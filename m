Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 368D8C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 15:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36FFD6B008C; Thu, 10 Sep 2026 11:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3489A6B0093; Thu, 10 Sep 2026 11:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211B86B0095; Thu, 10 Sep 2026 11:29:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EDB106B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:29:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49AE9A05B4
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:29:49 +0000 (UTC)
X-FDA: 85198237698.30.811D938
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf12.hostedemail.com (Postfix) with ESMTP id 792CE40008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:29:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=k2egxiLI;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789054187;
	b=uOIws21P4Ss2z2WxBBa0lMIVw3oQVO99yo9gt7q6P8qvweTc6WpOHjEECDoivl9HlcCkv+
	AwTQRpAJFX9RDsxHa5EwV3E5HR3pU7qq99/NFUNkMvGBHKfGZglpt8iPyp9YmgglHTBfoK
	MX84EX5rp7AHq8AsRDnfRToi+ZaU9LU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=k2egxiLI;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789054187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g+Y4FVluhJPEyKa8MIhZ+TvknJop9MgJLcSyMNBT04o=;
	b=owQ8qADRZzWuSQsF8LVoJzRxS1Zzm8N7U+txolndaokbmDkO/Cz+b7KZc4OwrBWi6IT1ra
	MBUBGVNomh1PEE4utweDtZXyNPsxL0RUOW0ZAFYpEG5k9ZxED+vf4MRRd0X8TZc1itZweF
	vc/yyaEkYsKMs7eLreAC3XnIuCRDgp4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789054186; x=1820590186;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SFcUASuvlDRtE2C4hK5s4ZmzjFE6/W3nNqwA+OR44zY=;
  b=k2egxiLIxOiBR9RNUCG9keDbzF7F1l5fuFxQ3z3Z02qJkD4/wOzYyzku
   KCm/TqJ+AEiK6ScBJNIzBUv/BSh4UBUp2cS53bU7Z38CQ4Wz+cq+s5Qwc
   w14kqgDTHecTdD1fq5KczfU2BOY8Zh7BHbJ0UEsZ9aU+EhGOWnZBgtG5Z
   DvpzYCdr6LJ0QNkHSx+uApj7858h1a0mIsONcQ7g6GonCPKRH/CxjGYXd
   Tzc6nKpZRar23SUeTAZ8tWwEMceS0nKPoNWSf3+UEglKhq6gAupw5ijm4
   hZLDkkCz/vcOFftFKz3I1737Qq7JzPoZGJkzaQl7PlItzUG0lPEUKIRei
   w==;
X-CSE-ConnectionGUID: /pSunOhUQlKGDjRZOPfbbw==
X-CSE-MsgGUID: CaDVSoRQT2qBV0X4/TyCMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="106875861"
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="106875861"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 08:29:45 -0700
X-CSE-ConnectionGUID: 8Dukv6vfSb2j1KuCmCzgkg==
X-CSE-MsgGUID: XenJd8NISqWyB5sRR4Bqeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="270317323"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.111.208]) ([10.125.111.208])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 08:29:43 -0700
Message-ID: <c1ce8e10-e190-45b4-b279-18f92aa4029d@intel.com>
Date: Thu, 10 Sep 2026 08:29:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 13/21] x86: mm: use pgtable_level enum in
 effective_prot_pXd()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, Russell King <linux@armlinux.org.uk>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
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
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-openrisc@vger.kernel.org
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
 <20260902-dummy_ptxp3-v3-13-5d8f5b17c25c@arm.com>
 <8f3979a9-238a-4d7d-a040-6aa526fedec5@intel.com>
 <aed03085-1d9c-4a26-be9e-196c3ea941d1@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aed03085-1d9c-4a26-be9e-196c3ea941d1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 792CE40008
X-Stat-Signature: i5h5qejed49qiwetm3e6fq1n8b83g4eo
X-HE-Tag: 1789054186-136030
X-HE-Meta: U2FsdGVkX1+Do3RTn1wfZw2v9izMKBSfCX541XnvlsyUcSDIX0gKwPusod0p3eUmyNPJBcv6ARjEIKfCBeiTyE/XwgaPZAx7NhTCteNjZqgQGEgGtQAGMHsCHWewTIBNTbQtK80tuH1f40NzdYPKZvsiLN8P0CSpWCtEFcwX/AwvG44IHSRR8RmwPa4q7CWfoSTYoc9YZnBFItefIYJjton7aqrPLNDvFMc0hFAHuOSA3ztp7rxyJTBQfvZY6rwSrHCfFD00vHDf/76inWbTdqGv1fD9xakihQIU/PG+i6w8Dhb2oe84c9YP7JCNjYd2gNWyLvjAcZia2iw0YCDQL63PGXif526DRBMC+8axhjxdn4rWtpJBTek9l/Y6YZulMFZUQHALl8fR7WUzuVcqJh+u8k2jwantZrPPnjJ9SE9VMMZay6ysdblPdNMEpZLLZHQCOTGYybqlrKP9Es8H82PcxBx43j8PuiKHulmG57yAcY6G3icw3u6qoRqQLYQBFudQE4gGC021/1k6X32LaZLveBQietjhTk7fhrgc+l9K5T3LcM5Q0sxu1VllFtK6GFfSIZS+AdUUan6aDel1xBFVO3khau7+0o00a4qeRVVVCEv+zKVB8CJgRqgaveBoYescYsMEOTquVL3TksHHL0m4OkOzbeWUbCeC+MmtOL/9ScqAehxC4e1DKnYErqp7NhqwSAMXQaI9dtJLIzT5hwM7Nxa3EFFV9awDVCBheS7XxfCi62ndojdW8rfkaALSqo0eJ8ex47hgjPb/T+yjFexPnUYrJ9e6vKotVDLgyN9NUnTZ4ykDcwmVnQ/+dwk+vRMZOZopR/2G8F5WKRhjPNrErbaUEPga8wW18LP0Go0MDhGo0caQwauUu0WmiVaZT1DFMHK1usyKABrMmpQKwHfnYAPUYX4NT0RgSjpI9oINYwiuy6DMZQ0ZnhKHX+dagzhrTR1TAPlMrn9mSDy
 JcMzKJzq
 2mNXy1iYNeFFtOPMl/iESY7GEijr8FmEb73KjbeHj/c+Q9Ng/kJM54pZJB6BzKXI3xOjCvsvztAkNkCr0nZ6V/g46RhDLFc7ynTQ24pNK1EQnPSTiuYtGxR0frapceYSXxld2UjWPOOH+O6uMvkgbygxCVOt2Cjs38Rmez9QwvJxd1x5F3or4d8IXEcsBwRrnJurKkPiBqN6gVpv59UAo2wgYUYtZmszPsyX47PeqcKCCoKnpdDKTNgtfYLbVYEGDvvst+gAzvifs/z3uZwmvl1jmDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 04:02, David Hildenbrand (Arm) wrote:
> On 9/2/26 22:48, Dave Hansen wrote:
>> On 9/2/26 04:56, Yeoreum Yun wrote:
>>> Instead of using hard-coded integer in effective_prot_pXd(), use
>>> pgtable level enum.
>> Does this actually *do* anything? 😉
>>
>> I guess it's nice to have a wee bit of type safety from the enum and it
>> means that you don't have to *know* which level number a PUD is, for
>> example.
> The next patch passes the value to mm_first_pgtable_level(). Not sure what x86's
> preference is to spell something like that out in the patch description.
> 
> "Prepare for future code changes that will consume the generic enum
> pgtable_level from inside effective_prot()."

Yes, a little "prepare" blob would be great.

Maybe even explain that generic mm code uses symbolic names for the page
table levels, not integers and this makes the helper usable in this x86
code.

