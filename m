Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28EBCCD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5925B6B008C; Wed, 13 May 2026 05:26:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A5C6B0092; Wed, 13 May 2026 05:26:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4589B6B0093; Wed, 13 May 2026 05:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3724B6B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:26:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D34514047F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:26:22 +0000 (UTC)
X-FDA: 84761865804.12.316F03B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 69C14140003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:26:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="B/MeBwzn";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wolDbEnS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="B/MeBwzn";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wolDbEnS;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778664380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XKMrjHaSnPAmYEI6gQbk/Eny6irDx2lJWYL45Uo3FA0=;
	b=GaQ4HptyWQDb/tHZvMX+kZdwqyKtyf6cOIhInPsZkA/gooS0XI10eXMvQRhwpwpo+QVpkq
	t9YJUqqhJDuHhhEsaLlOE7+8s8IQI+ux2lIuR63DA6uK4DEaw2fkA2XQjDYDqHFFz6QdSj
	KMFGbYutP8gCdXfnzVtktvkHgn0TaSk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="B/MeBwzn";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wolDbEnS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="B/MeBwzn";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wolDbEnS;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778664380; a=rsa-sha256;
	cv=none;
	b=fs2bolzWPB072V9Oa/cMxDmc8BJn7as2XD6r00S4HZUr7EqFrzcKBsJNLv2wariiWagU7Z
	BMWZchgzkclxnidOLY/zEqusk8Ptbm3pCOECvGwlGzf9rbhREOeruVMfyCjDLmJnBLikh/
	i+ag6Qt+X2ivqWTxurX3Tw/lPRbsygQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 99D635CFB0;
	Wed, 13 May 2026 09:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778664378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XKMrjHaSnPAmYEI6gQbk/Eny6irDx2lJWYL45Uo3FA0=;
	b=B/MeBwznYOdHc/hhIMg9XPMYhyMqz+Sdb6grPppKJNPaZvkz8i2c4x+aWC8+LAgaO/FZJx
	nge+82TDRbcL6XHLe3AW3Iunic2rZc5jcWj8yGXITKqSeHN4etaxPrPR5mgcEq1JovUvq/
	yaQsxHnoe1YsdisEooOv9J/luv5Pafw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778664378;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XKMrjHaSnPAmYEI6gQbk/Eny6irDx2lJWYL45Uo3FA0=;
	b=wolDbEnSGba8O5U4zO9fMtpF8uA3r+9Pj4N+aOadTPVOPcZbdRgl5zvxXLRiVAHYya/8DM
	E1U/WxDRgYtsPKBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778664378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XKMrjHaSnPAmYEI6gQbk/Eny6irDx2lJWYL45Uo3FA0=;
	b=B/MeBwznYOdHc/hhIMg9XPMYhyMqz+Sdb6grPppKJNPaZvkz8i2c4x+aWC8+LAgaO/FZJx
	nge+82TDRbcL6XHLe3AW3Iunic2rZc5jcWj8yGXITKqSeHN4etaxPrPR5mgcEq1JovUvq/
	yaQsxHnoe1YsdisEooOv9J/luv5Pafw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778664378;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XKMrjHaSnPAmYEI6gQbk/Eny6irDx2lJWYL45Uo3FA0=;
	b=wolDbEnSGba8O5U4zO9fMtpF8uA3r+9Pj4N+aOadTPVOPcZbdRgl5zvxXLRiVAHYya/8DM
	E1U/WxDRgYtsPKBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9893E593A9;
	Wed, 13 May 2026 09:26:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id A7zjIbdDBGoVZwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 13 May 2026 09:26:15 +0000
Date: Wed, 13 May 2026 10:26:13 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Dragos Tatulea <dtatulea@nvidia.com>, 
	Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel_team@skhynix.com, 
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net, 
	kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com, sdf@fomichev.me, 
	saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com, 
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, horms@kernel.org, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org, 
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com, 
	baolin.wang@linux.alibaba.com, almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com, 
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, dw@davidwei.uk, 
	ap420073@gmail.com
Subject: Re: [PATCH v4] mm: introduce a new page type for page pool in page
 type
Message-ID: <agRB2QTbzceRgpzX@pedro-suse>
References: <20260224051347.19621-1-byungchul@sk.com>
 <982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com>
 <4af19eda-c29c-4302-92d5-c0915267fc0c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4af19eda-c29c-4302-92d5-c0915267fc0c@kernel.org>
X-Stat-Signature: airdjhoqku5f9scg3m369y7i6uyaterk
X-Rspamd-Queue-Id: 69C14140003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778664380-403532
X-HE-Meta: U2FsdGVkX1/+TAeIW/DcnGTZxtd8VtkOZJImK67BsyXC/73TgeKf7WOx5FG6xhInsmy/CqnxCckhNFPoQXWTw+ansfgEuOJW2Y1jzUPBivTZQf5URuU68Bdd8O4Y+dOrLCs8yKUVErylTA1G4Z3+n+o9/5PT18GyngHN0TBsyC6vGIOGoYevMH0aQ8TRZiy3NtrGML2z0UotkFmF6rmX3e/B/lLRoyOTRzNqT8h6wqhVf9h+Qyt1Oh5dDEAeAAMhBMcw0ov01Bsu/ALr4W9Tjk0v8gA1U9boNlhPBtQoRnzaHc8Acq4bnOhhXHG2BtqTBmvJWZM/jdldYia1DiV3ZAcZsB0ZgqhKYJnVDju+IPdLqrEOIY51tLsr1OVW3FmarcHOmJNNGWoPQ5jnEUbGmA1RaP9vHsGwTzVLDdzVHjnaIZUjZNRcvfSndHTeOpMxYfRvw8MQ9+kF6dHt3q37hbioQCLTYw8Ih92/k0GRg2HX+PzwiOtlS207chO44KqggAPX360mwPQ1hKPV8csxhGVR6Ikd1YmBF8FXk9IzqDAZ/E07KxpYs9zvFeTQbsRQ9futy+VLqC3oHpSww7fatw9MQP7uNFA5Q9D62a1k2cNXP2AckODuWljdCoUn9jKP3BZCq4tIu/y8V6oLhcPUTF90Ddy7ioCwCWveb2LYFQGYfsTGBRMwcq5oMmQCsovQn7ygXm5jwP8SGLN/QMfZJy7lI4TWajH9KJes3rjIn/QXekhLgEQOW2TZ9c7LEF40aSHlPsKES3rgV9K/Eh+fwYfVAYK2ne8iCFNThicjplScZrVIwN6Nv+Dbl7yKRpKpriWC+DbOJ6ZoCI0Woeo8g0R7QkcxjalNfbe5w/UzX9B4owIK6pX5omZMHM4KatQXMm818zqbv050hBbfanQ6/j5I7CTASXqHKca9HsIleOrufRNseXZPD6+5wz1BrY3RTMtzAgxY2/kyaKu88Z1
 kAuOae3X
 ShqF7lnytIS9OhaElbMgTwr8Yl2JVRBOMVlbU3buzMsXiwCfjRm4w1VoV40TSqOP6vWsbO0zFw0PLHWVpTnnYqp0+pjDgh0S/cTWdQ5YyoB31201Cfr3DjE88nggdn+509LsR4lj1Qh7mzgbeHp7f9e8ctDPh+ZaqQM9MUyPSEjSFmSByeFhyXsLJbFUUWitomnhGir5Ze0ehDbP8+lqi6pWKJcH60iHtKgZbZAbEvVGrich/LQuBgCz25hXHGec5ZugqZ32UQs2slTAHOhA1ITk/qNIQSKeJLxgXnQHolBCHmuqIE0zA9gPukzA/rOqeZTf3VD/q50ViL50/btdH6EN/QfuQvUJ6euCussEBz4GnVkXRsZIYQvWJ5h+IQM617+zpvpAj8F6HAZ+XbfRBjfv3rZMYVVwVFxqxiWavuiYJI5vKHCBUEci6AFowLpzOMLhhqiocry6Q5ls98Xm5w6uoGG+xpzJ6TYvYbCuhVAj+HdcuiVZCOKy/OCL98EttD9659c0rlhtfEtjcGoPerN4S29JZSHjFkMRaCmPYWBpyCesWwW+cRABgjCzEzVNlVinKnEf3dSQwrnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 11:12:43AM +0200, Vlastimil Babka (SUSE) wrote:
> On 5/13/26 11:00, Dragos Tatulea wrote:
> > 
> > 
> > On 24.02.26 06:13, Byungchul Park wrote:
> >> Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
> >> determine if a page belongs to a page pool.  However, with the planned
> >> removal of @pp_magic, we should instead leverage the page_type in struct
> >> page, such as PGTY_netpp, for this purpose.
> >> 
> >> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> >> and __ClearPageNetpp() instead, and remove the existing APIs accessing
> >> @pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> >> netmem_clear_pp_magic().
> >> 
> >> Plus, add @page_type to struct net_iov at the same offset as struct page
> >> so as to use the page_type APIs for struct net_iov as well.  While at it,
> >> reorder @type and @owner in struct net_iov to avoid a hole and
> >> increasing the struct size.
> >> 
> >> This work was inspired by the following link:
> >> 
> >>   https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
> >> 
> >> While at it, move the sanity check for page pool to on the free path.
> >> 
> >> Suggested-by: David Hildenbrand <david@redhat.com>
> >> Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
> >> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> >> Signed-off-by: Byungchul Park <byungchul@sk.com>
> >> Acked-by: David Hildenbrand <david@redhat.com>
> >> Acked-by: Zi Yan <ziy@nvidia.com>
> >> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> >> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> >> ---
> > 
> > Seems like this patch broke tcp_mmap because
> > validate_page_before_insert() returns -EINVAL due
> > to a page having a type. Here's the full flow:
> > 
> > getsockopt(TCP_ZEROCOPY_RECEIVE) returns -EINVAL because of the
> > below flow in the kernel:
> > 
> > tcp_zerocopy_receive()
> > -> tcp_zerocopy_vm_insert_batch()
> >   -> vm_insert_pages()
> >     -> insert_pages()
> >       -> insert_page_in_batch_locked()
> >         -> validate_page_before_insert() returns -EINVAL
> >            because page_has_type(page) is now true.
> > 
> > The patch below fixes the issue. But is this a valid fix?
> 
> Hmm the check traces back to commit 0ee930e6cafa0 "mm/memory.c: prevent
> mapping typed pages to userspace"
> 
> > Pages which use page_type must never be mapped to userspace as it would
> > destroy their page type.  Add an explicit check for this instead of
> > assuming that kernel drivers always get this right.
> 
> So uh, this doesn't look good I think.

Yep, you fundamentally can't map a page with a type as page type aliases with
mapcount. Even with the given diff, just mapping it will increment the mapcount
and wreak havoc. I think we need to revert this patch for now.

I'm not sure what the long term plan for this would be. If page types are moved
to memdesc types, then the two stop colliding and that could work. I don't know
if that's Willy's plan, however.

(then there's the other question: are page pool pages really folios? not really.
they are mappable, but they aren't part of the page cache, or anon, nor are
they in the LRU or have rmap capabilities. perhaps we need a different memdesc
for those. we're one step away from reinventing class polymorphism from first
principles ;)

> 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index ea6568571131..4cb12673f450 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -2326,7 +2326,7 @@ static int validate_page_before_insert(struct vm_area_struct *vma,
> >                         return -EINVAL;
> >                 return 0;
> >         }
> > -       if (folio_test_anon(folio) || page_has_type(page))
> > +       if (folio_test_anon(folio) || (page_has_type(page) && !PageNetpp(page)))
> >                 return -EINVAL;
> >         flush_dcache_folio(folio);
> >         return 0;
> > 
> > Thanks,
> > Dragos
> > 
> > 
> 
> 

-- 
Pedro

