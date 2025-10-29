Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC89CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAA048E00D2; Wed, 29 Oct 2025 15:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81A28E00B2; Wed, 29 Oct 2025 15:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBE9A8E00D2; Wed, 29 Oct 2025 15:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB0688E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:06:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B4EEE5A517
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:06:00 +0000 (UTC)
X-FDA: 84052081680.05.5F01C6C
Received: from mail-10628.protonmail.ch (mail-10628.protonmail.ch [79.135.106.28])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9A2028000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:05:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=fFgp0OHh;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf02.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.28 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761764759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rr0Rm1n5HeBo5Fap/+IfVyHkvEn5nn0dcbxf514Q+kg=;
	b=3bfTSJgtN4E0oOc8RzDAav9Ew2G32t1p3aRRo4efC6RjMt6ScFmSUfHNc9m+9SRPh8vjQ+
	XwVY4/3xiWdAGn2IquF+zf8iHLzmBjYt71uyBbPfP/WeNcnlEQ7DTFeK7RRXmU5B3LPGUE
	RDWpKfrsV0OPTgVFfEwSX0ufjmWZ7fU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=fFgp0OHh;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf02.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.28 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761764759; a=rsa-sha256;
	cv=none;
	b=myLImEZ6FgkponPlYkher4iPj+8C1DJXAsVqTKxDSVhE2hQpbv/q1KcUcypyNxGpz07Jbx
	efwAOIu7WBx1dlB2W7+lMNtFp6RUZHFFVKWZsICburGajhNzx7+jfQ5c25UUhREEUwo+/z
	xhvZzoVrJTxhFpbbHR+uK3k6YjKOGJ4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1761764754; x=1762023954;
	bh=rr0Rm1n5HeBo5Fap/+IfVyHkvEn5nn0dcbxf514Q+kg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=fFgp0OHhcEPVlbbfupp7L0/UqzlPp2RufUT4rPPgcExkOWMJvc4oNZYRsMnJtLaiq
	 tbZ0pJJzf7+iztM4ZLjdgxVnfM0mU6sf7aJcNlMahV5ULYqRdQak8/GsfTRouV/FV6
	 Rs3i2/tvdQy39XdXhteb1Q2psCmSv2YN7LhtWCCQ7XWYMeotnXT6CCvT66EtLFz+NN
	 sdhEsdTaaCaHmgD+5tvbCHk0oBbsVLiQdk1opgevss+X0r7JVDeWWz63T8Rl3NBTQs
	 fXUxKPqTm1DzR2rgkTnD11K7i77mRTHyM41THQ7Jcuwksy4ckzfzi12AR2jyyGpRiX
	 +IffcE9sHZTTA==
Date: Wed, 29 Oct 2025 19:05:49 +0000
To: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org, m.wieczorretman@pm.me, stable@vger.kernel.org, Baoquan He <bhe@redhat.com>
Subject: [PATCH v6 01/18] kasan: Unpoison pcpu chunks with base address tag
Message-ID: <fbce40a59b0a22a5735cb6e9b95c5a45a34b23cb.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1761763681.git.m.wieczorretman@pm.me>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: aef5b12294c25038010fe20ffdc227c541613b14
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A2028000C
X-Rspamd-Server: rspam03
X-Stat-Signature: n7kgm647acizwm39qcgzu1qnef51c9qa
X-HE-Tag: 1761764758-914244
X-HE-Meta: U2FsdGVkX18++Z3UzxRwLZSXIF12oOS8gYXko9mH3YsVRFmCphj2F81SLkONv+hulfB9TRruGn5zq5Gi4QQJTmKfkJt38HPIUnNB9EKQoOOoBdSyOeNkG6rs8QZEnBvQEkDvH3rKSD+YTlVrxtlZw9GACMg7nXnIqFTFp0lTBRwSlGCW8Odvx01KTC0aBdvCahnbnYFq5doiryNgzKxj01mGyd1JfucWcLqpvPr25jZOMajJjpSla67fPy+fBuMcMgWydkR4jYzLu6K9hNcflmY04GylSjrXD6evP1x4Giq3F0g2fxLgACCAS4U6cunpfCv6fmQj11d/reEplRN0p31Q6cdm/OvdX8Z2D4WtvctIEy6BGx5gRR3NaX1bYR4JyJ1StcWLQDiyreEprEQcB8hDHfTlImseBrbxDBaK0+wc8bMu9dQ2eXMicji3rh6hSaMAhvfwN6TryPkWzMRRZ1uBiC4/tL6vP1wGfqxnK6+qepMBjTmWpieHUVPe++bDejdfPuRg2CGaiEYyFDi7r01j+d+1fGBTkZM0ofYWqSaPE4Eksic8LC8QGxvPqyWA9/x6yIqw44L9gQM48O4fPI66CqN/9CfZJPcweiz69IFSi8rGzPLLO78All87HiiJYwzhTEm4cSh8+T+28qNr2H3SzXCJMQUDgF2ElUBaH/Qu0SU2jDmSPo3WN7Bbw4iI2O7ntP6McarpqKhHQ+yEuXQWpTzv6vOtgnaZBp/sEKe2OHMQdHMxFRKNKIi5usnvoSgJR5kwvJrKLUPRBGt26fZoM/J/tukazXDbrtLrjtIf/4bmD7ldbvbGoqOffC9DqeiOHp1TCT936LMw3FHiOl5yxFZO1JYdi5LfKMTrXg7yOu7ZZ1P2U7A4NuW/iBU6Swh6geZRn2caCGeWJNd6FcE40P/BADGFiWpN2B/ToSQtIF9sBuHOozAR/bnEk6TXJG1RwvxF0ypKsLTa+A9
 5V/WIwlT
 VY7Hs/hv2Yb9fjqGBTTqlElrAl7b/Y8cEnnvHANaR2GCWI0+6Nyia4DldBRkgTcMQX6GUO4EL2SIhVVa+0/M4Zj8NeGX+14CBPLATq+1zOtt5IqamgzF6sQ7PQebsNYOfAt2B3chnpAVQ71E1iu6rbY1Vt3gFLF/r8lUhObTYSSgeCYKjdzoSSDeuA3FAS8WHL6v7fA/k3rqvSe1ZVlXn40TkBDW8TcytCAQjAOK7Ii2sd2zDUud+TdKAZEErx4vIFdiS9REeKhNBiJLkiBGkP2NLLPFPntOqEog5N9831EkfCe4v0kmLPhPpJCLL1UvGIxWZ4ECKtBcMDCQ4yZUKov+YF1uIzmk4Y/oIpdy2UVdg0/j2eER5Myv7sBP+VJkfMZIueROftncrcnY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

The problem presented here is related to NUMA systems and tag-based
KASAN modes - software and hardware ones. It can be explained in the
following points:

=091. There can be more than one virtual memory chunk.
=092. Chunk's base address has a tag.
=093. The base address points at the first chunk and thus inherits
=09   the tag of the first chunk.
=094. The subsequent chunks will be accessed with the tag from the
=09   first chunk.
=095. Thus, the subsequent chunks need to have their tag set to
=09   match that of the first chunk.

Refactor code by moving it into a helper in preparation for the actual
fix.

Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
Cc: <stable@vger.kernel.org> # 6.1+
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Tested-by: Baoquan He <bhe@redhat.com>
---
Changelog v6:
- Add Baoquan's tested-by tag.
- Move patch to the beginning of the series as it is a fix.
- Move the refactored code to tags.c because both software and hardware
  modes compile it.
- Add fixes tag.

Changelog v4:
- Redo the patch message numbered list.
- Do the refactoring in this patch and move additions to the next new
  one.

Changelog v3:
- Remove last version of this patch that just resets the tag on
  base_addr and add this patch that unpoisons all areas with the same
  tag instead.

 include/linux/kasan.h | 10 ++++++++++
 mm/kasan/tags.c       | 11 +++++++++++
 mm/vmalloc.c          |  4 +---
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index d12e1a5f5a9a..b00849ea8ffd 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -614,6 +614,13 @@ static __always_inline void kasan_poison_vmalloc(const=
 void *start,
 =09=09__kasan_poison_vmalloc(start, size);
 }
=20
+void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms);
+static __always_inline void kasan_unpoison_vmap_areas(struct vm_struct **v=
ms, int nr_vms)
+{
+=09if (kasan_enabled())
+=09=09__kasan_unpoison_vmap_areas(vms, nr_vms);
+}
+
 #else /* CONFIG_KASAN_VMALLOC */
=20
 static inline void kasan_populate_early_vm_area_shadow(void *start,
@@ -638,6 +645,9 @@ static inline void *kasan_unpoison_vmalloc(const void *=
start,
 static inline void kasan_poison_vmalloc(const void *start, unsigned long s=
ize)
 { }
=20
+static inline void kasan_unpoison_vmap_areas(struct vm_struct **vms, int n=
r_vms)
+{ }
+
 #endif /* CONFIG_KASAN_VMALLOC */
=20
 #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
diff --git a/mm/kasan/tags.c b/mm/kasan/tags.c
index b9f31293622b..ecc17c7c675a 100644
--- a/mm/kasan/tags.c
+++ b/mm/kasan/tags.c
@@ -18,6 +18,7 @@
 #include <linux/static_key.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/vmalloc.h>
=20
 #include "kasan.h"
 #include "../slab.h"
@@ -146,3 +147,13 @@ void __kasan_save_free_info(struct kmem_cache *cache, =
void *object)
 {
 =09save_stack_info(cache, object, 0, true);
 }
+
+void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
+{
+=09int area;
+
+=09for (area =3D 0 ; area < nr_vms ; area++) {
+=09=09kasan_poison(vms[area]->addr, vms[area]->size,
+=09=09=09     arch_kasan_get_tag(vms[area]->addr), false);
+=09}
+}
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 798b2ed21e46..934c8bfbcebf 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4870,9 +4870,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned l=
ong *offsets,
 =09 * With hardware tag-based KASAN, marking is skipped for
 =09 * non-VM_ALLOC mappings, see __kasan_unpoison_vmalloc().
 =09 */
-=09for (area =3D 0; area < nr_vms; area++)
-=09=09vms[area]->addr =3D kasan_unpoison_vmalloc(vms[area]->addr,
-=09=09=09=09vms[area]->size, KASAN_VMALLOC_PROT_NORMAL);
+=09kasan_unpoison_vmap_areas(vms, nr_vms);
=20
 =09kfree(vas);
 =09return vms;
--=20
2.51.0



