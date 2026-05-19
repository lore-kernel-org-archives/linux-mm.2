Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D087CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 08:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 893AE6B008C; Tue, 19 May 2026 04:58:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8193A6B0092; Tue, 19 May 2026 04:58:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72FA16B0093; Tue, 19 May 2026 04:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 615706B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:58:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E191B120235
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:58:27 +0000 (UTC)
X-FDA: 84783568254.21.A6AB158
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6D94640004
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:58:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=K+nRoIyg;
	spf=pass (imf17.hostedemail.com: domain of liuqiangneo@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=liuqiangneo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779181106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4oATOtiXmQ/yx39W5TsVQjZLt0wrqUXZg1OirMThksQ=;
	b=7DrTqwzsm91bbjvC+BBF98VgiUnnsfq5Ypi/z5T66Gu5mdmzhB4fEhhXgg7OgXx9B/qvuR
	SM2aHTLcpYvUZhmcP5aph18op++R/l7gCcRS2gs09on4BVlRLYYQhj5lRJNszNKi+Ce8W1
	DnmRKkhYxQzvp1Mudnn/hf7tfKKDPMU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779181106; a=rsa-sha256;
	cv=none;
	b=3XKWYqW5cJD2Lz/G3Yi/QgoUFjqJ4xABqJ1r2AVi3/8NEn0CGSiLI8FgBpgifsrlFH0hUX
	8KPxQqJPOmLkZp9WpZDtc8+s3pvMJl8jlF6BVIFtr5MnwmtlKi46s3LR38XmFXa7S5vFgI
	Njvh+4iTr66PDKcKyJ4TZhaGtv4z9rY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=K+nRoIyg;
	spf=pass (imf17.hostedemail.com: domain of liuqiangneo@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=liuqiangneo@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=4o
	ATOtiXmQ/yx39W5TsVQjZLt0wrqUXZg1OirMThksQ=; b=K+nRoIygEMBhZNEdIf
	xLKFHyZaFiHDQNtXhvm8d8ewhPBbN9k0sh3zCZyIoqP41TSIMRVxMg+vtpgrzgLI
	U2rrZLAA3fl+pyCmdIsp+1FMXU/dEX0MasoE9BSPPzU7vKgKveOf315ZjLuAf6EC
	C2qcKHVaSqRb78lATwyNOmPzE=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDnL6YbJgxqAaPICQ--.45653S2;
	Tue, 19 May 2026 16:58:05 +0800 (CST)
From: liuqiangneo@163.com
To: apopple@nvidia.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qiang Liu <liuqiang@kylinos.cn>
Subject: [PATCH v3] lib/test_hmm: Check alloc_page_vma() return value and handle OOM
Date: Tue, 19 May 2026 16:58:00 +0800
Message-ID: <20260519085801.172247-1-liuqiangneo@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnL6YbJgxqAaPICQ--.45653S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxArWxCr4Dur1kKFWrWF1UGFg_yoW5Gr1UpF
	48JwnIkrW3Xr1aqr17J3Wv9w1Skw4fta9rCFnxury8ZrZ8Xry5t3srKF4Fvr13Aayxta1f
	ZF4rtr1UuFn8uaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zE2-e3UUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbC-B4uj2oMJh4bYAAA3m
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6D94640004
X-Rspam-User: 
X-Stat-Signature: ns1fqm1u3entfufdo57bkzh3tkrx9qps
X-HE-Tag: 1779181104-40921
X-HE-Meta: U2FsdGVkX1+HE4kGoVBIoQikEIlPZbUu8bxPQBh7pJjcdfIGDb/7TKm2JLclXXs7OXrK5YuJMzP6Dsd0n+j2uJoiXU7eaQz2j5M72+l+AYTpg4aEKEC2tZEc9GWrHZ0cNoKezQZdqduBYlbI4EjWpTxQUD9Hgtr1cZaqix8W+eIWDrDomZsvjAN7cus818Wp7svn/gzmUEKe3p305m352E6ZDqA6oy7yBjgDRiCWlNtzvnVqr+KMcySr2c02EnUYbAy9qnnFrpTUaafgTt/WLe6SwIdDpnse11TnrUXdayHPmDQ2uwZ6udWYOG4d2TpEQMIpCNF1TB0f4UIS1f7VjRGxTQ/plbpqV430sBF1SmUXl16HNENGTIsjR5cGPNh/BTjo8qzu2ondPCYheHR7SYSABzkkvaVVQyu5gDgx9QGYh7l1J+oCFlUEuXW6bXDjNVvA8Ueafl7e70wHIeFQXWUENJr3AkzGZSQWK9ATbObCCL19YVcXmdQblX3a/6FLjOThzOyUX+LJwMXm81Tr/hMjH8eN/jRJZ3Zte1eOU6qvQoFRLWJ1mx5bgXaI1gh958NbWda5LXrxQdJuHH6K1W4P3uq1zYOFW5vpLf/K0mYFC61N6VzzMacoTuUferujSVjLVSLKJyjiejflq57djj2DXhHTtCcgHe+x55MXpq/R/9EMncmAGLICEHQmX6IeFZfkHXU8JydRRtu2sID2QtkGaI7pi7SmBeN2pnpY6icZrLvchS2RdZvuOlMYQu6OhpVzQrvgsLHbF9HCu9sulMRFzQp3lSQQ+fvjSZgNWg+jlbbS9+lCJI7VptIOBmZaiFXmOIRiBJvwo0g7oaVeXDXGTqz/fJJuwA7KlOWpOL6qb4wCyj2S4uj4+LfT4T/G3/ry0F211wveDkHNpzP8MKbcuExv25SjBBNpYsfG+S98YlQhb+HSWak9nizdJu0TQtzjytY4rn+CyUMr1rd
 JH6MgBuZ
 ml4N/VVUucFErvgRD4uTL5px/0kf5Cmlrg2CXj0IJHzPsZhu6EOIlYUZNyImxcmKHaj6Ajhd2do1EGxJF5PPwhxt/xzCAbQ4We6j44iaGIbLVjydXkdAzL9aH76+8EOb8ac5oYQg2VdU1Bo3ugoc5MDlC7n1IiItuRuFLpTnbsEeOF9904KzuYqVTcrVGoM8goL5cRTXeFBCIfzWhOE8Do9B1him2NCLOAaLE1hFpiUcDW7CVk5wLCyTlvqpE5UptAofs5mL6W7fdbZLM4nmjqGRZoWZjn5+uu8WbrMR5J3O/WGDevL/JTDOw14bGrXq5f6g1cc9021WxjPJbHsh5K7Q3aa5mBfJtaDwmJLKqQ03xSKQwHRs45bdc1IXrNgGUyobKcE1fX+bL53rwitqZ9LwG+E0f8uVeLQd+Madn0xNvDVONpeWwwyQtVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qiang Liu <liuqiang@kylinos.cn>

Check alloc_page_vma() return status for page allocation failures,
free allocated pages and return VM_FAULT_OOM on error.

Handle return codes of dmirror_devmem_fault_alloc_and_copy(),
call migrate_vma_finalize() to remove migration entries
from migrate_vma_setup().

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
---
v3:
- Clear dst[i] to avoid migration in subsequent migrate_vma_pages/finalize() calls
- Handle return codes of dmirror_devmem_fault_alloc_and_copy()
- call migrate_vma_finalize() to remove migration entries from migrate_vma_setup().
v2:
- Add unlock and free allocated pages before return.
- https://lore.kernel.org/all/20260514032345.32256-1-liuqiangneo@163.com/
---
 lib/test_hmm.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 5430ef97bbe0..2d75a49e8e7f 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1063,6 +1063,25 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
 			/* Try with smaller pages if large allocation fails */
 			if (!dpage && order) {
 				dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
+				if (!dpage) {
+					/* Unlock and free pages already allocated. */
+					while (i > 0) {
+						struct page *fpage;
+
+						fpage = migrate_pfn_to_page(dst[--i]);
+						unlock_page(fpage);
+						__free_page(fpage);
+					}
+					/* Clear remaining dst entries to avoid
+					 * migrate_vma_pages/finalize() using
+					 * uninitialized values.
+					 */
+					while (i < (1 << order)) {
+						dst[i] = 0;
+						i++;
+					}
+					return VM_FAULT_OOM;
+				}
 				lock_page(dpage);
 				dst[i] = migrate_pfn(page_to_pfn(dpage));
 				dst_page = pfn_to_page(page_to_pfn(dpage));
@@ -1148,7 +1167,11 @@ static int dmirror_migrate_to_system(struct dmirror *dmirror,
 			goto out;
 
 		pr_debug("Migrating from device mem to sys mem\n");
-		dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
+		ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
+		if (ret) {
+			migrate_vma_finalize(&args);
+			goto out;
+		}
 
 		migrate_vma_pages(&args);
 		cmd->cpages += dmirror_successful_migrated_pages(&args);
@@ -1685,8 +1708,10 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
 	}
 
 	ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
-	if (ret)
+	if (ret) {
+		migrate_vma_finalize(&args);
 		goto err;
+	}
 	migrate_vma_pages(&args);
 	/*
 	 * No device finalize step is needed since
-- 
2.43.0


