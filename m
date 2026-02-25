Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC02EEFD209
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B03996B00BD; Wed, 25 Feb 2026 03:31:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADABA6B00D2; Wed, 25 Feb 2026 03:31:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DA3F6B00DF; Wed, 25 Feb 2026 03:31:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A5A46B00BD
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:31:35 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 513D0B91DB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:31:35 +0000 (UTC)
X-FDA: 84482310150.28.732DE16
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf30.hostedemail.com (Postfix) with ESMTP id 67A5F80018
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:31:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PQ83Te9w;
	spf=pass (imf30.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772008293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=V+0btWJvpN82MWoUIfyGBEuNyVbQfKtpoUxMOk6bk5g=;
	b=AL+snpmjL/qVFspor7rV++rP5KCj3v2S7nVskhcv/pcKSjU7aMoOzPt94sZ2lDdTVLW6JA
	dn4/vf2QghqFNUEu9oYHDaKHJ8lH6NGiuV9A4kTKELVvUKEdNtNr0cSch9GY1PzjHvloaa
	FJ2j1V0Tr4avZGR2ciaMnWhQD+RF7Cg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772008293; a=rsa-sha256;
	cv=none;
	b=JcskE52cHbW/dDGxzBwXtEnTevpOJkRX4gBX+trVGEVlnaZLhcUBjyNkX5JdGmzjohcmEK
	0xSVgXsoV3UD/3GOlZgnZn9mys5bZzhQ23pyQ9WhYoQTZ34nzJznHVHEOVU6iEBlYA/jLe
	10K0clzZ7rs2eeD+UrVc3+ETMA4CE0o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PQ83Te9w;
	spf=pass (imf30.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=V+0btWJvpN82MWoUIfyGBEuNyVbQfKtpoUxMOk6bk5g=;
	b=PQ83Te9w1pj/Y/rdt6DlwqL+Q5nF3zmYcSBrFVCTRqvMsZbmO+KvZCwmVEKCNPbfiedXjTDpV
	dq5SsbAPaCCpwaiaL2lZEEMeNXFEJjW6ucexMQVnzrq+xykiVrrlcoqpErwohSlvFj0yb90wc+m
	vPUT/0g7b2Y24SDJNy34cJI=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fLSNs6FnvzKm4l;
	Wed, 25 Feb 2026 16:26:37 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 4E62D4056D;
	Wed, 25 Feb 2026 16:31:25 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 25 Feb
 2026 16:31:24 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<fengwei.yin@intel.com>, <baohua@kernel.org>, <ryan.roberts@arm.com>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH] mm/huge_memory: fix folio isn't locked in softleaf_to_folio()
Date: Wed, 25 Feb 2026 16:12:40 +0800
Message-ID: <20260225081240.253057-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam09
X-Stat-Signature: hgbp53sefhbn5ba5pqposqdhpk87fcex
X-Rspamd-Queue-Id: 67A5F80018
X-Rspam-User: 
X-HE-Tag: 1772008292-336061
X-HE-Meta: U2FsdGVkX1+C78AtpgjvubebOomkG+E+avHG15R52h+lydbieG8f232hjcTIeI+rvXuKFm+fbOtjbcTkUOMoCQoNVRAADYl9fzN8rRqA566eQjo5DgSBZhovTvDC/y9VzsBGVqNPir+teI6yQprOBpxLdwjqkMINGRluHH2aqOVLQH6Pz6ziG8hAm1sV+ukJXoZc2KgrAAk3j1Fug9aaMqq+qt4Ds+74C9zGQJnoDrQ159RPTzBmOaz7lzQy0oo+aXicUFEIIMOIwCfp/FitjGtCmnbyHh4EZmiBoSwmNgzK/Pcr8DwWaHAXVWqT6ehZ0J+yYly+yjwUDKnzPoCSB2VickiTBWwDrPEhkEHWugdskbkfH/+CKHgDGICDhBnq1cbmgB8nU3oGeKqXtaprphxb0FjkzTKDZ2u5yKXQK+ps1QCESE40uwzHcgH8U6jaVdXyOdC1bWwYClp5nntMVXyERoO8X90F8JebzGOKN5C8rSopYQvD6NkzgXRYQamkdgPB/GIJ9RpPr4VgXEqp0tO+CjD9G3Uf9tNAgw6wWyESAG8OEJy3jE2orzA4eYBhetrpc1MZXBYuu6Tp//PjwcThNx/H2Ypkt/6dx8KoxV8z8hbmIMrMlUvCX6faU+5QiHTMs0VVwUF7XQn8vmD8As0T91ZWEDxQp5Rn6PFeMllgDCSfWE6gikST0wwxfoB5rdENBh8J6svPVpoI0RgGE6YAeAwGVszJ3WTqwDnyJmUtOUDRAg20EAOZiWS7SjcDN2FgdKVbgg3Ms5KhTIZN7xGStoy0WH6SrRC/2V9JuZk5jd6iFlt/b52DWYesY1yke7cMMQPCBIsbYiSozk2lKRK38gwgqs45wph/ZkuKh7CwG9P8hk6EzRS6kDmYxOI3I7LKdlLBif7abpVDHBlEvZZAB8dFonS2HkZSvsRrS4EatJHIHAnFAUkk2LGXC1BVgXhkVivlkunRghgTeCs
 dvlkwgnO
 N3wHodcP0dkCR77xs0Qwqj/BQeLyyvSl6mzQTLFIFbzpMgnIETY1KK+LPegmvOSWSeT6PkTmCVYzfStecloQVo9S5anW9mmqVumpyV5LW+ZPBQIwoOx99Xerl4igLIvPyilxXkiD4JKR6U3WjVAfTeNfVH3bImSY2HBAB5JzS3SpIvKMCrCXvgJq0ph1PLkFwYS8SDcBrZNa1q+FI6XPy08EV+M3NC4jzV+wGS8+w8DPKnyiLKbIYd35umm6FyZ1vSJBk1hD+92gulsmoKhLz7upr4YHX7bQBo7YWqIjyDYMnoto=
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

Although the code exists for long time, this issue should only exist after
mTHP splitting is supported. For THP splitting, there is only a pmd
migration entry and it's impossible to access migration entry that stores
tail page pfn.

To fix it, add missing smp_rmb() if the softleaf entry is migration entry
in softleaf_to_folio() and softleaf_to_page().

Fixes: 7dc7c5ef6463 ("mm: allow deferred splitting of arbitrary anon large folios")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 include/linux/leafops.h | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index a9ff94b744f2..f823f390ba6b 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -371,14 +371,21 @@ static inline unsigned long softleaf_to_pfn(softleaf_t entry)
  */
 static inline struct page *softleaf_to_page(softleaf_t entry)
 {
-	struct page *page = pfn_to_page(softleaf_to_pfn(entry));
+	struct page *page;
 
 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
-	/*
-	 * Any use of migration entries may only occur while the
-	 * corresponding page is locked
-	 */
-	VM_WARN_ON_ONCE(softleaf_is_migration(entry) && !PageLocked(page));
+
+	page = pfn_to_page(softleaf_to_pfn(entry));
+	if (softleaf_is_migration(entry)) {
+		/* See __split_folio_to_order() comment */
+		smp_rmb();
+
+		/*
+		 * Any use of migration entries may only occur while the
+		 * corresponding page is locked
+		 */
+		VM_WARN_ON_ONCE(!PageLocked(page));
+	}
 
 	return page;
 }
@@ -391,15 +398,21 @@ static inline struct page *softleaf_to_page(softleaf_t entry)
  */
 static inline struct folio *softleaf_to_folio(softleaf_t entry)
 {
-	struct folio *folio = pfn_folio(softleaf_to_pfn(entry));
+	struct folio *folio;
 
 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
-	/*
-	 * Any use of migration entries may only occur while the
-	 * corresponding folio is locked.
-	 */
-	VM_WARN_ON_ONCE(softleaf_is_migration(entry) &&
-			!folio_test_locked(folio));
+
+	folio = pfn_folio(softleaf_to_pfn(entry));
+	if (softleaf_is_migration(entry)) {
+		/* See __split_folio_to_order() comment */
+		smp_rmb();
+
+		/*
+		 * Any use of migration entries may only occur while the
+		 * corresponding folio is locked.
+		 */
+		VM_WARN_ON_ONCE(!folio_test_locked(folio));
+	}
 
 	return folio;
 }
-- 
2.43.0


