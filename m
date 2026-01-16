Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62245D4899E
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 13:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C82896B0088; Fri, 16 Jan 2026 08:29:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30036B0089; Fri, 16 Jan 2026 08:29:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B319F6B008A; Fri, 16 Jan 2026 08:29:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6A76B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:29:54 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31F6EC01A2
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:29:54 +0000 (UTC)
X-FDA: 84337909908.06.6C0CFBF
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 32A9B1C0009
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:29:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UUAyqfGf;
	spf=pass (imf20.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768570192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V1EOYdbPMccS+aeufmTW2gbnPDhaXxuCCgvNnc3/C2U=;
	b=w3qU3ijk9oKQuzNFwC9l+YUlSpP0ZiM3zu9pMl1fYFGfyflbnuyRkK7D7cLW0oVeAT139Q
	HG1RozgzyJ+RMEdgkdvIQ3DQ2MzAFCNcbbhjNFYWIaOWq7gGYsJ8LrMS94ELRK3mJXiQQ9
	6BaFi96hdklqSP36/zq6G10oTiZYp/Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UUAyqfGf;
	spf=pass (imf20.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768570192; a=rsa-sha256;
	cv=none;
	b=NQEN+RAJga7F0mtkioSjAk/x8XwA+MaSgJ8FOudIeELnUf3aJYQ77vCZemNUQ7ndckH8+2
	sdGv+zOq3tCGqmq6HBZGpT90WxkujGxlzuw6Q04quis2Njqj9yS8Zq3ond5UNojMA3EzlX
	ONDiBu2qNiuUZWhaSEaPvuTa+AcsMyU=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-59b6d59340aso178191e87.2
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768570190; x=1769174990; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V1EOYdbPMccS+aeufmTW2gbnPDhaXxuCCgvNnc3/C2U=;
        b=UUAyqfGfXreQeGhrWdQrwIxOdkKrn1U9fweGwPyTz6EqeHYV5EKGwl4KvY/rsJSOcu
         P9QMqEVxFJKCplwEgsv3VNAVJ4hafj3MRf4Cl6XQNXTGSAjqBq63FZ9JUMucFrBcv60V
         bFrYZX1ACdNpr9xO2onUVgp5QyJL1UsXXy/fpeT2PCX5HLt1xHdETDYTdOVD1WB6t7B8
         ilAVpZB+3lGE4DEF0lmWq+05Y5eaoD3k7GhbMTS4scoz36QoDuMAkJlZ/n3ooFgAPNLT
         upoSdcmeFOyi9l8+mr9DBgGDxbWyMtT+UdNXsaSNBGtIO+3vB6nL6EwndZ6SCEWv9qwo
         U3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768570190; x=1769174990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V1EOYdbPMccS+aeufmTW2gbnPDhaXxuCCgvNnc3/C2U=;
        b=oEyERpLgRNOA+bgLmrcENXomHOToviUY7/0w7OiRmkxKB0y6kJaM6erTesJEiHmowd
         6sB+8a//yctHwgQXqB3aYBDZO0miqf+7yBUAf3+EwpJFB9MfVVLt+IKh6aW0aEsMSBmN
         6o6inxHS9045Jc3t5WFjFthYNkDE3/LcJnhRKMcRa0VVqWAC0KBGDo5qhHgPqfM2qb0E
         kULcBA1Cg/sD+PzzsOtZl5GO4ex6mNbjvFAZiRMTHtxBPYeml9GMamZcex4c8/hYeivJ
         fkr3oRL6NnQFtddXjRvcPBgJKybzXr2pfGtGBkuvv6jetFGrAGNwbkBHHCjLHxDD4oqH
         qMnA==
X-Forwarded-Encrypted: i=1; AJvYcCURKDBW8/4JHwPA7WjEuDGaNVQvvQnMwWFH+OfIzc3fSdtCcFOmTTF0/2p7nF2LVvyaSORubi0Psw==@kvack.org
X-Gm-Message-State: AOJu0YwKgGFa8xLKFOOz65+N2WYuQ05asS91WIGSgTUuO46oIKyUKNxG
	oQ2rdyMy1gXiDFPkRrJPgsmEOq+2t5RxCoRmCZqDZF7T/FyLydXT147K
X-Gm-Gg: AY/fxX7qxWvyKFe8nVy1nVpEG1birYJC90mvgoT+WtJ6Gv7NfOwuQoZT4z82FI5GN4L
	bcmLFkZxALSFVjSV/SNLvE3xlm9X7T+Io4vwSwd43zt2CPXFM54RYp4sCU7QnX8/K63fZvRbe/F
	wUQl5TrI5yRalJ4lefg2ngEd1+UoIRkGOPulQvHQLNFfxASia51kt2wor2HiS7QP9ip97OwWopu
	87C6TYXz7VCecth28fbdNL/ASALglzFJMBs6e7yG/8BI+i6KzCvG7Re/oKALZ+1LTfYqF8h178X
	M8wtbdIFjDTzO8jLWxY9a1googtFTNtfGj0Kig1ZcQSLIg1WfwSecm9w/6XqdfnVpmtQhgW1YdX
	RRZ+Gao21LOmtnHkW4Sou7yD2+C4ze8SdbbX9YTbj3iK3nAAKiGq0iQbWfjP/jxoFQPUyg64MG0
	YtCy5fyz9ezYoHhc5z9oPsE2NjaXqdzbAjHw==
X-Received: by 2002:a05:6512:6182:b0:59b:729e:680c with SMTP id 2adb3069b0e04-59baef04d3cmr537410e87.5.1768570190107;
        Fri, 16 Jan 2026 05:29:50 -0800 (PST)
Received: from dellarbn.yandex.net ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59baf3a2aafsm785875e87.98.2026.01.16.05.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 05:29:49 -0800 (PST)
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Maciej Wieczor-Retman <m.wieczorretman@pm.me>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	Uladzislau Rezki <urezki@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: [PATCH] mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc-fix
Date: Fri, 16 Jan 2026 14:28:22 +0100
Message-ID: <20260116132822.22227-1-ryabinin.a.a@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <CA+fCnZeHdUiQ-k=Cy4bY-DKa7pFow6GfkTsCa2rsYTJNSXYGhw@mail.gmail.com>
References: <CA+fCnZeHdUiQ-k=Cy4bY-DKa7pFow6GfkTsCa2rsYTJNSXYGhw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 32A9B1C0009
X-Stat-Signature: ezs4t5zt83xmfyhq6mrzg3i1yh8mqzzb
X-HE-Tag: 1768570191-675901
X-HE-Meta: U2FsdGVkX19Wzay6qgf8/A5F+xv7P5KjrKgpe2QeCo3fAe1X+gUzQIAwJ56szUKRwySjjeVWljZLsJ/k/GQVCe0UvWQtL1qtuXCq1KrMdcwoEuimqmSmEG9FlEDakaw2YMjEGUyiAwEIvpAkjQje6q8HBiO0ff9H58pJ46ilW9sQzDCoqVAtvueZmMVYECjV2ETXHHJRJk6Gf2OuEZmzgGKd1sormaFQTLqZUIC2ZjwdrnnJB3O7w/IhZa4HzCZgXY1yFNJvMUVdfikQcPJDUfW9Gru/mRZDwoYxPTrWg46BNYqddRhQWMXyh5shqHG6ca+cAaf/Qlq/AvElSXLHGamgUQtXn+sIoOidCIA4tvGSiWOPfgfH215+J5lHNmNaZGspkcWkv54cJKLU10I6xJ2p/DQwZg5VTLkEZ5kuKUFVP6lAUkubrY9W5mvqutCzZxipcnm1TkEW5H37Tx/Qsg/Yx5aoJ/oKDngTqgef+dl5X4Ld8JWFmid7GL3D1RH0iP3vn1lF4k/L1Bjdcu8rLx+xES4f//kSFYzeNQwB86JilWeFtSvbC48RU+O8G3Hd53lM1TzqGVzX1i1m0cklMoZkD0Pt3Tqv2fo0n2U4HBvdDm8Ad/Csp7fMrT/zrJ7LDXeN+hXTXt2IbUz6gPTV8z+jmUSYeLQPTwtVeDM+OSqgoqETRgCcyNCntPFpN2G1Jo6wOYAEaxXYX4j8Cu9gKIxzdjQFfijMkCYh/1g/SMvBbiyN5ZmZVb1P7x2pTE60RG4nB8TPq78xkRugOQhE7m3o3PHaI5O1biiDrfqCeMoO+KzTTyBkiiqwbB9oK7Kou5pRrhoj74TlXeUu4XQQyjSXkmCsXmPGNpxRR0cpGdgSXMhukF9gekptfTuV/8vBQfMcETXyhcdmkvG3sVHVS/wN7qov3O/INLOAEojg4FXUzCuAuIH76+44pJNRe5vGQVlCo0wYQJgbFiNbhQ9
 o8E1/5Mg
 Vzm8y8Y+0EOXL7CsTDdsCUTfqhwQ0Y1Jh2EvXbj1+B/h5Q0jbgwvMylgzFN7gC/Qgju1W/GkG0F6cPd7f1DLOFJ6LqDThf62ZsXpuapcwuVcBTZXjPcVOS2yjl0zkkbuy5uB9IIIZ13rSlt/e1o60Uo/A80A/15vyyx3v5nuSiHTl2CUGgDHZJi/FDiTT9L/K5lK1hVodFNzgzyRl2p3KctWkIZISv9gAhoZoQzH8GTOqcUV+9m1r/9SkP2x7+ZmwnzlsXFHcwr7jViROUDcqZ0AHlQ0dsci9qU+1AMtzUy5IZRJBO/GVLh1VzgsITtrOV0LUBVN8PEFajB5mQ7xTtWYzHP85avae311ULpdl2tmiVYBMbEhVSCgC2B0aQq3jNzDTUSa3YMsXOBUsSFfhxLOVgMEZyFcpvGvvJeILn/Uqco/shzbbOmpw9nS1Ttt7UXKpmuAI8J/Jr31HyN1nox4D5CGwQVQHRBXFFdxMnbV+rItz+Ras9gFy7xzRM5KPKN4Vtaq8tvlu/dtXjebOe6kyOMOGBiWSWQZs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adjust vrealloc() size to verify full-granule poisoning/unpoisoning
in tag-based modes.

Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
---
 mm/kasan/kasan_test_c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index cc8fc479e13a..b4d157962121 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -1881,7 +1881,7 @@ static void vmalloc_oob(struct kunit *test)
 
 	vmalloc_oob_helper(test, v_ptr, size);
 
-	size--;
+	size -= KASAN_GRANULE_SIZE + 1;
 	v_ptr = vrealloc(v_ptr, size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
 
@@ -1889,7 +1889,7 @@ static void vmalloc_oob(struct kunit *test)
 
 	vmalloc_oob_helper(test, v_ptr, size);
 
-	size += 2;
+	size += 2 * KASAN_GRANULE_SIZE + 2;
 	v_ptr = vrealloc(v_ptr, size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
 
-- 
2.52.0


