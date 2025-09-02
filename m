Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45682CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 844F88E000B; Tue,  2 Sep 2025 07:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C408E0001; Tue,  2 Sep 2025 07:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75A278E000B; Tue,  2 Sep 2025 07:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 620738E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:51:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 13F255D093
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:51:45 +0000 (UTC)
X-FDA: 83844145770.18.7D69E55
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 28A0A1A0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:51:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Aepyuw1i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756813903; a=rsa-sha256;
	cv=none;
	b=Sz+PtzQSE2SwvtQjRe2ZaSaTyHuGmlCFKHO+SIPA6McNp5wk+b/AqGW9BPC3JYNSOI4b8l
	oE77ts58IyI0c8ahM5R88Q8v/nvyrDF5FYtSKV2UEHlj4d0dPaFkMNYx24QopPOeYZCsDe
	Mn/NGnSGdpKkufRasPApfawT+3/Du8Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Aepyuw1i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756813903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSvS5Dw8cbSzTPFTeTjrx7vGtggJfEg2AXxdD6ZOy9M=;
	b=QqIv0Po5f53X2Q9cEQCAD8GxwTvIiwLjVNPoHRPgazuhYHjIVKIgPrlZh6OVdddSzp3DF9
	Df+0Czij/7mr+t3GjC2oFBN8Jy4AC2HHTo0hh9pdPmIJP0ayoZTt3rl1KaBfyIH0Bwn6Gv
	S63sJZdzvILlaQRShfLNjXzozAoyDZY=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-afebb6d4093so872407766b.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756813901; x=1757418701; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lSvS5Dw8cbSzTPFTeTjrx7vGtggJfEg2AXxdD6ZOy9M=;
        b=Aepyuw1iolJM4SCta7WuUS3983cFRohU2FUVLmF4X83HdxVqCl26Pr08F5hXZaRP7Y
         3ETb8AtvLIbLbT1DSscmGAyQVELGs7Vb8bOUzFpoO15U/s5BppYjRtZSr4xsxuGxc70V
         SF7GV6vW0FAXCVN0oIhJyK37JZ04fYN0bLdnjEYfooDp2UFHZIQtdxKr0N3IAP0DiBNo
         1D3RSEjJsjpnn80PyC5awZnqd5b6EVRMHAtUJfjq/PfIQjpP6zQH9Ca0zFRshkA+szfU
         4zdcd2G6MvkR5Vl9on/hPzF8rE3a9Htwb12P0x3YPNApp6PPqex0jfdtbezCNee4OgQq
         VvBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756813901; x=1757418701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lSvS5Dw8cbSzTPFTeTjrx7vGtggJfEg2AXxdD6ZOy9M=;
        b=Y5ck3HUMLORK1kQ1bglfEPSDuwQbiNP4Ja5p6wGzOEXf+WkLh40FCNeG0joobuMg6X
         hI2uKMA443Z3heJztNCxrBK4XevWEq3CGSlUBWHtyj/XW76jqx0aOGZp01u3iSJ0kHOx
         OOi2ae414jD/dThkCbZMTQ7Xp2nppPUVEdZL+5L8Hm2hWyIAryPSgaNNo0F83nznt/6r
         jkcffx/uaiuYA8RTxfrpgM5rTDBA5o29odhPckM8rJuQTn/aAaYikmTqWgCRkprh8oz/
         RWnSWOiLqhq2OGoZoIHhU74uGt17o7lkkf8hyPzHxMqyV9A9vojyY2mrZddODD4vGGZb
         tDRw==
X-Gm-Message-State: AOJu0YzlMZqDB9cRTA40Lfou1izS+skUH+mYJ4yjGRlqt6yFl4oOfbbm
	6H3UcPGJXzzzkjIRg9mjwOkXtOejn5leHCnyhjScgMwJ9D3WzWyHdMrWWX5r4E/Rw3vFzOuiJIJ
	iS+5koJOlQy6zOsCaXaFhhd4aOfIAQcU=
X-Gm-Gg: ASbGncuHKQ93jsV8j1Yh0NtgfDCTyMNFMHRlI2BFs8Vwx2M0zn7vNudgj/yatCSvpDc
	E9iOPHzQf2JSzJXeN4SRr4wVTybb+3G2DWE/HWcfjMJ61FCUX0s8wIxImvfpiIXawwPZ0jDdCL8
	v3xAVXn/vEtRaa+d2TD62zjD9JAzzZaT0LwOh5mmDchqk2PHxJuGf44bFEuOAYHebvGuyeEySXD
	Oia7viXJQWmHOkggXPenQ==
X-Google-Smtp-Source: AGHT+IEx3B21oLYPOIdFxDMDtY3rkvLZ5XDzFg7HBKdAm9QNvZitc4dm3sU8EHJLhha4a/khNoeUbmWYmy6zPKCIeHw=
X-Received: by 2002:a17:907:7ea8:b0:b04:53cc:441c with SMTP id
 a640c23a62f3a-b0453cc4688mr191417766b.28.1756813901119; Tue, 02 Sep 2025
 04:51:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-7-ryncsn@gmail.com>
 <CACePvbVVz5G9mC=Od3Uhw9Dkkgz-_jMg9R5EzNxUwx0adKKPQw@mail.gmail.com>
 <CAMgjq7BjsuooaHr=6cYTzGsj1nm+xG7jzCVdEsFgxyBHwq4GXw@mail.gmail.com> <CANeU7Q=_TveYGa2OK93YCRyJRYBc7QVi1pTTfQM7vm4Qh9tNbA@mail.gmail.com>
In-Reply-To: <CANeU7Q=_TveYGa2OK93YCRyJRYBc7QVi1pTTfQM7vm4Qh9tNbA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 2 Sep 2025 19:51:04 +0800
X-Gm-Features: Ac12FXxYKyC5qWDDx3xJPXEBEpk0d9wlxb__9hhFkPyO3auILUM2eu8faNXvPQ8
Message-ID: <CAMgjq7CWPt8Ue7AjkfwAtFEtsZx8wk3Ge4LcFHx9=ur9vUCEyA@mail.gmail.com>
Subject: Re: [PATCH 6/9] mm, swap: use the swap table for the swap cache and
 switch API
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 28A0A1A0003
X-Stat-Signature: fanrwr8nbwpddwq87ts156gihwi1k4ts
X-HE-Tag: 1756813902-553598
X-HE-Meta: U2FsdGVkX1+8Pbfda7g/WKM1x9BUI6qU4YvNS8jR9amzO/we6Y6kvL+nziLinZ6d6dpXLLD9lIhVp6eDon2RtzVm8z7KOl7a12k+Hu1uPBgk7RDT+lBzA4zYW1+H448hnTMNucLtNVNR0CYHruFYoojb7xhaiaFqsiI4DpYXg2mcYxc8FP3MoXSOqXm3OSe0qv1/a168tPx4snwBrDO8jNVLLINn4jFKmZtx04HUrSfQXQ+vctPqVY39kyYAbPs/upN7NOphvDRXfds0McipE1nJVuVhApjQYsdkMDvbp0pLe6GNF147BOhYfZMCn35XbFmnFDUrGgjMbbm0VxNd14AbqjsFXafMIr3mhW1KQXfyux11dZ7Nr/80lXTXpZmy4pI3MOPXA92aXxUKRiAhYlhxJASkco/qzSZKlZijXAdPLjNXEwEtWO3ILO7MTEB4Ou/2zwLUNfhHXm2vuQhDRrrhTXCjTraa9t+NQXFLpWKoftN+CoZ/rehXaeugr187QQFCVDw0v0z5Tpc0rWIGJCqjiMhkBGuNM+os/3hrV+uniaYK6jVplwH3FjFzZnws3poIe5WxQ464AhzI796PTIyJzYhu6D9cX9tCfvOXnWqkfifQ/4sX9OhU4DZT2Pl89JrlAs3L+xFNXXf6FiX36tQ7UbT7oLVD9H7qYja4PvvUnSysjr0S62Uw3Cw8rFRc7cM/TjEkdbkh1Q9YES54reC4SkhrvwwoQ3eRI4ZuNKkMaAxVCLVN+THNuEVmOxRRVeLRrcvDHCsAw4trjPvAXifnMFLVA1Z2NcPiGiaSNvp7ONYNy+phpbSY1aouYMKowCSxB/B/ajeQhYuVNDwgsyLsTwt8axc3qcXJNkCjQT30b6BTMH6u+sHzPaepAs9NDUs0ual0jnunjIL6M7uZq0Q7VYX9v1LrsFBpu5rxjKR+WVxDpaw5aAT0NWoZwbJpL1DXCuBvO52oAdM81cw
 5HVPmvJq
 PSsQsaed81jeKLlJHbaLXMIYk7qqTPef+OhrCSlyu0dUZ529pMQf4YEqiN0RYhHrwG5Fj54J+IbjNwxa/8uf21mPD3NvC/2bDQzSLfWKoxFFcIqyQo5o5eFToceQNLBqTdxmufB75Fb0EMVc+70cOEaDEOOYTXm8+TtAue7CbVPFhP7PeBqIVA/JxGGJ1D6zkaroPP0KtFDX0p0j+uyA8lq4FqAhKabzOpRAt7lSHYRjjvHT1sIkmTzjKxD6OprU8usBxUOu15lL0+4I3BQTGwPXt/3+J54Y7ZhtIixhLUChRZQi4Smt78Avk2IooLJ6J1agfb57dRVRlgImrKLZB/jMYfEDdbupUJIj7sALy1tBx6UO3fUv9fHylPdrRpwQ6ivV6FxlufhA86jOirb9Ae8RTxGyrX/N+E4jliEfybrnyKeVM9VBFTwSgpWazCw3THQEWQdD/pPlEf68=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 31, 2025 at 9:00=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> On Sat, Aug 30, 2025 at 9:53=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > On Sat, Aug 30, 2025 at 11:43=E2=80=AFAM Chris Li <chrisl@kernel.org> w=
rote:
> > >
> > > On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.co=
m> wrote:
> > > >
> > > > From: Kairui Song <kasong@tencent.com>
> > > >
> > > > Introduce basic swap table infrastructures, which are now just a
> > > > fixed-sized flat array inside each swap cluster, with access wrappe=
rs.
> > > >
> > > > Each cluster contains a swap table of 512 entries. Each table entry=
 is
> > > > an opaque atomic long. It could be in 3 types: a shadow type (XA_VA=
LUE),
> > > > a folio type (pointer), or NULL.
> > > >
> > > > In this first step, it only supports storing a folio or shadow, and=
 it
> > > > is a drop-in replacement for the current swap cache. Convert all sw=
ap
> > > > cache users to use the new sets of APIs. Chris Li has been suggesti=
ng
> > > > using a new infrastructure for swap cache for better performance, a=
nd
> > > > that idea combined well with the swap table as the new backing
> > > > structure. Now the lock contention range is reduced to 2M clusters,
> > > > which is much smaller than the 64M address_space. And we can also d=
rop
> > > > the multiple address_space design.
> > > >
> > > > All the internal works are done with swap_cache_get_* helpers. Swap
> > > > cache lookup is still lock-less like before, and the helper's conte=
xts
> > > > are same with original swap cache helpers. They still require a pin
> > > > on the swap device to prevent the backing data from being freed.
> > > >
> > > > Swap cache updates are now protected by the swap cluster lock
> > > > instead of the Xarray lock. This is mostly handled internally, but =
new
> > > > __swap_cache_* helpers require the caller to lock the cluster. So, =
a
> > > > few new cluster access and locking helpers are also introduced.
> > > >
> > > > A fully cluster-based unified swap table can be implemented on top
> > > > of this to take care of all count tracking and synchronization work=
,
> > > > with dynamic allocation. It should reduce the memory usage while
> > > > making the performance even better.
> > > >
> > > > Co-developed-by: Chris Li <chrisl@kernel.org>
> > > > Signed-off-by: Chris Li <chrisl@kernel.org>
> > > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > > ---
> > > >  /*
> > > > - * This must be called only on folios that have
> > > > - * been verified to be in the swap cache and locked.
> > > > - * It will never put the folio into the free list,
> > > > - * the caller has a reference on the folio.
> > > > + * Replace an old folio in the swap cache with a new one. The call=
er must
> > > > + * hold the cluster lock and set the new folio's entry and flags.
> > > >   */
> > > > -void delete_from_swap_cache(struct folio *folio)
> > > > +void __swap_cache_replace_folio(struct swap_cluster_info *ci, swp_=
entry_t entry,
> > > > +                               struct folio *old, struct folio *ne=
w)
> > > > +{
> > > > +       unsigned int ci_off =3D swp_cluster_offset(entry);
> > > > +       unsigned long nr_pages =3D folio_nr_pages(new);
> > > > +       unsigned int ci_end =3D ci_off + nr_pages;
> > > > +
> > > > +       VM_WARN_ON_ONCE(entry.val !=3D new->swap.val);
> > > > +       VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_lock=
ed(new));
> > > > +       VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_s=
wapcache(new));
> > > > +       do {
> > > > +               WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, c=
i_off)) !=3D old);
> > > > +               __swap_table_set_folio(ci, ci_off, new);
> > >
> > > I recall in my original experiment swap cache replacement patch I use=
d
> > > atomic compare exchange somewhere. It has been a while. Is there a
> > > reason to not use atomic cmpexchg() or that is in the later part of
> > > the series?
> >
> > For now all swap table modifications are protected by ci lock, extra
> > atomic / cmpxchg is not needed.
> >
> > We might be able to make use of cmpxchg in later phases. e.g. when
> > locking a folio is enough to ensure the final consistency of swap
> > count, cmpxchg can be used as a fast path to increase the swap count.
>
> You did not get what I am asking. Let me clarify.
>
> I mean even if we keep the ci lock, not change that locking
> requirement part. In the above code. Why can't we use cmpexchge to
> make sure that we only overwrite the form "old" -> "new".
> I am not saying we need to do the lockless part here.
>
> I mean in the possible sequence
> WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_off)) !=3D old); //
> still "old" here, not warning issued
> /// another CPU race writes "old" to "old2" because of a bug.
> __swap_table_set_folio(ci, ci_off, new); // now "new" overwrites
> "old2" without warning.
>
> Has the typical race that you check the value old, then you overwrite
> value new. But what if the old changes to "old2" before you overwrite
> it with "new"?
> You overwrite "old2" silently.
>
> I mean to catch that.
>
> Using cmpxchg will make sure we only change "old" -> "new". We can
> catch the buggy situation above by overwriting "old2" -> "new".
> Also when we find out the entry is "old2" not "old" there, is WARN_ONCE e=
nough?
>
> I also want to discuss what we should do if we did catch the "old2"
> there in the swap cache instead of "old".
> I feel that continuing with WARN_ONCE might not be good enough. It
> will make data corruption popergate.
>
> Should we roll back the new value and fail the swap cache folio set
> function to avoid the possible data corruption?
> if we found "old2", The new guy can't set the folio to the new value.
> Deal with that error. Will that avoid data corruption? Not being able
> to make forward progress is still much better than forward progress
> with data corruption.
>
> I just don't want silent overwritten values we aren't expecting.

Right, I just think-through about this. If we are super cautious
during the early phase, we can have more non-debug checks for
potential bugs.

There are currently three places modifying the swap table: replace
(huge_mm, migration, shmem) / insert (swapin / swapout) / del. I
checked the details, basically in all cases, there is no way to
rollback. Once the data is somehow corrupted, any operation could be
in the wrong direction.

So yeah, let me add some more checks.

I'll slightly adjust swap_cache_add_folio too. In this V1,
swap_cache_add_folio is designed to allow races and returns an int for
potential conflict. But , it should never fail in V1, cause there is
currently no racing caller: we still rely on the SWAP_HAS_CACHE to pin
slots before installing the swap cache. We will kill this ugly dance
very soon in phase 3. (phase 2 removes SYNC_IO swapin is an important
step). I used this version of swap_cache_add_folio from later phases,
just to make it easier later. So in V1 let's make it WARN/BUG if any
conflict folio exists and always return void, that's safer for
catching potential bugs. I'll change swap_cache_add_folio to allow the
race again in a later phase.

For other places, I think a relaxed xchg with WARN/BUG should be just fine.

Later phases can also use something like a CONFIG_DEBUG_VM_SWAP to
wrap these, after things are verified to be stable.

