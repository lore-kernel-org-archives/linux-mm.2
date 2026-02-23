Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17D8BEA4FD5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79A516B0089; Mon, 23 Feb 2026 10:31:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75BA36B008A; Mon, 23 Feb 2026 10:31:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65D976B008C; Mon, 23 Feb 2026 10:31:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5342F6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:31:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A1F3C140233
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:31:14 +0000 (UTC)
X-FDA: 84476110068.28.41842FA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf04.hostedemail.com (Postfix) with ESMTP id 21BFD40014
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:31:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=njc7m80x;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771860672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0F4yuHSX0H2lk85Bb9AYknNgTN6Qcl5xdHZGKhiugLU=;
	b=yBdLndU6bej7FNtOuQ/JJ9LzkaNVTu/i+YahK/ygv8Jjk6n9iV8pczuKj7GsbD4p4NYn/C
	ILk48Dp/X0AvD8bYFhhWT4NPPduQSMUMI22/h/vMusBUN8ukWzfjvaGBgFGiet6zwdi+rt
	U6xbfjV2QZ26ixBuRb5GvrmjRmXW3FE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=njc7m80x;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771860672; a=rsa-sha256;
	cv=none;
	b=lkEUAej7yz4cNWwXiPByI9BVqiZWN2LlyveRsg0+n32kpfWB6/VPi06REgPmDiwZ1gJwN6
	8vYQ3Tv7/QM2umxtATwTtVe3TgzImNwyZ8PZGIOeh90J8Sg6X0MfSA8vtjt6UMZnZRWzKy
	o86+0jIyg0tmnBQR6PjuVKl8SVTupLY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771860669; x=1803396669;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SXZbasoq/CXrbVuU7cwQOSmYwvFlNuPnKTKASQS2bPo=;
  b=njc7m80x9aO+wP0zpxS4g/ds/AjN7z8wpUVJNLeoTT8Pi/l2uuixgZ/D
   reITAmyas7zfHt0oUtvUpReGcWkVZciL7eZ4H+d+tnt6whbboK2z4yBGB
   +7us7A73+Cx+w2FWLK8us6wp86XeORk5nvpOApe5Zej0nHlm0nCH50cb8
   adfo/MCMpIyO9CnKEB5yF6SH61BNIDw5Z2cuJ3iiEbKWVShaLnR+YbgZO
   Bg5MYFsWTqc+bQOLk0kmgx6jJWiuN4cgLLe7hIaCqrLZWY9/ykcyBrJ1K
   uzKQ/9+/ouFSFVskFFCfZqghSHk6QBM3nUWliGcQr9DsOTtI92zp7JMYB
   Q==;
X-CSE-ConnectionGUID: 0f1lc5hVSDGrwlOYVaBbMQ==
X-CSE-MsgGUID: F4IMwG6NSRivnYv0H8AjXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="76722066"
X-IronPort-AV: E=Sophos;i="6.21,306,1763452800"; 
   d="scan'208";a="76722066"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 07:31:07 -0800
X-CSE-ConnectionGUID: 3RdSeWRtQ1OGmwABwOqOQQ==
X-CSE-MsgGUID: HpkJ5mxMT22hY3yqnfnyyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,306,1763452800"; 
   d="scan'208";a="220144437"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.110.205]) ([10.125.110.205])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 07:31:07 -0800
Message-ID: <a0c434c4-ec65-4a37-9422-5614249124bc@intel.com>
Date: Mon, 23 Feb 2026 07:31:08 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/mmu_gather: replace IPI with synchronize_rcu()
 when batch allocation fails
To: Lance Yang <lance.yang@linux.dev>, david@kernel.org
Cc: akpm@linux-foundation.org, aneesh.kumar@kernel.org,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, npiggin@gmail.com, peterz@infradead.org, will@kernel.org
References: <2a6c4e62-1663-4a98-9adc-406a6a1ebfd3@kernel.org>
 <20260223125826.28207-1-lance.yang@linux.dev>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
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
In-Reply-To: <20260223125826.28207-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 21BFD40014
X-Stat-Signature: k7sbr5mhhc9shc8kwy1cpynwdd1mum6n
X-Rspam-User: 
X-HE-Tag: 1771860668-530334
X-HE-Meta: U2FsdGVkX1+r7BNtcovlHuChQXZ0wVnFSLLB5V5VsckJoTwrW1towJigqoSk2zlCwRL7sQJINNfJWZqCjoWPo0/q3UkCokHIhTh9hvtUalaWmA0vURwnXUOxUBzPnmQOIwT+TlRob/1mqacXiTaboKPsT5iLGZQ9EfJdo4BW57oWVnPCKfCItBcgfoWx3bHQH88NBDxnj1mQ+//OovlePMDtW+eyCDv9T+sdxQra/6PODv/Difvs+56IZPUTebE1zkRsTzzlWz+RPVt0t71V5HVp0qPSp7h0jOyriAczvCj4O0Vr+h2jIDZJmzc26iss9FcTdl+Bo+QdRGu7eQJCxTgOv411lxi9QFb2Hnp1/G/NGCNzXQlMTtzodHCi82BlbVz2eaIww4xuVWs+e/bv+zpYR5cRR4NdgRJ9oPsiAPKXf7BbaMjHTBwZCrI5z9Ow6Awq2dG2O3TWaFvIA0qN/OTsZgWlIsGmONjIayCVf97/9J8Pa/Ow8wohvUZGZIffdXe6/6KxdYQat+XG9bdJAhPIqT2TaXBhtKe5YkrcD0o0jcXpnrQS20vhfL7h59ICOHcV2Vo7SL0n0FZ7E0r2mOlsB6FywMPu0QTkoDfSv7V0iwc8EvaR3Y+3/tYTKwsFWV/CeKmI2DmOwWpyk2CWBa795fFQ2QWd3v7r58Yz1O+ofCt1Ga7ZWFWSeUVmh4dj/C0Nka1878/FqaKw42+o0pT0o6je2/VQIGiDO1LxIuO5wUWsqjsX2ujD7HoDqNhblGTEhwdffLHkzHfBuichBQ4TJ/8oVz1zmDgs7eQryfSdQGrF3ADpY+DuD5PfQrToNX2UNvRTaWEv+J7+ej8VgvsThFF+2HlbksKEnK/7zeC3d88BPyxlR0ulXNgBblS4jJ3+5mdf4OISz5nSt7E4NlC9b2NCQOQ6sjEZW5dMlkdPpvHq9NF8vUHgH2ipjGpArj0ZILKFbI1PwutXk0S
 BcboV3D+
 vygrQKVTed5wdd9AoTccJu3pLuamnDovZtnCrwZ0TfbDwyoZEZVKCRtlwmme+KaETiOlAFoZlwlAYdH0MbIG9DV7Yr+ouiuzkIdaZAAyYzXhXoxBDERs5O7DhFUVRsqOmJyP3s2BRJkYu8cbw1XPYKmbD5TE3iC63SMZfbl3eTpnWbo5swar1+s9af37V2QuWdEvs2PSKz9da/BvJ4Mzy0GpWVRvDzFhb5YuHFF/KBougKkAKcwlzpr0QBheeB558/QLj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 04:58, Lance Yang wrote:
...
> +/**
> + * tlb_remove_table_sync_rcu() - synchronize with software page-table walkers
> + *
> + * Like tlb_remove_table_sync_one() but uses RCU grace period instead of IPI
> + * broadcast. Should be used in slow paths where sleeping is acceptable.

Just a nit on comments: Use imperative voice:

	... Use in slow paths where sleeping is acceptable.

> + * Software/Lockless page-table walkers use local_irq_disable(), which is also
> + * an RCU read-side critical section. synchronize_rcu() waits for all such
> + * sections, providing the same guarantee as tlb_remove_table_sync_one() but
> + * without disrupting all CPUs with IPIs.

Yep, synchronize_rcu() is likely slower (longer wall clock time) but
less disruptive to other CPUs.

Is it worth explaining here that this should be used when code really
needs to _wait_ and *not* for freeing memory? Freeing memory should use
RCU callbacks that don't cause latency spikes in this thread, not this.

> + * Context: Can sleep/block. Cannot be called from any atomic context.

As a general rule, expressing constraints like this is best done in
code, not comments, so:

	might_sleep();
or
	WARN_ON_ONCE(!in_atomic());

seem appropriate.

I didn't see any obvious warning like that in the top levels of
synchronize_rcu().

> +static void tlb_remove_table_sync_rcu(void)
> +{
> +	synchronize_rcu();
> +}
> +
>  #else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */
> 
>  static void tlb_remove_table_free(struct mmu_table_batch *batch)
> @@ -303,6 +321,10 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
>  	__tlb_remove_table_free(batch);
>  }
> 
> +static void tlb_remove_table_sync_rcu(void)
> +{
> +}
> +
>  #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
This seems a _little_ dangerous to even define. We don't want this
sneaking into use when it doesn't do anything.

