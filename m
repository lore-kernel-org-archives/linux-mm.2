Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51011C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 09:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDBA18E0006; Wed, 30 Jul 2025 05:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8C2C8E0001; Wed, 30 Jul 2025 05:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7B538E0006; Wed, 30 Jul 2025 05:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B79A38E0001
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:26:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E0A8158BAC
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:26:22 +0000 (UTC)
X-FDA: 83720400204.03.D94835F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id AD28740012
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:26:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZLmdn6Ke;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="hYn+v/AS";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZLmdn6Ke;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="hYn+v/AS";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753867581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PwwSk2G3t3g+z+exLv/8KSZMKkvH9vcoZU1kIker1MQ=;
	b=F09XMn49ENKK3MtVsV/A1Hhs3viceYQ5oNaruAxhwSWi8UnlBDBlTGU0msaFQZ1zuq7vek
	yI/0vleDXgauUvpaOv4w4+5/F96uctr2xNpe6GwSVAEVLSUq5dFyTYG4bsPjbRYaf/H5lu
	7Uhy1chZbDpiPA+/SdNA9TGhK8aZfUw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753867581; a=rsa-sha256;
	cv=none;
	b=R82hNmZed8N9hx6cNL4X++JjfFOpHobWqUjRYkQn1V8rcmsE2iqEwp5ZMAE7tZkjradPbx
	e2XM4/hnn3X5Z/C/Lc0UbXsy833rVy+9zNG1Z2+PnBmmtDIexbA5XBRrMc+imBo1Y5ALZn
	3TOkccWt679spkT2PhMJI8Us7yc9Wv8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZLmdn6Ke;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="hYn+v/AS";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZLmdn6Ke;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="hYn+v/AS";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F31741F45A;
	Wed, 30 Jul 2025 09:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753867579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PwwSk2G3t3g+z+exLv/8KSZMKkvH9vcoZU1kIker1MQ=;
	b=ZLmdn6KegNLRzn+dBx89gzlvx3N85If5zqoX3jHJv/5IxACROsLEdUumVIkRVA+qfzpztX
	llTr1qluDQxRaUlsR6kyh1U/XzPdd1H7TiWrXD77yNnjpu92kgcjRv3+jV5tfv9asZF5Qz
	YQDFeqGDy0vnCXKJkSiLRysSmse6Q0w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753867579;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PwwSk2G3t3g+z+exLv/8KSZMKkvH9vcoZU1kIker1MQ=;
	b=hYn+v/ASBkF5r+OUfvChwnoKZ4xNlRwApU8Dh9pNJIJcPp1ffL7v7NxnFmSGQTbMMcma1v
	OSpQhY2+thaekjAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753867579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PwwSk2G3t3g+z+exLv/8KSZMKkvH9vcoZU1kIker1MQ=;
	b=ZLmdn6KegNLRzn+dBx89gzlvx3N85If5zqoX3jHJv/5IxACROsLEdUumVIkRVA+qfzpztX
	llTr1qluDQxRaUlsR6kyh1U/XzPdd1H7TiWrXD77yNnjpu92kgcjRv3+jV5tfv9asZF5Qz
	YQDFeqGDy0vnCXKJkSiLRysSmse6Q0w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753867579;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PwwSk2G3t3g+z+exLv/8KSZMKkvH9vcoZU1kIker1MQ=;
	b=hYn+v/ASBkF5r+OUfvChwnoKZ4xNlRwApU8Dh9pNJIJcPp1ffL7v7NxnFmSGQTbMMcma1v
	OSpQhY2+thaekjAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1D61E13942;
	Wed, 30 Jul 2025 09:26:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id De7RAzrliWjwaAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 30 Jul 2025 09:26:18 +0000
Date: Wed, 30 Jul 2025 10:26:16 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Bernard Metzler <bernard.metzler@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Jakub Kicinski <kuba@kernel.org>, 
	David Howells <dhowells@redhat.com>, Tom Talpey <tom@talpey.com>, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org, 
	stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v2] RDMA/siw: Fix the sendmsg byte count in
 siw_tcp_sendpages
Message-ID: <x43xlqzuher54k3j4iwkos36jz5qkhtgxw4zh52j5cz6l2spzw@yips5h4liqbi>
References: <20250729120348.495568-1-pfalcato@suse.de>
 <8fad6c00-9c15-4315-a8c5-b8eac4281757@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fad6c00-9c15-4315-a8c5-b8eac4281757@linux.dev>
X-Stat-Signature: cufpe95j19cphmox6576eodf9owmmnux
X-Rspamd-Queue-Id: AD28740012
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753867580-216936
X-HE-Meta: U2FsdGVkX1+xFp/9UoYKah0/if3mJAJpY0yuGPa6nksLx4N8wy3jrv/kDKgaDZ3O1ClH2tQglS3RRorHFobS7wRMsY8r/bbkQjoVP35Qr1q07yj23fAq+3WLl49TLtQgEULIgO0GDAMboFAlnHYpkZ/FDUeQYJmikUe4MjdkqAiFP5ObA3mNVL1SzXSwN3jBPXrILHxPTOcfe4PM3N5uzxxU6xs+zoPOcYQABMZgtZlSPESsVs4diBZjF8eMd355geEWI3ovQxZ6pbYJ2Zem7LLsTxoRUXsKuTeJX0RV8DUohfEFmQBIj/Xm/yOMskiM3BmKMERht0aoxndE8z3+7fmGiMyGGKuwsmA1OevVh1E2bqi/6d+mWOEb56axJRQmZioebHLsfJEsIojHa3AfLKJyZxU7fGCJoCpVZirc+yxFwBslgqphLJ1IG6c0w9t0PtL7xcR2Q9SAE/ohBdL6E+kvia436kaWZTVJIYzFdxUaxqh0YS80vsRUMnQNNsAAjeLNtNlUWQYZ0OxJ6TakeoWeEU4cghO4de188Dpq2sVyr+uUFmh+f6cr5FSgAjdfaBxEeQASPIBPmpgJ6M1pC9tefLgkhlSYBwJaGNztSmh53s3K542sNiFpblCa2p3v9Ou3AWTlVae9IadDNSwby7mxe7c/cR2aQgU/CKKZ+bDQl18T43JtH+JhwnbO1l3YRcVecsJ+xElxk+vb24Q2DlAbT13Bs1YPVcSZVMHS1ML6/GS1zalUYwvFZ6VcCQ0jahwgMRlMB1iralC3mwxD7tq/oGp4YKTvGJPjUCjfyIEOp0yIPqr6pFq5uKuVUWo+lnDejJN9icIKthOfqPGmzSixSxuDSMZK0z0uL1brponPmFbqJPDdCiegD9XruXKg2lQqgtHqoJ3slu1kEM+3SVsbK2QUth8tfClGaugaAGOwHS9oQgONIA+BlG/PA5iahRmYyEBbjqmDMuuzbOv
 qGkY6jns
 tC3rtFZNG7ZISHuZZTVW+v0Kwx13HSFpJbG5sMCqBbIhlXhmP2svktKYByhtdGHl/DvougG+Z2GiWPoUhyH7TVDQ7o3SHF72VSYml4oxVri1OBKix7Dsz2FxYDQ/UpOCmjRuJVM8Ym2IGIy1FMU/POKby4VrhDd1KKmuTB7REb9Az58gff6o5qimK8hvopC9vlEU8t3AtZ/gqzhIF7vS8yZTN3Z3kLMjcsniq/AvOBOot2TuEfHRLOJde+fIl9BMnd151MG+6pjtu/2+ASdrCPW+DjAvQFfCrpyonzCIBpwnOsTdUDudTA8IpRhatvFpJ/wb26rXiXcPK8Fx0TO/3uEJB0/1Wv/ixzCr5rZyd9GNpFWPos+K/R0WcqR1We5WGCMcU56XxVZGNNsTUOvVeczsgwe9LTw1so+k2zmM7nKzFwCw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 08:53:02PM +0200, Bernard Metzler wrote:
> On 29.07.2025 14:03, Pedro Falcato wrote:
> > Ever since commit c2ff29e99a76 ("siw: Inline do_tcp_sendpages()"),
> > we have been doing this:
> > 
> > static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
> >                               size_t size)
> > [...]
> >          /* Calculate the number of bytes we need to push, for this page
> >           * specifically */
> >          size_t bytes = min_t(size_t, PAGE_SIZE - offset, size);
> >          /* If we can't splice it, then copy it in, as normal */
> >          if (!sendpage_ok(page[i]))
> >                  msg.msg_flags &= ~MSG_SPLICE_PAGES;
> >          /* Set the bvec pointing to the page, with len $bytes */
> >          bvec_set_page(&bvec, page[i], bytes, offset);
> >          /* Set the iter to $size, aka the size of the whole sendpages (!!!) */
> >          iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
> > try_page_again:
> >          lock_sock(sk);
> >          /* Sendmsg with $size size (!!!) */
> >          rv = tcp_sendmsg_locked(sk, &msg, size);
> > 
> > This means we've been sending oversized iov_iters and tcp_sendmsg calls
> > for a while. This has a been a benign bug because sendpage_ok() always
> > returned true. With the recent slab allocator changes being slowly
> > introduced into next (that disallow sendpage on large kmalloc
> > allocations), we have recently hit out-of-bounds crashes, due to slight
> > differences in iov_iter behavior between the MSG_SPLICE_PAGES and
> > "regular" copy paths:
> > 
> > (MSG_SPLICE_PAGES)
> > skb_splice_from_iter
> >    iov_iter_extract_pages
> >      iov_iter_extract_bvec_pages
> >        uses i->nr_segs to correctly stop in its tracks before OoB'ing everywhere
> >    skb_splice_from_iter gets a "short" read
> > 
> > (!MSG_SPLICE_PAGES)
> > skb_copy_to_page_nocache copy=iov_iter_count
> >   [...]
> >     copy_from_iter
> >          /* this doesn't help */
> >          if (unlikely(iter->count < len))
> >                  len = iter->count;
> >            iterate_bvec
> >              ... and we run off the bvecs
> > 
> > Fix this by properly setting the iov_iter's byte count, plus sending the
> > correct byte count to tcp_sendmsg_locked.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: c2ff29e99a76 ("siw: Inline do_tcp_sendpages()")
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Closes: https://lore.kernel.org/oe-lkp/202507220801.50a7210-lkp@intel.com
> > Reviewed-by: David Howells <dhowells@redhat.com>
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > ---
> > 
> > v2:
> >   - Add David Howells's Rb on the original patch
> >   - Remove the offset increment, since it's dead code
> > 
> >   drivers/infiniband/sw/siw/siw_qp_tx.c | 5 ++---
> >   1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
> > index 3a08f57d2211..f7dd32c6e5ba 100644
> > --- a/drivers/infiniband/sw/siw/siw_qp_tx.c
> > +++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
> > @@ -340,18 +340,17 @@ static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
> >   		if (!sendpage_ok(page[i]))
> >   			msg.msg_flags &= ~MSG_SPLICE_PAGES;
> >   		bvec_set_page(&bvec, page[i], bytes, offset);
> > -		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
> > +		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, bytes);
> >   try_page_again:
> >   		lock_sock(sk);
> > -		rv = tcp_sendmsg_locked(sk, &msg, size);
> > +		rv = tcp_sendmsg_locked(sk, &msg, bytes)
> >   		release_sock(sk);
> >   		if (rv > 0) {
> >   			size -= rv;
> >   			sent += rv;
> >   			if (rv != bytes) {
> > -				offset += rv;
> >   				bytes -= rv;
> >   				goto try_page_again;
> >   			}
> 
> Acked-by: Bernard Metzler <bernard.metzler@linux.dev>


Thanks!

Do you want to take the fix through your tree? Otherwise I suspect Vlastimil
could simply take it (and possibly resubmit the SLAB PR, which hasn't been
merged yet).

-- 
Pedro

