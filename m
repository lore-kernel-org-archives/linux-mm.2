Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FBC9C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2674F6B008A; Tue,  8 Sep 2026 02:33:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23F3B6B008C; Tue,  8 Sep 2026 02:33:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156566B0095; Tue,  8 Sep 2026 02:33:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E15426B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:33:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7519912039F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:35 +0000 (UTC)
X-FDA: 85189628790.14.B99729C
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8DB5920002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PTbKrRqH;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KahS5bRLriJtyNOdhgL7SyjjlJxTSa5+53aCYRqdY+o=;
	b=htZ2phfIKZJegw9g7MW3w/PhSguKSTBCLflSEJSjKyP6ckiWSJq77p9gqE0RgsYvf5oXax
	sfusH/LJrahSyxVzaCkBG8Z+cfkr5ypSDJXMLGNaNBuTqOcEzso6s1RThPDaqNQqn5rL2E
	FCJngB/tGpRH1sYZPzXOuyiFFmsn/iY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788849213;
	b=xstLFHkdnYr1sWdg7Wz4u+nk6RsFkDLxHaQTBxHRoPMqGZA4QGDHh3PnGvJ82W85ohNElx
	Kx85lEfNMX6l7WxA6rPoLTP8qkxKf0wMbBv5g3Sf/8vjQf4KrS/0MfgCax2UmOCJW+zfBU
	ZvZ7s6tUVWFpj9OTeaD1wT7YEehSh9k=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PTbKrRqH;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c250f28f1cdso672030666b.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 23:33:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788849212; cv=none;
        d=google.com; s=arc-20260327;
        b=BFFQE3gGruaDALPBY9WjefP7RJS4apnV3+gq8McZR/SfzTLoEmUAuG95HZ4dkIsIM7
         xlHYXaSkP6U9PM0DH85Ws7fVv0f46eOg8TjC339ybJ8wwwnSE4pFm84yIYU+oNthQuTd
         ASFaKdUe2uSEhqp3/BBGTIW8suOX8SmgBuqfis2CY7eT0nuHrmQZ85vqhwcJlrSUl+fa
         X4jYLTS06/5tsva4ApuPJV+IAsz2zYPJilBdY/WECFeChfhJFHLmszPyJ9rGissIeyp8
         C3mwtqQz4CSst+vNBg2wJzOQ8dHYZrGfxul8chFK5kkwXoEXTc+grDlHspCOAXjLIapz
         uHbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KahS5bRLriJtyNOdhgL7SyjjlJxTSa5+53aCYRqdY+o=;
        fh=jT1PJgl4q5TAn1RZiofrWpnV+OLddN+NkcsljwJi6Nk=;
        b=HkXAFVKXIIcQLoJ/YE7Rw9S+Fo0Z9fLEFk02fe3hr04V1E+u5QAQJkAk6v1X3mh9OK
         4d4r2bh9gGSSODKTnuSJbLFe1U4ufHNZH16XFHVhaKG9K4Giu6HUl5K6G0khEL4E7MDl
         +pqATLajrJCuuD6qTRzvfQ+GERvb3Ed+6hpmjGNTq9kTWeguhTvy8MfLEeIIjTdSfJJZ
         M5yD1TIq6FVGGMCxXe6VFhcWaYMuQPRx//DuxUBAVhOTb86nLTU98pJ818yL1GEYbTfM
         sm5ZNEJleIIJujGthewiUkqD4M6adaLq1oQEyT7aDf/gqGUgipSnPTN8XQ4Tkv82BC60
         i8uA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788849212; x=1789454012; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KahS5bRLriJtyNOdhgL7SyjjlJxTSa5+53aCYRqdY+o=;
        b=PTbKrRqHjQfzUHF4IWKqbE5y2wtz9gr23Fou3srdL+WEAoRe6oRReHMr+DHSSds0I7
         0BK2aesYV5NZqUx3Skg/2CRSXtRUXiuxlV2a0NP8D/05+LaCjo+uceqfDl8OCcVLYHf+
         JdR18w8R0blTHxyn61QqwQC+5KeOZMnJ0yeinj9/SvjBe0aLNgsqoAn6PgpxNqog+aFa
         pC6oKOQtuJsRrImPCP5mAiccM7E1NDA38So20f73mX7U461F8V3ISMyRRZBxJADkEN0M
         09t15KLoz4MIzLhWRBFcdZnQBRp9pxCEaoXLHOwKfwGqL0xpo0ZwZW0knIdZL5sv+nju
         kUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788849212; x=1789454012;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KahS5bRLriJtyNOdhgL7SyjjlJxTSa5+53aCYRqdY+o=;
        b=tQQQ9vw4Qz4iXm5aUg+EqkZMuVn+0FkhcHr4QeCs+Md43nvRwt7JfgCOy2AOUToCSi
         UZqr9RM/8xc+DaJ0q2lt49XpxRLhACmAWWmG8t9J7jUdir2LnyHFP/NLe7kf1sCpKITW
         CQAHl7I1QXtqwyeQyQhUs5mpj6JpGLoLTZNsmvun+m2Hce4Ojd0us0jdjUarGG6gnGDB
         ra8UmAHTAvYbv+Bh36QDTxkDOiIzj5FhiVHjSyHkjz3OynhlUQ6wc9hmmIVKxzTZ+IQl
         ve7IgQ392JOKANUsQTMg7u9GmjEi1xqgT0yPKkA5NOS7AFiFOHavtyWU66iTunm6qe1Y
         W/wA==
X-Gm-Message-State: AFuF++nXEOLp+SLNKr3c/jHNA/wt0QNpqjRvRnqtY5lnfUZ7CMZ6Jrpa
	K8l28jKxlNYFmEuQwOcSiHjEYaVMBp2vtjZKDMnxROc5GiKYzdvMY+y/p8GhqWCBqZEbbyAmg0v
	Y/toPudyO4ULEU62JknMWTUahnyeANqk=
X-Gm-Gg: AYBFou3N5H2BLt2Ozbbi24gOOdeiFW7+WoWJr/8vcAI5CgM9PNjwF+3Xe2aw2j5e/SE
	c4HnpNA8C0yBd6PeFfu9M9ybMhMmyRV+Q+PV6X0OXOzBuv9hChuQ2rueSMJ4qyFBQdM+Y3Trk76
	NHu8ZbGTg/ELw/t+4N1AQFZhl206Gy44bPkt6QkOUFvUKtxLOyNZag1PuWEOlvO+6ilpSJU7F/t
	jgimi5kZmdRvoY/62RNWAYkVvSijgO1wSy9g9SJJry4u2etEgrbXQhT/ljSsLpnxDwt55ndDaEZ
	BA8sOEqgxuogltZ3EC+0jRb0qfLasIaAQ4kuqjRkAbZFNDRgst4/dlmnixDQ5hk9C3WeHpPwkX9
	eco8=
X-Received: by 2002:a17:906:478f:b0:c26:19de:9ad5 with SMTP id
 a640c23a62f3a-c2619dea727mr969630366b.45.1788849211595; Mon, 07 Sep 2026
 23:33:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-12-b532a3f20e71@tencent.com> <DL9DHWXVU0YR.2LTES896PBMJO@nvidia.com>
In-Reply-To: <DL9DHWXVU0YR.2LTES896PBMJO@nvidia.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 8 Sep 2026 14:32:55 +0800
X-Gm-Features: AcwNN1WYNxaoAsw5NBSqsq02qN2vugN0LXLlxY0rzTzuTDZjXyZe74gvaxoUv5M
Message-ID: <CAMgjq7Db_0eDyddHp8zxHoCkauh_OL0WsKOdTfF8ZvV93MQ9pA@mail.gmail.com>
Subject: Re: [PATCH v4 12/17] mm/huge_memory: move anon_vma handling into the
 anon split helper
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>, Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8DB5920002
X-Stat-Signature: oyipcc7i7szgr18p19qj4s39fm7djkqa
X-HE-Tag: 1788849213-198050
X-HE-Meta: U2FsdGVkX19FWMq982uMomTmb/OtRbokrgIVo9c2EbqXXB/z30XM2gGYlArR/k+dx0PSFcrYi0de4ED91o8GWGsDKNoz7iWyQdDT+lJuI0PjoL05JPwCXp6HL4k7TlsyIaSlhuwyWRrKn4CtHfPReWnRORkuWdl1ZstDUM1mRN3JJdnVzisl6g89y9cv9kwJt+yoMb5DbmdN4IWiaY8PDpxydnKyQKmRQNgJFNB3IhpoMO+bmM6trtiisTIxggS8kVUGzyoX3g+RTpQnGWZVFHMGjp+Tsf7g+/yxmIkgzp48a7gNyddmQqRvJsjj1Qb31sx9QQaRM4mC01Cyww7eD2anobywgrDXu46qbSx7cxTKzwoKJJkxcxppXxJKQf1mPgCPLjjD5g1LlSNJUVZjI61p/af/tSHoC+TwpfI6Gng3N0OkmeVaEqNBoja7Sq5/v6z7Nbd4vYKxNKnoURSYC+IjbrWPEEAE66MClJMMOs55GVAPad76jhPx/fjeQQoGeuHdKJrYjwNnHJNTGcyV0BSNY8GrDLBS8LTDcIkiimEEoJqKIEZQ+vYHPJYBDbhPKznhV58+L2HpEF5X8VqA4nR7TTyTP3qrjXiG/trjCagfnCWi6POjheUxmstD1iANakE0XZLk+yVYtUqAj6vS5RJV0wjPxLYleE8MTgmI08UZXiUpQQeYHEikIiKwye22tYpu2ZRZ08+8Lk6p/TbRBsu4kT4kxI21qWsw0zWI3dGEw4jOdUSMcBuSCZOq2G20Uhp91XTReXJUyJEVtyCGjbIXxJ7hgiHf5COHZd3vCokYMipnO8oUzxrhX+hcdyPhCcXXmwzYMrwDiV/ZxUeHwKExY78prT8XfO3V1s6IPWdO+s0k/eormJ0kZUIyoE3Zd9Dt4i6rrpSzE9o1GMhUiBxksCBdBHldeIzIy/qIQ1nVcwmUqM8o0J8QV8MyFAbP5j6ganCoIh8VtmlPHrI
 CgQQQ4KX
 VjHKrK57LtlvT3BDH/kM4MN2BtY470GPztNIblIOKmvbHTfnda7nhlynb491EkjnrGhZk17gG8EmuZXVXJH4uSSJtHjrAElN9bz+DR/aVlIIS2BQosxsORYPhNP5DkW39InMGotw4PIuahThmAoqXjQo9pR+7LbzoQl0dvc9q1sS2xwWLVx+AlY66jK0BPUwnMG46GkgcC/xucUIOsvK1E/twcP4rvmJB7FWE2wQmL9an/w+yZUTPu+05bWqwBRBvl24e1yjr3hvD6fOAb62Y7FO4WORL7jDIYO5yFcJVyltbuPh78qr9BVFktqcjqBZToviRSNvEZOeC2iAB9+OoIo35Q28CdHqFz1pIUIwxOZSmNGB4TjPF7vEBeyRw1N4wkDAhAR05yRw2iTr6DrluZa+zpcJ43SqMhaoqkAUI0KkRQ76WMPz1U6TsG6WqmUHWF01SaztRozad4T+0de9BTFkM8ezBqrZdrAJOxClfa+/79wYy52wgW7n6Hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 8, 2026 at 4:40=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On Mon Sep 7, 2026 at 2:12 PM EDT, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Only anon split needs the anon_vma, and it only needs it to unmap and
> > remap.  Move the folio_get_anon_vma()/anon_vma_lock_write() pair out of
> > __folio_split() into the anon helper next to the folio_mapped()
> > check that already gates unmap_folio().
> >
> > This makes the anon_vma conditional on folio_mapped(), which is a
> > behaviour change but should be fine.  folio_get_anon_vma() returns
> > NULL whenever !folio_mapped(), so an anon folio with
> > folio_mapcount() =3D=3D 0 used to get -EBUSY from split_huge_page() and=
 is
> > now split instead.  The realistic case is a THP that has been fully
> > swapped out and is still in the swap cache: swap PTEs do not contribute
> > mapcount, so it is !folio_mapped() but still alive.
> >
> > That should be safe and right to have because:
> >
> > - folio_ref_freeze() below still rejects a folio that picked up any
> >   reference, a mapping or a GUP pin, in the meantime.
> >
> > - A parallel split is excluded by the folio lock.  The anon_vma
> >   write lock was added to serialize split in commit 062f1af2170a
> >   ("mm: thp: acquire the anon_vma rwsem for write during split"), when
> >   split_huge_page() did not hold the folio lock throughout. commit
> >   e9b61f19858a ("thp: reintroduce split_huge_page()") later made the
> >   folio lock a caller requirement and added the folio_ref_freeze()
> >   scheme, so that has been covered ever since.
> >
> > - Unmapped path is already exercised by folio_split_unmapped(),
> >   and the swap cache split already runs well for a partially
> >   swapped-out mapped THP.
> >
> > - folio_get_anon_vma() and folio_lock_anon_vma_read() both bail out
>
> You mean folio_lock_anon_vma_read() called by others? Since there is no
> folio_lock_anon_vma_read() in folio split functions.

Oh, the original comment mentioned it, so I also looked into that.

>
> >   on !folio_mapped() before taking the anon_vma lock, so there is
> >   nothing to lock against.
> >
> > For mapped folios the anon_vma write lock is now released before
> > __folio_split() unlocks the after-split sub-folios, where previously it
> > was held across that loop, that window is harmless as the sub-folios
> > stay folio-locked and ref pinned.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/huge_memory.c | 51 ++++++++++++++++++++++++------------------------=
---
> >  1 file changed, 24 insertions(+), 27 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index c4910c0b6018..53614b875794 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -4005,16 +4005,31 @@ static int __folio_freeze_split_anon(struct fol=
io *folio,
> >       struct swap_cluster_info *ci =3D NULL;
> >       struct folio *new_folio, *next;
> >       int old_order =3D folio_order(folio);
> > +     struct anon_vma *anon_vma =3D NULL;
> >       enum ttu_flags ttu_flags =3D 0;
> >       struct lruvec *lruvec;
> > -     bool need_remap =3D false;
> >       int ret =3D 0;
> >
> > +     /*
> > +      * Unmap/remap needs the anon_vma. The caller does not necessaril=
y
> > +      * hold an mmap_lock that would prevent the anon_vma from
> > +      * disappearing, so we first take a reference and lock it.
> > +      *
> > +      * An unmapped folio needs none of this: folio_get_anon_vma() and
>
> I guess you mean an unmapped folio does not need a ref or a lock on
> anon_vma. It is better to be explicit about them.
>
> > +      * folio_lock_anon_vma_read() both bail out on !folio_mapped()
>
> Mentioning folio_lock_anon_vma_read() is confusing since folio split
> does not call it.

Right, I actually just copied the original comment, and I'm a little
bit confused about it too, I can try to improve it while I'm at it.

> > +      * before taking the lock, and folio_ref_freeze() below still
> > +      * rejects a folio that picked up a reference meanwhile. Note
> > +      * a swapped-out THP counts as unmapped here as swap PTEs do
> > +      * not contribute mapcount, and they are splittable.
> > +      */

So how about rewrite this comment chunk as follows:

      /*
       * Unmap/remap needs the anon_vma. The caller does not necessarily
       * hold an mmap_lock that would prevent the anon_vma from
       * disappearing, so we first take a reference on it and then lock
       * it for write, letting unmap_folio() walk the rmap with
       * TTU_RMAP_LOCKED.
       *
       * An unmapped folio needs neither the reference nor the lock:
       * no unmap walk happens for a folio without mappings, so there
       * is no anon_vma to pin and nobody to lock against, and the
       * folio_ref_freeze() below still rejects any reference picked
       * up meanwhile. Note that a fully swapped-out THP still in
       * the swap cache counts as unmapped here, as swap PTEs do not
       * contribute to the mapcount, it is splittable just fine.
       */

> >       if (folio_mapped(folio)) {
> > -             need_remap =3D true;
> > +             anon_vma =3D folio_get_anon_vma(folio);
> > +             if (!anon_vma)
> > +                     return -EBUSY;
> > +             anon_vma_lock_write(anon_vma);
> >               ret =3D unmap_folio(folio);
> >               if (ret)
> > -                     return ret;
> > +                     goto out_unlock;
> >       }
> >
> >       local_irq_disable();
>
> Otherwise, LGTM. With the comit message and comments addressed, feel
> free to add
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks for the review!

