Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 801D8C44527
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664866B00D6; Mon, 20 Jul 2026 05:59:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6158A6B00D9; Mon, 20 Jul 2026 05:59:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 507856B00DB; Mon, 20 Jul 2026 05:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 20DAC6B00D6
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:59:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FECDA07C1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:59:15 +0000 (UTC)
X-FDA: 85008707070.04.1B0CC24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 75658C0003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:59:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Eme9M5Ig;
	spf=pass (imf22.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784541554;
	b=DukeLzlJR2285FbZ7phagiCOXgN35TtoNDOQS+EMjIygPnoEb6KDR2BCr+B6IgU1p6G+UJ
	OUAvoR1eGuODznRimkVLuuPL9yQV6VUG/U+G+knFqZCgCWv09JGrpU8E8RuYyyN/3sttLZ
	NnvG/ESLjMviyTGlFHE7Q6hPC6ux0vE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Eme9M5Ig;
	spf=pass (imf22.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784541554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kzrfRXAiX4Hu4kXoYmi1n5/DV4H+5STSh8/UbIu5Gxg=;
	b=Yt6JIAkHmMd366C6Q8jLiJY07rNhATF9yhIR4PrZi6veoh8zdJlg1NbI+zOm3qQ3Cmj3fY
	xflCB4l8xzA9LWYRP1ZVc6G3yvbDOSxreDkVmpkpYJ/NIAN/Dzo/c8uaD1XtbfLrfd2xR8
	yHFQ9yKOJ5OYso+SfNRv0DEosX70pr8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 99CFC4339A;
	Mon, 20 Jul 2026 09:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098F51F00A3A;
	Mon, 20 Jul 2026 09:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784541552;
	bh=kzrfRXAiX4Hu4kXoYmi1n5/DV4H+5STSh8/UbIu5Gxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Eme9M5IgGejVre/xameqf5XfphSy8SLE1OGq9UXSM2PvQxQlY68XQY5/VlVF850I1
	 HC8nvoVOlXpHITQyzN4K6t1moXiiPIy0d64x6Rlr1pEJfRAIy8FRJWuhhStZrDyEEz
	 svvr/niVKnQZ1Q/pl76w/WqHtH4tVESOMvezBzMs=
Date: Mon, 20 Jul 2026 11:59:03 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>, damon@lists.linux.dev, linux-mm@kvack.org,
	stable@vger.kernel.org, Yikai Zhao <yikai@z1k.dev>
Subject: Re: [PATCH] mm/damon/reclaim: fix typo in damon_reclaim_timer_fn()
Message-ID: <2026072041-rearview-unselect-3f92@gregkh>
References: <20260720094708.243937-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720094708.243937-1-aethernet65535@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 75658C0003
X-Stat-Signature: br74tiqd8yufa1kusun33fxm37s5rtje
X-HE-Tag: 1784541553-341834
X-HE-Meta: U2FsdGVkX1+BuqxRUthegqcTR2hNb2kzUaQhzmbrLLPbrik4I3QayrWduoTuQ9ophc3JogBU3OrSZf1q3miiQnHigLIS1PG6qzYyAmJ5kWcCHoOI4xxUX1NMnk0CvZTTi/dpTJVMSQawektb8at5Onm+LcYW0McvTZhpcn5+O2Ja7CrRC8D01YJgX3lWHz4Lo5ue3Vj9yHZxCwHU7ySgwc0JUODdJpTXf6O2R+6tTqSRp3B8ST5XPEo58fwE8MUE5b+FNfEntWfvYnOCUun/XdgG3JIk+3+KHabrXfURuDvE9oAgj12B/yokJKeFj/+jFritymk8afVUVwjCZBcdXm+5nib2vTUlgFmwFp0Qj24jbCOrE88gahOaG5ZykbfolNW+rD7sh2DCEzolPNfCrZmB6IILtIfffLAPMw678rWbX71iBI/4Pg7lSyWjfd9VdRSFnGgwhEu72KUWROiVeShsP778R1PRPghv0DvLlUK621WYF3uNKs6HxL/VRVBMvhntXhUk3hhJW7AFqsbKeQ+auoOMqAPSrZpm0tAetOEPhtn3SE+hsMSXF2TQF4n/+uUqMAP8DkXdZk0NivsuvV/Dgrhu8o72aJaWg3JID5JLEEYXKW7pDbJCzWUWPRNGWgrHR0QINfnbu/AfLSu/uyz989rO8zCRpBEa7mDC/XoltCVCnwvF/40525jInTESm7hvBkSO8MTnEYIqgg4BeJiXJms99GZVleZJkExIntnPU5hMKI/VhuU27T05yrUjvGfMFCiReZXubkcmBT9jI/XE+HnV11Usdj53w7g1v3EE9qathjo2H3EzP49FOhJ3BZI0R9kYP9BMummKKCekUtWkdwuhGn2bvfCO7Z/Mc7NSMvHoScsbMz/z971+5ZXPpPLKgKvMfrb8vbz0aFrU0Lm48HxRO86Ax0JdqEg6lxh4Q+7ngKEdSGqv310bCAxW/J2xCaKKxPRJ23Fn51n
 5yU/vUzi
 Eu/nDwcvXw1Pb874eSWEdZxdZ0vN6WkcMkSxH4CWB6TThEkLLCuOg7bsucJeG10h2a6rY4Wham8TiDHXSr9aaHCIsSfHgMtPwOpTeZozmhkrDmhjTLGGculWiz+2UbdidAEfK1A2l5l6dwWA7WIWWgl0o34FGuPqukP2VrOpx1Uz9z24tj1E7YuEL6+J0w14GojCR7MAgAdVGCoIrB/F14Zi9AIYP3F9moWv6WL3ULt1X257ppVepdLzzBbnbIqCe09sdjD3nnekG7u7uKmGH36zcrQhuHF8SrTToM/i5ffgb4xu16sdZkjp1fqUE/VUDfzfFsW0refqBI3HBBMMLZkQL/tB4eQBWhlCtLPt8tiMKcmj9aLhauVxt2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 05:47:08PM +0800, Liew Rui Yan wrote:
> Commit 2f54908fae211 ("mm/damon/reclaim: detect and use fresh enabled
> and kdamond_pid values") introduced a typo in damon_reclaim_timer_fn()
> where '!=' was used instead of '==' (unlike damon_lru_sort_timer_fn()).
> This caused damon_reclaim to return early during the delayed work,
> breaking early boot parameter configuration like
> 'damon_reclaim.enabled=Y'.
> 
> Fix this by changing '!=' to '=='.
> 
> Fixes: 2f54908fae21 ("mm/damon/reclaim: detect and use fresh enabled and kdamond_pid values")

Why is this a stable-only patch?  Did something go wrong with the
backport of this commit that is not in the upstream version?

thanks,

greg k-h

