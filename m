Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DA03CD6E6B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 08:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB1976B0092; Fri,  5 Jun 2026 04:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61D46B0095; Fri,  5 Jun 2026 04:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E906B0092; Fri,  5 Jun 2026 04:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8EE0B6B0092
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 04:43:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6919AA06BD
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:43:22 +0000 (UTC)
X-FDA: 84845219844.22.32B5E9E
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 87358180006
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:43:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BnOIKdBK;
	spf=pass (imf06.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780649000;
	b=U+Jg1eQWDaK4/51pYhVVFf1ITg65piTCreChLkhhT8/2cQFoCw+vmiz+ValJ/KAC6mXtTX
	flCWQ/w0/jIyqO01h4uKqPZg8SBuKYRajbmQngUj15ib967MLJT26ZrHEcU74eg435YhSn
	jpZ5Z7CScp6WYWHc7nIj7Xbb14wiiGM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BnOIKdBK;
	spf=pass (imf06.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780649000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5brAHyiBTWKYNL/XpyaHSOnMQ5/iB4MkIc268tnFsk=;
	b=8JmPo/Qk+Me5WoICkjbMuu+63iytp5G9seqcjE+wUgJQCO/OsPifnrVXZjWk5xdz4oJx2C
	RbTyi/ycNcIhs0VTQzRAiFDuQVZ4N9wIJbxNwE9x2j5rohtpMBhi/YWzH3Hw2tkUPdYzD6
	DsByCS2ZQJ6Rgt7evJLSqLX/l6hBC9I=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-36bba9a1089so1087380a91.3
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 01:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780648999; x=1781253799; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J5brAHyiBTWKYNL/XpyaHSOnMQ5/iB4MkIc268tnFsk=;
        b=BnOIKdBKjlpY7p/pIJ/q5YQmthlR7RNY9FoWFfvsViEi3zlxkDz2f/k5a5W4eeTC3f
         KZgJI9/nQ53je4LoU5oxxuiGgvx+OhmcLDx9WKv1BtVskUaZl8RcftURyKnLOoQCk3hg
         4MKYgrWJHeBM7E5yU6NxXbosFZvcgACBAwo7VVCvShKVjfJ7S8s9cjoPvN2wl+4FTPiQ
         NdLdhhQRZ992eciZpoeSPWtezwS1vN5D+t17Hl3b9pmqz1Y8BaU10XvCm/jgmogp/jx0
         KjjTzN9AY1wLI/mxLmFu0fWkyg7eKuoIYe/K9ajaoPamzxDGcWqXRfWnvDeauJ2Q9BKp
         MBNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780648999; x=1781253799;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J5brAHyiBTWKYNL/XpyaHSOnMQ5/iB4MkIc268tnFsk=;
        b=I2nFFlhTbN3HJJIim/TcuwA/oj4Ir3tW4W/HhKwmOv0PqKMqmlxK3TLTlAhXzgecMp
         SBDdsRm4el8A7m+gAcXRTXm5fKq1bHca8kdUtBbdG1m8HvrpNH3OEOnquJ/0jF/GSD/b
         LUthWwo6ORSFKyqYMazWb2zl1Q9iVwoIK9ScRJ0nGNYCAaGRgULTyM53gbkXsn4NG2Or
         pgndAoFOqg/Ns3kUCRs9RrL/KVejaf/9N8VzpQGodFPvoBs1AviZnItb8PdqairaHG9u
         PqmYgpKxNjj57L0jO4n6RFEaMY+0Y2Yi6DGmcchZFro0Ww44u+DcBehSzeQPlqo18lkK
         LnJw==
X-Forwarded-Encrypted: i=1; AFNElJ+btvfb7DSyhyAtR2L7SJvGmeGHExSJj22pWfIlr6BI5VWjekEi8CqX2fWMdZNwOe6IB0ACLCCLRQ==@kvack.org
X-Gm-Message-State: AOJu0Yx/VPSFXH8ymHuY6ORq/OePGq6IAzglN3Y/cZP8R3lPYlImebMX
	7z93L1abSEvSoHbjm+dnvEuL7J9mf6Z1AhISVMMdQPTFL2cd03aJRnbV
X-Gm-Gg: Acq92OG1kfJNPIGRv/ckNGc1M8VEFP3ThOCTTLRf5fhCR7QVZy8BdiEhqNzKndfNqvs
	MMyDcpJcXdSxyzgyN+Du77Aj4obXwNuK9uOn+4GYRECPxlQhj8LOTw3WlJ9tTwyKjOUfSImurCV
	BorbAQ44QqWkFI+krtC81I6EZoWD5FJBXCAiAjycJuy0W042Ekd3E414Gw6HZKvwZb/QHMRPrdj
	ygHdZ6Ais4IA+ZU7swqRCfN4TSuzrqbRrUPALXxUw8n2g+/7mfuNyX2NOfXPWiUtBxdjcC7BgbS
	CXXPiSphtnu3t+4AHHLjJ84L7TaAy/bp26pVo3I6CKOJd7IzTY0JrOWoG8ZSJmAw2RvO0cxEw6o
	wK0LttvAMgVrlb/+mTtjxQj+I9/aaqOU9ZGEQx3Uf25pp0dOeJHNLKiVixBUXyeoOAVyII7dELq
	ZVpg4IFoCOu4+XD0ITy5S9yCzikwBtgGcti9PU9bCcQ1dmK4FpMQ==
X-Received: by 2002:a17:90b:3a8d:b0:365:a5f6:4a5c with SMTP id 98e67ed59e1d1-370ee5448f4mr2558375a91.1.1780648999316;
        Fri, 05 Jun 2026 01:43:19 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3712fcb2607sm926632a91.0.2026.06.05.01.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 01:43:18 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Barry Song <baohua@kernel.org>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [PATCH v3 4/4] mm/zsmalloc: document free_zspage helper variants
Date: Fri,  5 Jun 2026 16:42:42 +0800
Message-Id: <20260605084242.1549811-5-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260605084242.1549811-1-haowenchao22@gmail.com>
References: <20260605084242.1549811-1-haowenchao22@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 87358180006
X-Rspam-User: 
X-Stat-Signature: jntjawpd3qnouq7riot1cmpxtj3qpxwr
X-HE-Tag: 1780649000-491881
X-HE-Meta: U2FsdGVkX1+DLpztf14gO0hdcBNtx6Z4671Ld6SC17jtn4GTdMVZdQz6bbbsfcZ+IdiUPQv1ICuLONknZy4tFQpxw3dUNM8VqpQxyn0YclKqsMwlLuB5DRrWy2v76KVJGpHSt03tMtdeGsokCBkbhRSXdjoC16QS8vLLTbapKyPsAjLByUKgkf0exjj6+CpZVE91055gjDjH/FCuQEkB1NJhl0b5Cv3Uun2MOK91MkZSJ1IKikjdNgK/dKZ/wLEQXSzMTjyB2F518iCDYE1yZ4jrjE/+mgojgrZ8JOYv0RlqRecMAlOgqB0cHUX/GGIjTIVMshMGUBXXWVCwJllWsIS840fckzr7QexrjYk44zQQbmv7Iff/X0ONYwuVoJHMlqrrYROgzAZVBS7k4V/oJVfvSde2vvquhdM3PGZOTc/CcJUh+obkdta8BBnZmEvNvN1hylu1mO9et+tXJaQms0tXRD7vcp8qB0nVD7c9JvdLVpsqya06QtY4Bn1e0UZBIeii95W3PYOLBeQX/L4VG5KIkTZIgfQHpHxIuaI0HW6IjmH4SWfmHjQzu+4GBejP8vFUVRdK3FblQvuzBc9EIfkbcjHBzcSRFic19oQhBregLd1UwS+KV3lAqnB1B9dvm/pu2Loi51CYZnkaSg7kOqOhl7Rtks8Yn6FivoW3Z4asGe2IGVBnoghVbEI0e+X9mrf3N3bDh0XyxteWwasOMgQirRNbppxdPk8HdXtoVLkA+OIvIl8AitaqLJSMAnPmc4C2wzfKaS0iADMo2vFra0Rh/VKIsKnjtyvDIF1f9bqXVTJtWhvK6bH/7O77Sjbqvhb4XgjVdO/GvgmexqyIbJbfeVGaADk2jLf/J3OFIKISIPwuX0t4De4Wz64GnacN9o1V8xm885vG9QZH2siOOjtB+JsV7F4wrOCmZlxK24vcjXs0LSo+eys/Tfa647ghs7kkIEsMmpy/q3h/nyX
 3XH+080k
 xjbLWPcxpIiWdpwh4BWa8LrtScy/tXwCvop1pWCzG2oIQovxtyJLQlnVr0mendH2WZUKlEuUfsTJM37rfGmsxis7kHH9scCZTkowfxc/4ugzdmR+BKdhMe05Df0pdp5JCD6bHmxXqJUprpGfa/+4EzE5fHXy59p5a/KjL4qvq7hT1yLMCaVLYNZ41OVEXnU4nreNIxGGQlOAu9d5le6HBzxfJbuQDay2RRGF0b2k+AxFioLF19/Dk3J2AnrQt/23crtNwQLvCZxDRoGQAd3fFfLDzlA9KoZDmBpp4tEvFdLDpfe5qPbQMbbGtB9RgGBNDj4dkDG18+M3VLhNemD7uDjE6KlbnuS4brLJJfP12UmfcgMeEbz+kDexhYirrvscgrgnZnWzj/nbrcCz6l4/FhFQi95B/mWWbZ+Sqr/xqrfNYhz6caM6EFvSGhAvJntUpzD0NIOrNSFHDG344A+i7PCam/Jfv5urf7wPP+ikW5jAsopNhoc72NB+Iowgr96tv0h3fKK/3qGS3u+86PjfvQya/t1jU9gMy3nh6iDI3X+6CuLGpyu8GdcSodw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wenchao Hao <haowenchao@xiaomi.com>

After splitting __free_zspage() into a lockless core and a wrapper that
does the class-stat bookkeeping, three similarly-named helpers coexist:
free_zspage / __free_zspage / __free_zspage_lockless.

Add a comment block above them describing what each does and where it
is used, so the names are not easy to confuse.

No functional change.

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 2ecdf79cea03..9f588b63ec0d 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -856,6 +856,21 @@ static int trylock_zspage(struct zspage *zspage)
 	return 0;
 }
 
+/*
+ * Three free helpers, kept apart here:
+ *
+ * __free_zspage_lockless(): bare core; walks zpdescs and returns pages
+ *   to the buddy allocator.  Caller owns all zpdesc locks and has
+ *   removed the zspage from its class list.  Used by zs_free() outside
+ *   class->lock so the buddy-side work does not stall the class.
+ *
+ * __free_zspage(): __free_zspage_lockless() + per-class accounting,
+ *   under class->lock.  Used by async_free_zspage().
+ *
+ * free_zspage(): full wrapper - trylock zpdescs, remove from class
+ *   list, call __free_zspage(); kicks deferred free on contention.
+ *   Used by compaction.
+ */
 static inline void __free_zspage_lockless(struct zs_pool *pool, struct zspage *zspage)
 {
 	struct zpdesc *zpdesc, *next;
-- 
2.34.1


