Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12C17FCE079
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 13:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 764CE6B008A; Thu, 26 Feb 2026 08:14:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722256B008C; Thu, 26 Feb 2026 08:14:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624566B0092; Thu, 26 Feb 2026 08:14:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0E16B008A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:14:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E7A91B5A3A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:14:17 +0000 (UTC)
X-FDA: 84486651354.20.B80D645
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 08ED41C0002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:14:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RkX1tfVZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZzDwtMmL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RkX1tfVZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZzDwtMmL;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772111655; a=rsa-sha256;
	cv=none;
	b=aBZzln1zcLJ/TT+UziFwGKvQH7HzfV2CUUty74UPQ2J+ZKE1q5V8SFBLzzrRcyfMtHjNaq
	sfL0qGT8P+BgeDg1A2BpGkdmGjsq5Tm1ukJgeWsP76TXcQy7gJIThsVeS9k3RYIWHHlNNK
	Tu5fg0L3zpPfZqkYp8axOlosNAhtYnE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RkX1tfVZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZzDwtMmL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RkX1tfVZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZzDwtMmL;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772111655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n1GVrJkaq5WHGx+GWTcqrATUrcyExqNgPTLvNqarQAI=;
	b=l0ZFBkxGBAVFkjFkv1AmUqxANHhqmMO3vbj9hs9bIlK0q756FWeOHGPr8G3lNdRlulZNEd
	89in+++vBkc2IEoDSTRCcOcrqHOhclKMiv6HF+HDkgVpt4Ka0Iws0Yhyxktu7nng/tLWgY
	kEpUXo/1CU4DdTU8hVHb9qb62t6I7LA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AFB261FAA3;
	Thu, 26 Feb 2026 13:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772111652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n1GVrJkaq5WHGx+GWTcqrATUrcyExqNgPTLvNqarQAI=;
	b=RkX1tfVZOKSFeTpXbKMSQrkjS8DiWF9dl6iG0MTuiEWPjIfb7l+c9Vxhe07l9C5XMYN+gq
	D6fFh6GAOsTvBGyrY/2NpAOu2pS+8IGxhGKqDfTKmEuBb//COrtz1HtBtOzt2lTFL1PkJf
	QFtiVqtzIrIdFKM9Z8uJ33qtde+B86A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772111652;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n1GVrJkaq5WHGx+GWTcqrATUrcyExqNgPTLvNqarQAI=;
	b=ZzDwtMmLuCzQkg6CPTLYsjjNmtRbjAn3ogJRQxgqjMgB86XX3cbyMVsTJCOONSEsgoVml5
	0daFFWnfXwuUsnCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772111652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n1GVrJkaq5WHGx+GWTcqrATUrcyExqNgPTLvNqarQAI=;
	b=RkX1tfVZOKSFeTpXbKMSQrkjS8DiWF9dl6iG0MTuiEWPjIfb7l+c9Vxhe07l9C5XMYN+gq
	D6fFh6GAOsTvBGyrY/2NpAOu2pS+8IGxhGKqDfTKmEuBb//COrtz1HtBtOzt2lTFL1PkJf
	QFtiVqtzIrIdFKM9Z8uJ33qtde+B86A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772111652;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n1GVrJkaq5WHGx+GWTcqrATUrcyExqNgPTLvNqarQAI=;
	b=ZzDwtMmLuCzQkg6CPTLYsjjNmtRbjAn3ogJRQxgqjMgB86XX3cbyMVsTJCOONSEsgoVml5
	0daFFWnfXwuUsnCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 995A43EA69;
	Thu, 26 Feb 2026 13:14:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9uNgJSRHoGkhSQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Feb 2026 13:14:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5EDF1A0A27; Thu, 26 Feb 2026 14:14:12 +0100 (CET)
Date: Thu, 26 Feb 2026 14:14:12 +0100
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
Subject: Re: [PATCH v2 4/4] folio_batch: Rename PAGEVEC_SIZE to
 FOLIO_BATCH_SIZE
Message-ID: <xcmjnkxgv5qzhqouj7dk3hqrd452crzosc74lyo53iqzeicepe@d6aoxuglacqo>
References: <20260225-pagevec_cleanup-v2-0-716868cc2d11@columbia.edu>
 <20260225-pagevec_cleanup-v2-4-716868cc2d11@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225-pagevec_cleanup-v2-4-716868cc2d11@columbia.edu>
X-Stat-Signature: tnym3m4y99dndb5qexgfb7rhkrbtu1wr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 08ED41C0002
X-HE-Tag: 1772111654-40079
X-HE-Meta: U2FsdGVkX1/DUlVsQwm+J1g+NJVx75nz4ex9PKoAEP5edcmSwm5oeMmuyMMYZdSty59hSqyeY7vmRYyKpTgF848qntPpnAaPZCDuY4OeeCpecex6ky8I81zk3nH6IovK4jWMHwBUUfenP2mzmURfMPDEieGL4Yv+EhFbfHIaF/KN/5FspSJTxYvEfceZ+yjmCkd2H00m5oJ05G9Sc8U3KlXIEmj4o5i3CpNyzxN+8CtQ2aLsqUW3efdNYXJOsgG40qvZJe+D4mTON5X1RQusO1VeYz3rU7uE3Mz+TIa/MbK0odr9H6FI3bm26W+PdAqcftHPQHMM4asv7tbUyOVid1xuJ9Iv21/atMdKmjuu6FITU+IL3hz7ByHCjW4aBB+sc8A+emqw++k21Lt9n3648JXbUZtfGQDuwn7czDbyrJOMY45os16R2bPPziA5yFAm5nC28uDAL7M8kOfoyJplxdinfZZ08Xquqy5aV7EzosuomMuz6PSiCRyo5kD0pym2ZDOfyrXDYc0kHFLpmeJpSOfEPAn7BCl+mkMBfPgJxnzJCEsQ36RjjtOKRU9eQrEnW7HjLpxkGab9ltHbyCt3lwbnVv9Qe2gYGMf6q7d64zWCAMdN1+FfFYNJ3w/ggJfVYbfFR9iI7Wtk06dCzMepOdGzzD4RQq+xZvEEx7Qqn4FJMpqno/wDMJrNTsBbM8epOjpfihCB/zaINIAARbm77O/lYoCuRC7klKt2s5zWCJcqiCvOezWk07OAH13eLB07WIgaygU9s0CifskuiGwaqdimfEHuV4j0OfngkaSXnGmgM1J0R3m5aptjjRBNLNwMGP1UQXxdEuykD8peUWXm0LpeDUz9TSGjZ3dsfEyltBvvC8Jq+vVIk7IFprj9+rp0Uciw7zx+S2OSCqhI5ecVF7Iba1FPCtrkNIhegQvKOepWkhUn8jXzj+ZpsHKD8le2BUSs4FfAOVnjb/9bTmS
 M2ybG5dk
 wt46iGgSfS8rycOtBLkKsRNitTQKH/X1IpP4VF2Wg+KYpp3mf3Dy4stpUdqIxqzp12kydgprF6NJWb/+lGCf75uptfFviIo7LL5cD3KUi0qoh/0k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 25-02-26 18:44:28, Tal Zussman wrote:
> struct pagevec no longer exists. Rename the macro appropriately.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/btrfs/extent_io.c        | 4 ++--
>  include/linux/folio_batch.h | 6 +++---
>  include/linux/folio_queue.h | 6 +++---
>  mm/shmem.c                  | 4 ++--
>  mm/swap.c                   | 2 +-
>  mm/swap_state.c             | 2 +-
>  mm/truncate.c               | 6 +++---
>  7 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index c373d113f1e7..d82ca509503f 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2095,13 +2095,13 @@ static void buffer_tree_tag_for_writeback(struct btrfs_fs_info *fs_info,
>  struct eb_batch {
>  	unsigned int nr;
>  	unsigned int cur;
> -	struct extent_buffer *ebs[PAGEVEC_SIZE];
> +	struct extent_buffer *ebs[FOLIO_BATCH_SIZE];
>  };
>  
>  static inline bool eb_batch_add(struct eb_batch *batch, struct extent_buffer *eb)
>  {
>  	batch->ebs[batch->nr++] = eb;
> -	return (batch->nr < PAGEVEC_SIZE);
> +	return (batch->nr < FOLIO_BATCH_SIZE);
>  }
>  
>  static inline void eb_batch_init(struct eb_batch *batch)
> diff --git a/include/linux/folio_batch.h b/include/linux/folio_batch.h
> index a2f3d3043f7e..b45946adc50b 100644
> --- a/include/linux/folio_batch.h
> +++ b/include/linux/folio_batch.h
> @@ -12,7 +12,7 @@
>  #include <linux/types.h>
>  
>  /* 31 pointers + header align the folio_batch structure to a power of two */
> -#define PAGEVEC_SIZE	31
> +#define FOLIO_BATCH_SIZE	31
>  
>  struct folio;
>  
> @@ -29,7 +29,7 @@ struct folio_batch {
>  	unsigned char nr;
>  	unsigned char i;
>  	bool percpu_pvec_drained;
> -	struct folio *folios[PAGEVEC_SIZE];
> +	struct folio *folios[FOLIO_BATCH_SIZE];
>  };
>  
>  /**
> @@ -58,7 +58,7 @@ static inline unsigned int folio_batch_count(const struct folio_batch *fbatch)
>  
>  static inline unsigned int folio_batch_space(const struct folio_batch *fbatch)
>  {
> -	return PAGEVEC_SIZE - fbatch->nr;
> +	return FOLIO_BATCH_SIZE - fbatch->nr;
>  }
>  
>  /**
> diff --git a/include/linux/folio_queue.h b/include/linux/folio_queue.h
> index 0d3765fa9d1d..f6d5f1f127c9 100644
> --- a/include/linux/folio_queue.h
> +++ b/include/linux/folio_queue.h
> @@ -29,12 +29,12 @@
>   */
>  struct folio_queue {
>  	struct folio_batch	vec;		/* Folios in the queue segment */
> -	u8			orders[PAGEVEC_SIZE]; /* Order of each folio */
> +	u8			orders[FOLIO_BATCH_SIZE]; /* Order of each folio */
>  	struct folio_queue	*next;		/* Next queue segment or NULL */
>  	struct folio_queue	*prev;		/* Previous queue segment of NULL */
>  	unsigned long		marks;		/* 1-bit mark per folio */
>  	unsigned long		marks2;		/* Second 1-bit mark per folio */
> -#if PAGEVEC_SIZE > BITS_PER_LONG
> +#if FOLIO_BATCH_SIZE > BITS_PER_LONG
>  #error marks is not big enough
>  #endif
>  	unsigned int		rreq_id;
> @@ -70,7 +70,7 @@ static inline void folioq_init(struct folio_queue *folioq, unsigned int rreq_id)
>   */
>  static inline unsigned int folioq_nr_slots(const struct folio_queue *folioq)
>  {
> -	return PAGEVEC_SIZE;
> +	return FOLIO_BATCH_SIZE;
>  }
>  
>  /**
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 149fdb051170..5e7dcf5bc5d3 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1113,7 +1113,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  	pgoff_t start = (lstart + PAGE_SIZE - 1) >> PAGE_SHIFT;
>  	pgoff_t end = (lend + 1) >> PAGE_SHIFT;
>  	struct folio_batch fbatch;
> -	pgoff_t indices[PAGEVEC_SIZE];
> +	pgoff_t indices[FOLIO_BATCH_SIZE];
>  	struct folio *folio;
>  	bool same_folio;
>  	long nr_swaps_freed = 0;
> @@ -1510,7 +1510,7 @@ static int shmem_unuse_inode(struct inode *inode, unsigned int type)
>  	struct address_space *mapping = inode->i_mapping;
>  	pgoff_t start = 0;
>  	struct folio_batch fbatch;
> -	pgoff_t indices[PAGEVEC_SIZE];
> +	pgoff_t indices[FOLIO_BATCH_SIZE];
>  	int ret = 0;
>  
>  	do {
> diff --git a/mm/swap.c b/mm/swap.c
> index 2e517ede6561..78b4aa811fc6 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -1018,7 +1018,7 @@ EXPORT_SYMBOL(folios_put_refs);
>  void release_pages(release_pages_arg arg, int nr)
>  {
>  	struct folio_batch fbatch;
> -	int refs[PAGEVEC_SIZE];
> +	int refs[FOLIO_BATCH_SIZE];
>  	struct encoded_page **encoded = arg.encoded_pages;
>  	int i;
>  
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index a0c64db2b275..6313b59d7eab 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -385,7 +385,7 @@ void free_folio_and_swap_cache(struct folio *folio)
>  void free_pages_and_swap_cache(struct encoded_page **pages, int nr)
>  {
>  	struct folio_batch folios;
> -	unsigned int refs[PAGEVEC_SIZE];
> +	unsigned int refs[FOLIO_BATCH_SIZE];
>  
>  	folio_batch_init(&folios);
>  	for (int i = 0; i < nr; i++) {
> diff --git a/mm/truncate.c b/mm/truncate.c
> index df0b7a7e6aff..2931d66c16d0 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -369,7 +369,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  	pgoff_t		start;		/* inclusive */
>  	pgoff_t		end;		/* exclusive */
>  	struct folio_batch fbatch;
> -	pgoff_t		indices[PAGEVEC_SIZE];
> +	pgoff_t		indices[FOLIO_BATCH_SIZE];
>  	pgoff_t		index;
>  	int		i;
>  	struct folio	*folio;
> @@ -534,7 +534,7 @@ EXPORT_SYMBOL(truncate_inode_pages_final);
>  unsigned long mapping_try_invalidate(struct address_space *mapping,
>  		pgoff_t start, pgoff_t end, unsigned long *nr_failed)
>  {
> -	pgoff_t indices[PAGEVEC_SIZE];
> +	pgoff_t indices[FOLIO_BATCH_SIZE];
>  	struct folio_batch fbatch;
>  	pgoff_t index = start;
>  	unsigned long ret;
> @@ -672,7 +672,7 @@ int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
>  int invalidate_inode_pages2_range(struct address_space *mapping,
>  				  pgoff_t start, pgoff_t end)
>  {
> -	pgoff_t indices[PAGEVEC_SIZE];
> +	pgoff_t indices[FOLIO_BATCH_SIZE];
>  	struct folio_batch fbatch;
>  	pgoff_t index;
>  	int i;
> 
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

