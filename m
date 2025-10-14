Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAE33CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 09:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52BB98E00BF; Tue, 14 Oct 2025 05:33:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 502A98E0097; Tue, 14 Oct 2025 05:33:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4189D8E00BF; Tue, 14 Oct 2025 05:33:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D6138E0097
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:33:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D69581A079F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:33:35 +0000 (UTC)
X-FDA: 83996207190.26.EFEBC82
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id AFA9720015
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:33:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xHzzbtQG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=16qmTPMq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NaECqKgg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="vP5VAX//";
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760434414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bu1v0ZsOdAGwtYXCG/q/PJru4MIkuHqF/5/HnD8J37w=;
	b=QcE8p00pKR5H6R+q3RgZsuZU1nOn57sgJfmoFOVeXCiOLRQbwqaZpd6l1JDD1VU5KjjFVx
	NKXGFm7AFPTsXDuNN/0p5rd2YDBAqgD6jwSZJ4sH+XVewmClxbTzxtyFkxjcPawXTrTCtw
	Q3jl0G4PVTercmo82uOl4i5wPRG/2C0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xHzzbtQG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=16qmTPMq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NaECqKgg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="vP5VAX//";
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760434414; a=rsa-sha256;
	cv=none;
	b=3RO18SBrbGq15yCNLhfRNGCzKGPYCbbD/fN3xNQuYy2lgVoBxYSO3xO+Wnv1XTR/KbnkFu
	ZJs8McZp/xx1BtGjlyrbe9pesAGOhldmPXgEeqrY2oxTvIaFLdj/dAsWoad0B3gPf6992n
	nWHaZUw8yyanfVf0/UZeF6u00v1cmY0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B12311F7B2;
	Tue, 14 Oct 2025 09:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760434412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bu1v0ZsOdAGwtYXCG/q/PJru4MIkuHqF/5/HnD8J37w=;
	b=xHzzbtQGIwea3na2nDBBtUHQCYVl+R4lrrOdnSJT/vknDNYjr+zb3BH7kF5R8Z9ReIr7s7
	8oeltK+lIpc7uiNPWBJFa/vsDggH3nWXkJCf5EllL+ZK7tZpRWDcVZnkLDXOS2PLphnnqA
	qhzt/HIwd8Ivy1zbyofvraqcWTE4jW8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760434412;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bu1v0ZsOdAGwtYXCG/q/PJru4MIkuHqF/5/HnD8J37w=;
	b=16qmTPMq9Ya8DnrCMADkaJsMgrCHAKaNUvd3JQofXIz30IZYTJ5fsx6dhNS9LiGSVjSJhf
	4MfmzQ8JrkN89pBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760434410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bu1v0ZsOdAGwtYXCG/q/PJru4MIkuHqF/5/HnD8J37w=;
	b=NaECqKggLq8fTYGbKvSAiCuRZdr3+9HhjsTNR1BSu02lITDfqhzA6+TCH9jpKHWdpZGzr7
	5FuW51Eo1RgIg7MgMNtHA4/HgVwLVezGUtBiUaNxgWNpcDkh7Z3ajhSreD7VB41gTDBOQe
	ej4qi+L9Rs2qxglM5o2QF1emQgcqt48=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760434410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bu1v0ZsOdAGwtYXCG/q/PJru4MIkuHqF/5/HnD8J37w=;
	b=vP5VAX//BKm3YMo8HYPJx5WbHvSRihWzLL6OI67rr+DUiEHOr+lFjqNyOD/u5H7D/BSFWt
	+EUkM3zJxNArduCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A16C4139B0;
	Tue, 14 Oct 2025 09:33:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eaVjJ+oY7mjaUgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 14 Oct 2025 09:33:30 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3B1F7A0A58; Tue, 14 Oct 2025 11:33:26 +0200 (CEST)
Date: Tue, 14 Oct 2025 11:33:26 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Damien Le Moal <dlemoal@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 06/10] mm,btrfs: add a filemap_fdatawrite_kick_nr helper
Message-ID: <qh7xhmefm54k3hgny3iwkxbdrgjf35swqokiiicu5gg3ahvf4s@xhyw4sfagjgw>
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-7-hch@lst.de>
 <74593bac-929b-4496-80e0-43d0f54d6b4c@kernel.org>
 <4bcpiwrhbrraau7nlp6mxbffprtnlv3piqyn7xkm7j2txxqlmn@3knyilc526ts>
 <20251014044723.GA30978@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014044723.GA30978@lst.de>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: AFA9720015
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: i95cdxt5rhg4i6my9qtb87edk6myp47r
X-HE-Tag: 1760434413-982255
X-HE-Meta: U2FsdGVkX18YStMqO+Qd9ax0rzcZFDGluWsd+uDNQnv3KlbOn68LlMA/w87niOyY6VBfNCyeaYLOjxscJtD1eFa3BFa9tGp7iyoFwhgMrYw7aRVDnp9I9zbE+l0SKHQyZ8ALT8UqIo66bC3guJ56LUjFb0tMT5XxBK4lLZPQHE3KDXxPF6OwEIL+QFQupJo+r4x8X3kt7I6yP0wzlfoo23N5a4csy2o9w55/5MBiPSoqD/q1QFdjKxa2YWBUx6i3A2/8Gxbps5kDLat7TNKTctdKbQHEzoHaZIqrMopqwj8mHg3jqj4bQBSfMM3EzeCqrTKlVqpD5CHEmn8oWPI2hbyPD6AiTU1iJBF+VpkyfOQ7g7w5crXVHj6uqTjiJlko0wnCYw3At31oivXeVKPb4LHC+8MCE2ymIPJZ4RqRll6Ml3HSQF9bChJMeYA9/W/D05fRkRYQwFZp0V9euHsbvmTjXK2tWcJib4INLSA1PLYqJgXGIBe3kwHH5XqKzodoi6b8/DOT6CZ+hNCEyImlGJYmBiidT4z4/6XM0F1OPWkUEZhLVucZV7MqXVVjUh7uXr9e+HlhwC1pP6v8qlh0ZIFGXKwxwGtq3o7GJfu8eVckWIDaNFRtpGfcE5Y8HrqU7RUlqEUZP79FBoDmmLRsP5hqBdErNrFQO6xtBjOZbmpwp+D5nU8+JukFZLk3j5UXVUMKahI/suJqj1BiiTsyHBV/TS9KrLcl8AZ3tE+XyLgKNUIjiUc6EUA1b4mL3M8atidXXuenDj9jifJMEAwoyXmAJJGYLQs7SQHeLjvRm2XXQePl9wThbOjoDIk2xGcJx6xUThi13er6COIW/ObxvFP0a/PDalms3aNUYr/N0Qri7nCXp6PsgNg28kIqERKCSXFk4e2jkRR3ukA1OtE3o0NBJPCpdB5j5Pa/PKK4iaWCFP+zas8rvtpVOcG25FHY7DaY6nvunGCDkN0NPk4
 0qblhA3e
 NmATv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 14-10-25 06:47:23, Christoph Hellwig wrote:
> On Mon, Oct 13, 2025 at 01:58:15PM +0200, Jan Kara wrote:
> > I don't love filemap_fdatawrite_kick_nr() either. Your
> > filemap_fdatawrite_nrpages() is better but so far we had the distinction
> > that filemap_fdatawrite* is for data integrity writeback and filemap_flush
> > is for memory cleaning writeback. And in some places this is important
> > distinction which I'd like to keep obvious in the naming. So I'd prefer
> > something like filemap_flush_nrpages() (to stay consistent with previous
> > naming) or if Christoph doesn't like flush (as that's kind of overloaded
> > word) we could have filemap_writeback_nrpages().
> 
> Not a big fan of flush, but the important point in this series is
> to have consistent naming.

I fully agree on that.

>  If we don't like the kick naming we should standardize on _flush (or
>  whatever) and have the _range and _nrpages variants of whatever we pick
>  for the base name.
> 
> Anyone with strong feelings and or good ideas about naming please speak
> up now.

I agree with either keeping filemap_flush* or using filemap_writeback* (and
renaming filemap_flush to filemap_writeback).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

