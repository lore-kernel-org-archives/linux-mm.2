Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9736ECCFA03
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 14:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CBA58E0095; Sat,  1 Nov 2025 10:23:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A38F8E008A; Sat,  1 Nov 2025 10:23:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A718E0095; Sat,  1 Nov 2025 10:23:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22EFE8E008A
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 10:23:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E14FC891E6
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:23:41 +0000 (UTC)
X-FDA: 84062256642.02.2192FB5
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 207B3C000B
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:23:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VzjPy5sx;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762007020; a=rsa-sha256;
	cv=none;
	b=ZaWYFDsdcfLZSh7VhIl9eKBOUw/QZ3yrBNA08x1J4noEDZD6aRK2K7p4AO1Km+GLBul5VM
	tSWaqdSx0u/7PUe6LO2J4A3bDQY19uU7qmcjeC1iGHgecUWF/dPIrJd9LtSQ0AbsT12kIT
	uFIehQFOBdKm4x3tOj29UOULrjtS2LI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VzjPy5sx;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762007020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1DCkHyYopvb0wF2qt5OuiBAkk+v7Kgo7WmWoUc1PDLE=;
	b=6OdRKje3kesxR5FuTtetoQtaPYYXq7RLs1QVBSC+G8DWCiAZIWvCTVEN72hZdupXO6G5Dq
	YRMcW5yJn+zRqS9ldFPfvmOUBguEQKuJ4E0G1kIrf/diW0ZjgRbzOLmjPitQpR1FU2kcl1
	JlkOMWpAG9kK2ze5+Wr8SVXJ324tIs0=
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-89018ea5625so1504114241.0
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 07:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762007019; x=1762611819; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1DCkHyYopvb0wF2qt5OuiBAkk+v7Kgo7WmWoUc1PDLE=;
        b=VzjPy5sxuGKp5G9P1JwS4I3RHxFoPvoZ13YEDwreJU7bihDBumvwjQyaOvDTrlO9rX
         cRn07DNgynh462y0Pez3gOpkFzyOpeUUeXHRPGKmg40oWAJCAlcShHHcquWeCxJfJLTT
         vIYI1YIDO21/I61Zb4OWp4/x0Ul+DQ/Noz1N6w6vY7t9DEmzP1zpDwrHqHuTQMSRlVZW
         bsTYFgU3WP+nSQRZ9rmtd49xuhifoSFtP6Jlc3zGMXYNhjKwRIQWTPZNeCeNCsOuR0rp
         Y74qTlXbkPC8CDHaRA+QwRv+3I4M9kIDJYYRSToZ0T+V65Jy9HPXcvcIFXP+rkcCluMF
         T/Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762007019; x=1762611819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1DCkHyYopvb0wF2qt5OuiBAkk+v7Kgo7WmWoUc1PDLE=;
        b=i7OkKUSlA2NYEmD9x8T0SQMczXCuw9HoHa6Nl/KmFn+oSMrSwUr8WdVmUBYkplO33D
         6mXXbD9hSooyCLJgSqUn2pFYg0Nd7SHrZmcUX8Xxp/UPg8IyLp9YS4ngktkYYnfzW/+A
         vEF5c6pGqFJJa4EIbILWwIqccX8eJkjm3LaMDpCnA0SYpyOzkZ1HOjkEw/LO1gxz0HXS
         ebCsbC6IpaIVIgTZ3FxjdPrRnboj3t2e71NNAfdYVjGscfW1218y+ytOG6G6g/SD9HFQ
         z9xo2sPbTvtDudhIV96swIQaNdsmr87o2pSmYWKxT3Sb2P5u07MmPBkThp6fOx1lMOGo
         U+Vw==
X-Forwarded-Encrypted: i=1; AJvYcCXAv+LB7UPulmWp3g1p/OM9Y8s1oNN/3YFhbntODQWULGU7qQkLP3Xc472lz/FMONfgTQGlpMeZYQ==@kvack.org
X-Gm-Message-State: AOJu0YwXxcsAhOEmnLSfvSdr54z7SQRVMBOZ1JmODlUY4dghbZgfsXNH
	m66dWnnoyI+b3F24ciV7YUjyJKO3tH4l3vtisRZPtFgh2/r9uLbDfptXIVO5AvrXg7I=
X-Gm-Gg: ASbGncs+h34zaAABhTpoeokUZWWAakcdLf/D+7mEUCrndLWwRR0nx40WRwwxTP0/bGl
	Dx8FrnakoqFHVEu1vZvSXvilvMKVJxLQY/NomUDfuMR07hqrcmrp/DIxf+SY3H7zyTzERvbTltL
	5l9yxmKEa73YGCJmoG7wAAhWCiK7Rmk4QGR0cPeTTBZbqP+IcbWBtCCoLSqnzHg/jYf70nECMgE
	9rv09NUMoOEexvW0lALIaPNxvXKSNw3fbwggMUcW5BB1tv33kjsLGieFiLM+ak+mgOLqiRPuaU6
	/fpX3bpKwOQbmhLM1X1uDJDsjv3zYmZBY5Pq/W/cGy1Qn6cvPXUfK5I64EHaXYEf7HEbpWtGdo3
	08SB6Bg91jlhrj7uy9tKpAgYi2kOZys+4LHQvudv4adLTYkA4RJH7X7N1Z2I0aC2NL8zzVfdT1R
	3ay8YmV3O6/vaD7gtaiT8AG9d/jMnPAmPRTUC07CyAHpvpLB1Bf6RcKPQE1i5IarTheTorZeY=
X-Google-Smtp-Source: AGHT+IGR/VzDF7AB+sIC/+cJHCH4X5S7Mi8sJ3f5dCfpSYmCmX5nmYDVJr+NLnssvgjti7LClYe3OA==
X-Received: by 2002:a05:6122:21a8:b0:54a:23dd:5a9e with SMTP id 71dfb90a1353d-5593e270143mr2102007e0c.3.1762007019132;
        Sat, 01 Nov 2025 07:23:39 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-559449647e0sm1776242e0c.3.2025.11.01.07.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 07:23:38 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org,
	yanjun.zhu@linux.dev
Subject: [PATCH v9 4/9] memblock: Unpreserve memory in case of error
Date: Sat,  1 Nov 2025 10:23:20 -0400
Message-ID: <20251101142325.1326536-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nh9ibaf8i66ajr44t14d57rgxrrxmh51
X-Rspamd-Queue-Id: 207B3C000B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1762007019-333540
X-HE-Meta: U2FsdGVkX18xov8TmXU/P+eMpWSzBFD3I2DDuCh+21ZhZT8Kd+Y8FD5HC+bT/vgV3HLvTjP3553d93dOzH1eRvjmwBn0Az5WVUpeujGYWsjgHPwD1Ypwppcc2yfJAEZcOGL2xOBJJKBP+I18Blnl38b7FgXiVdEBXfgnpiMrWByg4TV3WTjslIa1WFt4kG8jPYJNmj5gYv06giRK0N7s7C7/N2CvEhwlmQ8GH9eVzEPepwpBDj6lJg4aZkGM6HK7wLpyhWkKBv2VW1ZVHYCcjC4DCJ0jSIlsxdLGFYRJoZW7U5Jqo/0RkstZ39dHH84F0RWzlXlxaCZuZ3HvOfmduflsxh9jIcP4XD14X5CLCM4Fl4HzyLjPABaqbX4bMUbIj5XqjsTcU5sO1azXrR1+J157LGcndlTm7r0lEjJg5agxtLBClkMuww7iWDCYqi/r79uYdkZOWy6+TUrr7ymfhNSgJztBA7DqR71pKNGuw7VTKpoAMTusE+LLBsWG0cHtOnptRkEvAJc3fN8rHl8S36jl2xNt4LetQvR1fgJASZSoXfUdsZMaJrn+62Yf3bDJrAUl6qjdFRjnLaceqVrG/PJduGxGM4BA3zktgPvZtzjwHxaCXpFORsmLRfFiLrVQJ2T1rorTuDiJ5Lq8bSixvKUdW6OPP4tooV9D1jYeqKI1M3iVkbGUNi3Ic0sLgScRL4pi5x8Ii0xxLt3i8U79NQEdqrMnk5cELoJcljP8dYr69s6fiNaqn+j1jN2PzU6hjah0BBEJ4tSek4HeWrMLZFMyWjazrGuOPxCI/BPTqighe5O5aJlJqZ2JOOhmT03889oJb2QW6m2K8hj98Wt6JdTwNQ1KBz3VkhAqs8yqWcSPka+xHEGYeNMAFNBhQjr3kcN6sF58J/b80MOFxihc/YKzLtWMN0fftILxVSWiutcN4vznJJ2/swWpd3I9YKajmk7rRq4DtCLn3vmqPMB
 tXmmqzkE
 kJigbUDek9PXywYCYTAuLe8ZLvF8IVUM6TGorgUrY5GUVyibpXoKlTluFRxaU73qJ7Zd1Iztsf38sjaB+cLnLNP7mRVuck4HgZvna7yRiRizCJGFbE56zAoXQhiNjCa+0mfEYBsXL7+V2blkppEAtE6qbBSq4fNm9IyW4kHhTwvijOdox7nITkRw24ex+/pXpnj/HDjgVZ+pheB1Y2kCArxED6rPkmVeMQ/9gZrwPpxINwDfcz4ewP+iSSB1C1CohJrheCpysDOjyYUHF5IlxCCztBpOZtrlHvmKR3CFK1z9uIKRS5l78dNFvuf2a+bkkhOz9+OwVX2fHq/9Jmpxc6C7C7gKLfdMZI7mWT6Cos1SKqEpQYvT4nR6es4/LbO4W7dhu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If there is an error half way through KHO memory preservation, we should
rollback and unpreserve everything that is partially preserved.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Suggested-by: Pratyush Yadav <pratyush@kernel.org>
---
 mm/memblock.c | 73 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 58 insertions(+), 15 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index e3bef9b35d63..f527ad1ca682 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2445,29 +2445,60 @@ int reserve_mem_release_by_name(const char *name)
 #define MEMBLOCK_KHO_NODE_COMPATIBLE "memblock-v1"
 #define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
 
+static int __init reserved_mem_preserve(void)
+{
+	unsigned int nr_preserved = 0;
+	int err;
+
+	for (unsigned int i = 0; i < reserved_mem_count; i++, nr_preserved++) {
+		struct reserve_mem_table *map = &reserved_mem_table[i];
+		struct page *page = phys_to_page(map->start);
+		unsigned int nr_pages = map->size >> PAGE_SHIFT;
+
+		err = kho_preserve_pages(page, nr_pages);
+		if (err)
+			goto err_unpreserve;
+	}
+
+	return 0;
+
+err_unpreserve:
+	for (unsigned int i = 0; i < nr_preserved; i++) {
+		struct reserve_mem_table *map = &reserved_mem_table[i];
+		struct page *page = phys_to_page(map->start);
+		unsigned int nr_pages = map->size >> PAGE_SHIFT;
+
+		kho_unpreserve_pages(page, nr_pages);
+	}
+
+	return err;
+}
+
 static int __init prepare_kho_fdt(void)
 {
-	int err = 0, i;
 	struct page *fdt_page;
 	void *fdt;
+	int err;
 
 	fdt_page = alloc_page(GFP_KERNEL);
-	if (!fdt_page)
-		return -ENOMEM;
+	if (!fdt_page) {
+		err = -ENOMEM;
+		goto err_no_fdt_page;
+	}
 
 	fdt = page_to_virt(fdt_page);
+	err = kho_preserve_pages(fdt_page, 1);
+	if (err)
+		goto err_free_fdt;
 
 	err |= fdt_create(fdt, PAGE_SIZE);
 	err |= fdt_finish_reservemap(fdt);
-
 	err |= fdt_begin_node(fdt, "");
 	err |= fdt_property_string(fdt, "compatible", MEMBLOCK_KHO_NODE_COMPATIBLE);
-	for (i = 0; i < reserved_mem_count; i++) {
+
+	for (unsigned int i = 0; !err && i < reserved_mem_count; i++) {
 		struct reserve_mem_table *map = &reserved_mem_table[i];
-		struct page *page = phys_to_page(map->start);
-		unsigned int nr_pages = map->size >> PAGE_SHIFT;
 
-		err |= kho_preserve_pages(page, nr_pages);
 		err |= fdt_begin_node(fdt, map->name);
 		err |= fdt_property_string(fdt, "compatible", RESERVE_MEM_KHO_NODE_COMPATIBLE);
 		err |= fdt_property(fdt, "start", &map->start, sizeof(map->start));
@@ -2477,15 +2508,27 @@ static int __init prepare_kho_fdt(void)
 	err |= fdt_end_node(fdt);
 	err |= fdt_finish(fdt);
 
-	err |= kho_preserve_folio(page_folio(fdt_page));
+	if (err)
+		goto err_unpreserve_fdt;
 
-	if (!err)
-		err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
+	err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
+	if (err)
+		goto err_unpreserve_fdt;
 
-	if (err) {
-		pr_err("failed to prepare memblock FDT for KHO: %d\n", err);
-		put_page(fdt_page);
-	}
+	err = reserved_mem_preserve();
+	if (err)
+		goto err_remove_subtree;
+
+	return 0;
+
+err_remove_subtree:
+	kho_remove_subtree(fdt);
+err_unpreserve_fdt:
+	kho_unpreserve_pages(fdt_page, 1);
+err_free_fdt:
+	put_page(fdt_page);
+err_no_fdt_page:
+	pr_err("failed to prepare memblock FDT for KHO: %d\n", err);
 
 	return err;
 }
-- 
2.51.1.930.gacf6e81ea2-goog


