Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C505FCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 05:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9855F8E0006; Wed, 22 Oct 2025 01:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95CF58E0002; Wed, 22 Oct 2025 01:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872948E0006; Wed, 22 Oct 2025 01:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 749188E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:11:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5120C0743
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:11:00 +0000 (UTC)
X-FDA: 84024575880.24.8570BE9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf05.hostedemail.com (Postfix) with ESMTP id 27B0B100006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:10:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="PNEs+/E7";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761109858; a=rsa-sha256;
	cv=none;
	b=C3kERqnAa77s0MpTnPUxd+kyhNOTIAAVyO7e+I09zVlbM4QRIbxxoOcjijCb6CctGtNP5h
	q+naSU/SPS5zR9+ucRzPoT4neZWbGOnnSqn8aQ1azNdChgan2yZPm2LBieB/bHi6etrrHE
	0oRj9LeRxfjMFliwUlRtHNLSeMd16jA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="PNEs+/E7";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761109858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7pRLrlRO+U0HxfbJ3aF1UqUkueswfcs3GrI4cRaj+Gk=;
	b=u/nSu4xTzwf5nrswFCSnyrUMnpAN+H3DUJOZgV9Uvwv1EN9dDk9/d6x6LZtMyW2ri9CxBJ
	0itxXoJ+4Fk8kVDfl8msmER/baYiBto4MLCf49SMS1H0ZarlB5G5VT+9Mf3Jd75qSNFt1N
	wE0/i9wUYgiNU/+sLj5rwOLfOWlVlAo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761109858; x=1792645858;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sa3pkvNdt3+2ieOyDtANYF05yDX/GehSlt5KkTBOpIk=;
  b=PNEs+/E7mAx1hLMw1sdG5tXgVJKSAaLsFGI0QWei06J06P7Rrr0v33wA
   ML6Ix6oTwc9FMoH87Z1w+JE2K/g7XtT909Lg11ws/3UQn7XnDE+Q7PgDF
   3gzx/WuzU1IK1v7QvdJO2h8VjVtBDyiSUPrQYpwnjp0ZTjk+aMjUK+5Fp
   m7S2pMqxiYqWl3Oh1CMF1KurYyteK3JBDGiHz/wx4L3kBy17MEaWB4vjx
   gXCSXhXiaSwEfnTaFvDeY5kiuBE3u6WQnwdc26zSwRIkZu0pvMfPshg0t
   ozCZcyi94XW3pA5bby6ZV1ZwUe6WTFlwiDOdwkBJq6wSItIp6r22NZzmM
   Q==;
X-CSE-ConnectionGUID: UfMYhcAFSPque5IdcKMLuw==
X-CSE-MsgGUID: zCJ7B6jER9KAsuS90/Vczg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63151032"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63151032"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 22:10:56 -0700
X-CSE-ConnectionGUID: dxfXMIS5SPWjB3eWAnIlqA==
X-CSE-MsgGUID: DjyR4X0YT/ijS4596uZPJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="214718411"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 22:10:50 -0700
Message-ID: <16775184-a98b-40dc-8fb7-168f90edb427@linux.intel.com>
Date: Wed, 22 Oct 2025 13:06:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/7] Fix stale IOTLB entries for kernel address space
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>,
 Dave Hansen <dave.hansen@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joerg Roedel
 <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Alistair Popple <apopple@nvidia.com>,
 Peter Zijlstra <peterz@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Jiang, Dave" <dave.jiang@intel.com>
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
 <20251014174339.c7b7d2cfb9f60d225e4fe5ec@linux-foundation.org>
 <6b187b20-6017-4f85-93ac-529d5df33aa2@linux.intel.com>
 <ecee3200-c8e2-47ec-a219-c88e8e905b32@intel.com>
 <11cad2be-9402-4d45-8d2b-c92d8962edfc@linux.intel.com>
 <20251017140101.GM3901471@nvidia.com>
 <c3eee56a-7fe3-454c-878f-cff37467fb7e@intel.com> <87zf9pjsg5.fsf@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <87zf9pjsg5.fsf@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 27B0B100006
X-Stat-Signature: kpze1yezu5dm5nsriqk1g79si1e8pt67
X-HE-Tag: 1761109857-328038
X-HE-Meta: U2FsdGVkX1+b9W9B1hbOMriNfgDxzvv6oJWnaFWpijTc+hgCHF0LFcL3YaE8KeOphfljElBnfpnA426JGguoqCBvsyTvcRaQ0Jfii03XmoFe7QxoDbPYmMQe+grpRl7abzRLr2/wjYnrob0C4LXUBLpCJWr8Q9Qjt1VmcUYUnBA1w8nBacspwybohiPyh6M7a+r2d/cAeeWhjm1Pn+ybSvJl8AiPxGdOuJtRl/Dnu+BTDYAHY9RYRGEm6y5IOc1FVMG7P66qKcWoOB541Mb0FodhDxxYxqLU+7T8WTOo5llgxXZ18qyuoG+uWkydbKBgN71MZQManZesy4/nlGbHNzcp/NRAH0kQpFq8P7W4rI0YjtK7WHHPdmsqUYVIqe8HbBWW1+S6L14LKARKl16ZUvkqRGzPlF5vNcUXMS12fhEdeQCVp09MtoxPk9eYE8L5oO6MCyaTOK8h+JdMC2eGU2qEqYTdEgUnM9rj6JecdK5eIdKinIXWan+JM5cyOXJjTPbuCLA3bUlyqLf/s47u+9wDGl++80wPW7Ho/1LiB8z1a9pA3ms6Nn3pRhIYfX+TfZhN9EZIwTnVQ6TKoPncF1CL1eZsGdOiPyBLK80pNuu2HpJjDCl6AEB8HDjezbz4FaygIzxy04jIU8NguLMPSRdFUyLXYhQhoHcLc4EDUukD3GhExdmKWQEJcgOOO2XZYqdqwyBFSjgzK74Gz6i6SQQiTU58SrWZo5lR+U2kXe8kRAybW60Ezv1kCteQJHT5BXyfDUrOZXSwm46C5VnjSAjaoPCGN65wxA7dEAl0Wd8Z9aQPoAQzgAjK3HbrXWN+oeKDtku6cVe90Cryg2rKOto7OnjeCYj/OL6YLmrUgjV58bKGUSchuuIjWOxT9rdhyHV54ZwMdzVHPzazSBNXh6evhnDeqHx16AFXvVkYr7hTSkzGoHeTEIhjyYejA0kp5KPH81D29yUZPaydLNk
 X0aoX7TT
 bqqtAyK9mTR8cML5vwE9UG13wFsE6NKqT2SNpxtzUAttKUz5jJSVjyDJ58zi1KrAsjBXFid66TdX1qC3K2FfTgPzb42Oq8EZjmZj3CalZYmOLA93ObyMmbe3Q46xDwlqjmeWbaukao9FDOT2X9zdWfrApsEeYxzh8jZP2eSDWqOzsnNKd7x8uT1coDgoEOuGdod8jpMqMtA4TfzRebkUvbXZR2mI2DfzUiRfm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/18/25 02:26, Vinicius Costa Gomes wrote:
> Dave Hansen<dave.hansen@intel.com> writes:
> 
>> On 10/17/25 07:01, Jason Gunthorpe wrote:
>>>>> The other alternative is to have arch_vmap_pmd_supported() return false
>>>>> when SVA is active, or maybe when it's supported on the platform.
>>>>>
>>>>> Either of those are 10-ish lines of code and easy to backport.
>>>> Hi iommu folks, any insights on this?
>>> IDK, the only SVA user on x86 I know is IDXD, so if you do the above
>>> plan you break IDXD in all stable kernels. Doesn't sound OK?
>> Vinicius, any thoughts on this?
>>
> This won't break IDXD exactly/totally, it would cause it to be
> impossible for users to create shared DSA/IAA workqueues (which are the
> nicer ones to use), and it will cause the driver to print some not happy
> messages in the kernel logs. The in-kernel users of IDXD (iaa_crypto for
> zswap, for example) will continue to work.
> 
> In short, I am not happy, but I think it's workable, even better if
> there are alternatives in case people complain.

Okay, so I will add an extra patch to disable SVA for x86 arch and re-
enable it after the kernel page table free callback is done.

Thanks,
baolu

