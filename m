Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBD1CC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A73F6B0096; Wed,  2 Sep 2026 02:15:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5316E6B0098; Wed,  2 Sep 2026 02:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 384516B0099; Wed,  2 Sep 2026 02:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4956B0096
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:15:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F08340710
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:15:43 +0000 (UTC)
X-FDA: 85167810966.12.42210E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id D396CC0005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:15:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G85a2JdO;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788329741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JMHG+THezrVqv+LxM1LlqqUzwwh90wkGAEXs+OQ+QKU=;
	b=q4eq0mTflpuR640tYrKjecChm2eGtgbJ6VlcHHvkfUiWbhCjXekjxiUnfkFiXFl9ckfKM1
	G8/OxSRi+qci2c2XP3zFDKQH7IKfDhkSEg9Yu5TPaOoViSYY0X1HAFtGZzckYbg47mGGyg
	BrLxOzQjhCQitcTKWZX3KyN8v9gW8LI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788329741;
	b=2YPRCKGtxGW/mfKwlk6G6Vko25qdvF4Q4ofOerDVngZPAEvysfQWZ5PKkBJwL92qdgCXPV
	YJ8ocgca4BQV9V6/FmXbPe7i+MLANHZsZRoR86YXibfzABSQx5eItYhPrKhjmUqlOho64q
	04qK+rE5/3PkCVP6WnCVzpTC15BDrpU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G85a2JdO;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3701D43C3C;
	Wed,  2 Sep 2026 06:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17D11F00A3A;
	Wed,  2 Sep 2026 06:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788329741;
	bh=JMHG+THezrVqv+LxM1LlqqUzwwh90wkGAEXs+OQ+QKU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=G85a2JdOCh9i7kPV4oxSIFO3tRpnuXjL1+Hkbcz/GdOjbU+cATqvnUEkvo+HovQFS
	 mDAzWVrbtoC2INqMSDc5cVraa5h+T8JwuKw8CFCVCv4kC99pg5ZSdTINyqVGt7mO8T
	 vpktFiYmdzQe6eB+Ea7sfDCe1iPmcTKYvXmQ/EvrslTcD3T5Y7o5ZdCJmAXOPR5nTz
	 PAGU1hcL9SqAe6Fkit46TtmSyAZOG6CbPSDHIwih9DekxMjW2G+sf4bHSDG85j1cI8
	 MGqs2jB1aBYz995A+yEML7RoaZgubgy92NM7kGvNO9htDihdnaOyYpoNzZVlqfRlLq
	 h3DYFXRms4igQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 02 Sep 2026 09:15:15 +0300
Subject: [PATCH 3/4] KVM: s390: Replace get_zeroed_page() with kzalloc()
 for the GIB
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-s390-kvm-v1-3-3bc0986550b1@kernel.org>
References: <20260902-s390-kvm-v1-0-3bc0986550b1@kernel.org>
In-Reply-To: <20260902-s390-kvm-v1-0-3bc0986550b1@kernel.org>
To: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, Sven Schnelle <svens@linux.ibm.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-s390@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D396CC0005
X-Stat-Signature: konj33crqtdfb7wpmc9cmrwcnmyrcijr
X-HE-Tag: 1788329741-809664
X-HE-Meta: U2FsdGVkX1+HGX3N0UQXzHzNQLffkLXE7HjcsUP13djmA6Q5KsF63ExyJEGFL7Ru7ICFsiYmqQnRtYFWW7UxNuYaoPfwETxjFNPAmzIg0Tq+rnD23RaESc4Z9b+91d7tEGle5U3nLmSV/Z1QEkFLxf6ZMmYhRsncUotjIGrdY0n686kmayh3XqAjRotIDb0sYIttAgBZ4/QECJ3/oIWbxFqWVvh45MW4+8OQj6aP0Hj2RvGAm0N8NsZ8eZEzma6sexHwNC/Pkdpm20ga2CvMDr0g3iYvSLFRq/FJvT37HGOaeEipFMGbKTBB91n00E8dlhEX/ADWkkdXdMtJJjgHwTwwvcnzfdcjUnJ8GVPjpuQcMpdMx1yeYakEs45zyuATSBNzBBEDwuMq7QGKmwpcpBVXd+OSOdldAlC5aTGvu3tnv2cRRV4InINH1u97vD7ESEkezpARh3jsqikMWpnJBWZ0JG7RmqIXpLmpsYmWvIdVrPZNtczYLea8CKsQMt1PP/EDe69xQvvS27GIVeMjj2kgcWQc643kRP4r+GI7jBxH2WE450iKrw00miqlaOKpocl+GCkLhzgmDu+sxuluf9t/ffgQv4vOLYf82FEmfQflLdgVULh9/IxgehPwNEnfXsoy6grzzTyETON6xsQZRE3iAR64/OcBX37MKG0ecpyyBNF8PwD5+XE0p3gGJJGG2Eu1sluCVJfF6IFAsymKomN8iqU27DFS5ncR303loAOD9pXvQL/PsddujTfWKSSorkiLBvGxnbHtJAyxm3yuNjcx5uRfSlq/w6RmaikuR1PijN3q+SM1uuRNkkEJ1K0ojT6VNNyk5S8cgwnQnEPQ2ecMPYwjA75vhW8zJolRn8NrWiJhlxht8Ub4TxKeROanHvKaXzW43Foir+MH41cYZWOHBJOvQfMzLmOglEM2V8aRjRxb/9Ve3RdtRthHWo8IiiEwP5kQYplPaPIl8hs
 MLf7iEOO
 MvzXap2saaNL6N9Agf0q9jbYBjPXg7yHXKy7aYhMo5LuLArxmfU88oNapusGXmmp2glRQw1iIhk6Rx1SGSZ/Tm3d/wj9YrMt65MZ3gNKcK9EvVtXazNMVwzXQ6VO1mA+QX/yWZnBHCnIlxnt+JL5Hn/IvJN03P89CuMijDO6bzHrPpmcoTEHs94qju/btD83Iif2yy/hqNyTY7JLN/x33eIwUxXzpYYYRjh+QJvIunDqcVg1xK4LDyAIoBXESuLTrZlBee1E15td62YaR5YoPOU5xes1tGjZAJ2k29uw6wZrOTnv8Zhl/zjlvqHot4L6Q4TNY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kvm_s390_gib_init() allocates the guest information block (GIB). The GIB
is passed to the hardware as a physical address and must be page aligned.

kmalloc() guarantees that a power of two sized allocation is aligned to
its size, so a PAGE_SIZE allocation is page aligned as well.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/s390/kvm/s390/interrupt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/s390/interrupt.c b/arch/s390/kvm/s390/interrupt.c
index 0381ae9817035..02065fb8d053e 100644
--- a/arch/s390/kvm/s390/interrupt.c
+++ b/arch/s390/kvm/s390/interrupt.c
@@ -3689,7 +3689,7 @@ void kvm_s390_gib_destroy(void)
 	}
 	chsc_sgib(0);
 	unregister_adapter_interrupt(&gib_alert_irq);
-	free_page((unsigned long)gib);
+	kfree(gib);
 	gib = NULL;
 }
 
@@ -3703,7 +3703,7 @@ int __init kvm_s390_gib_init(u8 nisc)
 		goto out;
 	}
 
-	gib = (struct kvm_s390_gib *)get_zeroed_page(GFP_KERNEL_ACCOUNT | GFP_DMA);
+	gib = kzalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT | GFP_DMA);
 	if (!gib) {
 		rc = -ENOMEM;
 		goto out;
@@ -3722,7 +3722,7 @@ int __init kvm_s390_gib_init(u8 nisc)
 	gib_origin = virt_to_phys(gib);
 	if (chsc_sgib(gib_origin)) {
 		pr_err("Associating the GIB with the AIV facility failed\n");
-		free_page((unsigned long)gib);
+		kfree(gib);
 		gib = NULL;
 		rc = -EIO;
 		goto out_unreg_gal;
@@ -3742,7 +3742,7 @@ int __init kvm_s390_gib_init(u8 nisc)
 out_unreg_gal:
 	unregister_adapter_interrupt(&gib_alert_irq);
 out_free_gib:
-	free_page((unsigned long)gib);
+	kfree(gib);
 	gib = NULL;
 out:
 	return rc;

-- 
2.53.0


