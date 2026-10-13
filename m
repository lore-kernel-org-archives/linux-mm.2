Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 177DDCA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 833826B009F; Mon, 12 Oct 2026 23:52:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80B3D6B00A0; Mon, 12 Oct 2026 23:52:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 747DC6B00A1; Mon, 12 Oct 2026 23:52:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 455806B009F
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:52:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C68ACC0973
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:32 +0000 (UTC)
X-FDA: 85316230944.02.ED95302
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0666340002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=MR5IAADj;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791863551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xtPVlUiId2ccKpm7W1Fnn6SIyzFCa51LSmz5bGyULA=;
	b=P6M3XaJSiuwugY9gHfoA9jPgduc7PgS14gBROVYmSy/FjANL2mk/sYv9uBb5qvk42Ghtz0
	j3CQFZOa92k1jxOH/tCRyrtscsnX6wLa7S5SiK4NppFM4i45u/Q/cPgX+ZgHdARZAVHx96
	MmwDINkDdhqn93EGfiz43QzZ6e/S6Dk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=MR5IAADj;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791863551;
	b=7IJAMa7boIPsvxRI7KM3h6YbO7aWusRHgtsakqDirAS/m/SFbhzU/BiP6LpBfXem48brmJ
	JSIp4xD+50W6HEjvcKwPnEmWXZ4tmSFhwF7BoFVtlmgCrAyJ/PuiHdH8KjNe91sFmHir7j
	W/9mshPN5iVkTAHJDw6gDBYCV4bRZXA=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8917c712f32so1039572b3a.2
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791863550; x=1792468350; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6xtPVlUiId2ccKpm7W1Fnn6SIyzFCa51LSmz5bGyULA=;
        b=MR5IAADjlonlJ9cjFqlqJlqQnd6htpPjj6++297oklt4bn251oG+WVtMNtE+BH2lRm
         4mICj9sUBST6Wfks3kMa7NH+K3jFiyNRGM8Gj84PI8c4yw9mrpJEEDy5+9VgJU8ThZRW
         /Fften6W68V6nOGS9qYNFagCQbESUY3FUU+vI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791863550; x=1792468350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6xtPVlUiId2ccKpm7W1Fnn6SIyzFCa51LSmz5bGyULA=;
        b=ziVT27WUq63oTheuwLoP+idfenD557e47XtczAPU++cMZyScZkKMk1noQiWWcF7h6Y
         79yh5/KGArZyyR0k0f8nHfCYRluNGd3x2G3p6a1jgx0YUYVdgCNHW5HA9KYqA8c1mx6X
         Zx/8QXbBvtiDjRoyIg0vbtHZyDk96kyiTLWPo1bS7Yg/DWCkY6qtVPh+TUjfjKl2YM3X
         rbP5fPsXFDuCgmjRcEMhWcLJMHq1+vPy6/k0vZNlTAmc9d39zKeiNLCSi++fdxldbNLI
         di3o0K0cq15yh0L1wZd9cHiJKSFZZBXGlG51RG6GnLf33aNRGSMtynzv8H2mTFVK7TSb
         N2Xg==
X-Forwarded-Encrypted: i=1; AKwUvBwGsDaNiXYmTuFc0XKP4uo48iwFE/OaPGpgWJ3BsuaMxZ0SzrBTiW+IYykZMkegF1TiYKZCmA1O5w==@kvack.org
X-Gm-Message-State: AFq9FYIcFP4IFHDEHEgzwaUigetl//biWJB8ZiByuk77zd4//YgpJCH8
	HIBWJjtJYbU01Edbb9MH04Q9k5MzUuezmS4efxUCHnOgYdKEZLsRKL+24VZnZCl72zQPr8qbXQ8
	v2sc=
X-Gm-Gg: AYBFou3Wb77h8vd2skQjZEXMMjF0hp+PnydPnvhkYnMfggBihRYWnEGsFLa0YpddCac
	f0u81GcywT96d6kwc4h13DYh66qPHRPenF9F3UNURgkgTqk3VPamQnJ2+n5edrn4Iv3kJ3rv33Y
	AipyixjiH7exz94cJzzvJTp8qp8turDwMwHtksXk+t4j4uEB22II3hhmyUGKeKGkGL75x16sI3V
	Wb+cJTg0i306keCIIPlO27akXUO2H/D28t+IDUZtgLKTc33gre/Y8Azsjgu/B416ghT1Zj8uj3S
	K1+ZZC5aFGYS1YP72mAbEriQC0KYIoLxpUsbmgGX4KKSUTNUk641t67NJu6oZeIclOaXHVo3JQy
	mMzSvNwJCw3ddsAuWux3s4BV4RvCmv1H1xYg6fhR26cj+47trmZuX/st3ZoXtPnmXhhGAI4c0+I
	SyfmyS8nwT+5qOu2AUKSV9Ml7sUF/Bq1j7hi0fyA4l0Inf3qSA//vonkgcJJmCZsEPYNQl+USMC
	Cgm7/jIJrfBtudyXZdMOSAHF/huoW6r+zLmpTwW8rBO6kjDZFTDRvkKcrXmqw==
X-Received: by 2002:a05:6a00:3d11:b0:88f:9fd9:3779 with SMTP id d2e1a72fcca58-897c65410bemr9764142b3a.19.1791863549938;
        Mon, 12 Oct 2026 20:52:29 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:476:d384:7c2e:1579])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c41bbb27sm4326818b3a.40.2026.10.12.20.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 20:52:29 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v3 08/11] zram: reset writeback state in zram_reset_device()
Date: Tue, 13 Oct 2026 12:50:55 +0900
Message-ID: <20261013035201.2809924-9-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261013035201.2809924-1-senozhatsky@chromium.org>
References: <20261013035201.2809924-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0666340002
X-Rspam-User: 
X-Stat-Signature: gekyq58quccmzgdurqwsckz5y3tmx5g8
X-HE-Tag: 1791863550-684367
X-HE-Meta: U2FsdGVkX18+j+5M0yXqSMKg02fsPqRpPVpCmhcQLgxWDZQzAGglYAtQMDS5GZv15AyakUhA/HgTE6FppAx8+ncgR50IkQmON5a4JLXIvckssJcdL6bKD6UAZttthEazxHDqI6x5FJvfXb/HcgtEfBo1q8lE6gmFrNSzBRovVnM1xYEhJL8zRzqG7mMxgmqZsuELuVfIPsg4/wFOae0SyEUkrr8sJW/4+nPloqPW6qd6JOQkFiWLwY7sTV/xoIfwyWTteGwq3ozaQgxFZw9I+Wio7nvqveXsRCAcKHYgVQmCi+/HWt7D5d4wr6XEznGcYUkZPSW1m6Mp6AXV+u2Q5Yl12yQh9IG2IdKVLGLTOctt0Koxh8xHaSBNtS5KyPPFtdMllKAJsCMgdWC1OJ2wcfpzp6QmA/vm1VsoxLIAeAO9Vzk975KUbUulQ1UXFFExozFFzLzDaCejzSTiVgtnhMPAUKnwQUqdG99hjFqJ1LWSvBg0hIUPf9n8CeQjU1BxFEhNoNa2TaITb4aG8KsiZE8HCCwKdOvfNHWKnOzmiNP5RWS/lwbcPnzm8jbsHrnnV4ygXGZQ3s3h8TtATXSPjpta6LYB18mbzY/EY3QB5RPRo1evGz8DeF0LTnCsrhYiOsM4s8tuQ63JprWNJ8OmIu1+VZkttlpce/mF7RimTUpRyCPAUlfAEQ5xGay0YqIhgU7yTp2sfdKt4uc1/2X80o3BNjpND+Nu3M9Xkbnl8cusNxpYKiKfHpw7X4I/78141hRKgovMoQ3GJYrUu2sYOzm0Jh75gq7aqubGa13DMlgjC8leKiHTSLn3jJ2IYr8fOwUj30CYd1FlPxM4Gd5Fd3HeyeYU9BqFcowlyc1ajt85kk3xWt2ceFGxG3Y6wco0MWnwSze0lJem6nL0424iBcU1fnviLJ6eDpXnK78KG6SPhV17z57Yyv1W1XvRywhR9hR0ZRziTIjP6MwTgWN
 HiNx/3Cs
 Ct649876j9E6RKUuNwgYOP48N4+CjFnAsjgSMwDzDHR3o+ZJuj7Edm1c+GIhyi/8jVdCW9ui8auYQaaMiIcmmx28cHmYQrwZ6ujn3vmoPD1mWveMWdvwaJ2zt5E1aL4KnrV4Ga19jL/jO3u/y6aVZ+GvVWwX7VZl1rPKZnHWkmE1RFtlumHATq1/XuHryGXvIQ6UsemnIe4No1yy98LNedYXhpt6qsJ8fmEDl5atuEfObRZkVR0nIDmPyoqoHmBsWzWBe7xoa70+GVxmWF57qUIwzHsLVuJDgosSw7CMhZMRaw10JPym3I6od0KkZJug9byFBNPr2aBAxAIrbG+t0IjlWfAdehGyq5K+gkFjrrM+ESmCk4WmPOH/HOg==
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


