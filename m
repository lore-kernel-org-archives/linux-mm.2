Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CA1CCAC587
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 02:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1C1C6B0011; Thu, 11 Sep 2025 22:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7D986B0012; Thu, 11 Sep 2025 22:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9939F6B0022; Thu, 11 Sep 2025 22:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83B536B0011
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:39:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E5C511926C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:39:56 +0000 (UTC)
X-FDA: 83879043192.04.3126757
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 980E740009
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:39:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rnqoLcU1;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757644794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UbFPyEZigumybaTr60ckkS+zfqMprmurq8B/v4uqzmU=;
	b=DqDVdfkxY5IvFmudK9hB47iWr2qZuCZ5lTkqb+gaSsXlDkFNsiSJpiHOrmOCeaUpzs3/+N
	HOytlnuvB4MYsRD3wT+L+lRyugTtHSSghIV69jo/1IDD0LZLTgyQTp9Z3FMGrYYMkq9IqN
	uKA2eVhtqEgzPjI03MApEMcgvCXvojU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757644794; a=rsa-sha256;
	cv=none;
	b=bKsmUqcPm9WV0+ZHFZapQI3jb3VSDD7R8jR98II1T6pAyZGCee9tn99IBBgNH/hRCG+RtH
	EhtTM47CLKEQ7lTXLbnbfzNxqOKySK01ynVZ3kXObp7bRxRwihd87U6xRDszEMo1yg2n2o
	2YDWQP1f/hZwtBPdxCPKnG/kqoYPfHw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rnqoLcU1;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BE326024C;
	Fri, 12 Sep 2025 02:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F47C4CEFA;
	Fri, 12 Sep 2025 02:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757644793;
	bh=R6gFcrBZzKhA783iYWMpRMpyvk2yh72AuYFVIUrkO4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnqoLcU1HwAB3uvX7ReqKrUa2MOea8r/MNoj6WTGGW8PpUYZ5uTjJuKOhBBbMJHxJ
	 /JpGCWYr2X29FYDZhFC/FgHZPEC23na/YaL3P1qHSvAB4vH4dAaBbxk1f6/ixa2shg
	 hFh+a5tFt7YKuLwZ+b6QnTO8Ad04AzaGw6rMQSsABuBeVSgBEEeswPgzpscVI/XJg2
	 TJNr7DJiLa6cc0ghDf5y3skZGm9pndE+gLeh0Cfnjn6QHIhbT13MGVbr+pFk6btTkc
	 6xA0vI70JTxkX8ut4Q7cBzANJaO2O3WXpjgXaOP/JFEfjcXFz6wdAE+3NqvP/lxyo6
	 9XJJF49U7/mHg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/7] mm/damon/stat: use damon_initialized()
Date: Thu, 11 Sep 2025 19:39:41 -0700
Message-Id: <20250912023946.62337-3-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250912023946.62337-1-sj@kernel.org>
References: <20250912023946.62337-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 980E740009
X-Stat-Signature: pg7ifemeymprfib76zkinqc6f56wurcx
X-Rspam-User: 
X-HE-Tag: 1757644794-410329
X-HE-Meta: U2FsdGVkX197s7lxHdaorgN8CPAcK35nXUJhQN7H2p0dAg0j5DUL2Z0UOnhZloNBHf7NqI7oR/fSHv9NX9TJPCn99BvFhkBMvtko+9e7c13fFKmZk4e3Qi75qAANVOCtSKmPuVUTTrx3hTqvN/JYLzuvEkynW57xF9CJklDgTb7/EbCziRSlc+P89JJHxYccPGCJSmqkGuFXhOzIg7pdX/H+SUkRyRYhwQMO4JXqpcFvohimJ03m+k7E4IXYIK7kzAlwRmXysJeguDD15LeTdCyhVuxg7WVXK7XglwbATSiRX/EiqNCb0xD06w7gjRiGZrhyRXai+riEPjEhN9HvKIKKUWk0gWjmRZ5bFZvprZyfnsY0GEgT/lGVklrdFGNvQLfIKPBusDsnW/gW0liRD6hBl5/HPL/pEXlv8qlCielzA/c6qpqHdwzWnR8XJv4ILAwzhFzrEAfWoCVD32KRj85hYj5tthg+LZyjhlPQRHZXB30/8DFLxdYDLwxZ7q6eHl8oCCxbn/YfzjgheOMM07KnrEuK8TOw2USqZYdqvLiYU5q96+SD4Eayj74UtMgtxA+QbiF+WFMbVdVXtQsVO83sUePjB4SzSPQMH2HJZXVOIc+iQs6fQxjJjL3n/orpbYKiPqUu/xCbYZrxdzb3WbU8hk84npPckqxCWJTQNHjaiJ7/1oroSAHIcpZLnltuIno07wRz6hQvaEy3il1H5xURZnDaP+9l5TEzO8cCd84dJKR4rfhiSM0064VKz2e5Pvnjwn/RyvPHIYddaiQSNgl2Bpega9ZnrYbMzqi+dfjtipVqZ1gZffhs8F+vwuZY6g0IEDHqgq09Odln2W1I8UgZQLuLMyowKXxr+GBBrd6kdkZJ1GyvQ3ntxR71gITa/jvbDnv7K+qmMlUHHFE4fLbrl5zePMZouXnfYJh9YP55odrQs5tZ2iWl0yH8AfC9o0ug9JxTFyLJvzIjTZx
 P2tUrbdF
 yWhjci+cdpch6geGcgNZVu3jPppu6AH8L6PMkhuxV4/buuXNHUjFreTZYlIESNCk53C9LJxVE4VGxcUjFe2nHZjgwiuXVbyREqifsR8KLyz/R4g+BSbT9KmH2kx3pbRI6hjpb6ofU90XQ/LMFx0CMKXfFcuCjJBd7umw8JOKjgIaViKEi2HbRoSnY9tga4MKWtSQu1ZavQfAj1u+7HArzmCPYA4sZ+bFc/0+2UyRpNoyi1zminzdARXlg1ZiwtRs4t9ilAKUCx5EFsSTTGsMn3OurxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_STAT is assuming DAMON is ready to use in module_init time, and
uses its own hack to see if it is the time.  Use damon_initialized(),
which is a way for seeing if DAMON is ready to be used that is more
reliable and better to maintain instead of the hack.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index c33df0ade183..d8010968bbed 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -220,8 +220,6 @@ static void damon_stat_stop(void)
 	damon_destroy_ctx(damon_stat_context);
 }
 
-static bool damon_stat_init_called;
-
 static int damon_stat_enabled_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -235,7 +233,7 @@ static int damon_stat_enabled_store(
 	if (is_enabled == enabled)
 		return 0;
 
-	if (!damon_stat_init_called)
+	if (!damon_initialized())
 		/*
 		 * probably called from command line parsing (parse_args()).
 		 * Cannot call damon_new_ctx().  Let damon_stat_init() handle.
@@ -256,12 +254,16 @@ static int __init damon_stat_init(void)
 {
 	int err = 0;
 
-	damon_stat_init_called = true;
+	if (!damon_initialized()) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	/* probably set via command line */
 	if (enabled)
 		err = damon_stat_start();
 
+out:
 	if (err && enabled)
 		enabled = false;
 	return err;
-- 
2.39.5

