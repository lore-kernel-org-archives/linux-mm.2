Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6BCDC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1BA56B0194; Tue,  1 Sep 2026 09:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4BF6B0197; Tue,  1 Sep 2026 09:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 844D36B0198; Tue,  1 Sep 2026 09:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8CA6B0195
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:19:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED36BA040F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:19:02 +0000 (UTC)
X-FDA: 85165248924.06.2441F9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6873640007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:19:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WvRKDNbT;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268741;
	b=cbpaYvuox8Ru34xZN0vrfGSaNLMO+xrpfmnanxndEz0OJxzfkiRuXYwkttR4EiDo+PpRl4
	5Yln0mIHU1A0AiDGHmubhprXmTo6AhnkdcuBnlz/in1PB3wn1i+MTpeDXuCqSzc/wY9CoP
	w5DEZ6RynW5xMkyoW6meUdHwEHkKizE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WvRKDNbT;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLJtgrH/eA5cfD1d64StUX4ou+TBBQRag4ZJY9MXlY0=;
	b=cDRW0JmaVj+EeLJXaEBTF8kbs9N9PRT1hBRM2AMy0B1dnUhqATOZeWcMKZpLQ1+lQV7bhN
	1/0DWb2boaBdYDOKderWa6s+lZe3SF5or5KEQ3RoO/X17MLiI6HTqo8xFuzh9dXxOarEQY
	r8ylBRNCz+xRhlaPgUftxxWhefkfaIY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 107DA60534;
	Tue,  1 Sep 2026 13:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0DB1F00ADB;
	Tue,  1 Sep 2026 13:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268740;
	bh=YLJtgrH/eA5cfD1d64StUX4ou+TBBQRag4ZJY9MXlY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WvRKDNbT0hyEoN7m5TjTShQ5sN5bJPnuNWLT6l7VT3lCd/KVbAfzwtJkyYLnKaccq
	 P1Jw9u0g7PmSQBwVBlbiQEs8LfnoL/0DQbMK8XTluP/mmlATssbYqxglyn6C/fYh7l
	 rp+7LZauxItUuyiDJ4F/zDntxqOpzYlZKFlU9xINPgFA4M7tWIzkweK9pz461bhAnY
	 3/Wx8HiFakAB/JN3eWrXGLGf1uJiGNbN9/qPXlnfQx+MbZgFfnQ5N0f0vD3P9DNS3Q
	 QY/JgRdyAdRo48bYa/MLnNFX/VQqTSlkN74Z86yHtOfe/uztJgo8Qnbfn64UX4i+4q
	 MBDXcwSvH7XyQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/8] mm/damon/core: handle extreme memory state in damon_get_node_mem_bp()
Date: Tue,  1 Sep 2026 06:18:47 -0700
Message-ID: <20260901131850.98037-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901131850.98037-1-sj@kernel.org>
References: <20260901131850.98037-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6873640007
X-Stat-Signature: r41ko1xh7qp5baxxsjhpz8ch8zzki45x
X-HE-Tag: 1788268741-205372
X-HE-Meta: U2FsdGVkX18pv77F9pFzzHbFW5hRdyB0Wzj1/j7xuzzS49y6qN18U6QL3AjMYjLKKZ7pRlG64nlqDoCQS5D6ex8AiophZfMmf5NZGgW0MoZ1/NFIsG3EOjLVJFq/E4Ny5qqahMOx6yMEzUfr4jXDatTNjcoR9EAwsRPnAvlCAlchtxAeaWTY40Ao5jQYc7Ds9ZnmjycOXQkyDVZlF+3XcK/yUucNrvA7sxIeDaDixFkiDIKyQz8h+0g40SaI22bWBAkxJG/RtvwEpseUzZk/eA0LXZ4pJ2YZBeWWJUXyvbtCgEbpReVmkOIGmXGtd5KQTCeCJUHrJDz8MmGIdu1NNjIv8zh1MIXTJIpvI0z0wexfXOD5tZSqU153Qba+50SaJpjRw3bSfcoYFbEIC579L/I7nlPKQCUGTJF3JlceOb43hjZydkoHZoYArIXQQyxOeGU25UNbUNjtuB6l3o75soeaOKhI2/l4diwi52+QRzFSJ7+F2RsxB5xQ2h3MXAGoF7QsaX2ZxfRf/cgoQK49z2hGov22OwPweFtIjE/nl01keKI3ka9i5phgria6KL5074APHfYX07++rV5wNqTa403KOx/AqrPSPN3p+wLz5XxLWCHzSKuEAY+SwEUji2iSXvYMMN4Clq7jlyFeAyaNKiPegVt7w0u6sU0QOB1hUmeIawhNrHqCf3MnBxutuyaMy3c/A4M23JBMfzCSVS9a3E+pRlrmTdIVxJA4hYZ1kVo/55b/MbA380YzbVK5btDjVc1vcrOQH/wjbIEDHtqcdY0Ldbu92BboXHHGtjtv5Va4laamG/V6AvRD5QbQfvsuC94RS8YAD/kCmTdQvTzENwqRERChCGL3Kkany+uC7q6FIp3a7edpwHNDPnycHBj3gROeiAjTsxDvpwQXLl1ersDSEkPP3S54yvVCOAh7yGbS8U+5O9MWEJgQtFgurzaS31Lqc5I6b91TCZNMDP3
 6ZmyK8Ni
 YczKBDtuMM7JeKOCAhnU4AVPLlKw+0fGdPJ6EjAnuMnoX2jUnloEMKureN1a14ZN9wPbcHZOtmOOUElVNt22i4FJSBWtofaSq0L5SVfGIFVc7UwzZF57Xx9qn6tZD81lJdcqCOvEyXYWmHTpbOtbtWaEUI3iIKIkqpI3x1lsSjnWfpcfHHmbPVg++XswoFaehvhbWe+ZQPfXSKWCXj5mtF+L2ga2ZbRlbXJQsz2JyjNgfYOhAW6F3hj/Sdc4jCo7ozmNlOsEB6KbTel7VGn92PJ6OTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In an extreme and unlikely situation, si_meminfo_node() might let the
caller show zero total ram.  That could cause a divide by zero in
damon_get_node_mem_bp().  It could also show free memory larger than the
total memory.  This could cause underflow and make DAMOS temporarily
make unexpected behavior.  Thanks to safety guards in the auto-tuning
feedback loop, that should not be a real problem, though.  Fix the
problems by respectively returning 100% and 0% for used and free memory
queries in the corner cases.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260328133216.9697-1-sj@kernel.org

Fixes: 0e1c773b501f ("mm/damon/core: introduce damos quota goal metrics for memory node utilization")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index a6fdb3068262d..ad3657d356fbc 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2807,6 +2807,13 @@ static __kernel_ulong_t damos_get_node_mem_bp(
 	}
 
 	si_meminfo_node(&i, goal->nid);
+	if (!i.totalram || i.totalram < i.freeram) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
+			return 10000;
+		else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
+			return 0;
+	}
+
 	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
 		numerator = i.totalram - i.freeram;
 	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
-- 
2.47.3

