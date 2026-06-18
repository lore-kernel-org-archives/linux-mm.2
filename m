Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61B21CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 14:26:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2895D6B008C; Thu, 18 Jun 2026 10:26:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260916B0092; Thu, 18 Jun 2026 10:26:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F716B0093; Thu, 18 Jun 2026 10:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6A826B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:26:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A6A58AB58
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:26:30 +0000 (UTC)
X-FDA: 84893258940.29.E79604B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 930114000A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:26:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E7w7aSgO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FPZ6cOcJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Vf/L7LMb";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NzDkm8dm;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781792788;
	b=1kWjIV9Y6FXbO6PLnVLs3vlecgFrZ1UVbUkTpyCQ0Ozg3TOBkDDIfcks3mxuNkR95ZT3ud
	yRLHuwMs180XG0ygnpGR9VQMLqx5Ki4wzlRd7NMBstfyeUSD+nnlirGs+joZcVxUzoL11Q
	1arbnd2syWYirQuIiPxUd+seW6+X9sk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E7w7aSgO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FPZ6cOcJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Vf/L7LMb";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NzDkm8dm;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781792788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3nBTSAFLZWoC3PysnA6b/+hH4FfP0bc0bS97qROFMb8=;
	b=wHR4xTfjOGZF+Fnm9OvwbkDiKUaraZopPQetMMqOKbU2ts6xbNBnqzPExF3WF3JBSQ+FiT
	2txC9JQifwfR4gfFju/aoVewkJGGoAcxaVvZvIjC/lbff8JgU2ccni717z4y9EFh3pwt2c
	xUEsC8vollENOy8rBVdDTo/qndLgS2Q=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B506075F38;
	Thu, 18 Jun 2026 14:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781792786; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3nBTSAFLZWoC3PysnA6b/+hH4FfP0bc0bS97qROFMb8=;
	b=E7w7aSgOtnaguNa6ZwxnpBPFQ0TaVIrJaFzZVTGai7Q1GKhXenyWr3t8unofUv6n/drpWE
	hfrRS3HNjUlssOgJwMk6WfD6MTz4jhQFFbHQ2zYszvxh7zCaIHj+u7GFhqIjfT5yCSp6cT
	hQdpypD6EL0q7XI5bSh0SG8X/rblIVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781792786;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3nBTSAFLZWoC3PysnA6b/+hH4FfP0bc0bS97qROFMb8=;
	b=FPZ6cOcJx+gQ7DSm9rs8s+aUM9o6TPbqz39QQ+O7BCfMQy1/WTjh+sj7KZIF+L96tMMOQL
	hwt3RgDXsWCuWOAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781792784; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3nBTSAFLZWoC3PysnA6b/+hH4FfP0bc0bS97qROFMb8=;
	b=Vf/L7LMbhvTW2oePUbEbyqRzRV04eTxzyl5caEyrIU6vfwOjNHy+OKRAg+wa2BP56VDyun
	0vlxQcnJYF3+53do3m6jQmQEfB6Kup8qptVHtw9B+SCIZnCs3pnFeNjw/8MBxWE9D3ej5n
	eT/yKsOz4BvxF/DrE4gRDyjXLRGgno4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781792784;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3nBTSAFLZWoC3PysnA6b/+hH4FfP0bc0bS97qROFMb8=;
	b=NzDkm8dmm333GNGV25Mbtkg3oogOcD4Nmk+3zdfhFyaEaa5j1ytPFdMlKloNBXZWf7UCNG
	xp96Y/Bo2n90UODw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9BF61779A8;
	Thu, 18 Jun 2026 14:26:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Wu8KJhAANGpdGgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 18 Jun 2026 14:26:24 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 37368A12D9; Thu, 18 Jun 2026 16:26:09 +0200 (CEST)
Date: Thu, 18 Jun 2026 16:26:09 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <4jtsjd2sbsn2w7fzfwb7wwowz72r4kc6345ckkkcjoxjbbwjwn@rkl44x3o3sgy>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
 <agq2KRd8RkP1TAf5@infradead.org>
 <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
 <ahPbaSEoNA755Nt3@infradead.org>
 <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
 <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
 <ahbq0RdUyLIPiItB@infradead.org>
 <80cb53f3-e7e5-4f96-bacc-f9fb7661d976@columbia.edu>
 <cuyklvhnt37xwk3jlr2iyyxxkzvt4bsf5iqv2gag4ixdicnbk2@rfqgjlclwesz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cuyklvhnt37xwk3jlr2iyyxxkzvt4bsf5iqv2gag4ixdicnbk2@rfqgjlclwesz>
X-Rspamd-Action: no action
X-Stat-Signature: 9dte7q9k6nu1uay8rzn3hpkcj1uan359
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 930114000A
X-HE-Tag: 1781792787-6443
X-HE-Meta: U2FsdGVkX18msTpCEmDS7/rnWInjbNYv+SfU34MGloiPaBDYxNE7AwevOL+j2q9UsmvErDR5Mhh4Qef+jc+svxS7jrB+bcWBassc+d2ofVoMj0QUnNPGYTHeGmN1UhARW/LBPurREKQ4/FgJSxj1SGq5x6rMYD1YWq0jbP9CwtA4n1bivbPrxi0SnZHfb+p0RyfUJ25aW17Q2dvMlO5dtY8IBmfOuzeoQ2mEawGyrp5Ja9df0mZyBjaMHDyCpS68oagfbQrGCWmTzK0gYd5di4tv44jCz0TI37BESITQkd+G/U+gRAzye3ihlDPFUYCTAQFLibTMSSUHBlROh523PPfcTSjRaWtbec+3l3mC41Pp/+2KrjONguq4sUGIbzkqnP/Kkz5LD8Np55GuMcSUM1m8QTIdjnkMJ9WCRfRGRsxnfPZAByTGx8ewrQ4FtLffKgo5m4G2o4+QtUksafBENt6bYABxTj6rP3/7LeJMDO5s4l9UqXmohJsHvVPTc2jCx0N0gGdhKdT0VuwBv39DiX2wTjMilR08REgFVGQyKBRY/z4fAwiiXGh7akbAhmKXxpygggVnRHAnMVqLledvOpZA8TEB7lClZsRYDA/mG7GwihKs6zzd63oNn9sWJd0MtFsTS74LNtNjQp9UicTMa/Car+9SfpP6aRUlEwqIMrlMrVMQpmPM3xzahr1l2ntBAEIi7VfM/k/1Fhl/9/xyWU6dlD5ZVDCZiQ/3oB0RLjnfzdTmnAw0m1zmRQNOWWyGsWQw/+cSWRBQx+XTlWNgA4RGz27g/jipZeXYBD8Nyq7y4I70LspzL9vCwzbiA//S5+CpZ0UpYyxSxVT1t68fwSh4jMU0NhR2nue0aZjLF5SBR2kBppyxqAwSl/T0c97+qee8cwvA/Da7GadAu0tMB4pCuIv4CnxmP7JClldzSoLx60ocJOckIPkiTbuUJgphHaOMFcgCuHOlVE68SlE
 9QEGREGo
 S6qKNn37cPwPmfpGrvO8GccMgZXkptrEUyY6r/Yz0ex95oIF3miUZZbSybYqhHofCNedmlwpFF+4pJoTscDQQ8XIJlLAAZP5DNjRhItNzQDge8Jqpb2KTU7OuIrgJZpThv0Hg21eZz+OgZPBrxpGHB2/YtP0kDtJ5HxWEApjqHC6TZjKedPubDD5ksy62FLRZMqCkCLI216C3ZLngVHTJs+j8IwEB4JiP5gl8viNWbZkTIULrLWUSn3oixfNFOAWi/V03+dM6V4pUgG5gWXo54+NZ44sGqEr/QeC3GbLLdXR/K2dTXEUKzJLB1r82Ef2wz2//cWLbENvoxyYoSB38qALFHOpS1GXIG998czerifxXbMCJouY47SXmZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 01-06-26 13:04:41, Jan Kara wrote:
> On Fri 29-05-26 16:46:15, Tal Zussman wrote:
> > On 5/27/26 9:00 AM, Christoph Hellwig wrote:
> > > On Wed, May 27, 2026 at 11:42:28AM +0200, Jan Kara wrote:
> > >> > I ran some experiments with fio on both XFS and a raw block device. Five
> > >> > iterations each for 60s. Results below.
> > >> > 
> > >> > TLDR: Removing the delay doesn't significantly decrease user-visible
> > >> > latency or otherwise improve performance, but does significantly reduce
> > >> > throughput and increase context switches in some workloads (e.g. C).
> > >> > I think it makes sense to leave the delay as-is. Thoughts?
> > >> 
> > >> Thanks for the test! One question below:
> > > 
> > > Thanks from me as well!
> > > 
> > >> 
> > >> > Results:
> > >> > 
> > >> > Workloads (all `uncached=1`):
> > >> >   A: rw=write     bs=128k iodepth=1   ioengine=pvsync2     # XFS
> > >> >   B: rw=write     bs=128k iodepth=128 ioengine=io_uring    # XFS
> > >> >   C: rw=randwrite bs=4k   iodepth=32  ioengine=io_uring    # XFS
> > >> >   D: rw=rw 50/50  bs=64k  iodepth=32  ioengine=io_uring    # XFS
> > >> >   E: rw=write     bs=128k iodepth=128 ioengine=io_uring    # raw /dev/nvmeXn1
> > >> >   F: rw=write     bs=128k iodepth=128 numjobs=4
> > >> >      + vm.dirty_bytes=64MB, vm.dirty_background_bytes=32MB # XFS
> > >> > 
> > >> > Mean ± stddev across 5 iterations:
> > >> > 
> > >> >     metric                     delay=1           delay=0     delta
> > >> >     --------------------------------------------------------------
> > >> > 
> > >> >   A seq 128k qd1
> > >> >     BW (MB/s)                4333 ± 27         4374 ± 34     +0.9%
> > >> >     p99   (us)              36.2 ± 0.8        35.8 ± 0.4     -1.1%
> > >> >     p999  (us)               3260 ± 75         3228 ± 29     -1.0%
> > >> >     ctx-switches          184 k ± 59 k     3.68 M ± 65 k    +1903%
> > >> >     cs / io                0.09 ± 0.03       1.86 ± 0.03    +1888%
> > >> >     avg bios/run            80.4 ± 0.6         1.1 ± 0.0    -98.7%
> > >> 
> > >> So 1 jiffie delay is (with default HZ=1000) 1ms. That means for this load
> > >> the completion latency should be at least 1000us but your results show p99
> > >> latency of 36. What am I missing?
> > > 
> > > Yes, this looks a bit odd.  Unless there's multiple threads submitting
> > > and somehow the completions get batched this should complete one
> > > bio at a time and be the worst case for the delay scheme.
> > 
> > Sorry, I should've clarified - the latency here is the userspace-visible
> > I/O completion latency (i.e. fio's clat value).
> > 
> > I ran again and traced to get the actual time from __bio_complete_in_task()
> > to calling ->bi_end_io(). The results match the 1 jiffie delay now:
> > 
> >   metric                  delay=1  delay=0
> > 
> >   A seq 128k qd1
> >     fio clat p99             38us     36us
> >     bio cb p50             1.23ms    2.5us
> >     bio cb p99             4.13ms   1.44ms
> >     bio cb p999            5.01ms   2.63ms
> 
> So I'm clearly missing something fundamental as I don't see how can fio
> reported IO completion time be lower than the end_io callback latency...
> Ahh, it is the strange meaning of clat in fio in combination with sync
> engine where clat means: "how long after the syscall has returned the data
> is ready". Which for sync engine is immediately so the clat number is
> meaningless. I think reporting 'lat' numbers from fio would make more
> sense but whatever.
> 
> The bio cb latency indeed looks like what I'd roughly expect now. And
> notice how the median latency of IO completion is 1.23ms in delay=1 case
> and your throughput isn't abbysmal only because writes end up accumulating
> in the page cache and writeback infrastructure ends up submitting a lot of
> writeback IOs in parallel (you have ~80 bios to complete per run which
> amortizes the latency to decent level).
> 
> However if you'd have IO that were to use BIO_COMPLETE_IN_TASK
> infrastructure which doesn't have so many IOs in flight (like direct IO
> with lower queue depth which has to do extent conversion on completion),
> you would very much see the latency hit on your throughput as well. In the
> extreme case of qd=1 direct IO you'd reduce the throughput to ~4MB/s.
> 
> Now I'm not saying the delay is bad - it is a tradeoff with clear wins in
> CPU overhead your benchmarks are showing. I just wanted to point out
> there's also the cost side which your benchmarks don't show very clearly.
> So we might need to keep some stats showing how many IO completions we are
> offloading per second on each CPU and switch to delaying the work only once
> it crosses a threshold like 1000000/HZ per second or so (so we at most
> double the IO latency by delaying the end_io callback).

Any progress here? The patchset looks really promising so I'd love to have
it completed :)

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

