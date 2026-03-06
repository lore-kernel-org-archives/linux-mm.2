Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 652F6FCB61A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE836B0095; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4636B0098; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89F5F6B0093; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 497766B0093
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 012D6BA2C4
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:25 +0000 (UTC)
X-FDA: 84516022290.13.96AEF88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5A7EAC0006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZeVHgsPR;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772810964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UlhLG6107iW13b6rm94JYsvnIA17UoldCwGkO70pgG4=;
	b=tMIWt7AGHHM4jNqsTlWvlx14YhJg9UK6teZTtK02scjcV9NMOBCXrXQkF+rst/kuntnLbH
	hEP9bxVhuSiKbWAazOJ36FxR4p2qSha2zHlJ0CPLQMfAanq7Ut84CG3e+4Fu3VZDAstTdc
	v0lbswwR9YJj6YZk0sE8bvjSqhooSgU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZeVHgsPR;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772810964; a=rsa-sha256;
	cv=none;
	b=EJkOHRcdTWKo8wdsCUiv4EECfH3AA2iJ3XbpuJOp/ctnBRU98kR1cMCcSFxmGkJrU7PLLi
	EKdzFNS+Ui7iTt82/qNlZXSAFet/YCy8OOc/j1SPm75pUit404FHJidV/kEl6W3u4V3wCB
	uuwpU7JNSDgwcILsYcMLbacix+JabZw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 52A5E44548;
	Fri,  6 Mar 2026 15:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B7BC2BCB8;
	Fri,  6 Mar 2026 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772810962;
	bh=zFDrPDtcwfulSyFJOaJh2lietZw1gfebL6litU0OglA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZeVHgsPRrSNZYiyck/thY8pd39Z2lv1DqP49urnH198fOG/D+Xwtzp0LgzidbnQFF
	 +duTf5sg/49BkaZw9XXTxLBdkbqs56OBwRUohllckGSdBmMsFmjovUjmplvA7zzuS+
	 Q6QBvdOgPyNl6a+bjkghYiN5Mf1xTjGJq6hv7m8e4K3+AKZ5w9DwufSyO+MESEkHGR
	 yXDDjXuhCETJnCakfcEUIGdZqfHhogaAhSpKeDfRCWWRa+VJNkEgFDvTYK9hAJ5S0G
	 nxxCzoy++/eO6+Vz+iU7r/jnCeChX4s7vpQNbHReZvYE82d34Nokkknce6zA3IBXEV
	 MG3YT5q/So35g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/10] mm/damon/core: add damon_nr_regions() debug_sanity check
Date: Fri,  6 Mar 2026 07:29:07 -0800
Message-ID: <20260306152914.86303-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260306152914.86303-1-sj@kernel.org>
References: <20260306152914.86303-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5A7EAC0006
X-Stat-Signature: 7p3jjhrrd1g7xr87myektwbpk4w3mpo7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772810964-577602
X-HE-Meta: U2FsdGVkX1+Kri4vfTNVfM2p2x6coQ3BKLn2yN7KU7nP9GoX0gwbbq8iNMoiULcvkd0t9HuXqUAdSsVJ6JLBKO20U0AzQmATvvNz3hOxB9+OC2fb3tBaakRmEYad1JK0EZImgI/WghJcFjURa6MA4Wso+ExbD/2/3lCJChQ60ZgF6wY/3EaTVsqXLNKo4wdNDcvvued3zpKOKQNHbMBKozKlQPrziEGNOoYpAsnCg3wsYAi7SeRf5C44gW/DevgdOzltsxg6NksECMJ7MY8jQiE302k9JNusrNaOCsgHEIvbQFEeiwDgs3O6koz+/jw2rrsQ9B8xu9QkMsToxhTgkcr2OyoUaoKdxjzGoz36p77yK1xKp7kwSoy9ioRxRfpjzq+fYuqn+Qa1QP4v7TlJuSEd8TQ8yo6Xu52J097dTdirm2f9hMMbhfO8dKinYXl1CPIdLPXeDYW/mTVPFtw9euxBeApPTey8fM26eyKj3bG726wk0ECmgD1b5j/vV0iScR6aW0jJP0QnueZ6Bykt1KZaXU8nREcdcB7sv65NqxAZGEGhVYroShl//hnjCs3JxNYnQaUVQiEzcK6elkXyOGhLtquygx/rVENrgJfb15TFzzU/bo+J5wz9ep77DdaKDXCgL7gb9IUpwJr1fx6AyMnru6tH+PJ996mjY2cnQNUrET1EQIVBDnZNj0zcwMO+kiR5fvj6nEYFTEkoRmkG7bi8DBBUCTVQaBCrTpredrIKKSQVoEbMcCmxDAxm+EXCQop7I5+HDrPuWbhsFp7mXruyF/DXtAikxTAAJ3XPEiDhFFKv2DVZ54Ai01nIIW2kJWD+W72Exx6zk9EXDNuAk2yRtAmdZMPcDr+VQtZRkS2ltua6OchJXTY2NbSpjVUOIkjyOUYNLWoeaJ95oL7GpZdZ+UK47+Kz+SIvG9PHa+IpWPi8DDR5hLSjntGsZWBjSfPRsGPAmMjjEr2rixr
 gmP51fGi
 325YjSn081xwTNdQgoaE8i8Y7lXfeU4w2XEpLqNMazq+K7ZveZxkhWf8T4Mfm2clP73dKP5uhsGsOM5GNEI2scLCAyA/TvCNoi22jwdD/S1Iwr6DLWwdXufABIMlosd8Jk8YVuCgqH+8nQlqt+HxTvZw5tdkFTyGpB1XXvjUgccXlRf/Ref8d/GKctlpbrRIcW8bNotZXT1WTVyGFCb80SlTjpq7QvSvN42FWIQWmYhHJhjA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_target->nr_regions is introduced to get the number quickly without
having to iterate regions always.  Add a sanity check for that under
CONFIG_DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 92eac5eb96026..2b5aed89d449d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -545,8 +545,27 @@ void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx)
 	damon_free_target(t);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_nr_regions(struct damon_target *t)
+{
+	struct damon_region *r;
+	unsigned int count = 0;
+
+	damon_for_each_region(r, t)
+		count++;
+	WARN_ONCE(count != t->nr_regions, "t->nr_regions (%u) != count (%u)\n",
+			t->nr_regions, count);
+}
+#else
+static void damon_verify_nr_regions(struct damon_target *t)
+{
+}
+#endif
+
 unsigned int damon_nr_regions(struct damon_target *t)
 {
+	damon_verify_nr_regions(t);
+
 	return t->nr_regions;
 }
 
-- 
2.47.3

