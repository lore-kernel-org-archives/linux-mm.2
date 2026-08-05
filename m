Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1ED2C55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 21:29:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8AD6B00A2; Wed,  5 Aug 2026 17:29:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181106B00A4; Wed,  5 Aug 2026 17:29:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 021256B00A5; Wed,  5 Aug 2026 17:29:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7AEB6B00A2
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:29:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E46E1603C0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:29:33 +0000 (UTC)
X-FDA: 85068507426.08.04C5383
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id B5C0F16000B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:29:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HY7LIADl;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785965371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xU1EGnxu1zA/QCvrmcvsW9FFSAGjB7CeJF+feg1bhls=;
	b=ckPXiiqIcGvsARdpeSl4p+tVXEKKcnvSxVh2XeYboMXXef86NFDN2rxhd38M+HQbUTGtnQ
	slYgtV8QQFvyhX8a3mHaFb2AeMxUsijQ1pWLSpzBXTPPAYQ0y7KEysrt+5XstBICofUq4K
	6NxQ/VG80en7gNRP1jIVn83OKtkNJbo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785965371;
	b=5tVJsdKc0no5tzB9/GJIcBApZhtIjeT4/yGpyWIUJVyCk+zeqAcsy/PecofqfdsKGEMwrI
	6Ha5oJVs6rOgeksjDKLDMLKmllB6/aVhkNhGRCCM9t/k0TDGB3L0VKMYhQQfb6aAh5wgbH
	RM1Rpg0vVpYMGYMP1BN+zm8M+Xsoa3g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HY7LIADl;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=xU1EGnxu1zA/QCvrmcvsW9FFSAGjB7CeJF+feg1bhls=; b=HY7LIADl+h5kenkBUynlodcWX3
	2/0Wr63ay76B3ZaBFt1sjaxZygjmV3Bb4bOOaFJCd+mG3ViHMVvh/zGCVy2rVomHmKVYT+JLHgFQn
	Yx6Dqke/5av22WwET+2BiZXz3Mu8yjOZW/dIn+r8rF7oM/299f3Kj4jPM/Nd7yu4Q/bugHB68VL2u
	P1tx/PncY0c0nW57woah389eTh2p4jCoyc8akENNs4OpOlO5OpWz2a5r0FRfQ0n62VIPYZYtwp0bq
	Dme7zfAsZyVQIRXxJcKTD+6M+q5NctzcSpSCFXQOo+4sGjIZoKo+QDqH/g/zGuKgh2XtlkR5TnJMU
	hBdTW84g==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrioJ-00000004h67-1ooi;
	Wed, 05 Aug 2026 21:05:59 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH v9 02/15] memory-failure: Prevent hugetlb freeing during unpoisoning
Date: Wed,  5 Aug 2026 22:05:42 +0100
Message-ID: <20260805210557.1118966-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260805210557.1118966-1-willy@infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B5C0F16000B
X-Stat-Signature: g1w4pntg3jf4ird5b4qps4mjg34ancqa
X-Rspam-User: 
X-HE-Tag: 1785965371-462298
X-HE-Meta: U2FsdGVkX19ShOh+8rjstZaRSI+nYvO1JWvchV9RS/v7hKlArUtj/PKNt9C7N7o8op6pP6KVyEULxI0Qiq7ARq85RjJyt40cQRHvQgmxIoNW8T7qX1YOzU1x+IsHrSAGGpTHsm6kj2+L/Ru0nRmXE7UzpW2Op9dF0KLTg80LAWXHnXFrckJABel6YwTu5TQN6E3/zTYf19ozWA/0hb5OBwdMU0Li92LqmR0SyyzYpQ0qqNRYsZiiFIeAePy1MHM1xVNT2T353YvH5Ixj1NYAh40cWvroY9Lot/Uh5p3rb5Ljnsq13Jo2NpYPiehdYOkuPy4KgC3cN8weKMEUIsh24X77lppQ14DoIBrY8bm5B1W/T5SUhZjoyfMOMCWnXTLL8Yzv1DLiEF6oCJEjRgYt8f6UUk2tD6YTMb+alDhS9BZYi4Ohnz/sNQbkOhuyLXvpJFJ5m1kuvARQBh4v6jI/JONrfJMqWqyym2f1I+jqm47sEAkzXSpNY9ULJroSUzlxJVE8+KYjkeoRQDc5iyWaoDwyBTzMeCAOvYl08E9mfHz7z+HtLz11oK3bo58RhmfdYXx3qsetoU78g11IlR8HNlffRXOvHQmier7b+TLqzvm9P+chRE4VcV2O0SPCZhteGvcsPjahx548KHOPo1SZbvtomlZM6BHQtwKOfxOq2/uqxRUodwV6FXAhX646YvT4BTTXv4gpfUs61N+sSSothZGQAY2gwU8SpDPVjcuPSbJh6LhL8ucvzkZoCYqZ78HCR5FcvHzV3W9vZdyVYrZ5fIEw9G4cTtLfV7jWPKWhPLK50C2RBKBngL3hUDe65ZUdPT55ura552k2eFDAnMq9m4FdANRaDY2z0gfENoNkR7h42wL7gmAOLgI+aauyCaD52tBoisSa1MFj7zNlqNK4Rw6qCg8w9yVwtRtYnsAhs9jYLP56zN8dvlohB+yCU7Ge9P1F8kqEd0ppPyVg+2K
 tWJMkEnh
 cPpXjnjUSrWXRMphvMGoVT3DnsP8rcFcjIvIJZW+DLXbg6YRArvNoWt/vtqpYwU/D+LqRVHL3JGgZ/HZg5y3Y2zgzbrrmHoxAUBy+pQ1fzZ4/9fKeQaby4PKRHvWrNbkjFmArY5veBJgNYEnIMgcM3Hqgd4NfGGVscjnB7i+WMROZMpyaQRIK9UEI9b5DtotHbUXUyqnimmh0TGcLyH/LxtkhFyiTGPfqi2QBEuGfSl/qCglpmHdfefulSVYeQzGarHjD2Tix4fj201LwDMVEUFfLnZtJHe4+SCMo1IXd2to694FQrIoNJ38mKRFIkqwevnL/3IwO8kT/TZDHlydIU9Zdn1apcf3Rd0xObfRYwhVPkiZqGZjVQUkRG3DBMSnRu9UTvDwXgIHZeerI6uehaaR1osayxvr+vqP8N4v9HVGP/hmRNHxoef5sv04r4V2fs0TY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If we fail to get a reference on the hugetlb folio, then it might be
freed as we operate on it.  Prevent the freeing and the attendant races
around manipulation of the raw_hwp list by holding the hugetlb_lock,
which is also held by the hugetlb code when freeing hugetlb folios.

Fixes: ac5fcde0a96a ("mm, hwpoison: make unpoison aware of raw error info in hwpoisoned hugepage")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
---
 include/linux/hugetlb.h | 19 +++++++++++++++++++
 mm/memory-failure.c     |  6 +++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2abaf99321e9..50eab2c23299 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -110,6 +110,17 @@ extern struct resv_map *resv_map_alloc(void);
 void resv_map_release(struct kref *ref);
 
 extern spinlock_t hugetlb_lock;
+
+static inline void hugetlb_lock_irq(void)
+{
+	spin_lock_irq(&hugetlb_lock);
+}
+
+static inline void hugetlb_unlock_irq(void)
+{
+	spin_unlock_irq(&hugetlb_lock);
+}
+
 extern int hugetlb_max_hstate __read_mostly;
 #define for_each_hstate(h) \
 	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
@@ -279,6 +290,14 @@ unsigned int arch_hugetlb_cma_order(void);
 
 #else /* !CONFIG_HUGETLB_PAGE */
 
+static inline void hugetlb_lock_irq(void)
+{
+}
+
+static inline void hugetlb_unlock_irq(void)
+{
+}
+
 static inline void hugetlb_dup_vma_private(struct vm_area_struct *vma)
 {
 }
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 944e6e1d4971..1dd0e7b99bb1 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2725,13 +2725,17 @@ int unpoison_memory(unsigned long pfn)
 
 	ghp = get_hwpoison_page(p, MF_UNPOISON);
 	if (!ghp) {
+		hugetlb_lock_irq();
 		if (folio_test_hugetlb(folio)) {
 			huge = true;
 			count = folio_free_raw_hwp(folio, false);
-			if (count == 0)
+			if (count == 0) {
+				hugetlb_unlock_irq();
 				goto unlock_mutex;
+			}
 		}
 		ret = folio_test_clear_hwpoison(folio) ? 0 : -EBUSY;
+		hugetlb_unlock_irq();
 	} else if (ghp < 0) {
 		if (ghp == -EHWPOISON) {
 			ret = put_page_back_buddy(p) ? 0 : -EBUSY;
-- 
2.47.3


