Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5F35FD9E26
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 00:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31986B00FB; Thu, 26 Feb 2026 19:13:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFF336B010E; Thu, 26 Feb 2026 19:13:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDD706B012F; Thu, 26 Feb 2026 19:13:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C447E6B00FB
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:13:36 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 669578B85D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:13:33 +0000 (UTC)
X-FDA: 84488312706.20.4195F56
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4515080004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:13:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r1xwrMme;
	spf=pass (imf30.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772151211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=my/+LYo4A3vP/vd+8r8bbLsiMe25p21MkjnvWKVBUGY=;
	b=tSIiXjFO2dHNckyEolf0MdNtA6/YoXzyfag0Hy7FGiti/WM8MJuUiEVB0KLWWuCm4VMYJ/
	1iABaZ9FHA/qBCf+maWkgajvBlJtbG5Fts0/vvYZklE8ApE15tB4lGPv1taufJwQ9zA7Ig
	z/s3NShjgqWyHAjxQEfRmzCvkjwbht4=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r1xwrMme;
	spf=pass (imf30.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772151211; a=rsa-sha256;
	cv=pass;
	b=ZkG6ymxAa+oQH1lZhghD6B/KXg7m8mU0vhTYIHUb8VfO2cXbM9bxnIu2cJYBBH/7I+Hq0D
	sRVfexzHyg1sr/gCYZr3wZXbw3onp/3pPRIF20jpRygs9jtzH73D85IHEKt+Yjtq82rMHM
	juPWjDDf11/CKdnqHKB4IshtVsoUNbA=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48373ad38d2so35835e9.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:13:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772151210; cv=none;
        d=google.com; s=arc-20240605;
        b=Wv8McBKNw7kuMvqqB0zf5ZNUMGquK4R+NJ1cGVV+XA3YRtO7GXv/St3hpwW+D/zbwz
         ehcVvOzMYVCf5yculpsZTb7OoiWY6FQxfC5oVVe8RYczltWEgMPW1kIlwsXG5tgTub1k
         CfTm56tOdvfj74I9G3WCPvYu47Z5r6724F94DHsNqVvjg5LEoxrPh+ueCX9jSDJEVyIO
         jzR+ejOiINZU3Im41JVBE5EYdrH0rBvm6l+UN8C20A6t1zKG7kGz/ey2nXUWEbboixjG
         LzbCwjzwxzQGosPAkD6wY5/8ckYkHa7CDtfV4VK8qazdeGIgqu1jbKZ8vHLrR7ntZeZB
         EMcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=my/+LYo4A3vP/vd+8r8bbLsiMe25p21MkjnvWKVBUGY=;
        fh=XCa7uaLTci9QQjXtFcWOOH68y74N1Z1gPO5oHYAw1gI=;
        b=j4torXRFAcYf92S0oJm5RtXD/I6ekhbBIXwKHMBPxCpdSPTaSCo1sCXgzYg+Y6lS3/
         b5x3KLxkiZCPvI8hKJpawF5kqM4853u1Tg/vs5hPkWPSV/2LiWiiydYxV2Yfn8hsXvjR
         Ox6OUiPaHyR1sonJFZz08MBKj9qf3KpwEwdTsBZ18jrW+Xdif7lN1+Hq0E1va6/8Bts2
         P/kv9rTcUQqH+2072DrZbRDDcsGp9QfYVSLXiDQijLNEs4RbDSl50cFanN6H3WN7BiqR
         26G+eaif7FCh9VBSNZ3lq0NVn2Fym7AJrq0/ecVds6sRYwy9vY93E/DIC7NQc3O7nk4F
         J7HA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772151210; x=1772756010; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=my/+LYo4A3vP/vd+8r8bbLsiMe25p21MkjnvWKVBUGY=;
        b=r1xwrMmeve/wNouV/jicS0LFn7m2bdVi82PHVXYfXq553jlvVPHC26ISWtsby0c0Bh
         VE7HqVPL6mfr7F39rcQGaKp4yRSdpdbIsafDW0KfIQNXG2TXPb3bZ9nradagS4nI2cqV
         kz7OHS6W5IHIuX3wPM2Gw3Jebl0AdE1XQYgZky0A9d7seszZX64+YavKEkNwXWhiyvat
         Xdq3VNv35NCsJ9gBrlzK6SBtZgbynwAfJXJAzTm5WcTq6qs3ifZzz4/TPNMba58vLa0m
         +lAoQnelyyjuvcgsy98UpwfI0pzgWtorfQLRnKo+Ho9vuMRakfZ73qs1mjto2UWjyWH6
         CXyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772151210; x=1772756010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=my/+LYo4A3vP/vd+8r8bbLsiMe25p21MkjnvWKVBUGY=;
        b=Ysqhwv80WZNi8fRD0VL8jbSkwPk+oa5/ECudtrREJzatsZ1yF5agn9/lK9SXSclJY6
         ++TdGyvsJGjicdM16YAXbVosiJ7GATktr569NUuKxF654ewa1L3fi6ydphj2v5Lwh0wN
         tJIwJZnnwvW2FEC//5fp3nDF+7B3VNdjQDHgBeKVZqZo9E3p63fKiTCF4zpwr/oIn+dA
         hczx715mHufdItBuHlFw3rm7Ncym9mFMmZH5Smmnopujt3TMHcDv+RY4qutQB8jyz2yp
         cVBQ011HAmv8xYDxdQxf/UTA8IhGnKLvq+EyqFUlF2SPnJ+WnUk6hGgm+kMEyaLQ2Z1n
         ifUA==
X-Forwarded-Encrypted: i=1; AJvYcCUVmK2PoswKjeUOBThqRRT4ledfaJvmB6tuGUxRPWe7igIoAdKiOdseT2lSvPhwVSwHStr6BGqKwQ==@kvack.org
X-Gm-Message-State: AOJu0YxgMPhux0rdJlqVnrSAJ9nWYxxqGR3sDU0rr3Rb+/FtON48JuRc
	aZhnHmll86mRoW7ntJPJhk8+TnKsctqapZtS45SMJAYcvJT48v+O8cX4MX0I+go01Jupfu3dgWU
	KiahYYxsKzpl11p6j5N8+naNlj10ym1pzuc7OEuCs
X-Gm-Gg: ATEYQzya8N1jM2l/B5YmUemqeQIM51/X0nAAHil97I9Z8QsnM2PYVj5VRbbMpbNudVC
	PaWqlZEm3KhM1f6CKkDDxmteF0BztThRw6S34Y3XNbjCIKl02N8Z9hgHQxru7Yw9yl6zvDFSGkf
	Dm6WPOVjLs+/QIz/mRCDM/UH97o7Dba7OMqQ61e5YWUhiFu1PjdzeUXz6fswEXtSOxryYgDCk0X
	uYgh5kWAOiywL81E6M1urHVfSEjlWHAhskL8Fepd88VqZX8yIl81PX0P30WjOyCoTTnyTDBrAVW
	nCsuQANcACW0mlfWIKxThl4Utq7aZkTL9VMuthRyeu6aJ/FVEBaFOtVVXy6satvJH7hXoQ==
X-Received: by 2002:a05:600d:6446:10b0:477:95a8:3803 with SMTP id
 5b1f17b1804b1-483c39f8080mr839615e9.13.1772151209186; Thu, 26 Feb 2026
 16:13:29 -0800 (PST)
MIME-Version: 1.0
References: <e5c8b5b9e7574dce8e4d4744595123e2@honor.com> <CAGsJ_4zatnuLkCJyDe_o_yXmhngpc54kV6b7M3tu6JyvF-ZxDw@mail.gmail.com>
 <CAJj2-QEHAk-H6SSJY5OmLYuVyLRacSEgUupKaKefFFwGg7CftA@mail.gmail.com>
In-Reply-To: <CAJj2-QEHAk-H6SSJY5OmLYuVyLRacSEgUupKaKefFFwGg7CftA@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Thu, 26 Feb 2026 16:13:17 -0800
X-Gm-Features: AaiRm53yJMkwbgWJFQhZjpThlXpBx0qFwZUc0UbsmNlpQHCVPi4MvDukFuHxL60
Message-ID: <CABdmKX2mOD8CwAHPbn8Cha1uuMP8_mSXdH=914z5x_qTkJf7wA@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and Challenges
To: Yuanchu Xie <yuanchu@google.com>
Cc: Barry Song <21cnbao@gmail.com>, wangzicheng <wangzicheng@honor.com>, 
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, wangxin 00023513 <wangxin23@honor.com>, gao xu <gaoxu2@honor.com>, 
	wangtao <tao.wangtao@honor.com>, liulu 00013167 <liulu.liu@honor.com>, 
	zhouxiaolong <zhouxiaolong9@honor.com>, linkunli <linkunli@honor.com>, 
	"kasong@tencent.com" <kasong@tencent.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "weixugc@google.com" <weixugc@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
	"willy@infradead.org" <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4515080004
X-Stat-Signature: 695y45gnmcmnimydenqhbenj8jnparr1
X-Rspam-User: 
X-HE-Tag: 1772151211-61078
X-HE-Meta: U2FsdGVkX1/rVkEgjm57XjYuD6DAincfeTekeWyPuQLVRygRKUPS+DR/BJfZ5Xs53iDc8RXnrn7YYhCez1lLkW9PBdOzDhLol4r1mZ/jY5+tTM5BAUrCwZtvvOStrg122kySfUztb6lAo8a4XtJfrk3bA4Q4wMzUF9sRfSdbyWEhO8TOofntS0nOu4XgkbeOHReEtDxXcifD0p4YtfwU7eNTKuoEtbk/igQxKwCnZ+MGRkW0azEv1+fsJ2DJB0O5jK+Uqioz+Tv79/JaboOVDDIgAClhbFR+wAk/ymDi03YZ5BI6DAc/R/e4RZRlgcOjDz0w3/YuiV/l0sP/Wg/Evt7/6wZmuG9lqB8Iqu8/yRT14JorqmjIEHHb/004ZDkKQ7NQPeCS5xGxjDtC/+Sk1mHyCWhPl+Bf1vovBWnqhLYBFTBPP7cjiyDVvtNoheFsq+D9x7b66SZJdF6wtldPOlfenCr+q/AZUQeQ5r4zMCM8NDsLiTJfJxGnxk3a39CbqYRXo8j3aA8TdCsxi4pFOg0+TBk/gaSIiR3CKIWpKRtS9PGVEjiFx50Lps8dtetpyCkAbDjObKEN17Qb99ELQuYTgP37fdd/RE8ANjI8MujuSyOI520gAaXKX3tklYg4L/Ml7lFEV0hJaAQLFcyHkqkynZ/P4p+dOSDQ/Di9E7H0G9hUqk9ZaeL/xXVwQhrRbmlb3w8awJeV1hlDN9VcwU0Q5hHKDt2toja+ujlJPdPocQsg3nnxV+a8ZKovBgtKABhwr2xYAj56uvg4hWhGqjjxChs6vMcAXEuyyN/rfQ0eCv9L9ipS505Ld0ytjm2IDiIZGvuOBcgA8qdZ/2tcwB8+YpvLnTNXowCO/2K9+XDtfxeq0OPYReQcerBClglZloLdfeI6MdTYsrLzrSbsU8zNUPnb1YxzLZXnTlh8A9W/B62GoEXB8mbpbPsuabzbKivoPLiWNIJBm2OAIfW
 F9yjX85X
 SSVnYG7ScBTQHLRA8KyMaA01SLulQdGqS1CEtTcNnagoXzK4wsICCPDtqs71L2aMeVJ3Q8jOJS10DvxIQX7qqTvyjgpJp03T46U7sYElLfPjRR0bgiaHYxk0RSwvZHnw1Jz/MIeEqFm8pN+35wIOiVj2P5/gDtiswb8i4lrmzuLeiegpMI1Mh1LDPLhol58PBAtelq+oN3N5wzgFqMoDX62Wc6NUsSfIf9FtknN58gfC7rEG/DcwerMRFMNQbnZU6BLrQnXkZH+P4anNPUL3MwFXlpSf+Fr9pCU3EuPPVmxdmqRTuIM3jGb6+RsHYrUOLia2GMDgTWZCmAukP813jj/oss3IUjFD4yR0oFwdHcMFXdlXhYPysJ9b/SXnSEeznrrTN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 2:11=E2=80=AFPM Yuanchu Xie <yuanchu@google.com> wr=
ote:
>
> Hi Barry and Zicheng,
>
> On Tue, Feb 24, 2026 at 2:23=E2=80=AFPM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > On Tue, Feb 24, 2026 at 11:17=E2=80=AFAM wangzicheng <wangzicheng@honor=
.com> wrote:
> > > *snip*
> > > Below is a short summary of what we see.
> > >
> > > Q1: anon/file imbalance and drop in available memory
> > > Android apps workload show a persistent anon/file generational
> > > imbalance under MGLRU:
> > > anon pages tend to stay in the youngest 2 generations;
> > > file pages are spread across multiple generations and over-reclaimed.
> > > Tuning swappiness to 200 and ANON_ONLY does not fully fix this.
> > > On a 16G media workload we see:
> > > MGLRU: MemAvailable ~ 6060 MB
> > > legacy: MemAvailable ~ 6982 MB (differs by ~1G)
> > > Today we mitigate this via explicit memcg aging in Android
> > > userspace [1], which is a vendor-only workaround.
> >
> > One fundamental design of MGLRU is that file generations and anon
> > generations catch up with each other when the generation gap reaches
> > two or more. As a result, even if swappiness is set very high, its
> > effect on aggressively reclaiming anonymous pages is much smaller
> > than with the traditional LRU.
> >
> > One workaround is to force old file folios to be promoted to relatively
> > younger generations, but this could also cause problems by clustering
> > file folios in the newer generations.
> >
> > I wonder if anon and file generations can progress separately to some
> > extent.
> >
>
> To provide some context, the file and anon generations are coupled
> primarily to simplify the MGLRU logic (Original Yu Zhao's intent).
> Separating the two should allow for more flexible policies for sure.
>
> > >
> > > Q4: Lack of global hot/cold + priority view with per-app memcg
> > > Android uses a per-app memcg model and foreground/background levels
> > > for resource control. root reclaim lacks a cross-memcg hot/cold and
> > > priority view;
> > > foreground app file pages may be reclaimed and reloaded frequently,
> > > causing visible stalls;
> > > We currently use a hook [3] to skip reclaim for foreground apps.
> >
> > Interesting. This somehow reflects that the LRU lacks the user=E2=80=99=
s
> > context, especially on Android systems=E2=80=94for example, which apps =
are in
> > the foreground, which are in the background, and how long an app has
> > been in the background.
> >
> > But this is not specific to MGLRU; it can also be an issue for the
> > active/inactive LRU?
>
> Pardon my lack of familiarity with the use case, in what ways are
> existing memcg protection features insufficient?

I think he means that whichever memcg is next up on the memcg LRU is
the one that gets reclaimed from first, regardless of whether that
memcg is for a foreground app. Because there is currently no strong
relationship between memcg LRU ordering and Android app state. Android
updates oom_score_adj on app state transitions, so it'd be possible
for the kernel to use that information from userspace to influence
memcg LRU ordering, but I'm not really a great fan of that idea.

Right, reclaim from foreground apps is not exclusively a MGLRU
problem. There is an effort in both MGLRU and active/inactive LRU to
provide some sort of fairness (now both are eventually-fair) for
global reclaim, so that no memcg is the subject of disproportionate
reclaim.

I'm planning to investigate applying memory.low to foreground /
top-app for reducing the amount of reclaim from foreground apps.
However at the same time, we are also working on applying memory
limits to all apps (memory.high) so that no single app (including a
foreground app) can use all the system memory as a matter of Android
policy.

Thanks,
T.J.

> > Additionally, I=E2=80=99d like to add Q5 based on my observations:
> > Q5:
> > MGLRU places readahead folios in the newest generation. For example, if
> > a page fault occurs at address 5, readahead fetches addresses 1=E2=80=
=9316, and
> > all 16 folios are put in the youngest generation, even though many may
> > not be needed. This can seriously impact reclamation performance, as
> > these cold readahead folios occupy active slots.
> >
> > See the code below and the checks performed by lru_gen_in_fault().
> >
> > void folio_add_lru(struct folio *folio)
> > {
> >         ...
> >         /* see the comment in lru_gen_folio_seq() */
> >         if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
> >             lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
> >                 folio_set_active(folio);
> >
> >         folio_batch_add_and_move(folio, lru_add);
> > }
> > EXPORT_SYMBOL(folio_add_lru);
> >
> > I could have submitted a patchset to address this by initially marking
> > only address 5 as active, and activating the other addresses later when
> > they are actually mapped or accessed.
>
> I need to read it more closely but that's a good idea.
>
> Thanks,
> Yuanchu
>

