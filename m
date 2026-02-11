Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FDEAE9E308
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 13:38:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52F086B0005; Wed, 11 Feb 2026 08:38:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2F56B008A; Wed, 11 Feb 2026 08:38:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE5E6B008C; Wed, 11 Feb 2026 08:38:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9B96B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:38:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB2F21B37D7
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:38:25 +0000 (UTC)
X-FDA: 84432280170.17.0F53BC2
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id CA41B20010
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:38:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KTkCq28T;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770817104; a=rsa-sha256;
	cv=none;
	b=O4w3MVjqvnxzYVc+U/nDjo30RJg7Wjvlepf6ODhdfGMXN3Dway/8hG1AvCNC0lcV+NTlJy
	OVipCTnjiozskPOkzSX3vkLgQaZg9EmzE2n6A3cPk2qt0Z1LQQkVPynhh5Ae9r+zHceSjq
	fl2pN+AyORW1GYqWdBDj4RX/prPkTVc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KTkCq28T;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770817104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AvbV/7yBLNX8l/Q3y3FXi6sUQ6jYM1ujaQvV+NINbwk=;
	b=YYxeB70ims2GejpwbYXiBKVVzwd1J3jLjPuKUwWl1DZ4mYkAYxbtYIaX7kiLXIBz1HelQF
	2K+oi/Nams/hxEs+0Y9wYXRDnksaABGop81WtoOYFGj1cWtKvGHf36ogFihkhNgYk0Frl2
	jeFJjMtmGI1L6ccvgo2c29W4ay/sMSk=
Message-ID: <735c0277-2155-47f5-a650-b4c8a0a2e6fc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770817101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AvbV/7yBLNX8l/Q3y3FXi6sUQ6jYM1ujaQvV+NINbwk=;
	b=KTkCq28TEAtcHJtPGFZ/oKU8vD4gE8s1v/eM0FDHslaVRDzQDOvgbM71iCr6Pzgy+Spxsz
	evXRXBoMAsjI/Ec6zEqMkgSSphZQpvv9wrKwI5q/izSGw5wgkZUgK6soksEZU9HWq9rx3W
	FPXHMoVaAFe+ylRDS4SuNauNPCVGj+I=
Date: Wed, 11 Feb 2026 13:38:17 +0000
MIME-Version: 1.0
Subject: Re: [RFC 1/2] mm: thp: allocate PTE page tables lazily at split time
Content-Language: en-GB
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com,
 willy@infradead.org, linux-mm@kvack.org
Cc: fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
References: <20260211125507.4175026-1-usama.arif@linux.dev>
 <20260211125507.4175026-2-usama.arif@linux.dev>
 <13ab56cb-7fdb-4ee4-9170-f9f4fa4b6e37@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <13ab56cb-7fdb-4ee4-9170-f9f4fa4b6e37@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CA41B20010
X-Stat-Signature: qdsbadf16711w98kzcw6oqwy7yx1bbo9
X-HE-Tag: 1770817103-204941
X-HE-Meta: U2FsdGVkX1+w5FXThtffeG0wITeQfoycJS0psuez1SA1iJGVMxl9L1B+S5jp8486zKhmGrrWlsiJPgz7zz95VvTaNOKepoFgqNnZmPWw7aAhU9dKjxH2cJ9zo6iSIxal3D0FUqEdX1f+s7QE+Xgbu+55T0D5HaAna0nlFGH5IWVjOo7CbSI2cIAAvT2CHF5to+8gO/J/pto8TEtDSXbCVq/f0EfMOzpawDh4A1nfCSzYSm6CMNhVgHtfmWSU6AMSosQgLNbBAQW7ylyxx6RBp801EVbKgF8BZsJN4MIxrOj7lDdyziIB4Z9mzDYj7Mlv5wZMeYzwDKAtHnXEmzQUePtaQHvNe0pOOtHniYgGGVzpG1qyUc4kPu+Q5uS1AoWIWO0UGTGmAicvyJUGkdcS+s3qXrRk1rW1HX4QtsXqHckAn+6V5BmOBIIcZUPo+b82lmttiwdnT2CqKFXvIFWtOJeeMcsRt/d8FNjqAAi843RZjJOBj0l6AsJ7eGcxQ0DlV2S+6nbIUZ1SbEqS8bYfWZi4b940Q4osYhBVzYM+fLNI5DTVvSBeh0x4Q+Xh8v0VdXpMJxa3VS9xaXNkowC4RmhghTKSAUPOGRl9DaWB4g6N2NgIowj8T71EQ0J0vAd06uaNL3Ld18CCC2cY4B8RniuNUt4cbqfwYj1MrBt4TLYx19kozpLIpupmdfgzCdt2pnWsw/89ec1GKxedMDTbp8zfKlurqspSMxNz3nNXZxucfIgvMznjZesQcDuFjPQyzwlHFn/Md1Gexn/aHdBL66odYVH9TPOn/1UIC7Z1Xo5RW21E8NKUjFm/IkYRS4BVJ46ThN+tWGMZ+ow3AeOftxs/oN1Rfl/D7lxb8mRHrqMcOJ/PgD2vnkdGZDOllCfqhPsPo8N60D5YUtYlLEnd6I60uKRPN1+K+4L/fvhZY2e24F0FJvzKYXuP8FEh+QZWdaq4sn4ZYkkLeoOX4k+
 BVUaiaUL
 yx4+LnR8U0mpqxIcaXzMdDVLP/y0KIORlS19fDTqH9P3y9skIn/j5i/1HADyGldm5fCVqGb6/XheNxQJwJN9djeA79t5lKR5liDQ+2w40sJJnSxWwToZ/4cbSjrf4W11lIQAQKSqHXXwPYBcSRuVKDFzIqoDdLQKwR+lLhY6wJYVdnOY0hGHoiZwLEYgl2o7l5Rhbnk5iGdP7J979toPp4b4/YwRjJykrv2uu6TcJhCMZtxA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/02/2026 13:25, David Hildenbrand (Arm) wrote:
> CCing ppc folks
> 
> On 2/11/26 13:49, Usama Arif wrote:
>> When the kernel creates a PMD-level THP mapping for anonymous pages,
>> it pre-allocates a PTE page table and deposits it via
>> pgtable_trans_huge_deposit(). This deposited table is withdrawn during
>> PMD split or zap. The rationale was that split must not fail—if the
>> kernel decides to split a THP, it needs a PTE table to populate.
>>
>> However, every anon THP wastes 4KB (one page table page) that sits
>> unused in the deposit list for the lifetime of the mapping. On systems
>> with many THPs, this adds up to significant memory waste. The original
>> rationale is also not an issue. It is ok for split to fail, and if the
>> kernel can't find an order 0 allocation for split, there are much bigger
>> problems. On large servers where you can easily have 100s of GBs of THPs,
>> the memory usage for these tables is 200M per 100G. This memory could be
>> used for any other usecase, which include allocating the pagetables
>> required during split.
>>
>> This patch removes the pre-deposit for anonymous pages on architectures
>> where arch_needs_pgtable_deposit() returns false (every arch apart from
>> powerpc, and only when radix hash tables are not enabled) and allocates
>> the PTE table lazily—only when a split actually occurs. The split path
>> is modified to accept a caller-provided page table.
>>
>> PowerPC exception:
>>
>> It would have been great if we can completely remove the pagetable
>> deposit code and this commit would mostly have been a code cleanup patch,
>> unfortunately PowerPC has hash MMU, it stores hash slot information in
>> the deposited page table and pre-deposit is necessary. All deposit/
>> withdraw paths are guarded by arch_needs_pgtable_deposit(), so PowerPC
>> behavior is unchanged with this patch. On a better note,
>> arch_needs_pgtable_deposit will always evaluate to false at compile time
>> on non PowerPC architectures and the pre-deposit code will not be
>> compiled in.
> 
> Is there a way to remove this? It's always been a confusing hack, now it's unpleasant to have around :)


I spent some time researching this (I havent worked with PowerPC before)
as I really wanted to get rid of all the pre-deposit code. I cant really see a
way without removing PMD THP support. I was going to CC the PowerPC maintainers
but I see that you already did!

> 
> In particular, seeing that radix__pgtable_trans_huge_deposit() just 1:1 copied generic pgtable_trans_huge_deposit() hurts my belly.
> 
> 
> IIUC, hash is mostly used on legacy power systems, radix on newer ones.
> 

Yes that is what I found as well.

> So one obvious solution: remove PMD THP support for hash MMUs along with all this hacky deposit code.
> 

I would be happy with that!

> 
> the "vma_is_anonymous(vma) && !arch_needs_pgtable_deposit()" and similar checks need to be wrapped in a reasonable helper and likely this all needs to get cleaned up further.

Ack. The code will definitely look a lot lot cleaner and wont have much of this if we decide to remove
PMD THP support for hash MMU.

> 
> The implementation if the generic pgtable_trans_huge_deposit and the radix handlers etc must be removed. If any code would trigger them it would be a bug.
> 
> If we have to keep this around, pgtable_trans_huge_deposit() should likely get renamed to arch_pgtable_trans_huge_deposit() etc, as there will not be generic support for it.
> 

Ack.

