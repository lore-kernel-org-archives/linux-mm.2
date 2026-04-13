Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D49C7EBFD37
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488C16B0099; Mon, 13 Apr 2026 06:47:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EC0B6B009B; Mon, 13 Apr 2026 06:47:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA236B009D; Mon, 13 Apr 2026 06:47:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15C606B0099
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:47:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7E6E540FC
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:16 +0000 (UTC)
X-FDA: 84653205672.15.C6A18E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 212B8180006
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CFWh6Njy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776077235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mXZraA6O/JDdwGMPueXWPQRK8CEQTtjNtDASu0BQO84=;
	b=v4ob+AywkA6enmfY5qMBALAtUYfARbCcMWVdlrvaLKCM3+13HqfRQg+LU41LcosZr87k7Y
	VQ1nSNReL3ur2/PNW5/SJVq3iaKblbbB8xF7Ca2M5VEXBm6kduHP8qUOPPVXe8W4aXSqPf
	Bdp2Xj2DmII+lTNHU38J1Ag1SD/3Zds=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776077235; a=rsa-sha256;
	cv=none;
	b=6RgQ+vy/qRjjerLQnxAOjbsrMu001oGoZ1Buy8pQ590BaTvuWNs9be0TCsURXcC61Sn2yx
	VvDStvNW3I92BBfZz7oXWzXxFUdodS+uGuxVVUGijKPK+dd4vQn+HoW1gsHpDrmvZv5Irl
	KUDiJSFoqmuIIWvAT/KLkyeZxGXgOtU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CFWh6Njy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5588940B72;
	Mon, 13 Apr 2026 10:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A66C2BCAF;
	Mon, 13 Apr 2026 10:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776077234;
	bh=w9l+WDeNQIEjr29WOlkvK0OiSqXu58rsWU3JJJ9mskg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFWh6Njy40ZFutVv1Le8/k0/LKKAasphDLxpZJoBJ+HkrOQWeJx8deVpGFN/j7OcA
	 QMIOEZDqPTdUEz0M88LItJyYZ+ZNriSYOH0VEurK7Tl4Lpzmd5jqxNVA5h4KT6hxBc
	 D4ig52tzPvVGzjSmaGD6YV9fHXAwBafV2n0hgSYHAV+0aeBURSd6jXis4H3xykikjQ
	 kxexg88DsDwXGs+Ybdbtk6Kj8nNS1sBkZh3/B8Suhj0toGNAX4mVSzS/tnybsoGDr7
	 ib7BM+u4Z0Ajvj19yIl82GcHrAoJeVt8t9QLc8TQLKxbXyxdhDf/K44OCo7lZTNY21
	 ZY18VJszwwCwQ==
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
Subject: [PATCH 07/10] init/Kconfig: drop ARCH_WANT_NUMA_VARIABLE_LOCALITY
Date: Mon, 13 Apr 2026 13:46:45 +0300
Message-ID: <20260413104649.852228-8-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413104649.852228-1-rppt@kernel.org>
References: <20260413104649.852228-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 212B8180006
X-Stat-Signature: 7ppfnofb9w44m6j8xgj3ozxpejs363a5
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776077234-454030
X-HE-Meta: U2FsdGVkX18lfinxjVmeUrnvPIG2w7Ql2kfbLpN2fEG1LYkgviRq0A8+HDNYVygfqFq9zPfa/BPhVuMZo+ZyWLDeCG6jXzFDuLNEA9rBYBcOMxmKWnfasOPofxJHJXrj9t7xcB2m0iV7AIKr0FJlTKi4ak1ffcnlrUtW7bs0HWrf5aiLxX2MiKlVhbRMkhkUwlYOanQ7y3WX+9PdABbppAUCR/kBNojNQU7SPYqkvCaGxiOgK7XMU7LFnWO07mD5D1qYo+f2C2XXD8cRuxqf8JnHKiO2a4CzhvsOdZefrtGnRXvSn5bziF0tYeq+yQhCaMccdGQNfflYN3opevKC6fShyIv7rN2RXoivrUvj4HCLRGok75o87i/2UhJJmzAWGHk30ykyBwkupVqkeszwBDxAsYk07BEEKv5DvmqY7IC1XfQiD/MPoaIfuhbzK6uOAuSUvbyhzC659fqXSS+VNo7lY5UbmYFFOkwtNK0IVeuAYb4kPWlegv1RPLA8y0NCNtsPo8SmhLCVEwmwvtfOoeyduVQV7bLmvXxxu1QO4YU51uwUttO7Sjz6s/4o1Z3MYts8qC9z0vLhq3juklMNesPcRd0qNFqE23KqCIJRMgXf4cDijNvGjDVC4rWl84SgV5Eo5INpdt10mZhMZOU06VB8solPhnTABUgPjIy5gcO711aLl9Z9EWZR3Onh70tYzVmvtGAvSM5S75wxhhdgcWBqfWxy5vQWGfkAI92XZklFGrKFZpuJZ1/zAa1z6m+PXr8SmnSpKUBv1PRmoz4/zYg9GDhHlxNIFyEY6Raw/OkwIED1KqUMHHHnk0gGUYUiYtybcQCUJZKpnL0NYVtZMEOt/cgzP69i5LQIGXC/USVjvYGFOxUpZ/PDRyWzJJZ5VZM2kkiN5ZO1HhL9uxmgtRPNPFBiMLKfOci+d26RBuA4ZA2kOwy9BuFhQsw4uSLzGiWIEHc2IuU4ymUF2ZJ
 LHZAmfMH
 hzMDVcqsPvlxEXi15lMF9G8+BDPD1dSMUmIGIjRCAMTr5/ekZawpnDXebLc4ffF7iLrc9TnYKzfjL2s6VpOPGHqR+WrFFOGcOzF2Xo+U7qWzdHRlzC/HFwkFjRnqcFbPOrl2EIoNJmr0G+n+aOXcIxUAvjtoo/v3vtbNnPRUZ2T6GdTjF+lgRTz4X1hLQ0Y6h9UsA+r1Sd6Nc52Y93ZyE7NInezvU7dCkzDaKSCcrg0YQH1ge64sJ17Gl/2yIqUVmSrnyeWfbfO+991LBQJ46y9PAFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

sh was the only architecture that selected ARCH_WANT_NUMA_VARIABLE_LOCALITY.

With NUMA support on sh gone, there is no need in this configuration
option.

Remove it.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 init/Kconfig | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 7484cd703bc1..c31fb292729f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -987,16 +987,9 @@ config CC_STRINGOP_OVERFLOW
 config ARCH_SUPPORTS_INT128
 	bool
 
-# For architectures that (ab)use NUMA to represent different memory regions
-# all cpu-local but of different latencies, such as SuperH.
-#
-config ARCH_WANT_NUMA_VARIABLE_LOCALITY
-	bool
-
 config NUMA_BALANCING
 	bool "Memory placement aware NUMA scheduler"
 	depends on ARCH_SUPPORTS_NUMA_BALANCING
-	depends on !ARCH_WANT_NUMA_VARIABLE_LOCALITY
 	depends on SMP && NUMA && MIGRATION && !PREEMPT_RT
 	help
 	  This option adds support for automatic NUMA aware memory/task placement.
-- 
2.53.0


