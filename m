Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C63FCD3439
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 123736B00B8; Tue,  5 May 2026 12:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0868A6B00BA; Tue,  5 May 2026 12:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB71B6B00BB; Tue,  5 May 2026 12:07:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D7BFC6B00B8
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:07:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B3C9160519
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:34 +0000 (UTC)
X-FDA: 84733846428.25.E95632E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id A18AF40005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QrACWux+;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JyLQGMkLmMn06vm/kkUNE0GYCDkx/TFdUtarmzqVG64=;
	b=B+GP2Ruy0p88icFE8ozxH7DtC88fId5u6F5h8Ead4oOa4wOjoRBousqRPyd3P1+UBFYFxX
	gKKe31e004100ApRBzVx/oai8rzfYAzIMuEnYa4kJr4hMrC76IV4QasriRq5Ha+58+dQun
	JMbroTHuSOCMrrQdqahj6fMc/ewwExg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997252; a=rsa-sha256;
	cv=none;
	b=4NpZEBrHzKZCKCpDShqj8u09MAK4TdmySK0T7U3wIm9FH25yO5xEp6wwRS89m/LenzUHpx
	PpBLjo5N1RVIhY9Tl5pJ0qE/yS9E6pX1T8A3MtupG5EHGweGW+gYATvT7S6TUT4KZN3u7f
	g7IGhcK40p1KqmWK337mEiAOhwrfXQ4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QrACWux+;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5573714BF;
	Tue,  5 May 2026 09:07:26 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9011F3F763;
	Tue,  5 May 2026 09:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997251; bh=MOxM3vj0X//2zRrReh8Xv1luWs/InsWdBVDg3Ey3JTw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QrACWux+Y0e2K3EB4dQ7OfahSAZWS7apJujrQYH3+VtcK6VrCu25MCrxGajhZThFz
	 0zFMzv4GrRq/SYIfiVdgptbZCsUw49e8E6TojIYQO5ZpcAxCyreRiHjrzF/EJIBxu1
	 LFv2lWwSNlblRRrPZ5ria2ajVmU2dqe/7l+nn6bc=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:05:55 +0100
Subject: [PATCH RFC v7 06/24] arm64: set_memory: Implement
 set_memory_pkey()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-6-20c0bdd97197@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=2082;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=MOxM3vj0X//2zRrReh8Xv1luWs/InsWdBVDg3Ey3JTw=;
 b=LKWr4GHr99s7/QBCdOuZ6gEkPmdJUkk1OU+MXQ3fEB9VccuWTmIyKlZcu/hln9mzCyXSHDTAF
 aQ6uKrhEOvzD3qpExIHCeggVVyPxK3SEFqBjkQ07Zt5WEDMBfaKIb+7
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A18AF40005
X-Stat-Signature: hbx56yym5e8wnqdzaxtd5n8bdn4idpqx
X-Rspam-User: 
X-HE-Tag: 1777997252-927926
X-HE-Meta: U2FsdGVkX19Xcexepd/rz1RWL+CDdZFClutk9JDo8oUc4e+9HtNlhMiz0X5O7peDj+bY2bWzgG7UAalPQxS+Ro7wMihmfnJn18v2uF8rXi+mrrVmsN2zvw7kR/QFhgn+82Lb3bEGnvd8Hq0JZ7yBLDY9EfoxoBGigTnnNjiSeE8GH6XhkVHcozYOSSo0WnHucVHcY1aoQCceb2q0OR/jVCFpV15vDz7zRVBwN3fAFDLc9O8VaoaTvtQbKjFZ9ce0WBzYoLaz9XcEmgYBa3p4xIEfxwHR0RCYeZVSGyG9Y2FjVku6mUj6Sf5DYs2QTIc0CIl67D4To1YI8J/mpuZsfMZsbtmyxrNJqw8cwt6O9vsArheIa5TXeAM7Vkiyuu2ed37zmE4QndgSqvWaBr1Cw/preo6cHZVu+ijwKVI1iMlAua4j6KNf7+dP5FABqHoiSu/ucfejaMatO6tV/Udw0haMeCpI0rgxVPQB0AmbC/GmJtbRzpLSGnqT6quVDkj33lDbQ2UB1GVqYSQ+kVLr5XtJLYvKSdqefgJp5XXzEf62+fjNi9dMGjUoNI9OiwWNX6MQPkqT9BaHs3Eo8ZQXrtWvaL+TLKuwu1AgrjJtMnQmbr205fD4arIvvk9bVVWnkKDzyeMgRtzhFoOuelyP3ACaoyuYDoCi4nwaRT5QJIzWSycbAeg4xabC8IptWn8aVu/cJGbWFuZ0sWZ9lGaTTskIrRA3nuQrUCWjFeMOYLO7ZTqlO9veDBmFFsUt9rqJxT2wzEbRalHLFSIp5qRALuZ0yHtOtXhYz6fc/r4u2BvMgOhOt4oTIfOQ3WAKi1VZAmyTNOdhJdnEyVt/At3H2c3M+SpMG4uifWll/X92vm9Aa1+/NolIIhh69cnam3jQd8SnaZBD571bDlC4Bsu1empNT7jmOeEKjKoms2AFAuWmT/cAqlZcNI9uJpT/4jT2uhrtTXyjjKP/O407KJ/
 K2xl/1Y9
 tbWKpfjRTQ5qismmuiHS7H7OsAtBYwxsUvCbb9dWmSc5VnGXTGIP2UsZwcjDwd3dEsLGjjqa5GAioLLYGCUuWj7Q5QWWVTxLwnPn2Y/VrocHek1KRzqyeYBeGjzYXO/0N9t19dHxp/A6p0EOfIO63sV504ICE9YXEAVQbOpS0qwUWsvaptQGmcTLdg1onDeQa89XG8I5uMGpaxjNDeSEv2Uo0L981VkdfnVe5m1vc8qL8+OrLJajm/K8iBSJjbCJvWZfHU+eodBh9pgJVokcHV6/TgqTxhjS58MW3hPCKEYrkea8ahvbbY/Tv/+5u19H14gAs4K8yrKUizYMk4DTmzZ0/yQ==
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
index ce035e1b4eaf..ecdfaa9701e1 100644
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
+	if (pkey >= arch_max_pkey())
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


