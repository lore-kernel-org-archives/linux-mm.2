Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F3D360A380C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mRRNG3IF
Received: by kanga.kvack.org (Postfix)
	id D7A2F6B05C6; Thu, 12 Nov 2026 14:09:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2A726B05C5; Thu, 12 Nov 2026 14:09:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C67D96B05C6; Thu, 12 Nov 2026 14:09:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A111A6B05C3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:09:22 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3806380B29
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:09:22 +0000 (UTC)
X-FDA: 85427405364.20.701220F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id A3CC3C0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:09:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mRRNG3IF;
	spf=pass (imf22.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794510560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+SeaVehwt396QnIHnWRn5MKZzC9W7QYhwhH8JQg6As=;
	b=yztOTu84kDgTauxkkgBNwniJnzPsfyywAkxEhcd8iE+dwEr57x7wy7wf/z4HPbdvyhenTF
	CkKguMSNhzV6QTn9BVn+RtrywL2MnnoCizlA8TPQVLwr6NUdzmRpBN9PtKsvomYOrocdxh
	3H+HpItspZal4hNljTJLO2KEdqjm97o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794510560;
	b=msM+rvnZbMc0gnOpt/8IJwSxNLi/Vp9f5oGw3xUH1E4x3UQm8OihX0nPBRgb+ObswqZWIC
	wV2RGmZbV41s6kvuORHY7QdFPxb4fKEsx0o3kLxprgXw/YiUKW2S1i4AXHdS4hNp++GLr2
	44TurUUqfJ4tOQKHn+08ghUOERZzLdU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mRRNG3IF;
	spf=pass (imf22.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 45F4D623DE;
	Thu, 12 Nov 2026 19:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0F61F000D4;
	Thu, 12 Nov 2026 19:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794510560;
	bh=1+SeaVehwt396QnIHnWRn5MKZzC9W7QYhwhH8JQg6As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mRRNG3IF7VudZcwh4cqiVMNCUHH4sOIQkPODFYxjF6VVdN7Amv/1OT00M2ftUcuF9
	 EFIXVnWWcEt+0eXCmmNU8X+r2RnDVzuG6yfSf5Y/0M7ojHrS2yk8U239QZnI3qZ+Lk
	 6pR8RzV8tcebiPECs+5iBFoFf0yiyGcwr1ZghoutBg8hSmDyncKS27mRUTmnWqroyj
	 L/SKZp0FA859Q4W+eJP7ekc/fe9Mw8RBwFkiWG+xfjE6VToljzYbMiRZ6pDFU+2y4h
	 LF5KAJ8o2RQKKRtLOVtjbnm9D6+NC8KZTufBiQ30mbO0rgBhiX2YtfyO7SQvePeTqc
	 u45+zU/l1rX5Q==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org
Subject: [PATCH v12 3/7] mm: expose WB_DONTCACHE_DIRTY in bdi debugfs stats
Date: Thu, 12 Nov 2026 14:09:06 -0500
Message-ID: <20261112190911.84702-4-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261112190911.84702-1-snitzer@kernel.org>
References: <20261112190911.84702-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jnbkq3gw9jhckdy8hta6g7ibqg7yn4rn
X-Rspamd-Queue-Id: A3CC3C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794510560-148186
X-HE-Meta: U2FsdGVkX1+2jKhuKnSEw0/fb9ztRLdIYHD1xVYlZa6CKdVkGT+FyOTOMXUrcmkZujD67LdihSm1BsytnEGALTesBfB3+Ho2D3MHITMLYNAdI+SvdvT9TxyeIkEvsbZrkuRBHkRyBMoQyxVL7Rv7XoOoUbtSXDi864narZrdfWr3g559GbFB9XKrDwU+Y6wWzDWUVQmNkv1p3EC3v8o8QQg3uJxIaq7Zb+8jO7g6Bo36YqTfPph/8wencvmq8tgE+/IwnMLGMQa5WyjzlT3MCRLZYTvKv85jMVzvuDtrsO/BpRxh8I+ijBOToUusfHySd/kC6zNCrw/3fTXBE+X3+2ogHD8uiZDUhLoAq427OJiR+ztvDox5aoavGICc3yYttXppQtuieDqQMb/p78D8UP3nBMqcM5mWxN5VQqrLkoUl48kqht8dWuBlPZK2ETuWHgGXvZnIBIICrelr5Y7YnimehQNfbILydGeztSmwHwDSmQxZcSw+Td2LEksp4W6pgHoQU2zCs5NiCAFNuht/CXlhKsq+qS4rs58I+Ef89f/UA/NCnSxVeMb3ZfXr54i7lCPyTUiv+NwWDNI0JSSDT/nbIcfBvToMUoqo1gD8k+kvXLqfpQFk48K7Q5FdVDFTmo/2oKEX5OFN4omt4hK9mkCz1Ji5QPrEDc2G44/kAIMzbW/ZCrhydMnv6zoAJxepQh+OzLQZVFwAAoXXq88o6l6bjDGR6CMca5dncy0qUzYlW6HuPZmymP6Sw3BN/jLmbB+SFzbiDSn5j51mLJBpvAu+zZ70j0HCnPQ9WTaK4cjxiV3QLJibpDHZBYuS52yG6BhY2kQUE4EtU7Lqc3I5C+Rl4SWUCgEwS17pF3WyYqbCmrHgCoqLG58eRr/FA0y8034D3XflzCjcxyNSGkTdeYgDmuyors38PTMv3yGP6ADnHULOcuz+Bcvrqn+ArDQsGZrgj8yoKqDahfcjnlv
 lZm125yn
 zNSE3TSpCCYKa2iP2BRUD7+wepsZ5Fs2SDZR1Ho+rraNwLAjbLe7LqDggxKSqhRtahA70xpYVWAyAMMR6k57kw07oQ6D+IVd01MADFCeVidQNNES+BcnXq303fWbXSGrLjEvcSKtyyH0DuHDAcX/ypyidJn8N9JHDN1lYFMmmwY35lEqNPZUpEl7aynwkj7pbk0KPQfIvq76FVp5ZyMSjOigGZkXc2OflE7yJa4gUCRATgpalbxPKW+HfvMizANNgAmDWKylbTVP081izZLRT6LHKTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The per-bdi_writeback WB_DONTCACHE_DIRTY counter drives how much the
flusher writes back in response to an IOCB_DONTCACHE kick, but it is
not reported anywhere, so the DONTCACHE dirty backlog can only be
inferred from MemFree/Cached movement.

Report it as BdiDontcacheDirty in /sys/kernel/debug/bdi/<dev>/stats
and as WbDontcacheDirty in the per-wb stats, next to the
Reclaimable line.  Use wb_stat_sum() rather than wb_stat() to fold in
the per-cpu batches: the flusher targets the summed value and small
backlogs would otherwise read as zero.

Fixes: 88d6f128d06d ("mm: track DONTCACHE dirty pages per bdi_writeback")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 mm/backing-dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index fad1495d3b200..a09c21759fb9f 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -46,6 +46,7 @@ struct wb_stats {
 	unsigned long nr_dirty_time;
 	unsigned long nr_writeback;
 	unsigned long nr_reclaimable;
+	unsigned long nr_dontcache_dirty;
 	unsigned long nr_dirtied;
 	unsigned long nr_written;
 	unsigned long dirty_thresh;
@@ -78,6 +79,7 @@ static void collect_wb_stats(struct wb_stats *stats,
 
 	stats->nr_writeback += wb_stat(wb, WB_WRITEBACK);
 	stats->nr_reclaimable += wb_stat(wb, WB_RECLAIMABLE);
+	stats->nr_dontcache_dirty += wb_stat_sum(wb, WB_DONTCACHE_DIRTY);
 	stats->nr_dirtied += wb_stat(wb, WB_DIRTIED);
 	stats->nr_written += wb_stat(wb, WB_WRITTEN);
 	stats->wb_thresh += wb_calc_thresh(wb, stats->dirty_thresh);
@@ -125,6 +127,7 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 	seq_printf(m,
 		   "BdiWriteback:       %10lu kB\n"
 		   "BdiReclaimable:     %10lu kB\n"
+		   "BdiDontcacheDirty:  %10lu kB\n"
 		   "BdiDirtyThresh:     %10lu kB\n"
 		   "DirtyThresh:        %10lu kB\n"
 		   "BackgroundThresh:   %10lu kB\n"
@@ -139,6 +142,7 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 		   "state:              %10lx\n",
 		   K(stats.nr_writeback),
 		   K(stats.nr_reclaimable),
+		   K(stats.nr_dontcache_dirty),
 		   K(stats.wb_thresh),
 		   K(dirty_thresh),
 		   K(background_thresh),
@@ -163,6 +167,7 @@ static void wb_stats_show(struct seq_file *m, struct bdi_writeback *wb,
 		   "WbCgIno:           %10lu\n"
 		   "WbWriteback:       %10lu kB\n"
 		   "WbReclaimable:     %10lu kB\n"
+		   "WbDontcacheDirty:  %10lu kB\n"
 		   "WbDirtyThresh:     %10lu kB\n"
 		   "WbDirtied:         %10lu kB\n"
 		   "WbWritten:         %10lu kB\n"
@@ -179,6 +184,7 @@ static void wb_stats_show(struct seq_file *m, struct bdi_writeback *wb,
 #endif
 		   K(stats->nr_writeback),
 		   K(stats->nr_reclaimable),
+		   K(stats->nr_dontcache_dirty),
 		   K(stats->wb_thresh),
 		   K(stats->nr_dirtied),
 		   K(stats->nr_written),
-- 
2.52.0


