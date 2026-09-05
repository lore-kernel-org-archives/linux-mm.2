Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97E1EC79F8B
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 20:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78F506B00A4; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3676B00A1; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543F66B00A5; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E0946B009F
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3736160302
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:26:46 +0000 (UTC)
X-FDA: 85180842012.25.BAE03BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1950240003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:26:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y646QVjB;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788640005;
	b=8nL0VXgCgDLllTSbcnhrZeTMarUEAi/88Wdjxw4oav9u/HwSKFd2kfaP50mPp1/qYY+r42
	AVjYMS1Kiki8dxy41MquRPgfzOh1uuKkyx70F8L53yc3X9oBdjqYMZeQbr8KSeZkxbuX4o
	14nMPNrIvJiLQSOCXgRSgKt9xIUEv/A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788640005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fn4wlsJY/z4XEr5TrccoXyN8K/aFxzX6vlLK3FGYk8U=;
	b=izKQ/aeCBcnElMgXvhq8k7MsY681zuj2Qo9JHFZ41/DA2Hd5UlSMlmaZD/k9irMRGnnJv/
	licrzvEJLjQSQcJrY1fgCEI1h01FMgNky7btURPyraQDgWHmXJ7HubNZngETqrXY5mt6Qt
	vzBoBX5r16pznfN+IshRfQU3TiAAbKM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y646QVjB;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C7256025B;
	Sat,  5 Sep 2026 20:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2A51F00AC4;
	Sat,  5 Sep 2026 20:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788640004;
	bh=Fn4wlsJY/z4XEr5TrccoXyN8K/aFxzX6vlLK3FGYk8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y646QVjBODL2Nszz7u/PMlBRcqwdj40UkazJ/+ndoBf45LjxUX63V8oybAf0LrkTb
	 EsbEmKlKOyyDEQcIBDdziEIQe6oT/MkSV5kt+HK9xOLpQDKOuJv6tv5rcRwxzjimdX
	 WPzg/dpwTrEmQh9Xs46X7j10+LK21PhNLXpKZwPZL79EQ3ne4VVaQxSNlDktdEQeDl
	 Fg31MReWxKR4UYG96stySnkAc2tdSInKBIywyRA7IRTUNTe0kJDSWlvcsjeRhXc5A2
	 bfi9jDkidi/1NTrcVDtJ+BWtH5qstOI0Fesqwg7s6XE/PLvWmsnVbsyfl4LydHo4Ct
	 dNlS54AuTjURA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/5] mm/damon/paddr: move probe filter handling to ops-common
Date: Sat,  5 Sep 2026 13:26:24 -0700
Message-ID: <20260905202634.88102-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260905202634.88102-1-sj@kernel.org>
References: <20260905202634.88102-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1950240003
X-Stat-Signature: 55qjygwa3aremtxec4k1eo1eq41nn4k6
X-HE-Tag: 1788640004-977250
X-HE-Meta: U2FsdGVkX197JXyv4p70Q2GdSE+mO7ri3kU878Fiiy7h1gm+OTNhSVd+e8i/klXcJIiY1OLrELtwvRxPpE7Q0qGuqIdIH2ZeTjDBAN7kR/vS5xeVYTEElyk04UgIlLseTYjga+nUlzXh386dXeV3uNUwl4egaemjFPpJvKyRvDjYQuCKobfviXI9th1R2bWMbxxGUQGhC8FJvAORPnJKsAsZ+bTpdnCsx++cr+FU9FZdSN6XAgjMM7zrN1ybyR9nTmSt7DVPHzwxQHL4NIIF5Exx5b0t6NTyp03yyafFU1558VMatmfN8Bryjmp9eS3CLjO3llVlQO15oUPnDlFetqFDu4dPOpMJwTbhuk9Opu/b9r6d8/8mg1jSpMEEugcU+TM00Kl9VtbXUVfvN/OVc5jj7zHPRM4cmEJMk2P06FdXhZ3LeqfeLuOpYqnou65wEuc/MylcrZ0tiYDvNWOWRtPRfrsnpoldD9ew9fuEelQf6AYBSs8HdvQcY7pofzcs3ydMZzT78ul4SodGiyoiwBswRGrLHK9iB4VPOImj38g2A7pqGRBV1qJb8vW0s2oV061WCzkbVhXXTEbXdpjie6OGwHKQfVryyYLNM0R5beSwIePGvB8mYBRWUFWeKueYNDFHrJXe7FqiEjHPNNVb7t+lhwuGL7jTU+bkdcoITwEQO/ohutrMiAXRzrCcuOxqwwWvLSOR/sw06sSerWmpMWgoAmJt/9XR2gAQ37yIIaWl456NbmXJ9d2a36HVb4JgHNXuRm2yVVkJjN8RncbCcsmZ2BNmO2SwpAfdIGvSQS/ISBBUb2bclMuQw4iqhWkbOBCNePUgfcOhbHp0h6J4pTIoNHuE7cnI6IJGNOOMBGN66EoMx7bRv5HaZ7CopRlqjFKFhDBy7TvH/WOB66n8bPSLD0DRuqM/DzpT6BGnskOhkOM9ODHixKq78bHvGNQGEapa2aPaj9SwZ1iucWy
 OZxS78Rz
 B3wlnU/t7Oeg7CF7Tsz7SkgvVOI10UdZvjsZx2ja+3r1Qu+6EqCyTzzi9KST3yNnCIh8TBtFdQ/204QFQWpU5FPq9akzAlj9cA3eZAiHvTqiDerzwTn8NUP9mKvABPwWhdRIcMTouqeaBPPHfg+19NAzwl9pBPAFY0cJOtZRfdFli/Vbgovw5L/HnhIWfKVnJLDQ8azNFAehG+V1kq3KIH1ofi3yzhdl0DnzGIagv5glH2gc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Probe filter matching logic for anon and memcg type filters in DAMON's
physical address space operation set (paddr) can be reused by virtual
address space operation set (vaddr) in future.  Prepare the future by
moving the code to ops-common.c

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 32 ++++++++++++++++++++++++++++++++
 mm/damon/ops-common.h |  2 ++
 mm/damon/paddr.c      | 23 +----------------------
 3 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 441d45679eaf2..76b663a4be610 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -524,3 +524,35 @@ bool damos_ops_has_filter(struct damos *s)
 		return true;
 	return false;
 }
+
+bool damon_ops_filter_match(struct damon_filter *filter, struct folio *folio)
+{
+	bool matched = false;
+	struct mem_cgroup *memcg;
+
+	switch (filter->type) {
+	case DAMON_FILTER_TYPE_ANON:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		matched = folio_test_anon(folio);
+		break;
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
+	default:
+		break;
+	}
+	return matched == filter->matching;
+}
diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
index 172f0f17c4a84..ee27058251005 100644
--- a/mm/damon/ops-common.h
+++ b/mm/damon/ops-common.h
@@ -31,3 +31,5 @@ bool damos_folio_filter_match(struct damos_filter *filter, struct folio *folio);
 unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid);
 
 bool damos_ops_has_filter(struct damos *s);
+
+bool damon_ops_filter_match(struct damon_filter *filter, struct folio *folio);
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index d2173a448d0b0..d7c81829445ba 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -143,29 +143,8 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 		struct folio *folio)
 {
 	bool matched = false;
-	struct mem_cgroup *memcg;
 
 	switch (filter->type) {
-	case DAMON_FILTER_TYPE_ANON:
-		if (!folio) {
-			matched = false;
-			break;
-		}
-		matched = folio_test_anon(folio);
-		break;
-	case DAMON_FILTER_TYPE_MEMCG:
-		if (!folio) {
-			matched = false;
-			break;
-		}
-		rcu_read_lock();
-		memcg = folio_memcg_check(folio);
-		if (!memcg)
-			matched = false;
-		else
-			matched = filter->memcg_id == mem_cgroup_id(memcg);
-		rcu_read_unlock();
-		break;
 	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
 		if (!folio)
 			matched = false;
@@ -173,7 +152,7 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 			matched = damon_folio_young(folio);
 		break;
 	default:
-		break;
+		return damon_ops_filter_match(filter, folio);
 	}
 	return matched == filter->matching;
 }
-- 
2.47.3

