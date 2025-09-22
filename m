Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C1D6CAC5A8
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 14:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ACE18E0002; Mon, 22 Sep 2025 10:36:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05DBE8E0001; Mon, 22 Sep 2025 10:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDC858E0002; Mon, 22 Sep 2025 10:36:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC3A68E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:36:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A3321359CC
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:36:37 +0000 (UTC)
X-FDA: 83917137234.02.88A1293
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf26.hostedemail.com (Postfix) with ESMTP id 85146140004
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:36:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of xieyuanbin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758551795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=xZCqhKaof1t6liZb6zP9jcprtmeHICqXfgWoWpn/bW8=;
	b=DVY/mzzmwnVm35hXGh+MkX3SmeOPCqzrQS4it7/iIatNUr9oF9uLoN9yD2IKO1HVGemuPg
	OX4YDAM4Fug/i+5Q4Ya7BcDjC1G1lerQ8fVHGHCn7YaLwyhKitm+FMPaNfEo+l1PvPNpFl
	L0vZu4piuWuFfxjKW618ab3OnZ6FVSU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of xieyuanbin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758551795; a=rsa-sha256;
	cv=none;
	b=zjKX14I6HDzxF9MVp3zpt2G6Yrnh2Ho7UHHowuOlMRXZGPuyT+QI3RoJt9P3BkNzIAl0Bn
	cfG25YKOQ9s8RAv1hxuj+Koy+B3PBJROmBpsUzuTcbXevLjFlXbPbqpGfOfDAnWcZ41QH/
	vhgnpdiGJF7tPuYijVrhOsM6TdKOYbE=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cVlvv1gfCz1R9SW;
	Mon, 22 Sep 2025 22:33:15 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 4B2911800B2;
	Mon, 22 Sep 2025 22:36:23 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.108.232) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Sep 2025 22:36:22 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>
CC: <will@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/memory-failure: not select MEMORY_ISOLATION
Date: Mon, 22 Sep 2025 22:36:18 +0800
Message-ID: <20250922143618.48640-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.108.232]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Queue-Id: 85146140004
X-Stat-Signature: 1wcdqixa5qzfgui5wttu5s4jq9dbx14g
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758551793-681580
X-HE-Meta: U2FsdGVkX1+QuAGkcbLia1MCuiH/igwItMHJXEikaikvCWodQmPno38+RExODKgpGVQotVpKEGfIlTodlaXV5F5zWEKJPIfqumO+Fm5mxSWMvB6zlEhgo1uZIfT0Rdr3fmBvfZvy7cDmsJXcdACOHyCEzPVE5YBeJ8+juml7nqCiM9rbwDNQ+r3xNCfwPmiHM2cnq/6lxgl7Y9GQtPo7bnkwC1RX3WMu9lO/0FFrAn9NNik2M1N173wIJN1g60CbwFVWZnYnN67EuXxgR3WXZBCMC3xtX6U6CK51rXpfK9mGLB4ABz3EwWiCFUixKf5yc1JTcWZ186Z6T0U3BjCPK4kINQwFoFX8wGraPk92A66hmZMaUksK002rwnNrLay5LVYI53CmseBMTZDK+M6f2Ch8ihNtKv4oXh1gmT8PUV7pcYUOOrS05Au/ElUAY0rI0lJaDh3/teIHl897F1zmtGYPfXMgE0Bfi+MYoOei9amRu8ENoiGIB0jfpBikwSTMsGZAppI7hmwWEfFB4Dq6PlbWRvNL4yCTYebNm3PISexqZ2o4qTKqChAgqdIGtxeF8G0weqGAc+RA1i7q3aFE1U4bFWen4g4VE2EMRFBCUF3/p2CNZFwim7VGt5JuxJ/jzzOYtW3Dc7ef48NRRxI6tKf1oE5XyQ3dHoPz4dv/DNXTzcnCZYJdSepSrn3i5t9Mw3OW+dSpmqMgcmv6SllIYSwb+MpgUeZCXG0sw5xEZV73//iXksGX9vLd/ZouD6lh8NX1kblPGm7pGOPxscd+5OXT2QjqD0wmUc3LTZjBHXe6b3yZtj6cYdNorRx8OcId/EzWViPaF1ZKAAG2qOIsqbMjY2EqrlXSTQLL0vMPgjlUG7mGNM2nBMOCNSw7t5d6qYcriBpHgWTLKpyLEotwHWwFi6MqqREJOfCeKZ1C8agy1osw8JDi7FiARvK+rKkJic4CbtCXew6aUP3bRoZ
 tY8XOUtd
 lccm5K/MKRzyjPsKJH9WwWexJQWP952CUVncak7+wHMhcqHQc0ySCe26WfYnDhoS47OQ4B7lKnc/ghsjXhfT+VRz+E7kitnFz5ur/dr4dFBPh3V1ySAgZFOsRaylwHKIM+kuB/f2MYdWG+DEJcW71wAf1IAsWDw24vDhj8pgqP3fGvN/MA9coz0nz6mZhggsIGN0KDzJfptz33A3A+VA6URiwoXwTykbZ/twPNreI8o18ePGzAgDa//O0WhFgcih9VjMTjS3M9m3cYEkhXFcKSZ/hn2/KkAKTX5TVX91Vk5NSwPSlUx0XcrilmEl3rAmbGaORgBKszdZxU1A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We added that "select MEMORY_ISOLATION" in commit ee6f509c3274 ("mm:
factor out memory isolate functions").
However, in commit add05cecef80 ("mm: soft-offline: don't free target
page in successful page migration") we remove the need for it,
where we removed the calls to set_migratetype_isolate() etc.

What CONFIG_MEMORY_FAILURE soft-offline support wants is migrate_pages()
support. But that comes with CONFIG_MIGRATION.
And isolate_folio_to_list() has nothing to do with CONFIG_MEMORY_ISOLATION.

Therefore, we can remove "select MEMORY_ISOLATION" of MEMORY_FAILURE.

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
---
 mm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 034a1662d8c1..0e26f4fc8717 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -742,21 +742,20 @@ config DEFAULT_MMAP_MIN_ADDR
 	  This value can be changed after boot using the
 	  /proc/sys/vm/mmap_min_addr tunable.
 
 config ARCH_SUPPORTS_MEMORY_FAILURE
 	bool
 
 config MEMORY_FAILURE
 	depends on MMU
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
-	select MEMORY_ISOLATION
 	select RAS
 	help
 	  Enables code to recover from some memory failures on systems
 	  with MCA recovery. This allows a system to continue running
 	  even when some of its memory has uncorrected errors. This requires
 	  special hardware support and typically ECC memory.
 
 config HWPOISON_INJECT
 	tristate "HWPoison pages injector"
 	depends on MEMORY_FAILURE && DEBUG_KERNEL && PROC_FS
-- 
2.48.1


