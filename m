Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26A6FF9D0FB
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 23:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B7766B0089; Tue, 14 Apr 2026 19:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E366B0095; Tue, 14 Apr 2026 19:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3846B0092; Tue, 14 Apr 2026 19:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2A0B06B0089
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 19:59:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD62BE324F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:59:25 +0000 (UTC)
X-FDA: 84658830690.21.EB95889
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3A0E9160009
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:59:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BqCuFpEJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776211164; a=rsa-sha256;
	cv=none;
	b=GHEAlJQxD2piIP5WiLGJ5KJD9GmpcYPhju2Pxx8lG7S1H/RmN9dWUj+igCER+Nmu3VhI7l
	D01RFr5+ZEPgPv/BE4xuZoe/rltoYjx53xWDobSOKXlh2mhR3pxoebsW48dUVwzhnuEzOI
	yIlXvdsaqiXQOKbvA9H14fc2u38TY2s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BqCuFpEJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776211164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRHz9Zci2FqUqYYBhFmgB9/Dq+iNSl8ieRiB9CQ+sPw=;
	b=5CJwgFHrRVL13c9ocdKVVM5yXdiRdRvhUmf4wU6J4SmdoKInoOesp5bNDVeryTL3FTjr33
	uUJQCGgpKX5HUaPeTi7EI7PA9apCLSyFDvCjOKLc/zFAqeTzVImzzQWXBBrzCiYgBkmfSM
	Jh6UXfwbMVAMdrzoEsrBbJrBv7kNTGw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B51A43DF0;
	Tue, 14 Apr 2026 23:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A69C2BCB7;
	Tue, 14 Apr 2026 23:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776211163;
	bh=89KMBZu/gh+eCPCY4tm5mE3w5HQv3CWTICCzSSCwLjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqCuFpEJzlNl+RkLq7nmIRer8zwazZy31XdNlcdw+vRBT7cIO4caxhMKpQDa0UbqL
	 OEeuuwNCrQWDr/JOjjCYlaXtmmdWmaGS0mbRxEXFEaffIRGcDzn+sbWqoO16D+69Bi
	 RIvF/xcRqEhAAdH4AMtUUg4uiRlcqNCVbGHoUKeEaIkV8hA4UDaEhw7oyUX64k5xq3
	 DNpEqoNhW1ck7FhWhyPpYFG0z//8ilRNUGCclUJxUtkWCnoAw5Ut8WH/SMcIMi9CDS
	 d0aBGkx+Ji4ZpOBmlQmbFcC3wkLGYDurs1xVhj6D1TSLgeQ17iCvsBh+NTC05xBCQ/
	 xhUB0Qf0LsvNg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 1/2] mm/damon/stat: add a parameter for reading kdamond pid
Date: Tue, 14 Apr 2026 16:59:10 -0700
Message-ID: <20260414235912.98174-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260414235912.98174-1-sj@kernel.org>
References: <20260414235912.98174-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3A0E9160009
X-Stat-Signature: hu37jchj8we4si7igxmc871awumujac3
X-Rspam-User: 
X-HE-Tag: 1776211164-191421
X-HE-Meta: U2FsdGVkX188J5GGmlfDNYWgaCsinRvm/sJ2ULiIqUCAnYr5IJ9Q9PMr0vIlgwBAXoUOuI21PkwAFvltMx8ONXy2RaCkRnLVjIPiq1dPMP1dRPx1rPuhFgnA8Q4SZGwne0exnUnKICXXQA3T/DZVMpsEPxoHP74IH/GyVByh8DLDL9IWw61zCY2uKMizmKlMPL1k1PHJ71TtmFZTc9M1MTeZeQsJdicUlNbj9xTjy/1DibsRnJSA1FPnLP4N2FMCs5ml8NC8I+uvXNmFTnNbwyBVfNYkfH/P+LmgcdGV+sU3FTzV3v1WIi6Ygt71+A+3KAld8wcUcTnfWxzH7LwjVEDEq+AIPz9dJ5Ew7/40vtWOabWfwuZAwT/TbZ7cdUBpLcybrkFm2ge/Fb1sdsA3L9zh8uM9ualrmJh+22HDscXUb8t9GZy7X9obM+znzhx2+oX02GoNkkPZhl4SpE1tU2M1t4eDBUeDbz+IsvIuuCgiPJN+5jltK7neXtNoDcCBvSTlrddMY+kqwei9mK5e5W34o3BvuPfRPyGc5+GHGVPMdf/TkyXWthTKqdifxwtgJjaS8+JUHtd1IQI9MEDKkHHYgDk9H8vab0Ge6Bt1G0aijbaO8V+7KrD4HVw065Sjh2ZF/YKsKQ1Rp5hP9a+HRd4sIwLhpAhSVUqzg5nmKx5NFS0+AY4DbxzHTwLiwgqZAhojodz+D3cwSm3q9eVnlW9I4dQ7UIsM5JfoEGftQKqGc5Nidwakc2/2xkhsiuW0r1HBnPKzZH0NRbGcpHaxi15T4eucup3KlaG3sVH78BIm7FNdgKXuz7unq1oWRIHy0zgx6rGSUWy3HlUyGOKaq7pXz8r6yIIVw1yy9HTTreMkrdKo5yYCwXLBH48csafV71wLBUcHLUXvqcp4vxl0Wv/xAOjWe4GAmlhsEbPeDCPILuFfvLVcJk7LaNSY30hWWJHhP0CKU/oFtbXWjIR
 P7oddBGv
 rCJ1AantREh9z8Ayp4/RekcWTN3FIyft6f34ZUd+AV8UKQy5TMqgywEGK53R4eYK2sT3Lwb1WmPHliW8Q0HlHfHSjJSql/onZ9pqh8b4ZIOjYi4y5fQ4IH9Yvw6AEjo/9vKIzv889V06MHEEfvpzXkY1c3d5b7YBTzvjtalBu+dCBfpqCl/KbcBqfId/L9JoBG5mJgGzZJN7iAnfXx7EL4YKJf2soLN/aG2cQFhkd2RigEiU=
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
 mm/damon/stat.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 99ba346f9e325..510c593a313b8 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -44,6 +44,15 @@ module_param(aggr_interval_us, ulong, 0400);
 MODULE_PARM_DESC(aggr_interval_us,
 		"Current tuned aggregation interval in microseconds");
 
+/*
+ * PID of the DAMON thread
+ *
+ * If DAMON_STAT is enabled, this becomes the PID of the worker thread.
+ * Else, -1.
+ */
+static int kdamond_pid __read_mostly = -1;
+module_param(kdamond_pid, int, 0400);
+
 static struct damon_ctx *damon_stat_context;
 
 static unsigned long damon_stat_last_refresh_jiffies;
@@ -260,6 +269,13 @@ static int damon_stat_start(void)
 		damon_stat_context = NULL;
 		return err;
 	}
+	kdamond_pid = damon_kdamond_pid(damon_stat_context);
+	if (kdamond_pid < 0) {
+		err = kdamond_pid;
+		kdamond_pid = -1;
+		damon_destroy_ctx(damon_stat_context);
+		damon_stat_context = NULL;
+		return err;
 
 	damon_stat_last_refresh_jiffies = jiffies;
 	call_control.data = damon_stat_context;
@@ -269,6 +285,7 @@ static int damon_stat_start(void)
 static void damon_stat_stop(void)
 {
 	damon_stop(&damon_stat_context, 1);
+	kdamond_pid = -1;
 	damon_destroy_ctx(damon_stat_context);
 	damon_stat_context = NULL;
 }
-- 
2.47.3

