Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0717660A383B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RcXBe0Ce
Received: by kanga.kvack.org (Postfix)
	id 2AF996B05CA; Mon, 16 Nov 2026 06:05:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267676B05CC; Mon, 16 Nov 2026 06:05:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFD0B6B05CD; Mon, 16 Nov 2026 06:05:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B07D6B05CA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:05:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38794A08C8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:05:09 +0000 (UTC)
X-FDA: 85440700338.06.48D66A0
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 68C5A1C0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:05:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RcXBe0Ce;
	spf=pass (imf18.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zS2lDzeHA/1L2L3MmL+yEtxhF4ntSvUOnFxLZtQr65E=;
	b=nXIpxZGzh/mTpRGCXmkgm+UouWOZK/jr2OtzAFwfjjA6b9UeKvp6xmf66XOkiB5yijKXEO
	FDvTptD0bgCwwbHkuvwtCKjxJawTeYmlPC6nvACcEvELA3rx+CTzqOC6MGkkgN2DS3xisA
	+Rz4+eZtPPI5t4aUwPmEnIvX6OogHmo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827107;
	b=IqBSutFTWUeE4JlxGnC5ASuqnb+XZDV9kYAt33LSW+tokv5J6c2iyxX02b11Pvk845WhZU
	camt/r3Yrsz4LlSRiaaGSFcQRcXAEgmZgq3d/wN2w5vjBwifYCy89knENA/8YGNq0DuZ39
	I7frbB1xE5RTh55n4UMO6wFJ8ID6/Kg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RcXBe0Ce;
	spf=pass (imf18.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-14394530ec6so3922402c88.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827106; x=1795431906; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zS2lDzeHA/1L2L3MmL+yEtxhF4ntSvUOnFxLZtQr65E=;
        b=RcXBe0CeF+QRKBAFruLlOj/sxbmDstwZX/M4r2iT+XTquXU7dr0Renp+sAAdFJHmOt
         +QbA2JEYwaAZTx3Fcd8RYMrQgFzgb0bD57gGfepOYLDB3JmUkfi4UAUGerdykza/mLbu
         jCg8LsMGzqzXKyxQUXQaEx9rORV+p1xrYDGUV1mpKFdN/yUQ0JkUjHZCgmSZapRBxqNZ
         hE8pMjPyZy73HVi0x3G3aBxicJkpJcSdfKCIhpL6XOtgOPtFxMZMS4Z8CxUU8B1uec7i
         XnWxLUE1AQuVuMQ106MhyVTVGottswUcPiKH8emYIPtXOXP4Jh7Tmsqp3vvn7PNWdLsH
         XVYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827106; x=1795431906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zS2lDzeHA/1L2L3MmL+yEtxhF4ntSvUOnFxLZtQr65E=;
        b=1dJ2DQF7ZFJICtx7yKSYv/mi5ZZWWBucq9LXJowwUi+wSi5b4WdD2nDFVH1F6V7cRh
         AtR3CBIFomOyh6V2kulBQ2/ovPV2+SlSQSpjjPZzoCMDMpeCQOqATeMCehXgmBvGVM3U
         Ez4gdD8ZLFKFe7f7kMVODujUzXh9UpK2RnLDi7mzC/kDTMXYq/Ru6rghK9MqtnwO3hPK
         gwxmqkUcF4G50MMTdRn44mvosmvyQTItbIlw5+VSYTebO03cP+HI61tiNYZYjOkdZrvG
         Hrc7i8TGGgaMVoN5UTCia/G/xY67JMBzcISvJYupdblNpCHGBbT3gP3M5yjgMc6HYwBo
         n8zw==
X-Gm-Message-State: APuU4Z+498ex8d/C/OjKZ5x67bnaKwGEJNPRnQFo5np0z5FBX/QGZdHt
	MvDt0DddwGdDHXSw8aPtEDnXfnqJYcBivvmSkhQUDCQZLAcgBGbrZtFr26OuiXDoJyHnU7Hy
X-Gm-Gg: AYBFou26LL3Bd8EL+UigA1OM/frUrebl2IM7DWwiB4JrSHpon3JPxtw+aHGufLSzJ+i
	6ElOfyp0AGqPC25HKC6bpOpVfMT3FOpSgk4ARbpbD8WbP4u9aCDVeYykZtOg34k+k1DKb5ajevh
	pCLeEhppWr+IZlVrTu3QntZ2/MMrMoqp2KFssiLq1eil5m26yiO/JlPj8Rjl2ssLb/ZiJF8litk
	aP3TAZuJXOAMn6QWlrwo/xX8+frRRQeAJRL1mpNxUonb+HlLPE5AGfzqOBj1BKYV6YDjUrukgxq
	mpJiW9NzWyeqGYK7sCkebF62XS4ihDpVGkxGWYvxQyprXeAK/ezl4QaJmbPi2v22VKvd1ZYG53i
	U9xsgbtf/xA2c7Rvs0S8mI8yg6MUZQd/V1nNv+akSsbLlcp1l9gTOZTXNgVdVBvau3vRO2fWk4C
	KC+A3UJd5ydAf4VxVgXoUNBT5+ZNffAL69mDYyAPVCyjNHUyh3wBZM6vpKInuf23cjIuPhoYmzE
	opH8hWip28EM/Z0jFcWF2hfwEHnoVcEgZXFK2FIO4k51lHYKkWV09NtBfTs9YHipLPlZo2H385O
	hnAgV+im1oRd2Bxnsi3BJO2rIHQ4ho1BGRPJUeK4NLbu3ec=
X-Received: by 2002:a05:7022:170f:b0:166:f097:6f12 with SMTP id a92af1059eb24-1b5030e76a5mr10196048c88.15.1794827105267;
        Mon, 16 Nov 2026 03:05:05 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:05:04 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 16/16] mm: memcomp: add the admin guide
Date: Mon, 16 Nov 2026 19:01:22 +0800
Message-ID: <20261116110122.309748-17-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
References: <20261116110122.309748-1-nakixii@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6ixf6udu1obz587fbihs5opanuyc4ogy
X-Rspamd-Queue-Id: 68C5A1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794827107-984567
X-HE-Meta: U2FsdGVkX1+i3kJeEhIdlm+Mz+n1hN2HgR+P3PC9qCtGaHQs50q2B7P6hzrNQ2kAtX7zQq+Ru18RxGrxdT6JNAuPTh/xz3iB8eCSDmrp2jl4iiVLLD/7uovG1DHXlk10CHsZ9HsGfCPsCj87ZNDTte2wq6vBKPyPphRylMapYXSFLuvJqMe+4arD5iD6q42AKdVfUP6OQJhHm9D38LJzqnkS9ToS3csC/stwL/MUv4Z1RFX+89/1JUSI/4x9G6+WjR20ey64GtLAw9P4W+rQzvPw7VZyXEsCqdparjBrvqRXC7gAFCB0XZwIOc9B+mT+V/5oF3UpaocIYsTqyYEOsfL8n4vxvkJXBdCoWVsduIZogitzB5UqX7S352YmXBaiauxdxR390G16QSy5hWoYVEkJFY8NOjOseTdaAcuT2wvMZy5IsOlkO6mjNanJiiUW6MhWTd8b0Rdcdv6QYCxSjZZR/tsUNwICNxg5TuQOr2Bfhx8CxCsp849prnqZHlGc19aUPgGW5IAFgszADzM22E3zv44TW9Lz1vTnEA4IQuBNnyN188bbIutKHGbwDP+tDGFQ0Uv0dsp2E25DLKYdiZ0c3NKft4+Jzzb+N0qTlwZTTIauS46SC4esKiGjyJHIYW1K0+KB7+iuaUl5lgLPncO5OVAS/B9PfmaP8O28COPSnFo0alr3ODe6aVRkkOPLIb3eJvHX3t5QSm6q1+UVlo09FcndmpkIt2FKFWJCmh2QkalP16GgAk7Hr7mhJm+aAvzgLszUY5oY2yz8Mg5y/fKEMn8gs0tF+ljTwwIVphNt70znHARB4pRg2xC9FWWKDQVp2WFHuxKlI7H3PvQCXckC5UNb9FyDVz7LsX27WV8qRA2m9XJIjjVGgsRHrgY43Z5k7OcYc2ZWVYT4xsChJ4CEJ6uNk2yDpTmvTz4vI17JUwuujjkbqILMGgC8WoTpd7VnI/bNwVOHtTPKF03
 I9xDqzNf
 5Pr39wk41HHOZA/bwjuhJpqQHryuTw560oAuPXUaUcURPpvbPL5gIb5S2TVw5KdfdH3uvF3SX8PJR9OyO7Xk6bFp9UzenotmQaG8vS6zfb29byWVLsm8E7FFvL7K8wCxQ7m3M2os3W3+Y84+Igs7iaymOoiDVZiaCcLv4s85E1RGiCY+3OEGKe2pNKcK6LxtGoKozNZvS49MzlOIlSjwJb3inK62/fHkFe/xAyMXFFW+dJ6sk9IzVrh8sy7X2r4uBwgT6YGgndcU2b2wsoVjqBv6Wea9R3RHKnvDRUxq6O4Zeokay1MvnRL1Hg1Ey2v+seE5vw0lRhQzScvfo5e71W/Gds9vHJhVQ5sJ+l1DVPVohj7vccUDAveHdUXiwWUx1C2Sm0skEPe5Rd23Ccpq59E7B+51GM1F0peP+21QxynG8CBDgGahCJhP/4E//Lh2OUYziOPFn0jJNoyCe2kMa2JIojNl8/RR6U/U1xyadPh6S+DqJwl9PfMFEva59BBVBHECM5bggmD86C/r6Vr6SfXib9pg9TiTXG2+Fhn3WQiAA9eg2lHbXqDV0w8/LS554bevai+M8Ra1zeeGbhBCjP7VWvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The memcomp backend has boot-time policy, compressor selection and
observable statistics that need an operational description separate from
the internal ownership design.

Explain the experimental configuration and default-off policy, including
built-in compressor requirements and the memcomp.compressor= override.
Describe initialization and compressor availability without implying a
runtime enable or disable interface.

Document stat and compressor under the established memcomp sysfs
directory, with optional diagnostic fields gated by MEMCOMP_DEBUG_STATS.
Describe writeback policy, accounting limits and supported operation.
Add the sysfs ABI descriptions and link the guide from the memory-
management index.

Keep implementation, documentation and selftest maintenance coverage
aligned with the series. State operational restrictions and untested
areas explicitly rather than promising behavior beyond the supported
configuration or available validation.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 .../ABI/testing/sysfs-kernel-mm-memcomp       | 363 ++++++++++++++++++
 Documentation/admin-guide/mm/index.rst        |   1 +
 Documentation/admin-guide/mm/memcomp.rst      | 149 +++++++
 MAINTAINERS                                   |   2 +
 4 files changed, 515 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-mm-memcomp
 create mode 100644 Documentation/admin-guide/mm/memcomp.rst

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-memcomp b/Documentation/ABI/testing/sysfs-kernel-mm-memcomp
new file mode 100644
index 0000000000000000000000000000000000000000..0d68defd8d1a2b09f700d12827dad12743d94d6d
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-memcomp
@@ -0,0 +1,363 @@
+What:		/sys/kernel/mm/memcomp/stat
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Read-only memcomp capacity counters.  The three decimal
+		fields are logical stored bytes, compressed payload bytes, and
+		zsmalloc pool bytes, in that order.  A pending logical page is
+		still resident and must not be treated as committed capacity.
+
+		Slotless zero tokens contribute one base page per logical owner.
+		Anonymous PTEs and shmem page-cache shadows have independent
+		ownership counts. Fork adds a zero PTE owner; fault, zap and
+		MADV_FREE remove it. Moving a zero PTE does not change the count.
+		A present shmem mapping adds no owner beyond its cache shadow.
+		Positive slots retain the per-slot counting convention, so fork
+		can increase the logical zero capacity without allocating any
+		entry metadata. Counter fields remain observational snapshots.
+
+What:		/sys/kernel/mm/memcomp/compressor
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Read-only name of the compression algorithm selected at boot.
+		While memcomp is still waiting for a compressor that has
+		not registered yet, this is the name it waits for; it changes
+		to "zstd" if memcomp falls back to that.
+
+What:		/sys/kernel/mm/memcomp/events
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Present only when CONFIG_MEMCOMP_DEBUG_STATS=y.
+
+		Read-only text with one key, one space, a decimal value and a
+		newline per line. Reading does not reset statistics. Values are
+		collected independently, so a read is not a coherent snapshot
+		against concurrent work.
+
+		The ``folio_owner_pages``, ``samefill_pages``, ``raw_pages`` and
+		``shmem_pages`` fields are current entry-state gauges. They count
+		entries with a retained folio owner, same-filled payloads, page-sized
+		raw payloads and shmem ownership, respectively. Owner detachment
+		and payload replacement update the corresponding gauge;
+		entry removal subtracts its remaining state before payload release.
+		These are sums of signed per-CPU values, not an object index or a
+		transactional snapshot. Cross-CPU reads may race concurrent updates;
+		negative aggregate samples are clamped to zero. Compare quiescent
+		samples when checking balanced ownership.
+
+		Event counters accumulate; they are not instantaneous state. The
+		other current gauges are: ``enabled``, ``comp_ctx_count``,
+		``comp_ctx_reserved``, ``comp_ctx_borrow_limit``, ``comp_ctx_free``,
+		``comp_ctx_waiters``, ``comp_ctx_borrowed_active``, ``pending_pages``,
+		``swapped_entries`` and ``zs_huge_class_size``. ``enabled`` is 1
+		when memcomp is enabled and 0 otherwise. ``zs_huge_class_size`` is
+		the request boundary, in bytes, below which zsmalloc can share
+		backing pages; zero means memcomp is not enabled or no allocator
+		pool is initialized.
+
+		``comp_ctx_borrowed_peak`` is the largest recorded count of
+		simultaneously borrowed compression contexts, not current
+		occupancy. ``comp_ctx_count`` and ``comp_ctx_reserved`` report
+		the initialized compression-context pool sizes.
+
+		``swapped_read_io`` counts successful read/decode calls for
+		swap-backed pages, including calls satisfied from swapcache; it is
+		not a physical I/O count or proof of a later PTE mapping. ``swapped_read_error`` counts read-page or decode
+		failures. ``swapoff_entries`` counts entries successfully converted
+		back to RAM backing. ``swapoff_read_io`` counts successful read-page
+		operations in that conversion path. These four fields are
+		accumulated events, not current gauges.
+
+		Compression staging and reservation rollback/split diagnostics are
+		reported by ``execution_events``, not by this file.
+
+What:		/sys/kernel/mm/memcomp/placement_events
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Present only when CONFIG_MEMCOMP_DEBUG_STATS=y.
+
+		Read-only text with one key, one space, a decimal value and a
+		newline per line. Reading does not reset statistics. Values are
+		collected separately and do not form a coherent whole-file snapshot.
+
+		Accumulated routing-attempt counts: ``compress`` counts attempts to
+		route anonymous or shmem folios to memcomp; ``normal_swap_fallback``
+		counts fallback attempts to ordinary swap after a memcomp attempt.
+		These are routing events, not successful stores, reclaimed pages or
+		byte counts. An event can concern a multi-page folio; retries can
+		cause further events.
+
+What:		/sys/kernel/mm/memcomp/packed_swap_events
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Present only when CONFIG_MEMCOMP_DEBUG_STATS=y.
+
+		Read-only text with one key, one space, a decimal value and a
+		newline per line. Reading does not reset statistics. Values are
+		collected separately and do not form a coherent whole-file snapshot.
+
+		Compressed-pool writeback diagnostics. The following fields are
+		current gauges:
+
+		* ``writeback_pool_pages``: allocator backing footprint in base
+		  pages.
+		* ``writeback_pressure_scopes``: active reclaim writeback scopes,
+		  summed across memory nodes, including overlapping scopes.
+		* ``writeback_gate_open``: last evaluated writeback-gate state, 0
+		  for closed or 1 for open.
+
+		The remaining fields are accumulated counts:
+
+		* ``writeback_pressure_events``: node scope transitions from no
+		  active scope to an active scope.
+		* ``writeback_pressure_scans``: eligible pressure-driven writeback
+		  scan invocations.
+		* ``writeback_compression_throttled``: budget-grant episodes with
+		  effective compression feedback; this is not a count of compressor
+		  calls delayed. Feedback is effective after sufficient logical
+		  stored-byte growth when backing-byte growth is at most half that
+		  growth.
+		* ``writeback_limited_batches``: scanned batches which exhaust their
+		  node's writeback budget.
+		* ``writeback_budget_granted``: sum of payload-entry allowances
+		  granted, not bytes or completed writes.
+		* ``writeback_payloads``: payload entries successfully converted
+		  from in-pool storage to swap-backed storage.
+		* ``writeback_zs_reclaimed``: sum of observed decreases in
+		  allocator backing base pages during pressure scans, including
+		  compaction. It is not a logical-page count or exclusive
+		  attribution against concurrent pool changes.
+		* ``writeback_zs_no_progress``: pressure scans which converted
+		  payloads but observed no decrease in backing pages after
+		  compaction.
+		* ``writeback_decompress_error``: failures to decompress a payload
+		  when preparing an unpacked swap page.
+		* ``writeback_write_error``: submitted swap-page slots observed
+		  dirty after waiting for writeback, indicating write failure. This
+		  counts slots, not the payload entries within them.
+		* ``writeback_gate_opens``: recorded transitions from a closed gate
+		  to an open gate.
+		* ``writeback_packed_slots``: packed backing-page slots submitted
+		  for writeback, not successfully completed I/O.
+		* ``writeback_packed_payloads``: payload entries successfully
+		  converted to packed swap storage. Multiple payloads can share a
+		  slot.
+		* ``writeback_defrag_moved``: packed swap payload entries
+		  successfully moved back into the compressed pool by
+		  defragmentation.
+
+		Submission, conversion and page-footprint statistics have different
+		units and accounting points; they must not be equated.
+
+What:		/sys/kernel/mm/memcomp/admission_events
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Present only when CONFIG_MEMCOMP_DEBUG_STATS=y.
+
+		Read-only text with one key, one space, a decimal value and a
+		newline per line. Reading does not reset statistics. Values are
+		collected separately and do not form a coherent whole-file snapshot.
+
+		Accumulated direct-reclaim admission diagnostics:
+
+		``reclaim_ctx_early_reject`` counts direct-reclaim context prechecks
+		which rejected an attempt; ``reclaim_ctx_early_reject_pages`` sums
+		the associated base pages. This is a precheck result, not proof of
+		an eventual failed store.
+
+What:		/sys/kernel/mm/memcomp/context_events
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Present only when CONFIG_MEMCOMP_DEBUG_STATS=y.
+
+		Read-only text with one key, one space, a decimal value and a
+		newline per line. Reading does not reset statistics. Values are
+		collected separately and do not form a coherent whole-file snapshot.
+
+		Compression-context timing diagnostics. ``sample_interval`` is the
+		lease sampling period, currently 256 successful reclaim-context
+		acquisitions per context and reclaim source, with staggered initial
+		phases. Sampled values are raw measurements, not extrapolated totals
+		for all work.
+
+		``wait_events`` counts entries into the context wait path, including
+		retries, independently of lease sampling. ``wait_ns`` is accumulated
+		elapsed wait-path time in nanoseconds and ``wait_max_ns`` is its
+		largest recorded individual duration; a wait-path entry need not
+		actually sleep.
+
+		The prefixes ``direct`` and ``bg`` select direct reclaim and all
+		non-direct reclaim sources. Each prefix has the following suffixes,
+		joined with an underscore:
+
+		* ``samples`` counts accounted sampled leases; ``pages`` sums their
+		  associated base pages, not pages successfully reclaimed.
+		* ``store_samples`` counts sampled leases that reached a store
+		  attempt; ``store_success`` counts successful store outcomes among
+		  them.
+		* ``lease_ns`` is accumulated context-holding time; ``lease_max_ns``
+		  is its recorded maximum per sampled lease. A lease ends when the
+		  context is released or its output is transferred to a staging
+		  buffer; later store work may continue after it.
+		* ``pre_store_ns`` is accumulated time from lease acquisition to the
+		  beginning of a store; ``pre_store_max_ns`` is its recorded
+		  maximum. A lease that never starts a store contributes its full
+		  lease duration here.
+		* ``compress_ns`` is accumulated elapsed compression time;
+		  ``compress_max_ns`` is the maximum accumulated compression
+		  duration for one sampled lease.
+		* ``compress_cpu_ns`` is accumulated task CPU time spent in measured
+		  compression; ``compress_call_cpu_max_ns`` is the largest recorded
+		  CPU duration of a timed compression operation.
+		* ``compress_store_success_ns`` and
+		  ``compress_store_success_cpu_ns`` are elapsed and CPU
+		  compression-time totals for sampled leases whose store succeeded.
+		  ``compress_store_fail_ns`` and ``compress_store_fail_cpu_ns`` are
+		  the corresponding totals for leases without a successful store,
+		  including leases that never started one.
+		* ``zs_ns`` is accumulated measured allocator/payload-placement
+		  time; ``zs_max_ns`` is its maximum per sampled lease.
+		* ``store_other_ns`` is accumulated store elapsed time after
+		  subtracting measured compression and allocator time, floored at
+		  zero; ``store_other_max_ns`` is its maximum per sampled lease.
+
+		Each prefix additionally has ``compress_<outcome>_calls``,
+		``compress_<outcome>_ns`` and ``compress_<outcome>_cpu_ns`` for
+		``compressible``, ``raw_huge``, ``raw_ge_page`` and ``error``
+		outcomes. These count timed compression operations and accumulate
+		their elapsed and task CPU nanoseconds. The outcomes mean a result
+		below both storage boundaries, a result reaching the allocator
+		huge-class boundary but below input size, a result at least input
+		size, and a compression-result error. They are distinct from the
+		later store-success classification.
+
+		All durations are nanoseconds. Counts and duration totals
+		accumulate; maxima are recorded high-water durations, not gauges.
+		Lease and store phases must not be assumed to be a disjoint
+		decomposition of end-to-end request latency.
+
+What:		/sys/kernel/mm/memcomp/context_sources
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Present only when CONFIG_MEMCOMP_DEBUG_STATS=y.
+
+		Read-only text with one key, one space, a decimal value and a
+		newline per line. Reading does not reset statistics. Values are
+		collected separately and do not form a coherent whole-file snapshot.
+
+		Source-attributed context timing. ``sample_interval`` reports the
+		lease sampling period, currently 256 successful reclaim-context
+		acquisitions per context and source, with staggered initial phases.
+		Lease measurements are sampled, not extrapolated; wait-path
+		measurements are not lease-sampled.
+
+		Prefixes are ``direct`` for direct reclaim and ``kswapd`` for the
+		regular reclaim daemon. For each prefix, suffixes are joined with
+		an underscore:
+
+		* ``samples`` and ``pages`` count sampled leases and their
+		  associated base pages, not successful reclaim.
+		* ``store_samples`` and ``store_success`` count sampled store
+		  attempts and successful store outcomes.
+		* ``wait_events`` counts context wait-path entries, including
+		  retries; ``wait_ns`` sums their elapsed nanoseconds;
+		  ``wait_max_ns`` is the largest individual duration. A wait-path
+		  entry need not sleep.
+		* ``lease_ns``, ``pre_store_ns``, ``compress_ns``, ``zs_ns`` and
+		  ``store_other_ns`` are accumulated elapsed nanoseconds; each has a
+		  corresponding ``*_max_ns`` field for its recorded per-lease
+		  maximum.
+		* ``compress_cpu_ns`` is accumulated compression task CPU time;
+		  ``compress_call_cpu_max_ns`` is the maximum CPU duration of a
+		  timed compression operation.
+
+		Lease, pre-store, compression, allocator and residual store phases
+		have the same meanings as in
+		/sys/kernel/mm/memcomp/context_events. A context lease can end
+		before staged store work completes, and a lease without a store
+		contributes its full duration to pre-store time. Counts and times
+		accumulate; maxima are historical measurements, not current
+		occupancy. A read is not a consistent snapshot across source groups.
+
+What:		/sys/kernel/mm/memcomp/execution_events
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Present only when CONFIG_MEMCOMP_DEBUG_STATS=y.
+
+		Read-only text with one key, one space, a decimal value and a
+		newline per line. Reading does not reset statistics. Values are
+		collected separately and do not form a coherent whole-file snapshot.
+
+		Compression execution budget, staging-buffer and reservation
+		diagnostics. ``comp_budget_limit`` and
+		``comp_budget_background_limit`` report the current background
+		execution-credit limit; ``comp_budget_active`` and
+		``comp_budget_background_active`` report currently held background
+		credits. Their ``comp_budget_peak`` and
+		``comp_budget_background_peak`` fields are recorded occupancy
+		high-water counts. These are credits, not pages or all contexts in
+		use.
+
+		``comp_budget_direct_limit``, ``comp_budget_direct_active`` and
+		``comp_budget_direct_peak`` currently report zero: direct reclaim
+		does not consume these background execution credits. Zero does not
+		mean that direct compression is disabled. ``comp_budget_waiters`` is
+		the current number of registered context waiters, not only waiters
+		for budget exhaustion. Limits and occupancy are gauges; peaks can
+		restart if the associated context resources are reinitialized.
+
+		``reclaim_ctx_budget_pages`` accumulates base pages associated with
+		context misses attributed to execution-budget exhaustion.
+		``direct_budget_reject`` counts direct-reclaim precheck or
+		acquisition failures attributed to that budget;
+		``direct_budget_reject_pages`` sums their base pages.
+		``kswapd_budget_wait`` counts reclaim-daemon context wait-loop
+		attempts attributed to budget exhaustion, not slept time or unique
+		callers.
+
+		``direct_staging_count`` is the initialized number of staging
+		buffers. ``direct_staging_free`` and ``direct_staging_active`` are
+		current free and occupied buffer counts. ``direct_staging_peak`` is
+		a recorded occupancy high-water count and can restart on resource
+		reinitialization. ``direct_staging_miss`` counts unsuccessful
+		attempts to reserve a staging buffer; compression can continue
+		without staging. ``direct_staging_detach`` counts transfers of
+		output and timing state to staging that release the compression
+		context before completing the store; it does not indicate store
+		success.
+
+		Additional accumulated reservation/split diagnostics:
+
+		* ``restore_spans`` counts reservation rollbacks requiring an
+		  initial reverse-mapping restore walk; ``restore_rewalks`` counts
+		  additional walks while reservation tokens remain referenced.
+		* ``restore_ptes`` counts page-table entries mapped back to resident
+		  folio pages during those walks.
+		* ``restore_missed_pages`` sums base pages still referenced by
+		  reservation-token PTEs after those walks when the reservation is
+		  dropped. A subsequent fault restores the resident page instead.
+		* ``restore_ns`` sums elapsed reverse-mapping walk nanoseconds;
+		  ``restore_max_ns`` is the largest recorded individual walk
+		  duration.
+		* ``split_refused`` counts refused anonymous-folio splits due to a
+		  reservation; ``split_refused_pages`` sums their base pages.
+
+		Event counts and durations are accumulated statistics; gauge, limit,
+		initialized-capacity and peak fields are not interchangeable.
+		Separate locks and counter reads do not provide a coherent
+		whole-file snapshot.
+
+		``aging_work_calls`` counts retained-header aging callbacks;
+		``aging_detached_headers`` counts the empty current headers they
+		detach. Both are accumulated per-CPU events. They do not reset on
+		read and are not atomic with ``retained_empty_headers`` or the
+		metadata allocation/free gauges. Detaching queues existing RCU
+		callbacks; it does not mean those callbacks have completed.
diff --git a/Documentation/admin-guide/mm/index.rst b/Documentation/admin-guide/mm/index.rst
index 8b35795b664bee614fd941f12ba3a7df937f3a6f..c11d8c58d7e3cc26f87181f7bb4cb400c73c46e0 100644
--- a/Documentation/admin-guide/mm/index.rst
+++ b/Documentation/admin-guide/mm/index.rst
@@ -30,6 +30,7 @@ the Linux memory management.
    hugetlbpage
    idle_page_tracking
    ksm
+   memcomp
    memory-hotplug
    multigen_lru
    nommu-mmap
diff --git a/Documentation/admin-guide/mm/memcomp.rst b/Documentation/admin-guide/mm/memcomp.rst
new file mode 100644
index 0000000000000000000000000000000000000000..78298a51ad6eb198e6c5e00e94434e82d2966ed6
--- /dev/null
+++ b/Documentation/admin-guide/mm/memcomp.rst
@@ -0,0 +1,149 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================
+memcomp administration
+======================
+
+memcomp is an experimental compressed backing store for anonymous and
+shmem/tmpfs pages. It keeps compressed payloads in RAM before using block
+I/O and can write cold payloads to real swap. It is not a block device and
+does not require a zram device or a swap file as its initial storage layer.
+
+Configuration
+=============
+
+Enable ``CONFIG_MEMCOMP`` in a 64-bit kernel with MMU, crypto and swap
+support. ``CONFIG_SWAP=y`` is required even when no swap device is active.
+The option selects stock zsmalloc, the crypto compression interface and
+xxhash; it does not require modified allocator or codec code.
+
+``CONFIG_ZRAM`` must be ``n``, not ``m``. ``CONFIG_ZSWAP`` must also be
+``n``. Coexistence is not supported in this version. Enabling memcomp
+reserves one swap-entry type, reducing the available swap-device types.
+
+``CONFIG_MEMCOMP_DEFAULT_COMPRESSOR`` names the default crypto compressor
+and defaults to ``zstd``. Build the desired compressor into the kernel or
+make it available during initialization. For zstd this includes
+``CONFIG_CRYPTO_ZSTD``. The exact registered crypto name matters.
+
+``CONFIG_MEMCOMP_DEBUG_STATS`` adds diagnostic counters and hot-path
+accounting. Enable it for validation and controlled measurement; disclose
+its setting when comparing results. It is not required for the two
+core read-only attributes.
+
+The ``memcomp.compressor=<name>`` command-line option overrides the
+configured default. Initialization waits up to ten seconds for a late
+algorithm registration, falls back to zstd if selection or setup fails,
+and leaves memcomp disabled if the fallback also fails. Check the kernel
+log and the reported compressor instead of assuming the request worked.
+There is no ``memcomp.fast=`` option in this implementation.
+
+Inspecting the pool
+===================
+
+After successful initialization, inspect::
+
+    cat /sys/kernel/mm/memcomp/stat
+    cat /sys/kernel/mm/memcomp/compressor
+
+``stat`` returns three decimal byte counts: logical stored bytes,
+compressed bytes and allocator pool bytes, in that order. ``compressor``
+reports the selected crypto algorithm. The implementation uses zsmalloc directly;
+there is no allocator-selection attribute.
+
+Logical bytes are not physical RAM usage. Same-filled entries, metadata,
+allocator fragmentation and swap-backed entries have different costs.
+Do not interpret a single ratio or the pool byte count as a complete
+measurement of memory saved. In particular, writing a payload to swap
+does not remove the logical data represented by its token. The first two
+stat values retain swap-backed entries and are not resident-RAM gauges.
+Pending reservations are not committed compressed capacity.
+
+Additional nodes exist only with debug statistics enabled. Their fields
+are documented in
+``Documentation/ABI/testing/sysfs-kernel-mm-memcomp``. Take snapshots
+around the measured workload and subtract counters with matching units.
+Counters can include repeated attempts on the same page; they do not
+necessarily count distinct pages. Gauges and high-water marks are not
+cumulative event counters.
+
+Swap and memory pressure
+========================
+
+Real swap is optional for in-memory stores. If it is available, normal VM
+swap can provide fallback before token ownership, and memcomp can write
+cold payloads back using packed or unpacked swap slots. Writeback limits
+are derived from total RAM, not from a fixed device-specific capacity.
+The pool is not a preallocated reservation of that fraction of RAM.
+
+Storage can fail because data is incompressible, memory-cgroup charging
+fails, an execution resource is unavailable, allocation fails, or a VM
+race changes the source mapping. A failure after unmap restores matching
+PTEs or retains resident backing before releasing ownership. It does not
+immediately overwrite the token span with normal swap entries.
+
+Unchanged incompressible contents are marked to avoid repeatedly paying
+compression cost. Modified contents can be retried. Same-filled contents
+need entry metadata but no allocated compressed payload. KSM-merged
+folios are excluded from anonymous memcomp reservation.
+
+``swapoff`` must resolve memcomp entries backed by the removed swap area.
+This can require RAM and can fail; a successful swapoff is not a promise
+that the compressed pool became empty. Do not use swapoff as an eviction
+or reset interface for memcomp.
+
+Memory cgroups
+==============
+
+Entry metadata and compressed payload storage are charged to the source
+folio's object cgroup rather than to the task doing reclaim. This is not
+a separate memcomp quota, target or per-cgroup writeback controller.
+Refaulted folios still follow the VM's ordinary memory-cgroup charging.
+Observe the normal cgroup memory interfaces as well as memcomp statistics
+when applying memory limits.
+
+Validation
+==========
+
+Run destructive pressure and swapoff tests in a disposable VM. Building a
+kernel or running KUnit does not validate every reclaim topology or
+workload. Keep the source revision, effective configuration, command and
+complete log with each result.
+
+The dedicated KUnit configuration is
+``mm/memcomp/tests/.kunitconfig``. For example::
+
+    python3 tools/testing/kunit/kunit.py run --arch=x86_64 \
+        --kunitconfig=mm/memcomp/tests/.kunitconfig \
+        --build_dir=<kunit-output> --jobs=<jobs> 'memcomp*'
+
+Tests that call madvise are registered only when
+``CONFIG_ADVISE_SYSCALLS=y``. A configuration that omits the syscall does
+not exercise those MADV_FREE cases; do not report the full configuration's
+case count for that build. KSM flag rejection in KUnit does not replace a
+real merge/pageout regression test.
+
+The MM selftest is built separately from the kernel::
+
+    selftest_out="$(pwd)/selftest-out"
+    mkdir -p "$selftest_out"
+    make -C tools/testing/selftests/mm OUTPUT="$selftest_out" \
+        "$selftest_out/memcomp_selftest"
+
+The accompanying harness covers pageout/refault, ownership churn,
+userfaultfd moves, shmem and swapoff. Match its requested features and
+resources to the guest configuration. A skipped feature is not proof of
+runtime coverage on a kernel that enables that feature.
+
+Known limitations
+=================
+
+This is an RFC implementation based on Linux 6.12. The swap-entry encoding,
+64-bit restriction, mutual exclusion with zram/zswap, multivalue sysfs ABI
+and source layout need further work before an upstream submission.
+
+Runtime coverage of hibernation, memory hot-remove, DAMON and all
+khugepaged interactions remains incomplete. VM correctness tests and
+relative VM measurements do not establish real-device latency, energy or
+compatibility. Device validation must use the intended release image and
+be reported separately from development-tree results.
diff --git a/MAINTAINERS b/MAINTAINERS
index d1d8f578f62cd9c0b824b0a5f95b49433970c377..5e557aaae70d25ec47f8a602fb89eb63729d14a3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14806,6 +14806,8 @@ MEMCOMP IN-MEMORY COMPRESSION
 M:	nakixii <nakixii@gmail.com>
 L:	linux-mm@kvack.org
 S:	Experimental
+F:	Documentation/ABI/testing/sysfs-kernel-mm-memcomp
+F:	Documentation/admin-guide/mm/memcomp.rst
 F:	Documentation/mm/memcomp.rst
 F:	include/linux/memcomp.h
 F:	mm/memcomp.c

