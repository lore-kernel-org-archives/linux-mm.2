Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 941A7FD0048
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:52:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C5E76B008A; Sat, 28 Feb 2026 20:52:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0738B6B008C; Sat, 28 Feb 2026 20:52:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEBC26B0092; Sat, 28 Feb 2026 20:52:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE8CC6B008A
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:52:29 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B04801A03EC
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:52:29 +0000 (UTC)
X-FDA: 84495819618.16.D420D67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 03F39180007
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:52:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I0yypgzt;
	spf=pass (imf16.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772329948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uwMtsgZoLBsRhn3lFaYBmVOn3vHrABivlqDzgcUYJTY=;
	b=0CQegV3zKQPD2tYm6rkgJyaC/+YCcR0IGn2uO7GlZQIgjRlT6ZIxamvf4iuLiM7Xs76M1e
	55MHA5SY9ZFy6qVrnV5POKXxig7RiBr8mguiirVMBjQDOUSJKMZoNmKYJHr+gkgcZEbEGo
	SLKPR8sdlxCiQ5vDUWR5wZOLA9nlik4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772329948; a=rsa-sha256;
	cv=none;
	b=Wt9apGaD8Ae9kWzasp/1QE8I9aLZXVw4CJsQ9h4nPk9mGGor/hbJUd2JPEmYhcJ+2G/p+i
	zTM6yjM999vMANltSK1b232ednI3rMbEmSRNWrn7joa64FOE5iFym1otWooWaQMvd2xOA2
	p8J+BnWKniEgdsG7MlNJKat6QYXg+K8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I0yypgzt;
	spf=pass (imf16.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 182E543941;
	Sun,  1 Mar 2026 01:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A63BC19421;
	Sun,  1 Mar 2026 01:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329947;
	bh=eSH/epSalkFOYEVt6UOhEJpECxpdgQxRvntgP02NzTE=;
	h=From:To:Cc:Subject:Date:From;
	b=I0yypgztqHYHudhBA6ByA6knGUXoboWc2PlZ+XhbgEniQWl5akFhn6IQfYkd0Wjs0
	 qzicJi12uTR2v/UKr+qFY1E8mPeqnhsdaOtVJTp3dneWEig21BSimo5UF+BK+I+9za
	 nlxGMqFz02xAG9LswMnw6XagAmh5CgBNpNQJfpjIUsjC9ri+p3ffDv6p27A5MrhcnN
	 CVPkmxdMWa4791DvD7t1j0H9Z0BXrcsyEzrihEoEu1U7E6pCG4ci9EQRNg8NGsV3UC
	 pD0uRqd4L6kvqBNSlWlv/mnKeA7blIVJ0NCiXQ1/h1YUBJfRcnHEt7DNWMheLyKXtL
	 i55ZzeVDmRqHg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	kartikey406@gmail.com
Cc: syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com,
	Uladzislau Rezki <urezki@gmail.com>,
	Hillf Danton <hdanton@sina.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:52:24 -0500
Message-ID: <20260301015225.1718913-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: snq8ab5ty5iiye3tyiycb4oki4yqmd3g
X-Rspamd-Queue-Id: 03F39180007
X-Rspamd-Server: rspam03
X-HE-Tag: 1772329947-192879
X-HE-Meta: U2FsdGVkX1+CvSb6f+a95nC5BXGybMvkINjshBblLqvSwYnPddsvRgkvO8mbvzkUsUMxNOxHEYv0RN8z1XSswCNA95705xIAO+Zs4Gy6ixOdGOAMxPIcNg5MUdPUMTZ5OsIXDzYn/qFnGbjCA46bCj+6WTxuSV1FDub53cVYbQFafSoMwd0y/ROlavpZ2mjIZgXy/mILHTstvBbrRV3Ozv1+DJPuauDi4LiEtTWdV0fukzTga1D5ArCW64J+jp7I6mqLuA0mJn+4VV4uMzGBZHdj+psw1a34ANjZdFwzvZE3bRxeV+8OW7eEGLM1kCseoM7XPmte78ixM7j0w0tiW9PcgELPOdE5R/jCUdUZU5k3ZVt8dbTSF+lECWJLkJ0hx45YtpAHJNcBU+EXOR2LLqy8vJ3DqO9nuA98yMARM31SjShq6xMeATPtpN1CBfa8zNgDlaOewWMvsUwCrvLAQxUQpGhkkhlJxAocUKz5VmJzABEQPea2QYUl1HvhQDtmo51xPngBAQxB3ixuxjBzE2Nzb6uXfQGnT8/vNT4A2lFeWJr10i2HU8Bmi3qDBoDGqK2rF+ZG+Y+thpYSgsj1EoHTnffwEhQzu/VuQZ7ZLdZ1Zy+las1BA7uLKQowHDp49jfDrmNcknzvT12xS6SvEQFEhR6s+G3eHp0Bh8c9S1VMuswPbHdHUZ3X7dl9n58nCm6lARYOn6mQuwvurZQedeajN/bRlbmXp35BBsRLVuzKBt3fZJKM9Gu4wK1kYVfDPwvItzV+uEuV1oJUgRJz7KIJDLB8cxVAYK074xikOi1yZzf0FeQTsJmwayZg3kqImDmBm1DYC3rxTZa4qqeWOeBkbCvm7CLlrV0OhWYKV1JgR//LOR1E1I/S2fwNP1IdFchLmb+yFtqYqQ0Rmino2aooLVNSba0Af3SPzeQmoTxg5Y92Wnvw7FbDpH+9OYICMC306FfvtNgPJgel3Nu
 XZz6SX7w
 csoV5c0pLznGTyQprZbVTXQmmJKTCoPhMJ/WIwHx6GF5/+PU8YiNvZcnnh7SgzIDAOzED0Epiy6ndboOmRvpF/jpRhM9gyuNuDufRw+yMeG0MWZccYnsmZZBsJEGl5EQnCyM+zALCthWzapfNmn8ZEoYvXPXZedqEnDfHb/mluWFoa938fz0Y3tXsI+5mKxZnUkVAG+J85xVUpttEDTgY2L8rOZmXXzwqw3fzi+PuupiF8TKWK6+uKw6OlOvC1k5zZCSX2i1IDPeo8qKb4HBtV8dDj+FUElOtq616M2e74QNQYCJj7/l4mMYKMGoF/G7GABOmoMBwJjNWMXMHAbX56TWYz3TnUSKfYJvCAfO+CUtJiuBmzaAN9yJdZfe1xg6tY974Fzteka3eg48XTHDqpWil5EQmBFzbSff6EoBwqf8svXLoGMqK1hC+xpZE1Nh9Uktic6ZO9H55irt+bI9wwbxYPBDmQswU9yqg77UD21bfmtS68eRBBCiVe6pkNg12WmFawUSv8VER6y/JGef2Y6VPN11j2fD+QgikhECACTnkvrXlJKkSOjxZJKs5aOAP0OYQIZzgGX2Gu3+/rE8oQmdc8bAYEzWQQHMzN1EmMY52GglGU/rnmtu7YzB109ntoWzd0pUOnm8u2XU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 5747435e0fd474c24530ef1a6822f47e7d264b27 Mon Sep 17 00:00:00 2001
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 12 Jan 2026 16:06:12 +0530
Subject: [PATCH] mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node

When CONFIG_PAGE_OWNER is enabled, freeing KASAN shadow pages during
vmalloc cleanup triggers expensive stack unwinding that acquires RCU read
locks.  Processing a large purge_list without rescheduling can cause the
task to hold CPU for extended periods (10+ seconds), leading to RCU stalls
and potential OOM conditions.

The issue manifests in purge_vmap_node() -> kasan_release_vmalloc_node()
where iterating through hundreds or thousands of vmap_area entries and
freeing their associated shadow pages causes:

  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
  rcu: Tasks blocked on level-0 rcu_node (CPUs 0-1): P6229/1:b..l
  ...
  task:kworker/0:17 state:R running task stack:28840 pid:6229
  ...
  kasan_release_vmalloc_node+0x1ba/0xad0 mm/vmalloc.c:2299
  purge_vmap_node+0x1ba/0xad0 mm/vmalloc.c:2299

Each call to kasan_release_vmalloc() can free many pages, and with
page_owner tracking, each free triggers save_stack() which performs stack
unwinding under RCU read lock.  Without yielding, this creates an
unbounded RCU critical section.

Add periodic cond_resched() calls within the loop to allow:
- RCU grace periods to complete
- Other tasks to run
- Scheduler to preempt when needed

The fix uses need_resched() for immediate response under load, with a
batch count of 32 as a guaranteed upper bound to prevent worst-case stalls
even under light load.

Link: https://lkml.kernel.org/r/20260112103612.627247-1-kartikey406@gmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d8d4c31d40f868eaea30
Link: https://lore.kernel.org/all/20260112084723.622910-1-kartikey406@gmail.com/T/ [v1]
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/vmalloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 32d6ee92d4ff8..ca4c653286870 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2273,11 +2273,14 @@ decay_va_pool_node(struct vmap_node *vn, bool full_decay)
 	reclaim_list_global(&decay_list);
 }
 
+#define KASAN_RELEASE_BATCH_SIZE 32
+
 static void
 kasan_release_vmalloc_node(struct vmap_node *vn)
 {
 	struct vmap_area *va;
 	unsigned long start, end;
+	unsigned int batch_count = 0;
 
 	start = list_first_entry(&vn->purge_list, struct vmap_area, list)->va_start;
 	end = list_last_entry(&vn->purge_list, struct vmap_area, list)->va_end;
@@ -2287,6 +2290,11 @@ kasan_release_vmalloc_node(struct vmap_node *vn)
 			kasan_release_vmalloc(va->va_start, va->va_end,
 				va->va_start, va->va_end,
 				KASAN_VMALLOC_PAGE_RANGE);
+
+		if (need_resched() || (++batch_count >= KASAN_RELEASE_BATCH_SIZE)) {
+			cond_resched();
+			batch_count = 0;
+		}
 	}
 
 	kasan_release_vmalloc(start, end, start, end, KASAN_VMALLOC_TLB_FLUSH);
-- 
2.51.0





