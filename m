Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06406D68BE1
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 06:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B51D6B008C; Thu, 18 Dec 2025 01:39:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 956536B0089; Thu, 18 Dec 2025 01:39:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ED086B0089; Thu, 18 Dec 2025 01:39:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 618106B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:39:27 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 12E741A0D22
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:39:27 +0000 (UTC)
X-FDA: 84231640374.21.ABB5C4D
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf05.hostedemail.com (Postfix) with ESMTP id E0625100006
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:39:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of yuanlinyu@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=yuanlinyu@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766039965; a=rsa-sha256;
	cv=none;
	b=EMY2dSJW+Yo7T54b7oN36zFUD/I2ksUIiCkGE7OokCnk05le/VnwlELO8x7oM0+ofnwQ+x
	7KmtycVrW8Eh/5eplInbULqvqyZ8gZducjwddOVB5U5Q84a1MKLrAck8QvPQzy/1b5WI93
	i11j8FlfNbiRcFwVTTp1IuYAFHNmRzc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of yuanlinyu@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=yuanlinyu@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766039965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1SXi61QKvEmzRMEh+1xzYP0Tb6bWdmBrzPKuMyImTpg=;
	b=uACQ4nWi1EzOOj8OntoqwlP3ZveMjN9HzCCB8NXuhy4hF6BWz8FZJt0Lw61RUrXy+IOM8N
	NbU8LHEyGRtCwkAStQ0SdZ+Ow9xpVKXHC5f5MIcp0HeBuz/ROWCIB6TynKKuDCIilxrQq3
	9s6tjooZXKuV8XwDBXJFlKQK/q6KBYA=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4dX1Ct0YCHzYl7Sg;
	Thu, 18 Dec 2025 14:36:42 +0800 (CST)
Received: from w025.hihonor.com (10.68.28.69) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 18 Dec
 2025 14:39:19 +0800
Received: from localhost.localdomain (10.144.17.252) by w025.hihonor.com
 (10.68.28.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 18 Dec
 2025 14:39:18 +0800
From: yuan linyu <yuanlinyu@honor.com>
To: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
	<kernel@xen0n.name>, <kasan-dev@googlegroups.com>, <linux-mm@kvack.org>,
	<loongarch@lists.linux.dev>
CC: <linux-kernel@vger.kernel.org>, yuan linyu <yuanlinyu@honor.com>
Subject: [PATCH v2 1/2] LoongArch: kfence: avoid use CONFIG_KFENCE_NUM_OBJECTS
Date: Thu, 18 Dec 2025 14:39:15 +0800
Message-ID: <20251218063916.1433615-2-yuanlinyu@honor.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251218063916.1433615-1-yuanlinyu@honor.com>
References: <20251218063916.1433615-1-yuanlinyu@honor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.144.17.252]
X-ClientProxiedBy: w010.hihonor.com (10.68.28.113) To w025.hihonor.com
 (10.68.28.69)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E0625100006
X-Stat-Signature: g776szjmos8txqx6qzwpo353g3ppufzx
X-Rspam-User: 
X-HE-Tag: 1766039964-642144
X-HE-Meta: U2FsdGVkX18I5dug/FycnsxrJNIqhwW12rv4b16tG79UFetIvBg8MmUAns6mbqnetovW5GtDPcJmunIIr2hk5Ccr7qxuhhQjQNHtsjIi80YYvIGMbx5LNmsiGZhaS2uTbATAFEJzCxy60fcZybCGxLtOQvqlCSe2JKRfGLAZNc9l3Mx+DBN5rUGsYiHpkYKLlHWxO3wIyOPd43DvF2ySxn9Vze8afdxWK3JLkxNB3y5Wctl3Y5uZmLNon4pFkHx3DM8S2Frr3rQIq12aG4TdoI3ylkJ/f0l4GW375O7b/Ss88+4NnDEcjG5ePn7C64cjJa74n/BYvO4DpjRVW9bkE6h5fVTmkDc1Cu2RdXwEvUw7dARMsEBm05TJxXo6Xnv5hXiFQ+fWKvYOFKorEXXUcTXTp4aY+GE3J7CPM59uHHHEjUg/VkIzY+BA/47o/FpkwELJLKV1H7qJlzW8rR1jLLhF3vo2yb5LGm2NunUKE8AzBiXG6mSGHXv27qhi3GfEVtAx67T1YWMZstc+eYvG7L0zVXMygc6Oj8+dK2VjkSNeLalzKAJ+Cn2gBQ5IMCxxDsTrDJbZlhToRyU5088ELMVcoCkRYktLJ0fUDh1wh5EyTywASE7KqIPXIiot7Ou717RKnLGcBNu6cAqdTyXOs3CJf7KvaoDQrS1SWyUmE3kKUnEi8FP35PVysFOCq9ztDAf0rLpoWzceQYnGRgmmg3GMyU2Gk+5ZoMNGOMsCn9e4ROTiDI+bZHeJpPBjLf0y6s9FRWpAM+Yg4KRswWtKN/mNPTgOOw2dhJeDZavmeczvz854sl6RFt4C1KVbQQ4OcpAj7vWhcPYcyhTjae5FLkGgGYY6VHbG7xqsyB0kYNO5I0TiuvVLwjl0mhgJRjn1oxyEjeS0dzRMkjElI30gM4VMiG7q4y5M4KA+h7AjehjEWh2iMVDCeICXkJQyROHsDTtRA6tqDwbuMhEMudR
 IIeTkfN2
 mzzT4NpRMDMSgBeT4i14WeYamzmajHGjrAWdgLoeTnE3AN2AykW3LKNI0dc46//oYtfz8/R9WCBnVIup/fZhnL6t/hF7zAnfG0qBe2tc9ds/iATwExy9j+zlY3FaKF0NYPHytCh1TzU5Ris+F1CgoiCj8ttJBRhS5RnUGZEXLWHjGZBZYQ2+yyiQ3/jSdSf9zwUdVLlns5FVmBiMY0MwxkkupFvOZPP4evDp1R8dTQMenAd6pbDgv4aFWJ+ujfQDtVOUurm4AM3rMbKqsdkoUlrpsfJ0Hssz84pZkUtpfB6Nzt/hSdkDpaSAPn4+agHqJjH+cU+ULF24PO6Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

use common kfence macro KFENCE_POOL_SIZE for KFENCE_AREA_SIZE definition

Signed-off-by: yuan linyu <yuanlinyu@honor.com>
---
 arch/loongarch/include/asm/pgtable.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index f41a648a3d9e..e9966c9f844f 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -10,6 +10,7 @@
 #define _ASM_PGTABLE_H
 
 #include <linux/compiler.h>
+#include <linux/kfence.h>
 #include <asm/addrspace.h>
 #include <asm/asm.h>
 #include <asm/page.h>
@@ -96,7 +97,7 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
 #define MODULES_END	(MODULES_VADDR + SZ_256M)
 
 #ifdef CONFIG_KFENCE
-#define KFENCE_AREA_SIZE	(((CONFIG_KFENCE_NUM_OBJECTS + 1) * 2 + 2) * PAGE_SIZE)
+#define KFENCE_AREA_SIZE	(KFENCE_POOL_SIZE + (2 * PAGE_SIZE))
 #else
 #define KFENCE_AREA_SIZE	0
 #endif
-- 
2.25.1


