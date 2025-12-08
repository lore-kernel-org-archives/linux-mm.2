Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D39D5CEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 005496B00A9; Mon,  8 Dec 2025 01:30:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9566B00AB; Mon,  8 Dec 2025 01:30:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6136B00A9; Mon,  8 Dec 2025 01:30:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C03176B00A9
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:34 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94868BC231
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:34 +0000 (UTC)
X-FDA: 84195329988.04.C9F9BD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E5CA210000F
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cdPmNLQb;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r2z2+3nvwh91iqKX4BfAoZeN/KEhSis+tIwcxRtW4Sk=;
	b=My4BHPGEvEGcrA49ekZCeem+0d5ktV4h/nP8t6uVTPBj5pR8g3Q5+Bhev+SBfnD1t2dAyN
	ed6zt2QDVRU+9b7b4Jx/CnQpcDf891lPz8fNCq0ybzNY6whqbM+H/aMmcGT+YS0giBpFGS
	NWJ9F9W6NHMEo4ALCUTh1LttD9JaepM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cdPmNLQb;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175433; a=rsa-sha256;
	cv=none;
	b=5v2nBsHyzqnfkm8v45343YBQNqzfh1k6jX94h1Czh4c8zCl93OU3VSqTBSTuSlWjtbkb/v
	CPEtxDt5RJOXnelmCE+gdfZRetHnbzvCIn6cs21eh8+/ExZ23AtkNC2aTn3Dd2MGcMHbUx
	S4wtdaGdFUREMJqJs1Qay2AEpxaUaP4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B318401D0
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B08C4CEF1;
	Mon,  8 Dec 2025 06:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175432;
	bh=5bka80r89gRSONmAfQQwGshd2Lcq1UBCMlN2eimMurQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cdPmNLQb0JS4kyN0C0aSoPXZcXcC7pKfrTP1MSY+OtHS9al9RJAd+Nbyj+Ik3k5BP
	 IRERY4Z+6ATXkmOOoOJnf1rh8RWQCPK63AHKeazoV3/Q7WfHtEaNhC+9SrCa7dUDXg
	 TZ5z2GaNy1bgSzGGz5vjrAXGDvGFGyDRohfks2I2k0Q8wGeB5db/DMSWpDr+FpLlM1
	 XE8atbc/zYtR+0xbpIBWXV4+W4FqTr/y/wqf8AzikmNXDYmFhRmkxDlL9xvVfNJow6
	 UGllFv5ETbtMBvDmJ7Dc8ECbu11DSX99uofXonsxVWsJySVQPlg9LGroBt1lua3RHV
	 S6ZYQTE58i+Dw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 28/37] mm/damon: extend damon_sample_filter for threads
Date: Sun,  7 Dec 2025 22:29:32 -0800
Message-ID: <20251208062943.68824-29-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nzntp7smhq8tzd5scqgdqf1ddyro4137
X-Rspamd-Queue-Id: E5CA210000F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765175432-83783
X-HE-Meta: U2FsdGVkX18mQtv7ZTd85H1y3Wl7HJx3CYZZbWrUND4JMszJPfng4RopQYOnOc8FgS2yHn62Y34UFbB25jRq1VuKYKNwZ0/LViU6D4pb7nPHJKhvhd8kW71brsF2/WnwAiP3+lRd/xAGMmHatdp0HPn73BejIYCDymyYUunnd5RBkzYB026oTs7Ky+fCRkQHWTvDfIp5Jl97gcGrdsGVljIMS0JVO+2r36QrM+UbwPjXVwmB8tZ2VLEI0CvJwTrGfcYI8MflfwgHtAf4/uWWjUxf1IXcDkBO0J/per0WNAR/rIPRqI8YT+nH1y07UyPaIr1mFq9lLZ+4baCMn5BbvYBFuXwuzFg5JKql8UdswiE8KnXlnxz+NU5TtoS47Vfl8nxAPKeoY6qhzYy5qnCTD8s+ajrZeksYMN50Vf5lXy/r103lD2wUF8uj3u5iNRg01BLH0dC07YDx0sF9Z10JuuWK4FS/GSeNfKBc37+Dckk73SsDzBLnkJf6qQYbf0rMICCWhRp/oB9S27Gy+alZfRkQ6FGAeZeBtuQDmptGB4Vtn1n1/nE5iIavPiSucGo6G57JpJ1phbes6MH2CgXpEjVUlgk3FuHohIGo/0bbDsfJ7oH0DWI8mcnzcgTJfbpiI12o+217S6hD82zA1zAH4qnoEwbG9vAHGl6ehfZX0dQoSc5rXwBU7SreaVMlxHFza4AauSdAo67ao6PF41a4lnSELHvJgAgMfM0kgZCz4+RDk7PK0i+fUnLg285s2myS306kJ1I8YEHGLPa+H+F0tzfCMilZ4DgeemtDf/yca9NqsB7sarfJtW8+SsZltNBZ23dCPb6hh6fK/Jng0LxUD3mV8lTGN7DQWsac4maawehGAiZzZ+tFvjO5wgpfvUCdN4edWqAhr3PFme5Sxka6PR7C+Jc7xD1J1+Mk6qykWE20FLW/Tc/1b2BvSMQzygc+ixzJXS0zl68CV+poV3w
 Tl4BwsoM
 V3GjGfPGKeToO/TeEou7GKo2RF0UoX0LSjCK43gJhOdZWjFCXs2sScu+6zEiQC2e59HAOL16i6dyaWmGR9MY8uIZG8XlyPjIBXoKsm1xxh6FOexpnxEdUqVFX4Y0sQAWgn/hID40REZyUN66b3JWKZd3XcBU7H8By4Dum/2XMSErdKS9Fk4uxi2WsJ/34u+JwTHJ72lzzTZT3VvZsVIIB+lR2ScQkrCZcl36djLrToD3X76NUmjlWGS8/WmVVANweR7ruWTfG/vuNQWoYzUKT2sqgUhjTcLgyCy/f6A27aOThF3gO3+TCN8xiVMaz9IysN9p0qwxOymaGDicFmNvW4rCAPpkinpIp7VzF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now DAMON access reports could inform which thread was making the
reporting access.  By filtering the reports based on the threads, DAMON
can do per-threads monitoring.  Extend DAMON access sample filter to do
such filtering.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 80332bb2b73c..e3408280ea72 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -787,11 +787,13 @@ struct damon_primitives_enabled {
  * enum damon_sample_filter_type - Type of &struct damon_sample_filter.
  *
  * @DAMON_FILTER_TYPE_CPUMASK:	Filter by access-generated CPUs.
+ * @DAMON_FILTER_TYPE_THREADS:	Filter by access-generated threads.
  *
  * Read &struct damon_sample_control for more details.
  */
 enum damon_sample_filter_type {
 	DAMON_FILTER_TYPE_CPUMASK,
+	DAMON_FILTER_TYPE_THREADS,
 };
 
 /**
@@ -801,6 +803,9 @@ enum damon_sample_filter_type {
  * @matching:	Whether it is for condition-matching reports.
  * @allow:	Whether to include or excludie the @matching reports.
  * @cpumask:	Access-generated CPUs if @type is DAMON_FILTER_TYPE_CPUMASK.
+ * @tid_arr:	Array of access-generated thread ids, if @type is
+ *		DAMON_FILTER_TYPE_THREADS.
+ * @nr_tids:	Size of @tid_arr, if @type is DAMON_FILTER_TYPE_THREADS.
  * @list:	List head for siblings.
  *
  * Read &struct damon_sample_control for more details.
@@ -809,7 +814,13 @@ struct damon_sample_filter {
 	enum damon_sample_filter_type type;
 	bool matching;
 	bool allow;
-	cpumask_t cpumask;
+	union {
+		cpumask_t cpumask;
+		struct {
+			pid_t *tid_arr;
+			int nr_tids;
+		};
+	};
 	struct list_head list;
 };
 
@@ -823,9 +834,9 @@ struct damon_sample_filter {
  * that to make higher access pattern picture.  It can use multiple sampling
  * primitives including page table accessed bits and page fault events.  It can
  * also filter in/out specific types of sampled access events to monitor
- * accesses of specific types, such as access-generated CPUs.  This struct is
- * for controlling what sampling primitives to use (enable), and what sampled
- * access events should be filtered in/out.
+ * accesses of specific types, such as access-generated CPUs and threads.  This
+ * struct is for controlling what sampling primitives to use (enable), and what
+ * sampled access events should be filtered in/out.
  */
 struct damon_sample_control {
 	struct damon_primitives_enabled primitives_enabled;
-- 
2.47.3

