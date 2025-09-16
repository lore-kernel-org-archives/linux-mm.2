Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA02ECAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287E38E0007; Mon, 15 Sep 2025 23:15:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25F878E0001; Mon, 15 Sep 2025 23:15:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19C2A8E0007; Mon, 15 Sep 2025 23:15:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 094FC8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:15:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98D74BB557
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:15:55 +0000 (UTC)
X-FDA: 83893649070.19.ACC1F21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3AA08A0003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:15:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ghnep31B;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757992554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1s/T1eAhD4PSqIytNe/Nt1BbKYeNNug3kg0LKTqWzSY=;
	b=74g0zQ3/VM6qprnLvIitGjDhaMUSoamGBaADWrEfBdhhhRYeZxRnrwGMD60ZTcC1sBSg6K
	YRGVcy3nf/TVubdxoZynKuJfx5jhk95wap3bhtt6ksSvq9KRNdnyiyA7TRj1O81Ol+PSk5
	o5JCDamYd09viSShhntCPdMEgJ6DJYk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757992554; a=rsa-sha256;
	cv=none;
	b=Tm7z8d0iJyKTtymKYmp842zn9PBD/+jTF+kDQbhfsfVN8f/XUwGKMIOBZpJEdmuYLFwnHk
	HhdbUgKn/vptEnHH3SLIExUVEH2DOmVuQXEr+alCqRptsFU4inwTU8+h6hmE1iQ/9RUVJ+
	LSeB1XQBqbY3TUM+LRR3q6lxmOR3/lA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ghnep31B;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EB1224413C;
	Tue, 16 Sep 2025 03:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34A3C4CEEB;
	Tue, 16 Sep 2025 03:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757992552;
	bh=Q+ZVTVz4mEvUkB+hpSZhEe9TJff7bsWdkkhr92sx/0Y=;
	h=From:To:Cc:Subject:Date:From;
	b=ghnep31BqKD/QI5//aXn+PGWVlVVqTd59xS+nluKGfAIZ2K3QjLcqmB32MYENgJ9D
	 Xg8c8wHroj1Bo5EpTAI/BnZPZlOlx6dCgy+1tEKeO4Ujcr2L+GAS2YwfRlYf1KbgzL
	 HEfe97qgyByZ+uwppvRb77tgTQRBewjDhMNTUqkP0z42fyZNj6NVoH6Ye6GHw16JVv
	 zgl9KdctOri1oNyLuPJzUj4foa1118dkP7vsLvXNPanvBnq1M/2/wgmd1WMaDdHKlT
	 QnsNQIlLALMy0G9nj+m4QK7RQ+2toIK1do3l/X83c30uWiy9pWkxHaYIquYelERVkV
	 46Myp3LxWK+sg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 11 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: [PATCH] mm/damon/lru_sort: use param_ctx for damon_attrs staging
Date: Mon, 15 Sep 2025 20:15:49 -0700
Message-Id: <20250916031549.115326-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3AA08A0003
X-Stat-Signature: tocznysbyc1j6yiym473netd33zj3rho
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757992554-733967
X-HE-Meta: U2FsdGVkX1++KD5Qw3YGFBEQLd4c+gRy6sY17XcvVZkbybmczaTwee7liLW53/YPZz5oWJZeyp9c7MSgSZuDAyGzShZxddayYtn7vKQUNDNlKsZgJdLjK+XXkXtaE/IE/Yb1gwEC3xAS/nQa5BtsCQGGAgdMTFWEsMH3gqvYi3Ks6Rno0Y16fFp8S6jboZdt9jVKAMwflMYoHhRiTZseSzadGUHJ87ZwyVdreB77wvkqRuXLxWLgr1NOhe2LhZkDpceQOtho8Bf5zqGR3LG7jVV4YiXcTuncAo0AmdMwB4+UqZorauTwIMJy8DravCwo4KZkZ3j5Bvh+KJekX3QiWNOhKpfMHsqjlnukJVEMmrGvJxP21LIDj3s/+52HV+nGp0x39tQUq5sMutlJU1rVqXWdCwbnJdmDYLT4wd/O2TEJKc3MZWUWJKSL3+K4eXD1obMI2Qb5lbPCiFbz+rU5sgz1VolAEhdhu7QRnTziop4Cv7zxz9ZusT1PQL6IVKILKP9haC50Uu7tEV2HZT3rdzEQkbzMAEOhaAfFZApDqk2XmnPD8fT/y8iR4dEzohQRVSPLWCf7AvYaSg+2OxIsjG+D0xMmnBU5aFiSxWmR7veQ42kG5dpaZmBFm09Us8u3+L6d9NPe490kAVQYekwG/MUZ5FbMfDvtusB3jvJp2yugJOOFrbiIgp+I1Qw884sC+ZCH6aWjusdp+zFfbfWOg8FVyv6QZ+qkoUZBq5raMMySAP9/82K4WQW2VfEtw6qFoff02gfw1BbUp7hTMmMwG3OsDSbyq9sLMm2nqM2ecs2W0htV9LBIA8TxBYJLYBrqw+OemB9aJnFcJQehZpNUGyi+nIccIR61JCnJIA1dVlEyJocNFDGfrlD8xcf/gJZfrDvCag/Kpo0Opd3lwttXatQJVeCIhUjvvvq/TBx8LG58mmjk5RqDGX1r7tydt0xKlZK/n68yIHmBKUO4y78
 qB9lIjbP
 Hq9x8yUDLaISI/jU9klzDG777VC1AsE/wI+VAdNsf/FOWFH8l1l3z1VrsE/Cj361fZ8mW3IV5dqEjX80=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_lru_sort_apply_parameters() allocates a new DAMON context, stages
user-specified DAMON parameters on it, and commits to running DAMON
context at once, using damon_commit_ctx().  The code is, however,
directly updating the monitoring attributes of the running context.  And
the attributes are over-written by later damon_commit_ctx() call.  This
means that the monitoring attributes parameters are not really working.
Fix the wrong use of the parameter context.

Fixes: a30969436428 ("mm/damon/lru_sort: use damon_commit_ctx()")
Cc: <stable@vger.kernel.org> # 6.11.x
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
This was a part of misc fixes and improvements for 6.18 [1], but Joshua
thankfully found this is fixing a real user visible bug.  So sending this
separately as a hotfix.

[1] https://lore.kernel.org/20250915015807.101505-4-sj@kernel.org

 mm/damon/lru_sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 14d31009c09e..ab6173a646bd 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -219,7 +219,7 @@ static int damon_lru_sort_apply_parameters(void)
 		goto out;
 	}
 
-	err = damon_set_attrs(ctx, &damon_lru_sort_mon_attrs);
+	err = damon_set_attrs(param_ctx, &damon_lru_sort_mon_attrs);
 	if (err)
 		goto out;
 

base-commit: ea93a9235c1c6e61cfa6e5612b7b6b3fc41e79e1
-- 
2.39.5

