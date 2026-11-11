Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2050606B45B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=OmCMF7xR
Received: by kanga.kvack.org (Postfix)
	id B8AA36B05BB; Wed, 11 Nov 2026 01:47:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B63CD6B05BC; Wed, 11 Nov 2026 01:47:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C846B05BD; Wed, 11 Nov 2026 01:47:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CBD36B05BB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:47:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 08F1540204
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:32 +0000 (UTC)
X-FDA: 85421907144.15.D272F80
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3504C100006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OmCMF7xR;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379650;
	b=H2E+9dqqmXi/7Ru9DYDBDD+f3CImqm34Z+ZivE9+cAB1yoe9bv8tWBV8jgVH7lVnIZwERV
	bWlfJ1cMgBiD9Ag8AsaZcDvWyZy3DuJmZjIlKkzwNHKkyHcdjc1Kka6A5kImaIEc3lDZ+K
	PrGNC45OUguLLiQN2orAJwkRF2Oa2i0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ir7CRyHEX/3uMqgVqbpHDvK9mkESk561zfXrmyj8v0=;
	b=2YiSQ7KGXEI/lOH0H7SUHiZG0EPUPVF9dJDdQ71Y2d1UYKltsRv987bqWaxSv8t3AyNTKK
	W6fuYdzFHxaYvIJQofMzOme5nCkmpj83YAoBKZ5YViSLg7+SXBLTpYDeewyO2pgjTdz9JO
	j+XxZ4FtpA/hSFkk+Hy2rdYTxNG8Mkk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OmCMF7xR;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ae7626d14aso1499478a91.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794379649; x=1794984449; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1ir7CRyHEX/3uMqgVqbpHDvK9mkESk561zfXrmyj8v0=;
        b=OmCMF7xR1Geq9Rrs5Q6nwDu74DwsUejOZQ0eV+SiCTfHo/lfaLDe9dWHgXvGU62xT/
         j8h5MmkmMyT/ZD9rGRd8M/KCigmHzTOt8066hKizvxPYYr+uzT6068Qj7runYxpyUTSz
         Sv/aYx7KrD+lx4PelgPOqXH9Nw/2DmF9QXXPE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794379649; x=1794984449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1ir7CRyHEX/3uMqgVqbpHDvK9mkESk561zfXrmyj8v0=;
        b=T2EyVkAz1TMetcVAmNm6cMphSXyl1ylXEYlaswoYmo01YYpsUsPBmLZuL0Jtaz8dcH
         Unn9XDOfWP9GmBvmqEqqO7l62tpVoB3xFu4RO1JSxKsuK4Tv0HWc/3wBgNiBHasFFk6a
         99FlqULlMaMztDpYXD5ghDbUM9qHhBHd0Uc0hoczPrYt6mTWsyxXsjE6GVrdrMedQNKj
         IEvLokvV5s+Wf3HYfpjy4SyBW61nQB1QAQ69g3LpjTBlGL/BQGd9TjTAaCFxlB2J0PSp
         iZWglMBNVS+sUpXDSy0uVb+wc8b4RgzfYmJOaccel0ybg4Z5o1m7SoV9dKMqI8kXCF8w
         nJBQ==
X-Forwarded-Encrypted: i=1; AL+hErH5fTZDpJEWd1FTw/+Lj8V/so/Zi1WS1sARqGUaT/7TFc7dcKcCCkxLOJw7SLT12XUquU5KREW7eA==@kvack.org
X-Gm-Message-State: APuU4Z/RJKHwkOyVpIicLiIyEf4jTjei7DkH1Mq+F2xAB2yrfSGmNHam
	pRNFA4S52ogXCQejd+aRstg3Z4tUC9j+WQlNPdd1ZBMBaUh7kRSIgbY7B/C/semyUQ==
X-Gm-Gg: AYBFou25ycTGMfJ0hGf0IL0qzEqn66qGjKFrr/mexjF2L81WSciR7I1HnP4NamY1iAd
	q+zGUHTFldv7WjxTeXk+UkCtCo2/8n2wApGjqzZfiZy6ZV4kECqcqKYju+J+ArOkjsdAACgDpdy
	sn5tVQaCUeb3MQeEWOsnCfGORoK+RebLjYE0OZGZM2Dsb5azNTaSVfi/08v+DDxOLgo13UEQzKB
	gSA+mdIR4SsY1JzWmzNxEC4ewP1rJifWqunj6EX+Ut3HRNs90g+7yVpYeLJ5D6CteJ0NL8VZ6fz
	cFXTfiLlCITnKd0uE/vwNs/uO8gDtvoOVXI4ukIbm0R/UBIxkgsu2V6MlAxg5mWzkrInjpuiwkP
	dajMX5gn2JeHFsoRGnZ2U1RH09iGW6i9OhUeZB2gTKIhTBGYaGcqIA4ep0tOZ9jI6DAh+9uaWpx
	dE2+X0wMwq56fFKEC35TewPQuiUAgyU9F/bXPJouwo5xLM0hiDpFg/YtrNpdmdb78sCEL4OUaf2
	FmNV6NasKGHXRJzwZSoaOP8AMhyy1QIDwdvYszFJQ2G8fO/41wdfFAgI5m4NTwQquDUBWCjgZpd
	J87WJYzosDzQOfvXOiH4BUTxKGC4MYOCAKdHUyIIo6KdcbENrp8K7LhujwTqz+/cV699nZ3PQpD
	vWV3ZYwttNTbCC3MsKQ==
X-Received: by 2002:a17:90b:1344:b0:3ab:e588:c275 with SMTP id 98e67ed59e1d1-3b182ec1ea6mr1487044a91.20.1794379648977;
        Tue, 10 Nov 2026 22:47:28 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db85a9bsm3268666a91.14.2026.11.10.22.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:47:28 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v3 05/11] zram: check mem_limit before allocating zsmalloc object
Date: Wed, 11 Nov 2026 15:46:28 +0900
Message-ID: <20261111064707.2568433-6-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
In-Reply-To: <20261111064707.2568433-1-senozhatsky@chromium.org>
References: <20261111064707.2568433-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3504C100006
X-Rspamd-Server: rspam12
X-Stat-Signature: eakktbnr7643fuuopufm44uik8d9qexa
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794379650-739657
X-HE-Meta: U2FsdGVkX18bOqiNIEFpwJCW5OaS/qn9wtDJt49UWYvtYKG7Iu0LIZMgU5nkeiGOECW/qMAzVy7KqYU17S1iPKYlcTLUHAJIBZzR2k7KQcAsPBFg46m0d0MlexnS8483gkalPO899MErf5lAXs+2HbbT4+28V7PNQ4vqMEIDpEixQZfhrgn+NiiFoqBDfz7QgKmessyCxkW26xpq+pM8eqFPZIXqX6eftPTCUG4Xnrgtmj8ZYLDr+gRLwP7mCXk8lbBj+SUSevsvkqeubPqctbYF53BpR+7bDzSpK5mcsYsgNUx3SHPEEL4aN9tD2YxihqJBbcpmGvyj9lqZdp15qC/N/UHjWI/lqannKIjUDw8TEnJNl3hdzsgsixjbXNB+QYlwAxRDgleUjjl21F0haeyTuq2P9sifQSgFfFneRNIU2e4t8dL9sxEhsn0JbuxsiJVKXTnquZqLDarh/0xEBqgxPgymKJ2kzcMq5hKDpxoMVrxvR0dhpFIJ0D3nPavULbGDEj8EuAnWnK3abDyJY8Bc3iJF+kUAtXLrr+dukT66XBvG7dENmiyzu8+ZPhP+2PbtJWrwIqkuiReEdLqBkMb2HzIoHyPSZawTNyAOR5R/aRt3fXOEh2JbJcSTiKdyk8eyOrz9ayx5LcfnylTD0biY3zzhHH15WlOPr3uIUNghf12KucqARI/i8oPXDdT8QoctPjv1RCu2yuZQaVmu6xm7OFcv4hw4F+DqUlGBIP1GDOBb3J3u1R4s2Ki6pC7WW4jUZhD3Iui+1tP1dmVDur8GQRHok8kTIVK/bpVeu26MQOWm3+07/6F2FsYi1xVqVR93Av1SIb0o9Y1NbNMc/+XJK8F39MN9D50gJg99RhhI8EEzidHkUXhs4mY7j6HQJiQa4BhLI4x/REdm9LZn1lybBQHWATn4xDV+q/b1hVg5v+iAI0PWi2fCs/stR7uXXhLcYEte/q2FRV3ONdR
 yCWbbIJV
 uWf/wjb7/7FkgWHBj+XVOlT8cHuatsQVCyjGfgNtVQtgLeOk8lwEXLcA0falHKUPoHl2SBN8HmEtv4U9lrp3lkXX6IVWN8fyG3OE4pjE0uTj4w8OiQNEvpYwFoqB3B9Takg16nkE/xIOIM0/VmqD1gqvRKQHUaiHDrH9ow7IBsFgpRmkH3B5jeTmrvxkfw3raUagSv76z6ZfUHnxOgDbFp9A2MPLcyKZkTBZRxJmNZ6jLrmiftZyTkDGtxcEHuqrlYGDYcpHFFdsgzJ5NeDRlr5e4sIybGg/tdc31eIE4kud6ri+OgLyPr5XyMQ31QOQZFH9AbZiHVyROy4Pm/4n8iPqadyQEJfE1+sspr6xP1rWw1GIBtPbMCbI8ZRDwnFt2wahC4STh/vyyMXsGJ1NcKi6hA7sn2aalsnF7wqti+N6TQMk7fTyj4NzZn1xu6hvwCY2wrVcwuKq8SiZtjRTpB1ca0YifXrSeYR29P4iYfcTn4/6EyFw2BLOiHVb8jm8eY+4+cOM+RWBywNljq1+kLVoBZitcKNfBL//O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zram_can_store_page() is called after zs_malloc(), so once we reach
mem_limit every write that doesn't fit into a partial zspage allocates
a new zspage only to free it right away.

Check mem_limit in zram_write_page() before compressing the page and
allocating from zsmalloc, and update max_used_pages after zs_malloc()
succeeds.  mem_limit was never a hard limit, the allocation that
crosses it happens before the check anyway, so now we can go over the
limit by up to one zspage per concurrent writer, and writes fail early
until enough slots are freed.

mem_limit can change under us, so read ->limit_pages once.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 Documentation/admin-guide/blockdev/zram.rst |  4 ++-
 drivers/block/zram/zram_drv.c               | 27 +++++++++------------
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/Documentation/admin-guide/blockdev/zram.rst b/Documentation/admin-guide/blockdev/zram.rst
index 148b7cf3b924..db256c53b127 100644
--- a/Documentation/admin-guide/blockdev/zram.rst
+++ b/Documentation/admin-guide/blockdev/zram.rst
@@ -181,7 +181,9 @@ Set memory limit: Optional
 
 Set memory limit by writing the value to sysfs node 'mem_limit'.
 The value can be either in bytes or you can use mem suffixes.
-In addition, you could change the value in runtime.
+In addition, you could change the value in runtime.  The limit is
+checked before zsmalloc allocation, so memory usage may slightly
+exceed it (by up to one zspage per concurrent writer).
 Examples::
 
 	# limit /dev/zram0 with 50MB memory
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 2c2e11b2b663..74e02cf4f53d 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -177,8 +177,9 @@ static void mark_slot_accessed(struct zram *zram, unsigned long index)
 #endif
 }
 
-static inline void update_used_max(struct zram *zram, const unsigned long pages)
+static inline void update_used_max(struct zram *zram)
 {
+	unsigned long pages = zs_get_total_pages(zram->mem_pool);
 	unsigned long cur_max = atomic_long_read(&zram->stats.max_used_pages);
 
 	do {
@@ -190,12 +191,12 @@ static inline void update_used_max(struct zram *zram, const unsigned long pages)
 
 static bool zram_can_store_page(struct zram *zram)
 {
-	unsigned long alloced_pages;
+	unsigned long limit_pages = READ_ONCE(zram->limit_pages);
 
-	alloced_pages = zs_get_total_pages(zram->mem_pool);
-	update_used_max(zram, alloced_pages);
+	if (!limit_pages)
+		return true;
 
-	return !zram->limit_pages || alloced_pages <= zram->limit_pages;
+	return zs_get_total_pages(zram->mem_pool) <= limit_pages;
 }
 
 #if PAGE_SIZE != 4096
@@ -375,7 +376,7 @@ static ssize_t mem_limit_store(struct device *dev,
 		return -EINVAL;
 
 	guard(rwsem_write)(&zram->dev_lock);
-	zram->limit_pages = PAGE_ALIGN(limit) >> PAGE_SHIFT;
+	WRITE_ONCE(zram->limit_pages, PAGE_ALIGN(limit) >> PAGE_SHIFT);
 
 	return len;
 }
@@ -2266,10 +2267,7 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
-	if (!zram_can_store_page(zram)) {
-		zs_free(zram->mem_pool, handle);
-		return -ENOMEM;
-	}
+	update_used_max(zram);
 
 	src = kmap_local_page(page);
 	zs_obj_write(zram->mem_pool, handle, src, PAGE_SIZE);
@@ -2308,6 +2306,9 @@ static int zram_write_page(struct zram *zram, struct page *page,
 	if (same_filled)
 		return write_same_filled_page(zram, element, index);
 
+	if (!zram_can_store_page(zram))
+		return -ENOMEM;
+
 	zstrm = zcomp_cstrm_get(zram->comps[ZRAM_PRIMARY_COMP]);
 	mem = kmap_local_page(page);
 	ret = zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
@@ -2333,11 +2334,7 @@ static int zram_write_page(struct zram *zram, struct page *page,
 		return PTR_ERR(handle);
 	}
 
-	if (!zram_can_store_page(zram)) {
-		zcomp_cstrm_put(zstrm);
-		zs_free(zram->mem_pool, handle);
-		return -ENOMEM;
-	}
+	update_used_max(zram);
 
 	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
 	zcomp_cstrm_put(zstrm);
-- 
2.56.0.542.g3ef89b7020-goog


