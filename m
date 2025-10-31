Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E0BECCF9EB
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 06:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081528E0045; Fri, 31 Oct 2025 02:54:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D36B38E00C8; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13FE8E00C3; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9248E0045
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E24D885FD
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:54:14 +0000 (UTC)
X-FDA: 84057495228.28.B8C91B0
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2947610000F
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:54:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761893652; a=rsa-sha256;
	cv=none;
	b=hbtq5JxvpLV6xHBbr3SBVksHwU1rK3YifWHqiS0b3rrPcK2MOfVeFerUlycIXoF5AIr1Py
	+cYhbLYQGyzz7wMP8C1jfhXbpCXfQKDn6+/69RLjNQpK5NaH9UhfGjjGgHGgnTlMWANl3x
	3girmVHpYmPZK0FzVLycfae/up3xqhE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761893652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WFjFltfgKt5EHOFlCDblZeFhQDbuIBhyC06c6h7ZXc8=;
	b=CgpRJF5V4tWz/Xs4VRfP9V7KG0nNMehA2vImjEZQPe9lzSOCOSChEgU5wVdsL9xVxkcFoo
	o4VcidutkFGo5EISEOvVgAoXhIhiHtYmf957452YvjFXcHI3cr0hsqg/O6PtqETUeTML1l
	Fgkmq2wh5u9esztsJt8BkXMujaB5nR0=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 31 Oct 2025 15:54:08 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	youngjun.park@lge.com
Subject: [PATCH v2 2/5] mm, swap: Use SWP_SOLIDSTATE to determine if swap is rotational
Date: Fri, 31 Oct 2025 15:50:08 +0900
Message-Id: <20251031065011.40863-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251031065011.40863-1-youngjun.park@lge.com>
References: <20251031065011.40863-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hpsxxuebeiy98gqsgzwwjy7upz5d8oiq
X-Rspamd-Queue-Id: 2947610000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761893650-796922
X-HE-Meta: U2FsdGVkX1+5GaJ95Bl/sRaEtGrSIPZQf/RdxGUrACvB9thaQ3Jkjw3u0w52yjWAurIcJK/pNmq9S55asKVqUZxujunJQvlsSVWK5owXmmb4bdautsQ0J3Yy98+pKz5TUPJLPnimb0QgluJC0TlyE9EwNvat2//EXXcYn9GL5uI7sKzPsE49jUzU0pYfKNpvW5t5Jhg+a0Hjix/tfTJd4JcZV368+iAamcU/UCv/4JmppjdLSYRvJxLWEhZ1svnyZD3/AjimKO21wTAASOlkOKfkT5gMqWnXG+65XAs3JZ84BT32YVOEEHJMcy3lQK5SlPL9KwcRqs/soDC5K0vccQbFpEqyqrsPHumhwP3LMMUHAfgpKmgRW7fxDhrM6Zn+32AQQjqAWKkiMWYO3b+5vz3Srdvh2pAPV3qTJsvxy7ci6oNyEuHyf+sFOFlLrpLvtHCdLJ7gKmkRWHR7yzyMgbSXLHAGVylz1koISX3vWDlFgGp9zLCBGEAwf01o40S3/cUEPBGMuh4EFxH/Y3N2cIIejLZISd4EgmVzHQLpt7xoSm3Cwr4JaYREDVi4sqCtwpxD12RbxEXIiS0PweGPHszm9/f+P1v2vt98sKvSjhrEY15Msv0ZOmaUHmkFqo9sfLGhZSWju0CEyE+j+woX3EG1MXxonIm6asoS+jD9DwR1b2f/LVRTlL80xxaL6zXgV2CHK2oNTXzFy0aKoXqey6I6lgoquP4yO5sALvGn3gmm5SQWO7nEZbrfacMDFt2glLdaX9CZ+4ltxkL6GxVHmE3xkBOS9kz+tEYr8S7PS5kl/KYqeOw7Dgiktpbs8oLsQu2PxNwjKwOKcgJ4kB7qg2P71ixcdp9jMdzs7pEYR2GGrTfIcRL4ihxuKSHNpZIQMmIRUvMQNj9/MqUWTPJ4FkdvLCGGbEu/2FCxUiVO33HS3uyoRHINA9qz09az0SHsGYpzPfxFZwI9DmcS1w+
 bf7wvZIf
 kYouk6ewf+AzX3K+xg9kmd640+WEwq6W3NoGJ/ncZOKja2iLCU5pYSQbMIStCkLwAnXraAX/O8AOvWJwibbEHUr2j43MbMSy1q+e8VkLmdg79K0L3Dm44CP9Hjowv/wL0o57mmDdgbBRFkYHOc5ZU/G8pZNSQxPrB+vTPz5CYAWH6Kxl6hL0NXgWB7UjOetd00OyaxCRLcUtOBYWTWvn37lmbxhPjCN8TfrgvbflnH09Sv8Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current non rotational check is unreliable
as the device's rotational status can be changed by a user via sysfs.

Use the more reliable SWP_SOLIDSTATE flag which is set at swapon time,
to ensure the nr_rotate_swap count remains consistent.
Plus, it is easy to read and simple.

Fixes: 81a0298bdfab ("mm, swap: don't use VMA based swap readahead if HDD is used as swap")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>

diff --git a/mm/swapfile.c b/mm/swapfile.c
index ed2c8e4edb71..b7cde8ef6742 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2913,7 +2913,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (p->flags & SWP_CONTINUED)
 		free_swap_count_continuations(p);
 
-	if (!p->bdev || !bdev_nonrot(p->bdev))
+	if (!(p->flags & SWP_SOLIDSTATE))
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
-- 
2.34.1


