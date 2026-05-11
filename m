Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40E78CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991C36B0095; Mon, 11 May 2026 08:48:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9689C6B0099; Mon, 11 May 2026 08:48:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F0A6B00A1; Mon, 11 May 2026 08:48:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7561B6B0095
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:48:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 20D471A06F3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:48:05 +0000 (UTC)
X-FDA: 84755116530.01.81CE7F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 29FB6A000C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:48:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RxuFM0wY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778503683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11DgLMD0oDNTxJ1Hljb5gK1atwURFC6axw9MUN9b/Mc=;
	b=NwAfUEKN3zHhemleh1cFW5RXG4MWWknaG6esTvyiJoa1EMWQPUZoXVvwONRdcAPBWmDfRh
	Sg4kNBxg8BbBWPRqhrr96dO5wBm2X7CPoq/CBo6DH4pZO0wdP5gxR/GoZpaEOMNO0YlIS6
	3TisDFkZLQWwGT7DXTVZSOWg0+JBrd4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778503683; a=rsa-sha256;
	cv=none;
	b=H5orODs3VmW6E7r1PBxGEXlQ9B0nSS/d7YfGjjfAfhmS/6YfWHLsW4puBgNdIaZVKFZNEp
	F1nuZjdu+G0VIr/IYEIimej4esA8ZhfKXk3ho8uIiMjBYM40voQdhX/2T1lr2ZZ7LnlRSY
	eWILbhOvSaS6Nu5dE4b7c5EV+kNcjNc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RxuFM0wY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D98C740119;
	Mon, 11 May 2026 12:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E77C2BD00;
	Mon, 11 May 2026 12:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778503681;
	bh=xjCTB5ceIJr0tNHKjbbLsapZ9izKDwKmO+QdBIUbBGU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RxuFM0wY/cj9ZVZuXnbwdE9wkU5NWx4mgNDUShlyhw7Hi88NJ2VqAvCJ35KJ2VZbV
	 7LRIE1WsFcrJWamJPHk88WOXG4u/v0atDLLKcOiH6RjbuMwBCeZ+Nm5xj5wjJVZ7s6
	 fwX/ePZnBS1XJdbYm9AVh3Nl4eSGJf4oh/jNlz5DZhf0kD7y9fYTD++Z255qRx91Gh
	 CNTdcXX4LmJyYFKS9eI4MjA/Ad2brg1ECzBfUuOL8ijk1gxIaPSBjemON+rwRxON1D
	 P2GCAMJCSWqSzEdvbkA5ISvJwuBA7UZ7MzQSPCRC2kwi7w3Oe6NjKkU+YVKyyV+ch2
	 l64AgbRKkRvTA==
Message-ID: <c16350fa-2f74-4517-8d97-4772def97b78@kernel.org>
Date: Mon, 11 May 2026 14:47:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: "alloc_tag was not set" when running mm/ksft_hmm.sh
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, jgg@ziepe.ca, leon@kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, Alistair Popple <apopple@nvidia.com>
References: <be9a8bae-9223-4966-bba9-2cbe39c8f4de@linux.dev>
 <10e4565a-b416-45d9-a8b0-cd32532b2630@kernel.org>
 <2b46241c-158b-c9dd-9b81-a98366b2c9fb@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2b46241c-158b-c9dd-9b81-a98366b2c9fb@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 29FB6A000C
X-Stat-Signature: 9jaw5z8h1b4rde8t6ooayuqyf9cjfh6s
X-Rspam-User: 
X-HE-Tag: 1778503682-72673
X-HE-Meta: U2FsdGVkX19BJYMTH9dqLJqdxf6tCFyQVARIYj6L4298spHpBLXosjwgKvIcn3Ek6pW6oeEbdI2cDdlZi1alAe7gW8IfAftLgyB4Z3eLfwNeD5kmOUBvP+AEFN2WM9nOgGRCkl0UynPyypDzptmiV6jX0HpCEZLVMr7fJMvrQ0/pJxP/mzvOXYv8pRMFbLfA/t6iQhVL3dgSKhT+yiM2xLwAYAopLDYpopvtm5mYcYI5mWTWyE+ef09wVsSA5lfIERC2nhUmZ+amvZmbXfxMiBeR5Bcy3Jn26A2AgsJ/LV2yHPa1qVKlxzUJVKGduy2liC4/hIVORGOw8YVD+wSrukXRWKsni+sKmFYNjwEwlj5TEb2oRG3osolxDQ5KEIzX0vJRiZq76MuuJQgbhWeEjMRiRzKRyOjRKucpXOy8DltyjotoMnnvk01o6uR2gt1/NkgJWFfiEyB39+vnSvAA4hPXE50NF/PcYJFF46mHxrcAD/dFZ1MxkYb6WhSWlCo1AgaBJkGMi4lC9787oVrF6fPaa6Qw2mRwv7gpt3NO7W2nRd8gGrzWnriA/Ycb2s/XjQJQrjSiUzjH39VQIKt4jUHzJrzbNWm0WfLgHWTgpLkEcGAdr54IoCx8eVY5AXkafu2EjOIALoxZ7ip8QTbTMs8Sb1jKvdXDcLdVAg6nSnBxQaUYKsgtPjWhkcafWS3lT08N+5CfA1GHdCvfvyZNLNiH7Du/sJHMQjlnHHkgw6h3/pPC5akd/advAxLqr3iUTGrbigU/W/V+ZdxdEi7UhpgRNjN5WMDmqmypqFpSmkwmSVTRe9a7HYyjhgqtVgMjaf9a2qylyCUYtj/kxmwcyW3C6YdRcNaEn7buMnMF7tt+T9+feH8OAJceU4mjKpBomWRJI2ZAIWUgBouUX4kv6DVRRCICNcXAvD60NIvxCUK+rxC11L2X/orep3limqaN1j2TSTsIb8PdYpyGfna
 1BRtYuPA
 wrWR3M8pSNZDdtQKJxjO1dY3qWeBsxzXGKneWXBcGf7qyxo75pus0lkSMGDvsd2VYEtAnSIU2fCJ5SBElbWkx0ZBJIrutAQcprLwc6/75olFWeVEsCp1cHFzlcPK2AqCmSdbPCDfjmfvy4ixUrU/LZZJfPwXTpG+xu+CWWIDXvEliuTQSUus8NBAo+9cQYRD2gwS1qkD0DZB4xSNmeQteJGBsEYaCz+gby6WwCOYoEPeeHXTwEJGnMTmH8P1K5mnehNX1CITg/9VrpKC5f9M2NZjyZt3ZtdlsvqoA1RTefCKrf94hNcQxEqisk66dQcS3n+N6843Kw0vX/ZenROwKRLy9tMnhZborwEIjGKlqmu0vdFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 14:19, Zenghui Yu wrote:
> On 2026/5/8 19:53, David Hildenbrand (Arm) wrote:
>> On 5/6/26 17:42, Zenghui Yu wrote:
>>> Hi all,
>>>
>>> Running mm/ksft_hmm.sh triggers the following splat:
>>>
>>>  ------------[ cut here ]------------
>>>  alloc_tag was not set
>>>  WARNING: ./include/linux/alloc_tag.h:164 at ___free_pages+0x2a0/0x2d0,
>>> CPU#5: hmm-tests/2020
>>>  Modules linked in: test_hmm rfkill drm backlight fuse
>>>  CPU: 5 UID: 0 PID: 2020 Comm: hmm-tests Kdump: loaded Not tainted
>>> 7.1.0-rc2-00099-gadc1e5c6203c-dirty #285 PREEMPT
>>>  Hardware name: QEMU QEMU Virtual Machine, BIOS
>>> edk2-stable202408-prebuilt.qemu.org 08/13/2024
>>>  pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
>>>  pc : ___free_pages+0x2a0/0x2d0
>>>  lr : ___free_pages+0x2a0/0x2d0
>>>  sp : ffff80008345b530
>>>  x29: ffff80008345b530 x28: ffff80008345b700 x27: ffffffffbfff8040
>>>  x26: ffff0000c41cb360 x25: ffff0000c0c64008 x24: ffff800081aae400
>>>  x23: 05ffff0000000200 x22: 0000000000000000 x21: 0000000000000000
>>>  x20: fffffdffc5f20040 x19: 0000000000000000 x18: fffffffffffe7c78
>>>  x17: 0000000000000000 x16: 0000000000000000 x15: fffffffffffe7c98
>>>  x14: 00000000000001d1 x13: ffff8000818f3d58 x12: 0000000000000573
>>>  x11: fffffffffffe7c98 x10: ffff80008194bd58 x9 : 3ffffffffffff000
>>>  x8 : ffff8000818f3d58 x7 : ffff80008194bd58 x6 : 0000000000000000
>>>  x5 : ffff0001fedb1088 x4 : 0000000000000001 x3 : 0000000000000000
>>>  x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000c7f58000
>>>  Call trace:
>>>   ___free_pages+0x2a0/0x2d0 (P)
>>>   __free_pages+0x14/0x20
>>>   dmirror_devmem_free+0x13c/0x158 [test_hmm]
>>>   free_zone_device_folio+0x144/0x1e4
>>>   __folio_put+0x124/0x130
>>>   free_folio_and_swap_cache+0xa8/0xcc
>>>   __folio_split+0x664/0x7fc
>>>   split_folio_to_list+0x50/0x5c
>>>   migrate_vma_split_folio+0x13c/0x25c
>>>   migrate_vma_collect_pmd+0xed4/0xf68
>>>   walk_pgd_range+0x598/0x9a0
>>>   __walk_page_range+0x90/0x1a0
>>>   walk_page_range_mm_unsafe+0x194/0x20c
>>>   walk_page_range+0x20/0x2c
>>>   migrate_vma_setup+0x18c/0x224
>>>   dmirror_devmem_fault+0x188/0x2b8 [test_hmm]
>>>   do_swap_page+0x1458/0x185c
>>>   __handle_mm_fault+0x85c/0x1ba0
>>>   handle_mm_fault+0xb0/0x290
>>>   do_page_fault+0x1f8/0x6f8
>>>   do_translation_fault+0x60/0x6c
>>>   do_mem_abort+0x44/0x94
>>>   el0_da+0x30/0xdc
>>>   el0t_64_sync_handler+0xd0/0xe4
>>>   el0t_64_sync+0x198/0x19c
>>>  ---[ end trace 0000000000000000 ]---
>>>  lib/test_hmm.c:705 module test_hmm func:dmirror_devmem_alloc_page has
>>> 16744448 allocated at module unload
>>>
>>>
>>> It was tested on kernel built with arm64's virt.config and
>>>
>>> +CONFIG_ZONE_DEVICE=y
>>> +CONFIG_DEVICE_PRIVATE=y
>>> +CONFIG_TEST_HMM=m
>>> +CONFIG_MEM_ALLOC_PROFILING=y
>>> +CONFIG_MEM_ALLOC_PROFILING_DEBUG=y
>>
>> I assume there is a weird interaction between alloc tags and simulated
>> ZONE_DEVICE memory in test_hmm.c
> 
> FYI this can be reproduced by running the migrate_partial_unmap_fault
> test case.
> 
> TEST_F(hmm, migrate_partial_unmap_fault)
> {
> 	buffer->mirror = malloc(TWOMEG);
> 	buffer->ptr = map;	// points to a THP
> 
> 	/* Initialize buffer in system memory. */
> 	for (i = 0, ptr = buffer->ptr; i < TWOMEG / sizeof(*ptr); ++i)
> 		ptr[i] = i;
> 
> 	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
> 
> 	munmap(buffer->ptr, ONEMEG);
> 
> 	/* Fault pages back to system memory and check them. */
> 	for (i = 0, ptr = buffer->ptr; i < TWOMEG / sizeof(*ptr); ++i)
> 		if (i * sizeof(int) < 0 ||
> 		    i * sizeof(int) >= ONEMEG)
> 			ASSERT_EQ(ptr[i], i);	// triggers a fault ->
> 
> 
> dmirror_devmem_fault()
> 	migrate_vma_setup()
> 		migrate_vma_collect_pmd()
> 			// !pte_present(pte) && folio_test_large(folio)
> 			migrate_vma_split_folio()
> 				split_folio()
> 					[...]
> 
> __folio_split() {
> 	unmap_folio();
> 
> 	__folio_freeze_and_split_unmapped() {
> 		__split_unmapped_folio();
> 
> 		for (...) {
> 			zone_device_private_split_cb(.., new_folio);
> 			// -> dmirror_devmem_folio_split() which doesn't
> 			// set alloc tag for the backing system memory
> 			// page being split, i.e., rpage_tail
> 		}
> 
> 		zone_device_private_split_cb(.., NULL);
> 	}
> 
> 	remap_page();
> 
> 	for (...)
> 		free_folio_and_swap_cache(new_folio);
> 		// -> dmirror_devmem_free()/__free_page() which warns if
> 		// the page being freed doesn't have alloc tag set, in
> 		// alloc_tag_sub_check().
> }
> 
> The WARN disappears with the following diff. But I'm not sure if I've
> missed more important points (which is likely to happen ;-) ).
> 
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index ed1bdcf1f8ab..eefa2a739917 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -191,6 +191,7 @@ void pgalloc_tag_split(struct folio *folio, int
> old_order, int new_order)
>  		}
>  	}
>  }
> +EXPORT_SYMBOL(pgalloc_tag_split);
> 
>  void pgalloc_tag_swap(struct folio *new, struct folio *old)
>  {
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index 213504915737..3bec51828916 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -1713,6 +1713,7 @@ static void dmirror_devmem_folio_split(struct
> folio *head, struct folio *tail)
>  	rfolio = page_folio(rpage);
> 
>  	if (tail == NULL) {
> +		pgalloc_tag_split(rfolio, folio_order(rfolio), 0);
>  		folio_reset_order(rfolio);
>  		rfolio->mapping = NULL;
>  		folio_set_count(rfolio, 1);
> 
> Thanks,
> Zenghui


zone_device_private_split_cb(), that ends up calling ->folio_split().

We do have a call to pgalloc_tag_split() in __split_unmapped_folio(), invoked in
__folio_freeze_and_split_unmapped() before calling
zone_device_private_split_cb() when iterating the folios.

The zone_device_private_split_cb(folio, NULL); is then called on the first folio
after looping over the other (new) folios.

I would assume that __folio_freeze_and_split_unmapped() would already do the
right thing?

Maybe the issue is the hard-coded folio_reset_order() in
dmirror_devmem_folio_split(), where we seem to assume that we split to an
order-0 folio?

-- 
Cheers,

David

