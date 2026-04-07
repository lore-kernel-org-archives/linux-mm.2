Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1357EDB7EF
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 10:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384796B0088; Tue,  7 Apr 2026 06:48:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 334E26B0089; Tue,  7 Apr 2026 06:48:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A886B008A; Tue,  7 Apr 2026 06:48:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 150026B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:48:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0967E243B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:48:39 +0000 (UTC)
X-FDA: 84631436358.22.DDC3CC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2DDD72000E
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:48:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B9Hrl0YP;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B9Hrl0YP;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775558918; a=rsa-sha256;
	cv=none;
	b=SKMEr09zF6gsdr466ucoyxa4N/sb5KJPvUuW3cKOthPlq4BGDKmUMGif2DgqC1zEryQADL
	NR9BIWTUC1gsPhzpcTm4Lzeie41dUFrUbOTxDt6mjfj060FmHCzHEiG0khBHZZA67IYEnx
	0sN8L71HNXR/Kp9GKM1NlqdRpWPbl7E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775558918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kcFBtfoTc+V4OFvuZzLlJPwJoiGb+0fUJrkF+opujOI=;
	b=yAHPUZom4vLLX7Gr70mqkpTjKdmqCu6/OqWJGotdpKFbBobJwFFtOPcncSX+A+oJBiKpQg
	lM6mgSjcKg7z982tkFlNdXExe5pEQL6rfTKNvF+tGkM+clsIYMGobuhdm+jBGx4/SjE5Ph
	BDlsewSi8wMjKR70bFHpromCZq23PpA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 64C6860120;
	Tue,  7 Apr 2026 10:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4639AC116C6;
	Tue,  7 Apr 2026 10:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775558917;
	bh=plvm98yXi0oiNeiJ5KWfoDRd1nOJdHlTIM+h4PPVQwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B9Hrl0YPWM3VFx6SsgTZ8TtbBCyKSnUdHdQRtEc3XObxhiKqdsjaPL+d40XYklTNX
	 bggf8Jfdc/YYxn8zYxZyb61PdlVZJs1Rhf42xwVxhqL6ALT1DUYBMcJqRYFOY//5ls
	 SC/YvjS0xi0jwkTpCnWJ04h8xov1CFLLclQOJfJKXKNVKQgYJh3yfZ1GxEoZdhMTgL
	 mCoONRv75hKrOLtDgGBGVqAh1UuXR59rfwMSRx8077YOHSixyNdFrKSf5DFr3DlQkq
	 cONDaKyJ4b7pn2ZLckA82VmZYTpJhAtDt/CSwByCfjc+sOynjtguVIL6ve0LEcvou5
	 g0JopWY60gt9A==
Date: Tue, 7 Apr 2026 11:48:30 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Yin Tirui <yintirui@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 13/13] mm/huge_memory: add and use
 has_deposited_pgtable()
Message-ID: <adTb6_xqQoQqK74Q@lucifer>
References: <cover.1774029655.git.ljs@kernel.org>
 <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
 <41b1ff54-c120-42ae-8b74-54767abf3554@gmail.com>
 <fe357495-2e45-443a-93b4-52bf21d3bdff@lucifer.local>
 <c6748ac8-6dcf-41b5-a281-2f21069b1f2e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6748ac8-6dcf-41b5-a281-2f21069b1f2e@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2DDD72000E
X-Stat-Signature: nkfsnqs9oz6kyj5cu8qydu7rjbqodzfb
X-Rspam-User: 
X-HE-Tag: 1775558918-551674
X-HE-Meta: U2FsdGVkX1+KfFGiGKv0knXQzKKdljKfrpNgumNPb3PZew5pPfgDB57hltNA3kpTXG13IQZgbRPSesTL847nGcqIGyqIqZl4WDrBFKGviG2VOihy5lgMeD2fCLJ7zx/PKdPn5tSXh0Js7NUFivX0LMQvk7wnJf29RUeCfjknQ575DPzxp8J8kqt08x+b4T8Tn+PXlkeb/cJDQQPEvkjil75xjDZAz8mAfQu+SwI2ggV5tqb/2Kd+RQFysRCsT2w7UJBoF5//l9DAye7Th/YljObu9VZGDQ4vO8NyubU1U8eSzz4uiNxurbaOclCx5t6wjYS+tIQxhTTFHgbiGU2hIUBeRXmLJPD/6Ax5Ypr/n2z7bBBdh3UOLXBPlEBwoar+J2LswDSKUHX7nO8DLYmSmjMiYSPI2J3/j9gZZ7QA8ZDenB/jzhfr0JFHbtR9O6glRZrBVwhPv0Ub2iw62knuZvpV4HTnfvpZStMKoARZvKHjrE2/frd0wjKmVIMHWTSDz4O/AP0XQ/5QkwYq1QNRqyK5vLZsFFR23agAg2jiXx7k1RtxzZ4J3wZipidHIp4gBcB7w32Xz/EfoyH05TFhqUzk7b7mGwpEmFbUMMo99EMRprR0r7eQmQgNMOXCZtWOHTqcb8sJRMKFKbvkjXFPqb/u+J34RD1s3JcbUFC/9VBx4UXK3bfK9Dg5qJJoZHTLCgLUCb04pXdDmpjwZRtJ8xseeqskFs0jXpdXUBtDG+MBTDrTFKY5CVCnwSVqkajbuevbUcoyEgYQIY2M8EVgjjETn5wdtwm0NVq8D2bNcqpsrGcrP/XPj1Bl0fqDNB/JVY76lHnBUblXYefxBqWCXN/IY8o5Mi2nnpMAjOCnNB+FDXX7jEv1xXT0VgrEKNyAhjf1BxqoHkNjeYmzex3kpX47BQvlprFQK6eFmWWq9zsy6NCKjsF+Ens9neQr/Lrgi9cmzbxcFM2dSqyFJb6
 xYGYRfTk
 h1Za5gVV77o4CUK0oC4hyWVv1oe6EdULJZw4OhELSuiV+LvpDGfBQFoI5lWgXrd3WSjzj92QcT1npA5PwBBU/7/3Ua5XmDG/naWipDRYPZ76EW9dVMTA7l6CiYApC2y90kfTLXJj/942Gr3MWxJuaia13rXyvkK35Qg6fU4zt75Sa6H2UFl5VUzUueUrOySeQm4Uf6EhOLNCCqy+iyaVullKyqwBs68jI9ClSCkbJh7gYOjqy8BJLQLhNXf2beN0pEwqjGbk2zzsKcJaeQpyi+QVgtari2wwgb1NaH8mjWbaQgj8vZNmI40gCJ1HOmbXQGf2huVZXg8fODoiYKBxKZY9kxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 03:49:35PM +0800, Yin Tirui wrote:
>
>
> On 4/2/26 14:46, Lorenzo Stoakes (Oracle) wrote:
> >
> > I mean you would have needed to handle this case in any event, since this change
> > is strictly an equivalent reworking of zap_huge_pmd().
> >
> > But it seems that doing so has clarified the requirements somewhat here :)
> >
> > I haven't had a look at that series yet (please cc this email if you weren't
> > already, I do filter a lot of stuff due to how much mail I get daily)
>
> Hi Lorenzo,
>
> Thanks for the quick reply. I will definitely CC you on the v4 series.

Thanks.

>
> >
> > So if this is a PMD leaf entry it will be present and PFN map, so I'd have
> > thought simply adding:
> >
> > 	/* Huge PFN map must deposit, as cannot refault. */
> > 	if (vma_test(vma, VMA_PFNMAP_BIT))
> > 		return true;
> >
> > Would suffice?
>
> Here is the dilemma:
>
> Currently, VFIO uses vmf_insert_pfn_pmd() to create huge pfnmaps on page
> faults. This sets VM_PFNMAP in vfio_pci_core_mmap(), but it does not
> deposit a pgtable (unless arch_needs_pgtable_deposit() is true).

Hmmm... it's only the VFIO and hyperv drivers using this.

Wouldn't we generally want a deposited huge page here now we're allowing huge
PFN maps?

Or are this _special cases_ where we have a PMD-sized entry but are not
necessarily wanting to treat it as THP?

This is a real wrinkle in this whole series no?

David - any thoughts?

>
> To resolve this,
>
> Option A: Force VFIO (vmf_insert_pfn_pmd) to also deposit pgtables. This
> unifies the VM_PFNMAP lifecycle. However, since VFIO can refault,
> depositing pgtables here incurs unnecessary memory overhead.

How can VFIO refault as a PFN mapping? Does it intentionally sometimes
clear PTE entries to effect a refault, and implement a custom fault
handler?

I guess having a fault handler makes it refaultable...

I mean obviously that then contradicts the suggested comment above :)

That seems to me to cast a bit of a question over the whole series - having
PMD mappings that are _sometimes_ THP and _sometimes_ not is weird (TM).

And it'd suck to add - yet another very specific check - to determine if we
do, in fact, assume THP for a PMD sized PFN map.

>
> Option B: Introduce a new VMA flag set during remap_pfn_range(), which
> we can explicitly check in has_deposited_pgtable().

Yeah would rather not, that feels like a hack.

>
> Option C: Check vma->vm_ops->fault (and huge_fault). We would only
> deposit pgtables for mappings without fault handlers. However, this is
> fragile because a driver might still register a .fault() handler that
> simply returns VM_FAULT_SIGBUS.

I mean again this is yet another check (TM). But probably the most preferable I
think.

Wouldn't a driver doing that be being somewhat redundant? E.g. in do_fault();

	if (!vma->vm_ops->fault) {
		vmf->pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
					       vmf->address, &vmf->ptl);
		if (unlikely(!vmf->pte))
			ret = VM_FAULT_SIGBUS;

And so can expect maybe some more redundancy if they also happen to map
PMD-sized ranges? :)

And the only two callers of vmf_insert_pfn_pmd() - hyperv and VFIO both
implement actual fault handlers anyway.

So I think this is fine?

>
> Do you have a preference among these, or perhaps another idea?
>
> >
> > By the way, I am wondering if the prot bits are correctly preserved on page
> > table deposit, as this is key for pfn map (e.g. if the range is uncached, for
> > instance). That's something to check and ensure is correct.
> >
> > I _suspect_ they will be, as we have pretty well established mechanisms for that
> > (propagate vma->vm_page_prot etc.) but definitely worth making sure.
> >
>
> Yes, they are correctly preserved!
>
> During a PMD split in __split_huge_pmd_locked(), we populate the
> deposited pgtable like this:
>
>     entry = pfn_pte(pmd_pfn(old_pmd), pmd_pgprot(old_pmd));
>     set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);
>
> The newly refactored pmd_pgprot() correctly extracts the exact
> protection bits (including crucial cache modes like UC/WC for device
> memory) from the huge PMD, strips the hardware-specific huge bit, and
> returns a pure PTE-level pgprot_t.

OK good :)

>
> >>
> >> [1]
> >> https://lore.kernel.org/linux-mm/20260228070906.1418911-5-yintirui@huawei.com/
>
> --
> Yin Tirui
>

Cheers, Lorenzo

