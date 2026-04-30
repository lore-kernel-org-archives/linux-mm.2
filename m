Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E90CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9027C6B0088; Thu, 30 Apr 2026 12:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9736B008A; Thu, 30 Apr 2026 12:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8BF6B0093; Thu, 30 Apr 2026 12:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BDCB6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:57:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB75F1C0D3C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:52:06 +0000 (UTC)
X-FDA: 84715814652.09.3CB151E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5CADD40014
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:52:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LWIRUV1r;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777567924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ACxXmJUFaqpJM+rPsMg7ZbkwHWE1746v7RFgiLlxcE=;
	b=8OMKQsj46sCiyZBJaXA2pkh6ZwiGWXQ0gy1u13yenXJ9GHjOAEvKRHmOswJIBSbQnmaKR7
	diuFudvZazc/cF67oCuIrCLOsI60LDyvcVnliO7pltC17dIXnMQyhcvJztqfXoAAq6mkOd
	8rDFFu6EK7wjbHKYv3d4mFP65ZtauNY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777567924; a=rsa-sha256;
	cv=none;
	b=IA7aaZciGIhNLYcyxUZY8O6+h5MQ/AR465VHSgmSXS/ko1HMolmY1P1mHAdOtmWneOWf9f
	jPS3i07BQNf3yBciaCRegS4a7x8+IX3eRLK57EOmz94x0cv+3vAHR7NhmhWNt7d1/PRWMS
	djiICSzUULEa1pNqg8wqY+MZeJEqGSw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LWIRUV1r;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777567925; x=1809103925;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=IxARCr1BqsacoLcWn5yvwiS7Qt+sQBTsSEDWAF9CTBQ=;
  b=LWIRUV1rjOu2yAdUO7nrCQ25SkkTUEr46+L3OvUGIvdampqYBip863ld
   hZN1R0R0C3u6kPM66iKQTyvWMNaZesW6y8IePfaITjnSK2t3A1IpINVHx
   V8lGEn75tjdAjqGOGga5F4uQ+IdSJrbSCdmxZuGydVHksrOlTTXcREvkZ
   pFksuWDrtoD21MwZhNWrqKqMHu/4yW9X6vqiiO+99vr1+CC7fJy9jHaDk
   racZdXMinUewSkvprNKo3NbyXFY79ZlxdgO/NZr00mFRI5ZO+IKN4/Nfw
   3TqbOtkRhQeTltXhrr7HKtBTXfx35Dwlqh+oh/ZPOeHrrAp0sUOStY7ql
   w==;
X-CSE-ConnectionGUID: 194smrfZSWuN0g7/1A/Gzw==
X-CSE-MsgGUID: Fwyd6T/xR9Sd+Q1ufIi4zw==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="88840936"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="88840936"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 09:52:04 -0700
X-CSE-ConnectionGUID: w73/2rcuTJSC7b5+rC67Cg==
X-CSE-MsgGUID: dZ3t6KxcS/KxZ3znVMJPcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="258221482"
Received: from cjhill-mobl.amr.corp.intel.com (HELO [10.125.109.74]) ([10.125.109.74])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 09:52:02 -0700
Message-ID: <c5949ae3-5d35-4251-97f7-3b2e4c1901e0@intel.com>
Date: Thu, 30 Apr 2026 09:52:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] mm: Make per-VMA locks available in all builds
To: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260430072053.e0be1b431bcff02831f07e9d@linux-foundation.org>
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
In-Reply-To: <20260430072053.e0be1b431bcff02831f07e9d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5CADD40014
X-Stat-Signature: nngmeujs8mfrmczdjuk5e3k3okhmispu
X-Rspam-User: 
X-HE-Tag: 1777567924-668058
X-HE-Meta: U2FsdGVkX1+NUZzEQgWBP5sISONGxdaSuXmDpaRYOUgGC0TYNfHcAYj5C09miKrNB0Qi0gH6r5/uxopc4MKNM7gYZRnGg1aP6XIYXVjFTNntG+1THhbK5c1C1YuLFRupZm2iQkxDFb+5/SsVhwCje7f7+rqETfYGRwvUeJXP8GJ+mO/zOb6tiRg3NkLA4vO7TR9EmdL9V9h/VOhXCYPVo//hkLaSX5KqW4laa4ufGxmdtEXkR5DHngv5qXSmUwrEgc9VBXSkQRRQk0ApfyY2+uM6m4kHzDkNewTgNCbdUgjPcb5peKYliQ5dccXGMs/iNHjGg1KWde8yNeFsufQfSiM27nNu2KxvfJu0DQBn9uK5lSnCqGCdeQvAbmbXnWsUEIRFfG7bFtntUIEJOUSnWohrSK2s2pMO9rjFESZW2y+VQJOaskCNBStEP48AKZsb7TV1OiTG5LSOOVvLM3Rp3981Ol0SxRTCayATEWGOJhZ7DSusT/D4uhlUiftb4rcRdKsPhZ9O47TCpAHJqlF7/duON0jluFsAiduiIAWU3d7Ay2dHnIcWwEB8Zvryv0DQ2wawaBLJLej/7Dx80hHJ3H8JzotP3p7e525J8+AZw3PmrVKsrCW3lPQw15Mbzn10kMp+LrPjxc/kpv9Ushnw68bPVxMuMA7OtsUeJGOyx8jHElivym5MJ3Z4pfubMVOpzJUJWlWz1NOfCNnAXnmTVGb4FGpQinSDByx7UvO8Avl7ittAevDzPkhrTKhG8vy+zmI6/cd03YdMDbD0P+KR2wVFdrWslDwcjwqvxlqciEciLCaPLe52QvitoXPe+Mv/K877luqqL8e+AHvaEdvbs3e+lMK0H/nFI7akRWKVA+qRWs/Sxg8KLlrhspyNcSKh8lyg8YsY39FCPGro9tyqoJ6maU8OnFqZQSVrH6QhzlpvHC/CIccKiOYaYZAXvpbXnhir1OQcTin9g7aqo8U
 UQOxZglG
 ys/nKWdzD2f3KJPZJpMI0Qg6FtV2x0Yj6Tsiqe9vDHjFFtavFvgxgR/DLEaYDoHcO9V9ebdMVP6Q9R3B0qNpYK/JuQ5I41BId3+0kCOWCILkIOzuCe8qMvlM/lv3MJCM5ClduNODAbQdn5oXMmoID4ptZRmDwktNR5bCzsHu7Huhe9BL3i44xB0KbCf7pRLSzkJ/HlljA6vkDEiHL8efTqHCm5lWV7KLPKwV0OcKiIyo4OvWC1xd7uqSrOaaGokh0mQquZaGUbMkRjHjlSJFu0GJIfM70VcOMz3uN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

... adding all the cc's back.

On 4/30/26 07:20, Andrew Morton wrote:
> On Wed, 29 Apr 2026 11:19:54 -0700 Dave Hansen <dave.hansen@linux.intel.com> wrote:
> 
>> When working on some x86 shadow stack code, it was a real pain to
>> avoid causing recursive locking problems with mmap_lock. One way
>> to avoid those was to avoid mmap_lock and use per-VMA locks instead.
>> They are great, but they are not available in all configs which
>> makes them unusable in generic code, or if you want to completely
>> avoid mmap_lock.
> 
> Did you see the AI review?
> 	https://sashiko.dev/#/patchset/20260429181954.F50224AE@davehans-spike.ostc.intel.com

I just went through it. There was some absolutely valid stuff in there
like a bunch of CONFIG_PER_VMA_LOCK references needing to be cleaned up.
It also made some good points about the binder shrinker sites that I
think I cleaned up for v2.

There are three very valid structural problems that it's concerned about.

First is that lock_vma_under_rcu_wait() doesn't use
mmap_read_lock_killable(). It probably needs to, or at least there would
need to be killable and non-killable variants. That's easy enough to do
if folks agree that this is overall something that should go forward.
I'd prefer to hand wave it away for the moment, though.

Second, it brings up concerns about lock_vma_under_rcu_wait() deadlocks
in the face of other per-VMA or mmap_lock holders. This is very valid,
but it's inherent for users of mmap_lock. I think it's just a
documentation issue.

Third, Sashiko is _very_ peeved about the lock_vma_under_rcu_wait() goto
loop. Broadly, it's concerned about fairness and livelocks in the face
of userspace being able to compel 'goto retry' to happen forever. It's a
valid theoretical concern for sure. I'm less convinced that it will be a
problem in practice, and I should probably hack together a torture test
to see how many retries actually happen.

The other way to fix it more robustly would be to acquire the vma
reference under the existing mmap_read_lock(). I _think_ it's just a
couple extra lines of code, but I haven't done the legwork to flesh out
how that would look.

But the key questions for this series remain:
 1. Should/can per-VMA locking be available in all configs?
 2. Is *a* lock_vma_under_rcu_wait() implementation feasible and useful?
    The implementation in this series is highly imperfect. Is there a
    chance of a better one or is it just impossible?



