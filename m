Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B5A2CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C848E0012; Mon, 20 Oct 2025 09:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 664028E0002; Mon, 20 Oct 2025 09:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57A048E0012; Mon, 20 Oct 2025 09:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 458998E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:59:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DBCC9B686E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:59:45 +0000 (UTC)
X-FDA: 84018650730.28.FFE4F3A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7008440005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:59:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FQdkhRh4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sZ3Z4url;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DqBWEElY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Am1N2qnK;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760968783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HmmBnH8SaXShmttGIVhlHzTTaFEYyrDdxlkZ0RuRQR4=;
	b=M318jZB3VWkHP4IaLTBE4hM5FHzmVwVt8EEkun/h0svKKlhcw9d6Ih+4gUsYdd092Gvl9p
	oPjYwU2uIsy5CCKJXGzhKiH+60Llyz8a4H37etANhkygoccbKzN1S7AXYEEpJi70WM2Uff
	F1rP9oXmj2c6amzoExUh7mmWWPKwKB0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FQdkhRh4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sZ3Z4url;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DqBWEElY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Am1N2qnK;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760968783; a=rsa-sha256;
	cv=none;
	b=orq8e2cYb7tZrZO8rIjBrM6PJNCycpttnYPP39mSvHgcR1ViYAS6uDf69cO9FEK7xFcxIv
	GPShL7ffjJqsCcAWDQ2fUJ6fM/GAqYWVVkaEkACLJdqI/EMEmqLLt4XauOIynTtGfFrxge
	yK88m1zWmLpal4wcWWw14xUc48Q9qDc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B2F121F449;
	Mon, 20 Oct 2025 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760968777; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HmmBnH8SaXShmttGIVhlHzTTaFEYyrDdxlkZ0RuRQR4=;
	b=FQdkhRh4QvgfVUJRt2B9T8dfeTOjFnSMfLpX94GdcEEMr2Pvt4TJ2y8HCZ3xLW8SlCo5J3
	GGdSnOJ8RLS6oHbR6MdLHCPpsaBu4jBwOsGYxAxPXuFKrlfrBlR7cHbQnzEBdwoOO8fP3C
	MIKh99K0Z5lRvSG/LKlGiGvsWjP4KCc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760968777;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HmmBnH8SaXShmttGIVhlHzTTaFEYyrDdxlkZ0RuRQR4=;
	b=sZ3Z4urltaAQy3/wzDpnB159pgqUwC5GVizivDfXDuXJF4CrEWLGwfWmPEU+7fWalaRII7
	tFE6dVZIFACeKBAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760968773; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HmmBnH8SaXShmttGIVhlHzTTaFEYyrDdxlkZ0RuRQR4=;
	b=DqBWEElYvnvcjpRcxmCvkOjO4x2GNuawgcCE2nygLkKUwtzwl4GjMR5xfBzodD4ZccKM/r
	Tcd99bLtPNSiqM40emp5lHeKUNa7n1CIdDfxC3kmzInHh3JndZqXzvkX78ZQ6r5RZM29wS
	ImNUJl9ugPXh8VvCf4xxqAnwkzKbifY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760968773;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HmmBnH8SaXShmttGIVhlHzTTaFEYyrDdxlkZ0RuRQR4=;
	b=Am1N2qnK4Exp2HlXaXMXTh7+exhfTCHEBPIXXqW07kb92eLCghLQc30zY0Uof7h5rSk7dQ
	/7as+glrXJ2xScAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9B42913AAC;
	Mon, 20 Oct 2025 13:59:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G7viJUVA9mhjBwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 20 Oct 2025 13:59:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 16CBAA088E; Mon, 20 Oct 2025 15:59:33 +0200 (CEST)
Date: Mon, 20 Oct 2025 15:59:33 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Qu Wenruo <wqu@suse.com>, 
	linux-btrfs@vger.kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, 
	martin.petersen@oracle.com, jack@suse.com
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
Message-ID: <mciqzktudhier5d2wvjmh4odwqdszvbtcixbthiuuwrufrw3cj@5s2ffnffu4gc>
References: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
 <aPYIS5rDfXhNNDHP@infradead.org>
 <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
 <aPYgm3ey4eiFB4_o@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPYgm3ey4eiFB4_o@infradead.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 7008440005
X-Rspamd-Server: rspam03
X-Stat-Signature: rod14f3ii81mwnf8zi9gzisxe957nm15
X-HE-Tag: 1760968783-263327
X-HE-Meta: U2FsdGVkX1/0lyfcEPzIEwpdcmYC+645ZUPYjHjRtVbFFWRWtHJRNzWECseJ9xAhaXZwje2EZ6OyM37KD8PAJsiLks8x14sf7LJt5Rs/kB225BDLNoiSclZcKIqUd660c4kpXjLfwnivVcVtTNxMH3//1WC2j5P/OYFZL1Tzic4kqFrK+CG8n2VjCTmeW/zdH31gqeFI3x8I7gtKdcOnTgGx0u6ErSRSQAgDOnsozzakAKvKuT0xqtDDj3wIBEfPEj5l6Abir0i3zRN2tIRtRZbnmNy10qiI2soEPsgbZkrUnae9p1io3Uo/8XsCR3kYdKOPHhTf9Bnb7SR9BaOyPgJQMmdGLiI7h9BoG0j5DxaTECAcvAUXLTH4/v1t13LGEk+0va25g2Hu56IEYet1Eho4O9d1Z01D+Eh6XQ9ChYouDrZOC141td9aODvF6JkmveA0qGEeZIMVIaQGLpanQPE/+bUsjlQOADSwW9ewOIWAX06mqtoXC5UDPH42cS13+/6emENV8edl/2ZjaPVpPGuv44lWz6VuthFXyfdXQUSaXuYXi/OoQ3cfnF1MyFEL20T04Irvaaigu/JO/lYKE/0v8C7N7Z1K+crxAaLGPhm8Ju+OsskzQ1L/NP5VVdYE5m00kOfaZDkopXQMS2YQmFiZ+9G0qItXtP+OkACeM+GVX4vgFcRZLPWZtzWj5zKCqI5Y4jBYk2mYuGk+1X0aXa+m6kDnxjOx5NN78V6z6MPFDhcMiFgdpWxkKj+/dslWHTk1Rfdr6LCGjxD410jaUyGy2BFYUllBN3NqPTs15rL/gGwBjQ7oWZ82fYgEq45QyCf7ZIHlNW5h5kaIANvBZYpM+zgeJncwgwwU90QxlXpCB/F386Gpab4Xcyo0SVRYeUflhIHDBhmvGDeoqfxWdrjaOUXXvGfsoxsYdjuGAgogSnbyRXIEpkHFzDy5N7bM2KrhbgjKTZ+NLHqJd8q
 EuWGwn0j
 TgL8vITFyOlYwstvmliUyGwPLrKBV1lL6Nl4ZL51aagYVBgeCM7ydqJeKaO8mUh3UNQ+lO71tWPcKVLFPPnE4xYZF52pZwXeN5robhd752rY9fCfNg7VvmTi4wM0LGga+603kxn162C4tVSPbRr5m+eVlbi2nGN7hGJt+5UFefLHnFaB3SSUs8xUzHCLNjhd01HqYzvPRqlfb/lLdo5Y3ZI4MmoFf/wDOU/icpUAIJOZmyk3Y79xTDloDW+ebTZlGi1hwdlcsJzsLpca/5dsrDuG80A8L0C6ga8NrBnd3RX3U8sn4XE2Lp8yz+vafyxU03RMpJZhbuEb7k6G9p89lHK3i4wHxENqe/waEDlMXnmNor3LU6Fdz6kBwZJ9KfF+M38Z3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 20-10-25 04:44:27, Christoph Hellwig wrote:
> On Mon, Oct 20, 2025 at 01:16:39PM +0200, Jan Kara wrote:
> > Hmm, this is an interesting twist in the problems with pinned pages - so
> > far I was thinking about problems where pinned page cache page gets
> > modified (e.g. through DIO or RDMA) and this causes checksum failures if
> > it races with writeback. If I understand you right, now you are concerned
> > about a situation where some page is used as a buffer for direct IO write
> > / RDMA and it gets modified while the DMA is running which causes checksum
> > mismatch?
> 
> Really all of the above.  Even worse this can also happen for reads,
> e.g. when the parity or checksum is calculated in the user buffer.

OK.

> > Writeprotecting the buffer before the DIO starts isn't that hard
> > to do (although it has a non-trivial cost) but we don't have a mechanism to
> > make sure the page cannot be writeably mapped while it is pinned (and
> > avoiding that without introducing deadlocks would be *fun*).
> 
> Well, this goes back to the old idea of maybe bounce buffering in that
> case?

The idea was to bounce buffer the page we are writing back in case we spot
a long-term pin we cannot just wait for - hence bouncing should be rare.
But in this more general setting it is challenging to not bounce buffer for
every IO (in which case you'd be basically at performance of RWF_DONTCACHE
IO or perhaps worse so why bother?). Essentially if you hand out the real
page underlying the buffer for the IO, all other attemps to do IO to that
page have to block - bouncing is no longer an option because even with
bouncing the second IO we could still corrupt data of the first IO once we
copy to the final buffer. And if we'd block waiting for the first IO to
complete, userspace could construct deadlock cycles - like racing IO to
pages A, B with IO to pages B, A. So far I'm not sure about a sane way out
of this...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

