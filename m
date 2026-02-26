Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8AB9FCE08C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 19:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A038E6B0207; Thu, 26 Feb 2026 14:29:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96CA26B0208; Thu, 26 Feb 2026 14:29:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787A96B0209; Thu, 26 Feb 2026 14:29:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9ED6B0207
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:29:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0322F1393EA
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:45 +0000 (UTC)
X-FDA: 84487597572.19.2B23296
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1D75D20003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=crlfdpa3;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772134184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xmGkLxxoqKOr20qSUXIJFsIMVgh1ZbOFwoeb0w7HC5g=;
	b=vFhTZH03sR6hh4NjVy4SwE1+UNemjnZn2Ca1/r7pbtRWNpzhUo5wNY5JfO3bUWsR5vNCfC
	Yk3cMF1lP02vpHFdL6dEQniQH6MHBu/RVltH16sbxTgurWojBY7+RJRACUgaNWsc/Ehcdr
	F/2MEHEfcd/jDRVD5vTkfl7NcPHlXjc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772134184; a=rsa-sha256;
	cv=none;
	b=ljhekzNF7rB+kBjDX1CgLmWYQ5uLTcHsV7SiQNlzhbjymH7AJWFIT85NjCH7V/jSgSiA0g
	FmqxR3QPAur+GeVeLonNSRTLzZAqjZYGRWOw4c1CgnXUIP2xiE9eDgPpDl+/b0C1NjB6qk
	JNtjv8dAkLqakJG9mN1ZlPg/Ag3Z4cA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=crlfdpa3;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7d4bc9e48bbso543674a34.2
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772134183; x=1772738983; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xmGkLxxoqKOr20qSUXIJFsIMVgh1ZbOFwoeb0w7HC5g=;
        b=crlfdpa3kfL7uBLXOR3lNXDe7QHk6lsgAhhyVKAR6+fn3TiF+hZC3Mfz5s/NQEkj2O
         RE1jz0pAkWfKZsB84hrdbK0HfI+d7q0EFgw4RmvJAK1aeeCBQe5nuyys4wIk74up4Dkx
         JoQBZCW1V/6wAQvF2qoKhVk5ZmUl7oVe9SFBD+8nUUw0zKXyrIfDVN5zh7D2klo2sy0F
         ev4z4wjvz1N/RCpDsrKC03QtJ93pqCNR2V1VgyPMHcJDZYRmCYRAAtaDQUJ45hYl9C1V
         j7ncB/Mq7wkObYKlt0O/d99yzq7V2KHT6uWTiP0Kt4x7F5HUEJryZFHqAchHPd/tCIQH
         yk6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772134183; x=1772738983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xmGkLxxoqKOr20qSUXIJFsIMVgh1ZbOFwoeb0w7HC5g=;
        b=ZNF2A7SqM+ttlxPlKY15F+YisrOPlfyBFFlRDLAAE040t5Tvn078cJ/xNZLebcA3At
         aDITWlHwr48J3rq09unb5Ow5zI1vRi1JB4sJwWC8Xk6FalEZCh5zv1dC1YQQzZBOxwGf
         bjW5PjpTWlKqEqoIdSOuGznBrFmmC5pjWCyYiqifRZihm5E4ogkdLUOiHfK4vWEGFirq
         sNEla9kdWuVnU7RwDm4Hrde76SZzHZfp54v2xyfubfTjSc30hJc5ljwXPHcaDMWYR2wo
         anzCs5A0q1caRLFiT1gqynL7Irb9p9UxEk4Fq5sLI1NiQZHlo5BVDqhscpvEQTKqZ46I
         cZxQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9vkT+2ONASnRsQHdKlGJ9b+MF2Zz2rpBgRq7nwRnPyBJasYq2fF2ykMBzQHY9HNRlD2Rr70hU3A==@kvack.org
X-Gm-Message-State: AOJu0YxPdynmgcRBUz3eCfMHmJT/HIEQUmK4C52igzkuqXLzeWgZTfWJ
	J6RVvY7kxc0svRJJh3QsgexmD6gW0QdesTj7PYMkr5b4Jt3rzUZBwMXC
X-Gm-Gg: ATEYQzw+vM8bo0A9KmEfpO0LiQgUVApiX/TqurHasB3ujMbnpc9oT9WBIwMn5XlWiJc
	I9xALQ4gdPirPnuHEqXWgnKAiY18E6yt8SvlwnlUkU4evDEhJl2RXjlp/Jgqiug2tUDuvazVi4m
	gBqNHwRhg7JEZNe4nR1yS3CHp0l8Zd3LyC7YXnP9AnK4//C2stzWn32pFKS9YUozqJzNR0iaq0x
	aZJotlmPg3+N8CZ137Ma7hZPlLWU0f1ogrLl1zlmoz1LtGtNAhhISykFqq8T9LtxYx9i5iz4KWC
	gvxVJvPeo6fodO4s75SIl2SwoCByfi5dzsPuUbRzm5rtUA+FOqPPNAfAVe6fvCsKF3zSBJv4hYW
	LqdebDAtILhEPrC7tX0snEno2XvS7rjAHz4U9jDob61iz20WYz37m7OygVwzpBHpywHoajEakME
	geVTbI4emxBbn1FfMpAmwg1ZVZ/xsqsgnA
X-Received: by 2002:a05:6830:25c5:b0:7d1:9df9:c916 with SMTP id 46e09a7af769-7d591bd0ef0mr210396a34.23.1772134183134;
        Thu, 26 Feb 2026 11:29:43 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4e::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d5866541fcsm2414575a34.21.2026.02.26.11.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 11:29:42 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 2/8] mm/zsmalloc: Make all obj_idx unsigned ints
Date: Thu, 26 Feb 2026 11:29:25 -0800
Message-ID: <20260226192936.3190275-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
References: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1D75D20003
X-Stat-Signature: 6q8rpjeyux56kx7xxcebtncja4nbkp1g
X-Rspam-User: 
X-HE-Tag: 1772134183-337912
X-HE-Meta: U2FsdGVkX197wbYTeyfwkfanc13LJh0an9OPDoRdCqgb7t4aobXwZ6opagcTGiivIOIxLTw+nfZ//ZHVr8WK7H+/4BfHeOioLOIIisPZzTreZoUufiaed/rUCC308xvEkAMIukM06G/J0z3mFUC4ZWLj0868c1nDqj0DiwDa2k9A90bVzoYgfi2hH9x7I0RlbAbs6YG2C6A8zCKgyXnev350/QE84Mmcx1PBqg9GWNw2YTiTB5WyrF741h14sGj5zH4foq76c7Te9AUoUrQkXCjaKgZMaUalI+W20Q4gDc+o7iWxKWkqwyKXVnlLhbDngxR0LMmTMaWp8aPFlxBa9ubYXJiZd9IbGbGUoEYr0tIgBT6eCirOdGPnXGs0alSZogdmuGnhgYuzm5tRxJBEQyXn2jT4K/u8WlktT5bfj7LFYVQj+eDon6Y63/XeeTG8gyM0C+62114Qas+peHAsKPCW02FSaNYhFykbsDsTmEP1K+2RaTNBI+KNI5FS9pAvaKFG285yawSlLF1S0Tp+6paKQMg8cRcDytXuLd5Ru7yjLChFFs0PpgTMlEXp2+glngCestwpSIpg8J9v+p5gzFaeC6DZLPkAOTjtfdVtmBvtnvj53MO7tSPmDtUEo5mx+2f+J8/9HKWxpccxGvu/J7ELxi6p2CCjuelby4YtLub+gVYoQ+gejqytvEuk+YOhMNsremKzwAlg522tw8zRZxTtjvw3RcSVmc7STTAMSEckXFyHKEfysrkfreMIz56WVT16P7EUgipZ7bl5CI54ENaH8oX0sQAEfFTvyT8H42NVn1orIYsFK4xxVvTREJHZApRDKSDLjIVs/uNDoQoEXCfvnENY0jWeIWetdgHL8ghhxu2ZqrTfvcdUTWZcRUm7Z+iQYya0IzY5Fhwxvvs0Jall49GiN5N26E9YhGE80PslSKRF7xEqBEaO7aEC0VwKCg5CT+6L0Awt0B8pesg
 EXe/W96I
 SzBQ6rsKOjxZWeFKQRwJ7yPaZUuu478IMTl7L4Ap0nbf7uKj0Eko87fZFBmQmTLVL6CfHG4V6X3eC1slHFlgL9rU9pYFuUaStLZJGPvIwNUimJe4p3ukizkSdDF00Lc+82NhUPLh2N0wEESnef7ZOOgmwmQCc4U0J5NItZXtJAHaiPjUyf49O9KJiJ0pr6PIvykViuithOrjTAUYbM4cxFVKj/WaEvqdm9Xzd3eCQffURzPOvVwWLfFjmJT+5W7iPW7E7JAKtw6JLqZyrIkupbPf6dmzxNJ0aie1RwUSiadCcMo9rfuVFwgUiDeCUjne6RqsKQJKT2aGB0ANbqTVyzzYmTObxO1GCSnm6FmctsWtDMeil0RAfLOl0dpTjOUf+iKCAQCxDx/BAXANbJvH5oSUKCUrAQdzXDzTQXKk6WNkQMh5WRvZ3kAIMjtgvMnBkY52hohzTvy35zlYlJdtu6PISRBImB8AhdMGYGmaMiTrkoOwVMtlnikXyU0RqSgjE6yVCoJE1/hXBOc6KGBBj3lQoO4+oXOd+RIZd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

object indices, which describe the location of an object in a zspage,
cannot be negative. To reflect this most helpers calculate and return
these values as unsigned ints.

Convert find_alloced_obj, the only function that calculates obj_idx as
a signed int, to use an unsigned int as well.

No functional change intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/zsmalloc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 0ca2e94af5ad..7846f31bcc8b 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1491,10 +1491,11 @@ static void zs_obj_copy(struct size_class *class, unsigned long dst,
  * return handle.
  */
 static unsigned long find_alloced_obj(struct size_class *class,
-				      struct zpdesc *zpdesc, int *obj_idx)
+				      struct zpdesc *zpdesc,
+				      unsigned int *obj_idx)
 {
 	unsigned int offset;
-	int index = *obj_idx;
+	unsigned int index = *obj_idx;
 	unsigned long handle = 0;
 	void *addr = kmap_local_zpdesc(zpdesc);
 
@@ -1521,7 +1522,7 @@ static void migrate_zspage(struct zs_pool *pool, struct zspage *src_zspage,
 {
 	unsigned long used_obj, free_obj;
 	unsigned long handle;
-	int obj_idx = 0;
+	unsigned int obj_idx = 0;
 	struct zpdesc *s_zpdesc = get_first_zpdesc(src_zspage);
 	struct size_class *class = pool->size_class[src_zspage->class];
 
-- 
2.47.3


