Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FBE1C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 16:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D6966B00DD; Tue, 14 Jul 2026 12:31:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5603C6B00DE; Tue, 14 Jul 2026 12:31:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4031B6B00E0; Tue, 14 Jul 2026 12:31:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 014D56B00DD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:31:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 74E121A0473
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:31:42 +0000 (UTC)
X-FDA: 84987923244.11.C6E278A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B5FDE140017
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:31:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iygubm95;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784046700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGNkPqfQ+3YiSeTrXQY7i4khsNfUcYyUJCaxbq5y5TI=;
	b=WgghF79As/o7bZIYiMti+TGxJkfx3Rm8CVmXABrdIxG5RrTaJ+oJW9RXbGKkjnsMxsVpLc
	/3gx03wfWqYnV6Zg6GdrPdW8L2gY5ZLI8Gy21jzJGhwEb6x3xMTFI+nnuN8Jq0Yvz4E+SN
	hO/R4q6njs3XGwMQONVG9Fucw5xaRW8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iygubm95;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784046700;
	b=6jF30zrtvFVjrCd2U8UsL4F2hV26ie8ztBM5qdgPAyMUeTGHqZytTZh8/SL+AOgDoIqHXA
	7/Ha4oIOZXbLQuChCrVtnyYz1PLXIhO+O/sYJNNc5vD1baCtEX7PlORuFrLr2Iy7ZgzqFs
	oU+h6C5bYhT5QzNX5XMLPrB5haFbO+Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F86C60103;
	Tue, 14 Jul 2026 16:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE6F1F000E9;
	Tue, 14 Jul 2026 16:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784046699;
	bh=eGNkPqfQ+3YiSeTrXQY7i4khsNfUcYyUJCaxbq5y5TI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Iygubm950SawUz4H6UdS1oHVtFGj3vmU5Xr/LNe8MPPQAgJoBBt0xoxlt4TBODD1z
	 FNNjwb9hOZ311y07/ZAftU1hQEc34e8x+jf1tf6LYhhNd3YOXl7mnW2RqmBZyY4T7G
	 wIUg312HE7PRBXrs/M9RpJL/bPN7IRFKS+RDRpl+ZcVJ1j3oJP1lm5I4awTNye4/VV
	 9g27mbKmIzZW3RD29yOpill2fYN+TUbPp7mIKoJaCEmsyGt1rlgtJ3t9xRpmfjLJnD
	 41ledS9h43TNXkoCOh2oY4bF/tj2duuTHZp8P4tYTasFzJKq1S0z9SI4PBQwBX30IQ
	 jMGJ5R/NT8D4Q==
Message-ID: <2d51a1ad-85be-46bf-ac36-18eca199b449@kernel.org>
Date: Tue, 14 Jul 2026 18:31:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 10/34] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
To: Yeoreum Yun <yeoreum.yun@arm.com>, Dave Hansen <dave.hansen@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-mm@kvack.org,
 kasan-dev@googlegroups.com, linux-csky@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux@armlinux.org.uk, akpm@linux-foundation.org, ankur.a.arora@oracle.com,
 rppt@kernel.org, linmag7@gmail.com, chleroy@kernel.org,
 klarasmodin@gmail.com, chenhuacai@kernel.org, kernel@xen0n.name,
 kas@kernel.org, zhangtianyang@loongson.cn, wangyuli@aosc.io,
 tsbogend@alpha.franken.de, ljs@kernel.org, jgg@ziepe.ca,
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
References: <710b7eb0-8e0c-4f07-991c-2285c77e1beb@intel.com>
 <6007625e-c3f9-4ad6-99a8-61396bccbcec@kernel.org>
 <32d459d1-ad19-4baf-bbb1-0565458001d2@intel.com>
 <3ea30f8a-bb29-4bf5-8400-1c4840d46a88@kernel.org>
 <7e84b200-25eb-43a6-b5e2-5f27f2d82a77@intel.com>
 <31988089-095a-4eed-b5e2-c677c70f79f6@kernel.org>
 <14e250db-1641-4085-8d13-02f819657d5f@intel.com>
 <d83c76b3-ea4d-4c41-b4c5-f5ae558ace55@kernel.org>
 <alYgMxKqRnF6_X0A@e129823.arm.com>
 <6df814c9-405c-48d8-96ea-929c4b28949b@intel.com>
 <alZe-Cu7yQw9qRXU@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <alZe-Cu7yQw9qRXU@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B5FDE140017
X-Stat-Signature: td5p3fye37x8rx341zqkgquuk8an9nkx
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784046700-352742
X-HE-Meta: U2FsdGVkX19J+bdw9/zrtqarATGqUjGQzVgwSYmA+MmGwZqoVzjyUsZN97OYZjb1zHMGllf6rvyDQdgACUl5s81qi1IA4OZ5Hx+sA5PpgWd/4S6oVtP4G2zZsD3VISgwny7MXP4kbCPYzwC5lEjoSFCB7dL04YOyrxHlo+cGRe/DJFDp9I+o5tsTeyO3CjRRvgIWlk7P2itbZoTBWSOYTT+ASdgUIPQ9ovi94/qmmTatOE46BaFB6PadF2Lvld03UoVtUWDc7Xag8fd6mEEg9b+WAz+GHOWTRFoYoOlukK7ZLntFGLnj5t4ThRwhYoulF25G0ORTxJqWltxfrJpJzkMlW261EibU6UUOoz2F2bxSTVyXdjf3zxMLS8o71gIzv++Gh6PtfgcRG8v88c3CwWVMvgikKV1ILxe0q1vqDeExpHjy9nNyYs1k3PW93XiQB2M0RXcq/+PRMjkyG69qVqqyD9rfQXqA5M45uWywsm7gUU6+Yf3krJPxfVDFzQPSnqCkpiliyZv+QFbrQErbKXo3F7ny6gNl5W5Ghck7UTBdcIXQ6JDs7kCoxRY+iZ02Ou0Lia6HWFN4tv4HFRpFb8pm7eL3mCkE9Ppb4ZaslKuBjERO7KLcLsMgDNIaFAmWHIHyLePCyL4OzRk7AKQHhGdo3gptcLadOFfGb2piCClSr+O0TymuNgQTA7RMZYu9XYaT+6Px9mcw2Vj5azCQFbngU+PIoz15/KhAEHIHBQhuynweucGeK7Lc1Z41sQILyRPvIB+pjXyrz6W43QGxReVHbrsk2xpcai/dAmymdSt0mKs6B4CH+MvyySss45NpD0RhD1zDX+eQ8380phXOSfetyYbkqjrND0BQnUXNYLIg3Kt0+ZEBXAYUOFQPgNUDO38p6HUNssyMWPBfIoOZNF0kTcsuvh9VP/ryYuKe1+RhJDIn6ROrM53z6Jt3kRSiqbVAaVmN8AUPqp9iSGP
 p7D5BpsR
 hX2lyP6B6d8hqJsdA0pVceprE7YGDuzjNVipy0LDBcXJgNZ28keXqYa0ibQnZRGD9vqc4dFsESVVNiZpINPyol/6Y/wnqTfpLy2OB9+q1CE54RztRIIL8svKr84nThaAqxJkCzIpX0XLHfqK/z7ZXWxOCb19UvKyGq5xdIZgMYWWnICk8PoqgmTsYfdG954uUWUzbTn4LpqvPkiQJZtfJgTYjQYdOP+tQpPS2h/lNT8AK45+A5WIBxZ5onEO9KTCWl1u2DhbiF+be3CPHzc81KvZn4reuOrPBEA9RjkMz9wkFR1Vd2bcVF7J60uCJ2ERGaA7nBhTn3Iz6BgqayICVkDvgnnUZNE35ORfxtCjD6dMpSerkgmoz2F1WMf/wnXpUw7lR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> This makes a *ton* of sense in effective_prot() especially. Its entire
>> job is mirroring the hardware's job of inheriting permissions from
>> higher levels of the page tables and enforcing them on lower level leaf
>> entries. If a higher level is folded, there's nothing to inherit.
>>
>> I also think it's worth taking a brief pause on the coding to think
>> about what kind of design would actually be nice here. If the design
>> really is that the pgd is folded, the 'struct mm_walk_ops' code would
>> ideally not even call ->pgd_entry(). It would just (for example) *start*
>> at ->pud_entry() for a 3-level hardware page table.
>>
>> If there are no pgds, why bother calling ->pgd_entry()? It couldn't be
>> done transparently to mm_walk users of course but it could be done
>> incrementally where users move one at a time over to a new scheme.
> 
> Agree. Calling a pXd_entry() about folded one seems meaningless.
> But seems enough to check mm_pXd_folded() before calling pXd_entry()
> in each walk_pXd_range().

Needs some double-checking that callers can handle it (like effective_prot()
would currently not), but certainly something to look into!

-- 
Cheers,

David

