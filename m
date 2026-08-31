Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B170C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 13:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB9CD6B0088; Mon, 31 Aug 2026 09:35:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6A076B008C; Mon, 31 Aug 2026 09:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7FB76B0092; Mon, 31 Aug 2026 09:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A71776B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:35:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B34E80113
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:35:46 +0000 (UTC)
X-FDA: 85161662292.04.B6BD99C
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf26.hostedemail.com (Postfix) with ESMTP id 53203140011
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:35:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=m2SKSnTB;
	spf=pass (imf26.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788183344;
	b=u7Jz39/Lxc0883IJO2f9DIcNJirmpOAt0Ssdstzmpi+StRKkkTefZ04z7XQU6YE473er+h
	/GpO7UMd4cQbncOdjQK5nXpmh5DIjYvVyNPHKx3fmNFCWktqN0i+PsjW5zO+1JITRvitk4
	xjXQbaJfjVSFjl7cty/jjq2JckfdQxY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=m2SKSnTB;
	spf=pass (imf26.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788183344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SeR1+mALksfzVZt4agnwdff+4ehIP+rnZ95J6spXEug=;
	b=NZlBZZW2zyBrPRB83Musef6z3526j/14iKpAaT30/i0Y+MMt6x4tKDeo09jwEHyRJF8YgR
	uzigutzpjyNHMIPSs/XqTv3vU/YcZfsI4eiVJiqXDD1Md2C+/YE16a95bjNCowSWxsvEwX
	QduRhCipB3BRiBlpogrvwAW+EyY7Cak=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Se
	R1+mALksfzVZt4agnwdff+4ehIP+rnZ95J6spXEug=; b=m2SKSnTBFVwCNze2g6
	hr979eG4m1npQqij6JEbCGskhQSApcqT1y/qW9WJ2rnN7ePjrdL6AvDwADMP9FS7
	TyXUzEh7QdGfdy/PQW1wT71AUgm22mTrfRKUugjOanCjj5RzuVGdLwCH5P8VdQ2J
	7M6RBeFwmBNrn4lJ+KtyYRXRM=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wBHHmEbg5VqFKS5Sg--.13223S3;
	Mon, 31 Aug 2026 21:35:26 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	mike.kravetz@oracle.com,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH v2 1/2] mm/hugetlb: preserve source surplus accounting during demotion
Date: Mon, 31 Aug 2026 21:35:18 +0800
Message-ID: <20260831133519.2505020-2-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831133519.2505020-1-xialonglong2025@163.com>
References: <20260831133519.2505020-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBHHmEbg5VqFKS5Sg--.13223S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFykGr4fWFyDJw4ktryfXrb_yoWrCw17pa
	yYkwnYkrW8Ar9xGr4Sq34qywn8G340vrWjya4fKr43J3ZxZ34UKr13Xw1UJayv9rWfJF43
	Xw4DZFyDWF43ZaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j2v38UUUUU=
X-Originating-IP: [39.144.46.203]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC3B7n4GqVgx6CpgAA3D
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 53203140011
X-Stat-Signature: 7kfm3sjnxw1wq73fzpg73con4p3s6os4
X-Rspam-User: 
X-HE-Tag: 1788183342-671731
X-HE-Meta: U2FsdGVkX19t+1xIEvAA1uorIylVKBVnftroJBD05ORkA9DpOCJ4Jc0V8JYvgHJRFjPYFPbwC3H4qxYBTGAjKMD7sBbEZap0LR2HCD3WJI81jAkz49kYR9eK7sNnA10FZHdxReLDc5fJTmYYJ8eOXbYCUt26UPxmEvUq1As2PpiLOaWiIicXj6EcbEIzdFkT4prRRIqa+/TcMXXNcC2k/zuvEs/pgsFSbXfI2p7njF5KOKbQC6Cx5mA+aYm010meK2RG6/Q5UFVR76oNCFnU5i+mwQyvOurZ5yLJQonC2wiVAspm0JaFeLNk9HRTaUTlf4n4FBaPzzcgTdx34jHsMHZJrVn3IyVHLQxb9pueVEJpFJAy2Xw5MLkLr3iMAYovxB465QFO1DL/s4Z5qqFTSxoKgjqTA8RLZpUWklF2DKavTyb86qveqnPRDOaKBAeuwpTizOE12c5tZOZr/yQD67uOcDri9lB5Zm3Lz7v67T4+v1GHHXj2kvcLkytjxpZt1T2en57PNlcdYecINIe06y35L/2VovSIS8vQueV7ROML+8p/qUwHS2sZALnfUjxs/uDvoWNeQ75uOxKXWfUuPEQiRlD5EE/NvTa+/5Ip/SCesT6eo2b3BfNhjH0DzZLdrrBtFj7SmyxtxML16LQDggTot/OSDUXdn8B256QvR/LUbDZob2uYxcjclvp3IxCmamRybJXBB5T5WELH/LvSO9CopEfzwSEgqiWCYcY4pIi0dO11snUUTqSeYwZaHlMYlYkM9QtS0nE4okETgnwBrRVq3zEpZ2szGANxs/6YEqY01obACB1vah8aq3/fi94doqEPNeHKvarOStWkb+BT3gPO5J6hLp6K1iuCaMUTvofLtiifFBo5B96VFII9PlOYcFAY9FXC9tzZpT9vzZRDRg0PxgV8eDaeHQ/gk+XRTwRTHp7deuQzXOOAgsgqXiD1dexL9V2UAGtiupEAPHz
 +R0tn58H
 NiRwMuWjoRxeQSoQq+0rESoD7Wxegxnk+kZSiVvOaqQ8sRK6M7R8SLXVHhrKL5RSbGG/Sb1zbyz1e2Nhn0fDjP2kPjTIGg4FPN5neogdzbKD0iIdYjgb8jbnCsnvn/irYgR7bf3kERKwykP6P/0AlvCUWF6BDhWQhS44rN2Qbybyl5V9dGfAntS95THAgxlkvXwHAHOrfmeI9WprX8mVMR8/sQQbA+PUVuxMCUt1u8qtSr2YLGgsaO0sZQFqI9H5ohw/hE6QsMuVlHKCfmAMzDfEqJk5GffYyw3lRWNTrLFNs2km+w+2GqhD2XoZlHY2Khqt0U+EZeI5OqoXOCUEieNcLsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

demote_pool_huge_page() currently removes every source folio as a
persistent folio. A free folio can instead account for one of the source
hstate's surplus pages, for example after a vmemmap restoration failure.
Removing such a folio without adjusting surplus_huge_pages makes the
persistent count underflow, and later subtracting it from max_huge_pages
can underflow that counter as well.

Classify selected folios against the node's surplus count while holding
hugetlb_lock, and preserve that classification on rollback. Track the
number of successfully demoted persistent folios separately so only those
folios reduce the source max_huge_pages target. All successfully demoted
folios still increase the destination target because the new destination
folios are added as persistent pages.

Testing:
Tested on an x86_64 QEMU guest booted with:

  hugepagesz=1G hugepages=0 hugetlb_cma=1G
  hugetlb_free_vmemmap=on

For testing only, add a one-shot fault injection that makes the first call
to __hugetlb_vmemmap_restore_folio() for an optimized 1 GiB folio return
-ENOMEM. Set nr_overcommit_hugepages to 1, then allocate one 1 GiB huge
page:

  nr=1 surplus=1 free=0 resv=0

Unmap it. The failed restoration leaves the folio on the freelist while it
is still accounted as surplus:

  nr=1 surplus=1 free=1 resv=0

Demote one page. Before this fix, the result is:

  nr=0 surplus=1 free=0 resv=0

After this fix, the result is:

  nr=0 surplus=0 free=0 resv=0

The fault injection is one-shot, so the restore performed during demotion
can succeed.

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


