Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3E2BCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745108E00EC; Wed, 29 Oct 2025 16:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2D98E00B2; Wed, 29 Oct 2025 16:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2858E00EC; Wed, 29 Oct 2025 16:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 183028E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:07:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6A5CBC1A9
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:07:50 +0000 (UTC)
X-FDA: 84052237500.17.B0B6677
Received: from mail-24418.protonmail.ch (mail-24418.protonmail.ch [109.224.244.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id AFD661C0005
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:07:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=bjmx3g8O;
	spf=pass (imf21.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761768469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7bOmcRxuqO6z3MZPe9zBvs6V2vz8fOGqA1RpHhG/FE=;
	b=zOWQJESslUxnwRHhDshFU5yRphTYWEj9rfhCr4RHMhnHmw+zIiPBTMCFsKfB0qBmz4Mjy2
	WReputigXXnZyqPfE749aakj05+sm5EYVpd7S9Qf4dSZwdmoGS/E5iyi+iBkCQ9Eti4Nx1
	oM+3dnMxY5+C8HQWuzsddHp5zdthkX0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=bjmx3g8O;
	spf=pass (imf21.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761768469; a=rsa-sha256;
	cv=none;
	b=PXQ9WIaBODJijJALn8CRgShv4wxG7R1hYGdFrJuTPYxcWo0J1UG0dTnAhtwdvEnsscCgPb
	9SvIc0PaXGpyp10yWVf9Q7mh9luML8Fwu26pKsJU0N8RdkBTpXoKJD7Fmi0kn8qLfdbzSy
	heZ4WS87skVYn4buTXZQXdEFGNxqHNM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1761768465; x=1762027665;
	bh=h7bOmcRxuqO6z3MZPe9zBvs6V2vz8fOGqA1RpHhG/FE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=bjmx3g8OlacQX7FEB7CB4gFpPcUTD0I5Kc1p43/y9uXqIMVnKJWIWOuru2SF/QQfu
	 6AiAPDukFzXStuxWTR5WDI0wUwQ3jAjKxjVKN/rW5W4cFnmYpLhh/SnXC+CNzfiPNN
	 yCU0Y0WKKnfImz6JKMr3Dj0qQjo+Mp/U3OEVrV6kaX0VUG3dIxPsjjzPd48CTfn+MD
	 HpUu7+z+rhYq8apG5mFFr/w3+YtjPLc59AwJlIe7QmemdTNU+aT/cA3JtTnT2ge0If
	 nWKsUZ1l87vhw5I/ZZHp5y2xOcPYMO6CexFWC9kS9HmKpnu1vWPf8OvbB4AV2iSubm
	 Hlcw1buJNqcCg==
Date: Wed, 29 Oct 2025 20:07:38 +0000
To: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org, m.wieczorretman@pm.me
Subject: [PATCH v6 11/18] x86/kasan: KASAN raw shadow memory PTE init
Message-ID: <f533bb094a566242ec196afbde222796c6d6c084.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1761763681.git.m.wieczorretman@pm.me>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 388931058df330f6e092950b7ef3ba7585e70752
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AFD661C0005
X-Stat-Signature: urpd6f4he59icf1gmeafrghku1eo11fd
X-Rspam-User: 
X-HE-Tag: 1761768468-450598
X-HE-Meta: U2FsdGVkX19vbzkfDIQVv+YBmxc3BUd6nZuEKZOnFTG7rhSDIZPMdUbW22qFXTGfnbJk6xW4QxH3GsJp096RhFw3IDsTa5TyqRczmDkUgn7s7U+nf4CQI6WXAdguIVVv/KKZCfIAlbNFqeiptTsjpx56waQQLnlc5ng1pWFcDJONhS999G8xUIe9mFzoCczkY08TaAiIHwcOxqsqfBXECkZY5gZ1SP47JHQwGCYZklzUKkCo29C7jatliSUfCNVp8imzo/3F6fsRge+pgV9Cp83TvQ2XVAp1zw8DLipIm3ZAo2HLB/DV+hoSf9X7mUYeZDxmvLPQcfmtTkXZvATAIbtkx1Haiir2Qzh8MnVgWjuZpRCqaJc0UGuaAZlxjA3PiA8jYMM7XWJ3vIQGBFx6FEfDYquEeEP1iJ37KqNXZtjyzFAYQOKewCUY/HCUeFWfYsFGwXNivHfsG/+ygDTzrZQoCRNnVHjX7tW6GgI4GiTLS+cUL4svlAxxwOAT7c4HqGoN6iG24vg0k2lmI7SQJMEedydLiq1n6n3lnD6SON44JgDfiFMO4wfM7GWSOPoddk1oDIJqDHQFZycaM4+kJqObRGGWi9wzReHQnCueg1xoctcPRM6dGfLXbgGlKytHwLYANJR4mQCDK6AxtdXdfu7lo7p7Bxxg80kvG2zbLrV5Hi5sic/Jt7Zk+7q/33AoqLAS/YAVVWCEonBBP5N6LW0p4vyHuHnghSl1Lbcw/SbuvNZjzFo1pa7XWc9PXgojCprT+jj804mfO1vfC0wCyEyLzkS3M3YZr63HfAA3asrErmOt4SqvSbGE6XSqGlvVtUaTvDGShfDSokKUOndsrMNf1tBg6yPgg285MWmMt9tqMLSH7+TvHar7drvSrjt8Qvjh8U29pMcilE7U2x1q/O3vQDhIqclCkfZN1lkVN90c2YK6rMJKC6wFkM2vZvu3T4rmF5UKK6i7MFU9HoF
 S88PDIy/
 qHNZRjBRJNyC0NZWgVCenlAtiMSNyFoI8IQI114TnxWr0Gsk0RYBCfrhMQDobCqtN5UpVDpppUCiKGVrxRgh59DwadV9n5I3rdB3ztrnMEfOXtYB8eXxouNCF4mg8G8OlSJ9aVA6C5Y6TufZOVIs+YVeRAALuXkcf3Tif3p4g0z+XWWJ/Vo9vfvFj9QWG7204maonx9lPI9eG+l6j8gvuTOvNpVh04+hz9Snd4ANL5mbB1MGA0bkkaEPrxTvi4spRGAXkKf2o0fDXPgaKvrIVOgvN7JgZK1ZwLy1ZVIM9bxqe0UsFld0z4eYL9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

In KASAN's generic mode the default value in shadow memory is zero.
During initialization of shadow memory pages they are allocated and
zeroed.

In KASAN's tag-based mode the default tag for the arm64 architecture is
0xFE which corresponds to any memory that should not be accessed. On x86
(where tags are 4-bit wide instead of 8-bit wide) that tag is 0xE so
during the initializations all the bytes in shadow memory pages should
be filled with it.

Use memblock_alloc_try_nid_raw() instead of memblock_alloc_try_nid() to
avoid zeroing out the memory so it can be set with the KASAN invalid
tag.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v2:
- Remove dense mode references, use memset() instead of kasan_poison().

 arch/x86/mm/kasan_init_64.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
index 998b6010d6d3..e69b7210aaae 100644
--- a/arch/x86/mm/kasan_init_64.c
+++ b/arch/x86/mm/kasan_init_64.c
@@ -34,6 +34,18 @@ static __init void *early_alloc(size_t size, int nid, bo=
ol should_panic)
 =09return ptr;
 }
=20
+static __init void *early_raw_alloc(size_t size, int nid, bool should_pani=
c)
+{
+=09void *ptr =3D memblock_alloc_try_nid_raw(size, size,
+=09=09=09__pa(MAX_DMA_ADDRESS), MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+
+=09if (!ptr && should_panic)
+=09=09panic("%pS: Failed to allocate page, nid=3D%d from=3D%lx\n",
+=09=09      (void *)_RET_IP_, nid, __pa(MAX_DMA_ADDRESS));
+
+=09return ptr;
+}
+
 static void __init kasan_populate_pmd(pmd_t *pmd, unsigned long addr,
 =09=09=09=09      unsigned long end, int nid)
 {
@@ -63,8 +75,9 @@ static void __init kasan_populate_pmd(pmd_t *pmd, unsigne=
d long addr,
 =09=09if (!pte_none(*pte))
 =09=09=09continue;
=20
-=09=09p =3D early_alloc(PAGE_SIZE, nid, true);
-=09=09entry =3D pfn_pte(PFN_DOWN(__pa(p)), PAGE_KERNEL);
+=09=09p =3D early_raw_alloc(PAGE_SIZE, nid, true);
+=09=09memset(p, PAGE_SIZE, KASAN_SHADOW_INIT);
+=09=09entry =3D pfn_pte(PFN_DOWN(__pa_nodebug(p)), PAGE_KERNEL);
 =09=09set_pte_at(&init_mm, addr, pte, entry);
 =09} while (pte++, addr +=3D PAGE_SIZE, addr !=3D end);
 }
@@ -436,7 +449,7 @@ void __init kasan_init(void)
 =09 * it may contain some garbage. Now we can clear and write protect it,
 =09 * since after the TLB flush no one should write to it.
 =09 */
-=09memset(kasan_early_shadow_page, 0, PAGE_SIZE);
+=09memset(kasan_early_shadow_page, KASAN_SHADOW_INIT, PAGE_SIZE);
 =09for (i =3D 0; i < PTRS_PER_PTE; i++) {
 =09=09pte_t pte;
 =09=09pgprot_t prot;
--=20
2.51.0



