Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A00D1C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20C96B0098; Mon, 27 Jul 2026 11:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA376B009F; Mon, 27 Jul 2026 11:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94B5E6B00A1; Mon, 27 Jul 2026 11:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 587DE6B0098
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:18:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D2C368077C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:18:19 +0000 (UTC)
X-FDA: 85034912718.16.C5FF886
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0FBC01C0007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:18:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iWZotwxC;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785165498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FlEELJyfmAm9HJ6Z+y+pFDyBCjUh75N17pJea7pFUoo=;
	b=qQikvPnoTJHoU1tBZjxweyQDVWFoDs4sKrcmsjyDOyOPOPMtFbpBiJfHVrRNxhgdRWwczU
	//L/EyN+exYJzBxF1TZUBtgp7xPOG7cWicW4eWQhgG1lGtYLdCqaXewkl0/m8RfPvW7LME
	ytxgG8Swd/Kk/7RZkOYCIXomo4nUHhg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iWZotwxC;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785165498;
	b=DvscmJtPy0hhkoTbETOGOY8TyoDh3HGwYe1fTaXy8PZm7kuYSRPYU/Dg3raGSI5cG9LM9v
	Fzw7uGoL3EmfA9GgNugqFBKiSKHhO6BlPFNwEOKk1RnJ8JhaI83exsonG0hcfUZ6mX2hQv
	kedTwnfgy4i70HjLnUfZ2Y5hSL2/A0w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7F2340175;
	Mon, 27 Jul 2026 15:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB5E1F000E9;
	Mon, 27 Jul 2026 15:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785165496;
	bh=FlEELJyfmAm9HJ6Z+y+pFDyBCjUh75N17pJea7pFUoo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iWZotwxCmhlHp9gZr07K13hM+s/qDC1EXkIK4ffjKetua2NjBY8mAxp3cXPiAKvtq
	 diPbaqpdT5XZb8z5YPwv52GJehuURyYwN2ntHzf2mab2h7av6Eq9kdT0d54HLAN/nm
	 ifAaThidyGPLJiw6HPW2F8p+JT9B7MmEs9C1ZSmgmFYqyM6HGxt/Awub/ZBkc7ONXY
	 E+nGgQv4cGNPoZwkjtUjhsY3CTUlI9Dhmaz5pZ58v8CPHFiCvjOk7idMTMN+otO9Fa
	 /Bhty0dWdPePyC2HLiOBRh3sKx2k02l7fqnYB0YeieY4MBjwJJQhezC/xMSoF7bv5X
	 Pfdvwo+HQaT3Q==
Message-ID: <2a2923e4-6166-4ed6-97ba-2e544a1a2f9d@kernel.org>
Date: Mon, 27 Jul 2026 17:18:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/20] mm: optimize unnecessary loads due to
 ptep_get() and friends out
To: Yeoreum Yun <yeoreum.yun@arm.com>, Dave Hansen <dave.hansen@intel.com>
Cc: Russell King <linux@armlinux.org.uk>, Huacai Chen
 <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-openrisc@vger.kernel.org
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <0143b927-08c5-4e94-ae6e-2a0d7bfe950f@intel.com>
 <amD-TLGWGdMK2ItC@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <amD-TLGWGdMK2ItC@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0FBC01C0007
X-Stat-Signature: 3srxjn4whmbzayiwumtmdrucwkun9k39
X-HE-Tag: 1785165497-968593
X-HE-Meta: U2FsdGVkX1/Md3Wy/EJ1/kyHR9HPv8wQaPqahZRhuyMaRcQysoJTXDuP3XJmVClSQhthQDm3T3ERs+U0MDkOytKxY93+YXcOlsggt78aZppbAGB5H4ZtNLb2OObNjZHjRAEClC3mGlXXGit0/nf+yFQM2z0P4sjPWZ/KvaBMHFvIAvsMd7cQ5jmfHLhveq22XNAiW5vj/dk1pTE+USf0vd9xqS5l5G5TAGGBQhYdi9Pi/eX+cd9tu6tIRvexfHqXScLMyWnxMHCcqqeffo5Z3SibxfBkDj6Jo8EmvZLiWfpgE2cPHnzvStYYkltgPS63LJjEYCddEZ51u5SeL26kr0GqSjKFoQLESGHCbj9m5dc7NJF+9LVJnz4ts37BZvaaRPeHDdY9+FtVKY1yT+4jk65IH0+p65dUpqK5Dawx5PV4WtjLLwinTxzZ0HzWrKjkk3UeOtJzUBUiOCTI4GyaALEnFJtfpaHY+raCVnu6kB8dOD9n8zWi1jxs09b0PAilwG/DAVD3gPsdEsICmcwnkGvWyd9WXMRz6P+GvtwIuTrIm1X0ob8I/w+lAzv503KwqXRxUZmawzcqqLdyoYXoIEb0WcRDHivU5MGKGQ2xAS1sLJnt0xvs25q1geDJbk0I9t2Df9NrpTEiTszDu6Uq9mn6Qmo/WqIwhG3sdKYULvOrnshUUi8Ry0SgfNqidIEBUmK4cxApiXQiCKo5HefAO6YRNL3fHwWhbVreK9KzYsArkLWghamq8MsBNipaKjSMklAiZPSHji8VoolrqM1xFisLcKqZoraE87jxY9KvYLL8f+Xjq+ufuC/33Z0BuuBjcT0l3iLWzUvWxJNLqD96NyQt9q0ymkdF9KhKKs7neM64P7+bMLWw3P/WC3LVL2AOToNB0qngHC/u0oJduh2T9Bjcl8SXDl34pY3zOZcL5Fnm7NmnZCBkDRvBDs+BVnMR4XRerD/LaNJB5zlovNS
 xtV8SbFi
 nUUv1wIOph5wYdAHs8md1Pun0wKYywsNI1SZkU46adDs5Z6wgbN5s3wwbsQZrgoCsFPlLLP287qsvabSUP60AV4WxHXmc/vNiGC2x2E/ZzkrJOF2KAPlEDeEgeggB9li7mUgZY8o5baT/kgWcyf56TUAGi2YBYEYoaqCfqyZocZyZkN0N4MIZTVTIDhKkkHOACYw0HZtYSzanvyFW+9lcfmlkF1ZxOgus5wPc7ZqhzbK5LH19aXvkE8dX7ioZjI8nPBpAwjnn66gTIdQxMbwVXNsgxRBt5Abo6Exl/kx85+pQwBfwOHgT2rDZFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 19:30, Yeoreum Yun wrote:
>> One of my nits about v1 was that it didn't really frame the series
>> precisely. It talks about "optimization" instead of fundamentally
>> changing the way that the kernel deals with folded page table levels.
>>
>> The optimization that this *wants* to talk about kinda falls out of that
>> refactoring. It's not really the core of the series, IMNHO.
>>
>> This series effectively changes the rules about where and how folded
>> page table levels can be manipulated. In doing that, the door is opened
>> to optimizing out the unnecessary loads.
> 
> I see. might the title and the cover letter should be reparsed.
> Thanks to remind it again :)

While v1 changed "where and how folded page table levels can be manipulated"
more drastically, v2 leaves most of set_pgd/... working for now, and really only
changes how pgd_get() operates.

With v2, there is mostly only a change for page table walkers that use
pgd_get(): while the existing model already made all these levels be skipped in
most places except in ptdump code, we now also have to skip them in ptdump code.

So yes, that should be clearly spelled out: as long as pgd_get() is not
involved, set_pgd()/pgd_page_vaddr()... will keep working as is.

The moment someone switches to pgd_get() with folded page tables (like riscv
already does), set_pgd() is disallowed, and modifications on the actual level
must be performed. As discussed, a common helper for vmalloc faults would
already minimize the pain quite a lot in that scenario.

While we should make that clearer in the patch description, I am wondering
whether we should also add some basic MM documentation for folded page tables,
where we at least explain the current state-of-the-art (what's ignored when
traversing, why does "no_p4d" actually mean "pgd helpers are dummies and p4d
helpers implement the real logic").

-- 
Cheers,

David

