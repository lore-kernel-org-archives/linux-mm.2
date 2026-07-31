Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A236C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 08:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31AFE6B00C3; Fri, 31 Jul 2026 04:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255716B00C5; Fri, 31 Jul 2026 04:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11D586B00C6; Fri, 31 Jul 2026 04:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9E6F6B00C3
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:39:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 649CE16034B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:39:15 +0000 (UTC)
X-FDA: 85048422270.07.D881376
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 97181120005
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:39:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MRUp7+N8;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785487153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YV+vGlkWwAAqTC1IWyggngTy7GK63iEPW6UUQSpPO7o=;
	b=qKOpbgpb/0ktpVGa6rGH+d+ZVYG+oCn3N3ygdV+DE6sZz7DL5tM/CqAQDz9Ltnx2L+Lv0J
	ryKJWGFIgiRxdqHFIz/aPJc7JRZCKljSLl3MkIK++PoWxLpGjY10bRiVt+xmu2ahlAYoDf
	O5oSwOhbMVRd9wdejhm30nDCNvQuGTs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785487153;
	b=jsAGeKn7RbSoh5f6VwnE88mxUi97yGerO9gMjkGPHCAlXdlBkB22PovPRLr4fgRKUl1eiz
	eUIeZmy6DyzcMWkTzYOWG09OCs6CHRTJLQkAJ10crr7p6kTB668T8p6FO8LiM2L5xb3mS7
	cpF5yhUW7PIZv3X5nOwoHX1GFEsqQy0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MRUp7+N8;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2EFDE60A6E;
	Fri, 31 Jul 2026 08:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778D31F00A3A;
	Fri, 31 Jul 2026 08:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785487152;
	bh=YV+vGlkWwAAqTC1IWyggngTy7GK63iEPW6UUQSpPO7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MRUp7+N8XwNJdsu5G0MjXW8uZSR7JgKcxsOQe35smP5Ce/TgkBCUhrkLBy5roxTwX
	 wsNkeHlivzLYQ8qDRhUw8i5Ah+2z2t8t+3fF2yPrsBWMhPosqSaMQXlIZHNrjHltjD
	 HNp9iOUMD9bPFzOx5ApnpLUBmkHv3dwvZlEI43vunfEqC+mlnIfF6Gij6+G8Sh+/iD
	 2hhEPoC2hKyKC2XbPDfwtErhBYGsFGyhYoe/MNMPYl0tUto6xJV77kQJWB+C/uNAAv
	 6vOmIvJs6DAdvL8rp9qpdP8/V6fYwsjx5HVqQWkZpydRCjGk8fcQsma3njfqqS1mm3
	 GJVPgIVmCADXw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	weixugc@google.com,
	yuanchu@google.com,
	chenridong@xiaomi.com,
	zhangbo56@xiaomi.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	Barry Song <baohua@kernel.org>
Subject: [RFC PATCH v3 3/6] mm/mglru: improve readability of isolate_folios()
Date: Fri, 31 Jul 2026 16:38:40 +0800
Message-Id: <20260731083843.37811-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260731083843.37811-1-baohua@kernel.org>
References: <20260731083843.37811-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 97181120005
X-Stat-Signature: 7ciug1gftyzg5b776odpp4m8tztcftai
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785487153-237498
X-HE-Meta: U2FsdGVkX19VoyFtojpBbmrcFylRO9A+66lfqbQcbuDEO+0j21NbBrWwdiyCZRu7mhtQl8IH5atM+fbev0Ui6DX42qoKOH+TrMfokl5I8/MxZCppDYdZ+ayj/j7e3zWqam+xBSuYW3h4ulk/LtCC7ulZP6kPfq7xbX82rvjtsRVfc5E8FbNiPUxMnn46dvChpnfl6ZOEqN860VALfGlWZlxwlyjy88hx969bfSlSA3QIrjI+MJ3YQVBoPYkU+KhYNwbBANrdBg0fe99SBjgiJdXSqyeVQM3Df0S8WV7CpDEUmcwrn7xNR62v+jnf6yZN1P3E7qCPCNzXXArUKr4RcEXKXeq7VzksVR9oMZGMjxG4c2YyFv15mtV1CBUpN5Qwa2bNpHDpYrLmbLPROqbuW1owdre+QDXPuMZT06zQDzS18XUskz3ZLVyiDTqmTSqW1fbt5fXX3geeG9aUh/tkqVuXcFyesIfdUF0AmU1xDWhcQEWENG/B31OYCC5CuX61g8Dcz35tBT2qySczpTdZXXfx6YSbJRp9BSjfLyXcsH09vWGZ1QjEgnRBlhHUmXh7SPwk3U0MAy5cdtCWcqZbCnZvXUkpDQyBhhbkd3j570URB2EQOENz5mIiaIUWY8IfeNYGxEwpmW6KzkdIQREx2UxpmfX1yVTDAJ5JS+UtJuhng2V+PClzl2zx3WQIru512palw3qJIj0qE604ZE5q10B2NjY6stRgnn3i1u72TN3MWEcsUPw5oLk1927ZhlDm8rM+2Fw+vjwzltjmeDmwn18ymgmMqdhT8IScn1xZ/XiyMuIzJAQrJ4F7hw5M/e1CCs6DYNwiaed+ZW6eyQii/r9kGs1Cl4OB5ceH9AtolJ0TfBWYHUNGuYONfaH+PgX9jnepeX2vuPtxJwE9nmFPjINIR2gRtiBrcLVaIpUvE/Wi5YVyHhhX9gz4HB7rlFvr3PhvynQefSRUVy1Ehjy
 LtJFNGMv
 SM2iMtS5SpZxFRn7okjcxJIdckhUepxdlsSaDbsnOnBaH421EUszhIt4XbZpAgbNFaqcLyqbYBwncCSH7sXKoNmp0jA5Tgha6v93Nf9RrWHjGB0/XkIVMwOZghtjZJ9p74VvOpoUH6G0u8+7jZ8k4gkGP3JYHdx3tuVrcZ+S2ELizjViwrHgIaXW9sXqAQOVHRoyAPRW43DwO8VbMM4jTMd1vRUZ67yi+Eds9el9mMh+fkQQP8VOY3DYYi4KPuTDBB6SM0bYyo+dZQjNa1UHbbi7MHePNwVBQAqAAkA/w0tSZIzVVOSsaWhGeRBd3LXsNwnp5lXL7JpwZiz7ZWirz92pLcOZrAvULY8dp8F+jc/EGGbtMahE4cutkD0KvWjz25+CJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

The for_each_evictable_type() loop in isolate_folios()
is misleading: it does not actually iterate over each
evictable type. Instead, get_type_to_scan() selects the
type to scan, while the iterator `i` merely bounds the
number of attempts.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 47 +++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 31947fa60f18..0038f33aa318 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4828,35 +4828,42 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 	return positive_ctrl_err(&sp, &pv);
 }
 
+static inline bool is_single_type_reclaim(int swappiness)
+{
+	return swappiness == MIN_SWAPPINESS ||
+	       swappiness == SWAPPINESS_ANON_ONLY;
+}
+
 static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			  struct scan_control *sc, int swappiness,
 			  struct list_head *list, int *isolated,
 			  int *isolate_type, int *isolate_scanned)
 {
-	int i;
-	int total_scanned = 0;
+	bool single_type = is_single_type_reclaim(swappiness);
 	int type = get_type_to_scan(lruvec, swappiness);
+	int total_scanned = 0, scanned, tier;
+	bool tried = false;
 
-	for_each_evictable_type(i, swappiness) {
-		int scanned;
-		int tier = get_tier_idx(lruvec, type);
+retry:
+	tier = get_tier_idx(lruvec, type);
+	scanned = scan_folios(nr_to_scan, lruvec, sc,
+			      type, tier, list, isolated);
 
-		scanned = scan_folios(nr_to_scan, lruvec, sc,
-				      type, tier, list, isolated);
+	total_scanned += scanned;
+	if (*isolated) {
+		*isolate_type = type;
+		*isolate_scanned = scanned;
+		return total_scanned;
+	}
 
-		total_scanned += scanned;
-		if (*isolated) {
-			*isolate_type = type;
-			*isolate_scanned = scanned;
-			break;
-		}
-		/*
-		 * If scanned > 0 and isolated == 0, avoid falling back to the
-		 * other type, as this type remains sufficient. Falling back
-		 * too readily can disrupt the positive_ctrl_err() bias.
-		 */
-		if (!scanned)
-			type = !type;
+	/*
+	 * We are running out of the current reclaim type. Fall back to
+	 * the other type if allowed.
+	 */
+	if (!tried && !scanned && !single_type) {
+		type = !type;
+		tried = true;
+		goto retry;
 	}
 
 	return total_scanned;
-- 
2.34.1


