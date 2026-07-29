Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B939C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6246B015E; Wed, 29 Jul 2026 10:56:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BDD96B0160; Wed, 29 Jul 2026 10:56:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55E296B0161; Wed, 29 Jul 2026 10:56:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7216B015E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:56:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A00B512068C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:40 +0000 (UTC)
X-FDA: 85042115760.06.D885160
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E10F340010
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eZiJysUw;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785336999;
	b=N23ksuH1HNC5C3ISjLURpsbxzgtuXLK8tv32sLU6bU1BnJqnMaypMD+Pjw9M2NDbSJy+bP
	Ihtc83wDZ+PmtQfhl5vM9C1sNsL1AR3P6LUoMtOViYfu6fWofadpW//VMv8YeMT5/YY2NR
	LilrciP5BWsQu2kzrAILuIAjqmNLzCA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eZiJysUw;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785336999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0oSBVDvJVhrS8ulDeZlNQQxyRW9eRLFb9CyP3FfzZyU=;
	b=B4BGXIEBI+XYIfBRUYt46aW+syASmFa9z4zu1N9ams2E8h7wBxa+Fj/HpBP8/dBm6fZjiE
	zSSqyjoyGdovkZqp4Jlbm2P6t403LaxB8RR6obmXGD7onuJoo/28/bcOK9iQUzQ+5oZdZY
	yMUtTGPK5pFjngLrrgvOh61cAZoVBQM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39136434C6;
	Wed, 29 Jul 2026 14:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81211F00A3A;
	Wed, 29 Jul 2026 14:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785336998;
	bh=0oSBVDvJVhrS8ulDeZlNQQxyRW9eRLFb9CyP3FfzZyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eZiJysUwogklnynCVt8wR3BtC2dUOduHvdoCdY/cT5ZxzeTR7BuquI//AGnwADH7E
	 J8xoxKzIIS59SVEZEM8D3h2XruK+PFkxeGkBv8o9ktM8teqWncAMoWjMdB32pUbTWk
	 1wSkDW4wqYWxlb+ASQsM67wDaUK3FWNcj8mmS7XYc2xmUpEGQrTD0vcaD4r1jj3NAj
	 f8Pz+Y2QrQujD0BQiiKeUTdzPbqG7Y/DU8+d+mBFU3c8qFFNVA4zmWPTJa7GOz4R42
	 YRV8lDVodKYhSctsXEd1VVDFl3q46+bFqCjZxP3OkUT7a0w+AKgSkT2r/sHtSdB5yS
	 U7yyXXY+hlJmQ==
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
Subject: [PATCH v5 06/22] kho: move all memory retrieval logic to kho_mem_retrieve()
Date: Wed, 29 Jul 2026 16:55:51 +0200
Message-ID: <20260729145610.2827231-7-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E10F340010
X-Stat-Signature: yidebb7czwa4e9qxdce4ptnz8q6mogz8
X-Rspam-User: 
X-HE-Tag: 1785336998-861604
X-HE-Meta: U2FsdGVkX18+XL42AoqSe8cgr/emFuG7eriswJll/S4MqzPbjsSIjtXTZqTBK6RSHq3xK9OYf/gG58Mloinliq+lvdQ4TRPAc9cixty2yUEvMNEu2DFutI598NpjMPPlHs/waMFrEC4oN62obYYK8pXzDwsERu491khWzRZEF1HvU6W0GAAr8lmFh4RO0lemUE3XScvEmM+pO5yFZhw9JqgvrSc5asCEbWvhKxxGJJTtN8nbx7MkmoNtfQm8aGOxPapx6R4pEBxofKsgdgzhTPE0aBXU/aQmlDlGCVIDuLqOnUP02whvVlFhe9vO0pUwOdD5eCwRGSS3rnTj33JJfDGnt9IPyc330W60E6+e24OcI+F7LLyW4VFOlVp4eitIGyPw8Xm31R/ELzAT6E2bodxHyT1HuPO4L3m+bxt5EjuNbnL8JLqaBZY3tAcPipsgtxpDljDBfqmq1XL39lxpZ8yyR2mqPL6nAmouXVtY+GnBKAzpqSrOxepVUBlD8/C7kch59a/gwaV+fys5nTstVMKB/2GJZHUlDFrFYJF86JDsb9gL9yI6RTqlYngUxW0l2vtT+N5mtrSDgJjSQBJsVPEapOIrTtR14cplmjP3vunOo+nmCFX/I+DAusiMdwuriCDOIRgYiDAnnOJUSTf6OI/2GHIbP571inEsewPhNUqTONABbKlOxN331pGeU907dN2PDm8CpGh4m+rMHbbjDyDhcfm/J/9k+bgs1VMQOzbcc/+L4QAUf8CMzPRaM6/LLH6NySm7ETCeVLnpXp+EJDzWoqkOlqN7ciZc395Df4/VoRdyfNXFxYkgbHkqNogX4M0F0zmhc1aNFmC+O61ncJG9H0NTc+BTDnZfmP9ZLMfQIg+IxIQyCL26zeMztxRkB8SXqDpD+XeAkgJKMrkMc9O8lNbinE1S/xSHZHAgAIkOmg2sdH1D4DIs9DJQ4G1ZyIRDLsk94eXbgVyF3fW
 KHRbIUt9
 J0zUWzzYpnLhw3hC+r0puAvTgxagzf32GY9zzISu7FQDPjrVJpYLnUkc4vkWgGlrnLx059ACKm6CwUPTmw6B9dN+H7z6jsrqnEJ+9yMxczEzhEt2l+IBvHe01bCDff/xmzKMgJTv37kyWwHVErufP8rKinMyNNbNW/R1vV5UIzd7RpSj557+Q8j5+DkqgyxS6UtmGT+JEDJRpLi27GeDJRMHtZhpMzi48vFQXcuLV3hwUoLx0kBJGrwVQdeVgr14/xYsrB6CanXlL7SBgjrT+/MZIPdx8vTVauZMf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The memory retrieval logic is spread out across kho_mem_retrieve() and
kho_memory_init(). The incoming scratch area is initialized at
kho_memory_init(), and the error handling is done there too.

Consolidate all this logic into kho_mem_retrieve() to make the code
cleaner.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 31 ++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index b53ae68ca087..e3408e1844dc 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1415,8 +1415,13 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size)
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
-static int __init kho_mem_retrieve(const void *fdt)
+static void __init kho_mem_retrieve(void)
 {
+	const void *fdt = kho_get_fdt();
+	int err;
+
+	kho_scratch = phys_to_virt(kho_in.scratch_phys);
+
 	/*
 	 * kho_get_mem_map() should always succeed. If it fails, kho_populate()
 	 * catches that and never sets kho_in.scratch_phys, which stops memory
@@ -1424,8 +1429,16 @@ static int __init kho_mem_retrieve(const void *fdt)
 	 */
 	kho_in.radix_tree.root = kho_get_mem_map(fdt);
 	mutex_init(&kho_in.radix_tree.lock);
-	return kho_radix_walk_tree(&kho_in.radix_tree,
-				   kho_preserved_memory_reserve);
+
+	err = kho_radix_walk_tree(&kho_in.radix_tree, kho_preserved_memory_reserve);
+	if (err) {
+		/*
+		 * Failed to initialize preserved memory. Clear FDT and radix
+		 * so KHO users don't treat it as a KHO boot.
+		 */
+		kho_in.fdt_phys = 0;
+		kho_in.radix_tree.root = NULL;
+	}
 }
 
 static __init int kho_out_fdt_setup(void)
@@ -1629,16 +1642,10 @@ fs_initcall(kho_init);
 
 void __init kho_memory_init(void)
 {
-	if (kho_in.scratch_phys) {
-		kho_scratch = phys_to_virt(kho_in.scratch_phys);
-
-		if (kho_mem_retrieve(kho_get_fdt())) {
-			kho_in.fdt_phys = 0;
-			kho_in.radix_tree.root = NULL;
-		}
-	} else {
+	if (kho_in.scratch_phys)
+		kho_mem_retrieve();
+	else
 		kho_reserve_scratch();
-	}
 }
 
 void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
-- 
2.55.0.508.g3f0d502094-goog


