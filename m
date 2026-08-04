Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9DA1C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 17:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 569F46B00FB; Tue,  4 Aug 2026 13:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51A706B00FC; Tue,  4 Aug 2026 13:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB5B6B00FF; Tue,  4 Aug 2026 13:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DCB56B00FB
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:04:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5EC9D1A024E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:04:21 +0000 (UTC)
X-FDA: 85064210322.29.CF9EB25
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id AA0A240014
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:04:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NzP7nDte;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="0I8ng/Lb";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JcfVmEHS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ACZaZmlW;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785863059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5v7MkDI4Dtpq/Qliw3bpPtxAQ4VzKqgcoQOQ2I8B4A=;
	b=SOpbduY+f3GElAlno2DUQ3YdINd8LOw9GbeUuNeDbqQ/yOpNbY1LDcY7J8QFN9aD+IyA0J
	dA6310sozWcl9yOUDa7yC10y/OmeALFr7ooXXG4n5zJkQ+KPO5XkAWfoOGQsLd1+gIlqja
	18tHG7WKAjMSYXbFp92jWm+K0nNdhTo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785863059;
	b=A0B9+bg8Mvvj07vq8+r6zKiK7rYmMby9RK2rnicI7JWhvrFqxiMAXX4VblxI5Eozubqbco
	C7IH/cH/WFjlNohJsJ/s4SgYArhgpwqxtvG7MKknwo8ea4ltRAz8ltDFjbRoYqk43/8+i2
	TzanifZTzlPRdV4zB0Z1LZuUN1kov5g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NzP7nDte;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="0I8ng/Lb";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JcfVmEHS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ACZaZmlW;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 834C37F9C0;
	Tue,  4 Aug 2026 17:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785863052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+5v7MkDI4Dtpq/Qliw3bpPtxAQ4VzKqgcoQOQ2I8B4A=;
	b=NzP7nDtelMe+b+taflIEH1Ih7EA+zpoaRjoHxBaRJg4zRkipq6bc5B+Qtlij/L0b5HdzX7
	dklukd4c/qkMwnBiQmBsZnhHpUk/Z+iDNomLyEShRjrHbMNfNW4mT4bcApJdri/KWsiswu
	mI4GxjZmNQyM/SRbX5Z0o8wqarNJ12Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785863052;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+5v7MkDI4Dtpq/Qliw3bpPtxAQ4VzKqgcoQOQ2I8B4A=;
	b=0I8ng/Lb6ZboK95ZUQpPJxJUIWJ1vDVgwjOkNHKh+nbd/uUPb9jQxNimxSvW8CEWTQDG+Y
	1OT2iULKP+GXDlBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785863048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+5v7MkDI4Dtpq/Qliw3bpPtxAQ4VzKqgcoQOQ2I8B4A=;
	b=JcfVmEHSRj0suLTD08CtW028Ianxbe8YUbG6aqBAK7sSaVNnYXuJQ3MN4/fiOwiwMvJTr+
	fewzRc+rw7H3AQo2s57kMiRIFWNy0obiW3ukVmnHdUWmfVxTtX5qGw7E2RBn+sMQKvOi5e
	jesn+3ZJ7OOXQDG7Z5M2+VzlLnE9sHk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785863048;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+5v7MkDI4Dtpq/Qliw3bpPtxAQ4VzKqgcoQOQ2I8B4A=;
	b=ACZaZmlW7Js3yZLwzUjecV7cs2WuHQYbJZx/VOwQikbrXC2XRa+qQYJmWNzZ/f8xHiVtCM
	Y/+g0pEvgZY6MJBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 732CD779BB;
	Tue,  4 Aug 2026 17:04:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RbIYHIgbcmpQYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 04 Aug 2026 17:04:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 14D26A12F2; Tue, 04 Aug 2026 19:04:08 +0200 (CEST)
Date: Tue, 4 Aug 2026 19:04:08 +0200
From: Jan Kara <jack@suse.cz>
To: Zi Yan <ziy@nvidia.com>
Cc: Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC 07/14] fs/erofs: mm/pagemap: add
 readahead_folio_reverse() to avoid folio->private
Message-ID: <2evaxdu6cobpnzzer3y7fsrqvmtmhj7gm3e5buebdaw564igx6@7bs5enipxnpx>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-7-142c97ba3562@nvidia.com>
 <332rknj4vo3cfhvfhhlf6pvg37s3lbrnzbbnv4swa6gctsiu6a@ndotgokvnglc>
 <DKFGTVA0XD01.OZYNYUOU9FTX@nvidia.com>
 <huzyeqj6a57nbcqc23v6f6rdhkob5552fcwy4mlrsagycqi4rz@ggsapkumc2gq>
 <DKGA508ERSYM.26RBD4HYM1SL8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKGA508ERSYM.26RBD4HYM1SL8@nvidia.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AA0A240014
X-Stat-Signature: 5exdwtqdc3y6xqzksy74ym7cw4f3zfuc
X-Rspam-User: 
X-HE-Tag: 1785863058-104144
X-HE-Meta: U2FsdGVkX1+dGcivIoEb9QnSkbFXLS0mTDIuQgcF14PB2QUTLw1E+oG8pqaawyrPFQFa6DyiEOXl/ihS+Dpwu48VHG+L39arc+/DrfUlD5+IosCuPwOHtqTqMZ4cJKNqhBebbpKfrSI+pP5Ry95QuW99iInuEcnGwENfLhWF/njBfqIiX4wehEmfaHdHaxZ6Ta2YK7dSQqafeiLlTWPvlf4ArSwBhVLvL0fgEj51Osb5F57HlHj9kGGtkKKehbJE6pNTVhXZaVjHapihZtB1HVLc8wYB8/iWMVzITpA/Af+NBzMJEZMwhooxfNzeRwY1gYkDFU4DRaIKB0Im6Gv7YAgAVUnngmTdNm7Zq9DH7HAdiV7Iid6PpPNK5dGjYAvuwIv+kkINAQ6WGd59IEZcI89RMB4rkCHKQ+tRP2mXLBsblMdLz9q2wkWMWjAfF/cRDwkFeCZxVUzLvk1Ee3yRga9XLJl3OnUud0xUIqS7SlZmzSoGnyGs/u2NSy7btXaT261QSlIb6Bi8nHw2FavVv0UCh5rN7BjPFTn9c8CtZqhpnj+mlAV4zCyoSqVEol1UY+U1mrHwvyKVmkUrw5EJeVvBty5g9O6CjL6EyQUBUpBm8WQrX5SxoAxIiUurYfz1FGyH2LTFfP9vBiNwkU+ZBT9O/BlxCEAwjR+fmcmyiVTwAijw4MH2mpVB0BJi0VqyfJdgms+phqB4ydmdkaoDseOkcFBQaN9/kCkhu8Kgi1wAYjrZ0Pn8d4D+8R9Py1ewR+wBtXmtJxFXHcVnJH/H+pwCj9PGy/jrssYYAdhrehZpPIMm+o+g3iZzaNpsJ0wM/o006BO/HAgiI1YocnXaVtd8nRAJTIbgabpNPwr1bzsP4bnKGucZlaYb849OA6kXMO68qs/h/8+FZ9cpI3g6pEEL0TKrfxD5ULe/1jBPP5HurS1M4GshZEkaWkn5LgheLj1AmlmG3Gy5vra5FWZ
 B/2wjdkQ
 79TOiTUMf6Bpq0c2XOlfus+hmQDYXwXfDWG45hxzdmIY4YfArfXMnpUtTsaIUZIIKrtRtAFjSEv1hjsgKTBvrkAUfAY2DUH2W1dCYHMbZqV03BC8LopMuTqMOxCeBQjnoN0W1jDmU4CDOBmZ4NnJHWo2YPSPPOEUlSGR0m6wsSj9ybCtG5fpQjB2jozr7LDJgGC1SBrbT6yeC7iuDPUiSgYUbQalRTVAhWjovZEdT3XvSVnSN1uj8lhRy7oS0Od1pbS8stXzshF/k9S8iMwexSWJ3InPU6c059ibOcTiyIGXUNta2k3350NSHuBckXrFcrir4JVteU3mPjjJmgTy3fRUNw/gQWzdFJDOwzSb6c8tCUq6B0wnmZ+qaIT0HISSAerJAJkkV5Y7vueU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 04-08-26 11:54:41, Zi Yan wrote:
> On Tue Aug 4, 2026 at 5:32 AM EDT, Jan Kara wrote:
> > On Mon 03-08-26 12:56:36, Zi Yan wrote:
> >> On Mon Aug 3, 2026 at 5:54 AM EDT, Jan Kara wrote:
> >> > On Fri 31-07-26 22:13:30, Zi Yan wrote:
> >> >> erofs needs to traverse readahead folios in reverse order to achieve
> >> >> maximum performance by
> >> >> 1. reading all folios from readahead_folio();
> >> >> 2. storing the prior folio pointer in folio->private;
> >> >> 3. traverse from the last folio to the first one.
> >> >> 
> >> >> Add readahead_folio_reverse() to achieve the same function without using
> >> >> folio->private.
> >> >> 
> >> >> It prepares for a future commit that replaces PG_private checks with
> >> >> !folio->private checks. After switching the checks, erofs's use of
> >> >> folio->private without bumping folio refcount can cause unexpected
> >> >> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
> >> >> reachable.
> 
> <snip>
> 
> >> 
> >> The below is what I come up with. I did not add a bool to
> >> readahead_control, since I think that is the decision of caller of
> >> __readahead_advance(). But let me know if you disagree.
> >
> > The reason why I wanted bool in readahead_control is that if some code
> > ends up mixing readahead_folio() with readahead_folio_last() things will
> > get confused (because __readahead_advance() really wants to skip the batch
> > returned from the *previous* call to readahead_folio[_last]()). With the
> > bool in rac, even mixed use will properly advance the state of the
> > readahead_control. I don't think mixed use is very realistic (at this
> > point at least) so I'm ok with leaving that for later if you don't like it.
> 
> Got it. I am trying to figure out your mental model of how the mix of
> readahead_folio() and readahead_folio_last() works with the bool inside
> ractl. By looking at readahead_folio_last() code, it is almost the same
> as readahead_folio() with __readahead_folio() inlined
> (__readahead_folio() is only used by readahead_folio(), so the inline
> can happen without any issue). As a result, we can get rid of
> readahead_folio_last(), add set_readahead_direction() to set the
> embedded bool read_from_head, and use readahead_folio() only. This
> removes redundant code in readahead_folio_last(). One thing I am not
> certain is whether we want to
> 
> 1. use set_readahead_direction() explicit and warn readahead_folio() if
> read_from_head is not initialized, or
> 
> 2. set read_from_head to true by default, so that only erofs needs to
> call set_readahead_direction() to change read_from_head.
> 
> The former is less confusing but changes how readahead_folio() works;
> the latter is simpler but implicit read_from_head state might confuse
> people at some point.

My idea was: readahead_folio() will call __readahead_advance() and then set
rac->forward = true. readahead_folio_last() will call __readahead_advance()
and set rac->forward = false. __readahead_advance() advances from beginning
/ end based on rac->_forward value.

								Honza


> > Also I have some minor comments below.
> >
> >> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
> >> index b59f2745a8e72..23f423c22ac8c 100644
> >> --- a/fs/erofs/zdata.c
> >> +++ b/fs/erofs/zdata.c
> >> @@ -1908,8 +1908,8 @@ static void z_erofs_readahead(struct readahead_control *rac)
> >>  	trace_erofs_readahead(realinode, readahead_index(rac), nrpages, false);
> >>  	z_erofs_pcluster_readmore(&f, rac, true);
> >>  
> >> -	/* traverse in reverse order for best metadata I/O performance */
> >> -	while ((folio = readahead_folio_reverse(rac))) {
> >> +	/* traverse from last to first for best metadata I/O performance */
> >> +	while ((folio = readahead_folio_last(rac))) {
> >>  		err = z_erofs_scan_folio(&f, folio, true);
> >>  		if (err && err != -EINTR)
> >>  			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu",
> >> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> >> index 5ca5aa365f319..2cc3de5594518 100644
> >> --- a/include/linux/pagemap.h
> >> +++ b/include/linux/pagemap.h
> >> @@ -1510,13 +1510,21 @@ void page_cache_async_readahead(struct address_space *mapping,
> >>  	page_cache_async_ra(&ractl, folio, req_count);
> >>  }
> >>  
> >> +static inline void __readahead_advance(struct readahead_control *rac,
> >> +		bool read_from_head)
> >> +{
> >> +	if (read_from_head)
> >> +		rac->_index += rac->_batch_count;
> >> +
> >> +	rac->_nr_pages -= rac->_batch_count;
> >> +}
> >
> > Maybe we can add:
> >
> > 	rac->_batch_count = 0;
> >
> > as well since after the advance the _batch_count isn't valid anymore? We
> > can then also remove it from the callers.
> 
> Yes, for __readahead_batch(), _batch_count is zeroed right after. For
> __readahead_folio() and readahead_folio_last(), _batch_count is either
> zeroed or overwritten by folio_nr_pages() before any use.
> 
> >
> >> +
> >>  static inline struct folio *__readahead_folio(struct readahead_control *ractl)
> >>  {
> >> -	struct folio *folio;
> >> +	struct folio *folio = NULL;
> >
> > Not sure why this initialization got here...
> 
> Will remove it. It is some leftover during my development. Thank you for
> pointing it out.
> 
> >
> >>  
> >>  	BUG_ON(ractl->_batch_count > ractl->_nr_pages);
> >> -	ractl->_nr_pages -= ractl->_batch_count;
> >> -	ractl->_index += ractl->_batch_count;
> >> +	__readahead_advance(ractl, /* read_from_head= */ true);
> > 				   ^^^^
> > This is not really a kernel style :), please delete this comment. I'm ok with
> > pure false/true here - it is an internal helper used in few places. If
> > things get wider use, we tend to switch to 'unsigned flags' with explicit
> > flag names to ease code reading. But that's not the case here.
> 
> We did this in some MM code. I will delete the comment like you
> suggested.
> 
> <snip>
> 
> >> @@ -1583,11 +1594,10 @@ static inline unsigned int __readahead_batch(struct readahead_control *rac,
> >>  {
> >>  	unsigned int i = 0;
> >>  	XA_STATE(xas, &rac->mapping->i_pages, 0);
> >> -	struct folio *folio;
> >> +	struct folio *folio = NULL;
> >
> > Again not sure why this initialization got here...
> 
> Will remove.
> 
> -- 
> Best Regards,
> Yan, Zi
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

