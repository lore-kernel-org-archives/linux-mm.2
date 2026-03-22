Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F797FC72CB
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 16:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831F06B00AE; Sun, 22 Mar 2026 12:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2D26B00AF; Sun, 22 Mar 2026 12:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1A06B00B0; Sun, 22 Mar 2026 12:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7066B00AE
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 12:11:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E53DD1A0652
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:11:19 +0000 (UTC)
X-FDA: 84574188678.08.2B6144A
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id CF4744000F
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:11:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G8TIlCga;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774195877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ycYEtAZ+5wn8zbQ0EzQy6no5+hAvHJtWMECPeurjtec=;
	b=8KepKMlhyOJnDUy1AoTXU51ffWbekDWlQZDVVkwWghu1GVwn4MqdMhfd9eD7ISq5l/LNIO
	p3fxG+2WSFL/5oydnebAB9qMVFYaDVeMdKo/YOGa94PRUHa8YTtt18LDZSjwSLTShuvw8U
	JuHFZG+kL7qq9hRtSmv9nakFuTIJ1ro=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774195877; a=rsa-sha256;
	cv=pass;
	b=svTedP3KyalLB30DGgrS1sixe+NX6I+g0/04He6hxDflaAZ5E65T5MrjxdWcqjYu1N696+
	uhbN7Q/XilfVhWpe+CMsKGQqFmGiB4+a+e3pByNdbRwQsySmna6q+R9hk66SK4KuXt5fGT
	9YQ+yFaEYV63dM3s/vmWFN8FKAEfDi0=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G8TIlCga;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65c0891f4e9so3198067a12.1
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 09:11:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774195876; cv=none;
        d=google.com; s=arc-20240605;
        b=Wk3fzsdqljvhsgBO5ZFSzwNm3+elhAx+Tq7USF0ZgriDUstKEgbfvZMQo7NXxgG1sa
         ypAGled6bnDb0TabEGGuY4MeBEspHmfIaBnht6w73qN1fMxRdC2M81l4DIFoRSO+Zicy
         YbkLUlcHxc46LszafdIXzB40ffKOzoxdfr4gYkQk4+j2txnC/g4SMQBWDSSQ0i8bSD3Y
         3MOe/7uYAHcUXfiU+amtzr6E6TllcIbRapF3y60ZOfEDJtVOV3NLuw1AdJYnupyK6Hx0
         G8FqnQKFLZVsNqj2skHdn4ADtT1T29bzEu4CvzIoi3GZ0aRsT8w88MnM81iSKxyODdZj
         33pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ycYEtAZ+5wn8zbQ0EzQy6no5+hAvHJtWMECPeurjtec=;
        fh=GrxsEyvfNXGrbHrphCTFzfT3jhTvuoOGSVKzwWYZMRU=;
        b=EP5h5UWHUBYklv5RAnULQfPGNUBmvVlvu1K/I8YllaApTbBSBf6lnc26We1/1Pv9RD
         gfBcHCNfrODuGgYJyPDggeih2M6lJ/yjaRcZ0vsqctwe2l/pXhle+J+dnIf1sjXk3SfH
         ddWETBzXB0tBQDiT6iNXm6z6oV/zB1BEc7uMds70qGvE/yfsh1QoJbP7AVlX10OJFLxh
         8cLIwImgKN6GmW6K2y8131aiTqO1/YcKHmLJwp7HejQt2fqv5lOhakcNlUqaiNneT3Zj
         WSrxgNKFkQ4z/an3iidSEZG4zXkCzhLBnKyNeMjy4lYZE9GP1LPpT8yNMUsReeyuZE4X
         HblA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774195876; x=1774800676; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ycYEtAZ+5wn8zbQ0EzQy6no5+hAvHJtWMECPeurjtec=;
        b=G8TIlCga1sBJ7ylsjWC5lVbYuXFQVBA5TKXnw/aoExnEFLn5WBHFNNWlMw4JFpagDa
         RBY7mYCFPJxPYKSmboRrws86XprFAryE6TLlyPwWvFG2MojkUij1nCAKStsKn2/l/y9y
         n+u72Juj1TKh7dSwWJdtB1vh4HYHOVJYqx10GlJ9DCc6iYvNbVvyakyvDglWAxwisiOx
         pT0NpQF8wvrwpH0Y77+ZSqisjwKgsDQgHOQtGxyLdBT8Di7FrW80PdyWljRKNfO7CaAI
         cKZXYjS/6i0Wnv2W0/LRRILEGh/niyrbkWCkkYYeR6qiqJrHMFHsz+ABWIT42Zl+YAFQ
         PBEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774195876; x=1774800676;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ycYEtAZ+5wn8zbQ0EzQy6no5+hAvHJtWMECPeurjtec=;
        b=T5R1/D4bDqABPPvZ5CuGxDUCFBnOitD2sAZUerb7w5nhllqAuTHK2Ql2squ2MvKwTO
         mYm3VWdNHBKPfEplzc0poD+2+Ut1KFjcnp9qlSiSFfmjJ1zcGgrDRlS+5cEBVbuMxzs+
         9mK8HLk8Tdpubt3m4s5ZGPZTYLtfKBW9Td576AJni3tX2bgfEO0Z6j2kojvZ1YnApbsz
         hrrwcSTh55vYE10Euxcr+flsVkYJaxZwuxn6zBFezVoiXCzc20uGDDU2NL7l5BG1bJos
         3VvDfrHpHPMFkWnLzuU4iRZsdpnO3DmrZsQWomZiFKIvDzZ+FaZvoo00+4urVBJiZtCb
         1czQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhEJbC9iCjOXtSIo/vLzWLs8caO4FEp3FTnjjr0KtCTvah4S0aXDyOrND19Sx6KAA8dxkMV2AagA==@kvack.org
X-Gm-Message-State: AOJu0YzOpGHoXhMNv996r6Q4076AvL2ryC5i56bPkmnKQrd3K2tSQPV/
	UpdTnB+3AS6O/an9SyFvkmHhUMSVWdhVfHNPA2h0mUMgEu8LvWKbmsmWghckcTHmOA8QYltjDHG
	2t5WP22EHcm4Jhwvk1HjyuMYdPORgNco=
X-Gm-Gg: ATEYQzytym5yGTFgVv4S0Xph+5wmEiB+56AGpxyq/sGC7hFeiTKvcN7Ve4TU6f7J6n6
	VlhdEyynknwkjWoaR3QaeBls8C37rskmr+XQtH65XDVMhBLHYnTHn46kWSUd2tPV5stbV3FWzT2
	rgZvDhgxJ7SdVodKBEHG1c47fB/ABEQRijlJSmDtToyTzoiBJ0hL8vKeXf3WutFWIC3XYDTGy0p
	hQ8C21N0oB03K5/lfiwSl1ZeuRavbW7Zs32hKdqeQ30fO0UKjBa0KDY7xkx/8sjdfrMmLcwXGyQ
	rilZSiDv7Zqir0pmKMFbNQqGEyizbkjsn3RfGUcc
X-Received: by 2002:a05:6402:378d:b0:65f:830b:1034 with SMTP id
 4fb4d7f45d1cf-668c90fc918mr6409171a12.6.1774195876199; Sun, 22 Mar 2026
 09:11:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-1-2c46f9eb0508@tencent.com> <9f982344-1137-4d8a-9186-b1b130dc15a6@huaweicloud.com>
 <CAJHvVcgTxcZCACyniBuQeoGzgAyQzszHYWo+vj2i8TUC41t85Q@mail.gmail.com>
In-Reply-To: <CAJHvVcgTxcZCACyniBuQeoGzgAyQzszHYWo+vj2i8TUC41t85Q@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 23 Mar 2026 00:10:39 +0800
X-Gm-Features: AQROBzAMP-bx-jd6liLNEMO7QiBHkxsHeR-m0s8rEu0PiLssTtGCPkxSXpYAb8Y
Message-ID: <CAMgjq7Ag7_uPW2KTMiR+tDRTJ8=3S1cZNPiXJ6DhB40AbR3afQ@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm/mglru: consolidate common code for retrieving
 evitable size
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chen Ridong <chenridong@huaweicloud.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CF4744000F
X-Stat-Signature: diipuzgtys68dcjcejjr555h4gky7ik4
X-Rspam-User: 
X-HE-Tag: 1774195877-884800
X-HE-Meta: U2FsdGVkX18ERlwx70iZx5r24BDy1BrZiiNfF5f+9XP/Stf3NApYSSjiHRJ8uCw54hKkErfEyiHrqH0nGws/njVRTIpdErhJOPI4mSLap9jemVVoCx4PbqnqKqEeqDV/zdRdSQtReSwdmMINpnnUGYBoGsqs+jzCoVNbCZAI7h8N/QIwQk5hX2JPwBmcW2upTZeHLqSfj9GkNxNtnDJiBKtAC57tajeDWKUJ0Y7qJcPWwX2pBqLCmk8l14sot2oC30XzWy6S5mc0xY3jyYWfkC2EJc+9ZKGFOJgH8Yql2/oCPGYoF4DX0cHEdh6Ss8CUVA68k+zxV3oPLAjSLnAJ+uPoP+o37ZpMJBMensCC2hGEpuloJBuxcPSU9LC73ClI0uKkYGsxDeUybgepq57ZnJRz1zUsiVQ1eo2rnz6lqETdZcxsIJwbtlzSf1hjd+2hJ7qZauDqq6oh5sO7a0hPQiVJe6ZDuJ/LpdwX8n0x7rR3rlnyN2Z/SBS0lgxmcCLFik4J9yuU7sXW4Yd0rUmXn5SaN8Ig2T7L4No63ATEEOsxGeoNIbqLWU+1VoyakmTQ+tyg3nOKbYeCpLSJqIa4pQ/I30ujtEQpj5OSVEPFuePf1ECAw6Nz1htqZyZnlr160mx0nfObKKhYAFbPTjStiMB+hdGoiMm4dRQOxMD1n7MTlT02H2VHNf8VrCzCOWz3k4OdGOdpHEehBYzicnrDmamNJVAqO7J3nZ3SapKZg4JFp486gi2AcUp2HGHsVixhEhIfqdCVJ9dL80tncbheZ7uZv114j2wAyxrfhjNDdSORoZPmN5n9oeVamq97JcLuq1hYQqnE9zH0vNPL4E6XFqb0PBLwiz40zSHoRQRG6EkE/3i5VgWLG5LZ2zt1ztdWslSE6G6v1mal67s/ZALmMO7n5mMt9K52FOzR2indhIu9g3zLyX80tmEGo8hyjRgtOzM4CXlm/8QnLTgFaJj
 YQP/Dxfj
 AyOb0XcWiQZEi4yualZGBFp+6LU913buAMTe2JnSHnus1aCIzdijVn1IED6urT+QLaQddsYDbXLywLRgfww2ZOP2D8iU6q9OMe0XHxLqBCuWnmJCaDyLxj4stE9s4COzWJ+CX/ctQJNUHtRVyre3yHihnoZ4A28+XrT2fU2+ftWjHLxwDhZ9uH8Cgm8S7mEH8tHb2GEE6LcBMsvI8lNAGcy/JgJACR2q7e/Us+5quWfbyMTQHzbc8bQigfihzunv55DOXJ1pXR4/yk/YaxlY9atnV4Yf/bSJV3I6s4AT3ZRC5n///Asel228avsubQmqvZWOyHtTfhtBw/SJPxs+IbV67dzxEklyIE/xyswflkAjLfz6Q07phfKPfy+MQIZ4zEzvpv7fPZuBdYXlEBJPNyR8BXZmGgs/YJcIaR2EgjAa0Zv4fhie0JczOZB4unmuWgN0pZWWt8qu28NTn4k8bQBuICmybuAb6zMQH2GbonGtguYnCOrKHqH226w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 3:53=E2=80=AFAM Axel Rasmussen <axelrasmussen@googl=
e.com> wrote:
>
> For what it's worth, I applied the full series and ran it through some
> basic functional testing, I didn't see any bugs or regressions from
> that.
>
> Unfortunately, the best signal would be actually deploying it under
> some real serving workloads, but the latency for me to do that + get
> results is like order(weeks) and I suspect you don't want to wait that
> long. :)
>
> This particular commit looks good besides one minor nitpick:
>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>

Thanks! Usually I ran the series through a about 2 day long stress
test matrix, and similar code has been deployed to our production
fleet for months. Just didn't find enough time to push these upstream.
Glad to see we are making progress to improve MGLRU upstream.

> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 33287ba4a500..d7fc7f1fe06d 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -4078,27 +4078,33 @@ static void set_initial_priority(struct pglis=
t_data *pgdat, struct scan_control
> > >       sc->priority =3D clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY=
);
> > >  }
> > >
> > > -static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_con=
trol *sc)
> > > +static long lruvec_evictable_size(struct lruvec *lruvec, int swappin=
ess)
> > >  {
>
> Since `total` is unsigned long, should this function likewise return
> `unsigned long`? It seems ideal to avoid conversions unless there's a
> good reason to do so.

Ah nice catch, that would avoid an implicit casting, I think it has no
effect but wIll update in V2.

