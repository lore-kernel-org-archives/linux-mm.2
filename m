Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02839C982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 09:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A676B00A5; Sun, 20 Sep 2026 05:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB526B00A6; Sun, 20 Sep 2026 05:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 019316B00A7; Sun, 20 Sep 2026 05:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2F5E6B00A5
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 05:29:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD3CA1A0408
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:29:36 +0000 (UTC)
X-FDA: 85233617952.16.8C45A91
Received: from mail-pj2-f7.google.com (mail-pj2-f7.google.com [74.125.227.135])
	by imf31.hostedemail.com (Postfix) with ESMTP id 13BDA20002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:29:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lPe5aZJg;
	spf=pass (imf31.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789896575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sug+4f+tGLe8RFcRq2oeLrmDKsMlqAOb6R6Xgy7yp4w=;
	b=8kHQD+5mIuSGGOjhKPRgCxHrviReoQDXdqxp4Mz0T9kKBffjiqLncS6SI90zzvAwJaA53O
	gATtxluEPScDhng9kkz/NM5rOPdS56iMclcyJy44VAHvzMwBs9JRWbtc0Pk35HjJ6++5HW
	7Z6JrNR1XOIJYVlTvahZEzOxwOB5Mn4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789896575;
	b=gkdv65Eva2R9zsX7fqhtZtd57mf/BZ4PD8QFLyx/NsqnTFwzT1tzEm/N34jSgU6gS1lp+c
	GGUBmZWuCq0eHCpphtnHLGjASjfL3zkQjyKy+7U66LSn6P8fvP8gN3vejOSI9vd79Crd/t
	FUTzjm2ulCL1AGjGMc8l4QCqeiHfi4I=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lPe5aZJg;
	spf=pass (imf31.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f7.google.com with SMTP id 98e67ed59e1d1-39e37c430bbso985008a91.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789896574; x=1790501374; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sug+4f+tGLe8RFcRq2oeLrmDKsMlqAOb6R6Xgy7yp4w=;
        b=lPe5aZJgkau8vVQpjYDdaDEFSk37EY5+rFXJu1yLWn77/h1+wsWG6I7EojUj3OD3yg
         e0C0Ln76eFrqpKb1dJ9WrjLH5J+4MLJWm4JQWGco4EZftaf+PRYu1qHP9ZwFAlUt8QHL
         vZzZOL5Cvq1rpRYu+9/f6k91DK2gskv7fh6hq782Fz2CjrLtEAWE27K5Eq/Vfqw0hSf+
         xCa0VUW6gv3A8fulCz0eKh65prWSQkj7ZSbf9Hk668+fD2IFxv1s0uantYyanu535DW2
         ljWRh6tvA/2c2x9iX0L0kVgPxgTNH9ovTfo1Ak+dwQ0DwruKmtyVtmFW2VNZSFGh/Ay3
         BWRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789896574; x=1790501374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Sug+4f+tGLe8RFcRq2oeLrmDKsMlqAOb6R6Xgy7yp4w=;
        b=ZpmB1G1gK62WQNvO26RGRhv4Nkqo2Owt1icYBvRXg6DrlCIZLH4zdQNlGvHz6H4No+
         MBA/dICE6Id+XKJquQDut8nEXhwGCOHC8l6NzHA86E1oBGttc3B5/9oPBJc4EjkIinT5
         tNI5IrlnnL387JdRTohfCHC/pW0iDNOMGqtNuZWxT0mpKCPPHBwr+K8rJCyeiiYltwk/
         qvIU5wo5Ok0qgWJatdrYGSBYE1YTBkhc9mAecAoisuCDDvgoo5CvRFEUeCbZmr3bTBYg
         O2QQ4c9tqWouHIVJ4eAHxagMNAJtsio7zM/c3fWi9QKnAuGb0HuC2Eugba2nYiGbvz0p
         9zLw==
X-Forwarded-Encrypted: i=1; AKwUvBwD1DfHaT4/spUcVoBw8hBeHg/1lfEhB7mLYkgRQcXCCGW/8Jv+KcbWODZs+QZ6XtEEId1goBhKQg==@kvack.org
X-Gm-Message-State: AFuF++k3X49tnx6e0yt2ckP+WYd2LvdvDaxWvJY4z/6gmv7mCVC2wmy6
	U1LOE8bPpXOgfZ6MUaBJDuOdPpuD6IUZapjhfYCLydQDbRkTc0qrSQ4p
X-Gm-Gg: AYBFou3fv2lEalDv2fsL1VTmdBz+jdUZUEJcJRc8Q/XG86kLhpQ9Z80DNsuzn31Gs1d
	rXCwxptZ2M3xzEeVVbONQS2zl+1D037k4VzZ+x5UnyG+PVWJhmOgQBMVjgJAyABq7bwRi4GhUJi
	/CYxsroTAxmhDHSClpVI/gEIi8yM6nGveI5Bq5GaJuqndkLXDLdLzquTqFeWjEMqSdfx1Kj8uvv
	8/bBFI4Hr39QLdZBeysJ8c/MlRlkey5ATnPO1WbdmUu2Ro4IfHqN6eP+lZkiHM3ghcMD+Qeanjk
	uslFgguUV049mq9uXOw70f80QRjFLsiKKFwDOE5rhJC2JAE41TarqlrGESPdW+gh29SUyhSYdJY
	xIxrZPFTvB8cWQXbZ9pzvSgKZ+6jRmio8Xf9Ig0D5JTth5ThtJT09CAGQcDQ2YZ+RNicNMztCw1
	XWQxDGy3qiO7VRDULTIF+yluXOvhTj+zjc1pfPwgY0IpZqz1oXHfWsJKHGISz46d/JKnfbaxK2N
	G9hy5sL604=
X-Received: by 2002:a17:90b:2d44:b0:39d:8794:5564 with SMTP id 98e67ed59e1d1-39e54ce36fdmr13649499a91.12.1789896573869;
        Sun, 20 Sep 2026 02:29:33 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c37c64csm8154917a91.10.2026.09.20.02.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 02:29:31 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	m.szyprowski@samsung.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Subject: [PATCH v3 5/5] of: reserved_mem: reject static mapped regions overlapping existing reservations
Date: Sun, 20 Sep 2026 17:28:52 +0800
Message-ID: <20260920092852.614973-6-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920092852.614973-1-chenwandun1@gmail.com>
References: <20260920092852.614973-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 13BDA20002
X-Stat-Signature: b3k4rsyc564nx3drh1k6gtwhgpr6wge9
X-Rspam-User: 
X-HE-Tag: 1789896574-390308
X-HE-Meta: U2FsdGVkX18GAgKYcMykPuVgk0i/oJoHkd+OGAUdZIaME6JNtP/ufwjPt9EeNYZakWK75hAJAKVTSdPX8YT8ryQ8tc+ZPd6BO+ZC76y1KxxpheGgX5EqkckAwSfYLYbbf7M65I88tN2Yt1ziYUSH9kZW0kliVHnqAOer82gzxtT0mtNEjS2x8m2wWqeXR/tU6MvaPs8YXATw7mnKcMGNkwwbznXJbKQ9pwW7L82RVxXp3aMqxEaYddaz33a0c7w6TV3Sh1iv5kpCkFilb9l1cTTyXtpmcmBSCoA7TXuSXGtwvHiKfHV8SsV0MuI5ErIerLMotwFNh4c3NGSOCB6IlugFsQkSI/o0vI8byUzhCLRnzTl72s+gz3+IuUIFBVLiJ0/bsB3qJ9Vc/OdmlWfYE8N+t+X/vzRM/nZMw8+y/6xtVqfL/sh51wtZUXl/479J4ihxqUOFsBPYfznTdvB8+Wbag1OKCFErgiX0qNu6NP8Y21n1dVIuW49nl1xgw1DGU5fpUTRBJkXxUs3lB+1iklWwSQn/5f62OcUoE9hf7z3A2NH7ZV5sSisbhGEjIMewq6me1+BYNEvmajRET607em5j/oIPo71IJKT2sk6wXLJOuAHPpUquHFbaSMKTDOQ54rCUomoziqgEzzFLpN/Z3a/3RC41in/aQreTUgWxnjth6Fw/n39tMtVnwUHQSY/pz40vP7N8QEDRpJAW43qyIpdMslfIGmlshi4YgoUKUtQahoHt2For3ZQipTp6jCFb/Aexn7TOUQz3/V14mn4rg1t9+IzklcilWqmVebsq5tsGt8xjRfw0YALCKlgE7/tcv3Khs1XbrMkmk4AA+UejE7DSvaz0tRousHp0XjgV0OlBySebK4yrcHrhLYs+XpT8VXh++7y6S97H2Tgp/uOJFlKEFYtHCBNQEYYNnlI2aVKiWOdsN9vPWqJShdvody5YjDWaTWKY+cvXr/whBYu
 JnztC7oQ
 4c1sDoO7pKK8gPSAO1uNMvHdEWYeQuE78s6yXTUHmG9THzg2/n4srwBWDle+tZ1PGMjtInfoQoaoZ3e47kS2Fx3bV1r3yvKyLXe7I+D+WZL7vANSarOcENgpaIl31LNKMZtjMMyhYVWgp8V2VigwQiIqqC0SBbmhD3xEGHwzRXQ63Zge4MBhldmXhxuHLgNNSfCZLbTXv7f3p9WO8q6XS6yuZzrqtOkibMk2qG1gbGRk3rkiXEYXoiTlI/UhyHaol0/QE7tEfht0ErJl0rG+2S/aelSr6yCJs2Gd3R4v+8FhGSlFCL0Wp33WTVzdPqQdnFonOrVYAqKfGAZUNeFenDvm+YCbEtzRK0FI/PGcbYZRMFO2+5+U5E11RBvQIZi3zdckiGp5vRjHOcpt9OGN20Ka5i95GaRYxv9rlx2suu8x/IQHQkEeAcJ0wPatUaBNkqoVBNu9J9uPZ+kILI59igpslOkf0XmIaTAkQ6euobV9MC8jzWCrRdGaYqRjqKWJY6RrAhX1l6DrotTO/zb4bmrrblvhoGf3c1RxiSQ0hzpLiqk9y6sC1ome2OXYU3lZ6nAHZuUr2byqaPWJUTJVPx2s6gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

memblock_reserve() permits overlapping reservations, so a statically
placed region whose 'reg' overlaps an existing one is accepted. When
initialization of a statically placed reserved-memory region
overlapping an existing reservation fails, memblock_phys_free()
returns the overlap to the buddy allocator, corrupting that memory.

Reject the overlap up front. Dynamically allocated regions are
unaffected, as they are allocated from free memory and so cannot
overlap an existing reservation.

Sashiko found this issue in [1].

Fixes: d0b8ed47e83a ("of: reserved_mem: fix reserve memory leak")
Suggested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://sashiko.dev/#/message/20260806100605.2C2C01F000E9%40smtp.kernel.org [1]
---
 drivers/of/of_reserved_mem.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 8d2057f2ac12..2d1e01c0f886 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -141,6 +141,10 @@ static int __init early_init_dt_reserve_memory(phys_addr_t base,
 		return ret;
 	}
 
+	if (memblock_is_region_reserved(base, size) ||
+	    memblock_overlaps_nomap_region(base, size))
+		return -EBUSY;
+
 	ret = memblock_reserve(base, size);
 	if (!ret)
 		memblock_mark_rsrv_rmem(base, size);
@@ -343,7 +347,7 @@ void __init fdt_scan_reserved_mem_late(void)
 			continue;
 
 		nomap = of_get_flat_dt_prop(child, "no-map", NULL) != NULL;
-		if (nomap && rmem_overlaps_check(base, size, static_reserved_start))
+		if (rmem_overlaps_check(base, size, static_reserved_start))
 			continue;
 		if (!memblock_is_region_rsrv_rmem(base, size, nomap))
 			continue;
-- 
2.43.0


