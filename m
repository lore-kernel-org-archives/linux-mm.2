Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 102EFCA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F21436B0088; Fri,  2 Oct 2026 05:55:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1A36B0095; Fri,  2 Oct 2026 05:55:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC4166B0096; Fri,  2 Oct 2026 05:55:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B03016B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:55:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D37E1C37DF
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:55:43 +0000 (UTC)
X-FDA: 85277229366.28.C07A435
Received: from mta0.migadu.com (out-202.mta0.migadu.com [91.218.175.202])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0EC78C0006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:55:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BQeAY5xG;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.202 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790934941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLajjHfJC4lwgRqk/jhRT1cUOfWTvyEdBZXlSjSA4xY=;
	b=iane7ub5WpL/nPkon1dznJHQVdN3gyIhs95QWHTjX1cf5dkjuD2nz9vybFyPbScYGMxbBj
	98nWFrPGHgM0sV2yu3xHALtgB+wCbsniHUuUfXRsaMDgGWbyCGkYIQTRggZ+fsphb901Z3
	xXA6Il41pC9UWGTh50uhcnUndfWtucc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BQeAY5xG;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.202 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790934941;
	b=TPl/FNKaP5ySu7ketkjqQNKeiAKdNZKD0iMID8Nkpf5qvJFqUHd2dn/EkOAhY6UcHN66zM
	EzREHQQTsaXm/qFmjbhWZVlsPI3PZa98rZgQsUYC6XyNNcrvn8BxunvarYS2WPfk88EmQz
	nmbB7a/yzt2Pwfcichiuw8uQccE7UJU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yLbeu8NRgqnSY1gRBUCVHYrl5OSNM+m0QrzlFEGTHE0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790934939; v=1; x=1791539739;
 b=BQeAY5xGka7UonfyzgAKdJFXsrN15pIneVD3mcJ3aGukjf0CVK7NnuP7m90svGV2KCwLcoZ7
 GMnzmo89J7XSyIqWxAvIMyYVLnfFA13YBOo3qwdMHtJrUyzYq8KtlfDhwsgRVSpEAH9zTbppzmz
 wYySJqEboefe72aR+HuzV/C8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 6ad150664b81311e;
	Fri, 02 Oct 2026 09:55:18 +0000
X-Mizu-Trace-ID: 6ad150664b81311e
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v8 01/30] mm: rename pmd_to_softleaf_folio() to pmd_softleaf_to_folio()
Date: Fri,  2 Oct 2026 02:52:15 -0700
Message-ID: <20261002095503.3585565-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0EC78C0006
X-Rspam-User: 
X-Stat-Signature: mptxux9ihy5hfn3m6ept687kpeoetu9n
X-HE-Tag: 1790934940-176897
X-HE-Meta: U2FsdGVkX195eItJVd9O+Hofh2Serpl1VFHkdBzwybjs9HvVwG6u6IBESDxhlWydVDnS0k8sARkmN60UH+NvoHdFbP/rhknMdpWqDMaJyHZaGcHpVusyi+O8RzlMR+kdfj6Af7EO7DazbIlofrPqsL9LhMsN/pFQbc2339SURO9ZBP2ZJQRnOdMt5cbRDMf1XEqojSNU5eL3se1E5Px6k00Xq+gHVbbryDgoT1Ee+wOGtxkQOAjBd4RsPH+/FJfrifbPLJUppqJf2MElx5Jy69AUTT3Lh27QbqrWsABifZ2dYjKXW0QTzVksZZljc3cX6KIU3c3U7hko94NmRPRjloYF8OUFO6tBvNTpTMnJpnM292UKzW2ALdPbnpeiFFt73SXWVr3Gm9ahWOnjriwrUIEeC7CIfaOHHF6cJ0fDpPekzhIAYPoa7bMufO1bqlwp8sKWdrVoLv2WL/M3LatZ5AWkXE+5Cc4+eBt8c/BRff7fjoftNj/K2xM2hIh0z6vhB2RS2XC/qPkGd8FKyUX0knBAgEaqH/BGuifhePw8ugRosmQjWVejWeYJpl2iv4sJfJW5jO7+BqF5l7DYmSYx8cPKEL58HCosjH/dFl63+FJks3yBrvQ2GIhYs8/jVCdmIOi/7re3MpMGErUnS/+Dc/brlJXAjtrS1+8Pew/7ZNZd6kI5PmPaq7/0inxVp0Nmb+qFog0vIdpbLHu+WXPZFhu5nikus6JYx1DMpCuFyEiPTjJu6VqkLHcRRh7z58fvot4BRgoGGFGLXVXUAFjPaa9GRTF9T3YwoGVXQRI+sTg6IQy9uB6S5mg65+qtsrJ9MlQx/KiuXwEljoa2+UBiFsC6rnVP/Fn017K8ILazTsTCCTtZefrkDTxs7PCIKcpEjqzmb5KcqVG+e/ElQKYDT5QMkC+xRNQ1oXvmw7N978mFPqYGeqxn9e2x27AY9CBuw1nQjcwK3g6uQQsMWsV
 11W28rnb
 v08Q6+TPXU5FDW7Sa9bKmkdRxGbx5tPgxaCKRzd0uqXtv3Scky4eIs5Y51ixeAVPMxF6/SjGoKPR5qsBvEakOkPmFrmFID5Z9QjE+uWTXb1wXfo6LrDvagraLnMwRQvgLsSTN2ZQG9AJsACSvKoOgXpMGdkIQoY2D+AXNoabUFbq33z/5SYNvr5Bxu6uHil/f1u+BLK4xLuON4qqeLqIH/+K8YEeeVvUA5niKwQq0Fqyi5jhtRdI9Su7iMSeewFbxKHXE+jUTzz89xspGGGk7JFw/d6Lgp6XVrjAqen4PQ/T4kFvX6YBcQ1oVRuDXMCMxBNc/TS9RAc19s+LrVcoG29X7EWR+lZ5LveBXi8by6OhZBr0CMoxRbEa2QHrzfzfQru42
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pmd_to_softleaf_folio() reads as if it converted a PMD into a folio. What
it does is decode the softleaf entry stored in the PMD and return the
folio that entry references - the direction softleaf_to_folio() already
spells out.

No functional change intended.

Suggested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
---
 include/linux/leafops.h | 4 ++--
 mm/huge_memory.c        | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 4c1476ae32343..7c13c58a5e218 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -657,7 +657,7 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
 }
 
 /**
- * pmd_to_softleaf_folio() - Convert the PMD entry to a folio.
+ * pmd_softleaf_to_folio() - Convert the PMD softleaf entry to a folio.
  * @pmd: PMD entry.
  *
  * The PMD entry is expected to be a valid PMD softleaf entry.
@@ -665,7 +665,7 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
  * Returns: the folio the softleaf entry references if this is a valid softleaf
  * entry, otherwise NULL.
  */
-static inline struct folio *pmd_to_softleaf_folio(pmd_t pmd)
+static inline struct folio *pmd_softleaf_to_folio(pmd_t pmd)
 {
 	const softleaf_t entry = softleaf_from_pmd(pmd);
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7140a1031fb2e..ee8d46827ffdc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2518,7 +2518,7 @@ static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct *vma,
 
 	if (!thp_migration_supported())
 		WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
-	return pmd_to_softleaf_folio(pmdval);
+	return pmd_softleaf_to_folio(pmdval);
 }
 
 static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
-- 
2.53.0-Meta


