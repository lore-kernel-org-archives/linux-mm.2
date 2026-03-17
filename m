Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FC68FD8764
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 12:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84B8C6B0088; Tue, 17 Mar 2026 08:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8233E6B0089; Tue, 17 Mar 2026 08:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712CD6B008A; Tue, 17 Mar 2026 08:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 617EB6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:47:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE514136EDC
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:47:33 +0000 (UTC)
X-FDA: 84555531186.09.ABBAA29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 42B8BA0009
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:47:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mmx0yAMP;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773751652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JVOVG+dPilWaLecgaBdDxvClBnpnkF8r736GyZk/9i0=;
	b=j2FSD/ahBcTmcdQ0d1AuoRSugMIU8PYykQaRoS4qJeFWKVAiTDuG1CbEkexe3Ciwz581aH
	PCMldtaIBOqZQvExHRrY2dPS9hcqY5YHr6M66qSdPsY1XJXUJFe6O6V9Oi5Rku+8GrRam1
	T0rCx1DSmd/26NN1uwtvqxyHOdPFVEE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mmx0yAMP;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773751652; a=rsa-sha256;
	cv=none;
	b=AdmGqWYO1QKh2CwHtTHh2F5JApiiTGzcZlOB4v0xkV6YG3UE0/elb8aiaA0PVCal3+UI0e
	6UAz1UoN9ad0Q9DULY/a6F8T3YS83GwKyw+hH5vUoCKDcbAmzyq4NUY6rjD1hGG3Y5Tp8O
	0XrfAP6yQ9P0RrabpVi7/X6R3iCrVIE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A375660008;
	Tue, 17 Mar 2026 12:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B404C19425;
	Tue, 17 Mar 2026 12:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773751651;
	bh=JTwsqMb2I4dHEBP3Yr6hdh+SSfntwSOXY7WxnE4Jx3c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Mmx0yAMPyaTi+W7LMOLMl9+7j+cgfxWgN+0e8+WOHglYQuD4eGL8x36KMvnKPf8pn
	 wVn0efCAa7oEY8R0Id09hXCEmjRworf4hb93qMp5v/xMr+uwYeFP0hoPWqXx65PWUT
	 28MvJwArdGTlcRdzcbOVdEVX+vwzLSPskqz2CxbZWLn4w9Lf3/9wnOrQNGE78MhC1w
	 8HqKB40pzPWf8MIbg3kDKy+lOBM54cmDfPUaQ8Go8LlCRvyEMOBq2etcU5lk1GT0fs
	 /+JtdnBN9kqfbEOA1t2Fw7892WsmzlseiC2e9U/NDToOC6pX9+JrG7YzEzJ2z+7e9/
	 GD/Agse4pYisw==
Message-ID: <169a3438-40f9-40bc-86cf-a24535494115@kernel.org>
Date: Tue, 17 Mar 2026 13:47:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 09/18] mm/hugetlb: Defer vmemmap population for bootmem
 hugepages
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-10-kas@kernel.org>
 <4e52f70d-e0c3-471f-8073-68c0e9bc94ca@kernel.org>
 <abk58j2bV0sGabEU@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <abk58j2bV0sGabEU@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 42B8BA0009
X-Stat-Signature: 3m1hq6kzcen6simdw3hsacqnkq5cbxrq
X-Rspam-User: 
X-HE-Tag: 1773751652-766951
X-HE-Meta: U2FsdGVkX18+VCSrLDqRlz67V0JnicCmDvGygDhgG7YJKdL34zq3aamoOutu7zhiaqMuUpmGd3vXM4N0HlBMV98JvXrFD0faxVYxa/54xSMITwSPaAcpwInGOGqwyRWaNiX1Kxkrm9FyVzqUN8LBFcmTxfb8srMEBc9YhTg3/fPPqi2mrcXvZiL4fPDjUQSQJmiwtTQKjaBqlUaM5O2Nv35J4QVEszCrQNfLb24sBi+pGtRa4K9sdUo6eYAQhCnNmwyRqyzp/9Oo1A539mZL4tiqJ5kDIu/4JhycC4D1Txnvx5ReHGYjEvnGpKC3cMEO41fZMOmYeHk7ro4QH54jUtkulhqZ6ecHerwgKpps4Tq8s8PIletl6Q+FK0UqgLJ8P8g0qd5endTC8//F/Cr5gvljZKcTW8t64uWjTMrdbXDST2hb3/E1VIM8XmpA+rxFlNHxFBzzslMk2fX/lCOyu2+LiFf6+upmFV8vlYjCPD9pchrlcJiYKEMvj8k2hfFrgUFhWvud9na1COmOrM9ccxT3vKchX59r5+cx9UWm4fzp6TRgJ9wu4FBi04TJTKexU/g0V/VLcYHZxQQnzh9KK1YRAPkX7ojYJpzZ5ATAYRghv7ih0cUbqyn2gHFBN+GBvJ/lkklwCR9BvcScbEgmLyG73m+uYmwSQDn/F9GXPa3u58MZTCuXsg49zQyA/Ki2H8jsHZCPcqSho5C0ClIf6EkunTLdXfA2qQrwNcsq8+QTGVy4BdMF4gZjyrUdjA1iDg0eB1taLa2XhggDoEL9oO//hKb13UesDjvHZ/OLmhOkFyf7OTjjUFg4ZPuRv/uRVpiSC/OkdbW+Hkiy51RewgHhF5i5iXjVSp3Blvi3vTMCXCo/4aQ/vJ79nXtueK+njpbLdTexhMZxHyYMIlQ9/sS/mw++DGxl0P84aCSOydtb+CKu9LY8AkZLr3niiVyQzeVfxuNj5h2AOSUOnBd
 82egqPzk
 CBQy64ZWpIzT1NbFODuCXaEFRm9I+wgrlCmSFJhylz3D8OEaNhatY9abhtl4eYitlaKCwy4UR/eOJkC3lmwl5Dxe03t+Fk2QeWkZxjSpnPiFNBQdEng0mfRiIPt4RU80pIrtjbbUOSqBAvI97N+hbgwK7iZ9RV19SWLRi8p6kF1pYyb2DRnO0O8l4tHIn1uo0cu2bFCQ5AERlZReW/k0P/uQYRUoiSm3aw3wsQgEd0J/ETa6D24Z56WXfAoTTfI+lIXJ+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/17/26 12:28, Kiryl Shutsemau wrote:
> On Mon, Mar 16, 2026 at 05:48:24PM +0100, David Hildenbrand (Arm) wrote:
>> On 2/27/26 20:42, Kiryl Shutsemau (Meta) wrote:
>>> Currently, the vmemmap for bootmem-allocated gigantic pages is populated
>>> early in hugetlb_vmemmap_init_early(). However, the zone information is
>>> only available after zones are initialized. If it is later discovered
>>> that a page spans multiple zones, the HVO mapping must be undone and
>>> replaced with a normal mapping using vmemmap_undo_hvo().
>>>
>>> Defer the actual vmemmap population to hugetlb_vmemmap_init_late(). At
>>> this stage, zones are already initialized, so it can be checked if the
>>> page is valid for HVO before deciding how to populate the vmemmap.
>>>
>>> This allows us to remove vmemmap_undo_hvo() and the complex logic
>>> required to rollback HVO mappings.
>>>
>>> In hugetlb_vmemmap_init_late(), if HVO population fails or if the zones
>>> are invalid, fall back to a normal vmemmap population.
>>>
>>> Postponing population until hugetlb_vmemmap_init_late() also makes zone
>>> information available from within vmemmap_populate_hvo().
>>
>> So we'll keep marking the sections as SECTION_IS_VMEMMAP_PREINIT such
>> that sparse_init_nid() will still properly skip it and leave population
>> to hugetlb_vmemmap_init_late().
>>
>> Should we clear SECTION_IS_VMEMMAP_PREINIT in case we run into the
>> hugetlb_bootmem_page_zones_valid() scenario?
>>
>> I suspect we don't care about SECTION_IS_VMEMMAP_PREINIT after boot and
>> can just leave the flag set. (maybe we wan to add a comment in the code?
>> above the vmemmap_populate() ?)
> 
> I think keeping the flag is right thing to do.
> 
> SECTION_IS_VMEMMAP_PREINIT indicates to core-sparse that the section
> should not be populated and it will be initialized elsewhere. Even in
> !hugetlb_bootmem_page_zones_valid() we take care of it in
> hugetlb_vmemmap_init_late().

Makes sense.

-- 
Cheers,

David

