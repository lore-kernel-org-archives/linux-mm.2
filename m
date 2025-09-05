Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88E42CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 17:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD0BC8E000D; Fri,  5 Sep 2025 13:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81038E0001; Fri,  5 Sep 2025 13:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70478E000D; Fri,  5 Sep 2025 13:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B47DD8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:46:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44E8A117ABC
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:46:44 +0000 (UTC)
X-FDA: 83855926728.23.0195450
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id 594A220013
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:46:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mwd6rVRu;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.178 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757094402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bpSR1HTJo6nPim1htqd1MlTdSRYvLLWGux9NsjKArVA=;
	b=hCSL4HmyTJJeT2BkdXuRhXLsABQxJdY8opvB51wgclDuwCcP46XMsbecEgWdR5Uz0UNRhn
	SjaafnhUcWL6k8+9ht0hJSnwqTFO0d2VlOxl5RaB+/LstsUj8dL3exnSwqwttyHiLciEUO
	1t3/Rr6OAxvyIIYqqkKgqL+JbNceYsE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mwd6rVRu;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.178 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757094402; a=rsa-sha256;
	cv=none;
	b=DwC704NdpVDEIEYfa7/zPMKJnkNPo++/u6xPe54LGsK0etdPsQh7QnUfmWi+W2/+hR4CfQ
	HguP4eU6mKWwJzfyu+0ko33kqJ8XbbmR5cESfASxYWMlARNtm7DF7Qlwy6/vae1c207MGS
	s+643nXCHU+OEtI+pRjvoaXktA8BP3g=
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3f2b6e0b938so17944825ab.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 10:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757094401; x=1757699201; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bpSR1HTJo6nPim1htqd1MlTdSRYvLLWGux9NsjKArVA=;
        b=Mwd6rVRulhiresR9iKycQW8SZ/bbRkHI7CBORpmUSkW3GmcLPIbY7keivt7QP0QeLW
         ZGST1iz8e/OAhYByRhE1Qlqx1OPPf0i3LGPuwKrCtMkzysIDgBA9kUgPNE2hwRI4FpcD
         b1NiaVhkM1ht9GZj4oV5QVFXA3h4p4eTv4pnF7+lHprkxbqMjNE21DJ6jAWTfHglAAz8
         kramctkuEwBEZED3U356FxigtgI+p8jdjdS+ON4eHPoyMHgb0gJhalCSuahH49NPChoZ
         rXgzVxgAFRfclB8ielIiZ/IpVVls3f8z7pDVeEEotFrBN8xI0JzCcu8JjhpwUniRWfqt
         cCXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757094401; x=1757699201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bpSR1HTJo6nPim1htqd1MlTdSRYvLLWGux9NsjKArVA=;
        b=Z0Gyk19IS5N5wrMDCJGERyKzthqp6iMZFKqrmrfsgoBHPHjxK5d0PGRa+x4A2qbv/U
         a2B7j0ODTRxE2Wj3750D5yJDKEMHyncJ9xjfweCy40d73Gagf9/BZf9FAFUNi3DW3RS3
         OBVKq+4AnKNdfjnAOXsLWh91s2vkN73SSyhxs40CqnADpquUmK03j1IV/urL1IIzbf4w
         USMiUVtiaWskWoS2b06jpvjbBGkrWkN99TH+6jo8QWiBtjKfSdEUYLIfq8UzSeHI+soV
         7ywqwbU/5/FLWQ98wkIQh8q6hqSpu/sjbv3uYjp6Dn8Y/1fWS5TAJ+fAiSn2G8ZuP2ru
         lO4w==
X-Forwarded-Encrypted: i=1; AJvYcCWzK/OrBVi7MwPSrMATdCgyFXDdzQ3nGfmPXnlTniActYrp7iE8KOi2+HbmsE6nxIfGjJg43vlnHw==@kvack.org
X-Gm-Message-State: AOJu0YwAW8VA9Hf36PFdtbHL1cWLGtq2xh2yWHMBIK5UAYCpUY+wmj9i
	MABP/jn/mEoqsJVzAwK/OX5By1Ph/mhYoTu/d0+YDLYXZ+Jh+qfPeoJHo32spPK3JVPymVcMKrf
	OoMm5kuTBhi8u4C1HiF2PQir9ro+im/M=
X-Gm-Gg: ASbGncvS8/sU3hax5V0PyjxjYSlNtJCVwO1q86bY4mKYRoxu1w+ZdtpqcvP3VR+eSpu
	LUpDhPeRAry6BwSBtanyXhx8HFt35OAlpHEoJNWz06qNuTDjqXmGlCkLn07+M76b9GsUwI1xt9/
	8TGcF+GTiaUs4RRFWHq1YMDR78bUpaibQ8hjtcPIixl0zsQnp0YD59wrlK591Q0gntg9x5VKkSl
	bwh
X-Google-Smtp-Source: AGHT+IFk5Xz55Lrwaeg30ggic9C4Fnk5btiTmEEBZkVEbj3Gn6+4gdw2Oshvs2RpuY9fAkh+7wPvJ0+It5jjM+pHCSo=
X-Received: by 2002:a05:6e02:1d98:b0:3f6:6ad8:6fbe with SMTP id
 e9e14a558f8ab-3f66ad871c0mr88436955ab.27.1757094401258; Fri, 05 Sep 2025
 10:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250902-show_mem_zspages-v2-1-545daaa8b410@igalia.com> <paef7bzotb4runl4sjlcfesano36cc2bflb7uqe5mil3chnpgn@axng3yfe33w6>
In-Reply-To: <paef7bzotb4runl4sjlcfesano36cc2bflb7uqe5mil3chnpgn@axng3yfe33w6>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 5 Sep 2025 10:46:29 -0700
X-Gm-Features: Ac12FXzSy6TF-VgA3w4rWead4D6W38SYTeqqM6XV4n8p8HfQa0Ka1hCs1_kico8
Message-ID: <CAKEwX=NE3ngvFnyHQTAofX3M08JkeZZcfaKi_mkOUuiB4zh6Dg@mail.gmail.com>
Subject: Re: [PATCH v2] mm: show_mem: show number of zspages in show_free_areas
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Minchan Kim <minchan@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, SeongJae Park <sj@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-dev@igalia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: m7f3ozkby5kodrxwhex716u37eyubgoz
X-Rspam-User: 
X-Rspamd-Queue-Id: 594A220013
X-Rspamd-Server: rspam01
X-HE-Tag: 1757094402-678816
X-HE-Meta: U2FsdGVkX19nD1dm62jNpLToPunLjs7r95fgmh5tFqiG4sFS/aEPtGMHTfKkl3CYZXjci0/V+lRXDLHUQTdZ86T+odcwP51uFQGlT8zk9nU0Ox9aVsVx8BeuXN0/8eSA6p8k2kDvYO6bvuaYRxWQNwEJdYusRHDEVbDe0tndHv6xaB3n9vvy/NojUWi0pqwOAeBbiIxBz5GTr5iJxLZ64OzoVBAKc3IrPwkYy3LLgG4jfH834dq4Qpx+ROnRGpcEzj8P3AdP3f+zTQckC+N3RtqwofrV0kjodyGoLmd1sgeRTq7Kk9f0/5uwRc0/5hnJhs3T+Dib201hUWNVK2nDtsKINZJqycWsnEM0U64H98Bz/rp28uQ3BUoNUG/prQlUC/MDR/Z6uzlDQ2XuK4C5+V+3GI9zUuW442r+zkPJg11/VLsVlUrrIcjqprfThDDrYcXia+MRtM0qL4cUm6GS4TZcvRDn2CUE2mKMb+UP9Yu2hSaZ+T3QZXSzJI+EqYk9ZE43KKO0nVSrj4D0BJJxLq1OuYy25IMpUZFE5+8qVHkXZohV435A1ZoVkK7+16L65RvK3k30wW5vOnW8uJuNLaJ554A30XPPFR8XUrETJtZ94YpOeSi/J0CvF/kUIdABeWpyLMI1lzFojTiGaBTTbM8mWYsQohX8z0KfjewTHY7iSKFvwuy43N3vqvbDijL4LARAx48xVwQfxMA+ieNLpwlQrSTACiG/fdnt2bjzz9D+m5ERXWT9Kddp62f12pjhMibKeXNS5AHaPNXGIzqrcT0P+gwHIoMijDjDHQTHFVi1RNgEGisV7gx9MOSaWy6HQ/OGTBA75atmBUvNrGiXABI8tFEDoLVz421BMYmBrbOXfpNbDh+CWhhX2J/TvUfz8yQL4+LKCCQ25MgL3/icyDaNzFuL9QBi4QjjbOnqJ2NgwrL8wG0LiHY7Xv7bD9s/p9mWhs0OucyIK4pcDqw
 E8vIdfcU
 diNCitAXX+KWRqhsIIZFK0Mss3YFgpjljLbJ6VviXEYDj7zHA9UAgbmsA+dbI7tORqWeNy8JMKOMd4fWea/obX2M3luR+NONXK0dpypN49+9N6y3jkvM4Ej1X0nvmRPg+7obzQDGUNuviYd4NfRDkNYuqG0quF02hI/ofa8V9dmV3A6ZXfT5rGixHh24i4nb0IO/4AsNDPmDpBwCBEiVt/ZSzIt4IFekGK0AvZqJyXsUxKtIBNs94kGkb4sXTXxbGaLshJMQ7bik4QNbo2lu7xG9BbKYxwBI9n6PfrkHnB6HMejN/qtV9mqLA6ZpVuVhWXzsmSQKemouz3WwD3ShbYOfvYCkKio+eHY6DalG9CRRYBDrNCuESabJHrsGdgx2G1/fGG+w1R75CBfrrFGkEdir779QIi+/bR3nyG8CYcjLC0ooFjxMPo4RpD65pOKaUhwkIoO+u82QXcjZhQy56FPdbCXa7sJk/mFUYqN18kkRkTtw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 11:44=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> On (25/09/02 09:49), Thadeu Lima de Souza Cascardo wrote:
> > When OOM is triggered, it will show where the pages might be for each z=
one.
> > When using zram or zswap, it might look like lots of pages are missing.
> > After this patch, zspages are shown as below.
> >
> > [   48.792859] Node 0 DMA free:2812kB boost:0kB min:60kB low:72kB high:=
84kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_a=
non:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB =
zspages:11160kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free=
_pcp:0kB local_pcp:0kB free_cma:0kB
> > [   48.792962] lowmem_reserve[]: 0 956 956 956 956
> > [   48.792988] Node 0 DMA32 free:3512kB boost:0kB min:3912kB low:4888kB=
 high:5864kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB in=
active_anon:28kB active_file:8kB inactive_file:16kB unevictable:0kB writepe=
nding:0kB zspages:916780kB present:1032064kB managed:978944kB mlocked:0kB b=
ounce:0kB free_pcp:500kB local_pcp:248kB free_cma:0kB
> > [   48.793118] lowmem_reserve[]: 0 0 0 0 0
> >
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
> > ---
> > v2:
> > - fix build when CONFIG_ZSMALLOC is not enabled
> > ---
> >  mm/show_mem.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/mm/show_mem.c b/mm/show_mem.c
> > index 41999e94a56d623726ea92f3f38785e8b218afe5..c563d9adfa87765a8736e91=
c1f68d824b03eaea8 100644
> > --- a/mm/show_mem.c
> > +++ b/mm/show_mem.c
> > @@ -310,6 +310,7 @@ static void show_free_areas(unsigned int filter, no=
demask_t *nodemask, int max_z
> >                       " inactive_file:%lukB"
> >                       " unevictable:%lukB"
> >                       " writepending:%lukB"
> > +                     " zspages:%lukB"
> >                       " present:%lukB"
> >                       " managed:%lukB"
> >                       " mlocked:%lukB"
>
> A little "preliminary optimization" idea: do we want to specifically
> refer to it as "zspages" or do we want a more generic term, just in
> case if zsmalloc goes away, or if there is (are) another allocator(s)
> for compressed swaps?

Hmmm, zpage? z is a common prefix for "compressed".

I'm honestly fine with zspage though. We can just have any new
allocator call it zspage too ;)

