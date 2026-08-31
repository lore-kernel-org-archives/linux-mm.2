Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCB39C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97766B009F; Mon, 31 Aug 2026 10:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B47976B00A0; Mon, 31 Aug 2026 10:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A362B6B00A1; Mon, 31 Aug 2026 10:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E92D6B009F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:57:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC7561C03C6
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:57:34 +0000 (UTC)
X-FDA: 85161868428.23.F106A20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6603B100007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:57:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N+zCiSEG;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788188253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m77KSml7J9PVuWvfDXU+9FGVhk1wJqugBBvBHQZQDmo=;
	b=IDREGx7B2xh4HzYqmnfZ3e91yPPt8MPZ+IbbAljSIfwoiE6sAjDmZo1gNU+GdbmFnjMENt
	LaHnQPfVa3VJY5ObuZmlkA77lGNwClEZENWNazTPnkFyZcT9MAq2eMgtowWwQeUHpRiu3Q
	WykWJfxVFnJVQtf/yPgWtp2i1NgqDJg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788188253;
	b=DQ3nc9pnCRhkY/b0yY6Dac4BFBsFQqK/lU7HwKIe3MXjpoXdXVvtW0GTKAJmnXiUC44hX2
	f1cMYdQ+lKbyxxyHZBqaKe1MJCpLYa95TefKRDlL3HAT7K7bBqtY/VE3A0HQ3d8ernvMOt
	Ss2qmLfiiHZVSghxrnxulEb6rnofNEQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N+zCiSEG;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E5EC36013A;
	Mon, 31 Aug 2026 14:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEC91F00A3E;
	Mon, 31 Aug 2026 14:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788188252;
	bh=m77KSml7J9PVuWvfDXU+9FGVhk1wJqugBBvBHQZQDmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+zCiSEGrK3Nhq36uxKo0p9P/kcOA4cpEbSw5T1KZg+DAK8nJN/eTFcWbFp0r5vvs
	 2P/YVxF3C7gxWGtQLNfoDgeZ6uK2Whscwipd1W8j/ie71rBLoY7vpdjl9ANKFYBbPw
	 oTNNIOkfqYWe1l1auFjEgXoKhNfBWdaoqSQJtVQOJnrvXFTPXw4ZqpPQQ+kLHIFC4d
	 2R3RBZHF1ZtLQdsiZfibRVSCGTi+WjRfuN+gUOJUx+pcM0yiSxVzuoXvIjva+B0H0o
	 P7GFCV33v1VXSE9jCh3GmunH/A18fTlnnUIupp2+JUN8SbsWuxLWb7X8TbZo7wiQ5e
	 gfqrnnq930bpQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cheng-Han Wu <hank20010209@gmail.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/2] mm/damon/core: remove unused damon_nr_running_ctxs()
Date: Mon, 31 Aug 2026 07:57:22 -0700
Message-ID: <20260831145724.82387-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831145724.82387-1-sj@kernel.org>
References: <20260831145724.82387-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6603B100007
X-Stat-Signature: swr5znzgn7p4wu1h6qym7efiae7pb34y
X-HE-Tag: 1788188253-722290
X-HE-Meta: U2FsdGVkX1/nKsTX4NaGZDYQ81HHtOX6dQJ9r4UE5zqPaoF0XiwvcarJ+f0i4C/PYEQfTxE575rwsQfvzbGDmb6PTBiXO3XwciIqjZMzkSLTw1CbeeYLI8A6V/ZvgeX/Rq6CpBaiLGpimQ6Bk2HZFYRfmFUy8UDNwbK9OZQCoFkfv6NQbi/Ki5SZBKWExWRw1eefxXbz1abdn+bbNcjn/e6CVam2Wkt6DKdGLfdD0gKUHycXQNWjZb586mBGsJCXcDsqTxwUwviIrZ6bxek9bM7QYlfsEXMsOlvF+XOSm4/zhsaGIzpU4Uztb6UZdgiG3gvVDvxCTx7hGDxoP9RUNj9wcA2KI+qsV+0FO6NGRdtTrRale0xXvLHHIZFphTVo19mYEeOQKKFB6MrEIDXY3/4UY29HRfQLkuwBBFzFmY+At7Piz+pYyhx2IJ+pjxy/5lusQdgxTBPetKfFa9hlIZgD9y1IjOm9zDEatKEgWCDlXUo6HZ30+XPIXeiZzP5mRHk4iD79ap21y+xZ1g9NmWHZGzBjJp6c+cYDwsI2lmw92EdQ55NhiREvQwIBC0lqH/78dL5nVyR0/ZeT3FxdUy415munaFd8s/BDyDCP/U+SwUtGcnMBGTFDh65TkWBPFSmHTqsPNEyyPDmNOkB7Iw3wmjZxK+aL6bXXnyjP5mTCK9ySq50g5OxN1A8hVHrsNPf311n7vNP+S4mMbr+H0uohBLuUM/aqkpTnPk9ATIOfJyAzR6YeTjhOGXKnHbRt+BntFly59itHCnLMCDYQC4PmnQYqdBgM+0lXIIHCn7Zc3yXoeuHkwe9L5elmzP+S3BU0VoZrpBqhGD3dv+vG8+B2PCqAK2W7Zh0EPfZZAPGbXxrJX4EQORiHPvsmJifjJHT8Z2wZ6ZkMwOlds8cCyMe03oo96hQbRDIvuNJWndboInudNlIbsAiOw4FLcevMEb54h0trUmKxtbGfZXd
 ZYWrLsKD
 WJF4W/N9dYQTvENfqKfv/mI+Y48D1GTWI46EtFufKDsxUg1xAYxWHOWismRWY+tGf75Kyrq/HH4g7VdXJwg5pn/fNXDpwvRj4X93Bl3V3OKUTxvV5aaseDnpaz1oPXgG3w9oM1ikY3F4ArafO+t+qvr7/6p36oP+5mOp9B6BHQ3xjZ1+33gx6t5inqALIlxfSH9Pibo1IlrCktb4hSquYdlS6xA70pkng5w2eaqm2VgYvo0HuXf7YX0P+LcdZYL22fGK6f3St0P40nAIVF5hO/e+EY3nvb/Aaz7YrVqVU75ErhrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cheng-Han Wu <hank20010209@gmail.com>

damon_nr_running_ctxs() has had no in-tree users since commit
5ec4333b1967 ("mm/damon: remove DAMON debugfs interface") removed
all of its callers.

Remove the unused declaration and definition.

Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  1 -
 mm/damon/core.c       | 14 --------------
 2 files changed, 15 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 9835b864a8db9..6842a336291e8 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1067,7 +1067,6 @@ int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs);
 void damon_set_schemes(struct damon_ctx *ctx,
 			struct damos **schemes, ssize_t nr_schemes);
 int damon_commit_ctx(struct damon_ctx *old_ctx, struct damon_ctx *new_ctx);
-int damon_nr_running_ctxs(void);
 bool damon_is_registered_ops(enum damon_ops_id id);
 int damon_register_ops(struct damon_operations *ops);
 int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 043eb38de5fd3..53c3f97e3f126 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1866,20 +1866,6 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	return err;
 }
 
-/**
- * damon_nr_running_ctxs() - Return number of currently running contexts.
- */
-int damon_nr_running_ctxs(void)
-{
-	int nr_ctxs;
-
-	mutex_lock(&damon_lock);
-	nr_ctxs = nr_running_ctxs;
-	mutex_unlock(&damon_lock);
-
-	return nr_ctxs;
-}
-
 /* Returns the size upper limit for each monitoring region */
 static unsigned long damon_region_sz_limit(struct damon_ctx *ctx)
 {
-- 
2.47.3

