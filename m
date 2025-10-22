Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7054ACCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 11:36:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D06C08E0018; Wed, 22 Oct 2025 07:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDEA68E0017; Wed, 22 Oct 2025 07:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1BF18E0018; Wed, 22 Oct 2025 07:36:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B187D8E0017
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:36:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4910E11AEF2
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:36:02 +0000 (UTC)
X-FDA: 84025546164.28.16C1E7B
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6AA9E4000E
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:36:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761132960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=csw/aFut+Jkicky8EbGt5yyfxTSdGpum3xQE8RteYFc=;
	b=2ooT3vy304sYIPqJIQDDg4WkSVxNEAQdFwMimqw0hsCCy3HIAcpbD2pxp59XutXp74ZKQI
	nkxz1mH7awCD/OtPHjOkREThmE5qyz/QHrV617HyWVhlAXeAW7pMeuzBLE2w88AOC3kXST
	NOtT0b0c+mb0Tnx2NDEhrnt21FSzDe4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761132960; a=rsa-sha256;
	cv=none;
	b=e/1zr3RHtseDMUDUeocdJiVTon4wncmmqOxgTe0x1uVF4XrF/HhZ/VmdAfKtKaAqLWf2v7
	mkJY5ISJdqFeqK+0TkEOZmYd16w1/DXXds6KFSb3JOYRwLUwUbFb7+iVPr39HmfoPZXwgc
	gBG6+Sa4X7EVxx2U8xFfEOouAqsxGKo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cs6Ws33H3z6K6p7;
	Wed, 22 Oct 2025 19:34:33 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 9F1CA1400C8;
	Wed, 22 Oct 2025 19:35:57 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 12:35:56 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Conor Dooley <conor@kernel.org>, Catalin Marinas
	<catalin.marinas@arm.com>, <linux-cxl@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <james.morse@arm.com>, Will Deacon <will@kernel.org>, Davidlohr Bueso
	<dave@stgolabs.net>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH v4 4/6] arm64: Select GENERIC_CPU_CACHE_MAINTENANCE
Date: Wed, 22 Oct 2025 12:33:47 +0100
Message-ID: <20251022113349.1711388-5-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
References: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam01
X-Stat-Signature: ujekq4f4n7ozzzu1o93frp4ygyzzdyhb
X-Rspam-User: 
X-Rspamd-Queue-Id: 6AA9E4000E
X-HE-Tag: 1761132960-803495
X-HE-Meta: U2FsdGVkX19x/j7omjPTXiXf2GTwG5QVjpuAZFftAAyw3RWbRM1l1x/9lM0DonZlCi5ZRlnk9haQoKW7REBRnt91R1T6p6GTXxI6ZtdDQwxcPHuocLBEmG4wnI6xI31/OEG6o468wpNHDlCA1yEqbsO4cbp1vVk1Ip1aZ6Y/LCHKp7HrUQA4MtfJf6HL6h+6zftH2F1En6MBBqT1Lh+KLI6sWmow5ndVdQixiG6mGbYXbjrPT6moRDzXl3afsc/v4ZbzbBQbD92F7/jBIu11hLxHg4XCoIO3H1YGqjr0Zauwk/rnvcDS2oZKkX2YEkFikCBsuCh9GZmUiRxX9m74tgmn5xVu1y8c2GIDHCz6oTHQqqxrq1Wosu8g6yNeqXYqxgw49AHfdBPa5Sop80o0ixzvmLKycCiE4JMQwGVaZ94UPuOA0RWO+sB+mp7OMOx5XUsHgVNshkE6IrLijzJEZ2U427a5Flwj7MIUmtkeGPvd60fQ8Nk5ciqxLtKFYm1RsYnElYdYILcyUHjs7D5PMcJDoDMO45wFqdgjhtXqVWUkvEf0Hi9t1lJaciy0ONLeEod54mW9oTDV2BtcqvA8gzMRRsBaT5ajMCvxN3gCBUs1cezjkYijT+Tc0ePhvCgmryl5QTrh2ksEvrQeY2IbrsBTu5EWAqWINF0qRFsCm4t1EeqOJ0cjv81Uw0ePmeX4uMdubUub5U9PUVTcVVNyTOGl9559Md7L0iiMRhym1QY37dy0OgJt/v20ah1TrU67rW2GqoHr8sTvIFq0l4chuG0GC6gROWmETsQvL+OsZIHluWS8LKMOlcRGudaGR3w3smmkUjrxarQsGFUsZk9mw6xMI2ypU/L0/PNpg0gvcCxGq4V0ZnAyfyOS36S9r95B13VzVc9rNUkAV1H9ts9Cg/W9zh1EOJiVpHIt5XFo+4oyYxQQh6eZ5whLIeqwzC9rfSYFwCrynoV6Ts726t1
 gMKARbIe
 rs9maPFTv7KpZ0HGx3HofrmsYhcEdOcGiqzjdPdLycRcE3CTw9ujxDUsn3ZwHzCgi+RtAmao+ptwJ7bPsTcD/Mf3H0hlPz4+7n1SM3WK6EZC3knm5ZcKAZp7hMKtPku+UDPj+moVVoAh8LKRLdtBh6ECtiTHskY61Km9XZ48q124gUiXPTjQDBTQo73F+vS6DHo3gzvkApwchc2KxMch0Qj+G431olRT6Z7qN/kqCEJX0j8uhiZuUqlpvSxgsV1EuOqgHMzhUpr5xjG4zO7bJF0DCbDkkpQu68D76
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The generic CPU cache maintenance framework provides a way to register
drivers for devices implementing the underlying support for
cpu_cache_has_invalidate_memregion(). Enable it for arm64 by selecting
GENERIC_CPU_CACHE_MAINTENANCE which provides the implementation for,
and in turn selects, ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
v4: Drop select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION as that
    is now selected by GENERIC_CPU_CACHE_MAINTENANCE (Catalin Marinas)
    Picked up tag from Catalin. (thanks!)
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6663ffd23f25..893e0af0bc51 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -149,6 +149,7 @@ config ARM64
 	select GENERIC_ARCH_TOPOLOGY
 	select GENERIC_CLOCKEVENTS_BROADCAST
 	select GENERIC_CPU_AUTOPROBE
+	select GENERIC_CPU_CACHE_MAINTENANCE
 	select GENERIC_CPU_DEVICES
 	select GENERIC_CPU_VULNERABILITIES
 	select GENERIC_EARLY_IOREMAP
-- 
2.48.1


