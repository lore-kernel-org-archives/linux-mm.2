Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01F2FCD5BAA
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 180C96B009F; Wed, 20 May 2026 02:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131E26B00A4; Wed, 20 May 2026 02:29:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 044B86B009F; Wed, 20 May 2026 02:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D52086B009F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:29:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A1D2312017C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:14 +0000 (UTC)
X-FDA: 84786821028.10.8D5A92F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0111C4000B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XHnW23o/";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+/Povz79d87HbdJqBmb3Cot0viqAd/5mMxq8n9ZgbLI=;
	b=AOV7wuAWF1yTWU2veKuJzSsUtcyjcOPISMXFEUKLBYbnY8AzjgcDC/pKsa9dLK2h4h0045
	jslfIs39xJVFCnBnI8Sqc+YNxL1iWeCkLP6OKwShzaNWRqSzq/dRnOWKV+seaDPq9a4vIt
	67dA/tv/Hk03tKXxt8cmq6umh0psHAo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258553; a=rsa-sha256;
	cv=none;
	b=KXCrbUvmN+2wBXT1axAC5wPKHGyRbbMGjDFq8bO8BuCyCnKqrZhnm8tE1tsiAUtpSgQPhZ
	dBOGKgoboLoJwBqSLsypW+r0Qwsscy9addhshSgMS/GGWw7rbY4MphxknLLqyJebCggmzu
	/1rWLudoRsRi7o7SjHoFi+VeCZ5jQOc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XHnW23o/";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C38434439D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1261F00894;
	Wed, 20 May 2026 06:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258552;
	bh=+/Povz79d87HbdJqBmb3Cot0viqAd/5mMxq8n9ZgbLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XHnW23o/qxj5i4iQoUcRFLWQa0b+Ptv0FCVoUHWJtZu2O+Gx5TfdLSpApc9T2X05c
	 U7WTn784SJKdNBo7qO6EQAhnT65bROORu5FGAcWtVVDpICGyV5RDJdOfY5u8EO6Qi8
	 aMzO22HYiLZOYXhAd5lFITuUDHWCMW9Loo/IYW5Wwz5UF2dxVSovCg6NA1CRZZcLQL
	 U5UfFMb2KHOFECwGoBOIGEUvQQe6GkjuLMB2pJvnjdchxaSJBzo4+jnJIcwmyQnCW8
	 jh9u+aRd8v2828E7XHVq8mQK+Q5FDY9HR/xFFIxwTuV5FNqsyyMYS9JpXWA9lFXXJ7
	 YXJSQiDoBeFVA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 14/14] selftests/damon/sysfs.sh: test pause file existence
Date: Tue, 19 May 2026 23:28:46 -0700
Message-ID: <20260520062858.167011-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520062858.167011-1-sj@kernel.org>
References: <20260520062858.167011-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0111C4000B
X-Rspam-User: 
X-Stat-Signature: zjxi7hqee5pzsyfxc5k4sbq79cx4pi6t
X-HE-Tag: 1779258552-365749
X-HE-Meta: U2FsdGVkX18OY4OpAjThqKm6ntVVveeD8579gGOLbyZZs6jUwHVHS4/TY7VnTORsZXh0TJEb7jG+Zhn97Pa+ngmYo/WHDVXC67DvxqTiuhxm9x9eckmVANFDkGpeUa/5wE88yg1egbDLb7wredubcri7sLvwynGvGLHvkaiekYu9gCVBhq/NLf+HGCZMULJX0PipaJar8JIhBKGa4ZAQHQWCW7bjrKYwVB1AC7U3wwzfCm07QDa6re7NJYIzGI0ANUsYSz/i8hMMX5QCdSJQGgJ/q1POYCohA4wt6uw5Zt+nDTMiivOObyFlZohsL/mQnMSdQ4XnquTrQdO8W78rdXHl9btMMKgsLClGM9h1UoMrJXhR5DQU56Fk5q9dJUHt36n44NWqxrv1s7yPUudIytu3LJcsDIZxlnPE+EShN50H0mnwWlOIR82ntbrEDImXDB1zKk/T3DXPorY47drKG4sB+X8XpuL4BYHKjOWY8Vwb11w7QQDHUNbex0s8kNBAjgyg7mdeeeum76eX3lRo+KSqbthmKNjiCtOFxisb6J8fPObNgLnr4ZW0NloKCg6Q7ItKq3V9uXpI//1dUfLIASmPVAXSkiL0LfQ3LRF6wPpB/KITVhb3VRnDvPaz94Wpjwt2m9UyLpa13LKg5c92HWKBYnX8uK3gSG/At+J6FnDRVVNe9aEv//JoC2D/1SmzxpkCh0nt8mELkmXQi8j7BmijM0RL/XvnNmgWM64L+6wKDVKN44ms5g2EUUW2AJBG6Fh1E0nfhAtL5v5MVHZVpdMtIwJP1lgMlS6qdoxPLDCmKrcVsHMdFvzaUERpTophK8ht9/YK35PjILvLFotpqcyWQn1lPqLE0vXVIT8mwiUCMhjhwBUs/BaLzTnmy6HV1qW2RMXKDlZ1wMs8wFJEfOhT41n+p4rWnqjVfNn3YGGZ7KC7SRhQHnEt1TXdORC0O/ppqPzuXB79DvabvMQ
 gRPOE+3P
 8yn8dzOE0hwAAM3bp8wMnavo8zYaq6ATBihpUMOlVZzg7D4913c+3cXALxRZq6/3EbJtytBy1bdACGC1K5V6d3+wz31YZc5hrKAaj9XzFbHekec7J8+APeVpKyo/u5cFLw1grJQe31zJfWsAoz7G6vttX7qawPV41UK1dxLc3sTJUTcOwLQHiWeydSSYa5A5gj121voIdIporiKWI37QfpJq5HSNkNRgtzZm4Qs344YsyyUuLuNU5XJP87sUFWUt3G6vI+8ylr61FkP9E0XGjicnpe26EOdWt/f1JUlgPqPhQXKo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sysfs.sh DAMON selftest is not testing the existence of the 'pause'
sysfs file.  Add the test.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 1e10881afabb6..ae002dd3c0797 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -366,6 +366,7 @@ test_context()
 	ensure_file "$context_dir/avail_operations" "exit" 400
 	ensure_file "$context_dir/operations" "exist" 600
 	ensure_file "$context_dir/addr_unit" "exit" 600
+	ensure_file "$context_dir/pause" "exit" 600
 	test_monitoring_attrs "$context_dir/monitoring_attrs"
 	test_targets "$context_dir/targets"
 	test_schemes "$context_dir/schemes"
-- 
2.47.3

