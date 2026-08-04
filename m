Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E07A5C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 00:39:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5E626B008A; Mon,  3 Aug 2026 20:39:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0FAC6B0092; Mon,  3 Aug 2026 20:39:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25046B0093; Mon,  3 Aug 2026 20:39:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E8196B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 20:39:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E12AF120714
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:39:39 +0000 (UTC)
X-FDA: 85061728878.19.20C3CAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B62A1180008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:39:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DlvSKUc+;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785803978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBixw/d6HA9fsIHjVOC8TKnF1tclRjfp4GIg/F08u3A=;
	b=hoI8pTYQWoNC0StTHnq3zEbnuS1Z6+8Q+EqHDRSiQNtmAG/4ye2s0e+pkz8GxbYs+xfLlq
	rXOEspqgM9oDwIM5AKC5yhHis1ysM7xXR3gpTguG9lPJPM8j0cFVGlB4N4/KPZQv+3SrBi
	aLOUxMosQaYRoKJxszPfMLg7D/6E56A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DlvSKUc+;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785803978;
	b=5OWt4xEMKreFx0X+xLqz/lJyUd1He+7083gy5qyKBZg54xB4JZeKoLpbN6K1dXvP2uZMan
	pX6OWjRtOiCHX81bxdQL13b7x7Z987eVwW7gG9rkobVZPBA029gYS14tCv2QXrzBwOU5i/
	1K5kmVdO2QbHRhmIJFEYSKiP6pe9CME=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ABCCB60A59;
	Tue,  4 Aug 2026 00:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC361F000E9;
	Tue,  4 Aug 2026 00:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785803976;
	bh=NBixw/d6HA9fsIHjVOC8TKnF1tclRjfp4GIg/F08u3A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DlvSKUc+Vsrtfye61sNEFPlB3usZCSqALGCQPb1/D5dfxdteOTivfEVFbplTGk0t0
	 iqeTdvPezt0pEJSH4KqWR97fClBrd6Ql8qdLIrcK4YWVynH+7SgUczzbEpfsMKbmQA
	 zDHJrksbcl7IG1jhy9gzimA7ob9Gz1MZ/8I3RwzA=
Date: Mon, 3 Aug 2026 17:39:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Artem Lytkin <iprintercanon@gmail.com>, linux-mm@kvack.org,
 willy@infradead.org, shivamkalra98@zohomail.in,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/vmalloc: make vm_struct.nr_pages an unsigned long
Message-Id: <20260803173935.132156ba2b86293ffecb0e8f@linux-foundation.org>
In-Reply-To: <am9numIMZZ4s7UMl@milan>
References: <20260730130923.9e71be5f477ee3db333cf0f8@linux-foundation.org>
	<20260801114915.115224-1-iprintercanon@gmail.com>
	<20260801115202.ccba41ddac9f7a4f6fb1ca9f@linux-foundation.org>
	<am9numIMZZ4s7UMl@milan>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 48h795omngr88szbtw3max8swshpidsy
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B62A1180008
X-HE-Tag: 1785803977-203295
X-HE-Meta: U2FsdGVkX18uaOtyZmUE2WM6OeRQp5B0Atj5kAsyy41VmWlyttwnCSJXyqnHxYr7t37LIWCzhzFOHP+bUIYtzmwsNwZAeVlkrx+yfw4ddQVn3ZCaolOmKoKg5QXjEMz3vB30Ox0xlvfboYy+8MgoZymzD1nIiplvAjn2I42CcaA5x6QamXTe1KM5vYdaXrjV86XgnTpdqWyjb3e8s5OeUeJ3xZ5roufjc8bTZjixXfExnpIPaZzYVXbde0ggE+pdhP8bRiSRvDXkIvyIrqvDqjrzosG1j5IPfQ4PiyRAq8LOkcyXBrk9Sxv4fbhqSgcxwQLtnEJSbNqiyFry1YQGoq/k5tSK9NfBiyCng8tejmDzSdu7uj3eMTpakTeWA+HsDI66KCey+XpfNcq/bipb1w6am6LoOORyBE5UlBnwnHSIRkrq1mJ/AlGYBDiBUaP5aKbrL7vx7WH/kgbxIfpyXLUt+qJHya3QVutRiQDY4wMltnR5SH0EnATjO/FerhXslM1L7Wem4rwauCgftekQqTWyKSSgeZnxtm0/Xy0FF4DZB13VDgGMVm/GZ4oxGHfgqglmGragZRVpWu230Vyc9OMH7GkR/WKsGqKr6DMCnrmkeHTW1HTvxGK7K67QU5qn6mTQ2ZUj7Epr+dfJUG3l5ZWayAdXwGnlt15XIVFsL092s7xcutT6t4V+tr1DyxIhN3Px7xHGQ40XIujLVEfvzV7xYVWTaeDBCfnvfEKdqCCuk+okYhG0+Q3+9mytvKseRGJpuNKILXy0iNfI+59fw6Ue5E+29TihV/ey8gu8nEKmDx7+7mQ1SNjcMd5lOpFeT+0Y5YAIfpqZm42g9Vp56LmYiqihVFFrSePJOwNTnv8ACRe0smTqkKhArKoR0AhiS5uJRaqbSvUGLy0JwV2Si08nRmrLwsiGzwbos+nF/9glbRytZ36BI44eUc/gPgKhMXyGo43AofQieuz8mZs
 8x8VEzwE
 0eWxywz6u+/VK8B9mhMsV76lbZBenAOk390ENx7oWCczkKti1y/Nh1pACU2FryOmBKHrn5UAeZmedR2t81fbqbwC59Z1KDgZnl6JVfm5jRXtIGEvAJBlP9UdPLqBAqSbzQi6bO39D/Cc8iiILZ5nNnOcgyLRz2Gq4mLHIr770qwDTm2Vm3Xt6j31htiKYQrJryjokZk1u7HJ82t/FwzX5SiBKrBFmEhip6PgnqgrDPEPqmEUGfLUOoumUOfMNDzbHFTLlUGbJf1a4u2JG4aHhDPFx7uzLL7xeVvuvpxRxwjEOg6VhKGfvttWMrAe4C2rtnIhC0Ni0siP9L214bNAHcGmwoPvdStYRLNwWwI016prChTFygOOF+CQRqrvpbRabCste
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2 Aug 2026 17:52:26 +0200 Uladzislau Rezki <urezki@gmail.com> wrote:

> On Sat, Aug 01, 2026 at 11:52:02AM -0700, Andrew Morton wrote:
> > On Sat,  1 Aug 2026 14:49:15 +0300 Artem Lytkin <iprintercanon@gmail.com> wrote:
> > 
>
> ...
>
> > Ulad, AI review suggests that vrealloc() has an issue handling
> > __GFP_ZERO.  Can you please check?
> > 
> > 	https://sashiko.dev/#/patchset/20260801114915.115224-1-iprintercanon@gmail.com
> > 
> I have checked. I think the AI is missing at least one point.
> AI argument which is:
> 
> <snip>
> If a driver initially allocates memory using vmalloc() without __GFP_ZERO 
> (leaving spare page capacity uninitialized), and then grows the allocation 
> using vrealloc() with __GFP_ZERO, the caller expects the newly exposed bytes 
> to be zeroed.
> <snip>
> 
> In the vrealloc_node_align_noprof() header documentation there is a statement:
> 
> <snip>
>  * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
>  * initial memory allocation, every subsequent call to this API for the same
>  * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
>  * __GFP_ZERO is not fully honored by this API.
> <snip>
> 
> AI argument violates the documentation, i.e. mixing __GFP_ZERO is not allowed.

Sashiko is talking about the initial allocation not using __GFP_ZERO
but vrealloc() *does* use __GFP_ZERO.  The documentation you quoted
doesn't address that case?

Also, developers don't read documentation ;) What happens if some
caller *does* use vmalloc(!__GFP_ZERO) then vrealloc(__GFP_ZERO)? 
Silent misbehavior would be bad - it would be good if vrealloc() were
to drop a WARN() then ignore the __GFP_ZERO.

> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4294,11 +4294,6 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
>   * __GFP_THISNODE flag should be set, otherwise the function will try to avoid
>   * reallocation and possibly disregard the specified @nid.
>   *
> - * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
> - * initial memory allocation, every subsequent call to this API for the same
> - * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
> - * __GFP_ZERO is not fully honored by this API.
> - *
>   * Requesting an alignment that is bigger than the alignment of the existing
>   * allocation will fail.
>   *
> @@ -4415,13 +4410,12 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  	 * We already have the bytes available in the allocation; use them.
>  	 */
>  	if (size <= vm->nr_pages << PAGE_SHIFT) {
> -		/*
> -		 * No need to zero memory here, as unused memory will have
> -		 * already been zeroed at initial allocation time or during
> -		 * realloc shrink time.
> -		 */
> -		vm->requested_size = size;
>  		kasan_vrealloc(p, old_size, size);
> +
> +		if (want_init_on_alloc(flags))
> +			memset((void *)p + old_size, 0, size - old_size);
> +
> +		vm->requested_size = size;
>  		return (void *)p;
>  	}

OK, thanks, I'll assume you'll prepare this for real when convenient.

