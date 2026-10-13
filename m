Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5F9ACA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C559E6B0095; Mon, 12 Oct 2026 23:52:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C292C6B0096; Mon, 12 Oct 2026 23:52:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B18A36B0098; Mon, 12 Oct 2026 23:52:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 927AC6B0095
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:52:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F8D8120AEC
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:18 +0000 (UTC)
X-FDA: 85316230356.12.9B8594B
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id C8C0C20006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=d74kHYXv;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791863536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JRVEvrxfwQIXEs8jD1qgXlnqM+VVYXSC/piCelGt8c=;
	b=ViT/q+D+NLUKzeAVai46nOtASsJTgX6ygwr9sknvYGjWprSPgMRofaV5zVYROZWtwm2kAf
	LmnWtGzgoEGuvFPFrnoy9JIRggab/Jxg0M2ccDXz4myQGyb0L05J0MT88Miz9OdeDGLjqq
	jUk07nIhlWLdlrvV8sxU+8kpiIrWlUc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=d74kHYXv;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791863536;
	b=M2/g8FHA2diUsx537s1ICYqc1bY32MhvxgZEGbfPg8WVlABJ80VWvfGVjeIB3R17c97N4T
	T7zCXTIdHvcfaej4OYs/A4vCWGEsz5/scchHT3M+THn4QAjUuQXSQwCZy9wITo0t+r3MKp
	ThVyy6By1zgCnTxuCmRqXNRGfB9sNfo=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-891d19d00ceso709450b3a.2
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791863536; x=1792468336; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9JRVEvrxfwQIXEs8jD1qgXlnqM+VVYXSC/piCelGt8c=;
        b=d74kHYXvM+hr4YgZXyM1CiUv0RCseBpX7iyJCBQmSwWKNH8MnT6LtuUqD7lD1YVqXp
         AYBKIGGWjcKYgbhQNZABbqbMIBQvwtSzukcH4aS+w74vskiqZKWgBUv7G5HXCgB9O4Md
         xdyTygcNpTdPA2RW0N4CGRiIZeIiv2ck5qiiE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791863536; x=1792468336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9JRVEvrxfwQIXEs8jD1qgXlnqM+VVYXSC/piCelGt8c=;
        b=TIU34uS5D9cWKslbzHVkqOGmMXnLKE6wLEOsBa+ibhUefgrFeoTFbYDMWGwOU+qcg3
         M+wjzDkpIeKsQJhQxytBHzVWduAbtPqHsIjrAu81gSMns5+EaZTWNFwJyX2srv6Z2BK+
         TccCQDZJ47PWGL7kUBDEnyUAmpMQKHc5zOZD0JLuBtbxGErizCjMdk+42ZNVdHuNlCp9
         eZixsYsBu8DQt9q6APl02JNskNgQvGfmzMlDm4f+PQAT+h55meOAU7RPIUrWOBRAG4W4
         Lyso12V8TouWXRY9mD9EP+GL1A0kgpP5ry9JrMbj/5RjXEWAyiF2l2ut7+qa+jIBzaVE
         ehYg==
X-Forwarded-Encrypted: i=1; AKwUvBxfwPJyEgI0HI05iHxwthhx+fDzI/0bzP8JWFbb41BuYwkNpv7+XkyAwyO2hEv4aCocOpcjVNWDVQ==@kvack.org
X-Gm-Message-State: AFq9FYIEgr25IpgQs7JHWMBypYw2HG8LiXz1iW+iFaj0Bp41YYJlT6W4
	Pgs8TbkW4+vgW4vwOEieSAJJNDa+npzcYQYaccGruXtbGniLAHddeqwCbnpdGaZxjiqtGavT7we
	hfu8=
X-Gm-Gg: AYBFou1RzfT4T/F4D0/ZRwtdFjsBVjebLxjgwTOCbVlHeEZPl4MsM7ft/++nrsSlvxK
	xi/nUjq/5vK1cmq2buoQS9j2q+cYncrIka5CN8LabJyKrLAbulps2WPs7EdkOICRp2WFumF+Utl
	YSemHj3tE6Bz8eymAgD8wJvUKbJYwx+sTnzYvYUF/8UZoVnmTS4R7oYgOVtkF5HBnetZOQjNfYx
	NaalCDac1eBdscY1og8qCcHDs6XJIpQJk/V1WRioASBhcMdMFonMw0+aZ2P6ipC9WRcr0CQ1VRj
	RW0WSd/ROLG7d0GZqSZ+zLhGzcHuqSK6GmvTWld5S/rO1sEM2ibU13uplnwW63p1x1QY6IYc1gD
	vE6bl6NKlQGzVm+iW6PVWiRVKbID68qHJG6bFXsRC3hfSR8w34340TR/mO7qmVRtks5B0S0YPJF
	1ehWsXaAjl5oTKvKrSHGiUmJRG6Vrg+jz0ZQuG+4kZVaKMcHnpJ4tMw8ggNmagxFCXul+dAtZ16
	K9YNPWzBHyyyFCL1jFWR5ZPriztaQzmR6vL1NeIaaJJ6Uk8SnlWm9Py93nP9LI=
X-Received: by 2002:a05:6a00:1254:b0:886:5438:e47b with SMTP id d2e1a72fcca58-897c73f4412mr8459670b3a.48.1791863534025;
        Mon, 12 Oct 2026 20:52:14 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:476:d384:7c2e:1579])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c41bbb27sm4326818b3a.40.2026.10.12.20.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 20:52:13 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v3 02/11] zram: remove debugfs entry on init failure
Date: Tue, 13 Oct 2026 12:50:49 +0900
Message-ID: <20261013035201.2809924-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261013035201.2809924-1-senozhatsky@chromium.org>
References: <20261013035201.2809924-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C8C0C20006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: sar5m4apqzpodjoa4prcxcq7tk19ednu
X-HE-Tag: 1791863536-219527
X-HE-Meta: U2FsdGVkX18xPfUnVbChtNnYbQrDoRNSGwZWgyRm5mAOwSPmjpntIrLZoc9RIrpdo647LToZyJs+blYqfSF22o19Uj0VmKfIFc1Y00CQUZCAGF4NzSkVd7rTGmgQy/Iv1GJ55HtGuZ2k2RxVn/HGfTkN+9ZEgQqVZf7ANAxoVajaz77XPVbZMnj533jEITsqZDjpl9AuWqcO+dQ3Zmt8kvtxZDiyuZ4yPKYx8bryqbwyK7g4CDbR6SzFPBglTwkA31z5h286JgZlzWImyd1dMsfphY0+kl3aOEcM2i1rEHbn32d4ulvTw281hy4K50sqTJOCbEtYOlRrlEjDzcjSaQCJoACvJuJHK070Nd7MtY5/toDkpyfvMhjLv4xTTw0AkLuaSq0dkW2KQFr8yoqAAhHHMI94uwq35bd4xHjXQziIFKqHJxIupmunb8had0ox64aRNDqLfBnyz/oIVoSIvn+rQGruliexIPmJ3AhOS32izxvCcIYDZLU+WFpTLgxYqEP/rIMmMRlng6TNA/rdCfNPp0MasYwNRKAItorgRrcGluLmqfKdHQudRR3IhZMNKcy92S46Y2GPX1Gzg20FDVR3XeM25TtSuH+ZotDvoo04bZzhxv7WSq37PQ+YbthBfWDh/n8rbP3sLfwlblhSYJwke5QNiHuVYVGREy0kAvnOWPnl7N8M6pIBNJPqzNmwLGnXPUX/pjotMOZKbWb4fuhc+nXk8mRDyi5wkfsSAkihBtrRbkKFak4e+c1uJljZMBc+K5KEOsfRq4ecO0T1vZe/AePpqOcL9sODwovV2kooadv22clECdMqB23VQn3YOuNSv3fW/CjoBiCIkGIuH5pxUBdBgBOARIrshjGhiHG+lRLMm0WLYJENRrcIbYK//c+RjAZTruA8+3eN9QiV9mPu/4D/CMlMOaUSlSil6ZrLbYhKhbcKc7Lpb9EZnhwS+gGtKAYZq/5tJMsLEe7
 y4y6shz7
 hJi3wlXo1RgjMBNVQiSjt5jf/XuFt4r9Ez0Udix/mS1M5tQsPPTxjnA6GI17x0w0KMmRRMFaSL4xQUkv4r8nhpdiJz8p0GStoH+z4oSVBb42b7tomEHNN1VNF1nuEDAZ6d0V5MiQD5Lqhq7MDB7RoIIunrVyGDzqg4llSOxQ/3yaWXE8vuDIyTxCaeO0KC54l/M97+8MRT4ZXMUoei1qjkNiSipypfVWN0GI8yoYio5g6vZPSTuXWRNzINRCmBroPO/ogYJjUKGtGdFlk/iQ2hZFQTiEtXUp8QGbPzy7QF8FbUsU/jp+ht8mAAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do not leak the debugfs entry when zram_init() fails to register
the block device.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ab064c84b092..593fa4ae47c4 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -3297,6 +3297,7 @@ static int __init zram_init(void)
 	if (zram_major <= 0) {
 		pr_err("Unable to get major number\n");
 		class_unregister(&zram_control_class);
+		zram_debugfs_destroy();
 		cpuhp_remove_multi_state(CPUHP_ZCOMP_PREPARE);
 		return -EBUSY;
 	}
-- 
2.56.0.385.gd3acb90ef8-goog


