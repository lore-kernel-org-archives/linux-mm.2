Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE49C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:00:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C46226B00A6; Mon, 21 Sep 2026 16:00:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6476B00A7; Mon, 21 Sep 2026 16:00:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A978C6B00A9; Mon, 21 Sep 2026 16:00:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 790536B00A6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:00:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 034741A02A7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:00:15 +0000 (UTC)
X-FDA: 85238836032.14.C0D7C83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 296C11A0014
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:00:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jq6hV1F6;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020814;
	b=vSrxRh3JZhtXAKzK7Cts0w2W+MQDdw58sgjTOPqCJDokhM1FV2HD/cuj7Mi3RYKEAl+1yD
	I1zd90wvpupFRoX0Uwlvn2jRqJnEA88OClCzK3fQlSPBZP4tfE/LuPaKQDmeg6utSwQKgO
	gwJ4sqXqOyiB4eF/AnM0MQuocz3XvNU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jq6hV1F6;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uohIE5Ud1GVLNxgqJo8HKP8fD50DZwtEDQQQXUSGv4w=;
	b=sYBl1XU327Sibc4Zsotd/5oDBXOIoMsnenStIobxPNbx1dppmR2glvGClikSG2+t4q9LUT
	62nwDhj12g4zYbL9SZkd7iUjXtLpoeZtWtZIKx+5bsdZSMkgIxnPh41Rx6TSHUekKecdBz
	T+To5MN0InzRz7ppZ9G6T5YwXukCGns=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7253C409AA;
	Mon, 21 Sep 2026 20:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD441F00899;
	Mon, 21 Sep 2026 20:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020813;
	bh=uohIE5Ud1GVLNxgqJo8HKP8fD50DZwtEDQQQXUSGv4w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jq6hV1F6xq6J8paTwQAAKGSZfhRwBlx2ocNzRoGzAaeORMDZmCkdqNYnfSdjAeO1b
	 +9p6CA+RwWfuvXt10ONB9W+ARG+TRUSzP3yB/rvbPEoV7h3x7sWzTsshsCjvNmiYGY
	 pBeNThQ0lLtRgem+7/J6YCSayEmXI1vm2Zk2k4NBkI3YmmdMrQ3cdcuezTOKG2FrFE
	 lgDhSxeZUhIapwQdP/NIGtTHVR9WrFUgyzf1vIMzHaMAiPKF/+4ea3XVxFC/PCdRe9
	 xOsz/YATuBG0ycnif7zegeGNKE1Iar5n84GNQdAAh5k4IHAw6h6OIYVEPlVJ1t2c0T
	 4oV+JRhM4bYhg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 21 Sep 2026 21:58:58 +0200
Subject: [PATCH v2 06/13] mm/sparse: rename __highest_present_section_nr to
 __highest_used_section_nr
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-b4-sparsemem_cleanups-v2-6-54d81d65e125@kernel.org>
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3714; i=david@kernel.org;
 h=from:subject:message-id; bh=ZMj3GL7XkJQuzRyY7F15KJiefRjsZ0PhiN7MkSd9scA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI29rSdNVMPfzFfW2Wpj0ti81133uaDAdce7T7Wd0Gw2
 MTRMk25o5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIlIKzP8U9rU8CH6Dmtb5QHP
 w6sX/M84WP5Rv2dHk45SBPvLxqwyM4a/YhwN8mbHrj+WeuvGKmh4Y9nqR75Z1+zn/muoXe5857c
 RHwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 296C11A0014
X-Stat-Signature: x46h5ie3t47ksme685y1po38ju3th9ai
X-HE-Tag: 1790020814-752883
X-HE-Meta: U2FsdGVkX1+o+iewFJd5jRv9vfKMjUPyDIyNhgZ/q+sDM4beRmU3E1birPL4rSHwWt53FIcP73+15DLkQCDtTDfsB1t8V7ttjndWl2u1AysLSHxDVOcAiCWtpTb3Kf4ttVLGBi403vIywRDYsMJF6wYU+egWru3BIq1Zm02zR/6tS0XsfsbKhUQ3MH/x2Y2nLs1mkTK7lclv4vyLLAlB8v29c19gyQSJ6zcoou43MuJ8ylNguWxff2Es7vG34Xx41usSvhU5hmUSr643KPMynIp7DQL03eRqmX9Z8/cHjPzjAkP+fF9oJPdPbKjfc/7XWvU4YiVf/XO4Y6tOpUWLH+gKQvzZXiCoa9Yb3G57HBK3FaqpiQpvzVuZ0YJWjM/fCKK6S6TH4X5ofKP52Ocam47Zp2vogn9A+wgbQE9QpB++MfyoP0YBpcjc4bug3E8WSrXYVbQUvf/zTHBhm36D9wulbdesaDkvLetMKDMQgwHB3vtpdu4uim5aWXmDcGfoYvcyJ5cxdM7CFBVrtIBD6z5BvLzqhFSJKQxcqPLpRU1oEX3u2VRv3xclc+NVudIfaUxLkG3uDRMg7oABGSxHhxOaWGsj1/wHT9PKE53YAqFTdSNCp5VcR7mCrucWA8HT65s1yGtIP7I5bb0FELLTUU8KZfmWS/edWv/2U3InWy0Ue2v6tU3F1fbghi9PA0r07I/nO/Rv1swlqYN7NbsLAyS+3i9kgcDo1C8daluz08aXkV/DdLkuILTi0nOL8iQnmNHqX0lZP9g9j5v5Thd+gMrEWQM1wMgGyJHQolaX3hx+UfhbNADgl6hZQs/B3JQKsjd8vpMiHT+5hp+V4tSdZwM6ftLGS2jECfm7p4m8MY/ouVcJol2W7pbnvoOdCMhfWMjuricLewwpKxQrvhzc1Was/TLSr1O1hfR5JSNdKhIlf8iUXLVn5xeg8NupxWxWJvxdnpmKGHqev06R8TK
 BuD0Ph3p
 NyWSdeSFbPtgS1hBa3yvhWprVWf8ozVoJacE1EpgNQ+d+3tn+CRUu4c7u+Giapyq1X8at1RG8WD4J/+RG9SEv1DNJchZ9D3NRhz7LDI7s+DyPfNMm0dofWdaR1mRCMU3j0jwv9hhJJGe6pANJksS5wu6v4/MOL1wLuy2sILQyJ3WcvoyEk9Xd0PZEexXOqEZHhAMupUwUTIJI4V58oiuKIa9dkQZNtcInX+7b1XCeCPVqHiHyJ45IoZnyog/8Xz9VbieKN0NQ5e49ywuQ9NZsFvoxVNvjH/2dosDOvxC3PHCUM2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for getting rid of SECTION_MARKED_PRESENT, rename
__highest_present_section_nr and clarify the comment.

Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mmzone.h |  6 +++---
 mm/compaction.c        |  2 +-
 mm/sparse.c            | 12 ++++--------
 mm/sparse.h            |  4 ++--
 4 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ebbda6f311392..0c2fea48c261b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2181,7 +2181,7 @@ static inline struct mem_section *__pfn_to_section(unsigned long pfn)
 	return __nr_to_section(pfn_to_section_nr(pfn));
 }
 
-extern unsigned long __highest_present_section_nr;
+extern unsigned long __highest_used_section_nr;
 
 static inline int subsection_map_index(unsigned long pfn)
 {
@@ -2280,7 +2280,7 @@ static inline unsigned long first_valid_pfn(unsigned long pfn, unsigned long end
 
 	rcu_read_lock_sched();
 
-	while (nr <= __highest_present_section_nr && pfn < end_pfn) {
+	while (nr <= __highest_used_section_nr && pfn < end_pfn) {
 		struct mem_section *ms = __pfn_to_section(pfn);
 
 		if (valid_section(ms) &&
@@ -2335,7 +2335,7 @@ static inline int pfn_in_present_section(unsigned long pfn)
 
 static inline unsigned long next_present_section_nr(unsigned long section_nr)
 {
-	while (++section_nr <= __highest_present_section_nr) {
+	while (++section_nr <= __highest_used_section_nr) {
 		if (present_section_nr(section_nr))
 			return section_nr;
 	}
diff --git a/mm/compaction.c b/mm/compaction.c
index 4994e200bbecd..f1b2060eb2016 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -216,7 +216,7 @@ static unsigned long skip_offline_sections(unsigned long start_pfn)
 	if (online_section_nr(start_nr))
 		return 0;
 
-	while (++start_nr <= __highest_present_section_nr) {
+	while (++start_nr <= __highest_used_section_nr) {
 		if (online_section_nr(start_nr))
 			return section_nr_to_pfn(start_nr);
 	}
diff --git a/mm/sparse.c b/mm/sparse.c
index 3c19d47559090..bb89017254f4d 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -164,15 +164,11 @@ static void __init mminit_validate_memmodel_limits(unsigned long *start_pfn,
 }
 
 /*
- * There are a number of times that we loop over NR_MEM_SECTIONS,
- * looking for section_present() on each.  But, when we have very
- * large physical address spaces, NR_MEM_SECTIONS can also be
- * very large which makes the loops quite long.
- *
- * Keeping track of this gives us an easy way to break out of
- * those loops early.
+ * Looping over all possible memory sections is expensive, especially if
+ * NR_MEM_SECTIONS is large but only a fraction is actually used. Keep track of
+ * the highest section number we ever used.
  */
-unsigned long __highest_present_section_nr;
+unsigned long __highest_used_section_nr;
 
 static inline unsigned long first_present_section_nr(void)
 {
diff --git a/mm/sparse.h b/mm/sparse.h
index 4ee507c34b98d..242b7bab0013c 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -44,8 +44,8 @@ static inline void sparse_init_one_section(struct mem_section *ms,
 static inline void __section_mark_present(struct mem_section *ms,
 		unsigned long section_nr)
 {
-	if (section_nr > __highest_present_section_nr)
-		__highest_present_section_nr = section_nr;
+	if (section_nr > __highest_used_section_nr)
+		__highest_used_section_nr = section_nr;
 
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }

-- 
2.43.0


