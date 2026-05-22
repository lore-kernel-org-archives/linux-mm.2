Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58B75CD4F5B
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 10:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A03896B0095; Fri, 22 May 2026 06:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DB026B0096; Fri, 22 May 2026 06:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917916B0098; Fri, 22 May 2026 06:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 805576B0095
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:54:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 227A11C1A9B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:54:03 +0000 (UTC)
X-FDA: 84794745966.26.5D797FA
Received: from outbound.baidu.com (mx20.baidu.com [111.202.115.85])
	by imf27.hostedemail.com (Postfix) with SMTP id 8F58040003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:53:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=j+dPbeWR;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf27.hostedemail.com: domain of "prvs=md15961DD23A=lirongqing@baidu.com" designates 111.202.115.85 as permitted sender) smtp.mailfrom="prvs=md15961DD23A=lirongqing@baidu.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779447241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mf8dxdNkgCdt+eOuEBketESSqX3ALKUBloGqvBAcTyI=;
	b=KvQnvy3i0F79Kt6qSN3CqVVyvkThAj5Ol7t2i2d2TaKpDgcPuo4Rz7lu7rRGROl9neO8Tj
	IXMCs9TM83v58H0aBe4kMsAkSgLVypoNTej0xqa0+6Z2PxT7iGkzCNWXKtX4jrTAvqAgRg
	DsxbaTxp4sbdSeQPlhEkqo0Iomyka8Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=j+dPbeWR;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf27.hostedemail.com: domain of "prvs=md15961DD23A=lirongqing@baidu.com" designates 111.202.115.85 as permitted sender) smtp.mailfrom="prvs=md15961DD23A=lirongqing@baidu.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779447241; a=rsa-sha256;
	cv=none;
	b=Bfc7/LjvyFvlN8Im/Wxmi83m+U+B8gpCv2dzLpLBg+jrlXeoB+j4WRgf4HbvFN4c9ZZpHH
	HvdPEKw3AkVRa18AaGIWPCZ/adf5RXFQ1+uVpEVqE/XW5OA0lMVen4cQ1o67wQw19hZKnn
	bRf9QzbbtYW5VYbCJRmqb/LkTfG9fZs=
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] mm/dmapool: remove redundant DMAPOOL_DEBUG macro
Date: Fri, 22 May 2026 06:53:46 -0400
Message-ID: <20260522105346.2215-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: bjkjy-exc5.internal.baidu.com (172.31.50.49) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1779447236;
	bh=mf8dxdNkgCdt+eOuEBketESSqX3ALKUBloGqvBAcTyI=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=j+dPbeWRQwTEyMgw6Hj3B8dEHO5Qyb4IaQDi1hYLHy92RR/ClE+VMESzN4QLRmMRu
	 kfaZl4N9eyy/P1rbwvaDoqPPTMyKirBihvObaaI8PJvTRuFhge24DTnlG+Tj1Z201f
	 lAeZPSNpghWHq9j8Oj/QRGG+UN/q39B+6AW95h+ukAhblLHFaWMNZq+yaeTe82N0Q3
	 0rmODKN7ARImt5aSE6hufPCKQduirvQCJJfslcynAYFE42sH42+syAtenYaE3vF01L
	 V5u1xsh13MXlNBhmntX/55+KnxeE7p/6pkFlWzZUIzV2mrzRw+qZnd/ws8iWwl2teg
	 zRWSgWM8cEtmA==
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8F58040003
X-Stat-Signature: i1jqzen68fxzy1foquksqgj8mp6gg4wa
X-Rspam-User: 
X-HE-Tag: 1779447238-507480
X-HE-Meta: U2FsdGVkX1/FrnteqzhuGXb5V6lP31/WzUQSt+qu8KbNFUXxtBg6GsBRmg1rdKwrES0EKA1SoLqViqO5tgYKBSYpsFygPSlBqIPBAK9Eb9FKJ7TqwL89RHocg/1o/QDvS9Wbsw8ywCZU1dXttkW4jZ5eF6PPSyJlSmqaIz/uiFORB4/3nwVYYg0RNnwIeeIi6Msdw3gfY+rEj8zoZgorJu8VjyrqOylHiIYmo0odfSYiovmQlAbGpIjb14MgOwE8ZiMtN0JvuW/EcYhHfvhnSPsfukcLexb8mYr+8oW4p3B3Btcy952aDn09Mjk8hK58f4JcwKaYxlvvGtePp1EYosO4Oiv6UKYRDLL4YO2C0rHbZNGFIjThePxeQELmlAr97iaM2CC2pXL/aHTBqp43e+AsDBahSFQapZL/ruPmZdWKyKAocknEzEzNw7VfnlGfD0ctovKSNWuVSdU+/3Nc2J07QllQb3gEh2kaxd71oyxkEfDWzgAmlbDZzlEdDNN6L83tzMalDnFhi95NIpdgUq+QmfbapT9WcSPO3KGtEZetn8aubh4plUTH/yYV7uM+qFcHBCtJZZcAymnimJw1KmGv4dbeo4b6NA7EVyhobcb6OVxtJa/3LDcGAzFyah8l/Lrrq5rqPZ9KIv8eGGt/8M41HrXJ1fz8i0E+xR/Gm5qwu/N69PZd8BOHP5l4X358GN3dRmro80UHr0USwqMOg1M+46jPIkYfMJj2Hh13FoH3sKyF8CWq+YJH5KXcLYzW1WLfMnRHEgT8oWkPXA35PrHK/PsPJiQ3zTtEaEflA36Qrf2bkCXGhxXizWdGFEBUb4mS/RUXV62gR0pOWgK4SIyiL3T2Gl2+wpUElbRBpz2D2oF8YJIh7RN3veVjtoYmoOpypXqTG1a1PTHvrMoju3u5tdAMWN2aqhv8/rmoygzVMBRwnuEqZDepY0+D8RP90zlL7ta5lxNHPjwWuiM
 SuRZLaTY
 QzG3eR/91HoOiBfgpNYao/VAOX6ru24GaxKHxdOaqEvvVXISm4avmdceLMQTf0i2gVYdeUsoNXIxLrkAezBCZGz+zHEWNJCnzqe/AZA/vF8AHUaBe4866/Lk9ADRloRiMwhN5L0JTCuz1W4UlZka7Ed9tD21Fv2wVkR4bzmyDlUw6fariOGEdBJyhIr8Kowc1wFDq4mfyEko4/uJQlbEtwARekJlm1W9jO72eqBoB34DniAXx+XnN0So0X13td4wyRY/Lumm1QukNzTFws5sdD9xYC9F0//w938GRKE8ur059dVO3se+S2RnagOi5NbMrXKlNHr5dJCMczfQdj3l/KJaaVl88XAGfWlCuBkgHj/PtWWpve5v+wrG76G3TQX2hdqcZlu+pV7TmWyyR9SdzcchnHIID891ZbYcmFCLjkG3TUcGliFlFDXTOVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com>

The DMAPOOL_DEBUG macro is only defined when CONFIG_SLUB_DEBUG_ON is
enabled, and it is used exclusively to guard the pool_check_block()
function. Wrapping CONFIG_SLUB_DEBUG_ON in another local macro adds
unnecessary indirection.

Simplify the code by removing DMAPOOL_DEBUG entirely and using the
standard CONFIG_SLUB_DEBUG_ON config option directly.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 mm/dmapool.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index 5d8af6e..af43f1a 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -36,10 +36,6 @@
 #include <linux/types.h>
 #include <linux/wait.h>
 
-#ifdef CONFIG_SLUB_DEBUG_ON
-#define DMAPOOL_DEBUG 1
-#endif
-
 struct dma_block {
 	struct dma_block *next_block;
 	dma_addr_t dma;
@@ -92,7 +88,7 @@ static ssize_t pools_show(struct device *dev, struct device_attribute *attr, cha
 
 static DEVICE_ATTR_RO(pools);
 
-#ifdef DMAPOOL_DEBUG
+#ifdef CONFIG_SLUB_DEBUG_ON
 static void pool_check_block(struct dma_pool *pool, struct dma_block *block,
 			     gfp_t mem_flags)
 {
-- 
2.9.4


