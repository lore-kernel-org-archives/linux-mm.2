Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FC17CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 00:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADC7B8E0002; Tue, 16 Sep 2025 20:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8D308E0001; Tue, 16 Sep 2025 20:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C0E8E0002; Tue, 16 Sep 2025 20:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 829BF8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:17:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D6F2C0191
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:17:11 +0000 (UTC)
X-FDA: 83896827462.22.598E68D
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3199040003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:17:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f8FyKfj8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758068229; a=rsa-sha256;
	cv=none;
	b=vGAAzZa7PPSzyHiVf9DZad1tRsdDPgP/vJGe8K2ywQz11T4OW+yXjQvAz391g8LmB3EEZi
	XKXqCKdcJdmebM3o9LenvzqVeV8FBQuNfWL1Ydo5Mcfxg7Ct1fuhd7x+rrO+6CmNZpXOja
	nfchIlHhgJynCYvA5TnM9TuXFdx0FmQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f8FyKfj8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758068229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xXSGAh8chrKBAWdQa4v/8pOW/Kzc0QCjuDzlGtOmWtE=;
	b=Z3g+2fM7yVyeOUf09P4TsLIEt5NtBM0nYw1Fb2ckR4KoK/pjeBXJuRMWzftML4SI8z8Dtn
	DXB4fSWHFnZLgO0UQgLcLEEhGJsThvoqtUQNezQTW/zYUX2GLlwON4wa5SLWvNspaMbm7t
	l+/ckV8hdBZrGreQMjmxRteXpTg015g=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6228de280a4so3677466a12.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758068227; x=1758673027; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xXSGAh8chrKBAWdQa4v/8pOW/Kzc0QCjuDzlGtOmWtE=;
        b=f8FyKfj894Z3vwH7wWja4uG/TxNC0FYWzlA8/5cn7fJZN8tSBSN9XoOyjpFB0hoSic
         lpqCZtd4vXr5b3JuMQS6ox4drYUCRIFnJhefk2dmiv1ypblNJ+GhguGpSKwyh1rHaUhZ
         0tpVzNv/Yg1jB/PeyLqxfdJIhXfNIVszpChj84liSIHJW3fDI6y7DqXQcP7SkWyILIbO
         v/iC6g+70sE6ebD9xjjEmAAivcW0U0iUnphmKfm1OrEfgAD0qm0jiy0GbqmRHOmiOd86
         WmdXl9YAALEb4UVcH3xapGgORvzrXh5829m1z4iHqoQfCvwiteirMwANAU58pExbcbwv
         lTZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758068227; x=1758673027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xXSGAh8chrKBAWdQa4v/8pOW/Kzc0QCjuDzlGtOmWtE=;
        b=wjrgGNJfvsT4845SPI2gHUMlQYMbNzC/3ta1TUPV5bUMV6ie1EjxCnyg2wRjOuiNtG
         tSqMgKX+4/M8NFm7hckVYBVqRhZUIvGg4Zq40FD/+ijGOomHSB1YYVsmOJW0r5tL99C6
         Q6TXKncE9cg3baku4WCm5j8XBnUDrOGlv3HU8IWygnVAoONj4v8x7o5lTDUGXeqjEK3b
         L5Yu/DwbfgfO6xEvV8SHTQFceFVzyer3QUWcloNt3NI+ZfYKJuRTjvU5k8ZXmUPoXUU+
         WLH7LXfLTEBo6nFit7riRjYaRLeFrue6BMr1wFWcm9DEwrt/R/002PGgBY+c5ACaEAIW
         IYxw==
X-Forwarded-Encrypted: i=1; AJvYcCXN/GJnizwEwreR6kqQtQENNi1OBks62vz7RgN7IJLngI68FL1SAvnplx+/FDQhgFbJvYP95AMfMA==@kvack.org
X-Gm-Message-State: AOJu0YxW5zFzXcYNpWoOqijxCbX05mYDrQbbewX/+9kBDdPoAGLKXzdz
	2rRrJ2BtczpUOtHXpIfvLRclQdaxkmrAtk4Foo88GK94OhdiQ7gANg5CRaqikg1AFs1HZv8UB5F
	71d4alUC5VS6YTDcxvWm/QDAXd28EVOw=
X-Gm-Gg: ASbGncu4kljwW+Xr5R31fQ47CSvbdYvG8V8xAFsWAq1tsj2zRmtJft36GVePRD3/1KX
	KtEwBup0vYRDBS03SIhqzIVacj3yclFfJ+C/OWX5YW3sLA4yBAxV4V/wkGC3AZK+2m/jZ9x2QEJ
	uVZzS4ydjYRqGAzdSlu59/q82xpBKEB51Fd0oPvruRm82iaSVcxMCBnmSck/gXhdL14FTI0jeb9
	Eq06dhIgig9bZgmpvt9mBBMC2uoFSP9zkxi54o=
X-Google-Smtp-Source: AGHT+IHkWc8z+1xTqfr6RJDMY4BcUWdUqKw6o2ECW5HvusjoalWjKeML6JPCAbs/M1LUcK6l6vjMuNB824YFNjkP4LM=
X-Received: by 2002:a05:6402:26c3:b0:62f:2afa:60e6 with SMTP id
 4fb4d7f45d1cf-62f83c3f396mr486555a12.7.1758068227086; Tue, 16 Sep 2025
 17:17:07 -0700 (PDT)
MIME-Version: 1.0
References: <1eb2266f4408798a55bda00cb04545a3203aa572.1755012943.git.lorenzo.stoakes@oracle.com>
 <20250916194915.1395712-1-clm@meta.com>
In-Reply-To: <20250916194915.1395712-1-clm@meta.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 17 Sep 2025 02:16:54 +0200
X-Gm-Features: AS18NWCoF9toVvfO2cO2nt5EYzoV_mx2NXf7z13bcCNBsYM4N3TAXw98oK0bZL0
Message-ID: <CAGudoHE1GfgM-fX9pE-McqXH3dowPRoSPU9yHiGi+a3mk1hwnw@mail.gmail.com>
Subject: Re: [PATCH 02/10] mm: convert core mm to mm_flags_*() accessors
To: Chris Mason <clm@meta.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3199040003
X-Stat-Signature: 7958w3r36wmfhu5fd1h6t3fjryhgzpdr
X-Rspam-User: 
X-HE-Tag: 1758068228-111253
X-HE-Meta: U2FsdGVkX18jZceTZXVRPyPrdIZb/V197upxQLDv+7m8EIizmuUpcb1ieE4Ec3x/RUOVX48OWgS0tBxSUh6ixLy0p1JXMSwSTVSn2/aSJb0KHSxYy3dPmITNr/kKfFZYvwEbUNLGpm59yTkS426o6mlCfuZ9m5UkSrjwgmX5wHD5MMTCedw49ZC3KCqsNLXrDLQ3vgwe++j6pOxuCpCbQX6/0ZVGkcufyUL2X94R0MqVx1fhe8dshMOUWzlnqppFamWR9TOXT3pq6M90jGpoNbfJ+agwXBFg71y5/U12CxLp601IFoumYH2RXTZjGUIsNdaLJ/z+Z/ekpWkqfUM5CeuxO6YQ6rYxAoqFppqGCnXksRymjjckG6Mg25pPGno1toEo/BPZfjJd6LtJULcRs5XR9yn692hVIKPy0kPpJokHbc8TVEEtufN89DUSDN7qJ73GRQ9CS9Tbfb4wfV+zCEqZxCwRJcop6ZFM2Lw6MMpFLezheOWYKxwmT3YujI6t8Azld/z5D5sR+LtVGthB2VQFrUuT7MmyeWwg62GAl+lgpZ2wFoKPeoyqW2ClU5Uc8XAr3u37jrBvBUsUclmzDFp+5skGLLn6kXM9kM56mzFV5zavWsLupywxJsv8A315It2vUiPX6CZDr5SsWaATHplW6eRJUIpZ2tVkjnT848GjrHraSt7AvpTm0w9asHEDopeWG6pL/v8BNSc2cYbOOq7aF7SkDKRTegOY3F0Y6FEW3iua1jIdemFZ6uPhe2RHL+/8waeZ4HDbY7d1HrPuGz1AQixB9zUteylSk6wspnVBhkVzWjT+gJx68G4JHRqtdVp+9W8s0nkyDmOJT49/LTneYnLKuu7i1MypnvAlFrJhDigE5GlpTURs2G5PW85df3VF50Et2F92lSfE9rxnNUETwjQYH7cHQdr0bjm6LJzc4MTq8qcCaOgOwVxXqC/lMSAhvQ6nn34IzWRU0W7
 dtJe2J0d
 BuwzXnxI3+pOFrCVy193mWlqhAsNQIFHin+7d3aJ/CeEoamE/+sYxYv8SHzUt3lB9myfg1t3Cnk5ZLmGcwoQxuMNHCgUP4y74PP37uq7PmDS3+GqwKGltEKXnik/91NzMWwS4iWGVePszeE4GDArtDwhCwymyzy/mzwsAXnuENMea2qDQ7ASD7dD3ukyMaVjQFQJrLUqqRf/JbL1lo3uEP8aSxiYdRerNFB7kzjhvfRy/e8L1ChidSMIjQxTpOa3mB1j/+v93GmshkXPi2Mg61bXsX4aamXcBuZDrnY9V2AVGE/hUzSWXpCImU1jLcplvMOQv1gVkBT7X+Q6OpT+PjLJ6Ls4yh7wTkKBpkXoFmS7maaCTHFMjVUQtRfoT6P7lXS1K9hOtUnNRuHt2PTh0Vd3DWYckVoe7MadedMPTOKHZHT/cwEEW9d7SlJYKDHJhEhz5WPJDUabTLnXbCclje86MDq+5XTNxqNuZIuRTp0Yo4aI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 1:57=E2=80=AFAM Chris Mason <clm@meta.com> wrote:
>
> On Tue, 12 Aug 2025 16:44:11 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracl=
e.com> wrote:
>
> > As part of the effort to move to mm->flags becoming a bitmap field, con=
vert
> > existing users to making use of the mm_flags_*() accessors which will, =
when
> > the conversion is complete, be the only means of accessing mm_struct fl=
ags.
> >
> > This will result in the debug output being that of a bitmap output, whi=
ch
> > will result in a minor change here, but since this is for debug only, t=
his
> > should have no bearing.
> >
> > Otherwise, no functional changes intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> [ ... ]
>
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 25923cfec9c6..17650f0b516e 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
>
> [ ... ]
>
> > @@ -1251,7 +1251,7 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, uns=
igned int, flags)
> >        * Check MMF_OOM_SKIP again under mmap_read_lock protection to en=
sure
> >        * possible change in exit_mmap is seen
> >        */
> > -     if (!test_bit(MMF_OOM_SKIP, &mm->flags) && !__oom_reap_task_mm(mm=
))
> > +     if (mm_flags_test(MMF_OOM_SKIP, mm) && !__oom_reap_task_mm(mm))
> >               ret =3D -EAGAIN;
> >       mmap_read_unlock(mm);
> >
>
> Hi Lorzeno, I think we lost a ! here.
>
> claude found enough inverted logic in moved code that I did a new run wit=
h
> a more explicit prompt for it, but this was the only new hit.
>

I presume conversion was done mostly manually?

The way(tm) is to use coccinelle.

I whipped out the following real quick and results look good:

@@
expression mm, bit;
@@

- test_bit(bit, &mm->flags)
+ mm_flags_test(bit, mm)

$ spatch --sp-file mmbit.cocci mm/oom_kill.c
[snip]
@@ -892,7 +892,7 @@ static bool task_will_free_mem(struct ta
         * This task has already been drained by the oom reaper so there ar=
e
         * only small chances it will free some more
         */
-       if (test_bit(MMF_OOM_SKIP, &mm->flags))
+       if (mm_flags_test(MMF_OOM_SKIP, mm))
                return false;

        if (atomic_read(&mm->mm_users) <=3D 1)
@@ -1235,7 +1235,7 @@ SYSCALL_DEFINE2(process_mrelease, int, p
                reap =3D true;
        else {
                /* Error only if the work has not been done already */
-               if (!test_bit(MMF_OOM_SKIP, &mm->flags))
+               if (!mm_flags_test(MMF_OOM_SKIP, mm))
                        ret =3D -EINVAL;
        }
        task_unlock(p);
@@ -1251,7 +1251,7 @@ SYSCALL_DEFINE2(process_mrelease, int, p
         * Check MMF_OOM_SKIP again under mmap_read_lock protection to ensu=
re
         * possible change in exit_mmap is seen
         */
-       if (!test_bit(MMF_OOM_SKIP, &mm->flags) && !__oom_reap_task_mm(mm))
+       if (!mm_flags_test(MMF_OOM_SKIP, mm) && !__oom_reap_task_mm(mm))
                ret =3D -EAGAIN;
        mmap_read_unlock(mm);

