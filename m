Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEE0DC531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94BD46B00DA; Thu, 23 Jul 2026 03:50:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 922B46B0114; Thu, 23 Jul 2026 03:50:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839666B0115; Thu, 23 Jul 2026 03:50:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 629E76B00DA
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:50:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9A921203DA
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:50:36 +0000 (UTC)
X-FDA: 85019269272.23.78D77AB
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf29.hostedemail.com (Postfix) with ESMTP id 49101120005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:50:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nneI91TP;
	spf=pass (imf29.hostedemail.com: domain of 3ycdhagcKCDofuaoYWockkcha.Ykihejqt-iigrWYg.knc@flex--jyescas.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3ycdhagcKCDofuaoYWockkcha.Ykihejqt-iigrWYg.knc@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784793035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+D8QBFGuuv7YqblppvOsw7r5pHNiLsUGTC44kaIR0x4=;
	b=dwvSaNm6nBO2DqtT05tIx2Elcf5jW2KWFaUIuIzbS/CHL6YxWsAVXI7w0mUXqfNOtT/8Ph
	qhgEK9QspF4lP5Clw8+7OajRlxXhd8P8AT+J3Tzrfd0gmpkkpGCskGvMZBQgKA8Bu5zGsk
	MrdlOoLFZaN77gFnIYeHn7LZGQqUdDE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784793035;
	b=N8MszYxc3OZNxY8zDOPWPnkmzUPgYCotVYJPTlualjLtqQ8/S74Ys4Y2EyeaWA1QVumDOW
	e7Fio8Ms88gGs3lzRXT8CeOlAtKTWoUv71vMPPklgGebCrHeAFdBbqh7yGOrV8ZJluq8gq
	FGznuwETwYQPRR7N2g1QxySz5/tqwGc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nneI91TP;
	spf=pass (imf29.hostedemail.com: domain of 3ycdhagcKCDofuaoYWockkcha.Ykihejqt-iigrWYg.knc@flex--jyescas.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3ycdhagcKCDofuaoYWockkcha.Ykihejqt-iigrWYg.knc@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb7049fa552so374087a12.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784793034; x=1785397834; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+D8QBFGuuv7YqblppvOsw7r5pHNiLsUGTC44kaIR0x4=;
        b=nneI91TPW6pN7X9hly9QXkURmDqsN+H7SKYfbpNgBWRftUidazhK+JPjkl0HuxFkgj
         rUpDiky/i9vqNs67IEbhdI8x+4hIwPB8Udd6P+4Sc1HVP02lqa/9+1EfzrRnc1tNX1oO
         dI5BZdvrfEdq5Fne5GvHV7DTwG4ET+hZ96BSCkJinbhwHJ+cdn5zEL1Djfl1VkByG8za
         oPIdXFS1vbjv3PxUMQOGk8cBDfpA4JzF9nxFu9/XsQX1uF6u6N4tLUM4XCTUL2ssfj68
         5mRQ12mjG+PCYF0BOWkojT3rH1D/eV9Q9ckZS3UCG9xkWW3zUM/mZhCHkGkpVjxrYcQa
         4FoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784793034; x=1785397834;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+D8QBFGuuv7YqblppvOsw7r5pHNiLsUGTC44kaIR0x4=;
        b=Oy3D+RxdVf0zN1Ifhm9TViW26dD9fXTQqR8X/JDYqbed4RwhY61otsJZWfyN3vSj/r
         pqSDKIb2LMNntdhqPGnhJk5mq6BY4zJRC4suKe5ROMRFQZ9OD1g4NlvyjaYsXT12Wgrw
         yvOlzH21a3jfTSbcMkROmpFRDEQWn7Nd10EINc2dD//04rHv+/6Wx4evf1weGgkYkXNE
         C1Wm43Ea1DM1QVuUkbjD4zKAduBHhuu5T6p309feVuaPKT1Y3x7AebPrOYmK/yJKwhmm
         vGrIX+MHf8g57b9S1Gh8FhtZq0ey9qlVJtDGDd/ybDBtI32HY59P5vGELYn0qgW41wxH
         GsrQ==
X-Forwarded-Encrypted: i=1; AHgh+RofkP0pK4Lpr3p5QH/efZLzxInDr5Bb5FSdUpIP9fu2qJvFgBdkoc1Gvy4U4Irx0QQLiMX4B6XFmw==@kvack.org
X-Gm-Message-State: AOJu0YwfPrWBEc1pGZ2YLxAGF8WFcCGX0jZywCsDCqwc7HHDKlKWp/CG
	bohssqqr4T2M9vb0c6w7I4NSZiW8hUWJdEQiEkEhqa+lBufozVSdLJ0Y4LREYymJdPu0DWW7SVh
	gfbSWMTBd8Q==
X-Received: from dlam5-n1.prod.google.com ([2002:a05:701b:2085:10b0:13d:1da6:85cf])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d44:b0:381:149:cf91
 with SMTP id 98e67ed59e1d1-38ec658d33bmr1987739a91.26.1784793033910; Thu, 23
 Jul 2026 00:50:33 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:47:14 -0700
In-Reply-To: <20260723074854.1013941-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723074854.1013941-11-jyescas@google.com>
Subject: [RFC PATCH 10/16] mm: Set the selected zone in gfp_t flags
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: rwyrmzhah78yawafjc73xuqg1zw5ka1d
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 49101120005
X-HE-Tag: 1784793035-801219
X-HE-Meta: U2FsdGVkX19l8DkUIdeQUaaMmEqEPDmYdMzxX+wKNRPy8gza2tCiCz4huWM73woWbMyCdFp9XYmVwsR0gSSxi56rELHrHcbJ2+aIbSXuX8KPSgQrNnqBSGKJjqL0wQERBIH75Bp4fq9rC1/MDCO+8KkFJA5xfLl9UDCX8c4xYZKK0d4a7aYqeVcMNCeHIdiynwxFbDVIpxeYkVUKK8HFNqJSyLoNzs2+t/LzazQ7rHjmYm1yjfONG38itwRDQgV7izCWa6MOIx8tg9j9HF/JwRpQmwTe1d9nd3SmhGLulntEQbeTqNjP9pJFhd3jtJOK+7ipBF0c6vcnoABD2aAMF2cQBxiFqrJLzMjw1TSlcdTUS9ZwnMq+tyNpVQEbBEO4bdfnU1N9zgtu5yhhPOffkm16+p5HPeWI118AysKDX3hE4c8/ExV/R7JM6ixC/BC5nclq7L9n9JpHn5/vO8kNtb5WDV9SFH4n64/+BCGscjpDu3Ox8oxnZtQJvDA7rdU21fE4UXDZd0/t3yyBZga1Ms2QOs3+in/oZb+IeNGkGPTK9Hs+nzCe15IgeXVSwBzEpfLpekBjLfT5w+A88dNcF/TF/+9LrmHuPZUYFqkF0ezeOqbzBESEnYxiwGRoasOCdwpnzITPzTc6dQT9xrv8SsWmUelkFTawOSb9GQTQbOZcdRQmgNCivJkM/nvNfL/N3a0P3JC2ApJetUnbOZiOnA3nYNuVahm7qyEmFwOWlQhP+HZt83CsMk9mbbnMV27Pm7y1qmMY8aXI3srDPr+OdD48KNwv0Wmfog8WBkxhQ6bSf6G6WkE1/P6MexICm7E+u+EVfO/IRCXoTqqGtV98V9PTp7MSSnnIWwaXool/jQ96MGHq/4wIH5WDwwI/VJKdyTpTb1ra4Sp1TamaWgQcTOgFbXthVe2MQzf4rn67IxIY8mi9sjtaU9nq+hUtqwXbQrgtjbLIe6ul2xOWC2e
 ssUsAV1I
 3MFiq9Y41hLHR+tosBi83bMc6sQjigqfYkcZnRvDsGzpUeoKlEDbdiLwSQ1IduCuQJSvJbJjwJ/L0bbcQmZ8UpCrPnd6Fysa+7BTzKaWxRHOSlFduHGebUoL9zZoPYMZzTWf7IHJl/rPAlqkFE/uUMUGtlB5VIKrfac3oGIuFQkjE4E8bEZ2wDQ/Y/8PhY4kYfZHsQOx++3ULKkcAn69MsWZj5q3NZXyUzjNsgUvztCCX8ntzwGvMU/YP/KTwOQGL52P5qU3JutDrS7EvvEFxabCeaBsCwzaQgpZ1+iX+6N7WlEJtvUoHcvgLRDrr3YkvKxYgL8+7V0VfgnNCY+LGNAZYwTLoIci0T6e2AG/JBIFY0owCQ+q/1GsdY9tJiKXu2bq86+YA2/Momer6kNPO2O6q1jJ/509xG01XLyg3TEYt/RVtRrSv9cLy10wmZ1GiSAg+uFIwRZmq3yOhxQrb3knva7elBud7blbjj4jc0Mwp9cvMgsnfdEgFSV/rIq434m3SW7+hpCkb/cSXKf+TEJcmdufEKo+p5XfbyqbDhjGKx5ZwMrqFoj7bFPxbSL7mtkcpskvNe+86qmENB06HeVr0WzpazoQh5H6Y4jr3t5KHnDTJ8N8Qnv2PgA5JaIesI+XxYsoOaOrVRVldeD+Ct7AZhzdqc417+KwiUAFGGs/duy2ThGi3KOrEz2KfNz+/uQezV0WjeClPPHk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change sets the selected zone in gfp_t flags.

Signed-off-by: Juan Yescas <jyescas@google.com>
---
 mm/page_alloc_hogger.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 60dfddf6b441..5c00e9134a66 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -87,6 +87,7 @@
 #include <linux/debugfs.h>
 #include <linux/gfp.h>
 #include <linux/gfp_types.h>
+#include <linux/highmem.h>
 #include <linux/kernel.h>
 #include <linux/mmzone.h>
 #include <linux/module.h>
@@ -127,6 +128,33 @@ struct page_alloc {
 struct kmem_cache *req_alloc_cache;
 struct kmem_cache *page_alloc_cache;
 
+inline void set_zone_to_alloc_from(int zone_idx, gfp_t *flags_ptr)
+{
+	switch (zone_idx) {
+#ifdef CONFIG_ZONE_DMA
+	case ZONE_DMA:
+		*flags_ptr |= __GFP_DMA;
+		break;
+#endif
+#ifdef CONFIG_ZONE_DMA32
+	case ZONE_DMA32:
+		*flags_ptr |= __GFP_DMA32;
+		break;
+#endif
+#ifdef CONFIG_HIGHMEM
+	case ZONE_HIGHMEM:
+		*flags_ptr |= __GFP_HIGHMEM;
+		break;
+#endif
+	case ZONE_MOVABLE:
+		*flags_ptr |= __GFP_MOVABLE;
+		break;
+	case ZONE_NORMAL:
+	default:
+		*flags_ptr |= 0;
+		break;
+	}
+}
 
 /**
  * req_page_alloc_write() - Allocates the pages on the requested node, zone,
@@ -136,8 +164,10 @@ struct kmem_cache *page_alloc_cache;
 static ssize_t req_page_alloc_write(struct file *file, const char __user *ubuf,
 				     size_t cnt, loff_t *ppos)
 {
+	struct req_alloc *req = file->private_data;
 	unsigned long nr_pages_allocs;
 	unsigned long *allocs_ids;
+	gfp_t flags = 0;
 	int ret;
 
 	ret = kstrtoul_from_user(ubuf, cnt, 10, &nr_pages_allocs);
@@ -149,6 +179,8 @@ static ssize_t req_page_alloc_write(struct file *file, const char __user *ubuf,
 	if (!allocs_ids)
 		return -ENOMEM;
 
+	set_zone_to_alloc_from(req->zone_idx, &flags);
+
 	return cnt;
 }
 
-- 
2.55.0.229.g6434b31f56-goog


