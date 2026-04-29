Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B5BEFF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 04:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AB2E6B008A; Wed, 29 Apr 2026 00:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 782B16B008C; Wed, 29 Apr 2026 00:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 672286B0092; Wed, 29 Apr 2026 00:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57E2D6B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 00:13:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9CAACA073F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:12:40 +0000 (UTC)
X-FDA: 84710272080.05.136604D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 014CC2000E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:12:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KrFQKhs8;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777435959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UlB2ixe8afvreIptxP+Jt9Hl0ZVCxTpTNKTfJdJUZTE=;
	b=Rlhbvny4ZHUUEnTqSbDLrVd+cCkGuOW7Jrfym0QMvEfy0W+1EkeAJgoGPNyiZ3nfrvQAXD
	Cw45ZtG80Ry/lXUeN+ch5704u202ijeiP0Ny+oI/BqPffhbiMu1xU0iOgzsd5KJ4uf2q2Z
	HIgxc7AXX+zuIg9Oo7ubN62CkWZ+xWk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KrFQKhs8;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777435959; a=rsa-sha256;
	cv=none;
	b=vZIJn5OkKQWk46+SBV4ZLEP7xxZIvxb/Ly7EkhmRqKvkgSKzm4+iIyvzfKlf/H+4x2guva
	zOpNRVYQGXExFRolRvWIHn60ZvOp0xi4hUAi036Dw0dYYA3nwE0dlZ8pglDYTKradbC64M
	sLlYcwI3c0Zvam39OkOQxGlA20TTAL0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6395C6132D;
	Wed, 29 Apr 2026 04:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37B8C2BCC6;
	Wed, 29 Apr 2026 04:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777435958;
	bh=xMqq3xpXSyg1zeBbUMUMZmxc1oat68q5ZzAMINfxXRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrFQKhs8TpgSxmgq6oc2QBSOSpUfh6QnY0mq3KvhaNsnUkeb+vFvkzhrYL4Q5zmlP
	 fMaHEh8kNJH+Ry43zgBsmVjjbr36lZ37MsoI/PGqHtZS5Z/kkbQ++AU8x8uyJwB/ly
	 JT3araYWCHuo2N2R3qd96lw4CyPn4QTvUfFyFGEn/CSznJL01umPYDjvRKO4d3kpdu
	 GuzVlGyfCQHOhZRtR0SOiTZMiQ8qBwEJHQwUv8ZY8c4/oixWDZRfhS25C1Ed2pkrGW
	 abvpKBtVRPSpnYbxg62tHXUNRbWnHE4zxnOgDsAZQfa6nSmsBz50OqGPtTLs12FtDI
	 BcVijjgXikl/A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/7] mm/damon/lru_sort: cover all system rams
Date: Tue, 28 Apr 2026 21:12:25 -0700
Message-ID: <20260429041232.90257-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429041232.90257-1-sj@kernel.org>
References: <20260429041232.90257-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 014CC2000E
X-Rspam-User: 
X-Stat-Signature: yi1ug9iwuxnyh63u114i1c5k3yhsqks3
X-HE-Tag: 1777435958-406429
X-HE-Meta: U2FsdGVkX1+L6V0ZXpGgS4VN0koERJM2M6mfw+dcC98KMp/taifw0Wla7p6hqdHJYRz6KBv/Ad3KjymvxGBg97SqUX60YPAEC5/TPTBkEoFuTVZY8WT6j4P9yOdiiQUuEAdds1qc489lUyJNh8RET1ol85Y9zNnlqh8D0nWQtgbDzCK9y0B1t5sMfabiGW3atCc4qNAjpSYns0XtDYxNOCehQ1arC2OSpPo87goSQRiD8MLVyZFPkwG+lARmse4/ZCDbO1u29B4xEPgn3yBWrqMdr+QQ/OmiYKWaMFprfb1e3J/hTKnthoqHYMqce3l1BD/qRXpteyKQjAJkaEnk4/Ym1L7OMZJo7ZWtKJ/6epkrQJhYrqb//PFz1rRYYux17hUk+ssn6z1q2geRHwBZrBuF7W5IKopLlBQSl+sfZ5zstXguGrej+E/xXflruJSX+ZF7BHB18glDFfEBQ6VZEehj+EKbVizjlCU1o+3+xqGQ+ZTHIKhlmIZtyniwARprVIM552JnOrEjZ7jkMafYFsfpfxei7/+ao7VqspUonV1mFQ0ZGZgj0NUrdH+xoORso2mFfoHX8W+cldRfI8/WK/ydNL89B4AwdfXJeNZD4UQdyepUI3AO6iFKFMDQpR67pSCYIgRgUVRBAxf1G8Z8KJjim6iKVCG69pBMNf+eHXxWCr/0xQ0bKypAlVlN7Pt95Qg8TEfbaqAKX0qwLyBT2PsaVSEJWVULg695kDwi9klW8/eNss0IhtBwabDKoyFMxb87LGMiMWiWC2P566HGd/GrmPGh8XnAy+ckRpFUEa7ODsb6LnLI2Aaj022HsFJ5M3qXwoBQLlJ2RDfm4TAs1Z55zeo8P+csW8AIZtc57idJFger2y0jmJhO03gHSJeKrJgOKFgp7zXprkbyH4U0nRSr+rVY7nSuOP6oI4rOWe28eC11wc2cWIONzZxU8FfCZ4UrZ0Fv6apnaN+mPNE
 BiY8dXx8
 diLofvp+q4Gdb/t972kjlptRcXGAmY0oHF2nER+E2jKSla1cfJYS1TjacVDJGQKCTYtmYS8RQErRAigFhDpZXXnltQKpaxFoC9/yjJZqHtm7a11eK/01rk9RbbVkJ0ios3/Ni5C9lV07Z3bdUArR/vsGoMqgahYVPPEbNaZbEGync85wO5DktTtIBQ3Q4DCxlGhE3V3SqtqucCc7FiSg8CUFNrVZy9ZwyibuQh67ofjp9J8NFAIGp9fmyFKN19ebZTqm9k06OxIshKORsG+r7ynvQow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_LRU_SORT allows users to set the physical address range to monitor
and do the work on.  When users don't explicitly set the range, the
biggest system ram resource of the system is selected as the monitoring
target address range.  The intention was to reduce the overhead from
monitoring non-System RAM areas because monitoring non-System RAM may be
meaningless.  However, because of the sampling based access check and
adaptive regions adjustment, the overhead should be negligible.  It
makes more sense to just cover all system rams of the system.  Do so.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 7569e471160a0..2eb559d913b62 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -139,7 +139,8 @@ DEFINE_DAMON_MODULES_MON_ATTRS_PARAMS(damon_lru_sort_mon_attrs);
  * Start of the target memory region in physical address.
  *
  * The start physical address of memory region that DAMON_LRU_SORT will do work
- * against.  By default, biggest System RAM is used as the region.
+ * against.  By default, the system's entire physical memory is used as the
+ * region.
  */
 static unsigned long monitor_region_start __read_mostly;
 module_param(monitor_region_start, ulong, 0600);
@@ -148,7 +149,8 @@ module_param(monitor_region_start, ulong, 0600);
  * End of the target memory region in physical address.
  *
  * The end physical address of memory region that DAMON_LRU_SORT will do work
- * against.  By default, biggest System RAM is used as the region.
+ * against.  By default, the system's entire physical memory is used as the
+ * region.
  */
 static unsigned long monitor_region_end __read_mostly;
 module_param(monitor_region_end, ulong, 0600);
@@ -326,7 +328,7 @@ static int damon_lru_sort_apply_parameters(void)
 	if (err)
 		goto out;
 
-	err = damon_set_region_biggest_system_ram_default(param_target,
+	err = damon_set_region_system_rams_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
 					param_ctx->addr_unit,
-- 
2.47.3

