Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2714D29DF0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 09:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16DCD6B0089; Tue, 13 Jan 2026 04:12:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126776B008A; Tue, 13 Jan 2026 04:12:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068D56B008C; Tue, 13 Jan 2026 04:12:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBBAB6B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:12:07 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92A31C077C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:12:07 +0000 (UTC)
X-FDA: 84326373894.01.1A0E704
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id BC5C710000B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:12:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4mij10i8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3ZAxmaQYKCGcLQNIJWLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--glider.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ZAxmaQYKCGcLQNIJWLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--glider.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768295525; a=rsa-sha256;
	cv=none;
	b=D5BzrA0x/9/ypGB3TTyUtfqnHqZ6JaPxiRAe7LdGa4g4Zd+DZxRp3azlpFtpsmEN/FtSpt
	Ee48c73aYqJ7jwo0u9EUsU0ZwbgV/M/Dwlbxq8tsDjFIP60QhQ9VOTLQa4fOY1Y9mWZZwB
	K+FKdtVqWZWpQRJeHrC1uR0XH2YXzok=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4mij10i8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3ZAxmaQYKCGcLQNIJWLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--glider.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ZAxmaQYKCGcLQNIJWLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--glider.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768295525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QoyuWfM/l4vhVN1gT6WNx7tPdfw0LF0dPn1W/6MnGsg=;
	b=04IxSvhui3rK059sZybf6IlDketY9HGiMJfwtaoh27Qf7xTVW9kX/3pmulv1fsKVRu57I+
	J1cwoW6rIQP2sio7C82GSGP3f6ZqOBprXLihiu5IObzX6PyGij6FAyhbEX9UdgCoVMbSuC
	CjTOUvnNC4luwPnXQhFGKancyM1hofg=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4792bd2c290so85169865e9.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768295524; x=1768900324; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QoyuWfM/l4vhVN1gT6WNx7tPdfw0LF0dPn1W/6MnGsg=;
        b=4mij10i8RxC8cPU3rIZEds38VdbW4N8uZPVGU0AVuUVf3dYqm1rwKbNYbk/KUW8x/k
         VBhNOm6MLtrbbJUOr6vRgO76ivB+N2hP0LHHtwFQOmQQkpNW465iMBWzw1Vql0Elek0B
         DvBFB5xDXPN+JBv/bmBhN7nr4O0sm0vQGaYLz9rDOuTtub/Pwp5VLCqZq35Fk3qiRWKR
         Q6TjdQNBT2+XJHRNe45bNWaz3++4EvlffTuXq0q/kWDO9XluKocUNiRV6ipUz0+G/7Ri
         nqTzma98H2dIq9gO76WyIvZS7xIfq519ZJBEzPYsPubSDpQgJUcjGmW3gxBdBMEVdWkb
         ioFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768295524; x=1768900324;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QoyuWfM/l4vhVN1gT6WNx7tPdfw0LF0dPn1W/6MnGsg=;
        b=Ef3VG4D1tQJqdIpg1ySD3xoZZ0NB+oXZcpt+cxSR3ohqoXsfmgmK9jXLuh6y9TdpFZ
         Zvw5qGxcRO+xWASZ4d93T61EGAjU1IRUCi7ebBVGzdeN/jBXaFCz1etEmyrtMeK4Nysi
         x3A3vtKKKC2O3/Pu6VfilVQ/htlxVSBOUra4P884UY4YXh4M1KLhVL9fVTtFyBXk97z/
         mGNGq84yzUBXAP/x0quQ41nrQn9NTjdzv+4gkPokUwGXOQAwO2XIceGtvTub95vmXTyF
         9AUBsf3WnjlEmlJqsgh6kcVEzAQAJjkEnNrYftcqHzbNheX16xWAJhGWTqdSbWEIgxw2
         Yzmg==
X-Forwarded-Encrypted: i=1; AJvYcCWQIcLhocId0E7BGxj30FYX3ARSKpBTWTZ2Aouwr0qfWhTDBZ1c7c3UXii77WWah3KEmQ6j244WMg==@kvack.org
X-Gm-Message-State: AOJu0Yz0U7ZkQaFbA+99wlB0ZuJPY04Fqsx9OOJqfJ82c3JWUFjS3UmZ
	u81feGNvXIfabrOvTjxyylvYwq8ciLaJzPKfFQPasbWY5O/q5AjguklzYkNwrW8SRqlfoXJb1gq
	7aAMyqw==
X-Google-Smtp-Source: AGHT+IFs4g+zehZrcA6xY2I2VAfqlWGQUvCkpT1m3XcXWjJsR+XNjNwxt0+6LBE8zpjXn62+SxNDoSZIBNg=
X-Received: from wma11.prod.google.com ([2002:a05:600c:890b:b0:477:a4d4:607a])
 (user=glider job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f87:b0:475:da1a:5418
 with SMTP id 5b1f17b1804b1-47d84b0a9a4mr228119995e9.1.1768295524305; Tue, 13
 Jan 2026 01:12:04 -0800 (PST)
Date: Tue, 13 Jan 2026 10:11:51 +0100
In-Reply-To: <20260113091151.4035013-1-glider@google.com>
Mime-Version: 1.0
References: <20260113091151.4035013-1-glider@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113091151.4035013-2-glider@google.com>
Subject: [PATCH v2 2/2] mm: kmsan: add test_uninit_page
From: Alexander Potapenko <glider@google.com>
To: glider@google.com
Cc: akpm@linux-foundation.org, ryan.roberts@arm.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, elver@google.com, dvyukov@google.com, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: BC5C710000B
X-Rspamd-Server: rspam06
X-Stat-Signature: hqx4xdmry8o5c3fmzyz3dcw9q8mpaazb
X-Rspam-User: 
X-HE-Tag: 1768295525-293014
X-HE-Meta: U2FsdGVkX196racdCnrrl+wzXydKUE036QCtvPlLe7pG/njlGCPXPXBxOAepCRXB2tZyoQT+WNsdVPUcPWXrwYCnV0jhzyiBW/dDMDfmwDxynst5r4Qa14qP/jD2dXJ+zyrkFKJMBN44NJ16Fq0Mbt+ac/t8icwyRXQDwXW4TOEu/cPcgMqZIWO2f0mrCHZZz7rGgI6QHMXFxgHmoLkrmaOOsn/P1Rwz8OwTWUrw87EYwm7qGzE9887aHMcXiZgK6nQWm75BMJ4P0LgrHFOg5A+Q1NHr9wu8FEdk1jB8Z09R3DVKPcBuExtTbLM5FdvkzX2CN5xhzdHkG8bBBg3FXfkofZWGMZDh/Xbx4eKVHGrfvCH4YQ6pgDMPDKZRoNwgURlwnjQqnIgs8vqnPwQG5CJ2+OVsGd/0sgNcNfqvuNuiCLn1UXKjsYMnEuIVSIBgB+Wlq003HZRCDrz1i5b9mgT7KG65Coe516+3dxatd4RJ0gZLaBqszjKLuWvoQlGjCevC28Zy0fr47RoDkDcwjM6y9V5ZSQwK1U4oRN9fs9rot0bdWYIA9Dgc97cJRqZSSIlWvfbLN+TaT7THZk7+mggvNAf3yoHMvZsgkSY4gzoHEEEvV52pr6JziINrQJKNtHZhMgoBOz0rGnUazW5yKLv1bod8LPttefX9bT/pGDMQQxSRPIrW6Va69VRm6H2uFlRelpxNflrB0HUUelt3VcatcaDkZNJQus04Q4M7+c9Ul0ZL2W4Dw1F6ssyRUVDKmMi1kLD2O6f6AovJjteh1mLUr5GwGm4qqEAZhR9HZvHkeB7gsfyJeq/N5d7Uj8y4tNhcDdVlWNkcudASEDKDzfCCmjKlphRUKcLhH9DgaOBq3h50AdXgsI748eUjucppsJ3Gfiw1mfTRHLEtUPDVMgTv/woD97YvoaMtAc0NlbVIGNNCEpHBbT07Wr8GN3XBkjMgUOhxs5WMMnfR1Rv
 SoJAP6Hi
 3ZRN5wmz3PYjBtCa9Z4st0ZbPbUlGVRFN+2SvyckpnIEVljiW8EJ+spXDO3xJaTYYwYAkOjXNRXe+H8nONjVNnfOOYy5v6wW24A31dOYNRKUUtiQgV8H6dBZemLzH7w4HDcMedvSncIjRVTZOOvJhjjGhIJoNs9hSCPuJjt8T6h1f9QHjZ9slTGy9T/so9Tj2xUlV5U9g2wknRbf2xsudMR/wacOQBb2rb3+CMKTlpfdVM/fFDYghMbeS4/1JklkAgcNCsC7J8tzv+q9Cqdsgshov4mI1b2GGDwdI+UJcEP3ABa7ncTpiDfaeQzB//mvm6jPcqv6kQ6XDMizapbtqk2oEA3HRvqOSqZ9cgNLZw58PDQozqPzSDN2fgEYiwktX4+/tgyZ/9JUbhmOkXNn+YUrcB69l+ha4cotycESYCrXUE76hKY7xD/wU7S7QwLh5cyAG1LMmwp1LBVV3QW4jirE51dhPuuDLFIJ7HzpFGBzta7vjml+Wjj8sbjOc8PFODY2WGDn7KOgB49tP0cm2H1rOxMhKOjj0wtvw7L1r2riTIUJ9JUGMO49Y+FTRXxvgqi4R5m0VAQvEfQagDK+s/iB+5BqWLAQi5c2wcdW2U4NbeMz8SjkH/8EMhcwB8Ji9c4NFulmDwBxQczyhs4LdBxH8EXaTefAihLutz7w9d1jYoyk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test that pages allocated with alloc_page() are uninitialized
by default.

Signed-off-by: Alexander Potapenko <glider@google.com>
---
 mm/kmsan/kmsan_test.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/kmsan/kmsan_test.c b/mm/kmsan/kmsan_test.c
index ba44bf2072bbe..81e642db6e239 100644
--- a/mm/kmsan/kmsan_test.c
+++ b/mm/kmsan/kmsan_test.c
@@ -378,6 +378,20 @@ static void test_uaf(struct kunit *test)
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
 
+static void test_uninit_page(struct kunit *test)
+{
+	EXPECTATION_UNINIT_VALUE(expect);
+	struct page *page;
+	int *ptr;
+
+	kunit_info(test, "uninitialized page allocation (UMR report)\n");
+	page = alloc_pages(GFP_KERNEL, 0);
+	ptr = page_address(page);
+	USE(*ptr);
+	__free_pages(page, 0);
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+}
+
 static volatile char *test_uaf_pages_helper(int order, int offset)
 {
 	struct page *page;
@@ -727,6 +741,7 @@ static struct kunit_case kmsan_test_cases[] = {
 	KUNIT_CASE(test_uninit_kmsan_check_memory),
 	KUNIT_CASE(test_init_kmsan_vmap_vunmap),
 	KUNIT_CASE(test_init_vmalloc),
+	KUNIT_CASE(test_uninit_page),
 	KUNIT_CASE(test_uaf),
 	KUNIT_CASE(test_uaf_pages),
 	KUNIT_CASE(test_uaf_high_order_pages),
-- 
2.52.0.457.g6b5491de43-goog


