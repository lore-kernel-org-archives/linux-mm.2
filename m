Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42098EBFD0A
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 07:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACAA16B00A9; Mon, 13 Apr 2026 03:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7BF26B00AB; Mon, 13 Apr 2026 03:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 991A06B00AC; Mon, 13 Apr 2026 03:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 864A36B00A9
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:46:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E255BDBA8
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:46:00 +0000 (UTC)
X-FDA: 84652748880.21.F39E351
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id B9E651C0003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:45:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FcmbC42P;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QuemtuqU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AafFgXzZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9Q4A865R;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776066358; a=rsa-sha256;
	cv=none;
	b=ApgViksVtFqPhL3irPpNVaxfEwjBmg/Vaamgg+Pj6LvqfMhvQOWlnDnEQYJiQelA6Jk5UK
	3GjTRQbfn6K78lnQxxE71pOIPSs3Dy0rG4gicNTzHHRV09pZu/YA0F7O+Jv0PbS8bK3LL3
	PTktZ4od+UCAtYLTTgmxlSqaUdmXdqI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FcmbC42P;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QuemtuqU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AafFgXzZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9Q4A865R;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776066358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YTJMZK9JNHrBNpULFH39psQsEEIXluaKja8inHYGWDg=;
	b=8pNpZsu7F3sFzRScEJgmkVg5E1owMThg1vBLtH6IfjENxdT93ZokU3jxAtUL7nPWL0WyRO
	BV4Rrx2d+WfVyi76XlFG1ZQIlrH59XuDL7MwOmPTdbJBARlZA+9kG3zidG+9kOfoy6eI0m
	lo2yH+ar2iKILrIAw+Geagp8bT3e1ww=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DD1B86A88E;
	Mon, 13 Apr 2026 07:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776066356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YTJMZK9JNHrBNpULFH39psQsEEIXluaKja8inHYGWDg=;
	b=FcmbC42PtXmV/QCTrR7n9FZMc5dhwhf3bW4y0wNO4KrZKnl6AVLYpAUexJcAxPYSgiVkVZ
	FgOPYVMYt6qtYQ+wk9VAeOc0ynMpbUeVp/1JgDwbRCqhhOKVgLILfezjbrOj4khuQjI/Rr
	eVq3buWfszl+KiEiE9s3B/R2Blo/M7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776066356;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YTJMZK9JNHrBNpULFH39psQsEEIXluaKja8inHYGWDg=;
	b=QuemtuqUjON2NvTiai8i5mv6ew7exoZKaKqM/dEsGRq7DMWmpkae9Lc2Yn4RShdz2JCh6k
	Mtbf10X36H7xFiCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776066355; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YTJMZK9JNHrBNpULFH39psQsEEIXluaKja8inHYGWDg=;
	b=AafFgXzZmiBooGmUG8a+Cprt8/0H1IfXfIU7KBMYF38pvXjqZWjJAPyTh0L2JlAMGbxb7a
	4P4k8jb/QiAK23sL0jh+GP5AbXrzdJaS26iAG2he75gQZFDWttMBPbYcQVQYPHomQTMpUe
	Lz7F7fgWR0KHzq5Fj4+A+t12q9/fJy8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776066355;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YTJMZK9JNHrBNpULFH39psQsEEIXluaKja8inHYGWDg=;
	b=9Q4A865RlSf2Oy6CcPW6jj4fkYj+ilJPE3iLP+zVrzwzsCo+CHrdTceUL/GDTcWa94REzq
	6IP6BXuWr7l3V/Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D2F164AD8F;
	Mon, 13 Apr 2026 07:45:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Pbp1MzOf3GmqYgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 13 Apr 2026 07:45:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 84265A0AFF; Mon, 13 Apr 2026 09:45:51 +0200 (CEST)
Date: Mon, 13 Apr 2026 09:45:51 +0200
From: Jan Kara <jack@suse.cz>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>, 
	lsf-pc@lists.linux-foundation.org
Subject: Re: [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <sbypvp2rwe6m6ip5jzjser3ebyrj2233cjpflpmxzpbb5ib6do@gfb7eddxi3ul>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
 <adikj3y6OXgSyObW@infradead.org>
 <4q7d2bi2qjg6crznvr55yfnv2gcomfqdt5j2dgkrwp5hh3ynqo@cfgy5o53zjwr>
 <1BDB4B6F-D8B8-4FCA-8B3C-FA0672108C75@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1BDB4B6F-D8B8-4FCA-8B3C-FA0672108C75@dilger.ca>
X-Rspamd-Action: no action
X-Stat-Signature: o4mj69dxh6u3q5yumns9qi3fqu4xhw4f
X-Rspamd-Queue-Id: B9E651C0003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776066357-562736
X-HE-Meta: U2FsdGVkX1+QW28zF2Z0M3VBtAOGORVP52+/2xmamcggn422DF96VVbyQWaNr5O9FNmG1lw7NeK73Qs7p2Q3sQHr2oi7TCfP3TEWn8nJkWHI0DWL5sbDHCveKUpVywFauEO9M4dauuOEF1kDSv1zoMNsNliQao03BORW9nZs8nCzGvmWoWjGWkDPZ8KCudyv0nr0j0j0dso8w8p6Vfdjq6mC9YLwo4bxpm4cIhUnWZX6dBEpcmeFPMleiffrN/xDhFJvaiuNIS2lINEBbnaw+wrNZYA86b/GZz4eicI+QtZ2giNg0aYlodFUpp5l5n0zcFOPYflx8LYJ6QulfP1pRFBE3yipESz9n+xs0DsE2VqKbsJsZgW5roTvYZZc5WKnTlzVOem+HDfgMCXHezRelVPWCvW2fUgoBpk/cxeqTvLmXJsL19h1OUvdYLrIWPvqtlmRAT7htuLgVcqy1HYBjBhIePhfykS7D9mRJwYeuUG7nRZamttV4jbSPHWDaDfXJ+seN1JESlMxdxmBGu6ODOYNNsi8Zo+/QpxJN/vx/qiyeXWSAObjdRAOLghhViNTZ2fuwDkAfqZi6KAQLVh9BUxkg1M+4tNamNQzB+ey2pIhdmz4MTAGzitW7WqMgjn7+oJ/rnO7Mmu8jHtb3iWqVsFe/JKMjH5lKNoG9vQYpePcN2GenDlKnbXaYYPqETblOpqnIIwBQtBZXmobmXLW8/QbCtzmTtMKYRYvc74HHq7TliTDfRfm/STBg7j8aEJ4YT4zgR0UVtNU/T7S4+pq0xZGNEKx0RKYFV6viDUxI08AId667x/o636f99Sh8RidIBKBiaGjlepoF1bWByeaGfyTnTKSzAVM/lLQKpFSpW2dR3aq9aaXizxn2xr3+Ez95Q/yfqeBPw0qMVgZYYHNujxZ6VWZzp4hlcSVPAr5RE8fV9fMuYEfy/vq1fcQnEbJIaMsDoigDACyPCLGGT1
 g/2ih0hx
 Y4sM0//Vqv7WE7s4nhwRHSWBa60i+gefLJme5157nz70mJpeNKf81WFWu02sY6DGE5lGOICT7rPSgA31xjq3miSSK1h3fbVpqax+iIzKYs/xiC1Ef69VdHqWBZGM1jhTjamt8riSXBUcNcQu13UjSMDAAOpejS3DnbDyIPtKA9dwjsAtMrQC2pqeAvrrSTFswdUMEsP7oYa7xUygYg6P6zW6Zf1MOfKZoqxcY0ltp3rUacVguWJrTjshrgksnxXg5vtKE3CmeWK5Ct6vkrqZK0jMnD6r1saSUrL8JOzCfDQ4nMxlS8gF8aXQShHztx5vYmHhCnZYZ1Z/hyphp6PBx6/Fwzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 10-04-26 15:14:04, Andreas Dilger wrote:
> > On Apr 10, 2026, at 14:56, Jan Kara <jack@suse.cz> wrote:
> > 
> > On Fri 10-04-26 00:19:43, Christoph Hellwig wrote:
> >> I think a patch is more useful than a discussion here, that idea has been
> >> voiced multiple times, and effecticely implemented in XFS.
> > 
> > I know but after thinking for some time I wanted to get some feedback
> > before I start coding.
> > 
> >> Trying to lift the XFS logic into the VFS and finding other consumers
> >> for it would be very helpful.
> > 
> > I hope not to get all the complexity of XFS but we'll see :)
> > 
> >>> 1) Filesystems will be required to mark inodes that have non-trivial
> >>> cleanup work to do on reclaim with an inode flag I_RECLAIM_HARD (or
> >>> whatever :)). Usually I expect this to happen on first inode modification
> >>> or so. This will require some per-fs work but it shouldn't be that
> >>> difficult and filesystems can be adapted one-by-one as they decide to
> >>> address these warnings from reclaim.
> >> 
> >> I think otherwise we call this dirty :)
> > 
> > Yup :) I was considering for a while to use another kind of dirty flag for
> > this and then clean it from flush worker but in the end I decided against
> > it as it would be IMHO confusing.
> > 
> >>> There's also a simpler approach to this problem but with more radical
> >>> changes to behavior. For example getting rid of inode LRU completely -
> >>> inodes without dentries referencing them anymore should be rare and it
> >>> isn't very useful to cache them. So we can always drop inodes on last
> >>> iput() (as we currently do for example for unlinked inodes). But I have a
> >>> nagging feeling that somebody is depending on inode LRU somewhere - I'd
> >>> like poll the collective knowledge of what could possibly go wrong here :)
> >> 
> >> I've heard this theory multiple times, but we really need to valide that
> >> we don't need the LRU.  It also doesn't really solve the above problem,
> >> as we still would not want to perform the expensive inode inactivation
> >> work inline with the last dput.
> >> 
> >> So while this might be worth investigating, please keept it separate.
> > 
> > Ack. With the point Jeff made about NFS revalidations I agree it won't be
> > straightforward.
> 
> Can this be opt-in to flag an inode with `I_KEEP_UNREFERENCED` so that it
> is not reaped immediately when NFS does iput() on an inode (or even set
> it on iget() by NFS for that matter, in case there are multiple users?
> And a sysfs parameter that makes this optional for other filesystems
> (defaults to off)?
> 
> That way you could float a trial balloon of an LRU-less kernel, but leave
> an escape hatch/debug mechanism if this turns out to kill some workloads.
> It would take some time (a few years) to get feedback, but this and the
> negative dcache growth have also been discussed for that long without
> forward progress.  Having a runtime parameter with the intent to make it
> permanent in the future at least moves the needle.

Thanks for an interesting idea! But from VFS point of view this won't bring
much as we'll have to keep the complexity of inode LRU and the associated
inode cleanup woes anyway. It still could be interesting from MM point of
view as in most cases FS caches would be faster to reclaim on memory
pressure. Anyway this is sufficiently complex that I don't want to
complicate the "let's fix inode reclaim warnings" series with this...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

