Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2A83C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECE886B00B2; Sun,  6 Sep 2026 23:51:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA9546B00B3; Sun,  6 Sep 2026 23:51:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBC726B00B4; Sun,  6 Sep 2026 23:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDB476B00B2
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:51:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78AED8064E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:51:26 +0000 (UTC)
X-FDA: 85185591372.21.8BD6C51
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id E5F4D40008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:51:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cf4fVwxI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788753085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KAvzBvzg6imid5AikBY1vN1K5IfehJLW5pCyJnTwJvo=;
	b=Xl4bBoENdjagKrgz94OcSMOG8xTp8Rm9DgOULK6p27CPJQNzuib5pjazUIq2aZDNniaTwf
	DzBe93Erb3UOhTiv5Db/oh7zkT51r248CwRk6pz0aXYyGCOOg5w6IdmcogweCD/ynbsG3o
	/Rv9T1n8W9trDiOs9nRV9VPKax3hwqo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cf4fVwxI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788753085;
	b=0zshiXy7HTc4xUI4nYjI1iQx3uqBnfWvyoJ2/eKVBOgxlz3oDywWoKrmmGCeiasBQav5eY
	JG6BHCFJ1V9WoN2giizcRuufbc00PCTKu8gyl8xLCaDP1Sc5c5bEJcn1py/Bwal5g7f5EI
	u7nbGuNhlMKHgOv93mi4a5AAS9IQLWk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7612D1BC0;
	Sun,  6 Sep 2026 20:51:20 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B7F53F7B4;
	Sun,  6 Sep 2026 20:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788753084; bh=mwPzeOmFdvSni4XKS2FMhb0rbVSwZIBkk8UWH/i+Cdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cf4fVwxI/mmmgyaiTUIT/ejH9+XvsNL/MOGeyLViRVFbSZVWf1T80E/Cg3+gFm2UJ
	 cAIt+R9hrBwm55yxbTxLbtLImTnzRHfdm1A+s2hyROu4uh4fh9RI+VdEgdms7jNlMP
	 AabfhMhqjw06n1wosd7mIREPGtAeez160qFYBaVM=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
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
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V2 13/14] arm64/mm: Make ARM64_D128 selectable
Date: Mon,  7 Sep 2026 09:20:28 +0530
Message-ID: <20260907035030.2839978-14-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907035030.2839978-1-anshuman.khandual@arm.com>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5b9uexcrdfwpqbic4gg71faxoo7yzb5p
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E5F4D40008
X-Rspam-User: 
X-HE-Tag: 1788753084-866985
X-HE-Meta: U2FsdGVkX19OwUGvbQij6YOxljzeMw+QaXQe6U9SL/jwsyakvk+EvfHm7u6xMGeADihJ1Wjaqi3gJShx2gaXy7MqYG6Rya+U6Mf3fl6Qx1T7iRD4XmHmIvlt8noRKJiiglseT/hsvXjTiqIgmu16tnpdUWWwxi2d/GrijK79Gmn4ba/oXx3469+OI5AMvijEzx5xBpNW2Z23tSKkAXWvtQmndu4m3vwEKI4bx0sYTyUFxJxj7ljy61UngziLe6FLHiFHJ4bG1Fj+u+Brj+yYGxwQe1uT0nzaAQg3/ICxW7tKhIwJxyPYizQPmRQOpAnT2VuzbtBdZ1u5sy9dcdFA+XlEhvVKWmc8yZGj6c7vlwXAaPbZ5sG31Xm4yqkAGNzmvGR+N+fClpuapJ13TZCszsDqAlvhaC8m3a6lAggxZsPJGmXakP7yOtsQv85uZdOkQ4HLpCfWwglliQrCGUgNG+eLyb8Q5nXYVsYJy0cl3COhyDQJzIEe8kWguK072uhYjUIeFgcZigGH7hFzp/1J2tW0VRLuzaT2+rRwznGVumi7v2c6TITulk0UA7SZsrVFxDfzdVdrTxeSd+S7paneL3KxJFY1dGtLw4cj1HEIHhn1TDSesU55BnYEH5CGl0et4uCZgTQwr0EVxXTP6cBvbMhf0eZWwvgNcdk91XajcHExto7SWX4v3GvKpSrTMPQH4jUm30tS0ryyvEP+xK/835bvX7174uNLhTRBpNxEfLdcFfwZWaL8ZfKc5D6jyGNj56tT150hZz+SmDZBcO3iWTYABSCMRKqScT7BNY2+WofNbv6xohzfOZAipYXyUp64exzoCWBhwThC3fAJojnjs3fT+TxvbwaEVyzpQnsyRiF6n4SEHuIYyhhryoWwdPn+pMGbydWPL4R811qwewRAhaacGMm5WoQzmQTZBhVLVOfBmumPcrWI/vcWmmPvEP9f6/3IgE7gVn/iCoRb4GM
 lzv1gE/O
 Vz9MmH5bFK9j1SrxuK59LKPMNvI5OCT1apoVa+TwNxZx01wII3qbjM8i6Xm0H2KZWClkiRzDpu6RtP2BMgP66d6Tm4RJeuFFBT5pU060A+VAot/2zIcZUTmFVScP+x7KDY90l5BQGcLBttkLvfoywzeju7i0KWRNlqKEUJgsDfhhe7o6CNd19raJPWU/+0NUspEOQh4+KPDtoj0f5/W8ra8Ge2LoMli8PS8ZtMiT07vtw9Q3srmIX0qneGo0qZAugrnYf7Euuz4IzDepxwVpLQ+sWE6ij8yy1q/R5TTROVRBBZ5r2uPJMiIBjAYMklpn/7gtw+uQ0NbkfU6aFo/12xH8zHlSD4rVn3LpsUO+JPbUvlPy5j8p/0+UgJqHoYHaB/Twf47x11p9B1m4Wu+gcMMa8pdwWgAMhexgu1ZQkZJePqLU=
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
Changes in V2:

- Dropped !KASAN dependency from ARM64_D128

 arch/arm64/Kconfig | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 306e6c803471..483eb6d75c7a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -276,6 +276,10 @@ config GCC_SUPPORTS_DYNAMIC_FTRACE_WITH_ARGS
 	def_bool CC_IS_GCC
 	depends on $(cc-option,-fpatchable-function-entry=2)
 
+config CC_SUPPORTS_LSE128
+	def_bool CC_IS_GCC
+	depends on $(cc-option, -march=armv8.1-a+lse128)
+
 config 64BIT
 	def_bool y
 
@@ -2305,8 +2309,17 @@ endmenu # "ARMv8.9 architectural features"
 
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


