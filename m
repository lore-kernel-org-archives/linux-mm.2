Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D394FF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1C9A6B00CA; Tue,  5 May 2026 12:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCD336B00CB; Tue,  5 May 2026 12:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBB3E6B00CC; Tue,  5 May 2026 12:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B76DA6B00CA
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:07:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D21BA051A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:52 +0000 (UTC)
X-FDA: 84733847184.06.97DA3B8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8BC7E40005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ks1sXyRI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmFSGXNg0MSZohWP7YtFKB7EUmCmD7qHsh+06I3nSqU=;
	b=wnABh0WPNuAwp05nQ9htEn06ejqB743SF8Gb71stpEITFu25bxBRkWZEPmhogwCkyj3zjM
	ovpTVBEA0WZt7moeHfxNS0lw2e2AcSO6eO4929BvZq+EGLF5fJiSjIU8AUcDSaN3QiKJSw
	TzRMuMqWdET2TbdhyFSc6TQ3Bs0VlPM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997270; a=rsa-sha256;
	cv=none;
	b=3+5CMGkws3b+15yLZaVn/mL6Sx9W6ToudvPlTDXsRZsNx4wECyRHW7+0DFvYuJfnI6xzrf
	TiVf5MxMUHN+6CyAc8REgdaDpyHdqSwgYyev4OF8Q9OVXksC0ZI1JrwtG4W6vzEPfeSzCJ
	vdbw/B9amAp9OQpo2sPtGUwyfX3M2ok=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ks1sXyRI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2469014BF;
	Tue,  5 May 2026 09:07:44 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C3773F763;
	Tue,  5 May 2026 09:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997269; bh=BIW+ZJvi1P4EeD5UF9lAJp1G+q4h4naKio10It8LHdc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ks1sXyRI1hThrfI0cdrtNGl/4LarukIMq3EhDGNS8hHCb8PwPBKxzVPt8glVqyZOY
	 icrS0sCFNcZzIKKv23WubhfaR4pG99w8/OXoxkm58Oh5Rtt5dxmYtH78drowtyFFjt
	 /l77Qi6sK7w3BiGnqWt4/d06GTx6uIJRHpS5Vwr4=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:05:59 +0100
Subject: [PATCH RFC v7 10/24] memblock: Move INIT_MEMBLOCK_* macros to
 header
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-10-20c0bdd97197@arm.com>
References: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
In-Reply-To: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=1850;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=BIW+ZJvi1P4EeD5UF9lAJp1G+q4h4naKio10It8LHdc=;
 b=z5MDXNXpY+aTeXeMbaiCtyBMzuTaPkZmT8f7P/ADfP65GXXpjSAjvN21IuXvcFhCgjFsYnE2D
 lA1rmPOTU7sDIvgzVk9b/FlYvbl0xrxcAZyKwdW6IldgrgrGWI/hUwW
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8BC7E40005
X-Stat-Signature: bunzrmp9otbo5tmibujhez7ekp8x9o66
X-Rspam-User: 
X-HE-Tag: 1777997270-393559
X-HE-Meta: U2FsdGVkX1+saWGf+078JJ5KMm5wTa4McMC3pmhQfKjkmVkmeGlzRL7XdaF00ZnmrRabD9Itmgxc7oi4RTTBajQ/3WuUHESVS/QaP4LL40zVRy5lY1wvygZVpGRE1Rkn+qQd/yquSED9J8CJ2EbvNhiozj6qDiYFHGMFddUHxaDBpjYd7R+5IET6Co1TNSBRFZiNcRNsH65ZpKgoh2CMLLo/BPr9toqNf6y75HRDJRejcWejAzW0xo6wYF2b+5hxKuOrHtOabXkzTYgGNET4xQqdLngYD/yroM24Oia/v7Tdaijbs0AaCydWfWDymmpZ666AXm+M9tW/Lyc2Q3xDGnpnHCAiiTzBWmekvKkqJxN7x+tIkzfsmfNGvZlWV6SR55g8Wb7+7WOOgS7oBuQvMbI/HCldRi3N8FksqOem9gBIN/1Hnr9aS4Xi+fyoKIT1v8UhlA/E4+8WCq0z66X7FobtCMDOG3ZhKeLXDSGfjH5NlQGJ7Kv63Ong5vcnjIrHqNs1+jmv25eIMwARY+ub0B765/yvg+tqO1AfPJa2hTRZuxF4gEAPPgqPma9MF1C3GF1OlfXEvJiy1Ia1jyCGkFtRdSKMfkFamdHHVk8EcsJs8swGi2rqqM5iSG0GtEi0LOW1tO0Ac4jsasPiEGOnKGBW3t8n6LAfJWSGtjFplN81067UR6tdOMnqfkzaDF7VySuaZqqRn46dawjJPpGnnYjU/qtUey1uCiM3EsYW4If50X5+s0wKFQAhvmR1A8cuxaEjjlE79yZjvHgkfFzJR5O7DAR+nudIZIc9bSRVt92ZvDyzC5SaRzDEElT/R1Hk07aVDi1YAc2I1HNY4OTd2tAYP6ovaONBfsJ647sLNh3zUBXHMjckDgmreGahmlH+ZuiHNljRHYlTLAL5uRRYH+Y4qa2orD0dmufcoZJFQl3MA+p3p/H0HorKPmxl6X5RfzqxW9M/YVIU23H6Xdi
 ziQFnSo1
 TyyE0TycmkqVkPg2ZwunAhN5kx+JBPGmDqyr+7mdlRXhzNYCGch/zmUk+2xS0OJ0X4TBGrIccWcn/I/IAgUVfUB5fd2ZAsmidxEK3z7qa2/9YOULSKTqJGZlIifWtLjEuTzls1WVJ8ynLD+2Uf7Fmo2DhRgvnURkGsvS0mwjPVV1FaUX/UwBU0UObPSy/DQ3MLooKD9KCbSJZqi0lifZ0Mb8UyxuCNVThR3tF1ATLYBFwrdnzSn1m3/uiKDB87RosWcya0ZCzu750QH+Qs4QQJgNCWqLRk+aN6tjaOjbTmVJQEgs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The upcoming page table allocator for the kpkeys_hardened_pgtables
feature will need to know the maximum number of memblock regions.
Move the corresponding macros to <linux/memblock.h> to allow that.

INIT_MEMBLOCK_{RESERVED,MEMORY}_REGIONS may be overridden, but this
should be fine as only arm64 and loong currently do that and the
relevant header is already (indirectly) included by
<linux/memblock.h>.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/memblock.h | 11 +++++++++++
 mm/memblock.c            | 11 -----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index b0f750d22a7b..e58b2c859b95 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -24,6 +24,17 @@ extern unsigned long max_pfn;
  */
 extern unsigned long long max_possible_pfn;
 
+#define INIT_MEMBLOCK_REGIONS			128
+#define INIT_PHYSMEM_REGIONS			4
+
+#ifndef INIT_MEMBLOCK_RESERVED_REGIONS
+#define INIT_MEMBLOCK_RESERVED_REGIONS		INIT_MEMBLOCK_REGIONS
+#endif
+
+#ifndef INIT_MEMBLOCK_MEMORY_REGIONS
+#define INIT_MEMBLOCK_MEMORY_REGIONS		INIT_MEMBLOCK_REGIONS
+#endif
+
 /**
  * enum memblock_flags - definition of memory region attributes
  * @MEMBLOCK_NONE: no special request
diff --git a/mm/memblock.c b/mm/memblock.c
index a6a1c91e276d..e64ad9c72dc3 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -30,17 +30,6 @@
 
 #include "internal.h"
 
-#define INIT_MEMBLOCK_REGIONS			128
-#define INIT_PHYSMEM_REGIONS			4
-
-#ifndef INIT_MEMBLOCK_RESERVED_REGIONS
-# define INIT_MEMBLOCK_RESERVED_REGIONS		INIT_MEMBLOCK_REGIONS
-#endif
-
-#ifndef INIT_MEMBLOCK_MEMORY_REGIONS
-#define INIT_MEMBLOCK_MEMORY_REGIONS		INIT_MEMBLOCK_REGIONS
-#endif
-
 /**
  * DOC: memblock overview
  *

-- 
2.51.2


