Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC597C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C866B00C6; Tue,  7 Jul 2026 23:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04286B00C8; Tue,  7 Jul 2026 23:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19AE6B00C9; Tue,  7 Jul 2026 23:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72E586B00C6
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4A361C838E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:48 +0000 (UTC)
X-FDA: 84964134696.10.27BAF5B
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2A3A116000B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BaYmVBgT;
	spf=pass (imf08.hostedemail.com: domain of 38b9NagoKCAIlvjqwijvqpiqqing.eqonkpwz-oomxcem.qti@flex--jthoughton.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=38b9NagoKCAIlvjqwijvqpiqqing.eqonkpwz-oomxcem.qti@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9tYhyFlDTzE/YH6OeWF1FZ4zpUrrudSRzFbgqClNVeE=;
	b=iLvWsOFJVa0MoczbjXwb/z2rgbJcwO8JFa2s7N5C6Xj7W6ZeC5vqQfg23ijJ7IiqXso5uR
	ROuwNdQwrkJjQOoRWLoadaNZd2TjdfputxpTyCDApbkRWsIG7bkAnCFGe7L+wDUa0LtOZ6
	/AhRWF1zsgVJsYOuCiho5m7agwegKSQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BaYmVBgT;
	spf=pass (imf08.hostedemail.com: domain of 38b9NagoKCAIlvjqwijvqpiqqing.eqonkpwz-oomxcem.qti@flex--jthoughton.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=38b9NagoKCAIlvjqwijvqpiqqing.eqonkpwz-oomxcem.qti@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480307;
	b=1O+lnxE/gp1ppNdN/74DxX47PAj8A2bzooE4Jf8gduZ/ujAGAtoTyghm1Dz2F6L1eR1vTa
	S9Ynz/BYarCiO/D/gFU3y7vi5QZ1dZsOXGg1M2+NhasHvgVRFdR1WDPa4CO57n8i3Rm5ME
	hNmpJ/xOBhCqkbMjaaYbE7ewTN+X2is=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-847ad67cc51so229745b3a.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480306; x=1784085106; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9tYhyFlDTzE/YH6OeWF1FZ4zpUrrudSRzFbgqClNVeE=;
        b=BaYmVBgT5kbgLYu77juvyf/u5GnzLUeC3G7Zjgulv+J1bkwbzkiaFw57dJGVhUn+Hc
         09g/RzjJO7tKANEcO2Ux5DVUFanQn745hvgF7TyvTQR+B4Kl/fH9Bgy1AkwIKo+7p1Yx
         V1lPFDjGKlNMHr0tF76GE9qwPEWazXYKbPVrDW3qj5YFiBdYBvJO6DTi+PyZvlhAy0qD
         etRT0reCweSxZrhAqS2LOMXUBw6a5TYx/A+Rsw/g1Vpvx9jir7bKD+57Y4R2UolG9paC
         yirQA6pKpFqK97A7Iew8LwDoXzExUkgiNLfKvGPfEf2M+I1WL//lHyaFKuJX3xCRdEGR
         1gQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480306; x=1784085106;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9tYhyFlDTzE/YH6OeWF1FZ4zpUrrudSRzFbgqClNVeE=;
        b=WkKaVmVV4wkPWPm9U5J6tA3d9lwsYjUH+OBuR+/z3yqPwj3Rl49gBhILEs9RxKwxAQ
         6jaBhD/jhGK2rG1l474erlcJXDj72rBGGv0VU4gEhrwvnUp/lf/uOfTxocOoX+77MJPO
         0QwEfVpGeoGfLgyy0lPcPlvkArxdvtY6Bf/UmFVotfvZP84z021oqXVwbvHWVJD9QkLg
         rAv9OQGoj2iARhbCqsohzP5wLNWkHtYJtAhFPf6tiBX4mo1Fz0wdTL2+ociasiI9e4Te
         BY3zeVqAy+JUqp7wfXq2giSJxdFxYKZNahId9H+Kuhmf9hqxd9jTARP8ALOJcFbr3J+F
         zopA==
X-Forwarded-Encrypted: i=1; AHgh+Rr0LiyNFgOk541nAUvXuCckR4qcvrxybRSAj9lZ1ObRSsBTIE5DnOretT3mrF/1Avy/Cp9OSP1yJg==@kvack.org
X-Gm-Message-State: AOJu0YxdXR/x2ON0HiJxSijvFPdFbL1mC4auYKzQYcn+eXA5n68tPKQP
	E98oGBYm4ji/CyQluAbpknWnMNoptgzguG8V9hZhh7/GCpxkdCEC7DhA5S9bqhOKj1rO85acNLg
	Yez8PKeeaKD1r6Sy6ib51Ig==
X-Received: from pfx50.prod.google.com ([2002:a05:6a00:a472:b0:846:f544:63be])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2294:b0:845:388b:56f with SMTP id d2e1a72fcca58-84842f9f250mr639122b3a.40.1783480305691;
 Tue, 07 Jul 2026 20:11:45 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:24 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-15-jthoughton@google.com>
Subject: [PATCH 14/18] hugetlb_vmemmap: Rename mm/hugetlb_vmemmap.h to mm/hugetlb_vmemmap_internal.h
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2A3A116000B
X-Stat-Signature: x13sr4ryh1783qggi9d8rmwwj9cq7iqi
X-HE-Tag: 1783480307-686370
X-HE-Meta: U2FsdGVkX1++i4BjxTm2U2bA8nReo/WrfFQ8e+fR7w0zBa6Mnkdr4j9f/6qtRIQSccA5KYK6ZWh01cr2Zm87WFte3zk2OOxO6UiMDJvDQUYGcz68O+V6SPnA/X2XITZ39u203B3cNT6V/nyvT1R9Cd3WGMk5dgG/ItLmcDUwHzQSelW5DJEdMdyBhxJ/OFQObN2OByNcvBCgMRROaTfI9Q8NnFo+mBkk/gWqqhdTSFAPIbtdiir/IeLJmsgMxrRbTLSfkrrSzADazCofko9N8dBx5AcYE4hm8+q/vcVlWcOQfgt92OkjRa1qIINHUaBZgWWyPpJAC+n0yGcl5BeMWs3/6lvlOQTdDc3T7H3PUmsNCTWZuzPjkmxwUVJLnNzfc6AyvnvzLcqfLY2hz201zIery2lCZCbn13amZpSldHrMg2j2x1LHZERAHxocunA4Y73NCSd+18xrdGThQqv3+kS5tLsRizVfj4agssPvz9JBClAg4lQ012tQE2R3QSEQlSUDuH6MuqOkaUv7LgCfhaKsJsyOuJmxs4SpVO3NCITyBZVpdBDF3JfBBRfaojpjRD/bRatOJG9nLu/0ChPlQTZ4x7Ye2PPC7gk9xVBGuPkXS2aBYkgENiOZbvUjFnDJhPwFqqxWH0ztFoIMr/mx1Qv4VfNG1jnp04OCgRtIVZOx80n7ZqHoll+urVwT1aogNFKGuU5gTJzw9/+Em4PowKS0Mwe1gwGdVMXzsVfKl1K2m04K/WfdpkOEBYXcX6gVAzo4FPUFTrXv6/PJx93nUPfjmh6zNf3Ck5sfWGhwJ8DEY/OyVQZewco4G81By8eh4fU8vm1/NgdIrK0iryAu8qgbpHeJBLdY2+3fY6Sp5rb/+4E+IscVnAAnXPvu68Lqdayg7rf42nSEI7L5nd2aaRWzl2utPyuowmwVbSUgWvYCNh2dBIeMOjWVrD89BrQ504dcKbBDKT4izO7nDS7
 cBVipCqA
 VFgVkXbu4wwp87yw+7ejrUB2hOOTeFZYYt2/J63OmUgw8OEzPGZ/aAsevXKvkwmOTF+ORCS/UWLqSKwwLU3ItPYyUrJeRH5nuf8A3XSBTSchOmWA5nhXXJhBVUcjBgWGbo/rLW1vYtQo/6ZcThOfYblYvLT3slhDNoA5W0T/r3HC/GfDtZcxtWlY1HwiyyRzP1C9vfgVOm5HQIS7HvkYi1ZCLZJzbgg9iOUey3rFUZFyWikMXzWHPU4VuLgz4OEPNXzDzre10OR1qdl3yFMFj+Yx4Ixa3Jq7iFvWs/FZg65CfKOvUdeZXDOfQNsSKC0C5B3G+/ASaFCGGlhAcBNUr27R7ZD9c/fW02ykrU119udx0lGsgUvbAR/c1uoqPHYk+0Kckva8yr54QX7NvYBdmCqx336jPD0Gg5p0zUQhoAR49+3jd1vR+Q9MYVoqFP82E76iSt1zLs1SldyGXfIeNmGLq1nAFJ9G/FpDdUQB9F+8SWuOPrjih4oacUmJ1GcmOYHVVFZHK3xWjbdZe2gUOFeNvgl05Yg3F3i49a8duAiD1nxSUwSjUXRlPjBEYDQePxQGFt2erC/NN0g2ysHqhIf3DZpBr0ZHTpUojLG68OKKhKYpvBmcOWDwLa2PwxsokPoINbaD7aJn2UvTHnHgVSfof9g2ppYfFbT384JziV1DxTUAHAf8wWOXNXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This avoids the confusion with the new header that will be added in late
commit, at include/linux/hugetlb_vmemmap.h.

The file rename in this patch isn't really required, but the header
guard (now named _MM_HUGETLB_VMEMMAP_INTERNAL_H) does need a rename.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 MAINTAINERS                                          | 2 +-
 mm/hugetlb.c                                         | 2 +-
 mm/hugetlb_sysfs.c                                   | 2 +-
 mm/hugetlb_vmemmap.c                                 | 4 ++--
 mm/{hugetlb_vmemmap.h => hugetlb_vmemmap_internal.h} | 6 +++---
 mm/sparse-vmemmap.c                                  | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)
 rename mm/{hugetlb_vmemmap.h => hugetlb_vmemmap_internal.h} (95%)

diff --git a/MAINTAINERS b/MAINTAINERS
index f37a81950e25..ff47013ce995 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12021,7 +12021,7 @@ F:	mm/hugetlb_cma.h
 F:	mm/hugetlb_sysctl.c
 F:	mm/hugetlb_sysfs.c
 F:	mm/hugetlb_vmemmap.c
-F:	mm/hugetlb_vmemmap.h
+F:	mm/hugetlb_vmemmap_internal.h
 F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c
 
 HVA ST MEDIA DRIVER
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..298673a6c57c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -47,7 +47,7 @@
 #include <linux/node.h>
 #include <linux/page_owner.h>
 #include "internal.h"
-#include "hugetlb_vmemmap.h"
+#include "hugetlb_vmemmap_internal.h"
 #include "hugetlb_cma.h"
 #include "hugetlb_internal.h"
 #include <linux/page-isolation.h>
diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index 79ece91406bf..83a95f5142f5 100644
--- a/mm/hugetlb_sysfs.c
+++ b/mm/hugetlb_sysfs.c
@@ -8,7 +8,7 @@
 #include <linux/page_owner.h>
 #include <linux/page-isolation.h>
 
-#include "hugetlb_vmemmap.h"
+#include "hugetlb_vmemmap_internal.h"
 #include "hugetlb_internal.h"
 
 #define HSTATE_ATTR_RO(_name) \
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index b445febac0d2..a490a34998d9 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -16,10 +16,10 @@
 #include <linux/mmdebug.h>
 #include <linux/pagewalk.h>
 #include <linux/pgalloc.h>
+#include <linux/hugetlb.h>
 
-#include "linux/hugetlb.h"
 #include <asm/tlbflush.h>
-#include "hugetlb_vmemmap.h"
+#include "hugetlb_vmemmap_internal.h"
 #include "internal.h"
 
 /**
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap_internal.h
similarity index 95%
rename from mm/hugetlb_vmemmap.h
rename to mm/hugetlb_vmemmap_internal.h
index 18b490825215..6b28780014bc 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap_internal.h
@@ -6,8 +6,8 @@
  *
  *     Author: Muchun Song <songmuchun@bytedance.com>
  */
-#ifndef _LINUX_HUGETLB_VMEMMAP_H
-#define _LINUX_HUGETLB_VMEMMAP_H
+#ifndef _MM_HUGETLB_VMEMMAP_INTERNAL_H
+#define _MM_HUGETLB_VMEMMAP_INTERNAL_H
 #include <linux/hugetlb.h>
 #include <linux/io.h>
 #include <linux/memblock.h>
@@ -95,4 +95,4 @@ static inline bool hugetlb_vmemmap_optimizable(const struct hstate *h)
 {
 	return hugetlb_vmemmap_optimizable_size(h) != 0;
 }
-#endif /* _LINUX_HUGETLB_VMEMMAP_H */
+#endif /* _MM_HUGETLB_VMEMMAP_INTERNAL_H */
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 99e2be39671b..94d5da9f8ab7 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -32,7 +32,7 @@
 #include <asm/dma.h>
 #include <asm/tlbflush.h>
 
-#include "hugetlb_vmemmap.h"
+#include "hugetlb_vmemmap_internal.h"
 
 /*
  * Flags for vmemmap_populate_range and friends.
-- 
2.55.0.795.g602f6c329a-goog


