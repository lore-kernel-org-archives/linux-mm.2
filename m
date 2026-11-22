Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB428606A69F
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rgR3igk/
Received: by kanga.kvack.org (Postfix)
	id 3BC7D6B05B5; Sat, 21 Nov 2026 21:48:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395456B05B6; Sat, 21 Nov 2026 21:48:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D18B6B05B7; Sat, 21 Nov 2026 21:48:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9B076B05B5
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:48:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 755B216060F
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:48:08 +0000 (UTC)
X-FDA: 85461220656.06.DF53F68
Received: from mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id 91AE9C0003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:48:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="rgR3igk/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795315686;
	b=ZVMDjWzxShNPmKupoRqPnTbGebk4R5sZi+j0zUjhv8Ee9IKDdOdruAc/TU5oVldu3O17z5
	z/J7CciAybsyxlZrop5TVgpBNGwdlsheFJhT1pdk8xUA9eKpHg1R7LE7LDryWduFHHDfmM
	DGVlJI4ZF4fSxrZJnM1cLFvE3VByWAI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795315686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkxhsd+wNZ5decktFmYFGStmSBxY5/td+insSo0Xag0=;
	b=xFoF6m/5wFhoxdtXTkxz6nAazwU/GZFy58mKUvJCRBPacAxACA0UxLGM3qHKGuB+AULvJh
	PQkxPBp6xTYzWXaHSJfwNuvigknxRU+X3CCGawVUC/bFs2BIh4I4cMDcQaCOAskqZpOV6n
	18jmi/hVxrjg3kOQnCfDmtGrHYRq+1Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="rgR3igk/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fU97LFAIirxa+/rlTWHr0TmU8aBTzCwdMVuMHL65nxA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795315685; v=1; x=1795920485;
 b=rgR3igk/I/weVpqc719mO0amIqbu5Bush6VykTQXIVP7Hgc6xYXHbkpsGvoi0e8PXlKMmskc
 wQdTm2EqLYCt8t7wde+FHoBhXbwDaHyBuIBzk4FnIWu9L8GpEI68nbKF/y/Xtc3ZMBAXReQVpyE
 heYqth8DiLAG0CF6RyGa4ueA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7007ba29080ecc76;
	Sun, 22 Nov 2026 02:48:05 +0000
X-Mizu-Trace-ID: 7007ba29080ecc76
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
Subject: [RFC PATCH 4/7] mm/shmem: handle memory.high overage in fallocate and reads
Date: Sat, 21 Nov 2026 18:47:34 -0800
Message-ID: <20261122024737.2741569-5-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261122024737.2741569-1-shakeel.butt@linux.dev>
References: <20261122024737.2741569-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jrkuk9xieiwu8drxxzu4j68q5nu5cb33
X-Rspamd-Queue-Id: 91AE9C0003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795315686-127555
X-HE-Meta: U2FsdGVkX1/16bQaG/e8IOC54OA3yZRny5kUTFj2EGN3NRLkqwCeJgsGsDHcGfdeVFkKkQvWkIzXHyFHr5Vp752xRz9KslHV2n/exqXoY8p5k3Oq+z8KMyBw7ROvKteSrK6M6LKwW3Oc94ZOcuMiGwroU5mLLo+5SOllgp6rbqLuavyPRx7mFg6tdycPZHUyWAWNsFeYiJlh00nOjLLi3n9e9hBhhuzdyUGgMULrrER9qMHShMUOTVQT0aT9CAmUkxzzA7RHpOLJiyH3WTpS3R7Kb4xkWOi0pBEIYvvWDRDsGQnPgQkda/U7U7NpyvkpkWZDXtaKUWckXZudEZEEaLe3XzAQHuL9E3uWz0lawsC4617klu8qZJvnzLILLTRjVYvuiQQBch956GxOtG6LDTzDlH4hW2vBGEypaE3HJ1nIyojkipbdQh3mpI7pfuUMXzpQK9AyiSOI5VQ+marlG6yBvYLcNczkilpyG4gtY9DNds83u2fhXb5UDJfp+ELvAPIY2rp/k1/HzGo0CcfYyiLVRDE8pMKq8mhp5298IadhJkyGBOdOWH2kwjcYIbHFciRlN/0SF/CnxG1dMj0EFCrZHd0irYvjTEoFf1iYYES1+Tm7f1p6hOAAGWf+F/x8XN2x7X7bkaW01O0C7nSOsE71yXc1yQp3YaGtGYZdvZjF6g4Phw6h3UIcvLd9ANjZxG3SF7ptU8ttjLX+6YFfojRZN5DUoGH2VWcJr/BH/3XOsBIjL4qeHb22VUqQczWSWduGDhAAqNAzKKGk+R8HaD6P5BqjEAE9HeBQsVf9W2eyBmn85923oewJVa6XD7DbG+unhIrjxHnkakgyLj/2KjcRNhIch77pUmrEgYZFxMb4H/HtX0bfy/m2wJobLhzdjG0wzctz8lGPStmmUqeus6qv5ZLisJp5DEvBlORp5pOgfgZDV3qpZMzjEISBcvTvi5U31RbbfxsiPVWngGK
 V83FNij7
 5uusHJ1l52VzDrSaSKj60aGHs0a9bfQlGedOCS9ZleHDvURb+Z818xX0jNUBJ31le1HHe9vr+77qL+W436KDEU8GZSt1W+0d+ZxPeqmxAkUGBotHIZ61/7d/H8eaCd/b/9zhThLKrpwekyIMCacvB5ixIdgMURM7mvci7M+t7+Jh3mSHvxz8MVYV+IaAGqCmN5REuDqYzb0yIzY2upE14Q9MobcCvWZQ6UisSRHu7R8No0JVLix8lqF3GGLosQF7bnSex0KwUMB4OyMq7RjAH1mON4uFiIne5S1OMGnh15tKNDsr+soFSHJDeK9KIxVoSbkEXvdWP4LXazq/Fz5o6BUPVT9uMflIUuNotiQ9kflYgEUbZPTap/uZCyrANnY5hFJo/iGiKwlDXBlDET1pLrdgqcDzzyDXV3UcMnsT95OVKEU0OD4REeOzDwT0OAuMGw+od
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

fallocate() on tmpfs or memfd allocates the whole range in one call,
and a read can copy almost 2GiB, faulting in the user buffer and
swapping the file back in. Without swap, this memory can't be
reclaimed, and the internal mount behind memfd_create(),
MAP_SHARED|MAP_ANONYMOUS and SysV shm has no size limit. Today the
charge path throttles both for memory.high, except huge page charges,
which can't block under the default defrag setting. Writes go through
generic_perform_write(), which the previous patch covers.

A later patch stops enforcing memory.high in the charge path, where
the task may hold locks other tasks need. Handle the overage after each
fallocate iteration, where only inode_lock is held, and after each
folio a read copies, where no locks are held. This covers huge pages
too. Reclaim doesn't need inode_lock: shmem_writeout() reads i_private
under i_lock. As in filemap_read(), reads into kernel buffers and
IOCB_NOWAIT or IOCB_WAITQ reads skip it. Reclaim uses the mapping's gfp
constraint.

With swap, this reclaim finds the folios the fallocate added.
shmem_writeout() won't swap them out and counts each try in
nr_unswapped, and once there are more tries than new folios, the
fallocate fails with -ENOMEM. memory.high should throttle the call, not
fail it, so tries made by the fallocating task's own memory.high
reclaim don't count. Tries by other reclaim still count. In a VM with
swap, a 512M tmpfs fallocate under memory.high=64M fails with -ENOMEM 3
times out of 3 today with small pages, and would with huge pages too if
this reclaim's tries counted. With this patch it is throttled instead.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/shmem.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 951bb3c8f837..fad86c96170f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -110,6 +110,8 @@ struct shmem_falloc {
 	pgoff_t next;		/* the next page offset to be fallocated */
 	pgoff_t nr_falloced;	/* how many new pages have been fallocated */
 	pgoff_t nr_unswapped;	/* how often writeout refused to swap out */
+	/* set while the fallocating task handles memory.high overage */
+	struct task_struct *high_reclaimer;
 };
 
 struct shmem_options {
@@ -1918,10 +1920,13 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 			if (shmem_falloc &&
 			    !shmem_falloc->waitq &&
 			    index >= shmem_falloc->start &&
-			    index < shmem_falloc->next)
-				shmem_falloc->nr_unswapped += nr_pages;
-			else
+			    index < shmem_falloc->next) {
+				/* See the memory.high comment in shmem_fallocate() */
+				if (READ_ONCE(shmem_falloc->high_reclaimer) != current)
+					shmem_falloc->nr_unswapped += nr_pages;
+			} else {
 				shmem_falloc = NULL;
+			}
 			spin_unlock(&inode->i_lock);
 			if (shmem_falloc)
 				goto redirty;
@@ -3567,6 +3572,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
+	gfp_t high_gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
 	pgoff_t index;
 	unsigned long offset;
 	int error = 0;
@@ -3675,6 +3681,15 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			error = -EFAULT;
 			break;
 		}
+		/*
+		 * A large read can charge a lot, for faulting in the buffer
+		 * and swapping in the file. Handle memory.high overage here,
+		 * where no locks are held. As in filemap_read(), reads into
+		 * kernel buffers and reads that must not block skip this.
+		 */
+		if (user_backed_iter(to) &&
+		    !(iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ)))
+			mem_cgroup_over_high_throttle(high_gfp);
 		cond_resched();
 	}
 
@@ -3883,6 +3898,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 	struct inode *inode = file_inode(file);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	gfp_t high_gfp = mapping_gfp_constraint(inode->i_mapping, GFP_KERNEL);
 	struct shmem_falloc shmem_falloc;
 	pgoff_t start, index, end, undo_fallocend;
 	loff_t aligned_end;
@@ -3962,6 +3978,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 	shmem_falloc.next  = start;
 	shmem_falloc.nr_falloced = 0;
 	shmem_falloc.nr_unswapped = 0;
+	shmem_falloc.high_reclaimer = NULL;
 	spin_lock(&inode->i_lock);
 	WRITE_ONCE(inode->i_private, &shmem_falloc);
 	spin_unlock(&inode->i_lock);
@@ -4031,6 +4048,20 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		folio_mark_dirty(folio);
 		folio_unlock(folio);
 		folio_put(folio);
+
+		/*
+		 * Handle memory.high overage here, where only inode_lock is
+		 * held; reclaim doesn't take it. shmem_writeout() won't swap
+		 * out the folios added so far, and counts each try toward the
+		 * -ENOMEM check above. memory.high should only throttle the
+		 * fallocate, so tell shmem_writeout() not to count tries made
+		 * by this reclaim.
+		 */
+		if (mem_cgroup_over_high_pending()) {
+			WRITE_ONCE(shmem_falloc.high_reclaimer, current);
+			mem_cgroup_handle_over_high(high_gfp);
+			WRITE_ONCE(shmem_falloc.high_reclaimer, NULL);
+		}
 		cond_resched();
 	}
 
-- 
2.53.1-Meta


