Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AB89C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 18:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61D966B00B7; Sat,  4 Jul 2026 14:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CDE76B00B8; Sat,  4 Jul 2026 14:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE516B00B9; Sat,  4 Jul 2026 14:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19CD56B00B8
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 14:11:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8BD921C37D0
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:47 +0000 (UTC)
X-FDA: 84951887454.29.FBC28BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 10499C0002
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="idWhGM/N";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783188706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D62Tcr+yrJC0pq2paze4YieMWP4BsC6k5oHO7N7uukw=;
	b=CdI9ORZjAVFUBFZ2R4CYkRoWbWhcgNUdZN648oxsmvPt/jnwZsfPUskTsQsX178AOMcm+b
	LKMKj4HTtIoHKdn7SREcfRMNPJWRejfvOhC/CsW0Z2+sFOAGpTwEEAdBzBML2hB+OMy9KG
	NqIWxD4lEcc+IXNk5p+2D6fsWjyu1TQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="idWhGM/N";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783188706;
	b=xiB58303bW5cAuxbwIWTMGmh/Xqj6wKxA7ckhfh94GbcDxqLXPB9ehsHzNRR1kFBLYTXrI
	o+CRsy9Ak/3fp5vcporIwvf47XgeoFO1uC20+iWnVVOKB/YPcPI5feoXLEZi8cm1b5rdcz
	Vu0g4ar2Pn8X+3vqYGyB+wOnGj2Eokc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B065E60052
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4222A1F00A3E;
	Sat,  4 Jul 2026 18:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783188705;
	bh=D62Tcr+yrJC0pq2paze4YieMWP4BsC6k5oHO7N7uukw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idWhGM/NfW0pTEDlsAa5Fzw6cTaifXusxiPSV68Fu/A5SGWRzv+Ya57tK/wwmqA77
	 SE22BT2MD81KtUsBZ+XmiuaEUb9UvD3Te7qciTSZIPxwHYef/ijxlLHusmVH0oasTK
	 MnyD1BVyEIyDB9/m/nldUskLSsHbr03qjnQQeOAYsUY1yE2hTx7iXfB2xmT12qW4PL
	 kd5gfTcxOHMNj9nmEfMHIcEkh2jqi3QfXIou2x4bSbf/lJyZvP1Dkb8ivj2NZl6pVp
	 d0evckKD6aTR7/bX6U7NKVko3GVgYfJ6SGkGVhdOIrAZ+QVjennd1m6H+nv8z3sIt1
	 imXDs5Px59OrA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 02/11] samples/damon/mtier: do not stop first context for damon_start() failure
Date: Sat,  4 Jul 2026 11:11:25 -0700
Message-ID: <20260704181135.132956-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260704181135.132956-1-sj@kernel.org>
References: <20260704181135.132956-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 10499C0002
X-Stat-Signature: i6obo7q49qc6d8y7tkp1soy7ybwj8gt7
X-Rspam-User: 
X-HE-Tag: 1783188705-72742
X-HE-Meta: U2FsdGVkX1/9iSB3CETxfpUlVoTJbUqu33N7PYI6Z+mcj0kSuaV8WDQYj9MuVSCGT5fk6hf08XCy3uRGGBlkW5jELxQSQ1vzxaQtes7XLQQfM4j9hJVYKTwX3SgPn+AvSz/yn0h7UMXRIMgRbyDSSycahNxPeyOQVFdbzW51Qe7in7UDrCh7yuitrun31bXj8z49HCk5aGyz18YY9kU0bWLzuJ3tTIBNGWWj+ABRe1QN767tU9HPldo4WnPEmb+ZqBO5cpoCv0YOnN5t3a96DrzidJeH8gwm33sVsc2Ri9Q2yqmLJHUyaGhrQH5ULwrRP1QKQe44E13BiE/0lLBIX9VFbokBXHIbxynyHfAPISixDnXrvygfuNhtqBMpY3LCCHNfBhvEThaw1ovmBodxi6rgtbPcxwTKvUf70fr3irn67mNTAVqw43p39Lhbz4Y8J3ZEuF+f4lCQLW+GBhsqcSaEx/kK/ZHaMFVYDX+ATne4qu/A9frduzR2dx9rltxQwGsmNTc66zGte2wRfl7/b2F03VK+Ei7IRxE+XYlGEfNwd2w+5usMykcrCT4SZJyroLpU0ax4lV4grvcZQj2BDu1VuN5120sM6k7Nnt7vAaDnnAkcRwPIj/8AuMrfce5glfipYhyxdHo3Hwxs0t0E7Ku0qwJhxeUdTIlMr9uG8fKydKHD7xcbhvNUJCeruarAuyKe4INFIBR6QX4uIQRBJPp6Xe2q2ur3QVN+JZLfOlzC90ssSWmaC2ESJqUEOOT3YkTFdtPoY0a33FAnBfhcCkm3+2Qc+VW28mtiszBwLkrAAZql1zSlbjDX3wXznFi6y/guL+wS6gDJDyQlmDHsi8HcT1Af9u0/jWuwz3p2zxvlQH+5P7uK5HpoBbJLTlB9PTWd7QelWkY+D8XrmPKZpieLrjQEp8aRhuCz2VF79G2zM3zw1H/6R7CFs8aa6uABVhaqwoN+TINWUykD5Y6
 Wgbn8h8b
 uHSNdSChu3ipRes8u+8PBUYGbxIMxbxR3QHZko8O9puBsfpUdu5nKEm4u8uyjwPVHBMHPuPaa9SIJQIA7xsflJbzpG9jgbrWsj2POvKbNLqppRzmlb4mpMAmshUu4tL4T9+K+RepIRBu4xCaokeqf96930huxKuBMCLnHLhhQTO+bY1BagwT6DUOHK1uznTPqCuyo+XAbdiLE77/wsLA6v07moQ7CS2b2cagQT/awsVA0satxjo5cq0keN0h1djwaRV0YVREFt3vIsGNDg7fSGsg/WYRjOX4AEBy28LMpZTX1ctOGBkzPkEHNAUGtS6L072Z1TfxkwtdxtJl1gJXGF7RVF77Ew5o+z52O5kzfKI6Vqc8XhjHTP1t6DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_start() was able to fail while keeping the first context running.
mtier hence stops the first context in the case.  damon_start() is
refactored to avoid that.  The error handling is no longer necessary.
Remove it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/mtier.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index e567f4edd80ea..90881e8bd441f 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -193,8 +193,6 @@ static int damon_sample_mtier_start(void)
 	if (!err)
 		return 0;
 
-	if (damon_is_running(ctxs[0]))
-		damon_stop(ctxs, 1);
 	damon_destroy_ctx(ctxs[0]);
 	damon_destroy_ctx(ctxs[1]);
 	return err;
-- 
2.47.3

