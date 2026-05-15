Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3056CCD4F39
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5681E6B00C5; Thu, 14 May 2026 20:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519276B00C6; Thu, 14 May 2026 20:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42ECA6B00C7; Thu, 14 May 2026 20:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 34FEC6B00C5
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:54:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4E571C19ED
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:54:24 +0000 (UTC)
X-FDA: 84767833248.26.16DF4B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 22BC040004
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:54:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WqAbhuCZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778806463; a=rsa-sha256;
	cv=none;
	b=3jtmSK9TaeFGsq59t6EcVuW0K6VvuiQcn3pelOLyLNNPPAJdRzL5pruOWoi84xP0u6k9tK
	Fwf2FaTQl3AuRyHdKe2/18A5LPEUpqOclM3YPEN+2AUG/8ik/Qy2iWCxSE2GiXKXW3DNIe
	ekmfhIxIlYaD7Yyrfdq3BJP6N8/2HJw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WqAbhuCZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778806463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxnI6aQFnxGldUDcZ0n36SMrf4wdFJPD4TahoQ07ESo=;
	b=qVvMjMQI48vWNvKFRNqEryxZCpaUsYyYZSORvQqEMBteD5V5ZjI8wXOpqiu1LjNA7CL93T
	uqbhWdhU72mJtYgkcZSl4vuyyEPMoNWNXYdgbFR+RpgrqFS63uEttKHoSVKBlTJp8/x0O+
	L8fTHj1680fp7I/QQQQ2mF9ZVIx9FhQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 460AD42D73;
	Fri, 15 May 2026 00:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2331C2BCB3;
	Fri, 15 May 2026 00:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805892;
	bh=FnXqCOHFDGvJv0wq5YsdefT6POS2mPmRouI+CopcLks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqAbhuCZYwRVTcA7zp+bkbgr+8Gico9Vyk+HnlFgYCZbFgcBnMGkWw7OE4gec/taI
	 qk9sHLP4yHjyMl5aMfY6HcjTMVJ+i7WCQ+h0D7c8YpjhCA8JDWd6HIDEYPoaryWMc9
	 R6FC/G/Nj6uOjZFpmrn03B8wVLPZR1Ve5H0790rxg9RpwNwlKi0y05IC7ErImmCQDL
	 OpEXOVx/RPSq3+xkoF5JjTzX7U8sZekzRO11/s+OW8d7/cdw8kLVFA+R7FZKAaRN33
	 9uAfmNXJOlpMgOiJJy3qbaTtlDDFCLlwqORZ55aWzwr+7wvQapV/H08MzzKQ6j+QJS
	 1beloxFlWaGpA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 14/28] mm/damon/sysfs: setup probes on DAMON core API parameters
Date: Thu, 14 May 2026 17:44:15 -0700
Message-ID: <20260515004433.128933-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8irorwc3j1y9tyfco95xzrzcq3cuedt3
X-Rspam-User: 
X-Rspamd-Queue-Id: 22BC040004
X-Rspamd-Server: rspam07
X-HE-Tag: 1778806462-668702
X-HE-Meta: U2FsdGVkX1/2j5gejYYl6u40wp3VqDtz1MImfisLv2wgxTY/lLg/I6CfliSJYblSCIO4vRpFpC1ZQiDYiq62AFgn052XLavYQXHAX9E7G4/4rOTbBXjSqj99CAltA9sAx67/MSfikf1j8ad1i1nk+5eu/IrzZ4dCDrczYp+MMU9QTc2nLK/vfO6zS9iBmjN5TF65mKiInDmBWovlJ2jCt71TWjZ2WTGpoL5alXWywukDbqGIyI5riIBNcyEIpyJkeiu26VzKoIZQ7iTR25D0xANStL96iXSCdBScXGsHKCOxh96vKZbSm8NqtaaNWdiZZv0nYzYxrrsJ1SbW+iXyv4kVZY3xXidvlMpTh/HMkqW9PZTKZaKgij+/Bwtd0nMUZs1QxvCKBbh1mKqHLwmUDm7OY7l+WYRcQytv7URn5pK9Z5tV7AyEnXrj69rIz9rA5q5IPH8nohlF8s94+zp5VEci4buYrNOaeLFOrQ7Rj4P9bPRoodqjzmJafLsXZJyschevIvBsPXhT22i3SGApdKqUOfdIvyTq1+6gWDEmJy4GN+7JaJWTdoN3lXzg6SOWNCVSWObbYF9qdLVft5bPPFdMzWsLjIjQZ4m9ebxKL+8vtRN/uzrxoha5atU6gIBqYkFn85ehiwnJOAagkLpyZl+V27zqtyfJS2uCmKZ2+quxUI2rrGanwS2ydfxv+ZCn4rFea00sX7nUb9t4niUc1Yymrljr8m54bx9c4ViBWC92rpNerfmNy1iZoroTeOwcNiYk3Fipg48xeXW5BdjGAbU/h8hBA/t4Cb5RA3fATj/LwhAhAhDXbLrcPD46vvBt9pJr+fK/ifYMaWVQnDDIAjTHLECaShm16yBetCp7MeGFTlxRy08u1GFzLR6OWWPwyH5dyOOqqLJSP7DgPDc5y72pNFGjkH47LuQkzuDDuIWt23xHrHXCPirt6aLBZx6P52jn+eCc83MsMU2Qxl3
 r0a+g+HT
 ams28AlR6BlV4lWRYzdBOwbfFpe9PsGzxCO0e3dVMJs9VBKRYXb8OlsYgRjpqP9QWW9l4Tql9qFIa8GCJf1vFkvFW7zQJxUSm8sSOxt1x3CjTdNDHs81xySgqdiChmsW+HPAo59L5dwdziCKfGDBW1YpkVdeK5bjJlRUVhdZiAigWulD7YNx788lfHhcOeYe61rqGk8Edjzl1ZMNf78OwRpa/FKy+M6A05Gp3rttcH3uLkds=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add user-installed data probes to DAMON core API parameters, so that
user inputs for data probes are passed to DAMON core.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index dd520e39d3602..c2c172aeae149 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1825,6 +1825,40 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
 	return damon_set_attrs(ctx, &attrs);
 }
 
+static int damon_sysfs_set_probes(struct damon_ctx *ctx,
+		struct damon_sysfs_probes *sys_probes)
+{
+	int i;
+
+	for (i = 0; i < sys_probes->nr; i++) {
+		struct damon_sysfs_filters *sys_filters =
+			sys_probes->probes_arr[i]->filters;
+		struct damon_probe *c;
+		int j;
+
+		if (!sys_filters)
+			continue;
+		c = damon_new_probe();
+		if (!c)
+			return -ENOMEM;
+		damon_add_probe(ctx, c);
+
+		for (j = 0; j < sys_filters->nr; j++) {
+			struct damon_sysfs_filter *sys_filter =
+				sys_filters->filters_arr[j];
+			struct damon_filter *filter;
+
+			filter = damon_new_filter(sys_filter->type,
+					sys_filter->matching,
+					sys_filter->allow);
+			if (!filter)
+				return -ENOMEM;
+			damon_add_filter(c, filter);
+		}
+	}
+	return 0;
+}
+
 static int damon_sysfs_set_regions(struct damon_target *t,
 		struct damon_sysfs_regions *sysfs_regions,
 		unsigned long min_region_sz)
@@ -1936,6 +1970,9 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 		ctx->min_region_sz = max(
 				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
+	if (err)
+		return err;
+	err = damon_sysfs_set_probes(ctx, sys_ctx->attrs->probes);
 	if (err)
 		return err;
 	err = damon_sysfs_add_targets(ctx, sys_ctx->targets);
-- 
2.47.3

