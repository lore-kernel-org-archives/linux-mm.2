Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F3A3CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 10:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFCEE8E0028; Mon, 17 Nov 2025 05:51:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD46F8E0002; Mon, 17 Nov 2025 05:51:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEA6E8E0028; Mon, 17 Nov 2025 05:51:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9CB398E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:51:15 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A25D12F7AC
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:51:15 +0000 (UTC)
X-FDA: 84119782110.28.A0ED8C0
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9675C18000E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:51:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763376673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OEtX665z2JlcdgBBbipKuUMwN9cWh1oLTf7JBBzxWic=;
	b=IoT1UJIFr/IfkENS5hltdmFc5x3HKhBEL+LTMXHOM24dXKDgYei+n795XID/Y5yJNb0pTR
	Mrjxkb8TQ7rrBy6WdFAsPpe3VZ0toOPriX7mtK0V+UcJoOO2sUrwjIR2aaJMstQ9wRerEf
	JXULGaJi9W8+bqh2g8mYRGdjmJrQAo4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763376673; a=rsa-sha256;
	cv=none;
	b=3ENk/OnIdDYFJCnF5oTEdNTZ/8uFn9NpAuMfeSYg5hA5mUxcCqAs9369BXOz6rNb3T+873
	/WRSK3xoaCPamhLTm2waODxhUy9/Ie5nVZ0BhBt9KB665uQSQgY6kmoB2hG033U7PMDEtR
	gp3XsFUjRJgIkzfy0frqpIZI6XCOZ0M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d94K32LZZzJ46dd;
	Mon, 17 Nov 2025 18:50:31 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id C455E14011A;
	Mon, 17 Nov 2025 18:51:11 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 17 Nov 2025 10:51:10 +0000
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Conor Dooley <conor@kernel.org>, Catalin Marinas
	<catalin.marinas@arm.com>, <linux-cxl@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Drew Fustini
	<fustini@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Alexandre
 Belloni <alexandre.belloni@bootlin.com>, Krzysztof Kozlowski
	<krzk@kernel.org>
CC: <james.morse@arm.com>, Will Deacon <will@kernel.org>, Davidlohr Bueso
	<dave@stgolabs.net>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH v6 6/7] cache: Make top level Kconfig menu a boolean dependent on RISCV
Date: Mon, 17 Nov 2025 10:47:59 +0000
Message-ID: <20251117104800.2041329-7-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
References: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Stat-Signature: exjqd8f6kuxedokr89gk5hcpa738mpg3
X-Rspam-User: 
X-Rspamd-Queue-Id: 9675C18000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1763376673-95884
X-HE-Meta: U2FsdGVkX1/o0wjwNaQtpgIQqGfxvpTFf+fRSgiLgHfW9pk91TiZAEi94CoJc9LESuYuY/qpUS5Vh2ihMk5VqbNM/wMe3UG3FvK6xVnDHJFLt2y4e/5EjKnhRmjdDHDgBMccQN0ewLblPJABAOGoluV/S9wWXQpfCpAqwywlSWL6GKf7hEt0tnaECTgLawi42wL/UlihikrdnoVy+mUQfe2S8YtV8Uj7Xq8fdtkD379gKJcAq/rL2OxmoDU74E1xHZPyyhXrS/SiLEw2zWmPh7N43twDQXIzhPgDg6LXt8lcjojgx3YeOCZsujzlb6X6PVM3O7rV5MLPEoibXm6Hn0mZ9OyXbFhHcbRVfQWIvuezzopFclmiAqwKvM/yf5c8jJylaYCxwLaBXiy4mLCs61R/ONP3zm8RZei6qscI+fmx24p1SAfUw3+8yuiZbnVLI2552qFG7PeP2dyP2/XaMKI9XnAcI0U/u9xVFWEgRDPvykkW34+8uhtcZXGd5Hw9BZv2JQ+L6XfjmEen6UW+ObVH/P9bwb5TRemV9ULSo9BY4ZovJ31cmVxM/txs/k4Bp8cjNIG7OQ6kx5e5aY7e9aKIdXdbCSkSrjW/devCCMU3js59z2WrGEVg1DdukgLIktaPJnY0uijNRL2XGpHzCPbs8tfu/Z5qRqSk85b4WK8uGhmQembgFDn4Iy5SPU/dpYXm0SeSENG4FkouvjHXb6PYnXUuFWJCdLvuhzmdVNcPf9cUqkP1sGzlBqqyoTzc11j3tPXXPKqpsXElb8AuHqCbH2T1fr9OzBuQbpsEpyiUH3fQUQZkTQH+bNcLgzo6EgdThymUlShCyMjF3ew1whvSYaX/ftxjWjHt2OA3BO+n6RfFj/USNsHIpt1wGdN2gT1Ltb2+rj0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The next patch will add a new type of cache maintenance driver responsible
for flushing deeper than is necessary for non coherent DMA (current
use case of drivers/cache drivers), as needed when performing operations
such as memory hotplug and security unlocking of persistent memory. The two
types of operation are similar enough to share a drivers/cache directory
and MAINTAINERS but are otherwise currently unrelated.

To avoid confusion have two separate menus. Each has dependencies that are
implemented by making them boolean symbols, here CACHEMAINT_FOR_DMA
which is dependent on RISCV as all driver are currently for platforms of
that architecture. Set new symbol default to y to avoid breaking existing
configs. This has no affect on actual code built, just visibility of the
menu.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
v6: New patch as suggested by Arnd.
---
 drivers/cache/Kconfig | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/cache/Kconfig b/drivers/cache/Kconfig
index db51386c663a..59a79df4c0ce 100644
--- a/drivers/cache/Kconfig
+++ b/drivers/cache/Kconfig
@@ -1,9 +1,17 @@
 # SPDX-License-Identifier: GPL-2.0
-menu "Cache Drivers"
+
+menuconfig CACHEMAINT_FOR_DMA
+	bool "Cache management for noncoherent DMA"
+	depends on RISCV
+	default y
+	help
+	  These drivers implement support for noncoherent DMA master devices
+	  on platforms that lack the standard CPU interfaces for this.
+
+if CACHEMAINT_FOR_DMA
 
 config AX45MP_L2_CACHE
 	bool "Andes Technology AX45MP L2 Cache controller"
-	depends on RISCV
 	select RISCV_NONSTANDARD_CACHE_OPS
 	help
 	  Support for the L2 cache controller on Andes Technology AX45MP platforms.
@@ -16,7 +24,6 @@ config SIFIVE_CCACHE
 
 config STARFIVE_STARLINK_CACHE
 	bool "StarFive StarLink Cache controller"
-	depends on RISCV
 	depends on ARCH_STARFIVE
 	depends on 64BIT
 	select RISCV_DMA_NONCOHERENT
@@ -24,4 +31,4 @@ config STARFIVE_STARLINK_CACHE
 	help
 	  Support for the StarLink cache controller IP from StarFive.
 
-endmenu
+endif #CACHEMAINT_FOR_DMA
-- 
2.48.1


