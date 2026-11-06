Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC235606A328
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f9WAyjSe
Received: by kanga.kvack.org (Postfix)
	id CC4226B05BB; Thu,  5 Nov 2026 21:12:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76B06B05BC; Thu,  5 Nov 2026 21:12:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3E146B05BD; Thu,  5 Nov 2026 21:12:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87C9A6B05BB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:12:57 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14B4880C71
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:12:57 +0000 (UTC)
X-FDA: 85403071194.21.184A359
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 485B140009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:12:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=f9WAyjSe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793931175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2NrJEZHpWhPu2W0WafZ8uMlfwRmvxVzRyikkUkgFqo8=;
	b=dXK1yWXP92CY4JvCxDqP1g1cydxzMNbIEn6J+XVmEDcYxJswvtmgJl+B1yyXs2ZBrMioT3
	Zaq2D5dHwv4hoart7LV4tnuX44WNVczHzp/vc4NPDVK//IYWSuhcYvU19LXVwRo/qmjuZE
	IxE22LjjYEnT1qGB4uFPdMpKA4JDFZ0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=f9WAyjSe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793931175;
	b=xQS+VaPOVAg3AQZ5JNMl8Kcd7ExhJ8a7SpHIDCNyNn1yxHSZb+R05x7NAJPyHLxXQbTvih
	lFiDjiidrxSDJUAE+032kCALZbOMwME+4VyprWU3hijhwWmLKlcIcGCwmu0eN3uhpx7640
	gAqDLmahR4q4LNzxmB7w/fj7lirNVn8=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ac77270fbfso78537a91.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 18:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793931174; x=1794535974; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2NrJEZHpWhPu2W0WafZ8uMlfwRmvxVzRyikkUkgFqo8=;
        b=f9WAyjSeQArXTClQTyGhsISP6fFLyf0btr5e4asJPf0IKcJitxIOuVUx914LxCYtPt
         fqbJhmOWukdi69OODiMzPs8n7bZVC2V+p+pfe3vNztCHHhVkhWSaCYgreb7AXZDZT7sI
         TerB2Am0LZrgLLVDRmeIegXZ4hLpmMar1ramA0b0fPY1ONrSjixwguj2jc73LXbgWixi
         6/Q/yW5klrj16XLu752FM3oc7FJ6ZIKedGS8q2iTno7M6qB5VVaJ3/p/vOk+fWtCLqNi
         u+rm9B72YqrRWyHkN3xe+xtv8+WhlkwSAy4g2s9QWgmXA8x+OXqny3svg0uLUECMmgue
         s3wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793931174; x=1794535974;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2NrJEZHpWhPu2W0WafZ8uMlfwRmvxVzRyikkUkgFqo8=;
        b=v2s/X0ZVAcdJN/FAfvTZ/EqgDXBvYeTgxv+uW/6I1ql6+lLj/KYwCvZW+fO0ykOF4o
         W7z3aJLHCK5JsMqQqs7tr8QCP2X4D/2xw7qpKhvNne+lTonS8f0QFwUaCaVVWgSvKkCq
         FNoNvFhhpZaXFurmkW7frcO95CNKZid4XyB74CUvBxHmVbtq3DjDs/yHPlH2/JMQgxFt
         R5Y5IWeJsb6riHjCrqJx5ljALFhdAeKQpFrk6/zDzyb92vh46ce9+MZSDZ7KGhohWvhJ
         xdESgcWh22pSVS9MLcOKf8BcJfGATg86viUDFcfBEzUkmjjVw8R0oIsjAVP9Sku4E6A4
         wkBg==
X-Forwarded-Encrypted: i=1; AL+hErFd4gZ+2znxKFvNTepK+eOQRYdZv0KLFGixiipxyzXXf6endDgG7TZXbAnsuSZwzw3Pemqa5vH7Eg==@kvack.org
X-Gm-Message-State: APuU4Z9N7YOsii7Nb2UI3WOzIdLUUNZ6gX1Or//JApVHvguvo+M1llBS
	W3v90XI38b/iFwrh3bN6Cs73MWak8isLt2lYK/yEXYXb1YR1fibPcCPv
X-Gm-Gg: AYBFou1GA77EtWIc41GfntDVfVaAGcDwsuD5uFeswu/i3VKeXZUX7Eez2IV3oMUkLxF
	CS6QrN+zPeM8vGGSdLTXtL9ahJh/gjZqXozDd3RJFGg5G1y9yTtBotwfHfLKGrr85hTFrjcdYj4
	5AoGSo9wwUu9PwnggrM0HhcxRbMCdEuOJ077B3Htgeu84PDD7Q2Gg/eokIivNp4L9P6D6JeiYzp
	RF0DTVok6BSIhipdq4G6gjGSE97vbMKdH0bvw1aJdXP3xFKCmGe+ZfDp/2O1/H1HVgf66bFrSdh
	DBXVBQsZhHfX/gJbyMK5Fy5GuVQ40+hiAK9szF2nlxQWbTkqAFz3rE12zS7zsZm/hdek5Jcr8tb
	kKSFxlpzmERqRl6vaHvsj763HGBfOSbaUaI/PNRkjdapvwi+dxTHoMoHeoaGUqQKDV+AAb95LkP
	K6Afb0NarxcE3W+ptDFHv4GfhOP64XnlhEZgbXadWht+fU/SrXcpPNgaLag7O4VOBP77NKeTKtk
	Mpv8vUCDRGhw2MjtgkNjOPrGWxWbG6U6Nva19vzU72o9TUFSsf9XL++qgpaV3sH7hJe/Lm99t5r
	NY3GPs9CIpPfuhlJs6GABl2kFEFu44ND1athYkqfiv5vev+z6TX2Y2wkenCJaLxP
X-Received: by 2002:a17:90a:e703:b0:3a4:b0a1:c7ed with SMTP id 98e67ed59e1d1-3b0db6dfb59mr920602a91.13.1793931173907;
        Thu, 05 Nov 2026 18:12:53 -0800 (PST)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b326add7sm5665814a91.8.2026.11.05.18.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 18:12:53 -0800 (PST)
Date: Fri, 6 Nov 2026 10:12:46 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Message-ID: <257ab860-b408-4897-838b-e7b68f981d6c@gmail.com>
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 485B140009
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: rhhx69dc6pu9kxsm1wdoikzuitsn9nei
X-HE-Tag: 1793931175-46428
X-HE-Meta: U2FsdGVkX1+f1Elqb59K+Uut1PTdDjsos6BYmJ3Lf1NJ5liffh1TfK5MCdr9Hjrp50ZErKmvIpauGzJuLLTMolQDHZbGjNrHZbhkNXX7U1eolGTupyyXAQjfA1CBx+qgkTTxld6jrVfZ+a1kkYfsCNbxwaLKKDHkVC/lXVD37wVfkRf1vcfkM/ytpaPHh4AFZCx4AL7MS9nhGIvdQ+yBYctqxWBmx2PLaDTOK7CznesznYXyLzccCxAT23kvvyeuJU+MM6jiXVe7XcbRAOfxg8p5dF2IFlghpIlRJCcUr/nuWHE61XQ1rtarV4W4uKailh68Y0KT32Aj+byg2Cqxsk3YELyba5okW5CsMIbpBxVaMSP1PgS99cnlI/CKLIi1+DGjo+qFfYRRjPB+pECr7pSDCFR3qUNPQpUd1hW7v6OHuBeiQQBRhMzXQ50utk9thilyr/QMrzZKZUGKtUnEeUpbS71LulQbkFYgfjPxDOLM7IZc0DWZ55KJSkyNTadJy69j7uhuT3i8dV2dMdXHgxJyWn8mKcpPZyU5RI8ufVZgtTmoxfBedLpIQKgtlcdPp/s7CmhukS3IBa+oilrnrQepjqWughHi89mTtwFwATzQeLDirGl4Ui94ET2vkWblY+xCVjF9vAzgIuxu1jMAecoEnO3hd2VtGFeABh/r02c52aEzGGO+nUuHFKHGD0kAXkFxpjzX5iO/hAXWVRkg/5vpsObpOk9hZ742o0oIjn0RvclW1Mn5ouPdcJrezXQsEVr44VHrRjrtMk8YHO7Ve/mt1gYpx97SKleNPFpyMAAbHEya2aRQONlIsNDCHegblaVQzH4RJKVb7LIHwpPo7YrNjMoYWAh9M4bR7AFg00Ycmt4glOUwGbrbxtz5q1hCwQRH9MlXCwk10RnfTHQbl3XJDFw2frf0PxfnDrGkquDHn3vgKvp+NprdXXbyQVwwXrjo1yiDwBzcVsWd4vU
 CP6+LS+t
 UFnIKSJhQtZLVtqGwN59gJ17m/trzkav4Dm99aXjavtN32y+vpHDDKtXoZ1DoSTgKideGFlcbALIUsCGdkv+NEBdbUtS5VI+CRoPX6x0Dy89EN8iBTDs+BdgEOKMAXfoyvG7C0+loXO/4Ea7WIVohDd5Mhmxy3e/vTs+uEUFiNhmCMiSxyMhouuAJ3O1p7vgMPzhJ868APtqgDPjPe8LB+it53YAQnANcRPlM5OOpA/nRbVlbWzPpNMUV+BKyssn2aM8lvc2spQ/DfJSb4JSbnWR34XyZyHSj3Q9HDcWXMYkMfqIw6Gn4UWboQr6zNbryXNES1MeIk7d2jkSPFkWiFpZeRuVI3mkVUE43KziuPVTFQWrVO0BPnbsRvQBGI6NyFCB5ZFTUeW6bcaOxYU+zxvzL7gi1tAGizTP3rmgYNyAu+B87IdgNTtIEnCWatYJuc/th2oDgyntq2Wo2CC8urzCAD+YGZX8IcPrBvx6oCpeBhclmlzLHlm8Puq3S8Hl0NJmz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 08:57:24PM +0000, Lorenzo Stoakes (ARM) wrote:
> khugepaged walks an mm's VMAs under the mmap read lock in
> collapse_scan_mm_slot(), checking for ineligible VMAs first, and skipping
> them if encountered.
>
> It charges cc->progress 1 page against the /sys/.../pages_to_scan budget
> when these are encountered, however only checking this budget once an
> eligible PMD-spanning VMA is encountered.
>
> It can therefore hold the mmap read lock for a long time if there are a
> large number of ineligible VMAs present in an mm, over which time no mmap
> write locks (and thus no VMA write locks) can be acquired.
>
> Address this by checking whether the mmap lock is contended after every
> KHUGEPAGED_MAX_VMA_SCAN_BATCH VMAs walked, that is a quarter of the
> pages_to_scan budget, and if so dropping and re-acquiring the mmap read
> lock before resuming the walk from the per-mm cursor.
>
> As the walk is resumed from the cursor rather than the VMA that was current
> when the lock was dropped, the cursor must never move backwards. A VMA
> ending at the top of the address space causes ALIGN() to wrap the cursor to
> zero, so treat such a VMA as the last in the mm rather than skipping past
> it.
>
> This was tested locally with ~1M ineligible VMAs mapped ahead of a
> collapsible region of memory, and resulted in a reduced mmap_lock hold time
> of 170us down from 95ms.
>
> This was also observed to reduce mmap_lock stalls in concurrent threads of
> a similar duration. Note that a reader re-acquiring the lock can currently
> steal it from a writer that is queued but not yet running, so the full
> benefit to writers depends on the separate rwsem change at [0].
>
> Local measurements indicated no change for ordinary use cases, so this is
> all upside.
>
> This work came out of investigations into mmap stalls when getting latency
> numbers for an unrelated patch series.
>
> [0]: https://lore.kernel.org/all/20261105-rwsem-dont-steal-from-queued-writer-v1-1-275e070f426f@kernel.org/
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/khugepaged.c | 31 +++++++++++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 2 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 216c4b8d28c4..eaa01dae5a03 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -66,6 +66,12 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>
>  static struct kmem_cache *mm_slot_cache __ro_after_init;
>
> +/*
> + * The number of VMAs to walk before checking for, and relieving, mmap lock
> + * contention, as a function of the pages_to_scan budget.
> + */
> +#define KHUGEPAGED_MAX_VMA_SCAN_BATCH(pages_to_scan) ((pages_to_scan) / 4)
> +

When pages_to_scan to equate 1/2/3, KHUGEPAGED_MAX_VMA_SCAN_BATCH(progress_max)
always to 0, we will never scan anything.

The following code will solve this problem.

#define KHUGEPAGED_MAX_VMA_SCAN_BATCH(pages_to_scan) max((pages_to_scan) / 4, 1)

>  /**
>   * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
>   * @slot: hash lookup from mm to mm_slot
> @@ -2910,6 +2916,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
>  	unsigned int progress_prev = cc->progress;
> +	unsigned int nr_vmas_batch = 0;
>
>  	lockdep_assert_held(&khugepaged_mm_lock);
>  	*result = SCAN_FAIL;
> @@ -2942,15 +2949,35 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
>  	for_each_vma(vmi, vma) {
>  		unsigned long hstart, hend;
>
> +		/* Relieve mmap lock contention after walking a batch of VMAs. */
> +		if (nr_vmas_batch++ >= KHUGEPAGED_MAX_VMA_SCAN_BATCH(progress_max)) {
> +			nr_vmas_batch = 0;
> +			if (mmap_lock_is_contended(mm)) {
> +				mmap_read_unlock(mm);
> +				cond_resched();
> +				mmap_read_lock(mm);
> +				vma_iter_set(&vmi, mm_slot->address);
> +				continue;
> +			}
> +		}
> +
>  		cond_resched();
>  		if (unlikely(collapse_test_exit_or_disable(mm))) {
>  			cc->progress++;
>  			break;
>  		}
>  		if (!collapse_possible_orders(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
> -			/* Unable to collapse, skip to the next candidate. */
> -			mm_slot->address = ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
> +			const unsigned long next =
> +				ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
> +
>  			cc->progress++;
> +			/* Check for overflow. */
> +			if (unlikely(next < vma->vm_end)) {

I think you want it to be like that.

			if (unlikely(next >= vma->vm_end)) {
					  ^^

> +				vma = NULL;
> +				break;
> +			}
> +			/* Unable to collapse, skip to the next candidate. */
> +			mm_slot->address = next;
>  			continue;
>  		}
>  		hstart = ALIGN(vma->vm_start, HPAGE_PMD_SIZE);
>
> --
> 2.56.0
>
>

--
Cheers,
Vernon

