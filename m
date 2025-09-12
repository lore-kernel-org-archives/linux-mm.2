Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9979CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 07:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0F8900002; Fri, 12 Sep 2025 03:59:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB9078E0001; Fri, 12 Sep 2025 03:59:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCFB9900002; Fri, 12 Sep 2025 03:59:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB6E58E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:59:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29993BAC99
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:59:08 +0000 (UTC)
X-FDA: 83879847576.29.A4B8EB1
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 46FCA1C0011
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:59:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FF15jLCF;
	spf=pass (imf18.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757663946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYy2brfv/lGBhEHGS6G90beLGEnMaAiYcYf7uECp+D4=;
	b=zyDvN9xDRxQhCyEOZV4r5ZDVqZkX+iNq+X8ld3idraF65L+tGPccHhk0+Y0m56waDZ1/DD
	LrjTkCX6zFnj/jglua1ujMm06edVpwZyvzV2sZxTvFmVN5ZJZRbRInrTi3zcWam06bbTWq
	Mkgc1hqZ6/+UOw0lGb1ZZX68z8WgQi0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757663946; a=rsa-sha256;
	cv=none;
	b=C1jPSmhB7Un8m7AljbEG+2i2Gxet6/fen6ZqiClQie36tHsihwMbmoxvGJypcuvfoxY4cE
	wNyMX/Dj9dd+Ffq/1QUhoisJGreLFu/24PjLhjxAnQJCYXnw8rHJurY6nBx84XTq/fc9BJ
	S+212cnRzvpXhNBt40p7CqouHyiRYF8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FF15jLCF;
	spf=pass (imf18.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-729c1074875so11238666d6.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757663945; x=1758268745; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYy2brfv/lGBhEHGS6G90beLGEnMaAiYcYf7uECp+D4=;
        b=FF15jLCFCkw+1Cd0eP0TAcd7Y6QenRyuQ7ZuixACaxSFlE9QEezUhYO52+GkVct3RK
         No+KmkCIC7MOu4XZR1aCUSYi8rmJJtbYn/H5Yq8nf8MFHCppm44dohxREianE2MceiYL
         uHGFa7h1WnIlcqzPHSXNQvc4TqHXklZgARCPzNudqz6B4MbbaGc6ulR4JfI9d9dThDIp
         XeC0VAiPKLQwMcyGqnm0o8XBiQBWa7n0uLJj6RM3XOudGAtFn4jWeXxJMa8vij0663Op
         qdoPhDqo4RQtPRcwAdhflU13Y0A3na0YTZXOYh1Bm3aq9tVVAn3hRH1OTrDd2OcwKdc/
         GRug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757663945; x=1758268745;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qYy2brfv/lGBhEHGS6G90beLGEnMaAiYcYf7uECp+D4=;
        b=RJzlNEAh9QrVBMSEUmkeH8kr/AA94iJI2IncGYbZLHGwecmazui8veypzznwnmkX7o
         49SL1o1tn/ICpIlInukAAMBvVvEw6xjnNIurH8o0k6AivV/NSwx70yc95HrFh+cedkQ2
         qJq7LDitSA4dGylpiSD1bN8mwuIeL2mdR+mkZta0Ln4RBqqXjtNPCCPVqfiWK8Jx6d54
         XMUnmbwF0HXG7dFGcRoqzS1ge5c5ZZ8OeZ108NnUENZKEG1olDHD+18HB1TZ9e9NUBBZ
         it9wkoUlWx5MmAAATAGokRFfTtE2qx+FYocJcB+wNK8hn6CMK4SUv3/yaeEHrfBHxLp3
         rQBA==
X-Forwarded-Encrypted: i=1; AJvYcCWnVAiooVCSLV49ORFnFRPELOqaYUBuFgas5tHtGZLAEopSyZ7WyulAxSaPG8uiXrIeEaSIJgYOfg==@kvack.org
X-Gm-Message-State: AOJu0YyWiCdZcJc2EqTRU2YnY450EIa5rKLHeOZK7hoiidTkaTb326vt
	w7Ll43sOumI3VAEndOwobKZkUaMYvyPIcKEBgNWwKd6SIRGasGenr9gCAfBPjh7iVsIKeL/HJm+
	zvcL7olmiJeJF1uJyeDZH7RZ9MASmB5k=
X-Gm-Gg: ASbGnct1we0Va286aBOv+ZYVpajepMMCniI/Zw4OAco/t3IWV7caHcwpGL5vrl64TIg
	GqC+7rF3DtWrK+BmXGPZUoSgzU0MQVTLX1vVg9flu9NCruFAkcSRMaFlNclPbR6+E9KVaKprtIX
	zDLRqCho3KsTj36oGumOuzQgicXqjk6dX3yZ9pGEKi114mI3qTvJj4RIpqx06A64qxeisqyyacf
	VsPhQ+icilLJj22O9U2ioN0Bs1h2LQMgfZNGOW4
X-Google-Smtp-Source: AGHT+IEiaKF9pCkKWh4BbgOuXEKINdPyo/qenFs+0EOn/D/MSNe6hpdAb0zelQRVPMYqozXABSTq8lw3wGvRohll0zs=
X-Received: by 2002:ad4:4eeb:0:b0:71e:bbb8:9dba with SMTP id
 6a1803df08f44-767c5620288mr22748156d6.56.1757663944986; Fri, 12 Sep 2025
 00:59:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-3-laoar.shao@gmail.com>
 <CABzRoyZm32HT2fDpSy_PRDxeXZVJD35+9YqRpn9XWix8jG6w8g@mail.gmail.com>
 <3b1c6388-812f-4702-bd71-33a6373a381a@lucifer.local> <5a2a4b59-9368-4185-bd08-74324eebacb3@linux.dev>
 <4fba4e8a-a735-4cac-b003-39363583ad19@lucifer.local>
In-Reply-To: <4fba4e8a-a735-4cac-b003-39363583ad19@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 12 Sep 2025 15:58:28 +0800
X-Gm-Features: AS18NWBZ0o-Yi5EczDhcsVitmeJ-1xW5LexZHJbJIlEjf9ralk8ClSHWw7rPZas
Message-ID: <CALOAHbCzb=sfCzVvJze4Xth1v5YPxfdeNpWGkGALANciPae95A@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 02/10] mm: thp: add support for BPF based THP
 order selection
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, david@redhat.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 46FCA1C0011
X-Stat-Signature: 5b3jpab15z8zn6h3nhcspphwgdpkknio
X-Rspam-User: 
X-HE-Tag: 1757663946-504672
X-HE-Meta: U2FsdGVkX1+oTO8lfScdzBnIJKIZYPC7CHqnGQUlgcMyDBnSuoeqlnp98oI1mCwKevEwzYi3N5Iam06N0PhlfTdN6PWG67ngKAjDyJWYFRs1VDMRROfS4MRs2bTeDR6/668+dLyUBhpdH0N6F0/36YcybGzQaCSj7JasYYxiksE7vviT9ikN2zCK6gFd/D8hDmpkXb+W32O6alda0OPGgYRZHi8/sHjA+hTjukurRAHMmJM+UPPyg46YOwe1+Dn62/Qp71WkzmeExoMV6xQr7oapgRDuBpqAGnpVEyIHYHDnK1eIbid5wy6FwfgNY3L1IsHQb3JNx9vHS/XC3cilCzQhv5EcBiQG7Z259S7o0PMiopEFYh/sLxE+Au3ctNmz9PZvtGb7XujgFcu04y8yfInTtlc4r5cldULKDSULuYpMRO6TG0hCECPZ+XZoGgmuuk7sDYEPGAVzIF/4ztQPvVMFbNjCXbV1nOiTvvX+1xpZUje42cbqv6ONCFJgim0Rmb04J6QP/3aZFUUf6pDOiI++GXBK86A8+CGYdak9m653Pasw+8jLcPU9tTDaJnQenNaGhsFgcFWL60jEsVyudDExke+veFjPculgmqGBltQUPDTlgsRVW8wP453aMPyaPHoYowxkl23tGCDF2vy4ki7L2ApguIGfhrSCV/2C9CyoeltrPc6zepl+clY59/mUSpGnC/cyTABldScZF56wMWU+YRTVl/6Qmp91glsd9dJUg5JTxpAA16dEg54sPqv7lPdzmseyeZQASKvF+jhUwrLN1QciHNuAH6sqZTaeqSUg7Gjj/Bv+HF4v5aw3NIZgtkmzS+P4L4jCFlJU7G6QfyWzth9NeD23xV54ajbO/RCU2i/IKnNtlmJ2bCO9zDJIhag1w5sd83CfuWr0uvMUPjlj5cBLPhQJh1MFz10DUJOwSb95Bj58a/YOAOoWMMx5Pen74HkNwr0xN7sCWZ1
 dacjLEPL
 V/Bqxtvu4g4igkrmUiUaf6jOWLJ1XjdWbSk5pNHwL8SSZtKzoSJcGXGzNDXNpMSGAhpx2L9OLfx0SVDLJE5fOJ+WBwcUrrZHyQAr7yfXql4LPx1iqSiPgDUH/VEUFPrbihupBsML19u3T6ADi+qlmzRUadiJfrZdx2JbyWxleRDQoU6PJkPxolm6cD9IHjGfNhK5PYPxhVAS4XbVnBznCu7ijfkOxGHuSLJbV0Oaxnwuw2AnaizauYEmRLE5sjp123Vyh0jIoCTdznWxg2tQC+N7VfhvJygDav8P6yIy7vZw1CPYWswW6z2Rn/w/vrOezAk3aC3MPCIok/XF99F/4kI75a5eO7VzR2+SNMteZ2JDl3bVfe0LtOcdolko9m8ln4kegFTYdV/fn1sA9aQpaZqi136nXlRJncGsrY0L0A4F65X9UNgPhWERtWZ87xibnGnDVvGauZTwvyRw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 10:58=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Sep 11, 2025 at 10:42:26PM +0800, Lance Yang wrote:
> >
> >
> > On 2025/9/11 22:02, Lorenzo Stoakes wrote:
> > > On Wed, Sep 10, 2025 at 08:42:37PM +0800, Lance Yang wrote:
> > > > Hey Yafang,
> > > >
> > > > On Wed, Sep 10, 2025 at 10:53=E2=80=AFAM Yafang Shao <laoar.shao@gm=
ail.com> wrote:
> > > > >
> > > > > This patch introduces a new BPF struct_ops called bpf_thp_ops for=
 dynamic
> > > > > THP tuning. It includes a hook bpf_hook_thp_get_order(), allowing=
 BPF
> > > > > programs to influence THP order selection based on factors such a=
s:
> > > > > - Workload identity
> > > > >    For example, workloads running in specific containers or cgrou=
ps.
> > > > > - Allocation context
> > > > >    Whether the allocation occurs during a page fault, khugepaged,=
 swap or
> > > > >    other paths.
> > > > > - VMA's memory advice settings
> > > > >    MADV_HUGEPAGE or MADV_NOHUGEPAGE
> > > > > - Memory pressure
> > > > >    PSI system data or associated cgroup PSI metrics
> > > > >
> > > > > The kernel API of this new BPF hook is as follows,
> > > > >
> > > > > /**
> > > > >   * @thp_order_fn_t: Get the suggested THP orders from a BPF prog=
ram for allocation
> > > > >   * @vma: vm_area_struct associated with the THP allocation
> > > > >   * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HU=
GEPAGE is set
> > > > >   *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or =
BPF_THP_VM_NONE if
> > > > >   *            neither is set.
> > > > >   * @tva_type: TVA type for current @vma
> > > > >   * @orders: Bitmask of requested THP orders for this allocation
> > > > >   *          - PMD-mapped allocation if PMD_ORDER is set
> > > > >   *          - mTHP allocation otherwise
> > > > >   *
> > > > >   * Return: The suggested THP order from the BPF program for allo=
cation. It will
> > > > >   *         not exceed the highest requested order in @orders. Re=
turn -1 to
> > > > >   *         indicate that the original requested @orders should r=
emain unchanged.
> > > > >   */
> > > > > typedef int thp_order_fn_t(struct vm_area_struct *vma,
> > > > >                             enum bpf_thp_vma_type vma_type,
> > > > >                             enum tva_type tva_type,
> > > > >                             unsigned long orders);
> > > > >
> > > > > Only a single BPF program can be attached at any given time, thou=
gh it can
> > > > > be dynamically updated to adjust the policy. The implementation s=
upports
> > > > > anonymous THP, shmem THP, and mTHP, with future extensions planne=
d for
> > > > > file-backed THP.
> > > > >
> > > > > This functionality is only active when system-wide THP is configu=
red to
> > > > > madvise or always mode. It remains disabled in never mode. Additi=
onally,
> > > > > if THP is explicitly disabled for a specific task via prctl(), th=
is BPF
> > > > > functionality will also be unavailable for that task.
> > > > >
> > > > > This feature requires CONFIG_BPF_GET_THP_ORDER (marked EXPERIMENT=
AL) to be
> > > > > enabled. Note that this capability is currently unstable and may =
undergo
> > > > > significant changes=E2=80=94including potential removal=E2=80=94i=
n future kernel versions.
> > > > >
> > > > > Suggested-by: David Hildenbrand <david@redhat.com>
> > > > > Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > > > ---
> > > > [...]
> > > > > diff --git a/mm/huge_memory_bpf.c b/mm/huge_memory_bpf.c
> > > > > new file mode 100644
> > > > > index 000000000000..525ee22ab598
> > > > > --- /dev/null
> > > > > +++ b/mm/huge_memory_bpf.c
> > > > > @@ -0,0 +1,243 @@
> > > > > +// SPDX-License-Identifier: GPL-2.0
> > > > > +/*
> > > > > + * BPF-based THP policy management
> > > > > + *
> > > > > + * Author: Yafang Shao <laoar.shao@gmail.com>
> > > > > + */
> > > > > +
> > > > > +#include <linux/bpf.h>
> > > > > +#include <linux/btf.h>
> > > > > +#include <linux/huge_mm.h>
> > > > > +#include <linux/khugepaged.h>
> > > > > +
> > > > > +enum bpf_thp_vma_type {
> > > > > +       BPF_THP_VM_NONE =3D 0,
> > > > > +       BPF_THP_VM_HUGEPAGE,    /* VM_HUGEPAGE */
> > > > > +       BPF_THP_VM_NOHUGEPAGE,  /* VM_NOHUGEPAGE */
> > > > > +};
> > > > > +
> > > > > +/**
> > > > > + * @thp_order_fn_t: Get the suggested THP orders from a BPF prog=
ram for allocation
> > > > > + * @vma: vm_area_struct associated with the THP allocation
> > > > > + * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HU=
GEPAGE is set
> > > > > + *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or =
BPF_THP_VM_NONE if
> > > > > + *            neither is set.
> > > > > + * @tva_type: TVA type for current @vma
> > > > > + * @orders: Bitmask of requested THP orders for this allocation
> > > > > + *          - PMD-mapped allocation if PMD_ORDER is set
> > > > > + *          - mTHP allocation otherwise
> > > > > + *
> > > > > + * Return: The suggested THP order from the BPF program for allo=
cation. It will
> > > > > + *         not exceed the highest requested order in @orders. Re=
turn -1 to
> > > > > + *         indicate that the original requested @orders should r=
emain unchanged.
> > > >
> > > > A minor documentation nit: the comment says "Return -1 to indicate =
that the
> > > > original requested @orders should remain unchanged". It might be sl=
ightly
> > > > clearer to say "Return a negative value to fall back to the origina=
l
> > > > behavior". This would cover all error codes as well ;)
> > > >
> > > > > + */
> > > > > +typedef int thp_order_fn_t(struct vm_area_struct *vma,
> > > > > +                          enum bpf_thp_vma_type vma_type,
> > > > > +                          enum tva_type tva_type,
> > > > > +                          unsigned long orders);
> > > >
> > > > Sorry if I'm missing some context here since I haven't tracked the =
whole
> > > > series closely.
> > > >
> > > > Regarding the return value for thp_order_fn_t: right now it returns=
 a
> > > > single int order. I was thinking, what if we let it return an unsig=
ned
> > > > long bitmask of orders instead? This seems like it would be more fl=
exible
> > > > down the road, especially if we get more mTHP sizes to choose from.=
 It
> > > > would also make the API more consistent, as bpf_hook_thp_get_orders=
()
> > > > itself returns an unsigned long ;)
> > >
> > > I think that adds confusion - as in how an order might be chosen from
> > > those. Also we have _received_ a bitmap of available orders - and the=
 intent
> > > here is to select _which one we should use_.
> >
> > Yep. Makes sense to me ;)
>
> Thanks :)
>
> >
> > >
> > > And this is an experimental feature, behind a flag explicitly labelle=
d as
> > > experimental (and thus subject to change) so if we found we needed to=
 change
> > > things in the future we can.
> >
> > You're right, I didn't pay enough attention to the fact that this is
> > an experimental feature. So my suggestions were based on a lack of
> > context ...
>
> It's fine, don't worry :) these are sensible suggestions - it to me highl=
ights
> that we haven't been clear enough perhaps.
>
> >
> > >
> > > >
> > > > Also, for future extensions, it might be a good idea to add a reser=
ved
> > > > flags argument to the thp_order_fn_t signature.
> > >
> > > We don't need to do anything like this, as we are behind an experimen=
tal flag
> > > and in no way guarantee that this will be used this way going forward=
s.
> > > >
> > > > For example thp_order_fn_t(..., unsigned long flags).
> > > >
> > > > This would give us aforward-compatible way to add new semantics lat=
er
> > > > without breaking the ABI and needing a v2. We could just require it=
 to be
> > > > 0 for now.
> > >
> > > There is no ABI.
> > >
> > > I mean again to emphasise, this is an _experimental_ feature not to b=
e relied
> > > upon in production.
> > >
> > > >
> > > > Thanks for the great work!
> > > > Lance
> > >
> > > Perhaps we need to put a 'EXPERIMENTAL_' prefix on the config flag to=
o to really
> > > bring this home, as it's perhaps not all that clear :)
> >
> > No need for a 'EXPERIMENTAL_' prefix, it was just me missing
> > the background. Appreciate you clarifying this!
>
> Don't worry about it, but also it suggests that we probably need to be
> ultra-super clear to users in general. So I think an _EXPERIMENTAL suffix=
 is
> probably pretty valid here just to _hammer home_ that - hey - we might br=
eak
> you! :)

I will add it. Thanks for the reminder.

--=20
Regards
Yafang

