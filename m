Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEDF5CCF2C1
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 22:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C89D6B008A; Fri, 16 Oct 2026 18:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853586B0092; Fri, 16 Oct 2026 18:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718DD6B0095; Fri, 16 Oct 2026 18:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 489516B008A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:43:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 478FE1C1CBD
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:43:08 +0000 (UTC)
X-FDA: 85329966456.05.DFAD215
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8DA9F40005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:43:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YiEujQYp;
	spf=pass (imf17.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792190586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/hZbe7RB6+Bi29L6udyhEOuf33yUa63JOrb9nCRpHA0=;
	b=X8vFbONkDdJZdxVpmO+hmgQlbLB3iGndFHVhu9caH0S+VxeJ+xLabs0Mha62bPw2GfOLJf
	bzd10llIBjd9Fv9lMliqsVK/4rOijcJzSPtZF3SMmxnLS+9y4GVQcwI8WRR6ryKi8pbC1C
	USbWcmFp9jbkDeeKh/maO2SG5jnpa58=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792190586;
	b=6KEkR9CoFItM+eZEbTjG5dbKUtlhma5PqIH085RtXTLbDd/RbZY98cYKWJtuYzdMnUooBK
	gD+JVSk84dcpqfUST8zctTmcKZnqt1gPOjDvk54RQ21yIJ9f0AkHVJVcegEiry2PUNGHx4
	haKcOpJWYMiSgb+vHdLkBVeXuQP82Oo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YiEujQYp;
	spf=pass (imf17.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BB72140AEF;
	Fri, 16 Oct 2026 22:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759871F000C4;
	Fri, 16 Oct 2026 22:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792190585;
	bh=/hZbe7RB6+Bi29L6udyhEOuf33yUa63JOrb9nCRpHA0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YiEujQYpBQlsJbuSzPmj1eHQzFwASacSFLqspUDQfuGBomyDFTF6yeOvLbe23tcoY
	 IlTTCXTUid1xqaP3KqVpUaidLGlF1o5isUFYE90qUG95Hd/b/EbY9KL0DpcG1BnAth
	 hPwdkPC1Y60vW2KIxTIFox/PqXwVBfGHcaAAQeeRNUBvpkOV7Jtb87HnOm4/TL1BgS
	 F6mQZm0XbqeN6vsjKKp3YAOYVcRJwaFVQlSZSV/XOtz9KDiL/v1EX6W1Fk5tm9tL+B
	 zmF0lWKFVetyjRqk0im1FD6ObKpRD98kBZN4rGXoJ+EjUR4EL24DAhIPZXDFRomxTn
	 s/9xa0XIQifPQ==
Date: Fri, 16 Oct 2026 12:43:04 -1000
Message-ID: <97f9db644113ce22a7e302d1b79bcfd3@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ian@honeycomb.io
Subject: Re: [PATCH v7 3/3] writeback: switch a replaced cgwb's inodes to its successor
In-Reply-To: <20261015-wb-dying-cgwb-flush-v7-3-9278d9ebaf5d@honeycomb.io>
References: <20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io>
 <20261015-wb-dying-cgwb-flush-v7-3-9278d9ebaf5d@honeycomb.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DA9F40005
X-Stat-Signature: bhg39o8hwboy7e1zumyi4rzz4ik5e55w
X-Rspamd-Server: rspam05
X-HE-Tag: 1792190586-328295
X-HE-Meta: U2FsdGVkX1//YLnoNRDmHX/NdSlec/jwp0vKSs3iINB+BJGplJm9Ascn3y9/r+NLZ4+EgWsi9c+RTF1hb0AwDJmR9O+t5m823TD+GWOoJnTlZApTJewyEgSnI8V5xcR3LgVrWP6P3Cb17gsQ3XIadMjCVZv0gxu0xM+b6KUwhmPMbvaQfGIs0BxQBt8vWi7KesDled01nHOjs437XGMDFHl21+r7GHeeXRESvxzYZfnOPwE/OlRL7vu+CQhnlZ0ItMYBWoHWVZ4AfLfsWSvMNT0RnqeufoKSF+/U9SJBtAdUeqtpnB9bnb/WX2pttBKu8tNE3UitEntBWyv4qGSNDt3FVjivBQXwb7AdLU96WSstqGIor+QpkwbZYd9BGIej323N5A39MUTAMkrnOgX2LdWWkTBsV1rQG4ocx48DB+A2V0tgaW4ESapqlMNUWGXM4Kl7/jxWw+yi2gDu3lPdnGHr4rBWHBNNCeSKjfnoNEvzd6h0Bx10Oss/5+9wM8rnI7uEA1Y6ICTJDEwG5Qs9YIS6y6E+KtJXCaO0R1/unHmgddNp9igNbLWPJsiAW3eFBUhVxmnM/nvc1X0I1B4gO+ukWjmpfZAbd+o8KABZYUKFr1TK3wG/Wn05UuwJCucojbJsp27c55H4ziOQkffICAG4ze0aGt7yCr8s4RdwCTSVmVwk5vDg7bcmaYAmK5AP+Ea99eBYiwaM8gZMWMf++0yoSYaBYE79DXzERCaU3MZe/rvOIhvBPUuaqaPPRr18tReILPJboLj9I+skRBXF6yhseX7mi9Vjol/48+rX9C0FNbqKv3rnrtPsgCLwENpMsfS4V7+i1fF8FP9X9ee+IJM7117YUL92E6/UG91YfEiUMZ+u8MV3K40cZZK2gRENIOn/ZVsZRv08lJQBF1zV8VQKnRIojEzmIrq7fxZb0d5yLhg0RtRKmnPJnihLzvli4OJRP00Sq0ImERsn3ZB
 GEtn3HDj
 VfnAOP8N49CLkdMWhdBgWDrMw1J+PJashlgxYj/PBM4/extv4YO4kOZA829tFvWoZXXZAwahcMH0jWkdna6vOAxDiAV25A2tI5PVcGhgNiTLV5QnX6dhBbggPw0Cg4gs+t5H4n+PR5qsyyj5OdTlLSDJCUcUsLlVCnmBUPhjezSaY44EvG2uUoEwUECcBZivxVZzk37Fu173cGdjH9MWfT8s2wsUrFgt20aRmFYtV+z7WgjufiN5pQxOymadjMxXOrzWDicjNLOQNwyNLyuyXdwgcLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 11:40:49AM +0000, Liz Fong-Jones wrote:
> When a live memcg's blkcg association changes, cgwb_create() replaces
> its killed wb in bdi->cgwb_tree. Foreign flushes for the memcg then
> find the new wb, but the inodes, dirty or not, are still attached to the
> old one, and they only move over as they are written back (see
> wbc_attach_and_unlock_inode()). Until then, other memcgs appending to
> those inodes stall in balance_dirty_pages().
>
> After the takeover, queue a work item that switches all inodes on the
> old wb's lists to the wb foreign flushes now find, like
> cleanup_offline_cgwb() does for b_attached and b_dirty_time, but
> including b_dirty, b_io and b_more_io. The switch carries the dirty and
> writeback page counts, so nothing needs to be written back first.
> cgwb_create() can run with interrupts disabled (folio_account_dirtied()
> -> inode_attach_wb()), so it only queues the work. A switch to the old
> wb that was queued before it was replaced can land after the work ran,
> so inode_switch_wbs_work_fn() queues the work again when the wb it
> switched inodes to is dying and no longer owns its slot. Inodes attached
> to the old wb but on none of its lists, such as one attached as the wb
> is replaced (see __inode_attach_wb()) or a clean one switched over from
> the root wb, still move over only when written back. If the successor is
> already gone, fall back like cleanup_offline_cgwb() does, to the nearest
> live ancestor's wb or the root wb.
>
> Since commit f6988c90671e ("writeback: bound cleanup_offline_cgwb()
> rescans by rotating scanned inodes"), the scan moves the inodes it walks
> to the newest end of each list, so hold wb_switch_rwsem for read across
> it, like the switches themselves. Otherwise a sync that has fixed its
> cutoff but not yet queued inodes can find older dirty inodes moved
> behind a newer one on b_dirty and return without writing them.
>
> Test: a live cgroup appends to 5000 files on XFS at 250MiB/s, io is
> disabled on its parent so its wb is killed, it creates a file (the
> takeover), and a sibling keeps appending to its files under a 4G parent
> limit. Worst lag of the sibling behind schedule over 30s, in three runs:
>
>   without this patch    9.1s   4.0s   1.0s
>   with this patch       1.7s   1.3s   1.0s
>
> Without this patch, moving the old wb's inodes over took up to 11s,
> first switch to last; with it, all 5001 were switched in a 23-35ms
> window, with up to 98MiB of the old cgroup's pages dirty.
>
> Suggested-by: Tejun Heo <tj@kernel.org>
> Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
> Assisted-by: Claude:claude-fable-5-1
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

