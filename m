Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BA84C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 05:44:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94B4B6B03AD; Thu, 13 Aug 2026 01:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F93E6B03AF; Thu, 13 Aug 2026 01:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 811126B03B1; Thu, 13 Aug 2026 01:44:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3866B03AF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:44:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59DACA050C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:44:45 +0000 (UTC)
X-FDA: 85095156930.07.AA0B27A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C225BC0006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:44:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oTHampD9;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786599883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ydKZfv20XDA9Yk9OoF1itUqqkZNlBOcLwEjFDoPApk=;
	b=wGQfNukxkiuqAMJfH05TcjaAzoQxWexqVs+5lXWUDMsP5d3jut0kBzHu44J2jpphIy+bnt
	vz5MEgLkCf662DXEjPNnUjzcdx51hMdBh0J7yJs8t2GvBAK81Oyo8uPGR9sko/uSDztbt4
	guhqgOmGCPBz1BeEXNkFkvL6lTFHt2Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786599883;
	b=LTeSQJ2ywSsF0krviqD0EiovUbPCFJethRgWKczOOJ2PRqUnqYnau56Pmjekh6/wTyDuUU
	2BnqKPIkHWlfw6T8N9ZEwrf7ThYwbNX7JBXhtnbudlPa+5oxWJvl0sGtr6hsZKpfn9AftM
	xPIdWGfF47nIELdgEFAxpCgv8gBPiqU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oTHampD9;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECE2F600C3;
	Thu, 13 Aug 2026 05:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669A81F00A3E;
	Thu, 13 Aug 2026 05:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786599882;
	bh=3ydKZfv20XDA9Yk9OoF1itUqqkZNlBOcLwEjFDoPApk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oTHampD9EL+aNZtVjjB2h74cZMpvrG2Rg7tpIUrpaPKwsd7n901RWDPN777SrZlpp
	 oI8yHNzUjhoibL+KXIY8OoCtw7fLy1q4xkmOzn61cs7XR8LIvtnRw9exlUXdWzu28P
	 0I0iYq0GaEG+7ykgJpjH5p8KgwSKh/Vq6cNjo8gF7e1fHjF8dz56x0b8QG0AlRVwol
	 pJPVD0F9w23zE4wtoIPRzrqBnPDSDPEH5HtePBdwBYbp35i/Hc30kDk/SJy7R6O2dO
	 TFjxV2HyNK9iaD46h9R5UVcTIyDbCkTccqQai9Xm6K9C6ovhC2WyFX6b7qhWDXos1Q
	 CisuQqENrQ94w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/3] Revert "mm/damon/lru_sort: error out for >10000 active_mem_bp"
Date: Wed, 12 Aug 2026 22:44:29 -0700
Message-ID: <20260813054432.101197-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813054432.101197-1-sj@kernel.org>
References: <20260813054432.101197-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: k5dz77g4r6jdww4am166up5be94kjqo7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C225BC0006
X-HE-Tag: 1786599883-954348
X-HE-Meta: U2FsdGVkX18HAZiBo8WHFukPhI3wQY6X8zO6f2f+eMxXIO95p+IQhTaoOlb1r9J/WGLJmcVpGkPQRhoBqcbwKd6ZxgfZ+TS/BaQTrCP7cAdX/6A/agDkF/SlEuQvNbi+/ns347tF37Wgjp7ta83MduH0RM2/Y2XVDEBF1sN/TqyEzqxRRU9QFj26G/ICtALhavvHggMyQ0lhZYVlY/Ym3vFOPQxAZva6v2lOs4wyWwD5jVbUv1av4gPnReV9R2oZG5I9ObSf/rwwExIT4HTycH3FdCOl5ZIIgPcOeFRvNcUBDilapSGFxteuqsFq2aJFE1dTrGwQlBup5w7GrMNFpoIU5DvcO9262Ou1yyyWSR0Vm6MNvS+OItY/kRr37+JIGuuzG5r1km1bUSpxgk11XrVfzelXhvLL57/TJdhXKlbLG+rp8Vl13I//6GImMY7xWsXr7TD8a14ocH6VOS7ltr0rwYsGWfvKrxBi9CX01XG59EPUxZf8KLe653+pR2UbNwYLjNVwxNSL+cN7SMhbgC2vHiYo4uViLg2vHTfTJKWlBHqS7EH3RmizH5DOJWGsIOt4RFCn6MTlCSKKiFyJpEr+9ECVUbbDj0Y3HAlhnyL+rgUYS2fPtjjrHUPVHFZhCb7YH111SusL3FMGijCJvEEofzddWC29Jwpw5hpDjXp5c9GidcZncvA3rKEr5TWDuExqz9TIoveKaoAC/9vMU0hLqD6dA/3bdNS8GVrizG11vYB3OSxAr2n/CfZb4CMYbvzk4KL7kNm/ehYxVU9GLrBXE1oHn5jbwNK02bQDewc2KpzNAPUBvKGcuiKgtuhGREREaHP3ejnE+vH2UWDdmwTAKhY2kpXEdP5v3UT8rEeo8yhGf0NLCmnID2pMT9+pRwjoZJ6tDcb4HNlemF7D+wczZvrwujGLJzcfnyP1Q1yU5RNRbNQIvxKSqrQXqwwKPLSpKgE7As+TcWyLnTK
 1zL++Ktv
 bXuMd3H22uKpfYuGK82deiaPq8UfNt7IvVw/FcVAdL3WBAMQ9Zz9BWDIYdvydRZ1jk1QGHk6hmO3DK4EjdGmgJ/ybBmSnYcVMBt0n4HLCDRbC55JAV444ltZNx8P28N7yUAzFUS6Nn1SyF0mhS9pMZH6mENgxEhJy9Ociq6U4QxevdW3xqyiGc57XqmALxhgwShFJzKJ0McwQXqxg7nrthu64IWrFzmpH/PH+Xx4sQnjVqZup74WCELv2X8+GLYfg5lECku6jz8x3uXYT6mfr8+DUyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit 06befa61c427e74319781e6f35a364cfc32dbae8.

The commit was made to avoid zero damos quota goal target value, because
it can trigger division-by-zero.  Now the core layer handles the corner
case.  It returns an error for any attempt setting the aero
target_value.  The corner case handling in DAMON_LRU_SORT is hence no
more needed.  Remove it.

Note that this slightly changes the user behavior.  It still disallows
active_mem_bp of 10,002.  But now it allows other >10,000 active_mem_bp
values. Setting >10,000 active_mem_bp makes not much sense.  But it
doesn't cause critical problems such as memory leak or crash, either.
Arguably that doesn't deserve additional code complexity.  Just allow
it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index f25ee7326e87c..ad8e86dd3a93e 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -233,8 +233,6 @@ static int damon_lru_sort_add_quota_goals(struct damos *hot_scheme,
 
 	if (!active_mem_bp)
 		return 0;
-	if (10000 < active_mem_bp)
-		return -EINVAL;
 	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
 	if (!goal)
 		return -ENOMEM;
-- 
2.47.3

