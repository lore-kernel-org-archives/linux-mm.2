Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD2D2CA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:12:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EA486B00A1; Fri,  9 Oct 2026 03:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49B3B6B00A2; Fri,  9 Oct 2026 03:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3156A6B00A3; Fri,  9 Oct 2026 03:12:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA8116B00A1
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:12:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 667C8A786C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:41 +0000 (UTC)
X-FDA: 85302220122.08.054FF0B
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9387A1C0005
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="R0slv/m2";
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791529959;
	b=cBU4ucaw9kJzW93lJLdVp4brArpYb0KoHNzhTRjkyaFz64BMWqEKyZNTG3SgdomdA9G0MB
	iYvoFi9Tl2tujkTOj+umveJuVFPQHHyLyohSHvoFOAqe1Yvz6pjaEWBjCLsHQB7LY+YhN1
	3Ztuw136x6nA34H3seuHIUj6k7idQxM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="R0slv/m2";
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791529959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O7Z3LGH1ZkWROJK0VS9Mt3KioBTwm3wp4tjW9v7CFlU=;
	b=RuPBdgvaB8XQeGYeWYilyzUI2EAlqchm2LbGut0SDP0mV3NDJQw10vZqnjapkL9PliPLoZ
	dEWAtJ2kDTGtefEIeH3LJQOylvYLl8uVgtgww2JO9AKqfi5MzbEflwmDus8MCauBO19yVA
	eWJ/pX1F34iNu7MgOG1hnAnUrm4pNw4=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2dd9cbb661bso30670095ad.3
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 00:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791529958; x=1792134758; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O7Z3LGH1ZkWROJK0VS9Mt3KioBTwm3wp4tjW9v7CFlU=;
        b=R0slv/m297aLuLmpjVX4id7YfUH2iFGBO+/5aFhNlecTN0uGL754DTcRCcq+h7kaiD
         5EDWdcfSaU6g0F85C4IY1SytXonJfv36H9l1TMyPoRy2Jl7mdfgITGo2emPi9C72AMNd
         GQLpyWooN+tfhWfhxgoaEOo7YdaMc5eZ17Ji8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791529958; x=1792134758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O7Z3LGH1ZkWROJK0VS9Mt3KioBTwm3wp4tjW9v7CFlU=;
        b=L9KdMnXzklH1CyM81qV90kVKY9eRyjAr+Ne38ZtjfQT27DXiJb0xy/o2Te4JoRoeQe
         MAkUq2EXL4qwNu5IlnSraMxOV/p3u2vf38yisO0eOW/18ujAxwkFDtr6EXxb1qnWlMgN
         q36dja/Op5k4KsX/IcuGd0t0mvCxv118JjwqDxKDwlW0YLVLrTNLU/sLx2jb81a3PSSK
         bsCAQTHcBo3IjO8YtIz+7fPQlJpWNJMeXzq9rtPUWMGnx4FBosTndCfMVQB5wqQR7wv1
         zr7IbkdvPrJsIpaw+roxr+kPfhTjhVDTV4tm2GY+4VD2/vhDWzPJfQLz/WCR2X+0c2ph
         2fmA==
X-Forwarded-Encrypted: i=1; AKwUvBzAFK9KBRFljElZBmF2/0Hvl3wyL04DaXBsbUmKefRhBdmebqQlbBl4QcA3jIbLxLBc2XN5SpXteg==@kvack.org
X-Gm-Message-State: AFq9FYLKAXiPWLNIQ4Pa9c1VgbxUbkMU0mqyVit7dZW4uG4daBLi177k
	C5nQ+rUNB6F5D6Jf3MPH0i7BUOGRz7bhnmoqz0x9uRXqhHaH/6cLar3jv8tOmJ7G+TeCSIT2Bfr
	hB2E=
X-Gm-Gg: AYBFou22TEflji9exTpfhgNxpZ4yc2+aGjGHLDOUa8Sk7zdYn+XSFHab7UsHDx0zsEg
	yDO/tPH9DeHUXdEDFDNYx8XTl747oi5XVVU32G2p2/lNfyMqhBi4r4h/dJnA8anRVTG0tPGuEkv
	iU4/lD6lXVnvMQI7GEnacBTA0fW8CqZPVNSC7SYnWWVF4lxuFHK8IzoPTZmiImzEsicUi1cdc6L
	z9leVNC0mB/zZsgKFUC7FFPcT9kKBLI3kLA/RMwQXLAFbTAW8gvys+cYSkDqVQXa/K8OOdiOtW1
	x+/c7x/t8u8JLHpoQXCuTU3PT7Y2wZHE/NDuzZfInNO7htAAwexMLhxynQVkhYklfX2O/gM3Y+r
	AZnxUz00xR8ujzfnPdQ+5iNrkNgMfr0rqhgyQY2GY4828GLKLojsGr7NEAO6d5PTKDY7RRHzkUd
	vJAVDWQ3bPgbY7KWucmluS9zWrucBBuKV67jwf0KInS9062EhjBWiiZyW+FchNcEz/IcUdCnWYU
	/VCZxqxAeU4p9WZ0mUGwUFfM6YN3EUSUwg+pQGutjRqLVyuwI1QtGqmv/wo/xo=
X-Received: by 2002:a17:903:2ad0:b0:2e2:c3a2:9b15 with SMTP id d9443c01a7336-2e84280d558mr8568925ad.6.1791529958517;
        Fri, 09 Oct 2026 00:12:38 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:383b:5817:8167:5051])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b19a2sm4483535ad.46.2026.10.09.00.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 00:12:37 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 08/11] zram: reset writeback state in zram_reset_device()
Date: Fri,  9 Oct 2026 16:11:31 +0900
Message-ID: <20261009071157.3730698-9-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261009071157.3730698-1-senozhatsky@chromium.org>
References: <20261009071157.3730698-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7sspfeb74nxsfm8pajynrehrt8nyeb71
X-Rspamd-Queue-Id: 9387A1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791529959-596423
X-HE-Meta: U2FsdGVkX188jU1ceya675WOMN1V8Seg0y/JjeFnoTolj8Ex6poXCuIjvRtIyjPQxAr7Y1gaADMvdBBk9WFQCk6BEWJnP6N07Wpf8y6S5kDQRI76aZJWRh9ocooC35asOcKagO6wafZf7k6RVUBv+B5Gi6C8g9vYed08jKzCZ4ZGF9wLSJQgxE6v64ZT4BqnNIY710B+5u7QLYww0ganP23gHZwYIQyRMrRPxjSQk8Q2SdK/ThiNIgF98tViY/pAVlVNm3vRKMKXfpLR5KKdSGCJO23vDRl4xeBJobnR9Td+5Hmdvp1yALmTLOdVTTlzkVFi/+kZ5H4CNBDxGR84wx2VVsPK1kEn0NlKWymqzsrOrU5fbs9hrLodbbqGJG0xA9glAsSVW5zsSOhRI73r7Tt1ts4ve3GTYWU0sXrUafNMokuQQNEFaWChZ6t8alf5uCjDm4FdDuL+LHrLtlnXvYv54ibhgQgcXxmWKz0R9F00hSzulFktyEEm6WReptxTPQpiqsujtFFqBSO+tWcFDXKViB082xzPSVaAYKGts7iph8/iTRNbUValhve0Lruoez8QZ9lwr/sYy7d4n65GD+4EAEe3rh3E18ecULOvuy7jVHL8OMW7q17ti83wUWr+5eQGCBEy51JFGFnjSqFD5wlGh/1Uw+5WExCD3SewlIB2kNxK6pzuXsd+bFd3J1I/MQfL9IDticYTR/KqEmlfL/WJhrq7EZaVTj5MoRyGBpatxZODB8Lw9JJe+bDNjGHYoJy2TwdMdE9A2KTuVH0lJxiakZkzHpeogUZwNg/AMF7hshVS4m+mELHLnkIJXff8JRFobQkYxWr0YL5LSZEnUVwO+N+waC1ibbkxtya9iOdEK5n9kHKeGEYFwuSpr5VCx61Ixn8dhpq2sbOap5Cjp/n4+/UXYH6ZxuKLt0Jx8IJf+wXkaJ7YiZKLn/TCeejMBwrmhBFUZZuRYGKEZT6
 pRxALN09
 CFaHmmA09cthBsKs6P71mr6Ot9ywfAvErCL1z7CozRpMGyj6ycbEsDGo1KwoL8bZeFSFJp4Y2YtvBK8SHXTzQOx+sQRkcD2YEfCC61ZDxbToszVwuLuUXLkYwxCuHahfcjK5h8kpwpf/P2pkHBQTajsr8DJAJO8Fd17XXrH/YOKtq6KUzsyH38BrxSIV20DHO4YDQQ1/+QkxRGKTvPfUpGMXo8ZgBkD7/QDDb82RMsjdySwR8hPk1JX2Xyex5JapZa4EYrYDZ+etxRm1kVnHV6YlVdtXx9JUw/09TYH4SfVVGykh4vr3QVqzka8jXFLPbNZiWNQ2fLc/fVHbFDIPyzUQO/Tlgwv3Z9T1fWSIQEIIh3WG5rsadXcEgHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reset all writeback state to its initial defaults on device reset.
We used to keep writeback related data in zram->stats, which
zram_reset_device() clears, but commit 1d69a3f8ae77 ("zram: idle
writeback fixes and cleanup") moved it (along with the newly added
wb_limit_enable) to struct zram, after which neither of them was
reset anymore.  wb_batch_size and compressed_wb, which were added
later, are not reset either.

Fixes: 1d69a3f8ae77 ("zram: idle writeback fixes and cleanup")
Acked-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 593fa4ae47c4..0e1aa0da11aa 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -694,6 +694,7 @@ static void reset_bdev(struct zram *zram)
 	zram->disk->fops = &zram_devops;
 	kvfree(zram->bitmap);
 	zram->bitmap = NULL;
+	zram->nr_pages = 0;
 }
 
 static ssize_t backing_dev_show(struct device *dev,
@@ -2881,6 +2882,12 @@ static void zram_reset_device(struct zram *zram)
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	reset_bdev(zram);
+#ifdef CONFIG_ZRAM_WRITEBACK
+	zram->wb_limit_enable = false;
+	zram->bd_wb_limit = 0;
+	zram->wb_batch_size = 32;
+	zram->compressed_wb = false;
+#endif
 }
 
 static ssize_t disksize_store(struct device *dev, struct device_attribute *attr,
-- 
2.56.0.385.gd3acb90ef8-goog


