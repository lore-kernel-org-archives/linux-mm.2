Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B334C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 07:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 491A76B0092; Wed, 26 Aug 2026 03:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441E06B0095; Wed, 26 Aug 2026 03:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 358216B0096; Wed, 26 Aug 2026 03:50:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE546B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:50:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 84EF01C1690
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:50:18 +0000 (UTC)
X-FDA: 85142647716.03.34D7E01
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id DEF0620005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:50:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="2Z1Tf/yp";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=658bYWki;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1JuUKAco;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vA5oIE6L;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787730616;
	b=kOX5RfYmjBjJB5u1BbdhjUucwJ4ub3kBsoXAxbKZiXafR/geCMusp3nIB1yTivLofwx8HL
	qG9O4ahwu6ElXcp4zNVlqpFmbJ0anojFAkW/j8ZzUqgvaa2gli1nc0xu7W7ri3/0Ge02ac
	XuIoh4N1SoowynWyO/8Xl9ot4L4uwgU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="2Z1Tf/yp";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=658bYWki;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1JuUKAco;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vA5oIE6L;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787730616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V/kDgiqCJ24UzYKi/b0vTHiHEoPucZGyvIT9cCOxpb0=;
	b=CTXiwUTWgBM02okpn46HmZCEJe7QfKXWhSQbst+vHHHEmD4bwX5dT3B2yf8gjkv84LoMvZ
	twzQnuv2SPu/v+JetNqxkXqQVbGa0zeOW2A+D91DbrMfrCXNEReYQQCOifVUE8tcKTiP7Y
	LztV77cie4PA8cfTzB1NurhQXCOg1gw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E8ADB87217;
	Wed, 26 Aug 2026 07:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V/kDgiqCJ24UzYKi/b0vTHiHEoPucZGyvIT9cCOxpb0=;
	b=2Z1Tf/ypjBvVk+yBoniYR6BcmnlXWvIf6tUvzYS1LY5lHf1JhccViu7h5BgvZjiNltUVr3
	kVZDko2QEGnhBIRhDzJcJpdy47Nq1ot2zMLC5+HKo0abzmfnSiXYCYb2wS4daIZJwz6ku+
	mXaAvocjnmEJfLIojQHOnYh4tlzafKs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730610;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V/kDgiqCJ24UzYKi/b0vTHiHEoPucZGyvIT9cCOxpb0=;
	b=658bYWki4AUwyhAOT31qDuMyPna1QbJfz6FjGWQiHbcaSyiSXtc7eETidr9tnt+NHkWzNX
	zMcpKPXEliEmCtDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730605; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V/kDgiqCJ24UzYKi/b0vTHiHEoPucZGyvIT9cCOxpb0=;
	b=1JuUKAcodENvSgJev1mTdBqYGVNqOhIPDnDRUFHDNNfI+UKF5Hbx66lEdWsfh1WYPiRDz5
	NdPE4LAktNCQQPyuvR2Cmrbi0lThRccYF7sWAKSpyCYBW2xbtXUPAndVOZ3cFa9a9T+XQJ
	5SCdZ6uIdEikprCWzSb1uJ1VjbVSklY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730605;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V/kDgiqCJ24UzYKi/b0vTHiHEoPucZGyvIT9cCOxpb0=;
	b=vA5oIE6Lxvhb0G4M580CVZeOvk+ZaLTuwbG6zEdGNN79MxFpOzhk69zb4Q8Fq/lk5kzWsE
	NOc2dZCq8DTfn2CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D787713699;
	Wed, 26 Aug 2026 07:49:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id APOYNKOajmodDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 26 Aug 2026 07:49:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1DB57A13A3; Tue, 25 Aug 2026 17:50:17 +0200 (CEST)
Date: Tue, 25 Aug 2026 17:50:17 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, fuse-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	devel@lists.orangefs.org, Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 0/7] Remove aops->launder_folio
Message-ID: <cpxzyq5vdzuwters6mn3irrxvpvvkr6g7cjqbrsckivrupbua3@pzjpyvzqnke4>
References: <20260820193343.3852967-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820193343.3852967-1-willy@infradead.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: io64ezo1p7jcby7dqn4e5njjrhw78qn9
X-Rspamd-Queue-Id: DEF0620005
X-Rspamd-Server: rspam06
X-HE-Tag: 1787730615-376562
X-HE-Meta: U2FsdGVkX1+1h/mfuQd9WqJW+hP8iAECO7a38ua6JjMW11zgR5rY9KwXZztj+S5ylZbXTy1005Tq8k19yf3SrZp9wfIo+AeeITc1GPF4uGa87iK03Z2rYbUIqPOmJuASnnXQ85ZFWWfxSk9apsMzpQCqvcB0Yr+r64miN73mDnpITI1gcW8mOqMumfxPEScCd0P9FsfkTT6ewbNQwp1uWfsY5l00tKQfUTuA+wcbLqwm9YEglOjWcEPNqwhv36nF9io/yI90ZuS13By16H/tqQ/Hw56oYmvclIiTAu3uxtHTgct+9PVEe41JsNXtV1mBQa87WaoVhyrJs8wdD+Xhk04lvaEHYg0vrRYzahhQm4m1CNC3W4mlvHWXPg2AqUDSkXINN7cG7u6iFYe845FkOembWVdRePsJbxA4loLUGPIOmI3Ood622ekFaKRlqXoT0XBwFpRJ6XCdPDjgaO/3+xiWTa2UDzBGcJY81hNx8BLSIjxpyxxunVrV1m7IYi4gcpuiU245bL+m6VuvlQeZOtQeiJNygOr/SlFWf1um4ZLPifaT73PJoE4Ga9MsZ6VZhZfmjlbqOsgFaZnE+qUHBSuoVv8n7hkWLd5e1muTiMlNx6VznxpfZgkIhGADNsBn2aUl3S3Jca9wjky56755/iU/EJuGKYPo440lJFjlxYdthCKzcFp7Ue9H4zhaYP6Om7nXT9EAHV4msYVdycCS98ipzyIOCRA4gFc+9mrD0bEvgTXqKI9QSuuthYUvtdUi3RdK4iSu4Fp/TnwbGJiEWvkvsa6mk/4vGu1HgYQBHm704c52Vb1pN6AbHTtf0qscIkFTESxO6CRp2/MI9JksjX9JAvIu8rua84sB3cUlqzmap/OvL9DrEjuFkADv/UVZQElgJPCFuc7FAfBT9vUOo2nBgmaaWnQhjf+VhthhLvSmPoqgIhoArbSduvjvdEHzDhD74BugDQ3Ql8wUDUn
 PYbRfJ4j
 UETVT6cjygu1N2dZF9wI+ll4oMtIW9HfT1uPdm9e+6Z8zsx8o3ub2wMTQmWW7LD68RQLLCW+P1qajFRGtDWNpDPJ27utKqwZFdHh3VO16wQcfJqc65NQ5jlEQ0DulwbS99gQH9HEfRjeOP51fTsIjsKbRSEgy+ZbrHYel029ZzO5GtiE9vNVVuusRKpiTqbSMgMS4Bq/mirOxXrm4VNBN/hygyE8wEBiwEOy7LNgxn5sTETnTHAE4Ept0S3hwYWEz5bDlz3KscbGcu4/B3B7JxvoDTUE/jQI4+znh1ydlTgEg8jMfcwcnQ6kajXBGmmTtgg4aKUwVPNrDNRaK9hbTKGt3BvcGxxi2Bza8BgqPW/ijbATNSz1PRcRaikckHnaSaKBtudc2gLSIUHbyYeJmLjFYenGRUl4Dbs/9rg2Xj3otcCT7pvWFWuxjaXnyHCv91a4ggqNGyg6NlaObuhzlEnZHtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 20-08-26 20:33:33, Matthew Wilcox (Oracle) wrote:
> There's really no reason to implement ->launder_folio.  Most filesystems
> don't.  The only problem is that some filesystems rely on dirty folios
> being written back this way, so we need to make sure that folios are
> written back before invalidating them.  filemap_invalidate_pages()
> works well for that, once we remove the 'nowait' parameter.

I like the idea (and was myself wondering from time to time whether
launder_folio is actually needed) but what was putting me off was that when
using folio_launder() you can clean a folio while keeping folio locked and
so you can guarantee later eviction without someone messing with the folio
between writeout & ->release_folio. Maybe nobody actually needs this, which
would be great, but it would be great to hear more from the folks using
launder_folio about their reasons...

								Honza

> 
> Matthew Wilcox (Oracle) (7):
>   filemap: Export filemap_invalidate_pages() to modules
>   fuse: Use filemap_invalidate_pages()
>   btrfs: Use filemap_invalidate_pages()
>   nfs: Use filemap_invalidate_pages()
>   orangefs: Use filemap_invalidate_pages()
>   orangefs: Remove launder_folio implementation
>   Remove folio_launder()
> 
>  Documentation/filesystems/locking.rst |  8 -----
>  Documentation/filesystems/vfs.rst     |  6 ----
>  block/ioctl.c                         | 14 +++++---
>  fs/btrfs/direct-io.c                  |  2 +-
>  fs/btrfs/disk-io.c                    | 11 ++++---
>  fs/btrfs/free-space-cache.c           |  4 +--
>  fs/btrfs/inode.c                      | 12 ++-----
>  fs/btrfs/volumes.c                    |  4 +--
>  fs/fuse/dax.c                         | 15 ++-------
>  fs/fuse/dir.c                         | 12 ++++---
>  fs/fuse/file.c                        | 46 ++++-----------------------
>  fs/fuse/inode.c                       | 17 +++-------
>  fs/nfs/dir.c                          |  7 ++--
>  fs/nfs/direct.c                       |  5 ++-
>  fs/nfs/file.c                         | 24 --------------
>  fs/nfs/inode.c                        |  5 +--
>  fs/nfs/nfs42proc.c                    |  3 +-
>  fs/nfs/nfstrace.h                     |  1 -
>  fs/orangefs/file.c                    |  4 +--
>  fs/orangefs/inode.c                   |  1 -
>  include/linux/fs.h                    |  1 -
>  include/linux/pagemap.h               |  2 +-
>  mm/filemap.c                          | 42 ++++++++++++++++--------
>  mm/truncate.c                         | 15 ++-------
>  24 files changed, 87 insertions(+), 174 deletions(-)
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

