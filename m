Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFF9A606A322
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 22:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iB9+h97l
Received: by kanga.kvack.org (Postfix)
	id 8C3806B05B3; Sat, 24 Oct 2026 18:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FCB66B05B4; Sat, 24 Oct 2026 18:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EBA36B05B5; Sat, 24 Oct 2026 18:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4EB006B05B2
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 18:12:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C2B9120510
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:11:58 +0000 (UTC)
X-FDA: 85358918316.12.597876B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8A7F7160005
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:11:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iB9+h97l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792879916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nkmr3kD+iOFE6eqQ744hZb3n/K7IlKbFrJJL5zbx4VQ=;
	b=Fo/vVta0DWvU9+fONjvlFitct014IpuSQQZvyXpOQmXQx93bFNvOHeFmYNQ+5Awe3M+YQ4
	0kK17F8ZfsUM7Od7aq9WtT4CekgGy8GnZFBFdVrJwJtoySWpcCbO7sHtpdm+FhRRn2P1GZ
	GR5wuCRLhhuvecUI1fGs11ATfRMBLss=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iB9+h97l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792879916;
	b=N8dq8PqLOd2LeJr+ExPvRTrDh5OJfMjVrDbfEGSwCrIKF0NDLcxNAj1qErBkWjUMuHO15s
	RHGEm9wW3fi95FVB82DKv7CJuDMOMgj3sif2xBwJaPkczcnG4J+U/zOOPeHZnE29OtkD/h
	TpM4UmJfn0xgh6DtxdzkmCS8Nq/oinI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DBD614401B;
	Sat, 24 Oct 2026 22:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB491F01829;
	Sat, 24 Oct 2026 22:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792879915;
	bh=Nkmr3kD+iOFE6eqQ744hZb3n/K7IlKbFrJJL5zbx4VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iB9+h97lnqbFIUEl6O6yT3Xb13lPC+ZbQKXE9IlFhn5LhuWI8PD02Oz1MpQNBmJne
	 oxNS8VI3btkX9YItlGn9QKGgatxCJcJp+QEyL2H2BehjH3PGGrgx1AKbirxeroFhai
	 74OdaAYjGNzDIl76wRdapycLGUfxnNFyOlnlaJDC8oXBo4B9LZeMVo3Tn5I7Iq8ay7
	 WPtsrf8y9mvV7a5IoazqW6LpKVNrvYvwW8OO5p01kW/Ij4M9W33S2AvTW1QXyNhyHn
	 GsBrDgnTlOX2v7P4C3OzrbWJBWVH/J5EUYRPMGPfauTtPXegfAYePAyv1ul5HDqZfF
	 I3HdFZacSjiqA==
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
Subject: [PATCH v9 2/6] mm: expose WB_DONTCACHE_DIRTY in bdi debugfs stats
Date: Sat, 24 Oct 2026 18:11:48 -0400
Message-ID: <20261024221152.6965-3-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261024221152.6965-1-snitzer@kernel.org>
References: <20261024221152.6965-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8A7F7160005
X-Stat-Signature: ofxntdn7jnijtoh599cp3t15tscwc1fo
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792879916-98992
X-HE-Meta: U2FsdGVkX1+dD9jgxMPZ6jPd/yd9ecjeSkMKQWwsJctcyKNfZhzUbFCFPsoiplh8cq751v3aELlqLYQTKELDnBLbCr26hFLp8TWQuWtppjtc8eZ5cQOUvYSn4orviejbRk1ljNdB/LoJA8kJ0ehNjeY7SuS9h5Pb0mIbqAJt0wWy2mT9DV8MMjBJ4a/R4hla2j4R5j1ybNSCncouNToW8croEzqk6zt8QLHCBjiW5NT53mg74svrrIo7Yj5SKxUMOA6mRX0+LxTeSqQfFdp00o9rnv+ZC9bNLKzgAfWjpZpR/Hnyxwln5pS/Tya0RmRr8GZCUbPICYAOfw3AeF1S1InDPiiL1NsTaD+ujugOau5y9/KfeVUXdkfGOt4WEgtQ6hrAvIdpO6hgvE1gyFW/RU7BA5PFYg1PNuanDnUYuFKaG/lO108SKULml7tgasu7AGAVXyImyoOeo1TLAKn0Qef+sfA/me/St6skcK+GHHSVcbIdgtjeHY4FnJ4f1iKNnfVTSIbefnf9UMFP7t+l4YdgsE/XxI21xR4ZIwUN4e9rkWszsg6qNg5U2QZo0a0W4otFfkn3rW0WjGbdlloPPFSIkPqPsHu+mNm/V60sEUbtosRBf9RQeEz4bkocNrUSWSEXm0BhlUZNgBJP223sM+JDihfd3ZslX8ZMJrUZmH6n1HaSxvSoSWX7FwanL22/y3FX2Ev495Z8OpIOB3fXC2BwxBTANiRUUvT2WuwzCKfNKEFfjV0ndZd3Km+hLn5NCYgq0//EcFbbGQlVkRHE4ES/nsnmU3TkmRGiSRQPQ6rCWpLo5FlOV7wx8+TS5Ue5grI5hMelw8xzvrqWyz6vFfUEj8J7GN+56159OtVHR1evm51rZW4zgo8jd9d2PbxFojZ+jGRY/kj9xDM7tx+NOTvQY7ro8aJ2vKiWPt7oQ6KmrqzwEkO6z05V8jtnLiSOGxHVI5wqoixC8TE8Vp5
 4OiajZ9g
 BYeIFVEDh5LiZvNPN8sD0k7a3XEyIf1GaAVakZX0BZrBcmLoVJSJtmn34TpAvP0DNGqaroH7o5Efx8RoOUJtF2dTj/wfyL7xZlSugqO/5yKlGGjVPYUtQFwA9DCnmtZe/6QgIogpaRq53YiInmQv/gW6AUV7lcHXvH0wMXLi7Z2fNgPkO42g1Kz2ZCB50Wd56FTbHeXtORTbiSYzCeMFCj68vhZvL/miKvPtLN7bA/QgW38tNNN/CKPYuwms/gl+moJACxpxeW+BaWZ01CoA19C1kBQOPTzOL8u8m6J09CsJMD7LWaSvqKAkThzx3llvi1eWxNhiranuXuDd2QxQ9VTLGdRupe5UxnYKTDO0J7zsOqxE=
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
index 18e999053bae0..111b452629796 100644
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


