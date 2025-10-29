Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87EBACCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F148E00D7; Wed, 29 Oct 2025 15:07:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F168E00B2; Wed, 29 Oct 2025 15:07:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4C728E00D7; Wed, 29 Oct 2025 15:07:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C35F98E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:07:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 71DB41608D3
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:07:14 +0000 (UTC)
X-FDA: 84052084788.02.5ADBCEA
Received: from mail-24418.protonmail.ch (mail-24418.protonmail.ch [109.224.244.18])
	by imf23.hostedemail.com (Postfix) with ESMTP id 96DA0140007
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:07:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=OLK+mYTZ;
	spf=pass (imf23.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761764832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+GI3JCHWjOQcFbXmMHTXI5iGSfAXcKKoBJ+NaZcg5c=;
	b=la32CFF4mjrHkwMgLKiFOMTouM9E8Ds8qRqzvUUalsNm7Uw26SaewKZw2UHCsQK1InsbkQ
	tVYw3ErR2K39iYwacbADnnj5LRk/okmm8E7tpvisZGJFbo28xliCXaO/VpDpthgGUbxsxR
	c+1DXiShfrlUOVvRGxNGkorn2dYf4hY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=OLK+mYTZ;
	spf=pass (imf23.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761764832; a=rsa-sha256;
	cv=none;
	b=i06TNNIQUXhKSQP3ZXS02wqvqKRXh7Jf1q1suyZMqlVSuEYkDd+Jjs9PJkFjaPs7s7+dvR
	p9X/9Abh3T66sWqAXcdPDiaUaZuSf6Txe0C4fqLb3ZCHl97Q8RqtKVmhoaPS2eTyHhkbKd
	qfaBwYOqDN6H2eeEOrYYreDoScgU83g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1761764830; x=1762024030;
	bh=V+GI3JCHWjOQcFbXmMHTXI5iGSfAXcKKoBJ+NaZcg5c=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=OLK+mYTZss2HUSw9NfQJFmBZXPQpGyO18z4fzmKhditcec3bCsPrPoXyhQ2UsC2Ra
	 rAl5/2CYQI+Y1mMVRPqPEuOOiBjJHK544HtwILnNJT5/FKFU/v2pjnyIqXshlSmKEc
	 VadPr3Md0c5XXKXtYdnRBxE4zYRMSH50w+hN92Mg8Mv8P2KQAGZRBKBKqEStGqf0BM
	 /anLMmHFeqGGLt/rMS4Jqu4Xq1dszXRzP7qoEacCQwdD5XaLd82s2oXhsRREEJrf5B
	 3rkW2LUFOlJ4uHEyTIgUZpV2j3EWms0GxjcIoQ0nALLhlo0Hqiht1iraRW9TnRf3oG
	 iDVK81uAmCuwA==
Date: Wed, 29 Oct 2025 19:07:05 +0000
To: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org, m.wieczorretman@pm.me
Subject: [PATCH v6 06/18] x86/kasan: Add arch specific kasan functions
Message-ID: <5be986faa12ed1176889c3ba25852c42674305f4.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1761763681.git.m.wieczorretman@pm.me>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 78312123e49b3e9b61a0495ac0e750673eadf38b
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: is5btjtrm1b88h6arpcq57t88fidubxk
X-Rspamd-Queue-Id: 96DA0140007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761764832-624466
X-HE-Meta: U2FsdGVkX19SzTcHl8bgDjpCDjazrxdmsnudu3/ZebVR0pnXIPT/xcqNEbsj7Ye9T7wYY55mooXVVbVR9g+PCBf0uqajeFXNgXRAP5JGQ+iKiSIC4rSFog1c5nB0XNqATZA1rxSZhE25u23LR3l+mpXU1SdTBiJVTs637jTUSVb7I86EszvFElkikg9itlIPccfGsx2QfNJiAhf1W/xZEMsj7JJXL4EwBvPWq3OGjzBkXDw5ELx+SVRmZjvDnc81KbaGYqLTK5CrQmcrHG7zWNYD/M0UdAsfOP2zu66ZZdwIuH5dPRsBh3TuvWTPN2AC1zjDMWn3utgFNqClYZ22OSl2CfxxsD1pnx/ZIfX0l1pZ7cN/XHXHbb0xxL4pcy030Aoh2GBGsKnj3WaUHqf4MJZpbewWOEeWumwbpN4QQpJFxW+jwZSQUlVh6P0YLc9I+8puT2+6s/iIPNagTUYsidoNlk37T03MfayYPS8mhhg7dEyCA49Y9ONYzoZROir3prHUDRA/I2nFbiF+hRPc/b6El+0Xekt+ZzvzFoXCXQM3R1L/PJt9R+u9xNwVdaB41DV8sUg9hhrNtsmWDM8sLLG5/QvLOz1C8mX9jk3e4BDBZNAoxYWNuM6XX1vMNkW3YVNhheJ1ghf5K/NTvQ0bD1jFO458hbYA9T0Tc7lRlvjMehj7YATxUAVOB34l09ln3tSAFhqbDYesCaqPHirjfZyHLEnIqOCaJmb/bycuq125EKB5PollYAwvunrXz18vjZOmfmsRpDeQlE5Q5iTO4Tf4F525B7/EqEeDTnQNddz/ke8MftVqgemtx+2ZGtmCuCudLdleMW25CR0iv30+ZzEKApEgEO73GPA25q1dz779Bit8vZmeo6OF9aDpzoAanLO/kK8spAwC7dj/OMkPHrzF3yOXYJN6YeZnrEuaEykPhsmtIbXd3AQEIrX4Muefm1qI/dbR7T2yQZWPaYW
 v8AE4rFk
 lBvAaFUfMET5yAJ3+IgvKM/SdcAG6oNi2/woXS0oUTc2DT4PKHgxS7+aOglh2Prgx49SY9g/f+3xAiSYuL8Je0gtikMPik19mefgyE/Y1OjcYz+6syywqHF7lDSbsZXPESNRIAmHzmnaoDnDsw7a2FZgV7E/BHBmewC+WLzxIIIbg7qEXVfD96rnqqI1hkOpK9tu12vUZj7GkADaovU8XcSFKWSCBQ4awrtBVVdeosDL/sFFolxC9RWhprOTqrFxP3oLN900/brUIAiXUbznIY3bbB8oFy4yRX9MrYU0LobcfUMiCk0vaA7MyeFlCrCO586dCN1+vBhMxkts=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

KASAN's software tag-based mode needs multiple macros/functions to
handle tag and pointer interactions - to set, retrieve and reset tags
from the top bits of a pointer.

Mimic functions currently used by arm64 but change the tag's position to
bits [60:57] in the pointer.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Acked-by: Andrey Konovalov <andreyknvl@gmail.com>
---
Changelog v6:
- Remove empty line after ifdef CONFIG_KASAN_SW_TAGS
- Add ifdef 64 bit to avoid problems in vdso32.
- Add Andrey's Acked-by tag.

Changelog v4:
- Rewrite __tag_set() without pointless casts and make it more readable.

Changelog v3:
- Reorder functions so that __tag_*() etc are above the
  arch_kasan_*() ones.
- Remove CONFIG_KASAN condition from __tag_set()

 arch/x86/include/asm/kasan.h | 42 ++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
index d7e33c7f096b..396071832d02 100644
--- a/arch/x86/include/asm/kasan.h
+++ b/arch/x86/include/asm/kasan.h
@@ -3,6 +3,8 @@
 #define _ASM_X86_KASAN_H
=20
 #include <linux/const.h>
+#include <linux/kasan-tags.h>
+#include <linux/types.h>
 #define KASAN_SHADOW_OFFSET _AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
 #define KASAN_SHADOW_SCALE_SHIFT 3
=20
@@ -24,8 +26,43 @@
 =09=09=09=09=09=09  KASAN_SHADOW_SCALE_SHIFT)))
=20
 #ifndef __ASSEMBLER__
+#include <linux/bitops.h>
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+
+#ifdef CONFIG_KASAN_SW_TAGS
+#define __tag_shifted(tag)=09=09FIELD_PREP(GENMASK_ULL(60, 57), tag)
+#define __tag_reset(addr)=09=09(sign_extend64((u64)(addr), 56))
+#define __tag_get(addr)=09=09=09((u8)FIELD_GET(GENMASK_ULL(60, 57), (u64)a=
ddr))
+#else
+#define __tag_shifted(tag)=09=090UL
+#define __tag_reset(addr)=09=09(addr)
+#define __tag_get(addr)=09=09=090
+#endif /* CONFIG_KASAN_SW_TAGS */
+
+#ifdef CONFIG_64BIT
+static inline void *__tag_set(const void *__addr, u8 tag)
+{
+=09u64 addr =3D (u64)__addr;
+
+=09addr &=3D ~__tag_shifted(KASAN_TAG_MASK);
+=09addr |=3D __tag_shifted(tag);
+
+=09return (void *)addr;
+}
+#else
+static inline void *__tag_set(void *__addr, u8 tag)
+{
+=09return __addr;
+}
+#endif
+
+#define arch_kasan_set_tag(addr, tag)=09__tag_set(addr, tag)
+#define arch_kasan_reset_tag(addr)=09__tag_reset(addr)
+#define arch_kasan_get_tag(addr)=09__tag_get(addr)
=20
 #ifdef CONFIG_KASAN
+
 void __init kasan_early_init(void);
 void __init kasan_init(void);
 void __init kasan_populate_shadow_for_vaddr(void *va, size_t size, int nid=
);
@@ -34,8 +71,9 @@ static inline void kasan_early_init(void) { }
 static inline void kasan_init(void) { }
 static inline void kasan_populate_shadow_for_vaddr(void *va, size_t size,
 =09=09=09=09=09=09   int nid) { }
-#endif
=20
-#endif
+#endif /* CONFIG_KASAN */
+
+#endif /* __ASSEMBLER__ */
=20
 #endif
--=20
2.51.0



