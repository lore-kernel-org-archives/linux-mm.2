Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDE29C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 14:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF4C56B007B; Tue, 28 Jul 2026 10:37:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA4F16B0096; Tue, 28 Jul 2026 10:37:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93766B0098; Tue, 28 Jul 2026 10:37:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 905AC6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:37:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 231BA1C0B87
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:37:33 +0000 (UTC)
X-FDA: 85038438786.08.BE6E70E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6BFDB100006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:37:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nc26FOHP;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785249451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZDkk7PDtexhsBzVT9GWHhsxn7eilb1XwsTmiTnabsNY=;
	b=kI5bUQy9/x5cglvNg8hrqUGpyk8ppUHrWSmw/u+9BlAajQyw0PsiriXn8MIBv5CtumdWMD
	QIP+INZUUrsMGYDwL6IdyRJpowaEAj36M0ETUuho1FFiw1Hoo4ehDMW7LGxYhlKQP4XXVA
	bCatF5Uep45SACoEldnDXG/maIpb5ys=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nc26FOHP;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785249451;
	b=zk4oUyX/q8lvtUkjzll2Xm2AQ47kPqjYweEcTY3JdeYqF+WJBw/rvkGKrUXB/F+sKQYNej
	tCFaWFC47GwGzxX3t+o/XtRRds2RG0raUAHEzODlb78qDmxoYEtZVillbNRWRtsvtlvki2
	MIMaS/Pwwyjhkv7RchSMvzN2FuJHzPo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C95E4034E;
	Tue, 28 Jul 2026 14:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAA61F000E9;
	Tue, 28 Jul 2026 14:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785249450;
	bh=ZDkk7PDtexhsBzVT9GWHhsxn7eilb1XwsTmiTnabsNY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=nc26FOHPHYa9+8isLzyk0zxQfzaTb0OA2pPhKpbyYczQVTRy6FuWreWujR95MzVdg
	 8V5iMwIzJWE8pVxklYHkEBbw9SMYalKGI8aWBEmO/813/x/QKcOZVsf4OKFcMviYu6
	 F7BHRI2q+YBxtJsLz7B6DfQqqYINP84nYofCR1Y4mPeRUb4MatyytBNFpT8K28Ishv
	 OFcq8cMmk5AHLuJag0dHBnurSCJ0ACBEYb6XJACN3TB2nSwVJvVvabEMSgOPe4dU0n
	 HZsS3IgfHeKSx4blTi7u63QzixOnTAxG9B2N2TNrRS67Fu/3ZIsLCN8hszAm3my6x4
	 2QFGKWdOJKihQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,  Jork
 Loeser <jloeser@linux.microsoft.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/21] kho: make boot time huge page allocation work
 nicely with KHO
In-Reply-To: <amiwLSEi8cczamP1@kernel.org> (Mike Rapoport's message of "Tue,
	28 Jul 2026 16:35:41 +0300")
References: <20260725172133.4018491-1-pratyush@kernel.org>
	<amiwLSEi8cczamP1@kernel.org>
Date: Tue, 28 Jul 2026 16:37:26 +0200
Message-ID: <2vxzecgn89jt.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BFDB100006
X-Rspamd-Server: rspam01
X-Stat-Signature: aot5izzxfj3snbhyyb8t6dp1agrzydkz
X-HE-Tag: 1785249451-288324
X-HE-Meta: U2FsdGVkX1/KqmD8JlEVcreJpAToVE94rdVryMeiuvFJat/HO8/qX80RsY6NJN49jcsHOnzcXUokoWXpVhZ9WTkEhiN58LWg8mMeUxVS7ge9kIHldyVSJwOFzA4Kvo9hZpBQ6zEAvT0ouYsLDRt4emfHcAMQsHP6zqumlircL5thiGc0cuwUwtdw9TdYwZ4VuKMgleycxQgA0A6pYL9Idl2H/6FPpaZL830ea3LVt9SC6jtlZcmBSdlAtPSSQDcjNX/RNQX2pBLl+OJ0ALQRU0W3DsZF+9gcwwSevrjNQ9svk4bdP7Sn3esqh3B+c8Ntht/RS0pHa1Sr83G3ex3Vg8c08hN85ZV7hln+JXzCJ4iwrnPGC2iKKkHCmuG4TINyz5MynAggQ5BuixvAchfQNvpLtCWmMm6FftLSvXG47xOzGK374oeCeYRO4dAJFbQkyCCSnzwErWMhsTt13oQDqZJKCN3iz5VweVi/sD1XIIVGLlFbwf6CoZ8gqEZYJ1Q+co8rdt6+WgvBoMBqCQ/7gaTtLifAMCuIdoseTxkMzFOjUnNvS1+9YsEhT6ddtjVHJSZQFOMsT4r4VueY3DJgDCWQpq6WM+A3RgVETzZy6DiM9LJvY338VXQChzUd7EldUE8X5J3V97NdWXOSIcgxLzurP+t2Y9A2tuX7a845+5P0zDyjWgJt0VIb5sC/vGYx39Xsh+K9xWiJgQ9Vxe0OrHhxEAom7oogwN9lHjLstBYfLrC+2ETNVg2K64/xiZAMVKLHdZsdfVhkp6FCrUIntrVfIiZGPKQi9kuTJRaShHjrkUfcAAWOH8L38SNmLR/mqPBrTQT6L6rhhjsgjJJL2GtqpVpCOPsITZQDrzrEL5KxwhnEN868CfE4+sdHdUOInixY/PHoeOSxnCU4gZn3RMMFMs+dzdeCOTIycYVskgr+5b0A94Xy7q+Yi6PhCmb+tZ6x0tYXbQCga4ll69M
 ZDi3WBvz
 Kbw1HyUhGj640jpq+vofn2W4Nv2tygJ1ouyMjW6rzMySZKs1wkEOWp/pXBI7Q2i7CQl9YiG4T3unQqWsDDzVkgR0/auO0QOEZ+tuUO1oK++dfkQj/A2pFqzx2jGEsrcfBdcdK5FwXI+hxQtPm1TvGnA091Q41rorqybbJWwXlwigHNNIlwShTO49uMqLzUwP/UBWiuxIQb3Z5SaNMeWJFnTi39FSSe0Cx1AXHtETPeUoyS3c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28 2026, Mike Rapoport wrote:

> On Sat, Jul 25, 2026 at 07:21:00PM +0200, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> Hi,
>> 
>> Gigantic huge page allocation is somewhat broken currently with KHO.
>> 
>> First, they break scratch size accounting. Since they are allocated
>> using the memblock alloc APIs, they count towards RSRV_KERN, and this
>> scratch size when using scratch_scale. This means if huge pages take a
>> large enough chunk of system memory scratch size will blow up and fail
>> to allocate.
>> 
>> Second, scratch can not contain preserved memory, and if hugepages are
>> allocated from scratch, they will fail to be preserved with the upcoming
>> hugetlb preservation series [0].
>> 
>> Fix this by introducing the concept of extended scratch areas. They are
>> areas that the kernel discovers on boot by walking the radix tree and
>> finding free memory ranges. See patch 10 for more details.
>> 
>> Muchun Song (1):
>>   mm/mm_init: simplify deferred_free_pages() migratetype init
>> 
>> Pratyush Yadav (Google) (20):
>>   kho: generalize radix tree APIs
>>   kho: make radix max key width more obvious
>>   kho: disallow wide keys in radix tree
>>   kho: return virtual address of mem_map from kho_get_mem_map()
>>   kho: store incoming radix tree in kho_in
>>   kho: move all memory retrieval logic to kho_mem_retrieve()
>>   kho: add a struct for radix callbacks
>>   kho: add callback for table pages
>>   kho: add data argument to radix walk callback
>>   kho: allow early-boot usage of the KHO radix tree
>>   kho: allow destroying KHO radix tree
>>   kho: add kho_radix_init_tree()
>>   kho: expose kho_scratch_overlap() to kexec_handover.h
>>   kho: initialize kho_scratch pointer earlier in boot
>>   kho: initialize preserved memory map radix tree earlier
>>   mm/mm_init: don't rely on memblock to get KHO scratch migratetype
>>   kho: extend scratch
>>   memblock: make HugeTLB bootmem allocation work with KHO
>>   memblock: add memblock_reserved_hugetlb_size()
>>   kho: exclude hugetlb memory from scratch size calculation
>
> I added it to the liveupdate tree.

Thanks!

>
> Please take a look at Sashiko comments, we might need v5 if it has valid
> (not pre-existing) points.

I took a quick look and the only valid points I can see are the ones on
patch 19/21 "memblock: make HugeTLB bootmem allocation work with KHO".

All others are pre-existing problems.

Is it okay if I send a single follow up patch to fix 19/21? Or would you
prefer a full respin?

Also, general thing, but I should go and fix all the pre-existing
problems too at some point. I sent a fix for a really simple one
already, but Sashiko has found other problems too...

-- 
Regards,
Pratyush Yadav

