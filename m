Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 768EDFF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 20:33:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A354B6B008A; Sat, 25 Apr 2026 16:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C8C6B008C; Sat, 25 Apr 2026 16:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949E96B0092; Sat, 25 Apr 2026 16:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 76DB06B008A
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 16:33:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A5C41403FE
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 20:33:21 +0000 (UTC)
X-FDA: 84698228202.18.6D7252E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9A1F620003
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 20:33:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iSqUC9gi;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777149199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5bT1Gy2a7WVGqbDRfe+wQUgFZmFMVwYzzwdsirBHXc4=;
	b=aZsK8ieesXx3tZ0hij15QovVwEPxlqBNV61IbO2pHOE+w6p87/uF1CBNAGFOr0zjsq7ZFx
	+3RJ9H6UcOR2eDd/2hi9pop9HU3JGSk9j0/1vkzsuURh7zxuNg0Cy4cGNqvvP+J1qYPpeQ
	XAz8y3aHE3o3YvO9goeR4um0E/5Gyks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777149199; a=rsa-sha256;
	cv=none;
	b=2Uk/7j7X9j/Piqd4cPRKliAnc1IeTm3mT9NkxYUoi8EFOEE4BdmKsxFI4LrQVaSNvPp4vF
	+cu4p5nA74+pPhPL6qYN6kjWnfJhIXiHYVTDMaffCKly1HBxcNGU+jmyt6UklTmXWJeS1W
	NWcOEu6gnp0Vl6uNCc/eo7xm7hivM/k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iSqUC9gi;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 15D116011F;
	Sat, 25 Apr 2026 20:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985BCC2BCB7;
	Sat, 25 Apr 2026 20:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777149198;
	bh=Ru1qRcWk4w4e46Ipw1oHgndub0LRIDQasZkRB/XPXiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iSqUC9gi0v1ghuB0dKd16JF1JuCth0ib8nKBB28OGzN3G8aSh8lHl+tfT53OrtBJr
	 35FPofwxvIug4+ttP/B+1FjDbUu4jn3hwxd1Cy7aQzRzwmLzSdserTB+sWniV0T7AQ
	 9S4kGhSCaV0JhbAFbIlB7q5toGQWnCy1aiFpflMR0OTm+sLByZvbzQIc6L7rPEQ4WO
	 eD/VZ6ZwFz2h/dAHIpcudJMbw0643r5Z6S6P9acXcs7aJcduFCY6O5S0Q/SXPBv37K
	 NDIco7tJvtPYs97xMFcxUk3Th6mYV0XyNrvO7OT+EEv0FYJtllyFLP9QKXHUc0b1Bw
	 NTSjsyzJx3CNA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 1/2] mm/damon/stat: add a parameter for reading kdamond pid
Date: Sat, 25 Apr 2026 13:33:06 -0700
Message-ID: <20260425203309.108879-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260425203309.108879-1-sj@kernel.org>
References: <20260425203309.108879-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9A1F620003
X-Rspam-User: 
X-Stat-Signature: eo7k5akp3s77g166dneanhjfiade6z9h
X-HE-Tag: 1777149199-288998
X-HE-Meta: U2FsdGVkX19g81brdFtLtDCOaF5BWkgMPbZ4JdfJ1McUaI6P8ExsBOccZTTZ7Cz4bXR8DJn40rrUd3wcY8czbIxI/COfpwo6d0SPItwHfvIFv1rApf2iL8qIr/Cc6Z0draP2MlHh+8+vZgX4ewmw93SQhHh1KiqRKHcE6rWoxDnCfeKpwC63l62sqlOpsNu9xKY4DYepdpE//dfT2mainHHbXH6GyP9WMlCOtZHMuj+9gBlDA9K6Tx1CV62xOKOcsBQhz/HVTVnHBUW06A/W90bo2RsVYswWuEoGiPNXy3+oqskVJFf3gk1Gw1Th7BObyYZV9dnKyXBa3Ea1HPQZ+r3QtH93Sun0gC9/kN2mLGCJZ4CdZR4R3iYbJVno9VrXSZCfg3eDNNydBxoBl0wl3f0zVXRcAXMi5DINzm9fxJY4LCjhQlFfD1yiGFNaxNFjnQt0ia1oxhMhnHSMN75LkWNQgHQZRi7RywtQUcdAipaykYlg1cPJ8JNaA6Lc/j70JuhpKgHZiLip1AWWCbTQ9C1Dva6QZl/ewpQEs2cyCV9SkQNKCmqvyofOJGm23ERJfgzIapa3b0CwB90V1osOO6Du9XJdpwCU2eoQW4XOsvuiVdKYrJCjPzduLPI5UHG7t7IlkkUPZxCOVE4jk9zTqrUAJj/xQ5fHTCPlq1zKMtGBajAY6Fbk/u30ErYACBCzjqhuZ3zH4+P1V8MQzhVanEKb8DYIb0FItwL5MJ/kUweQc6+lv8h1quWA18R5RLAtuQt2/P1vOgmvcIdiKZ5FscO5EdB40xwdqbw8g5GHB9bR9wNntB/BdQvB+PhsV6hI5a4XWZdzpDqaDqztpXvYgk5yniG52HJC3unZtreAFvAOdPD6f6lwOkCd5yrripZajzlilAZi49S3/KfT9fpQkBwivm2Nc8AKdYaS2T9X3XeJ2N39ZVGldlX6zbvW/U5W9DzxeMwx9xHbZiqBBWc
 7mX3O7tp
 3c+RFeXFEHpWfmxXHqZfbplxoBZuC6aFJnEIK/Sxp7Ml3l9tAXIJk4ZzfaEXoLXXyWkbqQdWkiFvylMXwqr9F0aG7UL1ClEYn9wE6Rs2wpLeKSXX8h33egqnLKdCmrrmKoufxl/elWEpJQdbmhRIZlz1ZxvpIOINdU3Gnzjaz4jJx/vGIPXiQ4AJpSEan+oVyG/NwGLvNDcMVFs4UzjkqSQ12s/tl9AKWJKOCv//wnfWHVhk=
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

