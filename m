Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04A8CCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 01:33:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15B388E0016; Thu, 16 Oct 2025 21:33:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEFEA8E0002; Thu, 16 Oct 2025 21:33:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2D448E0016; Thu, 16 Oct 2025 21:33:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D09988E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:33:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9047F5934F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:33:24 +0000 (UTC)
X-FDA: 84005883528.21.3D5F558
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf14.hostedemail.com (Postfix) with ESMTP id C7E3610000C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:33:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=n1RjOknR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760664802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/2cJGWDfvVL4fHNuVReZSWnZo0xfggHECckgNQHJ+BE=;
	b=W+1CUA2b5qRnfDKt6zuCD9rS+BbewR7h7zWi41Nl4GF/LBqj1tW7+wtwLWmGLeGh9K7zma
	UHe8h9MymFC8uIlQY2TFDqVPjGzm5H3IsS4mRPJHnbhUEnL2ndNUVyHpIcLtVVL3Ez8R+a
	XbR1QiPW/RpK5tvdEHBr9Xn26li/AVo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760664802; a=rsa-sha256;
	cv=none;
	b=kqa+7r97QatQjrA4UpTalaVqY6yUDE0WuaWvoAmM4M31QNQs7cNZXcXBo9BZ1UGNo16Iw2
	E3NUEGG2jGMNuOMz+5VmMUq3xc/dFzfILRISbkxpwun2B3WdWBgFNL4rTSMLqn8EJnLS4R
	VZWsh/FvcXXWJU8EzqpjiTQ0DNU83HY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=n1RjOknR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760664801; x=1792200801;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=InToWeKulfFCiasailhcft0AF/qT17xeW6w86HnWH7M=;
  b=n1RjOknRsp+UZv6ClPA7BGrlsJU6Q1wT7dzfDzxMJi21oKgbCVLxjgNa
   H2ZeZi3JnYsFGBmAhVQeRsFflbjZyL9m5f7XCWajnNNAg8ypfJRcynI61
   cDeUdddiFWSrXE9wwQXEjtkDQVKF/mW3ABwbwDvJNKWnhZJU6jYsUfczH
   OicXYSVSALFY13e54fkFjpkFcIoz8esSPOQe0Ww6StA9K4PgyPEyWIBxB
   mhml5FzIzZdKhqXlYPySeYYpKcuJQLRWwaTvKHR+REpQX+eTozYD32QsI
   7vhvcpnVGga2sE+2jUJg1m4Se/G9qVZOxE1RX8LBC8+lKe4UwEP/EgdoW
   g==;
X-CSE-ConnectionGUID: ZX5YcKSFQWyElhCehrYVWQ==
X-CSE-MsgGUID: SjixgWWyRSSbAJO+tSjYqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="73541224"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="73541224"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 18:33:20 -0700
X-CSE-ConnectionGUID: 4hyF6p1zQ125ZX6UsPL5oA==
X-CSE-MsgGUID: ip+saoXoRX2OIkKrk46nPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="186627047"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 18:33:13 -0700
Message-ID: <ba9e0f6c-1d46-4447-a694-debacea44f48@linux.intel.com>
Date: Fri, 17 Oct 2025 09:29:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 6/7] mm: Introduce deferred freeing for kernel page
 tables
To: David Hildenbrand <david@redhat.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Zijlstra <peterz@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
 <20251014130437.1090448-7-baolu.lu@linux.intel.com>
 <e62bad6a-bd49-48d9-aa2d-9e2022f829b3@redhat.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <e62bad6a-bd49-48d9-aa2d-9e2022f829b3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C7E3610000C
X-Rspamd-Server: rspam02
X-Stat-Signature: 3u7nyhmmdpudbuiqcwfps8qmzh96neog
X-HE-Tag: 1760664801-574630
X-HE-Meta: U2FsdGVkX1+SDNBQdWgha/z6hNPsEtvJcyNxOuuOiiFlwIFpUIt7Ua6du0Y/lgEFONk1M0YzYggsgLkBgWgC5zJkY3QYBF6A4qexf5HlSCoGNBY+fxFnmVjIMYQm5tps0+tadrt7fN73NUBGB4G3o+UUHeEqZPc3Fiwp4iXxn2vtXolaRLjVdUQ1NEXDS+BH2Sm+K+ynCRQ31PbCefKm6Wk+4bhbQuL0NFvidK2KmnL+piZCEVtT1OWj67oR7XVt43xBv2ohjIZzDgln8EK6O8NXFFHHOp4qWhq7MF5TjA4/KnQsAvcra7XPCVlhmwdCD9nqi3nPMSe61w0UVFP5vNJLd4jrDMcTdPzTKT15/sGlQRm8gVYFNXBNl4+SiVIPtJ0VyqnNW+MnFwQ2YDephIrV+011brSrosHd5K2bQliMK6RPjGAHt/dN0FnPIpNN2gN8jCJyrYptzeb/diyq+Gav554EIq2X8ZGxkBHz6fyW04KEcHyjluANztj5zKihz0tYLTzc9Yz1LAGXTYoAN7QiZ/Eu7BYAVVXo7TPEv4AuTfUk2OdSYLD16OpdtlB5wLagprFtLFStK9XLmaNQvI19GCwc3FHHy+qC0zfDdunTRG8kGvxdCsls5QrwcreZVIGjsev61gpyIrTOCybOSriqdHW4p9WGb8PxIugr+mngkDmpEpOb5G5PoRXjysKUsIxAU6uhn1z0xHUNuCMuXzuV1H0XY0qSkAnoWMtfopxc9RuRPbCs5oEmfbQj3WoCDCSS2qCWY07T6Bcr86MCOT4c/FCxlleDGB2JNRj+IL+3ioCoJkvPlCiUQqMR8eZqKPuA9vavWmugnapffOXPyVFiXDsbjl0OlS04L39qKTmDchdGpkaVFaufvIuaiqCXKfCQTFYTUY8uxj4ULLZGz7N5kz6cArgtq5YQbBLy3yaCo5MCdp3Z0a7kcSR7p2hDafHL3bG1vYHwwnLT1PL
 7UJL20nz
 NsgYt2/Nj1HJy8bSEWtj7v7Ry0tz0BDJoPr7GouYtUF0ZPFO4D89+NQ3/mWeTI16UhQ5T9BAmhr9VLpp8dmOIXT/qOFgaovFvLPsjvh3yNgbhjJ4jeYZetaAjlY3MiTXimiv/Jz9ZEcnrAfcXCcKahl5QEsd05qddXA/oRJh7VY8EiB6fbPk//E4uFpHJ/jZJ9L5RlJ35orvpm4KpogBh5FJnMMopJI3glGiMOoueB0Z3VxtY0DJfrJmX00Zhnl85aUWJilWMV/1IitZ+CsLRRbpbuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/17/25 03:35, David Hildenbrand wrote:
> On 14.10.25 15:04, Lu Baolu wrote:
>> From: Dave Hansen <dave.hansen@linux.intel.com>
>>
>> This introduces a conditional asynchronous mechanism, enabled by
>> CONFIG_ASYNC_KERNEL_PGTABLE_FREE. When enabled, this mechanism defers the
>> freeing of pages that are used as page tables for kernel address 
>> mappings.
>> These pages are now queued to a work struct instead of being freed
>> immediately.
>>
>> This deferred freeing allows for batch-freeing of page tables, providing
>> a safe context for performing a single expensive operation (TLB flush)
>> for a batch of kernel page tables instead of performing that expensive
>> operation for each page table.
>>
>> On x86, CONFIG_ASYNC_KERNEL_PGTABLE_FREE is selected if CONFIG_IOMMU_SVA
>> is enabled, because both Intel and AMD IOMMU architectures could
>> potentially cache kernel page table entries in their paging structure
>> cache, regardless of the permission.
> 
> See below, I assume this is patch #7 material.
> 
>>
>> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>> ---
>>   arch/x86/Kconfig     |  1 +
>>   mm/Kconfig           |  3 +++
>>   include/linux/mm.h   | 16 +++++++++++++---
>>   mm/pgtable-generic.c | 37 +++++++++++++++++++++++++++++++++++++
>>   4 files changed, 54 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index fa3b616af03a..ded29ee848fd 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -279,6 +279,7 @@ config X86
>>       select HAVE_PCI
>>       select HAVE_PERF_REGS
>>       select HAVE_PERF_USER_STACK_DUMP
>> +    select ASYNC_KERNEL_PGTABLE_FREE     if IOMMU_SVA
> 
> That should belong into patch #7, no?

Yes. Done.

Thanks,
baolu

