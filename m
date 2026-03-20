Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C541099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060306B018A; Fri, 20 Mar 2026 15:51:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037ED6B018B; Fri, 20 Mar 2026 15:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8FF86B018C; Fri, 20 Mar 2026 15:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D68A86B018A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:51:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74A351B7788
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:51:45 +0000 (UTC)
X-FDA: 84567486570.25.EC04B3B
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5595620002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:51:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="tgKoH/7Z";
	spf=pass (imf03.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774036303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0fTbswDUhCytbSjyU/dbAvolz05MXUeSGYJ/0aVmQR0=;
	b=RIJIUsetOw1ehD99BfFKLkd35alDtJjoN+P7AX9j3P64YGb+7nTBP5f/J3QqWGN2dmz8OZ
	fRbueLjh26g7SbojK3lXMHvD8Ape91cLD+NMu4x5wAWToiR42x2QcxChJd3g3EY101ub2d
	oHrgY2rj6F95I2ZMDziSdeqK7BjHv8w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774036303; a=rsa-sha256;
	cv=pass;
	b=i+oKCJ872kuVkCdTSfd9CFUwMvnAj5qYvIh56cvygvndO9JgCVaRn3nVNQ8r2ZNz2EGEZd
	TZyAdCkVGk0cQtzbwNeguA+/MpOoLTGPVyyflqvx4MkeTjipkeCVo9p/tXlX7A+FFcRvLZ
	onMH3BOiXlTXCOAdaMZS61WtTqUHfEE=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="tgKoH/7Z";
	spf=pass (imf03.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1270f10a774so516c88.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:51:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774036302; cv=none;
        d=google.com; s=arc-20240605;
        b=E++2w2YaCNHh+y9yp57Z770pS9WWOlyowXkQblYAVgjXTgEop9iCR6LFt1Pk0HMdOe
         lRhEsiaz163zC4mdd+xf2oy4S3hS43rIxndk5p24t3mbHl5v26pYp4vT5M+TNoefu3Xv
         ccNuAWicnEArL22FakUB0sbdpVunh+SzAOsANIC251TSx8sLeEOPa07gIJM+4xHVAK1d
         RLP2yylfMVEYXp861iixac4/o2Adxzpi3DNzTU1GJHzayVW4TU2tqoJBW3N9mwPhYVZp
         OCuDQj10MG7GWVvmFUcbaQb/DgerUWePmFxnYu74hBtGzVegXMcNnQvxZ/+0o/us2hcx
         lQ5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0fTbswDUhCytbSjyU/dbAvolz05MXUeSGYJ/0aVmQR0=;
        fh=HxOdvjJC71PO8sVimAUKR0KeyMXGVmcnGs8Ej1fP3pg=;
        b=U8ovfFClXy33Cufj3YSAs0nINYVQM/UVJ3KXAC9/3F54GQwjANuVtDEtQvjP7iDaPj
         48R90p7AsGyRrkpa3/CE54n+vxVt9D5cOYEbuvh1iSwaF5YZj5v4Eu3A5HyKSRr/BvkI
         0G1cS1J/G2Y7U996Q9dDEwwZJFl/ZaexXt64vOiAkvttt9OyDOKU94Ud5MmMrj90Jpnz
         axqxH8xdIRgQpo+pY6XOvy253CWv/ekLWqfz4af5OO+S499jF8gMY3WjZDKuvGD+L6Gu
         x3OeeCeMuiDaBvMk8+xFIQ0B1OaXV5rVbMS0BJSvSgzsdbrNKh3oPaaRMkqER8rUMI3y
         B7wA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774036302; x=1774641102; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0fTbswDUhCytbSjyU/dbAvolz05MXUeSGYJ/0aVmQR0=;
        b=tgKoH/7ZvZnBvlyGvEm6tmhRPu7Pwayx3ksW9IZPXqa4d6R2Y549Ik+71/xIxTsR6f
         COo7QpREZkCITPt1ewgnRiKG4CgBqGIMbYNlH7yJLk9ECra5GfLWgfrDOF23RdwU6nVV
         QVsflfLo+3JpZNovdVdNhK5ag/WdvmnNeiG9GQG/a5UZtdvyw6pyQIoZoSlybBScxcL8
         YYlabvQzr+psgmz/M2UFm7wP0CWEGbmHixVIMQ5FRFP614E/wyRfjHUXsrfB1Y5hIqtc
         Mn7ZpKJ9DSnW1RyTObUWP9sVrqGXPkopvCAmlt/DtCYVpohei9IXv78oFha0gmg7QOtH
         kvdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774036302; x=1774641102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0fTbswDUhCytbSjyU/dbAvolz05MXUeSGYJ/0aVmQR0=;
        b=fGeyTNiQ6NJDCx602oZ1T1naZqGce88ydDZkfZRngsHyor91zCFYWoovKOTxhJbNxL
         4ft42XnRPVq4i0xdKV7rCRnDD32UaFWQmEnIjLvvLngxQRF+au6jJkmnNauhqkfkop5C
         u/cQywTOpF1fE5Xtox1ixQghoO9wGjXyxCcs9IO4vajNRJHugW6lNCjL5suloG42AqmT
         iO211rz4yHQAqsqMoDepQ5AFrs5Dol3qSqL4C52cW5EAeeEaBOvT4FiSER91uZ3592ls
         yYZJ7gT5eo2wj2wGelnXvlACkhX8e5BPdXrIGxwe2hLaeLWBNqHFKqhjmeiN5hpH1mYe
         CCFw==
X-Forwarded-Encrypted: i=1; AJvYcCXQyu6ekTasxqEE6hYg7NvPRMcOcPInbDuVmptXjtKB7rKZUKEHcoYMYqcGoG3PBVpR52xWmghcBA==@kvack.org
X-Gm-Message-State: AOJu0YxJDOWtEDSl5lcYK5X/Vm+SLRYS9W84Yf3UQ8JZ8hvMisUzmze3
	8Uu4IU4ynKBn2mIMpSt4/gpPN57oBIHOmDfnCCjbkPNO4W4zJZHHAvud9WehUCGT+Gqasu46Vpr
	5APFK1+Ni48Nlgx1femSh5/ZAWpGBZH0bmPL1Enwn
X-Gm-Gg: ATEYQzwNJfuoJQkJtlXoXlX5pQOxQdgjtAdLiybMQLN95FKY3GmwwFEJe4/87n1JKGd
	dFLKIaVJjS9so0oY63yJjxQVE2R4ssV6I+kLKBNHlDGjUMuzf/vCTg93xSBQR4mVaSDp+AcyOo1
	cB634KUHUs7mN2VAPK7immzRcAbRLCLO05Itf9ghbQ4q7OEjn5JgQld+suS2VLv8culMvauiAhc
	BjLBaJU8SsyMxDtpnSYmhDO3a0r6hKiEjLum++P3Yc4DHGneJxS9QCGXD34aVxO8maj+reQJYWK
	atw1mfuVQ9nl6CrVPV8=
X-Received: by 2002:a05:7022:ea33:b0:11a:61f0:6e6d with SMTP id
 a92af1059eb24-12a7afaf6demr22010c88.10.1774036301294; Fri, 20 Mar 2026
 12:51:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-1-2c46f9eb0508@tencent.com> <9f982344-1137-4d8a-9186-b1b130dc15a6@huaweicloud.com>
In-Reply-To: <9f982344-1137-4d8a-9186-b1b130dc15a6@huaweicloud.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Fri, 20 Mar 2026 12:51:05 -0700
X-Gm-Features: AaiRm50uxliVfzXfQiJvxhRVrp55E6hg9TjzHVZ5BXagR5anXuz84KgKhmMmToc
Message-ID: <CAJHvVcgTxcZCACyniBuQeoGzgAyQzszHYWo+vj2i8TUC41t85Q@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm/mglru: consolidate common code for retrieving
 evitable size
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5595620002
X-Stat-Signature: shgwdbwry9qgwehn6zo43m795r9bfm91
X-HE-Tag: 1774036303-705608
X-HE-Meta: U2FsdGVkX181oKE6p3Oo2IgF1wuooKNoZchE9cOe4vaVPRD92B5Yi4r8zmxOhNMsWYrwxRzCasCbEp1W3Iq5LMFiVSvUlgM5MQUhG+GSmnpz9j6WxXK77bK7lyP9WEFYGE64R1378jBQDGxC/X+r1/j9jMsVJhHIrFCr/Zx+GBjHl57PTGt7XrEGPERNHj+7Glc3wV7/KbJyGlVCwWeJHk7LJB8TkglBjJeu0ApLjJOVirkWGCMhZnjdVWps483MoDBc4fJw1g9dkFXJ5wVSe66GgIFuAfsL2y68gTqMVE97tP7+l49SACnn9qRDK6/O5dk4wUfYkP9j9RN6Ihz/wXjpBC2pgtdxcm7NpNuqt7amrlcxWPgit7dn6NDQvSaoKFpjc/H1s0Tt4CvA42UKX6JgJXFLBUJsDas9CGViQ8wL7RZ9059J5S8RnCUoTr8q921j+B2S+jMFYKdHo490S70T3xgfNWmIq3xVnxourrZiLvBvoeoU2SaCvZmqUAEOT3LNpZMDCNfXQDSQ+4NAPCkSu5vQ4+y72viBX97zNmIWAm1F/A/c+PHclV5mHgZ55DLnyjm6I/eizUyZE3wb1kMgNsZ29JSAK+NSb5wYbaB7caj1SwhYxmzcr+hLgqfL9buQH/wffvyMz6cchFuAU03X3CLyfl4+r6LLaarC1RbpGnbhOxI1LN4XpDiwkzzAh6yKHvJmnAp+OyLwrIEkvFQZphi9ChY/ShexS+W8GXNTZ42xLz+ZGR6gILZk/vlCL6/KRJJOhyGo35wI+GKq7mLJCXMVOjcplbA6/Abmp8BIQfIBg3SaWl50+Odju3rd+jfJh0sjA+WYVOWg2l9yYJpgyfNy9Fic4N2WcNAdyrdsv/RvIIu72JP1eXttV1j5XF5+gCWc4Uz0GvUr5UcUoa2uo1igEf6QG4zgsqRcPi2k8LFovts1GLeZIelrSl08txIlnlW9dGUjcdRyUK8
 UVl9FgBy
 YqxmzaV5jP0g52KSe6W3fy0S+uH6y9kQ2pXKZksxSFmcm1jz9IQn8tn6Ww1UKtIB/o1nu0AqwIIx2U3th2OzzX3h3JS2ft37LVrQhHX02a57tbmqObuNzqDvffslVSrTwndUoFacmFrl3esNCP5KJ0RI0bBJr2xfKFRGy2jtj+n0x+/nwpnmj/IeUpbD0qCZvXvZ3jHS2nojAf7H4vZSBDU9sLQekDbhhf6vmFkufuyQ1vAFjaQ+vBz4ReEx0Yhzm1h905gSV2AYgq1rYL5Wc+kvGJ3a6y5ZAojmgz83r7+2OsE4Rf6qOOHmCQ4tUYt8gc8YzqhmapeXslaZFkD2GSCi7kuuobIhv3HiodTVP33Hj331jQ8sA2t0BiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For what it's worth, I applied the full series and ran it through some
basic functional testing, I didn't see any bugs or regressions from
that.

Unfortunately, the best signal would be actually deploying it under
some real serving workloads, but the latency for me to do that + get
results is like order(weeks) and I suspect you don't want to wait that
long. :)

This particular commit looks good besides one minor nitpick:

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>

On Wed, Mar 18, 2026 at 7:19=E2=80=AFPM Chen Ridong <chenridong@huaweicloud=
.com> wrote:
>
>
>
> On 2026/3/18 3:08, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Merge commonly used code for counting evictable folios in a lruvec.
> >
> > No behavior change.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
>
> Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
>
> > ---
> >  mm/vmscan.c | 42 +++++++++++++++++-------------------------
> >  1 file changed, 17 insertions(+), 25 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 33287ba4a500..d7fc7f1fe06d 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4078,27 +4078,33 @@ static void set_initial_priority(struct pglist_=
data *pgdat, struct scan_control
> >       sc->priority =3D clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
> >  }
> >
> > -static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_contr=
ol *sc)
> > +static long lruvec_evictable_size(struct lruvec *lruvec, int swappines=
s)
> >  {

Since `total` is unsigned long, should this function likewise return
`unsigned long`? It seems ideal to avoid conversions unless there's a
good reason to do so.

> >       int gen, type, zone;
> > -     unsigned long total =3D 0;
> > -     int swappiness =3D get_swappiness(lruvec, sc);
> > +     unsigned long seq, total =3D 0;
> >       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> > -     struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> >       DEFINE_MAX_SEQ(lruvec);
> >       DEFINE_MIN_SEQ(lruvec);
> >
> >       for_each_evictable_type(type, swappiness) {
> > -             unsigned long seq;
> > -
> >               for (seq =3D min_seq[type]; seq <=3D max_seq; seq++) {
> >                       gen =3D lru_gen_from_seq(seq);
> > -
> >                       for (zone =3D 0; zone < MAX_NR_ZONES; zone++)
> >                               total +=3D max(READ_ONCE(lrugen->nr_pages=
[gen][type][zone]), 0L);
> >               }
> >       }
> >
> > +     return total;
> > +}
> > +
> > +static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_contr=
ol *sc)
> > +{
> > +     unsigned long total;
> > +     int swappiness =3D get_swappiness(lruvec, sc);
> > +     struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> > +
> > +     total =3D lruvec_evictable_size(lruvec, swappiness);
> > +
> >       /* whether the size is big enough to be helpful */
> >       return mem_cgroup_online(memcg) ? (total >> sc->priority) : total=
;
> >  }
> > @@ -4921,9 +4927,6 @@ static int evict_folios(unsigned long nr_to_scan,=
 struct lruvec *lruvec,
> >  static bool should_run_aging(struct lruvec *lruvec, unsigned long max_=
seq,
> >                            int swappiness, unsigned long *nr_to_scan)
> >  {
> > -     int gen, type, zone;
> > -     unsigned long size =3D 0;
> > -     struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> >       DEFINE_MIN_SEQ(lruvec);
> >
> >       *nr_to_scan =3D 0;
> > @@ -4931,18 +4934,7 @@ static bool should_run_aging(struct lruvec *lruv=
ec, unsigned long max_seq,
> >       if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_se=
q)
> >               return true;
> >
> > -     for_each_evictable_type(type, swappiness) {
> > -             unsigned long seq;
> > -
> > -             for (seq =3D min_seq[type]; seq <=3D max_seq; seq++) {
> > -                     gen =3D lru_gen_from_seq(seq);
> > -
> > -                     for (zone =3D 0; zone < MAX_NR_ZONES; zone++)
> > -                             size +=3D max(READ_ONCE(lrugen->nr_pages[=
gen][type][zone]), 0L);
> > -             }
> > -     }
> > -
> > -     *nr_to_scan =3D size;
> > +     *nr_to_scan =3D lruvec_evictable_size(lruvec, swappiness);
> >       /* better to run aging even though eviction is still possible */
> >       return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=
=3D max_seq;
> >  }
> > @@ -4954,7 +4946,7 @@ static bool should_run_aging(struct lruvec *lruve=
c, unsigned long max_seq,
> >   */
> >  static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control =
*sc, int swappiness)
> >  {
> > -     bool success;
> > +     bool need_aging;
>
> I have suffered a lot because of this name. Thank you.
>
> >       unsigned long nr_to_scan;
> >       struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> >       DEFINE_MAX_SEQ(lruvec);
> > @@ -4962,7 +4954,7 @@ static long get_nr_to_scan(struct lruvec *lruvec,=
 struct scan_control *sc, int s
> >       if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
> >               return -1;
> >
> > -     success =3D should_run_aging(lruvec, max_seq, swappiness, &nr_to_=
scan);
> > +     need_aging =3D should_run_aging(lruvec, max_seq, swappiness, &nr_=
to_scan);
> >
> >       /* try to scrape all its memory if this memcg was deleted */
> >       if (nr_to_scan && !mem_cgroup_online(memcg))
> > @@ -4971,7 +4963,7 @@ static long get_nr_to_scan(struct lruvec *lruvec,=
 struct scan_control *sc, int s
> >       nr_to_scan =3D apply_proportional_protection(memcg, sc, nr_to_sca=
n);
> >
> >       /* try to get away with not aging at the default priority */
> > -     if (!success || sc->priority =3D=3D DEF_PRIORITY)
> > +     if (!need_aging || sc->priority =3D=3D DEF_PRIORITY)
> >               return nr_to_scan >> sc->priority;
> >
> >       /* stop scanning this lruvec as it's low on cold folios */
> >
>
> --
> Best regards,
> Ridong
>

