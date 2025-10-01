Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 368E1CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 08:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 691278E0015; Wed,  1 Oct 2025 04:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668A48E0002; Wed,  1 Oct 2025 04:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A5468E0015; Wed,  1 Oct 2025 04:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 496138E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:54:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF2635BD58
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:54:29 +0000 (UTC)
X-FDA: 83948934258.12.CD7E69E
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id 000E040002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:54:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kt+EIMBQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759308868; a=rsa-sha256;
	cv=none;
	b=zlJxwIl9R4q2cabBx5LMOZ0zJI2JxzZgCCCVCrdyWJii8S+11/pafAnGbBN9FBIIB/Upqv
	0pBSFwFr+rA7Wnv+GG3tvnyXmdJjCEG6dPNbJ4+cP9UWStGfkWi+cDE+/7sfwT/YoQKjep
	pB/5Y69mZVUK8xPLRa32+0ozIHaRgsY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kt+EIMBQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759308868;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4jq+NwjNX43C8IcFtydh0hsU++MGHu2pSQ+/Nx3+Uws=;
	b=3rx7Jjs3cjsY62G9zoBKLAleaaao++s8aKdd8tsGFF1eQ8kKmNVHwVpLrpPTndKX4ytFBj
	y2JxPGHw3xzBeqXG7ljS72hRJliptQAERG2ukvLkOASYyJnbgURITF7bbAkg4SVkkmnBF6
	rn2uHiYs8nBlLhKp23yJsrTUQCXPiAE=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-62fa062a1abso11481658a12.2
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 01:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759308866; x=1759913666; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4jq+NwjNX43C8IcFtydh0hsU++MGHu2pSQ+/Nx3+Uws=;
        b=Kt+EIMBQVJXKhRB23RxvQ0UQ83ydU1TpUZHmPnYVEnzqv8bNGLFc9zmtsLOoPEMRTy
         Dgj/tq9KGW4dT2Jre07LvjbUP3MG7a6/H1t8yjA+4v1nUqF4IALOgh/8x1q4AWSymVSn
         rpckGeSwYQcpH+gf0uHIkkRkgy5U6nCavCOClFlcjGw5Np+z09dvH6Lj60iFTYUHiEgU
         8CezFhR+09l2uqi1xGSHP465nLihlGf1KPfKemnFMW38A14xzUV+nqGCCbWKMNO9cuq6
         BxxBsXVBk8aGlNLHJPWGUnJWeNWEmw1alGwDKh7bqmVN9Hoswjv3g/ct73zLjzrMNASJ
         wg1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759308866; x=1759913666;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4jq+NwjNX43C8IcFtydh0hsU++MGHu2pSQ+/Nx3+Uws=;
        b=O5rxBDZOBIHGnY1/pzqI3GEPG7q88U5+iKdCPpT1yhqTYzyEAPD1d6pHA7q2stHi6C
         4Owk9y9s3CUGF0wYhTNRGaaPnsK05QgeDfe5J1uzltficwcfp2FkW+J9MvA5KuIgqg4b
         rgNGhSQ74mQgZNxU6gOwcSv80VSGTVoiyFnelX+v4l5+cdm9nMbcpxcOENaKsS3bSxsj
         4Bl9RIRGJz5gZ5iDqN4IIkmKSwyw188t0CQRS9sE8I40W+V4pT4gfoKCd5K4evE5H94k
         YI46mXUfyZwdMD0UDvjOvYVRPZz8lZMaZSCJlldQKMTNo0znZQNjVP1IVWQBbLId63WM
         utxw==
X-Forwarded-Encrypted: i=1; AJvYcCUrcy1klqIdfEBVglSNakf5qdzKbkXKq+c6gNq+GQWZatbaLPO4jCaMJ5bDkv8/8C5YgQP+nzDPZg==@kvack.org
X-Gm-Message-State: AOJu0YxKSlBeqwp3BnanuAJIMUNbBwWy5j9ULl08ptvEZBNbRTusSGnQ
	56sA9ODHHBjrRMMuHfGFxRWl/K7nxASQYI2pe4x6/LSY3/L90oRO/ckX
X-Gm-Gg: ASbGncvuoVcXHbBV5hotB8TBbFs+k9PoAEEvVr0PEdxl5h7WPmXWurgZw+OSYwAUJTp
	15+AfFipWOvBz1DVnR4r7ag2JiHbgWX2g/F+cqjS9pWJWWbsIvZDHFwifnneCcVKQtyEX+VMx37
	e7dd7haRhswIuQukam0ChFLbVafHB1i6cPZ6IiF5BD9aOLtEBoID0L2XyV1WSKd9ZhexzdbE3F/
	s4uQYTJBImnICfPK6ScvAy8P8ikiCqMP2W/Vz1KE8mR7Qdi8Mhfh2KL53gXlLW94UVPCcu5cRqb
	Oi9n4hdGUhjxt7+XVvJcaEUng8gAF89uQ+sz4Q2SRAsN9lqOuw23WckV2GgvHwzBndZQb9EtiGr
	hanuAmf5U09YatZbHwhjQaqy4QWOK7iWVt0XG8twDCRKI86TN3g==
X-Google-Smtp-Source: AGHT+IEXQ1igMBNuJPp8r1+b1vCKJaIsvxsCFMXTwEOKWVqNJRrL3GS3CWPQfw5QrY0+nNdCEPtJXQ==
X-Received: by 2002:a17:907:9449:b0:b3b:5fe6:577a with SMTP id a640c23a62f3a-b46e24366cfmr319920566b.8.1759308866250;
        Wed, 01 Oct 2025 01:54:26 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b40f9d0a652sm457947366b.33.2025.10.01.01.54.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Oct 2025 01:54:25 -0700 (PDT)
Date: Wed, 1 Oct 2025 08:54:25 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
	ioworker0@gmail.com, kirill@shutemov.name,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	mpenttil@redhat.com, npache@redhat.com, ryan.roberts@arm.com,
	ziy@nvidia.com, richard.weiyang@gmail.com
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Message-ID: <20251001085425.5iq2mgfom6sqkbbx@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251001032251.85888-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001032251.85888-1-lance.yang@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 000E040002
X-Stat-Signature: ewtmr5iq6wriizakc15quqqjr7ny1dog
X-Rspam-User: 
X-HE-Tag: 1759308867-946681
X-HE-Meta: U2FsdGVkX1/SKVy0VdMatq5+LRju4VfJprHcE6lLKkd/dfpx/X8UkhUdnOpSjq+2vrkdDzZDMEq6SAJFuiTSAEjlBoF4HlgyzI0jUFpy9gGUD8u5To9q2Uv7B/djPehgcNfJbFsMMOThbfjaLrtYfYZchkjk+XO5A5SchxoMT9jXpkx23oV6qePMYjTsPQKL9Mf3Z+Hp/O5TwA51LDyvRiLl1v0SepkT/PRTqXvBuHhqNBh0WlZNSCZNpBkplrVGcET91Ls6zaQ7O1GnOgMQKGpIMN6DaLQby4zgwXISsXKXHwxDxW+WyTb+bTv5AJjAzZyAG7BsJBa50wi22eOdYYMOuQrx20qqmNEk8BDInVkp4wIsAAGsnto4Mtv10j9ewzktHS2y9UEUmY0pkreRDQOSbmQi4X/lLuNHrJPZYrHWG1ZLLfBxR4XUmJpNy9PTev4hEi08vLGp8LAhc+Ruy/u4fGTolZZsu208wtJjWRtqzsg6wjpm4EqVrH9cUhL9+x1jJYZIEJR0so0TA0IidazXURB1+AQK2pGJi4tveR7fDe5165IOPY75asAqA/r/bH8SUBfiW8jl8/9WXhj+2u6Q/UQKqNRLCn7gKyHyJik1UFood0QtNQwBVXMrAVbU8Q9WIAzSJbmcX1sj8JSzmJRPQaADl6awva51jOrXpcbwjFQeId06NshDliDmcDOPQSCsZegWKa3I4LYIolsuJjvQjxYcCAbJGuGDq7WgONM1iZ7gkoXoLCJDy94WL7BkdaBDordGQnadEkyPAntz8WVf/M8Zt0Ue7QuxsFXil8NxaTl+GaLPmAi47p9wAgFSx/YbOmefavj8i0GaLYCiClq37e65K5L+RTRrRN7IksmHyCma9rdN5DdRHIYRNJYlhNEK3ynqBgthiI0KFqTV49oWVD6XUEjR6VdBEW1CtuKK7dLpymAmhPTJ9/MUmnMZFcygJooKw0xP7HLEqMD
 zU5uvNRk
 CdnqM/+4cUUQuY200WMSrTub/C6GeNLSrWO5FABkhOq64q8W4Kef/G+xFiKEOmslySg8Jb8TaL2D8V7xb2biugx4ddpbmSIz0rg+0+eMuCc1QYA+1si0DBIXmf91x9TQNLmyRpuEGqlWfKlbv2zmhnsfDYNAm605Typdrw5MvAEWu6fDF0F+Uxk/AzAMqoLB7hUWUP5tmqsBPk/70VdskATlNsVtrkaPE7JcnGbv+4oAJUTT9fFPt5kqOOeU/5jXoTXPW6djpDmgxHrTrtmPqrzItK2VzdA4zH3uaoaO9LkasVEa6JubEE9XWd7IJsUCxQJZyiDSdOd4rLuKj5BlMceCwA+fAxgXWipMJj4gqL4HpLTm0jJ/PQR1e35+/mStWRbN4dhLrH+0z+itLJtWh5VzdFDeNOl4eWufkwsZFvQ7wYFdfIkAOcejC+WDJ4Ngsgz2YKG0w3KFp6LGKm51Wc2awgLPtfDP58gUOEuFaP/i0ki7gGR/jz23G+xgy29m6fCtwb45JmKp93qjgOdaAeB0fGWFB5w/FqZsBkLkNf2uQF+D+Ktk/kB/gDwBwrfPc7DhSfBbAN3L4PCeyz9zVJhx0Rg9ZBJEy4lOekn1Vo8D3X2IVcmljbnaV0IUr0k1S4Y9DSDjfiseX9ltPriJP97FcMfP3J3Vk204kPNydvmUZk09yTFEe6UMn++yFQjvD9C+rJ3FfWzIBctQ3FUFdgE6pgn+dGZKiONL18/t5NajEIJE4tmvBeenRfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 01, 2025 at 11:22:51AM +0800, Lance Yang wrote:
>From: Lance Yang <lance.yang@linux.dev>
>
>Currently, special non-swap entries (like migration, hwpoison, or PTE
>markers) are not caught early in hpage_collapse_scan_pmd(), leading to
>failures deep in the swap-in logic.
>
>hpage_collapse_scan_pmd()
> `- collapse_huge_page()
>     `- __collapse_huge_page_swapin() -> fails!
>
>As David suggested[1], this patch skips any such non-swap entries
>early. If any one is found, the scan is aborted immediately with the
>SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
>work.
>
>[1] https://lore.kernel.org/linux-mm/7840f68e-7580-42cb-a7c8-1ba64fd6df69@redhat.com
>[2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local
>
>Suggested-by: David Hildenbrand <david@redhat.com>
>Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>Signed-off-by: Lance Yang <lance.yang@linux.dev>
>---
>v1 -> v2:
> - Skip all non-present entries except swap entries (per David) thanks!
> - https://lore.kernel.org/linux-mm/20250924100207.28332-1-lance.yang@linux.dev/
>
> mm/khugepaged.c | 32 ++++++++++++++++++--------------
> 1 file changed, 18 insertions(+), 14 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 7ab2d1a42df3..d0957648db19 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -1284,7 +1284,23 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> 	     _pte++, addr += PAGE_SIZE) {
> 		pte_t pteval = ptep_get(_pte);
>-		if (is_swap_pte(pteval)) {

It looks is_swap_pte() is mis-leading?

>+		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>+			++none_or_zero;
>+			if (!userfaultfd_armed(vma) &&
>+			    (!cc->is_khugepaged ||
>+			     none_or_zero <= khugepaged_max_ptes_none)) {
>+				continue;
>+			} else {
>+				result = SCAN_EXCEED_NONE_PTE;
>+				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>+				goto out_unmap;
>+			}
>+		} else if (!pte_present(pteval)) {
>+			if (non_swap_entry(pte_to_swp_entry(pteval))) {
>+				result = SCAN_PTE_NON_PRESENT;
>+				goto out_unmap;
>+			}
>+
> 			++unmapped;
> 			if (!cc->is_khugepaged ||
> 			    unmapped <= khugepaged_max_ptes_swap) {
>@@ -1293,7 +1309,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> 				 * enabled swap entries.  Please see
> 				 * comment below for pte_uffd_wp().
> 				 */
>-				if (pte_swp_uffd_wp_any(pteval)) {
>+				if (pte_swp_uffd_wp(pteval)) {

I am not sure why we want to change this. There is no description in the
change log.

Would you mind giving some hint on this?

> 					result = SCAN_PTE_UFFD_WP;
> 					goto out_unmap;
> 				}
>@@ -1304,18 +1320,6 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> 				goto out_unmap;
> 			}
> 		}
>-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>-			++none_or_zero;
>-			if (!userfaultfd_armed(vma) &&
>-			    (!cc->is_khugepaged ||
>-			     none_or_zero <= khugepaged_max_ptes_none)) {
>-				continue;
>-			} else {
>-				result = SCAN_EXCEED_NONE_PTE;
>-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>-				goto out_unmap;
>-			}
>-		}
> 		if (pte_uffd_wp(pteval)) {
> 			/*
> 			 * Don't collapse the page if any of the small
>-- 
>2.49.0

-- 
Wei Yang
Help you, Help me

