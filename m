Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0F01C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 08:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB47C6B0088; Thu, 30 Jul 2026 04:06:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8C1B6B008A; Thu, 30 Jul 2026 04:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACA056B008C; Thu, 30 Jul 2026 04:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7F16B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:06:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F55D808D2
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:06:14 +0000 (UTC)
X-FDA: 85044710268.18.772C77B
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf12.hostedemail.com (Postfix) with ESMTP id 98A8340009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:06:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=BBOvar99;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785398771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KujgVCTc1rWCSsOVBTNJAgS0MTdCaoJqux8n84RW75U=;
	b=z/8tO2iZwJEEH8uDddRaIRQ0oyN0gpxjcL29Uhy7cqlXqLEiOFICW3kBtmkaoSGz/JI0mF
	xxeulvHl1369rPY4wrJhXXHloV4ZRZexzQNGqiWLq1Reh0vsvxg+75ONkFNrwz1+jc6yWw
	Xgmq5kVlsFSrHvDe6qLI+jUMp+XHjOQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785398771;
	b=7cxR5KAK0+ZXkfIPKxUgBfH5YDnj0wJEflG4T12cDm6DWZk/itDsiKeoPv2/TJ6uXSZZPy
	HCJ7Cu5QivFB/znLcl1M9LIu9YZZwzokPOZq241CLUFkdR3LEJJ4rOhr9wrAb/X33hb8bT
	E5mJL2wM6y6ILRRJVqRyrRyjSFTJYcU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=BBOvar99;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785398761; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=KujgVCTc1rWCSsOVBTNJAgS0MTdCaoJqux8n84RW75U=;
 b=BBOvar99bWM/TOnChHrUllELNTpzyunIYp5rLVlYhzJXmPK56vsnKfGDiurZesy/ouPYj/
 5vbJkQXEinHwp42UfeWyr8EDrUHI5Gl3PhvPLZIkNCsI+u5wcuyhPth+GfNWriAM/PFJ1W
 WCLQQapXLVlDzc5jH4QqeAoI12xh/ZF0IZql8oKx078Z/kV5NYGZIg7Paf5CZSFk+ECz4q
 J9TkMQCxDMVOpH3FBZrBGkmP7Dv0EUD7q8twYMXA4BnRpkSWTi3QONpghHCS2KubVplhBy
 Z22T2bDpTyi6nRk2yuCGhEGkUIim+KJxfSmmhr/RsIWns7icqR8VZp0Rk6qUKQ==
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260727123429.5673-1-lizhe.67@bytedance.com> <20260727123429.5673-8-lizhe.67@bytedance.com> <20260729234842.GFamqRWva8h7X59ccN@fat_crate.local>
Subject: Re: [PATCH v8 7/9] x86/string: extend memcpy_flushcache() fixed-size fastpaths
X-Lms-Return-Path: <lba+26a6b05e7+66bb55+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <muchun.song@linux.dev>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <x86@kernel.org>
Date: Thu, 30 Jul 2026 16:05:36 +0800
Message-Id: <0126ccfc-fe8f-4dc6-87e0-fc9ba5d116b2@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <20260729234842.GFamqRWva8h7X59ccN@fat_crate.local>
To: "Borislav Petkov" <bp@alien8.de>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 98A8340009
X-Stat-Signature: 36m3j7b74yb6rfx1f1y5bdwdnzt5azx7
X-Rspam-User: 
X-HE-Tag: 1785398770-636352
X-HE-Meta: U2FsdGVkX1+uGMy6AfPup5wp6OKauFuBKByV5ex1CUKdNHHYX1coE3bln3CvyWrJnIufrcXm0Rn7kzy2cxI3cfI9pxwJmmHMR7ir33bm809LvuY5S5pJJLwJ1a9vkeaypjjQPEji0jSK/z6aYDQT9hsNwnsXe8tH57cD1zkC+8/M7GEwTYs3VhAkOnEg2fWU01+pJ1uR1HJws5Bo+bb6fd9h+dniP4Z8zTsOQxo99vJxT9i7y+/UupW7GoaygFdNT7vHmNwLH2RWqGah2wROQF/Ac2eKAuaEqmfSNZZ1p+OkeWee8xSxn2k2LI6LyCsYyczp1MFTBsb8BBhYyTgzBq82zN7uCxyP0KeNakma6st7MSU6SOkDgCNvAKbdrLsDFiowSHQ1Cg5DUSltlbKyAy4nEIeW4KP77mD3ySyER+6Ev4eOhey3RwEYqwfB0lV/Qyf0C8Oe4NOLXG6Yyfk31broSdTBTEij/ud9GDiJQMmWm10LvwFPMYZKxlhjgEQvh6iQa6yhu1/wBk8gSdDgrRISDgmsAhVp+j6fYwbxSpfpQk7171j/Gc+nUoh/87qUUFzNEoMMuWzvH9kyL3xzxELZmHEdjtueqVxaIQ7yq9Q+bcmfA2nkTZUi1shdV5l8lDcadW5K3XhLsYCEfKrWKlaOj4J19riIrIiCh/4ziBzJxA+fNWZieNdbevAVOXqxH0A9AppeikVTdj5uKs4zp5eyXuv2gFcpfQllIvvnlAA1KjToI7LTYTWuZKPd/2DtqIJXH34//uw3xxSYKOQjHO288ODaHRR5V/7OXOQ31A4u2hlYJNlU1CDCwDAtZu0G5u8939SvQwsCLLpo7gAY6X/vohkXB9wCsBGZa/g6jXJkl0bY/DqWAAWa1zp2m8jkqsUuSR8Vo89VIQR5SSzDXAeY61VE42bx0B4xjb7bgvavhliUFnJrAap2i1a/D031lKQowJacm0R0OUceiCX
 a7q/eRzk
 BJ9JdxkkBOAIpGD32haQRKQjWUdaZcHXDr5lzGSPYBpKHvVPp9eh19Tye6TDBI7qEzYylIJoujYhz7ln/aqFTxfLyqcevb/xuX25wyEY612BPDWlsf5UERDfMM2rYfv3NPh9GoYaWIUTSYE6x8hbKsb/gzgn67Ij4F+gd84yd8txcCIEYkWacIRbEGKh88namLAtYydkpfkzum1vLopCAfoLucaHWqFDrRyPW07rWP6bQbdOclQIt81htB0yE+rIT9xiew6HCxv3qcc9GlgfEuqkXTUZW6VNAOTJ/PZjkUtjZo62dirW3qlMMOWRYk27JLGtZdXwHOwGfsAU2PNZ2Crb1yYHzShfEqTyF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 7:48 AM, Borislav Petkov wrote:
> On Mon, Jul 27, 2026 at 08:34:27PM +0800, Li Zhe wrote:
>> The new x86 memcpy_nontemporal() helper in this series maps to
> s/in this series//
>
> That's implicit.
>
>> memcpy_flushcache(), and the ZONE_DEVICE fast path uses that primitive
>> for constant-sized struct page template copies.
>>
>> The immediately relevant x86_64 sizeof(struct page) values here are 64,
>> 80, and 96 bytes. memcpy_flushcache() currently inlines only the 4, 8,
>> and 16-byte cases, so even those constant-sized struct page copies fall
>> through to __memcpy_flushcache().
>>
>> Add 32, 48, 64, 80, and 96-byte MOVNTI sequences to the main fixed-size
>> switch so those constant-sized copies can stay on the inline path.
>> Factor the larger sequences into movnti_8()/16()/32()/64() helpers so
>> the switch can reuse them without duplicating the inline assembly.
>> While the ZONE_DEVICE template-copy path only needs 64/80/96-byte
>> copies, keep 32-byte and 48-byte copies inline as well rather than
>> sending those nearby fixed-size cases back to __memcpy_flushcache().
> Do not explain the code - explain *why* those sizes. I already asked a bunch
> of times.
>
>> These new fixed-size cases follow the existing memcpy_flushcache()
>> fixed-size MOVNTI cases. The existing 4/8/16-byte cases already use
>> MOVNTI without a separate destination alignment check.
>>
>> The movnti_8()/16()/32()/64() helpers keep the "memory" clobber
>> intentionally. The destination memory operand describes the MOVNTI
>> destination, but it does not express the broader compiler-scheduling
>> constraint that this path wants: keep the fixed-size copy as a compact
>> sequence of streaming stores and avoid moving unrelated memory accesses
>> into the middle of that sequence.
> A lot of bla for its own sake.
>
>> A microbenchmark compared two memcpy_flushcache()-style helpers that
>> shared the same generic body and differed only in whether
>> 32/48/64/80/96-byte copies stayed in the fixed-size switch or were
>> redirected to __memcpy_flushcache() when the destination was not 8-byte
>> aligned. The timed interval covered the copy loop only; wmb() was used
>> only to separate rounds.
> So we're doing this only for a microbenchmark's sake?
>
>> In pseudo-code, the two variants were:
>>
>> variant A:
>> 	switch (len) {
>> 		case 32:
>> 		case 48:
>> 		case 64:
>> 		case 80:
>> 		case 96:
>> 			do fixed-size MOVNTI stores;
>> 			return;
>> 		default:
>> 			generic __memcpy_flushcache()-style body;
>> 	}
>>
>> variant B:
>> 	switch (len) {
>> 		case 32:
>> 		case 48:
>> 		case 64:
>> 		case 80:
>> 		case 96:
>> 			if (!IS_ALIGNED(dst, 8))
>> 				goto generic_path;
>> 			do fixed-size MOVNTI stores;
>> 			return;
>> 		default:
>> 	generic_path:
>> 			generic __memcpy_flushcache()-style body;
>> 	}
>>
>> For offsets 1..7 averaged, keeping those sizes in the fixed-size
>> switch took about 0.410/0.411/0.426/0.426/0.428 us per
>> 32/48/64/80/96-byte copy, while redirecting the same cases to
>> __memcpy_flushcache() took about 0.962/0.956/0.923/0.998/1.001 us.
>>
>> The correctness rationale for not adding a separate destination
>> alignment check is that these cases follow the existing 4/8/16-byte
>> memcpy_flushcache() MOVNTI cases, and I did not find Intel SDM text
>> requiring an 8-byte aligned destination for MOVNTI.
>>
>> The microbenchmark is only the performance motivation for keeping
>> these small constant-size copies in the inline path.
> So in the end of the commit message, I still don't know why we need this code.
>
> I mean, it should be pretty trivial to explain: I'm adding those additional
> sizes because it brings this and that. Srsly.
>
> If you cannot justify that, why are you even doing it?
>
> So from going over this again, the reason why you're adding those other sizes
> are because struct page can be that big. Yes?
>
> How do you know? What's the proof?
>
> I'd expect a justification along the lines of: in a somewhat normal Linux
> installation, struct size can be of size <bla>. Adding MOVNTI helpers of size
> <bla> brings so and so performance uplift.


Yes, the real motivation is the ZONE_DEVICE struct page template copy.

The second paragraph of the commit message was intended to explain the
main sizes: the immediately relevant x86_64 sizeof(struct page) values
are 64, 80 and 96 bytes. But I agree that the commit message did not
connect those sizes to the real ZONE_DEVICE benefit clearly enough.

This patch was added because I had measured a benefit from keeping those
struct page sized memcpy_flushcache() copies in the fixed-size MOVNTI
path. The current patch order and commit message did not make that clear
enough, because the ZONE_DEVICE memcpy_nontemporal() user came after the
x86 extension.

I will fix that in v9 by reordering the patches so the ZONE_DEVICE
memcpy_nontemporal() user comes first, and then rewriting the x86 commit
message around that caller and the measured benefit. I will also remove
"in this series" and trim the commit message so it focuses on why the
patch is useful rather than explaining the implementation details.

Thanks,
Zhe


>
> How hard it is to write it this way?
>
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> ---
>>   arch/x86/include/asm/string_64.h | 56 +++++++++++++++++++++++++++++++-
>>   1 file changed, 55 insertions(+), 1 deletion(-)
> ...
>
> at least the code is making a lot more sense now.
>
> The fact that you had to axe off so much cruft off of it tells me that you
> haven't really measured it right.
>
> So why do I really want your patch?
>
> Thx.

