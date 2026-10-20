Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6DE606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 21:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=evLX7g7p
Received: by kanga.kvack.org (Postfix)
	id 7A0BD6B0561; Tue, 20 Oct 2026 17:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 778506B0562; Tue, 20 Oct 2026 17:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4DD6B0563; Tue, 20 Oct 2026 17:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 466EE6B0561
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:21:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D80A1403A3
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 21:21:27 +0000 (UTC)
X-FDA: 85344275814.22.9278D4D
Received: from mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8505040003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 21:21:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=evLX7g7p;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.32 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792531286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kfPFN6p3dzzyhZDI8mEIySVXtBWL1/DWlxavyXB3fN4=;
	b=8ny9aUc+y0jcVhE5MZlYrjqg+Ttxn/2XMU3G5uWS40qYXnPijyvdT6JfMmmBWuos72kqgC
	LfXBQsD27MyMsb25M/6aW36Q1gXaOjPclxlYouV4eO/xvXSYCv6k/cZWYXAongjzMJdq4c
	yS18OiCXda/xwWYTpFIoznApL0l/uEQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=evLX7g7p;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.32 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792531286;
	b=fQm01bXUvrOXYTB4sSJbQ3IeD5Qufi/daUyJGgxd3iV3UMjOEkuKRcraTiWQqm3IIwt9PQ
	sAfU+12U7Yd3+/hhCJxikYt/4BaId/OZwImU8dXo9vMyVR+SUuzMIyIicDaj7eDOKLyIy1
	hbTW/g9nL3LkPkuFTytLZuCN1CdxQ0U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XQAWskVKn7U7xT+2zsWfc+G6Pi9IJ2IbzAXQD5zOloc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792531283; v=1; x=1793136083;
 b=evLX7g7pVPpCVP6R/sCEfJSjsP25ftzprt/nwJJYw5GG+vYMZ9ce6hIm6VDHJ5yaGkh2iuyZ
 68JdfilehvAXJsdFoMf3PKq9ip5bW7+Cqdx4AukYcpWz13NTekhMxEC06CNpCXiAB3zkXBMF7AZ
 Sbu3kX0k+JVYsupwIzvUqJ7Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bdf38585b1173da1;
	Tue, 20 Oct 2026 21:21:23 +0000
X-Mizu-Trace-ID: bdf38585b1173da1
X-Migadu-Flow: FLOW_OUT
Date: Tue, 20 Oct 2026 14:21:22 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/memcontrol: publish null pointer before dropping css
 reference
Message-ID: <atfMngq7nyZpt4u-@linux.dev>
References: <20261020190336.3754557-1-joshua.hahnjy@gmail.com>
 <20261020193531.181318-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261020193531.181318-1-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8505040003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: o646wodwqgesfp3isrohe7ueny9g39yx
X-HE-Tag: 1792531285-268965
X-HE-Meta: U2FsdGVkX1/D4VHQETAHjFssm0ytb6KyyeDKdVvQHZVyOR8RjkqS17lzMPCp+XMX8DUj3UQOgn7H8BqCWyLg5Fzu5KKv+63KOqlWBhjX2KcRETwCBdaMOfJrvvpJeDJH03xvJrCfPufBycxv6J2qIA9P5KkxDqBF9lW2P1+XbLzQjkNLZulUEGV/IUf3efzgGTBw1Fn797TzNnx0nPvuXhuQisdMq3D84HVBt5YcGr6A3Y0sAeaule+mgkqjOZR2619uXWUzXdSwywJLJ7TIcT2lg4AZReF9VejHNQ1k6uE/aCqHqTtGEJs9EYXtjDna4Q1dcyTqPjZ58F1qDpejYTYtU9N2B8IgH6dVMEkwoUmGn4KTsSqRu7V4xUM56ZetkIK1q71EHewd+Za50iBaku8LcunTb8WU1tgQUGpZQQ+r2cL1cEo35PdcMdnzQ71M99VBLE4bQR+ria9DLpwVQ1Qy7glLZsec6OBa+RQPMa6WjOkXXa5C3MjgnRchV7qHdTfDnsC0TrSkLT5xm8g1ub+M/VdO6iRREnTgkoT5ekiPaj6F5npRImHtedUpioRrEwZ7m6TR1HgYCwBG0uU3v/BU9HYCT2nWhSKEKg31AlxCwISXUr9OSJ3PflOcHMmcahpsrQic2DN1OHXrZYuRCNu4jtKTw5NHmmuETkObE8Jtvi5y7iDF3t182lTwA0leKZG50oOjE5YnHHZV5IYWLt3Rt8FEn7euRihjn8swEU1YPfY9mNp7efHTsKx99r2QgrDeyCr9M7ij8pjzUuhOTJWe/C8fQy4dBTKy73vHb4h2/n+sO3lqShVdx8GREIdS2+S2OlDR+F9RWG5ws2PL7OtkjHdvmOi9ICKiuQqAU69IZw3ohMSdKf9yw9UUpCVCjA7bXqwboakDT1ZxWCtMYr4yP5Dmp2hBP0AfpnBq8zvkkx+IZ1P08dLWlXbRLtT8wcL7axsS/o5xs1zz4KP
 av/7gJDo
 DVjlDfI299mCe9PlpLAKRA9wcx9i4zxTdHzW3YDvaf491mnoVMNVY06Z0VmidynRk2SkYKu/8HZBoZ7JPJ2HGHhUUm9uTJRH22x6reH/uWQJ2/RzqgoP2WZhgDXNHs8nRd2UMKeutHZ1fSEiBm9xSZVkCmIwEguLuw0YJqGhXp8VUefWE5MMzesT/jW2n5yMeqDXRcVDFNE82KUTw41qXLIScls6Rv2Cne3AHDtTMVSy2uVHD4QmoxVBzeP/fonkYrXiFAMjOCzw0lKS7G10uEjiXzO+gD7TUc7W+mzLhxl2m+DPUz+r2W+00y5vvB7F1iXkVKedwnlVvcp2zsNqLeY1Ez5yViggcB3euVACshZFK4j93nNAoTSzi+QNf/2emxbXDB54fli9etqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 12:35:31PM -0700, Joshua Hahn wrote:
> On Tue, 20 Oct 2026 12:03:38 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 

[...]

> > 
> > So for drain_local_memcg_stock I agree, since FLUSHING_CACHED_CHARGE
> > is set, so you can't have it concurrent with drain_all_stock since it
> > will skip that stock. But refill_stock also calls drain_stock when
> > it evicts the slot but the flag isn't set, so is_memcg_drain_needed
> > can read it at the same time.
> > 
> > What do you think I should do? I think reordering makes the intent more
> > obvious and maybe it's just me but I did find it a bit misleading at
> > first that we were dropping the reference and then publishing. 
> 
> Oh and just for clarification, my page_counter_stock series actually
> gets rid of this codepath and switches the order when moving it anyways.

Yes but this patch has fixes and might get backported, so we need to be use it
is fixing an issue which is real.

Let's try to reason how the race can happen between is_memcg_drain_needed and
drain_stock:

CPU 1						CPU 2

drain_stock
  WRITE_ONCE(stock->nr_pages[i], 0);		is_memcg_drain_needed
  css_put(&old->css);
  /* assume full grace period */
  						  rcu_read_lock()
  						  memcg = READ_ONCE(stock->cached[i]);
  						  if(READ_ONCE(stock->nr_pages[i])
  							mem_cgroup_is_descendant(memcg);

  WRITE_ONCE(stock->cached[i], NULL);


Do you think there is possible race condition in above? I couldn't see.

However I ran this through AI and it has convinced me that on PREEMPT_RT, this
is indeed racy access.

AI reasoning:
-------------

How it breaks on PREEMPT_RT

On RT, local_trylock() takes a per-CPU spinlock_t (an rtmutex). That is
rcu_read_lock() plus migrate_disable(), but the task can still be preempted
inside it.

1. CPU A, refill_stock(X): there is no free slot, so it calls drain_stock(i) on
   old. It sets nr_pages[i] = 0, then css_put(old) drops the last reference and
   queues the release work on CPU A.
2. The refill task is preempted (by a tick or a threaded IRQ) before it clears
   cached[i]. CPU A's kworker runs css_release_work_fn(), which calls call_rcu(),
   and grace period G starts. G will wait for the refill task, because that task is
   inside an RCU reader.
3. CPU B, drain_all_stock() → is_memcg_drain_needed(): B has already passed a
   quiescent state for G. It enters rcu_read_lock() and loads cached[i] == old. G
   does not wait for this reader, because it started after G did.
4. B is preempted right after that load (RT readers can be preempted).
5. A resumes. It clears cached[i], puts X in slot i with a non-zero nr_pages[i],
   and unlocks. G ends, and old is freed.
6. B resumes. It reads X's non-zero count and calls
   mem_cgroup_is_descendant(old, root). That reads old->css.cgroup from freed
   memory.


