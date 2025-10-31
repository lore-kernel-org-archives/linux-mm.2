Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA28FCCF9FA
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 11:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48FFE8E015C; Fri, 31 Oct 2025 07:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 440CB8E0042; Fri, 31 Oct 2025 07:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356C78E015C; Fri, 31 Oct 2025 07:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E4DF8E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:20:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D3E1749E8C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:20:04 +0000 (UTC)
X-FDA: 84058165128.22.F30D02E
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf26.hostedemail.com (Postfix) with ESMTP id 042A9140006
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:20:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761909603; a=rsa-sha256;
	cv=none;
	b=E+lpUp9p70BzRA0oQAf/n/icSBNAMUqBANjOB1RXHgm+ufJpPFBS5HSj2M+pmJPMzMwqkQ
	6NjMyZ0aJ1BYPHEh3fwOydVE/VarHvmOkRT36JFUgeyipWw74VSt7nig7Gtci5pyE8FiFV
	LMSqU2VYJ+DxPrtr5z4Oa4Ju/dyWI/E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761909603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LQPhXO85DTz+Bx0y8rhfUUmeCU1buvTTH78MBG7j5YA=;
	b=hxzbiNexb1pv+TLexmcBOsfi9EwDH5BHB4+tqCh5ktaU6nyaP/ikxcSEfdb3BwweQxVIv9
	qfVDa7aE5G27ipq71IQUuK6oZXlYrJc6O8PjddKkaRe3Mqv4x/c5Z9H8U8DKW7Ult1zTPh
	t/K50YprkDhHKgsZSUfY9Cfc5UKL2Ig=
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4cydmh4WXczJ46Zp;
	Fri, 31 Oct 2025 19:19:48 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 8CC221402F2;
	Fri, 31 Oct 2025 19:20:01 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 31 Oct 2025 11:19:57 +0000
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
Subject: [PATCH v5 5/6] MAINTAINERS: Add Jonathan Cameron to drivers/cache and add lib/cache_maint.c + header
Date: Fri, 31 Oct 2025 11:17:08 +0000
Message-ID: <20251031111709.1783347-6-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
References: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspam-User: 
X-Stat-Signature: 1gksteqhbybznnjmizjjmpjbn34wu6m4
X-Rspamd-Queue-Id: 042A9140006
X-Rspamd-Server: rspam09
X-HE-Tag: 1761909602-765400
X-HE-Meta: U2FsdGVkX1/XtNLGo1LvZhd9mdaz0bsmHCv5isFZ4+3LHtd/2LhqQhEDqHWjVDTiroz7nBMq7DkacRaoewaAF8UxLfgGMhdeG1qbXKTCb54E373kP0bzvojbuUPaB9ImOJ6mqN9fCDgEfT0qxK2eh9Hy34Lt7tw5v95I8qpy/s02aIDFx1sz8bBMTS5oFCofaywUtLNo9VHlul6vjWOUC76i8iY54Z1str1QcV1fzzGlbcCbENJKnGfVTym/mhfqFHEF7pU0W16z75ld6YVBZWJoodTw6XEni9GA/ibVPxHnStWdrqJLZ3rYwhWpjUkQzHIJUOO2jXPAOVdrycNoDuzPFHWIt912BFeJfMYpq/Der2uXoMEYkxSyiY5Civja6/y4eoGHCgIonLIJcU0h92sYu0KP+zqaZpM1PYF77clpvU15Px1HBm/qMBTluLRVjkp0cmkECgemyyVJ7ehlC7p1K/WeOi02S/EP86fSynRBawJ6PrGq4fXMzOj391yd93GmAaBR946LLIocUPrtl+l5ylyAqssYKUAaw8j+bFJlWvorQkj7hWbCwUerpnGld523JrtFT7h+O6VSm507etSaVWzmplvEu9CVIbLcMvz3M32TWq1XlDZGTGj+kaIMaUBEGhFUgG1e7WwtQ/xOsJo5RWFKawvE+oOyWmY83tsXvrFTDm5rpZsBFYfUmaT5p6tVTC1WASLOO8gY+ftZXafb8EZt8NcFm2KwG67Cd65ikWAa0hA7rscTBxY57NGvhbwj2hscgPiOrQbainvpAByF4BV7u5PNPxKxjLGG3aGEYNWkmrLyFTIgs35CLkaOPYY7JfHWGHAfkDFkJFtXClVQByVMQWdfTHckeTKUQtBqx2D65iTDRTvxCaPAQZ8UgJ0Y9cF1X6EyxgGwxu31OP9FbEn/UHs5r+NzqHSqna2ZCeORjhp51X2P3kHHtRLWJ72j87eePddSdU5snjD
 M/RR9uJx
 ew8kXvA0UtPul1zv/dq7kREtK196PD0ntbfbcYBIB/l3Yzr1rHyiopjzGcF5qLlgcXDItoBZfiDpIB3Ru8HZg1jMgya7XKlgVcv5q5ugs56/NwooFMiKVv7oVUi5WYS9gWwW5Cq61VI1rFeas2b8ImbGUTYXsdycdVrbrMwv3l/THGeOvF8uXwsM8wNNxDJev1i9MzqlWamSHBgQLB98k3kcQW6jjak+muyEEkckxyI2O5PXFEZTQuLCwF+zUgyxOiE5Gd7lY0F1luxN0W9AwixGlTD8PLQv+f2sTejipEKuRuuH1AojIDhY8fVfFR2y5rsFromeBoTdrj8OAvQEbz2y5HaXrCuK0Q8hM7ix+eFqsf3ILfeirBqL78g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Seems unfair to inflict the cache-coherency drivers on Conor with out also
stepping up as a second maintainer for drivers/cache.

Include the library support for cache-coherency maintenance drivers to the
existing entry.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
---
v5: No change.
v4: Tag from Conor (thanks!)  Updated commit message to make it
    reflect the added files.
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 46126ce2f968..b517f2703615 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24417,10 +24417,13 @@ F:	drivers/staging/
 
 STANDALONE CACHE CONTROLLER DRIVERS
 M:	Conor Dooley <conor@kernel.org>
+M:	Jonathan Cameron <jonathan.cameron@huawei.com>
 S:	Maintained
 T:	git https://git.kernel.org/pub/scm/linux/kernel/git/conor/linux.git/
 F:	Documentation/devicetree/bindings/cache/
 F:	drivers/cache
+F:	include/cache_coherency.h
+F:	lib/cache_maint.c
 
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
-- 
2.48.1


