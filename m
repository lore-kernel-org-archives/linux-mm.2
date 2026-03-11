Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13DD2FD065C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D60806B008C; Wed, 11 Mar 2026 04:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D32A36B0092; Wed, 11 Mar 2026 04:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8976B0093; Wed, 11 Mar 2026 04:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A84D6B008C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:43:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B0655A1C7
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:43:38 +0000 (UTC)
X-FDA: 84533143716.03.00B2472
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 64AE5A000A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:43:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=VCUAyixy;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773218616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBtB7XXOythHDvRMRushsmy5L46KSzcoEi5jZRX7GEc=;
	b=O/Bi2XKDA+qDPevcRLyH17nKYUlaUTbrLiWN/hos973gawdIWHn6BuphdorYqrUAf2KM6t
	y2fbvqe5y6k+16WFIRDJjGGSYvGZ6rRBZ/PiguxhzZ2qCCJfI3onDW5Z0VVDC+loN+VCrt
	Syi3MUp6EgWpikhxsAkyfrhpDkt9XPo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773218616; a=rsa-sha256;
	cv=none;
	b=wjWr+3dLXvzZYJDV7T90DhtOK5VZjDE8z8Zxv60FnSNqikuzLU56vVidL5y28jj2dgKmQ8
	lZ3vtxOiV3Dty+mOlo2xG5RzGlrcZmi3CNAfimDi/zzhDRxd/rvTxCTG7B+zudOv8OvMrk
	FhnpiHR0usj6kQit8/Es1HAyboAu7oo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=VCUAyixy;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ad9a9be502so90071455ad.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773218615; x=1773823415; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pBtB7XXOythHDvRMRushsmy5L46KSzcoEi5jZRX7GEc=;
        b=VCUAyixy1VBzKzXYQaDpcxeQIxY52VuzdEpDv2zRoDm2JIriO0UuUnMEJqToTb/2k1
         zLqNmRhxu1oPqVpSyr9IqzZFQ8cl8oAg2Zw3lFicgJl1h4CtscpHv0xYOlCfs3vA65c3
         Rfto6aZ4ZjTd7fi8aRJAkB6Cm5TV1/8GNCOZ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773218615; x=1773823415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pBtB7XXOythHDvRMRushsmy5L46KSzcoEi5jZRX7GEc=;
        b=AJKHSwHYI5R/+sIGEyzHSMuw0d9gsu7r4iITFQYCyhsUq7wt7Z80kywDWMPi6Hndum
         jAdl7n99FjxPPG78O29QN8fqZ0QR9thus15sbTcLCCc+C8vTys5FVoMFj2I/ZbBHiC41
         7FCJjJAoJhHZ5zp/Ey/Ap0S8d7ex86j4n1bLxzh6MD7Ay1RhdmOMAlZsyw3tptedVKrb
         PV1ZirDwAM3f0lmqGDgki/HxTxlLpyWIeKUahIL2AHflXvIbzPZtRmd3pP/gbEzvS90l
         lYMwEjnMN6oA3ArI7Xtnm89yc2N0Xa1PY4cafBuAgbuaB3zGvxXktEhrHMm1r8lkHKqi
         ZXig==
X-Forwarded-Encrypted: i=1; AJvYcCUe/8T/8sr+9bjYfKI4nrqrfeuMwnKR0RAmhEe/lrFceLjcTJmsxko0KyXwrdXrbGiTcC2BCMqppg==@kvack.org
X-Gm-Message-State: AOJu0YzBplptADkCocvIP45azL/i+UHdx1e59RMpxsMKcwvb4dklF5mZ
	1aE9moeGT4JwA4flXXcL7gN3yJfJoJg9bLMzgTPMMysm+6h+MKfSNMEvMsCKkfNsGw==
X-Gm-Gg: ATEYQzxNp+1KTXdymAneFgOpUAJ5nvGgl/8k0InlbArA3hesWYU0NaKnv+7aUdoOSp6
	keYFOKzype/T93Pw6Py1xfQKxKUTRWqh17TPUlRLaefty8VGCtBxd4FMldyYGpknDzWYnqFqV8X
	tUgCwiO6PUKoIwZFDstm6QYHzHZCz7q2mbnV38oGGOu2zo60i9qMW+P+jbeL2zB2ftBpf5+YSzk
	BAVujBdxpm6Dk4HPQq/YcP3+hdaoqpHv8VnEW1WP6P6it1AsTrbJDw6jL/DQt8VlnhyUCuyXauZ
	pEMWLkiWNQ3nSa/I70TlqV0hQnemrwua9lYHAeSYtsjIFEVpYQdS7YzHE4Rj3fE5m9WZqxcP6bX
	/RXa2wnWKnJ8jSivZSnDMSwTcT5PM2r8+MSL+ORzAsyRhohfrbsj1h+aijXalFNKGcBrMDyzBJl
	c9VRBeE5MU03MAaSNW6Mu8sm2+9hKz2My5WIBxgsM1kXyWElfnPQDw27HgGfIwi57V2QSK2AE0I
	ZRjCpuzXMZd+w==
X-Received: by 2002:a17:903:18d:b0:2ae:3dd5:c69c with SMTP id d9443c01a7336-2aeae858e3fmr20712175ad.33.1773218615277;
        Wed, 11 Mar 2026 01:43:35 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:93a4:8281:fe98:426a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae261077sm16062035ad.40.2026.03.11.01.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 01:43:34 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 3/6] zram: drop ->num_active_comps
Date: Wed, 11 Mar 2026 17:42:46 +0900
Message-ID: <20260311084312.1766036-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260311084312.1766036-1-senozhatsky@chromium.org>
References: <20260311084312.1766036-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 64AE5A000A
X-Stat-Signature: 9kz9bm1zj36yzfc1oy83zcneehshdd9g
X-HE-Tag: 1773218616-886078
X-HE-Meta: U2FsdGVkX1/nmWfJVeR3yQMrv9W5UJuAI+6w0xkNrN8tCj1UjzlYb80jKSmHGkkfSk/pSdhwODxT0YZ9P0B0zQoHQrtgv30YJyFfssGd+1tJP0H2JGCrP+XeO0e3URHNrsKi1+z4kAmFijCmHT7zyTCJzY950Mi83n9DF1SKB2PE0m/qLy6D3nUX0Oegi0Kvw0TyQHKYh0NESScpAa857RN2F61XQFzqN15P6RWa7+PM2TkSN0i4xjyrJVf2mf4U4Lu00vtWcHj1pfpFXl4dA2IpoO5cpFBH5wdbnd51uF2RBrTQCiJg+iB14KN7ALJvkZTEauz2MQ13foZHkZd1x1DjauLe3gmk8Tbm8n8lTpZqQByiqLrBe+7vBaUIwktHdxPxvgh9LL3YgweCcQEzTpDopBaDz29nkULpsTLbXXmvIxOqvsJGbsxwuRzoa1nQ4DynryYD/YQc++nYMufydcTXnWmnjmVTLM2EUGsW9VFM69AD593IlEE6hciiiy9e9bxvTjCQlVYcrTWKWNfoj7PS2KkSseiMuKnpli+NZQHBgpnOOFdrTnIiF0NYSePncFWYMD2aQyWQYZzsbnWzqGFlUQHSyJreGeTtY99XNks7D9CC7gXnD4zuIjrik72WQXUJTFSN3bxENM+zIyAWgApOEPIuUr6SQkIbWbM16tyJHW4HJU1q+GUxvaSZlCJCnu7zTKHpNVSS8riUr85Td6VTHKyr16b25k1YVuQF0HG0Bp+C+Sf2E9DamDbxgBaoAq6IXk1/d98NrmrxzBWXfLgNUX9QI4CnTFdwkWvR/JElDsPjsM6TRzO+zycDnIOpT0tgFFbkCPJm7PkxF4NFNP12gxqlVCWPLhZpDKary+7OXsBGgRLZ2YvilI8D7n2v0QKNT6PNPNE5MvI0ZhNMzQVva+PAe0/7MEhOTbSPO/EfiWawKGdCNcil5qzVD60dnrUtJkFRov6lLmSOYsr
 7l+ZezJc
 KKkSIp5r92hFHVeLv7/g1TKTP6cw2qEdzR2HjG8w7CQrF3oAsWp9LNBcWu02nGWcduLnZoV+O+UgrVXvhglQoGImhFyiuH4FIrFnUboo7HTYkmJ1XHckM7QL9/fzlv6kNcvGwzXNck4tW9uxl5Fk6/uPT22tiOZDOyg7jg+n9KHZ5Svnzq1O3a1QhaTxWL41HjgWte59CGofiB/ST3Ywj+WSCT4KvgK5BVQoRn2IQS7XCQE6MUWwIajDThmlsavR1thu3XXoKQPYE0vYTJDxRvHm8FW8A95LUyE+sb8wH1WbF+RIdyhlbf19lodjpAIEmLYyIrxPAiQxrCfhKS2QnzdfBiGR+Xlfjgq3mO4kqsfN1Xq/ZodbpRrQZnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's not entirely correct to use ->num_active_comps for
max-prio limit, as ->num_active_comps just tells the
number of configured algorithms, not the max configured
priority.  For instance, in the following theoretical
example:

    [lz4] [nil] [nil] [deflate]

->num_active_comps is 2, while the actual max-prio is 3.

Drop ->num_active_comps and use ZRAM_MAX_COMPS instead.

Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 29 ++++++++++++++++-------------
 drivers/block/zram/zram_drv.h |  1 -
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index add3291ff27f..0c3e83787d9d 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2335,6 +2335,18 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
 #define RECOMPRESS_IDLE		(1 << 0)
 #define RECOMPRESS_HUGE		(1 << 1)
 
+static bool highest_priority_algorithm(struct zram *zram, u32 prio)
+{
+	u32 p;
+
+	for (p = prio + 1; p < ZRAM_MAX_COMPS; p++) {
+		if (zram->comp_algs[p])
+			return false;
+	}
+
+	return true;
+}
+
 static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio_max,
 				     struct zram_pp_ctl *ctl)
 {
@@ -2482,12 +2494,11 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 		 * Secondary algorithms failed to re-compress the page
 		 * in a way that would save memory.
 		 *
-		 * Mark the object incompressible if the max-priority
-		 * algorithm couldn't re-compress it.
+		 * Mark the object incompressible if the max-priority (the
+		 * last configured one) algorithm couldn't re-compress it.
 		 */
-		if (prio < zram->num_active_comps)
-			return 0;
-		set_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE);
+		if (highest_priority_algorithm(zram, prio))
+			set_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE);
 		return 0;
 	}
 
@@ -2619,12 +2630,6 @@ static ssize_t recompress_store(struct device *dev,
 		}
 	}
 
-	prio_max = min(prio_max, (u32)zram->num_active_comps);
-	if (prio >= prio_max) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	if (prio < ZRAM_SECONDARY_COMP || prio >= ZRAM_MAX_COMPS) {
 		ret = -EINVAL;
 		goto out;
@@ -2837,7 +2842,6 @@ static void zram_destroy_comps(struct zram *zram)
 		if (!comp)
 			continue;
 		zcomp_destroy(comp);
-		zram->num_active_comps--;
 	}
 
 	for (prio = ZRAM_PRIMARY_COMP; prio < ZRAM_MAX_COMPS; prio++)
@@ -2902,7 +2906,6 @@ static ssize_t disksize_store(struct device *dev, struct device_attribute *attr,
 		}
 
 		zram->comps[prio] = comp;
-		zram->num_active_comps++;
 	}
 	zram->disksize = disksize;
 	set_capacity_and_notify(zram->disk, zram->disksize >> SECTOR_SHIFT);
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index f0de8f8218f5..08d1774c15db 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -125,7 +125,6 @@ struct zram {
 	 */
 	u64 disksize;	/* bytes */
 	const char *comp_algs[ZRAM_MAX_COMPS];
-	s8 num_active_comps;
 	/*
 	 * zram is claimed so open request will be failed
 	 */
-- 
2.53.0.473.g4a7958ca14-goog


