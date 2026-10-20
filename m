Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C54D9606A327
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 23:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eYctBN9f
Received: by kanga.kvack.org (Postfix)
	id DA5066B0585; Tue, 20 Oct 2026 19:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57456B0586; Tue, 20 Oct 2026 19:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6CC06B0587; Tue, 20 Oct 2026 19:39:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2F216B0585
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:39:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8D9DA03E1
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:39:31 +0000 (UTC)
X-FDA: 85344623742.10.620CD79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D54BCC0003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:39:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eYctBN9f;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792539570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQl5Bg7oCQYmjxLGNDnneR1jcBNml9LlrBZzxMCdKcI=;
	b=pjv4C41jseaobePI73pYGhn7P34VIJ4GIrR9jQGACO6nLyhLGc3wsDr9LRqJNxhTw4Zwsx
	NIAcAqZW9kd1ntNOVutR0NXWlOL5X9rcOJJeV5Yqh3kgy66HupMI8ll5x4KIJa4PjR71Yw
	X40d0s7KwNXkfAlmehgEwDFtoH4HLSA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eYctBN9f;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792539570;
	b=Cl+Gndy0GRw9YGK1E0E9A4S2WA8iIYfqIcEj/EsiFyu+alIVNoBh0HyZ31C3YyQIRx89nZ
	YlJAUq5LKJb2PPpWE2D4U/dVmK6ChIaedykZBUtzgWY36+xVIrt9kwWv3+h4mHCj90cD+u
	d0oOVtTTsU/sFo65EkNegOqaoDeAmFQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ECB3F405EE;
	Tue, 20 Oct 2026 23:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD3A1F000CA;
	Tue, 20 Oct 2026 23:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792539568;
	bh=CQl5Bg7oCQYmjxLGNDnneR1jcBNml9LlrBZzxMCdKcI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eYctBN9fSCLuSF9iOPVSF2UquNS5UPYIWHSOW/axi+OBvkcHa+Br7hM177G0aM9+O
	 xtakLfV2hBs4pl0vBN60sMCp6kjgYZRB2G8j++3d7GU2URjtOzsvTLzOV16/LIcIly
	 MjwJGuLDyqrIReTD2PvSd+0BkCOU+QLLDkV0BIdc=
Date: Tue, 20 Oct 2026 16:39:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, Mark Brown
 <broonie@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>
Subject: Re: [linux-next:master] BUILD REGRESSION
 3d229ce89862b8e82d71a9e11d6f840ca272a6d6
Message-Id: <20261020163928.ce045b68bf2ff27ee10cf01d@linux-foundation.org>
In-Reply-To: <202610210624.L8z54cjt-lkp@intel.com>
References: <202610210624.L8z54cjt-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D54BCC0003
X-Stat-Signature: 81fz7pfas95yc3ue8656nb1deudecwts
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792539569-508013
X-HE-Meta: U2FsdGVkX1/0Gk1qfF0/3vO8Hx79VLHRj2mpdNSXSJRAcrzssrZC9RTRJzuWYRRYAZ6B3VZl4rfgiyH044S91PMJtX8kBsCehAAvlLmEL2HRHQzSmozfc3uPcW9LPzeHhF2Oy7mO4bz0vEsLwBTXr6NSNbHDgcW/llUDMceaU+i+ASAoXg9xeePaKM9S9D+JvkDLNOQxt2Roy6nP0g+TmG8tC5fahl6/qPr7txkCJ9aPWOfZovClYazbIh9wBcmvyIJnkvkWUN26az5ZmYOcUDSO5OAbIT0W0ZnVwmk7fdI0LL3TaTC6qiPnaxOoIPIjwWLBAefl7S5eIX0nk5RZCWK6Ulm+keybcbn+FGrpDo+UkmG1+buSxYFzmeJewyp0Odff6XXW9Vd3irpI1xbmAYRKFz+YCWGqYzhujDnr0YAuryghp8fYJS8yZWqXy9iwENtuAp9uu374B3ozYxjrm5z8mqQN3/NdHOkcQH2Bx70tgSK3gXHakSAOxMRhm1b2GxmFBBiSK0bvFU5jXtT9/IbKnQCUnBY0+cfb2qugamrW/y2YfsfMTs9OR8B9nWps+j5al4+4NhhNcWme9S+qCjD6xO2KZCp/Urx7sev8zKvKLVEJU9r36VHsTW3PoLLAX3pGq5wAwtufWp1g7lkYKuMhIXiwYU5MLyh+s0uQASISzF+YFIyNel9/aTYREOgB51W1larOAQriIWbD4zkbqqhGuoNKsreoVAvbXkk2OXBK8AlhJCJf3YSsEJ8VHqInkpOxUf4DKkinqAOs2GQ/zd257ddlNpvDX6uWi0rsy6cZ3rIgjxiS/SQP4WcShknMI4WQEqFaH55MfB9fTt6qAWmH2SoTN3VVOOmQlF/9nDyBRR+WwE1jbktd5waP60qq3C+XOvNUP/RujwKp5SBUqvyr+nfXppaK+9xe32MxIlvz+5jbRDfoynHyenJ2mzIa00gWQCoWsnrYz1Q716w
 IKjifKIV
 rHpqF/Jolb14Z4NyXDLpm8ZQG24ZA37e6L2mVGT6q45Yxryu/mP0PU86zPIrxw14ndDOqme1D2pffrYhJD1VGkb0PzzeKyUWoPHeqdvIRVghlIBW/Q+LTP2Vt/q1afJ+NDd98QezY/ESemEmuxNeLRfic7o1wEZ3NtCa8sqx4UQavkcUPKldZxUftWjQITYthW97Eg9RVJionelCsr67e7Q5RxSbTF2ZNZHIqxDgCAKWR53C/dUgB2fxZ/XDuvgjtEtuuUtdFiHRoHq5dLx8RX8b4tryqUYiDQRh/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 21 Oct 2026 06:38:27 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> branch HEAD: 3d229ce89862b8e82d71a9e11d6f840ca272a6d6  Add linux-next specific files for 20261019
> 
> Error/Warning (recently discovered and may have been fixed):
> 
>     https://lore.kernel.org/oe-kbuild-all/202610210232.uzFGXnjw-lkp@intel.com
>     https://lore.kernel.org/oe-kbuild-all/202610210332.DDqYQv5K-lkp@intel.com
> 
>     arch/arm64/kvm/vgic/vgic-irs-v5.c:1016:15: warning: variable 'addr' set but not used [-Wunused-but-set-variable=]
>     kernel/sched/ext/ext.c:5178:17: error: implicit declaration of function 'scx_reenq_wait_dispatching'; did you mean 'scx_wait_dispatching'? [-Wimplicit-function-declaration]

Thanks.

cc sched peeps.

hp2:/usr/src/linux-next> git grep -r scx_reenq_wait_dispatching . 
kernel/sched/ext/ext.c:         scx_reenq_wait_dispatching(p);
hp2:/usr/src/linux-next> 

yeah, that'll do it.  Probably already fixed.

> Unverified Error/Warning (likely false positive, kindly check if interested):
> 
>     fs/ext2/super.c:1040:7: warning: writing variable 's_mount_state' requires holding spinlock '_res->s_lock' exclusively [-Wthread-safety-precise]
>     fs/ext2/super.c:1138:8: warning: writing variable 's_rsv_window_root' requires holding spinlock '_res->s_rsv_window_lock' exclusively [-Wthread-safety-precise]

I doubt if anything else can see these things within ->fill_super(). 
What tool generated these warnings?


