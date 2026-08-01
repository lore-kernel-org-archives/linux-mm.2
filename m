Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 078DDC5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18E046B00A5; Sat,  1 Aug 2026 04:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13EC06B00A6; Sat,  1 Aug 2026 04:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07BE16B00A7; Sat,  1 Aug 2026 04:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8D956B00A5
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63C7A140264
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:32 +0000 (UTC)
X-FDA: 85052076984.18.7F43FBC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id D07131C0007
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MDndfPJC;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=alL8/OJYh1Qv7+s2wIqZ7R14I5+RKoy6q+9hcJES2KA=;
	b=ftlzCqZNtZGR3HcwxdTKaoB4VjMzs5CeuMS2z0yc61Qu6BQv1Cc6kv+dlFeIc7NxKfPS4R
	yPDD0ZR6thuQ9VlDMHI7EbgJ1lPXyJalSD7tdk2xf4P9x5RkliwLAwk0tkChvPSyG7zToX
	lbsaSkFnMDn7moJYBnos/lJKOr2g3oU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MDndfPJC;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574170;
	b=wpXT7oyPnVvVcYFMfG3bE+xHEz9JmGLboNGJuctZbuOgvZwseUVWZkCahJNpQqg7mw7oBs
	acaoeK8k67WGaVC6hVKJDlr6rZrsGI6dmS5WbktIy+1CrmJT/M+ygC/cjgUeQ2aK3lKbTT
	Y7qZVf9O2n7K6MNE00FT7A6gzdjQjOU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70F3160AA6;
	Sat,  1 Aug 2026 08:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0133D1F00ADB;
	Sat,  1 Aug 2026 08:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574170;
	bh=alL8/OJYh1Qv7+s2wIqZ7R14I5+RKoy6q+9hcJES2KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MDndfPJCluyQBfI6tqVfi2Xf1XL4IwWu256xR2HN691lUocXmV+qzhHSWDle1BXrx
	 cKQu5OVKY2Mxzca45UzvuDFqs87Ancqrve8v+bxirdAWfb7MVGVJIIXJ0owzctpHS3
	 tlHlT+TCgZ+J7HysUziBuXNmxuE8rRaCyHDHBT4XsVAZO4ECMG9cxg6qBvLKYb2P4x
	 xxDpt8c+7CfZEO/v0Fp9EIYbuZ3qiAnO3lVOORQnJYL7/ed2/MgQ2lwVwGz3s0zzcM
	 f8Uu6H/Zoaskptc7WTVLmlh6T3lYJOpFzS+Bj6AxDBF1s6uysUkBlQqs34zid0gCG7
	 EaoARKZOolU5Q==
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
Subject: [PATCH v6 15/22] kho: initialize preserved memory map radix tree earlier
Date: Sat,  1 Aug 2026 10:48:24 +0200
Message-ID: <20260801084833.1897543-16-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D07131C0007
X-Rspam-User: 
X-Stat-Signature: xxng9s83w8uxygsy8pmozffqoecxc8sc
X-Rspamd-Server: rspam04
X-HE-Tag: 1785574170-315513
X-HE-Meta: U2FsdGVkX1+fGzNHj/pBE4RSzi3LtRkBiAnv7gZKXwPqTMqLKF/O1EYdOuUSi0JLTUO+Cn7S6vDhlDP24UDL45qsJvWdPfysegBQ3dghXEDwuQEifKPxBm5cay1hlwiUrpQLcO025Azv/hHOUB7BB/nlbMR7Q+GDnMLjrIWLZSshE6qwsox53PdfbtjC8iZXeQ14piYcXs3jmYk1aTvEjuFs17RLtQR6WsTvMa1J8ThBbBcdye5tyInX/geXKJtcrPksQpgbmpVHr8NYCdGOtLLG2Tmj3xeSHqrMleySltZuajQHYzO/RpOsYY6Q6trUeYwqIlFJ9QkBChxMN7uzy+YeY5K4Ku9zHWfa88naTSXJldCm0IIB4fOC4CaMWQBI94KQf/a/sV9xEAIzMQxqX407tl6MJC0Yq1rDg8q+gMB5gOzvkEpelkV0WbUOCdKcWvPkyPKzR3kcAEj2+vdAgQmuC/TqQa/iJT/uPphugsi7ftFrOZxyQ6jiXn8HK+fehRbMBaHTZZMfK3Gcq8gOoyxQVgcfv5a330JdBmTaaGoGeou5AfjM2wNslmr7/LCsnf+GB1Sw+TqCUuPIfZbyYBzuf4vRpFMYEJaZGjS+QUa+g0ZrSbRhNlVZ+MCe8tK4kiZbjJzHmCzkHqsp7d4xbsd8Uglff8Lss4Rksrz0+kWVupWNAbfuCNvQn3/BeuhuC/4JKjNkB5obx/9V4nUvMKhCEDHo9VO0xEU6F13kv1C+2tYPr5CPiv4tIBQyBh80dXbDACy1ezwuE5wZ+fo74uyLNz7ur1sj8NiJMk9rvRQWkJKaEn46qijXqcaPxZbzsY7zuev7JKGQ1r+DxT+DPp2XWmjPRrCyKNczDOXSFSa7Pcsr3HJpdytEaWBKk48oxiRjU4anOTJHSELZ18E+jNrsNZyzG+ycRy+WckDwlEZ7b5C6Z2m9as0hurNNrwm6KvoFB2mjztVheo0OJTf
 YbOjgGU6
 CHpeK1nIDAZWZ0ublpyDiIlEAgKwpKmxmAQwtvQ1T7J1TLFI97K80xv6KUjL7nrwJzJqf6ajw4nnSbvcQVvSw1P1AN89xc5iy06xgb2fbem1X6O1c69WkbQq+3X8CoJZ4QI5WKjLCZuwLIjST8IU+/D8n4yo2H6ZbY+HZ+Z9fewwaeoYFt/15P5xjdAqtOc6zNIzxB+e3oXqGkoWJ34vq59F+aUC+ihLcvd0ZHd2VFe8ITME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Currently the preserved memory radix tree is initialized from
kho_memory_init(), which happens relatively late in MM init. In a coming
patch, the tree will be used from kho_memory_init_early(). Move the tree
initialization there.

Simplify some of the code in kho_mem_retrieve() by getting rid of the
err variable and jumping to err directly.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 2ddfc804cdf7..6e8682469bd7 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1531,20 +1531,8 @@ static void __init kho_mem_retrieve(void)
 	const struct kho_radix_walk_cb cb = {
 		.leaf = kho_preserved_memory_reserve,
 	};
-	const void *fdt = kho_get_fdt();
-	int err;
 
-	/*
-	 * kho_get_mem_map() should always succeed. If it fails, kho_populate()
-	 * catches that and never sets kho_in.scratch_phys, which stops memory
-	 * retrieval.
-	 */
-	err = kho_radix_init_tree(&kho_in.radix_tree, kho_get_mem_map(fdt));
-	if (err)
-		goto err;
-
-	err = kho_radix_walk_tree(&kho_in.radix_tree, &cb, NULL);
-	if (err)
+	if (kho_radix_walk_tree(&kho_in.radix_tree, &cb, NULL))
 		goto err;
 
 	return;
@@ -1756,6 +1744,8 @@ fs_initcall(kho_init);
 
 void __init kho_memory_init_early(void)
 {
+	const void *fdt = kho_get_fdt();
+
 	if (!is_kho_boot())
 		return;
 
@@ -1765,6 +1755,20 @@ void __init kho_memory_init_early(void)
 	 * early.
 	 */
 	kho_scratch = phys_to_virt(kho_in.scratch_phys);
+
+	/*
+	 * kho_get_mem_map() should always succeed. If it fails, kho_populate()
+	 * catches that and never sets kho_in.fdt_phys.
+	 */
+	if (kho_radix_init_tree(&kho_in.radix_tree, kho_get_mem_map(fdt))) {
+		/*
+		 * Failed to initialize preserved memory radix tree. Clear FDT
+		 * and scratch so KHO users don't treat it as a KHO boot.
+		 */
+		kho_in.fdt_phys = 0;
+		kho_in.scratch_phys = 0;
+		return;
+	}
 }
 
 void __init kho_memory_init(void)
-- 
2.55.0.571.g244d577d93-goog


