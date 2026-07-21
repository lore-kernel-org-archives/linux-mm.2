Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6814C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 15:04:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8236B00A9; Tue, 21 Jul 2026 11:04:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 989166B00AA; Tue, 21 Jul 2026 11:04:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853C26B00AB; Tue, 21 Jul 2026 11:04:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 533E56B00A9
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:04:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D581D1201CF
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:04:50 +0000 (UTC)
X-FDA: 85013105940.04.B9B449C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id A477B40011
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:04:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A7zv8FYY;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784646288;
	b=06V3UdaaLWk95gLbIebdTZRW5IeVPX28cM6QNx0x3FqXRxLR6gASwX7GsvmRpIHYs5UHmf
	VfHEAcLMuuO7M5RKeg0t7UAeH1Sl30Jmlag6MWu6ZhU5jbOok5ld1HFexyWXX1NBzDkiJ0
	Daz9lB5G+XuIGcW1KSL6yrgIO/jivRI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A7zv8FYY;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784646288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KvFlBOSAAN25BmqEyf7MAcVM6Drefi3m8EoY83MJzfk=;
	b=J+h5LIB0V0KoORjYP8NKA7hjHOywfxjAKu23lIcWk4vCukEK8cqUoXdneomTLblc0MIo2h
	OqCkWsTySnN+gu5s0PN0m+GPWMzVsmbs35tCPncQ3Qp5TACJfQDBeAdqth5/RBj3WMDfBl
	hDA0B9+SjyeiIO6/rVFpF/9DO0aviLM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CAC91414B7;
	Tue, 21 Jul 2026 15:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253511F000E9;
	Tue, 21 Jul 2026 15:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784646287;
	bh=KvFlBOSAAN25BmqEyf7MAcVM6Drefi3m8EoY83MJzfk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=A7zv8FYYS3BagE62jjvD73Uo/224uS+6js4DUo1TwI40rxRLe9Jy+r9SjEyOaqeU5
	 rrJBY4oVg3W901xWvxUgvAaN9pRWVrH2l4W2I/qQ5dqtTJ7UGaFX2JCrkU4eOJlqcD
	 jxL2cK2LvZK45Y/FKSigYw2lIsYEm8O2UBS6UV1NJX6apyOK6foKBUIuE2snq0pRW2
	 8XXBKWZtHyGR2+qVvCUv9YcmaWJjt6iRu03x4OeaKWzLsttCkNZ0wQAKhXTJ1cXNRV
	 6VmOsoQBDpTz9vZqaykrZj3UP9etcPWzq5QO5kU0Ljog+5Hjy2ATYcv4TUr/wX9mdf
	 dN7NNkgocFuig==
Message-ID: <0bab816d-5de9-4814-b97d-11e89322c413@kernel.org>
Date: Tue, 21 Jul 2026 17:04:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/22] mm: introduce MMF_KERNEL flag and set it for
 init_mm
To: Kevin Brodsky <kevin.brodsky@arm.com>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Dave Hansen <dave.hansen@intel.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>,
 x86@kernel.org, tboot-devel@lists.sourceforge.net,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
 <20260714-remove_pgtable_cdtor-v1-3-44be8a7685d7@arm.com>
 <71045fa8-89fe-4a0b-a05b-67e19ce89834@intel.com> <alZOs30ziqa7l_Lq@lucifer>
 <5ce00109-c0ea-43f0-881d-f58a0fda8dcb@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <5ce00109-c0ea-43f0-881d-f58a0fda8dcb@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qis1sbjiy9dzncuuuqj5jeqiryf9jxiw
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A477B40011
X-Rspam-User: 
X-HE-Tag: 1784646288-387142
X-HE-Meta: U2FsdGVkX18RgMa2Mv+0j+hFe2bwnqzLxyOw0XkAok6pzS72oNDsBNewGUXSKaizFQ0x5pFJ4cdeu44Tu/q6fdny4eyuu5MTXIyFzd1E4bk8Acmytm6wNmvNhymYbo2jTEbQssDKaJCjDpycXa8tqnuT0FzXzGoUrLp9M+V359XdmmGYajMDlkqxTbnF7+vDVvZ23ARbvCBwEE/LAWjdrlW60qEhHYqdJj2YflmoixiXdiSainbwi1FeBVK4TlmUetNBCM8cH8a9W645icCrV43nSB6tyPqWyHLwsnNsEuCNt+E17JZb4DoqbdN0ATR4UgvGwtqwTPHq2WcRcc7SO4kWgIkZ+dc02DcCXz2+7px8n30ybyLJn3t85LaOjSzEYUqmyjPJHxcmaLUKqbu8ixRPkMMfGL20FLqcgnVWCCI22ITJf61WM+09sMdyQJid101MYhJ0WOqwWKt8uqXWaXsXhkXnCTjzlbmEYxT0/FeYZyVJgZEtt6bTu+BrOIpHEd3JN9ue5h+mRyimgighot9T/w67hdRVKu7fHfAKqR5+PDPi+NVFJHYRvmLTZQ5kv7Vge/5NOAh8vcuiLbv1/0Oj0HbOMR999bAg0SWFSansSTxPAHY5ZZvK7Q8ZyxaLgs0+X6MAuwS4LYIY+rmQjKlHl75UNOQrpqCHiJKNcqiSL/3ye5V7ZL0lct5GHTMbsY/j3mUMdBSz5vsvz1tN9BcL5nVfugm1a9FqdL1BScQ/s7X4TxdGIsyL3K+R7DXtKhtTPk3mUK1TK/QN3SnAMAc9mxzyWXlk04Z/4a31RT2j2CZdz0C8/rICaq21CFmRZ1oGykiJ+Gljo1aATfckZUrPhz8qrugJehA0/n4W5clnRPYPt58xzK1/ipKnjxGOWBKOcCFPjCybF4hMif79V0zVnYD3Lw8oXlDozo178JXWJjC4F8F4aYGTeiSxlNEkkR1LyT+ZpgaOxu4TC9m
 vK+k0dSV
 U/PC21O5yruTjjmnUJQBOwRdhAYhiK3MzFG2wRagS9lbzYQZ4uF66UQZj3wzldrer6gvJos26P52VAIVserzNLqY7b/Ht8hBJhxEP1GIMM98kV09/eTsKgOJ0vd2CRlxtou/477oQKqVIndw/FwmcLH1JiMVdcjTw4ZW8OFkjhV/5wq3buHehZk/KOG3MKhdpMdz3xAG622lE/LESO4COME7G+Z9LmC+zGs31sYzgy3lkp7umDtqwlu2ckj1KUW7rORAE+8raYBVqD7olwBJAwjLLQkvZBj8vrrUUX2kY2TlEVTy7goWYej+wHPeQr1Lv4j+648qB3sAvZbx6N8WGsgAf94a0e5kqu/NXHATqt4xeHl1pwFxcga4doz3YX1qeFwix
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/16/26 11:33, Kevin Brodsky wrote:
> On 14/07/2026 17:04, Lorenzo Stoakes (ARM) wrote:
>> On Tue, Jul 14, 2026 at 07:47:43AM -0700, Dave Hansen wrote:
>>> Could we give this some nice comments explaining what a kernel mm is,
>>> please? Part of the problem with the init_mm checks is that they're
>>> magic and it's not always clear what's special about init_mm.
> 
> Agreed, we need to define what this property means exactly, and your
> comments on patch 14 show that extending it to efi_mm isn't necessarily
> as benign as it appeared to me at first.
> 
> My motivation really is about how page tables are handled (in particular
> whether ptlocks are used), so as you suggested on patch 19 maybe this
> flag should be narrower in scope, and the naming should reflect it.
> Possibly MMF_KERNEL_PGTABLES? That's at least one thing that should be
> true of all of init_mm, efi_mm and tboot_mm: their page tables use
> kernel permissions, not user, and should follow the same rules including
> not using ptlocks.
> 
>>> Maybe start with this list?
>>>
>>> 1. There's only one of them.
>>> 2. All kernel threads share it. tsk->mm is the same for all kernel
>>>    threads.
>>> 3. It holds the reference copy of the kernel page tables
>>> 4. Userspace can't be entered when it is the current mm
>>> 5. It has different TLB flushing rules than userspace mms
>>>
>>> I _think_ those are universal across all architectures.
>> Well point 1 isn't true of efimm or tboot_mm so we possibly need a better
>> name :)
>>
>> "Special" is overloaded too much already. I quite like "eternal" so:
>>
>> 	static inline bool mm_is_eternal(const struct mm_struct *mm)
>> 	{
>> 		return mm && mm_flags_test(MMF_ETERNAL, mm);
>> 	}
> 
> Cheeky but why not! I do wonder whether this conveys the right idea
> though. The main point of this flag is that page tables are
> allocated/initialised/locked differently; in principle you could have a
> temporary non-user mm.

I mean, we talk about MMs that are not used for actual user space processes?

IOW, the following:

arch/x86/kernel/tboot.c:static struct mm_struct tboot_mm = {
drivers/firmware/efi/efi.c:struct mm_struct efi_mm = {
drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:static struct mm_struct sva_mm = {
mm/init-mm.c:struct mm_struct init_mm = {


So "user" vs. "kernel" is quite intuitive. Sure, there can be multiple
"kernel" ones, but each with a distinct purpose (IOW, we don't have multiple init_mm MMs).

-- 
Cheers,

David

