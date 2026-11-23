Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF71606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JIM0+eRo
Received: by kanga.kvack.org (Postfix)
	id 8F3896B05B4; Mon, 23 Nov 2026 06:53:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C9F86B05B5; Mon, 23 Nov 2026 06:53:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 806B26B05C0; Mon, 23 Nov 2026 06:53:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57A466B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:53:59 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9ACE120860
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:53:58 +0000 (UTC)
X-FDA: 85466224956.06.40914A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3D70FC0004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:53:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JIM0+eRo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795434837;
	b=Rk3XOb2atJlGBDdoiGihLK6g+63rSdLphzOGYm28T+VMS6KG8TFLzvsIhFMXjKrmYSo95V
	hmF3fM7dqnbNQOrgrkz7Nhb7dYjkSrvMZiYSZy6o1mQ9bxo5XIsmeyuURVhaYtGF2i0gx9
	AWoPCJVbiG9ZFPYejnlsxMIpJQhZZC8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795434837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtnqsqXHQKuDC8iW2zmEn4j43knd0EsHyQCpFt+z1m4=;
	b=my6USsChrXfN27q3qioywLEIog+CyLJCeZIwOxinx5WOpnGHoeZqRr6NCsLCN4SkDTuwqt
	G5aTRWuJHy3n9cOr7ipuRvGhS9Fbo0RgJrzRGhvO1fekZjbgE+qEZbHriX6CDAKMHWjt7O
	gmFF5sM7xqDTdEr3jO5ssYYobi4MtpE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JIM0+eRo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B5C9C601C7;
	Mon, 23 Nov 2026 11:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3C51F000C6;
	Mon, 23 Nov 2026 11:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795434836;
	bh=rtnqsqXHQKuDC8iW2zmEn4j43knd0EsHyQCpFt+z1m4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JIM0+eRoUDbIDakme8gpu8Dw9+Hw3XPCKCjTUoxiyGyWw4qFYt4lIvhSMKOihxx25
	 U58hML0Fp6d/RR6M9hj4GjDKY2SRaynGZMNJS21V8u9QMhkaS9jKRQ1HqstRF4xNI0
	 K8KaoEWXnH7BKtAcR+hUJ1xyGXFjUwltsRAj7Jx7aACtCnMo9TXzI0FZypxc29tofv
	 r6IjYcYVjPLTQbvgdPXIIcJIvElblOueuZsrsyzehwoEhJyCmqnbwIIiMDti5JFVBm
	 4zAXUpGx5KQwRjK02CGfjHL1ISOb8RExx95fCZZQXfNYsUIoUAmaICpNTouWn317Zu
	 6PKo7++42ebOA==
Date: Mon, 23 Nov 2026 11:53:50 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Qiliang Yuan <qiliang.yuan@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: flush the TLB once per mapping in
 page_vma_mkclean_one()
Message-ID: <awQo2tg9rzMJYCQe@gremlin>
References: <20261123-feat-mm-mkclean-batch-flush-v1-1-7e998ad13251@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123-feat-mm-mkclean-batch-flush-v1-1-7e998ad13251@linux.dev>
X-Stat-Signature: bbuozipcebwgnojazk65tq4dpx4jus18
X-Rspam-User:
X-Rspamd-Queue-Id: 3D70FC0004
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795434837-921303
X-HE-Meta: U2FsdGVkX1/UVcJud9sLth4VgQYOVViD3Sif34ixP+NeSYqntbc83RYXHcxRNGhI5l8xoS24mdGbN0+ysH8aRJQhLc/7mgyck0AZ26HPrEwNg9QY1KXL4c/sxy0VL4osORSqFXEghlgNoKvs/9WVTfKEGbE7/fYQwPFwiBQZ/qwWOPm4lyZqZB5pU8wvz+MckKn9GxemdNDnv8Ec6EkKY7Um/w1vU/Sqd/3wC4zUKIBKUy24ePR8Q182GKos+AjVyIXV/1h/XSDzmQ8v4QArAyXpMgqHmdasCf7uor4bo8RJS+jXfVBa4ugI/ZfxkTNEfbySO/9eIvWkDYPNMlTX+uXIuiThjX+urkaGNgviBUyqXKtk67R+kXydQMEMqrmFYhX8oPUwQq8KtjnlgQWDbYYBiorlRjUvhE/fmLxpK+hAgz1L9lkO5W7Tnw737S7Kljjet+f+LqOIa+0r8RY+YEfP/vUBcrJpivuSRJD4A9FKzp0At4Aw92p9zNYY/ucTGdNPHDv64xx1ZB4pNNuajOHpw3x1uBt5ObokdWjaJzRMD/1AYsHs1B34dnhlaTcsbm+iMDm1VjqoS7lHcxCLqic+dKrLyHUHiFcWinNjXaVK22wyW8dmz4s/kJX0RR3/KqeP2SB+vOIwRp0QENklaalFvKskvNr35AcqtE9JXh43ryV9Wz/2Yq4GcJpW8EJwyBVWYr9OZojdnitHpyZnSP0DGQ5URcg0lwecqDK/wpu9X2yqlpQUsY3CC2gSpC+u5OPhjIAJ8Vzu7yweVeSpgbSgO7xEs7ZkuqLRUgzFjBO07CKdlaNC2KVZ4B6Zj51azW6ovgb/Ny99bSXKJD293e5M9Kr7X5WLLbesgh+1Gh19WeDCagHbeHaUOOJD2ks2KSBU9449Tve4tDI2Oob+1EwEtKRLIIcRHYQidKTLUTGRRfYuRJtqH3JVQPezAgpJEX7KVPv4foZ+NBNoIuT
 4ZDbBXvr
 vceSUIGrt4yc2a4ixYDkHdU1B6wf3gUHJ4e7dJ9hWBXBToMYbmD7ttX0fcEA7riOmXrm45YV2iT3n/8JVNfBcd0+DsRjv27ybtiZn0/ouZ5Lqe1XDD/b1YTD7zJfLNIm9gYGwUiqL0A+qqW6sVK+Wx56BqGzeMqeRmR/u6TlwfZiwvjilS2+Cmid1YA+HNRN/ed2c9kX9lqgdkbl4hdjc5kJN3tpio0A1co9CXcGWEyAdTAnKl9WBtTvlZJlfssv75MbTrstmSkYwHY5jzwYIJvPWCgbIH98evgEYw+QkhFlE6WgpuflJI/qzgvBtUT1KSN6JwKMUogwqJje5wf58wtNRWLb8oQ80t7sA4fCwt2hJzNBf/PVd7Yx0mbvEUVuvvHROH4T8h2le3R+Wjajv+0b4nwPUcH5xI1DfEXuXbpwfNp9Ast+R82iykdCY7IRXylUpHeWlkfcLLXafZhfS1FS4nBWg1KA4yMbogUL8sMNM8mpK3X2skEcMU3gSA7viuey074DAnycDst+rp8asNufYAZAREBtieulGtVWGSd2RvIjfGqtc1fjRFXzc0TJJnErv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 05:41:38AM -0500, Qiliang Yuan wrote:
> Writeback calls folio_mkclean() on every folio it writes, which
> write-protects and cleans each PTE that maps the folio, so that the
> next store through the mapping faults and redirties it.
>
> page_vma_mkclean_one() does this with ptep_clear_flush(), one TLB flush
> per PTE. A large folio mapped by PTEs thus costs as many flushes as it
> has pages, each an IPI to the other CPUs the mm runs on. Writing an
> 8 GiB file through a shared mapping on xfs flushes the TLB 2,097,152
> times for 65,575 folios, and the writer spends about half of its time
> in the IPIs and flushes.
>
> Write-protect and clean the PTEs with ptep_modify_prot_start() and
> ptep_modify_prot_commit(), as change_protection() does, and flush the
> range they cover once after the walk. The flush still happens before
> folio_mkclean() returns: stores through a stale TLB entry complete
> before writeback reads the folio, and later stores fault.
>
> Writing an 8 GiB checkpoint to brd through a shared mapping, one file
> per writer, then msync(), median of 6 runs:
>
>   fs     writers   before (s)   after (s)   change
>   xfs          1         5.57        2.98     -46%
>   xfs          8         5.37        2.10     -61%
>   ext4         1         7.88        3.90     -50%
>   ext4         8         5.10        2.02     -60%
>
> Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>

You are flooding the kernel with patches, 6 series across 4
subsystems over 19 hrs:

https://lore.kernel.org/all/?q=f%3Aqiliang.yuan%40linux.dev

Please don't do that :)

Given the volume both recently and in the past I assume you are using an LLM to
do this, so could you confirm your understanding of the problem (as well as
those of patches sent to other subsystems) and what real-world task you were
doing to identify this issue?

See https://docs.kernel.org/process/generated-content.html especially the
paragraphs at the end.

In general a core team member tends to take over stuff like this.

> ---
>  mm/rmap.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 65646ed6fc453..4c3d9cb47e550 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1127,6 +1127,7 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
>  	struct vm_area_struct *vma = pvmw->vma;
>  	struct mmu_notifier_range range;
>  	unsigned long address = pvmw->address;
> +	unsigned long flush_start = ULONG_MAX, flush_end = 0;
>
>  	/*
>  	 * We have to assume the worse case ie pmd for invalidation. Note that
> @@ -1156,10 +1157,11 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
>  				continue;
>
>  			flush_cache_page(vma, address, pte_pfn(entry));
> -			entry = ptep_clear_flush(vma, address, pte);
> -			entry = pte_wrprotect(entry);
> -			entry = pte_mkclean(entry);
> -			set_pte_at(vma->vm_mm, address, pte, entry);
> +			entry = ptep_modify_prot_start(vma, address, pte);
> +			ptep_modify_prot_commit(vma, address, pte, entry,
> +						pte_mkclean(pte_wrprotect(entry)));
> +			flush_start = min(flush_start, address);
> +			flush_end = max(flush_end, address + PAGE_SIZE);
>  			ret = 1;
>  		} else {
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> @@ -1193,6 +1195,12 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
>  			cleaned++;
>  	}
>
> +	/*
> +	 * Flush the write-protected PTEs once rather than one by one, before
> +	 * the caller writes the folio back, as change_protection() does.
> +	 */
> +	if (flush_end)
> +		flush_tlb_range(vma, flush_start, flush_end);
>  	mmu_notifier_invalidate_range_end(&range);
>
>  	return cleaned;
>
> ---
> base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
> change-id: 20261123-feat-mm-mkclean-batch-flush-686d20219b52
>
> Best regards,
> --
> Qiliang Yuan <qiliang.yuan@linux.dev>
>

--
Cheers, Lorenzo

