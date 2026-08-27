Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C40BC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 04:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C4646B0092; Thu, 27 Aug 2026 00:31:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39BE66B0095; Thu, 27 Aug 2026 00:31:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B19F6B0096; Thu, 27 Aug 2026 00:31:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 018406B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:31:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 778A940300
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:31:08 +0000 (UTC)
X-FDA: 85145774616.25.ADF373E
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8DBDD1C0003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:31:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jOowQz7/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787805066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNF9twBVaAp7G+9eN2s4Q+uWE5O0f0kqDqf5iv1isXY=;
	b=q/X9DlATUF7EbTeQ2JUY35OfeROySpNQuO4UdV/k67JgGl+tPO8MPO5lrX7M3u6RUZywth
	kNzqq4pjJ0ELe/scAAZF6cpkDAf8jqD/ePGHT0EPyfu/LkiM1xFhEzGHimtWGitjwrS9T8
	pjOjiOSrXFiFFbUEOVaaL5tNDrOiFAs=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jOowQz7/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787805066;
	b=5FROLMdBIsI7Ac2Tk8CE9p0MrR47uEjj2SP63d16N+SLH4xV62e7I2t8ayw7YM3PdfyrLX
	kMTuXqVmGKn3jHe2JjgotgAPn5OnGdKIf6dh7zpe0/Mh/m0Ejdu44i7CGewaQWktb87zit
	mwvK2HMsebHKEh4bU9eiuQCQtmlso/o=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a3fda88184so2795164a12.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:31:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787805065; cv=none;
        d=google.com; s=arc-20260327;
        b=qaGzG7qdvuRMmEl1+zjuZCurXETv1Bm5dPGCgWI6JCdxgLsLDd5YsQWeyfqYTjns1h
         oNUal26PTn+a5MJYme9kL+1gYeWSfbXlgcmlr9w5kaqlkHGH85tQRpxYnacpK871PIlR
         jZDZP3kL9GqXu2CG6pZ39+C3eoxyyuP6fMyDeygrh7p93O4HQVZ9VP8Rjbo2NT17ZtZ+
         t1FJaEl2WSrkrzct9fR57NIFz4eMe24th7tUN0zVBSZVzwQD/xt5w73wYYuaDEInZUmq
         lEHJUBbpqalXdpgDaiE8z2BoBSuDSP65e4Ooz90Zu60jAbYsmNZRXw8cs5Zn9TTKFaxm
         NCKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GNF9twBVaAp7G+9eN2s4Q+uWE5O0f0kqDqf5iv1isXY=;
        fh=aUwqqfMMSxW8Ig6UiOFJqL6my3h0iUHfPeujMV1s13w=;
        b=aMs34ICZa2PlMcePY5dto2nOtsm/0aoZ7u8h970JuYP5IhKREPt8DfCoH8AhzqGHax
         ezHtEAY43J5f1Qm+wb6HEnQyf1m8lk8ZM6TRshu+da9mW6S7zZoWIaeQbbOCH3iqR0mr
         VqFZ19zttxKFxNE9McUwQfHfL9OLZriYWM1ji8CFq7igFVrpDPUx+d/L/2ROyejK4ev/
         9jTyw9ufs87iIcLj7jWGHXC7HODT+LdzNyoLpWMji0cCCzFvfPlDiwsvZlvNTqW3f9D/
         6EIKhur2/YoMxKOlys6Lr4KvZLLuTKrIHe8k4TXHnGg6FrIODQxJnELWbMh0SN32bizg
         s4BA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787805065; x=1788409865; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GNF9twBVaAp7G+9eN2s4Q+uWE5O0f0kqDqf5iv1isXY=;
        b=jOowQz7/0nbUmTAKb6BfVRWrH6g7K/itDFPj7yHDxez0ClDVJ7kCQIQKGy9pnnx9jS
         zOA8+QLA+4Y6K7kdewbx6c6jEjHe3YA+8EiJ3yd+v13ndaH21fudyGFEwPe8MDNwYtqk
         jEWnsC/nKUlwZh2LDjfjikeSVyVaD7oWwMtkT7NkguAijdoSm/1fuGeEuO+qTf8okSak
         PjjMstNrDE3Kto1DNrn1z+lyzpzpHOP/nFac8LUekKr5022p77lgsJPe8kALtX/Q51Yl
         KCTmot9wUZPYiD+IF0UQnCKIM/V6V0Z3tBuIZgnoaR0dN0mQhrH+MGXW3LlBN3JfeUaz
         fp3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787805065; x=1788409865;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GNF9twBVaAp7G+9eN2s4Q+uWE5O0f0kqDqf5iv1isXY=;
        b=XAZ4KFaM5tIBykTuvHvT8eMklQmi9l485jz3cuYWtXDWLx6nuQgpuvFwjpuXRt1kW1
         vbm6PvwovTQPNihMz8EGrxmYitAkdtmZP5NCn4ht68A+MeZKlvdcl4Jo4fwgQxjX35t/
         9YdNtyJfdxODMQy5pAVPwd0oeMRMMFXfqXgzLFYNyoOZ8WZXr1b17Rf9iQC2ftTz8Idl
         8SKS+YtPE5x4vm9v294mR3riIG9D4lARwiMoXzAeFvOYN4fxkp+qHj2DQHLiwaO8gXts
         i4SO9knIXvHg060eb4WCiDZr54FYPXPdpww3Hm21lyAVSEaW2B8OPqYZduD11/xEG8ov
         pY3A==
X-Forwarded-Encrypted: i=1; AHgh+RouWFdWQ6h4FXBFOD3ducuQL0YI2+xsXwPCGhQrrrQvBcptnR9km3j6dltBOkemRUpGCU1ER4psLg==@kvack.org
X-Gm-Message-State: AFuF++l1MBPE1hTmBm2vfZHyMB+vcqRMkTuxGJEMr1kOCIs2Re1i+qot
	v3vZ66ZuWKfBHbZ4tQ/IDpu3nnvEFBfB7rr3WXr73zbTjySGnT2QH+iqjGWLb7c7fbsj36vnrGT
	DXDW1g34e/XzkZyucz/Xalv8Okfg5LBI=
X-Gm-Gg: AR+sD12iCsyhVf1FLKmUXmwy1UYDV0lh3eWBn7TKZyMFkVSFZH5H3d/ToA+bj3habH0
	n12/rF+gpLNEv5BJpGZZdb0F9jpvDL0PIBWN8xA48OqDAFrgD3hO8GcqszCVB5xDGZic6bfqpEa
	nOH5Tuu9MXpmn0V5HaNs27aJ7SbH5rtz+tuhUrVyRrf3QpIow8cLl24/ziapwAoVbCd4tM9Ybb8
	bdpc3e696He/nV1ff/Kyb3IJrSLbX5IMb62u8po1aqNTjt4xI1n+4rWYTm+Ieue6W4TZB4l8W0Z
	PvOwD25L4Px30wrnQ3ESaTH40Qtw0JTf+7JJ/GocA+zxY2WH/Wo7d+J7BEMluETSiMzFjG45N2t
	I
X-Received: by 2002:a05:6402:2312:b0:6a5:f202:c1c7 with SMTP id
 4fb4d7f45d1cf-6a5f202c2d3mr5336319a12.8.1787805064678; Wed, 26 Aug 2026
 21:31:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260821102538.22642-1-baohua@kernel.org> <20260821102538.22642-4-baohua@kernel.org>
 <ao6qTTtk2xkkeKob@fedora> <CAGsJ_4ywk7mA1xfk=emtqby1UAwFsaH9PChmk2TuZoDKrMzuXw@mail.gmail.com>
 <ao-I8rYv_G5j4wz4@MiWiFi-R3L-srv> <CAGsJ_4zoXvyXG6-qAH+=nv6V92w_U_tk78YAPKMihRniqvTe8A@mail.gmail.com>
 <ao-dewgE9XAfP0rU@MiWiFi-R3L-srv>
In-Reply-To: <ao-dewgE9XAfP0rU@MiWiFi-R3L-srv>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 27 Aug 2026 12:30:27 +0800
X-Gm-Features: AcwNN1UHvc-7ieTQpT5mTwNxB7SGyV9BMF9NVmuEWVsoeKOE2GO6V9vnyqEIeyQ
Message-ID: <CAMgjq7CgT9yCz9bhfNtrsjNHh8=1F4zV7BKG4FRB5xWaLh+NNw@mail.gmail.com>
Subject: Re: [PATCH 3/6] mm/mglru: enhance cold/hot inversion handling in inc_min_seq()
To: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, 
	chenridong@xiaomi.com, david@kernel.org, hannes@cmpxchg.org, 
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com, 
	weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: yaxjjqhhpcp9cuwzz46tsib9onrkd6j1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8DBDD1C0003
X-Rspam-User: 
X-HE-Tag: 1787805066-199449
X-HE-Meta: U2FsdGVkX1+8R6OUo12EWR011x0MZFELTjV9pFAWIGF/JRDJj2QyXSQJN8qWBRau/XziBv17z9CVSorJas4Q2trcBarfcpiaM5+kP9MDQ8HC5+BudNOCwbTj5oLREOE9BeTBUD7OP8EiWfy6IJbrepDFNYhIXpmQkIWIqBm85ZpdxJUo3QnltmDEhXGz1FctXt3x25z5NAcq556s+oVkFvytR2z4W+uDDqDDZLA2bEyneYFQugLiDfGFTGUEi24NxlMDzMAStxp8I8bci/cMECRNGejJwhW0kQqd4x7FO2uf9SGCDmbkjp5Gw1uGL1x4tNPlmFU6FvDGMeVDeDYT5jvhjYQoQPYjwk85jfPK0Xqu+sC8fSStyAjMfq4D/iKWwmumh67DP2J9019YxlOs3yyW+b5g/GmbptbvhKAkl3i9fPwylySpLhbU04c3p/jwfUcKfxpz4FiM7pVfNVoDI9/qVHt+eC4T7YTCVh+OEJaVBzFT4qRpz89RdOqb5p4K8IkmCZEefPN8X51JEKlul5xoLDndisgHEpr+y2GZBQt+qI9B530wOSlMwIVKHkOS5Cpk3UO2K9S8BC9kIRo4yDPUgLr4NCzcMzzlk9Zr1DkKM4F7kszJR240hY9LgyQcoHNoKlta48/4LIcJ1k1VMS52nkJ8i0kCZ+Gm3EjMm9zKCKxnWA8iWEigehXJJcGzXlbkh3RI0LGd6w35kjrDIfiLYt+L+9Lftx1xlEIQp0b0ILxY5uUABZTHHdbDs3v3ddughOfpefqQ0f46gCRfg8PmryqJJV0UynSM0bisWjUkBb4SDwyu2V4Uk6EcLIPZkwlb7c6NjFR1ekKnnKno9VhDaSEBj7LxfD9yfRhlXDldTiqVnnpVRkHxAphel7j7gZMxcJphFq6WysP+K0QiDtXQy0mkTSDDqGrq+B67bmBnb3pJmfdrIupoW6uowbbmJ507K5ZPWt0jAjaDJvZ
 xmHB275k
 e/rMtOVdYXwxK3/26hJaTroK7w+MxLHMfGTc8LOt5az/nYThgEGHI0eIGiKrXKJNWkTwM/hMTylarYKnOipbL8+Vgyq6FKl1j4SQCqZKzVhEnVZGMpncHENm7GRsWJeeXTV/qXdRid7MwPoO5NcpSrSL4rl7r17WnGomUb/XPKo6oRYwDK1DL5C+9mMESkKlKnC7k7QWJKsYbnEJ9SzlMgDSmk+hNZN5AIGtEfKpBIfzkrtPQm1dhYR+Cb3D1tivSwmzLly831YwzlKgjsIHONnttn2IX8M+CEC25KWIMu/9pXjQM5g3db6tgLwsobQASZaQn0bDY2H/cNwMdubH80DAjgdTZ9KrYdQjFswRA/zjpEaMZ8W2Cdw1x07hMJFupz78BAK3lK6i361nxKyg7sXOWMb+arHEVV4/lC/OHXSrOoG/5EJrlY/RIlA0g7eLFJ/RgVIQi9wVp1Pee7dJAT5JuzxJpgktBsCBtskH21g6LSkDm4fFxrMUnHKJtmIptyHrLDJYnSsaa/draLnziyiLP0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 10:14=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> =
wrote:
>
> On 08/27/26 at 09:24am, Barry Song wrote:
> > On Thu, Aug 27, 2026 at 8:46=E2=80=AFAM Baoquan He <baoquan.he@linux.de=
v> wrote:
> > >
> > > On 08/27/26 at 05:43am, Barry Song wrote:
> > > > On Wed, Aug 26, 2026 at 4:56=E2=80=AFPM Baoquan He <baoquan.he@linu=
x.dev> wrote:
> > > > >
> > > > > On 08/21/26 at 06:25pm, Barry Song (Xiaomi) wrote:
> > > > > > During aging, a folio's generation may already have been update=
d by
> > > > > > folio_update_gen(), even though it has not yet been moved to th=
e
> > > > > > corresponding generation list. Such folios are hotter than thos=
e
> > > > > > already in that generation.
> > > > > >
> > > > > > It makes sense for inc_min_seq() to increment the generation of
> > > > > > folios that were never promoted during aging and move them to t=
he
> > > > > > tail of the new oldest generation. However, folios that were al=
ready
> > > > > > promoted should instead be moved to the head of their updated
> > > > > > generation, just as sort_folio() does in scan_folios().
> > > > >
> > > > > While sort_folio() move protected folio to the head of next gen t=
oo.
> > > > > It only moves ineligible folios to the tail of next gen.
> > > > >
> > > >
> > > > Hi Baoquan,
> > > >
> > > > Thanks for the review! I=E2=80=99m not quite sure I understand what=
 you mean :-)
> > > > Could you please clarify what you=E2=80=99re suggesting?
> > >
> > > Sorry for the confusion, Barry. I meant this is a good one, and
> > > sort_folio() has the similar issue in which the protected folios are
> > > moved to the head, wondering if that need be adjusted too. One consis=
tent
> > > rule for both is better.
> >
> > I think it might be fine for sort_folio() to move protected folios to t=
he
> > head, since those folios have either been accessed multiple times or ha=
ve
> > reached a tier higher than tier_idx. They are sort of hot in theory, ri=
ght?
> >
> > if (tier > tier_idx || refs + workingset =3D=3D BIT(LRU_REFS_WIDTH) + 1=
)
> >
> > But for inc_min_seq(), it is just catching up to make sure the newest
> > generation doesn't overlap with the oldest generation. Those non-promot=
ed
> > folios themselves aren't hot , so I feel these are actually different?
>
> I got your point, sort_folio() considers the hottness, inc_min_seq()
> doesn't. I agree with you now. Thanks for the explanation.
>
> BUT no matter what it is, protected folios, lazily promoted folios,
> and no matter where it is, put in head of next gen or tail of next gen,
> their refs are cleared by folio_inc_gen(). Then in sort_folio(), they
> are all tier 0 of the oldest gen and must be reclaimed.

Hi all,

I think this part is not true? a folio's PG_workingset will never
be gone after set, that pinns the folio to tier 3 through folio_inc_gen.

In fact, I consider this a pitfall rather than a gain; many workloads
have seen regression due to the over protection of such folios.
Especially with that "refs + workingset =3D=3D BIT(LRU_REFS_WIDTH) + 1"

Resetting the tier to a lower position is better if the folio is
promoted by one gen due to protection, to avoid over protection IMO.

Changing that semantic will require many other adjustments; I suggest
we just ignore that here.

>
> So here, I think differentiating them and moving them into head or tail
> doesn't make sense, the thing is whether if we need do something to
> retain refs of folios when gen_increased. At least, for lazily promoted
> folios, it should not be put in the tail of next gen and refs cleared.
> What do you think?

Actually, retaining refs has a very limited effect on the current
MGLRU implementation.

Basically I agree we should keep the refs if the folios are not lazy
promoted or protected, e.g. in inc_min_seq. But somehow we need a way
to "soft reset" the refs to a slight lower value so the higher tier in
lower gen won't looks hotter than lower tiers in higher gen.

This is not very doable right now, the closest thing we can archive is
just reset the refs field and not touch the PG_workingset bit, which
already done right now. (BTW there is a LRU_REFS_WORKIGNSET reset in
the FG series for this :-)

