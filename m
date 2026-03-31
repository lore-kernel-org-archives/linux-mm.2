Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E26C5FF60DB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551006B008C; Tue, 31 Mar 2026 03:15:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FFBD6B0095; Tue, 31 Mar 2026 03:15:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7AF6B0096; Tue, 31 Mar 2026 03:15:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 24A086B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:15:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D90315C378
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:15:57 +0000 (UTC)
X-FDA: 84605498754.05.577E26A
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0C60D10000F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:15:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=S6XXWgiL;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774941356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hBZW9JjlCCiEdLUd24hKtYoeuSUNPJmQ9yAz6YgyHRY=;
	b=yGVlryRGNZNmwvKVfgqw4LIzxac5AQm3/wN48DyS7PV3JiovKrTk+YLkZCfpsbF9+G/gFR
	R4CYnLO5KmWfft8QVaqaJ2HZcG6jHTCw4Zpw66FxZapoK+auOt8tyMIpwi8XQMPhGSJdWc
	hBZACxRUWsDCuCFCx7dQTpfPU98c/lY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774941356; a=rsa-sha256;
	cv=none;
	b=nT4WkbkQlqmGYFGuW9Er+NoNBi5l6iQ1oP0Aih0vWtMI/APH7cE9kgcKWsu/bVzrPdDrF0
	A5lCK3aEU2e7soayQy+BMPedeoPJmuc4CwMERCmCtPFk+q561Qxh35qIDknytg+hFEX00P
	1HmfWlKlEqqDKU1MhzVpORFSopO+Edc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=S6XXWgiL;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35d90833cacso1915811a91.2
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1774941355; x=1775546155; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hBZW9JjlCCiEdLUd24hKtYoeuSUNPJmQ9yAz6YgyHRY=;
        b=S6XXWgiLCJ/hoesxw4XVaZfM/js5ROy4q9I3tgZ1Ek4sLlIbDmGy9gfnPTQSJBQDfP
         VWRId445QnYeS8h8MECh0mzS4qZxe6FcWvHAjB7Sv665y5DPp3PnEM5r9YdFMuRpSsPf
         T41dLlra/IDmtdypvOKwCCKEEUcxJySA22HMU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774941355; x=1775546155;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hBZW9JjlCCiEdLUd24hKtYoeuSUNPJmQ9yAz6YgyHRY=;
        b=m+NNLAb7QFktyMTncUKCq6ypvyLMp5wQ3hBVoo0l0grphC1/htEriv+PXDWseZeI6n
         vgihQS9g1veASUefDPO7yLBYDA+S3A2oMC3AgSXLQtzK2vPBdtyoDys00XGuKJbOZIkM
         O0WV6Z7P9Meu9SxhAgTXSK4GHAK1vCYofCuCvVmZL7bw7fq82cSSGVnw8QRx/780+aWO
         RnZNAMT83j8BN7DfVQnKq+BHitudcYbH0Rtzqw72BhTzrCxcprCZx3o5NHekehe3QfDx
         PQST7o2coZVcjzlHRbRJHeiCAWPSq7W0ZMNsm0u9DV3Rngey1RKlTZkVC8hcMLxMt8NV
         u6YQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5JAkNumaRnG39gY/rn/Mpy/x179Ak5i/1kd98IPsKH3FNV2IcwbCTVzh4nRDIAlYsb6EAbLs8BA==@kvack.org
X-Gm-Message-State: AOJu0YylWG87PG6AHHiyp4MAvq9NOqkAxH9dpKrlfL7PL7RBBtgO3Kha
	wCYkPNV7yVVxMThSdthFrjhd/RkMIzllgQnZILaXHDOCfhOrf9enaHJ8M9/8Zl4nQg==
X-Gm-Gg: ATEYQzyihP0PZmIUwmQVSbVRs5dIGVuUQH+mFbS4xDDtwDgl4toqMkrHpe/5mbJgLy3
	qbscLOdqlFJL1GqM/2NUXzSJz+VCLDFIEF54TjRGngm7IOgywPhUzDbjWHuEo6JpnfdDmIO3RJq
	3mZh+FlMg3t7lRkYKxCCkmZhWc4JcLP+ZC4UdT+4fmY/vXh/1H6EL/D41WNlR7I/8VSD9WmOZVn
	iMJYy8LX7YBOq+nl57ys76iwCjOcjUAv6T/4hy7KU5TNJsLS3Q4g6Lb0LwKZhR41E6oQdgovYGE
	8qvuI0jjI7J48YadMrX9uHydiDH3yKavNAXhup20Quamwd2TN0KajEl97Mob87iUou1cvxyAek5
	MclOUh43fVEDmueCJdgHI9Q3ITXhf7Vtl4Vd47n1BdvogUe4vYePyRUYSu9tbrKlE3SNILELYUu
	X3lhevbuK1ONjDmH//q3zjXI+SDYIomddhfFIqoVVNqJ2Jaa9C0T3uBHI28V98jW5JcaWvP0luO
	Wdq2t+ceZiR0Q==
X-Received: by 2002:a17:90b:3c8a:b0:35b:952c:43b9 with SMTP id 98e67ed59e1d1-35c2ff8b257mr13908581a91.10.1774941354917;
        Tue, 31 Mar 2026 00:15:54 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:90ef:61f3:1679:56f5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbba1daf5sm331975a91.14.2026.03.31.00.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 00:15:54 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Qu Wenruo <wqu@suse.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH] zram: do not forget to endio for partial discard requests
Date: Tue, 31 Mar 2026 16:15:06 +0900
Message-ID: <20260331071537.706139-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0C60D10000F
X-Stat-Signature: d1cqb9bewwxcbz58zbkynk87rkq17iyp
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774941355-784171
X-HE-Meta: U2FsdGVkX19DNZo94RS7PcevF0X305MaXHGK9QpQaTjSc8jtshVYrlg4IzMPtIrJhg33vVPa+LHCnVBrlkITMgYb2Qp63Lhm6PoF3R/PWOdOghsWnk4Gse5ZAnhvLXJ2NcWDQXl8hq84lpRnHqWIIxBu2ahvUqprOKEQnC+hAa9aZxEiAsDtxWExvWS7g14t4NmeiJARduB1dsyQcrF5XtkyXNjK7myutq/FRYUTuwSeAei4fpCrerlY8Yloq0et4RZT/ZTS9khaxjZTkGULm3m9Yx0MOKhLwNB1z9azf2y1sk/YFa1YFpBE3qYMG8A0BVq8WFD6FL6mH80fMsfnCWptorfQZLdXQhTeTuGtPXSi7yXTArGmvJI/1SJAMnco+jsehuIEopjudTVjnlaSzQMFCkZ7vJs6fDQyjVlDZkkzFZR1a2iA54TybuKPXGWKQtpZDlKnIlFzXQiR/qf5nwzwQFNcY3tNWld+oI0b+4ohTHqrBhiiRhvbUAmIgO3v5sMfCOYOyyLw1rg2bUckv4ImLKEOzf7iyIQdwOtpxUbmLldbhUdJ3yyCyRgwLFQ3stOitLL4HSLLWr8yI66EQjJYRkgH6VecyiaivoZPuhl9tQ0/sLnPVKSI0CHYpsFbVoI+9dctK5s8pqPONuJOYtekh2k3L8Il2XnedOs8lbpIl1PP0/byKYv22X8di3eODxl7F2iYHFU+pxdUkzaYksWGDVg2JNQB6nyp20VDSZsPMNOoGy7rIfLCY22FpusfDw7hneXIDruUQGolCQhCvcZh/hlRBX2CKabJasPwd2UuA0GNdCtyebSx+QSEG4uznE58ZGzoT2GxtTSt+OqXkSrvAs2T1oz76lIg9Yq7ztKu63lpbjiPi4JwyGfReaMGyff7K6xyzBYeHD8dCpJRK0V/gJSoti99rUsI4xUUCVLGXuAyObUsQMx9A+BNO/zECW7YFQZflq6FoqlM6Gv
 k+mRlF++
 huExSEsue64A8PVZGR58v1T0NdE5T3gGjt1tssa0pE2CvUvKagVzgNup4wZ+uZySPvkcorEGt1p+oqV4f8eun+IUSVLSX1/XyGO2Ci2pBTG5TxGuh2QXCTUjEBWbnZpWMBRVGv26WxbeLFDpDgDm5qF0Scyn3aVufv2hN5BH8PpUCy/CXNaEcY1l2MCVr3OtYKClZ6bzuP/OsHCTMF/eoNpOzWRWGrY30HoEVtfyfZKDH44PzhF1j6ufmaBLBSH3BgYmgS5VB+euqAZObDjmSwR2prnSIBlgaR8xOAc6j7m6/8FPT6QVIIiieNABFnjXPUKcuBFtzScN36pBzmvGmXKvgBaITcBmU4QOjJy/ZFjoXaEhFM2TVSMNnk5yVFyb+BD1I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As reported by Qu Wenruo, the following

 getconf PAGESIZE
 65536
 blkdiscard -p 4k /dev/zram0

takes literally forever to complete.  zram doesn't support
partial discards and just returns immediately w/o doing any
discard work in such cases.  The problem is that we forget
to endio on our way out, so blkdiscard sleeps forever in
submit_bio_wait().  Fix this by adding a missing bio_endio()
call.

Fixes: 0120dd6e4e202 ("zram: make zram_bio_discard more self-contained")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Qu Wenruo <wqu@suse.com>
Closes: https://lore.kernel.org/linux-block/92361cd3-fb8b-482e-bc89-15ff1acb9a59@suse.com
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/block/zram/zram_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index dcea703a6766..b0637423953b 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2683,8 +2683,10 @@ static void zram_bio_discard(struct zram *zram, struct bio *bio)
 	 * skipping this logical block is appropriate here.
 	 */
 	if (offset) {
-		if (n <= (PAGE_SIZE - offset))
+		if (n <= (PAGE_SIZE - offset)) {
+			bio_endio(bio);
 			return;
+		}
 
 		n -= (PAGE_SIZE - offset);
 		index++;
-- 
2.53.0.1018.g2bb0e51243-goog


