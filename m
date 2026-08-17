Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD1FAC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 17:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2C0F6B087A; Mon, 17 Aug 2026 13:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDC626B087E; Mon, 17 Aug 2026 13:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCAB76B0880; Mon, 17 Aug 2026 13:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FCF26B087A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:35:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B40C120851
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:35:23 +0000 (UTC)
X-FDA: 85111462926.04.7CD3ADB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 09E1814000B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:35:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XTUk2lLm;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786988121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFdQfkrF9IWQwBtpGMM2MAg+txMnWXxTBIf2qu+5h6w=;
	b=BFcM4fG3IAqtMkVKm5Pfz9Lhs5sw115ceBk6J62rqiAr+F2Kv6+9Fu9upB042AnWi12mgt
	HyThdCU7M57XXtnEnSwY5itk++h8qWS0CKx3iny7m2UpBSgPpiln0LwHio5UNKhf4i/9j/
	Vb2QFAOds3rLj+NV1VX57VEdYsBqlQ8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XTUk2lLm;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786988121;
	b=dpI496bhlTPInSx/EQvy2YDRDC4nKvTCiOjizgwZIGamQK1Dxqk0vyyzvuxwa5LpLayb0B
	0FMFtQsjZBCWVbFlSiI857EGkrrROLDnHh2bdZvK0AfCIEt+lwIx7OoMZ/oDASr4iVACb2
	SYLrczWx8RUD8g+6E+IyUZwIoiuGLbI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786988120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dFdQfkrF9IWQwBtpGMM2MAg+txMnWXxTBIf2qu+5h6w=;
	b=XTUk2lLmDdOMk7RUW6urkNn3T4DZHr0znk4ucAUlRx9dZmzo7CdLpu1+GN7JdAysI6mzX+
	FE7d1v97GuwXQUVnVUUY2ZehocLHF0VfugI7AygeFeAs4vVRnkqSJcK9213uNSoMV/TEMM
	monzJoY/yai+e82EpMyALxLtuBsPAt0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-qSdI9OCcNve62WLucX9sXg-1; Mon, 17 Aug 2026 13:35:17 -0400
X-MC-Unique: qSdI9OCcNve62WLucX9sXg-1
X-Mimecast-MFC-AGG-ID: qSdI9OCcNve62WLucX9sXg_1786988117
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-92e82060977so15112785a.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:35:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786988117; x=1787592917;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dFdQfkrF9IWQwBtpGMM2MAg+txMnWXxTBIf2qu+5h6w=;
        b=T8BtQaThHr4+VZ7iWxmvMkXEtNIv1wjzzoXpJH10/pzBscySPHCO/njbMeap/EeQ5b
         tgUn60LbQulSHcFrRPLZQWHmFAwwg1zC7jHbNMksVuXjdtv9gn98e6+6n+ZJt4rUgjuM
         Hyzq2TDRrWwevR8gbvTuYYpCrvTKCbVEKHSKWa5Msgb2/DIJbhoQsilXsC+KkJ4S7ZBC
         AFM4tZkyXwf3RmmEKdG2hmlDjMOPKb9NtM7rVFEEduBx8OZHCzL3Up/0N3TEi8dTmLdw
         OPQdJL3yQIbOC/n6ryGdmotJqg2I9DmfzNBpcOv52s3gPTuItw0NVErcE2bWXpDRuogs
         5N0A==
X-Forwarded-Encrypted: i=1; AHgh+RpZhbgv0/5faT+M7oRRlYNpOC9HkepQ8W5F1s5otk4XNbE/X0hYu8rkXpZBp2gr1F3D3sw/WoEwdQ==@kvack.org
X-Gm-Message-State: AOJu0Yx4niLdnp6eYKH8GkPzAkvbpfQv8tS2hmpib2GziZVDhl4QPlCe
	WVzSkVmPH0pqJZMJb0X4JC4FY3umJHqt7BrznPYpLpKsZlAb52/1FA3Afw0ejHuWuA+E+jiY7wy
	GWQDRSb0uriUCOjza0BHaP/7qIEA2sguJwp14J7vqAqDuEYtS3cna
X-Gm-Gg: AR+sD10U6495H4TBxh/Z17nbQYmfcCeHihNXSK95mI5W9sw8AFwewY0UQlc/tBLHD+f
	VlqgRlXdZB+DVPQlej9dIgIA26wQQFnOqBvO3nDBSU0X0Mkr1S/4OtFHAucpx7OZPJ60AY5/4hG
	1kP0pQgRqVnG/XVGCeZ1aNJVTp5/7G+VHsrfiFPXo48WsX3qYbP75dixgxo49+RVSYl+RNuv3xN
	9H1qMaoMYJcxDyyhcmft5O87ObsW+S0NeO3TS0SjLj1eCKJZdHCWqpZkEsBNe+TKX4I3Q3vaysA
	JTWUqqX35UIZlCRwILlPLrpSVNIk5mHfZdirfcZKvGPDLmTqhDJWPFqQNdVxncayWFq7
X-Received: by 2002:a05:620a:8514:b0:915:9f30:23cb with SMTP id af79cd13be357-937063c9670mr75005785a.0.1786988116555;
        Mon, 17 Aug 2026 10:35:16 -0700 (PDT)
X-Received: by 2002:a05:620a:8514:b0:915:9f30:23cb with SMTP id af79cd13be357-937063c9670mr74995585a.0.1786988115555;
        Mon, 17 Aug 2026 10:35:15 -0700 (PDT)
Received: from x1.local ([174.91.117.74])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937033d2ccdsm94691585a.30.2026.08.17.10.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 10:35:15 -0700 (PDT)
Date: Mon, 17 Aug 2026 13:35:03 -0400
From: Peter Xu <peterx@redhat.com>
To: Natalie Vock <nat@pixelcluster.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org
Subject: Re: userfaultfd wp-async support for (GPU) special mappings?
Message-ID: <aoNGR04WaFkqde8a@x1.local>
References: <d5ea3344-24e7-4834-b743-4dec812ada70@pixelcluster.dev>
MIME-Version: 1.0
In-Reply-To: <d5ea3344-24e7-4834-b743-4dec812ada70@pixelcluster.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8evkPNLgmpbBMwp2cYWmZaLaw0D2mOorREph09ZOnXI_1786988117
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 09E1814000B
X-Stat-Signature: kfgoge6hzfskmsor7j3g8m5xgngn48wj
X-Rspam-User: 
X-HE-Tag: 1786988120-82421
X-HE-Meta: U2FsdGVkX1+eZplA0XFMhlnay7GgwIPZ5JmdMGwNjuLSvphdNdQt+fXX26Y3odQx8XCsZ9qYDktwfLMCyXyfR8BxYNxuACLtvYDulIe2+pB478t0zkxaWAOTYRNMjQF1RCV6ALp7LQ/eRfutKqXncxgQ13zg65KiyKslWsfdHdNSkHfwVeHfEmyKncF5meBy8lnNgHYVYXgDLd9HC45qIyoLtPbw+asqd5ZTgF4ogLZMcVgT11aM+XYkSj9a3ENw2RCN53KiTmX0XgVw0uIxMQ6tcdbtr+Nses9CiQ1DYIlTMpdHujqO5XHnvUhWO3sOx4rDXTxqnw8eEQTIvRH+GitOwVC8mL+dz76IHzhc71E/WpEnf33UfAjAvHjAP2QYxOTclTROdwWNMRkGqALz/5XTr5QyfRHC9hAKDo4EFsa8dToPsHPaGapZiyCh4ARwfelQbJkN3fYXiXIS6Z+d0CVbJZ/WttqF0+GqMDa7y9ChhsLvGsN8iSg/DdwjNCw5Ui7K2HrORpWbVZ3V4+vyZsuNwyvKDtXgwiPwIpiUg/bzvN0NJyNizjOP4ZG1ob+kgKYIO0oul0uHpnd1yTpgImCBQqszzoUfvK4oNwg5Cuq2xN46MYUQUrOK32mEjfo4xBsZnu+r7llZGvWvqYcB347D9FdUCTdti75ujLZNpKRdYdyv5wK+wVPx19FWhs3PS+9KmYzNzZ2sBoLeLz+HqSgnKDcXHlZrPuZ6UeLHG8vDhO858aXH7/1+o6TcX1HSnpfRidCbqf1gt6njmXSSHjZcz+QDfuQsXxGzMyDqKFilV0dsK31x78lxrxGeOc0Jrb0oECahLvKNwhQaMMoa2lJ7XOzzrPhRgvCFg+mgUYzxcPYZkCzmCGUhO2OdGz9FjzaGT8zjmDGI82eGIP9pOI0H4v82gGyZGlMA3zI9klZbktB0wCMfP4lBw7OQnD4OFO2PThCauS2HovoAuTV
 X7LPl7cm
 SodxJVK5kJX61XX6+JqdFzESuwAkCol9CEXpTavjNYaI9ztzWN6E1ms/VE6OQrhgumIGYSJzYmOtW8uQG1L6b6A7LfhWniXnX4W3WLs6VzpCBzhkaj8eUmgDaxKvXRUV5bgksGI9nDYys3Yy/N5KdvTAevjSC1Rrw68MRgx33oJpyawOJGmt3+BPoBkk58gq8TY43pUx+wm3Je6f9FXZ+mIBq4g1HpfPlify0qyF2th42baKHIu3QkIeFqEIkcLl9x3iY35RtVjdH53RaIZVbFLblFw1xhIzmXib3kOC0q0/0Yd7S+XFvdddUQNUm2WZG4keYvHs+9CKV7W5InpbXuVVU/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 11:01:55PM +0200, Natalie Vock wrote:
> Hi all,

Hi, Natalie,

> 
> lately I've been investigating some ways to efficiently query for whether
> particular memory has been written to or not. The functionality I'm looking
> for is pretty much exactly what userfaultfd's wp-async mode exposes, but
> with a twist: The memory I'm interested in is GPU memory mapped into users'
> address spaces.
> 
> The broader context here is writing a "capture/replay" tool for the Vulkan
> graphics API: The tool lives in a .so that is injected into some app at
> runtime (LD_PRELOAD style). All graphics API calls (rendering commands etc.)
> are then intercepted, making a copy of any call parameters and writing
> ("capturing") them to disk. Later, these calls can be read back from the
> file and "replayed", reproducing the exact same sequence of rendering
> commands again (hopefully leading to the same rendering output, too).
> However, one of the commands is a simple wrapper over mmap(), where the
> input is a GPU resource and the output is a mapped pointer for free use by
> applications. To correctly reproduce the behavior of apps using this
> command, the capture/replay tool needs some side-channel to know which parts
> of this mapped memory have been overwritten by the CPU, so that it can
> perform the same modifications when replaying API calls.
> 
> The only part I'm interested here are writes done by the CPU. The GPU may
> also write to the mapped memory itself, but there's no need to track where
> it wrote.
> 
> userfaultfd wp-async tracking would be a pretty great match for this, if
> only it could be made to work with GPU mappings, too. I've been hacking
> around in the kernel and I did get my use case working fairly well with only
> a few modifications:
> 
> First, I mostly-reverted commit 3c58f641e81 ("userfaultfd: prevent
> registration of special VMAs") for rather obvious reasons :)
> Then, all I had to change to get things to work was add handling for
> encountering uffd-wp marker PTEs on a read fault inside insert_pfn(), and
> allow the PM_SCAN ioctl for /proc/<pid>/pagemap to process vmas marked with
> VM_PFNMAP if ioctl only does uffd wp-async bookkeeping.
> 
> I included a complete diff of these changes at the end of this email, but
> their quality is very much proof-of-concept only; it's not remotely in an
> upstreamable state.
> 
> Is this something upstream would consider supporting at all? I'm not
> familiar enough with memory management to judge whether there are
> fundamental pitfalls making this whole idea impossible (but for what it's
> worth, it worked really well on every program I tried capturing/replaying
> :P)

I believe the VM_FAULT_NOPAGE path was used to be overlooked.. bypassing
finish_fault() completely.  It's good to see that we have forbidden SPECIAL
mappings for now.

On the use case alone, it looks like a valid one. Said that, I think it'll
be slightly more involved than what you have proposed below.

> 
> Best,
> Natalie
> 
> ---
> 
> Here's the diff for my dirty hacks making uffd work with GPU mappings, based
> on commit f5098b6bae ("Linux 7.2-rc5"):
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index d32408f7cd5ed..7ac75ac0a7794 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -2426,6 +2426,19 @@ struct pagemap_scan_private {
>  	struct page_region __user *vec_out;
>  };
> 
> +static bool pagemap_exclusively_mark_wp(struct pagemap_scan_private *p)
> +{
> +	return (p->arg.flags & PM_SCAN_WP_MATCHING) && !p->vec_out;
> +}
> +
> +static bool
> +pagemap_exclusively_mark_and_query_wp(struct pagemap_scan_private *p)
> +{
> +	return !p->arg.category_anyof_mask && !p->arg.category_inverted &&
> +	       p->arg.category_mask == PAGE_IS_WRITTEN &&
> +	       p->arg.return_mask == PAGE_IS_WRITTEN;
> +}
> +
>  static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
>  					   struct vm_area_struct *vma,
>  					   unsigned long addr, pte_t pte)
> @@ -2689,7 +2702,9 @@ static int pagemap_scan_test_walk(unsigned long start,
> unsigned long end,
>  		 */
>  	}
> 
> -	if (vma->vm_flags & VM_PFNMAP)
> +	if ((vma->vm_flags & VM_PFNMAP) &&
> +	    !(pagemap_exclusively_mark_wp(p) ||
> +	      pagemap_exclusively_mark_and_query_wp(p)))
>  		return 1;
> 
>  	if (wp_allowed)
> @@ -2844,7 +2859,7 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned
> long start,
> 
>  	lazy_mmu_mode_enable();
> 
> -	if ((p->arg.flags & PM_SCAN_WP_MATCHING) && !p->vec_out) {
> +	if (pagemap_exclusively_mark_wp(p)) {
>  		/* Fast path for performing exclusive WP */
>  		for (addr = start; addr != end; pte++, addr += PAGE_SIZE) {
>  			pte_t ptent = ptep_get(pte);
> @@ -2860,9 +2875,7 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned
> long start,
>  		goto flush_and_return;
>  	}
> 
> -	if (!p->arg.category_anyof_mask && !p->arg.category_inverted &&
> -	    p->arg.category_mask == PAGE_IS_WRITTEN &&
> -	    p->arg.return_mask == PAGE_IS_WRITTEN) {
> +	if (pagemap_exclusively_mark_and_query_wp(p)) {
>  		for (addr = start; addr < end; pte++, addr += PAGE_SIZE) {
>  			unsigned long next = addr + PAGE_SIZE;
>  			pte_t ptent = ptep_get(pte);
> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe923..a06a31f7f45cc 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2698,6 +2698,10 @@ static vm_fault_t insert_pfn(struct vm_area_struct
> *vma, unsigned long addr,
>  			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
>  			if (ptep_set_access_flags(vma, addr, pte, entry, 1))
>  				update_mmu_cache(vma, addr, pte);
> +		} else if (pte_uffd_wp(entry)) {
> +			entry = pte_mkspecial(pfn_pte(pfn, prot));
> +			entry = pte_mkuffd_wp(entry);
> +			goto out_set_pte;
>  		}

I don't think I understand how this current patch works so far at least
here..  Logically this path should need to at very minimum take care of pte
markers, which async uffd-wp tracking requires.  I think it means we may
need to pass *vmf over to check orig_pte, atomically install the pte with
the knowledge of what is orig_pte, especially if it was a marker.

Maybe in your case the pfnmap VMA doesn't dynamically do .fault()s, but
install the pgtables either with remap_pfn_range(), or something always
populated in mmap() time?  If all the entries were populated at pte level
properly, uffd-wp could have worked all fine indeed even for pfnmap.
However it may not work fine with pfnmaps that either allow ptes to be
dynamcally faulted in, or being zapped and repopulated somehow.

Currently, for any holes that are tracked (e.g. pfnmaps that can lazily be
faulted into the pgtable with fault()s), the async uffd-wp tracking relies
on the pte markers installed in the pgtables when wr-protection happened
without a mapping.

To support pfnmap with uffd-wp async in a generic way, IIUC we need to make
sure all VM_FAULT_NOPAGE users be able to properly process pte markers with
uffd-wp bit set, then install a RO+UFFD_WP pte instead, leaving the rest
processing to do_wp_page().

That's why the current change of insert_pfn() doesn't look like to have
achieved what is needed to me.  The other thing is, insert_pfn() may also
not be the only path that can be used by pfnmaps.  E.g. I saw at least
insert_page_in_batch_locked() that may need similar care.

So supporting pfnmaps with uffd-wp async tracking might be more challenging
to be done in one shot, and that may need careful look.  We need to make
sure all paths like that to be properly covered, and AFAIU it's not easy,
because VM_FAULT_NOPAGE can be randomly used in special drivers.. unlike
the other normal case where __do_fault() will bring back a page within
vmf->page, then finish_fault() will do the pgtable job in one place.

Nowadays, with vm_uffd_ops, maybe one viable approach is to allow drivers
opt-in with uffd-wp on pfnmaps, that might be slightly easier to achieve
with a custom .can_userfault() after justifying the driver works, either
the driver should make sure all pfnmaps will be populated upfront and never
zapped, or the driver should be able to identify things like pte markers
when injecting pfnmaps.

Thanks,

>  		goto out_unlock;
>  	}
> @@ -2710,6 +2714,7 @@ static vm_fault_t insert_pfn(struct vm_area_struct
> *vma, unsigned long addr,
>  		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
>  	}
> 
> +out_set_pte:
>  	set_pte_at(mm, addr, pte, entry);
>  	update_mmu_cache(vma, addr, pte); /* XXX: why not for insert_page? */
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index c3adedaaf7d54..aa1553ec5a3bb 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2114,8 +2114,8 @@ static bool vma_can_userfault(struct vm_area_struct
> *vma, vm_flags_t vm_flags,
>  	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
>  		return false;
> 
> -	if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
> -		return false;
> +	//if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
> +	//	return false;
> 
>  	vm_flags &= __VM_UFFD_FLAGS;
> 
> -- 
> 2.55.0
> 
> 

-- 
Peter Xu


