Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 170A0C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 03:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBB956B0005; Sun, 28 Jun 2026 23:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E455F6B0088; Sun, 28 Jun 2026 23:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0E8C6B008A; Sun, 28 Jun 2026 23:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FDE76B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 23:55:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1845D1C3314
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:55:14 +0000 (UTC)
X-FDA: 84931584948.10.521F4B0
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3A3411C0004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:55:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FeA0ZAt9;
	spf=pass (imf20.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782705312;
	b=ZZ1TI1fC9QQ1P0htjHZgaNFL8U/UKY7FjTSDu1E1YQUEKNxBTi/mOGaMIlfo5eZA7AJzQH
	+uUY1ACfEYq2dbzT97pZRkLWb29sjcsPI2GPs3Xfg7KB5NHJpMgPPkVUv5m61oNpOPWJhY
	fU4ElKI7UG1pviz5U+N6G3npyLtHER4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782705312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2HEXuekBWlP8PRlh41ZFtpJLOZNwbYwKT+VJcXRzJeQ=;
	b=A5JYasJHZxJsyl6GLREcdtEn9XVvXi2V8I75gNI9TJ3MN+REpl9LbBAqP+z7J7/keRkxdV
	kR7W4b8ufdw6nZewjqQXG8gFTAP7NkZ/pja4WgxwqXaw08BtGKiQRd9J+a9xYb5g/qu2t0
	AgpMDYylknOu2z4imsUeZ4YAhaiJ8ac=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FeA0ZAt9;
	spf=pass (imf20.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2HEXuekBWlP8PRlh41ZFtpJLOZNwbYwKT+VJcXRzJeQ=;
	b=FeA0ZAt9WRFs8sSQkP/cXZfSRVHWFmKR8rNCuzUv2fK0Fh1bf0wVespxmM/Vbkl9r2CD6s9IO
	aRsvb0A7fwUid/04M3GnW85jNSEISjomFpYKmUTu6Mo0TzLREW+Bsk8QjlqyogDmVEh63/OuxIL
	GwrYBUk/VqpPz/cWc4vVWIk=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gpXHq413yzRhS7;
	Mon, 29 Jun 2026 11:45:59 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 8D5F540538;
	Mon, 29 Jun 2026 11:55:06 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Jun
 2026 11:55:05 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <ziy@nvidia.com>, <david@kernel.org>,
	<luizcap@redhat.com>, <willy@infradead.org>, <linmiaohe@huawei.com>,
	<svetly.todorov@memverge.com>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v3] fs/proc: fix KPF_KSM reported for all anonymous pages
Date: Mon, 29 Jun 2026 11:31:22 +0800
Message-ID: <20260629033122.774318-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Stat-Signature: jak61xh4fsbu45pzbcip7mcas5ebgnp6
X-Rspamd-Queue-Id: 3A3411C0004
X-Rspamd-Server: rspam06
X-HE-Tag: 1782705311-530806
X-HE-Meta: U2FsdGVkX19x2GajxWdhOg8J4rXW6pkefCtboqdc+J3KmToKoh036FMmepNH2XPMRa7iVlo5ysCRUqTajAWPWx8HDUc9UJMKXoDvGENA7oUZq42AVYlN8rhFbsH0Hd48I08WP23PB62rbj+PG5RlzvVoJb6+YGjlRPME6RGwdnEhveJeJrJvNkhpLpRxFkqxNWXv5FZgkDZv4s2qoTxnV8Z6U3ImMK9ZnsHSOebE58pyz+Tp7iqJShUdB4wTJoV+u9CBKRX0ulwadQT1Dkp3rZA+zHEqaUMvodvEu+bsiv0Ip7SlCqoVNe5/FMjWL5LPI/dIvlEyjDalbOg0GDAZDKzSJ1usybJvadi3+/PU9jBGyjCiITosYfYWbZDroXuQZMQZbe5tMEMZ2f8KdLcUtC9XTu5CdKBMwccaHgJJJwnRPgBBEZNpu8t+n2D/cWxhAhZYmpcRexu5/asGhL5f/3oA4LbYXSl9Kd8Tyh+SAUiJ3xSxL+YO2kbFWVsGSZWbBSOsfD2MAFgjk1+B79q0PUtC9Fxu+Q0qsUxfqXaFzBf7zLL87EK5yqAhhS1+dnZcevugtuOPKjltOF1YcpRpAXSw8RFcSSGMZ8u+WKmmbLA9kjfhUozMxel7tnyXeHicHVvYYDlUb4UFSQS3FxE72709Msg1suxLwK+XhfAGvk38Os2eJDhg/Rv+Hb61l11d2gitWZFO72BYIGnwPuyxMIYiGKP9nWTXj3H2c8aHK1Fs0sAM0Xxr9u5t4vBHafiDVIzZlRnJhYY2BiY7w5/sDGUBNzIXO/Snou3NouBlpTzJtNW/xQGEpTkyMA1UJtgfY+4O9xgiVk1gkzbHlpJgUJNvXzT9Of+xARPdxo/Urjyej2yLo5U3jeMuDeWZioE+1iz0MTkdk/QaOFTft8aGhCirQD73QQ+dsoToksbcig1UFZISW8GfZt7qPJF28sFnNptEG4Mpq8sWa3Lan5F
 NaPU42Fm
 QSr7Awh3JR+WWirZjjUEW4P/NG3NFtLGuwKx5p4swDBqOOBABxbj1zmug5tJuSrgSICcz1xa18Yl19PWCoRTr6x7neFGhdiGaXjJjB7ubAsIDYuAqDbBZa9M0uQGaE604rx3Ij3e7pPuM2YEpaEi26OHxlx1jT0xzLEzZAsDT/fL2MB98jCj1LdByKdtMmxOBMd88ULOXYYAko6K+YIDDcnVhSRQ2SuKpg0Op+Fn1KJdC9DR+velda14AQMVEoYNZLfEAcI/mYz63qsuZB7mc+u/ECx1hnD3XVziccXaKuxWE4aN75xeBo/LXik9qfevTt+eXyc5SPgtKH9lMr08utqLWLfWOXqyIffyjDoIwH7diO4uDy7IOgzIpzZJcrEB+P5zs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reading /proc/kpageflags for any anonymous page returns KPF_KSM set, even
when KSM is not in use. As a result, tools misclassify all anonymous pages
as KSM merged.

In stable_page_flags(), if the page is anonymous, then use (mapping &
FOLIO_MAPPING_KSM) check to identify if the anonymous page is KSM page.
However, FOLIO_MAPPING_KSM is FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM,
(mapping & FOLIO_MAPPING_KSM) check returns true for all anonymous pages.

To fix it, use FOLIO_MAPPING_ANON_KSM instead.

Fixes: dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
Cc: stable@vger.kernel.org
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
Changes in v3:                                                             
 * fix typo.                                                               
 * add CC stable                                                           
 * collect Acked-by.

Changelog in v2:
 * use FOLIO_MAPPING_KSM to match explictly instead of use FOLIO_MAPPING_ANON_KSM
only.

 fs/proc/page.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index f9b2c2c906cd..7d9387143435 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -173,7 +173,7 @@ u64 stable_page_flags(const struct page *page)
 		u |= 1 << KPF_MMAP;
 	if (is_anon) {
 		u |= 1 << KPF_ANON;
-		if (mapping & FOLIO_MAPPING_KSM)
+		if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
 			u |= 1 << KPF_KSM;
 	}
 
-- 
2.43.0


