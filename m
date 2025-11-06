Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6EBECCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 21:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEBD18E0005; Thu,  6 Nov 2025 16:03:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC33C8E0002; Thu,  6 Nov 2025 16:03:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF8F8E0005; Thu,  6 Nov 2025 16:03:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C1C2D8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:03:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 446851A0296
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:03:14 +0000 (UTC)
X-FDA: 84081407508.27.2B2893A
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4CC34100017
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:03:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OHUnhMnv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762462992; a=rsa-sha256;
	cv=none;
	b=YD3EsmAa+IyCma+UYMkxUIYtGCo083m0AebuURSas8ThOskILbD4R/xwnLrCy6TmobM3ut
	zWZ1mSYe60zVG9+QRT4P5vMNO4a0OHX29wAElk7+FiVu9vTvFTth/SkgW+zS+2CuMhY/6m
	hLVJgX5NkpVcRqtfuRE4RwHIfnrY2dw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OHUnhMnv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762462992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wHypUXf5gm7cuOtbaXRtiwOqxniqg61cHX+ypA+ba/A=;
	b=kP/gQsJ5jLhYV1vfh5hQFJnZGQXxVBxKSj+xRuyjoU33SLuUjIkv+eg+pMvnrG9uLcWi2A
	OxeJU4aOeU/5zUxCoZdy53f2gMvqfRE/UK8gA4lBx24gihzZfZm2MhwQOlnCmN3jI9PynH
	NjsaIZiu6sG8gOmRxLRFLb/zWMz2UUQ=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8906eb94264so7826685a.0
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 13:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762462991; x=1763067791; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wHypUXf5gm7cuOtbaXRtiwOqxniqg61cHX+ypA+ba/A=;
        b=OHUnhMnvd7ZNulbzjvnpy+cOl/0dGAYEsGAEw+KW9/i0EQfGANpsup08SnavC8tM8p
         SAKc0w1X4EirkapfQ89L8wuOdkt0rYFXGDBpHGxtY54Bsz3B5fmE6t1y+B85x9tvP9ZP
         IRAXNfI3ht/RLEJ2wTMVgcX9/NozMF4CldkoH2iUk8Q5qkFgwHkg0FVdL0qtxZ7uxbnp
         qNE3R2uGxcnmWsvUTIvCgl+C8X8ssHnD3PdIQ0JOKszebxYkeoDF7kHCS72+eaLddK1l
         jmkAfuIRq1yW9rlSovWH8S4IK6nuOhXWpXvE5k97rhp2X3YjGUYNLfVzwDWi7usnHAcU
         GUyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762462991; x=1763067791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wHypUXf5gm7cuOtbaXRtiwOqxniqg61cHX+ypA+ba/A=;
        b=IQ1ZEIczpEipB3grnU2WYAdA62H2HMCnIuXP8GcE2brfjW8Frh09gdyphTFSfNAlwM
         t/cz8Qw+KczNqpT0cTgUcVhVbYYukqI36V9eg7Ucj8+64/lgBPXozW2yI6UoIC44Vf02
         Luz6UzvxiG2LKgfSZFvNc2CahotIr6nBQj6E2BJYSJZSM6xRpDSf/g0zUWTDMpfU9wzd
         u4w+m6yd3b/QRh8X2E5wRFN0FlL4iV3wN9t1HrzqmMY/K2iUFw1IeSBPT9Xu2LzTLnzp
         bF2uh3YsD/yGGKvrBNM3s6XFB+rCRVuFm05VpU9jRKRgox4MZhBduO5DZL6qpdplVdhk
         eynA==
X-Gm-Message-State: AOJu0YxsRq2Uy+mgiupecya0qxfqOAn5Kt1lv1XITy1qXIZ404cURHi6
	o5L9RRXtVVdbEMDajwD/OEWPLy1r5YoOwm1G9IMJ5pWOllJkPDK1JP+Sl+OPT5/39BrcMtqqzWN
	KCNhP227lDGDiYhLN/kqN6QC6wFFOYyI=
X-Gm-Gg: ASbGncuLq981JZ3ko+f0EQJeo10QPaoHRj+sAULgmbl/B29wCbGhKQXGni4+cL7DB9y
	pSp1zLJZXrQGknWjsHsoys6nSXMw1GYJAwdpTurPkbcXsjDdXieEehTJ+6o6xtWxf+pZ1u4IxvF
	n1TwldHe5gNjtSq9UmPncOQjjC3qwB4Uk/AuqmeMeNOnoHAUUqLwCGoajM9P5XMF1TrdRfZwJl/
	jdUfG93s+8XFjUYh/dTp62hC6Xwb8jBStQPQ4V+0CMAh4sBU+0zh4Wo8hfjbdwmtpetcQ8gDxUQ
	uJ2tQ34BpUJuy9FR
X-Google-Smtp-Source: AGHT+IEF6W6svjYvXsGYjS+AFcEKE7bp6remMWA7QdS0E7B02dPJ2qQaHz7h732U9sbkoWlRpx4v0Zot4buhHXWJ/o0=
X-Received: by 2002:a05:620a:31a9:b0:890:ea32:2508 with SMTP id
 af79cd13be357-8b245358052mr131886885a.70.1762462991082; Thu, 06 Nov 2025
 13:03:11 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com> <20251029-swap-table-p2-v1-16-3d43f3b6ec32@tencent.com>
In-Reply-To: <20251029-swap-table-p2-v1-16-3d43f3b6ec32@tencent.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 7 Nov 2025 05:02:59 +0800
X-Gm-Features: AWmQ_bmLUPQCpCueKwY0y58_af-PX7oXEsnJr2BWnItkloq8GETycyLToqDjuVA
Message-ID: <CAGsJ_4zW92dnCk6qUF9fKe+=b0dORLrBjuQC5mjq_nbTK4aT4g@mail.gmail.com>
Subject: Re: [PATCH 16/19] mm, swap: check swap table directly for checking cache
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4CC34100017
X-Stat-Signature: nsknnuucuea7nhafhbnbdto5sxraa9o9
X-HE-Tag: 1762462992-586220
X-HE-Meta: U2FsdGVkX1+Us9/QkXVbZEI0BBgY2xbda+7oHP0WAC1f2+7mF1jf6CYZ8TnTXXzRffSug252If66A8kcXDIWRwlZEMy7x1a/qLOjKX3sBsefk09Cw5HY23xidEHfN9fsHz19rKuO7vsneBZhERD+q6u7FV8VRTpVwdBG1WVFMdrd4rUvLx2Qlh7F/UFfPiwi5KOkqg2Fu/eUv77o6X+S6sUF4+imM9OyYObtxSBqvcNanQwSDYRMreuP+403v+TMFxJA5joy6XKivrtXxMgXBYTfaJWHLVBC1qAeBwu7U8RCFC7xJ/p2RhrVBVetZX7vVPYGROWKU1QfekafpfnPhfZTDB4CFEWT8ts4yvxnqhVEBR7AgMaMV8rwPCuY0Xp2wL/kGOAlZ6oj2OLRGPXs5HS+bBWxOlUowH0mj4iYbxSfNRiX328GCMwuqd4gPVjWGjQW+qkkrkBh2fH99Nqc7Y98dA2L/+lD1ul7ZYOjwA8En7Cxtxhw5Cjr7MLJVz5jVvXK+ooIucUSBDCAtJMsJTjvhLOuyxXrZ9kPpK/0VdRMg5x/GYIXUViNLtNI02cVsumGyPmHejW6aWzGN1VUs+GHOE3UrmdqMSvR7F+tM5Ozf/yNzINVFJdXAZGex9/SUReGNmtW///iRC+YupY/DisCRmX6EbEXjWmz3TXR8MVhJgTx4jFdKQPxVFVUMHKX+a948q8IqW1fHnfsFITBWis9cYWyDX/AC+xBYU7ILw2re3p+o5UsklF5ckNKrShKAGvksqaVqKbrwK3+BTKhn15GKtsqCf8rIqr5Xg1iGg0jVzJ9+CaDd+CIbKWhp5umDalbOz0zmVO0B6jIGxD6CcChPYUNBqJSwvoxlb/JOgfDKDfbNxkzV5p+uVk7bDGqAnUTCcSXWamvuC1WI2+Ue4pSSL++xC/ytRgTqGLLRL2a89sWe/es8Bbo4b6pCAxh8L1DvyQLgnGGH7dzwHI
 b1t+hxYn
 361T8gW6uXEB1ut9TLDDtEs90D/Lxq/3qyfXJA/O4BzieiZgBAJzUAJCx6DGEKaL9VqVKfJfuH/OWURSywEmbbQWH7jOUGQi2iR5Z2LA31+vjidqVWISrL3ujxUTepVisn35pyhH+mlQIkf5l/mhPzB/QZwOLsxXiXdDXIrOtv3Ab5JsOiPLm6VP2MehJO670FbiGfn27GqN7s6G1AiOOiDHJCwjS6QROsSyKDOlOVabOptpd37xt/dK6+aX90BLAntAinvRTPijr1lsd8OJMtg0wvQLBITXRb9FZRde1aWkO3ToJ0M75ixiZtybmyRCkkE01N3edtIL5fC5FZgmiIlphEJpmT5ws9lKPYp1OS0nV6s7uFv5glDAntSXShd4e3GAa26cqWRyflnKxBMnDoV2sXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 12:00=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> Instead of looking at the swap map, check swap table directly to tell
> if a swap slot is cached. Prepares for the removal of SWAP_HAS_CACHE.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swap.h        | 11 ++++++++---
>  mm/swap_state.c  | 16 ++++++++++++++++
>  mm/swapfile.c    | 55 +++++++++++++++++++++++++++++---------------------=
-----
>  mm/userfaultfd.c | 10 +++-------
>  4 files changed, 56 insertions(+), 36 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index 03694ffa662f..73f07bcea5f0 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -275,6 +275,7 @@ void __swapcache_clear_cached(struct swap_info_struct=
 *si,
>   *   swap entries in the page table, similar to locking swap cache folio=
.
>   * - See the comment of get_swap_device() for more complex usage.
>   */
> +bool swap_cache_check_folio(swp_entry_t entry);
>  struct folio *swap_cache_get_folio(swp_entry_t entry);
>  void *swap_cache_get_shadow(swp_entry_t entry);
>  void swap_cache_del_folio(struct folio *folio);
> @@ -335,8 +336,6 @@ static inline int swap_zeromap_batch(swp_entry_t entr=
y, int max_nr,
>
>  static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
>  {
> -       struct swap_info_struct *si =3D __swap_entry_to_info(entry);
> -       pgoff_t offset =3D swp_offset(entry);
>         int i;
>
>         /*
> @@ -345,8 +344,9 @@ static inline int non_swapcache_batch(swp_entry_t ent=
ry, int max_nr)
>          * be in conflict with the folio in swap cache.
>          */
>         for (i =3D 0; i < max_nr; i++) {
> -               if ((si->swap_map[offset + i] & SWAP_HAS_CACHE))
> +               if (swap_cache_check_folio(entry))
>                         return i;
> +               entry.val++;
>         }
>
>         return i;
> @@ -449,6 +449,11 @@ static inline int swap_writeout(struct folio *folio,
>         return 0;
>  }
>
> +static inline bool swap_cache_check_folio(swp_entry_t entry)
> +{
> +       return false;
> +}
> +
>  static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
>  {
>         return NULL;
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 85d9f99c384f..41d4fa056203 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -103,6 +103,22 @@ struct folio *swap_cache_get_folio(swp_entry_t entry=
)
>         return NULL;
>  }
>
> +/**
> + * swap_cache_check_folio - Check if a swap slot has cache.
> + * @entry: swap entry indicating the slot.
> + *
> + * Context: Caller must ensure @entry is valid and protect the swap
> + * device with reference count or locks.
> + */
> +bool swap_cache_check_folio(swp_entry_t entry)
> +{
> +       unsigned long swp_tb;
> +
> +       swp_tb =3D swap_table_get(__swap_entry_to_cluster(entry),
> +                               swp_cluster_offset(entry));
> +       return swp_tb_is_folio(swp_tb);
> +}
> +

The name swap_cache_check_folio() sounds a bit odd to me =E2=80=94 what we=
=E2=80=99re
actually doing is checking whether the swapcache contains (or is)
a folio, i.e., whether there=E2=80=99s a folio hit in the swapcache.
The word "check" could misleadingly suggest verifying the folio=E2=80=99s h=
ealth
or validity instead.

what about swap_cache_has_folio() or simply:

struct folio *__swap_cache_get_folio(swp_entry_t entry);

This would return the folio without taking the lock, or NULL if not found?

Thanks
Barry

