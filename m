Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 818F9C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3235F6B00F4; Wed, 12 Aug 2026 08:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FAAF6B00F5; Wed, 12 Aug 2026 08:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211426B0104; Wed, 12 Aug 2026 08:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE99E6B00F4
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:18:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7350B80349
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:22 +0000 (UTC)
X-FDA: 85092520044.29.E8FC97A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D523712000B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Yeol5q/2";
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537100;
	b=MaCmpOAFTca8K3JKPScJQAktB572XH/3Jsk/pDKq/6jiR5qftiXxo7r1UCne7n5nYuV1x3
	1jzbL5O3efS1udnarvrUk7V+c0yw61ZV2TNo2GPrddbcVx0LDOOq36ZKlcm0y7Wcx7+wwM
	Qg/Sei0i/O8OUPPjh/dunkSF6ArLNQs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Yeol5q/2";
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8SPnYkw1Tpm0RdC6K4fEpBajDKizXkw5kF84LatlXqs=;
	b=UEcOcmrCOnNNdZ3MIeSE5W0dJRCV+RO2Y8pL5Hy7BZClwePcuV2CmwJLhnwey0/7/nww7r
	92TW2Mapo4Vc6TeQHMJA0/cGaKO0X0xpisp4ahfHLHOp6ls1Re2JvZTLnmpWt8yEBysD/p
	CZJt/nTGBp/5j4/I0VHAVtShn6bNkwc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6772C60AA9;
	Wed, 12 Aug 2026 12:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759FD1F000E9;
	Wed, 12 Aug 2026 12:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537100;
	bh=8SPnYkw1Tpm0RdC6K4fEpBajDKizXkw5kF84LatlXqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yeol5q/25N+xnu1SXOdyiCkZybpJAjBsoTTDhfAYWyjY9mCkLZ/5oJczeJoI9uuWK
	 AonvvY6ikwAM7pWjaw009NzdXeUKBSVAg1uqAp2JpFSQ3dFZwZWK0vb3hnJxyOt4wy
	 4b3eYJwBF9l/LJqGetsBymGuqJEllDg7uKjG1blNYo9vBYdIrm8q8wNstwZdDW9+Dk
	 zJs4Y1mnlnmt+T43CaOzHcgwuF3hUVCYnvhIAJ7NSlrzAF5G2Xak3LmVCRcJoY8Cw4
	 QZWlIgZ5+B0+gHvlC4D5RQu02T4qP2hrhjGiBt2qRxIs5HMezylYX6kf5CXQ+zR3Jm
	 yfuATH/+e7d0A==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v4 04/16] mm/mglru: boost swappiness responsiveness in get_type_to_scan()
Date: Wed, 12 Aug 2026 20:16:46 +0800
Message-Id: <20260812121658.69965-5-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260812121658.69965-1-baohua@kernel.org>
References: <20260812121658.69965-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D523712000B
X-Stat-Signature: c8k7inp3j4esw8756m6nfrutsmrmzi7b
X-HE-Tag: 1786537100-237773
X-HE-Meta: U2FsdGVkX19B3Ad8NpZC1gQG8H92W9glmg0FNezMFyKPcIEXIzwS5NwyMO9QKJNAuiCrhA2N8PaOmxqMxVRZ/7M/d5i5gxVyU1/GLhFwisJhJ+8imoEH9RDI6/JUUI3MwjU/0mRH4TNfC0xCIza914orLrR3v65OREwUaeiqELgw4A/nncdYAOGzp2fC51U6SJKooWnYscTcIDh7qkNMiWgCA9ZALPe8mLiF6TZJ4cqw9mpF3jUshB/AJVu9MKpD5rT18Hl4xU2zRYUozGG7W4ocHz+n0xwIbRk+wYFtcAaF2dqvBULT0Ic4n30osqqfY9If3PwCx3llPY9JZnhGC2YISoYCZ+6AAg1/zInV1NUmYYvjBH6cY/4UM2tPEwJmrvDO6piPdxb7ZDXAqigcCatxQPgpIhpiWxX4GgE53g1tGfksprMXGYlWGn852Xj5bRUmkmpuQbzPZu25Efl1wygZY2yLXKBzTcGPwzsS6hIaLHtvXSe4qYJVAl8EEaWg/kyZnOpQYnQXQcyJI11z0pqeXL9XnDibHSg0EbTSDxyvo6cLTFoeGKxr5wLU9vkWq5zQVeQ00KfCwgLlTLAVsGCO7G82oVyCj8q9Omnlv4KhQ19iVwihCGnuHlWHqjrqzBlzFOPl0EKH8PRgD4TD1/Rtph+2QgsJGAXfgL8eCUc6vfuHGP6M3VWm0dcBwN05J8aAXYDve/aPxAcRIOdUnfX5a2tOUasuKnIlxhE/Hv05ldXfOOzhuKY2ZeStFExFL0RUu4TXukpBo7ul6ULWZmN+OSbbJkkzmBd9OwENw7yqZ7+dZ5DrSAyCG52kwtZKcl74/YR4D2NZoQ0VFzvM0wVK57PF667otB/YlXhNLa+Z7XlWNo0i9sp1eLO42oKH9Nal2cvYFKbTx0ZRcaWSYsVtbpwsFqXK8KK0zrY3x5mt4XGklWW8lGfxMUb3YgABeP0RzpPIylbSS26sO+I
 olPuNrA0
 qEi9ucNeYJ+nF9ajJhYwbH6VbgopgCFRbkINLITnPBkjM2wWqLJsZvc6ZOli8PbCDKqdvR7euC67/V1KwI3ythknPQMt4rzQYcb6sVnaz9JkeN+t1pilsjCOHOxWTJZbNWR+CYFNIbl5ZSY+o7GDD2I6Ae9IaSQAw0Wzj4jzcKbRW4u2NlpmOg821747yVs1+QC1K9gDch6OgmeHsDzvLrsqESlmG3QUHc3ANzpHsVEgOBHt+J9Vh8Akv+pquVePtTyiwde010z7wdQE3RjcYsdLgAQQXMkFfYc2voVviwSX69KbRYo1uEfmIJ7IskHojbaCkYLb/0mgwU7Xk+umnOMgRs/nvFKvH3DNnzqjjcIV5knw07NN6Z3wrvezrHDW9VHI4uzEM98+QcbU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The linear weight in get_type_to_scan() can easily be overwhelmed
by historical refault costs when swappiness deviates from neutral (100).
As a result, user-configured swappiness often feels unresponsive under
memory pressure.

Apply a smooth quadratic boost based on the distance from the neutral
balance point (MAX_SWAPPINESS / 2). This amplifies the weight of the
preferred scanning type (anon vs file) while avoiding hardware division
via bitwise shift.

Assisted-by: gemini:gemini-3.6-flash
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index dddd2ecf970a..2fd1e06eb192 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4838,18 +4838,42 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
 static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 {
 	struct ctrl_pos sp, pv = {};
+	int anon_gain, file_gain;
 
 	if (swappiness <= MIN_SWAPPINESS + 1)
 		return LRU_GEN_FILE;
 
 	if (swappiness >= MAX_SWAPPINESS)
 		return LRU_GEN_ANON;
+
+	/*
+	 * Apply a quadratic boost based on the distance from the neutral
+	 * balance point (swappiness = MAX_SWAPPINESS / 2).
+	 *
+	 * A linear weight is easily overwhelmed by historical refault cost
+	 * when swappiness deviates from neutral. The quadratic scaling
+	 * amplifies the weight of the preferred type smoothly.
+	 */
+	if (swappiness < MAX_SWAPPINESS / 2) {
+		int delta = (MAX_SWAPPINESS / 2) - swappiness;
+		int boost = (delta * delta) >> 4;
+
+		anon_gain = swappiness;
+		file_gain = (MAX_SWAPPINESS - swappiness) + boost;
+	} else {
+		int delta = swappiness - (MAX_SWAPPINESS / 2);
+		int boost = (delta * delta) >> 4;
+
+		anon_gain = swappiness + boost;
+		file_gain = MAX_SWAPPINESS - swappiness;
+	}
+
 	/*
 	 * Compare the sum of all tiers of anon with that of file to determine
 	 * which type to scan.
 	 */
-	read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp);
-	read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
+	read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, anon_gain, &sp);
+	read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, file_gain, &pv);
 
 	return positive_ctrl_err(&sp, &pv);
 }
-- 
2.34.1


