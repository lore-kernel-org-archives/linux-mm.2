Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74DB4CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 04:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0965B6B0088; Thu,  1 Oct 2026 00:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F586B008A; Thu,  1 Oct 2026 00:42:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56126B008C; Thu,  1 Oct 2026 00:42:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3B196B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:42:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A992A6811
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:42:20 +0000 (UTC)
X-FDA: 85272810840.24.B15F0C2
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf17.hostedemail.com (Postfix) with ESMTP id 631D240009
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:42:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AS2yfKoY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790829738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a1VMb1gdkAzPRn13HLN7Aa+0FwFU3dz+Af4Wv7wExRg=;
	b=QB675HMd40jPCkamtcJm1ggeXbf+1tIDtajd7v6Rm1N0Zj3tbH8rvmN0UQtD8XyTgSwJoi
	L/yy6XOX+ZRoy/WwTylYgSWKzGkwnf2gzyQs0NvLvt9w76KKgI12aBDf2VX/dxVlc7ZKbn
	u9fkQ8JHlJ14F15Dm3RS9/+c+saZHWk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AS2yfKoY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790829738;
	b=f49Qerd28yey+ZpBMJhR3EeQn4iYdlmd41VT4X22RSI6IMe/YTL7er6Pwc3/jDlpuD7t9B
	bkQTxmh5X+g9T/OD5eYebVw8JlpOKGdp8nOENSvCuYSMuB7Zsc9kseYg+32Mv49c6CWo52
	OfFdJ/d/9izVXShO3I/xd50HvljFAXQ=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ff9642c57so11796415e9.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 21:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790829737; x=1791434537; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a1VMb1gdkAzPRn13HLN7Aa+0FwFU3dz+Af4Wv7wExRg=;
        b=AS2yfKoYurvSHiGqgCfimVfuQ6W8euGrBxBxi5Ds1BzOuYkbQnuF463J/1vUxS7+JE
         GDR85hnbFYkgVGSb8Gnai7CDFO1GWEWfi4yIb3HPo+Hl2XkP9602Rb7DGsbG71KijNU/
         AXsetglEsjVLY5nBn7WUqQNlVBL1CfHOmJDWRUMi1pxcNAGU0BpVy62KNvEdX2VyqoUt
         ct+UFzWeucm5r9oi+n6e/TW720Cvtcd5BamkHfkAuVY9Ktm+Sqg6BO+FSnd1RbRhRIb7
         SsIaMth/AxePPoPg2Mg4UrOnIWHtpwTEOqG5hH84ZZEzG/eMg4dmQNA7dl6yhXp091jB
         oRfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790829737; x=1791434537;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a1VMb1gdkAzPRn13HLN7Aa+0FwFU3dz+Af4Wv7wExRg=;
        b=VhQxuN04ZPMFfaRvfvLlfZ5ia2XZ4wrxI9LYZLXWhhOBEhpPeegsu7xsckDHmhaYek
         RMKB3sXYTNayrAwaQ5CMOwxkl4XZNtxyoG7h8NLZJwtgLs6UWZVz3pTD+h+IDb3IKcwY
         jhCNEHALW5TBuK39pBSMczknlkb/7nQMLECrmq+7SRt+34SIpDYVoemlFse+cebXWXKk
         9xFSPDY4k2gJXwLqzfPrwo9XHpIvENgXh+9noIz1nx2wSiVkzDXQUVoQjmruuE0jitJP
         r4UtJuRFVcbrORmjxkE9+kjLwSMBTyUpFnWcV2/t9PS0wCLnDajHrKNnkmBbTblEEkm0
         t78g==
X-Forwarded-Encrypted: i=1; AKwUvByrIN4f7o7bzLzISvJ8R+3e4fongiLrNg/9bDTaEd2774tjV/JqWTs9tjAkwxC1ycvwV+EE4GIniA==@kvack.org
X-Gm-Message-State: AFuF++lY7nDBI/b6Q+wUwrbjaBf8IUghg6++MFgt7fBk2ccNtJctsGBm
	NMvhPGmyzSlXJVNUbwionnHZ0+GBdew97WX0IGvjonKiSPJMz2MMHuAZ
X-Gm-Gg: AYBFou3zdOF3mwh41pLoi5gp/7n5roCpuJjVm5O/a1YFI++3PwJpkm+F+G/YdXG0YpT
	IgEXaNoKtLDu4QBricqlwwXlyotnkGVutYmUlAyhqYT4zWVY0+4lmMfcI0rXXL7iWFAmS1mJJG/
	yR2RD+dQzMpe1Bd5T80qhdzGGJqBtYi7VAhoW05EAKrMoH0Hxrua9lmAdhh0UWtJAXT2+rymvgT
	UkMjIkdSNncHE7agq+2RTpfzlLJyhReVv3h/tfZdEPAnF4ciqfh+zGFkVweeUyL7y6nEw9XN4xK
	O9Or6AbrKPn0jjxF/vyJlS5cARVD9azU2YNkzUHv7Pv4NUnKWMOdl/8mQl3C5ohIq9iwWRNSdWX
	8f5Ev/IxVqZ4/G8Yfl3fr1C6mIPVVC5GK0hFsawVNj1N0feB/JpU0E+CzW2qSt3ZQFBVNci+jU/
	UECIfqsbNzM8PyiGg8TGAEGc/qB6JNB6/cVbZDttbcAWVynUlSTA5JlWf+42tAv/nuI0wL+zbSQ
	gikY3dVLTMZGWIjoWEqSDqw/RI3lg0oc8z1aXaz+NBuWOQA4WGTL1eXb9RYS2e8GN38PIz3ICI0
	Qb0nO9kcPSyUrSTuxrOvxisG6FhFFYL+PqLYV/G586+UjKRA2yL4M6lKixSD1vI=
X-Received: by 2002:a7b:ca5a:0:b0:49f:fbad:29ae with SMTP id 5b1f17b1804b1-4a01eb19ffdmr17039525e9.17.1790829736713;
        Wed, 30 Sep 2026 21:42:16 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-095-117-056-101.95.117.pool.telefonica.de. [95.117.56.101])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f6c5059sm32619515e9.0.2026.09.30.21.42.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 21:42:16 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Alexei Starovoitov <ast@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH 0/2] mm: preserve nolock context through memcg cleanup
Date: Thu,  1 Oct 2026 06:40:54 +0200
Message-Id: <20261001044056.75079-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 631D240009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: k7ypk4e9f994xqpi4k9uz7xuoiis7k7p
X-HE-Tag: 1790829738-703383
X-HE-Meta: U2FsdGVkX18YvRDmwfOFzC1z1emo6gCjYEBOpQxjWGlMz12KBtSE1U1TswXk0C+jz2Y5NKkxPK1LLs2ULsJS7si+j9OH/IIhOBAyy0DRT2+30P4c6D40EFm4D5sTC70boJdL+uTPW/hWDiO3+gCM/mDgHeQF3LeHYGASLzZ2pfTJpGJ3l71p2a8zs09lDxdAs11E3dPsBRwiEcXS0UWFbzmi3mZMbrTRcwt3TNHjPUZGnKR2OzwmPW43or8TdmNOgF1Pm5fN7csBzKvoeUzmOvpj7ACsmm3Vi/6WLo+WqRbDPjizYVhG6q0AKUvAMRJW9pQuD62+MyFDXc5z31x/B3wr07SKVAFzmUsA6mq7PXHIiysbdBC/sCxDDrSIlE+yTnNaBNf37oi5RRhMINHT0fmCXUNkIubIyqvMm9qJSevbNvPovYVqieVuCd1n5WsFZFdgl//1JfFKJ1hnjf+3dgMqFQ1PJBNEIAb4bohHaGkJxctsJZr2G8YRIdW4dXNm0m0UEnwjhKRsQ2tSQKg86VUdo+bcebLxYIxqQsGyNX1+sB3pacwxPatm7qsAsnM7MqiOkauvCLb3NtWkQ4IaY5Es58XWzT2ljMBowdnUXPIYQ6a34ktdUn8zxqy1DamwVD67FUlq2g2Gcu1GMx63D/c7CzRLiQbAz5dndVrIOoBt8IxdmABn8+X8RJFmoal6WgNpGD/OTUeOqQk1ZIryGfYb3dyTvhhE5L5Ge6xRk7kmS4l9/cf57movpyVfJxyCBr6BtM/jz53UrsC6Z1F8hiEl14nb/cV+c2N/WdQ8BVBE6+VrVoMkJvmUi0FkgP0J5zNMxdyyOfzQ2+et43LriqDWAeKPw1d1DFZE54m1z8elzLM2H5TZeUpyO3lOIQAzLOi5Ps6NtQyN3i8Jx8wjPF27GikxC9hmjZRxlUTsL9owQdB/c7ah5ahLxMv/STd1rg5/gMRmqOEYUL4RqfM
 91CQ46e/
 tXr8kaDgIo4gk255O973nimnlAxws7i3uiNsK4llv9m6iSENK+Em0s3j39JxLvi5q1iAiE5Wq6dhPmioTKb5WQPDho/0Vdc7hY4xey+TGupnJ79IjcaAo8iErA2NBJf+wKsUTOygSr/zfXIPCVluM3drtnjjvllxDFaDeRD//YGAcLFQwGKSOwrG82LvYCWA1fQJEzdmJ0szPXAN5twd8HYjUgAMWfncp4i3y+nLxhb0xEltyaE1qi5KWK7c6Q8Scce7LL639XRzL53/29TGcsbwUiWqu4k6at1FOs9N3rC7JZL0corBoaeWG/2wRS4Qel6kfHTERkyhK0cT4I24YjM2mwmMCPSC19cwK3p28JgJF6Qug4Mr8j1DZgnLBMS4wIZaIokw5lhFAOcJ7G+PK1Pl1FH2rQ7EP4GWKvPkE6Nqicbr7V1vIrdcQyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The no-lock allocation and free APIs can still enter regular locking
through two memcg cleanup paths.

Patch 1 handles rollback after a post-allocation charge failure. If
kmalloc_nolock() obtains an object but its memcg charge fails,
memcg_slab_post_alloc_hook() frees the object through the regular SLUB
path. Preserve the selected allocation mode by using kfree_nolock()
when the allocation flags disallow spinning.

Patch 2 handles the final reference to a killed object cgroup.
kfree_nolock() and free_pages_nolock() can drop that reference in the
caller's context, after which obj_cgroup_release() takes regular locks.
Queue the objcg on a lockless list and finish its teardown from normal
irq_work. On PREEMPT_RT that work runs in irq_workd task context.

These paths were found while discussing the following RFC and during
the subsequent investigation of no-lock allocation and free paths:

https://lore.kernel.org/r/20260919171443.90512-1-kmehltretter@gmail.com

Based on 40288c9206c17. Each patch's forced cleanup test passed on
x86-64 release and lockdep PREEMPT_RT QEMU, arm64 and ARM32 SMP QEMU,
and Pi 400 hardware. The objcg test accounted for all 256 queued and
deferred releases. The series also passed non-RT builds and arena tests.

Karl Mehltretter (2):
  mm/slub: preserve no-lock freeing after memcg charge failure
  mm/memcontrol: defer final objcg release from no-lock frees

 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 29 ++++++++++++++++++++++++++---
 mm/slub.c                  |  5 ++++-
 3 files changed, 31 insertions(+), 4 deletions(-)


base-commit: 40288c9206c17eb66a603262e06a58d300d0f279
-- 
2.53.0

