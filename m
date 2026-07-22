Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB5CCC531C7
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 20:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6D656B00A9; Wed, 22 Jul 2026 16:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D776B00AA; Wed, 22 Jul 2026 16:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E65A6B00AB; Wed, 22 Jul 2026 16:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D81F6B00A9
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:22:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 012E21C0478
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:22:12 +0000 (UTC)
X-FDA: 85017534504.21.8F9361F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf02.hostedemail.com (Postfix) with ESMTP id 67EEA80002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:22:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="UbN/z7A4";
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784751730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C07OTvTr7coVCVH6Y9d+rRwSbozP4VPBHbTE6ss77ds=;
	b=sJbMc23IyhYKzcImiZqL9GXW7bOyIR3ZLsK+eLNoWhNE0c1vgJooPzO0zvFHDF0LOK20tn
	c5gN8jkHVnc8QgnAIjrgDIVeKn7uCsmXZGZhS2FTLuGr14hMvBfba542ecWryInSBYdsUY
	AwQMXugIoSau+w+zk+aJanAvrCDL0I0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="UbN/z7A4";
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784751730;
	b=xxVf6JWQAQd/6+QFviiZ6LYo7TWvaMyBJMi6mXG08btrr2XtLLWUNuqexb5GEhDz7pOhQy
	jjcvlXK8THNsKFPd10/PmNcyyZF/xSOxjXuXAUQaaeNkrX0qEOC5n6k8l0Csouu5XwYCJW
	FQwDEzwg5XxcGdlc6NoAQ6vuX84Wltg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784751730; x=1816287730;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=C07OTvTr7coVCVH6Y9d+rRwSbozP4VPBHbTE6ss77ds=;
  b=UbN/z7A4VAlcx0eGzTRYFRBrPlnh50l8rqDy7Ko8Gz8+W3Tc9//gfu2D
   lUv6kBziDFQ8/cEYJoVgz5mwrfUHpFYwTl0pDz2WdCO2emF+2CC3kIbrY
   ecKaiInneoQZNoxJS4JaH6p/xSdg6esYiaG4L3NQhwJWfcz+L93keTxea
   FxQR/S1bdaPJN9bdzyFdeDeeTy5u27w1at8t9AvqPFQfKwhnmHhxpo1GD
   /sTBNX6gyIEqKIduuQECu2nfdUgyzXX+bsWz+kG7FPYneILDlDYiC5EpQ
   EAqkuPOc6TsBIuqdUv2j/UHL7YAl0hJzZqQ8i63d2AwsjgJ25jQ+LauQE
   g==;
X-CSE-ConnectionGUID: 2ouTaiG+RDGk5UCNnuQx5Q==
X-CSE-MsgGUID: yT/cj0feSMmyl8g7tK5/Hw==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="85489110"
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="85489110"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 13:22:08 -0700
X-CSE-ConnectionGUID: j/27Y88ERYO041Pa3i8rxQ==
X-CSE-MsgGUID: whhMVyXKTNOu5lad8draKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="296398206"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.58]) ([10.125.110.58])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 13:22:07 -0700
Message-ID: <3620750c-54d7-45a0-b067-bc813dd3cd9b@intel.com>
Date: Wed, 22 Jul 2026 13:22:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 14/20] x86: mm: skip pud setup when using generic
 compile-time folded pagetable
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Russell King <linux@armlinux.org.uk>, Huacai Chen
 <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
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
 <20260722-dummy_ptxp3-v2-14-d9e4bad31e0a@arm.com>
 <0ea931f1-4801-4d32-b6ce-4787a8d3daa9@intel.com>
 <amD7ab_KuJPdBQBh@e129823.arm.com>
 <6f5060a7-0a64-49fc-81a3-ae88729ef794@intel.com>
 <amElnEbvRTjv2hyU@e129823.arm.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <amElnEbvRTjv2hyU@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 67EEA80002
X-Stat-Signature: i5ctgzpznx5mcoc9jo46dzwywyw99mba
X-HE-Tag: 1784751730-679978
X-HE-Meta: U2FsdGVkX1+/y9AKtFR3AQLjFct03OouSTt7qp0X0Con1YCG3J9niFn6hnki+DDvuaxLPge3OWz+UC8Q/bdknFanZFdm8LhDdVE90ViPcun1xfP6ELMG32oiL6C+B8mIBb8K2SXX3EBR0bwY6+QCUHWPNu13U3rJjI9LcH/V3jw+kqH3MI90M6Tx8+fsnR339CUJWfh4yDd6PXtBy2drONIYGb4xXHCsimwZd6bA9/RmxTRm2Xq/AEuw/Wzlq31c/Nrp7ifpFXVLDNIQ5QknGHZ3I4KA5zbeZQWhuEe2XvbiA669i5L+cfNFXoT5kvOYif/8/0bjVH/tyI1i37BOW4JOMwRLA//zeP6tIUUx+T7zt9/RiRruGmkq+/SfM6ifscba3b0Tx3F1XZGuMi1q3pvT8iIPz3Wawhk2+po+ZUPRtY4PzqqtqDr9rFlx9smBhBO4ZfMP7prDrentrQw1sGl+2Cchjse11n0DonFntIemezuHREoGgFPFvrTA31d6sB4a7up8PTGKOrvmduezKA3OPJEynaCJuzfNnmQpTO0S1mosrmGRjPYwztX+bLivsLKKmEgfMlOxP7bO6JNAkhVAE2SE58mX8+zJMM4Mhn/+Oz+woaj/FEXET2B9g1GM3LJ9pU30NwbteGgVV3twvJnoaCUk16sPhTVorcBVMSGa6G+E/H3YZPB0FrZb8y/ndTUq873/K3Rlp2777c/7ZV2eQKjMOGAld1MGil1FnAnL6szmSjmWj7FNGQyvAoawGU36+4/Z54Ee46YwnLcup1DDOLtqJnRC1ZkL0GplNzyeh/fEMEf9Nn5wlr4fz1l37/bM/2eIUcadorynRerylJUZekMBu0SzVhTtjB5ZH7AgheDg8VH75RYCO8VgNXtkhigWqb1hsLzt07eytq2xFy+6H6V00/zU/xLWE2Gqv76qiSN2MBBXvg+Ox5SsX5vVky2C0fdCpuabVtF4u2G
 KaEM6G7L
 D/1BCQsRhMVGl/9dgTz456M/j7UWG3/gns2VUqnGppM28b0VRT15wMKUiePXTQ40RDIUBvkMDPlpuu0YrW8AtOCq2p/JFA0wS1FjARAnzYLh7g+UCt3jyhbHTK+cGX29DDbZTHVfD3P5J2FjV3Bn+EIiIQwVitRlD+rooX11safo1fpjZFQ+GSG2/iJKWDYV8hp7KY4xvZOiyneWfNf0CMzgWHcI7/Kk0GK/Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 13:18, Yeoreum Yun wrote:
> Sorry. But do you mean check with cpu_feature_enabled() not with
> boot_cpu_has()?
> IIRC, the boot_cpu_has() doesn't use the DISABLE_MASK_BIT_SET() but
> uses REQUIRED_MASK_BIT_SET() and I don't expect it wouldn't make
> an optimisation to constant check which is contrast to DISABLE_MASK_BIT_SET().

Ahh, yes. I forgot about that nuance! Moving to cpu_feature_enabled()
would be great!

