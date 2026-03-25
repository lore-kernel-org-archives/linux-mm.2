Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F687109C059
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 18:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18256B0005; Wed, 25 Mar 2026 14:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9206B0089; Wed, 25 Mar 2026 14:53:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DE606B008A; Wed, 25 Mar 2026 14:53:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7696B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:53:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CD5F160A74
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:53:47 +0000 (UTC)
X-FDA: 84585484494.26.C011716
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5676D1A0012
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:53:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774464825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0kxYPDeQ9t59Gb5aLuTV5ITnf7SaLGlB2qrZ6LLeD7E=;
	b=pb+QRk1s2T2/NdbiSMioTcOG+Pj08rchGY2WDDN31ygJzn01HjNNwVO1m0frxOJk4/2Fho
	aL+Y6cz3MpKdhiHvTW0TcQhwxN3o/hDx+1XrRn+tTn5Ub6x/d6Z5b9ktjaUOV8fBcXzJaw
	VG6D4x4Ezs4dISEc6hgPoTH/CslONwg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774464825; a=rsa-sha256;
	cv=none;
	b=LNjPUCzwrmYNF4JimdDb8lHubOaEAAerTUzKqrq59t3oeazSHYcoMPQ2S8W6vXeH8LL2Jg
	JglcwEiHLP6ODgagZewTfVXndOqNFGK9riHpgt3Ce+spdeqbi/GaJ1UwHQ+h9SSIunVxdE
	OihkPK6z7YeQCjDxWoRQsoageoOorsY=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 26 Mar 2026 03:53:41 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 26 Mar 2026 03:53:41 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, Liam.Howlett@oracle.com,
	akpm@linux-foundation.org, apopple@nvidia.com,
	axelrasmussen@google.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com,
	cgroups@vger.kernel.org, chengming.zhou@linux.dev,
	chrisl@kernel.org, corbet@lwn.net, david@kernel.org,
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org,
	hughd@google.com, jannh@google.com, joshua.hahnjy@gmail.com,
	lance.yang@linux.dev, lenb@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev,
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com,
	peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org,
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org,
	ryan.roberts@arm.com, shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com, surenb@google.com, tglx@kernel.org,
	vbabka@suse.cz, weixugc@google.com, ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev, yuanchu@google.com,
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com,
	riel@surriel.com
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
Message-ID: <acQvNRLpHwnHt7i+@yjaykim-PowerEdge-T330>
References: <20260320192735.748051-1-nphamcs@gmail.com>
 <CAMgjq7AiUr_Ntj51qoqvV+=XbEATjr7S4MH+rgD32T5pHfF7mg@mail.gmail.com>
 <CAKEwX=PBjMVfMvKkNfqbgiw7o10NFyZBSB62ODzsqogv-WDYKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=PBjMVfMvKkNfqbgiw7o10NFyZBSB62ODzsqogv-WDYKQ@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: sirmfcni5gh5p3464z1n6mzfnnyatngf
X-Rspamd-Queue-Id: 5676D1A0012
X-Rspamd-Server: rspam09
X-HE-Tag: 1774464824-330301
X-HE-Meta: U2FsdGVkX1/DPHBI5UEPMiDQk0t0VElZpmIXweRs5aSVUxOkLCt35svADSJzInw3nbl70o+GwrC9icAmuBaqxIIItv1/E0d2zrBqg0UcvjU8jqCDtVqKlQlqrwnkf2gVNYttmz7o0Ivs4xbe2b/Wx+4MgmauDrrZiBOkp4D2HXvSypQEynBdBWVKfGjJxytZPwTx7L5VTghky6jOSQ4PE6LpiLi2ZpPYE4cYQTiHDSh7H+nOm/TUXos0PQRfjVlKj609JibTPUmTvESDGLuY8ddNxv4+6C7HkRkyuF3NvH6veZTAcrZ/yLsw7Z92l9nUHiP2Wd/DqIuIPh8QJ6Xkds9E7IWTrcJUR+HLSJAbEAZ/6c0FU0164y1xpKMKBc7KNI0eDnTsp4QTh3DKKnCJeGAHBjN0T2sux3JdY9Ge8LAdHWFrtJZfAJ7mL+kjlfJ3Yon2ndm62cx1lcB5YsW+eDcr6VgqTeyy+RIQv/Yw+/Ik5jEd8VcYRhDl/qfun8v/r5vg/m2JYW18bvznlimSNVVTjF9k1+6AkEbyju2EAO4p5tL1R3pEmQUJtzsTNkI57yaPInTDxXlogqs5QBVSZiF5S+u6u4RKnS6Cqc96e/1ykikyx/9wlUJJQL2lyBFdwdvFIZaoS5oKSsaSL0Ml4dQWh0aZ3QOqLXE6cHerxHL/WWmThimzOd6i+dLOs7jyMU1N1YIxMYtgp5UfWFAStOUk+af55a4P6alt039EBnuPFSmXUD7JdMesJuU65vWIIVtFOR+UciYdRkQioyHX1InXnnc20yrfo4LQR0STAu6RUBv2VtadObxOJ7OsC3tD0Tew9eJGCbf6pcFe2sTiKcmY62NatWg+Ty93VcqABo643qPeqFJHbqZPdier1eha1vBF0HeZBp6y4ywuTuy9E1JNjuwlpowmzA7RkvyfqeofRf9FjO6VdVoIwMsN0+2t/61x+kRUgrEE0ZtWeF2
 Srzx2MMc
 2RPxtmTVP6iEyxvedEtrxXtB5Jfd2QtUHGkX/rJ5zlP2G0CE+wg2DpKiEYseR7yjL4q+7/r8mLq4tlEI1kEOkIN/Z4xm9C5+j3XcyfV86twOs3eVg+k4V9s+M3H3/6+72L00HUgbJ9keqaXyeQNOzU1HkUFduHvkVwmxG/q8ChiqWWwCNEbV+jgoSiAw1ikiYJ7nM3yj2dedy8rIAOW+sHTXzgDxxTXvcdSs5ylwFxVlFo3jZZDawv4tymBmMdCxMUE/aTgfQ9pLRjmslaf91EdP3WRsQy20G+zk2qZ9k3mqFzovBGLu/NolCFvVVNW9moIov+KRdgyvkqyMvUzyZtZJtkDnBZAuwa7m1vChAxc8abUySPtz8YSBw5xtVd6kSrx1BipTQOO4jnpdm52Cgi9RBfGe63mPzChz2IaVRf3p/NIhXr+G3CdqP9V5ohJTgjKa8K7+Wuukp+h/hVUFUWu69gw3MkYmqEgUf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 11:32:57AM -0400, Nhat Pham wrote:

> Interesting. Normally "lots of zero-filled page" is a very beneficial
> case for vswap. You don't need a swapfile, or any zram/zswap metadata
> overhead - it's a native swap backend. If production workload has this
> many zero-filled pages, I think the numbers of vswap would be much
> less alarming - perhaps even matching memory overhead because you
> don't need to maintain a zram entry metadata (it's at least 2 words
> per zram entry right?), while there's no reverse map overhead induced
> (so it's 24 bytes on both side), and no need to do zram-side locking
> :)
> 
> So I was surprised to see that it's not working out very well here. I
> checked the implementation of memhog - let me know if this is wrong
> place to look:
> 
> https://man7.org/linux/man-pages/man8/memhog.8.html
> https://github.com/numactl/numactl/blob/master/memhog.c#L52
> 
> I think this is what happened here: memhog was populating the memory
> 0xff, which triggers the full overhead of a swapfile-backed swap entry
> because even though it's "same-filled" it's not zero-filled! I was
> following Usama's observation - "less than 1% of the same-filled pages
> were non-zero" - and so I only handled the zero-filled case here:
> 
> https://lore.kernel.org/all/20240530102126.357438-1-usamaarif642@gmail.com/
> 
> This sounds a bit artificial IMHO - as Usama pointed out above, I
> think most samefilled pages are zero pages, in real production
> workloads. However, if you think there are real use cases with a lot
> of non-zero samefilled pages, please let me know I can fix this real
> quick. We can support this in vswap with zero extra metadata overhead
> - change the VSWAP_ZERO swap entry type to VSWAP_SAME_FILLED, then use
> the backend field to store that value. I can send you a patch if
> you're interested.

This brings back memories -- I'm pretty sure we talked about
exactly this at LPC. Our custom swap device already handles both
zero-filled and same-filled pages on its own, so what we really
wanted was a way to tell the swap layer "just skip the detection
and let it through."
 
I looked at two approaches back then but never submitted either:
 
  - A per-swap_info flag to opt out of zero/same-filled handling.
    But this felt wrong from vswap's perspective -- if even one
    device opts out of the zeromap, the model gets messy.
 
  - Revisiting Usama's patch 2 approach.
    Sounded good in theory, but as you said,
    it's not as simple to verify in practice. And it is more clean design
    swapout time zero check as I see. So,  I gave up on it.
 
Seeing this come up again is actually kind of nice :)
 
One thought -- maybe a compile-time CONFIG or a boot param to
control the scope? e.g. zero-only, same-filled, or disabled.
That way vendors like us just turn it off, and setups like
Kairui's can opt into broader detection. Just an idea though --
open to other approaches if you have something in mind.
 
Thanks,
Youngjun Park

