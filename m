Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C812AC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 323DC6B00A7; Thu, 27 Aug 2026 12:24:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 288616B00AD; Thu, 27 Aug 2026 12:24:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46136B00A7; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B1FD6B00AD
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E448A80113
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:45 +0000 (UTC)
X-FDA: 85147572930.29.B0AD75B
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 149B9120006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2TvuhQxU;
	spf=pass (imf29.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847884;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5euHgUF21bp60qTQigBwKjH4x6Qvg0qe8ONZJ9cd938=;
	b=Rl2aqNUETKrPKnr/2bK58f3gwi+cXs2vqhzJyJqDpI+LactWUlj47wxve15OhN5tlGNLNB
	grp2FLFduOO5RaN8ycvhzBcDDLlvokbSijKJzEgSon42jJlyzljer+n5PKqLA+Gvmm6RMQ
	6Z6bLL1Wy20lwMiyCAWDciVkRLjkbAo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2TvuhQxU;
	spf=pass (imf29.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847884;
	b=xsAb33t8oCuVzn6v6WMVcA2Zro4ubaMs7M4GyI0bq5PEjWT4ZVIztS9QyMyj0jZ6Kb8ExO
	qWLJtsbkXkx9DaNOYnGBI7tSjm/BfWvdr9AhprLa+0+1uwMn/KR0/BOmyAEVHIVlf7Jae5
	No9qUPzB/kFJXFTR0jFWV36kZ98Z7SU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5euHgUF21bp60qTQigBwKjH4x6Qvg0qe8ONZJ9cd938=;
	b=2TvuhQxUFr+fy+TYSZfwfzt2uKWRPMUlYGvkIcqkpSYVM6SYMIi2cNT3oGpFWAEDEkYLVmcp3
	27DLLJT6/TOlAQbpxu6X1KM8Trmh2Y7QCzb+ecElRL9a3atlGgKwmDr08QkmlRpPCcLbQ5ati4P
	s1CxhEaZ6wolohHl03XhMkk=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KG1l3lzHnH3h;
	Fri, 28 Aug 2026 00:24:02 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 4117C40570;
	Fri, 28 Aug 2026 00:24:38 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 27 Aug 2026 19:24:37 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <vbabka@kernel.org>, <cl@gentwo.org>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <mark.rutland@arm.com>,
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <panov.nikita@huawei.com>
Subject: [RFC PATCH 16/18] arm64: add kernel modules text and rodata replication support
Date: Fri, 28 Aug 2026 00:11:56 +0800
Message-ID: <20260827161158.3618409-17-panov.nikita@huawei.com>
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
X-Stat-Signature: kpzo56nrakwkq8pnpgm8ep1xz1i4etgj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 149B9120006
X-Rspam-User: 
X-HE-Tag: 1787847883-465554
X-HE-Meta: U2FsdGVkX1/IwZhPJQMuy53pZJpHepz0rtZm2qy+/JY0t7SX+vNatcMTL1gWhGb3cpeokCdHW2eHBBOVRhGn/5lPcLc2bi04+OmcvOTwoe86Nr6kcjSrMSpn2Df+EBbif2HSj9orOb2yDcvGMvP0MHoHiphWVnRlw7WZT179SfvvezF21rcORvrQeuqgNrR6lR16TveJjxR1yC/ruL+YL+tfSc5Kciv5xvrhSbC5yYX1m3QLKWi7IzyYkdTRNrfrLtza8sgrJRgKDGmUfCSrMO/b2aPUNXrhnm+mlMhZmv800XkOCVLSveHnIUWAxx8PSDQIasCQroE2/vnHiuvIp+JHoIGpk+ivsNWj1ekrDjMpF9djLkK+q/FIz4VE6tKE36gC/lCzgsRhSclEXAXaquKZZjXWnWujFzfK2paff5MVirHyM+oViJ7wkwGuVgDd1+RXQW5mEQIkPZaEpzCooiekv4cGdY56RpStLq+dzWA1Afv+EQwjzbrI3Z9pWDVNzCjTddp7GeJ8lMQf1ub6YN0rv5XTQMIQ584+mpygb9W8c9A7x+bTxmZZp7J/fzblJeG6kJCwEI5LEGYfblLfGgHE6cHbOQdTXoD2d4zOe6hWn+Sn4J4R3OXJL5Mc8YooOrOGDHpmj6DnI/ajRm/3gqdeZ3rp0LjAs1Z7OEmlatOoqPRvBOwhP+iC5i0PpeyCSj9Y9rfMXu736SELXCw+0Te0C0xlgyT7xkGyV7RECoCiz18AHzWHBsGVcjGJJDTVETOS0JBX8sC68AiDFAF5Z/16iFPcgo2yC81YcdaKhwfShP3MCExUwNU7kS6H/tLZG4GUfrJta4/jZE8EMIfcHomDUtMYJOOCKjo0iRt7SBcVGJDjc9frEC2U042BO4lRTX5Ipy2zeP24QG8SUGmUkl0Q/nC9KTWEtMj8Av36lVJIKLMrMsvkci4YSZgz/FBDrVlTQvH1qm/IkQt65Yc
 f/g2mHGK
 i+gbUri63yYl4ghMevWAzrNu7R98rxTyQSIb9gOq6zz16zJ3ORjCyH3LTTidALNbNtpzRgo397HC7nPLAvrAFkhPejPRZpTdoU823vrkN+28b9Fdgi69Wl2S/I1NUhf86WVioYqkveRbu5ESf6UQLZrreZl9Q9V7trBTZ20XF6EcDWNaY6Qm6xHJ7tuc0JJ39BAD44hFRxplUUQ2Wo8SrXwBB+K1s60D5rHUchO+ZnCQMtSB7e0psnIvZDl+eoBbb+ZuoZr+mIO40+HwVZ+0Owi8xO1dsN+RbRvFXFStrN3oNRzUM930pxPpsuNNLoGVHstBSuXCJDh0rZTVvMLqvmSIYTKUao2RaAEgQZEpyqN8SsPFDAQDBK1FLeA2UyeF5s9l6XBfU4135/DUxZofM3AFItPK1V1XHUnoSzuMjKKXLqgm3lS5vS+sYNu2JXHFDxkVOm6vzfu0NgX/oOK8zUnb9gT6EOdSZUJDc+2QpH92FtjKvTACfqoAEXw==
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
 arch/arm64/kernel/module.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index 24adb581af0e..61f605f74d86 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -18,6 +18,7 @@
 #include <linux/moduleloader.h>
 #include <linux/random.h>
 #include <linux/scs.h>
+#include <linux/vmalloc.h>
 
 #include <asm/alternative.h>
 #include <asm/insn.h>
@@ -25,6 +26,16 @@
 #include <asm/sections.h>
 #include <asm/text-patching.h>
 
+#ifdef CONFIG_KERNEL_REPLICATION
+void module_replicate(void *ptr)
+{
+	gfp_t gfp_mask = GFP_KERNEL;
+
+	__vmalloc_node_replicate_range(ptr, gfp_mask,
+			PAGE_KERNEL, 0);
+}
+#endif /*CONFIG_KERNEL_REPLICATION*/
+
 enum aarch64_reloc_op {
 	RELOC_OP_NONE,
 	RELOC_OP_ABS,
-- 
2.34.1


