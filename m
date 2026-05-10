Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E22E1CD37B6
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 13:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A1C66B009F; Sun, 10 May 2026 09:56:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52B536B00A0; Sun, 10 May 2026 09:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A7B6B00A1; Sun, 10 May 2026 09:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31E216B009F
	for <linux-mm@kvack.org>; Sun, 10 May 2026 09:56:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F00588CCF6
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:56:23 +0000 (UTC)
X-FDA: 84751659846.05.94D4A9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4D70240006
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:56:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y9CIBPRs;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778421382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nK9pOZEWFD5eyACdvIV61XMKu+05q5PVM+PBPqSP1iI=;
	b=m7P+/vtCVRoIkeQm+KryugVjgMZvQ+DiJPw+tk3wIICgwlKL0I6PsG9nOMiFeipcEVCDSM
	Ljyfz0y6RglSmZXWEcYHlZBysjj1QeWnZwOUfvcmVuf0rHuaJoS0/QNJz1Z+tZ4Z6ti4fI
	K7fDX+/X4DLnz1psqZmBbTuK65u+eG0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y9CIBPRs;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778421382; a=rsa-sha256;
	cv=none;
	b=414DF3uBOFuJS+O1nLuzX0WyuHgxchPZ8XlyB3mdMrfm9kq4H0MbV8IeeQ6izyR1+nVymF
	sLRhZoD4r7Bd9XQIfjvNfRqmgYV1pfocn89vupe7Bjvh4l/vpdirE068og7kSFoG7tbJ51
	jtuINp31td85HCh4fq62fclcZaW8o+Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8373A4445D;
	Sun, 10 May 2026 13:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC5EC2BCB8;
	Sun, 10 May 2026 13:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778421381;
	bh=FmPjppYqmtQ/uCHJ2PqO1Z7RqOhpoVQASPz+LWTt2U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9CIBPRsZwQvXiffEJfhuKEtVBvOPUiu+xxmZSpQoK2RCxhlOdidlPjYaH2ztd7u5
	 KyX78ObrKB+rGxIqadOoTOVCkVEN/1PmRcQ4vWb8SHzANQKzON+YmsBOZQIpGVbMDt
	 w79lF9elbmc2lpNeM9axwfznH2tej84bXIflsCl46luttE5qr4Ul22mGHi8miKHIV2
	 eoluVt5KARwhPmLaJaAXB6tnQbWswiOkJNYLte4V5mBwd4+dAw7Ekd0uwip5XSj0bN
	 NcBxOb1iKa2n8j0f+FYBkaH+UpYBoNUPp1NrJC1Z4UdY8GhWCN3paZ5B8dA1icDTTc
	 seOWZKHxZa7dQ==
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
Subject: [PATCH v2 10/10] sh: drop include/asm/sparsemem.h
Date: Sun, 10 May 2026 16:55:46 +0300
Message-ID: <20260510135546.13554-11-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260510135546.13554-1-rppt@kernel.org>
References: <20260510135546.13554-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aaw3yzet7r3tginw4meath3dycxwtdpi
X-Rspamd-Queue-Id: 4D70240006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778421382-232294
X-HE-Meta: U2FsdGVkX18Vn0YxfFSa4rrar5iHU3vGdSdLMxi6x+rHiESpWbyjoE1CT5efm5ihELVTJuOioIZ5YpWzt0UyRpiPE5U3Xy01TiKs14FZex+SJDBC0Kwaqrh4eDhwQEd5LcXXiRbMxyUvmM60vQDWyrrY0d0+PUHnx8hGXNYK+286OPm3/oVQ58ZO/daa7HxSilRxYIx3LaKMZ3hn/YyLVXBYVPZydDy12wCWticxE02lrMaKocI1rOEcKPvTZm4LoHKXhyzivaHsHaMlwmWMjEhFCjOVpEQBKs/gW6ZCpoLZJjeNl2MFgitHajLoSLz1pSsvqZtsMe8GZOW36ZyAQ2/Y3D536Z2HUWj83KhVG/bTEgQ7P9uB0GnCmDESpgVy3WoNic2/FXd97KAu7Z4zajBmjZwbXr0HBab7pq14b7CW0SB+OF6uApBbziQyfi7W/ckmZcF8qEUDfMTJuoyfZz4HvfyFNYI51FZX4Xl0OlF+G8d1ObwvAbm36xMJ63j1PgH6VQqUYFfEgESWIjtohQjdEZgxZ1VM297RS3vFohdzw+hQrWLXFxi28yCjdE1ANIRd8hiRBXB5mbIH+RCsm4ZGUkIJZvUvkY7kwIF2jVCDDF+O/MkTVoDAOcDf1hHSkRT2tM+tGAUgs39wZvXkF9hcuUxFaTWOV8W6vP8Boa1c8yxVGG3zIdqvGX2idcDc3XTOqTl6F+0/aD+tXaOU1SBuHjl0xnHrpR/I0oSecyVq2clqxIGE3nrdKJvr8I+yt0WfPo59/vk/VmJz+FsHyp0BqJVtgXEX1rrmAM5xKJrOOShvbPEzM/m0KB7aSsfIv2YBrYx+egUl/hC1nH9gkAblbtKcmLBKJcYOPt0mRY0ftm5fwQ+1R8xzxwbeeo3MFx/wAEFuvQV3XZf7jY+2A/l1om/l9mWRS7on4lv94Tqnik/MzAWCRtyeUyP4lUOy3wr9L4xzoartCLdNEwS
 TShJ7KiL
 Ij32+JORlNaHfeOQodN+Y1iZsX2zehFQEt9rIyPj70++XU4CcIz/WXI0vXzgSNllCmQH8qPDl7qlNyuf+xRmLDC/Au0gRRTSMrEVh5CKCcGuXbyDht9HnrVOWl/IB7sRgW1auDeUJa5wBIEa8nAbtZWJ/FB5YUFFUAnStbZdjvU7rzrii1qoZyt43vSLaed5lri6TssDx7pyPXCDS6qSI1wuiC8/6RxwhitNtnay7vQKBz61oKVEmp2RYorr524jacrf8qHEVvosPQcs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Move MAX_PHYSMEM_BITS declaration to include/asm/mmu.h and drop now
unneeded include/asm/sparsemem.h

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
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


