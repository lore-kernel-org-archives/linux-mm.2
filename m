Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56510606A893
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nC++JG67
Received: by kanga.kvack.org (Postfix)
	id 7B50E6B05B1; Tue, 17 Nov 2026 21:22:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73E286B05B5; Tue, 17 Nov 2026 21:22:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B346B05BB; Tue, 17 Nov 2026 21:22:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 477FA6B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD667160637
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:35 +0000 (UTC)
X-FDA: 85446641070.07.6F7C2FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 38A17160002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nC++JG67;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C57fSdsXcJ5YLRwB6q77RfzZshy+TLbem32PMMf0Xsk=;
	b=fDPGOkIt6DrKDWeUMSXLkhtZ/AMiH6zn4d7u3vK2HFYwhTWbBX+nDEiydywraKumHPMrrO
	EdVCiVSTUzdoVOwfVWopMSn+jRAZabP5N3VciisXn6VhaM5xDTjP4pMzeZ5C9rRs36zy6X
	BvceC/5G8lfC9qWUkaKmsaAi1OmdcX8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nC++JG67;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968554;
	b=h++rkU27cdDlSK7QrIcWWCw9xLVo8dDalw6GHVKoOiS20iJ/i7bdpy1ZSpbnqqEncP/XCg
	HRJGeWXeZrAeXbv+fBsYfhkSMOSk1SMV9th7WCMRlcHmy/za8oIBiEQhoCjEyScp9ZLkZH
	Ti7f2TRzuTf0Hsu19nI+Zb8u0JAEGsU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 797A842E6E;
	Wed, 18 Nov 2026 02:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370691F000CA;
	Wed, 18 Nov 2026 02:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968553;
	bh=C57fSdsXcJ5YLRwB6q77RfzZshy+TLbem32PMMf0Xsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nC++JG67OvodX7YCUzxqOSda3I2OMlBtEcWKzg6EkbYO4taqtoV30yM/okz8P9qx6
	 /zRNELjF+7E0yvmzugdWui4CaVvvR53mkrmPw6xR4vZRT+8aRp8kgs8eAIZ4kF2XXW
	 yjhomMWrHD0RIY0+PTWN/1SU2RedG++a5Xr+l3MQ5jM8hIiCovsB+v9ONRq9kSNP4M
	 YTlJaZm+LPaT/ef9s44Znv+0AqvOL0Omgb2NRrpN1EV6mV4RjwVDH/HEK+pl5PyeIJ
	 fPKiLswVxKfFbs4I6ua6bQglHs5OnLw4uYHikxy4tk3tiPdLkbIQkagCXUOf+1TdVx
	 85KJIVGicYjcQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 02/27] mm/damon/core: implement data attribute report queue
Date: Tue, 17 Nov 2026 18:21:57 -0800
Message-ID: <20261118022225.100659-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 38A17160002
X-Stat-Signature: 7ojsg4fj8oma7xa5o5m6t5pic4uksicj
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794968554-243832
X-HE-Meta: U2FsdGVkX1/C5+NSGOpNp9/FAeMeOogRWAI4bdG1+rvcdTGAStTOZfSnqHKS5FW47XDYU6B1mnmKLhD1PWPCD+1KhFQ8yt46X8ZIEgN3EliVtS/JAASvLuFl5AD6392SbbNa/1AKAeIw/PF5GxYGA0jZmvdNZmhpIbfaVkn3PQTfDaXhS07qRx5mNbE74dh/baggeF6K1kNex+jBpHWfBiUhzOx30+L8TkShqivbvk7D1oIQtLf1tPfa3DdBpHqlifUwqnF4nN9/73r0Yb7kBcQ1/HJO79b0ICIpe9AVs5wYf+bbsa9du9aP5dYUsCbjUQ/JF7JzPzksYWe4AdHhjJKW3i8mJVQ86QdgxyXMdxXGjb5HjO0n3nPNBCX7BPumj3MLDBxFyL8FgQr0Bv7WWFGN+OcgvlKdpBouazRv2O89AtdXGbRZ/SZbzST2qvEVVdovu8PUSswlk6p6i6KIZAjtsS6Gk9qcMRj9hmp9/CcF2t3xjf4D3Sca8r1lxbRCWJbIrNV9dZ3euPAeqhE3P9vkV1ifecFlOLrbZu9WdiQdV4eLXF6QjIIDGjAGqFHVJfOChtIV+ymUuAmL0C/nQDZLmpBXLqVDg7N4ZrUEf5E0ZCG2g0dJ1f1O3HVBVcA9jdhfHfbo1abOqFWgxsyCGoLkli4Ii/UJKSrbj7P+ghy1YCTnGEgPyZT7LnCgdUrnFxJ6siitjfr+h9KCzS9RFknC9BPtk9ZPNMMONSX6cP1tI569F9bUUqilYN0YBg8MwrLeNOc96yxJ1Tqd4uAVvsGdnnQxnfFTE9f+FbINXe1qyJrtVdwg4rmMbFSCeazVbRyBksVaOTzYj41PrlIuDpiKPT7IRGmkKqPz1oLrc7HiCBhHctXQ3HJyXD1aBA5QhKDlLzNrJZbH9Bk7rWnHtAGSGy3HZe8vis4JKDpiV37ljPGDNhA/IJinjJ57INgUyjjTyU+gphUyiunXag2
 arez3K7K
 +KV9D6lBFF43x9yBgSa+/vJUpufIUVQfS06EruuD483IN2E+/Z/dR5VvxqcsOSqd+gEIHarTLWDIt+xUb+o7VoL4D67hPEhKyCsvMpkS9g4ihLqvYJEy1ZjkNE+05n5xm3/nTaK6yqSS2uebN7cPMgS0fn+mkXFPF7I6H7u5yej3hYkyCFsmCECYngXGz1lNlohoaAGfZ1UiH4T7w12ujJdkeEGqJ4rNHFNVyL+R2vJX1N/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement DAMON core internal data structure for queuing received
data attribute reports.  Initialize the queue for up to 1,000 reports,
inside the DAMON init routine.  Destroy damon_region_cache and reset the
pointer for the queue setup failures.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0a056949604f9..0e9c1079fdb22 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2334,6 +2334,25 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
 	return 0;
 }
 
+/*
+ * struct damon_report_queue - &struct damon_report queue.
+ *
+ * @lock:	Represent if this queue is being used by someone.
+ * @tail:	Tail of the queue.
+ * @size:	Size of the queue.
+ * @nr_reports:	Number of reports stored in the queue.
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
+static struct damon_report_queue damon_report_queue;
+
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
@@ -4308,7 +4327,7 @@ void damon_update_region_access_rate(struct damon_region *r, bool accessed)
  */
 bool damon_initialized(void)
 {
-	return damon_region_cache != NULL;
+	return damon_region_cache;
 }
 
 static int __init damon_init(void)
@@ -4319,6 +4338,16 @@ static int __init damon_init(void)
 		return -ENOMEM;
 	}
 
+	damon_report_queue.size = 1000;
+	damon_report_queue.reports = kmalloc_objs(*damon_report_queue.reports,
+			1000, GFP_KERNEL);
+	if (!damon_report_queue.reports) {
+		pr_err("report queue alloc fail\n");
+		kmem_cache_destroy(damon_region_cache);
+		damon_region_cache = NULL;
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
-- 
2.47.3

