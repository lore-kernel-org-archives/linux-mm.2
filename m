Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C79D4D59F60
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 01:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0273D6B0005; Fri, 12 Dec 2025 20:37:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A856B0007; Fri, 12 Dec 2025 20:37:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31C56B0008; Fri, 12 Dec 2025 20:37:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1D826B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 20:37:29 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E2F28A5DB
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 01:37:29 +0000 (UTC)
X-FDA: 84212735418.24.2908015
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id 81EB9A000F
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 01:37:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D07WOsVZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765589847; a=rsa-sha256;
	cv=none;
	b=bvvahO5uJN8MIb9HO5IcBSrNNv+D3/0RjFUbx7e90gbOSSTbNBfKa+221INzLEMoNA4fSg
	U1cP9YOVeZ9ZhbxvCyDMJ5/4gQVtPArZJzcNiC/jyZKh4xED+Qz4zbyc1EUGVZ3KNz/bt6
	wZp0L3Bv+g6h0O5WmZ+W+xCVyYIy4nY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D07WOsVZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765589847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=csAfRwOb+6hGQnPT+25Zp2eP5dk+D8F+hnBaGvdyJOU=;
	b=fmHfg2T076uihEo0JbBD4fJ7km+62SaK5kf3HCllXkdCh3sDCRH03yTY5Lv25t7NUyr00x
	ijtscHtnuc5s85mUgq08pTpZ+JWukIhiUgDupytkWNsnCkQYWCen7UE8XhTvWv5Lj5qCJr
	1TXkZcRNUXW+BNvMR80xhvrt4Z/qHxA=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-640e065991dso1468703d50.3
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 17:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765589846; x=1766194646; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=csAfRwOb+6hGQnPT+25Zp2eP5dk+D8F+hnBaGvdyJOU=;
        b=D07WOsVZBiLaQ1Q+lNwDqnY9f7OVO/LKrWmrnNeqN5C+mVFGRSpBgUekgdzTvnLmnr
         ygWbSuJO8rKDJpuw1d1270lqMLL3tC3LLAgbDEFjdotXIbBD2Mf50xQaaU2se6t/Amw8
         5wNVHQgQCFEox2eO/tYSaYvnLr0e3WElsV55DWDZKs3uhIf/X5wfJVqaJSG7gIOWIzoo
         pN5r0vJc6a3k3kGnArAfIZR32zJFz5k6CHhKrjNKL68Woflb75pdywJj5qZUailEfPuT
         8yLKyUXVcpTfBrjYswiofjX0kuVDF+eLvv/H8d9U3uXyZ72MPxk4q6eBHVN1nTKLPnUQ
         1Mlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765589846; x=1766194646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=csAfRwOb+6hGQnPT+25Zp2eP5dk+D8F+hnBaGvdyJOU=;
        b=mRipXyGhA4Ddk5PmRQzURYU2CCSSF3Zy9Jd8LMILu+w4psMwCtm/a7runEPOvODCaB
         2ie4UUaBM0B7UUcjQaSQpD6hP/+d2Ug9F1pdJSIk8UYy2bVLHSUHr6XmQcah5qf8uKj9
         PqKrgTTY+2+qZxOOhe414lcCyotbtsqBxZv1oGNkUim49xTcHv0viASDziEL3qbD0y7Y
         n21fQ2TZONzf9isiTnYmLSEL6E/SwwEKlnCXguFxin3Mj8QlQvvydKwNoQWNoAtS8vuR
         DdDuv33GzthpkOg/xJdx8HCSzB1yhfh2lnlQB0QIr1tqmVZRLClrzdgGD0XuWNMuKKSe
         JvfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQm1gH/pXAIftWcG5EJygW23pOK/cSlQKnoXwTeMnW+4h76qIeDlh4lpWt8sqn/hiXyDQqTZDEog==@kvack.org
X-Gm-Message-State: AOJu0YyiJUtI9ce7B9WNtocrstjXE67BrffbDANH7Q+c5GWcTpeR341I
	vWv3hC3VlD75rCMIPTfMsRRsq/WgR+16+rQSyfvw8FToASh6qvaphUFB2FRPlPJejUPxuafvuMj
	LRR2vU+jREstZTTXqQJkvy+YdSH2CCSo=
X-Gm-Gg: AY/fxX6fpPTG+BX/5laY+1FORb/rr8zPKdnTdvKhAyM5jGQP3C7qjQqsu7IOkpUwuiW
	AVZuZXFCo4GUkjLpuGpG7ZMfp0TgHU73/c965vpdHG4LRHcq9iWgIuRvJ5N0TbiC1Y2A4b1Sn5l
	AQbjkyXgnCz24sYZT+5vz6E1NCHKqfQBTTtDEhVxH6WeTa4R0KcVjRdLH2e8AnOgbUigNyyqM+o
	UxAa0LaoJJswuUqO1h3NtDMe/IOe1scd+0wf9ieM6zN574mXo7uTpSb/3FwODufSPaD4O3E
X-Google-Smtp-Source: AGHT+IHwifFUh7ghZ7Sb2I67Rfsfo8yTZn4nkMEXK+s046YgWD01E/NmfDNjVDBefF/mtE2oIr3GKkZDMqdj3mL0lOs=
X-Received: by 2002:a05:690e:1488:b0:644:2e68:d1a0 with SMTP id
 956f58d0204a3-645555dba05mr2603842d50.32.1765589846413; Fri, 12 Dec 2025
 17:37:26 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC4jUGpyezSNMChyOCio-vTA=kK3CYS3O1CzEXxEiMjPyg@mail.gmail.com>
 <20251213005639.50513-1-sj@kernel.org>
In-Reply-To: <20251213005639.50513-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Sat, 13 Dec 2025 10:37:14 +0900
X-Gm-Features: AQt7F2peAf6ZXv8embAaS15t1cFvNlEzS6J9k2Rhhus4lzgna_Wm9102lTI4V_Q
Message-ID: <CAHOvCC6Bt-PcxhT=TJpukSyPyj-9e=dP--aQ8YR9JVKYJ913=w@mail.gmail.com>
Subject: Re: [RFC PATCH v3 04/37] mm/damon/core: implement damon_report_page_fault()
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 81EB9A000F
X-Rspamd-Server: rspam10
X-Stat-Signature: q66tfizme1ieycu3ku1pp9c3einoandj
X-HE-Tag: 1765589847-546966
X-HE-Meta: U2FsdGVkX1+ajCZ4PGBfmMTBYM8sODkfa0DWs+Ip9cP2rfbNc5H9L9pm362gAY82nr0MfmfAzAb+PC3KXcMvOeDC+oY/Xmtp/p8k1CPJZDRUYiNDU95txTh+QNy5YjEfhMKFkPJW+QkH5MgF4+ZR/HIAS9bZYcgHKD2ZOlJzFUqE3TJF8HLi5eAJcNnPvk46Xy/BQPSlAuqOwlEzz/pOCdNiwmGUWyJIZbu0rbCI7hcUyqo3YDeIZ2GfoVPNJ42oQbthE1S8rXOzo0lihJS5ioYcGufZlNnCVgzrd3VEX3/Aj5uEiVDxQGUUUbsby/IM4trbMziWEJ5RV5OXUZQC6rH7Y53Be8YwRBOrIszTMbJr0hQMjVcZQ6emFGkVO5nN5OWosSjAsXodoikwY1KfwZJHdSrpGz8yNPzWs1227JTiogS9yO7+hvxTOWNJoK1bxRmrtOTVbPfr1NG206cu6k3wFmdnIAdZTirVGuBZ9olHMjgSZonXoIThzW6vwZe/5f9xIL1QiIw40jeAwvVhznkvsBoDa2QlaZRKELixo+krHWQAQE6XFvorQWCWDlwX/l2UKY2N50oRwp6UDgGg18I63za08xBhIq4Ew772ezMrpT6ehK5QQMUt1jfzXY4qbXpaLeTzvQ7tLwozwueDeoMdT3G5XtWDEsNWVpExPY6PNCzv6f5yZ5kfS3W16iOeswsK8cZfImcZ6z2PSF489Dt6oxQj9ZeEkmt7shlHXGcz4WhZWOFax7IaZ2v03BdrkSNDLyXVW8mm/WfgZtzyLd0y8dIo5UwI7HaDwZsZ3oSPTEsRbYkQrn9dKXKTcYCf+wxorHMod4s6R128NjjlLIGsznrnp0YS8AGGDQvpRD953ByCxf4ux2Z9xth61VGHXxetUwV0sqzal1kTpo1TS5DZWbvcDyVHf43HgyvAu8R8HGEF6VrXBISuNmi8dvZbYI8iwOPUxFqMXXpLFBL
 ybIsQtDC
 AC9Ar+boSmfwbb2wkx7PirM1UF/b21esONiX/al0c1QEFsSaN8G4wgsIV71K2S+CECJT/QqpVf6F2SzgAgt6zdLbbKtdi5FEVJS6SgVZ8snp00B1Nyh3YqyR7n3xf/+xCOS7mwiRDLHgtMgKQukVWUTauXvgM5AKT2JotuBgq5OOK14CgKZonu/ArN6ZbUf1Z3T0SCMcye7prIQbfL2TmhwglVkCMsqVTmzLLKhUpdlCIpje2hOa9ufKQYpcEYl0VbTfIb5cybCtcGNxgDaacoWU7LuuLsMhoKsdfQcrbdf8972Huhpt51WIWNiMhG8GNHUXVkh0dsJQbyme/O3+LuhlRB73G1s3bgWyJr8HG3f2PuCz/5Z4RZxCQDfgjH2gfEWXG4D1KeN9u680gWtf/QUluuqbr6hyQHkfM3QIajmirIWt+IvmIB1QIsvkcaaAl4OpXHqA3I0qyw/QLYcs6zFSr2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 13 Dec 2025 at 09:56, SeongJae Park <sj@kernel.org> wrote:
>
> On Sat, 13 Dec 2025 09:31:22 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrot=
e:
>
> > On Sat, 13 Dec 2025 at 07:47, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Fri, 12 Dec 2025 21:46:03 +0900 JaeJoon Jung <rgbi3307@gmail.com> =
wrote:
> > >
> > > > On Mon, 8 Dec 2025 at 15:33, SeongJae Park <sj@kernel.org> wrote:
> > > > >
> > > > > Implement a DAMON core API for reporting page fault events to DAM=
ON.  It
> > > > > is a wrapper of damon_report_access().
> > > > >
> > > > > This is a temporal hack.  In future versions that will have no RF=
C tag,
> > > > > only damon_report_access() may be used.
> > > >
> > > > It's a minor, but git am throws an error when applying the [RFC PAT=
CH v3 04/37]
> > > > patch file.
> > >
> > > Interesting.  I can do 'git am' this patch without error on mm-new br=
anch.  Are
> > > you using something other than mm-new as your baseline?
> > >
> > > > I am testing it by modifying it as follows.
> > > > damon_report_access() is
> > > > called by damon_report_page_fault(), so they depend on each other.
> > > >
> > > > #ifdef CONFIG_MMU
> > > > void damon_report_access(struct damon_access_report *report);
> > > > void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd);
> > > > #else
> > > > static inline void damon_report_access(struct damon_access_report *=
report)
> > > > {
> > > > }
> > > > static inline void damon_report_page_fault(struct vm_fault *vmf, bo=
ol huge_pmd)
> > > > {
> > > > }
> > > > #endif
> > >
> > > Seems this is not for fixing a 'git am' error but build error...?  Ca=
n you
> > > share what error exactly you are seeing?
> >
> > You have been deploying RFC PATCH v1, v2, and v3 starting from 2025-06-=
29.
> > I am currently working with the latest version v6.18.1 (as of 2025-12-1=
3).
> >
> > $ head Makefile
> > # SPDX-License-Identifier: GPL-2.0
> > VERSION =3D 6
> > PATCHLEVEL =3D 18
> > SUBLEVEL =3D 1
> > EXTRAVERSION =3D
> > NAME =3D Baby Opossum Posse
> >
> > When applying RFC PATCH v1, v2, v3 with the above version, errors occur
> > in several places in 'git am' as follows.
> >
> > -------- [RFC PATCH v1] -----------------------------------------------=
--
> >
> > $ git am '[RFC PATCH 1/6]'
> > Applying: mm/damon/core: introduce damon_report_access()
> >
> > $ git am '[RFC PATCH 2/6]'
> > Applying: mm/damon/core: add eliglble_report() ops callback
> >
> > $ git am '[RFC PATCH 3/6]'
> > Applying: mm/damon/core: check received access reports
> >
> > $ git am '[RFC PATCH 4/6]'
> > Applying: mm/damon/vaddr: impleement eligible_report() callback
> > error: patch failed: mm/damon/vaddr.c:610
> > error: mm/damon/vaddr.c: patch does not apply
> > Patch failed at 0001 mm/damon/vaddr: impleement eligible_report() callb=
ack
> > hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
> > When you have resolved this problem, run "git am --continue".
> > If you prefer to skip this patch, run "git am --skip" instead.
> > To restore the original branch and stop patching, run "git am --abort".
> [...]
>
> Thank you for sharing these!  We are working on moving baseline, specific=
ally
> mm-new in most cases.  And we keep under-development patches on damon/nex=
t
> tree.  Please refer to the document [1] for more details.
>
> And a later version of the patch series is for replacing the old version.=
  If
> you have no special reason to apply the old versions of the patches, I'd
> suggest to use only the latest version.  And if you have no special reaso=
ns to
> use only 6.18.1, I'd recommend to just play with the commits on damon/nex=
t
> tree that was used to generate the patch files.
>
> Nonetheless, if you have a strong reason to do work on only 6.18.1, pleas=
e feel
> free to ask help if needed.
>
> > If I build the kernel with the above status, I get compilation errors
> > as follows.
> >
> > /home/arm64/projects/kernel/linux-stable/mm/damon/sysfs.c:758:25:
> > error: =E2=80=98DAMON_FILTER_TYPE_WRITE=E2=80=99 undeclared here (not i=
n a function);
> > did you mean =E2=80=98DAMOS_FILTER_TYPE_TARGET=E2=80=99?
> >   758 |                 .type =3D DAMON_FILTER_TYPE_WRITE,
> >       |                         ^~~~~~~~~~~~~~~~~~~~~~~
> >       |                         DAMOS_FILTER_TYPE_TARGET
> [...]
>
> Makes sense.  Again, I'd recommend using mm-new as your baseline or play =
with
> the commits on damon/next, but if you need help, please feel free to reac=
h out
> :)

Thank you for your detailed and kind reply.
I am glad to refer to damon/next and mm-new in the document [1] you provide=
d.
I will continue to share the analysis with you.

>
> [1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile=
.html#scm-trees
> [2]
>
> Thanks,
> SJ
>
> [...]

