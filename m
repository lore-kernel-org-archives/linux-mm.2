Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82C02FF60DC
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0EC6B0095; Tue, 31 Mar 2026 03:37:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E97C96B0096; Tue, 31 Mar 2026 03:37:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86E76B0098; Tue, 31 Mar 2026 03:37:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8D836B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:37:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 656DB8CD85
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:37:56 +0000 (UTC)
X-FDA: 84605554152.15.AC962E3
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id CEA60C0005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:37:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="JMoZD3/0";
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774942674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Qge3MorNS1YgycDNr3wmwHALhVcOGjEeMYPPOcQMBh8=;
	b=eq40sNJR1spgaQXM2BAkIp3vg+SEYNujqv63DaXxL3ws1FGjAXt2tORa5U+MIobIhq9Ypx
	QC+woxCwa5GlfctjfMSPXtJYvf6ydUmvRSmt0bsArnDb7oOCtKRZOIOmM8NgqsJvQO4FRc
	55Ymb26Zf+lt8afeoxsrGap0ydSwlgk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="JMoZD3/0";
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774942674; a=rsa-sha256;
	cv=none;
	b=uxkwt4fcYEM4kZNhdRC8tutFy3QzSeZj6qvGOGX3kO8qNCj6Aze0ePOxUC98e4gcKi2z0I
	PV9vk9H7c52hV7Wojjhm9C3BpIFi3xIRf82qkoCMpp/0lmbsfjGjndynxX/8LeOoFGdOSn
	zZZDNlab2FD1uMesbH3JKuSg2Hgte1c=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b0ba3bfe16so41049065ad.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1774942674; x=1775547474; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qge3MorNS1YgycDNr3wmwHALhVcOGjEeMYPPOcQMBh8=;
        b=JMoZD3/06VMbHdOPqhaN332Z92CJVrd0YRD8GC3p3H/3bI87+F7SKxqxvJFowwJPMj
         y2vIMTr2+iTD76/fKU58Y5D15hxeWb9eY+eFq51RJpRF1w/IcaL+HbCD6rP7MfTJbGlg
         dY+8TeQtLj/5oQ7tLv97mYVkeFQ5rwEuprCyA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774942674; x=1775547474;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qge3MorNS1YgycDNr3wmwHALhVcOGjEeMYPPOcQMBh8=;
        b=hBMO7PeiIHG3Dan61sSNhwGJGOcTsujJVM08J4iXBPH366u0aBzaBOn0gp0zPcCrch
         +7FzVodN5V6zme8Qr125tQobV44YrM6iUabRZJAN/vaMZ7ZNtRJ9O4x8cBSYM4trV3pc
         IYdDJb/VqYqzsSdQ2jvaZLqXDL3d99q/OD+ZPLDOUJG9IW5bK0fMVlGG72Q7JcusaIli
         pWnH26YIwoRf2ZuA5Eo+QrP6cmh68NxKQkhgo1df9hzUlGLsNzrZgD2zGdG2UoYfyxee
         VXKPQ5iNYKzyaSaAiEUKBitkAx/CfAtM+OJll/JfzPusj7dYDLOrTTdkVLgz0E+uWgDY
         Fhrg==
X-Forwarded-Encrypted: i=1; AJvYcCXulRl8jjcRnbkWKfYZd164v9oZY+UR70IvfGnJK/C4BnyBVs4tMU4HlSZ5iStLbQJX+Ks4VGxTPA==@kvack.org
X-Gm-Message-State: AOJu0YzOq3nuXudtCTZ8+ik13yvsmYFBV20x9e0WjGQduf0Xk1kBG4qO
	TrL1NhraaMbz3gf/sxyojMUXwLS3Iaiy1/6if8Qa9JzPFsaD8wKllE6kOgSjYUSuGg==
X-Gm-Gg: ATEYQzxh8cNVANkB2p7ef4oI5IOS2ZJUDhMQagCm5vhF3ooOsuYIbyDo/pLIrvRZAeb
	NQXB/PUhHKCDSdpPIVc8/RJaxAKU18Xg2o2C/SFu5rt7gb/yArVaU/6oNUri6fmxJwdNWukuFJT
	XyDTEE2FxEIrUWyUMjhA0wrrB4gTACxWGHD6A4YtMXdV+H1dhnPC5u3Yq83LwE3/q/MNg9c7y0W
	3bGpL/VTlpdnelQVwSmoQYA4rNeuE7/KllNg1QAE3WdJrw1zDvK6n4madjB5TA/U52oJSduZW9w
	cxuLI2bv8zJTnvA9HZf0Rwn0Htjcbmrjpog9KtiWX3MwwxsV/4M4Ejg7GZByJocvRwTQsQVQdzl
	69yrLvJSv0PsC2G9rMmCYukTAzN3W0QXrzhKwwf4tXcE3P7jNcmH8cifQKHCRnu0eUbG9hfFaL0
	rU1niR5iIvjl7CxaK+K61OFYL7Ee4wEvYydfRJy7kaUE11nodyex8XzcJKUpe7tq+J2Z+xO8G8Q
	yUmhjQvWklUgA==
X-Received: by 2002:a17:903:32c2:b0:2aa:e47d:e3b with SMTP id d9443c01a7336-2b25ed654ecmr25933655ad.0.1774942673664;
        Tue, 31 Mar 2026 00:37:53 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:90ef:61f3:1679:56f5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76916bd67dsm7848596a12.3.2026.03.31.00.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 00:37:53 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Qu Wenruo <wqu@suse.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2] zram: do not forget to endio for partial discard requests
Date: Tue, 31 Mar 2026 16:35:34 +0900
Message-ID: <20260331073737.774503-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CEA60C0005
X-Stat-Signature: amqajknij45478di5na6j4874hrco1ie
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774942674-827963
X-HE-Meta: U2FsdGVkX18Z7zrp6ChANLtOJmvLOyUAMh+Gw3V03PBjeAxFzmhqBYrVScTgfFRWw9GOPtLUNX90a0ZwFkrQiK4bwWOHUtEckresTprwU+LS8910fM2SS3LnIDj2zmlVar7oSpgs3vejtcR6RFxWcnqRUYtooDSw/U52AalKiYuTgeFyBdbcljMJ+rl3xGe448nC4aIzgn1xs8oa3DHB8kKQLQ/ejiYAY6lckD7w44eNkhBSsNbneBm1EF+i7CAUG5uAktQPShoWXj1XT07if8MBElXYoUGmMsPE01oWYNjfSfR4ensMsyAW0w6JsRxjDeiBlKTtibgNVG/ycyeKbFeIsPeqUYx6WkWuAIauhw1Yf+VOw3S1NXwPWcpos4ky//Zn4WVRQc/wv2drpW6e1xuuN1JUl8TFZeQ55cl8WO9tnWMW2XHsHGrulAquMHCVMdEnlHz6w6v49KLRxYF/A8B3iJuq8UCiMc2xNwL9kK5tAXmSZWRcWVBztOP6Qc64EesjOts+F6qHXbICpv/dUH0OAzMURuz5jdfJhKRJKeM0B+B4hdUKKsZpWizt/eRBNWShHW/JV6LKfu01mQqpSdSne3tbH5JB9mpat226RrjotTJ8Z7FwcO1L6n+2CbINujhfCmYOv9w/EVxs7QZ/hoizyhBEpyeEg50O3c89E8olKmu8JMkl/Ake58HxTzHb2GvlXHNcwOzoJqapu7NgTswyZqNwmNY0qv192v5be0YvnjI2fBjtzyt8ZiCVfaWxb910w4PsoS2vgo7SHdQxarKaE3A0PHEg92HzIZKC9doXuNAE0ITM23attxvX4Zk5cV90sOSnJA/WfY8HltQK+bb66oBkZ2VrSs8oBTBnxei6gCDM/tEPZhw0KdmPPXB7kDVpB07AwKiC7gW+8OAdjC2SolqptPrBz+NoCIq+ba35rgf4pKdPbxx0x5AF7+JtrIGbkpOQX2QPtxFVB67
 6kjA3mFw
 bB0JL3l9PjOXVeq3rMyxzrRqUIg==
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
Test-by: Qu Wenruo <wqu@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
---

v1->v2:
- use goto end_bio (Christoph)

 drivers/block/zram/zram_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index dcea703a6766..aca67d7144e4 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2684,7 +2684,7 @@ static void zram_bio_discard(struct zram *zram, struct bio *bio)
 	 */
 	if (offset) {
 		if (n <= (PAGE_SIZE - offset))
-			return;
+			goto end_bio;
 
 		n -= (PAGE_SIZE - offset);
 		index++;
@@ -2699,6 +2699,7 @@ static void zram_bio_discard(struct zram *zram, struct bio *bio)
 		n -= PAGE_SIZE;
 	}
 
+end_bio:
 	bio_endio(bio);
 }
 
-- 
2.53.0.1018.g2bb0e51243-goog


