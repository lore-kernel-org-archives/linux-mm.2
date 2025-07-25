Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A05AC83F27
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 04:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE786B007B; Fri, 25 Jul 2025 00:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B788B6B0088; Fri, 25 Jul 2025 00:55:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66D26B0089; Fri, 25 Jul 2025 00:55:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F7926B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 00:55:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C02881A05EC
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:55:24 +0000 (UTC)
X-FDA: 83701573368.22.43DE1E2
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id C28E040012
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:55:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RKE8jYWr;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753419322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjRvxsIHZ595y0DEJWKmPyqBjiMK7a2mQwpXKP8AxLc=;
	b=u1cVjJ4OJ6JgyhieMz6zTksLy6mic6f6ArOLngcu5u8421ApJUdPK/hREEUQvs4S91c8Uq
	OGuFtMQ7tsBK2zfxSNsbkZJ9jc26KTP0UzwOdeMlw+adN+K9wc9fWLgL/rwAtmRIuDhfl2
	USOl1hLB7qVnJ0ItRaL3McJImM2dwEA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RKE8jYWr;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753419322; a=rsa-sha256;
	cv=none;
	b=FaSvbpQ0UlHDGcCmwYGYa46e7bXMC90+emY0PSfhvKeVyeu5BnGHTZbfXk7rrX3G7Ng1F8
	9w8Sqe0ke4wBhn9uNC3XdSn8t7h4uovjT8Bi3d0TS+RehVjLpvr98KYPASA+BbFK/4WclD
	s9MENmiAuINIJd0ba2/dZKido5QinbA=
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-32f3ef6178bso14280191fa.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753419321; x=1754024121; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gjRvxsIHZ595y0DEJWKmPyqBjiMK7a2mQwpXKP8AxLc=;
        b=RKE8jYWrg/IEvS1iD7TI6iVv/H1Egnlv671UQCEVLrM15c7BjQUWuiMS1d1+WfE0tV
         zWPJnCYa5QXu1UcLv38KMlmBfA98pGXAnPjvzHfYrjoDdA2vTdM44YOXmE4LfYbijH5Q
         rK7sdCi8OYdsd/EbeFcX49468e/rwEXV2XrqGUhWfj7RncoQ8WoI7iniUneOP++S9Rqu
         kE8iNzE02ML2jH+zgldg8rayEOSfEmHNbNspawBTL/iXX9eaJ6crguOxRUr3GWe0lmDg
         gFuaTxnOxYjEdRAXDWhnitzehlaLjz3rg/GbidP1C6vO6ZIoDHvIkfS2iJweABbZ2P+A
         RZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753419321; x=1754024121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gjRvxsIHZ595y0DEJWKmPyqBjiMK7a2mQwpXKP8AxLc=;
        b=T5XdfSCU0Zq7jaZrSQY+nS7go0VS6oAbmcHig+A+8ZXuKklZcgdesu7Jdn++ji8msG
         iwWueGVga29TTS/90ZksVAtufv/1SbSSSXq17yTwIR6fSFcZ7bMlmutAJ8m+i90ndAiw
         0cb7Ls9Y2Rcje9zUodbOqo+ejdw9dauIbI0eiTlywpzD8wT2rwwCYGD8M7cxC/BmzL2Q
         yNLLRRJ+ykJWgevUMd2mzVbpCqek2E0aHyud9acGt19TMVGWIC08cqLgdkX7tpzEC/Zk
         F3K9AcLbySasSPGxHvkY0xvV4rIyCHYr3qAgS9WkS0LTiJCke3Q2WVfAbK1AYiamsetl
         AkBg==
X-Forwarded-Encrypted: i=1; AJvYcCUSas2PkgYiMHabZpGSImiZtYwTNPaMc3eCkGnxVJVYUrwf7FP6eASfh6AaxW9J4JQi3wEynp2VKQ==@kvack.org
X-Gm-Message-State: AOJu0Yw3K/HLWgIITNa4IZa8+txE/K3zJTGOdYPSrqlkduH9N3Uwl+Jf
	bKQQvzWhcC+Cz55NKx1v4OR8hk6QDj4/LRskiPkbk8XwvHRwrsky6NsHBmGEbwjnZNWLhIxy32N
	remGKC9lamwsiDMaSpki2fgTdgb67Tq4=
X-Gm-Gg: ASbGncs25CezpVHKF8S6D61ONgGT41cmYKQPnuqdagRZmjFPM4D8hZklVmmaK+yiXPc
	K+IoocpIq+Rzh+3SJ4u+eQwTC9OgEgyb+Svb1K3L1tMaYOFJhy1BLDTtwl59YTGXU9hMWL1Q6VX
	Mz9x0iuBZMeFs/t9GkTqx25mIgBThxH5l/4rjDQ3x4vqda+EtnUAWNiwbR1hcNCzkrAUxOL9L8Y
	6kKBRk=
X-Google-Smtp-Source: AGHT+IHqMl2rUjbDV1waYyUjl7JoYdOEn2Tf6QXhm2MqddA+SlKwGNxw3VHcGi7scZ6WdkNORrS1HOuAFcuWmANaEiE=
X-Received: by 2002:a2e:bcca:0:b0:32a:7d73:9101 with SMTP id
 38308e7fff4ca-331ee7c8f3bmr1367871fa.26.1753419320425; Thu, 24 Jul 2025
 21:55:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250710033706.71042-1-ryncsn@gmail.com> <20250710033706.71042-2-ryncsn@gmail.com>
 <CAMgjq7A+DBw=z8RPP-P1hcCH4Mid0txfmKqgqXghoE_v7zGEoA@mail.gmail.com>
 <CAMgjq7DfPXS4PkpGK-zem2L1gZD0dekbAyHa-CPHjf=eonoFXg@mail.gmail.com> <437bdc7a-d570-4602-9715-c716a660e762@linux.alibaba.com>
In-Reply-To: <437bdc7a-d570-4602-9715-c716a660e762@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 25 Jul 2025 12:54:43 +0800
X-Gm-Features: Ac12FXy8WN5w18XQCx7kjrQOVKWGkH7JUFyMUqQuQRsW2HacQOSFJKuMPAoqVSo
Message-ID: <CAMgjq7CuwHEWqmUG=4-nAtCrGJJjUM_1TY=ToFUAm0NXxMV3iA@mail.gmail.com>
Subject: Re: [PATCH v5 1/8] mm/shmem, swap: improve cached mTHP handling and
 fix potential hung
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C28E040012
X-Rspamd-Server: rspam06
X-Stat-Signature: 561brz4f54xbh7zgcb1hxydoc4dq5upn
X-HE-Tag: 1753419322-338785
X-HE-Meta: U2FsdGVkX1+m1/VUgfT9S94hvZnKTtKfN9ZUSnKt4VM5m1cXNS/7qUTKIDJblAvBJ8C2SqS21hduxIYjfnurRo2LKs/bUxDnpL7m9Ck03zpSGzRf/BgO7XGVj8acniNUwJc44eIYqGfggl+hN2pFg43eMTBBke2rflBobzMMusG2+nzN7xQXsg+9xMVQSV8pHAm7JadX4Cl4DpTvu+NqzGnvGprA3Gqfjjg6jZ0Ifc4JWX83NF6Td592Zd21EZSedu9E4bibrMDKEHAwgwdXmAGIwPTZwhirKgAOu1k4oCxzOzyPSnfK5wsS3RQptAFe90vvDIxMnqYY6oIoUpYxb+GR8EH5E0FKMM74uiWq2r+F4egovkiMR7GWT81AgEWelSu3mp1ArzGnPG2XcNqSDzwBHtqk4efojb5rX/zUb01ihJGlCEDrIzo02Yt4k9uFCLgsmhBbrGnjaH/A0MHIEiFYw5GGp8qH/IkoTEMTPfvDSLAXDYwynZ1qJ3wjGSKqwc6G3yvWhUxV+yL7MLoO1z6P/Kz083ZN/XvwiNZeF0TFYKjwAsxCVdrOuOB3OrbBQES84w5f4raL4SUKk67BRV0l3DmdcPIjLVyLUlDbuJnIMrBdTntmhOH7lK8+wxJlhh+g8j9MK94Zz8nRmFw7wJuNfLtsot7tS6bonR7suKTf2qGCxHlWqoHOJdz4HW779HB/rvYi96GcrxiIsQGoAG44+F9YjMaszXFkWiKD3dcppt1C4GHb5Pdl9kBq7X5KvSZEEplrcdc6s2mJUyENyZq5iNgyx4z/pEvdSecCYJn9aPWr4qv2OUREm+U/gh91emDB32pOfYskA9yEmcHDJmIPPOkXwNt4eyScjiItIx8JUP5moY1P01gDJhcgAz/QYPXXi+ks0gc+C9B5mo2WPzv7TjGRDPqJrNUKy6bCYQOMJwA7xXm0qLXNSKZVWpqRZ7CkRBlu2NZp8tr//WR
 VufR+oeH
 vvVkk7cTdCtOuT2haoAQpLI+k7P1e0sUxnjPN20f8KixmL6/HkyuiRsqCIxpD/8SGSyBKs+P1aPWx/rGZwJ26iDIK4tT7aoLB3NpYr3FL9wV8MbiOYtvXvJ6vuZaKyqCa8OXunC6tw0gFPY0cjOiDDqcQRPqMWt1SN44kpRQgCeVGx+2VTSGnooTgFJQ2w8Nw2cdkiXIbQIP3j0QbfA5ouP5RTCGaoLIyk+iAVxTIvBu85dcZdzSWE1D8lHhZf1Ay2aqIya30zEDr4Gh1FseagTxCoPot9hMVI23MBa4Qq8M9L4NL3l/m988sMrWWpQQb7gWTGJacVuOc6LPcyE3KkpDkFU8Cpco7L4tPh+oxmRoz8nTP2fX/wiDN2WxC8sTHZtvdsVLYI3CvmPzjiKZCpKhNs8eVmKJASgZQIOgETck7MumoKfcyFZWRLd0HpifJAiafjc4JUBiXgvRFj5CwftsV2fxVD2DsDraI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 11:52=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 2025/7/25 02:16, Kairui Song wrote:
> > On Fri, Jul 25, 2025 at 1:02=E2=80=AFAM Kairui Song <ryncsn@gmail.com> =
wrote:
> >>
> >> On Thu, Jul 10, 2025 at 11:37=E2=80=AFAM Kairui Song <ryncsn@gmail.com=
> wrote:
> >>>
> >>> From: Kairui Song <kasong@tencent.com>
> >>>
> >>> The current swap-in code assumes that, when a swap entry in shmem map=
ping
> >>> is order 0, its cached folios (if present) must be order 0 too, which
> >>> turns out not always correct.
> >>>
> >>> The problem is shmem_split_large_entry is called before verifying the
> >>> folio will eventually be swapped in, one possible race is:
> >>>
> >>>      CPU1                          CPU2
> >>> shmem_swapin_folio
> >>> /* swap in of order > 0 swap entry S1 */
> >>>    folio =3D swap_cache_get_folio
> >>>    /* folio =3D NULL */
> >>>    order =3D xa_get_order
> >>>    /* order > 0 */
> >>>    folio =3D shmem_swap_alloc_folio
> >>>    /* mTHP alloc failure, folio =3D NULL */
> >>>    <... Interrupted ...>
> >>>                                   shmem_swapin_folio
> >>>                                   /* S1 is swapped in */
> >>>                                   shmem_writeout
> >>>                                   /* S1 is swapped out, folio cached =
*/
> >>>    shmem_split_large_entry(..., S1)
> >>>    /* S1 is split, but the folio covering it has order > 0 now */
> >>>
> >>> Now any following swapin of S1 will hang: `xa_get_order` returns 0, a=
nd
> >>> folio lookup will return a folio with order > 0.  The
> >>> `xa_get_order(&mapping->i_pages, index) !=3D folio_order(folio)` will=
 always
> >>> return false causing swap-in to return -EEXIST.
> >>>
> >>> And this looks fragile.  So fix this up by allowing seeing a larger f=
olio
> >>> in swap cache, and check the whole shmem mapping range covered by the
> >>> swapin have the right swap value upon inserting the folio.  And drop =
the
> >>> redundant tree walks before the insertion.
> >>>
> >>> This will actually improve performance, as it avoids two redundant Xa=
rray
> >>> tree walks in the hot path, and the only side effect is that in the
> >>> failure path, shmem may redundantly reallocate a few folios causing
> >>> temporary slight memory pressure.
> >>>
> >>> And worth noting, it may seems the order and value check before inser=
ting
> >>> might help reducing the lock contention, which is not true.  The swap
> >>> cache layer ensures raced swapin will either see a swap cache folio o=
r
> >>> failed to do a swapin (we have SWAP_HAS_CACHE bit even if swap cache =
is
> >>> bypassed), so holding the folio lock and checking the folio flag is
> >>> already good enough for avoiding the lock contention.  The chance tha=
t a
> >>> folio passes the swap entry value check but the shmem mapping slot ha=
s
> >>> changed should be very low.
> >>>
> >>> Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
> >>> Signed-off-by: Kairui Song <kasong@tencent.com>
> >>> Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
> >>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >>> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >>> Cc: <stable@vger.kernel.org>
> >>> ---
> >>>   mm/shmem.c | 30 +++++++++++++++++++++---------
> >>>   1 file changed, 21 insertions(+), 9 deletions(-)
> >>
> >> Hi All,
> >>
> >> Just found some issue here with this patch...
> >>
> >>>
> >>> diff --git a/mm/shmem.c b/mm/shmem.c
> >>> index 334b7b4a61a0..e3c9a1365ff4 100644
> >>> --- a/mm/shmem.c
> >>> +++ b/mm/shmem.c
> >>> @@ -884,7 +884,9 @@ static int shmem_add_to_page_cache(struct folio *=
folio,
> >>>                                     pgoff_t index, void *expected, gf=
p_t gfp)
> >>>   {
> >>>          XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(fo=
lio));
> >>> -       long nr =3D folio_nr_pages(folio);
> >>> +       unsigned long nr =3D folio_nr_pages(folio);
> >>> +       swp_entry_t iter, swap;
> >>> +       void *entry;
> >>>
> >>>          VM_BUG_ON_FOLIO(index !=3D round_down(index, nr), folio);
> >>>          VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> >>> @@ -896,14 +898,24 @@ static int shmem_add_to_page_cache(struct folio=
 *folio,
> >>>
> >>>          gfp &=3D GFP_RECLAIM_MASK;
> >>>          folio_throttle_swaprate(folio, gfp);
> >>> +       swap =3D iter =3D radix_to_swp_entry(expected);
> >>>
> >>>          do {
> >>>                  xas_lock_irq(&xas);
> >>
> >> I missed a xas_reset here, also better reset iter value too.
> >>
> >>> -               if (expected !=3D xas_find_conflict(&xas)) {
> >>> -                       xas_set_err(&xas, -EEXIST);
> >>> -                       goto unlock;
> >>> +               xas_for_each_conflict(&xas, entry) {
> >>> +                       /*
> >>> +                        * The range must either be empty, or filled =
with
> >>> +                        * expected swap entries. Shmem swap entries =
are never
> >>> +                        * partially freed without split of both entr=
y and
> >>> +                        * folio, so there shouldn't be any holes.
> >>> +                        */
> >>> +                       if (!expected || entry !=3D swp_to_radix_entr=
y(iter)) {
> >>> +                               xas_set_err(&xas, -EEXIST);
> >>> +                               goto unlock;
> >>> +                       }
> >>> +                       iter.val +=3D 1 << xas_get_order(&xas);
> >>>                  }
> >>> -               if (expected && xas_find_conflict(&xas)) {
> >>> +               if (expected && iter.val - nr !=3D swap.val) {
> >>>                          xas_set_err(&xas, -EEXIST);
> >>>                          goto unlock;
> >>>                  }
> >>> @@ -2323,7 +2335,7 @@ static int shmem_swapin_folio(struct inode *ino=
de, pgoff_t index,
> >>>                          error =3D -ENOMEM;
> >>>                          goto failed;
> >>>                  }
> >>> -       } else if (order !=3D folio_order(folio)) {
> >>> +       } else if (order > folio_order(folio)) {
> >>>                  /*
> >>>                   * Swap readahead may swap in order 0 folios into sw=
apcache
> >>>                   * asynchronously, while the shmem mapping can still=
 stores
> >>> @@ -2348,15 +2360,15 @@ static int shmem_swapin_folio(struct inode *i=
node, pgoff_t index,
> >>>
> >>>                          swap =3D swp_entry(swp_type(swap), swp_offse=
t(swap) + offset);
> >>>                  }
> >>> +       } else if (order < folio_order(folio)) {
> >>> +               swap.val =3D round_down(swap.val, 1 << folio_order(fo=
lio));
> >>>          }
> >>>
> >>>   alloced:
> >>>          /* We have to do this with folio locked to prevent races */
> >>>          folio_lock(folio);
> >>>          if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
> >>> -           / ||
> >>> -           !shmem_confirm_swap(mapping, index, swap) ||
> >>> -           xa_get_order(&mapping->i_pages, index) !=3D folio_order(f=
olio)) {
> >>
> >> And this part is incorrect. This `shmem_confirm_swap(mapping, index,
> >> swap) ` can't be simply omitted. Some functions below before the
> >> shmem_add_to_page_cache shouldn't be called on folios might have
> >> already been mapped by others. This shmem_confirm_swap ensures that
> >> won't happen.
>
> OK, thanks for the reminding. But could you elaborate a bit? Which
> function should not be called, and what problem might be caused?

Yes, first shmem_add_to_page_cache itself will reset the
folio->mapping and index before verifying the mapping.

So even if the folio is still a valid swap cache folio and the
folio->swap.val matches swap.val, a parallel swapin could have swapped
in the freed this folio from swap, and now it's possible that the
folio is now part of anon memory:

CPU1                      CPU2
/* Start swap in of swap entry S1 */
shmem_swapin_folio
/* Interrupted */
                          /* Raced swap in of swap entry S1 */
                          shmem_swapin_folio
                          /* Swapin done, S1 is freed */

                          /* Anon swapout of folio A using S1 */
                          pageout(folio) !=3D PAGE_SUCCESS
                          /* Now anon folio A is in swpa cache */
folio =3D swap_cache_get_folio
/* Got folio A */
if (!folio_test_swapcache(folio)
    folio->swap.val !=3D swap.val))
       error =3D -EEXIST;
/* Check passed, folio A is using S1 as swap entry */
shmem_add_to_page_cache
  folio->mapping =3D mapping
  /* BUG: folio->mapping is an anon mapping, info lost */

And I managed to trigger this issue, it will result in at least an RSS
counter error like this:

[  1944.374356] BUG: Bad rss-counter state mm:ffff0000c1539640
type:MM_ANONPAGES val:1
[  1944.374384] BUG: Bad rss-counter state mm:ffff0000c1539640
type:MM_SHMEMPAGES val:-1

Clearly it will trigger even more issues.

And other helpers like arch_swap_restore and shmem_replace_folio, they
seems to be OK, but if the folio is not part of shmem anymore they
better stay off of it too. So for safety measure I think we'd better
add the shmem_confirm_swap back. And only checking the first swap
entry is good enough.


>
> >> It may seem like a small change, but it leads to some minor conflicts
> >> in one or two following commits, the benchmark result will change too.
> >> So I'll have to send a V6 I think.
> >>
> >> We can remove this `shmem_confirm_swap`, but not in this series I
> >> think, maybe after this. Need to re-arrange some functions, with some
> >> clean ups for shmem_add_to_page_cache and others.
> >>
> >>> +           folio->swap.val !=3D swap.val) {
> >>>                  error =3D -EEXIST;
> >>>                  goto unlock;
> >>>          }
> >>> --
> >>> 2.50.0
> >>>
> >>
> >> In summary, I'll squash this patch into it and do a rebase of later co=
mmits:
> >>
> >> diff --git a/mm/shmem.c b/mm/shmem.c
> >> index e3c9a1365ff4..4ca0b665b79e 100644
> >> --- a/mm/shmem.c
> >> +++ b/mm/shmem.c
> >> @@ -898,9 +898,11 @@ static int shmem_add_to_page_cache(struct folio *=
folio,
> >>
> >>          gfp &=3D GFP_RECLAIM_MASK;
> >>          folio_throttle_swaprate(folio, gfp);
> >> -       swap =3D iter =3D radix_to_swp_entry(expected);
> >> +       swap =3D radix_to_swp_entry(expected);
> >>
> >>          do {
> >> +               iter =3D swap;
> >> +               xas_reset(&xas);
> >
> > Correction: this xas_reset is not needed, the iter =3D swap is needed.
>
> Indeed, my tests do not cover the scenario where xas_nomem() returns true=
.
>
> >>                  xas_lock_irq(&xas);
> >>                  xas_for_each_conflict(&xas, entry) {
> >>                          /*
> >> @@ -2365,9 +2367,16 @@ static int shmem_swapin_folio(struct inode
> >> *inode, pgoff_t index,
> >>          }
> >>
> >>   alloced:
> >
> > And it needs `nr_pages =3D folio_nr_pages(folio); index =3D
> > round_down(index, nr_pages);` here...
>
> IIUC, the index alignment should move into the 'order <
> folio_order(folio)' branch?

Ok, I'll move it here. It should be fine either way.

>
> >> -       /* We have to do this with folio locked to prevent races */
> >> +       /*
> >> +        * We have to do this with folio locked to prevent races.
> >> +        * The shmem_confirm_swap below only checks if the first swap
> >> +        * entry matches the folio, that's enough to ensure the folio
> >> +        * is not used outside of shmem, as shmem swap entrie
> >> +        * and swap cache folios are never partially freed.
> >> +        */
> >>          folio_lock(folio);
> >>          if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
> >> +           !shmem_confirm_swap(mapping, index, swap) ||
> >>              folio->swap.val !=3D swap.val) {
> >>                  error =3D -EEXIST;
> >>                  goto unlock;
> >>
> >> And I'll do some clean up afterward to get rid of this
> >> shmem_confirm_swap. How do you think?
>

