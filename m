Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B53A606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fQmtHonw
Received: by kanga.kvack.org (Postfix)
	id 45D186B05B0; Wed, 28 Oct 2026 06:43:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40D866B05B1; Wed, 28 Oct 2026 06:43:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300426B05B4; Wed, 28 Oct 2026 06:43:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF25C6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:43:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D204B1A092D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:43:47 +0000 (UTC)
X-FDA: 85371699294.18.D849671
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 061B81C0005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:43:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fQmtHonw;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793184226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PEXPx1f1v6I2CjAMNLRcdHwCcztH0pJkRVk37TqP40=;
	b=QN5kLR1JZKFfomtaADcEXIlFsQigbB4R1250dM66r1jvYbfoIwzNBOWem9M3s5P7uDrm+S
	/qu1R0mTGYyv/3PTgfxwNTrGY8tA6/gqfRBfL7MxXdvRLidQTZwq0pcIL2leSP4x89eipO
	C1ienOSRb7WYpaIC8pRRqyyyaa+B+GQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fQmtHonw;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793184226;
	b=d6aPUAlYLy+mYf6MO+Rcc9e7b6vU9HB4YORI3lAZ3CkwQYo33rPH7bq3KdFp9lZCqGruV6
	JvcNcTvGdqvt6z/uaWMM1Mq/vuxouYBmhH76HICagOhX+Mhw4HUvjI00P9ykY1yiKUgnFy
	hMNB6Q/gGMt2Locs7ihdq7YwCCLBGKA=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e5fb79ce82so5097575ad.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793184225; x=1793789025; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9PEXPx1f1v6I2CjAMNLRcdHwCcztH0pJkRVk37TqP40=;
        b=fQmtHonwyvvWrlHd3qWfneAlhFAbih3U/ya2crpqI7kycDmk8icXQtQdVBdBnHmsOj
         jXfevfysCSu89ShXGlR/8Q+BA1rOR0NI5XuywxK/F0lh2d8OPpmt/udlczCMQGjwPYdw
         ktTRcN3/S4Cs2Ok0NoWRlW7Wl3Gffuy7sLROXCQRYjvPrx/u+//QPDRz7i6aId3/COd4
         i+0tSlSCcMbcKuvPX9qjorD6eychZJUKcp+6gBmfo8X3N8jOo+FX5yLj0aiwTgcUg8+I
         gaPyuug41zB+mjOAIAqj8NvDoVVlexz2RpeyGfn1JyzwQqOsnVLeIInXuov0vMBk4sLw
         AwOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793184225; x=1793789025;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9PEXPx1f1v6I2CjAMNLRcdHwCcztH0pJkRVk37TqP40=;
        b=MJhkQepLr36AcVME4/LaXXhiKLZgN95Da/zhIvShUVK3NDTp79BF4BCTJQ+6/7gyHx
         oIk5d1QwM3PFMyTS0vXNYkOANxLySNz/XDwIZdMZunFJvODjMBlSvFzF5033hHFBydsA
         Gmi0ilTEgHj6GOySZJWWFiliSnFnnrX7ZW5t+U1jKPmQ0GnPYbXUchI7Ud8AX6ip2t+L
         lxXlPj5i8/OYbqKlVuLM3IyObptobLWOIR877VW+h5cGhMKr9r2dYya004EU+r7VVnQh
         cN0gp/KzHMlj8Ozl+WLyU1S7X2Pn9aDDylhsfya6CM1sX5z3vHQBGI+catkB09IhV69b
         6ttw==
X-Forwarded-Encrypted: i=1; AKwUvBzfxsQNe+TGCOu4vHCA53SoqLX2VPkGCEcXRpuwJ/vyZg/mMWmY0Hd4NxrbNwVNUm+5s9cX3CQJIg==@kvack.org
X-Gm-Message-State: AFq9FYJIVfoeTnUVyAA0+eZvsZ81GSNSiCZA+LKXOSDqkI45uJmJFVsR
	Ui9bsuqK+JX+7DciFYBGVu/aSpHYPyoXPeARQNvGSxNfPmQUfBxv1D2p
X-Gm-Gg: AYBFou0xhU5s1kOgw5ifii5fBOWieotuAh02RwvAm+E6909qck7X2NKp6Cf4sUPa8s3
	bPVrWyITpcikKYU3vGKK8jGHaI4w9gXw5qNsfuY7IU40OM+2OlJPJ84DE6BKxjS8BtY4nVAuewc
	dHwGk9G6JNaYh6uoL5d0WuL+CiE1rHA4dDfvi8SnZu+QA7oD/GjedqsahGqDZNrsC2UQvM5HNNq
	M5LW14x2DynA7tQLemCSTkmglv/Voa385faUKVuvl+8IsIwsj0qLzNSy3hhPWkImyHtdN1jqFtw
	k8RY330FRkYmPO7OOxAoy9OMfSSrqE5x3q7hIjoPVeFQ7Yv9xrWCf5g7JOamm9YcI2y1+wG5JM+
	wKMbEgIkDx/MfFTGN9NhC/+SgIHSUb7DddRKMelVGljrWPpAEhnwEq3u24qcC7f2LiZbCjnbzCX
	cUIgK3XDF1wNgqLkh4lMxfyT3L3W6zgjPVGy9ejalnCR9B7pmuZrD9vPSJvAvd2rUpKmVcZO4LL
	cz+w1HrD+AWPsAqtV/ojJukHg/dCXljNnx9R6pDRDRTM+r6VwmN3aFZRCAs7A1RVjxFkxkSJpWi
	PMWWDgJKZYSkb2AOGS9Cc6Mbt/K2RfbWgBPEXE592Oc33fznYlhlc9XUg2dr7BUlvTzBCJcX
X-Received: by 2002:a17:902:ec8f:b0:2dd:c100:4b76 with SMTP id d9443c01a7336-2eb003e9b1bmr20590075ad.45.1793184224783;
        Wed, 28 Oct 2026 03:43:44 -0700 (PDT)
Received: from KASONG-MC4 ([114.246.239.200])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6c34c27sm19889165ad.50.2026.10.28.03.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 03:43:44 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:43:34 +0800
From: Kairui Song <ryncsn@gmail.com>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/mglru: stop rotating offlined memcgs to the old
 generation
Message-ID: <auHMXBwnwuRwHLmo@KASONG-MC4>
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-3-tjmercier@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028010611.3929937-3-tjmercier@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 061B81C0005
X-Stat-Signature: o5qkidc7bh1xoye95jopz4szpmi4ar1n
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793184225-348686
X-HE-Meta: U2FsdGVkX1+eRrnHA5JMvoDcsjE1lJ8OpfGhiaJ98IZACG9gDLMhzjOQ4rxC9MA1YRcx0D289PRcCvCT7QMsVm3RsXr46IX1WGaOwVwcbKsrrgSVoBb/4ebNWx/8wQJytdRGDU1kyeKHeGKIDb8HbDtc+4GCjqYEbdiPsF91n+o/DNGi//AmTF86R5ny1lUgejbg+XM+6flcv+sZOShSllpmb2XXB0DXRSS1wesrvIr5csZBsemgSboaxoCRvSF2RqIL/i+UhtT/MLsJgKlY8NoGWvpqHurGWNErEKTDB482E5TCP09X7ZZV3zPU2NE/nmxhfH5+o2bIB63RdUNISJ7UyYGnNNT3uA/f9Zldk5CaJDtsFdLqQqTQX4j0AjHkJ6BKxNkjQ86uKoTUr6GPisRupFUUBKN1uNAihyLKngUqri3WVxRC69iJ8RVA+sZ7zt3iVvZrjxH7KXF2Kt2aGF8h0gzVGAZzNgyVpscCtDoO4U5fk6jiZW7DqOef51bddjJOsXfyC2vemOn7/n2zv9k7KEnffH7qHO9VdFqZlIdm6dje0O5OOGArwzbqyEtBI6vw2Dk4CRmKxYsXGO3DtbS4fqrij3Jx3yAMXIjsMsLXwWMzy46orm5J2LSsNHAryocUcka3YaqpynB68xz+BQ4Gmfb7NVXzY20Rl4RUcHsdgUxIH0pCracD+rhQ/All4vgp7Jt6V+uNcGLbSYDgDfg6vwD3aIgMpzi/zBTOaifvmSbJW7EtaLbuVhFPckojYPyL/XHgOvZ+jBenuoNlbLhlxfxj7KGXHxxzsiiT+ylNk1bqIfY/74u5BGvxGEozGWMYco+ZWerC9AQexu04SDqXD3IM0wnL6M/IIJ31AyoeOF+rncDc7E7a9qimA85vsASfFlQkbwob9WZCIsKYvLSV37d7KEP5eE0/miiFcVXksnyehcfmi+K6LfV7q8OZ3vrU/J76hugHZWRvtKI
 e5Onugzv
 scZmgo9Di82S8VWYd4hNNruWV/xeiI2Sec/LrrgVdmgjbtEc3Xiv1kdOYoobyCtV2F7vmQC7Q3FYHxsSWW6GEUc8GIHfZvWW8Bd82i/3mAEbM7sZJ8L4tVj22ZtTJVYdyHMcdO7hcfAiYPwjeswH4sY/XoDCJKqy/ED+VdjbOaaz3UA0qMV8D8W3gEQkqeuzk5lcMgOGreXk+xuwUt/4Fdlq+RN7GE4LQEAk77NLjJzd3TvKDRAVxj2/xWoNVsCTmkv/iQBdvMe595HAeBogYaVNe47RlXAAnaPV5hhq7UXAMCJc/rNG13mhBZuoMFiNfNfq9Daos+d0gd4kUaadB1c3ZyS6vb8vGPepcdnl0/y8VVgZST0xPlx+HAN7e1kLJdfqPay6M7k9UWsu9vpOFi+hxnchrzN+IncXXWbIWZppLfQhXcVbsPpEaTZ3nhRnGx2ROprrRxzu3JLV9yqNlfvp0lIkUVw8F64jW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 06:06:06PM +0800, T.J. Mercier wrote:
> lru_gen_offline_memcg() moves an offlining memcg to the head of the old
> generation of the memcg LRU (MEMCG_LRU_OLD), so that global reclaim
> visits it first and evicts the folios it left behind.
> 
> Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> dying memory cgroup for LRU folios"), those folios are reparented to the
> parent before lru_gen_offline_memcg() runs, and nothing can be added
> back to the offlined memcg's lruvec afterwards. Putting an empty
> offlined memcg at the head of the old generation no longer serves any
> purpose and only delays reclaim from the memcgs that still have memory
> due to additional shrink_many() iteration.
> 
> Remove lru_gen_offline_memcg(), so that an offlined memcg is rotated
> like any other memcg below the reclaimable size threshold until
> lru_gen_release_memcg() takes it off the memcg LRU. MEMCG_LRU_OLD has no
> other user, so remove the op and update the memcg LRU comment as well.
> 
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> ---
>  Documentation/mm/multigen_lru.rst |  4 +---
>  include/linux/mmzone.h            | 14 +++-----------
>  mm/memcontrol.c                   |  1 -
>  mm/vmscan.c                       | 20 +-------------------
>  4 files changed, 5 insertions(+), 34 deletions(-)
> 

...

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 636152d8c94d..45a2c1021f4f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4538,7 +4538,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  enum {
>  	MEMCG_LRU_NOP,
>  	MEMCG_LRU_TAIL,
> -	MEMCG_LRU_OLD,
>  	MEMCG_LRU_YOUNG,
>  };

I think there could be other usage of this LRU_OLD macro, but indeed
offline is the only user currently, removing it is cleaner.

And everything looks good to me, thanks!

Reviewed-by: Kairui Song <kasong@tencent.com>

