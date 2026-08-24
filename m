Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54623C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 06:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C5326B0099; Mon, 24 Aug 2026 02:37:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072476B009F; Mon, 24 Aug 2026 02:37:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECAC66B009D; Mon, 24 Aug 2026 02:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C3B1E6B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:37:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F914C040F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:37:25 +0000 (UTC)
X-FDA: 85135206450.06.2FAD514
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf19.hostedemail.com (Postfix) with ESMTP id 439BA1A0005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:37:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YAoNliWy;
	spf=pass (imf19.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787553443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0WP5JdN/AIOBXWgf2qmOXq0QvCni7ganoj4mKN1n6I=;
	b=a1tDU9j9vXE9Fbxm352782k+jGnywXr8t5CbqY+FlEu3o5dchXMo3HS1yhq+YG3PFbaWLj
	inOKgtMji6gwYz1lgCiCwYQEubpz6c+ckj/YRi2JYhAK8/rcNt+QCgo8lDiKIXFg0pTQcr
	tE3YH9UJO8fCYawk5wqfI1w/GDbt9zM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787553443;
	b=DuHdDTedUCdIJlQixQg2jkvXxnohe1MCPax1idLHxxnKu2qEOtL0TbLMzYkbfr+KI6LCZI
	pJ12d3qhaPsFLU16meWw9jH6zVFvgO/6P/ktMJdr5z3j5W6JyZvnChSNbVJ8CaqBT2hoM8
	Ddxeb3iaDstLl2UWyB6H3b0cZPNVXNw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YAoNliWy;
	spf=pass (imf19.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Q0WP5JdN/AIOBXWgf2qmOXq0QvCni7ganoj4mKN1n6I=;
	b=YAoNliWyelz+I/5Dr28odx6ViEOy7u5pUiMvI06de7lcxVV6oOrV0NhvYlT4dzmwRe1qMJ4/B
	qMugIzjQzMSZRzr2luYhY5OU/xUmtmvmWWrzJJOElES7rESHZMmW2WE2uUoZcN9+ytJMkM9a6pL
	cpml4UW/fn7R9dkZgCt28h0=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hT1CF0bFYz1cyPY;
	Mon, 24 Aug 2026 14:26:33 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id B45224055B;
	Mon, 24 Aug 2026 14:37:16 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 24 Aug
 2026 14:37:16 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <corbet@lwn.net>, <skhan@linuxfoundation.org>,
	<shr@devkernel.io>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v3 1/2] docs: ksm: fix typos in sysfs knob names
Date: Mon, 24 Aug 2026 14:10:09 +0800
Message-ID: <20260824061010.3343959-2-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260824061010.3343959-1-tujinjiang@huawei.com>
References: <20260824061010.3343959-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Stat-Signature: ourzuawid3sspwmhrfn4xoharyoq1zoy
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 439BA1A0005
X-HE-Tag: 1787553442-42526
X-HE-Meta: U2FsdGVkX19vuJceZZ/g9b7c1u6mwfGceTSpK5DmGWO1ZQOJcx9/err509vVY/BUGXq6NgmYC2wPKUtiWkRPjBzreciEDQawK3ToBxWbdKKLCGjwtKLVW4txZQFK89tfX89WHu2KwXVIDrK1UR2H4JAKwKrEEbej8wDe1ybZ1iKQP9GV9c7jFWWEA+EkLM4I6N2zK30mIb3l8UqMZ9o97vb1wY3PEfokvp9ZGBcGqYcjZ8wq+BHU1mfDlYC9HOIvdxBy8/7vI01S9CcwTHQNJYQvi5skDWTXJhH7EOAD/p5PIYXD96PjU9H/vXRWZRk8eMYSS1m1CmHLcCRqZLShyq1FUn1JnUkU49VDI9SYPFNNisC6yV4G4nHn6yAE8nFtWQu/gIEnQ62TtP4/yDQdRTLCPo6t3RFjzN0GrNs9ZKTon+9YXl0xbcvvMnPZ2QDVGjl/bpwNf1oWt3CNcbH0vHRcWB0u82zxaNmx6N2v/s8fkMsOF4cJqC/rWb3Khieb16jdpvnvzj8kwlWbuxY/aVJpLG6MRkhocC2uq8xFrMEeU1RxpQ9z3axD58K6AC5HodlfKe8rPORTGCu2xc59i95Dx4rVZA3yO2Icz9YvgTEbL2cVacFDlqQf2AritYIhjCVlLOwaCnhKJ+S76fOWIJMOm0xtxlrjgOUvWHzsFi3NEQWi4Xd33btcMg1r1K/1Le4z3mvGbAdU3bDROlrB1XQjqTnwxoXCV/6TgYOVXHWXj0i1KeJ2OVK4PBEWQ16KdIEKRgHUHAD8eGtcugx3mhMAQDxL1zIrfcDUdQtAfigJhJPsocLw1pzdPH6Tv6O1Fjj/WKOSszAMln6W7hJ+tgcEhFuY5nYkdLecGcmCDmoMceLqYjzrOrCts7zDD1ceMSLWIxki+qZJJugwTENM0u9/LQcizLrsjR1IaMAetKzY99Osxb1yAPVPoFjeBk2O/Dg93vl84chOQ/MuiRt
 coDkglj0
 wNK3b/lIacp2MOKQ7LY3A6RX5fx8lxi9jQX0h8mMad1oixxeF6LW58MmsIDFZcfSovHe6MkQOQfWJwLl7FV/yGP/rfoOZn/ci0PLJdZSYRmtgb0+cMQmcUstChj4Lmw2fNwoI4QuLUHycLAm+44NIMf29DRN5RkX/rhOhAwK91gFSf6IS48H9uza/ZXuVPJzuRGfFq1ih0YNcRmm+iZAKqXis6I8DrJ2X84htcCovIx0gU4U1XSbDoy2Ptfvq4ZOjW6RVTjdiBXhSgifWi3AgcyCMVtWvUS4264i94f8gf5Ee7gUiR0hTgl3XdLiUrf4CI7JD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The sysfs knob names in mm/ksm.c are "advisor_max_cpu" and
"advisor_max_pages_to_scan", but the ksm.rst documentation spelled
both as "adivsor_*", fix the two typos.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 Documentation/admin-guide/mm/ksm.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
index ad8e7a41f3b5..c9f533b10f6f 100644
--- a/Documentation/admin-guide/mm/ksm.rst
+++ b/Documentation/admin-guide/mm/ksm.rst
@@ -174,7 +174,7 @@ advisor_mode
         The section about ``advisor`` explains in detail how the scan time
         advisor works.
 
-adivsor_max_cpu
+advisor_max_cpu
         specifies the upper limit of the cpu percent usage of the ksmd
         background thread. The default is 70.
 
@@ -186,7 +186,7 @@ advisor_min_pages_to_scan
         specifies the lower limit of the ``pages_to_scan`` parameter of the
         scan time advisor. The default is 500.
 
-adivsor_max_pages_to_scan
+advisor_max_pages_to_scan
         specifies the upper limit of the ``pages_to_scan`` parameter of the
         scan time advisor. The default is 30000.
 
-- 
2.43.0


