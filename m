Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6972ACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 16:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9040E6B00AB; Wed, 27 May 2026 12:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B52F6B00C0; Wed, 27 May 2026 12:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77C7C6B00C1; Wed, 27 May 2026 12:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 613216B00AB
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:31:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0320940683
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:31:49 +0000 (UTC)
X-FDA: 84813741180.04.64487CD
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 553FD14000C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:31:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=495d2NPw;
	spf=none (imf26.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779899508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dOGUXSAwLuzuMj+IPA83VAkWmjHs2kySdjAhLXS4foM=;
	b=i3GPjvUPFd6QLicUAFvFyAEHmjZ0giXJfKBx3TjQw/zyMm5D+dI3DG5VNAORIA1G/RswkG
	uncYxWr0D7DD4zG3NHHFXYnayKmPxvF6sFtDa48yFxMJK7toaGpwCSh7nWYWWZuc/MYk7E
	9YXgDdKVipRG10Pj978DTI1AMLDKv3I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779899508; a=rsa-sha256;
	cv=none;
	b=kIt4rypo5Bpd5gzJzUik0qCZLDNttE5GVu249nWy2pXD19+qgtacP3ZbChkABG1rSMmTqO
	mj0m/+/ty0l+DAXC9X3MAVEJ5LYuWdImguIILm28hPf2GvjA3CTdwsouJCafLJKKaxh953
	El96en/tQ/LnLYmv14oFIJf98GdphJo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=495d2NPw;
	spf=none (imf26.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dOGUXSAwLuzuMj+IPA83VAkWmjHs2kySdjAhLXS4foM=; b=495d2NPwcZ58y+DMXqQJYidKGc
	IQOwGs6ZhOhDGd7mltripiHveOc7BcU7Xk3XovtCXIuV2CQuageX0lQfPQkKcsMNRky7s1Sfzj2Jv
	E2+frzDc7T4hXkapNSHsW9A0ZGdankmFAWlSjHK82omo3TzKMR+u6hXlcUYjy/aPSn70TA8hp4+ck
	0zreigr9TN7L1m9AFzUb+++1bq9QQ7HWJrMwdjx49mxHTHIDDK3S9WhRWACvR/KBnSG4dGMw65Dps
	Rhc8F614MWvW98cQU8X5cgJVlf6Hz0/JXdyNz66YSDb60xKmFYFBct77i5RvC7ruwSZRQ9jpX1GZC
	8SWb9vXw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSHAQ-00000004Vmk-18xC;
	Wed, 27 May 2026 16:31:38 +0000
Date: Wed, 27 May 2026 12:31:35 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Oliver Sang <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Kujau <lists@nerdbynature.de>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Matthew Wilcox <willy@infradead.org>, 
	SeongJae Park <sj@kernel.org>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org
Subject: Re: [linus:master] [maple_tree]  280b792cac:
 will-it-scale.per_process_ops 6.0% regression
Message-ID: <fqfpxtjzisway7arouksnis7wfjvwe6h4ingrauuqzadz2n2zg@rnxxz5kh4bcx>
References: <202605131554.92e7df6b-lkp@intel.com>
 <22y6gvr7yzwdocwpd3wxrxfykmpvhbxytiiuht32db3dh7w522@pglkrpqognjk>
 <agV3Q2fBlQrB5v9w@xsang-OptiPlex-9020>
 <g7pvhqnuloifqhbvjgtgydbitcrvmxibferexj7cunsmagttps@oxjvs3aa3l3s>
 <ahFciGk6LfkOU2en@xsang-OptiPlex-9020>
 <wbgsjfbbiwmx2glp72ifomyb6fb7uc4lwffwg5z2inv4tzskbf@ufgets7hbskz>
 <ahP49NBb15KfCHhZ@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6odnmqt5iezagvak"
Content-Disposition: inline
In-Reply-To: <ahP49NBb15KfCHhZ@xsang-OptiPlex-9020>
X-Rspamd-Server: rspam11
X-Stat-Signature: yx1k3yeoyos45yxmosy1k6trxfrkcsk4
X-Rspamd-Queue-Id: 553FD14000C
X-Rspam-User: 
X-HE-Tag: 1779899507-327275
X-HE-Meta: U2FsdGVkX1+aC48RJpawuXrkEQD8wTd3dRNBrXoXPfSM+fAX8qrTR+0nWQZu8IYcBYU0Q9YjAWjyn5PRKTzk+Fdjv2uZ/PChtQf1gbjJp+UJySCEMz3TJulPmvIXKx0U2QS5FFdwlSq6uL1s801aUhKPFRytCqETKPc090GtxROpjX9tBo/h4FuIgVrD3PQ83m9iFB4TehtTLdoa+O1TbGY77a9c9wmSU7nw0H9LlHLhYkOzuzyXSYp0EjaPSILPP66yxVHLP1wmk9SW9Fc4Fz0kE6XssBA6+lW0uANTfhaFVLVdMQm1tZTl8G9oJsCi8WX7mxcfHa461DFhHGPAJIDnPC/p03pj/x2AbwSHQ+PN3vCn+H6GVRtbSDSO5SIgFvPCTf6ZzYgjVRxq2d6vxSmwMSBWhQ6Ms29Fw+rb6j2K2+RVji9el4mnimAu8WdvDTAJe837Zk021VUpCn9lCALLBu7HVJWrzccc51OShgsiMMu2SFrA6YyTqVlgSrbYLfKuIV9aGhJ0jJOssSmiSjEwxUUJ/a9D5a3v23NB53xjOhGDhDJlxhlhwRy9Q9DDEktoTTJC4pb/q6KA32bqGt1JPO7Nv/bQCAzRmezrhmFfRwmAQWB6LKwrvxfFPYhBT1exjhAP9+K5DEX2E9vMtvnRhxfUsD7bmO3oZ5Ih1jHxkGLFDcLTBvnbDCGi5aHgni7S2pkWnWRcUfNRZwLANn11gFFfLytUlZ7XJ6Vl2GP1lgKg/YoeuTqvvAj7hhZjMaKrtFomp24L2UTTFz/+pEuPYhJnQO8xT9QU/7SpAFnZXyWzneXgZ4oXvz9TIPg1l2MES22+J8qQKRZBR77/5n/v83OG5trMAZDkcOtPlZplvw4xdW2h/mWYHlb/ZkJHsROgAovLNi0RsFSelznYcV17kA6Au3GbTvLhzV2MXTdioD7026P6juX0O5os2ggYstsIB3agrIG4TqzkW9A
 krhiAwgf
 b1fktpVTO1Q+Jpw6egF1Ww+arxdjECkTMAqI3/CdrxImnLnXWHJ5z854Uofn7WRklF0Z5P9TB96eR5l/JDhxYOIixWodaVYsIMFJZHo6ARdhIIbMLYIEeKSlVLk1Lkk3rRndu2pOtGSSDf0fO9aSDZ37C3azMZGKY6NUWQd5qIXuShOAgSOtC7a7j4J+JjLFgSOrRxixU16gPgKNoEkTkA0MNYltFw4isbswYNsmiL1kq5Q5+exCsYmZ7WSy1RBbsLDLPx/EXS9eUq3V4W43JHHkE3NzRUZyeDlVShZpxpH6tCmN8f1NAHjBaG3WbEOroc/FLVFKAQ1lKtI2NzLGOX8PtkWK5EYLxNmNwYfnlEC34Wh1japj6Obw47fnSNrEtJOdclXVHQByJebL/InJVadluJ51jRAqJe7lqlSGkydYsvmP2rg9i/PM/k+u9ULgf5W13kGKdDaBMw38TiMvo2K6vca3wY0l+1jt2Dv8HHMWgUb+iyLkm5lnWmubdKfJLdHzO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--6odnmqt5iezagvak
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 26/05/25 03:23PM, Oliver Sang wrote:
> hi, Liam,
> 
> On Sat, May 23, 2026 at 11:12:24AM -0400, Liam R. Howlett wrote:
> 
> [...]
> 
> > > 
> > > I appled your patch upon below mainline tip commit when I checked.
> > > 6779b50faa562 ("Merge tag 'pci-v7.1-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci")
> > > 
> > > then build kernels with attached config.
> > > 
> > > but found a big regression introduced by your patch.
> > > 
> > > =========================================================================================
> > > compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
> > >   gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-ivb-2ep2/mmap2/will-it-scale
> > > 
> > > commit:
> > >   6779b50faa562 ("Merge tag 'pci-v7.1-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci")
> > >   942596e1c1037 ("maple_tree: Restore old tree layout using new scatter-gather node copy")
> > > 
> > > 6779b50faa562e6c 942596e1c1037f014638541bce4
> > > ---------------- ---------------------------
> > >          %stddev     %change         %stddev
> > >              \          |                \
> > >    7023559           -42.9%    4007886        will-it-scale.48.processes
> > >     146323           -42.9%      83497        will-it-scale.per_process_ops
> > >    7023559           -42.9%    4007886        will-it-scale.workload

...

> 
> > 
> > >       0.00           +14.8       14.81        perf-profile.calltrace.cycles-pp.mas_wr_split.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
> > >       8.17            -8.2        0.00        perf-profile.children.cycles-pp.mas_wr_node_store
> > 
> > It looks like the slow path is taken 100% of the time in your run, for
> > all processes, always.
> > 
> > I understand why that is happening and I can work to avoid it (nudging
> > the write deeper into a split node), but I'd like clarification of my
> > questions above before I keep going here.
> 
> sorry that we cannot supply deep enough technical analysis such like why
> mainline tip (at least 6779b50faa562) has no regression already.
> 
> but in case you want to dig this deep, you could request us to test any
> fix/debug patch, whatever upon your last patch, current mainline tip, or
> 280b792cac. we just want to be able to supply any assistant to improve
> linux kernel code quality. thanks

Thanks!

Are you able to test this patch instead of the previous please?  I had
already started this when you responded so I'd like to see if I'm
correct in what is going on, at least.

Regards,
Liam

--6odnmqt5iezagvak
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-maple_tree-Restore-old-tree-layout-using-new-scatter.patch"

From 0e7cf76a2d3fb864b06336fa854b088b6e0bc39f Mon Sep 17 00:00:00 2001
From: "Liam R. Howlett" <liam@infradead.org>
Date: Fri, 15 May 2026 17:37:06 -0400
Subject: [PATCH] maple_tree: Restore old tree layout using new scatter-gather
 node copy

The prior bignode rebalance and split operations were greedy in getting
data to the lower range nodes (often referred to as the left side of the
tree).  The new scatter-gather node copy was more fair on splitting
data, but this lead to a regression with mmap2_processes.

Restoring the greedy nature of getting data further left in the tree,
when possible, turns out to perform better.  Note that it's not entirely
greedy and tries to leave some room for modifications to both nodes
later, if possible.

The decision of where to push the majority of the data is relayed as a
'hint' on which side to favour.  Passing around a hint turns out to
simplify a lot of logic that was otherwise derived from the siblings max
or size.

When writes cause a node split or rebalance, try to place the writes further into
a node.  This is useful to avoid worst-case scenarios caused by writes happening
around or at the same range in a repetitive area.  This can be seen happening
by mmaping libraries and creating protected areas within the new mapping.

Signed-off-by: Liam R. Howlett <liam@infradead.org>
---
 include/linux/maple_tree.h       |   1 +
 lib/maple_tree.c                 | 458 ++++++++++++++++++++++---------
 lib/test_maple_tree.c            |   5 +-
 tools/testing/radix-tree/maple.c | 111 ++++++++
 4 files changed, 447 insertions(+), 128 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 4a5631906aff..c4c3b31614b0 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -192,6 +192,7 @@ struct maple_copy {
 	unsigned char d_count;
 	unsigned char split;
 	unsigned char data;
+	unsigned char write_start;
 	unsigned char height;
 };
 
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 60ae5e6fc1ee..09c3dbeed10c 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -89,6 +89,10 @@
  */
 #define MA_STATE_PREALLOC	1
 
+#define MAPLE_DST_NEUTRAL	0
+#define MAPLE_DST_FAVOUR_LEFT	1
+#define MAPLE_DST_FAVOUR_RIGHT	2
+
 #define ma_parent_ptr(x) ((struct maple_pnode *)(x))
 #define mas_tree_parent(x) ((unsigned long)(x->tree) | MA_ROOT_PARENT)
 #define ma_mnode_ptr(x) ((struct maple_node *)(x))
@@ -1720,21 +1724,26 @@ static inline void mas_wr_node_walk(struct ma_wr_state *wr_mas)
 	wr_mas->offset_end = mas->offset = offset;
 }
 
-static inline void rebalance_sib(struct ma_state *parent, struct ma_state *sib)
+static inline unsigned char rebalance_sib(struct ma_state *parent,
+		struct ma_state *sib)
 {
 	*sib = *parent;
 	/* Prioritize move right to pull data left */
-	if (sib->offset < sib->end)
+	if (sib->offset < sib->end) {
 		sib->offset++;
-	else
-		sib->offset--;
+		mas_descend(sib);
+		sib->end = mas_data_end(sib);
+		return MAPLE_DST_FAVOUR_RIGHT;
+	}
 
+	sib->offset--;
 	mas_descend(sib);
 	sib->end = mas_data_end(sib);
+	return MAPLE_DST_FAVOUR_LEFT;
 }
 
 static inline
-void spanning_sib(struct ma_wr_state *l_wr_mas,
+unsigned char spanning_sib(struct ma_wr_state *l_wr_mas,
 		struct ma_wr_state *r_wr_mas, struct ma_state *nneighbour)
 {
 	struct ma_state l_tmp = *l_wr_mas->mas;
@@ -1754,7 +1763,7 @@ void spanning_sib(struct ma_wr_state *l_wr_mas,
 
 			r_tmp.end = mas_data_end(&r_tmp);
 			*nneighbour = r_tmp;
-			return;
+			return MAPLE_DST_FAVOUR_RIGHT;
 		} else if (l_tmp.offset) {
 			l_tmp.offset--;
 			do {
@@ -1764,11 +1773,13 @@ void spanning_sib(struct ma_wr_state *l_wr_mas,
 
 			l_tmp.end = l_tmp.offset;
 			*nneighbour = l_tmp;
-			return;
+			return MAPLE_DST_FAVOUR_LEFT;
 		}
 	} while (!mte_is_root(r_tmp.node));
 
 	WARN_ON_ONCE(1);
+	nneighbour->end = 0;
+	return MAPLE_DST_NEUTRAL;
 }
 
 /*
@@ -2151,74 +2162,147 @@ static inline void cp_data_calc(struct maple_copy *cp,
 	cp->data += r_wr_mas->mas->end - r_wr_mas->offset_end;
 }
 
-static bool data_fits(struct ma_state *sib, struct ma_state *mas,
+#define MAPLE_TEST_ALT_SIB 3
+#define MAPLE_NO_SPACE (-1)
+#define MAPLE_MIN_SPARE_SLOTS 2
+
+static int data_fits(unsigned char end, struct ma_state *mas,
 		struct maple_copy *cp)
 {
 	unsigned char new_data;
 	enum maple_type type;
 	unsigned char space;
-	unsigned char end;
+	int spare_slots;
 
+	/*
+	 * end is an index while cp->data/space are sizes, so a strict fit would
+	 * allow new_data <= space.  One spare slot (new_data < space) avoids full
+	 * pack.  Keep one more spare slot here to reduce split/rebalance churn.
+	 */
 	type = mte_node_type(mas->node);
 	space = 2 * mt_slots[type];
-	end = sib->end;
-
 	new_data = end + 1 + cp->data;
-	if (new_data > space)
-		return false;
+	spare_slots = space - new_data;
+	if (spare_slots < MAPLE_MIN_SPARE_SLOTS)
+		return MAPLE_NO_SPACE;
 
-	/*
-	 * This is off by one by design.  The extra space is left to reduce
-	 * jitter in operations that add then remove two entries.
-	 *
-	 * end is an index while new space and data are both sizes.  Adding one
-	 * to end to convert the index to a size means that the below
-	 * calculation should be <=, but we want to keep an extra space in nodes
-	 * to reduce jitter.
-	 *
-	 * Note that it is still possible to get a full node on the left by the
-	 * NULL landing exactly on the split.  The NULL ending of a node happens
-	 * in the dst_setup() function, where we will either increase the split
-	 * by one or decrease it by one, if possible.  In the case of split
-	 * (this case), it is always possible to shift the spilt by one - again
-	 * because there is at least one slot free by the below checking.
-	 */
-	if (new_data < space)
-		return true;
-
-	return false;
+	return spare_slots;
 }
 
-static inline void push_data_sib(struct maple_copy *cp, struct ma_state *mas,
-		struct ma_state *sib, struct ma_state *parent)
+static inline int push_data_sib_left(struct maple_copy *cp,
+		struct ma_state *mas, struct ma_state *sib,
+		struct ma_state *parent)
 {
-
-	if (mte_is_root(mas->node))
-		goto no_push;
-
+	if (!parent->offset)
+		return MAPLE_NO_SPACE;
 
 	*sib = *parent;
-	if (sib->offset) {
-		sib->offset--;
-		mas_descend(sib);
-		sib->end = mas_data_end(sib);
-		if (data_fits(sib, mas, cp))	/* Push left */
-			return;
+	sib->offset--;
+	mas_descend(sib);
+	sib->end = mas_data_end(sib);
 
-		*sib = *parent;
-	}
+	return data_fits(sib->end, mas, cp);
+}
 
-	if (sib->offset >= sib->end)
-		goto no_push;
+static inline int push_data_sib_right(struct maple_copy *cp,
+		struct ma_state *mas, struct ma_state *sib,
+		struct ma_state *parent)
+{
+	if (parent->offset >= parent->end)
+		return MAPLE_NO_SPACE;
 
+	*sib = *parent;
 	sib->offset++;
 	mas_descend(sib);
 	sib->end = mas_data_end(sib);
-	if (data_fits(sib, mas, cp))		/* Push right*/
-		return;
 
-no_push:
+	return data_fits(sib->end, mas, cp);
+}
+
+static inline unsigned char push_data_sib_split(struct maple_copy *cp,
+		struct ma_state *mas, struct ma_state *sib,
+		struct ma_state *parent)
+{
+	struct ma_state left;
+	struct ma_state right;
+	int left_spare = MAPLE_NO_SPACE;
+	int right_spare = MAPLE_NO_SPACE;
+
+	if (!mte_is_root(mas->node)) {
+		left_spare = push_data_sib_left(cp, mas, &left, parent);
+		if (left_spare >= MAPLE_TEST_ALT_SIB) {
+			*sib = left;
+			return MAPLE_DST_FAVOUR_LEFT;
+		}
+
+		right_spare = push_data_sib_right(cp, mas, &right, parent);
+
+		if ((left_spare >= 0) && (right_spare >= 0)) {
+			if (left.end <= right.end) {
+				*sib = left;
+				return MAPLE_DST_FAVOUR_LEFT;
+			}
+
+			*sib = right;
+			return MAPLE_DST_FAVOUR_RIGHT;
+		}
+
+		if (left_spare >= 0) {
+			*sib = left;
+			return MAPLE_DST_FAVOUR_LEFT;
+		}
+
+		if (right_spare >= 0) {
+			*sib = right;
+			return MAPLE_DST_FAVOUR_RIGHT;
+		}
+	}
+
+	sib->end = 0;
+	return MAPLE_DST_NEUTRAL;
+}
+
+static inline unsigned char push_data_sib_rebalance(struct maple_copy *cp,
+		struct ma_state *mas, struct ma_state *sib,
+		struct ma_state *parent)
+{
+	struct ma_state left;
+	struct ma_state right;
+	int left_spare = MAPLE_NO_SPACE;
+	int right_spare = MAPLE_NO_SPACE;
+
+	if (!mte_is_root(mas->node)) {
+		right_spare = push_data_sib_right(cp, mas, &right, parent);
+		if (right_spare >= MAPLE_TEST_ALT_SIB) {
+			*sib = right;
+			return MAPLE_DST_FAVOUR_RIGHT;
+		}
+
+		left_spare = push_data_sib_left(cp, mas, &left, parent);
+
+		if ((left_spare >= 0) && (right_spare >= 0)) {
+			if (left.end < right.end) {
+				*sib = left;
+				return MAPLE_DST_FAVOUR_LEFT;
+			}
+
+			*sib = right;
+			return MAPLE_DST_FAVOUR_RIGHT;
+		}
+
+		if (right_spare >= 0) {
+			*sib = right;
+			return MAPLE_DST_FAVOUR_RIGHT;
+		}
+
+		if (left_spare >= 0) {
+			*sib = left;
+			return MAPLE_DST_FAVOUR_LEFT;
+		}
+	}
+
 	sib->end = 0;
+	return MAPLE_DST_NEUTRAL;
 }
 
 /*
@@ -2232,29 +2316,27 @@ static inline void push_data_sib(struct maple_copy *cp, struct ma_state *mas,
  * indicate it will not be used.
  *
  */
-static inline void rebalance_data(struct maple_copy *cp,
+static inline unsigned char rebalance_data(struct maple_copy *cp,
 		struct ma_wr_state *wr_mas, struct ma_state *sib,
 		struct ma_state *parent)
 {
+	unsigned char hint = MAPLE_DST_NEUTRAL;
+
 	cp_data_calc(cp, wr_mas, wr_mas);
 	sib->end = 0;
+
 	if (cp->data > mt_slots[wr_mas->type]) {
-		push_data_sib(cp, wr_mas->mas, sib, parent);
-		if (sib->end)
-			goto use_sib;
+		hint = push_data_sib_rebalance(cp, wr_mas->mas, sib, parent);
 	} else if (cp->data <= mt_min_slots[wr_mas->type]) {
 		if ((wr_mas->mas->min != 0) ||
-		    (wr_mas->mas->max != ULONG_MAX)) {
-			rebalance_sib(parent, sib);
-			goto use_sib;
-		}
+		    (wr_mas->mas->max != ULONG_MAX))
+			hint = rebalance_sib(parent, sib);
 	}
 
-	return;
-
-use_sib:
+	if (hint != MAPLE_DST_NEUTRAL)
+		cp->data += sib->end + 1;
 
-	cp->data += sib->end + 1;
+	return hint;
 }
 
 /*
@@ -2267,18 +2349,95 @@ static inline void rebalance_data(struct maple_copy *cp,
  * Note: @cp->data is a size and not indexed by 0. @sib->end may be set to 0 to
  * indicate it will not be used.
  */
-static inline void spanning_data(struct maple_copy *cp,
+static inline unsigned char spanning_data(struct maple_copy *cp,
 		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas,
 		struct ma_state *sib)
 {
+	unsigned char hint = MAPLE_DST_NEUTRAL;
+
 	cp_data_calc(cp, l_wr_mas, r_wr_mas);
 	if (((l_wr_mas->mas->min != 0) || (r_wr_mas->mas->max != ULONG_MAX)) &&
 	    (cp->data <= mt_min_slots[l_wr_mas->type])) {
-		spanning_sib(l_wr_mas, r_wr_mas, sib);
-		cp->data += sib->end + 1;
+		hint = spanning_sib(l_wr_mas, r_wr_mas, sib);
+		if (hint != MAPLE_DST_NEUTRAL)
+			cp->data += sib->end + 1;
 	} else {
 		sib->end = 0;
 	}
+
+	return hint;
+}
+
+static inline unsigned char cp_hint_split(struct maple_copy *cp,
+		enum maple_type mt, unsigned char hint)
+{
+	unsigned char min_split;
+	unsigned char max_split;
+	unsigned int target = cp->split;
+	unsigned int slot;
+	int preferred;
+	int fallback;
+
+	/*
+	 * Keep the original split bounds: these preserve minimum occupancy and
+	 * leave the one-slot margin used by the NULL-end adjustment in
+	 * cp_data_write().
+	 */
+	max_split = mt_slots[mt] - 1;
+	if (cp->data - mt_min_slots[mt] - 2 < max_split)
+		max_split = cp->data - mt_min_slots[mt] - 2;
+
+	min_split = mt_min_slots[mt];
+	if (cp->data - mt_slots[mt] > min_split)
+		min_split = cp->data - mt_slots[mt];
+
+	switch (hint) {
+	case MAPLE_DST_FAVOUR_LEFT:
+		target = mt_slots[mt] - 2;
+		break;
+	case MAPLE_DST_FAVOUR_RIGHT:
+		target = min_split;
+		break;
+	default:
+		break;
+	}
+
+	if (target < min_split)
+		target = min_split;
+	if (target > max_split)
+		target = max_split;
+
+	/*
+	 * A NULL write that lands exactly on split creates left-node edge churn in
+	 * cp_data_write(): the forward adjustment cannot run and the rewind path
+	 * is forced.  If this split lands on the NULL write entry, nudge one slot
+	 * away.
+	 *
+	 * Prefer keeping data on the hinted side.  For neutral, prefer pushing
+	 * data left when both directions are possible.
+	 */
+	if (target >= cp->write_start) {
+		slot = target - cp->write_start;
+		if ((slot <= cp->end) && !cp->slot[slot]) {
+			if (hint == MAPLE_DST_FAVOUR_RIGHT) {
+				preferred = (int)target - 1;
+				fallback = (int)target + 1;
+			} else {
+				preferred = (int)target + 1;
+				fallback = (int)target - 1;
+			}
+
+			if ((preferred >= min_split) && (preferred <= max_split))
+				target = preferred;
+			else if ((fallback >= min_split) &&
+				 (fallback <= max_split))
+				target = fallback;
+		}
+	}
+
+	cp->split = target;
+
+	return cp->split;
 }
 
 /*
@@ -2286,9 +2445,11 @@ static inline void spanning_data(struct maple_copy *cp,
  * @cp: The maple copy node
  * @mas: The maple state
  * @mt: The source node type
+ * @hint: Split preference from write placement and sibling side
  */
 static inline
-void dst_setup(struct maple_copy *cp, struct ma_state *mas, enum maple_type mt)
+void dst_setup(struct maple_copy *cp, struct ma_state *mas, enum maple_type mt,
+	      unsigned char hint)
 {
 	/* Data is 1 indexed, every src has +1 added.  */
 
@@ -2300,8 +2461,10 @@ void dst_setup(struct maple_copy *cp, struct ma_state *mas, enum maple_type mt)
 
 	cp->split = (cp->data - 1) / 2;
 	cp->d_count = 2;
-	if (cp->data < mt_slots[mt] * 2)
+	if (cp->data < mt_slots[mt] * 2) {
+		cp_hint_split(cp, mt, hint);
 		goto node_setup;
+	}
 
 	if (cp->data == mt_slots[mt] * 2) {
 		unsigned char off;
@@ -2407,16 +2570,23 @@ static inline void init_cp_src(struct maple_copy *cp)
  * @l_wr_mas: The left write maple state
  * @r_wr_mas: The right write maple state
  * @sib: The sibling maple state
+ * @hint: The sibling direction hint
  *
- * Note: @sib->end == 0 indicates no sibling will be used.
+ * Note: @hint == MAPLE_DST_NEUTRAL indicates no sibling will be used.
  */
 static inline
 void multi_src_setup(struct maple_copy *cp, struct ma_wr_state *l_wr_mas,
-		struct ma_wr_state *r_wr_mas, struct ma_state *sib)
+		struct ma_wr_state *r_wr_mas, struct ma_state *sib,
+		unsigned char hint)
 {
+	unsigned char offset = 0;
+
 	cp->s_count = 0;
-	if (sib->end && sib->max < l_wr_mas->mas->min)
+
+	if (hint == MAPLE_DST_FAVOUR_LEFT) {
 		append_mas_cp(cp, sib, 0, sib->end);
+		offset += cp->src[cp->s_count - 1].end + 1;
+	}
 
 	/* Copy left 0 - offset */
 	if (l_wr_mas->mas->offset) {
@@ -2424,8 +2594,10 @@ void multi_src_setup(struct maple_copy *cp, struct ma_wr_state *l_wr_mas,
 
 		append_wr_mas_cp(cp, l_wr_mas, 0, off);
 		cp->src[cp->s_count - 1].max = cp->min - 1;
+		offset += off + 1;
 	}
 
+	cp->write_start = offset;
 	init_cp_src(cp);
 
 	/* Copy right either from offset or offset + 1 pending on r_max */
@@ -2433,7 +2605,7 @@ void multi_src_setup(struct maple_copy *cp, struct ma_wr_state *l_wr_mas,
 		append_wr_mas_cp(cp, r_wr_mas, r_wr_mas->offset_end + 1,
 			       r_wr_mas->mas->end);
 
-	if (sib->end && sib->min > r_wr_mas->mas->max)
+	if (hint == MAPLE_DST_FAVOUR_RIGHT)
 		append_mas_cp(cp, sib, 0, sib->end);
 }
 
@@ -2506,21 +2678,51 @@ void cp_data_write(struct maple_copy *cp, struct ma_state *mas)
 		/* Handle null entries */
 		if (cp->dst[d].max != ULONG_MAX &&
 		    !ma_slots(dst, d_mt)[dst_offset - 1]) {
-			if (s_offset == cp->src[s].start) {
-				s--;
-				src = cp->src[s].node;
-				src_end = cp->src[s].end;
-				s_max = cp->src[s].max;
-				s_mt = cp->src[s].mt;
-				s_offset = src_end;
+			if ((dst_offset < mt_slots[d_mt]) &&
+			    (cp->data - data_offset > mt_min_slots[d_mt] + 1)) {
+				d_max = node_copy(mas, src, s_offset, 1, s_max, s_mt,
+						  dst, dst_offset, d_mt);
+				dst_offset++;
+				data_offset++;
+				s_offset++;
+				if (s_offset > src_end) {
+					s++;
+					if (s >= cp->s_count) {
+						cp->dst[d].max = d_max;
+						node_finalise(dst, d_mt,
+							     dst_offset);
+						return;
+					}
+
+					src = cp->src[s].node;
+					s_offset = cp->src[s].start;
+					src_end = cp->src[s].end;
+					s_max = cp->src[s].max;
+					s_mt = cp->src[s].mt;
+				}
+
+				cp->dst[d].max = d_max;
+				if (WARN_ON_ONCE(!split))
+					split = 0;
+				else
+					split--;
 			} else {
-				s_offset--;
+				if (s_offset == cp->src[s].start) {
+					s--;
+					src = cp->src[s].node;
+					src_end = cp->src[s].end;
+					s_max = cp->src[s].max;
+					s_mt = cp->src[s].mt;
+					s_offset = src_end;
+				} else {
+					s_offset--;
+				}
+				/* Set dst max and clear pivot */
+				split++;
+				data_offset--;
+				dst_offset--;
+				cp->dst[d].max = ma_pivots(dst, d_mt)[dst_offset - 1];
 			}
-			/* Set dst max and clear pivot */
-			split++;
-			data_offset--;
-			dst_offset--;
-			cp->dst[d].max = ma_pivots(dst, d_mt)[dst_offset - 1];
 		}
 
 		node_finalise(dst, d_mt, dst_offset);
@@ -2600,7 +2802,7 @@ static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
 
 		cp->data = cp->d_count;
 		cp->s_count = 0;
-		dst_setup(cp, mas, mt);
+		dst_setup(cp, mas, mt, MAPLE_DST_NEUTRAL);
 		init_cp_src(cp);
 		node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
 			  cp->dst[0].node, 0, mt);
@@ -2625,9 +2827,9 @@ static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
 }
 
 static inline bool cp_converged(struct maple_copy *cp, struct ma_state *mas,
-				struct ma_state *sib)
+				unsigned char hint)
 {
-	if (cp->d_count != 1 || sib->end)
+	if (cp->d_count != 1 || hint != MAPLE_DST_NEUTRAL)
 		return false;
 
 	cp->dst[0].node->parent = ma_parent_ptr(mas_mn(mas)->parent);
@@ -2646,14 +2848,12 @@ static inline bool cp_converged(struct maple_copy *cp, struct ma_state *mas,
  */
 static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
 			    struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas,
-			    struct ma_state *sib)
+			    struct ma_state *sib, unsigned char hint)
 {
-	if (sib->end) {
-		if (sib->max < l_wr_mas->mas->min)
-			*l_wr_mas->mas = *sib;
-		else
-			*r_wr_mas->mas = *sib;
-	}
+	if (hint == MAPLE_DST_FAVOUR_LEFT)
+		*l_wr_mas->mas = *sib;
+	else if (hint == MAPLE_DST_FAVOUR_RIGHT)
+		*r_wr_mas->mas = *sib;
 
 	cp_dst_to_slots(cp, l_wr_mas->mas->min, r_wr_mas->mas->max, mas);
 	if (cp_is_new_root(cp, mas))
@@ -2692,16 +2892,16 @@ void copy_tree_location(const struct ma_state *src, struct ma_state *dst)
  */
 static inline bool rebalance_ascend(struct maple_copy *cp,
 		struct ma_wr_state *wr_mas, struct ma_state *sib,
-		struct ma_state *parent)
+		struct ma_state *parent, unsigned char hint)
 {
 	struct ma_state *mas;
 	unsigned long min, max;
 
 	mas = wr_mas->mas;
-	if (!sib->end) {
+	if (hint == MAPLE_DST_NEUTRAL) {
 		min = mas->min;
 		max = mas->max;
-	} else if (sib->min > mas->max) { /* Move right succeeded */
+	} else if (hint == MAPLE_DST_FAVOUR_RIGHT) {
 		min = mas->min;
 		max = sib->max;
 		wr_mas->offset_end = parent->offset + 1;
@@ -2716,7 +2916,7 @@ static inline bool rebalance_ascend(struct maple_copy *cp,
 	if (cp_is_new_root(cp, mas))
 		return false;
 
-	if (cp_converged(cp, mas, sib))
+	if (cp_converged(cp, mas, hint))
 		return false;
 
 	cp->height++;
@@ -3049,6 +3249,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	struct maple_copy cp;
 	struct ma_state *mas;
 	struct ma_state sib;
+	unsigned char hint;
 
 	/* Left and Right side of spanning store */
 	MA_STATE(r_mas, NULL, 0, 0);
@@ -3107,11 +3308,11 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 
 	cp_leaf_init(&cp, mas, wr_mas, &r_wr_mas);
 	do {
-		spanning_data(&cp, wr_mas, &r_wr_mas, &sib);
-		multi_src_setup(&cp, wr_mas, &r_wr_mas, &sib);
-		dst_setup(&cp, mas, wr_mas->type);
+		hint = spanning_data(&cp, wr_mas, &r_wr_mas, &sib);
+		multi_src_setup(&cp, wr_mas, &r_wr_mas, &sib, hint);
+		dst_setup(&cp, mas, wr_mas->type, hint);
 		cp_data_write(&cp, mas);
-	} while (spanning_ascend(&cp, mas, wr_mas, &r_wr_mas, &sib));
+	} while (spanning_ascend(&cp, mas, wr_mas, &r_wr_mas, &sib, hint));
 
 	mas_wmb_replace(mas, &cp);
 }
@@ -3377,7 +3578,7 @@ static inline void mas_wr_append(struct ma_wr_state *wr_mas)
  */
 static inline bool split_ascend(struct maple_copy *cp,
 		struct ma_wr_state *wr_mas, struct ma_state *sib,
-		struct ma_state *parent)
+		struct ma_state *parent, unsigned char hint)
 {
 	struct ma_state *mas;
 	unsigned long min, max;
@@ -3386,21 +3587,19 @@ static inline bool split_ascend(struct maple_copy *cp,
 	min = mas->min; /* push right, or normal split */
 	max = mas->max;
 	wr_mas->offset_end = parent->offset;
-	if (sib->end) {
-		if (sib->max < mas->min) {
-			min = sib->min; /* push left */
-			parent->offset--;
-		} else {
-			max = sib->max; /* push right */
-			wr_mas->offset_end++;
-		}
+	if (hint == MAPLE_DST_FAVOUR_LEFT) {
+		min = sib->min; /* push left */
+		parent->offset--;
+	} else if (hint == MAPLE_DST_FAVOUR_RIGHT) {
+		max = sib->max; /* push right */
+		wr_mas->offset_end++;
 	}
 
 	cp_dst_to_slots(cp, min, max, mas);
 	if (cp_is_new_root(cp, mas))
 		return false;
 
-	if (cp_converged(cp, mas, sib))
+	if (cp_converged(cp, mas, hint))
 		return false;
 
 	cp->height++;
@@ -3420,19 +3619,24 @@ static inline bool split_ascend(struct maple_copy *cp,
  * indicate it will not be used.
  *
  */
-static inline void split_data(struct maple_copy *cp,
+static inline unsigned char split_data(struct maple_copy *cp,
 		struct ma_wr_state *wr_mas, struct ma_state *sib,
 		struct ma_state *parent)
 {
+	unsigned char hint = MAPLE_DST_NEUTRAL;
+
 	cp_data_calc(cp, wr_mas, wr_mas);
+
 	if (cp->data <= mt_slots[wr_mas->type]) {
 		sib->end = 0;
-		return;
+		return hint;
 	}
 
-	push_data_sib(cp, wr_mas->mas, sib, parent);
-	if (sib->end)
+	hint = push_data_sib_split(cp, wr_mas->mas, sib, parent);
+	if (hint != MAPLE_DST_NEUTRAL)
 		cp->data += sib->end + 1;
+
+	return hint;
 }
 
 /*
@@ -3445,6 +3649,7 @@ static void mas_wr_split(struct ma_wr_state *wr_mas)
 	struct ma_state *mas;
 	struct maple_copy cp;
 	struct ma_state sib;
+	unsigned char hint;
 
 	mas = wr_mas->mas;
 	trace_ma_write(TP_FCT, wr_mas->mas, 0, wr_mas->entry);
@@ -3455,11 +3660,11 @@ static void mas_wr_split(struct ma_wr_state *wr_mas)
 			mas_ascend(&parent);
 			parent.end = mas_data_end(&parent);
 		}
-		split_data(&cp, wr_mas, &sib, &parent);
-		multi_src_setup(&cp, wr_mas, wr_mas, &sib);
-		dst_setup(&cp, mas, wr_mas->type);
+		hint = split_data(&cp, wr_mas, &sib, &parent);
+		multi_src_setup(&cp, wr_mas, wr_mas, &sib, hint);
+		dst_setup(&cp, mas, wr_mas->type, hint);
 		cp_data_write(&cp, mas);
-	} while (split_ascend(&cp, wr_mas, &sib, &parent));
+	} while (split_ascend(&cp, wr_mas, &sib, &parent, hint));
 
 	mas_wmb_replace(mas, &cp);
 }
@@ -3478,6 +3683,7 @@ static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
 	struct ma_state *mas;
 	struct maple_copy cp;
 	struct ma_state sib;
+	unsigned char hint;
 
 	/*
 	 * Rebalancing occurs if a node is insufficient.  Data is rebalanced
@@ -3498,11 +3704,11 @@ static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
 			mas_ascend(&parent);
 			parent.end = mas_data_end(&parent);
 		}
-		rebalance_data(&cp, wr_mas, &sib, &parent);
-		multi_src_setup(&cp, wr_mas, wr_mas, &sib);
-		dst_setup(&cp, mas, wr_mas->type);
+		hint = rebalance_data(&cp, wr_mas, &sib, &parent);
+		multi_src_setup(&cp, wr_mas, wr_mas, &sib, hint);
+		dst_setup(&cp, mas, wr_mas->type, hint);
 		cp_data_write(&cp, mas);
-	} while (rebalance_ascend(&cp, wr_mas, &sib, &parent));
+	} while (rebalance_ascend(&cp, wr_mas, &sib, &parent, hint));
 
 	mas_wmb_replace(mas, &cp);
 }
diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index b9367c61e8b5..4033d1b85fee 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -1723,9 +1723,10 @@ static noinline void __init check_gap_combining(struct maple_tree *mt)
 	mn1 = mas.node;
 	entry = mas_next(&mas, ULONG_MAX);
 	MT_BUG_ON(mt, entry != xa_mk_value(index + 4));
-	mas_next(&mas, ULONG_MAX); /* go to the next entry. */
 	mn2 = mas.node;
-	MT_BUG_ON(mt, mn1 == mn2); /* test the next entry is in the next node. */
+	MT_BUG_ON(mt, mn1 == mn2);
+	entry = mas_next(&mas, ULONG_MAX); /* go to the next entry. */
+	MT_BUG_ON(mt, entry != xa_mk_value(index + 5));
 
 	/*
 	 * At this point, there is a gap of 3 at seq100[6].  Find it by
diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 0607913a3022..6d684327a8ca 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -36316,6 +36316,116 @@ static inline int check_vma_modification(struct maple_tree *mt)
 	return 0;
 }
 
+/*
+ * Assert we avoid split-edge jitter when a NULL write lands on split.
+ */
+static unsigned int count_tree_nodes(struct maple_tree *mt)
+{
+	MA_STATE(scan, mt, 0, 0);
+	unsigned int nodes = 0;
+
+	if (!xa_is_node(mt->ma_root))
+		return mtree_empty(mt) ? 0 : 1;
+
+	mas_dfs_preorder(&scan);
+	while (!mas_is_none(&scan)) {
+		nodes++;
+		mas_dfs_preorder(&scan);
+	}
+
+	return nodes;
+}
+
+static void check_split_jitter(void)
+{
+	DEFINE_MTREE(tree);
+	MA_STATE(mas, &tree, 0, 0);
+	struct maple_enode *left_node;
+	struct maple_node *root_node;
+	enum maple_type root_type;
+	unsigned long *root_pivots;
+	unsigned long fill = 0;
+	unsigned long left_max;
+	unsigned long right_min;
+	unsigned long gap;
+	unsigned long span_last;
+	unsigned long stable_split = 0;
+	unsigned int stable_nodes = 0;
+	unsigned int i;
+
+	/* Fill one leaf until the first split creates a root with two leaves. */
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	mas_lock(&mas);
+	while (mt_height(&tree) < 2) {
+		mas_set(&mas, fill);
+		mas_store_gfp(&mas, xa_mk_value(fill + 1), GFP_KERNEL);
+		fill++;
+	}
+
+	MT_BUG_ON(&tree, mt_height(&tree) != 2);
+	MT_BUG_ON(&tree, mte_is_leaf(tree.ma_root));
+	root_type = mte_node_type(tree.ma_root);
+	root_node = mte_to_node(tree.ma_root);
+	root_pivots = ma_pivots(root_node, root_type);
+	left_max = root_pivots[0];
+	MT_BUG_ON(&tree, left_max < 3);
+
+	/* Capture the first left/right leaf boundary. */
+	mas_set(&mas, 0);
+	MT_BUG_ON(&tree, mas_walk(&mas) == NULL);
+	left_node = mas.node;
+
+	right_min = left_max + 1;
+	mas_set(&mas, right_min);
+	MT_BUG_ON(&tree, mas_walk(&mas) == NULL);
+	MT_BUG_ON(&tree, mas.node == left_node);
+
+	/* Create a gap in the left leaf near the split boundary. */
+	gap = left_max - 1;
+	mas_set_range(&mas, gap, gap);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mas_set(&mas, gap);
+	MT_BUG_ON(&tree, mas_walk(&mas) != NULL);
+	MT_BUG_ON(&tree, mas.index != gap);
+
+	/* Span the gap into the right leaf, forcing spanning-store rebalance. */
+	span_last = right_min + 2;
+	mas_set(&mas, span_last);
+	MT_BUG_ON(&tree, mas_walk(&mas) == NULL);
+
+	/*
+	 * Repeated mmap/munmap-style updates over the same spanning range must
+	 * settle into a stable layout instead of split-edge jitter.
+	 */
+	for (i = 0; i < 128; i++) {
+		mas_set_range(&mas, gap, span_last);
+		mas_store_gfp(&mas, xa_mk_value(0x1000 + i), GFP_KERNEL);
+		mt_validate(&tree);
+
+		mas_set_range(&mas, gap, span_last);
+		mas_store_gfp(&mas, NULL, GFP_KERNEL);
+		mt_validate(&tree);
+
+		mas_set(&mas, gap);
+		MT_BUG_ON(&tree, mas_walk(&mas) != NULL);
+		MT_BUG_ON(&tree, mas.index > gap);
+		MT_BUG_ON(&tree, mas.last < span_last);
+
+		mas_set(&mas, 0);
+		MT_BUG_ON(&tree, mas_walk(&mas) == NULL);
+		if (!i) {
+			stable_split = mas.max;
+			stable_nodes = count_tree_nodes(&tree);
+		} else {
+			MT_BUG_ON(&tree, mas.max != stable_split);
+			MT_BUG_ON(&tree, count_tree_nodes(&tree) != stable_nodes);
+		}
+	}
+
+	mas_unlock(&mas);
+	mtree_destroy(&tree);
+}
+
 void farmer_tests(void)
 {
 	struct maple_node *node;
@@ -36411,6 +36521,7 @@ void farmer_tests(void)
 
 	/* No memory handling */
 	check_nomem(&tree);
+	check_split_jitter();
 }
 
 static unsigned long get_last_index(struct ma_state *mas)
-- 
2.47.3


--6odnmqt5iezagvak--

