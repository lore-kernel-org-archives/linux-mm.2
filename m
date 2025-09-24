Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A624CCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 03:12:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA66E8E0006; Tue, 23 Sep 2025 23:12:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57518E0001; Tue, 23 Sep 2025 23:12:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6C9A8E0006; Tue, 23 Sep 2025 23:12:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A508D8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 23:12:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C099BAD00
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:12:09 +0000 (UTC)
X-FDA: 83922669978.22.F9E55E3
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9542640007
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:12:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ry3iHDml;
	spf=pass (imf07.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758683526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpN6MR9tWHzIM5XbfO5zo6eTuKj59QIgIbF5cCp3dF8=;
	b=CSCJpBonwgfFmks5cYRBFngHxqsAd/uXclmqci5VpM16qYbEi91Yk9Pch+d/klqCqaQ2zP
	T96jrJwq7dA7qMfLgVj1Rcyc5n8Hv3YwLFPoZVcSIqWI3lwmWFv9FVH+LsCRZfzNUfDYuZ
	KPSiG6Iy79svQDVnD6n0hdAFpcyrzjs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ry3iHDml;
	spf=pass (imf07.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758683526; a=rsa-sha256;
	cv=none;
	b=KBDfKrXtAdtfqvJAoTzfBYDNwiARNXWQcan9VAnEInLxt13ROhk8VEeHAblvHmCg7BS+3T
	wjv8CsF/FoBOY2ACgtb3BgtoedZeo9VTd5VibhQJv+lKf7Pe+1tmINSD1NQiBuC6jju5DT
	ARF9IZeuAk0TVvufhawXKX9V5E0msuk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758683521; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=jpN6MR9tWHzIM5XbfO5zo6eTuKj59QIgIbF5cCp3dF8=;
	b=ry3iHDmlMOJFCVsLB0QrfCdy8xkhscZIEbjVYnvOSr5QOkmGlnin0ReRcAJAb6QTu9vtleZR4cFuSbSuTnXMwX3wVLfUcP4J4IHb+QKTCVnMo2TTmEIAxCWhcpbObbxSIqTvCaIy06sosyYV441Mje9d/LyrZk3rf3BXpH+NrbU=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WohrEz9_1758683508 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 24 Sep 2025 11:11:59 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Shivank Garg <shivankg@amd.com>,  akpm@linux-foundation.org,
  david@redhat.com,  willy@infradead.org,  matthew.brost@intel.com,
  joshua.hahnjy@gmail.com,  rakie.kim@sk.com,  byungchul@sk.com,
  gourry@gourry.net,  apopple@nvidia.com,  lorenzo.stoakes@oracle.com,
  Liam.Howlett@oracle.com,  vbabka@suse.cz,  rppt@kernel.org,
  surenb@google.com,  mhocko@suse.com,  vkoul@kernel.org,
  lucas.demarchi@intel.com,  rdunlap@infradead.org,  jgg@ziepe.ca,
  kuba@kernel.org,  justonli@chromium.org,  ivecera@redhat.com,
  dave.jiang@intel.com,  Jonathan.Cameron@huawei.com,
  dan.j.williams@intel.com,  rientjes@google.com,
  Raghavendra.KodsaraThimmappa@amd.com,  bharata@amd.com,
  alirad.malek@zptcorp.com,  yiannis@zptcorp.com,  weixugc@google.com,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [RFC V3 0/9] Accelerate page migration with batch copying and
 hardware offload
In-Reply-To: <C8E561B3-B9DB-4F58-A2C7-4EE17E08A993@nvidia.com> (Zi Yan's
	message of "Tue, 23 Sep 2025 22:03:18 -0400")
References: <20250923174752.35701-1-shivankg@amd.com>
	<87plbghb66.fsf@DESKTOP-5N7EMDA>
	<C8E561B3-B9DB-4F58-A2C7-4EE17E08A993@nvidia.com>
Date: Wed, 24 Sep 2025 11:11:36 +0800
Message-ID: <87tt0sfst3.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Queue-Id: 9542640007
X-Rspamd-Server: rspam05
X-Stat-Signature: krxspjo39cq476oj8hcmukfsnsutab7b
X-Rspam-User: 
X-HE-Tag: 1758683524-965223
X-HE-Meta: U2FsdGVkX1/FlPVJNfQFM9rPVAX0M666td8nuvxA9aaoZp6UmsUk3ErAlw+5cy+VYnm4kU9ydkZ0YZ6qy/+kZpnJddYUd7t8QeM+/OEE0oEjTOb97n0U1rk4JqcfEVYrNpo0QhuKEJj6r7kh/l6lZjBKyVSTGlaXazKzUuZl1xDxPmNoXhgbxOqFDgvy9SJ6Brv0ByC6IH/pOYzjSjwIe9FWkh9RWg6TjqXIzvU9C55Hb4+CxBbwh6lsOXew7nHTPlM6Ao9CafE7boyMmquyWtMU7gd15RYtdQZtbTezwRqFL3iGLchD0nzX9uC5OIzFdfi8eFam3buu8WVPO9Shvh+6tH+YDgIJoeEzs469Tzbe7wvcAmUPzoL6ES20WTyhMacZEBFCzRtEKx+ggcHOrQwjtYDLCf9ly0Wt+P7AP66WVz8KA5+DwtaPLNdOIs6W+Tmv3rGbu9Aog6MKmOXp4R/y6WoueoukZ/WYCMynzRRgAzE0/13eETV5qtIRRbVVOH+M7SCMgNmrOlUEaswiJZS5816oxSgk0Vjdwij14q+DC7XyfXqflP+KwZHefaytsIQRfas38sGfPBEsAzwVDr7nkipNBnOhzpbryssLofRhcEB4EROd6C1iNQbD1egcvpfLPNsfIamNvXkBwnrcw86uRXf9LsQiChOQm/bD5G5XeY1Cq3RIxvCUhxQl/+THhhluuTmB0z6lG8/pPQktxiR5NXCMMCDX5lIhljVbRjcXGxfr9VZS81soAu0NidNO3qr2Pm8JJTrVNRrXe0WLx6rWjbLHy/JSDK50GBsX/gFKyxC5BTXoF0iCfmdIkx3FbiahTyQKvkaU9gVu3HUH3vEoy1zmliavjWEtd3v+4GlLW17ooAtCJ1lD/9r2fE7SQVB3GT2npZBMZnJaWr7oVX12Lzt52ticLHMN98VaIWiYu4HdDrrhjEPqC6HmAvI9zLfc2sAI4mkGsbzfgUO
 wVZmRVh/
 5MCV9rqoA6rR0w77tm92Z0hydt8bD4+UYGgT7MKV1DNoS7ktsCIZ2nwGYIqNT86bUAkYTKofXGRfCuieYgHyxf1YaNWeSA4Od/RcD9X66liW5YdUF2Rs3QbDpCiWb3q3vt9YbbYg3Vm8Rr/eSZAvy2KeMhBgH/NlJvlFffWWvXnIepXF4G4+jeYamfsVIlcjx6JufpFcp2cyxe4g6KT3vJHm/gdHqqyZ6LFCcchYdPYwb7cA7NX7/g7PMn6lrKZ4nV+z9rmrI4iqZCpwqlOlMu4UCTNwV7HNtRKN1bVX9FCFhe+TCaRIjHr54EJT1ynf/70c7ih18rMpToI65ZSeHpu4LLEr48vEmjKR8Rh1GgUhSw4LyK517Pwz8v626UU4X7rFD7NCNWU6+bSY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zi Yan <ziy@nvidia.com> writes:

> On 23 Sep 2025, at 21:49, Huang, Ying wrote:
>
>> Hi, Shivank,
>>
>> Thanks for working on this!
>>
>> Shivank Garg <shivankg@amd.com> writes:
>>
>>> This is the third RFC of the patchset to enhance page migration by batching
>>> folio-copy operations and enabling acceleration via multi-threaded CPU or
>>> DMA offload.
>>>
>>> Single-threaded, folio-by-folio copying bottlenecks page migration
>>> in modern systems with deep memory hierarchies, especially for large
>>> folios where copy overhead dominates, leaving significant hardware
>>> potential untapped.
>>>
>>> By batching the copy phase, we create an opportunity for significant
>>> hardware acceleration. This series builds a framework for this acceleration
>>> and provides two initial offload driver implementations: one using multiple
>>> CPU threads (mtcopy) and another leveraging the DMAEngine subsystem (dcbm).
>>>
>>> This version incorporates significant feedback to improve correctness,
>>> robustness, and the efficiency of the DMA offload path.
>>>
>>> Changelog since V2:
>>>
>>> 1. DMA Engine Rewrite:
>>>    - Switched from per-folio dma_map_page() to batch dma_map_sgtable()
>>>    - Single completion interrupt per batch (reduced overhead)
>>>    - Order of magnitude improvement in setup time for large batches
>>> 2. Code cleanups and refactoring
>>> 3. Rebased on latest mainline (6.17-rc6+)
>>>
>>> MOTIVATION:
>>> -----------
>>>
>>> Current Migration Flow:
>>> [ move_pages(), Compaction, Tiering, etc. ]
>>>               |
>>>               v
>>>      [ migrate_pages() ] // Common entry point
>>>               |
>>>               v
>>>     [ migrate_pages_batch() ] // NR_MAX_BATCHED_MIGRATION (512) folios at a time
>>>       |
>>>       |--> [ migrate_folio_unmap() ]
>>>       |
>>>       |--> [ try_to_unmap_flush() ] // Perform a single, batched TLB flush
>>>       |
>>>       |--> [ migrate_folios_move() ] // Bottleneck: Interleaved copy
>>>            - For each folio:
>>>              - Metadata prep: Copy flags, mappings, etc.
>>>              - folio_copy()  <-- Single-threaded, serial data copy.
>>>              - Update PTEs & finalize for that single folio.
>>>
>>> Understanding overheads in page migration (move_pages() syscall):
>>>
>>> Total move_pages() overheads = folio_copy() + Other overheads
>>> 1. folio_copy() is the core copy operation that interests us.
>>> 2. The remaining operations are user/kernel transitions, page table walks,
>>> locking, folio unmap, dst folio alloc, TLB flush, copying flags, updating
>>> mappings and PTEs etc. that contribute to the remaining overheads.
>>>
>>> Percentage of folio_copy() overheads in move_pages(N pages) syscall time:
>>> Number of pages being migrated and folio size:
>>>             4KB     2MB
>>> 1 page     <1%     ~66%
>>> 512 page   ~35%    ~97%
>>>
>>> Based on Amdahl's Law, optimizing folio_copy() for large pages offers a
>>> substantial performance opportunity.
>>>
>>> move_pages() syscall speedup = 1 / ((1 - F) + (F / S))
>>> Where F is the fraction of time spent in folio_copy() and S is the speedup of
>>> folio_copy().
>>>
>>> For 4KB folios, folio copy overheads are significantly small in single-page
>>> migrations to impact overall speedup, even for 512 pages, maximum theoretical
>>> speedup is limited to ~1.54x with infinite folio_copy() speedup.
>>>
>>> For 2MB THPs, folio copy overheads are significant even in single page
>>> migrations, with a theoretical speedup of ~3x with infinite folio_copy()
>>> speedup and up to ~33x for 512 pages.
>>>
>>> A realistic value of S (speedup of folio_copy()) is 7.5x for DMA offload
>>> based on my measurements for copying 512 2MB pages.
>>> This gives move_pages(), a practical speedup of 6.3x for 512 2MB page (also
>>> observed in the experiments below).
>>>
>>> DESIGN: A Pluggable Migrator Framework
>>> ---------------------------------------
>>>
>>> Introduce migrate_folios_batch_move():
>>>
>>> [ migrate_pages_batch() ]
>>>     |
>>>     |--> migrate_folio_unmap()
>>>     |
>>>     |--> try_to_unmap_flush()
>>>     |
>>>     +--> [ migrate_folios_batch_move() ] // new batched design
>>>             |
>>>             |--> Metadata migration
>>>             |    - Metadata prep: Copy flags, mappings, etc.
>>>             |    - Use MIGRATE_NO_COPY to skip the actual data copy.
>>>             |
>>>             |--> Batch copy folio data
>>>             |    - Migrator is configurable at runtime via sysfs.
>>>             |
>>>             |          static_call(_folios_copy) // Pluggable migrators
>>>             |          /          |            \
>>>             |         v           v             v
>>>             | [ Default ]  [ MT CPU copy ]  [ DMA Offload ]
>>>             |
>>>             +--> Update PTEs to point to dst folios and complete migration.
>>>
>>
>> I just jump in the discussion, so this may be discussed before already.
>> Sorry if so.  Why not
>>
>> migrate_folios_unmap()
>> try_to_unmap_flush()
>> copy folios in parallel if possible
>> migrate_folios_move(): with MIGRATE_NO_COPY?
>
> Since in move_to_new_folio(), there are various migration preparation
> works, which can fail. Copying folios regardless might lead to some
> unnecessary work. What is your take on this?

Good point, we should skip copying folios that fails the checks.

>>
>>> User Control of Migrator:
>>>
>>> # echo 1 > /sys/kernel/dcbm/offloading
>>>    |
>>>    +--> Driver's sysfs handler
>>>         |
>>>         +--> calls start_offloading(&cpu_migrator)
>>>               |
>>>               +--> calls offc_update_migrator()
>>>                     |
>>>                     +--> static_call_update(_folios_copy, mig->migrate_offc)
>>>
>>> Later, During Migration ...
>>> migrate_folios_batch_move()
>>>     |
>>>     +--> static_call(_folios_copy) // Now dispatches to the selected migrator
>>>           |
>>>           +-> [ mtcopy | dcbm | kernel_default ]
>>>
>>
>> [snip]

---
Best Regards,
Huang, Ying

