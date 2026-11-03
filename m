Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFAD7606A335
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nsBBcQZv
Received: by kanga.kvack.org (Postfix)
	id 5AE126B05BF; Tue,  3 Nov 2026 16:18:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F976B05C0; Tue,  3 Nov 2026 16:18:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C9F6B05C1; Tue,  3 Nov 2026 16:18:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2332A6B05BF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:18:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 92D6A120549
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:18:01 +0000 (UTC)
X-FDA: 85395070362.20.2AC081A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 020C320009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:17:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nsBBcQZv;
	spf=pass (imf13.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740680;
	b=cDGnUQ6QSDQ/2bu5ZyRmF3MJN2RAHFg5+iTr2SaL0Eor6wuYXrBLghEQu9dNw/VsX+LP71
	LDGod6w4XuordjUQukDQr+PgFKJ/0Me2Unx/M9rNqGUQmPPz+STHsuy1P0ZY8sZV/yCWCx
	mulpj+d0x38JJRz7OuPGHOb7aJDiBG8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nsBBcQZv;
	spf=pass (imf13.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+SeaVehwt396QnIHnWRn5MKZzC9W7QYhwhH8JQg6As=;
	b=pGDbQcZSs57YxBnKUuVEkikCs1G0Ywurffmv5DjiEIpkJ3f3pZgcZG0mkeSBCahFio7AO7
	8d3UICPxNr3i7/hQeHltBOom4+kYeaLe1Cb2l0iFCEUlIlFk6PozEZl6cysUYxPMxk8Fjf
	UUwIpYYdLmS1rxYuPo2kqKHUJpSFjbg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 54BFA406CD;
	Tue,  3 Nov 2026 21:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066C91F000C1;
	Tue,  3 Nov 2026 21:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793740679;
	bh=1+SeaVehwt396QnIHnWRn5MKZzC9W7QYhwhH8JQg6As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nsBBcQZvBukrCr6ZOO/LZhZdwZ2UeCaaLrXBy7YduO+XZ+qdB+zZcZ+70hLRx0iym
	 LWa4m4h/8OIpWrMCwLZLT99KQSKS9bcqDa3xmfHUb8ym5/bamOIoBCQenlGGN0pZxq
	 uzi6woLgmZBihfj+KoQpnX5OjJ8Mflm1N6HJR/Fyfwh4N1tELoKYDuTqvaJ5Hi2xy2
	 +4MpPG5mOginkJf5dRid4rPNyc+GBAlewpMLkGEKcBjfUxRgAFakPkadlrVoqEWY6v
	 jsTKF7k2z1FXPHA5KwiowiwUo/Ifx4GCk1Dr5HFx9rZEgnwJZXrANlh9G7aHCwWRoV
	 UjAC280UkaWSQ==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v10 3/7] mm: expose WB_DONTCACHE_DIRTY in bdi debugfs stats
Date: Tue,  3 Nov 2026 16:17:50 -0500
Message-ID: <20261103211754.35352-4-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261103211754.35352-1-snitzer@kernel.org>
References: <20261103211754.35352-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qqnz476scz66eymtrao5fkpwn693nidr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 020C320009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793740679-436827
X-HE-Meta: U2FsdGVkX191Ym3BEE8hQvJUcNvaLx74tHrax7bC/H2Tg9HkA2nfxNdvgpdtJqAqDdLbx3w745dSVZ5a4EEjTQI1BnzIsp5Iiq8vC12ttJcJ5BMRMpusqzutf3+W2lSf4ofVfj/zGNtI2WacOKH4Z8bfJ9pyJ4T90EERu8sOkHdRi2BiEOadrfG5DGD9jIXKdBT5w505FbLGHoiC1DrWmAyIafu5mKARMcSIRXkHNwn6F2kyP+XnM454f/h8jIukSjaOgKNBdWeb+dVf6hpHXBJ+b5vRAoHY7dqHIH1C+JniDtorpU5SdqIiYMvFwo+GlYIjGAiY7GKWGNjXJGBh9EzCQnHt2++xzcWpAF2KKWLxrN0t1NWRkUQAzbprhjG8vUO3YjpVjbbWI/Ndp9/f8YFs6SixUEdGBBmXK5GkwBS/apbBinfGLWr3BxpSEMPiczGip/2iaPYwfQ4EqkEf+FO4+eMeowtuKHRhp92vikv0rj2QfJWa/RXHfRDmThaaeOt3c53yvFlxgfc5KsRHiInLWsKHO6gUBgwrzZYq0TaHB+4I0UdhHoqvJi9z7HKTX0zZynpc+GCeUrg7ZxdTbnhmbMiCaBNTBv8uO0Upfq0QxAeFybnlSI1K1+Xdqpt5uZc0h1Y/rqY8Vt8bzWu7xa+2JLDtum6ehoxM7bF8g3x1/Tgmk4oVSGBe1JIjfmihCEx9sB7hEvoslsWP0NDTCDyCsTvby+7hkDk6RCtmvyKwEXcy1k89hIGKC6Ko0RoKISpOsNpZaZ2bZTE+xASL4B3ffDdS6HhNgTmwwfEOHuZAmTOrwHcKd4GU3zbh809zVRk9ItaPcyVHsY55cYANrWTx+cM0iF9tmJcgLqozKdmXzXSCt18G+TjBTqdHgXplY+JVGIk3lpVX45au0QlVha+5KS7yJVkHf/muNuaFb3Ees/tlVEI670492EL6K05VR73jp7rvlgOTFnhAV14
 lcP5CGmO
 l+ITlcsIza5PgxmNESwvMh47R34r+eOSOVgRwUkykMk616DXm/+xI2hqiZizbfdMm6v2BqrwaP58iL9RpfR7Uz4UiK1CJV1tJoGLvEYPtH/9qS+Yw9dO2C6iSMWt0pRRv6IRQDU0dx4AWg+8p7bvR8Fc5RfDXgYrrjp0Dok6mc7LTfN/h6WeGuvechTKw7CLUjBwTUEangximeZDiDIgAh0iRNIpaRWXAVOCX9VGXTuxLdnvNyrzQnWH+Tbz7HR6wtPf2qC1sg55L3GH6MD3TjSgwcj4Twvq2I8bphKw528+A0BVYGWbqxEkx9ewTxlMzM5ADzwp0cT+4MJBVvD4/Owj8ou4ZdPUQUa3CJIe/xDMtxgQ=
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


