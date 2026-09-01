Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 742BAC624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781EE6B0155; Tue,  1 Sep 2026 07:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732176B0156; Tue,  1 Sep 2026 07:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F126B0157; Tue,  1 Sep 2026 07:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 434FE6B0155
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:34:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CAC0D4038F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:34:11 +0000 (UTC)
X-FDA: 85164984702.19.BC2B63D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 04978180003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:34:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f0hOIDPS;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788262450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xF9QmkpYR3qgfY873N8V29mRSsytqFszdnNsBX/pLXk=;
	b=RczQdhVHKOXvhmVld4MFQ1b8f0roHK5QZx3fxoB9GOr3aqj25/EjrJPhcnI3M7OODn1QaW
	FIIWDWeenuZSGpkyyFLp7kXjLjz9QqUlCkswcAfFcHc/ktrjZ0LiYHyvJcYYAAj6+vZWk1
	QrJv8VhPEq/inuDAkh6UMllLkD42334=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788262450;
	b=ncdlKyO3iWY2tTODrJ1m3Q/jdxokF8T9JUQtuwqyP8rPrQ17pvTwLq/pCJKr4/p+Ugf1qT
	/k5HbzqQxAIMSt6hCbAvYwCgjVuPCPmM1Pf4vcvVG6dlrgIotCCJuevVUzay1MFTDnW/UZ
	gnJo0n1FJwQBGTzxDbopLftvCVdXhLQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f0hOIDPS;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 36F6F602C3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13541F01558
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788262448;
	bh=xF9QmkpYR3qgfY873N8V29mRSsytqFszdnNsBX/pLXk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=f0hOIDPS0Q9O0NDOUwT1+3cAmNujvY626UF7Fj9LoHsQekd/bUeEofdESU+l131oX
	 1pD02uxaA9N44WF7W36MuDX9AWKSVrQiZ3f5rNYBFq2/GPvtaJf/7hTDa4vTpCdLk/
	 xFyi2lmQEIh8JufGCAkIZ5DMQOxUJV9TETWFBpWYs6B9+L+sa3hUwB1qvvStQ5Gu0V
	 7SWl9rdGmbgLyjLHiWssfIGosKEL8/Cr8ZLIyNhL4Qc72Xb1dsf1aWVwC1RpbqjYwo
	 jZDwlxaa89Qb9AlWq1Bu3P5zdXhfVnruK4+OUUi9XecQZqa/zCivsfjP4tq90UhDSV
	 rp/YHKjjJAneg==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-936c02e58dfso78108685a.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 04:34:08 -0700 (PDT)
X-Gm-Message-State: AFuF++klSVHHm95lgoPdTgJ0lOS6iLbdOpjIGztaT6O7nkGVwDPkUaVF
	6zIfPX5VkTQe1UWO8m3WnSI/4y1B2t8GVfoi7FLuRL3dP0g1sjwP0Mk70vV2w/n4UpLWcZB/tz9
	zVptzpRERx3VOQUqtotbxwVY0BoldVKE=
X-Received: by 2002:a05:620a:448a:b0:936:cae5:8b38 with SMTP id
 af79cd13be357-939137fb875mr3424952185a.10.1788262447895; Tue, 01 Sep 2026
 04:34:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
 <20260831-mglru-flags-cleanup-v4-6-2d15dde0d7ee@tencent.com>
 <CAGsJ_4y7MrUeHn4NvtpyyZ3EY-6dTUD4vhitw6Sy6tfRq6Tf9A@mail.gmail.com> <CAMgjq7CiewVYOsBoXMjg+tgbUMsXgYoTe1gJiEoADQdusffeng@mail.gmail.com>
In-Reply-To: <CAMgjq7CiewVYOsBoXMjg+tgbUMsXgYoTe1gJiEoADQdusffeng@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 1 Sep 2026 19:33:55 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zaKfAzggCM=TN4ONgymcPyKSkW7AWqu+TnqD530X2OGQ@mail.gmail.com>
X-Gm-Features: AcwNN1XvdXl1z36F6kMBWRMqp5qE1QnodBYOqZkwoOs2kZlU3JiJ64EkO1iAKGA
Message-ID: <CAGsJ_4zaKfAzggCM=TN4ONgymcPyKSkW7AWqu+TnqD530X2OGQ@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] mm/mglru: fix potential generation folio number leak
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 04978180003
X-Stat-Signature: gm7iombzyts1osen9g5rst6yxm87xru4
X-HE-Tag: 1788262449-623987
X-HE-Meta: U2FsdGVkX1/wzt5kro4DSz/6WeUmH7pYN6WnPLhu02wP4X2bDn3nv0uur6zr4PGLo3yZ8O0aWXN87ZaIPx6ZuP8S6IM2Z7LDAbSD+rM4AWIPivA0yFZt+R1r+zrvhCjoEru60adqJgI+Zq97AglBIG1w9vY+Fa8yShk6SBFrNQJcF3OVe2+dUSEzJDwppXzMkIRkuZtgIhfI7NqMRhX/F6aplDi4E8A9OB1zFOpmsMLEqigTxOPKIos4AZAIjn0KyOS6U5rzcpUHuTNGzbbzvqUhgcBjNIJHwV6xWpDHT5GbHQszwyUtyuw2pfdxE+XtsNg2ztIA43eBNemX36BfV1Lb5F08hB2KIZi8YUGEOr4oXkIY0nD7rzClfO7xGHRhG3gPu+92yxmEfs/DZm0PMKCPO48O4WITdTAH516eib8FhOzGSQBs4uFvcrtyyUwkj0LMo4eeTChXkanqu8FKDwmmmotEMxIaS9nSP7YonbqCX0BwzECqkfHHP0faK7aQvv2uQrIWXayfCwDjrYBF0oeLjovObaiqGsIgN3T04JRt1ZbsBX5bEm3ygyVDKKMabEzosRQI5nN49GvzFF/cbU5pIQ4lvKrINcKS0NTSig6YauL2cE4ij3F8gjh9bOZx1d1sFEYOGxYR+8CFk8rqfsqzkmutCqEa0bf/rJF/DIQZjIkZ7vB3SpELlG0fd7Qrxba06ACHRGw7+Ms4Us+RnsbeMtaxwFG+UFPPXdcYUqXTIuxlzOgaZrp79szZsSfmXDXgd154ta7+Lly/GsjIuYxjCB1Z1HK6CcHmHYDPJrxatHZTDpu1ztWQyG0I2AKdDfSFNCE3nGO6r53yOQV17VSgV52FRvq9XePGHYbYnVkmIxYOsahBqN/KoFFm+lk/3KHwXzSt1F2HWNy89I8jp7nJxoFy25XBVLOXFV48QI+bMLPJcPIA5wYmAGs8eu8lbIQVHjrNjHtx7cLxUN9
 p0WvfI6m
 Je21+GGUwBavqBw5S3pOLolRE+E6IoV+aIBEHeXmMA9UoPNNLqWLQxb3nTlFPQfJj1OK+Iu94UWulZnftu70j3yowzDTf0AJ8AgMydmYX2HrpMjcrqDVd0dRXg+zCU3crREYnVFeqFMJUxeyv5NL8G4CTB4qPaN5J+ByRQjSIfVjkrkG/ovzqFz73as5Y1NXBuqKySGZ3m5WDkoYi/Lk3k4LYQtAoKcoB/AcstETlCuQDrscWU51WG+3EbIJlH4PfOFnswxtFzoDZOJKbyKJzDyNS+mYwr9bUrYbEyh5YE60B11QEZuBi/BnSBeaUNjQevb8JuuwXycmoJJuGkw3uI4twIwUrmgy9BWe+9SDbriElAJtQ1rBYRSlhNFlECx1Xw7qL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 7:14=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
[...]
> > >  static inline int folio_is_file_lru(const struct folio *folio)
> > >  {
> > > -       return !folio_test_swapbacked(folio);
> > > +       return folio_flags_is_file_lru(const_folio_flags(folio, 0));
> > >  }
> >
> > I guess we don't need to change this function? It seems more natural to
> > me to keep using `!folio_test_swapbacked(folio)` here.
> >
> > In `folio_update_gen()`, you already use
> > `*is_file =3D folio_flags_is_file_lru(&old_flags)` to get the type from
> > `old_flags`. I guess that's all we need?
>
> Yeah, that's all we need, I was thinking that using
> folio_flags_is_file_lru here can avoid any further change to
> PG_swapbacked causing inconsistency of folio_is_file_lru and
> folio_flags_is_file_lru, seems a bit easier to maintain.

Not quite sure. folio_is_file_lru() is based on the folio, so I guess we co=
uld
just check against the folio with folio_test_swapbacked(folio)?

Anyway, I=E2=80=99m not particularly strong on this. Either way is fine wit=
h me.

>
> >
> > >
> > >  static __always_inline void __update_lru_size(struct lruvec *lruvec,
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 724b6e034e69..87e667c410ed 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -3269,7 +3269,8 @@ static bool positive_ctrl_err(struct ctrl_pos *=
sp, struct ctrl_pos *pv)
> > >   *******************************************************************=
***********/
> > >
> > >  /* promote pages accessed through page tables */
> > > -static int folio_update_gen(struct folio *folio, int new_gen, const =
vma_flags_t *vma_flags)
> > > +static int folio_update_gen(struct folio *folio, int new_gen, int *i=
s_file,
> >
> > Rather than is_file, I feel was_file would be more accurate here,
> > since it doesn't represent what the folio is now.
>
> I'm fine either way, is_file seems more natual to me. Or maybe simply
> rename it as "type"? Just the below:
>
> > > @@ -3532,9 +3533,9 @@ static void walk_update_folio(struct lru_gen_mm=
_walk *walk, struct vm_area_struc
> > >                 folio_mark_dirty(folio);
> > >
> > >         if (walk) {
> > > -               old_gen =3D folio_update_gen(folio, new_gen, &vma->fl=
ags);
> > > +               old_gen =3D folio_update_gen(folio, new_gen, &file, &=
vma->flags);
> > >                 if (old_gen >=3D 0 && old_gen !=3D new_gen)
> > > -                       update_batch_size(walk, folio, old_gen, new_g=
en);
> > > +                       update_batch_size(walk, folio, old_gen, new_g=
en, file);
> >
> > This is one more place where we rely on `LRU_GEN_ANON =3D 0` and
> > `LRU_GEN_FILE =3D 1`.
> >
> > We do this kind of thing quite often in MGLRU, such as `type =3D !type`=
.
> > It relies on the numeric values of the type constants, which is sort of
> > a semantic abuse, but it's hard to find a shorter way to express it.
>
> We also ahve WORKINGSET_ANON, WORKINGSET_FILE, ANON_AND_FILE. I can
> rename the newly added parameter to "type" here if that looks better.

Yes. Using the type seems clearer and easier to understand, and
it=E2=80=99s also consistent across multiple functions.

Best Regards
Barry

