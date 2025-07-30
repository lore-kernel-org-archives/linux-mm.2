Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5D9DC87FCA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 02:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492046B0092; Tue, 29 Jul 2025 22:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4432B6B0098; Tue, 29 Jul 2025 22:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37FFC6B0099; Tue, 29 Jul 2025 22:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28F106B0092
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 22:32:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9AC42802DA
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:32:23 +0000 (UTC)
X-FDA: 83719356966.15.2A548A5
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 911831C000D
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:32:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AYsLKaE5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753842741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OSdrNqk7apN4PoKxo9JFJtvNeGWmBBKLJgsYG8mDMZU=;
	b=Tj4aZUgYCVttnfZjfv91cdYzkUPQed3w3ljEmoUCFVaE1YCOriVopDAPhYcZhlIr1tfzIK
	GctdaHVYujachUyHmqJYuucKDw/eJ9y701s0QSkFXa1/lqqRjc6WqiG95fg17t0SRP5XWT
	OHVBAGXE4T2lSsAruC5nveU8ucdYdyk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753842741; a=rsa-sha256;
	cv=none;
	b=dA5q6yOLxRG9HMej7rxC4JsIHV9DNZec0Ct4otpTuZFAD6jeMNmJMaJGLFp1ryrIvIPcs3
	4km295vAhkBWsu4DkifGDwKgUyAQCvehCd2CPNrwhHL2CZkzY2yZhl97mJS64eVd3TDJO7
	IVGX+YwOeV8QNTko2ng4jZsS/zZrtFg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AYsLKaE5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-70744e8ed6eso25228206d6.2
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 19:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753842740; x=1754447540; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OSdrNqk7apN4PoKxo9JFJtvNeGWmBBKLJgsYG8mDMZU=;
        b=AYsLKaE5+uDLjUmJhunSCVoEQNIB+afcMRGzAPn7GZBo3UnpV9b4QbSU3s3gEJiM0L
         L7zcyNoU8xKr2MUxfcl4GNPSsMzgBOyq3KmwPNItMgDZtG+dYEXzaXXEjNAgJDZbRyyp
         PNHcu6RJ9MiS2/SwyJRUf6XrL1uxqUEAqJ/0TTrd4d0efDKnN8c7C8do+4AAUQ+cUF4c
         kAVY5xO+NWcXQ40HRrYVOIT8bqLhV5q4NP4ql3HRBCNGiDKDubq2zTuAC8qi22+WasD+
         J+dfwVJnJZtZ2CgdzbHhPrVF81YmnDaI+Nc/zAgLmnMUDXhgpuE6QEwJe/t9XIH3pkHc
         lIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753842740; x=1754447540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OSdrNqk7apN4PoKxo9JFJtvNeGWmBBKLJgsYG8mDMZU=;
        b=eVfgOX4a15D7IP5/WooOiarGgJLr2x/k5C+3rE7VCOh3LUtdmcSLGhVVjU8tvZ99Y5
         r8G8i3QGKwxwDl05FkfvglO3iFWiaInNYb37z+5fWFTBZjc/I8mCipHDdLKjtRoH00SR
         JgL2qVXeIFls0lYrga3oIt0OyajohQccLaT56NUJu0ZhIwQVm+Qj/MdIdMinHjJJpRxt
         anh2DRtmsqDvINkvT637h30zs2yHOmKEu3fpgxImjKSojvSV7aXtLLx9V5c7EM7MRSxY
         cPzZZx/VUqQ2ancWUrj+7WZLG4hiAsYc2Vj0jfOc/0oB/qsysxi4ezsYg/dN8BpL3E64
         JCzA==
X-Forwarded-Encrypted: i=1; AJvYcCW+o9tENFkI2IJRlZDu6GjqBf/17Wi9veEvFjr/Et75KzLM4HUgFqYC42V+lHzI35qSHkmZ4gXmMA==@kvack.org
X-Gm-Message-State: AOJu0YzoVp/q5LWxrbS/LP42mQZglgPNapn8ESF2eCTxH+CDb9yZ/zJC
	relkXiwrMUsaP/+10IRcBG8qaT43Gl+gIU9NNPYVHYhJD+NuWfM3MuCS6/oY2cUKIdBrRPyviua
	aV4h/EWzcdwXhHYvLOzM2G8bcO5LH0X0=
X-Gm-Gg: ASbGncv8wQEmBvMvugNLF6WgRRUzru0ZHDfi6e6CGLKFPVOLJeHbZuwrN2pHfBi/3Ng
	sbour6txjl2FjlgkP5RNh6nSy2zspikhzFTYTv+FfGD0nPLrxK7zWuNW2Sy53wAmVCQ41m4EWm4
	EvfgHCbrORw1i5V9OfjWpKIZzI+8WcacK3ExauuDMYhidiMkcvrQ4dxbEONNIP5FaSQJJCJ8uXT
	FmpAKM=
X-Google-Smtp-Source: AGHT+IHRf5Cl5qaMXk0K+z+ITU7Etj+RVem/klgU5pn92p08+EgcJfhh6TqXxZMHFoSeOhbUtXNZkG6kszlvkafjTqc=
X-Received: by 2002:a05:6214:f28:b0:707:3d2e:10b1 with SMTP id
 6a1803df08f44-70767114bccmr25338816d6.26.1753842740519; Tue, 29 Jul 2025
 19:32:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250729091807.84310-1-laoar.shao@gmail.com> <08D7155B-84F0-4575-B192-96901CFE690A@nvidia.com>
In-Reply-To: <08D7155B-84F0-4575-B192-96901CFE690A@nvidia.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 30 Jul 2025 10:31:37 +0800
X-Gm-Features: Ac12FXyVY7VxH-PclNWhwOUz4PaSKOLg-dKTL9OWN12oyQL1HTf3H_qW6d5Jd8k
Message-ID: <CALOAHbDRBs8bdXB_LJjx-7gALOCLvmMxFD+c7MbHAiQ3htXawA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 0/4] mm, bpf: BPF based THP order selection
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, david@redhat.com, baolin.wang@linux.alibaba.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, bpf@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 911831C000D
X-Stat-Signature: k1axcfqtf4qc54szieokuooh6qkzhrpo
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753842741-677273
X-HE-Meta: U2FsdGVkX1+3WksqCISx0m/q5+fUdpi34KrKPfnRJVPNLxsUTW3OOJ2CGiftJeHZFPkPLW2XFINpqxs7hzFWJkHZvmPwrdIU8NhAjz2MY4UKjei+2fkh3zF9UXYoW1/O/xVr3r4lm4Eiym1PvtiTnh5c8Nw4wpTZGHGmNh3fQsITTTI5r+oxjhf+iXvN6qzu03lH/YVpxhSZPkeF+e/P6vrEgbYxsU8CiMvJWltHBq33J4Svlq7upkXoCe3pRqeTPQM3vDZjkV3Ny1bbX0GNSii0H6TALV+Y85sINzem2pWXJtU3HX71zW9CGxSpcFwZkSv1dY7qQWW1Con+mXKq+pdSRHipIxPOSNSjrrBm2XOeZuJppFCvxOvxz/tkCchxZL2qZ2xaOlaMqaEi3WbcR6GgbxUNBLNXf35xcm4IabXduN6XhSRREACLWUkWM5vUVcN0VZhSOCrstGTTfjjVTPttE1zZPmvZqHev+qlD/m50BvZuSitWfyZZinpH5P5CzrGx9ZZdZGEo8Fart80Nf2s7MmzMFMO2T1iVzr60UEA+dBBAAg9jzK8gvkhK8OoUgQvoj6k3vhKcXFHerwALJ/N0YjSD+OudUz3N+DEAe4TKbbI153EKVNViCxxDqNJzEdtlVadyVEKPxoANbqAv8MsEDgo8DUFJJlAfv1WRYmS049oesTL2wS+PjCGZ4YXgHTlTZflHLetxArVUdTgsnMdt8Qfk3bKinkbZRIogDJEONC2Xr13g6JycotrmaevzhZ/1WSZl3B/X9rgV44vbbI8gChWaH6HCk0se4ipD2o9hiyYKUnY/rixh11vFMSXmZ6jJP6/JhoWBgESbZTOWWTE4kDtOl4/HGI7yPebBJWvsfEzPd78nxZDiMuY+5m+tf8ib9/iMsIU+0oEw0fyFgFajpy6beM+CYLhKdrvQs+qzRvZ4hWcy209idzNmNKbwyGLfE7+lKaCmMFKoDTE
 tjBf2VaB
 Nj5xeMQ57JKqfpYEIhEDNW4ojlianapZTDrGd5LftSMv+z+wYoW6jErsnoi4CoAwCmdOGTdh2kUq8YHQryBPgqveQTJE+OQDQorCF3N+Q+OHpwuY9X2YdGgQvqb5Ex3GGckXWdg8LxZKihlWFKj8HR4Okfw/U/Gv/uBJzPsV+UjU9OMtrOU3xFGxsVS8/i/2AWm0OHSaY3IDnD8tJoHTSYHcOju45Vs5JmkTxwzdLLMWPPPfl+hCgLjaING54lWvG+m2p+Zn1SGYjnuznTE+rkB0tzmM2rquTFylRmUKPyTkGpNzSG2aX3cvPePxwmuviIBGkI8yCwBI9DoTkkrWRqeiy+QN8kNrJVGscuXGtmvvU0y/Ox0omFpNgIN9fKLIuMjw/fAOR3gKP62RJjAvTxsMPkxLr81YEvlm6N9pcOQwySo6U45GjfxSlatjghmzcrVXsaILtO61cpmKlGD6I5rydQVBg0Jof0T7XatgHfLK9NMANROftUm9DAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 11:08=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 29 Jul 2025, at 5:18, Yafang Shao wrote:
>
> > Background
> > ----------
> >
> > Our production servers consistently configure THP to "never" due to
> > historical incidents caused by its behavior. Key issues include:
> > - Increased Memory Consumption
> >   THP significantly raises overall memory usage, reducing available mem=
ory
> >   for workloads.
> >
> > - Latency Spikes
> >   Random latency spikes occur due to frequent memory compaction trigger=
ed
> >   by THP.
> >
> > - Lack of Fine-Grained Control
> >   THP tuning is globally configured, making it unsuitable for container=
ized
> >   environments. When multiple workloads share a host, enabling THP with=
out
> >   per-workload control leads to unpredictable behavior.
> >
> > Due to these issues, administrators avoid switching to madvise or alway=
s
> > modes=E2=80=94unless per-workload THP control is implemented.
> >
> > To address this, we propose BPF-based THP policy for flexible adjustmen=
t.
> > Additionally, as David mentioned [0], this mechanism can also serve as =
a
>
> The link to [0] is missing. :)

I forgot to add it:
https://lwn.net/ml/all/9bc57721-5287-416c-aa30-46932d605f63@redhat.com/

>
> > policy prototyping tool (test policies via BPF before upstreaming them)=
.
> >
> > Proposed Solution
> > -----------------
> >
> > As suggested by David [0], we introduce a new BPF interface:
> >
> > /**
> >  * @get_suggested_order: Get the suggested highest THP order for alloca=
tion
> >  * @mm: mm_struct associated with the THP allocation
> >  * @tva_flags: TVA flags for current context
> >  *             %TVA_IN_PF: Set when in page fault context
> >  *             Other flags: Reserved for future use
> >  * @order: The highest order being considered for this THP allocation.
> >  *         %PUD_ORDER for PUD-mapped allocations
>
> There is no PUD THP yet and the highest THP order is PMD_ORDER. It is bet=
ter
> to remove the line above to avoid confusion.

Thanks for catching that. I=E2=80=99ll remove it.

>
> >  *         %PMD_ORDER for PMD-mapped allocations
> >  *         %PMD_ORDER - 1 for mTHP allocations
> >  *
> >  * Rerurn: Suggested highest THP order to use for allocation. The retur=
ned
> >  * order will never exceed the input @order value.
> >  */
> > int (*get_suggested_order)(struct mm_struct *mm, unsigned long tva_flag=
s, int order);
> >
> > This interface:
> > - Supports both use cases (per-workload tuning + policy prototyping).
> > - Can be extended with BPF helpers (e.g., for memory pressure awareness=
).
>
> IIRC, your initial RFC works at VMA level, but this patch targets mm leve=
l.
> Is mm sufficient for your use case?

Yes, mm is sufficient for our use cases.
We've already deployed a variant of this patchset in our production
environment, and it has been performing well under our workloads.

> Are you planning to extend the
> BFP interface to VMA in the future? Just curious.

Our use cases don=E2=80=99t currently require the VMA.
We can add it later if a clear need arises.

--
Regards

Yafang

