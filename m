Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6637C54F56
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766526B009D; Tue, 28 Jul 2026 15:36:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7171C6B00A4; Tue, 28 Jul 2026 15:36:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6061F6B00A5; Tue, 28 Jul 2026 15:36:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AA3A6B009D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:36:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C0D0EA1757
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:36:06 +0000 (UTC)
X-FDA: 85039191132.11.4DE98CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E7277100006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:36:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WZa0Bl4a;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785267365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gYUR4xB4aRwXq06Gc2LEXbjTJfiKmGLAUsIcZfM4LSs=;
	b=R1KhavcZGWpwjBzulCLUDujCQgCHdtmwVn/Wd1VYQJ4R3pHhZ+T3BBMD5Dcg1bTrq9cHoP
	RxshpzmDz4qAlaavgwUpnz1FGrGa8UT1Q6XUG7uyi4keWvXNuhjZDCACy5+GHnz8po+k4h
	28xAErsMzPs+SDFqjkxJDceX/NjMmCY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WZa0Bl4a;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785267365;
	b=BPlCSsnc2611cWqaHPs02SdtgErOUVzavRZ+OLwPCMygNIwY3lNMDzDeU82cmc2wXlIrLR
	iB50Iivyi+XraP20/8cTwQXyRoRBgeD38suGlLDATIK3O9aEjVAJ8uiBPBGu2OWT+sggRJ
	6wBqF/laQe87MO5KhexNSJc7plCovbA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 117604029E;
	Tue, 28 Jul 2026 19:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5391F00A3A;
	Tue, 28 Jul 2026 19:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785267363;
	bh=gYUR4xB4aRwXq06Gc2LEXbjTJfiKmGLAUsIcZfM4LSs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WZa0Bl4aUM4kIvScqfGaPW+tX9VDNsp5/KH1YZ8H5u3kxx6WFz0TXZsvUIiqnPM5Q
	 /4Yem5Vmurck8NmLF4ItsT1zeHY/0lmDIChER8jHRMx/8SKsmr5ie7l1N90sd8cYHT
	 D/3IwbdTraapcOCh/fLNka5JbqNNOg6AXLvua1eyOnneKRUGs5cDX2K1OYXANPeqiI
	 EWwvcCYr+Wts3+/Gr3EQRQ1hfsxtl1Kez7xRnDdVl7+bjyy2gUYXJP8upjUtaQT5uW
	 uAfDmQjuMPoC2ldkyHnJCHnjG0nsrvJ3bbGFzN4QRUVwirY57FfukWnmzMzgGGtj46
	 g7+0Lmz/e3lRg==
Message-ID: <32518229-bf13-4b48-8de1-25b7bd8edeab@kernel.org>
Date: Tue, 28 Jul 2026 21:35:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 0/5] Migrate on fault for device pages
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260525084524.139868-1-mpenttil@redhat.com>
 <1612d4cf-b725-4ecf-8618-51a33537f59d@kernel.org>
 <72e2bdfd-c883-47a8-b121-42a1fe160d9d@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <72e2bdfd-c883-47a8-b121-42a1fe160d9d@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E7277100006
X-Stat-Signature: e97djjwpkc6yn847j4wb6an6x8mn5hnu
X-HE-Tag: 1785267364-688348
X-HE-Meta: U2FsdGVkX1+udBjB8WbQTiGPrz081YVaUgm0WvIEJtIbrPT+sChipmxHkTWn2rWcGSDnu09j1lvcDttt/NJqocMCXNXVzmENwqclgXuozDBmKwx4UOxbLawM0faT/01TbVtKdoFkvIfVLBcv/6nl36ftnlmb46s4iSyGMUqsA5y4cK0i0p36CVCTcugfaGHZwqxxQpIdO4KoCmbUd3dokugl2fFqF+bB9Y+J9JRnFCJRexn26fHmwVQwp3aH8Otec/CujhFaBK5P5NVja7eQil2yQScltWc2IxU5YrM7ehCHi8MCZ5CaarICUN6J5GWQ6STpmbb4bVpfzPqV8fsusWX1tOdwcSlQwPcibQZcqyNwAXknPiWsy5Nk+GW1YMMrxye3YuQJyTQy0d6kXcwJVqZiaN4LziYNTxKqgZvvMAGffWlbDT8EgTAe6CY9ZXmZkvOfs/yu7jtRXmv0NHEeg34P5cQxBwJ2Z2u0npV5I8xk4/8JejtrhwfRlz5v38CjK3An+MIM6NWtB7UaBY/2xmIlA5YuVbQaEm3Rvkdk+PTVxO7xkl0xQreu7HDpwv3SQU3R5p4gySlH6KFCeGSOAOxNMtNvmZsRiEj5ZfC6NO41ayEJKwV/e+1Wd9AS5ahvX51bq0GSxIAfeIvJbsw1LgS2JNMhNNEYBz1FrpK96Sl4vgO0TklCZWkOlsMOxedt29EvkHs0vPJTZphN36cGC/b8/x4e846fhxPy83wHyBiVwsVxCW+/YuBL/YgEgE7HPOuM0VKwZBaSn54i8xWc8P+N77z9TsfP7UiW9RmQJnpOvro8u0ugc8aowB5B/IACfuO/C9Ax6OpfHCz0ax35TM2MDtqT2Rur6nYHCi94lXvVdtdgycZtdTUUvctEdcpJD7V/iVxP7ARHvsK5g4KxW5mpswZn6e+JWoTVKzBF7lLa2ms3f5JyJ6k3AnPSWlEXtfK9WI/SRyzV/fgvoIa
 WX0umDy2
 U0HS7E66/zNiirj/sQJpYEO7mQB5f8TJ4LeLvL9FJzOFPEcPmxA26CoSvAvEH1HZNosbm7bC+r8ckF99M/XdeafyWwsJ/ezj81mvOyydnA5OSUfpBKsPIh0vUVHuehLLN4jPBSmC5cUJ7+lRrPlkJ/GPenr39i7Wb7+Zv+RATx8jRsWtjPsCvMmtbUlp5LbiIIn7XMSRUGdbAXgCFHuMlml3c3SEArJo/sDFxYXLTitUh3Aw5eCW5RpFVXbKTI9Z8o36HbvkVobxSRkXKAEmnooEZJYERG8Oy9Dd+bynVLl+Pa0gC+FI/HQK7alpl8qV9UMhSt2a0hQzBWo88PJ+6x081xNwVBBOc2XPf61n6hNLnRXgqkwF6QhAn216juZoMEXvpiHC2bwfkiu9cd6hESKEV4+vBcUoOenLprVnUshbpqCnOJDbgg8ZKvb/eeD3i5MdZzjNCijIfp9L60p8mtAfk1B4/mfdbM4OIq+0NN+LR76Qx8svlnHuKqjyVGtWKBxtDvFTHewn5v7+CdQF+BxIWbAws/mzr+hGvuaN/BCBH6FjG+7S1ZhP/+6FaGgJy5YDcfIib5qsUs0opak8EYMOTSdEMSXwCiBGd5NHBNO6/VdIk28/59gt/prwmnQhFIktYnNIVUESGQV5uaKCJQHeYgAgYhQd/CiDBH39GQr56aVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/16/26 15:40, Mika Penttilä wrote:
> On 7/16/26 16:15, David Hildenbrand (Arm) wrote:
> 
>> On 5/25/26 10:45, mpenttil@redhat.com wrote:
>> From: Mika Penttilä <mpenttil@redhat.com>
>>
>> Currently, the way device page faulting and migration works
>> is not optimal, if you want to do both fault handling and
>> migration at once.
>>
>> Being able to migrate not present pages (or pages mapped with incorrect
>> permissions, eg. COW) to the GPU requires doing either of the
>> following sequences:
>>
>> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
>> 2. migrate_vma_*() - migrate the pages
>>
>> Or:
>>
>> 1. migrate_vma_*() - migrate present pages
>> 2. If non-present pages detected by migrate_vma_*():
>>    a) call hmm_range_fault() to fault pages in
>>    b) call migrate_vma_*() again to migrate now present pages
>>
>> The problem with the first sequence is that you always have to do two
>> page walks even when most of the time the pages are present or zero page
>> mappings so the common case takes a performance hit.
>>
>> The second sequence is better for the common case, but far worse if
>> pages aren't present because now you have to walk the page tables three
>> times (once to find the page is not present, once so hmm_range_fault()
>> can find a non-present page to fault in and once again to setup the
>> migration). It is also tricky to code correctly. One page table walk
>> could costs over 1000 cpu cycles on X86-64, which is a significant hit.
>>
>> We should be able to walk the page table once, faulting
>> pages in as required and replacing them with migration entries if
>> requested.
>>
>> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
>> which tells to prepare for migration also during fault handling.
>> Also, for the migrate_vma_setup() call paths, a flag, MIGRATE_VMA_FAULT,
>> is added to tell to add fault handling to migrate.
>>
>> One extra benefit of migrating with hmm_range_fault() path
>> is the migrate_vma.vma gets populated, so no need to
>> retrieve that separataly.
>>
>> Tested in X86-64 VM with HMM test device, passing the selftests.
>> For performance, the migrate throughput tests from the selftests
>> show similar numbers (within error margin) as unmodified kernel.
>> Tested also rebased on the
>> "Remove device private pages from physical address space" series:
>> https://lore.kernel.org/linux-mm/20260130111050.53670-1-jniethe@nvidia.com/
>> plus a small patch to adjust with no problems.
>>
>> Changes v11-v12
>>   - Fix for issue found by Intel CI in patch 3
>>
>> Changes v10-v11
>>   - Fix nested mmap_read_lock in test suite
>>   - Addressed review comments from David
>>
>> Changes v9-v10
>>   - Fix for issue Intel CI found, forgotten pte_unmap() before
>>     migration_entry_wait()
>>
>> Changes v8-v9
>>   - rebase on drm-tip
>>   - fixed uaf around  migrate_vma_split_folio() usage
>>   - added missing pmd unlock
>>
>> Changes v7-v8
>>   - rebase on 7.0
>>   - fixed subject in two patches
>>   - enhanced commit messages
>>   - squashed patch 6 into patch 4 to fix kernel test robot warning
>>   - readded dropped Cc block from cover letter
>>   - fixed white space
>>
>> Changes v6-v7
>>   - rebase on 7.0.0-rc6
>>   - added documentation and comments
>>   - denote to be migrated zero page as HMM_PFN_MIGRATE alone
>>   - got rid of HMM_PFN_INOUT_FLAGS movement in patch 2
>>   - picked up Acked-By from David for patch 1
>>   
>> Changes v5-v6
>>   - rebase on 7.0.0-rc4
>>   - use range based TLB flushing while unmapping ptes
>>   - gate migration behind HMM_PFN_REQ_MIGRATE for fault and
>>     migrate paths
>>   - always infer migration flags from migrate->flags only
>>
>> Changes v4-v5
>>   - rebase on 6.19
>>   - fixed David's email address
>>   - fixed link issue without CONFIG_TRANSPARENT_HUGEPAGE
>>   - refactored into smaller commits
>>   - added more comments to code
>>
>> Changes v3-v4:
>>   - rebase on 6.19-rc8
>>   - fixed issues found by kernel test robot with random configs
>>   - fixed typos
>>
>> Changes v2-v3:
>>   - rebase on 6.19-rc7
>>   - fixed issues found by kernel test robot
>>   - fixed smatch issues reported by Dan Carpenter <dan.carpenter@linaro.org>
>>   - fixes to lock handling (pmd/pte) on errors
>>   - added assertions for pmd/pte lock states
>>   - other issues discovered by Matthew, thanks!
>>
>> Changes v1-v2:
>>   - rebase on 6.19-rc6
>>   - fixed issues found by kernel test robot
>>   - fixed locking (pmd/ptl) to cover handle_ and prepare_ regions
>>     parts if migrating
>>   - other issues discovered by Matthew, thanks!
>>
>> Changes RFC-v1:
>>   - rebase on 6.19-rc5
>>   - adjust for the device THP
>>   - changes from feedback
>>
>> Revisions:
>>   - RFC https://lore.kernel.org/linux-mm/20250814072045.3637192-1-mpenttil@redhat.com/
>>   - v1: https://lore.kernel.org/all/20260114091923.3950465-1-mpenttil@redhat.com/
>>   - v2: https://lore.kernel.org/all/20260119112502.645059-1-mpenttil@redhat.com/
>>   - v3: https://lore.kernel.org/all/20260126111939.1332983-2-mpenttil@redhat.com/
>>   - v4: https://lore.kernel.org/all/20260202112622.2104213-1-mpenttil@redhat.com/
>>   - v5: https://lore.kernel.org/linux-mm/20260211081301.2940672-1-mpenttil@redhat.com/
>>   - v6: https://lore.kernel.org/linux-mm/20260316062407.3354636-1-mpenttil@redhat.com/
>>   - v7: https://lore.kernel.org/linux-mm/20260330115611.347988-1-mpenttil@redhat.com/
>>   - v8: https://lore.kernel.org/linux-mm/20260414041226.1539439-1-mpenttil@redhat.com/
>>   - v9: https://lore.kernel.org/linux-mm/20260505051658.2219537-1-mpenttil@redhat.com/
>>   - v10: https://lore.kernel.org/linux-mm/20260505184421.2324798-1-mpenttil@redhat.com/
>>   - v11: https://lore.kernel.org/linux-mm/20260525050830.100254-1-mpenttil@redhat.com/
>>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Jason Gunthorpe <jgg@nvidia.com>
>> Cc: Leon Romanovsky <leonro@nvidia.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: Suren Baghdasaryan <surenb@google.com>
>> Cc: Michal Hocko <mhocko@suse.com>
>>
>> Mika Penttilä (5):
>>   mm/Kconfig: changes for migrate on fault for device pages
>>   mm: Add helper to convert HMM pfn to migrate pfn
>>   mm/hmm: do the plumbing for HMM to participate in migration
>>   mm: setup device page migration in HMM pagewalk
>>   lib/test_hmm: add a new testcase for the migrate on fault
>>
>>  include/linux/hmm.h                    |  19 +-
>>  include/linux/migrate.h                |  26 +-
>>  lib/test_hmm.c                         | 118 +++-
>>  lib/test_hmm_uapi.h                    |  19 +-
>>  mm/Kconfig                             |   2 +
>>  mm/hmm.c                               | 843 +++++++++++++++++++++++--
>>  mm/migrate_device.c                    | 583 +++--------------
>>  tools/testing/selftests/mm/hmm-tests.c |  54 ++
>>  8 files changed, 1086 insertions(+), 578 deletions(-)
>> What's the status of this?
>>
>> Patch #3+#5 are extremely hard to review, I wonder if there could be a better
>> way to split this up better so we get smaller changes that can be more easily
>> reviewed.
>>
> I will send V13 with few fixes/improvements in couple weeks when back from PTO.
> I will also address the recent "pmd becomes huge or cleared" affecting mainline migrate_vma_collect()
> Not sure about the split though, patch 4 is mostly move over from migrate_device.c and patch 5 testcase.
> But I try to see if there's some sensible way.

I think #3, but especially #4 are *extremely* hard to review. Unless someone
wants to invest a full day, review is not going to happen.

There must be a better way to split this up into smaller chunks, or to move code
with essentially no modifications, to then modify in the new place later.

-- 
Cheers,

David

