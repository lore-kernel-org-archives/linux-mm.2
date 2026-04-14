Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B0AAED7B96
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEFA36B008A; Tue, 14 Apr 2026 05:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6F26B0092; Tue, 14 Apr 2026 05:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DCCC6B0093; Tue, 14 Apr 2026 05:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89DAB6B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:44:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4DC418BAE2
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:44:27 +0000 (UTC)
X-FDA: 84656676174.18.61EEFAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 55FA320009
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:44:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=slpqucUP;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776159865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=26d+rgBK5kND1dDLeLDTaFx5ivZ2rm5ivfYGWd6OdFU=;
	b=IRkwoM5IHk/C+3IEs5oBi1NFBjZByylK8sK0f5IZzVx1dqTbUazTM8drc5m74zoFxKteNc
	qbrG0/cgrk3MFhviE9e6Y15YZqrm14ceXszAXgr/3XfBaOazDK25lXHEETG8pIArW/r341
	VQOAeMz4OmeNPh1NM9UhlOZWne3CKkg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=slpqucUP;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776159865; a=rsa-sha256;
	cv=none;
	b=S+efWet23UuAgASJ9MUDRj4tmHV7qE+EUc1T68rjuJzczKF0v/vsu+V2MxrRsb+xuQGaX7
	D8qEoI5mTUJ5dX0KppV/MV6ULnOt8c5bMOyliiEPZw6K70hrR5YndM5SQYyUQb8FH5kYsI
	DpwNblXhpH8xBsRgzBdKJdlqbbHF5XY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E227434B3;
	Tue, 14 Apr 2026 09:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0060CC2BCB5;
	Tue, 14 Apr 2026 09:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776159864;
	bh=8p8lDCTXiWfQf27VA/xusuPatXsACxc8r/8hlrp5Sdo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=slpqucUPGENAkKmOkY9joO0vtpfbzWZiKgKyF12jOCqixCtcKwpNyoqDaSA2eNyJF
	 FxtizWhVP/PNV5XoIkKpx3g21ee2DTUq/yQdELQZf3uR6E+fhHGu9kIWSWSqvwrU8Y
	 PtcgrXkO04jCdxI8mo3p5D+cB4UhmLvkQcaTMaP+xLTr4XTOZwEE14ryEztLthdSSr
	 1govWKNAexcGyjQ4c96Un0NONjitxODogWJFVY1dWbTeEU0Zc5diu5PDAybAPj8PlH
	 5vKHNZ25y0XDazTk2hsRPlr8wsFlcTA+wdw+eUtdJxf+xbnKvh9fiLN6v9a9Fv4dBr
	 NENW05HucXRMA==
Message-ID: <53d748d3-4150-4e7b-8c1f-4c58587e9183@kernel.org>
Date: Tue, 14 Apr 2026 11:44:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/13] mm/huge_memory: add and use
 has_deposited_pgtable()
To: Yin Tirui <yintirui@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774029655.git.ljs@kernel.org>
 <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
 <41b1ff54-c120-42ae-8b74-54767abf3554@gmail.com>
 <fe357495-2e45-443a-93b4-52bf21d3bdff@lucifer.local>
 <c6748ac8-6dcf-41b5-a281-2f21069b1f2e@gmail.com> <adTb6_xqQoQqK74Q@lucifer>
 <2f29f66b-46db-4925-b922-4add61b633bf@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2f29f66b-46db-4925-b922-4add61b633bf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 55FA320009
X-Stat-Signature: ogje7s9tdz68w5g5iycqe1saji9fqm7f
X-Rspamd-Server: rspam06
X-HE-Tag: 1776159865-635107
X-HE-Meta: U2FsdGVkX1+JaxWhML1Ac+CLbEp12cnl6Gkgho7fcLH/c7gkwpYL+mNLXV1VQ9wZrbmU98hFalLSlEFROIOLMpMkauXiBExlNtBaKx9AKPiJYPEwZ5O4GMRmoyAchbJM97lywAXZc8PaS6uf0pcoTES2wrW1yfJLNzyORQzf8Sjz6sSRbXcX0kyDbDn21Pgewm2d60iX4dNdZSl18HjSXhLFj/E+aRZ/S3manmyOo10cJZRRbzctQkQsSEkMWCnAErAxSMfE9BAqWUdd2ULr7qxb1y+ZsnY8k7sGmr1xX8TTqk5ayQlwEH7GYO27bzKYQTEQ1vs/F19JV/c3wRZ5NupOEIV71F53lLdnwgxRsKkJt0OB42qFAr0MOPIgUZcocWFzFNbAjkhpGnzY4NZ37ycWz7MsduJy2HptqBBhq3XxaVVm5NaL8mW9MIIbEejM1w4iBXY5buKe4H1N0BOUjEdCW4IA8sXqVmAoSApOddCMr/AKgIDjoeE7NDLqDlU/dwruXJI8eZHD407QhsT+H6jPjNIMsLep5QDkDYJygulzJWJe9uOQEYayjP9MbBdUvtI9DY2w9oeWYOFE2D7opNN//qQh9BpKaJu/Fl9bmjw7pFaoJ1NwlRUJwwr57xyTP7bTZWrGLbNqi1DPOaiTdb0atEG9d5iciBhqUmhwdvpjdcG7JpYbYmeXB9pe8o6SfVUaNdQE5Il/xzo+o83L8zhV39XQMvJ1ZL3lOJovdEyUaB46MY1m25PhY7IM786DlwR+TNdf2qvbKYBuk/XeS6TBfZCxrdMKQiaWpyUQ5iaZzvRWLU5aJ0TnJBfgz7qOJlSH9BMhycyRd5fXxiDq6s6KlBZEDGAe814Rtfvjm4J+XlTvKSf9ml3ORAwNaiVcNiImEZDWDXDqiBBlO/R2133ZVbiR1cgz0C3H7orJ/pNGsN2WgoRu1xguBiI+ti+l8dyRhUDSsQ9wBzHvIUQ
 51Q7+mqE
 4Qt1S8G1gT0IMpAPEr5ne90td611lQLQ8xNQl3jGKrn5DyxHgs9bph6LRzXCP6COfSR5ilZBJ9vJ8zDvbYF5YiDx6I54dG++Qc74ixTGOwkxZF4a28Z2KpLKlbHerdndYo6mNJUGq7j1OW4EPbZRYlCHRN4a6qnqFEXnQjBPfbg4PlEsp0gaC1hVgj33XeRPVuBfIdUcdtG52rZ5A8O52twhLwzFqGhhVlvjVy/idKjmtlF8Fx2o9YVAMsVM5tmSZ35IoKLP+kguM1ZLWBQik6UWWPLu5GtyzspTJe4BAms5XCYvZA7SXBrj9TA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 09:36, Yin Tirui wrote:
> Hi Lorenzo and David,
> 
> Sorry for the late reply.
> 
> On 4/7/26 18:48, Lorenzo Stoakes wrote:
>> On Thu, Apr 02, 2026 at 03:49:35PM +0800, Yin Tirui wrote:
>>>
>>>
>>>
>>> Hi Lorenzo,
>>>
>>> Thanks for the quick reply. I will definitely CC you on the v4 series.
>>
>> Thanks.
>>
>>>
>>>
>>> Here is the dilemma:
>>>
>>> Currently, VFIO uses vmf_insert_pfn_pmd() to create huge pfnmaps on page
>>> faults. This sets VM_PFNMAP in vfio_pci_core_mmap(), but it does not
>>> deposit a pgtable (unless arch_needs_pgtable_deposit() is true).
>>
>> Hmmm... it's only the VFIO and hyperv drivers using this.
>>
>> Wouldn't we generally want a deposited huge page here now we're allowing huge
>> PFN maps?
>>
>> Or are this _special cases_ where we have a PMD-sized entry but are not
>> necessarily wanting to treat it as THP?
>>
>> This is a real wrinkle in this whole series no?
>>
>> David - any thoughts?

Sorry, catching up with that now.

>>
>>>
>>> To resolve this,
>>>
>>> Option A: Force VFIO (vmf_insert_pfn_pmd) to also deposit pgtables. This
>>> unifies the VM_PFNMAP lifecycle. However, since VFIO can refault,
>>> depositing pgtables here incurs unnecessary memory overhead.
>>
>> How can VFIO refault as a PFN mapping? Does it intentionally sometimes
>> clear PTE entries to effect a refault, and implement a custom fault
>> handler?
>>
>> I guess having a fault handler makes it refaultable...
>>
>> I mean obviously that then contradicts the suggested comment above :)
>>
>> That seems to me to cast a bit of a question over the whole series - having
>> PMD mappings that are _sometimes_ THP and _sometimes_ not is weird (TM).
>>
>> And it'd suck to add - yet another very specific check - to determine if we
>> do, in fact, assume THP for a PMD sized PFN map.
> 
> Yes, exactly. VFIO and Hyper-V rely on their custom `.fault` handlers to
> dynamically build mappings. In contrast, `remap_pfn_range()` establishes
> static pre-mappings.
> 
>>
>>>
>>> Option B: Introduce a new VMA flag set during remap_pfn_range(), which
>>> we can explicitly check in has_deposited_pgtable().
>>
>> Yeah would rather not, that feels like a hack.
> 
> Agreed.
> 
>>
>>>
>>> Option C: Check vma->vm_ops->fault (and huge_fault). We would only
>>> deposit pgtables for mappings without fault handlers. However, this is
>>> fragile because a driver might still register a .fault() handler that
>>> simply returns VM_FAULT_SIGBUS.
>>
>> I mean again this is yet another check (TM). But probably the most preferable I
>> think.
>>
>> Wouldn't a driver doing that be being somewhat redundant? E.g. in do_fault();
>>
>> 	if (!vma->vm_ops->fault) {
>> 		vmf->pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
>> 					       vmf->address, &vmf->ptl);
>> 		if (unlikely(!vmf->pte))
>> 			ret = VM_FAULT_SIGBUS;
>>
>> And so can expect maybe some more redundancy if they also happen to map
>> PMD-sized ranges? :)
>>
>> And the only two callers of vmf_insert_pfn_pmd() - hyperv and VFIO both
>> implement actual fault handlers anyway.
>>
>> So I think this is fine?
>>
> 
> I agree.
> 
> David, since Lorenzo also asked for your thoughts on the overall design
> aspect ("sometimes THP and sometimes not"), what is your opinion on
> this? Should we proceed with checking `!vma->vm_ops->fault` to
> differentiate the deposit behavior for huge PFNMAPs?

I mean, we need some indication to know also during folio splitting
whether we can just discard the PMD, as we can refault it later, or
whether we really have to install a PTE table.

What if someone used remap_pfn_range() on some part of the VMA, and
faults on another part?

Doesn't really work.

Do we have users of remap_pfn_range() that have ->fault set? If not, we
should probably just disallow this combination.

Then we know for sure whether something was installed through
remap_pfn_range() or through a fault handler.

-- 
Cheers,

David

