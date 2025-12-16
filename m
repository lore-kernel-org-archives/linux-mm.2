Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB2CD5E136
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 11:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201EA6B0005; Tue, 16 Dec 2025 06:44:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AF696B0089; Tue, 16 Dec 2025 06:44:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091BB6B008A; Tue, 16 Dec 2025 06:44:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBF4C6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:44:37 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 84F8F8AD5E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:44:37 +0000 (UTC)
X-FDA: 84225151794.14.7337874
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7FD9C100014
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:44:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4zFhknKp;
	spf=pass (imf05.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765885475; a=rsa-sha256;
	cv=none;
	b=Dx73XfGwK4AZEwXQUD5WEXVZO1J77nvTF9hrvdj6T5dKRQq1NRmRSm871c9vpyEejJfIJS
	EEbmXECDREpyOBbnAQOpyBqnWc/aWLAzo0rqyFJu2JQSIUjq4P+2ZiEeQQ2jBTJJotSLOC
	Z3YUoKXnjjrXg0MhGUFsXBc8fE0dD54=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4zFhknKp;
	spf=pass (imf05.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765885475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KnbsOQGGqitZXvxlpb5uOrA7UELunCy7qtc61NghMWs=;
	b=HtfvkB8wpk6Bdk3OU+b7UJ3vGSWQHZ2xS5nuOVPKmOpjp9s0cne/m+tjoVfO/Sz4abNwaG
	ctzK1lxlu3jQWmSGX0NXd5HO+PFH1Co22B6BFxuEXCd9IiljykgItYaXxGBTx0ceQ5hsVB
	tztvgFGRZMZWoVPC1TszNC9cjFfMBL8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KnbsOQGGqitZXvxlpb5uOrA7UELunCy7qtc61NghMWs=;
	b=4zFhknKpV9/w8l2T/tbHvqWTEoM9TmkRyK65/EQa2f24kM/WAT51AIMqm7WsAZQHcFd1U7xFO
	fTGKY0OpoWcCKfqRfs8Xcp86yVH5Qc0c7ConSDtZt4M1VoS46SqQfyOHwsxShiM0q5PZsMcnT9P
	IlBP3LKiSoem2x2A38EuSVc=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4dVw5c05HWzLlSw;
	Tue, 16 Dec 2025 19:42:28 +0800 (CST)
Received: from kwepemk100009.china.huawei.com (unknown [7.202.194.57])
	by mail.maildlp.com (Postfix) with ESMTPS id BEA381A0174;
	Tue, 16 Dec 2025 19:44:27 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemk100009.china.huawei.com
 (7.202.194.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 16 Dec
 2025 19:44:27 +0800
From: l00580197 <longwei27@huawei.com>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, Pasha
 Tatashin <pasha.tatashin@soleen.com>
CC: Pratyush Yadav <pratyush@kernel.org>, <kexec@lists.infradead.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<hewenliang4@huawei.com>, Long Wei <longwei27@huawei.com>
Subject: [PATCH v3] kho: Remove duplicate header file references
Date: Tue, 16 Dec 2025 19:44:00 +0800
Message-ID: <20251216114400.2677311-1-longwei27@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251215091150.4094334-1-longwei27@huawei.com>
References: <20251215091150.4094334-1-longwei27@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.159.234]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk100009.china.huawei.com (7.202.194.57)
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FD9C100014
X-Rspamd-Server: rspam04
X-Stat-Signature: snh76raoj33uohh5xqgx51n6enp7qt1r
X-HE-Tag: 1765885473-242382
X-HE-Meta: U2FsdGVkX190aqn5OkKyC3NyN90JtWE/qkKfJ3OgKwLrCgt1lQauwR/mN4zZL8uBTHN/EvXN+7d5PlCEGpAh2znDj8mCt+kPCMdZNr6ks3VtGNr2hHAwviq7bhWZb0TUC43SdgoiShX82PwFMuZs3k+nGHjW9/v3qIpsyiyh9LTI/qgdIFF4iYTJs1RGUxYAeVbY7gAiNoSQBPWdgjPi2rj5VvfFCq/ERIu/MOgufqGyXDJT7C9IuQhMnIJbuheP8lEH1uP5qwaIiicigi48cJVovmR4o443R5tSvRMa1dXqG93tV0ifulhGMyF5PEzmF8Xq569Q8YYwu7MVZ9tZn+Ho2DWoux8ixPSLtKDNssaVKO5QYP6SRcJFzfXWocY/a+y49zti+diy4r+tW+A1LQnbbgDsV6cBRtM4LaLsoc4TVdndoLE0cDSkZs06GcWav9c6/mPu4SwXq0XaNDHIO695g1QqCP9+80F+nyQpX5ekvQGq9KBvK2F3/bBzqjZRKjDTR5h0KFoijqI6CEJ6ebdZJKFhyu1Vkr2tFj1TXm2aDIN1vK/jgy0GVyS75JZtntXSgMHNjp8Vg7vuYXvWmHJrU+2dQ2bvRZTAQdtI18Q8fCPeMBVQ1xhxFYejoUZzbzZr8TRL/x9TNKAoPDw0dqRii9o4vKUBvcg+k8lNe0Ze6ExUvOk8CTGjM5PzDAqe56eJlJanWvzO+NCjUmS4XAa+s7AAfga8lpvREcwEFRH8Iws0DhnPPg615L69paoTFewKkOIlJX6u6ChVnK0uG7m1aSOwPONQbFY/N2LXn/xnsUoNAPoxmhKAIdxL4VHrCc3ofGglVsUEOis5W33S6GK1LErQHxqx8JnflnBOhVfbk4fK5XUNYS1ilroHf9DqZ+Y4ELNc33+AxcewThGP6ETXexSUA8+Pv4MufI6mqzMDBzSn090nJqXZUhsF6Y5lFUfwhDGjCGs5rpfXhUT
 5sgoBx8l
 RzsqiaxD8bNZG3kxbqWSP/YgjS0WTCap/MnyLuGHTCkjjHOMe3uFXJDnR3i4Il0lTXSiCwQxB6KvSmV6eHQxKuDvFWaMvJBkgNCFkdgaITiWAsb3RLeWvmk8jpweHwjo+ifDvAU8od5qND75uLYnY1TDH7tzn+Z62F+0XQSh4Bv9OhQNU6iJHUshvCqgeOJeMjDE4+Sk7ZqElk+QHc7bHBOuzmlhE69Qlh0jAHGa4/IchP2PgSHEN6L5DtuMIRwG0zN2hAZn2TuZxOJavM4wngvNlzr7BSltLu3JNjUkry1VrK1tyjka3wi7QHSJ0HtysozPmHVm1d2QRd+PKaGcyG4V1RQtnnQal3t/yt0Wx15H3RJjOm3OlRtqyEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Long Wei <longwei27@huawei.com>

kexec_handover_internal.h is included twice in kexec_handover.c.
Remove the redundant first inclusion to eliminate the duplication.

Signed-off-by: Long Wei <longwei27@huawei.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
Changes in v3:
- move changelog into stat section.

Changes in v2:
- Fixed the malformed commit message header (removed duplicate 'From:' line).
- Added module prefix 'kho:' to the subject.

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

