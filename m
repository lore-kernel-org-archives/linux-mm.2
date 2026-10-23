Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3A07606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 02:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JiBFwphp
Received: by kanga.kvack.org (Postfix)
	id 5A6B16B0323; Thu, 22 Oct 2026 22:45:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529AE6B0325; Thu, 22 Oct 2026 22:45:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F13D6B0327; Thu, 22 Oct 2026 22:45:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6446B0323
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:45:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68276140110
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:45:56 +0000 (UTC)
X-FDA: 85352351112.21.7885E09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BD92240004
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:45:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JiBFwphp;
	spf=pass (imf27.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792723554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tt8+p15e9DQsEZ+hqO3OeNWZ+sire2qJlEmWhnAKgA8=;
	b=y26WNqYs4oEqNwzXS/HGgdguHynBT36cYO3o4ADSl0QcGAsCHCBbYbX01v5TPntO1fbc2M
	VHjbn+RVW3UKP8qg1QbeDSNjfouEY9ryTVWxoNoKUmJ/J7WJk4KnRlIFVb2pULDbOHwK8m
	kqSfEgbyhTHfjlN+dWM9MQ7YAWchx1U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JiBFwphp;
	spf=pass (imf27.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792723554;
	b=SJ9toEtgOynDLpUxp30AZpYXUVaFPIiadd0iKK7D/w62YjFfm6ZcawEcSbzmebJhX79ure
	cW7Tfar4LrC7r0Qdg13Sf8dnq6EMRelMeu/wn8/4TRrrF29B0PTOxVGgBDd6eIPxugub7v
	SxCfcdabCVqYaoNzR+Dzm5lQUNe6xLc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15101447F4;
	Fri, 23 Oct 2026 02:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC631F031E3;
	Fri, 23 Oct 2026 02:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792723554;
	bh=Tt8+p15e9DQsEZ+hqO3OeNWZ+sire2qJlEmWhnAKgA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JiBFwphpQ2Zr9t9oVnbUSwSxH/ibLXGpQXw9XfkP/b8Kd1+3kWSUdZoZqHB5u86H8
	 h4a4iRVK3eNW2mS8lw3RrgQy2XqUjRtUZ/ICYL4oFywwJ6BRNwCCqQlpkg4UR3aHzj
	 8v92Oe67+bA8g2Oc+lPIN7UAVUoc/mXrMUv2AV/52ChRicBVrWjzsz5F5YT3YirBc/
	 l601up3GFLfdrCeqpBud6lxQhRXR29PlXTMQ3MNGwXPgMAjDq+w8h3VuD5a2a5Sjdz
	 43esOWe2b4ZRnne3cD7Ne6icV9zWQ8yG6iYUuB6VIcHnsfj7h02M0ZJTyZLfztEbjl
	 zIDj6jUROb+Lg==
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
	Jonathan Corbet <corbet@lwn.net>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v8 3/7] mm: expose WB_DONTCACHE_DIRTY in bdi debugfs stats
Date: Thu, 22 Oct 2026 22:45:44 -0400
Message-ID: <20261023024548.71123-4-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261023024548.71123-1-snitzer@kernel.org>
References: <20261023024548.71123-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD92240004
X-Stat-Signature: wifon6tf4oku4jui9xmfzg8576g5h536
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792723554-708775
X-HE-Meta: U2FsdGVkX1/0wH9gX6uEGHWPsoarpfhYH8sJNs6MIZppZtT1yY4ZirWS9xslHwMKAbxFSME1k2OP95YVkOS7/SLHSllvBH1zpZJaP1sBkK0vsBCA6G2NrhAXMf6tmCIBj8uKer9wTu+HP3e4Ra4T9Lf2BZ/j3E1WRMHg+wF+/sBhAPz02vFz+UpN4VxI/C8FXorZjNXZDDHJSl2HYwvJPpQ1E2ih5JCKZsDzT70CPZkduNJdZiW1Qx6Qed+m88G77oIOcvx+1xsMi3bqUvtft0Wsr1o6i59CjdeU8JPr+b+7esNcQfvP0udee7GbNa8nlL5w+ejzEujlPgcor7+swN6SZZdXN06KafiRBGfIdHKKcR0RRJN/avizSY3WtaRrpTw2fJZ5wFkAOwHZW6p7RE53ZDf6h9YdQVEazA9Dp91krc1M9mU65ef+3grJA1v2D9IctSDrhCEQ7QpQNhdlvkCOH2Od0+KV9v7srLIM5oYDQMBOxEwkvVTiQ1oqKZrf9/eoBcIgQ5f0+j8LrDMNebPY4j4FpO/lFizwv2dLBAOwrwyHB+Vvcika2NYeBuKut/WmRPtv1Tfv0LaGWNiPfmKuQGVtVxZDYaOvixIdcz/zKRZMbx906uk4Ifs88o14EzGAh2J5mXr/+2p7ctBoih/yvG/djAhXKJSBNeIfUljkUl4SG0rQ30EEsYEsnLsboTwoFGP+PjDalVnr23dxOO3gsfmnwmtF5+q6lRzNdYCXojvm8bmS/VkBghw/inHn6kMLFG/ar/Vf5A1s5GTgrzqLcrpqeT5riUmwY5sUbhDfaPikGTPBgvfkcNgAnjJWobsu3nH3QtRv7tU2DALRtxf1FpRZGxvHE4cC1LOBERmko9dQ7LYkUYIHDxuasAy5VkIuWOjsBBRe5Pw8kQGao5TpZfU9WBC8E8YLXJHMYjyhb1yXAqAaiJjA7fxh0ceeDy+ikepts/kTPDrBLDV
 qZFMnytv
 GVsydJtjrlJliMjyB8QHFgSE/D+IPHXbr9YXBTNcOph/up+f/+3c/hqt9wxviM26xPayvpYyjAwpAIHDcifj1VRtkaVUE2K+gAcaxjY5uRcWW5X13Gh6cBFzQ4YMoIRJJhUBo0fhBk3wX3z+G0L3Od77ubvTY8Qz/fn6/oFEnde33nPAnxZDNCHbKDVRHtfgfK8nQGMtoIncMH1eaYVqUakfG7bZ4s/6nJFzMraoUWhp5XE8VXpGNFDe7nqYj14/n3pV60whW+rBAotTM+P394ztaS3Iqfh2fReEavhJ3JnErlHcpcFoEG/qVVk/Vya7n9fD4KFiSL+OmqaXfF9ChewUIHsVMvatvpZw6AkeXF6kEeMw=
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
index 18e999053bae..111b45262979 100644
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


