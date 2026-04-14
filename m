Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35218F9D0D3
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 15:28:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEF886B0088; Tue, 14 Apr 2026 11:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6AC6B0089; Tue, 14 Apr 2026 11:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDC506B0092; Tue, 14 Apr 2026 11:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBC506B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:28:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 753871B4F92
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:28:44 +0000 (UTC)
X-FDA: 84657543768.19.B85782B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id E7D784000B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:28:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RTy5I9oS;
	spf=pass (imf17.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776180522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/eTbXvKaxwhs+y3kG83ryFZztyaR2djpY/Q1BdL5kUs=;
	b=cer0Nv0b98k6D72A0B+14kJLlwUyeDdURFpP3+EswaWtpsxBZfY49pyNSwip6TuFGXwO25
	1C+1qnt2wKgUzfYV1uiHR2mb2H9PekgIg+XnN2nS+p0GE7tEm8tgdsuhtKA8iQm2pwNtlG
	q8wLd3xIjQxIIghPc4g4zPvY8BLZ/E4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RTy5I9oS;
	spf=pass (imf17.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776180522; a=rsa-sha256;
	cv=none;
	b=rd2g15Rd0TDxq0V34dDWI1x0rF4bPeOkNrnuLObbvMpe2O06M6TYjrgY70KcKMnFPDsF88
	rsLfZfHU0EnEFheFu4uDs1+fC/ACGOQfIbMIFQfjjKp1ooM8P037NDJSrglZpbWiOs55B1
	4YsGypkI0f88VTsqXevA30lRiQpWj9A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776180521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/eTbXvKaxwhs+y3kG83ryFZztyaR2djpY/Q1BdL5kUs=;
	b=RTy5I9oS0EgxBA4HZIiRi+yl1FC2IKDNv5XxF5GkgsicBjaUwpPXUBRVU+FxMbZt5XX1GI
	Kdk8tUncFprDmNiVysmSglxEPfazyorguKZ9F48xM60sk1r86g99158canPgtz7GlwLxLW
	fUiLKDRkS4ZRlVpCI5TXsGf+tVx9UWA=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-8Qd0F6SoOru9wLFJtyKQrw-1; Tue, 14 Apr 2026 11:28:38 -0400
X-MC-Unique: 8Qd0F6SoOru9wLFJtyKQrw-1
X-Mimecast-MFC-AGG-ID: 8Qd0F6SoOru9wLFJtyKQrw_1776180517
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8d4c2906fdfso609432185a.2
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:28:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776180517; x=1776785317;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/eTbXvKaxwhs+y3kG83ryFZztyaR2djpY/Q1BdL5kUs=;
        b=fqV9Mhhr2hi7MYRW/5FEYRU8XH9u+WRba5NgTAcNk83m5URQnE0armkNysYU6qpcWu
         M2Y4gxRsZSHctmZFOtzGdCgtrTvDuUDkbBZGTk7mdNtz0lBO9j9NnQS2ycJxcJBimpM0
         r9JtWaNoU77Rz8a0XrM079qtHcGrQGWmwNz6SVb7X0Q/EWKTaVg/T/fJzW0doLbtpxOK
         WtlMZ3zlOCLBWPmtPxLhRmQXJ0QnEbJybkWA3S1M3Z6hXo+KJpbNos0TUv7pOyUQvjDX
         JdO5Gm3IubzmJ5yJEFdAMkaHWbVF706eJxnLL5wvvDphMOmYloV4PxIVrEOllmkpiywV
         aAuQ==
X-Forwarded-Encrypted: i=1; AFNElJ88YFe/53tWVUgRi00fpqpzCWQe2iZulMxcCxOR465g29DDu13h6V0Opzh2TpVt6UDup8IqxCWbPw==@kvack.org
X-Gm-Message-State: AOJu0Yyz2EX1S/I/6gPkjQ0IZSpDUFBpALsdASAbiwpgm2KDWZcVZlko
	wdaWc1JwF8I9jy0PReLmJ44dqTCK5D77NS7R/y10kMYqmL2k1+/0BF7tZ53kyyQUJkhnjwj4adO
	3c6QaIhWKYdCI0Iz0/cuvuSbpfY5e4NOB2Q6gJwjQm7lFOgrp4pfM
X-Gm-Gg: AeBDiesqJzqwFGPSOnhSJKsN2GOs0/vW00JAGWQSy69rKQPW8/24rUBj26S8XnE2mjF
	zFTpbczVurBHSAngHoaM8rjhC9Q1M4txkkG85wr3NGEjaY8vSYrlShpa1Oa36B3xEYiuO79W5tQ
	batrw/x2Ne3pVLLjXSKPQDnv6IueeWdAZMJL2eA+abXJ9tg7T8NTe/VtARYFsGl+Y3aJxzXkaBM
	fE/biHcLWg9xmcKFe9bPaFINQaloYnY551eFNIZdPxTsjTNLvDrN4htbdNDLqdI5m9m+Qu+2xIr
	xZczrCRn9FJ1rnnA6jSCAhjavOcrTFwQGNwmyYt3wne8NeVDMgvZmYhdWJQkFtkySkjlwqQByep
	JqHC8gOnOSkhVPEORmHY+7Xwf0XqROo4Dva1NXw2HE4f/qYM=
X-Received: by 2002:a05:620a:4487:b0:8d6:2beb:9470 with SMTP id af79cd13be357-8ddcf8b07a9mr2656286485a.40.1776180517057;
        Tue, 14 Apr 2026 08:28:37 -0700 (PDT)
X-Received: by 2002:a05:620a:4487:b0:8d6:2beb:9470 with SMTP id af79cd13be357-8ddcf8b07a9mr2656278685a.40.1776180516369;
        Tue, 14 Apr 2026 08:28:36 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb963d7edsm1115242285a.39.2026.04.14.08.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 08:28:35 -0700 (PDT)
Date: Tue, 14 Apr 2026 11:28:33 -0400
From: Peter Xu <peterx@redhat.com>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	James Houghton <jthoughton@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <ad5dIUpAMs4MuBvV@x1.local>
References: <20260414142354.1465950-1-kas@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260414142354.1465950-1-kas@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fq-2Mnxm4XJt3MyUxsWeUDe6W0eWmsHG6TkVZeaLRrA_1776180517
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E7D784000B
X-Stat-Signature: wzzuyysmz6qhhsmnqrd7xunt86eh4wne
X-Rspamd-Server: rspam06
X-HE-Tag: 1776180521-180635
X-HE-Meta: U2FsdGVkX1/mjZAWu3m2IciikqhE8FFGFpQ5ifoAcFnhUrXWomNUeGTx0aM/FKXdy7qWgHUyV9YnuT8rJ6ceKrwKsafDWb+TE8pcF7E1t6dxKiPEnIO83K54uzT8o0MsffngN5SJDJ24HNdxhc1STXFRfljybtWkpSXexpIaFk+Y0MJa0eQnfmsjEWgLX5CL9xa4QCXT7iG+aDjoH4MtI9jLThKyd3JLUSbVVCSPriRIKg0b6CAERBinfYmItmymOXcEKifYklVhaXN6JNFvmE+phyoIztgLJd1RWUxkSq6S0hMOJarss/uQ2AXESrJWiqm6K2BACk6rIgGw+AVFoYdga7/yrn/RggFJK9VxEV/512WNKNiIm15GR85E1lmUtQpGrDotER7eAx+VH0qjxCnAHIusstpFMTTZeOZL7C5OSPcxaVzbWpPh1HWmoZvBV0tvJ+e9bm7DgBsbzJgnkCR9quMnQoDfQY3QoDz0D9gzDvQ7l3E8VqOxUhZdS0iCvqf+GNOOl5ZV0nzRGGSsR21243jbmEhba020Ol0vMzCGCc9cQ9zbxUyNaT5NYMFqdbp5eVKRAWBgcyJPv/AS7/JIM0P+BaPyADbqr7B67Hq8+OWxWi/9+93xsLVLD4ODTGSnhN9JZ8j3xazjY3BKy9Bj23ZA1TaNoUAeFG53ETuMkVeFy38vXXj2rcJ3W4SrIYR90FFB4nFssprA6I+bi2C5ASeVGysGI3kFjkfgFrU913rAOoYbMrEZmOIZCWjERXWt005UG5bZ4QtDcr8j1JqvDcii/k6yuSDrakqR8ToKCF0JLpi2PGAJpoYAqE73VLP0YDLu/eDzHEUHCydwpMSbKQSSGWhkQnpsQtoUsf6Zg8K0dN787TUuL0YfZIsZ0Lu2/UktISsHYsmKjb08RydH9NxALRPmrfQfbsyAnJAyaVwME8r3R2kBuYT5JmvOvi1gGsJIOsqIpmdjNpD
 r4mwxGOQ
 QGpMwkgt4TUj7+VonQg6P2HooWkvkWQ9KcYsaLZNtgWi9gEUmuupnhwkM/N2Qw9JvK2nYbZBcHRtlS+sXeiILL2liSr8lWlY2mwY/DbLgb4RIBpZ9/wPlpS0qUYJhnu0nPVfm+/1MDPsIoETUb/nUKUnEx3RItPKsDGveiR+jFcsRlpI022Z3a0kQkZSG7F8FAS9YIvL3uYqfKCfqslenc/M5SlEOqSxR7eG+eQbgdbOI65nwkXNtcC+OUISjhoSfw6GnkPd3lqNMH/nNQiHXqLD+7oO3sIOWassjmI8jeldPflidqJVyXWOHtJVIO8XtXJGlB4G7fAF1HyhYAUqvqoKBv8wIgixmdzyqFzFnP3F60Iy4DPSWVa1tra8mMBQN7Xo2QJe8qVgWkC+jY7DYNPfm6RqLEtmKvddS443Z10aet1XNf350ihUdQBUIlJJkuolAycFFEFIBO8g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Kiryl,

On Tue, Apr 14, 2026 at 03:23:34PM +0100, Kiryl Shutsemau (Meta) wrote:
> This series adds userfaultfd support for tracking the working set of
> VM guest memory, enabling VMMs to identify cold pages and evict them
> to tiered or remote storage.

Thanks for sharing this work, it looks very interesting to me.

Personally I am also looking at some kind of VMM memtiering issues.  I'm
not sure if you saw my lsfmm proposal, it mentioned the challenge we're
facing, it's slightly different but still a bit relevant:

https://lore.kernel.org/all/aYuad2k75iD9bnBE@x1.local/

Unfortunately, that proposal was rejected upstream.

For us, it's so far more about migration and how migration process
introduce zero impact to guest workloads especially on hotness.  I'm not
sure if we have any shared goals over that aspect.

> 
> == Problem ==
> 
> VMMs managing guest memory need to:
> 1. Track which pages are actively used (working set detection)
> 2. Safely evict cold pages to slower storage
> 3. Fetch pages back on demand when accessed again
> 
> For shmem-backed guest memory, working set tracking partially works
> today: MADV_DONTNEED zaps PTEs while pages stay in page cache, and
> re-access auto-resolves from cache. But safe eviction still requires
> synchronous fault interception to prevent data loss races.
> 
> For anonymous guest memory (needed for KSM cross-VM deduplication),
> there is no mechanism at all — clearing a PTE loses the page.
> 
> == Solution ==
> 
> The series introduces a unified userfaultfd interface that works
> across both anonymous and shmem-backed memory:
> 
> UFFD_FEATURE_MINOR_ANON: extends MODE_MINOR registration to anonymous
> private memory. Uses the PROT_NONE hinting mechanism (same as NUMA
> balancing) to make pages inaccessible without freeing them.
> 
> UFFD_FEATURE_MINOR_ASYNC: auto-resolves minor faults without handler
> involvement. The kernel restores PTE permissions immediately and the
> faulting thread continues. Works for anonymous, shmem, and hugetlbfs.
> 
> UFFDIO_DEACTIVATE: marks pages as deactivated. For anonymous memory,
> sets PROT_NONE on PTEs (pages stay resident). For shmem/hugetlbfs,
> zaps PTEs (pages stay in page cache).
> 
> UFFDIO_SET_MODE: toggles MINOR_ASYNC at runtime, synchronized via
> mmap_write_lock. Enables the VMM workflow: async mode for lightweight
> detection, sync mode for race-free eviction.
> 
> PAGE_IS_UFFD_DEACTIVATED: PAGEMAP_SCAN category flag for efficient
> batch detection of cold (still-deactivated) anonymous pages.
> 
> == VMM Workflow ==

AFAIU, this workflow provides two functionalities:

> 
>     UFFDIO_DEACTIVATE(all)            -- async, no vCPU stalls
>     sleep(interval)
>     PAGEMAP_SCAN                      -- find cold pages

Until here it's only about page hotness tracking.  I am curious whether you
evaluated idle page tracking.  Is it because of perf overheads on rmap?  To
me, your solution (until here.. on the hotness sampling) reads more like a
more efficient way to do idle page tracking but only per-mm, not per-folio.

That will also be something I would like to benefit if QEMU will decide to
do full userspace swap.  I think that's our last resort, I'll likely start
with something that makes QEMU work together with Linux on swapping
(e.g. we're happy to make MGLRU or any reclaim logic that Linux mm
currently uses, as long as efficient) then QEMU only cares about the rest,
which is what the migration problem is about.

The other issue about idle page tracking to us is, I believe MGLRU
currently doesn't work well with it (due to ignoring IDLE bits) where the
old LRU algo works.  I'm not sure how much you evaluated above, so it'll be
great to share from that perspective too.  I also mentioned some of these
challenges in the lsfmm proposal link above.

>     UFFDIO_SET_MODE(sync)             -- block faults for eviction
>     pwrite + MADV_DONTNEED cold pages -- safe, faults block
>     UFFDIO_SET_MODE(async)            -- resume tracking

These operations are the 2nd function.  It's, IMHO, a full userspace swap
system based on userfaultfd.

Have you thought about directly relying on userfaultfd-wp to do this work?
The relevant question is, why do we need to block guest reads on pages
being evicted by the userapp?  Can we still allow that to happen, which
seems to be more efficient?  IIUC, only writes / updates matters in such
swap system.

Also, I'm not sure if you're aware of LLNL's umap library:

https://github.com/llnl/umap

That implemnted the swap system using userfaultfd wr-protect mode only, so
no new kernel API needed.

Thanks,

> 
> The same workflow applies to shmem, with a different PAGEMAP_SCAN mask
> (!PAGE_IS_PRESENT instead of PAGE_IS_UFFD_DEACTIVATED).
> 
> == NUMA Balancing ==
> 
> NUMA balancing scanning is skipped on anonymous VM_UFFD_MINOR VMAs to
> avoid protnone conflicts. NUMA locality stats are fed from the uffd
> fault path via task_numa_fault() so the scheduler retains placement
> data. Shmem VMAs are unaffected (UFFDIO_DEACTIVATE zaps PTEs there,
> no protnone involved).
> 
> == Testing ==
> 
> The series includes 6 new selftests covering async/sync modes,
> PAGEMAP_SCAN cold detection, GUP through protnone, UFFDIO_SET_MODE
> toggling, and cleanup on close. All 73 uffd unit tests pass
> (including hugetlb) across defconfig, allnoconfig, allmodconfig,
> and randomized configs.
> 
> Kiryl Shutsemau (Meta) (12):
>   userfaultfd: define UAPI constants for anonymous minor faults
>   userfaultfd: add UFFD_FEATURE_MINOR_ANON registration support
>   userfaultfd: implement UFFDIO_DEACTIVATE ioctl
>   userfaultfd: UFFDIO_CONTINUE for anonymous memory
>   mm: intercept protnone faults on VM_UFFD_MINOR anonymous VMAs
>   userfaultfd: auto-resolve shmem and hugetlbfs minor faults in async
>     mode
>   sched/numa: skip scanning anonymous VM_UFFD_MINOR VMAs
>   userfaultfd: enable UFFD_FEATURE_MINOR_ANON
>   mm/pagemap: add PAGE_IS_UFFD_DEACTIVATED to PAGEMAP_SCAN
>   userfaultfd: add UFFDIO_SET_MODE for runtime sync/async toggle
>   selftests/mm: add userfaultfd anonymous minor fault tests
>   Documentation/userfaultfd: document working set tracking
> 
>  Documentation/admin-guide/mm/userfaultfd.rst | 141 ++++-
>  fs/proc/task_mmu.c                           |  11 +-
>  fs/userfaultfd.c                             | 184 +++++-
>  include/linux/huge_mm.h                      |   6 +
>  include/linux/mm.h                           |   2 +
>  include/linux/sched/numa_balancing.h         |   1 +
>  include/linux/userfaultfd_k.h                |  21 +-
>  include/trace/events/sched.h                 |   3 +-
>  include/uapi/linux/fs.h                      |   1 +
>  include/uapi/linux/userfaultfd.h             |  40 +-
>  kernel/sched/fair.c                          |  13 +
>  mm/huge_memory.c                             |  33 +-
>  mm/hugetlb.c                                 |   3 +-
>  mm/memory.c                                  |  51 +-
>  mm/mprotect.c                                |   9 +-
>  mm/shmem.c                                   |   3 +-
>  mm/userfaultfd.c                             | 164 +++++-
>  tools/testing/selftests/mm/uffd-unit-tests.c | 458 +++++++++++++++
>  18 files changed, 1096 insertions(+), 48 deletions(-)
> 
> Kiryl Shutsemau (Meta) (12):
>   userfaultfd: define UAPI constants for anonymous minor faults
>   userfaultfd: add UFFD_FEATURE_MINOR_ANON registration support
>   userfaultfd: implement UFFDIO_DEACTIVATE ioctl
>   userfaultfd: UFFDIO_CONTINUE for anonymous memory
>   mm: intercept protnone faults on VM_UFFD_MINOR anonymous VMAs
>   userfaultfd: auto-resolve shmem and hugetlbfs minor faults in async
>     mode
>   sched/numa: skip scanning anonymous VM_UFFD_MINOR VMAs
>   userfaultfd: enable UFFD_FEATURE_MINOR_ANON
>   mm/pagemap: add PAGE_IS_UFFD_DEACTIVATED to PAGEMAP_SCAN
>   userfaultfd: add UFFDIO_SET_MODE for runtime sync/async toggle
>   selftests/mm: add userfaultfd anonymous minor fault tests
>   Documentation/userfaultfd: document working set tracking
> 
>  Documentation/admin-guide/mm/userfaultfd.rst | 141 +++++-
>  fs/proc/task_mmu.c                           |  11 +-
>  fs/userfaultfd.c                             | 184 +++++++-
>  include/linux/huge_mm.h                      |   6 +
>  include/linux/mm.h                           |   2 +
>  include/linux/sched/numa_balancing.h         |   1 +
>  include/linux/userfaultfd_k.h                |  21 +-
>  include/trace/events/sched.h                 |   3 +-
>  include/uapi/linux/fs.h                      |   1 +
>  include/uapi/linux/userfaultfd.h             |  40 +-
>  kernel/sched/fair.c                          |  13 +
>  mm/huge_memory.c                             |  33 +-
>  mm/hugetlb.c                                 |   3 +-
>  mm/memory.c                                  |  51 ++-
>  mm/mprotect.c                                |   9 +-
>  mm/shmem.c                                   |   3 +-
>  mm/userfaultfd.c                             | 164 ++++++-
>  tools/testing/selftests/mm/uffd-unit-tests.c | 458 +++++++++++++++++++
>  18 files changed, 1096 insertions(+), 48 deletions(-)
> 
> -- 
> 2.51.2
> 
> 

-- 
Peter Xu


