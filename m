Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8377C624D7
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 19:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8003F6B0088; Thu,  3 Sep 2026 15:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2476B008A; Thu,  3 Sep 2026 15:55:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67C246B008C; Thu,  3 Sep 2026 15:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D31F6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:55:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A13D21A064D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 19:55:51 +0000 (UTC)
X-FDA: 85173506502.24.074C883
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8FDA51C0002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 19:55:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RTa9IYvW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CFg+9dYm;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZZOpl9GX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SsuNNNEm;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788465349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S/Erzy3qipSog21XmSRx+P/p00l6BX/qJZPWZvzZbSI=;
	b=6E3JU3kVeqSQ0hpXTiM6P6RNLXGtIwGCJzmNPhNu2qMvhhXutPeefAX9YFOmzzOY9xXRD3
	7xXpWjeVWgIKUsG9TjYSNhjHAaBJ8v30TSs2uB+1n82/1h71HLn06QPeEGl6n8BjUXtziE
	o8n854sJzxrODdqDUUAwzLvQnYkxoQg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788465349;
	b=bkrc90Smm7Q9n/NidGg4aGlR3fvW3peQOQ1J4YU3Q+l5KewqhO9xZbtZDPuvHaqEC42+JS
	Ng7rsLoI0l2oFma1eoD9jkgHmZtumKzHKnZJtaVoGhcGivk8CzOPpucd8qwZtavn/Je+8j
	7rFlAd6O3qQqZhO3ljT3KS3KMJYmFMY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RTa9IYvW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CFg+9dYm;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZZOpl9GX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SsuNNNEm;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B310E22237;
	Thu,  3 Sep 2026 19:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788465343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/Erzy3qipSog21XmSRx+P/p00l6BX/qJZPWZvzZbSI=;
	b=RTa9IYvWr7tGW2jZp+DEqsmOO4wo0p/zNOm3E98Fy7mcLnp1qoUJNo55E4KsNRznO+7ijg
	dMHsKqHVOGT49LMRn4yu1Ady01BVijv4bw7yRmLlRPUpxFhaF5H+QH+Z5ahgeSAaK2cpcv
	u2W8X+m7BwxK6s5yBJvSj7G4q0JVbCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788465343;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/Erzy3qipSog21XmSRx+P/p00l6BX/qJZPWZvzZbSI=;
	b=CFg+9dYmO96Hwaqod/zU66rVwAo5M4L0rNh7WS5r0GuLh/E1yZyKisoB6G7bArc8F3soPB
	fHjfdfnue0iR7yBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788465339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/Erzy3qipSog21XmSRx+P/p00l6BX/qJZPWZvzZbSI=;
	b=ZZOpl9GXzWFguyRkJIL9k5Y/7whPO2Adk5/8ftBff3g+LhDqNJL6FiYqe084lCTI9uUBZL
	3IL0j5aYKlppzTTIRHWeG8yzuIam2xdSK56wfSPaFyJ9wFjOLlK3eqIcs9WWGTYRipDO8i
	AEWREz/4pNR0KEn80gfWpTowRheQWJo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788465339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/Erzy3qipSog21XmSRx+P/p00l6BX/qJZPWZvzZbSI=;
	b=SsuNNNEmrr8o/kFytiLZzYYkZwBlE7YGMXNxL4Nxp7YKsR0qgS9kW+527BbOfaO83Tv21q
	16E6Z8iUVnnyVdBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EFF23136D9;
	Thu,  3 Sep 2026 19:55:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XGgBN7nQmWoHVgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 03 Sep 2026 19:55:37 +0000
Date: Thu, 3 Sep 2026 20:55:36 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap
 writes
Message-ID: <apnO6MyHhCilamqJ@pedro-suse.lan>
References: <20260903182943.662461-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903182943.662461-1-kirill@shutemov.name>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8FDA51C0002
X-Stat-Signature: 3a6k6xbyqrjydbpdediazaaziadzyan3
X-HE-Tag: 1788465349-458097
X-HE-Meta: U2FsdGVkX18R7+hv/82UAfm6A4YeDCHMQXzZPw+1Qf5j6bdX88R35lZN0ab1AHcLqWb7VHQtQ3HLJwSqajW8hWQwZzenCdvaO2n5zzdEU/B/o9YQPpl9ISoV2weLfOK0sQFTqgqRcW1bQVWnIvTrsLwBoY/4xpCIoWOpv5OlfDqX5hWnz9fM3ZhcfNw5ICHmY/JDN4qUGS9fZvY99cT1gHtuoEaLGIFZqqrmjEtlYesoxzTql538U2rY3G7c0kfvejqlpCK6SGE3YuwoV+0mk1YBodDBOOZjz5IcKz8lrFUqYF7oR2gvWF2fJKJNCZPIAkZGa5txmB7LzI1Mp9SNMpmAORFyINxaUc1piYygnnudWWBCez0VUJejiHf+7WS/KhztnZeEH1ndITmHjeXHnCtQCHgHpf+Ra8S7/CJs/VtwdHNCFQUe7+lYTfZ0Ou6YGERb1tf3p7uUj2ROjYhP4ZAccCf9zGSpUt9yksXuwFRCRSocktIS0wyJrFvtjp1XFiPkOkIr0PGQmOBSV0lM5rutPjSnQCFODIdLp6KC5rWSQXKT26DdB/8zAURMNCpe/vuUacUKOo7HVSEkdCncMAiePebm06KOegKsMI0KlN7U72yvGTi+Xo3TmOgJOk79c8wjjBm91HRsuktu+locJ4kmmYwaD39+gMmgC6+fRVSuSJnV2NXX28rZQH7RTzuUOKvI12ORW65R5kmcoo4ZxYGDjd1v/ztgykrUWSBXjQS4hSuW8ccpvvTwtGGC/YI05QcKZGQhZv0rXjLplBYVPxtqDDpuHVIlD/3knXjEQVy3GxbXB6TzS2ibWFcsuds02PpFcoJEfyeIzUeOUIJp+uzbXHrjfXosNpWrBbwEtgbkHydm4f7RRGG33LXvcPz9F8lbpYd6/hWXQUvw/LVXSzcFSt1kmNUUPVpCk4b7FaxnSWUw88mrmkbiKACyP6OVBE2DJfl8HNhmO852I8d
 YGlsWYyd
 zooDe5S1YYPpYnNIXBn5CLowTDBAbr1Nh5Nh399r8Qil+kobZW6E5au58/ao9lrmYhlpAyzzjzoOLpiLwpF9SiqCn3peRTt3w57FpSR7+Bhzp8AU3ElwvyRqdSp6jJCLXw/WPO+QEPTiLUiXLDh9scg6CfLEGlHqGY9necjgIKlBmSdjyZnnsuJBu3gIgtm8qfncnTSu0rvHrQz5e/RZrkibwZAxgn9SM8dO29OHxtx8IFwZmCEyv59qy7/Uu5CQ2XEls1XRLWkv/2c26Dl3nMv1wFoN+7MBfBzp2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 07:29:38PM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> A store through a shared file mapping dirties the whole folio. With large
> page cache folios that turns a 4K store into 2M of writeback: one dirty
> bit per folio, and writeback has no way to know which part changed.
> 
> XFS already knows better. iomap tracks dirty state per block and
> iomap_writeback_folio() submits only the dirty ranges, and the buffered
> write path sets just the range it copied. Only the mmap path throws that
> away, because iomap_dirty_folio() covers the whole folio.
> 

Hmm, I believe Willy already had some patches; I don't know what came of
them (I think he's out for now).

> Narrowing the dirtying at page_mkwrite() time does not work on its own:
> set_pte_range() batch-maps a whole folio writable on the first shared
> write fault, so the stores that follow never fault and never reach the
> filesystem.

Help me out here: in which case does this happen? page fault handling is a
mess... I think page_mkwrite is always called, no? in do_shared_fault().

> 
> So harvest the hardware instead. folio_clear_dirty_for_io() already calls
> folio_mkclean(), whose rmap walk reads pte_dirty() for every entry of the
> folio and throws it away. Those bits are the only record of which parts
> of a large folio were written through a mapping. Collect them there and
> hand the filesystem the runs that were dirty, through a new
> a_ops->dirty_folio_range().

I think this goes against what we're trying to pull off. We want a single
method of dirtying folios, not 3.

Ideally(tm) we would have a single mkwrite interface.

> 
> All of this is about PTE-mapped folios. A PMD-mapped folio has a single
> dirty bit for the 2M it maps, so there is nothing finer to harvest, and
> it keeps writing back whole. Keeping shared write faults off PMDs is a
> separate patch and not part of this posting.
> 
> On a 512M file in 2M folios on XFS, storing one byte per folio and
> calling msync() wrote 512M before and writes 1M after, with identical
> minor fault counts.

But the effects are definitely nice though :)

> 
> Not addressed here:
> 
>  - Dirty accounting stays folio-granular. A 4K store still counts as 2M
>    against dirty_ratio and balance_dirty_pages().

That is correct; I don't think doing subpage accounting makes any sense,
the whole folio is still dirty, and for reclaim purposes can't be thrown
away (unless you added gnarly split logic for file folios as well).

>  - iomap_page_mkwrite() still allocates blocks for the whole folio.
>  - Filesystems without per-block dirty state see no change.
> 
> Kiryl Shutsemau (Meta) (5):
>   mm: let folio_mkclean() report which pages had dirty PTEs
>   mm: add a_ops->dirty_folio_range() and use the mkclean dirty harvest
>   mm: keep the mmap dirty range down to the faulting page
>   iomap: narrow page_mkwrite() dirtying to the faulting page
>   xfs: track mmap dirty state per block
> 
>  fs/iomap/buffered-io.c | 37 +++++++++++++-----
>  fs/xfs/xfs_aops.c      |  2 +-
>  include/linux/fs.h     |  3 ++
>  include/linux/iomap.h  |  2 +
>  include/linux/mm.h     |  1 +
>  include/linux/rmap.h   |  7 ++++
>  mm/memory.c            | 58 ++++++++++++++++++++++++++--
>  mm/page-writeback.c    | 87 +++++++++++++++++++++++++++++++++++++++---
>  mm/rmap.c              | 56 +++++++++++++++++++++------
>  9 files changed, 222 insertions(+), 31 deletions(-)
> 
> 
> base-commit: 0a0d1d55dad570724bf8c7ea83409639cfb4be9b
> -- 
> 2.54.0
> 

-- 
Pedro

