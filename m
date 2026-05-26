Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2906CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 198AB6B0099; Tue, 26 May 2026 07:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 122E56B009B; Tue, 26 May 2026 07:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011626B009D; Tue, 26 May 2026 07:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E352C6B0099
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:17:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93A5F1203C4
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:31 +0000 (UTC)
X-FDA: 84809320302.19.A20F13B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id B204D1A0004
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=raDh0PaK;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ex3HvoMIM3UwXbTP9nnwYzHjGyr80StLeJuDCBjVAMo=;
	b=Qjk60yefaGA0Vv+vApyWM7aoNjY22FmL40Nh1N48HZbue7UFdbhiYENt+ypCZy5NtLiGdq
	BvqwzaaDMhui2cr8h5soMlWzXfCCaI/L6pvU/m0GNmodev5EKRQeNh6Bf7nNWiCaodYzAe
	/n644kQdd3tzI/LBuQ0bApj+nEdnU4Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=raDh0PaK;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794249; a=rsa-sha256;
	cv=none;
	b=E2cAcS6ZxBeuCIvAJtjKqe2tCT5GoeXoX1E4hl2GoYz/2trnAcKuNSbqNUPvSxCqrdaY+d
	d8Wx98vft7d/UEC5v89t9C6olstbbt7Gs7N1BWJA2gBNztL190Pvxb0VBPB6+s8q1FVqUE
	KBRb8t37+xBlCz1jFQj0utuvaY1nJF0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B43E116F2;
	Tue, 26 May 2026 04:17:23 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E9CBA3F7D8;
	Tue, 26 May 2026 04:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794248; bh=t4PPHi7X24sfazkG9K2nWc4u6Ed6AjMWJ5H3R6VytlA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=raDh0PaK4/EH8L2R5toVA8l98hDbyGY6KysUl2a7vLw3yjxEusYRl42dGl/5DCm4H
	 fdku1nNJa57rCCpKeiAvxFEqCwgOIsXfdnErKRIEYrZnYwzijYHrUQ8ouIxTNzYdXE
	 +Q3mA9YtAx1g81mbLtYnqcOkRFtTmSt80SG5XMQo=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:15:55 +0100
Subject: [PATCH RFC v8 06/24] arm64: set_memory: Implement
 set_memory_pkey()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-6-eaaacdacc67c@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=2094;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=t4PPHi7X24sfazkG9K2nWc4u6Ed6AjMWJ5H3R6VytlA=;
 b=e5pMjC0jaX+BcDIZo23dX28PhZonT653oh1aJ8TdP8ymaQgAXPkO7sJ4E+xvbGOq/yGNefzZc
 d2SEKZeN7WTD4oFUBpohE39uolgaJteMWSvQWN5dEbMUwzsx/pbOYA1
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B204D1A0004
X-Stat-Signature: onmjheta97e9jz5o1j7ne4msegc8weqk
X-HE-Tag: 1779794249-477717
X-HE-Meta: U2FsdGVkX1/BXe3W4JsZfdxAWWz5ol42cMfMMtE+ri/GFr7W49PxKdQeBiWz3obAUKDQ8L55L1nx+kuaXBGJsRG5+T00/5JBmG2ulzjbxuOIg7OURllnvEAd/Rbm88JAtDSw8DVpzheTYJnfYftTIIdij3t+Nb4JJdZJXnmyINONNyd4qzla+8OaF/9GKBy4wvZNy08W9FBBqcCYBGXmWZVJs5Ngj10orM2Yb1nnHIWomyeLDy0uQEUB2Rs7U786OkPeQBzmN7cbo7Up2215gfeXkOCnxxonWtUNLDhDS+QokKDNSqiMdUv1Z2RZ++l8qIzWechA+nCPRuYf3MvyRoMpKKH6Nu9BYB/mzPnL6LXy+yLu0XhRY7kN+kc81TvEHWN04YnlT0TLoAFGLIEo01A2m3Rc+2ak4LZIDJxEERNGSKrsHI2Br6V3JVy5t/4BL0OJ/YHcRQMbxnuRwAw8BNT0pIF6I0GboSV18LAu5dK+xe4ie3HDGy2sL+ae5BDPM6i8uXMQ6WjZp+uy6JE6VYs8qSEvmm5UzVHNMWP0eadf0tBaTboTaKxhv1P7sXd5IGlnvdiEnVk3cEhmYz59997z8DG7ansJo21/8uB6RpZTTQYpgV8F1Ua5bJ7NluUK2UEMhpB+/HE14R7M4UNYOVExKfhUpmSCTBxLi8mR3PgfJroUUSINPfG4vsFFDS/L24Kq+L3x09drw2gsBxwtxB9h23YuIdZHAx62Jnmz/SaZICqZ4RalAWi4pCW0ox1bB57tuQE8nb6V4oolA1H/AqjqehiD620gs584OZTY527NaWWiROfaF8bUc1jCjvPo1xZuvy4Sq5cfDbBGKMVD+vnPJz8S/a9wZMbWjnjohUX29+pXCERz1SpmLdYjZCWZfCpW8zA9l4Kkr8wp30mJH0aiPxrefDvWU00y2utMfAXh1XbwYagTMr1w3HMII6oGQ9j4QXYOZBvyWZLec8y
 q1X4x18K
 RzjIwWq/Og5FdmstpRmou6iXjvlHFpi2T4L7SIrjD+cg72RBQNd2PNDGBP2vTvmwIUcY8CQlgXMbU1ODW7RTjt0wCRz3s8tAVuMgQZYLJBVdd9ZsdHJbO70h9fz2tfemWf0ROjUsAbckzQj5AGZhvtWJmaHOhfyBhgIASXRSJWF4nv7lZWYsl43xkw8uB4xVQV4LXR69H1fOLXhVGHerrNfw1+4RKM3y3xWGVmbHalOEU1AYVxA7leK1ky1yNAvIp6c9vn1+7TZtJ5mnDyoaZgTfmBnicjcvvtJt500vHtmPoXCoD02WV+q4FGB2a+FKe7GU7jAwyaHDvIniD7LUmwJdWZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement set_memory_pkey() using POE.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/set_memory.h |  4 ++++
 arch/arm64/mm/pageattr.c            | 26 ++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 90f61b17275e..b6cd6de34abf 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -19,4 +19,8 @@ bool kernel_page_present(struct page *page);
 int set_memory_encrypted(unsigned long addr, int numpages);
 int set_memory_decrypted(unsigned long addr, int numpages);
 
+#ifdef CONFIG_ARCH_HAS_KPKEYS
+int set_memory_pkey(unsigned long addr, int numpages, int pkey);
+#endif
+
 #endif /* _ASM_ARM64_SET_MEMORY_H */
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index ce035e1b4eaf..8f3519400bd1 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -9,6 +9,8 @@
 #include <linux/sched.h>
 #include <linux/vmalloc.h>
 #include <linux/pagewalk.h>
+#include <linux/pkeys.h>
+#include <linux/kpkeys.h>
 
 #include <asm/cacheflush.h>
 #include <asm/pgtable-prot.h>
@@ -365,6 +367,30 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 	return set_memory_valid(addr, nr, valid);
 }
 
+#ifdef CONFIG_ARCH_HAS_KPKEYS
+int set_memory_pkey(unsigned long addr, int numpages, int pkey)
+{
+	unsigned long set_prot = 0;
+
+	if (!kpkeys_enabled())
+		return 0;
+
+	if (!__is_lm_address(kasan_reset_tag((void *)addr)))
+		return -EINVAL;
+
+	if (pkey < 0 || pkey >= arch_max_pkey())
+		return -EINVAL;
+
+	set_prot |= pkey & BIT(0) ? PTE_PO_IDX_0 : 0;
+	set_prot |= pkey & BIT(1) ? PTE_PO_IDX_1 : 0;
+	set_prot |= pkey & BIT(2) ? PTE_PO_IDX_2 : 0;
+
+	return __change_memory_common(addr, PAGE_SIZE * numpages,
+				      __pgprot(set_prot),
+				      __pgprot(PTE_PO_IDX_MASK));
+}
+#endif
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 /*
  * This is - apart from the return value - doing the same

-- 
2.51.2


