Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B11ABC5DF81
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 03:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9C366B008C; Thu, 20 Aug 2026 23:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D74846B0092; Thu, 20 Aug 2026 23:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB11F6B0095; Thu, 20 Aug 2026 23:00:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE3B6B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:00:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DDBFD16036F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:00:38 +0000 (UTC)
X-FDA: 85123773756.01.0144A26
Received: from mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9EC5A100003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:00:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="hhE/r14b";
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787281237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XB0l9Dcjg8XmT9MPH8F7y5PP7dCpycA/U+FyTbpXnEE=;
	b=n3GfXCUYwDSXzBF3prFLpyjgBPCRy0Dv3Qn3dmYnO67NPhbZqVgscWJixdYONhMlLXlzen
	KQhEFXMsh5tVvymAULRvlrbjI+F8ZoXJ61rxAptrNWX0XToxpoUngVXjr8iN2LwxneVoIb
	c+DxWmwk0qLAUeklV0JehQCBshc6AAw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="hhE/r14b";
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787281237;
	b=qPn813ZRKgLZlOlsk57KR7G4j68QXaSF0LM2Et5o3vGiN6iqmdtuUtb6uQDMaoC3lRJVCa
	pbiV5YAeGErE8Xuxx5hBG4QjIdrTssO4gmznJiD6qcHJ8/bppcQWZ/p6UeuGF+LaUN9XH7
	itMDVKWE+SjEGiMBjV03rXsWnaije4g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uhrzXsEnv59xoQxn7xdMvatx4p2yG0HI+H5rxSB2d8E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787281234; v=1; x=1787886034;
 b=hhE/r14b5fa5SfRcn7cu44QGMI7KYSCkr6rmF/BtbaMxMAo7IxjUeg3frUoyXLbUvTWetTRy
 +RzkVwdEZob6RkKZXIDJAkznT6nBEJN2K8k1/dLV6JBtXIHUBU6m0Ur4C0a5utzoq6+jJlBbWYe
 0HEv3KVh9YtQpHikescY1qZU=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (223.70.159.239)
	by mta10.migadu.com with ESMTPS id 52bbf57bf0167d6a;
	Fri, 21 Aug 2026 03:00:34 +0000
X-Mizu-Trace-ID: 52bbf57bf0167d6a
X-Migadu-Flow: FLOW_OUT
Date: Fri, 21 Aug 2026 11:00:31 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com,
	qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com
Subject: Re: [RFC PATCH 1/6] mm/mglru: add PUD-level Bloom filter state
Message-ID: <aoe_T6-x0iQsG2SM@fedora>
References: <20260806103003.3924438-1-baoquan.he@linux.dev>
 <20260806103003.3924438-2-baoquan.he@linux.dev>
 <CAGsJ_4xZoSwAkRsz4DzPHQ7B=E0gCzRp93XhdnY+abCvZfg7bA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xZoSwAkRsz4DzPHQ7B=E0gCzRp93XhdnY+abCvZfg7bA@mail.gmail.com>
X-Stat-Signature: se9514eyrynfujtgynwmzzpnctnb7cp7
X-Rspamd-Queue-Id: 9EC5A100003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787281236-501668
X-HE-Meta: U2FsdGVkX1+vDDYhmZcF5hcDMj43sVyZL2NfHxuPb4yLgb1ylfrvI+UBsf4tW06oBLlYS16L0mLFgJ3tJZhVlVWzxRlzFV4jMGcnOd7IvsJlvb3hc8bTbuNskdXvp/XhEh6r0xkpipSz2Xp4qiQIdpY/Tca5tUK+aJwE/Qv9X8jq2bEUhpEcv+eQ6r9qadfDPECnL5cYUNG/76+/erN6AS/jqceAT1/IN3/Bp9tgJXqRihGm1SScpe+WnX95G56dVmbWJz+5TtH6rNaea8nxRjj3GdhwPBusuOokYxRYDYV+dywXcBy+C9iHEkFM8P1VV0Ce54zO2M5NPPjSDAdMTWyIofBkRbQ9u9GWIkJgn23v97Tt64GQGHV+bVfZuJHU9h8tbbeZgVJei/DdvCT/7vLGW6YVl5ZNz0sEHQzxuayqWOwVbzlYoE+g5lINhEO52IqZHb9trv0a0Zt15Jp3jpThshAjKpDqJcPhbCgVXnJgILH4DNX5T6uH12yIZzclRrXqhkAZDLTZCAYMjcdCurprN0qVpK58G6Qizq4MZDspdA3jGoSOym8aONmzxJO2LYeg4zQWsmlDXF2T7jUoRt0BHMSo9PQHnbJbKhrP4RUeZtjWWKZ3hysW+8DKv6c1pbF0uqzQCUeb8Z9Td4IvOZX1EKz+JWfiYMscx/F2c3PqzE1waNM4kKNQ0YhRwTEzLs98xwDmLfaub3usLW0QVtNEx3ra/Frk8XEGsJuR9nbCeLKfootUXHSXBy9wye4+AOtubwEwCLc4v3KAcGvGShBjoTMv573kkdINLsNRLWQPR2Y4lCpZT5lI4ZG49bX904W9QBe+N6nBV7LpDseHWWwVRctCw0OHfaf1/fqQ55SYVqRbtP6Q+yY2ni98/9vgmDA71wsbIQ9DGuJYplZ/XvjEBP8Q1IQS8+44pLayWwBUB+v/qGGVGGxbgtJXT3S6QHyIeDh8XK1bEAF4sM4
 McBBuG/C
 LBFPeOUbRHlHInBxUT+wQRgjmMYZRhzO1DrswpVJbCv/stChWiEmpT6NOnLlpf/dQdi0q76q4U0K87dclvJqEx6MOj/O19UL/FClsz20WiG5u5eeoH0T/kDA+njyDbnXzgLgWCDfJfKmz4NAat1ocZ7LsDEDTVziDwc4Cl/kr3Yh4rqmC4oloeoZYedh92LOsn2W/PXI23uhnK1h/JdNuyoYwWTNTKeSsMvt2pDZgOrogeaWifb1aAmZjPOAKnwbmpYlg7LzHi/zIEYbe5sofKpc0iTp0/gXoVrDX0PbGQbGr7V+oDVl4XA9pw/MKgA/iPeEIyo+fNWAU2ptXuQxdOi4Mrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/15/26 at 07:20am, Barry Song wrote:
> On Thu, Aug 6, 2026 at 6:30 PM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > Add a second, coarser pair of double-buffered Bloom filters to
> > struct lru_gen_mm_state. Like the PMD-level filters, they flip
> > each generation, but they operate at 1GB (PUD) granularity so the
> > page table walker can skip whole PUD subtrees whose 512 PMDs would
> > all fail the PMD-level filter. This mainly targets the page tables
> > of processes whose memory lives only on other NUMA nodes
> > (cross-node empty walks).
> >
> > No behavior change yet; the filters are populated and consumed by
> > follow-up patches.
> >
> > Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> > ---
> >  include/linux/mmzone.h | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index a26c8b855222..2bda24522d9f 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -608,8 +608,16 @@ struct lru_gen_mm_state {
> >         struct list_head *head;
> >         /* where the last iteration ended before */
> >         struct list_head *tail;
> > -       /* Bloom filters flip after each iteration */
> > +       /* PMD-level Bloom filters flip after each iteration */
> >         unsigned long *filters[NR_BLOOM_FILTERS];
> > +       /*
> > +        * PUD-level Bloom filters flip after each iteration. Same double
> > +        * buffering as the PMD-level filters, but coarser: they remember
> > +        * which 1GB PUD subtrees had young leaf entries last generation,
> > +        * so walk_pud_range() can skip whole subtrees whose PMD iteration
> > +        * would find nothing worth scanning (e.g. cross-node empty walks).
> > +        */
> > +       unsigned long *pud_filters[NR_BLOOM_FILTERS];
> 
> Could we rename them to pmd_filters and pud_filters rather
> than filters and pud_filters? The current naming looks a bit
> inconsistent.
> 
> I also feel the names are quite self-explanatory, so perhaps we don't
> need such a long comment here?

Thanks for careful reviewing, and this is a great idea, will change it
as suggested.

> 
> >         /* the mm stats for debugging */
> >         unsigned long stats[NR_HIST_GENS][NR_MM_STATS];
> >  };
> > --
> > 2.54.0
> >
> 
> Best Regards
> Barry

