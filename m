Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B243CA5FE2
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C05786B0088; Fri,  2 Oct 2026 20:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5C16B008A; Fri,  2 Oct 2026 20:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4676B008C; Fri,  2 Oct 2026 20:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81EB66B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:50:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CCEDFC08AF
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:50:56 +0000 (UTC)
X-FDA: 85279485312.01.60AD2CE
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1AD4440005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:50:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QsYGqNkc;
	spf=pass (imf07.hostedemail.com: domain of rientjes@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790988655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhiZmVtW9NaeDOXqJJN58cJlU9iYxcpc0LuITj+6LgU=;
	b=glD1Emd2I0/aD+tH3xkiKrb8uqAsOO2CiPo+sVP0+Y7ktAVYakKl6yogkF8CKFSjmrpI1l
	47aPxaJILEBxXLdToxmBAsdCzHOo5nPktQl+Blq7Xrp1mjDRdZNqFZSSy//icbpQCrZx/l
	zLFOQTIS8VUrzNef1tUHYj6dyUfcNV0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QsYGqNkc;
	spf=pass (imf07.hostedemail.com: domain of rientjes@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790988655;
	b=XVrT5vt3atkX/o+fd/wa0RdKUJsT49suayb18UTN7cNXAtlM5tJwl+XTWwpes3YVc2bA68
	WDPGvmSWZNvg1OiWrCXurYZBIXAW8zvlMZaYX7EpDaFNWOMtbg6yZ4sO7d3EOfaEC67lGx
	TObv3rKtzv3d/cieU1ULe/38RSFAp6Q=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2db33db4de9so4865ad.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790988654; x=1791593454; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uhiZmVtW9NaeDOXqJJN58cJlU9iYxcpc0LuITj+6LgU=;
        b=QsYGqNkc+UdL7Cf8A05v4IrMb7tb2lJxFlWtUWC+uGh/lVB1/Nkm2hXPJV1QFcMOEZ
         lhIA++OCM5z++5P58armuEHVAYE7VBOIT9meux8MRK9tmRDIwYGS5X1jfgnAeO0jeyBB
         oAdgHqrTxI3AAqNhocqd8mBwvQQ2yHsghhi+EdyxZQUuwhHx48bEhKbmTaVBXcrm+EjY
         NO00SpO7TsEqjYeaKnNo2weVCPYSWSBwCnsdS3RwprqVZJ60SfUMbwnO9ODFAfojMZIM
         puTWprx3w3SKQM3Db0xnOF8wlx0Q7g/hkJqvWRuAh8z1jBvRXm/3V/sxa4IplRNmXRvM
         3Y2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790988654; x=1791593454;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uhiZmVtW9NaeDOXqJJN58cJlU9iYxcpc0LuITj+6LgU=;
        b=asFeadHTR4LlXcWHWd8n9L2WZD5hYGuTrebNAobnZZ/iPoXIT8kxm0MRIZwRmhwJ88
         1Vttre3iqpPr+ft2MVgCyqRS4eW1SxpzsBYi8M1Los2xrrwWQoSQCTvRilMGrHgAUz3P
         nKm2UFJsGN904PBNMaK+G9SPgagDVlmscsCTj+UDtWHHwX1sfcqZ9vrmLuf6TWi8m+hV
         zxcv6DFcbSTlVe6ijvxRL64zTntGO9kNt9DLDEzxzIgX72/j8GBhlwg7WKJfmjPsiVcr
         msTvhlcrASkrG2pwNcoWSEyb5OZKNCgAmjjQ1IP3NYsSc9+UBPt8m7W5QPF5W9fpPPx2
         +DRw==
X-Forwarded-Encrypted: i=1; AKwUvBxhDDau6yFpH4Ygd94qJn8NK5xZuWdUPIs961n/P5fCTbF31cmSZoKdTbq80nIZEeru5ptVGoYqGg==@kvack.org
X-Gm-Message-State: AFq9FYITdIqzwujW5928gYpxWT3TdqcBa5YgNe/QNeJ/B61c3QT8Zqxe
	1fe6coZ/N3+VaOjjDRVYf1jgkUpyoDuGMhP5+fP4A70Gz1vGiAfyhU9q4qQrR0Hnpg==
X-Gm-Gg: AYBFou29b8XYnxAquoismj/3qPaPymWPaq3E4lEDwE6MrEyLfOfw+zHWi2TCpuCCjeR
	DpzXhl5rtyacj8yBrP7/LwJbzRacAsJmxpbBH+SsLtPb9lHc8OeoBi/TqwyMNP/vIo9KqY4zszi
	wH5OfM5cfwhWZ8RVk/Sl61H9CI0/OeDjdwVLlAfc3McUm09jJqD694iFhwKl9i+5tBT/9d9B1oV
	ZSFJ7kDNt9IRFM/x+2h92KKLDnPlAziPR/04ry1qbDBBiQZMhLdXzLTjHhNyRoblPgWEQiTroZt
	bFFjiKKzKPJvNR83INdwNsgg7IFpG8MbI5Zq+T6ta4og/utljhel9mdrJVNiLthuFEMwu8E72c3
	SBdJXzChKMSHAwj2kwS5PWAcE+i/bNeDgsLfDFpi7PDTNitkXuGvgkO5NO4KSTvN2tiEnuP4oNX
	A+rfO7S1dL25QEisZ3cCjUGRPl08DoERqPf55fuMXYS02Z8HIoeEkqkf6nGreKUXbBKMYASPH5B
	fgXVVkhclqDz0Qvv0+38mcCPU2KvOuWHofmNCrXQZKL3zsQNRrvPAjeDNHxuexMuCoW7u1UZjBr
	Dph/EQu0iRTFZTxKOPCWAluCBjS3ve0KMRsetLQlZpovEX+0143hWdogaYFrFj/bedoqDDqVvOS
	JuWXtjPBI6NFaFcY=
X-Received: by 2002:a17:903:2312:b0:2e2:dfb8:8184 with SMTP id d9443c01a7336-2e5339613f9mr1485685ad.11.1790988652992;
        Fri, 02 Oct 2026 17:50:52 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:b188:21e:8df9:36e4] ([2a00:79e0:2eb4:9:b188:21e:8df9:36e4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78d661ef5sm781639a91.5.2026.10.02.17.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 17:50:52 -0700 (PDT)
Date: Fri, 2 Oct 2026 17:50:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [patch v4] mm: vmstat_kunit: add synthetic benchmark for vm
 stats
In-Reply-To: <e72f2134-94d8-41c8-a859-b12357222d95@kernel.org>
Message-ID: <915d8d8d-1813-3585-9cfb-acb536188a1e@google.com>
References: <cfc1edae-8aaa-8fd0-95de-af3d4774c6dd@google.com> <e72f2134-94d8-41c8-a859-b12357222d95@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1AD4440005
X-Stat-Signature: oje8y51ekruqnygsj7zzk6bjj4qfone7
X-HE-Tag: 1790988654-475607
X-HE-Meta: U2FsdGVkX1+R1dsZvbcYTNACc5KHiY6P7kinMi2jpT6dzUnk4IiV8gGpz9VqU0Y0+hFHJrvZlVNL0qK/4K8jDJTV+cY5f7nPNzBVhI9uYbU6Ireel7+8V7GIsjqEFAXWEBD/tsrm2R4vLPxGBhsY5pag1ZN39BaO2DOsVcFcivn6Nomjtb8IdOvk7JkdyN3lmPjrLh0LEdyAgc724UPJJBvgP2CNBBiTG7Vb6CYCHef/h80omempEHxOho80eaOmS7OSDVMPlAZ3Te66r2XE69EbKyU/bR+Dy3iIL9b3XYh29VGZiEHmoQ7H9NMO3VQud4gqmNRNOHUWXVgq1OpmLz4rZv4I7Wk4YBhQirSFUNUYUc9gkuRL3rqec3zeXeokNGowLD3RPswup3daMxj033hxpbssauC5vWbpguqtCxwtGQcnUtTvl4lZ6Gla3IjIv6HkkJEDmuk6BqKPCb8mkjovV3UmIS3x9rLQwgdwHhF2vngDqeUC3Knr6C9pQGEy/0FlVJYp/YT/V5Tnf7Ao5F9N9XKx6inLRTku0157vNJZ8vPpQUwlsCLaQWCixkFJGrO49s8w0qiWJMU6tcoudKat2FAuOM98Vt+i68d6xPx87uHBBugwVbyCX5VrxxjRF1w/MyG711quG+LC0ja0Tyr5/85MFxPPki/0jzCkP1EuprOPBz8mYAC4KgOWZ4tpga5nEdBTnFG4DYvvbXysXCjt5a5YCv0FrSh/Nk5Hzp6jDyVltm2fywl7R5k0yL+WBoDS2QySVLoFhGwUmew+QURcn+jqpS5fzskL0mE64JVwUM6fUe2aE3Bd0FkiSeDMkQ9gyRgMfTnx571zC82Q9+GBsa0l8qKOlMXJL/ZSOTbWJ9uSaYczjKzy90LfLk6q05s5eu/xLUEtFGITRBGBsKKJzKf5G0JPQ8YkBMRrDboAcXLbXgsilHEAAyKBJ2PITFT3R6zSYJTFDfugKZ2
 iu4rf249
 h3ZRzpFA0Dq27sMTYlU0+4x1c4RyNU8AtfCeJVLoI0oyIq6BTjvnDyD/SCupRuWRmcpR8gPwgw8aX0k65b7I9Q7wzWQCXDkO1u8Rq4Ns89lPze/hD2A1L02jRsC2QIWsBEQbgE8ftAZMZiyBT+L97oNojfVHzWJuxBOhbjoGaKKYKBcMxmh46pi7bdUQi8jJUr0ZLDJwUzmRYqwNFoiWXS915aWgGKOpMicJ/jrfHWQtu/1CNfdtvOkKH3UqiQDPDAd9z1pIeNxl02/Ez7lh6FbW2dlC0MG84oy3f5b3Dghni4/zaoNFbILVHtf6/s9WozXw02fdckKvvinNkIBFW4rmw4SgsAKspPUPwf++LXIDB45XGrnWZdcFAuyADRjlZU0SSoUPBQDln6nGWUcdauyLnH5tJbMzmoOmO5bfQxOart55kE5W6AHl8/T31WOQnmdAGzs7luTqemLzBnEoF2hUsfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Sep 2026, David Hildenbrand (Arm) wrote:

> On 9/18/26 22:39, David Rientjes wrote:
> > From: Christoph Lameter <cl@gentwo.org>
> > 
> > Add a synthetic benchmark that can be used to measure performance of VM
> > statistics.  This is used to analyze any improvements or regressions in
> > functions that are frequently used in hot code paths.
> > 
> > The test is run by KUnit or doing modprobe vmstat_kunit directly.
> > 
> > Sample output:
> >  KTAP version 1
> >  1..1
> >  KTAP version 1
> >  # Subtest: vmstat
> >  # module: vmstat_kunit
> >       1..3
> >       # vmstat_test_inc_dec_zone_page_state: 10000 ops: inc_zone_page_state -> 8 cycles (4 ns/op), dec_zone_page_state -> 9 cycles (4 ns/op)
> >       ok 1 vmstat_test_inc_dec_zone_page_state
> >       # vmstat_test_interleaved_zone_page_state: 10000 ops: inc/dec pair -> 17 cycles (8 ns/op)
> >       ok 2 vmstat_test_interleaved_zone_page_state
> >       # vmstat_test_count_vm_event: 10000 ops: count_vm_event -> 4 cycles (2 ns/op)
> >       ok 3 vmstat_test_count_vm_event
> >  # vmstat: pass:3 fail:0 skip:0 total:3
> >  # Totals: pass:3 fail:0 skip:0 total:3
> >  ok 1 vmstat
> > 
> > Assisted-by: Gemini:gemini-3.8-flash
> > Signed-off-by: Christoph Lameter <cl@gentwo.org>
> > Signed-off-by: David Rientjes <rientjes@google.com>
> > ---
> > v4:
> >  - included sample output in the commit description
> >  - switched to NR_MLOCK which is display only so no side effects
> >  - remove unnecessary "rem" variable
> > 
> > Once we're happy with this change, I'll apply the same treatment to the
> > proposed pgalloc and slab tests.
> > 
> >  MAINTAINERS             |   1 +
> >  mm/Kconfig              |  11 +++
> >  mm/Makefile             |   1 +
> >  mm/tests/vmstat_kunit.c | 157 ++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 170 insertions(+)
> >  create mode 100644 mm/tests/vmstat_kunit.c
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 3b2eb2a7a89a..de09076d91b9 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -17161,6 +17161,7 @@ F:	mm/ptdump.c
> >  F:	mm/sparse-vmemmap.c
> >  F:	mm/sparse.c
> >  F:	mm/sparse.h
> > +F:	mm/tests/vmstat_kunit.c
> >  F:	mm/util.c
> >  F:	mm/vmpressure.c
> >  F:	mm/vmstat.c
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index 604c58199acb..2d021fb5ace6 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -1511,6 +1511,17 @@ config LAZY_MMU_MODE_KUNIT_TEST
> >  
> >  	  If unsure, say N.
> >  
> > +config VMSTAT_KUNIT_TEST
> > +	tristate "KUnit test for VM statistics" if !KUNIT_ALL_TESTS
> > +	depends on KUNIT
> > +	default KUNIT_ALL_TESTS
> > +	help
> > +	  Enable this option to test and benchmark the performance of VM
> > +	  statistics updates (zone page state and VM event counters), which
> > +	  are used frequently in hot memory management code paths.
> > +
> > +	  If unsure, say N.
> > +
> >  source "mm/damon/Kconfig"
> >  
> >  endmenu
> > diff --git a/mm/Makefile b/mm/Makefile
> > index e7245cb88c66..3d4f2c43b8d3 100644
> > --- a/mm/Makefile
> > +++ b/mm/Makefile
> > @@ -147,4 +147,5 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
> >  obj-$(CONFIG_EXECMEM) += execmem.o
> >  obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
> >  obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
> > +obj-$(CONFIG_VMSTAT_KUNIT_TEST) += tests/vmstat_kunit.o
> >  obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
> > diff --git a/mm/tests/vmstat_kunit.c b/mm/tests/vmstat_kunit.c
> > new file mode 100644
> > index 000000000000..899c957091d1
> > --- /dev/null
> > +++ b/mm/tests/vmstat_kunit.c
> > @@ -0,0 +1,157 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * KUnit synthetic performance benchmark for VM statistics.
> > + *
> > + * (C) 2009 Linux Foundation, Christoph Lameter <cl@gentwo.org>
> > + * (C) 2026 Google LLC, David Rientjes <rientjes@google.com>
> > + */
> > +#include <kunit/test.h>
> > +#include <linux/mm.h>
> > +#include <linux/vmstat.h>
> > +#include <linux/timex.h>
> > +#include <linux/ktime.h>
> > +#include <linux/math64.h>
> > +
> > +#define TEST_COUNT 10000
> > +
> > +static void vmstat_test_free_page(void *arg)
> > +{
> > +	__free_page((struct page *)arg);
> > +}
> > +
> > +/*
> > + * Test 1: Sequential inc_zone_page_state() followed by dec_zone_page_state().
> > + * Net change to zone counters is 0.
> > + */
> > +static void vmstat_test_inc_dec_zone_page_state(struct kunit *test)
> > +{
> > +	struct page *page;
> > +	cycles_t time1, time2, time;
> > +	u64 t1_ns, t2_ns;
> > +	u64 inc_cycles, dec_cycles;
> > +	u64 inc_ns, dec_ns;
> > +	unsigned int i;
> > +
> > +	page = alloc_page(GFP_KERNEL);
> > +	KUNIT_ASSERT_NOT_NULL(test, page);
> > +	KUNIT_ASSERT_EQ(test, kunit_add_action_or_reset(test, vmstat_test_free_page, page), 0);
> > +
> > +	/* Benchmark inc_zone_page_state() */
> > +	time1 = get_cycles();
> > +	t1_ns = ktime_get_ns();
> > +	for (i = 0; i < TEST_COUNT; i++)
> > +		inc_zone_page_state(page, NR_MLOCK);
> 
> Just curious, could some compiler optimizations here change the picture, and
> doing the average would not actually be representative? Not sure if a barrier()
> would reliably avoid that.
> 
> Maybe not relevant today, but I do wonder if we should take care that it stays
> that way.
> 
> Applies to all cases below where we loop.
> This looks much cleaner to me, thanks!
> 

Thanks all for the feedback, answering all three emails here.

Andrew's questions are spot on and his assumptions are correct.  This is
the first of three tests previously posted that measure the execution
times of critical mm functions.  This is the simplest of the tests, the
others are for lots of concurrent allocations through the page allocator
and through the slab allocator.

It's anticipated to be used by developers to measure the impact of any
core changes that would end up causing workload performance issues since
things like vmstats, page allocations, and slab allocations are all hot
paths.  It could also be used to detect regressions over time, from
kernel version to kernel version, independent of development use cases.
So it could certainly be wired up to the kernel test robot.

We've carried this internally in our own test suite since Christoph
posted them back in 2009 :)  We can build with the tests enabled to
measure the impact of any changes in these areas.

The "pass:3" is an artifact of moving this test to kunit, the tests
themselves will not fail and we're only interested in the ns/op.

DavidH: I don't think the compiler can fold or merge the loop bodies, the
compiler shouldn't be able to see through the call to the exported symbol
and actually needs to call it 10,000 times :)  I don't think barrier()
adds anything.

I should make this test depend on CONFIG_VM_EVENT_COUNTERS, however,
otherwise that loop is going to be pretty fast.

If there aren't any concerns, I'll send out a v5 with that change.

