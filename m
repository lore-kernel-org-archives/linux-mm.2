Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B87606A333
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 05:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kj0smSbf
Received: by kanga.kvack.org (Postfix)
	id 370CE6B061E; Wed, 28 Oct 2026 01:11:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321246B0620; Wed, 28 Oct 2026 01:11:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 237046B0622; Wed, 28 Oct 2026 01:11:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00A9D6B061E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:11:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77248C025E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:11:16 +0000 (UTC)
X-FDA: 85370861352.30.75B3C42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id D5149C0004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:11:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kj0smSbf;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793164274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUbseAYEE+G1IqK7aQUzVK/2OJ86R8Gy/7HvczyR3XM=;
	b=WDd2dGrirHegvf1RNULTeYckgTB9xJifmCWdvC/RVXV7HbSKzytn9SArC+NOdOTraxKBIH
	ISoqy8i4iIJYYeOvb/1szRZ6Rv58SMq6tdFkqciIl4oejtC6w1nxMTMYoajKaFoXxqhdPF
	VCFrrJ6+BtxySyN+AlBxPqpFSIgLd1I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793164274;
	b=QIhzXlmg3AKlnaSC53FHUm8BF+3M4C+z07TMvnwh9mpSA5ae/6twwtcc4HSkk3ExPMtelJ
	AAM3eSHDprywsC10zeu4H5bfjI0O7+pNS2nF05lysWeIZb1YUT7yXADftahDycCUwwRjw/
	/O1Np2dYFaxWJZKzm2zlDvuSv818t7c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kj0smSbf;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E5E5C43D5D;
	Wed, 28 Oct 2026 05:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E22E1F031E1;
	Wed, 28 Oct 2026 05:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793164273;
	bh=DUbseAYEE+G1IqK7aQUzVK/2OJ86R8Gy/7HvczyR3XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kj0smSbfq765ieYkOtcDNKd21m74Hmrgr9h4jcU744iWhuoJ1yOnbBrSOso1/1DPR
	 Ra5iRzvNxojssI+OjwgF0qYzn/xHQLvquuKVW7yUskugHLlEw0wh8ny/eqLSfGBLTF
	 nbvjfhwZp+4GdHwGUjydfITMVQNO/CJrovr2mQkjfe2r4ZqOcD93WNGxYBwJUff8LH
	 uPW+lAI2IqkPN0CfwOy4P6Sz6W0O2FiLBITI7r6RzPoqQ+5Bfl66eqGDDUgKhMlyiU
	 CHfPcVEM4RyMzEJpxRoomp4o7IGm5NOoyZSUyi1vOpPawVWceFme2fyWe3ZvcUAlNy
	 qZoaaWZEGJ+IQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.1.y 2/2] mm/damon/sysfs: put target pids for apply_inputs() failure
Date: Tue, 27 Oct 2026 22:11:03 -0700
Message-ID: <20261028051104.154232-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028051104.154232-1-sj@kernel.org>
References: <20261028051104.154232-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D5149C0004
X-Stat-Signature: zzmhpdgiycd196w7ho9tfcnb4u95wczh
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793164274-933824
X-HE-Meta: U2FsdGVkX1/5aot3+RTM1njXvCfLEhIUtNkYrgfRYJRR3yrKqhk0v2I7Bubumy2LUTtXsNwqUxiPwKxQZ9SQWVFePhPUI34xcvDNK3/KkT8rOpt1YDTPQSElF+gbOZ/w7Fz2yeyWDS5G8vgy8ZpB7RsgOHvKaZSYADbT7KRMwu5ZAPEpLoA9TjVlbtAYGks/EAQLdw83N03y8sshT5yzIAAN8YlAJiGoLRghYXQ8AHZAZsgOOjA+/oylWVVeVTQP11vMTqYxjGV4J1WFYkulGwk8RLm0He4lfrqiFW4PZtkaBbW/vLpCft5e6nK3lj1iDNEIJedjUDNR8XcYliGqC75W1NBCydM7+MZ5+nh2SJ1/b5opPzGhP/eo97LEDpcGejtXMFKHO3u+IDr9qgBkb0hEQDsQRYcTaN7VWDGynoLTjarsuv/eV9ALV+ybTdQyPkiRC/4oRwCcNWtfDFXAjaVzAPh0QPMjczyTBN8/o8Ecld9pkGy5NJ1u73cV+C9kK+eWx4J+xecsoi3+5bEW9wyKqWqJHVn+vJ7xiAfk47YLZhJ5jQwYDnyyUuuIpXUnwM9O+6k7z5+mxvf5c8KLCMIdOog7MdBnrny26LKY8RG419UPnbyBHh9wu+faNB1s8Zaeee8tYpE8nHH230wVu3mcTw1Rby2gcOt7K00YZgaayPJatfSRCCy90R7/xoeBq2nBgQRP9qR0fsEQU6fSVa5ZGNKAV/zuQPqNzRS4oHQOVHgwRvi7oWppqGa3TnQxsVqoJMbJzBTq70HGKk+avxYCoqmyx+zLjYdYZEoJKXiM1++BVG7dAvUlPmdmAVM4pFgcD5vq7YKYAbUxX/WwL8tgV2BW4O2wO3kXnQ4YFFUyBuHuBxaPrdAVE54jWSPs+l3s1NG/ZLm83nti6g4xOBXgzesUAC3PKlF5TFosf3CkWKTkqHlVAecwuStAYZvSoXHjtqK8AkdCKtjOxd9
 K6mJTP2M
 NT1nzvtBwILAIqIpg8BYdcf6hrYZ8LPlY5Eep8wD96uc955PfvA5og6PyFYGs/b0ItcAiTcP+uDvymrGPJTXmhvUTvPgZhVkrXoz4Xo32khQamhwmG/j4PwCY4vOt9oh2zVvqz+RIAAEPIp3MW7LYTxm0fdNVKq37LmfEsrfa9sdhH73GVaWjADVGqfyj83qE3Tzqjm8YzB/i+hhbfglj6fufIpWjkXl5zDBkwzTHqbXCd7pQ3pYoLLR1MqpxEAQavoVR7/C6UaSOaMx4nv8WQrg5kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_sysfs_build_ctx() invokes damon_sysfs_apply_inputs() for setting
damon_ctx object with user inputs.  If it is configured for virtual
address spaces monitoring, the setup also increases reference counts of
monitoring target pids.  If the setup is failed, damon_sysfs_build_ctx()
deallocates the damon_ctx object without decreasing the reference counts
of the pids.  If the failure happened after increasing reference counts
of pids, the pids can be leaked.

Fix the leaks by decreasing the pid reference counts before deallocating
the damon_ctx object.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260730040740.140836-1-sj@kernel.org

Fixes: 74bd8b7d2f8e ("mm/damon/sysfs: move targets setup code to a separated function")
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 4b28bb9ba0a24..b9b80d58e5bd6 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2515,6 +2515,7 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 
 	err = damon_sysfs_apply_inputs(ctx, sys_ctx);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return ERR_PTR(err);
 	}
-- 
2.47.3

