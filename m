Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEC8DC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C132B6B0149; Wed, 29 Jul 2026 10:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9C706B014A; Wed, 29 Jul 2026 10:54:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63A36B014B; Wed, 29 Jul 2026 10:54:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8158C6B0147
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:54:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E18F58068E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:26:21 +0000 (UTC)
X-FDA: 85041736962.11.92EC669
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 492F240008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:26:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="s67r0/xD";
	spf=pass (imf04.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+/GKX3IjH5uKDq/8w06PcQUyEeksBuMAx7kcby96yrI=;
	b=e1/lwQ3wRHOlQkyx75N5oqKxpFWXO38ZFY1tVhfnpLKb/RBhyLlF/7i9TPTg3tozNjAJQd
	SHueMBO+XFZSDyWrlzZAehcSLlRYJP4gHO/bqZ9MR1b3ACL1Ifc5YTk1V2c2UXfnwQv0Zk
	T+atfnMAYGvOWz3c9sK/A3dxK270qAw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="s67r0/xD";
	spf=pass (imf04.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327980;
	b=8IrT70EYJGofYijWIECSWfFpf4TRmXmBU5o3DL6tJI3eftDjubGtqngYYPx9cPd8ZJqwQ2
	vwwwqm/AUW+qW/JquBtKdZHZiZZxA5qmL5t2Nh4JA7+mKqmQl4dmM1RVFOGcOuVrqTG68a
	Bueyh2BLTJuLyTIfMsgyEya098/VgzM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83E05168F;
	Wed, 29 Jul 2026 05:26:15 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0B5153FA1F;
	Wed, 29 Jul 2026 05:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785327979; bh=M2ps/0zfUAQBr8mTpjkLtUW0+CfbGBqydB+0Or/9/Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s67r0/xD72kclPDh9SmJEMUoTLUiZAEmItMV562/z0Xu6NVG5VAPo/wXYLoVJga2o
	 k7OoO5MI3U2AaN4WbbcMkqk/uBph/b4pkZOms7lF02ZRkW/M3cdJ0N/kjt6ej3Sz21
	 TAQqFCE6T6YgK7P17Zf0WP8D7nHkPyHeqn3zxT5w=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 17/17] arm64/mm: Make ARM64_D128 selectable
Date: Wed, 29 Jul 2026 17:54:52 +0530
Message-ID: <20260729122452.3797443-18-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729122452.3797443-1-anshuman.khandual@arm.com>
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 492F240008
X-Rspam-User: 
X-Stat-Signature: ppryu89bkkt6sn4w6dxcb5imaa1irz74
X-Rspamd-Server: rspam04
X-HE-Tag: 1785327980-127566
X-HE-Meta: U2FsdGVkX1/RCRkTsCAeIHPq5XfOPCM2k/4MD3u7TAk9gHTBlgzqex4NNSJVKBl+ltHgFuWW8sXvC43+jab4wgWBDxnthpdEzWaLwUnLv19tcVbcETMe2HJa+FxKNRA8qdEdYlKQwd/j8rx3YLNFBon74/wroyyVsx+B/n0x5SMqz4s0JPPaWB/krXJkPgRQcbHynpZ7iYGXjefbMtoBavcA4FcJWH5sfCDnWc9CvWw6YN4I+4WOhjFJWsCebhEBOv3kS7v5CAdyhPvYq6UU5HjqBtJP1QbQfEU2VOHAPhVjohSwgMmFhgA/kjPvjL+YIObekUoM00jNC3DiAuk58zkrhFVESpe5M5EkNutb50mpvRl8GIxkiC/jUrgAQOrjTIQ1U6Bo7mfYvKE8kuqAbKTIut9xlRiskxUweB8GWSiZGwtQC8Y6BLoKmYOfKtTrGGVKA0b3CXGKeUr9lu7uWMqixB8oMbRpGsJsX1gW89hoL6cN7JDl4M4VOYShOmuU+1jUH3P8J0ACc+MWYf4a+2pCEpTqfrUSbbEL1hE1ww+DahptxZ5GCbPY44xs0Vn+wCleTxJeKjIWrhUkNUvYny/J3k3P0XgKTB25o4mFSxQN+0ydWqEFVaVHtHT+nWz3oEHJEI8jNBFi7k3kfEpstZf3N6m7RnQi98sGwQev0gewfz8Rswp7cnzUNJOAol91s2LotmBqsitWJ0chci15ttlXRqHdkz+6N6e7FH+4JFJaSxYqnmI1UIDM7ZQwz1yEPtv2tc/653ecqAIaoEfZHt/JqRxtSjxYbGdMw9CbpOklrUSrBV9+NX5rgQMG0hZbn4uv8tat2cSKdNp3fB7/q+rUK96O/BcZ6F+DyIKkEy9qpWqwyy5yLYui27aaJJeTYE6EsBWitwXkWGNqm00pDluOTBHYJRqXn72/ctpxweP/I4YGSWoK+w06ZPdJ2gCK0cfwb66hPvhCuxhporg
 vYweCE17
 thKzlVt9ilsE/Ywf0B1nPfU/BpkAJLqI+lpAR+/tb8fVu4VOqKDUAtI+13nVIWqT4OER3XF8tKWEmveNWKStRIYAhUxpdbchL+oKEbH/Ih/TkfXdKEYfLSVBB3mtywlhVjpJRCQe1nh2UBgs0CPL4y6JRwkKPAf46cvaAnVBtaJR3qO4jCKSMOKaU3KSNVuGSJst6Bibp/baMbbF1XKe0a35N235HtkapSJwUh2JFLkCq6qkxvLMm9k9a9MHIELIPFAch02X6EtN2JbSCvrZSGZX6MdGiVZ1zw+pwVXp4vKJVGMDV2UsU+SIvD50CLoe0+3t+cZ1Iq6EMIwzAtfjJfAnB1kiMkVgoGHi+QSvJx1nTYWc0y7/Io5qFUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All required changes are already in place including the TLBIP instruction
support for enabling D128 translation. Just make this new ARM64_D128 user
selectable, after ensuring necessary tools chain support required for the
new instructions being used for D128.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/Kconfig | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 8459d43afd45..6c88906d48ec 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -275,6 +275,10 @@ config GCC_SUPPORTS_DYNAMIC_FTRACE_WITH_ARGS
 	def_bool CC_IS_GCC
 	depends on $(cc-option,-fpatchable-function-entry=2)
 
+config CC_SUPPORTS_LSE128
+	def_bool CC_IS_GCC
+	depends on $(cc-option, -march=armv8.1-a+lse128)
+
 config 64BIT
 	def_bool y
 
@@ -2249,8 +2253,18 @@ endmenu # "ARMv8.9 architectural features"
 
 menu "ARMv9.3 architectural features"
 
+config AS_HAS_ARMV9_3
+	def_bool $(cc-option,-Wa$(comma)-march=armv9.3-a)
+
 config ARM64_D128
-	bool
+	bool "Enable support for 128 bit page table (FEAT_D128)"
+	depends on ARCH_SUPPORTS_INT128
+	depends on CC_SUPPORTS_LSE128
+	depends on AS_HAS_ARMV9_3
+	depends on EXPERT
+	depends on !VIRTUALIZATION
+	depends on !KASAN
+	depends on !UNMAP_KERNEL_AT_EL0
 	default n
 	help
 	  ARMv9.3 introduces FEAT_D128, which provides a 128 bit page
-- 
2.43.0


