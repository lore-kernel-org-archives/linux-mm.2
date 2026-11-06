Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5182606D80D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 11:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KoqO1Qim
Received: by kanga.kvack.org (Postfix)
	id 138296B05B3; Fri,  6 Nov 2026 06:33:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 110616B05B4; Fri,  6 Nov 2026 06:33:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 025816B05B5; Fri,  6 Nov 2026 06:33:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CCE6C6B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:33:19 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C48F41C483E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:33:17 +0000 (UTC)
X-FDA: 85404483234.24.E8EA214
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C15211C0004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:33:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KoqO1Qim;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793964795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwhjR2jVQFrycXPK2wViGRifyfXgiVWt6Joh/0g230U=;
	b=1uhsakPbtCx8uEx37uKUqSjj4+cOPWdm8Cx+VEE8GaTwahUKM25IytMgslHnIYAvh41DeN
	0sgaqMwaRM9HPuMXC6h8zQfreaY/miMO+dR29LyY4Qx74V7OoxR6rFUtZ71Lyj20gcto6Q
	uzR5RPWL7VxYZZtjVSiyl4Im3vRHHnA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KoqO1Qim;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793964795;
	b=gwY7RBuE6IUaaQ/rqBsJoJvbB+hODKdJ0dT99fOBeGoslRo9UIYCJdZgEn0W5USSLMAQUv
	TbWH0OGHnQ4q94nqm942Res36s6L/mHHU5axbj1uA7fVmA6h1dFBA5nlQi2JfH6X5YD3UJ
	9aOIYydyuy9g/mZrU68qsTivPvsi02g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A580343D8E;
	Fri,  6 Nov 2026 11:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A901F008A1;
	Fri,  6 Nov 2026 11:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793964794;
	bh=dwhjR2jVQFrycXPK2wViGRifyfXgiVWt6Joh/0g230U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KoqO1Qim6fhPciC3HrjGQpiNGTwfFkaaXnbHF/sP3XEWozhHAXPaWtoWRY5xXxTze
	 eoeBWbY+1e+iiei4kEtpDFZkgWVi1NnJjmmD5F8Cp1ysUYb0CFCThB71XKqLhs6Nr+
	 TSHxDqrRA1Nk4MJkHxtKif7C5VT1dbiGt2+HXmlV5ve0AnML+weKBLu7Xza/Y2j3vH
	 0XuZnoQlmW/YQ2MwmJlpufFDS4W3DNSthfkON++SKyn7Qzy8SAkajdVWr0Q8vJ25Va
	 T3dQpWZfOXJuAZYXgBTtazrbQUwosSq5FlT+W9+lViaQx4kjtlYjoS8Gm3JiJ9EOfD
	 D7+ozfAk3yCXg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 725E6198003A;
	Fri,  6 Nov 2026 06:33:09 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 06 Nov 2026 06:33:11 -0500
X-ME-Sender: <xms:9Lrtaqkp9-3qkexNMvtLxgPrPnal44LmqtyIgUdwLB4SmxkS8dGE1Q>
    <xme:9LrtakI3cPRKr4852ao8p7a2WlMa65T0MWCOFdxesHhJ83q3rl9YZllV-pvXxREAG
    3TEBByUImzVX4Za3JlhhvmQ1vIgAMAsID2k9o4d_TJGi8RnelAkbgm9>
X-ME-Received: <xmr:9LrtanUwGC87sY1OI40EDIoynU-OFR5U63teqDTIuCXa8opSVure6Gds49o>
X-ME-Proxy-Cause: dmFkZTEEFydlobSPmqq0NWC3mdnVpucy8xcvPzschiasYSG+OlRLasLiG9TZecSqeMAclu
    7ECEtWVEhVpFWw9L6x3TGu7nLR1O8zMFRELSlvLmXKF62TGeSu+644g+WtnosqAEJIBj3U
    1C1xys8WSxfv9kl/qzdvEzw3Cmj6rt7AE0u4GPfINkxDQ8zw5DYnQjjQtbTR4RRoqjyH3J
    xSUHuMOjWG/Jv5cLkhX/zTYDAz1ltDGIqG6hWds/QusvUCZGhIPZDTiXfUTJ7XCWMS2Inv
    DKk+mMT3lijC1m0RacMemu8D1Nvwd5LmLGsePLgiHP+eq5CrM0rj8rw3sU2o8aU0G/aqZY
    A69lcB4t4u/6I3XF0CLKZG7/FrHRMbIFy91zFZsNq52tbDvUbCUw92oGtyfOeBsfeeHeww
    szcOiH3p4asmaQMuWqhZSIJATRQx6Yr1IMLeUQMILL65RAq7YfKG+2GdkT/+LIcpxUBzwR
    XqFgJ8wxShaUOclMoMCNjGFiRyWU2+xFwKDBGiHXON7plZ5a0RyLEHmhszCw6SdkseHAUi
    iQvRY+kFYPLRCy8uR2wh+SKRWNDRH6kJe8WsrQ9L5nRgDt4qaub4NojRxEwuzGRpYfEmTk
    JXgOWukBYX8wmNJNrd8qNKlhsASz34Kb9aA7VBHVdrD+CSShqlN4PNWOK6sA
X-ME-Proxy: <xmx:9LrtarjV3mOSTqEcSTQaGqQ2WA_JhkjmAFoYe-W-js3fCWW1Rhs4Rw>
    <xmx:9LrtamdsFe3goRTjxc25y1zLrqNTxsgWzYZAgDmI_q9uhStOCjquiw>
    <xmx:9LrtatthR6KhOJSalUybeoTVfZ8N3aeen0odPHYe4f9nfn4kmqSvJg>
    <xmx:9LrtajmCqGSLd0xyR7P5i5lLOhaPZJNytvL5pCRdx8z8e1yoZXVm9g>
    <xmx:9brtahOQu1ng3v8YW7uyxKi-JWtXj0BnCwjxZwKEUJ6w-uO2HTj4DZXi>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 06:33:08 -0500 (EST)
Date: Fri, 6 Nov 2026 11:33:07 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: free unused page table when setting a
 huge PMD fails
Message-ID: <au263-sEU03puJQm@thinkstation>
References: <20261105-khugepaged_set_pmd-v1-1-cb79ab117199@kernel.org>
 <aux9liPvdZgpKCpa@thinkstation>
 <aux-ZdKu97JHLY96@thinkstation>
 <c13cdd25-7d7b-4059-a22d-af0a48fabaac@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c13cdd25-7d7b-4059-a22d-af0a48fabaac@kernel.org>
X-Stat-Signature: gcp6rxi6hagx11518x65pndw4c5k6xt5
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C15211C0004
X-HE-Tag: 1793964795-422283
X-HE-Meta: U2FsdGVkX1+IspS7zgFv+RTJV3hpFJxZN1a8mmsxkEoWJjVlghmjVV8GtGyGuAbgdczsrSkzH78uT9t2SXVZmW12ryINEJ0GbJUOMdVNYrumn4g45Ju2XZ3AiaYK7hatCZuE33WeQ3LvdniXZQzWznESiF9ChEFufRW8lE5Y5SAl0kEvaubNzNrdbmWIpftzR7PsGRdooGXD05lWjSnEGyWR9m4IODRc8fROvfs3NQok4XCUeWYbvv5Tnx1UH36AubKEk0HThW171NbcPvg30abyBcftR3l//1bzhW9OmUMfBevMQxCQOPb3tt+HbWESvVmv+RRhsKWhgic3StAmFs1ug0UN5QnJ+hEuehXNinPcWXcKZJXGE5Qhc15H/fWhRbFLu7FKLZtwaS8In3MxefozdrXQeCTtuaiWGyR57BKAIAuK1odK3PwqRWOQGd0NgEjHz6wGSpGgcfSx6p20d1PvBSu5FljbgVnGQzC5QrZj33dzG24SPz9JWWTgcL2h8pRgrLZbSJ+xbB9J94P/KGv3uff6ZvUYAfOHKA28ONtXVMtAJG8l29tByyu4DLE4BIv31SRt1lshC2pGURJKqbQpNo4YtvRufGicFIAyL5INR55XGFA7r0k5AFGqcfg7KwcWorg6IAQuPwUnWUsm7lVZA+Fclsv9WOXwbekmww18XGMj/GLg0kcVZZQPQdEtEc2aWuOpvIttrPgjELcvjlSPEwmGLSkoVCAsYigOKJcLrS1hkwvsdiR5UfXeefV0xVLPs1djbJNWtV8L1VdiP5ewHOE7SbEFzAm5XTo5nmJHaOHzEP3c19kWmm9uC+jN5fXpyqcHTSRXYSP0dl+1xcWwPGpJfCBenJ1iVJtRGoFYGhRKPhzWnC/NC5XkqPfY77FQDwXB/cdscE+OpViuDh6U2wMotbdukTSFw3AFuzchyIjvl4fvJcnsZzzN3b4I6GQIO+tLlKgcjDzVqtg
 cvotSbzl
 4+f3ytWOB1PNZ6/RKWOD3IrjFye6+xWdCW43/erzYboqJufhevoo/VnkplM97xhX+v3SJkmDYHJwHPtYmZEhf5YDLhTpYUYzY2c4t1V+OniLiQYd+bTnl9uq9zrKx9sRF1nV8vGeleIezktXwUq+OcgeC9Nc+VTKt0exo4EYiCxrA7iffq5x14QBmmqGmlPVEPJ5duL4lcRdtJhZ89fc7rNJGqzUj5Ko8FD/EcwqN4vHBCMiM7W6KbICDKEBYtrkTIhR6i0VPBm32jVhrvH0riHtuUCQzBjYNxbzlk/uyMRoBtjM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 05:40:39PM +0100, David Hildenbrand (Arm) wrote:
> On 11/5/26 14:04, Kiryl Shutsemau wrote:
> > On Thu, Nov 05, 2026 at 01:02:08PM +0000, Kiryl Shutsemau wrote:
> >> On Thu, Nov 05, 2026 at 01:16:05PM +0100, David Hildenbrand (Arm) wrote:
> >>> do_set_pmd() can allocate vmf.prealloc_pte on architectures that need a
> >>> deposited page table, such as PowerPC with the hash MMU. If the PMD is
> >>> no longer empty when it takes the PMD lock, it returns VM_FAULT_FALLBACK
> >>> without consuming that table.
> >>>
> >>> Since collapse_pte_mapped_thp() uses mmap_read_lock(), a concurrent
> >>> userfaultfd operation can install a PTE table before taking the folio
> >>> lock. If that races with set_huge_pmd(), the unused preallocated table
> >>> is lost when its local vm_fault goes out of scope.
> >>>
> >>> Free vmf.prealloc_pte on failure, as do_fault() already does. Successful
> >>> PMD installation consumes the table and clears the pointer.
> >>>
> >>> Having to do this cleanup outside of do_set_pmd() is rather nasty, but
> >>> other callers depend on it already having been allocated. This needs a
> >>> cleanup at some point.
> >>
> >> I hate this being outside of do_set_pmd().
> >>
> >> What about making do_set_pmd() freeing ->prealloc_pte if it was
> >> allocated inside? Nothing changes for caller.
> >  
> > Or if we want to keep in set_huge_pmd() then set_huge_pmd() has to
> > allocate it too. At least, it makes some sense.
> 
> It's all rather nasty.
> 
> I thought the callers depend on it, but if we just free in the function
> it will behave the same way independent of arch_needs_pgtable_deposit(),
> so that makes sense.
> 
> From 4e8d0a928f0b21e0583dac9234fb1821f3c973b2 Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Wed, 4 Nov 2026 20:56:37 +0100
> Subject: [PATCH] mm: free unused page table allocated by do_set_pmd()
> 
> do_set_pmd() can allocate vmf->prealloc_pte on architectures that need a
> deposited page table, such as PowerPC with the hash MMU. If the PMD is
> no longer empty when it takes the PMD lock, it returns VM_FAULT_FALLBACK
> without consuming that table.
> 
> Since collapse_pte_mapped_thp() uses mmap_read_lock(), a concurrent
> userfaultfd operation can install a PTE table before taking the folio
> lock. If that races with set_huge_pmd(), the unused preallocated table
> is lost when its local vm_fault goes out of scope.
> 
> Track whether do_set_pmd() allocated the table and free it after dropping
> the PMD lock if it was not consumed. Preserve any preallocated table
> supplied by the caller for PTE fallback. Successful PMD installation
> consumes the table and clears the pointer.
> 
> Returning without a preallocated table matches the existing behavior on
> architectures that do not need a deposited table. All callers
> already handle that case.
> 
> Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

