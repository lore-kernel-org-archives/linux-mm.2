Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D41A7CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FD468E00D5; Wed, 29 Oct 2025 15:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4A48E00B2; Wed, 29 Oct 2025 15:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311948E00D5; Wed, 29 Oct 2025 15:06:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 231AD8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:06:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A91EB13BEDB
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:06:45 +0000 (UTC)
X-FDA: 84052083570.14.26436DF
Received: from mail-10628.protonmail.ch (mail-10628.protonmail.ch [79.135.106.28])
	by imf02.hostedemail.com (Postfix) with ESMTP id BD23D80006
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:06:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="pGVXX/VY";
	spf=pass (imf02.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.28 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761764804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RT/zPmq8dzuzMSpg5XGcznppBgYR4y/21vyg9rTeyzk=;
	b=ExkhLKfstYNhFbyaOM0pZ6OPXhPvhkD5r+ucJkuSBWKpiotug3Jk78muy5i037hzqTi7TC
	KuXoqiamtr+z17ab8inb5rZrtz4keeZTAAAmE5BFKPL7PhNPscq4BSIu5TF/Df1d2QIJWx
	PE5+rKRemEidzbdWTzPFLGlrK7sN2dc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="pGVXX/VY";
	spf=pass (imf02.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.28 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761764804; a=rsa-sha256;
	cv=none;
	b=5Twcqckfg3qU7lZqpY9HmucNkXx1ol/Ek8OPgagcZy1w6n+SlvXHfpmoZWburGjJ82khIr
	j1w3nWjzeNqhhTxHnwOqTZiowZuireZXQUUeJJSH1wRiLPHtuPpKcD97VGmCXvdeR1K9w+
	YM93WNQ8ggNnb7isNc0CrgUr5Qx+vqU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1761764801; x=1762024001;
	bh=RT/zPmq8dzuzMSpg5XGcznppBgYR4y/21vyg9rTeyzk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=pGVXX/VYTWR44Wl1sG/O8IDygFTtrJhNXjWeLezoqqGkYg93K5hXzT1PokJx6a62h
	 GV+r67xFAM4zXxfmJpWSg+F64ywdK83enI1wzWnczmBMFY5OzsI3s9yvN7mT2Td4Dh
	 7TyK6Vznu89HYA6GkMLZywdeGiiHscMs/4E8pcQkBgwWwHkh9pWdFp7Rt9jF1HxtdQ
	 OMd4mrpIp0uXdoWQ5BDxmbbqnKomkHfV2zzEFu4RrOwaqx4IsoSWQ1IqwNNbeC3qV0
	 veI/fsLyEWuW5i6UByGv6InudSQ9k9UBxjAaTuvbgfCVVQPibgB5z0JnNq7hhrFh2B
	 fHc1Ge225l1xQ==
Date: Wed, 29 Oct 2025 19:06:33 +0000
To: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org, m.wieczorretman@pm.me
Subject: [PATCH v6 04/18] kasan: sw_tags: Support tag widths less than 8 bits
Message-ID: <8319582016f3e433bf7cd1c88ce7858c4a3c60fa.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1761763681.git.m.wieczorretman@pm.me>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 5f5d346b6b1d7504801ff3b4ec51dbe636e94b26
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BD23D80006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 5eucb8sqwmr49c79ct9hzbntodkcki76
X-HE-Tag: 1761764803-659412
X-HE-Meta: U2FsdGVkX1+ZM/b6VmPoqBOGmpEB1op3pYESySk0L9oNggBU6d5jQct6vjocui9ogrAk0Ic96k+1Zzl1cfFz5PXYBgXtmk/18DcU4gqXZDnwjVemJwjKwIIdexCxmRYktN/J96EZnXjIFuoExILOOcXCuhzoGwg3dMBAUMA4jSgg3I5QVh0hxyXNUhdJerK/mSPLuETyEb7yOC5kEId6CSSextzMR0W+58HyntoijwGPB1UW3SaC2TNOfFPnI6Decvr8qZLkkZZUIGUaKsxIPPpbktu45TC8yW+hDAyNyiQEyfAhRQDcWLBRYZaYu8v4wGFW9A1OIkE1U7yefs7RmdrCctdihsr1C5MOLKTVWViBK/yCAUREcFpZFlzIWte99rCzMJdgQj1CTuYAJ3enuzojFJ/SjYIpO6iDFfMQqt1oJat+v55mQQdejufQbs73r0Jmc2VKICXIQqHqPljKBRVgEgCAuTOFAFcGkZe4Z4xXOMdu3ZuvJl5xZBI0uUu/DkUzw4wR0ceu1txQ4N4XltS0vzp9HMWickhHx6IOBA+yazvpDvXFxuL0yq++zhkvgJiW+vgTCAvZMBII9pAJBYCAP1lYVop4jsQlAJOaix7JFY+sb3sBnTa7RqhuV3hyIJ9KAMpmZJPpS/1iaSLo7ig9WlAGr92+ULPSrTM3kObmV6MObgUlF1b38T0aXaiewcG/vhE3gJYbIWAEkhRz6VkUlY/+R5CdDRew6btsMUTCG7H6k9s0wMlmtvXg/8zCbgXAPfzbelH9yGO7KI0vaAYB/q4BdXMg96uN/0812vCX6N+kRN9K8VzqRfadWaLczrtnd/B9hy7ff8aSHawEGhWSTvZSni/0f0amQ7igkjv0qjsjuZVxWA7GC8jTTW3Z0pu5S/7Cuvpgr5qAMQyDgivMtW9H+R5WvBR4tBpYkzGrU4y84nprsFW1ovztFkiCdqX7hMrpNdKL2b3Hpba
 w/jH+IGC
 1+VtLgA3sRaFU4da6nlyZ7b2Qoqly/LyTT9aQwklAUrb9G1ZYWHNoCRsas96T7w6RItPho9NCWkbRT0rZQL9P5zoJOeL8sywaYBlIeabI3PT3DPbcevxW946MiCoOshU0UhB8TPVovyNPOmrthT2aQkpNEGjOLrS/7yxD521SlmJOycdBB42c8wTz/sHqE2dsbbaWzQEK279qoNxVPktI6aEamEyAe2FNXPvYbB+weeSXPJxXv6L/6/zGnMEsmA1Gl/lDGB0kZhiZ2lN3j5qIyJK1RI1/tFrz8jaZpk1ybbWz0uvCP3q3ki7gL3Six0pdnI0vKOzvila/go7q5XyRDDmgYw6tebJkqfSJjLoMCLU1lEcvaA+M07mZ+WLyWNWQFZZtMxwdmPFKZouCUIL4zjQhlzCck6xudnyT8hsoOl9UwY3+5rrHPMv/glvnZ6s9jfEg/C5RsXQzrVOuQs2GzVoOCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Samuel Holland <samuel.holland@sifive.com>

Allow architectures to override KASAN_TAG_KERNEL in asm/kasan.h. This
is needed on RISC-V, which supports 57-bit virtual addresses and 7-bit
pointer tags. For consistency, move the arm64 MTE definition of
KASAN_TAG_MIN to asm/kasan.h, since it is also architecture-dependent;
RISC-V's equivalent extension is expected to support 7-bit hardware
memory tags.

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
 arch/arm64/include/asm/kasan.h   |  6 ++++--
 arch/arm64/include/asm/uaccess.h |  1 +
 include/linux/kasan-tags.h       | 13 ++++++++-----
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasan.=
h
index e1b57c13f8a4..4ab419df8b93 100644
--- a/arch/arm64/include/asm/kasan.h
+++ b/arch/arm64/include/asm/kasan.h
@@ -6,8 +6,10 @@
=20
 #include <linux/linkage.h>
 #include <asm/memory.h>
-#include <asm/mte-kasan.h>
-#include <asm/pgtable-types.h>
+
+#ifdef CONFIG_KASAN_HW_TAGS
+#define KASAN_TAG_MIN=09=09=090xF0 /* minimum value for random tags */
+#endif
=20
 #define arch_kasan_set_tag(addr, tag)=09__tag_set(addr, tag)
 #define arch_kasan_reset_tag(addr)=09__tag_reset(addr)
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uacc=
ess.h
index 1aa4ecb73429..8f700a7dd2cd 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -22,6 +22,7 @@
 #include <asm/cpufeature.h>
 #include <asm/mmu.h>
 #include <asm/mte.h>
+#include <asm/mte-kasan.h>
 #include <asm/ptrace.h>
 #include <asm/memory.h>
 #include <asm/extable.h>
diff --git a/include/linux/kasan-tags.h b/include/linux/kasan-tags.h
index 4f85f562512c..e07c896f95d3 100644
--- a/include/linux/kasan-tags.h
+++ b/include/linux/kasan-tags.h
@@ -2,13 +2,16 @@
 #ifndef _LINUX_KASAN_TAGS_H
 #define _LINUX_KASAN_TAGS_H
=20
+#include <asm/kasan.h>
+
+#ifndef KASAN_TAG_KERNEL
 #define KASAN_TAG_KERNEL=090xFF /* native kernel pointers tag */
-#define KASAN_TAG_INVALID=090xFE /* inaccessible memory tag */
-#define KASAN_TAG_MAX=09=090xFD /* maximum value for random tags */
+#endif
+
+#define KASAN_TAG_INVALID=09(KASAN_TAG_KERNEL - 1) /* inaccessible memory =
tag */
+#define KASAN_TAG_MAX=09=09(KASAN_TAG_KERNEL - 2) /* maximum value for ran=
dom tags */
=20
-#ifdef CONFIG_KASAN_HW_TAGS
-#define KASAN_TAG_MIN=09=090xF0 /* minimum value for random tags */
-#else
+#ifndef KASAN_TAG_MIN
 #define KASAN_TAG_MIN=09=090x00 /* minimum value for random tags */
 #endif
=20
--=20
2.51.0



