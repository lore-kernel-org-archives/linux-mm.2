Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A991460A263B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 11:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=aPxq/8Jr;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=neGXudo8;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=aPxq/8Jr;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=neGXudo8
Received: by kanga.kvack.org (Postfix)
	id D12E96B05B3; Fri, 20 Nov 2026 06:57:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC2906B05B4; Fri, 20 Nov 2026 06:57:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB1DA6B05B5; Fri, 20 Nov 2026 06:57:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF7C6B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:57:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 285D680F3F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:57:28 +0000 (UTC)
X-FDA: 85455347376.18.37D639C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id B4023180002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:57:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="aPxq/8Jr";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=neGXudo8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="aPxq/8Jr";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=neGXudo8;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795175846;
	b=dfhRSVEMXMap9GOSbqlKfZ96Iv/94vMY0SlFXFnOc+3k9vE4k3yH3ydcq1vJR55VXo6Axr
	AjC3OQyiRjUnwPZpkiuRip71+yfUQteLWkbfFCxlOHwD1B2AXnLZYzLtR0zRsbzKLY6NUW
	h8Bg86+xyYbZo7cHE/FZIqV5+cZrVVs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795175846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2UfyX4HcTgglDLDCpVQRwII+hpQZMq7tsHEziWfbiTU=;
	b=T8eLg9tw3QYIzHelN2iCDjDgbPUYrTlwMXCKTTO+0OAy94TR6cNYxZ9x8IP+pWjZ6B1cYM
	VTAskranDVjEWG0o6dDz/Eb3nxXmhDx8Fq4Av/wQU3bv70PAXzBJCG02llAx0oIrRWT0qD
	aGjBOMxcBUjqjgWejceRDKGrQvGrexA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="aPxq/8Jr";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=neGXudo8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="aPxq/8Jr";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=neGXudo8;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 022D01F441;
	Fri, 20 Nov 2026 11:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795175844; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2UfyX4HcTgglDLDCpVQRwII+hpQZMq7tsHEziWfbiTU=;
	b=aPxq/8JrK7TX5/4zb61bR0lNbw+ULbGnJx7r8UWPT1s/w1td1wy6y5QQ5dMqQaqtKnotMG
	0wuJBaEw0oWI0WHGN3bT2LIwVZqB2BZnhUuEh4mwBvbNzHMQ7cztp0gRFRWAlG5MrbOsfI
	YBkUHP+j/PSV0xGH52dneXTl/+Xzcxk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795175844;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2UfyX4HcTgglDLDCpVQRwII+hpQZMq7tsHEziWfbiTU=;
	b=neGXudo8yCIZnK/u9k9axSwtuJRv4LtRqBsee9U9/HSxjThsg40KfQ1q5ujZJJ+jxbCZVt
	GdWCbnIWyiGdHLBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795175844; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2UfyX4HcTgglDLDCpVQRwII+hpQZMq7tsHEziWfbiTU=;
	b=aPxq/8JrK7TX5/4zb61bR0lNbw+ULbGnJx7r8UWPT1s/w1td1wy6y5QQ5dMqQaqtKnotMG
	0wuJBaEw0oWI0WHGN3bT2LIwVZqB2BZnhUuEh4mwBvbNzHMQ7cztp0gRFRWAlG5MrbOsfI
	YBkUHP+j/PSV0xGH52dneXTl/+Xzcxk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795175844;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2UfyX4HcTgglDLDCpVQRwII+hpQZMq7tsHEziWfbiTU=;
	b=neGXudo8yCIZnK/u9k9axSwtuJRv4LtRqBsee9U9/HSxjThsg40KfQ1q5ujZJJ+jxbCZVt
	GdWCbnIWyiGdHLBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C57FC1348F;
	Fri, 20 Nov 2026 11:57:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4gHRJ6M1AGu0EAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Nov 2026 11:57:23 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 4C6B225F40; Fri, 20 Nov 2026 12:57:23 +0100 (CET)
Date: Fri, 20 Nov 2026 12:57:23 +0100
From: Jan Kara <jack@suse.cz>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <ljs@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
Message-ID: <yawwmyxucwkzmay55hkcngm2bvaqjdrrvssgasf54zy5nwpfxl@6ocrzft2w6gy>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
X-Spam-Score: -16.80
X-Spam-Level: 
X-Stat-Signature: 16kpzkaahwzwf4yjjx6xrq3mwshjazsp
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B4023180002
X-HE-Tag: 1795175845-685727
X-HE-Meta: U2FsdGVkX18JuFKSt0BP1diZTs6eCgnzyhLxwhEpqxwD2FKfYOjXFZoHGkmybwrNwINsztS/7JFW7kV9llZdk7yUS+bfUru/fztBA8DWI+dFs0Obo0/5A6t1P9+BAR0FAPaUkzCrSMdZuIekvJxrMyyd9E4bK/gLr5I43Ay94ZYQehOwPOVyajFhq8UKlhlU/yYU4PSZYHvN8n7z7NealCJ/07qoMLNNoH3Jqhk/RdzFVh3Bh8XKw0jWa0U7a2XHcUJH9yqn8b6KmAwsYkmtmylzHc6NV4b21tDc4+bVjPt0y1ChZj/63Wdh6ScUBB32bj7cC31dVWYsdnvfhkL97G9c7qYD31qiKDAqr4+lBraTBFwJleJoXa2EdjRZA/7DDNz3hX3xpKtXTwusyV7mamHVMs0zR4O8Pc+ev7elgWFper7PQGajrrAofQ59Pl1TjSLIJ9CcTEFerBEsRNnKfTs0c5J8qfybluxePghUbGE23ZaxJ2YpWTZP3jMpcx62JfgEQVIltgmT/FDzsOw64BuEtRtMrhFoaT9FDOBFSM9LLdRq+Ish9RvGSZYGA4Zvm/wj4fcOc/KJFOyo6iXfySD43tlpulPR4Yf4ifqj9kkALybMfMr7eFOBtbpOQI8j+hTfBXnzE9luvGLeH6dw6jeljB9rKCl0cogzhPWGJrLYGtoAxKqhflP2xv489fnhjH8tZZkFI2m5ZomjZOk4I4ZFPYGUGUaC+nI8zhVLwR1S13sT77ks7NXXPZEl6MptxIBZ8KySRi2U2xYo/2QQnu9xzzSsTJmcHhbLnV7G/QLm2JpoxxUq3nKZVj1B7OsZ+/z+doYW7Vo20BX2VqSc648jXOokGRh2nh+fjgqJNtR3Y/AkacmFZpdxaoeWebebYDPOxGb+oMcI9rW8RmbgOtC7csUH62BDe6gjUFuCKgBpO4H3p0ihWvfC6W6gdG4dcIHdXgGStUFV49WOUCL
 1JhHzpc4
 q/NH543lRrbtQvDpBIeamAotCCxxs1kMjj65G9wZvImvEzSdrWK3Vgay+hfzqScsHDQlFcgFHfsEnqxgSO+GS27yHEyqJ30QGRDBRLXiKLfvUwUmDUWdvQWwKzKPWfoOEWAyeVVVg5ZRhUxLkmgpeL7swy0wutqKphuwGUpYt+A0/aSebMtrW9U7chcpE9WsU8k3uQcnl+9i9+Nfs6GANhR9ZHxwmWe1/KkDWCZIGXunwLPoydgm96ws3T1GmA5e3j7rMuSK/b1IKDTiHukFPw8y6HD7tF3faQJhYH/Y17n596hnrd2NIjvFCocVeaJcbRMJosRFGBjSVGjdvaEYA8aePI0pqdyJBHa6nHZ+Cr6esuRwfHGNEmGuYodJ0RJzM8l1VZSQVy0FV7cjZn2+hJfudSXz/ifba3lqJKvHvy9Q9FmXuqTaHJkTy2vRhsyPD3HBoF21lhZHXwiWld984rihCiuxaE+cPFJVmVM0J6aeq5wX4olqOCHlcOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 19-11-26 20:10:43, Pedro Falcato wrote:
> Sooo.... It turns out GUP dirty and ->release_folio() interact really
> weirdly. This was initially reported by some AI agent, and David let me
> know.
> 
> The basic issue is:
>  - ->dirty_folio() relies on buffers/IFS/etc being attached to the
>    folios. It _cannot_ attach them itself, as dirty_folio() cannot
>    block.
>  - certain MM paths (reclaim, khugepaged, folio split, etc) are very
>    trigger-happy when it comes to asking filesystems to release them. In
>    most cases, barring any dirty folios, buffers, it will just drop
>    them.
>  - there is no problem in usual IO submission, but issues start to pop
>    up with GUP, where the code flow (roughly) becomes:
>         [get_user_pages(), etc]
>            ->page_mkwrite() called here, or before
>              ->private correctly populated with whatever the filesystem
>                expects.
>              folio is marked as dirty, initially.
>        *write finishes*
>        folio_lock();
>        folio_mark_dirty();
>          ->dirty_folio()
>               dirty_folio expects ->private to be populated by
>               ->page_mkwrite(), ->write_begin().
>        folio_unlock();

As John writes in much more detail, if you're modifying folio contents (and
then dirtying a folio), you're supposed to grab folio pin which should
among other things prevent the reclaim of fs private metadata. At least
that was one of design ideas behind folio pins. Maybe something got broken
or there are paths we missed that modify folios but before coming up with a
different mechanism I'd like to understand why the current scheme doesn't
work...

> What happens if any filemap_release_folio() runs (and succeeds) between
> the initial dirtying (plus eventually writeback) and the write to the
> folio completes? Welp, it's unpredictable. ext4 for example will
> WARN_ONCE, and likely drop data (see ext4_dirty_folio()).
> 
> So, what can we do about it? It's complicated, hence why this is an RFC.
> For the possible solutions:
>  - ->dirty_folio() attaching this FS information itself is not really
>    possible in many cases. ->dirty_folio() can't block, nor is it even
>    guaranteed to hold the folio lock while being called.
>  - Can pincount help? Kind of. Things like folio_maybe_dma_pinned() are
>    rough, and don't deal with the usage of get_user_pages(FOLL_WRITE).
>    pincount itself isn't available in the common order-0 case, and not
>    available on order-1 as well on 32-bit, but who cares about that^W^W^W^W^W
>  - Could get_user_pages() ban FOLL_WRITE? Mayhaps. I would not be
>    opposed to that, but that's probably a larger change than ideal for stable,
>    and I'm not familiar enough with GUP requirements to decide to go that way.
>    This would require migrating all FOLL_WRITE users to
>    pin_user_pages().
>  - Can the whole system be reworked? Probably, but not for stable.
> 
> This patch series is really rough but kind-of works. Instead of using
> folio_maybe_dma_pinned(), which only interacts with pin_user_pages(), I
> introduce a new helper that helps places deal with the folio refcount
> directly. In that case, we can also deal with GUP. On the other end,
> moar problems:
>  - NFS private data itself takes refs on folios. Now private data (that
>    we could perhaps release if only we tried) is keeping us from
>    releasing that same data. What?
>  - ext4 data=journal has some funky usage of buffer_heads. Data journalled
>    filesystems will not, in any way, dirty BHs. Instead it will,
>    *only if it was DMA pinned*, set the checked flag. ext4 skips
>    dropping those buffers if the checked flag is set.

Yes, that code is funky and there's a big comment in front of
ext4_journalled_dirty_folio() trying to explain what's going on. We
attach folio buffers to the transaction on ->page_mkwrite. When the
transaction commits, we must writeprotect the folio again to be notified
about next write so that we can attached buffers to the next transaction.
But what will you do with pins and users modifying folios through them? You
can't just "writeprotect" against an existing pin. So we just note with
folio_set_checked() that this folio has newer data than what is in the
journal and then in a more relaxed context, we do the journaling dance and
record the updated data in the journal. But you don't have to worry about
this too much. Ted plans to rip out data=journal mode in the near future
and then this will go away.

>  - ext4 move_extents seems to have suspicious usage of
>    filemap_release_folio() as well.

Yeah, that whole code is hairy and I agree these calls are probably
problematic.  We should hold invalidate_locks over the whole operation and
should bail if any of the folios has a pin before calling into
filemap_release_folio().

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

