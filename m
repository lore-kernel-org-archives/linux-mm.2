Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED755CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 04:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453886B0095; Mon, 25 May 2026 00:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425356B0096; Mon, 25 May 2026 00:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362106B0098; Mon, 25 May 2026 00:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 273FC6B0095
	for <linux-mm@kvack.org>; Mon, 25 May 2026 00:46:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA389A012D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:46:57 +0000 (UTC)
X-FDA: 84804707274.05.5C3048E
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id F2A634000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:46:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=VGHEtO3U;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779684416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mYO9b4nBy6nb/eNXMOncyTmIUMd72bXkjtRJ+nbJfwo=;
	b=nrjlFysSgLNVtKiPKjxSaJgYI2kokxysOHmnWsSmFNGy1Xck6B2RxLFbKu92EFYP0os7m8
	DlvVosD9ssejXAzp0tDHXmj4NVjSYsRQCGnLOtrrSApWjSH3fir1X5pIbvE6vCSEoDcIwX
	qZ1Z/F+tG39Crzt0VWzWFtXMiEmysHY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=VGHEtO3U;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779684416; a=rsa-sha256;
	cv=none;
	b=aOKmae1Ssos7ipJPsLrY/LgDRmXfoU7hvMblsUnVuNBC9Wwcdvi8SsvIM4lSTfWNwgq1qM
	6GAoHR3KL9+G4/+wE8G8NxK1nz4oY+hmiEE2TceDopHFk+x4RUwkGCJBTt8cLmx8RjpXjU
	YIs5LR9YbP9qQrXsu6sOOcyc2Z+aQ/s=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-36ac67f489aso394052a91.0
        for <linux-mm@kvack.org>; Sun, 24 May 2026 21:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1779684415; x=1780289215; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mYO9b4nBy6nb/eNXMOncyTmIUMd72bXkjtRJ+nbJfwo=;
        b=VGHEtO3UtsiSSW2+x5rkR2vUqVr/YFhu4fZoIG2WjF09Zdb13zcfRgO3oLWv+vp2IE
         miyz/u7MPGKjuz3Lq2MNgXKVMalpMgqLdgMnwfCrf3WXKjp45zUqO1zNSNErcwzZ9wf9
         e1J2hnGqWNCVNXAi1LBcLj0yaYPrOEC2SbxtU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779684415; x=1780289215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mYO9b4nBy6nb/eNXMOncyTmIUMd72bXkjtRJ+nbJfwo=;
        b=ZuFD0p3rqYUdHrigizwohlfbTUTslgYN+563mixWLqYLemZl6Z+iziPfbNdsAiboPR
         vHvHADH1rlgLRrs2D523lrlDpsdbZW7QWDrZlFlsSuUku+9N9lUir8SRHReu/84EuiFY
         XiXV9N8kl0CmKGB8ean2r3BCOEOieepKTZkqspkqnFwNd3VDDmol5l7ueZb6Lx1b8ZGT
         fPsaWN1liKWvdZIAC1prsr7fLVkdY2RD3Rj4+VohGe0ch5MLu3eUZjTIfYbvpFWccr5j
         qDO1x2h8kJC3BuCX9SDOYjIDDWKl4VkThtqLrsX5tJRcjXo4NMe8KvOViPAAhZgsflCP
         qAlA==
X-Forwarded-Encrypted: i=1; AFNElJ9eqgh4rD5kyhRsDa3WVgrhUVOXQy/MFS2zeoI7lLEh3IQPQZ9pVq0/ScC3U6B5UmN7ec1i6iX+Zw==@kvack.org
X-Gm-Message-State: AOJu0YwIAyVSs7P3s0NkdXA4KBZEFGbfMiKKWiAxgMHBUJPbUj1UITUF
	odi8WHd+5q8/+4k8NSSfXIC1axorb7L90sEvrXCha2PTYkz2pFMORlkUYufsAjwFdg==
X-Gm-Gg: Acq92OFyfwclKDqxgz82V4xR2fucpZrwTwwZA+bZz/3ArMYZ43Jj29W2sH6kjVkOgg6
	fy0qEpaoU7YbWdMtjtYR4yBEVctqBInLpAULOmWVFHg+dvo19J2nzO62d2udKOoyI+DBahiRuhe
	NT1i04lGElhVr+f6ziFSYa+ZrwY+u9Ejla3FPR7Lt8GmU7DEmxRrbdFUyfPSvV8P4ri/o5TnlO1
	GkCqNcaYsPCoCy79uhearAP+XelghLu0gDh4gwv7vNxv5WJ6fh5OtmiJAdy68LavzoFICj9TNcK
	bCJKmxjkGSDVq1c1IY3OPEHdTJcvO7JG4p3hvdq77d8xQh290NFSf3Ii+8jX7CwojzudmZ12bh4
	y0B1scbRqj7T7LNRwvh3d3kvTnzHeBaZf8+eVz9+gv+B48Db3yYIxgbfjLpOuCnLf0fpNpRW+u7
	l0/3kPJ2nn41jtNKUVIqlEhRa+mxRUh6sTE2ICM15ZmQ7EdhIIwIAuKYdJRHO9MFGLWc9CrbJM8
	fi8XfL3RYqF
X-Received: by 2002:a17:90b:2712:b0:35f:b9f1:fded with SMTP id 98e67ed59e1d1-36a6c79dd38mr9694674a91.12.1779684414811;
        Sun, 24 May 2026 21:46:54 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:8f7:7157:3ea6:a126])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a6c680110sm4361447a91.4.2026.05.24.21.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 21:46:54 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 1/2] zram: do not leak blk idx at the end of writeback
Date: Mon, 25 May 2026 13:46:01 +0900
Message-ID: <20260525044639.1888561-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
In-Reply-To: <20260525044639.1888561-1-senozhatsky@chromium.org>
References: <20260525044639.1888561-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F2A634000D
X-Rspam-User: 
X-Stat-Signature: aobi4wnhjwiamxfnrn8rwe9getcsxhyo
X-HE-Tag: 1779684415-81536
X-HE-Meta: U2FsdGVkX1+ujLo0wXuvk7zxsTixKvToivVqw/7ZAV/Wo8HmCaR+P5pQSxEyouZUprD91JXVrb5oeOnTqDKtV8bK/hdNe3V94OsGCuxqlUnCJU23oI9xnvcU6NlwRGF5NHgrOrh0mPi3UAQP0vLgdUk4QoiMDb18gQnxQDq4Qm8XF0LnnSgouQia/L0T7uAd7CoA+iI/ODmKT0WHvPwHb8Rt6KfnYBEMPWDo83Pv5PmXYs8wUQGo0f2MoUB/GTsffYm2qB5WED3vU2j0+NBLmHpZj10FgGQOAYYeg/0IY1gqEKI90eX10DQLAl4blyy4cn0q3jsHUnOuJJ2TicbI40YhREMzGO5MtbVHHKGadyRUAcoAQYOzg1YEc4zEESbsvol01/BJaGgk3p9UgPS4LUgJZzRLvNGMzDL2PD2SkSa6AQKiXCzu1H03wc2jQ7IxutqwoMJm4ye4sMRal3j7SYHqyRNd7KGQFE2TiducUNZKE4RBILIknGdqBgzzwUpAePwwR1AQS1FDAlp0bBnqjjM6qydtuHqImiMcNAsSWXaECIUa+x+2L4iBwEtDrZzIXAl3PFpy2lap+6Q7diIcWMAEzZt51qg7PBh3uIqlAOruNYzCF+oIO4o4HLWAKeM8F0bOHCUP9BeQsUS9maGrlcPKr8AuS0kzNsdX5Cz/Dqrs3pbzCkI4q2TmnMAxf43t2/rtMPxewoxbQ9lcuiodSLdMdQ0H2LXqjgvJvDujgO2ZUP16oh9D+VApqrH/W2zlDL+/iMXcGyso10CHsb/NRIjU49FdhJux8jBXzg2zafsB7X2OFrA3DZ1Y6vgwQuuR74QO1autqdbRovh8vHQQrsInfWpZIY0FNgijHZjxY2/twedsK5xGJV9X9nhqFHyjXhCYQjREji1r9p2YQevAJS6a3saiCTZ13pAGbeXt9qsV2MAvi/L4surpdR/0cYP311kLSwmt6ew1BBLtLqq
 wMDJJ8kV
 fls2XwQGvAsrzUvkcGiPd3imV7qY2sNLyoKKniUQn0j8AWomQRHH8fSooxFZhoeieSmfmQSjQUt+UlrlU9zZUFX5TdOhvuXL7tOI+TIYc+EAmLUENx2RCgDSM0RgMO1ozpjIZwahMH5wJZMuZO9Su8Wg4V2DZfFRgqfgdOMvFnrmvxJl08Y/HcUFO/wT3ohzXRLuzZgSlCKSJREzlzooG/PyChuagaW11zZUhd8sEPG5s3gLkA1cVloQ6w1GwteiAkZvtILbFeQRsBkjMaGc/1Xnas0bUKAmywZip1BCdenmdkEzPpp7MG7KsGNHMwgUPBzDZRhmR8fg8+JdfRbLHPwNiL30rwWywLVI9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In certain cases zram_writeback_slots() loop can terminate with
blk_idx being valid (in particular when we race with modification
of last slot) but zram_writeback_slots() forgets to release the
reserved block id, which leads to this block becoming unavailable
for future writeback.  Release valid blk_idx before returning from
zram_writeback_slots().

Suggested-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 07111455eecf..602abfe23797 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1127,6 +1127,9 @@ static int zram_writeback_slots(struct zram *zram,
 	if (req)
 		release_wb_req(req);
 
+	if (blk_idx != INVALID_BDEV_BLOCK)
+		zram_release_bdev_block(zram, blk_idx);
+
 	while (atomic_read(&wb_ctl->num_inflight) > 0) {
 		wait_event(wb_ctl->done_wait, !list_empty(&wb_ctl->done_reqs));
 		err = zram_complete_done_reqs(zram, wb_ctl);
-- 
2.54.0.746.g67dd491aae-goog


