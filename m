Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4569AC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 04:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A9696B007B; Wed, 12 Aug 2026 00:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05ACD6B0092; Wed, 12 Aug 2026 00:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB25A6B0093; Wed, 12 Aug 2026 00:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C46A96B007B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 00:04:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57FDBA1AB5
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:04:24 +0000 (UTC)
X-FDA: 85091275248.19.FBFB55F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6DDF2180003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:04:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EDp9Hek4;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786507462;
	b=E3QfIjKtMLJcecvPslF4nCx8PQhe0FVPFD9m2SsQ/woV7IdxKU7RyGLeXViwa7sNQZFJPI
	TNCEtXDE3oMge7ff0ZGXHRLMtomuhfNEjY7nk1JNN6bBtQdZk/VPa1GgfSBXDa8LBRuQ8k
	N7g59Rn99KHUOq9AxOsvxFOG+odlnbQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EDp9Hek4;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786507462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FiLLmlbsLzuaMtcwBwMDwfL5w+GqVLTduA8mEqjoFy0=;
	b=y6W6CtvX1mxstTpkfL8APqipca4wqpz1sXi49nMWvQrsBD52ktJBeYGnG4/yZiNnWcn8nY
	RahqEmFfg/OvIPZ6meUjJshnvzVkZg40RWqLg5Z5cS0gQfN0t1mVcbMph+9mV6Jd99z6j0
	dwl6wADd33FkWnFABAKJ0M0qC3VZ73E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC503600AE;
	Wed, 12 Aug 2026 04:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BEF1F000E9;
	Wed, 12 Aug 2026 04:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786507461;
	bh=FiLLmlbsLzuaMtcwBwMDwfL5w+GqVLTduA8mEqjoFy0=;
	h=Date:From:To:Subject:In-Reply-To:References;
	b=EDp9Hek4af1hq1hEFwWlGF1kFT9CweEpNRXaghvS0UdHFeKVykTx39N2i2gthoNat
	 8/d1L33hWn1VYNeFlXdBu0J3dTPeP85xFiB0QVEKpsv5cTuaYAPFvmEXhF3oGQpmz/
	 He3wZ9UXNwSvJ/ylu3jpz8ICZg0B8tnMJU2akpFQ=
Date: Tue, 11 Aug 2026 21:04:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Subject: Re: mm.git review status at 7.2-rc7
Message-Id: <20260811210420.097a994cdb9a011f654227de@linux-foundation.org>
In-Reply-To: <20260811205836.59301ca91b65781c6292a439@linux-foundation.org>
References: <20260811205836.59301ca91b65781c6292a439@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6DDF2180003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: phnochrrjq5wdafn3fx4u8x59z3wuapd
X-HE-Tag: 1786507462-97657
X-HE-Meta: U2FsdGVkX18WxXprodaUh9RDtCgqBb4/O3QKPQMNalNbGS9jDhK/gdjf7SJIH/m+qE9PliEVjr0CrafRD+HIbpA9ZOpg4e3U99p2f0pf0/lNHrYgjacv/0v+AiNBQ3lfviihG9p9r/P2T7rKyDN90v3xSQG6YkMDX/YoHLMgey2/zYg5nv8tR3cmbyf/tVREVlB1W7mrY7N3ypy/4pKO+7KcUP70aHLoFDT6MLk92cJexqKUe/69H0W++9PUNV9C9P8dpZBMf0QIZoiEqZ3Dyp26LJ8f3ilypSQro6QH+QefSOXdsaQfhB5Z8p1uVqvszcnJzUXFMugOx5fJ6kho2F8kWuMRdEVXOncM3+ReGO0pE7C3zpNozsmWh8vOPFjQXGKjVuGMxdQLHlcE6ztCpqzTF0T2iSKHD5vTS/oYNIcSoeeoskdVCs2bB87p5KlmoNjAq9lLz9UPTXNqm6Hpe5CPu5YtdKlJygceBkm/hwq44j4OCiXeXaO2YE9xwnGgdCbcI9cd7ioZ/5Ez8TQS48yPZDY/h30+q6cHoA+KDEmtkmm2ofPYkH/qg6Zxr1Vi9oa8kFP5TUzpmv98K9xgTl7GbAPaWMq+CHxHndHNB9MNtv/HP+WbJxLeraOw2rjEeLyR9+7qnzHiefUwWVwXd9faU7q6iad19O70zWGAl4MAOOFQyWf2WykJNe+ydO9p0AhA1pHeozT0T//ZL/MtCI+NoBsOwGrzTbM+3tL4IipAg4/ufoYKP0n1GKp58qBmsfdap/gaIKdTgl1/oA8t6VnUVqWKOnFRQRNd6Ot8eKIDqITO/OWdIZ4aWi8YBAHVHMw1VMPcTVGZmALy6e0z/+VdbpP/zNTX9jSH6kEqAl9uEZzi64nanqk7x4hTkOU/HuYncyt89dT6eNHtdRQRYOWj4uG6e5FFUVCUbrUB7sM+Q7EGu3NbPyWi4NK8zO4ug8zMb20YrMTN/8LWCh+
 n63Gbfxn
 dY6OFtu093BfKDW78WDr8D3LfKwqg2qWlBAIavhVkUt8uRsk8uEU7k6thOVcMcvUj1OBOFgxChDNmzdme1k6htjQcapgfwY8jtkDNZphT6H+zAiraURKUjjDXU1G9kLraCH2xRkYOxP8k2LSzb0aS4KIe9HijFllan5gKKRd0W6wNkh5BMNPEeDKvF+CYX/SDMaLEbabpFaKsQnV9D4FULOEUzx/90lNbCiRI9Jrl+zTVIkw8OXSSehXO0m+jkWiE/BsTWNyyRNwXf4/eNgsOtJvpVAtpuwlOYxeeGEdFoRTBTJ1n382Jr9/mvzGDonTun991Q69WXzi+TxU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 20:58:36 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> For the second week's batch we have 114 patches that look in decent
> shape and another 63 which are not looking so good.  I'll continue to
> chase these over the next couple of weeks.

These are the remaining problem patches, along with the cryptic links
and comments which explain the various potential issues:

As always, append a quilt filename to
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/
to get at the actual patch and its Link:




#selftests-mm-fix-soft-dirty-kselftest-supported-check.patch: https://lore.kernel.org/db04536b-a98f-4025-a095-9ca49de10e12@kernel.org
selftests-mm-fix-soft-dirty-kselftest-supported-check.patch
#
#mm-kmemleak-confirm-suspected-leaks-with-a-second-scan.patch: Catalin acks?
mm-kmemleak-confirm-suspected-leaks-with-a-second-scan.patch
mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch
#
mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan.patch
documentation-kmemleak-document-the-conditional-min_unref_scans-default.patch
selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments.patch
#
#
#
#maple_tree-add-rcu-locking-check-when-lockdep-is-enabled.patch+N: https://lore.kernel.org/6yf7k4fmg4tkbmli6t4qzrk2eiyuuynoc2oimbgaebught2yh5@dspb7xile3kj
maple_tree-add-rcu-locking-check-when-lockdep-is-enabled.patch
locking-lockdep-add-sequence-counter-to-held_lock.patch
maple_tree-add-write-lock-checking-with-lockdep-sequence-numbers.patch
maple_tree-stop-flooding-logs-when-debug_locks-is-set-to-zero-fix.patch
maple_tree-documentation-fix.patch
maple_tree-drop-dead-code-from-mas_extend_spanning_null.patch
maple_tree-drop-maple_alloc_slots.patch
maple_tree-clarify-comments-on-mas_nomem.patch
maple_tree-use-prefetched-value-in-mas_wr_store_type.patch
maple_tree-optimise-mas_wr_node_store-when-not-in-rcu-mode.patch
maple_tree-micro-optimisation-of-mas_wr_store_type.patch
maple_tree-add-bulk-parent-set-helper.patch
maple_tree-catch-race-in-mas_alloc_cyclic.patch
maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch
maple_tree-warn_on_once-when-allocations-fail.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch
#
#
#
#
#riscv-mm-fix-concurrency-in-mark_new_valid_map.patch+1: Paul? TBU (Aug) https://lore.kernel.org/41c1a3ed-0afd-4bf9-9749-2031bff00fda@iscas.ac.cn
riscv-mm-fix-concurrency-in-mark_new_valid_map.patch
riscv-mm-exclude-invalid-thp-pmds-from-page-table-check.patch
#
#mm-khugepaged-refactor-per-scan-state-clearing-into-collapse_control_init_scan.patch: await David review
mm-khugepaged-refactor-per-scan-state-clearing-into-collapse_control_init_scan.patch
mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper.patch
mm-khugepaged-introduce-a-count_collapse_event-helper.patch
mm-khugepaged-fix-outdated-comments.patch
mm-khugepaged-refactor-the-pte-state-checks-into-a-helper.patch
mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch
mm-documentation-clarify-where-the-mthp-stats-live.patch
#
#sh-remove-config_numa-and-realted-configuration-options.patch+N: sh review?
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch
#
mm-cma-remove-stray-newline-from-auto-generated-cma-area-name.patch
#
kasan-fix-cache-shrink-race-with-cpu-hotplug.patch
#
mm-gup_test-keep-longterm-pin-state-per-file.patch
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# mmend
#
#ENDBRANCH mm-unstable
#
#BRANCH mm-new
#
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch
#
zram-fix-slot-lock-bit-position-on-big-endian-64-bit.patch
#
mm-page-writeback-document-folio_mark_dirty-locking-more-explicitly.patch
#
zsmalloc-account-for-handle-size-in-class-lookup.patch
#
#selftests-proc-make-proc-maps-race-work-with-read_implies_exec.patch: Suren?
selftests-proc-make-proc-maps-race-work-with-read_implies_exec.patch
#
#
mm-swap-revert-to-single-folio-writes-for-synchronous-swap-devices.patch
mm-swap-add-a-new-swap_opsh-header-to-allow-for-pluggable-swap-ops.patch
mm-swap-move-swap_ops-into-file-systems-for-file-system-based-swap.patch
#
#lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch: acks?
lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch
#
kasan-fix-quarantine_size-accounting-during-cache-removal.patch
#
selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable.patch
selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch
#


