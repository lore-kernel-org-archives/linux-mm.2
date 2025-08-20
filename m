Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A532DCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 10:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47CDB8E0053; Wed, 20 Aug 2025 06:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 454838E0003; Wed, 20 Aug 2025 06:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 391F58E0053; Wed, 20 Aug 2025 06:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24FA68E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:32:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DAA2714039D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:32:32 +0000 (UTC)
X-FDA: 83796771744.18.036FFB5
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0B0B3120010
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:32:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755685951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4SLF8njMGx+hMY0EzSzRQAV2g0lPdEnnpMoXSDXffQc=;
	b=nhliaEPaFfjaZVN86zmOeQPIh20le4LQY9smznvIScj+L2SWhJMTR4nJjjzPyioeekxcDX
	afrni0/ZHCL0qrbLAKn3l+O2MuhW1DOUDDctS5FrTXl3ID+DALgF8OcwgZ2XIcIFW8fH8G
	+BVWA/cmTCtKS7YkiMNS7Ysv0/BIems=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755685951; a=rsa-sha256;
	cv=none;
	b=KmPpI1TKwrGizrO2q4Hc1g+pddn+h2m44X7nj8NUOdq2UWQtWlZqdmkD0AXTD+EJKMv+u3
	uvHcl/dtF8vTEM8CYZ1C3WZB8QFyT4XaN68agXwHMNM35+dIjCro0Leb32dUCIaZnO4NjO
	BxewsBLTnZwVxnVj0PtuAkr14PVT9no=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c6N3p27HCz6L5wF;
	Wed, 20 Aug 2025 18:29:26 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 36A9A1402DA;
	Wed, 20 Aug 2025 18:32:29 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 20 Aug 2025 12:32:28 +0200
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Catalin Marinas <catalin.marinas@arm.com>, <james.morse@arm.com>,
	<linux-cxl@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-acpi@vger.kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Will Deacon <will@kernel.org>, Dan Williams
	<dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
CC: Yicong Yang <yangyicong@huawei.com>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>
Subject: [PATCH v3 5/8] arm64: Select GENERIC_CPU_CACHE_MAINTENANCE and ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
Date: Wed, 20 Aug 2025 11:29:47 +0100
Message-ID: <20250820102950.175065-6-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
References: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 frapeml500008.china.huawei.com (7.182.85.71)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0B0B3120010
X-Stat-Signature: ye75mfdow3yfwd77nb8urfsqnhtgkwa7
X-Rspam-User: 
X-HE-Tag: 1755685950-459419
X-HE-Meta: U2FsdGVkX19JabmMO+8zzC8HsJyNR+qQCUXehZq2Hyp/IrzBmp3pYHN9BnL165tvoeN+oe2x2oGUpCB5+d3aNembSRl5RTw+RRmPvVHDfQvGtbn4vWK0eGGV7s1thArYalRc9Sve1Pgyuzbnfib5sRYgDcm8WWdXzkcAM9HwKYxsQKlqlQZIohH1UgdqZNbS8xitAgvo5N/269PKAZInSNMl0+A7qaIkWtbOsoRUr/drUikfurkwizOPgsL9pNYUqGXrarW86agZqiG4xfNan5Y3R7IHqOXDEQf/PDuwLA/OqwcV2QXoEkSc/Ovxbip+h9JxNe5IOHnyb2sdM+U9Cc/Fq9jK1/m9fQUNH3Cdyt0Oid6yrhjAobQ4kz9mitOjZeaGvJZEbTmZXY8xv3jH3xM7NsbyPQ41iPd8cojrVolxXlTxIgJjR9gVWAgWsmvNCCQqqR2OY0IdaBbqgWTc2U0df81VTp4if6zbu77WQuOh9NBY+goYRBxVwwrANvm9+2uOPAVRS8spZnQ7JwjPJk2NEisx/mPscY/u44eRq1POarRZACLYqHHxSJ6xCz4DQVcgI9ZQ3067eaMZ8jwM5tG6C8nCXtyEsknBoU/ReUS3NGBHVhsS/MjGdy9dan9isnvPqeCv2Bd/KKj9kO15PlsiRss7gXeqVJ3ndI3jgSmpplCKxteU+svjwKyiDakfYIMwDxmuoUu3Z5Xh07vcYmvdNPUZVM+rC3/xV29y+p3Qd5VSyLNZXTp3OX2JSemzkpta46rjiH7XXacl0DeIZSVaKWy5oUjfGFJEaQ5ZJe5JQHKlIy0Bd9z5+OkVUWEhCzWJoyuYQZrCiMoFVQD9DIIetYaTifWoTtkNM8cylkc2i9AlgkRQNJjnMbyeGqLzv2QEjQzmAIDoo7xy7pMNrCknwZEh0mwgKcCBFMLijt6Sd0pZPH00oJEbNBct70HYl6knaYGVkf01QUJOucc
 0ecOZlSW
 tRuWI5adMoBPOxO0THHl5c/bbyxeBZ5FA0IH/5KCmDcxkkORN41jbFXthufdXO5cLb2dDv0umqfQagyf8OwX7h2190m7OyXUFu/nhSUY3SVedfwCdKfZFjiXG1+mlapc4k11y16XQ4YBJ/MDeutnAbI41h/EcVYjQsqH/fhs+V/mJzkzBoh4QMVEVAGspf8MkJJ4jm6zUvUKY9DlprjngE2hHAYXzAilHSEj2EYu2OHAU1ck=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ensure the hooks that the generic cache maintenance framework uses are
available on ARM64 by selecting ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION.

The generic CPU cache maintenance framework provides a way to register
drivers for devices implementing the underlying support for
cpu_cache_has_invalidate_memregion().

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 arch/arm64/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e9bbfacc35a6..15bf429b3f59 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -21,6 +21,7 @@ config ARM64
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_CC_PLATFORM
+	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEBUG_VM_PGTABLE
@@ -146,6 +147,7 @@ config ARM64
 	select GENERIC_ARCH_TOPOLOGY
 	select GENERIC_CLOCKEVENTS_BROADCAST
 	select GENERIC_CPU_AUTOPROBE
+	select GENERIC_CPU_CACHE_MAINTENANCE
 	select GENERIC_CPU_DEVICES
 	select GENERIC_CPU_VULNERABILITIES
 	select GENERIC_EARLY_IOREMAP
-- 
2.48.1


