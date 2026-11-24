Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 802B9606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EutnZELA
Received: by kanga.kvack.org (Postfix)
	id 5007A6B0831; Tue, 24 Nov 2026 13:40:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0CB6B0833; Tue, 24 Nov 2026 13:40:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A546B0834; Tue, 24 Nov 2026 13:40:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 05C8E6B0831
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:40:55 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12787C030D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:40:55 +0000 (UTC)
X-FDA: 85470879270.02.0BDA452
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7707720006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:40:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EutnZELA;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795545653;
	b=Ew8rsLFOK/wLak9rH5nm8o2VBB/zRiPaAw8PaeW+wgsDtbYIkxynP5ySgF2TjWIQjNNFMc
	VIZKWuHkrJo1RE1eOC4Q4kViEvZTAJLds5zTntSm1kZfQXtwDqX5P/wrrt05yXOW89DK6U
	DG/S3RtlrxOkg6Akru2ljen3s+AgiLI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795545653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rI9Ljt1hZCdQWyBk4/FIgQxeJTvHvzUdhg3L9ItkrWQ=;
	b=GV38TTzVbUYDz180BI5k6v+pj9jwdMMsS9pYca2Fh/CuUyuwkhYUThL9AqWxesGIlZmhKW
	6jzo3kkAMFztQ7EWM48x2HIA9Qia0uwH/tVUpN8E+TO+ag6cOLKNMhU/8T/8WLbsHpeMZa
	fssCuo6MZIXreLnpCh+Dep07/hKa9U0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EutnZELA;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E57C5613FD;
	Tue, 24 Nov 2026 18:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D5F1F000C6;
	Tue, 24 Nov 2026 18:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795545652;
	bh=rI9Ljt1hZCdQWyBk4/FIgQxeJTvHvzUdhg3L9ItkrWQ=;
	h=From:To:Cc:Subject:Date;
	b=EutnZELAWvdU6/l50m2Cr97OQ+mkxOIX0HVOC7RfR5z+j4+JSAR/1MseBis20mMjL
	 yG/jmcoHZ/l3AqegFm7uyz8AVenPQfyQUx6pANpQcS1w9jkIGmls9u6SEMmt7Z/QGp
	 fTfgQMwOfBv3zAhjfc9UZ852rcxLfzogazIFyeDVxl9u6DiGeNHq0pGJKIrC6Ysl91
	 uf/uDAyhqu/FD36K9VdvPoSxCsdKT4v+U6o/Q64SnQ4ivtSZkv8IE3b0m6loH1wycU
	 uEG73pdoWxwLwxD6xIRGDkbRX+2IGj+7+4pDL3LB9MFdfxdb18vnVdzHEOGfyCT+lN
	 W3pEMSQfrynkg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4] mm/memfd_luo: don't use memfd_pin_folios()
Date: Tue, 24 Nov 2026 18:40:41 +0000
Message-ID: <20261124184042.1823277-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7707720006
X-Stat-Signature: 64igsobrx8ndod8o9nhgtht7h6sbksqp
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795545653-807476
X-HE-Meta: U2FsdGVkX1+PJZ8Y5jacNv+sKFsyLMftDjJfhABx/PdFaoV+u+0mxchmdCtkZ0BxKYpU1svUtPdXnL7UG6yA+hAdwygyk0TpggJuzQmaDAQs6vbO2kJbXVOqdH/MQK4iGRGkFK8+ZUq+5VTSKsL03htlf1kmP3KPEW63aS7WqurP2Q+Us/IS/eio/MR5p4qFk55hfXulgwU1I7rQY3Hx/PWILTGKd7/V48FreyQtd0/yBCaQKs1dQha6gmaA3CU8knZDfCuUOA98sKMdl6+2qujiW+jhmguu6n3cnfTAW428bt0FxQLZf2f3asvZPSUWsH5f9VkUfwRpI85kujWbB1//0USUl6+4fCSlygT4+loyKfWtz0dU7m7sN+5R5yzjN2ic/wdfmlamAg8vNRcT9ILeRLGkkka+B9/HOHV/7RQaDS778p2TpwpUp7zfMQm8VoHJJZyOeABmcE1lgGsCxlZosvSZFjFJPXx45ffPWAR+gNeQ4nAMQ92be234eDrOCeAk3wgJ7I3jJpv5m11YSYGavI8ZmgRWUK7tSWCwvxcogzflEHP1SEKDbMOf/b2Bf2n0PMnB5XUwaIp3zHU2fACQUf1zt102iaWMbLWrbpjj+xo0aDRuMu1U1cs08m8uwSFTfqXd2Aw4rJD+2cuocMV4shj6D9C6Ekd37CI+J4XSUcEoMDvVUjDm2AfsD8kKvVa2ysPemQFzNrLixO4Gps4B+SlKuI8hkZbyL7VNV9GC7qUgfHQErYqxqtuvKJUPSO+S+GAmMoSHFNMJxwRObHcBSQIK3kt0ibcaXUzJkXmQEtn9Zwx61LtxTdLHXgomYJYHlmv7SYeJxBdl5jg+BOvqelC/Fm0nV0YkYgEckNp2e7jjR9rTg67Qa3N/ey/F+yJ3szFdLxlOppQnHQl+NfU8HtjvaEY3VNRi4XB0VYn6KBd6k4OrVm0DD6Uy64Q1+u0CVjLai9iOPZzrSy5
 7t1yzfTR
 +ULTPV1+2MoDFUH1/rR39NXZcSc38GlHYUNi4b0xZGkudCOPgHWv8AzGvnopXDfsG3OxLWFrJHG7/W4FD7puvMFlDdqrLhlYSGPRo5poH6rsEG1kY1vOMFw0k5KcpYIbcifkJEbbuW9V01SagshRTfu1qylzfViXZvXt/tWpCd0FdJEV/nDg9I7gj074xnQEwHPDpQ86sLCInF/JuhWKkXBajNjA200VdXSTGijx6cf/1br40D2FJF6MmHow2YItJvqEH7mRiWeRkw5lcoKLHrDLJ3MpnQUMo0a8lT83Jo7RD6mJ6uNzKTiJ4Rk/1hqJn27cuHztN9/w6ygDACjxbqSbbdwwh0tgQ/EbEQ7tNkRMQDEKNA7cZe/5Yq+Z9qxm/71wzySIHbvqtl6Bxo39vYbtkDsvplO5i+CdS1wNsX10AQ1ytJs8NBmtCPSGsQZUurhBjjnY/mwL5yp9oYFYZ3pZilLoV2LaAf0t1S9LLaiTR9mxsAaroHTU7rC4dedyS1djxiYdKFnR2yNr9W/0UNQ0P6THyVxDaSJkNRl5nMAbCFjjQ3p63dXpS7ccH9NpU5UBGMxr5nUiHFWTEO4GYvmBQNKVEqEU8W+v7JAcUdtWe4ig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

memfd_luo takes a snapshot of the folios in the file's mapping. To make
sure the snapshot does not go out of sync, it pins the folios in the
file via memfd_pin_folios(). The pinning also migrates the folios out of
MIGRATE_MOVABLE to make sure doesn't land in KHO boot memory or in a CMA
region.

memfd_pin_folios() does not lock the folios. So it can race with
shmem_writeout(). A folio returned by memfd_pin_folios() might already
be in swap cache. This happens to work but is fragile. memfd_luo looks
at folio flags and index on a folio that isn't in the memfd's page
cache.

In addition, memfd_pin_folios() needs the caller to allocate an array of
folios. memfd_luo does not really need that since it will vmalloc
folios_ser and store the information there anyway. The folios array is
unnecessary overhead.

Finally, memfd_pin_folios() fills in holes in the memfd. This makes
preserving sparse memfds very expensive in both compute and memory.
While this patch doesn't yet stop filling in the holes, it sets up the
infrastructure to make it simpler.

Fix all this by walking the page cache directly using shmem_get_folio()
with SGP_CACHE. This returns a locked folio with an elevated refcount.
memfd_luo holds that reference until the memfd is unpreserved. This
blocks compaction, migration, etc.

There is still a need to migrate folios out of MIGRATE_MOVABLE page
blocks. This is because those might be CMA or KHO scratch. memfd_luo
will hold a longterm reference to the folios so it will block migration
in that pageblock. Introduce memfd_luo_migrate_folio() to do this.

Also factor out folio unpreservation logic into memfd_luo_put_folios()
and use it from memfd_luo_unpreserve_folios() and from error paths in
memfd_luo_preserve_folios().

Since shmem_get_folio() always returns uptodate folios, drop the folio
zeroing logic.

This change also improves preservation performance, shown in the table
below.

|------------------+----------+------------+-------|
| memfd            | baseline | this patch | delta |
|------------------+----------+------------+-------|
| 4K pages, 32 GiB | 748 ms   | 600 ms     |  -20% |
| THP, 4 GiB       | 0.59 ms  | 0.59 ms    |    0% |
| THP, 16 GiB      | 2.99 ms  | 2.61 ms    |  -13% |
| THP, 32 GiB      | 4.83 ms  | 5.21 ms    |   +8% |
| sparse, 32 GiB   | 8695 ms  | 7269 ms    |  -16% |
|------------------+----------+------------+-------|

Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

---

The diff is unfortunately hard to read. It would be easier to review the
patch by applying it and looking at the final code.

This patch is picked from a separate series I sent [0]. It is more or
less an independent change. It fixed a race for that series so I added
it there, but since that series might take longer to go through, I think
it is useful to take this patch separately.

[0] https://lore.kernel.org/all/20261027173031.763213-2-pratyush@kernel.org/

Changes since v3:

- Fix memfd_luo_get_folio() returning -EBUSY without looking up the folio
  again when the last migration attempt succeeds.

Changes since v2:

- Reword the comments on memfd_luo_migrate_folio(), memfd_luo_get_folio()
  and the allocation comment in memfd_luo_preserve_folios() so they no
  longer say folios are "held until the next kernel". Instead, say that
  preservation holds a longterm reference on them.
- Use a bounded for loop in memfd_luo_get_folio() instead of an open
  ended one with a separate busy retry counter.
- Collect tags.

Changes since v1:

- Add memfd_luo_get_folio() which combines shmem_get_folio() and the
  migration logic.
- Collect tags.
- Rebase to v7.4-rc1.

---
 mm/memfd_luo.c | 313 +++++++++++++++++++++++++++++++------------------
 1 file changed, 197 insertions(+), 116 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 6b68220275eb..38584ecfa70b 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -77,26 +77,168 @@
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/memfd.h>
 #include <linux/liveupdate.h>
+#include <linux/migrate.h>
+#include <linux/sched/mm.h>
+#include <linux/sched/signal.h>
 #include <linux/shmem_fs.h>
+#include <linux/swap.h>
 #include <linux/vmalloc.h>
 #include <linux/memfd.h>
 #include <uapi/linux/memfd.h>
 
 #include "internal.h"
 
+static void memfd_luo_put_folios(const struct memfd_luo_folio_ser *folios_ser,
+				 u64 nr_folios)
+{
+	u64 i;
+
+	for (i = 0; i < nr_folios; i++) {
+		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
+		struct folio *folio;
+
+		if (!pfolio->pfn)
+			continue;
+
+		folio = pfn_folio(pfolio->pfn);
+
+		kho_unpreserve_folio(folio);
+		folio_put(folio);
+	}
+}
+
+/* How many times to try migrating a folio that is not longterm pinnable. */
+#define MEMFD_LUO_MIGRATE_RETRIES	3
+
+/*
+ * Preservation holds a longterm reference on the folio. This would block
+ * migration in ZONE_MOVABLE or CMA. Move it out.
+ *
+ * Must be called with folio unlocked. Drops the reference to folio. The caller
+ * must look it up again.
+ *
+ * Returns 0 on success, -EBUSY if the folio could not be isolated (e.g.
+ * because someone else has it isolated right now), or -ENOMEM if migration
+ * failed.
+ */
+static int memfd_luo_migrate_folio(struct folio *folio)
+{
+	struct migration_target_control mtc = {
+		.nid = NUMA_NO_NODE,
+		/* Not movable, so the target is neither in ZONE_MOVABLE nor CMA. */
+		.gfp_mask = GFP_USER | __GFP_NOWARN,
+		.reason = MR_LONGTERM_PIN,
+	};
+	LIST_HEAD(source);
+	bool isolated;
+
+	/* Flush per-CPU LRU batches holding the folio so isolation works. */
+	lru_cache_drain_for_folio(folio, 1, NULL);
+	isolated = isolate_folio_to_list(folio, &source);
+	/* Isolation holds its own reference. */
+	folio_put(folio);
+	if (!isolated)
+		return -EBUSY;
+
+	if (migrate_pages(&source, alloc_migration_target, NULL,
+			  (unsigned long)&mtc, MIGRATE_SYNC, MR_LONGTERM_PIN,
+			  NULL)) {
+		putback_movable_pages(&source);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/*
+ * Look up the folio at @index, allocating it if needed. Preservation holds a
+ * longterm reference on the folio, so folios that are not longterm pinnable are
+ * migrated out first, giving up after a few attempts.
+ *
+ * On success, returns 0 with *@foliop locked and holding a reference.
+ */
+static int memfd_luo_get_folio(struct inode *inode, pgoff_t index,
+			       struct folio **foliop)
+{
+	int err, retries = 0;
+	struct folio *folio;
+
+	for (;;) {
+		err = shmem_get_folio(inode, index, 0, &folio, SGP_CACHE);
+		if (err)
+			return err;
+
+		if (likely(folio_is_longterm_pinnable(folio)))
+			break;
+
+		folio_unlock(folio);
+
+		if (retries == MEMFD_LUO_MIGRATE_RETRIES) {
+			folio_put(folio);
+			return -EBUSY;
+		}
+
+		err = memfd_luo_migrate_folio(folio);
+		/* Someone else might have it isolated, retry a bit. */
+		if (err && err != -EBUSY)
+			return err;
+
+		retries++;
+	}
+
+	*foliop = folio;
+	return 0;
+}
+
+static int memfd_luo_preserve_folio(struct folio *folio,
+				    struct memfd_luo_folio_ser *pfolio)
+{
+	int err;
+
+	err = kho_preserve_folio(folio);
+	if (err)
+		return err;
+
+	/*
+	 * A dirty folio is one which has been written to. A clean folio
+	 * is its opposite. Since a clean folio does not carry user
+	 * data, it can be freed by page reclaim under memory pressure.
+	 *
+	 * Saving the dirty flag at prepare() time doesn't work since it
+	 * can change later. Saving it at freeze() also won't work
+	 * because the dirty bit is normally synced at unmap and there
+	 * might still be a mapping of the file at freeze().
+	 *
+	 * To see why this is a problem, say a folio is clean at
+	 * preserve, but gets dirtied later. The pfolio flags will mark
+	 * it as clean. After retrieve, the next kernel might try to
+	 * reclaim this folio under memory pressure, losing user data.
+	 *
+	 * Unconditionally mark it dirty to avoid this problem. This
+	 * comes at the cost of making clean folios un-reclaimable after
+	 * live update.
+	 */
+	folio_mark_dirty(folio);
+
+	pfolio->pfn = folio_pfn(folio);
+	pfolio->flags = MEMFD_LUO_FOLIO_DIRTY | MEMFD_LUO_FOLIO_UPTODATE;
+	pfolio->index = folio->index;
+
+	return 0;
+}
+
 static int memfd_luo_preserve_folios(struct file *file,
 				     struct kho_vmalloc *kho_vmalloc,
 				     struct memfd_luo_folio_ser **out_folios_ser,
 				     u64 *nr_foliosp)
 {
+	struct memfd_luo_folio_ser *folios_ser, *shrunk;
 	struct inode *inode = file_inode(file);
-	struct memfd_luo_folio_ser *folios_ser;
-	unsigned int max_folios;
-	long i, size, nr_pinned;
-	struct folio **folios;
-	int err = -EINVAL;
-	pgoff_t offset;
-	u64 nr_folios;
+	u64 nr_folios = 0, max_folios;
+	unsigned int pin_flags;
+	pgoff_t index = 0, end;
+	int err;
+	loff_t size;
 
 	size = i_size_read(inode);
 	/*
@@ -113,98 +255,65 @@ static int memfd_luo_preserve_folios(struct file *file,
 	 * Guess the number of folios based on inode size. Real number might end
 	 * up being smaller if there are higher order folios.
 	 */
-	max_folios = PAGE_ALIGN(size) / PAGE_SIZE;
-	folios = kvmalloc_objs(*folios, max_folios);
-	if (!folios)
+	end = DIV_ROUND_UP_ULL(size, PAGE_SIZE);
+	max_folios = end;
+	folios_ser = vmalloc_array(max_folios, sizeof(*folios_ser));
+	if (!folios_ser)
 		return -ENOMEM;
 
 	/*
-	 * Pin the folios so they don't move around behind our back. This also
-	 * ensures none of the folios are in CMA -- which ensures they don't
-	 * fall in KHO bootmem. It also moves swapped out folios back to memory.
+	 * Preservation holds a longterm reference on the folios, so keep newly
+	 * allocated ones out of ZONE_MOVABLE and CMA -- which also ensures they
+	 * don't fall in KHO bootmem. Existing ones are migrated below.
 	 *
-	 * A side effect of doing this is that it allocates a folio for all
-	 * indices in the file. This might waste memory on sparse memfds. If
-	 * that is really a problem in the future, we can have a
-	 * memfd_pin_folios() variant that does not allocate a page on empty
-	 * slots.
+	 * A side effect of this is that it allocates a folio for all indices in
+	 * the file. This might waste memory on sparse memfds. If that is really
+	 * a problem in the future, this loop can be taught to skip empty slots.
 	 */
-	nr_pinned = memfd_pin_folios(file, 0, size - 1, folios, max_folios,
-				     &offset);
-	if (nr_pinned < 0) {
-		err = nr_pinned;
-		pr_err("failed to pin folios: %d\n", err);
-		goto err_free_folios;
-	}
-	nr_folios = nr_pinned;
+	pin_flags = memalloc_pin_save();
+	while (index < end) {
+		struct folio *folio;
 
-	folios_ser = vcalloc(nr_folios, sizeof(*folios_ser));
-	if (!folios_ser) {
-		err = -ENOMEM;
-		goto err_unpin;
-	}
+		cond_resched();
 
-	for (i = 0; i < nr_folios; i++) {
-		struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
-		struct folio *folio = folios[i];
+		if (fatal_signal_pending(current)) {
+			err = -EINTR;
+			goto err_restore;
+		}
 
-		err = kho_preserve_folio(folio);
+		if (WARN_ON_ONCE(nr_folios >= max_folios)) {
+			err = -EINVAL;
+			goto err_restore;
+		}
+
+		err = memfd_luo_get_folio(inode, index, &folio);
 		if (err)
-			goto err_unpreserve;
-
-		folio_lock(folio);
-
-		/*
-		 * A dirty folio is one which has been written to. A clean folio
-		 * is its opposite. Since a clean folio does not carry user
-		 * data, it can be freed by page reclaim under memory pressure.
-		 *
-		 * Saving the dirty flag at prepare() time doesn't work since it
-		 * can change later. Saving it at freeze() also won't work
-		 * because the dirty bit is normally synced at unmap and there
-		 * might still be a mapping of the file at freeze().
-		 *
-		 * To see why this is a problem, say a folio is clean at
-		 * preserve, but gets dirtied later. The pfolio flags will mark
-		 * it as clean. After retrieve, the next kernel might try to
-		 * reclaim this folio under memory pressure, losing user data.
-		 *
-		 * Unconditionally mark it dirty to avoid this problem. This
-		 * comes at the cost of making clean folios un-reclaimable after
-		 * live update.
-		 */
-		folio_mark_dirty(folio);
-
-		/*
-		 * If the folio is not uptodate, it was fallocated but never
-		 * used. Saving this flag at prepare() doesn't work since it
-		 * might change later when someone uses the folio.
-		 *
-		 * Since we have taken the performance penalty of allocating,
-		 * zeroing, and pinning all the folios in the holes, take a bit
-		 * more and zero all non-uptodate folios too.
-		 *
-		 * NOTE: For someone looking to improve preserve performance,
-		 * this is a good place to look.
-		 */
-		if (!folio_test_uptodate(folio)) {
-			folio_zero_range(folio, 0, folio_size(folio));
-			flush_dcache_folio(folio);
-			folio_mark_uptodate(folio);
-		}
+			goto err_restore;
 
+		err = memfd_luo_preserve_folio(folio, &folios_ser[nr_folios]);
+		index = folio_next_index(folio);
 		folio_unlock(folio);
-
-		pfolio->pfn = folio_pfn(folio);
-		pfolio->flags = MEMFD_LUO_FOLIO_DIRTY | MEMFD_LUO_FOLIO_UPTODATE;
-		pfolio->index = folio->index;
+		if (err) {
+			folio_put(folio);
+			goto err_restore;
+		}
+		nr_folios++;
 	}
+	memalloc_pin_restore(pin_flags);
+
+	/*
+	 * Free the unused tail so it doesn't get preserved. If vrealloc fails,
+	 * the folios_ser is still valid.
+	 */
+	shrunk = vrealloc(folios_ser, array_size(nr_folios, sizeof(*folios_ser)),
+			  GFP_KERNEL);
+	if (shrunk)
+		folios_ser = shrunk;
 
 	err = kho_preserve_vmalloc(folios_ser, kho_vmalloc);
 	if (err)
-		goto err_unpreserve;
+		goto err_put;
 
-	kvfree(folios);
 	*nr_foliosp = nr_folios;
 	*out_folios_ser = folios_ser;
 
@@ -215,15 +324,11 @@ static int memfd_luo_preserve_folios(struct file *file,
 	 */
 	return 0;
 
-err_unpreserve:
-	for (i = i - 1; i >= 0; i--)
-		kho_unpreserve_folio(folios[i]);
+err_restore:
+	memalloc_pin_restore(pin_flags);
+err_put:
+	memfd_luo_put_folios(folios_ser, nr_folios);
 	vfree(folios_ser);
-err_unpin:
-	unpin_folios(folios, nr_folios);
-err_free_folios:
-	kvfree(folios);
-
 	return err;
 }
 
@@ -231,26 +336,11 @@ static void memfd_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
 					struct memfd_luo_folio_ser *folios_ser,
 					u64 nr_folios)
 {
-	long i;
-
 	if (!nr_folios)
 		return;
 
 	kho_unpreserve_vmalloc(kho_vmalloc);
-
-	for (i = 0; i < nr_folios; i++) {
-		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
-		struct folio *folio;
-
-		if (!pfolio->pfn)
-			continue;
-
-		folio = pfn_folio(pfolio->pfn);
-
-		kho_unpreserve_folio(folio);
-		unpin_folio(folio);
-	}
-
+	memfd_luo_put_folios(folios_ser, nr_folios);
 	vfree(folios_ser);
 }
 
@@ -287,15 +377,6 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 	ser->pos = args->file->f_pos;
 	inode_size = i_size_read(inode);
 
-	/*
-	 * memfd_pin_folios() caps at UINT_MAX folios; refuse larger
-	 * files to avoid silently preserving only a prefix.
-	 */
-	if (DIV_ROUND_UP_ULL(inode_size, PAGE_SIZE) > UINT_MAX) {
-		err = -EFBIG;
-		goto err_free_ser;
-	}
-
 	ser->size = inode_size;
 	ser->seals = seals;
 

base-commit: 4209b08181c75ea02164832cd8f47526de28d40c
-- 
2.56.1.831.g720f3f5937-goog


