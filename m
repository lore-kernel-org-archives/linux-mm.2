Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8069CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 18:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A7296B0005; Wed, 17 Jun 2026 14:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8516A6B0088; Wed, 17 Jun 2026 14:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718D66B008C; Wed, 17 Jun 2026 14:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 458116B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:16:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9B7E1665E8
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:16:48 +0000 (UTC)
X-FDA: 84890210496.30.F23E483
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C5C48C0007
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:16:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k1msFA/7";
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781720206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34T8fjVS2ijKeY073d7cPWfK3Eup8GlZsznBtOHwLAk=;
	b=vY75Pj4jbnDSvruWuCtHL/9kp1WT1VeWuOP0XSbAVa/+vPvVZGLvgtREUdo+xxP0vH419t
	t1Qrg41kf/GRMM58gxq4yZbRnYK1cJ7REAVeyrq79ryqJvMuqGX4Tspo/JnEOBuvFxK9ZI
	imF0Jf785+R7bDHxKR0QohwrSeMe/Q0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781720206;
	b=EQ20w2O8GLgfAo0mK9Fkmb5J+pt6FKCOItdzfQHqryAxoPDvcDQWVHjZLbV5RU7Mr+n9YN
	EQwvqk+x68trnOfrpW9H4shfhQGX6K9/ktwalWLh+pAJV8YBO5Z+Jk+D2rA3eSKzVSSauX
	2HUDxpcHAd3LAPgb113zN7/TUiVR/co=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k1msFA/7";
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BEA2C4172A;
	Wed, 17 Jun 2026 18:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0867F1F000E9;
	Wed, 17 Jun 2026 18:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781720205;
	bh=34T8fjVS2ijKeY073d7cPWfK3Eup8GlZsznBtOHwLAk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=k1msFA/7sWqjtak7jhvFWE52RHjJvxyaPLUVFiyCdcgtn/EOS7R3ztlAs5wt4PZuf
	 nldlzfXpwh6i33uufNBV07/pzvjDHT2tQG5GVWd5k4twbHnYbhMkHapJP/UfO5xHg6
	 /o7Q6iVlKAQhD6+0me4dvgaqprajFvit0hvB6F/OHvOoTRWQ3cq9+g/bWbED2WpTcB
	 R1d+1oNzdRyprLGeuVOlOfRn/wbKcl4sd8i6DzEEvhvmTUsTW591TMj/S4ei08Bt1l
	 j/swA4TBUewBZGsillQb1ERsNdzD38OQv8Q30e9RTfC15CrWGF2RJChQwlnouNyFLr
	 Gz5PyhzE0vCGg==
Message-ID: <89da8f81-9e6c-4923-be0e-7e29c7fdb68b@kernel.org>
Date: Wed, 17 Jun 2026 20:16:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] slab: recognize @GFP parameter as optional in
 kernel-doc
Content-Language: en-US
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 stable@vger.kernel.org, Kees Cook <kees@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>
References: <20260617163125.2716279-1-rdunlap@infradead.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260617163125.2716279-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5C48C0007
X-Stat-Signature: nsa8zhbocdksp9y66ixu8dnp53m3d9kg
X-HE-Tag: 1781720206-771003
X-HE-Meta: U2FsdGVkX1+OTFI65CuHrKS3VL01R4wRa4xT+g0obv2KrYgkPJoDdVNmDQRO4OfgPnG5W1rfXpS+v8qG+nT0maMSS5bKY/+Ym+yScy1xoz7P5KihFNcV+EibsLQRIsuy02YzuZjD91VjCj5+knY4z0e70k48ySlI9HbEPjpK81g6Njn7PhXIPqZVZRpmbSlXpZ1/pU/VIavgoRM4ydfo5CM1RLmMegiC4oy/utZqgtCFUS8SFjv65Etp5rvpPwhAHWb7fGTY6OKDdMVGra2hIJRYPiRvCSMPFpNsClCOWW6BHHngeFV3a8JCc+eU+NwdJXudfMO3jWF+tHjy6aBdCoX+8rIc9E5q07XvdptRrpQvfKT0nVuIN0hGWfCLBVyc8EeGTHDlFIgTBa7Pd0rlRXKwrM0xNzCcu3K6UTzZc7i/Dzwhudl8xF1wBqJDuMB32m5Rv+sJuLz6l0zn7FxzrR0WgZHoiDW/h4rh0ojiIlSayx5TqZ3NCwlOUGfJfIoc3LbMGbpq+nqtrjN1L2OyN+myFDOYbZefSco/rW0g66voGzUL+3uJIAMibS8lREcSt5/MXh85k4ujrBsY/9ApXj3LHwynRCbURewmDQMllOIBWOaiDEt+SsD9KZ311wajnUpnLi5SqoQFtvD4s7EAMqqGFPPur072YgzpdnxKtVZ7pa5xdxvJjva7ifMsBMP9Koz8NXSZAOzABUGI47/Q+6mMHHzHidUQ0RN7ReaEwZql1wRfX242taX7AhaopjMKMpVRXEvgA7XO44+qEV3yE+c/uSJnmoZlaRMTKTBDqW7QfKwgvSRonLRWT6JHNMmOQSA1ioP3bHSR0J1P0lcGgwKlWsU2z9LId7r8WmZCpqeR0qOquACsk77T9eiM/2AF8vLr0bgBhR7ezwET5wk7Oa7ncNufvq+LAvbtshKQofB5hbRVPvfHrdYbnNdfiSYWoMDW5UnJ04XblsODM/B
 cus+xYpu
 eiRgE496yDzwDpyW8Os3KMZrjg0kkSO8jGlyJtFV/mhvZyjzWuMj2tTplhJB7ahNqerlAsSsnZj6iYyLNoRHGU4cm+iomKIHT3emviVISWwjlVaOvnhWzYdHaZY9pu+tea59sH3+OMV6Ld18s7bKkHyiac3u/DpNdH/HSiN6qQDeXNxjCPdDSQr8FJzZqMo3wgvrvuUFYS3eV+MFksGeUGSHG5qDq24vhLE7lwslowcVWZ3VnDOb9CQdLqBvLSPLdqu3IwXijSljIa3VdRgN6CSx8Z/Sqma5aQZL08DiR9kmXvlAysYZ34jkcJ2qwXUACgHttU0k955zW3YiCDvGUxMGll1O1sjLlRmXKZaHgcLCy5PhbJqPIjHrxSzyxdRHrzJSn+HCt8raj+UXAT0VnxLYsCe9vFnRDJDtdIiZQ88hmtg8AdB1JP/y58WfleoCYjhJrq4FTJiR0r4LROvtwBpwu2zBYQAUJE1sRavYl/t0iTAPPkRF101j+67XcmMyEJQos7gN9gRxM7og=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 18:31, Randy Dunlap wrote:
> Since the @GFP parameter in kmalloc_obj() etc. is now optional, change
> the kernel-doc to indicate that it is optional. This avoids kernel-doc
> warnings:
> 
> WARNING: include/linux/slab.h:1101 Excess function parameter 'GFP' description in 'kmalloc_obj'
> WARNING: include/linux/slab.h:1113 Excess function parameter 'GFP' description in 'kmalloc_objs'
> WARNING: include/linux/slab.h:1128 Excess function parameter 'GFP' description in 'kmalloc_flex'
> 
> Fixes: e19e1b480ac7 ("add default_gfp() helper macro and use it in the new *alloc_obj() helpers")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

Added to slab/for-next, thanks!

> ---
> v2: add default value for GFP flags to the description (Harry)
> 
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Harry Yoo <harry@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: stable@vger.kernel.org
> Cc: Kees Cook <kees@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> 
>  include/linux/slab.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- linux-next-20260615.orig/include/linux/slab.h
> +++ linux-next-20260615/include/linux/slab.h
> @@ -1094,7 +1094,7 @@ void *kmalloc_nolock(size_t size, gfp_t
>  /**
>   * kmalloc_obj - Allocate a single instance of the given type
>   * @VAR_OR_TYPE: Variable or type to allocate.
> - * @GFP: GFP flags for the allocation.
> + * @...: optional GFP flags for the allocation (GFP_KERNEL when not specified).
>   *
>   * Returns: newly allocated pointer to a @VAR_OR_TYPE on success, or NULL
>   * on failure.
> @@ -1106,7 +1106,7 @@ void *kmalloc_nolock(size_t size, gfp_t
>   * kmalloc_objs - Allocate an array of the given type
>   * @VAR_OR_TYPE: Variable or type to allocate an array of.
>   * @COUNT: How many elements in the array.
> - * @GFP: GFP flags for the allocation.
> + * @...: optional GFP flags for the allocation (GFP_KERNEL when not specified).
>   *
>   * Returns: newly allocated pointer to array of @VAR_OR_TYPE on success,
>   * or NULL on failure.
> @@ -1119,7 +1119,7 @@ void *kmalloc_nolock(size_t size, gfp_t
>   * @VAR_OR_TYPE: Variable or type to allocate (with its flex array).
>   * @FAM: The name of the flexible array member of the structure.
>   * @COUNT: How many flexible array member elements are desired.
> - * @GFP: GFP flags for the allocation.
> + * @...: optional GFP flags for the allocation (GFP_KERNEL when not specified).
>   *
>   * Returns: newly allocated pointer to @VAR_OR_TYPE on success, NULL on
>   * failure. If @FAM has been annotated with __counted_by(), the allocation


