Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F59710AB82D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 00:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4116B00A9; Thu, 26 Mar 2026 20:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 774CE6B00AA; Thu, 26 Mar 2026 20:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6639E6B00AB; Thu, 26 Mar 2026 20:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 542086B00A9
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:26:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2824E1583
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:26:25 +0000 (UTC)
X-FDA: 84589951530.05.008CED2
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8AF9C0004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:26:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="CtclD/p5";
	spf=pass (imf10.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774571183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X9rjmjgxuv6M5iq71wlttSNR553X4GPDWyfLJKbyYVg=;
	b=6gcZ3R2MHpdMtfStDwE0WGS6SLD9TvlkqEopvf7Ww79lmeVmOyz07Jxb7H4EmOzNOIDRtB
	9+WwuZN1Gk6MogOU7b2WQM3tZf9ao+HHtQyF7hoei4f7izopWPPVK5HnaVRFSXjJ1PhlmL
	2dy9EMZjTjC+9QlgnLEXWKVDvt2YFxk=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="CtclD/p5";
	spf=pass (imf10.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774571183; a=rsa-sha256;
	cv=pass;
	b=HyfJLsYoxyqQ1fqt3LJy/BUwwsKJp7LfD/wYrfalB6ueHDC1vKJL2llE47up1XW74EFGaq
	0Tmz6szIdK0eGFtH3m8WSN71eCz54rYYSOpCWJlkf1P8nX/1RsCY9vcZSXjjfZioFpdxSx
	3NpIHNOBQ1pdduxZVMbmB0mGnBZCASo=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b052562254so44935ad.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:26:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774571182; cv=none;
        d=google.com; s=arc-20240605;
        b=FCi0xvwsYxOAxbgG7R8/AeNTcichQnLhk+uhFwxphiuFTM1dJ1TaUQbCIYf17/NDyK
         QiSbtabTv/fviXe6AnNIhavk/BHmE4SGqeWEG5X1ZVDY8S1JiGJ7ryuyCIIEWyEnSoUx
         z7I1dAF+h/NHx3jiUfXuflnlCr5VnNqRZsDu/PvDbr2WztVE5riWTOzJ9uTdsAKJOrVM
         gzT7C022p9nk2x5HFaNElv/iqDWZXzLkglI/bjfkaEd5I67VJrE4D4Cr8vG0l+tnP83U
         maKraKKwE9i4NME6hS/E4Duuf0RvFZumPYmIw64VCK6UC3UZX3UlkpLwfq79rxk4Y8Jr
         h/0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X9rjmjgxuv6M5iq71wlttSNR553X4GPDWyfLJKbyYVg=;
        fh=1vQR6+q2+hp3JMILz571UMUBFiZrz5AqDWuaO0rTktI=;
        b=fQFLjzZe7JJ1qZ3FRdIwCbnSCIuYK3tBYip+m8OuIsaS9hIl1OQrzVl7ciyDJx5SV/
         ZV4/2N6b6qu2WOs+7F0aX44A/TUwb576BEbwSvdUiZt7hTsAJtmAFBjMoSr9iJoTmgoY
         K5Wlc/LznCIUUBddh1hB4GVJ2Lg7WHXI76agCdownHaoYT8nkOR/0peZWiJ2Am7skPri
         ZOe9YAQHsYXyOvff0fAoufJzw6+msG1C1bRWram8Jc5kqxSJrBfCTBEkAE15br5onC4D
         7RS9uCaGyBPVq0NVY7T0H4P8i6jFszKKIPRionQ8zRQP7i2DAdn3hZbScSgWsktVqAg2
         o7Uw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774571182; x=1775175982; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X9rjmjgxuv6M5iq71wlttSNR553X4GPDWyfLJKbyYVg=;
        b=CtclD/p5KjyyUjtQizGNYx+vgWKw4NIYjmIlKjohNl8j9v4BEMAY5o9LHmCfX46lXA
         X+hTpzEIpP3A6ikyKorqtXOQVjLyXqsCmu0Fe1OWOpuavlOacHaFefRbtau+tLBYOpUy
         JLe2T3y+bFO2T0/e2SvwpzdzRYdVYeubZgnwxS5T1k219MegCeqqXnD2VMg5LLNC6Che
         uEnRKOf6trQ59pTYri8PKmvqIAqH/VtKO8C2FpH8Do6BMacrbjT9vZzoiPgCd1V1h2Ek
         MSm1l32gq5D/ur7+qLIj3nE+2c5T+jbt4g3F2t20Kq//10tEO62R6ZuXZlrIP6EWkzrb
         J2Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774571182; x=1775175982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X9rjmjgxuv6M5iq71wlttSNR553X4GPDWyfLJKbyYVg=;
        b=rJNbhH61fhXUQ1oRFxw6wd6k3VWe0I/ICN9ceEe0tVrvT/VnKoMBj3hEMvvj5fo4H+
         1GBHAjl5F/+rUMCynwwTjGEvB9gg3iFQMI7k7i8J3UwxsxoZts2rnOW4F6Wqp1WXP0rN
         l8GQEc52iuuqIDb3W5tKb6RNbdyOce4Bf3CTCRAjbTMHxD2mNtcFYF7hA/6Hu44YJzoC
         wUM0OnHmCvm6YXB3IVmqrKStE1YA2MLCPrX1isC81cGE4p/v7cOLO4FyuWjqFmhM0dM7
         I/oflJ1XhCGijJH1tlkNJlJ4/LTaxgMjBOdNF+30DxkCur5SvsM+OZXbE/NHCbetq3s8
         OWmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYt1ZRIolkw9dvGe/M/DjvnXu+wypcY7rHDyvx/jsLW/zR67F/+AuyE1erPDyIS0baPWccL3vxNA==@kvack.org
X-Gm-Message-State: AOJu0YxLIATJyiVKfG7Y9hxF9Sz4x32MaVVFD9wBv+cExoX2x1Xv41Vl
	bGVq+pcvWCHZdhGetxnEKu1fuvGSF3d2GN55LV+NZtMkzX4Bvx4vCzlt7RYmPCjhEdlZXDE7Ago
	6srqcDee/fjEHvtt1NMiQ3cnWvm8nr+ytPjH7dwdp
X-Gm-Gg: ATEYQzzzkatgW97RTfAZ/HgkjOPEQCb6/nfIdCizCIT6jTXRSYjtWEebBMoeymzASj6
	EK0CK1FLctMNaBhI3UoznSOy79ZiWe9AamfT7dk31lhBP+20o3dW9tHY8rlOjY+AmZ+REyGDSRn
	eqJAAEERCfYiSV35SzAWtgc+kNPY4b6lQvpuf8Hw0pGN1azM2UPXzqe1sRTyZ7UiCIHFG2sy+4b
	Tv+SZ1SSXxZXu09P0pJ2BdeWLjIXiRM5lqj2u+NNadZchwqSC+yx42RvN4ShgLsA39PpAm8f2cP
	O88ivfMSQf+CAmkPsRU+QgYHvF8bIMcC04WDlw==
X-Received: by 2002:a17:902:e5d1:b0:2b0:be7d:a25e with SMTP id
 d9443c01a7336-2b0cc2f4dc7mr1248615ad.18.1774571181854; Thu, 26 Mar 2026
 17:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260326185629.355476-1-ljs@kernel.org> <0d4e27a2-e9ae-41ca-b327-82296cbb0cfb@kernel.org>
 <CAJuCfpFY311807PpEP==UKBLqXXDENA3WjXuNnXMpKaOE2JQtA@mail.gmail.com>
In-Reply-To: <CAJuCfpFY311807PpEP==UKBLqXXDENA3WjXuNnXMpKaOE2JQtA@mail.gmail.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 26 Mar 2026 17:26:10 -0700
X-Gm-Features: AQROBzBPr9qT6dszlnftEAGpP8GFY6wdLTU21ZD8ZX0bfOFAEdwJwbiKKcaIQaE
Message-ID: <CAC_TJveJLkp8MJhphXA-xhyXCpC17p36Gf1OtKLT+oA8LwD0zA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: update MGLRU entry to reflect current status
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: uysjthj6efukhoqk49o648bwhc59i1hk
X-Rspamd-Queue-Id: B8AF9C0004
X-Rspamd-Server: rspam09
X-HE-Tag: 1774571183-385133
X-HE-Meta: U2FsdGVkX1+LUWbHxW7rbtE2PO6Gj6wVlJmx6f5RuugrkO+B+0UieL91ataU499WEEJKIaGiiX+Bj7V0kMiBHvD9EqiDxI9aUAczB3AsNLekITNvtiPGrzhZaQLW8aqzVQ1Ng66axEBwPX5gjb1tg7kAkM7NYd1c7a41l+v0h0ovg0sU+3sufE1jBwAH7z38U3p6jKpYS4Lmtwl1w4PaGjA+LE7mduVJ+SJbm37h9eUAYBnJZD7nyQrWkP63vbENd4Gbarh1QvUmPwWpJmactfdKhXuTqg4LH0y4Cr8wlGn/LVhFfBFg11N5LA+TRBMGkyCsGv2codNM5+nMQaLMJ736sEZ+nG2LwMr/3IZIg8dltr6gHDHtK4yzL4ixiCY7Lsd/KdXcncQFqbRD/nYjYUEB3o+fUJlNIjHvHpXUl3hMW1innRv7QbP+fPdAXQgwW8fbbzYkWe3nzO0oHbF04MjsTIU6JDlVIbOxwFmzA3owzhU4p1Fu8QsXqYpNgN+A90hNJIPmV9YHAysWecBRzsy2CJei58rChWMhheCe1EuYrkekrE4s/o7/3hDM5zX0eZFB5u64m4GDs0iIJoaQKzqkbbOYSgY9HMVpsrQMMRgZk3UmTMq7oFzgK3BbSUofvpOdtorF4CGvE7f/ebSzaxLRmewtCPtZ03zudbpw6iPWOpXZuEyO+F9R6s21XeGCO9icLZzJdd2xE1YMpNiSF29A35+evCOiJFFgrpql1nSD85qai95eFuwvEStcBYXPCFcLbQm46g+mdUq57TsM/x1FlhZKgnAnpfE73p9bNYozLZ4wQqvpJZyQOxeZT6w7BzobRx2vmKhAtaCL6SAsIUi2RtJvDxTxl5t4/qMBl0zfGb5ImMlBM3o4w6cLJUOEA6PzG7AWSvb+RhVMqa6elEuGnW/P81Yn2l74IlyNyfhprQ8rduMmPAWclU3caQs1EZFG2lG7NFBpwrCc7e/
 Nd++tBco
 84MYONPjobWnb7uoYwXDMf8xFlQkNtNYYTRdy7LahWd/1+xYAL0wg6/TWsUK9LOMnHtaJV1QdjLxwl+060o+IIpXsbpYSKbl3SvHl/gPlzhh9VrWRFcIUhDPSL5Q+IHzwZ06Ma8tgzl0tWyCuBMIwLK8epiLOBQFoR4kbhbQnAnhuZO7n9zX8NdhJA00+ihhE5OkffCim/elytYG6vBACvHdix2LXR4r5WzjzQqNT+3+lIU9L5tyFdF7Etekmp0QDX/8boihgNbdOLLkn3uI473FZ0v/B3Gh+D6bCLnGdP+UOrYTOU6LUaVFaZfxUxWV2KZAspYWj30YxVREZNLT3khiTxSvjreBVnBDKd29upi32E5c65tTeuw+fyHDEySICq9ssWmWtvRC41+6lngl/ks1afvaKTsSgFdGb46ddngLMZaw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 4:47=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Mar 26, 2026 at 12:09=E2=80=AFPM Vlastimil Babka (SUSE)
> <vbabka@kernel.org> wrote:
> >
> > +Cc Suren as IIRC he mentioned some intent to look into this as well, i=
n the
> > mmap_lock call.
>
> Not myself but I asked Kalesh (CC'ed here) to get involved in upstream
> reviews. Kalesh are you ready to be added as a Reviewer?

Hi Suren,

Thanks for looping me in. I plan to try my best to dedicate time MGLRU
reviewss. Let's see how that goes practically, and we can look at
updating the MAINTAINERS file later on if it makes sense.

Thanks,
Kalesh

>
> >
> > On 3/26/26 19:56, Lorenzo Stoakes (Oracle) wrote:
> > > We are moving to a far more proactive model of maintainership within =
mm and
> > > thus put a great deal of emphasis on sub-maintainers being active wit=
hin
> > > the community both in terms of code contributions and review.
> > >
> > > The MGLRU has not had much activity since being added to the kernel a=
nd the
> > > current maintainers who kindly stepped up have unfortunately not been=
 able
> > > to contribute a great deal to it for over a year, nor engage all that
> > > heavily in review.
> > >
> > > As a result, and within no negative connotations implied whatsoever, =
it
> > > seems appropriate to downgrade the current maintainers to reviewers.
> >
> > Seems fair to me.
> >
> > > At this time nobody is quite exercising the maintainer role in this a=
rea of
> > > the kernel, but there is encouraging activity from a number of people=
 who
> > > are trusted elsewhere in the kernel, and who have contributed relevan=
t work
> > > or review.
> > >
> > > Therefore add further reviewers, and at this stage - to reflect the r=
eality
> > > on the ground - we will not have any sub-maintainers listed at all.
> > >
> > > Each of the files listed are shared with other sections in MAINTAINER=
S, so
> > > this doesn't reduce sub-maintainer coverage.
> > >
> > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> >
> > Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >
> > (I assume the newly added people will ack their additions)
> >
> > > ---
> > > (Apologies sent first version of this without MLs attached :)
> > >
> > >  MAINTAINERS | 8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 76431aa5efbe..16874c32e288 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -16757,8 +16757,12 @@ F:   mm/migrate_device.c
> > >
> > >  MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
> > >  M:   Andrew Morton <akpm@linux-foundation.org>
> > > -M:   Axel Rasmussen <axelrasmussen@google.com>
> > > -M:   Yuanchu Xie <yuanchu@google.com>
> > > +R:   Kairui Song <kasong@tencent.com>
> > > +R:   Qi Zheng <qi.zheng@linux.dev>
> > > +R:   Shakeel Butt <shakeel.butt@linux.dev>
> > > +R:   Barry Song <baohua@kernel.org>
> > > +R:   Axel Rasmussen <axelrasmussen@google.com>
> > > +R:   Yuanchu Xie <yuanchu@google.com>
> > >  R:   Wei Xu <weixugc@google.com>
> > >  L:   linux-mm@kvack.org
> > >  S:   Maintained
> > > --
> > > 2.53.0
> > >
> >

