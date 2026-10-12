Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 931E3CA9EDB
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 04:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 180DE6B0088; Mon, 12 Oct 2026 00:16:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131CE6B008A; Mon, 12 Oct 2026 00:16:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 020376B008C; Mon, 12 Oct 2026 00:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0D3D6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 00:16:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 54E72140977
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:16:10 +0000 (UTC)
X-FDA: 85312661700.16.D9FD3D0
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6569C40008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:16:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bLlORlKT;
	spf=pass (imf12.hostedemail.com: domain of kanishkasolanki456s@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=kanishkasolanki456s@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791778568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FmrFlC4CymhdGvHPqaBIxxVKsVUaCyNEYowNbJO6Wtg=;
	b=NBf4qRPILWKe0m5ROeR2T9yDohrg158B16T6HV5MLqqk8KyFZYJQOs+ommo6355A5CZ98r
	6Gd8st54R9T1/Pginv3pLi9v4mYsafnSqxgQ0n9zGResPqUNFbs/RZk2RzWkh+ZZ7jSnqY
	/C4Yl3wwtEr3RkwlYy2wDbCeKKsswgs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791778568;
	b=27T3n3jJguOe6Sv+1YlOjVBGLqN6epORlK0MlHuSOXZZsSD3b8YC+uTQ+/zNyltiuu8rm+
	VpLaSZa+JY8ombf1oknzBUTNAJHY8xhUSBo1uS8oMPw3Gus9u5mEpvb3Ml4S2bfy75p8ej
	+Uth8znId7zD11O0zlIR5MNRUa7Mxhs=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bLlORlKT;
	spf=pass (imf12.hostedemail.com: domain of kanishkasolanki456s@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=kanishkasolanki456s@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8ace0741488so9821627b3.3
        for <linux-mm@kvack.org>; Sun, 11 Oct 2026 21:16:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791778567; cv=none;
        d=google.com; s=arc-20260327;
        b=eCXLXDgGTlZuOf0RlMbiluHGhLfJyjCqd4mJ2XHfQAHigDGttmM/v9HVbaxVeecZ/H
         LdVDHeJ+IfOtOgORfulZqTju9tlNSY+GkzTImtuty0hcDVCI/0PTMY7H5EeHUBPr6Ply
         ChH68KrJ8Ka8mwC+WgF7djXzzEv99vPbUmos0U4PUrrbg5p5uPOOPbwgLCTzWER96U+W
         NzQ47oPJRzb6X+/6BcSM/mvP7fW8HJtWcmSK0A8fuiMTnzRbfQmMkLKy6GSJZaYbRAyu
         LqhnIsvw5WG0wgTli3vIlsqnzNDhoThFIpE3No46A/wXwO3K5qmYaMNPjwPLS/aFyKde
         TNOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FmrFlC4CymhdGvHPqaBIxxVKsVUaCyNEYowNbJO6Wtg=;
        fh=TjrHhMj03upX0OhKXHc+qQN8kaJBBOZrnjh9OsP+Vck=;
        b=kil/qYzJjbJn5/1TgIGl5k/zUMCkJUwIu89gII2yGn2jsR+q/WI6OSTTBrv8wqvM85
         xc3QUWpRAG/RF2HrHD+3t7zWq/MDW+B0GAFj/XGUu3zEdvs+7OPZyZm9Bxa8NUSSZPfc
         BErIL7qiKS2SYXhK8LLHhWFuiow9ArXrb58O69B+qOYIeyrvUb3tXXxwwOJfURMyDdRu
         qQe0rf73hYzExpM/HWdR0BeOdY/kTD8FQiX2jrrUcW+dOv2lB9Ncrw02wOK0TzYZSY5B
         bmRPJwc+T5Zoyv7JmItluJw8paU84vJsJy7zXW6+w+UObCmH+8OdUZcsfTiAiTlEmhXu
         7vQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791778567; x=1792383367; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FmrFlC4CymhdGvHPqaBIxxVKsVUaCyNEYowNbJO6Wtg=;
        b=bLlORlKTMzG+/7fUpba6nhddskhu+pK/wPK6kb31Ec7/evBAKVAKyYTAlUlukX1o1L
         mj+k/dPcJ3jV8tvWx6HFpkV9E1AQqeND1TCnWdHHr4Y4hgDZ8Mwk0T7BCUtynRAhtmFd
         p+rqV5hRBcQP8aYr4FVxvkELgN0B+tKanTNczIG8MlVRoqp52GbH5y74Dnt0ZPBLWOLm
         GsYgEb+lYFbxq0dft+zFWujn3YZLJBvzgxqzce7ZBvcPdNT/VXcm12+603k9pa4q5eWR
         lSXkV49EqU+e22F3woYIlXpvPBY/VHcSZv3JS0yjLHojmkDK+TUsRWJ9ou2D/eRV9uFl
         j8kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791778567; x=1792383367;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FmrFlC4CymhdGvHPqaBIxxVKsVUaCyNEYowNbJO6Wtg=;
        b=Yj5Dnt9UEyatFzHqytyVkxfCy12gEitcGQ1E1c1at/7nrRPX8epDXBvPmcNTqMU6QU
         /EcWZa0Jp+EquZ2JYZhG710lSAazjNa1queNv9Tj8gAEKFikfYLuZjPe7LVSdeZlCIbn
         R5Yt4Qq/GK0CGSfYBSS7E/MT2eNk4hu4WpukgDfDUDPnTuFsQD4vp7SsL2YNbZ9GOgcg
         rc3/Tpy+6TP9tqhpfeKGSzaauOzOUDp6GO8ygf7WZ48nSCIQY1vCH/Nzd+KK9ZqkwwhC
         k1yM8jzIvzJXaZMwaQf/6/RgyebZeXGgfSwygzz8EF1WobXS5MDT2upqqAn4j3F/dZ7S
         6PEw==
X-Forwarded-Encrypted: i=1; AKwUvByZTsCiV9p8THRiB2XvOPw9d8EQ6SV7JRZasTMF/UDso5bWmD7c+JZRmfWoFXfar1ZLBVrqBCzz6Q==@kvack.org
X-Gm-Message-State: AFq9FYL3F1HrQ3kX1vh7L9M/OJqDJAkbxFrU+rVowolFM2dmIESGdI4k
	eCjATHOqFNe4K3EGi44Ygh1u1ivYqenum7pAV9wRQJHXriAWk47iJPfeysvY3MmM5dDWzo6xWvH
	Ub0BtZUzUWl3WqFzgPgfqnTxb180SwCY=
X-Gm-Gg: AYBFou3hZ2WhVnYtit6wMRRRzhHkem+ZnUdtyU2kvApmQSdgg04vkJ7k88R+18eaw55
	aq3VGi4dDf8lBZ4/ouvKSwL7MTHOSlXj3pfbtoiotkoRTqhz8J+kYFGTDS3vDOEFqYKjbBSrykQ
	y+B5s438DxSCIkDXedXWTe7xppJYqq3TqW9/M1HsmNAqxg0BaRIG4w8cf52LvtUw1sdK5B05U85
	3OtcL9vUW3P6QohkpmXMZOuMCkGvlhTSR2rn7KdWJGc8aNukGjewBpSVf5Nu7MuEaz4GkmbAtqa
	FxuzbJG5jq+OoIiNgQm6HMPTpsgC4NccGd7RT20lu5gWclKWVGWMS0WmefUTjQnXXLtOgfPtT+m
	/7maN3A2UFXBE
X-Received: by 2002:a05:690c:61c6:b0:8ab:3918:33c9 with SMTP id
 00721157ae682-8b07edfb3ebmr24808907b3.96.1791778567173; Sun, 11 Oct 2026
 21:16:07 -0700 (PDT)
MIME-Version: 1.0
References: <20261010093843.103169-1-kanishkasolanki456s@gmail.com> <DM14QKTSWM6K.YSJFASLMY53E@nvidia.com>
In-Reply-To: <DM14QKTSWM6K.YSJFASLMY53E@nvidia.com>
From: Kanishka Solanki <kanishkasolanki456s@gmail.com>
Date: Mon, 12 Oct 2026 09:45:55 +0530
X-Gm-Features: AclHuK-CkT6UlEdY9rvyIC5NaUw_85FFG0zYLy6H2r1vScvrdc1APxGJLTHTkV4
Message-ID: <CA+khhQvUULygvTwxEzQ5mae_saCRnk1GYXNWw+U99QpkpZ=1pQ@mail.gmail.com>
Subject: Re: [PATCH] mm/page_owner: make page_owner stack depth runtime configurable
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, 
	mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6569C40008
X-Stat-Signature: zmaxx86yw6wft3rzixedmcw1x3gkmt7y
X-HE-Tag: 1791778568-223612
X-HE-Meta: U2FsdGVkX1+u10dH5atRacEmGWQoVdC4/wSt5GpTQ8AUhC3GUU466LUYLwX1bWH2fUGOyEO2TwkHtQO+fL8MLKPQM36imznMYaWkLRzygKr+8W/gk8R4ASJkCeAWxk/0gAcw2p5KMxvw5wsalFW2meYAVgsb3nQlesE0a3C7V/akvW4TX1xEscDDBN12pqeNoIWIFwxF9etEu//X3RCY6FoqMzCGp3LTmCnb5dolQqDxfqr1pDjjotXnLGd9Ytmd8oxx5L6h42nS2Dx5kbKadsQSJvooS4mGvUR0qiamzIolp1Q4Me2UAMZiMnOsOkRnvFSE/+HUIvMtrNhjZLGWeSOMv1fO6P+iBpA6/ZmPpJzp2JyUlGaGWNF/5AEeW6YuFI4ewZSxj1H1DI9367jern79ipjOFXIwmFdH1LocJaIX8xXP68eJHWU35xITQo7EW/uZtggFwMKIx8HAkvhDyQiHLLBLTi7QPpbl1FeUwtWwS1rmonN8nIP/K7xhrbQSvAq+VBjbpqONqOoQimqXXbgvpqyv2tQi7HU+KdPiusMjsMnHDBQJ0Pan4ORQFrL9OHX9Lb8Mxc4cSRmzi7UgPZdJdCLhCrAdKcV+uHfxqzrGtGe1I3FJtHrBxZc8jl9UuDlWArR+7ZjsXAs65LYbSYHDcH4Ql/b4E3dUoXwNvnW0+jGivyqus0wIfFOpQB0wScN0XtrZhG3Mh4WUE3MS+tm9RWv4bpW21iI4+ZHy/mZNIHMf56HkQDCYjYCCeEM+mO6HGypJjPAz8XD+ybVV+YinE7n496wFdpKYj0xt2OE+2t3CHu6xVjB7mE0YMqDuAhpaYZPUncDxBAaswQKSZjlJV92ul5z36YnY1u8u/ihXhrM/MOa75ViOCxYGAsGa5Q8z3QEvOqeMZLjrXtbzqzy2Mromff2Q8z9E8gY26QwuQaFoxoA+oyupnoeKnG+MNcCBfpWA+Z0HdKFUHDz
 jIkgFusF
 gR2hfYtM+hnkyPOnV2iQVzIZoaSuvHagJlSnc8qrtb2zAE5Brd+qKirvaYY1k7tl87SMSoW1WdlD3eIj1Owm4BCUTXugJMS0PLvCoamaQTP7zoK3MXHAVyLIjuBPJ955s4v+dMxqzFOKRjeynClmkLMdVaz69K+oCJKc740jzeDRYpLJxsxUiCKpGDj4+V+UQAM5HgJyHE9qdV3Dnht0sDxOIlFVKTjLkgDZWpLV34b1MRBiPFB+RyL2GzFJDEsw2RFFtCEvlEjtnkXISC/BQFEGrxc//Ty/zjVq5b3v4pVO2e5oU7Zs2F/hESMdY5WlqDa/JDyaFafLm3ipI5MXHVUYPu8GPdLgwFcnMUfT/aVr6/t6JqwbYUBtKNXb98oXFiNLYfKce7H6FAEioD4P1lCG5i2IJfEe1RH/eMV/Wx8WQ7XCihquEyrYS1vrFWWC+8r8VSDKbutbJOnzfY/xhwdtgwXw2yADu+mi2BGKQIMg+W5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 5:12=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On Sat Oct 10, 2026 at 5:38 AM EDT, Kanishka Solanki wrote:
> > The stack depth for page_owner allocations was previously fixed at
> > PAGE_OWNER_STACK_DEPTH (16).
> >
> > Replace the fixed stack depth constant with a compile-time max ceiling
> > (PAGE_OWNER_STACK_DEPTH_MAX =3D 64) and expose a module parameter
> > 'stack_depth' via module_param_named. This allows users to configure
> > the stack recording depth between 1 and 64 at boot or runtime via sysfs=
,
> > while preventing unbounded stack usage.
>
> What is your motivation? If you see page owner stack gets cutoff due to
> insufficient depth, explain your use cases first.
>
> >
> > Signed-off-by: Kanishka <kanishkasolanki456s@gmail.com>
> > Signed-off-by: Kanishka Solanki <kanishkasolanki456s@gmail.com>
> > ---
> >  mm/page_owner.c | 15 ++++++++-------
> >  1 file changed, 8 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/page_owner.c b/mm/page_owner.c
> > index fbbda7ba914b..fcb584070f1d 100644
> > --- a/mm/page_owner.c
> > +++ b/mm/page_owner.c
> > @@ -15,11 +15,10 @@
> >
> >  #include "page_alloc.h"
> >
> > -/*
> > - * TODO: teach PAGE_OWNER_STACK_DEPTH (__dump_page_owner and save_stac=
k)
> > - * to use off stack temporal storage
> > - */
> > -#define PAGE_OWNER_STACK_DEPTH (16)
> > +#define PAGE_OWNER_STACK_DEPTH_MAX (64)
>
> This uses more stack. Do not do this.
>
> > +
> > +static unsigned int page_owner_stack_depth =3D 16;
> > +module_param_named(stack_depth, page_owner_stack_depth, uint, 0644);
> >
> >  struct page_owner {
> >       unsigned short order;
> > @@ -172,15 +171,17 @@ static inline struct page_owner *get_page_owner(s=
truct page_ext *page_ext)
> >
> >  static noinline depot_stack_handle_t save_stack(gfp_t flags)
> >  {
> > -     unsigned long entries[PAGE_OWNER_STACK_DEPTH];
> > +     unsigned long entries[PAGE_OWNER_STACK_DEPTH_MAX];
> >       depot_stack_handle_t handle;
> >       unsigned int nr_entries;
> > +     unsigned int max_entries;
> >
> >       if (current->in_page_owner)
> >               return dummy_handle;
> >
> >       set_current_in_page_owner();
> > -     nr_entries =3D stack_trace_save(entries, ARRAY_SIZE(entries), 2);
> > +     max_entries =3D min_t(unsigned int, page_owner_stack_depth, ARRAY=
_SIZE(entries));
> > +     nr_entries =3D stack_trace_save(entries, max_entries, 2);
> >       handle =3D stack_depot_save(entries, nr_entries, flags);
> >       if (!handle)
> >               handle =3D failure_handle;
>
>
>
>
> --
> Best Regards,
> Yan, Zi
>


Hi Zi,

Thank you for the feedback.

I misunderstood the original TODO comment in mm/page_owner.c:
/*
- TODO: teach PAGE_OWNER_STACK_DEPTH (__dump_page_owner and save_stack)
- to use off stack temporal storage
 */
You are right. I will drop this patch.


Thank you
Kanishka

