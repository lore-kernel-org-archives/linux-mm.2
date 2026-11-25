Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CEE0606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oQvinOFN
Received: by kanga.kvack.org (Postfix)
	id 675246B0B11; Wed, 25 Nov 2026 17:37:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64C8E6B0B13; Wed, 25 Nov 2026 17:37:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562AC6B0B14; Wed, 25 Nov 2026 17:37:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24EB36B0B11
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:37:45 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 991D01A014D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:37:44 +0000 (UTC)
X-FDA: 85475104848.19.6C96CC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C064D40006
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:37:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oQvinOFN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646262;
	b=R0sqbhRW08eUotc6G/BcuQlANJFGjs1U2+400xte14okeeHyQUqtvMZWxrKI31q3Pl7eTj
	LqRWJ77jTuMgoxGwfiMofD+5WeHQt9W38QJ6uJKvD4eMSJIGpqQb326464vHnTltitKg+C
	7mKMI+seldBas/cNiJ8vfk4RiDTeBmg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+6EYpLgAE/mRgNpOZ7Q+hz1peRJcwyxpJJGTowJORQ=;
	b=CMbz5tbmCenuUbGFFUEfJTJ+s6raZ5Hmz2koBy5Nl54EO7ZO1wUrN0jKz+DMsPLrLWoIbC
	1yA2eC8X0HDpTLRRHNC4iIUNyPye41qhAw/BMI8lrtscsjJ/kOLWQninsZHZ4Z3kbpfHsG
	a61rfx9n5JXIZfUqoofo6QWTMQwlva8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oQvinOFN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC4864137F;
	Wed, 25 Nov 2026 22:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078B91F000F2;
	Wed, 25 Nov 2026 22:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646261;
	bh=P+6EYpLgAE/mRgNpOZ7Q+hz1peRJcwyxpJJGTowJORQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oQvinOFN/+eS1gGNlyA1jrdenJLPZtq89iypBXtBD1BQptJqVTX8+7qZpvlAuw+So
	 mvtePvyGjYUzUSP9Dd9Z6JFJEtsSE47C1cECBg4vBmMC6X/HvWMN+a9DgTKUU4vwT4
	 NbOKg9iC2ODpta1AzEMd74Wf5QHE8zXqS1bMsqKBLH9n1/Gu61xk/52CFGisAS0S+7
	 Y8axHVPNj0oaBbSpQcD2ffZCXyELzvSEyF0DGvOg2dYGIJg3kHOOX84fJQBegxe+pQ
	 ofKaZOBjgb1tNK67YWADuwG5m/rDL6he2H1p9LhgD/eJzMlWDkR/n6C9xhRc1HgT8l
	 +jZA56D1JMxHg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:14 +0100
Subject: [PATCH 16/21] mm/hugetlb_cgroup: track in-use folios per cgroup
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-16-db27fd2f71a8@kernel.org>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Jinmeng Zhou <jinmengzhou22@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Mike Kravetz <mike.kravetz@oracle.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Dave Airlie <airlied@redhat.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Mel Gorman <mel@csn.ul.ie>, Dave McCracken <dave.mccracken@oracle.com>, 
 Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, James Houghton <jthoughton@google.com>, 
 Yang Shi <shy828301@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Wanpeng Li <liwanp@linux.vnet.ibm.com>, Andi Kleen <ak@linux.intel.com>, 
 Kenneth W Chen <kenneth.w.chen@intel.com>, Hugh Dickins <hugh@veritas.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Joern Engel <joern@logfs.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, 
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, 
 "Kirill A. Shutemov" <kirill@shutemov.name>, 
 Sasha Levin <sasha.levin@oracle.com>, 
 Guillaume Morin <guillaume@morinfr.org>, Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Andrew Morton <akpm@osdl.org>, linux-doc@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7023; i=david@kernel.org;
 h=from:subject:message-id; bh=Un1Xv2jSf94pjywu3PzLRYXUs4bjXbYIlpqIZ6naE1Y=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1SdXkcXzRcvvv/mxMoDJ4R9jYVdLxw990HLKkZV+
 WFdxu5fHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAFzEj+GfrlOwQu95w3Oly51v
 XQ+zduRnj3/PyVlaIRmjb6awtmkuw/9Ih2jjPuuKRWtFrk7dt+tvq065yqQlngdOdEzsXdxyxJ4
 HAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: kjw59drn1oczgfw1gear6m96yz3tcm4g
X-Rspamd-Queue-Id: C064D40006
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795646262-926656
X-HE-Meta: U2FsdGVkX1+DIVjlAI4JqyBjyvcGMD7MKiqFShgakVfrVhmgcQobX4JF+2K3en7MO+xKhrxkQ/AHqKP2s2l64eo3PeNNZFzIcNECrF3oE0wtt0T/KfrC1n7pdHUnca9KK/404j11VTYX8LT16r4mMsuAKanoR1uJ0T/TlkY7pfjKuuP5gjFQN/jZ+iMOUMtw8ltAIF5Jh/xyCNoFWBiKqWPwk3Dayzn04XZWt2pI8s28KIz6AYnWs57m/lHWRnOWIxA3Do9h/EKft7ZxKrgYiY1puy9umCePHPUnPAEHDYttTHnKsJcy2xs3RhlawYAi0by8QiCzD0LyiHHZnHRdmisd2CXBm5ahRw5+K9g5PLFkoQ/xodhi4MAVIsLH1h9O7nCDnAW82gt2sINLyiLP98zcu7ioITBhUK4rodSX2XJIUrfQK/EMRWKA69x0C3d4RcmU5oU6bschft5DXlTfcDZPsR0wDB84AL1iS8fmlGH0kgyv+iWR7T9l9hxy3HBUH4TF67tVEGUfosLaOCjFT+hv+mXOdXgCLpIu9g+udw7L8KRCc6NmFhY/UQgY7OsieSDI2U1Y1QGOntXufp+quZCE31XbR6rtQIJZqc3Ayx0aN0g1hOsc41r0/UARWqy2YQ87fgarpxOmTtYoXEEWy9xC3CSwShsBmcJF3IuDWasGTOW6LYSnnucz0a+HFwI2aqOXtqqL9f8g99IosMQHYKlRb0uvxhnnEJ++RjkaAIBjOsAWMkaQUwoWO4si0JiimiSlTdyj/IRR4SGZ9t7HFjCuusEfUYPHJ3U/jntGwQwhlawIMH2TVWlLL6/HZE7Q0dfP47JY9l+MeyBie9mW7J+aUNKW1EjooFeAQOWx8yJuxjFxXRJRfLQ6InIfMysi52Y3vMHNA5nRkVaLofy68v3g1c4rs6igT4h++2nUbUqXM5m4KokGD0KhlVfUyR8Y4zqrkrlo7rCqqdsEQ1l
 4BQgIL7X
 ZJf2EKz6v/9JWbTTlee2BqJ9m2B8BuNkS7hkTM09bx3alz0YjhPyBKqDWYMv4EOTeTumVYKi9TdVTDxm8MWsaBhLfRC1UqVo1HOQWUjAsEprmXR3ZKPgkT8RhO5bcttYPHWtXI0nuLBinpdWCyW0j5vjlMyuteB7dbi+YVkH84qOi6AgG8LnM7u5WxKp0HmyCQA1l9xXRgmgNUQ37gDTipTsm/omJeptSM3NPYXinvCcH5fczotzh8zltcjRHPTAJs3wF0D9Akt/liSFIpy1K/KsnCF3CNKFHcupr6ff6g1L5oNoDa93/9nhdgTYA9SBKA8G84ZpHV79ZUQiCL04rd6r1hCUTyQxq2q40+r/tXAmRSlxZBqcH49d2n8e4B3ISMTFqf5U18sntBWECzJXpaYBSK04qlfsrbGJnTFTQ5iOhqgYdrMNxWiT5fM/pTpeHw4yX/PGyKGSFkOGq8RVR+xXrPhd37v4j3Nkl/UIbgsz8V0+kv8bbB3lH8cYJQBY/w75BHMFcN4lbGfVuUJDZjZC6IUIVaXsxqJHh4rqRzSjXFVRlGq9wliFXLAFJDPNMgk7+3BTk3Y0PNhrTmcpNgv0BFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

When offlining a hugetlb cgroup, hugetlb_cgroup_css_offline() walks the
list of all in-use hugetlb folios of each hstate with hugetlb_lock held
and interrupts disabled, to reparent the folios charged to the dying
cgroup. With many in-use hugetlb folios, that can keep interrupts
disabled for a long time on every hugetlb cgroup removal, even for
cgroups that never charged any hugetlb folios.

Let's fix it by keeping in-use folios that are charged to a hugetlb
cgroup on per-cgroup lists, so offlining only has to walk the folios of
the dying cgroup.

Process in batches to not keep interrupts disabled for too long when a
single cgroup has many folios. Use batches of 32, like reclaim does with
SWAP_CLUSTER_MAX.

This has low urgency, as it only matters with a lot of hugetlb folios;
let's not CC stable.

Fixes: da1def55919f ("hugetlb/cgroup: add support for cgroup removal")
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: add lock checks, add HUGETLB_CGROUP_OFFLINE_BATCH, simplify
  comments and description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/hugetlb_cgroup.h | 20 ++++++++++++++++++++
 mm/hugetlb.c                   |  4 ++--
 mm/hugetlb_cgroup.c            | 34 ++++++++++++++++------------------
 3 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index b4e0958eabf3b..1c437eb2e1c30 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -54,6 +54,9 @@ struct hugetlb_cgroup {
 	/* Handle for "hugetlb.events.local" */
 	struct cgroup_file events_local_file[HUGE_MAX_HSTATE];
 
+	/* In-use folios whose usage is charged here, under hugetlb_lock. */
+	struct list_head activelist[HUGE_MAX_HSTATE];
+
 	struct hugetlb_cgroup_per_node *nodeinfo[];
 };
 
@@ -100,6 +103,17 @@ static inline void set_hugetlb_cgroup_rsvd(struct folio *folio,
 	__set_hugetlb_cgroup(folio, h_cg, true);
 }
 
+static inline struct list_head *hugetlb_folio_activelist(struct folio *folio)
+{
+	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_folio(folio);
+	struct hstate *h = folio_hstate(folio);
+
+	lockdep_assert_held(&hugetlb_lock);
+	if (!h_cg)
+		return &h->hugepage_activelist;
+	return &h_cg->activelist[hstate_index(h)];
+}
+
 static inline bool hugetlb_cgroup_disabled(void)
 {
 	return !cgroup_subsys_enabled(hugetlb_cgrp_subsys);
@@ -185,6 +199,12 @@ static inline void set_hugetlb_cgroup_rsvd(struct folio *folio,
 {
 }
 
+static inline struct list_head *hugetlb_folio_activelist(struct folio *folio)
+{
+	lockdep_assert_held(&hugetlb_lock);
+	return &folio_hstate(folio)->hugepage_activelist;
+}
+
 static inline bool hugetlb_cgroup_disabled(void)
 {
 	return true;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 796f02a4ded63..5db97f6d15595 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7608,7 +7608,7 @@ void folio_putback_hugetlb(struct folio *folio)
 {
 	spin_lock_irq(&hugetlb_lock);
 	folio_set_hugetlb_migratable(folio);
-	list_move_tail(&folio->lru, &(folio_hstate(folio))->hugepage_activelist);
+	list_move_tail(&folio->lru, hugetlb_folio_activelist(folio));
 	spin_unlock_irq(&hugetlb_lock);
 	folio_put(folio);
 }
@@ -7684,7 +7684,7 @@ void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
 	 */
 	spin_lock_irq(&hugetlb_lock);
 	folio_set_hugetlb_migratable(new_folio);
-	list_move_tail(&new_folio->lru, &(folio_hstate(new_folio))->hugepage_activelist);
+	list_move_tail(&new_folio->lru, hugetlb_folio_activelist(new_folio));
 	spin_unlock_irq(&hugetlb_lock);
 }
 
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 6921b18572666..6ee771334a3bd 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -28,6 +28,8 @@
 #define DFL_TMPL_SIZE		ARRAY_SIZE(hugetlb_dfl_tmpl)
 #define LEGACY_TMPL_SIZE	ARRAY_SIZE(hugetlb_legacy_tmpl)
 
+#define HUGETLB_CGROUP_OFFLINE_BATCH	32
+
 static struct hugetlb_cgroup *root_h_cgroup __read_mostly;
 static struct cftype *dfl_files;
 static struct cftype *legacy_files;
@@ -123,6 +125,8 @@ static void hugetlb_cgroup_init(struct hugetlb_cgroup *h_cgroup,
 		VM_WARN_ON_ONCE(ret);
 		ret = page_counter_set_max(rsvd, limit);
 		VM_WARN_ON_ONCE(ret);
+
+		INIT_LIST_HEAD(&h_cgroup->activelist[idx]);
 	}
 }
 
@@ -219,18 +223,8 @@ static void hugetlb_cgroup_move_parent(int idx, struct hugetlb_cgroup *h_cg,
 {
 	unsigned int nr_pages;
 	struct page_counter *counter;
-	struct hugetlb_cgroup *hcg;
 	struct hugetlb_cgroup *parent = parent_hugetlb_cgroup(h_cg);
 
-	hcg = hugetlb_cgroup_from_folio(folio);
-	/*
-	 * We can have pages in active list without any cgroup
-	 * ie, hugepage with less than 3 pages. We can safely
-	 * ignore those pages.
-	 */
-	if (!hcg || hcg != h_cg)
-		goto out;
-
 	nr_pages = folio_nr_pages(folio);
 	if (!parent) {
 		parent = root_h_cgroup;
@@ -244,8 +238,7 @@ static void hugetlb_cgroup_move_parent(int idx, struct hugetlb_cgroup *h_cg,
 	hugetlb_cgroup_move_usage(h_cg, parent, folio, folio);
 
 	set_hugetlb_cgroup(folio, parent);
-out:
-	return;
+	list_move(&folio->lru, hugetlb_folio_activelist(folio));
 }
 
 /*
@@ -255,15 +248,20 @@ static void hugetlb_cgroup_move_parent(int idx, struct hugetlb_cgroup *h_cg,
 static void hugetlb_cgroup_css_offline(struct cgroup_subsys_state *css)
 {
 	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(css);
+	struct folio *folio, *next;
 	struct hstate *h;
-	struct folio *folio;
 
 	do {
 		for_each_hstate(h) {
-			spin_lock_irq(&hugetlb_lock);
-			list_for_each_entry(folio, &h->hugepage_activelist, lru)
-				hugetlb_cgroup_move_parent(hstate_index(h), h_cg, folio);
+			int idx = hstate_index(h);
+			unsigned int nr = 0;
 
+			spin_lock_irq(&hugetlb_lock);
+			list_for_each_entry_safe(folio, next, &h_cg->activelist[idx], lru) {
+				hugetlb_cgroup_move_parent(idx, h_cg, folio);
+				if (++nr == HUGETLB_CGROUP_OFFLINE_BATCH)
+					break;
+			}
 			spin_unlock_irq(&hugetlb_lock);
 		}
 		cond_resched();
@@ -367,6 +365,7 @@ static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 		 */
 		WRITE_ONCE(h_cg->nodeinfo[folio_nid(folio)]->usage[idx],
 			   usage + nr_pages);
+		list_move(&folio->lru, hugetlb_folio_activelist(folio));
 	}
 out:
 	if (!rsvd && charged_h_cg)
@@ -940,7 +939,6 @@ void hugetlb_cgroup_migrate(struct folio *old_folio, struct folio *new_folio)
 {
 	struct hugetlb_cgroup *h_cg;
 	struct hugetlb_cgroup *h_cg_rsvd;
-	struct hstate *h = folio_hstate(old_folio);
 
 	if (hugetlb_cgroup_disabled())
 		return;
@@ -957,7 +955,7 @@ void hugetlb_cgroup_migrate(struct folio *old_folio, struct folio *new_folio)
 
 	hugetlb_cgroup_move_usage(h_cg, h_cg, old_folio, new_folio);
 
-	list_move(&new_folio->lru, &h->hugepage_activelist);
+	list_move(&new_folio->lru, hugetlb_folio_activelist(new_folio));
 	spin_unlock_irq(&hugetlb_lock);
 }
 

-- 
2.56.1


