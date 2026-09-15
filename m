Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD70C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0409C6B0098; Tue, 15 Sep 2026 10:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D816B009B; Tue, 15 Sep 2026 10:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D11226B009E; Tue, 15 Sep 2026 10:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A11236B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:34:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D612C80446
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:34:10 +0000 (UTC)
X-FDA: 85216241460.21.B4A43EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 437F91C0004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:34:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jczOAY43;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789482849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WsrL2oFK9840WoIrM7QJPBsnHu9HVCMK1ZcOyqnJN44=;
	b=y0AhN/yii0Hawm6F344sYpAPkKkseLErKkXCmzmph4MFeIXRNKq7o87/v8l5mX6AvhghnW
	BDx3C1Q8v20IM5oeyXXq4Pktl6cnhshOlFG4ChImUJeM4u7hTgUQu9mC6rmXmPw76dQZL4
	abauM4sYZ0NkZIjflBsbxuNMmmXH6+0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jczOAY43;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789482849;
	b=qj0ZV0uYOC759DgPnEuacREAldfPJR7/Sp60EV/JhRdc7fMPAc0Jqt32XMXOHkTF4WGMGV
	+9Bn9tPfATZZZPZ3bPufdp1tg/HEdN0cszxFGj4jjcmFH6Hu7b770vvTP45y1KdvT05gtZ
	ekzFcbsI2Y8EzAF+aMHUGxKbB+zIsfc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33B7543F78;
	Tue, 15 Sep 2026 14:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DA91F0089A;
	Tue, 15 Sep 2026 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482848;
	bh=WsrL2oFK9840WoIrM7QJPBsnHu9HVCMK1ZcOyqnJN44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jczOAY43TV82GPM9joO0KlMbFEhEwzVbxDedWo2jpIngc2YnKXqKV1N6fEST14jda
	 1bo+HY689g3cdashcwO2Xe6gl7qP7NtVUQO56OTH0bGsu9sRWT8j4mci50+2dQkC+7
	 w92S5G8oVmp58iIf+2qzkAFUuyjZpdKkBxKuiYAZWkzYWYc6u5+UmdUpUSCpdw/1c5
	 92UiWOIF+ooND9mn71yZ53zCNmfhnEDdjbSVs/+g10r7ixrV4qX/Tu3QG8UQZHU8z0
	 9A6sOziWW696qrxTub1RTsKQVS8c/EPAL/C2KU5Xd7GdYJ6ACrhH5VIqZp9EploMhR
	 /qaRa1MyNfMyA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/8] mm/damon/ops-common: support hugepage_size damon filter matching
Date: Tue, 15 Sep 2026 07:33:52 -0700
Message-ID: <20260915143359.91472-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915143359.91472-1-sj@kernel.org>
References: <20260915143359.91472-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ndzc5rkr5b9wnjdtkm1o5ojehapbr7hm
X-Rspamd-Queue-Id: 437F91C0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789482849-816361
X-HE-Meta: U2FsdGVkX19fotqQMfPCaRYChBnLRSkVtuPjYE6rQi1GJexKA2wSv6l/f3MTe5kDZRExdWU5ugyFYqAeNjRwer9LbNT6Pa40y58Qxa2XvjCc8PQ48/lt/QlzOpZ/wguScSgWm97CW60/fY+ZiWXFh5riQ3mqxeeJjoQjFh19zj8qNPCHKfSJhPUY3tfLqdGLkWkKQoY90k47vFmXvFeUbxResONcATWggK3jip8CnRNpQgtgXgMfKm7k84xhZVAoC+BCxLtMvRPTvQf7hAi+Y3Qmj+pPOBEicKg5FhRm3WTD3kHm2eGqciVfHpo6f77xVSvUw/1e6ECUnoriMQeCN4R/QUa2+ywidpmMrhdd15hcfSkfUigYI4/s6Ppi3aCuH9epSHUjVmm/TFtRiBb/W00Jjg22Lv9lpP11cQMpo7u1aOcPmApc1xsNtfiv/korv1l0w8f2i20LfV1/6FRdBiCF1WKh0jeUDaB/vtI45ooczjxkqtqod4HrP65KLpcdqmZOBoH1OPcmdD1kCzYtUhYDmh4IfBh9SD41nxRl0Ag+hODZ6/lTE5bE67Uj5b1/xTq1YjxvLO4ma0fmIVitSSVxYepavoSC8kQ/rraqIAQqeemmNaM7jTTftvIK7yTXHZw5XGcNQs6E2BPOt1rvii2xiguezJzL1QhJq8SU82nTt8kD1JHeXdwmg7MRIo2HSV+2yfETWK/QmghDQ5QGJ+RvlKcyXfJ6pRiaefBDEyBVMqldn/XkoeF4W5zCcH+fX+Z/PXHMmivcArOnK0+6qQJg1kufvH9jI+NmL0eh5wB8L4gjKsmWeuquPvzd14i/88ii6YF6B76OgAcA6n5OSpEaIJfzhaeSadCI5VemEraNhuF5dfDTiaHIYj+Z6wCcA2KYCsIZfn05W/GJgS/R+pmA9nxSVl+hwb97OfdH3aNDn/IEbKccDce7BA5GQ2psTsc7BCgX7UippBsiQs6
 mMmZWk5W
 3HUomsYJ3w6n8mvN9bI9max67vMZXvoSJUDRHNg9w1IUHC3cvOHP38WfUMNrvL4kzT5hya7EqGBOVAF9qzWX0r9Iq9gI9a6Nhe7e22IJpzeJovGMun0zi+YA7XdNZN8O5/ZjEHwXfZ6Pm5AfwZ6ZErWv2Wc4zXe81Epeil2wq3rV9BIB/knzrMYcv+76/ESPJfJOwXI/ImOhpLFqHLnjuH6mpxDF9FcTMpiO+5EqkL3WQLYfg0QJ6mJLTZsDVjoxYhj9HWnF/JrUAhTWpDba9Ruh7WkvxQ+dwA1Fll7VyDPG97pVce1+MXKUW/yG8NWzzjHQ3G+boN8EJs5ZyJpB9wR43L1sgr4FaVDhz1kMzoFy6fxE8dh5lTfwFrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update ops-common data attribute filter matching logic to support
hugepage_size filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index c36cc39cd2c70..77366f42b3e5b 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -536,6 +536,7 @@ bool damon_ops_filter_match(struct damon_filter *filter, struct folio *folio)
 {
 	bool matched = false;
 	struct mem_cgroup *memcg;
+	size_t folio_sz;
 
 	switch (filter->type) {
 	case DAMON_FILTER_TYPE_ANON:
@@ -558,6 +559,15 @@ bool damon_ops_filter_match(struct damon_filter *filter, struct folio *folio)
 			matched = filter->memcg_id == mem_cgroup_id(memcg);
 		rcu_read_unlock();
 		break;
+	case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		folio_sz = folio_size(folio);
+		matched = filter->range_min <= folio_sz &&
+			folio_sz <= filter->range_max;
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

