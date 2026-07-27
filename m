Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1A04C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADB056B0098; Mon, 27 Jul 2026 11:02:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8BD06B009B; Mon, 27 Jul 2026 11:02:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92C6A6B009E; Mon, 27 Jul 2026 11:02:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 579C26B0098
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:02:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E46064076E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:02:20 +0000 (UTC)
X-FDA: 85034872440.26.06175D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0477C100019
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:02:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EMEaHSte;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785164539;
	b=EasZnHQ8nBAxngbn51yHv63aviTsWNtJBoRKBx7xiHMtKUbzykZ1KB2FpTN9Uwe4uyD5kV
	2owC758TUBbjY6ms+cld0+Yi/4xraXAUC6zJoLF/VQ4O3EAgGAqk3T1BCtPNSU9Vn5F29g
	EGpsZwa55mDVnoPt58iWB7kZPnUKhhI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EMEaHSte;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785164539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMsj86qUImXvesh2jycuBRWJLhN2UfJjZ0XxDz3JzMg=;
	b=MjalETsNwJ27dtu3y74YrKvFmCkYqysD9qJK85dyUmVvboC7MIJcFAow/hu7c5INtUARtT
	FMF4t78Gm1jSMOjMZf8z7XHfjJmtzjZOdPnonY3HVZicv3y4IX8Bjs6PA32WowZfkZeh/x
	vptVzytWJWAbMDsxOKFvsTG4pFXGyg0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E40FF4346F;
	Mon, 27 Jul 2026 15:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2AB1F000E9;
	Mon, 27 Jul 2026 15:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785164537;
	bh=GMsj86qUImXvesh2jycuBRWJLhN2UfJjZ0XxDz3JzMg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EMEaHSteJJbpefcd9Kd01LIDQkr7+ZelsCRFi8qlLdp8EguIxG3hQVRarc6ZhqX/j
	 TRVy6z8dDQvQx9ZyKMS+5c5cIu09i0mjG5la5uOtxMUKM70WYkgXpPhi2p1HL3FUjS
	 O0EF7xrwhN0LHiafD7HZCb/GplkMVcPUCJ4Moo0j1IzJ8t3zA1uqUDYBOicoYDwjGz
	 7FheRA9OYUI0E8QgC3tjwsl6QVhG7Yz+yEBYmCqXY583OP4loarW5AvqBFL9NuoS92
	 dUJcGoTl8cRskWUSlNE2n3h5/iqKYrtoK3PjmBoVCNoGrWh/TVABdE+BON+GaekUwT
	 e6I74UNRxMVbQ==
Message-ID: <4dbf7e54-a541-45de-b4b9-43ee5add287b@kernel.org>
Date: Mon, 27 Jul 2026 17:02:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 12/20] x86: mm: define pudp_set_access_flags() when
 CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD is enabled only.
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
 Stafford Horne <shorne@gmail.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-openrisc@vger.kernel.org
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <20260722-dummy_ptxp3-v2-12-d9e4bad31e0a@arm.com>
 <188623a9-dba0-4229-a7ff-5feb2ef0c088@intel.com>
 <amD9iD7rjmU__9b6@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <amD9iD7rjmU__9b6@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0477C100019
X-Stat-Signature: b1zpniezea6ihe4rd6a3nsfh13khkrzj
X-Rspam-User: 
X-HE-Tag: 1785164538-956326
X-HE-Meta: U2FsdGVkX1+XT3o4QzA7aJgJEHuR56VlGVlvStA5tRVPfxwMgy4TwiK8FoPQEPxWVUG8CIIJB5FKEiJc6uJA99l4CxbMIVj2cfZtQkqKrKTZDPNXlsrD6+QON3AVAnNj61eEKsrTYzlkZr/dDKQp2LjiL2FseY8SmtQx6exK4RyfXhE+bOoagjMlhmerIrFI+Nr7Z+sLQjflI94LFrDfnODm+ATXGAm09uk4kSo8ZNJj/2rwuQBYiinqHZQhl9lS8Hj4MfBBG7S5fqm7/AMBzSQCxqilhw7b0IDpOmloCN+eteCEdu1G8yB/0/NI1lZ5xUXio/OP/0nyoguUqKSJSftoV9MrKP3WKTd6Rg+v8T7iXyrcBJjjfBdasNw4kj3NNslXuCc8PHpNNuGHAAjPkDMa7QG/NlaT+45Eo6xzLSUZtM0XuBwiFfmjiEvRR3lo8T/HaPncA8t9fAuq9QNv/YAHlaav0mAiBSNq1PFGn82QLSGAJ66+ouTL3wf/NiN13DAMogPccBOYABrZuocMvBSsNArH7gxiaQ9HdhXGWzK8G1oesvgikNRNMwZ/nEaebccZoxGlkLsdtuvp7yD2nDFUkbhOx5L2cq6+gxZ+OSmkWeF/Q7zyLQBJY+HO6CrYM1ASuXtjZABBs0Qb5LOdb8XbynwzKhvEExrpMSwsOiq43f3VIzPLo9YXRDudNCRx5pn/Vk2VYkkGvJO5bJVwtiSqDPO++m1TrObNXlPz17L1mU6MduJXDCTNdkU3ymRWG4nyLfqDUd/yEualYOcms3wNb54h1EWurIU/r067re4phCN+09u8bm7lHeTHq9ZbV9Z46JRFTmEMCZS1ZQmftvyeBkAulaKZJobAgCenNTXPQJCmSO6Epi2ux7WGqyza+jbI/p/P5N11166G8eEA+R2ZZ0gDBje3ETceOBB4ToWbErsbLKiy92KSiM7riUvNGMta8T7GW2UnIrWLECd
 6py8pAiH
 6zUbLlooao6SRo6dO1wYC3xyc/I0Mg5OtD1pYVsJcHep8KsQ+6z0wgcwO+NxXI5FdzAeillkbgAlBJ5bAJZEju91sy9dN/gk+Fhqm8Z03TJSyR6LoVhN2Duv+bM9AkynebxEhoPwjN7ITEsYIfbx41L3WM3qUm5j57r3/z8epzGkFaJ23OzW/oH81G13MZeOMakPFIq1QIEUhNt25mOUq4Twqqtt1VFhI4vh6JVo2th+lHXLmWbAqen1G4eQF/+ZhKVGoqwkClDmcCQ+xVMoO65I7VjrUw7iqVII9b1brOXjhwoB6DKCWTpQGVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 19:27, Yeoreum Yun wrote:
> Hi Dave,
> 
>>> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
>>> index f32facdb3035..edad847a2ecd 100644
>>> --- a/arch/x86/mm/pgtable.c
>>> +++ b/arch/x86/mm/pgtable.c
>>> @@ -411,6 +411,7 @@ int pmdp_set_access_flags(struct vm_area_struct *vma,
>>>  	return changed;
>>>  }
>>>  
>>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>>  int pudp_set_access_flags(struct vm_area_struct *vma, unsigned long address,
>>>  			  pud_t *pudp, pud_t entry, int dirty)
>>>  {
>>> @@ -430,6 +431,7 @@ int pudp_set_access_flags(struct vm_area_struct *vma, unsigned long address,
>>>  
>>>  	return changed;
>>>  }
>>> +#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
>>>  #endif
>>>  
>>>  bool ptep_test_and_clear_young(struct vm_area_struct *vma,
>>
>> #ifdefs in .c files are evil.
>>
>> The changelog doesn't make a strong enough case for why this evil should
>> be tolerated.
>>
>> These are also _precisely_ the kind of #ifdefs that cause compilation
>> problems. This one is:
>>
>> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> /// function here
>> #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>> /// another function here
>> #endif
>> #endif
>>
>> So there end up being a couple of dependent config options in play. If
>> there are compile problems, this makes them harder to find.
>>
>> What is the _actual_ goal here? Saving 50 bytes of kernel text?
> 
> TBH, this came from for v1's change of behavior set_pud() where
> triggered compiliation problem with v2 this change wouldn't require.

If the patch is not required right now, let's drop it.

I agree that it's the right thing to do: just look at pudp_invalidate() in the
very same file, but if we can reduce the churn and leave the cleanups to x86
folks, that seems to be preferred.

-- 
Cheers,

David

