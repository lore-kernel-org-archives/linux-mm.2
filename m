Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 400C1C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 06:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7CB6B008A; Mon, 29 Jun 2026 02:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 189206B0092; Mon, 29 Jun 2026 02:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5F16B0093; Mon, 29 Jun 2026 02:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D93476B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:49:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 504D5167EDC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:49:08 +0000 (UTC)
X-FDA: 84932023176.10.10F37F5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0C261180003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:49:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qir4B0AP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782715746;
	b=kll6/D89W1DzUNF9iF15ZgvbfaZO0x8T/6FbuhuQwdanifVobTVxyk86JXZPFMpquTJBob
	0qwnNRV/J4Shz2uPQW2VENXByDscgGIzrDAirPwgrWvJNEVqsSzWcAbtwZFlEUQQsF6wWs
	rWJAf9TGAqz5GPnHQrbrX3CxF/t24lM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782715746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYyoCzX/VTBLNOe/kKJ0m7L/rq4Xb/45Wd9kJXHQcKg=;
	b=A5lDiMGk9P5KQLIt7N1FrgNVzLuV6DVH0j+Kbxa/m0HN8i5t/IdDltjAI0X4Tp4U/3Ng1C
	CISzLw3nMttHPa36aRjhGSyvWVvWwxVs/TDH7XA/bHiprLJeJw0k1y1vk5m5YbbSqjz12Z
	Q3J10EFQxOIPw9ri7PTBM1zfTPWgIvA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qir4B0AP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B142F176B;
	Sun, 28 Jun 2026 23:49:00 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 720CE3F85F;
	Sun, 28 Jun 2026 23:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782715745; bh=WWesDXMaxpr9v0pxKfGfA5W4afJMug2+aRszzj4Irak=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qir4B0APt+liPIhMhV/X6VjodvpmrcL2dgZo8y3s/326ijhOw00p77WP5smmRoG6V
	 hHZ+WfMYnb38XwkL6UB2PFIIjGGWwUVgVzDUp3C2tW4fUEj5cGTXjksQ3LQGTiUljO
	 16d5GBzKOj3sW0EgqUgbb11lIqBZzsh8R3C+5lqU=
Message-ID: <1d6d699e-62e5-424f-a147-b7a75b966957@arm.com>
Date: Mon, 29 Jun 2026 12:18:53 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lance Yang <lance.yang@linux.dev>
Cc: linmiaohe@huawei.com, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 kas@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rcampbell@nvidia.com, apopple@nvidia.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 mel@csn.ul.ie, nao.horiguchi@gmail.com, ak@linux.intel.com,
 j-nomura@ce.jp.nec.com, pfalcato@suse.de, dave.hansen@intel.com,
 tglx@kernel.org, jpoimboe@kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <82395f5a-31d4-406b-b7ec-10d1a9d067d4@arm.com>
 <20260628054402.76978-1-lance.yang@linux.dev>
 <98f3aedd-de11-4a83-81b8-f3e3c9380e49@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <98f3aedd-de11-4a83-81b8-f3e3c9380e49@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0C261180003
X-Stat-Signature: sedgk51cacd13ky784xq9ua7acp1xcxd
X-HE-Tag: 1782715745-507336
X-HE-Meta: U2FsdGVkX19N6HfOy/87h8KvjdWWBcBNGIl5/6nKGdMWdHQYxLp/Hr+MxT+q6gf3NJhSD8y2KoA9lbY+9WK4/iZgEtfbx/tVehUdOBa12srCrk/7Kahyn7iHLBw53n/Ygffd5RKcry/L1j3WUCl9SENc6c6REH1T0J80O3SpUlUasetSpCHdl+djrLJeqxLsjBtrN8mKbZ8gdS6p4hijv5smZgDcHd0wwWWPbmBwkRi9OZjFmqG4iD4sGA/4xURHGL/+scBcgE5Y8cXVziKDPBC+OlJFuGT5PqPZWDRMzSxPWtx+TFLtZ/5wTILZLwRoYmLtnPyKD+oI94wqrNQVzqn/snbdintjC2LNXcmJEmq4D+EJ1qdBuyuHp4uZv27Y/UlhVnvcwcVF416E6lRBO4UD7mShD13uHr7JstGWrGEm6owc/7+oJuVYxRYsOA1IpvSau5p/mjzEWWprdB7WrwnjeJ/EAAAPVjARGzd/x83kCUBv8UBg7ABU7wGTsFuiW8PEPGqIHHVP5zGmYQskhZkwRPq0DPC1PwvZk3TN07od3KnF3keRlKmFcEknKgZ4atCJYewwQPlzSE9qzI6SsFMcOIp/y4YX764whgMOFJynH3vjWxadPpfxzxEj3YGhOdkJLXbcDIJiu2Y3jcm5Xdyd2xedcL/dFy+xu0RrGkl7pW64EkVTYHHEkhmvOecM1JGBcokPPeneb+IGbf8XHb/iWAI1xQmbkFSUZcXCMqcsksujk7RFe/CTHV8Hr4Clk3kkeUH5idjVNDazV+4f1Bj27BV4ji3xi+H2m3hwLxLw871Lg5gEtui5p2Q5cou0VrNSOSGLNKZxCWrr/I7L1G03fIyzkrSRWDxy79y7nkoqzqSTyDO3Gsfp1vRXHeKSw+knJYwS7w9GVcl2OGVwRj05sfmUHoRVxfnxVE8oJnRHDt5fiRyjo1rgkhc5nUc3sfwkGnWi9pTBZUsSp3P
 Tw0WtvTU
 lLRroDD/EQLo5/s2X66Tquxm+om20qAv9LGwmy6kTdtNg76Pm+AHx6MWRe4qcloaKxnRY0HlFkgxxjfesK15CtgBfQ1NBfosRsfadPigZ1Cs8E19O+ffZKLTwx6Bl1B9+HjEoPjd28URqiM0VS/kWkmFCN0Ds+yGWGE5dkx2343Nk0Aa0FlPFzxW3v0eAapBRuVN7Kq8dRiUNpFngIYnSCQcgK5lZiIBcTUWNf8fb5qXTj03KYWfVkBlEcN13n8e90CRNONDx1QPbBOsexOuKOz1qAYV52m6CDxfftrxVZ7UUZSrFhPu3zysGVUsmFaJ6IVxtUxNYoxIHaeOKdwhVbFldF3WMISan9swE6ycfMuDfNY6iJOBg2QHabMqsubQThmYROkwygH9Jpjpq7HCkll81IwnVKaMNMekeeYjtru/kLGNr7g2dw3gyoQAG2aapVad955wotBKvg+DxnqaaBOrsuQrZBV16iUuU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/06/26 12:09 pm, David Hildenbrand (Arm) wrote:
> On 6/28/26 07:44, Lance Yang wrote:
>>
>> On Sat, Jun 27, 2026 at 12:43:31PM +0530, Dev Jain wrote:
>>>
>>>
>>> On 26/06/26 10:16 pm, Lance Yang wrote:
>> [...]
>>>>
>>>> Just thinking out loud: given that huge_ptep_get() already assumes that
>>>> addr matches the huge pte, at least on arm64, would it make sense to
>>>> have a small hugetlb wrapper around it that takes hstate and aligns
>>>> the address before calling the arch helper?
>>>>
>>>> Might make the rule clearer, and a bit harder to get wrong again :)
>>>
>>> Are you suggesting something like:
>>
>> Yes, that's what I had in mind :) thanks!
>>
>>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>>> index fdb7bdf7645c..xxxxxxxxxxxx 100644
>>> --- a/include/linux/hugetlb.h
>>> +++ b/include/linux/hugetlb.h
>>> @@ -825,6 +825,15 @@ static inline struct folio *filemap_lock_hugetlb_folio(struct hstate *h,
>>>
>>> #include <asm/hugetlb.h>
>>
>> Maybe worth spelling out the rule as well: 
>>
>> For arch helpers that use addr, huge_ptep_get() assumes addr is the
>> address for the hugetlb entry ptep points to. arm64 already makes that
>> assumption.
>>
>> Callers where addr may not be hugepage-aligned should use
>> hugetlb_ptep_get() instead.
> 
> Do we have any examples where code would do that? I would think that all code
> must properly align addr ahead of times.

Sashiko notes other places:

https://sashiko.dev/#/patchset/20260625112955.3254283-1-dev.jain%40arm.com

> 


