Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3882CD1297
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:40:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECFB46B0099; Wed, 29 Apr 2026 09:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA60C6B009B; Wed, 29 Apr 2026 09:40:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D959B6B009D; Wed, 29 Apr 2026 09:40:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C675A6B0099
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:40:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5297CA0177
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:40:01 +0000 (UTC)
X-FDA: 84711701802.24.8E9F45A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6A9F510000B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:39:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=McyaYreL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777469999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QGesInR7T6C68cVUOlm4JuZ/jW8V7Alhc2pElaPQZR0=;
	b=qjNQUCKiEFVWNBz2NH+c6UGPMJLFpcaN0rZ1Yf1hUqXO5aZku3Ka51eeEEENtho+/omUXu
	3omfAFV8Rlx8lYd0LkS20Il/NbqjwNa4f9Vie6mSoo4S95fe8P4O117GcC3Jv5vpvJk1b4
	jLeQiU7AGHYC8CxX56gd0jcE4ZSvHF8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777469999; a=rsa-sha256;
	cv=none;
	b=R7yZ64xkSQLBPGeQ3ALXiKb4Fg8TJbsFpUK7hHtf/IVaE3I1RYGFCDQiTRhzn0ykliftwE
	GTUdyCLfYyXgtHlNpLB9MU7mo4ZE8L7mIBPyLJ/HfIhq6bq9+3mGZXSQrbSthIHq56jmih
	n1RpPk+RwLACi9IHdRrS2Oak/qv51xk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=McyaYreL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 90ED44083B;
	Wed, 29 Apr 2026 13:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85475C19425;
	Wed, 29 Apr 2026 13:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777469998;
	bh=ftYh4PDmonLl3Iz/lLsbB7jSCaV0uIwezkLhW0XcrsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=McyaYreLK3DAy83VtxLXczaPdKXbJ4HsxCY/b9v9x1w2NecV2RKtxkEindaIvwik+
	 p9wBKf9QM9MTBS70oGS1alRF8VwfLKyQP0+4d4uw6cNVG9h69sTE8EtPEByQVfsCu8
	 bPwGaav1RIb9hzLQe+joacKt7Oj9LVM5So5sgyYR5v/fyMaRHdSvIJUMikGsmSJoit
	 ypozQcdAlC8La2ma0Nyk9hasOZ+CYzl+xCTSYlqangq0cFXddwa8vUVg+pKe6XJB7m
	 WpaGbUethsdpNbmnKIUkq1TSbAi/GEhivGoKeWQ+4L6mkxo8NeQ0jpK3aIA/Qzp8up
	 EsGXhR/wQm11A==
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
Subject: [PATCH 06/12] kho: allow early-boot usage of the KHO radix tree
Date: Wed, 29 Apr 2026 15:39:08 +0200
Message-ID: <20260429133928.850721-7-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260429133928.850721-1-pratyush@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6A9F510000B
X-Stat-Signature: tyettyf31bwrtrqaeknphbmbfn7das8u
X-Rspam-User: 
X-HE-Tag: 1777469999-627779
X-HE-Meta: U2FsdGVkX18+5+iLy6m4swKCjyjj+u3N3/LpgHQTj7ATd18T0xP4494k2rLFbU2REiYKiTSdfVV9V7bB+UhDcFvXrUGJPlOApcrDaf57bu7YzZajIRDx7PjF15OE6hloSoLyMoSL1IOTwg51xnqnVBheDvjoS6pd/z0mGCguVd/ftRrA2pJUrge/3EzOorK/zXsIRrjWqtX4Tblrz0DtAZCkQlMEw2Cx7kTimGIHjBJjCJk9/CLAp4QJ+MmDBtPlPqHt60uUv8kHFv/aJIkDw/M/L45hEkzA5f3lcDiEwaRP6TnlM6biHw4Y9ECubWWAT71pEiluiAi+I4CBDgSlkukHOUb2MkfXZqI0D8djjQhf9R2jcLnmTTVByibEg/b5OHINezYtGR819gPzGOuncIBkJCDFKT79ZqdLpF5TkDNHv97Nijl49RXsJMQp6FQGpz3TM14FKI29Tfqaw6luCsSbs4QzMDPgLGMxBrlQzwWMAXnTBMXNufMdv3/IbL7zhYGVL/O3zpAEOobjg92fO9Bf8TseVel/0N6GSzeKaS/xJwsO0YJpJs5yMZdlmXhPgR0x9lmSRxX/IcHYBr83RwNTan1iCFJo3fjeCtIFfSDf9HAPzyh5gzlaNjOf4BijjPcqsoEUHe66Ya47k//Q3I8l0dyAF7WZgMwyTi1Ql85RCKGbN1CG7FUbV/nVmwMVtJw7cgilfZ+p2il2hWBW9gGzIohIMDqP0CiiDOJGMgjvlt3InyYLC719LtdFIkrq/+i5MjcRoaf/MQ7ykHuN44Yh0syhN5l8GJsjsspxN/18OXvijxWXNsb4OpQi2jGnIgnVJX5qgqe0ltZ7HjsR76lJYQ0rwH77YVqWeHZzxO13Xwl/Upw3BndYdFfzL4kp1uMzdk0MRXqCCGEaK+Hk/LPLbEZ4hF7SmFHBq1io/mh8Er8TADE4wN5uH1tXAWL4/hMOFyJY2f2NzME02QJ
 9T/qE6e4
 3Lp91PFRwceqE+lLfRMpTz0BnZEjuvAkhIG4IxksTBubAbJaRTkO8jNfw1RpFhcDLpFs91mvc4pAz9OZmgjgPSqgCiDg1PsFE+K3lMqlZ45L7sVre4wHyExGgf3xOIGahshlhRczP6i0qYR2jh2VegrWeMgbV4jF7vVw/nSTK+tguW2B+ZADRKfL3LYvYftKew+C/EnJi1eShlOYFDZqaIXflmFufYYOI7LUvax2+LIdRnnopyrBrUeN+gE/5t2HqvTEPunWS1/wuSo5qmSqr6vLXCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The KHO radix tree allocates memory for table pages from the buddy
allocator using get_zeroed_page(). This is not available in early boot
when memblock is still active.

Using the radix tree in early boot is useful for KHO to track metadata
about its memory. One such example is for tracking free blocks for
memory allocation when scratch runs out of space. This feature will be
added in the following commits.

Add kho_radix_{alloc,free}_node() which allocate and free the table
pages. They use slab_is_available() to decide which allocator to use.
While slab_is_available() indicates availability of the slab allocator,
it gets initialized right before buddy so it serves the same practical
purpose.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index d0a4f78eccfe..47f7c4a2865e 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -143,6 +143,26 @@ static unsigned long kho_radix_get_table_index(unsigned long key,
 	return (key >> s) % (1 << KHO_TABLE_SIZE_LOG2);
 }
 
+static void __ref *kho_radix_alloc_node(void)
+{
+	struct kho_radix_node *node;
+
+	if (slab_is_available())
+		node = (struct kho_radix_node *)get_zeroed_page(GFP_KERNEL);
+	else
+		node = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+
+	return node;
+}
+
+static void __ref kho_radix_free_node(struct kho_radix_node *node)
+{
+	if (slab_is_available())
+		free_page((unsigned long)node);
+	else
+		memblock_free(node, PAGE_SIZE);
+}
+
 /**
  * kho_radix_add_key - Add a key to the radix tree.
  * @tree: The KHO radix tree.
@@ -183,7 +203,7 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
 		}
 
 		/* Next node is empty, create a new node for it */
-		new_node = (struct kho_radix_node *)get_zeroed_page(GFP_KERNEL);
+		new_node = kho_radix_alloc_node();
 		if (!new_node) {
 			err = -ENOMEM;
 			goto err_free_nodes;
@@ -214,7 +234,7 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
 err_free_nodes:
 	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
 		if (intermediate_nodes[i])
-			free_page((unsigned long)intermediate_nodes[i]);
+			kho_radix_free_node(intermediate_nodes[i]);
 	}
 	if (anchor_node)
 		anchor_node->table[anchor_idx] = 0;
-- 
2.54.0.545.g6539524ca2-goog


