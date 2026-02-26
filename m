Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F1B3FCE078
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 13:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD2656B008C; Thu, 26 Feb 2026 08:14:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7CB56B0092; Thu, 26 Feb 2026 08:14:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67FC6B0093; Thu, 26 Feb 2026 08:14:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 914ED6B008C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:14:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 579301387E6
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:14:34 +0000 (UTC)
X-FDA: 84486652068.27.DA1D29A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id E87E4100006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:14:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=j4vB+WEv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kBe6Fnbu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NCKzskdH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=f6cNY8PR;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772111672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HGlBY3HX0Fk8rDjUuw9CIjH8eNDH8K3OHId4Pn3yGbk=;
	b=2B4KK9LII5zlw/RAUVVUfYoRhFIE9EzIIDDFRqyFl6bToBT6uwrNcx+dRVwOaJXwWbLkKy
	wdDfFL+1WaJI/TE23h/trik3a4Rii1xR4TUTF8yKUs3goy/cY5S/jne0l6ZMg4LzsKkt4U
	FsuXRZByj0pCyERmH8qHRhPA3F79tr8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=j4vB+WEv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kBe6Fnbu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NCKzskdH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=f6cNY8PR;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772111672; a=rsa-sha256;
	cv=none;
	b=jJ1umtGbH425e0mNuxJouTrSeM3zXWDEZsRns/lsDX4ITp798chisRhFs8MO7VPaAPHpSj
	rfgP6TYBIywuKADKdn1jeIRP0JDGxE2j3OpUCVTdQ13wvFJmb2xvw7yOb8jf9mRi9Df1nY
	XyMlSeO+w8KjMArnKPCOuiYlEw57I9k=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 56EB7402E8;
	Thu, 26 Feb 2026 13:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772111670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HGlBY3HX0Fk8rDjUuw9CIjH8eNDH8K3OHId4Pn3yGbk=;
	b=j4vB+WEv4y1kWINxinp4K5xHq4qNb6QVbszMDLqe2cOmCXQLmMpXqNvER/OkhmttaJ6mPq
	PO01afqr65QPKR1hJWaE47l5VUFop/tmqYFDkH4sSQUZZZeg7/lDtJZsn2OcgnXG+FYJDS
	3INSe7CY01YA4kqSgq+DkN654M2Qyxw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772111670;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HGlBY3HX0Fk8rDjUuw9CIjH8eNDH8K3OHId4Pn3yGbk=;
	b=kBe6FnbufQIISa9ZmB+PWU8oz7ztKwnEgGv0N1JRe7WMUc2sHPuXsS0oQ8TVFsDL/6jtgY
	2lICg1SqBVAhN4AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772111669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HGlBY3HX0Fk8rDjUuw9CIjH8eNDH8K3OHId4Pn3yGbk=;
	b=NCKzskdH3Dy9QkXFKg6glqlZZJMWI3MXryoRpFrE7Iit1rKhU2WrNQBlfY9I3bU0B487TK
	6aGiULbesLFXLotF7xJ+ZK2Ju/0lIZWQk0HZ965fTf9rNQVLJ/PzIypOaoD4zqVV/0nUke
	/rhJu7zUhkqh0wX6hDqb69mEKV4NGDE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772111669;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HGlBY3HX0Fk8rDjUuw9CIjH8eNDH8K3OHId4Pn3yGbk=;
	b=f6cNY8PR5Z08eNP9jW47F6KDNGFWkowV9LekH5eRsIayHKjssiYBUujUagUXY+lgyn3b9l
	0ggVAJZEZsV4TbCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 42C8F3EA62;
	Thu, 26 Feb 2026 13:14:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DCNFEDVHoGlMSQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Feb 2026 13:14:29 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 07D78A0A27; Thu, 26 Feb 2026 14:14:25 +0100 (CET)
Date: Thu, 26 Feb 2026 14:14:24 +0100
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Paulo Alcantara <pc@manguebit.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Steve French <sfrench@samba.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org, netfs@lists.linux.dev, 
	linux-nfs@vger.kernel.org, ocfs2-devel@lists.linux.dev, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, linux-xfs@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 3/4] folio_batch: Rename pagevec.h to folio_batch.h
Message-ID: <zggxppyvd5ik5grjxcrhw6yc4q3w4ktiipv7qbxwlskv3l4uf2@wbrqoqvpzcul>
References: <20260225-pagevec_cleanup-v2-0-716868cc2d11@columbia.edu>
 <20260225-pagevec_cleanup-v2-3-716868cc2d11@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260225-pagevec_cleanup-v2-3-716868cc2d11@columbia.edu>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: E87E4100006
X-Stat-Signature: uu99euyaskd6jrwda57pefjaud3cet6n
X-HE-Tag: 1772111671-259500
X-HE-Meta: U2FsdGVkX1+30mCAQVH5xXnMiiaBNyuvmSBoeTfmV+oN4CkU/E5JzKjd61Fy3jmKfbhzWJmTchvVCvkzJMKcBhIZ/vSPirrAsS7rZo6Q12XYcYgvRSynK9NtCvfd2HLsEDY8qXVtHUrdEco7uOz++WbYbLycV6a58hFqP8Iki+hwSCpQp44/QSjo2gdYArRQiT/OIQkPGbUGOWzwHurqrL89nCZ+2vyJFdGW94skMgJ8ZgX75Gw8SRglulGS35k9y4pcY9cumqOinoGryNvaZNAXAyqWUfHvh6rhcuzij21WpFGJHeRfhXUZkiEg77hZkEG2e6rWTlK6fwLhbNsd7jH98yzMGH8JB5qLIfv5cXZfnZYddj6pkt6riNzcUrRJIpTEKbWEdXLIKfPSXMVDTunIp5VOP2R8yJRyEafHPkCSEykggz5JBnbVkNE46NPbvw1CsdMyjKYz8BitBrok3isn4gtugQGZDTBaSqRnUt/jg/9V4xWpqBsX3tFkaMr2X4pm690nvocs4oS9vbx2c4DbqkNBsxdkWUNI+qkBphdv6pAiutdio+k8UfnnRQaPVc3M6NF76NeNqi3WCD83YdN2UAz1p17Y5KgeiffZSVuinp0egX1psQZ5RPMK3Oxh+r6HtfcLnsxzDkqUbF7PYf7FmRpoIiYwJI/sg6GtpELONDU52P23nXwe6QIG1iAIexC/aeNoXPU6pdSGDtkesxOwqnOpj+WfugCP6VzC7bwPQifIHbJ2YUIIHllglPlFkReI2GH2MeIx+Id4+hHBmFJw1u0baIDVIfNhycyKSOGWSuRHCL9Bvje4HgosM06scnS/e1IFnPnqfbn8keLaNsBJV2RQqRcJ8gyJLfUI+5RV7TGXqj2pM4f92UJ/4wrOEk126JmGW707mt0tJy7tkri3fwQFkj0Hdg2gDhU2hSXtaWX6rOjXiFc/ZwpukYwJN/Umw/LGC29XnsmyocM
 Th+HQCjW
 I3uIZicWjVvako1lKV0/M91PuasR6CLUJvfihp/6bYv7ZJ9dxRvcFaJ7O3q5Y/4DwuOcag1bXKs6czDGGEGD1IQ74TKljhhX2bP51pv5ozSkK5pcm6XYxslqNnTX9nSkYZhdSi4CuG45BVezt06eUw/jV70NzFo26GTzX6jRjylXGxD2j5xQ6w7oLizIVbNQNkVhIGQAcyzkwdWJNW9leA0V54VmA9mqMb2o3yPwaljtLqQJ/hso1Lbs72HUHuDsLsFFCHtSX6F3rnu+hokn+37tTcpSU8pmeV0znPBfXBmFk6BfoMC8JGaqTC7pFpw0TqarJGlzzGlX5hX2u+PwKtciRWnRYzNreAdC0yVZF2gmVi7bwgNXX8Vobk2twp4FsvaZttJexUm1NaWDhCE1mvAAEOv0xHqw/1S/cA73WRodJLm/SIjq/6qBLADmFPHBG7QocLciEqQVgOSgJ4lxwH4oudvxaL3ZZhS3wQU4+qkYOl5oS1f+iv5wwcQkb1GAOqgycojCSb+XUsRMbi02Ia+oJ8Go7GJMDM1PqvCuo3Us/+6642LANI1muvJYQDXdwluH4CSZBS5F4CQDF4Sx2cJruJRQVasAt1eeJhB0HBWWcMlzurHkuoAvkH8KTtZcQC1r3aKirjN+OwQdY7fABDwqh2JJglzUqWjNE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 25-02-26 18:44:27, Tal Zussman wrote:
> struct pagevec was removed in commit 1e0877d58b1e ("mm: remove struct
> pagevec"). Rename include/linux/pagevec.h to reflect reality and update
> includes tree-wide. Add the new filename to MAINTAINERS explicitly, as
> it no longer matches the "include/linux/page[-_]*" pattern in MEMORY
> MANAGEMENT - CORE.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  MAINTAINERS                                | 1 +
>  drivers/gpu/drm/drm_gem.c                  | 2 +-
>  drivers/gpu/drm/i915/gem/i915_gem_shmem.c  | 2 +-
>  drivers/gpu/drm/i915/gt/intel_gtt.h        | 2 +-
>  drivers/gpu/drm/i915/i915_gpu_error.c      | 2 +-
>  fs/btrfs/compression.c                     | 2 +-
>  fs/btrfs/extent_io.c                       | 2 +-
>  fs/btrfs/tests/extent-io-tests.c           | 2 +-
>  fs/buffer.c                                | 2 +-
>  fs/ceph/addr.c                             | 2 +-
>  fs/ext4/inode.c                            | 2 +-
>  fs/f2fs/checkpoint.c                       | 2 +-
>  fs/f2fs/compress.c                         | 2 +-
>  fs/f2fs/data.c                             | 2 +-
>  fs/f2fs/node.c                             | 2 +-
>  fs/gfs2/aops.c                             | 2 +-
>  fs/hugetlbfs/inode.c                       | 2 +-
>  fs/nilfs2/btree.c                          | 2 +-
>  fs/nilfs2/page.c                           | 2 +-
>  fs/nilfs2/segment.c                        | 2 +-
>  fs/ramfs/file-nommu.c                      | 2 +-
>  include/linux/{pagevec.h => folio_batch.h} | 8 ++++----
>  include/linux/folio_queue.h                | 2 +-
>  include/linux/iomap.h                      | 2 +-
>  include/linux/sunrpc/svc.h                 | 2 +-
>  include/linux/writeback.h                  | 2 +-
>  mm/filemap.c                               | 2 +-
>  mm/gup.c                                   | 2 +-
>  mm/memcontrol.c                            | 2 +-
>  mm/mlock.c                                 | 2 +-
>  mm/page-writeback.c                        | 2 +-
>  mm/page_alloc.c                            | 2 +-
>  mm/shmem.c                                 | 2 +-
>  mm/swap.c                                  | 2 +-
>  mm/swap_state.c                            | 2 +-
>  mm/truncate.c                              | 2 +-
>  mm/vmscan.c                                | 2 +-
>  37 files changed, 40 insertions(+), 39 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e4572a36afd2..f50421e65cb1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16664,6 +16664,7 @@ L:	linux-mm@kvack.org
>  S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	include/linux/folio_batch.h
>  F:	include/linux/gfp.h
>  F:	include/linux/gfp_types.h
>  F:	include/linux/highmem.h
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index 891c3bff5ae0..dc4534fb175c 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -38,7 +38,7 @@
>  #include <linux/mman.h>
>  #include <linux/module.h>
>  #include <linux/pagemap.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/sched/mm.h>
>  #include <linux/shmem_fs.h>
>  #include <linux/slab.h>
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> index c6c64ba29bc4..07025b547c94 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> @@ -3,7 +3,7 @@
>   * Copyright © 2014-2016 Intel Corporation
>   */
>  
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/shmem_fs.h>
>  #include <linux/swap.h>
>  #include <linux/uio.h>
> diff --git a/drivers/gpu/drm/i915/gt/intel_gtt.h b/drivers/gpu/drm/i915/gt/intel_gtt.h
> index 9d3a3ad567a0..b54ee4f25af1 100644
> --- a/drivers/gpu/drm/i915/gt/intel_gtt.h
> +++ b/drivers/gpu/drm/i915/gt/intel_gtt.h
> @@ -19,7 +19,7 @@
>  #include <linux/io-mapping.h>
>  #include <linux/kref.h>
>  #include <linux/mm.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/scatterlist.h>
>  #include <linux/workqueue.h>
>  
> diff --git a/drivers/gpu/drm/i915/i915_gpu_error.c b/drivers/gpu/drm/i915/i915_gpu_error.c
> index a99b4e45d26c..ffe5f24594c9 100644
> --- a/drivers/gpu/drm/i915/i915_gpu_error.c
> +++ b/drivers/gpu/drm/i915/i915_gpu_error.c
> @@ -31,7 +31,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/highmem.h>
>  #include <linux/nmi.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/scatterlist.h>
>  #include <linux/string_helpers.h>
>  #include <linux/utsname.h>
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 790518a8c803..dbc634d10ad3 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -8,7 +8,7 @@
>  #include <linux/file.h>
>  #include <linux/fs.h>
>  #include <linux/pagemap.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/highmem.h>
>  #include <linux/kthread.h>
>  #include <linux/time.h>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 744a1fff6eef..c373d113f1e7 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -11,7 +11,7 @@
>  #include <linux/blkdev.h>
>  #include <linux/swap.h>
>  #include <linux/writeback.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/prefetch.h>
>  #include <linux/fsverity.h>
>  #include "extent_io.h"
> diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
> index a0187d6163df..b2aacf846c8b 100644
> --- a/fs/btrfs/tests/extent-io-tests.c
> +++ b/fs/btrfs/tests/extent-io-tests.c
> @@ -4,7 +4,7 @@
>   */
>  
>  #include <linux/pagemap.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/sizes.h>
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 22b43642ba57..f3122160ee2d 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -45,7 +45,7 @@
>  #include <linux/bitops.h>
>  #include <linux/mpage.h>
>  #include <linux/bit_spinlock.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/sched/mm.h>
>  #include <trace/events/block.h>
>  #include <linux/fscrypt.h>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index e87b3bb94ee8..2803511d86ef 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -7,7 +7,7 @@
>  #include <linux/swap.h>
>  #include <linux/pagemap.h>
>  #include <linux/slab.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/task_io_accounting_ops.h>
>  #include <linux/signal.h>
>  #include <linux/iversion.h>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 396dc3a5d16b..58f982885187 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -29,7 +29,7 @@
>  #include <linux/string.h>
>  #include <linux/buffer_head.h>
>  #include <linux/writeback.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/mpage.h>
>  #include <linux/rmap.h>
>  #include <linux/namei.h>
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index 6dd39b7de11a..0143365c07dc 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -11,7 +11,7 @@
>  #include <linux/writeback.h>
>  #include <linux/blkdev.h>
>  #include <linux/f2fs_fs.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/swap.h>
>  #include <linux/kthread.h>
>  #include <linux/delayacct.h>
> diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
> index 8c76400ba631..614e00b8ffdc 100644
> --- a/fs/f2fs/compress.c
> +++ b/fs/f2fs/compress.c
> @@ -13,7 +13,7 @@
>  #include <linux/lzo.h>
>  #include <linux/lz4.h>
>  #include <linux/zstd.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  
>  #include "f2fs.h"
>  #include "node.h"
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 338df7a2aea6..90e8ef625d82 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -10,7 +10,7 @@
>  #include <linux/sched/mm.h>
>  #include <linux/mpage.h>
>  #include <linux/writeback.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/blkdev.h>
>  #include <linux/bio.h>
>  #include <linux/blk-crypto.h>
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 74992fd9c9b6..ba0272314528 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -10,7 +10,7 @@
>  #include <linux/mpage.h>
>  #include <linux/sched/mm.h>
>  #include <linux/blkdev.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/swap.h>
>  
>  #include "f2fs.h"
> diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
> index e79ad087512a..dae3dc4ee6f7 100644
> --- a/fs/gfs2/aops.c
> +++ b/fs/gfs2/aops.c
> @@ -10,7 +10,7 @@
>  #include <linux/completion.h>
>  #include <linux/buffer_head.h>
>  #include <linux/pagemap.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/mpage.h>
>  #include <linux/fs.h>
>  #include <linux/writeback.h>
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 22c799000edb..2ec3e4231252 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -25,7 +25,7 @@
>  #include <linux/ctype.h>
>  #include <linux/backing-dev.h>
>  #include <linux/hugetlb.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/fs_parser.h>
>  #include <linux/mman.h>
>  #include <linux/slab.h>
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index dd0c8e560ef6..b400cfcdc803 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -10,7 +10,7 @@
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/errno.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include "nilfs.h"
>  #include "page.h"
>  #include "btnode.h"
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index 56c4da417b6a..a9d8aa65416f 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -14,7 +14,7 @@
>  #include <linux/page-flags.h>
>  #include <linux/list.h>
>  #include <linux/highmem.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/gfp.h>
>  #include "nilfs.h"
>  #include "page.h"
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 098a3bd103e0..6d62de64a309 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -19,7 +19,7 @@
>  #include <linux/freezer.h>
>  #include <linux/kthread.h>
>  #include <linux/crc32.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/slab.h>
>  #include <linux/sched/signal.h>
>  
> diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
> index 0f8e838ece07..2f79bcb89d2e 100644
> --- a/fs/ramfs/file-nommu.c
> +++ b/fs/ramfs/file-nommu.c
> @@ -14,7 +14,7 @@
>  #include <linux/string.h>
>  #include <linux/backing-dev.h>
>  #include <linux/ramfs.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/mman.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> diff --git a/include/linux/pagevec.h b/include/linux/folio_batch.h
> similarity index 95%
> rename from include/linux/pagevec.h
> rename to include/linux/folio_batch.h
> index 007affabf335..a2f3d3043f7e 100644
> --- a/include/linux/pagevec.h
> +++ b/include/linux/folio_batch.h
> @@ -1,13 +1,13 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  /*
> - * include/linux/pagevec.h
> + * include/linux/folio_batch.h
>   *
>   * In many places it is efficient to batch an operation up against multiple
>   * folios.  A folio_batch is a container which is used for that.
>   */
>  
> -#ifndef _LINUX_PAGEVEC_H
> -#define _LINUX_PAGEVEC_H
> +#ifndef _LINUX_FOLIO_BATCH_H
> +#define _LINUX_FOLIO_BATCH_H
>  
>  #include <linux/types.h>
>  
> @@ -102,4 +102,4 @@ static inline void folio_batch_release(struct folio_batch *fbatch)
>  }
>  
>  void folio_batch_remove_exceptionals(struct folio_batch *fbatch);
> -#endif /* _LINUX_PAGEVEC_H */
> +#endif /* _LINUX_FOLIO_BATCH_H */
> diff --git a/include/linux/folio_queue.h b/include/linux/folio_queue.h
> index adab609c972e..0d3765fa9d1d 100644
> --- a/include/linux/folio_queue.h
> +++ b/include/linux/folio_queue.h
> @@ -14,7 +14,7 @@
>  #ifndef _LINUX_FOLIO_QUEUE_H
>  #define _LINUX_FOLIO_QUEUE_H
>  
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/mm.h>
>  
>  /*
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 99b7209dabd7..4551613cea2f 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -9,7 +9,7 @@
>  #include <linux/types.h>
>  #include <linux/mm_types.h>
>  #include <linux/blkdev.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  
>  struct address_space;
>  struct fiemap_extent_info;
> diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
> index 4dc14c7a711b..a11acf5cd63b 100644
> --- a/include/linux/sunrpc/svc.h
> +++ b/include/linux/sunrpc/svc.h
> @@ -20,7 +20,7 @@
>  #include <linux/lwq.h>
>  #include <linux/wait.h>
>  #include <linux/mm.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/kthread.h>
>  
>  /*
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index e530112c4b3a..62552a2ce5b9 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -11,7 +11,7 @@
>  #include <linux/flex_proportions.h>
>  #include <linux/backing-dev-defs.h>
>  #include <linux/blk_types.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  
>  struct bio;
>  
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 6cd7974d4ada..63f256307fdd 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -31,7 +31,7 @@
>  #include <linux/hash.h>
>  #include <linux/writeback.h>
>  #include <linux/backing-dev.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/security.h>
>  #include <linux/cpuset.h>
>  #include <linux/hugetlb.h>
> diff --git a/mm/gup.c b/mm/gup.c
> index 8e7dc2c6ee73..ad9ded39609c 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -18,7 +18,7 @@
>  #include <linux/hugetlb.h>
>  #include <linux/migrate.h>
>  #include <linux/mm_inline.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/sched/mm.h>
>  #include <linux/shmem_fs.h>
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index db59fad3503f..51508573963d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -34,7 +34,7 @@
>  #include <linux/shmem_fs.h>
>  #include <linux/hugetlb.h>
>  #include <linux/pagemap.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/vm_event_item.h>
>  #include <linux/smp.h>
>  #include <linux/page-flags.h>
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 2f699c3497a5..1a92d16f3684 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -13,7 +13,7 @@
>  #include <linux/swap.h>
>  #include <linux/swapops.h>
>  #include <linux/pagemap.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/pagewalk.h>
>  #include <linux/mempolicy.h>
>  #include <linux/syscalls.h>
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 601a5e048d12..1009bb042ba4 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -33,7 +33,7 @@
>  #include <linux/sysctl.h>
>  #include <linux/cpu.h>
>  #include <linux/syscalls.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/timer.h>
>  #include <linux/sched/rt.h>
>  #include <linux/sched/signal.h>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d88c8c67ac0b..74b603872f34 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -31,7 +31,7 @@
>  #include <linux/sysctl.h>
>  #include <linux/cpu.h>
>  #include <linux/cpuset.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/memory_hotplug.h>
>  #include <linux/nodemask.h>
>  #include <linux/vmstat.h>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index cfed6c3ff853..149fdb051170 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -61,7 +61,7 @@ static struct vfsmount *shm_mnt __ro_after_init;
>  #include <linux/slab.h>
>  #include <linux/backing-dev.h>
>  #include <linux/writeback.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/percpu_counter.h>
>  #include <linux/falloc.h>
>  #include <linux/splice.h>
> diff --git a/mm/swap.c b/mm/swap.c
> index bb19ccbece46..2e517ede6561 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -20,7 +20,7 @@
>  #include <linux/swap.h>
>  #include <linux/mman.h>
>  #include <linux/pagemap.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/init.h>
>  #include <linux/export.h>
>  #include <linux/mm_inline.h>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 32d9d877bda8..a0c64db2b275 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -15,7 +15,7 @@
>  #include <linux/leafops.h>
>  #include <linux/init.h>
>  #include <linux/pagemap.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/backing-dev.h>
>  #include <linux/blkdev.h>
>  #include <linux/migrate.h>
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 12467c1bd711..df0b7a7e6aff 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -17,7 +17,7 @@
>  #include <linux/export.h>
>  #include <linux/pagemap.h>
>  #include <linux/highmem.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/task_io_accounting_ops.h>
>  #include <linux/shmem_fs.h>
>  #include <linux/rmap.h>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7effd01a7828..7e921dbe2373 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -44,7 +44,7 @@
>  #include <linux/sysctl.h>
>  #include <linux/memory-tiers.h>
>  #include <linux/oom.h>
> -#include <linux/pagevec.h>
> +#include <linux/folio_batch.h>
>  #include <linux/prefetch.h>
>  #include <linux/printk.h>
>  #include <linux/dax.h>
> 
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

