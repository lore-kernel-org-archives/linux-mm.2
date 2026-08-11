Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3D72C5B569
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 06:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90D2A6B0092; Tue, 11 Aug 2026 02:50:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BDE46B0093; Tue, 11 Aug 2026 02:50:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AEB36B0095; Tue, 11 Aug 2026 02:50:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC6A6B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:50:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 848771C0ED8
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:50:41 +0000 (UTC)
X-FDA: 85088065482.24.5375E9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D073240003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:50:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MSNrlRyj;
	spf=pass (imf17.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786431040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c3hXD+R0mYxZwUJd+E8dww3Fu0OdFHhTiqFxeoSQZOg=;
	b=NIcEXmSuW5ZqBf4UwSUayKC6Y+o9qrbZCXYUOTVUkv6eX5obRDMM5Kxlf+euEUoWRr0Xr9
	yQZEVvaFcYtJc05V6ku85ylIfOHiDFA8bVQP9REVMT+zpSE73vsLOBg10QNMqn0YmJXG8K
	nF1XIv5FdObIDHr7RoTsM69mmxE3H3A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MSNrlRyj;
	spf=pass (imf17.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786431040;
	b=ecwrcs9QQf4ypqD4z8QMk9kgbCUuxb0oJZpyqwdVc73KnRzQYC24muiVIOGZlVe49jOwL1
	xXJpVvgHxln3wLK85AoLqCXN7gVoKmWRSNRsRUAdaRMHSWhkg6K+7l1sNlatl/qF0NQIF7
	xx6VJkXOgd4Wc5w4BTphRul/CxqUbWc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A722D409DB;
	Tue, 11 Aug 2026 06:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013BB1F00A3A;
	Tue, 11 Aug 2026 06:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786431038;
	bh=c3hXD+R0mYxZwUJd+E8dww3Fu0OdFHhTiqFxeoSQZOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MSNrlRyjdL0PbrVLNZ0N2bIveWHjzVZ20AyrRatf+Cxq1LGLdzCv4JpVjtnng9KLF
	 ecR11ajA9NN/Vqo7IR/IzPuCtMt6PPRuKdPMAPI/XRSvq+0ltYMfOZCScBimcNL2b6
	 Whv8IKMvGI/R/2ZvzBinVOY3iZy57Hpy3yvHSrEWcmoFR3Nbh64hyNpNOk2308nctS
	 my/xzSZpKnYH2M9r0JXmibnl082yJd8/7WlLpGiT54SDBeHg0LWjakQuPkj0W9MTjO
	 cvbDKIWd+QcdQYvQVaZ9x0ZNekH4zwdvaG99Wnf0EAVTdd3yPrt/uqeDo0omFJfgOn
	 FSEB34WguwFJg==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>,
	Tao Cui <cui.tao@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Ming Lei <ming.lei@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 1/4] blk-cgroup: wait for old blkgs to leave queue before disk rebind
Date: Tue, 11 Aug 2026 14:47:41 +0800
Message-ID: <20260811064744.1139446-2-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260811064744.1139446-1-yukuai@kernel.org>
References: <20260811064744.1139446-1-yukuai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D073240003
X-Stat-Signature: wy4pn7kxznexttok5m1fp78g9ednqm6k
X-HE-Tag: 1786431039-248354
X-HE-Meta: U2FsdGVkX1/Oy4aDV/qnFoD2GJRj7fB3KPprZtPCRh0pRQiKeJkOwFFbOU090QV7WsNTt/YbPjykul2qM8fe9mqmotQXmLXYqQGsFrDKAkwj98Jr+O+O6F70O7X7hf7f/+YVnaxFY7fn8QfVkB8p7cFdAaLwaG8pKbTMhmXxqpygJdjMSyqE/8/n0q6Fhw8DVq+BQ3Tq+YI1zswYMcrK+TIcpYLITXjTsSA03McmcjlhNBotHBmtdwIsLrMrdHKbgMPMXHy9Eo/EMwGZ/9YrvDfoPlmDfhmzRArGsWrNBvsWwHr+lEr3+ovdx5GFA0CUwZqJIqllzAV90W+oXSStZtyMsuq1yeQWnrvoOlS1p08nlsSgRd6jR/A+fV9TTJN7cYIgjGq4WpV+XsqhrYCftGmNrjoehetjs5M7+FBSNZPI1MrfCVxqsKdrNGfArT5w++wuvxL0/xYJkX0cDzJZoNVtYmTRA5FmBv+qjzAZXZlm7ksWtvotZvMxi1ZYXWMVTengcB9UpjEvg4wZRxEc8frtAVelzdjURJfZIAQ0pP+rrvaLH1N7WD42m9TX/Ir4fKGRsP+uu7yDg+nxVxEz2Ha217JR3xCuIFiz3XZ72H0pZnA2hFUhQ/QMeVFx0zokz1OVYjAvjwwfmhO/r4ZAQC0OCKz2YyqZLPld54JGJsNNECs+HHlnDmRmcxuBS26pmMmzw9Th+T1xbRiAjBhAufC/4DFrxlNx7M1uOmuneAS4d8MRZkmVFXuo+5uU0+y24UU+saF5X+rPyXJeAk4GQk/LpL8N9tCK83svF6lTocKELUW3qvlPRArFUyvLOZHFmTTlzsvpyL5ZGuBBpQHfUT31Ug3USeje3ROlcK0z3xxiUCVaEm6Xv10kamJ28TKFM6hVMgQ/w70xiiICWEr9McN+7IV6rW84rsmtUujOLqk/YwvVwS3mrZ96mqAAs9APjWK4wvpeS0hznKp4Hum
 ddyqUV19
 Nf14O0Zz8Vt7h19p9jCymMLKGs1kVl/evjLlIti27mOtchywfIjl91BwgElmfQ78nBobiQtz49YQwJFNd4kZHEulK88KFLQvA+6BLZ31ld1lmL81L1uUz3MR8uN4xDrUFx/5UnIQDiVg2yxwMRhgO1UdBw0dZ0bXJx24qXSdASah3BYgZ18HCrEPHrlTSsNQaEprXLRWwMiHn7lb6zZmUsMZed1ZD3CfDRmSkHBHgz5WnOdsShN0XI6w/n8bKfkXE1+VZbRuAoprNCAWHjGyHYHfLPEe6/xRzsS4a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai@fygo.io>

blkcg_init_disk() currently waits for q->root_blkg to become NULL before
initializing blkcg state for a rebound disk. However, blkg_destroy_all()
clears q->root_blkg after calling blkg_destroy() for each blkg. At that
point the initial references have only been killed, and the blkgs remain
on q->blkg_list until the remaining references drain and
blkg_free_workfn() removes them.

A rebound disk can therefore install new blkcg state while old blkgs are
still attached to the request queue. Wait for q->blkg_list to become empty
instead, and wake the waiter when the final blkg is removed. This covers
the complete queue-side blkg lifetime without adding separate state.

Fixes: 3dbaacf6ab68 ("blk-cgroup: wait for blkcg cleanup before initializing new disk")
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 354637f3b158..229348273437 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -131,10 +131,12 @@ static void blkg_free_workfn(struct work_struct *work)
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
 	if (blkg->parent)
 		blkg_put(blkg->parent);
 	spin_lock_irq(&q->queue_lock);
 	list_del_init(&blkg->q_node);
+	if (list_empty(&q->blkg_list))
+		wake_up_var(&q->blkg_list);
 	spin_unlock_irq(&q->queue_lock);
 	mutex_unlock(&q->blkcg_mutex);
 
 	/*
 	 * Release blkcg css ref only after blkg is removed from q->blkg_list,
@@ -607,12 +609,10 @@ static void blkg_destroy_all(struct gendisk *disk)
 	}
 
 	q->root_blkg = NULL;
 	spin_unlock_irq(&q->queue_lock);
 	mutex_unlock(&q->blkcg_mutex);
-
-	wake_up_var(&q->root_blkg);
 }
 
 static void blkg_iostat_set(struct blkg_iostat *dst, struct blkg_iostat *src)
 {
 	int i;
@@ -1457,18 +1457,14 @@ int blkcg_init_disk(struct gendisk *disk)
 	bool preloaded;
 
 	/*
 	 * If the queue is shared across disk rebind (e.g., SCSI), the
 	 * previous disk's blkcg state is cleaned up asynchronously via
-	 * disk_release() -> blkcg_exit_disk(). Wait for that cleanup to
-	 * finish (indicated by root_blkg becoming NULL) before setting up
-	 * new blkcg state. Otherwise, we may overwrite q->root_blkg while
-	 * the old one is still alive, and radix_tree_insert() in
-	 * blkg_create() will fail with -EEXIST because the old entries
-	 * still occupy the same queue id slot in blkcg->blkg_tree.
+	 * disk_release() -> blkcg_exit_disk(). Wait for all old blkgs to be
+	 * removed from the queue list before setting up new blkcg state.
 	 */
-	wait_var_event(&q->root_blkg, !READ_ONCE(q->root_blkg));
+	wait_var_event(&q->blkg_list, list_empty_careful(&q->blkg_list));
 
 	new_blkg = blkg_alloc(&blkcg_root, disk, GFP_KERNEL);
 	if (!new_blkg)
 		return -ENOMEM;
 
-- 
2.51.0


