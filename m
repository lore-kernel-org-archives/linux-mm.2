Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EFE3ECD992
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 18:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AFD16B0089; Thu,  5 Feb 2026 13:36:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D5C6B008A; Thu,  5 Feb 2026 13:36:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F4C6B0092; Thu,  5 Feb 2026 13:36:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F34736B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:36:45 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98635C235C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 18:36:45 +0000 (UTC)
X-FDA: 84411259170.01.ACFE7C3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf29.hostedemail.com (Postfix) with ESMTP id 15D4A120006
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 18:36:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZhLHDS4M;
	spf=pass (imf29.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770316603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a9XUew3OKs2khZcdfbu4P2U7TU7j0aznGt+BPSW+pjQ=;
	b=MYhfcTV6d6Hlz1+CYTdVB0ERE454E1bQIhPreeuGLM0Cz5TzYZWFFDS3aiHm50GMVV/5NK
	f4tetVhpYHawf3NQ+DiWxJ5AJ7Ovxp48XcqHntOrPNlVZlJD3kVCr2ckniL94Lu+6HwVTk
	ZsUIpYsdZXUL0cOJmlKg7ohiW62+1uA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZhLHDS4M;
	spf=pass (imf29.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770316603; a=rsa-sha256;
	cv=none;
	b=E2fKI6k02cKK0CuvrhIlhy5XSfKSKQHeQoHu0gyrSjaGTO3/D7Kw3maVKkHfxoNaeKAICr
	3t3oVi8vKRra/mrKsnHiVaxnLAA808JqNQEKZTBApqDpcHqS/hWznwLntLuRpCaUQ20j5U
	crFVawUjKpRNNq+5D5htq3MixRqbxNw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770316604; x=1801852604;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BRoiTGDD1DPstl6jjIry5OxGDVXQrFg9V+c5bc7ZNDo=;
  b=ZhLHDS4Mrr9kjDoYWu4M2/WF20C86S8aa98UFNwPBcrpynGt1pub2WD2
   NOlKz/YWcOS8hZ3wy+9s0RXgoCaCRbPTRw8ECW8Kkv1kIj8sRIAmPMMmu
   oifo2gbUzkamwn87oAi4qwhVpTgnqRv/T/HSR4En+uqchQNpipHUfOKut
   1nfcs/6SB3jUgLseb4GUAmF/I2+GwBe0pVyv4zqmvVfN3mBCPay31M5Nx
   Xn5GD8/uBKvZV+nz0vcoLdjobXUaxr1cu9uV9D32GL4GBxn77sY6NGik3
   aJk5mzpIx+ErIFzutNYn0BVx0duNNiA6MmjrOOxBEYLvmmPQRPHYoNpkb
   w==;
X-CSE-ConnectionGUID: hBfwFpLySWOUFyB7V1uyJw==
X-CSE-MsgGUID: YJ6vno+STLWVa6zVJXCPbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="71514787"
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="71514787"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 10:36:42 -0800
X-CSE-ConnectionGUID: gXKa7sqmSK6D/KjxOc4B2g==
X-CSE-MsgGUID: wizrHLKHQe6FZo0fvb0otQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="210428597"
Received: from tfalcon-desk.amr.corp.intel.com (HELO [10.125.111.86]) ([10.125.111.86])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 10:36:40 -0800
Message-ID: <dfdfeac9-5cd5-46fc-a5c1-9ccf9bd3502a@intel.com>
Date: Thu, 5 Feb 2026 10:36:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Lance Yang <lance.yang@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org, aneesh.kumar@kernel.org, arnd@arndb.de,
 baohua@kernel.org, baolin.wang@linux.alibaba.com,
 boris.ostrovsky@oracle.com, bp@alien8.de, dave.hansen@linux.intel.com,
 dev.jain@arm.com, hpa@zytor.com, hughd@google.com, ioworker0@gmail.com,
 jannh@google.com, jgross@suse.com, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mingo@redhat.com,
 npache@redhat.com, npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
 ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
 tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
 x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
References: <20260202133713.GF1395266@noisy.programming.kicks-ass.net>
 <540adec9-c483-460a-a682-f2076cf015c2@linux.dev>
 <20260202150957.GD1282955@noisy.programming.kicks-ass.net>
 <d6944cd8-d3b7-4b16-ab52-a61e7dc2221c@linux.dev>
 <06d48a52-e4ec-47cd-b3fb-0fccd4dc49f4@kernel.org>
 <3026ad8d-92ad-4683-8c3e-733d4070d033@linux.dev>
 <64f3a75a-30ff-4bee-833c-be5dba05f72b@intel.com>
 <c985a8ed-37ad-415e-b7b4-18a66b4da3fe@linux.dev>
 <647cbe2e-a034-4a75-9492-21ea1708eccc@intel.com>
 <99237729-f2b0-4a7a-8213-65a2f1c57744@linux.dev>
 <aYTJzft5cuqD9akC@casper.infradead.org>
 <6a364356-5fea-4a6c-b959-ba3b22ce9c88@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 xsFNBE6HMP0BEADIMA3XYkQfF3dwHlj58Yjsc4E5y5G67cfbt8dvaUq2fx1lR0K9h1bOI6fC
 oAiUXvGAOxPDsB/P6UEOISPpLl5IuYsSwAeZGkdQ5g6m1xq7AlDJQZddhr/1DC/nMVa/2BoY
 2UnKuZuSBu7lgOE193+7Uks3416N2hTkyKUSNkduyoZ9F5twiBhxPJwPtn/wnch6n5RsoXsb
 ygOEDxLEsSk/7eyFycjE+btUtAWZtx+HseyaGfqkZK0Z9bT1lsaHecmB203xShwCPT49Blxz
 VOab8668QpaEOdLGhtvrVYVK7x4skyT3nGWcgDCl5/Vp3TWA4K+IofwvXzX2ON/Mj7aQwf5W
 iC+3nWC7q0uxKwwsddJ0Nu+dpA/UORQWa1NiAftEoSpk5+nUUi0WE+5DRm0H+TXKBWMGNCFn
 c6+EKg5zQaa8KqymHcOrSXNPmzJuXvDQ8uj2J8XuzCZfK4uy1+YdIr0yyEMI7mdh4KX50LO1
 pmowEqDh7dLShTOif/7UtQYrzYq9cPnjU2ZW4qd5Qz2joSGTG9eCXLz5PRe5SqHxv6ljk8mb
 ApNuY7bOXO/A7T2j5RwXIlcmssqIjBcxsRRoIbpCwWWGjkYjzYCjgsNFL6rt4OL11OUF37wL
 QcTl7fbCGv53KfKPdYD5hcbguLKi/aCccJK18ZwNjFhqr4MliQARAQABzUVEYXZpZCBDaHJp
 c3RvcGhlciBIYW5zZW4gKEludGVsIFdvcmsgQWRkcmVzcykgPGRhdmUuaGFuc2VuQGludGVs
 LmNvbT7CwXgEEwECACIFAlQ+9J0CGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEGg1
 lTBwyZKwLZUP/0dnbhDc229u2u6WtK1s1cSd9WsflGXGagkR6liJ4um3XCfYWDHvIdkHYC1t
 MNcVHFBwmQkawxsYvgO8kXT3SaFZe4ISfB4K4CL2qp4JO+nJdlFUbZI7cz/Td9z8nHjMcWYF
 IQuTsWOLs/LBMTs+ANumibtw6UkiGVD3dfHJAOPNApjVr+M0P/lVmTeP8w0uVcd2syiaU5jB
 aht9CYATn+ytFGWZnBEEQFnqcibIaOrmoBLu2b3fKJEd8Jp7NHDSIdrvrMjYynmc6sZKUqH2
 I1qOevaa8jUg7wlLJAWGfIqnu85kkqrVOkbNbk4TPub7VOqA6qG5GCNEIv6ZY7HLYd/vAkVY
 E8Plzq/NwLAuOWxvGrOl7OPuwVeR4hBDfcrNb990MFPpjGgACzAZyjdmYoMu8j3/MAEW4P0z
 F5+EYJAOZ+z212y1pchNNauehORXgjrNKsZwxwKpPY9qb84E3O9KYpwfATsqOoQ6tTgr+1BR
 CCwP712H+E9U5HJ0iibN/CDZFVPL1bRerHziuwuQuvE0qWg0+0SChFe9oq0KAwEkVs6ZDMB2
 P16MieEEQ6StQRlvy2YBv80L1TMl3T90Bo1UUn6ARXEpcbFE0/aORH/jEXcRteb+vuik5UGY
 5TsyLYdPur3TXm7XDBdmmyQVJjnJKYK9AQxj95KlXLVO38lczsFNBFRjzmoBEACyAxbvUEhd
 GDGNg0JhDdezyTdN8C9BFsdxyTLnSH31NRiyp1QtuxvcqGZjb2trDVuCbIzRrgMZLVgo3upr
 MIOx1CXEgmn23Zhh0EpdVHM8IKx9Z7V0r+rrpRWFE8/wQZngKYVi49PGoZj50ZEifEJ5qn/H
 Nsp2+Y+bTUjDdgWMATg9DiFMyv8fvoqgNsNyrrZTnSgoLzdxr89FGHZCoSoAK8gfgFHuO54B
 lI8QOfPDG9WDPJ66HCodjTlBEr/Cwq6GruxS5i2Y33YVqxvFvDa1tUtl+iJ2SWKS9kCai2DR
 3BwVONJEYSDQaven/EHMlY1q8Vln3lGPsS11vSUK3QcNJjmrgYxH5KsVsf6PNRj9mp8Z1kIG
 qjRx08+nnyStWC0gZH6NrYyS9rpqH3j+hA2WcI7De51L4Rv9pFwzp161mvtc6eC/GxaiUGuH
 BNAVP0PY0fqvIC68p3rLIAW3f97uv4ce2RSQ7LbsPsimOeCo/5vgS6YQsj83E+AipPr09Caj
 0hloj+hFoqiticNpmsxdWKoOsV0PftcQvBCCYuhKbZV9s5hjt9qn8CE86A5g5KqDf83Fxqm/
 vXKgHNFHE5zgXGZnrmaf6resQzbvJHO0Fb0CcIohzrpPaL3YepcLDoCCgElGMGQjdCcSQ+Ci
 FCRl0Bvyj1YZUql+ZkptgGjikQARAQABwsFfBBgBAgAJBQJUY85qAhsMAAoJEGg1lTBwyZKw
 l4IQAIKHs/9po4spZDFyfDjunimEhVHqlUt7ggR1Hsl/tkvTSze8pI1P6dGp2XW6AnH1iayn
 yRcoyT0ZJ+Zmm4xAH1zqKjWplzqdb/dO28qk0bPso8+1oPO8oDhLm1+tY+cOvufXkBTm+whm
 +AyNTjaCRt6aSMnA/QHVGSJ8grrTJCoACVNhnXg/R0g90g8iV8Q+IBZyDkG0tBThaDdw1B2l
 asInUTeb9EiVfL/Zjdg5VWiF9LL7iS+9hTeVdR09vThQ/DhVbCNxVk+DtyBHsjOKifrVsYep
 WpRGBIAu3bK8eXtyvrw1igWTNs2wazJ71+0z2jMzbclKAyRHKU9JdN6Hkkgr2nPb561yjcB8
 sIq1pFXKyO+nKy6SZYxOvHxCcjk2fkw6UmPU6/j/nQlj2lfOAgNVKuDLothIxzi8pndB8Jju
 KktE5HJqUUMXePkAYIxEQ0mMc8Po7tuXdejgPMwgP7x65xtfEqI0RuzbUioFltsp1jUaRwQZ
 MTsCeQDdjpgHsj+P2ZDeEKCbma4m6Ez/YWs4+zDm1X8uZDkZcfQlD9NldbKDJEXLIjYWo1PH
 hYepSffIWPyvBMBTW2W5FRjJ4vLRrJSUoEfJuPQ3vW9Y73foyo/qFoURHO48AinGPZ7PC7TF
 vUaNOTjKedrqHkaOcqB185ahG2had0xnFsDPlx5y
In-Reply-To: <6a364356-5fea-4a6c-b959-ba3b22ce9c88@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 15D4A120006
X-Stat-Signature: db4w9r5ufjjysi6czdsknopknci6znsr
X-Rspam-User: 
X-HE-Tag: 1770316602-872553
X-HE-Meta: U2FsdGVkX1+vheyCd/ViDbCWfyaOJaOfFS5WwyrY2OQFu8yfEWIy6uphsNJ3qtw58VUsnalox0jSWD2kg97GtdxnpG23ZUlBM0/GuvkzElbxeHmM+/W+m5UYHZBn5aV7T07sDJkIxgXeaIHVsC8L8vDYfdyKrSBeS2801aEAgLeuc0/bGCysmhy4H01AtmoJJVpPeiY/srhhomaTa6wiA0yrYRahOZsx3xpdfWqCGFObDINHnOHgW86pVe0ZXRofkYw5ZqrHwuCnykwC5uaf9nVbnN1JdPc68YL6b/dCxH07ywVyQhaL2HhOxKSOeFROiH3SxW7cNUO1wuk5Y9Xr/JbR+nXMkbC+y2Hz837WnyhSFEiSTHkhAcbzpoe/PW5C1OF+CWOA4ShgDcCNxvtVEk1rYfmpREEE9zv97txenHOS+EycG+fDUbJABIlMEmh/wFo+RVm4qqMwaZhpplBUVFpBVtxirFkbMWUYKWxek4UTJzItZmd1wJsYGsVXGO9yv2BCvXIv8eqfXGobCohGVtg2hIcSMuliGLZqNVU4RMkDBXc87jMsrBjt5gvqzWkurZjZTscPmzzG2YAsxD0eTG04wRh9AZJnFZTYsm0uT7WppkJFxiAdq9qXWTV2rHtndZsg6OvOHtKfLDsQ0/XSyBzXUa5ngmU46g8mlc5FB/dPkRuS1yuVFwWMPyRnTWpXzFsfFUHVIeWIp5uGyvj+Kshr40hUwFyc08D2iFL8eTTlejgA9CX/UGsg1dbM421s2u4iefYO6O2EFxLM81BporVp9yYb/XlxJccmHnDLHKQaa1ckpgDptGque8+nMzX/L7PbcHFcUlErp0Zslw2jnb5JZ16gJgDmcdlgTnqMJiGbqg+9CoEqDuz5wVPSJJhp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 09:06, David Hildenbrand (Arm) wrote:
>> But can't we RCU-free the page table?  Why do we need to wait for the
>> RCU readers to finish?
> 
> For unsharing hugetlb PMD tables the problem is not the freeing but the
> reuse of the PMD table for other purposes in the last remaining user.
> It's complicated.

Letting the previously-shared table get released to everything else in
the system sounds like a fixable problem. tlb_flush_unshared_tables()
talks about this, and it makes sense that once locks get dropped that
something else could get mapped in and start using the PMD.

The RCU way of fixing that would be to allocate new page table, replace
the old one, and RCU-free the old one. Read, Copy, Update. :)

It does temporarily eat up an extra page, and cost an extra copy. But
neither of those seems expensive compared to IPI'ing the world.

> For page table freeing, we only do it if we fail to allocate memory --
> if we cannot use RCU IIRC.

But that case is fine to be slow and use synchronize_rcu(). If you're
failing to allocate a single page, you're in a way slow path anyway.

> khugepaged, no idea.
Sounds like Lance has some homework to do there. :)

