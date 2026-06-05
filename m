Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBCE3CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B9BC6B008C; Fri,  5 Jun 2026 14:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143956B0092; Fri,  5 Jun 2026 14:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0586B6B0093; Fri,  5 Jun 2026 14:35:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9F9B6B008C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DAEC8CCCD
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:19 +0000 (UTC)
X-FDA: 84846711558.30.8B99085
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0A85714000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eTBqi736;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ioAGw4mo1ZSaLPYQr72a7mMnE73SA6K6tW1O9fGp0Eo=;
	b=1DT/L5rdB4WoG1m4+pLjHfcJNFesIGmPQ4AzCbNM7NqGJz3yX79g8o6ezlVIRusbP0M/Wj
	cM1Br5+GbnbTe31E0wMw8+Dz+mxTNfbEshB2SSIxUaDxgSHKMnUWQ4PPQN9uDjRj7Qodop
	hOLO8OMPxfFoEX0uIuoab+rcpUpuiNI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684518;
	b=w8en08dF9SsHXNJoN/Of5zy27VJpr+lcFdqtK2JhI2sWZNwJjvX1TIQpLobpd0PmyZeceO
	ZYGzIYvbYUvOWLZQkrjfSJJNzLi8FJO7kuWoFCJdnrCOIGSvWiQsbtW8JiPuxoH/LZIffC
	iPMimALCp/hl0ZzlGhfmGW1uzQNkr2I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eTBqi736;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A441260204;
	Fri,  5 Jun 2026 18:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404861F0089B;
	Fri,  5 Jun 2026 18:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684517;
	bh=ioAGw4mo1ZSaLPYQr72a7mMnE73SA6K6tW1O9fGp0Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTBqi736uwqUzUJI9Q+VNGsjRDZoHKuLa+3iVAAhbnHhWJxIXcxg8gU8z0tqWrtVv
	 9FCWlBj9VEcEa/BnpGozoyHllj034V/bRRKn+vHsuaxtG3LxCEzdPS2KRQx2L7kens
	 btlbEQkkq3gzDNhJHd7W++WPQ/tKpmAukn0b3+OzlLlgAT3wwON9oh/5+Qda5zH/Jm
	 6FYzfGd2crcelE9VVBt3gw+qSb4VGtokhTO+III6C95A3b9aM/IBW6snlhZ6X3FdCJ
	 ThGmbQaoWfLwvar6GMCXSLZABMu8DwNGXgyNGsv6i5gxMyOBjF3acia4WJ40dg7h+V
	 4oDX9OVkERArA==
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
Subject: [PATCH v2 02/18] kho: disallow wide keys in radix tree
Date: Fri,  5 Jun 2026 20:34:35 +0200
Message-ID: <20260605183501.3884950-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0A85714000D
X-Rspam-User: 
X-Stat-Signature: mjccret16j5dni1hh5m6raq8e3jb5uoy
X-Rspamd-Server: rspam08
X-HE-Tag: 1780684517-77248
X-HE-Meta: U2FsdGVkX1/LamSQXogSedHUq5WDQ90poc1bEGDw2dVgHaLbYYdOp6D52pJLAxGZ7D7l1mQLbJiViMDfhiLR1czLfdaj2ZI01Ecghq8IDkPumQjWuPn43HyFfzd6F2ZqezEKADtY6Rx4XqAjrzEQn05BdE5/6U/diMY5EXL/X8V+pZjNCkCPcFYA65RN2B6uYgAIUMRJjZe6If90AU2afEb0B6bsnadFc8EJ9k4ndRQLmcGpxNa6RMBXYIwjAwyqPe6lFlbfviOC434kNL7LIxduuoRBbe4RdQUUgpEiYFvugL8VgwQvB+TcnSVsmH4PcD3fxJxTdomf0Uf+xBUkZ7pJKX81xyobqyOevatbvx/Zo2sXXFwAa4CefagO6qf9nUZ47IeMD7dpZruDMF8MIm6nvTuCiSm9CxBxJ0VHb9qOInYeoqZkFFSLfTbK62upDjLfF2ztvCnUToSkthT30JBdKaGJeSGYCfldeMhlrVFsgY2tiRwTyxfSBQ+s4jSi34EI6y9KI/Lbs1zlhqXDW8iwJcr7nCdyPXyaTruUuTuHp9Ev53P+NjDATLj+KIjb9Wq7k4EHxhmtCC0wlWixszIyBw6rB/L6AixXuu4zltaPz82MnlF744yX1fLpxpKiWI0+shDCnrHrFW5+QFfuAh0pRvSgMzDPI/RiqHCVBN7OvlqYpk7y1SV11Rw1f2wbGv7gO6xWKReoiVlGmzAd/7MhUHbY+ZKIAYtXE+AVcPyx4OeDcAt7dhH4Pocy6y/PaQljAcCbrlIaKLmHWgTfn8MAGSqzEY0J2Y7bzOTgo2yLBT5hi2p3AflaJ9le/uhWdFzRjZsQFp/2TQ4tjg7ynhVIiokX0iLWX9p1FDtdC3kphyzd8gDGX7xiH9DEDRDKXUBRVB5R7ylRQJML0vjsnE0x9DF2/z8VDCen4OLCTLQglmjuZCy5Shxqz6lN+qkmgyzBzNBKILPxYJwwc1J
 5Oeiikw2
 lMjncbDD+f3wUBMvBwBdiKZt7rXsK9SCWw28S/KK9CbneGbea/YbalycQvlLVDZoTycY4rlGeQMwOYDjBzXeHyL1cy4W0ymX28hzAYCZcsGqeJYvD9XjRbv6lCppJFWLKuQvqus/TO2cl/sFUCIuYThXXX5lwuC0H442I8ConI2Sj7rSDqECysOTZDRyG0QCZTzxz+uK1w5vmzyZD+m0Gcr3qzLDusGoi1y4JNbbqR4BZykk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The KHO radix tree was designed to track preserved pages. So it does not
provide the capability to track any 64-bit key. Instead, it limits the
key width to how much it needs for tracking PFNs and their orders.
Limiting the width reduces the number of levels in the tree.

KHO is not expected to be the only user of the radix tree. With the API
generalized to allow other users, now it is possible to add any key to
the tree.

Check the key width at kho_radix_add_key(), and error out if it exceeds
what the tree can handle. Do this instead of increasing the tree depth
since right now there are no users that need to use wider keys, so this
avoids memory overhead and ABI breakage.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kho/abi/kexec_handover.h |  8 ++++++++
 kernel/liveupdate/kexec_handover.c     | 12 ++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index fb2d37417ad9..6dbb98bfb586 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -278,6 +278,14 @@ enum kho_radix_consts {
 			     KHO_TABLE_SIZE_LOG2) + 1,
 };
 
+/*
+ * The maximum key width this radix tree can track.
+ *
+ * This value isn't ABI itself, but it is derived from values that are ABI.
+ */
+#define KHO_RADIX_KEY_WIDTH (((KHO_TREE_MAX_DEPTH - 1) * KHO_TABLE_SIZE_LOG2) + \
+			     KHO_BITMAP_SIZE_LOG2)
+
 struct kho_radix_node {
 	u64 table[1 << KHO_TABLE_SIZE_LOG2];
 };
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 7349cc82f6dc..e8454dc5b489 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -153,6 +153,11 @@ static unsigned long kho_radix_get_table_index(unsigned long key,
  * intermediate nodes do not exist along the path, they are allocated and added
  * to the tree.
  *
+ * NOTE: Currently only keys of width up to %KHO_RADIX_KEY_WIDTH are supported.
+ * This limit only exists because current users of the radix tree don't use more
+ * than that. Changing the maximum width requires changing the tree depth, which
+ * needs bumping the ABI version.
+ *
  * Return: 0 on success, or a negative error code on failure.
  */
 int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
@@ -169,6 +174,9 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
 	if (WARN_ON_ONCE(!tree->root))
 		return -EINVAL;
 
+	if (unlikely(fls64(key) > KHO_RADIX_KEY_WIDTH))
+		return -ERANGE;
+
 	might_sleep();
 
 	guard(mutex)(&tree->lock);
@@ -241,6 +249,10 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
 	if (WARN_ON_ONCE(!tree->root))
 		return;
 
+	/* Keys wider than KHO_RADIX_KEY_WIDTH are not allowed to be added. */
+	if (unlikely(fls64(key) > KHO_RADIX_KEY_WIDTH))
+		return;
+
 	might_sleep();
 
 	guard(mutex)(&tree->lock);
-- 
2.54.0.1032.g2f8565e1d1-goog


