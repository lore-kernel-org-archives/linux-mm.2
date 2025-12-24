Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 893EAE75450
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 17:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E86AC6B0096; Wed, 24 Dec 2025 12:38:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10086B0098; Wed, 24 Dec 2025 12:38:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAA856B0099; Wed, 24 Dec 2025 12:38:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B904C6B0096
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:38:19 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E4D7C16EA
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:38:19 +0000 (UTC)
X-FDA: 84255073518.27.493B05E
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf18.hostedemail.com (Postfix) with ESMTP id BE85D1C0002
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:38:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="Kyc82Oa/";
	spf=pass (imf18.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766597897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYwEBLSq3Xu0Bb48syjU2NlyMoZA1eVYenXZFn1Sm4M=;
	b=X46qP1L87j8FATZ6pnJIebk8Rufyn9DLmowtdn9CJEx2156VNKLXQRzYOV+/h20YIsCxCV
	x3JzsYbN59i6dePWMdzMXrD5qL3+1yAvRS9JVOPqFmjBr0+Ry7jG+kLfXMUTyhbQZhUUNG
	0bHvL4YhSZCMQ59EGY43qwIbEvyjp0k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="Kyc82Oa/";
	spf=pass (imf18.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766597897; a=rsa-sha256;
	cv=none;
	b=qRLaeOggNGsl1B3y9vwytUTujn0/iVM2Y5rc2teXHlzpmxpftZPfcJ1n+dn/NkCBSf/PA9
	RFo9yFWjaYJIy8dRFM5NNG0ulnp65HaPQA0/hGI8IPZyIhPJe2IuRtIfhuhLHoq3rHY5ul
	FcE4KHH5l7wbCi0zcdFApaofE4XWdgw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766597897;
	bh=WYwEBLSq3Xu0Bb48syjU2NlyMoZA1eVYenXZFn1Sm4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kyc82Oa/VOQLyVO+gGGs9HkFXez/2+guEVdfui5v984mZFlr/D55Mi3Qaqm8G6slM
	 TVI0uS3vd7ISHi/3nhBScUkW8AFSK29emStu8ovjbRPXxjAi5JDv5tRN800tah1JPe
	 tdDetBfzqZzlapGA73mR+EMpbyBa8T2xb4ycivJvwF4HSqkDOv24pnQl1n+p7re39K
	 r/zX4kOOwKy9MDogr9hux1qOZnBr4MQJZg18MqNzjLcmaWIIwX5tJG2130HpxhoHBt
	 WVG5BSuTxd29Ye+R9vEUZIp2XBRWx/6jBQUAoMkZ20viJir8Kdufrijw9kgKskVFrP
	 cnJb0/EBDzFnQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dbzcS6tbdzfKv;
	Wed, 24 Dec 2025 12:38:16 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mark Brown <broonie@kernel.org>,
	linux-mm@kvack.org
Subject: [PATCH 1/1] tsacct: Skip all kernel threads
Date: Wed, 24 Dec 2025 12:38:10 -0500
Message-Id: <20251224173810.648699-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251224173810.648699-1-mathieu.desnoyers@efficios.com>
References: <20251224173810.648699-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a5ny9ockfrg7q4jgi6winf667iqpye8d
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BE85D1C0002
X-HE-Tag: 1766597897-684704
X-HE-Meta: U2FsdGVkX18rhHifVXkuxQthju1rLreSuJrtkTsy27xFi3HtnZSBcN+2E+xm4d2BJEIsSnw3QHiJGpp7pQqfWcx+Mdm3cDwiZf6MAYtLWZCej2sCjULcm889ZHXjaLWaw+yBaNkc5V5TFMZIvnzVo7k7fsQAoPfSUV0krpFBEKWajnajTllvi/qSL7Vrns6osU2vz2HCJQjQPK7gYBBcbd5DfQpTTIv+i4PSAo0I64ky5aZhweqhl9pbXEXlmuzJhS1JGyf7A2hNqC0uzWQy2Mre0soLsWM0dmqAjiKtpOnkUrcVJUUzh3ThrqAKNSXvGmRiTDJPqtXryZT75X9yfiOon0wGWlhjxzQIRgMLBMhg+htIbeREwCbbJPINiJUCVJceE4eb8iwMtnETuWufIJZ8e7BHLjZ0YZ6nO/aA1/1k7NKVAkF5kTrR2nqgLFlMR9AFVaMZKG6C7g55TvSIlu83O/0gDtTxW57v9roCRAGFbbvWtvBdNw6VnYqNEYwX/pphDQ9u0H9CaLnYmHihWNhZAuizRG68sx4vfqR8tNwpXYrmE8DnMweXtUOx+SEwxfuj66kTaZbTVsRR3Q09XfZVWB+QLxxLXw+f4hxuaHhkaSVHO7qbNjy7x2UC0SlMnC8mOPMhN35QBwCySPCB7usFRWoCwjbSEyfl76J6PanDDEL5MPhxfDY8ZOUCC3/6Es2DHoOj2AonYmJR9CifPn/SGIdSYNV4RB09T2TaaRAdlk9HJGt6uVAdIn2wgtCpqspMbLJznmNvlH719oZoU2wo3TOfw2c8oDRpE3kr3/pNWGRoCLVPi2MmEU1ieZ1z4+W0cDszanbtFE9E2ckGjZMkCBZTnItDyivMx8eX2hrgJCxJGdWxY1mFz4tofA7MIDtsv5zDjBcyujqrTLbzSO4PvQrdIoK6+3YkxBsvxioDp+01WxlHHmz+peXij0TpW8yTBFQisz87dqIYfm8
 ynuM61bF
 Cp7eMoHHjL9UyWz3JtxXxQbDSajcYaYgo9P+q7YCagpAfjzPi2Vg5m+kjwexF1mnI2HhJkm05pSCy44MsPR4wApFcoSrDYzd91z2rQjS8B5leXSWaAS3eExxPaF34k7A1kHRitSTx/vhlSYxziSSjV0eezdZcu8T3LeSXX5LMIt7uqQ3js9mbxomVpd8HGaDi6zItbcU8lvOUl/UESssshantl8xh3W46SITUv9WWKVniZMPusDdjKxrHQX55bC8MCS++TXOJ9hgKfsxKKFHI9JRZDxExXaHeN6KF46J3HWpTPmFq1CW8DM0OQuasStyCiYXhvXuQYKRp7BpLWBgHDHX76L9MX69Y6IxFd1y4gUpgRmxsxKerR8Wb27PXkFXN5IiD3t77AFOoa+V4GdaS3Dg5jd3RMf+82/ZkHwlUHIPdH82NyN93QkXzXqqTMZAtUPvE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we hit acct_account_cputime within a irq handler over a kthread
that happens to use a userspace mm, we end up summing up the mm's RSS
into the tsk acct_rss_mem1, which eventually decays.

I don't see a good rationale behind tracking the mm's rss in that way
when a kthread use a userspace mm temporarily through use_mm.

It causes issues with init_mm and efi_mm which only partially initialize
their mm_struct when introducing the new hierarchical percpu counters to
replace RSS counters, which requires a pointer dereference when reading
the approximate counter sum. The current percpu counters simply load a
zeroed atomic counter, which happen to work.

Skip all kernel threads in acct_account_cputime(), not just those that
happen to have a NULL mm.

This is a preparation step before introducing the hierarchical percpu
counters.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-mm@kvack.org
---
 kernel/tsacct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 6ea2f6363b90..5c153106e642 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -125,7 +125,7 @@ static void __acct_update_integrals(struct task_struct *tsk,
 {
 	u64 time, delta;
 
-	if (!likely(tsk->mm))
+	if (unlikely(!tsk->mm || (tsk->flags & PF_KTHREAD)))
 		return;
 
 	time = stime + utime;
-- 
2.39.5


