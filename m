Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F191C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460E36B00F1; Thu, 16 Jul 2026 11:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39C366B0159; Thu, 16 Jul 2026 11:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264E36B015A; Thu, 16 Jul 2026 11:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E05706B0159
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:14:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E5BA80159
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:49:25 +0000 (UTC)
X-FDA: 84994620690.01.D8CC690
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A79D210000F
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:49:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EBTnCvJ9;
	spf=pass (imf14.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784206163;
	b=ELujNY0GH1reRMI/guHCItjwOqaUVE3nLKCV1TqYjNrquGPC+j46BqG2oXX6rAIop8+ibh
	cMHfnlU/SiAG45A4Olw0kwo0MtmLyykKSYwqobpX0qu72C2USwk7vAw9rHJdaH//eiDWTz
	BoIVtIzuZ2Xj+PAmAKymk3XC7ofupRk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EBTnCvJ9;
	spf=pass (imf14.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784206163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPC4/bkySYuEIDm7sSNDHaTK4nJg9WPIz/TBHjyeJK0=;
	b=WMR4AW/e/HG18QFMLuwnmjZcz5qctB8aeBYlq310+bluH08kvMtfJTj4nFD8m7QsxGSdNy
	lWFKLcbuwjOjEWLgU53xs93ECUZy6+IVf8FMxP5lWDplUkuE/JqHbpnXne5clug+Nkffbd
	LxY5WWJkazovGyFjo1auoU7lX3np1hA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75DC0438DB;
	Thu, 16 Jul 2026 12:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8401F000E9;
	Thu, 16 Jul 2026 12:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784206162;
	bh=hPC4/bkySYuEIDm7sSNDHaTK4nJg9WPIz/TBHjyeJK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EBTnCvJ9LBKnvWT6txkoqJfPx80j2qmCPPgtys2eexys61AqRBL/PikdcJ6hRJAu9
	 N/7/eAlmSuk+e3pdfg1br9QTOhJW2GGB9kHXTsWQFNTHz0JCZ97PbPUW/LdJ4+wRy/
	 +XTaRU6ByVV8cgDQ/Y8URNaE9ixhEq3zlBP78l090NnAF3jztLYymQ9AP81piPIYAS
	 +eLW/SudvgS/2t8T899cAQ7pEdr9DwlUjvvFQEk6oEwv3wdptotD0TLRa6MM1FffAR
	 YHD2d42XYxRErp70skW71CAatVzJVw6VUlhs8jh9r8ff+ImW/liW57cAnWmulaWueU
	 l0WsUaQ0QduBw==
Date: Thu, 16 Jul 2026 13:49:12 +0100
From: Will Deacon <will@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: Dev Jain <dev.jain@arm.com>, muchun.song@linux.dev, osalvador@suse.de,
	ljs@kernel.org, liam@infradead.org, riel@surriel.com,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, apopple@nvidia.com,
	rcampbell@nvidia.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, ak@linux.intel.com,
	nao.horiguchi@gmail.com, mel@csn.ul.ie, j-nomura@ce.jp.nec.com,
	pfalcato@suse.de, tglx@kernel.org, dave.hansen@intel.com,
	jpoimboe@kernel.org, catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/6] arm64: make huge_ptep_get handled unaligned
 addresses
Message-ID: <aljTSN3yGRv1OoUN@willie-the-truck>
References: <20260703114202.365553-1-dev.jain@arm.com>
 <20260703114202.365553-2-dev.jain@arm.com>
 <20260705003559.8b124d2b94b685cc2e4e77ae@linux-foundation.org>
 <8fdbe0d6-87fd-441c-b6d2-baac380f6fb3@arm.com>
 <4b4e8007-3747-457a-85cc-d1003e1c8fe2@kernel.org>
 <39a13445-dc6f-4a75-92b8-f4a122c63b89@arm.com>
 <7ac558fd-1081-456b-b997-c7321241cf8c@arm.com>
 <2b9d60a2-8698-46b0-80ae-b8747a66a85b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b9d60a2-8698-46b0-80ae-b8747a66a85b@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A79D210000F
X-Stat-Signature: 6akgb4j9bs4iqfcmmyw8kkixiyqftf56
X-HE-Tag: 1784206163-417933
X-HE-Meta: U2FsdGVkX19Kkh78VQ3l9qqiJddphXbVhiK9RO5/r9XjvlQNtMxQHHCMMJcfvJkN9Wrke7Fp660xyW+8Q39PG09vyHUayEhcfmWX31d/cZArQ+y6vxnUGHptc5zKH7cOWJdHPCyjz8KG7R19Wm9D1QitwMhoAQInFZ2XKBhXWcTXe+Ot0gdtJEOt1/N3G4tcaVocjD5rSsREuWkosGfRH5rrZFEZls1622JsEPpPpvroepl20KZUFK94oeQmE8rH23gIzT7/NuRgj6Sjgq/5siMxKNTG90dfYFdW/F0WZ8IQFIDvQF6dbJ87C8GbiZBUvQUqGegDuQPsECeYzjIyO0Se8nEqE61QXxt12Oev4PXxGMb7y7AA5B0Tz+dAiL+NTuzvUVqvQ/bzFTIUPtK6SPSFgaU4PPwJN6yoOVhUwkA4++SZ1txlJDz+TgMIFD570TKnwEipPdRKxQTgtfF570xmcb64eisdgHlykBm6KYZnqdRZysmdnRKBQyXBCkRWAdZcAGXgUPTTKoRVzZxaklxreCXp+9Vvj4D3WfNFYcWtGPFuWKBV/nAcnjl9l7PiiiL9BNqqjHjdQCpRamsD3ITpSWrueWfNGJ9Fz/5/rXIYsywwsdR8wavuK/9CKXIgVnX8ECv0sAWIo24i/z06QB8oK4nmPf8IUGgmVTEJUKXAehT9hEnCTEPW6pwwAKRX2aD7eT9vRAguLum2sY4fAjIe4INOT8Z+AT7FPq1I0Njgkh9sH0KhT6wFerAnoIuShSZW3buuUCbZXjJffvxcynXIBDYlh8iBIhBf+OkAVb+vRcY5X/+S/v+85F/hOyzdH69HISo9AFvwlxJdmycMSHhb5dIOODEHUuLGcLT45vLMP4hOeZBchI3YwqJcrzQ1JGk8vuJAP9b9rXP9et+KliO3F/U0f+lOhGheK+1Qtfxk1sUpTLo6zL6QbHoKyj8+4ym0ry3ISDCyBP826eR
 U0yRSfvw
 wsnYVL6yadAraHKHBfhG4exjsRdzj9HHqCWSu3Xviq9rNG5DumZnj2tEwMaQAH64t573sCH6cPSNM7jRqNQcSrxl3+n/dQHSlz/Z62KLkRZHCPc/qbDVNsqy6SuHi0pIiT2oLiF/qAlf4bRDNwAgMqLD+OxTpJPBLqlvdcNqns/WsHvZ8iqvyYospsbQjyJcDoLTVc3/+VooD0KEdI5f+xr4ttSEqgKtK59hH38sB/2DlQG3aM3AiuOzBlL7jxlkKCDcKqV6plvwQd9BepDN2SeR6acJkz98pVHgaZCBGhHRFOO1QcjeXEZbO0bEGKcAosvnZKrd3dm4R3WO1w8osfVdRWRKhUvC0ocxk0TkAfmq+eYj4ajTkj22DgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 04:04:40PM +0200, David Hildenbrand (Arm) wrote:
> On 7/6/26 12:54, Dev Jain wrote:
> > 
> > 
> > On 06/07/26 4:22 pm, Dev Jain wrote:
> >>
> >>
> >> On 06/07/26 2:15 pm, David Hildenbrand (Arm) wrote:
> >>>
> >>> Even worse, right? We could walk 128 entries, when we really should just walk 16
> >>> (IIRC) entries, possibly reading garbage or even worse, into a memory hole at
> >>> the end of memory?
> >>
> >> Hmm I was thinking that the checks pte_dirty() and pte_young() wouldn't care whether
> >> the pte is garbage. But, we could actually dereference a ptep pointer not having
> >> backing memory at all.
> >>
> >> Does the following sound good?
> >>
> >> "On systems where CONT_PTES != CONT_PMDS (meaning page size is 16K), we could collect
> >> excess a/d bit state, meaning extra work for the kernel. Even worse, we may iterate
> >> beyond the PTE table and dereference a garbage ptep pointer to access physical
> >> memory we don't own. Since the ptep pointer is a linear map address, we may run off
> >> the end of the linear map, dereference a VA not mapped into the kernel pgtables and
> >> cause kernel panic."
> >>
> >> Although I checked on arm64, there is no case in which there is a hole after the
> >> linear map, but still that assumption shouldn't be made.
> > 
> > Oh but we could access a linear map address which corresponds to a DRAM hole, meaning
> > there is no entry in the kernel pgtable.
> 
> Yes, exactly. With debug-pagealloc and things like that we might have many holes
> in the direct map.

I think this one patch should go in as a fix.

Andrew, do you mind if I pick it via arm64? If you'd rather manage the
whole lot, please can you send just this one as a fix for this cycle?

Thanks,

Will

