Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14023CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 23:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BED18E0155; Tue, 14 Oct 2025 19:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F088E0041; Tue, 14 Oct 2025 19:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436708E0155; Tue, 14 Oct 2025 19:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D7E48E0041
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 19:20:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D43C5C0711
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:20:21 +0000 (UTC)
X-FDA: 83998290642.17.45B426E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0C6F5160008
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:20:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VpCnS0Wi;
	spf=pass (imf08.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760484019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Shh5OaCHcMULEmpCG3Oh2GMfhY1DSJW2K15TncMe0vs=;
	b=FsixbEwT26bgP1nyir+ZecxuiXfSsvr88CXg5Hu0pfNyreeC/H6Scl7Ph0Z3QR4DT4irW3
	eTbA3wNRQeEBFaMtbMi0YChP23yfNPpnSjZ7LSbQ+2F7omOnqONVBNcWIM0Jkrhx21GXpg
	tQk19d9esNyrtuFuG9hkad6ojBK3zOM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VpCnS0Wi;
	spf=pass (imf08.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760484019; a=rsa-sha256;
	cv=none;
	b=eypZBXm2S8M8q7og+fw5J68RIDk90KarQm3mROJOYSZdTveSZy6atTrR8BFisExlPXu3pa
	lB2sDIxhqC5QXT8SaDP0ObmTIo3s6mIgleaD9kW14TlqwlrP8/dAlVQSD6nif3ycbAAHVO
	wd2d8sOouH3DGXmJy9zBi5Nb144m/F0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760484019; x=1792020019;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Shh5OaCHcMULEmpCG3Oh2GMfhY1DSJW2K15TncMe0vs=;
  b=VpCnS0Wigx7T86MDvOlAK/YbsiKR0W+9IatC5B8scMq3uroRjEC/eM/7
   kS9J11yfWBUwu+VUbh12XoufdrjFJRPNMrbfCbm/u99GHKExolvQcUxis
   /VoboPUE9BqwwY/1ICyGo/FD3dcgU+MqLHwKcaqPh2Rjcl9PeeETDzOAy
   j2B6uoPdEX5EZRE+8O4jNnrZKMU955lvy9ycSmbVECL7oNsOS2DKr7gER
   7Ad1OW12+N+dLQ7LdJqZZYQtHXtjpmoRHbdbzXdP6EeQEAD88zvBc7q5A
   r9j0U5RSwDO8da+mW3fwu8c2Vt7L56ofFA7RWJ+9gKBV9/VdYsqsnzmXZ
   A==;
X-CSE-ConnectionGUID: OXHCdAYZTjqVd6zynetxhg==
X-CSE-MsgGUID: MGoz7kdtTcCzipxmm32Zww==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="62804560"
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="62804560"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 16:19:57 -0700
X-CSE-ConnectionGUID: gKgXGwxpS/6QIEGmF33LTg==
X-CSE-MsgGUID: 2vt3WlKPQNyV9H0gyFaqcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="187318351"
Received: from spandruv-desk1.amr.corp.intel.com (HELO [10.125.111.172]) ([10.125.111.172])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 16:19:55 -0700
Message-ID: <b6fdba02-cc3e-4d06-b013-fba94209e7a1@intel.com>
Date: Tue, 14 Oct 2025 16:19:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/7] x86/mm: Use 'ptdesc' when freeing PMD pages
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Alistair Popple <apopple@nvidia.com>,
 Peter Zijlstra <peterz@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
 <20251014130437.1090448-4-baolu.lu@linux.intel.com>
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
In-Reply-To: <20251014130437.1090448-4-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0C6F5160008
X-Stat-Signature: zgfehdyohm1uswki3u6465gckhy4zi1m
X-Rspam-User: 
X-HE-Tag: 1760484018-909704
X-HE-Meta: U2FsdGVkX19pPr6lpTC4RYqvuM3NdqDYJ0fvd/VDNFB3ahCMMM9az7/Jyu8+teck2gn/x9QROQs41HzEyDGLOk+kV/wlsntT1SVRJu5kNUuznbCrXLPyK51gLk0ILKt5JmJ3oePNC8VZ34OsoRiYj03ndmmcKHvWAOD0ViNOkmOFUW1X2vdxSwEBPzpTvFg4v7TvY+Uo2IY3ISECeljejTtpOASSXEmMXzoKonL+yYqZ0LbS9EEd97Pn1ijTAVr5EZ2RPiEW93fsDRDJlJwt5c3P2+PJeVwl84G6QQu0VvEcFM7h499QYEOsBtob9XUeQNkF/gJSLbVReo2BtxAXrY09JQSzLFAwOIDa+Y24XpEqNAO5BMfw3qtWqES5ITKoksUUBofnuSIUQqRNOr/k5p4lWiIpiJ5NEgze3VvsrHyGIDYMfI58wVyKCxYCa6bbnQbDSAxA/PDw9wRy+Bo1jIgTTbKFnP712fmzv+vqTweS6QfmKPJalfUYBiyypJAVMFWVyjcb3LdmbYoiNjgtzkbZvBayMBEsh2A+COd9YKWsxpnPN8le7OK7TMnbP4PRnMZESEOUFIb3aOskdN1DTp9m+vbScwr/sXd1e1VkY518tOzpS9Tx/r/l1Uh4Pjn1/pcvwugt8oAp/vVb5Mfo0jHqAmtMS57CZjjP84WhjrLoBBkDplj6X36ksCGZyTBTce6BwD880IGBa9l3hLaeuIlVpmU1AMvQnIdO3TVJE6XnyFx8EdfluU4lc2U6MnmwvbrTT5m9B5GmNZQnT+h5vzdDRneoONnCP04OGZOfdx1lrrMPbXo7Ac8/fWiu8HmCsVQVybfU6FpVl64VM079F2nD/C/KYx5I1eCPgTjoJOaqyt1Oay56hfFZf9m9y7EDvF85ZzyZUZmKvQKUvYIROPJruaZ57STDxOO4s87nDRtFACSO2VmeE7XIGbQ+7ycxqDQbvqJotuoP+opnrQ7
 9wNHrcpY
 2x+UK9HH1vS7qbr3GsRogCk3hHl0oNzZPHCbkzH6R6LDpuzhHNAKFKUCW+Yt6IP6mtEU9BVDJxlpiCh1zkjJ6x062EOtwpxSGXfY1dVr6s+3kuhqpsnPiqihPx+iEtgXj9UmeTIEoTdCgr4/bWvbOFvI5fnNFA9/whbVlQrGxi5FL88Gq3p5XGcb3qYzOJqiCdDolv02m3CN/pl7fr7RnZkwLOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/25 06:04, Lu Baolu wrote:
> -#if defined(CONFIG_SPLIT_PMD_PTLOCKS)
> -
> +#if defined(CONFIG_SPLIT_PMD_PTLOCKS) || defined(CONFIG_X86_64)

What's with the #ifdef munging? It's not mentioned in the changelog.

I went looking at this because pmd_free_pte_page() is right in the
middle of the action on this reported use after free:

> https://lore.kernel.org/all/68eeb99e.050a0220.91a22.0220.GAE@google.com/

so something fishy is going on. It would be great to narrow that report
down to a _specific_ patch in the series.

