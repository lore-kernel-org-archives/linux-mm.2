Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF1ECD585A
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 11:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E72356B009E; Wed,  7 Jan 2026 06:34:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2F256B009F; Wed,  7 Jan 2026 06:34:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70926B00A0; Wed,  7 Jan 2026 06:34:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C4AB86B009E
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:34:15 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 705B38B23D
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:34:15 +0000 (UTC)
X-FDA: 84304959270.19.F12FB08
Received: from sg-1-100.ptr.blmpb.com (sg-1-100.ptr.blmpb.com [118.26.132.100])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1FC6EC0003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:34:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=oCBbv+Ay;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767785653; a=rsa-sha256;
	cv=none;
	b=UQYrFqV9TWaXI/EhwK037sSCmmIh5x6vBD9IvJjiGlWhr7kBXqheZqsvepp5zTEVQBqng0
	hxj7QZbAb2KeZPlP35CyjqgqtphHhCL+hIqrrpGe2DD6wz8ywCtJmlpT2z7cb04GkXUifU
	sCJ9f+0TiGj5y5RJMtACDgbU1rmRO0o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=oCBbv+Ay;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767785653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEwE/5mv3+6N5jXpp615j2AhMiOJolhztasIKQwJLWI=;
	b=VK0A85pVC5UKT+qqgTb08+qIlbEilGBmQVM5vo48OPMY6LuV6mVa/N5/JYtiEqFO9nJZ4N
	NlMG81Iu4ITG0AtVtIA9m2dFrw/R/KyoNIbcLC4/+RVpNjm3+kKNhOEN+c3bw4GFYYhXrX
	2TFk6wt228BwKsmk22u25sz9IlpT9zg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1767785645; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=xEwE/5mv3+6N5jXpp615j2AhMiOJolhztasIKQwJLWI=;
 b=oCBbv+AyrRruOaEpQ2tgQ3K8UOLiFLP+n2T2M0rYpgczIr40X5rUEeRaXclcgbAhKoJe7f
 cn7Jz1/UEV8uajkxD3Nd3KfIsmfz1vepRiuphMi1H19H+Q2k+qRFNgOzB2j4pXJjtxVnHm
 PfsuY6p9QciFEjhAAV13HhisSbvxBexEC5zcAJ0oPkeOui0/o87XGFV5Nlf4N5vJN60e21
 tl8rAiyuURDwJHZHK3vHh50bqrV24ycornSyzrTK2mlRrBeKsYjVGiijwSy+oAw991pS8u
 9rpNaAwyGo+/YX4Fi6ty+26WgUx3m71/eHT3WhVOK0R23j93Ht+a6Fh3e3Hy4A==
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed,  7 Jan 2026 19:31:29 +0800
References: <20260107113130.37231-1-lizhe.67@bytedance.com>
In-Reply-To: <20260107113130.37231-1-lizhe.67@bytedance.com>
Subject: [PATCH v2 7/8] mm/hugetlb: add epoll support for interface "zeroable_hugepages"
X-Lms-Return-Path: <lba+2695e44ab+5d679d+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <20260107113130.37231-8-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1FC6EC0003
X-Stat-Signature: w3d3hrnwwy5wgukhi714f877cjwkmmx3
X-Rspam-User: 
X-HE-Tag: 1767785652-63160
X-HE-Meta: U2FsdGVkX1/KUMCPkvTZnraqWMve1xVG31QIX2HS5+EsNKsPwjSTkDkLi3UZENb6zTb3a+zRfyFmWOX1mrcXnwlGJGuXkUCURcT2XDcTUou9gf9DjKj+NQycnF4PLLUkkF/mhSq2VJaIjp8GJfyI6m1dQ5EXI66E+J7ncWTtneXbJK90ws1iF/wrMPUKEvIOtOzDIcIzbyVXGF6aR8Mc/GkN2ux5Sg3QwnQhtAD2NLjcnkW9dcQorgBuyqovRZMcVh8552Nx+LI1KgSOPv8TgYbfcBWFEFimJxedY/usvhyC7qe7UI7M1FR52ugFaFdhFqUBYjWQamhbObOU+k7ik8x3T3FsHFjR+zBX3Epd3K+dUHlD79ZY7OLTHnVhWDh0tlZ1dq7dMqDOjKhyXGaHFVhBrVaYMkYGjRWWCorjt8ypbJyj3vNi9sBZWsRNHklryOC+JmYBRpIXk4Q3tRm78eY6lOFY/NafsYYFUT9zl3syrADoXy2WfDnD5SPvw+NjOOWSWU0eu5RNbV62biMOglGZL2n+iGdY7mcfmybQ9PPkF9GBILnaMYJ1n22Oxb+M2U1LhZT1ePNMFtI6//PSMzqRp9LhpanRAyxm+hTlxJdlu8cIL/Uzpii+N59PiMiH865ws3AUX0sFT0YaVo6B93Qb1i4dHUZyaYkWdzTQa+n2kmZQtuhrNi7E0du4WRszfkgisbD9lzyYHz4GlbBXADfVLb1QA0bGtsEBV9PPDopI33MAnw+hKdfcY+cdWqR7MaEuQNurgigUTvFznuSEhU+fC2Cr/m47HK/lqqWavcWyw9IXvxucDe2r1w1eLrc4pERhkmzdcrcyzAuwqIFpDmPlg73Y9EmB2HNvI9xxerlPg3TJvl+lMUgSyM1DmD3FRc4dzvMHdEno+Y5uneY4vNqgjISlM8yHK2eZOYm1Vki757SFSF1aVOcgNWQRTT6cByZdmXyTcOZ3hP6OHvo
 SxScysyL
 +RVCMNAYHrh/0x2ocVHl3ce8Dtl9sWrE7xIzz9fL4QFwD6tOKWbCqrvJfMIlKGrCpirlT1xwCuGHXiGR516KVWoZ9PWV+Z03i+BxF9KuyJmN4nGQP9zlhLj5HYM0PIDObXMpzILbTn7BFe+e/xbr/w9iFU4EbqN4bK7Zg7MS0bBjcrP6gbvuqAE7P/mfFVPhKTuuySrorfGipUaqyi0mLPiwIHr5Jgn25u0Plm950TCN3Q9ma8BBgjIKXPSJmRwgCi70KkbQJbBAJwXE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add epoll support for interface "zeroable_hugepages". When no huge folios
are available for pre-zeroing, user space can block on the
zeroable_hugepages file with epoll, and it will be woken as soon as one
or more huge folios become eligible for pre-zeroing.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb.c          | 13 +++++++++++++
 mm/hugetlb_internal.h |  6 ++++++
 mm/hugetlb_sysfs.c    | 22 +++++++++++++++++++++-
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 42d327152da9..314734e434e2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1868,6 +1868,7 @@ void free_huge_folio(struct folio *folio)
 		arch_clear_hugetlb_flags(folio);
 		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
+		do_zero_free_notify(h, folio_nid(folio));
 	}
 }
 
@@ -1999,8 +2000,10 @@ static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
 void prep_and_add_allocated_folios(struct hstate *h,
 				   struct list_head *folio_list)
 {
+	nodemask_t allocated_mask = NODE_MASK_NONE;
 	unsigned long flags;
 	struct folio *folio, *tmp_f;
+	int nid;
 
 	/* Send list for bulk vmemmap optimization processing */
 	hugetlb_vmemmap_optimize_folios(h, folio_list);
@@ -2010,8 +2013,12 @@ void prep_and_add_allocated_folios(struct hstate *h,
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
 		prep_account_new_hugetlb_folio(h, folio);
 		enqueue_hugetlb_folio(h, folio);
+		node_set(folio_nid(folio), allocated_mask);
 	}
 	spin_unlock_irqrestore(&hugetlb_lock, flags);
+
+	for_each_node_mask(nid, allocated_mask)
+		do_zero_free_notify(h, nid);
 }
 
 /*
@@ -2383,6 +2390,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 	long needed, allocated;
 	bool alloc_ok = true;
 	nodemask_t *mbind_nodemask, alloc_nodemask;
+	nodemask_t allocated_mask = NODE_MASK_NONE;
+	int nid;
 
 	mbind_nodemask = policy_mbind_nodemask(htlb_alloc_mask(h));
 	if (mbind_nodemask)
@@ -2455,9 +2464,12 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 			break;
 		/* Add the page to the hugetlb allocator */
 		enqueue_hugetlb_folio(h, folio);
+		node_set(folio_nid(folio), allocated_mask);
 	}
 free:
 	spin_unlock_irq(&hugetlb_lock);
+	for_each_node_mask(nid, allocated_mask)
+		do_zero_free_notify(h, nid);
 
 	/*
 	 * Free unnecessary surplus pages to the buddy allocator.
@@ -2841,6 +2853,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 		 * Folio has been replaced, we can safely free the old one.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
+		do_zero_free_notify(h, folio_nid(new_folio));
 		update_and_free_hugetlb_folio(h, old_folio, false);
 	}
 
diff --git a/mm/hugetlb_internal.h b/mm/hugetlb_internal.h
index 1d2f870deccf..9c60661283c7 100644
--- a/mm/hugetlb_internal.h
+++ b/mm/hugetlb_internal.h
@@ -106,6 +106,12 @@ extern ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
 					   struct hstate *h, int nid,
 					   unsigned long count, size_t len);
 
+#ifdef CONFIG_NUMA
+extern void do_zero_free_notify(struct hstate *h, int nid);
+#else
+static inline void do_zero_free_notify(struct hstate *h, int nid) {}
+#endif
+
 extern void hugetlb_sysfs_init(void) __init;
 
 #ifdef CONFIG_SYSCTL
diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index 03b774b1191a..77e7214a380e 100644
--- a/mm/hugetlb_sysfs.c
+++ b/mm/hugetlb_sysfs.c
@@ -340,6 +340,7 @@ static bool hugetlb_sysfs_initialized __ro_after_init;
 
 struct node_hstate_item {
 	struct kobject *hstate_kobj;
+	struct work_struct notify_work;
 };
 
 /*
@@ -355,6 +356,21 @@ struct node_hstate {
 };
 static struct node_hstate node_hstates[MAX_NUMNODES];
 
+static void pre_zero_notify_fun(struct work_struct *work)
+{
+	struct node_hstate_item *item =
+		container_of(work, struct node_hstate_item, notify_work);
+
+	sysfs_notify(item->hstate_kobj, NULL, "zeroable_hugepages");
+}
+
+void do_zero_free_notify(struct hstate *h, int nid)
+{
+	struct node_hstate *nhs = &node_hstates[nid];
+
+	schedule_work(&nhs->items[hstate_index(h)].notify_work);
+}
+
 static ssize_t zeroable_hugepages_show(struct kobject *kobj,
 					struct kobj_attribute *attr, char *buf)
 {
@@ -568,8 +584,11 @@ void hugetlb_register_node(struct node *node)
 		return;
 
 	for_each_hstate(h) {
+		int index = hstate_index(h);
+		struct node_hstate_item *item = &nhs->items[index];
+
 		err = hugetlb_sysfs_add_hstate(h, nhs->hugepages_kobj,
-				&nhs->items[hstate_index(h)].hstate_kobj,
+				&item->hstate_kobj,
 				&per_node_hstate_attr_group);
 		if (err) {
 			pr_err("HugeTLB: Unable to add hstate %s for node %d\n",
@@ -577,6 +596,7 @@ void hugetlb_register_node(struct node *node)
 			hugetlb_unregister_node(node);
 			break;
 		}
+		INIT_WORK(&item->notify_work, pre_zero_notify_fun);
 	}
 }
 
-- 
2.20.1

