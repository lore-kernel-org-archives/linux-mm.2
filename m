Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61C10C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 12:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05B616B007B; Fri, 24 Jul 2026 08:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27356B0088; Fri, 24 Jul 2026 08:05:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1976B008A; Fri, 24 Jul 2026 08:05:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BFCE6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:05:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 06E7B1C0669
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:05:58 +0000 (UTC)
X-FDA: 85023541596.12.C8B100B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id B2EC612000D
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:05:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PUQLs5JT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784894756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HIw1cBDk2Xx2IQU86PXttMNWviACCG8ueYO4k5oUpTA=;
	b=y31tJE31JrJWqVFdFeIKpxtWY2EPR33yZisqcJrf0gTHC4AC5r3oXOhX4yrM9Y5tS7H1bL
	0KF1r1oIdnMeMpGwhz/1kFfG9fx75ol82L3fiiJqHxEP4Aj6c+PecNfq9nD1gM3Z/Jjs0K
	BCFARrO/848+n34w+x5UwmmXCJvPKRs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PUQLs5JT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784894756;
	b=HQgrShqqQm4XiR8Z2ZIPugtdMofCafCfn4FhXStWRFUocNC4jJbnFjhcYSIC/OQBCpPHcg
	xwINJA4pUYUt7v7BjdBvIXWQ/YK6GQGFFIUST9nMGfmtoJFe7LDk+biavEB4rEKkiYVwjf
	FuGLSUL6J+jjU5GN++6RmYOAB79aPDY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 383361476;
	Fri, 24 Jul 2026 05:05:50 -0700 (PDT)
Received: from [10.164.19.44] (unknown [10.164.19.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 584453F66F;
	Fri, 24 Jul 2026 05:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784894754; bh=H5Q6O3f+4VsLMRu0BEb0Tqa+RIlw9y6bFNPPqXhmkJk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PUQLs5JTDwtG4lUIcvJ1bkbL105LXczgPsxaMjjS2Ymbk3kkkkZIjBzs/XZPt+cnI
	 fBquC+M7+yOr2KGWvreF0z9TayqdV1x3mBRT52lDxro1OxBwvLDz8Qbnp1opXxAQV3
	 rmdf44dOQKdDUJNK6DUl8Me/jT2gehKOiIBEqPFs=
Message-ID: <75259d8f-1cdf-43e4-9fa4-9a2954435a96@arm.com>
Date: Fri, 24 Jul 2026 17:35:44 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] tools/mm: add a standalone GUP microbenchmark
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Jonathan Corbet <corbet@lwn.net>,
 Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260716123226.197736-1-sarthak.sharma@arm.com>
 <20260716123226.197736-5-sarthak.sharma@arm.com>
 <4665dd2d-99c8-492c-a4cf-b72028317d0b@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <4665dd2d-99c8-492c-a4cf-b72028317d0b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B2EC612000D
X-Rspam-User: 
X-Stat-Signature: e4fwknutuwdgncfji8bpda3zo6tx863y
X-HE-Tag: 1784894755-63867
X-HE-Meta: U2FsdGVkX18AqOZNdHQapFWAs59Si16MqRDPu3kepTsZ5Cg/VHtpMQQ6jPRbI5jnrQCfAj0LY0tknbNpWjcffw0w/DM/g1zxsK5q2+LLdffQbDwkoPfjrCsTv59hFasdzZJ6t9HVCGKRhDspTTNc+Hm9R7Q2R/GKw8I9GgSbaL+XumVLI5eGwCeYoHKYFl3SpV0mnFYgAoPIydbdaf3GopZ59LzLsGYeQHV3enRL1sa5CFTtixsi1Cm830F89GnmKAcF9tOvT2RKd0josd08Houh5e9BNoPlsVldho4SRDiALwOtuS+4FDIAGRRDkuVOt8WLqfUeDY24k2/mSj3mJUSulfmBfBCGZ3ZjY9wVivstk2fgoIT+xuS6+cBBFevhJcIPFtILmBGHfCfePOpRzpKaT2fc/xb59QnHYu0p0sP0HBX6oGFUVGv5Je/gO64MIzjmDfcM9cwmBFyFQBuEIdwIFY5HF33jyweAZFKrm7+EQrFxQwzwa1cUXo8kTP8i8QLttKyHqASjbuXwaBEE4OUfoFtED3D51wH11aaJ3is+yeDZJpBwtAGKGicWBFkXuDvlaSc2NNuhfhu7lpjpsoyYzEMbiaDEtPCHvNiyrHH8v6lWQn1+GqpM6DWSriqQmg0Z/I2oqa4ulX/+16xR4z1JOVbC8EJn8ZUAjcP06z+MnIV2ufJ3H6AjhyABGWCdLfAPGJEmM+bpQ7nmHNujYIBIU8um/689LRXbewOC+f2Ll44C4bjx5+gEE8xlU+wS7FaWf5MHY3HshaQZSoL5YIecuVF0TdUL2FnYpmUHwAvNw7oqg2biTsjQAMMHtVeGxgsUhb6du2b/XPWiVI+nTITDLWvzc086er7ZqnqQsPcaA7Noq6/y5NgEnqz/sSKwkD2rJCC9iMOOQw5jn0OXi5gJ/njTtdp8QU7CjA8ODZP6m9LujJiIFZB6ia4Z9KMS6yLVrspLDULFVqTBwrC
 NuQPIzrK
 LDQb4Fbwtw2jIdFBf32O/NvxtCFRf5QfR/QIJ+jfhN1sGYagXZ8YwhXLwSkPkFZ3eOA/cSPhqFJeViH5ltzqx53DFXTxfaxHa1zRfei5J9DMUbdVH8dhxGoo6XaVgX4tmSQlv6rtunad3n4sNd9EGTr1dyEvxrs41u8gZdzMRQ8Bv4NPnslQC2BpNty4BaVAbV2EASGmTlW51bjuNz81aaO9zqB5UBoSfIeGYvxnyp1Km5AA8rU/KgnQwAumQIfoLEmvOU0nk5G71Hz1zl2ufLgRnmdvH1hWzzgFyEoviuXNKf1ME9SSoUiOrlzDTPVx13FdK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 21/07/26 7:22 pm, David Hildenbrand (Arm) wrote:
> On 7/16/26 14:32, Sarthak Sharma wrote:
>> Add a command-line tool for benchmarking get_user_pages fast-path
>> (GUP_FAST), pin_user_pages fast-path (PIN_FAST), and pin_user_pages
>> longterm (PIN_LONGTERM) via the CONFIG_GUP_TEST debugfs interface.
>>
>> When invoked without arguments, gup_bench runs the benchmark subset
>> of configurations covered by run_gup_matrix() in run_vmtests.sh: all
> 
> To we really need the matrix in there? The matrix was good for selftests, but
> not when using it as a benchmarking tool, no?
> 
>> three GUP commands across read/write, private/shared mappings, and a
>> range of page counts, with THP on/off for regular mappings and hugetlb
>> for huge page mappings. Restore HugeTLB settings after each hugetlb
>> benchmark run. Validate numeric command-line arguments instead of
>> relying on atoi().
>>
>> This tool is a mix of reused and new logic. The mapping/setup path comes
>> from selftests/mm/gup_test.c, while the default benchmark matrix matches
>> the benchmark subset of run_gup_matrix() in run_vmtests.sh. The standalone
>> CLI and tools/mm integration are added here and the HugeTLB setup code is
>> shared via tools/lib/mm.
>>
>> Add gup_bench to BUILD_TARGETS and INSTALL_TARGETS in tools/mm/Makefile,
>> link it against the shared tools/lib/mm hugepage helpers, and ignore the
>> resulting binary in tools/mm/.gitignore. While here, also add the
>> missing thp_swap_allocator_test entry to .gitignore.
>>
>> Add tools/mm/gup_bench.c to the GUP entry in MAINTAINERS.
>>
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> ---
>>  MAINTAINERS          |   1 +
>>  tools/mm/.gitignore  |   2 +
>>  tools/mm/Makefile    |  10 +-
>>  tools/mm/gup_bench.c | 482 +++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 492 insertions(+), 3 deletions(-)
>>  create mode 100644 tools/mm/gup_bench.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 26b06d80ab45..7d121dee9f0f 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -17024,6 +17024,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>  F:	mm/gup.c
>>  F:	mm/gup_test.c
>>  F:	mm/gup_test.h
>> +F:	tools/mm/gup_bench.c
>>  F:	tools/testing/selftests/mm/gup_longterm.c
>>  F:	tools/testing/selftests/mm/gup_test.c
>>  
>> diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
>> index 922879f93fc8..154d740be02e 100644
>> --- a/tools/mm/.gitignore
>> +++ b/tools/mm/.gitignore
>> @@ -2,3 +2,5 @@
>>  slabinfo
>>  page-types
>>  page_owner_sort
>> +thp_swap_allocator_test
> 
> ^ Does that belong into this patch?
> 
>> +gup_bench
> 
> I wonder if it makes sense to "git mv" the existing tool (only slightly fixing
> header inclusion to make it compile), essentially removing the old benchmark.
> 
> So it would be
> 
> 1) Move tools, fixing up includes and removing the gup testing logic+matrix to
>    make it compile

I like your idea, it would reduce churn. But is it okay that there will be an
intermediate state in which gup_test is not there? Wouldn't we call this a
"regression"?


> 
> 2) Extend tool by XYZ
> 
> 3) Add completely new selftest
> 
> Because looking at patch #5, there is not really any code reuse there, but I
> suspect there should be some in this patch here when moving instead of copying.
> 
> That would make this a lot easier to review.
> 


