Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB80BCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43EE78E00F2; Wed, 29 Oct 2025 16:11:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416928E00B2; Wed, 29 Oct 2025 16:11:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3078F8E00F2; Wed, 29 Oct 2025 16:11:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A1E88E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:11:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E783BC04F2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:11:11 +0000 (UTC)
X-FDA: 84052245942.16.F346FF1
Received: from mail-10628.protonmail.ch (mail-10628.protonmail.ch [79.135.106.28])
	by imf11.hostedemail.com (Postfix) with ESMTP id EDC0A40017
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:11:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="fzcdT/Mg";
	spf=pass (imf11.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.28 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761768670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpGuNHZZR4hchfLUKKttSmaxG+W37eMF01r5+dBbCBY=;
	b=4G3nNq8Jstnxiybz1Fv0Jp6QVGGCxflIxISRcQnf1x9wrczuQtGsut3AB8WxZvOFPZDpLP
	Ab3W2hcWyeD16xe6cPdOJ76Kiwi2lCcQ8SKCRAUIXYay1I7pOfRvA9vTdBbuuqBF47Bwaa
	bFFxZO8+COcNCmxFUufJki+Czp9nQjg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="fzcdT/Mg";
	spf=pass (imf11.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.28 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761768670; a=rsa-sha256;
	cv=none;
	b=gtnG7rUpyfOqxyxr6JIBer56qVQhqKFfl9N60hwX41shbzQhoEsWCSFSq45h5/00tYuJAH
	RXgTboo3I4KP6RO9bloViPyZ/bQxUQw38UHKMw09hTMakxY0SLwJ1EMuBdhvMkeDa4Jo6y
	OKJjuZloNwWkvVllJutUy5/UYY59njE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1761768667; x=1762027867;
	bh=qpGuNHZZR4hchfLUKKttSmaxG+W37eMF01r5+dBbCBY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=fzcdT/Mg837dtUDPzN3IZvJaFmIR4Koi9D+v6niFRb/NDXYCqERKygFXgJXDi25Nv
	 opesT+yY+ZAJxBCKk0ZbHNPb4MmR/qTVK0Z2Q1fl5bY9rdus7GvFftgsKs92S3Qtzm
	 u8mvfXIT3aHxC5vDZBVshhQgdWJHoFxaxEJQtYDzMAhElAG7KvcXieapyAoWHrlRUN
	 yJpUT363OVIiMLTqvxO9wi+6g5bah1gyRFRfq8Q1ReHcFkouvWUfWHp20CeXzhITsI
	 U97+N2r0KUpsSmw9ebJH+rNIrUxQ1hFJolDaiMg/U/CTV4shVJNvcKz19+T0ukaPqk
	 nmoReRkSuQ50g==
Date: Wed, 29 Oct 2025 20:11:00 +0000
To: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org, m.wieczorretman@pm.me
Subject: [PATCH v6 17/18] x86/kasan: Logical bit shift for kasan_mem_to_shadow
Message-ID: <81848c9df2dc22e9d9104c8276879e6e849a5087.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1761763681.git.m.wieczorretman@pm.me>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 1962ec27b7155c20b7f866d92710251ffdf5f53c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EDC0A40017
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: uiiy7csjhcspr78mtptr7954q5w8e9i4
X-HE-Tag: 1761768669-775863
X-HE-Meta: U2FsdGVkX18Jzn24hsO3iItuioVkAD3p4+v1U55rp03X/o/EIQ3Evq2gcVTh/efFp2kWZV4U7Eucw0AgaoNjcZDEOQLNo1dD9ss9fhxB/WnC1oJfanLvr/lbn1pHXwRlbsdkcsZdK4JTQnPKSGZpKQIjZ6fhUyZFk59KaWFQTakJnExTJLGaMM5qrxFlHd4l929XI8lqplfvzogXLBUP4xf7EQYKeScB/XMAjqrPF+s72BTNdjAQg/YP70c2V/vhhgJ2l+dXMWwFsqql7bGKLa+Xu6igu5/FNIUbNNt7w28SV+xO7zOeJBDnn7412XZrIW6nNPoMRMo+5z1qBZZ9Bmh7hISi+YJuVaq9IH02I813iHGuakfZIu2tBYyZCr5OP9aKyQaJ9FoPEZInlxnnV2CF14zTaeBWCiky1XE/jm7lSdM7NQVGsUTUz+cFWul3toRkeI3mZJObJ8TTEQiNdT8SB8rzvHOLwY3NYn5jvcEYumlT7XNFZprkcM4v3D8e7AmRRFzzUKhu58OMIAqh9dpdrz2vNZONslvP27q54idAjDZluZVu2HcrlI2gMb3oC5aAE7mAHO1naL8EqRRAvRlL6XcLsuTl5dPQmpBBhjUl0++MonV7mzfj0oTp88Ps8em/5iUSWAvlRgzpf3GTthj23P4YyWijPW26XlBn16Ug0SOtZwKmmgHVlO+NHsPUHq5rEngiShtQjvIBba11/CLzUQO/QxcGsxhr0tD7QI9fOYsa07U4sdPKCDH7h9car8RBxAGs9o6jX9aQuLYJsTxtoolXjxVYd37c8jy2TWhqK0jJPEZP2j7UCTQDmr7dhUujEnfqyXICJTVo11TEVQ1B6HwHnoI4yz3xMFA9qJtRIdLlE9g8To2uB0EvSFHx0L/UP8/MRP3vCL9dXSLTnRI+CoK2qPbQau6GMLVf7GQ/OOkPFd14PZcr1U95TW1rD5OsXxkZTdYDO8IFfzc
 dqCuevB8
 iXPWFXwLua51YPtskdtKlXLZHpjSS24Al9HPJnHLWrhHSofXGeVFJoHWzdWC/1qcMWqc8jchGeBqFpt9IH0MHEYzEeL2Hbn9bDIrU54fGY5Gaf+SpK0tPUpUYOaIdnvULj2kM8W1gQBAzK8c4rNaOBjTUbI6VtoETiknWL+b2dTztAFxTj6ebVbQ6ByxPEJenMR96NeDPmFkMQb849Sm/8rFnogiOazAzu3OJ3X8+FzdV8TKIea0mxeGTXmj80cdOLwfaObwaCw9Y0b24xX2YEZCK30+cCnowOBBCnkkbBzE//lt5b+wiQM0/GBpYNyfQWOgTUJHNuSW9D0kUM1U/fzmQYZTzDkgUAbfY+cXbTiFuK1ZmxwtITySsTJQ6VbsGSTXzD6R5WM2sf+0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

While generally tag-based KASAN adopts an arithemitc bit shift to
convert a memory address to a shadow memory address, it doesn't work for
all cases on x86. Testing different shadow memory offsets proved that
either 4 or 5 level paging didn't work correctly or inline mode ran into
issues. Thus the best working scheme is the logical bit shift and
non-canonical shadow offset that x86 uses for generic KASAN, of course
adjusted for the increased granularity from 8 to 16 bytes.

Add an arch specific implementation of kasan_mem_to_shadow() that uses
the logical bit shift.

The non-canonical hook tries to calculate whether an address came from
kasan_mem_to_shadow(). First it checks whether this address fits into
the legal set of values possible to output from the mem to shadow
function.

Tie both generic and tag-based x86 KASAN modes to the address range
check associated with generic KASAN.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v4:
- Add this patch to the series.

 arch/x86/include/asm/kasan.h | 7 +++++++
 mm/kasan/report.c            | 5 +++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
index 375651d9b114..2372397bc3e5 100644
--- a/arch/x86/include/asm/kasan.h
+++ b/arch/x86/include/asm/kasan.h
@@ -49,6 +49,13 @@
 #include <linux/bits.h>
=20
 #ifdef CONFIG_KASAN_SW_TAGS
+static inline void *__kasan_mem_to_shadow(const void *addr)
+{
+=09return (void *)((unsigned long)addr >> KASAN_SHADOW_SCALE_SHIFT)
+=09=09+ KASAN_SHADOW_OFFSET;
+}
+
+#define kasan_mem_to_shadow(addr)=09__kasan_mem_to_shadow(addr)
 #define __tag_shifted(tag)=09=09FIELD_PREP(GENMASK_ULL(60, 57), tag)
 #define __tag_reset(addr)=09=09(sign_extend64((u64)(addr), 56))
 #define __tag_get(addr)=09=09=09((u8)FIELD_GET(GENMASK_ULL(60, 57), (u64)a=
ddr))
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 50d487a0687a..fd8fe004b0c0 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -642,13 +642,14 @@ void kasan_non_canonical_hook(unsigned long addr)
 =09const char *bug_type;
=20
 =09/*
-=09 * For Generic KASAN, kasan_mem_to_shadow() uses the logical right shif=
t
+=09 * For Generic KASAN and Software Tag-Based mode on the x86
+=09 * architecture, kasan_mem_to_shadow() uses the logical right shift
 =09 * and never overflows with the chosen KASAN_SHADOW_OFFSET values (on
 =09 * both x86 and arm64). Thus, the possible shadow addresses (even for
 =09 * bogus pointers) belong to a single contiguous region that is the
 =09 * result of kasan_mem_to_shadow() applied to the whole address space.
 =09 */
-=09if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
+=09if (IS_ENABLED(CONFIG_KASAN_GENERIC) || IS_ENABLED(CONFIG_X86_64)) {
 =09=09if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0UL)) ||
 =09=09    addr > (unsigned long)kasan_mem_to_shadow((void *)(~0UL)))
 =09=09=09return;
--=20
2.51.0



