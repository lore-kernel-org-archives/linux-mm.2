Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66D69FA3753
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 16:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA54A6B0088; Fri,  2 Jan 2026 11:41:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B28EB6B0089; Fri,  2 Jan 2026 11:41:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0ADA6B008A; Fri,  2 Jan 2026 11:41:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0F86B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 11:41:58 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2BA81140617
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 16:41:58 +0000 (UTC)
X-FDA: 84287590716.17.5C25A1B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7E9B81C0004
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 16:41:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QFLdKZ6Y;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767372116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CKgdfv8RTuwrHTqSHeuNYDTgAzOR2J3Vok2ARmDoeLc=;
	b=giq1CDDddlMD6viFvOjrd3DQLeLNFufjM4RinIHsBipHDFgNvybyvixyTrT5yCxIMwZHyW
	8Ewwr6nopbdRUBcnlVUbvH4hlacxcEgvGV6OPHCXGV7+VcIJjCQourfzeEjEGhZ/+F2l2C
	ZuA4acsYXbhuBOTB4UMCWWc8ifcme/U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QFLdKZ6Y;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767372116; a=rsa-sha256;
	cv=none;
	b=TYYNqJxl7zijKCqi0E0KzW+FL9agCCktHTJ2/6LVqvK8gdB8umj0lxaxqu+18ATit2V/XM
	DFUQ8W2UDZ9JPQPdoSRq0a/3Qc+mgHO8596idwOYi/RojtHRPkfeNaczMeNQ5XW5SYy1uP
	SwXbwD9Ejxslfw+QqcaJZEwK+xkhkB8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767372116; x=1798908116;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KFOnUBOvFoPFL+L9c4KvjfxAUSn8fz9Ic3nFbWuYMi0=;
  b=QFLdKZ6Yb45wA7yvpWufNlGtWze5sLqErjAzzViRaX62clKyd1ht6Csm
   mLOXzA/TV6bQZUQdL2O/qjuidLHsEM3e+yn2E+zTei3rPkLp8G+SnviLa
   xO4+8X97Qx0+2JC/STDCnyygZoZrh0y5S9xKx+nhcxecOWo2wTPhSqloJ
   EzFdR+vsLvSEMbJQ++EzKRN/biwOfXGoTFxtXTDw3zcluy9AO571fS0R+
   TtQ1L4fgJbuZRMhPOxlwsE90byRZdHZ+FmZOJGI/8ksdo/bkWbBA45c0c
   C8D78S9H+iE9jseDG7STrqbWzJXO9uHC64gkn4EKyGy84Tu6P9NYXxyWA
   Q==;
X-CSE-ConnectionGUID: OR2D3GCOTSupr2vQip6W2Q==
X-CSE-MsgGUID: AHgmD3fHQQKQp11T+ibWcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11659"; a="79495499"
X-IronPort-AV: E=Sophos;i="6.21,197,1763452800"; 
   d="scan'208";a="79495499"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2026 08:41:53 -0800
X-CSE-ConnectionGUID: 9EUcYzkgRXu5VQKNCnjmbw==
X-CSE-MsgGUID: LWD3MAqzQ7+7gAGN2e+05g==
X-ExtLoop1: 1
Received: from dwoodwor-mobl2.amr.corp.intel.com (HELO [10.125.108.222]) ([10.125.108.222])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2026 08:41:51 -0800
Message-ID: <cea71c01-68e7-4f7f-9931-017109d95ef0@intel.com>
Date: Fri, 2 Jan 2026 08:41:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] skip redundant TLB sync IPIs
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251229145245.85452-1-lance.yang@linux.dev>
 <f81b98e5-87c0-4c21-9a75-ad5f9b6af6aa@intel.com>
 <1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: rmgfzh5ygniqjzdxg5ywszgwd4f4x84b
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E9B81C0004
X-HE-Tag: 1767372115-836745
X-HE-Meta: U2FsdGVkX19t/tu+vLlak1znskL/1Hp2SbB2mMg3N2eUondcC9GXkfjnCGekljZFaIJE/2/Q+/mQYE6uOEbvG1bAWHkoAPgIBm3jftkrONKhFYMz5ARDkznLTOy188qYDSqW5Byr5PPGMQbpbe/5YVe0fWwMuncAoUc8NRO6qnGCDvsxM40H2yefnztTjvKg0G9ys79eDMY+6UI2rxxyMa6smB2In/sy/ChdCUtmIj7ZlLWmU5SloyYbItE/4bRN+TDBV/IYeOfdaeCyd2yOxxNqEnxBny32RkGw0MFkvqDo5QcAUl+vhKeJ0vHoIGV5WCGOJF3U4/oAl+IN8ID8dRNsXlhANt/gX3g6wFFVgJ68YFHqqOqqvHMN6jD4ukf22WgjfxWP7yX6BIoQ/lROUur/3XPvg8aFmWAN1XU2Cec5b/AFWooUl/XH2+9yUQhz1Zsf6vTPY6h3MtKUKXHeaPzI9jJ6p484Y0CeXWWK0t056jYX3YTUkpE15kQ40I3JBAQ+SH+4KxBEdgPXDNhDTP0odnxOTJZLmeMZGCMoJc9dof23lLcgRWbc9Nn/DNjrmPiat1KAP1o109niMB24AJFzdQ16qxLbu3L+AC4G0UkVpeaO/1r5hEpJf5YTMloEpUQ4E+RZdq16J5VsT9kBUW48/Sfus2WiUM/jM5UYGs2V9HlZM2Gd++b4VZvmQwGSZpX5uWTSBr2GFvg4wHj1Vlyr9qhjKLiPGK58joUHm9DU05Ws0OdBVK/eje+vl1Tgi3DmZvZCdpEN4rqi93TiOhHTJEEgfSPTt6OjmDHZttBD7Q/9W7JozIGPbyQtqF8QvSwcm3SbfAPBYJ1s4bABwFoWYH4fsHCjYVj2NIoV+fcHp7wDdr5NKFRUs+SodTGqz17kGrUXO6Y0cMpDQPZoC7UrAv+IHCpfKkQ+kmEQezcC8FLhkd7L7E7eb7vzHVPl9xpRD6AlD7gCp/ZkIHM
 VuW/Xboy
 x0AJk0EgtLj/vxCytpirTj/H8TTEjlbQm2EGhwr2/eRCc3ujI3tFacMbKwx4SJpkwCgKgSRGTzFuSQ6jYbq+4/dqjhl0g7szI2CWg3xwZrpkjX0vQwmXmwdKcwpEv8VwHXreEWIazBjbgwUmMNCSEkr6J6A6cD825IclTb6HZfCT1ADnltJ8pBTcHxWOE2Uc2OHRdlGSCX2zpgKTJPb33UCUh1P57n7+cSxHB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/31/25 04:33, David Hildenbrand (Red Hat) wrote:
> On 12/31/25 05:26, Dave Hansen wrote:
>> On 12/29/25 06:52, Lance Yang wrote:
>> ...
>>> This series introduces a way for architectures to indicate their TLB
>>> flush
>>> already provides full synchronization, allowing the redundant IPI to be
>>> skipped. For now, the optimization is implemented for x86 first and
>>> applied
>>> to all page table operations that free or unshare tables.
>>
>> I really don't like all the complexity here. Even on x86, there are
>> three or more ways of deriving this. Having the pv_ops check the value
>> of another pv op is also a bit unsettling.
> 
> Right. What I actually meant is that we simply have a property "bool
> flush_tlb_multi_implies_ipi_broadcast" that we set only to true from the
> initialization code.
> 
> Without comparing the pv_ops.
> 
> That should reduce the complexity quite a bit IMHO.

Yeah, that sounds promising.

> But maybe you have an even better way on how to indicate support, in a
> very simple way.

Rather than having some kind of explicit support enumeration, the other
idea I had would be to actually track the state about what needs to get
flushed somewhere. For instance, even CPUs with enabled INVLPGB support
still use IPIs sometimes. That makes the
tlb_table_flush_implies_ipi_broadcast() check a bit imperfect as is
because it will for the extra sync IPI even when INVLPGB isn't being
used for an mm.

First, we already save some semblance of support for doing different
flushes when freeing page tables mmu_gather->freed_tables. But, the call
sites in question here are for a single flush and don't use mmu_gathers.

The other pretty straightforward thing to do would be to add something
to mm->context that indicates that page tables need to be freed but
there might still be wild gup walkers out there that need an IPI. It
would get set when the page tables are modified and cleared at all the
sites where an IPIs are sent.


>> That said, complexity can be worth it with sufficient demonstrated
>> gains. But:
>>
>>> When unsharing hugetlb PMD page tables or collapsing pages in
>>> khugepaged,
>>> we send two IPIs: one for TLB invalidation, and another to synchronize
>>> with concurrent GUP-fast walkers.
>>
>> Those aren't exactly hot paths. khugepaged is fundamentally rate
>> limited. I don't think unsharing hugetlb PMD page tables just is all
>> that common either.
> 
> Given that the added IPIs during unsharing broke Oracle DBs rather badly
> [1], I think this is actually a case worth optimizing.
...
> [1] https://lkml.kernel.org/r/20251223214037.580860-1-david@kernel.org

Gah, that's good context, thanks.

Are there any tests out there that might catch these this case better?
It might be something good to have 0day watch for.

