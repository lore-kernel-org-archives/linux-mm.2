Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95626C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 16:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264466B00BF; Mon,  6 Jul 2026 12:33:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215616B00C0; Mon,  6 Jul 2026 12:33:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DEAA6B00C2; Mon,  6 Jul 2026 12:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5E716B00BF
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:33:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41E56A0189
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:33:38 +0000 (UTC)
X-FDA: 84958897716.27.2E0C330
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id AABF54000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:33:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fyL77QPW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783355616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l27bgQBYkZ9ic8JTY8Nu2Fp9usWIwYdRIdGCbIzonFA=;
	b=v80JWFDCdFNQj0vB68n+NDWeKcGe8iSFUOeowS6YXB7FuuJkP6xpJFl+SoH2RY2zzExEa+
	igV9Uf19SBmYDxjPuT6O+Aeg0sKIZegYvOPP01THH8npQkUnrcRbfdl6EVJOMvs8wW9ktu
	4B2sbWAS1uVreDzzzVIUMl/RYm6relU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fyL77QPW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783355616;
	b=ofxbIHK+yWqwKfOLYyQKRuWrnrZ1qMBZLUiWfJSwjsL9lssouxnwvSWK5wPqAo7Y5+1ZmR
	Ps8ttlxJ+rjUGr5nggY5uApnE1MbFJ2sbJ+AAGSZRl5zRh7ki981yuFTrCNCLzj+7gnPXR
	eN0lHlcZiegHIZw6cYfVvYRq3CbM4LE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783355615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l27bgQBYkZ9ic8JTY8Nu2Fp9usWIwYdRIdGCbIzonFA=;
	b=fyL77QPWTnxwgda7Fc+xkSikVN/eabFcyIWoBwwnFMKVOa5Aki1F0TYCmZQVkuNjDK4Jqz
	Gl4eq7EsTkbwm1jafwrobNaMH1JPg2fg1mJWuk9f20viWRCLECahKhDgcQ4gBRV6lzuNA5
	HC/ngwCBa4JIbrvdcSsxcPtAz3pdr8w=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-f3yz7rQ7M0Opc96uft70cQ-1; Mon, 06 Jul 2026 12:33:33 -0400
X-MC-Unique: f3yz7rQ7M0Opc96uft70cQ-1
X-Mimecast-MFC-AGG-ID: f3yz7rQ7M0Opc96uft70cQ_1783355613
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e61b38eddso579097885a.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 09:33:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783355613; x=1783960413;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l27bgQBYkZ9ic8JTY8Nu2Fp9usWIwYdRIdGCbIzonFA=;
        b=nssXOzYNSTQE3VCM94yGahU7N1QMjytsHMD32qJ1pdxYdq7EmGmjvczvTg5I5p+WoI
         2KQKsDOjnlG94y9SlV3486rDOHbVgyF5P3WOuEkGWLSvzy4iIWzEBPwh/qKvoafBVD+B
         1c9u1/dj4bJQjchMjJX1o8ZGuEVaTqn16lj6UXMkhF+EWl7aVayJ2fIAZcjCR1+7Re4/
         tmK1Gt4WKTCk7D0hWe4yG646JcI+M5Bfz22cZIltp+oEPfjj0lqvnSgiMjjKstCDj7sw
         3LUUFf29XMcY+ObdOPKdoHBAYseyO4kNTIA2tC2tA+j0P//4pBNUG4VzN+DqXvTLKwly
         o36g==
X-Forwarded-Encrypted: i=1; AHgh+Rr4Xl75t8rZLnuEQN0em7/GTkK+kW6No/YaHvYsH+KuYmjG1wSaB3++2lrj2rOcNVQYtRqttgWJzA==@kvack.org
X-Gm-Message-State: AOJu0YwUy/zLV/FnJIF7dgGqSMBTFoRE+1OxkgtTqDJPM4H5mUyCIqms
	beLp0stFz9v61OBO94QFzmk8vfhlcDJSosZxzigoDrcWYetPWt2e9Ie8SOcVmmNanGpkvypxxth
	iOT9mnYFaMptApKBK0AaoRWcCHMrtn9/K6izcDibKtA8vRIl99vMI
X-Gm-Gg: AfdE7ckdt2cZqU0tItpgPzncGyyKQ/Ka9Ld3D0UPVIMgooa2I/J9aRoAudMMOnu/Ipn
	pWHW6ON7cTN7195iWKWc9mkIo0M406FO42jl0xm4L+xEDAFtcetzQEMM/jdfazrXdm6EoqX7sqR
	ncO86aeODdjCYMfvPYT+ncfn1voSISZNEobHS+nfzdjmYsAR7AdgdiFCIxzVwvIqFehD8d+fUm5
	MvtLOSXeEMm+tqvxc3t5BwCezod7PteIbdr782EItkfQZJG2TWEUKVaEw4g4SSN1tIH27BIHD4b
	v+7DQSzp2pl5WfdXZKqmgj5q9ssyopX6MGm8t+gk5LqgF5DqUSdC8j6JSnv+g9Nxsv+u+X339+f
	vg2u16HZHVA==
X-Received: by 2002:a05:620a:454a:b0:92b:6805:9192 with SMTP id af79cd13be357-92ebb5dd3c2mr173076385a.74.1783355612753;
        Mon, 06 Jul 2026 09:33:32 -0700 (PDT)
X-Received: by 2002:a05:620a:454a:b0:92b:6805:9192 with SMTP id af79cd13be357-92ebb5dd3c2mr173022985a.74.1783355607394;
        Mon, 06 Jul 2026 09:33:27 -0700 (PDT)
Received: from [192.168.8.207] ([45.81.3.233])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90ba4209sm1031297785a.12.2026.07.06.09.33.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 09:33:26 -0700 (PDT)
Message-ID: <cef34271-9dcf-4dab-afc9-d463c21a8503@redhat.com>
Date: Mon, 6 Jul 2026 10:35:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 5/8] mm/khugepaged: Refactor the PTE state checks into a
 helper
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260706154500.39178-1-npache@redhat.com>
 <20260706154500.39178-6-npache@redhat.com>
In-Reply-To: <20260706154500.39178-6-npache@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QpcGTfeQbmXz4PIxy_HIdGv1VX7Ca0Yle_c2dxy6NdY_1783355613
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AABF54000B
X-Stat-Signature: rr7n34u6tdeceg4ffwqxep7ppcjnu7a4
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783355615-527234
X-HE-Meta: U2FsdGVkX1+StfbY1jMnfE+PEmDU6zzGaLQ7XCCDV1JB96b2iGaCisUwVv8YtKIWintn5uYsQB+sE16SSIYysLI/Yw2rXFvuF5upH+aXulBwgV8etk9WzlaWCjSFTREUjWZTLeVCX9unN6Dh5jBzmDEwHj/63khu+WMMLSWwpBaJMPeM6ZvXLQTaJ/4rZSDBJKKd9HAYfu2QZ5cL6sgGiAgrKUs4OJom5CNI4/FuzkpbS0bg32ZMbnjsflCOUntXmO1MItOVhL80NAVy+0NP8GRLRA2PblpvQQbDIMpE2jMndgYo510lZta9k2ub2jxrOUWZLfA4U8A4doL2Wx1+8pBvUPmj7yltqE1GhU+u7HD+MFC07hSxtCgZ0Yk/tXUkoTZsO71/oTYU/uSK396UlsPA7re4K1k72fWD/uJBLiq6KnvBT2MtKnNr4bjIzHUfAKGUbqfXwd1qQTBaAwiNOY1OAHpBVr2eV1rxEjisX+mGqcENnlX9ZcsBp5UY3eUd0w1ndlUn/yAyJcV6ps7GKXCDfso2z8ICqW8V814gCgUd3L79/tqNOnHEW4vxhvU5JXw/z17n9SaTeru4ErKTjOTneiumlZJjfwbqtWy7gyF1N6fCs0HbuP61wpuRSvDdZP73pcV+0t+KVFG8arpH94jkPLp+VBnqKCMAE1aHgha4wItLSUdWgiwZdLo5FSt+ItgSw0BYGdGT9bBOeBq+6DtF1WAkpZ7FxRPI/Uogsc352Cs87dmzFDcf4mBaVMV/RZrzkz7hH/jtrsopxAWidwL2k0yTKbAk0Jia3qN0xMoAEPs3iGMs2th2jxaGi5ZzCzBdtxU09tzOXJbLpvIbpfrN+8V2sy393KsMPscqY/1mJf697fQLMLFqGFvvdZhPxobx+fInE+DfP4+9vhhrhwFk0ueR4IDxtdFcXfzHwTU24k/gGtI0iZ5dOyQhjLl6HoKfdGeF1JUW1davTJc
 3a9m+sXi
 nnmOKHhFkQAmyo5gihKLOwRAsZkkXPqkv/vPsHbG9zhgsuy/s3D9d/nPb9oBD2NVdHp/haToZ/WaMUDlnmL+7gURa71GBt5GibljxtTk/f3GZWr6QACwbl4mepRo8gyojvuZa84DGog9DIaSRgZqG+wj9K5j7IsJQQAPZF1GikReSyOazwhaqlDbQteUHRZGwghH9b0hbFaifQ1cSO+968g3+Ztj08jXk2BPFybKPJJYnwvD9LPpZTLLc1G6IiQmbz6cPXVByLKV3ZojTV0VTZi9uyRK0keKZLWVy4jwtk9y+V5Jn66mlgViVj6+Gd0mYTHF4HDL1H3U0u4pwlt9hrG9Rrxn4eT7n5Wt9Plxh/knoB0cg/iaAppjZ+OIGhlG1nmLPSLkj65Wuzc2g+RRei9zgqJPOPXhyiLbg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Mon, Jul 6, 2026 at 9:45 AM Nico Pache <npache@redhat.com> wrote:
>
> For anonymous collapse, the collapse_scan_pmd() and
> __collapse_huge_page_isolate() functions share a large portion of their
> logic. These functions both check the state of the PTEs and verify the
> following:
>         - max_pte_* values are not exceeded
>         - uffd is not active
>         - lazyfree properties
>         - non-anonymous
>
> Merge these checks into a helper collapse_check_pte() to reduce code
> duplication. We also add a helper struct for this function called
> pte_check_context which allows us to pass the required parameters in a
> clean and elegant manner.
>
> A helper function is also introduced pte_check_fail() to provide a clean
> interface to set the pte_check_context failure results and return
> PTE_CHECK_FAIL state. This helps reduce code duplications across the new
> collapse_check_pte function.
>
> Two slight modifications are done to the original functionality. We now
> warn (instead of crash) if the anon test fails, and we leverage the
> vm_normal_folio function instead of page->folio, this should be
> functionally equivalent.
>
> No other functional changes intended.
>
> This patch is heavily based off work done by Lance Yang, but modified to
> deal with conflicts and feedback received during the review cycle [1].
>
> [1] https://lore.kernel.org/all/20251008043748.45554-1-lance.yang@linux.dev/
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 295 +++++++++++++++++++++++++-----------------------
>  1 file changed, 155 insertions(+), 140 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 676f75773a6c..c4ea2dc1591b 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -63,6 +63,12 @@ enum scan_result {
>         SCAN_PAGE_DIRTY_OR_WRITEBACK,
>  };
>
> +enum pte_check_result {
> +       PTE_CHECK_SUCCEED,
> +       PTE_CHECK_FAIL,
> +       PTE_CHECK_CONTINUE,
> +};
> +
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/huge_memory.h>
>
> @@ -117,6 +123,20 @@ struct collapse_control {
>         DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
>  };
>
> +struct pte_check_context {
> +       struct collapse_control *cc;
> +       struct vm_area_struct *vma;
> +       unsigned int order;
> +       struct folio *folio;
> +       int none_or_zero;
> +       int shared;
> +       int unmapped;
> +       enum scan_result result;
> +       unsigned int max_ptes_none;
> +       unsigned int max_ptes_swap;
> +       unsigned int max_ptes_shared;
> +};
> +
>  /**
>   * struct khugepaged_scan - cursor for scanning
>   * @mm_head: the head of the mm list to scan
> @@ -700,74 +720,130 @@ static void count_collapse_event(unsigned int order, enum vm_event_item vm_event
>         count_mthp_stat(order, mthp_event);
>  }
>
> +/*
> + * pte_check_fail() - A simple helper to set the pte_check_context result and
> + * return PTE_CHECK_FAIL.
> + */
> +static enum pte_check_result pte_check_fail(struct pte_check_context *ctx,
> +               enum scan_result result)
> +{
> +       ctx->result = result;
> +       return PTE_CHECK_FAIL;
> +}
> +
> +/*
> + * collapse_check_pte() - Check if a PTE is suitable for collapse
> + *
> + * Check if a PTE is suitable for collapse based on the following criteria:
> + * - max_pte_* values are not exceeded
> + * - uffd is not active
> + * - lazyfree properties are not present
> + * - only anonymous pages are present
> + *
> + * a helper struct pte_check_context is used to pass and store relevant
> + * information between the collapse_check_pte() function and the caller.
> + *
> + * Return: PTE_CHECK_SUCCEED if the PTE is suitable for collapse,
> + *         PTE_CHECK_FAIL if the PTE is not suitable for collapse,
> + *         PTE_CHECK_CONTINUE if the scan should continue to check the next PTE.
> + */
> +static enum pte_check_result collapse_check_pte(pte_t pteval,
> +               unsigned long addr, struct pte_check_context *ctx)
> +{
> +       if (pte_none_or_zero(pteval)) {
> +               if (++ctx->none_or_zero > ctx->max_ptes_none) {
> +                       count_collapse_event(ctx->order, THP_SCAN_EXCEED_NONE_PTE,
> +                                       MTHP_STAT_COLLAPSE_EXCEED_NONE);
> +                       return pte_check_fail(ctx, SCAN_EXCEED_NONE_PTE);
> +               }
> +               return PTE_CHECK_CONTINUE;
> +       }
> +       if (!pte_present(pteval)) {
> +               if (ctx->unmapped == -1)
> +                       return pte_check_fail(ctx, SCAN_PTE_NON_PRESENT);
> +               if (++ctx->unmapped > ctx->max_ptes_swap) {
> +                       count_collapse_event(ctx->order, THP_SCAN_EXCEED_SWAP_PTE,
> +                                       MTHP_STAT_COLLAPSE_EXCEED_SWAP);
> +                       return pte_check_fail(ctx, SCAN_EXCEED_SWAP_PTE);
> +               }
> +               if (pte_swp_uffd_wp_any(pteval))
> +                       return pte_check_fail(ctx, SCAN_PTE_UFFD_WP);
> +               return PTE_CHECK_CONTINUE;
> +       }
> +       /*
> +        * Don't collapse if any of the small PTEs are armed with uffd
> +        * write protection. Marking the new huge pmd as write protected
> +        * could bring userfault messages that fall outside of the
> +        * registered range.
> +        */
> +       if (pte_uffd_wp(pteval))
> +               return pte_check_fail(ctx, SCAN_PTE_UFFD_WP);
> +
> +       ctx->folio = vm_normal_folio(ctx->vma, addr, pteval);
> +       if (unlikely(!ctx->folio) || unlikely(folio_is_zone_device(ctx->folio)))
> +               return pte_check_fail(ctx, SCAN_PAGE_NULL);

Sashiko brought up that by converting this to vm_normal_folio we are potentially
causing checks on incorrect metadata.

This claim is invalid due to ZONE_DEVICE pages being properly initialized.

> +
> +       /*
> +        * If the vma has the VM_DROPPABLE flag, the collapse will
> +        * preserve the lazyfree property without needing to skip.
> +        */
> +       if (ctx->cc->is_khugepaged && !(ctx->vma->vm_flags & VM_DROPPABLE) &&
> +           folio_test_lazyfree(ctx->folio) && !pte_dirty(pteval))
> +               return pte_check_fail(ctx, SCAN_PAGE_LAZYFREE);
> +
> +       if (folio_maybe_mapped_shared(ctx->folio)) {
> +               /*
> +                * TODO: Support shared pages without leading to further
> +                * mTHP collapses. Currently bringing in new pages via
> +                * shared may cause a future higher order collapse on a
> +                * rescan of the same range.
> +                */
> +               if (++ctx->shared > ctx->max_ptes_shared) {
> +                       count_collapse_event(ctx->order, THP_SCAN_EXCEED_SHARED_PTE,
> +                                       MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> +                       return pte_check_fail(ctx, SCAN_EXCEED_SHARED_PTE);
> +               }
> +       }
> +
> +       if (!folio_test_anon(ctx->folio)) {
> +               VM_WARN_ON_FOLIO(!folio_test_anon(ctx->folio), ctx->folio);
> +               return pte_check_fail(ctx, SCAN_PAGE_ANON);
> +       }
> +       return PTE_CHECK_SUCCEED;
> +}
> +
>  static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>                 unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
>                 unsigned int order, struct list_head *compound_pagelist)
>  {
> -       const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, order);
> -       const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, order);
>         const unsigned long nr_pages = 1UL << order;
> -       struct page *page = NULL;
>         struct folio *folio = NULL;
>         unsigned long addr = start_addr;
> -       pte_t *_pte;
> -       int none_or_zero = 0, shared = 0, referenced = 0;
> +       pte_t *_pte, pteval;
> +       int referenced = 0;
>         enum scan_result result = SCAN_FAIL;
> +       enum pte_check_result pte_check;
> +       struct pte_check_context ctx = {
> +               .cc = cc,
> +               .vma = vma,
> +               .order = order,
> +               .unmapped = -1, /* don't check swap PTEs */
> +               .max_ptes_none = collapse_max_ptes_none(cc, vma, order),
> +               .max_ptes_shared = collapse_max_ptes_shared(cc, order),
> +       };
>
>         for (_pte = pte; _pte < pte + nr_pages;
>              _pte++, addr += PAGE_SIZE) {
> -               pte_t pteval = ptep_get(_pte);
> -               if (pte_none_or_zero(pteval)) {
> -                       if (++none_or_zero > max_ptes_none) {
> -                               result = SCAN_EXCEED_NONE_PTE;
> -                               count_collapse_event(order, THP_SCAN_EXCEED_NONE_PTE,
> -                                               MTHP_STAT_COLLAPSE_EXCEED_NONE);
> -                               goto out;
> -                       }
> -                       continue;
> -               }
> -               if (!pte_present(pteval)) {
> -                       result = SCAN_PTE_NON_PRESENT;
> -                       goto out;
> -               }
> -               if (pte_uffd_wp(pteval)) {
> -                       result = SCAN_PTE_UFFD_WP;
> -                       goto out;
> -               }
> -               page = vm_normal_page(vma, addr, pteval);
> -               if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
> -                       result = SCAN_PAGE_NULL;
> -                       goto out;
> -               }
> -
> -               folio = page_folio(page);
> -               VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
> -
> -               /*
> -                * If the vma has the VM_DROPPABLE flag, the collapse will
> -                * preserve the lazyfree property without needing to skip.
> -                */
> -               if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
> -                   folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
> -                       result = SCAN_PAGE_LAZYFREE;
> +               pteval = ptep_get(_pte);
> +               pte_check = collapse_check_pte(pteval, addr, &ctx);
> +               if (pte_check == PTE_CHECK_FAIL) {
> +                       result = ctx.result;
>                         goto out;

Sashiko also brought up that we only set the local folio variable in the case of
a successful check, which can lead to tracepoints using the incorrect folio.

>                 }
> +               if (pte_check == PTE_CHECK_CONTINUE)
> +                       continue;
> +               folio = ctx.folio;
>
> -               /* See collapse_scan_pmd(). */
> -               if (folio_maybe_mapped_shared(folio)) {
> -                       /*
> -                        * TODO: Support shared pages without leading to further
> -                        * mTHP collapses. Currently bringing in new pages via
> -                        * shared may cause a future higher order collapse on a
> -                        * rescan of the same range.
> -                        */
> -                       if (++shared > max_ptes_shared) {
> -                               result = SCAN_EXCEED_SHARED_PTE;
> -                               count_collapse_event(order, THP_SCAN_EXCEED_SHARED_PTE,
> -                                               MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> -                               goto out;
> -                       }
> -               }
>                 /*
>                  * TODO: In some cases of partially-mapped folios, we'd actually
>                  * want to collapse.
> @@ -844,13 +920,13 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>                 result = SCAN_LACK_REFERENCED_PAGE;
>         } else {
>                 result = SCAN_SUCCEED;
> -               trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
> +               trace_mm_collapse_huge_page_isolate(folio, ctx.none_or_zero,
>                                                     referenced, result, order);
>                 return result;
>         }
>  out:
>         release_pte_pages(pte, _pte, compound_pagelist);
> -       trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
> +       trace_mm_collapse_huge_page_isolate(folio, ctx.none_or_zero,
>                                             referenced, result, order);
>         return result;
>  }
> @@ -1616,24 +1692,30 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>                 struct vm_area_struct *vma, unsigned long start_addr,
>                 bool *lock_dropped, struct collapse_control *cc)
>  {
> -       const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
> -       const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
> -       unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
>         enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
>         pmd_t *pmd;
>         pte_t *pte, *_pte, pteval;
>         int i;
> -       int none_or_zero = 0, shared = 0, referenced = 0;
> -       enum scan_result result = SCAN_FAIL;
> -       struct page *page = NULL;
>         struct folio *folio = NULL;
> +       int referenced = 0;
> +       enum scan_result result = SCAN_FAIL;
>         unsigned long addr;
>         unsigned long enabled_orders;
>         spinlock_t *ptl;
> -       int node = NUMA_NO_NODE, unmapped = 0;
> +       int node = NUMA_NO_NODE;
> +       enum pte_check_result pte_check;
>
>         VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>
> +       struct pte_check_context ctx = {
> +               .cc = cc,
> +               .vma = vma,
> +               .order = HPAGE_PMD_ORDER,
> +               .max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER),
> +               .max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER),
> +               .max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER),
> +       };
> +
>         result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>         if (result != SCAN_SUCCEED) {
>                 cc->progress++;
> @@ -1649,7 +1731,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>          * scan all pages to populate the bitmap for mTHP collapse.
>          */
>         if (enabled_orders != BIT(HPAGE_PMD_ORDER))
> -               max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
> +               ctx.max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
>
>         pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>         if (!pte) {
> @@ -1665,81 +1747,14 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>
>                 cc->progress++;
>
> -               if (pte_none_or_zero(pteval)) {
> -                       if (++none_or_zero > max_ptes_none) {
> -                               result = SCAN_EXCEED_NONE_PTE;
> -                               count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_NONE_PTE,
> -                                               MTHP_STAT_COLLAPSE_EXCEED_NONE);
> -                               goto out_unmap;
> -                       }
> -                       continue;
> -               }
> -               if (!pte_present(pteval)) {
> -                       if (++unmapped > max_ptes_swap) {
> -                               result = SCAN_EXCEED_SWAP_PTE;
> -                               count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SWAP_PTE,
> -                                               MTHP_STAT_COLLAPSE_EXCEED_SWAP);
> -                               goto out_unmap;
> -                       }
> -                       /*
> -                        * Always be strict with uffd-wp
> -                        * enabled swap entries.  Please see
> -                        * comment below for pte_uffd_wp().
> -                        */
> -                       if (pte_swp_uffd_wp_any(pteval)) {
> -                               result = SCAN_PTE_UFFD_WP;
> -                               goto out_unmap;
> -                       }
> -                       continue;
> -               }
> -               if (pte_uffd_wp(pteval)) {
> -                       /*
> -                        * Don't collapse the page if any of the small
> -                        * PTEs are armed with uffd write protection.
> -                        * Here we can also mark the new huge pmd as
> -                        * write protected if any of the small ones is
> -                        * marked but that could bring unknown
> -                        * userfault messages that falls outside of
> -                        * the registered range.  So, just be simple.
> -                        */
> -                       result = SCAN_PTE_UFFD_WP;
> -                       goto out_unmap;
> -               }
> -
> -               page = vm_normal_page(vma, addr, pteval);
> -               if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
> -                       result = SCAN_PAGE_NULL;
> -                       goto out_unmap;
> -               }
> -               folio = page_folio(page);
> -
> -               /*
> -                * If the vma has the VM_DROPPABLE flag, the collapse will
> -                * preserve the lazyfree property without needing to skip.
> -                */
> -               if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
> -                   folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
> -                       result = SCAN_PAGE_LAZYFREE;
> -                       goto out_unmap;
> -               }
> -
> -               if (!folio_test_anon(folio)) {
> -                       result = SCAN_PAGE_ANON;
> +               pte_check = collapse_check_pte(pteval, addr, &ctx);
> +               if (pte_check == PTE_CHECK_FAIL) {
> +                       result = ctx.result;
>                         goto out_unmap;

Same here.

The right approach is to always set the local folio variable after
collapse_check_pte.
Here is the fixup

commit 96f7896c359973a759578d2bf300138c31b494a4
Author: Nico Pache <npache@redhat.com>
Date:   Mon Jul 6 10:32:24 2026 -0600

    fixup: always set the local folio after collapse_check_pte()

    If we dont set the local folio to the result from collapse_check_pte()
    we can end up with cases that the goto out will result in pointing to a
    stale folio from the last successful PTE check.

    Signed-off-by: Nico Pache <npache@redhat.com>

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8dd902e546b5..1cc4d864f0e3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -836,13 +836,13 @@ static enum scan_result
__collapse_huge_page_isolate(struct vm_area_struct *vma,
 	     _pte++, addr += PAGE_SIZE) {
 		pteval = ptep_get(_pte);
 		pte_check = collapse_check_pte(pteval, addr, &ctx);
+		folio = ctx.folio;
 		if (pte_check == PTE_CHECK_FAIL) {
 			result = ctx.result;
 			goto out;
 		}
 		if (pte_check == PTE_CHECK_CONTINUE)
 			continue;
-		folio = ctx.folio;

 		/*
 		 * TODO: In some cases of partially-mapped folios, we'd actually


>                 }
> -
> -               /*
> -                * We treat a single page as shared if any part of the THP
> -                * is shared.
> -                */
> -               if (folio_maybe_mapped_shared(folio)) {
> -                       if (++shared > max_ptes_shared) {
> -                               result = SCAN_EXCEED_SHARED_PTE;
> -                               count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SHARED_PTE,
> -                                               MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> -                               goto out_unmap;
> -                       }
> -               }
> +               if (pte_check == PTE_CHECK_CONTINUE)
> +                       continue;
> +               folio = ctx.folio;
>
>                 /* Set bit for occupied pages */
>                 __set_bit(i, cc->mthp_present_ptes);
> @@ -1781,7 +1796,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>         }
>         if (cc->is_khugepaged &&
>                    (!referenced ||
> -                   (unmapped && referenced < HPAGE_PMD_NR / 2))) {
> +                   (ctx.unmapped && referenced < HPAGE_PMD_NR / 2))) {
>                 result = SCAN_LACK_REFERENCED_PAGE;
>         } else {
>                 result = SCAN_SUCCEED;
> @@ -1792,13 +1807,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>                 /* collapse_huge_page expects the lock to be dropped before calling */
>                 mmap_read_unlock(mm);
>                 result = mthp_collapse(mm, start_addr, referenced,
> -                                      unmapped, cc, enabled_orders);
> +                                      ctx.unmapped, cc, enabled_orders);
>                 /* mmap_lock was released above, set lock_dropped */
>                 *lock_dropped = true;
>         }
>  out:
>         trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> -                                    none_or_zero, result, unmapped);
> +                                    ctx.none_or_zero, result, ctx.unmapped);
>         return result;
>  }
>
> --
> 2.54.0
>


