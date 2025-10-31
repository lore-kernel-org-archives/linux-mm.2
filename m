Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3E91CCF9FA
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 11:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DCC98E015B; Fri, 31 Oct 2025 07:19:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48D908E0042; Fri, 31 Oct 2025 07:19:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37CF38E015B; Fri, 31 Oct 2025 07:19:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 220F78E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:19:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB1B749EFA
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:19:31 +0000 (UTC)
X-FDA: 84058163742.29.36A7D21
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id E174520016
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:19:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761909570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3D+nzXv7ucZQUlnqaejAdt3b+XDXtV41k6CcTgwIHg4=;
	b=5ePx9gkuCO3a9GuFAAgrzWRtG8BB4howbJRDM8G9CwcH7SHcPD9lp3AQCaQEnOgMeN3MU5
	UoycQJhbtiQfUqb2xEl59h6WRtPUDA/mbADvN0duyRBVeyIPqx5Ki7wERd9S6Lfp6MdU13
	zsNq0RKhTt476OngkNPoVkPN5CtpRgA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761909570; a=rsa-sha256;
	cv=none;
	b=OkGabRs4bPadn2jTmjNr2z9XT6qPDO4VnJvGFdm1p6kCWw3PORoRsEoAQVxyyrEsrxun/P
	jcszjnHWV1I6FwxmYCpnih3w7abIyso22sXGFZ/ro6dOTu2Jca1SR/+49RJZRA4yr8SC6Q
	0Zoc4LoCvCyYx6qXWnftWJwYetl2VDs=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4cydm13yW1zJ467v;
	Fri, 31 Oct 2025 19:19:13 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 7709B140370;
	Fri, 31 Oct 2025 19:19:26 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 31 Oct 2025 11:19:22 +0000
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
Subject: [PATCH v5 4/6] arm64: Select GENERIC_CPU_CACHE_MAINTENANCE
Date: Fri, 31 Oct 2025 11:17:07 +0000
Message-ID: <20251031111709.1783347-5-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
References: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Queue-Id: E174520016
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: y8wagsq9auieirkux1a641n13ma46m1a
X-HE-Tag: 1761909569-717078
X-HE-Meta: U2FsdGVkX1+e5Rbifz7KBqVPFJzGiVHKy63WqVuRNDk8G7uUxeQ5e1wiWw56fH9HqHh7uCNVnLwQbX2niOmMP4xMqVcdyoZwV0PvaHsY7Bz8FDzz8khLKBtALsR3HkmoHmt1mhxOD0Srwhf/mHfoP+qnOJBkwj5OTM221BdzMFbjeUJh3xkDIdweBAvmrOQSMtHAiNvfCXMYekb1v/BM2uK8WdNyrvHsV4QT9nV++XVde9s0tTIi79GJs1NUGOfsksKi//WNGhWKAe0Flc04Cy+Cw/4jWJmGl8JgaiNiNUixaXOz+Fi0sXCukHyYR/UTgO+LZW1GUSJy3GItiNHWxyk2xS1DeT8Fto2JptCmSyG5xOMxXXf6pVCBP4JQGtPY/2lm7E4EvnbvJVedac7MKEB6FACExWehSJu1IntcHws1KyhyrQf6HPBvzIErQO0cqPmdnHHAsN5u7NSxcHX9NoPV5O041XIVaA1EJj9g7nQW2mM1hFsVfIvxus70NziIaWvsO9W0ZZkijBbwcTNDtovV4MbF3BcjAoFiX55jDa4b1C/lN2vCU3O682eADAl/dxulmiOVFGa2b/WvnQ37sKExXApu5gmHczlJ/fUPx2wMaqNRyJAyB0qhMVsIpqlsuAzhs+vGLQsWKU+IKUlh/MsZcWezQb1CtLxbH7Xt6+U9BihuXvAjQGUV1cXTeUr+PzyWOzqNAEcfr6acEVAhguoj1ylOK+GLlq1hF/TPQ/FPk1pDKTPXzR87v51I8+sxgd5uaLSSiRwRWJ7VYidEfb9PvZfHgV+JVsdb1XV2/B/7rMe8eFSlnrWUCoLEtmemU8qsFBAlaEw43PCLBN1ZViaY+dWkS/FBM2SrE8WLGyX73s14MDyi63vmV8MTwvdvxo+BgORm8NhPKH8kgvNsmxgJpAf2TfUBJoSMP4GKw8L3HQfT8QstZilgrgZ83XriXdKJV8DlQXYFblJIjkA
 rN1VNPMg
 6cCtgoHv3iDqjs48Sr68b6qiTBU0rzBUbJpQbtwG/ZOIDBkQcabBBLF2HRUy+qri1E68gDQMcye3jy/5+AILjfNtPdiDm1SZwqAlaOetD0MmiVElFUtltGm/7EgInKYSvltyLWR850GwJtvtCaR1vGJojp2oFbZL5OdrBJTu+kRzmMfi6lVF4/AAlydn06tBADJG9ToLPx+IuCTXmvgBk3/mDbbvdvlcmKZgoHfrkk8ubyOQDN0pwhzDvfGhfpmS9OISahwPazAihGj/vx5X5dC3H91UGXltC09ET
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


