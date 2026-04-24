Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F9ECFED3D7
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:52:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E8526B009F; Fri, 24 Apr 2026 11:52:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C0696B00A0; Fri, 24 Apr 2026 11:52:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6066B00A3; Fri, 24 Apr 2026 11:52:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38FF86B009F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:52:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BA5BD140216
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:52:28 +0000 (UTC)
X-FDA: 84693891576.03.62900C0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf04.hostedemail.com (Postfix) with ESMTP id CE0F74000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:52:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JixgMTES;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777045946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PeuLygYRqo4BFW1V5R00Av+FdXdl+cSph4gUmBOyRYY=;
	b=alcXe1K3GXn7Zzf51oWmiz24sJjJlv1uO4HVA2c7f0PaSI2KJ9d3RJR4AJpQXqz6u6WM29
	dph0aoLD2jtnsF02IkG3SHroi6xbFSUg9tigdtcgE+5KzYdEBP2mzCtTipaAHxKgftCvnr
	txfVAnw4PYscmDNGMDegTNDW6MRpe8o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777045946; a=rsa-sha256;
	cv=none;
	b=FMYAohchQ9VoB8jrrj/uGLrwjnu4XQdWCaEJlkhmYlTBhZV1h36tK+AgCaKeAXVXW4xF3B
	l1D1ZusX8tBiRNb0EohQpZXAvELceRlN887ACd0cjpRHp79hEJLHLQBrseSH5RIpb898mS
	FtpLPF0t1xDvl8UUWTUL8asdFm6U/tQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JixgMTES;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777045946; x=1808581946;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HwsZeGTyjhLwKj6nQnbktyz6LRCvsAfioqPnhRfj+n8=;
  b=JixgMTESDNE4Qq83ZWRTS5nObW0y1jbiQe/63A1KX9c0bVuXkFxjtZA3
   R54uRYEwG/H8aUwz8O6mABnfUBkDBx2nMhoHL9KAEdoptBofK9y8FQtEL
   lia2/J5haaYtr7XWyMtp8O0MPFqe6FDIpcCmSa9VJ7PTdRW7j5e9xHOsK
   QtqQsMdnJF665sKK2+uZtn3+6Gw5F3/7ByANm5ojC0RmskuW8liXrp1kW
   i0rZvWR4MsEIWYfhztv4wVtSgwwAqemgFL5FPNjQ5nrlkFbIfXWhKv5Wj
   tZj41ueJTN6SqINiWtXGuj/kFHqLgZaMvPJ1f4PMXkYW1/AC1FzO6uIh9
   g==;
X-CSE-ConnectionGUID: GX+ztbMcTTefZogT+MDiUQ==
X-CSE-MsgGUID: 0+OHiswqQJu8WkJ/csDkEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11766"; a="80611084"
X-IronPort-AV: E=Sophos;i="6.23,196,1770624000"; 
   d="scan'208";a="80611084"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 08:52:25 -0700
X-CSE-ConnectionGUID: E0Nx+DioSqmBoBKTm4PzUg==
X-CSE-MsgGUID: czNrzks6Rq6tARJvsoUAxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,196,1770624000"; 
   d="scan'208";a="237987969"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.108.73]) ([10.125.108.73])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 08:52:22 -0700
Message-ID: <f437455d-1598-483d-9dcf-1932d265ef3f@intel.com>
Date: Fri, 24 Apr 2026 08:52:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v10 1/2] mm/mmu_gather: prepare to skip redundant sync
 IPIs
To: Peter Zijlstra <peterz@infradead.org>, Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@linux.intel.com,
 ypodemsk@redhat.com, hughd@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260424062528.71951-1-lance.yang@linux.dev>
 <20260424062528.71951-2-lance.yang@linux.dev>
 <20260424150454.GF3126523@noisy.programming.kicks-ass.net>
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
In-Reply-To: <20260424150454.GF3126523@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8i46rhtc1fusij4n3e63o57nh6ubnrjs
X-Rspam-User: 
X-Rspamd-Queue-Id: CE0F74000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1777045945-577951
X-HE-Meta: U2FsdGVkX19hvlZ762R8Dnkoia28is8dt3lU1K/+9E1tUjoiJMEFJxb1YgkLHNoiPf6unuodedheZaSBboJ5jpSuoWga2UaO6/Cyp26n8+7un55t9lwOC8V1cPfEvqI6bqr68JPLFdv0GTUGENWXgUT/ASm/b8w9apHCaKGqGtCGi0aVnRCDU0nqcCy/Q50w8iTfk72Zn4cDJwqdHkkWTW6puReGFHvzhOj40p5ssFyMYVOlckkvZbDumcm8Sqo5t6c8cxvkiumPVL0YaKBpCw1B9vs1Y7ThIsCk0J3I++jXb+wSce5v1b2JXU4E7G+Dvk9nRafQdrJpJDPaZA03fZeYJWHkKRT3KC2y+QkJtug9Aj/Em4DX85y6NU8om/Rk/Y6rcZYT0l7Q/U4NtvfAiv9/x3LFAhUp+zWmLVqnSedLwZfS982X/KPYzt6uws5L8/dcFHnuJw2oBhyPRPd7X6ZX2Pe2JSu0/nFjV4jTBmqnUpwMm8HlkfvHjsEzzRn9oirJO4yyj750P7r58pMtg+ao/sVLTZ7Rk26Idw/ZdZC40ZrNCBKGl5ndglObrNZOtvLAbW4bEM740tOnlQBBGroMicQ2t7rZJZXyJXPv2LuGCEb8AnJxoLT1qrVPwHcJe7K8u6bEgu6aVOnYyJGsDSzwyivdDqSxpaW9vqeGvgJLRAn/75RnvfRVYOvIUPHXq4fha6C483GaTqO7EviDCnI5KKrCsETkdG3hs5sNZqgwTUPSNRjZn0p+X8Unm0n6dEUaNYV7IF2Ig0Vs+3yR3Yk6VjsaOn3OY6nxX3XvM30Wzwwpm/YJbMsmlr0ZJwXkW2bmJD7dnWtUTYuElOM3vSO0ADPb+CxIDoLrwo14L6GJfmv+AGT08DCmjuXkCivsDa/uWf6u+ROACzo2wR+t/jEEHSLfualAIN6kUI84r8datUeU8uEIYnq7Fl19MO4bPxmgtDP5SSkZPOqtkpr
 gRWPkQjJ
 3+D6BScbT4BSak+kIgJ8ihP5z4YRpJ0epPNpBKLkndpYURUl5etG2L+diQlMcYbGG9nt1PV48JUrXmOiU0TaugS5O4mhMGxtREJU3Aiyf0/qdrughwXJ6SdJZRsYKCFHVLiSsrjhqKTb0GGGDzplU4700wWgUZNBhx7aAtaex/a0DXRFlo2kL4evbeeXBXP8XWdiQYx5T4iBVQqjGWOFoJYh8lZ6HFt3NiLO7YWdUuKMil4HdGe30DD0aH7RPuMydRugV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 08:04, Peter Zijlstra wrote:
> So I don't like this at all.... The comment says there is a preceding
> TLB flush, but there is nothing that guarantees there is. One would have
> to go audit all users and ensure this is always true.
> 
> This thing is incredibly fragile.

Yeah, this seems like an attempt to apply a code solution to a data
structure problem.

I think I talked about this in earlier iterations. But, ideally, what
happens here is that the things doing the table freeing or collapsing or
whatever would note in a data structure what they did.

Then the actual flushing code can look at the data structure and figure
out what kind of flush it needs. Things like "do I need to flush on lazy
CPUs?" Or, "have I done an IPI since the last page table free?"

But, if I remember from earlier in this thread, some of the callers of
this stuff didn't have a nice data structure (like an mmu_gather) passed
in to the places where it would be needed to exfiltrate the information.

I think Lance gave up on that because it looked too invasive to him.

But, I think this boils down to the code being too fragile as-is to
support what Lance is trying to do. It actually needs some refactoring
love before it can support the desired optimization. I'm not sure
there's an easy way out here.

