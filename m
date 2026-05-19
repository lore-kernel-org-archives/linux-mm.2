Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D91F5CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 14:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 362D96B0005; Tue, 19 May 2026 10:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33A1D6B0088; Tue, 19 May 2026 10:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2506A6B0096; Tue, 19 May 2026 10:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16B2A6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:12:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF1611C001E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:12:54 +0000 (UTC)
X-FDA: 84784360668.17.D88D38F
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf10.hostedemail.com (Postfix) with ESMTP id EA780C000D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:12:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf10.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779199972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ysqOe9DpzUv4YClbG9m+BVVZcmbA7eagpaA8Np3PFNo=;
	b=jeOwa4XJzlUIpmPmtn2ZeVuYLlu8+MD0ZcHu1EMnDpbdgpaayjRUIo9E9zLg6Xg3x62Rpf
	0A4rCi2+2A8kEeBNqVhfYdIUjUbVoprwdiCSpkBt32kIXW+0ZVinQMxdDd5vsuLC3qmAjC
	wZo9kZwWbwgAethS7NbJMcaBuy3EHGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779199972; a=rsa-sha256;
	cv=none;
	b=ZJjsZXqXhd0oeyL9Smf7ZvO3KRqVpF0AY0cVnK4T+t8sN2w3paYuyHOxpzCw9TvAS1RMKa
	b084JyA0LZGRZvU/6BQgsoSc59vp8gmUaYC5mmOosqNEmkWjJcz+onVRRbzZs5b4RKwsQV
	xUvLQR8zSINHGMDlRYcqxGn//9feoiM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf10.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gKc815Wshz8XrrJ;
	Tue, 19 May 2026 22:12:49 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 64JECenP060106;
	Tue, 19 May 2026 22:12:40 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 19 May 2026 22:12:44 +0800 (CST)
X-Zmail-TransId: 2afb6a0c6fdc718-f0c9a
X-Mailer: Zmail v1.0
Message-ID: <20260519221244272O8Chn7CcMIG3xDLxJf_aQ@zte.com.cn>
In-Reply-To: <20260519220536792dMIKRMurt3vZ5lXC5pwh8@zte.com.cn>
References: 20260519220536792dMIKRMurt3vZ5lXC5pwh8@zte.com.cn
Date: Tue, 19 May 2026 22:12:44 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
        <hughd@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <michel@lespinasse.org>,
        <corbet@lwn.net>, <wang.yaxin@zte.com.cn>, <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHY1IDMvNV0ga3NtOiBhZGQgcGdvZmYgaW50byBrc21fcm1hcF9pdGVt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64JECenP060106
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 19 May 2026 22:12:49 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0C6FE1.000/4gKc815Wshz8XrrJ
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EA780C000D
X-Stat-Signature: gy6ibrp91b6zwydrca7wg784fhswtm4y
X-Rspam-User: 
X-HE-Tag: 1779199971-307450
X-HE-Meta: U2FsdGVkX1/tdOF7DVq1X2ftAeoMON7F/x6cZXe641ONd3rozThPNfPmlFZfp4a6eF8rT3J+a7CHSy2syRmobS6IUiRDOgnRB7voFZT3zy18a6q/83wO9TGcU6HXqZ2fJu1Y1FSwPUsqEc2fgDchBlBMh+6ijTd/DMG5ZKxvaJHq0DS8NW1vUKRTi4ESCT7rp0HcGmVhA6/ahcAFG0HRnk1+4VuK6FOWi6Xwn+IvtwTdq7pSikE4nrr2Vkk16vVGi1tz0es4rOC3AYuU0qu+yWJIL4s0wLWrKTOv7A0skabnJjHMjE2c32WDdKr3pRUCrpRPT7IBuYqHwPk3HlKu6tZhTgtfFAJqvLMAMD7cylPIAu+fckX7wiKuiJAgy1jRkRoB0nmHXjBeblU4DStqAzAgNcBnSw6R0skssbtWRzDN9v6AMd3uIubLvianYfmATnA/VZ3V2SPHSA85DSlZ4FWqaR/FD1lqluA0MF7B9KG0mpeFcEr+QyodIJOxHXa0rx1LwA+X6ma2U1Nu6HFfVp9Edd/NU44HX9fw1ZiFim1TAEOZFUyP3WRQwr9xfaODUwAV42xAoSCqHcXPoPKT8gLnV42qowbCSkPf3pQcRt+fBXHnODZBMu71HIWhNNjuyHKrSlW1cgv+joDNO5LQGDFo90z7VkNSrK3BX8ZJ5NsbDT66q6z83ikori+tGjbYVkg0TSlk3HDAuUbclYXZNki+VV0X6nzVzIeI7B/uy1ceymvZ0QM3HBPoiUOSBJlg3CWaYaTOV854SajK2IjyieAZfs6mTS7MPzGZlh1vReFpa1nTzu0UrAFf4WDwuYaCA6dWrAMT1rnh37AGQzRkyxEl0CZzdFBIn/oji+qvjr7dYqMsClWtOJLdOxTWORRRBerLyxnEAQmH9BiBuW7olnO8FRkZ/sCNkH1LYixnBoqlNnOKGg4+ubkNmny5FU84Z0A1ADohGSSTSc7NCNI
 nB7AkN2N
 uORnq74MpCwBRSGFskVIso7kg5yMFa9NZvyyzX6IZeR1dNkg/xiaH7sFCMEUbMM4LS6gkdrDZ47jwttcYu0n4kCgQ7u1MdJbdf8WYEbusxI/VulE1xjrz1PSD2irg6sRtbQPwH/8no6idPnMzUgnKvvVcx33god9QQQn64kO5VXsgDscvwh6h6S8B0PfgsAa7ih5eMUuE/st8FBminM7TfRvH2kOifyp9pAAqcIH4ZR27DGaLQHeXiOxGOxS+tfVSGkPpFXMWCU/ksZgWpGffRTbMAVQITx5eLwnw2mv6Lsz0B1KlJ5mdApDjrazR5g3ckGiGrDKmGVPszZo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

The reason for adding pgoff to ksm_rmap_item has been discussed in previous
mailing list threads [1][2]. The main purpose is to allow the KSM reverse mapping
to obtain the original page's linear page index, so that during anon_vma_tree
travering, it can conditionally locate the VMAs and avoid scanning the entire
address space [0, ULONG_MAX].

To minimize the size impact of adding pgoff to ksm_rmap_item as much as
possible, a trick that David suggested is to use a UNION that groups the members
related to the unstable tree together with the newly added linear page index. The
members that valids only when in unstable tree include oldchecksum and age information.
However, the function should_skip_rmap_item() in the smart scanning needs slight
modification, since this function still uses the age information even when the
rmap_item is in a stable state (the page is not KSM), a situation that occurs
during COW faults. After using union, the size is still 64 byte without increasing.

We keep the same way to store the pgoff as rmap->anon_vma which is set when the page
is merged and become a KsmPage at try_to_merge_with_ksm_page(), and reset at
remove_rmap_item_from_tree() and remove_node_from_stable_tree() and reset when break_cow.

To be specially clarified, the reason for resetting pgoff at break_cow() is:

- When a page successfully becomes a KSM page (i.e., after stable_tree_append()
  sets STABLE_FLAG), both anon_vma and pgoff are stored and remain valid.
- However, during the merging process there are several failure paths where a
  page that was temporarily treated as a KSM page must be reverted back to an
  anonymous page. Examples include:
    * The second call to try_to_merge_with_ksm_page() fails in
      try_to_merge_two_pages().
    * stable_tree_insert() fails in cmp_and_merge_page().
  In such cases, break_cow() is invoked to break the COW mapping and discard
  the KSM state.

Currently, break_cow() already contains a put_anon_vma(rmap_item->anon_vma)
to release the reference taken during the aborted merge. Because 'pgoff' is
logically paired with anon_vma (both are only meaningful when the rmap_item
is in a stable state), it must also be cleared (or reset) in break_cow() to
avoid leaving stale pgoff values that could confuse subsequent rmap walks
or scanning logic.

[1] https://lore.kernel.org/all/adTPQSb-qSSHviJN@lucifer/
[2] https://lore.kernel.org/all/202604091806051535BJWZ_FTtdIm3Snk24ei_@zte.com.cn/

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..4761ca3fa984 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -195,22 +195,28 @@ struct ksm_stable_node {
  * @node: rb node of this rmap_item in the unstable tree
  * @head: pointer to stable_node heading this list in the stable tree
  * @hlist: link into hlist of rmap_items hanging off that stable_node
- * @age: number of scan iterations since creation
- * @remaining_skips: how many scans to skip
+ * @age: number of scan iterations since creation (unstable node)
+ * @remaining_skips: how many scans to skip (unstable node)
+ * @pgoff: pgoff into @anon_vma where the page is mapped (stable tree)
  */
 struct ksm_rmap_item {
 	struct ksm_rmap_item *rmap_list;
 	union {
-		struct anon_vma *anon_vma;	/* when stable */
+		struct anon_vma *anon_vma;	/* for reverse mapping, when stable */
 #ifdef CONFIG_NUMA
 		int nid;		/* when node of unstable tree */
 #endif
 	};
 	struct mm_struct *mm;
 	unsigned long address;		/* + low bits used for flags below */
-	unsigned int oldchecksum;	/* when unstable */
-	rmap_age_t age;
-	rmap_age_t remaining_skips;
+	union {
+		struct {
+			unsigned int oldchecksum;
+			rmap_age_t age;
+			rmap_age_t remaining_skips;
+		};			/* when unstable */
+		unsigned long pgoff;		/* for reverse mapping, when stable */
+	};
 	union {
 		struct rb_node node;	/* when node of unstable tree */
 		struct {		/* when listed from stable tree */
@@ -776,6 +782,10 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
 	return vma;
 }

+/*
+ * break_cow: actively break the write-protect of the VMA. This is called when
+ * rmap_item has not yet become stable, but page has been merged.
+ */
 static void break_cow(struct ksm_rmap_item *rmap_item)
 {
 	struct mm_struct *mm = rmap_item->mm;
@@ -787,6 +797,8 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
 	 * to undo, we also need to drop a reference to the anon_vma.
 	 */
 	put_anon_vma(rmap_item->anon_vma);
+	/* Reset pgoff that might overlay age-related information. (still unstable) */
+	rmap_item->pgoff = 0;

 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
@@ -899,6 +911,8 @@ static void remove_node_from_stable_tree(struct ksm_stable_node *stable_node)
 		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
 		stable_node->rmap_hlist_len--;
 		put_anon_vma(rmap_item->anon_vma);
+		/* Reset pgoff that might overlay age-related information. */
+		rmap_item->pgoff = 0;
 		rmap_item->address &= PAGE_MASK;
 		cond_resched();
 	}
@@ -1052,6 +1066,8 @@ static void remove_rmap_item_from_tree(struct ksm_rmap_item *rmap_item)
 		stable_node->rmap_hlist_len--;

 		put_anon_vma(rmap_item->anon_vma);
+		/* Reset pgoff that might overlay age-related information. */
+		rmap_item->pgoff = 0;
 		rmap_item->head = NULL;
 		rmap_item->address &= PAGE_MASK;

@@ -1598,8 +1614,15 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 	/* Unstable nid is in union with stable anon_vma: remove first */
 	remove_rmap_item_from_tree(rmap_item);

-	/* Must get reference to anon_vma while still holding mmap_lock */
+	/*
+	 * Must get reference to anon_vma while still holding mmap_lock,
+	 * We set these two members of stable node here instead of
+	 * stable_tree_append(), maybe because we don't want to hold
+	 * mmap_read_lock again. Here mmap_read_lock is already held to
+	 * find_mergeable_vma before merging.
+	 */
 	rmap_item->anon_vma = vma->anon_vma;
+	rmap_item->pgoff = linear_page_index(vma, rmap_item->address);
 	get_anon_vma(vma->anon_vma);
 out:
 	mmap_read_unlock(mm);
@@ -2458,6 +2481,10 @@ static bool should_skip_rmap_item(struct folio *folio,
 	if (folio_test_ksm(folio))
 		return false;

+	/* There is no age information in stable-tree nodes. */
+	if (rmap_item->address & STABLE_FLAG)
+		return false;
+
 	age = rmap_item->age;
 	if (age != U8_MAX)
 		rmap_item->age++;
-- 
2.25.1

