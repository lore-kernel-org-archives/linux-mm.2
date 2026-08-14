Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BA11C5DF66
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 02:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59BBD6B02E4; Thu, 13 Aug 2026 22:32:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573E06B02E5; Thu, 13 Aug 2026 22:32:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B06E6B02E6; Thu, 13 Aug 2026 22:32:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 249916B02E4
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:32:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6BD516018E
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:32:06 +0000 (UTC)
X-FDA: 85098300252.28.5868652
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C1B77C0002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:32:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ga09yGZS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786674724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=etbRcxU/qvTHRE2R0RP8Ds1Evnri04IdXsj0mMe/6KA=;
	b=FE6Vjyn0XdEhaI0Vo6IZ46eTyMqcUumSi1W063IK927fsR7x5hTRe0lpOYfP/CbOGuxxmJ
	ZUsjhbBdYCyq7hT/QvdE6wbiKViirNJi6bLFh2G8gMM/V71e+7A0wFXoZHZijmL+kZm3c1
	cxK4JUDXfEkQtySpW4CjgWFt7jhz2oo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ga09yGZS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786674724;
	b=N6lryZAFVscy022v6o4fA3vmr8rC4e23GNRSvOG6MalneJiPC67esCOGV5mlf7fmFfXq9g
	IGfQy5z6fskDlLaEH683sby4DJz3zqsppP4gv/kC3TeUebuX3KW3f4oyyLRsD1MSSjzr1M
	jmkBdMBjxyVJdJrgPkEJM/AQSXyJ/QE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E168600E2
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BE91F0155A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786674723;
	bh=etbRcxU/qvTHRE2R0RP8Ds1Evnri04IdXsj0mMe/6KA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ga09yGZSf1u73IHbvuK8mHtvgQ2Duw/+bhTpPE6T4CUoJ6r6xZQiTjJ6RJdk22q8R
	 eZRJlRhIPflQrbAn30TYu119RGh3AB2LpGyNxH/OETx/HcmouasvANG0n5YNPl69ZH
	 AmVGFwQA3LC+oD1GdOjSjpENI6SR5Fdxw237/5YTtCyBXpqOyFcyLJAzyuQJBbqtQF
	 BHfJzMjpBof5Oz1c0kWmY+0mlkCV/xUqDgr14742MMd+HVVq5orox0Abf0+5QgYRxU
	 DPJ5b5q8mMUwc8nTeTP50N3r9ke0lr9GouP7olhOPMdZA0aRHCq2VscTV55J1JmY7D
	 w4+fus/AAY7Wg==
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-52d37b65926so3074501cf.2
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:32:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrFA9KSlAmKq1RWBejA27s6nKYLwXX8EquYoIKbO/G8sTTcyxs3QNP69aRQamoThRbMbeHXStR7YA==@kvack.org
X-Gm-Message-State: AOJu0YyxgO+BDffrRfnfakQiuW1lwmCs9Lu7C6FI6ulcWaDfHb/YR4X+
	7ozUJ+eQvXhvluaXFW0DngfBUx6Du9U7LzGSYvpnbUoTvJz4Vj660Km+O5nL3l9mTfuAiU4aAiW
	qVGsBsLPZbi812a7U0Ht9WqiGHsY6ZFE=
X-Received: by 2002:a05:622a:308:b0:519:e020:6087 with SMTP id
 d75a77b69052e-52d853d8638mr29594561cf.11.1786674722390; Thu, 13 Aug 2026
 19:32:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260813110230.2124785-1-ridong.chen@linux.dev>
 <CAGsJ_4xBQ1r7_rzmu7fBvuy6c3eZCW0Xq=puXtoiGf=JeVnjvA@mail.gmail.com>
 <CAGsJ_4wEpmxZyDFj5eXwEDY_Rbveue552OqqiyZ2MOJw2TTrrA@mail.gmail.com> <c10dd51b-b439-4415-acfb-83a4024346cb@linux.dev>
In-Reply-To: <c10dd51b-b439-4415-acfb-83a4024346cb@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 14 Aug 2026 10:31:51 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wEojLabqJZRNRH5CVoEoXPRvcw5hbrGSQ6=8ShrCifGw@mail.gmail.com>
X-Gm-Features: AUfX_mxNXmlaK_9ljPaBoFzpERXmiDOKUKgXodVtH9bFCFdaPDvVAHGQw13bD2M
Message-ID: <CAGsJ_4wEojLabqJZRNRH5CVoEoXPRvcw5hbrGSQ6=8ShrCifGw@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/mglru: preserve inactive placement when enabling MGLRU
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Brian Geffon <bgeffon@google.com>, 
	"Jan Alexander Steffens (heftig)" <heftig@archlinux.org>, Steven Barrett <steven@liquorix.net>, Yu Zhao <yuzhao@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: u77ypng4r4g9tm3ruic539xbxasiprte
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C1B77C0002
X-HE-Tag: 1786674724-643674
X-HE-Meta: U2FsdGVkX19d+T+bEVn8WxFtj9azKpWN3CEdIm6a5rQOZpUiDrCMMySuboF0BbKkv04nfwoEHYyQ5jYp+J6hN81rGm/ms/fC4RW6MiDl18nG62t5SYz0AwSqPzvN0h5aOnFILFQO20a6awNcmbKRHDe8eZikWg7tqX29s8O/KeseWAmivLuj8dO/+ZRYu+rrklnsfS9DvQJKGH8kUHEiY7a4TOzPUUicHLL75EGMbvb23Cqjnp1waJBfBgd9ghTPXQaZlkLYiPhnC1K9XLhDzXsDG3Wbw8tJG3ABvqxTECWvgXKULGkXIqRlMPZfjhoTG7+NuuMgiAvD2GQUGMo36MQ0uSv6rzHSDLJoHVSnfTC7Jz7ALjqtvvs+crPYj2yHloETACkgn+l+rQrJgcxQ4F0DZYbU1Jv+zJAn+wX0NWH8APBWiy46Gp3DjT1SER9KmFC3pqtmWMB4Ioe63epKTTNBHM/C1xp1QqVazdv0bfw6bkrhOTS27sQ7gQAr5Nn4WeSNjodk0BIYKyuztbB57Tz7tyiPpGW6SK9+r4U3/pZ+LKdq3czimtvyawAhgf3TBp4e3KyAA2eUpCJpDG3xcFsjbitLl+wZbm7Js8WwhsetfH84MBs5LcbcKxrMqWEAnGIoOI28OKxu+pGMvJ6nt/JyVjaUjwdodlwIkaenK50eug4SrD6jZML7deVTDCiKWuQChpQsigAaMBWH8FcYxBccbZ0ltEdnpsc2YHvAFrm4qedGmF5OKDfSFp5UJx8ew7S5lg3O3xkN++0uoyrXdPxj7ru7djPYzP9MxefDv+5C1/SER9Xx13iEtRkYe2qHjthUwSCt70H7e3NvSdl7eVC0hXvLvM4zZS6Ls+2XqfodR3gdtNpiDKudP8sDdKNkmFbezkc8ygmDZ4zWE9qLm9NVX6qXviJSGDy4fRZoMTgFYAUplp6QDOZK0lB/fViqXLeI9UsV1CTkN83qtm8
 FUVv6tkN
 H7xnSbUuqfevjQJxWk7hrY5Wla3uCLk4nEFvdCIA9J17mJqCuKnGvBagD8uDHNVBmy4SA5VDM6VaRJ4x6R3jbBBrzoyBwqf9lgnMh1Ks1yRoZfT5PbRks/9tpQHWOz6uFaDYvdxfxTakOTxjhbjoUxMAHBuU8QcnMP43Ii7Kv0zOQBiVHzIJznzMm+f08QoNo5NDwI2zdmzU6+2wKBJ6LeXXrd2xHNLMmlPBFMfat9MrmTpNk4e6iWkS7EZGHgcT4GNA2gPsmpa0EFMvAkjzf8YYrXkUdIDlgqoiyGgohjU95iw4/ZiyIlCQmikQvJAcgrEKPgt6IfimALxc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 10:22=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev=
> wrote:
>
>
>
> On 8/13/2026 7:37 PM, Barry Song wrote:
> > On Thu, Aug 13, 2026 at 7:24=E2=80=AFPM Barry Song <baohua@kernel.org> =
wrote:
> >>
> >> On Thu, Aug 13, 2026 at 7:02=E2=80=AFPM Ridong Chen <ridong.chen@linux=
.dev> wrote:
> >>>
> >>> From: Ridong Chen <chenridong@xiaomi.com>
> >>>
> >>> When the LRU is switched to MGLRU (echo y > /sys/kernel/mm/lru_gen/
> >>> enabled), fill_evictable() re-inserts every folio via
> >>> lru_gen_add_folio(..., false).  With reclaiming hardcoded to false, a=
n
> >>> inactive anonymous folio (no PG_active, not in the swapcache) takes t=
he
> >>> "gen =3D MIN_NR_GENS" branch in lru_gen_folio_seq() and is seeded at
> >>> seq =3D max_seq - 1, which lru_gen_is_active() treats as active.  Its
> >>> inactive placement is lost and NR_INACTIVE_ANON is folded into
> >>> NR_ACTIVE_ANON.
> >>>
> >>> Pass reclaiming=3D!active so a folio from an inactive list is seeded =
into
> >>> an older generation.  Folios from the active list carry PG_active and
> >>> hit the first branch either way, so they are unchanged.
> >>>
> >>> Tested on x86_64, next-20260812, 2G VM + 1G swap, ~1.5G anon pushed o=
nto
> >>> the inactive list before enabling MGLRU:
> >>>
> >>>                           Active(anon)  Inactive(anon)
> >>>    before switch (legacy)        2952         1548792   kB
> >>>    after `echo y`, unpatched  1552052               0   kB
> >>>    after `echo y`, patched      15144         1536636   kB
> >>>
> >>> Inactive file folios stay inactive either way (NR_INACTIVE_FILE is
> >>> preserved).
> >>>
> >>> Fixes: 354ed5974429 ("mm: multi-gen LRU: kill switch")
> >>> Assisted-by: Claude:claude-opus-4-8
> >>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> >>> ---
> >>>   mm/vmscan.c | 7 ++++++-
> >>>   1 file changed, 6 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >>> index 94fc4f25e99f..2befc8d7dd3f 100644
> >>> --- a/mm/vmscan.c
> >>> +++ b/mm/vmscan.c
> >>> @@ -5319,7 +5319,12 @@ static bool fill_evictable(struct lruvec *lruv=
ec)
> >>>                          VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) !=
=3D -1, folio);
> >>>
> >>>                          lruvec_del_folio(lruvec, folio);
> >>> -                       success =3D lru_gen_add_folio(lruvec, folio, =
false);
> >>> +                       /*
> >>> +                        * Keep a folio from the inactive list inacti=
ve:
> >>> +                        * pass reclaiming=3D!active so it is not see=
ded as
> >>> +                        * active.  See lru_gen_folio_seq().
> >>> +                        */
> >>> +                       success =3D lru_gen_add_folio(lruvec, folio, =
!active);
> >>
>
> Hi Barry, Thank you for your reply.
>
> >> This is a very interesting use of the reclaim argument, as it is not
> >> intended to serve this MGLRU switch purpose. It is really only meant
> >> for `folio_rotate_reclaimable()`.
> >>
>
> Yeah, I realize tying the reclaim argument to the MGLRU switch is a bit o=
f a
> hack, since it was really only designed for folio_rotate_reclaimable(). T=
hat
> said, I'm not blind to it, I just posted an RFC patch to get the discussi=
on
> rolling and see what people think.

I think it=E2=80=99s fine. Just update the comment there and mention that i=
t
can serve another purpose as well.

[...]
> > Then the oldest generation will maintain the same folio order as the
> > inactive list.
> >
> Thanks for the suggestion. Traversing head to tail does fix the inversion=
, but
> we need to distinguish active from inactive during iteration, because the=
y are
> inserted differently: list_add_tail() when reclaiming, and list_add() oth=
erwise.
> That said, the reclaim argument usage still feels off to me=E2=80=94I'd l=
ike to hear if
> others have a better idea before we proceed with further changes.

We can change reclaim to a tristate integer, or simply make the
following change and add a comment explaining why?

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9e52f49114e7..5e624d0316bc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5403,7 +5403,8 @@ static bool fill_evictable(struct lruvec *lruvec)

                while (!list_empty(head)) {
                        bool success;
-                       struct folio *folio =3D lru_to_folio(head);
+                       struct folio *folio =3D active ? lru_to_folio(head)=
 :
+                               list_entry((head)->next, struct folio, lru)=
;

Or you could even move the entire inactive list to the oldest gen
instead of moving the folios one by one. Then you can avoid dealing
with the reclaim argument entirely.

Best Regards
Barry

