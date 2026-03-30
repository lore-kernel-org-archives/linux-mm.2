Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CCD41061B1A
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 18:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA94F6B0088; Mon, 30 Mar 2026 14:59:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D593E6B0096; Mon, 30 Mar 2026 14:59:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C48036B0098; Mon, 30 Mar 2026 14:59:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AF3AD6B0088
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:59:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74B06C20E0
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:59:19 +0000 (UTC)
X-FDA: 84603642438.25.EB3785D
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id 74435C0005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:59:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pAVVGSpZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774897157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Py8h5KWNDwvvZqpmJ1HkCrEJBDna/rcCea6Zwo0ThLA=;
	b=tUrUhEPpiaR0lYt7nt6fe8UxAkRqn0bKRs8xfGREM+N5XXGA9P2hn4u8TOBi4p3zmA2jtF
	6G6zWsoE6KWr66ohTED+Ta9tXe0WEhnaTCK+flIdMiQW8jqh2Iq57yLRTqg7ICraGrx+s9
	JML/D+O2+Nhs9YX35+bqEXvRJVen4fw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774897157; a=rsa-sha256;
	cv=pass;
	b=kDpyrKQdKUBtyWYRGT5LE8JZ1PSyTzYieBbRBvD+GRBTS5eSrT6CnxDVgGA3KR7YXVD5fG
	C9cyVR3clRRuJo919AhAR48twalgxv88+uTuNYKugpLqta7VGKgidjenaewHI4xKl6f46A
	Mxmb7aecTLFTKhXjoudtxTmgyc89TIw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pAVVGSpZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2c5b3d8eab1so305705eec.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:59:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774897156; cv=none;
        d=google.com; s=arc-20240605;
        b=hn76k4faCZnDP7K9WzB6JyJuen30+cXTb039mRWirkGm8OS9KEWCGP+0sLePAG5MVN
         /KH1ipqL8DTDG7mdRcR7b0hnc9asZj2fQzQq6rDeTp9dpvv8r/7iI7ASm9/AjKjRCZuk
         8eiDzASJu9oRZLzud8QSxq8cTlcoX9NB1Avwjr99ptkmWP/DujM5wO4aFmtTdIv889pV
         BvGrfFHCgT0oMirC4OXchxSZgYd/b14UH7Yige/dIUm4Vad3yjh+UOkfqBrsKlgDFnHx
         H/tmEeS8qY213CiyWsZuyj4gdLXi/STweOr81ZieCy6gKz63WRS+dJDd6B+6cWty26ia
         1ZXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Py8h5KWNDwvvZqpmJ1HkCrEJBDna/rcCea6Zwo0ThLA=;
        fh=yb4x4T0VHVpkc+48tZUxw5BSRM6jIEZQ4V0RoATCqjQ=;
        b=g+9V0CcvItJ7EfGN2V0a9r20tHpMRbOH9+wXpiAFOaIvwr5+yvMHpVrxsOc1VZ8yQB
         kTmpDcdXZbVX7D3YEz7K5719n6alo5VsOarACU/c1Nc8ZYKBw3c4DEwTG/1DSo2UEsWh
         5LZ7vvyJXlnS/96QQooaLGX7e2RI8UabujBz4hMBFCPDZ8t+oD/o1EyAmV2OtmAOiEdU
         GrYxNRXqhgnpSjX5zy1+ewT2VwHtaHmWnQETyglXSRKxogXAGeafF509w2JAjwF+FbFY
         Slf+OjZQgyM31yXNqcVt7GjVMuSjkCor4q6BoVtL/8bU9e6O4MQr31CDdj1E9ORp8ySE
         e5Pg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774897156; x=1775501956; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Py8h5KWNDwvvZqpmJ1HkCrEJBDna/rcCea6Zwo0ThLA=;
        b=pAVVGSpZIloDyr4nPfV/+n9v+6+MHH3RWWQYuQTDXFIBNUpgh/mkIEpJ+9RAHFR3vu
         BSdhI4EHqYuaglMk5rylTbATN3+8tvi7BNt6n9deFrR0QDrpGsRggHR6MW8Rq9uvF6SS
         Un+Gp87GzYV/3BUtRKQdjOnVhPpAt4C6GdnLmB8jxA/6QKk6bBm0sWRBqdFihRcn8z8F
         DGRAZvrsZ6ah8YjOmBnDcxzXtywbwbjtZYAVEeghJOn2zJ08PREe2HJsrWhpDDKJTfEl
         Tuj1h6uILxQgw3Qw27mYnGt3K/YIfFMPs39kaX3sI5UxSuzhPL9i8rXj7JneRZuOCOG/
         Dmbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774897156; x=1775501956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Py8h5KWNDwvvZqpmJ1HkCrEJBDna/rcCea6Zwo0ThLA=;
        b=i7e2y1h5v25CRxy02h5ld3MWxwM+6YZjSCpelUk3b5LVeNzp/f06PIqN0ei2zcmOGx
         f10C2X37iEZ2MsXZhzjXV52K2vcnTlFWlhWSYoyQTqQkPpRvDSf5+2bxyMwtwUpvhjm1
         Q+55YuUmSMyyUa5doNJLQ7iW5ClZkptywRGUkgz6imeEw80R7NwNw9fqTPvcAaKRwzdN
         FE7J2PQBqmu+4ZV1mfrijf1JugUv9HvNJa/62oWeE+P+AxjpHfO3+SuGbSo3Bf+ngudB
         wEcdLsOFKmDzOHkzk7De7WMGsFaNOp9gir/fn6jqFbuJo/gaO1jjEDKqH5ns7UmpsByX
         kw9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXxpPbng58avOmaoYqL1y7MM97Gy+6QttOyYFK66KBi1pZW7nlzOQCy7JVY9OnWblisOmviRMMxzw==@kvack.org
X-Gm-Message-State: AOJu0Yzty4S2DRjPtfgEMm3i3r4zxiE0xIuQGU5mQwizIeMX83pVArMO
	0YTABFMUdFA01wwoOPcWFsiVfS8azy/g6F3JPt0fDNTbMpdgG+G3jmAhOhc6o3anaktxDUBJ6TV
	UGVcq/EWDs7cSvUK7DVuVZyecGoFRU6ipx0VWI28=
X-Gm-Gg: ATEYQzwnrt8Kt5KXxyy/0btSiVJ9qxbzX7xWR0+Wn2iIwjytI2xo92QV6iV0Hnsjng0
	eyM6fsJ4VlBdVcmu4X3vyrmmZm5xAf4uqUJOgART8jiTpi9B6cVaAK+8WpDRUCTp37Ns4ryCfD6
	bdUxe+flBShDuNV8VUJUhfPgNYEuon/EGIVvC2TTkaaxUNKl1amrTLF0LSdTAHZrdn/uqhVxH2e
	cs57OmrR2+il1lDUJEycRSvZ13t7xOh+Q58ywzQYugF5OyPsKuvyvRUlvbRGZgY0NOfmJIrbgNB
	dRDKKd++CXgOc/hzrCTOXQM6n7w3TZfLbBF1TOBd
X-Received: by 2002:a05:7300:5b89:b0:2c1:5b21:ddd6 with SMTP id
 5a478bee46e88-2c185e55550mr7788422eec.17.1774897156074; Mon, 30 Mar 2026
 11:59:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
 <20260317014802.27591-3-kanchanapsridhar2026@gmail.com> <20260326192351.7fc8c27d87c60ab5f7de5395@linux-foundation.org>
 <CACpmpofW2hcmQ5srg=a_WT2fXNhvY0pp20rjxxL=n0jGGUEi2Q@mail.gmail.com>
 <CAO9r8zMSnRq02b68Tjf_yi+_Wg6TBgyM53gaxmfbXhXJ59Om6Q@mail.gmail.com>
 <20260330115141.997e29f96223da1e22c0f375@linux-foundation.org> <CAO9r8zNRcSBdBthR8Mk929pT2z_Ew_vc8_nLJns-2FygSX630w@mail.gmail.com>
In-Reply-To: <CAO9r8zNRcSBdBthR8Mk929pT2z_Ew_vc8_nLJns-2FygSX630w@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Mon, 30 Mar 2026 11:59:04 -0700
X-Gm-Features: AQROBzDO1REgxHagvNNTwyiCie8jqnQ5mT419DweEok8hdbdWPUcMjJVzXJ2EMo
Message-ID: <CACpmpodFvA_DMmXBmgZfE4A=VnH3+0rVfmAr2qKP8o738qafbQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 74435C0005
X-Stat-Signature: w3yt6146ahwi47sz76jzswaqaycoqqu3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774897157-446805
X-HE-Meta: U2FsdGVkX1/drwFoDZV2WBkDg7YMwtgTw3VYPk08dFAXv8J61KQ8X4yD7hv/l/KawWy/kkWXkF3DC12bdsXzfZcjM2Igz81/9fL10z3TvJJ+9tC25997U6xZ3BvOSWTILop5N/vQBPefeVxOx129IkyO+i+xQushLNoBlhlvWVkBmtYqfkk4a4a8fBvmggg4CMIc15Lb98APry0JEYwXNaXu0XsnMSbN5n1YqSwdy6AFzYcpHFVj0cNpFuEpY5lgSUMjO2kPFyW8vXWph6h3RJQGh94KcTJf80vuQ9FSkh/6zsnAro9f+KnbO+8Uwn1jZHttuiCuMTjqadUiNlJVVW9/UJ/ktAIkQiBGnzRAlAooRyM0KJk7Dz+f8mOPfanZIC+9XD1vewYjkvGPJOOjkoRvHFb5brnirFynWgii3cet8OUfB8lORV5+wC1MCQHJ8j3R8e/tuG7c7myMpa5JNpuskngCg/njEjb2mc+D5Jd6WDPp+u8ugFwsm2YMwjWp7d4u+HVgIN9YxpKDHBf5cGJGIUKZlMM4KrgAewePivgBMat9AqxyojiFwix+YsPCiEiJJHhiTX/1qZCCYX4hdLllUim/CF1ptmdlduDGWipRWaV4zh+iOLJ+WeNYnaTg+LDzhxSXk+NY/3u+N9DrKgvvuRnD2UDyPu18zrXc1kegwEcihoKKDFK7JAcS/bMPu7T5b8VO5Vxsr/2QrCVEWpqZWEZDIOr7wMKQEzW9E8d51rZPY9PCjleuoubeUTg1hTcgSxR+XpmqLGZ49TYTbAzGAhHTtjtbaDlh8GiHWwQg6wy5d6UIDDbvrOhN72BqkyNpBg+02BQy7Iv/QETHlaYqXPzeifLj07XoAqjE42B+dwTvkq3SbrtWnfFu9V/J2ZDQG0fsw9F3eAyb24yPs8wXH0KYA+1kAeGVEmFm2oSKrw+kjW5Svx2bJpz1sRIuptfXQb00RKezPlneyqT
 BaCawTnr
 f8iEqK31+Da7an8lvwInRFuUmfIJWRpLOxK0YZz706I67n58xcttioCc1SXTPrVXNebpKBOfIfxm5JDU36Yzs5zUzJeqWW2wjRe3ZNbI2gb8lTIKd9YyLJof6thjMAJJ8GJkW6sQSuSKZ5/byEat/gk9Wz0RPK4WnL2T5HWLGL9m1ZW4MZtKc9CIQ1rBHAdAyP8POAkxE5pR7EmbVBrpX4jgAsZebQpUMPZld+U0Wemy9betD3NC7F+z/BM9FXWN0LAf6xHCcSxnAhyccAryiRTkYG+PRe0jqrgFoyDoC39J1keTJabY25OxDXbDRjEEKKKQFRe5K1Fu0X4Dk4ay+eVI+HMWiWEmPw/X+sKrYYKvUzAWGUP4zzqtbWqtmNyVDA13nMirUwg5diP8e69Z9rOIb5m6BuRdrLi/MFhjgA0w2wyTgeSjcwJ4QQzkLxnJOWNgV7157l3FBOofQ6rGIYebvV0NIfhbuw/X+LZ+iEesUDfxfaCNv5S1aERSY8qpjZ7ccl812EKAobCIg74DxZ/BxFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 11:52=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Mon, Mar 30, 2026 at 11:51=E2=80=AFAM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > On Mon, 30 Mar 2026 11:32:07 -0700 Yosry Ahmed <yosry@kernel.org> wrote=
:
> >
> > > The patch looks good to me, feel free to add:
> > >
> > > Acked-by: Yosry Ahmed <yosry@kernel.org>
> >
> > Thanks.
> >
> > > That being said, it might be a good idea to resend the patches (new
> > > version for rebase + Ack?) to get Sashiko to take a look,
> >
> > Yes please.
> >
> > > hopefully it will be able to apply/review the patches this time.
> >
> > I expect so, but I don't understand why Sashiko is having trouble with
> > this.
>
> I think it was a transient failure.

Thanks Yosry and Andrew! Although, when I get the latest mm-unstable,
it already has the v2 patches :)
Should I still send a v3, with just the Acked-by added to patch 2?

Thanks,
Kanchana

