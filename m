Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03642606A33D
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xwRWhxda
Received: by kanga.kvack.org (Postfix)
	id 061096B05B3; Sat, 21 Nov 2026 21:48:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2D246B05B4; Sat, 21 Nov 2026 21:48:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69E16B05B5; Sat, 21 Nov 2026 21:48:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B43DC6B05B3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:48:07 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2DBBBC063C
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:48:07 +0000 (UTC)
X-FDA: 85461220614.12.6397527
Received: from mta0.migadu.com (out-201.mta0.migadu.com [91.218.175.201])
	by imf23.hostedemail.com (Postfix) with ESMTP id 333BF140002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:48:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xwRWhxda;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.201 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795315685;
	b=FS0AraUkPTSYTWtfTnhs1MnbdObJRxX+gk3TSTPejz7vp3CnfpHryuuk9eUbaAz8XIf/kR
	ZYcc8y1wES3HjQ260IIXORhu8E3Gmt0FhEkIvcFyDjASmH66FZJzQkc5W5EluXe06CrWGR
	PCj9TjKZ+LuJZZkdIEayoYto02TT1Hs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795315685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93KEZZm79T4K4z1XzJKlBY4GniO+4cdR8lKTt2J+MH4=;
	b=ZjaQlltFuwDs5CRsBu0+OmQKZU+jqhOcnA7CzpEO84jAmRUVF6X1wq7SqDoylHySXgmbyO
	CpVeW6mHcdYJ3mbdYcY07PoRe/uOcYAg0WwAbwXllHF/mrhC45/AIZJ/EaZhRDCjkCa7/a
	6dzMOqDTpHMTWQM8gZn7qrtfGaqbe7o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xwRWhxda;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.201 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Snj41/CC0oxxSA8iI87cvSw/qxupw/kfZbBBp8fjQq4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795315683; v=1; x=1795920483;
 b=xwRWhxdaIy107ah3iAY22Gu7XWqiG9ljdHQHoHNTkKyPS6wytCpH7vUhJ+wqUKO4anH7S8fF
 nm91CScm9w736dGPnvxhZ4bk0nIvbMpXwiAO1OVuAqbdfcwLbMa/23d7byVPABMhe171wUKZbqj
 iXVmrBuFJN+SWzB1QXZAaP6Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 47c6b318c025fda0;
	Sun, 22 Nov 2026 02:48:03 +0000
X-Mizu-Trace-ID: 47c6b318c025fda0
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/7] mm, fs: handle memory.high overage in buffered reads and writes
Date: Sat, 21 Nov 2026 18:47:33 -0800
Message-ID: <20261122024737.2741569-4-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261122024737.2741569-1-shakeel.butt@linux.dev>
References: <20261122024737.2741569-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 333BF140002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: ey8zmmxheibg3uy79sesgi7htjdhqf8x
X-HE-Tag: 1795315684-38268
X-HE-Meta: U2FsdGVkX1/QCRQKSpZW36XKs5rMY6316k9SH3qdlR9KQyNiPEV8MJu0coynPW1yeg7Vz18QRIow+A0OpWsqZ9dZAQ95FRr9iY0Qzww4PeGzOaKA/dyDUVmlNCOF1YN3TjtW/7mzYE5tw6F0MKtnmikJ095P/7z3OF+iZadB+j5+Oq/3oEJkzREFS5UrwBncjVVWX1mAihZ8c5qASJaRf5DQqnJpGLXyEmqHww2i70tmmAw8d3RRInbOe0AXNIWg1gBtR07s3ZcPbRk5mKnP6OTjsifiZyct02aRWnrtVb1w1csvJrTDUdjwx5c6pGQlvSFG56KRHKps6IVzsBAKVWAvWJCz+cKVXh9PCemrKXk1zGPEhSbmeKQ4MB5csL9aCH8G+hwfGJXw+AoqMyfqdn20QW7tBbjF5vTfz6NCkE+75nnUHZwtuBCY6p16fymO83aNEgSmC8O9OAIpfSRZ1nr8k0dl/tWWp4vsjLe8fCbns/DILiJKE9RAVfyzA1+J44GPM7VmxiI/N3tAGM+vENEvo+LsgkxUBqENVs1CGD5oe/UeEJK5MXiyfA2xGHTfhaGyKomE0qoJKQAWlaZvITRZBZX5cnG5LiVfl041VRMGimEFSF4m5pWR3IrZWcxMpgdmciycflMVuR7CvMgkSiYdlrDUzDRygCftWGwGeRMVia9YfANJ3KhmnzzRcCGDlk08JPo/DlD91dSgBQX2bQeW9bOyiM1Sd5IE9doEWRFRBxWLfDrqmDZXD3M7NWZfs0oNbZGJ6gkI9JRxjfbPlvIBbknZd9A1TMWmDmIIRPUpviWWwSLcSpARZ+uPKojj2wkZpfbabmrA1QPoq56AJ5dk21MG+3XadRQiYkDh2lr3HXWGnMfSKcoiifVPom/piHQqR8UYzl4c/HT34g3GD4cq0bz2LzKaJn96x/WLSHE13W+SWWWmTsx9IwaRKd09PQQK6x4JA5N6NExoElu
 0i27pR3P
 9jraTH997Nkn3dxPS4ba/FyztDA91oq8o2GCH0l2w0R1ctdWcx7Mk76vkKzwJV2nJBoC8X5lSTUOEHuhpeqpI09C6twE4GyDrmIf6wiqol0idhoUg9bvgGkcEK/xdMf36RSsvC6HJRqe4DynDWTp31HO+e5mgdHJt1VyHbT83x8pAoEE9WyBIhu3iBIZA89XqKT7QjZG426xh45vI2HIfaS9pu8LH7V+y4DO64wowHrJJm0UrGfeYKiD0YPnPfuZ2z7uJmxElpK6g9BxlIGcJ21Xs8hL0ujDlq37XZUZ+i24I/lnyzQyQfaw33d7VWS65FO3NzoP1jd60oHK+1dNF9X62mlvx5keNMGxtXiYBiYvcxtaBH1LGj7vjlu1ZWy1iNcg7Xtmo0ImospBRlJ4LkyjvAXuPvpYybgIDyhwVCHFascEsX2P3AMjhGKUG4BIO/nSY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A buffered read or write can copy almost 2GiB in one call. A write
charges the page cache it fills. Dirty throttling limits only the dirty
part, and does nothing on tmpfs and memfd, whose bdi has no
BDI_CAP_WRITEBACK. A read charges the page cache it reads, and the
anonymous pages it faults in when the user buffer is untouched, which
can't be reclaimed without swap. Today the charge path throttles these
calls for memory.high, except huge tmpfs pages and THP faults on the
user buffer, whose charges can't block under the default defrag
setting.

A later patch stops enforcing memory.high in the charge path, where
the task may hold locks other tasks need. Handle the overage in the
copy loops instead:

- generic_perform_write() and iomap_write_iter(): next to the dirty
  throttling call.
- btrfs_buffered_write(): between ranges. btrfs has its own loop, which
  the other two hooks don't cover.
- filemap_read(): after each folio is copied. Once per batch isn't
  enough, as a batch of large folios can hold tens of MiB.

Writers hold the inode's i_rwsem there, and dirty throttling already
sleeps under it. Two cases hold more: splice() from a pipe also holds
the pipe's lock, and gfs2 holds the resource group and quota glocks in
writes that allocate, which other writers to that resource group wait
for, on any node. The charge path sleeps with all of these locks today,
plus those taken in write_begin(). In btrfs, copy_one_range() has
already released its space reservation or handed it to delalloc, and
dropped the snapshot lock of a NOCOW write.

Most readers hold no locks. XFS, NFS and netfs hold the file's lock
shared, and gfs2 and ocfs2 a cluster lock, so a writer to that file
waits while a reader is throttled, as it does today. filemap_read()
keeps its folio batch referenced while the task is throttled. If it
dropped the batch, reclaim could free the folios not copied yet, and
they would be read again: in a VM, a cold 256M read under
memory.high=64M then read five to nine times as much from disk for the
same progress. After the sleep, it reads i_size and
mapping_writably_mapped() again.

IOCB_NOWAIT writes and IOCB_NOWAIT or IOCB_WAITQ reads skip the hook:
io_uring issues them with ctx->uring_lock held. Reads into kernel
buffers skip it too: kernel_read() callers may hold other locks, like
cred_guard_mutex in execve(). Reclaim uses the gfp mask of the
allocation that follows, so filesystems that clear __GFP_FS get
GFP_NOFS reclaim.

Without these hooks, once the synchronous step is gone, a 256M write
under memory.high=64M in a VM reaches 257-264M on ext4, XFS and btrfs
instead of 64-67M.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 fs/btrfs/file.c        |  9 +++++++++
 fs/iomap/buffered-io.c |  9 +++++++++
 mm/filemap.c           | 31 +++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f978c6524aa0..d5a00a26fba6 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -18,6 +18,7 @@
 #include <linux/uio.h>
 #include <linux/iversion.h>
 #include <linux/fsverity.h>
+#include <linux/memcontrol.h>
 #include "ctree.h"
 #include "direct-io.h"
 #include "disk-io.h"
@@ -1320,6 +1321,7 @@ ssize_t btrfs_buffered_write(struct kiocb *iocb, struct iov_iter *iter)
 	struct file *file = iocb->ki_filp;
 	loff_t pos;
 	struct inode *inode = file_inode(file);
+	const gfp_t high_gfp = btrfs_alloc_write_mask(inode->i_mapping);
 	struct extent_changeset *data_reserved = NULL;
 	size_t num_written = 0;
 	ssize_t ret;
@@ -1356,6 +1358,13 @@ ssize_t btrfs_buffered_write(struct kiocb *iocb, struct iov_iter *iter)
 			break;
 		pos += ret;
 		num_written += ret;
+		/*
+		 * A large write can charge a lot before the task returns to
+		 * userspace. Handle memory.high overage between ranges, where
+		 * btrfs holds only the inode lock.
+		 */
+		if (!nowait)
+			mem_cgroup_over_high_throttle(high_gfp);
 		cond_resched();
 	}
 
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 6d843b168d5f..861aa600b3af 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -7,6 +7,7 @@
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
 #include <linux/swap.h>
+#include <linux/memcontrol.h>
 #include <linux/migrate.h>
 #include <linux/fserror.h>
 #include <linux/fsverity.h>
@@ -1193,6 +1194,7 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 	struct address_space *mapping = iter->inode->i_mapping;
 	size_t chunk = mapping_max_folio_size(mapping);
 	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
+	gfp_t high_gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
 
 	do {
 		struct folio *folio;
@@ -1212,6 +1214,13 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 		if (unlikely(status))
 			break;
 
+		/*
+		 * A large write can charge a lot before the task returns to
+		 * userspace. Handle memory.high overage here too.
+		 */
+		if (!(iter->flags & IOMAP_NOWAIT))
+			mem_cgroup_over_high_throttle(high_gfp);
+
 		if (bytes > iomap_length(iter))
 			bytes = iomap_length(iter);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index dc0ceaa58a0f..b0cefe71c1fd 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2822,6 +2822,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 	struct file_ra_state *ra = &filp->f_ra;
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
+	gfp_t high_gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
 	struct folio_batch fbatch;
 	int i, error = 0;
 	bool writably_mapped;
@@ -2913,6 +2914,28 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 				error = -EFAULT;
 				break;
 			}
+
+			/*
+			 * A large read can charge a lot, for the page cache and
+			 * for faulting in the buffer. Handle memory.high
+			 * overage after each folio, as a batch of large folios
+			 * can be big. Keep the batch, or reclaim could free
+			 * folios not copied yet and they would be read again.
+			 * The file may change meanwhile, so check its size and
+			 * mappings again. Reads into kernel buffers skip this:
+			 * their callers may hold other locks.
+			 */
+			if (user_backed_iter(iter) &&
+			    !(iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ)) &&
+			    mem_cgroup_over_high_pending()) {
+				mem_cgroup_handle_over_high(high_gfp);
+				isize = i_size_read(inode);
+				if (iocb->ki_pos >= isize)
+					break;
+				end_offset = min_t(loff_t, isize,
+						   iocb->ki_pos + iter->count);
+				writably_mapped = mapping_writably_mapped(mapping);
+			}
 		}
 put_folios:
 		for (i = 0; i < folio_batch_count(&fbatch); i++) {
@@ -4385,6 +4408,7 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
 	struct address_space *mapping = file->f_mapping;
 	const struct address_space_operations *a_ops = mapping->a_ops;
 	size_t chunk = mapping_max_folio_size(mapping);
+	gfp_t high_gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
 	long status = 0;
 	ssize_t written = 0;
 
@@ -4401,6 +4425,13 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
 		bytes = min(chunk - offset, bytes);
 		balance_dirty_pages_ratelimited(mapping);
 
+		/*
+		 * A large write can charge a lot before the task returns to
+		 * userspace. Handle memory.high overage here too.
+		 */
+		if (!(iocb->ki_flags & IOCB_NOWAIT))
+			mem_cgroup_over_high_throttle(high_gfp);
+
 		if (fatal_signal_pending(current)) {
 			status = -EINTR;
 			break;
-- 
2.53.1-Meta


