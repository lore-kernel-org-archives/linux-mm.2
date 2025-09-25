Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5909CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 20:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 135948E000E; Thu, 25 Sep 2025 16:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10D918E0001; Thu, 25 Sep 2025 16:24:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023328E000E; Thu, 25 Sep 2025 16:24:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1F1C8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:24:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70C1D11A3B1
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 20:24:17 +0000 (UTC)
X-FDA: 83928899754.13.A2D4AC1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4451A8000A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 20:24:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Da12jCvK;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758831855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slC/4P0RsWxy7aIL8063QZr9t5aaGLRX+ts628BnJrU=;
	b=O27bATEMHay1Jfwy7MdBJ/Z9lze7qdwVsyZG4MI5sPtTlIqFJtiUZ2AIh68nhKiIbJj6rf
	dzHL/fWa0bq9IwwP9C0ZpQqqONMmz+aXKm2PBKNxpdQwoejqS5bdjt8aPKe0Srnb9ZR05Z
	cbcqh1cOR7+q7pAlzbJqvNyVPonkL7I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Da12jCvK;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758831855; a=rsa-sha256;
	cv=none;
	b=SJnVdaVp9C72dZOhg89omnppGyAEUhbGfdp53mPuokCZ04eDUBrO45oZ+3pmKf/2VJDZI5
	hIhmfp9ztHEDcGXJDqDbabXH+fFyL6WPu0m6S1uhrXA2ga19LH37K8c5a7AuJ5fp6lJuZV
	cHyuZoMvstzsHp4XGTHrWbcykRsiSC0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758831854; x=1790367854;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=slC/4P0RsWxy7aIL8063QZr9t5aaGLRX+ts628BnJrU=;
  b=Da12jCvKxLXDQDu5nBnyRl7g3a/TqGaGDzPIBKXBVtt3WFH3FE4KKixF
   v1vHMHehsusalX+lbJ95JB+Zk89EQVRG0MKCnjPQW2yEKBR72Iyjt4euE
   Wg2+jS2x14SJUy2xcb7H6KWN0xJdLrr9YNb8qDgff4XzAQCBTpbglHBpI
   ZSRaEZx9rRzVKXQiEkxUZ9YaKuFcsLdHbUmOI09TI2vXXOm/TpFB2qmFf
   zW9ChVyMzXk+rTpJWBXfayo3ztHsOohHnbY06VHNCreP44lzuFDuBO6ie
   CTkg6WliKimieQ9rLIgVPtfkoMJJ/HcmrxQnhPgnjGbUYKM44HV/tPd0F
   g==;
X-CSE-ConnectionGUID: Gt2hKC2nQZCiEZ7cegQ6Ng==
X-CSE-MsgGUID: cRVwvffzSHacBX3Ck1my7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="61085304"
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="61085304"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:24:13 -0700
X-CSE-ConnectionGUID: 6gr1JL/yQKiAf+2CVcC66A==
X-CSE-MsgGUID: 4LgWa1IfS9mUPDKobq41Jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="176557599"
Received: from ray2.jf.intel.com (HELO [10.24.81.144]) ([10.24.81.144])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:24:12 -0700
Message-ID: <c04d4c9d-e868-4883-af92-26f142bc84be@intel.com>
Date: Thu, 25 Sep 2025 13:24:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/8] Fix stale IOTLB entries for kernel address space
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Alistair Popple <apopple@nvidia.com>,
 Peter Zijlstra <peterz@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
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
In-Reply-To: <20250919054007.472493-1-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4451A8000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ighpchixsppzu1x1oz4ed859iewosmew
X-HE-Tag: 1758831854-623201
X-HE-Meta: U2FsdGVkX19QUgM0QXoCpq510hybx0Lqb+ipMdYAe8amvCHgSZ9LmiaCMJx7Zp7FNhh2n94KNe30pS02BJqe21uWXY2X5YqHHwenUQyL9wxikDt1x/R32bVnym2SKedw2ZikDBlfCCuWCw68X4wVwtQb3ijHrmmedFaL5YIT7l5Vq3btaIpg3jdajRsLNPASEwwZVWJHN1u2fEfDsONK5Yi+gJo6viKq8iGjnl+kMWaHWcdPTGM52Q/Q0ATuXRtRytSPDSmWs8h0QDvMFHB0M0nman9Zv3a4M5Sqdl0gusZSAzKDuVWwYVyG+BQeej9OGjkBQY0HHcfHjYN67L6fGNsQdKT4wAqb5pkT2Ko/66Xf51VruPVqspHd5ZquxSRnZsLQoavT00Dd8dNoJIMe60dnGb8WNBEklrNjdLI8x0bJLaxJWLg7fhty50bncTRxnyqNM3/l8FG/E6sQtzfs4TUScMrPFveTfktEG9RDRHnEEm+7Z0l68oznQS9A8tWV9CnXy7u4jtc7ojYAEI1oOkOh9W99bZ+iyKgZkwF+NaFO8XflO9AemM//4m//Fc4q/daNP2ePuYObSR3B5wGSpC7KbDHqXgyadZmRP6g9iYc4QQ1p6GeU9dy36xTNWvh9QINnRor5tJ37vy5B/4Y6My+YBduvmJIlht4VyyecHmjLVQSLwCHqdKUI1eFsTE18dLhccXZRi+g+0w9dCKS8mLorMAiCa9t43mNz9DjJdrSS662gMTN3HuHEXyGPkPjcEsyWoIpkJa1oNDOFxNYWCixabxN5QrcIejYY9CsanP1oFLZKlYwUGqrHXf965DL0gX4a++4QSJKZIDpybr6atwRZGLKAZrYtNt+MAJvT15E1HtdoSmZ3cXahYawcTPA49BT3NgHFsnbePE8otVN/C4OIhr0fVJ0yFr6bF1fGbq/8Sw+NfXeqoiIAlWiCiMTnmg7d8sc0ofCYjupFosc
 cofYQ/CB
 HHpjtr6DR1/9OxJE8hNkBvVQoAhP88Tv6RnAdzinzvn3mQdK8sHbqOSdOL3NWtOqPiooCWcTu7JF0MXG+wHgcHH1gvlmOUZXdn/yEUoAwKRper3BmLKgDfu0eJlGsp/ImBxzYZtBc6MGS/63naU2ZTn6Jo9diQPUFRm3IJgoo6DyLhq/9INrOrdA6Qf003axZLERNPzNrhRnMw5Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/25 22:39, Lu Baolu wrote:
> This solution introduces a deferred freeing mechanism for kernel page
> table pages, which provides a safe window to notify the IOMMU to
> invalidate its caches before the page is reused.

I think all the activity has died down and I everyone seems happy enough
with how this looks. Right?

So is this something we should prod Andrew to take through the mm tree,
or is it x86-specific enough it should go through tip?

