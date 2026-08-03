Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDE3CC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38886B00B1; Mon,  3 Aug 2026 08:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9866B00B2; Mon,  3 Aug 2026 08:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4ED6B00B3; Mon,  3 Aug 2026 08:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 66EAA6B00B1
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:57:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 133B1A0699
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:39:54 +0000 (UTC)
X-FDA: 85059763908.16.1646291
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5F685A0003
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:39:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RAlbdta3;
	spf=pass (imf15.hostedemail.com: domain of 3Bn5wagUKCB8KM55IBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--praan.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3Bn5wagUKCB8KM55IBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785757192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vv6DECOvSmngHsx3EI9j0R7ut4SHpWl9EkNqXk3pPjk=;
	b=XxlLp37WjemRQ4O8BvtRgmJPHop68B20fkclSyXwq6dt2EIXguWVeGU5Qcv8Lw5wJ6sKJI
	XOWwFVGNXXy/OsN5xmMJ5u6Uh0P5LUnKw4XroEJLk/5yaxheuPo93TjTlV3qoCHtns3Hge
	CIfzNHcRoZ/j5D+c7I9v7bc2l2jhnHg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785757192;
	b=xFmTg2pkXMwTywHYIaNVtorTQsEjjxmgr/FvhDNklHRYMEhEZM7I4KCtgvVDPwUTQLzacY
	D5OU3fyhTLGP/ORM85OCA/nPJVabFfgmulJ3HqQEp0ZmKLRGZlfqS4VYxaZxn24exPdyw0
	ecScdCfeibDCahcTAMLJr/joN8LBfZw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RAlbdta3;
	spf=pass (imf15.hostedemail.com: domain of 3Bn5wagUKCB8KM55IBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--praan.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3Bn5wagUKCB8KM55IBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb74d5db64eso3931162a12.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 04:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785757191; x=1786361991; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vv6DECOvSmngHsx3EI9j0R7ut4SHpWl9EkNqXk3pPjk=;
        b=RAlbdta3PueAuR/qMXObsxInhtm5N2Iop7bWr2tYGb1HrxqVTNOX0ngkb7HL1ftP5F
         73W/vYUxDFqGCI7I6w3VzEAcP3jZ0hUuAnAZZ94Q8mJVRferfPmfSmfp2y+O8H6X6tNx
         gZAypTMN+UEn+hLrgEMn+VlYcj82DT8OPuie0DThoMcfd9EQsIaNYLmls/Wg5DVRoMiK
         ug/feAR7pgpDi3W/RsuPU+aBxqa5M168XNa3v3P/I9TRoBxkploFHmukIj8eFbL7cyko
         Mcy947JNuOkc6BYFTs+PKkba5l4WiEBUG1EyRQVkWRngoF6L4fMJh7Ty8jG5YkckYqqv
         wEvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785757191; x=1786361991;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vv6DECOvSmngHsx3EI9j0R7ut4SHpWl9EkNqXk3pPjk=;
        b=PImurL+Yah2XPMxw+EKNyE9FY62FjjJ3A/6nM0b5v1ro5GgXaTFWicuVlMAMhVcDmr
         rBbcjfZqolPKAjNQlFI8uRKfUWX7aYwTeTwbhYgLEuoQb6xJvn5wGs/7dCLFZIkM9cGk
         3Fx55odsmVetqT/UuXNBY6SCVHc4yf+cmN0u6JPMIBKA60ASmLxF+j3lwxiDIXezyIgW
         qnjRXp0MVCCT0OCDSUilSQ7rZK4IPRtURIp7/7vEKBBuFVCRXeqW6ZSNRjP5hLky5Oju
         9spwp5hzgyT7B1Cpwpl9MGQfZk0EOKAbA8txFeV97dEpz9TkpwCkgj7b1Su2k2KU4KGV
         T1Hg==
X-Forwarded-Encrypted: i=1; AHgh+RpAL+CaCSVt88av4frX+Gcd9XCIya8RQHvluBug3ZMLpPzhELmPgWZpUHys0seQuAME6ca7WPcFBA==@kvack.org
X-Gm-Message-State: AOJu0YzzC5aQ8APjQyzsT++Qli1QpHYgt8i72wlmh/vYf6pzp2RrxtOY
	5+Pw4zjQfzi3YGRu3MbDecbCttQaYd1+IlXJBk445/xcXUh/aZ6aUxFFFlFBQ0PKtQqs91XUies
	Oig==
X-Received: from pgvi9.prod.google.com ([2002:a65:61a9:0:b0:c9a:c533:8329])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e58d:b0:3bf:e3d6:ab5a
 with SMTP id adf61e73a8af0-3c92a8f327cmr10771333637.52.1785757190359; Mon, 03
 Aug 2026 04:39:50 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:39:42 +0000
In-Reply-To: <20260803113944.3694290-1-praan@google.com>
Mime-Version: 1.0
References: <20260803113944.3694290-1-praan@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803113944.3694290-2-praan@google.com>
Subject: [PATCH v4 1/2] kho: Introduce a helper to init high order pages
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Samiullah Khawaja <skhawaja@google.com>, 
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5F685A0003
X-Stat-Signature: tm8n8hntmegm4ocxf8egoxm4u8w75sz7
X-HE-Tag: 1785757192-535691
X-HE-Meta: U2FsdGVkX1/dMu1RiVfdVd1HwLrUzm6Id57o+5KvRTdzXfAbN6VDbpjBF5nwgUKqJApOC07Ij3Cf6uV7r/FEQm7/KTksl2ORtYVsKrlihHSe3rUiIFW9YJAgfdybfERNzsIbBYrmH8JOJVvywV9Y4XlBL3bqD//rIrw2jskoOno0JJV621y7wBvKBiRI6XMn0p3sWxLIylqp7dqUBVNBASZO4KrdoNuGnBmZpwV8zKkx6miIIxDRRuZA7kH0QoDR/6s1HeYh5apLlYghZnstOemP9MNQ/S+oUyiv2NJ0BhHuTuQR2G7lgG/p+4DTK3hL0EdDmcLo4qMT1XKLA3wkRYObBDW4uEWuw6jo0OiNkNPUsiVsPwuRuXGtPToqfJk0s6YYpCSgxG/I1NA46Qt58V/FDcCG7wsCDxdU0/0SQi8OWJSbKOSaYglmR9+GiQWaTOoc/t0dRaGrUgiHjxrCWAv8iaucu5lAp+BejxaHJ3/KKts9PMpmxc0uQRv0Vcoe+6lMhJIrjfCMrCemKpZxXtpy+2B3SH20Ht35FFkq1HueEY2rrHmenSt/+eI7AN9JJQh1rrE2ma8VthGxUnLgBWjUbNokPJaBn2NCdrFDcghYeAO62m97ypUXzRHbizCrBNLCd8bHpF/WLY7a6rmgwBBfTtCYwvxpr0tSXQj93N9AVTMfA0Vk6jUjTMR1h7yNH9ewRvcq5qzUv0XGjGJ+kWrS/4ZMYb1gZGqKvQk177Zvp/xml+t3oREBZJZA+Uq1ZeXfuLq69gzZbuclpdGA1w4cCXcOK/MuRharivPL6V4FlJDI4z7WVXpEiF8CTBO9XlA+P3+JUMIP217Ur1sxy7mCZX5v//a8soM2fiEIm26v5kFe8mljTd1YFUsRXBPBrID6w9km00xSxpHNN67AtieFe9l2OdMfYJpROnW+hX0Vdd6Q15KZnpTcg8+sFfLzVC95epQivD5vota8eCN
 5iPUnK33
 ADpAPOxXuwLBCOpVR2lmVimGF6RoG312RIaaeDpQBEqQSsxRzgW7msNJEXxgZnTmZSZEkz9YzSTWYfgKYfP2JkJW1qiRykDpBNFn2iAPUJJ+C++vXMUzcoxHFODtV+pPvPEvAxboHAPR9lUmLW2XoamYU+XOJdoo3lzkRJPL3dt/sOAeEufQ9vpmAWeMIYylPYti+HEsL3lZVSAGfBoYm6HlPm7kkNJHMjil28rChGFpXZ+wWWlh141wMfICfp5pH9LZ7IfVLvrDg5AxN8rJTiZV72YFctOP6bBivXtPcMW/Q5E2+f7yk0E+tpXMPLrmRvSxUkgxk4bIBV9zXyP1Zf9UzMlTrkquNYYZUaFB/7mAWnrG2g67wZRUAb/mT+Yk/thdaOazGSin1ouiDZWEeRU/E8TJHcdKsy2kpMEAr7jWjo8bShIJsDnahSmpr6N3f7BcqM0K9lveSGub71xKWgq4p+P+VPem1J1BuRAyXUyzCbWQEDfEhMKRSKWT/gUQRn86/D/1BE//nLZUANXt/c5EWc4o7jq89evAF9rusJuo3KJFP1gEitqYr0hI7vVGUy/w1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current KHO restoration logic assumes all multi-page blocks are
split into independent 4KB pages. Break out a helper to prepare for
supporting high-order non-compound pages.

Extract kho_init_high_order_page() to handle the refcount pattern
where only the head page is refcounted. Use the helper for folio
restoration that requires a similar refcount logic.

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 kernel/liveupdate/kexec_handover.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4834a809985a..e836efd98795 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -357,6 +357,24 @@ int kho_radix_walk_tree(struct kho_radix_tree *tree,
 }
 EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
 
+/* For physically contiguous pages. */
+static void kho_init_high_order_page(struct page *page, unsigned int order)
+{
+	unsigned long nr_pages = (1UL << order);
+
+	/* Head page gets refcount of 1. */
+	set_page_count(page, 1);
+	/* Clear head page's codetag to avoid accounting mismatch. */
+	clear_page_tag_ref(page);
+
+	/* For high-order blocks, tail pages get a page count of zero. */
+	for (unsigned long i = 1; i < nr_pages; i++) {
+		set_page_count(page + i, 0);
+		/* Clear each page's codetag to avoid accounting mismatch. */
+		clear_page_tag_ref(page + i);
+	}
+}
+
 /* For physically contiguous 0-order pages. */
 static void kho_init_pages(struct page *page, unsigned long nr_pages)
 {
@@ -369,16 +387,7 @@ static void kho_init_pages(struct page *page, unsigned long nr_pages)
 
 static void kho_init_folio(struct page *page, unsigned int order)
 {
-	unsigned long nr_pages = (1 << order);
-
-	/* Head page gets refcount of 1. */
-	set_page_count(page, 1);
-	/* Clear head page's codetag to avoid accounting mismatch. */
-	clear_page_tag_ref(page);
-
-	/* For higher order folios, tail pages get a page count of zero. */
-	for (unsigned long i = 1; i < nr_pages; i++)
-		set_page_count(page + i, 0);
+	kho_init_high_order_page(page, order);
 
 	if (order > 0)
 		prep_compound_page(page, order);
-- 
2.55.0.508.g3f0d502094-goog


