Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C371CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F2406B00AD; Thu, 14 May 2026 10:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8527F6B00B0; Thu, 14 May 2026 10:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548E46B00AE; Thu, 14 May 2026 10:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 39B126B00AD
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 07E991C1480
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:29 +0000 (UTC)
X-FDA: 84766208058.06.38F3207
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3FD1740004
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Mus3+/t3";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOwj68eo0NOm5g0lJTud3PwFyfxBX28llVcqaGt5uRE=;
	b=52WFlkX+q1SuWeROMYKzfNrJX15S+T9cWsKu9svD+KnKgEbVr7fpq4TPICv1RkM9fM7uN0
	7nY6cAKZNKwqcyqDNPbXX7WDMdgnUeeL8cSmk01vgDq75+jJAReTyTgGEfHEN0iWqCujQw
	BFLPyDLl+JKEtV/b05BfYTG9JyvaRIg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767767; a=rsa-sha256;
	cv=none;
	b=PCFtdQp15JcUvD1g/Q54sslDwGzPYJ2gdkZ9tcLqVi2kMKOfqs91Wf61eYJFzxG8vD2lfm
	kb1iwlCKTva47CUjHwEcymkW1o09H5bqnRkWPRYyBU6DXqPiMo3KAnEQZDxhkyf0nm+Ye+
	iTcgSk6JnqzuDhYIhK8APz76U1fOgwI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Mus3+/t3";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EF6C74442A;
	Thu, 14 May 2026 14:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A935BC2BCC7;
	Thu, 14 May 2026 14:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767766;
	bh=nV0BEXAl/A1NtdiYPlzAvpITHMz8pj1VAAgBa/dBAlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mus3+/t3MS0p3bVGewchGU1cj0bSS8OuENPsGcTXoxhAlzYi6gB841ctXOqeNgB2w
	 +0M0FJoHO1sEqwD4HCszb608BB/khqQgl7Ksy1uMtKcLpkS/JspgwJJkpN8WGTpWRw
	 zskax89/YnICCVJW18uE4jo6VY/CK+PZ6QtpZTROwXxEz8ifwtydoXF9zPNpgSWMbI
	 WnRlyT2obZGPucV/hyYTKHPtScj69sJL3cDl3g0vqlFl16jeNtqMiLkh6tFr4boKO5
	 P79vVvDKJIbRGMBH7t3lLKbOT5TxD9pCIuNnP/YZiZ2LgX8Xb9CZ8HXun3atdezeRb
	 OuiOZYPyvbpvw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 23/28] mm/damon/paddr: support DAMON_FILTER_TYPE_MEMCG
Date: Thu, 14 May 2026 07:08:56 -0700
Message-ID: <20260514140904.119781-24-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3FD1740004
X-Stat-Signature: 1q4j31k1zu56fudimt7bh4rprmkry59s
X-Rspam-User: 
X-HE-Tag: 1778767767-792062
X-HE-Meta: U2FsdGVkX19zXlUL7nz/oH9ao0qdKb/435TbikCXfBdE/te8SRBQtj7DyUbnwvYC5AdP+ZAA8T5EJZ6d01tnk/dR7O+uHe5dMwmsZulHNVVj3nSsFTQhyztKEISUVc/+EUCE2ru/Lj4hERkWaSmTcR0N3gFyM3rdZnBxRzIY0N7rp4anxgVMts5R/r+7bMStazfaeM3UFRNR3sSTr0ykEzN5iBEgA+Nu+tvzGn2Mv2RYyG3QbkvFgonW3kniyo7l/b3qEaNxguwxGF2Duw8n5P8DkKT5IXWxfXnMS5eHTTe8I3JtTjITUpOIc6kqghjVr5Ur+4zY0mcl0tyJmJ8e8Jr1WwD6PRNhUtQghIbr/r5eBiHenMJ0wpp5A8tNmLaoD27qXFnvbVV58uljsaKjMgebyT3L3GCYyP2WSDjjoKZMUqAmZeMd/zIjf3HOhJzj2MJaOu2msiwMWFWnBHVxpYujLceZS9SCWfQJ/ZPWH0U19c114roBy3eb55Y9e9N66dWYMwkTcF77woh0/8SSBrQhC5TBi5J20uwizbZMjPPCjyvmz2hWHKxz83MIM8TSN25x+RTvOUG/gDGX6eGGJSoqlAhxEVMma26z1iUw6VvVAo2+QEcsYJGhIkIaoxd46ODM2U/vQm6WfQ5zJWthRvw2DGnOP4Y+SiVvF8FRWtkc7yCvPCozvmWfvwxU4Qlg8te/HwS0H7U6pHIgazCAX16dJIVr46F0w290t601nhkA7g1wUBfM9+DVo1vwGaGGJ1bb5x0aGgHukLE+YEL4GLlnOEtCaKNy2x+bZANTB3GgDf33EhoCJ9Ppj9pnhafUfnwP+qFm6czu+EM8LWDyGhQ1lYCUuK0c4IL5jRSMiRSLO71o1MLhLR9rypHYa8+EhwN7bi9iylGWqjCiXfvZzAzbfYXLzo6iyYypzVtZ9GBF3zBedMsuEuSC3Ae/EfBWBDgwRUIB8Fff2bK7t3Z
 vcSEkyov
 DLooM3SBilDbOVSnGMaHSf03JIJcfDLnFJ1Hf58yEd243dvhX6CG5Ay7FeTSH6sN3OGWXrn6OnDbN4H2bUWy7lmsfWQ3KjIWl8wiZ3oGwYDc3wFRgLdVbmb+iazfrL7QUOa316xjF8F16EkQm6N+PzmqjeaNVM+qljYxewJJ/kl4zFiHDCUmm1ZFQ5fCs5FtS/h4oow9uAxgtEjLamm+FetDMZNIrO18M0RO+jJ0mzowKcmK7+iUNWaxRWtUfZwi/CByDZT1KRjRRNGyiXd3qwVj/Yw==
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

