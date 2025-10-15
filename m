Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4372CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 05:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F071E8E0006; Wed, 15 Oct 2025 01:42:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDEEF8E0003; Wed, 15 Oct 2025 01:42:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF4C98E0006; Wed, 15 Oct 2025 01:42:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD43F8E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:42:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EC95160B4F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:42:23 +0000 (UTC)
X-FDA: 83999253366.14.110459A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1BEC1A0007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:42:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bor4azr6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760506941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A8SSeERBxQaygsdynI2a1AWP1b95fA+qvMAUSiPJaCk=;
	b=SC63SThJXH2B8DkXotfQyQhDbxMfSAwEV5LsxkqQYSxN9qPOIA6iez6465+kZTOpyT5Im7
	M8ygsCChYyi5sLzP4wNpq7Fr79IxYCQ3BKGdPRg0fHRqAyn1KhTVfmRobWWWtqJXwqRutg
	Ee4NApiBd14XILIEFHLXPmHDAuQpybM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bor4azr6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760506941; a=rsa-sha256;
	cv=none;
	b=BI7tuBAT4Ji5Ri4lfwQdXu4eiHjPlFUsssbJBy4DCdI9uNVeUZ+agW+j9ukqhFr08hP2s+
	L29XWEpSDvUIGvVQv7I+v4kHFtnSt4GjufqENhVnEuN8k1fp3S1qJhHYKtHw19gvnULCS/
	GsjwtJo4o+iXRYZqbcCQhRmJLfJqR38=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760506941; x=1792042941;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=M9nLxMplSMiBhPOFPdGzBcv2AwYk5gsRtz+J0q0qQz8=;
  b=bor4azr6kpx05OV3g/RnZenqz0DWH65hZ4209B6CBGD5FGzUVaKhYv2A
   tFK9QyW79Z+UWl+bl413158LVz1bUzdA/iHnhJthsQix2kqplb+7uPZuv
   q3n0mswUo5oU+OJg0XBRUrAFlU0P+HKQV5LIk5lfH3OXimEMio41f8XQZ
   2HcgXWu+IQSEIArg2E2UH4iYTQlYwk5WTWQI74tkYEyXyFwQgAcaCAQ5+
   JrGDpA08d0A7wxz9SNtZrW9EdHFiS8Ooct0fByPaiPehKXz+Quqbb2n6U
   YmPp1/8McEa6QUVBeHr668bQrMgWE9m2zYtaCj8tktqNpfI0IsDibwJJ9
   w==;
X-CSE-ConnectionGUID: KmkyYEIgTgmV7jlW3VIboA==
X-CSE-MsgGUID: 2NtC+/pEQxazL2Y7rOrozA==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="73275244"
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="73275244"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 22:42:19 -0700
X-CSE-ConnectionGUID: V4z70CP6R2+/0T0j+LTmrQ==
X-CSE-MsgGUID: d6UKwrkaROSSKj4Zgv4T0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="181296500"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 22:42:13 -0700
Message-ID: <6b187b20-6017-4f85-93ac-529d5df33aa2@linux.intel.com>
Date: Wed, 15 Oct 2025 13:38:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/7] Fix stale IOTLB entries for kernel address space
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Jann Horn <jannh@google.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@intel.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Zijlstra <peterz@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
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
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20251014174339.c7b7d2cfb9f60d225e4fe5ec@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BEC1A0007
X-Rspamd-Server: rspam03
X-Stat-Signature: nni7zucnmnh34n9qzzzuftog1nnnersf
X-HE-Tag: 1760506940-52847
X-HE-Meta: U2FsdGVkX1+v1jeWnpZmkubBmB96VzXK5hE6l+qlnhdRvYI6/YFLpdLNNnd97e+KSWCWntnIkL2Z7u90uoIifhacwkRkQ8bTjJETritEBim1pmQOKZIRuxTDlwRk5bPoXocNYqHzmnlclTvmMveo0GhX7E1Xd8zUheMJ2QBKpwFgd2lLi1zA4EyVg18vzf8VJKrHlzt6gnSXDvfLikDeaefCkwzLcJx4FdTKrDHypjowwJkeESYYKANETyYnu1wBjAhJqwwxxZu4M7c7FHYYufKwKKn3VXCC1oB9Z7FBJTP/7FZQYCuUqEulr+Tj3Ehc4PD9mr/Bw+eJnLXbtAJ/q4DXZPgFbTpDOl9oifBWxKemJXZ2YH4IJ+JQKHhO3RBGXFSuLQfOlxDpFernyPATctwG5BVAcV8JeYAPWiMkEEqHALL/sJP9o2Lz71pnLhu4JUslf4giTi11uJefAd1+ReED82RWQFdt8kpgT/CQt6QvJ/bdgzKJzXKdhD1lHaqKqUs7gzL/uzOwx3yhGCH5OgH4fUQRezcn33H0E1qFSdvNx5ZshyaDXWQ47Q7eMV+tEQAv+ulY04nsziTUqSUHbAoCAuzidHm3VjMVHoUStU2WxKb56wHxTSlEThuS5tdzqTYv02HtWBEBjnm0SsRV9hwJWS9eefU+I01YH/XcPu66GIsGFpAkWGkcwN3crc3nruBGahn7aTskXUaPnMZSZc5qdevj/b482yk8/BNkhNMtxWoEG+xvfAR0oHsLfJTyGJriaArj79oRva56HDM0gulVfyBqEEfHBvQbc58ABYYWiIAm298Tdf8xqvY9fiVja9o8c0C8jGTue9XIiYrH/C1uYSFngXZlX69EOvPKT2jV0JbabEIUPR4gG+zdiJ21
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/25 08:43, Andrew Morton wrote:
> On Tue, 14 Oct 2025 21:04:30 +0800 Lu Baolu <baolu.lu@linux.intel.com> wrote:
> 
>> This proposes a fix for a security vulnerability related to IOMMU Shared
>> Virtual Addressing (SVA). In an SVA context, an IOMMU can cache kernel
>> page table entries. When a kernel page table page is freed and
>> reallocated for another purpose, the IOMMU might still hold stale,
>> incorrect entries. This can be exploited to cause a use-after-free or
>> write-after-free condition, potentially leading to privilege escalation
>> or data corruption.
> 
> Is only x86 affected?

RISC-V is potentially another one. The RISC-V IOMMU driver doesn't
support SVA yet, but I believe it will be there soon.

> 
>> This solution introduces a deferred freeing mechanism for kernel page
>> table pages, which provides a safe window to notify the IOMMU to
>> invalidate its caches before the page is reused.
> 
> Thanks for working on this.
> 
> Can we expect any performance impact from this?  Have any measurements
> been performed?

This change only defers page table page freeing, allows for batch-
freeing of page table pages, and notifies the IOMMU driver to invalidate
the related caches. It doesn't impose any overhead in any critical path;
therefore, I don't see any potential performance impact.

> 
> Only [7/7] has a cc:stable, even though that patch is not at all
> backportable.  Please give some thought and suggestions regarding
> whether you think we should backport this into earlier kernels.

Yes. We should backport this series to stable kernels.

> If "yes" then the size and scope of the series looks problematic.  Is
> it possible to put together something simple and expedient just to plug
> the hole in older kernels?

Squashing some patches is one way. But would it be workable to backport
this series manually? Say, could we send a pull request to the stable
mailing list after this series has landed?

> 
>>   arch/x86/Kconfig              |  1 +
>>   mm/Kconfig                    |  3 ++
>>   include/asm-generic/pgalloc.h | 18 +++++++++
>>   include/linux/iommu.h         |  4 ++
>>   include/linux/mm.h            | 71 ++++++++++++++++++++++++++++++++---
>>   arch/x86/mm/init_64.c         |  2 +-
>>   arch/x86/mm/pat/set_memory.c  |  2 +-
>>   arch/x86/mm/pgtable.c         | 12 +++---
>>   drivers/iommu/iommu-sva.c     | 29 +++++++++++++-
>>   mm/pgtable-generic.c          | 39 +++++++++++++++++++
>>   10 files changed, 167 insertions(+), 14 deletions(-)
> 
> It isn't obvious which tree should carry this.  Were you thinking the
> x86 tree?

It could also be through linux-mm tree?

Thanks,
baolu

