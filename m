Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0114FEDA17
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 01:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D6A06B00CC; Tue, 17 Mar 2026 21:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AE6E6B00CD; Tue, 17 Mar 2026 21:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C47C6B00CE; Tue, 17 Mar 2026 21:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7E96B00CC
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:41:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A1AEC8BA4F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 01:41:03 +0000 (UTC)
X-FDA: 84557480406.07.2F588B9
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf16.hostedemail.com (Postfix) with ESMTP id 576AC180011
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 01:40:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=W6sEwpXd;
	spf=pass (imf16.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773798061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mafQ/iI3CnP3VtP25qAMmqjgnpHfvXNQc04UfeE8450=;
	b=VMAn0hGXBtwF93/K7ISLfhYIwHjJ3VLRRLPP2Kna3YiUz+OMuu9FfWJHRaP84vwO+RMg7/
	lR19nvmicEW7I4J7G6faITSbH8aeJuVEeU6tz7OCD3eYO6T095Zr1ECx3sneE7fWy/LwxG
	Bce2U3zcGfg9kSUSCkqPMpoUnkUKXqo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=W6sEwpXd;
	spf=pass (imf16.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773798061; a=rsa-sha256;
	cv=none;
	b=EJiCUj5DvZmJXypXiCqBfnsY1P4MN2HOQ9WtPrpU/cHdtiMX67kme22zM16wYEhQcLAx3r
	rBasPyEiYo97zkxA+6e8+PYXaB3NPPL+34Ciw5I+zeCwqdqQWUxGtdPPRv+C1jYqppv9AH
	FTvQZ02dth5G6Nm9zj9FGsGut/9mkoc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mafQ/iI3CnP3VtP25qAMmqjgnpHfvXNQc04UfeE8450=;
	b=W6sEwpXd5bYtBP+iHOEBy39wGu2PXdLnWDaoXD+GySzqTQAr3kJuTTu5flumvxm+LOyaTmxpl
	iKlAahZ7U4Mhxex4Yp0p49Zi4c55kjJSBwCjqq/JbspD8SntZQHFbHML6m9Izy6kE8F/2LrujdI
	802tPWeWLSBBOlEm4qwpRnI=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4fbBHH5v28zLlVM;
	Wed, 18 Mar 2026 09:35:55 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 182FF40539;
	Wed, 18 Mar 2026 09:40:55 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 18 Mar
 2026 09:40:54 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<fengwei.yin@intel.com>, <baohua@kernel.org>, <ryan.roberts@arm.com>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2] mm/huge_memory: fix folio isn't locked in softleaf_to_folio()
Date: Wed, 18 Mar 2026 09:20:55 +0800
Message-ID: <20260318012055.3593216-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 576AC180011
X-Stat-Signature: j14daf9uibjcmjyu97jfh4uhfqohuzb7
X-Rspam-User: 
X-HE-Tag: 1773798059-971422
X-HE-Meta: U2FsdGVkX19OSBAuwTIaz5ahe/vH1KmiMV/HedEQQ9ntKQ3JvKD5KjxrtDyzvBM8aaNvsutPBT1mx9dKrEm5s55G02dDavbSiXrSHmJcr6NjsMaIM8TGQ3a4KBWLB6uO9sSOycTHP5ydICZ1SVhsN4MbEcaEhtuq4dhA2fMpGFSTfimA9SJFy2OwOKqZ7IjJ+BAZB7/IYpW+s114F5J5zyp8l2K3RDQWXAwFCGs+Y6ArbPFYjwbRlcD+s/r3cK1JZ7snZ85j1/7Cz+XxRlciHCB8hJuRZMGDi5zg1oAuEMNvJrP/iP7u4wM96cmI1Cz//tc2CiAnywVgIKTBowW3RLMWzvtk3Rsess9M8Tyo8blGAFKTrtW4dI6ootOzIVpgAACbrXb9enpL90Vtw9r+lYifKPhrEqSlBmlvyJ+K9h5FEGSdqrZ+1NffkEUb+t3sPrjKMCaEliTqP8FYcbdNmlK2KJyOtLV4Sery454S6FmIm9pH/nnOPgwe36ByigNQagxqXGQl9uyu0P/Lm+oNFvb8SaewzKklWNQx3cqIROPbk+7N0qyCbIz9pSwgmWT6XrvzXEMQyEK4H/jaCmzYCVVwKBMcSFjdKOBWWeBYu3wiv0xWnBbn7ZHqL9CI5GJ8rsM8CJR8DwobInkc8VWpsHgThJ7bS975xomcHjiEgWAwsu8AnV9j5Aaz/Pwn/rF225HEeP3UW++0PlZWYhWGEOcT2yX5j9fDBK34XEow1zkoeOgGU2bLp1gtIGRUPlSb7QuseP3SOtudSuyG85LgcSLvPwjv1AntBOtX8nC4/8xJASqoEoqQFJEtH+cGJ9LIDLjWKy7ShaYljF0nWnwBggPaRGIm+msY9vPzboro7jXY2eWMOtnK0WAqlMqOC1/3z8I2/7+AO1mgXcpC4Wp07qz3YDHWjYyu9h1YqR2h0WixhHoPymmIXn93lsA49rBUCMaVMVyW0t1krnWXOVV
 6gfajRk6
 KEVE/KzZDCD8qsTsDkA86wjxklapOhvDcNX7IPA1WjJwecw02ewtQq7t0O+teSsxr0lOmBSywQ+Wkr117KHRO2+Pi8xC+ZF5Y0DrEmjTVegZgYHaCDD+0smtES35ciG0JgfyK4+5wlFZaROdwzqnZipbbqFEH6kLq7UNEIlcv/fgM07d41Vou7lo4qGKWStGi58qbUGbKY0W6+U2IqUiGyBIBucgKhuqaalNLB8dN/p0ouIe6DXUowoBUMmmDS3iQIbHk/JgA02fVnxXb0Ni5AQXbyobXV+g5IG3cB+rHPuQM4klBx7GzpB10+jZGA9NEG9lrnwtdxhe+2xmkzp65il/Png==
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

Change since v1:
 * update fix tag
 * use helper softleaf_migration_entry_check()

 include/linux/leafops.h | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index a9ff94b744f2..c7dbc3fb8ab6 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -363,6 +363,22 @@ static inline unsigned long softleaf_to_pfn(softleaf_t entry)
 	return swp_offset(entry) & SWP_PFN_MASK;
 }
 
+static inline void softleaf_migration_entry_check(softleaf_t entry,
+			struct folio *folio)
+{
+	if (!softleaf_is_migration(entry))
+		return;
+
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
@@ -374,11 +390,7 @@ static inline struct page *softleaf_to_page(softleaf_t entry)
 	struct page *page = pfn_to_page(softleaf_to_pfn(entry));
 
 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
-	/*
-	 * Any use of migration entries may only occur while the
-	 * corresponding page is locked
-	 */
-	VM_WARN_ON_ONCE(softleaf_is_migration(entry) && !PageLocked(page));
+	softleaf_migration_entry_check(entry, page_folio(page));
 
 	return page;
 }
@@ -394,12 +406,7 @@ static inline struct folio *softleaf_to_folio(softleaf_t entry)
 	struct folio *folio = pfn_folio(softleaf_to_pfn(entry));
 
 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
-	/*
-	 * Any use of migration entries may only occur while the
-	 * corresponding folio is locked.
-	 */
-	VM_WARN_ON_ONCE(softleaf_is_migration(entry) &&
-			!folio_test_locked(folio));
+	softleaf_migration_entry_check(entry, folio);
 
 	return folio;
 }
-- 
2.43.0


