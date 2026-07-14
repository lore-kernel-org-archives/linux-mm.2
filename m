Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30DE7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 04:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2522B6B0099; Tue, 14 Jul 2026 00:34:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10F326B0098; Tue, 14 Jul 2026 00:34:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E8C6B009B; Tue, 14 Jul 2026 00:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA8886B0098
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:34:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C27614022F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:48 +0000 (UTC)
X-FDA: 84986116656.22.CBB18F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 93E99180009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iRcG+bUq;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784003686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OgmQTZfSicG2akeujY0x1j+uFMrq86YzkqctonivABI=;
	b=AJ1S6PPS1XdyhsvdBBRk7vgM8TZwpHsjH4Y2lFjxh7aYC25/5Pgjd7s/vKlBFbhO0SWTQ/
	gHdpDd03jsibuCd99yCjtNr59CfOqSn5vXX8hlCNliyG2+cb+UfmQ0gJsZxGSNZeWE47pD
	0hEvqpbAVpkYfgFZKcACFlm00FIrdvE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784003686;
	b=O+zUZToKXwj/n3kRdUE/IQE3kW4WFgb/BVTzPvdNKEHmUVF4TFP2j5pBgcAmdqHQN7RY7Y
	uob69darDRpOHhFDkZ3n/Q8peMhXp+/fGtEjb+ASyOOJrhf/pmEnV0ofcXgdZHHsZ4C94b
	e8rnQ4OxzgC0iS71y4cifOBRvP5MJd8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iRcG+bUq;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC64343CB2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8133B1F00A3A;
	Tue, 14 Jul 2026 04:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784003684;
	bh=OgmQTZfSicG2akeujY0x1j+uFMrq86YzkqctonivABI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRcG+bUqxlShKXkBXEBVh/HqQEiB4R0Smqh5ZqJJu9ZeBTi5TU7fpq6ZUqNRGkZCB
	 cpy19YJ3Nd20RJp6KQ0KcqrwzgeKpbxbSWRo5/MztNkuJcB58M3CKq0ZJm3iPTbeH5
	 jfKdTJs8LLCYsXRHAnFpYwx7dvTCQBT5mWiauhuXhkJ++XrLU8ZRADyQ7r888K2JJL
	 ctYDqvBf6zYRVi55iP9fpoJJa5Lw2plZIZIUIqCtfRG+e5XOqxu+w/u5jzS25Olch5
	 ZPS8fZ98xQVM6LzOwYYfTSAUGCDcstA0kkBIhth8Iegu43AEf9XXwMg1h7vxvTnU37
	 v74H0eBKFSTUA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 07/10] mm/damon/core: hide private damon_filter fields
Date: Mon, 13 Jul 2026 21:34:33 -0700
Message-ID: <20260714043437.95811-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714043437.95811-1-sj@kernel.org>
References: <20260714043437.95811-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 93E99180009
X-Stat-Signature: ptgswe98aeqetehp6thfaedjhdutwc6x
X-HE-Tag: 1784003686-360967
X-HE-Meta: U2FsdGVkX1/3tmTOL96omULp3kt4Ff+cWtyBh1oJoq5nzYikJfqDEKB8AWc9gxP9OCnYcsG51MEUKfVB13mbSJy2ySvwNP9wELLkU8JgRvMbdBYV/VzKjvzkhLxhA/gUilrmLkVi66ISPw7LjxVqDnYqKIqEVYFPB7Q9JhxcBRDxR+FBpgtEDxnfIKIc84xdZBuvJzOWKigYdkoSaeaaxSLQogAmhN2QpLCMEC5h0sHcrBgaUCOBiXKs2aNw9u91mReXo/p57bVft9hRtKEj6MZkv70xVPuQCgb7uySJeOyUmoqgUoG1wk0MQikUXAsuVhcvec3YXpZMVi+on+7eGVyJ13by1lj0XVQUNfiuMVfPc50aPosdCsCYRbDKXyjBVYx0NhcnL5Mc1bFINpmDjCdXNgs05Twb4wfqDMvtMBsoxI8olnodb+S/82kHYPm2qyESAuiKDQhB4Vnt9sEDy2d2xKzwrCdXl5zNqHQltOewWhod8kfA0jdWNc8WGkOdw1MBvwSi8Pmjc20vdrOfFw2Ht0R6zD+qJynicoU6xkoedWW/0goqTFOHzGc8D1hK3Rkcnjb/V/sbclC5S/rCaW4xGkxSjrDYFj2kf3+2RcBzHRNAKaa8ZGV9W4WP/mjiDftWzlgUsgtCnrubv+lD9Q1ByUd6DDPfDzffiDxQ/q2uXRLwjlnLwxB7i6ku3PWQODhy+R8MGehkxzki/L2R8ubmMQdK6HdjzboYb3sh5lzjS5WW/hba9FqzZwWUh+OPp5q5NVWYpviHQGWFWzRvfUKGPGWp/V7o/ZniqdDfpwwJZHMQyqiFU6de3105bOfQ+EIxXtaSgn4pC9r2auhfEV3tnILLa/+L25J0wBU/z9oHe8mbul0J7iuk85ZF7kZ6idRRiPcXOmjwOvKC17Agyu2IdiCV23cnT/TH2CYVrZA1J746ukpQw5+5BTLUdS0jXh8Vua96hRXhAM1RqcM
 GwXqTzKh
 vrJ6m9KhFa8wfwQYeZLOASGkx1klalswPLdpXsE8Z5fVyeeP0cdwBoy+Rrj0vzl3SQGx+qdZHM0jNvRAksKd98IkT7ti5W0oNXhHOeeK/FZcLRzGLsdc601k0M6KJV5aro7w3qhoRZV3BilfZ6trrf3ApySu8NmXwJBZiUhjCvdevAEHPR/ztRHvSgaTWqF6sqrE1KM0MG4fzuddDxObL5J55IUcQDVP76yGhzY7D0SRH2MjFefxDbDSIdTHGKFU1DIjwzz/Z82sX2AXT5P1dWszPwBSSjwX5WtHJXXb709EhBqhr1p0uAMpIx6r7dLWBtOfmafvWeCMRyDpZ8uvAwhyn0EpTGKdi8bzc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_filter->list is intended to be used by only the DAMON core layer.
However, it is mistakenly not marked as private.  Mark as private.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 907d65f03d083..6c3c7c75b6ca3 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -758,7 +758,6 @@ enum damon_filter_type {
  * @matching:	Whether this filter is for the type-matching ones.
  * @allow:	Whether the @type-@matching ones should pass this filter.
  * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
- * @list:	Siblings list.
  */
 struct damon_filter {
 	enum damon_filter_type type;
@@ -767,6 +766,8 @@ struct damon_filter {
 	union {
 		u64 memcg_id;
 	};
+/* private: */
+	/* Siblings list. */
 	struct list_head list;
 };
 
-- 
2.47.3

