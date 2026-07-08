Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F2B8C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A9FE6B00C8; Tue,  7 Jul 2026 23:11:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9897A6B00CA; Tue,  7 Jul 2026 23:11:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849486B00CB; Tue,  7 Jul 2026 23:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8A46B00C8
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A414EC3E49
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:49 +0000 (UTC)
X-FDA: 84964134738.22.47CFDC4
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf01.hostedemail.com (Postfix) with ESMTP id E4FC040009
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b5NYifDE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 38r9NagoKCAMmwkrxjkwrqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jthoughton.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=38r9NagoKCAMmwkrxjkwrqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7DxyegdDTBkuws1o4l0mkPGvs9ZTLGu40cJligZL/Yo=;
	b=T6Zbp69RjxCWMxMuNDAAzY7z72d2LQnSB+DvEBiwQ6CrSlG3+u2ZNnlGZji1eOd0RU73an
	Pz3JKEDDef67MBPAlkVZRpXU87+hesGWbXLDtsUQDgbbn5umRShpCDl6qCEixgM37xZIFo
	Rmool5872bXJmI7w/O1IOO3hHTAJnvI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b5NYifDE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 38r9NagoKCAMmwkrxjkwrqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jthoughton.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=38r9NagoKCAMmwkrxjkwrqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480307;
	b=f4q16kPfx4zjpFDIqrDKBGVbt86U6iWaxLlAnW4+rDZJI9zKQ//P8YaSRrhseqQZSWN4bs
	2CI/7/kYc93gqvigJXZZMfTzsfVrGwwUw7zv3LNcJwfwXUIEaXy9c5tQseR1wn1M2EriUf
	0/xLAvDvmrIo+Q3J0hkgFzNJiBRUYvc=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ca5d2474c7so9176055ad.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480307; x=1784085107; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7DxyegdDTBkuws1o4l0mkPGvs9ZTLGu40cJligZL/Yo=;
        b=b5NYifDEzMn+c8aAKEoQYYJf00pkAtXT/Ni+sVaj+X8Dsa6Ka1v7wp2vv9+sboL1A7
         4Z+GfNYvzrAltaSL4gUx/iBM6ssUD4njj7S5+kZJ+vPe/BYTlr1Dudy+wNMZcVneaM5P
         ydVg3E1ZHiXH44jdyVjcgXlg30DX3wwf3DZTVxQyyYgdjypARaO2i+ykJr0Pa8K/aASw
         fK+S/7DJq+FGclk3XZ21Cc8ooD9KFIOKize1eaNRU2D8xr55fkfeEvntS0Z0gVjgxMXw
         4p0qaITBOtlw++Z2XAtpRLS4GfyLlE8HdPr4kTU78wOunfFlYZ9K/f2cGJaqG7pBvfpS
         Pelg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480307; x=1784085107;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7DxyegdDTBkuws1o4l0mkPGvs9ZTLGu40cJligZL/Yo=;
        b=ejfrRNNM90WYSfdc55Jo/kpvDISSZ/LJdKWz+uV4AK4c3CDHxnU5VuZFAEwC8wW2Rk
         W8uw/6054Ni9cxDkiQnBdwhAZYGl3wKHvY6L1GwvDc18QI1wvGMxyyhSbkhWEHhiXgX6
         lHS85RJX2Jj8UwCu68k5r7EupX/EEr/KlwVtmTEgcdotjLheemwEJDUZnYFcjw8S5fHb
         lNXtq1Uen42lv955qKsrTTmQItBOYdttBjnM3fiBQSIREndZCSM0WVBQ2cmSae+H212n
         TId+9jPGj29D1QCvv5CqQ1sZZQ1GoAslgFsDyfyVx2/dDcK/PezucxVIT+JL6dfKBoFP
         JEAg==
X-Forwarded-Encrypted: i=1; AHgh+RoCZZN2/vja3b2Ez1fIZ72AWLPfsxHwmQCy7MDnR/PuV6XFOmf13TZ2CFznTBueBDgygHBopOISuA==@kvack.org
X-Gm-Message-State: AOJu0Yw68gqKt+qjVjzV0Cczdv5AzZ6sKZAmVv8Gga4cyMvjyPDPQbz9
	DBxWJ/1xvAOqPiQInAzJYNMDLN2/UuLmJBT/7W5qBhBTg3VdGk0+maAmD+BZ+5p4piC0TAKPMXi
	DRN4VSKCm9AnWUIWu9qKpvQ==
X-Received: from plbjl21.prod.google.com ([2002:a17:903:1355:b0:2cc:7709:3bc8])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:4b4e:b0:2ca:c7a:859b with SMTP id d9443c01a7336-2ccea36d9cfmr6381555ad.36.1783480306686;
 Tue, 07 Jul 2026 20:11:46 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:25 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-16-jthoughton@google.com>
Subject: [PATCH 15/18] hugetlb_vmemmap: Add a way to permanently disable HVO
 when needed
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E4FC040009
X-Stat-Signature: km8m759bc3uu4o8banyz33fu6dnk5m9p
X-Rspam-User: 
X-HE-Tag: 1783480307-219142
X-HE-Meta: U2FsdGVkX19NHbRC+KhaCObIazh/TTbr9R+Ma1s573dksZh6/RHrD8ZqMEAiUjINxhC47nVfZn2E2lLg9DoF0DW+GKfSmXNpD3+e+LlvGxsDyhzJJ9wWLEy+8tOEJPFs5kkwSKE9V0VhHr1/PoeO/LzVB4N7QMJ8rdq2lv58gYxKjWQ6wNhOUmfbdpe+MpaR3WAEZepxHrOh3ylwLo0lLFOR+FMBPNOlFIq/jRvUn5LjyNkNfxvg11q1DKaryABJAznvxF+V7UNatbwr0PpIzTP0VW2ENF+kFfFbrN199I3ZRIzfVPF4eZQBkcQVMwn0a29jmNSjFeYcmMLXXDIgvdfwrBlPOZGn+ZpegSRc4xg0C0EltQb12v9Rv/dEIPHyfL4bLM+20Ax4z6Ygz8v/aSst8CuA//tYJMMpfysDLNDKy+prJmg8jwOlLYadpCTShSLOZasdm6EU6MDK659oXncCqiQHUjVdRUuxVByd+qx2r6nGQf1qrB2lhETrXzAjys94rEIsf22/4TKAlVq6TFTprFPhEe6inkLGQmOagSy+rhGuasE5RSSG0j9k017lfsZGlsKVsl33oPZlxhn4HzjLdpwlkdKirr02Zdmi3245Lnear6tgLeAtp9zgVK404O005AuA0ioA9Trg7icuSAi/rqSpJLWsivFJ3URTT0IfuDFVK7yMW4IhxXy8puR29FOdY7Qu/BSYD+wbaCuO0NrReOTqY+D1iZ3WqX3i02HqNpEk5sjunsxS+DoHIbjBRiuxDC9I0agg2oX6zc1h6xgTzXX+VJcvLu7kDVo8nBgx4eCOzU4PEeBVoG0HJnpExqFw72QqS5VtpnnDaNDF4/1jfULisVYOnGfn1kqQFPIhrLaQ2S93KccLHOCUmv87hKgD9MUTNe9FNHr48U/WeSdcYJ3unN40ylRLjmCQSz8i+RvQbgDG26PL8cZ+8+OuE1Nh+HhRBfZA+tbmfWv
 EPXq5pnw
 BRdVP1aiaXoXe7pBvNySHYGmGy81RieoE4/5YC2mZj7wMlLC0j1pJshM3Vr2dYIl1HfG7+Pztt3oQJeFK26kEA5ktfbQeX6LlU+g7vn6WAB+WMwruHaPnzOvYuQMQJN3K2iUsFtQ1Ht2oKaJyorNK0xaxyJVVbSEb7sodN/jLuHVE7SHBFWjj+8Fy7XOpVDy7fsR5P97Q2vP4/iekXBfpXSr2nxuDx0g7SqI4AO2T+M8jgF91RIf1SlgJMb0EDR8Jxj08wE6obDQQlF5w/GFERI8QNYMJW7EnnbaRSlpeCNT8YQCdNry1K2zKoWN2EseHQFQXon4JEGXqj/9KkEzQz/MCmCRva4XzSddBqYU17U02P+AEW6y6tTRpFU9dSkEO2XJOQfCOBoX2RcMdOOoCb1bl5fo9oImYmAPDx2bwk+vQFkFIRqlD5kRBb4gvvpxcqsOcwp4+kiWoou3KdfHeRfPMiZdUW1+2AVFlLtdTwuar3Zle9+FWmFLNK0xeMWwFN2LilzgbCvFGA1kaPNe4I9bv4890Uub0pRGwMGP17HUnWof7/J48m7pSQwcwQlVUiSD/1OwMpD8VHQriJfawzyFq2D2+tkpVeFxxsdBtMveQnL3QNNntogG29XpRYMjHmGVwRkSCo/s+Nx3TsTy4919kOXlviTNjPMmDvhIfIvlYaJVMjJcLbKeA+8mvovDEqMVB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_vmemmap_optimization_try_disable() is used by callers to
permanently disable HVO if it becomes impossible to use.

If HVO is already actively in use,
hugetlb_vmemmap_optimization_try_disable() returns false to inform the
caller to take appropriate action (e.g., for arm64, not to online an
incompatible late CPU).

Signed-off-by: James Houghton <jthoughton@google.com>
---
 MAINTAINERS                     |  1 +
 include/linux/hugetlb_vmemmap.h | 20 +++++++++++++++++
 mm/hugetlb_vmemmap.c            | 40 +++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)
 create mode 100644 include/linux/hugetlb_vmemmap.h

diff --git a/MAINTAINERS b/MAINTAINERS
index ff47013ce995..55bd4c09f494 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12013,6 +12013,7 @@ F:	Documentation/mm/hugetlbfs_reserv.rst
 F:	Documentation/mm/vmemmap_dedup.rst
 F:	fs/hugetlbfs/
 F:	include/linux/hugetlb.h
+F:	include/linux/hugetlb_vmemmap.h
 F:	include/trace/events/hugetlbfs.h
 F:	mm/hugetlb.c
 F:	mm/hugetlb_cgroup.c
diff --git a/include/linux/hugetlb_vmemmap.h b/include/linux/hugetlb_vmemmap.h
new file mode 100644
index 000000000000..a671eb4a4ff4
--- /dev/null
+++ b/include/linux/hugetlb_vmemmap.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_HUGETLB_VMEMMAP_H
+#define _LINUX_HUGETLB_VMEMMAP_H
+
+#include <linux/types.h>
+
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+
+bool hugetlb_vmemmap_optimization_try_disable(void);
+
+#else /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
+
+static inline bool hugetlb_vmemmap_optimization_try_disable(void)
+{
+	return true;
+}
+
+#endif
+
+#endif /* _LINUX_HUGETLB_VMEMMAP_H */
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index a490a34998d9..7e7f8579cc2a 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -17,6 +17,7 @@
 #include <linux/pagewalk.h>
 #include <linux/pgalloc.h>
 #include <linux/hugetlb.h>
+#include <linux/hugetlb_vmemmap.h>
 
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap_internal.h"
@@ -463,6 +464,39 @@ static int vmemmap_remap_alloc(const struct hstate *h, struct folio *folio,
 	return ret;
 }
 
+enum hugetlb_hvo_status {
+	HVO_INACTIVE = 0,
+	HVO_ACTIVE,
+	HVO_PERMANENTLY_INACTIVE,
+};
+static enum hugetlb_hvo_status hvo_status = HVO_INACTIVE;
+
+static bool hugetlb_hvo_status_try_set(enum hugetlb_hvo_status status)
+{
+	enum hugetlb_hvo_status old;
+
+	old = READ_ONCE(hvo_status);
+
+retry:
+	/* The current setting is what we want. */
+	if (old == status)
+		return true;
+
+	/* The current setting cannot be changed. */
+	if (old != HVO_INACTIVE)
+		return false;
+
+	if (!try_cmpxchg_relaxed(&hvo_status, &old, status))
+		goto retry;
+
+	return true;
+}
+
+bool hugetlb_vmemmap_optimization_try_disable(void)
+{
+	return hugetlb_hvo_status_try_set(HVO_PERMANENTLY_INACTIVE);
+}
+
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
 static int __init hugetlb_vmemmap_optimize_param(char *buf)
 {
@@ -571,6 +605,9 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 	if (!hugetlb_vmemmap_optimizable(h))
 		return false;
 
+	if (!hugetlb_hvo_status_try_set(HVO_ACTIVE))
+		return false;
+
 	return true;
 }
 
@@ -809,6 +846,9 @@ static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
 	    !IS_ALIGNED(psize, pmd_vmemmap_size))
 		return false;
 
+	if (!hugetlb_hvo_status_try_set(HVO_ACTIVE))
+		return false;
+
 	return true;
 }
 
-- 
2.55.0.795.g602f6c329a-goog


