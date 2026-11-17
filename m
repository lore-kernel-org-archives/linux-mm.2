Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDFDD606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=rYq6QArb
Received: by kanga.kvack.org (Postfix)
	id BA3BD6B05C6; Tue, 17 Nov 2026 02:07:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7B156B05C7; Tue, 17 Nov 2026 02:07:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91146B05C8; Tue, 17 Nov 2026 02:07:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 729066B05C6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:07:15 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C57DE40343
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:14 +0000 (UTC)
X-FDA: 85443729588.15.5C434CD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 29D3B18000B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rYq6QArb;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899233;
	b=SzGgoxTyfIsDYSM7xh8qrSeI7cgy9CFuc8wr/x+icsnSEyXQhxXZLU2KYD37C7kSkm3r8C
	UCPSxvudUusBFwrCAYyDzFNLZHdiY2iJnF5O12TdBNzvkf6a7M1KzQgKHVWWrMTOBkbQtI
	VTud0MUY3HVGixC39pEfsR6D8KRpIaQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mTjrX8BPMgEQvF/l76KpwD+d59uY8XaGkIgLG0DayPI=;
	b=UxtO+NxpZ0QI2tOpL0YUx+GiPRzbbrQTndTwzYWnhzcUXYYrhsG96sNVuvFBJf3bTHsA21
	lNb4jo8EfktbjqLLGpbWM3B0BI+zWX1V9oT1ZxkW3sGkyeV2BxxVOpcW/iKvShLp3VYHyK
	rVgRj6DYMHZdYVbFBokZS0y6xZiczGQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rYq6QArb;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C1D21476;
	Mon, 16 Nov 2026 23:07:09 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A32693F763;
	Mon, 16 Nov 2026 23:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794899232; bh=rJVnBpFL56QP0tzbwghdHJEf9E+Td6sJ8tYNwYNyfgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYq6QArbfWSLm8uS4OkY1zm8Ij6CSl/yN+vvIKSfIqJ+H9evA70BjDxNkdbkDldEp
	 eXRqqVIRMJQMqFwLfnwstjodMH4kyKA1Ac5jzWKcjLNGqKROOSWRcuOro4tf7HXTU2
	 HA2E7d0rj1VNO/iTkODSsEKMM85G5R99qliEUCJI=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V3 13/14] arm64/mm: Make ARM64_D128 selectable
Date: Tue, 17 Nov 2026 12:36:12 +0530
Message-ID: <20261117070613.1183243-14-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117070613.1183243-1-anshuman.khandual@arm.com>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 29D3B18000B
X-Rspam-User:
X-Stat-Signature: 9ah1abgk3tt6mndqtzxesincyc3kngps
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794899232-454267
X-HE-Meta: U2FsdGVkX18dkyh80aUcltUcvUqbdfp/NOlGjEFyHK2xgdfVHznRrTRsx/j3SAdUtS708aTH/6cCmdK/VH1FxQCc9WG6Wl/71uf2rEvBiihwcb5cBH2SfU5dEj1GBAuNglyet9DYYnQF2+WpVFaajD7EIWonEBSrT3pw20Za/XYKs57qK67q4zHjNJNbd8qYOS1Cf5gdD6Bk1Ry8KSNxn4itG/4PsghDMf06DQDOXmfJVPBE3lV3RqcBx39yFu4P9dE2j3BEV5ahcu4wZoJbVHYZJw7fsB+/J4thF3N42cJh8HN2yU+C27VEHn4VS1OPhWcSGBAt46QiRSOU8Zo0daTJ30S+E6Xw1T/56hT94oJdTAiV82Hj/ycBb8xorXb+rmbByDG+70kuoXw0V+8t6ntIhL1vnVOqlWRAa7OYRiKNcSPH7qG4m4RFYjxGQarIMlFd4Ysj1qEuoytcgI1ansdj3tu9ngKb5fbzxqKaeFjumoEKu/B4t21FYzjMdTmD+A9GcZGT1bLMVyTVyCCEn1p81JkbPyhF7Nl/T/PEwTWjxO27HZZpDFnaKzwIu648xJuanbTz/qIe3phzoQw9heIZk0NVGRbo7s5IKgDvdk2QANFPHlR58LeOhwEnJHz2zinCV1C9i3IxzkRIK0U1aHIJXkmthcJoxa+1/lwZfPzEM71Sa3XhAV+0G+mBZqjePiqa3thPzN8dGIki3xVZ3QT9N0+kriKk+hl7ExXu6SzSphXKHSAik03CYZ50/HUa2xMMH9Uu8PuuuSy3HbE3KPoXSnmZag44zhl+acBxTQgO0QhuaOWpZuwDdGYncF7TwUfDPjn1nB42q0OTNCh7S5h1tvjYAwzhlmEPBkzNlCp8cq3w9Yc7JmUH43Tvx3ZfbQy3tsWK4wizvTJC0Fbnk8/vgR2xPJ6otQNMB/NpnEQysBpP0sj1C6/zbWD07FB3hNxL1bD8KnRxlLEktxi
 HSXFq3jv
 ioexkq2CB89Z7ZB5jGJdGEoI/J6nxemVy6IGzq2a2d4m+gaC9umnzfznr6FjF6q89vH/PBbA0k3yn0zRz5Fg3he8w6dZakTLrFHU+bAgbSHBlN6lZ5YuOoBJ98e+iA9q7s8ZiNTHMF5/B2y4zSahJ8JZ/nKJPsaJPEmun3DhQbxH3+d7TADV9D/FCyeE/0lQx57UxuMZ+L12fBt55YhvTbcyL0MhvQzlHlQepOdnBWx0SoL4Z7/F1QQSFngbWqrGaalcBN338FPMcZXjoTVg/g8hxQq8jBdc/1oiEK9SMhoLbTshTsjXcaEfj0KisC0s8rp3ev335Fz5I9UV2wl9YbJI8QzyVDiadaLjZvoCnDFqIk1M2JDDIpUKTVPXa8Kz2nFnZHrX0X2sA+maPaWDFPjx8huYQi8lzenKeUH3+AeMOtcuXRBkRyQYjnh2zXi6MNMw45jP9YebU0LeC8Db2r/joaS5RYjEa+SrnHojzhaeDofRp7HtfeuhuO+7eUZT1ingbwN9nwa6WFgZcaN7ip6jIVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
 arch/arm64/Kconfig | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e54cff118f8a8..83faac63e5612 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -272,6 +272,10 @@ config GCC_SUPPORTS_DYNAMIC_FTRACE_WITH_ARGS
 	def_bool CC_IS_GCC
 	depends on $(cc-option,-fpatchable-function-entry=2)
 
+config CC_SUPPORTS_LSE128
+	def_bool CC_IS_GCC
+	depends on $(cc-option, -march=armv8.1-a+lse128)
+
 config 64BIT
 	def_bool y
 
@@ -2385,8 +2389,17 @@ endmenu # "ARMv8.9 architectural features"
 
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
+	depends on !UNMAP_KERNEL_AT_EL0
 	default n
 	help
 	  ARMv9.3 introduces FEAT_D128, which provides a 128 bit page
-- 
2.43.0


