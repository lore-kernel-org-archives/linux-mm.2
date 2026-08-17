Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16561C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1BE66B00FB; Mon, 17 Aug 2026 12:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF3CA6B00FF; Mon, 17 Aug 2026 12:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0AB06B0100; Mon, 17 Aug 2026 12:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B6A206B00FB
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:55:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5E75120814
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:55:45 +0000 (UTC)
X-FDA: 85111363050.29.6198037
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id EA3691C000D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:55:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gvWJIxWK;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786985744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xTXizeJAPN4W1pOJCZ7S/BTb0ROM//QBXQ2YriiHtoA=;
	b=NYvvMkDP8Osb30g3lvypv+CXvpEKHwfzLQSmbhzZ/kkRpzauuIAiqLuv2wf3fP2wN2HSZa
	/E8IQb9Ub0lyyEA+uuTOzpbmyrza0rHdImFIc+K/LT+kjSzUoWECVc9sPZWrgT+chuMk4k
	JSeVNS0nyms0TiH50yWmaFyv4P0Inrw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gvWJIxWK;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786985744;
	b=WxoqZaU5pxytKcMBnCKVQ6TN9KbGnwbEN9V5IcAud4CymerOBS4j7dQLdH7sqaUxTlqfQ/
	0j1xM0nB0lHGLzHySEmyVVkP7jAsuuLayfzSGa35WgGRu9/NG6ZiK3XFDmc/sEDyhst3zq
	Uud+OiIRsBMzZUlL8gI5oj3BBPMK56c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 19629416F4;
	Mon, 17 Aug 2026 16:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6711F000E9;
	Mon, 17 Aug 2026 16:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786985743;
	bh=xTXizeJAPN4W1pOJCZ7S/BTb0ROM//QBXQ2YriiHtoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gvWJIxWKGZQArcmY6QS85E/A1O8ewuvUfJKRBan0w4Gono2Yrk7XlDXvs96RWzejn
	 5VUHdR8hhSnoXJ9efGtKC2fgjVXBQJfyyykIJQltThPF/xDaRWzUpCPt7CSwVPmClA
	 svxI1wBISMLxjmObdB4asMKk0V71IRJD5sqIddfZoB57Ra2jFKhxtXGSHPmRzTDhdJ
	 J2gRRuJlPpIa7gTD/RuB31vhspwuiT4izxJNRLLUKNCVQ6zWb97umAv6karC9sLbW0
	 NvRHudMrg0pTjU3qwdDdpcKGrH4xyz+2K0Cchn8VFy9ASkJbLbi1jNA7ohe2xBTPCc
	 eNfeZ/EfkHgKA==
Date: Mon, 17 Aug 2026 17:55:23 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	shr@devkernel.io, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com
Subject: Re: [PATCH v2 2/2] mm/ksm: fix advisor_min_pages_to_scan description
Message-ID: <aoM8bbWNeuEbfCdy@lucifer>
References: <20260813031722.569983-1-tujinjiang@huawei.com>
 <20260813031722.569983-3-tujinjiang@huawei.com>
 <an2g39TIN9v87enG@lucifer>
 <b35d14b5-65d8-4b8e-8754-de35f03d4b2d@huawei.com>
 <an3RcQgDuhmcAb37@lucifer>
 <238c66fa-8144-4cad-b90c-e7992b14ee6f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <238c66fa-8144-4cad-b90c-e7992b14ee6f@huawei.com>
X-Stat-Signature: mma5jsebxmm14phbtaf5okpmztrjq8ry
X-Rspamd-Queue-Id: EA3691C000D
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786985743-860865
X-HE-Meta: U2FsdGVkX1/5k/a3m7GjllnFYJx5mFKvuLLgpLXuGMJIIZ0vPZhf1ToG8UQ/fMGusm9SLMD9QhdanZuGTTmv8LcWkQFRLzMbA7bRZiV62Jme9O18U9ZekdFeAom1ANWPhYLSOCGfhtE/Uh+T3d0O6Nsmo6CscrSP6i5l6nIEVL/Drkv7s/jHGP8HcLmHMgLdFgIb0rwCpvgeFO2rmDAlyVEiU4twbUr69g18kD4qKjCYAzT6UbPplrvAYnmV8BRMrYHEhn8JbgSReRex5tOQ7gPCNg7B09A68w/jGAENbry8QXcDR7VyyIALboW/AeMbebU7iHrzvy/cohin6Yh4x1wHXKTh5es4rmWSbmzgkyetInOeR0Eu0b4smNzyiUoOgJtu7LbOrXd3bSNTkr0OEdWHMh17TTBi1OYIgut18Rw9xo6FGL4C9uOWGk57vz95NaAsa9wgRCnCTGhgsGv7JjUcuaWK5E3PC/DIEydjgc+EVpyW6z0GOKeMcKAyO2mTgMBRsiAJ0iV/wuGVE6t5tz0fg2nUp4KHL6pdyLxMmhMGFnIWJRm7Si1szu+TK1igwZiDmOylDKotDaZQGH5EX4jOPiR3BIEp9ZoWCPQVNNqMrLmwxacZWk5j67/5tdi8KCMZ+kUyDOT9ZZ1ahKxVCYQcj5ycH/s6ddUT/DrLSkBDEMMVaEe5P2IxuDJZaoAs2bAghTaMuTOcsGXbYOTGdJzpiuite7vryfH8hi+5+g6whw4JdVT2nPZwYesWMrZmYv1HN5wLnXUlfWn+30MBznXa6Yj5Sm9l7dnjionn7SDkGKXanmq0yWOlWQfhIJ6rM5tsCVM07sySTo9bsd0fMv2wdRqRPHCdU9CRWTaBHLCM0naCVgyNZ0+tx2dQfP+lp1AWAsUN3EY3fIJzs3E6hwF0mJ0WYdlWTXjpUUcLJ4RtLiHXzrFjphFxJ3nhgorg4ZqJekx8rGetAIsbShT
 x018SzL0
 lyvNB+gHeyGzKuRZHRYBVaY6zwKnleybakAyCPiLhVgKN2revoELxCBxOQIpnGxQx3FuR3vDfBen+i5VXbpjddCxdBucQ1Bqv2d1E1VsX+qXNTLAlDyu5HaMkTCq84nsFxZ2xWpr/QF0JURDc58KRo9hSqljUnXCA3undGYETwf09mYsplwQg/IRcK5GRQkH//RpVD9pFt6cE8FPCJFPtP1uyfEDeZrCJumCE3/vmFY27WCiiucjGvPUYSQPQRTQC6Wmt6enSmrwlgV2SarzMnErBJj5nKE0bZFFi1rjTXAS/4oocfO76U8mn1923JeFs4pjo7hhvXW9H5T8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 10:54:52AM +0800, Jinjiang Tu wrote:
>
> 在 2026/8/13 22:32, Lorenzo Stoakes (ARM) 写道:
> > Please show me the common courtesy of responding to _all_ the review given,
> > not only the one point you want to respond to.
> >
> > I'm not happy with this patch, sorry, for the reasons stated that you chose
> > to ignore.
> >
> > On Thu, Aug 13, 2026 at 07:17:05PM +0800, Jinjiang Tu wrote:
> > > 在 2026/8/13 18:56, Lorenzo Stoakes (ARM) 写道:
> > > > On Thu, Aug 13, 2026 at 11:17:22AM +0800, Jinjiang Tu wrote:
> > > > > Both Documentation/admin-guide/mm/ksm.rst and the comment next to the
> > > > > variable definition in mm/ksm.c describe advisor_min_pages_to_scan as a
> > > > > lower limit of the pages_to_scan parameter, but that is not how the
> > > > > scan-time advisor actually uses it. commit 4e5fa4f5eff6 ("mm/ksm: add ksm
> > > > > advisor") only uses it to initialize ksm_thread_pages_to_scan when the
> > > > > scan-time advisor is enabled. This will mislead the users.
> > > > >
> > > > > The semantics of advisor_min_pages_to_scan was updated in the v2 patchset
> > > > > [1], but the documentation wasn't updated.
> > > > >
> > > > > Update the documentation and comment to match the semantics of
> > > > > advisor_min_pages_to_scan.
> > > > Umm, firstly if this were wrong you'd need to change the name of the variable
> > > > too instad of documenting it as something completely distinct.
> > > >
> > > > But secondly AFAICT the logic in scan_time_advisor() suggests that it truly does
> > > > act as a minimum bound as well as being the initial value for
> > > > ksm_thread_pages_to_scan.
> > > As the cover letter[1] said, 'The initial value and the max value for the pages_to_scan parameter can
> > > be limited with:', ksm_advisor_min_pages is used as the initial value, not the min value of pages_to_scan.
> > (Wrap your lines properly please, it's a common courtesy to learn how to
> > send mail according to community conventions.)
>
> Thanks for the reminder, I will follow this in the future.
>
> > One of the part of my review you ignored:
> >
> > 	But in any case, you are making a claim here yet have provided no
> > 	evidence for it. 'It is just the initial assignment' means nothing
> > 	- if the logic can then only increase it up to the maximum value
> > 	then it still acts as a minimum.
>
> ksm_thread_pages_to_scan is adjusted by scan_time_advisor() after a full
> scan finishes. ksm_thread_pages_to_scan could increase or decrease depend
> on the real scan time is longer or shorter than the target scan time.
> The min value of ksm_thread_pages_to_scan is only limited by
> KSM_ADVISOR_MIN_CPU, so ksm_thread_pages_to_scan could be smaller
> than ksm_advisor_min_pages_to_scan.

OK thanks :)

With this explanation put in the commit msg somewhere on respin then we should
be good.

Probably we want to rename the variable too but can save that for another change
since the attr is called min still (ugh).


--
Cheers, Lorenzo

