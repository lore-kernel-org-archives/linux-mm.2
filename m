Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 313E8EBFD37
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 992536B009D; Mon, 13 Apr 2026 06:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91C7B6B009E; Mon, 13 Apr 2026 06:47:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859836B009F; Mon, 13 Apr 2026 06:47:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 756A56B009D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:47:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4746FB5042
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:25 +0000 (UTC)
X-FDA: 84653206050.20.D861835
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9AD444000F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iTILtthu;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776077243; a=rsa-sha256;
	cv=none;
	b=UK/wMl/NMAwwYHf9B21hpKE8Pu3A+L4ndH1ewn9YWRFipgGKKljPF47WnO2rlnnALxHrSN
	MYnZeKbr5miJGnoHmdl4p+XAq2m6g2egJSqHjd2lQmtXlkxTW8cBiYlovVaAB3DnrKkQOu
	zSQ4SMsx/Uw2fHXFmOGXgok0hYUxrZY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776077243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ls96fngIYO9NqDAwLA0quM9pbFrDBipSm0DKBXDvGgQ=;
	b=XtIFN+790s0pZiIN1qgwQ/mcvSpU1xUtF+gExvlNMrTjItq830jddbOGdey4Tkn8sgFGa5
	MKUncahqAvDMUPlvcZFkWznNTFIn1Xc3YkczzjdCz6HIJwYZj3rblN+TodK9I/iawBL94M
	ABnuHicT8ZFZwuDhtNvB/OLC/dtAqUs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iTILtthu;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 92F0B44579;
	Mon, 13 Apr 2026 10:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2E0C116C6;
	Mon, 13 Apr 2026 10:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776077242;
	bh=lvY8/CoxdcUj05A6GOXsGloszNtYBaitN2QjjVRBlcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iTILtthupm/4gmTKWZXhsMVLE/4dux9MQkCta1L3VKbjBGwi5rfxjzuidNR8jJmbS
	 t+eNE63HRvaO1KaZtgDsAuZncVcKioArKuGmD8/p75TUb2W2DOlMfUYfYG4VUOc+3d
	 eYIKCKIP+7kBFqIT8JkKHCWVea+/dR+zvY7IhCq/XZxMqHUh+VaMo6hX7rxQdPE/B2
	 1z3CrDCo9skf16ez+6F3y4a1gJasZAEsk13quWWOr+wytIygw/Nu+JqOHtL2+vJ2Xx
	 4GKDwPWZq7expq914q/QrGEqxeCIgkfP8TkE2zjaAKZ8PwZLVX4Y549b09ginUYcSa
	 926oMD0kxLmNw==
From: Mike Rapoport <rppt@kernel.org>
To: linux-sh@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Mike Rapoport <rppt@kernel.org>,
	Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/10] sh: drop include/asm/sparsemem.h
Date: Mon, 13 Apr 2026 13:46:48 +0300
Message-ID: <20260413104649.852228-11-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413104649.852228-1-rppt@kernel.org>
References: <20260413104649.852228-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9AD444000F
X-Stat-Signature: aaxrrocnk4ogwtxdy731aiudrcksdx88
X-HE-Tag: 1776077243-119697
X-HE-Meta: U2FsdGVkX18N3UoHDqvpPRxKWnHuOYAcclSEwClYt+ObDCfyEXTVdd8x+s2LWv97wAD7NKIPmSOvS7vwiEgUpTpWe/OVX5V3etH/SEwX760DB9pw83QMSZ201Rx+pYiKSvazFEdTepgdKRRa1Zzs8ICubCR5KPRUFKBWeyLFJjfNecZtzkuZODfALqmhntCKodbODPacW2YS0VqwBjwizkYqiLudlIpCk/01aY0S/rGpnncVjwoqpyUfmxhwWLoYcDXJg0DNGJKw0ar1khZIv0hUn9HuNIYrRTY5SNI6tyYHCj8mchEaG4QDIMWlzo+DS48pap8c/AAFl75eva4iGtBjBeHiUF9h1/KeZ4jt2V422UAQYxHnrM3Cayd5OMouod9iVZfJogNG2JkMN7+jrbB5QsuUxhKfsNj3Q9fVnIp1Jyap5zz1dZL9oRKZoTF30OPtvdAty5m/sM1MONzs1Yb1WepD5jG8Ea/PFlcArq/9FD6oDN2jTYVIkHO6jIj77iMmTl2UEZerjiWFLFIwmRsjSMRhoLHHAw9U2P5C9c84qulLcY+a9bxPbUGDR7+7TPpEN45EDmKtuXdME+R5MW7j2RwOeOugSS+U2MkbvuK+wCFevPOL+AMnDFL3f0qHMNKhlZe/ykOgwQREZxa/otPOkS0uNdxxEMonYa3aLGnd21wrb8efMSi9E2RKeKrmgDeGSrbauxWQAICEe3LJFB0hnR9Z/hjsgtGsDHACI0KNu09m14RW3HfRop05HmqZrqFQfi5mGWjGxdfo9pT6uIorIdIsbsRO+EMS1Tq7qCUl994sWp4r5NS/ov3HPIGm/CS50ksZFA3kOx8y7Z5WUKec5JApFsh+2vGprh4CctmO95Z2ojZso0PrG9Clpvd3VZ0FzdofgXmx2ccWxeHnItmtFTfqv3A3bK3fIemBkFeuzVkai4jPMtPu/kThG3JY2snS059o53N0Gm2U6EJ
 wxMIkgYF
 zhox05YD8y36Y33Yth5MohOFxoDCT5uvza/gketGweZa77LsAQVahdjbVjlvfkMgv5VWZUo+B6evYlox/SXejxHSka9vE3sAfhi8fsv+kqS+ateNd6mpMmNYTvwE7xW7a0oAa49qeeDfRYn0satw45CBHgV+T0xNux7g4k6tRI68iN2xvHHYFXbYIA9cjrptMRL4pg0c8VnDL/krzKAoJOYcWG611/E6YWmPEaz9ZXBCySmXwGFIo7H9b5fbSjlW8z5H6k8i1bGNn9WU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Move MAX_PHYSMEM_BITS declaration to include/asm/mmu.h and drop now
unneeded include/asm/sparsemem.h

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/sh/include/asm/mmu.h       |  2 ++
 arch/sh/include/asm/sparsemem.h | 12 ------------
 arch/sh/kernel/setup.c          |  1 -
 3 files changed, 2 insertions(+), 13 deletions(-)
 delete mode 100644 arch/sh/include/asm/sparsemem.h

diff --git a/arch/sh/include/asm/mmu.h b/arch/sh/include/asm/mmu.h
index b9c9f91e6616..def7c1edd605 100644
--- a/arch/sh/include/asm/mmu.h
+++ b/arch/sh/include/asm/mmu.h
@@ -2,6 +2,8 @@
 #ifndef __MMU_H
 #define __MMU_H
 
+#define MAX_PHYSMEM_BITS	32
+
 /*
  * Privileged Space Mapping Buffer (PMB) definitions
  */
diff --git a/arch/sh/include/asm/sparsemem.h b/arch/sh/include/asm/sparsemem.h
deleted file mode 100644
index 4703cbe23844..000000000000
--- a/arch/sh/include/asm/sparsemem.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __ASM_SH_SPARSEMEM_H
-#define __ASM_SH_SPARSEMEM_H
-
-/*
- * SECTION_SIZE_BITS		2^N: how big each section will be
- * MAX_PHYSMEM_BITS		2^N: how much physical address space we have
- */
-#define SECTION_SIZE_BITS	26
-#define MAX_PHYSMEM_BITS	32
-
-#endif /* __ASM_SH_SPARSEMEM_H */
diff --git a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
index 43d0f7b62b03..99f52d888aa3 100644
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -41,7 +41,6 @@
 #include <asm/smp.h>
 #include <asm/mmu_context.h>
 #include <asm/processor.h>
-#include <asm/sparsemem.h>
 #include <asm/platform_early.h>
 
 /*
-- 
2.53.0


