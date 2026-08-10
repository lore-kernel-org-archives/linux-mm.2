Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 965DBC5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A98DE6B008A; Mon, 10 Aug 2026 10:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A227C6B008C; Mon, 10 Aug 2026 10:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93E096B0092; Mon, 10 Aug 2026 10:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 704536B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:26:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15854401A6
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:26:45 +0000 (UTC)
X-FDA: 85085585970.30.4FD9887
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1C3CBA000A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:26:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RYvBoyne;
	spf=pass (imf15.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786372003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bAngNRUu70f/xN7+43eKeHgCsKu5ptveUO2MkIfnplE=;
	b=V1ieL1kkKJVTcBFxdYB9yf3e12PrbwpA+akFwbpmCs0j+XUVrI7ppzjYTaJUcPzJt9M+Qb
	Dfoccwhc9Vy7SOZ0rOqx1/aANHTIs6AoBV99F6YWgpkqKfUIkLKuDlHge7hKG1luKOA/nP
	Up2rSvc1e23su+Uyf3y4egiHF8Krerc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786372003;
	b=K/OdbjFNj01SAq94zfXjBUScSKD9BIq7sTCXwIN+AC1qZE+HmIrgB0cO/7jNRHVh4ACeJp
	aoNaCk+VUvzn8imhqsR3+ogjE1uzWQ0/Tr+ftHTV9yhtNs0PPGriEVyLurRZtu+aIdMUMR
	jayhqTfMYU+1iId4X4QNKoz6jh90glU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RYvBoyne;
	spf=pass (imf15.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1844F14BF;
	Mon, 10 Aug 2026 07:26:38 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A6F13F86F;
	Mon, 10 Aug 2026 07:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786372002; bh=zjwgjmw2Cz13wapOkkSs//vcr48fzlSgref4mNwk7G0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RYvBoyneZzEB3QMUtepP5JZcL2qZ+JuOAZwBiaM/TSdhVOKhY03ZdOFmOILXJmU9g
	 YxbXxDzoppQKGeEGhNbOlI+M+b5dK/yJhBm2JwYln3hkY7apaie9v4BpG1yCxp1CyF
	 58C1yjwQ58S5Ot+C8g/lua8+t77ra7YAvHvOWeFw=
Date: Mon, 10 Aug 2026 15:26:37 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] slab: align ZERO_SIZE_PTR to ARCH_KMALLOC_MINALIGN
Message-ID: <annfnXskDJuyzMKD@arm.com>
References: <20260808105622.62026-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260808105622.62026-1-kmehltretter@gmail.com>
X-Rspamd-Queue-Id: 1C3CBA000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 91todrgzkicqgt6scb9mpbrg9z81cct1
X-HE-Tag: 1786372002-178598
X-HE-Meta: U2FsdGVkX18DYXnEUlDxgFQ5+ZonX8d2TDoGL5ZPIBYKg+eeK7btAsqqsROpXrQju6EdaNwDGejVrudZpN82xG4jiyRJ8Ymtz6TtC/zQ60sHTznxPwY5TNbRIwt4YFN8sP0X0kOXpA4FVkA9kYYW/moS0I6oSPSk2XJYwtT7NigWu4i0rMj0IjJbL+c+inpy5J3NwBiGQQYTBeyGuu4sg7cd9XQDgaoCagWPsfoEu4AhpUIlZqjhgnwzMtCn/WMUDzMYY64sryB0u1O31u3QZ2M6FN90bQzryvMxp0zyEsZb5wa7fVZx/CXenDW+RJxgBuoPyNKmTvI9REULX1qY025eZNhfrRMirYl0KhRIncm7OXK+e899NB1NLtbUYxHAa3Fygceld/js62wVmxUhEVJ2AtYEvoyM1b1vxGecausrOa6zxtuIo13vFLxThxC+S3tP3znKzxQf8sAiPtVc2tC2vM15O37pjJx6Pj26fz58xtcdi69KSCOpL1x8C1yIQ9P6FVi7ugMFqaqxjb7tXCDEIfb5QZ02DA+b3ci+tOSw+BVOy8fMVWcxJBVOOYqHmvFVmOdRjCVWzljQ2jsiuvq11uxGLsk6DdN6vE9fdUZmfyjyMpDrMDY0xbCEHNgP7uhp+HG5Sn1qbWEJUvDBGqmS0pbvccMpHmRm3+ijGX4TYKJGm4BMUwVkaPxrZMdWy4N5nb3eH57b8BS2dC71MkKFmhSCWBSTxTr9hWypv3uHKJUp1wjqg/WRkd5xQEByjsnO7bHGPej93f8easLIsLod30d/DypHlTBVCi22As6PpBZyEMHIj5aRAyM7aY0/5gR4ZauUyet5FCOZIh+e59koNOLgiV6rBzii807QXaiEWVrIjn9yF6iBNX9TPSp6IwwtO4+f9q8h3fjt4eHgzvJgnWpB3IAGmS2nSGRN3xXi3Jw1kTSHH228TWGql6C8yAhJlUd6GLx39C6h2bD
 dFS0h94s
 IIX8FwPTBnqvUQyTl4elW/lI6XEPsR/Hjkj+z7zpXjnLTRHUsiOsEuL+vPAwXw1skUHvTlv1FcU+5JBd1UMpNZR7YfGWIQmhBjYkKGRF9xMjKcwypGwJkDscrqxD2muwGW783dN6mLopvYcYFkXQkih9EkkIc7MfGoBnovUrFqvFEQt1idhUdOZj9y57D9PEVgEgHI7ZZnBPXsRuxWQXXTAhw/YOR2rHU1UwnSMecikPDxndELevMjF+Iz8UOm5Z8wkcvV+K0X7DusZT6MEY1VEdF5Zu7XHwmxqAMf0fUNjPZl74HUCn0+3qW1tjfn8ESBhwXyeOoto/GoRfILKHa927Vpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 08, 2026 at 12:56:22PM +0200, Karl Mehltretter wrote:
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 32c9f8ed7ae20..0798a714da87f 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -259,13 +259,16 @@ enum _slab_flag_bits {
>  
>  /*
>   * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
> + * It satisfies the alignment promised by __assume_kmalloc_alignment
> + * and keeps the historic value 16 where that is already aligned.
>   *
>   * Dereferencing ZERO_SIZE_PTR will lead to a distinct access fault.
>   *
>   * ZERO_SIZE_PTR can be passed to kfree though in the same way that NULL can.
>   * Both make kfree a no-op.
>   */
> -#define ZERO_SIZE_PTR ((void *)16)
> +#define ZERO_SIZE_PTR ((void *)(ARCH_KMALLOC_MINALIGN > 16 ? \
> +				ARCH_KMALLOC_MINALIGN : 16))
>  
>  #define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
>  				(unsigned long)ZERO_SIZE_PTR)
> @@ -622,6 +625,12 @@ static inline bool kmem_dump_obj(void *object) { return false; }
>  #define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)
>  #endif
>  
> +/*
> + * Keep ZERO_SIZE_PTR below PAGE_SIZE and the low pointer poison values.
> + * 128 is the largest in-tree ARCH_KMALLOC_MINALIGN.
> + */
> +static_assert(ARCH_KMALLOC_MINALIGN <= 128);

I'm not sure we should bother with this, or at least make it strictly
less than PAGE_SIZE since 128 doesn't have any meaning for the slab
allocator.

Otherwise,

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

