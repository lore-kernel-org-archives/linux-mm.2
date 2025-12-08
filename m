Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B3D6D3B7F2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 14:36:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D6C56B000C; Mon,  8 Dec 2025 09:36:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5883A6B000D; Mon,  8 Dec 2025 09:36:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49E786B000E; Mon,  8 Dec 2025 09:36:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 382D76B000C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:36:39 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8E8413902C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:38 +0000 (UTC)
X-FDA: 84196554876.15.2A0545A
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2FC261A0010
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PeD2KpXp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765204597; a=rsa-sha256;
	cv=none;
	b=hUHdTTgo3IXDONTQRqpQZukdISKdW8k8l+8srguiur8+YsrBUB/KxkhZK4eRaI88BSeQjl
	EKXZApIvACwjMF/0GF3NUzZndwBZhND2A0QwWVDv2XA5t+Zgttv/P9CiH9mw+Xbi03vjra
	WjgCNCuVrMT8efK3G+62pTF+J46/U4g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PeD2KpXp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765204597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=RSzsNFAakXYIWri8QRWrwPDoXgfR+MCrfXYZIwovtfQ=;
	b=YO+Hsaz7Z62CbpuGTqjoUE+IMyJbneEHl69VVP7aVQCTIkoE3RuOz1rI4kWgHPM60AOwu6
	O7wd7a4QJDj60qXyBj1ekiLejbTZ9Gh2l7MQX8mw/Apupikz4PysuQF/THIHH/KTyANQjQ
	iTz9zI3QitVJ3+0XxxpjjCSxdXW0sT0=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b73875aa527so651557266b.3
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 06:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765204596; x=1765809396; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RSzsNFAakXYIWri8QRWrwPDoXgfR+MCrfXYZIwovtfQ=;
        b=PeD2KpXpMvCc1rHUnwaVlfwK68f7Q1A8FWRlQTkuhj/F+y7KmWhyxY+lLtqpiBzD2j
         TEPENchWPnFokBFgt+nEpTaddLCVJdPE1DQ/vfZjr5qRj9F5wbuxzywSY9GT/C3O8y7x
         QZ3IxfpW0f8h585xpA5vcRYvySvK8JLfFAAg5i2UJQypO3uFB3RR+tjsFYh2MqaCUK0T
         alDDCdNw+Eg2lXUnh1+lYeigYU3DJExIFIxLlsHAiYq4Tley8qVmJsCC9iyIyGHZc8iV
         QN0GcqbeIFvl5gtzHdtuHUri/JmG7bYeTAklQgqHkZmF+TsnziATjQqZY6oA/2GBHXNI
         CvFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765204596; x=1765809396;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RSzsNFAakXYIWri8QRWrwPDoXgfR+MCrfXYZIwovtfQ=;
        b=l47ST4m1SkN6tItVXIliPzuxcUtyswz7SX9T86HfPMGDn3G1mBhfpuvhVgmKJf8RX2
         oV2oivOhuKHNITaEpO3bSpKNEvYu+L4nIMHM8e/Wzailubsq/yJBC2tDVQHKFasP06iT
         4nQduJGdVvAILc4BCdMbxH1JuWbBfGjdZ2nBzpIY3seh+aPv+9cgLLuNzQEGac+7NsrN
         B6JWD2zUTqHRanQWrG3BSPEDN4iI6yTywzc9/FjBU1UaBm2Lq0iDve5PJyokDMBPZw32
         hXuTbKz7Wfud/cFebJIMqxDmexmfUw6jcfBreErn9HJ2rGcWQIsevw5vIK4SgAQg2zXT
         E76A==
X-Gm-Message-State: AOJu0Yyju3PGwhd5oUH71ftrdAi6CuPLWb4yqaV37iKWw8dba1SSMPm4
	VciKE5ONlzopf+yvoPsaIumifbMULsvwzroSG+sBy0Cpg+HMgVSoJbKj
X-Gm-Gg: ASbGncuYc03jPrkA4t0dCtxikgaPFdD+0nfO1UwNK+wHgyIP387XarlXNYoDEQEmstJ
	O4Oxn0BQ7B3UO8PrSZpBCBnjT7DVRAyioVr1jrx6Uh/8CC7eqpZFi1K7SaP8J7nKlb/CRTon4PO
	T4TiiSoCJz2YTipTTulE4I5pWI8kB70Ae/A0R9xPekeN4X8JPyPbkmNqKeY+Ld4QNz1NB+YFK4G
	l5n+SvGjpOy6rwzlW5W33orodNa+qZj5fKi0Z7lqQub5W9XOg//5eKCLXZvfX7VysgUUW+/t0zG
	KWO1PscGkzsRrgKLx2qWsv0YMNuljX9xp5sUNcS+F5QdU6IKQ20TVl77of7sn+Nr1zbBD2LrDnv
	8EUi9fomW/2ZCYEpdJoxUKOz5MvdPFMWa6EVZfZjZvgB72/9Ip7j42+qSCjo5cxcBh25uLCWPTJ
	WzbVSK0SdqhA==
X-Google-Smtp-Source: AGHT+IEfgZKMgSETNVOgW+Eqxy1CKh/4M8uc2MwHhYdk+38Y+erIAjTLugARdAA92sNdsi4Ur94yIQ==
X-Received: by 2002:a17:907:8e96:b0:b73:d7dc:ddc5 with SMTP id a640c23a62f3a-b7a2428f52cmr741312166b.2.1765204595691;
        Mon, 08 Dec 2025 06:36:35 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f49772c6sm1110903666b.44.2025.12.08.06.36.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Dec 2025 06:36:35 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [RFC Patch  04/11] mm/memory-failure: convert try_to_split_thp_page() to use split_folio_to_order()
Date: Mon,  8 Dec 2025 14:36:09 +0000
Message-Id: <20251208143616.20797-5-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251208143616.20797-1-richard.weiyang@gmail.com>
References: <20251208143616.20797-1-richard.weiyang@gmail.com>
X-Rspamd-Queue-Id: 2FC261A0010
X-Stat-Signature: dd56mtr7f1g93amtcqp7q6b97hc343qt
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765204596-967734
X-HE-Meta: U2FsdGVkX18DkqVYPdIpZJnSytreVrVEtK8fr47kzb6QJJlja6PX9lrzkWke3zm6iAbHQ6LcS1LnEbP9ioTKUxz/k0o0JeBRWuFqLCHLaOhPJUtyJkwRBOVAMTB0K66tLNDq3PEXdgaUdmZEsjn1nrOOYwL0xEZbgr4SkKyEQrAu1OpLsXLeLaKK2qFjiphQA5d/6veDehejtMUH6bgzaPGjCS7c26NgW2oEcvUDZ2rBR9ahsxnc5r+o+HK/YB8sbiFf9ozdM5Wu91WW4pmJyltTgzrAlqU1tx0c/K0bHtesBTPuuC5GTmBwA1cn+teCExJISbas2hXY5RX9skV9O/8elb6sB2wkD/A7cn3BZJD2cXSCgD3g/AUAbjMVVyLHE8m7ZPKCMereu6ajwdzwmB8HoY4R35jP+ywXOkRzwAWILR24njn7dzwLUjhZZYHq3uYQ0xmF9XLh/g2NAOspOlLRRECrmf/KQzClqr/PsXRKEIZWfjJC/K8Xrrwd+D9eQobl+ZXiPvNUTtnIv/mSq99EXmxd500Tfs4xSrL7KYh74w8yOlM02JItDc4jQnHnZ+roMpLMgd5Dk9C97hqhJLQ96CRn6JXYx2pxzWmwEmWs/bHqc2runCJ7h/CP6icE1xSJk20p6unLaK72nHqMgsAsvsg+FqEJEtKwOX00JwttXvhhinWn7Z8SN0YqvPT6XC024UyN7jrTeRQVyfn7TvEoS58Ne5U5/80H+BvHp6Igl5QlOHIjcK+yLztVK8yqZr1K5e7JU672Yh/CZOqXtwSN68IgEyBM+waF9jYvc3Bual4xT3I/rLmFTVYajpVHnShorVxuBiDYjvtMc9yZH/+7KN9k3Xb0NFd5DTF3jnrjm+JvOHmoizIdS414oG8ehUncxFqInWM32/twnOhs0du4N41FNTd7FROmEwl+XFenSpRmSX/MXEzFqM90eMva1O5ilzjQ8qZA2h23s7P
 nhiqa7+7
 1J9cJhTH7FPEdFt4ZDXm/tQY5N1rCRykyh68eho+ztctIfOkwL0+vH8nyDUlbAx+KNt0gngwXmGCC5MnnMXWc72crfBGgu9Xvm35Jr3XHLKaxAUirpxkkZIiFPkoSq5kkvV+Ks7o0ycO0v9qnSy4vJYeQvY8tSF1vXDUdVoC+FHV0ETaflijSCyUtM9g3nbOV/KKeA/OASSmBcz0/bBLscSXYMRk74Q3o1GCgyxLAcO8lDFxa7ce/keF6cqqiXsooZnNl3QyerQrriJ54YQcjT4IhS1MsQUxvdRi5O1Fk+UhBTwN7Ye7/aGzUEVEwwi6kWDo2nvBWuxNkCzpf+5FO1b3DmsZ2KGnk+3T25gzmcSc8Nsj43tSRbzykF9baGmREfHe9zSpYk7QnoyBx2TUuTmp1tJ3d8j1ewnDCytps1hOXYiu3hTGm9/wwPD0Y2E8BREahopKTsxXdQv64e2vWctWU5qx7Lz6ViVAPhcoQrKf5x+7utbE/0zkUpvpPI0BUUxqYwyXHRQgWQ2tYGNiwIJtoBKBMrarVRmYdiQxhs8dut6YRw1DFMZrZSbW+RoXGhlZoS6uX4BsDbf6nDgPxH9eznR05u3dieZaV6AOxtGgQ79rw2dRRry4mlMiHo8BgI17cip0eTMqeEqS4cSeLrZWfWjQHvenVnu6gcz0yBwmO7mzhgDe8AwLXGfezuWvl3Hsd39uS4Jt5TgzKVk0PnKtuyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function try_to_split_thp_page() currently uses the page-style
split_huge_page_to_order() API to split a huge page.

Since the returned page is immediately unlocked after the split
completes, the specific locking behavior of split_huge_page_to_order()
(returning the page locked) is irrelevant here.

This allows us to replace the call with the folio-style equivalent,
split_folio_to_order(). This conversion improves code consistency
by adopting the modern folio API throughout the THP splitting
logic.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h | 6 ++++++
 mm/memory-failure.c     | 7 ++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 3e01184cf274..872b4ed2a477 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -647,6 +647,12 @@ static inline int split_folio_to_list(struct folio *folio, struct list_head *lis
 	return -EINVAL;
 }
 
+static inline int split_folio_to_order(struct folio *folio, int new_order)
+{
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
+}
+
 static inline int try_folio_split_to_order(struct folio *folio,
 		struct page *page, unsigned int new_order)
 {
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index fbc5a01260c8..600666491f52 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1665,11 +1665,12 @@ static int identify_page_state(unsigned long pfn, struct page *p,
 static int try_to_split_thp_page(struct page *page, unsigned int new_order,
 		bool release)
 {
+	struct folio *folio = page_folio(page);
 	int ret;
 
-	lock_page(page);
-	ret = split_huge_page_to_order(page, new_order);
-	unlock_page(page);
+	folio_lock(folio);
+	ret = split_folio_to_order(folio, new_order);
+	folio_unlock(folio);
 
 	if (ret && release)
 		put_page(page);
-- 
2.34.1


