Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B52C6606A32D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 10:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hLRa0aY1
Received: by kanga.kvack.org (Postfix)
	id B5EC46B05B5; Sat,  7 Nov 2026 05:40:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01826B05B6; Sat,  7 Nov 2026 05:40:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D8126B05B7; Sat,  7 Nov 2026 05:40:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 753376B05B5
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 05:40:15 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57F0F1402F0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:40:14 +0000 (UTC)
X-FDA: 85407978348.26.7AA0F6A
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id 60F7640002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:40:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hLRa0aY1;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794048012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=brZ9xHfj/WnFeD7kt3B9B589ugJ0PwWi/dKZ88IZvOE=;
	b=orBKDXgFWKXztCkA7xSpx0WMmcBHg8KazlkPx4x6ocn159Xtx9dJkVlxHiq570X6+Yjccs
	mScWs7DqoefUWP4Jhh9J4BTG9Ym16sQdSIt80Zmh6LXbtOmZCQczZ3ahWjQ8r9XWXTK9ML
	33DqBsmuUYqYLg7bCHXlzHXG3BrtBSg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794048012;
	b=kPpYNCEYqgat12wQn6CUyb2osmz7xoEJwmx6R2zzPew4GV2t8SRvNJaUSjzlq6fb998YxX
	tBCJEnSy6/OxpyqlsUVDqIIH5CjnRk363SnvP+Qz0itQCPxTfi6FZqrmA7S4XKow215fLx
	AQxEHe04EC2shYQb4GXP1WMOsuMCVEw=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hLRa0aY1;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b633ddfad6so2131209a12.3
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 02:40:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794048011; cv=none;
        d=google.com; s=arc-20260327;
        b=f0t3C+x0ubsFAIjkYLkE1D7HsOESDeNRQNSHiTTKDMqS0j8esmVuZf3a3UvnTbLik4
         Ov7iZz4rmpi8YiF79YlVPb5uM9nxQ29KMpAke33iLg4ubJkEnjptSkEoTjeWnnRkizuA
         HTXl6/eIT1XJifOvTuMmhDM566vc/TRn4wiLICBJbTIqc+JHuh+NZ5vO2Dd3J4l2Wfb3
         PG25u9gJyRZqx4nkd9SYlfsUDAHA424UJxspxf04/lHW5tKQ+6xDhdEX2Mgu+4/l3jvO
         2NLVKOkPNN6yY06Zw3MVeaP3yrED9ahPAzrQ42/pIkMVRk9Jr5FcfvQv/vQyRb7dXbFL
         BGXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=brZ9xHfj/WnFeD7kt3B9B589ugJ0PwWi/dKZ88IZvOE=;
        fh=OwFT3ijRwjiKeNexOqudporgcgZbdmyMttVzIFVXe4w=;
        b=VhEVR/62NU6TYcHClquMOcCkhnu38m0mjuAwKTNVzJ//VIFiFQpD1LL4wZnfVh1VUA
         ub3lze8rlBqOhYTWiO1P8jDbbHBTKPHiB1uqTqkSQUU1Im1hJPq2rnH+ZkiJKds52aWP
         /5r6Cl8jctaaPZ1slP1ADe5M3wJAKBvgtOYUrUK3xXvXzbQ/OvpbhdI6JjFDvwDmJPgt
         03nm8cIt3ikbamaZgCQRXc29X8YtygxHCyp/hPOHW0IAoJeftAegu3BMHm6GkLeDx25+
         nr8vtDN5aibNy2G6XWcUPuNzRYjMtsbVvU8AF0RMpyISUjfdSXKJ3OXcObVlmJO5yLsz
         szVg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794048011; x=1794652811; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=brZ9xHfj/WnFeD7kt3B9B589ugJ0PwWi/dKZ88IZvOE=;
        b=hLRa0aY102sKBk173YrvyaEsGHEPFHlDHLAdHk4XVNl7/1mW0SS8BcEh93PpcbJs91
         74ZehnloikouhQeGV2Jqshc0YWfMSup/7C8HhqM0LcMkQJHWYITXAAW2dDCPLkMMiqwH
         eDfEU2Z9DAV9MO1CwRBO47ddQCdSqFl0YcvjNwz125Sn6fPBzH46iCvgwWEJdASe79jy
         /sA1pJOP5/w82AzVuCZ/Ll+Um9fxTy62RC117/UmtJ7lscTf7wvN1dyBr9A3dFNVUrWt
         aimqOPV10X8dmGdm7kvMc0BChgHzAUehxGtceTsHMCfQCTORrheVByC375gYpo5czcOF
         qnsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794048011; x=1794652811;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=brZ9xHfj/WnFeD7kt3B9B589ugJ0PwWi/dKZ88IZvOE=;
        b=DezKlYO78YhE6wW6bRagHbGrMzLNg74/7t+Ojk7Gjc+t5DwuL/XzJ/x86MthVy9bS6
         /DaXVniZLgvDaaTvUZSbv/utNrpNV4H763uscXJmBzuYN9ljCIS2SNtO1RAC0Ui7YWm7
         x/9lhowl0+MmrkCCr9PAfmGOx6nvf4Gb2HeYFYa7t6tNBPjNo4gxkJtvzcGW0SHId11s
         jEAAyCAo3ff+z7QyYI7n56iPe5Dvf/oqkiUum3Rq8JvG8jBzhWTxgTEY5PHmm37K5d3V
         oUbTl5sUhw7reKyTEdtH66cXTm7Fu8X04xAv+SeimtXYucy1kP3MTbb2RrgmHGihx79E
         bNkg==
X-Forwarded-Encrypted: i=1; AL+hErGQ6bztkw0rhl7XIE6Y1EYBkfMyD1iGN7opIGhavLKWVAyiCkkMbBz74GrA9rrdeeZy9RDmYpTt+Q==@kvack.org
X-Gm-Message-State: APuU4Z8y0heRq/a0w5QCoGaJ0fQNnR5TKYiy0zP+lxVS/QKscO3oOGiz
	uvJM4iPWcBTcNDhy4DoNbm9TzVbIS4C1OFEbWPKDBVuZIqNd5n4LgZzm8xi/CUGeoPthHmSXPJf
	r4n9WtbEVTHgc5q4ryJQuPlxBVjRg5fE=
X-Gm-Gg: AYBFou2aMTOq3/39ppUgowKZvND4eg6EIt3Hve0NTudUM8sSdb+Sgur5gjC+YL+a2K1
	qDiDxKjNukuGrT/NOx1N4L9kYuqMKfTwi5SQNsI54Wo4VEt1xQj/OUWbl7BgKPhE55UPjX4pRLf
	RQTqZtdsdqz2UNYOlog5tMfbtGhOB+cgmqWDt0UpGpjpfftZFKk5VCVahaZmkqKqug9nvU4n9hK
	Usf5Hat1V1YFtvbvUuU4qwfanxtufT/b4kNd4pD6eT3OdvcOHMkcQx2N+N915y5ubngDGfTEQF+
	Nf7FP+66pgeo4eVY2CjH4zepr/18+Gozs2Cn+vJlCsrhXL1h0vjP5CRtiq0RkV//Y+Ovw5Jzfv9
	l0OGKAubXkfjbsA85RmKdLk7wN+uMyP2RcC4Hdwx/C0yVVohmCb/9mWHGvGOPqfwke0Mh
X-Received: by 2002:a05:6402:910:b0:6b6:e808:9701 with SMTP id
 4fb4d7f45d1cf-6b6e8089a74mr2855241a12.1.1794048010791; Sat, 07 Nov 2026
 02:40:10 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105132220.2233677-1-ridong.chen@linux.dev>
 <20261105132220.2233677-3-ridong.chen@linux.dev> <CAMgjq7DtU+tSOgQWgTaV0obLwkkUwQqgvtTXjG2qf8L+iPXbiQ@mail.gmail.com>
 <57d2a4ca-8edc-4291-a919-8a74abda94a5@linux.dev>
In-Reply-To: <57d2a4ca-8edc-4291-a919-8a74abda94a5@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 7 Nov 2026 18:39:34 +0800
X-Gm-Features: AclHuK-eKiLIC8UvuvG9I4P71PxI9aEIqz8ViP6dfYBZPO6ABCQvdCkjdD8McnM
Message-ID: <CAMgjq7BtS6KKqdq1oVrvrO9FcTEkE4HNJe02dA87n6Zm7FFrww@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] mm/mglru: skip the flags cmpxchg when nothing changes
To: Ridong Chen <ridong.chen@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Joanne Koong <joannelkoong@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: s35m6tdxunzs8gz5k7rqmdpuitugzjqr
X-Rspamd-Queue-Id: 60F7640002
X-Rspam-User: 
X-HE-Tag: 1794048012-958603
X-HE-Meta: U2FsdGVkX1+gW2RAQHmiQNz98m9+kv3V57JVCM9AvRX1o018DzfXx+7zvaIVDBWnzTwbSHEUEN25Gtio0BDQwcF4wlkZ2p8CDdXh1ATw36sez0agudtQo29iNAKksp37BTO1xNMAzNUgtR/w1SP7eJqnRV6mMD4qZAeuCwtlEkVwgq5lTdzzdSiw85cl/pRsrWk2GD2xXxf1piIXtTA7v4P27GBmHtT8Y5iGacqVdKWRfEk3N0sZt/aTNoW+uQ/hSnThllM5LD154LvYS/Z8/yb/CtXfl+iqTx+Ij18zGp1cknC7Wbi5NaSzNf7B/yIPEe+vcC1O96IW1nF3hmQMlhB3fi9fQjtT4rCVROsrnWYa8wi8bsE8/8/hP33S2nly4AR0SSTzpfd7x4GU3yS0MM8IJzwd/FWV7KqiJONDbGUCWkhY93SgY7Ajp/iWOPzBDCH+szhmPXFnbsFT53i6yuiu0Xc7TYyjh8S2xlUQKk2vlFpEW7Bib3tVtn7wCH1SoXVL/4+eb4j8cqf4lBo7G4uYqd8HbN+OlAeNZlMubZiO3fYWxgcDzlDhoB8S7leFf/IGnP2O8o0NtkaINhGxUfrM/HV06SQ+KggU5CUh5or+me8N3ZrDiOiRKdS0VNoQruj/34GtF3ZvhAk6Zt5nznWP15buY3Tj4kiODTZ5iGx9k5uMVdMVCOFpQxU1Updg82kJPRuWco9edqdZfTwEgbusFBUOVPvMhyJEhWHYopScUIvCJFaeCIP63yWXWf+04Z6tPLMnd2BmrbtduukCrhDaAaNOulQ0H6Fk159S5iHhPRFZcX8h2jr547wORMLszkYahv/NKQ5CnjSDteZSONpV38ohNXRpGf5/muvdStUOUtzNtCDsfuDGceGtohB5YAgYXEfGYPS2Gz4ky2swxMUO5YQw/wwjW7r3sPmxxIiTPYUCXSvqMstO8xCpIt9C6LjVriFpGDHPxHeNQn6
 Nt3VB05d
 dXXnoxLHsh06SmUfp/WDtsRbzEr7FtFjPLhmEMVHdFmQiufPP2ATZxTQjhBuUdSlMzQfa7s2Wgml41F6dYrg9N1+3j1HcFn43jjS5MqoOf9n4Tc4Pi+k9l9rS0r4x1p5YdGZ/MTjc+RpGN9KyOTcBOIqZf1a4ZWpLRDvCScGE+xe2pu4B+MW35Hlf/OLOgLkX5zk+ma5Mx87ohccUG8H9Xc2VJ+sPHCs1Yj8IhcG/XqlCs28HMF9mf4990zrthxsgsXmH0K24amnhCswqipYP5th3DjQyZckg70Lyy1AdS+lkywh34dfJJC1YHVe0L8j91yIb6SziG0eYQglYRXXHn5emxBmFSHs13bvIms3r7nmu1jnGe79QCfsMbY82GDFeTjY7qfAf0XyeNgYbxvXXt02e4r0FCQKYWBLXapkOlEEkgIU5P0n6rD1ozt+V5FLUV6Srrhhzb/m0254sasU5ElUhr2R3iz1AiDPm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 9:44=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev> =
wrote:
>
> On 11/6/2026 12:21 AM, Kairui Song wrote:
> > On Thu, Nov 5, 2026 at 10:11=E2=80=AFPM Ridong Chen <ridong.chen@linux.=
dev> wrote:
> >>
> >> From: Ridong Chen <chenridong@xiaomi.com>
> >>
> >> folio_update_gen() and folio_set_lru_refs() always end with a
> >> try_cmpxchg() on folio->flags, even when the new value equals the old
> >> one. The locked instruction still takes the struct page cacheline in
> >> exclusive state.
> >>
> >> That is common in practice: a folio mapped by many processes is visite=
d
> >> once per mm during a page table walk, and after the first visit it is
> >> already in the youngest generation with refs cleared and PG_workingset
> >> set. isolate_folio() and the eviction paths also call
> >> folio_set_lru_refs(folio, 0) on folios whose refs are already zero.
> >>
> >> Break out of the loop when the flags would not change. The result is
> >> the same as a successful no-op cmpxchg. The only difference is that th=
e
> >> full barrier implied by the locked instruction is gone on that path.
> >> No caller relies on it: the eviction and isolation callers run under
> >> the LRU lock, and the others (page table walks, folio_mark_accessed(),
> >> lru_gen_clear_refs()) only care about the resulting flags value, which
> >> is already in place. Note that lru_gen_inc_refs() already returns
> >> without any atomic when refs is at LRU_REFS_MAX and the folio is in
> >> the workingset.
> >>
> >> Tested on an i7-13700HX with turbo disabled and the performance
> >> governor. N processes map the same 2GiB tmpfs file (huge=3Dnever) and
> >> read every page, then one aging pass is triggered on their memcg
> >> through /sys/kernel/debug/lru_gen ("+ <memcg_id> 0 <max_seq> 200 1").
> >> Time per aging pass in ms, median of 5 runs of 10 passes each, average=
d
> >> over 2 boots of each kernel:
> >>
> >>    processes    base   patched
> >>            1    32.9      31.7   -3.5%
> >>            8   195.1     160.2  -17.9%
> >>           32   755.8     592.2  -21.7%
> >>           64  1597.2    1260.6  -21.1%
> >>
> >> With one process, every visit changes the generation, so there is
> >> nothing to skip. Before the patch, perf annotate attributes 53-58% of
> >> the walk_update_folio() samples to the lock cmpxchg in the inlined
> >> folio_update_gen() in this test.
> >>
> >> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> >> ---
> >>   include/linux/mm_inline.h | 2 ++
> >>   mm/vmscan.c               | 2 ++
> >>   2 files changed, 4 insertions(+)
> >>
> >> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> >> index b3d85fe91385..4ba9079f4dc8 100644
> >> --- a/include/linux/mm_inline.h
> >> +++ b/include/linux/mm_inline.h
> >> @@ -244,6 +244,8 @@ static inline void folio_set_lru_refs(struct folio=
 *folio, unsigned int refs)
> >>          do {
> >>                  new_flags =3D old_flags;
> >>                  lru_set_refs_flags(&new_flags, refs);
> >> +               if (new_flags =3D=3D old_flags)
> >> +                       break;
> >>          } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_=
flags));
> >>   }
> >>
> >> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >> index 50c352e9ffef..3fa76715382d 100644
> >> --- a/mm/vmscan.c
> >> +++ b/mm/vmscan.c
> >> @@ -3398,6 +3398,8 @@ static int folio_update_gen(struct folio *folio,=
 int new_gen, int *type,
> >>                  lru_set_gen_flags(&new_flags, new_gen);
> >>                  lru_set_refs_flags(&new_flags, 0);
> >>                  new_flags |=3D BIT(PG_workingset);
> >> +               if (new_flags =3D=3D old_flags)
> >> +                       break;
> >>          } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_=
flags));
> >
> > Hi Ridong,
> >
> > I had the same idea in V4 of MGLRU-FG which is posted a few weeks ago,
> > with the same code:
> > https://lore.kernel.org/linux-mm/20261016-mglru-fg-v4-4-2106750c0bfa@te=
ncent.com/
> >
> > + if (new_flags =3D=3D old_flags)
> > + break;
> >
>
> Hi Kairui,
>
> Oh. Sorry about that. I read the series a few weeks ago, but as it is lar=
ge
> I missed this change. I should have checked it again before sending.
>
> > I didn't have time to benchmark that one function but the e2e test
> > showed very trivial improvement, it's a good improvement though. Feel
> > free to add:
> >
> > Reviewed-by: Kairui Song <kasong@tencent.com>
> >
>
> Thanks for the Reviewed-by. If you don't mind, I'd suggest merging it as
> a separate patch, as the test shows the benefit of this small change,
> which makes the code easier to trace. I will also mention in the commit
> message that it is a small part of your series. Does that sound OK to
> you?

Sounds good to me! No need to mention that, though; I believe you came
up with this idea by yourself. And that will make the change more
traceable indeed.

