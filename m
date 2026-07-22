Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAD2BC4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 16:02:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FA2D6B00C9; Wed, 22 Jul 2026 12:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1A76B00CB; Wed, 22 Jul 2026 12:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E80E6B00CC; Wed, 22 Jul 2026 12:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40A636B00C9
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:02:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B982116021B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:02:24 +0000 (UTC)
X-FDA: 85016879808.10.85D818D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf27.hostedemail.com (Postfix) with ESMTP id DF9C240014
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:02:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fKCJmYjD;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784736142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pzURkASse6yjo7NlHguqsNW/r3n17/VuRvVPtz078tk=;
	b=t59kJ1LAVm1Yer5eMDOob+PKuPRYpXxEULihMdiSYMB978CUeta/dRYzP3KrLd7Q77odSO
	lpxJUJM8xg6mlZt9Pvq9gPr7ozpDj5150kMYH3AD9ZkHFsK8VpRoUoKZnXSCY6v3Tt9Z3w
	m7rMnyx9Ebj/zw/7Hh4vqnd+TEmFGCQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fKCJmYjD;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784736142;
	b=Jjst//o2RLdrA9fbXWzqoGlSPKne16hLrXT2tTghi0kzReCrefkzQMQN44qhrzRP2RnL4A
	35p89XC3ZR89Mr6buvKYTu1WH2KIk6JIYuRyd4zGAEkdtEzgJlB6zAS1BggqB06/Xd25xg
	hkWSzvuzRT75XRr0b5sg9jpOnFwd+qI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784736142; x=1816272142;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3YntNmWvXbzd8ZFyw1hNGjXIdKkTKwZiDQdVND7+LZM=;
  b=fKCJmYjDptjVAIgvfwgNybQslLWhft/FOaJtj2rOPW3PSbGEG7QkhdF7
   h+Ij4CA7s1dHETK4jrQKbCl6NhygBm16CVBf0fPRXnNl1Mc+K8rs1apdg
   qrmWgqlXZ4hyevkdl42fYPGUaSIttpvhcyYp6T1PGwXhs6y3u3xPnWCxV
   KYK+rcf3YV34U3Fbp//uVNDsoG7A88qRwjKnzhR6kUg7sKrObEaGlE+Yn
   uhWld6Q0gYdVoNIivtOTfiZa5WCpfdvkO/+1nZ/7v5UF8D2NyBrs867vO
   B/vzpGBMJnM+XdNxHTQGmifIiBGexN49XV5Qyu8tSueqoYT1MqX2+KMXc
   w==;
X-CSE-ConnectionGUID: URAPXzL2SWmDsmGgSWeIUg==
X-CSE-MsgGUID: 5KWSl8ijSrGbc2ZeisreUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="96891739"
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="96891739"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 09:02:20 -0700
X-CSE-ConnectionGUID: eltdkOwfQlattSuyxNW0nQ==
X-CSE-MsgGUID: 2a6sP2ztS++09pdF9LpRxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="256344594"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.58]) ([10.125.110.58])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 09:02:19 -0700
Message-ID: <188623a9-dba0-4229-a7ff-5feb2ef0c088@intel.com>
Date: Wed, 22 Jul 2026 09:02:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 12/20] x86: mm: define pudp_set_access_flags() when
 CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD is enabled only.
To: Yeoreum Yun <yeoreum.yun@arm.com>, Russell King <linux@armlinux.org.uk>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
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
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-openrisc@vger.kernel.org
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <20260722-dummy_ptxp3-v2-12-d9e4bad31e0a@arm.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260722-dummy_ptxp3-v2-12-d9e4bad31e0a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DF9C240014
X-Rspamd-Server: rspam01
X-Stat-Signature: b1cyikke8szuphyxqsjtczpqir7hwprg
X-HE-Tag: 1784736141-135251
X-HE-Meta: U2FsdGVkX18YEEU6CoMWemmdmwI6X4hXnBP9IJb5NjO0tVLO/K5oQC225+KeHlfrg+LnVnwDak81EexWZkpQoHkFI7oAfHBVpLJQhGOnI/w/iWQNo0Ag1JPCMbQBN6hX225tpsRVfaT78a0f1tquwso9xp1THNbe0REPMywV0tzjatie2oNSahZWE3tWJbutTH63rO8jD9rioT6hpUcH3+1fr7gPYooAKKXJZbfy8Rl0Dmf1LsPq9UQRBjiGd8/5vfbGLHFnUJXsiocFqjE6Ec9g9oH0IkFw14PF9bw05cBrz2FTif+nbUjwP+TN+WoTacTFc4S+VH8Ye0pWwI+nLRdeoMu1OlR0XdxU8mNtMbM3rdeFrLFmafVMCBnGbbz+8/eqYjt+BbxgMD209iUR8cMKNW8nzKDjNkGag3LWTC/rgORf1oHuCDMNFXzQLMkSMjByBatRbC8e0Nooi37HsUTkt9T7NSIn1Xp4XYC3E38UJ/M8uUtB19DjweumxTu4q+91OHPAZQataq4nWnGJFne8BW/gsK9zsORwkUXq1biNtMWXCrD1D/41Ti3U80jz5II7bOZU4pGmDOWu4jp8ndsXXap88CdGJ3+YrNPWHAcEOPecpXCVF5HbQaBHEgiBSC5DTYv0YoMxsI3j63d3MN/6v9vxKM7lHCUp1mO/EnhjOl7YfHyS6xzWmLGRStcNbDhpUMmPCeigQxFIduUWBP3QAsgne4dTSd0PyLT6nw3vY4cMsy88fC6mOFfYEZoBu3wcBdI+z0DxSl1xy5Npnx5F8wzB7grrrfi/85VmUPmz0/hrz99buHUOY6b4DUSpTCBp/O+A5N91YyfU1uIteG1nOX2IiPYMvmxhXLL0F/4c2oinskamTAISEXIOTpcdckQT9BKDI3YaIzgsIk/bmhuH3ECltU5hoaD+3ZZ+84k4lRlyT0HVJJTn8UDSczF976qgbHFMFtwehVVN613
 uiiUKNlB
 BeQJA5tQdyjSh0qlgQFT9oh9gf+gaMPR3Nqb9WQcK7B3qWGifgBbPqOKUllkOprJX/adnvD1OZXB79zjODae+p4H9IOzAFOrrM2Qogb0+jx3vBLfYBmaMBuObF9b/q/CstPDor/MjrXYt/RR01q3xuqXCax5yD48Xsnp1nbLn+vuCYg8aVWZDt98Sam4O5MdwTW0I7/tHfTDJasH3fRknwltC9cKfabtM7OrcEZXOhy2bhREeuLSyakY0OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index f32facdb3035..edad847a2ecd 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -411,6 +411,7 @@ int pmdp_set_access_flags(struct vm_area_struct *vma,
>  	return changed;
>  }
>  
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>  int pudp_set_access_flags(struct vm_area_struct *vma, unsigned long address,
>  			  pud_t *pudp, pud_t entry, int dirty)
>  {
> @@ -430,6 +431,7 @@ int pudp_set_access_flags(struct vm_area_struct *vma, unsigned long address,
>  
>  	return changed;
>  }
> +#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
>  #endif
>  
>  bool ptep_test_and_clear_young(struct vm_area_struct *vma,

#ifdefs in .c files are evil.

The changelog doesn't make a strong enough case for why this evil should
be tolerated.

These are also _precisely_ the kind of #ifdefs that cause compilation
problems. This one is:

#ifdef CONFIG_TRANSPARENT_HUGEPAGE
/// function here
#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
/// another function here
#endif
#endif

So there end up being a couple of dependent config options in play. If
there are compile problems, this makes them harder to find.

What is the _actual_ goal here? Saving 50 bytes of kernel text?

