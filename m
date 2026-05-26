Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B0ACD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC816B00A8; Tue, 26 May 2026 07:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84996B00AB; Tue, 26 May 2026 07:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AE8A6B00A8; Tue, 26 May 2026 07:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87D946B00A6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:17:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4BBF21C0215
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:52 +0000 (UTC)
X-FDA: 84809321184.07.2511DF9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6958BC0006
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CXUQBxWn;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmFSGXNg0MSZohWP7YtFKB7EUmCmD7qHsh+06I3nSqU=;
	b=Z7ceSQJsS79PSM6QJZwqcdfbgHnicqua7r8GHLgTmWC5Q8NhupFMW5a+0Cf7d2aAXHJwfL
	0Jcb8sKAjtJC8Bzw7vGABN1SE2cfC/+Zyhr1q7lV53z9myXxOQ7Lp9jeP+PWplNIbwSXh9
	5AO6EzDBJogffGCoj4lFSVxi455zS5o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794270; a=rsa-sha256;
	cv=none;
	b=atwHKXPz5ehsW0ibZTUnuKUNrxikVew7UbjQukz69x1FT1tE4b1NQUA9U1NdL3Urik5j7A
	pYgcQk0ARi+04aUe+WfGTmSDhZk/dW8UltP3y9ONC/uCGaaYHhzH4qaPix/evJIvM7ck4t
	y8IWj/BGym19TQ5+mpKxX4n1vOW+jvo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CXUQBxWn;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8770216F2;
	Tue, 26 May 2026 04:17:44 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B76F83F7D8;
	Tue, 26 May 2026 04:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794269; bh=BIW+ZJvi1P4EeD5UF9lAJp1G+q4h4naKio10It8LHdc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=CXUQBxWnRCwDZIJbyDjOv6buZ/ZHuWq3lv1+SZZ95PXYVPCEok99psIDLKCiBWr5j
	 nA46PFCbUIyYPmEnNSZNNxgOyaOoM5r+Fcgw/ImgQsqrmq4Tf1ySVD6Y18ZCcHBaGz
	 hyxkxF/1qpwM0AL+laviTWnjvM9ARiQxBMPY1G3w=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:15:59 +0100
Subject: [PATCH RFC v8 10/24] memblock: Move INIT_MEMBLOCK_* macros to
 header
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-10-eaaacdacc67c@arm.com>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
In-Reply-To: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
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
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=1850;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=BIW+ZJvi1P4EeD5UF9lAJp1G+q4h4naKio10It8LHdc=;
 b=k/6tYCVgqofYCAapYqWsSvaOAxLzZMkQtTrrGWimL0nEfK5dP+LdOGyVEW4bM+EHz7GaZ5JbC
 m/SoVteI4iJDZnNe5lK94c2vsiiFUy8vWgghfokYtQqib4li3mjDGUK
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam11
X-Stat-Signature: kf1o1bgwob6grmyqrbiynqi18ukirkfw
X-Rspamd-Queue-Id: 6958BC0006
X-Rspam-User: 
X-HE-Tag: 1779794270-617804
X-HE-Meta: U2FsdGVkX19QV+ZV7Qvgyp27dNRAsucbOaHfAb3b+ty/t/lMlAXkpABxUZP2WuHCKLouO+AwuRkVpgt2jGpGS8lXcRlt7fdW6GIOmXASLcL4y60cEdhUFX8s3npDLyxNSkuUm3MqOTnf8IWH6f09QwMDF9XuHzTGc4chx+DAp9q4HrmG8DnrjjV+vFdpoGKKHgwRNyWnrPKY8nLT1BWXlSBbPjQaiU5aByoh1u48M65bkFDQNu/+ZQ07DFWU6QFJtVc1HoLiScG9DY78PQ7kzETyQYkGW7HMbLGIpxQvPQ2El02JS+io6S3Fzvk8b7q78AARj+IFXzqOyXuCIxgR62gbRbm4JxKrQOGmAKfX3GMcrqa7wC3hs2/wW3MoHKS6eDr+2xBBwG3YPaOq2EvSz6BP1wdioaulZjCIlucNZayutKl73OLiLCkPvgM4Gx6K4ofumJYHPzqzmevyvtBChXW4FowPIyjmvv0ThUqsbZYHaQWGvB/vt18wRC64VO3bg/2eT13NHMRtGI9C8QaWCYseJkuuIn6Xp4S/dVxJea6HvIZXfKee2Fvon3PctpPxEwOF3+mHqCeL4AGGJOTSlgvYN1EDtgjwATKVxtZyb6kr/R2yHiOSbUYZKmSFkXm6M2jecdJ2fLUxH4JIDSfaDslBeBZA1wpDcUNqH7Ef5MfT+A2LlOpq7BNcCbvcqeMc3HrfyHa6ySFdm2dcqPP+fJqBj1Hb9RUm/byOPMUxbSwcpCLqrxBdzKSr2Gy+3PCmt42y3zmdw5Df8ZuM8n0CDAiwxNn7aA7JjhgjGNVYDyP0PZ+Jl4QMpgLTVjVEjDUbfhYagt+/Pf0B+zzZ5gH+FI0EboHY3NDVfDpyuPIGkCpWl8680uITBW97DduZAQF5kd3+6K3xuTQgDoaHjey+jf9TVeYOSIaSyN1Rerf9CXyqI35Mm/2SYNO1NlwYGG19hKUkR1XkWFvAPk/Nrxo
 x7q6uk93
 rSXNcqMtgF/ctNyJyu2NzS0M/NIYWWRpdrJCaAoDSj8i+0Tcb7BFN7ldmQmdE9Mwz5kKR+1HDbbcKEufqVez7rf5fyoOIQDII7c7a09v352M+flykdF0e4rXPshuyBjMGS5XfodCDm7UdQZm8ed0dP8nzryrak2oK8oVdxEUleiT3rWmu273M4BQLubsewtmndhZ1Z90gwAu5dQf5HNk9AOeEXztSRE2N285cVJnsnEWeceMKWY0Ej8QX9eUfBkuAOlUe8VxEA7N68l4=
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


