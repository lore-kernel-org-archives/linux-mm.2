Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 744A7CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC4B86B0005; Wed, 13 May 2026 04:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9C736B008A; Wed, 13 May 2026 04:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA556B008C; Wed, 13 May 2026 04:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE4CC6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:26:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 848A21C12EF
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:26:24 +0000 (UTC)
X-FDA: 84761714688.21.253F4FA
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id C887240003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:26:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=om2Rft3k;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778660783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8szn6appTCu89brk1myblNGatYqlSWNvLHOiLLGF2Fw=;
	b=oV+z24qVYufyL4PLFKFp14zzEQ14N1cvXYU0g0C3BNeewYw4orujkRhgygsLVNgR8KE+8G
	kCbA4ClUEYTH0DuilZNz1KZIoDFdX4ajFO8T/zMML/NGniOidm44D294FXWXpxLxq0LuVy
	16TgHobevkrgTyKjoHDswM1mEi/YBfA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778660783; a=rsa-sha256;
	cv=none;
	b=u7Jm7gRi11mh5uMwCup4zimCqBY80nb7doZezJsOxWsSIaAZ5Wf3Q8iL3B69FmVTlE+hXf
	mLHVwmm/W8dPvl1otB0i74BVe2sBNhzENtSPvDSBZo6Qfl5yWxzZE9PG6ik+PXtOBmOfq1
	6A3+pGH3QmaNAL73MvpoyEklSoPCQ/w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=om2Rft3k;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778660780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8szn6appTCu89brk1myblNGatYqlSWNvLHOiLLGF2Fw=;
	b=om2Rft3kNnNHSL7dKKvoXnqVLuMpayATk81CUdJj4s/U/XIz+Cu9ddtY1dvKux1OgZptGH
	2Hce1Vl+b9DFkdpDO/GZbcBqH6LuLi/CQ4u/7CIiPrkr+jnayFxwVa7HttEqztYYRNZCXE
	EYIkjqgcz79c6CcWhIoJ7eRbBEu3JRs=
From: Hao Ge <hao.ge@linux.dev>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH] lib/test_hmm: use kvfree() to free kvcalloc() allocations
Date: Wed, 13 May 2026 16:25:25 +0800
Message-Id: <20260513082525.154036-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C887240003
X-Stat-Signature: zzghwtogwf33hkzhopb1m9cgexe8dq7n
X-Rspam-User: 
X-HE-Tag: 1778660782-699032
X-HE-Meta: U2FsdGVkX19rOoF6HTwagWz2DHregs+zP1NIQLKqRKsHSCiI02QsEDvomsi9zIUDUg6OzsYJUHpJG94Ocv8Y9+MyZAShQLuR5IBM0IrBIauTm2SOrjH35edwQo9tG1J2djQ1coPXkkfIYma/P9KS+oJn/FL5CH7FgWUabRB2YZcE/dnmfeAmMTgU0BKoDv6oRCnfYUmWXPKmZKr4dAfvFe/vdgdImWCwY5wBa+D98Ba9tXymbRk6yJxaURsxZnPuuSMYYfpyOZAqPQO3A9sinIzLriqhWD/oj9h/Ez98jEsQXipSWpUK8qFoD1lesSbEInUIBpDyZBx4nz1VOCPdkYFp7iegtWNGiIl2Wc6B3CgK6DWhrmmT4r5c6me5kJj3ORuoRmhxFmBwjfqUW8RJgXx1YIFeUBk0zkr2UAw7oeVpeRzgfS8ln5FCexJ+z5Xo2DIRR70b2lzpOpxjPIRUk5eLwB1Bxbq/bpol2pb+EpfYVDHfDcoehgj//9ca0kdHvGCu2+zB+pFc0ssnT8b0/13QGu0zm/IbNB3DzC5L4Da0tK9Jj95LxsoUNYOn+hrYb9R6DkMthioIFGuZBU2cfF6xkcJCToO2vh/ngD8rGNR9t0ojcVR0UHJtLjK8f2F4qqjyRS8EG0XuQf2SbSRz0Sw1YgGr+NXD85JeghuwH6vW6QV5tszf/ZJeuoQtboi6xuOzY0Smn44x1M2O9Z+6UxxG+oV2yf3eT5oLkkx0zH71zoENMBNea/Nr6ldCScBPDMswNbTzcHaBP4vPiNJPOgEwN4Zca+61cVYLOeanrW1gTz9KmtJxt2yxnZH/JcK/2CaST65qjPOMMGg71T/e7YvBqPy6ATwCiBwo/6pOLnQePbt4F28I9h4G/HnEI2fYbNTcGLHwyfC9ysm+LBMmrGA8kWywqqlSDvPI5seOpScfFupN2oDP8zXyJ2p4lkwXV2xkEXSXN/9QsABrRym
 is3V2sQU
 kPuYjvYk6FnN/FtND1dCHHv44YQgNmRQra0ff3SbReZwmIQ/2r8VIQSIkHGefHdIBskzAnT+Xtsmf4wHNqQkYgfr3H2gNmMbDJT1H0o7WWgW6b6+4cD3ntbID02DtpYcnf+D3uwOclqFNDatrBazRCkMHgq6qYdfeDJxn8NU6ZW5/m8OVg4629gXbsqOS47abQzBVJMTEf9oZAYZXyI4pXruWOzHgPeS0c6DBd78ZuFbiiXzP/VWtv5mFZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Coccinelle scripts/coccinelle/api/kfree_mismatch.cocci reports
the following warnings:

  lib/test_hmm.c:1256:15-16: WARNING kvmalloc is used to allocate this memory at line 1191
  lib/test_hmm.c:1257:15-16: WARNING kvmalloc is used to allocate this memory at line 1196

Fix this by replacing kfree() with kvfree() to correctly handle the
vmalloc() fallback path of kvcalloc().

Fixes: 775465fd26a3 ("lib/test_hmm: add zone device private THP test infrastructure")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 lib/test_hmm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 213504915737..38996c4baa40 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1253,8 +1253,8 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 	mmap_read_unlock(mm);
 	mmput(mm);
 free_mem:
-	kfree(src_pfns);
-	kfree(dst_pfns);
+	kvfree(src_pfns);
+	kvfree(dst_pfns);
 	return ret;
 }
 
-- 
2.25.1


