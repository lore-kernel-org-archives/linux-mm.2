Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39AF7C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 08:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001DB6B0092; Wed, 22 Jul 2026 04:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF5636B0093; Wed, 22 Jul 2026 04:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE5BE6B0095; Wed, 22 Jul 2026 04:58:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B45566B0092
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:58:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4652C120252
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:58:51 +0000 (UTC)
X-FDA: 85015812462.09.810C164
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6A073C0002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:58:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A5v9IMOQ;
	spf=pass (imf10.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784710729;
	b=BeHT4DiGART0edst+P9f9hSbHYHvo5F4KkHwZ6T8McHr+RdvdwSKOSyhqmrC8pLc6hmHML
	SEWkoiKel0UVqCAgohBjvlaE/6nDL1Jv+ni+oJfcPJR0zipdBKDXoYN9Le4aw2shnBL4m5
	PVZO9W84v+hRFkRR1L5VHdNb9uENbZk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A5v9IMOQ;
	spf=pass (imf10.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784710729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NkPKMk7MVapNd2zmqS5l8beGNHYpl4HXQlvHxGO4S+c=;
	b=scsTLryGA8UKen1U7jgTStyUNA3dHNcCI+yY5ryKxoflF088IBjORcFMFbRdr+FJnqyTDI
	4CNFhFaN1DlnqU/Sh7vy5LCQO1IIlCbvvl9yIzIHKl6+Slpwakhux7pZLuy4UdBhKW196b
	44OBVV3TfB9AC0nYm6K8DbZlPq3HXnk=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ce87c7e3bbso137666505ad.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 01:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784710728; x=1785315528; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NkPKMk7MVapNd2zmqS5l8beGNHYpl4HXQlvHxGO4S+c=;
        b=A5v9IMOQf72GNFtJIG5LJ+z9bTVF4A6ZgXLWCxAAzg7e52TITcT+NU4DMockaAAhO+
         l7eOU25vyiWUVbncPV04xk3rhcx1K9kcz116RAzYbElXRd+Usz7/CoSJHrB8A+zmda1U
         HmXvUC9jir3dNEJLlD3FSLntvjeoYUOjskYi/A5C5TEQuy85LyXwLZSId0zOiVEbUW73
         ALWdceyCdbF2Lf9+4dInFNYdRsuWjlCAhVeOOaPGrXYrhdK/5Iso5BQZRk2XNf/2Tmzg
         0zB4mlEU7WTzl8h5GB0flSlm6eb70PaijLzID3xm4ksnwnMbsh8eP2VekuBYPgIXg4C4
         Z0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784710728; x=1785315528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NkPKMk7MVapNd2zmqS5l8beGNHYpl4HXQlvHxGO4S+c=;
        b=GljHX0EHsNUgU7Irl0iz+7t+XeTKXc4vi4PQsAE9B2hO4KcVDaU2n3lqkj2HaYJzR4
         R2SFDB/AyR96hHNR9GjmR//cAHM11w4eBXvlx05wobnK4MIaxzRN/KIMOG/0+FKXh2vH
         h1uyDh/tC+itnnw4N+VKnw5wHGBQGE39gJ81kLvlLD/+g/V+o7iSKsdRvGYJLlTUNifb
         0bD3AH2qv4gtnXB2SRf3PZZoTRifkkBmKFwrtqRzB8RCQOB6WRiiM3Qzf9+5eUgKrofu
         9axQ9koWg+gR4uRv+xPzO3iwSQbCZgvG5iDWGHyO7I3RLz6dYfoJIqsJbcieTnham36v
         JvJg==
X-Forwarded-Encrypted: i=1; AHgh+Rrq9KxW0twuIsZI7ZvERkHw0rGj5pTltrsdntF5YbPX9AKJnn8qfoZgug6VFM5RiMoqqvPmCTVnmA==@kvack.org
X-Gm-Message-State: AOJu0Yxc9E5dcmpnrQupJh0NW5K4Zieyua3r512AP8U77tcuqNCGqsKj
	mr6XMye/UjQKsTttA0aZA3SECXG496OmGjySlwEbaKY1uv5uoJ3MAPsE
X-Gm-Gg: AR+sD10OFpC+J7Bc0uef2pjvh9ihp5vh14M6LKpPZlDBg5tpsnNKY87CtH4slesY61R
	XECdAtnV4wdxRbOHe66r8E/QE5p5z6nM2d5u0uXEDN3jr14ZCcmYaZU7RBqjU1Z0JtQHHeg/cwG
	6qkYo/eHuVVgHCji/uFEbtTiC7ZuIEE8vNHc6Mh0Vkm+3mWIQ3lPWvWK855GV6N962FWucfvj3p
	2OmDZK5JIFs+J1BRNL0B3oXuC9JQRD7PYvIIilvae0B1qn2pPxyDj3lntukiO2NEvbwfghE0jb+
	SOuPIiKQulQp7yeX9Ypnzpx4e7DFZXh3Dph4HWYGICZCGTdrXKUKFA5sEPUE4dcxqCnY279AjlP
	zshvPmGAwwtXymmot5t8IVukZrrQ2u00lKGn7ulIZuMIK5zTEH3eLktqFQEeIPVdzBMSohC/Lnk
	3VPuvGjZZejJUN7R7j9sr3znyB
X-Received: by 2002:a17:902:f786:b0:2ca:caa5:9c04 with SMTP id d9443c01a7336-2cf3495ffccmr251154795ad.23.1784710728213;
        Wed, 22 Jul 2026 01:58:48 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f2e621dsm11137535ad.48.2026.07.22.01.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 01:58:47 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: dev.jain@arm.com
Cc: david@kernel.org,
	akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org,
	Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	leo.yan@arm.com
Subject: Re: [PATCH v7 6/7] mm/vmalloc: map contiguous pages in batches for vmap() if possible
Date: Wed, 22 Jul 2026 16:58:41 +0800
Message-Id: <20260722085841.3047673-1-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAHKocdEeYvdWq2hoot2cbJ1jhKnZbkbayRX841_gdv5gntQ4cw@mail.gmail.com>
References: <CAHKocdEeYvdWq2hoot2cbJ1jhKnZbkbayRX841_gdv5gntQ4cw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6A073C0002
X-Stat-Signature: wthou5ofzsmtizxh4gh4cyqg7mrqp1ce
X-Rspam-User: 
X-HE-Tag: 1784710729-130876
X-HE-Meta: U2FsdGVkX1/JxAjDZEZYBY35bT5aIOtvMhV9rO8VkcXT/FuaKeHThlSOkN+ZVrT9C4JmBxTCHkL11Pe4GGcR/C3qqcapDdFzgEOTkwdkgSvoAkzE8z9U/gsTDYYoMyoVpNUt3b+CA6rdEoz5dq7i/RD0Q9hj7hkl4Qa3GMTPA1+Z3bmNAiqLCYMYvzlaLAAxuvBqt8Bjuql3q8aKMCgQDtsemWS7O+pZBFCwprZ6yEBoAs3hHeMMi25ViNU64gm0k+K22SJ2qLtX/PqjdSXGhoZIex64eyWHFejfy7tvAjEQZvYmyO/jV2c+ulavHtF7d8StbdLK2haaBVkH89vWXym9uu2T9qq/4Np6pRIKv0ncfI88DSU54W2xn5dsG/CSBa/LsOpNrLqoMuoZ7KldejXqwNFO/PigDUsw2oTvV5c7LrIO/a/qXmIEEwYnYoxk9kLnqWwaskTcwbUgoJegGENfsEph6loT3E/pGTjuiV8y9YCo5XmLYHx0kA5dveSE7skItcveHGdGKyct0/lky1m/zY+9GSY1ujgAm9qb5108uFW54azuxv1oACHdep3zZErL296AlcoSNus15a+UYs5F0kldpkRaFDHFUrxgHdmYDmqkEiRJl2swHJ/fdz/3Wj9POvHr4awAbg6q0LjgU00mUCN0HWsJ8j8K3PT6ZrkNo740xRzh9F0BvONP8CbHQaKP6dSS9zg7PGG5U8dA39IApD9+eXhrCOv9K/GMmk2penToAKILMfbzAUHqHfPkTsZr4OPmqQRHzaUyHYTJgflANcNUCBVTN8VXnVIWGl3M3fp0pou8W0yC28NgEIwZvq4j299sc67WKzWzagXeBK9UMi66ZDiMUTxxRu7gEbzqvR1e+uG7lGyflx6zbNLrXE1YxMj6H9LNFHp2SRbICM5E/NKbMi1lThOP8rCI9zTcj9gusOnqPrTsaNc0HiAHWCR0qJf2QRn5KfW9395
 9z1PcPuG
 ktXtOxeNDaXGgwlD/txYLXgpaQUy1WcsTAaOT/sJvKp0i0CYBPnViGq4jGDGIyQ0rdWPJxcvv2FeYTKZZ3z3zjjFj3O+h80mNrFtITKO5rZ71s8UIeJxNF5ITKAjNljmBnJN55Mw6KSqS91jaZ/yHyIwn3aI1dD8tWxnJGRa1EUrqQPXX+5OISZOnuyCwSP2XlXLEZGXXZq2r7t5bLGC7knX40mOMRv9GcVV6pkyQkZYFWM02xtoaFy9u7+az1nf9t4/G35aCUTeyfFY3hPGYuc7ctrmf2BtLU6QWJGGMHOFaYTp9/puac6SlwFiF1ITh3L+5gBAMzcsHn92HnObAtDL+cli8S50pvUk1vfX0/9DpNDBOWuaKGYIGe1XoyZkTphXXZQjdClOfB0uqTm6l/r18qW8J+w/Cw75LhxAuFAZCk8XNd7KZSjGrmF76/rrj48jmQqnSQWsrPPQbjowWi3KLYiS6xVozBMpy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David and Dev,

The updated diff is blow.

Subject: [PATCH] mm/vmalloc: simplify vmap batching helper and limit scan by PFN alignment

Pass the current page pointer directly to the batching helper, and
limit the contiguous scan by PFN alignment before checking for a batch
size. This keeps the helper interface simpler and avoids scanning more
pages than can actually be mapped together.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>

---
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 92f9cd5e9def5..2f7e6128cbd7c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3558,7 +3558,7 @@ static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
 }
 
 static inline int get_vmap_batch_order(struct page **pages,
-		pgprot_t prot, unsigned int max_steps, unsigned int idx)
+		pgprot_t prot, unsigned int nr_pages)
 {
 	unsigned long pfn;
 	unsigned int nr_contig;
@@ -3567,16 +3567,16 @@ static inline int get_vmap_batch_order(struct page **pages,
 	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
 		return 0;
 
-	nr_contig = num_pages_contiguous(&pages[idx], max_steps);
+	/* Limit nr_pages by pfn alignment */
+	pfn = page_to_pfn(*pages);
+	if (pfn > 0)
+		nr_pages = min_t(unsigned int, nr_pages, 1UL << __ffs(pfn));
+
+	nr_contig = num_pages_contiguous(pages, nr_pages);
 	if (nr_contig < 2)
 		return 0;
 
 	order = ilog2(nr_contig);
-	pfn = page_to_pfn(pages[idx]);
-
-	/* Limit order by pfn alignment */
-	if (pfn > 0)
-		order = min_t(int, order, __ffs(pfn));
 
 	if (vm_shift(prot, PAGE_SIZE << order) == PAGE_SHIFT)
 		return 0;
@@ -3587,8 +3587,8 @@ static inline int get_vmap_batch_order(struct page **pages,
 static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages)
 {
-	unsigned int count = (end - addr) >> PAGE_SHIFT;
-	unsigned int prev_shift = 0, idx = 0;
+	const unsigned int nr_pages = (end - addr) >> PAGE_SHIFT;
+	unsigned int prev_shift = 0, batch_start = 0;
 	unsigned long map_addr = addr, batch_end = addr;
 	int err;
 
@@ -3597,26 +3597,26 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
 	if (err)
 		goto out;
 
-	for (unsigned int i = 0; i < count; ) {
+	for (unsigned int i = 0; i < nr_pages; ) {
 		unsigned int shift = PAGE_SHIFT +
-			get_vmap_batch_order(pages, prot, count - i, i);
+			get_vmap_batch_order(pages + i, prot, nr_pages - i);
 
 		if (!i)
 			prev_shift = shift;
 
 		if (shift != prev_shift) {
 			err = vmap_pages_range_noflush_walk(map_addr, batch_end,
-					prot, pages + idx, prev_shift);
+					prot, pages + batch_start, prev_shift);
 			if (err)
 				goto out;
 			prev_shift = shift;
 			map_addr = batch_end;
-			idx = i;
+			batch_start = i;
 		}
 
 		/*
-		 * Once small pages are encountered, the remaining pages
-		 * are likely small as well.
+		 * Once we fail to batch pages, we expect to fail batching
+		 * for all remaining pages, so just give up.
 		 */
 		if (shift == PAGE_SHIFT)
 			break;
@@ -3627,8 +3627,8 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
 
 	/* Remaining */
 	if (map_addr < end)
-		err = vmap_pages_range_noflush_walk(map_addr, end,
-				prot, pages + idx, prev_shift);
+		err = vmap_pages_range_noflush_walk(map_addr, end, prot,
+				pages + batch_start, prev_shift);
 
 out:
 	flush_cache_vmap(addr, end);

