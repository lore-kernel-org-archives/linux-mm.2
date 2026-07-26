Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33D18C531D0
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 01:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55DC16B0088; Sat, 25 Jul 2026 21:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50EB96B008A; Sat, 25 Jul 2026 21:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44AF76B008C; Sat, 25 Jul 2026 21:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0575F6B0088
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:29:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 46A8240436
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 01:29:58 +0000 (UTC)
X-FDA: 85029196476.01.13FF358
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id AD1A340009
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 01:29:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E1KtG1cB;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785029396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y1405Ze3xDfa95m+4L62HBoV5HB+8jDRTFTlAXIoI1A=;
	b=3BHE00qm4sBG8EOESBDCOnY6VlyfiS0kjmLOGwH+wGnDejyAS19m4hQORnRC2g278zg5bf
	oBbRkZQEfw1vvN8RHnfQNBFNZ4134kdXl/sA+q7WsWWrsrJdWaaRf5mPEooIoTaRVpRScU
	AEo4AtFboXlnG4ZTp5dTaVbTfeZqqj4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785029396;
	b=lV4Sc3iWBUpHEk+XIq7oAun17KOtjqyY+mzm1Tbiua1arXfWeL8/mxSWE5SvduAvWbbcHb
	WgnD1amz89n8IvIX1FS2feTyEH3SuKbL+PxHi0C9IyZI2C+eKeMf/0acZXU3m6eLk0J3/6
	J3zmJeNPzv5+gqdWY+6EeCXnO6vnyAY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E1KtG1cB;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0209B4056E;
	Sun, 26 Jul 2026 01:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A24A1F00A3E;
	Sun, 26 Jul 2026 01:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785029395;
	bh=Y1405Ze3xDfa95m+4L62HBoV5HB+8jDRTFTlAXIoI1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1KtG1cBh3txhpViXIqbLP0yE3ILIk9Rhj9EXYQke/MQNX6103UJDdN6gnsRa6WkD
	 CLHYf9bkoAI69RVJ+ES7fQkYB3jxvRUP15khmt9OYBiN6JtBxNKCF6sxmmmy5XNKoH
	 yJ4y/vUsDT3mxdHKl26XVe+qiEpdbsuyi08ojNLpEPx7tcykHE023zcHS9H4az/Qb8
	 faN8hTnEeD6RundhoGRduKJLDtqFE8KU/9Lo6M7eDs5IJWT8FRJkPFVXF3sUmsTSUg
	 bOWFm7Wldx3+mSxNLm0coq83E5sXZQ8grBhSPJG+7jSo2qSJJYch4LwDk+UBwuYDab
	 D0I59yXBHHOmA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	linux-kernel@vger.kernel.org,
	lyugaofei@xiaomi.com,
	stevensd@chromium.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH 1/4] mm: mglru: only fall back when reclaim is running at high priority
Date: Sun, 26 Jul 2026 09:29:43 +0800
Message-Id: <20260726012946.18684-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260726012946.18684-1-baohua@kernel.org>
References: <20260726012946.18684-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD1A340009
X-Stat-Signature: wm9gani7ciepd5exxu57sh9m61qgudzj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785029396-913647
X-HE-Meta: U2FsdGVkX1/SQos8Dtr4rBOmUvFYshMYdn0RsRrlMFXTfkidiuSuzi4Pme3w/s4W99i26FJ6iT6QvSpYD4v/ubgUehhVba2vlvLOTS22O/Yhj0vQBXAvtcjND9SdWuqkKGW+EXShNNiI439krWAkFULqB30vCiKCyXJeN4UJ1RPZ+KrPB1YV8+73hfyoD/novi3zUEBKuPb8LR4f330gKX4dmlwPPag/vp2R2xH/OHENDdaYRFNIo0+6mGg7ywIstJJ3+sjLJcSIsDrxoZB7x0AW0Iq9FWR9PM+Id2P6bPW1TU5wOwhDTpwMLfjC2MmOQ1utzi8sG5jnjArtk0qSR4ns4ejqwdfV9c8J6qeGRxadexvc+BVmKn1e0JRV/ug6U7+9mneJFd0ukiv5bOh4bwnWUpPc+y0vIKBuvIJ8T4o5HA02euZ4baipPKOWEgrR2jb5cqFu6Hp2Qoefy78oCIQ/KqaKtP6bqbCXpmI86LE5Y4Prd069YbwP6hOo8HdInmWI9xMur3HjFDV9661TgsERetKRwZyfz6OKPXdYliQpHF3c0erLzxS6KX4F69vxdREociFP6txyPDTQU8Te1I37zLzhfATK1H5tX6IehkX+Gs4K6AK6Hs1g6OPZxQlX18h1m/SJo4P0BslVUOGxxyZpKvek7WN0TcybwLFqBnVaVIiZ5uNGcMBSXvxvxRxgJMcvIbQ0lBhHnJLY0ailRtEeez4QBN4WBkExLmDrZZhwexYc6E0VgLo9kaM9YevtA7u5yj2QEeAbeTdUNUvC9WVz7Fj2gx50AGwOZv9/fbkCCIEY5upCd7rOnuKGgmh+0mGuFa1RBWMJ8Vf6tWrseQPh5/rKGlS3QDwmGAUCYyQ/DXuhHObD0Ykt+BGnCItgVdokqAOkN2+pdSqW9nt1jGwnKsw8vmGpuzRaluRqJ7p2QFR+2m41VLeoHLli+GTbpw3DNo9vyTWtu2ov/cO
 pmYoE39r
 1wFT/6BW7FXsF1Xrd+GHyGt0zmatkEmiHhUYs/Ez0vtEnUbunL0K+dX96AIe6wPkoo7EcnQX9QgOlq3cFWCYhO6IBVZg7fnFW08GBPv8RmGetecnsMJa7RJZFSZgtWLEimIzZB1JR/2b6UR/oUAZKaEbmk0SKBCng/yAFBxm1/TdMVhLstybWLPAYulY5iqFauCvwCJf1ZHojEYzlR4GiJZF9ev8L4C9XeYBehcxS8npk0+gA6PLtpCDwOdMfuGwOk9k0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Respect the type selected by positive_ctrl_err(), where swappiness
controls the relative weights of SP and PV. Falling back too readily
violates that bias.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 566c4e837c7d..f79402760776 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4855,9 +4855,12 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		 * If scanned > 0 and isolated == 0, avoid falling back to the
 		 * other type, as this type remains sufficient. Falling back
 		 * too readily can disrupt the positive_ctrl_err() bias.
+		 * Only fall back when reclaim is running at high priority.
 		 */
-		if (!scanned)
-			type = !type;
+		if (!scanned) {
+			if (!sc->priority)
+				type = !type;
+		}
 	}
 
 	return total_scanned;
-- 
2.39.3 (Apple Git-146)


