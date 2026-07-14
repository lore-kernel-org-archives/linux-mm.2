Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CECEFC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B77E76B00D0; Tue, 14 Jul 2026 11:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FE56B00D8; Tue, 14 Jul 2026 11:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A40016B00DF; Tue, 14 Jul 2026 11:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE926B00D0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:19:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E09CCC0287
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:19:53 +0000 (UTC)
X-FDA: 84987742266.29.F6D082C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf27.hostedemail.com (Postfix) with ESMTP id 803A140003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:19:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dFmxuN94;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aCZkw6xUYrO5rEP39TOIyxkZCiZu3ZPSrqz2vmLuQBs=;
	b=cav+yr3cH68jRVIchHmy4JCPVWXC2+L0oRySsOXAB9IUOxCBctsQGOJi+B/YnnxrqyMV4g
	XVGmdDLQjdbrwEgnm9emD+/P8U/9BkPnUHAz6QbI8dftzwjqRnGtQLNvxzqshSrJDfsnF4
	EM0U4vdiHPSwEP+ZZ18rAXSdsVJSwKI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dFmxuN94;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042391;
	b=fViiMmEZdjDCUP8OpGqxgRcMaOMhC6YDoSFJ60bJ7WAJneV7LDd/4qrFDPbJZ4PQZ55VvU
	b7TlkZDsVpYcLh3lbCTIauUiEle5uCUPShTdR3DAQr341THfjmVt+vnKoPDEWvdDJ46zY4
	wQXjQy7W7e8go6kdK8X3aEhJaks7Er8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784042390; x=1815578390;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=esUIM83rL258sK5DdFG0wJRDc+71b8kfykgRsy5DN/U=;
  b=dFmxuN94xnxN3FcyaBnSiRiz8lgAC9pBvp9RhUrvZY5/nWULWHBtg+Hv
   2dF6uhHnb2Sr2egmKz8IhNZ5ndmWmwyoTDSbqE/H27auhuY6FBQRsazj0
   ShfdgI0G6RXsi4VUjzWp31VYkREwODpphfbegiOVOQNde7dzXbwKrkfnl
   fHfbGMqewHNQXrxDHZKr87TMWhhHS5FppxjHy80SAZQue3qER4NqdBVM8
   KBIhi6vnGuB7LVK/beqrqvciu9OYojAFDfjh6jZAFUXzz4w8/NCv/ddRj
   /EGMYiUJDv3yjARpnsZ3cK5NSX54bTz4lV+8cpDppyCFklUtg18EBmqaK
   Q==;
X-CSE-ConnectionGUID: /LAPxOJ9QiWQS/WRbSSYKw==
X-CSE-MsgGUID: T9yP3R/rTnywr8vHpIe3YA==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="72190946"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="72190946"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 08:19:48 -0700
X-CSE-ConnectionGUID: gDiNFzG4QZm+kdK1kk6ciw==
X-CSE-MsgGUID: 2aROqIJzRsmirZemmKQlTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="254764161"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.108.120]) ([10.125.108.120])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 08:19:48 -0700
Message-ID: <8acb01ac-0875-4816-8826-59e15b4e30b8@intel.com>
Date: Tue, 14 Jul 2026 08:19:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/22] x86/tboot: mark tboot_mm as a kernel mm
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>,
 x86@kernel.org, tboot-devel@lists.sourceforge.net,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
 <20260714-remove_pgtable_cdtor-v1-19-44be8a7685d7@arm.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-19-44be8a7685d7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 34ejfu7shfi488wa4uooxx5j8ohmbi7u
X-Rspamd-Queue-Id: 803A140003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784042390-330745
X-HE-Meta: U2FsdGVkX19Alzu6OoKkpLMJW21R6f4T0uMvONyorQOTWxw+mWA/UN5oF8VXaTkY6GvH2BaWOR9FLY68+E+3/OR6/KYxWt7mfa8gZ/wrz0Mi2FxXVlMDRIJdX8WyZomrxJonunJukPxbE3DvZYJSTqSIopr9RpYHmmY/GLCSgbRQBiOCCdl817vGxAvGa3dUvLyJ+LN2jzv9Gr/frfY533TKDzqbrUTn4lMWusvY5CgiPZEZzfCt7q40jifssq3iKMXKkXO8Nmfb4TWETOt+K310ieCcZzLv73XWlbS/pu0j3gk7d6K64eQo0HeAHbz6A2BnBnggoaSEeWJVufRCti2h3xtYxLZx8pbCGXgVXwpIeaIp9ggD0VY27Y+H5uWWcj5u12Ja4A3jittFVda5zIDZGue4TgSWtoRB8GddkF4nGEJXMf9D9RSJJ6iDLiMKjw+rAA7GmyG49LlR1o3O3cneY08Bvo73WBs5NeMDJOqmABvzxglclwPqZcQ+pLvnqi2zUg5QdijDvhhVUOBtHd/4GGVz48dq2SUoiE2jpp3QyFaXso0V1TqG1U7Il4cWxkf33gFCJa62S5vLpe6goUp2nz6bBIVSW/ZdvfT6SdwOoLScLWayJ5ppUHpMvRdOEFsvYbAa6ciyGZ9EcqgjVJVTayDJ/curTGYdhA5yWmfpyToSEV1nhqoHwGG6oQeHfyjrEuF/h7aezaFzvNtg6H4xcyvPMrJuU/Cl89B21YSapRYk9hkaYCpwSvohhcVW+uqPj+UcBm80ZXSpGb956WNB8ea8Yw/kw/ImZsBcm4HEKyQrMIdG7a13Zj2nFd7RkkXE2oU9A9g7PEWlOZzpHJ+YvrEM/mj7ZAtNP5nYayN8NHno9oUmK9VU4lhm/UYY/JIHHFngipZ6CW5X15aGPCIKSRw0UlcLU8dk/lvHqXFHI0IC81vLxZFi1z2/flSFJtZJ6a+1yAZ52cuUQvG
 aqpXJYWb
 YXV7ZvLa+ssfp6JRDWjkltNyFYYJg87L3Vlb0+VuP0VUW2AuOfNNYfrg2SxzC1s3cLWeZp8d1QhYnXMHzoxlcrHEbRhQtJ/wyFLo5Q/u8GI2t8wrMQ5jusEwXvVVdnIduNgvTvPaKFETDvAlCjLH/U3u8Yx4Yg4Vezl3BN3lWO6OIGIAMCQUu5rYpmozro9TAfdRc43CKyA2Wk9TO6UMeOkbNby8w9LIIqgWj1+3LzprnbAtwNdE5xirvXMLq90SQfMxE05nQCCxOPfHu1qBxoJUUw1q6qQ1ZqC0fRYmZyYbHPydf+bUOscnp2q9GU6hd+6QFZRGVF0Ye6iw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 07:04, Kevin Brodsky wrote:
> tboot_mm is a kernel-owned address space used to build the
> identity map for tboot shutdown. Mark it with MMF_KERNEL so
> page table allocation and initialisation code treats its page tables
> as kernel page tables.
> 
> Having marked tboot_mm as a kernel mm, we also need to convert
> pte_alloc_map() (user PTE) to pte_alloc_kernel() (kernel PTE), and
> drop the matching pte_unmap().

This makes me wonder whether MMF_KERNEL is the right way to mark these mms.

I think this series tries to cram too much into that one bit.

Using MMF_KERNEL to drive the page table accounting seems like a good
idea. It also seems like a good thing to make sure that those mm's don't
ever exit to userspace, for instance.

But I think it goes a step too far to say that all the special 'init_mm'
TLB flushing should also be common among all MMF_KERNEL mms.

My suggestion for now would be to just go after the page table
accounting alone. Don't mechanically replace mm==&mm_init checks.

