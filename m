Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5EADD3B7F3
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 14:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F003E6B0023; Mon,  8 Dec 2025 09:36:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB01A6B0024; Mon,  8 Dec 2025 09:36:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB0B6B0026; Mon,  8 Dec 2025 09:36:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C701C6B0023
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:36:45 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8BCEC1A0172
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:45 +0000 (UTC)
X-FDA: 84196555170.04.D40A9F4
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id BACC0C0012
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y92BIRuq;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765204603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=6HnlF+1BZAwJ9l5gRTfNmZNfWFGFL2mnvLd9xIbmFwQ=;
	b=4+sm8ReI0Y7XXR7YuywN7ETV0LHnGd54poLBkI9dl2yQsoLKdFZ+Yr1zDLiW8JkaWgnK24
	ZTF3I+qh1i5TwhIJRwDL4/gaueY3O20QvDvLa9P1SUJL+wqXmuQwYzyICnjJTsxtO6pCAo
	UOBQGUm9wvfJJClZYQmpV9NhemlsPbg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y92BIRuq;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765204603; a=rsa-sha256;
	cv=none;
	b=XXT8HyQdA9vkmBUOTrGgRkB7EzjAmzEz0lElKZvAglVqJDI7uOjHM7Mrit/suEYG31NBO6
	1MbxSHQ69L3OzMx4d5EpCICZJL0OLVCRZmFKoGTkCs0zF4tDHU3pl39GlIiZbn4gozssgj
	QTw2ylpVuXab11JxbIt5AkGLkCx2O7k=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b79e7112398so752721966b.3
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 06:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765204602; x=1765809402; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6HnlF+1BZAwJ9l5gRTfNmZNfWFGFL2mnvLd9xIbmFwQ=;
        b=Y92BIRuquBKZ+pRVGCcxDalQW9Q5lanzXvZZqSzfJX+yOy49Ukb386v+gFtpiqbvzU
         ei5MSgvIhNX6IltygHNswXRQK85kWuXjcxSey3N3A4pXcpG+XoZ9zd76y7hJ/tRueODx
         4PiQVc4EVn18hRjFVih4wD2sYcRQuTWXrsl0kyHtHWMlJa5k7+TR8C2HrM77yb3jg/pA
         +WhP44psz24QvFu9SwJh+BGfTSOh0hqnSpZZfoxf9wtGhUVYl8arcz95lZeNUqKnMLHY
         Wl+YHkGElb546JBHYPuS2l4H5U151FhuThrgGeCoPoLDQS4eXHqYInOseUAEFnpszsDc
         rv5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765204602; x=1765809402;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6HnlF+1BZAwJ9l5gRTfNmZNfWFGFL2mnvLd9xIbmFwQ=;
        b=Y+SNGlAm4dWPA/+WedK3f99jPolHTDTwnZNjq02dGhFUG/9qjeoZ6y8mh1CdcUpHP4
         NT+z3v4cCARNjWHNVVeUim3TC+u0HosIjmHqfrq7cq9qUXIzhWcU1BN5YW/fViO9DWXw
         vYU9VDH9WOaErexPkc7nnQ5EL53XXw5MiI2WaCddHketT8TpqLOkLfOtO7iuXcdOvAt9
         FUvSY8plRsvPxqvecVU385Dmstak0UjO0tp6CpzCIccy12+7+XN5hOX++zCkUNgTS8DL
         p9G7M52bWHKIDK1TOyUi5RNwRVCgcT2wBEi1LSyA/CscQ0YOq9HqTP64MFshZ2ieMARx
         Ty3g==
X-Gm-Message-State: AOJu0Yy58uxttOtn3B45t08wn4kIH5T1SjcOmrZ2ZxoVmyPHd0xZ0un+
	mHZ5NJCi6uspb5RQE29cEI4BYeXN/PnvSkRvkqQ0uWu/UFS4G3bq3ua9
X-Gm-Gg: ASbGncs0XN8JGez22atoVphC1zia+wbbLXo48eeVGuEjDP0sliXdUjG4t0O7UEmRjyT
	dR2QXKDe9Lfp4csm/mg0wtWl2jeWP2L1JtiLp/toIT2OPCo6CQxG4r8LyF4FSx7F4HMLUZ1YYVA
	xxSMYYTqT4qBpTjTO5yrEE+lWfaOuSid7I8++L6GZzTUuVZRth3vaOr9+CAJiU4cIPgX9ClOEla
	Lln/a5CIWqt74GT4PPHjVkXz/GCiYvxO1j/+xSR6n6FSu6c6xenDDj9tj2HMxOSb3/B9l3Iwr/U
	ozrwVINOoLjG/GfGGqL2MRSbj/0NdIHlkV4G4qXF7T73X5x0v0WhmXq5eGKWsNubf6drhLbg2Ba
	fRvSvnJOZCJoC9JcN86YKnlcSTOSl3uG6uphw9LRoY2tgqYqGBSuhTLqGhvhtxWjiHzK7LX/QJq
	aqc98EvBomfA==
X-Google-Smtp-Source: AGHT+IE7Rok/e6Bxy5xGvZXfSJSFxXVsoe6BHMoirgQtG0/vydXJFaBnBjbfGjbRNlmzOtY86aol5w==
X-Received: by 2002:a17:907:3c90:b0:b76:e89f:98a9 with SMTP id a640c23a62f3a-b7a2484b7c2mr830867566b.61.1765204602180;
        Mon, 08 Dec 2025 06:36:42 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-647b2eda768sm11020665a12.8.2025.12.08.06.36.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Dec 2025 06:36:41 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [RFC Patch  11/11] mm/huge_memory: simplify split_huge_page() by calling __folio_split() directly
Date: Mon,  8 Dec 2025 14:36:16 +0000
Message-Id: <20251208143616.20797-12-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251208143616.20797-1-richard.weiyang@gmail.com>
References: <20251208143616.20797-1-richard.weiyang@gmail.com>
X-Stat-Signature: 5139jo6688xurbtdbcicqfj668kzqb6b
X-Rspamd-Queue-Id: BACC0C0012
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765204603-627891
X-HE-Meta: U2FsdGVkX18/jPUNh244/JAVLKAwLB49i2bp9LMHpTP4kgW9otjsibcHzt9HpUX+jtDT19qP+l+0jIG4+d+tof4FOupUR6f7OxxPgDQI1oQUl4qz2pvl92Gthj8UFWT3gZR3fY/7mDbLkZlt/QjiRMXbUY83bCgMlw/ICfkDTfO/KgNy4Absma7keKVSS1mPynYTcROS+4c8seYieyaQfIPCJQOuAvkR8wNhPeMUBSD/2/WetKeyCJ7u7H/nfVbjCObq2xKG8Oisx4BxGt83jW3ToM3+AYr2bqRkPTtoUB7YgUJxb5cFSPsADR3QY1ZdITRm8Vva1FzTZJiVBwiv45LBGkJif3zUiobbSFOFeu6I1L0Bg1l0xCHiCpKNdvXwvgvQcpDSvCOurdWwJXzLd3MQ2J/gMvRSWh5XEXK+1xnMWzyy2lDdTo1DTBOt0Q5qw8CA771zHo3wezSaBY4YI8PQPFl8YuUepEQHzl9OGHsrzppp6CYMQ4Fyp4KIA5Ha6H40di8EO6E9UvaPWBKb3QKu9MNS9tdLS7ut6Fo8f+re7qeO+wlyX4P9ZcWc7Qi8Q8NNQN5u04vcMnXL39bBFnr4cmNxaj/dZksuAqRm9wPfGXgTaCJBGzBCF8VMBMWpeqalqLz7q9mXJpCR6p5joVT1NP0e4HhTgJBIjGbJ4kwtbC89cqXVGfc+CBLqFhW0rUFirpQKwMnKfkXRZC3nMLnVE8UIIKaUCeGd+n6IF3k+B8t2rVv87tPZICUlbxuPP7KtdVkibn3lIpnGJzq/jwmSKcEkaoeW7hWnMTQ9lRN1+TYMCwsGAKFoly6f1P4XOJUsCP4BAgbcZG3Un+2mgOMwEZaivE9GA63/AuAhfXy1vKP+qXHtB9kYeTHnKfkCOckzWJKFOM0kUNhiEPJDg7F16i7UUYDPbuaCrEcev2mOHSVBpl1j3BcDPJzEQ9m27ueTt9WTfyWZH6Ttqg8
 m7l0LpwV
 y+d8Y1ItOY2EQ8bNPzCrvnrt44pSa4NTkH6l8XaezUIPHSoWpnbd25wE9z7PhbsgzyDn2J0Mu2t+eEnhlqF67y9cCZJGcuc0v43kmvnU2KdbJ20YAzhayHMc5WYKrhIQpoA5UylbnQlORl2EqxSumH1kVAwvPo4hWvXpdaUDSlz5XclDtjvIS1zDOTEWOXaVKej8IKbqU3t54No1WKGZeiXG3CjxY3g7WKAMmXE51lcfNcpxXv65CPgmPwVekYQwzq6IPq6MzQrnwzTxyycqeIQmrZQ8JB1yKkKdezZmcm8kDPGj/Pa1opCGoktaNXnX+PWm//4OppzMLnbjrjX8oe7vwi9HHBiOwafNMHW5w3cXe+alTtm0qfOmcA747Q/yHteStsskV37eWjiDUhwJw0HbbChfIt5EKlcgDY4fsBvpU3DgwBYrXHKponfgb0CFlnEeAGHhwXI2nT3luknXifTbSgs2TkRyWbfB/xB82hzb0H9Tj+HqnZLiETSaDKAqNzbkv6uNIjHWYc8gio3CaZJUihzCSICA91WUa7v1BZiOkc1LFG3qlj22G8CIF/WUTqY4hicnnIs1M0EsRzkAvr1P4z3LbN/qa8VNLQgI9gySp6GrPV1/4kHTU6uGVxv+0C/WB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current function call chain for splitting huge pages is overly
verbose:

split_huge_page() -> split_huge_page_to_list_to_order() ->
__split_huge_page_to_list_to_order() -> __folio_split()

Since __split_huge_page_to_list_to_order() is merely a wrapper for
__folio_split(), and it is only used by
split_huge_page_to_list_to_order() (which is, in turn, only used by
split_huge_page()), the intermediate functions are redundant.

This commit refactors split_huge_page() to call __folio_split()
directly. This removes the unnecessary middle layers
(split_huge_page_to_list_to_order() and
__split_huge_page_to_list_to_order()), simplifying the splitting
interface.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h | 20 +-------------------
 mm/huge_memory.c        |  5 ++---
 2 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 95a68c19e177..a977e032385c 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -369,8 +369,6 @@ enum split_type {
 	SPLIT_TYPE_NON_UNIFORM,
 };
 
-int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-		unsigned int new_order);
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
 unsigned int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
@@ -380,12 +378,6 @@ int folio_split_uniform(struct folio *folio, unsigned int new_order, struct list
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
 
-static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-		unsigned int new_order)
-{
-	return __split_huge_page_to_list_to_order(page, list, new_order);
-}
-
 static inline int split_folio_to_order(struct folio *folio, int new_order)
 {
 	return folio_split_uniform(folio, new_order, NULL);
@@ -412,10 +404,7 @@ static inline int try_folio_split_to_order(struct folio *folio,
 		return split_folio_to_order(folio, new_order);
 	return folio_split(folio, new_order, page, NULL);
 }
-static inline int split_huge_page(struct page *page)
-{
-	return split_huge_page_to_list_to_order(page, NULL, 0);
-}
+int split_huge_page(struct page *page);
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
 #ifdef CONFIG_MEMCG
 void reparent_deferred_split_queue(struct mem_cgroup *memcg);
@@ -614,13 +603,6 @@ can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
 {
 	return false;
 }
-static inline int
-split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-		unsigned int new_order)
-{
-	VM_WARN_ON_ONCE_PAGE(1, page);
-	return -EINVAL;
-}
 static inline int split_huge_page(struct page *page)
 {
 	VM_WARN_ON_ONCE_PAGE(1, page);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index cedecfc1a40c..ded17d0fa695 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4190,12 +4190,11 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	return ret;
 }
 
-int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-				     unsigned int new_order)
+int split_huge_page(struct page *page)
 {
 	struct folio *folio = page_folio(page);
 
-	return __folio_split(folio, new_order, &folio->page, page, list,
+	return __folio_split(folio, 0, &folio->page, page, NULL,
 			     SPLIT_TYPE_UNIFORM);
 }
 
-- 
2.34.1


