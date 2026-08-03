Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB41EC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D08FB6B00BC; Mon,  3 Aug 2026 09:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0CD6B00BD; Mon,  3 Aug 2026 09:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5026B00BE; Mon,  3 Aug 2026 09:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 795086B00BC
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:32:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF3344064E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:47:07 +0000 (UTC)
X-FDA: 85059328494.07.9709B82
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4F004C0006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:47:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="hoIk0K/e";
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785746826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9f6uXvjl/eWkKv9dxCKCKFPrfKoxh9uM+CaLuz8FSac=;
	b=pBExBN9SmvjHKYMdqwA7KSw4uAUrmFdeXsd9NQXxS5vNlrfjXQOu0wYgkWpKGqnGBAMpJZ
	bkbdgBe0/lUfyh3kN4y8FGFvUMrIhxeueu5L/ljbisxMzOtWan63U1yPUyJpG3UNEwDSIN
	H4bXVnKaFtPJyLdOO0xRbgFCXyaMkKw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="hoIk0K/e";
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785746826;
	b=4faEUiml9lFOQIA+Vnt2dcQdhiPqwxeA2z/3jHvlUJnz8Zh9J6DsugdLt/NFmQCH6Oayqn
	FB/NsNBMtU7VO5YPmDbw22R9OnJRcpNXNCBYOpTl3doSlTgFIwkWu2iduGuvrdX2+mHgik
	es7JywMqoNAPW0zVHO1wnH0dTwK6hxA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785746825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9f6uXvjl/eWkKv9dxCKCKFPrfKoxh9uM+CaLuz8FSac=;
	b=hoIk0K/e7YRXkEYMTC7HwT+X5+ApUOtyj7yM8GUakTLirPsXzU+UG2KtlOYsllYKI9GTIE
	mOuZdAfqFovVsK9/ndzzwQyHd8Y2ccidpuIThz5S6A6tV/n37AshLl7XS7wK/rz7LUq5RV
	+mrabrAWw0wlocdSWo3d++m1cTgIeuQ=
From: Qi Zheng <qi.zheng@linux.dev>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	brauner@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 2/3] mm: shmem: move unused huge shrinklist queuing past the truncation check
Date: Mon,  3 Aug 2026 16:46:34 +0800
Message-ID: <e3d8eb0605eb8c4836fb1f376a0487328135b2c9.1785746588.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1785746588.git.zhengqi.arch@bytedance.com>
References: <cover.1785746588.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4F004C0006
X-Rspam-User: 
X-Stat-Signature: c9feghu5ffko5ynn3a3u5jofuzfbse5a
X-Rspamd-Server: rspam04
X-HE-Tag: 1785746826-533620
X-HE-Meta: U2FsdGVkX1/KEGhnHDFK7OGbB7H79jDwf8PiQxisb+0987ut7q/rreE+K9lNHYngHc3sHZ8KtwRqqe9kDvVGgDjiLUqmDzt4WzuidH1zj8T0j7PYUirHyLJfYaUvVFIR7/sR3d5hC5xgFp3yj02rEXLGfnk/4GrkA1Nb8a1wzLOVGZfSMjdiROIr920+nIG11FG17iTW7io4T/uY0ReZ3XzRE2QcWK6vtKfZmsDyvaLUfl2cFRTXxjgJx1/3AETjKrSnmXIJ7Yleq2wJ8dHLhwnkYNuR56eRkhpZbtG3OlXTdr+fqPsgNYh7BufgMmqoLzFpBmC2psw+SXRf4uaImrXU3XEk2W2CUZWTN2EE8f8YpYPho0iqg4SnAA8e4MsNuWjINZP3S0MTdAxiAD/MBj6kYEosOJ5Yh7awK5JXVWSzXr9H/9X4W265WG4Idb/IfgVyDde0WOM59YU5R8SgMRmQM26Gx4O1p5MicsJ5T/5qutLxj7xOeKbvnOOH0U+PodMWFgvUuyO8YH+SiXx/8y+ZsAodIsKUbIGl1E8V/OXIbO0rVNpG4N4oZiomSc2FWNRFUpnoJ6bG5kezG45re++ot2PZmOLbG/cPybZHgWALq+90jSTgXykdIHfB+tq/Ecaut1TMnxiP8GWeqJA3HeBSxhA+f27hMu9O8pMBTqyN1A5CCfeTHhY/aSW4zV87g2qKob2DVO2BJNcaCGeF1eeJv+9yXwS3l5eTsGbvcWyyqP1mlFMMzNeu8kCaCpadS4xDCFleyEXy3YM/bcgmDMQoDNTVqHeZP43Uy7B+KJA+PK/tvaAx9qojwJEs/hUys6RJ8W+YqVJO+/5AwX8TcKEZnuBt5Emd8ubmstWnfaRbw/Zp5p/4WPwmcVhCZNNlaQ8BbJdR2y2s2H9VtQAqrOybIKf0K++18NyHfhv8iaR0GzRcvHODikxFKGWJZEoxGYdGe+hRovfdhch0QQO
 ALxuWlHr
 JLCsgemCRDfEK1/C+CcVGMeJAhGoIbsdDAyfZq04781BWUGe0XuJL+rg0czOwZmZtJ88FgysJWgs4ihIOr67W0eaBRTMK6wxbauscFMlxCYm3pKw2U9QwvQUc0DzsMRb3LUBb9g/O2Oy9hnGETkcDo9pobQlwwTbJdsAATKnTFujgJVVngDt+WGlnFDD0m838WcBkImG09Y2Ddh+F6VZlaJT6HiH8NCAkbbce
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The shmem_get_folio_gfp() adds the inode to the unused huge shrinker list
at the alloced label, but a subsequent truncation check may still fail and
remove the folio, leaving the inode on the list with a stale folio.

The original code works because the shrinker re-looks-up the folio and
drops stale entries, but it is cleaner to queue the inode only after all
checks that might remove the folio have passed.

So just make the pure structural move with no functional change, and it
serves as preparation for the memcg-aware shrinker conversion.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/shmem.c | 48 +++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 74dc3d900067a..bc0b768135113 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2535,27 +2535,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 
 alloced:
 	alloced = true;
-	if (folio_test_large(folio) &&
-	    DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) <
-					folio_next_index(folio)) {
-		struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
-		struct shmem_inode_info *info = SHMEM_I(inode);
-		/*
-		 * Part of the large folio is beyond i_size: subject
-		 * to shrink under memory pressure.
-		 */
-		spin_lock(&sbinfo->shrinklist_lock);
-		/*
-		 * _careful to defend against unlocked access to
-		 * ->shrink_list in shmem_unused_huge_shrink()
-		 */
-		if (list_empty_careful(&info->shrinklist)) {
-			list_add_tail(&info->shrinklist,
-				      &sbinfo->shrinklist);
-			sbinfo->shrinklist_len++;
-		}
-		spin_unlock(&sbinfo->shrinklist_lock);
-	}
 
 	if (sgp == SGP_WRITE)
 		folio_set_referenced(folio);
@@ -2585,6 +2564,33 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 		error = -EINVAL;
 		goto unlock;
 	}
+
+	/*
+	 * Queue the inode on the shrink list only after all checks that might
+	 * remove the folio have passed. Otherwise the inode could be left on
+	 * the shrinker list with a stale folio.
+	 */
+	if (alloced && folio_test_large(folio) &&
+	    DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) < folio_next_index(folio)) {
+		struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+		struct shmem_inode_info *info = SHMEM_I(inode);
+		/*
+		 * Part of the large folio is beyond i_size: subject
+		 * to shrink under memory pressure.
+		 */
+		spin_lock(&sbinfo->shrinklist_lock);
+		/*
+		 * _careful to defend against unlocked access to
+		 * ->shrink_list in shmem_unused_huge_shrink()
+		 */
+		if (list_empty_careful(&info->shrinklist)) {
+			list_add_tail(&info->shrinklist,
+				      &sbinfo->shrinklist);
+			sbinfo->shrinklist_len++;
+		}
+		spin_unlock(&sbinfo->shrinklist_lock);
+	}
+
 out:
 	*foliop = folio;
 	return 0;
-- 
2.54.0


