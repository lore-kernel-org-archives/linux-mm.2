Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 034BAD39011
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 20:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BABE6B0005; Wed, 14 Jan 2026 15:19:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33DBA6B0089; Wed, 14 Jan 2026 15:19:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249706B008A; Wed, 14 Jan 2026 15:19:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1572E6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:19:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C08711B589
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:19:05 +0000 (UTC)
X-FDA: 84331683450.15.10EAA97
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0E0764000A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:19:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bgE9oyxP;
	spf=pass (imf07.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768421944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NnVPunCdziCYjBPDoSF1dzwrlBIY0pMxQWPBf1MeQGI=;
	b=LF6VhuNf+wu1WEwXGe8BsvBHDMDMh7W8kXRMuwyzliVXLVTML9i+dyaSJGxhSvUyzUZpzq
	FVzclTRnfplsLbr07FAhJeXgfgdhPbSD6aMop2zmEoNH6S5MBpzGXfFHJWWB2qpTRfed80
	Bp35nyEtqYbpoG7EBOF4KACmEVPZ+20=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bgE9oyxP;
	spf=pass (imf07.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768421944; a=rsa-sha256;
	cv=none;
	b=q6/oIea4US2HwQaES7hyE0fRxQI44ssjch7etVubVGHIeisYvsHfy8iJ01Ft0UI8wj/6Qy
	/8DcK5ES2KMN25WEWD1PvfOabkX0BP4sru9EHKw3sPmsvdNkVGJ2kJqkxDCLEXXMxmawth
	fob7RbgtsymoyJACQl2960u9fZQgZSc=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-78fb9a67b06so1582877b3.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768421943; x=1769026743; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NnVPunCdziCYjBPDoSF1dzwrlBIY0pMxQWPBf1MeQGI=;
        b=bgE9oyxPbU+UGSULOCndwMA0YJz6zLwKzbYwJJtj1w+b68MsNJh4rU++A6cmSetZMp
         QspuzixrfmEBTvwgS1tdr0OFggnqozMIlUt3mjc3KSHs5GAi8NHmSOeAJNZhZpCknGKD
         8hGvMYeVIVw3rkB/sKdHOzCkfmRTwuePtdw6MSIgZpvU5I8gI0LeWG389EXJFPMlGFma
         EHjjcmn9l4Efj5VBIIg9RGwiWzGsmSWbqUEJdT3mlYDBL8b/MzsNn5bdLIMl6Zw/LB5+
         RPwJrBNck0PgXeXH/+AIHe7aU/bh1C5ukRH3+Cz01qOZbFxE21DN6TmT2cAuAzO3GXzJ
         zWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768421943; x=1769026743;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NnVPunCdziCYjBPDoSF1dzwrlBIY0pMxQWPBf1MeQGI=;
        b=ZQUPcmVnu/vDgwx3gDzMf8EwyydZrFDr6XXU4mXd5FpgM0lOvLO1GYkG1XkB0m4thc
         jbVwEGmCwLNqnoU7ze5Z8mJwcG5kudpKODjdvI6vzhd+sMBr2ofZYt0PKNJtrvjiwkIA
         M1yeWBUnFyJFoHkQ/sT6IOtRyOa/de7EgQ9QxaN3D6u4AFORymZL4FznSrBKspDmX+9y
         Ak3qWZKSY4FVL8SkKroSBPXF2iH0Z5znrX2zmzv0WPDVcAbXa8aF2vTw8vbi33XG6LEs
         C0fxrCZ5yB2lichD4kt0fOmQk5ytwCzMgEjJC1/BqkzBCZqYCAZ4KLOX6wP4+g3sPg/A
         VJxg==
X-Forwarded-Encrypted: i=1; AJvYcCVFVGmpaC3DUqKsYsIzI1XtWb2xQbYdZ0M6DDXGM9cUJPJtC2jaUSpv6F6QAsGRXfRluTUlIj6/bw==@kvack.org
X-Gm-Message-State: AOJu0YwQAcyLmc2lT8ah4W5fY9dLBwbNvMdltqO+4rk30yS64FuEHxXQ
	CTCEaLkXhB6LCChRKZGuzhnRk1jVGGwIaW+ytj1qD2U4m+XnrxUdszSSQq78syAS4AoUFcoi1ha
	U5njOd3v6nIErOiwWvWsX+6OBJocVVPU=
X-Gm-Gg: AY/fxX7L+vUpInH/4wWioqDGCW3ohNBDJ3JGs+MzHO+7GN13tZrNoHKnwy1USLT3wZY
	IRkbA4NVscFzOk57kvKyzFr4Q4M7sHDZdjeKZT0rMshOy4HmH+TKSiE1vek8GIXuZG0TEznuYPX
	+DCl5tC9a+MbHgVVfR41w2lIMje2R+7IW/7AhLojQtFC4hOsK3oXzOHlhIXH78+fkb+osOdxpOQ
	FvzsVCR9zixR6KpCTic+xPAulMg007KBGFpAR+MkmXh/om8fEDb6pLUfYDTADOrZ3fT4Pty
X-Received: by 2002:a05:690e:d47:b0:642:11db:f5f9 with SMTP id
 956f58d0204a3-64901b0bb71mr4320721d50.55.1768421942984; Wed, 14 Jan 2026
 12:19:02 -0800 (PST)
MIME-Version: 1.0
References: <20260113121646.31441-1-rgbi3307@gmail.com> <20260114154622.100466-1-sj@kernel.org>
In-Reply-To: <20260114154622.100466-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Thu, 15 Jan 2026 05:18:51 +0900
X-Gm-Features: AZwV_QgIjApPfUqHCJ9CXsY1zOWH5eS4Wjd7hCBP9UHgwERtGc2_9jqPezDh2rg
Message-ID: <CAHOvCC4kktZ5rvPmJKpeHkOznbmLAxB1GfowU7NgLc1EUA3-hQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/damon/core: modified and tunning damon_split_regions_of()
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rgbi3307@nate.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7t1jgrbwqun65k616fg4gmwzm8ffecqz
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E0764000A
X-Rspamd-Server: rspam08
X-HE-Tag: 1768421943-438746
X-HE-Meta: U2FsdGVkX1/iIURhlzVqs7FNNGo/JJzjelJFL/fWD8U+5KDnqu+tlWmdcVafBqzD8Ofl2WCo/3grFAUfmm6UlN4v0WypFOFz+/sd7TfNNupMVAdLOPk1S8XxTwXinr0lhAdjWIYmMZMyhkGKK2Mfc1sU9w/AagQtaUxZmfWN07KZGezAxRRBDLgicsZbnd/Az7uJz1yX7njWlVk1iUdX/KDyMBKQ8gWkEg61dtsRY85r52aXHcedez8RGMV9krVckHmYTLM8oJ6ZXEoQ6QYw0Vy04Qzty98khRB0ClRXQkuvZcDwYRw9Fko2pj6eEv1W+W0bBdHFarV/l2t9Wt70YVB7s3Anf48IgE0dknWmiY/QhXLCxCJVyI+M+XYsUp761fkuP00wlNxJnTRAVY91kxczbn/+rmTM5i7hyMizmiQ0GZOzSYSBjZ5Ab1gRp1FqBQ/d4QpnoPNJNc2C7icmTHSSryPiYCG3oyrDQNbBgyohZ0Lofq03V97YOrnyJndkBBPtWLvBC0RbcWvyzUIp63ymjQh90cWJw3kxB/goYlXngqqzClWN73jdc5rmQAqJAChgBHg8MC0tbeyccLiLnHHXRVNNWB5YADFw3zAeiScr1u7G7W6TuYRK6PtQfrPaQmUaxwulliZtc9U/ApP6o8AV5C832bFZTvR7flRvQGyfo2TS5OSYemw0XTefsuwjPnO5b3bX4VaUznqHelfRb1vVTKepaER5txNv9P5l+S8U4BSsZbnH2CQZvJrRG+XyvWX/GmIs55fv9RVii49pn15pecj7IR3sVjbBC9TPD14NAz6UEIlKkNu1ApQPkKEH1IjspF8lSjC7PeFHxNkH2oyLGxzKVYk9FmuKOa4B9Ors7fp+dapgePLEp2rpTz+azRGvpByIHjkNR0vDTtOwyzw+Cx7UIk0RO8iKB+bRc8OkQ6KE+Xk2NWhuFyhsPrdwGPCYSOTEgOMuvUx1+/7
 f4lnIQst
 hkfQl9fy7z4+MwiPNxmQWKvQQeB9EsO2WfJGD0ADMW9vlH3wS08cNLsjdl7xNQOzyPU893YxYq7PtoN8lal32MP0iVrYK9QAGx6RBouGtllfQ1P25cDpAt0lDYy1NsSnUTfCzmm27MR06i0slUKhZORUUGtIgpaClcce8lfA21OL4ygKYea23YNDjfT28ysO4YTIZTA+txN8L0PBznbzCJjmnBCI3GVkVdR3ru9gg///8nZgVRupumLleDt6k/T/lLxqZQXc4OKBpw5Gapnwapy2apEAQtKrpYK7RMeFUGPbgKwleqrLU2Bh4VEBjz2LXrr1txH7KUE1Liej/e6K0w4c/JFvX7MOZMtsjbJOA4maPhsNmtEl2gMSw1efySF4nszghT9jnGh+h7z/8oRbXRgY46DjMZQkeu+NxXY4T5fDYqMDW2PwjQ6YGN4L2ROWdNl5n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.176332, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 at 00:46, SeongJae Park <sj@kernel.org> wrote:
>
> Hello JaeJoon, thank you for continued interest in DAMON.
>
> On Tue, 13 Jan 2026 21:16:42 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > Before modification:
> >                                                              sz_region
> >     |--------|--------|--------||--------|--------|--------|--------|
> > nr_subs:     1        2        3        4        5                  9
> > split random:    <----------- (*] randmon        LOST -------------->
> >
> > When dividing sz_region at rand, the random value may be small, such as
> > 1 or 2.  At this time, there is a problem that only the front areas
> > corresponding to 1 and 2 are divided, and the remaining back area
> > becomes too wide.  If the area is too wide, there will be many missed
> > address access judgments.
> >
> > After modification:
> >                                                              sz_region
> >     |--------|--------|--------|--------|--------|--------|--------||
> > nr_subs:     1        2        3        4        5                  9
> > split from   <------------ (sz_region / nr_subs) ------------------>
> >
> > It is recommended to divide sz_region evenly in the ratio (sz_region /
> > nr_subs) rather than using rand.  In this way, if you decide nr_subs well,
> > you can logically match the number of divisions and their sizes.
>
> I was thinking about how to reply to this patch.  Since it is taking unusually
> long time, let me add short comments for direct future of this patch.

After much thought, you ask a simple question below.

>
> The existing code uses random() for a reason.  This change might break it.  Can
> you further explain what was the point of the use of random(), and why this
> change is not breaking it?

To find a needle in a haystack, is it right to keep poking around randomly?

>
> >
> > Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
>
> Unless you can give me a convincing answer to my above question,
>
> Nacked-by: SeongJae Park <sj@kernel.org>
>
> Same for your followup patch [1].  Btw, please send patches of same series as
> one thread from next time.

I sent you two after much deliberation so that you can see them clearly.

Thanks,
JaeJoon

>
> [1] https://lore.kernel.org/20260113121731.31468-1-rgbi3307@gmail.com
>
>
> Thanks,
> SJ
>
> [...]

