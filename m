Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02373C87FCA
	for <linux-mm@archiver.kernel.org>; Sun,  3 Aug 2025 13:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3148F6B0088; Sun,  3 Aug 2025 09:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5DB6B0089; Sun,  3 Aug 2025 09:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B47E6B008A; Sun,  3 Aug 2025 09:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0B47B6B0088
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 09:22:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F3EA1DD749
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 13:22:19 +0000 (UTC)
X-FDA: 83735509998.10.9E660B9
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id 682CB20008
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 13:22:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dl9lrjDb;
	spf=pass (imf13.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754227337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+HSB2tvXT9bEvdTAs0YnamquQV41xlFnAe7adfDX64I=;
	b=R+kcGVko6f5ePzJs+1H052AAUJjlTX0dMNb6w2qw/RQUBSI2tRXgAthPt6xPkuRrNPHvkd
	uTVlRcO3E35RhOcIgtuyrkYHdVbYIFL3EgwQIlUdf63H+XCCSqzK02PeqI9yZA3DpOIkiq
	lP6vGFRCMMkHJ/RWG/y2bof11SM4PVc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754227337; a=rsa-sha256;
	cv=none;
	b=mNWqdhZVC2dKJVBzEJHz2Ihw1L93Brds42xnkODzzNzMzg827iZzrs2zudn7EkB6TxWrAy
	l8oklPClObxkofcaHzmHZM4w40uWJSVlo3SIZl9YEymV3hmbJvRdhn3v5X5/dQMryLtR43
	rOmQxmohWyqglQGeLdBneeL/qQPVxOs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dl9lrjDb;
	spf=pass (imf13.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-433f3bc84e0so879119b6e.3
        for <linux-mm@kvack.org>; Sun, 03 Aug 2025 06:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754227336; x=1754832136; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+HSB2tvXT9bEvdTAs0YnamquQV41xlFnAe7adfDX64I=;
        b=Dl9lrjDbXoeNgOppS0A/e943D9CHzS1V3FRrQiM39lA7o5sc9isbnIEHxTCS17S2f+
         3EIkUFyJZ720J9NZyDohsAdxYwZ76p825w91EWLpynw6FxeuqZkmUbOemrNJDZ8pMnF4
         KiAocp4XoG8gIgbPbwVfzBkiZ7AuYQjV4/j1knaaUTsRra3TRt5HQIXw+LrAGmCZgZaf
         kKEyCJOjbQ0HeEfor8X48BHHWeAHm3LK7b8i7Ew1B1tfT7qsHsvCDWAoJRU4vWxeDl6d
         VlWSWat8Bqn3nautJrUqbRVNDozANxbflBMXUUe2OOcg11vCSs/FAiWCchyTHjfe+ZNV
         CVMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754227336; x=1754832136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+HSB2tvXT9bEvdTAs0YnamquQV41xlFnAe7adfDX64I=;
        b=W/24Mh9TCbIPIMDcHEPFHCVBhuMzFbmGuVL0jf8KXEt+QOuIsH4niDwZosaaDyERuV
         VzWC4afL+2Re5FRwIhx3kgkDACizEax4qjy1aNaud1yVRQw17wnJXqiDSFPjwFSxIOio
         utxHDsK6liMmkzBsvxY9qzR0/OTEvMwNnEDoh5ZhXLnepu3bGN5jlKQzQZjnyblzt4bz
         VF0zUnMp20z9MYCNwrp1P7ANz54IzhtTdgkg8Pus3aZ2MRmtbeIzeeKBUWVgaIjZEqk5
         3yVUbm8xvC6yxiC3Y0yeqZxIVDiG5hnHRoe3rMLh8dl2nvbpnnQmvcPvEs2+c/24Vxn2
         aizA==
X-Forwarded-Encrypted: i=1; AJvYcCWlBSOp+x9Ru7UvxndKkZrbHbhIvrSxNksrLBUPku5vnOSFCRXw5+JMfRpAPoqAQiTHHsvan8CFQQ==@kvack.org
X-Gm-Message-State: AOJu0YwEvTC/6cOLTV2FeVs0tPXJZ7V7bCQqNf84DGqtK1WB+OpbUfnV
	2u9RmBUsFa2kBqR+IgtkWwJd75dxtGTkj8ZhVaTdw5hSPirjPGaHYgw+DLBiFCXI4NaeEWcqHr3
	3TbWJei+7V9td86TUP7012Yxk5qrhaX0=
X-Gm-Gg: ASbGncudzHmZMRbMInofkhofSN0dYz2tYLsUJV41ApYp6keUvAd8R1PFc8CDrGr39sG
	zuxuSU6jeDdtl2vkWA6ogikRn52BwtxNS0hjjSQ3WUiCNRP9rbpTqM/59oQhM3zfK8NnFmRzHim
	ikNJW9h1LjJ7KgiTkGv2S09tpFuK/aEL62cbACieCew6HVwVTD5V/n+9PueHmdvxTUQe6vbDMn4
	f9lizRJZx4YvdA=
X-Google-Smtp-Source: AGHT+IGn04YesBrvNNzeh//REFv0TT3N2YTD1FoQ5dkwA3yQ5PHDpa/fPvYvxWZgpv2WpkMMcoT2RPLeXDzNoumHyNw=
X-Received: by 2002:a05:6808:1209:b0:42c:702e:bd81 with SMTP id
 5614622812f47-433f025fc53mr3866937b6e.17.1754227336290; Sun, 03 Aug 2025
 06:22:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250803053028.51309-1-sj@kernel.org> <356d8739-d47a-4d62-bec2-38ce8f4a91a1@sk.com>
In-Reply-To: <356d8739-d47a-4d62-bec2-38ce8f4a91a1@sk.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Sun, 3 Aug 2025 22:22:05 +0900
X-Gm-Features: Ac12FXwyv8ipVC1nQL5c1LPsQ9h2YnPsPaEgrC1otEGx9PjzexUCxQucBXAXTfI
Message-ID: <CABFDxME81-oWdDzc6EzCEgHnXDTe_fQT0s8c2YuqMA1EDbDZZw@mail.gmail.com>
Subject: Re: [PATCH] mm/damon: update expired description of damos_action
To: Honggyu Kim <honggyu.kim@sk.com>
Cc: SeongJae Park <sj@kernel.org>, kernel_team@skhynix.com, damon@lists.linux.dev, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 682CB20008
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: rotgimdnc1e91kepzsjcfscshg81i6wd
X-HE-Tag: 1754227337-172307
X-HE-Meta: U2FsdGVkX1/V6UyGOq8Yu2/PytOrw4flvQDD3vPm79CUIDD0d0w6DuzGryBexGHLG3vh3qnJXkfG0jDxnhyE65/RnD87occ/FjiU8m694xFO/UddAuBgp79QkApDfPuFtyjVOZwsdMr4TIYvuHfR+59W9ArR3AHbpizmCxmpd8/m7Fe4R6pmGVP6nDmgYvzwUhKWr3uWXBtjBSw344lPC+ZHr+FroAAN24OWSN7slBIGwdpJnQOlJWpIIS8NR5KLOwzrWJTuGhqHA5T00+fIMeXjWdLAZV6l5yX/CbeR/EWr9mSRPW+z9Zb/5WtryGIiClgofwa5mJbDZZ2VY7mbgJDotxWkK368Wg3Ww02i/cfPkaZVe2IOyAlI2K47EgGH93JU/9egAUa8Pu4Tyac2SzPQkGnso1n58fQXZVgfSzScVVh7RAWDaus/4u7BCrGKIzGDDUlbwuM+IPbfBNurAp1EB3RLnhuDcUd4dhhRCwpLYyKPnxC6ACVshzpILNCtDY5toNdZXv3Xjy0PNXoTvecEohMe0DNtR+uwRgQKNB2FVyG26qIuyv1NvGJKCwUyx86AvenCqoyRndpGGCpgOXw2Mr0W3yjq2he18+lQ06lNw/BmXd1tvXy9J5GNd9cQzwlpU+ZB4L1e0H/+SXet5pgsh3PMwcp3G5dP9NRFPxqBWbT/Tvn+zMcGswWHQlYKvCe3EVAtme0nRfGq8ocGBNoCIzKK8EKeb5vSPiefFGYWMHog03UkJnQVa5nQUfOA/2cc7ttBhJx1pENY259BUoNr3Le+52ZxIW833ZiYH7yV5lh1a78VT9YqyJh1RbNfZ4FRQCF5vDXBiRSnJk0Xj1Qz32E68cOVLnmtxeTUXfdpnt7rDAUqmYL/FGg02Kxve2NWkxOv7Sr6/ybtNWPynhKH1Cw8z/lHBFA+vQWpt4n+WJa2nyQYpbEffMGX76Ibw0fuIQv9S1pZUV2Kti1
 2ODKPF5Q
 5Acdh15ZBcVrNc5006pjco1QswLQ8JMDihMIdCQHYdfPwSLFWdZyy9ZgpvabqMU/58vFVQpGaoeDSlgiyaY9kI5WRpOsegm+Qsk96dJA4ufG/uMxwzChQvxeqBwdC1nP1tZLqPQshkQr2fmhsxOokTel+hbKdnuFrOXteYDn5Q4WNM54FqGIaG9zZpYcPB8bkPfueEM8tegKNmgg2aQQCkN7mj41O0480jCdCvQBbgW4BPpu8GNS9FuQ1K1yFwh0SFMzMc7vkOIJqmhghXLtz4I4DKzj8WO9en7wr4hZiEl3UBqdi5uo547ZqEk9Ovz7VKsCS1dQY4Fe9pVSfdv2nf5Nb4G+ZtVW7pxJcuRKRkn+L/0c2g9gtzZ2YVRqXL0/j4SyL/f4uUEp1w/ZQPlGK5VVj80rfeXwRz+fXg+1ckuXd6OmeGkq065SejOYj+Vr+UMKaS8CWai/nvV0NtRnyTYGFugZu1EP02fUaAEnJRO71by/5jWtUkTkvJ1Wg7jkFR0D2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, SeongJae and Honggyu,

On Sun, Aug 3, 2025 at 2:41=E2=80=AFPM Honggyu Kim <honggyu.kim@sk.com> wro=
te:
>
>
>
> On 8/3/2025 2:30 PM, SeongJae Park wrote:
> > On Sun, 3 Aug 2025 13:43:03 +0900 Honggyu Kim <honggyu.kim@sk.com> wrot=
e:
> >
> >> Hi SeongJae,
> >>
> >> On 8/3/2025 1:22 PM, SeongJae Park wrote:
> >>> On Sun, 3 Aug 2025 11:03:12 +0900 Honggyu Kim <honggyu.kim@sk.com> wr=
ote:
> >>>
> >>>> Hi SeongJae and Sang-Heon,
> >>>>
> >>>> On 8/2/2025 1:50 AM, SeongJae Park wrote:
> >>>>> On Sat, 2 Aug 2025 01:11:09 +0900 Sang-Heon Jeon <ekffu200098@gmail=
.com> wrote:
> >>>>>
> >>>>>> Hi, Honggyu
> >>>>>>
> >>>>>> On Fri, Aug 1, 2025 at 8:35=E2=80=AFPM Honggyu Kim <honggyu.kim@sk=
.com> wrote:
> >>>>>>>
> >>>>>>> Hi Sang-Heon and SeongJae,
> >>>>>>>
> >>>>>>> On 8/1/2025 2:58 AM, SeongJae Park wrote:
> >>>>>>>> Hello Sang-Heon,
> >>>>>>>>
> >>>>>>>> On Thu, 31 Jul 2025 22:22:30 +0900 Sang-Heon Jeon <ekffu200098@g=
mail.com> wrote:
> >>>>>>>>
> >>>>>>>>> Nowadays, damos operation actions support more various operatio=
n set.
> >>>>>>>>> But comments(also, generated documentation) doesn't updated.
> >>>>>>>>> So, fix the comments with current support status.
> >>>>> [...]
> >>>>>>>>> diff --git a/include/linux/damon.h b/include/linux/damon.h
> >>>>> [...]
> >>>>>>>>>       * @DAMOS_WILLNEED:  Call ``madvise()`` for the region wit=
h MADV_WILLNEED.
> >>>>>>>>>       * @DAMOS_COLD:              Call ``madvise()`` for the re=
gion with MADV_COLD.
> >>>>>>>>> - * @DAMOS_PAGEOUT:   Call ``madvise()`` for the region with MA=
DV_PAGEOUT.
> >>>>>>>>> + * @DAMOS_PAGEOUT:   Reclaim the region.
> >>>>>>>>
> >>>>>>>> Nice!
> >>>>>>>
> >>>>>>> But doesn't it make confusion about whether this pages out to dis=
k or does
> >>>>>>> demotion to the lower tier memory?  It's because PAGEOUT action d=
oesn't do
> >>>>>>> demotion, but it looks "reclaim" includes pageout and demotion to=
gether in my
> >>>>>>> understanding since /sys/kernel/mm/numa/demotion_enabled was intr=
oduced.
> >>>>>
> >>>>> To my understanding, DAMOS_PAGEOUT can also do demotion when demoti=
on_enabled
> >>>>> is set.  Am I missing something?
> >>>>
> >>>> Actually no, please see below.
> >>>
> >>> I'm unsure to what point you are saying "no".  Are you saying DAMOS_P=
AGEOUT can
> >>> also do demotion when demotion_enabled is set?  Or not?  Could you pl=
ease
> >>> clarify, and add more explanations about why you think so?
> >>
> >> I checked it again and found I pointed out in the wrong place. Please =
see below.
> >>
> >>>
> >>>>
> >>>> do_demote_pass in shrink_folio_list()
> >>>> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L1122
> >>>>
> >>>> The do_demote_pass is used here.
> >>>> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L1293-L1302
> >>>>
> >>>> can_demote() implementation returns false when demotion_enabled is o=
n.
> >>>> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L350-L351
> >>>
> >>> I'm again get confused.  Isn't it opposite?
> >>
> >> The thing is that DAMOS_PAGEOUT call sequence is as follows.
> >>
> >>     DAMOS_PAGEOUT
> >>     -> damon_pa_pageout
> >>     -> reclaim_pages
> >>     -> reclaim_folio_list
> >>
> >> In reclaim_folio_list(), it sets "no_demotion =3D 1" in scan_control, =
then invokes
> >> shrink_folio_list().
> >
> > Thank you, this clarifies.  DAMOS_PAGEOUT doesn't demote pages even if
> > demotion_enabled is set.  Thank you for enlightening me.
>
> Thank you too. Glad to hear that.
>
> >
> > So, "reclaim" means "reclaim".  shrink_folio_list() can do demotions wh=
en
> > demotion_enabled is set.  I hence still don't think this patch is sayin=
g
> > something very wrong, and how it could be improved.  Do you have more s=
pecific
> > change suggestions for this patch for an improvment?
>
> I would just like to make the term "reclaim" clearer and we may be able t=
o
> define what "reclaim" is.  I think we can choose between the following tw=
o
> different definitions.
>
> Definition 1. "reclaim" includes "pageout" and "demotion".
> In this case, we better clarify all the other documents that mentions abo=
ut
> those terms.
>
> Definition 2. "reclaim" only includes "pageout", but "demotion" is out of=
 scope.
> In this case, shrink_folio_list just do pageout, but "demotion" is only
> exceptional case so we can say the "demotion" escapes from "reclaim" logi=
c.
>
> We might have to clarify the term "reclaim" for those cases whether it in=
cludes
> "demotion" or not.  We might have to discuss with other mm developers tog=
ether.
> Thanks,
> Honggyu

Because of the above thread, I got to know the details more clearly.
Thank you guys!
When the discussion of "reclaim" finishes, I'll make v2 patch as soon
as possible.

However, I want to talk about a slightly different topic. How about
adding support demotion to DAMOS operation action?
Maybe we can add another action type or change implementation of DAMOS_PAGE=
OUT.

IMHO, I think we should first check whether it's possible to set
no_demotion in the `madvise` -> `foilo` flow we're using.
Since I'm still quite new to these things, I'd like to check whether
my idea and direction are correct.

I can't thank you all enough for your kindness :)

Best Regards.
Sang-Heon Jeon

