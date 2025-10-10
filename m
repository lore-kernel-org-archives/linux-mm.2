Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2C01CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 14:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 057328E0016; Fri, 10 Oct 2025 10:11:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007568E0003; Fri, 10 Oct 2025 10:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E862B8E0016; Fri, 10 Oct 2025 10:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D74258E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 10:11:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 09BB48556A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:11:49 +0000 (UTC)
X-FDA: 83982393138.22.31D643D
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4C7A94001F
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:11:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hB6GjnKx;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760105507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=yoCdzFP8oz43i2FEtCm56ukUtPbOdjgazLGvmbVXoUI=;
	b=0eT24SsFbObWj56DagiA2LssDE4biPyIMSbe+9JNtDgaicjYiNqb0pWnnSqhNIpZY/nE0L
	jHn6CY/6cfWficbV/WURSdygTxfUIiX9ZlbmVc0auiBCJbAxNVcRyOlXVRKU4uLPAMu56Z
	mJG6+kEbl19UmaRS6xTnuEyBiYIxwI4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760105507; a=rsa-sha256;
	cv=none;
	b=7ykKpUWuqxJETbivsSqKIe7zJYR2sh9OsjMVQeyx3gZTq8bJawOoJuBwm96eTRIYfy5Aix
	q3TYtbtia20bsCM56rATP1z19I8dtuohVQIIsrixyxg0MwBx6anHleKAOcLZX+OAY2Ks3P
	D3aUZFxt+cocCpm0Lrqzn4Dn0uz4wKQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hB6GjnKx;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b3b3a6f4dd4so395758666b.0
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 07:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760105506; x=1760710306; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yoCdzFP8oz43i2FEtCm56ukUtPbOdjgazLGvmbVXoUI=;
        b=hB6GjnKxXk6+h0D0K0/iXQMlO8LLMGmIRoMwtPQz6rVXNMWa5j2fE0vUBVeU5CECz8
         e1LpSKuy1ly1rZ2QvZiNdnzYtuEAQqZK+vlOaD5km/ZW8zduLzSBNpUeXJ2mqbQO8kMR
         yyuW3MKnLl7ZQrRuCpdpg/do9fJ6yDZJj3SN592Iny8jVVAHujTO5SYS8IhfRf12IfYj
         w3e3TcWHumpSm1nb/EDTdPu05wSwb3875iOq5NsgtYtDzDGcaoo6uede35X6EU4LiDFr
         6zNZp9XnJFj4hN7f3nN37IrC7p+RKVa+YwY+/Hir6MlubtJgcTMrP027Mnq+BgMLkQR7
         QorA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760105506; x=1760710306;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yoCdzFP8oz43i2FEtCm56ukUtPbOdjgazLGvmbVXoUI=;
        b=E9f68p85LB4MbGk89rmBSbjZCcoedJPbbLOc2zX34zwPAVwDb4MIZ4U9HzIT5Kq102
         SGRquxkd8k1ktHAjmwdqUfYGNpAzM43uI5DWwz1lz3KQmXRUDhB0qQuZOoxND9TSuUhY
         NzZclIpUDyNAX7+HSMzdFtD4WsuViVus8/aLkq8A2U4pKjvrRfIryRUd1MoGQ+PK2sjP
         nMvCYKCsU+05GLpcVf2/EgC6UEca6r5SOa3jv0y+oNYw0aIGBvnRm93yCsCPQzIsqeTd
         sw6fWaMa4JWMqWOjqQqDFJi0KDB+Ar8oKfnATcwvF9B3SjsS+jjM8Gftxl6G7DhIZAJ7
         bM8w==
X-Gm-Message-State: AOJu0YwvNUrM7LQeSZp+NNsEkzryFYJZJq3O0kLRnjFXi20ufEaGeRuR
	GMkzUbzG/f7IlkEWPS81xKN6D2HGs+tDwm+pNwrgBDelHL/jhRKgi1Fy
X-Gm-Gg: ASbGncs7wupUiYhxUaX5l2yqjqs+n+1stMX6mepYhQOWdq4QFl2ciliYi9xEU2/L/pr
	ij/i5flzgPowprAOBVJimDjJmeAlh6t1jLH3Ok7VlBleWdrCtFCM1avZkCJwH4H8PKOW5ml6kgm
	1QUUBRJMW8Y16OF3uXqKsI/N3ri7V5nPwRPWlLdasX25ktqXziS0yGqR5Q5AXGkEQ3b8+pwcWZ6
	1l1K6jVO4/sAR836n/AxkZo+vlSZY2emZ2ZLlXdDzrQfqzX6r3T8oNETOsffExvVoguNtK7xtL9
	2HaPmaTZq3N9yft+K2XhDZnhaTahXr+BsLSiyo+WFZuW5rsV0sowAY4gMUomO0aGLOHnq8OIscV
	ebkdEOvvJqIYl2YJpl9bSvZCpBTFBo+nD+iCik23wOGhDKKMHDcQ=
X-Google-Smtp-Source: AGHT+IEldcIZGfHk6Al714z2f3Txb69PY8B1hQiHBv8bBUdrZAff4Nir0Y6OwM1vLq6hFLasBiaCBw==
X-Received: by 2002:a17:907:94d2:b0:afe:7b8c:a583 with SMTP id a640c23a62f3a-b50aa48cbb6mr1283795366b.13.1760105505522;
        Fri, 10 Oct 2025 07:11:45 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d67d2ce9sm241527466b.35.2025.10.10.07.11.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 Oct 2025 07:11:45 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH] mm/huge_memory: only get folio_order() once during __folio_split()
Date: Fri, 10 Oct 2025 14:11:42 +0000
Message-Id: <20251010141142.1349-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam05
X-Stat-Signature: e17ezji58uss9zggqk1wdpfj6si4cowx
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C7A94001F
X-HE-Tag: 1760105507-315855
X-HE-Meta: U2FsdGVkX1+/RwUsLZbGp/6O07HuZs7iCMHHGfYNLbz4wl8/2AaFNJkg9B/yBsFY+ZlAlWNJb7VY7vxvlvVfK4XrPYbdswKCMcU4OD2NrmJM4L6AMa+9gFyFULKB/JRnTzrhIHPK2+5gdFIhKxb29zWctLhEv4Ea4JJIXm0zv0/uKcPz9ZLaPd3qJ+yC5uQ0agkv+nGgwBB++aFsyZ0G3kFMejRbQXSWoVRGzeYnhZ69XFe1Xhz/iQKujXOe+2JmuJY9Mlg19Is6D8BVrAeCvVyfAGh3JARcjz2wnl4Foas3xQfMmfpwYwl1kSNNYnkqEzQVxmA+lGoQ+zGBao1MKwwhBqSxOda6x86RhjfRAFOaoKiTrYE2o9SPfkO+RtNBVTOD5C6C0+Ziuz0Q7q3W1aefsqQU9XO/0lZkmcogZE7wbYHzcS82pM4U3BnIIVbrdvcX8fdgmlG1sQKYEnCrLieUJ9Z0I/LigKmzljzPffU8BQHECyxm7G8HMEfLqTH6nT/leUjL8ylzbUboaywOAXtFaINVOhv/AAYe+dEbdteHs8MXZpfUn4r/nTUzjux3JilobFGrC6fxFgHnzo8+9/1AgQkwO+bPf6elHUq2460Y4KEEy/XdaE078dF/J9MEmPqQzPxkHdPn3KHqAcb+zwFMPncmclDUOs7owry4UJGhp7sP7kTo+gbxajU6wEptaVqxqOfoLjuEDJ10DfrEh+YnBSJa6bvd1HexZQIgUYR7pjzbqqP3Ttk8cnMtk/0mc7rzuti7zNjUj+RCRyTlb4i5b00xmrl2cEZ0DuyN56/pHnutI9DFhPNP1uwAq0AWI/NkOTWSaA5R57v4fCTXjxtX8jvhuyNbrKnwtukLfoRqPXyhP4prGEJqYffCQyJjHEJrmoWc4QoWsfIohboqv9kRAkATh6+Ab6ihUvFqfbVoOnETnsOOm31FyWm+DBJSV3W45uULDuYZTP+8ohq
 +e/iAnNc
 0EMmUs6zaYqMkUBZDxJa31vnkYjolahespIwOHyYOOyxZQsG6DOgHUUgjDnxypguWIxeo8OHm1O71YRfZvFCFZGdxqN/HFOSVxZYsPLsnKwk1PgvKACVs90C4twIEKQPC+HhKM7WDFVwQA91gbiLMnCHWa8MN4jpaCjS14arp6Y4aInVyTOw6yoQ9ZWPbTGImrPnt7Ta/tYUMZDHuX241Y7qlGkM3J5Eiv7K5lPgm+ldww5y4CqRC3I94icCJPEZuw0wrK7jTklbatPjtLLyjIv1WKsgV7ie15rrzT5ZzMimhRDp3erDeB9jiHHdh6BxHCOafNBXfSDG+wJv8ovK4By9YvnvtpJXXeSXv5B9FAXPDzu81gCnd4XKck4glj5tD9MHOHoScqf8R6K+yP0mcCB5bkM7RWfOd5yhQLelgUkRtO95f1yS/JLipTyFVcTAXYtCSi+kv1dwhss4OZGQadL89BzkV/+CxjgeOdjfyRXukwaJ9pdevKbiHjWCv7LnKdX1mm2rOWHSl4I5ckSHy8paX2zI2KYBk53a3TQndjyI9LWyKw4ryYZpZpZXJFBOKaIa0MMXSgymXq2QJROJ4Yeh45SulPNpXakbkMpJCvI+jq/5Q0Zot080Ekk+RmlE6tO1j62bhi7WV2gLsJ584D9AfSLpuUxb+IsoRc5EhlAeArL8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before splitting folio, its order keeps the same.

It is only necessary to get folio_order() once.

Also rename order to old_order to represent the original folio order.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>
---
 mm/huge_memory.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 960fe50f2d89..9454fb7d635e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3786,7 +3786,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	bool is_anon = folio_test_anon(folio);
 	struct address_space *mapping = NULL;
 	struct anon_vma *anon_vma = NULL;
-	int order = folio_order(folio);
+	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
 	int remap_flags = 0;
@@ -3800,7 +3800,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
 		return -EINVAL;
 
-	if (new_order >= folio_order(folio))
+	if (new_order >= old_order)
 		return -EINVAL;
 
 	if (uniform_split && !uniform_split_supported(folio, new_order, true))
@@ -3871,7 +3871,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 		if (uniform_split) {
 			xas_set_order(&xas, folio->index, new_order);
-			xas_split_alloc(&xas, folio, folio_order(folio), gfp);
+			xas_split_alloc(&xas, folio, old_order, gfp);
 			if (xas_error(&xas)) {
 				ret = xas_error(&xas);
 				goto out;
@@ -3926,7 +3926,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct lruvec *lruvec;
 		int expected_refs;
 
-		if (folio_order(folio) > 1) {
+		if (old_order > 1) {
 			if (!list_empty(&folio->_deferred_list)) {
 				ds_queue->split_queue_len--;
 				/*
@@ -3939,8 +3939,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			}
 			if (folio_test_partially_mapped(folio)) {
 				folio_clear_partially_mapped(folio);
-				mod_mthp_stat(folio_order(folio),
-					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
+				mod_mthp_stat(old_order, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
 		}
 		split_queue_unlock(ds_queue);
@@ -4061,7 +4060,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (!ret && is_anon && !folio_is_device_private(folio))
 		remap_flags = RMP_USE_SHARED_ZEROPAGE;
 
-	remap_page(folio, 1 << order, remap_flags);
+	remap_page(folio, 1 << old_order, remap_flags);
 
 	/*
 	 * Unlock all after-split folios except the one containing
@@ -4092,9 +4091,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		i_mmap_unlock_read(mapping);
 out:
 	xas_destroy(&xas);
-	if (order == HPAGE_PMD_ORDER)
+	if (old_order == HPAGE_PMD_ORDER)
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
-	count_mthp_stat(order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
+	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
 	return ret;
 }
 
-- 
2.34.1


