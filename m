Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FA1ACA0FFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 16:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839EA8E0002; Sat, 30 Aug 2025 12:53:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C37A8E0001; Sat, 30 Aug 2025 12:53:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68B2D8E0002; Sat, 30 Aug 2025 12:53:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 51A5B8E0001
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 12:53:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0459B1A01FA
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 16:53:19 +0000 (UTC)
X-FDA: 83834019360.21.544BE94
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3861840010
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 16:53:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="F0va/VH6";
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756572798; a=rsa-sha256;
	cv=none;
	b=JSAq+vWd83ku4mYmof5JUwm6e4Tx0z/+KtaWhSg7widL2fktz9TWz3PBvku9DwQQnsmdZc
	8ro5F/41r1wNjiz/BacGMIOXehPi1QJtXkF01Rr8h7xE0BFNMzmyqFI/Tiob79QaqYzEs3
	HYu/UtH8YiHAKEh0jAsvPfio5Hvtbz0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="F0va/VH6";
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756572798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/3ep0bCmQiqVsV1i5AG/4ePqsJvhv+CF0yAihCPBkTA=;
	b=qF524ZkziiEBEZKxqNTLG3GQR/XjIYZ3Mc9jsrUnGOoaN4r1BVdKpwBJP35UnX0sfn1tKW
	XQF9c5lxzFX/4Trpx/aKdU7Ss305wS3h3sOWj66YBkuQDxnLEsFR8tCcAEPdMvVRFsqGA1
	P5gOaFCC8JerPE+VktstD+7Tfy0auaY=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-61d28950476so1132569a12.0
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 09:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756572796; x=1757177596; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/3ep0bCmQiqVsV1i5AG/4ePqsJvhv+CF0yAihCPBkTA=;
        b=F0va/VH6YVhm7FRm2mWJ6ZW1xaj1FEGGe4ltoy+8/Mj/sAhqGjbbcBoRFeuO1Zi7zq
         HzNXKto7cEynleWmKF5qcea4zjKWyABpgrkZTPKjq8WWFulTrEzoA/q/etjfpz5IzIRp
         GQ+7g+bzEw0RTpew59guQugTVWK8CXG2pX0C9F4ekl97Q5Bnj/0GtZk0FW17g6Dr+9S2
         Bd2Ll+MFfIuNtXGsLQl9hTiM7xNUncf3lVNQIru/5lhiYHi11HJf0rz28Q2l7ow7RpTj
         9s2tui+iDW4sP4p8X3bIOkC33JVDo0HkYbII2tO/FRoogYriCQpINweg9dkjvesrt+F1
         5sNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756572796; x=1757177596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/3ep0bCmQiqVsV1i5AG/4ePqsJvhv+CF0yAihCPBkTA=;
        b=BkAfM30ugHiIgvb6wi+Pxi5OC+TWtA2LhCM7XJO2KVl4PfiJ8itRq4Jj1NFZIcCuWt
         Zcp6uWg63AodIy/2S478baePOleV4U3YDN4AblPS25LHFnikUYHqznxcoSwBrOpe1gaK
         x6WWg3/oC9d5wPbM4p3+3Pg/uA7gN5i9WEEWDwttNXBRCYccz29vReoVfWKyp8DXTI0U
         pJrxQE3Lmf0j3e3t0YMGW/bsrDhKhsH7rB6xlPYPmJgK83X6XuXl0aNzI4Xz9wk3tP5g
         44JhPsskOXvG6d78QZ/fuo2MX8fIqw26B4zH/swksv6emksVwUsGJtUzdxwwTYKFrlSm
         8hew==
X-Gm-Message-State: AOJu0YwUNO1lKaqLjwQAfgJIxRO5uPncZEFGKVWJY3WpOafMe9oFhknu
	28byKEZdJAfycYE3N7oWOIrdbQAJmfDmFz7/YDv0dl2pBkLKFS+OPxewQgxlcgWVmsm59Di0UA8
	H3IChQNjJFEMwNFC6DRYKCa48oOTw5Ts=
X-Gm-Gg: ASbGncuE3ILDrAt1JXmY2KQGaY7BgHVm/gyR/4YsMp9uOx2yOJ8F0rZrVMoxIlITZo3
	0x0GYqY5+iBih7yQ2X10q4DlRGGi9R2/wJ7bMMhVvP2WqORMdBihlnp58qKMEy9GVDhrjwWI9Rq
	rAoBg0aKASKaiRGtMrQcu6oRbOL+4IdGeOSX2T+6szPcAWpx3ki+EQXWlbInV4W9xDKsAjDmvva
	3MQcFmhHjSS8ftd6A==
X-Google-Smtp-Source: AGHT+IFdDEGaMeg7X7RmM8uQJ1o0p1N6UcwN57NiYKrqIrh1Zx4Y8B5e/LiSK1SPCLcJ9Iisv3/279yBCICL0dkSc/0=
X-Received: by 2002:a05:6402:504b:b0:61c:5264:902c with SMTP id
 4fb4d7f45d1cf-61d26c53e03mr2342187a12.23.1756572796291; Sat, 30 Aug 2025
 09:53:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-7-ryncsn@gmail.com>
 <CACePvbVVz5G9mC=Od3Uhw9Dkkgz-_jMg9R5EzNxUwx0adKKPQw@mail.gmail.com>
In-Reply-To: <CACePvbVVz5G9mC=Od3Uhw9Dkkgz-_jMg9R5EzNxUwx0adKKPQw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 31 Aug 2025 00:52:39 +0800
X-Gm-Features: Ac12FXwIsQ5-CWCgMfQJCfaWrkz57jn-Epp2yA2_GbyTb-IBX7npj9twC9L3zqo
Message-ID: <CAMgjq7BjsuooaHr=6cYTzGsj1nm+xG7jzCVdEsFgxyBHwq4GXw@mail.gmail.com>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3861840010
X-Stat-Signature: 15aczydgtyhrqq17pnzo97pgkjmf5z61
X-Rspam-User: 
X-HE-Tag: 1756572798-319415
X-HE-Meta: U2FsdGVkX19QZxep0sto+GcNdZmt3psLHdTHAWF8K395CHuCxZbq1MjoXvCDThNSdhCMRdF3zC52hDNjH2/6IR6WM+uTQHcou1SHRvswCJrkeIr8HyuguYOfyf9btGoFMeOTAC0EFwV8e/IMv9/AqQRaiuK51ZaTf8zwgf+6HyA8sgGIcsW5JZp4eq8CbP2MS8ZjfKeE+frQmfYFle61+qlrcFO2jFoJ72cpPsOII/AjLngSrdejO2/9zH1tgEDTyerzj5bcfWk81WPhWFM0KURgMJ6zBtLKxbeGEcJ9QAkOf7GMPylSa+xonlpDFRLzdt2Ci6v59BDY+JEpgVLs2Bj+5x9hYRA1pfyJ8JFqD2M3o7h3Oh56uoYG9mdDn20OBgHp2x1Nz2dbsuoyybZrmbxyTL2YIYuFzdm+uf4bRlzdmbivmtMZBrgdgkrmYE+Mz/FAOxk4AICmYzpkDqg/0UUDwl0z9ZkLbUrlxCcqtr6dr2bYE1OHeIyGCW7hLHkdCnSYKvz9iWgJ8Cfr2bhpFmm55srh3vd2v6HIP+xpO9iqQKvCW1y9SUOFHi7ug4ObSkpTRD7GTTFb3xka3S21zsAO45SYZBssgFl/e8RD3r+iens71lT+DWNCSaEsJfBJ0AXbVjMib1M3E4JR5p9k1UC+fErAEKyfvbh8U3tMrn2W7f1lbe9RUVOXRAspWdHhQ0uexqFhBVawPb8zOqIlH5uKrwyLCZvcNBUQSIomJuCusLIqB7HCAmnM2Gia9Pb2XVYWL2UqaI1cmbug3QFINvMuVnqI2Nod0ano3jXxI/JLzSsaqzHhoCJfnY7BFlHek2vdyYWE/GghE9vD3DizRMZPUQ1PwhPf+R0CDmInDeD4snnpVCL101oda1GRueYyPXuit9rCsDcJ6zAH9NGd/byNHzW0FGd38XT0xq8HmmHb0c5lpENxsYrXINGaiTxGBjfX+cMeRI40cfw8Yeo
 iurAVVUM
 xE8wi8FU78K02wI8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 11:43=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote=
:
>
> On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Introduce basic swap table infrastructures, which are now just a
> > fixed-sized flat array inside each swap cluster, with access wrappers.
> >
> > Each cluster contains a swap table of 512 entries. Each table entry is
> > an opaque atomic long. It could be in 3 types: a shadow type (XA_VALUE)=
,
> > a folio type (pointer), or NULL.
> >
> > In this first step, it only supports storing a folio or shadow, and it
> > is a drop-in replacement for the current swap cache. Convert all swap
> > cache users to use the new sets of APIs. Chris Li has been suggesting
> > using a new infrastructure for swap cache for better performance, and
> > that idea combined well with the swap table as the new backing
> > structure. Now the lock contention range is reduced to 2M clusters,
> > which is much smaller than the 64M address_space. And we can also drop
> > the multiple address_space design.
> >
> > All the internal works are done with swap_cache_get_* helpers. Swap
> > cache lookup is still lock-less like before, and the helper's contexts
> > are same with original swap cache helpers. They still require a pin
> > on the swap device to prevent the backing data from being freed.
> >
> > Swap cache updates are now protected by the swap cluster lock
> > instead of the Xarray lock. This is mostly handled internally, but new
> > __swap_cache_* helpers require the caller to lock the cluster. So, a
> > few new cluster access and locking helpers are also introduced.
> >
> > A fully cluster-based unified swap table can be implemented on top
> > of this to take care of all count tracking and synchronization work,
> > with dynamic allocation. It should reduce the memory usage while
> > making the performance even better.
> >
> > Co-developed-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  /*
> > - * This must be called only on folios that have
> > - * been verified to be in the swap cache and locked.
> > - * It will never put the folio into the free list,
> > - * the caller has a reference on the folio.
> > + * Replace an old folio in the swap cache with a new one. The caller m=
ust
> > + * hold the cluster lock and set the new folio's entry and flags.
> >   */
> > -void delete_from_swap_cache(struct folio *folio)
> > +void __swap_cache_replace_folio(struct swap_cluster_info *ci, swp_entr=
y_t entry,
> > +                               struct folio *old, struct folio *new)
> > +{
> > +       unsigned int ci_off =3D swp_cluster_offset(entry);
> > +       unsigned long nr_pages =3D folio_nr_pages(new);
> > +       unsigned int ci_end =3D ci_off + nr_pages;
> > +
> > +       VM_WARN_ON_ONCE(entry.val !=3D new->swap.val);
> > +       VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(n=
ew));
> > +       VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapc=
ache(new));
> > +       do {
> > +               WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_of=
f)) !=3D old);
> > +               __swap_table_set_folio(ci, ci_off, new);
>
> I recall in my original experiment swap cache replacement patch I used
> atomic compare exchange somewhere. It has been a while. Is there a
> reason to not use atomic cmpexchg() or that is in the later part of
> the series?

For now all swap table modifications are protected by ci lock, extra
atomic / cmpxchg is not needed.

We might be able to make use of cmpxchg in later phases. e.g. when
locking a folio is enough to ensure the final consistency of swap
count, cmpxchg can be used as a fast path to increase the swap count.

We can't do that now as the swap count is still managed by swap_map,
not swap table. And swap allocation / dup does not have a clear
definition about how they interact with folios, and range operations
all need the ci lock...  We might be able to figure out a stable way
to handle range operations too once we sort out how folios interact
with SWAP in a later phase, I tried that in the previous long series
and this part seems doable.

I'm not sure if that will benefit a lot, or will it make it more
complex for the high order swap table to be implemented. The cluster
lock is already very fine grained. We can do some experiments in the
future to verify it.

But the good thing is in either case, this is on the right path :)

> > +       } while (++ci_off < ci_end);
> > +
> > +       /*
> > +        * If the old folio is partially replaced (e.g., splitting a la=
rge
> > +        * folio, the old folio is shrunk in place, and new split sub f=
olios
> > +        * are added to cache), ensure the new folio doesn't overlap it=
.
> > +        */
> > +       if (IS_ENABLED(CONFIG_DEBUG_VM) &&
> > +           folio_order(old) !=3D folio_order(new)) {
> > +               ci_off =3D swp_cluster_offset(old->swap);
> > +               ci_end =3D ci_off + folio_nr_pages(old);
> > +               while (ci_off++ < ci_end)
> > +                       WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(c=
i, ci_off)) !=3D old);
>
> Will this cause the swap cache to replace less than full folio range
> of the swap entry in range?
> The swap cache set folio should atomically set the full range of swap
> entries. If there is some one race to set some partial range. I
> suspect it should fail and undo the particle set. I recall there are
> some bugs on xarray accidentally fixed by one of your patches related
> to that kind of atomic behavior.
>
> I want to make sure a similar bug does not happen here.
>
> It is worthwhile to double check if the atomic folio set behavior.

Right, some callers that hold the ci lock by themselves (migration /
huge_mm split) have to ensure they do the folio replacement in a
correct way by themselves.

This is the same story for Xarray. These callers just used to hold the
xa lock and manipulate the xarray directly: e.g. split generates new
folios, new sub folios have to be added to swap cache in the right
place to override the old folio. The behavior is the same before /
after this commit, I just added a sanity check here to ensure nothing
went wrong, only to make it more reliable by adding checks in the
debug build.

I checked the logic here multiple times and tested it on multiple
kernel versions that have slightly different code for huge_mm split,
all went well.

>
> Looks good to me otherwise. Just waiting for confirmation of the swap
> cache atomic set behavior.
>
> Chris

