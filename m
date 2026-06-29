Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEEB7C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 11:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4C496B0095; Mon, 29 Jun 2026 07:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A238C6B0096; Mon, 29 Jun 2026 07:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9604B6B0098; Mon, 29 Jun 2026 07:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 716D26B0095
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:21:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1FA3C3288
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:21:11 +0000 (UTC)
X-FDA: 84932708742.22.610E08D
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3503F1C000D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:21:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Po/JTT5Y";
	spf=pass (imf21.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782732070;
	b=Ovney//Jf9cl0bqgd0ovBSM6d5N5Olfagj6BW8/2a4NFXZpwdpz8GkYWDNdTNa4noRMy3m
	OgCRly9Bz0/HqsFA6LfZ+WLnO3E+yKWeRElNfCNo/4XBR5FSqPQ6nRAtjDGoZoWf9nyaF/
	k0+R7kdowki7dTX1DWzOcHupGJvyimQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782732070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sO4sdWL/oCz6QEMC2wKysJsfeihvrWNSztOGuVnk/ZY=;
	b=jQVSAMKmmzuiNQ9NfJG/kI0HUL20EOmGFgxaK33T/INoDXOxUABNcHOPk5mxu9S49B8jCI
	mN4CH7PAnlCrK5a0Gnq1ik32CES3eMig69m1yoLsJ8EoQzhmj2uE/JWVg/fDMOLKvthy5Q
	S/mBButoXaxpEXrBk3HkMzwZyG7jU0w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Po/JTT5Y";
	spf=pass (imf21.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2c82538b6c0so16789185ad.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782732069; x=1783336869; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sO4sdWL/oCz6QEMC2wKysJsfeihvrWNSztOGuVnk/ZY=;
        b=Po/JTT5YpVzUsJ5ic5HlAEFMzt7+c4C4NokX3pX9LQOjrgzCA3FlNG+VYMhfEw9JyH
         HRciqg8Bkl2d2frvHGQnquS9Sd6UpyTUQem/L0iIaPw4G+84B1g+XEbKsLmlGNpNZ2kB
         3K9rHAUv/+SNBStZUKVuUrqfF0HEblG3cb4X1H4RtDs0P+aZgYX//ZcgLiMv6L6myfAO
         kXCU+7BoaVc/MLubsTXT/JXPd/mK++CtmCogd9AAcRf4Ocjtjaf9LY3WJ+ziqNiYf8Qo
         m91NJQ+4WntnajpN/igSw0yb8KKAQ5UVm/HGrT3u8oeiVabE71uDY5qYWoWscGpGHBNe
         /7tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782732069; x=1783336869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sO4sdWL/oCz6QEMC2wKysJsfeihvrWNSztOGuVnk/ZY=;
        b=km8i/f3i+uVHuUhuHiv9rbk6lZv9V89AkEeOBw0cp6oAa9xRsRlGpD5GwDMMsJQlfS
         bRrtj5erXGIJmiCVARgQT2h6MGf+UZ7Fjk0FhRB5UOGRF2EZbnIyia1hEgh2YzcqposZ
         AR8bT5w/zIiWYSVL8qXIEkwAH7Me0D2sUimQYYxcWegF+ggmJJPfdYYjwilQbIGHWpBi
         hujKqYjGN55xCpbiONTXJ3LfMhdldmg+wDG7rP/yP6l4NA/E7Nd6HcwlDIam/M/m4vsE
         fMtFSRE5fQD2W7TYS6qK7+gVvrFzEb6yCMTr/VknJbyoBqYgdS8dgg2uQJb1jw8j+b3a
         yVGQ==
X-Gm-Message-State: AOJu0Yy+U4E8JQIxtTU49+nL12elGwj9xM2Gbt3WPUOAsj0P6uY9FidS
	ybeH0yB93BreQGT0t7wrrle4JxEBYiPaszy9VtuOqIq8OSQun6Xa0Pbb
X-Gm-Gg: AfdE7clfiWhRgNBLAU0w6cuvOhqCNfHeGM+0gsWZi1OTEw5URQE/hroOm3qG4rexsrY
	D8DwSktcz8CSquBDkGI+xaOmHIpl9rh/7gqfkeZtJ5v0X7a8yPwlhthDk8CmN3LDBIbfbWmIT3G
	9726bADvLLvXjmWi6LWByZqY9ZarrALQzRcPqo61jeM1ffJea5u7Xc1etzme0jdPes4pY2RRi0N
	9hK+7cYd148Z9jD8ZSl5qRkY0ZeReZwTBsaPUXIRh/m3ymdqNSrsR4Ri4fZEzRpSIxQed5FJS7C
	mZ79K+6RxDBuLUYFHHvm5hk3k76CZfAO9pEbNFgooPjpvSVaiKx51t1YGSTcMLc6AW1DXCP3eck
	dbG8uYKYe6jQ7+NkCW+Q/Ewr5bqLY5MYjXFQyD+YmVE6/foDuEEdUgtHMMqhA/y1G99i9lVAsu+
	5lSW+v4O4B1X7cBnarmUqeNHlqSICuvz/RMy+z7Us6
X-Received: by 2002:a17:902:d4c5:b0:2ca:be8:62d with SMTP id d9443c01a7336-2ca0be80814mr19308125ad.32.1782732069117;
        Mon, 29 Jun 2026 04:21:09 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f63d09f0sm92759085ad.56.2026.06.29.04.21.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jun 2026 04:21:08 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH v5 3/6] mm/zswap: Extract a reusable writeback helper from shrink_worker()
Date: Mon, 29 Jun 2026 19:20:29 +0800
Message-Id: <20260629112032.20423-4-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260629112032.20423-1-jiahao.kernel@gmail.com>
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6ex1tbkwjsohg3wcb8pjm1ao6bwnkkxr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3503F1C000D
X-HE-Tag: 1782732070-422087
X-HE-Meta: U2FsdGVkX19K6P2C6KhFPdetMulPZbBuaCOeuBWirV/FbA9ieAc0qxalxiNVd6AAOw21KumVnUyV0kSH+G15h7vnzQyCJSp92irzUT+kYMB+H5GhE5gKXIorl0L5jKavHZWP0AdQREy1spLn5CvqZahlUxm6g9b4dIDZLf+FV4d6GFb+hZDCrnuY5Uv9Q9TCoPxsvmG6wYzRSuyGFzYz1wXWnZ+B7fEsHfH7ClszoQpcHqCoTICPSHyJK4iegZSOcmDkdmbdDSOjQ0/NSBsogkwQeTq1Z5WGRuxRL89P2YVSVBpUBnH0Rzz9kh6y4pqYM1WUzwQeNNTs7uIg5vI3rRRQ8QSn3fOrF4uxDcJgkEnmjK7Z3ZpVXzidSVLX0NDzrvLipqAoQh10krpWzBLpu47I7stu5sCUp6eIqcXH3iHSNIlzTyMyiFe+mVWby4L/fs/6vNso9qnQtcotjsk7kItICJBEOkx6ec6guABr9l0+6sdh3o2shjRaCmWNqVmsxhrKhEjCew7tUCfRKZ27iygOJT2I8Nm0TaNDBCaqtg4++dnks+M4fO1bSVSdYqsVI7BybwIt4EDWJLsIWhRneIYKaodI/KUxiL1EOsmZTHmjVvnrwXqTdEPyTQnBR+j29oxVbTVzNYpdo0H0Cxoew/DMABUd9Jo5psKVFwAtiZjDuBrHD0zeyXVkDiodWqMKfEMQyz5EINAfK71Uef7YyeAnhFtjlg/IzRer3uP9hM8VJwNo2Y1iOMy67qNIhw92d8XS3x5OAbifh5hcn0hvNrZr4YJU5jWwX9TjyPvQ65otm+lL5CHENy/0jBG7eoC6KOT7q9bLX6v312GM9yJlwuSGzk6C7Yl/n5Py2hkoPZcrr8+7mEQOY9HFkcoKBvI5H40UwpFC25hAjGK8Wm8fUbCo76+HScVnnWaNo916ToviEvyGP6Ci97e4TDpzbVqrIb17BitJV9i/nGFDckB
 eQhrg004
 0S9x0QaANPfdSmGx+So841XK3beeLEYsz2X9dAKC1qOMTwJ5BwTE6qn06NUVSr+fPeUeNAMLgwYdsctLtz5u3tfewTtTKHq17ZWUHNoUjhqvwIIccqicaYhiLjxp5I9NGfanQsBzumIQqBABQQYrsdyDEl8apZqagdSENp3VtAWKG2BolApNhHgq7siiarso7JW7wxedxW4z8iydAU3vjyKD/lv//GQxUQTDeeGczV8Xw6OVBDNgH2iLh1SVS/TKDcbHzR5FqJ4QIMar9GPz8upUQMh3UKwBn+pQfluajUPllfAaVhBXFgD+aMwSnoppgxoFF3F2chwUFBKxuVve+9WFczMalOXOL/YibqEGogvgy73rCe9FgoFhi0+bFurxykPNdQnumK7+pOJSzrQQxLX94mH/0so1XGPVZ46GoHBAjzQHI0TTf9WlbezRztA01DNYGBGw8QNrSv11d416Bac8MBjWH6XFT+KFZT7NX7p3cwnFbc/WBb44QF3rzC6thCooJpTFOgOVBI3VgA85CurALASHxNaSGnkANLD+icCOZcxA+f6YuS4mPTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Extract a reusable writeback helper zswap_shrink_one_memcg() from
shrink_worker(). This helper will be reused by the upcoming proactive
writeback feature.

zswap_shrink_one_memcg() takes one step of a memcg-tree writeback walk
driven by the caller's iterator. Consequently, shrink_worker() now only
needs to calculate the acceptance threshold, drive its own iteration
based on this helper, and abort the walk when zswap_shrink_one_memcg()
returns -EBUSY.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 mm/zswap.c | 118 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 49 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index e2c2a3f1e061..ba01bf0e44e9 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1351,12 +1351,70 @@ static long shrink_memcg(struct mem_cgroup *memcg, unsigned long nr_to_scan)
 	return walk_arg.bytes_written;
 }
 
+/* Track progress of a memcg-tree writeback walk. */
+struct zswap_shrink_state {
+	int scans;
+	int failures;
+};
+
+/*
+ * Take one step of a memcg-tree writeback walk driven by the caller's
+ * iterator, and fold the result into @s, the retry bookkeeping shared
+ * across steps. @memcg is the iterator's current memcg, or NULL once
+ * it has wrapped around after a full pass over the tree.
+ *
+ * The function returns -EBUSY to signal the caller to abort the walk after
+ * encountering either of the following MAX_RECLAIM_RETRIES times:
+ * - No writeback-candidate memcgs were found in a memcg tree walk.
+ * - Shrinking a writeback-candidate memcg failed.
+ *
+ * Return: The number of compressed bytes written back (>= 0), or -EBUSY
+ * when the caller should abort the walk.
+ */
+static long zswap_shrink_one_memcg(struct mem_cgroup *memcg,
+				   struct zswap_shrink_state *s)
+{
+	long shrunk;
+
+	/*
+	 * Reaching a NULL memcg means a full hierarchy pass completed.
+	 * Exclude the memcg-disabled case, where it is always NULL, and
+	 * fall through to shrink the root LRU directly.
+	 */
+	if (!memcg && !mem_cgroup_disabled()) {
+		/*
+		 * Continue shrinking without incrementing failures if we found
+		 * candidate memcgs in the last tree walk.
+		 */
+		if (!s->scans && ++s->failures == MAX_RECLAIM_RETRIES)
+			return -EBUSY;
+		s->scans = 0;
+		return 0;
+	}
+
+	shrunk = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
+
+	/*
+	 * There are no writeback-candidate pages in the memcg. With memcg
+	 * enabled this is not an issue as long as we can find another memcg
+	 * with pages in zswap, so skip without counting it as a candidate.
+	 * With memcg disabled the root LRU is the only target, so we should
+	 * abort if it has no writeback-candidate pages.
+	 */
+	if (shrunk == -ENOENT)
+		return mem_cgroup_disabled() ? -EBUSY : 0;
+	s->scans++;
+
+	if (shrunk <= 0 && ++s->failures == MAX_RECLAIM_RETRIES)
+		return -EBUSY;
+
+	return shrunk;
+}
+
 static void shrink_worker(struct work_struct *w)
 {
-	struct mem_cgroup *memcg;
-	int failures = 0, attempts = 0;
+	struct zswap_shrink_state s = {};
 	unsigned long thr;
-	long ret;
 
 	/* Reclaim down to the accept threshold */
 	thr = zswap_accept_thr_pages();
@@ -1367,11 +1425,6 @@ static void shrink_worker(struct work_struct *w)
 	 * writeback-disabled memcgs (memory.zswap.writeback=0) are not
 	 * candidates for shrinking.
 	 *
-	 * Shrinking will be aborted if we encounter the following
-	 * MAX_RECLAIM_RETRIES times:
-	 * - No writeback-candidate memcgs found in a memcg tree walk.
-	 * - Shrinking a writeback-candidate memcg failed.
-	 *
 	 * We save iteration cursor memcg into zswap_next_shrink,
 	 * which can be modified by the offline memcg cleaner
 	 * zswap_memcg_offline_cleanup().
@@ -1386,7 +1439,11 @@ static void shrink_worker(struct work_struct *w)
 	 * offline memcg left in zswap_next_shrink will hold the reference
 	 * until the next run of shrink_worker().
 	 */
-	do {
+	while (zswap_total_pages() > thr) {
+		struct mem_cgroup *memcg;
+		long ret;
+
+		cond_resched();
 		/*
 		 * Start shrinking from the next memcg after zswap_next_shrink.
 		 * When the offline cleaner has already advanced the cursor,
@@ -1405,49 +1462,12 @@ static void shrink_worker(struct work_struct *w)
 		} while (memcg && !mem_cgroup_tryget_online(memcg));
 		spin_unlock(&zswap_shrink_lock);
 
-		/*
-		 * Reaching a NULL memcg means a full hierarchy pass completed.
-		 * Exclude the memcg-disabled case, where it is always NULL, and
-		 * fall through to shrink the root LRU directly.
-		 */
-		if (!memcg && !mem_cgroup_disabled()) {
-			/*
-			 * Continue shrinking without incrementing failures if
-			 * we found candidate memcgs in the last tree walk.
-			 */
-			if (!attempts && ++failures == MAX_RECLAIM_RETRIES)
-				break;
-
-			attempts = 0;
-			goto resched;
-		}
-
-		ret = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
+		ret = zswap_shrink_one_memcg(memcg, &s);
 		/* drop the extra reference */
 		mem_cgroup_put(memcg);
-
-		/*
-		 * There are no writeback-candidate pages in the memcg.
-		 * This is not an issue as long as we can find another memcg
-		 * with pages in zswap. Skip this without incrementing attempts
-		 * and failures.
-		 */
-		if (ret == -ENOENT) {
-			/*
-			 * With memcg disabled the root LRU is the only target, so
-			 * we should abort if it has no writeback-candidate pages.
-			 */
-			if (mem_cgroup_disabled())
-				break;
-			continue;
-		}
-		++attempts;
-
-		if (ret <= 0 && ++failures == MAX_RECLAIM_RETRIES)
+		if (ret == -EBUSY)
 			break;
-resched:
-		cond_resched();
-	} while (zswap_total_pages() > thr);
+	}
 }
 
 /*********************************
-- 
2.34.1


