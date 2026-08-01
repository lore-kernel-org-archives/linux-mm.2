Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8879DC5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFB0A6B00A2; Sat,  1 Aug 2026 04:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAB7F6B00A3; Sat,  1 Aug 2026 04:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D73786B00A4; Sat,  1 Aug 2026 04:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9A256B00A2
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6921D40280
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:29 +0000 (UTC)
X-FDA: 85052076858.27.00F8653
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C1F5A40003
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k/5hdvIe";
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fB6QoJtOJWMJKT+tiRLfgRFEUeDku5eshXcZ+GMHx2c=;
	b=l5XdqIxsdgcJJI2c3QWLdGVdd25rNkqSLwk2k3HP08UQEyWFzmvH5DgPzq6gmpi2OaSCf1
	0kudYJNbXNPOskT89/uieKuMWnlj0wDsJ4hedb2pnhWPZAbdUViJeGuySDAjuNDfwm3ky0
	HOpnc6hgFU88oit3OOV9m6P+Vip4/O0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k/5hdvIe";
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574167;
	b=EgAGf5rNUVxiYgZXsLSjWbB0j+Zlg4x9msMG2XuMeuuWBe5cQ50v6hLqP4pnli1YXijrNW
	ApsuAm1Ox+hj8hvlSVFxdZ22YjNyvHofoo5fDzt1ox+WGq13qmMIzkzDhcE51YC6RkaNHI
	KKVuimlrHPhea7PVdZa/UAAaaCtaHqM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D5FC4527B;
	Sat,  1 Aug 2026 08:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39ECA1F00ADE;
	Sat,  1 Aug 2026 08:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574157;
	bh=fB6QoJtOJWMJKT+tiRLfgRFEUeDku5eshXcZ+GMHx2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k/5hdvIeEoz/uifaUAnG8jupHXEQhnD9Zo15v9weL5b539IURBmOQZNahkaICzMae
	 TZIZjDeGNxjBhQ1WcfSIIYF/caM1KifDruuizZr8qOYdrmnVSdWc8+2tzFsw9P3jzb
	 Fa21jbuUXhLg+YUJ97B9qX27sWmgdni6ZcmbnFBhxS76g0CyXJotLM1s82NHPzcMzD
	 lbE+7lvFpqaXLXAw/CpyGth0hS6iVDm4VBGMkAXaiNv4oi3ihPbD/a+2llVonYowwF
	 Mq38xr26vYrGJQ0rSV+rZTU1FqUu8HpdkjuPLuAguv9GqNObek93SB0c0c0adnN/Xz
	 Q6DHEjtZXMxbg==
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
Subject: [PATCH v6 10/22] kho: allow early-boot usage of the KHO radix tree
Date: Sat,  1 Aug 2026 10:48:19 +0200
Message-ID: <20260801084833.1897543-11-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C1F5A40003
X-Stat-Signature: 9pazb5je38mfuywq7hz9abmnpj8aqwio
X-HE-Tag: 1785574167-472958
X-HE-Meta: U2FsdGVkX19X6cszJnylky13EhHKvuFxsxSrV7OM1UiFL0T7b2gYHm3R31rbqOfP6SQjgcHYPu+wVNRj21jIMAn/lNY/PschocQ7GaRKNaQSLMN0cSnTu0NeBDs6xeEyGo4mNzn/O5t3YozC7npOgWuUYgkbDXVmDCvraxnUIXBkTE91lqoNJBL6naGRByIPB94R+Rs7QdRbzJD/e2TprfOCxGDKawtfgShCTiqJzFxHpp4sb3On8NlJN8RaH373AviFqCb1oMif6NedWeaQyyar3GDbbeaXWDbKljKrdNic5bJgdOqbLvMSUEhyWGCdilFHIoOnNOm8wzJilkuT5qBbdPKGpLuLbCuj8gqIczZajaPIh8XyJDujoE1m0beqlZuRsJ0Bi6+uaFaRPneVXahnzuxUCyEgc5gLSk/CNIXZh5puNilXIzHTgoU8q/771HLCIxkCdqyKbutYfwNUuY9+BjlViC3avA6mPFUEPJuRuA7wtdTZ9VFHWsZq2RFnz01ZHqaXA/xMdcUzHUy0BLiUPweBtsw27y0DP3m0OWD27axnIos8Qj5Hscl6MZPejq4DXDDr+OtJKkNILIli5uh5KwJ2vQt4xXvhPr+/WFEDdamST+urTrlyfQuaurJ14XI5omf5pCf3SZqbjj5+ASOMk4EruJ2OsNsbZ1vhcucL0Khs1nYVAxrKulgXNbvNQNfj2FYSATV9wxjOwghaLkGxvBLsg3raLVhewyMTO94Y3MGhFczdN6rpuGs9IDVg6cHs/Gu62EaPZbz5Sk4r09GEko0ZFc5SexA54tsn+MUswK2o6CJkQtRtepcWTY4dHblNieIImPWc10Aqlf2UsWJJLgQcaTfSCbX9j0wawjAayaKaVIL4bml3yGIueRWaAzSonSPET179eaTMYf1VrDqSFKXnlcP11vmMjiexQVU/zxsRAYO2SAbLPkxNyMPPbVfh1o1LIeSZ8BA3fhT
 vn9+Enfa
 5lEZAZ97XyDjVJEHYto3J0O/DwyA10YpW3DwQsVQ29vkzWJ6vEG5ULPmoaRrH1nrP83cFe6d7rfoLqgL3E9CqlP04uqD6cAqvgs6HkB5yp2m/ixzpEWdfJ695zZeQosrt7Hda2hkNE/RhhuSNsIQPFhN9oWAt8qxhpcgtvFNdFbN4Alo+zIgqAc9Yl9DUtoEnmZPgOBcwSWqBa1uMbc8876cbpubc93GJtXG90nkBRBzMfTRfoGow7M7dFm16PIHtT4cM9DaodUNjsraAKnqIDTLbCQCkZg2QWIImpaMqWQ+muhI=
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
2.55.0.571.g244d577d93-goog


