Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34EAECCD184
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 06:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7974A8E0014; Sat, 11 Oct 2025 02:34:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7485F8E000E; Sat, 11 Oct 2025 02:34:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65E3E8E0014; Sat, 11 Oct 2025 02:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 556148E000E
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 02:34:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CADE05958C
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 06:34:35 +0000 (UTC)
X-FDA: 83984869710.19.7090FDE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7E3AF180003
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 06:34:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GpuRKwpb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760164473; a=rsa-sha256;
	cv=none;
	b=dDDh7a66f/no+K5pTJWEY3TRNjKnJibMohKZtyLn2mDMRQirYKTqT5Ho9tZNelAEWq1M65
	LA/8sg+wDnJpFRbk6X7TCZC2YSYt/q2B9XgQEzJNP65gTT3MNRNvLeX/K+ojymRA9kEgwX
	+9G3J1Orvygmf6aj+B/iuPX2+h9kNx0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GpuRKwpb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760164473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5xSKcJLMWroD8oOqsL5TJgpTOIHvIg05ecSG07oYy9s=;
	b=2seMcd8rOAcyEn6IvwWN7C6ISRPcmSFn6NT/WMV14e02uVTuodyUmT7qk71LU4jBFtEniO
	3+K1rkDrAa0L+E3xQ6QBFBuCh9hW6QGgoN+nTmJq/2iVIE6uW+a4TPVQ5Sk6PtobM1c/Jy
	CjVhwNuOM26pzIE8lDw3ofp5WvCcZ6w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760164473; x=1791700473;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZHoGBUbqzplr1SqOVtjjpzhNhjDVkJ8UthME/KpzTy8=;
  b=GpuRKwpb5feBKRsoFo8CU4lzGAf7o8B9JPDmBlq9vLjFtgUypJexDd1M
   hP3B/qb2ceBE8JOjPmKX+MRPrJbQbbas848jPnsT+KmUmeMmLqu41d6sj
   0P0BwT+l2KCIdLBGhxfS1rk3QjQJkONSDWjIKra7Vi+0fmswPvLySsD9t
   A/nTZm81q84KG0pjJun6n7uoGo22kLG+gM4smZ0BuZYsPaYgyqHDo15K9
   pi8DbCMIghrTQ5+NrQHF1Jyaly3IGLw5BwIWu8EUj69jvCVYF+VBZMe9F
   PIzOTYfkqdQ6Q5LxHcR5GARz9shDOFFV6ok0j2ATeOHVV7hlFh4UFuvXA
   Q==;
X-CSE-ConnectionGUID: qpqNyGJTRPyhNydyRnRe2g==
X-CSE-MsgGUID: FwFct6fCTfqy7FGckT1zZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11578"; a="87838068"
X-IronPort-AV: E=Sophos;i="6.19,220,1754982000"; 
   d="scan'208";a="87838068"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 23:34:32 -0700
X-CSE-ConnectionGUID: VcSPh3W0SuyKVz7g68oZuw==
X-CSE-MsgGUID: hnXs8JcbTyOib7kc4CEhjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,220,1754982000"; 
   d="scan'208";a="204824426"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 23:34:27 -0700
Message-ID: <7a001cb9-fb09-487c-bfa9-e2d329b0f6a8@linux.intel.com>
Date: Sat, 11 Oct 2025 14:30:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/8] mm: Introduce deferred freeing for kernel page
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
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <20250919054007.472493-7-baolu.lu@linux.intel.com>
 <5b494700-a3af-4feb-8c5f-1ca424ad9841@redhat.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <5b494700-a3af-4feb-8c5f-1ca424ad9841@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: su57j495ugbrh5yosj9c3s84mwqgn4yx
X-Rspamd-Queue-Id: 7E3AF180003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760164473-635714
X-HE-Meta: U2FsdGVkX1+bJ1JcnxGWBV3MKyP4UrA9qz1sclN/d3yVUktGo4DhU6uDVCJCO+g6rH1YkP51Fe2wpF5JwSsI/LQdZXVAORwRqhM89B/u4JBXREeljO0/zNp5ZhXUZZX/kBKVxQO0Ue8z1a4RRRN1Hk1+NSKRUtva3XlNSvi5X5T/1Vd/O/3i+Wfg61z/5gkHsHNKY72RtaptaUzFKgcjSV3FxvRMgFMebkvqcY8N29DT/ma8juDR4BJpP+G3w0Gpg+AZPeLDR5ISfx7yDLZ4qjvPcDPuXEM4axEy3nmrp+tBR+iO/XB2OVi/uOG0pVvVIBWti6OvBbUfpe5XC9kFNZ5ykxUauAYRNOv0fMI/e6pWbMco9O8d4Przgx9jtbWiLtNeuKmeCVptJqE62k3dnyR9RAQ05Bfe304iqKyui83kSmtSe3qkPzU2r95HRQZ1BCvQuufxXtfJb8WtOv6bKWyP3y2Q8ZEwHdyonygaPeDPmzIx9STw0UIt6IJqsLrUxZ3K9GDCmUgD+WgzSJRZBOSaz0+Wp+221LcEMxN+ydMD7L5B6Z5epYSgntp0fUraQin+nUMPQZO4+bq2sdfDzCVmLUjsHrTKvEjBo4q8QKa5548xNkCnSfMkbw3OsHTGxlkh+Hm6RHVxHngm0YUZ1OnnhcWiJ4MjZG1qzXbyv52on/9FyGqXs/44FoHPQ08qmX46RakHGF+TSQvIH8Jmt9dOdIPwDPdy1tKb29u4qgQm21rnP3LbIv0WvpU6bt1+IqoXtZVSxCMnT/VH06PN+L5eeU91yHteq4fTE+KzkuCEJI1Lr0iTy9lY+hWzNuXZMZGN2dv2VSy7pghVtdD990BxaqlyZucPntVpJpnYyBPXxC58jQwqRIWMepFq2Ss0GuOTzQMyzN14N5L4/ZCd63dKQy1kQefFlsRBA7GkHwd6fX74ZViwSEzQMroM2QUz0gH8yn/oaNmrzcfeIg8
 VW4skhph
 9cxqMYGywe7S7g6uqSVt6F2nt8CvzuhDEYsHhgyFPR3ilME36+c8EM7uOefOYiIqn2mwqDUmguGLSOLGh+tULqCl+cqK4TIGG8Hf3QuDCU2Eh7watWhWpXgQh4C/QP/KZ0iFyF/bONAnvN6L7lKeV0B0bFfUVCjjsAZVvIE+pYNNZbUhmw6XM1mNhkEKgWIalcOxC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/25 23:47, David Hildenbrand wrote:
> On 19.09.25 07:40, Lu Baolu wrote:
>> From: Dave Hansen <dave.hansen@linux.intel.com>
>>
>> This introduces a conditional asynchronous mechanism, enabled by
>> CONFIG_ASYNC_PGTABLE_FREE. When enabled, this mechanism defers the 
>> freeing
>> of pages that are used as page tables for kernel address mappings. These
>> pages are now queued to a work struct instead of being freed immediately.
>>
> 
> Okay, I now looked at patch #8 and I think the whole reason of this 
> patch is "batch-free page tables to minimize the impact of an expensive 
> cross-page table operation" which is a single TLB flush.
> 
>> This deferred freeing provides a safe context for a future patch to add
> 
> So I would claridy here instead something like
> 
> "This deferred freeing allows for batch-freeing of page tables, 
> providing a safe context for performing a single expensive operation 
> (TLB flush) for a batch of kernel page tables instead of performing that 
> expensive operation for each page table."

The commit message has been updated, and CONFIG_ASYNC_PGTABLE_FREE has
been replaced with CONFIG_ASYNC_KERNEL_PGTABLE_FREE. Thank you for the
comments.

Thanks,
baolu

