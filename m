Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CDDDC982E1
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 12:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9618C6B0093; Sun, 20 Sep 2026 08:38:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89FC76B0095; Sun, 20 Sep 2026 08:38:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE146B0096; Sun, 20 Sep 2026 08:38:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58FF66B0093
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:38:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 648D84041F
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:37:59 +0000 (UTC)
X-FDA: 85234092678.08.B17F744
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CDC30100003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:37:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VzRdHciK;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789907877;
	b=Gh8mkmpG6cYN7797b/hw0WR6OTltss74HZD8mu31syUZW/qFdTlycESTdqIHHc1T5+/1XQ
	fzOaPEcru0RgZz2WSuukOsrLZs7lmhoEW0rIoqo2uRlClYdGSf4YK3a24DFbgT9lUFOqy+
	FFDpWp5GrTWUGuFZz8bIETqfcOlfNsY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VzRdHciK;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789907877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=mJsWGBtB6Jmto8DEzZ2y0wDci2YhQdizpVycyPmDhK0=;
	b=V1g2lx/JGWFg9q3c5C4xkriazX/16lNHk9zwfgQShLaj6dQ8sf52fc1NxQBlfjkEuMISBr
	Vc6dCv79llecZQFbhdP8P73qLuwqSzP5lbGXBEsQ4F6VQh3fCuFvE2RftqtOqeltUss+EW
	Dr+hkOgg4D/J2SnXEStYBPEjq/vhw6s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15D8D43DAD;
	Sun, 20 Sep 2026 12:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40FE1F00893;
	Sun, 20 Sep 2026 12:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789907877;
	bh=mJsWGBtB6Jmto8DEzZ2y0wDci2YhQdizpVycyPmDhK0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VzRdHciKS1keY3iQi9SFZNCz1KV7/Ah55tDvKdZXTr5m8bGGeqn/s033sD58PhgIy
	 TfPrqGNOi7LjtXtgCutOGzPRAJZd45t5n4H1V1kR2NE5cgppgASisfIOm18ItWwGqG
	 YKByiV76Sx5uB6EYvm6oCPDQVNUH149ja80rHzVGxq5cSuvq1CWo+PaQJwNeBx4T/U
	 rb8FTL7vE18NDxitJ1BDuusxWO458ObxKwLqApe8wdYKsbM7CR+QvG2s+LzyBaxSvv
	 sMbO1bEWWfhj7wK8bPK9jgyjryTqIilpQREp60zmEBFiaP/SyD5LMSX3wZVFyymDM2
	 p2zEN6UTMbCow==
Date: Sun, 20 Sep 2026 02:37:56 -1000
Message-ID: <73204ebd8b41871c263e99196ee7fbf1@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	axboe@kernel.dk,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	willy@infradead.org,
	jack@suse.cz,
	tj@kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH v6 2/3] memcg,writeback: flush foreign bdev mappings
 separately from owner wbs
In-Reply-To: <20260917070119.2648123-1-sunjunchao@bytedance.com>
References: <20260917065759.2643940-1-sunjunchao@bytedance.com>
	<20260917070119.2648123-1-sunjunchao@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CDC30100003
X-Stat-Signature: 93htt3xrqqaxoe1j9dzqr6jyxr7j7j8t
X-HE-Tag: 1789907877-646151
X-HE-Meta: U2FsdGVkX1/VXk/9ItDfMtbLiqX2s144oV1STi+X7Dl4WWRTLjeA/xq0C216wEE1UmFXLjNj+qLPLOQXZ+4mOpcMXXrHwoUuTQXmoEBCBJ3XjuNFb8xU13rRkL7De0GoR0DfNSMygcgO/9UvauEYz76srQhhiUpwx3Cw66p2/DlhgKNCtisgDYsulSGx09BvNVvf/GKJy04Pmw7+t3gAEm+cBljQ9y1tGbQQCj8r6DNwVd3NpTv1hCI3ogG5HfJYoq+mt0rBf6ovk4DAYb7plWN/bB51SwL6FQzdzN9/dgSvlffnwLRrumFzRFU5/5qHlbaFOcsJRqHICdrd5OfTmrTQjESNJY/XeyGlT3FPyt6aEnubxudNmkCS5bvbkhYEztUG7tTqNVw09bJFXw+wgsK9K0ohN9DYtYC+KeELY1AgTLuHGHdpajg9M9fFXIpACQ8etwqBTzb73DMz1Tqvz2ptC8ts8swN9kveIJd+DEjnv5cS+iLIo+j04p2DtBhHWSejvNl2FArNpdKIhISLTGM5pDA6Zz4I7NEoiKBRbgM7oXM6BbhsZPTmCSFkogFNsMTkN5lzxYjkRk6YGjCg512Xa67se0QWNbrwCOrpsZwrAl4TpKRbMiU9KXg+TzkMauvMCr+1k69U1uqaZOA+ksYbNjGU9D8YtD5GLv9H1l0LGhAQSxGDUy2Vz9HtC9SxB2i4IJqhR6rsnjAbTKicBNfvOXrgOI2hDYXN6GZ0+moj7mHP1fV3wiyKGq59jPKwHwzSofWJYHPt5+f+1g9xZkFZZYoJq8YQ/cazbWvQ0c6RwwHkmVKnLq4n7p6THNu+ZtHxY7dT7s8trkSBkmI3x3yOuJJqWTQziRALoIrDMBe7WnfyY1ZAUQ7j2lR2lMjJYdtbYzX4egTXzp89SAKAxlMYdFq5hCeo0hf5Sfga0JOy7r6B6JGrlPqz3ehbmoon5jLe+9Yup6juRkuVQhk
 /EyWseIl
 bSHk0RMRU7yAeq3KIDq2IjNksfMQB4yBTKeLHYWAr2WDv3TQYMV8hL0/VEhTpZrZpjp/5bIupODYInc+mR7Si2VAto8NNCKQXUWRWpykVO9bswwfbNM4K+K2zZxNX/V+EePKPH4yN27DZkOjDoEDzXgZpFpTz6SYRxv3VpsFrlttVl1h1JsCCw7NMeljntFFWKD8N4yOWyKN1a7VwE28peC6sgn6m+bHynLwZfEhbrb32XvRpbSrOw4krJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Julian.

On Thu, Sep 17, 2026 at 03:01:18PM +0800, Julian Sun wrote:
> Bdev foreign flushes can be triggered frequently. Use a dedicated
> workqueue to avoid interfering with tasks on existing workqueues. If
> allocation fails, retain the existing foreign-wb path.

Work items on an unbound workqueue don't interfere with each other beyond
max_active, so this isn't a reason for a dedicated workqueue. Wanting a
separate max_active pool for up to four long-blocking items per memcg is,
if that's the intent. Can you update the rationale?

> Use fixed per-memcg slots, with a shared lock protecting device records
> and in-flight state. Tracking is best effort: record only dev_t without
> holding device or inode references. Skip closed devices or devices whose
> open_mutex is busy. Device removal and device-number reuse may race with
> lookup.

Andrew asked why dev_t rather than a reference. The reasons you gave in the
thread belong here: the record is written under i_pages with IRQs off,
dropping a bdev reference can sleep, and a memcg that never throttles would
pin the device indefinitely.

It'd also help to say who this affects. Only filesystems that keep metadata
in the bdev page cache, so ext4 and the other buffer_head users but not
xfs, btrfs or f2fs. And that the decision is still blind to how much of the
memcg's dirty memory is actually in the bdev, so one dirty bitmap block
still flushes the whole mapping each time the memcg throttles.

> Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")

This is new development rather than a fix. Maybe drop the tag? Patch 1
doesn't carry one, so a stable pick of this patch alone wouldn't build
anyway.

> +static void mem_cgroup_track_foreign_bdev(struct mem_cgroup *memcg, dev_t dev)

This lands above the "Foreign dirty flushing" overview, which now says
nothing about the bdev path. Can you move it below the overview and add a
sentence there?

> +	/*
> +	 * Tracking is best effort, so losing hints when all slots are occupied
> +	 * is expected.
> +	 */
> +	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> +		ctx = &memcg->bdev_frn[i];
> +		if (ctx->inflight)
> +			continue;
> +		if (slot < 0)
> +			slot = i;
> +		if (!ctx->dev) {
> +			slot = i;
> +			break;
> +		}
> +	}

When all four are occupied this always evicts slot 0, and the comment says
the new hint is dropped, which isn't what happens.

Why not follow the cgwb_frn style? A timestamp per slot gives oldest-first
replacement here, expiry in mem_cgroup_flush_foreign() so a record from
long ago doesn't fire a flush when the memcg finally throttles, and
re-arming when the mapping is dirtied while a flush is in flight, which the
worker currently forgets when it clears the slot. It could also drop
frn_lock. An atomic in-flight flag on the work gives the same guarantee
done.cnt does, and a torn read of dev or the stamp only costs a wrong
best-effort flush, which is already the deal.

> +	if (memcg_bdev_frn_wq && bdev_inode &&
> +	    sb_is_blkdev_sb(bdev_inode->i_sb)) {
> +		mem_cgroup_track_foreign_bdev(memcg, bdev_inode->i_rdev);
> +		return;
> +	}

Patch 3 moves the trace call below this. Might as well put it there here.

> +	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> +		struct bdev_frn_flush_ctx *ctx = &memcg->bdev_frn[i];
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&memcg->frn_lock, flags);
> +		if (!ctx->inflight && ctx->dev) {
> +			ctx->inflight = true;
> +			queue_work(memcg_bdev_frn_wq, &ctx->work);
> +		}
> +		spin_unlock_irqrestore(&memcg->frn_lock, flags);
> +	}

If the lock stays, one acquisition around the loop is enough.

> +#ifdef CONFIG_CGROUP_WRITEBACK
> +	memcg_bdev_frn_wq = alloc_workqueue("memcg_bdev_frn_flusher",
> +					    WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
> +	WARN_ON(!memcg_bdev_frn_wq);
> +#endif

WQ_MEM_RECLAIM is for work items that memory reclaim depends on to make
forward progress. Nothing waits on these flushes. The throttled task just
sleeps and re-evaluates, and the bdi flusher remains the path that's
guaranteed to make progress. Can you drop the flag?

Thanks.

--
tejun

