Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C0E606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=THYEh85K
Received: by kanga.kvack.org (Postfix)
	id B80D06B05B9; Tue,  3 Nov 2026 13:32:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58CA6B05BA; Tue,  3 Nov 2026 13:32:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95C56B05BB; Tue,  3 Nov 2026 13:32:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 838A16B05B9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:32:14 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02C381A051D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:32:13 +0000 (UTC)
X-FDA: 85394652588.11.DE5510D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2A74A1C000D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:32:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=THYEh85K;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793730732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILxjlezexMiQB/qhWIVMMSrAnR1CgTKb5LctsghKpDA=;
	b=0zCuHU4kqQxe8ywtmgYoMQdDK8X+mlmD4V5R8EDvLKLNsQCtK5nlh4EwJDv6sd+Gpnuu7w
	E1xszeUguumeuTL/Zpkkru2LyxUoL2LHHei6m2gabKtqgmXfjBAweXwkKu+Rr4WwEaL9eR
	huBWdWPNXxjmt0Z39bA8M+ck1bpq6dg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793730732;
	b=MzyLKKzrSM+d6o7dzXHRB3VnCBIgFFlP0fklbPI6DqhuAx70ewM+TP0NJ7RBqCjoHlf6yc
	GMn9E1Y1d0gCg0e7rws+xh09hUSyT7JffzRpdRMrtSBicPTwgCfrxEOO2p4RqhMKa/zK5G
	5eLDfkz0pKDuyDflsmkMXVpjGX3rMQ4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=THYEh85K;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7483E410D2;
	Tue,  3 Nov 2026 18:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC991F0093A;
	Tue,  3 Nov 2026 18:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793730731;
	bh=ILxjlezexMiQB/qhWIVMMSrAnR1CgTKb5LctsghKpDA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=THYEh85KQWOpxrvmoqUb2jEuaZfJef3XGlNmMAX94uUHsGZcHWKByuiUrBtK9JEn0
	 mgw9BSzDNS36vOkvuaGr786d3q026sTUsQjdOE5fD2wHArn24ihDQgBk0yXJFrrb5K
	 bZ8FfY04P1l47coY+32n9aWn3MxIVQP0ZrcbqOHLpW9CJN1qR1VL6Fq7cRIgCkyB6D
	 B16173Q6wgI5OtSwxa1Yj9S8MNSuZ7Tex5+DXR368PZDUp0QYMSm+jifiBDowuu5vB
	 D9mly+sh+ne3A565hDreKSKo9b0ttO5vA+7QDJQhQkQtM8dY/RasZfanZlAATZECs/
	 aSOe7cGNhKZyw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 03 Nov 2026 19:31:45 +0100
Subject: [PATCH 2/2] mm/memfd: handle GUP references reliably when
 write-sealing
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-fixes_core_2-v1-2-f332954f1df4@kernel.org>
References: <20261103-fixes_core_2-v1-0-f332954f1df4@kernel.org>
In-Reply-To: <20261103-fixes_core_2-v1-0-f332954f1df4@kernel.org>
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Rheinsberg <david@readahead.eu>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9093; i=david@kernel.org;
 h=from:subject:message-id; bh=TSim9uX0FbLg8fMVFA/cFmoTXi4bDfYuxnZBghXN86g=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJeacwKS/qatPL1449zBWJviAvIzu7O07+8uF3zrNbFB
 Gf2TervO0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZhIixnDfx/Jn54xr3Z+8M96
 LJTxw7nZkeP1pMqQvVd7XlvM5K0R12dk+DtP327OFV6ZBZXWRgzSoocrd1tf+L624+8cZ8nN33/
 xcQEA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: z45oxqfrfwdojnwakgk4mf6iu7178dxy
X-Rspamd-Queue-Id: 2A74A1C000D
X-Rspam-User: 
X-HE-Tag: 1793730731-230210
X-HE-Meta: U2FsdGVkX1+QpFR5CEUPObu4F7AgmL1IpYgQFOrIaCkBTQ+bFF2VwJhpF+sVD6BhZHY+Pf7SeEYc6toaeJjwNOFmzceSXrpF9IFOe6AMVEiU9KNHjF96NgbsR1KkWFMG/mspuQnSQaVl9PYeEjYbupQBUmWZmDiZNSwXM8YjBnKhJmT0gW57uZVHHTBZzdvB3xQrXxNw1T1H9stU5rlVpt2BUkrb/0/tEFQmu27P9kEHf/ScYEEQHv9J4A3cEkfOggulM72CabghMz/FCmfQRTjCl1Z8W7Eu7kdgMsfnZdrpRhwyQBmh/uVlhUUXE/2mfs5Ru4LhRCWtOJNCdcinBYH3KiXpIUJk2E/H8yaC5xGlkeGhRUB91DCBrTFOXTdUvnA7EEA328042APX2ix6QdS5cHh+qu1rNvbR9RrbLSTpACJxtcaNw21YgHtnMwvGrJks/lzV+C8aT8lZ4qfnmuXnKvbHS7y6SbJhksyYjiwIDX+ihMG09eZJ6Ol2XOUTZDMDfGfKeIu/xjgzhqZ+QnxYnwWRf+JKEhV1GDsAdam6Ftjl2w9dPVUZDVxM3I/9xwidbmIYkdZCLg4BGLRHTLdYuYUvC/a9Qln5fuSrdsFkacKaNk1SQ/Gfs1ee9kquplpRaMQT3VYLgfEfTABdSki0SndiuyMR+7q4uSUOb0zSUOH0g4DhW9o3dbBu2w5aaCPgxCD9YD+FzMrvNTtdVWvD7B7JjIUHl56l3EDmbSXHYae2vvvvgY0Im4JfNqbc7o9NJyLHTnaEwAcbSO+EpaT3UqS2HJxPAjAJekTAdIghp3xigfzChBOq6Wz6wAL9FFJc2nJsLfhYkj4NcrEs7s3fF0V3cFa4MKXSP51h7tn8h/5GzM041LzZSZ90rghQzNrM2YyDRWZf5LrPxS0JVN/gEaGXNQuCSlnqAtjHncANlo00Uz8WkNRy3v6w7gHNLbgxICwPjPWtCZYSbPK
 kH01dsuK
 p6BmAW6rxaiH3Nkx5bBLT73xXUOtrgRrlUjZJUDne3AuW/ybCoNXNrdK+3gg4sjOHNgILFfAxHmqzpt8RaUhQyuljK2Qy4FGFuiYDjHwmeGBAMV2k0QG3Cy7mPL7u6Go5lWSQsxPAjbkXZ2Vl6XgHQ2iDjM0w67Sg5gOK+VRWZ7r+P/6Kot+wXGSR+D4MTXjDxOCcOclsjTswP1F5yfcKFiJ80dPkISFTLj3tbT7O19UVRDhb6aoez0CF+MelUa8AgQP6INjQCAcyMHM19M8GLc4P/Tgz9rQTC6iT3q/QBRPh0YtyhQnQTOefZdGhnoolRtjo+xEr1fr/zbGEjgontrMUTFj/cnVPlPe11maVzOpXWJ0jUjr+ePeOisKP8WbHlkc/n0l9pJzqq1a+ZaB0LqHhYXxOR9kaIYB2xnvSkk8/KvVdRaRkDUgqmnyYV8HPkAPpqdoTVxeTvTnH/qWQjxe2/gN+rRmgPxRPfc+UupMVpWMh9SFJQ4ZKw47CRZ7HvIx899KQ7g+vOcfEKIMu2ox1ratRL834Mnj7sxQArSk2EJq4Kiu6wInTFebQmZiF9bTIiZp9yhYgGcDyxV7H+L00GwXwrpSDwhsTnEJ7U8JkVnmTPklHkxytIFUwnUEd3IdKr+XQb/poAdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

memfd_wait_for_pins() detects GUP references by comparing a folio's
actual refcount with its expected refcount. As spelled out by
folio_expected_ref_count(), obtaining the expected refcount when there
can be concurrent folio (un)mapping is racy.

So it is possible that a changing folio mapcount can race with our
check for GUP references, and F_SEAL_WRITE might succeed even if there
are some, allowing file contents to be modified after sealing.

We made a big mistake when introducing write-sealing: we should have
disallowed *any* file mappings while we are write-sealing. Write-sealing is
usually done by a producer that wants to hand-off some data to a consumer.
Having the producer have a read-only mapping (private or read-only shared)
of the memfd while sealing is rather odd: it couldn't have been used to
fill the memfd in the first place.

Most identified public users don't do anything like that: they either never
map the memfd before write-sealing (using write() instead), or munmap()
before write-sealing:

 - systemd's journal writes, fwupd, Flatpak, runc, crun and
   containers/storage write to the memfd without mmap'ing it, before
   sealing it [1,2,3,4,5,6]. The FD consumer will not access the memfd
   before sealing.

 - dbus-broker, Mutter, Chromium's Android linker, KWin, Weston and glycin
   map the memfd file, but unmap it before sealing [7,8,9,10,11,12].
   glycin retries sealing while waiting for the loader to unmap.

 - go-memfd exposes a shared writable mapping before F_SEAL_WRITE and a
   private read-only mapping afterwards. Its API explicitly requires
   unmapping the writable mapping before sealing [13].

One exception is CRIU: it restores mappings before applying the saved
seals [14,15]. Unfortunately, we cannot simply disallow file mappings
without breaking that use case.

The preceding change handles FOLL_PIN by checking folio_maybe_dma_pinned()
if our folio has a reliable pincount. For small folios without that, the
1024 pinning BIAS makes it very hard (although not impossible) to misguide
the refcount comparison.

Handling FOLL_GET is, however, more problematic, and we still have some
users in the tree that use FOLL_GET for writing although they should be
using FOLL_PIN; and they are harder to fix, so we have to handle them
for now.

To detect any GUP references reliably, we need a stable expected refcount.
To achieve that with folio_expected_ref_count() we'd have to unmap all
folios and handle/detect concurrent faults, which opens up various cans
of worms, including dropping mlock accounting when zapping shmem folios,
shaky hugetlb mapping removal and properly handling concurrent page faults.

So let's make our life easier and only allow page-cache references when
checking folios. Compare against folio_nr_pages() instead. Concurrent
faults can cause false positives, but cannot hide GUP references. This
allows CRIU to restore mappings that have no file folios mapped yet.

Populated file-backed mappings, for example due to mlock(), can still
fail with -EBUSY now. CRIU preserves MAP_LOCKED when restoring mappings
[16], but whether any users actually restore write-sealed memfds with
mlocked file folios is hard to say.

To handle these cases that likely don't matter in practice once they pop
up, let's do the same thing we did with vm.unprivileged_userfaultfd: give
admins a way to keep such software working. Add
vm.memfd_write_seal_mapped, defaulting to 0. Setting it to 1 restores the
legacy behavior, including its racy reference-count comparison.

[1] https://github.com/systemd/systemd/blob/main/src/libsystemd/sd-journal/journal-send.c
[2] https://github.com/fwupd/fwupd/blob/main/libfwupd/fwupd-common.c
[3] https://github.com/flatpak/flatpak/blob/main/common/flatpak-utils.c
[4] https://github.com/opencontainers/runc/blob/main/libcontainer/exeseal/cloned_binary_linux.go
[5] https://github.com/containers/crun/blob/main/src/libcrun/cloned_binary.c
[6] https://github.com/containers/storage/blob/main/pkg/unshare/unshare.c
[7] https://github.com/bus1/dbus-broker/blob/main/src/util/log.c
[8] https://github.com/GNOME/mutter/blob/main/mtk/mtk/mtk-anonymous-file.c
[9] https://chromium.googlesource.com/chromium/src/+/e06bed6b494928199ae2fb4ec1fa9b03d0f4ef3b/base/android/linker/modern_linker_jni.cc
[10] https://github.com/KDE/kwin/blob/master/src/utils/ramfile.cpp
[11] https://gitlab.freedesktop.org/wayland/weston/-/blob/main/shared/os-compatibility.c
[12] https://github.com/GNOME/glycin/blob/main/glycin-utils/src/memory/shared.rs
[13] https://github.com/justincormack/go-memfd/blob/master/memfd.go
[14] https://github.com/checkpoint-restore/criu/blob/criu-dev/criu/memfd.c
[15] https://github.com/checkpoint-restore/criu/blob/criu-dev/criu/cr-restore.c
[16] https://github.com/checkpoint-restore/criu/blob/criu-dev/criu/pie/restorer.c

Fixes: 05f65b5c7090 ("shm: wait for pins to be released when sealing")
Cc: stable@vger.kernel.org
Cc: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/admin-guide/sysctl/vm.rst | 21 +++++++++++++++++
 mm/memfd.c                              | 42 ++++++++++++++++++++++++++++++---
 2 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 3cb0138e850c1..182db608ee436 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -42,6 +42,7 @@ Currently, these files are in /proc/sys/vm:
 - lowmem_reserve_ratio
 - max_map_count
 - mem_profiling         (only if CONFIG_MEM_ALLOC_PROFILING=y)
+- memfd_write_seal_mapped
 - memory_failure_early_kill
 - memory_failure_recovery
 - min_free_kbytes
@@ -492,6 +493,26 @@ warnings produced by allocations made while profiling is disabled and freed
 when it's enabled.
 
 
+memfd_write_seal_mapped
+=======================
+
+Controls whether ``F_SEAL_WRITE`` can be added to a memfd with file pages
+mapped into page tables (legacy).
+
+In the default mode (0), references from page-table mappings can make
+``F_SEAL_WRITE`` fail with ``EBUSY``, just like references from other kernel
+subsystems or DMA. File mappings without populated page tables do not
+prevent write sealing.
+
+Setting this to the legacy mode (1) permits write sealing with page-table
+mappings, but allows for some race conditions that can permit other kernel
+subsystems or DMA to modify file content after write-sealing through page
+references obtained before write-sealing.
+
+Shared mappings that can be made writable always prevent write sealing,
+even without populated page tables.
+
+
 memory_failure_early_kill
 =========================
 
diff --git a/mm/memfd.c b/mm/memfd.c
index 9eda4c3eeaca5..d70f43f439e6e 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -10,10 +10,12 @@
 #include <linux/vfs.h>
 #include <linux/pagemap.h>
 #include <linux/file.h>
+#include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/sched/signal.h>
 #include <linux/khugepaged.h>
 #include <linux/syscalls.h>
+#include <linux/sysctl.h>
 #include <linux/hugetlb.h>
 #include <linux/shmem_fs.h>
 #include <linux/memfd.h>
@@ -30,16 +32,29 @@
 #define MEMFD_TAG_PINNED        PAGECACHE_TAG_TOWRITE
 #define LAST_SCAN               4       /* about 150ms max */
 
+static int sysctl_memfd_write_seal_mapped __read_mostly;
+
 static bool memfd_folio_has_extra_refs(struct folio *folio)
 {
+	int expected_ref_count;
+
 	/*
-	 * Use the precise pincount where available to avoid racy refcount
-	 * comparisons.
+	 * Relevant with memfd_write_seal_mapped=1 only: use precise pincount
+	 * where available to avoid more races.
 	 */
 	if (folio_has_pincount(folio) && folio_maybe_dma_pinned(folio))
 		return true;
 
-	return folio_ref_count(folio) != folio_expected_ref_count(folio);
+	/*
+	 * Only allow page-cache references by default: disallow any page
+	 * table mappings, as they are not stable.
+	 */
+	if (READ_ONCE(sysctl_memfd_write_seal_mapped))
+		expected_ref_count = folio_expected_ref_count(folio);
+	else
+		expected_ref_count = folio_nr_pages(folio);
+
+	return folio_ref_count(folio) != expected_ref_count;
 }
 
 static void memfd_tag_pins(struct xa_state *xas)
@@ -527,3 +542,24 @@ SYSCALL_DEFINE2(memfd_create,
 	fd_flags = (flags & MFD_CLOEXEC) ? O_CLOEXEC : 0;
 	return FD_ADD(fd_flags, memfd_alloc_file(name, flags));
 }
+
+#ifdef CONFIG_SYSCTL
+static const struct ctl_table memfd_sysctl_table[] = {
+	{
+		.procname	= "memfd_write_seal_mapped",
+		.data		= &sysctl_memfd_write_seal_mapped,
+		.maxlen		= sizeof(sysctl_memfd_write_seal_mapped),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+};
+
+static int __init memfd_sysctl_init(void)
+{
+	register_sysctl_init("vm", memfd_sysctl_table);
+	return 0;
+}
+subsys_initcall(memfd_sysctl_init);
+#endif

-- 
2.43.0


