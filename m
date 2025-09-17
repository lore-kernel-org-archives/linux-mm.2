Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71209CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 05:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF2A88E0012; Wed, 17 Sep 2025 01:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9D28E0001; Wed, 17 Sep 2025 01:23:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE00D8E0012; Wed, 17 Sep 2025 01:23:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ACC998E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:23:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64BA7C03B9
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:23:03 +0000 (UTC)
X-FDA: 83897598246.28.518E23E
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id 78F7640005
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:23:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VslHPNsO;
	spf=pass (imf27.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758086581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VB85/PaNUJMrdnB5pj74aZCvU4kUegAWUrlhOp8yV3A=;
	b=A7uyIxL3htnZfKvmXzO4m0BUqn0GEcLE618VFAy/C/q/IxdB8iOmhMo+KFi0dc6KI5hTs3
	GZ5ewgciM9hxo7WJbOI6GrPhy+z9iLsM/UiB/IrYpYMSdcP629nO/phFsr2troNVY4yCk/
	9erTvsvgOpEIzKtzGGR0loMllgmSLNw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VslHPNsO;
	spf=pass (imf27.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758086581; a=rsa-sha256;
	cv=none;
	b=mDwe7sHR9jv/g7nQh1k4IkNV/xZuOFNuCLS6v0YF01kyZeyx2DRIyXFULELW34GSjSZhZ3
	+mdyf1FZNNYquiX6UCqxaOQ6GdUz5K5NNCJvM+iBrhYqZzMlAqD/+6W9xrXgnwI+5DbibN
	rd7WW1Tuk/jfkq7kC7BRPkC+DTFJOpI=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-62105d21297so11974182a12.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758086580; x=1758691380; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VB85/PaNUJMrdnB5pj74aZCvU4kUegAWUrlhOp8yV3A=;
        b=VslHPNsOOs4b38f5VKTT/qITiDQ/mE4GVVJRt1ws7JIPnRus8In9CroAxfBxIt8EVQ
         WVUjM/6FH95WgDjXrWXqmPUrUFLkLjEI/owcmiMRYr3tML/vxpab8FpoHpr7hCEMub/z
         RtO6GN1RAh6Lh1GY7edCQBkB5B4gj7XfzzG7fHhuwlF/rWcYd7cHBWL8SNrzQJac+Pyi
         +VvsyQFx1oM84o1jm+ocmfTTyUwRcc+6bbcLTwQuqqecCmMuXFeLAY1Rd8o05BXzTVhs
         306Pql++kUcJPOmGGUIoJZA3R8sSRRalXtooM+uB2fuevxjct3MiHGvdSY8smK9tiHnH
         1+Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758086580; x=1758691380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VB85/PaNUJMrdnB5pj74aZCvU4kUegAWUrlhOp8yV3A=;
        b=Ymr1HxRb/QXOoyoOweoxzBleLldKmTLy7kyBH7z6q8vgmxtw5y2wVZRb46j+YSYRSF
         8qFU29U7m/yX7178vreHHWCMqE78DgUyXt9b0kUDsKQRd76iOjXZRejwrWylbvs5N05I
         DvWZ5ob0OH5i56r1398fr/pCaGTN1j/Gpj5APBEa9RX1V1xKh+h6GhXbWEbQRtyA4QEM
         hon+dyW1a87Dn/JzSTDEI4lnDcR14pl3K1nC2PV9jk68Xr8U0b+zfyXS9iwzM1QCt5K7
         LV+nos4nNxKXW8VvlnnJSbWzN5Nijh9wdQ606OKIUHKS9YIiHscF7g5w8Zgd57ZqSPkI
         r8OA==
X-Forwarded-Encrypted: i=1; AJvYcCUlDnCLhMeLeRY4OQ9wY4Sl2bY3GIwSgJuz+UUQNELJS1coSyrSYChnauFCk4v+UDlTeU0UTcSwGg==@kvack.org
X-Gm-Message-State: AOJu0YwO4hNsrnycPYofJXBT1G3JC2ATmjAy8F4rltA39CpnlwMP0lRr
	mErhuEFkG+IIUhsWL4uB6zAQmDQ3ppJUMJg73rs7Qm+DfcNb+DfMuCA4phpQUQR2p/NbVO0pXg5
	sjVgvBCc3RYHGdr5jW9RasfSSDMQBjJY=
X-Gm-Gg: ASbGncvjuwzUwmwHP/NX2wPNUHPbTqTGBHYbkyMHernLZMfcBooM5MtqIuvfnlVzscv
	mSzJaM0Oz8AUbEQ/6e+7HCNzzdND45qegmVrl4/DlbvGCbKB07lLGPHWIbqa25P6/wxp6y1UEUu
	OSZ4dUYv+XAcBvK6bGzhZ9rKmmiLBzRX2gyfdT3jCp5u/cyW34Wjgk+IttDVVkg2929Cz/n7cvs
	UJ/YZzeY3jC+I0UCFQZzna6Hy344uiM9ku5tfA=
X-Google-Smtp-Source: AGHT+IGW18xtRuU2GK+tpKtajYwOhrW4O1BhSvambII8KyAv0L3MmzAdTmi7DunDdrqaD8FTROygg/qVkaFANLc30gY=
X-Received: by 2002:a05:6402:40c8:b0:62f:6706:7772 with SMTP id
 4fb4d7f45d1cf-62f8468ec40mr917576a12.34.1758086579371; Tue, 16 Sep 2025
 22:22:59 -0700 (PDT)
MIME-Version: 1.0
References: <1eb2266f4408798a55bda00cb04545a3203aa572.1755012943.git.lorenzo.stoakes@oracle.com>
 <20250916194915.1395712-1-clm@meta.com> <CAGudoHE1GfgM-fX9pE-McqXH3dowPRoSPU9yHiGi+a3mk1hwnw@mail.gmail.com>
 <36fc538c-4e25-409d-b718-437fe97201ac@lucifer.local>
In-Reply-To: <36fc538c-4e25-409d-b718-437fe97201ac@lucifer.local>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 17 Sep 2025 07:22:46 +0200
X-Gm-Features: AS18NWDTNu0uFCPWXMNYZriE-TkKq3-qYDDJDkS6S-UwtaAG2QuEVfyEtB1SXAM
Message-ID: <CAGudoHGBedD35u9FnYyPuJV=vT9mUrbtRVREO1P0RdzHhV=1FQ@mail.gmail.com>
Subject: Re: [PATCH 02/10] mm: convert core mm to mm_flags_*() accessors
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, "David S . Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	"H . Peter Anvin" <hpa@zytor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Kan Liang <kan.liang@linux.intel.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Matthew Wilcox <willy@infradead.org>, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 78F7640005
X-Rspamd-Server: rspam05
X-Stat-Signature: k5zf3fhwqu1rxecjmik3ffppjkxu4347
X-Rspam-User: 
X-HE-Tag: 1758086581-376998
X-HE-Meta: U2FsdGVkX1+oYt7jNWnWx8TQRhc+JICDjB2pRM6R9pn/l7QtRxYLhD+4vpBVOccGYFKR4a+uF5ywY/Gjvfypi6rkHURt28alh1UDRLERNG1wjJNwz4y/WBi4aX/1idxwGsO2iS7j+tWf3nFyjTMhuE0rOGan1rA/4y93TfyCFNspq6mJmNiHg8Y3YLsyY7f4Kv8Xbf/uG6rZxXV94/lk2bCFY9mNsdpPehi+XrBmd4gGVGHk6GElsDAm0o2nBGaYdywo3BcRfC3L9Xa/u1wwLdyNGYLdjerwm/gVVGicL2JRt/UOsO47HP8w6Az0RcMm521XZs1X0cZt00RuVEeuTJ9Hoo3uzUC1IPPCv3DoYQgwiyWnD4NbxEVJMMLvdYBSKt0tza77UheKW8NWIsbin//8AffULCMGFzVPS7iR7O4SNwT7WUwwC33i+ozMqz747eSPjsXCvvSVXY8UaNPkscbYTjob+wtn4H61qw2PyQpEmLDU60F77DPU998iJsMdGWkBI4jpmgeo7nJwwlUzXXMDvBVgrsnAVnHTR2L2nqhks2TWjIZ+BnPojFS7+gPRBw4Y/ov8mpXy3SvBqDnApo1bKeHOExZ4ugY2Q7qlF8Wv1+YdEo/E46u5dgxSpZb26xYCh6ivxpTeTUsJm4z328NT158B7CudWenKs8vXKIrCpXgVZwsSH1Q2LQQN9Cbk57RCuggxp9AtcVIAelxroigQOLtLF4FBCcCFDldmDqkBEBenjcvFXd2M8H4C/YeltJIwmW7Jd04xRr5x3EFTX1LHl2ySY+ZHEV3aB/AvoAnhYsbQOnwLuQ7/671phJqOyM53j43IpEwp5gDTOTJBDsh4jbt7/TQ+TBpcFpWA56l4wWfi7jcB6ZcywNsTOCSWWH27GbVgFHqxL48kYdB57T4GmNZs+2sbF2sX0KBN0gv19wgPZJaBi8RKZS3lMYXScO29l7BEZRUUyVOx2mv
 7kP2tKe9
 JLRrOT0ob5snCpUh1sB2fQovtXXYzigRnQlXuyU0HKBePj4YG3frKda2/OrAr5XaI+a0uWAjvikroLaJxtL1jpcFnlIvT1mIa549IK4YvljCEWpk5aWDC3igbPHDiMcRBjg2hWF7r71lIw/M1xGMSqjlPFQbo0Y9Rb6ndkJP/WRSQE+PIx8KiNoVOp2UlVNbNTQqsWjJyO2xydlz4rYP/rUiht0ipJTlTo8lNtsd87AXD8h6XnbhJX+s2O8WuylNhoWgIfSX1HyjUDrwlo+5gyGt9aPsyIboHK3dGQgfes/d6X1LToMj7es3+e3ccAbiHJO/pp/rrLyuqPjVjXeTRoJvOfbzis7PWW7WEPlb4xBCrAcBLehAUM5wGatSu9FZUpARrVr/l/52IpCo8OlNrYv0pFw2rO8Xn69lMa24GCyOwjds59p+a2zyQujrUwaW09imBybRih3kU/dhttfqAaMrBB3FZRkzGV8TLdC+e4N62SfI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 7:20=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Sep 17, 2025 at 02:16:54AM +0200, Mateusz Guzik wrote:
> > On Wed, Sep 17, 2025 at 1:57=E2=80=AFAM Chris Mason <clm@meta.com> wrot=
e:
> > >
> > > On Tue, 12 Aug 2025 16:44:11 +0100 Lorenzo Stoakes <lorenzo.stoakes@o=
racle.com> wrote:
> > >
> > > > As part of the effort to move to mm->flags becoming a bitmap field,=
 convert
> > > > existing users to making use of the mm_flags_*() accessors which wi=
ll, when
> > > > the conversion is complete, be the only means of accessing mm_struc=
t flags.
> > > >
> > > > This will result in the debug output being that of a bitmap output,=
 which
> > > > will result in a minor change here, but since this is for debug onl=
y, this
> > > > should have no bearing.
> > > >
> > > > Otherwise, no functional changes intended.
> > > >
> > > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > >
> > > [ ... ]
> > >
> > > > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > > > index 25923cfec9c6..17650f0b516e 100644
> > > > --- a/mm/oom_kill.c
> > > > +++ b/mm/oom_kill.c
> > >
> > > [ ... ]
> > >
> > > > @@ -1251,7 +1251,7 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd,=
 unsigned int, flags)
> > > >        * Check MMF_OOM_SKIP again under mmap_read_lock protection t=
o ensure
> > > >        * possible change in exit_mmap is seen
> > > >        */
> > > > -     if (!test_bit(MMF_OOM_SKIP, &mm->flags) && !__oom_reap_task_m=
m(mm))
> > > > +     if (mm_flags_test(MMF_OOM_SKIP, mm) && !__oom_reap_task_mm(mm=
))
> > > >               ret =3D -EAGAIN;
> > > >       mmap_read_unlock(mm);
> > > >
> > >
> > > Hi Lorzeno, I think we lost a ! here.
> > >
> > > claude found enough inverted logic in moved code that I did a new run=
 with
> > > a more explicit prompt for it, but this was the only new hit.
> > >
> >
> > I presume conversion was done mostly manually?
>
> Actually largely via sed/emacs find-replace. I'm not sure why this case
> happened. But maybe it's one of the not 'largely' changes...
>
> Human-in-the-middle is obviously subject to errors :)
>

tru.dat

> >
> > The way(tm) is to use coccinelle.
> >
> > I whipped out the following real quick and results look good:
> >
> > @@
> > expression mm, bit;
> > @@
> >
> > - test_bit(bit, &mm->flags)
> > + mm_flags_test(bit, mm)
>
> Thanks. Not sure it'd hit every case. But that's useful to know, could
> presumably expand to hit others.
>
> I will be changing VMA flags when my review load finally allows me to so =
knowing
> this is useful...
>

I ran into bugs in spatch in the past where it just neglected to patch
something, but that's rare and can be trivially caught.

Defo easier to check than making sure none of the manual fixups are off.

> Cheers, Lorenzo
>
> >
> > $ spatch --sp-file mmbit.cocci mm/oom_kill.c
> > [snip]
> > @@ -892,7 +892,7 @@ static bool task_will_free_mem(struct ta
> >          * This task has already been drained by the oom reaper so ther=
e are
> >          * only small chances it will free some more
> >          */
> > -       if (test_bit(MMF_OOM_SKIP, &mm->flags))
> > +       if (mm_flags_test(MMF_OOM_SKIP, mm))
> >                 return false;
> >
> >         if (atomic_read(&mm->mm_users) <=3D 1)
> > @@ -1235,7 +1235,7 @@ SYSCALL_DEFINE2(process_mrelease, int, p
> >                 reap =3D true;
> >         else {
> >                 /* Error only if the work has not been done already */
> > -               if (!test_bit(MMF_OOM_SKIP, &mm->flags))
> > +               if (!mm_flags_test(MMF_OOM_SKIP, mm))
> >                         ret =3D -EINVAL;
> >         }
> >         task_unlock(p);
> > @@ -1251,7 +1251,7 @@ SYSCALL_DEFINE2(process_mrelease, int, p
> >          * Check MMF_OOM_SKIP again under mmap_read_lock protection to =
ensure
> >          * possible change in exit_mmap is seen
> >          */
> > -       if (!test_bit(MMF_OOM_SKIP, &mm->flags) && !__oom_reap_task_mm(=
mm))
> > +       if (!mm_flags_test(MMF_OOM_SKIP, mm) && !__oom_reap_task_mm(mm)=
)
> >                 ret =3D -EAGAIN;
> >         mmap_read_unlock(mm);

