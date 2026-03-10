Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38FA4FD4F08
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 17:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F3BE6B0093; Tue, 10 Mar 2026 13:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB156B0095; Tue, 10 Mar 2026 13:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F1DA6B0096; Tue, 10 Mar 2026 13:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B0076B0093
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:54:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C054A140298
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:54:17 +0000 (UTC)
X-FDA: 84530902554.25.746B331
Received: from mail-10630.protonmail.ch (mail-10630.protonmail.ch [79.135.106.30])
	by imf03.hostedemail.com (Postfix) with ESMTP id CC9602000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:54:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=I3sUpFOI;
	spf=pass (imf03.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.30 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773165256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYzT9pUJ33fciEEYHLErzOjZWjIu4mssUSjNvzdqw84=;
	b=5NWARF9fz1Ej94WBscTJHLaFeSc5Lh9qONPni5MgqRczMQM0oaMcmwIqqOxrY9jMzwQuc0
	fgkFHaXgzgsA8IFC18Aa7KObEMemtUaSZRMffkkS7khZl5ZTTyNkDtGO+fl0BxzuYUCspG
	dIBt4ycXZbnMZ2DlKa0JY6YzgI1G/Vk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=I3sUpFOI;
	spf=pass (imf03.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.30 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773165256; a=rsa-sha256;
	cv=none;
	b=UjCCbifH1aZN1lVsQTSa631b0snYOpdP/Y9B+gzFFEGjh508EcEQnipcLF5BimK1q/2Yz9
	BOZMwk8oUofFRnyg3FB2UX6P4AH/c/tjf2cw3xstUQa5LUvxcmEOrjcuCcodK3sbCV4dDb
	40MnacZ1uwheyAzUKvBkfRHiWfQbCjM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1773165253; x=1773424453;
	bh=xYzT9pUJ33fciEEYHLErzOjZWjIu4mssUSjNvzdqw84=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=I3sUpFOIrb0QB5EzsPsVdPlNOpVbfpHLEIFJQeylmc0o9iLyg5d30OqYqf74C9PEt
	 RxuA3WzuNAsFr9ULBmNwM/R6q310ubpG5zMPLnSj8NrahepZxdw9FFYzh8zrDewQik
	 Q+C99HzEX98wp3AL5hhD5rDIhZk9HpP0T3YASmLQ4jR4m7lhEPy5rvBV99WZHTb6Ap
	 LQb0JdgMolcKL7naA7a8LT3bnoSH6+T/ea4fC83VoDovOCHQmt3is2Q4jssmokQ/XV
	 VYE1OSvIOG1j2JVFfqGlypQEZkNX39kCtNRTrCb6+LvwUXH13MrQ8zkE8ZfYM6zqvM
	 r7E5fhO3jM/lA==
Date: Tue, 10 Mar 2026 17:54:09 +0000
To: akpm@linux-foundation.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
Subject: [PATCH v11 06/15] kasan: arm64: x86: Make page_to_virt() KASAN aware
Message-ID: <b51b60f82bbd99cdcd7f6d0d2bac1d5f3bed0fe0.1773164688.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1773164688.git.m.wieczorretman@pm.me>
References: <cover.1773164688.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: a95af21cc490f13be9b2b1108f966a54feb03d3d
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CC9602000A
X-Stat-Signature: 7ouy4syzpfpmk3cw4pxtui1uyn55tc57
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773165255-765048
X-HE-Meta: U2FsdGVkX19wzLNal5esd8Z8Cl6aB1yWJbdqK3OK6DFRL2JtS0X2KLdr7pGPtU+sJGQ0DBw7gTKpV0zoWKXhBGETqI6o7pLDcRQF/p2KzmhiVdAfFzv4JPIopBLTAg6VzhpOrBasIglJH1kVDmdbx8ztI5ok7krluRHiaOPBROu26rf11Q7/KruzPvm+kQSE9wtU6C+jL298KUzQlI++HY5SD1Pk9DNDHnjJVgv49CL9rh7NVGBDoBPLGQvyme/dH0vDxTfuaGEWDwauT6Nq7XTLY4Of6VptP9lDQxn2XM1Z0xoW9INREiFRzv2gGmpNS36sl6hZssMJKuo2+nmocatspaUAaXZY/0XjQ2P0igPNMjSezVYseRthrQqPitoS+DpT+TAgO8lyrcuEPpTip4+RVQTScJnxvKgarlhXagPkW/oXNCsUmfP2neitak2GosIzAjkgfK1fSjN27eM9YpSOR6kTostHzZMrbaVFh7oJZntHGV7jKTYeP5C9+c3nnuDQKv3hBwv1Spyslh8W+9j7uTJb1Q6Yshm+y9IP/JLMlq1LTkbwdIxKVTXeBZjyhE/tOiMx+Y7hBikPPaCpIIHoZ2M0m9ZSP0zNbxA1/TGJGTnZwHJydb6zIzQweD8cHE42DkIPNqLr5HpfJ0XYjNZRh3yjEKUy0H634Jlo67l/ZP/OtAcOJwZ1f2SFLTXhbyX3nz45XkbjPieYZ7m81PWtRTVqQQD9k4I/18VodBExMHbbT105jPl91u+FEDtlCYf8xROYHJ8eQg5CCqUMv/abzUEegKGRMSHDynLgdkKwJ+NSzmePrCzfGhcirsQtyAztahxvknDF5a3oX41XefozRUYyNavlPlWSmmWZjzw6BOpyQW5x6JNvGGVwv+yirUGQFee4r75Yj2zuol/7Gu9IBNHFQR+ChPImo3Q26wAxUT7Gpv51XzyIJ1TCOTQItmI7tHo5HDDXsEHURxB
 5cV2/OGX
 N5T8P4vWNdOXVuA5z4aKwhCYqblWoiOuA/sJ54jFn2HQDlFwh/SmQl4xXLfxqnvg537oP75uDuJop6B8TGx1s0bBMQUhVASsxKd6u8hArGYIjvdn0Q9pB6lfterVtK5BEv0ztIOYoXxiFBlhNfk/YEfXK5OjjgqHvE7w9rXORYW386stwencjfYFxlws2sqojqmWSRd12ojCCqXHyFoU8KzVnB50lNWkAb2PRWNqRQg6Q5EbOI1tl0iHM7a1JBQmXpc9mLf31tYTid22qABuBrYXyDXQIYdwFoYllFPPcMnsl5CU2I0zddR+n9aIdnakpOtfQnmnAMlz26e/dl9bEbPZXvp4Ts3T9EvJCzFCHVOLCtv64QuWNNT4yHQPDEl+1Plu+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

Special page_to_virt() implementation is needed if an architecture wants
to enable KASAN software tag-based mode.

Make page_to_virt() KASAN aware in arch-independent code so
architectures implementing the software tag-based mode don't have to
define their own implementations anymore. When KASAN is disabled or for
architectures that don't implement the software tag-based mode
page_to_virt() will be optimized to it's previous form.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v11:
- Redo the patch to work on the page_to_virt macro. Split off changes
  about virt to phys conversion to an earlier patch.
- Remove Alexander's acked-by due to bigger changes.

Changelog v7:
- Add Alexander's Acked-by tag.

Changelog v5:
- Move __tag_reset() calls into __phys_addr_nodebug() and
  __virt_addr_valid() instead of calling it on the arguments of higher
  level functions.

Changelog v4:
- Simplify page_to_virt() by removing pointless casts.
- Remove change in __is_canonical_address() because it's taken care of
  in a later patch due to a LAM compatible definition of canonical.

 arch/arm64/include/asm/memory.h |  5 -----
 include/linux/kasan.h           | 10 ++++++++++
 include/linux/mm.h              |  5 ++++-
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memor=
y.h
index 875c0bd0d85a..39dd0071d3ec 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -411,11 +411,6 @@ static inline unsigned long virt_to_pfn(const void *ka=
ddr)
  */
=20
 #if defined(CONFIG_DEBUG_VIRTUAL)
-#define page_to_virt(x)=09({=09=09=09=09=09=09\
-=09__typeof__(x) __page =3D x;=09=09=09=09=09\
-=09void *__addr =3D __va(page_to_phys(__page));=09=09=09\
-=09(void *)__tag_set((const void *)__addr, page_kasan_tag(__page));\
-})
 #define virt_to_page(x)=09=09pfn_to_page(virt_to_pfn(x))
 #else
 #define page_to_virt(x)=09({=09=09=09=09=09=09\
diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index c6febd1362e8..58cf02af4fa5 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -527,6 +527,11 @@ static inline void *kasan_reset_tag(const void *addr)
 =09return (void *)arch_kasan_reset_tag(addr);
 }
=20
+static inline void *kasan_set_tag(const void *addr, u8 tag)
+{
+=09return (void *)arch_kasan_set_tag(addr, tag);
+}
+
 /**
  * kasan_report - print a report about a bad memory access detected by KAS=
AN
  * @addr: address of the bad access
@@ -544,6 +549,11 @@ static inline void *kasan_reset_tag(const void *addr)
 =09return (void *)addr;
 }
=20
+static inline void *kasan_set_tag(const void *addr, u8 tag)
+{
+=09return (void *)addr;
+}
+
 #endif /* CONFIG_KASAN_SW_TAGS || CONFIG_KASAN_HW_TAGS*/
=20
 #ifdef CONFIG_KASAN_HW_TAGS
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b2245b1a25d8..044425db766e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -117,7 +117,10 @@ extern int mmap_rnd_compat_bits __read_mostly;
 #endif
=20
 #ifndef page_to_virt
-#define page_to_virt(x)=09__va(PFN_PHYS(page_to_pfn(x)))
+#define page_to_virt(x) ({=09=09=09=09=09=09=09\
+=09void *__addr =3D __va(PFN_PHYS(page_to_pfn((struct page *)x)));=09=09\
+=09kasan_set_tag(__addr, page_kasan_tag(x));=09=09=09=09\
+})
 #endif
=20
 #ifndef lm_alias
--=20
2.53.0



