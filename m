Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF91C606A332
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 20:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ALp+ZqNe
Received: by kanga.kvack.org (Postfix)
	id BAF0E6B05BA; Wed, 11 Nov 2026 15:36:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5F9E6B05BB; Wed, 11 Nov 2026 15:36:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74DC6B05BD; Wed, 11 Nov 2026 15:36:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66D9A6B05BA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:36:51 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04237A7DB0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:51 +0000 (UTC)
X-FDA: 85423997022.25.221F105
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6AA852000E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=ALp+ZqNe;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf13.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794429409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IG2i4eM11A8lVv+NbNC7CjJ7zEpmOtNYGqSnK/Rh/6Y=;
	b=yi+zJABYm2tmdMWYJVwJYCSOZawJMaa9k7wW2wULRyIWnQ02jv95wJPIVOiaKrQ5VLU/Z/
	d7klvTNBATUc9oNGRDoA7dnQtXUBH7XVgXpNTgA7fpi7Nma6ONxOLrgkvnU2QNKCuvMfkO
	BgG4hTN9OwV8HFPj3GoQemxs+8+LHG4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=ALp+ZqNe;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf13.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794429409;
	b=Ug+1RJyF9G1XeU+ZWBPctdX4xEQnaNJkghqwEDOSdAGtX0HGhMB3Sd468tVR2C9L3Upc77
	yaEHELXLmcRSlLuu2oI5nUk44AG3okfwacl37IKnt1ovPrs/4pDiDDOfWKZOo4AYxAPrie
	C26JF4xvx3pyAe9ZyBCiv1ydFsrvKVE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794429407;
	bh=IG2i4eM11A8lVv+NbNC7CjJ7zEpmOtNYGqSnK/Rh/6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALp+ZqNezrOAxayzvPcDAUX20E5pghRS59g6lOQSA2zej8fZoYWUwg6rL1ZSV17YD
	 sGTIIb+53qYGxyuLe2xHUY+6lASwNHa5sjz3rdQNed6KddL9rF7kfx5JssGDJIY4XS
	 0BjSNkXziuJ/WZYP5NXR+SfzipTUGkBp2fxNM40Vpo/AAQ4/GZDsZ2+bxV9/iNxgSc
	 kLvqwkGfDppndZrqnnfVeGy5nvWt0KBCaK259IxQ1mKycTcqHLfxYTnG/pIvrCH8ye
	 9AU+ieilBaQ/IECjOJs27hzUhF41Y9GEqlYFX1Yr2P3hu3pPeqWaxh3DsAIXjwGwDS
	 9sU6gb9AQ/mNA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jPwKp6tFLzP3s;
	Wed, 11 Nov 2026 15:36:46 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Hildenbrand <david@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	David Carlier <devnexen@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
	Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Kees Cook <kees@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	linux-trace-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrea Parri <parri.andrea@gmail.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Hugh Dickins <hughd@google.com>
Subject: [RFC PATCH v25 11/14] mm: shmem: use a limit counter for the tmpfs size limit
Date: Wed, 11 Nov 2026 15:36:23 -0500
Message-Id: <20261111203626.95838-12-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
References: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6AA852000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: cu5yur971eoexobi83itg8sn4i379ppz
X-HE-Tag: 1794429409-528638
X-HE-Meta: U2FsdGVkX1+Hix/Cp/rlMq+CbaiYpobU7lUr/+kdFD0O+IIl6Zf+bxTGT3x51wPtc2zzeApx5mfW2gnL8NLCHeyT/wGYpl40Hko6NkmyWZfQv810y1zVa7hHSNWxMzVKbEOxTdMX5hNCstquFcMbqiYQbiCoD7XDgm1gWEUOAT9BB0NHGwEuTCR2LzLW1yt7QiECSB8hjwFDxVEl+mlWwXoiVymIoLEJ04XEb0aZHvkyjPoN2IlmjXpOdjem5IGH4rd5B0WAutfZt3/VQU651UgeQxPuzD0a1cWSbZoK/UzU3fSarR3EIx2pcEQklADWQwvbLDfVmKy7nAVvakvjk104pBz4WoN20arvV7axc30i/hybOfrrrA0MqeGxIeAeO6FlQzzZSBroOkPJEvOohoHouSqXPNUeg/m7E+2CA7K9f3IINvTMW6Atisp7De5f58racpaw6tnI6vphYXwQnewYJZHufKdT/Z47czReKuDW4JpX5SZKuVjCC9VFVm7JKRknPiaq87INDCT6vVTopE63YF8JlOvoW3NMz70mZlWEknmpA41YH6H1ZER0WvfWO99di1MmQmSGYd/NKX9CV6Iiby4yjdCqo2LA7IUl9HBvtV+MQrZLaoh/1MdI1koSDP9nKw1W8O3NqnfKH9vNA7Zd40wHZO9gpgy+4kY5rM4HXi/Pwy6v4dMFiwLJx6bV9BsDLy0IpduzmJMB2Pofwmvm01f808YyyBwgCerUICb4GORsY/pYum9ME4I4k59qSDk2NM4sh/vAtgld1On65grRNVc2il77u2LKCIccWI34YxuFmrShj7PVVRk6Po+spK6HHbfvZ3RNdDGjZV+tz3gm9+BetktKn+gIzHXtxjT3bFbQRdT7Zg5ZPHjkEhy36g8T7+G/BeYQMNKkLPXFPkAuxdLQUxCnOK4Dsg/Rv6A+RFutSU0Nl2886UEbzPAZu73636SMBatPfNAYhbL
 dp4Js8gP
 YxQik5HSm5uc3cPtSi2c3NWbeyJCf9PM54AQByEgkqtgXjnQJnMrzlZ3ttKkmw/GFmaTPAE6yEqzHBOz4vz8K+ztTajIAmiLDvCazE6BGES5US9hpuPkuIH8BRrxFYGmB4jk//8iEZLE3WMwXPZ2KyvMMHo//Nsybngg87DbRZ6/gRQSr9r6rfzaP0p9UVJ3i5J8iWS4rTRk9vu4JWR1oCsPefYa/zvtjE3oYIfd4EGEnZXpSCiWrHXgIeQcK77BODWjpvOsdYPS8lX+cBxKnqJy3FRzTFbE0VDkoqtZUk8qKnpbk+AqsIn2TKHVWpNy3dsp025itvnAW78SfbptJZXeyps876/vvfg2faWWx7mLRzrrWWhSRRtWs/5JCOyFMPr7g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The size limit of tmpfs (the size= mount option) is a struct
percpu_counter. Each block allocation checks it with
percpu_counter_limited_add(). That check takes no lock only while the
mount is more than batch * nr_cpus pages below its size. With the
default batch size of 768 at 384 CPUs, this is 294912 pages, 1.1 GB.
A smaller mount, such as a 64 MB /dev/shm, takes the counter spinlock
and sums all CPUs on every page. On a 384-CPU host with 384 processes
allocating, 99.5% of the time goes to that spinlock.

Use a hierarchical limit counter instead. Its batch size is chosen from
the size. When the size allows, its accuracy is within 1/4 of the size.
Block allocations then sum the CPUs only in the last 1/4 of the size.
They take no lock. The limit stays strict.

Near a full mount, an allocation can fail although it fits. This
happens while a concurrent allocation of a few pages, which does not
fit, is being undone. A large folio is checked before it is added, so a
large folio which does not fit has no such effect.

A mount without a size limit never counts its blocks. A remount cannot
add a limit. So such a mount no longer allocates the counter.

A remount keeps the batch size. A mount grown by remount thus keeps the
smaller batch size of its first size. Under concurrent allocations, a
remount to a smaller size can be refused although the use fits.

Test: fallocate() of one page at a time into one file per process, all
on one mount. This is a will-it-scale variant. It ran in a 384-vCPU
guest pinned to a 2-socket AMD EPYC 9654 host, on v7.4-rc2. In
thousands of calls per second:

  size=  processes   before    after
  64 MB          1      208      483
  64 MB         64      256    17771
  64 MB        384      126    54275
  1 GB         384      125    93879
  2 GB         384    93851    93476
  16 GB        384    93737    94806

Below 1.1 GB, the mount scales again with the number of processes. At
2 GB and above, the results are within 1% of before. Within the last
1/4 of the size, each allocation sums both counters over all CPUs. With
one process, this is 37% slower than before. With 384 processes, it is
about 100 times faster.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/shmem_fs.h |  3 ++-
 mm/shmem.c               | 33 +++++++++++++++++++++++----------
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index f89b4b151133..b37adf32e4ef 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -7,6 +7,7 @@
 #include <linux/mempolicy.h>
 #include <linux/pagemap.h>
 #include <linux/percpu_counter.h>
+#include <linux/percpu_counter_tree.h>
 #include <linux/xattr.h>
 #include <linux/fs_parser.h>
 #include <linux/userfaultfd_k.h>
@@ -76,7 +77,7 @@ struct shmem_quota_limits {
 
 struct shmem_sb_info {
 	unsigned long max_blocks;   /* How many blocks are allowed */
-	struct percpu_counter used_blocks;  /* How many are allocated */
+	struct percpu_counter_tree_limit used_blocks; /* How many are allocated */
 	unsigned long max_inodes;   /* How many inodes are allowed */
 	unsigned long free_ispace;  /* How much ispace left for allocation */
 	raw_spinlock_t stat_lock;   /* Serialize shmem_sb_info changes */
diff --git a/mm/shmem.c b/mm/shmem.c
index b8399bb71997..2e368d7b0e41 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -231,13 +231,13 @@ int shmem_inode_acct_blocks(struct inode *inode, long pages)
 
 	might_sleep();	/* when quotas */
 	if (sbinfo->max_blocks) {
-		if (!percpu_counter_limited_add(&sbinfo->used_blocks,
-						sbinfo->max_blocks, pages))
+		if (!percpu_counter_tree_limit_add(&sbinfo->used_blocks,
+						   sbinfo->max_blocks, pages))
 			goto unacct;
 
 		err = dquot_alloc_block_nodirty(inode, pages);
 		if (err) {
-			percpu_counter_sub(&sbinfo->used_blocks, pages);
+			percpu_counter_tree_limit_sub(&sbinfo->used_blocks, pages);
 			goto unacct;
 		}
 	} else {
@@ -262,7 +262,7 @@ static void shmem_inode_unacct_blocks(struct inode *inode, long pages)
 	dquot_free_block_nodirty(inode, pages);
 
 	if (sbinfo->max_blocks)
-		percpu_counter_sub(&sbinfo->used_blocks, pages);
+		percpu_counter_tree_limit_sub(&sbinfo->used_blocks, pages);
 	shmem_unacct_blocks(info->flags, pages);
 }
 
@@ -4048,9 +4048,11 @@ static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_namelen = NAME_MAX;
 	if (sbinfo->max_blocks) {
 		buf->f_blocks = sbinfo->max_blocks;
+		/* Under concurrent allocations, the sum can be above the size. */
 		buf->f_bavail =
 		buf->f_bfree  = sbinfo->max_blocks -
-				percpu_counter_sum(&sbinfo->used_blocks);
+				min(percpu_counter_tree_limit_precise_sum(&sbinfo->used_blocks),
+				    sbinfo->max_blocks);
 	}
 	if (sbinfo->max_inodes) {
 		buf->f_files = sbinfo->max_inodes;
@@ -5020,8 +5022,8 @@ static int shmem_reconfigure(struct fs_context *fc)
 			err = "Cannot retroactively limit size";
 			goto out;
 		}
-		if (percpu_counter_compare(&sbinfo->used_blocks,
-					   ctx->blocks) > 0) {
+		if (percpu_counter_tree_limit_precise_sum(&sbinfo->used_blocks) >
+		    ctx->blocks) {
 			err = "Too small a size for current use";
 			goto out;
 		}
@@ -5187,7 +5189,7 @@ static void shmem_put_super(struct super_block *sb)
 	shmem_disable_quotas(sb);
 #endif
 	free_percpu(sbinfo->ino_batch);
-	percpu_counter_destroy(&sbinfo->used_blocks);
+	percpu_counter_tree_limit_destroy(&sbinfo->used_blocks);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	list_lru_destroy(&sbinfo->shrinklist);
 #endif
@@ -5212,6 +5214,7 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 	static struct lock_class_key shmem_unused_huge_lock_key;
 #endif
 	struct shmem_options *ctx = fc->fs_private;
+	unsigned long batch;
 	struct inode *inode;
 	struct shmem_sb_info *sbinfo;
 	int error = -ENOMEM;
@@ -5286,8 +5289,18 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 	ctx->mpol = NULL;
 
 	raw_spin_lock_init(&sbinfo->stat_lock);
-	if (percpu_counter_init(&sbinfo->used_blocks, 0, GFP_KERNEL))
-		goto failed;
+	/*
+	 * A mount without a size limit never counts its blocks. A remount
+	 * cannot add a limit. Otherwise, pick the batch size from the size.
+	 * When the size allows, its accuracy is within 1/4 of the size. A
+	 * block allocation then sums all CPUs only within the last 1/4 of the
+	 * size. A remount keeps the batch size.
+	 */
+	if (sbinfo->max_blocks) {
+		batch = percpu_counter_tree_batch_for_accuracy(sbinfo->max_blocks / 4);
+		if (percpu_counter_tree_limit_init(&sbinfo->used_blocks, batch, GFP_KERNEL))
+			goto failed;
+	}
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (list_lru_init_memcg_key(&sbinfo->shrinklist, sb->s_shrink,
-- 
2.47.3


