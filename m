Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F0AD1094461
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 08:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B5B36B0005; Sat, 21 Mar 2026 04:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68CC26B008A; Sat, 21 Mar 2026 04:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA186B008C; Sat, 21 Mar 2026 04:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E15D6B0005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 04:12:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E6F2C1404D2
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:12:34 +0000 (UTC)
X-FDA: 84569353428.23.DEEC63A
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf12.hostedemail.com (Postfix) with ESMTP id A54FD40005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:12:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CZk02E+o;
	spf=pass (imf12.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774080753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DAt9LzhhsgsjYtr773f+9eH1uFjEz14PpVB4IOX1NDs=;
	b=CDC1qawv2eR7lC97GGHxW9u+AXw9K9/ENwbndtUX3DZHxMNnfr/lO0tQlEv9DyCfXPwGKD
	lreK34wROOfh9TBsMHi39ScAx2niUTTxvrak381eAEUpgzz2+jdUjq5e7rWfysZ/66wu+2
	TUCEPB8yyBA0DCX3mWDdJ3jx7+/hdV4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CZk02E+o;
	spf=pass (imf12.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774080753; a=rsa-sha256;
	cv=none;
	b=BeCwZl91MemaYupviW8oh4dmXHwAkIp5ZVB6MC8OtcNdYayfl1UDn8e2GM3L6rBGTmSWi4
	6dkaTLXEJ+dpaDFZk2T0PNIbEKyGLk1qFCvxP+yI7PDHJf+vBwQhq22XR7lAwRTESY4kaB
	2l4mQ9jur0T9j//nd1UTV8uWbmq5U04=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DAt9LzhhsgsjYtr773f+9eH1uFjEz14PpVB4IOX1NDs=;
	b=CZk02E+oXvlBWQEVNPrdXwcxTOovIGvYotDDF01EeCiy1bi6q1R6pO+GXOegrb5xVh/ccJUxB
	p2RBhxFIEvQLDLmGt9wGXa5XSsjGFJays7/B1y2CL2ntMCtLKas8zJX/an4FDY0clIAjnVbbMOt
	vFr+3HP86g8X6JjFGpkvwI0=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4fdBpT5QpKz1K96T;
	Sat, 21 Mar 2026 16:06:25 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 8AE094055B;
	Sat, 21 Mar 2026 16:12:26 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 21 Mar
 2026 16:12:25 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<baohua@kernel.org>, <ryan.roberts@arm.com>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v4] mm/huge_memory: fix folio isn't locked in softleaf_to_folio()
Date: Sat, 21 Mar 2026 15:52:14 +0800
Message-ID: <20260321075214.3305564-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: A54FD40005
X-Stat-Signature: ep77in3txyfdrfzoppabxc3jfdstre7p
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774080751-378106
X-HE-Meta: U2FsdGVkX1+vsvPjFMuGsHPxuau4k8MKPtKj/Z3a2YF5bmcbXBq58ywPhoCmRLBSRuvx5bDxyeN6rOH06NfV0KNleKRuzjpBrjIIQNpyIRVRCoc/NSPW6QtTOUtEqklD7dkbuMbFV/YttCFNXlpXHk5RCRpdqmvjE0TtvMzbeGiRb/vr5JYObf7Pvo4M5NNaAdC1rlfGlAHTjtQA7HxesuMSADgtjMzRne+uFysFp5prmcH3JMBw/6V5QqfhgQGmr6+y7x24UjYw/H5ZVU4ZaMufSHlB3mzfNrcV/EsKuwAFqgM3bY8BkqwhtVzyn+nXUenq5y0kJJc4acUzriAE0OFgJCeBWeWb/FGPEUyqGPXYiEQ9pBMOH8WPUCxoq93wy3pbktlUU+8xeE4yOYZbjOCkUw0yvmCmQaAsRgTCrUaSuiWlFB29AB/xo763vzXV+VtafTS9Ogb+gXoXi7DO5Rkcaw9z2dZVsXrR803IegTQ0qX86agR8oq8Ei/8OPQKzfSrusovi8mlTRw1jpUS9NKCEMs8YC2Asjdt2ytjVu13QmxfrDIsBqxSfJLudcIhqNkz+2dTTvbUqHY7nyErdoLNGqunv8u25QjZmvVcia342aUxGPtbD3FTtBRod00Frf7iPJ458lSShtzhdDSapRmH934vUdsbd0aLGKBB+GuOBynIuWMjvSsc6G5HlwOe8M9N4zW6te96/kdZaBReRPOlbUriox3Mpc5qUZhVx8oONMRdgqLPVbJJ67N4McTEYxl8YM/IQnJ6FNcRcaIHwGn3DgHnyPMNyDf/d0tAKnziVmNt9adkiZk9cVF93Sb2OWlfdHqzt7cpsKNcVfNnDaM+5NP9gSLba1p6UXYGLWGdZlhEBkABTzHSDNRLVYJrF0pcRfpD5HtABKnNgEph/WVfcMNMqboOV4anGogOeXGud0+ewLbx1Q+svx98KuNr+O9tCMgBGGt6Oyy6631
 Sd9Ru5gr
 6k4ypH+Rll0YSxBsZNcuD7tTYMi57PMRrqWx+IdM1JUcuhsc=
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
Cc: stable@kernel.org
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
Changes in v4:
 * update function name and comments.
 * collect Acked-by and Reviewed-by.

 include/linux/leafops.h | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index a9ff94b744f2..05673d3529e7 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -363,6 +363,23 @@ static inline unsigned long softleaf_to_pfn(softleaf_t entry)
 	return swp_offset(entry) & SWP_PFN_MASK;
 }
 
+static inline void softleaf_migration_sync(softleaf_t entry,
+		struct folio *folio)
+{
+	/*
+	 * Ensure we do not race with split, which might alter tail pages into new
+	 * folios and thus result in observing an unlocked folio.
+	 * This matches the write barrier in __split_folio_to_order().
+	 */
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
@@ -374,11 +391,8 @@ static inline struct page *softleaf_to_page(softleaf_t entry)
 	struct page *page = pfn_to_page(softleaf_to_pfn(entry));
 
 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
-	/*
-	 * Any use of migration entries may only occur while the
-	 * corresponding page is locked
-	 */
-	VM_WARN_ON_ONCE(softleaf_is_migration(entry) && !PageLocked(page));
+	if (softleaf_is_migration(entry))
+		softleaf_migration_sync(entry, page_folio(page));
 
 	return page;
 }
@@ -394,12 +408,8 @@ static inline struct folio *softleaf_to_folio(softleaf_t entry)
 	struct folio *folio = pfn_folio(softleaf_to_pfn(entry));
 
 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
-	/*
-	 * Any use of migration entries may only occur while the
-	 * corresponding folio is locked.
-	 */
-	VM_WARN_ON_ONCE(softleaf_is_migration(entry) &&
-			!folio_test_locked(folio));
+	if (softleaf_is_migration(entry))
+		softleaf_migration_sync(entry, folio);
 
 	return folio;
 }
-- 
2.43.0


