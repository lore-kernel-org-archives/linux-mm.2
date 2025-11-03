Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF4A1CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 03:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13E0A8E001C; Sun,  2 Nov 2025 22:35:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1160C8E0015; Sun,  2 Nov 2025 22:35:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 053298E001C; Sun,  2 Nov 2025 22:35:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E89588E0015
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 22:35:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E51B1A0A95
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:35:52 +0000 (UTC)
X-FDA: 84067881744.26.3DDE4E4
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf07.hostedemail.com (Postfix) with ESMTP id A31924000A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:35:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pDisz5Xi;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762140950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WPxs96Hs/koLnIBv2CHx6Mog13FyM3+Pfhd5CDpvcDQ=;
	b=ag9xYptQcPVlNMDzxk2xRb8TT8yTIkW/X/0bCwCurTPAkxMf4SzyrN9UZRC4apfu6behGR
	u7CwUEje1fwta04JTykkX9cmlLatWAnx3JDD9ACpvXyFAZNVSVIyreAGZF6qfA/dUestgE
	wyLw4PwyQR5TM/4O2quzUKZ6B5/M8EI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pDisz5Xi;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762140950; a=rsa-sha256;
	cv=none;
	b=f8k63+DgxCCln+3mIhuJOWUi3Lv7tKXctgwCnx5K7/may6eDaKbDM4nWe2dmuoKqEUDUie
	DcHEgGTwXj3sJT5bxcTf3HrURp+BRnyrDW1TkjYOeKRruHKbtctH0igs17lk7pzwg0kGGp
	BTlJxUbNgjJzXSPcixbxZ4J7XwFCpyo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=WPxs96Hs/koLnIBv2CHx6Mog13FyM3+Pfhd5CDpvcDQ=;
	b=pDisz5Xis5C/jNgPZPCj4fd73OzkDQPHOjqPBdGsn5EocB4cKbPdWwXHji3iShhaxUFcN5oJa
	RpWFYbFWrrmpd8ulEATo1MF23QHDhANbAHoAI26Fyd0tm0Y1IGIEGbI/RpaD4zQjFMUpPMecuqr
	jFdaCtWi8qv6+sLvpAPM4ag=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4d0HJ126Ycz1cyNp;
	Mon,  3 Nov 2025 11:34:09 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A92C18001B;
	Mon,  3 Nov 2025 11:35:43 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 3 Nov 2025 11:35:42 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
	<david@redhat.com>, <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <luto@kernel.org>,
	<peterz@infradead.org>, <tony.luck@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <will@kernel.org>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: [PATCH 1/2] x86/mm: support memory-failure on 32-bits with SPARSEMEM
Date: Mon, 3 Nov 2025 11:35:35 +0800
Message-ID: <20251103033536.52234-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspam-User: 
X-Rspamd-Queue-Id: A31924000A
X-Rspamd-Server: rspam03
X-Stat-Signature: 6mo9in4nzpgu67r9xxiq8aiwua93etm1
X-HE-Tag: 1762140949-661444
X-HE-Meta: U2FsdGVkX18GRNsbyqmJ47b5g/7qoyJPzrOffZWnSnHJZ3dir+LXlkKbhBlwB9VwF1yowx1kz6eIUCrLhtBT99Gaizf+m6A7QTVpVjZ84LKFnsF8m9jPbPDvG718Sq/aVq50h11LYEOTsSINGQ87/ZwWoddKk2UkTyK/ehqg7sqL4yRt2gfnQiw8J5qlIortWkX6oUVBLcJhkmO5cVvgD1SHL++8WSOSWSUfUXa9gE2am6Fz31k5IliMkKkrvz+VicvM0I1/nPsGi/bz9vVdlREySZSRUrlrQbCUQYkmajw/rmm7NLZRZcfdItNZln7RwNbDyDV75xHILSNDb5w+wZ6BAz8jb9MyEE6srqTsXVjqzeoASW5Grcdp2tm9nUplcU22A42ffc924gftGm0tLXXVR+152fWji8YTRVhFyrf1U4r8cny0zaR/6oAylDib9o90a+J8s2Xxiod0Z4Lfv1LkfW9HasjGgSRxeIDmcrG2i0mS72htzOZPH7yo6ukPt0mCJ1F6kA8PVpegsbZ+l80X48mxDHLMXhALUNJi8jXZyq18+n9ZAHmBbirlkOnOu7owIycHt3otkCBsNt3cywS7WBTvErt8mnf0wGIgKL8MeOd1j4XEWuC9WAKLfkUmCkmadLnuBudq67IImiqD6j2unYr8d60SGC3snvC+BJbd3y3q6w58skf/IFicteyPSXYOABj5upYihUxrddxozFh09Pl3SiT9g9PnxloUZr6vyoroDLlwvobayJEsVWZrUgYIpSFV9ibZ1zVvyZ9epXoOY7HVrA9JQSLxB6UFN2dC4KcJ1UTGX3cFpLKfBCVnoS1RG4CpwqCr2l52U5G2SLsDFhM16/83cQRFVmP8mCluzLJdHWlwmTy8dpo+XxCsUR3ODUzp2siGkmdS4xKO/7xeXJcTCK6CXKWSRM8NUyzd0WV6HAu6vUmWJMcLFF5jEkwhEQj0MOiwFFPrd7L
 XP8hlpYY
 t5+8nkag6pDwvxWFxBe+xsVojtqmrQU2xT/xgWI0+We+kJpcSlIWWy0zCXkQ+YXUi3+/CFZLajIYjC/uRnBv9Ewmb+PNDoENIaHL1bauyves/dT9y78lauVIVAmjC5dMWtxMDZsA+29+1a+11sRloBjr4LsvzxSXWl/1Tu+iK6638+qcNqQL46UvWvOAeBQ0M3lbjA7Zj/RqG0aODADlJLuhDXdVoJE+EdqMKXwBcwLTu44ZY5QhvbBCuL50WEIfZufeRG7uOQErJFDdzwCqqTKDBywyhsUxc5+AmspHLj7JCXH6jJRZOH7JB2djfF3/JVA4YA9xNIeIUDD/1OxuhOREoswi7Oop1szRy/hZfvVvusSU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The historical commit d949f36f1865c60239d4 ("x86: Fix hwpoison code
related build failure on 32-bit NUMAQ"), disabled x86_32's
memory-failure when SPARSEMEM is enabled, because the number of
page-flags are insufficient.

The commit 09022bc196d23484a7a5 ("mm: remove PG_error") removes a
page flag, so memory-failure can now be enable now.

Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
---
 arch/x86/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d55c01efd7c2..f9ee57a55500 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -750,13 +750,10 @@ config IOSF_MBI_DEBUG
 
 config X86_SUPPORTS_MEMORY_FAILURE
 	def_bool y
 	# MCE code calls memory_failure():
 	depends on X86_MCE
-	# On 32-bit this adds too big of NODES_SHIFT and we run out of page flags:
-	# On 32-bit SPARSEMEM adds too big of SECTIONS_WIDTH:
-	depends on X86_64 || !SPARSEMEM
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 
 config X86_32_IRIS
 	tristate "Eurobraille/Iris poweroff module"
 	depends on X86_32
-- 
2.51.0


