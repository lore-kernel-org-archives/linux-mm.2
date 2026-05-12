Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADD22CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75B6B6B00AD; Tue, 12 May 2026 10:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BCCE6B00B0; Tue, 12 May 2026 10:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582396B00AD; Tue, 12 May 2026 10:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3ED7B6B00AD
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0876E1A04D6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:09 +0000 (UTC)
X-FDA: 84759020178.26.7EFC9EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 21DB34000F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KsojjOUR;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOwj68eo0NOm5g0lJTud3PwFyfxBX28llVcqaGt5uRE=;
	b=XP3OdLdSz/rzfwmypWQHXl5V+bHt6LkfgBndEEsSV2um3WOhTMjcUfAfBW+ed6HDmS21Id
	SHI7VZfZuKFBnj27laRK9fx/rEvrfDcyM9ClOLa0jV7mlqWAtg6LMFq5NlDZcrQXHjryoA
	04iOAlFBhV40HgpAxMQpZ/Wdxb4q/Sc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596627; a=rsa-sha256;
	cv=none;
	b=PSFvbwH1DZpiFq4dySNl1OcB9cNZBfFA4nQCMnXmXBY1agww4hftZ5gpbnhaHXVf62H7v/
	IdaDv4VzW004EQ8Zjcyefy1YXpEUKRTkAPaBvF5atE4l9M9/6tJdT5VApK9m3wgdwiGRoc
	dCFdycDxuFcIQq1tpIqz8PPZvzRZVpY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KsojjOUR;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D6FCA44A94;
	Tue, 12 May 2026 14:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9207DC2BCFB;
	Tue, 12 May 2026 14:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596626;
	bh=nV0BEXAl/A1NtdiYPlzAvpITHMz8pj1VAAgBa/dBAlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsojjOUR5FpzuhoMEsiQ74lUTtF3Sd4uHmbZgbxvj+CN35fepwndOghBiOVFw7xO0
	 Ina4iKV98T2sy2Dl9/ct+GGklfuSC0R28ypUeAVNfyTyvZXbJX9viVYPcDujdLlhlJ
	 fMdeernsOZ2muTPkX9fjxA9IUvBjVb3JUrIDuSA0cy53BnFEXy0WeJFIjVxbqslFze
	 Z5U15cbyGca6bSsK6eJ2xDhpWeWufKtDJcpPofPlrKa1YynmqgbFJvd7fuZ6+a5u77
	 iaFVyUu91FxnYcnsAH7crC5O+qgR4dRcbzf8l37Wkx+Vvga8b1iTzg8a9f3yWdd+8U
	 k0G98Y2QL1+NA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 23/28] mm/damon/paddr: support DAMON_FILTER_TYPE_MEMCG
Date: Tue, 12 May 2026 07:36:38 -0700
Message-ID: <20260512143645.113201-24-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 21DB34000F
X-Stat-Signature: xdbh3jqwrdjd53m1waynpxp5b45ribat
X-Rspam-User: 
X-HE-Tag: 1778596626-551462
X-HE-Meta: U2FsdGVkX18P2bKwrnq8A7TL8hQDzSfo0vcVzdbrYAOBSpnxmuNlKjRn13WpNJkpfQqNPxTWYhq70A7j4ahfU3LDsd0zmupjJmF9/PMsz9Po350+PqfjYLYgBDRsWAzwlM2DgGPrxSraZMRZxZF8CKGI03tGBb93ndaSAYpr0sCzYexnk9btHsr0l8xDwgGCPtz8KmtSp8J7Rqturw93CXT/q7/6r1tAFAxdmuY6bz868P4yZeTz3hjDNjvt3bbWZkRYCNkbb/1G3qoB1DA33Crtm9Yi8L6l0ptRbb/ALfbUGAa7Z99Fopq//kNwgIFaLIV+e+0JDq9ukEekq+6DepEiXnUWmgaWt6b/D7UUN6ppni8q3b1cqkCu0ngijvWUKuJcUSYXmotcUzNJBJ/7sTK6Ypbzw4MZw6Jwd07ie7GLrD/0GgS9ewLDbw5amM/q4WhZEXh40apYiHncfd9d6ndK0atBZaaMnCoXDwlfDGy8fWm6/6nZO3+89Md07M8eUadQuKpI4sk+Pal+D0hrCz3Y3+xQQp+DB5xdvUZYcdbYShCHzlbFFin5GCgWQnqzQXxxyzt6HgUw7HeQcUpr1AriuWY5la/ZxQRTE/rFA7EtcB54ku1nG3AHWBt1WagI6lR/NTLqg51j/4yDxXCocBH1clTRNdYB8EsHVtMjieUNgXRS2HUuxtIZYHLKH1TL5QlBkBCQ0kTTZemPu9c1V0r8xs/OhAf/D16uS5C1VIUBn53/N8dvJQ10jmFWmS0zWQJK6aZ3yu0F1hq0ltB/bMB8AvSHvmR3NBHrsL90wxfGNAM3Citr4004bMtggYXOBXCBIM7sfgL0V6g0Ct94PkR/fR2mMKDfLeobnL6AfhFzhzGQUlcMeCHqBja9aX6I5CNzgwjhf6afxi5VwgTftvuQljhjAuuJ3wFkpQwNsmgkfpx1kTTcwSWka9qeNGqonXUI1b5y341/Zk/g4m1
 hchMuIGH
 hJLMcdwAZTW0QqYc28y7OUAU0CIdfluE/WqoaTiKMhDTcHMLcq1DC/O6dpIAJ6sNZ5AUqGSc5pcBK+vsf06idLwlXuPjh0vzDIyvLngzZg80Ce/eBwspl70GJ6Fh7aQyUYT9t0LfYHyEldIaS/HkRYqukE7umy5fSAwN2wjkVdXUExKfAScvy/9KF5zX95ZnWh2M2ZRUOl8xy6HXYYWapsOjQZfvTE5KhPagqTx3qc/YhRjNrr6k7MbBTDJdxEUjbi/C4ITc79y9st5MgqIh1nHN+7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the support of DAMON_FILTER_TYPE_MEMCG on the DAMON operation
set implementation for the physical address space.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index e60af2cbc1089..f093485fd16a6 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -124,6 +124,7 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 		struct folio *folio)
 {
 	bool matched = false;
+	struct mem_cgroup *memcg;
 
 	switch (filter->type) {
 	case DAMON_FILTER_TYPE_ANON:
@@ -133,6 +134,19 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 		}
 		matched = folio_test_anon(folio);
 		break;
+	case DAMON_FILTER_TYPE_MEMCG:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		rcu_read_lock();
+		memcg = folio_memcg_check(folio);
+		if (!memcg)
+			matched = false;
+		else
+			matched = filter->memcg_id == mem_cgroup_id(memcg);
+		rcu_read_unlock();
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

