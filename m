Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4907F606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=m5xT4FxW;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QITJlvhV;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=m5xT4FxW;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QITJlvhV
Received: by kanga.kvack.org (Postfix)
	id 234D56B00EF; Mon, 16 Nov 2026 06:02:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5EC6B05B0; Mon, 16 Nov 2026 06:02:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AE326B05B1; Mon, 16 Nov 2026 06:02:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCC676B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:02:25 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 463D814089E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:02:25 +0000 (UTC)
X-FDA: 85440693450.09.64508E6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id EE7D54000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:02:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m5xT4FxW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QITJlvhV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m5xT4FxW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QITJlvhV;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794826943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMrJA+gjZFjeo0ud1+bDTEk2lqHpB6cq2ulbdh6191o=;
	b=f6RGCSl4Se+3e79/YDDYyPveFYc9KjuvrbaCiYktSM5O6P8m4ysHL65xJMfpobIsq+MWbt
	HI4QOrj2W3r9y4Ev1eQyVlwJRyF+B5sOPkPHYD71cq20RiEscuEovR5CtFqPLlrKE3FNrK
	p+biTz0Ve0/cru36qTkYfvTDbV5CGz0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794826943;
	b=AjtJ4m5+lAyQKzu0NQZjJzw2hVgO9yyHcm3WHHS1f34qHfOKmXGu3rGT3DGc21cuJM252c
	WQfTjXmACDTpt+VWnVGyBCcCftjwm9gFUgzYKffNGxjefwX+mURv/qRp8n1c1yb++CZp3G
	Xy5NWbRpUMlc4t70M03rHsoaEUaZtgM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m5xT4FxW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QITJlvhV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m5xT4FxW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QITJlvhV;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9A98C1FD38;
	Mon, 16 Nov 2026 11:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794826941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zMrJA+gjZFjeo0ud1+bDTEk2lqHpB6cq2ulbdh6191o=;
	b=m5xT4FxWfhs/zyAI8agAe7LoG6kv0PNhgm8FfIeYbvTPRTtint7AWkWG9HgUuSUhcMt3/K
	HxyfZRrNkInhARbOOiK4DykIpqUjBjMAwWxL2XQzor4MjcVbnDgPoORIOouh0h8zwauEQE
	3tlmZTNweSJPM80cbqK2X/wzBiz0kGI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794826941;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zMrJA+gjZFjeo0ud1+bDTEk2lqHpB6cq2ulbdh6191o=;
	b=QITJlvhVhkoDFdAS/Enz/tCFDnDccQ+1FlmiGUQ0L7nZ1+NYfKqgknnqaLI6mDhJ89eQJH
	YS2FmZ31zPzziODA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794826941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zMrJA+gjZFjeo0ud1+bDTEk2lqHpB6cq2ulbdh6191o=;
	b=m5xT4FxWfhs/zyAI8agAe7LoG6kv0PNhgm8FfIeYbvTPRTtint7AWkWG9HgUuSUhcMt3/K
	HxyfZRrNkInhARbOOiK4DykIpqUjBjMAwWxL2XQzor4MjcVbnDgPoORIOouh0h8zwauEQE
	3tlmZTNweSJPM80cbqK2X/wzBiz0kGI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794826941;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zMrJA+gjZFjeo0ud1+bDTEk2lqHpB6cq2ulbdh6191o=;
	b=QITJlvhVhkoDFdAS/Enz/tCFDnDccQ+1FlmiGUQ0L7nZ1+NYfKqgknnqaLI6mDhJ89eQJH
	YS2FmZ31zPzziODA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6FEC713408;
	Mon, 16 Nov 2026 11:02:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 39+PCb3i+moaCwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 16 Nov 2026 11:02:21 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id D0FBA24DB2; Mon, 16 Nov 2026 12:02:20 +0100 (CET)
Date: Mon, 16 Nov 2026 12:02:20 +0100
From: Jan Kara <jack@suse.cz>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, Christian Brauner <brauner@kernel.org>, 
	linux-fsdevel@vger.kernel.org, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH v12 0/7] mm, iomap, NFSD: stop DONTCACHE writes reading
 back shared pages
Message-ID: <iushs6l3mjqkq65srej4gevaf2oeazy5j5miaipy6yxscetzjd@d4ti4qgbhman>
References: <20261112190911.84702-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112190911.84702-1-snitzer@kernel.org>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Stat-Signature: e83fh55uc4o479t4z7owfachcp1gaaca
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EE7D54000A
X-HE-Tag: 1794826942-804394
X-HE-Meta: U2FsdGVkX1/EUqUPyN8cM2bc025++b3JDE0phBMKJjaKV8r6QJAOYO/9aCqxgBepH0qN8xGRxE0ESwOd1qjmgPurrKJhjFsDzCkO3wsIXrba0hZr847M+CRX+I2D6MP6HwpU3rkVK+McQ2AWfJvDES2Le0mTRJg7KC1y1xb5cdPPZx/k7k8N8mJM25j3/jEy/gYh1ku0TWu62GbQLCf53xlWo0PMp1I19viGILLYeYso2Y4k+Aq4yJOT0UvxRt8E6zKwzdwUpG/ooadEzjxl9IEXafcxs2xc0M/bTNA9VzzZCRqMJfvf0XuvdAUmy4FfyBb5ZDRCCktQWMNSZRmPqmKs4Yu8+LH/i2iissrR7EUCXsJSNkfXnfa8ZbK6hdZrtd+AITftkWq4zOZ3ZhclPeiniYiDAhwGusgcYjdCPqQfuzvZI2efFl4iN61NSKenBbP9RQJ5rpVx79YtY4kRlv9oFB7iLOpd69hrqCMSpvLsUkdWs4T+RuEkagfnSacw5jOK0Myudegbdi4Ey0EXzzhRfNhDBpLIrVUGmdYj12ErTiasSvtZOmeRsdFXmr4hIewePBCvKZX03Oj0XPEzS/aJzeE4H4SINMmMAL8/HmFdHZ070KLOIaJLVigKhfP2W1dGun+kXXu3SzfQJiZLBGDpS9FXVkeqVnxv22BmYM9Nc1BEBinQNgHHsw0Wiv5A7PM5bZqudSsrPjNIsUITM3LRErsvhY+iTY5N0b9QW7k513DwGA64bf4327ep9FVQrTBHHgYLwdGKwObU46FHXzsrgpWiGXUmt3DxKkReCMLWmXkP3g2yax/VP+qSrgXrCPM9Mw88if6sGp7oQKlnl5NGtvaltg4b03UgnA/h6hrDLBemWzsItSBiFDsmfSazUFXsSiefNxCio/d1Og4tFWNSRxWLbFFMyY0ROhWjrN4u+XLnOZ7PT6+52UAyHAVzZUSboqvEA76JBH1ARGQ
 liBbMjSd
 qV+Y6sTi0xz0IFjSUUrgf8TKwJiqlYQjs7W6dWJz4L1Xnyo+xf/x/qK5UwQy9+HOPUDy2h/c3B8hXMDg3wkFnFSS/wWMG0v1gr93QilgrLzR4SKMiY88m0UQ8yk+m3yXOIipUktrqYjWkWjNEWZSRnKlKP6mKCF0jflVKKOXGIozt4FWSd59ymT6Hc90OHeMzZbICcofjX1FkC4uwwsC/ENnGxCYyUMBlh6PkTehBKiHyNy+8BmX2vtDV+2CcZgcgPlxuoL+fz5MID1mTWLMCv18YDT4AeuQgU0V+zrV9Vs3Atl8lLy44yUIy3l0+WmvQ8aoTEaRwjwaQJ2yikaUuMBbwMav5ZaYBMJrF6ZLC4JuTD30=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi!

On Thu 12-11-26 14:09:03, Mike Snitzer wrote:
> An RWF_DONTCACHE write is buffered IO: its data goes through the page
> cache, and writeback drops each folio once the folio is written back.
> A write that starts or ends inside a folio covers that folio only
> partially.  Usually another write covers the rest of the folio.  If
> writeback drops the folio before the other write writes its part, the
> other write must first read the folio back from disk.  32 threads
> writing interleaved records to one XFS file, 4 KiB pages, before and
> after 5/7:
> 
>   record  pwritev2() flags          4 KiB device       MiB/s
>   bytes                             reads per write
>                                     before   after     before  after
>   47008   RWF_DONTCACHE             0.97     0.0005    831     2281
>   47008   RWF_DONTCACHE|RWF_DSYNC   0.99     0.0005    601     1227
>   6000    RWF_DONTCACHE             0.97     0.0001    121      488
>   6000    RWF_DONTCACHE|RWF_DSYNC   0.99     0.0002     90      206
> 
> 47008 bytes is the transfer size of IO500's ior-hard, in which each
> rank writes interleaved records to one shared file.  Any record size
> that is not a multiple of the page size has the same problem.  6000
> bytes is a second example.

OK, I understand the problem but frankly I hate the complexity this
introduces. Patches 1-3 are good improvements, patch 4 is OK but 5 & 6 look
too complex for too niche usecase to me. I didn't really pay attention to
previous revisions of this patch set so I'm sorry if this was discussed but
can't we just make iomap for unaligned RWF_DONTCACHE write ask for
minimum-sized folios for the partial edges without FGP_DONTCACHE and
use FGP_DONTCACHE only for folios fully within write? That will also solve
the problem with the following write having to read again from the disk and
it will be much simpler. Sure the edge folios will not be dropped after IO
completion which may have smaller or larger effect (depending on the
overall write size) but I'd say that's the cost of userspace making life
hard for the kernel :-p

								Honza

> 
> The test program and script: https://lore.kernel.org/linux-nfs/atqJBS8MlYfeUU-t@kernel.org/
> 
> - 1/7 moves code into a helper, with no functional change.
> - 2/7 fixes 88d6f128d06d ("mm: track DONTCACHE dirty pages per
>   bdi_writeback"), in v7.3: WB_DONTCACHE_DIRTY could drift.
> - 3/7 reports WB_DONTCACHE_DIRTY in the bdi debugfs stats.
> - 4/7 adds folio_mark_dropbehind() for a folio that is already dirty.
> - 5/7 keeps a partially covered folio until the write that completes it.
> - 6/7 lets a writer that syncs its own write complete those folios
>   itself, after the sync.
> - 7/7 makes NFSD do that for the misaligned ends of a direct-mode WRITE.
> 
> Merging: Chuck suggested taking the series through the mm tree.  1/7 to
> 6/7 apply cleanly to each of these mm branches:
> 
>   mm-unstable  4318887a3efa ("fs/proc/task_mmu: fix lost maps entries above 2^63")
>   mm-new       daed51c91051 ("riscv: mm: fix concurrency in mark_new_valid_map()")
>   mm-stable    fa4ad798f6f6 ("Merge tag 'for-7.4-rc1-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux")
> 
> 7/7 needs the NFSD direct-mode changes that are in cel/nfsd-testing.
> The whole series applies to cel/nfsd-testing at ab036e3a0dd4 ("NFSD:
> Refuse a direct READ whose aligned range exceeds the reply pages"),
> where each patch builds with W=1 with no warnings.  So 7/7 could follow
> in the nfsd tree once the mm part is merged.
> 
> Changes since v11:
> - 4/7: folio_mark_dropbehind() leaves a mapped folio unmarked.  Through
>   its page table, a mapped folio can be dirtied without the folio lock,
>   and PG_dirty set before the folio is counted.  With a stale dirty tag,
>   folio_mark_dropbehind() then counted the folio in WB_DONTCACHE_DIRTY,
>   and the dirtier counted it again.  sashiko found this in its review of
>   v11 4/7 (https://lore.kernel.org/r/sashiko-outbox-210121@kernel.org).
>   The folio lock keeps an unmapped folio unmapped, so the window is
>   closed for every dirtier that does not use buffer heads.
>   filemap_end_dropbehind() does not drop a mapped folio either.
> - 6/7: filemap_dontcache_edge_complete() leaves a mapped folio alone,
>   dirty or clean, to match.
> - Jeff's Reviewed-by is dropped from 4/7, which now has a code change.
> - Testing: a KUnit test (not in this series) runs the interleaving from
>   sashiko's review step by step.  On an unmapped folio, the folio is
>   counted twice.  On a mapped folio, v12 leaves it unmarked and the
>   count is correct.  The v11 tests through NFSD and with RWF_DONTCACHE
>   give the same results with v12.
> - Rebased on the current cel/nfsd-testing.
> 
> v11: https://lore.kernel.org/linux-nfs/20261111015607.46338-1-snitzer@kernel.org/
> v10: https://lore.kernel.org/linux-nfs/20261103211754.35352-1-snitzer@kernel.org/
> v9: https://lore.kernel.org/linux-nfs/20261024221152.6965-1-snitzer@kernel.org/
> v8: https://lore.kernel.org/linux-nfs/20261023024548.71123-1-snitzer@kernel.org/
> v7: https://lore.kernel.org/linux-nfs/20261020220346.28020-1-snitzer@kernel.org/
> v6: https://lore.kernel.org/linux-nfs/atbfEbgMU6UGkn2X@kernel.org/
> v5: https://lore.kernel.org/linux-nfs/20261019150725.1507-1-snitzer@kernel.org/
> v4: https://lore.kernel.org/linux-nfs/20261015233309.42999-1-snitzer@kernel.org/
> v3: https://lore.kernel.org/linux-nfs/20261001045502.48381-1-snitzer@kernel.org/
> v2: https://lore.kernel.org/linux-nfs/20260929231329.22018-1-snitzer@kernel.org/
> v1: https://lore.kernel.org/linux-nfs/20260929173423.16149-1-snitzer@kernel.org/
> 
> Thanks,
> Mike
> 
> Mike Snitzer (7):
>   mm: move clearing the dropbehind flag of a found folio into a helper
>   mm: take a folio off WB_DONTCACHE_DIRTY only if it was counted there
>   mm: expose WB_DONTCACHE_DIRTY in bdi debugfs stats
>   mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it
>   mm, iomap: keep a partially covered page until a DONTCACHE write completes it
>   mm, iomap: let a DONTCACHE writer complete its shared pages itself
>   NFSD: drop a shared boundary page only once both WRITEs have written it
> 
>  .../filesystems/nfs/nfsd-io-modes.rst         |  18 ++
>  fs/iomap/buffered-io.c                        |  30 ++-
>  fs/iomap/trace.h                              |   3 +-
>  fs/nfsd/vfs.c                                 | 107 ++++++++-
>  include/linux/fs.h                            |   5 +-
>  include/linux/iomap.h                         |   1 +
>  include/linux/pagemap.h                       |  12 +
>  mm/backing-dev.c                              |   6 +
>  mm/filemap.c                                  | 219 ++++++++++++++++--
>  9 files changed, 370 insertions(+), 31 deletions(-)
> 
> 
> base-commit: ab036e3a0dd410f762192f33d6244e7993b36f8d
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

