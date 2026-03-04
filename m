Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07678EF8FFC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 16:28:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AB146B0089; Wed,  4 Mar 2026 11:28:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62B766B008C; Wed,  4 Mar 2026 11:28:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53B986B0092; Wed,  4 Mar 2026 11:28:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5016B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:28:17 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9BE621B8519
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:28:15 +0000 (UTC)
X-FDA: 84508912950.02.E2E6B04
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 96696100007
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:28:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XiKIFErl;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772641693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YdrH1d30bQdn/vAx3ufQokRMQ3BuuJO2abIxKj8RN5w=;
	b=XD6yKUjkTCWzc2z9L8FvKHnhGMMC5g+vG1FivYlLUESTYYJgackATVoRlWBmtso0pMs3CX
	yCTIyWgAE9s4xHb2wXM+BUqOZ2uyuxPbARQ+uGpYD0dkTCZTFyMusQdrp9x8juaP9eMXPP
	Bgz97gjtcpx4XH/5lFfFfzaAeRuckQc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XiKIFErl;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772641693; a=rsa-sha256;
	cv=pass;
	b=cLVDVeWFyweWTM6Lc8eXJgKCh9Qnqq+n1Qw0XzAM6LrRK0YmzwPuA885pOfXnI82C1FI98
	1aOCp/WvDNaXGakduao3nWFD4EU7i7EaEP1Csof7cQelcpMb/ZGeVovFsMhS2ATwM3cNp2
	5+8C/x85LVzoSlVfPcQ61bICh8JP3a0=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-439bcec8613so2344529f8f.3
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 08:28:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772641692; cv=none;
        d=google.com; s=arc-20240605;
        b=gT4+sJ5mIFU2upoivpm4CYcFagAD8XX5UvlhGJTn00jHXV59Up166GlVLpTbsVmnwp
         xcJDrAg9+P3QCW2t+uLgQK3wTsLFYVfWgB8qYqstwEeoFzkbCABOvEj5o4YEvo0iro8f
         xP3WQvpKwrvjHDzvPQ3B2Pz+H7A5+sOhCKr1kKBfARFqLAmrsu5pQLUxp/8idVuXftxk
         PFy7KHpwaDe0PWleMs6gQmlqxV7dmq5uAJ+c7GFYEr0dUfBY2d5yymy5hPJiALT0EvPK
         5xgXkqu8GfZ4CsEfUvXnNZ/lQmGd9EEA+Z37y7m6fAcPWuGYZB2UbayjBdTwwEt7YSec
         M7CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YdrH1d30bQdn/vAx3ufQokRMQ3BuuJO2abIxKj8RN5w=;
        fh=r0lqEbpQ7Yf449c1ti8iDtavygkb9dEfNh+BjYCYV7U=;
        b=K5kJr0Sq60UBCbMYXWyIYFKTM4UxzdwIxGMUzRIp+WLt0O9F/yAXf7KHf1S5xyDldF
         w2tAOC5C27boiZybmc7fTatYFPjBBd5FPv+yD3j0U7wHnQ+xkU9roqB2hzFypXIeMriL
         U3YuZehsmj2nzT+nE3ftIZjAH89KzrpI7tqebl/0+sJkjdqKR09uFHXUV+Tu7xQQhBG2
         OWLR73fHiGmWb2frrFNu2RhnnwyijJJxlBDsnjcaF2HjCNrxIoTg6FESfGJxKjKA88ei
         nTZC/QE9fOlQUnxaKFzTC4wx2SXvYgHiJL6TaPZDIQlKByIBP0l8VUvAcvdQo6tbBtfF
         6FQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772641692; x=1773246492; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YdrH1d30bQdn/vAx3ufQokRMQ3BuuJO2abIxKj8RN5w=;
        b=XiKIFErl9I1E6tuQ7xqkJYZaEZqvU4m1tOoySd2FWrwA3BIgHQBhwF3n9baqAH2Djr
         uOm7NFIOMA+kjrUrcDe9XCkmWjBfEfvxllBVCwjt2IrEytd8PcGTKUgbtwSzolXZeKhX
         3rHkjgi+USuj2qITciDeqbO75VV4NgH+/yKjptesuJpdV9IAYRPLIJdoWF8YFOkvEutH
         cedBlyne8CaM2uvQU/EXSkbkujfoN2TDRSa6V37N32gs1+AwrBxzHHwRllYudXRwOSx3
         wZfjwcmkiVypQvsLYsGtcySAmFtV8/RafxF/GTtowaosuE/CtiQWXu3qMRtK9roh10Jr
         bjCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772641692; x=1773246492;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YdrH1d30bQdn/vAx3ufQokRMQ3BuuJO2abIxKj8RN5w=;
        b=jQaDwvJU7dyEGHB1XRj+jagbKCLw8O4SIjVfGvCYekpIArCd++olMYQaRxEXzvsfvw
         2Vtff55QPzF3XqDr+1EKIC34AiFvg1Pq/bJJmZGERiCt0pB8dj21HTc4XMVg5ycREDt7
         BdNuDdIyal4KJ3qVhxb+CsHhx8HhOkkdXPR48gueCX7u+0BHQ5bcJivUL+v/dkZfj0Mk
         RsK9nDk7C7CjbFiPV9WxZBhYbViW8cZJIyd/57DwXZoNybm4/PyHvnDUn03CeTNOnELa
         YXmcC+VLEATirShCKi/4bk88BNQIgQFE+148KgpFbeID+3eBkt6bXHqqTByRgFHOujn9
         JUAA==
X-Forwarded-Encrypted: i=1; AJvYcCVMNfxf3XqZLSnQ1v539SNClSrEBjxvmq+jksu8+MJ0+pD50/jEJuA3q0ZNfCmn8GtrVWajNrRyvw==@kvack.org
X-Gm-Message-State: AOJu0YyPy+h6CFxE23VQG9OmaKXKITslQHA/ktZ8zYDir2g9fD7IzAIB
	EYxxU6WqLn16J9HDmlcOMLVBmo54DvZCu5qzOjzmKhe+IacU/AZg18CnbLQ9eRKJ6oqEkhrLcFR
	ydkwVtIZV7ULCK+mYKRVGej8l/PuX6Rk=
X-Gm-Gg: ATEYQzwm9gou0I+DJZa9AnWuxQFopUz5uIzT+I7fepyVrlzzp3GLbf1O/aUy6JhCrPB
	g0SRfF3E9zBIJ9xJF4DqiYEnTkHf5WrSEof1oC1OYbEMDijUU467QCGq/IQm4D/7rOTh9nEixoy
	ALVUnB0c5McTAYZPwEz70kzMqITSd1aPfPUPpqKTNxWpdU7CF2kbNcmsZdbTC3fK1OOO1mJs/9a
	S1ZlrgJ91+66T8D+2rxcHt2Kq2XxCFVo13+8gCpefAr1Q5iarE9if6Y56aDe3WXUfLDl5tobP6Y
	cQzN1YmbAREnUSmcTyP7r3dD87N2xRpvmIfe8Zs=
X-Received: by 2002:a05:6000:2902:b0:439:c5cf:fc68 with SMTP id
 ffacd0b85a97d-439c7f91d78mr5207728f8f.1.1772641691795; Wed, 04 Mar 2026
 08:28:11 -0800 (PST)
MIME-Version: 1.0
References: <CAO9r8zOFS7zU-eGkErcjud=DW0t00_WqNqCzq_QDf061dOsYSQ@mail.gmail.com>
 <20260304151120.3512645-1-joshua.hahnjy@gmail.com> <CAO9r8zOJ5bkJzptM7+8V2G00dHuycAEAF4CDcaR1YMk0kWyktA@mail.gmail.com>
In-Reply-To: <CAO9r8zOJ5bkJzptM7+8V2G00dHuycAEAF4CDcaR1YMk0kWyktA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 4 Mar 2026 08:27:59 -0800
X-Gm-Features: AaiRm52zyzsQi8r-nj2jrSJ8eXqkhJNQwWcx0gNagqCtRndwiPZHFx6CGeUvqPM
Message-ID: <CAKEwX=ObFWm6cKbi4hL8JLDKui3MsRu-JpEFohBdkqHFY9tVfA@mail.gmail.com>
Subject: Re: [PATCH 6/8] mm/zsmalloc, zswap: Handle objcg charging and
 lifetime in zsmalloc
To: Yosry Ahmed <yosry@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <hoangnhat.pham@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 96696100007
X-Stat-Signature: z31dkdx78pm83bzm3sp7iiiiwtp89wdx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772641693-1326
X-HE-Meta: U2FsdGVkX1/NqJnHsQEVah7dKjgZ8NIWYOODtI5imNSpp4VQcPckWQkdRjDyVl34mocQOGfRL3uFMUP2Vgf8+DovJWXl1zZwx1zTG8CWJnIuw3u2hilNUpq9NjyPdW8GKGJ8qw/H9eS+mCE8xNBZPc3lnU1kcui/VDQYrS+B/oJUj4/zN1gX4rgk+YaJgqTl3uoWPz+lRuRx3PNnEqesryoO/Z6F7Fdkkv7gStFrE2qOL9tGJuJzh/g/naby82PvxiV9pMDsnZ8hLTLtVT3TR9nrfkwds12kZLPmg6/g7xfV6P/G0uz0CiFgPPSMv2Bd6JDgqJKXuf7UHnrkG4vte3hL5+sYNE13ZAnfM6XN550OZ1NG/RL6hhlHDZzCx85hOmzwKk75bYJpUf53u6Gd5AkUFrSq9x8WLH0sOvYJ8HDIUMZLvfWl1FgnV41hkDoTXOvsJiJRD68z+ifvNq0RSov0dgJHhJnRAAen4wS2CAT/kn+6RWvhl46SlzQTJgppxbstBM2EYpN4g8hdzkuPnApYVj9seZqN1PfHMCTvOo6klO8ILkQQHBUcOoIJ44zAtKMbwmn91DX5pBi+WtUx0VvG+9vfNpHu4q1WZWFZZvSPeHwFvMqZp8lqzabVoIWAC8pFsp3c1dLL0cqPumgd1sPZMlf7ZxmaaKxSH3rx6XpfGW8YdlcP+2eg2yrYT5Br9aRml2FcJoIvyCl2xFSWwMuLRaTVEZI3MiQTGEAuPh+k+5w8DYCqzDS5cgHDObPobO9hRFrbaYbEvlm6gVo4WR+I5PgwA24NAsWCv4P1vfjkKZxj5Dl+gVcYCwDclDxUOplW7ZJp/Nvii3ZJ+T0DL+wIbj5qtvXjKJ80DLAYEBG8X+OTv/JZx7+eCQMueypmPZQ2H/xQbt5t0ABdp4BentTGRjUFqPwgjGA85EhHZbmUwW+nHlGvk/4xtXgsxE+9mvuVHtauItTWIKlpzSS
 NZs+lupA
 MtGS32VCWuRgyEtXRVB+lCQYKeXjz2hUkD4Az7mQQIVrAAOac3myMB0RuZvzyXtLLeteW6P01O+0Vfev/OK2HB2I8g8BU/+dYLldjUToLt2k0g786wJYRZPzKNcYiTdMTTkTcEYEV4LLKB8DbFyL0DPCvr42luSJeC5eag9QBXLPY4YFOktHOcInNnBYGwRB/WM8T8mwmU1PDo4R9x5tK9D8dT56B2PAlIohecugtuzT6EUoLGQ5KD8Rz/kCZVfQgSuPn/2FN2xKVhf+06P+ux9l6iOmy7VPZiTPCoRafDhjPiVSeKIj8y0gzjizhfRcJPUmowjxzY6A6luaOAjkcvUpKhFfXuNDjivoQh1dL9LK+Q4T1EnRx+mZ/OpYdGep7vhhLxl+J+IIermqzFV/a4ezRC7zvva+F4qEB9kzx9Mt+gtgcvCtpYy9OMwbrjdrZnWJB5udsRAcwKFRr5mrD1BvWSRQbdz0x15Skk50YA4zvhM2/zbAeAPGzqwHp/mDVLh1A+CP3gMlhAOM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 4, 2026 at 7:47=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> On Wed, Mar 4, 2026 at 7:11=E2=80=AFAM Joshua Hahn <joshua.hahnjy@gmail.c=
om> wrote:
> >
> > On Tue, 3 Mar 2026 15:53:31 -0800 Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > > > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > > > index 067215a6ddcc..88c7cd399261 100644
> > > > --- a/mm/zsmalloc.c
> > > > +++ b/mm/zsmalloc.c
> > > > @@ -963,6 +963,44 @@ static bool alloc_zspage_objcgs(struct size_cl=
ass *class, gfp_t gfp,
> > > >         return true;
> > > >  }
> > > >
> > > > +static void zs_charge_objcg(struct zpdesc *zpdesc, struct obj_cgro=
up *objcg,
> > > > +                           int size, unsigned long offset)
> > > > +{
> > > > +       struct mem_cgroup *memcg;
> > > > +
> > > > +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > > > +               return;
> > > > +
> > > > +       VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
> > > > +
> > > > +       /* PF_MEMALLOC context, charging must succeed */
> > > > +       if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
> > > > +               VM_WARN_ON_ONCE(1);
> > > > +
> > > > +       rcu_read_lock();
> > > > +       memcg =3D obj_cgroup_memcg(objcg);
> > > > +       mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
> > > > +       mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
> >
> > Hello Yosry, I hope you are doing well!
> > Thank you for your feedback : -)
> >
> > > Zsmalloc should not be updating zswap stats (e.g. in case zram starts
> > > supporting memcg charging).  How about moving the stat updates to
> > > zswap?
> >
> > Yeah... I think this was also a big point of concern for me. While read=
ing
> > the code, I was really amazed by how clean the logical divide between
> > zsmalloc and zswap / zram were, and I wanted to preserve it as much as
> > possible.
> >
> > There are a few problems, though. Probably the biggest is that migratio=
n
> > of zpdescs and compressed objects within them are invisible to zswap.
> > Of course, this is by design, but this leads to two problems.
> >
> > zswap's ignorance of compressed objects' movements across physical node=
s
> > makes it impossible to accurately charge and uncharge from the correct
> > memcg-lruvec.
> >
> > Conversely, zsmalloc's ignorance of memcg association makes it impossib=
le
> > to correctly restrict cpusets.mems during migration.
> >
> > So the clean logical divide makes a lot of sense for separating the
> > high-level cgroup association, compression, etc. from the physical
> > location of the memory and migration / zpdesc compaction, but it would
> > appear that this comes at a cost of oversimplifying the logic and missi=
ng
> > out on accurate memory charging and a unified source of truth for the
> > counters.
> >
> > The last thing I wanted to note was that I agree that zsmalloc doing
> > explicit zswap stat updates feels a bit awkward. The reason I chose to =
do
> > this right now is because when enlightening zsmalloc about the compress=
ed
> > objs' objcgs, zswap is the only one that does this memory accounting.
> > So having an objcg is a bit of a proxy to understand that the consumer
> > is zswap (as opposed to zram). Of course, if zram starts to do memcg
> > accounting as well, we'll have to start doing some other checks to
> > see if the compresed object should be accounted as zram or zswap.
> >
> > OK. That's all the defense I have for my design : -) Now for thinking
> > about other designs:
> >
> > I also explored whether it makes sense to make zsmalloc call a hook int=
o
> > zswap code during and after migrations. The problem is that there isn't
> > a good way to do the compressed object --> zswap entry lookup, and this
> > still doesn't solve the issue of zsmalloc migrating compressed objects
> > without checking whether that object can live on another node.
> >
> > Maybe one possible approach is to turn the array of objcgs into an arra=
y
> > of backpointers from compressed objects to their corresponding zswap_en=
tries?
> > One concern is that this does add 8 bytes of additional overhead per
> > zswap entry, and I'm not sure that this is acceptable. I'll keep thinki=
ng
> > on whether there's a creative way to save some memory here, though...
> >
> > Of course the other concern is what this will look like for zram users.
> > I guess it can be done similarly to what is done here, and only allocat=
e
> > the array of pointers when called in from zswap.
> >
> > Anyways, thank you for bringing this up. What do you think about the
> > options we have here? I hope that I've motivated why we want
> > per-memcg-lruvec accounting as well. Please let me know if there is any=
thing
> > I can provide additional context for : -)
>
> Thanks for the detailed elaboration.
>
> AFAICT the only zswap-specific part is the actual stat indexes, what
> if these are parameterized at the zsmalloc pool level? AFAICT zswap
> and zram will never share a pool.

TBH, if we were to start from scratch, these should be zsmalloc
counters not zswap counters. Only zsmalloc knows about the memory
placement and real memory consumption (i.e taking into account
intra-slot wasted space) - this information is abstracted away from
all of the callers. And if/when zram supports cgroup tracking, memory
used by zswap and memory used by zram is indistinguishable, no?

Anyway, Joshua, do you think this is doable? Seems promising to me,
but idk if it will be clean to implement or not.

