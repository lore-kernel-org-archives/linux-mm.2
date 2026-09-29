Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E9F3CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 04:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5E06B008C; Tue, 29 Sep 2026 00:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5FAA6B0092; Tue, 29 Sep 2026 00:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C76116B0096; Tue, 29 Sep 2026 00:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB116B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:23:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25E5C1C26E2
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:23:37 +0000 (UTC)
X-FDA: 85265506074.26.8DE2451
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id F19BA180005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:23:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WaEAiyFO;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790655815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GWvSOOqVTAz3Wcu5avR6xu8eL6h5B0Xus2IHL6Dce0=;
	b=nmJcKNnPruNhiJPpatolSimOgnifP4GJ0rIGieYb/qIPuOoOnfDwYcUDo1yhh/TXtPh7KT
	920uh3xwxDYgJ/EbhTehZznMnuflx8xivaPBWj1cUQt2azRQaOKzTzxIRPQjN3wwkJFbPG
	ngi5st4TsAFFOHRdZciP6zCSJK3ZLcI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WaEAiyFO;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790655815;
	b=SyhLUo4R3zqRlaH9835h7UYeHEV3ApFaCYUQydqBHgDIytfhjKiEfvfmBuEO9opU7w7B8H
	u4mh7K7tV0c70ruLz5ipns43Gyuceng9H/YfXgUhGyVfjOBlyqjVEwHKRV2KjNRq8EsTjG
	2Bv3LylRfGMB7GPRxX3RVev9m2kVnSM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69FF21655;
	Mon, 28 Sep 2026 21:23:30 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A5863F85F;
	Mon, 28 Sep 2026 21:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790655813; bh=38gpMZNPpqnqqQ/VxkZAtTNQl9I02Z0TkAk9crVDC7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WaEAiyFOIeFJRacHEmYjHfBnHDEOzs7PI85OKuaWjrFXIMlpxg8+Y+RmB/WUJrD7T
	 MBU0eEE4JPAlCGYAb4X/quWV+Ho5soGIiCoiMPD3Q1XG0N/1mH7XUIFRTTHfyYlJ30
	 n5N+50XwZD8f/U9/xZe6UEVOZniNRPvY2c3FPlmE=
Date: Tue, 29 Sep 2026 09:53:30 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [patch v4] mm: vmstat_kunit: add synthetic benchmark for vm stats
Message-ID: <sknjqkoobsbq6xljd63pon6ohksrdd4kco3tatxueqk2g2boj7@ocuy23vkghai>
References: <cfc1edae-8aaa-8fd0-95de-af3d4774c6dd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfc1edae-8aaa-8fd0-95de-af3d4774c6dd@google.com>
X-Stat-Signature: d7s54hs6jxhifm9pi9eogu1cggfoff8o
X-Rspamd-Queue-Id: F19BA180005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790655814-807339
X-HE-Meta: U2FsdGVkX18S8vsZzIxjWbaHJhRmkT7tbQqiDPEBcgno96rtfdtweStbaoPDiHl6BWNRMal7VekihbhGPa+staAW5s3FGKUABx7RknoTOlyrkztI1Zrvd3NIFMLzhbRADMC4wHD68ca4aBd0WD8vd13P4rDQKWcQ9yU/16PATu5IXkqKmaoaQwgqh2SeGk1IUoYVtbqiHxaNn5LCt/yW3ISy9zdm+UonZY781JEge9uhXPJ4Drmz9pBhW1AP+Q6OT0bRZvU2Iv0mTOG7tkbK/zWeZrD5nyd0kbb77Slc4rOF6PkdgJetJV/mgFILDwmfnqCqhwYR7J3ecIPbx2Y8/K0UIRuHzqY7U9hvjKRaVQzvy8nZwTpMxc9iiqD/K5mUye5CGfUMAD58JideDupzzkGDbDv/dXbuUBgA//g+Fo7e9h7R3fk3cbXe+gUl9z9vRtU1M2j2g4J3Jtv/KWp4IK5eyNbRSF61nyfpCVXY7ZRzQYT7Be6cmaPV7UIdZmkIcPsdQLRJmU/jnval5vicDUtOzqflpWRjCxalrmVWW4OstcuyfR8ykch2AQ281IkWiZbT4sWkp3RXru1MFiIG+ySCd5PJ77nHk7lEZuiF7NWaH0/8E6hklAtLqLoj2WsKmBuh9FMY8C5VcSEcKdFfwN2XhPttuupiBDW8KIKzwcS/CoqwEkYdQhb0MCXg4kH21KhDcAmL1eIcA7J1d9n0KthI/P4y4TTNhonccyAfilBSx0cUqsmXf5SBFGECXWRGWYq7EgegyrYBACl3zMY8RecgTy57lILXhZtwqUPYuO3yk3fH/x3VKCxQ9+iOx782iLqPUNCTniugelG/eE4mCOaxleX/djk7MfOKb7cQOlNMqQzoF22EYxSMgpBpemjTNXdotNK6KCWwcwH8s9f4gFfvQImFUO0d6zrlicLC2TzWkfMpoywaoBtkUf1YwVmWcPFnFzOyWj6/zky7vR4
 Hgi7geW0
 1YddfxGBPeO6iH4xCETJIPcl5Hw4+C8s7K7rSVBbI1eDsmgGqAVQA3LyrTYp+SJbtkIyo0aRDFwSBvp5NzRYUo+EJ61fU4bDcpVZCtAInH8VW0FezoRMXkVowjQ6BQCKn4/Nh+o7Nbbk7hsezu/yU+gwevKRG8Uj0h6nzYu09o29pORI7+yKvrObTEuenYgK8kLk1Q5V7d4WLixs68SElrQgeOJ1rXEzRbP1ILDiPE+xn3YHFUQKoLzyI7vFRuWhEQP/B9YXuALYdRBZdJrHrGEeSRLJw6FzurimptpmwELXMLBHEG1+Iir4pnMTJ+OvfOZljqq/siKQqTpQs/MuDIpVs2Slst9IBU6/kW0InF5rlwRgySejGAnFqjhCfzgU3TaBvY2a+PNDMIIH5DIRO1KYzNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 01:39:52PM -0700, David Rientjes wrote:
> From: Christoph Lameter <cl@gentwo.org>
> 
> Add a synthetic benchmark that can be used to measure performance of VM
> statistics.  This is used to analyze any improvements or regressions in
> functions that are frequently used in hot code paths.
> 
> The test is run by KUnit or doing modprobe vmstat_kunit directly.
> 
> Sample output:
>  KTAP version 1
>  1..1
>  KTAP version 1
>  # Subtest: vmstat
>  # module: vmstat_kunit
>       1..3
>       # vmstat_test_inc_dec_zone_page_state: 10000 ops: inc_zone_page_state -> 8 cycles (4 ns/op), dec_zone_page_state -> 9 cycles (4 ns/op)
>       ok 1 vmstat_test_inc_dec_zone_page_state
>       # vmstat_test_interleaved_zone_page_state: 10000 ops: inc/dec pair -> 17 cycles (8 ns/op)
>       ok 2 vmstat_test_interleaved_zone_page_state
>       # vmstat_test_count_vm_event: 10000 ops: count_vm_event -> 4 cycles (2 ns/op)
>       ok 3 vmstat_test_count_vm_event
>  # vmstat: pass:3 fail:0 skip:0 total:3
>  # Totals: pass:3 fail:0 skip:0 total:3

Is not "pass:3" misleading ? KUNIT tests here dump performance numbers,
hence how they could be treated as pass or fail ? What's the objective
for these tests ?

>  ok 1 vmstat
> 
> Assisted-by: Gemini:gemini-3.8-flash
> Signed-off-by: Christoph Lameter <cl@gentwo.org>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
> v4:
>  - included sample output in the commit description
>  - switched to NR_MLOCK which is display only so no side effects
>  - remove unnecessary "rem" variable
> 
> Once we're happy with this change, I'll apply the same treatment to the
> proposed pgalloc and slab tests.
> 
>  MAINTAINERS             |   1 +
>  mm/Kconfig              |  11 +++
>  mm/Makefile             |   1 +
>  mm/tests/vmstat_kunit.c | 157 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 170 insertions(+)
>  create mode 100644 mm/tests/vmstat_kunit.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3b2eb2a7a89a..de09076d91b9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17161,6 +17161,7 @@ F:	mm/ptdump.c
>  F:	mm/sparse-vmemmap.c
>  F:	mm/sparse.c
>  F:	mm/sparse.h
> +F:	mm/tests/vmstat_kunit.c
>  F:	mm/util.c
>  F:	mm/vmpressure.c
>  F:	mm/vmstat.c
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 604c58199acb..2d021fb5ace6 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1511,6 +1511,17 @@ config LAZY_MMU_MODE_KUNIT_TEST
>  
>  	  If unsure, say N.
>  
> +config VMSTAT_KUNIT_TEST
> +	tristate "KUnit test for VM statistics" if !KUNIT_ALL_TESTS
> +	depends on KUNIT
> +	default KUNIT_ALL_TESTS
> +	help
> +	  Enable this option to test and benchmark the performance of VM
> +	  statistics updates (zone page state and VM event counters), which
> +	  are used frequently in hot memory management code paths.
> +
> +	  If unsure, say N.
> +
>  source "mm/damon/Kconfig"
>  
>  endmenu
> diff --git a/mm/Makefile b/mm/Makefile
> index e7245cb88c66..3d4f2c43b8d3 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -147,4 +147,5 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
>  obj-$(CONFIG_EXECMEM) += execmem.o
>  obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
>  obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
> +obj-$(CONFIG_VMSTAT_KUNIT_TEST) += tests/vmstat_kunit.o
>  obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
> diff --git a/mm/tests/vmstat_kunit.c b/mm/tests/vmstat_kunit.c
> new file mode 100644
> index 000000000000..899c957091d1
> --- /dev/null
> +++ b/mm/tests/vmstat_kunit.c
> @@ -0,0 +1,157 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * KUnit synthetic performance benchmark for VM statistics.
> + *
> + * (C) 2009 Linux Foundation, Christoph Lameter <cl@gentwo.org>
> + * (C) 2026 Google LLC, David Rientjes <rientjes@google.com>
> + */
> +#include <kunit/test.h>
> +#include <linux/mm.h>
> +#include <linux/vmstat.h>
> +#include <linux/timex.h>
> +#include <linux/ktime.h>
> +#include <linux/math64.h>
> +
> +#define TEST_COUNT 10000
> +
> +static void vmstat_test_free_page(void *arg)
> +{
> +	__free_page((struct page *)arg);
> +}
> +
> +/*
> + * Test 1: Sequential inc_zone_page_state() followed by dec_zone_page_state().
> + * Net change to zone counters is 0.
> + */
> +static void vmstat_test_inc_dec_zone_page_state(struct kunit *test)
> +{
> +	struct page *page;
> +	cycles_t time1, time2, time;
> +	u64 t1_ns, t2_ns;
> +	u64 inc_cycles, dec_cycles;
> +	u64 inc_ns, dec_ns;
> +	unsigned int i;
> +
> +	page = alloc_page(GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_NULL(test, page);
> +	KUNIT_ASSERT_EQ(test, kunit_add_action_or_reset(test, vmstat_test_free_page, page), 0);
> +
> +	/* Benchmark inc_zone_page_state() */
> +	time1 = get_cycles();
> +	t1_ns = ktime_get_ns();
> +	for (i = 0; i < TEST_COUNT; i++)
> +		inc_zone_page_state(page, NR_MLOCK);
> +	t2_ns = ktime_get_ns();
> +	time2 = get_cycles();

get_cycles() will count for both ktime_get_ns() in the above code block.
Is not the goal here to characterize just inc_zone_page_state() ?

> +
> +	time = time2 - time1;
> +	inc_cycles = div_u64(time, TEST_COUNT);
> +	inc_ns = div_u64(t2_ns - t1_ns, TEST_COUNT);
> +
> +	/* Benchmark dec_zone_page_state() */
> +	time1 = get_cycles();
> +	t1_ns = ktime_get_ns();
> +	for (i = 0; i < TEST_COUNT; i++)
> +		dec_zone_page_state(page, NR_MLOCK);
> +	t2_ns = ktime_get_ns();
> +	time2 = get_cycles();
> +
> +	time = time2 - time1;
> +	dec_cycles = div_u64(time, TEST_COUNT);
> +	dec_ns = div_u64(t2_ns - t1_ns, TEST_COUNT);
> +
> +	if (inc_cycles || dec_cycles)
> +		kunit_info(test, "%u ops: inc_zone_page_state -> %llu cycles (%llu ns/op), dec_zone_page_state -> %llu cycles (%llu ns/op)\n",
> +			   TEST_COUNT, inc_cycles, inc_ns, dec_cycles, dec_ns);
> +	else
> +		kunit_info(test, "%u ops: inc_zone_page_state -> %llu ns/op, dec_zone_page_state -> %llu ns/op\n",
> +			   TEST_COUNT, inc_ns, dec_ns);
> +}
> +
> +/*
> + * Test 2: Paired inc_zone_page_state() and dec_zone_page_state().
> + * Net change to zone counters is 0.
> + */
> +static void vmstat_test_interleaved_zone_page_state(struct kunit *test)
> +{
> +	struct page *page;
> +	cycles_t time1, time2, time;
> +	u64 t1_ns, t2_ns;
> +	u64 avg_cycles, avg_ns;
> +	unsigned int i;
> +
> +	page = alloc_page(GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_NULL(test, page);
> +	KUNIT_ASSERT_EQ(test, kunit_add_action_or_reset(test, vmstat_test_free_page, page), 0);
> +
> +	time1 = get_cycles();
> +	t1_ns = ktime_get_ns();
> +	for (i = 0; i < TEST_COUNT; i++) {
> +		inc_zone_page_state(page, NR_MLOCK);
> +		dec_zone_page_state(page, NR_MLOCK);
> +	}
> +	t2_ns = ktime_get_ns();
> +	time2 = get_cycles();
> +
> +	time = time2 - time1;
> +	avg_cycles = div_u64(time, TEST_COUNT);
> +	avg_ns = div_u64(t2_ns - t1_ns, TEST_COUNT);
> +
> +	if (avg_cycles)
> +		kunit_info(test, "%u ops: inc/dec pair -> %llu cycles (%llu ns/op)\n",
> +			   TEST_COUNT, avg_cycles, avg_ns);
> +	else
> +		kunit_info(test, "%u ops: inc/dec pair -> %llu ns/op\n",
> +			   TEST_COUNT, avg_ns);
> +}
> +
> +/*
> + * Test 3: count_vm_event() benchmark.
> + * Restores counter balance with count_vm_events(item, -TEST_COUNT).
> + */
> +static void vmstat_test_count_vm_event(struct kunit *test)
> +{
> +	cycles_t time1, time2, time;
> +	u64 t1_ns, t2_ns;
> +	u64 avg_cycles, avg_ns;
> +	unsigned int i;
> +
> +	time1 = get_cycles();
> +	t1_ns = ktime_get_ns();
> +	for (i = 0; i < TEST_COUNT; i++)
> +		count_vm_event(SLABS_SCANNED);
> +	t2_ns = ktime_get_ns();
> +	time2 = get_cycles();
> +
> +	/* Restore balance */
> +	count_vm_events(SLABS_SCANNED, -TEST_COUNT);
> +
> +	time = time2 - time1;
> +	avg_cycles = div_u64(time, TEST_COUNT);
> +	avg_ns = div_u64(t2_ns - t1_ns, TEST_COUNT);
> +
> +	if (avg_cycles)
> +		kunit_info(test, "%u ops: count_vm_event -> %llu cycles (%llu ns/op)\n",
> +			   TEST_COUNT, avg_cycles, avg_ns);
> +	else
> +		kunit_info(test, "%u ops: count_vm_event -> %llu ns/op\n",
> +			   TEST_COUNT, avg_ns);
> +}
> +
> +static struct kunit_case vmstat_test_cases[] = {
> +	KUNIT_CASE(vmstat_test_inc_dec_zone_page_state),
> +	KUNIT_CASE(vmstat_test_interleaved_zone_page_state),
> +	KUNIT_CASE(vmstat_test_count_vm_event),
> +	{}
> +};
> +
> +static struct kunit_suite vmstat_test_suite = {
> +	.name = "vmstat",
> +	.test_cases = vmstat_test_cases,
> +};
> +kunit_test_suite(vmstat_test_suite);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Christoph Lameter <cl@gentwo.org>");
> +MODULE_AUTHOR("David Rientjes <rientjes@google.com>");
> +MODULE_DESCRIPTION("KUnit benchmark test for VM statistics");

