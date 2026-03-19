Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F0E91088E5E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 01:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB7B46B03A5; Wed, 18 Mar 2026 21:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68696B03A6; Wed, 18 Mar 2026 21:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7E3E6B03A7; Wed, 18 Mar 2026 21:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A631C6B03A5
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:45:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 554281BD17
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:45:53 +0000 (UTC)
X-FDA: 84561121386.01.5156C47
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0ED7680009
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:45:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="mQYay/mo";
	spf=pass (imf02.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773884751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CBjNDUrpBgJBp3zBYdczHJmCkCUetr9Avb7YiT0J0os=;
	b=M1dvu45vZNgONJUH77FHuHcE5urIDCiCgZhmJfS+e3z/ADzu/zRyNOc7m/616/ofU/Dxnf
	nOdDJvNaJBErXb6Nldz+T2UOHEx6BTyeKfmDOntUf2Rp8PxdpFYhAvJ/QnlJ414OBbPiCF
	zNt8zrNiNd1cw9iR0sLKurcleB6xkdY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="mQYay/mo";
	spf=pass (imf02.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773884751; a=rsa-sha256;
	cv=none;
	b=g0rQJ2ZTF/2HXQQZTfMR3s1jqzr6tceL0B0b+0v+psOcv1ZXeCSi+/W5R/u61GKag7XybL
	iAVBkk5RM39wLME75W0rSvCBRgLn0E+HuWhULLa8uvEBICKus/rXLCCGp1AsgoDgMZSgqX
	auc453DqAc25y7D2ax7fo/sFWK8Oefw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=CBjNDUrpBgJBp3zBYdczHJmCkCUetr9Avb7YiT0J0os=;
	b=mQYay/mojnRqYwfZ2Yd8EIyMTqNLJ1UymKyfR+nvc8U0PmYBRd1ONIp8aDYVloCnPVqGRkwMf
	UPGORmvbrwcmUlazDcsL9NVhb2wWJS59478QAvu8sWyavdncqpVcQwr419Pqzvi+FiLuaPeEzYk
	Y7h12a/UwNAA8b2Yab2fZ5U=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fbpLL6VtBz1prMV;
	Thu, 19 Mar 2026 09:40:42 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 229D62012A;
	Thu, 19 Mar 2026 09:45:45 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Mar
 2026 09:45:44 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<baohua@kernel.org>, <ryan.roberts@arm.com>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v3] mm/huge_memory: fix folio isn't locked in softleaf_to_folio()
Date: Thu, 19 Mar 2026 09:25:41 +0800
Message-ID: <20260319012541.4158561-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: q4mncobag3y8n7jk8r1uzjcy9wc4o9pr
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 0ED7680009
X-HE-Tag: 1773884749-311083
X-HE-Meta: U2FsdGVkX1/B+YMpaZeGHLXL1Oc2k7YIWBokQzB63dUMIX8RM+a70Qm+6CDj+gSGQ/9arOwA4dhmk65OrMmuWmI/IQwzZrA2YgzWV6Yq9S7fBgCmK4bHrvOIAnFz72cyhYNWYwT+4ZcZ3/awrcD7MYADDxw4kDZ97xqYjJDQ/k4jxsmas0+emt+HwT74pHw4aYMgKwQFcsk2QnO5YChE10Ep3hKY4GIHUCaRY2tzAct2NZvznQ5xl+T2AJxChFL11ETDIx5SU8JgeCEoAPE+ETsnA+2dnZHXws85s0MlUXJ+r5LBF6b4xadSI3EsKDiTQDC7wKi1qilD1oruTVvJUnekY6uyYKrDwrwRvfn8TTC0+eVGf2OWvS88Oifzsw0d6WZhrhGiYHF5cJow5fD9PJZpXOCy9bI4INYPLA+YXdv4qkLKL3vE1BQzRbxycKLiAwr3Q9UyjITXLMVjp1bgPdxPMlqiv9VfGu/DcUKeXUnmfijpUOITM7IT893ifU6+Id39T8Pn4LH40mGAWyBEf79nLen6o56zzsYQ1D+wVF+/bZzBfS3IRKY9grtrL3D6lgNtc/Crz5yaMU0LXVdadHsaI5qJZ/4cEmHjjpjG16qpHMvYRbmXDnKTX1x6TAdIHue882CsuEDDZ5xzPepA4pI0mZHIGBbu8QlRX4XIj/1ZwKLvE0R1FmQo3JpxOKcMcbVK00uscIKnY5LsfjcJ1ekVjR54dsbSlryXncqAuD387JaUpyXexutGmWjXJpr9HVH6pg7P57H8jl+noDWJgXO7n8Ln927Qh1eLLVoGQcEsXIR1Sarl1YXvq+xec1X01zjgEt3fzag/8W1NfP0YjM4E4PBOLEJgbihxqEpLwelbz9+ScHtOEXtSRBiaxNeicGqH3B1zBkSUHnIskh54UMJuUx584Cps20wIQVm4DuqMk7s8RbR7V2P82Y/eh05/a1BY1kfUvixAV481wIN
 425zDVE+
 X5AyTwL6SX9aJ1MAeGTqNvywO/Wduwompm08pSZllwZuo499cXL9YwD1ocYjzVelxfluWKWYpDnLq+2uN2qAQ4XdW4imdgwEoW/y3K3LL6h08Ycf4vDpTIiXlBBMgvSWxi9DCalrXZ/XviKEDJXxCq5CEUEupzt4X7sZM/geBHdqlpiAD58EgdBSm410iIz3jPSyXjVAat633LnnHjGqjrHNOrJcmr67boCBAX6uIsp5SDjaNLq0ODesSP68KuB/cjZhe6vw3WIviuyfifvVAks+KC0nnjszG4RYQ70dCiycJAvY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On arm64 server, we found folio that get from migration entry isn't locked
in softleaf_to_folio(). This issue triggers when mTHP splitting and
zap_nonpresent_ptes() races, and the root cause is lack of memory barrier
in softleaf_to_folio(). The race is as follows:

	CPU0                                             CPU1

deferred_split_scan()                              zap_nonpresent_ptes()
  lock folio
  split_folio()
    unmap_folio()
      change ptes to migration entries
    __split_folio_to_order()                         softleaf_to_folio()
      set flags(including PG_locked) for tail pages    folio = pfn_folio(softleaf_to_pfn(entry))
      smp_wmb()                                        VM_WARN_ON_ONCE(!folio_test_locked(folio))
      prep_compound_page() for tail pages

In __split_folio_to_order(), smp_wmb() guarantees page flags of tail pages
are visible before the tail page becomes non-compound. smp_wmb() should
be paired with smp_rmb() in softleaf_to_folio(), which is missed. As a
result, if zap_nonpresent_ptes() accesses migration entry that stores
tail pfn, softleaf_to_folio() may see the updated compound_head of tail
page before page->flags.

To fix it, add missing smp_rmb() if the softleaf entry is migration entry
in softleaf_to_folio() and softleaf_to_page().

Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---

Change in v3:
 * move softleaf_is_migration() check out of softleaf_migration_entry_check()

 include/linux/leafops.h | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index a9ff94b744f2..dd4130b7cb7f 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -363,6 +363,19 @@ static inline unsigned long softleaf_to_pfn(softleaf_t entry)
 	return swp_offset(entry) & SWP_PFN_MASK;
 }
 
+static inline void softleaf_migration_entry_check(softleaf_t entry,
+			struct folio *folio)
+{
+	/* See __split_folio_to_order() comment */
+	smp_rmb();
+
+	/*
+	 * Any use of migration entries may only occur while the
+	 * corresponding page is locked
+	 */
+	VM_WARN_ON_ONCE(!folio_test_locked(folio));
+}
+
 /**
  * softleaf_to_page() - Obtains struct page for PFN encoded within leaf entry.
  * @entry: Leaf entry, softleaf_has_pfn(@entry) must return true.
@@ -374,11 +387,8 @@ static inline struct page *softleaf_to_page(softleaf_t entry)
 	struct page *page = pfn_to_page(softleaf_to_pfn(entry));
 
 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
-	/*
-	 * Any use of migration entries may only occur while the
-	 * corresponding page is locked
-	 */
-	VM_WARN_ON_ONCE(softleaf_is_migration(entry) && !PageLocked(page));
+	if (softleaf_is_migration(entry))
+		softleaf_migration_entry_check(entry, page_folio(page));
 
 	return page;
 }
@@ -394,12 +404,8 @@ static inline struct folio *softleaf_to_folio(softleaf_t entry)
 	struct folio *folio = pfn_folio(softleaf_to_pfn(entry));
 
 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
-	/*
-	 * Any use of migration entries may only occur while the
-	 * corresponding folio is locked.
-	 */
-	VM_WARN_ON_ONCE(softleaf_is_migration(entry) &&
-			!folio_test_locked(folio));
+	if (softleaf_is_migration(entry))
+		softleaf_migration_entry_check(entry, folio);
 
 	return folio;
 }
-- 
2.43.0


