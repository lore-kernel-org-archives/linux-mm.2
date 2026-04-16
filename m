Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24FE6F8D763
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 17:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C46C6B008C; Thu, 16 Apr 2026 13:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175466B0093; Thu, 16 Apr 2026 13:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03D346B0095; Thu, 16 Apr 2026 13:40:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E81186B008C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:40:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 616025B942
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 17:40:29 +0000 (UTC)
X-FDA: 84665133378.22.7E0123F
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4E90880010
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 17:40:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WW+GZe4K;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776361227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ep0e+oD24wKRfskgqg4nq4PrXdaak/438+06Dgmnlxs=;
	b=HkgXPsxApMWQzYyenDX+urqCrJbq4XsmufZ6g82Uzpq6rLHMGAnlKfbpD8RzGY7Z7OcjpB
	Zowv3wNSLlI1mP2Iar0+e4WhCfxlA+bxzpyuBQGhvk+tzPNyeOji1g0tSCq1Kt5Ehlgloa
	rENnFfxDBbT2pu00YSCF3W6vd8D8SbI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776361227; a=rsa-sha256;
	cv=pass;
	b=IH+ySBIb09cPbzBYGDUr85slNS/bxjSfFhaVgwL4Wvue+auLR6eAeqH6uP/53KMr1eeOeT
	kY36tSCfl/1pl5j4Tm4AbjezVZXvn0X2jJWcUFRC2sUiATkfpfEyNg39YOcJZYQ5M+tqs8
	f0y3LJcknZkuHWswhPKric+QK9egGqY=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WW+GZe4K;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-671c24f23b1so6494578a12.0
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:40:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776361226; cv=none;
        d=google.com; s=arc-20240605;
        b=cRuLD8ZPuallZ0r8t/EVzTbWbvy7sD491c1pW/yakXOtZOGbgcfqfZEDe11MRjq+E/
         6hZduzq5d85zM1jVVaTA3TAEqVtFIk+uW+ErD11J1ucsHkkPHdneZljKmacw1NlfxoBT
         eJwOnOnADUb9xxIWc0kDjS65EKGA4v9H1rG7WPeVrPLfTg1/8Wk6msvRO/yBlAJyLahs
         7qJpwalmNooi3KVLBOHe3OmzzFCS0rNeTzmy3qCeMghl/r1XClcotoHYM31Ky+Bi8kai
         98+SxDWYE5f1v9J+4VvnAHUvLnO2IxyO8OvVGHI5srL9n8K6v81cSYERVTEdDnCi4uPw
         eRsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ep0e+oD24wKRfskgqg4nq4PrXdaak/438+06Dgmnlxs=;
        fh=H8awOgofe9e1ujESOU2zM5cTDXjgfwcd8q93/hU1FxQ=;
        b=aCHo24UyxU6FdfF9FQJvXVKww1iBryCM2m0gQJf6RGGUkctk6dcajnFxPA02Caaz0d
         PLP59T+C0fjuHSIWNQE9xVLdnyZBU0gjjqyHdCOEHoB44TsdCgxXWQ76Piz/uknt7n+T
         eGt564qKHhf7oA/uTSlKYVoN2J+Sk83XYGjkEUBVc0QHJmhtoOxZy7Jr+Ano2y9eOGZg
         0n4DYPlZRONwYZ0e9BFvwv+psiu4PPumQ9gzT/IOZCxVoB/130bdZr60ZCIixcSky45E
         4Y9f6KGY6i8GKlM44I37riCIpeguRvbsijAnNsg9aAaNPDv41zzsXGUP/062U11oPJSH
         cN7Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776361226; x=1776966026; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ep0e+oD24wKRfskgqg4nq4PrXdaak/438+06Dgmnlxs=;
        b=WW+GZe4K47+zOOThxcpApOtLXj7vj+cZJ2mF3s5StWfRDK5goeRM5cBWie4GWpUZK2
         m0twSK03x7uPfZtiJjjTLkhRXMZetxHrlX40xcFZoiLklkzziBX+wG0ofZsvLyLIboIF
         l4e4BzAa5SQr4UbuDFoB6+Z8AedIPH7tyJZwxe/EoHy2qA4+Glk7j5qjqfLuF2ypfnPK
         BhwygSvQ2tDO/WInd+rVwgZg6dQzYKkUTi9YnNyQu5uZa8OQyuaI8PtatzdX4/54rxii
         YyZV17DvBdufzUZzoR3jmpWJQ6m+A0jfFr0Ps1ZDEphSwDdArKqaNmiONhi/fUQXlezN
         apTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776361226; x=1776966026;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ep0e+oD24wKRfskgqg4nq4PrXdaak/438+06Dgmnlxs=;
        b=eQV2fPRksM8CVAPF8VVtzt0czmW9v1xY7+7oaLWY5JyikBIPCDHzttSKZeB3hVbUWz
         Xj3Gj6fIVqp04be9Q5B+hFe2+PYmIukhPqlscD6P4tOgKStv3czBHmvX4Cr5ph9Sk50z
         at5O5i7dNWSyNXzRvKPOAOIKxIVVd4kmvT3q8XP4BFsp07xEj7y55VxOa20A0VDsqQfB
         hFJEHaeXWxBeVjCtSMA3sLyvECAyfft3EXEb75ZzcfLP3vijUmaa46rqFxB2FBnwrDGB
         wsmKNgKA5lWR/0aN80xR9Q8aGw//z6naguuPxXcWMd4rX/p0TLmGahGu57g4r3K1/dEQ
         yRpA==
X-Gm-Message-State: AOJu0YyT57Soz/5KgcP/3PhkLIOlIAfVPmmUue8SzeQiqWdZyCXcv+Lc
	gXy0oIumADpXBRAX6JeFgGI6UdQXOfoFT7rNKCyc1u/ZS5r1KkA0Q4lXTLokMIZaT+Np0CsiqEm
	ab8S4iguKV3c2jGEGYeww9aZJEqgC5fM=
X-Gm-Gg: AeBDieu52nHXMvUkPoMClfIjwuyN9yo+FWKKkxcA6vSLP4NktLvNklRBUsJkKZM6d0Y
	0w4qnCxW+7WvO5Eoptv5VyG3k6N8FILjJlZ2J7PqSowk7hA7G1hUgGv+lTBK8NM0QzAZjeJDzDx
	lXNKOF6MqoxXGR8wNYNc99Vsqi/iJ4X8SFaiEI31glG6SnAkLI90QKHalPqxrx/ThQkUQgKRJVe
	fnJbV8ZUtto8W0yORDunVjT2G++GLVbR01oQ7YPjOfCBo8pBoMSgu+K27/GVFMPA0QmjBhg5sCM
	vhFLDVU/oZLKywqgEtaiQ4SDBXWMBUt7VT4UBY50fBJ7YBh2s+UdcQqVH4MPgQ==
X-Received: by 2002:aa7:c4ca:0:b0:66e:7b0:ba0c with SMTP id
 4fb4d7f45d1cf-672bd740a4fmr9005a12.28.1776361225367; Thu, 16 Apr 2026
 10:40:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
 <20260413-mglru-reclaim-v5-5-8eaeacbddc44@tencent.com> <CAGsJ_4yH6v58oD8K56hMPp5bTYGC1Bfo3XSAViW9gWeSwLXgDw@mail.gmail.com>
In-Reply-To: <CAGsJ_4yH6v58oD8K56hMPp5bTYGC1Bfo3XSAViW9gWeSwLXgDw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 17 Apr 2026 01:39:48 +0800
X-Gm-Features: AQROBzB7813SZqOe8VUrFkopu87Ga5hwb0SKkKnIicUEBSJwId1p42qs29c4hig
Message-ID: <CAMgjq7D+ni+t-bLCeEmOHwt8s5+4iszCMdzzek+P-DuZYemcVQ@mail.gmail.com>
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
X-Stat-Signature: 9r3semx66eku1tzin76udpm9tfj5z3au
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4E90880010
X-Rspam-User: 
X-HE-Tag: 1776361227-252698
X-HE-Meta: U2FsdGVkX19gPIIPN4yGnzZgapimLlRJFZX5ObyMLrslAoQ/s2MGhOs1RaBsYt7b0EwAZcfyhXhIplVo57rbt3Ju4QThWad9xoI1Qf7841feyUIYImHBykbtHWrD/dp5ExoIvV3TOXeIwSmsMZNyDzn26dtf+nOFulpa89HSmHOOmVAMvFP+u6JVPTO4im7NMiTv1712MijQZTlIj/Qar637gbtRamtZeSjBjDGc723/deX3JPxEb1fUQx7T1M8WvV5iZhyNLyv+N1UFyi/L3GJdzd9TfiaYBXnRxdaAV6e0UIiUxvAVVbRAS4b55cOP8DB7i7SjmgAvdxBX4p1blLvIoXrIG3hJ2zlcJxOYOTe3IwBNSIa4QIp0EDotHWLwB2mv09RihzfGqeSj6jy5joyOuRxLICie7kp/tECH2ADh58OMp6AeYe5cn+DF3RU4Gs1s6rPzs6FG7Nlxu3ocFMh9L4wJR5CVVowfhRLBXvMYdvsxC2W3BRS737Jtp2ZSY/O0YB/h94AUJwJB51sRTopdI4MshCWrg7otWbg8kN42mAOLxfxnl998hzdPFt0qBuq3xvrewMQl+Em7/puklPKRjWBbUeXBRzZFKZg/nKqCN6k0UfcUXgp3BMFMPHh7kEx4x+YyxJkbW761ZG51jY56N8l+c7ErlEDT5boducVns66RCxDmdWnIH2ZULYWrKg8bqSYH0QuoG+BrAv4cHwlwW2NbVg6qIwMR9/CPsFfPRQn0n6J3JLw8mHzaNZaK3nBm7gVZoWZRes5TX+z1MKf5/kT5JD33g0OI+cAToQ/wlVvDk5e6fQnKReVD6+u5LWl73Tq6OB0wpQQPsoLIwSM/6JHoX46O3/WAb7cXRytNaUMsZ7axPOBLgk0pUWi/g3kxIUL1LPvEoZkZzwp5v7gD4fyunlPCbi8GwS/a5XCjZti5/TAHmIgJ9oofHWlAjgttnAGq+KFOBms3Ii8
 KXqWJz4B
 vd3p1ttoTFaQKH+3CX52aOE3ntZajqTPWPZ9gYG3UhSbd+dNlZr/cU5zIdAGheZWgav0rylUR79VIKS38WMWMVIraCpNfdxyD8E/FhNPSlUT0rjy55G8IzrtthmnSfVel9hpBqqu9FDl/RTvHtLp+scPmMmJf5MiaVvAiLRubWiyP8+h019AQUZIGYsd4KTMzm7GFGb38wqBMjYwkdrEqLwOhlzk2PkxCYAVL0d5CR3taFmKirB/RjsWXlu8aw5v4vin5ezKcfVofMx/F+W0iNeuw2969tyveoF9AT5uReGgQXESBj28EbimasFYumBKr1qe4gC/VJ1YV38ciTF45nkYC0YrX3msKO3R7nivNhu2oiVjVfQhG/7MT/K0jJ8Uup+Pg+kmuNdIdHSkXGjCBHDiCZKCoPrlAq8OcCB9vGaugBBrTGjHEiXY1fiw4RrknDz/1KFJe6iMgzvzcnvccCRgABRUrb0D0FXR24NnUbvWo0EpveH4Fu/1V0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 3:03=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Mon, Apr 13, 2026 at 12:48=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> >  static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int =
swappiness)
> > @@ -4686,7 +4681,7 @@ static bool isolate_folio(struct lruvec *lruvec, =
struct folio *folio, struct sca
> >
> >  static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec=
,
> >                        struct scan_control *sc, int type, int tier,
> > -                      struct list_head *list)
> > +                      struct list_head *list, int *isolatedp)
> >  {
> >         int i;
> >         int gen;
> > @@ -4756,11 +4751,9 @@ static int scan_folios(unsigned long nr_to_scan,=
 struct lruvec *lruvec,
> >                                 type ? LRU_INACTIVE_FILE : LRU_INACTIVE=
_ANON);
> >         if (type =3D=3D LRU_GEN_FILE)
> >                 sc->nr.file_taken +=3D isolated;
> > -       /*
> > -        * There might not be eligible folios due to reclaim_idx. Check=
 the
> > -        * remaining to prevent livelock if it's not making progress.
> > -        */
> > -       return isolated || !remaining ? scanned : 0;
> > +
> > +       *isolatedp =3D isolated;
> > +       return scanned;
> >  }
> >
> >  static int get_tier_idx(struct lruvec *lruvec, int type)
> > @@ -4804,33 +4797,36 @@ static int get_type_to_scan(struct lruvec *lruv=
ec, int swappiness)
> >
> >  static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lru=
vec,
> >                           struct scan_control *sc, int swappiness,
> > -                         int *type_scanned, struct list_head *list)
> > +                         struct list_head *list, int *isolated,
> > +                         int *isolate_type, int *isolate_scanned)
> >  {
> >         int i;
> > +       int scanned =3D 0;
>
> I would prefer to rename this to total_scanned.

Good suggestion.

>
> >         int type =3D get_type_to_scan(lruvec, swappiness);
> >
> >         for_each_evictable_type(i, swappiness) {
> > -               int scanned;
> > +               int type_scan;
>
> And then we keep this as "scanned".
>
> >                 int tier =3D get_tier_idx(lruvec, type);
> >
> > -               *type_scanned =3D type;
> > +               type_scan =3D scan_folios(nr_to_scan, lruvec, sc,
> > +                                       type, tier, list, isolated);
> >
> > -               scanned =3D scan_folios(nr_to_scan, lruvec, sc, type, t=
ier, list);
> > -               if (scanned)
> > -                       return scanned;
> > +               scanned +=3D type_scan;
> > +               if (*isolated) {
> > +                       *isolate_type =3D type;
> > +                       *isolate_scanned =3D type_scan;
> > +                       break;
> > +               }
> >
> >                 type =3D !type;
> >         }
> >
> > -       return 0;
> > +       return scanned;
>
> Then
> return total_scanned;
>
> >  }
> >
> >  static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruve=
c,
> >                         struct scan_control *sc, int swappiness)
> >  {
> > -       int type;
> > -       int scanned;
> > -       int reclaimed;
> >         LIST_HEAD(list);
> >         LIST_HEAD(clean);
> >         struct folio *folio;
> > @@ -4838,19 +4834,23 @@ static int evict_folios(unsigned long nr_to_sca=
n, struct lruvec *lruvec,
> >         enum node_stat_item item;
> >         struct reclaim_stat stat;
> >         struct lru_gen_mm_walk *walk;
> > +       int scanned, reclaimed;
> > +       int isolated =3D 0, type, type_scanned;
> >         bool skip_retry =3D false;
> > -       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> >         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> >         struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> >
> >         lruvec_lock_irq(lruvec);
> >
> > -       scanned =3D isolate_folios(nr_to_scan, lruvec, sc, swappiness, =
&type, &list);
> > +       /* In case folio deletion left empty old gens, flush them */
> > +       try_to_inc_min_seq(lruvec, swappiness);
> >
> > -       scanned +=3D try_to_inc_min_seq(lruvec, swappiness);
> > +       scanned =3D isolate_folios(nr_to_scan, lruvec, sc, swappiness,
> > +                                &list, &isolated, &type, &type_scanned=
);
> >
> > -       if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GEN=
S > lrugen->max_seq)
> > -               scanned =3D 0;
> > +       /* Isolation might create empty gen, flush them */
> > +       if (scanned)
>
> scanned is not equal to isolated, right?
> Somehow, I feel the comment does not match the if (scanned).
> I assume sort_folio() could also create empty gen?

Yeah, you are right, it should be isolated. Usually one batch scan
always isolates a few folios so I didn't observe much difference in
testing, but I should definitely fix this. Thanks!

