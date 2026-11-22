Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 339BC606A682
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=VZ27ky9e
Received: by kanga.kvack.org (Postfix)
	id 1FCB86B05CD; Sun, 22 Nov 2026 13:45:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AAEF6B05CE; Sun, 22 Nov 2026 13:45:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023086B05CF; Sun, 22 Nov 2026 13:45:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA39D6B05CD
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:41 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B2141606FF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:41 +0000 (UTC)
X-FDA: 85463633682.29.74F1B28
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 760A420007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VZ27ky9e;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373139;
	b=508Hmx5jhngDgIZk8yHS8CRVBivOYcU5+hfVJAgvlOMJwjWRVZb/1fQyrysMGpKHlKGmQN
	ARHjszZo7qAGk9n9Na+9mQEBl87nlsCJtXT7hE8OGEgMjPXhhnaGQeM1qaZxPiaDomIO2F
	ShggbHrNkfusFu2spqPqrmVDAO8J9KA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QIe+i9eK2zr3QCsqOe2BUenoQBuWEgVrfsYe7q090kc=;
	b=aPDUP6evhYkecxGKF+rFgPChy5daI556KKDTHqga05E7Lp8YJIR4Tl3LUe9JTpUkwOSoDt
	z3Aahe6oXZNG7F0GCHS9mb+IUyf2hZrikn9DKyJIYnVnVpVr90hEZWKHsjNWF19hwrZLYk
	coumCHXShNKYPBdYlDIae1k3SASu8lY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VZ27ky9e;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-921375f52b8so28593446d6.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795373139; x=1795977939; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QIe+i9eK2zr3QCsqOe2BUenoQBuWEgVrfsYe7q090kc=;
        b=VZ27ky9euNbRAKhOvoJZYv7Sbl6mxpZ5vG7mHzH7C6IbZ422ss138s+AuscxvHibEe
         hZarIeiwaCV0MoJxrf3AzeEy5bmm99Jo96FMiQvCYCsd99XulAfxoUKsBci9HQG4ljj5
         Da9iUZYO9h/CG2XgVmO5zSzOFeUmH5adqyyzhVVULKWyw5oJwe7DisJwZzAN9qmz0c53
         fPCeGeIO4kD5z9r4QxNxjsfmDxpNjVrqYjpwsLVQhEk+kSxvqkrj9j5PsJ1ZNH0xdBbl
         iySHUjfkS/lNuUd9qekQAkLONRBwWzFrJr6Aa+zwC0Q9zLdXzY1BW48IEADxzHJ24JyB
         i9sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373139; x=1795977939;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QIe+i9eK2zr3QCsqOe2BUenoQBuWEgVrfsYe7q090kc=;
        b=Gc4re9PBaxFmj3Xx0BpPi1hJq16WtJnopSNYMTrc/xL+INwz9dw4izJquEisDDWCJh
         fZxNHhRZoGrsNUMCWSWU+EvS09uZqrbcNe9lxuhG36FmG9UmkGkVXZjj6moE7LyWXZ32
         I1iu1PjvfP6V8v7sslW22C+kWz6PYLmaym3rgLw/8vofnCUXfQqGoGMrw/d0gkddnF4U
         krvdZPf4FC1QY+9MephVFUkmNjgu3Y1u1t0m0WX8J3zKBtOD4POcgA/VH7zzjs/ni8Q+
         NfgdvNaYujqrzL62DOCQjt4U6m4oJTx/oIvzAvmxxobWu/oGxmzEzOV7ueRPJr1oxmAQ
         4Gww==
X-Forwarded-Encrypted: i=1; AL+hErF6OO/TxYedPmIkQslpLEVRaUUAel4MB/Xub6KFTJpgSN5R23C9bCXp39kNdCTdf5XP364X2AJO4g==@kvack.org
X-Gm-Message-State: APuU4Z829TKYO6XbTHx3LHBa9L4xmbJXx+SQfKe0Kfneg+vGAyVJxiyp
	TeZT8/mshlmJMHpzNkxaodEJcmP5UGLgWHKVVqnFdyujV6x1j7V54Ox9sMhOU0snCBc=
X-Gm-Gg: AZFdTZe8iZam3KRGTDDKj7w37BMPXUX2LN+WkWZ92e2FP+4ZPlBKhMZGN2avOOXo2tz
	IlfPBAEG9nGkdbWkC7feasDUdzy1+Ko4uXenNYHcLYoWvjrhQ9H1NXJtGNaQw3LIcOH/2AioKBU
	DmcaoTgyJBcBmcboFVC2xHkBZLHdCUhLdc09OCZan7kSTOB/blFjbwy+GX8mPLpNHoOGd1PIyAQ
	2A/jN3qxrwgazv2bxOA/T5IatONSR0gb+GT6vWpXhWbZ+9RPEFHQS+uo3QkL8t8+UnOtzNrVQWQ
	swYM9SdLiL8O1cz/ry9POoYKovxvq/5jVMdMYvjoWz5zd8RCuIJkHzVrM6+JxLoGopNfcG2OyNS
	f3s86YbBkjZJwCjfndseNpvZSrXqHITli/lgNLctRGd/ingMFEelYY4r+/3Cme6yNJg9HXDyZ9B
	lQ+mebCfvG6iewlRhULlPjZbrZ86X/qPWyPPzGvjTdvrlMYVG3l1HRBSDwM0nLk9H/WPrChBRAQ
	og5gHPFax8krpOCiILBiVpO8yK6CBiRUkLeCEvwOMJoA5ltx71nnB7Jqwwky6jzSur9iRuLEsP0
	wKCnhbeBd00nREafnGqHb27J7zjgypX9RloJP0hK6fyopkx/FWKtlTYSFBy35iJU5TYMCIN09E/
	qnbjGU7M=
X-Received: by 2002:a05:6214:ac3:b0:921:3a0b:673f with SMTP id 6a1803df08f44-9213a0b67admr141234506d6.7.1795373138655;
        Sun, 22 Nov 2026 10:45:38 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349cd592sm86571036d6.16.2026.11.22.10.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 10:45:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] mm/huge_memory: use NOFS when allocating while
 splitting folios
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Heiko Carstens <hca@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>
In-Reply-To: <20261122-migrate_reclaim_deadlock-v1-1-83c56185b0fb@kernel.org>
References: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
 <20261122-migrate_reclaim_deadlock-v1-1-83c56185b0fb@kernel.org>
Date: Sun, 22 Nov 2026 13:45:37 -0500
Message-Id: <179537313704.412063.6683001223228002260.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 760A420007
X-Stat-Signature: hicgp7879i5bpq17g7qi8p5qxijnyr6t
X-HE-Tag: 1795373139-956836
X-HE-Meta: U2FsdGVkX18juwktPbh9aR68DBQkgJc/1wqV7cm6CZHV3qHEDAKY/Hc33x/yOWUiQwDVUCUfysVDBYjqcmExsQ3daCB/cidp4ZZIwAPPB5iOhNknH+Pz5aSL1O3NJj1epz8/nm3kyCDiK9iuNhZbhDS819OKhQ2XwYsb0OI8LTnDoRbMZNDkjHBCYoeKwuZq5jeg8Oh/oXA2OrtxjllpKBgfi0+Kni+G9tlnx2NtOnzABQHm49ze2n3ZTnCfr7LMYw0azKd/PgmHUq0zZ0x5j6G92JFC9X2j2niakUpqcLHnoucJSlGpm+hIlvpEbYEo5AP5b/9UmOeIX8JpKx+0Qu30qsLoZ9Hy6Ora//lYFe5gpxbmoudumnwUrs0tmdcNUm/6XaKjG7isAsqm8I9YnENsSQxuAWgPH6/eXhjmPzRwzZIgkqZdMC9lY6wD5JEQCjydDBKoF0oT868AXUcj20tR7mAdAhYjjDc6LZG1/M6c+ystAD4L2fITomsk6So5iNd1aqPPoVpR4VYCH6TypB3ByfN37CKu5IiN1LxlY0psZRvBdNVSr0sN0m5VwMZ08qNdlr2jnYxachlMnnDUch9k+qjcAfk+AU9xLpZkBtCdsk906o1CMKH+8Dgk4jihqOPFSi3TO5WgakqGY/o5g+25ucGHdgPrwQm8yVT2AYRDkiX7GFkeAy89XthNOvibzRT/mL4tp/8LfuTnsTjC5X18ZQkLAX+A9Cfl/Rk9D8VikDXO6GRB4f9bmEglokMDnG3mM2NrEyzMeUa/62cB+TzFGNHNUJt5iuVvdhCv/crWjnhSAVC61jbinUQ+hAytmdga8rOTK+mFvZcgbUmPoMxkBVclQbL8ADiK8eGWmqMMBv6DjnuaXcNDKoBO9HFZH2CKgVnSfIbC8E0ATCdnqKs1Yc6BuQZdLL97NTPHBhypAipp2uCM7rKZlBxTwmqsU/vGfxo6tMD9jMeVQ3d
 HrjPSy8J
 VQ8pzzHG1ryC8vIylw/0sT0dJhWsOSA82l1B/1QHOJbOl0lr+oLVEVgBWezvNKCkwaUZxfJ13bGHjVte/fFdqtyYNWENe8lNhlS+D3/Thp9+xd3gsADXEq44OOXK30049I/OP+rQWu3bf2ldTc9bvj5QVfN+zN1/hjtkvMTSbNUlxcYy+S2DGmWkiHQWKUk+cwk90aAibmyMs7jfSKPgA4LCsGp7NWODgE3yM2dFNq0Q2pk/iGVfjbP+XVXkRN0PpCrkGGv/shqVrvSTVuXUuPVFp3KVIbzH01+m3tnBMp6LmFEk6CB+1fdQnYr8XiZwTCo2DX3XG3Y7wuuXMEoZkA1OQ7X1OQjLerEaRh+eSEdp1W+zzv2z02TOfg6lMq3l2y3Rr3ki2jz2g01vrvBsw8EWizvyeSP/YD+tDwpmZdE8WaaKUNrLl3jnN4KglR60HL8GhxhaLF41wtFwHsJF0B+56A7MlyaScRBSFqtDR0MKoiJPGspFeWmUDI+ZutWpLBsAntzOsxpKm3VxAgTiFoXCB53u72j5t8QWi3DWTMrppWLxOOsn6quYBrt+eTBWAAFg6aOKo76KZ6NS/bdtG6EvgDBBaiQP7M0XGc1yUoP5KSYNCOdRYWfRPTr/iBUxWhrl4oXnZbEIUImc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-22 13:42 +0100, David Hildenbrand (Arm) wrote:
> Various callers (migration, memory-failure, s390_wiggle_split_folio) split
> locked folios without holding a reference on the folio's inode.
> 
> Splitting a file folio might allocate memory for the xarray and call
> filemap_release_folio(). If either ends up in direct reclaim with
> __GFP_FS, reclaim can evict the inode through the dcache shrinker, and
> wait in truncate_inode_pages_final() for the folio that we hold locked:
> 
>     try_split_folio()
>       folio_lock(A)
>       split_folio_to_list(A)
>         xas_split_alloc()
>           try_to_free_pages()
>             super_cache_scan()
>               prune_dcache_sb()
>                 iput_final()
>                   evict()
>                     truncate_inode_pages_final()
>                       folio_lock(A)
> 
> This requires that nothing else holds a reference on the inode, and can
> be triggered most easily with FUSE, which evicts inodes on the last
> reference.
> 
> Further, xas_split_alloc() charges the XArray nodes to the memcg, and on
> cgroup v1, memcg reclaim waits for file folios under writeback if
> __GFP_FS is set. That can deadlock if writeback waits for a folio lock
> that we hold, for example with ext4.
> 
> Let's fix it by splitting folios in a NOFS scope, so callers don't have
> to care. A NOFS scope also covers allocations that filesystems make with
> their own gfp flags, for example in filemap_release_folio().
> 
> On NFS, splitting folios with pending writes or ongoing writes to
> fscache might now fail slightly more often, until these writes have
> completed. On netfs, only folios that are being written to fscache are
> affected. All fairly irrelevant.
> 
> This has medium urgency.
> 
> Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
> Fixes: eef88fe45ac9 ("s390/uv: Split large folios in gmap_make_secure()")
> Fixes: 789763523fb4 ("xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reproduced the hang determnistically.
Base deadlocked.
With patch 1: -ENOMEM (safe)
With patch 2: split succeeds

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


