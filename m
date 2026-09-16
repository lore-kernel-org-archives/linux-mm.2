Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B603C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1226B00AE; Wed, 16 Sep 2026 08:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 930AC6B00AF; Wed, 16 Sep 2026 08:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81A1C6B00B0; Wed, 16 Sep 2026 08:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B6A96B00AE
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:03:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD4F31A06CE
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:25 +0000 (UTC)
X-FDA: 85219490370.19.EE50ADB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 21E8280008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mn2bIJmY;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BvSsEcfuxj9lC5YTGUuAUBtK1T4naFDW4wq12j/K7Zg=;
	b=7JOckzSqTwIkYFRar928mR9pymxXjkZzHX8EfsQc+rX2x3yJf9ghwz78eMkTOl3b/UNGih
	ry7ouDEsvR4XCC3cAVQq8BpOLSDKfBqVjwux4Yui6b54Txzq9a1Ub5hL5FF0wKaDqXr6EG
	tXSIPKt/+jUl6omx5rZDTBcWdfxtdxQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mn2bIJmY;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789560204;
	b=UBT2+AEk7ZdOWdAkaZ1n61sMzk7eMbIByjqPpxEC7KOTj1kEAszXqRTlFnbt2tRsP0KVnf
	f2Ce/pNtTE3eyqmAfNozMnU7427qOBrSdUboN7pmOvRO6Km56OfU4z7e+vsEYv1Zv2nabM
	6D6U3qQXddIB07RPbvi1ZKeQ33uxdpE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6576D43B46;
	Wed, 16 Sep 2026 12:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49C01F00898;
	Wed, 16 Sep 2026 12:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560203;
	bh=BvSsEcfuxj9lC5YTGUuAUBtK1T4naFDW4wq12j/K7Zg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mn2bIJmYb2iP6iTTQqcRf+V3ei9Y5yLFrakNHWf/D7voPbGhwR6ONRoyLaIQM2KAI
	 JtNE9yoB1GAI2sszrO/4TdezQh5ZoOTscCnxAighHM7Ov7TdPCDrE3PV8GeL1vm5Uv
	 G/HKnTHt5WvJyxt0Zy6h3+Blac/jnQj/8Rp3RapUnA0qUsYHeAp97D9Ac9qJKpH99L
	 dfBENR4QV/Id02mK0tC4gOHtM0bYaso/fe9YO1xpV9QXHt/LOSQ32nIt9vGJwUwIOW
	 j2AlQVN/MXbSQHT47PmZ8heCBfoaEVM6F1kmV1Sth8WyD1x7WCPboJvMTA8Imkrl0b
	 wDOTPYFyPq/Tg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 16 Sep 2026 15:03:09 +0300
Subject: [PATCH v3 02/13] s390/chsc: Use kzalloc() for the SEI work area
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-s390-cio-ready-v3-2-39e4894637d6@kernel.org>
References: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
In-Reply-To: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, 
 Peter Oberparleiter <oberpar@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Vineeth Vijayan <vneethv@linux.ibm.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 21E8280008
X-Stat-Signature: c3qcsodc418xpt3rzkoctmmxi9471kdy
X-Rspam-User: 
X-HE-Tag: 1789560203-303054
X-HE-Meta: U2FsdGVkX18fbtvgBo6IumWxsXSksn2tutKMmZ1BNkduVKT4WsIAJ2J6FJ3J2dveUpalIksuwDo78UB0uvlKHAdwfKVk4OJfPjTmTIaAkcyAE0mJnoZK89yPY9dl19MJWsi7zk1BqA76r2sk6P/iHpyLtL+6F4ZXmM6W6HGPpv15YvIo/CA1jAGxIE/lBVe66TqSLZ/h2jK4KFOv6DtJ7WGM++mbgE9u7Zgwdy50q9Oo237PF6eOwFM0mPf9A4CQqV12gWagAShJg7sYyxUC9pqSyUcX5lgsW5CJge34IJtlGCH547cdTbRoW7nMdQLr3nwo87w9UbI9ye3aOKJd6giPJ1w9wv9UlA+ssGhv5k6EPU39at2Q5TFb75BNwqQd759PHa2zf5g2LD1ipWp5O15HsqWaLU6Ro4nQ3yq60McWV95rl0/7f9fjDFiQviQgcKnkNgZ2G0ozINkFcnSrpVP5bx+Q4frCmU0XM1RCpz8ZikBxJAWYCv5ysim/Q3iwJPbKHk0AIvI/9u+pxL3tfJ+D9T5gaNVcaz7maGnX8MPuMQDMCwX2drp98hZNjxNbPQfQKvV7ELSnMLS6QYROvYMiqcyfTJjVjwH1yCDZgs4+Rj1bKyatC274x05JWggyoPF9Dn66u1Gpc/FwJMGg96mS77Ra5ppqEkdSi6PK1p8fNxsVELInaTo9ACL4847MsniROkp5EwdGMMlA4U4O+b9ABC/hcnMO/B8xYTMelWTIqXJpwCViyw6SZYxezyMOLuXdj88t0oxZqRt5bUSEjPXRb1/m2jynKgbAFRzC8FvamovTlR1zKKJ9vLRdhX2B8aXtxJNpFmxGq7aNapCCOGw7k9x3HcgQAbngLL5oeY4bVZzcJCxXt6SfY1UqgqPa6Pn2qxjNUApADpCoJoM//k9avi0wq/YRn5yDcYM7DlBhYYZkZW60mOEBaSBoBu/c1wNJwU4NYRe8Y2V646Q
 54ACOrxR
 VStprMyj1pMVfPu6OKeGxU3VxAbNgSa+CXSbGfZLFxfg1EYBJawkwZb7IVjj9/g4cYNyPHSNPDfaA8b+T3FnFIqonE7shvp9eKfOa0dF58avj7gdESEqAJGCPAaI4EUh5iP+19/jsmfofiFjB4Fs+wQ4xQ3jUWmajJ+QucAto7PFv1gBOuBuW4Ttj1+3goHMzOnV3oexPEjfFU6wT32RXGisR+IonSD5hxgZTByCp90lN5LAQBKeMGr8iqeo8kj0mzuHO1+xTm99IVYA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

chsc_init() allocates the work area for store event information data.

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/chsc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 60a4a7e6086ce..c3186c0a372b4 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -1142,7 +1142,7 @@ int __init chsc_init(void)
 {
 	int ret;
 
-	sei_page = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sei_page = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	chsc_page = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sei_page || !chsc_page) {
 		ret = -ENOMEM;
@@ -1154,7 +1154,7 @@ int __init chsc_init(void)
 	return ret;
 out_err:
 	free_page((unsigned long)chsc_page);
-	free_page((unsigned long)sei_page);
+	kfree(sei_page);
 	return ret;
 }
 
@@ -1162,7 +1162,7 @@ void __init chsc_init_cleanup(void)
 {
 	crw_unregister_handler(CRW_RSC_CSS);
 	free_page((unsigned long)chsc_page);
-	free_page((unsigned long)sei_page);
+	kfree(sei_page);
 }
 
 int __chsc_enable_facility(struct chsc_sda_area *sda_area, int operation_code)

-- 
2.53.0


