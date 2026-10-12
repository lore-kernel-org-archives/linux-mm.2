Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CC38CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 14:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE6006B0088; Mon, 12 Oct 2026 10:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBD496B008A; Mon, 12 Oct 2026 10:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DACBC6B008C; Mon, 12 Oct 2026 10:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3CF76B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:56:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D949120A9D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:56:34 +0000 (UTC)
X-FDA: 85314275508.08.7D935E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3FCB3120005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:56:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YEyrT119;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791816992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zzV1H8VuC6aKyIL6Nu1e4YLM0TUxzj/r7iNtBdypT/Q=;
	b=I/nbm9GUxYMM0upQs+HAUwQbu8th0et6cR55oN8fyOVDsRFwHj4ioG0m8sYxEcTuTguKJp
	sngthxM3wtdMduSJ/TF53t3wgOSagcS5tBdXTAPJyxE3TDSQfVbMtgw6bf9Ylto408XKR4
	lWpNyoI4KPLtujFB3/LHID/PTry6dKU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YEyrT119;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791816992;
	b=3obSYwIhpBP4YyI7z7oJS415ZXYsrMLFQSUj9zmo6n0svM2jiFkoQbww5R12Joi6v+4e1v
	jcAs3zQH7xZ7dt6xfywlVYTeBNAOlAnWxEFSFoix30VCAgJ9ToNHOxtC+nCJzuGRc0pTMv
	ouhaNOiaYTcnrU70zKGEbTQ7jNN8HVo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4880043F78
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2661F008AB
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791816991;
	bh=zzV1H8VuC6aKyIL6Nu1e4YLM0TUxzj/r7iNtBdypT/Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YEyrT119wH78rbXg8r9XKN58cwZQSmO2C3utNzdkqvlSzzwWhdBzLdv6w4y/qS+gU
	 fR1+uiWgJNUZEdKwKG/7TiRTpodHqZlQvT8/bzBH5hUVmiW14731eHJuncEk+Vmd3E
	 LZlKJsogxJjCfoJcIjCvhIOjpqafPFuuSCijt5uPMNFmHVyOn4lw8uIK/KQaz3TsWV
	 kUeEGfpnX6S2YrV/ONtgrgk30ZE6d4i7oJdqcpsR7yGLbrS/HEMK4OuHyNUFsVjsB7
	 8EbiS3fag2pgn1M9HrKa0CoUFlXwbXdHQZRJuf4Yerhgk+5jzKKQCzL4fXNtBen3fV
	 h8CuGI9brsQtA==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93a40a9a01aso892297985a.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:56:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwfrIIxxaDPBSvF/jpt8k7ngt/ABwfxMoyeR5Z01PjraGzkUJuIc2SH7ZT1qXOcIVuLxQ7na0Ccww==@kvack.org
X-Gm-Message-State: AFq9FYJY+0sdKyrirKK/f/h5Fe7jrAygdQWWVIkCg8DiKbl9p1knLQ9Y
	g5KeJ/ASfJkpPkUgkKM1l/Mh3p2pDiHNjJVAA6NQYaBpXMSdoD/qT1d0vFP3juEYQ+X37vT0sEd
	XEbBvuGi9e9u+MkgIlT+RgKNJaydhP3k=
X-Received: by 2002:a05:620a:408d:b0:93e:5508:24f8 with SMTP id
 af79cd13be357-93eb9677234mr1673656885a.32.1791816990380; Mon, 12 Oct 2026
 07:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <20261007153915.53429-1-alex@ghiti.fr> <CAGsJ_4xyzgUH4uhKqpD7PTVuOzdsAkYgowsyn5iT1LHWiaYqqw@mail.gmail.com>
 <CAEmasaWQm6DPqAhmW_z=kuR+3LDWJ=h+yM0hAs+ryNoFQd6qmg@mail.gmail.com>
 <CAEmasaXa2pB_Jm_VgBZAWQwu1p75yUSY2=dr0Opt5okLgWk-YQ@mail.gmail.com>
 <CAGsJ_4xw+CLzrazOFxnvJCbvG0qoauEuFGR6OdtT3x78ef95pA@mail.gmail.com> <CAKEwX=NrMD1jpU=Kfh367mGArw_ju_8ku=Rh_v8TiLumx3+S3g@mail.gmail.com>
In-Reply-To: <CAKEwX=NrMD1jpU=Kfh367mGArw_ju_8ku=Rh_v8TiLumx3+S3g@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 12 Oct 2026 22:56:08 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wck1jiahYPHRT+n4YsjK+MH79Fwcq9NeJQB__AnUESiQ@mail.gmail.com>
X-Gm-Features: AclHuK9l5YlJmbsyV-N-AoDzMMoah_wy-giXfPgwPy_mojUYu5-uhB03Mnu4R_Y
Message-ID: <CAGsJ_4wck1jiahYPHRT+n4YsjK+MH79Fwcq9NeJQB__AnUESiQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm: bypass swap readahead for zswap
To: Nhat Pham <nphamcs@gmail.com>
Cc: Alexandre Ghiti <alexghiti@meta.com>, Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, chengming.zhou@linux.dev, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, kasong@tencent.com, 
	ryncsn@gmail.com, chrisl@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3FCB3120005
X-Rspam-User: 
X-Stat-Signature: 8u951i1fiwcr3s6h96cski3iotozngzn
X-HE-Tag: 1791816992-910620
X-HE-Meta: U2FsdGVkX1/qf5i/YxhTm53hgKz50KvOGl3jxvQkr1vxShFk3Ivum/R0A0VoEDhX0OLILcI1hS6W4ZWbAa6OXQvy+rldHTrD4Fw4qzxUWnkAwHwn/5Wc7twOKOC2x17lLYoLAb3GqkYNmbfZU7v9AfylXMxk6JpHRDz+5GwZWj7hZr/S3qNwZoV9dCiJyS5V+jtEe+0xqrOG2tpZGadrVoDASEppn0NFcD4b4+l+TMbdysoEIVjZU6A4PTbGZ0PG7qLO746SC/KZ1X9UJG67lDVjpnQYBByb8TkvcdwBdAkwG8bviESgr7fpynS17TyeOrDumJePmlzyPWFMDQn0ddV1HBJuLzYBLXhAdLlUlmwQQnOuJio6AbaGOfk+2WFP+G1GJLMn+mgNp1YkoA6hLy2TTeNBjFibibD/49RKsK1FQ6h0LNHbH7Ld2EZ8CLd3O8sQcppSI2YOzz50HoQ9Jjmf40c1fb/hpzuAw7UGp4Sr/0mZpDutQNW/g+zR3rxKX1OgfdZa0xpQEyOgbKVr71ubf5QpqmUIfB7m+dRa3T/+RLwttrrqEa3W25YE1pli3lmOswiMOk41ygBc7pAgRUo6Di21kvpPPO+ROxKBsaunCifRVJ3UyTuFl/2oaDlUvV61a7bCOcvYNQRp/b9woGpDNcX4I2WnAsymOjUHRGPya69/8LCUwHGQ16oSreCPOowqBNzYex4cPwGgSb0XcR8uT7XcP4JSEP3GJZfKOIi5drMtEqonmN3d5x6fxy5hVgRs6s5QTYKvAA9nHpY6HczERlHNYEgv5ZYDQ674ZTuFjxsRUT6PBOFn2HJ1D5w5VHzD+oYu9zQPtKoZ7A1nRjKiLKNHRsdJD14s5KQ3T/sEsNCXkMiCiJD49k++HS5TjJyQleI0ya5VD0OZvX/HmwsBQ2LIErp7BfnjH4LrRp7aUOuPv9AWlK5gGsVXcDHJ3e9G0eP1U7vlJoIfVTB
 UF62iRW0
 jSjwT0Up2Il/jKP5mlzbZJ1QnG6Kw6AGpwj91CTIblybfmxA7bScePWYepuEoRW3TMCsTfxAO1HhQn8mivAyK9P+PSykm35fNB+Wk22nOHfH7ep7cnM7tvBpgsrD7QkaH2Ngltasnt8wvKoaZjtrJCVorVP32pDIvNDZ0hxBypWzncwzXAtYoBgPwCZA50fMCo4D1oSiSu4Mar77D9J81/xrRBRwspSDSilPkzhEVTkJ3HtvG7bWawIHiLDrvAFQJmG+ebw+BCGpCNbosholIRWPybYe67KUZdc21wcDtlevoZYNIgHjc3ZHzM9w2cpigQROhW4UNplTV230=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 10:21=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Mon, Oct 12, 2026 at 1:01=E2=80=AFAM Barry Song <baohua@kernel.org> wr=
ote:
> >
> >
> > Thanks! This seems to be a strong indication that setting
> > `page-cluster =3D 0` can also resolve your problem, even without your
> > patch. :-)
>
> If every tenants use zswap, yes. But we have tenants with different
> kinds of swap backend in the same host (some using compressed
> synchronous swap backend, some async IO swap backend).
>
> >
> > But I'm still glad to see your auto-tuning patch!
>
> I think we need some smarter readahead work, for sure. I'm just not
> quite sure what it'd look like in the end, though.
>
> Doing synchronous readahead work in page fault feels wrong. I chatted
> very briefly with Kairui about this. Kairui is trying to come up with
> smarter readahead heuristics, but I don't know - even if it's 100%
> hitrate, we're concentrating work of multiple pagefaults into a single
> pagefault. That sounds off to me?
>
> Crazy idea time - what if instead of skipping readahead for
> zswap/zram, we offload it to asynchronous worker (only synchronously
> loading the target page)? That'll cancel out the latency issue at
> least...?

I am quite sure I tried this 3 or 4 months ago, and the
performance was very poor. The problem is that async wake-up
latency is highly unpredictable. For example, do_swap_page()
can complete all the mapping and decompression work in less
than 10 us. However, if we queue the work to an async thread,
its wake-up latency alone could be much longer than 10 us.

Based on my results, async zram readahead only works if we have
hardware queues rather than relying on async threads.

Best Regards
Barry

