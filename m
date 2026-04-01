Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B29CD35174
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 10:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906006B0005; Wed,  1 Apr 2026 06:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AABA6B0089; Wed,  1 Apr 2026 06:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772426B0088; Wed,  1 Apr 2026 06:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 59A956B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 06:37:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D4785AD2E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:37:02 +0000 (UTC)
X-FDA: 84609634284.14.66622E3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 86890A000D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:36:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="F/mE2xUZ";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/UccDmD8";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=POf5okF1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aUqErqgt;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775039820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZI/NH6MnG5cMCHh3hQuSK0Fc/OsQ6oNTdNxeEnpKjI4=;
	b=Iv9bG0kbRYcdmc6KeReOwXDNfz+Oj+KgLIU4J4ClUCt4phzdEnzjwWzPvrSeu/OBWPJ+Mx
	oxRVGwIzj+xM1jbb54ie7jQE1+bXOqg3rtyoRyx9OMWkfMQkxCCcguslxbuS/pPGPJuUWi
	jWGpBPjOKAcoPZWxtqsCV6oEL7FSs8A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775039820; a=rsa-sha256;
	cv=none;
	b=lFC6hQ+3Pqx0lTalknwYISuszn7/rUt+UwCaBD9q1T6oRFge+DSSIpmzuA+coO7z90tTBA
	/d5iWROf056ipKEQ2ue3siXJeJnIZzHdW4l6uiOU3WeSO4ioYq7Ynjo+CCgUTK5MbbrMTO
	HgDTj+Z1a0NLu3Pfb+0K+pdJ2g6moTQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="F/mE2xUZ";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/UccDmD8";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=POf5okF1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aUqErqgt;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CA5074D250;
	Wed,  1 Apr 2026 10:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775039817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZI/NH6MnG5cMCHh3hQuSK0Fc/OsQ6oNTdNxeEnpKjI4=;
	b=F/mE2xUZAQea/XHXfCcYqP6U7yh+XRiWyxOcB9QX6W4Kts1Ugd/6N+n7a4sE4o/z/WYfoM
	gKQKxEhA20xLQGogKp7G0QriBpXoOJ0csPcZFlCIKBvMsT90WRVGIUQwNj9KIxdRrGZYk1
	03z7EoEBaUazm6teNPyJLhq8rY/XXGQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775039817;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZI/NH6MnG5cMCHh3hQuSK0Fc/OsQ6oNTdNxeEnpKjI4=;
	b=/UccDmD8wkmfjZGhyYrnjMEADda/bmrssSeVDp+PQMafWCf8szzau/h/vuv/xF3o3NbLYL
	g0k9WAaMPlBmrGAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775039816; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZI/NH6MnG5cMCHh3hQuSK0Fc/OsQ6oNTdNxeEnpKjI4=;
	b=POf5okF1V17iFfbrnw9u5ARfRncGmDuCZNDLesvOSBGlNQgqsI0RLcDW9TtbApPabNXM4J
	PyOIEK2snE+VD2xx0r6ae2kQrZUO1+8hDBilzn/BD4T3cBxZoByDYXtmsGzLmieJmMAHN1
	hpFnDV+GTzJFvXDO4nxPl/uuh7lOrn8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775039816;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZI/NH6MnG5cMCHh3hQuSK0Fc/OsQ6oNTdNxeEnpKjI4=;
	b=aUqErqgtW6YullBWTiJ6nJ2+Z1UFG7qI038hpzIdUk69peJy1Byw1XuuFY3RNLd0bagbxC
	/Eb68QI3sM5ZoWAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BEE614A0B0;
	Wed,  1 Apr 2026 10:36:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dBKVLkj1zGkNEAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 01 Apr 2026 10:36:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7F9D5A0AFD; Wed,  1 Apr 2026 12:36:52 +0200 (CEST)
Date: Wed, 1 Apr 2026 12:36:52 +0200
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-aio@kvack.org, 
	Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 15/42] fat: Sync and invalidate metadata buffers from
 fat_evict_inode()
Message-ID: <dvo2jvc6upmzrgqxx3n6er3e2gvujheongtzkihzmllwxqiyuq@h3qrrnwxlwo4>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-57-jack@suse.cz>
 <87ldfazqo2.fsf@mail.parknet.co.jp>
 <3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
 <87jyutwo6o.fsf@mail.parknet.co.jp>
 <mjraa5thsnzchejoomqgiahwajx4cs5ryqnmn7zsi3fylzhrrr@5ip65jcrlknn>
 <87wlyss2ny.fsf@mail.parknet.co.jp>
 <gkwyh4z45xglmq7jmam4yfvkecivipr23trzjkbyfolm6pdzre@d5huocjf55ew>
 <87tstvc90b.fsf@mail.parknet.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tstvc90b.fsf@mail.parknet.co.jp>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 86890A000D
X-Stat-Signature: gazqdub3kw11jzaspg13fshro6xexk11
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775039819-91204
X-HE-Meta: U2FsdGVkX198zuEkI3bA8gWh6RTwKuslIBi7XiSXk5V1Qjm7A5q3qe/JJVFeXUeIN/DsiDj9Sec5ist7oUIVR27uo3s31r8RLLMJKKKa0Cgd7GTRYtfRm2ibJbleMeYynH0o4E6ZaHa4tjYR5EN2utNbKW9YoOy1fmddyaW05Bw/fBPEZcVKHENFA7rk5r+kHnwyMmoJzBO8GS545xRZ89PeOs+KN4hatnAbZDdKAXd9l4tkOiG3OKJ3CR0htRlC+fv8k8D4BHRg9jt0SMEly2PuiVnDMgnWf2ZAI7gushAYyeFjpztrHbZVUPQtCbq+nSmRQPAuOFPMRAgBdfMZMF+fO0VruLYgwyK3eZOFe1DvIySI0KNg0GqVDkDPcUpbjnOM2N5WeIW/LX6rtRZctdQgWM40fXYYvYEBTIMRvvSMUwrcHhf8UmyFeRbLqTZsDWxNdcevuPneTNXH31X9pYAQUe1H+PudEMKivJ/lP4A+En8IH/P5x75gJXgEoFh1IpDps6p2IClpzJgn2CxtDk5q49w1IWycFio63hHSpvsFgsdCsfFBmiUeMQmEh3/uogITYD+PPYscmVlf7s+z50iPcDPMhxbnEYwUBafS3jx2MYnn1eloMrBhmwrgbZNOIz7ohxuqHvWkKgUbSRCw/6wokCLYpFIQyP+no1wwCtDnvl9m29ZLmSS9jyZNDOiifL2S6wsuj63gS35lUI83Z+9wsnvJn1b1riRhFhDhQ/UgUavN8s6Utd1ZF0M6kVJjJKeTL1K0VMjs4Er3pGIc/0Ab+hzA7IhH+699bJ3HQkdkI+sKMl1kPLdxtYBbgx0REH4m9m/AOdBoPnKk2/B9N3rr0zSbRiGKeF8bNQpLtvdZTeUfdvr/q23tgNM4l1uOfV2kM9mIGAGcqIE2eH7rp8ovVQiu758s1xg+wt1+z/GpF+6YELat7KjJRaCpCA1eoeQV0i/HzhFf3DP9kgc
 oj8lw4u5
 UInHUH/0MJPNl20lD8cLBpJAFMLokqHeje1mphdGvvCN9dHZ25m9fDFndEtpMbwjyZ3FLPVjnJuB8wHDtdqZhNpS7vWJ4UUzYp39XaatSxCPJzakoXfGB4w8bF8mU6CWJfWRiBhdUFoxyQc8XLetK5N81+6FKFdsJCYn44X9LJYTOEAYoPdPRPnZfmDKtAXMdma42XAFF60GGPStKtOsq77gK1L9Utzr49q04lLFg7b4RPh5Rbm6CYarWjFKfkRFAqvBgoqMzrnOi+cEbHZI8RnbP+ve2Hu3qrnadEpkdElJIggX2NM4C1uWGLYFDxKgEz0uOJNn6ZBk/w+yL3JN9Ng51NeXDGrrcdyuzU0ucS13MItdbuLJgykyTi39ymcpV5zxp+VOxXjpORiIuQAX+P3Y9n59wHYFKaPbhrLfM0q6Cfqmbn4LnsvHNiwMlNGXfxO2/QUecVaD8Cyk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 01-04-26 18:41:56, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> I think it would happen with normal operation, for example, copy many
> >> files more than total memory. I think this would be much common than
> >> write=>close=>open=>fsync in your example.
> >
> > When you copy a lot of files which are large in total, I agree the flushing
> > can be triggered. But I don't think it will trigger any excessive IO
> > because the metadata blocks being flushed aren't redirtied after the inode
> > is evicted. So blocks may be written out earlier but I don't think they
> > will be written out more times. For FAT for example you track only
> > directory blocks in these lists so when directory inode will be getting
> > evicted, you may see earlier writeout of dirty directory blocks but that's
> > all.
> 
> Hm, metadata block is shared by several inodes. So earlier flush
> makes fewer chance to combining multiple dirties.
> 
> For example,
>   create dir-A
>   reclaimed and flushed dir-A
>   add new entries to dir-A
>   lost chance to combining re-dirty of dir-A

Yes, but for this to be possible you would have to:
1) stop using dir-A between dir create & file creates
2) create enough memory pressure to cycle the dentry of dir-A through the
LRU and reclaim it
3) continue memory pressure to cycle the inode for dir-A through the LRU
and reclaim it

So the amount of work that already has to happen to trigger flushing of
a single block is so large that IMHO that flush will be lost in the noise.
 
> >> Anyway, with it, reclaimed
> >> inode metadata will be flushed forcibly and frequently (yeah, may not be
> >> significant though. but I can't see the benefit for users from this
> >> change.), and lost to chance combining multiple time of dirty while copy
> >> many files.
> >
> > The benefit for users is 24 bytes saved for the majority of inodes that are
> > there in the system - all the virtual inodes on sysfs / proc filesystem,
> > all tmpfs inodes, all XFS inodes, all ext4 inodes when using journal (once I
> > optimize ext4 code a bit), etc. So actually quite a bit of kernel memory
> > saved in common configurations.
> >
> > Another win is that with metadata buffer head tracking now separated, I can
> > modify that code (which will require growing the tracking structure) to
> > properly track buffer head containing the inode and flush it on fsync(2).
> > Currently there's a race that if flush worker writes out inode before
> > fsync(2), then fsync(2) does not writeout the buffer containing the inode
> > at all and thus data is not really persistent. This is actually my initial
> > motivation for this refactoring since growing inode for everybody to fix
> > data consistency issues of FAT/ext2/udf isn't popular these days...
> 
> Agree, it is good.  I'm only saying about the flushing earlier. To
> implement it, is the flush earlier really necessary?

Yes, to separate metadata buffer head tracking into a separate structure we
must remove the handling of buffer head list from generic inode reclaim (as
the filesystem has no way to provide the separate tracking structure there).
Of course we could add a filesystem hook to inode reclaim to allow for
handling of metadata bhs but:

a) I'd rather do that in a way that is usable also for other issues
filesystems have with inode reclaim as I mentioned in this thread before

b) I don't think it's warranted for FAT etc. at this point as I don't think
the possible overhead of metadata bh flushing on inode reclaim will be a
problem in practice.

But of course we can reevaluate if my gut feeling is wrong and someone
comes with a workload which significantly regresses due to these changes.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

