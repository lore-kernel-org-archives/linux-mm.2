Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8323606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 01:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nYfJuhMF
Received: by kanga.kvack.org (Postfix)
	id E50466B03DF; Mon, 19 Oct 2026 21:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01346B03E0; Mon, 19 Oct 2026 21:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3DD96B03E1; Mon, 19 Oct 2026 21:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1D256B03DF
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:50:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B66C140810
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:50:43 +0000 (UTC)
X-FDA: 85341325566.10.6480BC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 89F5380006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:50:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nYfJuhMF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792461041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7E3MYOWZmAqd5n44b4wTDqjDi7qvsZEFmKsEM+R1X9I=;
	b=xfMSpvClcvX0EU05oEbVDBjoYLbXREd19OWquVzuJTvtQgVWp39txcuojH2ujr1px2QrVp
	lfRzA91WC8aPOdn3rn4OOLWaJ/21c1AkoH10yOk7YCuek2eS1X6ix3KvOaKKfT9VWIP9xi
	vBm54cu3BWWvdU3Ncw7AuiA5Pat9zW4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nYfJuhMF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792461041;
	b=BD0fyqMV4mayJGvf9AchJs3a02YKWNxdok53Rmf6NNaGz7B/pQBU04cGVJCYSh7OYOrpMN
	19UkUM8uRQ6arvtRcPt/C3PDLRnH9Ya5YK5TBR89uA3q3/lc5ve0msVW+yU9klXrLfRhQa
	g8HnlFISv9SpdU6qhQgkP8/yjhv5lgY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24FAA602A8;
	Tue, 20 Oct 2026 01:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7601F000C5;
	Tue, 20 Oct 2026 01:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792461040;
	bh=7E3MYOWZmAqd5n44b4wTDqjDi7qvsZEFmKsEM+R1X9I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nYfJuhMF7lVNH8K59PI8SOCo9JhPtzkfmugOIwk/OBLhEZHvcvQAaLetAKbXg+yJ7
	 KseQkgptJXdvJBZGupXNZ+EgKYiNZKWlnjIf8VxiU8xyCCHjTaEeArgkbZgXJuzJJT
	 rKJIidY2vQcPLic1qkRx7yRn0Oz3WeaKIg5jdXE0/3odb12gGsKi8GxM33B9XQQEc0
	 XVmhOgUmuTTf4TOrzg3OQX+4s8A7Tkw+RAt8cNuDxSwq8RaEvVcc2Iz1SVeJx9UbMs
	 7I2MhIodSKTkOvjs1Ctj+g7FxvDOrRhd8VGCgrjzhNDdxlPOr158DZci7RHdwoRLXO
	 E5Hqs+0/KGlLQ==
Date: Tue, 20 Oct 2026 09:30:34 +0800
From: Jisheng Zhang <jszhang@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] riscv: mm: don't let GUP-fast follow entries without
 _PAGE_READ
Message-ID: <atbEOlTjwZ9nr7rG@xhacker>
References: <20261015-riscv-gup-read-fix-v1-1-8cf7f2504029@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261015-riscv-gup-read-fix-v1-1-8cf7f2504029@nvidia.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 89F5380006
X-Stat-Signature: aye3zch1t8wma1bm75is3d4xufkkrq9c
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792461041-361957
X-HE-Meta: U2FsdGVkX1/UXlWTOOT5E3bkDuSxMfqBcn5EhxglD4rFRFdXknXWsrM3lR6/QkTUhlf/7GLX/iFPEwi5s2mBByoEeGnvER/C5jBEdW40gmaVQFFSXem4+QjykD6nLKHZ0G2r8BfGvj5P3/5Rcc0sJf+GKrSb0pvbquiO9XsGag082esyX+sTna+a/gM52J2wUQetPyfHninWaijLgEYmbNHKX/NMAJwJL8qpaqPFnhux8zjsJyIag5cmzek/hu5AObkTGRB4HcOU8/spqo6GStA1DWaeSSh9v82mJiKc867LJlJpL7kG5SXDbZtnhaoozV67y+9Bq90Looge9zKO+DhS/ZMvQQlbZz43kO6sscQ734da5a3yQFsr3OD5tpjoIrWQCwPoADDAqTbMPXJP3M3OlWbJSIAZ6j18p5n+VuyiP82fc7CNcmqamH+WYFQMsBjf/uOts4eydRwcgxcu3PO/aXa8pzAjxs8PfIeIb/Z9vcSZaOBlXBRkLwog3xi0SoauiH6xiSK9K6/ZCD64xsek47LHXW44x3C3htPrkjQ4SP2tUeMhsXw+vx4DppCqn8rT3wEkDHV96HOjrpuezfUmZrTThADu1NsUmJAebz2NKn/V8l2n+JdF+SjhXUa813Pf2UnG1Mjmnjbb0BpWcPZsRfzrIc6kSkCVooVURn7FLyKOphVsrpoI+7SvTEt6ukipap5CwtabrqXxH7xhjuwdSPSNI2EFY/oRGklFO46jTvd8gKvjdWm+Or4ICKmRlnxcFW23eeRJWF5EuTYYtI8wBxmbF/Dp8JKQFD6F4SDujQ4F6MWNWuGKMKTOGb/V3tPBn2GDybnxAkM1bD8GbGJstgPHXk1Jo4wPWY2V1Hp6ME1h2KRSNyrOij1dMnyOrQyjAoCFvi0E/N77+Yd/d0+nxE3z5JlcQV+VieogpmEdtpBAV5krxraJdLdGzK+B4VlvDqHBpUzYnRpoQwh
 Avgvj14j
 zn1nknUjZfdBOZgSQcme5zSYp5mmTnN677wfCObG5QZnqH/iiy7o06gzR5RlHRlxZsCDMTPh+TVVJ2b1gUxNjCVMyL9NNgLWMdMMtR/n/yVLBRACXjTOT8VVcvD8nL5V2rBEYwD2b+9oEc/nnAsGwhmTgOzPt1saRPKKhwVOJvWYTkRQryXlQuVfudLwRMyugtHvxXCRkXiYoFB+dbjZhlHXba5PxCfU1ydIOrj+/ShK1eQlxT7nqrzae3mMBoXvIp0OeHsY7rmCh0O3sfruWyhcm58oGr61SnnjDG0KjGoLDSag5RYRiVvmyWPoXRt+yem4nnPLzJw6nBMyhxamfZNJhCzJYJTyuk/Wifkzj2e8LfHDo7v0uKCOGR6RV7ytHeBGdSismiS5hCtxoT8ABPB0Cv+OuPzfTiM+l+IgWEbW2rUbZooG7xMK1gMW6vmsH89ZLYJmQTZ/pm76RSHscRO50VfuXX6yHRLqkGM4ZLbjy1Bd9kJpiDaBSgBpXa+o5ysNNuCVVJ60o/FuSx5C/Zgefze5GC00jWILmfHK4UwreF6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 15, 2026 at 10:37:44PM -0400, Zi Yan wrote:
> riscv maps PROT_EXEC alone as PAGE_EXEC, which has
> _PAGE_EXEC but not _PAGE_READ, and a writable shadow stack entry is
> XWR = 010, which has _PAGE_WRITE but not _PAGE_READ. riscv uses the
> generic pte_access_permitted(), pmd_access_permitted() and
> pud_access_permitted(), which only check that the entry is present and,
> for a write, writable. So GUP-fast follows both kinds of entries:
> 
> - a read, e.g. from vmsplice() or an O_DIRECT write, can read an
>   execute-only page, which userspace cannot load from;
> - a write, e.g. from an O_DIRECT read, can modify a shadow stack page,
>   as pte_write() is true for it.
> 
> Slow GUP rejects both: check_vma_flags() fails a read from a VMA without
> VM_READ and a write to a VM_SHADOW_STACK VMA, unless FOLL_FORCE is set.
> 
> Fix it by requiring both _PAGE_PRESENT and _PAGE_READ in
> pte_access_permitted(), and using it for pmd_access_permitted() and
> pud_access_permitted() too.
> 
> Requiring _PAGE_PRESENT also stops GUP-fast from following a THP PMD
> invalidated by pmdp_invalidate(). x86, arm64, and powerpc do the same
> thing.
> 
> Fixes: 3f910b7a522e ("riscv: enable HAVE_FAST_GUP if MMU")
> Fixes: c68c2ef9d641 ("riscv/mm: teach pte_mkwrite to manufacture shadow stack PTEs")
> Cc: stable@vger.kernel.org
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20261015-anon_vma_uaf_fix-v1-0-7b977303b42b%40nvidia.com?part=2
> Assisted-by: LLM
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Jisheng Zhang <jszhang@kernel.org>

> ---
> Sashiko found that the riscv pmd_access_permitted() added by the
> lazyfree THP discard rework [1] lets GUP-fast bypass execute-only
> protection. The generic helpers riscv uses today have the same gap, at
> the PTE level too, and the generic pmd_access_permitted() also lets
> GUP-fast follow an invalidated PMD. This patch makes GUP-fast require
> both _PAGE_PRESENT and _PAGE_READ. Requiring _PAGE_PRESENT stops it from
> following a PMD invalidated by pmdp_invalidate(), as x86, arm64, and
> powerpc already do and as the rework relies on.
> 
> While reviewing this patch, an LLM also found that riscv's
> pte_wrprotect() sets _PAGE_READ unconditionally, which turns an
> execute-only entry into a readable one [2], e.g. every execute-only

This issue can be fixed by Nickolai's patch:
https://lore.kernel.org/linux-riscv/20261017162229.796020-1-nickolai@csail.mit.edu/

> hugetlb mapping via make_huge_pte(). That needs a separate fix.
> 
> Link: https://lore.kernel.org/all/20261015-anon_vma_uaf_fix-v1-0-7b977303b42b@nvidia.com/ [1]
> Link: https://elixir.bootlin.com/linux/v7.3-rc7/source/arch/riscv/include/asm/pgtable.h#L409 [2]
> ---
>  arch/riscv/include/asm/pgtable.h | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 40b1ed4f3ea89..f46b742d6dd93 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -372,6 +372,21 @@ static inline int pte_write(pte_t pte)
>  	return pte_val(pte) & _PAGE_WRITE;
>  }
>  
> +/*
> + * GUP-fast only follows entries that are present and have _PAGE_READ,
> + * and leaves the rest to slow GUP, which checks the VMA: an execute-only
> + * entry and a writable shadow stack entry (XWR = 010) lack _PAGE_READ, a
> + * PROT_NONE or invalidated entry lacks _PAGE_PRESENT. Any other writable
> + * entry is readable too.
> + */
> +#define pte_access_permitted pte_access_permitted
> +static inline bool pte_access_permitted(pte_t pte, bool write)
> +{
> +	const unsigned long need = _PAGE_PRESENT | _PAGE_READ;
> +
> +	return (pte_val(pte) & need) == need && (!write || pte_write(pte));
> +}
> +
>  static inline int pte_exec(pte_t pte)
>  {
>  	return pte_val(pte) & _PAGE_EXEC;
> @@ -820,12 +835,24 @@ static inline int pmd_write(pmd_t pmd)
>  	return pte_write(pmd_pte(pmd));
>  }
>  
> +#define pmd_access_permitted pmd_access_permitted
> +static inline bool pmd_access_permitted(pmd_t pmd, bool write)
> +{
> +	return pte_access_permitted(pmd_pte(pmd), write);
> +}
> +
>  #define pud_write pud_write
>  static inline int pud_write(pud_t pud)
>  {
>  	return pte_write(pud_pte(pud));
>  }
>  
> +#define pud_access_permitted pud_access_permitted
> +static inline bool pud_access_permitted(pud_t pud, bool write)
> +{
> +	return pte_access_permitted(pud_pte(pud), write);
> +}
> +
>  #define pmd_dirty pmd_dirty
>  static inline int pmd_dirty(pmd_t pmd)
>  {
> 
> ---
> base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
> change-id: 20261015-riscv-gup-read-fix-d657d67d350a
> 
> Best regards,
> --  
> Yan, Zi
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

