Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 701EBC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A2C06B009E; Tue, 11 Aug 2026 12:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552ED6B00A0; Tue, 11 Aug 2026 12:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 440F16B00A1; Tue, 11 Aug 2026 12:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11A806B009E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:47:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BA3312014A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:47:52 +0000 (UTC)
X-FDA: 85089570384.11.1CBE09D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5E48E40008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:47:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="gTV/2I8H";
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786466870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPBfDxKxUoGsTZQWDQK497a48XaoCti5RkP3xp/cBKo=;
	b=Lcor08dvDPn6YOnzKvnBL0in7R/UtpkG9kykl94hYZt0SOinNwxHfnJqb/wO9HiISLRLYR
	srrDbUdqfb8TnOXd75vhmYRGiuqVIyAWWfOYh1zNfVxO7RuGOpY/3poTrvg7PeSKRi6g8g
	JONtsbAVvqza/0JKyeQ8F3mWCQbypSs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786466870;
	b=607jARNgzKf4uGeLeQs/f7fbKhVFv1KqCnOx/gcj/WEFF8CmBhQ/IYIwh/XoNe3KBDD5qV
	HvOAZw6Z9Pn421207//jYI/0mKoA9WnGdr5+0O2bO0O0P18ptdGtrTPM0rAtGAS8zkQvIu
	wD581LTUSBiFxYSYpg41YRZoDkJgpH0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="gTV/2I8H";
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 392871516;
	Tue, 11 Aug 2026 09:47:45 -0700 (PDT)
Received: from [10.57.5.246] (unknown [10.57.5.246])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CAF723F86F;
	Tue, 11 Aug 2026 09:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786466869; bh=k6fuvdQDvEP8Vgz2PTv5lXUtwGGjwj2b08wkJAsWaVA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gTV/2I8He3BRcDFubFelv3SAtZiIJOlWDCGYb/PqwlMmSJRZUV+SfPlIf2y0trfly
	 nKQsPwWsI+/aVoYR5dV3ihriAWJ5e9TgHciz8Ikf7zi44esgAkNV9YyJAGhPOgjzVd
	 dWAjOsQ/MfHlSTn8IGEVVhT1EzNUwNUvSRhbFuk4=
Message-ID: <ac24fe96-dbe2-419f-86eb-2d0f78912877@arm.com>
Date: Tue, 11 Aug 2026 18:47:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/22] mm: introduce MMF_KERNEL flag and set it for
 init_mm
To: David Laight <david.laight.linux@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
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
 <01f07ea2-8bdd-4450-8a49-548f8b646cfd@kernel.org>
 <20260811142507.4c6c760f@pumpkin>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260811142507.4c6c760f@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3awx46zswhxp5dhah49yy896tnfaqmzk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5E48E40008
X-HE-Tag: 1786466870-152870
X-HE-Meta: U2FsdGVkX194sI2KLyglfMt1bT/1pz4hK/iuv/iVD4vxELd26jE2wHDbphgJbNifaOXJh5yOSquQ+UA79vVqiEh/UKgqvazzTn6PepPCujHNbqKD2Lgn8mKHKRm4ErDyCHRCSYIJqajM4G3fgk5OGKwco0NgDcROl1CVq5NTNBTVa/GyFTbajhFbV2c1SO8Y/KJk1xot1YQ15oa6edAeaG0hvkokFX5TGeZhN5q4eVQNc4NvCeYTrKgPnxtMLK7bQppldHEIFC843O0oqt9++dIO2mDK0ukFReHraidqehSQilFu10Te8amS5mfoc+x//A0wz3FceDSKZ4SjLEGwXcLQwN6CaAA54ZJdKHya496lnXsYtlygLJ4VNGyUmx4/DyFH/N4QgtfP795/Z6qwuhMFLQMJlxwod788bSj8QBp7a7Rygc4y9yxhvAPZFohqdXElOHuqzL0EjC5FUpjCVpry5p5hPwVYdwtNrJN+1MR2bWf1zHk3NnAE1dy6hPilkI0+X4luyFd+hw384psCiIObq4b8NmKovz1wkdAfCjsmrXX9LIUItqJKCILEtW753RMHb/f/59FVkb2K1Cp7mFsPiTYyrPF/u0djVWEtXztzLbj/WE3rKDaBQUr/Wum5g2lDuWmsCTopcbTMrC4SLykFsr5BjmBVxLFzBWIWT9HM5go0a003fcEDvyWtbNmR0JpeOom7nB7bX6w51AKR63lqonxgzdQvZQwc+oowX10d59BwlyCMW4ckf5oeCzLU7ghoWUd03v42CJYE6iBA5hSlPEc3WKQTYvgbT27J/FFpYpXsyesUxNcFy5pjcAfPsouTbayb6403K9Gja0HtoV1m9xeNAEBInry1baAsuB2BLHHnkz9QNunbHJl9z/45ViAZPSAGktrzXPGChUkoi8DAwaCLy0mJHFaTb7hVhCWPk3LZ+d+nHXegtWelBZ/IKUhqV0P33AL5AyHqeiH
 3LqSsU8J
 rrE7nRXy2+1bwayApwT8+HCU/aW2kUH0tcZlPxMLGvgSk0+kz6RbyhTZKiy5FiNuUkeDuXpYzNUxJFqJtii0N/PQUInLGqIQxxDVzIZL5cHWuKI0f5W+wFyons6se/eICsIJGOqhHDLu2HtdX2VqirKeXA7SIpnuDAKlC8KxTN0Jja00Dhp/2jjG2j+utDeUtNEDhzssgFF7soJ/YYQFwwfwcprzZpFzr5B1LB0QB9YN+huyn/jhas4mKn6rrQQavRIyvfPsqnSYH7nD0ON0LcjOpT9sG+To7L3uLlVdbwaVr5lAm+9kDSYtQOe0J1m54K8tnggqggJXQDYn26sNYNZPhY9k4lFcDSA5cGcIFu1pDx2DL4GPRc5OV1Y3fVp4Pb8ESwTdxi0lSzfmsbIXLtwt+nuA92d6jofFUHhtPC0Obzg+p4Z1AK2hRx7OhMUAfE/yE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/08/2026 15:25, David Laight wrote:
> On Mon, 3 Aug 2026 15:59:35 +0200
> "Christophe Leroy (CS GROUP)" <chleroy@kernel.org> wrote:
>
>> Le 14/07/2026 à 16:03, Kevin Brodsky a écrit :
>>> mm code often needs to know whether some mm represents a kernel or
>>> user address space. This is currently done by comparing the mm
>>> pointer with &init_mm; besides not being particularly elegant, this
>>> ignores the fact that other mm's (e.g. efi_mm) may also represent
>>> parts of the kernel address space.
>>>
>>> Introduce a new mm flag MMF_KERNEL and set it for init_mm.
>>> Subsequent patches will use this flag to replace comparisons with
>>> &init_mm. No functional change is introduced for now.  
>> Did you consider performance impact ? This test is usually done in quite 
>> critical memory handling functions.
>>
>> init_mm is known at link time. Before your patch 08/22 there is just a 
>> comparison of mm (r3) with a constant (loaded in r10):
>>
>> c0014048 <assert_pte_locked>:
>> c0014048:	3d 40 c1 09 	lis     r10,-16119
>> c001404c:	39 4a 03 98 	addi    r10,r10,920
>> c0014050:	7c 03 50 00 	cmpw    r3,r10
>> c0014054:	4d 82 00 20 	beqlr
>> ...
>>
>> After patch 08/22 we have, it first checks that mm is not 0, then it 
>> loads the word located at mm+528 then AND it with 0x1. This load might 
>> be costly.
>>
>> c0014048 <assert_pte_locked>:
>> c0014048:	2c 03 00 00 	cmpwi   r3,0
>> c001404c:	7c 85 23 78 	mr      r5,r4
>> c0014050:	41 82 00 10 	beq     c0014060 <assert_pte_locked+0x18>
>> c0014054:	81 23 02 10 	lwz     r9,528(r3)
>> c0014058:	71 29 00 01 	andi.   r9,r9,1
>> c001405c:	4c 82 00 20 	bnelr
>> ...
> Thought...
> Could the check be replaced by one that checks for kernel static data?
> That would require that other mm that represent part of the kernel
> address space be static (and probably not in modules).
> ISTR there is an address range check that can be used - and might be
> cheaper than the explicit test for init_mm on many 64bit archs.

That is actually an interesting idea. Finding those "kernel mms" boils
down to looking for global mm_struct, so checking if mm points to global
data would achieve essentially the same thing without a flag (and likely
faster). I'm not sure we want to bake in the assumption that "kernel mm"
is equivalent to "mm is global" though.

- Kevin

