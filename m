Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AA2DCCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 11:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 895358E0031; Mon, 13 Oct 2025 07:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86D188E0007; Mon, 13 Oct 2025 07:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75BB88E0031; Mon, 13 Oct 2025 07:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 61E4B8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:58:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF0C41A03CD
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:58:23 +0000 (UTC)
X-FDA: 83992943286.22.1557405
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8CE2A1C0006
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:58:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LHzybpyB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Qgh3oEVH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ME29yvbc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="+GQ6nB/u";
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760356702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPZNntVP7wQ8uxjyDhXSga5p6bLX+QQQQkULf/eXU6Q=;
	b=XALHYNJMZgW35rfCKnjj3ATWfXGwItf+eVmE3nkLcWB9fZoq2VOzsH5vhdLIGVZzvR/gVr
	nyEkOOdWXmZw4Y5Keo1bptY3eopKcgZqTFU1cjexDRpBgK90k9UYjBvlXYk2aX8TMt5niG
	edIKX/bE4OYSFXg++xpE8GulwCG3bLA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LHzybpyB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Qgh3oEVH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ME29yvbc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="+GQ6nB/u";
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760356702; a=rsa-sha256;
	cv=none;
	b=gEeW09XJkQ23kpPTlL6IUPgTQDNPODgPpoH9tpZF5zYbvPKnW6zfQuE8Uv0jlPvzIohBqU
	MmLyWhdSETaohgF8HcXfSr/+lrZEbWd3QEm5v6DOy3USLbO0ll5C7Vwbcmza+qs4nm3ll/
	KeGmZdJJhRhi87yCwCejbAJeXeMj88I=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D99E2219AB;
	Mon, 13 Oct 2025 11:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760356700; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BPZNntVP7wQ8uxjyDhXSga5p6bLX+QQQQkULf/eXU6Q=;
	b=LHzybpyB0GLJakHDKi3v7mSUdW9sAkVSckJjEIYU7uionamZ8B8jl1KTbGeKT00iy1lEuI
	WKI43I0cicxVj/CLUtuUgnH8+OkMsKb5FLUoSmCTkm7TMt+dSjcvbp5TsWFGzuPh567c2G
	38FD0LDh/nHQBeFHEXPf32xy4RS8GrM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760356700;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BPZNntVP7wQ8uxjyDhXSga5p6bLX+QQQQkULf/eXU6Q=;
	b=Qgh3oEVHWWIesaXhtgPESImlj3Mbme3RyXo8inUKxZESl8DLVG9QTAg2Lti/jFyfIiiau9
	B2fY66kOepwpv7Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760356699; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BPZNntVP7wQ8uxjyDhXSga5p6bLX+QQQQkULf/eXU6Q=;
	b=ME29yvbcQ/MbJF53rFA6iT5e32yP3OhIHjaDcaOMTyWZug0IIw6GrktxYOOzwhwmM5fvV3
	nd3sCEW/6Ew1uGaomnCVpxSwK+mYoJmrdqoxHaAiBwEyOjz7ZRKy2dyNZh1KXf3D8oSUzU
	zLvv73wixItoXsvggoNyAvHt5BKHaDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760356699;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BPZNntVP7wQ8uxjyDhXSga5p6bLX+QQQQkULf/eXU6Q=;
	b=+GQ6nB/uGXVIcxmT+F8khHkzFYthRB5g+YdjO+rW4+iS7ALtG00KT8SsjWel7sDbDJ1Yih
	7Mnz5AnHeYOb11Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C6F3213874;
	Mon, 13 Oct 2025 11:58:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zHCMMFvp7GgCAgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 13 Oct 2025 11:58:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 72419A0A58; Mon, 13 Oct 2025 13:58:15 +0200 (CEST)
Date: Mon, 13 Oct 2025 13:58:15 +0200
From: Jan Kara <jack@suse.cz>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>, 
	linux-block@vger.kernel.org, v9fs@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 06/10] mm,btrfs: add a filemap_fdatawrite_kick_nr helper
Message-ID: <4bcpiwrhbrraau7nlp6mxbffprtnlv3piqyn7xkm7j2txxqlmn@3knyilc526ts>
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-7-hch@lst.de>
 <74593bac-929b-4496-80e0-43d0f54d6b4c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74593bac-929b-4496-80e0-43d0f54d6b4c@kernel.org>
X-Rspamd-Queue-Id: 8CE2A1C0006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: u9u4rgzu7xpptji85wfpa5f4tzbq1q1g
X-HE-Tag: 1760356701-693163
X-HE-Meta: U2FsdGVkX199GmKPJLdbGlEPi40NHy0BYwq0uOwLQUwMDCVgV0/DC5oSUuaDJLIirTmUrjsd35pg0gQlIF3m7r4tesQrPyGbEuH8XA2tZU5BzL+z74R9y3Crk20jGrql08xFfTvNmU7hgEPhylGg4tGlSwlqsLVAVmpfpt2d5Y3hB9ADzG3JzI1Iy+lOTucGMORYEhTDKw5bzQfKF/6AIt+49cl9Z6cRgjMAIc/UlqfdJn3uZg5PXTpGDZ4bEuZCUA5ta/RbF9UNt95Fb14VaHWVMBVqr1v1ZL8L+P+sidR4x+s4DiyIgBUawABXyhgD87uxFx68TRkj5icjewshpy9gCrNQTdc00PtJVzIrtAAiWZlZxUh+iW8BMHjw5u3mf1kJc0tBcRgiso91w4bsGIwApefIw9hnTHwM8Nd8OpoKgwKpYEYkf3Ly25/Z3IdHGw1+RZ17OVxPgiMiPTpYkpthui2NvJDusbNmk0tt9x5MwdvZji9AQ51IWyGGfJIFULnjdE5IWYOCK2Bwd2kW6GNScNH6l/xIj1Mzoq9q+3jJAZJrWwZSpHRaxm0B0/3VlFx3KkrIRwYVY/5AzHeSW8jruAmLQLEkPu70kz9hn2zl4/fCL+bTDKg5Rfym+XkSSlP7vK6Pk+5ZeWTTnqFY/KPtczxiUeLs84fXvHz8irIiyglWNXVWt9OHuqJZ5YCJz9ewd8W4Q5XtJUNvco9dPBtqa6rC0x3eQiKCdNv6Sjd8g0OF7dEPIa4/LckWVpuOpLID60u7flOsCYWt8VBxyhckPL63lh4nu9Zjv4mRoAIlBR4Xym0TcC++uH9+8GxJ9j95lXOlSTq36Wf6x2DflgzvcoQkDanhZew5VRBd8LgJPGrmChd8tPGdRMyX247mqRD6xFn0ptrJ+L6+5scIg7F5+mSqY+e7ZwNB5/Ay60byM5hWGmddrEzNbCMKYnQ0y62fY1AsRSnvIRMwfru
 kUYUXxXK
 ihVQseygcC8jIQDidroabD2UpsYTZRPh7YvkgD965YWRjNiyAKwrjqs1zzJF4lKOFegdJf1fi55hoGiFYSV/huWSBV1B9zf3GHle3WtsTFehKujvxHYxFHCkNG76A0ofXgLUi+hmvWzrJ+XJVzwbS/i1I6cs9hF2OCZrBLBRpR/1FWDbSoSRxcoxOMZ+FXM1Qvy33eHlb/UlU1CXYiEQgZoXD2D3X3QOIhM2MBRT+qPN+Oq30E0joywyBIcTH03A/HTUKuZBoFjJn0OkG/G8TPVJZVheI6p58s+1r140sUrIbb9Io9/s8d/W/CiEaaS2shixv9blXf/AnOx33hfk4CyrrVH+3Uyr353XhonTU6sHy+Eq+SgQ/5hsddZCqmcuEyBc8MW15HfybPOji3sRiRAA5270lIVudFgGX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 13-10-25 17:01:01, Damien Le Moal wrote:
> On 2025/10/13 11:58, Christoph Hellwig wrote:
> > Abstract out the btrfs-specific behavior of kicking off I/O on a number
> > of pages on an address_space into a well-defined helper.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> One nit below.
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> 
> 
> > +/*
> > + * Start writeback on @nr_to_write pages from @mapping.  No one but the existing
> > + * btrfs caller should be using this.  Talk to linux-mm if you think adding a
> > + * new caller is a good idea.
> > + */
> > +int filemap_fdatawrite_kick_nr(struct address_space *mapping, long *nr_to_write)
> 
> Not a huge fan of this name. Maybe filemap_fdatawrite_nrpages() ?

I don't love filemap_fdatawrite_kick_nr() either. Your
filemap_fdatawrite_nrpages() is better but so far we had the distinction
that filemap_fdatawrite* is for data integrity writeback and filemap_flush
is for memory cleaning writeback. And in some places this is important
distinction which I'd like to keep obvious in the naming. So I'd prefer
something like filemap_flush_nrpages() (to stay consistent with previous
naming) or if Christoph doesn't like flush (as that's kind of overloaded
word) we could have filemap_writeback_nrpages().

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

