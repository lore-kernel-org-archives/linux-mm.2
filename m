Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98695606D839
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Y4zBKWh3;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=CHDXryvq;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Y4zBKWh3;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=CHDXryvq
Received: by kanga.kvack.org (Postfix)
	id B364F6B05B2; Tue,  3 Nov 2026 06:48:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0D2B6B05B4; Tue,  3 Nov 2026 06:48:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD736B05B6; Tue,  3 Nov 2026 06:48:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CC706B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:48:02 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0ED898035C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:48:02 +0000 (UTC)
X-FDA: 85393634004.16.E6FF3E0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 80ADC40003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:47:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y4zBKWh3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CHDXryvq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y4zBKWh3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CHDXryvq;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793706480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpNnj5q4z35v5NpxDoXWpLWIxpF/EVXKHOt/hVE3ktU=;
	b=i9nzSQ+wIIAvZTsIa+6NN+6HttJWagkeR/6zFAYoNYd0Cc9k7PGtgbbA9abckShZoywC/1
	aJucv2Sb2rd0g5G1Gvw/jXrLdlE3kvoDNVfInnoHUV94V5hx2PxEplAscCIwUmsJ/zBo9J
	cwhDVeAxhFc9peUuL6Z6ZmOJnccoTPY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793706480;
	b=nwLuevrjVY4alE3mHgoFfXe4FT5uLC7KinABVY4UQbvjhdmw+aAWpaXalvd1InKJSHTrlG
	zy0ahFz5JD7uMVdBTqx1eBkTVlOYxw2ZghSUrNF7Q4YKVsguKILBoGFBNvKCji4lwx4FUw
	S+x5lg4o20PHEDh5wYWKvO49sGWfIRA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y4zBKWh3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CHDXryvq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y4zBKWh3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CHDXryvq;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2FACE1F83B;
	Tue,  3 Nov 2026 11:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793706478; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gpNnj5q4z35v5NpxDoXWpLWIxpF/EVXKHOt/hVE3ktU=;
	b=Y4zBKWh3jpv6KMan74hAIoPBOSLs6tZK+6I3oXqMSfIYnA8S5ywXTaZUj3pHgSrb7VT90k
	329ZViAKBSeKUbGb8+5mzc2frx/+GV6reJ9nXvxCL4vReDMldn3E1PoxUzI1wb8UPaR2qV
	R/wJmcymFrxhPjRxW0H5+f3xz5M+HuQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793706478;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gpNnj5q4z35v5NpxDoXWpLWIxpF/EVXKHOt/hVE3ktU=;
	b=CHDXryvqgLheeosXz5cGd2sibnFQ1eIqkqKPm0R0TjOV2ia+1m/8RKNtWnzplPS6lEGySx
	jwKpi9Hus6OsYyDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793706478; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gpNnj5q4z35v5NpxDoXWpLWIxpF/EVXKHOt/hVE3ktU=;
	b=Y4zBKWh3jpv6KMan74hAIoPBOSLs6tZK+6I3oXqMSfIYnA8S5ywXTaZUj3pHgSrb7VT90k
	329ZViAKBSeKUbGb8+5mzc2frx/+GV6reJ9nXvxCL4vReDMldn3E1PoxUzI1wb8UPaR2qV
	R/wJmcymFrxhPjRxW0H5+f3xz5M+HuQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793706478;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gpNnj5q4z35v5NpxDoXWpLWIxpF/EVXKHOt/hVE3ktU=;
	b=CHDXryvqgLheeosXz5cGd2sibnFQ1eIqkqKPm0R0TjOV2ia+1m/8RKNtWnzplPS6lEGySx
	jwKpi9Hus6OsYyDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B3A57134B8;
	Tue,  3 Nov 2026 11:47:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LqoVIu3J6Wr7VgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Nov 2026 11:47:57 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 31B58B23A; Tue, 03 Nov 2026 12:47:57 +0100 (CET)
Date: Tue, 3 Nov 2026 12:47:57 +0100
From: Jan Kara <jack@suse.cz>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, ryan.roberts@arm.com, abuehaze@amazon.com, alisaidi@amazon.com, 
	blakgeof@amazon.com, dipietro.salvatore@gmail.com, rvvandan@amazon.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, linkinjeon@kernel.org, 
	sj1557.seo@samsung.com, yuezhang.mo@sony.com, miklos@szeredi.hu, agruenba@redhat.com, 
	djwong@kernel.org, hyc.lee@gmail.com, almaz.alexandrovich@paragon-software.com, 
	cem@kernel.org, dlemoal@kernel.org, naohiro.aota@wdc.com, jth@kernel.org, 
	willy@infradead.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, ritesh.list@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, exfat@lists.linux.dev, 
	fuse-devel@lists.linux.dev, gfs2@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ntfs@lists.linux.dev, ntfs3@lists.linux.dev
Subject: Re: [PATCH 0/2] mm, iomap: account dirty at page granularity for
 per-block dirty folios
Message-ID: <mcskrz2zbav5r3xtlwqytyotgjcmmi3wapeibkqornuhb3qp5y@qk22j77kvkqx>
References: <20261027112702.3747009-1-dipiets@amazon.it>
 <auCrqvae2tm4a8PV@pedro-suse.tail5790ac.ts.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auCrqvae2tm4a8PV@pedro-suse.tail5790ac.ts.net>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 9e3q9dpf9i3onx4kwfhympg6ckaockqz
X-Rspamd-Queue-Id: 80ADC40003
X-Rspam-User: 
X-HE-Tag: 1793706479-657052
X-HE-Meta: U2FsdGVkX1+zRaBnmhvvcWVXxpAFWInziObw411gp66R66CexeGUXf9P1OMC0Kc4MTx0lcAYNs/E63CMc9Sy8/Vqg5Lo43thXkow6oWQ0rNakUowcWsbUyT7mdmbnNfJ5nwlTNtp4gnd4s7mSzHpx8HwWHo5kDnz7EtvUIzSp8QoUSe1TQ/tKaAbSbFcz+86FPwlElixBTwJVVH5CuqgrZLzSohZ9ZCCGv6v/MJKoiaZR6yaF3a13OBwIsa4DLHywQ2Loqini0hcU3jcGGixRxsm92AEJbqpEWJ8U3LGBTmtYAs17Sb9SE9wZSYhIud+6xb5gD9XUZ7hTGz0DLv16TeZHpszzDGJMyE64It1Jts/0oToxTRnm+oYYs4x3a7SUDivpDCcYK6MDBrbVcVPEmH1OI7wZgVCauyY4DUJ3RESbZJfMlS9OYbaX9EgXWvD/vbhoquqNFVBw7YsoMhZRLW77Wd0MH9IRjLEBqb9fUYFgjXdNynBeWdGf+3z0qGSP2hvFlGnXc7EOWnPtFl7VFXuwswePsteUHF+pgvULpSh0Rj0u+VI0w6h6Ys2FzhDXZR9wBLc0DAQYVdBJMai1ClcDwuE2iKbMUTYKwv8ux93uFVh/0YWMwrlpU/Dd8tSW+RsPcZdzds9SvsKgzyZGnC62O9Qc2t9S0s4QUvLCUH6VYRg8TW9CkpdF0Qmjp28vTJ0P4bMlGvTOhR0C6+QBVNladZGEKC5Eza4yobe8rfaH1/yLdD6G4nvZoyof8VmmI8SQK+Eb22GCDO3x1a9fC4sMYRZBMAETi0y0vyr0QnOOoPm/juv8PJsXQY09efzXucxWCm9x8hOy/dQrFHOivcSS6Jm+Rmw582R8o2HeOwY9PUNv7mFDYEPkQ4eHQR/rurQWpN0IvxdW82iEbNGnHvuk8j9Uq2nvGbqOmWbhvSSOGkUZMQeon/mjnwkrIc5o1xUkGyqzi5l9cP50pn
 KIwfPZwe
 Lz6i0U+bTJap1UrdT4YLc2gdh1m9w5hgvornhZbQXSaN1s4eQM5Mw/Zm11DRf2a8fslvF2ksCzLfqslTDqpS+ZLzBEy8BVUdKCWZ3Yr97+uThojhBbYSkJNUJoRgZmNmZwoi2dnbUlOcEoYazfe3PH0q/8HMXRWFKq/bQAVlJwMBZuSlJe/9k5qlK11mwUYQeY3od0YOxMnNDnAi2mlhx8bUOEHQQ1kxvRWSiOBIadXLAVanCTkGIrvYTVQZOaLteVvNoew5JmtgrKFoyyh5l36UfKTPmebdMpvbkhNk08xv4eioPAVD4By6wlxTqC02ZogxOBled9wA5Yv6eO3alhHOcG/FwUnKW6D/EietLNg21vbKZGNdYZhtp0JCvX4aEvGNEcb8NgtuvaL0IB02MHVjXf8xdrIeZYSOlc/XDKLJpPaHS8HX1vNrBs7xnlnlA73GL/LQmNKrp4wA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 27-10-26 13:59:59, Pedro Falcato wrote:
> On Tue, Oct 27, 2026 at 11:27:00AM +0000, Salvatore Dipietro wrote:
> > Since iomap gained per-block dirty tracking, a large folio can be
> > partially dirty: struct iomap_folio_state records exactly which
> > blocks are dirty, and writeback only writes those ranges.  The mm
> > dirty accounting, however, still charges the whole folio even if a
> > single block is dirty (up to 512x over-accounting for a 2 MB folio
> > over 4 KB blocks).
> > 
> > balance_dirty_pages() then throttles writers against a number that
> > is unrelated to how much data actually needs writing back.  On
> > workloads that repeatedly dirty small ranges of large folios --
> > e.g. PostgreSQL, which writes mostly 8/16 KB pages -- dirty_thresh
> > is crossed and writers are throttled long before the real dirty data
> > justifies it.  On the benchmark below, run on v7.3-rc7, the
> > unpatched kernel charges ~159 TB of dirtied pages while writing
> > ~6 TB to the array, a factor of 27; with this series the dirtied
> > pages charged match the data actually written.
> > 
> > This series makes iomap charge and discharge the mm dirty counters
> > per dirty page for folios that carry per-block dirty state, so a
> > partially dirty large folio is accounted for the dirty part only:
> 
> Why? This looks wrong. Yes, you may only have dirtied e.g 4K out of a 2MB
> folio, but the whole 2MB folio is still effectively pinned by the VM, awaiting
> cleaning + writeback. And that's precisely what we want to measure and
> throttle in certain cases, so that e.g the VM system never finds itself
> short of clean pages it can reclaim, and no easy way to start writeback
> on them.

Fully agree on that. We have already discussed this with Joanne about one
year ago [1]. There are some aspects of dirty accounting that could be made
more finer grained but overall the whole folio is difficult to reclaim due
to dirtiness so accounting it all is the correct approach.

								Honza

[1] https://lore.kernel.org/all/20250829233942.3607248-1-joannelkoong@gmail.com

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

