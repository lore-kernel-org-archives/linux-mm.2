Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CAA0C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 07:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9E956B00A1; Tue,  7 Jul 2026 03:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4F806B00A2; Tue,  7 Jul 2026 03:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F0F6B00A5; Tue,  7 Jul 2026 03:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFE536B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:21:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36B4F120349
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:21:38 +0000 (UTC)
X-FDA: 84961135476.18.1BA2E12
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4EC2C180003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:21:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PYpOBmTo;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783408896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RuL7lrFAhFFbC0DaxVnYi7IkQ87nYE6lxKOGL6gGHpI=;
	b=QfBzNgF6HO6YVGuTB9ljMoDLTj0aZa+2Gh7gWX58kszVOgSODr7VLnVkpqxOWY5hNojWyU
	6wukRGfc9RcXgaHESV5cL8YJLLGsqhtnLh3Gzo/m86tqPlJ+Py3W2Tx+/bl9CxFpZMd5w5
	jOJlSNV1wUJAIHptMW2JZvrzFwB2YFs=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PYpOBmTo;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783408896;
	b=7U2eK05czC/0Qie7cy5PFN8lcvcSvy+67OlBxLws70BnkD/7aMnB3k84jYH6JnSQ4IVbEo
	0GbpCPU7QPtRGi2oe7cu0GKA5xIiwcTl+C4AITD3Ma5V9Yw2cSIfaw7H+pYUs3BOy8imcV
	EHT37BHyLMH+cTIzsbm5NxPZfg/494M=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5aeb6bdeaeaso3020e87.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 00:21:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783408894; cv=none;
        d=google.com; s=arc-20260327;
        b=A4e1gp9Xa9O0gw0W8O4JPYzbqwoCE6HorM9vKaC8zd8BD0iUyNQJ/m96jI5HRJivoc
         wT1JItKpVpHaPquOjm1wkbiy1kuBO0H556B25QLAQtkPE3YjI9UASXWJAmwrf0W5i2x+
         6Nq2Nqmgaw7cWVRYHi4WMTSwBqejI7OUv5BMjn62eb7MJNOG9+OlyF9AKxi3P+jdD7ZM
         gAWeFkmJy0bUmQW/NLNfrYNjBm4NgUCofU0hQgqsDOPVQgltMFKXxl1A/JDXfIaA2eoW
         4jwtwX+uRHjkgYera+vq+UAvjSDs3jd4Q1eSEUA6hZtmqsvUOefFk+Q4143f133cP5a9
         2SBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RuL7lrFAhFFbC0DaxVnYi7IkQ87nYE6lxKOGL6gGHpI=;
        fh=KEtEFfb0DhVTkrgaBKweT3qcda9LW/2YwfGbZxX060A=;
        b=YXnLptXlPqevDyx620CBt/P8UWro2KEqjva1GVMKogypVDnGHvMt24qCF50+2yAWaq
         PxGN1hpECZs7SxhFEbgmRGLfvCNdYq3JXHAslLKQRq3QJxcpo5o3g98VKh91tO3goCvH
         RWIf/FvSyiGTi3IIP1jYKHFP09wE0E9JE2BhVbKo0Ygxad8trQ0vmO5cP59UXp6sjFAU
         ZCQCN0ZQHysOvOvz5ZUu+Rb4I11PxNI6iBNl4XQshOxrZXfgL7vYtlz3MFVEAOdLK70C
         PCqJ/6oRbA/rC0ynnxpyAMcoNx2okmQvjQ93RfPRdwALoNxPaqW03YRnd9vTZxLEITz+
         kRrw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783408894; x=1784013694; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RuL7lrFAhFFbC0DaxVnYi7IkQ87nYE6lxKOGL6gGHpI=;
        b=PYpOBmTocdJjxGtQlJh8GQo+OkPkn0Px+K4qrAQognz1pg0Id6KBDsbeWjAd7iFWNY
         ERHM9ZBh9rhGJNoqgQaBuqqSbndjTxBC/3K/rNAHOhkr/vDI2ZMRu8XO+B6VdJ6wrWLX
         itsYE0Ad8HQ1ynL8zUp66Sz1auJnABsDREH8liCiCma2P/CoKH/MDrU568U/tgvVHnFI
         q3MPFeDM+esXqn+FKi7k7UWBcs47wsOzrY1RYVxkn6j636rSck5ZnGh6QNY9hnocZgBL
         ki2LTG5PPz2mva1KLIKEanqvuO9qy7cNY/C4zT/kkKl10+9FhQwhLD8KcA7bUwd4g/kF
         5nLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783408894; x=1784013694;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RuL7lrFAhFFbC0DaxVnYi7IkQ87nYE6lxKOGL6gGHpI=;
        b=GVCm0fyumFASddJKy6rBkAJ7yM1F57FCnmo6lt8ThSejlNi7rxKC+P7AuBJuDbr4Qz
         5ifwQs9wgOlHPFiUiroAjdFG8Bkk9a9HiYLBgfPC5GViOEoigTwIAdTWaQJylyj+0dj6
         QyzhZsCVrDUIKn0TUocwIasn6RLHBd6IEu5W7L4CMig84fSxYUtk0IFYD9UpELwuco7h
         N3TA0mGEKfXDQhyeGgA/XyN34e2g4avsZZw7vnhzhr3RcjEKcIUhvBzA41iEmzhj67sP
         lAC+HwaAPj3GlDHadqN5M5UdpX8+NS5TEPz+zZq8tU2fbV2jAsKq6NatLLXZi8S1snqD
         2hlQ==
X-Forwarded-Encrypted: i=1; AHgh+RqjjRW5QJ1fon+BwpIHq1pK7Sg0/PnLpEoXSDMD3RhATMDuq2WINitqxopJMSnVv8/aylLBn286tw==@kvack.org
X-Gm-Message-State: AOJu0YySl/JxrO6H/O73PR+Th7yd0LbQtcAhOYMHMNJFMSnSuQ72qWL+
	kh9GuG9oqUEXONk2PC9zeefiultpmmfkc4TJSUrGcgfUtO4NfoiMTASMcwqTC4FGccK0/8qsS5h
	EwwdRkHZUgT4fE27vXZvQyLkOVXolJUO2CSeeCTcT
X-Gm-Gg: AfdE7cm7+Z0LS/kkrBSYLBgvKqLsXD6O+1VgrjY2Xfs6B7IgHN6X23mmX93nCC30rRN
	Is0WeBTvAR6eElc4CcPo9PVkvc+UsLGzrGZeVyJJAZtqw5ErIt+R/FHsM+FM1xUOELoJxcTkkl8
	1ImA8/JIF5FFkXtu6UDlUCx5SiOToQ04vkWQCLZwcSseyIS4fFO7aPTCPl7PhPgMiKdJvfjJPPw
	6oLh3clgKFhNb7Mk/RPYzgVk/SVqqdmbxo7YTEfmlGYT61x297kmTL7r0KKPgwZkv1w9ebekks+
	7tFk56WkDcPbbd2KZodZ5KEBmUHEGivzvptf+cAdJuYCAAc11y88XKEFNUiXOg==
X-Received: by 2002:ac2:4f05:0:b0:5ae:aff3:3eab with SMTP id
 2adb3069b0e04-5b00ad136f4mr95410e87.3.1783408894149; Tue, 07 Jul 2026
 00:21:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260707064235.1386552-1-souravpanda@google.com> <20260707024744-mutt-send-email-mst@kernel.org>
In-Reply-To: <20260707024744-mutt-send-email-mst@kernel.org>
From: Sourav Panda <souravpanda@google.com>
Date: Tue, 7 Jul 2026 00:21:22 -0700
X-Gm-Features: AVVi8CfKV_0_sx6GsBkVajWa1tfSd9GrFQw1r5LpgNz3KY7jvpoCzYNvR5XKQh4
Message-ID: <CANruzcTiDCi_xg=FyykAgnrstvwGqzRDOeHQxu6LAJ_LdYDygw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] mm/hugetlb: Dynamic, NUMA-aware HugePage Cache &
 Free Page Reporting
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, mhklinux@outlook.com, 
	fvdl@google.com, gthelen@google.com, mike.kravetz@oracle.com, 
	pasha.tatashin@soleen.com, rientjes@google.com, riel@surriel.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4EC2C180003
X-Stat-Signature: aqx5effizxwk1oecj5855kdycngwnz94
X-HE-Tag: 1783408896-941792
X-HE-Meta: U2FsdGVkX1/enibJU/lSRqroBw7hiQlykc1jDUI2ITMifx88VrH+ZJmNSBu6SO/cFc3CMyJ/XTuSmh89VOIto7O7bZE1/o5qSAMgmrmvCCmhOXKnDNsMGNvLyaqIovL9NvXL6e/BZllHHDyqI0WKXdQp93kCKhXuvMK1EUNLXcPZEzCSQWREdRqfp57z2PpKW8uip5QNWbF10LTR46zeTuXjKB4NBq6xEP3jLi0UZW1uTp+dcQC0USEJuriUxD3iVYE1Nd1Z5RLk5RYq+CNREkf0j/EyRVgvnqmgApyB7MVroZLuBvfS5OC7ExKraq3bEqxQaPeLUcJt0ptuyjo1Omhk3ustNUNlJO5tob5OblpYy9m6PHFaP1KatshIVeRkxOZW06cgH8EA+QHMTozfimrXLOGha7ZnsVTz8xtK6+v5ndQuJBSr/v+bKbiBGAcjcQwt3M14PlgZYFOGurlljiM3HWsSCr4ROoG2u8+uqTsmisgThkL/h8rToI55Fy2wECKItVH/Rbf7HYIlgyKk2HQ2WLivAHDXir7e0FUTbBx4QVLa3OWf1GbXhUWUvT9pmn6lralQOwWlZLmXnmSjyeg2rlpyjnVs2mKG2Lyr6R57hCF3a6wO+rZY8N0USs/fZXfQLrLbuIj8Jx0whr3WrQBdLaFPD6DpfkRk/Mn0PmkjuNJj0upoSahGSNTiYqluaxcz225OizRJMlkHq7XBUTnF7AA/oEzhJTYV3MN66Uoas7cLf6elkrB8QCC2NTJBIMXpuEvM69mx0RvbAPgu6OC7/uO0fg4aJKxm2FRqfvyiE1b2DSm8qG88DfyhzGD0fnPLtWM0o8n67jyJA0BA0Mvv5r7SEM9KHgvUm1F7U1GCmBO8cMj86FWWzlK/rbFsSN3D+8nxEb/sju6DxMLFcZwEs3uBGF+/Yu0Um2ihFC7FmpjfiFf5uE7pB5K85raIwGaOVf49qMsqzjTmr/A
 4uW7AqD5
 5CFh8OVA6UzOlZEXc+q5NVrdjniFSA8iLsDHFitU61GOUmfhlgbfa+Ji4iERStANMFS+5SKaUvIq2w5UfceUuBgfN7jctl3UN5aB/pz0Eun3mzU8fpVM9BhNhtUlmzWO9I0ImKj1A1LKa4HJid5KXcv9v+Vx9CG72Y7WCSMbafFkGumZIlYTtLoSWfS5IVXllJImLibjjWAtKKHVrpJ72TfznpOr3SJlZVFdtxilpc55BsSLK7ZIfUJFoEtWGvgk1jp43kaAF6zhM73U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 11:57=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Tue, Jul 07, 2026 at 06:42:29AM +0000, Sourav Panda wrote:
> > Overview
> > This patch series introduces a dynamic, NUMA-aware HugePage Cache,
> > backed by a kernel shrinker to safely return memory under pressure, and
> > integrates it with Free Page Reporting (virtio-balloon) for HugeTLB,
> > specifically targeting gigantic (1GB) hugepages. The goal is to solve
> > the tradeoff between allocation latency and memory
> > fungibility in virtualized and heterogeneous cloud environments.
> >
> > ---
> >
> > The Core Problem: Allocation Latency vs. Memory Fungibility
> >
> > With highly heterogeneous workloads, latency-critical applications dema=
nd
> > gigantic hugepages. However, dynamic runtime allocation of 1GB pages
> > from the buddy allocator (via CMA) is slow.
> >
> > To bypass this latency, operators often pre-allocate hugepages
> > statically. However, this locks up the memory: when the HugeTLB
> > workloads are idle, that memory is completely unavailable for other
> > buddy-allocator workloads (e.g., page cache, anonymous memory). If budd=
y
> > memory is exhausted, the system will OOM even if gigabytes of HugeTLB
> > pages are sitting idle.
> >
> > This series resolves this challenge by delivering Dynamic Fungibility:
> >
> > 1.  Dynamic Caching: Intercepts freed surplus hugepages and recycles
> >     them into a NUMA-aware cache instead of dissolving them immediately=
.
> > 2.  Fast Allocations: Satisfies subsequent dynamic allocations
> >     instantly from this warm, local hugepage cache.
> > 3.  Kernel Shrinker Integration: Registers a NUMA-aware kernel shrinker
> >     to dynamically dissolve cached pages back to the buddy allocator
> >     under memory pressure, restoring host/guest memory fungibility.
> > 4.  Free Page Reporting Integration: For virtualized environments (Gues=
t
> >     VMs),
>
> I was going to look into this part, thanks for working on this.
>
> > cached pages trigger background Free Page Reporting via
> >     virtio-balloon. This allows the host to reclaim the physical memory
> >     while the guest retains its Vmemmap Optimization (HVO) metadata
> >     savings (~14GB saved per 1TB VM)!
>
> Why "!" - that's 1.5%, seems surprisingly modest.
> Are you sure it's working as intended?

I phrased it poorly, my bad! Thanks for pointing out Michael :)

That ~14GB is only the guest struct page savings. Meanwhile, the host
is reclaiming the full underlying physical memory of the cached
hugepages via FPR. I do not have a number for this yet.

Let me reword this in the next iteration.


>
> >   +---------------+   Slow Allocate  +---------------------+
> >   | Buddy         | ---------------> | Active HugeTLB Page |
> >   | Allocator     |                  +---------------------+
> >   +---------------+                    |                ^
> >     ^                                  | (1) Free to    | (2) Fast
> >     | (3) Under                        v     Cache      |     Allocate
> >     | Pressure                       +---------------------+
> >     | Shrink()  <------------------- | HugeTLB Cache       |
> >                                      +---------------------+
> >                                        |
> >                                        v (4) Free Page Reporting
> >                                          (Host Reclaim in the case
> >                                           of virtualization)
> >
> > ---
> >
> > Patch Series Structure
> >
> > Patch 1/6: mm/hugetlb: add Kconfig and basic cache infrastructure
> >   - Introduces the CONFIG_HUGETLB_CACHE option, hstate tracking fields,
> >     and the HPG_cached page flag.
> >   - Establishes the clean helper API (hugetlb_folio_is_cached(),
> >     hugetlb_cache_remove(), hugetlb_cache_add()) and updates
> >     remove_hugetlb_folio() to be cache-aware, eliminating inline #ifdef
> >     blocks.
> > Patch 2/6: mm/hugetlb: implement cache recycling and allocation
> >   - Hooks up recycling in free_huge_folio() (up to the cache limit) and
> >     allocation in alloc_surplus_hugetlb_folio().
> >   - Implements MRU allocation policy for maximum warmth, poison safety
> >     checks, and MTE/dcache cleaning.
> > Patch 3/6: mm/hugetlb: add sysfs interfaces for cache
> >   - Exposes global and per-node sysfs attributes (max_cached_huge_pages=
,
> >     nr_cached_hugepages) for dynamic userspace control, including NUMA
> >     memory policy scaling.
> >   - Supports dynamic delta adjustments (+1/-1) to safely scale cache
> >     sizes alongside concurrent background reclaim operations.
> > Patch 4/6: mm/hugetlb: add memory shrinker for cache
> >   - Registers a NUMA-aware kernel shrinker to evict and dissolve cached
> >     gigantic pages back to buddy under memory pressure.
> > Patch 5/6: Documentation/admin-guide/mm/hugetlbpage.rst: document cache
> >     interfaces
> >   - Documents the Kconfig option, sysfs attributes, and shrinker
> >     behavior in the admin guide.
> > Patch 6/6: mm/hugetlb: support free page reporting for cached hugepages
> >   - Integrates the cache with the Free Page Reporting framework (virtio=
-
> >     balloon), introducing the HPG_reported flag and the
> >     reporting/isolation/draining lifecycle.
> > Sourav Panda (6):
> >   mm/hugetlb: add Kconfig and basic cache infrastructure
> >   mm/hugetlb: implement cache recycling and allocation
> >   mm/hugetlb: add sysfs interfaces for cache
> >   mm/hugetlb: add memory shrinker for cache
> >   Documentation/admin-guide/mm/hugetlbpage.rst: document cache
> >     interfaces
> >   mm/hugetlb: support free page reporting for cached hugepages
> >
> >  Documentation/admin-guide/mm/hugetlbpage.rst |  34 +-
> >  fs/Kconfig                                   |   9 +
> >  include/linux/hugetlb.h                      |  45 ++
> >  include/linux/page_reporting.h               |   1 +
> >  mm/hugetlb.c                                 | 590 ++++++++++++++++++-
> >  mm/hugetlb_internal.h                        |   9 +
> >  mm/hugetlb_sysfs.c                           | 158 +++++
> >  mm/page_reporting.c                          |  10 +-
> >  mm/page_reporting.h                          |   6 +
> >  9 files changed, 844 insertions(+), 18 deletions(-)
> >
> > --
> > 2.55.0.rc0.799.gd6f94ed593-goog
>

