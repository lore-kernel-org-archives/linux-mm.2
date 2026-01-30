Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2A28D49C80
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 08:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F61E6B0005; Fri, 30 Jan 2026 03:56:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A3786B0089; Fri, 30 Jan 2026 03:56:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AF886B008A; Fri, 30 Jan 2026 03:56:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 374ED6B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:56:29 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 41EFB596E7
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:56:28 +0000 (UTC)
X-FDA: 84388024056.17.748D9C5
Received: from outbound.baidu.com (mx24.baidu.com [111.206.215.185])
	by imf22.hostedemail.com (Postfix) with ESMTP id 09224C0007
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:56:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of lirongqing@baidu.com designates 111.206.215.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769763386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=t5wMplL768bz9zgsuhmwne/hEYLl/+ynUEKbgQWee1w=;
	b=o2XgfZ47kZC/GopSsa6fKUoW5O63ss+tPMb2jJZwd/M+OCzd4GkhgbHCPw6icvx8mxrLBE
	HwnhnV2M4nDdfRtfsfuC73LdnxnSqOthZa541r9s1v7626pYGu9m9/e7y5fLzAV8/3KTjC
	gzbI68YYsPwndekzXUwlIF+djzPIfl8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of lirongqing@baidu.com designates 111.206.215.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769763386; a=rsa-sha256;
	cv=none;
	b=a30WSwsiTY1B+10C9s3cJCV8CzTyYJNuj/A7yNE4CCO49djlKEbnbtAK1J9k6IVGHIlRxA
	K4rvATU7nsyvwEoB8OhrFQyQyEum6UtKWXEjuKuk2yul+QSsJbPErAJlX6Auuz58MZK/0i
	bFDj5wLaoyDo0NA/+dO79pwS2qNA8f8=
From: lirongqing <lirongqing@baidu.com>
To: <sj@kernel.org>, <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] mm/damon: remove __read_mostly from memory_idle_ms_percentiles
Date: Fri, 30 Jan 2026 03:56:03 -0500
Message-ID: <20260130085603.1814-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.127.73.8]
X-ClientProxiedBy: bjkjy-exc11.internal.baidu.com (172.31.51.11) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Rspam-User: 
X-Rspamd-Queue-Id: 09224C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: k3c75oeoy5w7ygsyx6p3sdijyuogoqjq
X-HE-Tag: 1769763384-69032
X-HE-Meta: U2FsdGVkX18jxiVlJWXKdjzBgTCMqHjStdKYIjlrAEDdGyKCjVKU95oTyC3lQzi8MUnHNZAD1Lsragip6ws3IEXp+Kmm/caGa120bhlJ6A8+x6nu3uRSckfyz2gHmUPzM/bW4JUy7Y1U6Il7HIJqND6L/5fuADfAJVM+cLC0javDGQUEyYIH8NAMwxgXBGHu0efj8GjPBj35Ej+PXZrEMKKQM9d+GlrgmA36H81xWdFcphjUJ3ZyqF31lHvQ0/HN2E7rVLXXaHDaJk7GTwrK3H1sujE/EOSdBHKqYNfGhpf9UqzQQq0DArfII7+EjbUtTrkn6crotXMdZe2NpLpT7rVceZrMoECKvWGVW5AG2Ro1N9yOl3AiQpAD73a2KDIIHNrxaYcmojXSKhowmb7WcATZxQcwCtKZDkuJbPGweG3nsDaxgf9ShyrIONc7X1QpHQxWSg8sUo08nUmYaX3vFSRkwxk18XVDMg5x9i6nUGUvE6UjX/yvJLo/FlQMlQynWJk7497HXd6pHh437xSdZuYDvP3PBGbpO20Wi/yG15RSHDD+SIn/oeSbDAtdDTb9GtL4myapgSmGUCj/g1Kptj/8Z10k35hzQ2SfV8Hf1DKtMqGGYfZxmuFA/05zd6b/rHyjx41UIITqMIWtA+BuU95UmgMYPtcmmy9yofcoCyCYs0ctUd9hrFtKx5nrm57UkZ+k+2QLRkeawZuNNp0l/qsl3Mch8YTaoqAwmlzVUFHjPJ2TJmSLSSX3FgQjGhVRG0Eyaf8BQU5vEvDpZeEXfFpP1JjSl5MxEeo8GYpkwo7Ac4ECJ+CN8yk4kcokZ/SA49crIcb/u+jk4V8NNceJBB+50Adx1r+95ChHlmp/QMiEQMl5UWXffmYBOEUeGnBO0NPPQ0euKCmXyGOztpvoWM9wSErRnU1+qVW/9i4AHb93DtmJTl6N0qvVFVbh5E6GBuuWgYTEGLcfoCv5mTq
 b+5IcEMD
 te/X+BLJRgrs4WI3I2v3fGDcizDlZVV/KdtMLumZvPNDQ8iMzwZVFnk0cRXn9bHp8MVGk9HKR0S1glFO3G4yLrc59j1sN9C48QOt25FFJmlXPcUHAiKixqcp57z8h12i2LVPVMuF/bVdhvXUpBFuCRovo5ZyXpXNwpbqU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000003, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com>

The 'memory_idle_ms_percentiles' array in DAMON_STAT is updated
frequently by the kernel to reflect the latest idle time statistics.
Marking it as '__read_mostly' is inappropriate for data that is
regularly written to, as it can lead to cache pollution in the
read-mostly section.

Remove the '__read_mostly' annotation to accurately reflect the
variable's usage pattern.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 mm/damon/stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index ed8e362..5c4eec0 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -34,7 +34,7 @@ module_param(estimated_memory_bandwidth, ulong, 0400);
 MODULE_PARM_DESC(estimated_memory_bandwidth,
 		"Estimated memory bandwidth usage in bytes per second");
 
-static long memory_idle_ms_percentiles[101] __read_mostly = {0,};
+static long memory_idle_ms_percentiles[101] = {0,};
 module_param_array(memory_idle_ms_percentiles, long, NULL, 0400);
 MODULE_PARM_DESC(memory_idle_ms_percentiles,
 		"Memory idle time percentiles in milliseconds");
-- 
2.9.4


