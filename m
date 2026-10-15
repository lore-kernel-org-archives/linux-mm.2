Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE529CCA462
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 23:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEB4C6B00A1; Thu, 15 Oct 2026 19:33:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E75656B00A2; Thu, 15 Oct 2026 19:33:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D64466B00A3; Thu, 15 Oct 2026 19:33:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A74046B00A1
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:33:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C50C160277
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:33:23 +0000 (UTC)
X-FDA: 85326464286.14.6B4AA07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 77EBAA0007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:33:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lt14ELye;
	spf=pass (imf25.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792107201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=niSvj87XHsN4hGzJTzuoChUeOadlniTEmyEjPH++0pI=;
	b=LXVzra7jgp6vPrBcFG/oKCKjnTeaGIxRM8ikeqLT62INmgRXeU5H+5iwxUDhrjCcxj1HcG
	DJIGltl3R932H13vM4l/MDjFIxgi15r9IXgxCHYWHALFRD/DWnFV5qD0XguPJitgXS50gD
	ATSs23G8D3vXhxMmP/puoo9XYHf5PKE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lt14ELye;
	spf=pass (imf25.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792107201;
	b=AsRevkkSiYrqwcS7QMS5b3xzu9M+Ek0SWgl+re3sDXKRU6FStwyclrv9KeYDPMlyDeGtNC
	bdrIog4Hsl1OJXkatLAIRHsNu4G14AcTA7c9fyHBkcDTW1tANlFrWwCTqJmmTdnXIOc0bg
	z7Dk+CboCiuvqA0cqcmNz7Wq8GK4fXA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0656E60A79;
	Thu, 15 Oct 2026 23:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8531C1F000C4;
	Thu, 15 Oct 2026 23:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792107200;
	bh=niSvj87XHsN4hGzJTzuoChUeOadlniTEmyEjPH++0pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lt14ELyeoZXK4DAzsbJV1yXi1vtxQngMgi2Pvp5uY3dJGqQn80iRdp/nE2oCupNH9
	 9XvBqlZ5Tz2US+3/uZbNy9Q9gp3U6CKkAszrnvuz5yZVVjh8AR/BDgmQ7QJwasJYLg
	 bDlA53dfklAzUtNCpGgaGxfxI99e2VEM7wt2xQEghneCJKbWBNs9M061HBsnhlE3Se
	 8IwieEtNq93YJ2yKsz468+yqOr5NUko/f9fttut7JEBSGaFOCE0KBFPKhRbuOswE/6
	 mjptfd7jl4GOoea9tp+FyUic8ZyHvFhzNokbsDHK6YoQQlOysUMtW8hibdvmjPN/N3
	 u4fx+i+ju+SqQ==
From: Mike Snitzer <snitzer@kernel.org>
To: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>
Cc: linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH v4 08/10] mm: expose WB_DONTCACHE_DIRTY in bdi debugfs stats
Date: Thu, 15 Oct 2026 19:33:07 -0400
Message-ID: <20261015233309.42999-9-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261015233309.42999-1-snitzer@kernel.org>
References: <20261015233309.42999-1-snitzer@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 77EBAA0007
X-Rspam-User: 
X-Stat-Signature: 7bynzepymbbfzp78wj5nmzgrn5pk7zs7
X-HE-Tag: 1792107201-635023
X-HE-Meta: U2FsdGVkX19foFLPbIZfHUvH5IVyT3jx2NvFB9KCr/N1YuP4NFgl6IMHPA2251WvMeFh4YetI1LHWmKj9X/JVwv6PJVtMwtchbQg1bxCFeZy/lh+5dyf8AZhBLHUayIUm8ezbAJAa1dpV5mTCHKYt1Zr+Ep1Gp1keCT0JWxRr+zpuI2UkUUbn9TzoDlwIyP5DiMNVsmQdsIw+60w+FnCN42Vd/IfjAzcXxBqBvweUHWgh3gYgm4M4v22iE+9lG2go8eBYFy1qQ6R66hSscM0mNd2+dxUGDGDuNDqYojYy25bQAEv/JkYJL3H9U3AvZznnnZTrfNc45euxmvLOM8/PiOSwm0YmN9U3Swr40JVl5yxJWY4Sbda+gZr3s0rto73CD1EyUB/aaG+r/izp4RbaQ4lgm7nnTLxQSb7s2CJC4j1EirJHnr8XauAzZI2nLUbv9nGtlKuKLUvQiZ4AbblRjDF/BeQqi8OZwl5o3CKIALa1ajaxOhO8GvwdcitFGaJfiZ/YLhdOxppWZdTjRzYUNL0zAggDlNJrTCBb1c2G9fNieKG8C1PZP6EosOjXzbQnapNPGM8vPpUQCbrzE3rjN4el+LN8/jRBsI9gPMZtPpteLIbNcNWiisHCvuBx1FKecmpHciBOg7nBMy+UCKVhc5xHUbB0Ily/qwzKPdiMluyvrelrlaj0ffg3ugk/Kca8pQFhOb+R/9ymZlOjuqYzx0UjTW97WvH+UKHjYnXHtt1iI/m6m7Gkli8DgV59ixeLT+zju1cX6/qz8JK5aqGp46hNEL1K26QvnmXAqysaBSJRdbuwoqB2HcepfhjaQ5nB1FKD1C8ee5YUdM5e43EzK1PkOWPkvq9MFYQ649we9mnVwTRI6z5yb0VxvMDkSV9MefZ79QiMuJdY65BuCa4tUDHRdH2RgE8Kq5wbDppz/vCFzKMrNxBauwbSlyH++zul/DzQFGx1qlgc54GtNU
 YJ25zjCx
 JsJjMr9Ofe7CUw+iTp4du9mMiSET0bEgY4rL3xOfFNgsPmbxP+r3hEdjmXaD0G4vJHuKH6TIq6a/UzPKCp11pii7b8Tg0DWS04FIqAdTkiRVcN5CByGKm5oDxTW0vlSWubldPoGHXyodeenR7H9g4cdB50e+zUHHjiOCMWkSSxakYCWnccnq344Lt3/a9+yFnIGWONJm8YiPVgkI8ZxUgE2Rgem+h0IUYRebY08PsQl8NgyGlnrPD8NEeXRajwjxOyf0gwB0kb2JfbTnMfMNFo/nTBAfydJ61NJ9YS5I9mNtkubH3fd5AVb1jcDv6BkAwV22ieNBhU2mI6Z2ZUzH68q0nvach67lQ8HiVrJkdBMBhCFITlOl1q1OqdRvjDX0Avz/vrIxSu5L5zOPt7HLUC7mrrMQy0ayeDnKSKTZ7fWPdZ1QlVl6Qs56XgLDxuHHD/KfrtcD7DY+RL/fa7VHU/+nVZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: linux-mm@kvack.org
Assisted-by: LLM
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 mm/backing-dev.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 18e999053bae0..b8a2c27e07fac 100644
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
@@ -78,6 +79,12 @@ static void collect_wb_stats(struct wb_stats *stats,
 
 	stats->nr_writeback += wb_stat(wb, WB_WRITEBACK);
 	stats->nr_reclaimable += wb_stat(wb, WB_RECLAIMABLE);
+	/*
+	 * Sum the per-cpu batches: the dontcache flusher targets this
+	 * counter via wb_stat_sum() and small backlogs would otherwise
+	 * read as zero here.
+	 */
+	stats->nr_dontcache_dirty += wb_stat_sum(wb, WB_DONTCACHE_DIRTY);
 	stats->nr_dirtied += wb_stat(wb, WB_DIRTIED);
 	stats->nr_written += wb_stat(wb, WB_WRITTEN);
 	stats->wb_thresh += wb_calc_thresh(wb, stats->dirty_thresh);
@@ -125,6 +132,7 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 	seq_printf(m,
 		   "BdiWriteback:       %10lu kB\n"
 		   "BdiReclaimable:     %10lu kB\n"
+		   "BdiDontcacheDirty:  %10lu kB\n"
 		   "BdiDirtyThresh:     %10lu kB\n"
 		   "DirtyThresh:        %10lu kB\n"
 		   "BackgroundThresh:   %10lu kB\n"
@@ -139,6 +147,7 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 		   "state:              %10lx\n",
 		   K(stats.nr_writeback),
 		   K(stats.nr_reclaimable),
+		   K(stats.nr_dontcache_dirty),
 		   K(stats.wb_thresh),
 		   K(dirty_thresh),
 		   K(background_thresh),
@@ -163,6 +172,7 @@ static void wb_stats_show(struct seq_file *m, struct bdi_writeback *wb,
 		   "WbCgIno:           %10lu\n"
 		   "WbWriteback:       %10lu kB\n"
 		   "WbReclaimable:     %10lu kB\n"
+		   "WbDontcacheDirty:  %10lu kB\n"
 		   "WbDirtyThresh:     %10lu kB\n"
 		   "WbDirtied:         %10lu kB\n"
 		   "WbWritten:         %10lu kB\n"
@@ -179,6 +189,7 @@ static void wb_stats_show(struct seq_file *m, struct bdi_writeback *wb,
 #endif
 		   K(stats->nr_writeback),
 		   K(stats->nr_reclaimable),
+		   K(stats->nr_dontcache_dirty),
 		   K(stats->wb_thresh),
 		   K(stats->nr_dirtied),
 		   K(stats->nr_written),
-- 
2.52.0


