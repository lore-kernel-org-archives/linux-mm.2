Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6625CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F6A08E00D3; Wed, 29 Oct 2025 15:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 078918E00B2; Wed, 29 Oct 2025 15:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF85E8E00D3; Wed, 29 Oct 2025 15:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E35578E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:06:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 95D7B4A1DD
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:06:19 +0000 (UTC)
X-FDA: 84052082478.30.0894EE5
Received: from mail-24418.protonmail.ch (mail-24418.protonmail.ch [109.224.244.18])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9B6E318000A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:06:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=auxqsyOv;
	spf=pass (imf16.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761764777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOT+8LaCSd2bsGWZH31RqkbowzlJMvnmRkALmEb4OMQ=;
	b=p92bmZm2ltrl8xuLoY0/tkhPVz7rjsLuGGs6j5T1+M2dS46CKIcaFHFscEjiPmzXJ4Xesm
	/SlJvmgB/x7PKG9RGzzXm4V5AlhCUL121XjUZEQtv4KNXGSfDkqkpG61tuQwh+oTiv0g3j
	7bWIHcjU8Aan2hhqrzfKktfHLWRDCRo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=auxqsyOv;
	spf=pass (imf16.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761764777; a=rsa-sha256;
	cv=none;
	b=AISIs+STcFKxA0rzxacWBbYiiaiSzX6/IcA4gkuwUpAZfAjZaQqr55zTzRmMSWbajLPfZS
	E/c1LtwYPfJNJvCAkdMI+sfZNM2iPA3vZa8tu3SUR/pxJ2nzXx25zO3B4sEKVhBsrG41jf
	McbDXK8uNYCWQ/EAB8yRGd40LDkprhE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1761764770; x=1762023970;
	bh=oOT+8LaCSd2bsGWZH31RqkbowzlJMvnmRkALmEb4OMQ=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=auxqsyOvljSpXFTF5AKB3T/509bEa7/sfm3pUYNafcxp0ATbiM7w+PvdgHqDzP/Kl
	 o6m94wJHeNA3LtEU9nJ3AbSjzlGm7hiKBmLb/V/GAJmJs7bw09PVZ8hQvZKOkhPZvg
	 DJMBZlr4c42lwpCP6cG0IYpaei1wF90rYUs7RQpjzwhRHBhBgw2CbJTJkF9OyZXbaZ
	 yfuwOUsn32t9bC5lYqxSFDkgHGelKaEZELumFwoYqF2EusJKk8QLDQkIBqE9T1z3V5
	 wXfTIeT/vk723bJXmhmoHgApPMBuwmceI0urqM/axJShS22fMn8OyttRP9uyR911Xi
	 er2jNGKegxn+g==
Date: Wed, 29 Oct 2025 19:06:03 +0000
To: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org, m.wieczorretman@pm.me, stable@vger.kernel.org, Baoquan He <bhe@redhat.com>
Subject: [PATCH v6 02/18] kasan: Unpoison vms[area] addresses with a common tag
Message-ID: <932121edc75be8e2038d64ecb4853df2e2b258df.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1761763681.git.m.wieczorretman@pm.me>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: b78f8be95b4a3268cc028d63fcca55df4e5c6664
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xoyogx1yrpfa9q149suxpwjouu3fhntc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9B6E318000A
X-HE-Tag: 1761764777-810201
X-HE-Meta: U2FsdGVkX18xaIcvSYfE1BXCijxuSNug9mEFSwEv0ehm4LNPt4l7bWkgGfsr/Zfb9FY+bg5DYiJkTBPG33VlUpok7QIQpYcljItj6a314KtJITpaiz5gf+wzD8EZhed0xNoTOH4YUSI+v5QeRISu3Y8bVa9kaiuuQTy05RU3owvp+OrJaIT6oiAZlX0IGb94a3U+0n7i0UTMqunfiYt2ItXJIoVtzirUPgkEhQ9NyiVbwWJd2CQFioXcZKrrY0vJtnVHbZbmlfPbyRaBY5ggAjRbRMX5bJfZJdoJMUKGtrc0iHNEEj/gRtfgndN9G+eR/whudxo4vgp45rroSr62sHcGNwZZ2vylSlKoVLrW8U15cVWTU3PPUYv5XI/2qUajPcOkJZWD5y8zELuLhTEYbiYNGCIaS0+SDwB9Q88MpT12mO9lmAIvCW1oeOZKwtalUn3gjU9AKfZMsZPH/CfNGIJHK4zMsEhjh8hE8fNa4OjOzNlAHgTX64lLU8pIG5RUG5hkMVIUPMiQ3V5TOywESMr8LMxgv38KO6B18LR5IL37BoERoB2yaBGrU9AiEd02GNOoCzVNJS2wktU4eJycgv1S/E6i7cFleb4a3BlzucqQfbqP+iXhbfIM2c9o+QgSYPZScoybUJI/8phCAV8pNNwO6VqHYnCAvR3zwzdilKoNebJ3bAFvV5+cbcGFWuVdjDbEWvDmRMh09phlWSChOKxrvFAWIKdnKL6tGAcML+U51agefsof0MHCtVuBDYATJjyGlpfJ9x1yUkOXnvj9bP4xafDS9VHirEGJHTlRys34/y9aBk2T5XrjurC2evU7GvtOAv1vLXaSQhd/9VXbtjpHBiydEey1yFqRh1+H+66W5B8ksOSnqBoKuOIicgSO5mKrYwdkuMgBsXeM8yIqc0hNn18ukVsx4bUyyZ+77QbB0xX3SW4cQGSBw884x7T3PIsPk4/MHxLVSJ87iv3
 0YoGSCVg
 skB6oD3NPolzAS/4OcMlW0/MJ7MmxpuNzn4SUPaNaj/6xthdOywcBwJZ2/e1/KFrqyCClFnHAc645njuOjfm1wA3xl3paMFyRGhlXXFqtKsmnbrPiCOP2z0jBoUlGR20QScgkOKpjsuagyDQ5b2/L2/shJFYWdcrLxF0mGsy03xIQmfrEwZiIjmoIsxVdmCaLRnsyBGDDvEbco3MDv3NsE+CmFLomvpdbXv8ABnGiL3NPu5Pt4pVseKxfntUaKiE+ps9YxY/0zvQ1ztDf6rR6ifSFixzOiyrN28Cn096zW9DomJbkzr2xuremefLxZjtWyRNPQ2spjS/wxgDhAkxluwbXFTOQnEwyMqiN
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

        1. There can be more than one virtual memory chunk.
        2. Chunk's base address has a tag.
        3. The base address points at the first chunk and thus inherits
           the tag of the first chunk.
        4. The subsequent chunks will be accessed with the tag from the
           first chunk.
        5. Thus, the subsequent chunks need to have their tag set to
           match that of the first chunk.

Unpoison all vms[]->addr memory and pointers with the same tag to
resolve the mismatch.

Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
Cc: <stable@vger.kernel.org> # 6.1+
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Tested-by: Baoquan He <bhe@redhat.com>
---
Changelog v6:
- Add Baoquan's tested-by tag.
- Move patch to the beginning of the series as it is a fix.
- Add fixes tag.

 mm/kasan/tags.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/kasan/tags.c b/mm/kasan/tags.c
index ecc17c7c675a..c6b40cbffae3 100644
--- a/mm/kasan/tags.c
+++ b/mm/kasan/tags.c
@@ -148,12 +148,20 @@ void __kasan_save_free_info(struct kmem_cache *cache,=
 void *object)
 =09save_stack_info(cache, object, 0, true);
 }
=20
+/*
+ * A tag mismatch happens when calculating per-cpu chunk addresses, becaus=
e
+ * they all inherit the tag from vms[0]->addr, even when nr_vms is bigger
+ * than 1. This is a problem because all the vms[]->addr come from separat=
e
+ * allocations and have different tags so while the calculated address is
+ * correct the tag isn't.
+ */
 void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
 {
 =09int area;
=20
 =09for (area =3D 0 ; area < nr_vms ; area++) {
 =09=09kasan_poison(vms[area]->addr, vms[area]->size,
-=09=09=09     arch_kasan_get_tag(vms[area]->addr), false);
+=09=09=09     arch_kasan_get_tag(vms[0]->addr), false);
+=09=09arch_kasan_set_tag(vms[area]->addr, arch_kasan_get_tag(vms[0]->addr)=
);
 =09}
 }
--=20
2.51.0



