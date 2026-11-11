Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FB52606A337
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=OThinlnI
Received: by kanga.kvack.org (Postfix)
	id 7B9B96B05B3; Wed, 11 Nov 2026 01:47:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791AB6B05B4; Wed, 11 Nov 2026 01:47:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7BF6B05B5; Wed, 11 Nov 2026 01:47:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4035E6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:47:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B451BC0226
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:20 +0000 (UTC)
X-FDA: 85421906640.24.431A4CF
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id E38E0180003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OThinlnI;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LoLBKM4Sjqa25bXrwKOIU9y0T4xg6/+5J3Td4BlyGMY=;
	b=VydGFV6ROKXfpPOgPwvOFY57lLD+InqlLOzTBPPUNMJlqL6tdbd3T0iiKQo132tIMHueEi
	6US06RY96mYp28bRgkKW0KdrzSmwK9DHNdZSBt0nS0xapD9TK2ucH2IjTMJlPNh5RRAR8H
	xiGgaGmleBesmmPG7OLn8eAm8h+yFAg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379639;
	b=BnNokTDj+Ee2YHPqZJFMAWtbxKMJZcfL4JRqdZbu8Vio35c3kLgdjMp3V3H/jJM3hYVSDk
	PbbNZbGmM7yQykrTMowDY9TH53Wt7ERPuESibuKz7v78fh5ZfY74eTFJ5xwFtb7F4JCmOv
	w639ouNzfYjztA7U9K3LmKwDNefcVUo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OThinlnI;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ac9f49b984so1610121a91.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794379638; x=1794984438; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LoLBKM4Sjqa25bXrwKOIU9y0T4xg6/+5J3Td4BlyGMY=;
        b=OThinlnIJEE2vn51tzEppyF3hhFWI0TZd4wm6eKsVtyynudXwo6E1ZQwMO/Pr9zGVh
         SAVoq0K99Ztk/isvlfrd+DdItyQZUThILrFcrEB77pP+gJVh6IUYJa2P4eZFOYLd+NDF
         7pkzF0EY8TKmR6cOJVA/SKfaEQWPKWLiix1b4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794379638; x=1794984438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LoLBKM4Sjqa25bXrwKOIU9y0T4xg6/+5J3Td4BlyGMY=;
        b=vy8aftq9JN4DkBe4Ns8sa43sePCAf6KI+wZWIZrF3e8uBwkRbLBFLGsBvZmiQxsdse
         PRCxcpXh4cXE30xb+TVcjzSDdf1IHCr17+vgNfzGstrk0AtTER/YW212RXStRwq31+Ac
         A2FdZbvg/sqrGI+UZWC/X203eciQDeSGC+5/2ATUXDcJJxhyaByoHyqk5r2itxIhpTF7
         JtZEebZGTKVFaAQQR/UeXml8o05rA1k2vmQg/mZotJYHm/nONxAJOkVdxcIdeOgw4EWh
         cLXueu0lvo5rL69IvhpETMWSBRP18ZzDBbAmjjHMlrNa1U4AV8B/L1xx/jXrq3fnxeVX
         zzVg==
X-Forwarded-Encrypted: i=1; AL+hErE4vAHa7UMy8kVp+9ye6vhjYKakifqt3T7hcYGD/f5gymBakJ+QYhJo9MzJbdCwrsN8tPnr+ARTcw==@kvack.org
X-Gm-Message-State: APuU4Z8gyd3YShfsQqWXTVgR0X1EaxHVeoOzFbXs3yPabWGs0f1eNtrJ
	9PJ1XGymmMnEWQBgStFRH+x6RCzL3uE8TWkLAnt8aYlV51PGH7RbpVKVXXlg18Ox96rNmcmIAbp
	n6z4=
X-Gm-Gg: AYBFou3kp9URzkKxrO3q3JRSgX/3Ay5E5Ud/1tDCRA1qRpLyhKne7YLfXo0gK6WCVsr
	WzRM0ADn20HthV4SKixTr2xNSLFVrpJguObHX8TcVyh9JeFUDx5V7nV4Yt32J4uMxMxXoJFOp9S
	sXdHT7zTo+1qpx/t/EcFRtD9pwS9h9ruvoFuvqIc/KUzboRmLVlBD9PfAr3lPGmwUOqc4GxGQps
	TjrPTRask2HTrmzvBQ+i7V0NPpRie2LBi1ozIcSJHl/DG+4EAHgyDsBAQ7mzlPotuZ+3I0pEtzB
	DpgDyxT0j6EfngJTB7o/B600+l4eNwiOwfgYDNBDAtSjXuTHGRmpR2zo0BqJV8TD5uq6L+hqLq2
	lr0JuuTs6yDGXCnHRiqxKPC+ZinuQMcXJz+ejPIgDYKb6H4OB6U9x6uf79WL46k1mSDXe4i7nq9
	aIK/8H5idvgAvDJm+5Ah3wr+4RmC8VJiQvCJHErkoVjfPXnqyguUeQDGBxuehSKJnAAfqRGd7r4
	/qBXuHyHHEJUMgHKcIKxFy7FTEH300qVjv7g3lVIOMHlHeIaYy6r+Hdh8tR/X6gdqVaotjt2NWC
	IifXqPnZIyIECMMKtICcv9VLbKNduc3uHT8Hdsp1R2ein9iqbJAQl+vF+lstDSn3vBmbfCOVEIY
	yFRBnaGhEeSOuXpPv4e03/Pfycv4ppi+OBJ7m4G8=
X-Received: by 2002:a17:90b:3c06:b0:3b0:a413:dd8e with SMTP id 98e67ed59e1d1-3b182fd6335mr947201a91.43.1794379637677;
        Tue, 10 Nov 2026 22:47:17 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db85a9bsm3268666a91.14.2026.11.10.22.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:47:17 -0800 (PST)
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
Subject: [PATCH v3 01/11] zram: drop stale comment in write_incompressible_page()
Date: Wed, 11 Nov 2026 15:46:24 +0900
Message-ID: <20261111064707.2568433-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
In-Reply-To: <20261111064707.2568433-1-senozhatsky@chromium.org>
References: <20261111064707.2568433-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iyfnex65sdedhri6gdnbsy3x3yxk3jhz
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E38E0180003
X-HE-Tag: 1794379638-54150
X-HE-Meta: U2FsdGVkX18jpKQNlzGkS5BvZdHpjtNzwDxARTsmlyW4cTuy5bUfLq9a58+XzcK9vND0tIbR7vPUnHLjBUtgt61Guavmo1gsk4aIx2y9bz72t6deeOD/psU4INhfjhzZB9BQ7x4XkOn2TMUcnPDMc/pb+XoLqEBKRgB1YbFIIJJ7tSsLznOO8/daAnwP4InI9zweb/X97W1OdcLjMLodqDuyg+uKL+VGbxz+jYM3ra4FMx13kEZ/Qb7F2IXPptT5UFO3JgGXIPaFzjclTrHaoWfM8/ECoxW4SrBjl4m2IQttoDk9IqmznbdQ+UhiBrCtvp5xNs1mjJCFVUGbSgKOcpCjeilFv1ZK1hfwKE2ahXiOq4yQJy20SriTlrQe8iXl5mstCX0ZTS/HJKIAZ6VmaF6/zHKiPV5XxXDCh8dmKKU4xqpaYxFJG8Q4zysb3bPy7NsLTl0Trubb5H7NvSFkAvQeBJNe21S4mKxNgUGhZEFIIs+2c6kDT+4+96Mvysl4c49WfKPAXiTmWSsOU2IPMEFMMMDT6WOkohlBKEqNfro4yC17zb44FWys+2OEVxeQFdAhjTDGuStDTeiFez6MuJ2weC66PIn5PFjwudwnuth4fpTloKI/VrMKYdyfYpfniF8pB9OkRCT6270lrxZUgc1x9R35uU+53xVSG0XSySGjX2k1HUmg6ALReoRx6OmiFlAheHAvS6P7TcFBXN1jmEusiSnDxOtztKopUfJNgk52rb2ooM7W8G36V0FOL7G0Ixf5rPZP+UG3fwHa7wYUPgDdXGiQusxvd1Mf/vQwMPl2LQ8O6c1Vrxc2P+2T+GDGQluUXDHqBuKOjpJizvXJsOQXwQw+hEB1VWTDEb10+sx6KitVXLRvZOkpEU8s9+KUBXlM0mJOu58eStMN3m1kHxSBq1gWWBGctYI/uTlUhw5JXYyTR0LjzaoH6FDfjx9vymuubJnGmsZBrUTpnl6
 PadXSHbE
 j1mbRnFtD4IV9Xu83ybG8UXipdNO8IhvmZti+2ttbl6O1wLEld7TNYztQTsyRafoeJ/v+Ogt6w5G9O/ZIt/y9h/HqOCnKX51pTB94yZuD8E7ogPfEtEnLhYFu1jEfyqrCGmWjnY4jvY/3V3dt+DT6kh0YBg24qLO9MxV7n9u1JxhOweIOTSgfvol5BH6Wasq0yEymgElu4NSfIROusmF3qNk0CRWLj5auACIIYRxGbXVBvO4EC/T7PPmcMJWcb4tSq7kpVg3uSPbnRKQC0MlkXLC/yaCQgFrd8RaJ/Ao+HPCbiJswMc1b4yeat3qCYnJhlkdWhRkh/L+AsvUbSvA51RYhK1B089KGjcihIGRk8Dzxae0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zram doesn't do fast/slow-path handle allocation anymore, so
the comment in write_incompressible_page() is stale.  Drop it.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 632045b65bdb..380615b73446 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2271,11 +2271,6 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	unsigned long handle;
 	void *src;
 
-	/*
-	 * This function is called from preemptible context so we don't need
-	 * to do optimistic and fallback to pessimistic handle allocation,
-	 * like we do for compressible pages.
-	 */
 	handle = zs_malloc(zram->mem_pool, PAGE_SIZE,
 			   GFP_NOIO | __GFP_NOWARN |
 			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
-- 
2.56.0.542.g3ef89b7020-goog


