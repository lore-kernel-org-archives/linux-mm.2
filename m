Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54BB6C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 18:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 335CC6B007B; Thu,  6 Aug 2026 14:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D0B6B0088; Thu,  6 Aug 2026 14:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225A06B008A; Thu,  6 Aug 2026 14:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDB206B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:24:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72BAF120187
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:24:44 +0000 (UTC)
X-FDA: 85071670488.27.B914136
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 94A5440009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:24:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aiCyMRbl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of audra@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=audra@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786040682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eDz9E568MotxR3+S9hrXjCNiUKmMbJuSpoRSuTy9vwI=;
	b=MfLgdOihKBuf7iWhXsYPc82FumAdXJyrAonnYEdZCThUQ2BE/iTWLTY5zTqXSnrNVQAMpf
	21i8TEPVsYDbwPnXQym+hTFOiC3x1jGf7NMrlOQJGMzRx8GfoIqw6J0VNSMUWmQCZxjEK8
	uwf/tPXc9RbLrW9yABjK/3tSMNfSfSE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aiCyMRbl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of audra@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=audra@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786040682;
	b=7R3jZBgOhp9mWGdgZh1aycU1Om/tUyLkAvJro2JgK5/W/YV8RUFC+m1OZNhJul+/40catS
	5D/JMczado7tiCAAVA4is/++tXjrtTXOno3ozbil3hyAi9UsQOaG0yPk9GzbKUZ79/NuZY
	8q6EGNe+T6RuZeSwUYveZSqs5C/QkZE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786040682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eDz9E568MotxR3+S9hrXjCNiUKmMbJuSpoRSuTy9vwI=;
	b=aiCyMRbl5BcPelfpaETssetLufFmI6zqn73/rw/CYyaF5rhyfIZMnNK5RfbGR07YRL9etA
	vUSfToyNsVbkxeyIYQdHbUSBboaqT2po0mndYLuHoTT644/4tgR5Yj5C2v9iiF9xrpm0HR
	HWTRWcjM/zPnPL3FtTHreSKXMyg1BWU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-cRadgUPLNM-vesmcECZ9Lg-1; Thu,
 06 Aug 2026 14:24:36 -0400
X-MC-Unique: cRadgUPLNM-vesmcECZ9Lg-1
X-Mimecast-MFC-AGG-ID: cRadgUPLNM-vesmcECZ9Lg_1786040675
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 449A71800650;
	Thu,  6 Aug 2026 18:24:34 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.255])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D1104180034C;
	Thu,  6 Aug 2026 18:24:31 +0000 (UTC)
From: Audra Mitchell <audra@redhat.com>
To: david@kernel.org
Cc: jocolema@redhat.com,
	raquini@redhat.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Fix unbounded loop within try_charge_memcg
Date: Thu,  6 Aug 2026 14:24:28 -0400
Message-ID: <20260806182429.1841095-1-audra@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 7FwTmgHiu11eHQ0Rq88q1D4gVhLHCAY9PSwLj_GkxO4_1786040675
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 94A5440009
X-Stat-Signature: usrp1bcekkfxzggwrutbdz4doe7k7xoe
X-Rspam-User: 
X-HE-Tag: 1786040682-878054
X-HE-Meta: U2FsdGVkX18PivdOKFkrJoyO6I1OJQd1xLGWGqfK8f4O8CMKYS/OmKmdf5kgxoQw031lLtLbOGUmbg7fVO4FFysLoRoEstsEhdvj9zRSwA47tHRGb5rMdArvE8PoahvRl7g32a6E2nycS///OvVd5TowyN+fTUWgq8+aNOB3g6c1QnGfqGfHVNlEwfy0d3EGwWs7xiImPT0GU0eRBa0c5srHZElPnhQns9IIHe4TSKyCX7x5VrJEvr6c2dP53gx4syR9o7fgWYpJdXR0LqDy3gnqR/izZGHWAAGt3Vm1UORBoDZTMA+HUO+M6YISvVhmWyYZrAEvwKxhucpOUWvaTzWiHiPDxoVIvQXjgRz5K0CPj0rmNdJYjKoAWD+1w+QD3J1ZlxAUlzGarr1y79c6hHVqIKhVAhVwUj7Vu0y5JANvPc6boujJUXE6jUROjFaYUl+bmms/6u7/bLSMDrNNn8sqw7Ur4iEtLoQ3n7/2gaRmALY4GohzDNXLEK3d00LPqm3wxNVHJN4ww5bZgPl2KnSU1H7yGiWQNG+nQFGqZ/BIhj8hVPJS70SM5UdguUOB1YMpNjwiMTtbGeB+xIiDQDT1bBuCcg68GFWsKObfA3+2DhsZkbXKfkoRwgFMAWv1NbRYMbJ9SpkHUV4cYcr953Kf498TaulbVmD57w2AUHCFQ34+SD8dl/0rNZcix/uFFR/+JDFnxDUbO2W93LFiBBa8zwPNiRB5M4vLO/dKHpPfoVNmZQlQvWEvHYPd0i/EJ2ZXQhnCrsVrfI9g7/WZoOUbLgsLV0bVXdIDfRGJcdSaj980D7w2x7IxsMukYYW4Da7+fHp6stkOqt730uMVl8m6z1nTYG6s7dm40seF8Lg2fh/zXbRuZInpZwJF0T4eRNime3c155fhU+kf6zXRJ7YA4Mc02vuctv1o+2R2/TRgxlGQh6SIMvD9Pv2xoHgNvV/8rsBYg8ZwXHLDTMG
 vEMX+Bby
 ZabGZkQFuCD5j9wt+oD0i0Rod+LNxSZVxnHXncz0T664wQxbXKr+MVIfgpdhVn+mg3E5U0R/o0jVhwh77nHbOa3UQvKXkUJePVFXs6tVdcAQ5/PZj1Dn8+KTxV390WqFouNurGe1DXoOoif63j9dy3zFEwpNut3jRzWUOnPVy+dSf9hbs7mcLvygJ7L6nJde0LK1b77LCNFOhuyqqt1xYNzt7e51/GoBAX2+9GsvL2ZVFx0AhIFVq7HhR7HnQFiCjahKHUQHyY7SgLVpM3LurGScvw4Q8pKejfOgeCV8+MChXhDNW+YrDcgtPFpawWyJnI22mOWcw7ZlxIMPRFOHaVFqnM17Vi+75PAhHLnIImCHM3QPO58caUc4OhNu/BCymmNCzsRnROHKnX58=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Originally nr_retries was actually nr_oom_retries and we used it to track (and
limit) the number of times we entered the mem_cgroup_oom path and then attempted
a retry. The purpose of nr_retries counter changed with the introduction of
9b1306192d33 ("mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL
charges") so that the oom-disabled and __GFP_NOFAIL charges would also continue
to retry within the desired nr_retries threshold. Later d977aa939fca
("mm, memcg: unify reclaim retry limits with page allocator") changed the
nr_retries counter from 5 to 16.

As the function has evolved we now have multiple paths that have a goto retry
path and we have lost the original purpose of the nr_retries counter, allowing
us to take a goto retry path an unbounded number of times.

Fix the unbounded retries by nesting the code in a loop and decrementing the
nr_retries counter correctly.

Signed-off-by: Audra Mitchell <audra@redhat.com>
---
 mm/memcontrol.c | 153 ++++++++++++++++++++++++------------------------
 1 file changed, 76 insertions(+), 77 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..781bcced5848 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2607,98 +2607,97 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
 
-retry:
-	if (consume_stock(memcg, nr_pages))
-		return 0;
+	for (; nr_retries >= 0; nr_retries--) {
 
-	if (!allow_spinning)
-		/* Avoid the refill and flush of the older stock */
-		batch = nr_pages;
+		if (consume_stock(memcg, nr_pages))
+			return 0;
 
-	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
-	if (!do_memsw_account() ||
-	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
-		if (page_counter_try_charge(&memcg->memory, batch, &counter))
-			goto done_restock;
-		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, batch);
-		mem_over_limit = mem_cgroup_from_counter(counter, memory);
-	} else {
-		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
-		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
-	}
+		if (!allow_spinning)
+			/* Avoid the refill and flush of the older stock */
+			batch = nr_pages;
 
-	if (batch > nr_pages) {
-		batch = nr_pages;
-		goto retry;
-	}
+		reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
+		if (!do_memsw_account() ||
+		    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
+			if (page_counter_try_charge(&memcg->memory, batch, &counter))
+				goto done_restock;
+			if (do_memsw_account())
+				page_counter_uncharge(&memcg->memsw, batch);
+			mem_over_limit = mem_cgroup_from_counter(counter, memory);
+		} else {
+			mem_over_limit = mem_cgroup_from_counter(counter, memsw);
+			reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
+		}
 
-	/*
-	 * Prevent unbounded recursion when reclaim operations need to
-	 * allocate memory. This might exceed the limits temporarily,
-	 * but we prefer facilitating memory reclaim and getting back
-	 * under the limit over triggering OOM kills in these cases.
-	 */
-	if (unlikely(current->flags & PF_MEMALLOC))
-		goto force;
+		if (batch > nr_pages) {
+			batch = nr_pages;
+			continue;
+		}
 
-	if (unlikely(task_in_memcg_oom(current)))
-		goto nomem;
+		/*
+		 * Prevent unbounded recursion when reclaim operations need to
+		 * allocate memory. This might exceed the limits temporarily,
+		 * but we prefer facilitating memory reclaim and getting back
+		 * under the limit over triggering OOM kills in these cases.
+		 */
+		if (unlikely(current->flags & PF_MEMALLOC))
+			goto force;
 
-	if (!gfpflags_allow_blocking(gfp_mask))
-		goto nomem;
+		if (unlikely(task_in_memcg_oom(current)))
+			goto nomem;
 
-	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
-	raised_max_event = true;
+		if (!gfpflags_allow_blocking(gfp_mask))
+			goto nomem;
 
-	psi_memstall_enter(&pflags);
-	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, reclaim_options, NULL);
-	psi_memstall_leave(&pflags);
+		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
+		raised_max_event = true;
 
-	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
-		goto retry;
+		psi_memstall_enter(&pflags);
+		nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
+						    gfp_mask, reclaim_options, NULL);
+		psi_memstall_leave(&pflags);
 
-	if (!drained) {
-		drain_all_stock(mem_over_limit);
-		drained = true;
-		goto retry;
-	}
+		if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
+			continue;
 
-	if (gfp_mask & __GFP_NORETRY)
-		goto nomem;
-	/*
-	 * Even though the limit is exceeded at this point, reclaim
-	 * may have been able to free some pages.  Retry the charge
-	 * before killing the task.
-	 *
-	 * Only for regular pages, though: huge pages are rather
-	 * unlikely to succeed so close to the limit, and we fall back
-	 * to regular pages anyway in case of failure.
-	 */
-	if (nr_reclaimed && nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER))
-		goto retry;
+		if (!drained) {
+			drain_all_stock(mem_over_limit);
+			drained = true;
+			continue;
+		}
 
-	if (nr_retries--)
-		goto retry;
+		if (gfp_mask & __GFP_NORETRY)
+			goto nomem;
+		/*
+		 * Even though the limit is exceeded at this point, reclaim
+		 * may have been able to free some pages.  Retry the charge
+		 * before killing the task.
+		 *
+		 * Only for regular pages, though: huge pages are rather
+		 * unlikely to succeed so close to the limit, and we fall back
+		 * to regular pages anyway in case of failure.
+		 */
+		if (nr_reclaimed && nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER))
+			continue;
 
-	if (gfp_mask & __GFP_RETRY_MAYFAIL)
-		goto nomem;
+		if (gfp_mask & __GFP_RETRY_MAYFAIL)
+			goto nomem;
 
-	/* Avoid endless loop for tasks bypassed by the oom killer */
-	if (passed_oom && task_is_dying())
-		goto nomem;
+		/* Avoid endless loop for tasks bypassed by the oom killer */
+		if (passed_oom && task_is_dying())
+			goto nomem;
 
-	/*
-	 * keep retrying as long as the memcg oom killer is able to make
-	 * a forward progress or bypass the charge if the oom killer
-	 * couldn't make any progress.
-	 */
-	if (mem_cgroup_oom(mem_over_limit, gfp_mask,
-			   get_order(nr_pages * PAGE_SIZE))) {
-		passed_oom = true;
-		nr_retries = MAX_RECLAIM_RETRIES;
-		goto retry;
+		/*
+		 * keep retrying as long as the memcg oom killer is able to make
+		 * a forward progress or bypass the charge if the oom killer
+		 * couldn't make any progress.
+		 */
+		if (mem_cgroup_oom(mem_over_limit, gfp_mask,
+				   get_order(nr_pages * PAGE_SIZE))) {
+			passed_oom = true;
+			nr_retries = MAX_RECLAIM_RETRIES;
+			continue;
+		}
 	}
 nomem:
 	/*
-- 
2.52.0


