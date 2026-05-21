Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F96FCD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461116B00BF; Thu, 21 May 2026 10:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EA2A6B00C0; Thu, 21 May 2026 10:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 215CA6B00C2; Thu, 21 May 2026 10:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E71F76B00C0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:34:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A79F11612BB
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:40 +0000 (UTC)
X-FDA: 84791673120.22.89647F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id ED00C40002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AMUsZIf9;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779374079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5i2WVbg2PjBsmn2NfpjKEh0VGjqNajgL/l9BFto2EhQ=;
	b=LbRx89oOiMgk3CbGEGzTzbpLilGeMrNEgGPVVrm+oqxVKg2CKe8PKw5Cb+B6EjYsPCLB/l
	fJq2HZMUByb3lzeu/QOTOiOrvfb7ytYToJvPvF77hEUzvDN+lX/lFvlKmAjr+3+WfL88pu
	iB1EG5kalagAeSBlgIoSI5HS/p0Aic0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AMUsZIf9;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779374079; a=rsa-sha256;
	cv=none;
	b=vQ5F29m0YTjOxMSUQ1JS6TBrpoWjA4QbAsKGmdcrKpvm/iOzPD13tEExKBBSYRqdQYa99e
	a73fCxvsuskMjPGnDA/GY4ZBen806SUcsZgANLgxk+YZFs9eU4V9mo4bhGyAv5yMZugg0f
	nf8zC54EhGEx2hHPcSGj8FKPGbed5t0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F1A7E43DD7;
	Thu, 21 May 2026 14:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9E11F00A3B;
	Thu, 21 May 2026 14:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374077;
	bh=5i2WVbg2PjBsmn2NfpjKEh0VGjqNajgL/l9BFto2EhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AMUsZIf9llHaj+LMaBC6OfmqVdMv4o6AxcDfQ9KSHUD6w21A49A9s6lLb3X0UmsnD
	 PM+CdMA9+zuqcZaNQ3MzcLIF+Ot9zyn/xFMifwlfsikGP/+N28I2xvTa4WaranbdpA
	 vYNEEAz4ZsRileTbMkA+D20t/vv1ZWxrXvfV22ZxUEbIvTYJlPQ0QStRRYPlOhqlFP
	 P75wrk+PZyWQQpu7eWcDF70i70vYfRTRNz/co0tQHMBDyBraLS1VUlMUGZzkPs08lK
	 Ee0GmtRDEaWJiOwhrv/EuMO+1Gtk/fB7ZHP4uwOYZZ+eunW1riAQX6A+xVioLJ3XEk
	 SLlvX3nddJAZg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 01/14] mm/damon/core: safely handle no region case in damon_set_regions()
Date: Thu, 21 May 2026 07:34:11 -0700
Message-ID: <20260521143428.83157-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521143428.83157-1-sj@kernel.org>
References: <20260521143428.83157-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4su3drgibcrf4w9yc571deyketkrypwh
X-Rspamd-Queue-Id: ED00C40002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779374078-825738
X-HE-Meta: U2FsdGVkX1+NPqqraCnAFc+ObFyJokW8uRqPvMlX6WnugIXK0FYpHUKB9O8j+WeqxyBbKerazlszywmrq9XklzwA8FI7zZ1Ki3I1/sYB26XYxQyEhp3qrbBggSXQKbYCdKo0/34kMZeB5rgYwyFHOA76bgLhMr8uwClaz1e6oHmvXqSoThrLQvovFZPEP9n+qngjhuNdLqxLC38Rw62WFVgjdFCaH3R0VtzQZq+kGK2wn9wjYWlrpuMNoZROldum61cCEX69ZcUbQm7I2k6yAArnTXW4AdQR0/8xRQbhV4jTt9FIK5+DGH/4l1tO8WWvt8cIF1jpCacBuZ7E0cKevMeRisAHHTSllvCxyL9g3hkQKE7/rcmJjI9czeEpgmUoP9Ggr8cIPwt2uEMdDlgqT76r77eT02q5yhUJFhWowIDqMM9W2EtJVhYnjF9IPrscgvO865JGjB3XSjJ47/FEZru3YEbWphPftVfxZwvb47FO/tqpRijd7ZI1yPu//HDcqi+ajr86+8qmObL1GbaLjDxQHm2ReaEzLqe680OHsaJk0Pgi6QYQp1xnBjaeHm8uN7N9GwVdRslBrc5lETWkbdnjjBBHKXbAJwfFnbnry7JKrtnRcEG2Pboo6Q37H09Y3yqFMdDkFnjMRkr3YIQsyKMFd+r/tLsAMU2Ymxg1FmMSLFS71/lSfpqMGMKdXsM8QL77zXErQ16lVlQ+4PdCXhvwzKkg8VEPUM9moOsGFse3rnr9rRhcCGsfONtIdnxz0iO8C2YB9NMqScUwtmKADVS4fQh2BITP3pL/ch3KmiVTCplrSAlJWLzc2JqEdDju0d51wuVBERR5qgTmnYOqKSBOTLnNcInzILtVhyJwWEzPyI29PjjckE1raUTRj4LrAoUNge9x5G8d85Gz5d7q1JYLmhsn1U8MOqmYU634HCRc87IvQElqgVblvyI6BI5BuvzG7pRYWoMtLnte7Rz
 qjnmkAVq
 QydF239PNx9K46ls+t2vJDPo8X0R5LbLD2YWxl6onaWqi0+ocryyLstQLSVNrI08JvqK1XZeH2uhfz7IrjOzQaiC0K4XwxPWwRvJbtIHvXljDd3mcZNxMHu+ulfpRHyLIcD1sUdyzP1fdtxCCnpSI8+VCcVITkyuKJXqt3Cw7jwtnz/4sJ/n8LtYiEmLwN5XHx9qjm9OWtbHhcsAaxl0euhOsjbdSnNimGgNfIO5b95Zd89M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_regions() calls damon_first_region() regardless of the number
of DAMON regions in a given DAMON target.  damon_first_region()
internally uses list_first_entry(), which clearly documents the list is
expected to be not empty.  Due to the internal implementation of the
macro, damon_set_regions() is safe for now.  But the internal
implementation of the macro can be changed in future.  Refactor the
function to explicitly and safely handle the empty region list case
without depending on the internal implementation.

No behavioral change is intended.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0267faf216b95..40946a7f6f549 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -356,6 +356,19 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 			damon_destroy_region(r, t);
 	}
 
+	if (!damon_nr_regions(t)) {
+		for (i = 0; i < nr_ranges; i++) {
+			r = damon_new_region(
+					ALIGN_DOWN(ranges[i].start,
+						min_region_sz),
+					ALIGN(ranges[i].end, min_region_sz));
+			if (!r)
+				return -ENOMEM;
+			damon_add_region(r, t);
+		}
+		return 0;
+	}
+
 	r = damon_first_region(t);
 	/* Add new regions or resize existing regions to fit in the ranges */
 	for (i = 0; i < nr_ranges; i++) {
-- 
2.47.3

