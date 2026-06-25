Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E777CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700716B0095; Wed, 24 Jun 2026 21:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8926B0096; Wed, 24 Jun 2026 21:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE866B0098; Wed, 24 Jun 2026 21:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6306B0095
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:22:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B9AD1C3323
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:22:56 +0000 (UTC)
X-FDA: 84916685952.12.93010E5
Received: from h3cspam02-ex.h3c.com (smtp.h3c.com [60.191.123.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id C3534C0002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:22:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of qin.yuA@h3c.com designates 60.191.123.50 as permitted sender) smtp.mailfrom=qin.yuA@h3c.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782350574;
	b=F6C8FuDjKCApGyLpwHVbj1aYS0zjbkbSwxXnmNebKDeaPPjWZNrlrHvOecijZ3p4Re622X
	za1q+mAMKc9zbiE5K+ggINB7/xH+Jk7mgxrDRcT2jkKE8LWOAdeb+jLXT6Oav4X4x3g+NZ
	66akZgdEn6mryE0JCeEwjtDAA+ipts4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782350574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=j58kmwGtgX3DeQ2MGQItqqH6F1B+g8O+/M45J61/AeI=;
	b=nCyogFXy2bz3KNCvsOLRNAgDOKNBOXRg81dpHkwiwDp8KYurlpcyZzyb0fxdL+a4/+U+hZ
	XO7jJMDumL2TP2D2gjMS6WDcX8sD048uxmqiUCi4K5sGbNzVLIn8bRr4NRIzeY7lmXO2pG
	mne1ziI4HJTM03wXMgvS3k4k5pb1hyY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of qin.yuA@h3c.com designates 60.191.123.50 as permitted sender) smtp.mailfrom=qin.yuA@h3c.com;
	dmarc=none
Received: from mail.maildlp.com ([172.25.15.154])
	by h3cspam02-ex.h3c.com with ESMTP id 65P1MNJA069473;
	Thu, 25 Jun 2026 09:22:23 +0800 (+08)
	(envelope-from qin.yuA@h3c.com)
Received: from DAG6EX08-BJD.srv.huawei-3com.com (unknown [10.153.34.10])
	by mail.maildlp.com (Postfix) with ESMTP id 7965E20045BF;
	Thu, 25 Jun 2026 09:35:23 +0800 (CST)
Received: from localhost.localdomain (10.142.164.51) by
 DAG6EX08-BJD.srv.huawei-3com.com (10.153.34.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1258.27; Thu, 25 Jun 2026 09:22:21 +0800
From: Yu Qin <qin.yuA@h3c.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>, <linux-mm@kvack.org>,
        Yu Qin <qin.yuA@h3c.com>
Subject: [PATCH] mm/damon/paddr: remove folio_put from damon_pa_invalid_damos_folio
Date: Thu, 25 Jun 2026 09:22:01 +0800
Message-ID: <20260625012201.2937854-1-qin.yuA@h3c.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.142.164.51]
X-ClientProxiedBy: BJSMTP02-EX.srv.huawei-3com.com (10.63.20.133) To
 DAG6EX08-BJD.srv.huawei-3com.com (10.153.34.10)
X-DNSRBL: 
X-MAIL:h3cspam02-ex.h3c.com 65P1MNJA069473
X-Rspamd-Queue-Id: C3534C0002
X-Stat-Signature: b1ydz898fboopcb98yfo77ziuszuoj48
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782350573-413237
X-HE-Meta: U2FsdGVkX1+u5KixNleio5zvEGGBKaBSmHMR+ll23MNZlxbF/xCfd//bdiDj8ZrwkWnf5gpoYBSJlSvPl/EqtKmVPIusDlzVpW6O4vFHSTxfY5K0xN0HAMG0DHWbxtcQA49xWvo3AYGO0uFfbTUYj52dIwrwtJlKLjOMlVaiJXGeCucyBI6MXVKf+OieFVqiJvJBdmWpQEsKEGBAchU9qUboskyS6lJX3/acVHNZy4i2Im2w0aclpJ1ayxUT9TftlSWZY+UMedsHRkPFbD/difZf8d2EoT5tSEWozvplvDhFmwrbkRspfGypENCeDyzTXZomR/9PCQ4sMu7C8OY6SIgUAdEQrSayJ007tECausT3o66kGuX7CFTQgXe4OTTnp5C5oR3IYud2raUvoiUkYyrL5vk6WN/Z3ttgjB9SzOdJB3ZP7HEhPGnjGoWcKPj+VHQKQVQfV9wAqFqnfTN68KeUalGi6C6fTJaMY7q7jITmtHgfVZbJVOfE0lYbhOs5Bb/xAu75z3pHa9BnjFYLgEx8tCLiLL27/jC4l/CQS63JPKK6CNVfscza4f3JNhigkNFJWWC6K5P0DJDlIz4nvDzFwl8jYDj+uEpWAWiYHxfH9aVt5K5SaZpd80tAv3+C6+Y/u5dUppM0P0xR3KPN7BwZDSGtBRk8UaEdXPqY3bZmKs7L6CGUFlXgHZHU+Rdnm/Aj2pcP4I4gQmWzFEmC5nf9WBiyArNdtOruLiodSBJb5ZdJglANdrdyWsI0FtTD/sm75uDp7JWzgdgNrOfnBf4aaPl5iWP4YSQi2MLQPH7cnaD8C2irxcuHmMsZCZOBKM0GUv8/1ICkYH3Ldycuxq1B6sk3Xe/u95oj8GtyCZH5ljaiRKQuBtiwuyWi32fbmC5FUOYtBgIfudEb1wU/3kwj8ZthxAfkro7AnZZgItQfsh/ND6bnoIo1KYsTaNmVLrjqII03piDG6p8GtTP
 uouirHhc
 54S6Dr83RlZtiFcl14tZZOsjmY3bX5syJPFOjoNV3uAKqQPJMxan4LSmYhb+sPc5GgodK32H5Yzb5WCl2it3yDfCx/4g+Z2XUSQkfubbyn+dipVrSnNUpnTBOUVQ8msJ2zmf4dor3omMfT224ohdyMM5vxIYm9wtd3x6sgzXhNqsFnlkGnC/4aXGJK8lUEZulGPhSjt4k6ZKspT5PakZSF75FDSVOvmCwNORp6pT9Gf5UXIXknQfBs9LbaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This boolean function called folio_put() implicitly. Remove the put and let
callers handle it explicitly, making the get/put pair more clear.

Signed-off-by: Yu Qin <qin.yuA@h3c.com>
---
 mm/damon/paddr.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 85cd64a55..f45c7939a 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -313,15 +313,12 @@ static bool damos_pa_filter_out(struct damos *scheme, struct folio *folio)
 	return scheme->ops_filters_default_reject;
 }
 
-static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
+static inline bool damon_pa_invalid_damos_folio(struct folio *folio,
+		struct damos *s)
 {
 	if (!folio)
 		return true;
-	if (folio == s->last_applied) {
-		folio_put(folio);
-		return true;
-	}
-	return false;
+	return folio == s->last_applied;
 }
 
 static unsigned long damon_pa_pageout(struct damon_region *r,
@@ -353,6 +350,8 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
+			if (folio)
+				folio_put(folio);
 			addr += PAGE_SIZE;
 			continue;
 		}
@@ -394,6 +393,8 @@ static inline unsigned long damon_pa_de_activate(
 	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
+			if (folio)
+				folio_put(folio);
 			addr += PAGE_SIZE;
 			continue;
 		}
@@ -442,6 +443,8 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
+			if (folio)
+				folio_put(folio);
 			addr += PAGE_SIZE;
 			continue;
 		}
@@ -478,6 +481,8 @@ static unsigned long damon_pa_stat(struct damon_region *r,
 	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
+			if (folio)
+				folio_put(folio);
 			addr += PAGE_SIZE;
 			continue;
 		}
-- 
2.43.0


