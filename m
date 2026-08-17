Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18FA1C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 15:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE34D6B082C; Mon, 17 Aug 2026 11:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B93D26B082E; Mon, 17 Aug 2026 11:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A852B6B082F; Mon, 17 Aug 2026 11:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BAD96B082C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:30:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0C9B807B8
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:30:04 +0000 (UTC)
X-FDA: 85111147128.28.B8CE739
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id AD4E3C0007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:30:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sgxvc1E6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WYlgK5W1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qY7ZhzU8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3U+ceEZX;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786980602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jwocy5HOnc4xM9hp/tGparlx+7VGWV7D51yWV27DQ5M=;
	b=4kjA2A2aLhcnxKyvbHXhNt9iPhonQUD+pCp+UTkU8XKy13BhswDrWpjxhIhqPWvC2lIR1i
	cU4GZ8zkEP/NilV+QQTUNzL83Vp58dC1DDmquSEX5PrhCZe0cYlmd2KDz8GLK9zor2B8sv
	gP0VrCIQQCw+IO69sf7y3MdvwcL+Ns4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786980602;
	b=ndkQ45j+rS4YIN+43uzaYqdEPUE9ybCpJolsxbbpCOnJj4/MNwzlY1qFjcHOB3dXeeQeiB
	Yj6/MYJc9SEHmW+uToa6DZs0yNPRexkxecLAW+PCAR9yJi+FV0fWz4BdBvSB0RStT6Zo14
	rXn+jxJ53CkZWrTU27TWxrE6xB5XvhQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sgxvc1E6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WYlgK5W1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qY7ZhzU8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3U+ceEZX;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 17DD482272;
	Mon, 17 Aug 2026 15:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786980597; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwocy5HOnc4xM9hp/tGparlx+7VGWV7D51yWV27DQ5M=;
	b=sgxvc1E66xVbgt4vyhq2S4LOHeyIw05arZapn7IOfAQil3Nw079pQnHe+KNKGoRMr5IMWn
	RfB+OsPAHtkMl70gi6WvJKZWUWlNHKo8Mjupa79J73oL9uV94T5f8IUTyIXcp/WldlmGch
	eAO0dXOswnaomaCIKlADpaMqmENP7Ew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786980597;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwocy5HOnc4xM9hp/tGparlx+7VGWV7D51yWV27DQ5M=;
	b=WYlgK5W1INQL3eJKuwgh7HpVp5WYC3yotN4+cxP4buKLvm8e+UBquk12kE7rDQczjRbkfk
	ZrrniCCaYalPyXBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786980593; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwocy5HOnc4xM9hp/tGparlx+7VGWV7D51yWV27DQ5M=;
	b=qY7ZhzU8cWYiuZUSn6Vddx85pZDAqRWlkLdsjl1v1XFOUSe27JtEt2QZv6NmLnc2hytTPy
	Iim4DhM7UKGgfNZoVnnB5Ry10Y+/GLF+sKSJVDgXozjr5rkF+ziFGAujLUOrLJ+Bva0Csc
	WppXgnJrpKNBNipQimA8rsEP/KZQzwQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786980593;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwocy5HOnc4xM9hp/tGparlx+7VGWV7D51yWV27DQ5M=;
	b=3U+ceEZXdFnhrB4m1rTFO4lz4J5esIAAVjjptJB4/6MlejgCuMyAO5UFb/LBh6tOPr+3km
	4UMLC8J16vuSoXBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0ACA979529;
	Mon, 17 Aug 2026 15:29:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rgE0AvEog2oMQAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 17 Aug 2026 15:29:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9F8B0A13B5; Mon, 17 Aug 2026 17:29:52 +0200 (CEST)
Date: Mon, 17 Aug 2026 17:29:52 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, vova tokarev <vladimirelitokarev@gmail.com>, 
	Christian Brauner <brauner@kernel.org>, Pedro Falcato <pfalcato@suse.de>, akpm@linux-foundation.org, 
	security@kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Kees Cook <kees@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: Fwd: BadBunny: UFFDIO_COPY shmem killpriv bypass leading to
 local privilege escalation
Message-ID: <5y3qictex4lbtab552i2ybgne2xt6gpmpen7nfsk46t6u5qh3j@jfmrs4dwa7fy>
References: <CAGBKPgOm8q-8_rwyRPEmSj8JXdh_GaK1Q8vpJ=j-+yA0SgcNQw@mail.gmail.com>
 <CAGBKPgPPALX_5CQJAKUNjwi2fD28pBeS5pRuwQgePU93pOy8EA@mail.gmail.com>
 <anXnHMInq_JLYbWc@pedro-suse.lan>
 <CAGBKPgOfbMJruqcegJca6BBpEtpd91s5ASF_VU+gucWsjwp8WA@mail.gmail.com>
 <ancYCBUT8aB0qHwz@pedro-suse.lan>
 <anlOGOmO1HWVCMdF@casper.infradead.org>
 <20260811-knieprobleme-holten-palmen-4d42742b1962@brauner>
 <CAGBKPgPanzn8WuHK1hm44FLCXwJcnk7W=J6b17D9UzScWW7SJQ@mail.gmail.com>
 <trv2wwdwprrebu4s6i2ufepk5a5ir4edz3tnttv7ivlkzihx3e@zq6lt67oplc5>
 <aoMmOHjLMRyUXhys@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoMmOHjLMRyUXhys@casper.infradead.org>
X-Rspam-User: 
X-Stat-Signature: kzueg1iq3uk3mcdtxu4fs4bm93tmk1g8
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AD4E3C0007
X-HE-Tag: 1786980602-717500
X-HE-Meta: U2FsdGVkX18D8AkeDY16JD+dcjCgoncN63+ArYNo4IN5/Z5EBDQCfEURTRYlmLeRJStG9+N+RxbZDEUbCzxj13R/YLudSKDgaHzd0dB8tZ0CRC/pANfiJTOICfMHS2O5k6auQBFNK6kB4cknu/m5J31QNSV1UyYzUF038e5Tph6E5QlvsxPN+vvjp0PXME0Gr1MkCt2Rpm43SxKznAQJCZTxgf0rrx714H63/huuNZO6PI5YXB55EW9lc/hyUdO2+oFDdeSRygimPC9HiZoCyqL3F3ZJHDfUJrcGZ4/uL744pwiyD+Y1Dq2JkB8jY9PQe5AQnkgZ2nnewYvDhATC+4NjfjiTWfdl4iTvOq7ZqFZTQNUBqU8kyY0fwjIRfMebiW7jWjSHpb8/4grZmBqYGSLuTdo0eQpmiqDGOOqZp16TnLB7gJNlbrjhmmnOLiiw/FMtz1c9HXTN1GLuRzNBzChHM/hE3gTT/cZ7MlrT40btKelXyoR0F48sIzY0Z32+FwzNFrcPmaPdcP91YfM4wJFqwk2GHDVyb2V08VNU1aprwn1gn1XcAx4XYFEzzaCTavWFqqmzLvvT7Qzsgmx+EAH0kFm+QS4lli0vMZJ6HZIYZTaD/diz4MLDrau0LSYUjkI+A45N557NzquYy03BwpPl8HgAE0hm7nzr6jM337j/V2qKM2vCshpkaqmehOOTe4SVZRrKSvqBkJ8fWeTaYTIwUN1NEUz5VvPTC5NoKxIL+OukE8sDG4SftNNNVRWCVcuHzocIhOJeuCsBdIhim8miM9nrHf7Nu3pcdj+36AMuvnoex1Ssij4uTvO3jdgi1ya4aIciXYCiQmZ2HBPFEs4DX35TFKL8nHlZzd32JtcbUr5PTjOXMeZYysj5hWYd6+3yNBp+rBTE6FJGiGxpfAr5AlMAME2U29Ex9iapu2C/7hfpS/SHNnyh9Nn+FQGl6GpojS2O5TGxM+2/+JH
 D/14lmND
 CsrE0z6biZg/VlmQHtOIcMXKhwsuaPM4f7Wz6UrEm+YdZRKhoq/kXxG354FfVuRM2zr94y/NBg0s3KcC17RRDx1BcuExDo7wrDFsjwdzwhTTJJ+FafaRc8jqWnXRf9mIn6+IjfexGkGQf0/KU79/cvmiGs3DuEDMLDSEXXc/U+bFfbNipxa+vux0T7oPfzLgOXDmRzz5p2+lR49gnqspIqhtvBoVJEtq2Y6yRsstDXOGw/7ULfVrRlKnZxKGXWhmVr0oUFLxGTI0MXHj7ZgqQMYwNOwh5FqORimESnoZ7oNd9e+hYcP/cY8wWny4sOt83dA6+Ye6v0kPa1s7JX7xJuUuL7R9CWaYaqwMMopZrh7knQLT4RrMu0jb1u19DC7EbA0F0mrBziWhUhec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 17-08-26 16:18:16, Matthew Wilcox wrote:
> On Mon, Aug 17, 2026 at 04:53:08PM +0200, Jan Kara wrote:
> > On Tue 11-08-26 14:16:31, vova tokarev wrote:
> > > Matthew, Christian, Pedro,
> > > 
> > > Lol - fair point, I'll keep the reggaeton references out of future
> > > commit messages.
> > > 
> > > Agreed on severity - but this is a
> > > killpriv invariant violation, and the kernel has treated those as
> > > security fixes worth backporting before.
> > 
> > I tend to agree this would be good to fix for consistency as much as I also
> > don't think this is a particularly serious issue. Removing SUID bits on
> > write is more of a hardening measure than serious security guarantee and is
> > there mostly for historical reasons AFAIK from the old Unix days.  POSIX
> > for write(2) mentions this as: "Upon successful completion, where nbyte is
> > greater than 0, write() shall mark for update the st_ctime and st_mtime
> > fields of the file, and if the file is a regular file, the S_ISUID and
> > S_ISGID bits of the file mode may be cleared." truncate(), chmod(), chown()
> > have similar notes. No mention of this when handling mmap BTW :).
> > 
> > Anyway, the problem with calling __file_remove_privs() when writing through
> > mmap is with the implementation - in particular the locking. To be able to
> > call __file_remove_privs() we need to hold i_rwsem and that ranks above VMA
> > locks / mmap_lock we hold during the page fault. Now that I'm speaking
> > about it I even have a vague recollection this has already come up in the
> > past and we've just decided to leave it alone due to these technical
> > difficulties.
> 
> Perhaps we could just do it at mmap() time rather than waiting for the
> first fault?  Obviously only for MAP_SHARED / PROT_WRITE.  I could see
> an unenlightened interpreter doing unnecessary MAP_SHARED / PROT_WRITE
> mappings, so that might not fly.

Yes, I'd be afraid of userspace regressions here.

> We could also do it within filemap_fault() (and shmem_fault()).  If the
> fault is a write and the suid bit is set, drop the locks, clear the suid
> bit and return VM_FAULT_RETRY.  We already do that if we need to do
> readahead, so it's a well-tested path.

Yeah, right, dropping the locks + VM_FAULT_RETRY would do it given how
rare case that should be. Except we can have faults without
FAULT_FLAG_ALLOW_RETRY (generally from GUP callers) for which we cannot do
this... :-|

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

