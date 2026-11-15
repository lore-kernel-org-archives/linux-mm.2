Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C43606C40A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DYzPGt9Q
Received: by kanga.kvack.org (Postfix)
	id 8FA526B05B9; Sun, 15 Nov 2026 15:29:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882E36B05BA; Sun, 15 Nov 2026 15:29:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD016B05BB; Sun, 15 Nov 2026 15:29:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 40F0A6B05B8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:06 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 92F96A07FE
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:05 +0000 (UTC)
X-FDA: 85438492650.13.C70DABD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 116B040004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DYzPGt9Q;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+HeOpjq54P3hj4CFI7ndeEkKRYx17STvhME5Gvi2/U=;
	b=7UrbY8sz/psK2h7svcVr9HWLPUfZZpW/RptmFoOjfs01rci/qRy/yQKiuajndPNJ12/yku
	lptVoAYDZGFpsG3MGro4d3SwsmIPsOyH+Fi7BTzWhq6e/wC1liAfX1vnUVNyobMdoYj8mI
	E+9rNk7fZVq4aHPby0vrw1PMZwHbmi8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774544;
	b=PzZv+T6z8c0AUvGObvLuk4jBUxZNKVPZnwDJyJvEnmVEDKo6HgrNbkx/TxXAvLRES81AUr
	kbUeH4mAgTF4Wf0BKyWLnWCY3K8saS5ePQ1K/tkF8v+Qt+wlm6FCwyh/cMC/nTk/cQaK1Y
	YvdRh8dT0z6gGmmpKVRMeN7Q9XBBu5I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DYzPGt9Q;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B21043A34;
	Sun, 15 Nov 2026 20:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1101F000C4;
	Sun, 15 Nov 2026 20:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774543;
	bh=o+HeOpjq54P3hj4CFI7ndeEkKRYx17STvhME5Gvi2/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYzPGt9Qw+hksAwG4ufwgBQdWrM0ei+25CDBW8kAArPZWpPFIKezf6X4cTCdl8FZN
	 Ss8cAAgj4NOgTFpLzUJfqHfjk56++PYMiHPwD7b5EPI3ddXZzBc+FNIwFmPthnnp50
	 fEpqUSSQmyjbntPSQzgJ5J0X19YYkdM1bR3OGdRPjhouOLrvrJruFMjk5AAbmFDF6a
	 yki3C34upd5J2Wz/3E+yQ9m3PdJ68RnL+4QyXmIl+/f5Fs8i3pGnlQU8pal6cVPEkL
	 rvqLN+U55WTDmaInrdGfVcC+kFa3z2XW7OrDjfvnXLADLN01Mm90cvtvjXZt7xbIv6
	 sGkdrwcEHBa9g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 02/27] mm/damon/core: implement data attribute report queue
Date: Sun, 15 Nov 2026 12:28:20 -0800
Message-ID: <20261115202849.99134-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 97fuscizncuc3pz53u4trx7bnopfae3q
X-Rspamd-Queue-Id: 116B040004
X-Rspam-User: 
X-HE-Tag: 1794774543-919114
X-HE-Meta: U2FsdGVkX19FswcuinmihRZrJRhAbPNN3qQHvU7Kht4t2pvl0qcYUq30hwdz4WV1sVzINWF9wFUey/aNjSAOCBsk816Us2ua1mxoFCP9eG/svdCSYFKBDfcbN6zKfvgqEGw9Jl/UNv9nwqXzoejkYvbY+tncKXePAib4wCt9omDAL5i4N7lQrs0kkY2V1EWPBn5E3pF9vipNpVleXICYngid4jOJyHVRZj2gXeLrne761LnCUvDkiNUUsRhz1gL8A8YBcLS2RNc3EtahY8+UeiBhl0VUwuwP/fozGeR7XLjXXLToq+Grv9wknmpq6GCtRkVu5QVSs9WBo0EbQJZe7Z8N0Fja+FxKl7EVg06UZop5sP7v/OY9cWJamrSxUBGlhSRSO1OJIOu919mISZl4sr/YpilfqCcSWcbux5PN/zumEo5BBgp4QqO68T8dorHItthab2T4CHcshh41Eg7BUZ9pFKQBVwViK4v7EQJTs7iX1R6lihxYG0sWVBks/3MVxoS8khkDkzDyvPYWc07QqSyUuCBBoHcS9Fq7Jqg0ezTkwUHTXCmA+6vmXCT+yOAiMbxPtZD1MC7fnhmGIVX1GkRat7auDUa0zRwmcE2ExpXy5mpNMwatApnW/u+KmdcpVxKQKsdvHkWiQKjjB+XhNBq9I8ZFAvuyn9ZmiV+gF5b+sdKdJtI9jOs9w1d8LINiWCaOUhqFkJaU0td8qAKPA2GlVMJVQ71Hb1W8KfERKtKZEoZ59dmJL+868+bMdDooz8I2dXvyWaG5pQZPphCOmpboQ2jEDH+ujLHlRPmyLlJ23plVJ3W8Yun31v2tLrOtdjREQcL/5Uu90BPvGoHdmP9NbXgzbNrMa7rdQmbHCm1HD7JcwEzC8liIfCjOqBFuR0ovkZHOgEBGJ1TjTCdtylYF12EOfBWi8cD/DTDnofUSWlOkA86JXMsZXTqkVtdEmO02gZzvOkSwRm7mPA5
 WBGWFjwv
 rV2vYXcNbdiMC42HTUJbdHlyXdcY3FstPxnxBTVXnPmrSU0A5/jqznmY/blhwCaBhqp9ajbgJ6s1RWPkH46VyjcUbqRQiaZHER5d2/WUhFq8GZXdDOr3VK9umNYXYRa/pb6hyqXS/J7X3CylR3g9xugRuY5jzTrox8S6B1T1z6CsybguRA8r/MT05YjolmDVCa34B010szLySuboBlySUXSDEKZO4EAi1se+43s0zy++ovD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement DAMON core internal data structure for queuing received
data attribute reports.  Initialize the queue for up to 1,000 reports,
inside the DAMON init routine.  Also update damon_initialized() to
return false for the setup failure of the queue.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0a056949604f9..3f87a7eec442e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2334,6 +2334,25 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
 	return 0;
 }
 
+/*
+ * struct damon_report_queue - &struct damon_report queue.
+ *
+ * @lock:	Represent if this queue is being used by someone.
+ * @head:	Head of the queue.
+ * @tail:	Tail of the queue.
+ * @size:	Size of the queue.
+ * @reports:	Array of &struct damon_report.
+ */
+struct damon_report_queue {
+	atomic_t lock;
+	unsigned int tail;
+	unsigned int size;
+	unsigned int nr_reports;
+	struct damon_report *reports;
+};
+
+struct damon_report_queue damon_report_queue;
+
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
@@ -4308,7 +4327,7 @@ void damon_update_region_access_rate(struct damon_region *r, bool accessed)
  */
 bool damon_initialized(void)
 {
-	return damon_region_cache != NULL;
+	return damon_region_cache && damon_report_queue.reports;
 }
 
 static int __init damon_init(void)
@@ -4319,6 +4338,14 @@ static int __init damon_init(void)
 		return -ENOMEM;
 	}
 
+	damon_report_queue.size = 1000;
+	damon_report_queue.reports = kmalloc_objs(*damon_report_queue.reports,
+			1000, GFP_KERNEL);
+	if (!damon_report_queue.reports) {
+		pr_err("report queue alloc fail\n");
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
-- 
2.47.3

