Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C6FCA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 22:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8F256B008C; Sat,  3 Oct 2026 18:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41746B0092; Sat,  3 Oct 2026 18:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2EBC6B0093; Sat,  3 Oct 2026 18:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 965EA6B008C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 18:40:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23A8A1C3D74
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 22:40:06 +0000 (UTC)
X-FDA: 85282784412.02.881B18D
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5F83620002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 22:40:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NYeDBCXU;
	spf=pass (imf03.hostedemail.com: domain of thehajime@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791067204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/oIu14jUGCFAHwNtKrIHGbo5GeSCHJZDG7wMHq45NE=;
	b=kZOYhyu0nZvk89Jv1279TdDJe0UJZR0I5s73FkFSEy85wcXLwB5WrrwtuFIqXF1R09231j
	0/o9N6rkm7MUE+0T9ESU7ptG9MCNX9vXoaGScOOvcG8J79W/vV+uU/gtSXa3GgAgTkYbqI
	bOasZqlfvNOn2kQNLYSb1hWg+6R+spU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NYeDBCXU;
	spf=pass (imf03.hostedemail.com: domain of thehajime@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791067204;
	b=2mrF9vK1+3Gea+v4QLhMGBzQzgHdnceJmv2VMgrHjw86PHGqw0jFc5n+kWm0WM6uvkaPuE
	jmt3eRS18A2dwFUUEEBF6WSplTaOQDq52xRNY4IoAVquWS6vNWSAP9a12x5InLHOP3MbQL
	zZhiRscEZI5s7Bqe8Hrl3LGa7Tx02eM=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747ee1f9bso1970975ad.3
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 15:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791067203; x=1791672003; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=n/oIu14jUGCFAHwNtKrIHGbo5GeSCHJZDG7wMHq45NE=;
        b=NYeDBCXUhuFgwvb24hJCHNNpsc0bpRVEj2V4Gw+RbF4BWOLgCMIOAH4cjQhiyMglEn
         zKoB6AR+F183AR9re3SjFSHChFKtbXuvnZIQYP3Fzbbu0PelZSUyEqLFh87p9jli4uoR
         uje7/N8DGCldz9XfD8ICNfsANpSVfv5Juu50xGsSfe+OffdA7AjaBTI3mQVUPCNCI4Ql
         y+lADDP++L8JuIgWrDV9M1mUxOeM+V6zedXJQFC3xw/xQHdMV5HdqUf/WEOamHBOJwdb
         LGkNeBBtX88zqHynq/QQ8P/TYH+NiT+GtnfNa7wGcMbdNCWHrRlMn8rVB14sKUgtOUiA
         xhBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791067203; x=1791672003;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n/oIu14jUGCFAHwNtKrIHGbo5GeSCHJZDG7wMHq45NE=;
        b=IMBf5HHE1FNeEPBxEULaqWVDWxueOaj5n4aBBxM2RUj+rX91G5vRf6oqrpNrC6eR3W
         SJ57JmOhTqjaGhg9WoUnZIu7QvGYOCrUuGOLFBuq6WAzRr2wWuZMlhc8uQ+7FiDZ4mzL
         o4k7up00J75UQvzjG/AkbTM5bEAeSQsCqqraSt+2qpjWQScb5fykDsdU3RnvU82U4GKG
         kx+gBboo/4hveg3BlW8Up7ZKkDIsb/xxI1qu3DIokp+n3a9cmygxsFFdlsy2/Q5OfE71
         rJNILfipsgcSdDTrcBrLP9aQakgPjDAhIaRLdVTEg6Z3DmTjcrqSXBrIDNViIP2bBZTc
         pwtA==
X-Forwarded-Encrypted: i=1; AKwUvByPirNa0H8TnTB5qKH1Jr8MQNzRZ42BkWANY6OSyX5VgzUWeHdlRZnkKH7/pVoaZ4qZk8pQ+q3YWg==@kvack.org
X-Gm-Message-State: AFuF++nSpLsCUCrh13Vr7vZ78Xh8oPXNCjY7IUZoe61mjl+XcFC1DRcc
	2jDZbnDpJRIc0fIW3c+FHsp+CKo88K0kKmD6DiMum8mYP1jI4cpJxet4
X-Gm-Gg: AYBFou2MQsLjHSKXHXbnaf4aefBBLUQ6FfxmjgwfwX3lxPFteaiprmIgzM1EILZeqLO
	oPQpgcavMGI30q5AopZ8mY/TJtug+UdtZIwmiAGtj1cma6yOw1H0j93abPlitX8TPMR4FlXIATq
	dNHZjzqS9bSDfwp9bCCFCRgLBBJYbc+N6L2CcIR45MLrbHZWXWbqL2K7d0VqTq0volpg4Ccvjfh
	dUNxNjgDH/YwLELD/ztEgyiA6jRtFSRSF12pA54Uu2oMaYdaHFUyLGzgvhAsR+maJHvtM5TXKl9
	j+5V2qmY6mjyJEKKPCtvy+6YxC5q471PTM0NmIBTxRiim90vY/P9UQCPCSEaLT45uDZVlBwAnO/
	DZsPr9zKVkvKl4xa/qlEDadn0GBr8XwBpP2O4deZhSLOI4FZMF+MtfA+MvcF48AM7h4CO8m24wA
	gwcQpawjjsU56e6WP4hSDBxFu/ISukOA/sctWDQ1L7FjVbHuAOM17zLzAd/sjMpQtwwUBBZO/9Q
	GxtqmxSn1HptwBvQxApB+PWBhsEKvBDz/sYgcoFASjLBWL1Rx8Inn9NhEirCfw9EBwam6TEyoN2
	LK3zp3AgPaT+PpLNUXpg0vNVQXvMOUCrE98N8JO7Awc8GL4qQr7OvA0tMpHgUjnYv64GH0Q+vmo
	VMpyNnVB0O4w=
X-Received: by 2002:a17:902:d506:b0:2df:84e0:9034 with SMTP id d9443c01a7336-2e49a7cdc18mr57178595ad.7.1791067203022;
        Sat, 03 Oct 2026 15:40:03 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49f7339desm19297455ad.81.2026.10.03.15.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 15:40:02 -0700 (PDT)
Date: Sun, 04 Oct 2026 07:39:57 +0900
Message-ID: <m2qzi62yte.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: david@kernel.org
Cc: ljs@kernel.org,
	geert@linux-m68k.org,
	johannes@sipsolutions.net,
	linux-mm@kvack.org,
	liam@infradead.org,
	rbm@suse.com,
	akpm@linux-foundation.org,
	luto@amacapital.net,
	brendan.jackman@linux.dev,
	liuhangbin@gmail.com,
	corbet@lwn.net,
	kees@kernel.org,
	broonie@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	wad@chromium.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org,
	daniel@thingy.jp
Subject: Re: [PATCH v4 1/2] selftests: run tests on nommu architecture
In-Reply-To: <d6ee0a8f-e7a8-4fa7-88b8-62fb44bfc863@kernel.org>
References: <20260929235711.2287931-1-thehajime@gmail.com>
	<20260929235711.2287931-2-thehajime@gmail.com>
	<bda5eeaa-7868-4d4a-9026-9e99347afd7c@kernel.org>
	<ar4br2vW7yZGd3gt@gremlin>
	<94759bed23f00d2044005e36be6f72f297e092f0.camel@sipsolutions.net>
	<m2se2o3jyc.wl-thehajime@gmail.com>
	<a65f4431-d225-4535-b921-00319ceeb2a2@kernel.org>
	<ar9ldn036SgT-bq1@gremlin>
	<CAMuHMdUKcUxHZKhTEF1gwWrU1o8O6jt6N3r90V5hynrLFdwY0A@mail.gmail.com>
	<ar-bIzYDdlOKUqla@gremlin>
	<d6ee0a8f-e7a8-4fa7-88b8-62fb44bfc863@kernel.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5F83620002
X-Stat-Signature: bp918m8n8pdapapwwigik74uwdxk9g7m
X-Rspam-User: 
X-HE-Tag: 1791067204-793114
X-HE-Meta: U2FsdGVkX18iAwpjK4PeWFQudWrVsbX6QGYGs/rY1LVWfW/ifooyTfM+hXJWCwFAFpEpZikY5LJ9/HAziQUIvcKz2I2TQvswL5VbO7QZRTpZcvzaGe1WTJCDhVsW8qb4JiElJthD0ymagq3+o9LSK3dAvtF9ZxORG4oRN8bEYq48O2JHYdaL2co8betHwEfeD4tAYuG+8ErEe5+v1BoMl/LNPRUCm8Yfg38CLyszQmBFsQIAYxMssVkCMEH1L9xSLtmY2HlSOrUh0tfXwJ0Jh/+6qhpys4Kkri0BQcG+xlnCwqLxAMCj+RRuGRyLg39Af1f6Jy82JprKlQjS+xp5IPal2h16gmTSKncVlEsFchC235zWoFIxtkZQMmQ7zcw2TOKHkzAOR5XPWAaiw2nL1iBnVPBqrGlXkOHdzZ8x/PhJLMnOWfyAxG4hjI3vw69VNt7jIrwMoOx6wnM93J1UqGmNj+UWc+1FK9J7bXDiTBt+P+0hXz+rYb+/c7unpkj1XQJNjhEyzV8o5SiS9rZdoc2qMKcFDBWoTx3qUDufkMv/DqbMVT8ml7Ubtd5AsjNhJX09bp/irUkHKZ1l0CPiM7ach5yfbPxrGolnPbNzjsm9FoxVCz+zSlW/jMpRa6UvezGscW687d1zTA3OM2Tt1LvxQEi/7QrPeAbSFCWyHS1GVyDEnVRxZqF1GMwWqbG1W738AS15GmcAZTrLhqnWb6LgEUivlyJ6gE7nsTihvcCrzxoyCLLdYoSApVEMHy/Ks1epawU/70IH9G88WjL22u8tXV7Os6dgrHd7MmcJLWTRZDj2GaTkBjO4GzCFwb8OD0oevnaGGgooVtooWDMTF5ds6JRO47PE6o0PeTr0XYhe2CZgRRTXXtQ0n36mBS8MTNsLd174Qj9Ie2C6LQS1bOq56+oBuMS75vG+QhXwH4JgwUjZCdmd+0wncBA1kGUx+2gFQ+0llBYISNqfxSY
 cXniCbH/
 +CG4UeG6uHBOUw8VYEOJHB8tOvaH9aup9hrGoMIUMI5nTnvhXFFxhkvduGRpmFMoTMc7WG0vSofxtcmmTC1AF7tAasMWr1a8dtp9Es9nW153FClA9cVlcfk1rbKUaozyfsncSRPTWPBJlPYQ+Azxc59r1KncADehZVloWhbSCdiAnVw9yqWQsTZictVqHa4QJEiGJ2xihVH69xPzmSCvWuTESsPKe1aX9kvn57kxruKJwRewb+Y7sfdfgFQqkw1WNiBZghZkyCaBpx155Ji75xe3LqHQBib0pmX9s2IM8Ga0tKxcUZfLZDxaUUTScZUokJ0c6J9+tQjYut5vz9FoDsz244+OA1SD8IEIW3fUuLHDOmb6di66gMh0CBKQIO9oUtjh5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello,

On Fri, 02 Oct 2026 21:21:53 +0900,
David Hildenbrand (Arm) wrote:
> 
> On 10/2/26 13:53, Lorenzo Stoakes (ARM) wrote:
> > On Fri, Oct 02, 2026 at 01:38:31PM +0200, Geert Uytterhoeven wrote:
> > 
> >> On Fri, 2 Oct 2026 at 10:10, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > 
> >>> But fork() -> -EINVAL or -ENOSYS = nommu, then just have the child quit and
> >>> etc. should do it.
> >>
> >> fork() is not strictly an MMU-feature (you can implement fork on nommu
> >> if all memory accesses are done relative to a base address register),
> >> while I think mprotect() is an MMU-feature. Unless it can also be used
> >> to change the protection using the one or two BARs most MCU haves?
> >> Anything else that is a real MMU-feature? Non-identity mmap()?
> > 
> > Does any nommu arch implement fork() in linux?
> 
> I was about to say, that sounds a bit too theoretical for me. IIUC that is not
> implemented, and if someone would propose it we would likely just nak it.
> 
> In the unlikely event that this would see the light of day, we could always
> change our detection in the selftests.

thanks all for the inputs and review.

I will try to implement the detection with /proc/meminfo.

-- Hajime


