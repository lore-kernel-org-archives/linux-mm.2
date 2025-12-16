Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6574D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 06:45:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41CF26B0005; Tue, 16 Dec 2025 01:45:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C37B6B0089; Tue, 16 Dec 2025 01:45:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F05E6B008A; Tue, 16 Dec 2025 01:45:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 165CB6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:45:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0D51590FC
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:45:57 +0000 (UTC)
X-FDA: 84224399154.04.381454C
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf18.hostedemail.com (Postfix) with ESMTP id E12471C000E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:45:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=NXgMllGa;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=longwei27@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765867555; a=rsa-sha256;
	cv=none;
	b=gwYn17bNIEZS36nltopeUCXpfbtOQg2Ql3nsfqmlppnZCbm9tMHbF7rqDKkytmgWiS4crX
	kMgEM/bhzq8fEx2sGyW5vOOQFMMvkb37aPC3rPCu4xm2KWtv22PjDIetsLAnEsKWJQJdBW
	b9C5AsiShqiBpIQU4QvbhB9QivYKshQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=NXgMllGa;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=longwei27@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765867555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EeUCktEk7tKcuhscgHtGmG1MIpsx+ua5mmBnZ9Rv1gA=;
	b=HUZcWgCVSya2SVjdXwN8yCrfEhZinL8Rwe6GOU0l0VaAbIFtiZ9IPNgJ4fUH82RZsyfknY
	bzuvZ53THlJrAfISvrzd6Veo53cnnxmlCjBpVs7SsKmplyWH5Kb7Wmsr/Ev7z8gMdqUefA
	vKxjau1lZ8q2I/e/ZyeOeNgfoccrJ2Q=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EeUCktEk7tKcuhscgHtGmG1MIpsx+ua5mmBnZ9Rv1gA=;
	b=NXgMllGaL1TKTZ8uCvN2uRDDsx2iCirRKHs/ksSTjTmysbZse6exWdUiEAP1zGEBQG9L3B2dC
	Xy5mq5tYLbJCVCDPIrndcjL+EX59eh+yLGAVkf2AsC1tHAyPB/ANCiw2TYZhvp2CWj3wWi8MzPN
	/4nge9PfgLGh6k8rJVvih18=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dVnRr01Dnz1K96V;
	Tue, 16 Dec 2025 14:42:47 +0800 (CST)
Received: from kwepemk100009.china.huawei.com (unknown [7.202.194.57])
	by mail.maildlp.com (Postfix) with ESMTPS id E49E7140203;
	Tue, 16 Dec 2025 14:45:47 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemk100009.china.huawei.com
 (7.202.194.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 16 Dec
 2025 14:45:47 +0800
From: l00580197 <longwei27@huawei.com>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, Pasha
 Tatashin <pasha.tatashin@soleen.com>
CC: Pratyush Yadav <pratyush@kernel.org>, <kexec@lists.infradead.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<hewenliang4@huawei.com>, Long Wei <longwei27@huawei.com>
Subject: [PATCH v2] kho: Remove duplicate header file references
Date: Tue, 16 Dec 2025 14:45:20 +0800
Message-ID: <20251216064520.1529635-1-longwei27@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251215091150.4094334-1-longwei27@huawei.com>
References: <20251215091150.4094334-1-longwei27@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.159.234]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk100009.china.huawei.com (7.202.194.57)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E12471C000E
X-Stat-Signature: pzhx31ugm37rn6pix9ky9jkfddtqtxqb
X-Rspam-User: 
X-HE-Tag: 1765867554-307290
X-HE-Meta: U2FsdGVkX18zP+c2gKDKGsB/HiJicv8c2OK7+zr4pp1YJVJdKz5kVKq73QpVaL+N46A6+qR11llrqnzNEPd51NFJOJoyG0LEiZmK6DVTzATTzVjOHhOEBUzp5Q2/j3He0q/g/b7wsLDbdxrVhnKO5LoRWDOYpeeab7F/62pi0QBfDP0znKxyOmiMFuwwQn93ZATTWdUxW10hOVMG/1CbSX09L23YEgjjypP0XAGt/RfcjC6KDW5WaGRKr/wRo3Yh1xNLX3mUnYSG6KfblSOsT3qu+LXVZEvlji6pGt89Qn60U9LErw9ceKPXnaPql9QP68UBsk/tQ0xMf6vAPZHuI9A7AdetlBszHPUc0dpHJ45N8fWJ2U3hqVAJNFy0i2XV3ZoTiqRb4lWrNJ2DvgDI55CJClSyhzDp2s1GnAULkqqDDev74+1Cq58jihhY78reoX1dRNEdsL+5k6v1Vin0+TgZD1HtOl/rRqWWJMIF+KQ2ir/umY/od6/JAISlOx4cOQV+ijXuyJrYKsAlfImgaLvmgEGv03CgeZ2dKZpLuEeT44zeixPeeXKYD6z8CQnVsyr6LztOmBnfevrskdPQ+/ncwS0iF9N4uwrJ1P37Zm2jy0QM4JuO0ufRMpmIwNcK/zz6brAXfAtLwCbFuevlNC7K3qFMyHjREZMQQBIk9yU+jsMKPpCflQZL8Qmm2yAuw1EouF5yUWP/Yl2M5/4pn2ZXrcifHDTBaW3mwIT0dygOQHoPSDNbnmpHvBvXkgG31DQcv+wJfWQexiCI5nV1ELmY9cNTLW9MhhGRpjBPj03matjBpdbOVCcU9LWDmjmV7dN4q3p4T3vYb0y0GSzDXIG+cY/EUf2Q3jHyN/ZXhgjIEH1sE7Utlh2PSlYCT55XMRsRmwVAyb5lvHnvK/q5yha7UJk+gjE+xxZBUgBtQKcRqMhss/sPTYkwG8tYMWIlkbTwiEOQ58ikyj7kuKA
 I3ry8FVN
 7uspsxLK2M6/1DAAWvpxqE/B5UasLuBMKQeDfh2FYA+h/gE+o+roHDR7WK3UDFAFtLieA7HbkXrH1U89LM18PQfKuckcgojJvRC4cMRCWz4MbSIGjYfHaKTSJHSdvmlr5EWHZctiZhHSO/3JdUmaNgfg5D6hmeSk/y75gl32pcyN2eOxPQlnTj9bi89TQHHdY7us6cw35rCXxiCtBJ6QCKgPizf1lvn6h0RVrf6YwMlBEdGI6L+JrD+nQ/5x7/2nlyODlJBvQRY7sz3XEqeIbQP6X7/3JXyhJPZhiHE437t9ZnA5TiiKEYDzvFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Long Wei <longwei27@huawei.com>

Changes in v2:
- Fixed the malformed commit message header (removed duplicate 'From:' line).
- Added module prefix 'kho:' to the subject.

kexec_handover_internal.h is included twice in kexec_handover.c.
Remove the redundant first inclusion to eliminate the duplication.

Signed-off-by: Long Wei <longwei27@huawei.com>
---
 kernel/liveupdate/kexec_handover.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9dc51fab604f..1962b6052840 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -24,7 +24,6 @@

 #include <asm/early_ioremap.h>

-#include "kexec_handover_internal.h"
 /*
  * KHO is tightly coupled with mm init and needs access to some of mm
  * internal APIs.
--
2.43.0

