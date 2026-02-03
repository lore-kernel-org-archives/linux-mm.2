Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64E14E83040
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 02:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 923C56B0005; Mon,  2 Feb 2026 21:45:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D1866B0088; Mon,  2 Feb 2026 21:45:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DDD86B0089; Mon,  2 Feb 2026 21:45:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 691696B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 21:45:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0AC4913A9C2
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:45:56 +0000 (UTC)
X-FDA: 84401605512.20.B2FA024
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 77B8EA0002
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:45:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aq7FPcLK;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770086754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YBaguH+9NwB8kKYTtoXFDuNecMGYIpEQDhgeb5wP9hI=;
	b=AN5nL4ceReRAvmvZbPLGu4nin4Cs0PNwni+vqYAReWjy8mwfKEySU3LLu6DBSzJi6YlsTq
	Sc3NVpCdtG5t7IJRfB0hvbjrCh7EMH1oWe8r4OUqsps69qQmAbzYAgLkfHymegaGjKo9Ye
	RlSJ+BT/HfpnJ0OndljRJz81FCuRMoI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770086754; a=rsa-sha256;
	cv=none;
	b=Tu2NqvlX5uAtQ41S/LdOj1G3rxLAkvZmtZ/C0gNzTFxZl6X5bV3FVPNxTbU9NMj6yJWzrB
	7go+ht1/HI10awWFZZ1nvPnSZPFQ23gOYQfrWA40DAWBiW+ChZ3i6qCFRuDmObGMumd1o5
	+V26NqydSQ71Vd3PCJfEU0IebEmLpcQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aq7FPcLK;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A4FD560010
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51663C116C6
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770086753;
	bh=7StDnkM6FRjBqhGiWdFwOVCvqm9+fMfr3S04E8rB6zA=;
	h=Date:From:To:Subject:From;
	b=aq7FPcLK63HPxdGX4OutJekxLnJ7gDUYAZTOhdXOwxwPQ4erBFhDjsYDqhEM+LLNv
	 z4suevlZM92bjBbI71ctp/KSl926ONUOgzeMlAlG0u6UDakG6QEXIGJCAjOjdNw+8o
	 ZmH2l580jahM7R2RTKYCtfaQgHpBjVcXoDae3eXI=
Date: Mon, 2 Feb 2026 18:45:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Subject: mm.git review status (mm-stable)
Message-Id: <20260202184552.23fee27882d83b753aaf0e40@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 77B8EA0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: jthfc6rsugpcd34dfs1qi4fj4j6okim4
X-HE-Tag: 1770086754-76493
X-HE-Meta: U2FsdGVkX1/d3bY/BtBzdKHSfRrV7KB6FEpDiviNi2Gra+L9lPaVaq0uBqVCvkMi4XXZppNacVl++wTnoYtz28koMaobGfozMOVxgdEtkqaIY2wRQRO9BWahTjdMUw6cKt98Dg2l6UM4oURn1E2FVtsec5Gs/GBDoXKsrY9YzfYRKRaVkYsMkzcVkJA29xyDjiOH1UwrixZcQHDBGLcZvFRJ/4AMyJQUEemJvrQXwD486UTOkGLA9riJzI722cZMdCaxUD6Mia37usz7Vih00dS+C1ydi7n0QZsjq6p5TSRDJIKA0rxN+0tmI52QZ3sM9FhUi4dVm9mm3iEBQTc9+qnovxv0ySGSLlKzrgvh03wpTqc508salroNUkZ9X6dDJ77ljSZQHc3/W79WkLwcy2uHGAdKrU8ljkxsNDFKHfNHaYZ9MF8iejh9okTT7yoQLqwrpezt8wLf81eWk3D3r4s4eDxtzFfMq5AQFin+bOrc1Tb2tfPyTiS5hlG/gM6WKYHSH5ICfDe0Q8CCYTrm0plkcTOlURKmPGW/XoVdTlpy0roK8OgfKXJbojMLugo1ZHHq6kPgGRX62G6VEeCEvJiB+ZcnjNyDZvC2ai+FcQ047t7lSyKYoHmuarN0yTb7UP8yA4ac9MjnJUN1i902OQXrspz1N0gzgy6Qy/kdKTshKAHFoI2t5zVBB4gLtKSQRr6hlsF8z8y97YDTyuYkXpPVdwag5ukehoqIqEp/M0cLk79VlehbBtoHQBLPvOXGbr5RKviICkzicIMAIKjaiThhQdgi/EDxvjXvEjZ+wATCdTmqrDYOsjpYPtVkE+ipze2VhzH6I2ND/yJXZs7RkXodBgT9TBuNfpgkBbHTOa16VATtruhia+q0n+5gzxS4VWcb/zWlGwQAm5BJrGcjv8ujche3CkN3afn/AIK39Kor1uhZjdu4cqfY2jsqPioZx6cPNaZBxcGh1JnAva9
 H9GEkILX
 oEDyho3ZVv21FCYjpD8G3svQwy0CpyTGiVmynuHLQ7qBfCZCJH5IufzgRrK4R5n7C37P+DY44zyAOGXm5lw755x9heTkQEer8KPWcbta2SN2UMMoGo8hoqREjNJ1V0HPycQKNsJY01KPKpr+5MrDuCqn0rDYM2mfjqJLk69tFHz59hL5n3zT3hdRN1hJk7FHwf49GmZ+anSH7lg42YZI7XDcOC8hZ3WR5sifcRzy8NQZRkp4Na9HFIRdNe6guC81GrqHrFNJ16076AFYnnkpUSUn87Dv2TlMue1gL3PtZ+16S8ZTlCMh1Bo54G/CwapDQqwGEH9ocoB+D3q2sQR1fseXwPmvsvWX59zJTgXoU6RJiDLZIaCMsTF5rNjCB1MoYYr4OWKUnQs0S8PbtcY+DMFb2BSc6u15cUce1mBS+W9CkaAAAxNEl/TDDzMQCPwOyg9NzATuHvMorNNLrp8V99Qf4lpS48+lGe+GEhL/4xq2+jN6yX3WMnKvHGh02yVbsDVhO6Es+TV5qJMHVwRvoSBWjit29owBM9BqpV+EN6e4cM2ceTvj1Cj04XN7fiOh9kNRF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


I wrote a thing, thought it might be of some interest.


mm.git review status for linus..mm-stable

Everything:

Total patches:       320
Reviews/patch:       1.40
Reviewed rate:       74%

Excluding DAMON:

Total patches:       259
Reviews/patch:       1.65
Reviewed rate:       84%

Excluding DAMON and zram:

Total patches:       245
Reviews/patch:       1.74
Reviewed rate:       88%



Unreviewed patches by author:


Andrew Morton <akpm@linux-foundation.org>
    "mm/vmscan.c:shrink_folio_list(): save a tabstop"

David Hildenbrand <david@kernel.org>
    "treewide: provide a generic clear_user_page() variant"
        Link: https://lkml.kernel.org/r/20260107072009.1615991-1-ankur.a.arora@oracle.com
        Link: https://lkml.kernel.org/r/20260107072009.1615991-2-ankur.a.arora@oracle.com
    "mm/balloon_compaction: improve comments for WARN_ON_ONCE(!b_dev_info)"
        Link: https://lkml.kernel.org/r/20260119230133.3551867-5-david@kernel.org

Dennis Zhou <dennis@kernel.org>
    "percpu: add double free check to pcpu_free_area()"
        Link: https://lkml.kernel.org/r/20260123205535.35267-1-dennis@kernel.org
        Link: https://lore.kernel.org/lkml/20260119074813.ecAFsGaT@linutronix.de/ [1]

Alexander Potapenko <glider@google.com>
    "mm: kmsan: add test_uninit_page"
        Link: https://lkml.kernel.org/r/20260113091151.4035013-2-glider@google.com

Kevin Brodsky <kevin.brodsky@arm.com>
    "selftests/mm: default KDIR to build directory"
        Link: https://lkml.kernel.org/r/20260122170224.4056513-1-kevin.brodsky@arm.com
        Link: https://lkml.kernel.org/r/20260122170224.4056513-2-kevin.brodsky@arm.com
    "selftests/mm: check that FORCE_READ() succeeded"
        Link: https://lkml.kernel.org/r/20260122170224.4056513-6-kevin.brodsky@arm.com

Klara Modin <klarasmodin@gmail.com>
    "arm: make initialization of zero page independent of the memory map"
        Link: https://lkml.kernel.org/r/20260111082105.290734-5-rppt@kernel.org

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    "mm/rmap: eliminate partial anon_vma tear-down in anon_vma_fork()"
        Link: https://lkml.kernel.org/r/9923da5f8b095dd1e8d677692dcaf95859de0ef5.1768746221.git.lorenzo.stoakes@oracle.com

Richard Chang <richardycc@google.com>
    "zram: introduce compressed data writeback"
        Link: https://lkml.kernel.org/r/20251201094754.4149975-1-senozhatsky@chromium.org
        Link: https://lkml.kernel.org/r/20251201094754.4149975-2-senozhatsky@chromium.org
    "zram: introduce writeback_compressed device attribute"
        Link: https://lkml.kernel.org/r/20251201094754.4149975-3-senozhatsky@chromium.org

Mike Rapoport (Microsoft) <rppt@kernel.org>
    "arm: introduce arch_zone_limits_init()"
        Link: https://lkml.kernel.org/r/20260111082105.290734-4-rppt@kernel.org
    "arm64: introduce arch_zone_limits_init()"
        Link: https://lkml.kernel.org/r/20260111082105.290734-6-rppt@kernel.org
    "hexagon: introduce arch_zone_limits_init()"
        Link: https://lkml.kernel.org/r/20260111082105.290734-8-rppt@kernel.org
    "loongarch: introduce arch_zone_limits_init()"
        Link: https://lkml.kernel.org/r/20260111082105.290734-9-rppt@kernel.org
    "m68k: introduce arch_zone_limits_init()"
        Link: https://lkml.kernel.org/r/20260111082105.290734-10-rppt@kernel.org
    "microblaze: introduce arch_zone_limits_init()"
        Link: https://lkml.kernel.org/r/20260111082105.290734-11-rppt@kernel.org
    "mips: introduce arch_zone_limits_init()"
        Link: https://lkml.kernel.org/r/20260111082105.290734-12-rppt@kernel.org
    "riscv: introduce arch_zone_limits_init()"
        Link: https://lkml.kernel.org/r/20260111082105.290734-17-rppt@kernel.org
    "s390: introduce arch_zone_limits_init()"
        Link: https://lkml.kernel.org/r/20260111082105.290734-18-rppt@kernel.org
    "sh: introduce arch_zone_limits_init()"
        Link: https://lkml.kernel.org/r/20260111082105.290734-19-rppt@kernel.org
    "um: introduce arch_zone_limits_init()"
        Link: https://lkml.kernel.org/r/20260111082105.290734-21-rppt@kernel.org
    "x86: introduce arch_zone_limits_init()"
        Link: https://lkml.kernel.org/r/20260111082105.290734-22-rppt@kernel.org
    "xtensa: introduce arch_zone_limits_init()"
        Link: https://lkml.kernel.org/r/20260111082105.290734-23-rppt@kernel.org
    "arch, mm: consolidate initialization of nodes, zones and memory map"
        Link: https://lkml.kernel.org/r/20260111082105.290734-24-rppt@kernel.org
    "arch, mm: consolidate initialization of SPARSE memory model"
        Link: https://lkml.kernel.org/r/20260111082105.290734-25-rppt@kernel.org
    "mips: drop paging_init()"
        Link: https://lkml.kernel.org/r/20260111082105.290734-26-rppt@kernel.org
    "x86: don't reserve hugetlb memory in setup_arch()"
        Link: https://lkml.kernel.org/r/20260111082105.290734-27-rppt@kernel.org
    "mm, arch: consolidate hugetlb CMA reservation"
        Link: https://lkml.kernel.org/r/20260111082105.290734-28-rppt@kernel.org

Sergey Senozhatsky <senozhatsky@chromium.org>
    "zram: document writeback_batch_size"
        Link: https://lkml.kernel.org/r/20251201094754.4149975-4-senozhatsky@chromium.org
    "zram: move bd_stat to writeback section"
        Link: https://lkml.kernel.org/r/20251201094754.4149975-5-senozhatsky@chromium.org
    "zram: rename zram_free_page()"
        Link: https://lkml.kernel.org/r/20251201094754.4149975-6-senozhatsky@chromium.org
    "zram: switch to guard() for init_lock"
        Link: https://lkml.kernel.org/r/20251201094754.4149975-7-senozhatsky@chromium.org
    "zram: consolidate device-attr declarations"
        Link: https://lkml.kernel.org/r/20251201094754.4149975-8-senozhatsky@chromium.org
    "zram: use u32 for entry ac_time tracking"
        Link: https://lkml.kernel.org/r/d7c0b48450c70eeb5fd8acd6ecd23593f30dbf1f.1765775954.git.senozhatsky@chromium.org
    "zram: rename internal slot API"
        Link: https://lkml.kernel.org/r/20260115031922.3813659-1-senozhatsky@chromium.org
        Link: https://lkml.kernel.org/r/775a0b1a0ace5caf1f05965d8bc637c1192820fa.1765775954.git.senozhatsky@chromium.org
    "zram: trivial fix of recompress_slot() coding styles"
        Link: https://lkml.kernel.org/r/ff3254847dbdc6fbd2e3fed53c572a261d60b7b6.1765775954.git.senozhatsky@chromium.org
    "zram: fixup read_block_state()"
        Link: https://lkml.kernel.org/r/20260115033031.3818977-1-senozhatsky@chromium.org
    "zram: drop pp_in_progress"
        Link: https://lkml.kernel.org/r/20251216071342.687993-1-senozhatsky@chromium.org

SeongJae Park <sj@kernel.org>
    "mm/damon/core: introduce nr_snapshots damos stat"
        Link: https://lkml.kernel.org/r/20260114152049.99727-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20251216080128.42991-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20251216080128.42991-2-sj@kernel.org
    "mm/damon/sysfs-schemes: introduce nr_snapshots damos stat file"
        Link: https://lkml.kernel.org/r/20251216080128.42991-3-sj@kernel.org
    "Docs/mm/damon/design: update for nr_snapshots damos stat"
        Link: https://lkml.kernel.org/r/20251216080128.42991-4-sj@kernel.org
    "Docs/admin-guide/mm/damon/usage: update for nr_snapshots damos stat"
        Link: https://lkml.kernel.org/r/20251216080128.42991-5-sj@kernel.org
    "Docs/ABI/damon: update for nr_snapshots damos stat"
        Link: https://lkml.kernel.org/r/20251216080128.42991-6-sj@kernel.org
    "mm/damon: update damos kerneldoc for stat field"
        Link: https://lkml.kernel.org/r/20251216080128.42991-7-sj@kernel.org
    "mm/damon/core: implement max_nr_snapshots"
        Link: https://lkml.kernel.org/r/20251216080128.42991-8-sj@kernel.org
    "mm/damon/sysfs-schemes: implement max_nr_snapshots file"
        Link: https://lkml.kernel.org/r/20251216080128.42991-9-sj@kernel.org
    "Docs/mm/damon/design: update for max_nr_snapshots"
        Link: https://lkml.kernel.org/r/20251216080128.42991-10-sj@kernel.org
    "Docs/admin-guide/mm/damon/usage: update for max_nr_snapshots"
        Link: https://lkml.kernel.org/r/20251216080128.42991-11-sj@kernel.org
    "Docs/ABI/damon: update for max_nr_snapshots"
        Link: https://lkml.kernel.org/r/20251216080128.42991-12-sj@kernel.org
    "mm/damon/core: introduce [in]active memory ratio damos quota goal metric"
        Link: https://lkml.kernel.org/r/20260113152717.70459-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20260113152717.70459-2-sj@kernel.org
    "mm/damon/paddr: activate DAMOS_LRU_PRIO targets instead of marking accessed"
        Link: https://lkml.kernel.org/r/20260113152717.70459-5-sj@kernel.org
    "mm/damon/lru_sort: consider age for quota prioritization"
        Link: https://lkml.kernel.org/r/20260113152717.70459-6-sj@kernel.org
    "mm/damon/lru_sort: support young page filters"
        Link: https://lkml.kernel.org/r/20260113152717.70459-7-sj@kernel.org
    "mm/damon/lru_sort: support active:inactive memory ratio based auto-tuning"
        Link: https://lkml.kernel.org/r/20260114055308.79884-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20260113152717.70459-9-sj@kernel.org
    "mm/damon/core: implement damon_kdamond_pid()"
        Link: https://lkml.kernel.org/r/20260115152047.68415-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20260115152047.68415-2-sj@kernel.org
    "mm/damon/sysfs: use damon_kdamond_pid()"
        Link: https://lkml.kernel.org/r/20260115152047.68415-3-sj@kernel.org
    "mm/damon/lru_sort: use damon_kdamond_pid()"
        Link: https://lkml.kernel.org/r/20260115152047.68415-4-sj@kernel.org
    "mm/damon/reclaim: use damon_kdamond_pid()"
        Link: https://lkml.kernel.org/r/20260115152047.68415-5-sj@kernel.org
    "mm/damon: hide kdamond and kdamond_lock of damon_ctx"
        Link: https://lkml.kernel.org/r/20260115152047.68415-6-sj@kernel.org
    "selftests/damon/sysfs_memcg_path_leak.sh: use kmemleak"
        Link: https://lkml.kernel.org/r/20260117020731.226785-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20260117020731.226785-2-sj@kernel.org
    "selftests/damon/wss_estimation: test for up to 160 MiB working set size"
        Link: https://lkml.kernel.org/r/20260117020731.226785-3-sj@kernel.org
    "selftests/damon/access_memory: add repeat mode"
        Link: https://lkml.kernel.org/r/20260117020731.226785-4-sj@kernel.org
    "selftests/damon/wss_estimation: ensure number of collected wss"
        Link: https://lkml.kernel.org/r/20260117020731.226785-5-sj@kernel.org
    "selftests/damon/wss_estimation: deduplicate failed samples output"
        Link: https://lkml.kernel.org/r/20260117020731.226785-6-sj@kernel.org
    "mm/damon: remove damon_operations->cleanup()"
        Link: https://lkml.kernel.org/r/20260117175256.82826-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20260117175256.82826-2-sj@kernel.org
    "mm/damon/core: cleanup targets and regions at once on kdamond termination"
        Link: https://lkml.kernel.org/r/20260117175256.82826-3-sj@kernel.org
    "mm/damon/core: cancel damos_walk() before damon_ctx->kdamond reset"
        Link: https://lkml.kernel.org/r/20260117175256.82826-4-sj@kernel.org
        Link: https://lore.kernel.org/20251230014532.47563-1-sj@kernel.org [1]
    "mm/damon/core: process damon_call_control requests on a local list"
        Link: https://lkml.kernel.org/r/20260117175256.82826-5-sj@kernel.org
    "mm/damon: document damon_call_control->dealloc_on_cancel repeat behavior"
        Link: https://lkml.kernel.org/r/20260117175256.82826-6-sj@kernel.org
    "mm/damon/core: rename damos_filter_out() to damos_core_filter_out()"
        Link: https://lkml.kernel.org/r/20260117175256.82826-7-sj@kernel.org
    "mm/damon: rename DAMON_MIN_REGION to DAMON_MIN_REGION_SZ"
        Link: https://lkml.kernel.org/r/20260117175256.82826-8-sj@kernel.org
    "mm/damon: rename min_sz_region of damon_ctx to min_region_sz"
        Link: https://lkml.kernel.org/r/20260117175256.82826-9-sj@kernel.org
    "Docs/mm/damon/index: simplify the intro"
        Link: https://lkml.kernel.org/r/20260118180305.70023-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20260118180305.70023-2-sj@kernel.org
    "Docs/mm/damon/design: link repology instead of Fedora package"
        Link: https://lkml.kernel.org/r/20260118180305.70023-3-sj@kernel.org
    "Docs/mm/damon/design: document DAMON sample modules"
        Link: https://lkml.kernel.org/r/20260118180305.70023-4-sj@kernel.org
    "Docs/mm/damon/design: add reference to DAMON_STAT usage"
        Link: https://lkml.kernel.org/r/20260118180305.70023-5-sj@kernel.org
    "Docs/admin-guide/mm/damon/usage: introduce DAMON modules at the beginning"
        Link: https://lkml.kernel.org/r/20260118180305.70023-6-sj@kernel.org
    "Docs/admin-guide/mm/damon/usage: update stats update process for refresh_ms"
        Link: https://lkml.kernel.org/r/20260118180305.70023-7-sj@kernel.org
    "Docs/mm/damon/maintainer-profile: fix wrong MAITNAINERS section name"
        Link: https://lkml.kernel.org/r/20260118180305.70023-8-sj@kernel.org
    "Docs/mm/damon/maintainer-profile: remove damon-tests/perf suggestion"
        Link: https://lkml.kernel.org/r/20260118180305.70023-9-sj@kernel.org

Kefeng Wang <wangkefeng.wang@huawei.com>
    "mm: hugetlb: optimize replace_free_hugepage_folios()"
        Link: https://lkml.kernel.org/r/20260114135512.2159799-1-wangkefeng.wang@huawei.com
        Link: https://lkml.kernel.org/r/20260112150954.1802953-4-wangkefeng.wang@huawei.com

Yosry Ahmed <yosry.ahmed@linux.dev>
    "zsmalloc: simplify read begin/end logic"
        Link: https://lkml.kernel.org/r/20260107052145.3586917-2-senozhatsky@chromium.org



