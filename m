Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FA32C5DF81
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 03:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59F386B009B; Sat, 22 Aug 2026 23:43:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5777A6B009D; Sat, 22 Aug 2026 23:43:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 466376B009F; Sat, 22 Aug 2026 23:43:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 067136B009B
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 23:43:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C29812025F
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 03:43:40 +0000 (UTC)
X-FDA: 85131139800.22.1D5E52D
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf08.hostedemail.com (Postfix) with ESMTP id 58BEE160003
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 03:43:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Ci7T9s8E;
	spf=pass (imf08.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787456618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fBkKeEy0n7n1129jfqfo7mvp+BkKpcVoZE6BQwb1smA=;
	b=w64HEAaItExo14LXuikWE7QiNU03+fD+vfD3EIq3XsvKM18dqDerA+s3bKPzh1qJF17vee
	6b+JaFhbp1sNIYoun52fWKr4rou+Ajs/M5nNMBXJW5Bph4lY8KqdduSJiTJPf7eM0T8rsV
	IKBgEXgH7GEEfc4zkMf4Vo6C8X8LF40=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787456618;
	b=IoL26kiJLN4BoXsbP9IVWZrD+SfZUck3UGpHszZNlYdhC9kZS84c3g3JFcdkfHUpZbECcr
	ZCD4mJsiE2IneXZVxfUXwf9CY17mPFYs9ShYYGlq3spPWH/YSKTTL7mYkB5FKxFiFa9fll
	4T1JeXf6U2J3fEkh47TY3T5uFzTt6Tw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Ci7T9s8E;
	spf=pass (imf08.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=fB
	kKeEy0n7n1129jfqfo7mvp+BkKpcVoZE6BQwb1smA=; b=Ci7T9s8EQ4j3i6ubTY
	6ecF3y6dNUlV3wvOdGYa+pHrawmpU4OOUm6wJ+eDkUam8opxkX1+skYYK7LWEMfp
	awZh8iUvWdsSjKhDjpYGvoP6QP+1ZD2TxtNrp7A/K/k0LkeoteooJISESkRWV8nO
	NBrNXnVvQlaMwTOR8h+fEkWXU=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wCH5exMbIpqBB8uQw--.11509S3;
	Sun, 23 Aug 2026 11:43:11 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	david@kernel.org,
	mike.kravetz@oracle.com,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH 1/2] mm/hugetlb: preserve source surplus accounting during demotion
Date: Sun, 23 Aug 2026 11:43:06 +0800
Message-ID: <20260823034307.1072415-2-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260823034307.1072415-1-xialonglong2025@163.com>
References: <20260823034307.1072415-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCH5exMbIpqBB8uQw--.11509S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFykGry7Jw15Cw1ktrykGrg_yoW5KFyUpF
	yYkws3CrW8Ar9xCr1Sq34qkwn8W340v3yjya4fKr43J3ZxZr1UKr13G34UAa97WrW3Jr43
	Wr4DXFyDWF43Zw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j7PEfUUUUU=
X-Originating-IP: [2409:8d1e:e12:7fe:fc27:3a72:bb72:5709]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+A9rZGqKbE-yDAAA3F
X-Rspam-User: 
X-Stat-Signature: 7ydduxngq5g8wrw1bxtfbrhcumpazeo6
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 58BEE160003
X-HE-Tag: 1787456616-948001
X-HE-Meta: U2FsdGVkX19BcJTjtplywI7V36FfuRZ10UBV01zwgvQAsfBZsooMOPz83g9Ayl2Qc852kRg+94eYoM1B5ouv4cxNSmTULReZB+bJsXTDToHsx4DXeu6Bg4eGs27jo495fjuhWaPuI6SQswYV1Lt+Uo/UJZ7lD/4gR+AUp+02qfhgbtnEajsL9uK2l+fg/YG4mKOtNUlAyoDQRySUOsjTU587Cboc3cE77wzdIbTtei6OQyw+4oIvRILPwDndEsuFkfU18mlxozegzuLVbwaliRwZFw3dOFXcgoAsalb8JqX9GIC4Uw6TDfD5KLYbP/1ZydWWBfNyV7+r/xujsVvDgr+xRRhxPodJCxgkTPD0/WWPRFKertnjmbwI6frPwvccCru0wt34ACKSV+1GTiTXhi1RzbpVWm1+vITDggT3VPus1wOPcU9rc61K9NXNPL6CXZE58Rorpqym06SC4JCSVuaS7XqLOjJlpmrIUzql7Keb/35sLupDDcAYOccUXfuGAWFwXYVF64ef9II1WD5Uh6jsYhcf7S7Z/8Ym8BF7sJMo6f1vJneXDAHywMK2w6/Bs56kPouqT25nmmA80pZFRcwiDw4UeHZqDwwwYq0qm4qGjDJq7P5FeuFlMdkZFUlUnWpP5NeXbqamEd+fNtbnN5kVDmdu/c/5qvkmn+PyzM3y0Me0k6+EeV/WZeNMeILZNpwct7PfRvNxBaQ/p0VwJJIAE5gbB6H6S4HEG4WzjVHYa3t7WktVqaEwHqyTb+YF0+EHuCL9eVdLbXhH/dj/pTbKkGFWtONYdByCt5OHWj0ssvNUF0rIDFosQPMG0KV5TvQHxDyzRNbbsLzeH3u4HUHXoIse/bZwY2WTA82u7ThOK0peFy0q/HtyCyhB7Y3v4pRhjMLGuttO9/2ZVAyrJPy3/pfa/MoKB6m6LhY7QGI3gEqrz3y/MEcarY5mr8HcuI+NujOHdFbmNRe0Y3m
 WiDp0aqw
 XwhyjqtIGQpYO9bIXfs6IxSHwiJLeZHc4aAK+IJpnoHA1waJruqFhhHqUijIQZXhqj/CrVBg23tfT+zXW/qazi3I/cC73mTty/yUSJZyan97cKSAvRI3JZSHVm+4D5AR3IVJK6d4zIglW8c5EpCzvRGGCfgQTcb858/WDgiiXW6BKvfcNQYN7ut5uNe84XxznGBJxm3ccBTd4xtJHsjBZ/y6WtA/f8mKISDf3OeaO8Kl5xJ5YCOsTr1bllkDxMbTcL4psa+v4dG3096nIGwGqFSBz4ox//xhBOm0wVj38zu+Lz89OufJNyYNRQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

demote_pool_huge_page() currently removes every source folio as a
persistent folio. A free folio can instead account for one of the
source hstate's surplus pages, for example after a vmemmap restoration
failure. Removing such a folio without adjusting surplus_huge_pages
makes the persistent count underflow, and later subtracting it from
max_huge_pages can underflow that counter as well.

Classify selected folios against the node's surplus count while holding
hugetlb_lock, and preserve that classification on rollback. Track the
number of successfully demoted persistent folios separately so only
those folios reduce the source max_huge_pages target. All successfully
demoted folios still increase the destination target because the new
destination folios are added as persistent pages.

Fixes: 8531fc6f52f5 ("hugetlb: add hugetlb demote page support")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/hugetlb.c | 35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ed26105b84de..640df58be4e5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3983,6 +3983,7 @@ long demote_pool_huge_page(struct hstate *src, nodemask_t *nodes_allowed,
 	struct hstate *dst;
 	long rc = 0;
 	long nr_demoted = 0;
+	long nr_persistent = 0;
 
 	lockdep_assert_held(&hugetlb_lock);
 
@@ -3995,22 +3996,40 @@ long demote_pool_huge_page(struct hstate *src, nodemask_t *nodes_allowed,
 
 	for_each_node_mask_to_free(src, nr_nodes, node, nodes_allowed) {
 		LIST_HEAD(list);
+		LIST_HEAD(surplus_list);
 		struct folio *folio, *next;
 
 		list_for_each_entry_safe(folio, next, &src->hugepage_freelists[node], lru) {
+			bool adjust_surplus;
+
 			if (folio_test_hwpoison(folio))
 				continue;
 
-			remove_hugetlb_folio(src, folio, false);
-			list_add(&folio->lru, &list);
+			/* Surplus accounting is maintained per node, not per folio. */
+			adjust_surplus = src->surplus_huge_pages_node[node] > 0;
+			remove_hugetlb_folio(src, folio, adjust_surplus);
+			list_add(&folio->lru, adjust_surplus ? &surplus_list : &list);
+			if (!adjust_surplus)
+				nr_persistent++;
 
 			if (++nr_demoted == nr_to_demote)
 				break;
 		}
 
+		if (list_empty(&list) && list_empty(&surplus_list))
+			continue;
+
 		spin_unlock_irq(&hugetlb_lock);
 
-		rc = demote_free_hugetlb_folios(src, dst, &list);
+		if (!list_empty(&list))
+			rc = demote_free_hugetlb_folios(src, dst, &list);
+		if (!list_empty(&surplus_list)) {
+			long tmp_rc;
+
+			tmp_rc = demote_free_hugetlb_folios(src, dst, &surplus_list);
+			if (rc >= 0)
+				rc = tmp_rc;
+		}
 
 		spin_lock_irq(&hugetlb_lock);
 
@@ -4018,6 +4037,14 @@ long demote_pool_huge_page(struct hstate *src, nodemask_t *nodes_allowed,
 			list_del(&folio->lru);
 			add_hugetlb_folio(src, folio, false);
 
+			nr_demoted--;
+			nr_persistent--;
+		}
+
+		list_for_each_entry_safe(folio, next, &surplus_list, lru) {
+			list_del(&folio->lru);
+			add_hugetlb_folio(src, folio, true);
+
 			nr_demoted--;
 		}
 
@@ -4029,7 +4056,7 @@ long demote_pool_huge_page(struct hstate *src, nodemask_t *nodes_allowed,
 	 * Not absolutely necessary, but for consistency update max_huge_pages
 	 * based on pool changes for the demoted page.
 	 */
-	src->max_huge_pages -= nr_demoted;
+	src->max_huge_pages -= nr_persistent;
 	dst->max_huge_pages += nr_demoted << (huge_page_order(src) - huge_page_order(dst));
 
 	if (rc < 0)
-- 
2.43.0


