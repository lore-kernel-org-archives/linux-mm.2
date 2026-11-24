Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50345606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MhpbC1X2
Received: by kanga.kvack.org (Postfix)
	id 63C8B6B0810; Tue, 24 Nov 2026 12:49:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6143B6B0811; Tue, 24 Nov 2026 12:49:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B366B0812; Tue, 24 Nov 2026 12:49:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5456B0810
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:49:30 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AEE8580B7F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:49:29 +0000 (UTC)
X-FDA: 85470749658.01.FF523EB
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id C146240008
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:49:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=MhpbC1X2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795542567;
	b=MH39VDHsvhd5nll36MUGokeTNN5cQ0ZDJ0O1L3vsxBx1joIohmzwZPaGX7UeXFzlK/IQH8
	uMxCc+CUptVRst4mP8Zugr4s798h8K6+77IMFny8pUYAXvtTNljLOiePkS/MXGoA+TNUYf
	OlR0SUZUPGIW3BCPOGgJNac3OQvx3N0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795542567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZpsKsMasCu0VG55k4IFjBDsARDNBPmeWnpoFmnC3rQ=;
	b=mcHDuYkwOt3gN+xPV1gznkX5XiSEhUZ+yfJjYNVaJJo5j520SF+UyLYoJxFvBifOSSD7UV
	A8e5lI976bZxorQUH9Tu8pZTb1+u8UFlyduvmkKVRap94Hk753fSrelWMWV/U9fF1mY05p
	s45QdbTUVFRocr1X+NzAgZtIA6Q4IMY=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=MhpbC1X2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-533202fe429so983081cf.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:49:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795542567; cv=none;
        d=google.com; s=arc-20260327;
        b=Yj0alC5hfY6zVhGrDl6e9jS2Tu5NFwSVNsuaTfHdmOMIRP4/WJ6RJ/xv4AD1hASJ6P
         zf0MISaBDyLl5VfgyW2X5ZYr5yV/ddVwon0Qa1gSQ5gYRR7prdGEBSzphjL67/ratGA5
         ia65HHQmiYdGSlAzZOIHnCIbicH1MqOeH54kW4E8k7evDPmZR8UN5wy0rGw/WlrHPJio
         vFbtMHho/J9VGcNH8SNP9G6ltwRiJXzqM+nyPrgeEktgDSY2m+3Q4m7/e9MliZk6PZTA
         bDe0mwmRwpD9Tg2pA0nrNWnO7Oy6JwdE9fof7xA+w/j4vHiY7saShVl0TLHXaZ0O00HG
         47bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rZpsKsMasCu0VG55k4IFjBDsARDNBPmeWnpoFmnC3rQ=;
        fh=yAb4Gh015Jj+ObJDoRnT8/lnjvMwB0aiD3yuGaJiqgM=;
        b=MNCmF22+32L3lIXrYXbeT3OnJR8fXYvWQQvzz6Id/ERMvi9rVmlgyLf0uKzu0dRy6X
         BRmwizS8nhx+hrxwKAI9JoKuUsaUW5uA7933+VEgfqXxnPljLE5qUC9EGSyKh6D9H+Om
         0eLo/tV+imP1QHCMBGX5a5+IlqSjeq2zOLUSgkW5MCnzv2SB692H7VJN8tgxjjUukVzg
         B031Vk/Mn20AQzNYqhr9ijC2eAzNvmSzr6iRqnDdQKAHshUgvQSj/MYQ4NbORqvvCjEG
         OSsC5gAlio4ButhWiYXmB1wX5CiLQQ8NTWn+DK5iIPn86cQPzJl42cGTAIXCZEQ5m11A
         x+Mg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795542567; x=1796147367; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rZpsKsMasCu0VG55k4IFjBDsARDNBPmeWnpoFmnC3rQ=;
        b=MhpbC1X2dKom2cBZJuQAFjuti7BFjlBJMtAG92J5/eF/E8mDxwIdrc06k6ok+VkXpV
         38SLwoIZcLIWpXqorjja6oa/m5N98a32MmLEUepferkBhxy+/utMQ1/LAo/uy4IFsuA/
         54cjbe2uafcVKAV2/AoR5MzG+BGVqs0e8uw85dHL82ZHatQ+sPTF1dNpzEucUmfO2k0R
         HH/H09ztg7qutCTitAWvIA7+aOqJrjRmnaRtKIdVTyCygiS4E6XyqfcgG48h/qc4GZ8X
         x2kilYWsvAy3HxeYQXoEj9r0EkuG0P1WFxa6oCQfv1txVUIG/0HQyacZ78HoLdmMAKIN
         QKfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795542567; x=1796147367;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rZpsKsMasCu0VG55k4IFjBDsARDNBPmeWnpoFmnC3rQ=;
        b=OKDPNePlLhyIou1Z8F1r3oGF7KTNH6wH8RVXRLsPUF1avocAzuMWQbBqdKS0tApMmA
         JaJacXwL2NcrzObd6ovEYns4aWH47KZGmxslPtCPX4b5n+mS0vwCasQFkAUOWPyDUH0u
         aAOlH+AiO2GSGCX5OE/fMlHibBD+LQ1+V4jLPYoh6/uQ48QFUDFuc7VmKLiAwiyUanC4
         T0LFtNrX2+ZrS2nquUwiw7d2UKvP0IBUpZ1+UoJrPpvu8LrxdFWwiTeYYOGWA9w/op+l
         GiTznrktWPzAjq149dGksfRoxwZr0psbY4MwKI3ZIit4bfUnR+D5kfqa93dDDhTvYv4V
         B2QA==
X-Forwarded-Encrypted: i=1; AL+hErFyoBZFa/f4SpyNVDvyUu8sPPtPoCh1nsFJQd+DbbZOzFQPhL5Nvr9qSnoh59Mg1/gGctBini/M0w==@kvack.org
X-Gm-Message-State: APuU4Z9NuZEqSOs+QoBgPjrgJ1FDQpIzGlB8ahpfX287lbUazU87AH8S
	EXtFEg3SE4kGySvRuuGgTAOR4aLOEsBxuQjUJDEXoRw2rzAESUwSZPcWB+yVY7NF37AYjKduM6F
	GRb7/eCDqw2i7286Ayq8RTaZiyntO5GcQlWv+J2zP
X-Gm-Gg: AZFdTZdm1HoCbdx5ylsmt6v+6pQiiutA87A9I4qlvzlyI4bKJl4dMHt/6Z0GaYLdzlU
	I8twXUK3v+GZBy9Fchaa9m5KqLC+g4EN9zWMlN/9cq6iGjHvZW4NuOCaqzsntxgvilzBGTrA9g6
	gb06Qf/9PNTcPqbGozccuvVHKn6aZzafNUa8nvFkRI0gST4P/l75/aRqElxp78EEE988FfDjHWe
	LbBeTBQ1+jH/hgu5smy2jK9ikVRATsL1FU/Xb+2t2Y8VYZMo0AFPKfsLS38PUlHtMCcHGXLU5zk
	xapocu7Bi4a9Ow3pr4kAxpTk3oY/ddE3uAnKMdrc8Px2xriXsazQKjGLUrPyMQNxXUe2FGyGoHy
	+/8erCETATXQLT1JpzqFIIiiIHsJqxD1SpGXCdKNzQpPWtUPeHaFkNuJ9oHZbbAraEsu/bkboHN
	vsesnjlKc72Yz5GToUfakwUyvVXlvE/6fEW3XNU7UO2cwXTtr5
X-Received: by 2002:a05:622a:1f14:b0:545:7949:80a5 with SMTP id
 d75a77b69052e-55d890663bamr62644371cf.12.1795542566115; Tue, 24 Nov 2026
 09:49:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org>
 <awWLCZ-jBjSD7V3M@pedro-suse.tail5790ac.ts.net> <CAJuCfpGk6eYK43Unxo+O4ML5=GM_siZ9owp6oa9fO0ipZXVg-g@mail.gmail.com>
 <CAJuCfpEd1rz3P7fB7W_mHkyzbpq9TscRE+QNwvHdYME=WJj6cw@mail.gmail.com>
 <awWz3nc_b8x3mIXq@gremlin> <CANk7y0gAxY18Ew+6j5YsqrOsf5Dx+v5M78r7_8JLXh5RHZj4qA@mail.gmail.com>
 <CAJuCfpFuDCUPTUi3SuAhmbtw5tubRZ0+YEY3PotjyJ8Or8pdQQ@mail.gmail.com>
 <awXHR007d8MlhJUC@gremlin> <20261124093328.3ba2e066e5d5081c69e0e667@linux-foundation.org>
In-Reply-To: <20261124093328.3ba2e066e5d5081c69e0e667@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 24 Nov 2026 09:49:13 -0800
X-Gm-Features: Aa3M54rJtgRgH_rcKNgpafDHAbKng8SpV3uhoRslOvIjTwkRWkSfaO8JY91K7G8
Message-ID: <CAJuCfpEmFEX5iqLw_c94a97rVrC+xBWpKnO4rVpeDgkUfAPq7Q@mail.gmail.com>
Subject: Re: [PATCH] mm/vma: drop mm asynchronously in vma_start_read()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Puranjay Mohan <puranjay12@gmail.com>, 
	Pedro Falcato <pfalcato@suse.de>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: dax8ic5h7uqzhb4x6tg837pszakp8ief
X-Rspamd-Queue-Id: C146240008
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795542567-71310
X-HE-Meta: U2FsdGVkX1/ylnaYntBDq57eQtj167bJL5LJOAL3bd9CQqHUt0m2XG6X5b9+YZK521uDiSAmorxnjR7aKsQdkAwZqihnTjDQ5cfzVtioA+PU0dcytq9GubAOPwHhB7b/g0T3jiVjyb3kvAJLeq32JvyzFVo28EBNVDH9jXktEfbJCM9TmmFFnwRUPHmkl3f7xmpGM4mM7psXI89NA6wYFmRztRLpIAitMujzhnSwLf6l5KZ3wKB3COkqtpgyIJicaLEz1InD3Hgc+OX/LInYbHiND9sKlUiJSa+Ni7lZAyTuYOy+6x/aJzkYnp0D/R95Rvw6m7MHCW9YYrQQU2e6PbNkW8/WZln/CwCBfZkLZF98DcYSU5vlAPr7oF1kGwJ01RoW29SWVDzVl2Va6DqJaXP0J3hL0rrOBZR118yO9NInJv3VjLtSw6LtYMSUmSW0P8cGeaKCEprTA6dl2XlodUD2oek97c+/GF5G3kkLyfQBlB4AQkmRuAb2250AIoobKWSI//rOMcHSIiTNOYYL65g4Xveqqgg7+FNPju0KurghydwjDoxAg1y3qfbOxqoA+BmRAQUlvxEwP0Nnje7DnEKIPEiCuIKmIA5VLEMP8ElMNHkrSU4rNeLFeMRVTnwOfGuBSbjxRL97KX7afwiLoWxo+MXv9A6wUGamBSkba7bxJUTVgMXDqG4FEFcJxiiV4pwGtZRz2Mf2K/Lf50hK6FA2Znpw8ksbJdrbBLWWj6IKZIS5HKwVoFKgTRG6WIFvI8+SKzDtizoss6mhUpm03fJrznqRSq3RimYezhgHbhPtFVRitEdXoxcyiDd+uF0iGoc8qyca9599/lvG27vVY/UnXnhh8aKhtHzbulXcRtUvcZl0rGIhhxqzSOfyKAsaYLmVBD8DDUyBaVaeGvmqjTogqPm0Fsv3RaP5o/pA+L5etSemYeit+AxyYi7ri2tDIfVqVLhnoCGU0eIHIq7
 I0uN1aTG
 KQv+D2NMLSM1eIiYnlgDDOWLgIqU2JZpyZayLePiKXWkkPOHTlieARdAOdVchZSmGqrQP8BFcMtV4WxhgCB3QXvb/GrlKrLI9LlL0+xTZf4TqNXvoiPyF5q/gNz6gX9rgRtwGWQsLcpyVHIFBkK/CDINuLfkyWCeUdF+Lx6RtGi4ehHSMelOimEibS2Ileu+CLC5b5drFzDNc/Pr24KUlVem6d9iEmlMUcZvk5ygw9Zcq9f1kOgWJVOI6VKsl5mibrwOl08vmfcAogcXDVQ7tJwjQbQnmtaXue2O0geOUKvH/WO6u8Nsr/TCxK0aL+WVbmBQZulWTBg4GDN+zyd9mLBWXOoiGTHjj0G1Co2t83lbvRJCivzIOQwtEfyuHGNMAKYNoqoGsfodY/zXWw9qI8mTACQFy4rBpJagsQaIItQxE0wEeGYerz6n4yBGculOC6yai/pVWrIQsPqAHRzQJk9tZwWDlNpvsXJjGe/AIWVlQd8EHfmAuauqNZQOWbI1bREEQ/DEaXFLGHrRcnGrnY2+d+08ewApjmKtp+xcjbBpSwagECnD49GXRkWqS+SLRuT5mNaZtqNeN0ud9NYLFantTxEZJmHkOgqsMwtqxvY3pfP0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 9:33=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 24 Nov 2026 17:23:35 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.or=
g> wrote:
>
> > On Tue, Nov 24, 2026 at 08:34:40AM -0800, Suren Baghdasaryan wrote:
> > > On Tue, Nov 24, 2026 at 8:06=E2=80=AFAM Puranjay Mohan <puranjay12@gm=
ail.com> wrote:
> > > >
> > > > On Tue, Nov 24, 2026 at 9:28=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@=
kernel.org> wrote:
> > > > >
> > > > > On Tue, Nov 24, 2026 at 07:51:42AM -0800, Suren Baghdasaryan wrot=
e:
> > > > > > Actually, VMAs are allocated from a SLAB_TYPESAFE_BY_RCU slub. =
With
> > > > > > that RCU unlocking move you don't need other_mm copy and the co=
mment
> > > > > > that comes with it. VMA won't be freed until RCU lock is droppe=
d.
> > > > >
> > > > > Yeah but they can be reassigned? They won't be _freed_ until a gr=
ace period but
> > > > > they can go back to the slab and then allocated elsewhere  right?
> > > > >
> > > >
> > > > Yes, they can go back to the slab and become a different VMA.
> > >
> > > Yeah, you are right about that. So, we either have to keep the RCU
> > > unlock in place to keep other_mm comment valid (my personal
> > > preference) or update the comment next to other_mm to explain the new
> > > reason it is needed. Either way is fine with me.
> >
> > I think let's just change the comment?
> >
> > Andrew could you change:
> >
> >        * stable and can be freed in the narrow window after vma->vm_ref=
cnt
> >
> > ->
> >
> >        * stable and can be reused in the narrow window after vma->vm_re=
fcnt
> >                            ^
> >                            |
> >                            just this freed -> reused :)
> >
>
> np.
>
> --- a/mm/mmap_lock.c~mm-vma-drop-mm-asynchronously-in-vma_start_read-fix
> +++ a/mm/mmap_lock.c
> @@ -300,7 +300,7 @@ err:
>  err_unstable:
>         /*
>          * If vma got attached to another mm from under us, that mm is no=
t
> -        * stable and can be freed in the narrow window after vma->vm_ref=
cnt
> +        * stable and can be reused in the narrow window after vma->vm_re=
fcnt
>          * is dropped and before rcuwait_wake_up(mm) is called. Grab it b=
efore
>          * releasing vma->vm_refcnt.
>          */

Sorry for being pedantic :)
There is also this comment later on:

        other_mm =3D vma->vm_mm; /* use a copy as vma can be freed after
we drop vm_refcnt */

That should be replaced too with:

        other_mm =3D vma->vm_mm; /* use a copy as vma can be reused
after we drop vm_refcnt */

Again, just replacing "freed" to "reused".
Thanks!

> _
>

