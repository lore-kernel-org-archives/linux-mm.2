Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2500FCCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AA988E001C; Wed, 15 Oct 2025 04:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65AF78E0002; Wed, 15 Oct 2025 04:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570EB8E001C; Wed, 15 Oct 2025 04:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 42AA68E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:59:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E39FE140BE0
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:58:59 +0000 (UTC)
X-FDA: 83999748798.09.A03F6AD
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 13EAA100003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:58:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kMBfnr5Q;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760518738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z6GEbOuJoC554lGHBLYuF53j0sRi/iooljPh8BTRXkY=;
	b=oxpsQw0+s/gXzQBiKUa5ckQk42PvBumTDSIK9ofrHY2BTiFgLJR8x95fCAE7UhKPcDH+uT
	3Hta+kwxNjh0uuB0SJHPz0r7M2cj4o/0XWk29MY4buyhzkY1XJRTsj1jPUdanyZMVXcl2/
	tKwkx+bdvrkFACkA2HyecAIJwk/5CfU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kMBfnr5Q;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760518738; a=rsa-sha256;
	cv=none;
	b=3Wm8tKDiRsnFXg8n/v4iXdv+1QBHl8ZBcyuewg4927f6yH4G+c2OpY/+e+Mh2ZNWKGkENM
	CEHFYzH6nnmmB/tDGhWVVGPsXiEYqkVll+DnQtcxhEgI629r+gRHVns4+8NQLQ2K7qJEWb
	fqh/Fx0B1KGnAl0jU/WjHObkJQRGerQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760518735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=z6GEbOuJoC554lGHBLYuF53j0sRi/iooljPh8BTRXkY=;
	b=kMBfnr5QlX2wURQI43A8aMSWif7BZDWTzOc+5iLw3k+cb/clwblt1cctZqGsG9itxt9xpZ
	OAo5lmlyi+TQMmCMyKdEAHmgCLjzSwlwGAAh5TtYevD3Klpd+P/dJfnjJSzAIjadQwyGTQ
	Q6KbMjHuxNFqYbgm8KsWkmwe6gG/Hg8=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] tools/mm: use <stdbool.h> in page_owner_sort.c
Date: Wed, 15 Oct 2025 16:58:41 +0800
Message-ID: <20251015085843.104443-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 13EAA100003
X-Stat-Signature: dx4r6s75ngtxour7dn33ftbyi11rmuzr
X-Rspam-User: 
X-HE-Tag: 1760518737-746259
X-HE-Meta: U2FsdGVkX1+rmMPD90m0XWiOXpKWPHT76XDrwxzmitHyrHQ3J5Bsz9CM9P13IKE+xpNDAEGN+EHg5dz2+hrufKga7gidBUwhtY6PCkj/WWkX27LMXl7SgTu6bFolvP8nDeZQAfz0rJo0B+kLjhXF+WdSbcete/x3oMHtZboJSUmmCph2wOTbPe+APIfSbkJCNS5BVcV5tNX8hXXkfSp6qesajrbJalojm4y9bCYgMDqUNLD6KdXOArG+lLsShEAzOwihBVd3CG8phkbAwOSnvEmFNGmhRnh6Fs0LgS9O7RJiP2TRRwiefzewAKsfSpY0rsBYwXPbXgdFo9mAUR7ao1fwMm6kcaEfn2Pl0HRoDmXdfVl4nkQsOQDcLt3D4VMhCyhU7m2774/NChF2RBPJozHqi/5jKeJFF/cCroPIFgDksEkdmeCqDGhohJq1BrOH818eRtLRF49DfnIfKw+4ashe8aMpFkExCgpvf4mjuEgXZa+gdvyY0ob4h9NipDnk2zOB0bF3GEhKe9X1lnh2sncj8LF51jnE/OsP/r50fwknDCSQVgVIcEcky+xNbKLOhUpTBQPFhoNRUq5xMm2cbb4wjQMH37A2jGYB3L/O+jUfx/MZ4cYFPEe5Yj9kqB94BXXFKKS9vutXlWSVE7QWb24ZmlR6amBCUx444qBum4t4Bdz3cpIwWSHdLCv0nQwx5j+Y5vexOOgxLWljU3FXVKtB0086U7/t4NFu8pjioLAUbQB2qhIGeFykbzpZWth55+5FqHptbFS9xrtQwAXIlkoYcl9fTGeRVFjL5Ui/dKSQSVXeATdMaJLBptoRPbTwc/7oogAQfVNjqJWdEOLwfZUJ/MbPaLLLXTchPWd/B8MGEvTFYgX8IrM6Jpuld42gR2JQQ7A+2eDgTlJREKjtf3fnbAAfXAsxfRDUtH8PHXbH3H+cUa8nlcJKM+D2p6Xfvs/+K2cwlqItf7Z0DSF
 gRoFH7jI
 8hp5eNNEA9wymEApgZ9GHUCVJ6GXEBlWawT9s+OhQmLm9uJvFbwQTFSmjXkmleu63jRGR+k4g9LZwuvswYyRF7UTvBAYy0TqHVjrbkfZQOsZANnij1d4gTVdPMguWqkQYhgFfHH8rFEjrkSKPTCcT5B1T71ngEJLx5gK6oSve+JyyePrQFA/yQpX1/Fo7VzavAY7FF8mTykjTMz4AtRzfWah5ILGFlNP3GE3ECNgznqDAOoUuuSMPZf294g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Use standard <stdbool.h> instead of manually defining bool, true and false.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 tools/mm/page_owner_sort.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 880e36df0c11..cbd195d7b5da 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -13,6 +13,7 @@
 
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdbool.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
@@ -23,9 +24,9 @@
 #include <linux/types.h>
 #include <getopt.h>
 
-#define bool int
-#define true 1
-#define false 0
+//#define bool int
+//#define true 1
+//#define false 0
 #define TASK_COMM_LEN 16
 
 struct block_list {
-- 
2.43.0


