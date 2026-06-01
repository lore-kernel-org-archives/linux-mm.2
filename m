Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACC28CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 07:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39B96B0092; Mon,  1 Jun 2026 03:43:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10866B0098; Mon,  1 Jun 2026 03:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26D16B009B; Mon,  1 Jun 2026 03:43:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1C796B0092
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:43:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D94E1405D8
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:43:30 +0000 (UTC)
X-FDA: 84830553780.26.162245C
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	by imf28.hostedemail.com (Postfix) with ESMTP id 46E27C0005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:43:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b="nUjIU/Bu";
	spf=pass (imf28.hostedemail.com: domain of niecheng1@uniontech.com designates 54.204.34.129 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780299808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pwZkHXqKqxkxLcfcppEkvJjtNsDiBPN5huDHZl9Eqqc=;
	b=KmaFtRCBXoW/VrQC6nTZ11hG2NVuumeXb5zKS4Q71oh2Fn0jMk/9RHBHm4AUWGlWrrYOzL
	ocSqgq9AUnJwltUgOVSBAwrmOeU+56J2oE86fDjRcmTKjZseNllvHPChbj+75OEMAKfVPM
	oyWIMMHraGRBOV0Y4CsbUzcvQWa01v4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b="nUjIU/Bu";
	spf=pass (imf28.hostedemail.com: domain of niecheng1@uniontech.com designates 54.204.34.129 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780299808; a=rsa-sha256;
	cv=none;
	b=dTx0e/nRnSM184VkP5eTOrjRM7kmBRXaT4Ka3Hbaf7CFiN+9fEwOA4fSBjxDmNTfhlmD2R
	IxVF+YaPsIAkmyygCQebsVfEcxbf1l5F4uDjMgUoJezWGMk5dNCl7xvOqLsu4QVFRLu9d2
	cVc5dQ0opRphLcaeCppsP54O9XVMV6E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780299789;
	bh=pwZkHXqKqxkxLcfcppEkvJjtNsDiBPN5huDHZl9Eqqc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=nUjIU/BukiOGcfae12Pr28aUl+p7bkLozg4sxgd4o8ZJiKyDFujVZ9Zbcst6Rbiqd
	 ojTzr09SCiQ+fQxkV8GgnmD3zAABG2cYWj0j0rotDcLRB1BxTq6867r73Y6JbbzEH1
	 wQhQEpeH68mdJ8fidJc/4E7ZiJkCmAiRYNPyL2fs=
X-QQ-mid: zesmtpsz8t1780299777te9dd8a35
X-QQ-Originating-IP: sj9qZnDxjOiHmc+F6pDsHm4ywVs4+jfPh2wpfeznSRs=
Received: from PEN1097 ( [1.202.39.170])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 01 Jun 2026 15:42:55 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12067453659540289926
EX-QQ-RecipientCnt: 8
From: Cheng Nie <niecheng1@uniontech.com>
To: sj@kernel.org
Cc: shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel@uniontech.com,
	niecheng1@uniontech.com
Subject: [PATCH v3 1/2] selftests/damon/_damon_sysfs.py: fix memcg_path assignment
Date: Mon,  1 Jun 2026 15:42:49 +0800
Message-ID: <E4B88E7D4879D1B1+20260601074250.203583-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260601073635.200015-1-niecheng1@uniontech.com>
References: <20260601073635.200015-1-niecheng1@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NfCiKUdyqwvYVH7Nc7tPkOYzQ0ufTexoNNJxrhOV6EJBqROmP0f/esBV
	cnU3lvM4a0LZW4zMD3rZ5hClxBlyP7/RlocgN8MaMriPHpp+mkxgx1NSXDPxFX7rXxmwnFU
	X/CIl/Me+0njusvVMgeko0kI73Wh2L5NrcRCisNDJ2SHH8uMinXsN8VgPakUDUzTjblnHPe
	tt4RSH/aScOrPl+21R95uhh9H53W9En0DRr9VM5yy1zgXm1DhRyLHLp8Fb8o241t49bfN0A
	mu6DE/sTxJ8RLJODwQY1Q9Ok5Q8vUGaJvr3zZ96xRpjnGKhw2aMapxk/nvu4w9thY6L+/j8
	SxQ0YCCPzIFRpdUxUlQkjxKKIDaCuVHf28rN1st6OO/rd7RN0/mjjp+2pYaeP2v3qr7l9jL
	NSyT3ATCGm4wyR7pIjvJgQtck2Q0+ElMtUJsfztZ2OPqz1UmasZSTauzU1tj1ULap31lVmv
	FpiCr8bJuaJqQDoppqEx5DgUfwqKbVMmsyEtisCa5QThxbvmi7gktdT8DdQlZeg1xYL+lWg
	FreBEiw/UlOVIuiUHXYikF6VjbxSbzV1MdntIu8I5k6GNrWIxmiPdpFD//qhx55RKyZth1L
	Xb0YMpFy/e9Mzc8YUws9NaxcP99yKKNqziJ64YUPGuPL9FSeAR9PAOGwyP8WeZXM7CqGY4H
	Z3w5vky9JDtPXrmsaBhFHCxoecpJiRDtBnX2/+f5fRmfOm03vz4Z+D/QbeLyhh8vkRB+68v
	u6+0VeOplNEit0VuWgyRDMbMZtZEdhGcuND1bIvqpL4KH9sWHEUb6/TKkVkhHnfB9DI2CCi
	7k/J03vYOulxKZa2KFZm6FQuvcuumAhjcK0+//a4Sbjl1AMsR2a4YtbWF8uUU2udOfAMdzF
	Ga+ghoPwcindFrw8lAaa6AVFvXOefrcFVd2dhXXfmo3Fi2MU5f197KmwGgsZPGkenefm50U
	U+It/df0E++OIer2ttaRZFzDFrDJDpmU4peboFv1cpy142VCxzNdhIGrPIWdaGd+7QRCPIO
	ja8PPlCVF2UMrmPTkp+QtYpe7Dh4w78xxPYpejWEDAuvdJCXzNSGn0Ze+o3js=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: 3ygxcdt8eei6nqte867sfgaky81n7nsn
X-Rspamd-Queue-Id: 46E27C0005
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780299806-860207
X-HE-Meta: U2FsdGVkX1+ByIZGe8pY65JKfKZA495u+GWqWTRclu53GgAYlJPJqG5w5GVA03IyOYsJy9+kLMHbdLKCGV2n01RQmzcB26oX41HCXWziW5V3NrK+/ot/vjLKjwuH5B1cjf4bF3hM0x221Og8TI03C4ZS/Y+jQQSIw5jsCTjRg0rp9AZGTgXshANcMqQlCzJhNP0yn5dr7XgA55WULz1eSk3QB7cw5UeXuMSDI24+O8ZYZPpQv69swBjM6+V2faFRm7bEiHc0+UkFSJbyvjTDnb/gBp8+oMJJiOUHXtfouqXAJkHly6169E449axXkTn4mU2yg2uO7CnQOVSqcUEBI6OSSsRQS6n12hASXz5XynhGZ9eAkCBC9gi2bTl38B8AkI+MmDUjd6o+b3IGvJTZ+u8899qbwbLn0foq0uT1KawV43taRKaiGAoM5fEw5+GjJ+YN6hijP4wTqqMp9FtRIOrklmSutHBq3ciaiw+6bIfyPNeQVfKcd6GzybEB0nRS2MlHzgjobACIKZwUVRrbQ27CleYMAfeThzgN0vxqzIQ32i7kGJlk/79fZ3uP5ulqoRyDzX7IcIvVwzeG46hVEXN2R2E+Ur24VPgXcSQVEN4tlGbf/IVSfngtVvonNYKMA8r/RX/kC9C48PM9QmDz7Lxt3NTG3dBpus6HkbFTrucLNOofvKkQ2LMnwFIZqGK7jzL7ihYooLqs76AaR4DOpddU5MIfs391vXo/UEyNA8cOYDMHHjRIFPqwnMOE5/4XOCeow+ruxms2mKaUz7pQOu1XXN5mbC/uvQW15zqdYv30g/ajfLqALRqLutyY6ZdkogBOwJsK+i/uE34oQk18RKpiJxwijFteZw54oMC0weSo4sl4oOsJvhN8jlGKtJq7s2z9LezrRqJcqwoZF6REIALjBbAR5u7Tk1hB6ZybagAZ/Xk23YzUVnqy23g8xd8gpYjdoraldHCguMgMiFO
 Ca4wIIKD
 xIagv31VtHItUlVW3o/vjNC0sws/4b//7PExJ+hafUJRoAs9DaXMy0eTUZRD5u5YH9Dngx6PwnAn/JS83uHnxRuNiBzOPwtvdRGS45WBTWx8epH/VGWT+h8VLmG5wSYXA9ZmJ3cWspUb6XB8QLhRVIYNispDfMBhn2NoBBjuOhCFbGwAbdbEM1ohbsta/ndc0ObzYc05ChrtbIWC2cgzqWblK/1WBOuPxyKUN0kBFh0NrRSZvlr0g9JQQlFp3JvDT+MzIKKYER+XsazluafUwe/hn+Uj8A6nBBsgGFsAUYp5my2bw0jUpJ2S+OiEIE5Ef8dsCauAEkxaG0nIJpGE7052X/+8xDOcI6WNQkUWCUV8RId4Dza3o+wsSLEasiC0D31jdmAGs0uIDk48=
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


