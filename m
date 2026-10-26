Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B99606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 07:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UsTSCXzR
Received: by kanga.kvack.org (Postfix)
	id 66BC16B05B0; Mon, 26 Oct 2026 03:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61C676B05B1; Mon, 26 Oct 2026 03:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532776B05B2; Mon, 26 Oct 2026 03:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 301936B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 03:34:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 93719160454
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:34:52 +0000 (UTC)
X-FDA: 85363965624.23.41C3A62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id A9905160005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:34:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UsTSCXzR;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793000090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eCp7793YU+XpI2dR52kKJJUrJruoufr3s1+FAGOxksY=;
	b=3XmblHmsgGQMok2Zbbft15JuKkrebfgqmbhW5eeo/Jf4NF9DEwsbB94+z0DQ9Iuj3OYGlc
	PL0RcoC9WMMdiZzJxaSsZ3PkxPEGNkuNOFx/uwzSpRMQtLB0klP8j7LIaonI7pYjBMqh4E
	GxAnQ/zfWVdZFYTHCu59pxjfZFpjp3g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793000090;
	b=E26WIMyQvlRCmk4BAcCe2ebi1B1Kt7q5ApTGf5r6Y6eq2oaCd4mK8Dl/Cze5d45xev1VSN
	9h8sjmWAKrbzNFHRHELnoqRvyEVCfycsTu+AQyoeacrj34QsJOpzUtrjRAR3HuNxULOu/T
	MSNYlS1hQpUG4ZT5QfgCMFrB6l4RNQU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UsTSCXzR;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D20F643B24
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B626C1F031EA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793000089;
	bh=eCp7793YU+XpI2dR52kKJJUrJruoufr3s1+FAGOxksY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UsTSCXzR+/RjF9VnjyyhN4i1jTHMUDayGFUMfG8dnQNxw09izDNW4bne3+DM3nr9c
	 WMdFJuuokskdhoWpwWdUD66xtgYNT3ilRBItkcgwr6m6AxyajJp5N8EWgmZgUpjzz1
	 mNgKinnthCD6R2XbLcRJPInGLiuMhMDyO5z0Dl+CfeWlluxg2yqLGv/OzsmxYuq0/8
	 PECJpBocY4XFWFeFQuH5Ci29f1+UDyvpcck0kGjhTkVBzZU+0oAnH24bqslIlq8TNM
	 G8va/Znm4XrSCLC6OzMNFGj4KkC58shzmD2A/FieYhVzRSsyYRL+2zkWeS9yoEAtxB
	 BKUQ14ERwuGug==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93f36c18b75so133526485a.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 00:34:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBziwLgyPddufGEvbePbDu23TiGcIH3hsXsx56gpIrlwpBKWHbZ/D+iGsFa7OztB9wyki4c7Z32roQ==@kvack.org
X-Gm-Message-State: AFq9FYKCLa58SM2MzLS3EwjznY1dWifhZHuQZQBAcoXunphXwEp/FA0X
	lXMFHg9B0rJRu0LyLCxEK9LMdE3hwFW04ZJWHCIYBwYiH3qBSuiA226nzlrhvwWBKzt6+MrAH5s
	hpl5eqRkeOdJnfxEgH7tf06ku7TEhiko=
X-Received: by 2002:a05:620a:458e:b0:93c:b7f3:9f5b with SMTP id
 af79cd13be357-940ef95515fmr961429385a.45.1793000089011; Mon, 26 Oct 2026
 00:34:49 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022220203.91911-1-baohua@kernel.org> <20261022220203.91911-8-baohua@kernel.org>
 <sashiko-outbox-183273@kernel.org> <CAMgjq7AZF4R8voNhsbj5Ede7NR19k1tkAMGnn7556ydB2ERX5A@mail.gmail.com>
In-Reply-To: <CAMgjq7AZF4R8voNhsbj5Ede7NR19k1tkAMGnn7556ydB2ERX5A@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 26 Oct 2026 15:34:38 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zObH8KOzRL77+oPgp5Scu9fJuV7Q5_8=qDVMERA_t+1w@mail.gmail.com>
X-Gm-Features: AclHuK8HIHYePZwSi4ORH8Tu8XMTrLkYqZE4DswlO9WKZxuNsXLsRQwzbO4Fx3c
Message-ID: <CAGsJ_4zObH8KOzRL77+oPgp5Scu9fJuV7Q5_8=qDVMERA_t+1w@mail.gmail.com>
Subject: Re: [RFC PATCH v5 07/14] mm/mglru: balance anon and file scan budget
 by refault rate
To: Kairui Song <ryncsn@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, hui.zhu@linux.dev, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, david@kernel.org, hannes@cmpxchg.org, 
	ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	weixugc@google.com, yuanchu@google.com, zhuhui@kylinos.cn, 
	baoquan.he@linux.dev, liuxiang.277@bytedance.com, wangzicheng@honor.com, 
	lianux.mm@gmail.com, liam@infradead.org, surenb@google.com, mhocko@suse.com, 
	rppt@kernel.org, zhangbo56@xiaomi.com, lyugaofei@xiaomi.com, 
	ridong.chen@linux.dev, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A9905160005
X-Stat-Signature: 9b1qzccyrjeg8ky34673fcfm9f8dokwe
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793000090-272673
X-HE-Meta: U2FsdGVkX1/o51CgpDKurBb4OgRSAfKaZKyuYwGuXG0eOXbX1W+PJEDj54tGwAX/aven5ROVxxw2/PaiohNkPjHUazrcCmOZ3zLs5W3yxBBEWfMCyvasrhYkHAHdr6H4ks2EYZc1kiTN53vLZ8d3kgJOzHDGMFK9T0MXRFl7Uvdtox9r3NYWLhE2WyCq89POd2h4D2nuCW6fnbversnwCc+s35ha7xkruPdgXPL62baXKOpG8vSeSpUUygHAj45x6XnI5IOD29TmAbsMRhfvSbNa+vmmOKuc6y77BhjBKvTlEJ9UW9Ti28qoI/mRxjCfZpRyHs74eyszJhL20a9t4yKekjCPn9UFnzonjQ4Wd++If+aQzB+cQAKzuXR2puXmx7g+MYp4gwen3coW0C3N7mCflW0I3djsZwbfm6ZsDcPZYpTPzwJjva97AtzZuc8ge4zJ43qAZEQhqWGKyjpK/hQJHCA4jehNL983b6e2QckWJkw9P6+lfeRAwxD6+LqLaVedLd84O3enypBm3Um6IhI7BdUZ4u6ww9xgGdyaY9o41ka8E6XZDoTq1tc/x3JAtPqj5CRW75trtTNPHlFWJOeZaofekY5v5KBJw2aEhrgluSLGxXMTztfyABrtoLLCZEduhmqHR1lc/oSBlney60g7S8xaWeNvBalAKEzrYZT5z9o3xPDmfkFfIz2ndqMwD8l5jgkRFtPnfhxf0yo8PiqCD9UpdFM2oYiiMzyIaRiJKmlCUdcbFfgyy66400fC9QFc1eow4VTuz4ltiUq6UU1uoFPccp4h0fJvzh0rNr2iBiey1q+keWo3wcnV7QHjUEaub9sqYr1HTTMpPqGBmQGdJ07RBOxem8qPf1PQbwAVqK0j7Z1F7gDfC2I+fJzzsLElgSzN+I1V8dooJMdcb2gULSJmCWkaMhGpj/zPVZbfcISWTlJ//+cn4cb9BLBM+tRPpCV2J7CYnCwXc6v
 PH4lNbzO
 WMJTDs6SLc7eljuRD5XTAXgYdK1nvE52QWNqeLffnuaDxBCIIdPZShSqndxoz2I+aQnBkosUMTVxH+54LaxYBzJGLt1xYvnWWbirn618Ou4PqSEwD2Kvt3XrG+qNcWcYycRdDNK64/6iLKz5bTju4P0tcXwraS+2qfapFdk3F7Yp5Q4wjCKCXZ2SvHS1RF6Y+AejQBRvndBKta2EezD2RAjyCXTG+sYim0uw2KtWQUfTmYqe5E0y3I8yeYbc2Jwg8U6KH42B6Z7Jbpg5yNZqsTkhV9Xv+abZr4aEYl8TmKchPM1THiK4mFGXdpALqe4G68/VUFyWkRsYi8Spc9k6vyeYWvI0wCkPlXCJBQ3qQ3JePPlH33GE+Qw/ZVhhKr7HABeRjaGAueZu3cqxLTzFZ/xJWKOtUUnS2UZKiJPRjEf3N6sW+0QW/7Gr+Aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 25, 2026 at 12:25=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
[...]
> > > @@ -5948,8 +6001,11 @@ static int run_eviction(struct lruvec *lruvec,=
 unsigned long seq, struct scan_co
> > >               if (sc->nr_reclaimed >=3D nr_to_reclaim)
> > >                       return 0;
> > >
> > > -             nr_batch =3D min(nr_to_reclaim - sc->nr_reclaimed, MAX_=
LRU_BATCH);
> > > -             if (!evict_folios(nr_batch, lruvec, sc, swappiness))
> > > +             lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
> > > +             lru_gen_balance_scan(lruvec, swappiness,
> > > +                                  nr_to_reclaim - sc->nr_reclaimed, =
nr_to_scan);
> > > +
> > > +             if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappine=
ss, MAX_LRU_BATCH))
> > >                       return 0;
> > >
> > >               cond_resched();
> >
> > [Severity: Medium]
> > Can budgeting with lruvec_evictable_size() in lru_gen_balance_scan() ca=
use
> > lost scan budget and premature reclaim termination in try_to_shrink_lru=
vec()
> > and run_eviction() when one type has no folios in scannable generations=
 or
> > eligible zones?
>
> At the moment it's like part of the design, prioiry will raise and in
> the end we will have no scannable generation limit, zone might worth
> be considered when getting the evictable size though?

It should be straightforward to exclude non-reclaimable zones based on
Bo's fix to 14/14 which addresses the GFP_NOIO issue[1].
Since sc is already passed to lruvec_evictable_size(),
this should be fairly simple.

If you want to give it a try, I've pushed the code to:

https://git.kernel.org/pub/scm/linux/kernel/git/baohua/linux.git/log/?h=3Ds=
wappiness-rfc-v5-with-kairui-and-fixes

[1] https://lore.kernel.org/linux-mm/20261025013103.2742885-1-zhangbo56@xia=
omi.com/

>
> Also, maybe we can improve the aging on imbalance to trigger when the
> scan budget is much larger than the scannable size (and priority is
> raised beyound default)?

