Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E52F0182B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B037F6B008A; Fri,  6 Mar 2026 06:42:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADB2B6B008C; Fri,  6 Mar 2026 06:42:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF3C6B0093; Fri,  6 Mar 2026 06:42:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B2D66B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:42:25 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36C6E13B176
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:42:25 +0000 (UTC)
X-FDA: 84515450250.19.67D5FAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A9305180007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:42:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VmPUWeBa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772797343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kEmVEpgowf0W6Vgf1W3oJX/C7Qq6rm8l/j/OBFgCVyI=;
	b=Vtz6bdq6bSJEvHJ1yORzFc4yp5SRNwrf2XU8PvMNGoS/9EPAFwy6i3fJx82IlsQdehtebv
	mE/wZq8v+K855c67pKwYwOTzVNX1GobgZVQ9xWMyMjiFc4aohwaAtX1zGLFrx5+gFHvEw3
	D6+7WaRgaWjpUf6Lpjxxb9BZJZud8WQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VmPUWeBa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772797343; a=rsa-sha256;
	cv=none;
	b=eZQqOec6JTl95bU82qGgqrGgG1QlGhqM83gc7FTo4yevu+GuV09phySofCd84TX4cjXjzh
	ac0UctVUs1ge1QUXwhwVvdEn8gKP0fuAMljE9XEQyQJ2NkUSgPRd1twoT1wy/wFg34bp8W
	ObmItQkfdxc0z767DhrEOFIw5YKGPhE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B4B9A60127;
	Fri,  6 Mar 2026 11:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4FAC4CEF7;
	Fri,  6 Mar 2026 11:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772797342;
	bh=CA2vkPrs+KBRPBb6HWrkcW5f3nw7u13fgvwPYP4Knsw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VmPUWeBaQkwHyNWrIgE+k6VTvF58sgBu9LcG+6SertLT2ce7KXBFZ0We86Id7A25U
	 Q+HpvLqR5cHvWiwcCko03D2oM0ZKE14Cr+BxZZDDmzCKdHkCFk9RqTfMemJZDDnloC
	 Ew767ufZJ7CKXy/CG6eJzT3vDrdM6zE9ZYv22SYiUP3CREBCfUFzOy3pucv0xCVXiW
	 9MsH74masuCdJlZ8BntBknVUwyKbUCdud5oUJoRnrzrGTDqUqCnck040huUBGNP38a
	 rVd+D+l7txMQlbfz48dBDZDt3rCVTj4/qKf0/Air3/s23aXm7SQiY2Tv5T9Owh5nxk
	 DlcAdpF9cammw==
Date: Fri, 6 Mar 2026 11:42:19 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
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
Subject: Re: [PATCH v2 1/4] mm: Remove stray references to struct pagevec
Message-ID: <3f262490-ebed-49b5-99ff-7a8aaa12cada@lucifer.local>
References: <20260225-pagevec_cleanup-v2-0-716868cc2d11@columbia.edu>
 <20260225-pagevec_cleanup-v2-1-716868cc2d11@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225-pagevec_cleanup-v2-1-716868cc2d11@columbia.edu>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A9305180007
X-Stat-Signature: tjztsubeyid6tpofdwmphpm9j79ow8kn
X-Rspam-User: 
X-HE-Tag: 1772797343-439503
X-HE-Meta: U2FsdGVkX19BC2DYfwtYkuGhuslNUcYVdhw14NWO5eDsBre9feEEG7MUrO9Ps1oCAWTtZL4LHLVSiQpIjDPJHSD21tH8dLWPdPpGp+JqLEB2E4p7YL4FeIP3h45B94MFUvOnefYQgPikUQA+NpMudL9R4rVxwitJ5Di8D/USPhYlM8NFD5k+TqNjYY86kiOrDU6ndvoX+ahhJGfoWM/iz2CiCaLF7nA+kTBlZYeqiFzWVvYhsNermjnmH5Y/r2eXf/W8x+x7uJIa3SZ1ZX25LUK2MpHuGj8I+THO5u9+Rjpau8Poz43S+bIFzzoHLe/bDeqlWdNFDS7fByqajFK6tKG0Z3QuqCSUP1lfbUPx7EAtcyte0VZ22tOww6jj7tUvJUKhsx2nuBZUyUwD1xdiIw1zqof5psBexGnIWpdxwBhJbYGaUMUknbdP0/vPMUsbviWjUYpsp8IgxvijCvWVq4R2i8AFXhM39zVz2JMOpqfVXCNTTwskW+zSlXIiYlVYxs53zWa+E7gLHG0D/3+tJD2xl1MSbMWeCNCFosSLPAJlyZd5F6eYwYw4ZOfWG7Ds3WMGYhSuj25AmQmzM54/JhMqOy7neOYUD+CJ89BklUPkcEYD9rcOQErtD31X9KBOoWYzjWKhFKlcBOsOJqPQ5RKGGsgR3AV57W9gT/7cV6Sf0YK1fRucz8Bf+SD1bIEmfqS9zodp5YFspIW9gdoVhBIfmpM4YxJaZ9kpfLHTziElUH1UBvLLXl1meFxgGUMdgGLLHLM0mGlTeSQ/wBsxSsvS7czc2moOGgxbgqK9twCbSQ/P2sYJJKz1y1xhZinDDTOMFa+6SpSX9j+M8TZ/loinIDNQBg+2ioao4ykvDYR1f9TBlF69CIuOoHpXJ/5xcDkQNLFsUgMZjSCf5vgDRrMA/qzws6mWx5mL6Pqt6chsWOWq8tjTzLOykoUUXqk2LSJeZyI7c23bXxhrAgo
 E6iN1hrA
 xwXbC2+gaCcFlT0LY48uHW3nm0csu8zQUyzK6QkrGkchf+nPuM/E0PXf8JaHZNH+74RupMboHTuZqhJ35lJ0ia2JkFVY59J+hOpsq6r+KZ94PMtEQFBx1KmZ6M6L1EBvQLC/HqCc93r6sNol0hSi8BAJ3oq575XGtox7x4I5Mks0cpFdaeAtPK66d90bnUF2EtznAc9Icy4bLCn7Cn3JuoKdJNqNVxsXq4Bu13VW3TpH74fWM+13zVRh6HWQ+UrLd6r4zGUWZw1w/ahqjEEphLbnRT3Wk5lfZ39nuSpUBH+uhR9OojJ/gqpIzGXjr/VlFlioBSt+ZIxTEglEXfFJbKOtEhSzO1XhDSfVUBrE5oCQZFcHwPZqwBG9G08tF28JhRiZEZyIQbWJUA13OaCbGFQ+Mpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 06:44:25PM -0500, Tal Zussman wrote:
> struct pagevec was removed in commit 1e0877d58b1e ("mm: remove struct
> pagevec"). Remove remaining forward declarations and change
> __folio_batch_release()'s declaration to match its definition.
>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  fs/afs/internal.h       | 1 -
>  fs/f2fs/f2fs.h          | 2 --
>  include/linux/pagevec.h | 2 +-
>  include/linux/swap.h    | 2 --
>  4 files changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/fs/afs/internal.h b/fs/afs/internal.h
> index 009064b8d661..599353c33337 100644
> --- a/fs/afs/internal.h
> +++ b/fs/afs/internal.h
> @@ -31,7 +31,6 @@
>
>  #define AFS_CELL_MAX_ADDRS 15
>
> -struct pagevec;
>  struct afs_call;
>  struct afs_vnode;
>  struct afs_server_probe;
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index bb34e864d0ef..d9e8531a5301 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -28,8 +28,6 @@
>  #include <linux/fscrypt.h>
>  #include <linux/fsverity.h>
>
> -struct pagevec;
> -
>  #ifdef CONFIG_F2FS_CHECK_FS
>  #define f2fs_bug_on(sbi, condition)	BUG_ON(condition)
>  #else
> diff --git a/include/linux/pagevec.h b/include/linux/pagevec.h
> index 63be5a451627..007affabf335 100644
> --- a/include/linux/pagevec.h
> +++ b/include/linux/pagevec.h
> @@ -93,7 +93,7 @@ static inline struct folio *folio_batch_next(struct folio_batch *fbatch)
>  	return fbatch->folios[fbatch->i++];
>  }
>
> -void __folio_batch_release(struct folio_batch *pvec);
> +void __folio_batch_release(struct folio_batch *fbatch);
>
>  static inline void folio_batch_release(struct folio_batch *fbatch)
>  {
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 0effe3cc50f5..4b1f13b5bbad 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -20,8 +20,6 @@ struct notifier_block;
>
>  struct bio;
>
> -struct pagevec;
> -
>  #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
>  #define SWAP_FLAG_PRIO_MASK	0x7fff
>  #define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */
>
> --
> 2.39.5
>

