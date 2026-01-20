Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CFFBD2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 15:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C80DF6B043F; Tue, 20 Jan 2026 10:39:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03EE6B0440; Tue, 20 Jan 2026 10:39:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3A226B0441; Tue, 20 Jan 2026 10:39:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A238C6B043F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:39:46 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44EBEBA526
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 15:39:46 +0000 (UTC)
X-FDA: 84352752372.08.B93D669
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 46B8E180006
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 15:39:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SoJ3oqHR;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768923584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=urvg/XtaZlBbzcQcq8EiqAuOpFhl6Pv+GSbmq2DJdbA=;
	b=KomifudzNz7Id/UBIE5mpxxCpfunP7fcBn7LTCMTMQDD8cE0d25z8GjoR2Sd3kXRZ2lqh5
	1N8Rs/iM7ZMjO5cZ7Ytct0H1VQ73r71rhnrIdKoenAwnZjkQI9a++DUIHy3cyfFb59wYtp
	eX5Oo6AV7s5mXiLqxIcsaU5oklnl+Nc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768923584; a=rsa-sha256;
	cv=none;
	b=moO3haD5ensCb7YmjFndcRf5AS4ddBjVCr2sNp0fLiNp/XUaxbEOjF4zM+FhiAGNi4hiXP
	WVAxoJYLvLwR5YMPolISrJ1ojE/uGkxuCHmXgG2fo9r3+2SurxRk+eh39csMqgAMcEqT/6
	11LykhOzdEc1XIdxFba9cOTfvbZ+Wf8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SoJ3oqHR;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 20 Jan 2026 23:39:19 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768923582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=urvg/XtaZlBbzcQcq8EiqAuOpFhl6Pv+GSbmq2DJdbA=;
	b=SoJ3oqHRsMJsnydigqOEf56Ym9ympNUfN6BX0yHAWE/3VWNWtkvE0OtshjQfgYdtr5SwSe
	miqp6VjWjBsnqxZyrlUwbBi602tlImge9bMaNseMkf0S6oL8i9gb6aM5dbK0h+T+MbZ1sh
	j+oW7QrWCgKlfEkXNQ54Y8vQYS3RQs8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Eric Dumazet <edumazet@google.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev
Subject: Re: [PATCH] slab: replace cache_from_obj() with inline checks
Message-ID: <obrup5ejxuy42fpwmzczvo5ubyv62tocoqooqpxg3u5eq2i2sg@qpcialjznogf>
References: <20260120-b4-remove_cache_from_obj-v1-1-ace30c41eecf@suse.cz>
 <imazcyfzfkxofsnriyp5wa5v6yzszozljircucw2tgj6zex2ee@ytew6wy4kkh6>
 <8bd3c3e8-9865-4467-86d5-17d891f6f21b@suse.cz>
 <vyhpr6lq5rb6qgkshksg26a5ns5gd5ryqu46pqx2z5twy2gzlx@t4xaze2lhoen>
 <efd02f1f-b09b-4786-aa55-aa366f58442f@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efd02f1f-b09b-4786-aa55-aa366f58442f@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 46B8E180006
X-Rspam-User: 
X-Stat-Signature: 8fwezrtxrkka4ogfc5e6674becbcrw3f
X-HE-Tag: 1768923584-654422
X-HE-Meta: U2FsdGVkX1+YLhIkEER0GX4Zhnyf8IyZ4TTT0yQJzk456cVs53Pw6cXf/pn1w/m5VrMGUjmLkT/Y0OJlKjKAEXMJJHko3rDT24N0rRBDSDw0X6ubcBt6US+d1aZy/sdIyhyEdGqcSELXQoVdQcbLRwZsatIIA/wV/0PdR39bCKTHEHepAiTDBhRnB1uEopLnUgogkBnX7oXM/N+WchR5IGWV4plc/eFSGieaWHf0rzoF0WSNcL4k5KbkWLD/7FfLy0Ov++pDu/MTFoRb9Oj46eoTn55Lesc0rQ6psHdD5bWvNfRdegeis8QqF0NcsXlUaI3MmF56/EwU81tqgJYYf/ERwIa6YGMhskVpTeHQdaU6oVovmgc/GqaHYIuZIwoKVvg0feE1i9+089c34vM8PxOAO65exw3HzzMKg2KTbNTdSY5NJ5WJq4W33z9e1bG9xHkZaPn15XFtn4EGkTY7QkuDDQtOyKht99o8/pn1CAW3LZr1gqgM62u6jJye3LDtbujUm3D/ucdw8TmMUevg7l3AlgS6rHELb9l1OuOhsUCz8+SEy2qysot26+9xXDTD1FGtYG8FEyYZCAe7wn+CcpQUNz6USbCrWVmGDgTgqGpMLtCxSdLCe05YqZDclXw0wZ45uSZeMxj/3BPUZjtjc07YyNbHD7JwauyaNyG+jZ+9nTI8nLs9qWb4HbBCVlmUq5OamvMTAqNKFvKcleqoQUJfkNByLuD9q6ocahvjLnUHm++q5HMVhrYXkCcOV0WphsOFncuDUYuQvLqjzMfRMo7OQ89Xl9/AUPOpNJILVW7VYR8oWNDv8uXYCGKhgM4GwKmb4rOqwONZW6d36WRlx+H48kmvlTu/yY43Ita/aMLkVQI/sSUcWgoTkgbLPWIXmpWGtsAwzWIynITi/sFyErceQk+F3YWKNQ0+SSONxoCqmf8Z1Dj4IAeYA231Di1MUhF3rFFKejVb33kZoVd
 Ij6na2mn
 I2NE5oyPclXRT2RaBAa0RRF+Bg4MJH/u4bTNf0Et0GTQzzXaXoMAPMDz1Of9VpFFEkNl+OCFbWE4gKB+qgbE4ZqZlWRv65ZZl1eCyMgOqwpNXjRBl8Ie4oZvDhAiJitPQj6WR66po/+p2UnNcNuAkYDUhIQcsducPih5iWnApM2IEGlzVoI7GPavV6GdPZnrwgCLhz7AJl5IlXS9RUEyFN2W1gK2OqN46oDKfOzhE6nwe0I/I1nxfkLPTEngUWtgJMA73
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 03:01:23PM +0100, Vlastimil Babka wrote:
> On 1/20/26 14:56, Hao Li wrote:
> > On Tue, Jan 20, 2026 at 01:55:09PM +0100, Vlastimil Babka wrote:
> >> On 1/20/26 12:57, Hao Li wrote:
> >> 
> >> >> @@ -6774,11 +6770,21 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
> >> >>   */
> >> >>  void kmem_cache_free(struct kmem_cache *s, void *x)
> >> >>  {
> >> >> -	s = cache_from_obj(s, x);
> >> >> -	if (!s)
> >> >> -		return;
> >> >> +	struct slab *slab;
> >> >> +
> >> >> +	slab = virt_to_slab(x);
> >> >> +
> >> >> +	if (IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) ||
> >> >> +	    kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS)) {
> >> >> +
> >> >> +		if (unlikely(!slab || (slab->slab_cache != s))) {
> >> >> +			warn_free_bad_obj(s, x);
> >> > 
> >> > Just to make sure I'm understanding correctly, are we intentionally not
> >> > releasing the object x in this case? Thanks.
> >> 
> >> Yes, it means something went wrong so it's better not to do anything.
> > 
> > Got it, that makes sense - thanks!
> > 
> >> That was true before this patch as well.
> > 
> > I'm still not entirely sure I follow. I read the original code, and it seems
> > like it retrieved the real cache from the object and released the object into
> > that correct cache. Did I misunderstand something?
> 
> You're right, I misread it as returning NULL, but that was only on
> virt_to_slab() failure. So that's a change, but I believe a proper one.

Yes, I agree - the current handling looks good to me.

> But I'll mention it in the changelog and the comment. Thanks!

Sounds great, thanks for taking care of that.

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

