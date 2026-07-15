Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02280C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38266B00B3; Wed, 15 Jul 2026 09:29:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8EE6B00B4; Wed, 15 Jul 2026 09:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7DD6B00B9; Wed, 15 Jul 2026 09:29:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC3D36B00B3
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:29:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07AA6C011E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:03:43 +0000 (UTC)
X-FDA: 84990725526.28.B111278
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3FF304000D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:03:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Lzuv0dXb;
	spf=pass (imf12.hostedemail.com: domain of 3C2lXaggKCJQ7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3C2lXaggKCJQ7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784113421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29O54/g86I/UhsnFuKm5xVq389jfQYeh9pI8FKcXiJI=;
	b=DgYj17w+nxj0d36vxaq9cxHC4+czQ2ePjGqOJxsyfkMkB6FdWp3k0jNpOqR5+w0+7L/NB+
	kzeqiTp1A6ITOXEafQkjaIz4dccbWEi8SVemN1Zfa5Qw1Zh1zJw82KjLO9D4b50VV2JJFM
	6QeCyRibbsx9uqXkaprPZS8Ml/vQI5E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Lzuv0dXb;
	spf=pass (imf12.hostedemail.com: domain of 3C2lXaggKCJQ7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3C2lXaggKCJQ7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784113421;
	b=E0Q+/5aNqlEWSIX/WaR7IhIv7yf0psVfSHPdQHN8/TQPs1r8XIAxWPoOvr5lx1+LHyyhsm
	Og7nWFQYTJ8bQxEBQsTY24b8yPb3J42NxQt0DWZTyha0UTzS2HMTG4uE2gqbTMm0ubqgom
	aPHYoHPXZuORnDOJ7mKkW2rUj+sCpzQ=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-493ce4b7777so39117375e9.3
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784113420; x=1784718220; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=29O54/g86I/UhsnFuKm5xVq389jfQYeh9pI8FKcXiJI=;
        b=Lzuv0dXbdqaZ5zPqrS9zUlLpIROyMbP2qERFoGpB2oQxWyZKpvn7CQZ4sx5eVLvKSr
         rdvLS5eU6hBg3OX65e9kLWPXRCW9nJd2ig8n7d6SkBLqdelTThfEw4moJBEszAA5NRJj
         aCm+0XLKmfui9we6i6AKt9TCzOBTBiO0EDRLipsAsmrQPzbu7X7JhNVFKen7sVGZec7p
         ERJ/gniwFWEC5SZPMj9GnX6WaQdxC4SMAk5PKsC3QPfv3Qu8KGgdCV3xNWoGdWtHhnaW
         jcMUFkDC8lq7ug//h4dRg+0AZcV6rCX0PjoWCQMlx+G3jgYZEzu7z0MVuLA9XWLyEA0m
         cR7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784113420; x=1784718220;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=29O54/g86I/UhsnFuKm5xVq389jfQYeh9pI8FKcXiJI=;
        b=QJbJgETcWNV3vl24UflkX9k+4hzGh51WL0FLMDMwXLbTmmd6G3d1eermnWvn9fs7o4
         bV3XKzzQI7a40Z/U2M0bzJBhRbfanGkolzUMZ/7lHNhuaBi2U5U7xx9Xq0XnxFMnnZ3x
         Muj6jnC/hbY50iXZWdcZAOzhqWNS0fIpKncjw+zOqRCYQ74PzZy+M78LMSmLYp2JTdlZ
         NRTOWm5ruiVGHWuEIJgqs+dQzlEfLXQXpwdahkYDJ/O1bNJ35n/Kazy/efLyXwUzqgaS
         TWQNQ6sGr9+GukZHwPPI+PfxqQwvRg3cX1RQRa+mgGfHvOgJyc/KrFz9oLGeuqfe0xQX
         mijg==
X-Gm-Message-State: AOJu0Yw8E6x54fMCSBKZ5jkT/yUIX9PzM+bw1kdpTpuPgGjXDSrSztSS
	Z8jQGSp1wpGSRvCzMR6i0WOuxd9xvHFPYbeDMR/QVRAAsWQ3DNJJFZ7e3EddNS2Z3oWEVQCV3SK
	5miXDc7eGN5rzjA==
X-Received: from wmqa14.prod.google.com ([2002:a05:600c:348e:b0:48a:79a9:335c])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1393:b0:493:fa66:4861 with SMTP id 5b1f17b1804b1-4953c273bb2mr27821985e9.25.1784113419548;
 Wed, 15 Jul 2026 04:03:39 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:03:19 +0000
In-Reply-To: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
Mime-Version: 1.0
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com>
Subject: [PATCH v3 2/4] cgroup/cpuset: update some comments about the page allocator
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Waiman Long <longman@redhat.com>, 
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?utf-8?q?Michal_Koutn=C3=BD?=" <mkoutny@suse.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3FF304000D
X-Stat-Signature: 1ccwwje77obcnaehfu7dnoe46suyi3os
X-HE-Tag: 1784113421-323230
X-HE-Meta: U2FsdGVkX1+QnkzZchqSNB5HOwzMwA3+A8BclgdAgX1dVqeoCoo+eOFqGOVtWuqvGBo0V5WJ++68fYNcg7+OzghuECe9NSENowffrN1pnjoqQSz803HYIgJi32ghpiT9vYnRSNfe/+S00A58w3tj6QlICJshGnfKUSK397ada1s86jxATkhRCZ/jJQQaO3NJkAkY5tw0aW8Mzj/SNyW1oEB6JLUZPQzwTAB3qGvaj7JhDp8N/CssWE90tZpvKjwB/AtZRk4rpSO96CdML40FtoKmVszIl+pKay8GMwjFngQnU1f+siew+flKCfrr/FJUzVfAZcR2aAFp8kSFOH6pbcQr2c5Z6rc9Knwp/dhLavSc8P/cdBuqVupTMLnnRT7RF7mlFMVULT9MowMpbWUCcNSTTZJAvtEdE3+ALIJKo316BIVrr04e1pjhZFDP7rJRv6BqGfnL9VW9TXnG/BvCetqHT1lscIcP77M9xKjl9DTHG3w8f2BeqVi79PbGjHpCxlkqB8GNR8TNG7z93XoGO5AMqEltVQfSwnAmMU4niJpd96A+zcEGXkTiWN5XsRtgtEoE3ek+RzXWcvBjZHu93GTcqgpooF9rQ8SJfIt46h1Xd39qelatnhctBKral1GMbshGR1JQpqcfJ3Ugo4Yfyz0yRHYgz51AKJdbHsu9Zqj1jYLQKinOq/ZL/q1AAv2BDuTV+S2gPsPErXwu6OFy1CyvAUabYwenPXpc8Syej0SGOiPW+rxgNPEE9d7DqmnBf12MRd9zvGeD+3a6iZCsbA4ZOHivSwMf2TS3nPi2ROgBdbvAml9jYZVZK6Q9sAvnZKT3xRwwc0bkzZIDzo5Hshws7bhU5h13TkN3pLXqKyIyxIMwyUMeIH4mxxXoveHVx6jCYrTHtiMCdR63mHrHUuxHwUKnjFJXX+nIAMYe8OfadbBgp5HnYwOdwQu5fORz35ZE5sZq8y2KyJmKOPH
 bovyYlPQ
 E88ETrfWixE3NC1RL0pKictqyVjIv1+gMhXC03g/PH1RI3xIfN0sak52BCG5DK8n3vaySRQWV8BUr0Y/8hoR592mhndDMPkFAusxCS4xpaN3YivmuXW7d1RjrHl4RdKaCMpb7WFj5NJD+blI+eSHQ7uKtnoP38g4cYCWxoNj9CR2WtGhQ6gHTZGdrhmnBbHUGCCvRf/Y3FvKjhjkIO4Tn0WOsf59FwEYNSb5igmsx3x3MpWm6THCfIXZ4CIQmDjTT3cwHd9cPx5r9gOk1le3lNMdSDryEukmOl8Coh55zhm4cVP9NnmJYKxJvA5mOdYFno6M8oIQjRfwnyGefee4+IGPB9e2dL/ak8BgM7LUnWMAz/z9k/TD+2CODFaVhI84bmY/Efmew1YGsAyobbuivwaAy7GAzHb8BvwEkY04RFDXU9MYRbXHdJ8CfdL5zl4Vc73L/VQk1bFYGz2k2ad+f2Zwov+ICdCTVpvumx4H5ig9TkOPq/6+p83lsxjZYwmS2Ylka+U+4wCUrnD1Jy1YGJ+3m9n23nZIjKx4vpi+W9ncLJJKsamprjxqjXx1fIrEe1VFvaUnANNCPRM2+07h7CUx+FoB7K/aNYBxiKwJ3wPACUy/NJN7xOCiJXg169yGHVCx5DYuu0yCMCeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These comments describing the page allocator are out of date:

- __alloc_pages() is no longer a public API and has no business being
  described outside of mm/.

- The `wait` variable is gone.

It may be out of date for other reasons too but this patch is just
fixing the issues that stood out.

To fix it:

- Instead of referring to a specific function, instead to "the page
  allocator"

- Completely drop out-of-date details of that function's internal
  behaviour, since they were irrelevant anyway.

Suggested-by: Zi Yan <ziy@nvidia.com>
Link: https://lore.kernel.org/all/DJP11T5V7BDW.2FZZZ8R6LOY4I@nvidia.com/
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 kernel/cgroup/cpuset.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 24ea2d09cdbdb..dfd0f827e3b92 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4193,7 +4193,7 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
  * nearest enclosing hardwalled ancestor cpuset.
  *
  * Scanning up parent cpusets requires callback_lock.  The
- * __alloc_pages() routine only calls here with __GFP_HARDWALL bit
+ * page allocator only calls here with __GFP_HARDWALL bit
  * _not_ set if it's a GFP_KERNEL allocation, and all nodes in the
  * current tasks mems_allowed came up empty on the first pass over
  * the zonelist.  So only GFP_KERNEL allocations, if all nodes in the
@@ -4206,11 +4206,8 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
  * come before the __GFP_HARDWALL check, otherwise a dying task
  * would be blocked on the fast path.
  *
- * The second pass through get_page_from_freelist() doesn't even call
- * here for GFP_ATOMIC calls.  For those calls, the __alloc_pages()
- * variable 'wait' is not set, and the bit ALLOC_CPUSET is not set
- * in alloc_flags.  That logic and the checks below have the combined
- * affect that:
+ * The second pass through get_page_from_freelist() doesn't even call here for
+ * GFP_ATOMIC calls.  That, and the checks below have the combined affect that:
  *	in_interrupt - any node ok (current task context irrelevant)
  *	GFP_ATOMIC   - any node ok
  *	tsk_is_oom_victim   - any node ok
@@ -4327,8 +4324,8 @@ void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
  * should not be possible for the following code to return an
  * offline node.  But if it did, that would be ok, as this routine
  * is not returning the node where the allocation must be, only
- * the node where the search should start.  The zonelist passed to
- * __alloc_pages() will include all nodes.  If the slab allocator
+ * the node where the search should start.  The zonelist used by
+ * the allocator will include all nodes.  If the slab allocator
  * is passed an offline node, it will fall back to the local node.
  * See kmem_cache_alloc_node().
  */

-- 
2.54.0


