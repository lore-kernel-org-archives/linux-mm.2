Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1BA6606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=tqkDepCl
Received: by kanga.kvack.org (Postfix)
	id 6261D6B05B2; Mon,  2 Nov 2026 21:07:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF7C6B05B3; Mon,  2 Nov 2026 21:07:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452556B05B4; Mon,  2 Nov 2026 21:07:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0E86B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:07:46 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90A27A7A2C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:07:46 +0000 (UTC)
X-FDA: 85392171732.13.32CD244
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id E41448000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:07:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=tqkDepCl;
	spf=pass (imf30.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793671665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUK6dMZMlyfLspx+cnvTRerB/rIYpcvguJ7fRvjfqkk=;
	b=D+beFsG+RJEuH5Gz7hpzjj4cz0HqQMRNzizu2hypFgILTyJ1d8hLFxDn5KFzdfC0qfJGV6
	rztBmhERHQBWh/1IkRb/YMfGf4WA8Y+uDQks96beYS/iMDAzKfTp2gxG61q50H3zHLgVKY
	SVeQgQsFNrUEvnDq03Ru5aYnyrP7kO8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=tqkDepCl;
	spf=pass (imf30.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793671665;
	b=zk0ggDDKCIjEhHvWxXX0nL7pPteMT8btHY/oyI8+VHrKxRj+/E2x53gUEypTbYpgX8AJAp
	ZcFn+JcD0uqHU2E4cgl0JiKTVKjv08j49FZTyOSzmgmJjrfCkQ1dpQqB2VT9JgSh3L0r4V
	YehEoo8u5aNbaNpizU/5LUrKvgA+phg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UUK6dMZMlyfLspx+cnvTRerB/rIYpcvguJ7fRvjfqkk=; b=tqkDepClH/XB2WsLDTpGgw58pb
	3eeCyZOft5L4ztsDzTWG20/8awVk6wfT6aRg17rcDsHisNbbn+7PC8/kEpm4aabx63xYTYcfw+FeF
	CQ2vfIJSZRqwZaccLpenTU+0PR2sHFgImLl96QZpKeuTGLKMYtMO7l7TjEs2MhWwcT1I4J0H7HAkd
	AYxy6Zed5EHvBTdJVphaqv5Ca6cpP5vtfFqh0sWl6GuPIeW3caY2FB98S5iT48cI4q91eP+6lM9J0
	Ailm/TN3//XPMlEws2nIiW+Y0UMgqdsOufUQZTOcyvHWOcQeQuKx0vilvA70tVWMdiFAQPhCoxJ5a
	vUO45uqw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xO3w7-00000000qv2-0F0s;
	Tue, 03 Nov 2026 02:07:43 +0000
From: "Liam R. Howlett (Google)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	"Liam R. Howlett (Google)" <liam@infradead.org>
Subject: [PATCH v2 2/3] maple_tree: Test emptying tree while RCU reading
Date: Mon,  2 Nov 2026 21:07:23 -0500
Message-ID: <20261103020724.2614498-3-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103020724.2614498-1-liam@infradead.org>
References: <20261103020724.2614498-1-liam@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dqbwbhctxt8zzzk5sf3nf37dgpun4dde
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E41448000A
X-HE-Tag: 1793671664-794776
X-HE-Meta: U2FsdGVkX1/feGssTrb3qlQajmZxx1SYgwyMV/3fIPdK9KSaUFMAfw32xG422wLEvQEIx7vE+pITVlVIduJv9oEpGtZMLSGR4fHNpu2RqKSu4kQcsQgtAY2knKCFVu7De4Y2VcdVr7/9R+zkle2AZIA5pKLDfuFsFRtPB9zYEO1xhtyCREOyw3n0rob5foN/4/PWlwrqcbX6FWXeb6W37DadXgVEIQlLvEtnxmaP1AYbnJc5zOtFwr7GhEbB5MQj4iIP/ka+K+CqXhQqIgn0+doidQqzdAVa+4IC9uBk2f8u/3yrnGK/w5Us+4zIkV5GAbFhhJmWuxa+PHHDvEcLaljRKUqig27KrrfDDYpAj1z8GOV17kQ70NFikoQkdOUL/MnoYnQeUMQqXIEE7r1eUt2b0S1IOeM6tPjc3UMaDp2pHXUkJCvOXNYRhs7CqCLpPtVakWwHlQDbqsaNLwjQmYEkrCeG6KS3/YMGjFGQaQZXaSGHXoobAeY1eMxShnXriJgmTltHpJQHcZXz49MM+uDWOCAyCc7jrVnon5VTP71x6yvxDxlLVD0IAxSjkqOJM+E96HK46CDrXH8g97M49YGk5gSW2TU+7EA5e4tkccZMm96WIhefcFkQGy5O0Pt+694hy5VyjzEbiR4Y9QBrnpFCCChGdvk8ZYW1MbWYQ4cqc6TUH0BlIOKXyuZ+Rbzk6kHfOKRxcptTZl5nNPuBYeOOxI/mTG0O2Tv9J5hn7bbo/skO+OQ0S9AKVs15266Zl+WvICzaD6seXo68Ckw9w+baYlMWoEAvAMBsZMd+hTqMxHKJIGL90zHUu96g+9k+J3MlPzQVmW5JjAWPhfpk9HHgDUAlkvNr+UjTscfHAHhCX7xwVvg+oJQJFUwyS0VDT6QLeFbVoaSaHOwJun9kUaSQfqPrG9OG5Yspm56ss0Z68uJ30e0ypLPrFyqlYaT7T/hZyGSQJXVXWd5vjl2
 54KL0NhO
 Sy3Ek+XrX5lqZvOfE4MT9eL1eeLhn7daNnb7QwQkm+VBFJ/LHiUhQKGmDE9hIxcQZ+NsamEcGx6aHet/UdDiuRUa/DGQa0R8SCDZAALynVB2NVLFCoBEyd5i7OQrOTIw4qYl7SX23LYJfsXrqV/QO3qlKhNnKUmyhmdW2GM2TFSxxtb133S7afKLYcmbUpbuccAekB5BqmvBhs8fj/7ybL+yqv/9NntCnW90HPx+2nOmJXu6i3Gv/GO/waZ4zBgZQ/HAc/po7xy180P0rsMfTouHCwSZwMwSi+AnAtNrvkEKjCMOWX71c1gmYzocaIf9I6TCXvIeMxvO/YzRb+OmT5b04hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a test case for the rcu reader being restarted by emptying the tree.
A reverse walk from index 0 must not return the new root entry.

Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>
---
 lib/test_maple_tree.c | 165 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 165 insertions(+)

diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index fb40e193a3cb7..10e5577ea0f19 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -3740,6 +3740,170 @@ static noinline void __init check_range64_in_rcu(struct maple_tree *mt)
 	rcu_barrier();
 }
 
+/*
+ * A reader that restarts after its leaf died may find a tree without nodes:
+ * emptied, or emptied and then given a single entry at 0.  Each case starts
+ * from a tree with nodes, built by check_seq().  The stores run while the
+ * reader holds rcu_read_lock, so they use GFP_ATOMIC.
+ */
+static noinline void __init check_restart_no_node(struct maple_tree *mt)
+{
+	void *ptr = xa_mk_value(1234);
+	void *entry;
+	MA_STATE(mas, mt, 0, 0);
+
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mt_set_non_kernel(99999);
+
+	/* find: the tree is emptied */
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+	check_seq(mt, 100, false);
+	rcu_read_lock();
+	mas_set(&mas, 0);
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != xa_mk_value(0));
+	MT_BUG_ON(mt, mtree_store_range(mt, 0, ULONG_MAX, NULL, GFP_ATOMIC));
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_none);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_none);
+	rcu_read_unlock();
+	mtree_destroy(mt);
+	rcu_barrier();
+
+	/* next: the tree is emptied */
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+	check_seq(mt, 100, false);
+	rcu_read_lock();
+	mas_set(&mas, 0);
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != xa_mk_value(0));
+	MT_BUG_ON(mt, mtree_store_range(mt, 0, ULONG_MAX, NULL, GFP_ATOMIC));
+	entry = mas_next(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_none);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	rcu_read_unlock();
+	mtree_destroy(mt);
+	rcu_barrier();
+
+	/* find: the tree is emptied, then holds one entry at 0 */
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+	check_seq(mt, 100, false);
+	rcu_read_lock();
+	mas_set(&mas, 0);
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != xa_mk_value(0));
+	MT_BUG_ON(mt, mtree_store_range(mt, 0, ULONG_MAX, NULL, GFP_ATOMIC));
+	MT_BUG_ON(mt, mtree_store(mt, 0, ptr, GFP_ATOMIC));
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_none);
+	MT_BUG_ON(mt, mas.index != 1);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	rcu_read_unlock();
+	mtree_destroy(mt);
+	rcu_barrier();
+
+	/* find_rev: the tree is emptied */
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+	check_seq(mt, 100, false);
+	rcu_read_lock();
+	mas_set(&mas, ULONG_MAX);
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != xa_mk_value(100));
+	MT_BUG_ON(mt, mtree_store_range(mt, 0, ULONG_MAX, NULL, GFP_ATOMIC));
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_none);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_none);
+	rcu_read_unlock();
+	mtree_destroy(mt);
+	rcu_barrier();
+
+	/* prev: the tree is emptied, then holds one entry at 0 */
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+	check_seq(mt, 100, false);
+	rcu_read_lock();
+	mas_set(&mas, ULONG_MAX);
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != xa_mk_value(100));
+	MT_BUG_ON(mt, mtree_store_range(mt, 0, ULONG_MAX, NULL, GFP_ATOMIC));
+	MT_BUG_ON(mt, mtree_store(mt, 0, ptr, GFP_ATOMIC));
+	entry = mas_prev(&mas, 0);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.status != ma_root);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	rcu_read_unlock();
+	mtree_destroy(mt);
+	rcu_barrier();
+
+	/* find_rev: the entry at 0 is below the minimum */
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+	check_seq(mt, 100, false);
+	rcu_read_lock();
+	mas_set(&mas, ULONG_MAX);
+	entry = mas_find_rev(&mas, 1);
+	MT_BUG_ON(mt, entry != xa_mk_value(100));
+	MT_BUG_ON(mt, mtree_store_range(mt, 0, ULONG_MAX, NULL, GFP_ATOMIC));
+	MT_BUG_ON(mt, mtree_store(mt, 0, ptr, GFP_ATOMIC));
+	entry = mas_find_rev(&mas, 1);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_root);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	rcu_read_unlock();
+	mtree_destroy(mt);
+	rcu_barrier();
+
+	/* find_rev: the reader is at 0 when the tree gets one entry at 0 */
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+	check_seq(mt, 100, false);
+	rcu_read_lock();
+	mas_set(&mas, 0);
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != xa_mk_value(0));
+	MT_BUG_ON(mt, mtree_store_range(mt, 0, ULONG_MAX, NULL, GFP_ATOMIC));
+	MT_BUG_ON(mt, mtree_store(mt, 0, ptr, GFP_ATOMIC));
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_root);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	rcu_read_unlock();
+	mtree_destroy(mt);
+	rcu_barrier();
+
+	/* find_range_rev: the reader is at 0 when the tree gets one entry at 0 */
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+	check_seq(mt, 100, false);
+	rcu_read_lock();
+	mas_set(&mas, 0);
+	entry = mas_find_range_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != xa_mk_value(0));
+	MT_BUG_ON(mt, mtree_store_range(mt, 0, ULONG_MAX, NULL, GFP_ATOMIC));
+	MT_BUG_ON(mt, mtree_store(mt, 0, ptr, GFP_ATOMIC));
+	entry = mas_find_range_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_root);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	rcu_read_unlock();
+	mtree_destroy(mt);
+	rcu_barrier();
+	mt_set_non_kernel(0);
+}
+
 static DEFINE_MTREE(tree);
 static int __init maple_tree_seed(void)
 {
@@ -4031,6 +4195,7 @@ static int __init maple_tree_seed(void)
 
 	check_range64_in_rcu(&tree);
 
+	check_restart_no_node(&tree);
 
 #if defined(BENCH)
 skip:
-- 
2.47.3


