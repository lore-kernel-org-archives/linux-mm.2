Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 557D6CCD184
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 01:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 984AD8E00C0; Thu,  9 Oct 2025 21:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A598E0002; Thu,  9 Oct 2025 21:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86FC28E00C0; Thu,  9 Oct 2025 21:30:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7664B8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:30:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33BE6B61AE
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:30:39 +0000 (UTC)
X-FDA: 83980474998.27.DAA0769
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id D6A63160023
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:30:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OOxlpxTE;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760059837; a=rsa-sha256;
	cv=none;
	b=ZG8awA9Mfy6Xe7gI7/k4blmjCxwp347rm2WtDC+IubcWzCDvXa8P3WjK1tT3TDAxLiz+vN
	mtGtnxpvhpK033WbpDZWBNZ5vlD+tfX525u2Zk00VBKnDPj3gZTXW6Cs6m6vRAmdiX9PQ+
	f0ylwp+G5BhgicRWPlPIelWl32XNLyc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OOxlpxTE;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760059837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KBH+D1VY1k/iyJW0tFekBL3SOp7fQC1/zH8I/sKtZcw=;
	b=KnZMislqUUxC3xCkO5BAjyFUb31pGiK1Zk6+7XBaXZjgXNNDmRXmA6GXxYZn4GiKtmtlR1
	sZ/5yos0o+AUf+sAgP1cIGjrtIGIVLz4B1sdQ7eG7Uz2nyQYCrInGuuWGegJzlB3M+nzBj
	vyQSMzBL8dlXN8pWm3GmA38vXEHzuho=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4dcc9cebfdfso79431cf.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 18:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760059834; x=1760664634; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KBH+D1VY1k/iyJW0tFekBL3SOp7fQC1/zH8I/sKtZcw=;
        b=OOxlpxTEHOtGipAou+IX9pGh90v9cI9s3waY0F3+Vc4byWHkhOHIyHmaiWjKHwdEy6
         CuGOAHSvCIdN2JjCTdC+t67bZE82pephbgC2famkekNfFitxkNY624K2mbkvjJo53ftS
         0Pjnt6UjZxo0lfTBH9cUD/LcoIUbdFA1mHC05vgZFm1D1w05P07Yf1qSoOuvcKl008i9
         JpphORCAKHOV2IPjlra0yhLXITMlGjDIVIB02PdWaoNde0NjzEnfqfWDDoUmuq3U1QEZ
         2VCUXHKSi3MNvgBa57vWll0wZb9eRF7n4nn8Wn0HVgl6UCshtfo87PH82WrwKVmO0UZO
         cdcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760059834; x=1760664634;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KBH+D1VY1k/iyJW0tFekBL3SOp7fQC1/zH8I/sKtZcw=;
        b=KBa5cOtRhuIxartWhskgvOayOCVVkSb+FTPxSsl8L8dqNIrWJ0Wluvgh2Dqgc76VcE
         s1qkdoQNthfaR9xFzVKr476LSMMpzdclR30hveaa//cOIVvLabTZ2w2tJq/RgmtixetH
         RurrT0gSuvLzu1UsP7zrsJsmuWvVw6rqFQQT4QL5WzK8txtefdb+IfFEXgJsiWYMfb0C
         nmYvPQZdc+U9lPLM27CVQeC47k+Fb992erEgXDjfT7MPrpGByfXl+8ZdkaV8Z/A+JYaA
         lfV/W4KI5RjkeHPzpI6x88+IPnOJ6fJIJrMaGG070TdgcpLurD6jGXqtIBxj+909bZQz
         EvkA==
X-Forwarded-Encrypted: i=1; AJvYcCXNI+OJAhy9knzwj33sFrwznTg9ra+pv47wpWCHX/Ao/mSGtwV1kvrkb+PLx/MAJBfld1tjB72vDw==@kvack.org
X-Gm-Message-State: AOJu0YxKcv0VvvUyDTgCfS/N1MXpz0LNjaExDVSrYZVvm00k2mmuu/7C
	HIHBLUxBYErWsCT/5UrGZw1yaQYvkUIg7L05lF1ODhewNdZ9zvORJ9/8fpzyYI+/cDXSuw4E9pK
	gb9Fmw1LhECA3c/sO41JL4Tgscx4PzgE3MK+7gAjk
X-Gm-Gg: ASbGncuTGToBNiytV9boncNUK0AfxCtLjMzZ+CZZbyv1aUVzxab4Q2kBCB8+m6q8chX
	gSSmAQioxV2wkAJzBM4T7JkqfagvZCYtUrZH4vIoGS4ThNL7Ja+R1PVLcWlbKKIwckQyRog/ZZM
	mO+GjJ/rBIEpTo6t7PhyNaDHp613kEi2+rW7l36PMYBxfsRrE7azUUmzGMEV5kKm7hJp4YuA/Jc
	BKIxtrqGR2YQeH+lSSAcwW1/NxMMireryoPq0CegQMCJEysdm51b35EXiMo19CUWDV0
X-Google-Smtp-Source: AGHT+IGk8Rd2nbBjoorFgreXWL8YEF1zfX/maQIRfIsTxRQx/dTeXmM1jNyMGcBYzct5IpS5hc8RFccG69AI+l+vWmA=
X-Received: by 2002:ac8:578d:0:b0:4cf:dc5c:8c76 with SMTP id
 d75a77b69052e-4e6eac11cc2mr18767941cf.11.1760059833471; Thu, 09 Oct 2025
 18:30:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAJuCfpEWVEqsivd7oTvp4foEho_HaD1XNP8KTeKWzG_X2skfGQ@mail.gmail.com>
 <7944006e-8209-4074-85da-14f5545cd8b6@redhat.com> <Z6H4qCZDthSpI3nN@raptor>
 <CAJuCfpHZFAH4YvzekBgL2Np9UE95tw6ueevxapFzLXpf8UeoqA@mail.gmail.com>
 <CAJuCfpFyJBf1PX_d6NKDVSgg3EhXcbebVCYjMMpti6d5VnAJwg@mail.gmail.com>
 <CAJuCfpGghAELOpAxcUrAsGt86th-faAdOebw0SfYesS0+2cGmg@mail.gmail.com>
 <CAJuCfpEXBMBTPB6j3OS9uaKT_NbyqivnpA35hRYRiPikgyO6AQ@mail.gmail.com>
 <d3177175-86d6-437b-8084-9d3521161146@redhat.com> <CAJuCfpFBgYrOsAD5JbuBOMUVJo7H5e_qDxjxPsqHH1SSQum9Xg@mail.gmail.com>
 <ef8b8fe0-be77-429c-a474-be7b7f8be587@redhat.com>
In-Reply-To: <ef8b8fe0-be77-429c-a474-be7b7f8be587@redhat.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 9 Oct 2025 18:30:22 -0700
X-Gm-Features: AS18NWC5qkEWuBGJ_ImYbeCpG87MPdUv1DQcMHgCuj9XmGSqg6D3idAdjlZnJ_M
Message-ID: <CAJuCfpG+bXMDzfDRAZwhTX2CNu+yA12PVVV6sWcbWvJAsKvUww@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Guaranteed CMA
To: David Hildenbrand <david@redhat.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, lsf-pc@lists.linux-foundation.org, 
	SeongJae Park <sj@kernel.org>, Minchan Kim <minchan@kernel.org>, m.szyprowski@samsung.com, 
	aneesh.kumar@kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>, mina86@mina86.com, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <liam.howlett@oracle.com>, 
	Michal Hocko <mhocko@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 71bzsgqt1hn17q5nhd7g69fwocn9x4zq
X-Rspamd-Queue-Id: D6A63160023
X-Rspamd-Server: rspam09
X-HE-Tag: 1760059835-867834
X-HE-Meta: U2FsdGVkX1/4Ad/838xSnzet5pE/eqRhGou8sRYb63KLky12e+l1cJ6VmW36cQLDODebOxoU/RS3FTHqBx/AKVlHe8+PFM/0WMCM7UaWqyGG/kO67XTl55hByI29euDk39S7O8R3Li7W4sxENkE0HZM3Vvi//dHFCDrwALU83/e9DCaPE5tCOCThESgnc4zEZuabiUupC7ubLVJ65I8O/ZSQ0heS19ZUbr+NtpS+b5jbfUNTw8/uYcI+22FZdFKnbvyavTb72CLPSGW05Y8FKSGDQzwHeDUVjR5QzJ7ZTgfsF5ssIJ0zxnmPDw6rYiQ4QRXVVrRV9b/nMnBsTzffCFaJB9XJKyuG63F+irs9kQ83e3OBDiQma7Ac4ggdKkxIIiS14y1BBhVbHhhRpc3aWRl4sCRHzymC/dLRm4ivXUSkwURmhLrSdytWfkDKt8nGlqd+lqlWl9x/pljuZbLSqt3MRH58xhkyS1lE4STzdO3FPXvsH+6Rar7AfbCcyZILCLWaM23EyCsX20xbfEPs94D4gD1gs6B4hE2Z2TbfAxbq8RH2RcHbk9LMm1dOZhSU7iXKZIkB2V5LBIzqZn0uJ4ZWspaDBnr+hT69/EPBzgc/bZ+xBbYtdlyQiwn5ZS1GMZp+4n8LyoTPzvh+5+ObVJLXpIdgDDVb+Uxzt1MO+GpIOvnAO3VCPo14Czr1EE2b1/Yc5xRGepl8msRkNfoT2vhv7IN2He+tT+4H2UgQfcHiLHVJQ+LYTyt4DkFZPxGPOv+XS42FvU+n2waYGDVNSLFQYBqi/gnXTbJSADdO5uKEtEgRytMTQznyDMAC1XSoEPaCHkR/eNZgb7IwUBPmQmWwtLg7FNel38ZH2xgB2c9nFGuMQnoIqiRA62GUXRHQZI0FpCiW1m3ta1QOqoDibu7cN5pFGErsIl6oKteKNQWWT9oQXSzVgxyO0OBcRGXELwrOeQf4acOeI5yp13o
 3t16KpSU
 wMiY1KwwWEpgdLps37COe4ShEGNaU0EwaMVBUKmT5wGt4k+QX3Y5hOll0VOwo23yQhfccYv88qTkqtv3dVi53/Gh4dn7X0uxES+OPRHGBLJ62DD1s3JeJ3K1KWowskoZRLnJ6oTxOibxdYmlzQXKWJdmZyKE+YBKn46YHTQizh1CJbEsyurLTObptlWN1pPmQtE8aL9sqReN6nLi2thJLoMhNNuVrsyOeiKNYAtL4l7ee+54+w0JToVwZYePnYawDBc6bf/u0wbuBb4ph7P4aUmke8x7FE7BadnjbequZrUX71VRugkG4Hhf3tgPNjAqthnlKBXXkLYztjUc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 9:01=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 27.08.25 02:17, Suren Baghdasaryan wrote:
> > On Tue, Aug 26, 2025 at 1:58=E2=80=AFAM David Hildenbrand <david@redhat=
.com> wrote:
> >>
> >> On 23.08.25 00:14, Suren Baghdasaryan wrote:
> >>> On Wed, Apr 2, 2025 at 9:35=E2=80=AFAM Suren Baghdasaryan <surenb@goo=
gle.com> wrote:
> >>>>
> >>>> On Thu, Mar 20, 2025 at 11:06=E2=80=AFAM Suren Baghdasaryan <surenb@=
google.com> wrote:
> >>>>>
> >>>>> On Tue, Feb 4, 2025 at 8:33=E2=80=AFAM Suren Baghdasaryan <surenb@g=
oogle.com> wrote:
> >>>>>>
> >>>>>> On Tue, Feb 4, 2025 at 3:23=E2=80=AFAM Alexandru Elisei
> >>>>>> <alexandru.elisei@arm.com> wrote:
> >>>>>>>
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>> On Tue, Feb 04, 2025 at 09:18:20AM +0100, David Hildenbrand wrote=
:
> >>>>>>>> On 02.02.25 01:19, Suren Baghdasaryan wrote:
> >>>>>>>>> Hi,
> >>>>>>>>
> >>>>>>>> Hi,
> >>>>>>>>
> >>>>>>>>> I would like to discuss the Guaranteed Contiguous Memory Alloca=
tor
> >>>>>>>>> (GCMA) mechanism that is being used by many Android vendors as =
an
> >>>>>>>>> out-of-tree feature, collect input on its possible usefulness f=
or
> >>>>>>>>> others, feasibility to upstream and suggestions for possible be=
tter
> >>>>>>>>> alternatives.
> >>>>>>>>>
> >>>>>>>>> Problem statement: Some workloads/hardware require physically
> >>>>>>>>> contiguous memory and carving out reserved memory areas for suc=
h
> >>>>>>>>> allocations often lead to inefficient usage of those carveouts.=
 CMA
> >>>>>>>>> was designed to solve this inefficiency by allowing movable mem=
ory
> >>>>>>>>> allocations to use this reserved memory when it=E2=80=99s other=
wise unused.
> >>>>>>>>> When a contiguous memory allocation is requested, CMA finds the
> >>>>>>>>> requested contiguous area, possibly migrating some of the movab=
le
> >>>>>>>>> pages out of that area.
> >>>>>>>>> In latency-sensitive use cases, like face unlock on phones, we =
need to
> >>>>>>>>> allocate contiguous memory quickly and page migration in CMA ta=
kes
> >>>>>>>>> enough time to cause user-perceptible lag. Such allocations can=
 also
> >>>>>>>>> fail if page migration is not possible.
> >>>>>>>>>
> >>>>>>>>> GCMA (Guaranteed CMA) is a mechanism previously proposed in [1]=
 which
> >>>>>>>>> was not upstreamed but got adopted later by many Android vendor=
s as an
> >>>>>>>>> out-of-tree feature. It is similar to CMA but backing memory is
> >>>>>>>>> cleancache backend, containing only clean file-backed pages. Mo=
st
> >>>>>>>>> importantly, the kernel can=E2=80=99t take a reference to pages=
 from the
> >>>>>>>>> cleancache, therefore can=E2=80=99t prevent GCMA from quickly d=
ropping them
> >>>>>>>>> when required. This guarantees GCMA low allocation latency and
> >>>>>>>>> improves allocation success rate.
> >>>>>>>>>
> >>>>>>>>> We would like to standardize GCMA implementation and upstream i=
t since
> >>>>>>>>> many Android vendors are asking to include it as a generic feat=
ure.
> >>>>>>>>>
> >>>>>>>>> Note: removal of cleancache in 5.17 kernel due to no users (sor=
ry, we
> >>>>>>>>> didn=E2=80=99t know at the time about this use case) might comp=
licate
> >>>>>>>>> upstreaming.
> >>>>>>>>
> >>>>>>>> we discussed another possible user last year: using MTE tag stor=
age memory
> >>>>>>>> while the storage is not getting used to store MTE tags [1].
> >>>>>>>>
> >>>>>>>> As long as the "ordinary RAM" that maps to a given MTE tag stora=
ge area does
> >>>>>>>> not use MTE tagging, we can reuse the MTE tag storage ("almost o=
rdinary RAM,
> >>>>>>>> just that it doesn't support MTE itself") for different purposes=
.
> >>>>>>>>
> >>>>>>>> We need a guarantee that that memory can be freed up / migrated =
once the tag
> >>>>>>>> storage gets activated.
> >>>>>>>
> >>>>>>> If I remember correctly, one of the issues with the MTE project t=
hat might be
> >>>>>>> relevant to GCMA, was that userspace, once it gets a hold of a pa=
ge, it can pin
> >>>>>>> it for a very long time without specifying FOLL_LONGTERM.
> >>>>>>>
> >>>>>>> If I remember things correctly, there were two examples given for=
 this; there
> >>>>>>> might be more, or they might have been eliminated since then:
> >>>>>>>
> >>>>>>> * The page is used as a buffer for accesses to a file opened with
> >>>>>>>     O_DIRECT.
> >>>>>>>
> >>>>>>> * 'vmsplice() can pin pages forever and doesn't use FOLL_LONGTERM=
 yet' - that's
> >>>>>>>     a direct quote from David [1].
> >>>>>>>
> >>>>>>> Depending on your usecases, failing the allocation might be accep=
table, but for
> >>>>>>> MTE that wasn't the case.
> >>>>>>>
> >>>>>>> Hope some of this is useful.
> >>>>>>>
> >>>>>>> [1] https://lore.kernel.org/linux-arm-kernel/4e7a4054-092c-4e34-a=
e00-0105d7c9343c@redhat.com/
> >>>>>>
> >>>>>> Thanks for the references! I'll read through these discussions to =
see
> >>>>>> how much useful information for GCMA I can extract.
> >>>>>
> >>>>> I wanted to get an RFC code ahead of LSF/MM and just finished putti=
ng
> >>>>> it together. Sorry for the last minute posting. You can find it her=
e:
> >>>>> https://lore.kernel.org/all/20250320173931.1583800-1-surenb@google.=
com/
> >>>>
> >>>> Sorry about the delay. Attached are the slides from my GCMA
> >>>> presentation at the conference.
> >>>
> >>> Hi Folks,
> >>
> >> Hi,
> >>
> >>> As I'm getting close to finalizing the GCMA patchset, one question
> >>> keeps bugging me. How do we account the memory that is allocated from
> >>> GCMA... In case of CMA allocations, they are backed by the system
> >>> memory, so accounting is straightforward, allocations contribute to
> >>> RSS, counted towards memcg limits, etc. In case of GCMA, the backing
> >>> memory is reserved memory (a carveout) not directly accessible by the
> >>> rest of the system and not part of the total_memory. So, if a process
> >>> allocates a buffer from GCMA, should it be accounted as a normal
> >>> allocation from system memory or as something else entirely? Any
> >>> thoughts?
> >>
> >> You mean, an application allocates the memory and maps it into its pag=
e
> >> tables?
> >
> > Allocation will happen via cma_alloc() or a similar interface, so
> > applications would have to use some driver to allocate from GCMA. Once
> > allocated, an application can map that memory if the driver supports
> > mapping.
>
> Right, and that might happen either through a VM_PFNMAP or !VM_PFNMAP
> (ordinarily ref- and currently map-counted).
>
> In the insert_page() case we do an inc_mm_counter, which increases the RS=
S.
>
> That could happen with pages from carevouts (memblock allocations)
> already, but we don't run into that in general I assume.
>
> >
> >>
> >> Can that memory get reclaimed somehow?
> >
> > Hmm. I assume that once a driver allocates pages from GCMA it won't
> > put them into system-managed LRU or free them into buddy allocator for
> > kernel to use. If it does then at the time of cma_release() it can't
> > guarantee there are no more users for such pages.
> >
> >>
> >> How would we be mapping these pages into processes (VM_PFNMAP or
> >> "normal" mappings)?
> >
> > They would be normal mappings as the pages do have `struct page` but I
> > expect these pages to be managed by the driver that allocated them
> > rather than the core kernel itself.
> >
> > I was trying to design GCMA to be used as close to CMA as possible so
> > that we can use the same cma_alloc/cma_release API and reuse CMA's
> > page management code but the fact that CMA is backed by the system
> > memory and GCMA is backed by a carveout makes it a bit difficult.
>
> Makes sense. So I assume memcg does not apply here already -- memcg does
> not apply on the CMA layer IIRC.
>
> The RSS is a bit tricky. We would have to modify things like
> inc_mm_counter() to special-case on these things.
>
> But then, smaps output would still count these pages towards the rss/pss
> (e.g., mss->resident). So that needs care as well ...

In the end I decided to follow CMA as closely as possible, including
accounting. GCMA and CMA both use reserved area and the difference is
that CMA donates its memory to kernel to use for movable allocations
while GCMA donates it to the cleancache. But once that donation is
taken back by CMA/GCMA to satisfy cma_alloc() request, the memory
usage is pretty much the same and therefore accounting should probably
be the same. Anyway, that was the reasoning I eventually arrived at. I
posted the GCMA patchset at [1] and included this reasoning in the
cover letter. Happy to discuss this further in that patchset.
Thanks!

[1] https://lore.kernel.org/all/20251010011951.2136980-1-surenb@google.com/

>
> --
> Cheers
>
> David / dhildenb
>

