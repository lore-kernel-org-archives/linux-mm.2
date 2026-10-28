Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D713E606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=lPiAT+ME
Received: by kanga.kvack.org (Postfix)
	id 30ADB6B05BB; Wed, 28 Oct 2026 11:42:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BBAB6B05BC; Wed, 28 Oct 2026 11:42:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D20A6B05BD; Wed, 28 Oct 2026 11:42:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE6B36B05BB
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:42:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60DAEC0149
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:42:47 +0000 (UTC)
X-FDA: 85372452774.05.DA8001D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id A718140007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:42:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=lPiAT+ME;
	spf=pass (imf17.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793202165;
	b=em2dvRA3HBrsZVSG6XaMCH1jCZreMd0zE/pTN3gWlIV2cJ1bmnHDgv6D/cA0Q1nR43djgh
	5rrMb5FuGk0Wr70vs0XF6O7+TwDgD0jdRStvLVfC8Q/ZX4Zlnq8OpVoXBDKAUjzsGi++Qj
	2BdNQ1UNcbtmEuKoDm4kniLI7nYF5ag=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=lPiAT+ME;
	spf=pass (imf17.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+FxMyc8VBoBJuWtxhwMaxRzj9HBkqwJBoUXFm0B+Fg=;
	b=rwLKS1VuRtWiFmbmJ7vQ44cOw6M3zHzxJX38E1DW+jvwUqfXpuz7BYS7ktKnAjCaz4/P0y
	HoNg3Yln+pno61FCg1aAUMlI1Y8Jsy321AreyADbGU9Q3FT4p4hC3UlCiSHwzIaQtJhhPm
	HTShVCUYEQOxi8xidlR6b2LCP6cqrSw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=x+FxMyc8VBoBJuWtxhwMaxRzj9HBkqwJBoUXFm0B+Fg=; b=lPiAT+MERRmJ05OI4LtM24SW5H
	q6vq8GOmZSheoS0D7L+ZVVQ388CuaC4IF0zid0zVq9dejkrGnXkXVnZyx42Oynvo4RI2R6RaR6XXE
	oC+QZ+u8lDtuEHpLD540KGfgXT2G415p7z1I20po/MBk5xbNEKC+p1rJrbCURX13+k5SgjmLUZ+VX
	eZADsxJxTtS9wW2LgbvkYCumTlVj0UH55qhvWVWqjtylCODJokKwkG4iu3A0KJ7R6kfZbfR+vwhAq
	n28uQ2nZKG34/uNjd4iLhXdd34Nq1I2CF55FBLwqA4GVGcSMxiBjfVa4EWxqBG/55LqNL0tDWfnkA
	7zZv9kKA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5nY-00000007QoX-22zr;
	Wed, 28 Oct 2026 15:42:44 +0000
From: "Liam R. Howlett (Google)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	"Liam R. Howlett (Google)" <liam@infradead.org>
Subject: [PATCH 2/4] maple_tree: Test emptying tree while RCU reading
Date: Wed, 28 Oct 2026 11:42:16 -0400
Message-ID: <20261028154218.1668182-3-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028154218.1668182-1-liam@infradead.org>
References: <20261028154218.1668182-1-liam@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9joip8sy4mc58hfr1unoxp6sptcopiqw
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A718140007
X-Rspam-User: 
X-HE-Tag: 1793202165-671701
X-HE-Meta: U2FsdGVkX186YtSELwxelAdubtrlNPT+ebgXglDN875VNlBtdx5qyoWEnafeTddIKQd1TvoCssUyvSHDln/kVMJL8b/mmkhGDWVrtfXARFF5Jw6TMr7V9KnJ0byzwCJjemfxO+gw2Q16BhhOGWAEIDRHH5HcRQ1jsM9qGCzQeDImkg9iIni98a5ddeMaDpUjoJUlW5+WrWx0xgv7ouzgi7XR5Yb2GQt/qphx1UWGRzfXdo1eZiDWQ/OUmYJPnNv+zwdld3R4hHvPQ7foaFzfVa1XNZQTf8VtKUy4s6qKF0v5aHsv4nCFl5Uje26gyEKhHJy5rA9aum6iFv9Trx8wAEtewUHOrLxQ7KXedQ1fnK5ReWsGNdDLoke5+iVgSpwMgUQZQrOgUDKKDgol/p0DZels9SXYDq6EH7fnputWscNRu4hXG7dHB8eKpknuhBWtfp6ZC+4OOwCUkKNYGzTt+RJwHt7zYIooJQj8IW2kg7hP4gado2MW7mVxGigQi+w/lzBNtbX6E2qcy80yyYpowhBAUN5O12mwOkrIwxv4ugqQBTtBgU+m7EAOByaooN90BG6kL7abOj0x7XF4h8q/KnCzkrhca7IF6PebZa/OBmoRwD/PBRNqT6v0ZcNarGv8Qpsb8ErZvGI1Y6AKIp5H0QFHeEMxU9acV/3bpsrLBIK1AIiIq+T8CwIrQML1PAGzwMjBdvOcmLRsqOXCUgvC6zXv2O+EnMeb/k3u4/PLw57Z50dRZYBAAVqJ1Kzozl29Oc0B3kfG7bMMN29C87p4FFtoXatdkONK9gtm29GqmhJOCX3M9NwxkNAoOm8qMxvq2Xmq0r4s4YOEOtjWEXC83mnC7mxjzLhs8FecvDXpnmDeGz1I+lT6nPHKGutOhJSJNMwYQs8yJcIwy3DefXVUlBVlmMNJpbnU90q3kN+AAnyZYxrH99VHj/xQdqqtbo5Y+pOzKre4OmKbObeqfxB
 1qX9GoHt
 zGD87NkEuefMBgKVk/BBHcCS1/5FWGNMtUcKTEFu02TvGBJS3RX3aVRQe8xm31cs+Xj5k5H2a4kH7xxGqrhmHyKyZ5cHyOYOVRC9FR+b2MUJqrgLCrBEJrS9qKPV9rmTJL4Lj83ZstRc2gf9a4abKCTgjdu7394lKE+ECf0s4lqjEv3Lcx/3jEWNfZ1Fw5g0yWb1U2q6RpHYmiBu4WCd5lMJ5SnECMXmq4Ub/Xr3kd2YbnxJr9xqXNLYjz3R4Q8EascEn7ghYzPpdFqy/BGcxro9dg30iYkUzCAD3Ut4Z5VAhAtjUXTaEIGA6KfExBbGQvId9kmQFO9TYJ+PEvwox6vXh1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a test case for the rcu reader being restarted by emptying the tree.

Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>
---
 lib/test_maple_tree.c | 129 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 129 insertions(+)

diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index fb40e193a3cb7..894f5893e1be2 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -3740,6 +3740,134 @@ static noinline void __init check_range64_in_rcu(struct maple_tree *mt)
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
+	mt_set_non_kernel(0);
+}
+
 static DEFINE_MTREE(tree);
 static int __init maple_tree_seed(void)
 {
@@ -4031,6 +4159,7 @@ static int __init maple_tree_seed(void)
 
 	check_range64_in_rcu(&tree);
 
+	check_restart_no_node(&tree);
 
 #if defined(BENCH)
 skip:
-- 
2.47.3


