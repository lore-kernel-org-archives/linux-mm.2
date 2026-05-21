Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 435FCCD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 02:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CFBA6B0005; Wed, 20 May 2026 22:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 280AA6B0088; Wed, 20 May 2026 22:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 195BE6B008A; Wed, 20 May 2026 22:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 043D56B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:19:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A7D368CFAA
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:19:28 +0000 (UTC)
X-FDA: 84789820416.09.1AFF2A5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf18.hostedemail.com (Postfix) with ESMTP id 63ED61C000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:19:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FXCoV6EU;
	spf=pass (imf18.hostedemail.com: domain of liuqiangneo@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=liuqiangneo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779329967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=akrxasQlRBwMUes7le78cPpBIDsElzjkYQ3k/XPa7rw=;
	b=Y2eWvGQNec2ChkK3h+tAYR3hhlyuGjZHG4nKZhX1SvABFjAtfDFG37deeAYICV9brf3mrZ
	ejvcGIoDqHErIosaWEyqGRnZd5Gl11bxl10q3N5bp43KdpDXdau67TtnQv9IzXqyZnoZGo
	iy/MPPMnjM1WPpcuAMHgo6jpOBxd7Q0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FXCoV6EU;
	spf=pass (imf18.hostedemail.com: domain of liuqiangneo@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=liuqiangneo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779329967; a=rsa-sha256;
	cv=none;
	b=KeEqyq80TP9xdU0eTYwig+RrAZxrKvktzzrYWhlcQ2/siWOLgOOlYFHQWtAVQSzx5zYzT5
	ffVbRPZ5oIs9tP+SMzCxhKuFdvTf7Dn7lcCHABPJYoslTLil2ScUYLDS22Yqp5i1efU6xj
	3imFG5PiSK9ZFmQWK1lBzux3EG5cimg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=ak
	rxasQlRBwMUes7le78cPpBIDsElzjkYQ3k/XPa7rw=; b=FXCoV6EUT1audiz4wV
	1b7t15ggWx0vUkygTFOfy6uYQ0YFQEv7F25Wpzh7i/p+oceYrzxNpC5rQTYgz9Sm
	Pjgh56EUHMcUsett5Dhis8ao5So3eTu1BW8sko6AlUH2dO/GHeyotJcilvRMUTMi
	48kN3evU7C/bYnuWVfTyYaiFg=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgBHbzOVaw5qG00ZEg--.62491S2;
	Thu, 21 May 2026 10:19:05 +0800 (CST)
From: liuqiangneo@163.com
To: apopple@nvidia.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qiang Liu <liuqiang@kylinos.cn>
Subject: [PATCH v4] lib/test_hmm: Check alloc_page_vma() return value and handle OOM
Date: Thu, 21 May 2026 10:18:58 +0800
Message-ID: <20260521021858.21511-1-liuqiangneo@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgBHbzOVaw5qG00ZEg--.62491S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGrWkKFykKw17Ww48KrWrAFb_yoW5GF45pF
	48JwnI9rW3Xr1aqr13Jr1v9w1Sk3yfta9rCFnxur18ZrZ8Xry5t3srKF40vr13Aayxta1f
	ZF4rtr1UuFn8uF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jzMKZUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbC4BofgGoOa5oGJgAA3Q
X-Stat-Signature: jxrfc144oqjae7bd8nq8app3kngrgwdr
X-Rspamd-Queue-Id: 63ED61C000A
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779329965-43980
X-HE-Meta: U2FsdGVkX1+7nRiTcbu7cVw5KakPP7sO/9FkgxPnoSo+DKMsycPCXsULbr7taZmw1ru+lTjKlrWtZ33H62ZHvkNTGYAAp2XTfIk7+I6dmgX5QQMyqJFM9utTquiZbWRB5n+JNLoF1XoUtsDCG5+XjbwMmjZnpo3vthNMDNsCjA9hzYQfWLs35sqmWDuhNjy2v0Q1S3FrNJ/9ivwxYkuppL1FF9Tqj6nYuB52hsoXatMk3MnJ93rGlDcCRVG+MYojx0Usgl0Syb/btCp57eDbNWoC0m4b8WbIjxT2nxg2eQlgwR4FcVYtzPTw1RUlRtOFOjt1qCLelcSlYX0Q+zT4MUUrMbjvCYjiepcQwu8ls700f1kloCBDnkFOj9k0F7vAdKd9hOResYw0B9JaX8mHrk3yv/O6tpX41792f9EfFZR+p7mmk/Cspwnmgs3y417ExIIkcAg+HeX5E/Iuem/Wr4HTWU/Rn59bT5jkgM0vjM69UZYH9pFj4r56qlQTMCq/Rvrnk1x1ctV8sUmHZx5U910Zn+zH/dfo1enpoMs64veHImK1yWFregSLLAXkJqgNGKfjBnKkMouWS0tosJnvwvVaBVcX2xmbZehh9RXsGL4FP9tF1KR2zjEM1mcTFDREvWnr6Nz41AYnYml7ztSpbi14jA5bzeNvi6rW4vy2JfHN1wqQDDb14YGASMhsclhe7X1TqkoKEUn34aW+S/ZLbvjKTAeibjbb33217t+NOJWwf4ucmeLRwyb7EZIwLfGBXVhovyzAPVyBK6RAoVsGU9ubTXSpoxXxp7h/jFi4Z7AmGN9qFm+/yI2AJCVMgbkH61DU65WXEs62rqQGhmjicGWqdT4vTOmpMpTDAv2+akvIwl66pmbqGds+1VAmDr08xh8dmI/mOWvkFk5I7HZHOVOZ6spA06piWxKzJmor70qACJU+O7QwVAAew6lcQKd+0ATgQfeM9PgRAsPa6kA
 lzQ1D7e0
 cncA4C9R05+KqFf/K8R8QSbbdG3U6NIgfltV3bMY2SKtE1/3+vcKM5okoj/gNCssV41kEflwQvNJrPrxrF3zLVE8X9Tnf+G4k6cSQzyuvvg4+jJR05/7SzKg4AX0E7iA2NC0dwoekc4YU9sSzy0eRVv+LdM00ZFk3mRiFjea4aHznj9vm0zpTHApBb86DOcizy9skkzo7KGN3gFPpxa4BY2sfUoG3A3MQRcZGdr/lRCKpbTwor6Wll1OT/iZIL8UUdGFBhI6EUE7d8o8uxyNgHYcS/Rt3jahLBOyEECNlTiXz9o0La4wplaKuwEONHzJrAzK1ISQynRoUnFgpnkKg+YpidkZGYANXOhNsbmhANRsHP5tmOFyGyxSWKPtwZu8nDr/EpHXZbQEUMNqzZt8KaQGqrFn0GaI+rWkZ06QY8E6nAUl7slervndb0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qiang Liu <liuqiang@kylinos.cn>

Check alloc_page_vma() return status for page allocation failures,
free allocated pages and return VM_FAULT_OOM on error.

Handle return codes of dmirror_devmem_fault_alloc_and_copy(),
call migrate_vma_finalize() to remove migration entries
from migrate_vma_setup().

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
---
v4:
- Resolve code conflicts.
---
v3:
- Clear dst[i] to avoid migration in subsequent migrate_vma_pages/finalize() calls
- Handle return codes of dmirror_devmem_fault_alloc_and_copy()
- call migrate_vma_finalize() to remove migration entries from migrate_vma_setup().
v2:
- Add unlock and free allocated pages before return.
- https://lore.kernel.org/all/20260514032345.32256-1-liuqiangneo@163.com/
---
---
 lib/test_hmm.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 38996c4baa40..b086034e8443 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1063,6 +1063,25 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
 			/* Try with smaller pages if large allocation fails */
 			if (!dpage && order) {
 				dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
+				if (!dpage) {
+					/* Unlock and free pages already allocated. */
+					while (i > 0) {
+						struct page *fpage;
+
+						fpage = migrate_pfn_to_page(dst[--i]);
+						unlock_page(fpage);
+						__free_page(fpage);
+					}
+					/* Clear remaining dst entries to avoid
+					 * migrate_vma_pages/finalize() using
+					 * uninitialized values.
+					 */
+					while (i < (1 << order)) {
+						dst[i] = 0;
+						i++;
+					}
+					return VM_FAULT_OOM;
+				}
 				lock_page(dpage);
 				dst[i] = migrate_pfn(page_to_pfn(dpage));
 				dst_page = pfn_to_page(page_to_pfn(dpage));
@@ -1148,7 +1167,11 @@ static int dmirror_migrate_to_system(struct dmirror *dmirror,
 			goto out;
 
 		pr_debug("Migrating from device mem to sys mem\n");
-		dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
+		ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
+		if (ret) {
+			migrate_vma_finalize(&args);
+			goto out;
+		}
 
 		migrate_vma_pages(&args);
 		cmd->cpages += dmirror_successful_migrated_pages(&args);
@@ -1683,8 +1706,10 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
 		return VM_FAULT_SIGBUS;
 
 	ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
-	if (ret)
+	if (ret) {
+		migrate_vma_finalize(&args);
 		goto err;
+	}
 	migrate_vma_pages(&args);
 	/*
 	 * No device finalize step is needed since
-- 
2.43.0


