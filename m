Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56762C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A686B0108; Thu, 23 Jul 2026 03:50:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52B086B010A; Thu, 23 Jul 2026 03:50:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32F966B010D; Thu, 23 Jul 2026 03:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6546B0108
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:50:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90AE0A105F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:50:14 +0000 (UTC)
X-FDA: 85019268348.30.9C4E287
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf22.hostedemail.com (Postfix) with ESMTP id D7A66C0005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:50:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JLGIW1lh;
	spf=pass (imf22.hostedemail.com: domain of 3s8dhagcKCCQJYESCASGOOGLE.COMLINUX-MMKVACK.ORG@flex--jyescas.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3s8dhagcKCCQJYESCASGOOGLE.COMLINUX-MMKVACK.ORG@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784793012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41Xn4kxvg4d2m5A/f17AABWitCrv11SosQfQDkutcgo=;
	b=scriWHgjau3+tGyUJ0riZXyopxbLwNlskiGCDL011esy4uz2MJx+i1T6moIRkleuL7buF4
	wyoLNbc/4nqotzYxx3dK1/w0Iv358Ht7VJ43QfhJ22fUpzBe490CIsI8gsneWGCPOzWSWL
	GZGvLP7ervyeE7U9D7iHOaV5y9dhB04=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JLGIW1lh;
	spf=pass (imf22.hostedemail.com: domain of 3s8dhagcKCCQJYESCASGOOGLE.COMLINUX-MMKVACK.ORG@flex--jyescas.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3s8dhagcKCCQJYESCASGOOGLE.COMLINUX-MMKVACK.ORG@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784793012;
	b=NQN9Qnh7ybd+qChgTAF9CYf1SbasiBfqWosWNivKutMRbeF5WFatCRx4I5adM/KCt0BPFR
	xByhykg75AR+my0Qqpc0auOxnp0n1Ly+eH7/+tZJJ4V1PrmrRdWpIwocZ138+vi1nIq78Y
	kDzFfM3cl7pJ06mEVcLtaULyXyJE70g=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb5ea36f969so518068a12.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784793012; x=1785397812; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=41Xn4kxvg4d2m5A/f17AABWitCrv11SosQfQDkutcgo=;
        b=JLGIW1lhb+ZEzU/gbyc+dz2/UEW/SwyCpt1ECHG/n11tKDpdIxvwEXyX/mE44i+g6K
         yoD5EfDF5XN+aWrBjuRALlK7UemUcuXOkDqC5zuE3eieRdkxZYd5V4jiNBcaZIJpBQo7
         XuAeXECD3S9cXameYLbVIm8RfqTU4p3KHWrrwYYdyPJ6sLej794GBDmMFbihQIXqiIOn
         OqMv26C9ip2RVtGElmVHxi9Osw3U4KzH8Wa6HxFA1McKej/kXMaBx1XKpNQPGERcb7k1
         /FwjEdOAhQZdJZgn0xrmzchxrvVjWMpfBeLMfhcFvMnr/PvJw+B3f/soFmfgsudCqUSs
         Lo3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784793012; x=1785397812;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=41Xn4kxvg4d2m5A/f17AABWitCrv11SosQfQDkutcgo=;
        b=UxCT6vACMdQPgyHvNr5RdFbgoGcaztcVBBhwz0trhDbYVEyoOhoZaYftJ6FJx7FyNV
         vYKP1HVMBSE8lhzVDGDLEzyWHRJIq3eOfdlsWBcBtHrWz28XKnhu6oQ6eqkXoXExVY35
         esfPFbFoGN/Gwi8o5OIW/bw7Hmr0V2sVJ7AetEEHyv+IwK/LW7lB3URLBa/QzQljvX1A
         1lzYeh5TdwgSL2V10vFx8YY8LibBuhsPs+hugMSw5H7vpVioGaZQu9mmIPcA+ex6wEPF
         OPRecaXFSvhu9zmDSv7tl3dtxxANIrL5eUi7hRJfSAO9x3l3caomHHvYzawtRrex8Fo0
         YUJw==
X-Forwarded-Encrypted: i=1; AHgh+Rrp1Hawbz51HaQc7RezHhJxTqE4BoMSR9dJGKHKidc6rnEHMiYCj6fOgbbNPntpJiRmH5igj3ABmA==@kvack.org
X-Gm-Message-State: AOJu0Yz09iPbVAb1DEESXuV0ZM1foF6qWQrFmfOXfUiP49JjQpJIooZE
	pMFs0l9+P8OG+d8w8B9XSVY3+eF2ywguowgC+s52zuIAl2oFVhvIwPh5sUuocdPRobRALuZQnVu
	3qKvuPL5HEA==
X-Received: from dldyq11-n2.prod.google.com ([2002:a05:701b:454b:20b0:13b:a1b5:d4c1])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:2d42:b0:3bf:a0e5:99a5
 with SMTP id adf61e73a8af0-3c44b191b26mr2284095637.47.1784793011546; Thu, 23
 Jul 2026 00:50:11 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:47:11 -0700
In-Reply-To: <20260723074854.1013941-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723074854.1013941-8-jyescas@google.com>
Subject: [RFC PATCH 07/16] mm: Define function to create a dir for each
 migrate type
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D7A66C0005
X-Stat-Signature: e93i18efio7mq97aqz1gk43aznem8fp3
X-HE-Tag: 1784793012-97493
X-HE-Meta: U2FsdGVkX1+AyDIT4JpV/93w0nZDfEMfWufu01FDCoqBQzgCpnPviamXMmdAZXbZFlieHtxSnPEol68xvXnLei1DBDehBKO7b5gInzysTdAkKjKBcJW7OrzQSUDaw3fSrmhv10bMG4br5+s5m2sr5TBYjPjDy3CcJpFZDPanVD+AjrMHlksxMd3e9RqfpegVyOKZsiXQ4rgIhYwXISmtF+d0toT0OpgQBnU4jW5WmmiZA4bdvOAd6qVR7UgoS78I5yxGHqXAoMebpfkCahRzE+i7G6A84x1Sq+0vZBI11N2Bg2sGcJbT0G+CokNFtv1X2F5YnFg/t9AGV0HPMorFRzy+NtJW/cUqJzgwDZ/+TpWks+Q+ISvKwBx4Z6qF4NAvM2wBplaL3ii8E/HjETPjpVIT8l0VZ8fFXrV9m71pWK+Sb39I4ujc9YhYeAFHjRHGN1bwWNdj3y6zVD4vuhXCiXspXu9xlDe3QbiWfIAAGY0uX2d81g2OCvf6y9UqEPCu+TmpteEPYiB2yWpyw9O0IUNlzzLj8OXqHAv66ayGCsNlQp9NrTWq/iWszwa4/Ui711yTBcHsa8HxP0YVBgLumBDxDCdVZU/ntxrYxSf3/D0WoWxOwop2J1Em6CYpyEWxWcBmIIS/Jx7j3Ar/jmEbXf1F/ydJNJXS14VxpV5nNSRTXTCv3hWoa+Mx3Bw8kkVdYjUWB/6D+HMdqT6kxM4sYCJ88lpeaYvemURx8/6Hg34kGXljdjpJxbj88lJKfR2/4Ni44X0WaEQG9aWE093tRGgIYiN/abtRkAyNs5eVzg4vnvf7TF9WTmLV+gmFCQzF9bY42oN4Q7YTXy9xGAfkYZ/mB27pIRel3c2qBQ3nPpNkmELGM2Qc8+S7shSUVROOdrU87kWblYORAwNi9Uv8/ZyeACKjJfbL8+3/EDnn0ushIYbWMkiJQyTETY8NSOacG0EgVWOAXoEmPt98m8j
 5aME1ZQd
 dKsgOaEA8OS5xeYZCkWcbtuAKWDIKYYFUNRE6qHmUtqQKthLENdBJ5r2VRebY5xHz1+223BnzxMf67LamsUCdJyUgLvwJgzsCak/Z68d9lzYEnRlfmOaK+WrZuwgpXDQZ2K7npEu3QuMaJrdcyO0mgb0dTDyZm1ykf7MoXc6PYPbHqNzgsFKrWbAYI7cW9wqHpYjR3PSYNZ4Einnrf1358WQXv+gmV2iVxoO+la52PbXswuR4JWbZWqPZVbOvr+Uiop0hTF4SsEJCyiyejO2wVyVYTPAsunRgSOr/3e3AwUcqiCFzJEVP4YzFboIOMxUG/Gg981BZc8Pli6OiUV1wj+6As890x+0kMLqy6Ghr4kqV4nRg5AmDUN2UfA5bVKO29Yj+/kPO+tKY1pGlJcq5crJnpohkAemHWkm+wHscbiym1cNe7MXHvDa/A3jgAVuw/uP2Qh6BQII+rYcsWWITFtT54GT/qymM1rrzLFA11X1q9H+6dWjEyxYLoldcoUDIvBk3uUN0IlO+u7w7mgvgP7nLPxhmioxLyl3qXoA5Fh2ho0QD8BsJtsbQRHRdlykpT/58747WmLhYVCU+Z9IJRn2CJR6+msZkqhSTbcOXDFVy9p5YoeXaow43917f1Qou+3Qw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change creates a directory for each migrate type inside
the order directory.

This function won't create a directory for MIGRATE_ISOLATE due
they can't be allocated using the Buddy Allocator.

Note: The MIGRATE_CMA directory won't be created yet. It will
be supported in the future.

Signed-off-by: Juan Yescas <jyescas@google.com>
---
 mm/page_alloc_hogger.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index de86b8526338..a727c4f48ffb 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -127,6 +127,37 @@ struct page_alloc {
 struct kmem_cache *req_alloc_cache;
 struct kmem_cache *page_alloc_cache;
 
+/**
+ * create_migrate_type_subdirs() - Creates a directory for each migrate type
+ * inside the order directory. Once the migrate type directory is created, it
+ * creates the "nr_allocs" file and the "free" file.
+ */
+static inline int create_migrate_type_subdirs(struct dentry *orderdir,
+					      int node_idx, int zone_idx,
+					      int order)
+{
+	struct dentry *migratedir;
+	char dirname[24];
+
+	for (int mtype = 0; mtype < MIGRATE_TYPES; mtype++) {
+#ifdef CONFIG_CMA
+		if (mtype == MIGRATE_CMA) /* CMA allocs are not supported yet*/
+			continue;
+#endif
+#ifdef CONFIG_MEMORY_ISOLATION
+		if (mtype == MIGRATE_ISOLATE) /* can't allocate from here */
+			continue;
+#endif
+		snprintf(dirname, sizeof(dirname), "migrate-%s",
+			 migratetype_names[mtype]);
+		migratedir = debugfs_create_dir(dirname, orderdir);
+		if (IS_ERR(migratedir))
+			return PTR_ERR(migratedir);
+	}
+
+	return 0;
+}
+
 /**
  * create_page_orders_subdirs() - Creates a directory for each page order inside
  * the zone directory. Once that the page order directory is created, it creates
@@ -138,12 +169,18 @@ static inline int create_page_orders_subdirs(struct dentry *zonedir,
 {
 	struct dentry *orderdir;
 	char dirname[12];
+	int ret;
 
 	for (int order = 0; order < NR_PAGE_ORDERS; order++) {
 		snprintf(dirname, sizeof(dirname), "order-%d", order);
 		orderdir = debugfs_create_dir(dirname, zonedir);
 		if (IS_ERR(orderdir))
 			return PTR_ERR(orderdir);
+
+		ret = create_migrate_type_subdirs(orderdir, node_idx, zone_idx,
+						  order);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
-- 
2.55.0.229.g6434b31f56-goog


