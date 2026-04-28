Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A93E3FF886C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218396B0095; Tue, 28 Apr 2026 04:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF6F6B0096; Tue, 28 Apr 2026 04:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12CD76B0098; Tue, 28 Apr 2026 04:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0527C6B0095
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:52:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BCD791402DF
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:52:41 +0000 (UTC)
X-FDA: 84707348922.20.A9FF01D
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id E52694000A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:52:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=czQ5szsu;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777366360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jiF95cax3V5L6nJjgrGO2oz2uPDfmL3HpmR2wC0cXHA=;
	b=7GLF4Yu/OCINuphHD/GH9Ot//2egcwWJlXV5KGqfMEPoBYpOM/XHlr+5PPZ8zIphYZ9h/l
	g/vwcWoTojzslEyEkT8X9lGGt2umsThSgArsDW2uyI7eJb6Iv3n5tg8HNJef8tlAyEbrTA
	g9KG5tLT88SPhzLsByAyy9mgEzZ3dFM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=czQ5szsu;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777366360; a=rsa-sha256;
	cv=none;
	b=kJ+UU35wHC8OO1DfnsvIgKNlDeDNIntfi1rE+pYjPGiVeHBms5Gwue+el+W4RTWo1EwA0X
	5DwDM0ZnfQfcHkGKmdy4UccqqY0IGcKQxCJTIm3PcNJD2nOivQk4meS+txM+HMaH8lpwWD
	hTrpOJKFHZnyS8SgtZhEFMM98iWlyFg=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-35da2d35eccso7596911a91.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777366358; x=1777971158; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jiF95cax3V5L6nJjgrGO2oz2uPDfmL3HpmR2wC0cXHA=;
        b=czQ5szsuQ48XYV021AOJ5olzyY/fFzkJtdStjQS7GvYucU6jlAtGNnHj4AHwEx2NpS
         7LCLdeaEtjC991yHb10Kew2fpd3S5CG0dXZTxYfvF+QnS1aI0C8YpmMQTiEFwxi9keUc
         YHcScYwHBB2J//i41709ZMAR+5y0uldXVOhen6XoVDu+XP5mqs7ACqU+EDFIQVdpij7c
         AncU+DushFJg7oGIAJqiGYumiUL0O+aNW426PcfnpkAMokVYNKWDGmEtgJxwevMW/NUE
         5lrXAUW2QU05MpRnHJZt57o/75mZbCd76Fa2lS23kCltbp2ShrZ08amWkyLER2P4hCdB
         fXRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777366358; x=1777971158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jiF95cax3V5L6nJjgrGO2oz2uPDfmL3HpmR2wC0cXHA=;
        b=SFGKMvda4XSkOyzHmFmOHq5+Mt0Qr+m1XY9ctFqnzHvWSqufJGH3Grkj0cGXDNXJYp
         2+E3166yseYrCyeJ0KCiFd1D29TSsOwx9FP54AiPhAzyE8CpKZBD5E3B0cw1EVfiDzyG
         elmvfo+Olm8X5ZIwpMSInjAiZb7R2HbFfMtlJf+hlxkfBvZs+wouqeh+3PRb1AaUJNBc
         naAV7MP+kOxJMEPZjdrp8vbGpiKMxRi4ov3pkLPZVbM2OFbI0fJGmoF/0o8fboRz1CZ4
         N6oin79VSOAosKsiww/+DGZ8XC+sVxG/xcKrlE+wj7V1dDEZA24zJ7NRGBxP+KoBO3/b
         F29w==
X-Forwarded-Encrypted: i=1; AFNElJ9Z5P4+XSH/FOD9C3u7eYy+KorjYhDIR77QiikHgPg604CmQDyypDmyMTKd3fnyqPqxK6p2dBUeEQ==@kvack.org
X-Gm-Message-State: AOJu0Yw9gN1tfj+37zU9GhWDoHMxrKJyLmzVsziY1PE1mKvvSRDO9ToQ
	xYHsb3PHDSML1Ky857HW3kRL+Uty1WLr1GDRLm0tEuNFaqOZI0tEoeo9niBs3c1CD6E=
X-Gm-Gg: AeBDiev1pwmzwmVyxSwKkqMaS42iTn9Dml0NMzxRHy1ojN8C3heSvYm7PQnieshTKyX
	ol4AZgAQnFUQ8rN1Qj2+e1U0ytpfqj6DeQznZGkiCmDNVD4TtvuMERIVAbhQlQf8Ioq4Wh9mwj+
	ZjQpdYhyhVe45lJzbHjBUlx1rSqUbrip8ZqqA37+sQLME0HrIhqHGolnaqkOdqBCWfadn/jDwMb
	nwKMoaA6w2IliJV3NOpTFczLYvkgrMLA7CNxpS1UpNzV5gpz5PrxQIgh8mgTOJ6GnZpRLZgPZnX
	64hihoGppStOaCDMhV325wW3nJvQeVfL9DSceGc80kD+pf8VrZjSbDfECH+Uc9CoyBjBOOUryzB
	PzuOcuw8KxpKDqrHh4wdgZozhE5+94pupwHwcD7dlJwOmOqVHBNkOjbWrrouJ2ZHs83aRQXnAum
	tbn2t6QnwzUpIENBdiALxnrEBkJVxYuJP9nN85P+OG2DIS9lqAeX4vlSI=
X-Received: by 2002:a17:90b:554d:b0:35d:a380:6d1a with SMTP id 98e67ed59e1d1-36491f89850mr2386051a91.2.1777366358483;
        Tue, 28 Apr 2026 01:52:38 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364902e7debsm2889080a91.15.2026.04.28.01.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 01:52:38 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org,
	muchun.song@linux.dev
Subject: [PATCH v2 2/3] drivers/base/memory: fix memory block reference leak in poison accounting
Date: Tue, 28 Apr 2026 16:52:18 +0800
Message-Id: <20260428085219.1316047-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260428085219.1316047-1-songmuchun@bytedance.com>
References: <20260428085219.1316047-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ng9gu1z1snydqzspjmwmx6mbxj1t8umz
X-Rspamd-Queue-Id: E52694000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777366359-707840
X-HE-Meta: U2FsdGVkX1/TuiA37vemwNwvORxAkTRyRwQpG8o+AVEYgDIu8gQPKxkfvivubbh154XtaWDimyxkELLSv9Wr6ttxGWNCeKg8diBwkXnsFqYh5U9YaSZXqRpuf5793XbT7Bd6WnN+ts1h1v7ChlalLwtqi2qtDZFKKKdFg21JCIvx2r2wAO0DDoWSpX4Zq73XbP/nU4ermwf20pOhQVQJ0H/8FO87hGTjt2+oPrQRwg876BvadLZzqlDpT3pHm2GiM5xkG1qWG2XxdgM2WpBJrk5/sPTlq4UrjiF/FiSnpTxfDRh7zqk5bSOk8y8z3IaaCt3oX4IvbFGY73mKd8FrNeAJVGQr9+tv0fL3pVkwl6wiB4hBcGtr38QXlTJbDHue/s2r7kqeF4wtKKdqms/1U6L3ozvhtlRg2G3VvxulmSlYtAMTb5m3gsqYAwbYk7bvegfFUHtsDbtxUa+ympLrlffTqrPitR47SixpmmpOz1bI6VnlIqvl2UmSQBN8TIK+OCwbTk1Fjx0YNP0dRXee+zwwoXFf/t1RYKYyKfEhwYsZdCAp8h5nSkpjgzBXxLDxzFvkYkGUMGw/gMrLAQX1y7ZQOXnbQt2yTvLrpDXhT2UyZqThilTPXuZlM0pZt+fqSnP3PhmQfygg9AJIpqFecMaLLFOAXy18rrJI5STkz2kT5XAFbM8Pufnci+WYzoTkkH+kS491x/o5j+XpgON8erhe0Mb4YHw6/Ts+rir31DhPv6r/aHEZbeYiapLvD8agtqrXGUCrxR9sc6aIfk47ZIUd8Dx5d6T3p5HeZnITO3bMo5HqLshnLb4heWWvKvv7KQ5sh8af+y1HkkNgvf498llBFsBKSrcJWLVc1K99ej/iTbwUwd5th3AMq48FqjN/GBkBMYzE0d2o0yS7afvX3jF1eimefE1f1rIXVQxWICvL2X818t11VuKUs9+abmxtXrs0OFfxlf8DaXtu+7u
 BMnlB4tK
 si36tyqiQDz7rqENOfJnMS+S4k0GzVWU/j6YxNHosGnVWyoQd28Q4B4ITsTmuLqFFJp/TPDn/KpYjc/v+3jaHEh/sAddglg237lSgXi+WQGODuJGLHMOXL/4bKqyhPi0XSbT7SrAtzPZRqKB7IWQLm4ebG/E6ZrKtoYVXh7eMYEeNqIwuKJJbq2sEeXNGQrzD3xLLFOaG7VWc6vq8mrdd/tJft4oQnTUqnMnbCaASm7ittljS6QqjDundfBv2qeWDqBFhnQkHtC3kNt/4qaRc+BarImkzw+6nfSVgOTFLzU9okPSDVRfGa27SB6TMrhzor6DljwlJr8zniaW9Hfafuc6usU+/Cgfe8V1TPRhRAYIrUvsgXNPw2Q6pRdO3C1iUIxlG96ptfCNzLUPastYY3CEILwRbs3nL6mP3w4Wd4BTq+64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memblk_nr_poison_inc() and memblk_nr_poison_sub() look up a memory
block via find_memory_block_by_id(), which acquires a reference to the
memory block device.

Both helpers use the returned memory block without dropping that
reference, leaking the device reference on each successful lookup. Drop
the reference after updating nr_hwpoison.

Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison counter")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
---
v1->v2:
- Add Reviewed-by from Miaohe.
- Add device_hotplug_lock in the next patch.
---
 drivers/base/memory.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index f806a683b767..6981b55d582a 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -1230,8 +1230,10 @@ void memblk_nr_poison_inc(unsigned long pfn)
 	const unsigned long block_id = pfn_to_block_id(pfn);
 	struct memory_block *mem = find_memory_block_by_id(block_id);
 
-	if (mem)
+	if (mem) {
 		atomic_long_inc(&mem->nr_hwpoison);
+		put_device(&mem->dev);
+	}
 }
 
 void memblk_nr_poison_sub(unsigned long pfn, long i)
@@ -1239,8 +1241,10 @@ void memblk_nr_poison_sub(unsigned long pfn, long i)
 	const unsigned long block_id = pfn_to_block_id(pfn);
 	struct memory_block *mem = find_memory_block_by_id(block_id);
 
-	if (mem)
+	if (mem) {
 		atomic_long_sub(i, &mem->nr_hwpoison);
+		put_device(&mem->dev);
+	}
 }
 
 static unsigned long memblk_nr_poison(struct memory_block *mem)
-- 
2.20.1


