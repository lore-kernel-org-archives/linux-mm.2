Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8708D606A337
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 20:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MZ5aB4fV
Received: by kanga.kvack.org (Postfix)
	id 8FC7B6B00EF; Tue,  3 Nov 2026 15:47:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F1B6B05B1; Tue,  3 Nov 2026 15:47:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 746C76B05B2; Tue,  3 Nov 2026 15:47:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41A786B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:47:34 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B091A40563
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:47:33 +0000 (UTC)
X-FDA: 85394993586.01.CBF6A0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 08368180008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:47:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MZ5aB4fV;
	spf=pass (imf16.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793738852;
	b=ZG9qHib2OSQtLRBridiZDMNbX7xrurA8DcOFHsYocU3P71Jf5jLUEvMgKCL0eI6kzDUskk
	8nWwEU7+pMyUd2nmkcmkH4VOUF+uhvMbKE/EGfalexovn8U6LRysIb5cQBVpY0q2N8r+Ae
	jGhim0ndu5nAp4+OwGExF/u2OlHVPlc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MZ5aB4fV;
	spf=pass (imf16.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793738852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WA4JldT6jZkiRqUOUhymd9+bMbgaai5DPTFvHOVFxkY=;
	b=5IZXfxn1ifPbSJN2LS849+jzxKyB3RkR4jXh2b8APBYAd4ueiRp3Im+TlGPucsIELVF2Wk
	Tq7FoGYaMq/bP2QhPvfjh3zvkJBtJKFRWghBu3zKXO9Eyaqzbnu9Sk/qibIB+yV0Mw9p0+
	aEOd8npzbSRXzw6hd5azLqk+DSYs62g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AC46431CC;
	Tue,  3 Nov 2026 20:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219691F0093A;
	Tue,  3 Nov 2026 20:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793738850;
	bh=WA4JldT6jZkiRqUOUhymd9+bMbgaai5DPTFvHOVFxkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MZ5aB4fVto6FbxRg77AGVx0jiXNVhH38K6sxyQ4CgLc3S9lJLQH7InuTEYv8lfOaf
	 5uoad99J7Yo66MZORzU1SueYppREaWAp7DnLjMArd/bw7llqmgjA7QeRkN0TecqOjw
	 mgPYGDAwQqwyEL4ByoiIyUJS5Ynf7UPLyKjtpGQBMTUIJCZtNDazrMWwmoLIPejkIK
	 R4yBtwITyXNn68MPxARx6qpkmGIeYtFfjYSs2zxU7gR3nB0yXltF941REAJYSVQAZs
	 JOShTK4Swr6Tw/lPkD7UPNQLTdL9bwzUWCtu2lgQU5SbFGQKMkCODHWkdfiTaQncQD
	 tHuce+fkMYTgw==
Date: Wed, 4 Nov 2026 07:47:09 +1100
From: Dave Chinner <dgc@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: gregkh@linuxfoundation.org, arve@android.com, tkjos@android.com,
	brauner@kernel.org, cmllamas@google.com, aliceryhl@google.com,
	nat@pixelcluster.dev, arunpravin.paneerselvam@amd.com,
	maarten.lankhorst@linux.intel.com, mripard@kernel.org,
	tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch,
	viro@zeniv.linux.org.uk, agruenba@redhat.com, trondmy@kernel.org,
	anna@kernel.org, cel@kernel.org, jlayton@kernel.org, cem@kernel.org,
	akpm@linux-foundation.org, david@fromorbit.com, david@kernel.org,
	hughd@google.com, hannes@cmpxchg.org, yosry@kernel.org,
	nphamcs@gmail.com, matthew.auld@intel.com, matthew.brost@intel.com,
	thomas.hellstrom@linux.intel.com, jack@suse.cz, neil@brown.name,
	okorniev@redhat.com, Dai.Ngo@oracle.com, tom@talpey.com,
	qi.zheng@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
	kas@kernel.org, mhocko@kernel.org, shakeel.butt@linux.dev,
	ljs@kernel.org, kasong@tencent.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH] mm/list_lru: Account node removals in isolation helpers
Message-ID: <aupITfr9pBKPrU20@dread>
References: <20261103045053.59548-1-kaitao.cheng@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103045053.59548-1-kaitao.cheng@linux.dev>
X-Stat-Signature: 5egqg9y1wk4zmmfwmqjfigb5eqhdds4y
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 08368180008
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793738851-525130
X-HE-Meta: U2FsdGVkX1+Ncw8jeTnbw8lk3dUebmiZvlAy2R9HuEe0P6Ztz+njqpdPjQKKIhnNU3TZsMdLCZlpGv0xP2gN3kbEwheXeYjXOiNOYZ6p0z8g3YrSNONjzxxVKkzHImFFD57bud4jycX38Kh1rKRE6/Al25b0SrOfan3D9zIWYcF5QPjnvsCDRc9dbNZBEUOXGlqDNrz9t6bTEc0TKS3rwQHPAvIsO4PMkWJy18MdvrXT4hXcJek6iDmnnzaqL2l3NIkd9/DINMEON+9LnxiJnIzQDP6tod9i8xkx/bbu79oI1a7OLfd3rNJNuDiAGynVdlD5abJDQ6qwEQB+iW7mVft7Aa0d7hx+rX+B6PnDVl7R/fLptnYaBoPTi0ZjdrBK2Dzt+VgKJdr0+DBWW0S6XWjsoUgho9twahfNgb6KiTnv9rDXjjcNJQyXdfte6GYPqNPlML0g3UOKQbrOT3rElSsHUvThAo4UDxmMAYQjuDL5c6tXNGBlRVaK0dohe3fY1NHLSyPaVkhvQkS5h+ecbEC/9UU2wD0O13CDNVRoWrgbiRm7rMMJys+jv8hv1Qs5fTrGKj99dar8UuIu4gVst+97sG6VxSi37a+y/zQqJ6AVDwb/s1pktJ3EZzjTJwDtjf747uWCMRzKL+4jffVakU6Pq2E/M20+2qh8RSHqdS+Fx2Q8TTHkS+vBPbqkNhte3upGE9kkPSqjZlRbcoQR5XPtrJ+kh3IxurVM4Kf+Wcr8TswnRLNMNR8vxKZtVuUesfIa02de6KwttMRy2WhQE9n26AzcOuWTImF0esWT6ixrSOPb/uyjuoJe+GOQFhyMxwKGG4R8W43ue9boajdMI+dSKUMoJG9QxJQ8k4Fro7jokggU/y43aYspl0kzpdbqjfIrtkrhu53yksP6OSkTH3BO3nZQNNbD5fY1M+K3+g0LH0Ttw90aw0M6dzseaPAYmBeCr21Z5zOzLuJiTWM
 Lpqagtd4
 bAjAjWDEf5WdZ7eyBZISCtFRtgXVKssoRL9Dl5TgZ8kbNRM9tR0Ou6dTiGxzUPwYHM9yPlw0+WjM1kPXLBhviAwhiAltynu9MoPoEZ8QrVqMMG8hJQseFqI2RlBLELAgZOs+WORVnOZwkDJ/op72ZefRwHMZVE/AAhlEZ5W+emQD6F7DJmzVDZDFMB/Zv9Ej3z1KxTTPyu9+ciLdwavzrSoOBQWv/UU/V1IK/vchNPGWNFc3g6TKAtpZKqAqcsnokBnzineTCJaN64Cq6Cx6k5ImkeApSBrHwzEWa5TP5dObQpNReZTS8NUhY5wxUsMGmJ6vuF4xZNVmDVDjo1CN2uSkzqQBlDM49X/A/E+Vw3uWVtRoqWJqVbnScwk4XfhC+WOkE4EzthdqjMDuVJFX7Ddub1o7b4PnnRUE8IgJo0grGBq51yQVH1B5onw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 12:50:53PM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> Successful writeback calls zswap_entry_free(), which removes the entry
> from the LRU and decrements both the sublist and node item counts.
> shrink_memcg_cb() then returns LRU_REMOVED_RETRY, causing the LRU walker
> to decrement the node count again.
> 
> The affected call path before this change is:
> 
>   __list_lru_walk_one()
>     shrink_memcg_cb()
>       zswap_writeback_entry()
>         zswap_entry_free()
>           zswap_lru_del()
>             list_lru_del()
>               __list_lru_del()
>                 atomic_long_dec()  /* first node count decrement */
>       return LRU_REMOVED_RETRY
>     atomic_long_dec()              /* second node count decrement */

That's a bug in the zswap code. You shouldn't be calling
list_lru_del() from __list_lru_walk_one() context.

Walker callbacks are supposed to use list_lru_isolate() or
list_lru_isolate_move() to remove the item from the LRU under the
lru lock. i.e. the walk and remove are a single atomic operation,
accounted by the walker infrastructure.

LRU_REMOVED_RETRY is for walkers that need to do work -after- the
item has been removed from the LRU (e.g. reclaim work that can't run
under the lru lock). i.e. the pattern for the callback code is
remove-unlock-reclaim-LRU_REMOVED_RETRY.

What the zswap code is doing is
unlock-reclaim-lock-remove-unlock-LRU_REMOVED_RETRY. That's
problematic, as we can have concurrent walkers, and so it's possible
that two shrinker invocations try to remove the same item at the
same time....

.... oh, what a nasty hack.

The zswap code is doing a list_move_tail() on the LRU object to
rotate it to the end of the LRU list before dropping the LRU lock,
in the hope that a concurrent scanner won't trip over it. That 
doesn't fix anything...

> During the mailing list discussion, Johannes Weiner suggested making
> users of the isolation interface responsible for maintaining the item
> counts, rather than having the walker decrement the node count based
> on the callback's return value.

urk. How is smearing the LRU NUMA abstraction into all the isolation
interfaces an improvement?

It seems to me that that this LRU hacking is all because of this:

         * 2. Usually, objects are taken off the LRU for reclaim. In
         *    this case this isn't possible, because if reclaim fails
         *    for whatever reason, we have no means of knowing if the
         *    entry is alive to put it back on the LRU.

And so to work around this inability of zswap to handle failure
sanely, the LRU list the reclaim code is being abused. And now the
abuse of the lru list code is triggering problems with the LRU
infrastructure, the suggestion is to push internal LRU structures
into all LRU list walkers to allow racy (and IMO broken) walker
behaviour?

I'd much prefer the zswap code get fixed than to have to modify a
dozen other subsystems to enable zswap to work around broken reclaim
code...

-Dave.
-- 
Dave Chinner
dgc@kernel.org

