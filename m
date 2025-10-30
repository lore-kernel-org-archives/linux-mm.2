Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8756CCF9EE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 00:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2D938E01A9; Wed, 29 Oct 2025 20:57:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADE118E0106; Wed, 29 Oct 2025 20:57:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD188E01A9; Wed, 29 Oct 2025 20:57:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 884F48E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:57:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C7D64A307
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:57:24 +0000 (UTC)
X-FDA: 84052967208.14.4EA995A
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id 410D440010
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:57:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L7iBeu18;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761785842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GGOSLQUTALcsgNMy+aMsU9t+nwOQ+f3KSncHX5+6nPo=;
	b=2ZvbLxvoY2aDuxL6lfCWizcomX8x6F4so8Qi6lHnZ9sr2M2YBPVZStwO9X/eHMpQVVtNuU
	Yq0FQZKF6JiLxZxX6cmOjnpHUtDj22JAUAUOlR2ch7piYeDXp4saapgXYwBdm06pQfbXO7
	+U3aRHeW4nzAjAA6CGYipg6yq/Zy2+k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L7iBeu18;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761785842; a=rsa-sha256;
	cv=none;
	b=WhTnRlG4+O6vh1tXcCXJnvxxRVIykuzXW1Uncg70tCbDC4RWI4IJwd184MLeNKBndKMF0r
	gY3H8YDBXsNN/voL8yjbOErqHIZiwOYLNPgVwh4DQA1xAZgra02uufUvHX5zHKekAI+IBc
	at9Aqq2t2Kmlj1h1soHxLZ6/aTIxWHw=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4711b95226dso5554585e9.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761785840; x=1762390640; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GGOSLQUTALcsgNMy+aMsU9t+nwOQ+f3KSncHX5+6nPo=;
        b=L7iBeu18v4OhCLcBnpSEdRmgMFXgYj7cZFkPzajfD7ZRVxyaZH4CCKocgTgdX4QfyJ
         PbwJudjzlTyckQaykbavnBhDkQa+8WlqiXwL9jCaZuKIisln0lBj1yD+NKMk4KCjvqVs
         Vykfq281DN2NlhoMeavbj1lVpVsbPpUpKy0kmjA2r4BPq8eY4JQQMXjAcdz17mSCU5zO
         0OkU6bC7xW9f+bRJPN/omKZEM+eCDMDU0w94hrixd1Q8ehI0gFKr3pPgEprhjt8bozjL
         f3GVW588fc3MmU5bigGEGV1TmbAQUZbX9rHZFTU1/h68itWSpXGwpV23U64pkkDn+tZk
         baPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761785840; x=1762390640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GGOSLQUTALcsgNMy+aMsU9t+nwOQ+f3KSncHX5+6nPo=;
        b=W2+FlSDgB0LmMRzZpW+KvdYI4x1UO8wFPLTgzZGEnLe1ArKms8Gzuxo+zC7g/mq/yN
         3UlTcBfymFJSRGtxV2YwJWM8piAROrjj0+2xfxfU7rMAHUbcjWnM/BDkpf0GaSRq+cnN
         r7Q32yGsZKSrFThOSihO6n5OHrEfxKcvvZQssnn+of0QT+F9QXtls0FR75RxU4Dk4kiy
         KCC6R09HzCmnIgAFDaZndQKTxjCaOXQB7GNjcr0VjCHf2RZ59XDPXjVwc3BtdDT2QmnM
         MmMmC/ajZEMGoBnDB+A6h2G3qA279U6zKFtED7dPsH18orrn6NvyjdGLCnLVQ6JS2zQb
         iZ6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUTeJOu1JP/oL5N5OH5SncvhbMIhWNW+9pMPLcIT0t9aLBKnJ4aVVD3WujbMn3MWCG03GRF907RoQ==@kvack.org
X-Gm-Message-State: AOJu0YyAawQLdCuMx+4xbJVO5e9rlfv2JPCwFYoxVXZMhyBsbwkzxreH
	aiYQFdq0bBkCpXBxZeEqO6wz2zV8vNzhK9rm1UgdpSr4wEU+NyaLXg2P92No+yYjAalT9YTHezH
	n8Al7OaAE0GU3G0zZowEROlxvJuWwOqQ=
X-Gm-Gg: ASbGncvxbHy3QRlyuYTDJWpT1KT2smgYbiDNWEGmUCineFLIxkG3em1WGfPtpr1opoY
	VAIE6fmIupjm+pIe4JOvWhdE64IneKdlOGlQhjhOOq5RSDX+ankQWKj/EayILWs3iEj4encbWXU
	pC/H6E0Vyr9GXjIT78wziPsgf43Rke496Ml5wB45iu9qYbTJprQr39hpeGWa1R00ls+MoUMrE7W
	zJBeUsg0Fp2/dtirWi7+9VvEeGfOIiPsjZbNueKXijMbAKmpGCp/6aBN60Ubtx95leBn+Ce4AMC
	rzHwFMbZ9zCWeY08Dg==
X-Google-Smtp-Source: AGHT+IE8ujPhUrddhGr1ou5jGncEGSlrHU/1FNSJfOObUCYG1pNyel0Awu+5uZ4HHENyvHOHjZC7HyCZC9+zzKwILg8=
X-Received: by 2002:a05:600c:3d98:b0:46e:36f8:1eb7 with SMTP id
 5b1f17b1804b1-4771e39f7f7mr33114585e9.10.1761785840454; Wed, 29 Oct 2025
 17:57:20 -0700 (PDT)
MIME-Version: 1.0
References: <20251026100159.6103-1-laoar.shao@gmail.com> <20251026100159.6103-7-laoar.shao@gmail.com>
 <CAADnVQKziFmRiVjDpjtYcmxU74VjPg4Pqn2Ax=O2SsfjLLy5Zw@mail.gmail.com> <CALOAHbD+9gxukoZ3OQvH2fNH2Ff+an+Dx-fzx_+mhb=8fZZ+sw@mail.gmail.com>
In-Reply-To: <CALOAHbD+9gxukoZ3OQvH2fNH2Ff+an+Dx-fzx_+mhb=8fZZ+sw@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 29 Oct 2025 17:57:09 -0700
X-Gm-Features: AWmQ_bl2FRWYQe1q3u6mxOkWzHju5ssI-I6pfEKXXZzZ5UwL_V6B6USXxdaH9OQ
Message-ID: <CAADnVQK9kp_5zh0gYvXdJ=3MSuXTbmZT+cah5uhZiGk5qYfckw@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 06/10] mm: bpf-thp: add support for global mode
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Barry Song <21cnbao@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, Chris Mason <clm@meta.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 410D440010
X-Rspamd-Server: rspam03
X-Stat-Signature: xbhnhia3zedfmbd3z7o65iqsbdyf88z9
X-HE-Tag: 1761785842-978139
X-HE-Meta: U2FsdGVkX1/aMvs621cMqTyCIzERZ6oyGBTyucD0Jv9Akv9lzOJy/ODqge4xMRyrW5Evh80CuppUpcAhuK5qanwevN0UQbm6U0Mb2K9qbS5I2tBFqcqZvMTU9eSKBatJv/qJ7YZNqR2/+OFV+g9fS4mOUiTTWO3rmnRf5CzmEE2RLqGzbbsqs+HDMtTJCQNtwJlV9l4RuP26kUw/np9AH0HJ7dfG5yT3o053IxQ6hr/9ERKRHanHU2HVLaLJxyFNQoDyZHzjW8wLmFbOB8fujOZ6d4Nr/bYjKeU+TQ7oGLCHbZfxE5WS0Z9cBwfVp9lesP/ZqnssghfwW1JG4s/iUV1RmcGAiNt1FqYQWW86cTvge/cpVnN6auiYiMmmOhgn8iHya2jkqpzodlrZK/WqLUI+uR/NqHA1XyTaGDQYwMPanbglubBOHH1JL7j/QFJCeIKKg7cE+LuxNhb6aB6WbjO1CHE/C/FwzNq/A6fH7UFJ3mOPqq9SjKFSAMd66uOjWbIQ1LgevrtuRABqjAwj91ppVwAyR+54Ij5MbXFTHtUgiyeRNm+ITjXPk3laiQ9siBhipawpuPoyRPgvFW22ajuOttJcQ/vRR8GTIEVZlM+4fYKmw7NUV603njj0aRYvjC/iWYr/0OkL2HM9LidOIRhpUYC1Jh79sIe/jBVs6gTuRtrFdIKlThLDNtNivoi8vyPs9XzHRTi3JAXzwm/7SBxox3u9UcHde2Tv1gvga2Lz0G2XhE+QL5VtHAF7tZCLgI+v4Insh73MTnVXjjYnxJNaXKgUgiVyWsmadP7VVIw5baMe6oO8QoOvv7k33i/lubs6xBwRVf60GKeFsBm2cpzHxLZAdMnTCfL0bmktAH6427UQci3Sbw7C1wpUBBs3yYkt9Zje+rTkA8jiK0ek6cD1dVL2AnpoN8rvQZlVbuFUx6F4CSJpssL+OR2wY8VHNqO0gdv8CwSzLfaobfp
 bNkTttNb
 DT9H1SQ2MbQfPmSb4JizVSeqtd7lnTvx6oGRSI3nsk7HxJOryo0GhaK6MXKC0YT2c/L80cJ/sooYBZvKz288xY26ETrMhLv1KvWQVstPUX6uCBUfNWy3qBJejNBpfQ81BUooQMwkowaiJaMd1yX+wv5B+CmnWIdvvsFyWbesXJeWsqfqaTeYOwA+5RXjXYoYcbXOTfSmjLaNChunaI7bqqpjLV2ztPdcFDmd8AGCVH2tEZmJo1ZcMgvAhV2GGxVdeZV9su2UeOlPfRJ1YQkxnSQt0uyA2A49Rgc9XytEmiNZs5vlZCJ2Gn3VylG5TGT0rdkvRvMcMnogtC0PJx2ocg7emmvm2pK4WzLSU+4U98w6nQeYg9YvjnK004a3wBSsfUmFHAH1wBCKc2pUpZTjtulLhYpXVXTLqMh1agRbWhw9U2Fx1PQZuEC8S8QBhT/T6o3mV3fCovFsO/GJR8TOP4uXvwdzovPatKtaz8tG124u4ytvD6uB9mCvZoYV3UlYE/VvB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 7:14=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> On Wed, Oct 29, 2025 at 9:33=E2=80=AFAM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Sun, Oct 26, 2025 at 3:03=E2=80=AFAM Yafang Shao <laoar.shao@gmail.c=
om> wrote:
> > >
> > > The per-process BPF-THP mode is unsuitable for managing shared resour=
ces
> > > such as shmem THP and file-backed THP. This aligns with known cgroup
> > > limitations for similar scenarios [0].
> > >
> > > Introduce a global BPF-THP mode to address this gap. When registered:
> > > - All existing per-process instances are disabled
> > > - New per-process registrations are blocked
> > > - Existing per-process instances remain registered (no forced unregis=
tration)
> > >
> > > The global mode takes precedence over per-process instances. Updates =
are
> > > type-isolated: global instances can only be updated by new global
> > > instances, and per-process instances by new per-process instances.
> >
> > ...
> >
> > >         spin_lock(&thp_ops_lock);
> > > -       /* Each process is exclusively managed by a single BPF-THP. *=
/
> > > -       if (rcu_access_pointer(mm->bpf_mm.bpf_thp)) {
> > > +       /* Each process is exclusively managed by a single BPF-THP.
> > > +        * Global mode disables per-process instances.
> > > +        */
> > > +       if (rcu_access_pointer(mm->bpf_mm.bpf_thp) || rcu_access_poin=
ter(bpf_thp_global)) {
> > >                 err =3D -EBUSY;
> > >                 goto out;
> > >         }
> >
> > You didn't address the issue and instead doubled down
> > on this broken global approach.
> >
> > This bait-and-switch patchset is frankly disingenuous.
> > 'lets code up some per-mm hack, since people will hate it anyway,
> > and I'm not going to use it either, and add this global mode
> > as a fake "fallback"...'
> >
> > The way the previous thread evolved and this followup hack
> > I don't see a genuine desire to find a solution.
> > Just relentless push for global mode.
> >
> > Nacked-by: Alexei Starovoitov <ast@kernel.org>
> >
> > Please carry it in all future patches.
>
> To move forward, I'm happy to set the global mode aside for now and
> potentially drop it in the next version. I'd really like to hear your
> perspective on the per-process mode. Does this implementation meet
> your needs?

Attaching st_ops to task_struct or to mm_struct is a can of worms.
With cgroup-bpf we went through painful bugs with lifetime
of cgroup vs bpf, dying cgroups, wq deadlock, etc. All these
problems are behind us. With st_ops in mm_struct it will be more
painful. I'd rather not go that route.

And revist cgroup instead, since you were way too quick
to accept the pushback because all you wanted is global mode.

The main reason for pushback was:
"
Cgroup was designed for resource management not for grouping processes and
tune those processes
"

which was true when cgroup-v2 was designed, but that ship sailed
years ago when we introduced cgroup-bpf.
None of the progs are doing resource management and lots of infrastructure,
container management, and open source projects use cgroup-bpf
as a grouping of processes. bpf progs attached to cgroup/hook tuple
only care about processes within that cgroup. No resource management.
See __cgroup_bpf_check_dev_permission or __cgroup_bpf_run_filter_sysctl
and others.
The path is current->cgroup->bpf_progs and progs do exactly
what cgroup wasn't designed to do. They tune a set of processes.

You should do the same.

Also I really don't see a compelling use case for bpf in THP.
Your selftest is beyond primitive:
+int pmd_order;
+
+SEC("struct_ops/thp_get_order")
+int BPF_PROG(thp_not_eligible, struct vm_area_struct *vma, enum tva_type t=
ype,
+     unsigned long orders)
+{
+ /* THPeligible in /proc/pid/smaps is 0 */
+ if (type =3D=3D TVA_SMAPS)
+ return 0;
+ return pmd_order;
+}
hard code this thing. Don't bother with bpf.

