Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEE14FEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3696C6B00A8; Fri, 27 Feb 2026 12:56:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5FF6B00AA; Fri, 27 Feb 2026 12:56:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203766B00AB; Fri, 27 Feb 2026 12:56:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07EC36B00A8
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:56:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB0811CA9B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:37 +0000 (UTC)
X-FDA: 84490991634.22.4D6BB28
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 02B95140012
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772214996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mERVD61sY/5daxDXxeryajyl6Gvr2VmXYacv4kT6jOM=;
	b=We1Zv27SU4DNVER+ui3i+bcxMOqHTdv7jsT0nr1XD3XpF/O0m46aOqBqaPhE/q15dhPIa5
	go9J4HYeuPQ6OHReVNjoLyGaXgHtj9B6UX0vsxw4F00YDzpzs5r1y5Rqp/15jINV4F373J
	r0CUrdAFk7pwPZVmx1IEcICV0nRFkts=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772214996; a=rsa-sha256;
	cv=none;
	b=VtVB0V46qtreqfuYGIZNSq3Dc8KkXCbo/8fU4WnufcthCi0JyIhFJlDn0dgq9hk9uIr+Wt
	pgdnELV6XBxZEg79rJSnHp/V3CrTx9ulXs4RC83hzcVByBe8p4KquNrs6w0MeNVz/bwP2r
	lf2mTv/tXf/rw96D3sO4QEa07LbHFio=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3DBC14BF;
	Fri, 27 Feb 2026 09:56:28 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C17103F73B;
	Fri, 27 Feb 2026 09:56:30 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 11/30] memblock: Move INIT_MEMBLOCK_* macros to header
Date: Fri, 27 Feb 2026 17:54:59 +0000
Message-ID: <20260227175518.3728055-12-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 02B95140012
X-Stat-Signature: hy69asy5u5gnia7uds6mc5dissabei1h
X-Rspam-User: 
X-HE-Tag: 1772214995-735993
X-HE-Meta: U2FsdGVkX18jZNEZLlhgorj2yLS8aBV9hze53oNtX+kjzdYrM05JUUV3IDlxBXVPcGZk6/rYyQ/wNxdT8qTXFkGsDgD3DVLsGVh78ayqyVOBlrqQXjmBR+rhbJg9wYrb2NcKoOvHkXPHsQYLN/IIUqw1Hx6tbyANWrzf8JmZoaNhVPpa/xDC5mcWJPRWhY/YM0JAOyiL2YThGHctBrfdj2kxeLdghWF23/ztIbp6aX22MyAP7lLV6L+M4xJ2nsFJs3g21GUVK6CMUZEzhBb8qJ7zwyCkxBGtzWfmnwylyzVA6e5vAtKsZNlaX6wSKMH6hgJdpRR1UYwy/mqKfVuLUBzDBf9qSH9ikVOzxPdvsDEW4Ttgc4SicJdMSPv7vog1AYEzQy1H2bu3P5nQQD7p+cQN1alPsAoNp8uck5IE1AfZwep+sPHY5telab5HE7B44i5iX6TDOdqlWvLc4AN7kXSukxLuO1cNyZMfMARunWBU/rlnqnL9OBPMlKK0X1ErLVUhCkshcQNkP4bmosTo2kGufrMHvHNnm4UVjB+NFEneOugo31mlCr4YFdz5SVcFqnCsk0tDUqR4kD1c76YeZeUYb79shCbntN7ncPwPi2/W4C7WQcJthPnYgtqllWO+9RiAYQXqjCKUTzPB5EJbtPiAllXwY2jp3FJHX3i4+6wGlKO9EfG4fdjEEd82YYPyx6cLsFmGvI6SykGvQe/4AH1I43BKcaeSSmP6xWaZFYiPA0oxDqA3Ji2D0tOBXZ1O3fqXapLI9cd3ADXiJeHaZTvaCX+Pm33SgbkZeYPLpYBrYPtT9mxg29yqpB4PQ61TcytkeqirR62MZ9x4xA2v/iLRjzz53VsysIgzudeDNZXGG5VSpJWawFOyiWqFV2a3f1tzk8d9+B2nUZBGJK9uTJFlAHpiwjKl+5XOcj3a8abvOWMmwFU/fZQujKuYQFH74J81R9bo7maFP5RP+mC
 2Vp5h94T
 /kds8mVYjF0Cl5NUxU+0Izzw+MKKBYIn7B+je1LUe9FrNHmRpPW5FljAWzwtpxhJ02Pv3Fp8H5eG7Lq+P9b50szIjS7NQi6p3xNQ75R1dfiEKsZHWuU2gJiBYQiqiSp3Z46f12d/eklEgh3KN2ui5Y1eLkS/qSFhrlmsv
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
index 6ec5e9ac0699..79f3ca8ff268 100644
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
index b3ddfdec7a80..954eb76aa0c2 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -29,17 +29,6 @@
 
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


