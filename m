Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1095C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:32:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA4DC6B0092; Mon, 14 Sep 2026 23:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E552D6B0093; Mon, 14 Sep 2026 23:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D915E6B0095; Mon, 14 Sep 2026 23:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B88726B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:32:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0274F140307
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:32:11 +0000 (UTC)
X-FDA: 85214573304.13.EB28E38
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9DB0240004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:32:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789443130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+ygtrvdivSA6ZBqnGJh4AMZO5xI4B0IxVdT4ACX+3Ic=;
	b=R4LssIsdFd9LILss3U2fN1SBCxXgq5tna4rvpXqhnp97WszVHZ4km50G0Re5WlwOWM8pdo
	sB3Fk1Pgv3X+OYegk99AoAUhTiduAaMluTsxg/4SvppboTstA9F9XbMn7TveD4zNHQ+ze6
	mZWencXnCUjQ5UgQmrizIDxxNIcL79g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789443130;
	b=GlX/8Wfbd+ufZneWGRvYqo1h+Oz5BfkAOvTl6yCl3Bd8Uvha+W0JFHA5//69i8iDir+cmn
	dLaDF056MDVyeFyJYsq9YZwn0+uJElYcLGBVrj5Sj4WDrbPPtSRhkEsW8pwm4z2msFfcXT
	Sd0FLgBmcdTB2R1etr9HfRVyts/v7+k=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 15 Sep 2026 12:17:07 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	her0gyugyu@gmail.com,
	youngjun.park@lge.com,
	taejoon.song@lge.com
Subject: [RFC PATCH 06/10] mm, swap: hand the image's free clusters out in disk order
Date: Tue, 15 Sep 2026 12:16:54 +0900
Message-Id: <20260915031658.1505680-7-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915031658.1505680-1-youngjun.park@lge.com>
References: <20260915031658.1505680-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9DB0240004
X-Stat-Signature: ytxauaf7xgnzjugm8m7wfn3tb33d3j7m
X-Rspam-User: 
X-HE-Tag: 1789443129-795082
X-HE-Meta: U2FsdGVkX19uxZGHZ+A/pTeZ4JdjNQUIWIfEk61Ru5EPQwSjzYGIghGwcQPiu2H0zNjnFvuQ/NuTmLxu/hpOyoRQgQsJjnGtDjjVKXpNjA+0haJyaM705DahGCOgMpOsqhwJwPSd9cf0FsmsdPEJRw9ZovWuyjJna7wFh4PmMlRbgttRpPiazDTrDrBL30qoQIRfwRpsp8RHfD+ZUc3RDmLyJhtI6jBfOkYxLhvSGH8gA5rHVW3UmG2A0xVf3g8fMee3D6ARvShRpGSBhhRpSpXi8/x2D1xUEtHB2GyWoAtPsplswEom9INd2DVtgj7umKL4eggj+lXFZSnxGauzPQi5jWrQzDVc453MUlD1/Hs7Ri09UTGGF92ufmK03FP5vZWh6n8FELVEAwOMTxy2fSE7bpySZi/E+kRU1UlZheaiL6d5vGfDivmylrWdZrhl9Z+/pZzHN2HcCP8U8hxd+i4Cp8dFkDhShB7G7WNEEgURJUP1f1uysjUEjjaA3ff1QGgDOehh17oHr4vZ4m+tProuLUmlhri98Bi+LH6TvikglhtP1hJfYTW1T+9uBo/Mmf3Oncm57CDBJso7C3wsEAJyes2+FKtw1U9wilyxOrZQ73whbER+I0sdDO6e/Tcm1KqJZLuFY4sx2IAco+MjksPtciBI2aJBFlDYHuwSivjBOmeOsQNXE1hpvZHjpldT7E6Gqs8J0zzwKSg5uoSgosSYy2A/1tlMl1GwaUOL6ajAriSI7dkrbFMxbeF0gTCARqQnAnsLWQMkVY+xBnZ8STAUu+bDpj/lHO3SHCtZn/3JgT8LGQHOvOMxl6nhzegY1zvGQA9GcwUhvajNWvR2r++0dbyZJxgfhx9wq5dqfVszttQMog7WOTqbWeQHCcNL5gyCHTsKdTN8X96Tb30dL6oYi/jv+lq+8vUdKBhYMwHdrtYrhrqhbtP6ExVn0Njpv9HEi4dQpZ9ociLXLxd
 DvGK6ygx
 Z5f+lAO7kOe6yiOZIZYAEbSlZ9BSQpzfx/NiX89HGRwLs6JOHckKz+suu+iSscyfRUjCmgDW0E2/IUKBZ5hBrnfkl6mVPpjc8DYD5KqNnwN9zD78U5GnnuDSMjpCW/J0J3eJ5raAZGabqVNvNKup+1OFo3cFAf17w25hS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The clusters set aside for the image come off the free list in the order
they were freed, so on a device that has been in use the image is
written back and forth across it.

Sort them by cluster index once they are set aside, so the image is
written front to back.  A rotating disk then writes it and reads it back
without seeking back and forth.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swap_hibernate.c | 9 +++++++++
 mm/swapfile.c       | 1 +
 2 files changed, 10 insertions(+)

diff --git a/mm/swap_hibernate.c b/mm/swap_hibernate.c
index 3431443716d4..23dc766f04cd 100644
--- a/mm/swap_hibernate.c
+++ b/mm/swap_hibernate.c
@@ -13,11 +13,20 @@ static struct swap_info_struct *hib_si;
 /* Free clusters set aside for the image, out of the allocator's reach. */
 static LIST_HEAD(hib_free_clusters);
 
+static int hib_cluster_cmp(void *priv, const struct list_head *a,
+			   const struct list_head *b)
+{
+	return list_entry(a, struct swap_cluster_info, list) <
+	       list_entry(b, struct swap_cluster_info, list) ? -1 : 1;
+}
+
 static void hib_claim_free_clusters(struct swap_info_struct *si)
 {
 	spin_lock(&si->lock);
 	list_splice_tail_init(&si->free_clusters, &hib_free_clusters);
 	spin_unlock(&si->lock);
+
+	list_sort(NULL, &hib_free_clusters, hib_cluster_cmp);
 }
 
 static void hib_return_free_clusters(struct swap_info_struct *si)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 86ed8c6adae7..98ed75708661 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -38,6 +38,7 @@
 #include <linux/swapfile.h>
 #include <linux/export.h>
 #include <linux/sort.h>
+#include <linux/list_sort.h>
 #include <linux/completion.h>
 #include <linux/suspend.h>
 #include <linux/zswap.h>
-- 
2.48.1


