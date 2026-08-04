Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82A6EC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:15:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C1F06B00E7; Tue,  4 Aug 2026 10:15:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871E66B00EA; Tue,  4 Aug 2026 10:15:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761A46B00EB; Tue,  4 Aug 2026 10:15:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3A06B00E7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:15:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CCE7E1A01BA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:15:57 +0000 (UTC)
X-FDA: 85063785954.22.24C70B5
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf04.hostedemail.com (Postfix) with ESMTP id 090ED40002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:15:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=U9Y+ykcr;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf04.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785852956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8W8JyDPmzm5UCFlTscqzEvqyD9BPaBjnzevjHF84zPM=;
	b=2xlzvE3K6qfRTOB1C7UmnaWb+e32wIUrQdy0e7C46I0mVTVIoylj6EQ+oKlTug7d76zjzT
	zQkmGFke6AOkyzth0GQeSC63HBin93Kc/iUpQgwkV+ShLAuzU2mC+A6RanI5vb00wBsXwu
	VeZZbwg5LSzfNAFsJvuIy6i+qKk6u/U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=U9Y+ykcr;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf04.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785852956;
	b=GRYAYfpJpdbxgjP+B30DGfgDoblw/89Nps1k3wmAQ31M7yxLyjp2EPfXMiFotAGFDbIX1m
	qodtazS+rLjwgzjOF9SXTlm8deCY5nrd7MQKX6ohdJxjVM/vr63ng9gZ1irKhh7kCeHyjr
	J8zIyuDY+GWZF16CiZ/X4y7z8Fse9Zc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785852953;
	bh=+3Z5rwHR3Npu6BOoPBa6/MBmkSks84W8RMudMGSUNxc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=U9Y+ykcrneFm0SMzgD5Wequ5C+6YI9+5KWqJjq6MLqKcdspZXPBqRSTKLAQbn0Dwe
	 Jh4DlMKtwG72LHsJHkUlb16WIQJUUj+18D9Om/xq2DDIQYHJIqqeqV+cs4S2K8ll0u
	 4Xn8vps1thOfJAuih04f0ajvJ02z0b+dNM7G5KG4vsA9uJkF+UPMtoBzuOl8N0d9/o
	 Axxxz0skaIMlF/q2UUrgx2HHInYAouN6PFta0IFcrqGw7mD/F5MJfrJPa2J0b9Xe+D
	 51C3Oe/EKywkLcUXr5kjR7m7lRQJZFO/08vh07hJlCOSImCykqaB0uJfKf5qoEjrQj
	 v2Cf5nQUhFxUg==
Received: from fedora-21.home (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 8ABF017E0048;
	Tue, 04 Aug 2026 16:15:52 +0200 (CEST)
Date: Tue, 4 Aug 2026 16:15:49 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Alex Williamson
 <alex@shazbot.org>, bcm-kernel-feedback-list@broadcom.com, Christian Koenig
 <christian.koenig@amd.com>, David Hildenbrand <david@kernel.org>,
 dri-devel@lists.freedesktop.org, Fei Li <fei1.li@intel.com>, Huang Rui
 <ray.huang@amd.com>, linux-mm@kvack.org, linux-s390@vger.kernel.org, Michal
 Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, Sergio Lopez
 <slp@redhat.com>, Sean Christopherson <seanjc@google.com>, Thomas
 Zimmermann <tzimmermann@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/6] drm/shmem_helper: use vmf_insert_pfn_mkwrite()
Message-ID: <20260804161549.4cd9a66f@fedora-21.home>
In-Reply-To: <20260804120529.1730187-3-pbonzini@redhat.com>
References: <20260804120529.1730187-1-pbonzini@redhat.com>
	<20260804120529.1730187-3-pbonzini@redhat.com>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r5wnqmkqugt9iie5pmbryu35tddutou3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 090ED40002
X-HE-Tag: 1785852955-970707
X-HE-Meta: U2FsdGVkX194fgkrGccFvJV5THSdvFkhA0dOWKIrFjUvkCoSMYIqAwgJ6/UuwcQOG8bkiHgd+ggMucLy9qrjHFVH1Er43PYvAClExMdGzM1HkBj1HO0S6LRFiEBXiY+UpiEHFD3b80n8iJP2PFdvSq/Kwg+S7g3iXq1orKXYGROc35NbmGhk9pw3iwuGB8v7eVQAbFS/Vz9c79393udxS5k4O41SQftYmRCyBywA6YQF3hvq71Yzye0VtNlh27K26WhmuUcc2G2/He3kEv1+i6eybpI98nLkk6/mcOGymOeG+SB/cUTni4yLRshl8RW8HtXuq6YKQVh9n2hKWc7dFhPFxcPos3vkNOxi25PRvRGomx6mGyFf4mJP6wfMyf1BjJynp8YYnT0ZKyoPCVjRnz5h0o7R3poC5bjJGFA7zeBnpyHduYKign9oDy7dpEBzSWyWTuAGxbksAqy8oknN8Qgucq2FewlcIRxpt7Iw/4PDTNg6sxHZzBlL7bZpp/QF3mGsPAqg5/FEKTq6Rx8PHsTsSnTxnXrW5yxZUvZVk6+c0d9Dp/QLdFlQd/rOKVFRQ7Xv5hOeH8HahBQB23WLHMrUGsKQh8z35Cv+lTe3xSCIUga+fCK0E5TxPrZ0XNgpqKJVFseYMj8YmL6NX59fLsScXNsGYcv2Ed1a1wJFtkcA5BLofT4ZKUhtquMTD5/ZZG8OsPw5gzWnmdkkVAo47ChESr1uc+o7lRB/Y4uPGCKNUmldx4p66VX7mXojfWItxgTQuN9hqKNpLF0H/ykPyAF0je12vVj3Vt+Mo9pPPPwVWAkpEOs19ChaIdsy+Alf25/RIC9BS4ELqJBrybJNf7rb6VdbLiN63gl+oYuyvkipbuHLmj3lfROoS7JclV8xmH2MuX3e6OvjhuHHbkhbFr9c4SHlvyTcX3mcpoqQKAUOftnPmlFPDi5gw2r0M2/9IZQ8e+rg5B4OZ0H92xI
 YH4KDct5
 JUNPg107IabUft48AapgdfcavJhNCYdhopGTAt74exJBLw8Q8OJcaNoxLEN8+6aYTg7+S9DOjm/AFCUuhW9rClNq+CzBa292KIxnp0oZ23+qyD291SZmh23tceOMGORN3i3OdG1nzPLSkUKcExAvVQ1/yjgzNsh4TEjAHBQ2MfC3xIhzbDE5wVCV41aBKuv+ceNMhEDDbDM4KCzWhi/mmsfhdzM1JF35sfWv7lcN4zfRpN4xrdLLapiHxZ36ito5MVzJrYxtoxLYp6vSRP/MovBjmRlYNIteX9PKJjxbUgxgh4mrHZ6xNpP+8RBQL3V3HekR/1QNCH+k0j65rVa+FPx+5n8zF2lFAP3vchR9o63U54Onl57DxS2HEPbEAhLHwK/dx3TiDM2qaqecV5viStkigEi+xe6bpCgRJfZqmNy1mQI7m/F7fwfBg74kaFADUqJwKQ8KRgxXTqHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  4 Aug 2026 14:05:24 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> This ensures that KVM or VFIO correctly see a writable PTE when
> they request one.  Otherwise, a guest write to an unpopulated
> PTE from a mapping backed by a DRM GEM BO triggers a VM exit
> with EFAULT.
> 
> The code actually is simpler, because the same logic already
> applied to the hugepage mapping case using vmf_insert_pfn_pmd().
> 
> Reported-by: Sergio Lopez <slp@redhat.com>
> Link: https://lore.kernel.org/kvm/20260729072044.25796-1-slp@redhat.com/
> Tested-by: Sergio Lopez <slp@redhat.com>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> Fixes: 28e3918179aa ("drm/gem-shmem: Track folio accessed/dirty status in mmap")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 38 ++++++++++++++------------
>  1 file changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index c989459eb215..c81be3e97317 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -589,11 +589,25 @@ static void drm_gem_shmem_record_mkwrite(struct vm_fault *vmf)
>  	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
>  }
>  
> +/*
> + * Because the vm_ops have a .pfn_mkwrite() callback, vma_set_page_prot()
> + * has cleared the write bit from vma->vm_page_prot.  vmf_insert_pfn()
> + * would install a read-only entry even for a write fault, relying on a
> + * second fault to reach .pfn_mkwrite() and upgrade it, but that second
> + * fault never happens for fixup_user_fault() callers that directly
> + * walk the page tables with follow_pfnmap_start().  To ensure that
> + * they don't see the read-only entry, pass FAULT_FLAG_WRITE info down
> + * to install a writable entry right away.  Because .pfn_mkwrite() is
> + * not invoked, record the write afterwards.
> + */
>  static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
>  				 unsigned long pfn)
>  {
> +	bool write = vmf->flags & FAULT_FLAG_WRITE;
> +	vm_fault_t ret = VM_FAULT_FALLBACK;
> +
>  	if (!order) {
> -		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
> +		ret = vmf_insert_pfn_mkwrite(vmf->vma, vmf->address, pfn, write);
>  #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>  	} else if (order == PMD_ORDER) {
>  		unsigned long paddr = pfn << PAGE_SHIFT;
> @@ -601,27 +615,15 @@ static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
>  
>  		if (aligned &&
>  		    folio_test_pmd_mappable(page_folio(pfn_to_page(pfn)))) {
> -			vm_fault_t ret;
> -
>  			pfn &= PMD_MASK >> PAGE_SHIFT;
> -
> -			/* Unlike PTEs which are automatically upgraded to
> -			 * writeable entries, the PMD upgrades go through
> -			 * .huge_fault(). Make sure we pass the "write" info
> -			 * along in that case.
> -			 * This also means we have to record the write fault
> -			 * here, instead of in .pfn_mkwrite().
> -			 */
> -			ret = vmf_insert_pfn_pmd(vmf, pfn,
> -						 vmf->flags & FAULT_FLAG_WRITE);
> -			if (ret == VM_FAULT_NOPAGE && (vmf->flags & FAULT_FLAG_WRITE))
> -				drm_gem_shmem_record_mkwrite(vmf);
> -
> -			return ret;
> +			ret = vmf_insert_pfn_pmd(vmf, pfn, write);
>  		}
>  #endif
>  	}
> -	return VM_FAULT_FALLBACK;
> +
> +	if (ret == VM_FAULT_NOPAGE && write)
> +		drm_gem_shmem_record_mkwrite(vmf);

Actually, if we're making the drm_gem_shmem_record_mkwrite() call
unconditional (for PTE and PMD updates) in that path, can't we drop the
drm_gem_shmem_pfn_mkwrite() call living in drm_gem_shmem_pfn_mkwrite()?

Also, I'm not even sure we can end up with write=true for PTE updates,
because our pfn_mkwrite implementation returns zero, not VM_FAULT_ERROR
or VM_FAULT_NOPAGE. This means the default RO -> RW PTE upgrade
implemented in finish_mkwrite_fault() [1] will take place. If we really
want out try_insert_pfn() to be called for those RO -> RW updgrades, we
need to call try_insert_pfn() from drm_gem_shmem_pfn_mkwrite().

[1]https://elixir.bootlin.com/linux/v7.2-rc5/source/mm/memory.c#L4021

