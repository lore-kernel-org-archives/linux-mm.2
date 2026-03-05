Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 515BFF3D332
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 16:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721306B0088; Thu,  5 Mar 2026 11:42:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67A206B0092; Thu,  5 Mar 2026 11:42:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552B36B0093; Thu,  5 Mar 2026 11:42:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 46AAD6B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:42:30 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 197EA1401D9
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:42:30 +0000 (UTC)
X-FDA: 84512577660.10.629F745
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id D8DD38000F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:42:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jGUo2hFU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BL+0lglh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jGUo2hFU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BL+0lglh;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772728948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YB9x8XN+Y+qd6tYArq0nO9pyPGgcxxO2MoQ2Szi1vEw=;
	b=r5VQYXAWgB4NL2MHduLYKpE8GpcXNfIg4Z50K/vbsvvf7HyRMq/bXUxB990YKJgeuyS6RV
	VaSAQaGwSYksfl3ACisJI5SOyN+tGWP7HeTsdo0451ohDS5F28j0h6A1biQfJ5+vecKyTy
	REdcfIgwNSntRCGXiBDPITidRI+oamw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772728948; a=rsa-sha256;
	cv=none;
	b=33DakNolf+z7D1uClAsY+UEMUAPyCNKWm7PZpc5TymKczZxsexGciXNKsN60J53uu9Va3Y
	MFp3QwnUfvIEFb0mX6xwIqxMieGPYJVJEY51H59jef10TAq6djPODe9HAcs2xVa2msdADS
	gvyRl0eIitI5I7YCiQ4KraA+rafSxIo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jGUo2hFU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BL+0lglh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jGUo2hFU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BL+0lglh;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 988553E700;
	Thu,  5 Mar 2026 16:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772728946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YB9x8XN+Y+qd6tYArq0nO9pyPGgcxxO2MoQ2Szi1vEw=;
	b=jGUo2hFUI8OmozNrFFkgC3iFPeYfTnB7NnJosv2txPSzBCHDo7yShBYMkbyjjQKK65Lw8m
	nWKUtgTqcLAYrBhBrU3N0y9qupZj79fK4f+a/jv4WzuLo9r++aVRQyoU2okvmCx+DT4i2n
	gclejavcsWz4tQ2xMMidFy3fTUC0YWc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772728946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YB9x8XN+Y+qd6tYArq0nO9pyPGgcxxO2MoQ2Szi1vEw=;
	b=BL+0lglhRwEZwDaevlbFSFxI04tbXmtWnzkMwU3TKDoGGdpCdlBOEUKqxIAggT0ns2Z2mP
	pLE3YJ5XCcQUGCDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772728946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YB9x8XN+Y+qd6tYArq0nO9pyPGgcxxO2MoQ2Szi1vEw=;
	b=jGUo2hFUI8OmozNrFFkgC3iFPeYfTnB7NnJosv2txPSzBCHDo7yShBYMkbyjjQKK65Lw8m
	nWKUtgTqcLAYrBhBrU3N0y9qupZj79fK4f+a/jv4WzuLo9r++aVRQyoU2okvmCx+DT4i2n
	gclejavcsWz4tQ2xMMidFy3fTUC0YWc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772728946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YB9x8XN+Y+qd6tYArq0nO9pyPGgcxxO2MoQ2Szi1vEw=;
	b=BL+0lglhRwEZwDaevlbFSFxI04tbXmtWnzkMwU3TKDoGGdpCdlBOEUKqxIAggT0ns2Z2mP
	pLE3YJ5XCcQUGCDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B5723EA68;
	Thu,  5 Mar 2026 16:42:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oo3+IXKyqWm5AwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Mar 2026 16:42:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 426C5A0A8D; Thu,  5 Mar 2026 17:42:26 +0100 (CET)
Date: Thu, 5 Mar 2026 17:42:26 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, 
	Ted Tso <tytso@mit.edu>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
	David Sterba <dsterba@suse.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-aio@kvack.org, 
	Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 17/32] fs: Move metadata bhs tracking to a separate struct
Message-ID: <2humtq6dr6dsoovz63xqwql5wk7ntoz4xtwlyohavl3vym4xxs@l3rivwrbxmy7>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-49-jack@suse.cz>
 <aag1vDoCVwAlIKPq@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aag1vDoCVwAlIKPq@infradead.org>
X-Rspam-User: 
X-Stat-Signature: apg1ep7d58feeqwba9djudptx7optxwh
X-Rspamd-Queue-Id: D8DD38000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1772728947-814406
X-HE-Meta: U2FsdGVkX1/wKkWH5ds241iOEng9yUkk3yoqHdZJk2/avwLI8lgvlxiNdPoKjoZDiM87mEBZ8F/N3dhLFVQT//kMw5ECBB6E4ThGT4NrJvF39+Th8AFlkV5mnzCKlynxeUwXTPW+9bjXoz13ZvyCRy00HbIfA5a2vWcEk3DYCJtaybUlBTSDmhBi5fTMob5TCxz/kIf1C0c9awnI9mpD1BKAUI/idr6CkYQMk7N+UNc50SiRmvohHvgynOntim7Dw2k6kMc94Gjw34Uyi3L/04X4ATuxI0PpxsQOvjr1YCvCR6pa4Mw/6EZyq3//P+hvccG6bI0nTqAomnqwAZ2ShwWhB7tzR874oHrvKEpXhkdJrjJtymf/9FV4X0Kl3UK5U6pz/ZuQIsNUdSZXmG+0pLRAz5IHVFwTWPbHf3jf5yVuvb0qG/LoK8ayWExYG/C67VbAUu5GcA2eUeRSACi5bBeP0hHK0PdK5HMtwxZclguCk0bsfytZtLlO+SM0nBtL6nibrILBXdc6HohH9M/XYAzKjLMZNwSVXF4riZJPiW1SUfpPFOxS1CXHkog+tXXphnUl6mrMYu8Cq72cYZmwlf+sVtkEeZnKP70bjRSzSJywPgVCxBSUvElX4mYJUgAp1obnyD6A6NJ/nsuATjSpliuhNdUoYFtm/uRZvpA3aeh4mYlb8SBXqd82mk6PI08Q+xC8wmWfCoRb8YNGkvBhW9paxOwLygM2Y6d9gcP0KACmoT27oQn8/w8YmCpsARFW9iA22dn1b1DEXKW/6mMr1cZDaC9S4OCXdSBbqZ5n6+sYX/kwkcFFFJyTBz/xcGzyYNmEhDUOe8FoQNc+Qb2MqTKd0kF7kDew+y8zhChY+cGImkmmsi4cIrbw8BAE2PwYhwXKcKitQyC83DZpqxFA3XCuNJ39a81kN0ENJMWxrETWzNHEBeio6WQNaT4eEE/qijqZR+0UDmrnBtLR4EH
 9QNiXsBv
 tNLZ4Pf4Ewcodu78Aj4SRYvOJR1h7f0soeqsFtv5+Lrup3bNKoKylRHM0KntQQYHYmV9zBd2KQQA11UefO6BfUxyaqPvWQCBofi5qOWNrC5c+E1RYF/mzMEHh1RGMkZlmlWaG9j0jBvS3Oh3e2PlmDce70pkf8HvxSZaSESR8v149PMVVbZzBm/N2E+HgRsIW+z8OrerwEbpruSh213Lh3mx8RRH58TaO0/7bdDPlZXY5WdTJLURyCzoNbP2E2pQkXPFNodKTEbABtt+mDUmQHezejgXqqN7xLuVz/WS++z/KxL0dO5xogz9aPhgp62hRZa76DsTGuwWb7EUEpdBN9205kg0Y3iaE1xd/qY2FmCoeQofzMBmmDNrkKaXKEDApuY5ZzZmx9HYtmqd6HmvbUZtOo20/T79Z05xs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 04-03-26 05:38:04, Christoph Hellwig wrote:
> Maybe just call the structure buffer_head_list at it really just is a
> totall generic list of buffer heads with a lock?

Well, since we'll be adding pointer to address_space there and eventually I
need to add a pointer to the buffer_head containing the inode to fix a bug
that fsync(2) now doesn't properly persist the inode metadata for all these
filesystems (but I didn't want to clutter this series with that fix), I
think a special name is warranted.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

