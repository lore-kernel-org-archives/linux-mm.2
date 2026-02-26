Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0FE5FCE07A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 13:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2EBC6B008A; Thu, 26 Feb 2026 08:13:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDCBA6B008C; Thu, 26 Feb 2026 08:13:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBDFC6B0092; Thu, 26 Feb 2026 08:13:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B6B1E6B008A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:13:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 382BA160172
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:13:00 +0000 (UTC)
X-FDA: 84486648120.20.0B854EE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id B8F1E40010
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:12:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VGr+5vEt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=69XqZjby;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="F9/qrZcg";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uMdyIKIf;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772111578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9pIdsXl9YcbrN7MEcIZiwr5nHNouAJ8lo4fxykwpls=;
	b=G8ycmVBfWlmHlfRljP9a5TiSgUtXHmJLDIDcNoj+nzAqkitRALq5czXnuR/abCclHtLS0Q
	AaB0/4D686skxRPK88Z1fRkCOVpHnOXNT3ajuj/dKMv2N/bwCOyrT8sHgsGCciNp6Ad5b0
	eo62FPBLhdezGGChA5C0mq372BWXlqk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VGr+5vEt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=69XqZjby;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="F9/qrZcg";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uMdyIKIf;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772111578; a=rsa-sha256;
	cv=none;
	b=rakMW4c9devSTliLjSs/X5hHhuc4lNUFEmA6P4AaczzaF+olivKcEG8f96R5VLPPZfIFwj
	FY8A520KwL8Mtq2pqmO4GuhhC80D/zZZ7811ehXzHE49DXGrobfuzd2TWEZ+Z1ggK/Pizj
	f6B3eTRvoxQvnqI4sukwtnlDxzuOiU8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DFCBA4016B;
	Thu, 26 Feb 2026 13:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772111576; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t9pIdsXl9YcbrN7MEcIZiwr5nHNouAJ8lo4fxykwpls=;
	b=VGr+5vEttV5KSq8KiEHuA26h/lUE7LlTpKXuEPlZT6DHY8M0THqc8Wu4WiiN1rMKTDa6OR
	5Zwq7W2zP5J9H2ZZtsgp7HFYiY7A5pTLtjNy0TniXfJ1K1ZfjtmltW1AfqY66XIH5dEDdF
	VeWG6x2cAMoVE/5vHhJrUfeSClIjrGI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772111576;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t9pIdsXl9YcbrN7MEcIZiwr5nHNouAJ8lo4fxykwpls=;
	b=69XqZjby1BkpPQKJs37ti4jhyJiLv1OPj8pDlz96Ez+SqXyH4PTF7HJvtJR1jjG+ILIaff
	xw7ztXeG0NlBlDCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772111575; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t9pIdsXl9YcbrN7MEcIZiwr5nHNouAJ8lo4fxykwpls=;
	b=F9/qrZcgGN/hgxgLb3qI//qiHnxBKsB5Ntd3IGQuMTlxZWdr2ZN0mP/0xmZRIkCuKafDWW
	+xk6zJK7T/iYLhGjEM5isA7Eem1B8k1QXrKcyY15lvatrlOTH99iXwpZ6R10io+b8DM7zy
	RLtfnL1PTllGjvJOTHiKeaQnegihWz4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772111575;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t9pIdsXl9YcbrN7MEcIZiwr5nHNouAJ8lo4fxykwpls=;
	b=uMdyIKIfyG5+TXpjkra12NBuPmWqX7KgZp3+we3ktt8NePQQXrpbFT4ToI2DhSA7MGpiSM
	FOl4NQaT3QPKQJDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC4D53EA69;
	Thu, 26 Feb 2026 13:12:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gY5oMddGoGklSAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Feb 2026 13:12:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8CCF6A0A27; Thu, 26 Feb 2026 14:12:51 +0100 (CET)
Date: Thu, 26 Feb 2026 14:12:51 +0100
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
Subject: Re: [PATCH v2 2/4] fs: Remove unncessary pagevec.h includes
Message-ID: <hulhfdnrv4bbm6nvy3x4xbuxmc5ypmhpwdpt3jurfkibq5t2pu@6dcvs2uzzr46>
References: <20260225-pagevec_cleanup-v2-0-716868cc2d11@columbia.edu>
 <20260225-pagevec_cleanup-v2-2-716868cc2d11@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225-pagevec_cleanup-v2-2-716868cc2d11@columbia.edu>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B8F1E40010
X-Stat-Signature: nq97sg878bceyefixk3h8z81nwf5yib7
X-HE-Tag: 1772111577-77763
X-HE-Meta: U2FsdGVkX19R/jSuSkK9qzJJttDcFntyJ6zzunRAqkSxEVBQzQu8RtAJY75teCZVWWG27p9y9IDfF33Rv3gQgwYeVEQ8LSymz8wv1qmut/8kz0/I7xqe2gNAagrZtkp590NyxNXK+IHa2N6QtsDf/zm/zk4SbGJ6Krz8dh1qWMXGsfJUrxWAXXKZ/XBBCdunPsUIlySyzS3FE/NE5B8AaSzvT73cEv/1RyeqvibUJGrGChgPesAKDlNGYXQwp9fRJq36bz9wugcq1h843e1Ls73ucNboMed1rEdG5tepHts07xWYfnsQhFbSal6KFPERDAIjjNA5Xx+N0bcOw+kpu1GlSnKrU8RHeSpfg1bQyUK6J/qvLGouyjTo1icFeAxQJV7A/rIQNMf9YALJZOawDifiG6kN86ETMB5029nkZDad1jUePZCC6lsbbNgJddHHMS3/JpLyZd6YCg8wyS2v2/oefsc5hg9306jbdHu3P0x0KzDqt6Smg1o32TWIXZciWY10uke1KURTyJhRFTB4ojh1sMOEWUYOIUxRvnd1SuqcNGvTgh6DaS0EQ/dDvtBpJYSygmRQE0xo1j3VoBWaDmLA9GKBNxwZCheKrwINEFeXazHbIMLGethE/920Ysivi359gXFTLlf7d68bU44IxLHw31kLE0JgKOgSwQ2KXmye7w54wqodO8Y+v/omeD/9uBVCVA2H6xi6f6UXyrmxWCGo3+u9rWJgCCz1Czg5WqlmMNRC+ZAY+VCorHpxXmxREkvpj85W5etFFSjWiN0FH1LIZy2jk/oNwTwrrgvWPoKd78pmkNPcK1wB8yGe4LFRl8UcWQJx560caIO6b/cYe3MA9BV8nyuCb2Gxe5MsqIts1XkvtgU2TK9qO5CSSgCLzgK1GW3xCd719vZJ3c2TJYTmwNjyVILTvwfO3iR1jMVOIgy8bC7mgXMGOsog3xsdyEocwJQzXD7IISoIJXO
 7MEHI3kc
 zkVbMrKv5BVZ37rqzAljRwGNcBYpg4KBNV3d4Fx2JrhAPMAU6pSHcxrZKBJTl4XGYiQcmAiLUbxBpd4fx5r3PuolDLFhYZKfc9DCR+AshByL+cNtewGtjJRjVQS+NVxk4ZO76tGcT/Cp/zk8rNvmoxa9YCnEpjsdJDuXziisK8iVWec775kefGwt/5RMW9wzSfzz6Imm3vJZLnb6bneXI6ACTKHn3xcwTdnCsnQ3XhhOfw7EDh9+HSHN/B7go7UhMtGKxCykisRqDsXh6WwIwbOXqw4c1HFUS67vn+veRqHjqz6uxAyPHc1CqTXYhyQfDqJ4dseVXpsGYFhbtE0HnRgdYGfZxQWnAtunkG8cRxXB64k+dioDSuEDpecx9sdIHBii45fVU8zxHIrBEBM7feRYlNnHoeqxQs21rviSLSnIyojFbn5UAgAb1rlr+SMuIHCDQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 25-02-26 18:44:26, Tal Zussman wrote:
> Remove unused pagevec.h includes from .c files. These were found with
> the following command:
> 
>   grep -rl '#include.*pagevec\.h' --include='*.c' | while read f; do
>   	grep -qE 'PAGEVEC_SIZE|folio_batch' "$f" || echo "$f"
>   done
> 
> There are probably more removal candidates in .h files, but those are
> more complex to analyze.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

If it compiles than it's nice to get rid of. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/afs/write.c                   | 1 -
>  fs/dax.c                         | 1 -
>  fs/ext4/file.c                   | 1 -
>  fs/ext4/page-io.c                | 1 -
>  fs/ext4/readpage.c               | 1 -
>  fs/f2fs/file.c                   | 1 -
>  fs/mpage.c                       | 1 -
>  fs/netfs/buffered_write.c        | 1 -
>  fs/nfs/blocklayout/blocklayout.c | 1 -
>  fs/nfs/dir.c                     | 1 -
>  fs/ocfs2/refcounttree.c          | 1 -
>  fs/smb/client/connect.c          | 1 -
>  fs/smb/client/file.c             | 1 -
>  13 files changed, 13 deletions(-)
> 
> diff --git a/fs/afs/write.c b/fs/afs/write.c
> index 93ad86ff3345..fcfed9d24e0a 100644
> --- a/fs/afs/write.c
> +++ b/fs/afs/write.c
> @@ -10,7 +10,6 @@
>  #include <linux/fs.h>
>  #include <linux/pagemap.h>
>  #include <linux/writeback.h>
> -#include <linux/pagevec.h>
>  #include <linux/netfs.h>
>  #include <trace/events/netfs.h>
>  #include "internal.h"
> diff --git a/fs/dax.c b/fs/dax.c
> index b78cff9c91b3..a5237169b467 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -15,7 +15,6 @@
>  #include <linux/memcontrol.h>
>  #include <linux/mm.h>
>  #include <linux/mutex.h>
> -#include <linux/pagevec.h>
>  #include <linux/sched.h>
>  #include <linux/sched/signal.h>
>  #include <linux/uio.h>
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index f1dc5ce791a7..5e02f6cf653e 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -27,7 +27,6 @@
>  #include <linux/dax.h>
>  #include <linux/filelock.h>
>  #include <linux/quotaops.h>
> -#include <linux/pagevec.h>
>  #include <linux/uio.h>
>  #include <linux/mman.h>
>  #include <linux/backing-dev.h>
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index a8c95eee91b7..98da200d11c8 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -16,7 +16,6 @@
>  #include <linux/string.h>
>  #include <linux/buffer_head.h>
>  #include <linux/writeback.h>
> -#include <linux/pagevec.h>
>  #include <linux/mpage.h>
>  #include <linux/namei.h>
>  #include <linux/uio.h>
> diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
> index 830f3b8a321f..3c7aabde719c 100644
> --- a/fs/ext4/readpage.c
> +++ b/fs/ext4/readpage.c
> @@ -43,7 +43,6 @@
>  #include <linux/mpage.h>
>  #include <linux/writeback.h>
>  #include <linux/backing-dev.h>
> -#include <linux/pagevec.h>
>  
>  #include "ext4.h"
>  #include <trace/events/ext4.h>
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index c8a2f17a8f11..c6b6a1465d08 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -17,7 +17,6 @@
>  #include <linux/compat.h>
>  #include <linux/uaccess.h>
>  #include <linux/mount.h>
> -#include <linux/pagevec.h>
>  #include <linux/uio.h>
>  #include <linux/uuid.h>
>  #include <linux/file.h>
> diff --git a/fs/mpage.c b/fs/mpage.c
> index 7dae5afc2b9e..e5285fbfcf09 100644
> --- a/fs/mpage.c
> +++ b/fs/mpage.c
> @@ -28,7 +28,6 @@
>  #include <linux/mm_inline.h>
>  #include <linux/writeback.h>
>  #include <linux/backing-dev.h>
> -#include <linux/pagevec.h>
>  #include "internal.h"
>  
>  /*
> diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
> index 22a4d61631c9..05ea5b0cc0e8 100644
> --- a/fs/netfs/buffered_write.c
> +++ b/fs/netfs/buffered_write.c
> @@ -10,7 +10,6 @@
>  #include <linux/mm.h>
>  #include <linux/pagemap.h>
>  #include <linux/slab.h>
> -#include <linux/pagevec.h>
>  #include "internal.h"
>  
>  static void __netfs_set_group(struct folio *folio, struct netfs_group *netfs_group)
> diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
> index cb0a645aeb50..11f9f69cde61 100644
> --- a/fs/nfs/blocklayout/blocklayout.c
> +++ b/fs/nfs/blocklayout/blocklayout.c
> @@ -36,7 +36,6 @@
>  #include <linux/namei.h>
>  #include <linux/bio.h>		/* struct bio */
>  #include <linux/prefetch.h>
> -#include <linux/pagevec.h>
>  
>  #include "../pnfs.h"
>  #include "../nfs4session.h"
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index 2402f57c8e7d..0d276441206b 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -32,7 +32,6 @@
>  #include <linux/nfs_fs.h>
>  #include <linux/nfs_mount.h>
>  #include <linux/pagemap.h>
> -#include <linux/pagevec.h>
>  #include <linux/namei.h>
>  #include <linux/mount.h>
>  #include <linux/swap.h>
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index c1cdececdfa4..b4acd081bbc4 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -31,7 +31,6 @@
>  #include <linux/blkdev.h>
>  #include <linux/slab.h>
>  #include <linux/writeback.h>
> -#include <linux/pagevec.h>
>  #include <linux/swap.h>
>  #include <linux/security.h>
>  #include <linux/string.h>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 33dfe116ca52..9e57812b7b95 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -20,7 +20,6 @@
>  #include <linux/delay.h>
>  #include <linux/completion.h>
>  #include <linux/kthread.h>
> -#include <linux/pagevec.h>
>  #include <linux/freezer.h>
>  #include <linux/namei.h>
>  #include <linux/uuid.h>
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 18f31d4eb98d..853ce1817810 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -15,7 +15,6 @@
>  #include <linux/stat.h>
>  #include <linux/fcntl.h>
>  #include <linux/pagemap.h>
> -#include <linux/pagevec.h>
>  #include <linux/writeback.h>
>  #include <linux/task_io_accounting_ops.h>
>  #include <linux/delay.h>
> 
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

