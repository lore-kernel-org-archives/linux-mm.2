Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3879FF46114
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 13:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E37F6B0005; Mon, 23 Mar 2026 09:43:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BB836B0088; Mon, 23 Mar 2026 09:43:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8BF6B0089; Mon, 23 Mar 2026 09:43:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DDE86B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:43:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1BA38BCD66
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:43:24 +0000 (UTC)
X-FDA: 84577444728.13.D066141
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 68E93C000A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:43:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PT8JafTd;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774273402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Le5fwrAkDsOSFfKM1eekaep78MxMBo1DBzZrEmqeOVM=;
	b=zpCWhbFy7jEp5EOc/pLmAaDIHx2EuNaA0DopZYd+OSaLanYcqZnjyP+Pej9xwaY8BptVhl
	kfRst/yZfIDfKuPqZ5EwVLW9pDnPg/iqkUC3xByvPN3IKNMj4UAHNPcbNO3kqXSk89rqV3
	BA9HX5jt0a3uCY8Fx3y+AlywBev7mZ4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PT8JafTd;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774273402; a=rsa-sha256;
	cv=none;
	b=kMT0eKd1/CE9t8Ou503v/R6xMiT3YOECteZWfMVgfnTDpYZv4d4EmLWqScRvx49gZWG9Vo
	iA20GgALdIviQqaUDUILJjV3ghArNyd6sPum6OTKttkgUOp5hMUirPcZ9f/s+H/H5UPiL6
	WIUIWBryxQ+qJJBMSwT0BT4MGKjxyN8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B61A43C2F;
	Mon, 23 Mar 2026 13:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBE3C2BCB4;
	Mon, 23 Mar 2026 13:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774273401;
	bh=sos2rOgDnEu5phU7h7C1DwMHpSPALkFyrx3pKpO6fWg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PT8JafTd+3DvjSJLYIe4144ilUiYgAAZloVXZmmXPp02ktGDG/1RwGdDCLFndI/FY
	 7atB9JVqY9peb/4WozzZmT1UkycmQT68wuvbSulZGeXg7c5U3crWHUBLfM4R+Mp9df
	 iOIC6Xy4nyXZarH4qQPA6vOHLJQoJihGZJEqwnIzntirtqv3aKkBCwQ4E6XAyOvlfs
	 T3Bg5V6aiOEkCzs6Wmfz7jqlhRdzDpkbLEUWbPFlMROnnb/nFeiuxCYnbGLOmySD5s
	 g+HHXBKRGR7pZW7VdHz8MhzC6pH9FdjPlgzAjOUHOwiEKSP4GmgWJ00fvsVYT8FrZ4
	 6GZEifXOn1bHw==
Date: Mon, 23 Mar 2026 13:43:16 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, yuzhao@google.com, 
	shakeel.butt@linux.dev, willy@infradead.org, Liam.Howlett@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/vmscan: prevent MGLRU reclaim from pinning
 address space
Message-ID: <f22cb9d9-7fc8-4a79-ada8-02d66a1155b2@lucifer.local>
References: <20260322070843.941997-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260322070843.941997-1-surenb@google.com>
X-Rspamd-Queue-Id: 68E93C000A
X-Stat-Signature: pbiqwt9z8x66g8n69sqnwc87jeqbifxf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774273402-93110
X-HE-Meta: U2FsdGVkX19+bDTKEW+IUe57KmLAxQyUq0H1+amQk30WQyLzUDkBjmuDnqxswq9xlRpmCIF5dBGZwW3pyLJTOcshms6GvU/M08hjNuuTs512z87qahOrsja2ZdGGQVK4Z1cekJhv5KJc9lu+N2AIAnqMwkB0k5qtDHAyIK+jA5f7ozYdShs8kAC7Oisvm+ZYC1mu8NaCfP6hQ4HBqLmb+nh0+bYbnHQBaUMUVrVDWdjgGUTTszgkKjFg3rxkQaSeo2W3kvPmNvYkkgdG2sCq26wRPoplBpuk2F8cKw03jhlNr3sDe6Q2cR2WLW2dB+ErFaKGR/6UgbdFc4PEDVNWy1yOpeKdqbbGssqFXJ0Cs2sRDHzfAVrqPAhD8cskxL0pCgs9RvavJ9KmJH9wxEkjwM3up7w2lL9JzXAPermLbCPhsPWPA+Hd01Rc6vFtQgv5pfAxqPQczaXn6mSKwf9P4FDdfLPWnLSHy6QA8awZF1idC3b1NpoT/GUmm2WT3OaCzAgd29Aa0lyaNOrwwcKg44CaEPKEQyyRzSdnqjfHCxntChBKUfJZFBNyZ1NIAXxwDIyaLID5Mgld7ynIgjQUysgMRQbT6A5mKlhUD2ez0vLA5bRNgyu8liSznMxE0sdyNq076naZ1d/TdXACy049Sde+mQdZ/1HP6q6rmqVlZTKJPM1X4VTbO9LmdiZIXrnUaJp7x2uA2vj7If9pcQW6IMF3/MkDjJnO13qyCh1oSS6v6BDO3z4qTGZr5Cv+gz58NkrOcELrLz4bkgAtDs65tbQaPNFscRwqjDffB45MwlmU91STnfTj5saBrRRtINCwN4UxCpOKlhWyTqv4vx/zTPgKAggqSQ+38qs9oikaJtjIwiZ8fIMTgGS96qXQUdKGkjrKy6WmGtW3lNzX4XfEpFHSJUzKtgkTt1RQ+fPNd/m07kMYBzgwREwKOKrLxakgKlYR2XIlue7yW6Bu5z2
 BQSc7MMq
 ePrlxGYcScmQ/WZNl3u8ixn9Ny/DVASlWQOzerZP6nfMPLfjU2sz+eq+jiZ8vzE+mQOmMUwjeTiCEkfUMhGQp40lm7OsOyllG2e+iZP0mZ6b/LnqCmfZn1RiwIJeY1norMgl9yFL+5TLP34wq/z6QB4IpLZ9MFue6zA2GZ7Px+rcFyBv0XE+ZVoCsoaqSWdkr13d5bxkiqi+Kib7eQreOEJFUBbvsmSqwv/HD+Eru+uYW3SU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 22, 2026 at 12:08:43AM -0700, Suren Baghdasaryan wrote:
> When shrinking lruvec, MGLRU pins address space before walking it.
> This is excessive since all it needs for walking the page range is
> a stable mm_struct to be able to take and release mmap_read_lock and
> a stable mm->mm_mt tree to walk. This address space pinning results

Hmm, I guess exit_mmap() calls __mt_destroy(), but that'll just destroy
allocated state and leave the tree empty right, so traversal of that tree
at that point would just do nothing?

> in delays when releasing the memory of a dying process. This also
> prevents mm reapers (both in-kernel oom-reaper and userspace
> process_mrelease()) from doing their job during MGLRU scan because
> they check task_will_free_mem() which will yield negative result due
> to the elevated mm->mm_users.
>
> Replace unnecessary address space pinning with mm_struct pinning by
> replacing mmget/mmput with mmgrab/mmdrop calls. mm_mt is contained
> within mm_struct itself, therefore it won't be freed as long as
> mm_struct is stable and it won't change during the walk because
> mmap_read_lock is being held.
>
> Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  mm/vmscan.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 33287ba4a500..68e8e90e38f5 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2863,8 +2863,9 @@ static struct mm_struct *get_next_mm(struct lru_gen_mm_walk *walk)
>  		return NULL;

Not related to this series, but I really don't like how coupled MGLRU is to
the rest of the 'classic' reclaim code.

Just in the middle of vmscan you walk into generic mm walker logic and the
only hint it's MGLRU is you see lru_gen_xxx stuff (I'm also annoyed that we
call it MGLRU but it's called lru_gen_xxx in the kernel :)

>
>  	clear_bit(key, &mm->lru_gen.bitmap);
> +	mmgrab(mm);

Is the mm somehow pinned here or, on destruction, would move it from the mm
list meaning that we can safely assume we have something sane in mm-> to
grab? I guess this must have already been the case for mmget_not_zero() to
have been used before though.

>
> -	return mmget_not_zero(mm) ? mm : NULL;
> +	return mm;
>  }
>
>  void lru_gen_add_mm(struct mm_struct *mm)
> @@ -3064,7 +3065,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
>  		reset_bloom_filter(mm_state, walk->seq + 1);
>
>  	if (*iter)
> -		mmput_async(*iter);
> +		mmdrop(*iter);

This will now be a blocking call that could free the mm (via __mmdrop()),
so could take a while, is that ok?

If before the code was intentionally deferring work here, doesn't that
imply that being slow here might be an issue, somehow? Or was it just
because they could? :)

>
>  	*iter = mm;
>
>
> base-commit: 8c65073d94c8b7cc3170de31af38edc9f5d96f0e
> --
> 2.53.0.1018.g2bb0e51243-goog
>

Thanks, Lorenzo

