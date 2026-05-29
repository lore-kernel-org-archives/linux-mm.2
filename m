Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71C33CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 09:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997DD6B0005; Fri, 29 May 2026 05:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948AE6B0088; Fri, 29 May 2026 05:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85F186B008A; Fri, 29 May 2026 05:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 790F96B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:20:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1879D120A1A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:20:35 +0000 (UTC)
X-FDA: 84819912030.02.3F13C88
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id CC63D40007
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:20:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=oXBNPcL9;
	spf=pass (imf04.hostedemail.com: domain of niecheng1@uniontech.com designates 54.92.39.34 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780046433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pwZkHXqKqxkxLcfcppEkvJjtNsDiBPN5huDHZl9Eqqc=;
	b=Lk0XD11jRLaqhEsuaGeXu3o7wNs1p5Wey/PK015weJ9NMHhE13QgYzqq5UYfh996a15vY8
	rBNxOzs5fiZxt6aQN5oub18PMoL1MrNK1v18apVlfIC03i5GXXILyXnpmnY8GqBZeC6CgT
	YvItFP5T1KpTG/xdYrMum5+j0b5A1t0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=oXBNPcL9;
	spf=pass (imf04.hostedemail.com: domain of niecheng1@uniontech.com designates 54.92.39.34 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780046433; a=rsa-sha256;
	cv=none;
	b=sr2ojjNZlOF6BaAEDp+FiCt2qJ1VmXLKrwrcJMHY+EBo2O8quR4+mB2OO93Lf8fvmtQTRe
	ttBuC+IxClH9N6lA4DCgIRifa1GSu0irldgrAOwS2A6mKciQf9SMq3hBZhp/IRTZZ4lizr
	cjNo9HjZx/6UfiHwoPNqBk4yYMEYIpA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780046410;
	bh=pwZkHXqKqxkxLcfcppEkvJjtNsDiBPN5huDHZl9Eqqc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=oXBNPcL9l43i+7hjlYwOT9Vzcu9sz183zszbRotKOezN1hoUFJa9r9YVXdtW5p+ai
	 irhp5lFv/99r8V34HAdpw1qvEZBr0xNuofjaW7NVA0Dnpw6g1YXmZdxwFynCgKHTsR
	 VlVcnwI2F+cSqfAKfITK+OmSwv7MyPvzGmUL5dk0=
X-QQ-mid: esmtpsz16t1780046399tb2a1703a
X-QQ-Originating-IP: CJUn/onq9sVAsdQEE4Dgz4kIeQDPJjAROSdjJs85g0k=
Received: from PEN1097 ( [61.183.83.60])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 29 May 2026 17:19:57 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8377059717619170860
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
Subject: [PATCH v2 1/2] selftests/damon/_damon_sysfs.py: fix memcg_path assignment
Date: Fri, 29 May 2026 17:19:48 +0800
Message-ID: <9EAB27169F5D0F3D+20260529091948.1702421-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <4CDA28DC581FDCF8+20260529090845.1696845-1-niecheng1@uniontech.com>
References: <4CDA28DC581FDCF8+20260529090845.1696845-1-niecheng1@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: OMCYmVIWJe6uos5vFmn6Hv3b1VLW0y7mvdHhjV+Aqw2safJnkJceOqCk
	4I0tpRTv5bjYZBZ0J/7EfDLyU/doSnAM6fNBLs5lD+UvveN5+LV7dHP5kZ7sC0JaJMQbSR8
	BcUezDcrK8W0KPMFImStnIAynQ/3XgD+Md3caTKZ69IfUoDSR2YqHXKhCM4a69MmUUH5LQh
	4LVn/TSDjlBkvdJ1X6457D5Hg5WKDrFX9dumxehSZUffMpvfiIjJTKyGC/MY57Dl5wdxICA
	lI/pCX7AwPtCHSE0CjStDl+9Eo/0oS8UFPJbMxYUPElM1wAAt6+pXTleqEySweD3pXtPJyt
	+b9TgHC1QJRha4xdbTWn+GyU9QQsfuCTmuDxlxljnmfcLcFMm8/X34po+jYA7HX9Z7gLClE
	ZRaY82RsQvEgckplIQSMYCsOw1DvHa983i51pGfKTqH7Zu7OTz3L9bRvNHcTDH8DqS7JgX+
	AK+i59hiR0/eSA8lNcWN3vCNSiSNCHHxfhAKJTUmRaqafeHEIGg1qKpdeXVLpOuorj2LVa8
	PRg/gr1P9W0YaKYi/KOIWW9sLE4R6E6xhlYMkjWMMMsBP1rsaw6p89fN6i8HXUyeZHfcnRF
	wSiPMr8yCkJopIX5bGm9WpTwlF1fTJN+ILkQpqrVJdi2Upyf2Sh0eB3C+EG53raG8WApa0M
	6BnL6IFAfxsTYmiIjE9zYw5ZPhRlA01lwnwqJK313E/XDEejCjvLQ52QW6062nM+dWKJN5M
	+iOvqrT3bHmiRbAkRbqb/OSZ9xmXsbZxZN+Hp3ECLDK4h92Ti3Aj68A+xQk9ybM7dQiwAas
	BBzCCXoPl6u2zzsW6VOYiy5hrZiHnK3hNfrbFmuh9mM1uHXwtMsPacDRwCj8LVFbXkUb3nx
	8MlIZM9wWPP/+DGnT1+DXx5o8E0My+Sga6TE1R4HHpsFPKM+m6pV9lCTZSgJZuOOQ1tVOed
	1Y8xMOntoVlnKbVlXVxZ32eCpwNzikHJg0JuQvclFfep9Tvf+Shg+2zoYC1s9+U6tmJSYge
	TBPrcqFwJmw5MJcd6yZ10tKS+nFO5MVhDG55HVg0as9cstELSGrcrr66GbHNk=
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam12
X-Stat-Signature: zo1n4pfgrrbcsead1rdwci8xicskhmqy
X-Rspam-User: 
X-Rspamd-Queue-Id: CC63D40007
X-HE-Tag: 1780046431-33069
X-HE-Meta: U2FsdGVkX1//5GiXPEpmgbksxRpJqC+azEGNkE9sov7YaYJHnLoV7Lxy1s89LMb5qsy/etqHtgNf3QmYVRoTPMQahhXrhYmKderjI34ToXSZXIHyMWKXtIF7AKZsgsWiDc225ilulyOAIJDI60/zSquZYV86MpFeGQYBCOw2yOruPBMk8z1hZpVLtZIpjrQXk0VsYaRdYumb3sPvy50JG1xvyzVuE+ay41kffQubQQBOGZIkPu9b1CqZv9OrkZE5SQ65pg5GdeUeQdrT7WCS400iXEMyfCyCsg8YUHqnrIfJPIAUKv9XXTFGU6033tCWAVwsNDm+0rUxKmZ4ovvNKT5TgKFQI8Rr4wHpDzHFBEjiphqhxiNEh1qioaFnCyT5kxedBDwr+oy1OXF3Viaw+hgkRwhYLY/UhOiUwjvW8i+m8BcEN5j553a8dn5hrSNwdpDqUx7WjIa48CD5gXf2p1a2m+67zZeMrAU0oM0vNIdAcHOy2Vf9Dzmp3/RvFckqdMYc4XEs43xp7EfLxyUdKdSYV9UzFMDsLkm00GUg2ZeKWgKJXuxDslInz74pMpV/9Hc2bUOgFg+8Siji5WD5YYuDOB6zFMtMtqb1BrfEWD8X0CPCl0T+GXxPjD1dKj7wqkGQD6NL9+qnHqxz44jI3g7HlTKPPbCG+Z1A3UuhXPJiIciFVx3UvmQ1fx2xxFO3quN7Pcj2Fz/7pu/LKUoPBs46AAUvfpS/C9/PekzauJNty6j5YbXsFv0k8nZEFGx6TE99omSKz5DtZneIopNnk1lVc+4VTE87mz03QdA7l/Tgl7rl979OYC2Gwjy8TnQYGvgcOmat4qatEzwo2wp6kIYp9E+aDEL+7vnSJl3RxwHrseiNrPg4fbXzLGM3fqTzGwsSZFtIerSB6fl8EIBE32KrhNDKoeI+fzlkToZGr7I7RtP98Wp/+CiHxoQ3uJtSV+dlW1dCaQ7hZRmYhqP
 mU1HREuw
 s9S+ZxJ5UQVgHTfsUnz0NHeOEKjvXzF/ryde2U09extDVufU7909ZJoKJ8huTdJPWjSqddiOzZKJORZytAjimzLEjGrHMfwIeb2EMJaQ2vS6anYub0CDeLuh0wJ5XgVYWL9IibV/X4s/dpD1empFZfpGstlDOhfOtP8UPy75zXQUOurI9JjeHpstlFPeeFN8AAwRPvErWJuMKUURLkHZM+2JaQugu4Gle+45TOjGzovUw80kj2Yo7B+YBwmDaea+8KUKTJmB+PKUjyXj6m0BnEtoWdAnKsOJoBDVWhQPLUApSKctxpZgy8zu4zogKV9omVitIbJ26tTbSyLVCYm8N+EvNM9Qy49q+7TNwUiBA4dZtJMF1tx7tSvU2XqwkSGJKRqLnBb6BGgYGSEomIduIyGqpvuD7hMm+zCZJKjh/9LMLWJ8pmiFpVz21zQ==
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


