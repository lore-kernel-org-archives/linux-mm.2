Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B500C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75B8A6B0166; Wed, 29 Jul 2026 10:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70B3C6B0168; Wed, 29 Jul 2026 10:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 622976B0169; Wed, 29 Jul 2026 10:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 369486B0166
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:56:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE579406C7
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:50 +0000 (UTC)
X-FDA: 85042116180.05.DC5891A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2091E40010
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a3Wq3fbA;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337009;
	b=Bws42fAEEYWzJ6x/0PmRSSPFDyqahXH0gKILL5wn1bt95eLo1e9LKfeKv72NKBXvRKBHbk
	auPiV4TJwdjZNrGNJDV7LJkNlgY0a3bcDIDboEC7IkWpFjaF08r5btg3OAgwKFviFkbv92
	OQM8SiOAfvG1qBTmw8vIWVmrpzFtvO0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a3Wq3fbA;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mXuLDpqxEzsTVqRkllpf/CYrSLOw6JAQtw3S3O6zV18=;
	b=1C/IbFhQ0VWgnnW7w6yCXIuxlPIPhjUigeU541U0BjkGwY3+pxzZwP54pEXKlp2u0eIS1n
	ZM5MVleZpp571BWz0n5Fq471Tbg3ICX1ggOXUGWq7qIBH5xDaGuLnYB6ZQnNLIWN76i/Kb
	k/bhWqhLMSEMUmxQB3Y1ciMEg0uw02g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71A3740828;
	Wed, 29 Jul 2026 14:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3F51F00A3A;
	Wed, 29 Jul 2026 14:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337008;
	bh=mXuLDpqxEzsTVqRkllpf/CYrSLOw6JAQtw3S3O6zV18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a3Wq3fbA3msZlr9w2Ldc/c68YoJ4udpB6juRL4k+zMwrwIJLuhsvPcHAyYuKslP0O
	 pfn9AzhjrAJJutxcixriuE7y26wF7iQx6Rt3AezUvY+gLyS9T52HHeI7uNl7BlkKfF
	 IMo2MNLosTgS8YsN5vNzH11Qz5qEwzT3WW1UjY3D7mTGpCTVGZldfLuqNJ884oV1YE
	 0+LqtiK06BVGxzkw57nzdEYwBpbm6fU66egKj04jbDX5XQxZEsyFElmyy9Vtahnhbm
	 CI3lUGbGOJmuJJH8gXR7CJuofEziok2H1jjwrZna9H+0FsmpqVVFKCbb8PD9/R2I5i
	 GZYN3qvZ+clCA==
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
Subject: [PATCH v5 10/22] kho: allow early-boot usage of the KHO radix tree
Date: Wed, 29 Jul 2026 16:55:55 +0200
Message-ID: <20260729145610.2827231-11-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2091E40010
X-Stat-Signature: b3mftag6o8wjoe5pkj3hhib95d1ruqp9
X-Rspam-User: 
X-HE-Tag: 1785337008-663156
X-HE-Meta: U2FsdGVkX1+W6W/RGzKXLZ+9XfuoA3G4D2yVr6V1BdmzI58DXUoTxGmT1xT7XOSIL2EpnMSux45p2AlMM//Q5BOi7487vfhYmIhO6tONzDAxlBiuQtV1l8EzjdwzZVfuaFSRX2c3/JpxhR9t1iMY3+9fA9pgEvtLUxA8XkkupYlptXZFfdXB/edQB8Z/7U1LvNT9ioFKneWgDJVtl43iRWJ0jgp5ujsseiffQEtNBYdoAQ5ITKEURPq7bFhl560OBus9suoIS/TILFvIu8Qk4qYLurmfvmjrCyYxwh6H2EQ5ONcicRMdBdg3hgLZeY4G1+ZAIynSAQRLqrMuOR9S3KtMHC/TUmrOebyAPfj292P/Vk478RKkcEwthOBqfJMB9zT/j+Au6QBFEA10aqYcaaSnmaCLUV+oQX19+mcILXzl1nESVrRHNl0JmUgEf0os2LxYXLjDPnOij19BGXqDokqubOKxnCbSOYYEsnXsvVnTBtSBDnHt0FDpENCXJOIK6YGVnwkGVjLK7FYuV49ErpNCBcpbCCcssCPlznf6xxFJ+0lgVCCyQ3J6cWsp3oF5fT6q9Fqq66JYg7Ln8aJ6QV3nSo/Yp9wSBmuj4Ogn2em67XvzFle8kVLZpwoq81TZucrUuVz3mriW6hDRD2wSX2JtAqqC9iHuYoNSsYwzd+4Ih50cKZWGAwKn3wOOJfj5NJ9+0WT3LA+ODXFpqOUCLhA9AZ6A/NVCNP3sv9/eT7f4yfOMSuHdbM6IxdBO0rjgeTvcyPi4k/cINpeMELdkneNit+BLseHlOgBTxmZ4QeeSRhi6TU0Sx8fz5Ui1W2+S65qwvufr3VBnWThhc+iDA26ehzQwpDDOOdfD1eXWPq7Y1VnL6spqssIIdMcW6wdPKS0an91N97LM5lANRTcdB4i770xph9h/wWaNawZN5RHhdz9zDd/NSNMJtVwsUEPdexoYdUGqtTk9A3gJnVI
 8/sSzS8p
 L8txjN/ueFB/hTHHRCgcB7neWQu29AkU2j9cC7rt/ipSIee2Q9X8/RSA8HjpV0GaFjjOClVT5YugBK37+2sl9tYlMoALJ9OMUluCr6ZAc91VhQsCvvpmUEyDbNZEf8sEYnv3zTOYtaU8hZxJZ9Ot3BCjGQ67M12MvdY0IwzXR4bW/fqYE1v6zMPxj6HTH4TT3loLLtlgsvXHgDIciSpk3OXLuhHo40AWzQ6gYRi63QAlNA5OoCE4iDcAGGLMzxAlDkxQ78M4h2cxhW2NR4dITDiYHqtCTupX3aaC4
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
2.55.0.508.g3f0d502094-goog


