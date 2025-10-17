Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 022BECCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 21:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CAE28E0010; Fri, 17 Oct 2025 17:41:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A2628E0008; Fri, 17 Oct 2025 17:41:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0912B8E0010; Fri, 17 Oct 2025 17:41:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7F358E0008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:41:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9AD8183B6C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:41:15 +0000 (UTC)
X-FDA: 84008927310.23.121EC3F
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id B0D8C140002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:41:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xrRgukEK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=kaleshsingh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760737273; a=rsa-sha256;
	cv=none;
	b=N6x9dOIjWu5Vg8JXjSdFS6efZjl4MnUVj76q3d5bkSVp4u9YJmlMeWHWg6no77MmyT29PG
	ZhdpL9TKpk2fNBr4ShkGUOux1WmBuq5QxiMGp01B0VLAEZPX48HS8t+thhoppkuef31Ult
	UyAjlxU5kcXrnJQwQEKptjMblSOJHYU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xrRgukEK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=kaleshsingh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760737273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DoFe3a+bSPCtOzhTS3PznxfwWfc/KsW4h0kLBShN2vc=;
	b=7QLbMeiHZiV4FaP4ejpXbUyKZltartZo6CvHzxpRtJMHde+rjr/80CmuF4TOh9PorkRhGf
	BqD0tBuJhfL1njBXQldLeNO9uITNqm2kKPpqhx70IJxm9moZlHyga6GP07kE6ozryxFg98
	2KiBtr1iri6+kv2ESVTtm89hOHfmtQY=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-27eeafd4882so56905ad.0
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760737272; x=1761342072; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DoFe3a+bSPCtOzhTS3PznxfwWfc/KsW4h0kLBShN2vc=;
        b=xrRgukEK28THVgD/8sJHmQSi9/trL7IOlBDJVvpn+3weJ/xGZ0lIgGZ+wHEv10+FUQ
         enBKIIU158QJiROxI0nDFguV20dZoYU02oKlhcudhPvYVnxa5rHZcf0ViadBZWb8Za2S
         uPA20yyqBgaZ1oWxd+Gy+OUzxnXiWWS72eSsfPBX3pPsDD24XvO+HtOkcBpyQb1SuxVd
         qtCuzeDXEIAFeZi8hF2RVMAAbPKWgU8vOK+Iv9ytUrVsim8/hn/Aeu3GexyBp2O2Is22
         pe5OS0xK583fJtri9u15fK9d+dT/0zH73y6IbEYAF5RdGb2ZyVVPeYerDt6utYWEyA8P
         x7Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760737272; x=1761342072;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DoFe3a+bSPCtOzhTS3PznxfwWfc/KsW4h0kLBShN2vc=;
        b=wqLcDVVaF2aU4gtMLd+6pQhfU5houFkLcLkEsJJZj0Gva7v+I5Fm9rLok6N9ty8QDj
         JNkDWwsMFpuRQQ91ef4QH+eMS+PJPwLKM+KJd/8YCwbq6of/iYFdkul5f01O88rErdNb
         q2GM0BOEzNVZiyULR3LRe+lf2vgg3A1F4kM3Uk3D7t0drW5geoiebbzULw3W37p60DuD
         qan3NEhennKO5IIEQIFrejOxYpmLpV0QaDVgDqoRpbDOUAhzefuFhVQ2GyWPUXxmZBam
         Lbsq0EHxJxdLBfysw/7Ha0MEuBWLZjOZ7VqOqiDfPxeg2rOfJUbnQmk3j3F75eyYKbk7
         2enA==
X-Forwarded-Encrypted: i=1; AJvYcCWue3Rbsz/jVVIKixbhJM3HzbThulfoV6KwOiJkf/DuInj9U6WDF9Bi1Eayp66eQp2dJRMaOro7jg==@kvack.org
X-Gm-Message-State: AOJu0YyftA8xRiZjp6w5ZN7YO0vnSNaiEqiCRqS2NZ4hZHNVbZ1t2lTd
	pYsyeeMJO70EtEfCJJqY6gPBvd4LExL8Xy9Kae/M4/XT7Wfsq5pJydYYmugrpc+ZVBB/GrTTJVB
	410Up33D7GG0Be7vsh03CepFOZ6TUC6IpSKIRLgKj
X-Gm-Gg: ASbGncsLL+EmGN+vGdLkADyxLo9893YQjGaex6UZLFa2Y+UB52kiEgWqwwFW4i3MyEf
	WhJLiXxUjqD9zcBI/70oMSMkk0aleuLWFE6f5OL4X0aYO6+wXMWcC6xKAv20w3Gvd0yzWlLb7++
	/ilFYrn/DbxQTo+4OhaeiyhbxwcesfvRUurunB2NgCDptal7ZuwqLUognEVasXEYUkp8vikY3Us
	miHYka0r2PXd1+6TzHlVFqM0Z0pPDtteNPSqKilhY1j6QFglL+v7Z2kBgI7jZM8vk1O4iLJ8SCy
	ij3c5zvsYz7BjoGaM2Ry8OfjMQ==
X-Google-Smtp-Source: AGHT+IHtptS3qhjfptCTM9UYehBVmfrueMOSL7S+Pfi1w2W7eKNrIq2vjgUpRLWVN0ASJ4z7VbQlA14jLw5KQ0wBFc8=
X-Received: by 2002:a17:903:2ec5:b0:25b:d970:fe45 with SMTP id
 d9443c01a7336-29088aa6b1dmr17839645ad.1.1760737271933; Fri, 17 Oct 2025
 14:41:11 -0700 (PDT)
MIME-Version: 1.0
References: <20251013235259.589015-1-kaleshsingh@google.com>
 <20251013235259.589015-2-kaleshsingh@google.com> <144f3ee6-1a5f-57fc-d5f8-5ce54a3ac139@google.com>
 <098b030b-9d5a-4b1c-ab44-55bad474e70f@lucifer.local>
In-Reply-To: <098b030b-9d5a-4b1c-ab44-55bad474e70f@lucifer.local>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Fri, 17 Oct 2025 14:41:00 -0700
X-Gm-Features: AS18NWDP3VNR9bpkGiOrp1S2qwrmystBtCXn8TObSk7Rzzc_acmKsNrgOHKkCec
Message-ID: <CAC_TJvct_KXyUuiO328MgrHnVPwvx995mEucvRPvNBa9zCekqw@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] mm: fix off-by-one error in VMA count limit checks
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org, minchan@kernel.org, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de, 
	kernel-team@android.com, android-mm@google.com, stable@vger.kernel.org, 
	SeongJae Park <sj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: nzykb5kbjkipswkc6iy6ow8nns9kchim
X-Rspamd-Queue-Id: B0D8C140002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760737273-133878
X-HE-Meta: U2FsdGVkX1/m+xBnUYkLs/UR7ppo3oaCBItCf6DBHX/ZeuV/Dj/ImgsMPg1tatsNRRDHJlpHaJj+xGh2qSA+cET0G92cCbRXgd64ebeZ2xaO9TbgbnrqFIoDoYmPo1apXG3fokZ1NKFAc294bSrKvaWzvlgey/SV3WF00OPWyMYS/3/Eu8DsEUgjavp49mOC3qncBVeF8V/UwH0b8JXrZc9G8NNMEXHJd/naKw0hxoxjbbyloGAyPYa9xXWthKoP4azSRi8Cfo9wl25/C/5mD9eTywpC4vgONtnv81dqlFCXthjZ8NLTYcq6CUM8TECa3wqT36a/omH9dt4V0z+bF33qP3+AYctJ9vmxhCUMDcCt3pv/nDEwlmyEpxqXlPxDG972kKVxZq5eFmbxMfYmCw9SASoeiuGCgi2DDvD3Ad1IaOhwxA9z9CVXxOLm6pRde9Lz5xhxrOIscdydteIYZ6PZarmCcR7aUd0zazYeUgnJ7dAT/usSrDNfs08ikv8vYu3vlg43EcK5UyGxKY0E/CPWMH1kJj1mxAC2Mr2nHL4N3fb+zCQzTgVwn2DxO6c/HRfsd9y54f5QtyCTkB2tOYULah4he6LF2EI+Wdt7/CN4tLuA0ozzbITCVq4XyMlgjF8g29n/v7Z9n6BtYmMmAV2leXwq8HAUKch5SnYmfw6azcf99QtUdRvu5w/+pBVheCkC255KgaZS2r4xD/FOPnVEQpCl+TsTIEZqPBg25TmEkK9wIOcgg5SHGRLN91BYrxKV1Sz8NYJS3K59AA+/O1hsL9uLBcF0UpwCC1rBAkojIWe86vYI593SbJC8khhRALJtA6xRlwI5EOz0TL8aJbHTlRqbtGNQtOoUm5Rjc2m1swfOezv8xk4ujuIvV6BjjZsILHP0WqBNegOjXt3XRCYo5Z32VJynqOc28A3LHYIRkpy2nerF4mT9ecFjI3iKP+kuS0dD6hWVuwdA8MM
 oc7FRy/2
 sVqQsQTq2ch/J180FKPbeMgh4grUTdCZHrFlDQDgJZ7ZM+0SH7GK8BtDvbNQ5j11KqNmkFZtQ7/rqW+sXvHfuiUyCf5WQ9n6VpngNmb7jK9FRcLS2AXTPhY+Us+3PZa4bIKZKf/rF3i+sX3lcnFuf3gJvI0cbnpdC6fv1IQ2hKWNsLXON5SvFc0S2HAGdM3gydWWHS0I7ohV6xggmeLWaEWG0v99vSbrdLSc3VQCQT83di5yBSm9Clu+Bfqb4lIUd4Pq64pD8lLftpjJzphw0meige2EANwmKDJiSeFN+Z0d4i+RBIebVMXidglvuozC5Adu0CglG2yLr+sJTQHpECFCjzyZ9qc66gPqm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 2:00=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Mon, Oct 13, 2025 at 11:28:16PM -0700, Hugh Dickins wrote:
> > On Mon, 13 Oct 2025, Kalesh Singh wrote:
> >
> > > The VMA count limit check in do_mmap() and do_brk_flags() uses a
> > > strict inequality (>), which allows a process's VMA count to exceed
> > > the configured sysctl_max_map_count limit by one.
> > >
> > > A process with mm->map_count =3D=3D sysctl_max_map_count will incorre=
ctly
> > > pass this check and then exceed the limit upon allocation of a new VM=
A
> > > when its map_count is incremented.
> > >
> > > Other VMA allocation paths, such as split_vma(), already use the
> > > correct, inclusive (>=3D) comparison.
> > >
> > > Fix this bug by changing the comparison to be inclusive in do_mmap()
> > > and do_brk_flags(), bringing them in line with the correct behavior
> > > of other allocation paths.
> > >
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > Cc: <stable@vger.kernel.org>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: David Hildenbrand <david@redhat.com>
> > > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > Cc: Mike Rapoport <rppt@kernel.org>
> > > Cc: Minchan Kim <minchan@kernel.org>
> > > Cc: Pedro Falcato <pfalcato@suse.de>
> > > Reviewed-by: David Hildenbrand <david@redhat.com>
> > > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> > > Acked-by: SeongJae Park <sj@kernel.org>
> > > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > > ---
> > >
> > > Changes in v3:
> > >  - Collect Reviewed-by and Acked-by tags.
> > >
> > > Changes in v2:
> > >  - Fix mmap check, per Pedro
> > >
> > >  mm/mmap.c | 2 +-
> > >  mm/vma.c  | 2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/mmap.c b/mm/mmap.c
> > > index 644f02071a41..da2cbdc0f87b 100644
> > > --- a/mm/mmap.c
> > > +++ b/mm/mmap.c
> > > @@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file, unsigned=
 long addr,
> > >             return -EOVERFLOW;
> > >
> > >     /* Too many mappings? */
> > > -   if (mm->map_count > sysctl_max_map_count)
> > > +   if (mm->map_count >=3D sysctl_max_map_count)
> > >             return -ENOMEM;
> > >
> > >     /*
> > > diff --git a/mm/vma.c b/mm/vma.c
> > > index a2e1ae954662..fba68f13e628 100644
> > > --- a/mm/vma.c
> > > +++ b/mm/vma.c
> > > @@ -2797,7 +2797,7 @@ int do_brk_flags(struct vma_iterator *vmi, stru=
ct vm_area_struct *vma,
> > >     if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
> > >             return -ENOMEM;
> > >
> > > -   if (mm->map_count > sysctl_max_map_count)
> > > +   if (mm->map_count >=3D sysctl_max_map_count)
> > >             return -ENOMEM;
> > >
> > >     if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
> > > --
> > > 2.51.0.760.g7b8bcc2412-goog
> >
> > Sorry for letting you go so far before speaking up (I had to test what
> > I believed to be true, and had hoped that meanwhile one of your many
> > illustrious reviewers would say so first, but no): it's a NAK from me.
> >
> > These are not off-by-ones: at the point of these checks, it is not
> > known whether an additional map/vma will have to be added, or the
> > addition will be merged into an existing map/vma.  So the checks
> > err on the lenient side, letting you get perhaps one more than the
> > sysctl said, but not allowing any more than that.
> >
> > Which is all that matters, isn't it? Limiting unrestrained growth.
> >
> > In this patch you're proposing to change it from erring on the
> > lenient side to erring on the strict side - prohibiting merges
> > at the limit which have been allowed for many years.
> >
> > Whatever one thinks about the merits of erring on the lenient versus
> > erring on the strict side, I see no reason to make this change now,
> > and most certainly not with a Fixes Cc: stable. There is no danger
> > in the current behaviour; there is danger in prohibiting what was
> > allowed before.
>
> Thanks for highlighting this, but this is something that people just 'had
> to know'. If so many maintainers are unaware that this is a requirement,
> this is a sign that this is very unclear.
>
> So as I said to Kalesh elsewhere, this is something we really do need to
> comment very clearly.
>
> Or perhaps have as a helper function to _very explicitly_ show that we're
> making this allowance.
>
> I do agree we should err on the side of caution, though if you're at a
> point where you're _about_ to hit the map count limit you're already
> screwed really.
>
> But for the sake of avoiding breaking people who are doing crazy things (=
or
> perhaps I'm not imaginative enough here :) yes let's leave it as is.
>
> But I really _do not_ want to see this global exported so, I think an
> appropriate helper function or use of the newly introduced one with a
> comment are vital.
>
> >
> > As to the remainder of your series: I have to commend you for doing
> > a thorough and well-presented job, but I cannot myself see the point in
> > changing 21 files for what almost amounts to a max_map_count subsystem.
> > I call it misdirected effort, not at all to my taste, which prefers the
> > straightforward checks already there; but accept that my taste may be
> > out of fashion, so won't stand in the way if others think it worthwhile=
.
>
> I disagree very much, I see value here.
>
> Avoiding referencing an ugly global is a big win in itself, but
> self-documenting code has huge value.
>
> In general mm has had a habit of hiding information as to how things work
> for a long time (when writing the book I really had to decode a _lot_ of
> this kind of thing).
>
> I think it's time we moved away from this, and tried to make the code as
> clear as possible.

Hi all,

Thanks, Lorenzo, for the feedback and support.

The consensus from the discussion appears to be:

- Drop this patch keeping the existing check lenient, but make it more
obvious and clear that this is the intended behavior.
- Keep the vma_count_remaining() or another helper and abstracts away
the direct use of the global sysctl_max_map_count.
- Keep the rename of map_count to vma_count
- Keep the selftest and tracepoint patches, which are important for
documenting the behavior and providing observability.

If there are no objections, I'll plan to send out a new version of the seri=
es.

Thanks,
Kalesh


>
> >
> > Hugh
>
> Cheers, Lorenzo

