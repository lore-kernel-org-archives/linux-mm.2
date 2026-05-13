Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E42DCD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 02:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A86EC6B0005; Tue, 12 May 2026 22:43:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37BD6B008A; Tue, 12 May 2026 22:43:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94DF76B0093; Tue, 12 May 2026 22:43:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 875286B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:43:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 496FE1A05C1
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:43:02 +0000 (UTC)
X-FDA: 84760849404.24.AA88D50
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6F4AF1C0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:43:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=UMFVeOs7;
	spf=pass (imf21.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778640180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HDotFo7yQkt3tGus6/l1hCvSHXQW8pdq+LRsiO9XGls=;
	b=QvIas68yY0BSZchKvREFa940SdwKGaXvIV7OK/YfzTG5bg2gVLSK13KUgankK0CSuI9gWF
	tGik0UlH/IWkeypCbS6LkygF5EAIMNH0/xfA/o4DjlvIHo1KyAa8Zs96HvRNQWn52cL1SB
	kQzzk3p7WHCh/vh2N6RbL9cQjzH9fc0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778640180; a=rsa-sha256;
	cv=none;
	b=Q8JJ8QWv+XKlStoI9HN2Ir48mGKTGC7KMxifwG5Em2ac94baxcWc3BQjEBAiYzHpmc07kl
	CuQiqOAT184gts3i/vyQimV0DmC29xrxuNL7/YVGQpQ09hDPW/4szD2KPNq1JMTX/FAcsw
	JfsPYhzO+bp+ResqO8SROMb28xA9I9U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=UMFVeOs7;
	spf=pass (imf21.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from skinsburskii.localdomain (unknown [52.148.140.42])
	by linux.microsoft.com (Postfix) with ESMTPSA id 0EBE420B7166;
	Tue, 12 May 2026 19:42:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0EBE420B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1778640176;
	bh=HDotFo7yQkt3tGus6/l1hCvSHXQW8pdq+LRsiO9XGls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UMFVeOs7jhHizUoZTF3rLV2fW2H7+kCxsG+j5RVqvZRaYJO8AXfta9wqL4aMgODOg
	 J3qPV4D2PtHGW6IjCCwtKABwk4UA468vwFN9VGwCfbgXSjEomN1K9YREsOaurc60cL
	 8SMTLGI1FKlt5aHKMDLY/c6dwmfueyb1aeDwXOKs=
Date: Tue, 12 May 2026 19:42:57 -0700
From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: kys@microsoft.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	decui@microsoft.com, haiyangz@microsoft.com, jgg@ziepe.ca,
	corbet@lwn.net, leon@kernel.org, longli@microsoft.com,
	ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, shuah@kernel.org,
	skhan@linuxfoundation.org, surenb@google.com, vbabka@kernel.org,
	wei.liu@kernel.org, linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm/hmm: Add hmm_range_fault_unlockable() for mmap
 lock-drop support
Message-ID: <agPlMYFCrdD2WKYZ@skinsburskii.localdomain>
References: <177759835313.221039.2807391868456411507.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
 <177759840859.221039.13065406062747296947.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
 <563bb216-c270-4711-adda-b91484af40dc@kernel.org>
 <agNS4llNtAHBkMA2@skinsburskii.localdomain>
 <f073a8d7-5761-4f7b-a5e5-c6aeae5fdc72@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f073a8d7-5761-4f7b-a5e5-c6aeae5fdc72@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6F4AF1C0005
X-Stat-Signature: omn6je5a58jgsakw6rwaaj9rz36ymw9x
X-Rspam-User: 
X-HE-Tag: 1778640180-926788
X-HE-Meta: U2FsdGVkX1/spz1pcNIN8qiYoRIIhZWQydHfOMHO0nMXmQnOvOUvUZ1YApFlVnTvx4CmVfkXQv57F47gGxNU+VOPANSfyXlXs2Wq9mT1VDjpADA/b3PVC4IfRiGY9PfPQLL40gSo1pEijKte2iOzwGb/b3qW1Zdj1cUUhPVyoGxEsXDUE/dmJ2PtwjZ3iVKmv2WMc72L/fU8ctoQv7QX0ZZF9PcJk45tUcJi7A/TEW2Y4Vph4GC1WNNbBXKMUxdX1P+ZwrNM1AxGMREIGaNqNw1N+UM2WGSl0NRiJRpLsv//5KRbueH03NpKNN9ryxrrSPNpG82PtknAoxqHfAbeKxXUvMdJqf+RELiBpupYzjffmsz5zWaAsCyHS5O3Lj9/v4DGYrpbAosA1Cktn4uiZYVoFb3iWGgBhKjQupVEWhZQ+KgcHRSdWn4Fl8UyuTVfiLOtU/Vme4mZEkAOeuTZD72jDiN90mvm0lQvkV3yALSa/yLGfjHc/Xc/3EdkaQB8PKKv2FlxP3/Eqfu+fkXaDzCBmtADeyf94rlZuiTdKqqlKh2ca6w3aZLmSD+z+Zh564HVYvD1wCeq4SaKP/Ms7D8E2M2NHvGZaoxI1wvq/pJ47aubcgVUBi127WWOZ0KS31RwvTQyMAV4g+Qy3BT5zBhYlRs+GzIg1FAyFjzRLaWeRsKWCMgB3s39dvIY/+C9ycTscmWg9sScwvDfQuLhAbJlkkaZiq7eOoDjHTi6Ug7vliXym7ILOw+lgCOrED8BHLOHSjiPfCQwl/f2wjxvAmR3x0eWvclP4t0CO8QOaEuClZGD99VnX97w3w8UEjVyBBRtExIRG9iFeyj1RyYhrJcuuPHmelI+vOfVBsBrInfKm/VuoI8iQKPs+luc9Cv999/xy5jxvNn1XG7nKeFqNiRzVsYsx4Lrek0cz6xv74iriQlIOZ+28ahLFNUF/OwnHNoAyFrFBjIKaOdZskO
 UrH6HkES
 Roq5Ikd1RsiU683JG0TJQM3ozsYYxDA4pTJzo9NVsqzvDnWnsyZKQf/R+QRh3nIUuFDht2Hbdd7772LDGl7y/bE0dEUMog2rg8QYOoUPK60tfSiqtFGy52BGgMcA2fW6UuS39z3JqM0Tb8UHzG/CsL+swaJkTZF6RZnc+aYFK40v7dAOd6fxRprZ4GqKi2bQkBZzxv6rt0v7Bs+qa2JnPvQ4jFnghC6Sw4RdCIm9Si7WZmGoDGyJ6HOGWcN7QrOHkkYKRGXu6qb3n6/6AQ21n3Dh/M/UuZ9FwGy3tz5u1zVkVFzCnEDoxdzfl3ynHRX/LjXGe495rvFybHreKGa1AUDDgnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 09:18:11PM +0200, David Hildenbrand (Arm) wrote:
> On 5/12/26 18:18, Stanislav Kinsburskii wrote:
> > On Tue, May 12, 2026 at 10:42:14AM +0200, David Hildenbrand (Arm) wrote:
> >>
> >>> +	for (; addr < end; addr += PAGE_SIZE) {
> >>> +		vm_fault_t ret;
> >>> +
> >>> +		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
> >>> +
> >>> +		if (ret & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)) {
> >>> +			/*
> >>> +			 * The mmap lock has been dropped by the fault handler.
> >>> +			 * Record the failing address and signal lock-drop to
> >>> +			 * the caller.
> >>> +			 */
> >>> +			*hmm_vma_walk->locked = 0;
> >>> +			hmm_vma_walk->last = addr;
> >>> +			return -EAGAIN;
> >>
> >>
> >> Okay, so we'll return straight from hmm_vma_fault() to
> >> hmm_vma_handle_pte()/hmm_vma_walk_pmd() -> walk_page_range() machinery.
> >>
> >> Hopefully we don't refer to the MM/VMA on any path there? It would be nicer if
> >> the hmm_vma_fault() could be called by the caller of walk_page_range(), but
> >> that's tricky I guess, as hmm_vma_fault() consumes the walk structure and
> >> requires the vma in there.
> >>
> > 
> > It looks like a caller can provide a post_vma callback in mm_walk_ops. I
> > missed that case here. This callback cannot be supported by this change.
> > I will update the patch.
> > 
> >>
> >> Note: am I wrong, or is hmm_vma_fault() really always called with
> >> required_fault=true?
> >>
> > 
> > No, hmm_pte_need_fault can return false.
> 
> That's not what I mean. Looks like all paths leading to hmm_vma_fault() have
> required_fault = true;
> 
> IOW, there is always a "if (required_fault)" before it one way or the other.
> 
> Ah, and there even is a "WARN_ON_ONCE(!required_fault)" in the function. What an
> odd thing to do :)
> 
> > 
> >>> +		}
> >>> +
> >>> +		if (ret & VM_FAULT_ERROR)
> >>>  			return -EFAULT;
> >>> +	}
> >>>  	return -EBUSY;
> >>>  }
> >>>  
> >>> @@ -566,6 +585,17 @@ static int hmm_vma_walk_hugetlb_entry(pte_t *pte, unsigned long hmask,
> >>>  	if (required_fault) {
> >>>  		int ret;
> >>>  
> >>> +		/*
> >>> +		 * Faulting hugetlb pages on the unlockable path is not
> >>> +		 * supported. The walk framework holds hugetlb_vma_lock_read
> >>> +		 * which must be dropped before handle_mm_fault, but if the
> >>> +		 * mmap lock is also dropped (VM_FAULT_RETRY), the vma may
> >>> +		 * be freed and the walk framework's unconditional unlock
> >>> +		 * becomes a use-after-free.
> >>> +		 */
> >>> +		if (hmm_vma_walk->locked)
> >>> +			return -EFAULT;
> >>
> >> Just because it's unlockable doesn't mean that you must unlock. Can't this be
> >> kept working as is, just simulating here as if it would not be unlockable?
> >>
> > 
> > I’m not sure how to implement this. The walk_page_range code expects the
> > hugetlb VMA to still be read-locked when we return from
> > hmm_vma_walk_hugetlb_entry. How can we guarantee that if the VMA might
> > be gone?
> > 
> > I added a note in the docs. Whoever tackles this will likely need to
> > either rework `walk_page_range` to handle the case where the VMA is
> > gone, or use a different approach.
> > 
> > Do you have any other suggestions on how to implement it?
> 
> You just want hmm_vma_fault() to not set
> "FAULT_FLAG_ALLOW_RETRY·|·FAULT_FLAG_KILLABLE".
> 
> The hacky way could be:
> 
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 5955f2f0c83d..83dba990e10a 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -564,6 +564,7 @@ static int hmm_vma_walk_hugetlb_entry(pte_t *pte, unsigned
> long hmask,
>         required_fault =
>                 hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, cpu_flags);
>         if (required_fault) {
> +               int *saved_locked = hmm_vma_walk->locked;
>                 int ret;
> 
>                 spin_unlock(ptl);
> @@ -576,7 +577,9 @@ static int hmm_vma_walk_hugetlb_entry(pte_t *pte, unsigned
> long hmask,
>                  * use here of either pte or ptl after dropping the vma
>                  * lock.
>                  */
> +               hmm_vma_walk->locked = NULL;
>                 ret = hmm_vma_fault(addr, end, required_fault, walk);
> +               hmm_vma_walk->locked = saved_locked;
>                 hugetlb_vma_lock_read(vma);
>                 return ret;
>         }
> 

I see. AFAIU the outcome would be the same.

> But really, I think we should just try to get uffd support working properly, not
> excluding hugetlb.
> 
> GUP achieves it properly by performing the fault handling outside of page table
> walking context ... essentially what I described in my first comment above:
> return the information to the caller and let it just trigger the fault.
> 
> The issue here is that we trigger a fault out of walk_hugetlb_range() where we
> still hold locks, resulting in this questionable hugetlb_vma_unlock_read +
> hugetlb_vma_lock_read pattern.
> 

Fair enough.

> The fault should just be triggered from a place where we don't have to play with
> hugetlb vma locks or be afraid that dropping the mmap lock causes other problems.
> 

I reworked this part. Please take a look at v2.

Thanks,
Stanislav

> 
> -- 
> Cheers,
> 
> David

