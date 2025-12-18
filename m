Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C081D68BC9
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 01:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6436B0089; Wed, 17 Dec 2025 20:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8572D6B008C; Wed, 17 Dec 2025 20:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED096B0092; Wed, 17 Dec 2025 20:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B9726B008A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:59:09 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB0EB1409AD
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:59:08 +0000 (UTC)
X-FDA: 84230933976.22.01C4872
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf04.hostedemail.com (Postfix) with ESMTP id ADF1940004
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:59:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf04.hostedemail.com: domain of yuanlinyu@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=yuanlinyu@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766023147; a=rsa-sha256;
	cv=none;
	b=AlJF5OzRvAQZm7x93jxZO4BlCD4zSxkrVBql0c4WHY/J4VR68XESeep7lilMlO6UaT8bNv
	YLzE8942ib+pYYbZnfdekLw1iYvlM5AWW87xBSvu81QaAbzr9tlQnBGdP4vCcmvqzXWyJp
	7AAWjugrtrqtrIlAMTbSMQPiFlBIAhI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf04.hostedemail.com: domain of yuanlinyu@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=yuanlinyu@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766023147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1SXi61QKvEmzRMEh+1xzYP0Tb6bWdmBrzPKuMyImTpg=;
	b=5QRxPxYekHPc0ZZpeiHAvvBUBrvYehpiBMTl0Zfmc8SM4oMF2jQt71+jEhuW/NHjIdqwii
	pIYnrgNkrxHT6f86DtimBmkDseHFulycMhM8hfmRrmgOSvIl+2HgciDm6lJT7JDbmfAoCZ
	rGmCWY9tAZkJkHab/MY8L0FV+PEybao=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4dWv0X2l0vzYqZWX;
	Thu, 18 Dec 2025 09:56:28 +0800 (CST)
Received: from w025.hihonor.com (10.68.28.69) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 18 Dec
 2025 09:59:02 +0800
Received: from localhost.localdomain (10.144.17.252) by w025.hihonor.com
 (10.68.28.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 18 Dec
 2025 09:59:01 +0800
From: yuan linyu <yuanlinyu@honor.com>
To: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
	<kernel@xen0n.name>, <kasan-dev@googlegroups.com>, <linux-mm@kvack.org>,
	<loongarch@lists.linux.dev>
CC: <linux-kernel@vger.kernel.org>, yuan linyu <yuanlinyu@honor.com>
Subject: [PATCH 1/3] LoongArch: kfence: avoid use CONFIG_KFENCE_NUM_OBJECTS
Date: Thu, 18 Dec 2025 09:58:47 +0800
Message-ID: <20251218015849.1414609-2-yuanlinyu@honor.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251218015849.1414609-1-yuanlinyu@honor.com>
References: <20251218015849.1414609-1-yuanlinyu@honor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.144.17.252]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To w025.hihonor.com
 (10.68.28.69)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ADF1940004
X-Stat-Signature: cqtxsdneomy4q3zpy4tjtweyatfjt3xh
X-Rspam-User: 
X-HE-Tag: 1766023146-169915
X-HE-Meta: U2FsdGVkX1+SpDtRadkgVapjeIyv9rVNONRBibTxR/831dhMmzTVsjPGsjL8NvhulMyk46KisECuL6z3cnsXQr1G5YwC//4bn4QmCgeCQ6Ikvu0ZAYSaw72M1joIZgHzpzyGULLl+oBepSFHHV67RyNY+vGBE5KnawSI3PgK1w4VMq1NZWSWv22QX/nKn/pmFE5j8KH8Xk8Luv7EUooE6pIm+VLT9Pfccf7lfFLSePET2gn8wcD6JXxXZnPCHiD8eP6zizAl152YBA7wQk0WjEqu/BH0CgIZSXbevMUvLRMScV6bwVNRbL3zfsWONa1McvogcSvDn4jPxH1G1xjVHYe1Y4Dd6xHMFpf7M59Vg5xPH9F6EtIRIUbDt+48DpDOjcghKVaof/UxrKUr8slgbw7hWVXFboUhyzP7Ez355vmWYAE0COeqIh6zhixdeW/HQtRg3oKC+1f2u/lnTGFzu5uMRbiagVmZHEDjmgTaNV9hE6J9mieM1LY9ZA+SxiZEi6dVJJoKd/Q06hTmG647P5y2Z4jWalG/KMVltk/AKEWFPiGfFeX/yRssSHgzyxAOytMjCCTVoptVq2vdWy0V3oc9nyttVlbQ5nP9d+fOKLATHtVp2WeAG7sVrQGWKF14NkO1n4+Ih1UJFfjuSIuVONUQNsyPGqc+W3P/HIkLBVWfJG/W7grIFC1MJ/X0I9QO0nq49W3ezNOXtJfPKtLG/Jynxh6FiiTldmZuRvr16gsMuaZSTGktGWrjHr0JgLJxnyu4H2ZW4e0vBcrkqak+BnHRG2T1YRXU6p8g8M7xRcFCB+PaRGJQzjBECBQAnvCohkWE29lLm29xKamXZaXQZUSHsCX+sQ17ISXaZQYnf1Ml5QufdMC8Zogv+lnuWdC4QYQUYL7T0BPf85cHKzo1EZnbCBa+ytWkLmnY4wydpG4628XeiG2CUPXUGdf7hLfLoLTxEHUK4Fo=
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


