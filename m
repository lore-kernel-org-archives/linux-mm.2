Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EB95CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 14:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A71C8E014A; Tue,  4 Nov 2025 09:49:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57E418E0124; Tue,  4 Nov 2025 09:49:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BBE78E014A; Tue,  4 Nov 2025 09:49:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6148E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:49:18 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8E6DB9CE0
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:49:17 +0000 (UTC)
X-FDA: 84073207554.19.93F1F49
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	by imf01.hostedemail.com (Postfix) with ESMTP id EA16C40007
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:49:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=sLxtTSkC;
	spf=pass (imf01.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762267756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xfqs8NGDzi/GLs93yh/ZnyHEZsNbd7BFWZBeJoDbuBw=;
	b=sXw0e4QaINBGk1EUQSwL5ZaA2BMEtLeYu/RaIluHwJn8XJNSTDqyySMVmmCxfjVIiwKlvd
	lOvNzRanNAiPndSYmFgiVC8ZUh6Mss4ahv5jsxtvoRuLp6P+VXYyJ0zr2ppqlsGmmUp3Eu
	LcTN/LoYDNmBfwJYMIFxEvu0JOsn1sc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=sLxtTSkC;
	spf=pass (imf01.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762267756; a=rsa-sha256;
	cv=none;
	b=ul0hlyWPnZiJWWKh8UoysNEcnAlLxyWSv2/Q/K8WBtw1exKZaFbPvlaawdf9U6oGG+eTA4
	5ZaBbivdhW6BqejeaBuDoTsQ6joo2ApDxCpyu2PnqMYd+7/pgnbcbmYP60bKLQOeHz+0Mg
	2T/W7wyElC0ziXScdLcv2XE+Tuo9uSg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1762267753; x=1762526953;
	bh=xfqs8NGDzi/GLs93yh/ZnyHEZsNbd7BFWZBeJoDbuBw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=sLxtTSkCbLJUhXOFbUAzkkZTsRM3HZRQToyIFBaRu0PGKyO5fKHZRIxLblCnA8aYq
	 1xoYfY5qfeaDniIW4yU04b5OalIS28PDRxj+azfnN/T1tuuyxwhtvNxmTqubXlVhCP
	 5Wmk14Q2eC7LgmtAM6XkOP6t9k8j5zagrcZeoLWy3Eae2EIy/LmGPcSjjXKunZHQeT
	 6DVds+bC8KILEg+9m7m6wV+oKy6hyY+wCp12XaOtqDKrgK/+buG6nEwcCt2Jf1PjPB
	 p+2mjdRnk6A4YqsQfKo4GSIhwGBNCXB6TR/nuFpapEoYpzSN1o6Ve3JeLMfBT0hAo7
	 YpBYBfB6AI79A==
Date: Tue, 04 Nov 2025 14:49:08 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Baoquan He <bhe@redhat.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v1 1/2] kasan: Unpoison pcpu chunks with base address tag
Message-ID: <821677dd824d003cc5b7a77891db4723e23518ea.1762267022.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1762267022.git.m.wieczorretman@pm.me>
References: <cover.1762267022.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: fd6efc8602e9b03ae9b37c660c7f86c9a4b17086
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EA16C40007
X-Stat-Signature: bgmwy9qxz6ma8ib86btzjd4nsah3ccc4
X-Rspam-User: 
X-HE-Tag: 1762267755-347222
X-HE-Meta: U2FsdGVkX19zqD99zTRbAlg34Sbme4UDYLasJ/gScQ94gKj/IUL/bu+kBmAJ1OwF9BFAn57KupdVc3v5LKfT4UxN3wUbkpAAbL3EFeJaunQbyKbL0JTJdyus8QNH1/YsZP6Bx/FgLFCoCCCb4iPTgqP3vfQj0zu6tqmj25TB83BUzIGXC5w3xrPdHDsT/G7PwKikRjATo7VHddRcJltOlWA0F0vb0MbBTMRaKMhTpEdYrWSWJ/qFb92ngcfTejYJU2env+kyIL+O/nYUR/rt0PeoWCsjwHqTfaLTCX1xpVJ4DG4XFxGa5JsbGXowOQc9CPWJZMBMZjxVugSj9RovvtK17ocvxzB4/zbuJRR38LlrQQ6dzHjF39WUFC88XmEFPnuq/S2LlwzTxT7BaoZtDmj8KXW3bE4pOU33oN5A2Gqk3JWBFZp3mAwOQcVeRmUJk8BdbwnKsgZkbcDzGqqn9ZczBwSDbOt9h2ePOttkclyMq9uyNCZTpDOyd/AR5zBTse4Ulnu2FkJPA3DTlgDWSNVUFnAEz3vEU+nK96wkcbuN9TeCrUhc245BvIK1U9RvRD2jVpWbmm6Elb3OUT6kind37TndBxgV0OhBRtl2Os3s6p+Bg1GiQz96nOz7XYylc8Get9C0naS0xyVnNlkMVpdTn7szJD9+WwwImR7XOgXDmi6eTjLs+GXcLtZX0ekBp85L2DHWlgdnKLgOs9CKpEhtISTQ/COjIiGEDGPcqWjhCAtl5YRs66vUL7mK5W6laUa0CfzH2P+BXjRX+jLN4zazoq1ZdDDAq9C1QFPnh7jHMK2SMelWZ7eexXio1/9speqOpBIoavAbFvER+M85vJaIbGVXXiBNE7m6HksiSOMKMZsdH7tf6XkwVEW4tCKWHZW/3kqYEcT7/KKPabFE1BDXNxNmAYCx1q7l7SQOfBzt/hYR4FgExdc8IPtCu42CzAEJQqf88B3nzFAM5To
 Lq7e3/sK
 FRASmboI/lu7DJ88o3weHh4bXTlbLAciy7HWaTy5N+gDLyt0HwM6v2u6N2zI489KsOTyFexALG4kmDVgt5vV8WTWViAa1nYEuKOy5syrWiSHVZEL1fiEBQKzyRT3JV2DuPTGSE3TBbvq2DJjQ4edTN/6Xp8Fo/IIwkLRCljet7BkBeRqrg8jApE4PkqjFTj+cehNZDN5iTUruO+sVj11pv3/hxfQ0pil6wNEAZ79tNennWV6MGzt+zHQsBpziUejJ4r9GBMNWWP+qT79q5XySDAXaQyrRbk7je2os5bVmNJsw5mcYFWBcx+rObRdA04MUFrxI/f+aU20pynCGW4E3UaaLUl4MB7zNBht5jYsqcKuaFAxNF2enf3f2GGsYKzDSzP1M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

A KASAN tag mismatch, possibly causing a kernel panic, can be observed
on systems with a tag-based KASAN enabled and with multiple NUMA nodes.
It was reported on arm64 and reproduced on x86. It can be explained in
the following points:

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
Changelog v1 (after splitting of from the KASAN series):
- Rewrite first paragraph of the patch message to point at the user
  impact of the issue.
- Move helper to common.c so it can be compiled in all KASAN modes.

 include/linux/kasan.h | 10 ++++++++++
 mm/kasan/common.c     | 11 +++++++++++
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
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index d4c14359feaf..c63544a98c24 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -28,6 +28,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/bug.h>
+#include <linux/vmalloc.h>
=20
 #include "kasan.h"
 #include "../slab.h"
@@ -582,3 +583,13 @@ bool __kasan_check_byte(const void *address, unsigned =
long ip)
 =09}
 =09return true;
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



