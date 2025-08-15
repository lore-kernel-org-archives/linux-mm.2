Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C807FCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:55:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69084900214; Fri, 15 Aug 2025 04:55:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61A138E0002; Fri, 15 Aug 2025 04:55:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53135900214; Fri, 15 Aug 2025 04:55:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3784A8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:55:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1B9B5BB11
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:55:38 +0000 (UTC)
X-FDA: 83778383556.10.5668465
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 60073180007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:55:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DAvN/ymhOC9RH1764Pqdo1P8xtkdW4aJF6g43VRuQIg=;
	b=Ba90DEbRpIecXfv6w1GrG7bO9vRpO4ZE8kL9l2n/OeGpim6aHd6Hqhvk9DbtZUwFUkFNii
	VIXuGC2KDJukYSfdLF1dyDY7dnW0+B7S343i82cSO3mx6Z5umqFbzvZe6RWFYTlvGb5aso
	5zUeP9nL/NN2EE//DRXf5bsb+Nar6Hs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248137; a=rsa-sha256;
	cv=none;
	b=MenQTK3m3U2KML0Qu+JFlDuMmkGWLRaYcLxCSbxcZXFBKdmAb4HAGejJA2RmssHuKi/KyX
	rCCJ+foO8RA+7YTEeNKgLrs2tOKCIhTYmhxIdSGYl29dMRYovOVzFykPGxxA6ZwHvg0Ogv
	r3s3FffSSRxiKVJZA3lNAe1ew8rHssc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00C5E1688;
	Fri, 15 Aug 2025 01:55:28 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9326C3F63F;
	Fri, 15 Aug 2025 01:55:31 -0700 (PDT)
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
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v5 02/18] set_memory: Introduce set_memory_pkey() stub
Date: Fri, 15 Aug 2025 09:54:56 +0100
Message-ID: <20250815085512.2182322-3-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 60073180007
X-Stat-Signature: ogubrnggc6sqjw9ypb6eggyg3jjeipqo
X-Rspam-User: 
X-HE-Tag: 1755248137-308964
X-HE-Meta: U2FsdGVkX19rJjVnM7s6X6IhjpKEX5DF3L0B+/F2eJiHy4Ang5tyuGAQ+ch07231FLKlKgF0URIVxCrJZyri1OCek2ZWJvU+IukJYKWcVtIViwxeRlQOXunXa9YKlJm6zk1HV6MkKEz6M06BrP1HbP6Vi6T7lL6ryqewSXU0/Isa1/ACGcp6IPTlMCKfdwnPEsXbJwzw63xYHkkyAePU3AN+FNMkZ+gBtrf/Bv0mRj36eGqFuv8b1zH6eet4vDh4Q/AYg7iyiR4fMg+I8evYyKNN1/uO50wZL1VqUE2AizsfSma/ikQ0gjaA12wbxgDcJzgx5QyIsQAuL9WCBhoHVR9NyOQUYftLqJgLbxYL5GgCMO1e8tEnRSTr0pGhwqccKU5IVTPCQcAFhhG4Fwfp5GHooOgi0Ck++do/rQae7Tvz9EpE8f/fyEhidYj4NoEPPQkmuNoKQCPLWcwm+Xm3RhTI3a8YaDIi54hIESR4tYAnP3+a2238huQaDAtgomHpxXYHzpfRKwab++SsbhQAUVOPPpsdjceGMEpV9bNBKSKYCEx72y7UU+QVnYkbqDDtC4freNCeHJKyrp5zWpX9LPuE6HQ6HNJNahg2du/k2LAcH9wMhqPmeMB6lC6qH/4cE69KFBgdb+TvltNJfaFiwirbuQj7lYNOIFB/azBzMksmLiHJa1arz4MdasTJoxoMIguMzY78K5I+CLId51upGOpJuigTGJ5l5/9jkanBTPFMyCWBwAiOLo/FqbNkmSa5StvdWIr+XD2D4cqf3GPSt0eh43WgA9ccyqrI38NgnhzsiUxRHCg7UMiCUjIaPa27UfSZlPdk09JnobybYa2mlvfrCyCrkvYfpUanqBD68o2/qHETJRcq+316cllCLI6/QMbfwUpC7/yyh5QoB/FC6Chyibpp+kJmTdilSH6SPyRSpHh9sSaW8LmUGs8wb6zBwobRRsi1y27lshFCyzg
 lqXeyU9w
 RQUqxoAzhZcbu2pMmm/ltLbmAqsR84Uq5gXvnZyWMjKYPljQHymv8uSLtbk5N+h0NbgzGU6TCRKaiihymVxPHIs5ffIS3SDcpgEJecFH6v2kQ0hjwCsDngmn6mSZmtzia0hYLa10fu9mq3l0cAeiIQ1rIIai4W1Izm7NCc/xiIyiWJRKR2AXun/T4sG+Z/mjNenDIcgVCeKytFomKYqVvZDyMDg+Z/ACOFVlSngBG6wwxZ98=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new function, set_memory_pkey(), which sets the
protection key (pkey) of pages in the specified linear mapping
range. Architectures implementing kernel pkeys (kpkeys) must
provide a suitable implementation; an empty stub is added as
fallback.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/set_memory.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5a..7b3a8bfde3c6 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -84,4 +84,11 @@ static inline int set_memory_decrypted(unsigned long addr, int numpages)
 }
 #endif /* CONFIG_ARCH_HAS_MEM_ENCRYPT */
 
+#ifndef CONFIG_ARCH_HAS_KPKEYS
+static inline int set_memory_pkey(unsigned long addr, int numpages, int pkey)
+{
+	return 0;
+}
+#endif
+
 #endif /* _LINUX_SET_MEMORY_H_ */
-- 
2.47.0


