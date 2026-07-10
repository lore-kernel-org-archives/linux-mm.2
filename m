Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FD92C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 18:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CD236B0092; Fri, 10 Jul 2026 14:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D516B0093; Fri, 10 Jul 2026 14:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 320446B0095; Fri, 10 Jul 2026 14:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 047976B0092
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:58:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81AB24054F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:58:23 +0000 (UTC)
X-FDA: 84973777686.07.DE2FEE1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf19.hostedemail.com (Postfix) with ESMTP id C8C181A0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:58:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=klAJbRwa;
	spf=pass (imf19.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783709901;
	b=BejSCSYHOXuYn4zZhK6pHj90+YIQRu1T2zm83Zr5XP1snOQJYvQefInP0t9fQgOhuplZpl
	Lg00m3/rqW36TzrbBe0B6hTHDqn/zR3hNINZbQ4borh4/WytFqZrEbEs4NBsxlhGDeRY63
	qdCzHTkBYoUrJhesDwDtbMgmVcXA2cw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=klAJbRwa;
	spf=pass (imf19.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783709901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pxjx3HPNgwHNFs2aZgbl1oOO9kFSczH1Z0F9Hwmf1zw=;
	b=fKXNJ0ZjgYT5Rc6k99OFruMJ3/w+I0Sr9L/BY+XyAEr90wSzcY4ZBRX9pyiNdhl825Xn76
	oZS2pZBNnrKo35S1vUqUXleGSBaVyicXmd6SetG96v87XFnUuIGmyeYw7gDRozcEHqRELk
	RbZpe+8ie53WGsA0KC0beWeUZ/tjKgI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783709902; x=1815245902;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DrPaq6heWDDdouFqQIykoOFCC9AQr7k0ptjRkxAthqQ=;
  b=klAJbRwaycL8XJLU/DQsA/Sy19rM1A4qdITMORPYV1ouwO5phtVZYHrD
   00TfFrj0Nx0+joyiS0rH8igxTPoe4QhriQwpgdfya6GCk2+uuT89uCdKw
   HQg9wAdIqx6voGhbRWWLbrRW/uMKY/audav6qJvx8NnEXWvhJ9fdCyUzy
   /3TJa42BRdHqBf5wrFEL3AcTQXNqvpKLpEar0Dxf6rm8wQkfD+1pZZP71
   uluhjuuilNJdMGSrjZawtCRGGt71E+UzQIyo0myyhOTdLG7/YLleHyB4c
   IcdM/s7udhf+zE6eeVj9+bqhdYdXKbxIYGV/Hx0NakXgdZHjmC9QLsc4b
   g==;
X-CSE-ConnectionGUID: nMCTOgrHSUKstE5wEKyj0g==
X-CSE-MsgGUID: c49x4B37SdCuYtS4l+RN9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84266986"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84266986"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 11:58:20 -0700
X-CSE-ConnectionGUID: VeQ15drLQUOMPQogtYS6tQ==
X-CSE-MsgGUID: YLvfyccNTkO1wszNS4m6OA==
X-ExtLoop1: 1
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.111.199]) ([10.125.111.199])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 11:58:19 -0700
Message-ID: <bfa239d3-2582-4669-8614-0a299491a744@intel.com>
Date: Fri, 10 Jul 2026 11:58:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Xiang Mei <xmei5@asu.edu>, Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, linux-hardening@vger.kernel.org,
 Uladzislau Rezki <urezki@gmail.com>,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>,
 Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>,
 Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>,
 Yan Shoshitaishvili <yans@asu.edu>
References: <20260629214712.1198680-1-xmei5@asu.edu>
 <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
 <20260701072747.GN48970@noisy.programming.kicks-ass.net>
 <20260701074834.GI49529@noisy.programming.kicks-ass.net>
 <8730D74D-6395-4FF4-B9F9-06AFABBF8CDE@zytor.com>
 <20260701083108.GD751831@noisy.programming.kicks-ass.net>
 <CAPpSM+SzqLSPt2q0KhkzB-WvphXGmby99QBJL7v_nq4kJGAYFA@mail.gmail.com>
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
In-Reply-To: <CAPpSM+SzqLSPt2q0KhkzB-WvphXGmby99QBJL7v_nq4kJGAYFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C8C181A0002
X-Stat-Signature: mrh7xd5zw8o9sioontom7t1xjujtbbrc
X-HE-Tag: 1783709900-759147
X-HE-Meta: U2FsdGVkX18k6K4EDC0HWjnnNxziN9t+RnD9zQuxPCkbOcT0I2bGwFin7dYLQpt2zYIipgVC0Eq0NowwklBjPEZfJba28Mk4VJA7+zNsRF/jKDHTlL12G1qm4zyPJq0cG2jvQIvwPnuIg7UeZMWjrUsheqpqYew6+WR7mDSmyy3qBCVtUlbGgx6iX5cnqbv0RQGFES+1V9/try+x7y0EXzPQG2u4D609x9WzLnQR+XxX3zkEp/Jb9ndol48AzSLfRly0yVvyY9wGraWpYgqYLewrk73gEe0gNsgjc68Nep+Y8YG/P0xGqgXeDwuBhjKx1DCFyPIdYwLldhOwD2hjKhWtQWjqPycJ1cWnD3eNbODmAYzlQOoqyJuwucIS9RyIxWqI4tGV17MTp9et/BBqs4wFr0bGfgmk9YJO7wtXGxhF5hP+YBiY8AHcJdjWzo6MaC03gL/9asTuYK4TEVYTNvaGsQ3p4c96dW4skhB6oXy628wT/WbMKL48tlKMwXg0BPcPCmFkFBQE4rZh9Tw8M/oS9/d5eYBxiSiN8J3g5y0S3KPCjzXWz/RMFXwfay+NLPByKui7/P5/J9/AXshBVUMkCUizxPU8XOzatxqYvIxL8TCuHQuf+xfCXoaZ2a7Z+Ul2F5rGO2pVMJw4PdFIHk2WUq8b7VshOLs71uVb40Ef4sQQJAZuLWaDLZA6lLHb1qhypCyBDEqBTGtQbW2lzqXQA7nQmaRkMt/SBGg9iEUMR1OE19akzxK700kf+5JkzyZxaSuVNVscnSnkZOu4IbltkE196kofKQab0232SphrTjvfkj+y4iSM7yd22nAwmT4tQ4+FKJNeoDawtqi1k2wkGoLdmjl5bV6VwIwoYyMcA/MvW4X5UVKqgeiWol4fuvdZFmmuSXkIlCNJiUYCo+0mqz4zdph5qng4EdBb8gwD1ZysM0N3m+uxrCwruwAKzBSgXfQkjwnynMRC7cE
 5AN8vIVO
 AY6KWpQjXFENjBXNKvudrHvgKoyo4JVETS6ti4SS1AhGfc3BQdpM2nj/3dRVuoKISrlMQQyaqgaLeHr1GNEsbj7Q+jAut5bBOfwP/0UmCuPzW+LbxM44pIkp+Aqva63gUY1dfjhFGT69bNVgzp2lnKCtm6HA5BCIeqZOyPFTYaYQbkEIjNAJhBdsPahgqLwj1Q+UgCmNj8bANQIU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 14:04, Xiang Mei wrote:
> Peter's explanation is correct: this technique makes CFH->ACE easier.
> 
> I think both ways can mitigate it, but I would like to hear your
> (maintainers') idea of which one we should proceed:
> 
> 1. supervisor-ENTER-#UD + Peter's objtool check. Cleanest for ENTER,
> but it needs a new bit from Intel/AMD, so future CPUs only.
> 2. Kill the landing zone with a 0x11-page guard area.

Or:

3. Do nothing. Normal kernel IBT is good enough.

The hardest part of #1 IMNHO is convincing people that we need "a new
bit" *PLUS* the two CET technologies (indirect branch tracking and
shadow stacks). If I were a hardware guy, I'd be complaining that those
silly kernel developers aren't even doing supervisor shadow stacks, so
maybe they should use what they have before we starting building new things.

Also, I kinda gave you a route forward. I think someone can both make
the vmalloc gaps more flexible, less hacky, simpler and cleaner. Then,
once that has been done, it's dirt simple for any individual vmalloc
user to have a custom-sized gap. Or, to have a universal, larger,
tunable vmalloc gap.

Get that series put together and I'm open to an 0x11-page gap that x86
pokes in to place in some way.

