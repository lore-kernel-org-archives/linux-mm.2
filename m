Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34363CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00B88E002D; Wed, 20 Aug 2025 04:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2318E0037; Wed, 20 Aug 2025 04:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA46C8E002D; Wed, 20 Aug 2025 04:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC3568E0037
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:20:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C1FD160403
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:15 +0000 (UTC)
X-FDA: 83796438390.21.45CE9EF
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2E77180008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755678013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OVkuy8oWdJcl2WUwXkBCpd3JjszqeDzA+UnMj4HPh7E=;
	b=5b8pDOtzrxL5ar/9cmtXB52/wj5K3rGgljFJurZG+9TobSBnF7DsTWjgh1s+E/u0FhB1/X
	j3UL4coFboYAAuicePkPEg7QxMmvJd6MekO+DUEeKGa2RnEpdUz4BddVwMpQy9NRZ6ypmx
	ONGp0MopNAW0NThKQ5VN/XMPykHP984=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755678013; a=rsa-sha256;
	cv=none;
	b=jd6Y2mOvqkV+doT7rmkLc5agWfxlwxEdCJiv7OI6shZcwSxXxupyQalEtPLOlgp+BN9A/Y
	AlX17k64wzBYZrb5EXzjQT3hdk+bRfxtyISk820tQqX5CAJesX4rQgHB5p55hK4eVFM4yF
	r2nCKMzoOX13u7ksttaoxDsKne/aRdQ=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c6K7N102Bz2TTDx;
	Wed, 20 Aug 2025 16:17:20 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 3191D1A0188;
	Wed, 20 Aug 2025 16:20:09 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 20 Aug
 2025 16:20:08 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH mm-next v2 10/12] Docs/ABI/damon: document addr_unit file
Date: Wed, 20 Aug 2025 16:06:20 +0800
Message-ID: <20250820080623.3799131-11-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820080623.3799131-1-yanquanmin1@huawei.com>
References: <20250820080623.3799131-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: cyr3jkjrcrzai1su5fxrb13b545e3iza
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E77180008
X-Rspamd-Server: rspam05
X-HE-Tag: 1755678012-756413
X-HE-Meta: U2FsdGVkX19lrCqIHW+G2Scdd88Yv5nE7fYgQhwGRB+aHvzcuff7m4vIqZKpXVxFGkeB7IAobG1WovvXfs665E3oDWQUdAZS8rbFKAvfSyWIre9BedQFzhZQOsB7zXAlKjZDBrzVyXDodCIINB8XXqcTGGH+fKpimgz4uuWPyZAHATJeYMahp3hCa8VGH5iDBFPQRy5c9nFCC2V75JSuIGDAvKGFfqaujKuGnf3xhG01brKL+uJH+ycp83SkNGiePEVe1jdMXtT29r63KQHeZaPACgVuXZl8ekIgnYTJYBVsXpebwhdBGiSXW6vy745K1KsVLeP9HHKvUfB10QHdLZoAU0s4Z5tB7U/0kJrguZ338W3uzVDLoY0wksP1JAHfZq4rymHZgGpnoQsGGpm+E6U1GkgkGeYKsDfO/3dbXoGFnLIaJeDR/a8OLPymcEY8csLASNi4TcZusMRb0Aj5jE8hMVMQQZBGZ/j+04+UcRzHkGfMplFMpRd0LY5ENUrSf6+ipeOgObq6lBbeOXKjtt9TpMrLPQo+Xi8AGu1ohKH9qX9f4+G8sJugCDfsNZxdIRW+MFmMY/klTudY3udRv2B7KS0rZr77Xo6vkq4hxWM2GYbvszpIe6Od6BBN4LPm5DB9WRQXq16fIQUXjVbnA9pBEfoY0fEBHQrj9Xf/9u50gaSZpKT9Bw0sA6QxZk1WhksTMNjvs/IzcqFw2rLuLNU4TOes/hWCY5F3QUY/eZJiJNScgsRqKApXdzE/3QEPas/HA6O+QmcI/5ylCDppgZSccYbd4/DlsWnpzQgr/ekvK31JBCMLR5LICDQj+J+v37EArMpstGJpHUrZf28FdT1aPojR8babEY4ZWLzWpoVsuAXrtMu0FRC29rqBe0cerqrF/+DI3x9lBPzU+QPkEEIiMJzOnvVgjJqqWMxK7TfU7sQh3w1Hc/j7/QuKzj9Ynrnwcp8g9jc4G6k9Mnt
 LeMwLOu9
 EIlawQvLlYfEfBScEAFlWmTa7Z7JYxh8QGjDs/2NDUzMW2MupZCf/qSM8xJ2soJKt+JwtcxueBXaU3mL8nUqqcx+oC/RVo4Su0dXNDGAf0xpLQ0tBZ6BTyx5xyqvi520BOMcd4oOpsAfUrUj7qebtARn12HNgGwQF+K66csAEz2mL1dBM3SStOrA2CZ8n2muKtO96Kkz5/Vncx5lFf314h++93JX2Z8OVRS+4Xgfx70BuJKHBtp7/jIclTzKr6udab3C4gIRhETW/99w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Document addr_unit DAMON sysfs file on DAMON ABI document.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 6791d879759e..cf4d66bd119d 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -77,6 +77,13 @@ Description:	Writing a keyword for a monitoring operations set ('vaddr' for
 		Note that only the operations sets that listed in
 		'avail_operations' file are valid inputs.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/addr_unit
+Date:		Apr 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing an integer to this file sets the 'address unit'
+		parameter of the given operations set of the context.  Reading
+		the file returns the last-written 'address unit' value.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/sample_us
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.43.0


