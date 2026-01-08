Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7CF2D185C0
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 10:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193D66B0088; Thu,  8 Jan 2026 05:36:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14B256B0092; Thu,  8 Jan 2026 05:36:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04DA46B0093; Thu,  8 Jan 2026 05:36:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7D346B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:36:47 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8AADA8C129
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:36:47 +0000 (UTC)
X-FDA: 84308443254.18.47E6790
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0FFFAC0003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:36:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=L9PphSHv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EkjRTIoK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=L9PphSHv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EkjRTIoK;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767868605; a=rsa-sha256;
	cv=none;
	b=vR0IrhGVRKag6WLn7p+1MkbEnpJjOnukXHpBCN1rHyqUVfW2MtM4XFuItBYxPqvqqf2Q3W
	swID6CACUcABARlbXMWcY0otrNclm4tF1lM3RW3n3HwkUUkfZ8t1aA6CJBYiMUaONdJ9cb
	aVNI4FsGQ3yHgZgybl+woRDnvIwE260=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=L9PphSHv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EkjRTIoK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=L9PphSHv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EkjRTIoK;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767868605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y7zhMg4dN+hDANKOVxoNd5LSGROZDwb68O8xAw3Tm4E=;
	b=7T1K+81tAdsre/7bEahGdYI2Mq9oWikUKhWrVLAW+hCkKIQzaQCWWWUufeQq3x5kft6dgT
	zRTlmGrNVQSGeBxmBNBL42ZTS+/xNr0SG1zgJBUIw4PBPr164CqAuaYs6md2ZIaO1pLxua
	/RRJnBtRhidn54dThljOWrj7o/k8UVs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4EAFA33CE2;
	Thu,  8 Jan 2026 10:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767868603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y7zhMg4dN+hDANKOVxoNd5LSGROZDwb68O8xAw3Tm4E=;
	b=L9PphSHvE5aR8dH4x2yDWKzbzE7wgHTIPEJc1LruiiFeoKxe0rptToVkFsCWOKf0+iXdEN
	BthFIq3+XrP+9YJvLraGvQZZ0YkbXpq/Wy86oN7Xn6hcghaaGXUsDuvybdBQneXBST1EjH
	KbXkbXiZdrU+WKtZGpBN6oFPEZLh5bo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767868603;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y7zhMg4dN+hDANKOVxoNd5LSGROZDwb68O8xAw3Tm4E=;
	b=EkjRTIoKt0pWVfhd22UD0qU7RDnjIEAUPdxkd5yjon7tdL6zZE2EbkeRZHDxuClMhzgOER
	dfJvWLCKhLKlqSAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767868603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y7zhMg4dN+hDANKOVxoNd5LSGROZDwb68O8xAw3Tm4E=;
	b=L9PphSHvE5aR8dH4x2yDWKzbzE7wgHTIPEJc1LruiiFeoKxe0rptToVkFsCWOKf0+iXdEN
	BthFIq3+XrP+9YJvLraGvQZZ0YkbXpq/Wy86oN7Xn6hcghaaGXUsDuvybdBQneXBST1EjH
	KbXkbXiZdrU+WKtZGpBN6oFPEZLh5bo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767868603;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y7zhMg4dN+hDANKOVxoNd5LSGROZDwb68O8xAw3Tm4E=;
	b=EkjRTIoKt0pWVfhd22UD0qU7RDnjIEAUPdxkd5yjon7tdL6zZE2EbkeRZHDxuClMhzgOER
	dfJvWLCKhLKlqSAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 353253EA63;
	Thu,  8 Jan 2026 10:36:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Erf3DLuIX2niXgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Jan 2026 10:36:43 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EB010A0CF3; Thu,  8 Jan 2026 11:36:34 +0100 (CET)
Date: Thu, 8 Jan 2026 11:36:34 +0100
From: Jan Kara <jack@suse.cz>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org, david@redhat.com, 
	miklos@szeredi.hu, linux-mm@kvack.org, athul.krishna.kr@protonmail.com, 
	j.neuschaefer@gmx.net, carnil@debian.org, linux-fsdevel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
Message-ID: <fhwhqvzs6rmn5zbazbbtcdr73tokykwy63lrorv4q5azbdg4hz@czkgoperhk4x>
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
 <20251215030043.1431306-2-joannelkoong@gmail.com>
 <ypyumqgv5p7dnxmq34q33keb6kzqnp66r33gtbm4pglgdmhma6@3oleltql2qgp>
 <CAJnrk1aYpcDpm8MpN5Emb8qNOn34-qEiARLH0RudySKFtEZVpA@mail.gmail.com>
 <ucnvcqbmxsiszobzzkjrgekle2nabf3w5omnfbitmotgujas4e@4f5ct4ot4mup>
 <CAJnrk1b-77uK2JuQaHz8KUCBnZfnQZ6M_nQQqFNWLvPDDdy4+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1b-77uK2JuQaHz8KUCBnZfnQZ6M_nQQqFNWLvPDDdy4+Q@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0FFFAC0003
X-Stat-Signature: pgniw43eiec16o4ee9ztmfujs8wtssi9
X-HE-Tag: 1767868604-84112
X-HE-Meta: U2FsdGVkX19h2UyOBqOmRQXtrbtaN/6HGktYUZRHweN5Emx8pRd734ficX6YMbgZaqvH/rP3SlszOcWk5TuQBYnpyAXOcRl5D1wmQO54Zipu70ojgma32f9gbVUQKWf5HeQBYDBwK/im+ofZ1UmNvrGwlfIDp+ROsNAxnIHeVgNClVPrDkX10gF3m087iFQdKFcwRLbg/7vlOANDvI2cOfjWr5UyIi17a5NBnkWXynDMj4RFwUyREVbtStty+lH/7G5BVc53oE9ZIm10LVGkhQ58LzgmibDImyz/EiHrWp2jqigyFls99OeSuVWognlvLNGRc3OHYjItGOqOozDy7a93UPUq55vznRHv1eJHSiuVVrwJFaCQ6qIVRasorhXirM70VqGU3AHsi9UUhosqMaFzD9nsyHs+HCwHaIjwZDkEVIaAUt809LnjQzSckH9RZfmWEeHOXLpIkz8QmHA14JX6PXbuQ6xuYzC98K1FHZbfS1Ni3MMVQYe/kuWEQcjcQtfrOPsiu9XAV+JT2aKOIHuucDaC3629p/A5wjKgWA9e4JG+3Ns/9xzVJ6UUgqF8lCJ7ntlnwpS/RBtfbxUI8qF+vfOxCQ4NHmWghjP+cg8ASGlZnPkk6jMbBD63zry4zuRfVRxXZYyQOXKCNDinM/nJpaX+I9WmAKd601Utxz+Xo9VdXOf6rp+5x1xjBPuXZZ7m8uMeIXG+k9lLFHbTLtSNhM8wG5kjtumtLUaG8+zzLZpOfPfktS55rqEliwudJ/oq9amQQmohVqnOad4GBQuLFYXNL2bRzDu9k69Jhg8CiiG838YchdR/IAzM4WKtz4nlyUSAYgRZPdWIXhc1dtPFbkFVNOOu26QD8VZhALnOytjVM2DZdBRknjhpyAs4V8lldu+DPhuHl1KubdECnVID3YFJUxZNx0BXmzRmQSv8OG5X6/17/yMOUJkR4J9NtRWcM9ffJLf7ACJWfEg
 4y+my81s
 G49I7sR09/YmG+uHA4t/uhkLJx7ukx+77iBL9btT14x0Z7VPA5V792pwSUz7Qexrey1Vb+MiU36b/T/YX/kerwsjCpMMM7QpZ956oO5QS/fq7mXSyv5e7l6wydKowIQLJixKuB6opbnqOWd88nOk22xouCVVX6pJNA+sGmiOxoGlcKKInafKEJe822cBF8c1tgB8Mv/YNEAmbXxopLwYhqKyLoVButJ3GcWOSERjH4zoX0uGiApDX2NNdnlcLeZSn71oKm0Yam1iDWXdqbGJX7Aud5Y7OxmTgle5aLa/MN2kwlMipA6Rdv22Hh5zMU1wG891y1cPQ/G4RJ5CFCfvGPp1c8VAlQwShUhkD0SIgrM8AaV52ovbmIdYWgRXcGnOGQ3Ac9lPwKv/PrxXjLXc+OakmoCuABH2Z2XY6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 07-01-26 15:20:48, Joanne Koong wrote:
> On Wed, Jan 7, 2026 at 2:12 AM Jan Kara <jack@suse.cz> wrote:
> >
> > On Tue 06-01-26 15:30:05, Joanne Koong wrote:
> > > On Tue, Jan 6, 2026 at 1:34 AM Jan Kara <jack@suse.cz> wrote:
> > > > [Thanks to Andrew for CCing me on patch commit]
> > >
> > > Sorry, I didn't mean to exclude you. I hadn't realized the
> > > fs-writeback.c file had maintainers/reviewers listed for it. I'll make
> > > sure to cc you next time.
> >
> > No problem, I don't think it's formally spelled out anywhere. It's just
> > that for changes in fs/*.c people tend to CC VFS maintainers / reviewers.
> >
> > Thanks for the historical perspective, it does put some more peace into my
> > mind that things were considered :)
> >
> > > For the fsync() and truncate() examples you mentioned, I don't think
> > > it's an issue that these now wait for the server to finish the I/O and
> > > hang if the server doesn't. I think it's actually more correct
> > > behavior than what we had with temp pages, eg imo these actually ought
> > > to wait for the writeback to have been completed by the server. If the
> > > server is malicious / buggy and fsync/truncate hangs, I think that's
> > > fine given that fsync/truncate is initiated by the user on a specific
> > > file descriptor (as opposed to the generic sync()) (and imo it should
> > > hang if it can't actually be executed correctly because the server is
> > > malfunctioning).
> >
> > Here, I have a comment. The hang in truncate is not as innocent as you
> > might think. It will happen in truncate_inode_pages() and as such it will
> > also end up hanging inode reclaim. Thus kswapd (or other arbitrary process
> > entering direct reclaim) may hang in inode reclaim waiting for
> > truncate_inode_pages() to finish. And at that point you are between a rock
> > and a hard place - truncate_inode_pages() cannot fail because the inode is
> > at the point of no return. You cannot just detach the folio under writeback
> > from the mapping because if the writeback ever completes, the IO end
> > handlers will get seriously confused - at least in the generic case, maybe
> > specifically for FUSE there would be some solution possible - like a
> > special handler in fuse_evict_inode() walking all the pages under writeback
> > and tearing them down in a clean way (properly synchronizing with IO
> > completion) before truncate_inode_pages() is called.
> 
> Hmm... I looked into this path a bit when I was investigating a
> deadlock that was unrelated to this. The ->evict_inode() callback gets
> invoked only if the ref count on an inode has dropped to zero. In
> fuse, in the .release() callback (fuse_release()), if writeback
> caching is enabled, write_inode_now() is called on the inode with
> sync=1 (WB_SYNC_ALL). This does synchronous writeback and returns (and
> drops the inode ref) only after all the dirty pages have been written
> out. When ->evict_inode() -> fuse_evict_inode() is called, I don't
> think there can be any lingering dirty pages to write out in
> trunate_inode_pages().

Right, that addresses my concern. Inode reclaim on FUSE shouldn't be able
to see dirty / writeback pages. Thanks for explanation!

							Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

