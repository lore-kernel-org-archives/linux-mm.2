Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4432606A322
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zPodisHS
Received: by kanga.kvack.org (Postfix)
	id D6DA36B05B9; Thu, 29 Oct 2026 17:21:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D45186B05BA; Thu, 29 Oct 2026 17:21:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33FE6B05BB; Thu, 29 Oct 2026 17:21:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AC916B05B9
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:21:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 13AA5160524
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:21:19 +0000 (UTC)
X-FDA: 85376934678.03.426ED6A
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id 30AF5A000D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:21:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zPodisHS;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793308877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+8ns+yvE4djttd03VIoOUqKqYBAUVZpRS1Gm6Ry0jA=;
	b=GLyQDSKIOG0ug5xzDK7mSx1YPbyVb2SKAcx3b77CB+jWGDfVrG+V8J4r7jOg4Dc9FstDto
	65VsTLdFD9fwNFby7CHYDZC7mBNiFYqUoleGW9JhsYxVh0xWwwCLHNmmSJ/srYHOOYzwqV
	cMvFIQ+Aj/pPB/7MWAiLBwXvJSXLIdk=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zPodisHS;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793308877;
	b=oo1swH5FoE+TRthiqUsSxw+zYBDQhP5V7Xk1NBJdUp+iw6BYaasKPtKvwUPCsHqesXd0XA
	6Q9PiKoHcwfYcepfDLcZ+rtJGVDNGE4z6anZfBwhDUj0qGRSe0vH5ENrNSlGqYMMiNroOt
	HeECOl3wTiEJJGnK/s73kvhDFSzC3P4=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso172835e9.0
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:21:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793308876; cv=none;
        d=google.com; s=arc-20260327;
        b=o4JB9Bcs9NG8wP1bd8ZVlrZF69zAwF9fgb507pK/i6exqgICRvR4RSOYX+KdOqSV+R
         S9e/IQwB2WmwF8vY9TGHff95BrjcCfKPs5ygX+RQ5KrXWgP2kmp3/NEWfs28zqsf8xiP
         RPecBYCW0znEbG87f4Gvi2SC4eRi2vdaF8uvnQcnxMKce9HI0HqHWk5x2G5laHYTW5ww
         UxjMxISwqrh9TCEK2Cbrw088tmE5z4k07UYqcjNnmlFyarFd6d5bjq7putAwZD6DS1P2
         Z9E8LlT8GCXuQCHrR+QPApMM0500oMeXQ36KV/uf1Y4+eT++W9noUgsZD6lD5E3ltVwD
         t1xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9+8ns+yvE4djttd03VIoOUqKqYBAUVZpRS1Gm6Ry0jA=;
        fh=1LEpChQUCvvqQJhYieeMdB7oGsZ5WPjufEj1RSSea2w=;
        b=Hs6ajY/Rn6BpF9hE3J1mhX4IPBxpwBWVeXT8h4uvmn0RMXVKSvCWnCB4FfNUFvQR2r
         mdy0dA1cybgiXsWJxjFXBkdeTwNovKBr3ipdGEe4dQOB/F81Wt6VpNkevnmVYyI614Ya
         DgvFN7ylzhRbISircU+SonojOqsuiC9+ONmVGgwWfLEkp9kyOG0T3ev/eeCOmx7yZEf4
         N1DinoKalMCbvaEZ+XcFLQhK27wzhaGAOlRgco+WK1gJ4LK2P5+5PD2Ibi6OvoKpas1+
         uhVQedR5ylrc7lAj7Wteiqc2okji5Tfy9FaqNZPwOmXe4eU7Hg4xn6RfeRjRcrpwBW72
         XchA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793308876; x=1793913676; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9+8ns+yvE4djttd03VIoOUqKqYBAUVZpRS1Gm6Ry0jA=;
        b=zPodisHSTbTMPMl4ilX89BeTMW+uAy9xa/Ofj0PauZhJtXplJq1C9v9HHDCY+WdSvf
         ub3FrgUTudDNzPktZhLtQLX2LvEUXKnVfhPR7dKxuPMjb4/gorLUi1LbaOkNGzPys7zm
         673Ol60rkgohWID+WbysN9PTjaSQIngNwvakq9IUImHtD6RdUtaVbRGbcU7296X0G0+U
         nIj1gsDtXsSSbwLQcB7a4H6+9Fl3KbuypODv04eyVYKg/T3RaQibKG3nZXCi1QlJwFsf
         iNcrXyUA0OHBO/qudEUzgsoSd9FlaXZQTSucQ9JHw6OxGWqzzf9u5/oKBRvSjYOwjx46
         qhtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793308876; x=1793913676;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9+8ns+yvE4djttd03VIoOUqKqYBAUVZpRS1Gm6Ry0jA=;
        b=bSodI0gRo98icqeOUgmyk5pFUxHb0TMZE8aUPvYt0htnCv+uUO1BVymPBPeDoQtErL
         MWc5QIG0E05qp+QvTgk4DgNyLHnD0fICTrjiQgsgHE7DxHM6/YFn2EVqY7G2MTQ8SEnY
         Dj2ozVdd0r9Z/MNpee93OI+GV1B6X4/Ct19UGkCurRKlXEWU5eKhCJzwVq2nU7gfT3qi
         Abf+Q8p4ZPXm1OXa2zsQWCS1OTfH3rmc6Fe7HIhBCQR8ah8tOy6M+Dyyjwg5pLZOyNxi
         iK+x9MbhcR/jxoJS0sTssFzRamnmLgKcACZcY4tpWKFPABizAkk9Dt0u4bi6EUMSrKR3
         Hfzg==
X-Gm-Message-State: AFq9FYLiLugfDEt3kBbxVqxeOZxCyllCpCO2TDFTLPI5LPLDp43E0IUI
	OT0L1JQFx+hpQikth6TrmBKEVLKxSyI8EVdS7IX5uVDghbcOO+yh07otFooooeDU+czB0BQY6m0
	suNhJMFn+tHMqkc9HX/lGps0JZc775cM=
X-Gm-Gg: AYBFou2Nop/PNnegHqxKjnl12rdNWYMRmrwhbRv2HJZLeqqwdknY0Nr2beVD5x2T08T
	KYHStEMGgBnCSOSHzZGYJTqd8z/9kGuQd/6AJyhjtotNQnJLJfIdLWMSoc6BZhqBS9wjCftCbQP
	2o3Vo/WLABhx1OGr98XR7bc1cE7SEsSNtB5tUJxRU0Q7+iDbXPnJU233weOc5DqNab4hr2hXyrZ
	RODH4oEsSGa7xRakpv7Y0OJ1jo6fdObomG3qr0TfoOtiSe89Y70FwUUkjldWwX9c/F+d5WjJl2w
	QYaD9Qv/awDRm3EEkDbLbj1stJvt5YacRcW4Q1wYQkBLJ1yFzugIRcZ9fFY4g8VxOjR+USvFgsy
	OCNmxaeUjebjC0i+7SdYJkzNaeSrvSD2HpIg4Y7SlofkaxPjZjuOPdIhIUi2GRWZM6xUaG/bc6o
	K1zg4axzlbfxtpGkk4FBeumoJKYiYVwfurEKv1yjU/KXCWAsh840KnyU2YkhaHO3qSGakLtqufu
	Q==
X-Received: by 2002:a05:600c:8b46:b0:4a0:4a8:d444 with SMTP id
 5b1f17b1804b1-4ac18c73238mr4750555e9.33.1793308875581; Thu, 29 Oct 2026
 14:21:15 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com> <20261030-swap-fixes-v1-3-73f73a59f2fc@tencent.com>
In-Reply-To: <20261030-swap-fixes-v1-3-73f73a59f2fc@tencent.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 29 Oct 2026 14:21:02 -0700
X-Gm-Features: AclHuK94IG0mhXQQjpw3RIi-A5xAWBQBwS6QINbigt5Lm9tPUmEat0F26KqQrPE
Message-ID: <CAKEwX=MJcyr1GjKNQ81x+fUS07T=THXGivjebt=W0ayjjZ3fgQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm, swap: fix large swap-in across swap file extents
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Usama Arif <usamaarif642@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chuanhua Han <hanchuanhua@oppo.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Mani Tofigh <mt4022@columbia.edu>, linux-kernel@vger.kernel.org, 
	Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 30AF5A000D
X-Stat-Signature: b5siguhpxnxs86xircb4ehb31oscaob5
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793308877-818085
X-HE-Meta: U2FsdGVkX18WMuECBi4AGA8hHIOtNU3N2qc80bre7NCg3SbMSGgDetKtn/dLOKGFuPcqNGvUEP36kc24thePwpWwf11ZM7xBS0PmSGdk+EJ3rgJ5MyvSmG7lmuABnvn8Et2hv0+sI0XURc1twSPKR9ENBI1+BE6vTuwehq8GvQOE0JaYoUQWGRPI2V09wNLf8wwHrlshh6fiqz6FYHGHRnpLHH1ztws/daGucWYpDkLmiNxQ11pqn6y93/7XPz8fbPCDxGRXMBFd9z45j8T25Ji6fqv9/m2hd3jD0us0aN4Q6QeYdx4XIA5DOCwmmGIXL0jowcJk/92UdIHu/ClDRGMNU23l2PUNjmuqdGWW/QFwTPqhMILDWJooxsqrrPqnTBoT1mugHD3WVNrKPppS5yW1q3KEykSw3OhqM4Vo7NpzfVBhbfG9h8RjcJRKaoPSbmuZaPhg711ELMmTbThc8ePnYU8N4DHCz7/2JmRpySJuVbxAcMyTG1TrFhq9cYG1FmTud+lZbYUzlyUXUntZUKMYu6s7oOFV4Apo7li08nmlUvVNiPNrvqVGE1FzwV5wXpTtJHypbWrj/+sljNza6MsKEnuyEQh0EcEEuNdDI/QWX/s3q3VhZaZbJe5tTGxce20gPmy+ajD4UXlsDKmxanA7CQ6UPMYfILdlcfYW1xjcQnWVGklpDVoZ+S1tlJcXg8ZmuVLypPEuHsaMqBFseQadtPwOWp//rdJPgJ2Rbx5UPyBkk0qDqNsdN5s2LdypVPIxSzd1ZlTQmiiC2OsLdwmpWeKWiVpQR5ioMKoCLKE6X4bOAYohiKukpOcToDS50rb1NKJRHPopo5IGFDwdQHJxPyqAAc/S5d0UvAW1btc0mfp6/hEvY8pYhssBIamVztUihGZuK0bWWbRSO0hkvTwBNV/7F3O4Ihzo7qRuc5QZp2szkgyNTG6LpIVhn7A/wtiPE+J3FLQEOxKYzd/
 r3iulXDN
 LdHr9QAIF85uXxHdZzx6ub0QUIbmfL3C1+Y2FseU6ANWct5Y2a1f92PQ9rcdZsdMrhnei7sEuHlB7Vnq3yJDcKoU3YnjUNlehxBkOcLkNe85A/84grFkaEc00//7wODd6x/5bG4ywJ8YOwc4DIR73P6/I30vHgqIhFjYOrz71ihkof2jgo0DcFvT6kJETcZL7cePHabKcuXGW0e6uZbZHRWQvyqC72K6YbmlXVwD8R7JMBwqIH/+/CgjOWBw2OYHyDx3g9l7gXvkYnHIzm0P4N2ycgOtKpzd0bv7C6oAo9h8h5hglKWXPORSYH/tDokhhb3v2ImqqAjKJmR5jxnFzJkFgj8GPgdTMizsfI/46Gn2jDTslCIpkQd73Jfn25d/BX/6WS+imaBm19xvGE0DZvDh9Hsw1bAVh45c6t1PPAIs74enrCKbvGiTUT78ZUFixh85Pi3ebq0dKvCWR6Um1BuoTiZKfolnWQ62a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 11:32=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Chris Mason <mason@kernel.org>
>
> A page fault can give an unprivileged process blocks of other users'
> files instead of its own swapped-out data. This affects systems with a
> swap file on a synchronous block device, such as brd or zram. For an
> anonymous mapping it also takes a huge page size below the PMD size
> (mTHP), such as 64 KiB, that is enabled for anonymous memory.
>
> A swap area is divided into slots of one page each. A swap file is a
> regular file, so adjacent swap slots can lie in two extents, far apart
> on disk. A folio is read from swap with a single bio that starts at the
> sector of the folio's first slot. So all slots of a large folio must be
> contiguous on disk.
>
> The swap allocator knows this: it only hands out a run of slots for a
> large folio if the swap area is a block device (SWP_BLKDEV).
>
> The swap-in path does not. On a synchronous device (SWP_SYNCHRONOUS_IO),
> one that always completes I/O in the submitter's context, do_swap_page()
> can read several swapped-out pages as one large folio (a large swap-in).
> thp_swapin_suitable_orders() makes that decision, and looks only at the
> swap offsets (the slot numbers) in the page table.
>
> Pages that were swapped out one at a time can end up in consecutive,
> aligned slots, and are then read as one large folio. If the extent of
> the first slot ends inside that folio, the rest of the folio is filled
> from the blocks that follow the extent on disk. These blocks can belong
> to other files.
>
> Reproduced with a fragmented swap file on brd and 64 KiB folios enabled.
> After single pages were swapped out, a fault returned blocks of a
> root-owned file with mode 0600.
>
> Fix this by allowing a large swap-in only when SWP_BLKDEV is set.
>
> Known gaps:
> - A swap file on zram, brd, pmem or btt is now read one page at a time,
>   even where its slots lie in one extent. Its swpin counters in
>   /sys/kernel/mm/transparent_hugepage/hugepages-*/stats stay at 0.


I guess we can check for this right? Look for the swap extent of the
first offset, then get extent's size (swap_extent->nr_pages).

Not sure if these users use swap file here though.

> - With the posted "mm, swap: enable THP swapin for xswap entries"
>   applied as well, the large swap-in that it adds never happens. That
>   patch gives its swap device SWP_SYNCHRONOUS_IO but not SWP_BLKDEV, so
>   the new check would have to let that device pass.

Mentioning unmerged patches in changelog? ;)

>
> Fixes: 242d12c98174 ("mm: support large folios swap-in for sync io device=
s")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/memory.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index b65b56fe9714..944f57153c89 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4863,7 +4863,8 @@ static inline unsigned long thp_swap_suitable_order=
s(pgoff_t swp_offset,
>         return orders;
>  }
>
> -static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
> +static unsigned long thp_swapin_suitable_orders(struct swap_info_struct =
*si,
> +                                               struct vm_fault *vmf)
>  {
>         struct vm_area_struct *vma =3D vmf->vma;
>         unsigned long orders;
> @@ -4888,6 +4889,14 @@ static unsigned long thp_swapin_suitable_orders(st=
ruct vm_fault *vmf)
>         if (!zswap_never_enabled())
>                 return 0;
>
> +       /*
> +        * Neighbouring slots of a swap file can lie in two extents, and =
a folio
> +        * is read with one bio. The flag is set in swapon() and stays, s=
o the
> +        * race is benign.
> +        */
> +       if (!data_race(si->flags & SWP_BLKDEV))
> +               return 0;
> +
>         entry =3D softleaf_from_pte(vmf->orig_pte);
>         /*
>          * Get a list of all the (large) orders below PMD_ORDER that are =
enabled
> @@ -4924,7 +4933,8 @@ static unsigned long thp_swapin_suitable_orders(str=
uct vm_fault *vmf)
>         return orders;
>  }
>  #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
> -static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
> +static unsigned long thp_swapin_suitable_orders(struct swap_info_struct =
*si,
> +                                               struct vm_fault *vmf)

Nice, I think Sashiko is complaining about it on one of my vswap
patches lol, and I was wondering how on earth is correct in non-vswap
case.

Fix LGTM:

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

