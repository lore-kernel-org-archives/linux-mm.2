Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64D88CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:05:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E6B6B02E8; Mon,  1 Jun 2026 05:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CFAA6B02E9; Mon,  1 Jun 2026 05:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5236B02EA; Mon,  1 Jun 2026 05:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB506B02E8
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:05:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 488811C1DE9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:05:44 +0000 (UTC)
X-FDA: 84830761008.02.F2BB6EA
Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	by imf10.hostedemail.com (Postfix) with ESMTP id 41D71C000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:05:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=AemEIS1f;
	spf=pass (imf10.hostedemail.com: domain of niecheng1@uniontech.com designates 18.132.163.193 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780304742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ea62rNturdRY4XhPqvTtukJW98iV/DZwMOLJ/F5D8vs=;
	b=E1GfeTOa7nohb2AjwCnMQJ5/BeKzpKHLES4M6ZTUobeNf6ivbT4xBJ9Gx5lTMQLZXGVz7A
	VfKjzvQO6Um/67REup3FMLZqb4XRkFWY58oa0nPXK2UnyNYn3tqAO+3Oeojp78b12BAKMd
	I7Kv8HkPCnTXfm4u/Qw/3wnt/BkLLmo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780304742; a=rsa-sha256;
	cv=none;
	b=1cApGZ4wa7y8Y6ZMutENH0Ekv8O/rIVaT+b22V2La1z2QsSYkmhieUkEzDygS0tTMpJd67
	mRZI5MIYF9dTyAdyvU2BrWOy2XWJzEbL9sDbWEnkNNA5/9UovAaIZ4KtWTyiXJKfoVGSFt
	xv12UwtghsqhHHr5KNXS/Pp+aQ49cuc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=AemEIS1f;
	spf=pass (imf10.hostedemail.com: domain of niecheng1@uniontech.com designates 18.132.163.193 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780304732;
	bh=ea62rNturdRY4XhPqvTtukJW98iV/DZwMOLJ/F5D8vs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=AemEIS1fhNRLY0jn7BjS7V9hm6q/gb1WBHf/aYfDQS66JWDk8dYi16bhDeRgalvR8
	 lkVvGz5xcPXqODKv5n/0RlAAAIjHbm9K3XAQ6BSqMlc1KEqctiJx1oy1B4o7ZHkpu7
	 VvXMW4I6cYQg4rgFy6qAG3JdWRUvYbek5iTB6cX4=
X-QQ-mid: zesmtpgz8t1780304727t4a62472c
X-QQ-Originating-IP: 2bcxmMbH2iusCaR5Nzg0f+ovlfhyFWqjrzOOczmEX18=
Received: from PEN1097 ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 01 Jun 2026 17:05:25 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 41246512580462291
EX-QQ-RecipientCnt: 7
From: Cheng Nie <niecheng1@uniontech.com>
To: niecheng1@uniontech.com
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	shuah@kernel.org,
	sj@kernel.org
Subject: [PATCH v4 1/2] selftests/damon/_damon_sysfs.py: fix memcg_path assignment
Date: Mon,  1 Jun 2026 17:05:19 +0800
Message-ID: <464AE12D4BC6B6F4+20260601090519.240482-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <7E6EAB7C1BE04DEA+20260601090119.238457-1-niecheng1@uniontech.com>
References: <7E6EAB7C1BE04DEA+20260601090119.238457-1-niecheng1@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: OfLzXF8J7RicL/ZU5lX6H/24XsvdkJHW89YHSaoLnS0I9im0Y0dG2Z9j
	EA4sHOksION396oefkjL7N3ihF+xbBnzd9hGoHKefggKJujqurYZvQEKibLLtt3yzvZqXJS
	q5K8kThs6+M5G8+u2y+d8P+J3ZHc3NM8I9R0AsQlCtqDKzLXQVGDk3y0e7DuhjBFwlYmSpZ
	FN6Fx/2HTMKaV+Cgn1zzUCDo13uKxlBM6zWeVaiIczE8i9Ynuhjl6Azb+n6tcRXMmRhtID0
	0TrEZXZRrKlI4cWZlyM3IZmpt9+hQwbOg3C+Z8euefWAh5I+4iECq93x3iBZlPkMThcSDPb
	Dq/qCj6UD3Y7sc3mOlSBSqMVe3tgLDdsUNsN5mXSjB8j76F/rgjLljhQSs+Lcv7qrGfJRQd
	HsPIxMwtGfkGs+V6MnTcpsmCng2PrSKf90h0RGTIYxuSzMmlyhPKnkB357pw5YGCRgJIXi5
	yfPerX5KzEydoboaqFt2DP/NDwgE9NYgsSwf17yHr8rXGJCNr+CLLCQjf6cCmVSiKbZjt3P
	GGspFhhr2L4+BmV7MkeMrpZCoVH58FtWxjKwC4taAjPJJCiqe1Qi554mjQbvMkEjj/1xLgG
	X4TdpD6+ueK4vpMAF0eiG0O5mVX7rA0HPPYUkh8z5ToO+DkfqY75KRFaRd8mIBZwcES4b9J
	0g8tpqUxZvapoEWoteFa+myMgpB6B4ZaWFOVccOMyS/FPnMFge2IjL3uWZUZmj9Mj9dsFoK
	0gpmyUmqwkcnu3jgU6T/zkhnkgI3nGBCGr1aFLDZlDwQVo79WG2iBkzWRQTAIb8QDDse2sC
	x2oYO5lXQ6vowMjZFOdG9LB/g4OMIHxHA92CIzcwaNpp0u7b3pBMLIXJTBoeae8uiGZESUY
	Z69YePUo2HduZMp5+IbDTB/3ayboLzJ+XXKm2A17v8+IdzqF+7sI/YhRzkDJwk0ppM9Gd9E
	mN6jAaNyH0rvpnkzGxdtqr3EMYdeNc6HzU8PqYiwSfQIOQq1RXrzKxnBOay8aVaF2L4NLh8
	LbGA4oOajEjLomJiAfdfqEfXJRa571zhzkutV42N2T6H0/fb5izQSY5aNrHUxSXN05xYvXp
	HGuRzo67OubF4tpYPXL2OTJK1uBkAvxV2QGslHFW9NQFW0TkNgNBSVmQAgOQO1ccQ==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Queue-Id: 41D71C000A
X-Stat-Signature: ginyzx9efrnu7aew8tojx4g51bhrhxk5
X-Rspamd-Server: rspam06
X-HE-Tag: 1780304740-397295
X-HE-Meta: U2FsdGVkX18f2x9pNUGu6X+0n0AzVHJRBhw7E5DPFolaYxpyXAzNd9mhBc77N/Qbh9yPqukSXMdN/U+1V9sZyC4bh68OO5UYMBfw/0HDyDgDC8sEnCuDZnxvhkxf/NY2eex6WUKpiGJF/z1IbiW1VaRMGk1Uh6wGBK1fGRm6hp4UgxhQ1xSBlqoSTuBAKAlZA3wI72zQEe3HY/PvylyO8auZXlA1oiNi7mG+3UN4U3OzjxClhkOCEJOtgGU4nmQKaTeR7aa0+oScLh1NTwBAJVZAebCsUKiTVMacGqziEBssUlY5z5dNBp0DPYwM47/OHSJEJEF5SR4nzrZ61MKGTgXatQ9G3tL/Kw1fF96olr2dS+MBbzMdJ3JymFJKH89tqoQdJ7ducHwi6PGfxAAMlJ1XRNZYddpe8Mj4xbGSqtiFv8BKzkb4je2k0pvLfIdN8XYYdVVaIKIY1AEy4kZi2IkStRYsseqCTCkkOb61RMxtd7BCqavLg3iCv7baW11EojCVEw1HYY3YMlTOB0IgjHiBdxpjD2Cp21N3i7+/w7gVEfwnnF0SpLrrsxEJ8yZPgCZy6hshwaXjBk5QmyppLNUfaY9uSN4dD0WbsuS1FFfaKBdZEffRLxwy5UwXtUgFE+aZ/PaI3QJIlYQhYEYw9oT/pDISKQBEnSP8ugj9P6HsUp4bz4zwVwG0Zxjb00rETPoRf4npgIcPAv/JRtJflR4HhseKBlPOtct313sIeLDh7K9E2VvE7yX5aFjZLLCEZEMR+WqZqh3XGPESNNFvDoz0v5WuHYR4nLokPvVPk1MBkVkGCnHXb4ioQG0Ph+oOugF7uKo8zxOlnI4nmzZd5KQ2XRQRDikVphf6cpT77LGdRiaMnohtc4WbImWGBOQqyX/gz8RN/0dvH6XEhPd/TXhQzREmyj5V07YDjPA5X95udNlLmTMl5RQk8HzAEVA+BOf8+S98WJiiSufjA8Z
 SXkZHPVP
 tSUBj77TuX6hyVwhyrACKg9QMC/4da/kDPSj4ASBcYjR1rFu5ftUXcUFolLS7gTNOckfhVgcHdHufu3I69PpMw53bqwTUcW+X8zidtw2MWmfbuO9GBeCrMoE1cahKeCI5kdo2Xg2/gCLg9omSOxcM02lOQY7L1gLITWnIh15Q9wYdwa75g4aYAQJ24BHKrKIOd3Spny84ZN7CgPUDc00MHXEcnxk7HvcyCotGu+2zzkg5WHDppVFiEKctujVQ5raHotS673X9nlNaC7QCRZ5TOAZBqhfA8DrCPw8npNpwmSZzm8vYmYJatmLo3RA9X4ScW5lFxV1rQ85ZFDOenbJVd5BTi+JHky23kPn2PWFGYyhUWtHaJqmtl+pli7wzgXRGki8fvwZxIxSWQuGDtVYL906BHYTi4WDbi3AIZDrQy0GfuK8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DamosFilter stores memcg_path for sysfs staging, but the constructor
assigns it with a trailing comma and therefore turns it into a tuple.

Fix the assignment so memcg_path is stored as the intended string.
This makes memcg filter staging and follow-up validation use the
written path correctly.

Signed-off-by: Cheng Nie <niecheng1@uniontech.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 8b12cc048440..43075892215e 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -271,7 +271,7 @@ class DamosFilter:
         self.type_ = type_
         self.matching = matching
         self.allow = allow
-        self.memcg_path = memcg_path,
+        self.memcg_path = memcg_path
         self.addr_start = addr_start
         self.addr_end = addr_end
         self.target_idx = target_idx
-- 
2.51.0


