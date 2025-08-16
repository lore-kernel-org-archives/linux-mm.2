Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF9DCA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 16:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2B78E0028; Sat, 16 Aug 2025 12:56:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A848E000A; Sat, 16 Aug 2025 12:56:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBBB78E0028; Sat, 16 Aug 2025 12:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D38B88E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 12:56:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71E53B9A60
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 16:56:10 +0000 (UTC)
X-FDA: 83783223300.05.62E48ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D5834A000E
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 16:56:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R0CIZP3h;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755363369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GlD2TP/rHKub5q67tK17rGXITKsC5ZGKdsWWIbMiJQ0=;
	b=PxN79d8k8TKWU+1WqeRRHd6UCm8+c5nFsqRrHGeUMj8YraGCWOOu4SYdspxYvjaj5LzQ0W
	rbTjtxK8DfuduoMntP0tdWwHQpgMCWjSEJ4pXn08n/jY4GQAx7c4rcC8LhmFHJp3t/N8gV
	JSk6wICMlQY2dw7DiYHOeSU+oZEaBRo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R0CIZP3h;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755363369; a=rsa-sha256;
	cv=none;
	b=Uo0JHIRiqKTn9ttK2K3KXGfJZDIjAMkh9JPAd8NMlsWg/9GUGYd+6Pmzcx9WIoGOSl0JFq
	QYFKf63k8NdK7dMHiMYuHe6U5WEqd9gk5wt6tePRwTd7UF4ovhGXIIkf/y/fYmr4okVhto
	1yI+Y6uN55ayiKYC6NiI3E05/qp0us0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CDC9D45AD4;
	Sat, 16 Aug 2025 16:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88435C4CEEF;
	Sat, 16 Aug 2025 16:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755363367;
	bh=v3c00vABdRpksOJBgZaWwWtGx/wcPhBRtyST+3P9e6k=;
	h=From:To:Cc:Subject:Date:From;
	b=R0CIZP3h74gVXo0whJ9net0psnUn5uiaiskWOLdiTuTMkr+HkWuLuRqMXmZxaJrAQ
	 AKeTdsBBznAhFd2vxOkEdWSXqI5TxCuvo945WlHaxWOhuRcBpFw9j+60V2x8k5PwGE
	 v2kcx/zdhR2VCxqsPGdvZeXYs1/x8BiYvot/Oe1gFZEryqu0pMzBU5qUI6CwGFuWTZ
	 eaE58FT6wC0izKnd8ipPPlNzZ/xo+ht/IQBeFbgzSG4uEKdn3kJ60GH6gv6N5gACy1
	 ZNNZPA4MbOj4toljR/dVrwLT2BkjXbRgdE1PK6h2NXUgfFOnucViBzQHxmUFTYXKAT
	 kndscDg3hdtTw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH] mm/damon/sysfs-schemes: put damos dests dir after removing its files
Date: Sat, 16 Aug 2025 09:55:59 -0700
Message-Id: <20250816165559.2601-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D5834A000E
X-Stat-Signature: t1z1t76utdoyj8tmxu8ct7qbmu1xucy5
X-Rspam-User: 
X-HE-Tag: 1755363368-518170
X-HE-Meta: U2FsdGVkX199oCahBA/zUdRt/04KBAtEf5SBRbplEMhs9MfdK3C3hY6HLztn4q/+NseIHfiSA91oV6vg0GEt42gBgabZqHiJcFACnvAaexHbJl6z9GN0dSrfzP/84Ae3nSF9DxisZUwXLePtM5Uq/5XFW5haNlthV7gB/OXpnGtg07QGB3BA3vmVAYptvcz3dFD6Yu7BcaU76ygfvKC17Yndz5+cvHckom3UY3jBh6yVp0dL/OoEwTd9Uawx6zF4VMBoFVOBCzZiRlCiFLaooplGcO/LFtZkqgS7NhMLXZ25XbM5hy2Dp5k3EQJiiOOfRKdjrpkxGmofnIroRDZvcmP/27l+KZzpwgjcZ5mMD4R1AZRziUaqP/t9TBB7fYpbcA38H7gpLswJJWugIzSY+ySGJMj4sNj0uVFs+C1fUiUIYDr/3WzyeV8oaGoVRGn4Juv+XpeOB4HhmrxEemGaS0Wne7CfvKUOmzObvEvSzScuK7/UCov2QSalQeLRdC0j92lQx8uVbqUQ0w6WmthVBtKkGqC2KNJ9RNcFKXUW1n5MMF20bZ1vFHN+4BbVthsmql9SzNLDhoz5vu7uDQKcbzuV0q53fP7WXDblN3+AEUW6wY8mjrfaKdjKZrzGU1x9+WKPaEAXa6Hmgd+pnFy8nBUfmE/O9XK8g51AH53by9qKoxDsdXL0kB7XZMSGq+FE9xfKMMbaPFypNfrVdut9EXSel6RG1zIrO0GohiRo3QI1rcAZnutyBGOha5ts1YqVVirub93FZ4KbesbjPeOKl6nD7Z7SGA2DSsy1xX0oDQDyKhskVDnuuJYchGBYs/1cM8Uu0nMwh92ZjGXoFq2XcgPeCW9ahJWEUXK/t9GYOt1gKSu9NK51kwO0vGPOqPs20HKiFUrpFC+KL3ioeU0W1zgbMbWZ8v3HHnlnlJLHgKRNsIZ1et9TO3q5Mil2aU+OHUP4772q7pNqr5Oedvl
 2XiapcCf
 tihzPwuwT8KSHa4r4fqVmFIARhNGkYQ3UEbc+m+5b6+HUkukwr8/KVpfK+s6vaW0y0ICxziMy7zn+dDdChRKB8VbgwJZwCFiDLIwepe7Xp0FoMx3Wi7811Ze6lAb3OahjoETqXDXvbC8q0TXUC5E45Shj4BBrTSHyJjDzxqIjv8qp6ZF6InAywf0jgPG5ABA19Na4uFaoAVHKv4ojW6RUZRmPvWwuQQ/WLSwZiAngUZ1/5gM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_scheme_rm_dirs() puts dests directory kobject before
removing its internal files.  Sincee putting the kobject frees its
container struct, and the internal files removal accesses the container,
use-after-free happens.  Fix it by putting the reference _after_
removing the files.

Reported-by: Alexandre Ghiti <alex@ghiti.fr>
Closes: https://lore.kernel.org/2d39a734-320d-4341-8f8a-4019eec2dbf2@ghiti.fr
Fixes: 2cd0bf85a203 ("mm/damon/sysfs-schemes: implement DAMOS action destinations directory") # 6.17.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Not Cc-ing stable@, since the broken commit is in 6.17-rc1 and hence probably
this fix will land on the mainline before the release of the first 6.17 stable
kernel (6.17.1).

 mm/damon/sysfs-schemes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 74056bcd6a2c..6536f16006c9 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2158,8 +2158,8 @@ static void damon_sysfs_scheme_rm_dirs(struct damon_sysfs_scheme *scheme)
 {
 	damon_sysfs_access_pattern_rm_dirs(scheme->access_pattern);
 	kobject_put(&scheme->access_pattern->kobj);
-	kobject_put(&scheme->dests->kobj);
 	damos_sysfs_dests_rm_dirs(scheme->dests);
+	kobject_put(&scheme->dests->kobj);
 	damon_sysfs_quotas_rm_dirs(scheme->quotas);
 	kobject_put(&scheme->quotas->kobj);
 	kobject_put(&scheme->watermarks->kobj);

base-commit: 9aa69ba9d9e220ea1d8ba62592fe7ffba376b2cc
-- 
2.39.5

