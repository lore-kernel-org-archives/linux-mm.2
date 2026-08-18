Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E4FDC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22C606B07C9; Tue, 18 Aug 2026 10:12:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203FC6B07CA; Tue, 18 Aug 2026 10:12:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 141746B07CB; Tue, 18 Aug 2026 10:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E918C6B07C9
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:12:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C48F1A02BE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:14 +0000 (UTC)
X-FDA: 85114579788.15.C15C573
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 97A8F140008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TpDgui9M;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHzFJCC+M8tqZnin41JZgMMbwSSc+ifNVeas8AixPfs=;
	b=0WKslZZOCE8mG3yABEbtc1FidXmNmxKONT3A77A2go8+DAyQuAj9NegDJ+tLDK3uGlOYF4
	zgXwwRiETx6DyBv/Zsjs1P32Dj9Fj0q/pvXogZhuafq/EXl746cekQ1C3sMfwAc4RuQMDa
	yGQuGS7XzOZvf9A2nBfdDE2vRHA1n20=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062332;
	b=2wtE143jf36wqi1tmcWaNZWIRs3eBt2ITJ0k0QQ4hFvxAN5jd2vXFEFFQSFjDEb+ZQPbsT
	9zf3q+8yVVmDQn3Zl8kuu/oTExxZX/Ri7xlzBwCe8JlJmE1wA42Lzw/aV2LK4oPuHkEACD
	zMDUWwGzhkVXEpAp4kbhAGqiuCCrZG0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TpDgui9M;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F297B19F0;
	Tue, 18 Aug 2026 07:12:07 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A4813F85F;
	Tue, 18 Aug 2026 07:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062331; bh=nU3eiDcO03IFOkcW/QGHHUOPCdH6UYiP9fWY6Wc22aE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TpDgui9MEP/DBiWOyzoEFsB1lSyWL8ccgweMm+voZxhnjOnFlIV32WzriZZ5/oRPo
	 tnPqXku3XwOXWsK2MZqvD6H70hyFxKWRJQOQL3X5cxyVCg0oEn6vItIQoDoecGu6vE
	 9voczrix6U4Ain8AcgwnMaD8FjPPJkqWUfsxemAw=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:08:52 +0100
Subject: [PATCH RFC v9 10/25] memblock: Move INIT_MEMBLOCK_* macros to
 header
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-10-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
In-Reply-To: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062276; l=1850;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=nU3eiDcO03IFOkcW/QGHHUOPCdH6UYiP9fWY6Wc22aE=;
 b=B0yfVHLm7lbOmhzKoBAFNdH82AYQgzd/UVKdZtKYaNAexZho70FVP/w0siiGh33OJI1gNWTC/
 Brpeg+LeXnWDRFfn/jmPmIAPVCw79DvJkgh9fVeFcjJUTg7KeQ0CBKn
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Stat-Signature: kcmwwk75pg747u4d61d9ohrtt1ujgfzh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 97A8F140008
X-HE-Tag: 1787062332-648902
X-HE-Meta: U2FsdGVkX1+C9Ce50+N12MUeb7Rg9/3vLYhM92m2/ZMGEFdBRnIsDa7DjNBYMrZ/soMdFxvyX5ZvtBQAQVL3sRkxGmqTfwXhHzQvJhdzv/1uAaqyR46nkgAgft2mwkgZ2pKC6oedUtW1mrV3OjMylWXRevp6DAcvK9bxXIIdzMg2yKPmRlys34MbrKHO8L9mdSWEH86MD3qcKAAm7PW4I2w3HsHlXULAxNYs5OyVknYaCc/DuccyI417uxTwIHun2awyx8tIMaUedtdl4bIGt50I9SzpFkwvQrwRa+8a74dXER3BbP6Cxdb2OKEOm/eO/T3pNx/c2ep7i70ODF9K03o484AeqQ+xqyZ1zwwA/+9vVXr+1NO4oAyWCaeTRDn0G2KMbdrKBQ/du9cWvuBphfPYhWI7SxG0TWny3xy899lVwFaK/AxubyxD83eKBSAhUjkgoZ6Q1VaKDJgxRFyEiKJaGLg1inNZ3bzGVW1Uk1O4pDY6Ia6L88+QhWdyYXT1NlhISf4V9VfwW02N3cOLEq0i4K1hXGLrHwLgwpF4d72VirQzKOnbWql9GGIDu+xepdD0mdqQh9QVOkKi1ADGrDjCXlZtvL6qFcBMPbrzYAQC4HLN6y/70J0GSONDkIs+mJRN/df3RfkSxokeNeSBKN6hhh0/HLCufGUFDwY/67O0FK/xiqpGbN5mTdjqkCJWQUde3CEZgb5l/NaD2hZshwwvlFcPn8CQMxYHrrU5r4nxzDkf0UWhA1MN3jZekm9DdA2koI4TpaE7Tw/q52dxKsFX5jRk4pyQrqMTQJmRiR5vkBU+hk1MZrUw4NUnl6be4HdE1kMN8RoL+lfHLpERpO65s3DtBNwFLqtsIpQtHnCoFG+8L64CYaiq4CJKDUI524NPxGCVUQttCrM7FVx3lvt+xDiScbXXiYx121Anu5jcmYnxcEH8+S7cT/ZpnkPXCFeiPhJthHwYbsYn53Z
 kjdnh7ly
 yzWw9pbt+6JJCA32RRpSdnNrcQoL9Q8749hGuf3+UhHPJ7K3NLozFucnudEZiJVG+xodcV0XM/mqRtSyPSurSdHAg1zRQ6DjdZnucPxJefDLZ6Pe0k6XJPqIWhfiZY+5RXtRitHz5w40A7t2Xkl/hXz4D1JXyc7zbKNWqvzqu8y/jTUxIne5KDPhwLtl+fwaF1sFZhyq+nwm3RG2jeN047n5TupId9eujqXR1ssn4TmZjsHUzfz/T4ZlGLCs9OQoy421lG47/kPt1UMlFeMmlRAWNZoFuGm3ogtqZ17zkn8LG/hw=
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
index 5afcd99aa8c1..c61f80e31cc1 100644
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
index 6349c48154f4..3b497d3556bb 100644
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


