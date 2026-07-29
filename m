Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F117FC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 04:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D785B6B008C; Wed, 29 Jul 2026 00:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2A1F6B0092; Wed, 29 Jul 2026 00:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C156B0093; Wed, 29 Jul 2026 00:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 938EA6B008C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:57:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 24400A0462
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 04:57:59 +0000 (UTC)
X-FDA: 85040607078.21.BF5EC49
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 55F37A000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 04:57:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=K0AkDMAw;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785301077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QwE/Kwnr9BPCU8EkGjoplXuRnm52TdDRkTVQHOPaAmg=;
	b=aD4547yaOI2v6Dy9xkgbsqdMtCkvqKKyxP5QKU1ZQzcTHAwogYe7RSqU2KDRXxUEizzUfn
	88jUs+mXVvLjixbTJ+KFYkIBH3DrqRQbKVglmRu3KeohCPX97mMOaF2CDhykaw3VxNXgrB
	1gVzdXCISeGbYY+15ZPIUTRDaILbBTQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785301077;
	b=K/3ZN90y8LVtBcXEzmEKJBCZavoqaIJNeXxFEu8NAIIypJM15M5vdZEuc8Xm1WENpDTCqk
	QYCdxo5DbINvS7y6FhsR+2s++OzUZGlc1/hbF/nSiQzalNg8rK5U4u/YBHxVqAIZ5Koh3g
	klT6yrfp7Wbth+k4E7eqIO8PVzCNNPc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=K0AkDMAw;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c9e0b89e228so304538a12.1
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 21:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785301076; x=1785905876; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QwE/Kwnr9BPCU8EkGjoplXuRnm52TdDRkTVQHOPaAmg=;
        b=K0AkDMAwRpo3ymoN3j9tW/kB53qOEoxDQ8jXsCXZlkh4ef43mZ8HxJuId+1l9V/IeX
         zBjVqnh1vNqTsWqKylMdjVA30SJPo1Vt9nS+lX49WPe2rwSpWtX8NM/TR9UXsYDZ2Aga
         aaAf1OZ+1pBG2z4kSj5WLi+vqen5Whys6eoLE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785301076; x=1785905876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QwE/Kwnr9BPCU8EkGjoplXuRnm52TdDRkTVQHOPaAmg=;
        b=KRW121j9N6PYlmaPN4uCjwAx0p9+RgDEzttDoTqQZoP8+T3sg4wdVzIkxtjdFGee24
         gk7cYSZtWu1G2ov46QA5+36SkKTvdUtoi/DEaPmeOCdROZ5FBjoYFOZE6AZsioNtdsUF
         JDAsrnFlSZKuyOfV1+0RFMFYg5/+v0tFl81kCV7QX3EX48x+ahl7748jWUiBMTcG8m3a
         dmKV+I2grZNEzIKJ2WNIlJEQcMR5lS9zn5h814K0kERMeSO/fG/V1XbteAMOa40dXQ8s
         rPx/yoYZIhKk5l2WFRqYWUGTESvqELTavKocOHtJdKkWLXucIcOc7gFZaXaasP1K/vib
         uGrw==
X-Forwarded-Encrypted: i=1; AHgh+RoFOWGxOAJ4VSqjFNTF0u5njOwbs29TMiRse/ORV1Q/u6rKube2LfEYggHbXcrUjBkibl8F9Nmd9A==@kvack.org
X-Gm-Message-State: AOJu0YwLcLLagn/xorHrI9u5Nv8IqwYNmJjG269x0m4TS/ExbfGusfba
	TQn07v1A2Povy/QLZ0S1WHg+0JDyW6sUOxmTdkSQfASZevi/lBu2j5b8mGi+7zAStw==
X-Gm-Gg: AR+sD10i8O5kYlCH1I1VJVZnQd1/CUtT/JauB8OhAgva4DwCHNTl0bZDp7HUrxv/3Xd
	IOWWxIPUuV8RNs9JSwqFEKDu9mMxEBH4Nftvue8nfTjHfG0U3gWyk8cW0KcH/oi8M1mJMDMHtyv
	8P/0F+D2nNm/ZEp+XSoZb3APzrxmaLA5CsG6G1YiPjzWdmJWrvM2O6rnJyFf4HLQ+8P4mVO3DKT
	Qgf8PV4B9e/aJ8Nv2gD8kUYmoWrpmVEGCi0dZBQswmcIbBgMqCRAL14CRseVQ74WVgEE1gW9eXP
	heNHHoocY6kwJ5qSCobpB/JLmAdVG1YsfFQ5ywzjiB9Bmzo7aO6gGZsiiO1fzhqbqX+zHBUaGex
	7oLKiau1178JcC1g//AOq6hVqyEIQUnU2qbmUZFaaDwKvs+oi2JUYEmxWX/edvz62undq+oJbgg
	aT+xhwIgMop3XTLNtKig/vkaEVHTFcbmmFbIviq0OQ/wLmAG6JMr+b+0lrPNdAsAwZ687TmP0UY
	5Nq77TFKKZnbST29z5y+w1VZyhLFDgcFZ5/iEH30VrBW6IYIYlB
X-Received: by 2002:a05:6a21:3204:b0:3c6:5673:2bd1 with SMTP id adf61e73a8af0-3c8ba5da101mr5924466637.42.1785301076232;
        Tue, 28 Jul 2026 21:57:56 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:65c1:52a3:f6d3:37dc])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdba63c743sm335183a12.26.2026.07.28.21.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 21:57:54 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Haoqin Huang <haoqinhuang7@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] zram: set default primary compressor in zram_destroy_comps()
Date: Wed, 29 Jul 2026 13:57:35 +0900
Message-ID: <20260729045745.775973-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729045745.775973-1-senozhatsky@chromium.org>
References: <20260729045745.775973-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3cguusyd3pgdjwsjg66g65andm3dudse
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 55F37A000B
X-HE-Tag: 1785301077-620216
X-HE-Meta: U2FsdGVkX183ksLe9CGeO8RmECWjVL88/UXnP91iX5KMTAtLucPaGwpYfWxUPBzpdnQ8E2cUvc3EGXaDZzQyz59THqVbLe02SuS/TGGqIPGxApqNI6mi8ZYf3SsYxNdkYJu+myU4WLj9llspGxS0cC4RY7ciy7/7rhcp2EyR0dnCs1NnpeK0+PBQ8OgCF4Tc7YL0ETEu7HOyHCTmLOsifKzPO5IzuNNouVBfTwGFq0tUGAMxTCYAspwIgtgg7inVjd/LdGKiUDHlHM6A7D96cpFmKsDXRhDjtrJRQ4QHW2wZcvlKtH4MhfLj6fQJuThUFZRg6SyWR4/ciLuQNr9XpTi9tfS3k/jtCUyr/vsb/kTugh1NBKFLh1ikUfZA6n2b6bPWUWMRGyggshfDE9PgqZIUsD3CmXZKeInuLo6p3+lnZSJIxjlSLoetnvFMlnyx6xUPNacHbyrbxe4Y+yuIVKWc9RkBwR1csYRNLtH67mwIoAVayBQ/qd8twXTbaEqIrYURisWjTNxMbWGjrf0bCUDBL4OGVjn9Vv2wvPTj/Wwl5Xu5bUb7iMm5QvaROi/cT9OvSlXWyLSTCnnj9Ia6RWhdCbTqXSA726bVdE+n13x7f8yfkyq/Z5JE8AUPE8eCgultcNO1FFwxwWQ5Om1ljJ4KusdlBwdKTdJNqO+93+ZrsE6Y12DE5NmYEq0nDKNM4eRiCmahgir9ocFbYw9JbGlbzr2qw02BqHMxY3pS1aX/srBd71eA4AhHZjLBxCZYT/OfrfhWCG///3OQWVEQEayEK7bQqKJoioVo8DTSTpRHP5V+IRggd0tRyDMM+aZ4UaE2idc6Vy9rec4Dkx39pUa2v7XRqaaq5RucILRupNrv4yLak2nXTlzIyNl7vjeWDvaK+RwS1CrMfAua01mLpGOIpp1ZrfEMZnu/CLRkl2nJWISoFyTAKY/4Kgpln1OsQxpCSp3Xd2EkmIjEQOu
 jve4mYSo
 yBs/4UfKHeq70zhimDwi+j50l+CnWcXPq+If4V+bRtKWtHXGMmAQjjESujWU25cbRKbRQJ7tU8Q+mr1YRhO1yFyZj2VfRECqzGK3RLFId+/rTKnXt6+Pdq7+0X6tTZ/2M/tzAQg7rt4pPw4bXup45o7vXsypvne7VqH5XHmTfl2Ewu0Zgrpxwn6/RTLlsGX556XVwBVfj6V5r5Tpc0xluKGg2/VKXn5ECt+0agQG7y9aqIMvxk/4obNj8eB+dLJYk4BrXA7dRcQraPbWl0NlW1WWDKsAeblTLjCbZrsQwYGsrgZWmNE0orlD8YZjpQqYNlT/eP+1xkRMCd8HaU898EBO2/SoKKPbJMqKJjVw8u+Qw79KhoLExb3IOIJDaS37SAJUkfCeE+GDxm0jEe+GlMvymeNI8ZxWMCgeGLSGZqByJcaTsQeaKH1Y+xilKYENJxqwcnsMLSTrwvjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zram_destroy_comps() resets all compressors and leaves them
set to NULL, including the primary one, which is invalid
device state, as now comp_algorithm_show()->strcmp() can
be called on a NULL compressor.  Set default primary
compressor in zram_destroy_comps().

Fixes: 486fd58af7ac ("zram: don't free statically defined names")
Link: https://sashiko.dev/#/patchset/20260728092935.31139-1-haoqinhuang7@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ace65c586072..ebe2da955182 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2836,6 +2836,7 @@ static void zram_destroy_comps(struct zram *zram)
 		zram->comp_algs[prio] = NULL;
 
 	zram_comp_params_reset(zram);
+	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 }
 
 static void zram_reset_device(struct zram *zram)
@@ -2853,8 +2854,6 @@ static void zram_reset_device(struct zram *zram)
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	reset_bdev(zram);
-
-	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 }
 
 static ssize_t disksize_store(struct device *dev, struct device_attribute *attr,
-- 
2.55.0.508.g3f0d502094-goog


