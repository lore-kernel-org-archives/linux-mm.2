Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 802CEC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F74F6B00B7; Tue,  7 Jul 2026 23:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AE296B00B8; Tue,  7 Jul 2026 23:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF426B00B9; Tue,  7 Jul 2026 23:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 960086B00B7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0D87120671
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:41 +0000 (UTC)
X-FDA: 84964134402.16.0C9B55F
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf24.hostedemail.com (Postfix) with ESMTP id 10B3618000A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jrTdLIR+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 36r9NagoKCPkkuipvhiupohpphmf.dpnmjovy-nnlwbdl.psh@flex--jthoughton.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=36r9NagoKCPkkuipvhiupohpphmf.dpnmjovy-nnlwbdl.psh@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ibpf6/Yw4Qk7w5nMnSeu5NqKAQPPT11UDasodOvdS4o=;
	b=XGK3HpNzyk+DdSy177MnT9cMipL6ixUcm0u9aqrp9T44jCYAI9pGFd4jhhi3NS/gwJCIot
	C+s3R4kf8j9P8qF4mqmCvwRdADfsV6DbUpozg88Zhlkmw7BX/ogshZg8B1JLSptlWOmVXV
	WQSvDDrCGAg3dN776Zy+hrHBsx2EhRw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jrTdLIR+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 36r9NagoKCPkkuipvhiupohpphmf.dpnmjovy-nnlwbdl.psh@flex--jthoughton.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=36r9NagoKCPkkuipvhiupohpphmf.dpnmjovy-nnlwbdl.psh@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480300;
	b=ZoxNlC1ojK+9SgPOShoqMffbQXuC+mOdMXrpekAP+eeBvrrGA112JpMPkn4i35JSdh/lde
	mPn+iO9LAWQUfCozcbFlEw1+aUQx6pHAImpPbkmlYT6KqzG3+JkUWQiKR4mdj5MvLeDGzu
	REigH2JUB4+e67kNIpWrYD6XsYKEUcQ=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2cc5faecf01so7049675ad.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480299; x=1784085099; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ibpf6/Yw4Qk7w5nMnSeu5NqKAQPPT11UDasodOvdS4o=;
        b=jrTdLIR+lUbXLBCeD9fxXIuWIiy4Hb2wBCWC8fRDFk0UCQwtk6Wh09ioTxPoy5Qf1S
         mxoVpUH5vp9Ufm/VtyH1vQeY5JefsvrY8DYvesvVuPoyk0RNtijIr4eVyCXT8eTt+xbb
         ouDAnMDenV2zS4smZw/86P25D9wFjaZLac2zGx+2pmd2DSEfsWPBWBikoKbAkZM05Pjw
         wRGGgZaLe1RahIR74nSq2V4LfEQfcUHTweTUWWzdg5Ie30ltCa2RJQrblN3yIs/mYN2N
         IonZUHxH5lGUPSaYXWQPl/cZnRqtOAOF5IEOPoIt6F8/1nWXLE9QQTkZ85Kl+6avEQEE
         PNSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480299; x=1784085099;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ibpf6/Yw4Qk7w5nMnSeu5NqKAQPPT11UDasodOvdS4o=;
        b=fH+8Ma5ki//SSZMPcQouxyXQCp7TqwKjeuFabvp07B6yhPTnDTjis2lumcK/zXAbrp
         AYWE89FKZqDJYR2gQSPbW45ldHKFWO/b7SaMu5V28JV5urKfSXNsyPksfr3ZM5czC9di
         JLrH2L+Laenno+FKXFyWvXyXQua+Lc+1XsfHendZqyliF05qLgmMPLXANn9obUA2YTwy
         F0ajAt4Ylz1xRNLXofChHXQoaDoTbiZIdiyEWrfKXzqJTluc/7yKjnr9ql/bY3hiyoOU
         GWjo/RpaHyE7k+1Fs6Q8VL/Os1Efxqv0UZyy6qnU6jdZWVso0yrEopv1/HzU+ROK/Dc6
         ERcQ==
X-Forwarded-Encrypted: i=1; AHgh+RqdFUPRKJiLKCj8msfAfd069kRKXRwTgVlE+xFOOYcMEu653GlLIBqonDDrnPGlDxV32XX5Hl4I9g==@kvack.org
X-Gm-Message-State: AOJu0YyTzdVy3I6ZYjvCT4RBJNbVAi4M2K6+NzdInALBGd3iOWO6/MT6
	FNyUB40IDMpM3SCMoqXg5hfXNriKzRMX6XvTGPwof44r1fRwBZ9aMSMr2aAq8WOGcttex9iQIdM
	yUQwVSdKaV9UD+jhaC6LH9w==
X-Received: from pllg11.prod.google.com ([2002:a17:902:740b:b0:2cc:e845:dd38])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:fdab:b0:2ca:d666:df72 with SMTP id d9443c01a7336-2ccea39be30mr7195965ad.21.1783480298875;
 Tue, 07 Jul 2026 20:11:38 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:16 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-7-jthoughton@google.com>
Subject: [PATCH 06/18] arm64: Rename cpu_has_hw_af to system_has_hw_af
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 10B3618000A
X-Stat-Signature: 5zhgyxxor96oo7k9odrdaxzgifwrdidb
X-Rspam-User: 
X-HE-Tag: 1783480299-765450
X-HE-Meta: U2FsdGVkX1+h64saVD5/btg3w67g2pNCT/JmOdRSvQVQFpB3DtSx3wxXSNgt/zZft907oyl+pQOC6ZXt2r1EutTSuXNRF5JC50iVh01/mprnefuEBB3tjmxv6JOIxRq2n5904gWQZ5sgKVP0aRsCQ9uj70B6j/dPa4j6xaoGkFM7XCzK0U/V/zNpkcZ4fo/O8V08Paaaf1AXeQm+m2nnN36ovOilIfhGNvlPoGyP8/T13Ii1eI1Qt0kW7tw7V7ji9XZNx4d3ShEHfiIt9kqx66Q+jPftMAJ3GLbh1jVIP4eolNhT1T9odUMKMhc321KEbNivoKW7+8+kxAYDls46mYn4g4wwNCxd6r+ZU9HFCFnK2v2i+/ULFXg1yTXWyvH2mcnTUdYx8SitzFvn6na828gqNbEmor72dL+NDKOVIHLdpkJMyiplfRqSU+WSW6Ob36bhugnrwtNN8OzF64xPOJeA7gr/N1n5mLO2gz4+lp7fomn6z8EEJrpmY2eVTfHH6zZ6Imm4GlSBxVgNxGx+lDSM9PTpdilmbcIY7zoecizjF7zcnZHW6n4aku+8Zn25N3csp85a2LlM7/ZZ1lOaMhjKwYw35F65a1YWHv8JqmwM5ElGT6ubVNN54GaSJLhp0vqgOU7FbcKYoupfYxKOw6d6ImJWQk8WkaOKEgrxKZ4rln9pwgq8tA8HNI3NKmEmCVIoxkskTfwARJzKt/dd0lq+tcQ0/Zkh12ZB+l7TynqZ9PbrZ4iHGBWFRzg2U1n+WYnCoAoGXWaEso5HIcspR8jG9TUYtXZ9fxJ+cd/a0NauUSoYgNnPJ41HSGZg9evEaxT8kbCXP0GEkbAA6amzKJ+8LcP8Pvk4DKsCpUl455IUisTipxMW1Hph0+jmtUQlHo6D6VJ3jHEj6I7fkZHiP7IlL0TzBx2vz2bbUKHqt/klIilaw/8wA2tICHopuQ2TMZRrMOUWBHWmPqwZGqA
 qjjAe+17
 6deoq18SboBJEa675vutTndkfR3Tlo+C9pBUbx1EnYNxuNT1AQK6XjoUQpml1ew4k5UCUkPywEsFvY3I9h7onfkDQ2o2tX0ZYnl8WSPf+a8oCNzNo/9awnCfpfdbm9EQUO6dZ4TMH6mefjN0QLpPe8bvftUCjm2aDHBIuxzBZ0S7XckYKY+TpCy3YgFzmNh1k/ejC7j8EYIfRfMp4x9jMtMTINpkozkjbxHa0yRoj2hj/Mw5uxRslkvDL437GXlWGKnM+vQYMZvnjM8jn9CejaGIrcNPySjieRMM7wRKdZDT9SvIkVhsUL0PjYOYtiOWjyuIATfmXq0C90DrLxpMjtLre3wOhAqoYOeufHJC5r/oTRyPg6h7njcQ/s6SW5ujBL3C0aOUp3hFiQIUrhPSuFKwEhLtd/XqzCbGey7n+13jcf9NS6zlJ2a62ByhLRjZa4wRx1mMFn1jvQMfX+reYI7/BzyCmWUpghZSOLQNDG6KLXEAOX17cZbH8vDvKYw1NN52dOH6YlbIi3XcEV28KdsaoeJ29tpAKkZJ415VZDC1GC0UO1J4z22nft9a+n1EFWvKW6seaC9hlqnpcraTn2sPG4kGAx7N3j4vw0EPlDYrPuMvcflQp5i16MSB0yHuu/G/W8TwJfE9FTFAzip92DA4HmhRW4KzRBETl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In a follow-up patch, a new system feature will need to check for the
presence of HW AF on each CPU individually.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/include/asm/cpufeature.h | 26 ++++++++++++++++++++------
 arch/arm64/include/asm/pgtable.h    |  4 ++--
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index a57870fa96db..e818ad1b56e2 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -910,22 +910,36 @@ static inline u32 id_aa64mmfr0_parange_to_phys_shift(int parange)
 }
 
 /* Check whether hardware update of the Access flag is supported */
-static inline bool cpu_has_hw_af(void)
+static inline bool supports_hw_af(int scope)
 {
 	u64 mmfr1;
 
 	if (!IS_ENABLED(CONFIG_ARM64_HW_AFDBM))
 		return false;
 
-	/*
-	 * Use cached version to avoid emulated msr operation on KVM
-	 * guests.
-	 */
-	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	if (scope == SCOPE_SYSTEM) {
+		/*
+		 * Use cached version to avoid emulated msr operation on KVM
+		 * guests.
+		 */
+		mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	} else {
+		mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
+	}
 	return cpuid_feature_extract_unsigned_field(mmfr1,
 						ID_AA64MMFR1_EL1_HAFDBS_SHIFT);
 }
 
+static inline bool system_has_hw_af(void)
+{
+	return supports_hw_af(SCOPE_SYSTEM);
+}
+
+static inline bool cpu_has_hw_af(void)
+{
+	return supports_hw_af(SCOPE_LOCAL_CPU);
+}
+
 static inline bool cpu_has_pan(void)
 {
 	u64 mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 27689c62bd25..5f21d3a738ee 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1598,7 +1598,7 @@ static inline void update_mmu_cache_range(struct vm_fault *vmf,
  * page after fork() + CoW for pfn mappings. We don't always have a
  * hardware-managed access flag on arm64.
  */
-#define arch_has_hw_pte_young		cpu_has_hw_af
+#define arch_has_hw_pte_young		system_has_hw_af
 
 #ifdef CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG
 #define arch_has_hw_nonleaf_pmd_young	system_supports_haft
@@ -1608,7 +1608,7 @@ static inline void update_mmu_cache_range(struct vm_fault *vmf,
  * Experimentally, it's cheap to set the access flag in hardware and we
  * benefit from prefaulting mappings as 'old' to start with.
  */
-#define arch_wants_old_prefaulted_pte	cpu_has_hw_af
+#define arch_wants_old_prefaulted_pte	system_has_hw_af
 
 /*
  * Request exec memory is read into pagecache in at least 64K folios. This size
-- 
2.55.0.795.g602f6c329a-goog


