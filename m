Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27F2FC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2388D6B00A1; Thu, 27 Aug 2026 12:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2108D6B00A2; Thu, 27 Aug 2026 12:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14D3E6B00A3; Thu, 27 Aug 2026 12:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE0406B00A1
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60F3C16010C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:44 +0000 (UTC)
X-FDA: 85147572888.16.DC0A48B
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf08.hostedemail.com (Postfix) with ESMTP id 77610160009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=X57abhX2;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847882;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZpijvlSw2xNIsfL6IQ6jLABbu5LnLQd4TTudOzRHd8=;
	b=GxPX8gPHZHHLQTXAP7mcu+NtkwdscgZr95vQgL67cHDitVp2qF7sLF9HA+ICkjM2gZUYpp
	cnEtX5cIW3gseddaU8yBlSDSGVPWopm5fJVI/O56RulH/Bhd53I8b9y77Em75BcRhkYN2h
	RDjvETVeJ4jmh18pbrAtuGXSws8U0mA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847882;
	b=Krz04ks7gfnR067yNVjZVdwBoLW4D032uYNIxaCxquTDQb71MGxVndyLuMsJBm1XcOCKZy
	Vu82IopkDhqmQoUtYHyJiR80yLaRr1IKsYtmBIEBSeop41XCA7aLEFdh1SnQ9CwXiLoW4m
	gISahRUkfAAtiAjkLvrZm724IoM1c7w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=X57abhX2;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mZpijvlSw2xNIsfL6IQ6jLABbu5LnLQd4TTudOzRHd8=;
	b=X57abhX2xJestC1P2bJzdl/sfZqWq7S2z/DnrQR2S6d5a9iNjQpzAs2nrZVVgINhqAiK9mlEe
	8Un9AB4ywk8zAwPRdHmdZkkfEjyoRP/9lB50ajE6W2cmsfC1XR+YoRU9zHH+zlyOCfqwx3cge8Y
	0suoxFbuxnwTqeM9jTi9eDY=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KV1gnVzJ4673;
	Fri, 28 Aug 2026 00:24:14 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id C345340572;
	Fri, 28 Aug 2026 00:24:35 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 27 Aug 2026 19:24:35 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <vbabka@kernel.org>, <cl@gentwo.org>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <mark.rutland@arm.com>,
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <panov.nikita@huawei.com>
Subject: [RFC PATCH 01/18] mm: arm64 add Kconfig option for kernel replication
Date: Fri, 28 Aug 2026 00:11:41 +0800
Message-ID: <20260827161158.3618409-2-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827161158.3618409-1-panov.nikita@huawei.com>
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
Reply-To: <artem.kuzin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 77610160009
X-Stat-Signature: kewhiwofshz87o46abi91a53xwrcikda
X-Rspam-User: 
X-HE-Tag: 1787847882-946406
X-HE-Meta: U2FsdGVkX18KzL6Z7ON2Qc0rFV5M+/X0hZckPwIZNXb2BWTsnJXbWqNhiixCaAziSZAk/Srm1KO/BLTK00xQvPAubvRh28rgp57qIUQga9mZ1l3PWDCMzKvS3Nb42EsjVFtFRWOfCFYFRdLhcqbQKeKtzOJyVtIC8H2+4T5mBuTvixilc+wy7rXz9sC4PNDLSS7WyG09VsW2vyDv0Ed8coAnpb9SEbTST33kjg3lM26NoeYnINouxTPTfUonDyOImJEWKe/AZWIBju1xkpPWCIeIG23tvCLS/sLHqcgBlwoPEwFBAdnhmz8miK4HMxJZ5a0PIoyXvBgkeiLZQnpEpgg6hOcrkvMCygXyMj20h77yF/FSriU/rm1jWR+YW+pBdZrvwFBkTI4xTe4uQSZck3Itsw7YSkwMYds/vU1E58s2K3c4jZT8LD8DIBMq3C6gK6WBDbJWQ0PAvrUFHE6yDRwFsnfJutzco1Ugr8bQd7KJsJ7j5RPnMpjC7LA65Lt8zbvkoVF1kkGBa6e/PzwQl6W2PoW/mt+NL1XNmWTk+i42HAO4178+inc6udnTl8Hp0I2Jz+zBTcsag9nFq5nVuW8AhVCKryfJN85A/uHWbDcoWvrDz+CbgPKIm864w6b92f5z1zCpCnmRZmzNzp+OzfMK5BOePQy5xDS5hfWXfUcwt6levsvyo8koBlS0BDbfbXLA5Z1OseW3E/dW3sHI68J4My6iJxXlKi0la6LjsEnV0Mzn46l1u9hIv7dWreVhOawFP2qN4nVnghaVVPxSyLg7A7WUMO766Ka99zXHRMs59kfVWW4tKLM5NDLQaAS1uPptPYI/i3CVO3PIgtZMiDJVsWuXy2e/jxZRpxQmmeewnb9HtgrbEa+PuLtr7AH8L+6qour7se1jMWxyZ0+jIMnyAYHv0gG4ojA4no3I3SBknX6qTkYDNeFz520XrtLJudAmE3LRRrs+Gx/H/wG
 0kqCNBXM
 uzOBdDsHugoAkt+8hbi3iUZb6Tz8oUPE88f8dVXbBi2MiAoJLPhJ2wwnzqGTrsGOQzCjakuG2/qn+JlnIMFFkgxADoqhL5vbfX3Cc/8GuQKlkYqI838dl0IkmVUbWPBhcWVB+h7JDpkJKb+jjKzbBaV8Ncy78UJZPP7i2/rb+rm3HslBYr9rDJzHJIRx9XmcX5iRfMU+r/v2r6ew4x0O0KjL0oUU/pTyd52MQMfSI040wniWfK7Ojp/0P3xbQuf/IHgqm/OnF98z5xNeRsyQ4WXaAWaPgqTfSGy/I6/h8aEuDw+GayCqyR2Oo1404PBD4+4RBDrgoVuSi7sw+Q5HEJT/Z2+nZG/89Rzo8b/yAF4OxdDGI1yjh26f9YNuFxuLYyEiq68qH/AQxryxPdjCKpi3lwnntPfG+vICvOlTVLifaCE3XvSA0SSmZ7G26NlTGUswuT+zQbAb13QEbJDqrzrqXhR/OOpLOHOKohPowXNXVJfaJ2hCUlUzEsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Artem Kuzin <artem.kuzin@huawei.com>
Acked-by: Alexander Grubnikov <alexander.grubnikov@huawei.com>
Acked-by: Ilya Hanov <ilya.hanov@huawei-partners.com>
Acked-by: Denis Darvish <darvish.denis@huawei.com>
Signed-off-by: Nikita Panov <panov.nikita@huawei.com>
---
 mm/Kconfig | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..1302268b72b6 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1446,6 +1446,16 @@ config LOCK_MM_AND_FIND_VMA
 	bool
 	depends on !STACK_GROWSUP
 
+config KERNEL_REPLICATION
+	bool "Enable kernel text and ro-data replication across NUMA nodes"
+	default n
+	depends on ARM64 && MMU && NUMA && !MAXSMP
+
+	help
+	  Creates per-NUMA node replicas of kernel text and ro-data sections.
+	  Page tables are replicated partially, according to replicated kernel memory range.
+	  If unsure, say "n".
+
 config IOMMU_MM_DATA
 	bool
 
-- 
2.34.1


