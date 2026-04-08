Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24523FD5F92
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 08:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 826066B0088; Wed,  8 Apr 2026 04:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D6716B0089; Wed,  8 Apr 2026 04:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC166B008A; Wed,  8 Apr 2026 04:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 561856B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 04:12:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E468ABA45D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:12:58 +0000 (UTC)
X-FDA: 84634672836.25.EE7D02F
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5F85BA0006
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:12:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=d4CwHB7T;
	spf=pass (imf15.hostedemail.com: domain of linruifeng4@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linruifeng4@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=d4CwHB7T;
	spf=pass (imf15.hostedemail.com: domain of linruifeng4@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linruifeng4@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775635977; a=rsa-sha256;
	cv=none;
	b=HUbRKCG/HddSaF5Pl74foimxycSHFe/1tFGWHlP7dGNjxM0GwIzLhXkiX4PhCNUuOr2VvU
	oQCGWrq/p12rDYqbKY1WVkEcv0JZsIRzpybDaouJrclZR9qYY0UTiMRwBHzrDhgtGYxP92
	X27dIPaH49rYhICHBNhV+o7ACqibb94=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775635977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=D4Dc8j1nfmErNosxziXn1qD0pEKNNpyJIdOEd8MGydE=;
	b=a/RCW7Pl675w8tQqy5IAFaIMIDPiV+MN9fHEVd/RDsdagkGaaE+/+DqaPpTWfR7edu8sam
	hZJ/lcjYLei3VH6NR+F1qBpqKtflFg4b5rP2PJGkKRUe+S6Yw7Q8FdMGZAsXvU809//0RR
	n2csy5KBeLeuyvaXZO4DuviAbHfdPNY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=D4Dc8j1nfmErNosxziXn1qD0pEKNNpyJIdOEd8MGydE=;
	b=d4CwHB7T/BfpIiJ9dxUhjmmqhh85oduzMsFRGGSxQM14aLEvKGDhQbZtHwo9cdM7+OPCEiQo1
	BOeFiMsk35DS4SbTbDvGo8RdKJ7naiTIWHP8+Z8wiGU7UcVctaObnlUVr/gZK9yzV3URSaJ0ESc
	RXhfXzEu/dnJZJKe4GacfEc=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4frFyM02KHz1prLc;
	Wed,  8 Apr 2026 16:06:35 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id D59DE40576;
	Wed,  8 Apr 2026 16:12:51 +0800 (CST)
Received: from huawei.com (10.50.87.63) by dggpemf500012.china.huawei.com
 (7.185.36.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 8 Apr
 2026 16:12:51 +0800
From: Lin Ruifeng <linruifeng4@huawei.com>
To: <sj@kernel.org>, <akpm@linux-foundation.org>, <chenjun102@huawei.com>,
	<tongtiangen@huawei.com>
CC: <damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/damon: support freeze kdamond
Date: Wed, 8 Apr 2026 16:06:52 +0800
Message-ID: <20260408080652.1745410-1-linruifeng4@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5F85BA0006
X-Stat-Signature: xh99ipfzr53ktrppuh6tw98stnghwr7w
X-Rspam-User: 
X-HE-Tag: 1775635976-957709
X-HE-Meta: U2FsdGVkX18a8kcnmE36YS0C45/yXoYdCWwDiJYBVEEQ6UWK1B+lndPpeCzU+yRBNdxTStZLVqf/MKk6VPPRsKlOjlde8SASD6UvHNH/6mpCpYNpG5HvNb5dElGEoGdlyHkp8jUyAGH8dCFaWtAEZl/F7XLhSF26tmPiDcztJA0GmWch3HSOM68gj1Kqqe2P8JdV9E4mOOxt9sJHlCRaRZuqjAOnV7Y/+hne3vTOREuflQ7wLia/UddeE/ngNvg+VmoQHcIeO1Ky6K95pDjuTMQc7ojdrnDCIxwZoBVb7EsrOZi+PgWoAo+LysO6agsJQmVz/DWQeyUm30zzaTzYdqSAJmX+In0Qmz2P4wmTIPuNhJVhn3A4Hs2XkuSxZE5KO59hklvmM/pOAho//GqxiYhTGKbh8YnEJbXAcvlrX8mJYx11cViIFVJ7oyeM3PcA5BbZM6hfKjEOruROUO++6kacesCE5d1wSVbakr7gL6yRPFYWRPw4AUilh7rIZ8thdcTMa6t2HuCq1lCf0PHl93o+bM4t/mRhQwANxUZJ5CQoTx5RbZImHz1FLqzXN9GOqUPFV+KldYHJj0lcLqH8PEZUSsJS8JUkpoMKdsZKA80SbxDS7gawPJKPeCv9mTsMQCMwti7mpMWR5lMyHOwghEX4z+XRLWnhwT+kifQnBjRwpAY9hZzepwt8+J6Ak38zfPhAVYiFZUOQPppggMpkSoJ5lzA+i6dYTcpvogR9MxWBnpl8z5jeYhRxGh+Z6zr9K7/sd9bK7cmzoj5BjWaEU2702svRZfrjRSAdifI/IgPw5x0VAloJo3G/AOTsJUWC/q/3Ab5ubeCUs8h5SY+ystCM8S+aF3gCGRrYy+tnnkFLn1SrSrGw1j6Q2n4SZ5sRMdrLqEBXVkrun3yP3ZPmrp9pJqZahuo61QVlD7G8v1kt59SWkMbtLnZDIAfuUUUfsvt4Vqdv6JbaXCkk7ZS
 UYLg23m5
 aeNblFYwB0j5LlObPe5BGQTdhtNoNeh//C+Wsckj/7HerC+LCsvmKNAKKC6KyhHOshQVOMFW6i0Y0F7EEYbpHVFoXVSZjpLNxyylMJRlEqr1J5P0afe0/S1ZCIjW4hBTWf4uRw1BNJ/BbRWljqAlWn7oIGxC+LNOJZ4dy493dqKeUlTz0kQUT7qV0K1TeRl1H82VEuqGpQZ5Hff83h4fefy69yCGV8LyqZoc0RSrm/IBDrRYD9iKc2ot6Ws9Bk+AaRb7dJj8jjzQ/9dcmqG1FW9Q2mf1VRr9uyMWNbh7iCv1KXoSKRetMidDEBXWcAQJijNAYgKBDGNSir9qrv4cimLPrtoFtbqweuEkT8gaCzuKG0sg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During suspend and resume, the data monitored by kdamond is
no longer meaningful. Meanwhile, since kdamond may involve
I/O operations, it is necessary to freeze it.

Signed-off-by: Lin Ruifeng <linruifeng4@huawei.com>
---
 mm/damon/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3e1890d64d06..5cd1f0aed66b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/string_choices.h>
+#include <linux/freezer.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
@@ -2753,6 +2754,7 @@ static int kdamond_fn(void *data)
 
 	complete(&ctx->kdamond_started);
 	kdamond_init_ctx(ctx);
+	set_freezable();
 
 	if (ctx->ops.init)
 		ctx->ops.init(ctx);
@@ -2774,6 +2776,8 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
 
+		try_to_freeze();
+
 		if (kdamond_wait_activation(ctx))
 			break;
 
-- 
2.43.0


