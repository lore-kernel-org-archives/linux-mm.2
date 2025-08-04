Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5A9C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 14:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E2AD8E0005; Mon,  4 Aug 2025 10:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BB478E0001; Mon,  4 Aug 2025 10:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7198E0005; Mon,  4 Aug 2025 10:38:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F4AD8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:38:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0736BA840
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:38:39 +0000 (UTC)
X-FDA: 83739331158.18.7CB632C
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2970B180012
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:38:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jbaixovd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754318318; a=rsa-sha256;
	cv=none;
	b=GwrRFtskvlf+gD1giI4vDHPmeZZoQyTl6Faqonyxw6/LKft2DXAw73WSnrAMVgZ9sy3mWC
	prRVvFP+KC/PZMYbXc66CvBzs0vFA4BOzfCJpOKcw8oao8MNf4r39XIZLHBopvxZZ5RXuF
	WsS+lmdcP408WM+raA7L6VVNeKJh0eY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jbaixovd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754318318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nKqsGYjG/1BmdnQ0cztxxQLi7+AdyPlUFMMBGfBbx0k=;
	b=ea5RhzvWOBHfXVoob8pnYDD+KUZXsg2DjK2szgtZ+0AiGWtSxLsaDoqS97IC3vlt7HbOxD
	bLUxfnE6e6YLTSlPvYD8yk6xPG4ttQ9kHIEGpxettxoFTqrZGB14L82T++Iq1rI9CITcpg
	/oFYuYeTI1Aq6EimXMt+HCS9z7yHQN8=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-320dfa8cfa3so3507919a91.3
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 07:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754318317; x=1754923117; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nKqsGYjG/1BmdnQ0cztxxQLi7+AdyPlUFMMBGfBbx0k=;
        b=Jbaixovd/t3tQ597bvtJ+30teQ0GAHWT9twBkSEzrgf9zE5UCzD/CFW6rfi3rZBo2z
         7WXnNLKva/OWjil7ioUw/r60UOyuUyau6SvxHNeIp+xl7Mcvl2mu7wLMcXRKJfoJxalm
         0NB/3XiX+apNOHgGPhAUjg3AKkvzZrLkaFgiOO9ADIfsY7a/vcJ4ekQEEe5eKlCBqzd0
         kEXCCyETxWoweYwBs7WYVtVE4P9Gc3Ld9kO6rsFIB/n7hgnN95VzFfnePvXnJfqSWrxG
         tmmztX1oBVR5e0kOKIP8WdxcmJBcwtBiEuQfMmFObad6Mkyro0wNWm0WlZhPL/rIfYQ2
         EOaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754318317; x=1754923117;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nKqsGYjG/1BmdnQ0cztxxQLi7+AdyPlUFMMBGfBbx0k=;
        b=DM8/SmTPMZtLDvy5h0VVAiX602wqKbbi7eBpZT8qZiKxeAhi6XEJA7ERc30PxHi/cI
         rKZp9nkOLYxCDppyQcdtrkACofoLTSpS6FBEX/kV4OPlL0rKyyx62VH64qez6xpFUh+C
         mB/ne2KoikcHHVeapcvaLCtJ1dKh2qVKwUAB0DS3OfvG7VPVh8Idn78RQ3yLErBtA1Ur
         pY4BBFoNhbrH+JgAwnXbF88jnRZreSaVJ74++Rz3uPNf7boUrcwSbnX3ywpayhVoe3ba
         NgNDmr+94PgPp0PMK7IBTKuAdzFmeyD2HZs6yKcRS9Vr4P7UqpVsTh3vWESJcHBV5apB
         KGOw==
X-Forwarded-Encrypted: i=1; AJvYcCWePZljxStp+xPvuF2gGBMxJSPqRebzJuGRkEfOpJyFBZTdYiVsd91umLPthM5YhDERrB3wEy+QeA==@kvack.org
X-Gm-Message-State: AOJu0YzTm84xAnK2BHFZsgQX2MaDPNkK7stMmJg/ZJ7cJSXehRAtDxtL
	B1rjLGRm/1k+wBGOKRGhuerc2tzxnavuDupBTlvmaJv3BV81zgFgX1tA0w6CvpEdynE=
X-Gm-Gg: ASbGncvotEptKeGc046MQKfUFATWX+L9Q7Ki0sr8tL/2Rd2zuPvmiDCpKRHyjxHNDrC
	A4yaqIIcSlquMlYO/VGenqJuxiFOS5QshBajOUMUKgXXaYmsLqYRS2181IbMCYyLRVS8hmaj97e
	cNxJGBW+WuKBdYCtkVsFdG+ITnCSP6ov8FmhgQAynI6hGi9wM4F63i5JZeOveOHCT7uKezdcR2f
	Ar4+997BMJXrJHFnMYhQTsb6vuEmI+sXon7HpLGojKDyARZKuhKWbGLjk7u7ZITheTj31XkgEq3
	++RYCsHlqM4qo404b8B0Kqv9O4PFe1pyKxoJ9rjz15UaMNl23IwEMoqFd3t6DHeFunRwLiOau1C
	/iLmXpLQBySQO/9Gc
X-Google-Smtp-Source: AGHT+IHRqr31KNCSXP7Z/0yBPbquY2OT5HTWJj9w7WcR5N7xmXNiwClCJptbegHrPC6bWbI9yVA9OA==
X-Received: by 2002:a17:90b:4a02:b0:313:f6fa:5bca with SMTP id 98e67ed59e1d1-321162a25dbmr11632697a91.22.1754318316926;
        Mon, 04 Aug 2025 07:38:36 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63ee4f42sm14773433a91.23.2025.08.04.07.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 07:38:36 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [PATCH v2] mm/damon: update expired description of damos_action
Date: Mon,  4 Aug 2025 23:38:16 +0900
Message-ID: <20250804143816.29654-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2970B180012
X-Stat-Signature: ac4cy1y5xhfemkrqyoi91prdm4r8ydpi
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754318317-66868
X-HE-Meta: U2FsdGVkX1/hG+eK+DaIUmDVV5zqYbtK9Gr+P7qsPlXJKLepyytPIxH322wcOoWXzGCOmG0ke/ch8kzPd2yjXkTHqXFWAObh7Pne7DtLQm4LTYvV8nqDxBsOy9DASOAITyvG3qa37urzDmvRSCyHElo5PhRWp4UPubPUEHn/PxZIc938vGOw4SF01NguwqtxstkSmp9T/uQh7qtQVSf1PujfzygoMzvztZmVotIc+G8IW4LAHl4bz8cMUoFp29aLm52tWwvfdD5/w3ONEAYL6VwQ00lGZW7zA5mc8B5Fn6YEFFTcCtyCrJ8o0Wc2bsQl9ItDqKT86jAsC3qX5TstvzS16KKt9R+IycmyVtvngnSEWB7ZiXDO6iPElM8v4xtTfFWi1OPoQbfMu2oxrDq8YZeGNVFYUWKqW9r6h2lQ5I8ACiZ8w873Nxl76JA1a3EiQHSFM8B9iIvWzOuc0QoBQZe7OmH0+mWseBGDrte3HYetMyWBsOKEe7ItxORBMA4AkmKfRi13phmnyLUZ5WlW1cxsI4UTbWrBLt4tCJkzJM7TWvSh4MmxrN7yZZEjC/ImW9tIuKPhVOVAo4s0M7JCHCS77RJCJL06cyYpdBGSdL4JCjTGtzTALxFkg6S4EhsOj8uuPz1BEe0kJPCu/HJmkDmLh1oUSRoAea9eScVDhj1OV6NYHQFm4/iYfCjIu32YjVbbakzzLxKlU6jKTPYr9VSnWWXChYJ4Vw7QqvfdZ519jswuwi2xiKT7eJgeiJ9ZpR9ns7ek2mjYLjKH3E6V+RNtRp5XIeylcowcrNVnfgEVNECPvuCTwCgqM9zVtDDTCiBY0QrfFfrYoUyrnpz5FAoVq6Ykns3ItxIEahKeamAbWdO9rPz0uVKMOmNKjCStyVb2sTOdcE2elsNBtJBGBqHnZZyIQHQU7WybVDCbLtsxgZOPopgauI/jrlfIdB3XK92sTaXFgu/DuwD7dkr
 QAY0JPaO
 JQp93troWUleDjF39a2uvImaAdKj4wGU1BIRCLh8OLdxBdsHHL9vH9RpKjQkA+lIVJoLv9gNNnQQKB0cKLoo3RkFjp97Gd3YHO5MPYy7fOQaT2kHHKi4A7d8FNJPUQZZ4G/i3lzlkXm1QVAg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nowadays, damos operation actions support more various operation set.
But comments(also, generated documentation) doesn't updated.
So, fix the comments with current support status.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
Changes from v1 [1]:
1. change baseline from damon/next to mm/mm-new
2. Add note about DAMOS_PAGEOUT and demotion.

[1] https://lore.kernel.org/all/20250731132230.80046-1-ekffu200098@gmail.com/

---
I also watch your comment from [1]. Thank you for not forgetting :)

[1] https://lore.kernel.org/damon/20250801233942.1614-1-sj@kernel.org/

---
 include/linux/damon.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f13664c62ddd..d4b3ffd6144d 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -110,7 +110,7 @@ struct damon_target {
  *
  * @DAMOS_WILLNEED:	Call ``madvise()`` for the region with MADV_WILLNEED.
  * @DAMOS_COLD:		Call ``madvise()`` for the region with MADV_COLD.
- * @DAMOS_PAGEOUT:	Call ``madvise()`` for the region with MADV_PAGEOUT.
+ * @DAMOS_PAGEOUT:	Reclaim the region.
  * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
  * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
  * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
@@ -123,8 +123,10 @@ struct damon_target {
  * The support of each action is up to running &struct damon_operations.
  * &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR supports all actions except
  * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_OPS_PADDR
- * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
- * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
+ * supports all actions except &enum DAMOS_WILLNEED, &enum DAMOS_COLD,
+ * &enum DAMOS_HUGEPAGE, &enum DAMOS_NOHUGEPAGE.
+ *
+ * Note that DAMOS_PAGEOUT doesn't trigger demotions.
  */
 enum damos_action {
 	DAMOS_WILLNEED,
-- 
2.43.0


