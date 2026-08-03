Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B363C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A6D06B00A3; Mon,  3 Aug 2026 08:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 257026B00A4; Mon,  3 Aug 2026 08:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4696B00A5; Mon,  3 Aug 2026 08:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B6EC6B00A3
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:54:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95539A1C39
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:16:40 +0000 (UTC)
X-FDA: 85059856560.08.1086519
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D6A2420010
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:16:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZhilxiHV;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785759398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55xmHsjPqzaGV0ly1LUi624NBcwUFcBTGLs//q+Aif4=;
	b=lPNKJ9quhG6w+jxxoVQThqlbQzVtWDTikgovb9GlnQemCBpJ75IPDijZuKQXqi9NKJTxRT
	q5AaLn/lGlRW3VCX1fwogK0t8e3LCnyxVKB1lovOYEq8nNv2gRIPrKwcSV9RXn9DF/Ng8W
	mE4XtITkYvRrKnp8J9XDL1v/sw5RvpI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZhilxiHV;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785759398;
	b=eopKbNNxxyP+ZneFEGNPLO8yxsxy36guRP4of8AAhPn/xJT1wzhhx2/LkLo/NLov49YlG8
	ZS8LVsCDBill0nch10FSyvPZuS8s6+/BS1GXuI7iSlNEg6tRyUssDMpnm3RvPAkMincVfL
	4bfNHZUALoH15WV/9ECa0QeM34I9AFA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BA2360A81;
	Mon,  3 Aug 2026 12:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0933A1F000E9;
	Mon,  3 Aug 2026 12:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785759398;
	bh=55xmHsjPqzaGV0ly1LUi624NBcwUFcBTGLs//q+Aif4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZhilxiHVcGglLBMt5PIQz/4XhyzmurGW7f7hDst5wFgXLkEJ7Ql4j38SUeUjDtxpo
	 iujYsQK51eOkQ+gMwj9rS2dVQ7eOYOVNnhbZESsOAcqCXH+mx1d/0Fdd9WEzcoiI8c
	 vDP9WGdcT7/uIbYeu3lbftJzQrqcB1xe98RAX036DKn6XJXwFInPs1bs1Ka5WOVZcj
	 h7OmESiRPlzjasLU3dDExgLYViNgbcUhxF4UfAyoDE9r+H+KGPx+tuBH7/2OUI0/u1
	 /x/TJ2Xr65rD94DLz9eth0zXRCVGm6UE64DiY5TolS1I3TuHsCYsINlPMG/kPcDX+W
	 4IjSrT+t9CKJg==
Message-ID: <bf97ed0d-571f-4c61-b761-5b45d435c4c2@kernel.org>
Date: Mon, 3 Aug 2026 14:16:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFT 1/3] mm: export variants of vmf_insert_pfn* for use
 with pfn_mkwrite()
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, Michal Hocko <mhocko@suse.com>,
 Sergio Lopez <slp@redhat.com>, Christian Koenig <christian.koenig@amd.com>,
 Huang Rui <ray.huang@amd.com>, bcm-kernel-feedback-list@broadcom.com,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
References: <20260731164341.1109827-1-pbonzini@redhat.com>
 <20260731164341.1109827-2-pbonzini@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260731164341.1109827-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D6A2420010
X-Stat-Signature: b8fg8k1xzuxqtur3mtc5e3schfe4aa7a
X-HE-Tag: 1785759398-887635
X-HE-Meta: U2FsdGVkX18MEmxrhDLDeJTQqNqmaDFYBcZ4zALi2adMEooHTRsTbaGR0sTFFzSg/yQ0MFVNzTcn9EI6MN6k/AOSp/4IqTriiXss7XxP6guuLNa4HSFU47eMGkANXctYJ6FJq/MUU1Uro3bj8iM7IXH9nbUPa0wXeS3rELByWiVnRt7IQ7UPxJVFMS9vRV9ZbTlQiaTgP8yKQHaynF4B3bDHbt1jK/OXuRSPGJQOAHeVPaYXquDSR1Rqe5mm3L9xhZl45uIFh04Pwm7UCSzt7lRnGHGrPVRgpkW2+nQkGOKEdQEA+hiQEAxaIF3/iOJyqqT9dIikwY034LHiVlRt+RZ81B9Vak2HKS71FyjGYl9lAAP4fFxG2Gs6bSOeb51LvifVDj7yiO7PhztYBlDx5qNqjambA2dBarshveazbjIUCY3Hw0dkpJ92aPRAgG3Pqrc7U7pI4EWaxFWeW6UGrndZfPRTcAE8T0T6rI9ocsGJUyXYQdYJg5vYqZ8VEBpfTWsxskHM4Z3Zu2r2gYKtPAJR/UcQMWbuUtDCANC4PV6XGZvrmKkeIx9YltBZ1jffZjZ6k1ofM7HtPk7CkMUpAFej+NoHTATzmRLuhVlCe5vRQrBQEjFPgp3yAF1HqLOJRo9SQHqDCgqjIXksH1PKK5SYcd19U2BHEtpDpAd/HGKt50tLx9pyh9NKZaZpzfBvzFyvRjiu/XEEyFy/hkF8A2EVyWOP+KjSvKUVQeVcDRYWrTjTroRs3Go+qUSM7BO6l18xnoE557XTPMjwFNJDf1x9ejd2rLtldqzO1bHu1ySWTwgMMgiiDujbyVcYJUXzDyWzAmEukgDgnT51xG2S8RMU3P3WnDJFyFy8bdFYAgTMIOixqGZN1dcRvgH96DlttYyWacef27NehItuV0ZlSmPwoH/yW41s655rHqz1/M4Que4qKa7msyxpV09r9VKSSdKqTifqshIxS1vtla0
 KQ4U7PdS
 aWeTFPp6w01dqdNl0K/AGrjtf1CHpyiBzS1izxPbrg2HQTMOmgsyBQ2R1exzGM9h4OfMHl/+mUzx4K7ny1Ys8O1q342zzxayME20QWIz+lAykuBmZym8NONO70MThPZS21x/4HuysTwEQ6e3qL0y8ml2kAOcOd3nhoFihWeAcw+AnjxHWj/3h86ZymSOxsOpOjUMCfmxw8HITl8Gz34/i7INRxH3z9G0wSNrt9/uJnHvEnx6YNpxpiJWEy+T0l/LLPXuHr4O1J03hg1cMswhn4IehEAvehweDFbO1ahUnPWRcGYjRkZhA0ag4eoWBvss5tY73M5aFRyO5POHhfdFVF2nmKfGQZtQ/97Sp6+2NlT/d1wg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/26 18:43, Paolo Bonzini wrote:
> Right now, users of .pfn_mkwrite() have no way to create a PTE
> that has gone through maybe_mkwrite().  Because vma_set_page_prot()
> will have cleared the writable PTE bit, users of fixup_user_fault()
> will see a read-only PTE and have no clue that the page needs
> a *second* fault to reach its final status.
> 
> Handling this in fixup_user_fault() is problematic: the information
> about the presence of *_mkwrite is only recorded in vma->vm_page_prot,
> which is an opaque pgprot_t, therefore only follow_pfnmap_start()
> knows how to retrieve it.
> 
> There are actually some preexisting functions that suggest how this
> is supposed to be handled, namely vmf_insert_page_mkwrite() and
> vmf_insert_pfn_pmd().  Adjust mm/memory.c to export two more
> functions: vmf_insert_pfn_mkwrite() for the common case where
> vma->vm_page_prot is okay, and __vmf_insert_pfn_prot() when
> really all parameters are needed.  This makes it possible
> to fix drivers that use .pfn_mkwrite together with
> vmf_insert_pfn() and vmf_insert_pfn_prot().
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  include/linux/mm.h |  4 +++
>  mm/huge_memory.c   |  2 +-
>  mm/memory.c        | 75 +++++++++++++++++++++++++++++++++-------------
>  3 files changed, 59 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 34c79b5fcb9b..33c7de36b214 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4551,6 +4551,10 @@ vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>  			unsigned long pfn);
>  vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
>  			unsigned long pfn, pgprot_t pgprot);
> +vm_fault_t vmf_insert_pfn_mkwrite(struct vm_area_struct *vma, unsigned long addr,
> +			unsigned long pfn, bool write);
> +vm_fault_t __vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
> +			unsigned long pfn, pgprot_t pgprot, bool mkwrite);
>  vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
>  			unsigned long pfn);
>  vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index b5d1e9d4463d..2f4dcaa819b7 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1615,7 +1615,7 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
>   * @pfn: pfn to insert
>   * @write: whether it's a write fault
>   *
> - * Insert a pmd size pfn. See vmf_insert_pfn() for additional info.
> + * Insert a pmd size pfn. See vmf_insert_pfn_mkwrite() for additional info.
>   *
>   * Return: vm_fault_t value.
>   */
> diff --git a/mm/memory.c b/mm/memory.c
> index 40997a26846f..7b950be8f511 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2718,6 +2718,34 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>  	return VM_FAULT_NOPAGE;
>  }
>  


[...]

> +vm_fault_t __vmf_insert_pfn_prot(struct vm_area_struct *vma,
> +			unsigned long addr, unsigned long pfn, pgprot_t pgprot,
> +			bool mkwrite)

(We indent two tabs, I assume vmf_insert_pfn_prot uses 3 for legacy reasons after
renamings)

Hm, having a __ function that looks like an internal helper exported to drivers
and then not adding kerneldocs.

Why not simply have

	vmf_insert_pfn_prot_mkwrite()

And add proper documentation?

I guess we could also turn vmf_insert_pfn(), vmf_insert_pfn_mkwrite() and
vmf_insert_pfn_prot() into simple inline functions in the header. And I'd even
say that a single excessive documentation of vmf_insert_pfn_prot_mkwrite()
might be sufficient, and keeping it very short for the wrappers.


> +{
> +	/*
> +	 * Technically, architectures with pte_special can avoid all these
> +	 * restrictions (same for remap_pfn_range).  However we would like
> +	 * consistency in testing and feature parity among all, so we should
> +	 * try to keep these invariants in place for everybody.
> +	 */
> +	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
> +	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
> +						(VM_PFNMAP|VM_MIXEDMAP));
> +	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
> +	BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn));
> +
> +	if (addr < vma->vm_start || addr >= vma->vm_end)
> +		return VM_FAULT_SIGBUS;
> +
> +	if (!pfn_modify_allowed(pfn, pgprot))
> +		return VM_FAULT_SIGBUS;
> +
> +	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
> +
> +	return insert_pfn(vma, addr, pfn, pgprot, mkwrite);
> +}
> +EXPORT_SYMBOL(__vmf_insert_pfn_prot);

If this becomes a dedicated symbol, why not GPL?

-- 
Cheers,

David

