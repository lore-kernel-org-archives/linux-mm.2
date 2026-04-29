Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA961CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495DD6B0098; Wed, 29 Apr 2026 09:39:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8E56B0099; Wed, 29 Apr 2026 09:39:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C01B6B009B; Wed, 29 Apr 2026 09:39:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1BB146B0098
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:39:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D8A65160264
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:39:56 +0000 (UTC)
X-FDA: 84711701592.01.78697D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 15CC2140002
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:39:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pJMgz7rA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777469995; a=rsa-sha256;
	cv=none;
	b=2N/wH/Hg0XOmEgV6KLy4JKPeJRM9KXuEGaAnAsOmeOQ+5En0nYzqTIM0bSbQ3FBAQvBmVd
	6E/Oiswz0WpJrDm11xqUwBTJFu2Tq2XvcN/xaaqcrUueCXWliK5ZIPg0XEUckO26m+T0UC
	N5S1790dPioj0tm4olSXZ4swhC2fp/Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pJMgz7rA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777469995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wT8SHT65Xp8jPRIDHQJpTLiE6G4RyE+OJV6LG666YIw=;
	b=njY7mUPdhGd1m+l+7uzR/ti72UISzMutfU6SqJz+cx0EJO/rPmGIeEs/misby4R7nnKM1y
	tsA59T7/BUYnQMTvVohMxge4sdTXbhoIcyKDq7ZONFcVRtAfKop3/cYPpjnJzuIOYfBNbG
	rCVdHbzkAQZ26BQXjtZ6RWbpK8iE2uI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0112744500;
	Wed, 29 Apr 2026 13:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B84C2BCF5;
	Wed, 29 Apr 2026 13:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777469993;
	bh=sDZpiRzsQemL+9DqGDzdUHvJ8tPGWBEbveTIR7Y1hd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJMgz7rANvW3gltIkCoxOmN4OeT/8No7Cp1LNZNgfeI0ERfnTBJV7X5VA9FsFlsBQ
	 AkoG4qksc3arluR9/BXwUeN2v8vDomDJR4s/cIZa61IvEufufumwfXANLiu0VTO9Ar
	 4/rks236tYY0G6/gif4nwLOVloLD0TccVWymjdpcOWyoEe4YaiOykti2NUgoYASke7
	 MhRh3K1y4/v+UR4paeYbNAfM3yinnlpo3/1VnW3jG/w+lW2cbiU+7I3kPHDGNCLOgj
	 IAN0zzX3m1ic3nirBkZDMHk++ARwWtCfZT1pisHHN79hfyYM3M01Lkc2epsT+rhWtK
	 /2IZuGHxw9WIg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] kho: add callback for table pages
Date: Wed, 29 Apr 2026 15:39:06 +0200
Message-ID: <20260429133928.850721-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260429133928.850721-1-pratyush@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xxxe3gzm5d1ypj99ai4hdqgc3cmm45br
X-Rspam-User: 
X-Rspamd-Queue-Id: 15CC2140002
X-Rspamd-Server: rspam07
X-HE-Tag: 1777469994-135522
X-HE-Meta: U2FsdGVkX19jES1BNqaNaCae3dK+nniDckjzdZvyaJFt/Iv0fP8eTrj2IxBsTBRISOiPxNO8K58FnvcJqcSqLGDmwRsDb+pNsRGrSbt4JKeG4yuiEonxt1J7p/5FTNYlko3MVHxWzO5Ls/6VwbVSu26SZJhn+2KRcrJa1DvueuoDSuZAWQkABe4On0Sy9bk69jpB9Y0TjV12p5Rm0lQqyThR1a1KlkugQ1UbGvF0SkVaerSM6d6WTnwOGuGeuZF1tTWwvDtAtRuJvs15gZnwZW8JhIPuNbqj4BaR/UH0zwEt7qS9XRpPzlb6B30087p//GrhFkY5O5b1xaEtKvPCmyzFqeiZxR3atd9W+6pyrq2cPgOIOwAq9+eeH6IGZGYHHV9rXopLTcThH+rARQa01ZfGdCJ7rPJM3JnRKm6EbF3wPl7dMgu2NpCk0UFlZih2wGqHO7zSMWxOq68x0yRlYVNTVRQhLQ3IZWOX0UqGoUHwaVdyeksBJBL3Nn7E0Owi93kewwGKArgfHbCvzmHnH8bA3AJX2FCWy6rb3I5UIHmAjROK/54GVFC30WD8sI7w2GSqJdXihGfeP9fByl+9MBoGVHzqXQg6/Gi9AazBw9mAVD+dez2XgTqSCty+FvJYmg2NBLAlEnRVa52TmtvjaBYtsmQwV+gQak3Lwpc7kvvSGFgNt7EqM9Uiug9cen4ThfhUarjmyU3muf5pkzr7zwRIcGcONfP4Lxi+Cjym5vr95Oud20Nzv6CG6Jq9IkwnheKzazZgQwTaoYud9zyfj8280/KUUP6jfs7xbSOV3PoFHKdbdFqeRE9DjEs1o8vG8ldUJzTttXK6Bzl7ltVoFhPmaBNGbnBnOAOZ+s2/RQCDEs2f9GTOAvix8X3RAbYtao9hA5DMXJ+DNfAw5VKYzHt8Jr4aqV8RrnV9C3Z+r7ouzPv4S7EEYk0eX1RkwNzXuOb0kP6KAkNNW+LGtJ/
 YG3Tkacq
 MvNpXKBCDGALOqpRXAAco58aYa01e49pDNv9RSwcY3BtMyTuZx5nswbzFRoNGY0e3oosAW2YLhCIcAxCJvmiieB/sYpSfTpgNg5wEPp4taMBx35YnlNrazGRoE3DJ9+h9aAsTyNo3fYP60PkjkXmrltsqAjHFnZoQbSy0qf5ks/UD/PkzMWONDMdAkOdNFYvahMDSksg725m7+8jjtDXuO6at5jzfO69WzLAIAzV+YGYqJbTuYUzOHbtPg0+61kQuPZogfBBZsnBS2QQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The KHO memory preservation radix tree does not mark the table pages
themselves as scratch. This is done to avoid a circular dependency where
preserving a page can lead of allocating other preserved pages. This
means any walker looking for free ranges of memory outside of scratch
areas will ignore the table

Add a table callback that is invoked for each table page. The callback
is given the physical address of the table page.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kho_radix_tree.h     |  3 +++
 kernel/liveupdate/kexec_handover.c | 12 ++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
index 030da6399d28..fe7151d89361 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -37,12 +37,15 @@ struct kho_radix_tree {
 /**
  * struct kho_radix_walk_cb - Callbacks for KHO radix tree walk.
  * @key:      Called on each present key in the radix tree.
+ * @table:    Called on each table of the radix tree itself. Receives the
+ *            physical address of the page containing the table.
  *
  * For each callback, a return value of 0 continues the walk and a non-zero
  * return value is directly returned to the caller.
  */
 struct kho_radix_walk_cb {
 	int (*key)(unsigned long key);
+	int (*table)(phys_addr_t phys);
 };
 
 #ifdef CONFIG_KEXEC_HANDOVER
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4a5d1b47799c..94ca831b41c9 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -273,6 +273,12 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
 	unsigned int i;
 	int err;
 
+	if (cb->table) {
+		err = cb->table(virt_to_phys(leaf));
+		if (err)
+			return err;
+	}
+
 	if (!cb->key)
 		return 0;
 
@@ -295,6 +301,12 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
 	unsigned int shift;
 	int err;
 
+	if (cb->table) {
+		err = cb->table(virt_to_phys(root));
+		if (err)
+			return err;
+	}
+
 	for (i = 0; i < PAGE_SIZE / sizeof(phys_addr_t); i++) {
 		if (!root->table[i])
 			continue;
-- 
2.54.0.545.g6539524ca2-goog


