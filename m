Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3DC4C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 21:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C84C76B0088; Mon, 13 Jul 2026 17:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C366B6B008A; Mon, 13 Jul 2026 17:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6DD6B008C; Mon, 13 Jul 2026 17:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 72D706B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:18:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03A98A00B7
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:18:07 +0000 (UTC)
X-FDA: 84985016256.02.0228923
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 270C7C0007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:18:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NvF2YMXG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783977486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7AP6vL/IknWnMrMEhy8oZzGqoRe/qZtcpIw0uJFVyX8=;
	b=EYSgROwnMB3ZHOBNGUTjnf0rJr+fXyWSlKuE0E7DrdyIn2uglWQb5FAXRt1XLR1wUOMu2G
	uH/Wom812/PHrhhAjjLj2EgQI7+XUjU3+Qz1NtCR4Y4Nd+/nJcegPqyKCBPrGS66muu4XK
	3d7t2SrRkx6AEBfovXHi7NePIZ9uANQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NvF2YMXG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783977486;
	b=vkkbVj40jaMjv9uFOGT7HTmq7Xn/lFuJfC/bQrST4mR7d5lMsfIBRWrA8qZt/GwDNfoVxJ
	zq3sNbYKuL0BEyAZCu+kKEvyV4Fe3Ve211mI4o96ZL0RMsmUPuxm1nhXPbby8vtjECKnIe
	rs/zWqjq1SNqtPVCSvBexhG/tIAf93M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9406B40657;
	Mon, 13 Jul 2026 21:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC2B1F000E9;
	Mon, 13 Jul 2026 21:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783977484;
	bh=7AP6vL/IknWnMrMEhy8oZzGqoRe/qZtcpIw0uJFVyX8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NvF2YMXGsrh91m0Utx3mep+raAJ6w2eAV20dIZ2Vceh1KtH0lLgRsZPiRwnxy3ziE
	 EhHLOxDlPyLPcRkEsCFjqbxTQoOJlyTG5u8omN4r7c2/S/zFQ7tv7gpyEb2CF4M7JR
	 6ipE7uR1d94f42i6B+jK76nR4i9J2CFgqVPOzc+lR2jFGfZVbKxZDiMN0XA0k1Jc/O
	 2Lv5a9w4YUeFP1Lqm5Ult/7gJZrmH/pN8DncPc3gl1kQwfVnFrjZQcYcx2fK0DCDLr
	 DGwppflzLVmoQ2RgRZuksFfztRqvsQ6RK3KDcFAX//ZN1J4BuvAEHDd0MqBIrxE9Pu
	 INPh4wS7oJaUA==
Message-ID: <31988089-095a-4eed-b5e2-c677c70f79f6@kernel.org>
Date: Mon, 13 Jul 2026 23:17:31 +0200
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
 <ac365196-8ccc-4d8b-83d7-28fec763e75c@kernel.org>
 <710b7eb0-8e0c-4f07-991c-2285c77e1beb@intel.com>
 <6007625e-c3f9-4ad6-99a8-61396bccbcec@kernel.org>
 <32d459d1-ad19-4baf-bbb1-0565458001d2@intel.com>
 <3ea30f8a-bb29-4bf5-8400-1c4840d46a88@kernel.org>
 <7e84b200-25eb-43a6-b5e2-5f27f2d82a77@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7e84b200-25eb-43a6-b5e2-5f27f2d82a77@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 270C7C0007
X-Stat-Signature: 6tzh6uae1bor7aremufh8nbi9ch8mwbu
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783977486-164927
X-HE-Meta: U2FsdGVkX1/LRaaiUN2Hgwsn7SjwrH49fSaj/SHCe4ETKdysV40lzNAvneGKip+HhAa0O9Kq3aRh/ieJy8L8UNzTW61VvBL1lLH58Fp8fiJS9el8niDjuBwdUKfY1Iw6ZTPvZeT53p742l8E0xk/c/0jMkG27CFfQzahAgmTCJfSIT/91OxQEJaN0zTDdFlXSJHrCf2bfWrsrAO2k6FyWVrF4QJd0KqpD7m6WTnjilikf36QKT1UNsfsRhcxnXJZKBl1BvPyE74sVoclqTFdrSo8dxKUBemPuYnQ3dc2ky6ZM3hWGgghwqmwnnPp0WpZbbyFskB6+o7fE+qE75gMW4yHkwzcxcPq+tdyqLxk8Gl6uQVDIGRwqadxtw45C8OyKymthbwcT32WgmEd8iBRsOn1Z8tkgZgspt6+aoMsCj23iELg4OAQvyCOYok+TWhESr0pS579Zs1x3QENBReMCumT8b35r4oNNEMSFjzzlqlc52Cyz8NTHX01gIsiUTMRYxz0NSIAM2H7JLMwLnqzgsycvxg0BMQvSbKMx33fkeuhg13UgkzpKtCwzaIzylrjhy40h5n0F0JW1EYnbmqxGeLKZPiKMkb6eDrL/A8AJwgNZTNeWsdwyGsdnlj+4IkU3FMNrn9eOJvzEyDzNEMsq97OEdb5YWIIX7H53Asn30TQWosbxpZAtUPQgjMhZ/lGGdVfuue1NhV+e9JX3uVOp/E8zqo2R4LDcpXFsKEUO/IsTspqafPLCY5f5bY/n/IODuyaWAcQ2y2MaQrzcdin+WMS3/PAD4ZtHnsUdjNtzM0hd2el9YYdBMD+kXJ1WOMRmhPfcoaNi7M6o9jg2CLiLOVuHhIJsaCItDffDtRHSQGozJRmCmDgw8s3nvGYGTwQUQOA0T358wgbj8LQj+Vf0Qfg1VyWQglPWkKr0NHuYhSux9BQh0wh/jPft3TQoAZDsrTq766H+Sq+a72TTKe
 mbp6q8TK
 LSyW9fJHfzWoQSEQri4VnadEKz8buM/GvZqCmHNV+xSJJtY/qoo5BYVF4d9RhbhBnluYpP2cZ82OJv+lrHkRrmuEwGW+NYItFmfad+7MqyPeiNC4UlFunZ1FzGmsKraLsEhngG2Yu+NJk1TDEvfvJCXCKBCwyQj/qzaAvTThLEfuaNx74PXIkAt0F3sp4jobnBTfWzI5TzZmlXZ2KxK+Mbcj8+bfOpk+48evq7e3OkiFwL2LF1TbzwKgxqbU5uc3JHLaR8Sf6LVNNRHpmLEu5XIoeCCxONmvhlurznNM1PlV67HCShubL0cwKA1HITQ798nWL+v7UhpNQxd1QTZH6QnULA2XTdhIbGgRxuGH5TbXL6zatUgooZsYb4aB97O/ZOaAI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 22:27, Dave Hansen wrote:
> On 7/13/26 12:49, David Hildenbrand (Arm) wrote:
>>> I really do think this series is changing things, not keeping them the same.
>> Looking at it from that angle, I tend do agree: it further moves into the
>> direction that actually the p4d_present() carries value, and the previous
>> pgd_present() is just a dummy.
>>
>> I can see that some more work is required to untangle the mess we already have.
>>
>> I don't know why pgd_present() was made a dummy function and not p4d_present(),
>> but I'm sure there is a good reason to it. Changing that now ... omg.
> 
> Yeah, the p4d addition added even more wrinkles because it was the first
> time we tried runtime folding in addition to the historical compile-time
> folding.
> 
> There were certainly some ugly corners of it that we never found a nice
> way to fix. I know Kiryl tried pretty hard.
> 
> But, zooming back out... I don't think this diffstat:
> 
>  31 files changed, 329 insertions(+), 206 deletions(-)
> 
> is nearly justified to eliminate one virtually guaranteed cached memory
> read instruction. "Unnecessary", sure. But, worth the diffstat? I'm not
> quite there.

Just to emphasize, this prevents common code from being converted to pgdp_get()
and friends, as it would make folded page tables more expensive in other page
table walkers, and other arch maintainers rightfully complained about that.

I don't want to be stuck with this inconsistent mess of some common code page
walkers using pgp_get(), while others are stopped from being converted due to
inefficiency concerns.

*that* makes our common MM code worse, and it grinds my gears.

And I really care more about common MM code being clean and consistent than some
rusty old 32bit code being slightly worse.

As discussed, we can keep the set_pgd() monstrosity from working in all places
that don't use something like set_pgd(pgp_get()), bust as I raised off-list,
setting something that is unconditionally pgd_present() -- a dummy -- is just
extremely ugly. But ugly seems to be the theme in folded page table land.

That would certainly be less churn, while leaving this questionable code in
place, I'm fine with that as long as we don't add silent bugs when some arch
start doing e.g., set_pgd(pgp_get()).

> 
> Also, I think a series that adds code like this:
> 
>> -	if (level > 0) {
>> +	/* Ignore folded levels ... */
>> +	if (((level == 0) && mm_p4d_folded(st->mm)) ||
>> +	    ((level == 1) && mm_pud_folded(st->mm)) ||
>> +	    ((level == 2) && mm_pmd_folded(st->mm)))
>> +		return;
>> +
>> +	/* ... and make the actual first level remember the protection. */
>> +	if (((level == 0)) ||
>> +	    ((level == 1) && mm_p4d_folded(st->mm)) ||
>> +	    ((level == 2) && mm_pud_folded(st->mm)) ||
>> +	    ((level == 3) && mm_pmd_folded(st->mm)))
>> +		first_level = true;
> 
> fails the sniff test of being an effective refactor. It unquestionably
> makes _that_ code worse, not better.

As I said, we can improve that part. But we'll have to stop faking that each
level exist, when it's really folded.

That's all this code does, and the first part of this logic could be had in
common code easily (just don't call on folded page tables).

> 
> If the series was:
> 
> 	Subject: Refactor page table folding in all architectures
> 
> and we had a discussion about what the best overall thing to do for all
> architectures is, I think we might have a better path forward. It would
> also be a smaller series.

It took me too long to understand why a "nop4d.h" file defines PGD functions to
be dummies and assumes an arch to implement p4d functions.

So yes, in a perfect world we'd rewrite folded page table handling entirely.

BUT

Let's focus on the real problem:

Common code cannot consistently use pgdp_get() etc. as it harms configs with
folded page tables.

And that problem shouldn't require refactoring/rewriting all of page table
folding at this point.

> 
> To me, the double READ_ONCE() is a non-issue.

To other arch maintainers, it is!

> Having a nice, coherent
> page table API in the kernel is much more important to talk about.

While I agree, we are talking about avoiding degrading folded page table configs
as we make common code more consistent.

I hate our folded page table code when looking it from an arch perspective
(common code walking just works), and I agree that it should be improved. But I
disagree that it should be blocking of core-mm using page table getters
consistently.

-- 
Cheers,

David

