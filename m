Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEE5BCD5BD0
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7026B00A7; Wed, 27 May 2026 20:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55876B00A8; Wed, 27 May 2026 20:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884306B00A9; Wed, 27 May 2026 20:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 718EF6B00A7
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FBFB1A0738
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:37 +0000 (UTC)
X-FDA: 84814977954.01.1B41CF8
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id A1CC54000E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=PIEHqNEC;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf01.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cpp3h87G8qknuAl35zSdpszjamPTiyZ/dw7XF2/OzTk=;
	b=tfJ+/kMTxRc+37x4rTO85wPEGoN2Hpa0TriHGxFESpHIMgRKaWVh22Sihiy2ioRxa7kg0J
	FO+1GWqZMz4WWVWq1Lj3rhAiq4vQkK+5RDwEsqAW0doQvoWmAsyrwqH9r7dt9P4ous8mF1
	zgmyLht8dcWdQI8/Q259a597PWkjpzo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=PIEHqNEC;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf01.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928955; a=rsa-sha256;
	cv=none;
	b=379+MgXVsJqzzNKCiAn5DWrmlYpSc9W8ipjDM3IRQFt85dOFXoEY3I0z58/iSlGMVPFUhH
	OXEwk1pominPPEr7NBT8Az1Gz8BXbjw0Wsg028OEVBUyicq8vxXr2g+XtiLzqOayDt4P+5
	VMg/fS0M+zspcH49mvdJUfUdkko8/xI=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id D7DDE20B7187; Wed, 27 May 2026 17:42:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D7DDE20B7187
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928944;
	bh=Cpp3h87G8qknuAl35zSdpszjamPTiyZ/dw7XF2/OzTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIEHqNECP5CTqhXoOkn4rDFNUhRk3G8ySSEWPLqOtUqj80vbwQHXMFlUQhyAXL6nk
	 Lkhsmhg721K+zYQEUnUOCDla7QLptnzUdto/HtBqJ3+Y+YsgwYNi4ynRenpctewPNA
	 Xaw+l3dqh3iNA2xMzdvnzv7XVsaBKTonUE6FHXyI=
From: Jork Loeser <jloeser@linux.microsoft.com>
To: linux-hyperv@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jason Miu <jasonmiu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kees Cook <kees@kernel.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Justinien Bouron <jbouron@amazon.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Kelley <mhklinux@outlook.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Subject: [RFC PATCH 17/20] hyperv: Reserve crash MSR P2 for page preservation root PA
Date: Wed, 27 May 2026 17:41:59 -0700
Message-ID: <20260528004204.1484584-18-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A1CC54000E
X-Stat-Signature: h7yh97oxksszsrpj315w35u1po498nmx
X-Rspam-User: 
X-HE-Tag: 1779928955-817359
X-HE-Meta: U2FsdGVkX1+HkOgb/PKdud+XGWu4yH6Fv55Es8asxuYxulXsRrdsSq+ql5qNBOydxQl6478/bLU5SBtuV4aOW0xJkpKnO8Xm+yXpsBF7Gue5pZi/5K6qe66iOoRXW0NxEBrd7g+C5Wdju8mYsGxmGDK1Q8wPXcq4U0lgc7HyzaYcy1b8v3Lb6HmEKKlm/htqjcS2j1NMp4SL6+eJgdpN10/fiEGI8gw5/hoQvH4i7R1Hog4zpcPCg+X2BKsOIJ+pW6R+KlK+1RK/y7bc1jWFNNo52vGx7uuYUMs5LsCk/CS+6xFWQCsRh5XFI8rVc3O0vnE0JAtZTyHr5kGq7lqzv+3QzhYRMb9fZusqzRGIJqLWTfu2aOpM2wMmsVJRVOyjihFK+nTdW6dpSf0qPHLUXKlWJbmF0frBjyzvFsG3Po5JpIeBRk42tyYGsy39tr5TYPa5v3tgQqfOUWZRaB21p3McsbwEy4RVjk2O6PQJKY2V91A3h1jnxt7cqqVnzj/TGoSYiNLF3tzp6clOwBW17o9akcERhniKqt1X7tNfS2WoeBMk93v1BQipE593TOi2lUaHypyKESeaeIQLXWfjHf1gzlJRY1Y2b6B31nxLT88i5TDj3svzsiSUlIwMsPRYXK32p9YtDxYlU+FVUMvrrR/vQlfcVkAyQkyvMUKpZnRYbvbQlkkMoX5z60+HBbCOZcE2ETcqD3yXXxzPX8RHPXz/2M+UnNL94PSWcPykzmbPomevZiRQZo9GuiiUjWiG8LY/eSrcOXrpy8Zx4ghW+hcwpS+lVVvu1uKZX/mneXKyLg90AO+rGVPAI4RscdCCuhVVLXm00rOawJssHt+ZYf26Dl6NXv8pIk5gINcbBzPsG1b2fXiGdjJddlWvSzqIufndhDly+Tsnxx7aa97g2ZzABN36jRIoF3eJaZTCau2zKa3iIUwXKyODc7zNpJyemIl21+g6kytD4KlLd6Z
 TVjX5T9s
 zQW8jvgNgMgPTMyWGGPl/PM5NrC3NkGFS7EXZCfiPjy2tIKSpbNyLGX57ncjXNI2+iiulr1UlX5/k1c+Dtjo1+iPYxgWPjHKwPkSP/q6zP3Sq5dp8QmZ161+tHN5MXQJNOcMC2MHhANIpuGatNxNosoTHyWerZ/1CfPX/wOmqrZ7f4oHBHqpN3+Xe9x4PTtPKc/PNUARsyGTQB3eaIRRgNU5OKuGk4ECYQGk2KSUlmbaMv6UXp5WsS7D+BnRPMZ8Bi290
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The crash MSRs have no formal semantics and nothing depends on their
contents, so the register assignment can be reshuffled freely.

Reserve crash MSR P2 for passing the KHO radix tree root physical
address to the crash kernel for MSHV page exclusion during dump
collection. Stop overwriting it in the panic reporting paths.

Move IP/PC to P3 and SP to P4 in hyperv_report_panic() on both x86
and ARM64. Remove the P2 write from hv_kmsg_dump().

Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
---
 arch/arm64/hyperv/hv_core.c | 6 +++---
 arch/x86/hyperv/hv_init.c   | 4 ++--
 drivers/hv/hv_common.c      | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/hyperv/hv_core.c b/arch/arm64/hyperv/hv_core.c
index e33a9e3c366a..b75337c4892d 100644
--- a/arch/arm64/hyperv/hv_core.c
+++ b/arch/arm64/hyperv/hv_core.c
@@ -185,9 +185,9 @@ void hyperv_report_panic(struct pt_regs *regs, long err, bool in_die)
 	 */
 	hv_set_vpreg(HV_REGISTER_GUEST_CRASH_P0, err);
 	hv_set_vpreg(HV_REGISTER_GUEST_CRASH_P1, guest_id);
-	hv_set_vpreg(HV_REGISTER_GUEST_CRASH_P2, regs->pc);
-	hv_set_vpreg(HV_REGISTER_GUEST_CRASH_P3, regs->sp);
-	hv_set_vpreg(HV_REGISTER_GUEST_CRASH_P4, 0);
+	/* P2 is reserved for the KHO preserved-pages tree root PA */
+	hv_set_vpreg(HV_REGISTER_GUEST_CRASH_P3, regs->pc);
+	hv_set_vpreg(HV_REGISTER_GUEST_CRASH_P4, regs->sp);
 
 	/*
 	 * Let Hyper-V know there is crash data available
diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 55a8b6de2865..cd75e2be19b2 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -675,8 +675,8 @@ void hyperv_report_panic(struct pt_regs *regs, long err, bool in_die)
 
 	wrmsrq(HV_X64_MSR_CRASH_P0, err);
 	wrmsrq(HV_X64_MSR_CRASH_P1, guest_id);
-	wrmsrq(HV_X64_MSR_CRASH_P2, regs->ip);
-	wrmsrq(HV_X64_MSR_CRASH_P3, regs->ax);
+	/* P2 is reserved for the KHO preserved-pages tree root PA */
+	wrmsrq(HV_X64_MSR_CRASH_P3, regs->ip);
 	wrmsrq(HV_X64_MSR_CRASH_P4, regs->sp);
 
 	/*
diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
index 8a593117e9b8..ae6415f42f25 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -212,7 +212,7 @@ static void hv_kmsg_dump(struct kmsg_dumper *dumper,
 	 */
 	hv_set_msr(HV_MSR_CRASH_P0, 0);
 	hv_set_msr(HV_MSR_CRASH_P1, 0);
-	hv_set_msr(HV_MSR_CRASH_P2, 0);
+	/* P2 is reserved for the KHO preserved-pages tree root PA */
 	hv_set_msr(HV_MSR_CRASH_P3, bytes_written ? virt_to_phys(hv_panic_page) : 0);
 	hv_set_msr(HV_MSR_CRASH_P4, bytes_written);
 
-- 
2.43.0


