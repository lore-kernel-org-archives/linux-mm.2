Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B1F6C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 451616B00A1; Wed, 19 Aug 2026 03:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 401D76B00A3; Wed, 19 Aug 2026 03:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27BBB6B00A4; Wed, 19 Aug 2026 03:54:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00F246B00A1
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:54:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 89F434042C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:54:35 +0000 (UTC)
X-FDA: 85117256910.12.A9084B8
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id C980E120002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:54:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="byqkAa/1";
	spf=pass (imf29.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787126073;
	b=6Jk0RoDHyfIxp+5Jx1si/+jo35fzWzfHDJzFUS+FDg+1XXBveqfMBxME2rjq+9rqMtWOGf
	9mqGyfW7DwCMx3PYU9O7Gc+LTSO8QKrfCkZzMTdGzvREkRQqkTJLVQOdwd+nrNGTkY+Q0p
	D7FtaZ9geyEOM8MBTYDi6/7diN0Ji6c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="byqkAa/1";
	spf=pass (imf29.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787126073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y5VObEqVOp99ppCJ9xRs38fsUMieel2e53/fex25hio=;
	b=rN3KSC2hD+aV3fRgC6rM1sn7ynda99LmDVqH39x8Ic41kZEnU5Tk/qAPhMdUjHiuFx7Dac
	D92mMZ9FmfCf2pcyVEkScm6aGzrKOt557qX2U9KwPSdbKScCojO8d4ANaZ5Zaoetgzwe4z
	cwY+Om3jhUIIPTdqJky/jNnaHdWBjiA=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cbb8b54fcf8so586324a12.0
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 00:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787126073; x=1787730873; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y5VObEqVOp99ppCJ9xRs38fsUMieel2e53/fex25hio=;
        b=byqkAa/1qgmLULto2isYF0Ac6iofBly9pPsSNAJ7LicYvdIjSc5WLXp31P5dwmuLNS
         0snjJH3GcpEvqvjsH15Huxnwjm18rC7tq1m4/5iv4+npCmEhTPCkSwcG2365o+hrCqag
         pTjFG5haDpo//RDCuTXWRuOpVJakW5RNQU9y15Dz9X6kiNET7TcWwE1wqDdSYsKhuH1T
         BSm9DCC3OBga0DsfxDeTTmJO9/wAOe7cudhRmpRVfk6XeV62eEX15HsPH4ab86VY8dSm
         azkIDkYf8QS46NDAwJ6F21YYypqp2Rw9hDEKLMizyGNjWh2LwlNFV/jAYJtE5+ETRHMm
         Ekvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787126073; x=1787730873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y5VObEqVOp99ppCJ9xRs38fsUMieel2e53/fex25hio=;
        b=sS4lcdfcVpgA6O2goKljqvfwFrMmiZNfHpmmmvVns23q58ztRG9AEKSnW3GLlW1D0z
         DfND00Ij3+iFFwW1kbBNzjb7hXIfzLPfhQwueOgIO9pG/ySA426FA1PCBB6B+2LeO6vO
         SMU3mI4y8y8k/pByu5YoGPQYJo0K2yJiCo+ZKQew83jI1VUwF+aGCdXDGJtMS8yhXV1n
         /K6LgllIXZtf6e+yNINVFmZ69uN0ADsgmOJxSDv+oF104edNYljDc6Ug0VyVoLKdjQbP
         Rjaf3zW47/V9I5A2eDrYH4xjzLR6kiUTqpS+eMPquJ2y8OIdQ0ryTmGcptkcEC4puLss
         TCEA==
X-Gm-Message-State: AFuF++nHARbj/909nhHijBquwzD5sgT5BKwVJwMLFwRkFD0UXaW+Oa52
	jO/5ckjWahPT9qbtoFG+LuVsiFpA9/QrBSiLxyGrwpMgw+F8E3dZWriC
X-Gm-Gg: AR+sD12oKYfYARDukIjp1uXTvXUoGJhpzzhmXXSR/QHnCwiXfMB1lrxzs6kTUasHBu9
	ElE8ZGC4Xbk1MMXBxe2bsIb7TCQP2nBa3HMs0KoFLXjwpvXm/E+foGCQZ+isaHAGp5gIT39OrE1
	CyPdIjfwpTSrS/RQsh38PqAaVq8Gg12UcVB9tl11wWpmDamJt5v6XLkI0LlDA0f6bvdQ/yXmfBS
	BcL8snPML1rjlsASnjXUCZx72Qj4Z6XEzzl54l0S4Y5rXmMT6gDypBUyEsAsrB0amgqivhqRhXP
	84cOgYdrUbVLNzMEY6kUqmPLfKNRhXWTPkMmCL6OZfG6BLOt2WAVDCQYblQ30VAd7C0clO4wFQK
	bl4k85uCgKVBd1I7hucEG3Usk4FUYP5Vb5V2vv6jHXTaAFglgYoJ9Metn69q/X820OBq0pL5rjJ
	r4UXpCp9DhAdX/8GsORjWtn1Y8VUVuLPAeu7jqSeON9/Tt4XtW/YygP6AuVjWP/fs8mWmMYWIXr
	E/0YClZDQrObpXcurGVYBvXlwc2
X-Received: by 2002:a17:90a:d60d:b0:390:8361:a532 with SMTP id 98e67ed59e1d1-39580bc9ad4mr5475274a91.7.1787126072381;
        Wed, 19 Aug 2026 00:54:32 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957faf596fsm1668929a91.11.2026.08.19.00.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 00:54:31 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wandun Chen <chenwandun@lixiang.com>,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: [PATCH 1/2] mm: memblock: add missing HugeTLB flag name
Date: Wed, 19 Aug 2026 15:54:21 +0800
Message-Id: <20260819075422.2387980-2-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260819075422.2387980-1-zhaomeijing100@gmail.com>
References: <20260819075422.2387980-1-zhaomeijing100@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C980E120002
X-Rspam-User: 
X-Stat-Signature: r6jndiih9zpkeqn3np6e1bxw8smnjehe
X-Rspamd-Server: rspam06
X-HE-Tag: 1787126073-964723
X-HE-Meta: U2FsdGVkX1/G8EFoAGg3w8Hpb6zmFqKug67zG/Ug1hRTuOYfSaI3FAUfThc1ux3gVIO3px3ExK01GSh3JaeXo7rZZAKABFDp7GrpYsVzZlDpB4SklGQALeDblz5BazXSEi+N73FSRC66PhegSsXuzeR/P7+FWvywI0HT6xv04ZFxDP9W2dt/XOCBahDMhCH1LFOC7gyPdYOzjWRodJytZgajLU2ulVGfF3RVt4I48OfTDLb2bCmuy1eU9wStHR2PMzg/Nhc3S+I4M2XFC+Vdo5gUNLuz664Pj8tBDTbfviDz5SxoMD45vBfgRxl4F4W6C+XG0zlsjDyZrUzPTTwW+0Zj83tV+z8psAEoahIXJuylgTf+44TAQIRwiHm+bN+4al8OopFauPIez6lPA/b7OR7VXwBPFlgapl3rgiod36wylHHchkqPXy6RmMYmxH0yoXLIeizD2bipymrPTTZe6jIZjxVcDW980Svtm9N09En02nGIvs5UP3m79mSnhIgJtB7MROglLbeiTGdag9HligBue9Nh3c7Fwy2TgAuyqx08Nowyy1HdIf5mrZKTU7YrR4R7Ji2zq6aaYXEQnV6U8tRKarUevsCZGCnag8BH+S18GUKdbq6V2NRbrnTaQXYr/aUhlvHh8C5AwDAnqeDLKp6R98sRj/QCRqx+aere9DErjEgmc5WgdTikWDHQ7sISgI7Yj5Ea1kRFONI+0Xn6pK3CW6v6vyYnm7ZozU05nFsDxbu5xcQmFcaxtRo+96HrmQdoBoKYcuG4vySUg0g+6QDBd4gzGGbdfPT/Sri1n4TaMvJBfsDp34A3D3vlLqm+5ftvcb1wU9XPZi9yS+644ni/SKYmPzL5iTINJhAozxvfFBeZl+gBOqhVenCSX5+Tiw69430F/IC37XWp7sd7/np+vY2brQf0BwZdObTm8nqrr4bHXqQincUJwxtWsMBl6GkV6j6tili5N7QTTTU
 OLvEcNQh
 z2nMlWHIS1LVGlZJw0qltVuxUtV5nzJoLd5gxKPyWvB64wrjLCzESfDIIiE+ingTLW9ModFcVQ/VqEe/GLL84shp2NOjRtGTxlH5MWskRXF7stOQ9mWTllbZF0fs+HOTecwz2ZPJMxjtzx9Msvh6A7foup2LjJp37Vgiu/XWqymfyjncniPWzCugBsaPaQotknZwYe7vvumcNyUa83h7Q3CF68rtnA57G7L/mOhYn4GIThiPU0OUVwbqAXzsN69I1RGCkl4YIK65hJfpOAE2X9jW1Q4y0Zt3c8VapaYcZ23NIt8jPrH7BGHUtC0250shfMB41UqiZSJ6+CSpwDhqNQSmrEp86zdRgcA4Errcke5vJk0jLxi8EONyurzPfIQMOXSU8xUL1dkxrVBsFZQVhlRcRrLokoAapKU4sSCyopt5z88iq0cbjn3vVBrwH0/NjEsdebibx6qJcbf0IEhdrLo70gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

Commit 7d163a75f821 ("memblock: make HugeTLB bootmem allocation work
with KHO") added MEMBLOCK_RSRV_HUGETLB but did not add the corresponding
entry to flagname[]. As a result, memblock debugfs cannot report the
flag by name.

Add the missing RSV_HUGETLB entry.

Fixes: 7d163a75f821 ("memblock: make HugeTLB bootmem allocation work with KHO")
Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 mm/memblock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memblock.c b/mm/memblock.c
index 9ce86349a29f..f2952d725c10 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2886,6 +2886,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
+	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.25.1


