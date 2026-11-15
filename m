Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C7E606A331
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FrYHf+aD
Received: by kanga.kvack.org (Postfix)
	id CF18F6B05CA; Sun, 15 Nov 2026 15:29:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9656B05CB; Sun, 15 Nov 2026 15:29:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB8FE6B05CC; Sun, 15 Nov 2026 15:29:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 80C7E6B05CA
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:11 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0987FC083E
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:11 +0000 (UTC)
X-FDA: 85438492902.19.0371517
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7FF1C100002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FrYHf+aD;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARYlsg/n7vm9LXNMaknzvoX3MBFuukEjb8T+Kwqr2mA=;
	b=PsQZhtLT4ivYh+mBMu1s8tx3zTs/gQIOmXbU5rj3Vth+hrD4JWFgWpZ3ZeISozrfTzp8wk
	5n9LwBsFZN4k6OOLb8sVUkpZZeg8I3ASWYi6kKSGg3SkmC0b5a2id1wVh3fSK1KxdJIVMU
	gRu5AGbcl+/Y8aNQ1phDCEqpYdsSDhU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774549;
	b=aLMk0Diy/tuj4H8szMajKRWyP9SfX7wUlTZrNxc4IhVcXvoNoq7hsRW/8ba+b8jkHNrmxb
	BmTodZ58x1MGnS3g82YwX807zX/U3ROljDMoi8wKIQrdPwp/cFNh0Je7canQ4IlCl6UJgk
	VMLVMdcy3YH8pHyaAsB5ZY03glNJMLo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FrYHf+aD;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E98043D4D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DEE1F000C6;
	Sun, 15 Nov 2026 20:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774549;
	bh=ARYlsg/n7vm9LXNMaknzvoX3MBFuukEjb8T+Kwqr2mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FrYHf+aDyjeGulLS0Qi/lr/Lu6h/exWci9yJRgjUqTadEBun+0tUWoAWrHVaSKecq
	 vleP6oiOGjHlDrFOL6lvW0FkNKpZmrV+WIlGXRLlF3mGoba7abva5MdOLTTvn+/+5T
	 9wRJNtJNZkYqpmWm0fPM2Vj+9Ht3o4lUb6LY8jW0DMf/IPEBSdDPrOITEfXQGr1sRH
	 URxrvfroT/gOz4jbXJeWlA5uY0OEVKT6t2mssWJkwuevSLbaUH7zpj0Z74iOxtwZpg
	 ZT31ZvOkTwXq1/YHuMA1e+Vlo/A3dtr4RJXGDOWlfgVo56n3b0Bo8EYL0xatGwG7ka
	 1H8ZwfTSIwT4w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 20/27] mm/damon/api: introduce user_report report type
Date: Sun, 15 Nov 2026 12:28:38 -0800
Message-ID: <20261115202849.99134-21-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7FF1C100002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: hzuobwuku6r7mt71t14cpq5usdwikp18
X-Rspam-User: 
X-HE-Tag: 1794774549-877785
X-HE-Meta: U2FsdGVkX1+O2JlPA+8rxOsdUh9A2XjZh+s4Ds/6Rk+fqNrXJEoH1HD9w+VcduW09sL0j1C77jf5+BGBpJS0mWRC+dMdfqtG79Nw3SeJZztOQtDXyAvRho4rXBDLG/8efBwPYHnbd7yCRsL4C6CSL9f8pAB1D3OyDf6XhrHpZBVysk2shD9MM/SSONgzK3blogf42ndHgcwngtAkINkLPAW3FsjFrcZIgojASFxt+qFG0hpNZV5kdFI+3+iAcgCB7BsSYuhxyrVF761XtVS7Kr+16pT/Ahei2wNJGkuvJsNJQpcT29aaWByT4qFxmBIx0hLZYcdxUqPWbvG5CA6Un7qIMw5eIGoaRikN/wh7XHO8AvC3zrRs+ai1SzWVUnDb1e5ubujwxNXHP0Kh97KPbBFCqYoS/NeMy1Pw1lbWojXGOz+XiUumKOvjneF5Ke8qfFHbncNZG/H3163lTOqowwo2k0JPM4XWrxKn4FdY38salzfiu7EbNA805shXycRXAXwHHzKQRu3KXw/WkeBJ4Yohyn6Dv+cSvJ3c0AMP/fL75WYvuK2Glg9Nt+ZshuDa0dHluQGmNcJtw8WMMeUrXJ71cRgLD3DpdhSTKDBQdiXIxhYUQNZQVEVWj/dSB/R0hEhg9X8IFmE/34gxepDS8tnf/GorrW63nbiX/uzWEcIjx+vlhXt3iYqjZ5e9O+RqzKfBrIIx+JXqBLnLecM5s37S+UdhDJOWyuCktnEysI+K2whM4BVj6Ye131iEBweH10C4R/XaZinuQ/O+qnx8X5CNZIabFz46o3fVAzQEDLYgpTpXESTwPw1XWXx7qARRerpnfxvR3q+x41X2O1b8Cd1el+KDNUUWhBdttqpBE6piT2QMqR5zE9NmUCWAPjkhYNnrWC9ul6ny943d6PWMJUruvdp5qUnbO0pSTBHyhN/41wx3x07V1FOINLXwRB+QS0GQ+UgGkq/ZVhAyL1G
 bJTzTYU0
 +TDetP9d+FbwUHseSI/gcSpXmI7OPizoX9PbplqZDK5MVU+YFcpkLEaw+5yyq3/LlytYNOYDxNgGqUrRq4nyQKFu7dajv2pTrgDLajl25iHRAWKQ3f6Y5z05T3cdA2mmwtAHupCfC/PdMf8YyXs60kMV1uix020AocOY/yruEsGLomBOSSJRKB26KLOeHFdUUC9Nm2jUual3id/nIizGXTi1UdAAmPFQHQVCpgUemRtKoS9E44kg0XuvxqSoNFufsyCta89Mu82ojGYaaz3KtRmcuKFVEWMKNqyYff7qhQBzcdaMu82QKrf6FJENFNJaA7bUrwiWBdQF56Q8ueMNxn598dSG2Ki8q6l7F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Users could know some data attribute information and willing to provide
that to DAMON.  Introduce a new damon_report_type,
DAMON_REPORT_TYPE_USER_REPORT, for such user-provided reports.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 0e43b669dfc49..329d8202b41db 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -753,9 +753,11 @@ struct damon_intervals_goal {
 
 /**
  * enum damon_report_type - Type of &struct damon_report.
+ *
+ * @DAMON_REPORT_TYPE_USER_REPORT:	User-generated report.
  */
 enum damon_report_type {
-	NR_DAMON_REPORT_TYPES,
+	DAMON_REPORT_TYPE_USER_REPORT,
 };
 
 /**
-- 
2.47.3

