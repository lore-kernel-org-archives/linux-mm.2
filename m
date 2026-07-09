Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DAADC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3368E6B00A0; Thu,  9 Jul 2026 13:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BFF76B00A1; Thu,  9 Jul 2026 13:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FBF76B00A2; Thu,  9 Jul 2026 13:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D4C616B00A0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:39:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27F34A025A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:00 +0000 (UTC)
X-FDA: 84969948840.29.A64A20F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 88EBC12000D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TrJ2jtbR;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618738;
	b=lIiG9yu0l27kGRSyQK05s965xjGlA69OuD5o3J2GlrqgdWR0BNDp5EQ5WnAlmaH17QwNRs
	VTqoyY+w4VToTm6rnZuDMSx7lxhDqO2wU6ux7UnbfVxeHkNkq/2G+Z6tyUUdlCb0/8lxWC
	PrObSZCNGdW4uC5cHduJyid2C7SeuvI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TrJ2jtbR;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TflEiF+P3v8r5QgzuLrXTOp/v+oCi2axdEmh9PuAiiA=;
	b=uR6V+dt/aYmnHzA3RUbb7TBHVdZ9z8opoW1dMq7wOdT98+BccQfG9KDEYY3B94RCaVtgpg
	DSJh0YIP9HT1octmk3zfeDZDhKUInFr8jgMT7fhAB1HurSVy/aFl+mUW2oJUx9U4oA5bS+
	GJ8WxEiDRMRu7JQsPuaZxgoAqMFk120=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 272756187F;
	Thu,  9 Jul 2026 17:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC4B1F00AC4;
	Thu,  9 Jul 2026 17:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618737;
	bh=TflEiF+P3v8r5QgzuLrXTOp/v+oCi2axdEmh9PuAiiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TrJ2jtbRO8wG3jLnTy48C7Y4laN1CbOqa0+9hJCLpLadL0NNNR8AIK1TmJmhrtwxE
	 bfOX48Oj5jN1nQV0YAzZfVpD+MWYQw7ME/PFUvPVUfq8wTxTYUMMW7QtCplM+rTFeE
	 LpZvWpRsWMubDOL5m8w3jEXwlfNOMqSDTzxHf8lknOJJiB1T9UA3WI8y29rTsI7NGh
	 N58AJKteu5aXhZI5rfSRWgAljIUahAR0oldOpBQIhstbvtUysh3vGRp8qEmxJrDVmg
	 8JqgI9W8AdmrnGUUCsSAwTIFO76fshDnCpv0x2rJcwO7WrnQptgWolFCPlE+NJd01J
	 TQ9CQ093zvqQQ==
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
Subject: [PATCH v3 10/21] kho: allow early-boot usage of the KHO radix tree
Date: Thu,  9 Jul 2026 19:37:59 +0200
Message-ID: <20260709173821.429921-11-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 88EBC12000D
X-Stat-Signature: 5ir79hm1rahtopdpi4b8ho5jaxp7p7y6
X-HE-Tag: 1783618738-242094
X-HE-Meta: U2FsdGVkX19Gy9KLnXPPZEEqE95BkuDYzVwimjQ7lvBHUtIqCOZB4WvRqg4NTIOqdiOhLsNXAyUKeyLZBRTXYC3N36AoQcsmeBy/AOoejlitRU/IUq3LP22dJstYsTJczw04AJolMG11S5BFiMF4AqlwgtH/0p60ooAz9P8JpJbo4dbqzeFe1MgM3BOVJSpmneFTLCofSjsFLb41g3kiPXND/babO3j7E3LdGBAedI9kk8Ge20ORyimvyeyEwcx/hKFTtxYEvXFV6vyahhJpTSvcKgVAd9cJSUAm0+VWtD+E1k4CV9hheoPTXdDpIdXA7vi8AkqUSvhTAH3oWI8dDEHG75O67cnwgNA/GL8LoZIMiGQoTwpEGk7FXXM/4PV/vNEcTrAWF6qOqDwLmK5JzURjPPdg2aGD3yC/XDztRWSYeezf29SAibzTAE5ScvNEBCnsvJle+P+qrXZ14d3sJIDp3pWCiPgu7+QMDS1SnxoSuJ8uOC+Tb/aG8wvmZdbQWp2mwll6mDFOowrBdKgqHJfNXjKnKKfRcucqAU6nsbd0rTpfNTHoUqieYGjoN2jbe7tvoPAeDYBSNDxfYhP0xcox7yTXfmdb0JjW7ON5teca5ZdPM4/lOs15YMsTjRJbwHMH65GCq/aQdxJnsty0LRq19VHrHRo46/EEypRgjg/Ck+A/Vj/2xMsDyk/DTWqgcX4J1aVLz4Uf5mGZDQUQuvkvFhD0x7mjIN8PM1JsBhkAEdbBw6MMPjOYEfGXTdWaaDI2AUKxhZj5tpVVv4m7xOGDdE1g+fMXIm19qWYtwaowOQ4HznFFd1a91uCEqDDkhEm35sQOkrDMUllOSNBc0BafraPo12EfDEOUZnl+yhTqDghTrYwirf1orTvcL3Oi6WX+H+l/27L8yxlalES57bzVtdwYZneopzmoV86aZjJmmOyLZgzpYPmfMzGIPMfNNv0oCmGAyhjCrZz2BnW
 BrTrMKSw
 /mx5RzfnRE9YVT2yHlTvNEghVyD2mrFHD8iL/SKkbEXRN24jgugmEUylv69OXpT08dbMOffMgzHLawoY7CA7QQb0wnW6FYzvVYyZZ6+qoRSplrMz0QbUlZD4uAdq8uT2Xk1sqsxPEK6wxmMeS7Jb+VUETyCJT0XVt/J4jyNYahtqcTf1Isxwp2ROoNE0sPemU3DXmbbtTlDNV3j2oXreiHS0C9ozmuAwGzIbB56wYPpmq7c1SGc6kXmu5TGp2DIH8ZUGnL44AE9cQS3cgyDqkq3Cwgd//+HzxwvCG
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
it gets initialized right after buddy so it serves the same practical
purpose.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 3dd26d5d3c09..a5800b960cf6 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -146,6 +146,26 @@ static unsigned long kho_radix_get_table_index(unsigned long key,
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
@@ -194,7 +214,7 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
 		}
 
 		/* Next node is empty, create a new node for it */
-		new_node = (struct kho_radix_node *)get_zeroed_page(GFP_KERNEL);
+		new_node = kho_radix_alloc_node();
 		if (!new_node) {
 			err = -ENOMEM;
 			goto err_free_nodes;
@@ -225,7 +245,7 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
 err_free_nodes:
 	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
 		if (intermediate_nodes[i])
-			free_page((unsigned long)intermediate_nodes[i]);
+			kho_radix_free_node(intermediate_nodes[i]);
 	}
 	if (anchor_node)
 		anchor_node->table[anchor_idx] = 0;
-- 
2.55.0.141.g00534a21ce-goog


