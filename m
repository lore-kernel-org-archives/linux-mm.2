Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C92CCD3430
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 07:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9512B6B008C; Tue,  5 May 2026 03:18:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 928D06B0092; Tue,  5 May 2026 03:18:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83EB66B0093; Tue,  5 May 2026 03:18:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71A046B008C
	for <linux-mm@kvack.org>; Tue,  5 May 2026 03:18:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BB121A03B2
	for <linux-mm@kvack.org>; Tue,  5 May 2026 07:18:22 +0000 (UTC)
X-FDA: 84732512844.24.4E1F7FC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id BB9AB100007
	for <linux-mm@kvack.org>; Tue,  5 May 2026 07:18:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tmf7EFp+;
	spf=pass (imf05.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777965499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U8Okzffkmp0X0il5ChdwD7WwCI7y675UlHMmtZ9sMKU=;
	b=MgwZS7rGyax7QEbVNPM3c2gA0Hx+R6CZaypsfkBDeMKxlMc59du1PVLW5A3ok/2vXmFSN6
	+GYPX3SWVwwTun58Ent85peyyCy6Syr4sOC8XrQ86clME8Muwuho5LZXo9uWY3tdXqXBrs
	L5oaWCJSQhyCwakDeAh5m9o3RHesWl0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tmf7EFp+;
	spf=pass (imf05.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777965499; a=rsa-sha256;
	cv=none;
	b=uwk3vbZjnnbmqOfRvxfFoSGAIftmAhxXsj4l/zWNv4O1AGrAfdGXEmqol9xkB2eupWxpCv
	/7SYoaiXSV7Zb8R0GA3ZejlBHCDZghLvNWBZ23XG/K918AxikDoxd2Y4rBoSUtrqF9oTm9
	VOv32BOCZ2I01s/F++uWCWHC7t36Cm4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777965499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U8Okzffkmp0X0il5ChdwD7WwCI7y675UlHMmtZ9sMKU=;
	b=Tmf7EFp+eRyh+tKEllHkWX2TOT14mimKwIQeMg380iiyyKdKW2L58yXfo00xO+skPuNJA5
	bLVfKqtIoZ4YVBGqeTF8051UmuJ2ydPeM9ptKOvCOU+uvbv8WbzWxeJbyUrSx9Sq/PDz95
	En8sS7n8OLlRB0LS+2npAkCmopPo5Go=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-393-drYrvMkpMXiYMhcgH8lDOQ-1; Tue, 05 May 2026 03:18:17 -0400
X-MC-Unique: drYrvMkpMXiYMhcgH8lDOQ-1
X-Mimecast-MFC-AGG-ID: drYrvMkpMXiYMhcgH8lDOQ_1777965496
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5a877706823so611582e87.1
        for <linux-mm@kvack.org>; Tue, 05 May 2026 00:18:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777965496; x=1778570296;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U8Okzffkmp0X0il5ChdwD7WwCI7y675UlHMmtZ9sMKU=;
        b=tH2CXYplBeQlBznXLEPIEr5ZzLtHgwikoFPJpe4xyBRR3UkwrtIU52GDKYgshw2pxD
         6tEAVy8F9jNwKNrAmY/05AR93bpZRGLD0GB0QaAwy/6bFqbI59pe58QBVdgw6PIk8BhM
         JgBxliV1+JldSJL43oo8qx7LJ2//G7s1564Lrei5XYENMNJngzcodmI/U29xShIJuY/7
         x0fm5Qb37TTAvimvrVmnKQur1l5Izjci/VZ52CMqJib5YW0jBIsbdz/Gy2DOgWW5K//I
         PfPXHftv2Wo2mojI/KOBTtqajzruMwwWx4ALM9myfiBArVpSMEa9Rf1ngsVV3yTMPtJ1
         ApLg==
X-Gm-Message-State: AOJu0YzaIn/pn1YhITjea7RztUOkar7QrHcWBRPJePGxVztllyx8wpsd
	DSkqJ6Zcoe4CnheHMawPPYuvaghz+fSH+KCJSpyg61LeoNET7gPiDSA9oqhquGiITBSOTAApW4B
	XnCNoZeOTd+f91nQGo9/dQPiwXeR8z11l9Fv0wsU9/TP4ZiNIsug=
X-Gm-Gg: AeBDieuZy1ihWSWg0K7nIAR51sQnxE1xtG11F5Iqv4+Vmh0WMLuUyEtITORn9XogVnM
	D88u0X5CX+MIDC64OHURYSWE6hfrVC445rjDn8e1BZHLHFwTA+c9JpmPEJsFbUtAmdqSDUXK9Gk
	nsEt7sTXyxG29zUQdX4qToMQ9hqhdQ87G1g0Rtwd1A5a2ou1Go/48UH/ol9bCg/pNb9iuSFEbK+
	lx7xboaF4Rajnu287ZLirAx1FchTH0qBT3Pwgr5w9nSpEq4XgcoISSptiS6p38TUfQLu4UGVwcc
	X/cZNSO6w24RtxbNx6WgzfajRd7VrEuYqr3uvNhJeOJJARxWr028R7+osP/NTBchUORcfu6d/TI
	i7H1EuRG961eFdxX0Yi5XpoWFcUpVEranxo+6lmRq2WnuahukuTHzyyjALQ==
X-Received: by 2002:a05:6512:2527:b0:5a8:64cd:4d7d with SMTP id 2adb3069b0e04-5a864cd4d86mr4224296e87.37.1777965496050;
        Tue, 05 May 2026 00:18:16 -0700 (PDT)
X-Received: by 2002:a05:6512:2527:b0:5a8:64cd:4d7d with SMTP id 2adb3069b0e04-5a864cd4d86mr4224268e87.37.1777965495404;
        Tue, 05 May 2026 00:18:15 -0700 (PDT)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a87791b4a2sm1029451e87.1.2026.05.05.00.18.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 00:18:14 -0700 (PDT)
Message-ID: <ecd81b6b-62ef-4dab-a93e-e65598d64841@redhat.com>
Date: Tue, 5 May 2026 10:18:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/5] Migrate on fault for device pages
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260505051658.2219537-1-mpenttil@redhat.com>
 <afmXIq8VY_vs1GPo@nvdebian.thelocal>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <afmXIq8VY_vs1GPo@nvdebian.thelocal>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JrmuFjdEw8MQkRydf0l20e8CiwluqA-La5ULGbwUbeo_1777965496
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rbp4kif1nnz63p7jc6dzehu9uqncawxj
X-Rspamd-Queue-Id: BB9AB100007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777965499-271044
X-HE-Meta: U2FsdGVkX19v1nHnERGPlC7ZGU4eCNVAd//u0L4k0DelIyCEzl/JYKoUNrlFeFAGCANPOP76WXGzD4fKzX2hLni0NMG7r2JJpBopc2SexnngXvppui1aUJt63vxdr6XrMO735JaDtzlsxhB2JSkG9cV1oWy5mJNBaNodBdMYqpekcvpzUI5hNoVnzB0xXV4BuKbK5qyJhfjV/8i/i503Vt/ZZCEeL2AQsZlNRiUXKgxw1jpXegUbMGRVxCvOGocSZOrgFeCvn1GebBqwq+pphEYilja/5dEDkspGyCGnrg+vENpy2qQBIzQf96KjvR5ma9rUKZqiXkXGXOpwpD6A30QqwBbxBF8qLU5f7Z4xKwA6wqP417ZX7XTlC27yj+8GOM4QRt/Y2lCqttzGEoZrf6jE5p7tpPy3ELQ0f1DOSNgdNLtk9ZBSWj0bVY1Q/rPVs3iejl/7Z9SFO0PowVgpoHdk5pnAqnGGABUv0aogyI8Chq5ZeLotMRhUnnpQ3zrIoQ0ny4qwH/SZOWzYX+87kq0+UBza6qBNrPGCc6Moa3nLKV5OaxFfCywcHtbSlrhC+aKvawBrJmq+fHXRoLDApmqlnIXieNRLE5NQFwI9WyEiq5atyHzphXGPPIjZ0Fe8TTykPECtHveunk8xmqaq43+xITRQgoaAXnC0kg7+SYi8j8Y5EU2VhfuDLR2nh4BMTgMq3SZ7S7+tyNTGv2Fl/4+OE08i4efSPZdsioZ4hWdzhvMy4XeKKjxTmevu4Ya4vwdIj4Y67nP4N0+8c5f+4ESiyd3H6lE3C7CyK5LLqKh96tsj27PAKsT7Wzd0GLvdPHzIEmCKMnCs64jFVEO6j6W9ngrUAaX+gs0lNGBQ7BEDOeJV8R9D5lQNrb+qnxOaXtbntKdZhDWi4phtS2/FFnPBMVjoBhyxA/g4UyQc259m8cL9vE8/rtpK5DVVjbAnvmpOft5hJd8VC9ZvZJS
 ZQs4hHeT
 g4ByRH3HhaNKUsBEC6VVcbRMh3f8QKLZWc+pjMdPhdbLfKCZgC7lVTpJCR6PIURZ8qfR4DbCDiUfFR62TFjLeR/LYisgwb7Q9uDPw0+UbWo4YvLrGzLoNnfD4DKv11tBX1e7pybIjcL+Mh6asdYtmKPGt3kAP9obzUW49BTr3APddZuvo8zEoFF1aKMVRqCrn7n0GBGN71f0+o/r3+pWjVdP5fYP/+ejKQBBYjcov7b7BTYa2/Ri7KcQHDNhAvyhomBR+9KH7I0duqjc23jA+EL2PYRAy0hEb8YHe9VQ4Df1GxBr7wn1JG3gV/kejBA6kEsBLrkATbeh6DWYUJbYMhMOq+mBN3zpMAR7aEwqYYKWon9xlo+AHOrlEM3qpLb6bL4+RA708krt46cJHpgabPAZ9AcMMI0jCvJCzX+/esvQo2K/0gQo4fPBbYpIDBs+VUffksHLMEjskqFn/RmS8nc1hxf4OAo7DiC9LGhz3ct1h1NN+zFvbfr9u2Rp5E6Q1oWIVsGeFM96ma1yA1pH76kfPliN3v+OxgE7J/iCDYRIMqdUVJzOqxXWZwimEptyzqRfywhr64K4bCYnuZ6F90jO4UReQfYPeFLVBEspm7Yv5ZB4Qtyt9c25IM5AMxl3P7tToLGKcgmRazi88pwiT539arOAzs6rsHSwMgPfdg1k139tVE4icVw2c/UcO311UP3aq4KBQUl4/dDo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 5/5/26 10:09, Alistair Popple wrote:

> Thanks for doing this work Mika. I've been meaning to take a look at this series
> for a while. I'm currently at LSFMM but will try and take a look this week or
> next as it sounds quite useful.
>
>  - Alistair

Thanks Alistair and no problem, appreciate your insights whenever you have time.

--Mika

>
> On 2026-05-05 at 15:16 +1000, mpenttil@redhat.com wrote...
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
>>   lib/test_hmm:: add a new testcase for the migrate on fault
>>
>>  include/linux/hmm.h                    |  19 +-
>>  include/linux/migrate.h                |  26 +-
>>  lib/test_hmm.c                         | 101 ++-
>>  lib/test_hmm_uapi.h                    |  19 +-
>>  mm/Kconfig                             |   2 +
>>  mm/hmm.c                               | 835 +++++++++++++++++++++++--
>>  mm/migrate_device.c                    | 583 +++--------------
>>  tools/testing/selftests/mm/hmm-tests.c |  54 ++
>>  8 files changed, 1066 insertions(+), 573 deletions(-)
>>
>> drm-tip
>> base-commit: 94d56a898a2db27f841b17f6966a81ba502fe63c
>> -- 
>> 2.50.0
>>


