Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66313CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 18:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1CE8E0026; Wed, 20 Aug 2025 14:15:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952E18E000B; Wed, 20 Aug 2025 14:15:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8695D8E0026; Wed, 20 Aug 2025 14:15:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 755338E000B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 14:15:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A7C683B8E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:15:51 +0000 (UTC)
X-FDA: 83797939302.01.4FBA061
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id AF70110000A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:15:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Db1qd1dW;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.219.180 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755713749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=96wUse0ygeqtfCpROkv1ZZ3hcmMnQRg2Z+H6dp5krQs=;
	b=Imds3c7IVCXOWvQE6aR7t4A30WIxFhHlIm04Iwgd+K5c7qM/pXv7IRcILaw2SDp5BX83b7
	qc/XT9S0Cq1GI6YOyMqvMxzreabFO/+HBZvRIlbV1bgCDTn+pcOJEZFlYzXe94HKsAiwLI
	6CJhTWZYDKfnal01+4l66O6RLLMs/O0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755713749; a=rsa-sha256;
	cv=none;
	b=ynouCiMdRhGUNLR9hXEjsLN3SA0H+E0hd3bYJsHDukfBOaVrB+qeID+rFukXO7yR0IuV2A
	m6RuemJPbQzAJdOab9UyNVKEwG9OXUi8UEfPayx0UZ7wPQXQHm/zHmg5APjXk4Q+wZmrrh
	Ep46+0Pk7NUuO8RrZ/5qLfXyLHF9O2o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Db1qd1dW;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.219.180 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e94e40fd473so128252276.3
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755713749; x=1756318549; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=96wUse0ygeqtfCpROkv1ZZ3hcmMnQRg2Z+H6dp5krQs=;
        b=Db1qd1dWD0XB7+DBWZjeG2ooKQBRSyKouJfWgTLlaCaN3GrR3MNJUCjeaiiacHrWet
         jfn5OUf4lRmXoTzhsoBS7AyG41P318+e4XceHRkLz6JVokNaMz8FjB7C2ra6KcKBxE1M
         4qZZXPm6anYBdLqimdJ6qehvEej5VRud8I39UqTDuoD5HI4hnmfUfck/8zApsnwEpa/4
         jFWkw9iXEmbc1e/Uzw4qlK7Bqdc5idaGe8xBZ1nFFkTgomQw1M32HHHs1HUvubvaJy1R
         mBkMD8y9Yshg2WW67cmYOfbUWkEScI+DwlflsMEXSOU+8slz5/46Sn0UxJHk6uqTH9mD
         aRCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755713749; x=1756318549;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=96wUse0ygeqtfCpROkv1ZZ3hcmMnQRg2Z+H6dp5krQs=;
        b=XN2l4PnEovGK8Hu3rABgglAOMLBooME/Ouglo1cypT3oowfiVQgTQJzy2LvrAltBua
         uwq+zOmGM0+omsnZ+BA16efu4V54Eio+zmgjmmIe8mKfIMm9oPAfbb2ZxpSFVMpK0Abk
         ggdbvsXnaIf3Mu0wfme2B1NzDPyq/G4DSxJLCjglEh2RVEQGBbDIGlYY/dMMzLZ2WT0p
         w9RVpeoNg3sKaSVujahbBsoejFUxlwjRSl5XwM+ozCUL4rMUu6do3PpMp1n/DLfB0ypE
         +n6Yt2w7/lWWK6blh4MTJWbsj44v1+iNVzoVpO1sx+klXwrK02N5rEpyiT+78O8jGLrp
         PdlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuuC7I88EirMoaQd4+976t4rK868laWJaXtGGltKnyJ5gic0QjuaANmAy9rupq39KgqxYtGpKi5w==@kvack.org
X-Gm-Message-State: AOJu0Yx0xRUgJqqKv3ihpB840H03kXtnx6Vtv4DX5kadxFSWIztMepLM
	vnlHQbiG/vitL/AgWpFVPBG4sndHTZTl15LhlEp88SmRg43RUEVZyXm2
X-Gm-Gg: ASbGncs4Yb1fs0MOtlPySJ3Un+yFQx1xACbyEgFPtOx38OyLN6LG05CrvDBoLk7tg1m
	nvJ23ddPuaavnPcFnjlkPQrUpeJ9RtiSpDPiiE5IYJrH5nSovBegQFcExIBVCaUg0lanOPuyVxM
	m2nC/4uM8RFnIrTOhdPNx5zGkKEuhrTkaMcUD2R+aGuCWl6uNRdjvHgs5xLSEmKu55XSwC/aSL9
	rDPeXokRCj8pn19fZmbDjVrxh8y/r3n03mGcyMrChBSYVYsA+x4vIHdN60IKgGPZDtbHF7q3Yc+
	C8RbG0DZ7DTBy/ZqrJZ5DtqovxTy5P8NWi97hMKPaaYhxQFVHmNznZNw+NJkFfV6wDx/rHd7O3S
	PGYYos/02FQ==
X-Google-Smtp-Source: AGHT+IGXLlrycdZVZJcRoezmANRufsGVW3BlL+gThG3xVwVx9OCUap0alwdRq2H2BAG3+kdMLH28kg==
X-Received: by 2002:a05:6902:4081:b0:e93:4e74:598c with SMTP id 3f1490d57ef6-e94f64e4be5mr4684998276.10.1755713748597;
        Wed, 20 Aug 2025 11:15:48 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff::])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e94ea90ed28sm1641937276.11.2025.08.20.11.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 11:15:48 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	chengming.zhou@linux.dev,
	herbert@gondor.apana.org.au,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/zswap: reduce the size of the compression buffer to a single page
Date: Wed, 20 Aug 2025 11:15:47 -0700
Message-ID: <20250820181547.3794167-1-nphamcs@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AF70110000A
X-Stat-Signature: 8furn3r6pu79doqcpaesgij34repxxph
X-HE-Tag: 1755713749-351234
X-HE-Meta: U2FsdGVkX1/nCWnRjLB32b4LmshuwRytzCs2rddWtgbRGWkxEoVjxRZab/DqeSDRUHeA7i5fX32UeXNpWo9Popop5v5aNahn7tYPdPbkIYQoZQHs13Gc745vhMN58GySIW00bDO7i6Tg6J2q+GDuvOQi2pnC2GashhVwEDp8QcOtIdDVdKj656XgM3pPM78dTGNJcX1/BXnCdTSy3a9vkBgpeB7txJh1EwFRz3hEdUBbL+MrmZx5FHjsKcWzfUYnJmq3UjT7uqsaoeMkB4mocbZphhEVou7Ug1NdruPtia3IU0FZZP+jFpQcFnrvyZranML6FiAbfn5QL5RAuhDp/5a0YqPFCsAH1VPd7BE4rGS6LEwvBmTuM75jGw55FhMRb7/GuHbogf7tfCCU6Uix5hmgEdxLHiPGqhx+99W+d/iC2zjpE9lMygrb92unOspNpxEloNz6UIImI9b3Dtwk1Y8Sg6AnHALgBlSUOTHR7IqWDorqUvNJ5IeT1OL+BqHy8ZsmIarA+VfyyNLS4QoObnWDd5KP7ZH/N+TstdSyQouf3gPKB5VZLfylihhK8G4KRKlHreC6RJlyfnOSeIz6hcNgRKP34xVF5UPlCIAe9dHixN/SEWgHazMYxsdfSyExDR35XSCheGhjHl3Aj3Ejdo2Rgnt0YGp7lWVs3Ho4IqgS+5BLRJ6C9YMp9w1Ur84ZxYIbQxThf9PFEPNB24KunfeKtL1REgsUIckI+O6gwFTLC41JOYQqXn0c4/otpgcPpCFcf9iM/erk4z8t4/ICGKbw0I+gIbwlFRbuHXLrotfOaPBOHmGGml6FvwgCpqYrSIZIR0FJOl5MUuJCGpn9i0WObZvTYsZXNMMw/1M82eDMr5OcsAyauprAdxmAMvvsbyK20Vm+MmYhdQOJy9ca+asdJ+Gp0zbJ2WvJQKvri51A9dRRhQTtpOdn0bvUu3Te1gEpRDm65+w4s6dvbMU
 o9ZdrP3c
 VTuBIvDSXifD8KHJNxB/J4dlYPD8Ns9ALbwyfmPhO7DGCqGGmzjqjE9jd+D8WMcR4RY4RxJPubnDtra36gQRQZDpRcFaRDC7SCrvX4o0xzfrsn2OGZhAo/nr9p8VQ+6Vz6jc7U6YIojPtRzZs8HL2EcasA7Mex7Z4aXnd8F97NsHVW8zflsRoLbR75BrcaBCoR5P/QUf7wfWET51LD7pEG5nfHW+qQx/6wOoZSqIyfW1nyHUUJdK4QgLuBF//ycEFhL3fb4aNNIDdO4OkTAQaqz3eNyM+U7eXG/ZZIX+Rm3KtguRMevsBOlJZoaOB1Iza9aDN6qJK/Xc046YB/Z9c3znEWDSTJogjMzCAa7UtsAEghxI5lPshozy3w/Q8XoK3QNRwSx79aJ20cUw7apwFTi4wS5ZQfU+xzpzdn8Y6EX1fWPIklMyZ2uI5THQHqqDMlcwDzsjJP4+97KPVN03kenld6jKe9frT1ABpHcLFgKynAONyq8bgamvVkcPxnM7Eq9kTx7shzcVkist++fztQo9cpbSV/LXmxbhSE5Eo/rTvtYm7Zeh6HToV3ZkHRWXwbF83MrqsIQtnXgLR+6SUB6yzrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reduce the compression buffer size from 2 * PAGE_SIZE to only one page,
as the compression output (in the success case) should not exceed the
length of the input.

In the past, Chengming tried to reduce the compression buffer size, but
ran into issues with the LZO algorithm (see [2]). Herbert Xu reported
that the issue has been fixed (see [3]). Now we should have the
guarantee that compressors' output should not exceed one page in the
success case, and the algorithm will just report failure otherwise.

With this patch, we save one page per cpu (per compression algorithm).

[1]: https://lore.kernel.org/linux-mm/20231213-zswap-dstmem-v4-1-f228b059dd89@bytedance.com/
[2]: https://lore.kernel.org/lkml/0000000000000b05cd060d6b5511@google.com/
[3]: https://lore.kernel.org/linux-mm/aKUmyl5gUFCdXGn-@gondor.apana.org.au/

Co-developed-by: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/zswap.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 1f1ac043a2d9..5dd282c5b626 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -833,7 +833,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	u8 *buffer = NULL;
 	int ret;
 
-	buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
+	buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
 	if (!buffer) {
 		ret = -ENOMEM;
 		goto fail;
@@ -960,12 +960,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
 
-	/*
-	 * We need PAGE_SIZE * 2 here since there maybe over-compression case,
-	 * and hardware-accelerators may won't check the dst buffer size, so
-	 * giving the dst buffer with enough length to avoid buffer overflow.
-	 */
-	sg_init_one(&output, dst, PAGE_SIZE * 2);
+	sg_init_one(&output, dst, PAGE_SIZE);
 	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
 
 	/*

base-commit: c0e3b3f33ba7b767368de4afabaf7c1ddfdc3872
-- 
2.47.3


