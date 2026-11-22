Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B34D3606A336
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xgBbcIYd
Received: by kanga.kvack.org (Postfix)
	id BACA86B05B8; Sat, 21 Nov 2026 21:48:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0EA66B05B9; Sat, 21 Nov 2026 21:48:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4BB36B05BA; Sat, 21 Nov 2026 21:48:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79F026B05B8
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:48:15 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01D4CA066F
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:48:14 +0000 (UTC)
X-FDA: 85461220950.21.BEB59D4
Received: from mta0.migadu.com (out-226.mta0.migadu.com [91.218.175.226])
	by imf10.hostedemail.com (Postfix) with ESMTP id 14AB7C0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:48:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xgBbcIYd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.226 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795315693;
	b=ZctvgVZPMVHHrQdzzjwK0w1bkvC6Ik30uxflJ2YKTDByW0cohDvNCKZ8Z10URrjuYSeQ6m
	xzhcnJybYe1LWix8Iu0J7zg01vhK9npcJNjG88PhOT+0MHgX9JHsi1nYU/jzOjVKthF2NB
	GxIkDQ+wbe56rJcfT+4P7jrpA5znGhw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795315693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvXKv2uGoryhV8ejGU2oe5V38xffHiqxUDzEj+9Yto4=;
	b=eF/0C3Oapk0W7RcKkyZcIQyumIbiox2wUjUOWQRCmvexHrH7GF6z0KZBX5UV22BsQhWD7f
	VMoQ7YFsPjJ9IeBGGSXyYEuiWTqc5Ti3RGbCARRK9hrdmk1pEzQ0DxKZcCDD2AfeOrpIjE
	DAtCQ7WUSXY0od8bIL7XtbjMD7LKGBA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xgBbcIYd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.226 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FlgX4ij9PP8OLUKybf0hSOU7C77RZjMnD053eX5Rndg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795315691; v=1; x=1795920491;
 b=xgBbcIYdsWrScz/oSs25iQBtmCvRoJPC5puXDBYAuVeVwGFLVNe6SaeNj5t37nhEfm6o5V69
 TohB8FPxWLMSjKUQPM01Mdloy556YRU4Wj66DO4wzWnehgJNbQSia2eDujE02ZzdcGuu0rnFAXF
 uNNkVmPxBss03ajpBYuueN5c=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cf46edc9697afc8d;
	Sun, 22 Nov 2026 02:48:11 +0000
X-Mizu-Trace-ID: cf46edc9697afc8d
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
Subject: [RFC PATCH 6/7] memcg: remove synchronous memory.high enforcement
Date: Sat, 21 Nov 2026 18:47:36 -0800
Message-ID: <20261122024737.2741569-7-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261122024737.2741569-1-shakeel.butt@linux.dev>
References: <20261122024737.2741569-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 14AB7C0005
X-Stat-Signature: p5o66zck13fh1wz78ghhzdda8h3ps6cr
X-HE-Tag: 1795315692-765506
X-HE-Meta: U2FsdGVkX19rNW/rAEFydkW+a17JE3cMm9uiZV0qVaTO1YmVzZcZuPN1LZvSQjiTgaVCunwOnuCAXGKTDALPkftn8QVVhqFcX/3p7hjVxhBnIoPDX+aqs83VwdFQGtoehxc/9WV8hXM4WtOSFf0LbPSFIdL2GLyzotdHoloaAkUW6ZdHC7WN6javDJOzXBE3H/6u0UaVCvR75VBRlqi6TlmzbipnyqZzyzevBuofzPsgCegtdr5M/Ot3vOEZiRidxurluFuZWcqPBKpCTLQOEYtWaklbhBpY49XDI4W3vZocEIDNTZY+T8oi4BIjInCW1pj55SMrQgKH8F5sQJyZZpP69qpthawP4tbJaWExZxtWiD/yGzdTBn0k9Rh+Z8uNnUSfDmaicvwP783kYL4/OICDAOUBhu45imnmL4JuMOKQn6KObDGlcaEGHZLmk8vDpzLLuHer10hrnEqBEot8gBbwPLefaWv9OBGB8X+84MURRAFa0agv4IAJjfAnTaZemweBwQMc90PGCQqafEzMmVB16T60egYCQvvevYRAKCuLIsc4rUV8Gt97Pr14N3xcTaKbA+bvZt7Q8K7nZpxhoyIJtQwZdDlNfxYCuJBNacPosCKFOdfR4p/B27SlhQF1WeAyFPMu9sB2iwOP7598iPPuwM9L3/t8LWH3yXvue/ZuA3Kpb2j2tNn4qDWFAQEs4CSEIJFkyxsbBwoH36x6KkITBRE83mUJ+KxA1VQDRTjh4fw09yRrK6P3hHjbww6k0SUnYSWHuwIxqjXL3HLVzfIMqFWbWHO+X8De+RazXHrAYS8EDYA1vu71VHu5HsDWxIRbwiFr1LUmwfsjDM9PEOmkKc3Ssm2TB6ggFTmvVghIpTgKqWxIzIbUb5xbggQhkiqDkU2pT49B38+R17Z0/PsD0eDbcx5qmDv9Pq6R5aADPL/jc2ah9JhqXZ7JOsle+9MkM4LkEZjVuhuY6ox
 1t8cXDwe
 83GnSQ0aeEBZrCyq/sokuT6wMjgAN/9SBxSHkUyhH4dTNoHMk5QUHMoLotCWyenaIqMSA625EG/hq4O/NDL/PID4StGgBj5GP0pMQA+2gvgIqZwSvnRKlcOt2nVhP8mdZaTU/FrPOwoWpKaHwXbVHq6nVoq/ycNGP437yqcDM71NdHu37zfERBWOHlCVDrOeaqgq0gYq/v5qJsMa4C0fI511LZk3OwqDZHBmrgeKJcyiheeeu87XaRpVc6XfnlQZphiZYxL2xOnmZUnRftGv1bFFGufg8mTFpAHwXTbkhM2223b5QKzAmVs0o7KL4c5vPI5s+ryPQGjQmj4qF4Zi1Wm3VKZj0kih3tsyijEKPhV6K4iwTfdFa1QECSjUoYqlFCJClAzCg9PtGOFMIUbkYpMxXHFzSuCe3Hjx9TQbgl607qM+DjK69r8ddTqERHA/QcRIttS0lwjQJOezsUnRwThZzuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A task stuck in memcg limit enforcement in the charge path keeps its
locks, and tasks in other cgroups that need them wait for a limit that
has nothing to do with them.

memory.max is a hard limit, so the charge path has to enforce it.
memory.high doesn't: since commit b23afb93d317 ("memcg: punt high
overage reclaim to return-to-userland path"), the charge only records
the overage, and the task reclaims and is throttled on return to
userspace, where it holds no locks. Avoiding this priority inversion
was one of the reasons for that commit.

But return to userspace is too late when one system call charges a
lot, like mlock() of a large range. So commit c9afe31ec443 ("memcg:
synchronously enforce memory.high for large overcharges") made a
charge that can block handle the overage right away once more than a
batch is pending. That step reclaims and sleeps, up to 2s per call,
under whatever locks the caller holds: mmap_lock while mlock() faults
in a MADV_HUGEPAGE range, or invalidate_lock and locked folios in
readahead. It also misses THP charges in other ranges, which can't
block under the default defrag setting.

The previous patches handle the overage where the task holds no locks,
or only the locks of its file, in the operations that charge the most
in one call: populating memory, shmem fallocate, buffered writes,
reads into user memory and MADV_COLLAPSE. Remove the synchronous step.

Other paths now handle the overage only on return to userspace, and
memory.max still limits them. Many can get a hook later. For example,
reading /dev/urandom into an untouched buffer reaches 513M under
memory.high=64M. With THP on, it did before too, but with small pages
the synchronous step used to throttle it. Another is mprotect() making
an mlocked private range writable, which copies its pages with
mmap_lock held for writing.

Update the memory.high documentation to say when tasks are throttled.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 Documentation/admin-guide/cgroup-v2.rst | 12 ++++++++++--
 mm/memcontrol.c                         | 20 ++++++--------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..215710a44a88 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1386,6 +1386,14 @@ write "max"; to set it to zero explicitly, write "0".
 	over the high boundary, the processes of the cgroup are
 	throttled and put under heavy reclaim pressure.
 
+	A task is throttled when it returns to userspace after
+	charging, and at some points in long operations, such as
+	populating memory or large buffered reads and writes. A
+	system call that allocates a lot without reaching such a
+	point can take the usage over the high boundary by up to
+	the amount it allocates. Kernel threads are not throttled:
+	a worker reclaims for them instead.
+
 	Going over the high limit never invokes the OOM killer and
 	under extreme conditions the limit may be breached. The high
 	limit should be used in scenarios where an external process
@@ -1396,8 +1404,8 @@ write "max"; to set it to zero explicitly, write "0".
 	reclaim is bypassed. This is useful for admin processes that
 	need to dynamically adjust the job's memory limits without
 	expending their own CPU resources on memory reclamation. The
-	job will trigger the reclaim and/or get throttled on its
-	next charge request.
+	job will reclaim and/or get throttled after it charges
+	memory again.
 
 	Please note that with O_NONBLOCK, there is a chance that the
 	target memory cgroup may take indefinite amount of time to
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6d147153bd06..4771730e017a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2615,8 +2615,9 @@ static unsigned long calculate_high_delay(unsigned int nr_pages,
 }
 
 /*
- * Handle pending high overage during a blocking charge or on return
- * to userspace.
+ * Handle pending high overage on return to userspace, or at a point in a
+ * long-running operation where the task can sleep (see
+ * mem_cgroup_over_high_throttle()).
  */
 void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
@@ -2725,9 +2726,9 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		!current->mm || !mm_match_cgroup(current->mm, memcg);
 
 	/*
-	 * Check the charged cgroup and its parents. Local charges normally defer
-	 * reclaim until return to userspace so it can use GFP_KERNEL. Large
-	 * pending overages may be handled synchronously below. The handler looks
+	 * Check the charged cgroup and its parents. Local charges defer reclaim
+	 * until return to userspace, or until a long-running operation reaches
+	 * a point where it can sleep and calls the handler. The handler looks
 	 * up current->mm and rechecks the limits. If the task moved to another
 	 * cgroup in the meantime, the handler works on the new cgroup instead.
 	 * That is rare and costs little.
@@ -2765,15 +2766,6 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		current->memcg_nr_pages_over_high += nr_pages;
 		set_notify_resume(current);
 	}
-
-	/*
-	 * Earlier charges may have left high overage pending even if this charge
-	 * found no new overage. Handle it now if this charge can block, to limit
-	 * overrun while the task remains in the kernel.
-	 */
-	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
-	    gfpflags_allow_blocking(gfp_mask))
-		__mem_cgroup_handle_over_high(gfp_mask);
 }
 
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
-- 
2.53.1-Meta


