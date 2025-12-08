Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 753ECD3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 08:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1BBF6B0005; Mon,  8 Dec 2025 03:45:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCCD56B0007; Mon,  8 Dec 2025 03:45:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE23B6B0008; Mon,  8 Dec 2025 03:45:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC2656B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:45:27 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 149D913BFC1
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 08:45:27 +0000 (UTC)
X-FDA: 84195669894.11.3F38669
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf21.hostedemail.com (Postfix) with ESMTP id 74C6B1C0010
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 08:45:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PcabI7z6;
	spf=pass (imf21.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765183525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hseK3jJexUYps8Kl5ZsFalbdPjsFIa1tJO0pgXItq70=;
	b=Y+4uHKXzDRVeW+Z8Bokrwkel9bY+P7CJkqM9gVezKWn0LuC+cLWGMicP5qHlJ1kF52IHxI
	0wDitOocJ5O9rylZwK8DI4xMxfNstRFX2aqYtVrxidrbk4Z1YuQ637j5Pa6uVU3LyXepv7
	OPTvIRKnP30DoHn0uBmrUM7a7KdJYCc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PcabI7z6;
	spf=pass (imf21.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765183525; a=rsa-sha256;
	cv=none;
	b=0PH+S2WYhDD0uukPpf9Ek2+V4cffT33Peet4RCDRwk7zfi1h/qLc0rqumqIXTXVS7WgZKt
	xn9b9Fgbaf5PrKZLb+zav4qCzohAbY35+VUBJ5d8uRbi+E/VuutjbPmndqJU74qlcT5Mpl
	2TRzDDx8pP/eNwteXMrKylI9MO29of4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765183525; x=1796719525;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ejWKILgH5AA+cBS+dClJ4CEF9EcY4joNP/Bh3I/BxpM=;
  b=PcabI7z64A+SMczlFsO5k3i8rzetb2kBeVmP6YsLzOrt3P2KLKEzW+F8
   kV1RYJmyaLJjCYoh3wOLgI91nLt3SAso2KrfhlRu6iO9Vg6LXbFMiDeZ7
   thkyx6Ct7saNsStmgc8JEZrUh6gTdFW3/gntK/u8fkr67ulJohfvC8wzR
   tZ5vonSfRh6roEGzKjjf1g6QINEaVO6NEuBOtvsYviX1sLvWSj2/7cxUM
   PWZqaRzlkQi3H5Df1T1qnl3bCrWmUouHSsQlop1oISlh3STWj6N5Uhtqp
   6uLVZj3ysgZHf8sTl1q0I7rAKiWfptX3PLLqcClCLndK6ecPKCiDNuQMs
   Q==;
X-CSE-ConnectionGUID: xyRB1RuRRni0dFsdRNZf4Q==
X-CSE-MsgGUID: q4jK7cL/S6S+9WkmIbQVUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="84726506"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="84726506"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 00:45:23 -0800
X-CSE-ConnectionGUID: Hugx2lAnQjm1YnMjMFNpww==
X-CSE-MsgGUID: KEzZAIEtShms+UX7L8Payw==
X-ExtLoop1: 1
Received: from baandr0id001.iind.intel.com ([10.66.253.151])
  by fmviesa003.fm.intel.com with ESMTP; 08 Dec 2025 00:45:22 -0800
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: [PATCH] tools/mm/slabinfo: Fix trace disabling logic
Date: Mon,  8 Dec 2025 14:12:55 +0530
Message-Id: <20251208084255.2689901-1-kaushlendra.kumar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w97u77ewpdphtjd8pwbkwgawsgyw5556
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 74C6B1C0010
X-HE-Tag: 1765183524-683871
X-HE-Meta: U2FsdGVkX19dMKilce+y+huzZxocMdFQczxKCym8PlXf7xopau1wehEKWGgp4pk+CoX8JnBgbPOOyF27yRd8goQC7fsYxlzLxJd5kFNZpptUELdPP1wzyLDm61Ryr3PezqeInQrRwgnbzrxFILPF5p/aPDtQqP0eUSyLNfYZ032elRcUongiyS7i+F89bUBD9+Cq0BzjOBiKetvnEKOiAVTT51ZySHdtj6qkjBDLSM1/+jWG4ZmlZ7S4BOX0spBfkao0aOTqlVDkXd2zaaDoARYB6gy6zAChGTYrUv1faqgKMF3tkmKtfFukJSiajZUJUMBXGwfOuIpodGoHKYdKrT9rR1KOivkK0BXctwUPctqQ7K4bq5EH9ATPRySPclt+gSy79UbMQTid9uVG5pmXKDYkPi1jbPOCxUYT6dItZXvPUK5V7in5jgResQ3ZsgKeTakBNEsFpsiSQ0GbGqKATVZS/2ltzH7boD8R3p+CEfrTPoIMElpaontt9xPCD3ut1khu2tsdvr3aCoQaCvCIMRWsgehYOJjWcmvaoksjIxOSIoPuCmq2glByArqVlKSUFFR3hh4PltfHbK0W5oUXpolK3i6jIRFsykMadqee2WHWWq/n6+auYcIKxiFT7oYronoCmvfoGySsTzpG9c4QERAZT3pBtNYl2b0PYsiEBAE/yorhHJqqvwzT0L9aY2OBZOPz4YnGC2NMXMS/DQqAYViHsTqP6sfPn7bUtqBi8YVi9cImNPPZ2wNsxFV3uJ9vi84WYhqv2pS99tT9wzxPlx+MQzyKebBGntf9qZOqhWPDXpDCkVwdApFXmNP+3Zb0QXOtzoNamxECuf+dsiuZZC5Gzagh/3NvGgA0gQviIkX0OiPhcinxTq2uMiZIXSPdbR/Y8KYaGjwBdR3jRSU21fnYA8IiJH9abrNOizG/pZBnOw+zQ0OmWr2M0X1zSu5/9SReJ/dx4fL3xPYDaYO
 wA1k9M1v
 nfglVgrWqzA5J3oA+c/rLgi1Nk3E7RkUbVtAuB+VRSZ50XamyBx8cRs/vpuzB+L8a0T05+lfy87qg73YN3OnVbUWfth9UUyjKPEUBG7bXRbfBpvB5+Y7sBsT53Sp0qwjz+hsnf4gdntaevZBdHVg2I6ih9AuG3pCB0069zrEdGpLv1F4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When tracing is disabled (!tracing) but the slab has tracing enabled
(s->trace), the code should disable tracing by writing 0, not enable
it by writing 1. Fix the inverted logic to correctly turn off tracing.

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
---
 tools/mm/slabinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index 80cdbd3db82d..7c51d283504d 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -798,7 +798,7 @@ static void slab_debug(struct slabinfo *s)
 			fprintf(stderr, "%s can only enable trace for one slab at a time\n", s->name);
 	}
 	if (!tracing && s->trace)
-		set_obj(s, "trace", 1);
+		set_obj(s, "trace", 0);
 }
 
 static void totals(void)
-- 
2.34.1


