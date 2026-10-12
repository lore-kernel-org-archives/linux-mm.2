Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25B45CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 14:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2905C6B008A; Mon, 12 Oct 2026 10:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268196B008C; Mon, 12 Oct 2026 10:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 131A66B0092; Mon, 12 Oct 2026 10:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6E4F6B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:39:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DBED1C44B0
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:39:30 +0000 (UTC)
X-FDA: 85314232500.04.CFA50A4
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id A2354180009
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:39:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WcfSFCl0;
	spf=pass (imf16.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791815968;
	b=s9/ip72ZlntZhFBAXT02sJ5vMkgjG4M+f+3TgjfcEw3aomGvWtewU8TuKF/7VHkmDEXBg0
	dWnX7fH4W8YKLJknUlUFeCUMatvCWWrHggzG3UCMFI6rwbUJmcQI0GmtS25tiBHgr/7Xba
	fZS9I6yWRbKBD1Aqfu3MakEYznUJSUw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WcfSFCl0;
	spf=pass (imf16.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791815968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8AhwaiJTOIO9yzRLrCBE5zRrRd3YyiOnh3b3vVnas14=;
	b=GJdMjflR36WyuxQgww+Lj5yY7L7e0xWYwtQSNY234NfiscuAvSU0ytQG4RaJ5qp+Vsp1K7
	yACrLPY3w3m6PzS/yuCqsnUAa6JAV6i1YNKfRIXOK8WtsGWXyzD4Q6NFTV5E9Pz/mTV+lr
	ZSmVALadPIPA7euPyuLzJXRXW1Sbb4A=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e49fbf92aaso10342025ad.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791815967; x=1792420767; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8AhwaiJTOIO9yzRLrCBE5zRrRd3YyiOnh3b3vVnas14=;
        b=WcfSFCl06q9eI5bV2Dd8XjVG60UUEUVpPIDiDv+SHjppDiruEN74qJHrYAwyJtI9IL
         e2B2hlwG4T+C1LElE8HjyXQMv1M6MfjR7/PpXRiPJXpx9d2R+RM5qFpbNzy7j20uFqAp
         F3bY2fLzykMaCZSIFOYCM4ojZ2TEQXJ00yxP6MvDkBsMOpl3Qv1W4Chd2/cfYD6NURW3
         1n/B6bjPDnRHpD7NI3HFYuabovFId2ZR+7FYJZuSlY968Eu/tvnBSpDeqxnLVX2b9a1i
         cMF226UqZABbx1lg7pxaG15AfdgDIK6S7VHqOAmaVv+sAEuaMRT2iNrNt5MeAjqsCkBN
         gRQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791815967; x=1792420767;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8AhwaiJTOIO9yzRLrCBE5zRrRd3YyiOnh3b3vVnas14=;
        b=KjafZDBlMVAaxYoIBzhQkl7ISsuX+PKNYJ65zUXFQINZI5m9LUwKAbIoEOnYh6QXC+
         NlHGtpYyEi2IvjvVQj6Yk5ULB9zSVZHIOU8dqqyGCPj1ua55LIfIHyfZxMntjI0/mC5M
         bNKHP8LQzIUiLcmPioLyCz1AWw3ZL9EgLVvJtYkh930N/bZm99tabxvK2Cda0bOPEs/p
         2k+m4D1fsrAldaoBXU2nshO2FoCaPvWF5PJYQvpHbfP56zXbPJlA6NUAvfonmZnUJkWa
         URSs0EpYZx+H2wLLTvcpIJ2rZLKY74JQ/xdBgj0aYzo7ZbMxTcE6xNSyTqUDtfViqoh8
         wXqQ==
X-Forwarded-Encrypted: i=1; AKwUvBzKjx8scrNgO/e5nvrq8u/ZH4mhHPIxnGdGIhFt8GNInwtKJR8jGGRP7P75dbNwCK4+/j1MQuEhmw==@kvack.org
X-Gm-Message-State: AFq9FYKmvX0M9/TNRyv6OVVi7c76YPJc+SH6w7cx2N+s/ORVidWHR9w4
	fDAGwV6law8U64P5S6rODwn9Ycd8f5ixD1Ev6SVEVkRSEtoe7C4fIJjxfGoMaR3+
X-Gm-Gg: AYBFou30XGy4KbfoaiY73kOOeFyYB8x4If4yboIZggi0qvxMZcotI1jl/QRR9FggSNe
	3v6EAT8AcnKS9SkclruMLyRTEmsCL60HrOPSJSFy9k9kND5wR03P87PMkyWWdmLCfKsv5umx16B
	cbeVt3l+eSnL+X7mLzWl8Iq3OXJYVCtdrcc4KCZpzT3tuKH933dBSaye/eW1ilA19prMrpYT+nW
	IJM5PpkZE90Wx0NhGSchULl+lxlHrbuXRkEGqOYXV88oUqpzfRrcTqiY+91DD1rlj+6JydDwhgc
	eU5kbNVE+rmfdfvshT9GtKCiuQtrHaSvWcOAL4xDFJXaqKQGWiwSSJj0frU9jttlgXTL9Hl4qxT
	ER4Kpm+/tO926/CJMBm0TLChfxGh/ZBT5LOi46wIfBYxzR2loE6agm6e6KQwMcmu9EN8qDAjAFp
	mOykOUh8AfglJqwaO0xWqDvsSZW/AU4y2ADG62dQGjJwAyM6hvOb7ihVMTnXfsgkfopJs/AQ==
X-Received: by 2002:a17:902:d4c8:b0:2e8:cb5e:c3a with SMTP id d9443c01a7336-2e8cb5e0cabmr24547315ad.59.1791815967347;
        Mon, 12 Oct 2026 07:39:27 -0700 (PDT)
Received: from thangnn-ASUS.. ([2a09:bac1:7aa0:50::3cf:23])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422db284sm42652555ad.68.2026.10.12.07.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 07:39:26 -0700 (PDT)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	syzbot+e0624b5bf72b99131402@syzkaller.appspotmail.com
Subject: [PATCH v3] mm/filemap: annotate lockless reads of mapping->nrpages
Date: Mon, 12 Oct 2026 21:39:21 +0700
Message-ID: <20261012143921.283806-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8cy99azuyb53hw4g8a6tenca78psb9eh
X-Rspamd-Queue-Id: A2354180009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791815968-223513
X-HE-Meta: U2FsdGVkX18xnqxsUaKeNzLHeJtbAbQhaOexCNS9Yot38SQg6J8szoBoWqAqZQ1JUtQdK2XDhSKHf2owhglyuHZeP8cs+W1yRT2e2xOl9Ls88Sz0M99qyaLS3xKW9PxhFQ+/UnWb6n3xvnst0fWfCb+D+EAJGOYhvZYoBmuJeDT3JSUVjl8sfZ5fmNA/pmfqNeZ5Z1ExG+YkPxSbQtUVp+3uHAegzStW9CnXPNluN9SdwwNRyZPPYlmvaOBjix08rRx0LmNP8tFnzm/xpT5pixZ68qYulwFjMXCBQW9OUY06+5tco7RDJg+/hefxHlI0KkBxUP1WlKD31p7b117fEHXzGqM+bBrQpOI2/mfMKE9EA9LBibY92lEGVDpUOFh7o6VBfuII2yPZry9IkeRaag3ZlkEnep0RdA/gue/3DlQoujMnZCUQSmHfUrdMaI5prq1nv8JyLE/hqDhtRMVMmOcDXurih7uYj4vBxztgkSrdTffSjAdMSmd6RwzQxn0UwhqvzgacrYkfA1ci93hbgAtczik4aOSTezhztFcog2dqqy2Hclgy05WkjeAXZ3xoo2cXgBCJKGmZNPjbccK0cx5sqzqlS7p5YNWG93Tde/ze/UHaMzWmACPmODKXGdpRenyrUo9iHoj0coYZjmeY7vhIzoyXZjWHMaeo81JPTyK/tYX8mAyngIKPCoDYriRiB+ylDEshzelXy3eINTKPfiqK1pyw+SbqtdTMTF42Jw13jYYQnet57g0aN3G2qFApiIvwRHuw9pMNTAusJpMvHPobriIjiz1UPbm3WDbjGSJoXBbkHGEf2CJdqMeGg17kfLOaaO2xacB1fsLnn+dv9CPuauhRJyFAyZdAM/4acWqfJJOQuboP5amEaaD+Kvm5DbRVz/EJ1BzekTNeIN0YxE4JSQrQ/mHfSnloMzaQhpmIi3Cz+jFmPS9Me8u1dn4DMslb0jqiCGEGcG382GQ
 KMMKQJ50
 J0EJaVPd5/JjPZTbAMb6vIdEi61fu8i7LI1JAEosPDJmiKTjkxMdnl7lhpv70I4NFQFFgxVIRJ/IPDsJG2CVmACWygo+bQJpuJELUh3UftX9a49w+MDbiIJVvZGrlUSjV2loNTqIj18EsmTWp2FJmDTVJuNuvpUhBc6hYdRBxAeELRKx2fFT7FXmHJ8oHI+vjzlQ2uiXu8w+ZL6gcOCvxSYbMoG2OWtNbMxaN8dTIHX3JM1wQ+5mCtm2nLHm54Avo8eGwbZhvvIaaZC/jfWC1rKtdt0m3SNjidnAJYEnSVv/Iiu98/KixZe5Ht+mocBkF7l7GRgQ2rWzcWEpBYw2kns2wwTk3Wpqb9QXPxz3oMW6zJUE0WJlAzMFtJrf7+kGsMTvjbLuj5vLnPIVVa6vBNX3G9YmH/gbSAkapzLNRXhW058U/54I2hjqs5Ad5TEIJtzFTXI+NNVExLlW2YjZhjSUurnrmyirOZUzaKnmozTqIIzuODhc4/a5A0GBBJn9Asg2zoQVe0WfrSGRtMzRE0Qk/TukVsbua5y7Gbd+a8aBDVBLNqJ/sWwnBjNv9ho5laG5jYSGLBzWHcKNH9T1Xs9mgNt2z6BWoOtRqNPOsqHwYUvvJRVPGwFn+cds0eDr1IZNR8WHpdlL3oOhnxaqWuYrKZeL2m0OlKBbRtVb9yOBE8LM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mapping->nrpages is updated under the i_pages lock but is read locklessly
as a cheap "anything cached?" hint, e.g. in invalidate_bdev() and
filemap_write_and_wait_range(). KCSAN reports the race:

  BUG: KCSAN: data-race in __filemap_add_folio / invalidate_bdev

  read-write to 0xffff8881004c4178 of 8 bytes by task 3600 on cpu 0:
   __filemap_add_folio+0x6b7/0x910 mm/filemap.c:919
   filemap_add_folio+0x1cd/0x380
   page_cache_ra_unbounded+0x1a4/0x3a0
   ...
   blkdev_read_iter+0x21e/0x2d0
  read to 0xffff8881004c4178 of 8 bytes by task 3601 on cpu 1:
   invalidate_bdev+0x25/0x70 block/bdev.c:98
   ext4_fill_super+0x2ccb/0x37b0

The same counter also races with filemap_write_and_wait_range() through
mapping_needs_writeback().

The race is benign: a stale value only makes the caller do or skip a
harmless invalidate/flush pass. Mark the lockless reads with data_race()
in invalidate_bdev() and in the two callers of mapping_needs_writeback(),
rather than inside the helper, so a future user needing a reliable answer
is not silently covered.

Reported-by: syzbot+e0624b5bf72b99131402@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e0624b5bf72b99131402
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
---
v3: move data_race() from mapping_needs_writeback() to its two callers (Jan)
v2: use data_race() on the readers instead of READ_ONCE()/WRITE_ONCE() (Jan)

 block/bdev.c | 3 ++-
 mm/filemap.c | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index cd8323083740..233750f87e6d 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -95,7 +95,8 @@ void invalidate_bdev(struct block_device *bdev)
 {
 	struct address_space *mapping = bdev->bd_mapping;
 
-	if (mapping->nrpages) {
+	/* Lockless hint; a stale value only costs or skips a harmless pass */
+	if (data_race(mapping->nrpages)) {
 		invalidate_bh_lrus();
 		lru_add_drain_all();	/* make sure all lru add caches are flushed */
 		invalidate_mapping_pages(mapping, 0, -1);
diff --git a/mm/filemap.c b/mm/filemap.c
index 00fd89cf6f55..ff10ac8f56b3 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -680,7 +680,8 @@ int filemap_write_and_wait_range(struct address_space *mapping,
 	if (lend < lstart)
 		return 0;
 
-	if (mapping_needs_writeback(mapping)) {
+	/* Lockless hint; a stale value is harmless */
+	if (data_race(mapping_needs_writeback(mapping))) {
 		err = filemap_fdatawrite_range(mapping, lstart, lend);
 		/*
 		 * Even if the above returned error, the pages may be
@@ -782,7 +783,8 @@ int file_write_and_wait_range(struct file *file, loff_t lstart, loff_t lend)
 	if (lend < lstart)
 		return 0;
 
-	if (mapping_needs_writeback(mapping)) {
+	/* Lockless hint; a stale value is harmless */
+	if (data_race(mapping_needs_writeback(mapping))) {
 		err = filemap_fdatawrite_range(mapping, lstart, lend);
 		/* See comment of filemap_write_and_wait() */
 		if (err != -EIO)
-- 
2.43.0


