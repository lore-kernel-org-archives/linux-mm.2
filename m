Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ECCFC43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 07:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 050BE6B00D7; Fri,  3 Jul 2026 03:06:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1C066B00D9; Fri,  3 Jul 2026 03:06:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEB216B00DA; Fri,  3 Jul 2026 03:06:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B50B56B00D7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 03:06:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 396FF1203EB
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:06:58 +0000 (UTC)
X-FDA: 84946583316.23.501773A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 67A7140004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:06:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DnR1vQWE;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783062416;
	b=Ihhy8NXFyOq5MSHQqwgnhX3AFInI1MW6wthZIxX2U1EVnXI8afG950eKObpuCJ0w3w+PLH
	gzFO1n6qF6Up2UbPmXfhMyEqM3ku1flLdQFZIUKF+ynx/97NUirLqACV5eFPyxLZD7xku7
	1TOM6RpJjYPsAvsdX3U135IPef2kc+w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783062416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4piB+34XL+KRHk/H7cX5eonmByAQ55KhjuwPcounnz0=;
	b=PpCsNz2s8UmIqhrDzCYI86sxkOZoGlE95O5OAJNAXM17DbvpwCWC0Oj/xvm1cRkghrG+bk
	n3oxOL8kFwuDYhrOsOILuxE2/KTKMPF9Qp5n2hG4bhEaxvtpFVj7pDtBMd5fQDBGO4P3Ge
	PSoKmkE7u9nFa45tk5G/s1PgXtmIvEo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DnR1vQWE;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D209413B7;
	Fri,  3 Jul 2026 07:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A661F000E9;
	Fri,  3 Jul 2026 07:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783062415;
	bh=4piB+34XL+KRHk/H7cX5eonmByAQ55KhjuwPcounnz0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DnR1vQWEy7SOqZOkad+cMz408hpbdEeW1rFEXVMkJQGbj0pIJMlUurDtkcAC66OqC
	 Wn91EDTa/5pobK+HuZ4dbs4W1cVmDrqVT2hNGnm6F+uPv9+NGBnYLTWMTvIMOQrIDD
	 xJt2AEWEa4WHkGrSnW7bZSGaXeW25aL664SlQ06qm7Yb/ZLHjmbLS2BRL+MavVdudO
	 XeA4Thj0htfCJBSAkqepkMS1NmmYSIiblcXXhKKHdAIMmlcvuKYnGBkSklagStYqlk
	 0Qlp/bplhyrEH4j8SeqazuMtCQQkn/oLiJUqxsCXF8Mio8EBqpoVdQW4Dyx2cDgyGD
	 ol27RsdpjMhYQ==
Message-ID: <705431a4-c301-41df-87ab-c0b4a4069f97@kernel.org>
Date: Fri, 3 Jul 2026 09:06:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
To: Dev Jain <dev.jain@arm.com>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, j-nomura@ce.jp.nec.com,
 nao.horiguchi@gmail.com, ak@linux.intel.com, mel@csn.ul.ie,
 pfalcato@suse.de, jpoimboe@kernel.org, dave.hansen@intel.com,
 tglx@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260702051341.126509-1-dev.jain@arm.com>
 <20260702051341.126509-3-dev.jain@arm.com>
 <00d6e0fb-dcba-45d5-98c0-f5ed81604ca0@kernel.org>
 <1b1f6281-2a46-4811-bbea-24a666c0a772@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1b1f6281-2a46-4811-bbea-24a666c0a772@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jukxtn98rqnc7rwb1fgad5i916n1i7ff
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 67A7140004
X-HE-Tag: 1783062416-604702
X-HE-Meta: U2FsdGVkX1/aBS3eb5/PSkRBGl0GY0NnBlXrcoLhOdF3szL6OVAyQ57AMY9Xfd8M2Ew4DSwkZS3bR9FF1mBfus4O8fMVZ24+0srZAFTlR99HOVN+fqFWwSHrdfXYP3VOoJpBOwS0W9AvcYz8B1gCngW4S83+X78XZKWwKzZ1zAXtaUzPZB9b/c/y62qlh69RUbMKLx/H5SLZtSEBmaxFYxWf5tmUQ42mxlEwy8t3UPCdvbUuZpuyZvY5uWGWdhbHeeprVwl/L1ixdjdI6fyC5XnqORfamARA1BgYum5QoyVMc0iN4w9fgs4hWFkw7lhWm2BXvHK7p3cIYmKxutMP37vBBz4tKvVkAyT/TLbv7zU5WTttdWNJLmVWUyAvZiBqdLwngnV2e2xvvO0uHYJpmH0oD6Raaqt0su94Cr01o/F2B7UKc1rO33LYlxd2CbnRBJMEVIfBiiZlJCBvwpk7w40pgRdrNBSoBjwv83cWW/qLMU1Ceqzr3V7NfIGDOB09Irfi7GuEm1sADfI22OAV0lHAAd6VrmKJGYY5ILvLtcHYSVh/NuarjObJASgd5dsFiGUEOLo8PKcTUWawHt6tA0DzEnux9rvCuW8J9Hh6lDCVwgf8ZxLLyX/X/O+P+CL8TDC3BvQ7Umt5Mrtd+vhIy+FuKEGM595IyQaO4+TF6WuVMLQJAxV/Ax/tac6F1gRBdf8XiGr9ptDwq/Hx7sDKcshg5IkrFVzXhxludZoS0JZP2RiVw9Q7QMl/IgPqzIx/+aZFxV6BSqM/HXE+r15U98kzf+fYvHle9kRdKkDWtdMEub2n8w0DG6vhTx31V5VmwFhSDFkdcffJ6inEQvH9cSgGIS4oV5O05nl/fSKEI7MZuHPRU1WgJ9HVLwCBRAYTjrISVqavkSJNa2UAOWZShTs+7IOcNeaHWENxtSNZ7Kmt+Sy0Hcqiwfa5M/xl+NHFW14orssqo79IZdUHbR2
 kd/9H3eh
 QfWOPiYgSjZITndvl38bNdWmPV/TmalGdxnHEFU+j9fBfAZqiOT1OpRcD58HfiuCeo7KVhlt07JuBS5FAOyxseSjd+n5+uhsxLrTa7UmEB3tRUaJzrLQmtkKxROp6N8jn90nEhBoVBFoQ9jajuA59kZK8BMiaYPKnlEK5zUf9uZDGLMbp5uhOKT71hCuGHWL/u3o0qyBmZKWvZyM9DN6iCsZRLDKdeMxzsuAkx8eR/eikNt32Nw3rayziMIqtdymrx23faS3VQasftsOmcZ0ij6iPstV0mpOo9FboLQD2BCxTk7rg4IZkHFsZa/vHmiGqkjGJAjsVx07DqSgiCIPHTRGOrclzub5iQO/dCsKt/Xw/5ZDRdFo8Nyhmt0GkAEOQe67k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index 1c77d5dc06e9f..aa8a254efaecc 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -2095,11 +2095,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>  		/* Unexpected PMD-mapped THP? */
>>>  		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
>>>  
>>> -		/*
>>> -		 * Handle PFN swap PTEs, such as device-exclusive ones, that
>>> -		 * actually map pages.
>>> -		 */
>>
>> That comment now actually belongs above the pte_present() check below.
> 
> Oops I mindlessly just copied the comment.
> 
> I will then rather put it in the else block which gets the pfn from the softleaf,
> that is the most appropriate.

Works for me, thanks

-- 
Cheers,

David

