Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E3FACFC283
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 15:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3F96B002F; Fri, 21 Nov 2025 10:22:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5747D6B0030; Fri, 21 Nov 2025 10:22:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 489ED6B008A; Fri, 21 Nov 2025 10:22:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3544F6B002F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:22:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1DCF4EF45
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:22:54 +0000 (UTC)
X-FDA: 84134981868.13.816D288
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id BDFF740006
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:22:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ePowNP1R;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763738573; a=rsa-sha256;
	cv=none;
	b=mJa2+o2NInr9YpYV2p5V7CqiJDfRB8/9Olpw+gQd4x68VIRPIZ0MpTrKcmHOvzkwqjMXwj
	aDq1LQuAmrtMTs5E8edjvtPSBADTChXmlJCwAwkL0xSUcVzeTo6T1MqEn88yRy9H8C66MG
	e1I2OQKXF86g4zhu1g+ApOD5jRsf6Kk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ePowNP1R;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763738573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WNtuz16wzgGzcpGZS8JYKE5/YVgpkKvVzgsqWl4Ntwc=;
	b=DqRiPrR3p1/ECE/YcOtdYRYQa5LchB6LfQC/Wm3wrHqpHxjZYkxO1gX58M/RL7dQIbMwZV
	hoq/vz5SSAjZiKH0WUsusYOSs5ghuNgafiwIZ/ceQ76Fee3Kq3X36zmNfgelUnMLys/8HR
	lfisxzF7UbVK5VTk9bp9sr/vUsuGS+Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763738572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WNtuz16wzgGzcpGZS8JYKE5/YVgpkKvVzgsqWl4Ntwc=;
	b=ePowNP1RSuRZ8inndJsI8jimK/M4wKyUAtm3OAYKRlFJlb543TvEALwkQWTj2mrd78ihM9
	o25uGGP2sOFIxWKES1h3J+n1mQtaPgBCuN7+co39Z6WXtJHfx/Ze8b12v45BDaanpEX6P0
	TF4Am4uc6Yuaz33Eid2IO/mXptONxQw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-327-_PUgaWA8OZiLGT2AKOZ1zA-1; Fri,
 21 Nov 2025 10:22:50 -0500
X-MC-Unique: _PUgaWA8OZiLGT2AKOZ1zA-1
X-Mimecast-MFC-AGG-ID: _PUgaWA8OZiLGT2AKOZ1zA_1763738569
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 731261956052;
	Fri, 21 Nov 2025 15:22:49 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CF354180049F;
	Fri, 21 Nov 2025 15:22:48 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH v3 2/3] tmpfs: zero post-eof folio ranges on swapout
Date: Fri, 21 Nov 2025 10:22:45 -0500
Message-ID: <20251121152246.1023918-3-bfoster@redhat.com>
In-Reply-To: <20251121152246.1023918-1-bfoster@redhat.com>
References: <20251121152246.1023918-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RD3U6Meo4p8haWip5sLMHfWTCJrH6H2LGZqOPpd6bJ0_1763738569
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BDFF740006
X-Stat-Signature: jur58cdww51gxb7yaej6cwy8mpwmsu4q
X-HE-Tag: 1763738572-278568
X-HE-Meta: U2FsdGVkX18ApC7f4QpsUpMM8fYVuK+l5xwuvGbF6FjcxAH9/W/czBu9SeCDsl49W2iOXC/fpEDbiChgZwGv0fLSrJwD/KpTffjti3AAmv7ZSB0bRsEClDp3VMkeaYAvC/svrWW/tU4U5L1mV46pUMIKOt1FXfZN85UR+A3ENfefSr2IZ5NZTRWPOJGjuLyzBv7z2DhQuu/+bTtX9ROx5+icr53TfTmp9KxEnEbdkYijS7ubUPSJcPobWk+1ZYmE4/YG76qHKfydoZY6Mg10+mIqdNi5sqaKMrkRjh4YLsMZ2Q37ZGeN93PlvcDHK5vo9zYBjFidhzb74f3AJcTxP47rOtFj6zFhxpUak5v7MRmB9kRtQa1FIrWTKgMPZL4Q92hTQuSGhMndMsV1GRR2ivWSc66LVXnG22Y1m+kH2TBTcAMxmL5eFc1I4Wlr7wx91JgDiqChQ1bLiAPLlUgjBLaKmuiVBP/e2Zej/XK1s9g639NX1TilztG1SeTGn70sqT6I/eu67zFBzPd1dvr3QXVH/q+xfMWukpzJ3bf1R4pjUGeXIGwxHKRhDx6s9YoXYEatSYhiRLXZKDzZ2hJZzPHyZ6fSQx92O8CT4KrHOro9O52bqmN+XpewAM6x/Ev20z/2P4InjPVZqtm0iPSN50pvezCB0tlLrcvfTny8TPZaRoGF4AkRIDGQk9JeWcinhcp9GWTYRJ14Y1w0o0cCa/FJsghSFVUv3HPXGVCwnLhWD/2pAyNVGgItdSKlbLEDSt4lO1ti70zainsDZd5qvklPgsZY8/tgZojelTlKJTalYwkk51SLAiA0EuhZhCEtmgSlJhATIl14vmA7N3wZTPFysZ9fROyrw4OlBAWznQrOquwq0EDFvxZ9b7mrJyTBH+yyUbU3Lm8N1C201k3kLztyQm8lsfAHD/JgCpMZMqUO9lRGn9i8H0SyxLzr7XizNLpAd/MW7XeW7AitEuI
 iNMnSDCU
 f+cRd4vhVIELUvsNKNijyTMhaPunEEX48Z7TnroiFpugD3MFY0lbJJ+Ww2c/HmxPjDFKRAF+YE+JInqesOLuAncW41VJ8Tjx9bfFWgNC00mewV+9m/BAzGH8Cvsh9bAVX9xezXYX5zlPwfZmy13macmzTP+RGNIZ4kEwDuw+qNRJ582MVroZ5u6hhFrgU8BWPj5nlxb602VpV4NaanzCOeevS1GDItkFgwLzHcx6V/Qfbqw/tWN6gmMhTzBVtI6rRaGOcZasvKFIoY7wbemslQMhI7qFS2obV2Dgyj5bOw2X9U72o+dgIK9to8CqdrP2BjQb7sLHn/tGE12vkp93Vv961ztkGa1/fcpm+FEmsnwVXyjIVkRnAY568AQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zero post-eof folios at swap out time to help preserve POSIX
requirements and facilitate efficient post-eof zeroing during
extending operations. This uses an analogous approach to pagecache
writeback to ensure post-eof ranges are zeroed on-disk.

This facilitates file extension zeroing by allowing it to skip
swapped out folios that might have been preallocated beyond the
original i_size.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 mm/shmem.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 651602460770..97ca2b3dd1b9 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1577,6 +1577,8 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	struct inode *inode = mapping->host;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	loff_t i_size = i_size_read(inode);
+	pgoff_t end_index = DIV_ROUND_UP(i_size, PAGE_SIZE);
 	pgoff_t index;
 	int nr_pages;
 	bool split = false;
@@ -1596,9 +1598,9 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	 * (unless fallocate has been used to preallocate beyond EOF).
 	 */
 	if (folio_test_large(folio)) {
-		index = shmem_fallocend(inode,
-			DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
-		if ((index > folio->index && index < folio_next_index(folio)) ||
+		pgoff_t fallocend = shmem_fallocend(inode, end_index);
+		if ((fallocend > folio->index &&
+		     fallocend < folio_next_index(folio)) ||
 		    !IS_ENABLED(CONFIG_THP_SWAP))
 			split = true;
 	}
@@ -1642,8 +1644,20 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 			goto redirty;
 	}
 
-	if (!folio_test_uptodate(folio)) {
-		folio_zero_range(folio, 0, folio_size(folio));
+	/*
+	 * Ranges beyond EOF must be zeroed at writeout time. This mirrors
+	 * traditional writeback behavior and facilitates zeroing on file size
+	 * changes without having to swap back in.
+	 */
+	if (!folio_test_uptodate(folio) ||
+	    folio_next_index(folio) >= end_index) {
+		size_t from = offset_in_folio(folio, i_size);
+
+		if (!folio_test_uptodate(folio) || index >= end_index)
+			folio_zero_segment(folio, 0, folio_size(folio));
+		else if (from)
+			folio_zero_segment(folio, from, folio_size(folio));
+
 		flush_dcache_folio(folio);
 		folio_mark_uptodate(folio);
 	}
-- 
2.51.1


