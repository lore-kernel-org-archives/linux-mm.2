Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D2DFF885A
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 08:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F4F06B0005; Sun,  3 May 2026 04:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5C26B008A; Sun,  3 May 2026 04:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BC306B008C; Sun,  3 May 2026 04:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EDB566B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 04:42:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A10DC160708
	for <linux-mm@kvack.org>; Sun,  3 May 2026 08:42:52 +0000 (UTC)
X-FDA: 84725468184.25.D1FA969
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id E718C100007
	for <linux-mm@kvack.org>; Sun,  3 May 2026 08:42:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Y12/bHBy";
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777797771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hZiG0TlZWUpBlwxZVKlF94H+jTltYp2DdK+uiCeUZ2Q=;
	b=yrwc2CKb8qPpNFgJ+sMte4pwDcYBTMgKh5ib4EOGRYGvYSoGtR3QiWubAy70rpmLCOm+HS
	Vy9dp3b9/aH9GRy02BaOoCG9vQgZGomO2QHky+GjUe2XK8T0ZqPY5OBv+v8N4/ts1kdJH2
	luQjFaF9Z1eN7b/ZnI3/k7wta2guOpk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Y12/bHBy";
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777797771; a=rsa-sha256;
	cv=none;
	b=7uXP78x4T28RO5skH0tSNdspnOXOjw2zLrqEtfkyxe3oaiqGh/XQwwFeO86BvvY23HkzNa
	EJnWv1khCnXf4tuXJVtW9g4HLp7RuqHWusWqxSJyClRBcFFTg1wO3fMPBfqW28WA/++OtB
	+U4tpv8pUYEFkdyme0xHNvlzkUiVSHQ=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-36525730172so511866a91.1
        for <linux-mm@kvack.org>; Sun, 03 May 2026 01:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777797770; x=1778402570; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hZiG0TlZWUpBlwxZVKlF94H+jTltYp2DdK+uiCeUZ2Q=;
        b=Y12/bHByydEda9FZ14aAa1JM3dKXD7GqXWkZMPv1Zifmh2BM/mrAzbhSIIdmG9bPKG
         U0S/Ev/TsLCfwTULgdV0DbAiqo3Tg9mDIGNYjLcXuueR2ZiTzI7Lzq88N6SqB1pFuKRX
         K4Wt1ccimQdhII3vH6qMnbCWCIKtx/y6Q3tqnStG1bSNjmfksYuyzNbWELfRPcOsTqc5
         +gj7H3L81fQBODh/8DNY7A/Jh7mZGE/uwfJMfR0qwdwAEGDDnN3+32pgSigOTjxFm/0x
         BZssfA8WQdE3hzBRRdCRvujI+qnsBO9uf6juuyyk0Rfv+lLhDCpBBxABPYNZpuCJe9bS
         rzqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777797770; x=1778402570;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hZiG0TlZWUpBlwxZVKlF94H+jTltYp2DdK+uiCeUZ2Q=;
        b=jc5YXLdv6foXJ79jm6s+446WAP0GSoNCjbFb6E66emvQyeWDzfNEVynqRyWeXYcTey
         V1wpHpPe2VyaLG6NnoXKmyDo6wtAFRc4a9kdp0nks4QOmlD6gdycyUyp7JQOdBvdYfMU
         so+XYCVpa826GEbTO/kl8kyNb3pJbVXejAmJ5zHV2qowqypJ+b/1h1+s+F2506tl1Op7
         wgtaypjPwFhXtOx1oPwVh9mjkbNY+zdrIQdCjvhLWZruGSc4eUJsZZCX5/m7pUTsTXXr
         /n8xb8S3ldE8/gMoesx6z0RxDzMPGrewxiumjLk5GN1ypxzNKQBrvcH4hvMRphlS3jJz
         fspg==
X-Gm-Message-State: AOJu0Ywo5HGve/m1EKTmI7GMGFrU9KFGOoIYqnfk8BdsP0Ji01m6s8AF
	PLRBa3K7Hs7qQXZ/Yi/UPxshCI8ZKdPDb6/PDu0mDD0tfrwf6tfEM/We2Z54Gw==
X-Gm-Gg: AeBDietyeNAD77emZO7s5qMsDC+CBy0U9xiEhxZHFnQn6gB1brTiqpdnO++F6nVgYGV
	s9wEy4D77Zm5fXtOfhKTwIkwQd9gGjVkFx54wf6fB++OIKz8f8sMbB+vou1Htqj+hEN2F6LQQQS
	8adpn17FeXrXb1nn0FzdcNj1T8UEdVasdS/Ye33KgAgcgAggV36pwnfmTIGKloukjoSMuy9iXV/
	O6XpMHNy+12SepvOk0W11oAyZi/5m/0z0Dq2BkHVIg3A415lDUZF7VLqeoFe7R7s0mAW1CKPJN4
	dBMLpzKmX8+prs/sXsLK2PRZR6wxKSNcSu+csYuvBUhswlW5mb9FS+h2G1TQeieqwBd7V82BMSj
	AWaWeH1KOijD/W+OAz+Y2qaR0bdpcH3XC7a8j6VziyxJ4bSbeH1DikWhWsnTNUD6fWphdyMy7xJ
	M24FxI7OTLwY1BjjUdBQLQ9UmZvoyU
X-Received: by 2002:a05:6a20:6a0a:b0:39f:3ca8:a331 with SMTP id adf61e73a8af0-3a7f1b2cf2amr5968319637.16.1777797769581;
        Sun, 03 May 2026 01:42:49 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7ffbba8fefsm6351395a12.7.2026.05.03.01.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 01:42:49 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [PATCH] mm/hugetlb_cma: restrict hugetlb_cma parameter to gigantic-page alignment
Date: Sun,  3 May 2026 17:42:25 +0900
Message-ID: <20260503084225.415980-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fjefgngb4o8438883xg9sdqmr49r3d3a
X-Rspamd-Queue-Id: E718C100007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777797770-474459
X-HE-Meta: U2FsdGVkX1+5L5P5X9YS2zeNBD9UCKRH3/cLzCvprhq4VvnKAqgnUXN4SzfUHZ+atPELl5vipAd+0Z6C36KRpM7DyTLiAxbAsOXZS9IDrtnN+dVvBbrqiyRRc0oYyxRzeKpkNMNZTvdfuByN1qGCiaRxNt9s9kK0ygf5VCTzPaxsLLZLTI8g7Czu1d9SesBDLL+4YC3m9PH5cAhKGswVMfco/jsnhYqgv4qKDxXSDEt0THSZy/R00G6oWNACYQ8rlf9NxP6VVUk2qgUOCZxCMrLcyERMdeb6dDfZACB7z8mYxhBBsT8FaPucWctXQBAeb6E+qCNcd/p/CIQNxY3CU1heDaFAde2HC8bmJ/8zSrynu78AUjVSiS28qJ9Yfh0EKnd6xxRJSMU+t5mlUl7mEpX8aLs32nejd52ZuaeqLDeL3IPLvKfw26ypWiLmg8qU6XWTsb1yEjGpYXmf4hTj5ZxJP5FaF/y6zmiGsYQS5SAk/bKnHFaGXpwzTmXb1ADwpBb8IYDQhbhCMgZ0FcMCwnumIwXtIX3wDCVbID3Xut0EIz1qz22o+i71Ndbx/MOcwhmh2C105rAR5gzbx4ATqdvh6vDHeoXHXS3tddLB/NgOPCiXm4u9xg8ry449wl16PPX5grAbbzrWpnVLc5UNGQV1NOXdmzBXgES5MT0WW+FlxgWndlU+5y84bxX1QTJKGT63k0dTgiKaHTMTKUF8N0FKvgYT2wtLE65eZYZSnzQSD/PdOCI5939SKQi2eu5MvjlKsm6XI6HxxduAJgjmZoAe/Xc53966BrCYyK/ks38fGbU4IKqYaAwknCDZ/VxPT9pL+8BlunNio3CfisEoGsZJSn6+dmi9nijp2ANt8odQizDZr3w2sYvZNh9r7li7W0GFbE6+tq6oQPJYasCyTd1rtchN6REZaAPlUNn8aHBj045ZPad6VRqdjgtkUKjBnrJdtBSxOjizeezu3Ch
 S9JMUuQx
 ntBN5M3ES8pTE2mOgELbVk3/Lxze7Q9a3JuW9YWeltiAHrCu07GUYsQUpBQkl1vcqVLXhDLnQ2G9HWZoBxcFqt4QJGCuvogNbqZagaGmphND6LUPBKkackxkG7sUEacW8BzffKX5+vh0e/eUlA2p+Yut1tN5TLAIkeK1uBZqKwdZDV79njANI15OpjP5OHk457EsIbQrmmvw2jMaJl9N8tG/QKZQcSm27nb26+s0bWNUd4cMLpMfmLnPlaPzBFWWswP0RGCcdQzRQAHx94HhAZJY96W4lu0LrGR9FLdPtNISpZZCyXwSIV6BfkQl4XWJedPHIk8U0bRqJ46+KHKMVNQac8ew/dQ7nNWZfzRAEv+Rh2dSwcoUfp3/vtqRsk/nProCVynqccnZxQAhgZ0Vc+lJfwDUe+DKt9nzzx+QKsZJK+/PafKGk8lJIINafg/Uf9E3ZyY/Hn6Ow4XVIdvKrHJglqbX/Td8dRNys
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Existing hugetlb_cma parameter handling logic rejects sizes smaller than
one gigantic page, but rounds up larger sizes that are not a multiple
of it. The two behaviors are inconsistent and neither is documented.

To remove existing inconsistent and undefined behavior, restrict
hugetlb_cma parameter to only accept multiples of the gigantic page size.

After this restriction, the redundant round_up() in the allocation loop
can be removed.

The new restriction is also documented in kernel-parameters.txt.

Also, including other minor changes for readability improvement with no
functional change.

Suggested-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
QEMU based test result

1) hugetlb_cma=1300M
  a) AS-IS : total 2G reserved
[    0.000000] hugetlb_cma: reserve 1300 MiB, up to 1024 MiB per node
[    0.000000] cma: Reserved 1024 MiB in 1 range
[    0.000000] hugetlb_cma: reserved 1024 MiB on node 0
[    0.000000] cma: Reserved 1024 MiB in 1 range
[    0.000000] hugetlb_cma: reserved 1024 MiB on node 1

  b) TO-BE : rejected
[    0.000000] hugetlb_cma: cma area must be a multiple of 1024 MiB

2) hugetlb_cma=0:1300M,1:1G
  a) AS-IS : 2G reserved on node 0, 1G reserved on node 1
[    0.000000] cma: Reserved 2048 MiB in 1 range
[    0.000000] hugetlb_cma: reserved 2048 MiB on node 0
[    0.000000] cma: Reserved 1024 MiB in 1 range
[    0.000000] hugetlb_cma: reserved 1024 MiB on node 1

  b) TO-BE : 1G reserved on node 1
[    0.000000] hugetlb_cma: cma area of node 0 must be a multiple of 1024 MiB
[    0.000000] cma: Reserved 1024 MiB in 1 range
[    0.000000] hugetlb_cma: reserved 1024 MiB on node 1
---
Hello,

This patch implements a new restriction to hugetlb_cma parameter that
was suggested during the review of the previous patch [1].
Thanks to Muchun for the guidance.

[1] https://lore.kernel.org/all/BFB1F124-B599-4832-A9DA-F4931999BAF9@linux.dev/

Best Regards,
Sang-Heon Jeon
---
 .../admin-guide/kernel-parameters.txt         |  4 +++
 mm/hugetlb_cma.c                              | 35 +++++++++----------
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 4d0f545fb3ec..23be2f64439c 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2100,6 +2100,10 @@ Kernel parameters
 			Format: nn[KMGTPE] or (node format)
 				<node>:nn[KMGTPE][,<node>:nn[KMGTPE]]
 
+			The size must be a multiple of the gigantic page size.
+			When using node format, this applies to each per-node size.
+			Missaligned values are dropped with a warning.
+
 			Reserve a CMA area of given size and allocate gigantic
 			hugepages using the CMA allocator. If enabled, the
 			boot-time allocation of gigantic hugepages is skipped.
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 7693ccefd0c6..39344d6c78d8 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -142,7 +142,7 @@ unsigned int __weak arch_hugetlb_cma_order(void)
 
 void __init hugetlb_cma_reserve(void)
 {
-	unsigned long size, reserved, per_node, order;
+	unsigned long size, reserved, per_node, order, gigantic_page_size;
 	bool node_specific_cma_alloc = false;
 	int nid;
 
@@ -162,37 +162,36 @@ void __init hugetlb_cma_reserve(void)
 	 * breaking this assumption.
 	 */
 	VM_WARN_ON(order <= MAX_PAGE_ORDER);
+	gigantic_page_size = PAGE_SIZE << order;
 
 	hugetlb_bootmem_set_nodes();
 
 	for (nid = 0; nid < MAX_NUMNODES; nid++) {
-		if (hugetlb_cma_size_in_node[nid] == 0)
+		size = hugetlb_cma_size_in_node[nid];
+		if (size == 0)
 			continue;
 
 		if (!node_isset(nid, hugetlb_bootmem_nodes)) {
 			pr_warn("hugetlb_cma: invalid node %d specified\n", nid);
-			hugetlb_cma_size -= hugetlb_cma_size_in_node[nid];
-			hugetlb_cma_size_in_node[nid] = 0;
-			continue;
-		}
-
-		if (hugetlb_cma_size_in_node[nid] < (PAGE_SIZE << order)) {
-			pr_warn("hugetlb_cma: cma area of node %d should be at least %lu MiB\n",
-				nid, (PAGE_SIZE << order) / SZ_1M);
-			hugetlb_cma_size -= hugetlb_cma_size_in_node[nid];
-			hugetlb_cma_size_in_node[nid] = 0;
+		} else if (!IS_ALIGNED(size, gigantic_page_size)) {
+			pr_warn("hugetlb_cma: cma area of node %d must be a multiple of %lu MiB\n",
+				nid, gigantic_page_size / SZ_1M);
 		} else {
 			node_specific_cma_alloc = true;
+			continue;
 		}
+
+		hugetlb_cma_size -= size;
+		hugetlb_cma_size_in_node[nid] = 0;
 	}
 
 	/* Validate the CMA size again in case some invalid nodes specified. */
 	if (!hugetlb_cma_size)
 		return;
 
-	if (hugetlb_cma_size < (PAGE_SIZE << order)) {
-		pr_warn("hugetlb_cma: cma area should be at least %lu MiB\n",
-			(PAGE_SIZE << order) / SZ_1M);
+	if (!IS_ALIGNED(hugetlb_cma_size, gigantic_page_size)) {
+		pr_warn("hugetlb_cma: cma area must be a multiple of %lu MiB\n",
+			gigantic_page_size / SZ_1M);
 		hugetlb_cma_size = 0;
 		return;
 	}
@@ -204,7 +203,7 @@ void __init hugetlb_cma_reserve(void)
 		 */
 		per_node = DIV_ROUND_UP(hugetlb_cma_size,
 					nodes_weight(hugetlb_bootmem_nodes));
-		per_node = round_up(per_node, PAGE_SIZE << order);
+		per_node = round_up(per_node, gigantic_page_size);
 		pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
 			hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
 	}
@@ -223,15 +222,13 @@ void __init hugetlb_cma_reserve(void)
 			size = min(per_node, hugetlb_cma_size - reserved);
 		}
 
-		size = round_up(size, PAGE_SIZE << order);
-
 		snprintf(name, sizeof(name), "hugetlb%d", nid);
 		/*
 		 * Note that 'order per bit' is based on smallest size that
 		 * may be returned to CMA allocator in the case of
 		 * huge page demotion.
 		 */
-		res = cma_declare_contiguous_multi(size, PAGE_SIZE << order,
+		res = cma_declare_contiguous_multi(size, gigantic_page_size,
 					HUGETLB_PAGE_ORDER, name,
 					&hugetlb_cma[nid], nid);
 		if (res) {
-- 
2.43.0


