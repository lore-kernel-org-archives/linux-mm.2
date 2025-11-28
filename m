Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CEF3D111A8
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 02:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 319826B0011; Thu, 27 Nov 2025 21:54:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DF6D6B0012; Thu, 27 Nov 2025 21:54:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7556B0027; Thu, 27 Nov 2025 21:54:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C6D606B0010
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:54:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8842F88BA0
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:54:26 +0000 (UTC)
X-FDA: 84158497332.01.F3757D4
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf23.hostedemail.com (Postfix) with ESMTP id ECC3B140002
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:54:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764298464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eOYltvgdZ6IkS00ofG3LMozd79MhywbNv4jtlo04ijg=;
	b=nisB3aHeONwFOrIhXCkExNGbQ1/P9R+U1W8p8RJBdX6P3mcG0815k+9/w1mCsWWmkbx7Zk
	fyC3CPeyvKw2pSmKbLhTgvVAMS11RjekMu/GKKGlkPD/GTaAz9F85BGPz7JBtu0nQogVNt
	hlgvkJxZ5JvBxzPBGOHyOzKwCTkkeek=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764298464; a=rsa-sha256;
	cv=none;
	b=tL8UnxF2j95Pc46ctVDRkaf4zMQopp2iOBGnZOikMvhwHcRF8nCF2DpcQwIEDdltqalgc2
	dpF4JdvYHBOz/o5BlZD0PPm06dnwJQjSyAleiXixit5gl25TbJI7S7IJ0j+rG7sleil6N1
	63abZXCQeZRXfrsnXBOgJsr4c53PpNE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4dHdBy2jyCzYmZBB;
	Fri, 28 Nov 2025 10:52:58 +0800 (CST)
Received: from localhost.localdomain (10.144.5.36) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 28 Nov
 2025 10:54:19 +0800
From: Zicheng Wang <wangzicheng@honor.com>
To: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <david@redhat.com>,
	<axelrasmussen@google.com>, <yuanchu@google.com>
CC: <mhocko@kernel.org>, <zhengqi.arch@bytedance.com>,
	<shakeel.butt@linux.dev>, <lorenzo.stoakes@oracle.com>, <weixugc@google.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Zicheng Wang <wangzicheng@honor.com>
Subject: [PATCH 2/3] mm/lru_gen: add configuration option to select debugfs/procfs for lru_gen
Date: Fri, 28 Nov 2025 10:53:14 +0800
Message-ID: <20251128025315.3520689-3-wangzicheng@honor.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251128025315.3520689-1-wangzicheng@honor.com>
References: <20251128025315.3520689-1-wangzicheng@honor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.144.5.36]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To w002.hihonor.com
 (10.68.28.120)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ECC3B140002
X-Stat-Signature: k5qadj8wrtnojtq1t8uh8riygnixs9tx
X-Rspam-User: 
X-HE-Tag: 1764298463-923705
X-HE-Meta: U2FsdGVkX18qoFGSh/qK550fExeByuODh1hZb5+LE11AtgcMUKVros0QhvV2cjJNayQxw+rQLutGmj2WbUsdkyBXXhH6y+NfUNm9PO1gqK+mBBHXHfMeCVDpUo2Uux/VgnLJZ2XjxFJ0UhPXIqJ16Ow1cQxPLZB2dYxe270goImLyA8ID+DkubOBKH5sIpwz0MSeAEmU9ihYrOQGO8+QNToBIwBGP53BIRXRleP9vb/qN1hFippBSLE8ORkSVExX/w4/wlAyH70YabBH+1l6zBvK8Rqw/lb88oQNJqtcxtCabCBfHIU8aChqY2wCqE+yUVJSNdtwoklB1cFpoTOXaho8LgakTO52vkp4Vf2wEf4i/hIxGFmvzlBADd7ry1XjRBiXaMnGHz1JwKaMVA4IwFPzaBu7NN7Om85vKHfxoGbZtcVtU8qrk2Ou0TfF9xExyGL07yAak4Jvhz14ZeOYRra8Iw42FpHRsFU8HHMXzxAJ8y96TMdHRdKbIfE2W9CsVGck119X1Yn23e1HkeBtJuaCpVHjfbKFIucv80j9JdUyEgqTFIO/bsXWHZNEnXXptwYbG7+tda2VvEp/dXMAZ67Zhx095PdPv/ak63YYVNkLY37F/FVj+yW8p5AhyPEOZHg/IqECnOVDaQPWeKA5WR72qFmuzuEAcRdPu5VcMVz1QOUbOx90yhEHrf2Jot5xYiaESm2em+nKcyFiJCVPIjwmWkv9tYHgNLQqkAdZG0x5IwV/K0Vbu46+NrNd7iDh+FvMOw7t10WbA7cWAAd05ddufFuMMr1dC4wFQkE94lBsWiCT4SnXofVLESkcA4ZnuFgNBYI9xLA/qrT13Q7aOEqZgl9ndYYiIJj9V/UZeOIaZ+G1NE8zZWMRMqWOdzjGojZ+yQBDGVGfhSnHgErn1dFMB2uihm8P4hjO3uY5zW5nNJKZbqeeHmTeUfImupTN/CTdlvleAkk0lELXMGm
 v/TlRRHq
 tnwrAZsgIvh4fZzD4br/2LjPZeJTTgoldb+JRR9gYcECV9Ad0FmzVJzEyWD975hpiCK6pu12lPguslgwtRnyZ2I8XqZGP2o+HvX760ZaGPzCLPGL0UKY4Qa9Numhpgi+ID0oiI0T0Q5U8yPRzjHuklMaEt70apTTiQG+THwlQLrx+alpmqUFrNpBMWvg9r1odWrsnjjZBvMPK9YAsC1aI2VTIIxyv0RJgX0lPV+n9yE/xE4XemJ3xiQ0LktfIgCjNNTb6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Zicheng Wang <wangzicheng@honor.com>
---
 mm/Kconfig | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index e443fe8cd..be7efa794 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1325,6 +1325,16 @@ config LRU_GEN_STATS
 config LRU_GEN_WALKS_MMU
 	def_bool y
 	depends on LRU_GEN && ARCH_HAS_HW_PTE_YOUNG
+
+config LRU_GEN_PROCFS_CTRL
+	bool "Move lru_gen files from debugfs to procfs"
+	depends on LRU_GEN && PROC_FS
+	help
+	  Move lru_gen management from debugfs to procfs (/proc/lru_gen).
+	  This production-ready feature provides critical memory reclaim
+	  prediction and control. It is no longer experimental.
+	  The migration ensures availability in commercial products where
+	  debugfs may be disabled.
 # }
 
 config ARCH_SUPPORTS_PER_VMA_LOCK
-- 
2.25.1


