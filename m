Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3A53CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 05:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D08FB8E0009; Wed, 15 Oct 2025 01:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB85E8E0003; Wed, 15 Oct 2025 01:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81968E0009; Wed, 15 Oct 2025 01:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A260A8E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:23:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BBE41A0AED
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:23:35 +0000 (UTC)
X-FDA: 83999205990.28.494C60A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6933E180003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:23:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SjBTOJtU;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760505813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6SJ1uOdgRs8onMO21B5pckadKM/6bHFkwrEEa1uZI4=;
	b=IY9V/GBas0kljPmQZ+C7pGwx2EsPkRqfZMjXBKdIhTH1r2dFvIYC+bDDngETFbDgh+8UhA
	ZDGuV3kYYv9pf2VVdrDrQ4Q3aw+lxirrSyeTyuDbjY1HYzCPSonQ9q0MF6pAj7X3+BHkvy
	cl1CQIiOi7HmFgDSCPkXJhokf5qS6j4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760505813; a=rsa-sha256;
	cv=none;
	b=AHH7eXY0xd3/6P8ejekjyJtHuNlIO64ReTOnM2Xt+bpHCwW/4lFBnw0eydUL8o4Nc7auLA
	wGWPlBUbPJNaMusZEi/EZmJs7VdkEetQ+GYTbXo836zpPJpSNBUM9veK37aUvqnOCAuLEt
	UQpDNtKPMjKAxeUKyY2ibkhxdh0pd+4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SjBTOJtU;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760505813; x=1792041813;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eK0inZ4rNk5w2Qq8gSVATW8wmK6XxymTxfw6OxJSz54=;
  b=SjBTOJtUvfODoq0vWNsSBH+xJ/8Rh+l13C/JZEUyudR5+6YCp740HPNo
   w4Y45Wj1ga7uobXKdo1t9YvfH/mpoziJzWd7QUtcCL4w/WkWESsRpNH2Z
   aVIpftbgUvqPHYaXg18aC48bBi60QCVDuYSnpm5mdIoWyuBpyU++yDIhc
   D79gb0myjWjnR/RoCmLBDr0maUttJGUW5OogYd16AJVEU4gI8RJhWiCe+
   KbF851JAmU++E9PtF++3V85aMPigWi/qijGpq62mK9CUYvAUUD5QgSwbA
   /f/pjsIb4hKr2Xxs/eHNy/8bnLwVLufzyRmMK62P5wTfwff7Mh3WkUBv3
   w==;
X-CSE-ConnectionGUID: uKgWckYSQ2aUaXF0qDlhuw==
X-CSE-MsgGUID: xXk1IsmsQ9uttOt1YqRZaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="85290274"
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="85290274"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 22:23:31 -0700
X-CSE-ConnectionGUID: T0k5dDuKTp6Gt6SVFGKEog==
X-CSE-MsgGUID: eUacngtfTZetlmPxF9skJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="182018745"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 22:23:24 -0700
Message-ID: <bf6ee535-cd5c-41ed-b0a0-f2dc10c1382d@linux.intel.com>
Date: Wed, 15 Oct 2025 13:19:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/7] x86/mm: Use 'ptdesc' when freeing PMD pages
To: Dave Hansen <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Alistair Popple <apopple@nvidia.com>,
 Peter Zijlstra <peterz@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
 <20251014130437.1090448-4-baolu.lu@linux.intel.com>
 <b6fdba02-cc3e-4d06-b013-fba94209e7a1@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <b6fdba02-cc3e-4d06-b013-fba94209e7a1@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 8g48qk895jw4x6k5n9d9qnbpzyz68qrx
X-Rspam-User: 
X-Rspamd-Queue-Id: 6933E180003
X-HE-Tag: 1760505812-284576
X-HE-Meta: U2FsdGVkX1/uTDLTdLr1Tzstdgz7QBGl/ZXhsTxHy0m7Ioj0ooHwonr3KBXT6xbbB8GtKzahFy3s576KFaabqrQH1GWcS2Odid33ePKG+82fG4oN3hy364X/g03mHcev+xEe4d7Xiha/ui3C+0k2QoG0LAEXM81kjxnjmg+0FR1hGi+Px16n0P2r40ku+EEJUK/V4D8WCPJ8j7PwIuaC9NMDEo5J3r0jnG2naAm0CiRtTTJwyvruEpYJ+Zbt7O9S86ZUiTDa6THDi+XcdlOoVb3pJhnWA6SIAoCl/YfTRbQ9G+TrLBVdWw3GL5Yb5ekp4/z+TvZwgLncWXFmG8V2yI4ZTIDR7yGT1hJhWIicOvp4boE4y+9qJB9fIG1rPyfv/LvICZB2Qmh6Rjt17WY7IGhJGIOeWhX1qoFI8F3HovwALcp7FCmqbfcUkn1eppqnYX9jtyOG3WJc3avial/RzvDVSTYQedYunHJ55F4BtkVEOkADmdX6mRnQu93DFE7kMc9JF0md7J9YpMEvCmjHDs1g3jwUZySSSLqc1waXLWoj07RXQTbf0WxJKQlHYsvOnOjUyA7LgydT52Z4T3XcnVI9mFc4DjRJU0Iz/908HFu+cHvsTKrGpyB42YtSTDibK//7MBBtkIz9QAwVaUpd9p7+gX2awjx7CYbkhsu+KXNGP3b17foNoJfyGQnbPdQqKqcLCP++lfwLgJyYqZkTRSKs/k6sRUzJ/gs5Yh+bUhZINR6MPK/rAhI027WdO/n+JaP4LXRtMFvPctJcNyTWrb+sRc4XA+76homeYfEeHxqBnWYc7PTgqddXRthlXN0C0zJhm5cccCdvpYbSg8l20NfYqzcrFTRIRNfOLTnL/EDnEomft4Lh0/YokhunhT0HaOMBNhePYEP7tT3SAxIzHrKZTNeJRmZMj3zFwG0o/SlI9lGvxwodw/jVh9GAtg240yVaphVBJyWeI+ZMryI
 bn15uN69
 IXFzV5ace7BuCO3Wxy9iXqAuvqoLpQ0cUL8XDSfTq2vQu/xuBRDfK06yBXDFSWwUjF1hk4mpnzDEFiI4bH+WtAvmG79AXl97H2rfTzN2fl7fXNCsqtCK2N3Xd3AnLyPRkPyjqJZHMe6IlK2OvvgVm41UuyUVGqmxxhwkhETpQBDUQJtQbhnYSKwawsIqLlyXRtY3d12TypLguQ2Uezc84cmknpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/25 07:19, Dave Hansen wrote:
> On 10/14/25 06:04, Lu Baolu wrote:
>> -#if defined(CONFIG_SPLIT_PMD_PTLOCKS)
>> -
>> +#if defined(CONFIG_SPLIT_PMD_PTLOCKS) || defined(CONFIG_X86_64)
> 
> What's with the #ifdef munging? It's not mentioned in the changelog.
> 
> I went looking at this because pmd_free_pte_page() is right in the
> middle of the action on this reported use after free:
> 
>> https://lore.kernel.org/all/68eeb99e.050a0220.91a22.0220.GAE@google.com/
> 
> so something fishy is going on. It would be great to narrow that report
> down to a _specific_ patch in the series.

Yes. I am trying to reproduce the issue on my local machine and then
narrow down the reported issue.

Thanks,
baolu

