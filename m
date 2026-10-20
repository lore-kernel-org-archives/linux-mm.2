Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D207606A325
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 22:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=hammerspace.com header.i=@hammerspace.com header.a=rsa-sha256 header.s=google header.b=dyyXyaRc
Received: by kanga.kvack.org (Postfix)
	id 185526B0568; Tue, 20 Oct 2026 18:03:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10F576B056A; Tue, 20 Oct 2026 18:03:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F946B056B; Tue, 20 Oct 2026 18:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98BA36B0568
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:03:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2C79C03C5
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:03:53 +0000 (UTC)
X-FDA: 85344382746.19.0F05099
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id C1F6A120008
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:03:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=hammerspace.com header.s=google header.b=dyyXyaRc;
	spf=pass (imf29.hostedemail.com: domain of mike.snitzer@hammerspace.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=mike.snitzer@hammerspace.com;
	dmarc=pass (policy=quarantine) header.from=hammerspace.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792533831;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KYIFZnbJ/tQXvMmHyoqaiwEU9dnEoX51wTobPwpbUYk=;
	b=6o9QctmMLrOt1B1AaoSDB9L15bjlZHtmc6p48tvBzE1EsxJh/1OV+Dw/taNNqtZbMZDsqv
	2d+tZDJvv/h3GLra0DvpL23rZjVW9PZcjCeHPIs3Sadx9cl7VobNCtBhfOxZkjE8Up2rgh
	HYXF0hnJT1YYotFHkbOzeW57u3NA4SM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=hammerspace.com header.s=google header.b=dyyXyaRc;
	spf=pass (imf29.hostedemail.com: domain of mike.snitzer@hammerspace.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=mike.snitzer@hammerspace.com;
	dmarc=pass (policy=quarantine) header.from=hammerspace.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792533831;
	b=fggzmSiZPvD06wVU3uCQOBuuv6h23b8f/CAzjaW3xN9cabqOWt77VFqPaI9CXU3iDvsrye
	xuM1JQ3d+FacN6rx/m0gXfXdOOIp1qhmYb/ehFJwfWgQuEgZH4TWXRjU1PmQRkruQr6iki
	O8Vu3iM1h8XpcBT+CTStuFylj8YN6cg=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-91b834592afso1650696d6.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hammerspace.com; s=google; t=1792533831; x=1793138631; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KYIFZnbJ/tQXvMmHyoqaiwEU9dnEoX51wTobPwpbUYk=;
        b=dyyXyaRccHrhK907YxuYR/IDIby/vKYF0zzVcRLKTuiPwfzWYOQ9Bfjm8iT5+CdHbf
         7xOq3WMSRHxQuAOrQe13xDkQdMC4OpqH1B7mG1Jx0IoCLb566EnQizcdeGZpEib2E7F3
         boyXLwKLJoN0wcJzA1c6OCxoI+QqgGcffKWlBV60MKexx2PY1olcgb6lVEQNU43Ra3IO
         XEcwjsvu99TBTEYSMsTs0khgNn0M56IqmIRab9HrCOPvSlLIGF1D5ti8p20/MQHl3dWg
         iTzXA3s4mLYH7SenP3pfzVQBs5JiV0s9jSoug4X7Ooj4MUpO/0rUkd7Vof9Bf7rpXVCO
         EVWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792533831; x=1793138631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KYIFZnbJ/tQXvMmHyoqaiwEU9dnEoX51wTobPwpbUYk=;
        b=kGj19hx/O05B6gDm6LlFjrTWamqxpnvGBMrpVSYvJ/JTo43ANgSplhQvdoGVcszQqM
         8ToIFKQM3gUG8Bd55JNsQ5vDbY7j2Bpc8jkwL6OUmGSl0ds5Up4IXww0cuMec5NRCA4C
         ZsqQgVaQ2N2uTrCCFrgax64hJv8UEEGroBvV3gYp1SmdasuQeyc5qPotPDoFYbGwnU3u
         2CSDtDXWSAWorENNaL8GupL9d9n7JZI/FguqIKV8HpI2O/thX5MwTQtDCRjpaU52jtds
         F3ZERJhiut2DfyBv+KnB1/Z8bPPK8lUdLRfzVjlWjk0YTOQdWZb2bFcBnpyhV0wNveVZ
         FuIw==
X-Forwarded-Encrypted: i=1; AKwUvBzK/NpgouyeSNea8mRJ/EMysiqCxEkiYndgv676SOFrmDKqgP72I/qjPLybIdWtfp2EAFFuGoRqRQ==@kvack.org
X-Gm-Message-State: AFq9FYKNTiafIJfYOQK3kzQcXvnKrYozYmtL28qtlh3jle7C3tN9uXCE
	uVy4/PFQG+2MbjfzjzDbG8B43lW1FuMaOE2aocdYifVcPeEoYHQSsGTeVIMy72x0mug=
X-Gm-Gg: AYBFou1iuRQFE0BB4J1UlfMDmebxZO9N72FykN3yMn5ohCawSgwPMnvfy066xZ56kR3
	c7Bz5hzWIv/QVPtaei1guQSmdMtviX72+QY8x5AyH1vS0n3vFvaTOqkYwBPJalD0WY2M4qHwJTd
	Q1lGN8BaGfl2Ze2B0eXDL/wyL//FIONmiUh0Hx8MxpOGkQHv3YfrOEZU6r/k0fHslRNTjXij051
	21AE2BfXds+SijcXe63Vl0gFdJzlxfAoB6TmBueHYL68PzBe56Awh2HELY/+9wDjrnFEiO6wVLe
	7taUvM8mVQ1JFhfUnK+0IyxhpDcNFlPge3bxTXeLhKF3Eu+CI8ra5pQ3esYmvFfnKssAsMWIzZI
	G9JgVXmAPyggRfA/wr2fNTTjHSBQry/EJ3oy1cFPN6ZZcbQkG86YbGoF3Wj3UlCtJRmU174CDv1
	YQYLxNwjP8+f4vJj4HBi2Ne2474VxLvfBZ0DkGP6IyWg420BZO+gOaF7CKV7QsCHERPVwJ2ERlx
	n6ltFgQUz1KtjAe6QdpiZyTTpfe5mOeHbwfljGkIvk6VjSsHpgnOEjKLLTn5LsdAAQinUXTE+Q2
	4/qmki8dzQ==
X-Received: by 2002:a05:6214:8623:b0:91c:1061:f005 with SMTP id 6a1803df08f44-91c12eddb7emr2552846d6.20.1792533830405;
        Tue, 20 Oct 2026 15:03:50 -0700 (PDT)
Received: from localhost (pool-68-160-167-46.bstnma.fios.verizon.net. [68.160.167.46])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c116fa63bsm6647676d6.36.2026.10.20.15.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 15:03:49 -0700 (PDT)
From: Mike Snitzer <snitzer@hammerspace.com>
X-Google-Original-From: Mike Snitzer <snitzer@kernel.org>
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
Subject: [PATCH v7 1/5] mm: expose WB_DONTCACHE_DIRTY in bdi debugfs stats
Date: Tue, 20 Oct 2026 18:03:42 -0400
Message-ID: <20261020220346.28020-2-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261020220346.28020-1-snitzer@kernel.org>
References: <20261020220346.28020-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C1F6A120008
X-Stat-Signature: dfzbhthri9ieitzk1645xazhypy5oghp
X-Rspam-User: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792533831-36838
X-HE-Meta: U2FsdGVkX18fWng5Mn5ueGPpxNpZDJly6VMhEB8oII5gxZh0Cy4f3JG9/L3n5n28Ir4tUn+b5gjHGsoMDRSAyzI5TokMpmshrRGqq3A/FUZ20IvxYrF9St15LgFJY/GCpJMKHANx4nPEKzDAOM0TF66QZvMFsznUi+Tu7NXyNZyHv9IqX+3OrMAjy+naImt85A/OZHYIXCs0TrMGM3NM9rD8U1HT9o1q4FjNlnXZVdScgWy55h0Vr9ckisWF9nXq8Zvvgx3382C7aAeF5f00O5LxdZ4txFv74qHEobPEw1+jaIv/iuPCdN94+AJVuY93Ki5jpTigz+RNJ2IbzxaNRI/sWzIzsUOCypRhc9RFYMtnRB0T+iSADuapT5WZ0tOkGLijB4f0fd7MKS4msamLvy7B/RaDA0LzbgtITDQEc+BcglWvppuOHUftWy/j1OfozmMfIOFjitGnfCZhsmaqQCg9KCjUpYnOvzVbxi9LzWWtfNfQ1FfqKD66Kb9LjBqf7XCF/BmAN8ujkbMenKRWqcDxxNRk26hqC21z8Nmw+CfnNtmkKN0NL3NpRoF9dVdd3muJd5q8qbNmQj3JYJTc6a/N+FNi8wLPH81o5FTcqLzi89CyAf3pt11D/cvEs3a3KzB6sUgI+Nl2j0SStfWdDSh8g8AEzCIrCTdqjhdcLU4zMMeWS1zI1f1zcs3BnqbxBciA9cFAc4egncAc0U5cSUp6zYdTR2ufpkV+2MZbq9KMOQQjwtM68tGKN8I45n/WdW2qclR0/JUSztAC10DeW96U4YHTK40Xh9npfPQbqiDe8tQjBkmTuInaHhmmhyi1oMtpNUwZBg9d2i389v3zZ9bWOwPxVp+//sPSy+rSaeijHohsSCgEwfZYpNUSuTjYNHJFjeunmLokw+q9rfBocjKnhEDRHO1DEBkDVi4Nt3yRAY/xYLxLj28U+8jLiGhNqmPzyUnvlRcjDLB1gtD
 y3UEwHYY
 YeRJSiP3dd5Cm9jDq5G2tZaYaKSf/IoemZ0VbWyn8W/VhmG781fXGOfBGWrcmIpAveSoZjTaP1Fy9wFzz1QehH4q1UXQqrtDcunOJsQS8coRIPSfrT7MQ8YSLEiTH+6mJGGes5iVf4lGOgQaJVtdF+UXn2YxWLiBN4o/ChoxeHujIytHSM4/WNR7gEuxd68G1qcFm4gK4NNRJuMMj8PoF1i1DJqDD9Io5oiPs4NT7KU5VeDziFTJs5rjWDBukiHBAIskS7l9FF5bglB8xdidKkjX92f1/QBNSUk7xJzGqRC7TbhO6jLbxzPtrs+BCxV6WYHkCM0zTN9mS7oM/6qB+4GqrZyRn0hvX9sO26PRVb8S5On9+O11ja7iJfQMUaEQ76fuPzdwa7pq2JGG5Cf41ifY4ElVYczoq/iYg6cWWiSpyp09w/tZX9cplrB6YUty07FKVbhNr4AeN4EJvMxyHBwxVSXwQV9Y/+FWrFWehV9POoJ8H3/W8HYUS0lipPQHmIrz9jYimHuqjDoVuwNCu2ngREuPuTRKU6SL+0lWly6fz+Ho/pN5cwE8yDdadXCd4WJRG3S8MTY5Dh1MLficIWKyTZmZVNu18bSEDBTPncmc09VecPSK/I6kAAg+9qKQvxG1Nx3ptdRTbzwFM3tto+t9S+Z4YxfYp8SornB5FhE+a052vYQFPEtRHIdlaJwP4dBkNtt0G3Wv7aTWjj/+3YHTvRfbRFkTcxiCCq+vuR031vhgTHvwMlWSfd6WkHQLBEN69aIkReoj0Wgg=
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


