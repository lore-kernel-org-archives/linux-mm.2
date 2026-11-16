Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45AAD606A895
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hHG9Uz9g
Received: by kanga.kvack.org (Postfix)
	id 6F5206B05C9; Mon, 16 Nov 2026 06:05:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5966B05CA; Mon, 16 Nov 2026 06:05:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB4F6B05CB; Mon, 16 Nov 2026 06:05:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 349776B05C9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:05:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D3FF8A8711
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:05:02 +0000 (UTC)
X-FDA: 85440700044.29.0C18C63
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id EBC6118000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:05:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hHG9Uz9g;
	spf=pass (imf06.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dEwMuEk6L9PkuPwgRk5o/Rg0G4cgqI2PeNM611PKi+o=;
	b=RRhDrGo/RupFS6V15l648X/OXFeC6thPQjLlpfMW/2pTqaPmwSjA5/5lspJLboaaA5sLoj
	OOAl02GyQHG0nknth8Lv6b8XkA6B07Nxbgj2/frAk1Ab05ZlGM8X5FolQea7pXR7Zc3xrF
	QKjog9fhcFA/52+tAki9KqWtcRsC8AI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827101;
	b=0BW2dJMKw5bxZIToBqHo3Hr5TAaI91Ye/O0m+lbBnYBiopds0fcq7dawsU1j0DnxKJmE8/
	KklxyEk2ZKnyR9wBbyibVYPKF6kvSg1GTpwdvZJ3+08wIxZ9NmUGXC+xV43imF86g3BKkX
	crVvrt78n8QAFQsuO+/VIXqA1gLM4Dg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hHG9Uz9g;
	spf=pass (imf06.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1a8cc11ac42so3002266c88.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827100; x=1795431900; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dEwMuEk6L9PkuPwgRk5o/Rg0G4cgqI2PeNM611PKi+o=;
        b=hHG9Uz9gffRyw0dYek52MG/i9lASZ3y8W0uhed3pUoL4hAqlfyx95VbrkuOGow9axf
         RWSC6+vwtw2W3koN4rzErMjbFQ/NWQDk9EC7/xEccxBhOxhnMwUvUuvFsBXQyO2GstUB
         RSzypIj8XriuRneZ2HauCGQjxd+/RT6ZWbxvEhmBlE5wReddpgNWj0O98Nc/64Vv0WB/
         E5MXFzoNp9kYYHYCfiNtdsMOtxm0TowL28U8r9IbFbjO2GLih/tIt7ljHYXh4G1STkJ+
         cOV+IxxLUN9cQALYlDE+cuTidLnddfxoZiHoLea8W1yhY1nR2vumlyFXeeG+6vrzPntL
         J4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827100; x=1795431900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dEwMuEk6L9PkuPwgRk5o/Rg0G4cgqI2PeNM611PKi+o=;
        b=nbDsVCNT5fPkdMyE9quHlcYZhoo0F54Bs+RHfnC1kP+NskL4fedvP5hszxiS74+/UG
         nG8yBgicu0Kui44N8HZfM25kxOBImOXNfiiqbDGPhVDqwe2dUlTn8HbnfFL+4s0II72b
         NBQxkQR+uibRWZuaMJL48812OPYssyX8WvzIj2/k/zMfptdiBYiou6/IAgBPFph7TpBy
         YC61QhphMI4FJLvbVtiJOcdxezC/SA1s2pgc0wvHm1pUhp8evSQTvkslD5bHfOBKKSM2
         ISfolwQUktveostbu7VPmwaPJiz0YS4+++1q5rpzTRJ5rxX0F9AonZ8k3GuKSpHcifiX
         YG4w==
X-Gm-Message-State: APuU4Z9lyk6ukpQmgj2Zjhh2K7v4WeJ6opgFzlfq6+5IpwBw7dtkjNe1
	NnTTmDg11JIkFNQOrVEVzvDMXoPCXALyRyNivFQr/JbcMT/MB8sGGTfJc8bA5RM0fmmbz7r5
X-Gm-Gg: AYBFou3FeguNt891J3XQYZwF3Z6uBvA46PvtObIuKeVIzeGlmUPkNz5Ama7AcXLRt8J
	cTzJlFicPIm9AZ4QsyaFUzDAp3dUPex6dqhkLrUyijyj4xDd0P1hLkwjL2Sf2apaxmahF5HUZfV
	SVdp13vm2DdSQc9t9rO5U5i2B3FQD6xgxWOI2VL6/N81+/ymdMIcr1g61MZbViq0eznlp5ktXvn
	D5c7Nhs3pD/4OJdrUDuw3KFHghvC0erL4aDD6L5KROMeKrzxw9uMHk2Lzzo6SlWIRYsZ4BJmBZB
	smas4ZiAC3BaHe03rPAglAuTuOeph1SddBDxY+58vcCWgyG9VEKPumBZ1c/QIwvclGTFpm8HdtM
	bNNOdu8wJs06UChPbBnSO1uChtLYrFC/4gS6iuc3tXTkTyvEnNJ7ZQMYKMU7SHl4NV5TmXGJ6vb
	X/sxoNNlwMddhCTwS9EYYxKpaeolL5/eLp1hjw7lGXiOv6EXdrB2Gvc0W1K3qE9r1Ocy82aDGd3
	YFoOMEbkLmypItn27pFFUERklOTrJQgHiftM2WVmxlK78quEMI3NAuGB8XB+u3KHWlqC1XrYOmF
	zmaZX86Zfu6azZUdxEl37NSoPd6oQt7Zel/jLuRb/ckZ8CE=
X-Received: by 2002:a05:7022:ea81:10b0:193:3274:aac with SMTP id a92af1059eb24-1b50312f210mr9875871c88.37.1794827099537;
        Mon, 16 Nov 2026 03:04:59 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:04:58 -0800 (PST)
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
Subject: [RFC PATCH 15/16] mm: memcomp: add the design doc
Date: Mon, 16 Nov 2026 19:01:21 +0800
Message-ID: <20261116110122.309748-16-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
References: <20261116110122.309748-1-nakixii@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EBC6118000D
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: qq8isj1pi6aiuhekrafjx6zrnctsnq9i
X-Rspam-User: 
X-HE-Tag: 1794827100-664004
X-HE-Meta: U2FsdGVkX1+A3eA8/diLxmUcYkY+LY44reniRAuz0dz8wGmg9F3EodGFZj2aScpyI/6hpOBqdNqtDcko7DTGKgQk9ihJZWzTZxijRUhnMtY3j/+u5kh50fWvkhiKf9FxcoN2GdnHHCC4IlqCZWAni6tEIqbl+seGPac1P832mMs8P1bdgIfz1BZcXfun4MJjLrrwnIaE/eNmcI0cA5guU3gmu4f+qsfe45BEVl2R4oQVkp5lPLJraxZnPTsj5vUgZToVg0L9OrndviBoWwwj4sylMGdyppYScZ2MyRJAjp+z3r/xR57sYdp6X/s+sgcQFnyohIj5vcrGMTb6bJqhfjVglsAZdasSbLrVvJv/nsHaOejjXYc6oRN2A/rs/eRG9te6UaW3dIS2KPa9yp2gJ1PJgF/cBMu+C9rpyZpY8N3xd5/y40w0Dmc1U9owBZNu/La/FbpNw3oceCx6y6L0uqPVitXB/S5LvkaSL7G0yj+XvWrVlQybWAb9aVpJ8c6hsO3bkm+sJ0eskmW3v4SxVkuMkOthQN/APH5kTyZrmYxl4+1+5HdVhpU/Zcgcd/STgIdy9xmhQKiS+rVpshW9GHu9ciZsZwe6rLeV7Ez0oTRG+MMmY+LVMA+kU9HIIWwWzOgo6vplpNTdT35xXsfI28WpLrQD8DpLVABbNaqoNwqe96ot8FDpdLDCFq0SrzsTuJF73NPo3FvWaoHolvaMir3JPZPly4hnuy2qxCgz0NHp/zUlAaxLqeDAgOSGBZKv303csuuR8OVn6A7blNOVbSd6h6vO1DyL9a0GHExUikEjPgYjeKwZNpsrg37Km2XOC+g4caGWBtAjmskb6//pdbHg3DYmsYQEEHT+Do2H5kY6pIqg2mAev1jCUwzRwubL6w6cdwJuQCpJBAxLMm+X1qvIj2GlqC0ccTdMDZcAYsVWo7PHKldQjYvbj6SxQ/0HpRhQ4ze4O6n0Ruvg5sW
 zrRldKQ6
 S4LKtkbL0VudH+MK2OV1tOJeabZOJfuBBxFwdtdD9Bad42boi9KjvesrGSOmMgBzCjdMlagfIq7ekiNRS86e1pfgC7D5GBctIumNWQRZroimlVjzlWjP4BUGedKcHb/mvJgsZdLSMkr2YsKl7gP1eEu+KpoqicHqAnnCx/o4RdEx1iU6sTyoecBYSVKtP7d85ns48ERP7YjQiTjgCSgWefbxWW9R8JX0cvxwGz2iwMFa0g6xekPMbqrkrKceNgdd7tIZHgJNOwh1frhZ/Qp5lyTBVb5vKm7jxA7u/c+EJWSd2k2uu/KK+yNGt05wswHWpepPpqRMow7YvTo3LgEfcOqM5Gs8xKkaGFwrS0KQqmIxN6MpARX8P3Q1nXU/jaPfW/l98jkJML83d4A3A/yI/2LcBAn0I8vgBBQyc4TAwVNMVgH2g8URH6r++bH5nq/a9qdMTigbUjwwIwqQXYXsQbRz4IS0k+Ctt4WpS1i4c3FXYHPNhAn3XE4e8NFpfmdyAsR52hp8mGkheFlgMtqsCoQ6pkGh41DAJVhdneN+KKA+8KwOrPjB6u0gIBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The memcomp backend spans page-table ownership, compressed storage and
real swap. Document the design so readers can follow which object keeps
contents alive when reclaim, faults, fork and backing conversion
overlap.

Describe token encoding, 16-byte slots, per-key clusters and temporary
resident records. Explain the separate zero-owner domain, nonzero same-
filled values and source-object-cgroup accounting without treating the
slot layout as the entire per-page metadata cost.

Document anonymous unmap and rollback, single-PTE rmap restoration,
fault revalidation, shmem shadows, writeback and swapoff. Explain the
lookup, producer and mapping references and the locking boundaries that
keep allocation or I/O out of non-reclaimable critical sections.

Describe bounded compression contexts, foreground asynchronous batches
and metadata aging in batches of at most 32 examined entries per storage
lock acquisition. Document the stock crypto and zsmalloc dependencies,
supported contexts and restrictions, and link the design from the
memory-management documentation index.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 Documentation/mm/index.rst   |   1 +
 Documentation/mm/memcomp.rst | 215 +++++++++++++++++++++++++++++++++++
 MAINTAINERS                  |   1 +
 3 files changed, 217 insertions(+)
 create mode 100644 Documentation/mm/memcomp.rst

diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index 0be1c7503a010de78c1c1965b43bffc6311a6ca6..dc00d0b5db14d1a323715ceb8bdefe66e4179d17 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -46,6 +46,7 @@ documentation, or deleted if it has served its purpose.
    hwpoison
    hugetlbfs_reserv
    ksm
+   memcomp
    memory-model
    mmu_notifier
    multigen_lru
diff --git a/Documentation/mm/memcomp.rst b/Documentation/mm/memcomp.rst
new file mode 100644
index 0000000000000000000000000000000000000000..08524581e26a88119d9b2bd0f327fc7c3ccf9cf9
--- /dev/null
+++ b/Documentation/mm/memcomp.rst
@@ -0,0 +1,215 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+================================
+memcomp: compressed page backing
+================================
+
+memcomp provides experimental in-memory backing for reclaimed anonymous
+and shmem pages. It uses the crypto compression API and stock zsmalloc.
+It does not route the first store through a swap block device. Optional
+writeback can move cold payloads to real swap without replacing the
+memcomp tokens held by their mappings.
+
+This document describes the lifetime and VM integration rules. The
+administrator guide describes configuration and the existing sysfs ABI.
+No particular compression ratio, latency or energy saving is guaranteed.
+
+Tokens and backing states
+=========================
+
+A dedicated non-swap entry type distinguishes memcomp tokens from real
+swap offsets, migration entries and PTE markers. Enabling memcomp consumes
+one of the swap-entry type values. The implementation requires 64-bit
+kernels: a token must round-trip through a PTE offset, and the compression
+paths must be able to address a whole folio through its local mapping.
+
+An anonymous folio reserves a consecutive token span before reclaim
+unmaps it. Each entry records its position and the size of the source
+span. An entry can refer to the resident source folio, a compressed
+payload, a same-filled value, or swap backing. A token identifies the
+entry, not the address of a zsmalloc object or a swap slot.
+
+Entry references include mapping and internal references. Fork acquires a
+reference before copying a token PTE. Zap and MADV_FREE drop only the
+references represented by the PTEs they remove. Discarding one mapping
+must not invalidate another mapping's reference to the same entry.
+
+An entry's owner relationship with a folio is distinct from the reference
+that keeps a resident folio faultable. A failed store can release its
+owner hold while a token that escaped rollback still refers to the
+resident contents. Releasing that resident reference too early would
+leave a valid PTE pointing at a freed folio.
+
+Anonymous reclaim and rollback
+==============================
+
+Reservation requires a locked, swap-backed anonymous folio outside the
+swap cache. KSM folios are excluded. Their reverse-mapping rules are not
+the anonymous rules used by memcomp's restore walk; a still-merged folio
+must not acquire a token even after its mapcount falls to one.
+
+Reservation pins the anon_vma while the folio still has its mappings.
+The normal single-PTE reverse-map walk then installs token PTEs and takes
+the corresponding entry references. Reclaim must flush pending unmaps
+before reading contents for compression.
+
+Compression, backing allocation or a subsequent ownership check can
+fail after some PTEs have changed. That is not an opportunity to overwrite
+the reservation with a normal swap entry. The failure path restores
+matching PTEs through the pinned anonymous reverse mapping, updates RSS
+and reverse-map accounting, and drops the reservation. It re-walks a
+maximum of three times while escaped references remain. The initial walk
+can be retried even if it restores nothing; a later re-walk that makes no
+progress stops the loop.
+
+When every page of a large folio has been mapped back, rollback repairs
+the partially-mapped deferred-split accounting. Otherwise a failed store
+could leave a fully mapped folio queued as though part of it were absent.
+The anonymous reverse-map pin is released on both successful store and
+rollback. Entries that escaped restoration retain resident backing until
+fault or invalidation resolves them.
+
+Normal swap is a forward-progress fallback before a fresh reservation
+owns post-unmap tokens. A failure after unmap restores or retains resident
+backing first. An unchanged incompressible folio can take normal swap on
+a later reclaim attempt instead of repeating the failed compression.
+
+A dirty anonymous swap-cache folio gives up its swap slot so that its new
+contents can be compressed again. The locked-folio check also reads dirty
+state still held only in PTEs or PMDs, without clearing or write-protecting
+those mappings. Checking a clean mapped folio can require a reverse-map
+walk, but its usual swap-backed eviction is unchanged. Writeback or
+outstanding swap references leave the folio on the normal swap path.
+
+Compression and allocation
+==========================
+
+The allocator is zsmalloc, called directly rather than through a custom
+allocator interface. Compressor selection uses the crypto API and does
+not require private hints or changes to a codec. Allocation and context
+admission must obey the caller's reclaim constraints.
+
+Bounded compression contexts and detached staging buffers limit concurrent
+resource occupancy and allow foreground admission to fail. They do not
+guarantee bounded reclaim latency: background context acquisition and
+asynchronous completion waits have no timeout. The lease
+needed for a synchronous store is acquired before unmapping and consumed
+by the store on every return. It is released before finishing or rolling
+back the folio. Foreground admission failures can stop repeated anonymous
+attempts in the current reclaim pass so that file reclaim can proceed.
+
+Same-filled pages store the repeated value without a zsmalloc payload.
+A folio whose contents did not compress can carry an incompressible mark
+and a content hash in folio->swap while outside the swap cache. The mark
+is not a reserved token. Reclaim recomputes the hash and clears a stale
+mark when contents change; migration carries the mark with the contents.
+A split cannot assume that the original whole-folio hash describes each
+new smaller folio.
+
+Payload thresholds depend on the allocator's actual class geometry.
+Logical compressed length and allocator footprint are different costs.
+The implementation must not assume that a threshold measured with a
+modified allocator also applies to stock zsmalloc.
+
+Asynchronous foreground batches
+================================
+
+A crypto implementation with an asynchronous form can compress a bounded
+batch of already-unmapped folios in the reclaiming task's path. The
+reclaimer flushes their pending TLB invalidations, submits requests,
+waits for completion and then publishes the resulting payloads. Small
+batches can use the synchronous path instead.
+
+A batch does not hold the limited store leases while waiting for the
+compressor. Failure to acquire a lease when publishing a completed folio
+fails that store and invokes the same rollback rules. No private crypto
+execution hints or independent background compression worker are needed.
+
+Fault, migration and userfaultfd
+================================
+
+A token fault resolves the entry and its backing, prepares a folio, and
+revalidates the PTE before publishing a present mapping. A concurrent zap,
+move or invalidation can require retry rather than installation of stale
+contents. Fault results use vm_fault_t rather than negative errno values.
+
+A resident token must be restored where the source folio's reverse mapping
+expects it. UFFDIO_MOVE first faults that token back at the source address
+and retries through the present-PTE path. A nonresident exclusive token
+can move like a swap entry. A stable entry reference spans the lookup and
+PTE revalidation; entry locks must not be acquired while the temporary
+PTE mapping keeps an RCU read-side section active.
+
+For a present PTE, UFFDIO_MOVE checks exclusivity on the actual source
+page, not the first page of its folio. Reclaim can clear exclusivity one
+page at a time. A genuinely shared page remains rejected, while an
+exclusive tail page is not rejected just because the head differs.
+
+Migration transfers the resident/owner relationship together with the
+contents and restores that relationship if the VM mapping transfer fails.
+Splitting a folio with a live reservation is refused; rollback must first
+resolve that reservation and repair deferred-split state.
+
+Shmem and memory cgroups
+========================
+
+Shmem keeps memcomp tokens in its page-cache exceptional entries rather
+than installing the anonymous reservation protocol on an inode mapping.
+The writepage handoff and the swapin path balance the mapping's entry
+reference separately from an anonymous folio-owner reference. Truncate,
+fault races and allocation failures must undo the associated inode and
+entry accounting.
+
+Compressed storage is charged to the source folio's object cgroup, not
+the task that happens to execute reclaim. Metadata and allocated payload
+bytes have distinct lifetimes. A pending charge must be refunded if
+allocation, publication or a competing operation prevents its transfer
+to the entry. Same-filled payloads still require entry metadata.
+
+Dropping a mapping does not necessarily destroy the backing entry. The
+payload charge is refunded when allocated backing is freed, including
+conversion to swap backing. The metadata charge and object-cgroup reference
+remain until the RCU-delayed entry free. This is compressed-storage
+accounting, not a separate per-cgroup admission controller or swap budget.
+Normal VM charging is still required for folios allocated on refault.
+
+Swap writeback
+==============
+
+Cold allocated payloads can move from the pool to real swap. Packed slots
+share a swap page between multiple payloads; the hybrid representation can
+also use an unpacked slot when packing does not fit. Slot ownership,
+packed-member lifetime and read-cache references are balanced independently
+of the mapping's token reference.
+
+Writeback selection and its drain budget are bounded. The policy derives
+its limits from total RAM rather than a device-specific memory size.
+The level controller observes zsmalloc's physical pool footprint. It must
+not close its feedback loop on total stored logical bytes: moving a
+payload to swap leaves those bytes represented by the entry, so that
+quantity does not measure memory released by writeback.
+
+Writeback pressure scopes exclude inappropriate reclaim contexts and
+avoid doing packed I/O in direct reclaim. Swapoff resolves entries backed
+by the disappearing swap device into RAM, balances failures and lost
+races, and does not report a failed conversion as successful. Allocation
+and I/O must not recurse into reclaim under an entry lock. Conservative
+packed-slot defragmentation remains separate from active pool draining.
+
+Observability and limitations
+=============================
+
+The stable stat file reports logical stored bytes, compressed bytes and
+allocator pool bytes, in that order. These are not interchangeable gauges.
+Debug event counters can count repeated attempts for the same page; their
+deltas are not counts of unique pages. See the ABI descriptions for each
+field's units and accounting point.
+
+The current implementation is mutually exclusive with zram and zswap,
+supports only 64-bit configurations, and reserves one swap-entry type.
+Its multivalue sysfs files and large implementation are RFC limitations,
+not the intended final upstream interface or source layout.
+
+Runtime validation of hibernation, memory hot-remove, DAMON and all
+khugepaged interactions remains incomplete. A successful build or a test
+in one VM topology does not establish coverage of those interactions.
diff --git a/MAINTAINERS b/MAINTAINERS
index 98c920275f276ba29fdd459a39aa8db7c83042e7..d1d8f578f62cd9c0b824b0a5f95b49433970c377 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14806,6 +14806,7 @@ MEMCOMP IN-MEMORY COMPRESSION
 M:	nakixii <nakixii@gmail.com>
 L:	linux-mm@kvack.org
 S:	Experimental
+F:	Documentation/mm/memcomp.rst
 F:	include/linux/memcomp.h
 F:	mm/memcomp.c
 F:	mm/memcomp/

