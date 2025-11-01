Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB3E9CCF9FE
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 00:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0ED8E0112; Fri, 31 Oct 2025 20:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343858E0068; Fri, 31 Oct 2025 20:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 196008E0112; Fri, 31 Oct 2025 20:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC00D8E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 20:29:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B405F13B818
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:29:45 +0000 (UTC)
X-FDA: 84060155130.16.B6B971F
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id D621F20007
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:29:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MNW47Vs0;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761956984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=cptIHrdiz2w8L0e2q9E9572zvPadknEyqwQxlQ2KxJg=;
	b=y5QhnK6RLFixQKW6PKRdy9oVtj3D4hMIFqK1tvhQmCsJvEhiz9WPhLdLw93Pqs5YGWZrPj
	aO56Q73kgvsMF0qi4wNy27lm0PQtViC/7/4dqnLJLDvXKf/ay2BB/BM8PCinHpkaWf0jJK
	ynj9xAFlowA4T1no9jk2QTGqgIdUL6Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MNW47Vs0;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761956984; a=rsa-sha256;
	cv=none;
	b=xdlxGzofDaQ5pILYpO4yEoZ6+h6i+sW1jIolcnTrCGsaFin6Ms/nNcsUk9wiizGkxwxdkN
	fPcqzXc9ycfcw/0rQt1aiac3IkDURXhluXKLJriEd7vnxgGlrPjSpqfsJIyTABwSCkTnZR
	Trg6TIYLP7rFkDxcvf0mNs4pP+uFaOs=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b5a8184144dso419001066b.1
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761956982; x=1762561782; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cptIHrdiz2w8L0e2q9E9572zvPadknEyqwQxlQ2KxJg=;
        b=MNW47Vs0g0kL0WGM1H0dAwDQ/ksx3BNisMtfteRJEBbyfJ8BSiSd9n7NqWtnDWLW5y
         qf6ItErC7kHG/0JjXh9+57jNDw0nCrro6dGlKz+qiBt9J4LniSfG2MgKX8bV6T9HqDOM
         BSZTc5f8DBtRvC+FDMTUBKDBBTrZKAv52n5YoVnrQs1W74Zbgiesn+Ye6LkOTlcxATn/
         7g6CzfaXjh8onJ2VrtRvx/K1GoeLxt5Etw+jSFtB4qcj3cR1x4tFwQt7o3nuW7FpJuFZ
         t6gUiQctKTOpkdw6DCrjcDz6/GBIUf+qXtVNfjOXe+b4Xy8kmXoMjMRWU+QCzf24HpVI
         hycA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761956982; x=1762561782;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cptIHrdiz2w8L0e2q9E9572zvPadknEyqwQxlQ2KxJg=;
        b=gR7LDuYXaL+Aa9bgFYDx2CtAqNeg3rYmHeeYH3e4d5SmsaZefYp4nlOeZi4FV9bwMP
         Fn6QZlEJCOs/tHJHjmqfGVxLdbbgB9UgmNXb0QLo6U8E4jIiwaInOeSuE14zUFRYNrnR
         jtP9ynBpxNJaP6MX4RlGrSYCaoOqZBHIeYMKRPBo/TxojhYp72HD41FUTJLatMYtVU1N
         dkypiWlUjZWc0WmVyXwb7Or37PHEMrcqLswMeH4I8O7n449nUx/QrF11lrx7ldlQWTxC
         yf9VSNAoWDw/MMDaReSr1eNXBK9DLZUhtse/Qrct9zW7EzWCua6zde+L7xHu+IX+ZG0+
         hdBA==
X-Gm-Message-State: AOJu0YyulsaNAdbwzZgCjsdComC8y1q+J+0/WGYcTVt8j8PwQmuPXJRQ
	F3P03csbNZ+127uJhJqknTLcBvFY+gF9ijBAYkAmf1pFvdYEX3hO2rSN
X-Gm-Gg: ASbGnctVU9jM0ijg+n/cId0Pms/64RRKAEGwC+UVWdbIz0hTEoOnmARNg8iUkvSIXj5
	HeCfI/chAliMFwPJIaDcX5zhFycqnfsxNc591juInjfBkgl3YS+XHfr7+b9x4g3Rkg2iDxuNCef
	SwoQ13mAtQDUcvoH5M0vKoj1VV5jkYbKZtL99vFNctuYg36AltiCq5KQdUsahkgcDdfl8+Dldxe
	4LrdwKrVdAH23vH9V9hdXaEvcvOj7qYxWbkEYaPk9yFGTJo4YT6QZE4wx/L+HFAM7eEqE3dNyeH
	VOIjec726j3oLCD6+TzHf4JfAD2vzHRe8L5OB/S+nNIcKZoPwQCuK1gd+wftEaWp4UmiC+UcvcX
	rntJSt23rLSk+EUgI7OwSTPTiTsnjRTOn8WNeB3gcIhEMtnzLi7/zFkdIz0zNrGfTf5jF6HMnkQ
	YnKhiefP43qQ==
X-Google-Smtp-Source: AGHT+IF7b1sfy9B5PeNXLS0p0Uu4Ap/DONfWdKDRvbTJYU336zLMsOP03TxMC4LBDJsLonBogQv1qg==
X-Received: by 2002:a17:907:9496:b0:b57:2c65:116e with SMTP id a640c23a62f3a-b70700fd97cmr600528266b.12.1761956982351;
        Fri, 31 Oct 2025 17:29:42 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b70779762bcsm314352266b.15.2025.10.31.17.29.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 Oct 2025 17:29:42 -0700 (PDT)
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
Subject: [PATCH 2/2] mm/huge_memory: separate uniform/non uniform split logic in __split_unmapped_folio()
Date: Sat,  1 Nov 2025 00:29:27 +0000
Message-Id: <20251101002927.2610-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251101002927.2610-1-richard.weiyang@gmail.com>
References: <20251101002927.2610-1-richard.weiyang@gmail.com>
X-Stat-Signature: hubupckt45jcwwkqouqxpmijsjhzxzc7
X-Rspamd-Queue-Id: D621F20007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761956983-615730
X-HE-Meta: U2FsdGVkX19FxC7YtPcGSha2NXh5F3JVhSvrN+VzMIdDwYaPmltspncWYP6y9NbFbqpldLl1Cx8vPiAmCaPexMOotN5lVTAYTnprqy11SFuLM21cGuBOwFXeVQdFt+ORFMDJA+6D5gRzPzyoWnpvDGfrM3xbQ0zfAl/vZ8QWsTqHCPg9c4z746PAT6bPzxzpxGGnxfQBKn7osGosmUYXI0prUesPQLPeFih8WBfZcE6l58cB8fjTZlXVXLBfncS7gNok5dNV2TG1ZWVKJ+GShqlf2ehwP++K42FmcAfWQMf5v4lCqHK9YTBhi50QXB36A4FDTvBWlQswGNaNudhHaalkujDJhxkJ3SSMAnGaWdK75QBN88D4V1JhLsMzorgzWysowmM9CVUEGtjYKQwlwtVNghMUEQK+op6OdrpBmuqb41EW8dGY0O/R74uSFliKK2mJcQWydl/ZRVvlubvpbK8PcKkgU2QSB9yEcxw0ENVi+kmNXnpzwZTohNpOIMyEcXOp8d1t/I9WFlAzam7RcIxzAP6IkO6Ozwv+U3Cj1gOlUyfccjWtnky3aIT1juZn7ltuPuAowtviUNr7bI0mXco26d1ANK5YBXJ57+6nDSpw+WQftkOLCW7psFI0kMr+bpTGz+hS5omLDJvC7aKNTpVNNEyD5SAtdeJ5wJ8R45wn8N/Mf9MpoL02nsvxhp02arm1/Ft8Et+M+3uG0lxbYJ/G8p8857dXpEkhgTbOr+TVs2pW8LCEiStD1Fv+Uf733Sj+CpdS+7wRG75YuNMgw7Wvr07kMLb/psBDpjnzg5hJDeY4cb2OOUZGHOSeqNcCqqHCh6+F8i7D50daT1ROVTKI+ONaVBLJEedqeZ549weLhJdwMYx1Uedj075FXZ+P26i58yERi1WRFYKdW+Q3McwBLNKtMG7mKu5JVHjxJFPEvVRIeBuVY2D2KE3IklU7AcL0zU52veVKsYLRHBd
 7efuqXqi
 4XH3TB6gsD1i9HrocbvVYT72XRk+mwM6v6uI7GTkl4JAk3H+eb/uYKmBAnb1fLUMzBMSUfGD/Ha2bWHc/EQEn0hbMRtFlFrPXxrN4KsTsB8m4vQWfg7oBkuIsUP0s3a1BldDDNdeReZZ8a068pDirmO3LZPi9gTAsvcQ1foyMcyHIKbQNipIwnifTnIb+Y1a994EGM5VtbffjzjPJzCdeKXiOGUqnRTdLFA4yMi/sAgcDJ0fKRXujHJcKsgxzBz2M4ZrXAvGc+YPMg/mF248P32+ZaSo/61QDNbcUnJMabSnig+KW5T7y7LBs55OUFG9sppdp8EaaIqycFoGvyz+82NBWsP5Y/JUsxyfZ4c9BB7BQGS0RArweoSW76aoqTip0YykHRReoaY8oIyWoYQD6OfdtA6r+1SNWQ5QPjcwv//irdkuM4+KxkkyAgZ7uoDJ+Ja1deXcM+03r2wuAPySTnndsbd3K6nDJcPat0d3ClHR9SzrMTy8diWOpaU3TaRf8Au7E8vxvIJSsxJTw9I9uhcWIBIfausGM/0CVOAkxCDEnzMKEDYiMq9f4iVwdJVAIxxnIMzFsyA3EvsQMlfBE+k1/60oiJp/E3f4XaXvzJ3RmukDjNPeTHq8N5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

By utilizing the newly introduced __split_folio_and_update_stats()
helper function, we can now clearly separate the logic for uniform and
non-uniform folio splitting within __split_unmapped_folio().

This refactoring greatly simplifies the code by creating two distinct
execution paths:

    * Uniform Split: Directly calls __split_folio_and_update_stats()
      once to achieve the @new_order in a single operation.

    * Non-Uniform Split: Continues to use a loop to iteratively split
      the folio to a single lower order at a time, eventually reaching
      the @new_order.

This separation improves code clarity and maintainability.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index abde0f1aa8ff..c4fb84cedbe0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3629,14 +3629,20 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 {
 	const bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
-	int start_order = uniform_split ? new_order : old_order - 1;
 	int split_order;
 
+	/* For uniform split, folio is split to new_order directly. */
+	if (uniform_split) {
+		if (mapping)
+			xas_split(xas, folio, old_order);
+		__split_folio_and_update_stats(folio, old_order, new_order, is_anon);
+		return 0;
+	}
+
 	/*
-	 * split to new_order one order at a time. For uniform split,
-	 * folio is split to new_order directly.
+	 * For non-uniform, split to new_order one order at a time.
 	 */
-	for (split_order = start_order;
+	for (split_order = old_order - 1;
 	     split_order >= new_order;
 	     split_order--) {
 		/* order-1 anonymous folio is not supported */
@@ -3649,21 +3655,16 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 			 * irq is disabled to allocate enough memory, whereas
 			 * non-uniform split can handle ENOMEM.
 			 */
-			if (uniform_split)
-				xas_split(xas, folio, old_order);
-			else {
-				xas_set_order(xas, folio->index, split_order);
-				xas_try_split(xas, folio, old_order);
-				if (xas_error(xas))
-					return xas_error(xas);
-			}
+			xas_set_order(xas, folio->index, split_order);
+			xas_try_split(xas, folio, old_order);
+			if (xas_error(xas))
+				return xas_error(xas);
 		}
 
 		__split_folio_and_update_stats(folio, old_order, split_order, is_anon);
 		/*
-		 * If uniform split, the process is complete.
-		 * If non-uniform, continue splitting the folio at @split_at
-		 * as long as the next @split_order is >= @new_order.
+		 * Continue splitting the folio at @split_at as long as the
+		 * next @split_order is >= @new_order.
 		 */
 		folio = page_folio(split_at);
 		old_order = split_order;
-- 
2.34.1


