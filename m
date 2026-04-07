Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1729105D98A
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 23:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C9206B0088; Tue,  7 Apr 2026 19:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A1996B0089; Tue,  7 Apr 2026 19:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9386B008A; Tue,  7 Apr 2026 19:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DE7F56B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 19:00:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E27B1B8E0D
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 23:00:33 +0000 (UTC)
X-FDA: 84633280746.27.C39F4CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 644651C0017
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 23:00:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N6VNSKvR;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775602831; a=rsa-sha256;
	cv=none;
	b=nH+kMCoI1etCcG7+xGk0FX+kb0aigQDFYbOJkuvxrXFUJZI7f1JPk1goTvHUIIZYSO5mUE
	VAyH8S4n9/YPJQRB2sBR5oSRwjLQSKr5wxx6TB59G2kFmy4HTCza8w7w6cef5DFb6siTpN
	sPfHTisPzpgXDamBcqVhQ3SZ9F/WgGE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775602831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HET5hJmoUonxeOKRNkcO45gduQNISxOyuHxsdJOzLOY=;
	b=SHhKo14cuj1T8fewEoAQoGzS5nsDfJXLfYMqwDKOu2ka9ldAWsNRklR8QaZbHIGJoWqCwe
	DiCND86jvxfECEwtW3s1nnrWH2hth/y7+rGk3PlgK05FAajicHI6Sg5Qtfyg2RUHybxsbs
	FWQ+JGGxR4oFXSByupRyJuz6a2aKigk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N6VNSKvR;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 34B8C44535
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 23:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129A8C2BCC4
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 23:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775602830;
	bh=jkF6LsPqU12jwyxFfypEKWSkg3vXsh5cayrxCNLp5i0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=N6VNSKvROEaExx1bmqctO6GSFjzHjZ61bxsG+Jau7BNti7eUcF7P7xprNrn03/0jq
	 lhn0anmZJClQoH/hT0PoO5u+VMrbAqtinURrFwgNNAZEhBa1+ALUYZC30gQBJkQyZP
	 SlzhGpFKiRKaGqgWSo9JqCfhpp+6ILkXIp17WzwSnuc+iCe20DSjAho4EcQSI1VxEZ
	 zb53N7FnEcmdc5c92s8lD2obmOsfEhAjFFmWW1cvqmziykdgsW1T/vtgq3AxqIOQeB
	 Sr0smbUY/mRoYvlvmdhCp5EAUu5qE1pUk20d4zDVicchRux/1pqhmQwy+XTy0FHSvT
	 vIsTY1UOi66qg==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8cfc3ca1922so40532085a.1
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 16:00:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWgQXEGfNrKlC6uJldpbGe9R1xbrXcxufqZbSmE+ORYnJeUqWBVWZ3J/jFX4J3LNvAD01iGv+UkYQ==@kvack.org
X-Gm-Message-State: AOJu0YzE+87tPiop5gyyOLheMXLdJfe974+7bU0TbZTCVdPhKBFGEth8
	KTtOil2WvbEXrwYPUmQdEslKVLk2rpheUv/SOUoRv4olYxrg4cNjPlVwitsbwoxqNIqdQ+OyU99
	87XUuEMLBEsDiJNrjgHMHggGhjVRlmHs=
X-Received: by 2002:a05:6214:d88:b0:89c:ceaa:872c with SMTP id
 6a1803df08f44-8a5eb81bfa4mr340853426d6.13.1775602829252; Tue, 07 Apr 2026
 16:00:29 -0700 (PDT)
MIME-Version: 1.0
References: <7829b070df1b405dbc97dd6a028d8c8a@honor.com> <4451bdc432864aebb54f401eee51ea53@honor.com>
 <adUM54W3WYwEFj3J@KASONG-MC4>
In-Reply-To: <adUM54W3WYwEFj3J@KASONG-MC4>
From: Barry Song <baohua@kernel.org>
Date: Wed, 8 Apr 2026 07:00:17 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yZHjSq=d1g7dJC9szwRVLuHqLpWt0Cphi7npzrQz6p3g@mail.gmail.com>
X-Gm-Features: AQROBzBw61WCRWk6P8DZuUdQL5lNNdSj2p4e9VUuuyVH9SFPZTUX1jhf5ktw68A
Message-ID: <CAGsJ_4yZHjSq=d1g7dJC9szwRVLuHqLpWt0Cphi7npzrQz6p3g@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/vmscan:Fix the hot/cold inversion when swappiness
 = 0 or 201
To: Kairui Song <ryncsn@gmail.com>
Cc: wangzhen <wangzhen5@honor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"kasong@tencent.com" <kasong@tencent.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 644651C0017
X-Stat-Signature: racd1hifpuhj8jpqsttwzew7fyje9tdo
X-HE-Tag: 1775602831-6283
X-HE-Meta: U2FsdGVkX19zWnYX0VYsguQMJ5mTYCQPVGNhwZj8IaAwLPhfKDo9c51KksEVCmnXjbdJvNGMX9DXLlbUpleh4c6CM91pDBFV9Q3zw4uIzYLTjQBNOqPWmFWM+8O/Ma4KhwcLeOud8QqsrCOS+XH4/I4y2MwitduxzLoQtE4pcbaD5adOBSoUiAcPqM8/Tj3ZDE9wOoV4AZwe0wstX1zwvIXDzAUHPtpMJXTePWlOgOzvPgJ19pCwj/St+bjHLeg6vLH1Sa/3HLIU03AZ3xd8oXAM467oTodrPkaZTGcm3wFgam2qCoQyXPVyr4YBRdJ7AxnKA3cQeEWVrMLIVIwpfJh5M967UD38Uf8AshojwykY4CvwYuWKohTVVoOdFOGMz4+/gtDBRfbzdrLjSD8anHzROd3SQNTiyCan+gju9h5VbGJr9kD1OwjRmhEG/pKkxle19o7oAeE53/abZUpljIwf8y7ZK6+cW9UVU7GE+sJTTlZojFnKEDbXIHIO638PqqL1OIaSqCtBRh5twZ1mO323PoPUr9K426AeBeXkXwu8zo9ew64SY6zUA2IRDvEWwFZY2RVcjCSDqVRSUZYUwjL2WRUGJ7m9iAJuxLgWBFNIJCifGppPh3lonY0nuF69R1loCV3XL72WsUaoHFsdw7OsTDC+0q/p4qJUrx6C/dW0DQe+8/ewH+lTci/99TC80kMUXGt3QJTBSO3ve+PdBO0u1jsBXIW8ld/pbMKJexuw8AlpRFXdeX+nnD03nePKNLlXUp0mivjeN8qKzZ2nr2g/0RUvDZP2EaX27dmzTHv5jsJOwrgBaRa5e/T3Uvx57zMGElKz6mLW/BV27+W4XT1sL3siqUXJqC/4c1zJvx8D6WDqkvANT6P/FvjYtTmm0oMPvcLfvO3FHy5Xqkd+VrHjNKEvxtryIPamJu5ifHMWUPNME6HcEbdaXfGAHciGVZEZ67QLMVLawhl+Jcp
 cPsY7mzh
 kcF0LFEDn6EZ7z4DyjnJ0+qO+tzCrfC+nkP162i1iu63uZ9gMQa3/c3d/mcHEm3TL3seMA3QdHKJsQvYwphCUDCDqKnDz0/jftYRV5zRTw7hy/55nZCSoAKOv8onrzFGZGNfYH8d2s5fDkqVDiZRcxg7hLkk9hUl/AKq2u8cENzfq8kHBjEj31ntgIAtECqa3mfQw6y/5HLUTTUsvt4h9bUEW3zWDslmKH5lz3XosX6YKSDwnaYU4ehckMMOQ8cngFrucKq53hokNjf0OBgIFNiz1deXdXNIP+H5fi4HSfM6HTloZ45o1JM8GqKFVyzoyB/eBx4Z/Y1kuMhSitjVEd9YnYVO4F6G13RIrf+TfRDcOoQZfBdyUgb3jU3nRYqF9ubmroMngixb5JSccueaLLZxeiRZUsGUxxS1L23GLYNT3e4U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 7, 2026 at 10:26=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Apr 07, 2026 at 01:37:08PM +0800, wangzhen wrote:
> > >From ac731b061f152cba05b9aa351652a04f933986e0 Mon Sep 17 00:00:00 2001
> > From: w00021541 <wangzhen5@hihonor.com>
> > Date: Tue, 7 Apr 2026 16:17:53 +0800
> > Subject: [PATCH RFC] mm/vmscan:Fix the hot/cold inversion when swappine=
ss =3D 0  or 201
> >
> > In some cases, when swappiness is set to 0 or 201, the oldest generatio=
n pages will be changed to the newest generation incorrectly.
> >
> > Consider the following aging scenario:
> > MAX_NR_GENS=3D4, MIN_NR_GENS=3D2, swappiness=3D201, 3 anon gens, 4 file=
 gens.
> > 1. When swappiness =3D 201, should_run_aging will only check anon type.
> > should_run_aging return true.
> > 2. In inc_max_seq, if the anon and file type have MAX_NR_GENS, inc_min_=
seq will move the oldest generation pages to the second oldest to prepare f=
or increasing max_seq.
> > Here, the file type will enter inc_min_seq.
> > 3. In inc_min_seq, first goto is true, the pages migration was skipped,=
 resulting in the inversion of cold/hot pages.
> >
> > In fact, when MAX_NR_GENS=3D4 and MIN_NR_GENS=3D2, the for loop after t=
he goto is unreachable.
> >
> > Consider the code in inc_max_seq:
> > if (get_nr_gens(lruvec, type) ! =3D MAX_NR_GENS)
> >     continue;
> > This means that only get_nr_gens=3D=3D4 can enter the inc_min_seq.
> >
> > Discuss the swappiness in three different scenarios:
> > 1<=3Dswappiness<=3D200:
> > If should_run_aging returns true, both anon and file types must satisfy=
 get_nr_gens<=3D3, indicating that no type satisfies get_nr_gens=3D=3DMAX_N=
R_GENS.
> > Therefore, both cannot enter inc_min_seq.
> >
> > swappiness=3D201:
> > If should_run_aging returns true, the anon type must satisfy get_nr_gen=
s<=3D3. Only file type can satisfy get_nr_gens=3D=3DMAX_NR_GENS.
> > After entering inc_min_seq, type && (swappiness =3D=3D SWAPPINESS_ANON_=
ONLY) is true, the for loop will be skipped.
> >
> > swappiness=3D0:
> > Same as swappiness=3D201
> >
> > so the two goto statements should be removed. This ensures that when sw=
appiness=3D0 or 201, the oldest generation pages are correctly promoted to =
the second oldest generation.
> > (When 1<=3D swappiness<=3D200, only both anon and file types get_nr_gen=
s<=3D3 will age, preventing the inversion of hot/cold pages).
> >
> > Signed-off-by: w00021541 <wangzhen5@hihonor.com>
> > ---
> >  mm/vmscan.c | 14 +++-----------
> >  1 file changed, 3 insertions(+), 11 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 0fc9373e8251..54c835b07d3e 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3843,7 +3843,7 @@ static void clear_mm_walk(void)
> >               kfree(walk);
> >  }
> >
> > -static bool inc_min_seq(struct lruvec *lruvec, int type, int swappines=
s)
> > +static bool inc_min_seq(struct lruvec *lruvec, int type)
> >  {
> >       int zone;
> >       int remaining =3D MAX_LRU_BATCH;
> > @@ -3851,14 +3851,6 @@ static bool inc_min_seq(struct lruvec *lruvec, i=
nt type, int swappiness)
> >       int hist =3D lru_hist_from_seq(lrugen->min_seq[type]);
> >       int new_gen, old_gen =3D lru_gen_from_seq(lrugen->min_seq[type]);
> >
> > -     /* For file type, skip the check if swappiness is anon only */
> > -     if (type && (swappiness =3D=3D SWAPPINESS_ANON_ONLY))
> > -             goto done;
> > -
> > -     /* For anon type, skip the check if swappiness is zero (file only=
) */
> > -     if (!type && !swappiness)
> > -             goto done;
> > -
>
> Hi, thanks for the patch.
>
> We have a very similar patch internally, and the result is kind of bad.
>
> Currently MGLRU forbid the gen distance between file and anon go larger
> than 2, which mean with this patch, when under great pressure, you may
> have to keep rotating a long list of the opposite type of folios to
> reclaim another type.
>
> For example, when you have only 2 gens of file folios, swap disabled,
> and there are 3 gens of anon folios. Anon folios are unevictable because
> there is no SWAP. And file is also unevcitable due to force protection
> of gen. Consider anon folios are mostly cold (at least a portion of them
> are), now the oldest gen of anon folios will be very long (e.g. 12G,
> 3145728 folios).
>
> Now, to reclaim any file folios, you have to age first. Before this
> patch that is usually fast. But after this, it will have to rotate
> all 3145728 folios to second oldest anon gen, will could take a
> very long time.
>
> During that period any concurrent reclaimer will get rejected
> due to force protection, result in very ugly long tailing or
> unexpected OOM.
>
> So I agree this is a good idea in general, I agree we should do
> this. But better defer this until we patch up MGLRU to remove
> the force protection first.

I suspect that once we can age file and anonymous pages
separately, this issue will resolve itself. David already has
some code for this [1].

Not sure when he will have time to push it upstream, but I
may carve out some time to take care of it this month.

[1] https://lore.kernel.org/linux-mm/aam5nOyXs1sNdjTe@google.com/

>
> But I think it might be reasonable to remove the SWAPPINESS_ANON_ONLY
> limit now, that can only be triggered by proactive reclaim
> which would tolerate long tailing and won't cause OOM.

It may be better to defer both cases until file and anonymous
pages can be aged separately.

Thanks
Barry

