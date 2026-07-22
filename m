Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11D5CC4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 20:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D93886B007B; Wed, 22 Jul 2026 16:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44586B0088; Wed, 22 Jul 2026 16:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE7226B008C; Wed, 22 Jul 2026 16:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 85D576B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:03:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B0B4C0322
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:03:01 +0000 (UTC)
X-FDA: 85017486162.04.1FFA91E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf06.hostedemail.com (Postfix) with ESMTP id AB4B8180012
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:02:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GlQrgO3V;
	spf=pass (imf06.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784750578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0vs8qUcws20PbRcHGCmwLowNjECoZnWVctGbviPhQjo=;
	b=1Wfz8BH1EnBRYYnPhd9Xe4xgR8Ha2tQILbPqje2XjKoqRlJIHNQL4rh1o3NxJvRRx3IUxV
	eMp1xViaNgcValU6oEeF1LDeIRHI+49RgrC546PlUfAIxEiOZX5wNv5EDB3umAeYpR0s6p
	HrbUxF9PuSBFVYi20PHXTXvKk3S87yg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784750578;
	b=326jP2Do9Nfx4t0sZIKqNZ+C+2dQZEhv7GO0RE2C8ZlHKLa5qLJ1s1j3Ss1bBypmKWaQo3
	3VjS8OBLWdq1p6lb93CbjFycLWlf0zTqdT/qqLmhY2deOoiqBA1lDekrYugf9iNznANTLz
	InhM6O9sQRn8tOPjS3Es3mrRo+LdW9I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GlQrgO3V;
	spf=pass (imf06.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784750578; x=1816286578;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uqbBTPCzw4yRBeGp2Yr8m/BZSs55mdTxe1zylVnLMSU=;
  b=GlQrgO3VwtQmR7Sgb4JxJ9d4xbXPvQI6oaPNBBFAoPVinKoPGHeF/Ykl
   1QhEt6H4tFiWuM73v/AqkcU07XcINqV/1ypY8ql9R8v+NYahbE1Qm2UlA
   23YloZl5sDwqcslVJQsTaezZtLz9WupFtqS5uXr8bt4XexObZou8a8E81
   uGxw1RvioTgQFwUfSPuOddsF7i3f9bJ220ssjoK2Cu3bDKZ6ihUAzEEmt
   CKdQKBJHZilHLsjEMLvK7jqRa0BrQkRtFnrQ7FkYf+mUQp6WKViYnitbu
   0AYsTk3hWVyYR7yBO00vGYO1K3/Tqw4bEK7dzcbRCZUwXar95+BM3pWAe
   w==;
X-CSE-ConnectionGUID: 5FkVJIG0RjWro2xkL7wthg==
X-CSE-MsgGUID: Fwp5Jvk+TN2Wjj6M8DdCoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="84523112"
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="84523112"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 13:02:56 -0700
X-CSE-ConnectionGUID: n4bQqbtdSSSwOuzaoTMNAA==
X-CSE-MsgGUID: WZ8ynCgBTUiBBT4oSyVU5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="254266571"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.58]) ([10.125.110.58])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 13:02:53 -0700
Message-ID: <6f5060a7-0a64-49fc-81a3-ae88729ef794@intel.com>
Date: Wed, 22 Jul 2026 13:02:53 -0700
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
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <amD7ab_KuJPdBQBh@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e41ckx7dc8tfhefcwhg6o571bkegfzf4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AB4B8180012
X-HE-Tag: 1784750577-341228
X-HE-Meta: U2FsdGVkX18uzruRjVL/M3xWCHI523e+eXrurz38Tb2KFO8IGNCaHDdr3leA6Fkt6HWEEjRoQZU0uFtLbxxPsYJubZoHIlyQD6F+n6eFS9RXONP06RLAiEuAqls0rAC/QZePhMMHVr7uHatsndGj8wntDDZ4IF8N2yJvXotBmIQrGPUcrikUhx18R4Wso1nsjdpDsAFUyEonzK7pChbwnWKzCM5Xnta15gAap3E0zquPbVQTzHMBN4uJW6+1dredaYjHzIusSMSgFSfRx/+OcV6ayUJqLMpxsyXfOqVmHCA+OPtpE88RSTxTqpFgeyv3appgF+R8AL4Ist36H0+yhMNxbDbVfPLPPr3P8jLRJK82XvVe9ZMcbFIVLha2j2M4/Fp3Nq2CxIPclmUvAlkKKl+tyNU8HRwZYX9JuW1KCAJI2GG1wiVTsBX7vUXUEtq8EW/ZgLHLCXr55s+qtN50BiyYopaVWPZ3o56dCkip2SeSY13XBZzEHD5MjrcZvdD1cnguUA9ZJ9F8OxE+o04qB97oefDLdHpPEQ89Ad4eEPFQI1/QtLtZ73+92GrZ0e9eNCSP0Kze66pEAXzxm38/mciEcNkntDDebjyoBeXmTm9WRP3/ObLzK5YnZSMdJXHr+jjqrx/VO/I3YWOFrk/5sycns5cUQcPlL6N+TPLWLRt1DgwAz7E73sdhyHCNIGH0//XhH7ruj1Ed+RbAbodIkP/h4pxl5FLT1JBUkY0Njb+j/IUDeKRuSD3vShSGUl1BSv+FTP/OuQJNsxWdE5KmQQipkTJaC3J2gtcfCzPEcH1Vs003JIXUOLmeAoDHvSH53swIydNew6TBtktj1KWV6OVcXszdwRxs/0r8EBpZKctQsW9f7igkFdkWvKTzDBM9e+E+5yvnMbRKimbSvh5tLSOCRolF6chMrCeAmnSmSJQFB4JcW7qKXQZFkdNLmpzxYgqaLBpk7Zg81MbSZ+0
 zUxbpXei
 dzkJlrfo/aOlMBeWt6fmEtmbFnfRK19jVKtwaszwMp1j2Haj0Xe6JZUUTZbe+yB7bNbPG4CF9/r+D+HsMl9oObSuWqG81PVGTWLmqZpx1cVgR/UK8W2OpNi4i7HByohuDUgTuMF9r472hQ/z+anFbSXCJ0Y3VhXIJh5lL4v+EpHdCkoBxu0SZ2XQYULqrhR17Pz2WlHnqOxsWteg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 10:18, Yeoreum Yun wrote:
>>> @@ -1730,7 +1730,8 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, p4d_t *p4d,
>>>  	/*
>>>  	 * Map everything starting from the Gb boundary, possibly with 1G pages
>>>  	 */
>>> -	while (boot_cpu_has(X86_FEATURE_GBPAGES) && end - start >= PUD_SIZE) {
>>> +	while (CONFIG_PGTABLE_LEVELS > 3 && boot_cpu_has(X86_FEATURE_GBPAGES) &&
>>> +	       end - start >= PUD_SIZE) {
>>>  		set_pud(pud, pud_mkhuge(pfn_pud(cpa->pfn,
>>>  				   canon_pgprot(pud_pgprot))));
>> This is an OK approach. But there's a way to fix this site *and*
>> optimize a non-zero amount of other code at the same time. Add this hunk
>> to arch/x86/Kconfig.cpufeatures:
>>
>> config X86_DISABLED_FEATURE_GBPAGES
>>         def_bool y
>>         depends on X86_32
>>
>> That will turn the boot_cpu_has() check in to something that can be
>> resolved at compile time. It has the added advantage of compiling out
>> all of the code under X86_FEATURE_GBPAGES everywhere else in the tree.
> Does it? when I glimpse check, this wouldn't be compiled since
> there is no bit for X86_DISABLED_FEATURE_GBPAGES and defining the
> DISABLED bit for FEATURE_GBPAGES seems odd since bit X86_FEATURE_GBPAGES
> is already defined.

x86 is a special snowflake here and all the similarly-named things glued
together with magic makes them hard to grok.

Our X86_FEATURE_* bits normally compile down to a bit in a bitmap in
memory. But, there are also some optimizations in the helpers that
access those bits. The optimizations turn bit checks like:

	if (bitmap[N] & bit)
		...

into a compile-time check:

	if (__builtin_constant_p(bit) && DISABLED_MASK_BIT_SET(bit) ? 0:
	    (bitmap[N] & bit))
		...

The DISABLED_MASK_BIT_SET() macro magic check if (for instance)
X86_DISABLED_FEATURE_GBPAGES is around. Some processing of the Kconfig
variables produces a header with X86_DISABLED_FEATURE_GBPAGES defined.

> Instead of CONFIG_PGTABLE_LEVEL > 3, as above, would it be better to
> add check IS_ENABLED(CONFIG_X86_DIRECT_GBPAGES)?

That would definitely change the behavior. It honestly might be the
_right_ change, but I'm ignoring that for the moment because even if it
is best it is fodder for another patch, not this one.

Please just keep the check against X86_FEATURE_GBPAGES for now.

