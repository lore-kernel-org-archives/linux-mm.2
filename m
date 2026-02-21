Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4033AC61DEB
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 19:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EDB86B0095; Sat, 21 Feb 2026 14:36:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E526B0092; Sat, 21 Feb 2026 14:36:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C4EE6B0093; Sat, 21 Feb 2026 14:36:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 035316B008A
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 14:36:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9AF6D8BF3B
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:37 +0000 (UTC)
X-FDA: 84469470834.28.55569A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E7DFF40004
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f/wZ7aER";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771702596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VaesDynQ63dW3V3BuRForPVnEhfazfZI3wy4eshNiOc=;
	b=lW/WjEQYx9M4qJZw0Vn6UetqLTnFO9qcVGcuSOZCUfit1OkWisPQm9mz0Vg2+OYdUAOWbW
	Dk9yKZZq03purEj7goKDf4l8QJ6e6dKFnXAKnZft0yCkTS93gv2Wvjx4y7t24D3R2R6lH7
	qc19vftiA8ZiHtX1UJf12Uk2EmUSLWE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771702596; a=rsa-sha256;
	cv=none;
	b=YAbdcOszbk7CojZDbszES41Dos//gmb3vz8EOIA4YVPfwtJTu65r1I4t4pHhF0GJG6QFIl
	eru9E7RKEaz5wirbfrFbXpYEFK2tjkLOQlvk0B0xdENKkfvXsb5vlNOm8BpmvL6k/8iUWL
	tFq9fdcv0ONkkNykTwSBVPb8xxOsrtY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f/wZ7aER";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D1C6C44407;
	Sat, 21 Feb 2026 19:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973C6C19422;
	Sat, 21 Feb 2026 19:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771702594;
	bh=NP5yGYScgnKGoybmv99+TvTrjNGo877C34B0II+hAcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/wZ7aERGs2PvqVhMrKPyc6Tc+lGG1/WZh2v8Sb4EoKD5+7RTgO9/TJc5ZAfJXkvp
	 eb5b2xcJ3HFcTadFVuhNa8aNxrjCf+yOxE1DS2O847hktwk22wgrJ02hc+cvEsNlg4
	 yEPg8AcEKU9J3oc1IdwNrhSWZq3FPC15HSY0XFrJ0MyjN0RhP0fCurfvjnAAMUzFox
	 lnGtcsT8xfuFl6BLGuiT16hYzCgHtqMZkm2Ni8USIF4ehnaQyZ+jdGGH7oJf9Z5ws5
	 xCb40o6OBnj1RMff/oNVgxYUcxQXyfXf/Y/J9GwvGyFFTQNnmHhknLyf8oEEM/BH/r
	 QKg5pTnR6c9Uw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 01/10] mm/damon: add CONFIG_DAMON_DEBUG_SANITY
Date: Sat, 21 Feb 2026 11:36:18 -0800
Message-ID: <20260221193629.19332-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221193629.19332-1-sj@kernel.org>
References: <20260221193629.19332-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 14ckopwr4y7yd57ezsareqmsbufepb6x
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E7DFF40004
X-HE-Tag: 1771702595-236376
X-HE-Meta: U2FsdGVkX1/6dcO35HErNxPUDfyBC8fLMVf62W1FvAdt6F1vEB9gvGnEkKODKJxARgK8ml4NwFEv/BeyVq+amOTLq5d1+eJ3NYDN9qD2UPdxscyaYFvSTLYwuFSQXAiR9b9J/Pi41w4LCFl5zrL7kzZ64aS0UlyVxn/atWWBRsvQ0uhCGtkbvPZVjbUI27k2FvipnZlFdvOlRZ4qrQedI69TrhJC5EuPxvIAJChTU2WFy1a6CJUdz7I476uxjNTl4xrHqO3f0SfUJDhLCfTwzU5cQWnKQY0BoDg2Mpe5AD2tASi1dWthsOnpmW0T7fZeXxwmN7s43TaJjmAfsZwybVDqRy/WPS90vHsnNI276syr+waML9cISP3pj1Abwcqb0BhbflsdG3Zd8efZey+ngrIYLkT+9UeJ6xRQTC8T1ocGwQ7q+dUC3MRxRA4q3Mf4FTASQCyelpzekCnXlJVwJg23eiUGhF4gyE21MeWEeUdNka409pu1yksLynrIjSgSN5fDu0zOoUPdPxXD04GLjiPfQWAEkJBVDNRIfXK0lZYWf5wln0xL0CSbnuKtH3pGloFmkEVP1HRxoyYrQiCeAZs6xWpAt3YfkAgYY1IMq/wF9xD9RXqeiK6gJlklbGxuyueNSfDhHh5mt56VpfCNehIfegv76Yk0NkAoQ5JfmZA85WHtnAgMTcT/EOiIX3AAfDQ1SQmwwmXAlW+Dn8cvKpTenuFCAqh9rBW9xFT9MkZxokI6gO3zVoaQ6F3Ytd9ihYbkRwROoLqXM3gG7zyx51b+z9BMr1IKw4cB/EukvTbcrbPOZlCti+FC2ShXqfJK0FDDjuJO/tgt6ZhgKInuU6kxbp0b8itMbMAk6lenNayvJL5+aEmCJoYW6kLGvjujrPn0WQAfGcjfbcUM96qdh24iBHycc2qMbgGrjX7d+bG3oCyE4Vqeo0pyUjmAufZIpiOMKh7i8Ktq2PCm/+V
 qXiU4Bd4
 UCsv9KoWwxmPiIZmSrXMIvm0nk6fFpRpjZbrWKIy5KMN/Hzrn1ZUb32JXBIlp5HgalecYTJ60BgCOJxRl2mx0B++ztulb/q9T4TiVhrsdS2jLCx8F8F16qj7/JGp5cP/J5pWJj6UsZWU/bWwotX4PLvyd7GBUs0X5sPuiF9+aKgjp5j0lPmJWK4JFpYVZxXnYpuaGh6l/KHAoqSI1jQjuIdbraT3ygz1uyvGMATsoZKsskqO9MY0xT8E9YYuvV9YxJWbUNBJSo/CwrMJZ6/UV/tiCpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new build config that will enable additional DAMON sanity checks.
It is recommended to be enabled on only development and test setups,
since it can impose additional overhead.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/Kconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index 8c868f7035fce..413adbd8e4089 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -12,6 +12,17 @@ config DAMON
 	  See https://www.kernel.org/doc/html/latest/mm/damon/index.html for
 	  more information.
 
+config DAMON_DEBUG_SANITY
+	bool "Check sanity of DAMON code"
+	depends on DAMON
+	help
+	  This enables additional DAMON debugging-purpose sanity checks in
+	  DAMON code.  This can be useful for finding bugs, but impose
+	  additional overhead.  This is therefore recommended to be enable on
+	  only development and test setups.
+
+	  If unsure, say N.
+
 config DAMON_KUNIT_TEST
 	bool "Test for damon" if !KUNIT_ALL_TESTS
 	depends on DAMON && KUNIT=y
-- 
2.47.3

