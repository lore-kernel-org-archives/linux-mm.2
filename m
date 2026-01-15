Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A5FED44C63
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 15:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95BF36B00A7; Thu, 15 Jan 2026 10:20:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87A766B00A3; Thu, 15 Jan 2026 10:20:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667876B00A6; Thu, 15 Jan 2026 10:20:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3A3836B009F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:20:56 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 022C31B8B5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:20:55 +0000 (UTC)
X-FDA: 84334560912.06.C9FA4A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5128E14000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:20:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mmUrtir3;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768490454; a=rsa-sha256;
	cv=none;
	b=1dSUWNo9ZwYhCtcbTQGcbmi77xqYFvndkpbayvs4ggzJ/n+t2I2daD4LDPcy9JIWDu40Xb
	6pN0TnNrcrajAqiVWiLkyIiLwAhqRxp7uzZJ/ZWklw0kO56U4tceoTPHDOqV0KJ7HVtOUe
	WlMfVgEoRxCulDVOFYrReoWHI7LFcLo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mmUrtir3;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768490454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P06cKn+cIfuRDwAXZjSUEsdqZUz0r+BWPlXArvFZ08o=;
	b=FG/sEve7bCz88vq/HgCP2oEQ0+sQHnQIu1GM8ZN2ZQXpV8d4q/C0wB0qmsbNXcWwFQDwgX
	FG1RD4wn4kchWmk4giHXndti9/iS6nugaYbrgeS15XxdfwZmLQ/yq3MBWsArVADCo8OkmW
	0AmGuOqmzp/pgDNH+HVutTF7Run4hPk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C50F43D58;
	Thu, 15 Jan 2026 15:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4916C19423;
	Thu, 15 Jan 2026 15:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768490453;
	bh=1IPEhfIuLNwm0i05nT9ETMSk54stCMKIEwoga36jhG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmUrtir3+hVR4Mbud547emvQzHs+RYh7LX8xdBcT2SrKDVGqkZTAuU1EFqltZIXKl
	 9uAk6zpfvcfInlVcqJcJru8oasDn4gdYgO4G4oPAl8eBozA+j/SPwWxbLNygI7Vf/h
	 zuxaqG75HrkZXQg9ffN1bfOenK3Me7Ds6xfAfDYfDg0h9A1gPs8jO/wx8c678ninhQ
	 9ig1Q/z/IElFee9dHwqy7wiczstggxeEOTgHwW6sdT/Bl5LdW1U7KRiLIF8B4o1XVQ
	 YVR7JVEQxpfpQOa1jDdvFkb7l1bOePJgdXjwxStmmHabVHVz0HoCITr8ano4xV/vuv
	 MRLxIRCfMeqTQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/5] mm/damon/core: implement damon_kdamond_pid()
Date: Thu, 15 Jan 2026 07:20:41 -0800
Message-ID: <20260115152047.68415-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115152047.68415-1-sj@kernel.org>
References: <20260115152047.68415-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5128E14000B
X-Stat-Signature: mx6ofs4dy7sc3czhojmy7r4d4k1zzhxu
X-Rspam-User: 
X-HE-Tag: 1768490454-167691
X-HE-Meta: U2FsdGVkX18AgITqL+JEuoITNfugBGdzLeXUbbU/Mx1TFd/qb0wzjGFyVCXCafZl8CAMxflWBV3fxFdtH0Ino6lhLM8PI99SOS/r3vnFSXNsS92uH9Ah6tztoE97ThacSt6Leo2X+ZaenEAzbT5w+0LuVGD5i24ORmWQJc8HUUa5gkhJNGz2QNTdJ+oDKuqIYGJ6I4/U9YkuSq1Kib4qqyvyzbbkg27UezaJjHuVT3nANF2gAgN3wJpCsWHkPBKlrD/SJYdLmbuvnC6mAFaA3f0G/YtxNSGHU9wcv/NQcYbgUwcHVSurj0JSW0+A2WZLN63Ejio82QKG7OAiV55rWLCDbjf9UuE+SmtcxM4z6csvRQJ1ZY1toqlm4mf6hjE1MtyVM6qegIE9GcrTkQZ97LYRkFOFBOY79cVQIndKo5fB7uKwHZgzr0TpJ5x9iVRniwYwA0rlYtgVVJWFRykUzdogr+2d7F6wB3Qds7o9YtJkFXwumwB9z2wt9tDjQhCLo588Y2iRV2FMdVe7TWxeTpg2im9Bwq8Im4J/uF/FEveohZaEHdWUb5FxA4TDCgzhsJS3qd6rx6DfCVvF7/IbOmVOm0ic6UWqBb4zVFVlMhDUKAsAYvlo4Qw/uFsNde2SddBK6oXwZsSGRrHzUqwjGiEzSKbGv/hlj1xkIQvXalNQm8GRExRDkEwE+lc+wMzCI5qG9aDNv89PhIboy3xVeFmlW//dTRV7XJPHwLE2BkCbv3MgSsiR8UI+AYucy5AcoBBVLic43oW0ew69J1hesXTfpRV5VgZp8wSLF/s06xrI61AyHWnjFe8Jgu4msCUt9OlqOeTV0AersSpLktDjp+z0LO3RDp6+PCrglrt8MQ5yHtFve8prfMLNSSbJpMkCFacq3oN3+C5PGj8LFP9DE8fK0fyCmdVVwp5w4MuTSlxn8CmCXiduF2eq49zlWed/QAMxvntSBWlDKMVQ98T
 6wQDwO7m
 9n5f8xJSsBqI1gBl+xu/cbTQPxey3RrCAbKO7fnEd7DfNRyF8M3bqk4IZFwvhWmO4Fi7LuHrs9zSnIUB5zTLx+ySSDCcrQWXm8RCplgZAL14WMNPww40/CCK+QZfWn1mJJds3ta8SrJzKx5K/Kb20xQBYEcoZayW6IlfCZxVcIANNSJFU+kG6W9yb6R21q0xflAe5wQkXdXAc5kdxj3XB7k6jvreFIV61NUzeEv/pi+RCouNZX6uE0EhH8dRzO0O4dFpodH3xwSAPtAnM++xcV/FLzLLWRu1yZod2v5N3KVhJZ02bH3xlvqRFEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'kdamond' and 'kdamond_lock' are directly being used by DAMON API
callers for getting the pid of the corresponding kdamond.  To discourage
invention of creative but complicated and erroneous new usages of the
fields that require careful synchronization, implement a new API
function that can simply be used without the manual synchronizations.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 26fb8e90dff6..5b7ea7082134 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -972,6 +972,7 @@ bool damon_initialized(void);
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
 bool damon_is_running(struct damon_ctx *ctx);
+int damon_kdamond_pid(struct damon_ctx *ctx);
 
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 729a5f7fac94..81b998d32074 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1442,6 +1442,23 @@ bool damon_is_running(struct damon_ctx *ctx)
 	return running;
 }
 
+/**
+ * damon_kdamond_pid() - Return pid of a given DAMON context's worker thread.
+ * @ctx:	The DAMON context of the question.
+ *
+ * Return: pid if @ctx is running, negative error code otherwise.
+ */
+int damon_kdamond_pid(struct damon_ctx *ctx)
+{
+	int pid = -EINVAL;
+
+	mutex_lock(&ctx->kdamond_lock);
+	if (ctx->kdamond)
+		pid = ctx->kdamond->pid;
+	mutex_unlock(&ctx->kdamond_lock);
+	return pid;
+}
+
 /*
  * damon_call_handle_inactive_ctx() - handle DAMON call request that added to
  *				      an inactive context.
-- 
2.47.3

