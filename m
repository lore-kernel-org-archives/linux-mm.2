Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE3D6D3B7F3
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 14:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49F3E6B0012; Mon,  8 Dec 2025 09:36:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476686B0022; Mon,  8 Dec 2025 09:36:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B3AB6B0023; Mon,  8 Dec 2025 09:36:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 232036B0012
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:36:43 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1A7056385
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:42 +0000 (UTC)
X-FDA: 84196555044.07.029AFFD
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1B5FF1C0014
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HKL3VKzf;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765204601; a=rsa-sha256;
	cv=none;
	b=8IHb26nTVlEOtkg7wHsGRwcS/OwGzz3KLUrbnZUuMeGhoBnPU5obTPhNILc8TRRYmHOLOd
	TJKBNjFqrz7R9duEDU9dP60++gF+82ObvF+Ctdupm7nvvHDedCJdrcZml2J/BWZoFf02P0
	/P308nKinDPMZY3OknJUM91rUQ3LU3I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765204601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=yBRAXORaBk+WtmlH3bewY7/tciNkchQd1TxwvTKD58A=;
	b=B23P7wsTo+pwKSbFmNLkcBV2pJ9T1MWVQfYmizFg9bxiZDBJC9r8uHKvhy950CrNML2dzB
	BOoq/x8jjh2b9PYj3ZudyiW0EmuIsPcW5QXv3Rf+Sy6tdLIHeg0uXdcoJFH3ROPMhdQ949
	bfhpg0RvWNv7LN4YIXUTby1s5i54Co4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HKL3VKzf;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b770f4accc0so600900066b.1
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 06:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765204600; x=1765809400; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yBRAXORaBk+WtmlH3bewY7/tciNkchQd1TxwvTKD58A=;
        b=HKL3VKzfrhkNlc7HyNxZmwf+O77JMtxOT1W88ciT496xMXI7SsZ+RlQSas8yZlsjeE
         f8HNVriUaGF/L6Np0XexNuzVJDZG3L5DcHgPdpbuI01YmPPjcqyaTbZ0l6sR17o0eQM1
         wAk+tlYEJ95nEPybZVUkgfsEiRlbIka6PUd6Z06ckQZ61hTEkBGlLZhiq+EftQWykSAL
         hCttTYJBnZyQgH33th4hn3eYFxCROmFjuNp4IcX6xVcTla0wxOo5ebbj8jPL3v8Y9oed
         ecinUMUaoqAx1cPII+txnZJb8I33iwWk6l6Z56JKfQySYUEjB1D7iRI9BEm2VqO2c+/E
         09aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765204600; x=1765809400;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yBRAXORaBk+WtmlH3bewY7/tciNkchQd1TxwvTKD58A=;
        b=P177LWpB0ec8Klol5Y6iF7maByqaBz9E0ljEJwLeBBwBQ3p+UbSlpkAbE001aGu8hh
         5zDxWGbTaeulG0DEb+Voxf2vKUDiRYkBlHQoxqygPvY1SrXfQ0vnidYGx68ysZPqSKq2
         YeIkSDt+2EwnnGKcU7wrKP+0SfbHcLvbq15BfOI9/t3wge0F+9XLi6v0u7+AVXhh65Yi
         vyWizvJ1KMNKAorRxeyxiZZg3dl7gI8jqNMi+/v/x1mV+44kEQm+jLKhDsAa0NVN7vau
         OSbiGbyYjVnFNkHVTl2U+2VmYwllQuEgkEkY8BS2Cw4Mc/RoxvSE7v5cGB+w2iwKaTTF
         E76w==
X-Gm-Message-State: AOJu0YyLY0y6s449cYmG/GXmdpq8anekG6O0X074VgqeAFOSAs3sUSbo
	Qk40onq+SiPXSKQ9wLmOkat4uCSt485kmCCL/ULC9NpkTZwtMEIDTCDM
X-Gm-Gg: ASbGncsF6F6pMUvlkC+F1oFcsUXI/j56prcJSvO5RLYuwQdvr+fEGoK7j3/zLlRsVqU
	eHyeRr2B3S3gqfGRHkn3/HIgUYNfgaz39g20dj9Wy7RCVNQvxg4fqjrLbHrei1Cf1aGshEofzba
	ljPGfT+FDqfA9KoWozMoy4YCOUs1homqV4G+hHKOHPLkDcA/3hRn9COP9kmt9upxsDymRhXH0T/
	W2J5Z/Q0kpM0fPxPGRcKfoMP7/nu/g5CF8FgNrpgWOoZbFV3vHcQRr0PH78hqLgHAGrb/8bw2rw
	Vh7tFxevfXLe/ACKj9g/CEm6wpFM8T2WiIdCQatmkhv/rcHNeeLJwc+gDCoqScPkkD+zYdP4sWO
	yZnkc1Q6GSt8/p8BjzfITLaogPQ3ury5o9kDQgdSIQZAEmMVybUcziKdzBgV2BJTmv4uS+RNdxg
	bOZ/uF82igo+FyqXVU0JOJ
X-Google-Smtp-Source: AGHT+IFuaP4/6riOxkAV8tEq0QbmrZ++dn6jUj8LlL45Z4HC5AzfLn/DWi0RFBjF5KAvGrquEscA+Q==
X-Received: by 2002:a17:907:3ea3:b0:b70:b700:df98 with SMTP id a640c23a62f3a-b7a242efe10mr811045366b.5.1765204599582;
        Mon, 08 Dec 2025 06:36:39 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f4a60f50sm1086354266b.70.2025.12.08.06.36.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Dec 2025 06:36:39 -0800 (PST)
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
Subject: [RFC Patch  09/11] mm/huge_memory: introduce folio_split_uniform() helper for uniform splitting
Date: Mon,  8 Dec 2025 14:36:14 +0000
Message-Id: <20251208143616.20797-10-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251208143616.20797-1-richard.weiyang@gmail.com>
References: <20251208143616.20797-1-richard.weiyang@gmail.com>
X-Rspamd-Queue-Id: 1B5FF1C0014
X-Stat-Signature: hxr6rf8s9speat44ji8tc8hmc4c67wjh
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765204600-18214
X-HE-Meta: U2FsdGVkX1/VTWmK9L+SdGbjPrefuxkoR4yjthduEHVYf5wNiEuEuzjosBrtSKfJsNA45/FHrFk7KHDVqSomcuN6qjmBFd3ak1gt8oT/4swQ/IAq+oFsThOeH3KgWebgkwCB7/wo/jM+8xlIXQ7bh5aA9DWGAQ5rFiM5FtJWiSjl+DCJfS7AdRC0JrjRfX4YUNVgzvXQcQMlGiym1NN5LqbQv0QuYTJktCp4kMPldBODULxKHezXfby2cuvW4A5+qM5pZpe6lQsVp3hVYmygruFyN/9FTL/ZPj60/wkHmmmzdpGNAxwS78UJP+TOZCOH6nkL/yimu/8dHFluYdxjmWUEekmJsjt2xt/V7er+D2M5YniBxkBOikqj6lFGw+Bgaw928TKyl1ipvzCvQkchgqPGolsANzdo/+syVMMWX3Geq9MRWwKdbIuci6Yhp4Ab5ubIPHRc5i/0kor/w1l3N0Rcz0kYd+XTbfu2Aw8BvMeh53RGrgK/3HPRJzh8I01tGVIJ7XJnx9HZMsHlpJEn0RdL54WMlOEnrknffxTYf2GHrlJT8Bgb6wLtYQZ2IOVSNxDF6OgPYzC4nRTPogZM6bJpRTW6IABi6y7Q13G73dW0L0pLs003UIdvbKeFzfQ/olpa2FDLNETMsZcgVx9bz/cDVt4uDaXkM6xN3TOZGXMLL+we+y8aLzws/nfaMjGQujAleoF4S/b6RoabfrhbYKGNrvabuShVFdO3fGd5pBSVV4EfTitPD0oHEgdCpbAYfmKidfuLw5IUCkAuazRg5uM2M/V6afJWnkZ1lVplBljaQsfJr0FBoLzKYp8h3DR4wE/GdMJ+fKDkcqFb/NSZqTW0fygSZ/MgCbSwlXBMw9+lL8NABCx/EEP+39VuOwon1I9P4XKOqcabtKqwzVd7VuiHFugqtIC/6brH7bYJw0uQWLK2CwB8984BMxjvucqvUE3jHVRM8dWS5M+Tk8D
 V6JuS7j3
 M4nXnjVcZMZKSFd6Dav40Efn1FzQnlL8nC6Wihah+HZI5iCwD4pb/nT7WJ8KNemiDBxiX8LDF0aS+tDfAoQ+zg0YHU7SIfqYFGRHzOvEx1k9TIlG4guQnQ3Pb3U/Szu8/I5jcZMeyTg6wmMYhMVJcRvJtqikHcfg4QzBVtpXy61Vnj8iBhI8sAq8qNO6gcUK6RkRM1KzehuA/QDySjfPeW5sRQvc1I+J0/mFwARPFFdbRjA06WclIX+RdIWPauD1zjSzeRXOIzKENogG8jt7kP8c4vteDddCt9bYI6iFYDXHUvKAQYBMwUFlpDJgBid+3fTTuqFII+X4MAEdIsOjpo7gcPXnIXPhhC11Cmm4lDzcqTXjCaFkF2iWpgHUvb32f5bEMD0fZpYTFBd+2LNHYWVGha3IHtubLDmA6snaIWe1S+WlDUe3Jpyu+iAUbujVMdJA5vvq7XtfbCiwGXW193KtkmZ9GlAXpYxL038wq1/9U04VQy7BREBFNKmNtgm5BGD2DBdShDFKRYJsx1kGMIP4g3cS/+d6YngwWpKkvJ3dfkucFmlcX1lKk6TBydDB5DGiVa3VME9uuAuJIGNrG4BwgFO1nGyMIfcr+LtVfsvp9lkRpEAzBGDMlB3e+OAA+1SCX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are two fundamental types of folio split:

    * uniform
    * non-uniform

The existing implementation uses the page-centric function
__split_huge_page_to_list_to_order() to handle uniform splits.

This commit introduces a new, dedicated folio-style API,
folio_split_uniform(), which wraps the existing split logic. This
transition improves consistency by adopting the modern folio API and
paves the way for the eventual removal of the older, page-centric
interface.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h |  1 +
 mm/huge_memory.c        | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index cf38ed6b9835..bc99ae7b0376 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -376,6 +376,7 @@ unsigned int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 int folio_check_splittable(struct folio *folio, unsigned int new_order,
 			   enum split_type split_type);
+int folio_split_uniform(struct folio *folio, unsigned int new_order, struct list_head *list);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a8ca7c5902f4..09742c021eee 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4199,6 +4199,24 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
 			     SPLIT_TYPE_UNIFORM);
 }
 
+/**
+ * folio_split_uniform() - split a folio at @split_at to a @new_order folio
+ * @folio: folio to split
+ * @new_order: the order of the new folio
+ * @list: after-split folios are added to @list if not null, otherwise to LRU
+ *        list
+ *
+ * After split, folio is left locked for caller.
+ *
+ * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
+ * split but not to @new_order, the caller needs to check)
+ */
+int folio_split_uniform(struct folio *folio, unsigned int new_order, struct list_head *list)
+{
+	return __folio_split(folio, new_order, NULL, &folio->page, list,
+			     SPLIT_TYPE_UNIFORM);
+}
+
 /**
  * folio_split() - split a folio at @split_at to a @new_order folio
  * @folio: folio to split
-- 
2.34.1


