Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 280E0C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 22:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33FA26B009D; Tue, 14 Jul 2026 18:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EFF76B009E; Tue, 14 Jul 2026 18:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 208B16B009F; Tue, 14 Jul 2026 18:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE9996B009D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:23:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7EBDF1C0363
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:23:00 +0000 (UTC)
X-FDA: 84988808520.14.8F1B9DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id C6EB4A0007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:22:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kC//weSt";
	spf=pass (imf25.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784067778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aW/VhQGKLT7lo4RL60Q9vlfIJhM19IRBW2Xc6k3j5aA=;
	b=l8Qvkqy5k6uK+zjl3VMdy93fKLuURQiTFpeWewPla9QB/MnjRQ2SMikM1MhZGCpMobDch5
	KYfz9qT3tKxF2boAPYzLkYHUKtZWaNe+in9WyoS02SptsqTwCLnA0BOx3oxEUQjxsxjXyE
	xYOd8SCb8NhqXbHKhsZryoDGi+UFuBw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kC//weSt";
	spf=pass (imf25.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784067778;
	b=2bssG+PqY5XmWEkPB/H6aNzmBAmdVUEzncRiQE590Bb1FLdFg1VlRBE1MFVPv9bdsKtKVj
	zAxXXt5uyZ6J4vzoDk800JkzMGKyt4fDweO3gdliv3aWMWaLpTz1mRbZ81G30OiAgYBBVb
	Vq8ZvZzZ+gfCGnlFsK9HPLw965SBBuA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C6FF141180;
	Tue, 14 Jul 2026 22:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D208D1F000E9;
	Tue, 14 Jul 2026 22:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784067777;
	bh=aW/VhQGKLT7lo4RL60Q9vlfIJhM19IRBW2Xc6k3j5aA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kC//weStXk5f3N6WZzLP0YLgvU9fktRcRiiMLCE5kGshiYa1KIxXg/9Bw7q5Ofqva
	 3TVgHfl3KPemY8C7xjEeCt8ud9H4K/0IlxLbd3S2qNvBAO//ad8IF/JNSzvvoAmW0p
	 NBA7wBiag/P4uG8walzTY/9BXlP5CF75pMQ5hA/WLJ8XHETIEjg2nhoAl3ht9BJuDM
	 eH7f4ZWBfbpn3FC867t2mcdvwML0HaUuyVqAwKnorYZ9K9zrzNvr3U3c+VBB9jqSOz
	 rdDF1enltkZ2LSSqc+GLIGA71bOdngTjtLiSSapXQ2gJjKNoo5NliTTlPAwt9wy/Ct
	 ce62BOPi0BRYg==
Date: Wed, 15 Jul 2026 08:22:36 +1000
From: Dave Chinner <dgc@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: brauner@kernel.org, qi.zheng@linux.dev, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
	hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com,
	linux-btrfs@vger.kernel.org, cem@kernel.org,
	linux-xfs@vger.kernel.org, shakeel.butt@linux.dev,
	hannes@cmpxchg.org, riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH] fs: push nr_cached_objects memcg gating into individual
 filesystems
Message-ID: <ala2rDHrFDjql3Qg@dread>
References: <20260714101454.1202449-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714101454.1202449-1-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C6EB4A0007
X-Stat-Signature: zb1oh68zdezfxd7kzw9dywqgu8bj4t9h
X-HE-Tag: 1784067778-986236
X-HE-Meta: U2FsdGVkX19n2BDIeOuGYr4FUD3TFYGirQcM5wMdMVHCpjm9ZlL3TbV2uMjRPaHIWkHjKrWa4VFJL/xMiKrM1dhXLFjElgHzdRJLzDR/Ap8hVTxNt0lorgQAQxE1/180j1pI7kRKg2QtPPh5FZqsSwaYRQGwF4WOHHQ8GrdGHkVYHVeS9dUcbBR+DcjKJbjreeGwt0NXojA+Z2dcnMDpD869VSMKKvbcm4w0ABLkGhNmUWFZrK2/PYrxTD0Go4XdHJ9SDNwBo8G7qKwatEli4cABUSOwnrDFCe63Ve31zizmZnhyXFmDM9Y9N2O6vFXE31MCaN8mBQSZJuAAHq7g/f2XjlFRZC5HNT67rKcS0W/K+/2P4Qi07bIS8FMIyV0FN0aX9neAYGoPsZt7bXi5sAyt/+uKrM7rSdHvuJInhakwK798JKnOd4QYfa3KmM1IHU8NzpIpOXbqGB8nYASjdz8rTPZ9dUQ0OZtp+aKbxHi8Uq28Es4lAANP/NZkVyD8P6hWk1PqG0teDvyly2OXWMab/NswKAn6VvYx2tJxD1CTpJYsMRtvBDTss82qLbO0aDiYQ4OBJ8nVoIHS0FP2KGIK77MOS4GQb9ropfYr1qCDy4J78G3wWEn0AxSJFL3EKG1rz69M4B2GhV0Q4OAG5VcKfTQ2B4ikxHEQvH64o0a/stkuG8ZhwJ2x3YO0gvEu0DWhpA61d4LF/gR/zDP2Ycj55WjjECmYEyAktGxCceXa42C/Tu//f34uRccuPs5seSV6c6gRDwvATniX/r+Wqh/AOQM23WlSwQ4dHT40kujRuAtA0d/box48/33/gskOMZosl5l1/U8xBklhUP4EEUSqC7R7AkWiP/WFaVBzwClPlxqEBFwRE1jbDfmbCeCZziGNVN/vPqggC5ALOWky361/BkLLcR+tyDt5vDC6AKBEXDcnbAGqfQiV9Ejz6fFQTMKjhPZsGTMAhMoqFth
 H79+3QEC
 j/QPd0Kt5kBbB9jqXhGJxFbxj/mnwvlWcntU3iNbyLajxFN4nS8dm7/IFXaFbMULWjMB3r/R3FjucC06LGZuKdwJzXRiiCI0yP4jfXaQ3/0wBIWAuZe/9+Y04Oodn2ksk38wgy0mII8eUl+WRuC0DnuIObMtIfiaYg+HlhyYIzTMxNBfxQtsC0mHyvTjvG/w8iAgA0ugMn8/IStKLRreHIGZHfQL51rSrLoVKVUtP+0D9Jqy3kN+USxHwcmTLcJ779E9eFQeinulrNos7V754aH8OdmCrkTEVIDmNjv8KJF1yGi+jdZubVeW5+40InXDMiWEC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 03:14:54AM -0700, Usama Arif wrote:
> Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
> in memcg slab shrink") added a check in fs/super.c that skips the
> ->nr_cached_objects() hook whenever the shrinker is invoked for a
> non-root memcg, because none of the current implementations (btrfs,
> xfs, shmem huge) honour sc->memcg.

I don't see that commit in an upstream tree. I'm guessing I wasn't
cc'd on it, either, because I don't recall seeing that as a patch,
either.

However, if anything is gating the fs_objects callouts to the fs
when memcg is being srhunk, then it is fundamentally broken and you
are correct to fix it.

> 
> That policy is really a filesystem-owned property: fs/super.c should
> not encode the assumption that these hooks are never memcg-aware,
> since a future implementation might legitimately filter by sc->memcg.
> Move the check into btrfs_nr_cached_objects(), xfs_fs_nr_cached_objects()
> and shmem_unused_huge_count() so each filesystem can lift the
> restriction independently once its underlying counters/scans become
> memcg-aware, without needing a coordinated change to fs/super.c.

However, your assumptions here are incorrect.

That is, the XFS fs_objects implementation is intended to be called
even when memcg shrinking is occurring. I architected it that way
all those years ago when I introduced the fs_objects shrinker
callout. i.e. XFS is not aging reclaimable inodes via this call - it
is purely an expedite freeing of recently reclaimed VFS inodes when
there is memory pressure of any kind.

Reclaimable XFS inodes are still charged to memcgs, but we don't
track them per-memcg because it is extremely inefficient when their
lifetime after being released by the VFS is usually less than 5
seconds. Indeed, this low level cache is not for working set
retention; the VFS inode cache does that. The XFS inodes need to
through a GC state before they can be freed, this takes a little bit
of time, so we don't hold up the VFS inode cache shrinker for that.

The VFS inode cache shrinker is memcg aware, so it only pushes
inodes that are being reclaimed by memcg reclaim into the the
reclaimable state at the XFS level. Hence we don't need to track
reclaimable inodes by memcg - we know that memcg owned inodes that
are to be freed have already been pushed into reclaim by the VFS
shrinker doing memcg reclaim. Hence all we need to do is sweep them
and free them.

This is what the XFS fs objects shrinker does.  It needs to run in
conjunction with -any- shrinker context to immediately free the
clean inodes that the VFS shrinker released that pass, and to
release any of the recently released VFS inodes that needed GC and
are now clean and can be freed.

IOWs, the XFS fs_objects callout is not "memcg-aware" in the classic
sense of "it tracks objects by their owner memcg". However, the
-combined superblock shrinker algorithm- is memcg aware and that
results in XFS only seeing objects from the memcg being reclaimed
transitioning to RECLAIMABLE state which it then immediately sweeps
away.

i.e. the architecture of the VFS and XFS inode cache reclaim is
entirely memcg aware, and that is why I implemented the fs_objects
callout for XFS all those years ago. It works efficiently, it works
correctly with memcg based reclaim, and XFS doesn't need to care
about memcgs in it's low level reclaim code. Win, win, win.

> Behaviour is unchanged: calls into these hooks from shrink_slab_memcg()

Behaviour was broken by the above commit, it needs to change.

> still early-return 0 for non-root memcg contexts, keeping the shrinker
> bit clearable in each memcg's bitmap; the global (kswapd or root
> direct reclaim) path still drives them as before.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>
> @@ -170,19 +169,6 @@ static void super_wake(struct super_block *sb, unsigned int flag)
>  	wake_up_var(&sb->s_flags);
>  }
>  
> -/*
> - * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
> - * operate on filesystem-global state and ignore sc->memcg. Driving them
> - * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
> - * per-cpu counters and queueing duplicate work: the actual reclaim happens on
> - * the global path (kswapd or root direct reclaim) regardless. Restrict them
> - * to that path.
> - */
> -static inline bool super_fs_objects_eligible(struct shrink_control *sc)
> -{
> -	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
> -}

This wrapper should still exist (with a better name) so filesystems
don't need to open code memcg cruft.

-Dave.
-- 
Dave Chinner
dgc@kernel.org

