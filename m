Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4730BCCD183
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3B078E0039; Wed,  8 Oct 2025 11:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EBA78E0002; Wed,  8 Oct 2025 11:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 864D88E0039; Wed,  8 Oct 2025 11:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 708C18E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:34:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D8C711A817
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:34:26 +0000 (UTC)
X-FDA: 83975343732.18.8980064
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf06.hostedemail.com (Postfix) with ESMTP id 37668180010
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:34:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lbkU968n;
	spf=pass (imf06.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937663; a=rsa-sha256;
	cv=none;
	b=atqGPeMXw+kogcrc65QQ+K9KFvbacd6bosHm2mHvTdnpsnqtJ6JS5wvN1400cnuUhIhd/H
	6Q8K0s+rsqB0kgJdhymvPFnPDJhX42hLF3fKSF3cKNaGkhzd4TN6QY55Ul2bLOXpb7+pZa
	Ct8B0LTzY4X1TvzIqVSmwZLowpVf08s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lbkU968n;
	spf=pass (imf06.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQGSkFc6wNYm08Y6FYHTifxdNbPiddSU06Ng/7Isc30=;
	b=f8NQvymNTpCQ82mv7Be2hstZXVy9QXFWZwoegqIYKTbVi3q2y8Csyf/5J530rxeVVBwdwj
	kL4vVL6Oo6axp4r8YIrZA7DkI5dxG1jSRB4/cZzG1je2ioaFmlCQld7THlIgc6zU6cZgnD
	xa2veK9JTz9c2dHG+HBezNkjQ95wnHM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759937663; x=1791473663;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3wlMUtRlVeX4swq5+CsB9qp3ch0ctpXp57Y4EX8++gE=;
  b=lbkU968n2dokx1sGaiOWECFGqeq/SiiZsbPNLNfoM77bfu4lX4EWTD2G
   gjPfb3AK2WgI92G9t3zEVIVbE7WWpYki4Sebt4t9AqkSBEQLRVQ0a1HqQ
   rIW7npQ6h4PJndMOQ34tcLHQ54fIVsF2wMRmLXu8a5EtgYApBCYsJ0NQt
   bagfWy4ujZAq7LMSp8kUXK2f6zAxeiE0SA6SFX58OCUfiX4N+/wVkpdir
   fZT00dHnjB+7zIF/kAqyh6WNiJUS9fl2YO1nDNj94wCUT9olZOsdfODUS
   kjPLAHJ5VeL8FfxaGAp9jcOLZJm4h0/TgzXD577vx1Gf+WemL3RU94Ci8
   Q==;
X-CSE-ConnectionGUID: 5LgfiIiER1uoDF7ELTr76g==
X-CSE-MsgGUID: nwJ6wjwLTRSj/wOoJ51boA==
X-IronPort-AV: E=McAfee;i="6800,10657,11576"; a="62231928"
X-IronPort-AV: E=Sophos;i="6.19,213,1754982000"; 
   d="scan'208";a="62231928"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 08:34:22 -0700
X-CSE-ConnectionGUID: 8H/0jZtwSDaZG5E5GxraUw==
X-CSE-MsgGUID: wQBuL31YTiyKD06b34dK9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,213,1754982000"; 
   d="scan'208";a="179595806"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.110.204]) ([10.125.110.204])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 08:34:22 -0700
Message-ID: <1b72c0b1-4615-4287-bac2-c8806e56f44a@intel.com>
Date: Wed, 8 Oct 2025 08:34:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] [PATCH] mm/page_alloc: pcp->batch tuning
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ying.huang@linux.alibaba.com
References: <20251006145432.4132418-1-joshua.hahnjy@gmail.com>
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
In-Reply-To: <20251006145432.4132418-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: s1imoomnmnxjfsg8stofk1q7kd76qkdi
X-Rspamd-Queue-Id: 37668180010
X-Rspamd-Server: rspam09
X-HE-Tag: 1759937662-15676
X-HE-Meta: U2FsdGVkX196GBximUpdafdsgEkLUJjP03O7kUtqVH4uklXBTJd7uJ8wF0/8k1T1NAqstZE9t72+1WYmgKjWPzJu7/F3LwahVmU7NnSbfFc7EBF9BBxkTyin3BkPV/39GFLV6csbubh/4U1MvAMV/ko4usOqhPre/sNIi0Hw9tPHcgcAwPXyFfzUtPM2llJeMAj+xWDKqGDOmkINyrtEpVWEoJdms2Mlastaa56m3uE1afCAbpKxRczc6HHuMXrEcC+tK6Ze+39S9A21p4X3Bb4tPxroM1yXOIuKAkDhInoSi+pBTbSHW7orvHyhpcUi/enWywvwS83iiukfGcAWpLWhIsr/d5N7DmMnnDdyTL/UGU43JvtbjXytxI14BgE9XNf2wGG2nvtYFptHHzYFo8DLoVPwyEYfvMJkdBjm18PaE6kAmJv/KMKOrP0HITwdgmbfvrmxSNCo7QFpIW/bz7yqyZ3ss/RJS9m0/XlQU6EOEDnxYtggaVAD+lkj815VZyVfX25y9+awOS+mFO4dfCGTZYH6+sE+9xqR1GNVzNONX1KR9hNj5p6uqDn7HRd2i0bFNb37uzXjMVulTXQmc4tEDgZpjFEu6QSTCQx1XfTuDPWYQprcMb3udn2cPKhcivHKuo1GUnfE6PACx7jz+MFzRar4NfYxSuFtrUdWoDLSrgfaZ1+9W3Zi1ayRcJix0V3HiKPrGtJXbbYgm6MvWGl9RpXY1y7VL48crVhPCVLNd1F7xRB7rKlvDv2JOpPNg7PBpJtxrhY2GcCuU2bQWJiRjrWDR+Q5sD7cSNGBD48wovM4/hmg/PSWaCUkQ4ZR1yBLwKfyyI8rXDSgikEmIhTcfuGdFhvEzNvPR1FZrHHbgFoSLo4jlf0ZIJBWAP1I34rUB3LrweTJhT2ppaGD8i3jGWrBtbC5Ig+trijcumdWCmjPAAQ7afx++IrP+7UV2cu/3iePjv6IRR20yTL
 ph6YtNWx
 gYbMPj41C0v/FETPqkSCEq3k+uDf9N0/OepBqzcz2HZVIsCE8sBTJcnO+oN/lKzlYzto6tfgFrPDgQDQG7YS1WWoXiE1uFuy40vyiW/j4PLL4YjLfw4iZJWI6twM4vbkNbk8yV/aWHPgCZ1h2SAK5aXC2uPyTSPZxC1qdG9H9AHUbmLr3B1R/KepdX6XC9JSV/+VWJmaWxwJ07cWfy7lRThXIsd91XtBhb5X/3oX2MsVeavhYuGZyFtQ2KCrG7I9g96snE6IBD0QDg4a2hZe66pqgFlOim9TT0dcFOOBmGSlB5PW3ugjeIG54BbTDKQaFvl0b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

First of all, I do agree that the comment should go away or get fixed up.

But...

On 10/6/25 07:54, Joshua Hahn wrote:
> This leaves us with a /= 4 with no corresponding *= 4 anywhere, which
> leaves pcp->batch mistuned from the original intent when it was
> introduced. This is made worse by the fact that pcp lists are generally
> larger today than they were in 2013, meaning batch sizes should have
> increased, not decreased.

pcp->batch and pcp->high do very different things. pcp->high is a limit
on the amount of memory that can be tied up. pcp->batch balances
throughput with latency. I'm not sure I buy the idea that a higher
pcp->high means we should necessarily do larger batches.

So I dunno... f someone wanted to alter the initial batch size, they'd
ideally repeat some of Ying's experiments from: 52166607ecc9 ("mm:
restrict the pcp batch scale factor to avoid too long latency").

Better yet, just absorb the /=4 into the two existing batch assignments.
It will probably compile to exactly the same code and have no functional
changes and get rid of the comment.

Wouldn't this compile to the same thing?

        batch = zone->managed_pages / 4096;
        if (batch * PAGE_SIZE > 128 * 1024)
                batch = (128 * 1024) / PAGE_SIZE;


