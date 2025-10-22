Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91D6BCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 03:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE7038E000C; Tue, 21 Oct 2025 23:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBE2E8E0002; Tue, 21 Oct 2025 23:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFB128E000C; Tue, 21 Oct 2025 23:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ABB0F8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 23:30:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3DAA35A877
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:30:02 +0000 (UTC)
X-FDA: 84024321444.03.1F08F1D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 37A6040006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:30:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761103800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=CAm5ZGmC8Qsdp70DZ6RKusfWMt/sRA8dfOuFyVV6Bf8=;
	b=FQd4b4n//fyX0vZ0KkZKiHoi/yOLWZPFgbwg12sN8RLNV4NPzaIhe+Kd/xDvtrhf1l/Ilo
	OMLEc0S7lS1BV0zuhceAzv69BBttJFg5e/7WfPD5xvxEvhXcS2GT1JtEbYzCMOHbNvKI+j
	1gVpzA/7xattM3NDzowiuB6DJIh/NnU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761103800; a=rsa-sha256;
	cv=none;
	b=ybMLyezYyP9lXTLyX2GXCQijSwUrGCdDN6HDkzj3lxblpoPHwptoRV7w3V2TFRtveXEZch
	H/4/lm0K+bXaxkr5itEZn+WgSgMaQp9Gx2G9nI+AiW7hfTWM1X+rkS6jXsHfYQVPR0XebG
	527m4KuxlXO/+68B2AIcic64zGVSEiY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CE531063;
	Tue, 21 Oct 2025 20:29:51 -0700 (PDT)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B50563F59E;
	Tue, 21 Oct 2025 20:29:57 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH V2] mm/debug_vm_pgtable: Add [pte|pmd]_mkwrite_novma() tests
Date: Wed, 22 Oct 2025 04:29:51 +0100
Message-Id: <20251022032951.3498553-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ho7img3yzb5jh99thkzgoufm3eqxzdag
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 37A6040006
X-HE-Tag: 1761103800-792604
X-HE-Meta: U2FsdGVkX18t9T8xcVgla+5T6ksWXpqUeOVdEoKVorIk7PFZsnLEvjB5QoZsmUE8l5CvIM61eUEdgKKkb0IEM/zszuDmxPDaHSxvsS5dtYXo4W1QNJHWfLZrGFZ6B5w8GYCeJAGrNtBAvGwBPcLHpq3nQe0Z0U1IdJOcJp266JQxxBL6E7UNo3OPNJnIL1FKuz7kPY9AlQhZEk+RzioyYG7ca+cxFjtJusru/yHs6CBcui+U612x9Rr8nMQbDzW7zvaV5lC/HpN9Nirtd+1Mf93EuyOM7iakJwVnG2YV2674NWqfQPAAcRP5VK5Ek/a1zBmLFjlqutNQbhxc7slLkbZbgTDPwix9Y1hhdn9Vy7PWWLQQydWCv4lFb3g+CWNTkyAGbluRa7QBp0O0C2W9IPXToLMn4PV3nojcXas+l3LxBKK4pW8nA/+I6pKbvob0KlK3GatOg5+mZ/XogKsMa8jmj16ozUowYl2mx40abTAlv89VvETq6Goxnf6mJYq8dPHSWE90a66dJkiaVLWr2tPB7fl8BwGZdj6bTLRByIU4QrFXNt5Grmsyg2Nxog8RNoxxLcftADT4frn46sEoQ39Av47nPkKIUnckNGP8PCpXBawydUrxKSfUF4GWOstyI1Pt+kX5HHNLoUhv7pXWq+nv3+U9IvT2IJ4xV3rGWrJvvqZQmALK1IYLZKpTxNM2IVESnMB5m8qxwFvi9yBFrR4u1N67TODJCxnB+ue4wrkp2AwSBsrvRVARx96ZEExPejhxaPjVe44jJt24eYrx3LSINz5eQOEby7spTGrdMp3IUbqKR9Xprq0lNZLp4rpKOA+P62Cd7vgpnNixeQqJiB/po0edAc8tyhpKt6PskfzV9jr+IB1/f2MS3al2g3Gfq6S0udXtGT8+xJ05KoYDujOG6+e9V/6w9WN52Ze9QopAiZ+KOnDmemH0ittcJRMxXoz/lOjqy+5+Fxvsm6v
 IMiLxaQJ
 SuzkPHOsU9+HbKdX3tRleJAdNdLB+ppTGs2+/v+tK+UTCg2QGC3gSp7rJoYYYfmiORALSw+82b6HRSTWVSEfiQiTYdt2RjDWsBMfp9v3Mn2J4j8gpTHa9p6N5Q7HYVXFgf3u0z/XRyoAVlHNbYwNPdwlxh4y9in8PSwkMvZP0IL9mxbbQMNZCXfEnJcbiSU+wqqBfMiN3hHWbNo2SyNutDy6qz236IkWCo1vXFQLS2/XxK9DSLR5Psm6erH+LfrR/JwbCAlkKJT4SFlyqjdtTGr7Lgb2M7nFnp6su5hDdLtIklQGTk6zHfs/9iUbIemXs1l6wH2E+7GfbyYouOPBinRTUKeldHeyMJomlwoZPfXhtP+AiaG/JZZ3W4me8+4KeLSPt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add some [pte|pmd]_mkwrite_novma() relevant tests.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
These tests clear on arm64 platform after the following recent patch.

https://lore.kernel.org/all/20251015023712.46598-1-ying.huang@linux.alibaba.com/

Changes in V2:

- Added a new test combination per Huang

Changes in V1:

https://lore.kernel.org/all/20251021024424.2390325-1-anshuman.khandual@arm.com/

 mm/debug_vm_pgtable.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 830107b6dd08..def344bb4a32 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -102,6 +102,12 @@ static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
 	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
 	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
 	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
+
+	WARN_ON(!pte_dirty(pte_mkwrite_novma(pte_mkdirty(pte))));
+	WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));
+	WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));
+	WARN_ON(!pte_write(pte_mkwrite_novma(pte_wrprotect(pte))));
+	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite_novma(pte))));
 }
 
 static void __init pte_advanced_tests(struct pgtable_debug_args *args)
@@ -195,6 +201,12 @@ static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
 	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite(pmd, args->vma))));
 	WARN_ON(pmd_dirty(pmd_wrprotect(pmd_mkclean(pmd))));
 	WARN_ON(!pmd_dirty(pmd_wrprotect(pmd_mkdirty(pmd))));
+
+	WARN_ON(pmd_dirty(pmd_mkwrite_novma(pmd_mkclean(pmd))));
+	WARN_ON(!pmd_write(pmd_mkdirty(pmd_mkwrite_novma(pmd))));
+	WARN_ON(!pmd_write(pmd_mkwrite_novma(pmd_wrprotect(pmd))));
+	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite_novma(pmd))));
+
 	/*
 	 * A huge page does not point to next level page table
 	 * entry. Hence this must qualify as pmd_bad().
-- 
2.30.2


