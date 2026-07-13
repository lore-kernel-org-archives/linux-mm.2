Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59370C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456166B00D3; Mon, 13 Jul 2026 12:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42E646B00D6; Mon, 13 Jul 2026 12:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CE2C6B00D3; Mon, 13 Jul 2026 12:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFC4E6B00D4
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:21:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88EC61C1F05
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:05:13 +0000 (UTC)
X-FDA: 84984227706.23.A5220AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id BE86F140015
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:05:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BvAfS+kz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783958711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ESM2SzSD3UynOgixO3ALqhK0K8aaLtWF+/LHsivKfc=;
	b=NyjWZ3U46+IvhcpEm9LOzvi0rl2l/HaTrq93lAFkB3AysIpu8GQ9BkycciymyO7xupA9oW
	b5rv6YEdpwZHGVA486qI4kn09DqXsRwDfUYoRygR1Tw5SOb32mXOhFTUjBvlP+TahOULh+
	m0ytXjp2ZFa9OT0l/XsQQrEJc0jYT4w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BvAfS+kz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783958711;
	b=wnjoD4VLHHKBRRWI4/Yopy35tcKRGPx7F93CS/aq6MJ9QGiHQtCso7XCo2cI5iQSl9uEIn
	kB62yzfH9Cs+U51kHUL7kggC1yLNGZeNMd/1AyctDMm5djpdBzrTBdHe+EVi+mokospc4k
	ezuGG19UdJGO431wrDbZsw1cYxr2FCo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B5C92600D8;
	Mon, 13 Jul 2026 16:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224DD1F000E9;
	Mon, 13 Jul 2026 16:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783958710;
	bh=1ESM2SzSD3UynOgixO3ALqhK0K8aaLtWF+/LHsivKfc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BvAfS+kzALSX82y1Di2VtOQp38EMVYa/a0vHm/IjTpc7kf4jHjuOTM3sKo8R84O9c
	 xOk4JPna7qvfy1PaukIZF3T6cPMAXfpfTSZDna4XE+oYrFfmsKMFc4d0xDKcU5/eKx
	 U2YwGSZRSNFKcvP67THVBGvhPF76bHe3Vlejfo+krhMrjRfHJBFUB8U4uJ9SFX0fWQ
	 Qts/DhSoySClKbyxe4FlftP3EjW4m8SF2SIajlKKylzaXj3KgTYmFpd3BWKFz00kdW
	 b89lbYsbbXIQskkvAlEcQj7q/YxyAGkwddulKX1HhX8qMFejkF1bio8/BTAmHZMc7B
	 eOM3fNCfKhXaw==
Message-ID: <2858abeb-4134-4768-9a35-a569d5c86e10@kernel.org>
Date: Mon, 13 Jul 2026 18:04:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/34] ARM: mm: make 2-level pgd_t a scalar
To: Arnd Bergmann <arnd@arndb.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 Linux-Arch <linux-arch@vger.kernel.org>, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-mm@kvack.org,
 kasan-dev@googlegroups.com,
 "linux-csky@vger.kernel.org" <linux-csky@vger.kernel.org>,
 linux-m68k@lists.linux-m68k.org,
 "linux-openrisc@vger.kernel.org" <linux-openrisc@vger.kernel.org>
Cc: Russell King <linux@armlinux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ankur Arora <ankur.a.arora@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Magnus Lindholm <linmag7@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Klara Modin <klarasmodin@gmail.com>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, "Kirill A. Shutemov" <kas@kernel.org>,
 zhangtianyang@loongson.cn, wangyuli@aosc.io,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Lorenzo Stoakes <ljs@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Rohan McLure <rmclure@linux.ibm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, Anup Patel <anup@brainfault.org>,
 atish.patra@linux.dev, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 qi.zheng@linux.dev, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Yang Shi <yang@os.amperecomputing.com>, chaitanyas.prakash@arm.com,
 Ard Biesheuvel <ardb@kernel.org>, guoren <guoren@kernel.org>,
 yang.li85200@gmail.com, Alexander Viro <viro@zeniv.linux.org.uk>,
 Dinh Nguyen <dinguyen@kernel.org>,
 "schuster.simon@siemens-energy.com" <schuster.simon@siemens-energy.com>,
 Vivian Wang <wangruikang@iscas.ac.cn>, junhui.liu@pigmoral.tech,
 Muchun Song <muchun.song@linux.dev>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
 Nam Cao <namcao@linutronix.de>, Pavel Machek <pavel@kernel.org>,
 djbw@kernel.org, yu-cheng.yu@intel.com, Baolu Lu <baolu.lu@linux.intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, Coiby Xu <coxu@redhat.com>,
 Andreas Larsson <andreas@gaisler.com>, "Liam R. Howlett"
 <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Stafford Horne
 <shorne@gmail.com>, Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-3-yeoreum.yun@arm.com>
 <d57f5b18-583d-4848-9d74-65b15c93dcf8@app.fastmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d57f5b18-583d-4848-9d74-65b15c93dcf8@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s8fwgp7cke5ozjzmgy8o77k5cmbsfzxn
X-Rspamd-Queue-Id: BE86F140015
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783958711-516151
X-HE-Meta: U2FsdGVkX1/6YsVK6kIb21cgFE5ue124bvvWv4lLOWjx6bOe8/7ybHUwaxCIGHCeufb5HzE02evZ4IAOGGNOyHTdgwOVe3cMxuhLJxFEjRdWOX3LDZrLMpPnvVId7acL+Y3YTmY4XjSAPACc7NsHNuiQxwjikxxV+fuwLtfhmI5ZBy1NWtZpy89KnMjPS4jh4CUwChuFk/8DQjxH2J1jGYhJwTT5mX13FRwI3oA+3/03CduipcdahHvuojcLoCoHrY6cKhBX9wJcaMj8ROIYMMj8tbrd31OB/nzCQYuP+oEbDmdSMKFc0dLu3nMSYMGA0aFB4lHLEJnxfqauyLZ9M/ZNjd0khKH3rjJZGJjlRmEoWtyEinimTG/Y/eHpQMRdRJpYv1yxqatwpPxzKeKoJSTCRlk71tb10D6IkZdiRFbHSUhL4yyuXBeBK/tiwGV/dB1Lgb0g56SXgX538sU0yLADAAeq/LlOkhK7HRKUjBV7++8Xind6SBWjdxUju2fZiVQJqInbjDqhE3XgRdEsffubRxybLXt1ifkmqFHKC/35NeNSFPzGLuHE6iNB2XbvmeDW6XCOOmB7OcTtD9ksQ04MUj4nYvZ6T5tTEaTHTu8bBjqqHpJZCIKTz6Yef8SepuOY6XxPxokIGi8Wbxx/GgTNSiBP9gbCvW+FDLZY/FCedMNoM9Kpe9cbROU8+sRYcYjoj95ch0/7bdJvOl+SL6L71VVp1prA8+s/ywqi7f1If2XoK+M5EqH7GEjCMAhXRDqzrnUaUQ90xJjvB/UcxB/G/DtwhPwONaNF9MGr1wVzp8bo7ZYFyFsSOe+pslmaL9EdzCTb9yONrzyN57PKLgHRtJI5In32vSzxPwBbJWQ9D17mz7LGnG1fEriZGQjcKWWLbnZZMgNCZLVHn7sntcKSgh42vRCgKt930fFPLXiSja32Ccl+LW5dj3BMrdJnX+jUOQH+CjdhLeicCP5
 cE56LRjG
 lp2A3/Fzz3RN7s5uLg1KoltMutU+QfoZZrTEEHraH7QpvSYF2mEpGiQoltQaoC9iAhJ5a9WTc6i+orX+ulTLGemBrl42vgIJ/VNsx4COKDrLpuvNIWZjsh04hXVVHychLLadWSR2P27UeA0oZh//ayHXM5jMC3nQCJwcZA/R0/nULFTPqMWzd/gvx7mMu9hMdeX6pZhcEZ7XEFPC/cGyxaTxWHOS/LlijHNQUnGky47ps4GQ08FpSadcID1khIVUhooXGKPkPACgs7Hz/ZKVwe7ZOgp1uUYx0NfLYistTPs0uO2uzO35uNOCEh/axTsUlQRBP2DgirdhjJtp0nWbmOoG9s6mK1NmjVb4hrezZ7prSW3dKADd6wEl+/0/GTc3d6IReelHYorQ8Fpkmfm3fO0Pbm9+bJD2ySjyrCGqO4gU4oOHLHmFp4jKCm2QEWRzpjBkz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 17:38, Arnd Bergmann wrote:
> On Mon, Jul 13, 2026, at 15:55, Yeoreum Yun wrote:
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>>
>> We don't want pgd_t to be an array, as it prohibits returning it from a
>> function, like pgdp_get().
> 
> What should pgdp_get() return on ARM 2-stage page tables then?
> Does it return just the first entry or concatenate the two?

It is rather obscure what we do (below).

This patch tries to keep the existing behavior.

> 
>> +typedef u64 pgdval_t;
> 
>> +static inline pmdval_t pgd_val(pgd_t pgd)
>> +{
>> +	return (*(pmdval_t (*)[2])&pgd)[0];
>> +}
> 
> This could use a comment to explain what this actually
> returns and why the second entry is discarded.

It's rather crazy. We have two page table levels, but fake that we have 3.


There is some documentation in arch/arm/include/asm/pgtable-2level.h

/*
 * Hardware-wise, we have a two level page table structure, where the first
 * level has 4096 entries, and the second level has 256 entries.  Each entry
 * is one 32-bit word.  Most of the bits in the second level entry are used
 * by hardware, and there aren't any "accessed" and "dirty" bits.
 *
 * Linux on the other hand has a three level page table structure, which can
 * be wrapped to fit a two level page table structure easily - using the PGD
 * and PTE only.  However, Linux also expects one "PTE" table per page, and
 * at least a "dirty" bit.
 *
 * Therefore, we tweak the implementation slightly - we tell Linux that we
 * have 2048 entries in the first level, each of which is 8 bytes (iow, two
 * hardware pointers to the second level.)  The second level contains two
 * hardware PTE tables arranged contiguously, preceded by Linux versions
 * which contain the state information Linux needs.  We, therefore, end up
 * with 512 entries in the "PTE" level.
 *
 * This leads to the page tables having the following layout:
 *
 *    pgd             pte
 * |        |
 * +--------+
 * |        |       +------------+ +0
 * +- - - - +       | Linux pt 0 |
 * |        |       +------------+ +1024
 * +--------+ +0    | Linux pt 1 |
 * |        |-----> +------------+ +2048
 * +- - - - + +4    |  h/w pt 0  |
 * |        |-----> +------------+ +3072
 * +--------+ +8    |  h/w pt 1  |
 * |        |       +------------+ +4096
 *

So we interpret two 32bit entries as a pair (64bit value). Together they span
2x256 values.

Then we make PTRS_PER_PTE = 512, to iterate all of them (both pairs).

Let me do some more digging to come up with something I can confidentially
document here ... maybe I'll just refer to the comment in pgtable-2level.h.

-- 
Cheers,

David

