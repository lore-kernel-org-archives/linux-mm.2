Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35D4FC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52EE56B00CF; Wed,  2 Sep 2026 05:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506876B00D1; Wed,  2 Sep 2026 05:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C3F6B00D2; Wed,  2 Sep 2026 05:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17A8B6B00CF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:20:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7ACDA1C00A5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:20:53 +0000 (UTC)
X-FDA: 85168277586.02.52A2803
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9184E40005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:20:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lwV5QY27;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788340851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GXUAHFg7dowH6ZuhPVHAPwiDJHgaYFq0oMVg2SQ370=;
	b=yCfrr74oY8pVIGrpDVA72EQNcrl8CdodO5Yp3DZ2kHuuQxEcY3SmOVwiza09jRkrYn6/ou
	ks+hph6G4vjc6mfHQ05TD88wDqjNJKM5rhvmtyX71FnkWWyzgza6c9djpytdNgOG/sOyxT
	KYAyUVTzCIcjmKpZAVIJnKp3u7lV6xs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788340851;
	b=6frmjp5LGS85eeYFG4M9FIW0pTzFDInXQs+cgtCqOYr3+3OTQGmOH9gHhOm2rTU8ExoDFz
	giGMlpHcwxlbxH00qrNQX9dElJ+0THW2POHteZTYAORAVTV+L/rORnpmutzXSgPeDD8FPL
	2qp2KtQseYmopbxe5N/4KCv4yedOSe0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lwV5QY27;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF62E600D0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C5B1F00A3F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788340850;
	bh=0GXUAHFg7dowH6ZuhPVHAPwiDJHgaYFq0oMVg2SQ370=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lwV5QY27UhR/tSkb5eGWMr0ToHrmUSSxFjNOPCr25W2O6D7VUYDsjvy5ZctApjFzn
	 Cl9BizU9aN/fsS3sDgrHut+ZR7nuQX15LQc+vmdd51Vn+Mg1ne+P0VuhMI4fUKuQN3
	 O13A6z5zsKgOVNrhlYAHPND3C0MOdwPkXic/fAQUPHEo74I5T0/mryCFnNyblrr2GI
	 h7beybzYBqXpBNHcvBlZNTaUCxXxNAFEjTV4pct4OMU2DYdrSNrClRzusY0eiFPw6Z
	 VCU5lZH79KFZBYYi0IyJlFVgOhBbsK0cycjOO0di2txzLnFP5jXrkgkDCWAF+7Q58z
	 by94WptVImw7Q==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-9390c3ade1dso52832685a.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 02:20:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro3XdRx88ATyL2fa+5//rJq5hI8UtE9RSgq/TIqXOWiw1UG86Jzhq6Pi/v7hQXqaEEYp7UvvgDarQ==@kvack.org
X-Gm-Message-State: AFuF++kZR29FXpePITwLzXJzLzQzWL+tgLTAGtQWtFAVGFaNbVhAK9Vj
	AllpcdDv6cMcWEh+AcZJ1aH03UC5lwAWllJIFCoGVTv5v+miSY8rZjdDW1oD5Oun3GDhTBqEAlz
	ITJiEj1RthV1ZO6662KBrhuQuihX1aAc=
X-Received: by 2002:a05:620a:6a87:b0:92e:6637:da3 with SMTP id
 af79cd13be357-93960fd096cmr375837085a.38.1788340849834; Wed, 02 Sep 2026
 02:20:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260829074204.45304-1-baohua@kernel.org> <20260829074204.45304-3-baohua@kernel.org>
 <apfZQE1X6zGAsBb_@fedora>
In-Reply-To: <apfZQE1X6zGAsBb_@fedora>
From: Barry Song <baohua@kernel.org>
Date: Wed, 2 Sep 2026 17:20:38 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z=A3EGajzL8F5H+0fwyzh3qqMNACEzo20J83m+T8bbZw@mail.gmail.com>
X-Gm-Features: AcwNN1Uu2xlu8wqm8VQe819Z992ew7Xryu4VEWNd4-KDRJbEJpXorv82ZqYnFI4
Message-ID: <CAGsJ_4z=A3EGajzL8F5H+0fwyzh3qqMNACEzo20J83m+T8bbZw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/mglru: make retry logic explicit in isolate_folios()
To: Baoquan He <baoquan.he@linux.dev>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com, david@kernel.org, 
	hannes@cmpxchg.org, kasong@tencent.com, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: oa41bnjndfjgczp5cnmp1duu7cj9hbem
X-Rspamd-Queue-Id: 9184E40005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788340851-631333
X-HE-Meta: U2FsdGVkX18iwRmBOoMekGKe5byv61tFoRGi4RFKSu7NuOfSj1u+trikGGIi/FC2QHLQJIb459rWzyLAxwRCI1xD1162Uvokp6edoigxr3HVimquo/3AIObtAA2B2XKndhTCbHqCAqvJ5usOoFuVL/fHTWy5ySJ2yoUVKLKhlYTDku+yXn8MUa0XOCdFCSHGHMUwXkeqctroEa8wUV4iPwUaZdEwYiZQnsTh/haSwYDpB2oAqzEDOz1RUMH6Q9yZRtzdJXAOqXu1qlr90dQRyXQ44QqX0bHLyPZuUBIqtHY1uOmukDfbmAN65hl2s1XjgA7qViGrUOVovRbOH1oGjR4OiMxynZBdgFPw3lJwePlsLxQS8h3UIqcILduf6gz7vSBk54s/yKxJcot5sC+S8qyTc4bCCXxCj//nS/bx7U3qaT4GXbJY+idJGnvTxcvqMMRmOvveYSakU9OMLqtl9RSgyED872JjEf5ffAgr7NlqPNsLxCL6NF7is5Ssm8vlsWjP8Bk2w8d7D3h28HoDmvrEq0a5kUymtzoqQ2c22Mph/z4+m1Rxg68BFR9iCBEW3RIoQv68bWI6PFRrOQCHnSXUKg4VHWwW948kFQaDrGCpHVE2ALVJIwbSy0nvHwl5y6iv0m59h0NN9zdMYX8+5J83VjMJkP3tgqxoOZi8KyrHO+54PYRAFipFGgTRdnB0Csbw/Avf205RSwUumsKt5IBmxKhIb3mjWQI7j31vXUNI/qLzajZOxRIo/cYX07Oe+OQXqxCCOjLUx8bXF3+TcJLvQZLVNpx07nu78CEbdmMSATJk8x7+FKlssqtpuUTSwod2quomaFHBgLNKnIrMSnir6fNc6sS8zQa8M+qWujxDCgbCSQl0Wewe8HfV2wSovdPdvro8PNutGl/2jAR/QJsyi1GwkHrS5fYllv9XVKjpcjzdEq+Wcmk089ZPzOIMP1pygVW0YMwMyLiDYZZ
 iNtkMINp
 Uktk+p8PHsqIbi3Q1eOK0QJyFX2qRQUZMJmZYDzejtzHVQgzzRtNaAVFaUNvzD9pFzPiQ+NWB4cx01g83xLqFBsrqYvL/rtBxVd0+B9sqFiOD4PO18rsNMEybaTt44+RSPNKaWZnbTJqVLu398KnHcLfWwMtTlEy3j097DWDz3lB6fWdjb83w7sqBRmr4dWFAJk5JLVKESwrVr1ls42yLOAbsi4bIb9TOuHEszUy/uw651XQF3d7aj9T3k1LgjVLK76zYCN2qBFuT634qtL7ZOyjEqQwGbilgMFNnCoRuXBkWK/QMSzI6uo6CZhB7Ij4TGw0Vuo695pmLe02StGttjSUpgLyHGaNOb1AkmR4p2xPUmh7c403VGUWw1SV3hIe29RKYA4WczZ+ghoT1dza7WSl3k/puOYBKs/AcNasKgdier1ogBp6uRnzNrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 2, 2026 at 4:07=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> wr=
ote:
>
> Hi Barry,
>
> On 08/29/26 at 03:42pm, Barry Song (Xiaomi) wrote:
> > The existing mainline code retries the same type once in a rather
> > subtle way. `for_each_evictable_type()` may provide one more iteration,
> > allowing the same type to be retried if we scanned some folios but
> > failed to isolate any due to protections, promotions, or races. This
> > patch makes the retry behavior explicit.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/vmscan.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 35a233623368..718f59ffc688 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4852,6 +4852,7 @@ static int isolate_folios(unsigned long nr_to_sca=
n, struct lruvec *lruvec,
> >       bool type_fallback_allowed =3D !is_single_type_reclaim(swappiness=
);
> >       int type =3D get_type_to_scan(lruvec, swappiness);
> >       int total_scanned =3D 0, scanned, tier;
> > +     bool tried =3D false;
> >
> >  retry:
> >       tier =3D get_tier_idx(lruvec, type);
> > @@ -4871,9 +4872,18 @@ static int isolate_folios(unsigned long nr_to_sc=
an, struct lruvec *lruvec,
> >        */
> >       if (!scanned && type_fallback_allowed) {
> >               type =3D !type;
> > +             tried =3D true;
> >               type_fallback_allowed =3D false;
> >               goto retry;
> >       }
> > +     /*
> > +      * We scanned some folios but failed to isolate any due to promot=
ions,
> > +      * protections, or races. Retry once to avoid a larger loop.
> > +      */
> > +     if (scanned && !tried) {
> > +             tried =3D true;
> > +             goto retry;
>
> Seems patch 1 and 2 makes not minor difference than mainline kernel on
> behaviour.
>
> 1, if swappiness is 0 because no swap, it will run two times if
> (scanned !=3D 0). This is not corner case, but usually seen on some
> systems w/o swap device. The 2nd no gain run could decrease efficiency.
>
> static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
> {
>         ...
>
>         if (!sc->may_swap)
>                 return 0;
>         ...
> }

Yep. For swappiness 0 and 201, this patch slightly changes the
behavior, as I mentioned in the cover letter:
"
 There is a slight functional change for 0 and 201: with the existing
 code, there is no chance to retry for these values because
 `for_each_evictable_type()` only iterates once. After this patch, 0 and
 201 have behavior that is more consistent with the 1-200 range.
"
I did this intentionally, as it makes the behavior more consistent with
the 1-200 range, where we retry the same type once to avoid having a
larger outer loop.

>
> 2, for swappiness (0, 200), the behavious is minor changed.

I guess you actually mean swappiness (1, 200)?

>
> Mark one scan_folios() result as one of:
>       iso     *isolated > 0
>       empty   scanned =3D=3D 0 && !*isolated
>       busy    scanned > 0  && !*isolated
>
> mainline:  T(busy) -> T(empty)         -> return   (2 scans, no fallback)
> v2:        T(busy) -> T(empty) -> !T(...)        (a 3rd scan_folios())
>
> Maybe we can go like below:

Yes, you're right. For swappiness (1, 200), I didn't realize there was
this slight change.

>
> static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec=
,
>                           struct scan_control *sc, int swappiness,
>                           struct list_head *list, int *isolated,
>                           int *isolate_type, int *isolate_scanned)
>         ...
>
>       for (attempt =3D 0; attempt < 2; attempt++) {
>               int scanned =3D scan_folios(nr_to_scan, lruvec, sc, type,
>                                         get_tier_idx(lruvec, type), list,=
 isolated);
>
>               total_scanned +=3D scanned;
>               if (*isolated) {
>                       *isolate_type =3D type;
>                       *isolate_scanned =3D scanned;
>                       return total_scanned;
>               }
>               if (attempt)                /* already retried / fell back =
once */
>                       break;

This `if (attempt) break` makes the loop look rather strange,
especially for a loop with a maximum of 2 iterations, where we break
when `attempt` reaches 1 :-)

What about just changing one line?

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bf2786c7247d..ba7adf36e69f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4939,7 +4939,7 @@ static int isolate_folios(unsigned long
nr_to_scan, struct lruvec *lruvec,
         * We are running out of the current reclaim type. Fall back to
         * the other type if allowed.
         */
-       if (!scanned && type_fallback_allowed) {
+       if (!scanned && !tried && type_fallback_allowed) {
                type =3D !type;
                tried =3D true;
                type_fallback_allowed =3D false;

>               if (scanned)
>                       continue;           /* retry the same type once */
>               if (single_type)
>                       break;              /* no fallback for 0 / anon-onl=
y */
>               type =3D !type;               /* empty: fall back to the ot=
her type */
>       }
>
>       return total_scanned;
> }
>
> This preserves mainline for 1..200 exactly, keeps the intended 0/201

I guess you mean removing the same-type retry for swappiness 0/201,
rather than keeping it?

Thanks
Barry

