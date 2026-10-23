Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A07FB606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 18:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Em6Da7KA
Received: by kanga.kvack.org (Postfix)
	id A489A6B0BC5; Fri, 23 Oct 2026 14:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D22E6B0BC6; Fri, 23 Oct 2026 14:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A966B0BC7; Fri, 23 Oct 2026 14:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 574936B0BC5
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:11:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9BDAA1601AD
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:11:46 +0000 (UTC)
X-FDA: 85354684212.08.5C74933
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 22D8410000D
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:11:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Em6Da7KA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792779104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OER7OiM3baakXk7yT31L3dFSCqe76IjxgAS+7zkqevo=;
	b=J3nhLGmNlHt7M03fkKGy42Laif3Rjn7gpWn6I/TK+hE4XYepCUq2RU8ZHiZDWIh6jzd3Lf
	Ue8Kf00hPgccumUU3xSv1xC91SCkPH2zwhqIg3hJl1/B7YAANYdbG0HeNR/6wB01CRR+oD
	bSSx2aoGme0wnxEr0Gb8/ZByf72sGLA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Em6Da7KA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792779104;
	b=waY5mzuN3wHXALRaMG3vTt59kbkJw2rjUbhL3ONDnIrR7oQNt+dmjJL6Mw6+zBbzYQop6l
	GbwjTckunPxnMpmHAutJyM71G6cAERkXKWiq14X7/ZOjJ00hJ5zAz09z7W4VJBBUvanBqJ
	v7a6j5qAm9rovJsVXtaFRzM7zpixYPg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792779103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OER7OiM3baakXk7yT31L3dFSCqe76IjxgAS+7zkqevo=;
	b=Em6Da7KAdkjGvpkiw/HLt72foCTy0Z/L/Xx9V9UN6vqLsti1l/qXcnKgaq5U+g1/nmkQLY
	Me8rtJ2HYhuebjLfq3XtujU6QSkg0f2w4DdSVPxJyqPWTepqCwN9nNRkCshdKFj4hwI+76
	LCT0G+rVK9FwtjEhDEMiraOCDLXKw/Q=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-4VaKfwUMP1W0NKXIdDk6yA-1; Fri, 23 Oct 2026 14:11:42 -0400
X-MC-Unique: 4VaKfwUMP1W0NKXIdDk6yA-1
X-Mimecast-MFC-AGG-ID: 4VaKfwUMP1W0NKXIdDk6yA_1792779101
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91bc57d4d11so29511996d6.1
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:11:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792779101; x=1793383901;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OER7OiM3baakXk7yT31L3dFSCqe76IjxgAS+7zkqevo=;
        b=jHJdsv/XHdiYK4pNC94jHC3qmWtHNJIoL1EmYizpgRS2pWCOHmF4kgEK2SJ5oXD8Sk
         KN9bjzSm4vwP/CUNCmdY9UZVgdpYdT6+15D7qP+vVVRDsiMouUFWtgAC8RW+avhMWoEM
         xRrJ5EffktfGJ7F2BC8LWc+nzUj4QF/nE2Uo/6dXKuZJt3Gny+I/5/zZiM8bO+sLPjtk
         2+qditWrtxXbfyXkgKfWVzMF9R6nHQD8ZV0LXwL4N0tKZ6Suru2g+gglwc8uF7n4Wn2t
         7n6ViqzsPPULS+nB2Ti06CwrQF4uLqgsoKls2eMJRaBEarvBUzovaLUX4cMBEUnfWA6Y
         ROGQ==
X-Gm-Message-State: AFq9FYJR8M9Kwr1on+mz5HIz29jHFWJtF07n17vpObS4mWUb7cdiEWAu
	Tich31gjxGzcipRbGVFA8To1ROLDcOyQ2nmyFGpu2rgNhaQY/Val5NnMkTCg886rTutWp/ZOCk5
	LwzEgoMyR0oCFw/7CKeAhcWPSlwO8VVLKXzIcQ1ai6nZ5D0AkatAP
X-Gm-Gg: AYBFou2U+jr6TnlVHd3YfuUNWz7bk6zTqB/oORoYPYNxCu8ZIGo1CjDvoJUuS3+hzU+
	iD+3bGdqHQR7v4+OfbNXpPIbVirqB13FH2UatmDQTH+UpFqwydtKMaUNitW19GlN+8kdhCcBQBW
	yhydMOdxafPaIzA2SPWSyeHv0nbbjd6J3Hp0sCXxk9K+71PvmcV/rfGdL/vanPv7F2QctKEYCQg
	TvaZyi1dkUXqayTnETkVBQA1iglowu8pj0bgrt6sCoc5k9qfNAeOxHxIWEtQVo97lJSM3wqgqlS
	/vF5i6wGatOA6thqvynsLQLP8EGiFydaQyrBlckpYlJnr2yAw4yR9yakbpVx1+Q35Iuas5FyCrT
	GMFk=
X-Received: by 2002:a05:622a:1394:b0:536:cda:d3b0 with SMTP id d75a77b69052e-536c2923e1fmr44456851cf.75.1792779101101;
        Fri, 23 Oct 2026 11:11:41 -0700 (PDT)
X-Received: by 2002:a05:622a:1394:b0:536:cda:d3b0 with SMTP id d75a77b69052e-536c2923e1fmr44456341cf.75.1792779100422;
        Fri, 23 Oct 2026 11:11:40 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-538394c5273sm448581cf.9.2026.10.23.11.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 11:11:40 -0700 (PDT)
Message-ID: <44a9f234-aeed-4986-8660-608b8a23ecdc@redhat.com>
Date: Fri, 23 Oct 2026 14:11:39 -0400
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vma: fix expansion of VMA_MIXEDMAP_BIT VMAs
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 =?UTF-8?Q?Jakub_Mat=C4=9Bna?= <matenajakub@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261023-vma-expansion-fix-v1-1-6142baf1f46b@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20261023-vma-expansion-fix-v1-1-6142baf1f46b@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 40yZ1laT7vsy_zVWdxkfRDHSHmcYXmXkzSs4miVGiBA_1792779101
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 22D8410000D
X-Stat-Signature: 7ftpktdbze6976uc6una3cefyh9gqrtj
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792779103-888343
X-HE-Meta: U2FsdGVkX1+oqiM64E2ODz9knhEfxLaqycPBYHdjvPnMYJrHBUqpBZ8+hkrp0wfkN2CXEtOMlDLbsgk1NnJORuDGOaMoHNLo2ugtJLEvbgmOZrc8yUVei9XvQks6HQLcxZlDm1cGfodoD50ZurK7OEbXhsNgfbH5f0QvTulrUdkN9XYc9L06U8JferQ179b3YRGGcgilArpzc27qSaRC0TNcSdMhnAiPG9e4phMkwcxtIB2B1dvXRiAU/8OXVmjI7W6AAIlZTLnFilpiBhrhca0QLfesIaadaxBfJxjK0iBX7nmhwem5FU1C31K08NgGGYwF0w8xfGyMuXhhCC6E9KAJtVRCwwJOTPIOamiiRSPwotuejRopk6ON7ZRXbUgmuNYoXi9K2huQWtNlxb0IoPICT0tSqTjtFdch2Ve8D1o2xUsdeEMYVEA9mR8y6q4vdHAQsmYp2dx/EK/t0Bah02aPVhEtUXVBvF4owwX/JhS3kLhGjy9nIizKQHmgcyyG4FZYTvp/rp+yTFINXpRl3cDeDyF5bkC7MVD/bAN2Xe+8L1cbMA53GscXoFhHgpI/hHPTkvnkI7AK/EbhCLfKh0nwJD6tqht5CQWCkeAnEFJu7EM8/jErK5gLtTd+Tyeyx4LltrOkzbgI70bvK923ccIdLWUgRsTZyaRaVq0BHEb1EaBjMi9o5cAYZcHptY43ZRnqEmpbdXoQLmkgSgtLPTHxiLaH3QphC3vWC4XO7mxWGeIrSE0VypWvwew4EqHX9xFS6Qo3xirYDadh/KWOLtGAZd/Z9c87E02YCQWeIxWxzfwzdX+CSd3UPa7/kClwEm73dtMPTsdRGgELQ+Hwft6P6VQtguV06lUTv2Dyrd3AXRbrQ3nK4bsAzL89D+lfUqEEF634HrJ6HGjVKsIt4N/OxZfN7NR8ZWPdBhOd5uZxzRQZcTQFLTMcjBuOMhXEjhyxjFojYbybLHYKqHu
 RyKAFPgS
 K4lsJPCtiVfQW7DieT86/ZaoUBJ5U1rF4MVj1fwz1XYBR+SAxLQtHhJFumh/avmKmWKwtfmCCYrJ3wtP73LAjVYPP6PYWItbuJL3g12n6zUFwTXP7FN04G76CsaO1mSJH/odlV/5agFH7dTGAW0JEzXaVtEZM4jATBdOr4zS/pPuBCDAVK3qd2IaEW2Ly01HCKSfRMcp+t0u1Sx/hxjnMr+5Nt07x4amQ9Rp7bdcuSevb/xTQGFxXz2ZjUkFJ4FjBH8q/aI5bsxJUa0qwZd+nOA1BYotsOUXDUhc3kOuo+Lmap4BiBtCL6ErskSKJGvSL3xgHJCXhamSEfG11VNLw0CzyA4IzomZ2I9keVWREuWto7eLxUFTEfOjEd3L0eIYK32+1LHfCVHTwqLiXUDQAC+VGz3jh9hUmTWwzVMBZZ/vK9j9S42Z3Itbf+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/23/26 11:17 AM, Lorenzo Stoakes (ARM) wrote:
> Commit ca3d76b0aa80 ("mm: add merging after mremap resize") combined
> merging with expansion of mremap()'d VMAs, however it also unintentionally
> disallowed the expansion of unmergeable VMAs.
> 
> Previously it was possible to expand a mixed mapping which mremap() had
> already ensured was a legal expansion.
> 
> This is clearly seen in the mremap() logic, as it checks
> vma_is_fixed_mapping() to determine legality of an expansion rather than
> vma_can_merge().
> 
> Additionally, copy_vma() allows for a failed merge to result in a new VMA
> being instantiated if MREMAP_MAYMOVE is specified.
> 
> However, this is not attempted, as a failure in vma_merge_extend() is
> assumed to be an -ENOMEM failure.
> 
> Since vma_merge_extend() is used exclusively by mremap() to perform a merge
> and/or expansion, resolve the issue by invoking vma_expand() for
> unmergeable VMAs there.
> 
> Explicitly assert that the VMA is both non-fixed and a mixed mapping.
> This provides double insurance against broken changes in future.
> 
> Note that khugepaged_enter_vma() (which vma_merge_new_range() runs) is
> redundant in this case, as a mixed mapping is not subject to khugepaged.
> 
> Also update the VMA userland tests to add a required predicate.
> 
> Reported-by: Luiz Capitulino <luizcap@redhat.com>
> Closes: https://lore.kernel.org/all/20261023023106.515365-1-luizcap@redhat.com/
> Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> Confirmed that this fixes the repro and passes mm selftests and the VMA
> userland tests.

Thanks a lot for the ultra fast fix and for the attention you gave to
this issue.

I tested it the same you did and (of course) it worked. I'll work on
testing it on the environment that reproduced the issue originally, but
this may take a bit. I'll report back if there's anything unexpected.

Another detail is that I see that you CC'ed stable (which is of course
correct, since this reproduces since v6.1) but I guess this fix won't
apply since the VMA code has been changing a lot.


> ---
>   mm/vma.c                        | 19 ++++++++++++++++---
>   tools/testing/vma/include/dup.h |  5 +++++
>   2 files changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index 1be613044b4a..88ef92ab24ec 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -1851,12 +1851,25 @@ struct vm_area_struct *vma_merge_extend(struct vma_iterator *vmi,
>   					struct vm_area_struct *vma,
>   					unsigned long delta)
>   {
> -	VMG_VMA_STATE(vmg, vmi, vma, vma, vma->vm_end, vma->vm_end + delta);
> +	const unsigned long start =
> +		vma_can_merge(vma) ? vma->vm_end : vma->vm_start;
> +	VMG_VMA_STATE(vmg, vmi, vma, vma, start, vma->vm_end + delta);
>   
> -	vmg.next = vma_iter_next_rewind(vmi, NULL);
>   	vmg.middle = NULL; /* We use the VMA to populate VMG fields only. */
>   
> -	return vma_merge_new_range(&vmg);
> +	if (vma_can_merge(vma)) {
> +		vmg.next = vma_iter_next_rewind(vmi, NULL);
> +		return vma_merge_new_range(&vmg);
> +	}
> +
> +	/* Mixed mappings are permitted to be expanded, not merged. */
> +	VM_WARN_ON_ONCE(vma_is_fixed_mapping(vma));
> +	VM_WARN_ON_ONCE(!vma_test(vma, VMA_MIXEDMAP_BIT));
> +	vma_prev(vmi); /* Reposition to start of VMA. */
> +	vmg.target = vma;
> +	if (vma_expand(&vmg))
> +		return NULL;
> +	return vma;
>   }
>   
>   void unlink_file_vma_batch_init(struct unlink_vma_file_batch *vb)
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> index f449129ea97a..e0eab4eca998 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -1727,3 +1727,8 @@ static inline bool vma_flags_can_merge(const vma_flags_t *flags)
>   	 */
>   	return !vma_flags_is_hugetlb(flags);
>   }
> +
> +static inline bool vma_can_merge(const struct vm_area_struct *vma)
> +{
> +	return vma_flags_can_merge(&vma->flags);
> +}
> 
> ---
> base-commit: 2bba28e98578de622ef307d00875aa8f8bca3d10
> change-id: 20261023-vma-expansion-fix-6843391177c4
> 
> Cheers,


