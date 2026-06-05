Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E1C9CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 982FF6B009D; Fri,  5 Jun 2026 14:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932CE6B009E; Fri,  5 Jun 2026 14:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D4356B009F; Fri,  5 Jun 2026 14:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 70CBF6B009D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 322A0120273
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:37 +0000 (UTC)
X-FDA: 84846712314.08.60DD915
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 840A916000F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CsY8nuFv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qTphUicBGxw+ljeZ1ORDyDZbANnd1GB5XieWEaaUYI4=;
	b=E+uX91XWFXwLsjyqqBNOfhKW5Cxh9ppdtks0vVI+IcHAcy8UNzKbNXJ7Q6x5jUxhnUr4w4
	k4mUEJZP6dIufL2T5w8ko3Agp3wyxTI6oyjVlydTyH+zWOZ3PmE8XjAzGYV7vveYIEfBXq
	5DQk0EQnsEbWykS27VPrmvPuJDjeEko=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CsY8nuFv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684535;
	b=k9cscBw0nMrqtDunuFRs6CB12TaTHChuWCqcd1aGyDyEFU228FlqlLcZwhwzMOMUOIgZ8r
	f6Widx6DFtfPQ/scRrZpu8nGTw0POEDoZWc5XKqsosM06YGS4/i+5LkxELh1SjDY/xIzMc
	dx2mYsY1XkpjCEm/traSjM9blTrd2S8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD13A4436E;
	Fri,  5 Jun 2026 18:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1E61F00893;
	Fri,  5 Jun 2026 18:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684534;
	bh=qTphUicBGxw+ljeZ1ORDyDZbANnd1GB5XieWEaaUYI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CsY8nuFvQ+DgMmh65ei90bv2MYJd/hBWXIrE9XLIGEI3BzPrS55ccke1KugAEMr2q
	 fsdWabsyi+i/ee4Z8u2T9dKUwYd58AyFTYmr8UnT42taM0KChOZBTjJOdeQQi6jlFC
	 3EsQ31i+xm4ZWUiNYAUZfxIQ9gGyeaX3srtIp1duNND4yxhs38ecdPxADjb0OQ53iW
	 jqRJKAnYn9hBvxXyDSO7OaF5gChGb97hTvdJLZq8vTswF3ve9ZfWZpDjeyMBalUmEq
	 P+h7YcomJuRpKPQ/Np5eVsDVoF2nrAmnq1Wvqelv8Fas9UhoJi+Xw/UPi/z1DMoFtZ
	 ABTaW9NCd4zXQ==
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
Subject: [PATCH v2 09/18] kho: allow early-boot usage of the KHO radix tree
Date: Fri,  5 Jun 2026 20:34:42 +0200
Message-ID: <20260605183501.3884950-10-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: gd8kchw333b77kdztefj5tan65dapcb6
X-Rspamd-Queue-Id: 840A916000F
X-HE-Tag: 1780684535-126013
X-HE-Meta: U2FsdGVkX19Ncd02/7G/VujEfdDh8kxViH8y+9iIJKipW/RjjW2tmdlDUbeB5InjgWfUFDZmoAiS2A5jg+DsGwgNKaR53QxdpQeD1J+G4FkpBw0L9z6NUvocg0Gm4G77eyBCUoTrNm/DJ9BJcJJaBBXkvPDK9K3Yupc0s+NWTY1jUHyDuq7xnH15Og5RQD+sJa7ggHACNsHoKpqO8wMhj/YZdqL7c8ly3WCp8TMYZfzT1wMstwHgZo5e83Oe5iC6xChr5Au5K6qRj3b6N8lcf5hR0XhbvcKPruf4+lrWzjkh8EfFXLlvlbWj+vgtVAFLZn4JMDSwpYwLri9yWLmPI1v+BzctvW8ngTUp+YsKqRMyv6AyDn+zFCHMrifkltTRX2H/0iT3hL+E+BeRAsI8wHwjaKb10saTEDkA7WVlqv17jmlOHCByvuBi2yKsNwmNuY9ow99pFJX8QFqIowsTotnySJ4mbojNw635uPrcoRdqD4begG+0vEqFjhvLKaFUIQg4r0vrYvjfnxI+o/K97gakFOWS++X0XgnpzX4Mm8CQN+XE7I0esrZuOY//KzdSeYO7jCWRhdVdtR3q8LJoU2IYorZKanCUD8Ga3sVVW3BKGrkhUCNNoMcTw87Jw5t6Yit8/zu0HMJwHyKxsfTY5PGkgTw3VyNCqeUnSimvN+EXl+TVoBj1UzuGdh3hWUsQomAoeRHYEy5V71gGx5LKB1HCLsbUgGcfng54QPrh5GHm4nq8SU9tHT6xgobvevlDtLBG7ei9yjCbtrFNeRlfBvGVm2S/WWWBBVI6xI1A6JsgTUACNBZzwRW14SF4Vq1MUYQWX4glvPPXozl+XGdwa5NpbxbhRVbcTifIh3MfNkGzEM4FjTwavjDwVjL7uy7uCbOU8c3KrKp2K7sKv6uo9pNeIBoafmfoUq39O/ItfgbnGbZrqJb8FjJJqc90J6aBfFWMon576AkLpzeAoge
 psQEC5m9
 uwQjQeQW6A3F9IgOFJqLwJTQlBgzLO6ZwzMxU2BF/vHBsdjHstfsXDI1AQwvVSTogrurTgYXUhXxqswN4eSvb5/jdaaYcbmWzXIaUxf8196f613reIbH9nIhs/H49MGUGOT9dAHiEvAUxpPcWxXDG6+l5XOP9Za5fMJhqc0ybB0FaAFV5uieByo85Tb+aU/My99x9DEgFXeiPKeUlMYnW/6c9xl90OVQjYTaap/KVRGSdOjMI7CsqhG10fm2FMB/tshcJ7849FuhMl3qKlUnx1zwU8hx/tOw/WkHE
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
index b890a69bddd5..452b4dcdf2d2 100644
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
@@ -191,7 +211,7 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
 		}
 
 		/* Next node is empty, create a new node for it */
-		new_node = (struct kho_radix_node *)get_zeroed_page(GFP_KERNEL);
+		new_node = kho_radix_alloc_node();
 		if (!new_node) {
 			err = -ENOMEM;
 			goto err_free_nodes;
@@ -222,7 +242,7 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
 err_free_nodes:
 	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
 		if (intermediate_nodes[i])
-			free_page((unsigned long)intermediate_nodes[i]);
+			kho_radix_free_node(intermediate_nodes[i]);
 	}
 	if (anchor_node)
 		anchor_node->table[anchor_idx] = 0;
-- 
2.54.0.1032.g2f8565e1d1-goog


