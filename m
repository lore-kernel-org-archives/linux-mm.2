Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C206AC5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56C976B0092; Mon, 10 Aug 2026 10:07:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51D746B0093; Mon, 10 Aug 2026 10:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432A06B0095; Mon, 10 Aug 2026 10:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22FE36B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:07:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 905B5160182
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:07:57 +0000 (UTC)
X-FDA: 85085538594.25.9FB6F95
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7F8E016000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:07:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VDMFqS+F;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786370875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/l2H3T3xXRxtAlEmVxkMBjt3GQq1sSw4qqDUaZjjxc=;
	b=1Spdu3nTaFJ6duQCr0mbWwHhODRUMCzcXM8CpVAts/bjKk/8SyDrc4hcsGXGIS+t/MWdm1
	g4WyD2jtrC2uQf4E3UcahK+9QvIO4cH7OkPNkcUEmSyMy8WvOcS2T3oQzbV/70wdQOb5ua
	6PFDUc5Nu+rsom3/6NKHDBPqPBbMy58=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786370875;
	b=4ip+umvSGbO353O6vDj2PLFULxhSPbf6BM7096MA9mukAqqXJnND/Bb/ZWr98ijBJkzrp3
	KMNxJO0GYb567Vxz7dX5/rQkLtB9A17URr/At3It0g0Q+bQ2/bD8+JmRpGL18Lbp5VIMQ5
	9vtEofqW8Wo44og7DjeTLugZrZCDOY8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VDMFqS+F;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 737BD14BF;
	Mon, 10 Aug 2026 07:07:50 -0700 (PDT)
Received: from [10.57.5.211] (unknown [10.57.5.211])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0B0D3F86F;
	Mon, 10 Aug 2026 07:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786370874; bh=l/l2H3T3xXRxtAlEmVxkMBjt3GQq1sSw4qqDUaZjjxc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VDMFqS+FI7dztumWUIj0YSzO03RhoFJUBQIQzYUdFvqVl9cEv8Iw/mDKNo7PN1C6X
	 1VHMihPE5KmCMT17k5n8XBwRp9N9Pbg9cGBMMV/3LzWSgApFGs1tQxNrK6u2zmk9z2
	 n2fKbvDMQjaTvkmApv2yhkGVWehw0StqDsKzTy6c=
Message-ID: <efd52893-bf66-40cc-a53d-980b89cee448@arm.com>
Date: Mon, 10 Aug 2026 16:07:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/22] mm: introduce MMF_KERNEL flag and set it for
 init_mm
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
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
 <33fc9d31-2866-4315-9510-0004deb93994@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <33fc9d31-2866-4315-9510-0004deb93994@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7F8E016000B
X-Stat-Signature: wuh3op6ybzcnjsmb9j5761xc1jehdsjm
X-Rspam-User: 
X-HE-Tag: 1786370875-739851
X-HE-Meta: U2FsdGVkX1+LGrIQlWeQNGwCCA4GWcCcwerXPTTU8UWacsE1b5fHk6KqtA7AdeQqknxxx5UvWygDVBs6gvwfj9IjTd7GZm+2PsyRz+Zrp36GnLy5BLBQnyjK//UqfMMcmSRosA2qPPN1hPal/s2xn8Zd3NtRNQZICuN01ZdERVU2xi/SGkqZnBDfgabroZyp62RDeAyy0OgtMUVl+AztRKPxX1MoMJtrM0sLseSvovWm8ioQQEcCfnXrfmdz8zWiKMwKHQuaRB///eHFljkD2WsRT1agNpK3wHVS8sG4dbUub1kV4GChAh8qNW34YSnOvIiB5yStUfXPfcLBxDZ/hPM9ISUyE2IkJKhS10DKFWTtdApnsXx111Rh/TzfCRW/v1MOhyENK/+Ohs3fMaagNKVEBAyJSpb28TfNu3UFTe+L2sEOMXZqtuCBMaTCpzMpfc1dL5s84dQCOMQd0G3rCuOLyFnG8V6aJob4OPRFCiGMIPfXq10SUIxOqh0o9DstOgDOwSvTgrxrYNgFd+UzpR/tMAeLDYze5FAdYpZqS3qtdyx6h7zpnFvT8pyiv+fvE0YSfuo/r+Qtf2SnwzzV7LvZkVJHNeYBlCG4EAPErZ0ccAxC8iJxq6iS+qOVfzPyYZ8jmkD8ECZT122qfCWOS0kg+0DmV3H2UfZz5jB1Y1Z7hJbIBV10GyMydSXlw8kAKxee4pQUlCgJVs3BTbokDSUXFGXYAin4R1HOgjqkQEU4p9RR+9XHmke/7Qwq5zHuNlB9ep3iJEhrm1P+IgQLQh18izKvrD8g57/93Hcin1WfuC/u6hgnzaZ9ZlDtNcBJWNxp2WUVKo5CRVM55FHLsSoR97vpAeoHootZLfthLH3DlHZUvbuytBf0ngXfm+LBJNkkzcXkptrOXMDoAab0wxg6UFbK2pMZOpBB3O9iWcx3IEVcCA0gPj9jLYF8KmU5+hF4xv+KMjw00gfqBCP
 xsDuLRf4
 NEdOZ7WNBudEmbae45d1EHTOgOJtEmu56NF//pU3KfoPQPsDQvtEg8kkZtjkV/g1yEMQNDcCb143vC7fXw32eSvk15lKZO1/s66OMTVQt5x2gsdYb5s60mZOiMFIjjR+w+2BSnUSIPhd4qVjMHFjQ86qkb01C2Lz/vkhjq6e1weBLbFae4OUmg0FiGYgABRsmv9Eo04M4P432CkBsKhN34dH2XPR3T3Qzmejpo1I7AJpCH0+RdUMSC/gv/ZSdYTYt/hy41qerSQUuD4wgPaj98JCvXTk+ZC8n24+BJH/X+0pN2NHHP6E57yVFHKuI0skhUAPlGLoMNie12r6frqcMyTteZrZE56+FhGet6PkMOS1x4iyCiy5LV5tD1tjVPdeqmHxr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/08/2026 14:07, David Hildenbrand (Arm) wrote:
> On 8/3/26 15:59, Christophe Leroy (CS GROUP) wrote:
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
>> c0014048:    3d 40 c1 09     lis     r10,-16119
>> c001404c:    39 4a 03 98     addi    r10,r10,920
>> c0014050:    7c 03 50 00     cmpw    r3,r10
>> c0014054:    4d 82 00 20     beqlr
>> ...
>>
>> After patch 08/22 we have, it first checks that mm is not 0, then it loads the
>> word located at mm+528 then AND it with 0x1. This load might be costly.
>>
>> c0014048 <assert_pte_locked>:
>> c0014048:    2c 03 00 00     cmpwi   r3,0
>> c001404c:    7c 85 23 78     mr      r5,r4
>> c0014050:    41 82 00 10     beq     c0014060 <assert_pte_locked+0x18>
>> c0014054:    81 23 02 10     lwz     r9,528(r3)
>> c0014058:    71 29 00 01     andi.   r9,r9,1
>> c001405c:    4c 82 00 20     bnelr
> Is that a real problem, though?

I doubt it, this is a load from a fixed address and therefore highly
cacheable/predictable. At worst we're keeping an extra cache line
allocated, but I'd expect init_mm to be already in the cache most of the
time.

> What we could do is to just keep the == &init_mm check internally on configs
> where we know that there is only a single such MM context.

Sure, if this provides a clear performance benefit on powerpc or other
architectures/configs that don't have an efi_mm we could do that.

- Kevin

