Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4102C87FCF
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 04:28:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 830F78E0234; Sat, 16 Aug 2025 00:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E1678E0006; Sat, 16 Aug 2025 00:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71E388E0234; Sat, 16 Aug 2025 00:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 624158E0006
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:28:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F26C82FE2
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:28:53 +0000 (UTC)
X-FDA: 83781340146.01.6BDA8C3
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 38B6240003
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:28:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j7MZVDMb;
	spf=pass (imf07.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755318531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nUdKVXAydBJ9wkHs/z6NzRQghT8Ti2LWocpy6KfUJOo=;
	b=fy8KYojiQs56YQ3c0rWU+2ae/LqCmsDdzhwtutWWwVStKggyGUR/XqGMCIkTjKIrjNB8NN
	Xr3xayMAyvgaih9wG3vfTDXgFVKHRLVfA8cDBqEvH2/vsM5u83ZhENF/1cEHeuPLBkANXZ
	nGCZYk+KywoI9Hv87Vzgjgtcc/oQ0LA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j7MZVDMb;
	spf=pass (imf07.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755318531; a=rsa-sha256;
	cv=none;
	b=OZPGtNOvl9SkOkUNS6UW++jBuWqXy+YxXFMeV3pQ1ChQd11+Fw/b++j8a4/gS3IBj5lY+z
	UCEV0f/adlkBso7wVjF2HJCW1xK9GQjozD7LxriL2DGN5HqykSvBTQc+sl2muZ3X0RQifx
	l0+sLnCwWweja0f8SY/aSelSlMbdBWM=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-76e2eb20a64so2918421b3a.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755318530; x=1755923330; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nUdKVXAydBJ9wkHs/z6NzRQghT8Ti2LWocpy6KfUJOo=;
        b=j7MZVDMbGM/wsaZ6NxCly0gjJD9fRLhtWmpQDkblYnU+2bhehEsnQHx6Cjgk1PHOOH
         YQSFsmgWsy1kSW9HZZaFl2jyI0pXmGAv84W8qT5bxNxBRLkrelqWuhbdLWPK3kAW+71G
         l6gs8RsV91ttqKD4ryqqDFqa7QzTlDT1+k0tESGlZ0mIwPThd0WJ/4W1d4E5ZY1wGIdG
         GrMNPpSF7LzuKLsv2DeImH177WTJ/vE/xHVoJpi+iT8ysFtuUp3rznmgz4BsYggoS0CA
         HGcjhMS2k++sKcrWM3NMRWLASBSY17LtcjJjKnaSMyIF7W5ArurgrqQt3YQW3YuV7pTz
         GH0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755318530; x=1755923330;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nUdKVXAydBJ9wkHs/z6NzRQghT8Ti2LWocpy6KfUJOo=;
        b=sq9p13eufu1XCpDo4tO5sJVYTz5a3n8iKJD+tq7wTQ9ZnIiKGiRc7KPs4BmAok/hYp
         DzGN7GXEp7NZcA7zavNetdn7hxtqLQzKUq+qz1a4PnADaDZ7qqxcrfbKeQQTbJgWBH8G
         v5sqnBrwErjGVTmT38tZBanZK+PcONcDmTXe48RQCmhESwFHf34oKRPjJ+EXHMLcg6Mm
         O7qr80Eo0KFSPcQQEH6nuKkEBfPOSXeil9zl3HP2k4Ya415adUVn68ceF8su8fu3guy2
         RBEbGSRo21FBgIfo94Wn5s9S20pf+ABlmAs55ZWL2p7pdv3cf2rc2gUkaFO7c0gLOQco
         eTPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdFe2fFYisrGNzyjMX834bbn/Hn6elFIAYANOULGXLhR+p6nyFjS4shIS4jJjXFvmPFlcD27JFAQ==@kvack.org
X-Gm-Message-State: AOJu0YytO5oocJ5+8ZiZN3RIPp+35UUiWTmUBlX54EC1eJIs+fhsCDgw
	fGBKgh2wdnj+Cp3+gEaIabNYGyqeqrxWVTeFCLGz0dosO+npH74OSPFt
X-Gm-Gg: ASbGncsBSXryTBz1vvM1Zr+HoWPcQwyrOag4VCkoNqripgebNsdQxDuGBQGGrwlU/pW
	R2aNfu0aSvAow2J/mV96NBF2VWwA7taQUHgjSkIsTqJJ39trLvvALAKDMi6kMB8EuMLs3VrwZP/
	PhwB7v+/X13ekYoyfDDnGi4Q20zZfJ/Wa5mGE89BqcqXwvAwp75X/ngP6tyd3XkFWiIUvf6czec
	rX7ojzQsdBRC7kGRDfeO9CGAUSUVJZrFeUMOYM/oDuM46Z2uUQR8NIMC+iqHZ/OEyoPlXCv+8i1
	zd90l0+/Stt0SpTEhFST7tdriCzQej7B8ZFB1QXgwVijCjQHr9qphDnnbyVVuXGLkkEKHtACFe3
	E2GfjRMt7n3IbheEaiWA7CA6UBV5gIbyKj2mensaaJtQXKN+JUtsAn1Rc322j/5ia
X-Google-Smtp-Source: AGHT+IHFWWtb1KbXVIg+UozThISuavCO9wv+AE+Tap4j/B944QQFysY2kNhergonWcz8XuW9tB67gQ==
X-Received: by 2002:a05:6a21:6da6:b0:220:3870:c61e with SMTP id adf61e73a8af0-240d2d7d678mr7691737637.4.1755318530006;
        Fri, 15 Aug 2025 21:28:50 -0700 (PDT)
Received: from bj-kjy-standalone-gaoxiang17.mioffice.cn ([43.224.245.244])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b472d73a418sm2611958a12.38.2025.08.15.21.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 21:28:49 -0700 (PDT)
From: Xiang Gao <gxxa03070307@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com
Cc: lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	gaoxiang17 <gaoxiang17@xiaomi.com>
Subject: [PATCH] mm/cma: print total and used pages in cma_alloc()
Date: Sat, 16 Aug 2025 12:28:42 +0800
Message-Id: <20250816042842.3959315-1-gxxa03070307@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ru8j8u71xjt6injzqyngifwekjrhgspb
X-Rspam-User: 
X-Rspamd-Queue-Id: 38B6240003
X-Rspamd-Server: rspam05
X-HE-Tag: 1755318531-927981
X-HE-Meta: U2FsdGVkX1/K1QXKiaeGyQ7EYZjJP87HsQZoPelwrMIoNeyQeRUH6gnaUMfMNJ91Mwj4j9XrTV0k3pCrPHpu9E2t/zCloJ68vNNfJ3mdjG9E/oTdiBHmNgwQw5MI50ELpVslVuh+aGAAFW+u9VAoGl/2sePcS/7B039UDfpOMzDVREtsWbFTzY+ETEFNwcrzQC1TrFn9JIVoUlkW62qCIfkpi9gWwkM/RkOcn4STFCyfT8OrAyWyGmL3iaUcLawvOZQAhnmcITj1iJyZnuvOogOuBlW30QkexDM4IbEDRr/T7SYBbMsC/A4ocP5KmbSi01lsk/Qzerr4G3wOeGIUkf4aT7bPbyQU2UxSIKJUlfSWVITk0iTZv06gh+SvkA78U6thd34EFQQF2YF0fVhyoRwNOWV/u3OpDcaEXGNzq0M9wED0iT+UStTDd6+wBXvf4qCXNPc/UhHkhtdmBC9SsRxnsZz6LRC7yxeOsBT5q2TqnAKNjdmkP4HcnMhJu8Jcv7rmYzWhlVKFMjhVEjEkn+eeo5OetyH3aqCosdXhRSgxGyccxXSK0FDvWtTv5Fuk1J8lB8PtfS2KNlX4N2CZpcy+NAsr0gQlyIWVkahiTd2kUysgbIcKW8q0g1tqx6hVpDNIXxYcpRfe2+IFIuheGbV/onaZ28hMoNNOKHaXomjZqgd17bU90KZ8Rl2dpTpzNf+yg7whxrm4JvmF2swJ1ERY/PqNIq3kIF2mi9wBQh5fMn5JyKA9wArhlW72EE9Rvg9Bx0AC1dbWaPOMBDkRe2xxhk0R7iveEORxdqHUtcXHsw1a8WRJcPzC7FOkM29Ue80Uzf+7WL+KLAe3Sfs1hcHCVTtO63vgd5Pt7RywKaxpUsBfL5cQNAUD7WmfF80Qz6BtDUWGr0uT9PGfY5NCLxKQz8su4zOXebvEy8bZFiv5Q8PYX46jegp9Mymzwu7wVZeSuZCQNqDx00DUHD4
 u3dreA7q
 8hAjtHMx8h4RtgB6OYyXHi1PpVf1l07HWL+y2tSdHjD+a2I9Nj7YBiqRa9NQ8Dz7g+phGwQONiDA/OsZBJiCN744tU9BidF+uFmXm7J3sKM74Tks0rIZwFB7ohTscWUlv8uF2NLd9ZqL3L5CiliYJzHqkfWBlpLpQFlpAnbxaIcIrvT4N8eM4zx9nALbHuno2zhzUAeIVJdRcrNBPy455Mq1CZd1a5kzxjhKDevRY7MqeNDd7nTBoHRG6q9LMpWmNt+rdDmLS1E9Az3zFRKCKRIDMz8LHbPdZ8ol2sQSVMoW6D+3baH4Z9Dzy99e8OcuM4R/sMGrHuE7v8DJQrTVwhpLdi9pWe4wa/sjkzmEHFushhpfkuMx6gMESPHLbGZNhADxBkDy3m8xQxeBxuUuK7gIRhdT5F/h8ha+rjhY3U+50VLX0oo7en+lqvkb0exfAhNY4YxvoZSRDSTI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: gaoxiang17 <gaoxiang17@xiaomi.com>

This makes cma info more intuitive during debugging.

before:
[   24.407814] cma: cma_alloc(cma (____ptrval____), name: reserved, count 1, align 0)
[   24.413397] cma: cma_alloc(cma (____ptrval____), name: reserved, count 1, align 0)
[   24.415886] cma: cma_alloc(cma (____ptrval____), name: reserved, count 1, align 0)

after:
[   24.069738] cma: cma_alloc(cma (____ptrval____), name: reserved, total pages: 16384, used pages: 64, request pages: 1, align 0)
[   24.075317] cma: cma_alloc(cma (____ptrval____), name: reserved, total pages: 16384, used pages: 65, request pages: 1, align 0)
[   24.078455] cma: cma_alloc(cma (____ptrval____), name: reserved, total pages: 16384, used pages: 66, request pages: 1, align 0)

Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
---
 mm/cma.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 2ffa4befb99a..46cc98e7f587 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -776,6 +776,17 @@ static void cma_debug_show_areas(struct cma *cma)
 	spin_unlock_irq(&cma->lock);
 }
 
+static unsigned long cma_get_used_pages(struct cma *cma)
+{
+	unsigned long used;
+
+	spin_lock_irq(&cma->lock);
+	used = bitmap_weight(cma->bitmap, (int)cma_bitmap_maxno(cma));
+	spin_unlock_irq(&cma->lock);
+
+	return used << cma->order_per_bit;
+}
+
 static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 				unsigned long count, unsigned int align,
 				struct page **pagep, gfp_t gfp)
@@ -858,8 +869,8 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 	if (!cma || !cma->count)
 		return page;
 
-	pr_debug("%s(cma %p, name: %s, count %lu, align %d)\n", __func__,
-		(void *)cma, cma->name, count, align);
+	pr_debug("%s(cma %p, name: %s, total pages: %lu, used pages: %lu, request pages: %lu, align %d)\n",
+		__func__, (void *)cma, cma->name, cma->count, cma_get_used_pages(cma), count, align);
 
 	if (!count)
 		return page;
-- 
2.34.1


