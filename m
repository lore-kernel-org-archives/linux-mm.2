Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 100F9D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 732A06B00B0; Mon,  8 Dec 2025 01:30:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2606B00B1; Mon,  8 Dec 2025 01:30:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55CD96B00B2; Mon,  8 Dec 2025 01:30:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 445766B00B0
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:46 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BFBCC09E7
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:46 +0000 (UTC)
X-FDA: 84195330492.01.546EBCB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 851EF120003
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q3OgjpkR;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vs+TNNoZomxHDqLV1TkT4vZ3S/gMoYTABs/OCdkeUKQ=;
	b=2zpcQeYIWIg6LohZ7DadNuIoqA17Mkvp8QCpkSmxzxVuCBaAEg4tZHfrUQBOX3/S/3WLvG
	eAW9fmlhjp2rtDEs/EJvPOuOk9W+NGObZAsIdCRYyymMn+w4OMZOnBUHurOzDBligBvOvq
	p0sJ4GA565LXdT7WWMPCLiwba3Xn0pM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175444; a=rsa-sha256;
	cv=none;
	b=APxFQN7O1xfoHM4qVOCd3DsYhFpyeAVg0xskDeswy4wKlq+TVyET76Rlu1/ll3WNDQ1RX+
	SaWNGiKd7QvNzFW8xyfSul0ry3BHujbqdYvCGekqZaVgqWkc7xya1TXtycX7cYyZnzQfTu
	zhW5NoooXyduK1cnTRE3w1bPuctby28=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q3OgjpkR;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 20E026013F;
	Mon,  8 Dec 2025 06:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D208FC116B1;
	Mon,  8 Dec 2025 06:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175443;
	bh=I2gSrUS/ytzkCO1hJUdsffUlWhdJJTl9/yHYyXuCFtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3OgjpkR49zDj2QFoLmWOx92p1HIbZX2mIXn+c67LiZRVhV/qmtiAN6QAivmIiS4B
	 acDRY6oMBC+L0ZilJc+sJkWCdFl6QnzirMYRi4xbUIHciCmy8M8pTK/m3wfxNoDxgB
	 B9MAp6q8QV5L2+NgGWfBqAHMqeR2DF6/lspaRDe2lrRAZeEatsa23zcG4MdlpXXZHt
	 YNw7GTz9W9bblfkR6tQBFR54YxALWklwnM4OokbXLsYUZrrsJGhz8bjoUeLVTwiFIc
	 sanfNZ6mWEvnJObpLzN1GM1HOMrC7EMmHduLAzCsUvNasOziiHbeWwnizarubsYom7
	 RJ32Q0TBhwnew==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 35/37] mm/damon/core: support write access sample filter
Date: Sun,  7 Dec 2025 22:29:39 -0800
Message-ID: <20251208062943.68824-36-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 851EF120003
X-Stat-Signature: 8uyj1kcxa4d856dtzkwddsu7b8t7q9jb
X-Rspam-User: 
X-HE-Tag: 1765175444-991319
X-HE-Meta: U2FsdGVkX19V2tO0GrXFiDVQwfbx/SMykKSCjpcYLLtDqu6sw2L0M1UZjhYl4b7uRBIEtsyXj+l1CG96hLnUp7os66lPh0zuWmPMbYkCCPzNlxNgidtzIutKkhIOtLrAZSLu7W9/AmtTO7W7DiEOfmW6iXEexgDVSM5VYEnF5/Eb160gAcGU5pJYmwqyujk3eAIjK6jZQGCVH/4S7c7eE94n84MLcpeIxSsScg08ubePWgfMRkLdsj+LsTJNcl1HfdIyhCIyhbAOtkH4IC9GWl22pw7WxvmNwTewu3J/Bd3bhU/wLHNfyayoqzOzXEuBMfCDRLgnbMti4fRURoHEIpCHfnGQ4r69xmB0fg6sXSkC9/XJXL1JBub+2KPtVRt0jCwIiW4CssyTXA8EFrtn00Rzq+9DwwME7b4OgwVGL6BdH8FCHP/+wTjJldrb0cMSzNubVrhSk79ndYZOapaRvW7wsTATwFHIx8A2H8tAdD+F8socC/33wPWPDaJZ5NNkHLjyFQZNxtT6ZLmXrsbtr7DmVATmsLyNvdxZFON01aT7wg50ACZF79g47LwQiNWTkqB5xDhF8HZJ6Tl/LTsFTRf2+CZDr2KuAQZzdpGjkqSfJP0Nv2TbDkCgQYY96+6VTccKLWfnPF/hywW1qnznMsGSiW2qOGGC77dLKq6Y220bpJHdipw6damUvc0sOYAiQWZ0+QDOtFONtt0p8TGWSqM8yxzAW/Sdmjnm4XnbC69vDApGIThKipQYx8RAYnqym0PlkUIEsgh+S9TqjbxIZd/Pt+YmW05xXyvuXMLEV9l+XIf5zSZ+/2p5vFqTmjG984v/jC+oP37UQHaylMoFQFUW6wxTspk+dhDE0VkhSKDyRcYAbRtHq9CiCSF23Hc8DqqyVhUcnspCiCz0Vam7VJsUzI5juAgnrwDaMIb0+QpXxg7SKquNMJPr9HgnSuhtd1bUdKqtfGwUJauNvWO
 87Pjgx9A
 9i/EyZhomHsjXkkmONVPbTp1rP2XVEj8x5gM0JVHN/6hpRIdnrnRvc6kfbSjehzVBh2sQut62mKfTXVSxU0W/gvJI6spGQcjhC1bcQZepiU8ohacCVo5MLb8Lz2FTGK+97hNsUfgu18wLpTLQskaYPIY8MZTLx/bWAfGC2Cjb3fPD3ecppUghqX0nNxyZlP8xG7Up
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now page fault events based access reports contain information about if
the access was for a read or a write.  Doing sampling results filtering
based on the information can be useful.  Introduce a new type of damon
sample filter for that.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 9 ++++++---
 mm/damon/core.c       | 5 +++++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 9299fc91ba27..f9fd26f7eab8 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -790,12 +790,14 @@ struct damon_primitives_enabled {
  *
  * @DAMON_FILTER_TYPE_CPUMASK:	Filter by access-generated CPUs.
  * @DAMON_FILTER_TYPE_THREADS:	Filter by access-generated threads.
+ * @DAMON_FILTER_TYPE_WRITE:	Filter by whether the access was for writing.
  *
  * Read &struct damon_sample_control for more details.
  */
 enum damon_sample_filter_type {
 	DAMON_FILTER_TYPE_CPUMASK,
 	DAMON_FILTER_TYPE_THREADS,
+	DAMON_FILTER_TYPE_WRITE,
 };
 
 /**
@@ -836,9 +838,10 @@ struct damon_sample_filter {
  * that to make higher access pattern picture.  It can use multiple sampling
  * primitives including page table accessed bits and page fault events.  It can
  * also filter in/out specific types of sampled access events to monitor
- * accesses of specific types, such as access-generated CPUs and threads.  This
- * struct is for controlling what sampling primitives to use (enable), and what
- * sampled access events should be filtered in/out.
+ * accesses of specific types, such as access-generated CPUs, threads, and
+ * whether it was for read or writes.  This struct is for controlling what
+ * sampling primitives to use (enable), and what sampled access events should
+ * be filtered in/out.
  */
 struct damon_sample_control {
 	struct damon_primitives_enabled primitives_enabled;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index e2fd17b83a92..5f29e4dee267 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1336,6 +1336,8 @@ static int damon_commit_sample_filter_arg(struct damon_sample_filter *dst,
 				src->nr_tids);
 		dst->nr_tids = src->nr_tids;
 		break;
+	case DAMON_FILTER_TYPE_WRITE:
+		break;
 	default:
 		break;
 	}
@@ -2912,6 +2914,9 @@ static bool damon_sample_filter_matching(struct damon_access_report *report,
 			break;
 		}
 		break;
+	case DAMON_FILTER_TYPE_WRITE:
+		matched = report->is_write;
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

