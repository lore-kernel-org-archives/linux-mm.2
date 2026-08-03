Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F4A5C55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 03:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA7076B007B; Sun,  2 Aug 2026 23:50:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56DC6B0088; Sun,  2 Aug 2026 23:50:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F6E6B008A; Sun,  2 Aug 2026 23:50:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A13EE6B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 23:50:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FB42805CE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:49:59 +0000 (UTC)
X-FDA: 85058579718.13.5E2F0C2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6CD30180004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:49:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kIZEY5K5;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785728997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjdEMLkja9qKxv90Rpl8tIl7VQwb9LCdaOHrApnrTCU=;
	b=HzPkv7osEM4RjxCJArxYqRfLgAr9RDdikOqSPIkJjugiRjzCGftL7Futpncab4YBog1hkU
	0OlmTsgg/jHAJgRxhidmeFw3vGN829Yw1RsI8khFATGMHJGGw09wTq5LkpZO9shL2zhMm2
	UkkfE9+9RnBLGFRPL134TTYdvBPIAKY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kIZEY5K5;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785728998;
	b=YDB+cmgEP9IK+tYZsaSNj+7rObcmY/o/IDPIvpP/xcOwBHRy9uJWcClB2KZKHBe1AXtjGO
	m0a8EUIK6o/Tpljpq3p7MLZ1LkIKNhu6ESpN3LLhh3av69xCnWHly7bvzSgTQ1prTf95uv
	5RTOHiM3UaTYMAPi2GULjobZlhsR8oM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E7E1143D;
	Sun,  2 Aug 2026 20:49:52 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 994583F86F;
	Sun,  2 Aug 2026 20:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785728996; bh=BEtWf/7nQjx9/eFB+l0hzs+fD9Z86AKzw+zM89qjclI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kIZEY5K5JrrwAD/m+/5k5UHF+TGv+edBFiJB5a1ZPlzVomWmsHPUAWZcviZg55K5j
	 4XU8WB0HWvhQ7QImJlaDd/3Xlsnf/4n7oKGkBynmUcl/8yhd9LREu5qsAZmaeJyBn0
	 QPJBqCei+ZGHqIKKvnLREFS/s8pGXMJwo8Ft0z8Q=
Date: Mon, 3 Aug 2026 09:19:52 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>, 
	syzbot+61c997e6be1d9bb300ba@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/vmalloc: Do not warn on -ENOMEM from va_alloc()
Message-ID: <pi25qtpcxjhykyc7xwjvvgnlnam2gyp6rxoxsxj5vzfscg5ysp@6wzaipk3t6bm>
References: <20260802104627.63892-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802104627.63892-1-urezki@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6CD30180004
X-Stat-Signature: yxizcmof83qdi8b96ocx5go47pgigxgd
X-HE-Tag: 1785728997-264954
X-HE-Meta: U2FsdGVkX19cu0JDYCnbjrDloxzs9sFl+8y5bjIRKwCyx1e0DPeEHPdzYN6po8Uqs/VHJx7bNvZs+wWBiSbSGBKG8a/jrLV6v0BfkBw3kU/45Zch6KkjJqpyMXrIJy7327OKuXLfC1pk3H53sSjfKUrclVvNM5/CEBE0rQ7rGJCxXp7O4iAzgEa08LF36dB9PVZUxL5p/zH/gyj1/cEMoOMC9XeIo6jAjOuYPf8tQT002WpchSdEiwGHhRNBUbU3jZq26+u6ZA20SoPnCA5n+sAXuv3PoKLFGv0rcRacBTchX57RK21JxWHjJu9ZQbNGE+FuLnvcsDoqs3nn/X8tHUqAdwhA4gLT3LTPZSMml5j37ZGwQ5MMbUGQzmEAsqr6wLr4s1h9kAOumnd/jIq3oE+Sh6DdHGLe2SoPwhYKdO/4wRFMQ+kwGGyQigQl8TPHpxRnzHxgYjBm8no/zl2RXSUxkW2M9tK4+SbHGjdViZX4/j/xR6y8i0gmzzsFXnJXskDQ6ZHbEObSgw2bryIggKBgk0N28ZUZ5Efw/H0OJnvFVmViD80Iv/Kkx8woLkj8N1Sp6WJMvdxYuZ6T2Z5BvE91uml6ak/jjc9feYYzJnazOV3r5yeor9bcTRWcdWOxAfPX/Ljwegb9gw2JTOj2JNlWxWJjoKDSkEtJee2/FAboTxtHpX8BNA2plX8+igdMqlTa3oWjxWw4wvdfAtwAm9x7moyM0bO8cmr/XU248vs7UvHhafbmrvBhQk53swUkZximeW1UiaLrSMkwTQVN1WAYmvfCWX57U+SW+rLTAoD2aIFos9PXJTdu+cqAREkLfMW6TjHmCbV+v1N0IkUrYd7lsVG2mjcEdmDuXV3ZauFrwzqbE7FnK8ck90eHpHomGTqSJXaKRj0F+zX9c+JlsWJUD9o60cbzYsEkFlX2flw2mOYv8BqxE6n5RpwOR7QgaK9SUdzufPeVly8CYfb
 i+DI3Vk1
 q6GMCQWUfzE/nGt3yFNQ02WLaMHXwx1DlEhb/LnRlyQ+Lldxlvm1mU/SbuoqWP69OchIzmIcHgt3hRNq6KI9vYCS5/MRwk0t6B5ki13mwlNJPRpCz66RErr/ZQuYA30BvuD0/EkoeL2WchRiPgawpErBGwUJahD9Id8RYQ/BEDmHQZfctpFfIwapGvnjLwJVk6jvhdgRVH94BpaPZvMPtT+ocUzPQcCr9wyJ8/s7fANYDZGG6vOw3R450GA0yx9I6cHhfnlj+6NYhSTG7emkB3bRpjAsbJ+tPfcsG2eGDLIrKY9ejkx/fXFVHZfcpannmfou+tyJdSW6I1AVjEATHZxMRk/LY1Myd8l2Z0oCKlElzK1gOiGJZ3NLwyzSsOEAoBekz4PcuZj+UHxvjXkDpqL1AIDHmbtscSmrw01fpiN42SWIGrp13TdkiU0KSuMl4HrxyirvacwWDxdsDuLGGtmgdul0A0UQaz8D1WmhGqhY+l1DoVPWgvn7wJ1ezWn72wV+znWK73K4BaM7c4iwbMuacH9YVins/ZFF9YTvqU+zFqBVrYr4hVFDJFQYTh+bZB+8L4b+Pu+rzwIUKzhQV0rGbQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 02, 2026 at 12:46:27PM +0200, Uladzislau Rezki (Sony) wrote:
> Since vmalloc() accepts non-blocking GFP flags, allocation
> requests may fail when callers pass restrictive GFP masks.
> 
> va_clip() may return -ENOMEM when its GFP_NOWAIT fallback
> allocation fails during NE_FIT_TYPE splitting. This is an
> expected failure, so va_alloc() should return the error
> without triggering a kernel splat.

Dropping WARN_ON_ONCE() just for -ENOMEM while preserving this
warning for other returned errors does make sense.

> 
> Reported-by: syzbot+61c997e6be1d9bb300ba@syzkaller.appspotmail.com

Very small nit.

If there is actual link for the problem report, probably it could
be added as an Link: or Closes: here.


> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  mm/vmalloc.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 1afca3568b9b..7a0cbba3d29d 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1817,8 +1817,10 @@ va_alloc(struct vmap_area *va,
>  
>  	/* Update the free vmap_area. */
>  	ret = va_clip(root, head, va, nva_start_addr, size);
> -	if (WARN_ON_ONCE(ret))
> +	if (ret) {
> +		WARN_ON_ONCE(ret != -ENOMEM);
>  		return ret;
> +	}
>  
>  	return nva_start_addr;
>  }
> @@ -1891,12 +1893,9 @@ preload_this_cpu_lock(spinlock_t *lock, gfp_t gfp_mask, int node)
>  
>  	/*
>  	 * Preload this CPU with one extra vmap_area object. It is used
> -	 * when fit type of free area is NE_FIT_TYPE. It guarantees that
> -	 * a CPU that does an allocation is preloaded.
> -	 *
> -	 * We do it in non-atomic context, thus it allows us to use more
> -	 * permissive allocation masks to be more stable under low memory
> -	 * condition and high memory pressure.
> +	 * when fit type of free area is NE_FIT_TYPE. It is best effort
> +	 * pre-loading. If it fails va_clip() may return -ENOMEM from its
> +	 * GFP_NOWAIT fallback.
>  	 */
>  	if (!this_cpu_read(ne_fit_preload_node))
>  		va = kmem_cache_alloc_node(vmap_area_cachep, gfp_mask, node);
> -- 
> 2.47.3
> 

