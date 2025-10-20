Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22755CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 11:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CFD08E000E; Mon, 20 Oct 2025 07:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47FE48E0002; Mon, 20 Oct 2025 07:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 347D98E000E; Mon, 20 Oct 2025 07:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F23C8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:17:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8F48C83BCF
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:17:00 +0000 (UTC)
X-FDA: 84018240600.17.A996B99
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3821A40003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:16:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S+sF83a2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="PXB/R9hX";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SoUIqli+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nWPipZFK;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760959018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xM1PbaYDZEV6JMqVRTGxnqw+sNH7uxtqulhhY+yBP4Y=;
	b=QloVptDzQTMCe62gYoUX+469I8sLgMARGk1qtXMGhe+vOSShYoRlCecEXq/+8t6GoQb3ch
	gD1eA0z9Mp/iIKE+SiB7aedHAn+yQ7LGlpfaAzLLXowV3mjU7WfftdeLGc3k2kqHf+MQ9b
	/sFsRvH8sq82jsVlFpwlzoS1mCCHgK0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760959018; a=rsa-sha256;
	cv=none;
	b=E/rR5F8Fi65mFGZGwteDWkFuSd0Ln4Kc+f2QlZ+sIdKc/U4oGkjPe8+mY/uYchmaZPVVOv
	Xqf5FIl/8FYoRHWQEUsqkoYUZTUqeroqgzKoY/5D87OvvdIIp2R+Fg/Jbno7qBSZumMiUN
	zQTIx58cgV3ljElQil8LAJHHg0rdPK8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S+sF83a2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="PXB/R9hX";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SoUIqli+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nWPipZFK;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 52AB821186;
	Mon, 20 Oct 2025 11:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760959012; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xM1PbaYDZEV6JMqVRTGxnqw+sNH7uxtqulhhY+yBP4Y=;
	b=S+sF83a20Ne66kDF5CGiT6xsZ9SITj2hEv65D9O2iwEKXinPrXQp2vhthmDy/CPwb9UMf3
	kL+jeVh6D32pE1QasGxJRhlIWljFFY6EM6fn4pAhtAFfzfmbLd02b8BbDw6jmeXwFbwpDy
	HIkCgrpVW1DSl4wzqy3VHcrLqEA57I4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760959012;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xM1PbaYDZEV6JMqVRTGxnqw+sNH7uxtqulhhY+yBP4Y=;
	b=PXB/R9hXqpxh7QhcHr5MuqvTLIYBlfcLAijFu+QLNCm1MFwNQLvqZ5PLK9zFQ2CNH3FNhS
	ycZm218ZBtcOZwAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760959008; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xM1PbaYDZEV6JMqVRTGxnqw+sNH7uxtqulhhY+yBP4Y=;
	b=SoUIqli+giSYZWF902ETGINdXPBqGYCpcLge4Cg9t11vNHRXbdWedh1Tg/idW/QkzjxfaH
	fYjcgbwL4ojJdpx0BN5fm7d8PK3hLG6EWrrSwiTN95wi/jBDQQ0lqsj5jrjZx8sxPW/s9k
	Bpt2jf72qOlF5/eDU6U3vkomhtDtdng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760959008;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xM1PbaYDZEV6JMqVRTGxnqw+sNH7uxtqulhhY+yBP4Y=;
	b=nWPipZFK3OAgu7JM7tjXRmd21rccbIxPJZvoRGYTM4mJ09OvOYqtEnsJF34gg176RMan5c
	WtNJcuflHcWXnqAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 48A3313AAC;
	Mon, 20 Oct 2025 11:16:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6sC2ESAa9mjFawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 20 Oct 2025 11:16:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EA6B5A088E; Mon, 20 Oct 2025 13:16:39 +0200 (CEST)
Date: Mon, 20 Oct 2025 13:16:39 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
	djwong@kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, martin.petersen@oracle.com, jack@suse.com
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
Message-ID: <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
References: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
 <aPYIS5rDfXhNNDHP@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPYIS5rDfXhNNDHP@infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Stat-Signature: tcpatwqdms644jrcpdr3bim4yu7qaqek
X-Rspam-User: 
X-Rspamd-Queue-Id: 3821A40003
X-HE-Tag: 1760959017-782736
X-HE-Meta: U2FsdGVkX19XRB+a2EvoKlCTrhxp1rIy3dL22vd2U5qGH4MrQc3E3f0YxYLEfaRMUGIHyxlXpNfsVSULgoR7gR1rlxBQUh1OjW7LDt1NT6zNHwER8GJAr2ayVxnSdDhf/jPRDBFkajpDqepUci6Kmyv5QIo17a8k087f+RtWZmHPFIN52aih93bqQ9Y4nvTw5/wOCVQiznY3HOHYrUfW6AQ+z8wv7FkperratpFmUEjtPqWFA7/mf5gdoXVIz0yWcfD8w/XBRuGVlewWou7D0m8H+5PW8qSRUfE6/+ywInfxbjerKoKpqx0LX+wl1k95tWRQymMPw7065tsj4xyiLrOhNoI5ERuMBlKEzgmM4i4bLXb+LiOcUlUNd9Dz5sZ4TymLwN1btA7h5zP+pp5rgFTtfmc3DggWdW3TYlBlNE8sp0OfThToQVX2VXcmwx4vC020QEza9XPJ4R9YvN0d+ZsGhiwyG5kNwBXCNTvy7FnmwyKjHrnKIUq3W69DknPkhqVToQ1oVSt/+zv/AtU2HEo6CGdMOabDh1jHIWuNpNkXSX3KJ3R/0tpKSKE+GzU+hbNg03F6hu+LlPxQ+tJwituPnrumlLyzzAni7H6qscfpeyfJsFwAcDOqKeyyz9TqtleasA0eg5JzIFs9BJOhjmSm85LvDqjX7uLGiukbeG1csaOAozTSmi/5Db/m+ns3oWamUYOkilYTC5elEp+z7l+wRnNXpZALjzzluKW+I3vDC0ZIuWtsMh7RrBC5hY2vaDz03qVEVf41n1m+egvej7v+8F/IdIKfHgUlHOnEBJ73dk0gH1IctwBKiWHtznX6YwZaGhFsVALAUWQ66/WLdu0RMq13htqkk3+DTVbS83ZqznwJjoUuOyuryl6m9GKJyPGm3LOXRg3afSV50y2nKJaJUKbm8PWZdjn5ePCGSZGyJW1+MyttcgZOxuQsE1ES7GY3eV/U34MRA1H+Ror
 Kexnpn9O
 2xPF7vsX+RYm6pK8/Bq7vhj0vPstNSmKZGX2vqH3qZ+FGcqXeT1/TpyJVkDlHuxPcQ6Zi3vL7JSFJcmeukMqn1KIBL9yGYdyC1o5rgbcmaGBijB49T9Q8ZXm0RvEe6j7VDm7YKBtMrBc1mezNVeCS6kj3dai4NWZi6xH9dX9lJFzOMoIq6SErqg/7zU7gqpDjr0V44cLvffz/xOI4VoxwKnOM16iMxBHR8556ogPiWs8HzPvW7WReTHDX5yKjw0E7LFydOEn9EwbUbMi+q0XIbZqRr7SIjKgsH/9GLdZwnO7Z9XoZZrNfpX7ILlhSxSWuxcD/iAoy7qzjyJBRghBdre6IjoQ11d5GHlDQMBcA9UcapmRghEnqsDZ2kLceubxUu6DS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 20-10-25 03:00:43, Christoph Hellwig wrote:
> On Mon, Oct 20, 2025 at 07:49:50PM +1030, Qu Wenruo wrote:
> > But still, such performance drop can be very obvious, and performance
> > oriented users (who are very happy running various benchmark tools) are
> > going to notice or even complain.
> 
> I've unfortunately seen much bigger performance drops with direct I/O and
> PI on fast SSDs, but we still should be safe by default.
> 
> > Another question is, should we push this behavior to iomap layer so that other
> > fses can also benefit from it?
> 
> The right place is above iomap to pick the buffered I/O path instead.
> 
> The real question is if we can finally get a version of pin_user_pages
> that prevents user modifications entirely.

Hmm, this is an interesting twist in the problems with pinned pages - so
far I was thinking about problems where pinned page cache page gets
modified (e.g. through DIO or RDMA) and this causes checksum failures if
it races with writeback. If I understand you right, now you are concerned
about a situation where some page is used as a buffer for direct IO write
/ RDMA and it gets modified while the DMA is running which causes checksum
mismatch? Writeprotecting the buffer before the DIO starts isn't that hard
to do (although it has a non-trivial cost) but we don't have a mechanism to
make sure the page cannot be writeably mapped while it is pinned (and
avoiding that without introducing deadlocks would be *fun*).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

