Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62BF6606D80D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ikn1y6ry
Received: by kanga.kvack.org (Postfix)
	id 863E06B05B3; Mon,  2 Nov 2026 09:35:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A346B05B8; Mon,  2 Nov 2026 09:35:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72B456B05B9; Mon,  2 Nov 2026 09:35:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52CDA6B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:35:45 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA15014014A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:35:44 +0000 (UTC)
X-FDA: 85390427808.21.A5365E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 380A040004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:35:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ikn1y6ry;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793630143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+KH9DKnobF6DQUWg/9OINh8veQE+eSIIBbaMlh5YSf0=;
	b=B74eA2wAwWjjzNW+MSCIUJMsZeGKJmFpOP3ZcHgxIqvyecXUMgBcTDnzc6NOcUmJ2AppMa
	GXzYrqstpun8jkma/pO52kCCVBXuxOWdNttA22IgGyDbCq02+DXzaDzOXpNz1MfE+NjNbx
	ETOSGlLMa5o9Q1Lsj288AeDwMaCNoPI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793630143;
	b=4PFDbi9ZUNLLsNCKFPTZl0JTEksW20jBQ+3KGGRUVKkWjY10Q5ZS9ERnBL0bnupvGS88fb
	nwCQ7/cXHZhOyCQ+yZ5GRS9UKiWvcnr4OPZZxLPeI1bCDmXOljmqaaRBexLryU6845xjLk
	kZUonnpONsYGDe3bJBWobuUlh/+5GUU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ikn1y6ry;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 68B3A43771;
	Mon,  2 Nov 2026 14:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E1F1F00A16;
	Mon,  2 Nov 2026 14:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630142;
	bh=+KH9DKnobF6DQUWg/9OINh8veQE+eSIIBbaMlh5YSf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ikn1y6ryTPUoeZWCunevYgyGsdCva6xgumlNAVWW5Xw1G1m7YhcfouBu0crpxQ01H
	 zw3kj4Fzllj0s/gES72EKL7lmVdFd9+upRks3Az6+sycu4SgIBaieLz37micyH6qij
	 Fbh5Nfzn1pkfP/SOUBdlk37bPE6Cr5NBRJyZMWYAN1tMglddycvGqd8lPQnuPdk7e1
	 kOp7TbA7D/Kb7ezIlJeqediV5rZqmM2dmksRAUWt08p2yvZDvF5QG8qUu1X/+sJU25
	 JXZuu/14JcWcosmYHhryfwLwD4qeqnRlYhrcQV7EYkDsnnDawHHR8t49JUxdMMjT2v
	 3JIO0LBpLHX2A==
Date: Mon, 2 Nov 2026 14:35:40 +0000
From: Harry Yoo <harry@kernel.org>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: vbabka@kernel.org, urezki@gmail.com, paulmck@kernel.org, 
	qiang.zhang@linux.dev, akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	rcu@vger.kernel.org, linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com
Subject: Re: [PATCH 2/2] mm/slab: don't queue the page cache work under
 krcp->lock
Message-ID: <auifTNDwbBTJeu81@thinkstation>
References: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
 <20261028134647.3176080-2-zhanxusheng1024@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028134647.3176080-2-zhanxusheng1024@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 380A040004
X-Stat-Signature: yozrhakq5a6kanyn8amontr4ihb44dmb
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793630143-498267
X-HE-Meta: U2FsdGVkX1+ZSpsUVQMcfppJfmggoTsElu/ZmIhBD3CIOZbiEc/4LI/xDod3Qwu07dfC0to3IIRMlrc24qM56PTV1KV/P4/vXWXwBRFOK7UFiFyTIBhuyZV4VKkVVswha8Ce8Nw8FkLigRNj86TM0ckXuDmlDhpMh3xauvO/eC3Li63thim7InbSVuj+uCwgbkZ8S/DZjpJY53U0IQWdZWcmAZNlXfrJN6tOUbpD/Des13BWmQ8vDn1VEc1GTcdNRFh5a35ZIHo1m06RwIjO1iBd5ZvV4r7OUEqIH8ibdsBEX4tM8dfqKbnxkgKVgHojDKooNLOq101KOUnBR1tdm9CIlLvDZv9nQkMFAkif9qMOgRCKPWk6D0XlC4TjXyxzaacGQI/FvgjgCZmkEbs29GElTAiNsI7pqfnzalafNZjVFDFJfWbqlPL+GqP1Mi46c2IfiAnK0gFKca2UR+XReJUV8w6S2rVS5Az1paNOlVda8W2ZaMwt0yFNIsbwASkR1IlF9O0tEhgW08Egai2VHkNV7oENEUdQLFMUYf8gC/B6XsTDWNRckHu5g7zj/oACw/8dxKyarYQ/hfDd9/7ZsQxEohSkq7olg0o98krjGBgWIIzKRFEUSfjsLrYZI1bePpTtaELWB+6b78YDFNEBw50fmsAZ5qb9NlKhmfZaBhecVRfiegJtVo+mzd+nUQa0BztCOa1VLg8GJ5cWVE9s8o0diam/K0MAKdg4QaucS6u/W+mDhvq1QsAaIhV778A0uXrE0U1t/3izh89PJvRqH9pGr9PtHiuzREKHdMwZQVYGgLY226wiZG+N/O9dUBkse0cQFrpaxnKjEmW5qkzHLammn3LgyP2f8c1csxlt5ujVhxmNeoY8ZqjT2bQjGeqcq0dY6K0a1p02I9sxa0EYL9K9+Nll7EUKYKhb90p2OxzeUA63m+Ja+ZYlEi+hsMp7rFOqdmKNtbXvdyl2EvV
 nuC6YZ83
 8F3giYSuIwU2eWB+qp8hjCocmlRf0PmMjINoAwncEGT52ZbPz1SlfQmvEj+Mc7GpLejPCgdZgNUTyNKRje4FEFUylDvHlvBTUgMgmtPhp35N4qAcJniBhgDEl5YKgfB3Nh7dsP+bkUxat0AObYSr/sUannWXUwKbIVRZq5i7tL/aOKlr+6ojI5tiziXp54gQFnzL+5EQoTKMyCNIJ8pcPrkK9bzzceQaPmqNgQRTnd4d9zydggfNEhQvdRowxVpECcl6EIqgGpzRWJXwbLt4J2+A3yJVP0V6ICcm7Y5100buVZMqsuz9grisc1cWmECJybjdicQ4CebyKASmUHb74WyMUoWJzcUmorSH9guWqElGeni5XJdsnuZQzVJRFh1qRw+I5JPshcPVWVW2npow9U9i9JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Here I added bit more context and adjusted comment. End result:

mm/slab: don't queue the page cache work under krcp->lock

Commit 56292e8609e3 ("rcu/tree: Defer kvfree_rcu() allocation to a
clean context") deferred page allocations to a workqueue. To avoid
deadlocks with the scheduler, it used hrtimer to queue the work instead
of queueing it directly.

Commit d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory
pressure") later added a backoff mechanism under memory pressure, but
did not consider that queue_delayed_work() with delay = 0 immediately
queues the work and introduced the deadlock commit 56292e8609e3 tried to
avoid.

run_page_cache_worker() runs under krcp->lock, from kvfree_call_rcu()
callers that may hold more, such as set_cpus_allowed_force() under
pi_lock, so it kicks the refill work from an hrtimer. Under memory
pressure it instead queues the work with a delay of
rcutree.rcu_delay_page_cache_fill_msec, which may be 0, and a zero delay
queues it at once, taking pool->lock under krcp->lock.

With the delay set to 0, calling kvfree_rcu() on vmalloc memory under
pi_lock after a drop_caches makes lockdep report:

  Chain exists of:
    &pool->lock --> &p->pi_lock --> krc.lock

Use the hrtimer when the delay is 0.

Fixes: d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory pressure")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Link: https://patch.msgid.link/20261028134647.3176080-2-zhanxusheng1024@gmail.com
[ harry@kernel.org: add more context to changelog and adjust comment ]
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slab_common.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 41dea01a8c1f..051ca63c0b67 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1987,7 +1987,15 @@ run_page_cache_worker(struct kfree_rcu_cpu *krcp)
 
 	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING &&
 			!atomic_xchg(&krcp->work_in_progress, 1)) {
-		if (atomic_read(&krcp->backoff_page_cache_fill)) {
+		/*
+		 * Use the hrtimer to avoid a deadlock with the scheduler
+		 * by waking up the worker directly. queue_delayed_work()
+		 * uses a timer to queue the work, so it's fine.
+		 * But with delay = 0 it queues the work immediately.
+		 * Fall back to the hrtimer in that case.
+		 */
+		if (atomic_read(&krcp->backoff_page_cache_fill) &&
+		    rcu_delay_page_cache_fill_msec) {
 			queue_delayed_work(rcu_reclaim_wq,
 				&krcp->page_cache_work,
 					msecs_to_jiffies(rcu_delay_page_cache_fill_msec));
-- 
2.54.0

