Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E72FDCA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 08:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D608F6B0005; Thu,  4 Sep 2025 04:53:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11336B0008; Thu,  4 Sep 2025 04:53:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD8556B000C; Thu,  4 Sep 2025 04:53:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A76766B0005
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 04:53:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D0001DF4DD
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:53:31 +0000 (UTC)
X-FDA: 83850954222.06.34AF299
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9BE0D40008
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:53:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zLY0z0sK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ks14tQUF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zLY0z0sK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ks14tQUF;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756976009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nPAlW2jGM6z2VbyPzIAk1XwDtLLRv8RXQFnUCLBEOis=;
	b=D9j03aCLdGMQWWo2uvs+9wBfJYBq8sKkIfPg9a7PkJZ3L5ZU3zpMTBujJPvqw11DKCrt7l
	4udwa9l7/6864Om01WgU9Hd7po4bXqWkeBp6rlVxtzFmtQ5QeHPLjY9verP3T98tmEdi9J
	aHWhRWpoMg0xj65pmNc1rnE0ptrXDpU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zLY0z0sK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ks14tQUF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zLY0z0sK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ks14tQUF;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756976009; a=rsa-sha256;
	cv=none;
	b=57GPMeHVuuOswxPz0cjSX/zdzbdK4PU5g/4cRxXIDLmnkrWx4Bid+kC8f8rdkMCX+r23LP
	w4ubyXH4BV+KynEigkmHtlvWHca7F49TKqdfgleP/Wo09L0U04UAZ2lEe7iuNf3sSS7ofe
	DqYQDNowe2iOUerWCFAv0qdG8ZxaknY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7619B33F61;
	Thu,  4 Sep 2025 08:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756976006; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nPAlW2jGM6z2VbyPzIAk1XwDtLLRv8RXQFnUCLBEOis=;
	b=zLY0z0sKVWzhzRyIbQlPUo4m/YP4rEXl2vWzHuOLU0U5wdSzWrLpPL14PpyZwl/3qBUvTb
	rKaEslebF5hPZjCAjVsD1OUXeyCWXPcDPw2CAfakN0tG1eRxPTorzw/JL7x3rHhN7/8Of7
	D+3/tMdTZX6vSBZ5b6Y0kE9t0JQGgTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756976006;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nPAlW2jGM6z2VbyPzIAk1XwDtLLRv8RXQFnUCLBEOis=;
	b=Ks14tQUF4QfXY3dKTad0ND0t1O3z2jPZSLpeLYMg+2yG3fErY4sRXypbYiiIo6S2x88NXf
	XLr/5Bal3QW4uPBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756976006; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nPAlW2jGM6z2VbyPzIAk1XwDtLLRv8RXQFnUCLBEOis=;
	b=zLY0z0sKVWzhzRyIbQlPUo4m/YP4rEXl2vWzHuOLU0U5wdSzWrLpPL14PpyZwl/3qBUvTb
	rKaEslebF5hPZjCAjVsD1OUXeyCWXPcDPw2CAfakN0tG1eRxPTorzw/JL7x3rHhN7/8Of7
	D+3/tMdTZX6vSBZ5b6Y0kE9t0JQGgTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756976006;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nPAlW2jGM6z2VbyPzIAk1XwDtLLRv8RXQFnUCLBEOis=;
	b=Ks14tQUF4QfXY3dKTad0ND0t1O3z2jPZSLpeLYMg+2yG3fErY4sRXypbYiiIo6S2x88NXf
	XLr/5Bal3QW4uPBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 69A9113675;
	Thu,  4 Sep 2025 08:53:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QCDEGYZTuWhOEAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 04 Sep 2025 08:53:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E8B40A0A2D; Thu,  4 Sep 2025 10:53:25 +0200 (CEST)
Date: Thu, 4 Sep 2025 10:53:25 +0200
From: Jan Kara <jack@suse.cz>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, brauner@kernel.org, willy@infradead.org, 
	jack@suse.cz, hch@infradead.org, djwong@kernel.org, jlayton@kernel.org, 
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 00/12] mm/iomap: add granular dirty and writeback
 accounting
Message-ID: <5qgjrq6l627byybxjs6vzouspeqj6hdrx2ohqbxqkkjy65mtz5@zp6pimrpeu4e>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829233942.3607248-1-joannelkoong@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 9BE0D40008
X-Rspam-User: 
X-Stat-Signature: 9bmp8app733s7ipnyo4b696a8h6rfsm1
X-Rspamd-Server: rspam09
X-HE-Tag: 1756976008-796390
X-HE-Meta: U2FsdGVkX1/d8tIKOnCKFf/XYNZbW8G84PkZkFx8v8atA42kN/qJbjY0XEiT14XYX5nz9HxrJcEwBjUwc/wiVrcxLp6HVy2PbSUcmqii1Z1bFAI1eHaH4chda1GxFWgAh3oWado49hr86asll4LT1uOtUaWXb6ZYE3/NfbiaFisCy1QGAMoyNxMuiqnc4FSjOg1e4TRiR8cXXVnijXBaIUxbYZLlgZmvhBdlZlHfUj/wQv0TwWutp1adJ0u5smUikDXKC//M6R+dKMyJr+43IZNiSZNqhKONAHcVPB1fvkH5g44taBRJ76ZdERj2b1wt+v1TfvRFsQ5S3SbpAHqaVQWzdF6Kwt3pYRM4anRZ5EOBN0sm5DLeUSLN21pWnlfhjzRrTzBjxzLfF2d5OAmAHKdBNvQg5uc7/bG12w2ePwZTg3DZ1aaPyqHZXBua0fHuZ4b/+KwQFJiHGC8gnX/L7RsFJNEfwdRHplpZFO2ip4F6TV1rdbV8S15/kINUFN+aJv/4z5wgSnyDq9vRb78pBMfBA3MxX3NeqNRvxrw0ktJ1NTtnYibRS3qXHfwoSVXow6a/rh82cAyeYTpNutkzcuxFjfccHfaQ8PdLbYhZeRP0KH7FxsY1ZxCp1phqbRmuMUetvsiWzEiG2wEqKCnwr3bdcZYoeTKbeRgch3VZP0/rgBnWUm1IPVhBVotWhkErsyJtUmM7NuBv62Faqo7sX0AKuUhet8i3BaamKB3YcLnTFqNrXfh00+6dLlTVrXA2kQksnlPAQqZTadhArA6aTnZpBnKwNZzpVSDZYhX2SvC2L+/uhP44hlq51j9p6scp6LUrBZpliuL7uN68MyAT3rkoif9FMeOz9tc+UaVWvJVKlWiERf4R6xuEh4RKd0A1gZWlwxFf2DjH74GEBQ8x/EtXb6fS821mDU8zKGqTzJ1K3/zhIpGbAvKAjrL2nfFskp5zd4fIv6uasaj/uOh
 uUbfA56u
 wurEUM2vtA0PeyfoFowf2IAGTQvtsz2XZDuTYQW7BxicLOtItfCxO4Yoyzb0hVNdE3ERDLciE4sEnUU1gUnE4x1KeYk56Ju/hTRk4e8+QjdmOOm5MNHEorKGn+YHXgZLQbiJuQwuxWpzWfzeniU1t7jR0wjr57e3a/RluOz46SDIJQt9bajcJK8Vo/8kugKXJrZubWkU/T5BTSZt/oqx0dWjf8pb17p1dswobaPcpvotjG7zTG1W4uhUqexphFxHUPrw+nkxHAuisHuthMzPAn+6J5ML2WnnpFN//NUy9Dp3nvgKNu+jM0oeveRNNql9JB+rZRXg65boDTCJX9VuMlbs1VNyJWsIj4hj0e7TdTIijj9g8O3m0rROt8XyvckkCJBhLSPgorMIqYXQmwVnWvUV3LYvSM0nZvoTB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello!

On Fri 29-08-25 16:39:30, Joanne Koong wrote:
> This patchset adds granular dirty and writeback stats accounting for large
> folios.
> 
> The dirty page balancing logic uses these stats to determine things like
> whether the ratelimit has been exceeded, the frequency with which pages need
> to be written back, if dirtying should be throttled, etc. Currently for large
> folios, if any byte in the folio is dirtied or written back, all the bytes in
> the folio are accounted as such.
> 
> In particular, there are four places where dirty and writeback stats get
> incremented and decremented as pages get dirtied and written back:
> a) folio dirtying (filemap_dirty_folio() -> ... -> folio_account_dirtied())
>    - increments NR_FILE_DIRTY, NR_ZONE_WRITE_PENDING, WB_RECLAIMABLE,
>      current->nr_dirtied
> 
> b) writing back a mapping (writeback_iter() -> ... ->
> folio_clear_dirty_for_io())
>    - decrements NR_FILE_DIRTY, NR_ZONE_WRITE_PENDING, WB_RECLAIMABLE
> 
> c) starting writeback on a folio (folio_start_writeback())
>    - increments WB_WRITEBACK, NR_WRITEBACK, NR_ZONE_WRITE_PENDING
> 
> d) ending writeback on a folio (folio_end_writeback())
>    - decrements WB_WRITEBACK, NR_WRITEBACK, NR_ZONE_WRITE_PENDING

I was looking through the patch set. One general concern I have is that it
all looks somewhat fragile. If you say start writeback on a folio with a
granular function and happen to end writeback with a non-granular one,
everything will run fine, just a permanent error in the counters will be
introduced.  Similarly with a dirtying / starting writeback mismatch. The
practicality of this issue is demostrated by the fact that you didn't
convert e.g. folio_redirty_for_writepage() so anybody using it together
with fine-grained accounting will just silently mess up the counters.
Another issue of a similar kind is that __folio_migrate_mapping() does not
support fine-grained accounting (and doesn't even have a way to figure out
proper amount to account) so again any page migration may introduce
permanent errors into counters. One way to deal with this fragility would
be to have a flag in the mapping that will determine whether the dirty
accounting is done by MM or the filesystem (iomap code in your case)
instead of determining it at the call site.

Another concern I have is the limitation to blocksize >= PAGE_SIZE you
mention below. That is kind of annoying for filesystems because generally
they also have to deal with cases of blocksize < PAGE_SIZE and having two
ways of accounting in one codebase is a big maintenance burden. But this
was discussed elsewhere in this series and I think you have settled on
supporting blocksize < PAGE_SIZE as well?

Finally, there is one general issue for which I'd like to hear opinions of
MM guys: Dirty throttling is a mechanism to avoid a situation where the
dirty page cache consumes too big amount of memory which makes page reclaim
hard and the machine thrashes as a result or goes OOM. Now if you dirty a
2MB folio, it really makes all those 2MB hard to reclaim (neither direct
reclaim nor kswapd will be able to reclaim such folio) even though only 1KB
in that folio needs actual writeback. In this sense it is actually correct
to account whole big folio as dirty in the counters - if you accounted only
1KB or even 4KB (page), a user could with some effort make all page cache
memory dirty and hard to reclaim without crossing the dirty limits. On the
other hand if only 1KB in a folio trully needs writeback, the writeback
will be generally significantly faster than with 2MB needing writeback. So
in this sense it is correct to account amount to data that trully needs
writeback.

I don't know what the right answer to this "conflict of interests" is. We
could keep accounting full folios in the global / memcg counters (to
protect memory reclaim) and do per page (or even finer) accounting in the
bdi_writeback which is there to avoid excessive accumulation of dirty data
(and thus long writeback times) against one device. This should still help
your case with FUSE and strictlimit (which is generally constrained by
bdi_writeback counters). One just needs to have a closer look how hard
would it be to adapt writeback throttling logic to the different
granularity of global counters and writeback counters...

								Honza

> Patches 1 to 9 adds support for the 4 cases above to take in the number of
> pages to be accounted, instead of accounting for the entire folio.
> 
> Patch 12 adds the iomap changes that uses these new APIs. This relies on the
> iomap folio state bitmap to track which pages are dirty (so that we avoid
> any double-counting). As such we can only do granular accounting if the
> block size >= PAGE_SIZE.
> 
> This patchset was run through xfstests using fuse passthrough hp (with an
> out-of-tree kernel patch enabling fuse large folios).
> 
> This is on top of commit 4f702205 ("Merge branch 'vfs-6.18.rust' into
> vfs.all") in Christian's vfs tree, and on top of the patchset that removes
> BDI_CAP_WRITEBACK_ACCT [1].
> 
> Local benchmarks were run on xfs by doing the following:
> 
> seting up xfs (per the xfstests readme):
> # xfs_io -f -c "falloc 0 10g" test.img
> # xfs_io -f -c "falloc 0 10g" scratch.img
> # mkfs.xfs test.img
> # losetup /dev/loop0 ./test.img
> # losetup /dev/loop1 ./scratch.img
> # mkdir -p /mnt/test && mount /dev/loop0 /mnt/test
> 
> # sudo sysctl -w vm.dirty_bytes=$((3276 * 1024 * 1024)) # roughly 20% of 16GB
> # sudo sysctl -w vm.dirty_background_bytes=$((1638*1024*1024)) # roughly 10% of 16GB
> 
> running this test program (ai-generated) [2] which essentially writes out 2 GB
> of data 256 MB at a time and then spins up 15 threads to do 50-byte 50k
> writes.
> 
> On my VM, I saw the writes take around 3 seconds (with some variability of
> taking 0.3 seconds to 5 seconds sometimes) in the base version vs taking
> a pretty consistent 0.14 seconds with this patchset. It'd be much appreciated
> if someone could also run it on their local system to verify they see similar
> numbers.
> 
> Thanks,
> Joanne
> 
> [1] https://lore.kernel.org/linux-fsdevel/20250707234606.2300149-1-joannelkoong@gmail.com/
> [2] https://pastebin.com/CbcwTXjq
> 
> Changelog
> v1: https://lore.kernel.org/linux-fsdevel/20250801002131.255068-1-joannelkoong@gmail.com/
> v1 -> v2:
> * Add documentation specifying caller expectations for the
>   filemap_dirty_folio_pages() -> __folio_mark_dirty() callpath (Jan)
> * Add requested iomap bitmap iteration refactoring (Christoph)
> * Fix long lines (Christoph)
> 
> Joanne Koong (12):
>   mm: pass number of pages to __folio_start_writeback()
>   mm: pass number of pages to __folio_end_writeback()
>   mm: add folio_end_writeback_pages() helper
>   mm: pass number of pages dirtied to __folio_mark_dirty()
>   mm: add filemap_dirty_folio_pages() helper
>   mm: add __folio_clear_dirty_for_io() helper
>   mm: add no_stats_accounting bitfield to wbc
>   mm: refactor clearing dirty stats into helper function
>   mm: add clear_dirty_for_io_stats() helper
>   iomap: refactor dirty bitmap iteration
>   iomap: refactor uptodate bitmap iteration
>   iomap: add granular dirty and writeback accounting
> 
>  fs/btrfs/subpage.c         |   2 +-
>  fs/buffer.c                |   6 +-
>  fs/ext4/page-io.c          |   2 +-
>  fs/iomap/buffered-io.c     | 281 ++++++++++++++++++++++++++++++-------
>  include/linux/page-flags.h |   4 +-
>  include/linux/pagemap.h    |   4 +-
>  include/linux/writeback.h  |  10 ++
>  mm/filemap.c               |  12 +-
>  mm/internal.h              |   2 +-
>  mm/page-writeback.c        | 115 +++++++++++----
>  10 files changed, 346 insertions(+), 92 deletions(-)
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

