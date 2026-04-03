Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29080E7E358
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 09:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9F36B008A; Fri,  3 Apr 2026 05:25:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28B4E6B008C; Fri,  3 Apr 2026 05:25:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0FA6B0092; Fri,  3 Apr 2026 05:25:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08EC46B008A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:25:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B06A71B7144
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 09:25:58 +0000 (UTC)
X-FDA: 84616712796.17.AA08324
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id D729320003
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 09:25:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YrFAJ0rF;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775208356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V8rwvXnVBjuHbJpTYFqSEoeoIulBrF4TUgcT6yi5HCk=;
	b=2Zme6qlwXyPKZ+hmaBjHxoJSSf9TLaYDDUuwCkv7eqOAwNetT6CXyW9AvaeWz4bkU8vEdb
	vyGDFzYxkhJxmeXJNd0/PpApmskta48xf/+pPevR1LiLTclLnnvvG7Nf3e8hdHBlPIAiic
	wZZ//EzCDjOMBdUQ3HXunhO121A5578=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YrFAJ0rF;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775208356; a=rsa-sha256;
	cv=none;
	b=WZDpU+ozxsSylGgEXyAMLEnIyeRUQGe0drIaB/F4w1/41HNSf2IBDqrv4/PljPc/Gq8Th8
	7QHxhxA/jOnE0bpuYqsrQiKEPBJIg1wc+M+z7QtdgIdyi71xiZMf2qMiluO3C+nUrbEvN0
	Ab1pu4rQ5ahD1Gz4xsfRKHy0LuiWVG8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 50B0560131
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 09:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDA1C2BCB5
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 09:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775208356;
	bh=WyI3r5saJuWJFnyYMaWsOg209eedBKVgYTU8sw7H+BQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YrFAJ0rFH9D0TTmhuiSQaSzdsikJatB5bmaXZ/PXVLqcct6ss/gjdYAG+DnUP4Tgr
	 C/hkpAEZ6i8HcbGESJiiDgEeA/0/3XizWvgdY9aLeXya5r7bCZuIxR1fKPaGpqgcxO
	 3zE5isZCCZ0cbIf2J7eCiAIM+/2gDW859OGl+whzEVZlysWNrOCV+CKUtwOxoxu3z3
	 HQI30B5lOPdP2LJ8TSf+iNEmgfLJX4Gc6fOoKjxZ1yqLQRtWbfZNfLX+QA6LTyXoE5
	 FwvhGF9+2mfDUbMNjqrHI9h+qW2TENxTOvEu8i7iJWZaUJ2+cETETEqAM8TYKYbCl8
	 IdL4OK1uAU3WQ==
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8a08fa355a1so25983536d6.0
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 02:25:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUgmzR+1ELqAx2Egw+ysdaDCLig98ZJcJXojUqQpu6gh84rIG7Hey0lf4yVJNVB4qrxHvPACnKMZw==@kvack.org
X-Gm-Message-State: AOJu0YyQlnkU1HtZ11alzCgJgZeZUYX9gdOsjTN0dSju0IoZztepQ7DD
	9V00DON1rbHa6NILTQ+DH87A/C/72LncB0/+lVIMJv6c+coHFum0TBshU4rPYjxd/Ia+e9Xzbfp
	kFYdSKwPr31hxF7JeAtMMqU13Pm7VuYA=
X-Received: by 2002:a05:6214:2f08:b0:899:f993:f2a3 with SMTP id
 6a1803df08f44-8a70326f35dmr36663106d6.23.1775208355111; Fri, 03 Apr 2026
 02:25:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
 <20260403-mglru-reclaim-v3-6-a285efd6ff91@tencent.com> <CAGsJ_4z2=Wrm0NAfpE_98rKqEgncBceVscqFRGDPeuR0eCxQCA@mail.gmail.com>
 <ac9xnv1Opj6cVS2R@KASONG-MC4>
In-Reply-To: <ac9xnv1Opj6cVS2R@KASONG-MC4>
From: Barry Song <baohua@kernel.org>
Date: Fri, 3 Apr 2026 17:25:43 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ynA85H56LqOAS6WS25a1a2ZJnLP-3iM2A5fL5JoohPog@mail.gmail.com>
X-Gm-Features: AQROBzBqeKpmV9nPNwHwPLXAMT7Ro5sEV8nFj07A_4sJczJQF-xsX0bMlUjBiU0
Message-ID: <CAGsJ_4ynA85H56LqOAS6WS25a1a2ZJnLP-3iM2A5fL5JoohPog@mail.gmail.com>
Subject: Re: [PATCH v3 06/14] mm/mglru: use a smaller batch for reclaim
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: D729320003
X-Stat-Signature: heapyuh6fs94ykeig4hwcqnj8fs9xj4g
X-Rspamd-Server: rspam06
X-HE-Tag: 1775208356-697939
X-HE-Meta: U2FsdGVkX19Z7Z/IKQ45HKy4rF3timT1AxzuWVk9LAQ3862w0wWRFXhMT4SSIBkHxWQPXPNudOuWvZO8eoS/zCZmNGZESD4sPjIAy4xbs4B8lIIIxWC3NPLFyR7fZPkI8u6xTwnmnVuu6hqnNmVzKxh+eLecv9Tw5+I+irz2bn93bV5teZw+wrVM1Dw0M+Pzji7L93UBCce5q68UdDAdV3LAwn2zZVbiAbvHMsbRnvru3pknZKhpQwmahTWOS7nfiBi9LfR0qst2/vLZQOPobLwOCO5DhzTov4M58GpjqITYyqTB3lkLb24kHsIZjapqkOjFF7tOElMBZ8a5AyXp1u9ImVLZN6kGhE4jkWmIX6kseP4V8m0xIorjmQjIFGwzfUyb/xlcQhLPHMePD+GqZ8TPv3qRY5+XN5Cz+Xa4IKR+AdTWsHpsXDEwXoW80DNBeQh+v2FC9xG3akaCqUmSm5hLzt8ntzRevC+8GjLe05qmjdyvGdG6O2xysPqJvBpCJ0ZQ4rGhkE/2LHBiQ9m0ex66YqFYtWVbkZDDnDyFDOAG8EuDaCL/Rw/pBcsUC3ZimO7+B1oqlpfVMtuFF7kqtZ+pnXYG7nOCq3FloZDSfM1RaI79f4BMBCSpyo0MtIx/dlT7Mlsm5xwgLAeG7ewkkTEk1ONd/XHDeUY6ENiaW5v7Vvj4QX+9CLrLoTUid6HaFPieGrQn2doAhfpn+R/n07zMBhEI/DgRRKuXPL2S4a3f3VlBfwl+5MhRTHqo/6GCYFJlLfrabmahBfF5fbzDUN5BTeuJcDsysL5j6Cr62GrGNWT6NANIASzna7y62mx0syRIPhiHnD5WVaa6pNfKlyMFcP1VEkQg4JvqkwnjqCiotvF7KghTSTjAJfHIyhq9HdK/cpRs9toDCc3G9ysqI+gH5FpoVPC4N+8NMDoXI0farQVM+IwDapGfjg8deaVk3CcVgGkveGRdJ8F7vNN
 KuUsasKm
 b3zW6JOxGPMoUEi0IcqYpsycI+m4ZMwi6G6P8+7aiqIpvrwGXKh2FuXhBTjdxt3u4Zp9/phUq0YzRRVGqk4pz4RKKFmduT270Q8hqNGmTXKq9nihaMGAxkMCpIa773Uh3rkxEbcLpwTaRK+qWmcnFRfzzXvCykmcrmGOyJ9adJ14Opn36UUrQf8ncMxG33XUTxPH6GxaPLt7sBY9rZNuK0WS/FEeAv2mMqgeDMeXZUZ/4lCFYzqyWcnydeEHTU9PGLz+i3nEJPtEu66oi5PV8KCq0z+D4T6wJC71njtG+t/YBuklVUJ41y0TPQcIkRgLH8vn6AO2wjc8z43ffAWMnvvjYwzfcVLais6aE9Q1nyWtZPgpRdKf+zFqQG9bIez8Co/IsA8ljezCTclhnENumQJtoT7D7MgTQdRQ7YUtdQb2UnIUY4vcjYHiPv8RNeyB048MYHuz0XFUTYRZme0BwkZPxPDiTleIfwrpSc/KmK5ecDKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 3, 2026 at 5:09=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Fri, Apr 03, 2026 at 03:50:37PM +0800, Barry Song wrote:
> > On Fri, Apr 3, 2026 at 2:53=E2=80=AFAM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > With a fixed number to reclaim calculated at the beginning, making ea=
ch
> > > following step smaller should reduce the lock contention and avoid
> > > over-aggressive reclaim of folios, as it will abort earlier when the
> > > number of folios to be reclaimed is reached.
> > >
> > > Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> > > Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
> > > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> > >  mm/vmscan.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 643f9fc10214..9c28afb0219c 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -5008,7 +5008,7 @@ static bool try_to_shrink_lruvec(struct lruvec =
*lruvec, struct scan_control *sc)
> > >                         break;
> > >                 }
> > >
> > > -               nr_batch =3D min(nr_to_scan, MAX_LRU_BATCH);
> > > +               nr_batch =3D min(nr_to_scan, MIN_LRU_BATCH);
> >
> > I=E2=80=99m fine with the smaller batch size, but I wonder if
> > MIN_LRU_BATCH is too small.
>
> Thanks for the review, Barry!
>
> It's quite reasonable value I think, for comparison classical LRU's
> batch size is SWAP_CLUSTER_MAX (32), even smaller than
> MIN_LRU_BATCH (64).
>
> I ran many different benchmarks on this which can be found in
> V2 / V1's cover letter (it getting too long so I didn't include these
> results in V3 but I did retest). The new value looked good from large
> server to small VMs.
>
> It's also a much more reasonable value for batch throttling and dirty
> writeback IMO.
>
> >
> > Just curious if we are calling get_nr_to_scan() more frequently
> > before we can abort the while (true) loop if reclamation
> > is not making good progress.
> >
> > Assume get_nr_to_scan() also has a cost. Not sure if a
> > value between MIN_LRU_BATCH and MAX_LRU_BATCH
> > would be better.
>
> We are calling that less frequently actually, in a previous
> commit it was moved out of the loop to act like a budget
> control. That's also where using a smaller batch start
> to makes more sense.

Sorry, I missed your earlier change of moving get_nr_to_scan()
out of the loop[1]. It makes a lot of sense to me now.

It seems easier to review if moving it out and decreasing the batch
size are put in the same patch. Anyway, I understand the story now,
thanks!

[1] https://lore.kernel.org/linux-mm/20260403-mglru-reclaim-v3-4-a285efd6ff=
91@tencent.com/

>
> The overhead of other function calls also seems trivial.
>
> I also wonder if we can unify or remove some
> SWAP_CLUSTER_MAX usage, that value might be no longer
> suitable in many places.

