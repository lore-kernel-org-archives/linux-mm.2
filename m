Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F6D4606A89C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WT1C8sty
Received: by kanga.kvack.org (Postfix)
	id 463656B05C0; Wed, 11 Nov 2026 17:50:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EDFA6B05C1; Wed, 11 Nov 2026 17:50:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5EC6B05C9; Wed, 11 Nov 2026 17:50:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7C036B05C0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:50:35 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7ED211A01DC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:50:35 +0000 (UTC)
X-FDA: 85424334030.10.4CA30B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id E0861100003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:50:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WT1C8sty;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794437434;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JM8sbqrYlgMDry6zWHzievP0h2WyCRO0O7Hgtn6Zl/E=;
	b=l9DYAZU9NlsuOcXtFYUQJSV5g+R15Gv8U9uLCOogyHL2vpRIWLGOBsHvG5z7Lzmogr8ZFF
	g19r/VA/QKn3kzLnspyqGV/XrDWhVrshFWItm5crxEJP5eZY/0TIaVbYKr18eq5g3TpcfW
	jgYBdaPNxfk8fjL2QCrzd6dGfc88wEA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WT1C8sty;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794437434;
	b=DsbYlLN0vJFAczMXjZo8aYe5B0JinvstNmngnVkiEWdyXWGG5/zlJzishwcz6S4mp2r5Kc
	n/nkb0eZHztodi5BzS5eXRhiyOp01WH2RHxF8CNpA9lNHSSwnNE3/kIsQF0FEe7zxqj4lc
	jR7bSMoe6Uji3G/Ppis68d1QGdl7tkk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7763965331;
	Wed, 11 Nov 2026 22:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA921F00A05;
	Wed, 11 Nov 2026 22:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794437433;
	bh=JM8sbqrYlgMDry6zWHzievP0h2WyCRO0O7Hgtn6Zl/E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WT1C8styWEhq7LAEGBCmoiGwEVoww+2VJvtBFd/Z+HU2SFBHbWosk4tO2QDKUUVIu
	 19OiaMq0uJ1xGfvUyDtRysk/h6OIvTUEQ+8ULr7vEpLH0gkk7SKvmpd0sbGxgh1QcN
	 k3YJgd/YQbfki/oucyGUhmJuJWcQlwmUspv8xsyL/XTM3P8WCthYNmDjRmr8+KBH8a
	 q8ZPiHv53kHhVxREjf1Nu3EDdtW4/ZINsSJTKGwKEAOSnP3IKcLB2417kxrax7gQkq
	 JwHsokYBj63yGPrabR239rbQWfHQsB5CcfildYHpONviaHxmjiBEmE9Cw8Nbu7qoTV
	 KyTMCcub/+hig==
Message-ID: <sashiko-outbox-209833@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] uio: implement huge_fault support for physical
 mappings
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eliav Farber" <farbere@amazon.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Jann Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>, linux-mm@kvack.org
In-Reply-To: <20261111113045.35368-5-farbere@amazon.com>
References: <20261111113045.35368-1-farbere@amazon.com>
 <20261111113045.35368-5-farbere@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 22:50:32 +0000
X-Stat-Signature: hpd3fsusibnhx9cg4fbyrhg7qwje35ts
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E0861100003
X-HE-Tag: 1794437433-674342
X-HE-Meta: U2FsdGVkX1/HtVjBjPHg2c3HauEvMsMC0H552T3N4DjCm45Y4GTT2aYL9Zys+nNSOyh7IJO6JRpLkBvamaklswVrJ9eeaxxiMkb6+dAEdbiqG34SzPYM4OoqLMAFvf5pRoZHDVAYviTYAwL4xQ/R8XZ53LRU5XmfzWQ6IngNo95QJg0hAIiMr0ZZGiftGAoqXkmwO5lAJMjpCY/FBkpaiKrV+BTpO3F08eE2LCnopnIKo/qdqJfgW2B2SHXy3yj2amn/HB6QiB+dbHs2k8hCdr8n7Byt4MbrPIdkozTZS7l+2Zrlz+hPAmYO3dtXJXpQdDNqu8gptqWmzraR6MetOziJN6zhKRtWG0wP15OmM7GMyvzcQdhqLw9RlE7HNrAH3WlWHjF/lcL/SvNObOSDilkLFVcuofhakvbvoYdOHXx7+0tyYo10dHVUwgDbBB4yvlWxnKv5HWR/U/zDJR8dDZqp1W8lDJPaGNvJStKAAc0J8iNwrAEqN5QffcP/eeQMq38n8Sxy3lP6Ry6me/TMWNoawRrSflfXh6X8kSbPM2u75/+oXPiBTV6Cm4BFggzT0fRtOOimO2sOaEHmO88MS1w6nzebFqaxea1ee5bHMav0GFV2Vu97DZ73aMc6EiG100xLn9lHMqFTaIF5nY67R5GEjMYNBza5HNdGOfs+2Y8AVMNgyO2YpscADbBHFdMtyjFguF25rpoMl0EQgtj0A5MZEde0owbF4A6L87ZQGgar/wEdRx/+IzImVCozuwn51nesCNeQy3e1jTSR3P1iu9C9OLq0rHzQtWtIoFVEEVYR57fv7e4e7UtfKz0gXQ0hwlNKQqnWo2+pecC2Rq/C7jpabxZg9kBsD2POGjraDIxSoSVBuwmkW7zSBsW0cyPhraYddrSVscPJ/aaGGhFhSbavBzN+3ToAvVGRFycPaMfCEZiT/Hqswt3uJk3bQpUdr+kQ9tbJRFnI96QiOfV
 ycLZKuHU
 9jtUVkSNVRRGLoEZ0lnQCPnFU+dIFaN1COSKKOnGbATJK3p2KYFTEzBRbjLmV8apNqSBjI63KQORz8imBbz8ufyOBr0L+5u68scMCA2PIi5QA3TO8+9S+0xP69NAlwNZCYmE1CNJNa8QVv2+VMZ9Vkuti+26py0EZltVn6KuHdYdpuYZe3qUvZGxuo33O8Suphc7eLZ2Qp2vbcQjuHCAE4rwbwKagG2kysJVcx7taCFNkcHmUlXKgfRI/i1uTwn+aAyDsoJqdUw/ELItkTLlv5nAUinKTAErMrpKd6a62x+CQvBgA0Oq00nT9+6inZUW5H/NiOJPRT+0ELu4/oLYNiCBsfmhGBJQeH3UjxcaWnPlwfKtY9+zIQG1M2jPxtR3u4N5QbaTnCnynnzX2vO+UDtRyDFoYhI1+dXF0e/wIOhEdZ9lhxK1/F5Vt8CiNf/9Iy2j1e6saBeTNlv/J8PFwdoT+S9jwNt/Mi6ojZciWIXQRgHXl0LC3X+YVRb/2Kp4QdU3h2TsARtUJcMZjzXtveXlySzM31CW90HGtAiLdYi1zi67pZbdNltGFx7HqgSyipGcMG5GRCUpr4mOP1QFZ4YJxKuOUH4TJicLyQcGYqg/AMUCnB7iyE/ThDTd3jLAdaoAiGjK1Tu6q+XY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] uio: BUG_ON in uio_physical_huge_fault() on COW physical
  mappings
- [Medium] uio: read-only PTE after fixup_user_fault() in
  uio_physical_access()
--

commit 64a7c2da3be318c1019224cd530d155344992a33
Author: Eliav Farber <farbere@amazon.com>

uio: implement huge_fault support for physical mappings

This commit populates non-COW UIO physical mappings on fault via .fault and
.huge_fault handlers using vmf_insert_pfn_order(), while tracking the PFN
range with pfn_range_track() and faulting pages in from .access.

> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index f8fa205226601..6b4c79340e5c8 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -733,9 +733,80 @@ static int uio_mmap_logical(struct vm_area_struct *v=
ma)
>  	return 0;
>  }
> =20
> +/*
> + * Populate UIO physical mappings on fault, using a PMD or PUD mapping w=
here the
> + * architecture, the fault address and the pfn allow it.
> + */
> +static vm_fault_t uio_physical_huge_fault(struct vm_fault *vmf,
> +					  unsigned int order)
> +{
> +	struct vm_area_struct *vma =3D vmf->vma;
> +	unsigned long addr =3D vmf->address & ~((PAGE_SIZE << order) - 1);
> +	struct uio_device *idev =3D vma->vm_private_data;
> +	vm_fault_t ret =3D VM_FAULT_SIGBUS;
> +	unsigned long pfn;
> +
> +	/*
> +	 * vm_pgoff is the base pfn of the mapping (see uio_mmap_physical()).
> +	 * vmf_pfn_order_ok() ignores pfn if the window starts below vm_start.
> +	 */
> +	pfn =3D vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
> +	if (!vmf_pfn_order_ok(vmf, pfn, order))
> +		return VM_FAULT_FALLBACK;
> +
> +	mutex_lock(&idev->info_lock);
> +
> +	if (idev->info)
> +		ret =3D vmf_insert_pfn_order(vmf, pfn, order);
> +
> +	mutex_unlock(&idev->info_lock);
> +
> +	return ret;
> +}
> +
> +static vm_fault_t uio_physical_fault(struct vm_fault *vmf)
> +{
> +	return uio_physical_huge_fault(vmf, 0);
> +}
> +
> +#ifdef CONFIG_HAVE_IOREMAP_PROT
> +/*
> + * generic_access_phys() only follows present PTEs, and a lazily populat=
ed
> + * mapping has none for pages the target has not touched yet. Fault the =
page in
> + * first (through the handlers above, so info_lock is honoured), so that=
 remote
> + * access (ptrace, /proc/pid/mem) keeps working.
> + *
> + * fixup_user_fault() refuses a fault the vma does not permit, so an unt=
ouched
> + * page of a mapping without VM_READ stays unreadable, where the eager m=
apping
> + * left a present PTE.
> + */
> +static int uio_physical_access(struct vm_area_struct *vma, unsigned long=
 addr,
> +			       void *buf, int len, int write)
> +{
> +	unsigned int fault_flags =3D FAULT_FLAG_REMOTE;
> +
> +	if (write)
> +		fault_flags |=3D FAULT_FLAG_WRITE;
> +
> +	/*
> +	 * COW mappings are populated at mmap() time, and a write fault would
> +	 * copy the page instead. With unlocked =3D=3D NULL, fixup_user_fault()
> +	 * keeps the mmap lock held and the vma valid.
> +	 */
> +	if (!vma_is_cow_mapping(vma))
> +		fixup_user_fault(vma->vm_mm, addr, fault_flags, NULL);
> +
> +	return generic_access_phys(vma, addr, buf, len, write);
> +}
> +#endif

[Severity: Medium]
Can a remote write to an untouched page fail with -EINVAL after soft-dirty
bits are cleared via /proc/<pid>/clear_refs?

Writing CLEAR_REFS_SOFT_DIRTY to /proc/<pid>/clear_refs clears VM_SOFTDIRTY=
 on
the VMA and calls vma_set_page_prot(), which strips write permission from
vma->vm_page_prot so soft-dirty tracking can catch writes.  When
fixup_user_fault() then faults an unmapped page at order 0,
vmf_insert_pfn_order() calls vmf_insert_pfn(), which passes mkwrite =3D fal=
se to
insert_pfn() and installs a read-only PTE from vma->vm_page_prot, returning
VM_FAULT_NOPAGE without running wp_pfn_shared().  generic_access_phys() then
sees !args.writable and rejects the FOLL_WRITE access with -EINVAL.

> +
>  static const struct vm_operations_struct uio_physical_vm_ops =3D {
>  #ifdef CONFIG_HAVE_IOREMAP_PROT
> -	.access =3D generic_access_phys,
> +	.access =3D uio_physical_access,
> +#endif
> +	.fault =3D uio_physical_fault,
> +#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
> +	.huge_fault =3D uio_physical_huge_fault,
>  #endif
>  };
> =20
> @@ -767,11 +838,30 @@ static int uio_mmap_physical(struct vm_area_struct =
*vma)
>  	 * So we just do the physical mmap without a page
>  	 * offset.
>  	 */
> -	return remap_pfn_range(vma,
> -			       vma->vm_start,
> -			       mem->addr >> PAGE_SHIFT,
> -			       vma->vm_end - vma->vm_start,
> -			       vma->vm_page_prot);
> +	if (vma_is_cow_mapping(vma)) {
> +		/* COW mappings cannot be populated on fault: map them now. */
> +		return remap_pfn_range(vma,
> +				       vma->vm_start,
> +				       mem->addr >> PAGE_SHIFT,
> +				       vma->vm_end - vma->vm_start,
> +				       vma->vm_page_prot);
> +	}

[Severity: High]
Can installing uio_physical_vm_ops on a COW mapping trigger a kernel BUG_ON=
()
when a concurrent fault observes a transiently cleared PTE?

uio_mmap_physical() sets vma->vm_ops =3D &uio_physical_vm_ops before checki=
ng
vma_is_cow_mapping(vma), so a MAP_PRIVATE writable VMA gets .fault and
.huge_fault installed even though it is mapped eagerly by remap_pfn_range():

CPU0                                  CPU1
handle_pte_fault()
  do_wp_page()
    wp_page_copy()
      ptep_clear_flush(...)
                                      handle_pte_fault()
                                        orig_pte =3D ptep_get_lockless(...)
                                        /* sees pte_none(orig_pte) */
                                        do_pte_missing()
                                          do_fault()
                                            do_read_fault()
                                              __do_fault()
                                                uio_physical_fault()
                                                  vmf_insert_pfn_order()
                                                    vmf_insert_pfn_prot()
                                                      BUG_ON(...)
      set_pte_at(...)

Previously .fault was NULL, so do_fault() took the !vma->vm_ops->fault bran=
ch,
rechecked the PTE under the page table lock, and returned VM_FAULT_NOPAGE.
With .fault set and no vma_is_cow_mapping() check in uio_physical_huge_faul=
t(),
do_fault() calls into vmf_insert_pfn_prot() (or the PMD/PUD equivalents),
which hits BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma)).

Even if uio_physical_huge_fault() checked vma_is_cow_mapping() and returned
VM_FAULT_SIGBUS, having .fault set on a COW VMA would still bypass do_fault=
()'s
page table lock recheck and deliver a spurious SIGBUS on transient PTE
clearings, and having .huge_fault set makes vma_can_map_huge_file() report
THPeligible: 1 in /proc/<pid>/smaps for PMD-aligned COW mappings.  Should C=
OW
mappings keep using a vm_ops structure that only defines
.access =3D generic_access_phys?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111113045.3536=
8-1-farbere@amazon.com?part=3D4

