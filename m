Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1EF3CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 11:38:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A12928E000A; Thu, 25 Sep 2025 07:38:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C27B8E0001; Thu, 25 Sep 2025 07:38:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0D98E000A; Thu, 25 Sep 2025 07:38:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 725918E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:38:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 15D701A047D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:38:41 +0000 (UTC)
X-FDA: 83927575242.24.A9F9793
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3017D100002
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:38:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CPN3FhKQ;
	spf=pass (imf14.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758800319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxqroIT0bJ4gLlcnSWTcG5okvXIsZwteqLXkgpBpuRM=;
	b=ftB7ydCBTQk0URokHxyaz7RBB6YpLxnAuvG0rRpmIdAVns8lAYKPMU7TAYc/FDRfMnv4np
	uhk2HvxSL5cJB4o39jJeGCSKmMt9+GqZ5gREw7C9qK7U3BrJjd5iP5hWsWSBhz3WjkmHAO
	fcqOZcizBQbRfIAkGQ98/TRsBX8sfy0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758800319; a=rsa-sha256;
	cv=none;
	b=num/lrKE6MpuSk7A/NsfdSQ6RNHceKgA6nXC4tmfsST68BxY6L/EgswsQlvKDCLgeYcFd5
	QcC0drS73NIFF7C3gUy5fvmwsd07uy1GQIeryV7GQZbwrmiauqRRB4vwIeRusvHJRralBg
	ie7wwKozBHmvgd3AV+y8cTQJYdQmwI0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CPN3FhKQ;
	spf=pass (imf14.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-78393b4490cso6493016d6.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758800318; x=1759405118; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dxqroIT0bJ4gLlcnSWTcG5okvXIsZwteqLXkgpBpuRM=;
        b=CPN3FhKQ+82o1f+/zlz2tiTqrVHkVs2W1dufO7FbmbfMhzPZHw1j1JkfEBkMemD7my
         YrtEDxj0aqpojV7CYd9QU0UmGLLwfq6X7DcGK4Rmg9HpUFLAurgnfcgCMHMrWZUNnw//
         9P2I49l7QLRsk4gcO8RWcGtm3w3+J7OTAXX0c8UwS4JuFn+Q8K+h1TtNSYGtSYSN9GB2
         DeXoT0ThItIjUijdcr0nhEWKliO0F/LF8G91Z9yeMpClb8y4X0nIRavJiRByAgPR1yuh
         3llbX9fJO/SqkEZ3WT8mtnPpeQ5dmKfLcdoD+U7mFUOwKYuu+p0W2/Q1sqFig0lEoVFL
         v4pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758800318; x=1759405118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dxqroIT0bJ4gLlcnSWTcG5okvXIsZwteqLXkgpBpuRM=;
        b=l9ebLoW1FN8MpOLkSMES0YN/5vK93/+akrSAUwM4gDsbJT9P8atTpj7KGwW100Nd8+
         Ul0fCx6syTcHmpuQncWJzRcTet7kgrSJlyfhayAmdUEwnfapYTfIVGnhDhhVQ8Sbb7RI
         bbaUyvRrsUW5KnGdj3S9mrOwUQpuzSllfGJLJJplFloNXjbto1+nmN4+lh0noWIFTziH
         bLoj/RTenze9xvXyDzl891WuYEoAXWqVQtcmfcLYjOAbS6mMQi616dcY0PgnlePsnEd2
         PuEiApEfCjagEmXsNSj0x0Uzcd/6lgTuAyivZPq84DXxp8NX+2p+6MiR3KVFnR3ik4Pz
         ciww==
X-Forwarded-Encrypted: i=1; AJvYcCU44emqTW70xbanFHpZM62MSOxfIS4FHkrfAG21MsbVM3IJj6a9I0I26PLHo+HtAvrT5HlSWeVAdw==@kvack.org
X-Gm-Message-State: AOJu0Ywvit+XnBOXjSdgv3PxThfloMMNdvZUTB8h5LtCQt115tO2xB0v
	buJTbMrXleVI5ndJkI0pG14nKc3+4NNsJSE6i8IPIWAhlDq1rj3Ju3NkKvzkAFX6S95UjOqLSyY
	fg5NKh06XbfJryO+huW2jCeSmGsagQZs=
X-Gm-Gg: ASbGncvpssGT/NHZN/rAE0vy5V1+s5DLmD3+bcZkKkc0QlEbN6X7Uat0rOoK4UTVxlw
	+qk6ilqQUnC3wNwMy9gwJlrTeyYlNzKOMi14Cy/yrhDBzD0kJ6ZMqZ4tTjKZHDuZBlAg8/TL2sg
	0Uz8uCa/SWEj380qQWtawnVB4xPJeJjpK1SDxfsdudjlJ5QhF7WLEteakGdXRWztbh4ceVt46XU
	DwQJIkVMCAeNBwZpj0vT5kgqo+FlHUWTugjbspo
X-Google-Smtp-Source: AGHT+IEjqFiMZ84yVMmL8aqHzutnqyfPVAvHhHZi1w2Zyv0MzO2zv3PyHq0KNksiUWqn8ZVtvz5/v5ORndsZtS+GvZ0=
X-Received: by 2002:ad4:5742:0:b0:7e4:ee39:738 with SMTP id
 6a1803df08f44-7fc45d03d94mr42335986d6.67.1758800317940; Thu, 25 Sep 2025
 04:38:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-3-laoar.shao@gmail.com>
 <CABzRoyaFv4ciJwcdU=1qQNvSWE_PPQonn7ehE7Zz_PHNHfN4gA@mail.gmail.com>
In-Reply-To: <CABzRoyaFv4ciJwcdU=1qQNvSWE_PPQonn7ehE7Zz_PHNHfN4gA@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 25 Sep 2025 19:38:01 +0800
X-Gm-Features: AS18NWAPI6UtnnMnTVeKsaXnI6UeT7SK4r6__DsbeZCo6L2UhwRp_pLiTM-6Da0
Message-ID: <CALOAHbA=On41GnxAQOh__5ff20NSCO3bzG6trOd=+tymeJndbg@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 02/10] mm: thp: add support for BPF based THP
 order selection
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3aeygnp4qoyu73cde8x669oxxgjdj1g3
X-Rspamd-Queue-Id: 3017D100002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758800318-476011
X-HE-Meta: U2FsdGVkX1+6ObDkYTj0H174aSN7+2cDVDAyHsZrY8zJIDJyZG7SfawejHGK/3E+il3T3YZ5uUvl38scmVC2wER4dCcwaS5M8dtw/AcuMJk0uLCeLZq2fnNbfrlp/mXgbDK+tbpnhn7SnUmdIREKbFpwmCpYiOV/eipSKGn7CCAzEQUaDE0JbsXg8uBQdRcyhbOaNuRKgOf1x5MBRyodUW2HXfl6SoNdPUt04FUBWNNBFDsupSKcfr33g3TgANZTCCLEL0+aO8qqQeaR+Q7u7zaKIlFCxHrHFr892xsXxJiWYw12i/n25wpXnDpJdOET+6e6vl98tPJ3FEjcDFQAyOKlte+QnRdjQghSDQNnTSKx9jp6D8rH3eQiwwfifHzUFECuJ73qhHk5ks6iDpMCANtb59jWGNCzH5im2/fj4UDqth/MKzcUj4G3ad1Y3XBXZ7nP25oq0G38V6pc4O9Tc3VQsoa4nzn4tu7K0b9JCq0ep7ekrfflJkJhHBentQWdByfE5v8p1EQ1o8IDqW0JvWDalkeXME6VmeZI6Ps2jXbFnZuvH49Vc4YVEWrrsw6HJUd3/cZ11ZBaqU7SpiiDpGbfwsbGrVusvqLZZLwqEEFa53KiSQ6x2FNoLHJQj619JKJ3R4obM//J7e5aoNh7X5F2w7dJHtGpMUjU2vGyxjKE+h/MOwpUrAKZB7t0U4TByC2mV/wIj092+9wVteIz1kAi2y/ukDzW7Pq6KDzVdTI0qb2SZhUhOfjZtYMwmsregx/wAdKplzfw8+CXctvL/sU2pC7NAogF0tdB0vbpLxrhlovuJerBrI7x6KGZhC3TuBNONlbCtvai3VbvobqQgPeH+NMJnTIeuHn5u8PrRtTodafXlxwmYaFfAJxZmige07gz5LXolop9XvLQgMVQ8HpfORBMirgYC6DqayA6WJxF5WxMpaR/+FL4XLNLilUbUXgdDKemBmaMWyy0vDv
 ACGqnR+5
 PZ/Od0dY9CiQjohA4gIGrj8mnzLX38w0uUyeYI5hKyji25C/SFXUTLs/8NUITQxAR2/xzaQMKJ82pl9XBEsk/DoAFcixML8PXQy+kTeuAgF1odtMU1K7kMNyAny3yFA7TpsZ98mTeZAUXetH6bbGmLwORr3KEa2itcBWaObDI/aISso+/OsKYde7TOaVtvidXN96ZgMGHSIgBGImWNrfj30Erz2dsii1zqCp7qYnib3jDKKhc1eGJ6A1bL1x+MDfWxC69aDhVl+jCSPvd2wAdioiYlVPXcM+iQ3FLH6teZFsEs7jT8Pc4HmSN7AK7mFxMxDrRDbDjA3rdzPbXGuyPMVt2tFhOw15QnWNQGqQ82LJr75AcwkBKF5+YdTk0JXOZL+nOXja1CfN0zXbW3Kb+5cYOqgDpnc4R7qECs28RA1IOdCWsqw2qWt2cXBBlheAoy2TP0NLeqfRDoBk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 6:06=E2=80=AFPM Lance Yang <lance.yang@linux.dev> w=
rote:
>
> On Wed, Sep 10, 2025 at 10:53=E2=80=AFAM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> >
> > This patch introduces a new BPF struct_ops called bpf_thp_ops for dynam=
ic
> > THP tuning. It includes a hook bpf_hook_thp_get_order(), allowing BPF
> > programs to influence THP order selection based on factors such as:
> > - Workload identity
> >   For example, workloads running in specific containers or cgroups.
> > - Allocation context
> >   Whether the allocation occurs during a page fault, khugepaged, swap o=
r
> >   other paths.
> > - VMA's memory advice settings
> >   MADV_HUGEPAGE or MADV_NOHUGEPAGE
> > - Memory pressure
> >   PSI system data or associated cgroup PSI metrics
> >
> > The kernel API of this new BPF hook is as follows,
> >
> > /**
> >  * @thp_order_fn_t: Get the suggested THP orders from a BPF program for=
 allocation
> >  * @vma: vm_area_struct associated with the THP allocation
> >  * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPAGE =
is set
> >  *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_THP=
_VM_NONE if
> >  *            neither is set.
> >  * @tva_type: TVA type for current @vma
> >  * @orders: Bitmask of requested THP orders for this allocation
> >  *          - PMD-mapped allocation if PMD_ORDER is set
> >  *          - mTHP allocation otherwise
> >  *
> >  * Return: The suggested THP order from the BPF program for allocation.=
 It will
> >  *         not exceed the highest requested order in @orders. Return -1=
 to
> >  *         indicate that the original requested @orders should remain u=
nchanged.
> >  */
> > typedef int thp_order_fn_t(struct vm_area_struct *vma,
> >                            enum bpf_thp_vma_type vma_type,
> >                            enum tva_type tva_type,
> >                            unsigned long orders);
> >
> > Only a single BPF program can be attached at any given time, though it =
can
> > be dynamically updated to adjust the policy. The implementation support=
s
> > anonymous THP, shmem THP, and mTHP, with future extensions planned for
> > file-backed THP.
> >
> > This functionality is only active when system-wide THP is configured to
> > madvise or always mode. It remains disabled in never mode. Additionally=
,
> > if THP is explicitly disabled for a specific task via prctl(), this BPF
> > functionality will also be unavailable for that task.
> >
> > This feature requires CONFIG_BPF_GET_THP_ORDER (marked EXPERIMENTAL) to=
 be
> > enabled. Note that this capability is currently unstable and may underg=
o
> > significant changes=E2=80=94including potential removal=E2=80=94in futu=
re kernel versions.
> >
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>
> I've tested this patch on my machine, and it works as expected. Using BPF
> hooks to control THP is a great step forward!
>
> Tested-by: Lance Yang <lance.yang@linux.dev>

Thanks for your test. I will post a new version ASAP.

>
> This work also inspires some ideas for another useful hook for THP that I
> might propose in the future, once this series is settled and merged ;)

Excited to see it!

--=20
Regards
Yafang

