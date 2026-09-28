Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F8E7C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24A7A6B009E; Mon, 28 Sep 2026 04:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222786B009F; Mon, 28 Sep 2026 04:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15E9D6B00A0; Mon, 28 Sep 2026 04:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E99F76B009E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:21:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EA34160134
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:21:27 +0000 (UTC)
X-FDA: 85262476614.01.531A263
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6F04C40003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:21:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790583685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YZHiFvpLd5DfH02qnQXNA0yRbHMexVIoa1FVtB7KmrU=;
	b=eeWousmL6uGRdxSDUkeVCeKt1Umr7jX9SPRIMExstmexYQjGSWxwqpg6vWe23C1Y1ih3NP
	rdwQ5e8xgnx69FCXUc5IUp23wBuUZRgMWF8P/2zT78AJ0AkOt0TOL0jKNdJB9sVMh4uiOz
	fSHby9UvcuDtJZC1o0pIfhFyetNgne8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790583685;
	b=ZIRleBCBExGZG1jlRYAB2Fypc54nERMkWpNyOX3GjgtVqCYSgnBGSMjrfgjF7IXhrQw8/B
	pQ5iHnBtfuEn3s+ecCX0CcSmFX+dl8EIAi8MHUD0miVJ/zuiVAohNvXBqwnedIKhqVmdgk
	7UiSfdbm/xHigoEKYPdEYeZfH1aSy3I=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 20BD03EBCC;
	Mon, 28 Sep 2026 08:21:16 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [RFC PATCH 2/4] mm/zswap: turn shrink_memcg_cb()'s argument into a flags word
Date: Mon, 28 Sep 2026 10:18:37 +0200
Message-ID: <20260928081900.4187482-3-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928081900.4187482-1-alex@ghiti.fr>
References: <20260928081900.4187482-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTEpuKzi+9nZy15nMgJyn+LYM68tVW6nw40rxZ2FTtj3LkINJ8XpzVdLNzm+4dPd95uwxkyI93VqgXgJKruJ5Zx87IWGb9/o5Cg0CIuB8fLJCUAhJCMsfIbCjrnaJ8jpiGh/113ZE4AwYUpMCteHajJRR+jCW0CIdVCAEmf3ip5wCzp3jqTh6yehydxzWU4OQncDlE0Fy9xk5KRKwDJiCdo8BzLvhyOaB28rIgpKDh6opr+ObwRBiI6Yzn3uKDeXjqYlaOgG/XGiiuJ96Ejgwm2eSNxFkynogMVHXUeYQfH4jxVmcqhC+6wcbD0TSVlZCcoKPR2vq/qFU65Hn1PjOKTnPF5CVTzvPT4crn7Rw6CeOm/etPj9O5fA4XnHWKmMg1BDdylPSbvxcpE+2nYlnYLiNPrMnbQp7OrNxSVHkjitjAVvgLl7C207BsVBVFyBlt+p6Oa9RLhV8hQhZYDrqH2ZuYh85onxqT/6kkScowRiJit2XbFOyX0fUt4iMngHQSHHw042D8CFK1m65CEBQV7ZDSDpAbJUlAcrDkLNpH5xIete8TfYe6o0vwg9BI56zPruHwFaAs91/NxDUrMaE9z2O4jQgbJBMpjl5E2dyZUEbdpXTXQma7NV0M215RavDQ99CU/jhJt+CF0XwqqbNCSAG/ktF6zdY3SnukjDhyYPUA
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6F04C40003
X-Stat-Signature: 9g83rw79rp4s99e39bsbysg8ph1jrfuf
X-Rspam-User: 
X-HE-Tag: 1790583685-571899
X-HE-Meta: U2FsdGVkX18AemOpzHJsBhK/c3iihxWg/oNTDa3Mk3+OWJ3ar+jq3oNk/4md9cStzIy/4GU4gl7WyKe5hDFTpZprqrIjAjm+kBQEdcEPQyuaV9BQZY8VCLl2HkRm/p3SOPAlCIKuLqhQWGdY7WD3KTTY6jZBWqgdyiTZ6WFDk6tV27ISQElMZgOq+K3fe6kmLnti2v1bW0GKP8NFccTrBxJlkwWovFRFuF+B7D8KHAo1qJd7JBSvHTTKCYadfAI1wLcptu4jDP3HhW3DIJSFiwOCtoPMxmkCfOAnNDi5YWBpCFe1F5+j7BGqifIq5hhv4FnmGxnc/fVMgzHR0RgNIPiK3p7Z5VCTaTozI5gfT0xCqmA6z8hZYwtcdELWeIge9NaDqC0bQhtr/KVdFaHMpYCr/cl9GuF/GkEOnmkuPOICE1OuGHoFq3s4psoo/+X3hLZMouLxRp5VNMqNcd4pdXo8kicjfmQ7Un7YLbl43ioa6pgnIAqCqMBPKpo7HlZF0wHnn0MqJVNnId5pr4EQgIRE1blqYF+VmV2Q0CkZq/COyxCkcKnOB/tT6pjx6LbOArrffsBTmvIJVzHDPNvFluVzG1opfj4GtFZnIKMf55gTYM4xutewduLozRXVgK5XnVpbU3s4r6usSm2gTXn1VpKfrGjxNeP1Dw9pkU2W7964NE3Cr0rdJQoSERgsZi1XDimrwe56ejJZi/+9UEmOEucHv4U3oAmsMwHSpGgJUvJd0vInZYyZcM03PzPxBLl6JuuRiiCdJX369fjIb/cnOl7uPy/NcBsnVDL8FXUNpOlaJbpQwI+0qgL+i8mpVFEKPvTiA/iwTSmq5sPx4ZYjbUkMuA3SkZZq7P2vN+gpoTDBwLGuNLuHfuli3xGIKh07dZEftLB8sNaNeGLHSMVC8nDZb+35KlD7+EwzVPptk3RDJGtgL7lTEqT1PO/jkd6JN0vfDqfaitRkLr6nv04
 FbXN1q4C
 yUBDCdhX/NQPVRPRyN6+6lGm0H/EVg3c6eLpO0ZDiTCKu+TXmHRwjAMRxsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shrink_memcg_cb() takes a bool pointer as the list_lru walk's argument,
which it sets when the walk stopped at an entry already in the swap
cache. Make it a pointer to a flags word instead, so that callers can
also pass flags in.

No functional change.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/zswap.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e..8925b6100402 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1065,6 +1065,14 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 /*********************************
 * shrinker functions
 **********************************/
+/*
+ * shrink_memcg_cb() flags, passed by pointer as the list_lru walk's @arg.
+ *
+ * ZSWAP_SHRINK_SWAPCACHE (out) is set when the walk stopped at an entry whose
+ * folio is already in the swap cache.
+ */
+#define ZSWAP_SHRINK_SWAPCACHE	BIT(0)
+
 /*
  * The dynamic shrinker is modulated by the following factors:
  *
@@ -1091,7 +1099,7 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 				       void *arg)
 {
 	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
-	bool *encountered_page_in_swapcache = (bool *)arg;
+	unsigned int *flags = arg;
 	swp_entry_t swpentry;
 	enum lru_status ret = LRU_REMOVED_RETRY;
 	int writeback_result;
@@ -1157,9 +1165,9 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 		 * into the warmer region. We should terminate shrinking (if we're in the dynamic
 		 * shrinker context).
 		 */
-		if (writeback_result == -EEXIST && encountered_page_in_swapcache) {
+		if (writeback_result == -EEXIST && flags) {
 			ret = LRU_STOP;
-			*encountered_page_in_swapcache = true;
+			*flags |= ZSWAP_SHRINK_SWAPCACHE;
 		}
 	} else {
 		zswap_written_back_pages++;
@@ -1172,7 +1180,7 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 		struct shrink_control *sc)
 {
 	unsigned long shrink_ret;
-	bool encountered_page_in_swapcache = false;
+	unsigned int flags = 0;
 
 	if (!zswap_shrinker_enabled ||
 			!mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
@@ -1181,9 +1189,9 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 	}
 
 	shrink_ret = list_lru_shrink_walk(&zswap_list_lru, sc, &shrink_memcg_cb,
-		&encountered_page_in_swapcache);
+		&flags);
 
-	if (encountered_page_in_swapcache)
+	if (flags & ZSWAP_SHRINK_SWAPCACHE)
 		return SHRINK_STOP;
 
 	return shrink_ret ? shrink_ret : SHRINK_STOP;
-- 
2.53.0-Meta


