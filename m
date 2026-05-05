Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E611ACD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:08:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5915F6B00A7; Tue,  5 May 2026 12:08:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5419C6B00DA; Tue,  5 May 2026 12:08:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4321E6B00DC; Tue,  5 May 2026 12:08:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3D66B00A7
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:08:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8CC2120454
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:18 +0000 (UTC)
X-FDA: 84733848276.24.0E7434B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 02A9C1C0019
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fIdM1FwS;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iHXcZFw+wF4OYpI6Cnw8uZJYrQ+MXVIiKcx2ZKYmuA0=;
	b=zhvc+p/4IYgDvl0p60WCZgqWWBW2tZeW04Pcb8BQQ5KvS6YlT+rcvqH4urNYHnqeXy8AdE
	nYwx6DR43lH0wUjlmERP1XCpoMheo0B5Xucy0x9cMqZBNQEylyXsci3tIEc8DLEs+oYnwr
	rZPpQTnd7/8NUpOIwyQZQsmca8ikjLQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fIdM1FwS;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997297; a=rsa-sha256;
	cv=none;
	b=0Dp7DPzorNAD/TG2YOG2WjOJ152LMTKQywK8mfc958cuZPNUmNpC2caZdcvPmaEcYWX1xU
	pQGRsjviggBqtKX9xHUrmgj2CxpotVJyZPS1jJYMDRFPRKYZwbvsb/Ajs1IOz6SHOGglyb
	ESLUCWWtWBsM5K3x60hxNcc1Cmy/pZU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C866E2681;
	Tue,  5 May 2026 09:08:10 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 101713F763;
	Tue,  5 May 2026 09:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997296; bh=v82/1vPoSQuONG3WsQV7YwA6orY4PDGaaB1P1kQ48kU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fIdM1FwSO2f6XGsJKrkG/VYHmwB0LijHUxa41oHHt+eexYWn/zSHVvFdi/WjIj5TC
	 CKZbYJoEfEIPR0koypxMh7V++i2dVvWf/FB6mx+sHP3u1WjdfYY0GYSO1UNahW+wOC
	 owgcTiwx2aUZTy4OMoYhxFACve5A/xPX1cLP8fHQ=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:06:05 +0100
Subject: [PATCH RFC v7 16/24] arm64: kpkeys: Implement
 arch_supports_kpkeys_early()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-16-20c0bdd97197@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=1883;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=v82/1vPoSQuONG3WsQV7YwA6orY4PDGaaB1P1kQ48kU=;
 b=erbWwshOH5eSYbyBEexjjPp8WQMR4JDB9K29Hi1KltLPQNM9epNdeZRtpkGDFf1Qo50ePQwea
 Ds0xvNYDolDBUJxj2MoI7xnIpoGZ7cxQVtj2651ujEYLpq5wrnulAVd
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 02A9C1C0019
X-Rspam-User: 
X-Stat-Signature: m1rbbieih1ype9te16ww4uodk9dceeoz
X-HE-Tag: 1777997296-211139
X-HE-Meta: U2FsdGVkX18zFdRsKLjf0BI2gFs1IdUmS8d/CzTb48eGBXupepQvicsbgOiHiwGXle4tTVpvv8Q5AJdaphIi+HGwmoDuMPP7EnW0CxYEYiS471eMftF2YTWzcp1lcItrc+rrBkMjAAlOMAETRxbme1BgrPaHnM++DhrrDqtN9kM1DxckqaNGvcGhM/5mzsBhoiQzIepvzYtTZ4+TGsL7a8xWAKl66zqjEM3ZXTkRvn500Luop0A3hdpvOuCcgfBvAozQq3nt1Lhu7mlHzbk1CPWP9HtLwaIxLqLFT0q0tm7QjYwXEo3l/bCqXwc9JClkd2+oDpdrL0SqKXDuHastvh8tYvjyo7+HVU6BY9F5smq0HtT2E6aPLPniDouXEVs+VsKHfnZcanJUXPLGI4fja7cKcEH1z8elTyi0HdMvcLFvswA1XvAj+1fJc+oxE+2fW2fFVSyQEOVYQTANn5mPQ90ttFlg02BM0ApbEtk5+YeixWFBAUvhwnpI2j2D5cv08WMWrPDQ6ZTejKOUjQsvOSMgyBmt0EjgWgeURfLCeD5l/TRPSqRhvXfoT6iQxgvS6yZ9oAApW9KDSlosNrGYR72v7GsfeH5tSb+t9LnjdI2TSpdVfGTJKbrisxoHY1vetHTfZc3TmkRXla47F/b1PkGIt51FAXgRUlOpfKQWVD9YyInYhVy1BfogF3Nr+QJxlTBUGfCoMnKFeM0jAky6ugIVOjbVqYQAafO+QddYqOpFw6Qh1aYsDIEBAmuYaaMeVJwlev6GCPFWHcimzCttkmZeeU2I+xrbzbXAt78sN7FATkbu0db+gCW/0dyd7FknH4jcZicxGjOIvzUnBkw18tPQn+Wy0MaBzq6C9wYmAo7ewcsTMgtHxnsG+3kX3zZtegvg0Ddjw7FfjwxxbyQ7Yfb6EwybeTG1z2gObwAPPYhoh7OhB6DYVnV45xK+g09K2K7C+kqB+5O1j17Oif4
 sd8nUbZF
 rCt8X7O++gn1q5GMzagCzLES4We6oznhTF3RHf0JDhDcbK2oAOchYtqwLuOoVmJymo75cazTsj5TlMo+xIJ0qeTkYTfK5QEgG4PgJMbXkAZ9h3PX+KfWQifuddME4QTXrXgPhQxwRe2G0uk3Agryj6ufm93be5o1kDiJsiFUKK9h3us1r7/eGYEz2F4jaht1QkWIRQkZxRr1N2orYR0PbXP1hVBIMs3PmtSvl8FSEhq5gGHtrTwcfHGzWA/8XIpE4KboI2l5UBJHq/8kFlaL6/w/6WJSDojv6MjPTjiZpGykHYQY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We need to check if the kpkeys_hardened_pgtables feature is going to
be enabled very early during boot, to decide how to set up the
linear map and how to allocate early page tables. This happens even
before boot CPU features are detected.

Implement the arch_supports_kpkeys_early() helper by directly
checking if the boot CPU supports POE, if it is called before boot
CPU features are detected. It may also be called later, in which
case we simply check the POE feature.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 12 ++++++++++++
 arch/arm64/include/asm/kpkeys.h     |  7 +++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 4de51f8d92cb..8722e9e62702 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -1078,6 +1078,18 @@ static inline bool cpu_has_lpa2(void)
 #endif
 }
 
+static inline bool cpu_has_poe(void)
+{
+	u64 mmfr3;
+
+	if (!IS_ENABLED(CONFIG_ARM64_POE))
+		return false;
+
+	mmfr3 = read_sysreg_s(SYS_ID_AA64MMFR3_EL1);
+	return cpuid_feature_extract_unsigned_field(mmfr3,
+						    ID_AA64MMFR3_EL1_S1POE_SHIFT);
+}
+
 #endif /* __ASSEMBLER__ */
 
 #endif
diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index 7dad3532cacf..ea915f78936b 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -21,6 +21,13 @@ static inline bool arch_supports_kpkeys(void)
 	return system_supports_poe();
 }
 
+static inline bool arch_supports_kpkeys_early(void)
+{
+	/* POE is a boot feature */
+	return boot_capabilities_finalized() ?
+		system_supports_poe() : cpu_has_poe();
+}
+
 #ifdef CONFIG_ARM64_POE
 
 static inline u64 por_set_kpkeys_context(u64 por, int ctx)

-- 
2.51.2


