Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACE3BE7C6E8
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 20:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E098C6B0005; Sat, 31 Jan 2026 15:27:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEBD26B0088; Sat, 31 Jan 2026 15:27:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEA576B008A; Sat, 31 Jan 2026 15:27:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C02CF6B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 15:27:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 699D0C20A5
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 20:27:28 +0000 (UTC)
X-FDA: 84393394176.20.8BE2C16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9F067C0004
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 20:27:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=thPxqumx;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769891246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAZgUZJC5dBZWARwWSwGqH2Q5dNDy7sXCMqkQdWQtww=;
	b=u+LAhBWQeKwXCd3BCQ2SERqZ5D8Lv7Q+rrMQFTdRg8x4m7TDI6/WlOhTvH4YL4m4BqE/Uj
	txcOa2yBdjI7IYh5Z54XTZRoHaL511jlnwQUU7ssDtIo8Wp8w8v0YwLuAUXHYobTha6T1a
	Ys8xXA6AB/05/l8fFqGbilE7F3SRb0I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=thPxqumx;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769891246; a=rsa-sha256;
	cv=none;
	b=xaFj5GkuRXvoUdiA3VkhqTWskTcwfV7ijeit6qq0oA87JExr07Vs3VaIcve68Pp7ftarDN
	XpbyTFx5l66orLR38tFjT1nXIdSvmUxNJodgI+mDdBS49502L81D0IioHi/G0mPZa2cd1g
	LfXfsnwYHO8VuPpb5LJsdxFx3FxP1pA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B4E2D60210;
	Sat, 31 Jan 2026 20:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86A1C4CEF1;
	Sat, 31 Jan 2026 20:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769891245;
	bh=PaCl4GIrSU0JjpBXBBJkrJqycZOwvOM8tmeEFkIuJ2c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=thPxqumxEs56rq52rMb7rh9fwr/gkMsr7IKeGfOrjB4y87ft364alBne/1ngTfMtB
	 DRLqZLM3t87q92lEVv54feI2yYRITgavsH6p9okf7E01fYrFlpoAG8nmNJBZplXgek
	 faBrg73p0DBllufWZGqI5YWY7hm9vqy8zo0d3mOY=
Date: Sat, 31 Jan 2026 12:27:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 Matthew Wilcox <willy@infradead.org>, Sidhartha Kumar
 <sidhartha.kumar@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl
 <aliceryhl@google.com>, Kuninori Morimoto
 <kuninori.morimoto.gx@renesas.com>, Geert Uytterhoeven
 <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>, Christian Kujau
 <lists@nerdbynature.de>, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v3 00/30] maple_tree: Replace big node with maple copy
Message-Id: <20260131122724.ce19aa2f8260530bd3dee102@linux-foundation.org>
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pn7hc6ux8x54xd9y81hyk1c4qe9gfabn
X-Rspamd-Queue-Id: 9F067C0004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769891246-36385
X-HE-Meta: U2FsdGVkX1+JJnJdranKqRZPqxLlGVL5Om+cIIUB7uY4xMeyhJgnC4vANn6rfQdF1/Zaozpr4Lu5kgejepDOjnvRmtEo/0xa0qEy3Oym5XlGvMcAjvA8BIwh318Y6sQSXdoWlLMMMlgTcGJCbIXDC0OzaYIEyrbBPdnF/kFLASEiwa/6tf/QlJCmjvpU4UsTbqv5oGAcs8yEGepQFQsSY6r9zJVP/xuesC+hdar+EtmtMPx0EyumHGba2oCXitTwIR97AFOIYGFzXCyRbM53gCL6c6NOu02wkUsUOZRbunFNuInMpt2gLF1zhneQaDDlQOzjJEpNnRj6ShIQHDI9aAGi50NPcYx0Q0wL1Kpp+gYcYejowijq9IjvtX4edGiwbqqxZHw7yBVAhsC/DqJUkv++n32hyuxA9lWlTnt2MIRa48s9m36fDNzGB6O7qLWRUppaKN7JK4k/ZX5sIQ7F5rYhQFN/5FO2Y3TlE0WazlIwjkivTMhZ2qp97Ta21UC0IGhu5VgXJH7C2iy4h9hzpnD1Hrv08uV2hjg739oGhjKw1Jv1ZGIPIiDa7J/Oe4PxFlaV6GZyLD+xFkpg+zHRFgU2iNOzg8YQBegSr7811xodvR/lsfeZebTMa9OP1FPlSZmZ3rFDRUlXznUoICCpARPUNck+S/7WO7dk68/vV9nwEFRbTDMFpfZn0g4EZQcG8MSvFZ4984jcPpyVGq5fHVdezUBxIUzgju1ZDTp12zWOfM1r1HssRXKhZnLROvGRL/ikuvcUY35FlVSiaF08d4YwHBFz+F7t0UpU96PDvpMhMDuzJvnSMm/ZoLIbco28MAFHeEa0myLPwPZnUktJv53ozpgKrYWvWmB5y4X9pGlitYftlgULw3kiR8gCWEM8uevjW5nsBRBUid4G9BNLm7BkEoZslgzDGYtKl9D0OJOvW5YLfaHmIkDFAGxlOOZvpHZBIJ6XOjjuJsDHWJe
 hWMZH3TN
 53VE3GhhQ/pYKFsIsPOuIpA428h0ajwZzzLHl6UVI158HVlcojPrpyant9kKYBglVPakgVNFggvk9VvR/yNv3+StsdE9AvXQrCzx3+LtURDhFx83bim7vkG6u0S8ezuVFtbhkt7WWEtOY++PUowOZiF6SOdfI63IOdPePN8YuWxKysTZg3NYJ6ZgfkyD6R5rjou+9Hz01AZiNflz3JCyI9NUBmpuuKlTYeMy8Nm05onioX748AK35VI3vnChnhf4H69Xz3reofOby3L/EQBePoYUywpNOPpONftvMIAboZ5OoOZERhSTAr6pfO8KemozJITAd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 30 Jan 2026 15:59:05 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> The big node struct was created for simplicity of splitting,
> rebalancing, and spanning store operations by using a copy buffer to
> create the data necessary prior to breaking it up into 256B nodes.
> Certain operations were rather tricky due to the restriction of keeping
> NULL entries together and never at the end of a node (except the
> right-most node).
> 

Updated, thanks.

What are your thoughts on adding this to 6.19?  I'd expect to move it
into mm-stable Feb 17ish.

> Changes since v2:
>  - Whitespace fix in rebalance_data()
>  - Added ma_init_slot() for cleaner casting during RCU_INIT_POINTER().
>    Thanks test robot & SK [1]
>  - Fixed off-by-one in rebalance_data() which caused node overuse,
>    reported by linux-next. Thanks Mark [2]
>  - Added new patch to reproducer to test cases in userspace testing for
>    the rebalance_data() off-by-one

Below is how v3 altered mm.git:

--- a/lib/maple_tree.c~b
+++ a/lib/maple_tree.c
@@ -314,6 +314,13 @@ static inline struct maple_enode *mt_mk_
 			(type << MAPLE_ENODE_TYPE_SHIFT) | MAPLE_ENODE_NULL);
 }
 
+static inline void ma_init_slot(void __rcu **slot, const struct maple_node *mn,
+				const enum maple_type mt)
+{
+	/* WARNING: this is unsafe if the slot is exposed to readers. */
+	RCU_INIT_POINTER(*slot, (void *)mt_mk_node(mn, mt));
+}
+
 static inline void *mte_mk_root(const struct maple_enode *node)
 {
 	return (void *)((unsigned long)node | MAPLE_ROOT_NODE);
@@ -2231,7 +2238,7 @@ static inline void rebalance_data(struct
 {
 	cp_data_calc(cp, wr_mas, wr_mas);
 	sib->end = 0;
-	if (cp->data >= mt_slots[wr_mas->type]) {
+	if (cp->data > mt_slots[wr_mas->type]) {
 		push_data_sib(cp, wr_mas->mas, sib, parent);
 		if (sib->end)
 			goto use_sib;
@@ -2246,7 +2253,8 @@ static inline void rebalance_data(struct
 	return;
 
 use_sib:
-		cp->data += sib->end + 1;
+
+	cp->data += sib->end + 1;
 }
 
 /*
@@ -2553,7 +2561,7 @@ static inline void cp_dst_to_slots(struc
 		 * read-side operations that can view them until they are
 		 * inserted into the tree after an rcu_assign_pointer() call.
 		 */
-		RCU_INIT_POINTER(cp->slot[d], (void *)mt_mk_node(mn, mt));
+		ma_init_slot(&cp->slot[d], mn, mt);
 		cp->pivot[d] = slot_max;
 		if (mt_is_alloc(mas->tree)) {
 			if (ma_is_leaf(mt)) {
@@ -2603,8 +2611,7 @@ static inline bool cp_is_new_root(struct
 		 * read-side operations that can view it until it is insert into
 		 * the tree after an rcu_assign_pointer() call.
 		 */
-		RCU_INIT_POINTER(cp->slot[0],
-				 (void *)mt_mk_node(cp->dst[0].node, mt));
+		RCU_INIT_POINTER(cp->slot[0], mt_mk_node(cp->dst[0].node, mt));
 		cp->height++;
 	}
 	WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
--- a/tools/testing/radix-tree/maple.c~b
+++ a/tools/testing/radix-tree/maple.c
@@ -35899,6 +35899,127 @@ unlock:
 	return ret;
 }
 
+static noinline void __init check_erase_rebalance(struct maple_tree *mt)
+{
+	unsigned long val;
+	void *enode;
+	int ret;
+
+	MA_STATE(mas, mt, 0, 0);
+
+	/*
+	 * During removal of big node, the rebalance started going too high,
+	 * which resulted in too many nodes trying to be used.
+	 *
+	 * Create a rebalance which results in an exactly full parent (0-9) that
+	 * does not need to be rebalanced.  This required two full levels,
+	 * followed by an insufficient level which will be rebalanced into two
+	 * nodes, finally leaves that need to be rebalanced into one node.
+	 *
+	 * The bugs tree:
+	 * root    4      Label     R
+	 *        /\               /\
+	 *       9   X            F
+	 *      /\   /\          /
+	 *     9   X            E
+	 *    /\   /\          /\
+	 *   4  8             C  D
+	 *  /\               /\
+	 * 6  9             A  B
+	 * ^ becomes 5 with the write.
+	 *
+	 * Below, the reconstruction leaves the root with 2 entries, the setup
+	 * uses the letter labels above.
+	 */
+
+	ret = build_full_tree(mt, MT_FLAGS_ALLOC_RANGE, 4);
+	MT_BUG_ON(mt, ret);
+
+	/* Cheap expansion to 5 levels */
+	mtree_store(mt, ULONG_MAX, xa_mk_value(0), GFP_KERNEL);
+	/* rcu is used to ensure node use */
+	mt_set_in_rcu(mt);
+	mas_lock(&mas);
+
+	/* Node A had 6 entries */
+	mas_walk(&mas);
+	MAS_BUG_ON(&mas, mas_data_end(&mas) < 6);
+	while (mas_data_end(&mas) > 6) {
+		mas_erase(&mas);
+		mas_next(&mas, ULONG_MAX);
+	}
+
+	/* Move to Node B */
+	enode = (void*) mas.node;
+	while (mas.node == enode)
+		mas_next(&mas, ULONG_MAX);
+
+	/* Node B had 9 entries */
+	MAS_BUG_ON(&mas, mas_data_end(&mas) < 9);
+	while (mas_data_end(&mas) > 9) {
+		mas_erase(&mas);
+		mas_next(&mas, ULONG_MAX);
+	}
+
+	/* Move to Node C */
+	mas_ascend(&mas);
+	val = mas.max;
+	/* Adjust entries to be 4 */
+	while (mas_data_end(&mas) > 4) {
+		mas_set(&mas, val);
+		mas_erase(&mas);
+		mas_prev(&mas, 0);
+		val = mas.index;
+		mas_ascend(&mas);
+	}
+
+	/* Move to Node D */
+	mas_ascend(&mas);
+	mas.offset = 1;
+	mas_descend(&mas);
+	val = mas.max;
+	/* Adjust entries to be 8 */
+	while (mas_data_end(&mas) < 8) {
+		mas_set(&mas, val--);
+		mas_store_gfp(&mas, &mas, GFP_KERNEL);
+		mas_ascend(&mas);
+	}
+
+	/* Move to Node E */
+	mas_ascend(&mas);
+	val = mas.max;
+	MAS_BUG_ON(&mas, mas_data_end(&mas) > 9);
+	/* Adjust Node E to 9 entries */
+	while (mas_data_end(&mas) < 9) {
+		mas_set(&mas, val--);
+		mas_store_gfp(&mas, &mas, GFP_KERNEL);
+		mas_ascend(&mas);
+		mas_ascend(&mas);
+	}
+
+	/* Move to Node F */
+	mas_ascend(&mas);
+	val = mas.max;
+	MAS_BUG_ON(&mas, mas_data_end(&mas) > 9);
+	/* Adjust Node F to 9 entries */
+	while (mas_data_end(&mas) < 9) {
+		mas_set(&mas, val--);
+		mas_store_gfp(&mas, &mas, GFP_KERNEL);
+		mas_ascend(&mas);
+		mas_ascend(&mas);
+		mas_ascend(&mas);
+	}
+
+	/* Test is set up, walk to first entry */
+	mas_set(&mas, 0);
+	mas_next(&mas, ULONG_MAX);
+	/* overwrite the entry to cause a rebalance, which was 1 too few */
+	mas_set_range(&mas, 0, mas.last);
+	mas_preallocate(&mas, NULL, GFP_KERNEL);
+	mas_store_prealloc(&mas, NULL);
+	mas_unlock(&mas);
+}
+
 static noinline void __init check_mtree_dup(struct maple_tree *mt)
 {
 	DEFINE_MTREE(new);
@@ -36260,6 +36381,10 @@ void farmer_tests(void)
 	check_mtree_dup(&tree);
 	mtree_destroy(&tree);
 
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_erase_rebalance(&tree);
+	mtree_destroy(&tree);
+
 	/* RCU testing */
 	mt_init_flags(&tree, 0);
 	check_erase_testset(&tree);
_


