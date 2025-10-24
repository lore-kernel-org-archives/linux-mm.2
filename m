Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC6ECCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 16:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D5CE8E00D0; Fri, 24 Oct 2025 12:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5600E8E00C9; Fri, 24 Oct 2025 12:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38D828E00D0; Fri, 24 Oct 2025 12:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 298408E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:10:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ECD404964A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:10:15 +0000 (UTC)
X-FDA: 84033494790.21.1BE2069
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2682A1C0017
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:10:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Fu1ACxwr;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761322214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPI1gxitoc4b140sD8ZnWvGi4JoP4wU7snq/qHJbNDE=;
	b=QFOl7KdNJB/zN50roCvUI9d4er3n+7Nit7YCkkr1oHOPLXFxosG4rIW/siynOf5lv6nJmF
	DCGz8uHICjatZSmJNXCghGWevSe6ShdS7wgB6d365qRS76+2rj4k1fxMe1P1EzBv46LVcG
	ekoOVTypTcMj7dyiIdNdfpDkGKl/LCs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761322214; a=rsa-sha256;
	cv=none;
	b=Ntz9RljHrAuvzF82qHNfwS+/iq6f7lU4xpeM6x9yZWqV/Nc6bn4pMITvldlxvpSwW6eM+n
	OG1obs+V0+5u+nEzRm8H7WYZzzvIHzuGPpgvI2L32zzRg8MWFVtxyMkYqWQwa+4IbhPEed
	+8Iq73cnCcdukvxHGwPNJBJu5tC/VXI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Fu1ACxwr;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-71d60157747so21776247b3.0
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761322213; x=1761927013; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kPI1gxitoc4b140sD8ZnWvGi4JoP4wU7snq/qHJbNDE=;
        b=Fu1ACxwrC2MIoWnij5TUfEneUS7V0t6ifOGU1os6J8pZlsqX0+o2r0xYFpgiuMGlxg
         mmlYVwcVeuRAztc2t7VX3WZv46d7bVyviSXzDbySIWoaXn3+CVsGIuB6R9jExs/XQsjA
         M993V6mQBhMWgUdYnPQ3xkbNh5LXELHu8Pbk3zajAJBXg7Kgq+5bWFoqWnDI499M8oFz
         7Q+b3MHD0qcYxQljKhyzSrZqg2YdMbOPLckjo0GzjpcoVir86YHZSScX07OKAusCDieF
         KsAPppyQdFhWMx313f+BAVUBDuuozKcLoyEs0fki6mksopzk7zOt7US5Ja4yJN+hu1wV
         0VLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761322213; x=1761927013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kPI1gxitoc4b140sD8ZnWvGi4JoP4wU7snq/qHJbNDE=;
        b=d4CWPCPQsVyW7lqp9aliSbkj3AEGaQaz+yzp+rbkEnOViSHk2lsSa1XGkS9v3ZuZrl
         riWWRygp1YBIIwYJvOxfte3cDHioP3+fGTdBFy7La0z/zNpXsFqQh/d2EReMZOHR7/7+
         AZppt/plYW/jMAkfSsafWJlp8z9Crs6Dt2knOASclJO3YQfmwHle5lzD/rq9e4cEvy+d
         PnkNntYDvjpFr2OUjzrLOD2cEc34oAfY649QP4dmBjp9rAB1Tjm6c4r96PK8MQqWds5g
         djhsNnMAMWlK/FDMPZpA47rOD6OSIW3hO2djcqy7Zb3eqgxOequ0jOr1UlLpGc160jaM
         q4CA==
X-Forwarded-Encrypted: i=1; AJvYcCUsDnpzO2XvHhgdwFsNnXuDDTr/Ckg6KN0wxVTGbMw/4dT1JRE8vWrBeR9cWmnedoq/T7yXVSD/ug==@kvack.org
X-Gm-Message-State: AOJu0YwfsItsiA0/1mm9uu4Tz2tT3YXBiaQiGd6M/ygQKydIfJpJVQry
	MqmpPIh6sy+j6/7FghW5jm6tFh1zfZLgeLZmOhxkyK6TZnyP+dJTqPTUK1WN6ELBjnE=
X-Gm-Gg: ASbGncv+bZ8if5p93e276XfzBm7ZWsi1l1V9+CEkQ8u/5OrEum3qI1HRrhvePIl0vMq
	gX4h5Zuy35bwRojw5TYd8Z2PkFL9WsAuWnDkjUZ93Zj+kS74XHKtBAAWxLh21TYbtu4jlJzLS4t
	bIIPYSQkCTzs1TLuAZ/Vzol5xvJaGlkFlriSeNCDAIR+SrM1sZITL9dpVbPY7pehs3xQwP/z3Wk
	v3+DY/58lTm9LsXF8oElaL5PZekf2HK7NI0KY2VLs6/zOitSoaJhz/0pf27Le4oY6ep23sNs/hZ
	/2WDrls7QtH9SL1Q/a5mPlJqKO1kmo0IAlmSSmqMTV8mJDz8ez2eSERfAoMHVjA00HA9yAXsozk
	wwFXjdLjBRwCg8i0bJ79UQEttGme/yl2Gm2QkZnWathd4mVCo3lzZR+ko3EsPQSaAKsgaq9+e5f
	qrBfgZYuZxHJ7ARN5wSoguoXb9+NHT4b3KuAdJsOWGNtn6OBrr4zoio2n8L2PtV6O8Sy5u1bv3A
	hj3X/mCRHg0Nc+W6/TtuYbQcIHtBQKmWQ==
X-Google-Smtp-Source: AGHT+IHNLH1g3W3lGanu9RY51vSAbD6c3rZHsTMEnjrgcijU+Yq4oR9AGojuFoR3I5TlxNSrGCNhOw==
X-Received: by 2002:a05:690c:253:b0:781:64f:312c with SMTP id 00721157ae682-7836dd58f3emr189766937b3.58.1761322213053;
        Fri, 24 Oct 2025 09:10:13 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-785cd6edd87sm14099197b3.51.2025.10.24.09.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 09:10:12 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org
Subject: [PATCH v8 8/8] memblock: Unpreserve memory in case of error
Date: Fri, 24 Oct 2025 12:10:02 -0400
Message-ID: <20251024161002.747372-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.1.821.gb6fe4d2222-goog
In-Reply-To: <20251024161002.747372-1-pasha.tatashin@soleen.com>
References: <20251024161002.747372-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: czehf7mizgw91cinh444gibep6jjhthg
X-Rspam-User: 
X-Rspamd-Queue-Id: 2682A1C0017
X-HE-Tag: 1761322213-264856
X-HE-Meta: U2FsdGVkX1/2ghxsYU1cfwXcbJKzCOtTGSYWo0qscHdLmd31c61o5GWRows/KJijY6YNZ0pnABW6WF7v/UNSM7KedktNerEvq6R4x+3nrqZt8XX+rlWo2vVxVpHwiFDYcm0nFKIz8TnauU1qS7pONqqcTwAIyLJJakbKnURQYRgkTspNRd2NhdvltkrNEFH2+m/47lsAd79aRUJSTmIKlJWK2ly2O3PwdYgQC+FZBAUEecJ9zXZvXH7HapYYWL8peEoQom+LhYGHrPEwelHj2vxd23LH8MlGVcVeKja/AFtc2JPYnnkvxNWqB3nsitfjOw29Ig6PFfTwyZqb2Wx0A17rG6yp8FRzEzGXgmo1i+mv4OAfv3NFKTP8E7xpwenAQcFAX8xeVTCQ0Fpp4PRAJHFyPMPGUfSKIwronpwKRkMqzKzY/lhXFy0mx80c5vUibWw/TIT3C+h1iYVFCppXdQmGCxvwgEb859OUu0LmP7IvgbRjqHwaJFieW+CN+QDne3etP8RNIXUQBDRwdyFfpUO/s7jJgHLrPCo/l4yqsZycAnOTIndqbpJ3O24iSU0vFxMBqjNTTbqFSl6mEV1KDYkEEo/M5x+Jvb8tRwVBDquk0ZLd+EX6AhzvAJ2e8yW89lbkrtrlM8X2AI5TU7WH8JzSyYTM9EUMesTEtDuLUz8AFngOKOwbkftmYox3Bwj84USGY15EGIJrzxislKbO3XZt26ZKAQf32waEpGdNDTJDXg4X4iPLCsqr+iYCSxmrvWWlRsRaq3XW+bTft8VQUGIQEYLSgHhDX/Q36IG1igTDwgneJdcK9yv9llA9bLwGPEjAlrhiBM+Ox7yPEraWXIeamOU++JCDMheqJxEbk6Q1k7KRJYEYwI3VmRX9xftehDCH0TRmj5p8bJZbE9mQudf/mpuT0JvtjbATFDtf1eIS1+kn1JWeKLYZdf8t2qXV59+hHK6C5g4iXejIH68
 tH7cYoEO
 +zJzhLAsW9NttY+ZzuHtmHZ5MrdqcwsU54OtDUeJxZAWoQpSCSDt7XfMfIdYfI30hA/O+b62m3bznQtVHjEENa8uRlU6vMuI3HI82apd1WOwY86E1f2nRvJaVP8nsKigA2BbIu25xkvSFmPPhs/zOe9KuaIVhOt5nyyt7OZDaIubqBzOdI/jethS2KU+3A7E7kXFdZt+B68rJH/cGoXSMK1InAUwCKwIY86blg7+22P4tKgHkW7c3CmtstDq7ELhIVuOm2DGTk/deuZV8NqwyPebVSMj1fY4Z8iHCoAuA6HBEBO5tHv/tdbfTwlBm9JiCISjrMBiZKdw1DTFg1P/t4P3Ley+LjNCgjUesjt7lXGEya+BW7dVzjH2dkYcEBvkqCMd1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If there is an error half way through KHO memory preservation, we should
rollback and unpreserve everything that is partially preserved.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Suggested-by: Pratyush Yadav <pratyush@kernel.org>
---
 mm/memblock.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index e3bef9b35d63..5ceaa02af7d6 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2447,6 +2447,7 @@ int reserve_mem_release_by_name(const char *name)
 
 static int __init prepare_kho_fdt(void)
 {
+	bool fdt_folio_preserved = false;
 	int err = 0, i;
 	struct page *fdt_page;
 	void *fdt;
@@ -2462,12 +2463,14 @@ static int __init prepare_kho_fdt(void)
 
 	err |= fdt_begin_node(fdt, "");
 	err |= fdt_property_string(fdt, "compatible", MEMBLOCK_KHO_NODE_COMPATIBLE);
-	for (i = 0; i < reserved_mem_count; i++) {
+	for (i = 0; !err && i < reserved_mem_count; i++) {
 		struct reserve_mem_table *map = &reserved_mem_table[i];
 		struct page *page = phys_to_page(map->start);
 		unsigned int nr_pages = map->size >> PAGE_SHIFT;
 
-		err |= kho_preserve_pages(page, nr_pages);
+		err = kho_preserve_pages(page, nr_pages);
+		if (err)
+			break;
 		err |= fdt_begin_node(fdt, map->name);
 		err |= fdt_property_string(fdt, "compatible", RESERVE_MEM_KHO_NODE_COMPATIBLE);
 		err |= fdt_property(fdt, "start", &map->start, sizeof(map->start));
@@ -2477,12 +2480,27 @@ static int __init prepare_kho_fdt(void)
 	err |= fdt_end_node(fdt);
 	err |= fdt_finish(fdt);
 
-	err |= kho_preserve_folio(page_folio(fdt_page));
-
 	if (!err)
+		err = kho_preserve_folio(page_folio(fdt_page));
+
+	if (!err) {
+		fdt_folio_preserved = true;
 		err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
+	}
 
 	if (err) {
+		int nr_reserve_map_preserved = i;
+
+		for (i = 0; i < nr_reserve_map_preserved; i++) {
+			struct reserve_mem_table *map = &reserved_mem_table[i];
+			struct page *page = phys_to_page(map->start);
+			unsigned int nr_pages = map->size >> PAGE_SHIFT;
+
+			kho_unpreserve_pages(page, nr_pages);
+		}
+		if (fdt_folio_preserved)
+			kho_unpreserve_folio(page_folio(fdt_page));
+
 		pr_err("failed to prepare memblock FDT for KHO: %d\n", err);
 		put_page(fdt_page);
 	}
-- 
2.51.1.821.gb6fe4d2222-goog


