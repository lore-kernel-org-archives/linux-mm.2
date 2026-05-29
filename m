Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71657CD6E51
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 11:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B10786B0005; Fri, 29 May 2026 07:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC14E6B0088; Fri, 29 May 2026 07:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AFBB6B008A; Fri, 29 May 2026 07:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8AEAF6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:19:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E039C8994
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:19:54 +0000 (UTC)
X-FDA: 84820212708.03.038FE72
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4E86912000F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:19:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VmEQNF8A;
	spf=pass (imf29.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780053592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xtH8EAmvqZSbaipGcXqbfvMaLUl7NiYH5Y5wqwunt3g=;
	b=qT4S4B1nWl4BkJQZSv+/dFDR7p01Iu32q/3xQ1qtg1+nSrjrfwbRIVF1kf6PKHQhRBUz92
	9j5hGPPVcfAHeDXCDUvQ3AGxYmxWv9ZaY85TFvslwc2Lf+cANvIZ4LRDMoDBEKqzRxnbOu
	0Qu8RgBwc1mwV0K+Y21NIpj7/h2v5kY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VmEQNF8A;
	spf=pass (imf29.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780053592; a=rsa-sha256;
	cv=none;
	b=4yWwH/h1/wfQL8oZCv3/AlGIg8RRyIh5k6ceoycJ7yIzKDdvGYMYN7cbK6qcQhUvBfPyI0
	/HV6DKJmjtkdGJb8tOpy26/qHcPdLDtViDl/x4t1/bCBRqHz3bXWOp53nfT3OI1I5uw9et
	3fS6jneXvmCrgd3vxEv5wROBj5tFSUg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B20D06012A;
	Fri, 29 May 2026 11:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5841F00898;
	Fri, 29 May 2026 11:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780053591;
	bh=xtH8EAmvqZSbaipGcXqbfvMaLUl7NiYH5Y5wqwunt3g=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=VmEQNF8A0z8+1KzIlCnBSO2nUEjqvajOvCGEzAL61RGw93MGpbxmK5hJDcK4X+hgg
	 UZKxfoV+OrLA00JLpRYVuEnk2+zG0EcpjagS5/KmFt0OlhLC2p/e7meFVlfDWD7qGs
	 nXTLDmbcXuJ39EZkHnlth4IqaeCi/xiYBJKbRQwcygEsAdh9ylf/Ou+VU97yLvZ9Cs
	 KUHV7496Qj6cK1kjLuE0clbEqRyZChdum1FkQtJgv1XKb+hiJafgFN/nxu3gSZRMV6
	 cHZPnxD8vXnSD0ap3nn/GVB5hOYSMxIec2bGVi+edJ+wzEHCTm2BRGVHuY+7qP1zKL
	 Hwp9v0rR9TS9A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id ED4F7F40074;
	Fri, 29 May 2026 07:19:49 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Fri, 29 May 2026 07:19:49 -0400
X-ME-Sender: <xms:VXYZakI5lWrnjge3izJfszwDrLDqJlPb7nZ0fT2HU7TYrL3TCplw0g>
    <xme:VXYZau-AYVOUF9zWLtiR3lm77FNmKJDLXiNWTgXWm9kM2PbUtk5JH_BTb9XckEQOf
    IM6xKd0uVlGv-Af0EaHgCLAEeZ07MDo1zAmw0HyV4We9otTLxNO-NQ>
X-ME-Proxy-Cause: dmFkZTFogum++9uuClw8cy4SxNf1uWqqkvv8W4zIXBwA82RSASLtxRMehGsMOXMDBhgeWs
    nqlmwZCFKVFfLIVlHXs/McboQpxGj3Pf/Ca9vw5Fnwc460UfhaDDOmaD3qvEx/I9yot16o
    HKbvIb5r5GxP5YIN93FaDmoekYS17nZB9LNN3lQjM9012YeqOgV9t7nikOyyFsfLmoVLay
    2YMvHAVZxPo//ZDllLTAZWgQ4dya84DY5uFQ7jgZWp0nWHWbC6LnXyanKW9V439JwchFGC
    I+7TQCdJ0Aia8Y6Nx/jquUp5kpwJr9SFRPG5NT61F+6w8immYHkB9rO2MG46U9M4rAtks7
    FeYlv48F9dDSBaNVIhgiLyXG0PEVVdSqnyDVJK19Q8VZKEv7FqVxTjyauoS88acTjMpWp/
    wnyx9eq5Q+f5wK4egPUSKqhj7maPxidfHDG1WybBbDoe8hefgi9mzbvN6wOxEvLi4ThE/i
    MCWVLp78FR3MwE532+oBLLfeGjmhf6gZyKHjLuYhzMxUvJnYMpPai18akdXzsdwQK2aSsn
    wpp1RuigsjRmFaaIsnA306F8hDP1J0Fxb+aIo+N2kmBwBA8HAEREHRMnLbSamezdfHC6Ve
    s9QaINOtjR8mBOL8OW8amM7Webdd9NcpxVnF5I+lLv9XwA9CwYgWN6RjMV6w
X-ME-Proxy: <xmx:VXYZanXYdNwCH4CsxKGeZZp6kszaQ63Ocg-v04B-teUHBstDlEmyMg>
    <xmx:VXYZamBp3-MPM4qn2rsNYhHpzsmmVdV5g6OjHCmDaSXkN1v4jHu47w>
    <xmx:VXYZag7SWu0rxSwEDztJtlk8ygBpxPpuf624jcXQ5GC0FR4qM0qwuw>
    <xmx:VXYZaqsRBvAntj4cnVkJkSyhoVKFoo__reIoGcw406RrMsk5tE-WSw>
    <xmx:VXYZagzZ6tepEBQMivW1UkJKqyKitg7wfO0OdNyGrhha1AuEusqO4XPX>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id C1546182007A; Fri, 29 May 2026 07:19:49 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Fri, 29 May 2026 13:19:29 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Kevin Brodsky" <kevin.brodsky@arm.com>,
 "Ard Biesheuvel" <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "Will Deacon" <will@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Rutland" <mark.rutland@arm.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Liz Prucka" <lizprucka@google.com>, "Seth Jenkins" <sethjenkins@google.com>,
 "Kees Cook" <kees@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Jann Horn" <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
Message-Id: <96a8b6b9-71f2-4550-bbbb-fbfa146f4e6a@app.fastmail.com>
In-Reply-To: <2a6f9f05-ac57-4ef8-9328-74cc8ccfea16@arm.com>
References: <20260526175846.2694125-17-ardb+git@google.com>
 <20260526175846.2694125-26-ardb+git@google.com>
 <2a6f9f05-ac57-4ef8-9328-74cc8ccfea16@arm.com>
Subject: Re: [PATCH v6 09/15] arm64: Move fixmap and kasan page tables to end of kernel
 image
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: a75h7gnxkcfybpkehzsnsjopjn8jfmtw
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E86912000F
X-HE-Tag: 1780053592-338244
X-HE-Meta: U2FsdGVkX18ITHJtwWY98qz+jHpH7pBFDHjnQfmjGRW87YddPTAnxny3mgxB/WPpxTCk+to51NONhWrtN3EMp/M7NBgHVlCy6CbSaVB4Ll6eJzWs5Y4eOt002hbod+3JBFGVeIwv8x5gGUT1xV3Oh7Rxh6WvzyhZciTkE/Q5FRBJqjOFYA+7NhIL3EceLNVK9HfRTzzHdgVBwGzbb0JZmq/7tBAYRykIV6vpDBqfd2p9vL8fX+Ze6JUD1WxMVSQIgt2Mokt5DIMhYp2dmq/7Ss2Z7DMrEac1piRuQ1nUqJU1Iwfo1nkGbFvXySb7AEgzMEUcOIsHh1fi0aLE55BzBQ5cVVm1YNpuD/6bjmj7cOfzRKMd2OlJbcoI5TaU1s9oP0XUsjmhVE5LfB1qLzGc0/8enAINMvKo0stAQjqdG/ydbhA1V4IY1k0fPgI/J5mcoXVeFQYrPVVStBa9XiQoGQmryoW3x75iWpTG+H0mk28m4GUFBcMiCD6kzD7WN8ixN3W7IXZBtPLpwgVLn5V99ieJW6CqL1M1Vj0WPYkPkExnrr+WLT8Myy8c47PN0S+05+kCMhXdiNQXmx5BAJJq6OOXxSkoelMkLNJlkOfaHMBcGNGTjN/H+e9ZSEqZUH+y1w0BHMBXELtMW6q98BK2BJA9tFdmIU+95sI2/nwZcKrSAr04bAGLIOvR0M9ztz+dv+fMp+vnM9YNqadstZ6akXalsuoz5F5qS0uXovWms1TgV2IqtZUsLQaXxlxo7iYWVYU8Y0u4CHxd4m7foeUplzjBnt50DLzeGmUImTHIXCZ34XLF2dbcN7eidqMDLkVSW+XEg0oEMTTZlI/p8T5pB5DsG96LrEUfsvPutFyV7BW8jt2AYekC9AamcYqQt2469ZPkq3cZO2/S7b3/NnOrhLOM3aSeZD+fL1kcwV4G1fJtXVNbWkbWjpFtC6egCy9rjly6W409Nz3CeT25eNb
 DtA9SkeA
 dXlzUgE4hKxTDkw/77l9qIEVFCezHFux5xP6LTBvK2zga2C90ZkmkPX4Qti55mfaflv/TfoW4mK2laW7iAD/LuyqFWGvhhqQerWxpoG+c8iWTFUWdo4Bvj4/MIbHgvxagyV8xjjdwR6vNUdMOJ91tIfg4hRbnjugdgX3b0l1XewEs4EzPP0Pf6vVxnK8hQQryKw3o0n2iX8VGPpthgeddVrAh2IJEtJGYHp9GnGBmF9K6v0TvU9AVYmhj8cxk5ecwgos2MT+g5aHPHcA4CPUmO/bg5PVdcQd3TASlsj7MZS7h65nef6GYJSfCrW8CifAkjdmL1T7r+2XOoM7tUsq1n5oB6mvi2VUqSGKJH2PgGXXSAHSPxYLZWKE7T3USJYgAAhlcNYc36MbVcKlY23CJXTwq8CPbt+rMN0QLyaMTqMwE3jeVni4fz+KvYJ8FcYtLbjkZDs8Z3Lc3AgrpYWjVoksCUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 29 May 2026, at 10:27, Kevin Brodsky wrote:
> On 26/05/2026 19:58, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>>
>> Move the fixmap and kasan page tables out of the BSS section, and place
>> them at the end of the image, right before the init_pg_dir section where
>> some of the other statically allocated page tables live.
>>
>> These page tables are currently the only data objects in vmlinux that
>> are meant to be accessed via the kernel image's linear alias, and so
>> placing them together allows the remainder of the data/bss section to be
>> remapped read-only or unmapped entirely.
>>
>> Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> ---
>>  arch/arm64/include/asm/mmu.h    | 2 ++
>>  arch/arm64/kernel/vmlinux.lds.S | 8 +++++++-
>>  arch/arm64/mm/fixmap.c          | 6 +++---
>>  arch/arm64/mm/kasan_init.c      | 2 +-
>>  4 files changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
>> index 5e1211c540ab..fb95754f2876 100644
>> --- a/arch/arm64/include/asm/mmu.h
>> +++ b/arch/arm64/include/asm/mmu.h
>> @@ -13,6 +13,8 @@
>>  
>>  #ifndef __ASSEMBLER__
>>  
>> +#define __pgtbl_bss __section(".pgdir.bss") __aligned(PAGE_SIZE)
>> +
>>  #include <linux/refcount.h>
>>  #include <asm/cpufeature.h>
>>  
>> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
>> index e1ac876200a3..2b0ebfb30c63 100644
>> --- a/arch/arm64/kernel/vmlinux.lds.S
>> +++ b/arch/arm64/kernel/vmlinux.lds.S
>> @@ -349,9 +349,15 @@ SECTIONS
>>  	_edata = .;
>>  
>>  	/* start of zero-init region */
>> -	BSS_SECTION(SBSS_ALIGN, 0, 0)
>> +	BSS_SECTION(SBSS_ALIGN, 0, PAGE_SIZE)
>>  	__pi___bss_start = __bss_start;
>>  
>> +	/* fixmap BSS starts here - preceding data/BSS is omitted from the linear map */
>> +	.pgdir.bss (NOLOAD) : ALIGN(PAGE_SIZE) {
>
> Do we actually need the NOLOAD type here?

Yes, otherwise it is emitted as PROGBITS, resulting in all of BSS to be
emitted into Image.


