Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63E7CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D1236B0176; Mon, 13 Jul 2026 13:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781696B0177; Mon, 13 Jul 2026 13:08:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649D16B0178; Mon, 13 Jul 2026 13:08:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31EBD6B0176
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:08:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A96F9C109A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:41:43 +0000 (UTC)
X-FDA: 84984017286.30.1F473E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E4EF2140015
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:41:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d/plkVO6";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783953702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBY6/zZhRC68VTHJE9tvmewxH4e1dhtoSqkrqElBdFc=;
	b=6hjo2M2ux9qNkNXMPxsOKghxbkqWXfma8qqpUo44EzYNXhzm/kXKUTmGbmQDKCWVOJ922C
	AN1aJ9Y3SwzAxf61Nu4PVAMXm5XZ6642jkE1nYff/aaapj3BqtPiBBT4HIPFpX16tfEeeX
	yM+l7sP5vto6Bs/JQKDZ9M256BsLtIs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d/plkVO6";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783953702;
	b=IWQ9yCnlWbL+14rmvb3pVziECKjncIecxRLoGYROTszNeaKbRrJSvlhibXlDNGNd40v+3T
	oyH72mlZrOKX6cp3+fp8uVkL9st7NSzmKZx9DzqFR6AthoyMoVVaCw/J8B8tLfd9gxN9ti
	MoqQavn6xi0WWB7L4xEKip2ZEN2ffa8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3F2140A31;
	Mon, 13 Jul 2026 14:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B469B1F000E9;
	Mon, 13 Jul 2026 14:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783953700;
	bh=TBY6/zZhRC68VTHJE9tvmewxH4e1dhtoSqkrqElBdFc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=d/plkVO6rd2qyJeLzEs11C0CVJuuf2HHzGqHFvzPWjZv1ksY/lH0oxGrPqOvw8FfX
	 18MMa+NOVo5QdmAqNVR0UtR/9ZeqLdnY3BpMxrRbtBVmHu43AOkVBQkU1uQQd1F33P
	 CbE+s+9cAC8IO5LVmPWqzQPOxfFSfCZKnF6ebz2JG4NKXqNKv1QYgQX6muXKZu3ONG
	 iL5KScKLuAU/LfLE4qujl94KWh8JFBZIQy0cQrSUDrA0H6dYtF6tqwyifNJkq2SjWT
	 sQ/MytTWT9Pj9iOKN186Nu8gU71p+1cNNW5Xci65ELCHB1s3hC3yM/OBIlGlmAenDI
	 ZLwyPHMxcbq6g==
Message-ID: <ac365196-8ccc-4d8b-83d7-28fec763e75c@kernel.org>
Date: Mon, 13 Jul 2026 16:41:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 10/34] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
To: Dave Hansen <dave.hansen@intel.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-mm@kvack.org,
 kasan-dev@googlegroups.com, linux-csky@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org
Cc: linux@armlinux.org.uk, akpm@linux-foundation.org,
 ankur.a.arora@oracle.com, rppt@kernel.org, linmag7@gmail.com,
 chleroy@kernel.org, klarasmodin@gmail.com, chenhuacai@kernel.org,
 kernel@xen0n.name, kas@kernel.org, zhangtianyang@loongson.cn,
 wangyuli@aosc.io, tsbogend@alpha.franken.de, ljs@kernel.org, jgg@ziepe.ca,
 catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de,
 ryan.roberts@arm.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 baolin.wang@linux.alibaba.com, tj@kernel.org, kevin.brodsky@arm.com,
 anup@brainfault.org, atish.patra@linux.dev, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
 hannes@cmpxchg.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, kasong@tencent.com, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, anshuman.khandual@arm.com,
 yang@os.amperecomputing.com, chaitanyas.prakash@arm.com, ardb@kernel.org,
 guoren@kernel.org, yang.li85200@gmail.com, viro@zeniv.linux.org.uk,
 dinguyen@kernel.org, schuster.simon@siemens-energy.com,
 wangruikang@iscas.ac.cn, junhui.liu@pigmoral.tech, muchun.song@linux.dev,
 vishal.moola@gmail.com, namcao@linutronix.de, pavel@kernel.org,
 djbw@kernel.org, yu-cheng.yu@intel.com, baolu.lu@linux.intel.com,
 Jonathan.Cameron@huawei.com, coxu@redhat.com, andreas@gaisler.com,
 liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 geert@linux-m68k.org, shorne@gmail.com, jonas@southpole.se,
 stefan.kristiansson@saunalahti.fi
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-11-yeoreum.yun@arm.com>
 <c3edfb13-08ec-419c-bc05-8f3f64186b24@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c3edfb13-08ec-419c-bc05-8f3f64186b24@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E4EF2140015
X-Stat-Signature: baw967igkodkg8yibawjzc4juq4wmzet
X-HE-Tag: 1783953701-668155
X-HE-Meta: U2FsdGVkX18VQihnBCmi2KGYk/H8m/MId81QSBEHEDRzUXKGpZFf30q8uT2WtZxsz06CsnJV3FLfGbpp+VSGzu9nQ3WQajLLYr8RBTCqqTt5ijSik8zdGGdK0xnb9H/YrEf9ygJw3//UvfSutw+lddJAbffJ6DVaPEiq1UQ4awN19RdO0NetwPfxkK3EHrDHWMgCkr4zu2YK8UblXK8aIFcwytYOdVJ1mLmNKBzxNglwrmnQqGL7Oi0lRDGRJsCMIUrUBrKzzEpqXHNFNxtWt+9Ljvh3MJa6dLSQnaViwNxpeKTELtsR6z3jdq/RHVfptrBdR013aSZMzR/j7SEI9BbZ7UQaF0HeUAxKCAkTllelbFDNQCfCvzpfkDPR2KKf42MaR8lBTDi9NyKWgVbaIF/HZL6UUCnkdaGtPfJLWjf03iWhfkPKi6Gwm0YqY5HXfbRBAQ3WYM3suQsJVCZPWI26HBq0PNI2Hp3BQYncFOMYkLwLwvO/EnPTZmWJVibLjD097IoYo5B/fAc1SmHOBdzWVkjcknXXOPJLOh4ZGAkJrwV+sHmWY2yk5qova2QI5n+aUdQAKtlmP9LIGk2zMQkj4USiPTA1bi3GerPAexsSWfYeWZAxSCnyI9DXk/1NImXpCzl7KsHzYVi3UPKSQK2BR4s0Fx5kB7Wec1f/nd0qQDntXMf4srbrXWnzpS0F4U3KzUoWuvdriengbk/1Hfi0wHSFrGgDmjVHGtL3GmPhLrdhbubgENyAqxsiNgYJUudT0WSSpkTrNvNkgYFk+rGA9NrCTBRsfw21MnGUFEBfO41hNtHQBs407E/XztWQGKtfIlDZYD6SUajNZG7CGqOMaKlWQvMj7NbPri34I/BB1rDzOv6dSRXeBzIe2p301AWin8HiJLPXhKDdh1YNVbQYXoRoHs5+rW/D3ggjUUhleIy2VrBS2UwzqOi17rw4hcxZGrRlKf2PJVawp5N
 BQRYHz9L
 8cE4wMr1BV1BkBYcsgLrllzJtY/MQkuGdN+D3dvjW9bYSjWMwegD3yi1AZC/B052/olXb5rQlW0mSYVRCq9vFJiMKW525eDzT+kTVxiRaeIeGHojqEk8Dv6UOsA9jATz9NprYdWRRuEaGbyY1twCmYRySf9xkvgYGZfPUsLoyC5U4ssQN9Xt2mmIZN8glYYUTPve+d7R2clckaje+sedYEdMwClTG9X0o6ePC0xntlIz6oNYpYwL0vcT/YrxOt8MdAhMG+Mqgm8UIMZTShuGxxMTPOjcCSJzzx+liU2w5QTOMwiVhl1pvPcogT+dpDvgzpKJeu4dfdKYJuXknwkdJpAZ8epPDsN2EALstFKnjEji3TNUzEtjEQrmNBxJSNwu1znYE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 16:19, Dave Hansen wrote:
> On 7/13/26 06:55, Yeoreum Yun wrote:
>> We want to change how pXdp_get() works with generic compile-time folded
>> page tables. To prepare for that, rework effective_prot() to ignore any
>> folded page tables entries, as it will unconditionally get called by
>> ptdump core with pXd_val(pXdp_get()), and we really should be ignoring
>> that value for folded entries.
>>
>> For this, identify the first real page-table level and
>> update effective_prot only when the current entry is not folded.
> 

I'll let Yeoreum comment on most of it, just one thought below.

> Nit: could you please clean up the "we's" and move over to imperative
> voice for the series? We're picky about it on the x86 side, but I do
> think it's generally a good preferred practice across the kernel.
> 
> Also I really do think this made the code worse. effective_prot() is a
> pretty tidy function. This change more than doubles the size and is also
> basically the same block copied and pasted twice.
> 
> Further, this does seem like it will stop filling out some of the
> st->prot_levels[] entries. That seems like it might break things. It
> definitely needs to be covered in the changelog.
> 
> So, in the end, I'm not 100% sure what this is doing. Is it "optimizing"
> the ptdump code? Or is it preemptively fixing code that will soon be
> throwing a compile error?

It's a preparation for getting called with folded entries that no longer
duplicate the information.

Otherwise, with later changes in this series would break it.

Essentially, we have to teach x86 code to ignore levels that are folded (e.g.,
pgd, p4d) and start collecting effective prots from the actual first non-folded
level.

I was thinking about handling the "don't call effective_prot() with folded
entries" in ptdump code, which would likely be cleaner.

We'd still have to teach x86's effective_prot() about "this is your actual first
non-folded level, everything below is not initialized (or we decide to just
initialize it)"

-- 
Cheers,

David

