Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 411B7CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 315158E00DA; Wed, 29 Oct 2025 15:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5F78E00B2; Wed, 29 Oct 2025 15:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 204638E00DA; Wed, 29 Oct 2025 15:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD048E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:07:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C8CC21A096D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:07:48 +0000 (UTC)
X-FDA: 84052086216.19.1384633
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0685D20016
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:07:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=oLFtUaeP;
	spf=pass (imf13.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761764867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sFQWpkAgZ4WYl8uNu/8Fmdid7sZ+Bxs6DzYolFKr5rI=;
	b=cnOUKHnebYyoqJEsNDESi1m7Qt9Oiait+dr0Nb83xYWgRZPTSQH92jWvUzp0KuKnmsw1Tp
	/aUEGz+A+2o35xpF24UwclhQvEguk7SAt8WafdNRPw3omu19a2n2cwcFMAZpBuuo/iIoXc
	+p/43IUXH0fppgIho7NHaV1TSZT0nMw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=oLFtUaeP;
	spf=pass (imf13.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761764867; a=rsa-sha256;
	cv=none;
	b=bYlNuGnuiuT6L/qOiEwQ4h9kpmcduSoxDsB/0aFWI1K1ix4C3aIDGTWcpVpr+dcYDfYVrm
	qQlaqNkRkX1R2rb8PFYVX7mf2mXiVf10Dls4EkjmSixSqNuwHGecc8RYLKAafWAKp3TP3t
	5Q7B0oUsXN+wNjauvsw7+Q+B2ZxAjDk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1761764863; x=1762024063;
	bh=sFQWpkAgZ4WYl8uNu/8Fmdid7sZ+Bxs6DzYolFKr5rI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=oLFtUaePcdKPdIcWB++mjgoA1FYxZr+2qq4hruE3cTHdK9B3d+RcwNSKm4Yjzuean
	 Yy3mXhLMxlUY79Y37OsojkJOCfOOwHoANbiDCLpmuEgEynKBfImp9SUS6yWy3g3D4+
	 ZWfCuzapxDyymtwWB1LxqIVav+eW6ttVRuFBHhxAyTJImw+MKe3v3cF7Py5MKMvy/W
	 erm3j57lR0Z4dpzNDQPJ2WldIPuRsSCDx1m3pNOWYpjYPErDQAlXPG3R7vrqH1xbA4
	 d2dtAZhxuJk/uir+koJ2LsPFTm9IhIxQtSGaCQEf+N+oe3ms7MPhnPNrYi+DQPJaaa
	 cQqb0wWO5S0ow==
Date: Wed, 29 Oct 2025 19:07:34 +0000
To: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org, m.wieczorretman@pm.me
Subject: [PATCH v6 08/18] x86/mm: Reset tag for virtual to physical address conversions
Message-ID: <d030a07c956c1e7cbf8cd44d6b42120baaa41723.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1761763681.git.m.wieczorretman@pm.me>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: c34c086f0ceececd458efcce81b943565370c09a
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0685D20016
X-Stat-Signature: 7nhaqf1j6d5qp85huxi6s9i1f1xfi154
X-Rspam-User: 
X-HE-Tag: 1761764866-229697
X-HE-Meta: U2FsdGVkX18bJtVQ6Jz9m8v12DFDOfr1JQzqSJ0Z9HHdg5NUcgyXGWfKkCOquxAm615KJWS2LTJa6LArints0y9IFBPqSCpsYmoy6vZZ0o1U4wlYpkEV2zLKJA/3/MtGjUWIiZmu814JasqzPKLRt13rLSbFFpgQX2WQaO0Vka8bRe36lR4evh8ldEYJaKJiuzIFGdK6gyTPLBYEiau40A94OEpAyLaSGBMYTSIGXfkElmugai4GuaEmT8ODJJQtyWWezJCNbVOPUSQeLmWujLhf2zH5/aHVAD/2khazM68yPUR9H8FsiZiW/v8Aic8kpaLib7nssJarVsfISrzXdcKPTW4HtR1bedaqkgDMFDOtF/n6sVnm9fp9Lv4AJm782aFGun3BPQ2XJ3h0SQ35RBIfaRkXmu4f0zl/szyPZZnOIItRZDrr3E5SAxdP4WCuuNzJMvnVSZSa/Ueextz3THugM3UeedaL6LlVUpIE0UBoju/HWq3scck8SgR8DDeZcRmngWYowX9Z6DcHyec2QLzRZWAWDiQFCRcqDzuykDJqgBQodO8Ve3ALbwrS035QA1fIcB17uTsavVbBQBFSyt7ZeeK5U4SEyx2jY8sGAGTXxIUsU2ogvGlKaCRBcQs77XGcZ2mHn9stpQhLaamHKbCd5nzb8Bsmv2vVNeeI/yApIyEfSFm5+IYqc38YsZfoQaDoeJIjfYVmP2crlEzTPAIJxtTKZNWZI5ksoC34nW4kuruAafZ80nNuP0i05IrDjSn33rQMySz2G4mx0eP5nUNE4fJOll/h0+bJUA9r9D1jDh9i7YKL67cu+XcEgkqXSLxmwuBH8hQazw6KQ+7g/aJdFT7/VbkVZxHPTw7EWNSMCyD2hscUoMZ50lr0JJh7TdYeGv1vQZpr6OnJGznM0D8HHDBn4GW1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

Any place where pointer arithmetic is used to convert a virtual address
into a physical one can raise errors if the virtual address is tagged.

Reset the pointer's tag by sign extending the tag bits in macros that do
pointer arithmetic in address conversions. There will be no change in
compiled code with KASAN disabled since the compiler will optimize the
__tag_reset() out.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v5:
- Move __tag_reset() calls into __phys_addr_nodebug() and
  __virt_addr_valid() instead of calling it on the arguments of higher
  level functions.

Changelog v4:
- Simplify page_to_virt() by removing pointless casts.
- Remove change in __is_canonical_address() because it's taken care of
  in a later patch due to a LAM compatible definition of canonical.

 arch/x86/include/asm/page.h    | 8 ++++++++
 arch/x86/include/asm/page_64.h | 1 +
 arch/x86/mm/physaddr.c         | 2 ++
 3 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 9265f2fca99a..bcf5cad3da36 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -7,6 +7,7 @@
 #ifdef __KERNEL__
=20
 #include <asm/page_types.h>
+#include <asm/kasan.h>
=20
 #ifdef CONFIG_X86_64
 #include <asm/page_64.h>
@@ -65,6 +66,13 @@ static inline void copy_user_page(void *to, void *from, =
unsigned long vaddr,
  * virt_to_page(kaddr) returns a valid pointer if and only if
  * virt_addr_valid(kaddr) returns true.
  */
+
+#ifdef CONFIG_KASAN_SW_TAGS
+#define page_to_virt(x) ({=09=09=09=09=09=09=09\
+=09void *__addr =3D __va(page_to_pfn((struct page *)x) << PAGE_SHIFT);=09\
+=09__tag_set(__addr, page_kasan_tag(x));=09=09=09=09=09\
+})
+#endif
 #define virt_to_page(kaddr)=09pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 extern bool __virt_addr_valid(unsigned long kaddr);
 #define virt_addr_valid(kaddr)=09__virt_addr_valid((unsigned long) (kaddr)=
)
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.=
h
index 015d23f3e01f..b18fef43dd34 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -21,6 +21,7 @@ extern unsigned long direct_map_physmem_end;
=20
 static __always_inline unsigned long __phys_addr_nodebug(unsigned long x)
 {
+=09x =3D __tag_reset(x);
 =09unsigned long y =3D x - __START_KERNEL_map;
=20
 =09/* use the carry flag to determine if x was < __START_KERNEL_map */
diff --git a/arch/x86/mm/physaddr.c b/arch/x86/mm/physaddr.c
index fc3f3d3e2ef2..d6aa3589c798 100644
--- a/arch/x86/mm/physaddr.c
+++ b/arch/x86/mm/physaddr.c
@@ -14,6 +14,7 @@
 #ifdef CONFIG_DEBUG_VIRTUAL
 unsigned long __phys_addr(unsigned long x)
 {
+=09x =3D __tag_reset(x);
 =09unsigned long y =3D x - __START_KERNEL_map;
=20
 =09/* use the carry flag to determine if x was < __START_KERNEL_map */
@@ -46,6 +47,7 @@ EXPORT_SYMBOL(__phys_addr_symbol);
=20
 bool __virt_addr_valid(unsigned long x)
 {
+=09x =3D __tag_reset(x);
 =09unsigned long y =3D x - __START_KERNEL_map;
=20
 =09/* use the carry flag to determine if x was < __START_KERNEL_map */
--=20
2.51.0



