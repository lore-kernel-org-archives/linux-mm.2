Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AA7EC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 17:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37A826B008A; Mon, 21 Sep 2026 13:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351F46B00C1; Mon, 21 Sep 2026 13:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268F96B00C2; Mon, 21 Sep 2026 13:58:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2B0C6B00C1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:58:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A9C41C0B8C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:58:04 +0000 (UTC)
X-FDA: 85238528088.10.27BF98F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B769018000B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:58:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="R/sDK9og";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="R/sDK9og";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790013482;
	b=Bvxtn8hGf3lfS3zJkORW1bwjBidVQ3F2clBhy5NGlAh2Ii8EvSUy6FIxZnVJHNwno/MpFC
	TvbdCO7gbbQW/rMAWjKUB/sWh/OQmlUE8iWk2b0YXiUMecX+BCfRR2sVSCi5mT4yHD+8nE
	4nt2oHeT0qFE7GF7jiSMoE7q6js6lVY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790013482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VrEKRxhpsxO4YB1Z88WoC1VfhzGFQ3EMsTjDujrRO+w=;
	b=TGiW5a5OCS/NUzE3bxftKD2t9HXzg1+KTnb0cI2gj0LHQdvADOS+tsY6PgYD3XwYDh3ZdC
	kg3kKZF+fDpCxv6WvQWJtPSY63IN+cNB4JK+3KDmQhPJlVATVmbxhqzy59DQlC31tN4TYo
	F9R+gFwAwdlckKwsUncpn7p/csfZcsQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D614D438C9;
	Mon, 21 Sep 2026 17:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904521F000FF;
	Mon, 21 Sep 2026 17:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790013481;
	bh=VrEKRxhpsxO4YB1Z88WoC1VfhzGFQ3EMsTjDujrRO+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/sDK9ogDpGJxJewL8iIUth9DWQnev+2MEzZXFhD0YypTxIon+lddkV/B5MiXsboO
	 byMrkKP0wfUx7XngMjTu9nAl2JaQK7zF3Phju/+ez58bU954kYLbxc8z3/4Vc0WgzQ
	 KOftHb5AUK5N9gFffvyEvRM47sRdl27CRx18LUuqQktKtMjB9/XICkbjwojAmHMCx0
	 IOUpxI7tR5Dak2iI8yZqV+B2DzvoXQOeYv7BXJA3uNEFbHCW1NXGE79SgsXboqYDFB
	 G+yzrNcbI31AM4MpDGbVDD6WgYVtVj6uG6HlTqlFELJEHb+bHt6BsCAnyTE5hCf2DX
	 y4CbMiaMOzh0w==
Message-ID: <b15c63490f9164bf46d68ff3ec5dfc02@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, willy@infradead.org, jack@suse.cz, tj@kernel.org,
 akpm@linux-foundation.org
Subject: Re: [PATCH v7 2/3] memcg,writeback: flush foreign bdev mappings
 separately from owner wbs
Date: Mon, 21 Sep 2026 07:55:17 -1000
In-Reply-To: <20260921120658.1627992-3-sunjunchao@bytedance.com>
References: <20260921120658.1627992-1-sunjunchao@bytedance.com>
 <20260921120658.1627992-3-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B769018000B
X-Stat-Signature: ob9ugmdskj8rfcxjjywymh93xbm7154z
X-Rspamd-Server: rspam01
X-HE-Tag: 1790013482-324201
X-HE-Meta: U2FsdGVkX1/Sn3kZ/1FduMvdc6d+hS0ylzoBJmi2B4Uen3VqsiNhV4be5hV+R9SiSorGID44lfls5QgchTbcHzrMewmv9PIPYqef0GUeijjGtQLkHkLT9UCG26zP8yVB+JWo+46Yf0WhtkXciZLaibdM4Fh4BfYfVrhaVxShk9IFXDckf9qYL5YNpWMelKGpadsMevZ9O33nLdNeLWcEdAoEgMuqNpuoJTDvEq43OjTyvG5vWwRLg5xool7zg9AS1VIMzJq5gf8Al8tg+WmmH8pMBYuv9bCE2HPPYf6TChGi5Ctk+9w9TtDJ9jzZ8ngbMo3x7R1zdEYDVLS8BU93I2WNU7aXirUgWY4PdUDhGE/rh3U+kxq+sAO9fZvrRzlAFha+0YN1B3whh06ZvF+FYl6RHX1qcFa8o53XHHXyxpRsRaDWlCNrN4EIL+DQ4SFgSSfYrh+Fdc4pBdcfXCBDM08G9iSg2rvrrhEOGXvkCMvpSAskpVzfJqPn1iCXcE5ABS58oBfpIu2RF5SduLxJYchPZxKwSYnDVo7/Y5pG3pwOX7Fn94cZC3RWPllwkpVB5pZsluvY9ZVC2nfAfxazQOPaybbdsgTliNHjXNdV6BOs9r29yjeMUbmSAATL7vgGV6Q1kSTYkoqvEWpPoz4ONWyrZ/rvOJqu7QrqCZJRzi10zFziaqFyZDCVbjmkt2U67DJKmoDA6FGoOuKcCduFKh4VCDnoCCcZRkUqm2NHi0Lp9dxo19WHRUCSl1uDzOkxND9V2QgSZG/eVJIrUxcEb6MfcFefz0Foz+UhpBCCCwQcu6bNAXcDq9jfL/im3IYqZo+VSBAYqwwPvdHhn6mGo2um17XqE8eSZiwq7RagPmX6EkNqJ7IKIrlBp0LMadd3q+61Z9p/ImwuE8bMKg/XDcJs8b5LAqwY0fuds1UfVgWRkjCOHUq/236WvQMITZl24tFI9sZ41QgL+L4Oqt6
 cotWcSh4
 JV9fd0ZEbYfDi+Zw9YHWjLEliYtHMzWfyq1oZ9OU8Okx0Jxrf6cMhMyiQvl1GZnW1vo3ImmZI/9yV0aqzfdYmRkuBEwCd8Zra/rtKbxG5xRBs9+vml+jnoE07nf1RYnloF7LjfPpluxH61E9N/zMMPtvgFQUYDH5s91i8HMDHn5nPyJHu4RRuXB5qfAYGvkTS7/gv01AiOZ+q3z+zx+A0agZXzXUQ+JO+5LK5uqWImhvTc1NHY9VBlv9B3q1Kl/4hJ32H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Julian.

This is an AI review. The series was built here, and the bdev reference
across a racing last close and disk removal, the slot races, and the
css_free ordering were traced and look correct. Two behavioral notes and
some description and comment fixups.

On Mon, Sep 21, 2026 at 08:06:57PM +0800, Julian Sun wrote:
> Use fixed per-memcg slots. Tracking is best effort: record only dev_t

The slot policy this version adopted, oldest-first replacement, expiry
after dirty_expire_interval, and re-arming when the mapping is dirtied
while a flush is in flight, isn't stated anywhere. Can you add a sentence?

> If allocation fails, retain the existing foreign-wb path.

Andrew found this unclear on v6 and the subject is still implied. Something
like "If the workqueue can't be allocated at boot, bdev inodes keep using
the existing foreign-wb path."?

> This primarily affects filesystems that keep metadata in the bdev page
> cache, such as ext4 and other buffer_head users, rather than the usual

The branch keys on sb_is_blkdev_sb(), so buffered writers of raw block
devices are covered too whenever the bdev inode's wb belongs to another
cgroup. Worth a mention.

> +struct bdev_frn_flush_ctx {
> +	struct work_struct work;
> +	dev_t dev;			/* for bdev inode, device hint */
> +	u64 at;				/* last recorded dirtying time in jiffies */
> +	atomic_t inflight;
> +};

It sits next to memcg_cgwb_frn and is memcg's, so maybe memcg_bdev_frn?
"for bdev inode, device hint" doesn't say what the value is. Following the
sibling's comments, "dev_t of the foreign bdev inode", and @inflight could
use one too.

> + * For non-bdev inodes, when a foreign page - a page whose memcg and
> + * writeback ownerships don't match - is dirtied,
> + * mem_cgroup_track_foreign_dirty() records the inode owning bdi_writeback
> + * on the page owning memcg. When balance_dirty_pages() decides that the
> + * memcg needs to sleep due to high dirty ratio, it calls
>   * mem_cgroup_flush_foreign() which queues writeback on the recorded
>   * foreign bdi_writebacks which haven't expired.  Both the numbers of
>   * recorded bdi_writebacks and concurrent in-flight foreign writebacks are
>   * limited to MEMCG_CGWB_FRN_CNT.

The flush sentence and the slot limit apply to both paths now, so the "For
non-bdev inodes" scoping reads wrong. Maybe keep the original paragraph and
let the new one state only the difference: separate MEMCG_CGWB_FRN_CNT
slots keyed by dev_t, flushing only the bdev mapping, same expiry.

> + * These wb/bdev_inodes records only remember IDs and don't hold any object
> + * references. As being wrong occasionally doesn't matter, updates and
> + * accesses to the records are lockless and racy.

The paragraph above already says the bdev records hold no references, and
"wb/bdev_inodes records" doesn't parse. "Both kinds of records only
remember IDs ..." would do.

> +	if (memcg_bdev_frn_wq && bdev_inode &&
> +	    sb_is_blkdev_sb(bdev_inode->i_sb)) {
> +		mem_cgroup_track_foreign_bdev(memcg, bdev_inode->i_rdev);
> +		return;
> +	}
>
>  	trace_track_foreign_dirty(folio, wb);

With this patch alone, foreign dirtying of a bdev folio no longer hits
track_foreign_dirty at all and patch 3 adds the call back inside the
branch. Can you keep the tracepoint firing on the bdev path here so that
patch 3 only adds the argument? Also, @bdev_inode can't be NULL:
__folio_mark_dirty() checked folio->mapping under the same lock and
folio_account_dirtied() already dereferenced mapping->host.

> +static void bdev_frn_flush_work(struct work_struct *work)
> +{
> +	struct bdev_frn_flush_ctx *ctx =
> +		container_of(work, struct bdev_frn_flush_ctx, work);
> +
> +	bdev_flush_by_dev(ctx->dev);
> +
> +	atomic_set(&ctx->inflight, 0);
> +}

The in-flight window is now just the submission of the bdev mapping, and
mem_cgroup_flush_foreign() runs on every throttle-loop iteration, so a
memcg that keeps dirtying and throttling requeues the flush back to back.
A folio the flush redirties, e.g. a buffer locked by a jbd2 checkpoint
write, re-stamps the slot on its own. The old record stayed in flight for
the whole owner-wb work. With a journal the write cadence of hot metadata
is still bounded by the commit interval, but for nojournal ext4 and other
buffer_head users it's bounded only by the throttle pause, for every
tenant of the filesystem while any tenant throttles. Not measured. The
description covers the target size but not the cadence.

Each pass also goes through wbc_attach_fdatawrite_inode() and
wbc_detach_inode(), so it votes in the bdev inode's wb-switch detection
like the owner-wb flush did, at the higher pass rate. Whether the bdev
inode ends up switching wbs more often is an open question.

> +		if (memcg_bdev_frn_wq && time_after64(ctx->at, now - intv) &&
> +		    atomic_cmpxchg(&ctx->inflight, 0, 1) == 0) {

Records are only created when the workqueue exists and @at stays 0
otherwise, so the wq test can't be false with a live record. Fine as
documentation, but the cover lists it as a fix.

> +		INIT_WORK(&ctx->work, bdev_frn_flush_work);
> +		atomic_set(&ctx->inflight, 0);

memcg is zero-allocated, so the atomic_set() isn't needed.

On patch 1, the kerneldoc's "does not wait for all I/O to complete"
understates it, the flush waits for nothing.

Thanks.

--
tejun

