Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D579CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 12:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27C0B6B00A1; Mon,  5 Oct 2026 08:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25A756B00A2; Mon,  5 Oct 2026 08:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07FD56B00A3; Mon,  5 Oct 2026 08:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5CDC6B00A1
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:21:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6DC43A6591
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:25 +0000 (UTC)
X-FDA: 85288482930.02.C73D938
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id A26284000D
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Krw1QAeh;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791202883;
	b=O+R4dUcylP5S3bpVPdCNqTJxRR3mTfyvxzYktd4++likOKuZVQ0oi90LzXZdW36TvBTzzQ
	0K0c7TFKi/3TkISdDw4rjBH3/EKgk4nSHHJuAd3Imz3nEY3CJPvLqwAHk3u9+Z39mn8OCG
	GpA0QONqPdrS+oldhJwXIIWg48dKbIo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Krw1QAeh;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791202883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEfqKq8AUXff9rV1VBfaaWIWwsRhsIZ+aEa8DBn6+DQ=;
	b=Kbejcr4Evo3VzXVxSnV91aJoZRyJQBFw/5ZOTbPxKVEpvLb3vWgiaKVWL3IDqbtIXaE1Xk
	WvATioC4cUFydW5QAQxLqntSSlo0z8b5iZaXGnFRdRUrS1j1qiuUjLXTmH9t5z8S7u8/ld
	1KyHbMqnsGxYznVooCNOhZecYNfl0LI=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3a7d283e017so716040a91.3
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 05:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791202882; x=1791807682; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JEfqKq8AUXff9rV1VBfaaWIWwsRhsIZ+aEa8DBn6+DQ=;
        b=Krw1QAehA7afXOyHUwjlb+gfHgsZaUd/bNteAOrBiyOuFdMhbph6B7Y84I+/SfFCsa
         iDr/0m1Sgw6+IweDe6I9F41BlrEjjIYMGlYD/1gHULAFddQlikZwVAPy0IRfA6nYO5KO
         qQTc+jPdta4NVbsre/bIXe/2cea/Dm0wGVQSE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791202882; x=1791807682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JEfqKq8AUXff9rV1VBfaaWIWwsRhsIZ+aEa8DBn6+DQ=;
        b=aJZAvGh2OQsrzeGlRKRcDIlaaMZBrFhiH65VqZ3W4It+uPW/a54GUI5zsRY5eVe4rw
         HI4naM7HPYexOrksAoy1aRmZneqYXEpuvkkCZboMdERGWWGE+AIsuvDnOfdxu5d1xiP5
         WrBPFDnHoWDeBcBLa28BAkGOgfB7kK3fIVx8TFFC4dbbFS07Jz2p7Edj1gnTKQXbdKkL
         v96RUKuUSqX7sxrprFZSHsCOheOGGRq/JpaXSmLTfRDFC/EAneFMaT/n/127PregsuiY
         R3yK0Ntf9DwUpHa/wJviObcEo9c7dsuNsOWASClpZL2Tv7UVzYWbkf7eoFTgNo6GQO16
         e9Yw==
X-Forwarded-Encrypted: i=1; AKwUvByFyXVD3XIB9+0bPp1KcS4+ndDfKmgu8E0fEEPCapyNZ6hiMPXbokllnaV8Wtj6ha+XnHL3jgQXSw==@kvack.org
X-Gm-Message-State: AFq9FYII7TxmdjhDzj9A5NgdpE49vSoX2PE7YIJd99pfH8u1GHkTIp/Q
	zQ7jKtbB7Ss/Wyj/ghMmRuW84b2+HfGDaZBJ18VWoaDZyJ7hbaA/bWszp2zMpq3NOw==
X-Gm-Gg: AYBFou1bxD8rBRuvNVZ9ZUtY1gaTl+ltFLzLAcg8Ph76R3HXG6y5sgBcXcydxnQYBwG
	2vgYiSUPrb2GxgCawjEPXh93g4ito9SiwD+Z+nICZV28XKBkzXIQMBuvfTQVqS94gbexLxVqVo0
	Mt/34mnrt1p/BVvl9UkyPHVkAiVbAabw2d5WcTv0fwlTiRHeUbB3maWDjjFe59opctvutf7zPpY
	390+fztexsHPuS9aDkxy/49PYQC3Q13pIjM5mC5SQQxBohAFJOG7Tz2US/TvM84qHG8MXG2Y3M7
	oS174ds54wthy57st7SkwHPbjfnxNKgoIQRtW7LQc6H9udoL1Vv8SBcaTI+Y0SRaM/hGm9degxA
	Q492KZZ/LamYEb/QoBS6SfKvboku5VJNUTbZ5kkw7l9GJoDjJvmXBFvyhsCHPdSHk+QG6in7/7u
	wkDud8ABRjKDqPi5SM6iAV7lS0kKvG/e15hw3XOIfUwZTEPfQutDFwFZLJhctYftARLeTVxCoXY
	GZe+CYfGosEhiOjIRM1HwQv4IcQese5lEMDwyQOmDXF59SZmpbFR8W1QpWbwkg=
X-Received: by 2002:a17:90b:380f:b0:3a4:eebd:2410 with SMTP id 98e67ed59e1d1-3a7873df65amr5816685a91.37.1791202882532;
        Mon, 05 Oct 2026 05:21:22 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9211:ddf0:3c6a:bf9e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a7e4b00de6sm3342997a91.1.2026.10.05.05.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 05:21:21 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 08/10] zram: reset writeback state in zram_reset_device()
Date: Mon,  5 Oct 2026 21:20:23 +0900
Message-ID: <20261005122036.718976-9-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <20261005122036.718976-1-senozhatsky@chromium.org>
References: <20261005122036.718976-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A26284000D
X-Rspam-User: 
X-Stat-Signature: ps5or67589mioj3ca15tmge1o6ky6snx
X-HE-Tag: 1791202883-282043
X-HE-Meta: U2FsdGVkX19PrdiLYbbixYSnHApcWrUgBR30oDXErXvK8PDOVsEOzcueeU6lQCdZY86fZfAcv/ZBw8Nifj0YHLsDAOHytQddpfl8u4/okYeN1/7I2I2s9ChX6ooSZNdX2e6rIr+8j8jdS/5C+rV/VNsozweo42jc4TKks+uWkt3gfkluFXpNpwXfdVzYueZFQr5tuX9VMNEAzlRImc6eArMU8WsvU0ilHO6/Upm010DGZ6jqwv58vg+cWYzoTLVlFv1FrFzo0eY6hOz7ovXaF+7esBwn4A9kClm1bCyMMXGVJsvXLhXAEbvXKMsnvT6V3vYXFzuNXVyWgrUgpZFBdHhP7fQtkh+Hf+7fPFL6ZzhuaS7g1qp0cfo4+vnxXatxkY075bgfAR4OHhFt+91YLqN7GuZzZ8q6pkrMm6iy+vZYfLyNDN+h6o2EUJn1fXGpRKbEAv0kggqGvXh/93Y1ElwTTAGTip/zDLx4qIEO43RxIq0Y5ZzShGYvK/udzoNCK8rNhVM+wzupDhlFaNy8kXVGfFReqBgz+oWlBGIbnCZCVTo7v0UK4t8YUMKmvLsckOBShz5wE4/ZYkC5/LoSfHDAMeheMvEhiSJ3aK1FypEFEb3VuBTh6RDasMbegwTf9BNPFzIeT6HFCXoIcckQf3kVKsmtmuyL3S8e0tHIE0GkGHL/uMDP5a99Ir6u8xuWWWOqPsiknrVKGwTDdWiLDrwYICIW0iHqJn7I2S9wbfqCglzc2tF2TLqcnmvwrKFbABtOc5cuNfZ55PI4slzTLAP1JY0kw4y8npkEs/IJgALd2/yt2+bMyDCWqsrb6biYAtxJ5xmjkxvYpdvI1LzKPeT1U1sDVPxa7MEb6FEIvIbQd1NOLgAvxJprzc6PAP9FNzBJp+GIle5xxp0WcGeZyKIJx76ipa5nD7Qe4mVlQ5+t4q+rC/KTmtsuIhOdFJd/lA0eGf7MGfFJXit28Gj
 CbuDNR0g
 1BRIKGFi6qei0umLB1qF9B1FTZGKhVEQgx+weD00aPDRzQ+7m2kqz0PiTbdDYemvFSmU3uO2ZMEhrUI6zcIbBn4DXeOz5VR37jLfRXHTHzK1fiN4Gen8KdS22iPKBATao0CVvxBXoQ7uDt8UMgijY1I8C/G6vBxbiJcE1Cz5+0V6snsuoXUU0C+Eu+dqBGt41Lm5jUbURZPy8y7SVPqpSW4ZkG0/cR0rhqqSQKVWe0oqgXY0GtE4pcPjOI2gomhxdzbTH+RfqoAyRBuQpF+T1NChm8hLtx/h0VeCyiVjsEYFsDBom5NVr5eEmpeqkfH8U6NSNtAumFTGzb351qUzEqaCuxzfcP4NU8u03
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
2.56.0.rc1.315.gc6ed9934b7-goog


