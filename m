Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65097D3B7E1
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B76D76B002F; Mon,  8 Dec 2025 01:30:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB26F6B0031; Mon,  8 Dec 2025 01:30:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99F066B002F; Mon,  8 Dec 2025 01:30:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 83A506B002F
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56CEA52F57
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:25 +0000 (UTC)
X-FDA: 84195329610.04.38E5469
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id EC1501C0004
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CNkul2iS;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KaVu/MsMQYTGgjIt03B7W0E1gqL6fX5TefCt4zm3CwY=;
	b=cqfYvqXoDv+GEUA2ciKeU9PecAts+UPWCuKcrdp4NhyTtflpzR/4QiSbzlH1sYf0QkRRhx
	0jV+vuDNlE0+8mNg0XREZhwVEbw2t1NJ5P7SVcwprO6hAi+oMHZY/rqqu651BkA40DnitZ
	QIMKV7XCxBzJ8ZPI3XWotnguP+0ZmFU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CNkul2iS;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175423; a=rsa-sha256;
	cv=none;
	b=shIx21XnqDkh/lHBfvDcP04uQ5HRnSDR2Hnv/dgCX05acLcMD09wbigWZX9xSDakx0MzXv
	AIk7yyvKtcC6L6dVhmwWg3JE+vO/DrsFg+A04uV9x4YeZiXHKlaKHs6JSWSPL269jarTZ0
	xRz+47vB9kB2kSPeMj+cN7d73eQwQ/w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 78CE860178;
	Mon,  8 Dec 2025 06:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB73C4CEF1;
	Mon,  8 Dec 2025 06:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175423;
	bh=QdvS7fwjEHTygGGbOIz6Ht6d55+sgZP4hFmu5IDrnVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNkul2iSXsQ14qVswyuoPgh7WhQlrFK6KDpfr49NKoT7+ekP7VI1kiUzeVKw/h8o5
	 e124ct7G+hZnLujpWYfVlVuivbilZbqhHwqW9M1CxxCFQglSa4MSmyW41DDg2xh5be
	 BJ9RdcHt6Cx3Rkq0Sntjy0EJYIWb9j50EZ30Uz8KVHB4rN7XtcXaPeox7XYH06WWl0
	 YQ/porikMi9xZ29JGuupPckTOXxHaONboOpTuzcMVLMTCIr37ifXnpcxZc39K7I+Fi
	 dfb+hqPYhzn7NLhLr5NU6dS0k7hRCFxepp0vfR7fQaHALUnedGPYL8BZMOEy0EjnNa
	 wureveNDGsrVA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 23/37] mm/damon/sysfs: connect sample filters with core layer
Date: Sun,  7 Dec 2025 22:29:27 -0800
Message-ID: <20251208062943.68824-24-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h7fznmbfentyu1pxdgz1uuz3qj11um35
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EC1501C0004
X-HE-Tag: 1765175423-562729
X-HE-Meta: U2FsdGVkX19iE11xdiybWRnN/lYtb+LY2mkgEVZe+7zvkfo6JLuu9YKz7qB+ZIskim5z72ZHa9LmjF5l0tCGdoobGlzute7ij67594WAFn6ScBwHTd0DqwJ24ecjcR5GEktid1F84Fi5UzODC/nfUiknZCyDfq0PEvXlZYv8Se/BbrzLyfaQDOpz+qf0NKzRqnIqrljR5FPRhBVE5PkpbpQC3oKC0ChDCkg4Gg/jp+leN3CXG6I/LjrrbYAGpum3qUK77o+y8U0nXdLSJuVZa8im2CxH+gSQvXl2+cLkn1i6K9YK23P6yUQU+B3YNDX9XegzH1EREPfPe9jPk6L6CIlfge5xk74+EnVj+hkAlPNVJKGqhfG12Y7OvFEryF/2x79vhYA33b6aC8/yk7xjY7sSZMXbzNPCuXQDnkPHct07UP3hleaJ211IX98KpDK+src5Hvd0Yy6vA56k2ObI6yFd90Ju/hVF67r2CxL5FFgtYPgLcPiLiKGVhINS1Tev5GUmf4yhCp0A4PA5QMb1JrzvRlceG/nilIY+abzsUrv3n+UUVQYAuezdn3t8yy5d7tZuDcjjZXC0AuXd2rhN3MkLp2EQ2jWnpnkFMvq2KE3eCBQ/QKhfKv4lSwD2h/jCPsFJplSUd+pTVO4p2Q9JSgkfCFBn6pMrVSWCYbpchd8rW8N/qAPgOulm1aS7+xpdMtB3qmW+DGVUG2g6pcHZXEKDc56YZxpAoRPxlARhE31EoS3JRRY6Qh9uNSN6RTU+jMU9vVigHLFFmtiY6lpRjBEs7ar0G/0OvQtgWsQlB30wlpPC48IfIlBedBH4t4gHg2jGDazm7gmMuJzXD768OZ8zPLBPe2RTaUAet7yLeIQQWqx18uPHofQdFLldEqLrDwmrl8LY49zUflbMndnzDs2mNXBnSkQ+6gYlibWDj4lsFcq4UalQfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Only basic file operations are implemented for the DAMON sample filters
sysfs directory.  The user inputs are not really passed to the core
layer.  Make the connection.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index d6b0b6513fd1..3aac2aea6b0c 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1952,6 +1952,35 @@ static inline bool damon_sysfs_kdamond_running(
 		damon_is_running(kdamond->damon_ctx);
 }
 
+static int damon_sysfs_set_sample_filters(
+		struct damon_sample_control *control,
+		struct damon_sysfs_sample_filters *sysfs_filters)
+{
+	int i, err;
+
+	for (i = 0; i < sysfs_filters->nr; i++) {
+		struct damon_sysfs_sample_filter *sysfs_filter =
+			sysfs_filters->filters_arr[i];
+		struct damon_sample_filter *filter;
+
+		filter = damon_new_sample_filter(
+				sysfs_filter->type, sysfs_filter->matching,
+				sysfs_filter->allow);
+		if (!filter)
+			return -ENOMEM;
+		switch (filter->type) {
+		case DAMON_FILTER_TYPE_CPUMASK:
+			filter->cpumask = sysfs_filter->cpumask;
+			break;
+		default:
+			break;
+		}
+		damon_add_sample_filter(control, filter);
+	}
+	return 0;
+}
+
+
 static int damon_sysfs_set_sample_control(
 		struct damon_sample_control *control,
 		struct damon_sysfs_sample *sysfs_sample)
@@ -1960,7 +1989,9 @@ static int damon_sysfs_set_sample_control(
 		sysfs_sample->primitives->page_table;
 	control->primitives_enabled.page_fault =
 		sysfs_sample->primitives->page_fault;
-	return 0;
+
+	return damon_sysfs_set_sample_filters(control,
+			sysfs_sample->filters);
 }
 
 static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
-- 
2.47.3

