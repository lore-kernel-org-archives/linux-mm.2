Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0EE9CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEFE56B0005; Thu, 28 May 2026 05:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA19C6B0088; Thu, 28 May 2026 05:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B90116B008A; Thu, 28 May 2026 05:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A931A6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:22:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44CC61C0696
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:22:47 +0000 (UTC)
X-FDA: 84816288774.18.057F324
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0FD83180005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:22:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vwFJrv3P;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WGHUy67C;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hKpjqBIJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bLDbaUfZ;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779960165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=txEsarQVyN8eunFyNH+dCTUvcxmT63EdhouQVd3C0+E=;
	b=twv9G+44nqT32guICX2kXgsdSIffcMg8XWNlswzOqCVCvRxzghhunLn1lLz2HMpQfg7hsE
	3uR0lrHMoDLDF2cUMeqW/qBj3LpqzQkCr1259pPpKvxgTvL037D8pglCTgQgn0je4Myi5N
	LA0psvuqE8ruMSL8V7x0yJ4ZC3hR/KM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vwFJrv3P;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WGHUy67C;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hKpjqBIJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bLDbaUfZ;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779960165; a=rsa-sha256;
	cv=none;
	b=T9E4nKuXByBqgbXcE3Bsg5qJAGcfZ1ezJif24Gc4ioJEWx+CUlAm+lZtyvKWFD2GY2pewg
	oEcRAirTbq6AnYDu5aVxkOMvJPyr0F09FIl+1q6wAB1tZ5Z2rB0j3wNswIBfPbH0wG9ddD
	kqPSRGV0rNYT8DHjbzQ3CcN2B15xXLc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 68A9767380;
	Thu, 28 May 2026 09:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779960163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=txEsarQVyN8eunFyNH+dCTUvcxmT63EdhouQVd3C0+E=;
	b=vwFJrv3PTA+YrYJJW4Ms+yETvFyZi8cym5fOaaG8hQgh4LCo5WZf7c6TVMngafgPJx0pCT
	NQmqTDY07CoKXY38uKajNl5AsKEJZW7MfCJxIhL2pzCbMkyN3j1Q6CGtzoTcH6R50t83E4
	sTP61OA3EbjACQ/o/eGw7NxYku7OdPk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779960163;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=txEsarQVyN8eunFyNH+dCTUvcxmT63EdhouQVd3C0+E=;
	b=WGHUy67CH801700ZCizCQlnjNSXm4CGoaVzR0qm/EjUFuHjILBX1re9DUybIDWSOks31IJ
	g1zOezv0ur6I5YBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779960162; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=txEsarQVyN8eunFyNH+dCTUvcxmT63EdhouQVd3C0+E=;
	b=hKpjqBIJJJWkh7JFOAcIDpZgZddY1JA+3wYGfTHxv8D+49orws0VVkj4P4mq/UPUgGnlEP
	mesj/2kJXNRPv+79Jp0Jzzt0tj+yOivO3CwhDokCT3bv3c6jNhbQMFT0Kj+HSt9Mb4QpT4
	RW7v6uw3F767X5AzIC0jgOs3FJhLzM8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779960162;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=txEsarQVyN8eunFyNH+dCTUvcxmT63EdhouQVd3C0+E=;
	b=bLDbaUfZVoUHAoN5AsJRKhcMzI5Rj+pD0en3A8mlT5fyi513884lGAzCBNkv2qrVLsaiCr
	CUHd9zMd8UuGzvBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D0BE5ACF1;
	Thu, 28 May 2026 09:22:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VpaxFmIJGGrOQQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 28 May 2026 09:22:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0286FA0905; Thu, 28 May 2026 11:22:37 +0200 (CEST)
Date: Thu, 28 May 2026 11:22:37 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 00/11] mm/filemap: split out folio wait and VFS code
Message-ID: <3dxzu3ck5y3wxw4pp2qhzwwb6y3f7mwhvgxfpl56sokw4ymop7@xaaoxsa5yu5q>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0FD83180005
X-Stat-Signature: h5bfzt4pc5i3wqgjbyq38za6h6ozdgum
X-Rspam-User: 
X-HE-Tag: 1779960164-962890
X-HE-Meta: U2FsdGVkX19kxy+UjzyWF83SeIYjBft7blU1DB9CHGuIauSlPq/UAazsga2tckp4YRjSTTSZ8PviMqcNnCBbugnxc1rWufRwMe7B9Vq/XE8hiW8808T452oq3p/GKW7Xyt7QROVz5DKqOXKDsnqBrz11gJHnjLguplQN8sko3bcqojOSnw/Avxfelojp7uvfDe/f//eD1RlZ0l3E85xJCvcPbtoxvWlRqV2+jkD5qzZUDV19j14Qm9hjn/0FZ4TOpUpCWK3+rF+pBE0MZ9LOI9X4E6lhc7lsDOyVviXiSGiRljSi3qYeH+iaawqX5GnStXwFwXrHXQAd5osaiGar/IQFtzqSafaBYKItfK3mnSpUyYc3xz5kTmqYl4w4+SuYW0cRV2A6B3Rkxz2MPlIEeL6rRAg9IIm77FXvM4yPwh/+CJpg2Mxm+LcfDMOWdN2a7fa3nTaoqrEuCAfR4U3+ipammpu08i/+jixnD6CmWNH0uoAxA0Fvb8aHM5SV9nWz0CqB4hqEoYfsgO1BW5BSX8pXPMph3RGX1uDKoI+iGLjt5xKZKBvZEXnJtugXX+No5khtAaD+/bWfdSvJthtxXYNvB4M2XB7iri3fD1amCg+34Y7u4PGz8OL6a7n9LnrxSHjbcbrt1Ty6ScefVfcIe1kpAFr+GH1tJ3rvijqdS6IZW4xzycOVu/1Qp5RtiRds1TL5Sndu+Vg8vHyFNr7bKxsWM1Tz+9YS+FY5/F0ArjRFdca5DV+YUkLQPurhLafjXcyuwtAYL3jcqBgvzcfgXg0hPUELs4GNHIySLmiqyKQ8mcez2bte5DOvytBWcIWytU10NFJfkf6oDxAEzb3pn4BE7CfhOWzIA/2QjQW6tceMXgA82sg8QZlRsPfG0Ijwou77NnpC84wKfiL3iam39Jk4ylbrSFxyuHrBUTR8iqFVJ2u6LBdMz+6m7JByDQ1w0bSb3YzS5pKH+2T3qag
 xF8yUsSA
 KpmTZgl2HcFDb3/pa2pfAJt/qASBdO5h7ub0iwoZX8EPIb5u0BkKDm96keUnVnSRCer+yDOoLtWnU+jMyrMqKuzI8x6yftd7P71t8r3ezat/HFoTid9sH5nrzDGix5bm95qDYUTVn8p14yOwrOoVJehql1uCsmdNLpNrjbqihTaRgm12HKa/RR9+BxSLy8iQ21v2tVSbZY10mRYowIFXvSek6GO3TknpHLKUgeQVf4lxZyRi/ha/oBMMwtKhXxhGc1MxiOki7pNGV4xhh/ri2fNhJkY9ikxFoHylDTkpGhOIYPMSloJCr84WfFR1iyD6qdMDLaCFsaxsTM2sCh8ElXiavnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 20-05-26 16:48:51, Tal Zussman wrote:
> mm/filemap.c has accumulated additional infrastructure over the years
> that is not directly related to the page cache. It is currently nearly
> 5000 lines long. This series splits out the folio bit-lock and wait
> queue code into separate files, and moves the VFS-level
> generic_file_{read,write}_iter() family of files to fs/read_write.c, in
> order to provide better separation of concerns. This also slims down
> mm/filemap.c by ~1000 lines.
> 
> The folio wait infrastructure is centralized in mm/folio_wait.c and
> include/linux/folio_wait.h, with functions moved from mm/filemap.c,
> mm/page-writeback.c, and include/linux/pagemap.h. Afterwards, the code
> is cleaned up a little, with functions and data types renamed to refer
> to folios rather than pages.
> 
> generic_file_{read,write}_iter() implement the VFS-level read/write path
> for filesystems, including support for direct I/O. These functions and
> their helpers are moved to fs/read_write.c, along with other VFS-level
> read/write functions. dir_pages() is also moved to include/linux/fs.h.
> i_blocks_per_folio() is not moved from include/linux/pagemap.h, as it
> requires folio_size(), which is not currently available in
> include/linux/fs.h.
> 
> No functional change is intended.
> 
> Note: I have additional cleanups to mm/filemap.c ready to go, foremost
> among them centralizing on the filemap_*() naming convention and making
> the exposed page cache API clearer and more consistent, but I've split
> these patches off from that in order to avoid sending these logically
> separate patches to ~60 maintainers.

Overall this makes sense to me. In particular I agree it makes sense to
move the file read/write helpers into fs. Regarding the page waiting bits
it makes some sense to me as well although there it's more of "I don't
really care" opinion so let's see what Matthew and others think...

								Honza

> 
> ---
> Tal Zussman (11):
>       mm: add folio_wake_writeback() helper
>       folio_wait: move folio bit-lock and wait implementation to mm/folio_wait.c
>       folio_wait: move folio bit-lock and wait declarations to include/linux/folio_wait.h
>       folio_wait: move folio_wait_writeback() family to mm/folio_wait.c
>       folio_wait: reformat comments and fix alignment
>       folio_wait: rename wait_page_* infrastructure to wait_folio_*
>       folio_wait: convert VM_BUG_ON_FOLIO() to VM_WARN_ON_ONCE_FOLIO()
>       MAINTAINERS: add folio_wait files to MEMORY MANAGEMENT - CORE
>       fs: move dir_pages() from <linux/pagemap.h> to <linux/fs.h>
>       fs: move generic_file_read_iter() to fs/read_write.c
>       fs: move generic_file_write_iter() family to fs/read_write.c
> 
>  MAINTAINERS                |   2 +
>  fs/read_write.c            | 358 ++++++++++++++++
>  include/linux/folio_wait.h | 183 +++++++++
>  include/linux/fs.h         |  19 +-
>  include/linux/pagemap.h    | 184 +--------
>  io_uring/rw.c              |  14 +-
>  io_uring/rw.h              |   6 +-
>  mm/Makefile                |   2 +-
>  mm/filemap.c               | 993 +--------------------------------------------
>  mm/folio_wait.c            | 710 ++++++++++++++++++++++++++++++++
>  mm/internal.h              |   4 +
>  mm/page-writeback.c        |  66 ---
>  12 files changed, 1285 insertions(+), 1256 deletions(-)
> ---
> base-commit: e9add7501ad3297dad9b90ce201266830a68ab47
> change-id: 20260511-filemap-split-871b5c18e98c
> 
> Best regards,
> -- 
> Tal Zussman <tz2294@columbia.edu>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

