Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 879F8CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A2BA6B00B8; Thu, 21 May 2026 11:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42C0F6B00B9; Thu, 21 May 2026 11:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CBE36B00BA; Thu, 21 May 2026 11:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1380A6B00B8
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:45:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B00491C1ACB
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:45:23 +0000 (UTC)
X-FDA: 84791851326.26.A33A046
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0FC39120003
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:45:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2aVNG5UL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf29.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779378322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FtW46vKlNNALD/zxQOtmBrPRqKcpyx0kda6fguvIyA=;
	b=62J7N66WLkk6QIFKPgyUT4F5+hqS6vt9zqb7DaFJxbQ11IGXDsPPJTLwf18jIlYUKOH0xu
	ApWsGApn9PkTWux/fDYusXHVnt0X3ZUwI1M85kUd2IEW7kUH3YLxtweqpduFnyHY/vsP+g
	VOZnbJkJEO8nh/nNeETqI3ZbFTnS+O8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779378322; a=rsa-sha256;
	cv=none;
	b=aISEcSvMlYGbpqRN3dS2Z4hx1mcLu1McrKD0WCycfb+r+4Ac4OzpBTuBLbzKpNizgoNIx3
	Uk77HTOaLSqJ0hWO1ojgUOLgTZrBMiartmQVaagCZZ6B+4V6BiHWX+B5hUq59f0LrW5ocw
	n7+a/t1o36vCYU8Yyl96zyA6axOTcPk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2aVNG5UL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf29.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0FtW46vKlNNALD/zxQOtmBrPRqKcpyx0kda6fguvIyA=; b=2aVNG5UL7YSPCk/rQnyjP3GT75
	BaIVwIh+J2+nuv8yNOlwOE1ld7cV8JFGpDCbkQ7ID75IR33tk/7h8QFXwAPv9semyyS9XxM8YccU/
	thScC7XDPHSG3Xv2SulMaEwtDeH4ERPXKSSzmwcdw3jHeTOEyCNrLPqJUUo47heea62ujhXUDOsbY
	c3fhvR6HSozzwywZ4jAzg7hjoB0ZhdyyvqImDyyDWrS7mWFh026wvJjEG0LkSnBHJ7qWSNY8oa4Db
	vs5C7K0DjAyXMF6FXkbYzPiGSS8LEwo1tfrH3/R+BgBZ+Q7n0lhBYYhdKy4OAYn0Jzq0/sldxypar
	N8n+uebA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQ5a8-00000008NhO-2g5I;
	Thu, 21 May 2026 15:45:08 +0000
Date: Thu, 21 May 2026 11:45:05 -0400
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
Message-ID: <g7pvhqnuloifqhbvjgtgydbitcrvmxibferexj7cunsmagttps@oxjvs3aa3l3s>
References: <202605131554.92e7df6b-lkp@intel.com>
 <22y6gvr7yzwdocwpd3wxrxfykmpvhbxytiiuht32db3dh7w522@pglkrpqognjk>
 <agV3Q2fBlQrB5v9w@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nbgco3lueasalhqb"
Content-Disposition: inline
In-Reply-To: <agV3Q2fBlQrB5v9w@xsang-OptiPlex-9020>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0FC39120003
X-Stat-Signature: ntemtqci4q5e9bqebctdgx8hm59xqsqc
X-Rspam-User: 
X-HE-Tag: 1779378320-394164
X-HE-Meta: U2FsdGVkX1+57fGT/u3RSVeyGp/wZOPQHKKW1yiVPgZMdLpOhXQXXe2ydhDTljqoqUkb0ewfk72BSuWBVA7K78KTejqSkI5K1aW8klo2LuQ26V3fmL9GadHmZkREqsunH16lt1rPgzZgHxmptKmGWGzMry3RVLNfRdR66KP7l4KTDoNuZsny6WymoC86FqInd/asjYRQUzU6iGy2E9a/BDLttdV+NurlvmyOx18BjBWEpbxC8gaOwUthZvb5qNlBAPrBowl3s0Zy6/Qmj3E8HpBslVnwNNVpXVyAzje/4hpZOfbZrHX365TSMnpdzon7wdx/lJHPsajkQVE6qS3e+8OlNbtVbN5Bt7lIY2UgkC4Go1BcQ6rLb9FOY92iPd+r1aTKApNthqC4O6pg44cL00HKlIxTIuq/IVO5P4rzMPblE+ba1INdkcnUWNATVADWzDcWdy069huxg+XV7cNgjiOW/xAP/zFKoMbV5Lq6rML09PZY81sMpgU5rKUfWYDn8omA5J8ChjYYD/sb8wCFDZjHiFUHisZqf6UYqXMaIHNseRUbLxorP94pXe6JZU14py6Da+7WmXpsCweCu7Hb9nEeQdToBcn7OVgcyypB3NAkjm17enYxSEOQWP+4k5F5qh8RbvBHRhWFnrjRtk2Gt0vu7sIRPrKuZfAshHPcE/zoqsjelmwXUUzYVGxxUcFliyBzj71sNc3vlZjc3ZVYiIm8e/vwd5efHjp+tH1cwmmL0zmxZ6WN92plysPguz7wJW/zr5wR7v6XJ+AIu2FxpN8Df1gcKlTH5xiU10xOxG3vrtOIZYxHSrdirxI13DBco3L+EbbZzqO4iegR6ODEdt4NJT7cnRam4hHrfYTVrmc5mDns5SPLN2P4bd8Ee8+V7TtKNmQCIOdilkkyvowFbGmI/6Zo/O7Ra0wbxvjOj3pjQLlFX08WYeYWSmfrGnhQtfFuungD1n26f9+0vfc
 J2tTCFG6
 2oSzsT5YUzbzjt098CF3Qgg1CsfGsuIMNcITuXSIBzf0dtcj8B9TsSQI2FXCvtudK7tkirmTbRHiV55fjhLL5PUoL1lvRp/3iwanFDoO1en/mdK3IZZsdGHQnlVlOTYIjtrJVwrs5WCipmVq8dHxJSyaFJlQpwzUzEkWnm4bTxEdcB100VVjTL9QaaipCW8w9dJz5TemarlnxQDBh94kQX9tjwSzqpH2wYDVDDbNcK44vPbx2Pi8JgziCWokSLxX68U+9IyT2VaZsHSivp9+NvMHjPRLQ/gZ+Na5x+BF7JtrRxbE+IU5EK+XOmof0BAl6M2bf0lnGBnxAxWD9jbTjir/W3kx4WsHPi/QDsVj6h/aw6Kr+7VPTbBjMxZQ2TVEfh7H2rqcRGMjL1FsjVWiXgDWUF/y1ieoEsoOZEMocvDheBgXp0jAdexHoqdkoQUJwkE6UbQkOmyKS7/nJebwW//XAw7bN1Kl/OIhFVKBn23r/Fi0VuYdFgxlB9a1rEWNRKLSoulmR8jOWfcyydqpypVTp+nJueuiv3Lo5Zm5UuT0C8FSB0LsLb3G/ax+RFjVbAsEe2X1TkLsYj/2jaYpso9G3rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--nbgco3lueasalhqb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 26/05/14 03:18PM, Oliver Sang wrote:
> hi, Liam,
> 
> On Wed, May 13, 2026 at 08:16:42PM -0400, Liam R. Howlett wrote:
> > On 26/05/13 03:40PM, kernel test robot wrote:
> > > 
> > > 
> > > Hello,
> > > 
> > > kernel test robot noticed a 6.0% regression of will-it-scale.per_process_ops on:
> > > 
> > > 
> > > commit: 280b792cac62ddadca2935766ca870b438c86323 ("maple_tree: use maple copy node for mas_wr_split()")
> > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > > 
> > > [still regression on linus/master      5d6919055dec134de3c40167a490f33c74c12581]
> > > [still regression on linux-next/master e98d21c170b01ddef366f023bbfcf6b31509fa83]
> > > 
> > > testcase: will-it-scale
> > > config: x86_64-rhel-9.4
> > > compiler: gcc-14
> > > test machine: 48 threads 2 sockets Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz (Ivy Bridge-EP) with 64G memory
> > > parameters:
> > > 
> > > 	nr_task: 100%
> > > 	mode: process
> > > 	test: mmap2
> > > 	cpufreq_governor: performance
> > > 
> > > 
> > 
> > Thank you for the report.
> > 
> > 48 threads on a 2 socket E5-2697 v2 looks to be 12 cores (24 threads)
> > per cpu (so x2), or exactly one mmap2 process per hyperthread.
> 
> this is the cpu information:
> 
> Architecture:        x86_64
> CPU op-mode(s):      32-bit, 64-bit
> Byte Order:          Little Endian
> Address sizes:       46 bits physical, 48 bits virtual
> CPU(s):              48
> On-line CPU(s) list: 0-47
> Thread(s) per core:  2
> Core(s) per socket:  12
> Socket(s):           2
> NUMA node(s):        2
> Vendor ID:           GenuineIntel
> CPU family:          6
> Model:               62
> Model name:          Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz
> Stepping:            4
> 
> > 
> > Is this across all process counts and peaks at 48, or just 48?
> 
> just 48. the run script is in
> https://download.01.org/0day-ci/archive/20260513/202605131554.92e7df6b-lkp@intel.com/repro-script
> 
> cd /lkp/benchmarks/will-it-scale
> python3 ./runtest.py mmap2 295 process 0 0 48
> 
> > Is this across many runs?
> 
> we run 6 times for both parent and this commit, the data looks stable
> 
> 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json:  "will-it-scale.per_process_ops": [
> 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    143595,
> 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    143474,
> 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    144104,
> 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    142796,
> 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    143081,
> 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    143623
> 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-  ],
> 
> 
> 280b792cac62ddadca2935766ca870b438c86323/matrix.json:  "will-it-scale.per_process_ops": [
> 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    134451,
> 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    135089,
> 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    135080,
> 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    135039,
> 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    134082,
> 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    135301
> 280b792cac62ddadca2935766ca870b438c86323/matrix.json-  ],
> 
> 
> > 
> > My testing didn't produce anything like this.  I'll have a look into
> > this when I can, but there isn't anything obvious that sticks out as a
> > likely cause.
> 
> if you want us to test any debug patch, it will be our great pleasure. thanks!

It looks like the result of the shape of the tree changing.  Can you try
the attached patch against Linus' tree?

Let me know if it'd be better to provide a copy based off 280b792cac62d
instead.

Thanks,
Liam

--nbgco3lueasalhqb
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-maple_tree-Restore-old-tree-layout-using-new-scatter.patch"

From 98e443b159a75a6cc34af839c122a9e5eea2fe19 Mon Sep 17 00:00:00 2001
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

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 include/linux/maple_tree.h |   1 +
 lib/maple_tree.c           | 427 ++++++++++++++++++++++++++-----------
 lib/test_maple_tree.c      |   5 +-
 3 files changed, 305 insertions(+), 128 deletions(-)

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
index 60ae5e6fc1ee..b83a5b902e56 100644
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
-
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
+	spare_slots = space - new_data;
+	if (spare_slots < MAPLE_MIN_SPARE_SLOTS)
+		return MAPLE_NO_SPACE;
 
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
 	sib->end = 0;
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
+	sib->end = 0;
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
@@ -2267,18 +2349,64 @@ static inline void rebalance_data(struct maple_copy *cp,
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
+	cp->split = target;
+
+	return cp->split;
 }
 
 /*
@@ -2286,9 +2414,11 @@ static inline void spanning_data(struct maple_copy *cp,
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
 
@@ -2300,8 +2430,10 @@ void dst_setup(struct maple_copy *cp, struct ma_state *mas, enum maple_type mt)
 
 	cp->split = (cp->data - 1) / 2;
 	cp->d_count = 2;
-	if (cp->data < mt_slots[mt] * 2)
+	if (cp->data < mt_slots[mt] * 2) {
+		cp_hint_split(cp, mt, hint);
 		goto node_setup;
+	}
 
 	if (cp->data == mt_slots[mt] * 2) {
 		unsigned char off;
@@ -2407,16 +2539,23 @@ static inline void init_cp_src(struct maple_copy *cp)
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
@@ -2424,8 +2563,10 @@ void multi_src_setup(struct maple_copy *cp, struct ma_wr_state *l_wr_mas,
 
 		append_wr_mas_cp(cp, l_wr_mas, 0, off);
 		cp->src[cp->s_count - 1].max = cp->min - 1;
+		offset += off + 1;
 	}
 
+	cp->write_start = offset;
 	init_cp_src(cp);
 
 	/* Copy right either from offset or offset + 1 pending on r_max */
@@ -2433,7 +2574,7 @@ void multi_src_setup(struct maple_copy *cp, struct ma_wr_state *l_wr_mas,
 		append_wr_mas_cp(cp, r_wr_mas, r_wr_mas->offset_end + 1,
 			       r_wr_mas->mas->end);
 
-	if (sib->end && sib->min > r_wr_mas->mas->max)
+	if (hint == MAPLE_DST_FAVOUR_RIGHT)
 		append_mas_cp(cp, sib, 0, sib->end);
 }
 
@@ -2506,21 +2647,51 @@ void cp_data_write(struct maple_copy *cp, struct ma_state *mas)
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
@@ -2600,7 +2771,7 @@ static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
 
 		cp->data = cp->d_count;
 		cp->s_count = 0;
-		dst_setup(cp, mas, mt);
+		dst_setup(cp, mas, mt, MAPLE_DST_NEUTRAL);
 		init_cp_src(cp);
 		node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
 			  cp->dst[0].node, 0, mt);
@@ -2625,9 +2796,9 @@ static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
 }
 
 static inline bool cp_converged(struct maple_copy *cp, struct ma_state *mas,
-				struct ma_state *sib)
+				unsigned char hint)
 {
-	if (cp->d_count != 1 || sib->end)
+	if (cp->d_count != 1 || hint != MAPLE_DST_NEUTRAL)
 		return false;
 
 	cp->dst[0].node->parent = ma_parent_ptr(mas_mn(mas)->parent);
@@ -2646,14 +2817,12 @@ static inline bool cp_converged(struct maple_copy *cp, struct ma_state *mas,
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
@@ -2692,16 +2861,16 @@ void copy_tree_location(const struct ma_state *src, struct ma_state *dst)
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
@@ -2716,7 +2885,7 @@ static inline bool rebalance_ascend(struct maple_copy *cp,
 	if (cp_is_new_root(cp, mas))
 		return false;
 
-	if (cp_converged(cp, mas, sib))
+	if (cp_converged(cp, mas, hint))
 		return false;
 
 	cp->height++;
@@ -3049,6 +3218,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	struct maple_copy cp;
 	struct ma_state *mas;
 	struct ma_state sib;
+	unsigned char hint;
 
 	/* Left and Right side of spanning store */
 	MA_STATE(r_mas, NULL, 0, 0);
@@ -3107,11 +3277,11 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 
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
@@ -3377,7 +3547,7 @@ static inline void mas_wr_append(struct ma_wr_state *wr_mas)
  */
 static inline bool split_ascend(struct maple_copy *cp,
 		struct ma_wr_state *wr_mas, struct ma_state *sib,
-		struct ma_state *parent)
+		struct ma_state *parent, unsigned char hint)
 {
 	struct ma_state *mas;
 	unsigned long min, max;
@@ -3386,21 +3556,19 @@ static inline bool split_ascend(struct maple_copy *cp,
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
@@ -3420,19 +3588,24 @@ static inline bool split_ascend(struct maple_copy *cp,
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
@@ -3445,6 +3618,7 @@ static void mas_wr_split(struct ma_wr_state *wr_mas)
 	struct ma_state *mas;
 	struct maple_copy cp;
 	struct ma_state sib;
+	unsigned char hint;
 
 	mas = wr_mas->mas;
 	trace_ma_write(TP_FCT, wr_mas->mas, 0, wr_mas->entry);
@@ -3455,11 +3629,11 @@ static void mas_wr_split(struct ma_wr_state *wr_mas)
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
@@ -3478,6 +3652,7 @@ static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
 	struct ma_state *mas;
 	struct maple_copy cp;
 	struct ma_state sib;
+	unsigned char hint;
 
 	/*
 	 * Rebalancing occurs if a node is insufficient.  Data is rebalanced
@@ -3498,11 +3673,11 @@ static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
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
-- 
2.47.3


--nbgco3lueasalhqb--

