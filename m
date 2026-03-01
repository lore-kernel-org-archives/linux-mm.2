Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6B43FD0057
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 13:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE496B0005; Sun,  1 Mar 2026 08:20:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5FB6B0089; Sun,  1 Mar 2026 08:20:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1766B008A; Sun,  1 Mar 2026 08:20:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC3C66B0005
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 08:20:47 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 57E001A05D3
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 13:20:47 +0000 (UTC)
X-FDA: 84497554134.11.7BEAADE
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf19.hostedemail.com (Postfix) with ESMTP id D471F1A0002
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 13:20:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772371245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=N70PHx70HemaU0/j0mqCP3L/B5OCEkq4I46VvoZbMko=;
	b=AIOogGKlDnFTlm1TSAb6kNI6NmWwrArlFDj/KgrXBQexroo+AhN5SZR9rG+LU+lWgCqRic
	l+BXVvbf9zWz3B1PORA8ZchFdh1oyotyIrjbA9WZdxoxSM+cKJy+/P0JLnh4u52fq15CJ9
	rpsDvxE8rCEjiiF12ZI49qWWJP2KmYg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772371245; a=rsa-sha256;
	cv=none;
	b=WCAKVC19wNszrmGlVjA6t7KT2pwwzfq5McFeaJy49ewmye19ANC2SyhG6eiZvX4u1c4LdH
	c+qanhyTqeGSqXYRD2CdsA/KBj5PwpKRXcTp3TtvirsTGV8shVnjfCgHkGGx6qqocDZ8vX
	rLDboWej+/kVlaxgOgG9t+KPeAlAICo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fP2jj3PkLzJ467w;
	Sun,  1 Mar 2026 21:20:09 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 49B3440086;
	Sun,  1 Mar 2026 21:20:39 +0800 (CST)
Received: from mscphis00972.huawei.com (10.123.68.107) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 1 Mar 2026 16:20:38 +0300
From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
To: <gladyshev.ilya1@h-partners.com>
CC: Gorbunov Ivan <gorbunov.ivan@h-partners.com>, David Hildenbrand
	<david@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Zi Yan
	<ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Muchun Song
	<muchun.song@linux.dev>, Will Deacon <will@kernel.org>, Yu Zhao
	<yuzhao@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/1] mm: make ref_unless functions unless_zero only
Date: Sun, 1 Mar 2026 13:19:39 +0000
Message-ID: <a0c89b49d38c671a0bdd35069d15ee13e08314d2.1772370066.git.gladyshev.ilya1@h-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.68.107]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: o3bffgwzx7s7y6riox9jo83yhsq4heq5
X-Rspam-User: 
X-Rspamd-Queue-Id: D471F1A0002
X-Rspamd-Server: rspam12
X-HE-Tag: 1772371244-339124
X-HE-Meta: U2FsdGVkX1+uLrN3qHNaV4fBNQDgIXE2j1/BUea/W++hxcpz7E55yx6M+i5UmNbOfUhX2FQXdFReXlNVu4Xz+UQVDhzB9e+nNVrRVh3IjXk1SmvxG9kWE79MRJ41k2AOsd6S34OAGmDmoMZW3XyxACKPtijz/JyfWpFrZNtB3vDhnCw9eHyhNqObR/zEvemZ8c2f3peBvXciNQlEdZgLXLG5+eV56VHyO7h4lvYxbg9KtzrSePkZgtyS8S0JCM7+z2yAqbDDTZLkcIHCJ/+3nPXVSb6LT/1tzwCmT+NkkUZqRpEerEfayv/J3pcuOcGQKBXfg1RPiFOxh/fC3phEJ9NPOVtBy/YdT88D4K/yYFZtOBga7ANOp1vttRrA4WDvixACQ9feFHvWpsgoNcSkLxNdiFqh+p4cL49tLM/rLpAx897W+prX645J25fXuSVexwYxxGp8j3Ir3bEtqiVsrJKEiD98A82bSbK51qB1r07q65OVuyi8eDsHJekqS4SbzIfYKs6Bt8S9L2XYujJCPl8vtc6oBrIF30N/WtVyx9rKtb8xhkUoX9CfA04QKO398C0PV+1l5MCAG6dynr5ACUuY6HIDbQWkyLZdD4IX1hKxy3EJ1MxohFRi4BGPdcBdkcBulsA2S2461UcnnOUexPyf1Sv/j6BYwQwYuiy9IPXaRarrJTptc/PUFhKcVoIYus63zYZZBXea1C/xa53qnVxF3clWJ0qSqhAWRGa9aTIBsoCodtOYSqSGj8gCWB3bvoFTUFNVPkqOWfvWvgiCk/bFtD4QOULUbvJi5BPKu9AjQiDad/468LkoSIesGnWzayYUK7tzR7fyAyI9J/mKsZf8xdidgINuNd9tYgwGSECX7N1IOm9Cl8PSJ9vVw6DaKMLWZQOeSM9bXbGoHdF5/v9bVnniLuydj4XvtOx+UD2AK0c4Ty3drOFIfhH2r4TKE1C+ae7klxEbFkZB2af
 vKm7YkhO
 xJX00NsCUs1lTXQ5HcrH0y4bytyrx5yduvmWZXseBNlRjy34VbpK8sRAZrH3V+nR62ojvxkpv8ut5pRJXiPlZJt786rS53eYmtvPs6o2Y9dcor6rKUZUo5IXvz5IxIlCbdRw1k/K3sdLZikEf9Azbfv1sHy6ZzJRtLM/fYuHKzFLPnS5G1MS4nW3kBtjIpHJo4/azWTmcouJjL+JKBSiDd7cK4+he91hylVYOZ/KmcIfT3EhrLKNX+m0tmj+rFofF9/X0y7TeU02GvHMGuVi7bfc/KawLX79rM1aDpFbV3OlQYcNnigVP5uEDlCmVBV1GVGMt6FFg1f0Pqj+9oq564SOSWRq1/SIMlIn0WvXdVBm5iCc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are no users of (folio/page)_ref_add_unless(page, nr, u) with
u != 0 [1] and all current users are "internal" for page refcounting API.
This allows us to safely drop this parameter and reduce function
semantics to the "unless zero" cases only.

If needed, these functions for the u!=0 cases can be trivially
reintroduced later using the same atomic_add_unless operations as before.

[1]: The last user was dropped in v5.18 kernel, commit 27674ef6c73f
("mm: remove the extra ZONE_DEVICE struct page refcount"). There is no
trace of discussion as to why this cleanup wasn't done earlier.

Co-developed-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>

---
Changes since v1:
- Rebased on mm-new
- Remove mention of the "next patch" from commit msg

No functional changes

Link to v1: https://lore.kernel.org/all/20260206133328.426921-1-gladyshev.ilya1@h-partners.com

---
 include/linux/mm.h       |  2 +-
 include/linux/page_ref.h | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a68f065399ee..1294d29c8d93 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1506,7 +1506,7 @@ static inline int folio_put_testzero(struct folio *folio)
  */
 static inline bool get_page_unless_zero(struct page *page)
 {
-	return page_ref_add_unless(page, 1, 0);
+	return page_ref_add_unless_zero(page, 1);
 }
 
 static inline struct folio *folio_get_nontail_page(struct page *page)
diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index 490d0ad6e56d..94d3f0e71c06 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -228,18 +228,18 @@ static inline int folio_ref_dec_return(struct folio *folio)
 	return page_ref_dec_return(&folio->page);
 }
 
-static inline bool page_ref_add_unless(struct page *page, int nr, int u)
+static inline bool page_ref_add_unless_zero(struct page *page, int nr)
 {
-	bool ret = atomic_add_unless(&page->_refcount, nr, u);
+	bool ret = atomic_add_unless(&page->_refcount, nr, 0);
 
 	if (page_ref_tracepoint_active(page_ref_mod_unless))
 		__page_ref_mod_unless(page, nr, ret);
 	return ret;
 }
 
-static inline bool folio_ref_add_unless(struct folio *folio, int nr, int u)
+static inline bool folio_ref_add_unless_zero(struct folio *folio, int nr)
 {
-	return page_ref_add_unless(&folio->page, nr, u);
+	return page_ref_add_unless_zero(&folio->page, nr);
 }
 
 /**
@@ -255,12 +255,12 @@ static inline bool folio_ref_add_unless(struct folio *folio, int nr, int u)
  */
 static inline bool folio_try_get(struct folio *folio)
 {
-	return folio_ref_add_unless(folio, 1, 0);
+	return folio_ref_add_unless_zero(folio, 1);
 }
 
 static inline bool folio_ref_try_add(struct folio *folio, int count)
 {
-	return folio_ref_add_unless(folio, count, 0);
+	return folio_ref_add_unless_zero(folio, count);
 }
 
 static inline int page_ref_freeze(struct page *page, int count)
-- 
2.43.0


