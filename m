Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A98B10BA421
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 07:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97CE6B008C; Sat, 28 Mar 2026 03:15:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48A66B0095; Sat, 28 Mar 2026 03:15:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5EA36B0096; Sat, 28 Mar 2026 03:15:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9835F6B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 03:15:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01135CC19E
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 07:15:19 +0000 (UTC)
X-FDA: 84594610800.19.4B037FC
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8093540009
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 07:15:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=INv0jD1c;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf04.hostedemail.com: domain of ljykernel@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=ljykernel@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774682117; a=rsa-sha256;
	cv=none;
	b=Ok2bV2SWx2h6CinmbMnXwvLfcmTW1ixiyteW06QlE1uph6vwifV9igpULt9yDUEMpwJQvh
	yqemZaI1GaGZNCr5VS6syXrN6uFGy9DO9v/lW1pJQznmlneofwjpeOI7klfvlo+IeYR4C2
	L6rKYv3HSgM3v8BDFwOEvWPcJtNVu4E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=INv0jD1c;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf04.hostedemail.com: domain of ljykernel@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=ljykernel@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774682117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GSQdopy9IOFzy9zXCzk176qT9TVanGvFuvMaw6cmkBU=;
	b=IcWBobdOAGdaHWHSS4JjsjmUTFjgSRxPT4NaBORxTCMr7SsE4IcoDIblPnZRf3xpXYK7AI
	ple6BR+nWmfNlYZcjCBlAKiiBgT9342nCl1LMxv7H232xLK2DGGOAnp+jGeJdwdcDlIP2t
	K3VU14T0fUuSykIAqLQ/yK2op9IMN7Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=GS
	Qdopy9IOFzy9zXCzk176qT9TVanGvFuvMaw6cmkBU=; b=INv0jD1c70SqY404UW
	naKm9WeGTmXnaCpflmhJc3qe4MsBqqtiaJcvss9qatDu5hX0djddr2RxEpy7zJI1
	uE3eVY+ByWm3PzmFGRi+PCg/P0c+YDxCWdGHKr7ftjCTCcYycHRLATPBhfY8donl
	KvUYaSCfqymjtPVXL/Ws/3jA8=
Received: from node-3.domain.tld (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD337f9f8dptZiJBw--.62665S2;
	Sat, 28 Mar 2026 15:15:09 +0800 (CST)
From: Jiayuan Liang <ljykernel@163.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Jiayuan Liang <ljykernel@163.com>
Subject: [PATCH v2] mm/page_owner: warn when stack trace depth hits PAGE_OWNER_STACK_DEPTH limit
Date: Sun, 29 Mar 2026 05:44:08 +0800
Message-ID: <20260328214408.2990597-1-ljykernel@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD337f9f8dptZiJBw--.62665S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gr17Xr4fAryrJr4rAF4fKrg_yoWfKrbE93
	y3X3Z5tr4ayFZIvw1Ik3ZrJr1293y8Arn7Crn2gwn29r90qa4kXFyvvwnrur1UXr4Ygr4D
	Cr1DZayjk340gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRKCJmUUUUUU==
X-Originating-IP: [211.103.144.18]
X-CM-SenderInfo: 5om1yvhuqhzqqrwthudrp/xtbCzh1r2WnHf-0f4gAA3w
X-Rspamd-Queue-Id: 8093540009
X-Stat-Signature: ahckmgefkcqn99arhxqqo3zx8fnyz141
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774682116-4797
X-HE-Meta: U2FsdGVkX18jC0158qL60L3xW7CpsozBSu8uPb9RvIrch7jm3ke4rzu9uzDnVEAsc7ryZDnd8L5zTc8Uz0xfzGPhEGwnfB5ttnRYMO5M8dsxxZyOZRCDhhbeoAhv52weGmgYO/z+jvbOyXf7hDtD4Cyf1FkpvGG9JvfNSNi8HDhCBt2DGJ9MwXDEr7ZRdarANNRgNs24xU+n/2gXLfRxomN70Cyn4w8ChLO9qN9Y1gkQqlM/8/p0VkKcFim8/T8+4brj3LbgSmfo3Ymu9k4/IRqBLQNT8f8lWksgTbtDpv7FwWnpCUf8sXBoO7TWuBGbzu5QReljj786hPOUz4BnCdEpbUmFt622IqtWb5srz07O7GN2i/yfgHuELkkA7BH7PA1H9Cnaod0Kcf5Mk0wlO5dMTCqgsyL5oVIH+mguQ8Miu4riVfMkIKhXTLFld10cLT4tbZIIo7uWU0qqT/4/3pnOOCaXs6THgGix4N6hWZT+xacbozaVMPIp0tNmBaKZgrtDzQK6a4Npds1sXr/GHgHfMbiyLsaOtEWt7gYpY5XTafQL2E1U+SS0XB1GXqVy7QqFXHucc9XfIgLnFh4xGiM1bq8hSfdHrbQdAQXleTo4rCL6uATs9W6vXaK2o3gui9er8CEczjd+RO27jy1uhOyrM9tdhNo42Y39T1h95gZUPvGEbuhWlvlRv+6MlLezSwuzTfnhP0oiAi9n6+Dx4lb4j3cWSvscuBr6bsu8zuXI9+EiaFX/UfOspcp8/1ZqhB7oFUKQxyJwf76g32ton0N5pD2G9Dgfbeoa2ecUnj5LQDTTGsLxp2LxYN8/XJSNzTZ6xF5rmkCd5VZh2AguM/KLq6GbnYs8zirw9sF+8DKGn1q3RWP7E1LEXkip45oQC+6UNkdz92gwRrNj3Rg5lUlPAEQhoVkyNfZbeHeKcTwjXrtidL97zPPATU0sYX8mgp2YIoJHc0HbPDQlyEx
 0yB1Tg8h
 nXTYOWUoaO7N+Y3ikG8VBv+q/FcluFJzoQk8maicCUuret45VUVw9itOmaXiZRV665yiIIWXtLm4FY3zBp1kAz+uCFjxy3M/UuklsmBc6MX7p9HjbBwOLEwmNK9AQdEVb3gLtpHM4HF6I7ZHS3bMrGveCbX172Jy44NIr6Mwgnishvc51ARcUVpIxlMg3m7Cq4E6piZSiFDopgbexM8n/g+vbNATTThCeOtANJOG1bCAd5hnC75zPedEkciIhx2D8ASYtq8OqfHMQ/Ct7lyl/U1wp+7UHJShlwjf9AahN1+oT2G3BoBvqOFAfY6WLPHqKEybWs1QSE79mRrumUTP++OK+FMtBnJfnDYzSE5x9NaMlbgVH2Qe0F4XL0sfGxYEEA0brGt2hOCLPzUN2R1JIxv6Wbopa4DijW2yTOIp04SAaMHmSgufWWN+UikfVgPiqfLNw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page_owner silently truncates stack traces deeper than
PAGE_OWNER_STACK_DEPTH (16), which hides root caller information during
memory debugging.

Add a ratelimited warning to notify developers when this truncation occurs.

Signed-off-by: Jiayuan Liang <ljykernel@163.com>
---
 mm/page_owner.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 8178e0be5..962a4f694 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -163,6 +163,9 @@ static noinline depot_stack_handle_t save_stack(gfp_t flags)
 
 	set_current_in_page_owner();
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 2);
+	if (nr_entries >= PAGE_OWNER_STACK_DEPTH)
+		pr_warn_ratelimited("page_owner: stack depth %u exceeds limit %u\n",
+			nr_entries, PAGE_OWNER_STACK_DEPTH);
 	handle = stack_depot_save(entries, nr_entries, flags);
 	if (!handle)
 		handle = failure_handle;
-- 
2.43.0


