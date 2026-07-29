Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84C80C54F55
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F8476B0162; Wed, 29 Jul 2026 10:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A94F6B0164; Wed, 29 Jul 2026 10:56:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BE986B0165; Wed, 29 Jul 2026 10:56:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 454B66B0162
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:56:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C89381C0DBA
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:45 +0000 (UTC)
X-FDA: 85042115970.14.F0BF5FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 393144000E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QsgHpZjw;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PzxYZqqYyrI+9wxKR1kRgJpED7EOcZAMCNlRei/+zXk=;
	b=qB7M4WNgMfTfmcKSTzwvZXJBRYitTzfF/O3qUpRjhIDkeG7k8NSRVHw15NR3SPE+n+LCnB
	N1JYqtJiIDXsMwXYE34drXDCLq8vUERxWGDHKfsYsV3ZIuknpX18leAQC3UBxcw+N2bSkM
	R2wXYy/sj+oNz1k+2y0l5LPQ7YxtRcs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337004;
	b=7wl7Q2S+D73Fow7l6+F6qYsLhNaoYGfLPh92GUL+LVI/uAwZ1wG++MoLM/iNjbFrPYn6GO
	qdNQP5UsoRFL6kn2qvEHACsZ0FSsNAANEY8PW4NHsNReQJD6thkJJLNLQMGPQQKRR6LhOT
	oeOLDboITgoucM8ByNB3o9ZWG7wGRn4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QsgHpZjw;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8401160A5B;
	Wed, 29 Jul 2026 14:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109541F00A3A;
	Wed, 29 Jul 2026 14:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337003;
	bh=PzxYZqqYyrI+9wxKR1kRgJpED7EOcZAMCNlRei/+zXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QsgHpZjwqbZuf87ikvD8qiVG13txFR8q1MCBJCH0R3wi/68klsjvtClPeaPlunvkk
	 v10AXT0COX4Bs0ylfjt6E9kMQ99OqPWmcFiYRo0ia03DydixQAAb+JKQStWNO7S1ZA
	 qx7lepnjw3RPYiDWthmQuw7ZC74eBef4qgJCe08boKwc+4LVPFP7POah4fjwSrj16j
	 XB12Q3rgkN8slZs08gLd1OCGS+4MliPkqo1Vk9qoJX6KlQnUVWegpeE/VND6+3D4EV
	 8Lp/ekfadUZN47dcgnt4tRyeyFWdkZVrfHyjhAetRjsama8MQuJcpedDqk+BrdY1LN
	 r5+g2NM3os24A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 08/22] kho: add callback for table pages
Date: Wed, 29 Jul 2026 16:55:53 +0200
Message-ID: <20260729145610.2827231-9-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 393144000E
X-Stat-Signature: w7tznzpxfb5oq7zb63qetograckbkmkh
X-HE-Tag: 1785337004-263735
X-HE-Meta: U2FsdGVkX1/IUtIwyF2hw4UlClvXzqif5I6gEh39HNRpcQNNgQ4dgplRP8UYeNFxlgAO6jDFCdi8hThtR2uH+hfAJZHdRbjp2nccdrk3X2EVJm/xT6FrUiZ1+l8gByT5f5dNygasUtHT/LhaGGiWUbVEKyjo/hpyZurO9n/0eDOSmA4vMN705zBGptqBFugQMCdGvqLd+K+TALjp8CClj46NBeYjr7vu/P7PZWEcgXRLPhTww+x8erY0myfG2BvvF+6K+F/ZUev4Nz12Ddb/Aer3JSJSnpmxMWtGQCtLkbflCZaWLjTsHI/CjR8YZIaLcXYzkg8QUCdREnz3qO8oOrUNJLSGMTHf9fQXaaqZ/bz5m3e3fKY5Sw0qwTBIlvl60Md+mEevQK+5mUIMk5cBU4Vc2ovlvq2hJCNqo2eYpH+axrFX01ZxcoQsTnu3/Ng2mIi9rT0WAnN/J6Gt8sdDFDnPf4T4ZsnbJC+pJIu0JCXAl9DrYp4Ft2XnNMV2uApGzLngyojOJwiLxWwErS4CVA02ryIPw0Ej4JsLY0JDEGGqFThAikmA83Lj0rWGPQ/yIP51x9lxej0QrIY/zy+8NrWnvzG4zY9SbnN9/+HNmBZocHYBw+iUJ3X0IsSZHJySAU4b40Zc4Eda8V85WvVYo+hVg8MqbCI+al0+BsJI3M3du3VYGJG7ExaeXIyGY5loaFMXVBOumoV60JIs/6SFFsIJ0M4rbthPdufvdCswhb6sznXKBhCjKl0Z8FcWpLVA10vcTtBudWM9d2K/0K2NnTmjwdzYA+VaPtDCGZdbiqID+q/iQpEKW3ZtT2CtrOjfQaVhnHIm49igb1C9rsR1jNznUqk62tQTvBft95EY8xSlXwpMCSxHg2LBMU6lUvWOltMRu4BzJBgr2SxoN2O8yXEiBGiVuW9HTjqZFuCOJsy2Uxe35QsRWXg4fSBSvfjizNL150d5Jas3g1Mk2sU
 GlHI0Lp5
 7xsZJaL2mRoHjxJR1baWiwBaOZKp5TL4jrr8qYsIO1gLDa+KkW2r5Hh5QuYLIu/kLa88s1yJRqPvQMdo12J9D3eu/hy+J33t39Na3EPgjYhDeICipLcshGkwi7TtMHTliucaKVelvLbYyXFbC3/p8aGpvwB20LRxsZO4RMNmQZgohn45vJo0QXF7l4wkFo+IclxFwj3tk6qXXhDbT2ki8St5/Xd6MQ/+XTKdFai1V/mZABQHFI+mmv05zKOPwgHpNy19zk0TnL/oOqeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The KHO memory preservation radix tree does not mark the table pages
themselves as preserved. This is done to avoid a circular dependency
where preserving a page can lead of allocating other preserved pages.
This means any walker looking for free ranges of memory outside of
scratch areas will ignore the table

Add a table callback that is invoked for each table page. The callback
is given the physical address of the table page.

This is useful for the upcoming mechanism that discovers blocks of
memory with no preserved pages and lets them be used for boot memory.

Another use case is for users of the radix tree other than KHO itself.
The radix tree does not preserve its own pages due to the circular
dependency described above. But external users of the radix tree would
need to preserve and restore their pages for the radix tree to survive
past early boot. They can use this callback to do so.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kho_radix_tree.h     |  3 +++
 kernel/liveupdate/kexec_handover.c | 12 ++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
index 426a9cc9bcde..ac7ba7e567e1 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -37,12 +37,15 @@ struct kho_radix_tree {
 /**
  * struct kho_radix_walk_cb - Callbacks for KHO radix tree walk.
  * @leaf:      Called on each present key in the radix tree.
+ * @node:      Called on each node of the radix tree itself. Receives the
+ *             physical address of the page containing the node.
  *
  * For each callback, a return value of 0 continues the walk and a non-zero
  * return value is directly returned to the caller.
  */
 struct kho_radix_walk_cb {
 	int (*leaf)(unsigned long key);
+	int (*node)(phys_addr_t phys);
 };
 
 #ifdef CONFIG_KEXEC_HANDOVER
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9fb07c0ef18e..2044f35cf1de 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -288,6 +288,12 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
 	unsigned int i;
 	int err;
 
+	if (cb->node) {
+		err = cb->node(virt_to_phys(leaf));
+		if (err)
+			return err;
+	}
+
 	if (!cb->leaf)
 		return 0;
 
@@ -310,6 +316,12 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
 	unsigned int shift;
 	int err;
 
+	if (cb->node) {
+		err = cb->node(virt_to_phys(root));
+		if (err)
+			return err;
+	}
+
 	for (i = 0; i < PAGE_SIZE / sizeof(phys_addr_t); i++) {
 		if (!root->table[i])
 			continue;
-- 
2.55.0.508.g3f0d502094-goog


