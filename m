Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1100BD59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 09:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79EE16B0006; Mon, 15 Dec 2025 04:12:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776636B0007; Mon, 15 Dec 2025 04:12:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B2EF6B000C; Mon, 15 Dec 2025 04:12:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3806B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:12:25 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED95D13C459
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:12:24 +0000 (UTC)
X-FDA: 84221139408.23.4F75B72
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf26.hostedemail.com (Postfix) with ESMTP id 324EA140013
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:12:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=D8cp+M3N;
	spf=pass (imf26.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765789943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XZgdrwHTqEPsqlq92hjVC8yJ61nB++FpNZyUSYNf7fg=;
	b=Xzydh/vsm5dVm5FmGWc6CBAorQyw1IppWfgEEichpISsOtyOvLm/IT22xZFJpM73GeGjzf
	VCdGp9vCAvoB6QmBUY9Q54HkTNWMbVEaJdlb8f2qGvyi+6necCrzZKgjL+SYfOII37J6Em
	QaUmB6PDBL0ABqFC9vqnPFvZxvgVWY8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=D8cp+M3N;
	spf=pass (imf26.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765789943; a=rsa-sha256;
	cv=none;
	b=bDqi07AOBzrqn0wR/jLL8gMlE29m67Fj96mpcIn36PQjSs+Qd+NNvA1zNHsGGYl3C87Wfb
	t/Pq3ohIbHfIU2QtEAoElv84mPfDk9JKJaRVK3P50ya2bjI70Mz9JCgGLbbVvQ0IgXD6CK
	DCt8lEdRezj9aLFjS3IrWoCOlFuT+mo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XZgdrwHTqEPsqlq92hjVC8yJ61nB++FpNZyUSYNf7fg=;
	b=D8cp+M3NyiQpEkSRe34dtr+w+at5oG1dxRCu5nksZG0eiQsMj6rLuBX/myEbBFEMFnibMjydy
	gz8Kbz+GUS2366nux0RPO5ZhvPrSIaQtRLIqtkPLU1JzUTtL2E9eWUw5+nHO+CjIpk/OlJ1bgai
	EabVkous1xOcVICxNJqB4vk=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dVDmR6YMnz1prMW;
	Mon, 15 Dec 2025 17:10:15 +0800 (CST)
Received: from kwepemk100009.china.huawei.com (unknown [7.202.194.57])
	by mail.maildlp.com (Postfix) with ESMTPS id B21C118048A;
	Mon, 15 Dec 2025 17:12:16 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemk100009.china.huawei.com
 (7.202.194.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 15 Dec
 2025 17:12:16 +0800
From: l00580197 <longwei27@huawei.com>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, Pasha
 Tatashin <pasha.tatashin@soleen.com>
CC: Pratyush Yadav <pratyush@kernel.org>, <kexec@lists.infradead.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<hewenliang4@huawei.com>, Long Wei <longwei27@huawei.com>
Subject: [PATCH] Remove duplicate header file references
Date: Mon, 15 Dec 2025 17:11:50 +0800
Message-ID: <20251215091150.4094334-1-longwei27@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.159.234]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk100009.china.huawei.com (7.202.194.57)
X-Rspamd-Server: rspam02
X-Stat-Signature: iyi8kysqeruzufjebgnqnway8acxnuzt
X-Rspam-User: 
X-Rspamd-Queue-Id: 324EA140013
X-HE-Tag: 1765789941-351934
X-HE-Meta: U2FsdGVkX190z8bwjVyhvI49huiTdBIl3U3QZjXQorq66SEwnbSgPX2mfLRrfntLLvYKhy15DAhXBV3GYMozY5b/08OrKr7itCU3Ma6vimWc+lQNAkc6m295bhB+4aXXDDkJgFT1cGgsQziHJwIz6v9I7L0skqcW/CFaGitj5YT/BwbgP5iySzfXqBEaVJXdLnZ9bJOdCnvVzcZdGcvwyR7D4sRYAw6SF6cN4Z50ePVQyq4nrz+UeJki3SHNaIsdKqSAAmCktp6dBF7N29EGl7SPgt3odPYNODpqQ4M0Ug3kQw4O/ky2F5VDjXca2J9ZF6h6sQQm1jOu73sXz5Vo/Xb4g/7f8J1Z09MhwEywdSMSldiawDw2RzDVVGQ8g2dTzcbq0Prfx4OeOfD18MP2vXmB1+CeRHgy+JQyiT64m8ZBjVAshQ2VZTWA2rzA5wJJsk9wKCDrSS+fWM8TkAFIXCUY8nOYkzj48nJ6ihvK7XEs53QTT8YXSj/ViD0I+Bfu1wAte8zalQQBBeKJ4lShAIXYuaVMEuhlnMmnFX256MGkDK1TWrPikGruYWauS5zoKFP7zZO99Y8N+A2b4gBqETogCUR4f7mIeRCYAmr8+VZUEBKj/kG5Chwk2Od0qGbCJBQ911OxefS5HeQ+zLmkYLxZ/EdUvbAuH2mI1sNlQRkY7mSLDgyEvuKl32MN5YkZK8mnrT6nqw0PSGl+LWG2O6ZPXh3vLdvEXETeQSZAQ4HWz292fnqWY1hEUprD7gsql6cSXJI9xP3jC83fEPYCt6qquR9F7inJvVkxYLXZvQNF7CP3etQogmNyO5Pnjvlnkr7XrrBs7V6APwlIK5X01LfaELlbZEFDwteD3Xt54YrTx9D6UOHVUq8dg88gM0cEZSA/6U6G6dj5dYpvRg4P/r/2ORXYN9bqM7NxutvJKjOeFFHiu+bvSpuVMNauCUEWDFtEIGWbKeO9Ev16KJP
 0Jg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Long Wei <longwei27@huawei.com>

From: Long Wei <longwei27@huawei.com>

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

