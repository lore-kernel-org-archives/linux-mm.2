Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 056F5CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 09:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1DB66B0088; Mon, 22 Jun 2026 05:26:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCEF36B008A; Mon, 22 Jun 2026 05:26:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABE4E6B008C; Mon, 22 Jun 2026 05:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 892416B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 05:26:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 147AD1405E1
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:26:23 +0000 (UTC)
X-FDA: 84907017846.17.87319DC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id BC85E10000C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:26:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CgfTfYOH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eKDzHnWl;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FB4GzeeA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nJzo8WJN;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782120381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=orwbBsy9A3Mw4ETnXQSohuB+yc1BDjfxHVYxLaRkDCg=;
	b=k5dmu9Zt11G9dxB+K58ailIav4Z6ckFF7y9CgWL+KzSRVNhCLMcdxgKphyz7KVpwer6mcS
	5t+WD/ZSHqeqQXjcSB0hw73tWoaJWN/HHE+cZNBQ1u79Uo0HvlMPq77iCC7gN1hCGxT3xb
	4ehZIDzWfSBPlPr3Nn199GIRz4qGCfM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782120381;
	b=GX/Webw3KE/lCmtqlFzXh1az1ux75EyB3X7VANxX8w8dXt9Pqo/qT9ebWFc7Lv+Nc5HvNa
	M8dIBC/AoHFtLTwIj57FShxBXKxKGHDU0ykKr4qKy2G9HQq9A7qj8vcSUWNB8O1srhhEtC
	qTmv3rCPsch1cvCThECMxKtJnzVbj7Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CgfTfYOH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eKDzHnWl;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FB4GzeeA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nJzo8WJN;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E923275B66;
	Mon, 22 Jun 2026 09:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782120379; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=orwbBsy9A3Mw4ETnXQSohuB+yc1BDjfxHVYxLaRkDCg=;
	b=CgfTfYOHzgCuAEDV6LZxxxGIEKT93w1A9JeIJ1CENppexvpWPFKJutv3ajSWJsJfU0FH64
	sHQccFX+Iicch9cGypsO4gZmzeTHJ9pBKyOI45z2Z8wHKWZynAJDUdjH6NlSHeyHUXOBzj
	fUo2jox0tWk0NUDAPLSh6fTWro94gec=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782120379;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=orwbBsy9A3Mw4ETnXQSohuB+yc1BDjfxHVYxLaRkDCg=;
	b=eKDzHnWlTd8E7gl331pvxrGGnSL+SLDtxZC44RBqoj/Vrk80/UfgRd9hrisd+Z/HdtHolA
	hOYnIqJ1ex4KOcDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782120378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=orwbBsy9A3Mw4ETnXQSohuB+yc1BDjfxHVYxLaRkDCg=;
	b=FB4GzeeAVTGqfX9cH62JAiufzhjfKjEcn5R3s7WJlHH1/xiIXkBviIcj2klEQuhjUbbH8m
	U0Tcd2oVGNnA/xymmyRevtgtRqkFKbyPWtjB3ePHf8ychf6MVNmYBlXSS1wrNGmBD9vmNX
	szaAnae507RvGUeGzp1uWQ0iWbmEFW0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782120378;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=orwbBsy9A3Mw4ETnXQSohuB+yc1BDjfxHVYxLaRkDCg=;
	b=nJzo8WJNS9zt1umxMA0YYCX7/5u1rCgVBZsUCrK49vYgGvZWYayErBZiMZPR08Vrx8WEGa
	B+yZ0CKhuvHTwAAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DE466779A8;
	Mon, 22 Jun 2026 09:26:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C2c/Nrr/OGrFNAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 22 Jun 2026 09:26:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 840DBA12DE; Mon, 22 Jun 2026 11:26:18 +0200 (CEST)
Date: Mon, 22 Jun 2026 11:26:18 +0200
From: Jan Kara <jack@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Frederick Mayle <fmayle@google.com>, Kalesh Singh <kaleshsingh@google.com>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead
 to VMA boundaries"
Message-ID: <7ftrqtta2bw2xxtrzelrs46t7khr7tf2vmh2ur2mhdphtymlsr@rqbd3pfjxdp7>
References: <20260619112852.104213-1-ljs@kernel.org>
 <20260619093711.d0d37c9920b3a16394c356a6@linux-foundation.org>
 <ajVz1nhMn2JwucMY@casper.infradead.org>
 <ajV0TbwEyaKMzoa6@lucifer>
 <ajV49Fyogfa6aIjy@pedro-suse>
 <CAJuCfpGdxsPDbxOwQFdY+Xt7mZGFvoKWmed6FteTongvFgjgww@mail.gmail.com>
 <ajWAYBXHJniJAO4u@casper.infradead.org>
 <CAJuCfpHF1qtpHZQzLmLi7xz06OWgBfduHqBHF_-0Vkx7OtBmcw@mail.gmail.com>
 <ajWXEn7gECvgG7F5@pedro-suse.lan>
 <CAJuCfpFfr_SQ4ZDFojOkDKWbO2dKdL3pUPA06B2ZC-usUnYRgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFfr_SQ4ZDFojOkDKWbO2dKdL3pUPA06B2ZC-usUnYRgA@mail.gmail.com>
X-Rspamd-Action: no action
X-Stat-Signature: gt14toj9qukfm8m94qqrsart73o9nm87
X-Rspamd-Queue-Id: BC85E10000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782120380-309940
X-HE-Meta: U2FsdGVkX190nHK+n7VGHw5PPgQMtnaHQZq66cJxeh7LqxrMTiGT2xSLjrvNaf5M+OKin05HpaNqfrj1Q6H7lAFTBatGktr15LJV+jW1hYZ5GHKNda/+VRB7y03TsOLUbfoRek40wWL6cqTph8IGCN0mhiVmUTKmRApPlpxgaDCmiMHegQ7DUVXvX6LHj/BRQ1a/ic8S0x7ncT1RMrnaGqrG5CJEa644eCWGgwajykekCA4xNvzacnS2/et90IxYN8MpJODo3QfHYofavWfHYmEhbD6is1sdr/FGmx8PCJbcUYLmIpnHQTh7oxVaQzBiVD0DYQsDldMDDan9aGmhidVygVuylxBiDpbY96UE3sosN/tujkhjA5MbNrBkixORcgRZKAJlOKGok+oE+llnLnATnLuMr7pLNWCD9uHgNx4t2yT37VPLIHRsxyi+WhIg5fW/QiehUlrembF07N0gan9cLMVGtqA6C5vCNo6j493nOx80mE5zIkRXbz+bS10NmhnTgPPlOo7CbXb64McOrOjRcsyhXr0AHge+yKV1yLW4/SMTUUJmbqic+5PMG70TztdJqkgqUtRr3y+nxFT4pc7aoW4tsAEXaKySINgOQP812OP+kG+AdAiyMnx4YtS/ofLU+7lAQonhm23bIGz/iN1AV05l2rVNapAmzO0IfnYdVuDVF3XzihzakC7Qq4sYTH6Tjxn1zf30MdtNvFd4WMpISGZs7Uu+byuh1aLI4TxrDIZpC+Vf0yiocFCWi8pNmhB75eU+2f9F2Bq6fmuoMXicDH2hYE3pDUio6DtFBEm5IwKfR34a+C6whX3WOJEMroh3PLA66Xj4kQFeaEg8G0DRAJTrjbB+ofv1R3rKmPRbRbCUN0Ub1VALs0vWODKHKX4Nluz/F/Du6T3Ojf3Yf08M67sSyCo80NiZ8tInva2DRooMlbPRnwKIbSo+2dlP1QRrabwWGAsmv9HNc1D
 hSjoDKxo
 cKCpGim5Jft/k/iAtR1GuSR+AGK1vj46VSldd5MFqXSeiSZQMAJ4y4OkJoHv0btup4z2TVn+72okolRMu04PrQ2Cevt4L13vGVxSoto3g1Ezo7abTPh20y5APLGRyGqdPUQdmM8w5u/CXORBMGzr0+QZss6HxUqsn6BhL6CMoUzTAdMfiCw2fMyNwvvzi80RzAwv4TIlLKaEjjS1hzdrnvGLqETNaG+6JC4RpNHlOXBWuGFkpfyvWehIYpNa1FVRDVOfoecCEBvxKq8sB3meEP/hukWnyrm1YGv6ldxLn8A0fUpBgXOyuzKLI826A2ZBRIhCz2uyAay1/Dhjy8dUIVqxCWOPCMzYOVZqfkZ9hY6g/amhKxCtyi6ca1FcK9R2m3ShoyvbSvoWDxg6wG8ZG/ZGGQorHyJILZzAnQLEHLWlzeaEMgPZWHt/say4kE2bzpFBBQNLOzghAq6SKeqUXFbetIYLVQzECP5Wl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 19-06-26 12:33:43, Suren Baghdasaryan wrote:
> On Fri, Jun 19, 2026 at 12:26 PM Pedro Falcato <pfalcato@suse.de> wrote:
> >
> > On Fri, Jun 19, 2026 at 10:52:07AM -0700, Suren Baghdasaryan wrote:
> > > On Fri, Jun 19, 2026 at 10:46 AM Matthew Wilcox <willy@infradead.org> wrote:
> > > >
> > > > On Fri, Jun 19, 2026 at 10:43:06AM -0700, Suren Baghdasaryan wrote:
> > > > > > Yeah, the mmap usage on SVT-AV1 is a little suspicious, but I guess the
> > > > > > pattern may come up time and time again for people doing chunked mmap
> > > > > > reads. I think we need to take a closer look at this change.
> > > > >
> > > > > Frame-by-frame mmapping for a streaming workoad is quite questionable
> > > > > IMHO and I don't think we should be optimizing or encouraging such
> > > > > usage, but I understand the reasoning for the revert.
> > > >
> > > > If userspace is properly tuned, it doesn't need automatic readahead
> > > > at all; it can disable it and issue manual readaheads.  The point of
> > > > automatic readahead is to cope with userspace which is doing stupid
> > > > things like calling read() for a single byte at a time.
> > > >
> > > > Could it have better defaults?  Maybe!  It's worth a try.  But those
> > > > attempts need to have a very low bar for reversion when it turns out
> > > > they affect other workloads.
> > >
> > > That what I meant in the last part of my reply :)
> > >
> > > But in general, I think that benchmark measuring "how many frames per
> > > second a CPU can encode" should be revised so it doesn't depend on
> > > file prefetching mechanisms. Otherwise it's measuring something else.
> >
> > To be clear, that's not (necessarily) a benchmark, the code we were
> > looking at is their encoder app.
> 
> Ack.
> 
> > (it's also generally not possible to prefetch the whole thing into RAM
> > because, well, raw video files are quite large)
> 
> For such streaminig workload I think read() would be more appropriate,
> and the change limiting read-ahead by VMA size would not affect it.

In fact if you look at that app, it has three different methods of reading
the input frames (mmap, normal read, fully buffered file in memory) and one
is chosen based on config option. So the benchmark apparently configures
the mmap method of accessing the input file.

Anyway I agree with you using mmap-frame-by-frame approach for this usecase
is kind of odd but not completely insane and it does demostrate people do
odd things like this. For others the usecase of Android doing tons of small
sparse mmaps into executable might look odd as well :) So this seems to be
one of the cases where it's difficult to please everybody with the same
behavior and we usually stick to the legacy behavior in cases like that (as
much as I personally find restricting mmap readahead to a VMA a sensible
thing to do). We just need to figure out how to improve the Android
usecase.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

