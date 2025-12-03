Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68F80D116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 05:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B07266B000E; Wed,  3 Dec 2025 00:33:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADF186B0010; Wed,  3 Dec 2025 00:33:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F60B6B0011; Wed,  3 Dec 2025 00:33:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89A0D6B000E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 00:33:43 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DCC016045A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 05:33:43 +0000 (UTC)
X-FDA: 84177042726.07.E64463C
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7D2D61C0009
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 05:33:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HL3jYX7l;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764740021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXYv2g3mMeVHg586+4q0ZQi51VwtQG1+dmYwOUHmoMA=;
	b=yC2xFpQpTT5r7hXgRbRf9BodpzpOIPfroxjms/JNW6100m0aQPfCKsQtBxlN6ADQMtl+aq
	gPfQAwm38hYfMj1zeJCt3AV1g93C0/oSDTZaKTqqyF930OsUKUmPYUJgm28UpxdfvPL9K7
	qQvt/8ekbD2yixyGAITslywRoqQTFSw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764740021; a=rsa-sha256;
	cv=none;
	b=QuxiCI4ih0y4vwCIL7t198CQviAleHrRGh4iui2gMD5q0k9HVsdbJSGOos4ZlqrbO23Efk
	DqzzRo8jw5LTq4uUshLwxONxSwgpnweRFnl7wiJNQvAowxbAWSQtYnpC1CmUMPhpEf1eig
	6ehoDr9I22K5Wx50mprvQiZAF/wd7j4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HL3jYX7l;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b735b7326e5so81553666b.0
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 21:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764740020; x=1765344820; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sXYv2g3mMeVHg586+4q0ZQi51VwtQG1+dmYwOUHmoMA=;
        b=HL3jYX7lN/07aYRAAnxkSluZO0joAU2pdIvbb7rTUZ+rWp/Mh5J6IjMSWquPfbqINU
         tAOMt2gnOSDGOsv/MkvoEuvBtJtd+0UbgNGvyNIR41KR6uVhOI16KKp3pQ14qNEZ1770
         ja3ijASeGcsckI9mY78tFUs/LiwrAy2LVsFGjuGZbBdxoe2ATTIehwVLSGSZ0wNac0QO
         gbSdF66S529Cc82//IVT2+YquIZ4C7DNb6Gw3gA3wdLw8/HYZJLZcEWhaw6wjp2qc5no
         L3zJ+WAzEWb/xtbPDM9djwT3ycGY/X9smKkq5Cj4X6wYF8nJDMqNVRmApEhLj2IQxvfS
         YztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764740020; x=1765344820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sXYv2g3mMeVHg586+4q0ZQi51VwtQG1+dmYwOUHmoMA=;
        b=Um4HVRIzC+f0apNwtEiRT/WuUllPq8eGt4m4dl7rXcts2EZA9tKBh1VvJ4hyIxWPPE
         ubUMPEXXcKmxWz4C7dkpWOu7c6COfbPJSQv7CjDSQHS6D98PTUjkjJIjsuHYQNbB6n9S
         8iiYXRTyyNNIgBCsdZsn5+z1cZM8zxEPMMXYZrUWCRZ2NxsKaa0LkUyVHUiNzJUGswOZ
         ETG/4kPjYNzR2EILOpEd/vUh0SVHgSLuw8w8EJGnpwBGdj/v+s6UB9dcax7JS38Xe6r4
         gXQF6QgOrz1Fp5YnsxbsuCXyrOOfbV9uspxemRsvKJVzdHH5nMGwrpZ3MfKbLtkPKZL9
         BwjQ==
X-Gm-Message-State: AOJu0YzNraGQwAHETKXsAuGCUzfLM1/I9fdVMj/U/kJ0oYdD0RyZmZ2b
	+0OxXqlc/QdMotilcBfty2wAzSyf0xDI0xGLsRfuEhjVYZy6X08OIWP3PED6liWuLBtTiJ+V2s/
	ete1eK3QkHM6NAilO4H8DW8i6qJAOV6w=
X-Gm-Gg: ASbGncstZVNTdEbdt+JcZkRn1ULnz/mELEEpVLJmPQOv780bFWwYrvNgaQGKVYVXM4U
	A02Lkos9pbj1W0DEIpZ6BBjX5yv4PzuEtd+oEwpoyBWnrq6gxZnPo5BuxjJGGa7qT/eM7PKC0sP
	7prgvoP9hAOsw+2VcZGe79MjK1xKQEUJOfm5EPu7E7kXlfniGD7qUO7L32mcBeMXMhPOOvH+ipp
	A5iW9xQOZ7ReyENpYVb6x5dxvxkN8iIg6yIZ4ufCIS+14/cQIL6cEvCUzU+aVS5XVuQrd3002OB
	N1xD0oP+BYCi+iR7diMI3+lqTdc=
X-Google-Smtp-Source: AGHT+IGEXWjjjE9oWinfOWWL4EhfZ09arKCQPggoWb8G3fviHhMOM5SJK+oiYrAqoOTjgHt2DKGqn+mno7SX33zsWVU=
X-Received: by 2002:a17:907:741:b0:b3f:f6d:1d9e with SMTP id
 a640c23a62f3a-b79c21c52e5mr618371366b.6.1764740019445; Tue, 02 Dec 2025
 21:33:39 -0800 (PST)
MIME-Version: 1.0
References: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
 <20251125-swap-table-p2-v3-7-33f54f707a5c@tencent.com> <64ae5450-b74d-452e-a9ae-486c57efa092@linux.alibaba.com>
In-Reply-To: <64ae5450-b74d-452e-a9ae-486c57efa092@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 3 Dec 2025 13:33:02 +0800
X-Gm-Features: AWmQ_bkGfnDwoqOX3QuGY6eAlvIHyiYB5WHBu2QG_RPkq-opn86lNB_tXcETgws
Message-ID: <CAMgjq7DcpMgLjX1m=+4SM=zMe5+H4qDLqdOUGnYGNBQ_HsKw-w@mail.gmail.com>
Subject: Re: [PATCH v3 07/19] mm/shmem: never bypass the swap cache for SWP_SYNCHRONOUS_IO
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D2D61C0009
X-Stat-Signature: 68nd7wguco5srocb9iit5fwn899wz78k
X-HE-Tag: 1764740021-570633
X-HE-Meta: U2FsdGVkX19hUjvQvwV3ewsX8hPo6yoH8RuXZnjE/Cx7rAg/hAI8CptO3GmvvG5yu0zOOOVWXHSuJAipIIGDlQy8d7LFlK4Jv6XTiGeeSjC7XskKzCnE8GtLQwQ62VHKWp/qwaU9+whT2wfKQ5JLTYTbpdSA0mUU+YawEOhcvbdG3neLEgpPvbumvngkv66XAV+BZAoSLY8Pskpo02bZz9g7cPCcr7whkNeDwqOhpM1LMlIkvsSY2dKoEAPLyJujhhxiXhKZmDmS5z6mJhi/W2guOK8XYlPi/tExsbHf9JNI5g2VwqTWHqQAFG0o1vn5YqOotjI2Ls/SZzxWrWlWtD1UAkuHIlOUMQhFIed8bHOONayEnvGSF5bZC3amDpoZw6ulPL7aRRJC2A/dT3Ibt63L/yFFTG7VDpKYsJ5xtt+kO2WsFTYL/efJexZhLkVuRDCKH2Xyv+RW10+MZmnwM7FOSZUTCpgm0Z8wXasOLVv01iXMdkaNfgyFMi3xCbeYLx1rNZpxaMCDVrHLHLA7qYY0M6phJn7ijYwML6GRpO2khjL3FX3eqDBTHrv8fUAEtK4yNFvLJnjZZHtnirxMKJHpEqI2Uzu/DClxnopbtRsY8Kwa1ECrvnuxZ37Pi4W8CmPW3SfCT9g0KoqPpP8yCh5nyg4WHfCrpneVPRNzAz/SQH422ImU48MNKM5hVVgrmot9Hbec9lplJ9kFten7+/E/IBCafBsPmdi5u95WrowEZLUpmMwtfxw2uHeI5trtLrsOTX2qJ1/RWU663CuSvGA71/Tki7UBX4+69PTdENolUrDwqxKGCxdCrFQZb4BHy67H4TAMIKbGDGTmXJq1h75SXlxI3TVG3rmmRuZe2uz4JWw+wn+xBnJ035dy0DVeXXOx3wgLpG3XKuaMW9FFLOy0iwJ0sF9A1V5oNgALFdXL6s4NFjfusn+7F5j6mHo9yze3E2DzszOrnkSl9BC
 smHkll4+
 fJ3OFaICYomEVOacRN28e92RVivWtkMfB0h2ZvIX48TX5yBW/s0s4A5QpWnhynW55h9Nc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 2, 2025 at 3:34=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Hi Kairui,
>
> On 2025/11/25 03:13, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Now the overhead of the swap cache is trivial to none, bypassing the
> > swap cache is no longer a valid optimization.
> >
> > We have removed the cache bypass swapin for anon memory, now do the sam=
e
> > for shmem. Many helpers and functions can be dropped now.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
>
> I'm glad to see we can remove the skip swapcache logic. I did a quick
> test, testing 1G shmem sequential swap-in with 64K mTHP and 2M mTHP, and
> I observed a slight drop, which could also be fluctuation. Can you also
> perform some measurements?
>
> 64K shmem mTHP:
> W/ patchset     W/o patchset
> 154 ms          148 ms
>
> 2M shmem mTHP
> W/ patchset     W/o patchset
> 117 ms          115 ms

Hi Baolin,

Thanks for testing! This patch (7/19) is still an intermediate step,
so we are still updating both swap_map and swap table with higher
overhead. And even with that, the performance change looks small
(~1-4% in the result you posted), close to noise level.

And after this whole series, the double update is *partially* dropped,
so the performance is almost identical to before:

tmpfs with transparent_hugepage_tmpfs=3Dwithin_size, 3 test run on my machi=
ne:
Before       [PATCH 7/19]         [PATCH 19/19]
5.99s          6.29s            6.08s (~1%)

Note we are still using swap_map so there are double lookups
everywhere in this series, and I added more WARN_ON checks. Swap is
complex so being cautious is better I think. I've also mentioned
another valkey slight performance drop in the cover letter due to
this, which is also tiny and will be improved a lot in phase 3 by
removing swap_map and the double lookup, as demonstrated before:
https://lore.kernel.org/linux-mm/20250514201729.48420-1-ryncsn@gmail.com/

Last time I tested that branch it was a clear optimization for shmem,
some of the optimizations in that series were split or merged
separately so the performance may look go up / down in some
intermediate steps, the final result is good.

swap_cgroup_ctrl will be gone too, even later maybe though.

>
> Anyway I still hope we can remove the skip swapcache logic. The changes
> look good to me with one nit as below. Thanks for your work.
>
> >   mm/shmem.c    | 65 +++++++++++++++++---------------------------------=
---------
> >   mm/swap.h     |  4 ----
> >   mm/swapfile.c | 35 +++++++++-----------------------
> >   3 files changed, 27 insertions(+), 77 deletions(-)
> >
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index ad18172ff831..d08248fd67ff 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -2001,10 +2001,9 @@ static struct folio *shmem_swap_alloc_folio(stru=
ct inode *inode,
> >               swp_entry_t entry, int order, gfp_t gfp)
> >   {
> >       struct shmem_inode_info *info =3D SHMEM_I(inode);
> > +     struct folio *new, *swapcache;
> >       int nr_pages =3D 1 << order;
> > -     struct folio *new;
> >       gfp_t alloc_gfp;
> > -     void *shadow;
> >
> >       /*
> >        * We have arrived here because our zones are constrained, so don=
't
> > @@ -2044,34 +2043,19 @@ static struct folio *shmem_swap_alloc_folio(str=
uct inode *inode,
> >               goto fallback;
> >       }
> >
> > -     /*
> > -      * Prevent parallel swapin from proceeding with the swap cache fl=
ag.
> > -      *
> > -      * Of course there is another possible concurrent scenario as wel=
l,
> > -      * that is to say, the swap cache flag of a large folio has alrea=
dy
> > -      * been set by swapcache_prepare(), while another thread may have
> > -      * already split the large swap entry stored in the shmem mapping=
.
> > -      * In this case, shmem_add_to_page_cache() will help identify the
> > -      * concurrent swapin and return -EEXIST.
> > -      */
> > -     if (swapcache_prepare(entry, nr_pages)) {
> > +     swapcache =3D swapin_folio(entry, new);
> > +     if (swapcache !=3D new) {
> >               folio_put(new);
> > -             new =3D ERR_PTR(-EEXIST);
> > -             /* Try smaller folio to avoid cache conflict */
> > -             goto fallback;
> > +             if (!swapcache) {
> > +                     /*
> > +                      * The new folio is charged already, swapin can
> > +                      * only fail due to another raced swapin.
> > +                      */
> > +                     new =3D ERR_PTR(-EEXIST);
> > +                     goto fallback;
> > +             }
> >       }
> > -
> > -     __folio_set_locked(new);
> > -     __folio_set_swapbacked(new);
> > -     new->swap =3D entry;
> > -
> > -     memcg1_swapin(entry, nr_pages);
> > -     shadow =3D swap_cache_get_shadow(entry);
> > -     if (shadow)
> > -             workingset_refault(new, shadow);
> > -     folio_add_lru(new);
> > -     swap_read_folio(new, NULL);
> > -     return new;
> > +     return swapcache;
> >   fallback:
> >       /* Order 0 swapin failed, nothing to fallback to, abort */
> >       if (!order)
> > @@ -2161,8 +2145,7 @@ static int shmem_replace_folio(struct folio **fol=
iop, gfp_t gfp,
> >   }
> >
> >   static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t=
 index,
> > -                                      struct folio *folio, swp_entry_t=
 swap,
> > -                                      bool skip_swapcache)
> > +                                      struct folio *folio, swp_entry_t=
 swap)
> >   {
> >       struct address_space *mapping =3D inode->i_mapping;
> >       swp_entry_t swapin_error;
> > @@ -2178,8 +2161,7 @@ static void shmem_set_folio_swapin_error(struct i=
node *inode, pgoff_t index,
> >
> >       nr_pages =3D folio_nr_pages(folio);
> >       folio_wait_writeback(folio);
> > -     if (!skip_swapcache)
> > -             swap_cache_del_folio(folio);
> > +     swap_cache_del_folio(folio);
> >       /*
> >        * Don't treat swapin error folio as alloced. Otherwise inode->i_=
blocks
> >        * won't be 0 when inode is released and thus trigger WARN_ON(i_b=
locks)
> > @@ -2279,7 +2261,6 @@ static int shmem_swapin_folio(struct inode *inode=
, pgoff_t index,
> >       softleaf_t index_entry;
> >       struct swap_info_struct *si;
> >       struct folio *folio =3D NULL;
> > -     bool skip_swapcache =3D false;
> >       int error, nr_pages, order;
> >       pgoff_t offset;
> >
> > @@ -2322,7 +2303,6 @@ static int shmem_swapin_folio(struct inode *inode=
, pgoff_t index,
> >                               folio =3D NULL;
> >                               goto failed;
> >                       }
> > -                     skip_swapcache =3D true;
> >               } else {
> >                       /* Cached swapin only supports order 0 folio */
> >                       folio =3D shmem_swapin_cluster(swap, gfp, info, i=
ndex);
> > @@ -2378,9 +2358,8 @@ static int shmem_swapin_folio(struct inode *inode=
, pgoff_t index,
> >        * and swap cache folios are never partially freed.
> >        */
> >       folio_lock(folio);
> > -     if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
> > -         shmem_confirm_swap(mapping, index, swap) < 0 ||
> > -         folio->swap.val !=3D swap.val) {
> > +     if (!folio_matches_swap_entry(folio, swap) ||
> > +         shmem_confirm_swap(mapping, index, swap) < 0) {
>
> We should still keep the '!folio_test_swapcache(folio)' check here?

Thanks for the review, this one is OK because folio_test_swapcache is
included in folio_matches_swap_entry already.

