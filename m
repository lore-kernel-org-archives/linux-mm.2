Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7723BC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 540456B008A; Mon, 13 Jul 2026 12:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EFD06B008C; Mon, 13 Jul 2026 12:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DFAB6B00CB; Mon, 13 Jul 2026 12:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE3126B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:21:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 164EA1A01B7
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:03:06 +0000 (UTC)
X-FDA: 84984071172.14.C994D5D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 53D2C4000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:03:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bnBSYp00;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783954984;
	b=I5hyeqVe/SL3Br2tK/KumqtAM7ktB6rwiPYxMdCdwb0SPYuSfGh2ZTyRChYLgDqOzzaroQ
	xAs9QzwVqGqLNYPzJfBG7FQ4fWU/su52WeSzX2+lFvzxPYi8eqVye+bQ7GY4HDicz9miG8
	1thQIrn/LjkBX0brwKnDDkZ+Nz0B208=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bnBSYp00;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783954984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6ZbNayKCIILAdZJps9dKBEVAzzMJHZQIgylB5LKsr8=;
	b=vgVYCXpDeb8cth1hla3WoJZdOy7rrDCUt30QnJcpjWqXrbe+5rGlmfvqaGvsttpPAfQ083
	Yj2P9obuf5vDenrNBKGQpCK+TWbQpFswIAgGwfbdsuE/xPDYRfdyKpDzboDEJSqJe59ukq
	BEgX2N1QtIyLyaeeCbppqft0+JElNjs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8729860103;
	Mon, 13 Jul 2026 15:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4CD1F000E9;
	Mon, 13 Jul 2026 15:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783954983;
	bh=F6ZbNayKCIILAdZJps9dKBEVAzzMJHZQIgylB5LKsr8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bnBSYp007P3L0wbtoXgGfxFvsLp4tsGHwrC12gp4KjH6ljYnZ0RBjSDF5M5pnmvuO
	 IQJ3Rx6RBpIm+JzkohNZdbqCP06ezF6UpF9zPwHoSJ1Xd6U4rZA/gMDAY2Jyzxidpm
	 SZ1CXfJ1sjFaRFFkaGILplnO6B2e/EQs4RpQTDDK/p125mtmvZMGUUCctk6maQDOoq
	 2TEUViz+2i5GU5Vyz0mqub2TyjXhAVzJNdZS7MGgEre0oapyl/ENAR2FRfa1pDxghq
	 Rn/FbvCnr5Ng8YtNdBVy8Q/nP/TGA4Wfj3GvdAxYMjX9e6ab7HmcnWA4c2XqyLdr/e
	 fBzLU/vO1pLkw==
Message-ID: <6007625e-c3f9-4ad6-99a8-61396bccbcec@kernel.org>
Date: Mon, 13 Jul 2026 17:02:47 +0200
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <710b7eb0-8e0c-4f07-991c-2285c77e1beb@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 53D2C4000A
X-Rspam-User: 
X-Stat-Signature: hry9foxinn1mhi8jk856ii9z6zmgrzho
X-Rspamd-Server: rspam03
X-HE-Tag: 1783954984-113254
X-HE-Meta: U2FsdGVkX18Xe/Rx4ihRi0JoLW+g7JuQ2Gc9tk+k1Q4BR6wBpPtkyGDGvcrtOVZrpLjw5JB0ROWjM63NN9y8xkLSaDDBkYCI18TG1tK3T9kvIYb5uNv38XU3njBQJDc2AYPWtEnOZD4I72TVsfVHkbMKg0DSHSY4wy6uubH4WXPeTmzlBohZZeLPFg+YxEFkPPdkPRwEV9zrUbls0vv0M5BUYaIryr+tsn3C5JvdqWlbke8tLWWbir/ypJzekgfSgOg93xtuXWvN6H7xqadsRltgq2uOXdkGe2Eo/RXXp1Bu/cMkqFCz98HFhNs3KytYS3Gy7jtv5e6ECICk3JTyQ0IWP90KaMgxFFXOQPe9GipVRLQ2jVO0tbpK2g4gRdWQkRityTIzIxBjV5Bc0TTRTVvzIsfLsG0EUA6fOWzQWeDFQ/fayCgplSae89BqVfQGiqXJNTVrhdt1UkusFpl2d1nDp5vgeJRRaFbMnOJ/1ZUTxGqmy0nKcimHOfXNiva7X5NHwVJk+BRbhj6viWnV7VV9ehLd9r8y3bpemVXJjxCwYBJp6JYNIIzamjNzEswV2S6tAyoSi8qdOijEOIWbTdRtAmkWEy7lnj2+lVWIKpkyKUMa4fd+GYYnOk3aR4qoVDYGCzvIZrGWBuSv7Zj4BpMuCfBwT3jIpzwGja6kSrbt8dcofV49eVKgcosk/NonlNq5ui0Up34TeWpS38sg5vWQ5wlcWmy5gXhwDmn5OcQjo11pzMfwZuWu/KCGA7vmJ8oJJ7YG3QzUImImsVq0YxHqWmH9tl5IAuSDA9A1uXio3fwnoBP/ZTppirPiT3FGR8ZJim5SCUnkwR0l3kT24RlsfUzoohe6p2iEC4f7tTQgJX4ILZN8cw3VJr4kzwE8Cdg+0XHpmVkIj2HsGAucOFfY32j6Bj1JaAfvL5Mf88f6mw29kLoZvalGOf30OkHeKU/1Zfa0JohDoIUpS1E
 Yvw33ut2
 pvnYwFZ87vDQDzFkhxxhxOA6cgR1aMmIanxlezsow1UMp8sm4y6PYo8D4BVW7GCG8IzSGBsYizNl7Hf6Vryz4LwUuvQOAmiB9HsWndDiUTn953lAMAH8UzaBtRv7OtxsPyh0gkFeaBNaqVu50yepKq355uPveJ6U7jdX2T3UUZr4yBfmBaFCLxbu89NSDxozc5fwuzOxMFhYDscwgTjk2IyyHsPiXLOVUuVgQc2iNwoYydr6Q4aYWIYIeWGk2QDWza7CEheaE0OodNRqdcJRvJi1LykLM4YXa0E6oF9R7j7NlHVN9XjdDx4/+pmURHtwtDeqmw5LvBXl1jA7/EkBHyzdWZ+mpBulJWKwwiRjkJsa3Z7TD0bq83ytPPnra/YPwWcoO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 16:55, Dave Hansen wrote:
> On 7/13/26 07:41, David Hildenbrand (Arm) wrote:
>> Essentially, we have to teach x86 code to ignore levels that are folded (e.g.,
>> pgd, p4d) and start collecting effective prots from the actual first non-folded
>> level.
> 
> I guess that's what the series really comes down to.
> 
> The model is moving from (using 3-level PAE as an example):
> 
>  PGD => ...folding => PMD => PTE
> 
> to
> 
>  ...folding => PUD => PMD => PTE
> 
> Right?

Not quite, because it's complicated:

static inline int pgd_none(pgd_t pgd)           { return 0; }
static inline int pgd_bad(pgd_t pgd)            { return 0; }
static inline int pgd_present(pgd_t pgd)        { return 1; }
static inline void pgd_clear(pgd_t *pgd)        { }
#define p4d_ERROR(p4d)                          (pgd_ERROR((p4d).pgd))

#define pgd_populate(mm, pgd, p4d)              do { } while (0)
#define pgd_populate_safe(mm, pgd, p4d)         do { } while (0)


It's always been the latter:

	...folding => PUD => PMD => PTE


This series rather enforces that the latter is used consistently. (e.g., not
working on pgds when they are actually always look like present page tables)

We decided to go for strict BUILD_BUG() on set_pgd() etc. because otherwise it's
just waiting for trouble once we change what pgpd_get() returns.

-- 
Cheers,

David

