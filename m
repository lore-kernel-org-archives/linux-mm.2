Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B30FFB5173
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 01:05:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72EB6B009E; Mon,  6 Apr 2026 21:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20ED6B0098; Mon,  6 Apr 2026 21:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93C7F6B0098; Mon,  6 Apr 2026 21:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7968C6B0096
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 21:05:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35916C2104
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:45 +0000 (UTC)
X-FDA: 84629967450.07.3BEC6B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8F5A3180004
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Id46/Ofa";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775523943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMUCrJ+gvGwaDfmPiXkEDkPCzQINbFEnETxptdhOtNc=;
	b=7bZaQDKDw7+exkBBFh2X/UhKG1jtS6G4r0+NDd0TIxDya1WNFWUeYqs3/gtJK4450Kscb1
	xk5S304H6di03QKdkgmZO8VVPTImBPUc/BoJzsSsa4XxbkDc3PXFjP0T4N8eAn1S8D1/Mv
	kKailFpi13YVhpxZEmmTsfpAS6BxaOM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Id46/Ofa";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775523943; a=rsa-sha256;
	cv=none;
	b=zr/mkB3IjFj8mE1iPu4dm94e/VFnUqlM9xGz+uvhMk0abqo0eGiRUShXwLW8vcP4XeiNYJ
	v5UMH0ors2+pLaK23YVF3A34+QvtJLBZy6nYC2Yl06dRACf9jWJEBtHMEcS0HRKulHfjjV
	nZRONuhmCe7pswLoxkMpCAaRakP//4E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B1E5F4441C
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA67C4CEF7;
	Tue,  7 Apr 2026 01:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775523942;
	bh=WgiRHi50zFvHwjFSQiNfyV/FQHY8WOkdhFM9Jv3jqj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Id46/OfaAZ00K5ClvIVUWb6pW1AehlQgKQuwbUeY7+YOgQfpDGSijPvJLSfqp37RA
	 rWgC40yAyYcZv5yGsVW3utBVGld+73Kg/2Sl3snA21zEPhfoia88/Fl2slMRwpbzYd
	 /RA3TZsaNzn5PtV2lLkGbyscD9adNDo26ijcaxEAYSzDmOnEB4K8OyUlveFgnEkcxh
	 /cXDwmu68UANFTWVWrPesnpKynchPvDXc/qLLGNv7vrlN9beoeWgKw5PmRLBrJCQiS
	 2HWmyh/lTkoYqAS6WNFjgqJQT8H/RNw9e58pQY+x0nYikRrQ0V8tqIJYknZ5/xvGsk
	 qKFKS94nyS3ZA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 06/10] Docs/ABI/damon: document fail_charge_{num,denom}
Date: Mon,  6 Apr 2026 18:05:28 -0700
Message-ID: <20260407010536.83603-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407010536.83603-1-sj@kernel.org>
References: <20260407010536.83603-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F5A3180004
X-Stat-Signature: h3axz5hb6s4k4s6nhcay8a3s4xriu3p4
X-Rspamd-Server: rspam06
X-HE-Tag: 1775523943-462855
X-HE-Meta: U2FsdGVkX1/uFvwuqf99R9AGNuZ6ptKMoEtAQKeve2Zy08kvz/OfcqnGN5aH6vj0lD7T5pBGWsuQAcBAwla2xhC1L0wlzbRc8wjbB2IIytJZIEz7ftt1bReXPlM9SIvZYcMeb2yZwYxABhqadIc0V5brAitA41C4lolyOJJImYiWSJd/d46ZPgULMeHAbuuHfG7GXQAKPLZ/lzXA9ycmvdr3zqxQEo8fLlGyMOpDEUeO+uxTg/MFjetjz588aDS+Uh0rBKzoVnQgjUOONPTdzpG1UcYt/L8S/CXyYX3BeUpWGHgM9KtN+bgcj7fsVeNhYeHZ3TS3LA44E9DKs7wrwKXHgYVIPpHs9jgKZh7S0rz8c7HrCzbL8M81PSOjbbe/6ML1jTL/5W4GGDtsXgWp58nJCxvdE7eSfV3+DUi9VbKHluqPHrcAZYeu2UUT9vQfL77jDwVpOc3SO1ry4cC9Hn+syY3dDLIGS4OoJNey5o7ul8FLC2U3dj+2vnnEUfvuL+550O9GvfTaBTQYH3C6dc0NVhTBRxbOKK3PnGWiKwN+/WK9Ugces2HZSgijdGkvReDRg80xLbhCPA147qH4HYych5hc9q6zWyM5d3mKByCJDCX3iJhPr8vf/vvNQStCcbMz5X6fCFbGkI1uc2vm+iXW9tJfw1llvWJFDGQ0EFp7g6f+ra5bBhGFBuh4H5VwDkCXYN1i8TM5SE0n3EpHQ8rVo1noHX1Wmvpb6B61WBZVv6RYfmnN/SbxA/cl0d6bKH3y49PQX0YzpcaMAHedqo/1994wrwUMTVioiHrpRV/e/PREYWrsbdxBaOMU1fApBUDHw8BmfAwXMO05pkcXNoOIwhIkqg+F+gAHcNIyM8YAeURdtzYmOcVlhyEHyiJNavdRbBjML6rtCFSqEb9D9KPQZ8sxz33rKNWbtUduXniiWw+Q33kh+Lbjly5uO4wJklyUIRAatNpNQulDBNP
 ssyms8ak
 TQ/1OdAoh1SsjRB8OY2W3BwJwxnAIXKVFMZCVjKbT596lmYCOGh5q42lgNOxGEflpK9LLSAnMIH3/w9JPWYEDP8HiXuNZZPO1ELh8IGA3nFxWgp2gHrfNOA2HMCaGQvceU8g5VJW6UNSnx8dFBTpKE743yE0SqTiYACWVJDn9aUZnJMDCdRGOKaCGpOEGyU1+uozN0/zL+0rXah+Pz6nNbVPj8tiIPnO7H8Sn1rwPaOMPtKQ7y8whupVrPOzzUDwOpRmqVKU5G5pE3B9angt8OUS6iY7MF1XCfXxgISPX8CcpvseU81jWZSJ95cwoF1+aZYn7qEtIQ1JT15EhZ73YkOvEk3YVK0LbAnsKuNGIXk6fmHGDSob/3H+SpWOu3/8NsMYR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the DAMOS action failed regions quota
charge ratio control sysfs files.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 7059f540940f0..971c22e34e722 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -329,6 +329,18 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		goal-based effective quota auto-tuning algorithm to use.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_num
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		action-failed memory quota charging ratio numerator.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_denom
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		action-failed memory quota charging ratio denominator.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

