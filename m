Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04C62CD6E7E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:35:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C3056B009B; Fri,  5 Jun 2026 14:35:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69AC26B009D; Fri,  5 Jun 2026 14:35:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58B556B009E; Fri,  5 Jun 2026 14:35:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9936B009B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06EDE120274
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:32 +0000 (UTC)
X-FDA: 84846712104.04.B811B6D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6F14280017
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CgCduHIB;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684530;
	b=YcPvwRvDMDY0vI/VO3LGGHqBtpZo+rX80czYIlUXJjZCkLSmVtpbRLyY8LBKdmtHetIwLJ
	XLORGVyjKI7XnR7KLmBx6vzGm1W4NtVmf63KJHT8tXlNtA0vupZVe+K3n32exJJLTLxAmL
	zuvrxSLV04KpvGK/YIsLkJBjIFVjCjY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CgCduHIB;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=//G582QmL83eTkSHOXL243u6P2jYvjAZreKxz5CziEA=;
	b=BBS+NlFmRT+SI9z4hktSdHmI5G1H1TznhHVmVqZ2i5GMzDMXU7EXCghZ+IRXCPuIJaysnD
	tdtqPkk8WwkANvCUoxEXLL7LzrsfIYeqI3kH8JGevpX3jcxU1G82zARh7n6PUjoH08GuTJ
	EfMeKnvZY21Ev6+kU9ZEsqjB2oxbxus=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB93960204;
	Fri,  5 Jun 2026 18:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7C21F00899;
	Fri,  5 Jun 2026 18:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684529;
	bh=//G582QmL83eTkSHOXL243u6P2jYvjAZreKxz5CziEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CgCduHIBqIPIikUteN8s7UcrkafZ328qitJTMRx9Gja3CtmQtqozZSz1Zo1cI3Q4a
	 0mf/tCWCSTcijpLqHNl9TEhAutmrsCk9GRJ+SYcGitEs482y4PCrL1BVdLCOEG9Nw4
	 5czURS+nx7/D/QTH4gdNW3LVBzzZLdXwdHsDgxSUn2+44JmtFlaUo9q6aiDvBG+Lgb
	 qPA/1r89XudaEhwvOQFP0XGpFLG7C2ZCEeP6SmQ0AYVC9gh3MrgQoPi/Kr2z+gUrHP
	 JdsoPk7nqhko/8Pvm3dp/u6IoE848ykhluss6wPDk/Al0xWHheka8i27MJ4VZZAOi3
	 LRjysH+vsMxAA==
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
Subject: [PATCH v2 07/18] kho: add callback for table pages
Date: Fri,  5 Jun 2026 20:34:40 +0200
Message-ID: <20260605183501.3884950-8-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6F14280017
X-Rspam-User: 
X-Stat-Signature: 9db8i9gb4ziuxw74g5iepu4x75uo6noe
X-HE-Tag: 1780684530-327293
X-HE-Meta: U2FsdGVkX18wtZnnzOJj/bP3tmF68T6gLPA6VPxT9k1NmLfkECJerfd4Mj9pxLkcSZA0CfPkszFwfjs2lqB6POqygopo9LyHTseIiqBNI+Vi74QqwEwnOgQV0fWfohRHOi4Jue4FsE/8zlQD93drbUbSTRg1wSuSEchZ1J1+Dbnmuc4bbJOPe+LHxwFoXgYIK04YFB7w7Um4mlwiGjiE0xYEtizQlWGL9MBC+UPw1hUP00iJV/ZjswTCV1GGAl0geBIzRCxC0M828yrUjDfKyJJuPejGB5+vZ8nCotmOpvaOujAHSAklZFbhsOfiI1JLmBdYaPXx+1MuqBRJ8yY5dmScwdVWYtbJKrNlIBt5KoXYMh+Cdu5I4ZAoQ1oNOZHrAxfYtk/jW2u8yu0KIw8CwZrQONmRAocOK9uFanZx+J9AV5dI8sJWuihMoMp69co6D5DdoT4mATOEtuxbHYRcQHswDtLC+CGNlRi19ri4eWX3QZ9AdWVWAIaxjVzl2TE2FYgNjmQ9d6Uymcqb7es2PMq5pFSK2Y72YLPogPNVx7dD+4v8SgkYd/eAaPQl7Vkv+Ep+unBrXb58A1joFhIKFdJmSyyk3Mx1SQrvogb++eq0Lu8zTOfuBVafatvoKcZE9SKaDbGBtYhU1ezT2GuIW9195+cVifTGJK38Ol+QctfA52t2onGiXY9ZKrZuUgDMwXU3/FPmi/Wy25sXHXerC22vtSM5GZKOC2PuanGVD+Mu2ze5VvwghqhtwQhjK7+jhaEX1ESOs8UlDHyaCBFTt5WQIcav87tkq2YHI7cFO6IlMDjmj3T37ZR188ZaVTVjnGhQJjYbBIZ2MLqkLJcoEKtuQZY3+6Ti5l6ERE9CNyZj1bZ4hWd+6KXZaee2OW5cnmd+HJ35A7s26ECCaI7UTggkcNAFT8zFlqQdioXEyulxaRRwCI+4h9/hqB9rCQZitLYYirio65gi0L2oglA
 UoMOSqfp
 ASy0jwuVlWREYUD4TveiZUtsGhec8U1UUQbW355eGKlxJNncP0o703wBSFTwWcxVb0iOf04K4kGmdi9OCX4IpW2Sqhy4cEKYUDcG0RwPXHYS5mUYUxd5Y3rpQBUbxmlMAVt9kVGCJA1jnanrjXfVqIY+6VQkJZDO6+jBMk6AchDWif3FTITX5mR/cfLaUbzHwCOLIpYNOQrkOM8IvQ5jRUsMSWdlLNENueaZ3p8luAvVcHQ4Wgf+hG6QvkfZnHy3oO4j+kWE7VOwxb3A=
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
index dbe075348ce4..94f18fe42c4b 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -285,6 +285,12 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
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
 
@@ -307,6 +313,12 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
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
2.54.0.1032.g2f8565e1d1-goog


