Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2715BCAC5B9
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 19:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4208E0005; Thu, 25 Sep 2025 15:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 454228E0001; Thu, 25 Sep 2025 15:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31BBA8E0005; Thu, 25 Sep 2025 15:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1DDE28E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:59:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 961825914E
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:59:21 +0000 (UTC)
X-FDA: 83928836922.18.5AB483B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6F9B91C0013
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:59:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L+gUNV7Y;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758830359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VtJf1GszDLJtjJQdHSN6ZaZI8gulmzhtocHbs4vV4bA=;
	b=K0sMuoHjBvNUWBqPn4kNgkQFFuvqB7WQsKknxaGLVlseOMuhDm1OcaHEHyMngHqhHJXFFH
	u56VYiSlR0LJWFCFngd13q88A++jLFlrVSAgbBNTkIh3Sln9rivQQjUy8xphQE9IzM/G+v
	avWW2Zgmmhv3XqnwppjQzUXI3JrxKLQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L+gUNV7Y;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758830359; a=rsa-sha256;
	cv=none;
	b=5VBIm+Qu73IDPp9mYTK+/LpXBUnANMXo0rfpMUYNk4I6snMsbws5WoCF+jldvwvzhAtgkG
	EUd9etit0fFKZqYzy+nE8mlUXZ2HSrPJyIMUFh0J08+nOw52hz9IL27wql/m7UEhBGVNXi
	SchKLHNQsTsi80ZXa2MZKZZz4KxZpyM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830358; x=1790366358;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ifRJk811qNPEsFfNdRG90y0xS7LckLrNUOB82ykqBQk=;
  b=L+gUNV7Y7Z4ukQUATo1CNa1Writq6U+OJlWBk6ZBJ3lfz9LHToXbFYzE
   FVgSt5jjxAikDvgTc1uNFSw2tvbQR70LNtSeGl7qmRSSmD81QR29qm0IR
   /b1KWWkH9A/Xymp9aiSBymmoGCsBfy/btJFu76ffwbaG/hU7lbU+NLRKp
   g9zScuCRacCMIAOgs6HMJRIzsCBVhOeyVCacViPoUJTg/O+RdzGuqsTsx
   2dcc+AitXWrAnYzFZIL1a25dIzKLhOnFYlF+PCLKH0GHtwejS3r+eJugX
   TaG10+SyrRrCGb5F3iFSR0fO7ybH8YqlNynk5VTivQcHZ99opBkh7jhZK
   w==;
X-CSE-ConnectionGUID: xxNsiOy0TeGA4aqh/l280g==
X-CSE-MsgGUID: xmQazLKZQBOiQfHfoTKCDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61112115"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61112115"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 12:59:17 -0700
X-CSE-ConnectionGUID: 9f2J8JOTT9OzQxVDvp1k1w==
X-CSE-MsgGUID: McENJBkSTp6URj4A/sRW9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="201105063"
Received: from ray2.jf.intel.com (HELO [10.24.81.144]) ([10.24.81.144])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 12:59:13 -0700
Message-ID: <82bff1c4-987f-46cb-833c-bd99eaa46e7a@intel.com>
Date: Thu, 25 Sep 2025 12:59:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/12] KVM: guest_memfd: add module param for disabling
 TLB flushing
To: David Hildenbrand <david@redhat.com>, "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "tglx@linutronix.de"
 <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "song@kernel.org" <song@kernel.org>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>,
 "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "derekmn@amazon.co.uk" <derekmn@amazon.co.uk>,
 "tabba@google.com" <tabba@google.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
 <20250924152214.7292-3-roypat@amazon.co.uk>
 <e25867b6-ffc0-4c7c-9635-9b3f47b186ca@intel.com>
 <c1875a54-0c87-450f-9370-29e7ec4fea3d@redhat.com>
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
In-Reply-To: <c1875a54-0c87-450f-9370-29e7ec4fea3d@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6F9B91C0013
X-Stat-Signature: nt7y546c8eraww6aay6684inc4at1m13
X-HE-Tag: 1758830358-861278
X-HE-Meta: U2FsdGVkX1/2m0B14S4EIGYWQp8E/lkLAZuLAbBLVjvCiwyGz4F417DVMzBgPG9GEvYUH26rN1oDxAB5oCmeu/Ec/Oob2eNRGGt6lP1QN6sK1syA7bcCH4623R6f+8SZIoKkpE1XhN4C9BMtRnNH5i0Px1d+9r4600V3IBcBdVv/6DZZcJJEBEfsCg9BOwiJVnXP5FdE0voTXHN1CTT6T3PbRXyqgfGLqF3gGlVBxBFGAkYzvb161U1kiPf3ItKlavPXzmOzhKsTlGLFyOtYVtDBlNJ7zSUqsNITg77G4K1uib7WChOiZkQmT0VO2yAHMvw387tnvdftFYqnV6vIdKGATb6ooq1LRiC5GG3MhCz72YXP/Hk1KuAR0heLkqh/DUImE2L93DjhGFuwnKHHAcMTH/n7B5gdbqAb9xk8ZfxBvMuexL7cdEFw6ib2/etx8zIRbX1ysJQ2gUYUiIh39kAhP+mFJ3M2TnVSXviyhqUN8/I1P/zXy68PdfWg6UEjizTKxYBQj9PJzKmlu/N1Ze2oLQGH5DZuwztMR+fEBMEtVd1PnY36lSznYtPMK5pl0H13Pcd8qNezY/8Z2bfc9nPLqxsDFKbBe1zySepm2iUAge0e0nP+bKbayripNL+40XdWivdxkNv/aOaJ3mGOYgl4QSXGG1kXx5ER/Kngiva5/HnNnaTE/vKiW/OZDG56HrVBLoK5n8t3BTfpxaEJo1PBGmPbNL1uCu5NeCck8Yl/XN8QqPd9QVl2m/YtoInsF12YOlj+8MeY2YkJR0UYCq0lrVXN+G071h8HmbVJ4CKIFGH3X3uAlN6lO6oeHHS1Li+lJ/WFWBRTvlVRcUWgilOST2RjrCN65lkppxUZu8grtJqlMI5YGcr/JQNujrsj+lxB7SUHldDAGRL3LzwKV9EBiFftPcY87Kw5T+dqttuUue1axt2QlyAjWUAV6v6iUz5b1SQ8vuUzS3FRFFf
 HFsr7z6G
 4hC3DRKQ1E2/CVsQmcEcoc0hc/qed/7plxNO3yuAPcLaWA8lvNDijnDbYJoU6SOsbIpvNIjYFBYLsOltXp7GcvmZJY/ulf6vTkhS4iIgZCG0q6TwOt0/FzBZ8VyUyjyG8KeM968r6z6egQxfy4nJaUEWgo2oO/0z8d7Mxyp6BjH96x3POzdvYZrn8WB3lmGgM3KJ9oeQxV/GOtrECmk8xfygXnc/X1m2RUfSB+YexLQl8hijjd4u+vD7qCSvuEEWgC/bXzaonv72eQO8LU8IeQDSLgs4n4+Ucfb0Uqo92w5hgQphOI4O4lShQFqp5KdVONrwcNFQjMUXq1QqSqAeleeCo5+ihm+ooEGCiIKYD9wCXySY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/25 12:20, David Hildenbrand wrote:
> On 25.09.25 20:27, Dave Hansen wrote:
>> On 9/24/25 08:22, Roy, Patrick wrote:
>>> Add an option to not perform TLB flushes after direct map manipulations.
>>
>> I'd really prefer this be left out for now. It's a massive can of worms.
>> Let's agree on something that works and has well-defined behavior before
>> we go breaking it on purpose.
> 
> May I ask what the big concern here is?

It's not a _big_ concern. I just think we want to start on something
like this as simple, secure, and deterministic as possible.

Let's say that with all the unmaps that load_unaligned_zeropad() faults
start to bite us. It'll take longer to find them if the TLB isn't flushed.

Basically, it'll make the bad things happen sooner rather than later.

