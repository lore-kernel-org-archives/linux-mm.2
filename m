Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5826EC982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 09:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71CF76B009E; Sun, 20 Sep 2026 05:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CE306B009F; Sun, 20 Sep 2026 05:29:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BCF36B00A0; Sun, 20 Sep 2026 05:29:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 341EF6B009E
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 05:29:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E465F140394
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:29:12 +0000 (UTC)
X-FDA: 85233616944.13.B423B70
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1FBA940004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:29:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HweM5OWV;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789896551;
	b=0uz7DyAaHlWVUvvwwHBIafPiXWwk7Sec3LAvmKifjnnKs9+387nWb2R0vIVjqC2XsGLy9c
	OnjhL+KCnOr8j//o4jQygFFUhzaSmYObQQ1RsO+/QBlCPM5oAgSiwSjrqan30bUaN+bC/j
	7qE11RYFihxH8yS1XwqxKJE1xuPFpyg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HweM5OWV;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789896551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hr//weXOOHxuEsChSdCH6E1epplNkMkMoIIsD/MpGSM=;
	b=3MSg+pKv4usV9Hx8FNGeeDg8nSdn/yefY7GiESrXL1ngw2DnfT4ggJa8R2IhGzY+YsRrzd
	7n2TAdUoZFrh1oToL+VzcjCg/MF4bqAIhjow4frJdbVGkwaHWTe8VI/rp0p5r/z+ysJh3P
	m7De1n2CG+dQ6SqzhKGK2M+zR/RFHgc=
Received: by mail-pj2-f8.google.com with SMTP id 98e67ed59e1d1-398b9f722abso1158478a91.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789896550; x=1790501350; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hr//weXOOHxuEsChSdCH6E1epplNkMkMoIIsD/MpGSM=;
        b=HweM5OWVJdnLRZ8J7ahojtqJ85Wz8j+bq+e9PGErTeZBW9h4WS4Kr7RgcoLmRSsjvu
         /gXxwBrvUXiIO48mUTsdCzU4kqYX230/fGZCMAsFu/o/aRPSbuNQbU7Hy0pkXzMA2CUi
         QzlDPA3YeD13geTtcMpZOP5i8mB9qa2gQbKjq3J/wK65SxVbjW+1rBE/FsSK92G6PGJ6
         1jXMbjLoVoKWdNNU8APNFI7K0JkWRNztl/ASkPKVta6UKiWMcQbNSGxwJgqsfA0HgHAN
         I7dMezg2TOvnIlAzXcf5d5YIbuxdzTKYGbuglPhnkL1wa3AAMcs5oXv99QQO9KO2GQrO
         ZFFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789896550; x=1790501350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hr//weXOOHxuEsChSdCH6E1epplNkMkMoIIsD/MpGSM=;
        b=htrlQnrzp46w6IFrakWBZAJqsqE/cCrfPm5Pv71mfeqnBgOmYcLuV8v8CIEr/uh5bL
         yK+dA/jVYI/AVceCHoTct7zfd4Q7f2CKOeduV8DRJt1AewLsQ+tSKuK4k+WhsF7Qz+qE
         PNiD2yuXuKkxJ2jGCu/20FIgJEE1DffLXzLhQ63uTv0hPve2xsdbhIHcsu6do5kTbYwI
         kXFqK/oLl2k/WSNyPljEGmXh9Oyr2d0K+l7K9olX2bMcLM6zgjxa1TigFOOOaCBDEKVR
         YVOJ5dN6eA3E0NB8x7AlNCVJrhOozRKC6aIfkYuxv2U0UcEiJzWyoJSCL5QZ/NIiqxLx
         QrJw==
X-Forwarded-Encrypted: i=1; AKwUvBwpdH3js7Pc4JvOhf1yxY/kP2PCOfYOyCPBwuTubgMiDU6f4m5bnTe4dvS19IwmiEvogOFltnqQiQ==@kvack.org
X-Gm-Message-State: AFuF++nkLqnL6GNnQV3nL+MF58mD+I6o5EbsoY8+5J8Ms4rpd9DvDB+r
	aQKQYqNr1Ej/WHAE+UKHKPt70wgHu5Zbc/VJQEixx8p5ogqYx/pgGdjj
X-Gm-Gg: AYBFou3lbAmNifWa2T4AycZqAh09MIYdHpFlRPEtjpZ/egtVQo+PrL5mZZpqy1ig8+g
	BSvh75a+Y+ruvW+B+7Oa1MEt53Nwx8jMFcti4zq4Y7TSfdNDmjIZI2nIikWN0Z9rfgbfNxqLLpP
	oduQGNlFdQ/xgMxjyk6II1tpV8O7nKoClXgDdlQ8An5bB3fkWfJ8ChvOOlYc60g4e7Ku5aTeVV/
	Orxgx48Ct33AzN36EOl1241BTpTsstjfnWYRwuDPwqpSlzpw1vaGKsr2oP+MZqLE84Z2/Xm1mxA
	X92sCbLE9WezXjsl12vZbDHOSrxMPeXMt91BW1B2UX7DkhcZVq+Y1nmA/t6N8u9niIpIgOFVeuq
	JHn9xPlN/jlkhQg6PwwVCUfFXB17lA+fxYOFxZ6EP/onkJi+RjwzD/kGSgU4m+0WLgQ0POjz/pq
	IhXcDa2P3tsZdIak90cDTK7tXDXmbNrc05YeRAZLIvWBPggUpXYUz8JoOHBSkWO3vAcjA6ZZm9k
	On1smccrW4=
X-Received: by 2002:a17:90a:d648:b0:39e:6c6a:4b70 with SMTP id 98e67ed59e1d1-39e6c6a5518mr5665139a91.58.1789896549933;
        Sun, 20 Sep 2026 02:29:09 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c37c64csm8154917a91.10.2026.09.20.02.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 02:29:09 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	m.szyprowski@samsung.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Subject: [PATCH v3 1/5] of: reserved_mem: release dynamically allocated no-map region on init failure
Date: Sun, 20 Sep 2026 17:28:48 +0800
Message-ID: <20260920092852.614973-2-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920092852.614973-1-chenwandun1@gmail.com>
References: <20260920092852.614973-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1FBA940004
X-Stat-Signature: 644xyi9nekfcb9ddacpshc86ed73jt7r
X-Rspam-User: 
X-HE-Tag: 1789896550-234235
X-HE-Meta: U2FsdGVkX1/gpgfOBKzrmKmRwKhhMZ+3MnUlo8Mz550PhkIfFK+HKJmvtKxKhriUo0P95eAKYgFZw5vVFzOS+c3Q+BqmbZ/7F6wg/9Yh0xVBPO67amDL631sTgXl5hQDoDLCyZv4hyqOfvEmyRM+FalO7YpnPqDkOIUkqm8uNuz4NFGqDeWkYUaqns+pUDKPoTnVrQJ7iFofEeEetykA6Z+CIXpXRHJkEyhFKL7y0i/uq6AE7CpifVt9cKEVPVRnjkU1xlFHxAFmLiApQWDQySuXbf6mAAbd+bYp4jOSWYZNzRvRTD54E07YwHt3hPqILLtNdlPcefaJ7Fg0S22WPFMiTcQdhgpSfx1SjFYRr5RHWAQlDSOpza8gA3NGrstioEN4lE4bKkH07S0vsR5izNfPik12LcdGZQX3weU5hHCFHLB9PY5NjXyYzD5GlWU0P7Qw/KdJvGupgHsYRHrU0xxVPB/CyAUDc4nE/5DSrDTKn7Fev2z4wdnxbt6UfV2qn930QG7ScxlhOP9N20YVxPc8E2K9EXmPHvEg9boxeGcH+aQOR+Maad2Gwfxvy57xw4S5suFjqG8ja5LMM9zD29OrGRtUnd5XcPLU6D9A7h7iIjuS86FLaHRbGqrpSGXkXKbFTE0oIz+ebmtYiKzY908rqlzfi1WDnaGSc/3qZfj5TBZe5i8OveH9f4nnW9DaTEf+hIFVzrjQ4XqriC2KoiB083VlUqghyBbAJWzEjgL/SkgLViQ3nG2YLmYX+ZbIU2kzuBfvxWqkUAXayRZEYUJb4SMkZUVtE7/odMq3Hrjsw1trNlo2Y62DG0HNbIb5Mg5JelbqMHmK0zg1BV38cmlFsyp2+Pq32n6HgRFfPgOSCNlmkc8UG4wnzjpo4fmr2X5wN9yyMDMFs65FHaVyyS7elBqMRPQET3qNk7PlCLhgn+uisHldpUJuR4P+FfbtVifLMa+DmxUhGEI+rr/
 WBqahG2J
 AyAJeclMvOtwuVn1ywoB5Lz4WCUeS0PnOP1Yny5XmVdoJKsP81IckXuTdNfLRCWdD+leHYC0a6Ie4rRzcSoyuERAV5zndzYIA9pxZrhHv1NwEL3RGoehzZGyphlflA15xyA99F9VUGsiV/y+84gDss+Q4Z7RFlnL+9O2XOw4+OYEzRIjLx+9h3L07qNq0XDYIYUWjw536WTVK1P6wJrkEeL8AF9QB1R7qzjrhVxyfPvyuqXD1n7LEN32PbuOymI+8iSGji7XoB3QIcAKzc3YH3MBx+ugwEHymllpAGMSGcNV+JOMgHg3SQpi41KzT7WhZUHNrKTAM6sN1+H9881SBWP50KPnFx0KN9tfevx3bmiHJtXgNZpeMnEfjGi/jn4CA1RWhTsgxaJQ3qt6VGsf/M2Sr9Cs8trz+0VlRUXZzbGDNY0klmCzvDpMUuavY4xFYwyeXtbFIUtQQtyHFNJW8lsv5dqNC3g4yuogrLVZHGmo9VTgAjc6NKcv40NhTTT3ds64bXVUHLFr3VLpgrkxO0iVwtC9Nf5OIlvlj2fEcp7Gf5aizTYIY1NcUhmi5WNFdxRzBFtD6hPUt2HbrB4Pg1TlmaxGSDPxJ7ehh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Dynamically reserved-memory regions are added to memblock.reserved by
memblock_phys_alloc_range() during __reserved_mem_alloc_size(). When a
reserved-memory region's driver initialization fails,
fdt_init_reserved_mem_node() cleans up the reservation. For no-map
regions it only calls memblock_clear_nomap(), leaving the range in
memblock.reserved and unavailable for normal memory use.

Fix it by freeing the region on init failure when it was dynamically
allocated.

Sashiko found this issue in [1].

Fixes: 7b25995f5319 ("of: of_reserved_mem: mark nomap memory instead of removing")
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://sashiko.dev/#/message/20260806100605.2C2C01F000E9%40smtp.kernel.org [1]
---
 drivers/of/of_reserved_mem.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 8c9d6395d6a3..f55ed3b5aaa4 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -112,7 +112,8 @@ static int __init alloc_reserved_mem_array(void)
 }
 
 static void fdt_init_reserved_mem_node(unsigned long node, const char *uname,
-				       phys_addr_t base, phys_addr_t size);
+				       phys_addr_t base, phys_addr_t size,
+				       bool dynamic);
 static int fdt_validate_reserved_mem_node(unsigned long node,
 					  phys_addr_t *align);
 static int fdt_fixup_reserved_mem_node(unsigned long node,
@@ -308,7 +309,7 @@ void __init fdt_scan_reserved_mem_late(void)
 
 		if (size) {
 			uname = fdt_get_name(fdt, child, NULL);
-			fdt_init_reserved_mem_node(child, uname, base, size);
+			fdt_init_reserved_mem_node(child, uname, base, size, false);
 		}
 	}
 
@@ -518,7 +519,7 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
 	}
 
 	fdt_fixup_reserved_mem_node(node, base, size);
-	fdt_init_reserved_mem_node(node, uname, base, size);
+	fdt_init_reserved_mem_node(node, uname, base, size, true);
 
 	return 0;
 }
@@ -627,13 +628,15 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
  * @uname: name of the reserved memory node
  * @base: base address of the reserved memory region
  * @size: size of the reserved memory region
+ * @dynamic: whether the region was dynamically allocated
  *
  * This function calls the region-specific initialization function for a
  * reserved memory region and saves all region-specific data to the
  * reserved_mem array to allow of_reserved_mem_lookup() to find it.
  */
 static void __init fdt_init_reserved_mem_node(unsigned long node, const char *uname,
-					      phys_addr_t base, phys_addr_t size)
+					      phys_addr_t base, phys_addr_t size,
+					      bool dynamic)
 {
 	int err = 0;
 	bool nomap;
@@ -659,7 +662,7 @@ static void __init fdt_init_reserved_mem_node(unsigned long node, const char *un
 
 		if (nomap)
 			memblock_clear_nomap(rmem->base, rmem->size);
-		else
+		if (dynamic || !nomap)
 			memblock_phys_free(rmem->base, rmem->size);
 		return;
 	} else {
-- 
2.43.0


