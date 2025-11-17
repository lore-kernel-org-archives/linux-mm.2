Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7849FCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 10:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0C598E0026; Mon, 17 Nov 2025 05:50:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4C78E0002; Mon, 17 Nov 2025 05:50:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFA798E0026; Mon, 17 Nov 2025 05:50:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B08028E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:50:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 74F9412A74
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:50:12 +0000 (UTC)
X-FDA: 84119779464.04.295220B
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 89B53A0014
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:50:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763376610; a=rsa-sha256;
	cv=none;
	b=UJeR+IAw7JXxvjY+wZRg0u8g6PDnVoRAKxtmoIYoaPWcD0B6uP4bM9iym0lbYr7GDKcbo6
	hFKMPPNgSFFBJGagOmXxhBbfJb92IOhrx7SMf8LWGvwEQVH2giLxPH5opKuwb2KP7hOlGC
	vX7YlLVsWGqKampri7ykPph41EIv37M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763376610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EXcBTB/6lLLcsJPAjlBciSRQxiBAUvJmSEnZQq00JmM=;
	b=TsmTqOyIzq14cKDc136Ns86l4uK77lEscjT39hr1tensLq1ITEzwqh6qmUVMpdmpAZ2taH
	BlSwCpQLq0TtwtGBwOJ7Qb1M1FiF7JhqSjRH5HSiI9JeayZMwf5qYHV56ZuBkK3vC8o9tM
	pBHtXPOS0yhKpzO+gnt2nK4I3PeW64M=
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d94Hr0LwNzJ46fn;
	Mon, 17 Nov 2025 18:49:28 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 7FBA614011D;
	Mon, 17 Nov 2025 18:50:08 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 17 Nov 2025 10:50:07 +0000
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
Subject: [PATCH v6 4/7] arm64: Select GENERIC_CPU_CACHE_MAINTENANCE
Date: Mon, 17 Nov 2025 10:47:57 +0000
Message-ID: <20251117104800.2041329-5-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
References: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 89B53A0014
X-Stat-Signature: ii6173hwwea7ppin58c9thhk4p15fj64
X-HE-Tag: 1763376610-281217
X-HE-Meta: U2FsdGVkX18gad0BGymq2soRRw+0VI6wq6TnfqiUQYFkb8cQ8xlM44YD9PlG4ccfeoY2R/ertlRHwxLgUsRx+NlBvfDogq2P8RT/NXSStoe9rWMeyJpY92oH5dASdx1wpNyVGJYhP2hhNMiaxO/7gXhCyDeVIpm+okA7jCaIrThSb8aNItYs7597eWhcodJy6SB5177FnInYlSal9chFwSXvVw4Zq9BEEfrjar/9Yxngapr9+gWw+4d5c4BSfmI8BodNH7jB2HWYtpGaIBo/VYDlTuQRU4l+mu/VfBALsuakMjV7Pf1jTLtye4vMxAz93Puj0BAUcoGpPigYELWQuGzUVYzxbAd+/SH+/wwoTYjg8HvgUTgT2/WBTwZ9Fx9hT1Bbk0k93t9dY1RmnVChuWC2KBF5jrdDD0qWfB9IbO9BDYDkFcmheNSZZW9IihhT3YSurEIjzbJ3SyvSwsGComx1pyWoL3l6K5e1jdwwyyxmlWNloSBih7ME6f9NLJ5B2cxxvf/56EA81hWekAteFhnqbY12eUh099dfitScd5imOwR8sLdlQud5C2aETCk+tI+dQmNOrm86gBAvPBVcmLP+67si638NIR/02I/O8synwRjpoTjbLWyhf1V5BfyGjYZh+cALeo4tWKX7jJ96XVyoEZt0VRECeq+KIilKIXdfL13cPX60YQR2ZbW9kbOgQH5zyD1vHtFovRshsz9sW+AFrNZ/vJu09HYOmPzLKB5/Trv/RUjo6H8BAtek1bXJSI0ioa1hUO+lewtUApZ0K8txync6zAYIJCNZdaooCzllQrLydYdJF9j+gHCpohsv5iMfpl5VtiwgabpquJB6x4Idr0DU/g1M6MCODpi4aR5dgSD6UAu4Vvda+iUjy8CufGnSgL1pZ8BYH6d0/680sUa52drgIz2yHimbo+Glc6AWXrrKTl6Wu4IhfDOpAhW9bZD8OLbtRZr6jQxMfGi
 MZx8T72T
 QyAdGjr7uaMWzc6OEshoKpYtGjKZdc/6WkdDy4OxmcrPKfsdcBbbBzOsDp1K8biQA+/c/QKJse879fJjldTIXTvBmNa4kOWUv1sbJiGKjUF9CDQAysKLzIEeYckumNsDzmCbw7ghg3SeZQxQERecBdu30z6w7yKJxPUgxt0lyJaTsM1mVY/l0Cql4OUbmkonPAxrINtydglNLVOJ6Uiq+75c3h3QGvRy0RXX10uoczmWZ9d4Kh3Noo09+wb/s0dcKIdXsh1V9qm/S8mEpL6xzeu86dsFz8LGjI4ed
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
v6: No change.
v5: No change.
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


