Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE6FFCA101F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 02:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80016B000D; Sun,  7 Sep 2025 22:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30898E0001; Sun,  7 Sep 2025 22:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6CFF6B0010; Sun,  7 Sep 2025 22:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7A896B000D
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 22:40:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8DD9711B02B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 02:40:24 +0000 (UTC)
X-FDA: 83864529168.01.2E60DBB
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id E71F61C0006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 02:40:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mA5K7eN6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757299223; a=rsa-sha256;
	cv=none;
	b=rmr4lzWJIXJYehldjAgMWyjEl9fncbOiQ4QmZ1F0e3yozuNkqM3WQTlErPQj0kIO95NflN
	m6o9Yhhb8UJukhVrL41AnTQUicgAZNPxzf0FJ8zxgKlmS5YJkgLabGNaLP6oDyjO4/45Ed
	l8A0bt7VaUxexJbXnYbfqdajMi4wApA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mA5K7eN6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757299223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F05Pyb/PPuwSrMwUArE1DpgL89Fb2LA8TTTDyvg9QlU=;
	b=iIS8A2I4cQCB0VWu2io1sEaJK+asPEoTzvqQTCavgyWnfDwBb61eag9gwBix79BOZAVja3
	pu8dKi/8p9NZF/M8Zr4BiiqQHZ5Tui1IFQCcGMpBB+v4Ls/r8xQczi49SHf9enSHq3OouO
	795oj8BUkPRtdxBjP+QSwnpx3G3CPo0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757299221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F05Pyb/PPuwSrMwUArE1DpgL89Fb2LA8TTTDyvg9QlU=;
	b=mA5K7eN6CSGnj975CFEr2X3wpDGCOCFa/TLk5K07it46WUr5PIqalYHlAsMRCnBn3mmqFK
	w2gAtfWapxBlXSy+aDC9mLpD5MkYlFjOBxZrDhmzxK2khmgI/MKJdDGp1nCvtVnn/nrcDU
	2eWeK4R2A5Bv8kYrX1GKEKYAI4IJa4w=
From: Jackie Liu <liu.yun@linux.dev>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	liu.yun@linux.dev,
	liuyun01@kylinos.cn
Subject: [PATCH] mm/shmem: remove redundant entry_order variable in shmem_split_large_entry()
Date: Mon,  8 Sep 2025 10:39:15 +0800
Message-ID: <20250908023915.28907-2-liu.yun@linux.dev>
In-Reply-To: <20250908023915.28907-1-liu.yun@linux.dev>
References: <20250908023915.28907-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: E71F61C0006
X-Stat-Signature: x478nrrhasbngqbbxwgq4ki7iasg8m4u
X-HE-Tag: 1757299222-457985
X-HE-Meta: U2FsdGVkX1/S9uKkDwC+EiYlKVbe8k4qp+OneBTwB6C6NFdK3MX2Qsd2f/mhdvKf89bGtl8fruyGvsZ0RNRfqtICD1oDoiuBJe++tHxcAsX3kHLirnCvSn9b0+X0R+zeAm8E6/c34lZAH7kw5TO3Z/7Y0Jh7QNGtnxqv9D4Nt9ECVT+9EWgiN1QcsV698TQ8FfJ5wZXghhg9pHoL7+gTMvUTstoP2Ss86UmSIouEW7ZXV05KEuzbcJCRS+1telfX6IFzDU4VccpFDQW2pvtZ9Dqz+nr4X3fLFhDbFpgc9klC6b8vDTSE0Mw1LQrZom4XOg9EtABLssi4loSjQXAaIJC7qiekirGnZ+hd1Efs12pSjZNT40Nztgxix85m6p9jwqvOEg8DqP5eHqJoxGLMYbtdjqd5xjkjppVm9cHxhTQhZZC45WBgF1mWOYju1kjwRAPf1cvO2xdlA91zcifILOZCng123/xAgOE8d6GfjPHvEME6ngCeg8+EYmrmWZLwdpHAcWOVou+x1HGbdtTr8bI0B6MZS3vrWBNvg6XnEur8skubp4DjzzGnLmvPwtDuSyG/UYp69k7bh3UbHRhWXzzF4Gqx5C0xqrL97mzk7VrhLFqDfXP5GQToWTm2VEGKCUgN2MwtO7CydEfxnjcGwA9KA4RsIGwrXKPKR/60yXbEiGvFCimNHI7onmq084RtXi7aHLtiFHn+XUYUfTNFP9PC1p33gCUTMBfC0CgHPIf/4NX92KQGsGcoh33Wih7kOjvMq7Bt1YiGmxjVRuCio1yo67AcIorprIuS3gh5qYpPPK1AU3LGByL1HERyCLv/S6/Lu8Bb86bOpoml4i+x2aDhOvezqDQb7TrRYAOS6jpbR/5uu3rspZJSIhGXc2ikFvQL3ybJQ8DQBcXqKv1jJfvdnJ1F/CRPammNTNs8DnSM/1UeHkrDMtQfWUEHuC6lLJYfiy9/ebZTqQy4J56
 aDdbpzVJ
 F3/FxCZ0/KQ4vfanotvWCvXAW5/Sa3ou2xLxEUReJv3hUuGRku4tI+6/KnVeIzbmkyCZosjo/EQzyZYBsIUHphFoiNTMHQ2HBLea+4H7rd6UOl4YwDnT716U7QlsjQF+hFjO4LiyK1Nc2F6Ur9RnDM3qe0nkrRFCRWqwo6ryjQOu7m/l363Z9gMdR8go+Bpo8L46SNhCwLm6YZFZU/M1w9eprjw8OG1H0/dD6XvUgX0aGDX0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jackie Liu <liuyun01@kylinos.cn>

Commit d53c78fffe7a ("mm/shmem: use xas_try_split() in shmem_split_large_entry()")
reworked shmem_split_large_entry() to use xas_try_split() and simplified
the splitting logic. After that change, the local variable `entry_order`
became redundant since its value was always immediately copied to `cur_order`.
Remove `entry_order` and use `cur_order` directly to simplify the code.

No functional change intended.

Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 mm/shmem.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index e2c76a30802b..53d28ea6e52b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2235,7 +2235,7 @@ static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
 {
 	struct address_space *mapping = inode->i_mapping;
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, 0);
-	int split_order = 0, entry_order;
+	int split_order = 0;
 	int i;
 
 	/* Convert user data gfp flags to xarray node gfp flags */
@@ -2253,15 +2253,12 @@ static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
 			goto unlock;
 		}
 
-		entry_order = xas_get_order(&xas);
-
-		if (!entry_order)
+		cur_order = xas_get_order(&xas);
+		if (!cur_order)
 			goto unlock;
 
 		/* Try to split large swap entry in pagecache */
-		cur_order = entry_order;
-		swap_index = round_down(index, 1 << entry_order);
-
+		swap_index = round_down(index, 1 << cur_order);
 		split_order = xas_try_split_min_order(cur_order);
 
 		while (cur_order > 0) {
-- 
2.51.0


