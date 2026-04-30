Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F0ACFF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 15:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 772EB6B0092; Thu, 30 Apr 2026 11:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74A8C6B0093; Thu, 30 Apr 2026 11:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6884D6B0095; Thu, 30 Apr 2026 11:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5803E6B0092
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:08:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 13BCF1A0647
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:20:27 +0000 (UTC)
X-FDA: 84715432494.28.B7F2BEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 75C6218000B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:20:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oKqYLUQ/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777558825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5bT1Gy2a7WVGqbDRfe+wQUgFZmFMVwYzzwdsirBHXc4=;
	b=liLO3YnA2ifT4RedEcF3wksItBku7EjCixqoKRYzHhMTJ5XCq2RCUJXKvMyzfqniLqxzBy
	BThkH6kaCgEOctXRd3+WFwraJPb2BnuXi2jkR06+soscSyuJTgtf68MuTTZ+8HJSzifOCh
	zC/CQZ+skBQ4fW/j6PnsP0tKXZD40XI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777558825; a=rsa-sha256;
	cv=none;
	b=1KSmZ4LEsFYbYqQfni/kqq0StLvpQ8GogDkXKyCACaRUe5L4gWx8acqyghIJBQOk8NaDoN
	feOEBAgPBDFtZ476Z4rSVoQaiTbaLY+sidGTrupXdGfNQpR+/u5dpkzNOdIqFZ2tZQ26cC
	5mC3ajxoPDQcmXCPGQ2a0dNbST19ypY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oKqYLUQ/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7133960180;
	Thu, 30 Apr 2026 14:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D63C2BCB8;
	Thu, 30 Apr 2026 14:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777558824;
	bh=Ru1qRcWk4w4e46Ipw1oHgndub0LRIDQasZkRB/XPXiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKqYLUQ/2B+XygqyB+m1N2X5McbAhh+Xb9n1h5sVjlovsA6Tq9Eqv411ck53zDMAq
	 lkOUX3/km1VfYrZPQWd2y7kU0v8bh1CLUNBFaUHxzCmp+u8lTjuzeFK3yWsmNI8Um9
	 Ah+7q39huMiGgUmZHiMSdXB7d1CsEAiozKM6LhPd6kd+kaQIGMlp+bqHK7kIbK/oVl
	 puM7lORos6+xfOugj8fmbHkYUZdnO1OaGuCuzFuy098fMu/OsTq+15giAGCcMdQCkM
	 2K7WKBEwcKQaqh8XYlmy6rFDx2GkLiIAWWv3BkX4aRlMkXvKRBap+yd9yJmeuVQ91M
	 dAIdSPIOTlY/g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 1/2] mm/damon/stat: add a parameter for reading kdamond pid
Date: Thu, 30 Apr 2026 07:20:09 -0700
Message-ID: <20260430142013.80993-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260430142013.80993-1-sj@kernel.org>
References: <20260430142013.80993-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 75C6218000B
X-Stat-Signature: sn6hganinrm4onyujz6mpdoheaex6yd1
X-Rspam-User: 
X-HE-Tag: 1777558825-449011
X-HE-Meta: U2FsdGVkX18TJpcosUHQw9ojEQi9f5H5JbiTx6M9GPYaaXHjuScNleduUz457uxEOrj4nu7H3mUcuqLpmGkSbfnjWHcX4ZVMGPdUjeHQXRoInBk6qPhUmG3/t7wxgSOeHLR/mSemnTEoLWoDNKU7TZLI9t84op98sBkOwYlssxozu5V9VASQr9yZlpO034pFfXDzmG7k4YwOlkt0a8VfqaHn7RgjIryyXG4zv3AHMkX+OSaJ3/hOFMhqLYoM+MF9wYg4ZeCLBsr9n+9BXP1mYruDbt9Zl+LGOFVWSWt/IYikvnC1pIRsc5xq2qc7sy0cAlEXwHjR+s4lEJRaJpnnUrus7x00ZSHFWXBk0BfjuKbprFmUbX0SoNwy8TNy5h1FN08t7dqc19JrGiQw6vm/ba+3/e5j+eJn9OiWVBxi95ta6EcQtmj57NGKHQ5mrjCWQ6EewWEtiejAOJcR4bsTaEoC/ZRonYCcpsE34Cc67YmVbSNFJITlkOzZEv76XjTw/DHDuGLTesfqsE4mBEZrRm+m4jUUKfNjdjhVjpHoK0bsU+jIXp1xhLmqyirmSyqzdQy9u734U7ekFT9mQcAoawR4ILO7Vf7Vp9SZfsQnk4XnZr2lYMbyXJoEawnH7AHbGHL9qS7PRIytgz6IBrN59k1JG7QfkQyDPrGQ0W7cnuUyQ0x2F0fVSKxB2j3xpZUldrYdj0giSZTVKle6oO52PbtKGsmqrH/gBXhoqilMg5TQW9jJQorfIIH73uY4UlJPc/lB1nHSRjUxF3mwFNpm0Hjl5zc7iRYlS5m5I9nfD/mP9x5N7xX+Nh91Cl5Vwfu3Co+C1ph4U1mQPvEzLb0jvxJytoBO+Atud3RaSa5FPWPUmaknCD3x4ILxq9BqFDxIaIbH7kxjTs25t7YSSPoyxHexIikvwg0nobcF4zdZJBo/+dbnIGIk07tRdrQjthrYrE3D9F2zjbWULqScm8Q
 9OSJFDx9
 XCse2d5OR7qAFEy3zDpmK0DSL8spowYa0I5PXJmNjgFbc5YBFll5opW2mlnhApTvr6DN2gftDfmGeM+SIhBDwZZyAiWHtxZnWMSApx3GTOS6j/vsO+21WgChsl52xNVU4Txj8KC45JLyCLjdN0GMyQXDlYnYy/Wu697FxcRHjuy+6zoU4ur0cc6/LfPabBpZzeNq+lFDjzUF2j/2lGRWAvrz+YVWAadp52QzA0y+dek/O66w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Knowing the pid of the kdamonds can help user-space management including
monitoring of DAMON's system resource consumption.  To make it easier,
DAMON_SYSFS, DAMON_RECLAIM and DAMON_LRU_SORT provide the pid
information.  DAMON_STAT is not providing it, though.  Expose the pid of
DAMON_STAT kdamond via a new read-only module parameter, namely
kdamond_pid.  This also makes DAMON modules usage more standardized,
because DAMON_RECLAIM and DAMON_LRU_SORT also provide the information
via their read-only parameters of the same name.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index f4d3203e92639..37964683839d0 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -266,6 +266,44 @@ static int damon_stat_enabled_load(char *buffer, const struct kernel_param *kp)
 	return sprintf(buffer, "%c\n", damon_stat_enabled() ? 'Y' : 'N');
 }
 
+static int damon_stat_kdamond_pid_store(
+		const char *val, const struct kernel_param *kp)
+{
+	/*
+	 * kdamond_pid is read-only, but kernel command line could write it.
+	 * Do nothing here.
+	 */
+	return 0;
+}
+
+static int damon_stat_kdamond_pid_load(
+		char *buffer, const struct kernel_param *kp)
+{
+	int pid;
+
+	if (!damon_stat_context) {
+		pid = -1;
+	} else {
+		pid = damon_kdamond_pid(damon_stat_context);
+		if (pid < 1)
+			pid = -1;
+	}
+	return sprintf(buffer, "%d\n", pid);
+}
+
+static const struct kernel_param_ops kdamond_pid_param_ops = {
+	.set = damon_stat_kdamond_pid_store,
+	.get = damon_stat_kdamond_pid_load,
+};
+
+/*
+ * PID of the DAMON thread
+ *
+ * If DAMON_STAT is enabled, this becomes the PID of the worker thread.
+ * Else, -1.
+ */
+module_param_cb(kdamond_pid, &kdamond_pid_param_ops, NULL, 0400);
+
 static int __init damon_stat_init(void)
 {
 	int err = 0;
-- 
2.47.3

