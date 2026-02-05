Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D21BEE9128B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 07:43:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F302B6B0089; Thu,  5 Feb 2026 02:43:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDDF66B0092; Thu,  5 Feb 2026 02:43:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCC76B0093; Thu,  5 Feb 2026 02:43:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC1536B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 02:43:11 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D5121A03ED
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:43:11 +0000 (UTC)
X-FDA: 84409612182.25.4387D85
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf30.hostedemail.com (Postfix) with ESMTP id F09FD8000E
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:43:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=z0hFhj2S;
	spf=pass (imf30.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770277389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2sEkyTYoXLoqsCh2Me8BmcoslamYjRf5TkQkVIJnLIE=;
	b=4qp4rDJuw/7auZx+FHF47xZOPApaNlGb515um8sGBpnSJoIemrlKUwUUS7v4rMz/tsE7SC
	T3WScfAshZOUvv5zZp5v/AFhNwtYQth6Mcg6QA1l74ZFb6CTfmiBAO51JS9Zzggn5J0II9
	R/wFCMhSNrCqpJxLiTBHnY6DDuycjJY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=z0hFhj2S;
	spf=pass (imf30.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770277389; a=rsa-sha256;
	cv=none;
	b=Jdonj7pvmjaVwXlddLi6kYnZ7FjbNKXPtLVr1HZxtzOHYIjlW16TPkNJS/YhCGWlp90L50
	HISIXD83e2Kt6vYKbR66z3miEl4KNmgj14ZNUGOOFMjl4cFOsXeEfTWtI4kgRZMVZLfHgb
	Q/lNlORbj0G1xfes7QQ6E/8JJbMzAfA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2sEkyTYoXLoqsCh2Me8BmcoslamYjRf5TkQkVIJnLIE=;
	b=z0hFhj2SHpZLKHA0QzfvcJemSPOdSmSlDHv3pAJRdH/3jL0YqMgP3a5ZzAnxj4fFQawthP+oE
	NsWol7eY67E5r0IKVaxL2vr6pOuqaRywRthIvcvHNGEdq9WtiJLcebPCRfb43ySlqoJt+g+zzK0
	hacammfPG8wiKV2ChdpDXhU=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4f68GX24SLzLls7;
	Thu,  5 Feb 2026 15:38:28 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id CFB8640563;
	Thu,  5 Feb 2026 15:43:02 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 5 Feb 2026 15:43:02 +0800
Received: from huawei.com (10.173.125.37) by kwepemq500010.china.huawei.com
 (7.202.194.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 5 Feb
 2026 15:43:01 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <akpm@linux-foundation.org>
CC: <nao.horiguchi@gmail.com>, <ziy@nvidia.com>, <shicenci@gmail.com>,
	<david@kernel.org>, <jane.chu@oracle.com>, <linmiaohe@huawei.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/memory-failure: reject unsupported non-folio compound page
Date: Thu, 5 Feb 2026 15:53:28 +0800
Message-ID: <20260205075328.523211-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F09FD8000E
X-Stat-Signature: dym6ikc561ipj41ai8ogk167t5fcyxjz
X-Rspam-User: 
X-HE-Tag: 1770277387-798083
X-HE-Meta: U2FsdGVkX1/iek7DuSbFTt+Y9ApJEMMAtEFcULGcesOqsQXF9yvnPs9PPDb+mVI/0hItnLaXtbGoHbUEqK6rI0MoGxxA6N+8PL60mpaqwz32wOOay/xzVENBY81QeU7PQuUXvRBcp8RdR+UY+68o2hZSITxwH8TXlSp1nEtD3hhlTRFJFXsshMs8iyA1cRKgU5xXt3hypEPTxdGOipKBStJ/u7dDEr8MiIP/UihgcmA19lmm/LAfOJqWQjyvZ1GWh52WFgqzlgZFn3HjXKAVjadgWDL+vhPGwc12cZbEUNOGextQvUqyPQIsq8KVSc9rg4rpEEwE61gWVsfMm/evS148Ec2900gswV698rqwwSBfXYFO07t+RC2qu4GEhs1nhb0oX4UpfyU3MUZwq2rPNwl360W5mtAtl0xE2QL1cTZwwf+SKkwGlu1Wr1acZchEYTgKGKfykCiH3EFDJvPjWSWR7c2tPqAZooRAXinkl8uueut7zSumiKAlVIduKBx13HJV41pnYaNj/ULXdBsBlrlVN210MqgYrqNZskiCM5hUmjWP02c2WjXXaCHbYexps14u0xC3uRfJoBPZ2eaz5nL/QeHiSs8SeyGxl7fKSaG02lDY17Hv6bIUZnU36bY3DcXjOdb2p4jyG9feMjio5Sh5Iej+kV0X45B8IcJWMoQzRIu2V9jE0NzFWnU0GnosR0bp7Mk1Ajjqf0++VPv1ldNGuBywH9eB/cMmkV3Ws+yYIKXbLNYNIHtAcDUZih2dMlMGY7tpUe9asx1L3Plzty2o4hUv8LWhTaeKqITncp5J53GfyEh3RIPIA3IlNFi0t2IRbJaVfGaj3ERVNyd7xXbA5M3Q+ZsKG8ozUoxe69IbyVaT3mQszKgHts35YesIbJiUPCvQvp3b5J4SM3MiHpBLor6e4XivUO2+Hw477hdPoV773mB/KwGqilZPV0RNJXAMIZnvdgMyRPdHsy/
 pZdhfr05
 WTNMTlNZUSCEc/9FYkEaowMKmnjvX7+ZTpjNy5liarwxtH+QOqcJ55wPu7xd4D4H4S3f1uXvm5ZpwJUq1eOl/450sd2Wu4Ymt6lulkUPwvEg5iBi1ARfvXiSBUfSF4pJ/20OlXenYHaicP0niXL/Ax2L/N4r6N6nrq+dC0nX8/T13lMzGGgOizUgGuSj38Cva49jyl5/FGl2JxMvF0i7Zl7ERO0qgbYS78YNXvRYLteN1MIsDMaI2LRwL1HgTLnLVQwE0TapKyiIQHxGl4DMO8ZC29CmNk3qTMMom9CuQpzEX5mCMfeDTVu9m8yg3cwXhzCoc6Qivn6L3xsqbfN0jDsw6VHJ0xdDWgttn3kU5OPFCKt+iFL+Vnma92+AIFvdywm7OdYk+EYDqxK73VPFueT9H+fe0gdQ4n4SYW1EeyFqLoxMUEtBavh8VCR3E/OXtLQ5F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When !CONFIG_TRANSPARENT_HUGEPAGE, a non-folio compound page can appear in
a userspace mapping via either vm_insert_*() functions or
vm_operatios_struct->fault(). They are not folios, thus should not be
considered for folio operations like split. To reject these pages, make
sure get_hwpoison_page() is always called as HWPoisonHandlable() will do
the right work.

Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
Reported-by: 是参差 <shicenci@gmail.com>
Closes: https://lore.kernel.org/all/PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com/
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
[Some commit log borrowed from Zi Yan <ziy@nvidia.com>. Thanks.]
---
 mm/memory-failure.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 825c706ac576..ba4231858a36 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2411,31 +2411,29 @@ int memory_failure(unsigned long pfn, int flags)
 	 * In fact it's dangerous to directly bump up page count from 0,
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
-	if (!(flags & MF_COUNT_INCREASED)) {
-		res = get_hwpoison_page(p, flags);
-		if (!res) {
-			if (is_free_buddy_page(p)) {
-				if (take_page_off_buddy(p)) {
-					page_ref_inc(p);
-					res = MF_RECOVERED;
-				} else {
-					/* We lost the race, try again */
-					if (retry) {
-						ClearPageHWPoison(p);
-						retry = false;
-						goto try_again;
-					}
-					res = MF_FAILED;
-				}
-				res = action_result(pfn, MF_MSG_BUDDY, res);
+	res = get_hwpoison_page(p, flags);
+	if (!res) {
+		if (is_free_buddy_page(p)) {
+			if (take_page_off_buddy(p)) {
+				page_ref_inc(p);
+				res = MF_RECOVERED;
 			} else {
-				res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
+				/* We lost the race, try again */
+				if (retry) {
+					ClearPageHWPoison(p);
+					retry = false;
+					goto try_again;
+				}
+				res = MF_FAILED;
 			}
-			goto unlock_mutex;
-		} else if (res < 0) {
-			res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
-			goto unlock_mutex;
+			res = action_result(pfn, MF_MSG_BUDDY, res);
+		} else {
+			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
 		}
+		goto unlock_mutex;
+	} else if (res < 0) {
+		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
+		goto unlock_mutex;
 	}
 
 	folio = page_folio(p);
-- 
2.33.0


