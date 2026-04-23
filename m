Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33F26FDEE2B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 821AD6B0088; Thu, 23 Apr 2026 13:10:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2776B008A; Thu, 23 Apr 2026 13:10:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1366B008C; Thu, 23 Apr 2026 13:10:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 59BE66B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:10:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDF4A1403A1
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:10:31 +0000 (UTC)
X-FDA: 84690459462.25.1C8BEB6
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id E054C12000B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:10:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kO5zNLgK;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776964230; a=rsa-sha256;
	cv=pass;
	b=xxENxVe4eQksrM4YFvclHoeOWnIjkEmjORygGlP0z5J2bMdIiVDcrWfaet7HlATLO9sh3n
	9uBNsoo+FVAVgdaE9y10E/dJ8Q5R/hxaEb0761yznMLquRJA8mURRmq6RU8PEJWO2j3UN9
	F46K3XQC4mOcShxXsCy+cL0NbZPRbZI=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kO5zNLgK;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776964230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A3cxCPTcX43DT+WsUicUeZrNCHdgluMNK5uUzSlgybk=;
	b=G3R2PhLX6sm4/leq0N/NMcNRsTwAEzsNJ6oYGNg4mWKFBTc09mozlLSPsP7h2RFF7Lb4s3
	aelmtdYZTnsD8kHOKIzP1A710hEO4eq0nQCklVHi1LKcmAosYpnjYYdFv1cdqMMPHby8sn
	N4uRuR0zoRH3IndAQOwDRYchu+PojHo=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-678a16429c6so339221a12.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:10:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776964228; cv=none;
        d=google.com; s=arc-20240605;
        b=DPCi9mNDLRs47HZ/Y5TziC73b271F9VpCqoMOT/BDG6Rcw3elu3iBMXZCEfpsuOMRi
         8HV/dkoYRozejdE59lZKrIZJbWEqaAI26wR8XsVkdbrWQvoxjMm9tLF+R0OfZecHi7Ya
         aiZRPBIS87Bc0lP+6SnhvQKVoKP794kqu9egkFyc26L7fCTOai0o9wa4CGfQXPhwPDyA
         Itbk+2NjFXKinFKAwTpnzjYFoz1QwvrkQ9nuhRDLutO+0gxMV1ec3BlP8agqzltIQik1
         wiyL2eayRIYsw23sMIU1FjeVVcxA3+AcdQwzwp0uh6oays1nAO1oHwbKT8WPXCKANcmF
         jAzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A3cxCPTcX43DT+WsUicUeZrNCHdgluMNK5uUzSlgybk=;
        fh=H8awOgofe9e1ujESOU2zM5cTDXjgfwcd8q93/hU1FxQ=;
        b=Ol8C40Ud3LOAmjhEKe/MrEk/FrXax/KkzIb4G5WOT7Scew4/50Gy/xJ0Qv08U4zZMf
         oBjZYlK6ryu4aS8ADqdQOlVouzVeI8/8bbGhmr/6akNTb9sffTehCcCtTVwXHPQfnaVt
         YPDsHj5NmtWtamuX9jsFNnNvAKNdEgbxnaVoOh0P3WVujDo4DW2lVs3mms8B2baVG27k
         +im7UV3BlR2Q/onOkXRwpkWnljtaVzzZrWpYhmEbATivR0Q3FEiuNmoTNP7hDArAGlXV
         bj7A/1xL18OTDmVMOiwJvGjwEmL4BkQPf4to8KH4AQk4CExMCZLxjnFpE7Nyo8F9bVCP
         xShw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776964228; x=1777569028; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A3cxCPTcX43DT+WsUicUeZrNCHdgluMNK5uUzSlgybk=;
        b=kO5zNLgKmVJJtPq7FWgHlNz9asNTxbewNignHu9aa4HsVAKhVSLIDmgMh1wX7+6YTp
         YoZuzYw5DlSNg412FgGhtWw5dkcslzI0aAZ2XTuT3YvXLRX/CNW+/1/oYViXTVudFPZB
         7wiMhDnLn8b25NVs58Eo+YH4hzrCImXFVPSX5MOaBf4sk/TiPFjQbPJEWGMplw6qTMQV
         ZhJ0eCge7n7JGSd26Yzix70LFd8l6Nw3QuJwPbCD0ryl1LQ8J3fs4AZTafmVROQLKGXC
         Jj7YcuWt0QHy4tEKATXhMe9aQ71Fd4U+pnoPW3hgvjkHU1WQuvTIrAuSaxZeC4m1UvOR
         qxPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776964228; x=1777569028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A3cxCPTcX43DT+WsUicUeZrNCHdgluMNK5uUzSlgybk=;
        b=V7bVny1NFo5n305TfsCWpRLzDExtsugOGhtc71WUoZsbGLUGmi5OOyP2nVqxXa76S4
         aTJ39FCWlUj18w2mGqKPlHsP50ZUwS3RiCMcPDyh6as0zcfBF/SRDvztI7Eztnpx8O5j
         7Cidh6dKtUMXwNlGbu28W7dTZ/DkuzMTAwc3tHG/lW+MDBQFANPIZOAiHPFpR2ZYKdpk
         lrXNkn7xgp9nP3TIuJXE00jtqQUQFto7cud4BBOjjtTOmdpOe0a5IpasiXSrgZ2MQ0bf
         e+TM85gQVLhzADl5Rnhm1c+EnPz+CcQ+5O8YOxCKpTPkw0k6mH9ObPcqsDjluNpmQTu+
         Jrjw==
X-Gm-Message-State: AOJu0YwGlg8K+tzXOODBumenJOCke9qaMFn0sbt7pVGyCX53TznHIHv4
	u8aD5y+SqOAasP0Y6HpuYkybkrKr7ln86cnGHTmbxDsaXrZUemZ3ai4mg6RKHvVvXcIenooEEic
	jMHlWXIMNyisO8lO2712Yv5sQy+Uwm4c=
X-Gm-Gg: AeBDiev+ElWtiniKwRjrbRj0i+IuGNUtnvyj0eoQnHCdzckI93/R0QxCC0oLRl2t6eL
	D9bc7BnQJ23pd2S/Z4YsQccm997sIL/eD1nCd2c/AdqYGGC46rJ6E4FhBc3OeJlcK8KzijALGU/
	PXOCnAUJqy6tW514CsC9jot9ND/w+EKgOhCIM/5azTCqHs9gz3nwULr5BuEAMs1DNCPgkJcvCHT
	ifbf1Fi+FMTS/M+e4OHuHQbHecnnCADU+0v68oisLns+0FeDQBUqnPRxDezK0eSCzGmbyX5aDtN
	RE0mbuIsAYjBaNKaOK1/lokMRQhl5SUaZ0S4wzsb+u6AECKR1FE=
X-Received: by 2002:a05:6402:454b:b0:670:a28c:4604 with SMTP id
 4fb4d7f45d1cf-672c12b321cmr8265107a12.9.1776964227886; Thu, 23 Apr 2026
 10:10:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
 <20260413-mglru-reclaim-v5-5-8eaeacbddc44@tencent.com> <CAGsJ_4yH6v58oD8K56hMPp5bTYGC1Bfo3XSAViW9gWeSwLXgDw@mail.gmail.com>
 <CAMgjq7D+ni+t-bLCeEmOHwt8s5+4iszCMdzzek+P-DuZYemcVQ@mail.gmail.com>
In-Reply-To: <CAMgjq7D+ni+t-bLCeEmOHwt8s5+4iszCMdzzek+P-DuZYemcVQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 24 Apr 2026 01:09:50 +0800
X-Gm-Features: AQROBzCFObP6MfKOFDr6DeGk8s4S2K6O6Mkn-kXgXzveisSr5L_OA05g-5_yvac
Message-ID: <CAMgjq7BWVLRiJBXv4_+0E=SNUcH6TLFmhdJh46WECKiAZNiDeQ@mail.gmail.com>
Subject: Re: [PATCH v5 05/14] mm/mglru: scan and count the exact number of folios
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
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
X-Rspamd-Queue-Id: E054C12000B
X-Stat-Signature: 5963w9iwphjie1qdhauut8kn8pisuc3j
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776964229-532291
X-HE-Meta: U2FsdGVkX19YhtiHOM2+OMHP3j64cYcQ9+3iTl9SpLbKvzbo61ROZgGhwCCvCy+N5z+MkWKhwt5NV7cGpGJOKAcY3Q2MQ1boF3O7eTMrp4tmfVXhLR8Wp3+gL9n/AwCtNrY/pI0UMMzrTCEyAAT10TSgc2UlGZx3Om9XVh/1rZI0nNAeJJlu5omuVFmRL0IevLzT6g6vkZysVyBTGO0l7gudqYSEq1H0cfGC2mgQqVyKc+w1bk1UEFtzloOpmfbH7pWwEy217O1ymyE4BaHhXcfl9PMNqmlhqLwukOdlea/Aovd+IR5HC3+iLL3PAa99h+BFSwKmwpaqzlsW5sMMFXqgeHLZ9LnnhaViIypgxt40AvFNRsHWVf4xOWbzBha0DINp0B6ieFaczjNJ1WGeTwbCZcbgRHDrUTkEf2ya7yRWJ5ey2X/rTDI7enN8PkWyRiRJqPI+kqe1w+t2QGeH/17b7zardANuAiKSSDASfTnYsMEA9j0q1ZuwKtyVouMK0t75BHBK+XWezWMpmug50uMiUK4vrsiAnd7/OUMalNmfaz+AOJrgwNC+STMSSWxLIfotPOo7akEg92NwMyNJIkiI9s+yK7SA48sCzNXYxTdA2MJEXnTnQmUvsSjYpSTylxG1YRMUIHeDmVD4eLhW0TsLijWieb7rD5kIAx+eDUO5/4iLqsCHb7H2CjGPR74DpNh1PWulmXBYgGli8ADGboaTDm/r8yghy+PF+f26nwS/v39oZl1MBbXkrmlyuKPa3RdiNDn82jMarA4A2jkwslfVyM0pYrYqCWKAbLzKVxKBxWds9Sh/74HwIyaMdjVV1LB32h47OFGorke2LM7Rimz0aQZJRUzqtjd19gyrPZDdp7E+3xVlF/Rc3wds6YTS9NYW6KEbs4o6LoIfrMXe/6TNXKcc1dzTGYvDzyKsAWs59HjJyVspu5McI4cZnE3YEYk1Ubv/REvtMgZ7CjP
 XNDAQcrT
 SY37U+O87wJJVR9/fQfpIC5DNtIQXZQsUk/b/F3qnOdyFxF2DJP92Es0lQWTUKn/VPIM6fQFcH+oXWxK1HTdmAOYkSXdC1TJFe/N+rkPO89TPqZ9DquLPgB7U5dNd9vDQiV83MdAYEweLd2ulgP4qERdisjQSOG+jsucSpEh3cH2GctJNpkHh+8+5BCgNtkb+fB73BxGxPjaHKrHnrvxuVBUPJobN1qp80ZUlc4he0pA8d5fht2PjNnbsZ+zqDNmeaIB6eHQYBUaG11dWhU13UKG4FRE1IEgXdVLTSPo61BSdTYO5lMNQYw+L39Mi+sBnzKKpB3Qy01FKkWr0olI2WzksSajJ70y7HQhcqFnlA5VIwB4ajCdHXSu0u8z4gGVuav5He1w5uJ75fs9fTj8B0OC5+wlpiziq51pUiP0EggDThR3FKhdSg9T5rpB25v6wNiuxqAt1i4mNJFXhEAEW+WRb6Rq2Q1p+BnwTYGuMy6frMu06BDUf7fqo76LcKx+RW4q3tSsGAfyDvtg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 1:39=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Thu, Apr 16, 2026 at 3:03=E2=80=AFPM Barry Song <baohua@kernel.org> wr=
ote:
> >
> > On Mon, Apr 13, 2026 at 12:48=E2=80=AFAM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> > >
> > >  static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, in=
t swappiness)
> > > @@ -4686,7 +4681,7 @@ static bool isolate_folio(struct lruvec *lruvec=
, struct folio *folio, struct sca
> > >
> > >  static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruv=
ec,
> > >                        struct scan_control *sc, int type, int tier,
> > > -                      struct list_head *list)
> > > +                      struct list_head *list, int *isolatedp)
> > >  {
> > >         int i;
> > >         int gen;
> > > @@ -4756,11 +4751,9 @@ static int scan_folios(unsigned long nr_to_sca=
n, struct lruvec *lruvec,
> > >                                 type ? LRU_INACTIVE_FILE : LRU_INACTI=
VE_ANON);
> > >         if (type =3D=3D LRU_GEN_FILE)
> > >                 sc->nr.file_taken +=3D isolated;
> > > -       /*
> > > -        * There might not be eligible folios due to reclaim_idx. Che=
ck the
> > > -        * remaining to prevent livelock if it's not making progress.
> > > -        */
> > > -       return isolated || !remaining ? scanned : 0;
> > > +
> > > +       *isolatedp =3D isolated;
> > > +       return scanned;
> > >  }
> > >
> > >  static int get_tier_idx(struct lruvec *lruvec, int type)
> > > @@ -4804,33 +4797,36 @@ static int get_type_to_scan(struct lruvec *lr=
uvec, int swappiness)
> > >
> > >  static int isolate_folios(unsigned long nr_to_scan, struct lruvec *l=
ruvec,
> > >                           struct scan_control *sc, int swappiness,
> > > -                         int *type_scanned, struct list_head *list)
> > > +                         struct list_head *list, int *isolated,
> > > +                         int *isolate_type, int *isolate_scanned)
> > >  {
> > >         int i;
> > > +       int scanned =3D 0;
> >
> > I would prefer to rename this to total_scanned.
>
> Good suggestion.
>
> >
> > >         int type =3D get_type_to_scan(lruvec, swappiness);
> > >
> > >         for_each_evictable_type(i, swappiness) {
> > > -               int scanned;
> > > +               int type_scan;
> >
> > And then we keep this as "scanned".
> >
> > >                 int tier =3D get_tier_idx(lruvec, type);
> > >
> > > -               *type_scanned =3D type;
> > > +               type_scan =3D scan_folios(nr_to_scan, lruvec, sc,
> > > +                                       type, tier, list, isolated);
> > >
> > > -               scanned =3D scan_folios(nr_to_scan, lruvec, sc, type,=
 tier, list);
> > > -               if (scanned)
> > > -                       return scanned;
> > > +               scanned +=3D type_scan;
> > > +               if (*isolated) {
> > > +                       *isolate_type =3D type;
> > > +                       *isolate_scanned =3D type_scan;
> > > +                       break;
> > > +               }
> > >
> > >                 type =3D !type;
> > >         }
> > >
> > > -       return 0;
> > > +       return scanned;
> >
> > Then
> > return total_scanned;
> >
> > >  }
> > >
> > >  static int evict_folios(unsigned long nr_to_scan, struct lruvec *lru=
vec,
> > >                         struct scan_control *sc, int swappiness)
> > >  {
> > > -       int type;
> > > -       int scanned;
> > > -       int reclaimed;
> > >         LIST_HEAD(list);
> > >         LIST_HEAD(clean);
> > >         struct folio *folio;
> > > @@ -4838,19 +4834,23 @@ static int evict_folios(unsigned long nr_to_s=
can, struct lruvec *lruvec,
> > >         enum node_stat_item item;
> > >         struct reclaim_stat stat;
> > >         struct lru_gen_mm_walk *walk;
> > > +       int scanned, reclaimed;
> > > +       int isolated =3D 0, type, type_scanned;
> > >         bool skip_retry =3D false;
> > > -       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> > >         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> > >         struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> > >
> > >         lruvec_lock_irq(lruvec);
> > >
> > > -       scanned =3D isolate_folios(nr_to_scan, lruvec, sc, swappiness=
, &type, &list);
> > > +       /* In case folio deletion left empty old gens, flush them */
> > > +       try_to_inc_min_seq(lruvec, swappiness);
> > >
> > > -       scanned +=3D try_to_inc_min_seq(lruvec, swappiness);
> > > +       scanned =3D isolate_folios(nr_to_scan, lruvec, sc, swappiness=
,
> > > +                                &list, &isolated, &type, &type_scann=
ed);
> > >
> > > -       if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_G=
ENS > lrugen->max_seq)
> > > -               scanned =3D 0;
> > > +       /* Isolation might create empty gen, flush them */
> > > +       if (scanned)
> >
> > scanned is not equal to isolated, right?
> > Somehow, I feel the comment does not match the if (scanned).
> > I assume sort_folio() could also create empty gen?
>
> Yeah, you are right, it should be isolated. Usually one batch scan
> always isolates a few folios so I didn't observe much difference in
> testing, but I should definitely fix this. Thanks!

On second thought - it should be "scanned", not "isolated". MGLRU
might move or protect folios to the second oldest gen without
isolating them, we have scan > 0 but isolated =3D=3D 0, while an empty gen
might be created. Ideally isolate_folios can detect this internally,
which might require some other refactor first. So let's keep it
unchanged here. I'll update the comment about that.

