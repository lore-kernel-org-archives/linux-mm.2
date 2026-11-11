Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0AFD606A324
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jaYer3Uk
Received: by kanga.kvack.org (Postfix)
	id D380F6B05BA; Tue, 10 Nov 2026 20:56:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC26B6B05BB; Tue, 10 Nov 2026 20:56:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD7676B05BC; Tue, 10 Nov 2026 20:56:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96EF36B05BA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:15 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C4A71601CC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:56:15 +0000 (UTC)
X-FDA: 85421173110.04.F1D092F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8DE7080004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:56:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jaYer3Uk;
	spf=pass (imf30.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794362173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+SeaVehwt396QnIHnWRn5MKZzC9W7QYhwhH8JQg6As=;
	b=GOGd1EWjFtfTN2oNLacKJbxuvpwa7pl2wLjyLwaDiB79tGFQb8h9FfaFw+ALMZp/17JUJe
	7/f7oTfxpGV3GtevN4oqd1+bQEIkdlAvtjeVUbbzRf9laFX0t5LI6idoYTuel8gUgggr9d
	ZMQpkfuWYheAIh9LrTlBUEG09Os8pUY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794362173;
	b=x2hmPDU+6HCYgffMe9StHLL2QCztUqYFZPCrnWhmQEYBJRKx2AKEY0yVORTS/Gn4d70a+H
	FLi/g3el24HXbMKalzc1Z2Bvxe9ZEgGuqwn8XPzPr1tFZM//0xV/wQMpiBUhSC5p9Me5nM
	wzYj1WPFVKRNFRM73DkS29U3yuXIR/s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jaYer3Uk;
	spf=pass (imf30.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27E3A61C66;
	Wed, 11 Nov 2026 01:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4531F0089F;
	Wed, 11 Nov 2026 01:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794362172;
	bh=1+SeaVehwt396QnIHnWRn5MKZzC9W7QYhwhH8JQg6As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jaYer3UkU1XnKYfff4RTI5kdyEoXoydQ9Uq+hWH5QUV/6fm64O+SyKY6w6ncUO6km
	 c/t8alJnoPITaNLCj6H+jafLoaNyVreEpXaR7luV87rWLQguNQvyv8X2O9jBeVcUpg
	 Vy+26mUE7HSWj3mrNodWLmb2phg0BI9OPzd1UDIyVHE97cq8n0yqRTIDlY3OnC9D+L
	 yUZiPvPWbJYYqLr6AKUYrOsu0S1ToFj+ewvRtBoXs4Uuk5G27EtO+rUD1O3XuUYQv5
	 s1464Z+iOs1zBIGgvFTMp7L2wTVcRaH8A+Iu0LhRJwbn/RT65spHtXg7DV//IsPZsk
	 qInAFc8KCxg6A==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org
Subject: [PATCH v11 3/7] mm: expose WB_DONTCACHE_DIRTY in bdi debugfs stats
Date: Tue, 10 Nov 2026 20:56:03 -0500
Message-ID: <20261111015607.46338-4-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261111015607.46338-1-snitzer@kernel.org>
References: <20261111015607.46338-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: de4h3j4w9jpd5f4sriffyzit97qsiit3
X-Rspamd-Queue-Id: 8DE7080004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794362173-349037
X-HE-Meta: U2FsdGVkX19uDm0SRh1+LumCFho8rpNEac81maK023nxxYYaJFEtSbvE3Ij4o1mdzcf1pEMCUJ7RrYRu0yWYbE0zoSLK7oKeDgGbTxpiN+FKwot9XKd6EfZRZ3oEEa7ZZWzMO7L+phirCDcowq9/32bu10J9K3fLARSuFfs8NKfO7i0YxVZ+BMzzQ68PynvFj/OjIlrqh8qrTOebx5GdD3I4cMD+Zrmfp552yrmhWgDdWhh9CHhjoHHOhWv3AK2CWDgU7m230PstGIEmvIc6DMxjEy53X1SHCYU/2OvNdhxDYRScuXi3uETxPPUtRZvc6yRuVKq4L35CwyXsPnRTc7cSIJRWfDwfpuFmyGsRQOl2Zj1KCbR87JLtPI7DNmq9B6LeD2XOR5mYfoB02bT1Z5ILIn4haMXzy/ETvVhXh2aCNVfDNbx/eUmqzaS7GW25q8MI+P88oRFvTSlcvRNn92ERuy70PRSRkbYVTbM6if/GNw/BS1zxzZkdpgmlPtrdk3Lin2Zu330i7UxdUn/+8Xl12NIJVsCJsVx4fMyvrsEmVWi6d2R1bGzzJCQ5YdiUV5nJgOoBm1QMLLoRmiJMSUzdRD7zfNlDvAeCRKtNFgobqkcvqjoRgeMaGW3TnIbjhNZU2608K+PXny2n2zp6hQYfTsNIvTcT3r2/sPdYQkW+CpLR+DYZNCL4OKChOW0hOikvWVu2wEwkJswRDkzqAOi1sBPtbKm3kJWmSC967lOhoGbhqPz9ko687WHSLZF8gGQ2PHiZj/WXt34Dur/5IU7qRIsrD+JmUupsR9txpVJ4VIFkNw7UQNfwY0h6Mfppy99lHaL9P6gSWnZodBWjwFSN1HTFLeTwCPPcOIN2P626NMl+rLPEii9K9Md8V11b1dxY4ig/mnTZVvOQS/pTUmuA5C2Ogp+QVYXtijVjsl/aQGRU1oXnB31brot2NBNc0CpbbwD/dPGzxpcXfjk
 yHVB8nKQ
 xvBFqwB+s1pTbT20m4Ahq90SAf3asJ2xtib3c9R/FxZH4ETPj+36Fp/8pK7VglEUwcROv3CH8u3qgS/Wib3USkaNLZhJW+ZAluGsbYZmbl8ZzrTS33pPSeUorNrrOwGM8qe1xs4ty2+n8O2+85Hozqn3qVF6cnx6RSNJ6sYDXl4gl47waKYamOVYybCIRnoKFSAJniWmsJUljsfcdza0AqE28XzDLutJX4iSTNcLRYyYhgv7oLNQJWdjTll9j73gV14QHXRXZbw/9N//qo2dwIUosUA==
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


