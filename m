Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 630F1C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 15:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100A76B0096; Thu,  3 Sep 2026 11:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B25C6B0098; Thu,  3 Sep 2026 11:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2AA6B0099; Thu,  3 Sep 2026 11:50:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C65756B0096
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:50:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 56541120567
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:50:22 +0000 (UTC)
X-FDA: 85172887884.05.C9AD82E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9EE621C0007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:50:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gKSbt6d9;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788450620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7gSlHxYgypuWgcZDQkom/SXcL5+3gzhc1fw1FAM1Py0=;
	b=CzR3nPqKMB4M/lMArZ+Mm3MzB27H+WtLTAhSSO1Ve88Mimz5/Cwigax0GR1zJQY9AW4B1t
	h/5Dio+mntZeDFhz8Oz042DhvGsn66gHLPzGTAd0Y0R8bA7OX6Uy5oJMle3PoZh3syABqG
	RXsx269h1oSEJC5d5OF6sWbG0+g8Uwc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gKSbt6d9;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788450620;
	b=u1ydqys9aEPEQMmrrbPuGmfU6e+SDugnKqDCxBlKLVkvHSIbSR7I87K02sNBBGptu+HyJ5
	ZLBKG378I5z0PVs/Nqqcf/9T/70dHRV85MgxbNx1ZR/glxFbi6gPHzCqiVli6vYOWOnvbL
	upZwoV2hyzyKP0/yrnLW4R4UIpT97/k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F150943C54;
	Thu,  3 Sep 2026 15:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EBC1F00A3D;
	Thu,  3 Sep 2026 15:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788450619;
	bh=7gSlHxYgypuWgcZDQkom/SXcL5+3gzhc1fw1FAM1Py0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gKSbt6d9D0uAdEaOVghOguJ6c5AtIVGFZ05HuItgg8aSgDE7+88HwvowvZDc8M4u4
	 g5ZZqw3Lc7+MZm/ErnQ6lTH7QY1fKwso02uiRPA4Lqq2HQpjUBxVRHu9XcggliatYB
	 Ir8GpFHtraTriTsZPrQ7SPsYncQAtbqXCCnIz2jfVM5TtQHgUZLP18dr8d7VBx/0pv
	 SShtK+ubAdzhIquF0nf2gnu5G64PAJSJz9JbbW0oQBIxX2mhFJ6wgyRuuKgGI68uqF
	 qdRQd/XHSPvXQhsyPAEyo8sNgKYYrb9VcqX/Ub/P7IMdntF7IP5C2xnlesXk1istpT
	 LDFrk2HJ8zXHQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 03 Sep 2026 18:50:01 +0300
Subject: [PATCH 4/5] mm/vmalloc: add DEFINE_FREE() for vfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260903-execmem-rox-cache-pmd-v1-v1-4-11beb2a3d249@kernel.org>
References: <20260903-execmem-rox-cache-pmd-v1-v1-0-11beb2a3d249@kernel.org>
In-Reply-To: <20260903-execmem-rox-cache-pmd-v1-v1-0-11beb2a3d249@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Benjamin Tissoires <bentiss@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Stat-Signature: spwdiakbec7mzu6ikuq5owh5z1xds6cs
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9EE621C0007
X-Rspam-User: 
X-HE-Tag: 1788450620-341134
X-HE-Meta: U2FsdGVkX1+Yb9Gus1y/EF9M3wBbG4OfUmdkVy8qBnqMnITnjmgL5n/xsDp2pzPR2oiFSwhAOvs1kPOHi68/kXJbJbIpYuSOnKuGDXLupnOOZkDe8w4jsFvI/7ddDUg552/gMKF5Iw6nwUEZAiB5j0l9KRtYcb9efZ3dk4YHlpq+W7FwCoO3t5icsxkjB9XKvcIsUk57eoWaj8xZ+Z+wRPJoXlTzwoiQqPlyHgwsEL37a3027ksXLw0+TqrmdOH82xBvLeS1iVSVDJte6HvX4Y2w7arRuE9qovSGB6TxMVbJ2ybOAE06tJJnQc48r6JZR4Z4L/ndlMxTz67f5rMQPgNPYByD40YBIIw6UOrhsN/aGLr1fPf9yzXS2x9NkOFjW7p8NnFEhFf2jDuCYmw9tWnxaYqSK0+nvNZfgwg1N5b/LHNXjtmXcIGoBYdMNYQWjjcSQ8JLBXBQ1UI3WRYHMdUy+hu635hTgiGFmf0XeX2W2ShrReVQVUtfbDcf6wGSIi3fUYzFlFOkIBu2w4iTP0HyKB7XRa2HjTTCYhMo/Kys2g0EBk950TOoRmfqpTXHnBbM7gVscpo6cf+KH1mujH0Uszai+mMtcFHbbF3j2j75GeLq2RR3WtdFxnEH7kUkeo6uSnID0kvAM5QBzoFdqFprRNo+1fKH3nzIM7For8leEPx8nRTayMN8kj4FYuJxDVNicOJMNl3t4DU0oUrRfZ/N5vnSC6w44hbP1PkI++E9z4PoToBtOzqODmtV0xxQSWakjVlsPQvBNFsoLU+cRRJk4XLCK1cFrtMSWqgtiu3uDbhLAKEBNJ70GIjkZ7dDqTXRgoeim5xcEGyIJIwN5BiEFJzEY2AcuO8IAjoNL/xML1yCLi7KmByhBrDYZniIlbWX8UZJymtzkI6I/n46z2rkEzEMwLRaK63vAMhbwcJGwtEyELGhv7lJLmc+Rj3Ts9JJn3pzX1PPPAMcPwJ
 F4L//M+E
 tGx/Y6of4OMhiOJbyNC7HJde7PD1lXQyi0+XSCp8Xp4pNRv7i3jVCbGYX60chvPIGy9L+vJJyCS64L9EQEPbc0Jt2UntFF9NnTmMm0RBbAqtES32Pfhw6E/ym0p42wJAM4Bl4z2hWA/y2iIVkDpFMgSGTZZ3lTE6NfEY0b3K4ieX3vJU/Q0lzj8v8chLCEhcqErieI5LAee6B7ol72+OUs1tlsjeAO7GswCj6jPPMLneDcfG4Hk3AWQDnGor7acajDeTOdLWZpBrTUoJx2cEHu9QeAvZQaqUdALJefBYSDp3zYvkb2XpA2rEibPn/o3p0G+4i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

... and use it in hid-core, the only place with a cleanup for a
vmalloc() allocation.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/hid/hid-core.c  | 4 ++--
 include/linux/vmalloc.h | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a3ff0514f9cdf..ec7c2860c93ef 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -944,7 +944,7 @@ static int hid_scan_report(struct hid_device *hid)
 		hid_parser_reserved
 	};
 
-	struct hid_parser *parser __free(kvfree) = vzalloc(sizeof(*parser));
+	struct hid_parser *parser __free(vfree) = vzalloc(sizeof(*parser));
 	if (!parser)
 		return -ENOMEM;
 
@@ -1265,7 +1265,7 @@ static int hid_parse_collections(struct hid_device *device)
 		hid_parser_reserved
 	};
 
-	struct hid_parser *parser __free(kvfree) = vzalloc(sizeof(*parser));
+	struct hid_parser *parser __free(vfree) = vzalloc(sizeof(*parser));
 	if (!parser)
 		return -ENOMEM;
 
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 6e555e31e6225..034a693777ca0 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -3,6 +3,7 @@
 #define _LINUX_VMALLOC_H
 
 #include <linux/alloc_tag.h>
+#include <linux/cleanup.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
@@ -215,6 +216,8 @@ void *__must_check vrealloc_node_align_noprof(const void *p, size_t size,
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
 
+DEFINE_FREE(vfree, void *, if (!IS_ERR_OR_NULL(_T)) vfree(_T))
+
 extern void *vmap(struct page **pages, unsigned int count,
 			unsigned long flags, pgprot_t prot);
 void *vmap_pfn(unsigned long *pfns, unsigned int count, pgprot_t prot);

-- 
2.53.0


