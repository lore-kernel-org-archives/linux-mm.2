Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A823606A94F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lARir9k/
Received: by kanga.kvack.org (Postfix)
	id 9083B6B05D0; Tue,  3 Nov 2026 03:40:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B8426B05D1; Tue,  3 Nov 2026 03:40:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7AF6B05D2; Tue,  3 Nov 2026 03:40:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E9206B05D0
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:40:25 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44072A0350
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:40:24 +0000 (UTC)
X-FDA: 85393161168.20.4C47917
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 43234180009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:40:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="lARir9k/";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793695222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xyaSToYButot7G2W/IDarlTzf5GO2BwZdE95MRsey0E=;
	b=BvrOX4bet2Yi7cAksAbbPUi4/qDYWSk133i3e3Vv/UBWPXCZe9s2vXTkfSE2chvF4pBhWs
	q++xFupBQHRVVM+DP+cGAHilYdtm5+3TIjvO7VIKsNY5MxRz9tYlRJQY1wYEDnVgJRXmNr
	D8NvM74ps+wcvCp82r1GRaBSnLSH3IA=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="lARir9k/";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793695222;
	b=QQ6MCDnQzXj9GEN5X3XoqAPHRCNoUJvp6GgXjDRQuPk+9OgTudtoWb/ixlqtpPV/D3Oq+3
	H/NIDxOtmwp8I/Nkj7GreImIYjQ2TWRz3wcnwVTCgaVSoecmE9pj0AGu4PlJevhWZYyuFd
	UoR8weEuMGVVPgwBdwqefy/iKev50Gs=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso43362955e9.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 00:40:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793695221; cv=none;
        d=google.com; s=arc-20260327;
        b=UGZfqXUw6HAgCyM325nD1vsYi5Qtua52lr3nBuvLB34bm27Y5xADlhJIxTkSZP5L9o
         nw5IZNY7oG676AK1EYdv3pUrPetExOubFb/jMVeffs+p3Gm2t/H/po8+VD4D1G609NLu
         aeZtPszqek0SoNR5dk4TRykBNcM0jpSd6+yJ+tQ8ueAfSbgNFcpDFQhtnR+9CrFB7ji+
         n0Vwj/LDmcitIjwUVL4CCNuJEY5biJmjx4KCtSG03QcTZ3dXPWjNNLXshMHT+4Ey4faX
         YaaYG6nayGyZTCyUOBR/w2/ozKUa42oRW0LqOO4+Qyk0TCfDaKa2Qj9QfNT4+VvuIefJ
         LeaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xyaSToYButot7G2W/IDarlTzf5GO2BwZdE95MRsey0E=;
        fh=3e7qRu1Y8ai+7Bts4+2KDoq6p8SVGjxXGAy9B2rAC3o=;
        b=aNKiW1Y40kPqkfJlqxyAlJjq4cx6+5OCa/gT+TwPqh2Vs6dXTMd8yRABvzX7Ra9ZDI
         +LsLJzFeiPnzwZuXaLOSiEaFHToiZAXHxPuv6543xNmvqJIqIriMQvpf92+6M/DfJm86
         3FNHitio5Q/RMLUJxLaiMqCTCxwtKVYqiZ0cOj4fP1/J/d5SVT0ZhV1N+PC66wkZWHJ3
         cIIORhY9cxYbLP5sXlly4wQb/k4unPWMGh3cQb5GxaL0GK7MrwsiIlo0tsBnuFuvf5xK
         BOJHPGWjlEW3mRxtKJCHfbABvoG5k1ZxgG99D0BRCKllYTuPnZ8C6DgCjYhtAFukrlDq
         ZhUA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793695221; x=1794300021; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xyaSToYButot7G2W/IDarlTzf5GO2BwZdE95MRsey0E=;
        b=lARir9k/Ufusp6ckj79leT2pSeVfELbjX+3cALAq7fNpNflsdQs/IsbTmTy51mc4es
         RPpJt/XkzDdVVXjxINIi1ffBY+ecM43QXlfk9wtce/EauHoVaPSgtJY6LME8ur5DV5vJ
         V44AP6XOZO/0FxCsRXyBJz9879KlK68RLK+oBsjxnwZUyV0LW04B+kvggvuzDXp3Hkpa
         ECVy7nVI4WiA2BIPRDsso2tJ3N2ADtszB12mzltIFGalHPAjv7/ECAFhSbXioNfi/kHA
         pHVpmFl68e3DhCjHkQVYZ42lg6f2LY0RumqKGhjpwce/St4rJR+nGPZEYGVsZjt4Spgs
         LmLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793695221; x=1794300021;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xyaSToYButot7G2W/IDarlTzf5GO2BwZdE95MRsey0E=;
        b=B7xAYgd2p0RUVUY1uPik8O+p2m9/yY/25kbJdl1NIkyKocSeo04zOt/5ff+HEVNXrR
         YZsO0hvMEr7G2Dn0PjevBIxL/I8ST2MB3swkFyynQPod7qeqx21saA1levoX0+g4DDz1
         GJ2sjdxIwKwfrZJeaq1K4YEOxY8pTs2AFeqKZDTRyzGTtdfzSQLsdR7vzrfcKr+J6dMA
         NCoeDc0AwxLHz1/Zf3RCDMkZUchKIoss0tf73qQ++njfBsDgAjF6JwCFEDbGIadcMvTm
         OoNYhuOnV1yyc3srDa2yyQLcZnpBLoj6sG/S5K1Pe7lNJLV94WTQXEc9vJam23w5JUN4
         8prA==
X-Forwarded-Encrypted: i=1; AKwUvBw5BrdOvFPMAygwKLdDe0r1fU21BdamLm2O3E3JwF7poNuSAm1p00Sdo91M+2ZBZjTCfFe/sMq07Q==@kvack.org
X-Gm-Message-State: APuU4Z99Faj1OLUj1Nlbq2iOMmo9TgC/BXIoWhaeIKu76XTQm+i/tVRM
	rG71DVhhre+ASDcCZSZifc5VETJzcY2TrxUUmMQIQgljGRIJ25Mi0ieeBxhfmNLGPOgTt2WvAmi
	q0Skj9RY5+/r2gy3Gyjo3xaryEAPwR5w=
X-Gm-Gg: AYBFou0ZCag8QlQCBmY5WCPcwrMYK3YJ98mDZWf4ypp8PF94WPRaDQejBnI2QLy1Egn
	rrUNhQ07FZON+nfXfdLgeK1qkbGraBSk3LYyZkQBF7f4ZqMxYgnrSNFRk+S8ULVqQ0lGyJPqiIO
	fyBMmqeukNNdegc4RlQbak+qpvmmFzmO7nn5ZoqA2nwsfsB/dR+THr0Sk20854H8J1GKK2U5T5M
	lXIqT7cdVp9zZeJ80oLGmYc+IYX1Ppz17SeMkotj9ybJDMAtABhtMuJw6Klut+disZ2jMVxRzv5
	7aAAT/p/GKMMJyJGvbumvuyF44s4AbPK8SHhKnlUufM7M1el5EZlPv7Gavua1W4mEXdEnyl+/Dm
	QPbW0tsW4vXWqWS3EX1ZD9YP/zluf1kDSWmNgM6KE8te0EN8JSPDBFMTiThJAfn9X85G+ngk=
X-Received: by 2002:a05:600c:4f82:b0:4a1:e92b:ae4a with SMTP id
 5b1f17b1804b1-4ac1889d525mr259315445e9.21.1793695220188; Tue, 03 Nov 2026
 00:40:20 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022220203.91911-1-baohua@kernel.org> <20261022220203.91911-9-baohua@kernel.org>
 <sashiko-outbox-183274@kernel.org> <CAMgjq7DjYS01BQAWnr=EdbhM1gbX+K+pXM6z04UEKg_NLU3CNw@mail.gmail.com>
In-Reply-To: <CAMgjq7DjYS01BQAWnr=EdbhM1gbX+K+pXM6z04UEKg_NLU3CNw@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Tue, 3 Nov 2026 16:40:08 +0800
X-Gm-Features: AclHuK_DPE7MUhj0Pm7VEX8dloQMmjTTCcJJc1QEhmoeYFhGDxuV_2DIy0Ds_8w
Message-ID: <CAN_Opa-dh59YjHOLNKy2MrXiq2SvdFCsCwz=niF5TyMYvxR5nw@mail.gmail.com>
Subject: Re: [RFC PATCH v5 08/14] mm/mglru: lift youngest gen protection for
 higher priority
To: Kairui Song <ryncsn@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, "Barry Song (Xiaomi)" <baohua@kernel.org>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, hui.zhu@linux.dev, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, david@kernel.org, 
	hannes@cmpxchg.org, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com, 
	zhuhui@kylinos.cn, baoquan.he@linux.dev, liuxiang.277@bytedance.com, 
	wangzicheng@honor.com, lianux.mm@gmail.com, liam@infradead.org, 
	surenb@google.com, mhocko@suse.com, rppt@kernel.org, zhangbo56@xiaomi.com, 
	lyugaofei@xiaomi.com, ridong.chen@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 43234180009
X-Stat-Signature: mpeq81ex58gdwsrbmap1yhipq46jo1cd
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793695222-269255
X-HE-Meta: U2FsdGVkX19ooFo/Q9WZ+/O1U5jZW6ncHR0RYVJs+fBgd1qqyqLg9FecBqsAQI4dWmf2gk5RT1itKV9XXpey4eEzsr1TXNd4/Zf9IaeXlyiRnaEtgVBpUe/dpX+VKgnOAQrJ4rClf64YheB1uw15U53RBUScx7HVB4hH4+fDz2SA6COH9qS3wO26mJlW6hbUyUlNpffv2scpSOxkV93SfnDLA5K04TCqKD+C+GKIxoM2rQnduoQPNeavP+U+5XwP0uZIsbJEna2f1w3NXIglvWktHj/60Xp250eqJt7/RPsEUGk55kxtMdBUmSOSrlLe5NrDG7CBnjewQN3IoHpvRoakwTxjG0fDqZqP9mZ5ygOkZ4yzgpzM11vIwe45Cme/LsKjt25Fk/dz7eC7XZL3IKCVPeHR4GJ4q422ZjlL8M6XjngudYnAr0g430npL/h6rynCdsUhVdfw3LAF7kM5hIJH5z/r4H33KItp6+3VTFFCP9D6ryp86QNK3P9jppHCmHIcTP11XrLA1uzjn091mi/MYfgZSFrFBKJteLncZFIv6g2BQe9le3i06mK7ozeJOatzOMMATLuUFSa4mip01mjGCpvAse3BgXt11ScSXix9gu1lWpvD3UtmbQrrxgcn/IeWyVn5tTWlfNYTlF6mrItGfHvoz+Mxt6jg7YifZcFll2MtleJbmGDOsW3urbDy+6ibYa9QcFSMz0huVLHZ7Cecltpbxc8ydCcu5RVrC0pAl+KWAwetDZwIv5llbyyBGxeTrcLEX8TG0lXUl711LnvOzROwYkAQND8R/y8L9t22n2IhahcXvo9Ym+c7G2as3zSDQSKgEgC1oERf3HUzX0BPyjhoqBwdpkssg+nzrHTQHeV8mq2ggiMGYiO++gXDMYYsCdfTSbFh8ZLcJkqHIUoVwYxYRdhhJMsJ/CZIR+pfQKkLyxFrNQpxAU1fcMFxQDBcj1bwBgnTm41oEIT
 WS8mHFvg
 bihcT1LMNF36p8B2d+5DcRicV//bI7RQHi5gWkegFQYlLu2n4vbNav/gpWIGyk/h15K+GkbzbLqnjY7I8fdQ4/pwQpVl5lMeaQOgC5/hA7CkdwqSAsX3EKSlqgpgvQ3tScjLx6fMwW0bhIuEZlJzzltWx6zsJF66MqdEnPFNxch3nNT2RA+cjNTIt5JC7lQNZTtQtWn3nE3Vq55JakxsvWpc/CvPJ3JIdMOnf5UFg1PDy70PgH8ViN6e9nnLT95eyHXx1hq4rb8zNjtz4mx+mo/wQYxWPAjK2xpX84FJOUq/zXhXRnGC5eXLvZlY1E1oMrLSX3wkA8XcSCNGzi8lCDK9qlcMEtjIGQxUEIF5/x0ecTFKx0q0i1D6InisF9dhRTH6On/n5b+bG25sfJJQpAJ5thf+VAtS8J+CSgkecxONMqUu3kb/2LRxJapTfGRWi/cS12XnhxIqaKn+mb0OnHh9x0z36s8m6+KMI1gKN6NjRYfjd0+LaaGeqiUDL/mIcZtAJXOoW0ZyYhGTwRAwNBboeHhnRhTZlsLF2NV3ypCoJye4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 25, 2026 at 2:09=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sat, Oct 24, 2026 at 6:03=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
> >
> > Thank you for your contribution! Sashiko AI review found 1 potential is=
sue(s) to consider:
> > - [Medium] mm/mglru: scan_folios() scans expired gen < min_seq at DEF_P=
RIORITY
> > --
> >
> > commit 1329290ce5f86b7de9b77d6b22e4b265f16348ae
> > Author: Kairui Song <kasong@tencent.com>
> >
> > mm/mglru: lift youngest gen protection for higher priority
> >
> > This commit adjusts scan_folios() in mm/vmscan.c to choose the target
> > generation sequence number based on reclaim priority rather than using
> > lrugen->min_seq[type] at default priority. It aims to protect younger
> > generations at default priority while allowing higher-priority reclaim =
to
> > scan newer generations step by step.
> >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index fed39b0422e01..d1e14001f9346 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -4930,12 +4930,14 @@ static int scan_folios(unsigned long nr_to_sc=
an, struct lruvec *lruvec,
> > >       VM_WARN_ON_ONCE(!list_empty(list));
> > >
> > >       /*
> > > -      * Respect the gen hotness distribution at low priority to avoi=
d
> > > -      * aging and scan cost, but prefer to satisfy the reclaimers re=
quest
> > > -      * when under pressure to respect swappiness more and reduce IO=
 cost.
> > > +      * Respect hotness at default priority, and only reach into the
> > > +      * newest generation when under severe pressure, so hot folios =
are
> > > +      * not evicted as soon as priority is raised.
> > >        */
> > >       if (sc->priority =3D=3D DEF_PRIORITY)
> > > -             seq =3D lrugen->min_seq[type];
> > > +             seq =3D lrugen->max_seq - MIN_NR_GENS;
> > > +     else if (sc->priority > DEF_PRIORITY / 2)
> > > +             seq =3D lrugen->max_seq - 1;
> > >       else
> > >               seq =3D lrugen->max_seq;
> > >
> >
> > [Severity: Medium]
> > Can this cause scan_folios() in mm/vmscan.c to scan an already-evicted
> > generation when a type only has the minimum number of generations left?
> >
> > In try_to_shrink_lruvec() -> evict_folio_lists() -> evict_folios() ->
> > scan_folios() at default priority, when get_nr_gens(lruvec, type) is at=
 the
> > minimum (2 generations), lrugen->min_seq[type] is lrugen->max_seq - 1, =
while
> > scan_folios() sets seq to lrugen->max_seq - 2 and passes it as max_seq =
to
> > lruvec_populated_min_seq():
> >
> > mm/vmscan.c:scan_folios() {
> >         if (sc->priority =3D=3D DEF_PRIORITY)
> >                 seq =3D lrugen->max_seq - MIN_NR_GENS;
> >         ...
> >         seq =3D lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx =
+ 1, seq);
> >         gen =3D lru_gen_from_seq(seq);
> > }
> >
> > In lruvec_populated_min_seq(), because min_seq (lrugen->max_seq - 1) is
> > greater than max_seq (lrugen->max_seq - 2), the while loop is skipped a=
nd
> > max_seq is returned directly:
> >
> > mm/vmscan.c:lruvec_populated_min_seq() {
> >         min_seq =3D READ_ONCE(lrugen->min_seq[type]);
> >         while (min_seq <=3D max_seq) {
> >                 gen =3D lru_gen_from_seq(min_seq);
> >                 for (zone =3D 0; zone < zone_limit; zone++) {
> >                         if (!list_empty(&lrugen->folios[gen][type][zone=
]))
> >                                 return min_seq;
> >                 }
> >                 min_seq++;
> >         }
> >
> >         return max_seq;
> > }
> >
> > When scan_folios() previously scanned younger generations (lrugen->max_=
seq - 1
> > or lrugen->max_seq) at elevated priority while get_nr_gens(lruvec, type=
) had
> > fewer than the maximum number of generations, sort_folio() can move fol=
ios
> > with a stale folio_lru_gen() value (such as after __lru_gen_reparent_me=
mcg()
> > or when inc_min_seq() skipped draining old_gen) into that expired
> > lrugen->folios[gen][type][zone] list:
> >
> > mm/vmscan.c:sort_folio() {
> >         /* promoted, or moved due to reparenting. */
> >         if (gen !=3D min_gen) {
> >                 list_move(&folio->lru, &lrugen->folios[gen][type][zone]=
);
> >                 return true;
> >         }
> > }
> >
> > A subsequent default-priority call to scan_folios() will then visit tha=
t
> > expired generation (< lrugen->min_seq[type]) and corrupt active/inactiv=
e size
> > accounting.
> >
> > In addition, in lru_gen_seq_write() -> run_cmd() -> run_eviction(), deb=
ugfs
> > eviction runs at default priority. If a user requests evicting up to
> > lrugen->max_seq - 3 when four generations exist and one type has alread=
y
> > emptied lrugen->max_seq - 3 while the other type still has min_seq at
> > lrugen->max_seq - 3, wouldn't setting seq to lrugen->max_seq - 2 in
> > scan_folios() evict folios from generation lrugen->max_seq - 2, exceedi=
ng the
> > requested seq bound?
> >
>
> Looks a false positive, though it is tricky. A folio on a generation
> list is only ever promoted, and min_seq[type] is advanced only after
> the old generation has been drained by inc_min_seq() or verified empty
> by try_to_inc_min_seq(). So when a type is down to MIN_NR_GENS, the
> max_seq - MIN_NR_GENS target is empty, not a populated expired
> generation. Lazy folio flags and the non evictable skip can create
> temporary skew, and reparenting can look odd across generations, but
> that skew is transient and cannot survive until a DEF_PRIORITY scan
> targets that generation. sort_folio() also refuses to promote from the
> last live generation.
>
> For the debugfs case, lruvec_populated_min_seq() starts from
> min_seq[type], so the type with min_seq =3D=3D max_seq - 3 scans max_seq =
-
> 3 while that generation is populated. The type already at max_seq - 2
> was scanned at max_seq - 2 before this patch too. Not enforcing the
> requested seq per type is a separate pre-existing debugfs issue, not
> caused by this change.

I traced this and agree with Kairui:
the gen below min_seq[type] is always empty because inc_min_seq()
drains it entirely before min_seq advances, and try_to_inc_min_seq()
verifies emptiness before advancing past it.

The transient skew from reparenting cannot persist until a DEF_PRIORITY
scan targets that gen. False positive.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

