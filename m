Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5576C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 17:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 079726B008C; Thu, 24 Sep 2026 13:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02A6B6B0092; Thu, 24 Sep 2026 13:57:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5B5F6B0093; Thu, 24 Sep 2026 13:57:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB7F96B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:57:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 622901401CB
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:57:13 +0000 (UTC)
X-FDA: 85249412346.13.15A2174
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf10.hostedemail.com (Postfix) with ESMTP id D477BC0005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:57:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gFOOJ6lX;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790272631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7kE9HsUX44un0zsngBjEnaGDjKX5zQ1DwZixp0+UiPA=;
	b=JBlwdtUtsweKKSiVcuzdn/XwMWd3cj+L1pTdxzL++DSLEQGgW4y1/pzCGzWcyfCEDERWYu
	P3Tj3zsJOFcBGqnSR2cEzKjtEEAUCH9RT9eHdBA1N51blmA4aIbEI1QDwrwnnlCUsnjX5A
	p3O/L22pYn13PJ5avDdg1BN4aaqrYHY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gFOOJ6lX;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790272631;
	b=XYcxyM+365cxZTAtKUsaCyXvJdeU65PALd+dfmYRvKZn3ENHWMN/8gEjt8fKpIFgduT+Ns
	10w582tZ9Q5CPSnuikBzWRPAH3wPSzObQosoE0vVsY0BhC2ZDYBBgPRchW82eEup4BRjuo
	oncrsy3zeNYVaLok93x8fA8JaGqDACE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790272631; x=1821808631;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7PzxkTqNasNQwTYWLD3humalS1r1ifxDG7NI4O67jJg=;
  b=gFOOJ6lXk2+waJoHX9qQ9pQppRjsioQrgk4T/qecsegXBgr4xEn2V+K9
   wpfeQxz8Xij6kHPfrC/dW/jL3oP1ltA2D2G7Q2isZWguB53OZu4BBQdHa
   ScSefQolsjwWAhc8qpi0kVdeJjb0sbSNmImgmiHrm1IUQV6SvOfL9q2x6
   Ai4NJR91Xi/Sp6cKQaZlAgikyoEHzJ4Kifp7cZpyFbmOVhNW+BmkXa6cc
   ZrraOWSgwYDs1pA/kZ9SX1aK17EjfB2QhgkQkGkSCKtYZlo52o/pzry5y
   hEuwFkEQ3bPoiBTPYMCGeQi60spJwvyXTMHCigsWchzVfwcHxaMK6qiQx
   w==;
X-CSE-ConnectionGUID: AZ0KLgoiRCCy31cM2P7aVQ==
X-CSE-MsgGUID: Qphjo9SeRIyO/+sJNibx8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="90098861"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="90098861"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 10:57:09 -0700
X-CSE-ConnectionGUID: jvAxloPTTMG3609yo6txNg==
X-CSE-MsgGUID: xQE0XoJ1QBuNuuiki0EiRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="273317475"
Received: from jjgreens-desk24.amr.corp.intel.com (HELO [10.125.110.171]) ([10.125.110.171])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 10:57:08 -0700
Message-ID: <6a0c2fd9-b2e1-40d2-b7a1-ba93cb3c53a3@intel.com>
Date: Thu, 24 Sep 2026 10:57:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: don't schedule deferred kernel page table freeing
 while booting
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 Ingo Molnar <mingo@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>,
 x86@kernel.org, linux-mm@kvack.org, regressions@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260924092307.22813-1-mikhail.v.gavrilov@gmail.com>
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
In-Reply-To: <20260924092307.22813-1-mikhail.v.gavrilov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9xxybqeiieeq8y6hzg88jz9o9fg9ambm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D477BC0005
X-HE-Tag: 1790272630-578331
X-HE-Meta: U2FsdGVkX19G9NsULy55Q4Wqm1z0Takjw4po4qDSennTrkGPgGj4XbjZkEyYG852BR1qoX3mfy6F3+7/5hSPTQrFc1NrTQ/uwSK0kX4w74s+KMfvke/Pz9q/FjkyzEUsg4qkNwaIvBsoSYzxOkAOm20eEr36hxupIVj5ENYdtFbVf5sGVH9jlmoscjhMycGSNYR4WWlryVXJHwGqryAPy+S5+D95uolQTxRw4TL8691hQ7WvLpuMiEVb8hSvWaY0+t6WyQC3hEIuaJDcOqDF7za5AJ7nPyxJ6PFsBMkOV0cktmRtCzvjTLtozrz8Zkse+vzpfUxpui3lGn+c3UTfBwySfRJT1GnQqWLmL6l6UEvfjdSQaJB5/DKe0A2HyxmfhFpE6IZd4sTcDMLDAWb4YMxgkj7Ql5qtzd8FtBIDeJ0VmXU7847y7XZKg1Sb6CCgOpZB+qBnN5G1TaJT9I5Vm+meXt6zKCgFf/0BYwYXScVdzaek79mnNgA7tecXg040CgnsFBXCq6m61MLFBfAXYPFzuzaXdELIEkUZWVanc0BpegZlAGAfuW1DrhyqkOIpZ+xKPYnIxqUniKhy5go1P1cSOViTDc5ztcdXNUPwpTY1+2Z8G/YtBj909nCnTh7K2zg8z6n5aVzJSEZM27FlUF3LXVALB7gl6LPuL1SO5wqEujS+1BKtusyS4lURMZ39zAM2oONMNDtWYH/YeprIF1BdXTR0oFSllZuBNR1kchH7jukilc+FUon3UEtbOnazptlk9nRkQXPikpkX+JAuPMR5fNqNZER/Kbh4IJv1YnHone6dx6WS0F1SEgXOlysviqRLYYTj55ydMhF6/GA5YDgJ3ZKSIfLifZxmr1ydD/YqDS+A1MeBMHZJU/DaMN8s1MMBIUDyksHltgH5al0QezYY6DRbQDMcNGtdi9SbbVPUKa1M5UTf7RhFXXfnllQx2JYjPvEmsvGp4kr3U15
 9ljhSEQG
 6kJn3keVAPAgeUB1eteweiwfXfV/1N+kFPGEBy7Nu9CFd9H8zY0VJKlh7Z7rAytW3CQZVIemKZb2eoaUvNljHX0tQNW8N3mzgXDXYOQJhxHOw86pGUE5bCJVRHJe/j/HvP9R/BZiAZdyeMFvm0H4wABDyFZmfoJUJIPxAnItxbeBbqD/AjNTu8m11vq08ji9kIqglcxCNfA3KlX8CZjenTT1wuYx5HR253wNAquoBl/V8fOujxpfqsJX1aGKuUwJtdjyVmHSwLiQczEVA8wL9I8ac7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 02:23, Mikhail Gavrilov wrote:
> Keep putting the table on the list, but don't schedule the work while
> the system is still booting.  The next kernel page table freed after
> boot schedules it, and the work then frees the early table too, after
> the same IOMMU flush as any other.  If no kernel page table is freed
> after boot, the ones freed during boot stay on the list.

There seems to be an awful lot of chit chat about how and when the
boot-time tables might get freed. Like:

> So on this box the early tables wait until the first module is
> loaded, and no separate drain is needed.
Wouldn't a "separate drain" be all of 5 lines of code?

/* Take care of deferred freeing from boot: */
static __init int free_boot_kernel_pgtables(void)
{
	schedule_work(&kernel_pgtable_work.work);
}
late_initcall(free_boot_kernel_pgtables);

Then we don't have to reason about it at all.

