Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2981CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 10:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E6938E0027; Mon, 17 Nov 2025 05:50:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BD478E0002; Mon, 17 Nov 2025 05:50:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FA9D8E0027; Mon, 17 Nov 2025 05:50:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BFC08E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:50:44 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4A85C0BEF
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:50:43 +0000 (UTC)
X-FDA: 84119780766.17.1C1C9C9
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id 05E7B1C0005
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:50:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763376642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tK3oYGj5fCGxbjc5Wx0/dNr6eylsijg3aHETP7B0LpE=;
	b=z35XxQzDguo3biDVxAj/E12ViK3sLu/bofaIFGBGLkrGXEQeqce7q66nGfgkwNpfjujCex
	1dLcwXcErEumB41uo0O4YHw4ofwzmtSsP9X1UJPt112BIouX5qANXPx2O+MEqxo0vZGZSX
	CSpmdBGBiB4Jc40ethcufoPjQdEBArU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763376642; a=rsa-sha256;
	cv=none;
	b=42toY37Qu84Q5Lv5oO0KE3J1eIr9dIKXPpcUJ1h1AhLfGjqsGPsbr9f+3kM5K6a1Bvj7Gx
	pJqBiwOvYI3on9yCvmr/JlfMPwIi6hJTT3mY+gxxwHzglCbU9sA9+7EnjowwdDno/wFaVp
	R/bzYjo6SB8J+VvtkCF+Xhdk9N4jXRI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d94Jg3M5YzHnHF7;
	Mon, 17 Nov 2025 18:50:11 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 2946F1405E1;
	Mon, 17 Nov 2025 18:50:40 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 17 Nov 2025 10:50:38 +0000
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
Subject: [PATCH v6 5/7] MAINTAINERS: Add Jonathan Cameron to drivers/cache and add lib/cache_maint.c + header
Date: Mon, 17 Nov 2025 10:47:58 +0000
Message-ID: <20251117104800.2041329-6-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
References: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 05E7B1C0005
X-Stat-Signature: pm7yrojsurfrtm3ziteyk3igqupqnukt
X-Rspam-User: 
X-HE-Tag: 1763376641-574808
X-HE-Meta: U2FsdGVkX1+UP12MLyd5vNscl7sFfAslxWbAc9fguAB3Yp3r1f2qtpYEfrMKrjw0veL6tKyJD/ezmIP9AQlyAkzwSYhw7+iw4rz+GuaJGfm66EKdB8Ht/ecLZFCDpF0Bv/N6K0kDA0ztg41xyWfj/yRJyexKhqgPaZdcmRT3WQHp46N+t50/gS7g4jqG4k+6/9J3gX2CPMJfKOYyWMjuAhotoZ+uYWoWBQUJ/uvuduuFXV1SFK7L2PufZ72h6fJLeiOPp/3ID8hdBGSgIV4Az6yQ9Wns8xq8Of2Ue+NuR+eFyEdwjdISJcnJCYY5fQ7mYliWFvJOovfS2Jpb0hYNIB/aiXE4kFLZp8F9yCk4rdpRclWqTIcD2Cm93yZLSnR+PoczZ8aATeAJRa7orsNHHeRX78WWViUnr1XGILBh7cGjK+jWzakmv00Go7BiCQTS/sFAkfAwMLDn2rnipeBmeKry832ragmqaGnrE40Zjpd6+qGf4bk+BHRHIL7Six5Et69SdKidU2Dc3exAbPKjP+eet0NHtO2mrbARJJMhXNtAMoN8cZqw1MbaoBVJNltE91R7QLWf6HKHLJGiG3A81G0ArdVHV2CvPfc3IGtH6Iyk5hx53wdwbRlrULImi3VvGFSJJxY527PjNKtTFnpQuifUcwVuvsB02StFT+dlNWGuuuleWVzRe8d3iZ+VjZ4N0hlsSSbRzpWOoK7+3ZRFxstY/+Vtz4kIx9o/Kvk6SZZCg7moEUGuTBCv/qtcg/BxrICS/tlV+ooW1n1jYY7qy16Mpu/y4HxsG3fX3Xl66FABGgNYYqOUbz0gz7ubiUp2n/yMe+5FnDQP4pDb7t7g+SMTka7/U5cUVRYsCzjoaReyldSWIECptGAeQxadSIPXzyZE7Yq07H27rFX3IRYL7GJXCN465Q6w6m+jsl0xhjPBJlXWbxdYAg==
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
v6: No change.
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


