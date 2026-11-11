Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57E6060A5BDC
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=DJNrLY8G
Received: by kanga.kvack.org (Postfix)
	id 5E2F06B05B7; Wed, 11 Nov 2026 01:47:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5966B6B05B8; Wed, 11 Nov 2026 01:47:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39A846B05B9; Wed, 11 Nov 2026 01:47:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E92A86B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:47:26 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62DBF1401C9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:26 +0000 (UTC)
X-FDA: 85421906892.28.CCB6507
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8B5EA100005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=DJNrLY8G;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1hLwQVyMwUi9E19JxtZsIeEAf9lJS52psxbgdcCZj9M=;
	b=xeXIQoAx9S5p4wp18m/JL+WvqqjTNXnvM45D/Ur2vH7hgVl1sgDsOsl2UnAJSNC5CrnO9+
	sV7sArmkMtAh6F14QdjMIEXPGk0YppVkICldTTBCWzyGj2ws0tz17CDETCiOdXuIUU3XNX
	QAlK8hhTRodAmRhy4+4LlBoZf+EWM04=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379644;
	b=Q1pDmeDPbU+VX/K5rwfuKDcqqgCaITF+m7xoSxMr4zvnNL3d1+Ni/w7K2pEOZXc3uVuwPQ
	1E5SQB1gGhzJU+Eow6O2UP0S93odUbuuv9qgRRKkYwK1UBRAB4Q/JjT1NZ/HsTwCYaP5rC
	8Ei5sesmojAd/C0qnCbGFKapNx+kXnM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=DJNrLY8G;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cc147d86bebso1641315a12.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794379643; x=1794984443; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1hLwQVyMwUi9E19JxtZsIeEAf9lJS52psxbgdcCZj9M=;
        b=DJNrLY8GKe/d4AOPb7IfO39e7Foz4tuVc9Up+QUNGbMQNRGmIceYeq7nxyRxiCN+bH
         /gt3sSbuc8UBJH2oRcy53Pw10afAvllSm0Ab8aUuYkJpy4obiKJYzrH3IYNqnSUfKnoV
         rGtVZf0vvcIuhrK5etuC6tOefryOphcrCjR4E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794379643; x=1794984443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1hLwQVyMwUi9E19JxtZsIeEAf9lJS52psxbgdcCZj9M=;
        b=lHJzA2Vpi2QWYgQ+9Z5YXDuSzrJBg35bCteh1/Epg9NUuB/FWNyYRgMso3dEKFdIhL
         BRR0NlzU7Gu0LIW8MRPcmsVhAeaOWE71cUa1e1q57pCIBRUxaNw7oFECjS86BpKAfQMJ
         Icv93kKFXbtusDI2xcY/zWPE2EyV6//EmiC9NW5UeOom2vlEiRDDQKHunrL4NuVbUDJ5
         qrbxDU86r/joLe57CFQvKp0skA9+DNs5wLxoTZcHcQxyZDkoyI8uEFMaNpzKV3RIgN9e
         dsNeziYVLZ450/4wbWGcW/X0XqQrMZiDgWDZN0BxScibVn59Qax9g3o8A4PyoPmqOHJJ
         PUGQ==
X-Forwarded-Encrypted: i=1; AL+hErH2FqgdADrBtqgWWzKoU/NZGr8ke17UJ+7amrBey17vSPVz2uHAUsxNQ6FYzWJGJf2guOZddKD9Hg==@kvack.org
X-Gm-Message-State: APuU4Z/2idVzy596OznObwCwQyoP3aKAaspk75RYLVXwaMqMtYPsENz/
	46riHDcjWqxwqr42i29fxIdghhhqe/9Spc2+vGywuy80WwsXrfs/+OAP0Xa3vZAalg==
X-Gm-Gg: AYBFou1kHGAZmg7bnpmTabqYmy6X5FHQb4zIrUXdWTDLqoVUEvzivEe0hc5bOZHrZBt
	vLtE8BXx/DEGjl8/GIMZugHKzia89kxaJFQ0JCdrZ+KmvH3253ONAdJgFD9c1NAitZpIRxRGTRE
	2SPdo5DrtyHWM1I2/PbDYUiE11f8WsXI+S7CmZ8uzvEYtiq7VVMFQZht7SeXLV/qfnSS2P3s/Fq
	GckRfUCXRrI1mJPmfNunXBcdhMeHvlgWbaHapQgIYMLOzHVv5iVjDTv6kvl9zNhAClCJ//9sOu4
	dUZN/i/f5J9poK3A6hW/FNQQJ+0qFhmlkaeTH7tyTpDJ6K50eWmX0n7OoWrFx/W8W3xzhqcxAcw
	SRCPlP4EmF5xxdvoj0UsvJelEzzKeHUSQzKoly6UxZh831PSDpCqAjrIaJFDPjV+pELxM6QQwLZ
	pWm1fXo13KiGxRTxGsY0ZeBTS2wavYRy2bAu3h2Pfe7Nah7YldQPl9KBl98qeAVggFXbOG/EWkG
	xPr0kMWriPP90TJ/jSwIv5EUUVgtG/SRV/Z56EUCSv+z67KYXmeoKps2ZrXhF00bLeSovEXHBno
	a4wYfDvLlEWMvlzkFCxH+5OAFfxhYeSOPFX6UnCc+3xgfpR8ZLMvLmibVf4JN/xFpxNI7e9ltU6
	5C1p0eH4TIhr59pH3Ag==
X-Received: by 2002:a17:90b:518e:b0:3ac:9a5e:9cdc with SMTP id 98e67ed59e1d1-3b167ab877cmr4231873a91.19.1794379643365;
        Tue, 10 Nov 2026 22:47:23 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db85a9bsm3268666a91.14.2026.11.10.22.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:47:22 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v3 03/11] zsmalloc: return handle from obj_allocated()
Date: Wed, 11 Nov 2026 15:46:26 +0900
Message-ID: <20261111064707.2568433-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
In-Reply-To: <20261111064707.2568433-1-senozhatsky@chromium.org>
References: <20261111064707.2568433-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: tjx1xreoabqp9wqmanroyooe8883hxtu
X-Rspamd-Queue-Id: 8B5EA100005
X-Rspam-User: 
X-HE-Tag: 1794379644-337521
X-HE-Meta: U2FsdGVkX18j87EmTUdTPBXkGOUO7n682vFhIokP/syDA9tWQEQwA9HyFiF8rmCL0gVnHIKaYUjMeUaLdsDSVztsrCEXgfNT/T2ZX+JlPe1Bfm6s3XSQg9BaeGW9VJctFxP1n9Muwh25d/aEsVw9ry/VePcHZgQaHzndJI9C2uvUYz1FO1+/tptbT/TdzHvY95IT5fTUg4vYWR+AqOj7NGt6egeb6/XcYEXoJW9HFBIM6xhqCemPTcucL9mXsP2s/KeUMjtFws69i+/iR2VgJj+0U4XyxVtDuFtWlIKsdncrPFFMurrPFLo+9gdL9B5BmheE0Ysd4nW0XkVvK08gojiiAjNpNiSRuJDttVlqIPsqVh/He0j65PnAxJ7PLcYVNrKu8xnhVuLUiHEwMRsE6wr68gy3P72JSHqSgQWvMiFU0wzUzEkQtRecEl3IqMGWxFyrh669EEkXeyNWIpWwQyvDsPdhc1nDpo6lSKTLySvWTYFlhz1zyh0gpuEVc1KbJSTnj3//C+InYbk7+mA/lET5uY4/rcLLqjA6ZuradCWrhWwI9l1y0MoJwuYUMUObTnM5ZiAEA7423KB5XTzUSbC+5BWytnclHcWaIVem+vlwtPp7zxBPMQa+WG9JDrUH9/lvGISHCUlUrQaGkwx+5k1CtoWcxQOahKAVf3X9vh8ltby1+ZVjK+w4iiBQwOLMCNoLnEznyl12PGgF+YKhfLPsCd4BZjGl5URSw4p8w0Z/UAFmCTpzuI4UNUN6AMgWfKz8oBq22goVrOzhpkwaRJtJKENcZ3sNNp6cwitS8WB9PwXWQiiMdwl3pQXtbeNFhQZq/LjZuQzrfFKQu7ZjGnWMtm6hCEBzK+3ITgboFKbdSEqmnRBdSPdOtjahwMOz8l7wvJ2YLJcBgNluJdaJgDvS83moAhpGhdvw8bQ1rehBwnKfJ3t9ioNla5xIVy6T+6wDqFOfXmfPOuEkiyc
 dRXuhSAW
 nHS25JlHusY94sM30oBLC84ikmSdhGCqwy41EHJNeTvRBk4H0yrJMJzeiP9ktpR/Bn49Hzv8NoaZjEX9ygMzwJagV3EcP49NnWDaeWcMImnhvt/+RoEzN/iNgMU3xDBxjBSbXZvl8tEhqw5RssUS3PxmysbCPPYMZ391jE03EvhvnYAML1/EhLAcL9+ytReecCE7GMfdo6ilgMus9Sn+EmrybVXj+UnddD0msBmrvoyZnRLxoMNPMsJRWVH/34seZJw0LjVeeusWF/4Z2wdPLsTzCoCqYBs4UITdBXDPNCKRMQKjY7sWhxYv9od420kXqepVnagYLwtgHL44lhHKSZu/jJb+y+RLMjnw2ivYtazGVe1bSqRo3DXWXHyE8UDO6i+wOTO1UaThFimHoivsT6+qbHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Allocated handles are valid kernel addresses and never 0, so let
obj_allocated() return the handle directly (or 0 if unallocated)
instead of returning a bool.

No functional change.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/zsmalloc.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 7ef80e0da626..dab71f582103 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -822,8 +822,7 @@ static unsigned long handle_to_obj(unsigned long handle)
 	return READ_ONCE(*(unsigned long *)handle);
 }
 
-static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
-				 unsigned long *phandle)
+static inline unsigned long obj_allocated(struct zpdesc *zpdesc, void *obj)
 {
 	unsigned long handle;
 	struct zspage *zspage = get_zspage(zpdesc);
@@ -836,11 +835,10 @@ static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
 		handle = *(unsigned long *)obj;
 
 	if (!(handle & OBJ_ALLOCATED_TAG))
-		return false;
+		return 0;
 
 	/* Clear all tags before returning the handle */
-	*phandle = handle & ~OBJ_TAG_MASK;
-	return true;
+	return handle & ~OBJ_TAG_MASK;
 }
 
 static void reset_zpdesc(struct zpdesc *zpdesc)
@@ -1571,7 +1569,8 @@ static unsigned long find_alloced_obj(struct size_class *class,
 	offset += class->size * index;
 
 	while (offset < PAGE_SIZE) {
-		if (obj_allocated(zpdesc, addr + offset, &handle))
+		handle = obj_allocated(zpdesc, addr + offset);
+		if (handle)
 			break;
 
 		offset += class->size;
@@ -1824,8 +1823,8 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 
 	for (addr = s_addr + offset; addr < s_addr + PAGE_SIZE;
 					addr += class->size) {
-		if (obj_allocated(zpdesc, addr, &handle)) {
-
+		handle = obj_allocated(zpdesc, addr);
+		if (handle) {
 			old_obj = handle_to_obj(handle);
 			obj_to_location(old_obj, &dummy, &obj_idx);
 			new_obj = location_to_obj(newzpdesc, obj_idx,
-- 
2.56.0.542.g3ef89b7020-goog


