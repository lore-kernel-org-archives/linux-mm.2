Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A8FB608484A
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q7/5HC2y
Received: by kanga.kvack.org (Postfix)
	id 5F2416B02A0; Mon, 19 Oct 2026 11:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A42F6B02A1; Mon, 19 Oct 2026 11:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B84D6B02A3; Mon, 19 Oct 2026 11:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A78D6B02A1
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:07:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A593FC072C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:07:31 +0000 (UTC)
X-FDA: 85339704702.09.789589C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 27BDE14000D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:07:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q7/5HC2y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792422450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KYIFZnbJ/tQXvMmHyoqaiwEU9dnEoX51wTobPwpbUYk=;
	b=dFxsYpRvyullaWj6J8GAAOPul8jlTvSFmgl6J74GGyNPwFR1ASDSbTXSMLHhnuge8uA4pd
	dpINkWxWUREdizGUCaZnRQ7pJMZkcW7lbouUXrICAk2dXuZEf7R3mAjTKD7KTnnF6i+hwJ
	P1Dj2TVRfJl8osFplE+atPQpU9TlYkY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q7/5HC2y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792422450;
	b=KNSvzeH53u/sfwrYop6O1gI1gFT4NNp6WPKdqN+/zJUXWDfjXQ1mSMak2cZH6AyMiIrYvq
	5AtYYJ+eRUYUmP+g6Rzxcm07DMN2K7PnJPaMMv0CtLFgKZiOq3l97lLw02VoQ4hPPALsOb
	GV+Io1jR156EU+IQHsJFAMjz+eIvE28=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B874E602A8;
	Mon, 19 Oct 2026 15:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE711F000C4;
	Mon, 19 Oct 2026 15:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792422449;
	bh=KYIFZnbJ/tQXvMmHyoqaiwEU9dnEoX51wTobPwpbUYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7/5HC2yuwRStW9uT0uRx6ddM3dspudm2S30vTdZhfxrJmdHNXGuppUxH6i1DtdhH
	 XjJjNTLHPLxrW+qWvrEpd8QN+onnmwyIgNnBd0fQwuSdK92xPdtwMt1w7M4+Xwq/mn
	 f2iPBxoQzG7PyD7Pe9C0ddHHi4/2k5vc/xBQBeN3Jth1U9QUpRRAYBhKd3j951VokQ
	 /sZR+wL4hUIgfRCuk/OZ791Cf+jBc8dVRwgXpTXGpeKjA+vV2F30ax7BGlHDmLNjPB
	 QO4zLIX/y1ygzGKb0ZtRKtxszT+/Cz4bUJLMDo/w8DN5pAkzhrfg/g0lPdI+dMDHY4
	 K/2eHdhpPreFw==
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
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 2/6] mm: expose WB_DONTCACHE_DIRTY in bdi debugfs stats
Date: Mon, 19 Oct 2026 11:07:21 -0400
Message-ID: <20261019150725.1507-3-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261019150725.1507-1-snitzer@kernel.org>
References: <20261019150725.1507-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 27BDE14000D
X-Stat-Signature: scdkhcgndmx9q9eqaw6wzt7execf48qd
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792422450-665003
X-HE-Meta: U2FsdGVkX18kYqRDwF+nDxhVEo69bvwUfZsRLuLlGT2BJAFItI7jUK/fTpVy8R3/83Y1CJfpINyVISghKHmKv8n1Z2nqZM10gBtYsB5aO2RztKcQXv+m3s2CwzfiJfZqNW2pd+R2yJDZq7BfV9LusrIhpvDtE4ndVkiHmutMQJFlbkS0jyjNCqzTqtH6k7WXKZyzDGFvyXipPmaxA3jPaVJUC/4O4mk9xgL8sdiwbZ3G1DjqoBvCd5pFg76k4Eoh7P9ZwdAtzN9h2WuEuEmDtIlMNEYvB019vHUVoR+fNLWil2a0SGswy+ck0OyagWXVRTyww/izBTG7TzJX1ljr4HeQhoZU4JwXzzj1RTZpykb1xwdKBBb0luTzM8lbNZgl63PNqWFfslocSZKVLLt80PJCNpu6uNEXdJT6FwkpzCA6YObfIrHGA6pHFtG+kEWzorx68hrAendzDwOoLJCkuzdCjry7bZRof0oR1QFBkLLEnR8n/EgpI045I1cE6d6PPimGQdnvRU5JnxvJFlgHaescNk0JWgiqjR6zV1sGBz7vqHTXbvBhr2EtEFtB3UmfNdCKyU/hkjCTdSkk7T3iovgcDe4SGidOXr/lx2H4pJG6y07umpDS4SXxaADu5ejVL8sFuvtvoC8N39+4lXvfcRYNCkl5nKPCd04HtH/8YpHrR9L2c4OsItA4DT2sWnbf3GwsSDCbCJUVlEii25I4qwISJ8ssNjuELPWS4CZjxSl4ZXYWZ8WFnh9TMf6GrxOiqeY2XPL9SeCuwl5oVQAzCJHuCxdV6AET+C3FRA58pCxKcSsyM20gNhfxyxGl8BfTqhgR9tlgtuQi/+48+m2J62zQhctW4MxB+WFngzaTMgSjI4Y94t7dfclDSEPbccyTd61NeZwPXDnSEptmB5jSjuTmZiABhEGiK1sxGfD7hrg2PCxdX3Orex7TpppQM02Pk44EstRqBEx65A/dWXs
 lCkDxFpB
 Jt8DfEW7kesN5DmaDRtrxrY8XiizADxIh8evYHISH25eUgIjQ1IRaSstOf01f25GxyaDN7M7Wm8a+o09+TNnOLugmoOALiC4pagUTs9gfyW8qnq2tv/4udfc5XwQkLy139UBuKw621TuNqUUzV2bYFV0CnWUOwd9iKHLr0s6yBqNQFJls3JJUqxQ0DySlBamnsj6Z7CZl45U1F1T1pPDBMCazoXufgpRaRaFboe5UYpPRyHkZ50kbm1VzvxtR71giWD6WuVvlhwpKgoshAdYvThLURTau5pfRyyY1gzKy6UaP2ED+rrsIrJF4CLQRX2MBzix2etGSA/K+9oMg8iaA3Z+ZbyP9rj0r2shpr5ZRFmuozvZffpiJI/fiH+IYUuPuvAJdQoeD9UmrAcHz0uuFP8iHwHs36KS9ytFdtMewJVBeXvmE3SP0CFMSUAetVj5cqLYG8rqjqK3F5s1ADaH6D8H7R3GGyyr/jl18
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
index 18e999053bae..b8a2c27e07fa 100644
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


