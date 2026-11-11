Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1150606A333
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HIi63Rsc
Received: by kanga.kvack.org (Postfix)
	id B58446B00EF; Wed, 11 Nov 2026 04:04:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B086A6B05B0; Wed, 11 Nov 2026 04:04:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45F66B05B1; Wed, 11 Nov 2026 04:04:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CEDE6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:04:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC5E68023B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:04:27 +0000 (UTC)
X-FDA: 85422252174.05.7D87174
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4DA6C1C0004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:04:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIi63Rsc;
	spf=pass (imf20.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794387866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uu+9KGMrpHo8NgeySjI/tnMOPCgQH/37jz3abKrEz2o=;
	b=vGcnlv/1Lhfm5dl3Fe4n8nDkmhVGmH0/bRuute5unyIjIC4RY2hdy36W+3dX+OWup+9NJK
	5u6otiulFuprrKbcVvaUcahhhnziYgqVTGxCWk/8uCdGP+1vRAziYv1IxZXhs4Kr9HTCLm
	Kb0941MvQ6aYsZ1UohYhzZXNkm6xE1I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794387866;
	b=lFG8TAm7Hit8DnYpn5Dje7Ty8+6MgqfbyhQHO8EOxH0PhTAo9w9JuQNUN7Asf+B+a6SmlF
	gjI3ropsISMCsvY7YJebu5lKnXnILJZkD2OM7CnUHrkCWXumfNUobUxXyGS/zCAGOy+BlR
	c8Ms1Dku/yGTZM3YcIVdkkKBql6XwJY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIi63Rsc;
	spf=pass (imf20.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4E7763BB0;
	Wed, 11 Nov 2026 09:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53ADA1F00A05;
	Wed, 11 Nov 2026 09:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794387865;
	bh=Uu+9KGMrpHo8NgeySjI/tnMOPCgQH/37jz3abKrEz2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HIi63Rsc072fcV3Tl1WAPHmCUz8w3a5jTfXsiegMUGVvyuq0PblXB+u68/3bRBoJO
	 T1P0Y3HXdzA2glvFOEAULVTxX+f30mY5CzVeX37aHt4sn3Yq80qpmSNWLSpwA+QF5L
	 +OWMh0pe3Wf/fuBagRsb2AAxmPmnH8HLa430rxxnafK5LaZUUdRqGILc0uzwMDQoS7
	 APpykF1PkmpRzUSEJIa6FImTQdljxta8iwjlHX+H7UxhNeqBY85ZZHGXyejxM+DtJm
	 iFt4yxKv7HQ9sSl7td/sWSWxe9ov/nIWJbuwpsmeuFh2WB5KaNQWfbiChgOXpq5Q0q
	 4mRWIekkXy4BA==
Date: Wed, 11 Nov 2026 10:04:19 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, Mark Rutland <mark.rutland@arm.com>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH] arm64: hugetlb: Prevent write fault livelocks on stale
 TLB entries
Message-ID: <avQvk0oxEHTLFacU@localhost.localdomain>
References: <avPxZjjdBIlM_8_g@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avPxZjjdBIlM_8_g@chrisdown.name>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4DA6C1C0004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: dubemb1s6a8kbjjbyr83qxxwn4xsnudq
X-Rspam-User: 
X-HE-Tag: 1794387866-543836
X-HE-Meta: U2FsdGVkX1+SjJ9RcWsgJTbKNi+JsHySBQDdw2xmHqYfGa9LhBxAxQ9hW74g3fFWsxPRSf6BO5O6TKEmgd0VFVSFjc9F/dVZNk2fttvWQtRW6u8jgQBc+6DLCv7KNs/EcABG62n1gR++RZSjQFIfiN2zemXX8yPKQ1cFmQ+ca/Cwew01wehRURAzPl+vg+YBHZMj/x9FWGUstK+DX836ki6TWlBG70mVNUq2aILv3+o2AnwPrhAuNbmeLuSj00DSW6xBHSkenO3HFGANg+wF6Fpgbc1LDIkW91qAGTLnb5+RQ2wlGc/bqQpmLBxpBQRlqBxghj9HCowq6+F6LYD2TYNeXH0GmhamgPlVWJbudD9L4GcoooKMq48RJNHABKRHH+j3joX+fEZmNJMY+lW1PJmBPGpTIouAUDcQYaRmvvUpOgGIEPgamuoTRSxJQdm+LeT5jVVrKOh9vJTvddF1UxYE0623IbuoGLyrzYBJlTM6nHarw0JbK0SuhyFYr1LSm7J+q2r/kU7squroq7GwPnByhYKmzAKD8WQIh2S4q6RvQc1Lpe6QZ4RhTVswPPh3dYL21O/Qtbibhl9B04ZrhvGFhCQLhMhq+/UnB0o2g/nqMelubcOhkiupcP8V2OUvPErQDO73Y2d2xB6NSSaH+scRZ57H/YdNo92A6PpFidrCasofL1y2Cc2zP9PHbkSggbKwOOPmxRWMO/ehczlzXq57wwrgWlDaYD7ReZhOvkoxzBTyRPyqRnvFVCLgxjaErp441215+bC+1kClNrWMZ0dfQCfxnCErU0KsbVpzyUDA4RQB2vjQE/qeQFoHEMU/1RsTf346tWR93t07pvYSKUALCoslOtSvOz96N67jHLhos0LNBKE7EO76Wve0HlHF9uEh/ai7vf+iDUaaUMyg8Ltzne9vQq+tjNtY3NsY6B3+ZpL2N1ohSqTNaBY+ILjPG3HhudflQZnixirMSDy
 8Q+XXe6y
 3JODtv3i6UdfMIegGyfk4YEIz8KHQetj0XPBwjldqMXqYb3zxu3enUX1kzOXxhNsy4JkhdykrV4uwyiZDay7LGtWznw2EV+S1XrDw6c4pfd40mob6PLMlaPIYGnN9cy+GuwktCWqdM7zQ6DWZUviLMU/QYc8P8WcXIKdHkFjvsadTZB8qujJvuQX9rwwJ9Ku+tby8Evqu7d/H4KkZyn5vSjGIYufotbz/xeciCqNACeVSYBg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 08:39:02PM -0800, Chris Down wrote:
> In Meta production, we have had tasks get stuck in a fault loop while
> using hugetlb on arm64. During my investigations I found that affected
> tasks share a private hugetlb page.
> 
> Looking at the stuck task states, I found the following ordering:
> 
>   CPU0                                 CPU1
>   ----                                 ----
>   read page
>   [read only entry cached in TLB]
>                                        write page
>                                        hugetlb_fault()
>                                          hugetlb_wp()
>                                          [reuse folio]
>                                          set_huge_ptep_maybe_writable()
>                                            set_huge_ptep_writable()
>                                          [flush local TLB only]
> 
>   write page using stale entry
>   hugetlb_fault()
>     huge_ptep_set_access_flags()
>     [entry already writable, no flush]
>   retry write using stale entry
>   [fault indefinitely. well, that's not ideal!]
> 
> The reason is that when a write fault makes a non-contiguous hugetlb
> entry writable, it only invalidates the local TLB. However, another CPU
> can keep the old read-only entry, so its write will fault even though
> the page table already permits it. hugetlb_fault() then finds nothing to
> change and leaves the stale entry in place, so the same write keeps
> going round in circles.
> 
> This is particularly bad because, if the kernel is copying to user
> memory, the retry stays inside the kernel and the task can't act on the
> pending signal.
> 
> It can even remain unkillable while holding locks across the copy,
> resulting in further failures. For example, a read into a hugetlb
> buffer can hold the pipe mutex and block other users of the pipe until
> the loop ends, causing cascading lockups across the machine.
> 
> To fix this, when a write fault finds nothing to change in a
> non-contiguous hugetlb entry, let's invalidate the local entry.
> 
> Fixes: cb1fa2e99955 ("arm64, tlbflush: don't TLBI broadcast if page reused in write fault")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Down <chris@chrisdown.name>

This makes sense to me, and I see that commit cb1fa2e99955 ("arm64, tlbflush:
don't TLBI broadcast if page reused in write fault") only invalidated local tlb
for cont-hugetlb.
Reading the changelog, I guess that was an oversight because I could not find
the reason behind.

> ---
>  arch/arm64/mm/hugetlbpage.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index 8e799c1fe0aa..ff1f53e435e1 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -429,9 +429,24 @@ int huge_ptep_set_access_flags(struct vm_area_struct *vma,
>  	VM_WARN_ON(!pte_present(pte));
>  	ncontig = num_contig_ptes(huge_page_size(hstate_vma(vma)), &pgsize);
>  
> -	if (!pte_cont(pte))
> -		return __ptep_set_access_flags_anysz(vma, addr, ptep, pte,
> -						     dirty, pgsize);
> +	if (!pte_cont(pte)) {
> +		if (__ptep_set_access_flags_anysz(vma, addr, ptep, pte,
> +						  dirty, pgsize))
> +			return 1;
> +
> +		/*
> +		 * Another CPU may have made the entry writable without
> +		 * invalidating our stale read-only TLB entry. To avoid
> +		 * indefinitely faulting on this entry, flush it.
> +		 */

Maybe put that we already do that for cont-pte? 

 

-- 
Oscar Salvador
SUSE Labs

