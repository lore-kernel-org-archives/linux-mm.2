Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03C5CFCB618
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B2726B0096; Fri,  6 Mar 2026 10:29:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93AC16B009E; Fri,  6 Mar 2026 10:29:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833BB6B009D; Fri,  6 Mar 2026 10:29:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 64E386B0096
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:29:28 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 319691A0637
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:28 +0000 (UTC)
X-FDA: 84516022416.01.084AA81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 84C4240012
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J1fm2DUI;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772810966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEoOZh4aL7JRuh6wAuw06VMxdtW54HJvRP0C0PttKWo=;
	b=cTPQsVdwxTe6+Kk4yOM4+/lyaMVGmEdwlkG79B2JtHcgRiWJ6wlJJCU+nRqysci8bk0eIU
	FWyUZC3I46l75rIjobTjcCEI2eSiB6ThEqNtyqYz3Q4kQvfUExcYwIFlxeAfiQJy7rU54j
	5NGQaMBjINFRHHj4eqvGVlmXw4oSLf8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J1fm2DUI;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772810966; a=rsa-sha256;
	cv=none;
	b=wl6gKKyI6Pw3bxn2oMnkRSij+qNotwFqZqbtf4tixRxvhEQ83EfcPpLFCStUErzupEAxW4
	OHdhRNSu5LbDNaL7nsz/K9c8ZQmWZ/1R/lhgD7giBHgI5WWPYT6zTaeJq5eV+hjRFIdCMK
	zFt8KxdVXhgfyN0xrEsWtLM3oa7ClnM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DDAA6442B6;
	Fri,  6 Mar 2026 15:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5E2C2BC86;
	Fri,  6 Mar 2026 15:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772810963;
	bh=7QL/RYpMYPTB1eC/p0ZRS1BwtD3YKWYXznWIGxGADnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1fm2DUImHlRnIE6oAsvDturwnznPySYDUcJwjnRiMZUOBbLVdOKtU0o9SxybtH3N
	 kZvG5pVzm2eyVDZbvN9VlGRBCeh2sqgNZmagwb4439kVElZSxXquDR6a3bhNdo0zJm
	 jCJsENfOOO98J9RHHxi9sy005TXMAtrYcS0ZsjRKAcvcBNWS63zpxEGU6otnmqPVLK
	 9Qg49J5iBrziw1YPJGTR1YyxFckMgFkEEZzY3ygQlWk2JaCUVpTJt/8DxJrG91jkbw
	 /ob8qXkoKrmLTnEuhpigEung45LpNG6GhWhxu4TvBoRrcTQBUIaaFNHrNiwewgfTOg
	 hrHbX2AQctG7A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/10] mm/damon/core: add damon_reset_aggregated() debug_sanity check
Date: Fri,  6 Mar 2026 07:29:11 -0800
Message-ID: <20260306152914.86303-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260306152914.86303-1-sj@kernel.org>
References: <20260306152914.86303-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 84C4240012
X-Stat-Signature: q4yt8da14ntfjri37dif6nkpbiit1fh3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772810966-482918
X-HE-Meta: U2FsdGVkX1+nhb7V5Lmatdg0qgdQzZqK40m3BZJVlWZUSDdiSq+ro44YQdc1smn0W4/M8MA2I1qqhHJuPJszi5UgkcWI/L5DmetIrvQb4kMoruSheylRyp955BrI/LnkFNorAgMBDL5bVjGsuSB5Xb5ZTeaXov4Y0Vz15s1mMea3d7rfzkStn3d0OI17sO0HkoLnFlRcfQQy1Aj4kYsBkIyT822fSvhVdnVLbe9NMNH1sjSlse/g1OIGwdYzJXX63qQDIVwYqGqatAt/eZDPR1rgCnlZs6f0UZuDSAJvdDoA5u8RuajRpycHvvGiW+gbJcMxLWrgbwpDmFaOu/7Vk9QFNlw4/0QX0NcKlhDBRTVPVcuwCHP7OTfsBBRNpm+41sOpm74rqpDYQzxV0ww5e/kofqkgrcxQcjPd11XWPyfL79G38lpKhXZNpU2GObpMCwgxnBeSTOUavgDaSwh4M1qBBb4nFITVXUQgGm8lrBMnJ9fl51tfiZEdmUefh9GwBlYju33TS6sIepL2q+Zr7yl20DF/4KNaLt9tzk2kFJW8e+logPN4UGo83b8lcGnrIt1wR+Y8OUFpUwz7AROOZRQmoFdJHJU2ehPTN4JXof3/maGZvjDfvAONBzxD48GWT7AK4qnbtI+cpozN5uzwj4OwqFgeOLStYJDSRzNss5k+LGgLei/Dh7u56VIL4ZpxfQ0DA8sgoiRlUzc+dmrG8I30Ee4y5XjA78UHvrLYQTEwv18DIYoiTr8JSTB0scGKDFMRMnDOM09gio4b6WEYbJEMsoxeYYUW/RlW+FxxN0cuKR0x0LkrWGX2+aWYcDWr4J4wNXfJQOq/gAHCSGhZ5TIkab3Exuk9JkwmRwJrxq3IRbdowD00MWXKIo8Te7dgCZopqdoUkzKCwIjO3rOZendVo876uIYYMnl8mEYcNFlaUZRdu9pgmAmA9nZoZgyNTGJuK5WdQUaESJrdpGj
 IGTLTAhX
 pp19gO++4/0oXgZlpoi/5LkpNAQp5y8UiRyBH8v4wem6wYlIGE5UrHkrvWs2glvs9uvHLaV97sIBa4KEsVdEJa1h32pOFxqDoELv3YmsQfuP/5deypS5GCswpEGo+0zPjAbrSH+lpO9HqawSwXkvX8oL7fKK8UzSv3ASxgMiRfZoi8BAw1OTsASRXe7STiPrYjXQIdzEsiW4KSyOqXGitiv2P/aqepNesf8oiCJaugDz76f0J3vyOqT6Af0OWeqW+aI3vy9uNdSK9n6LrnxsM3I9Few==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At time of damon_reset_aggregated(), aggregation of the interval should
be completed, and hence nr_accesses and nr_accesses_bp should match.  I
found a few bugs caused it to be broken in the past, from online
parameters update and complicated nr_accesses handling changes.  Add a
sanity check for that under CONFIG_DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index be2300cf3aeae..e8c44541754f7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1666,6 +1666,23 @@ static void damon_warn_fix_nr_accesses_corruption(struct damon_region *r)
 	r->nr_accesses_bp = r->nr_accesses * 10000;
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_reset_aggregated(struct damon_region *r,
+		struct damon_ctx *c)
+{
+	WARN_ONCE(r->nr_accesses_bp != r->last_nr_accesses * 10000,
+			"nr_accesses_bp %u last_nr_accesses %u sis %lu %lu\n",
+			r->nr_accesses_bp, r->last_nr_accesses,
+			c->passed_sample_intervals, c->next_aggregation_sis);
+}
+#else
+static void damon_verify_reset_aggregated(struct damon_region *r,
+		struct damon_ctx *c)
+{
+}
+#endif
+
+
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
@@ -1682,6 +1699,7 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
+			damon_verify_reset_aggregated(r, c);
 		}
 		ti++;
 	}
-- 
2.47.3

