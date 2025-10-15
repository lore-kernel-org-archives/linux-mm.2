Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60295CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A597C8E0027; Wed, 15 Oct 2025 11:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A314B8E0005; Wed, 15 Oct 2025 11:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9468C8E0027; Wed, 15 Oct 2025 11:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7FEC58E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:55:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3557B57538
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:55:28 +0000 (UTC)
X-FDA: 84000798336.07.8F98B79
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf22.hostedemail.com (Postfix) with ESMTP id 39BF4C000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:55:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KrQVNmyW;
	spf=pass (imf22.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760543726; a=rsa-sha256;
	cv=none;
	b=kM973JSYwyZx1X6rHml8JsS9cdPYdwUACDyUvFqM5D8i2nv18swRAf7XP5VM989qnbV+lZ
	I4Pf0iNx6MAPEjiuND6Uycw69mlmFqt03nL2dhAEpM9j2ZsMWH6eykeUE4gj9qC1Gst02U
	YPEiDEfX/cFVOmHz3SvHR575zzeyGmw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KrQVNmyW;
	spf=pass (imf22.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760543726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wIX/BPiSf4g7oS1xa1PtmSi5Ucf+QzFMuYW4CS++8nw=;
	b=dmefq/6dWPXP1VfQAWdHqQoJpipnUDbjlkJJfiLaT4SE0Bj1oGZ9UShUzcboz9xQZQpBWS
	xyj5e8dJErFlW2EcX/LhUuAhHIrTH5wJR8j+m40St1HeKJnACOlt/J4LBP9+ub6aJ/edaP
	/7tqhw8j33uvZVi4oKLrbEW0x+Wi/Ns=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760543725; x=1792079725;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=S9yNFLTbhi4KQGgGfnRYFdCq2kVd6d+5069UHhBhEIQ=;
  b=KrQVNmyWh/pfhm/4nIHqGmLuwwKw7jZ1V+cW2e5SxbDvunLHkj7sNqqB
   S0gb6x0v2ICWUCjd7ZPVJ9ZgvVYnbfaXSHE+u/IDQwidPHKWyqOLxxfMh
   O8eUqEBxWpS43qcQuBrWGl7ngmHMXj0y6Sy/vPLgAjPzhfk+t0fG4vh8t
   lXxVm1LEp52btKleMEeiQCrPKBb73aTpD14r6aUeckyhkZhazMzBSHUKT
   yX3ct0+6ye0k7D6pEF9jLsIj/hquV80yDhL0kxGFoJnhvel1A3Om0bH1H
   MwySZF6h+aY/b9SSzh7JGUezqtPsbqfhCdaJr8SH3bWPb1U6j0HsKOzhP
   w==;
X-CSE-ConnectionGUID: h+YSTCLyQUKV7vwdNQEJcg==
X-CSE-MsgGUID: WjROOh8KT5+rmEYPuUu4+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="88191006"
X-IronPort-AV: E=Sophos;i="6.19,231,1754982000"; 
   d="scan'208";a="88191006"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 08:55:23 -0700
X-CSE-ConnectionGUID: BODiAZaRQcaYxfgzQJiLGw==
X-CSE-MsgGUID: DxN9gEAKSyeFdMCQtcw0Dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,231,1754982000"; 
   d="scan'208";a="213156431"
Received: from ldmartin-desk2.corp.intel.com (HELO [10.125.111.202]) ([10.125.111.202])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 08:55:22 -0700
Message-ID: <ecee3200-c8e2-47ec-a219-c88e8e905b32@intel.com>
Date: Wed, 15 Oct 2025 08:55:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/7] Fix stale IOTLB entries for kernel address space
To: Baolu Lu <baolu.lu@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Jann Horn <jannh@google.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Alistair Popple <apopple@nvidia.com>, Peter Zijlstra <peterz@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
 <20251014174339.c7b7d2cfb9f60d225e4fe5ec@linux-foundation.org>
 <6b187b20-6017-4f85-93ac-529d5df33aa2@linux.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <6b187b20-6017-4f85-93ac-529d5df33aa2@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: pc7yx3g1oca68u8a4y9bhdkudea3un86
X-Rspamd-Queue-Id: 39BF4C000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1760543724-57887
X-HE-Meta: U2FsdGVkX180E8w96fDb8XL9qsOBTv/DCMd/ZWlZ1L2vvdtUp3AW0AJfM+3omR3Yryfjf7sq0o07iSu9PL7v58sDs3G0oZO6OU+4Np3mvf1OyRl0aVmfxrrX8TvVGS38RC4EcUZA23lbTe9ze8aB4D8DJhWk+GiwTv8hNlxwjUy+DYs0w/m3zut2q+U1K2EESlgrTlQMy8SYQU5Q4ahGh53Iv7zCB7sp1iO9No13F+LTwM6ub++nNyiZ34FIVYlzm3Nkx4fJYldUS2qINb1CBoAMeQ7eFqqX8fMx1DfYmzaNaVBbGvM1WNaxlp7TkAAuohl7WvLvUVmHnfFjf9oL6dTgzdcnzkQ6dukXRqRFsBfK3ypuuOtbIUozMv4urhHVPEjnbn3T6+z8bciLCFvwzFmGWT/zsYNbfvILplxZBOX4S4zL3rOl1cdZsUQ2fOdfuGr5m3NcWrSmZwuPFpa+Wo5cmkqBWmykrIXakM2wamD3zZRz5dyW+xbe8Z47etwqTzgateALdYqHwjDfGjNkM/xdDDe5HdsQ3BDH+mc8emEayCOUUEd1Wfggd2FISKYWzhsksi57MpR3ckE2X1fHUVWT5Pxak2yxk27sdQwAwq/3SW1dVYvaMm06gtU2QNNLkgicxj/KwI3D9sVFM4/5Kq9l93VSeukBJd8hCdo2MYlqaVA9joE9q1sO3cED4OwsUXK5Lg+q3WijgLSS9b9FbBJSdG5eer7Oy/ELLZGcVtolGj48DGXhRiiHaUkScWK23Aa9jobX7kn2TU3KkVY33me9jyCDCVDOWOMxLMW9NHkjG5osqfgW3kt8CSJHV4eP0a94gaFpWRTD80p1LewksVho4EVhjPZKVF+ke7bsncGUK4gPdqLouVpCk5ZLPhm+Mu4gp/rshRX/kBEQ4tPKWzJmvbH4t+z+x6U2BrtwXVooxi8reYgtv4mKjHUHJ8z8ONk9+WS9/jzJYva6P+v
 E7t8pjd5
 l1uNyUcwUkcSGZi3dAzQwHKJu9WQnzO76Oob5geu9vOjuCX0mDNjXypfWJ6XNVC+1mfcMZS2Nc6y0tk0dE3WrISdv7If1Mbs7gKDcD6H1b6Aemt1p7pWs3kpYbrZpHQ6AR4c3zGcArWWFR9sAX/SLgbhiVHgnePdrbqmSt4ka9UDPrkJ9VSBkj//cRpe2l/LFowgcP9kq/82U0sF0ANk9atgdj4RkoPHRLavY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/25 22:38, Baolu Lu wrote:
> On 10/15/25 08:43, Andrew Morton wrote:
>>> This solution introduces a deferred freeing mechanism for kernel page
>>> table pages, which provides a safe window to notify the IOMMU to
>>> invalidate its caches before the page is reused.
>>
>> Thanks for working on this.
>>
>> Can we expect any performance impact from this?  Have any measurements
>> been performed?
> 
> This change only defers page table page freeing, allows for batch-
> freeing of page table pages, and notifies the IOMMU driver to invalidate
> the related caches. It doesn't impose any overhead in any critical path;
> therefore, I don't see any potential performance impact.

Thankfully, freeing kernel page tables just isn't a common operation.
It's also done right next to a big fat flush_tlb_kernel_range() which is
going to IPI the whole world. So I'd expect this new gunk to be in the
noise behind all those IPIs.

We should double check that 0day has had a go at this series and hasn't
found anything. But other than that, I don't think we need to do any
specific performance testing on it.

>> Only [7/7] has a cc:stable, even though that patch is not at all
>> backportable.  Please give some thought and suggestions regarding
>> whether you think we should backport this into earlier kernels.
> 
> Yes. We should backport this series to stable kernels.
> 
>> If "yes" then the size and scope of the series looks problematic.  Is
>> it possible to put together something simple and expedient just to plug
>> the hole in older kernels?
> 
> Squashing some patches is one way. But would it be workable to backport
> this series manually? Say, could we send a pull request to the stable
> mailing list after this series has landed?
I honestly think we should just disable SVA in old kernels at compile
time, or at least default it to be disabled at runtime. That's the
simplest thing.

The other alternative is to have arch_vmap_pmd_supported() return false
when SVA is active, or maybe when it's supported on the platform.

Either of those are 10-ish lines of code and easy to backport.

