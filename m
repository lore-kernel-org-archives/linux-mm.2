Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93477CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFDBF8E001E; Fri, 10 Oct 2025 11:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAE2B8E0003; Fri, 10 Oct 2025 11:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC47E8E001E; Fri, 10 Oct 2025 11:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6DEE8E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:07:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 935781A0389
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:07:49 +0000 (UTC)
X-FDA: 83982534258.10.2FFBB5C
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id A94CB1C001E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:07:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="uh4GX3/0";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760108867; a=rsa-sha256;
	cv=none;
	b=0WYEymWkX2mZythFj81Q8jMmnOQDLNk3vqozBVWLRyvbSg4AL4chnXg14HU6dQOAGDI78W
	3LfsBjLGceWFf1muFhk1vwwr5eChk5VtDvRAlVx5w+ASBk/s3KEC+VPJOhDm2cz+lwMW7C
	72ZFuF06v5rxfBCR9A/Bigjg6Lrl73Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="uh4GX3/0";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760108867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oiMpGGyMpB+yTRL6ZjOzz4/6xJtqKoc6DzihxYXpWbA=;
	b=IiQowdoV62PMmebYVSgQzgpW6YDIlHTbRG/eP0hmjqhcEN411ckX9Yh4MXNYgbviu/mFjn
	tdqaPSBCaA0PLlWh7T5rMsAPVFKnhq8tbUtKxoxoEvwG0CMsuUmvp5tw1PBhGkS+6zgT56
	IWB3YeSstHESMSumULVecmeY4uPN0y8=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4de66881569so511821cf.0
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760108867; x=1760713667; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oiMpGGyMpB+yTRL6ZjOzz4/6xJtqKoc6DzihxYXpWbA=;
        b=uh4GX3/0VnmE7u7FIWkOIabKz9RN32nV/zOVlihBZ7D1zY4bsI5fWQ2QDk6L097Uvd
         CbAMIEKz11DuuVNNgttjHU9RiIssZf4RsZq0MIilDRCJAeNap4uurD7QgcN5su3UvjQ2
         ssWuJhP1texlMA6HoYXZ/3uFzoIQCRayPKn7m2Zfj4X0ptb6MAKD2RoOPsGl/fZyrS1e
         0frW52V1zGTh1Z6bYoWzUIqpLRxRs6cRVDnARhnjEgZAJveISrmPbxgbmrsbJs8fqx72
         yi0l/N9UupMUTS5Dp2KlOek8zdx4PWhjgKByd/362LTEW5YPO1GzWgNEo70UB9FYUQzg
         bbMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760108867; x=1760713667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oiMpGGyMpB+yTRL6ZjOzz4/6xJtqKoc6DzihxYXpWbA=;
        b=Z24AvT/a6gmiYAa9Fc7g9ck2yl4woiPIEiyf9cQEuNXtq40rrFcWy/+b9qcjWgEPeF
         wzNMCq2wpMTRZN6NgXf1cwfdPBt2ou9YxSHVd/zGCWjz6zsug+XdAInQda2IuAiFP5Iv
         aGYdLNrsx5+mk6s3FTfIpN7KJPcRZ+EfH25JrD6/JbPKLthgEjesq48QQhHDkwrPkb1J
         QJRPCjb+4tn5RUrSfiD5GqH6xtOIAyUbJI1oMyDvQ/XwJ50UEKu0NAC1jlC0+U+F+D+7
         UVGVi1K9oIbGenE1D3D88/YH9zZeKZKBi/BJ0ocaB4rkRM3tiiGc4212hED63z9xHgEW
         Qg5w==
X-Forwarded-Encrypted: i=1; AJvYcCUqSyiZ0agqY8vax764Nl3CMmpO5W5wriYNREI46unzAWj8BYV4cEVSkPGWYinqdrfP/bQ7evc65Q==@kvack.org
X-Gm-Message-State: AOJu0YzGqRSU4/aAiPlQpEdjh8i/vYmky311Air2YGPyoTs93NyDe2qj
	n5cet15LG/F16121cFSyYTVJZPoPGwC5zllSTZDGC6Hn+gDKkBJaS2wUygV+f7dY6XIbsEKJ6m0
	jGUbwDSwfkSQTDyu3ZUobzmQbHBMG0/cLPKrtIJNK
X-Gm-Gg: ASbGncuQf061Gy5H/P3ja1iecxx5YlmTNHXYGVzmCzJl+XuEFXS6HkrJxUw4wIVeG+z
	7Af0ar9qXBh7zOT7uYJn+lgmVU9NEcLggkX3t8jFP9uX9j6y55Tb/iakPMK2RN0Wrv12I/HEZch
	6ybWzzv5METub7doShuXzTi+kBKhdiMBzQUzW01ihXYMVCSBFkBZQFL6FBTDRKq9W+DJwu1BtX5
	Q8ljSkkOiwAFFL0oALwp/uNpUjJry4=
X-Google-Smtp-Source: AGHT+IEH4I6DL8o//DQd7yMeh9olaC2ZDdhERUmWdQqlcxWlPzgZuHs1bIp50rcgtVXXDBmAoLVuKmzyXvobHQtVt2A=
X-Received: by 2002:a05:622a:1113:b0:4b7:94d7:8b4c with SMTP id
 d75a77b69052e-4e6eaa78202mr24292801cf.0.1760108865916; Fri, 10 Oct 2025
 08:07:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAJuCfpEWVEqsivd7oTvp4foEho_HaD1XNP8KTeKWzG_X2skfGQ@mail.gmail.com>
 <7944006e-8209-4074-85da-14f5545cd8b6@redhat.com> <Z6H4qCZDthSpI3nN@raptor>
 <CAJuCfpHZFAH4YvzekBgL2Np9UE95tw6ueevxapFzLXpf8UeoqA@mail.gmail.com>
 <CAJuCfpFyJBf1PX_d6NKDVSgg3EhXcbebVCYjMMpti6d5VnAJwg@mail.gmail.com>
 <CAJuCfpGghAELOpAxcUrAsGt86th-faAdOebw0SfYesS0+2cGmg@mail.gmail.com>
 <CAJuCfpEXBMBTPB6j3OS9uaKT_NbyqivnpA35hRYRiPikgyO6AQ@mail.gmail.com>
 <d3177175-86d6-437b-8084-9d3521161146@redhat.com> <CAJuCfpFBgYrOsAD5JbuBOMUVJo7H5e_qDxjxPsqHH1SSQum9Xg@mail.gmail.com>
 <ef8b8fe0-be77-429c-a474-be7b7f8be587@redhat.com> <CAJuCfpG+bXMDzfDRAZwhTX2CNu+yA12PVVV6sWcbWvJAsKvUww@mail.gmail.com>
 <ddde064a-3297-4da1-bd2f-b3fbc2384e1f@redhat.com>
In-Reply-To: <ddde064a-3297-4da1-bd2f-b3fbc2384e1f@redhat.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 10 Oct 2025 08:07:34 -0700
X-Gm-Features: AS18NWBwtuICx2040RjQhMEltl4myUnQm9q936mbILa-j9EothRaLweMQxP3H9I
Message-ID: <CAJuCfpGHZFmSV9ZDXc_CxxACzq-TjVudnCT3thn_Ok6S4nm3eQ@mail.gmail.com>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A94CB1C001E
X-Stat-Signature: 7bp47zu9bd5r6168ebe7aqo1m3axuafh
X-HE-Tag: 1760108867-339942
X-HE-Meta: U2FsdGVkX1/r7wTQ1BFmll22Ap+pOSRTWL1/s2pX4QCKHCq8naUqyOAz3dSmw3WeNSHlTH1o4kFBCvL9n7phIoulwu4KllCoO2VheZgEMYaFg2NjJ/50/aCQo3Q0+fxS8EU3jgOA8kk6cYqkfQhj/hWtqo9nPckqdtxfKGwWAG3r/nXTOQM2Y6aCj092vjFlwWFXVpMox3YnywgxHwdKK/4AkGnBc9zdKl7yG6EpyF8/36zcjkG7/lJTWwdigfoaN5BrlTfNg5E7DLyI12BDYbPamJZT0WXuqsMPIw4pbXGXRCyFywesMbB+5tK6M4I6QESLeezgf4UKmKJfO7eRXB6BMvF9+GNY9D0s2AqIbHJ+g6/PDh5ag3nHSPVw+5gahdl5nREu0lZSlQU+WsliWyv+U4HmT/BPJmCaYKs0f9a9pGQBCWlyKhJ+XNppWwr01SZsqFXBsYoW0lIOOEeRB1PoYIxxLaAcTJplX0Ojo3hFJTUVsM6V2A0XzzAhf97vBc9ud6Hieb2bWmAn0x7fIzGUdS6n+qfBrn77okQQ319qwP/1i/luMl0HJV8rCichizSb5DrgPPtRJfjkPgW3Oj3jrucYTN10iLmZnjFTjfDAYSSuc5Hvwwna4//KKn0n4C2XaTX/jSkjKlySoy8dXZov2d01Lk+1wiLFXi9zV+VIkcuhQCQjpe8xylVe6y6oipEI3nwmejBP+30igCOsqvzLeMb/PuB1phlKxRUK18u55khrnmsx1bk9u5tOmu+804oa0TR6Wcbah/QI2TAgteH8PDTbHwr/3VYzhNN57FhX7NfczpPLGnvDswQ32H6N9ko+kvnMYPKVI2U7bJ2rTA7+60/FC0khgIqe7BHvjSPa4EF/sInoN07zkWs6ojBBQ+19zgdfwRygNAMji8ZEy9hhGL8SSqYaX3weCLOAEY37lUdY6T8BTXBVPSbe/mgD7XsyTYq9u26+JrTLyYm
 Jxj12sRD
 nDS2r7AaQgRRPZysAGSVIAOz8iFWUs8VW2QzR9N74dAZsjRyw2r3jW+EmXryV0yRjs3tWFi5oMVttRxKY10YgaU7W4ZfSlul4G2GMryav6hoMcAZmqNBrG1Ko4y3oJJ0BVq7yCisUXkf1ZJxZMetRkc/K9vfKr+UjhlA687PXyFnzivoADL7SuP1IBVK7zT0cokjgo1/oGTS+V5OMAO1/lXDHFHyMQQMvMWWRxJEyhFsHbud+RplBDQZi+oVgeGbCyz6C2trpCeYpY8t4BJQzjE5P4eMqjdFOHBoBq+8evoLpVuDNEh5CTg/Bf3ZpeReMK5MUHcGeSOS87Bs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 6:58=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 10.10.25 03:30, Suren Baghdasaryan wrote:
> > On Mon, Sep 1, 2025 at 9:01=E2=80=AFAM David Hildenbrand <david@redhat.=
com> wrote:
> >>
> >> On 27.08.25 02:17, Suren Baghdasaryan wrote:
> >>> On Tue, Aug 26, 2025 at 1:58=E2=80=AFAM David Hildenbrand <david@redh=
at.com> wrote:
> >>>>
> >>>> On 23.08.25 00:14, Suren Baghdasaryan wrote:
> >>>>> On Wed, Apr 2, 2025 at 9:35=E2=80=AFAM Suren Baghdasaryan <surenb@g=
oogle.com> wrote:
> >>>>>>
> >>>>>> On Thu, Mar 20, 2025 at 11:06=E2=80=AFAM Suren Baghdasaryan <suren=
b@google.com> wrote:
> >>>>>>>
> >>>>>>> On Tue, Feb 4, 2025 at 8:33=E2=80=AFAM Suren Baghdasaryan <surenb=
@google.com> wrote:
> >>>>>>>>
> >>>>>>>> On Tue, Feb 4, 2025 at 3:23=E2=80=AFAM Alexandru Elisei
> >>>>>>>> <alexandru.elisei@arm.com> wrote:
> >>>>>>>>>
> >>>>>>>>> Hi,
> >>>>>>>>>
> >>>>>>>>> On Tue, Feb 04, 2025 at 09:18:20AM +0100, David Hildenbrand wro=
te:
> >>>>>>>>>> On 02.02.25 01:19, Suren Baghdasaryan wrote:
> >>>>>>>>>>> Hi,
> >>>>>>>>>>
> >>>>>>>>>> Hi,
> >>>>>>>>>>
> >>>>>>>>>>> I would like to discuss the Guaranteed Contiguous Memory Allo=
cator
> >>>>>>>>>>> (GCMA) mechanism that is being used by many Android vendors a=
s an
> >>>>>>>>>>> out-of-tree feature, collect input on its possible usefulness=
 for
> >>>>>>>>>>> others, feasibility to upstream and suggestions for possible =
better
> >>>>>>>>>>> alternatives.
> >>>>>>>>>>>
> >>>>>>>>>>> Problem statement: Some workloads/hardware require physically
> >>>>>>>>>>> contiguous memory and carving out reserved memory areas for s=
uch
> >>>>>>>>>>> allocations often lead to inefficient usage of those carveout=
s. CMA
> >>>>>>>>>>> was designed to solve this inefficiency by allowing movable m=
emory
> >>>>>>>>>>> allocations to use this reserved memory when it=E2=80=99s oth=
erwise unused.
> >>>>>>>>>>> When a contiguous memory allocation is requested, CMA finds t=
he
> >>>>>>>>>>> requested contiguous area, possibly migrating some of the mov=
able
> >>>>>>>>>>> pages out of that area.
> >>>>>>>>>>> In latency-sensitive use cases, like face unlock on phones, w=
e need to
> >>>>>>>>>>> allocate contiguous memory quickly and page migration in CMA =
takes
> >>>>>>>>>>> enough time to cause user-perceptible lag. Such allocations c=
an also
> >>>>>>>>>>> fail if page migration is not possible.
> >>>>>>>>>>>
> >>>>>>>>>>> GCMA (Guaranteed CMA) is a mechanism previously proposed in [=
1] which
> >>>>>>>>>>> was not upstreamed but got adopted later by many Android vend=
ors as an
> >>>>>>>>>>> out-of-tree feature. It is similar to CMA but backing memory =
is
> >>>>>>>>>>> cleancache backend, containing only clean file-backed pages. =
Most
> >>>>>>>>>>> importantly, the kernel can=E2=80=99t take a reference to pag=
es from the
> >>>>>>>>>>> cleancache, therefore can=E2=80=99t prevent GCMA from quickly=
 dropping them
> >>>>>>>>>>> when required. This guarantees GCMA low allocation latency an=
d
> >>>>>>>>>>> improves allocation success rate.
> >>>>>>>>>>>
> >>>>>>>>>>> We would like to standardize GCMA implementation and upstream=
 it since
> >>>>>>>>>>> many Android vendors are asking to include it as a generic fe=
ature.
> >>>>>>>>>>>
> >>>>>>>>>>> Note: removal of cleancache in 5.17 kernel due to no users (s=
orry, we
> >>>>>>>>>>> didn=E2=80=99t know at the time about this use case) might co=
mplicate
> >>>>>>>>>>> upstreaming.
> >>>>>>>>>>
> >>>>>>>>>> we discussed another possible user last year: using MTE tag st=
orage memory
> >>>>>>>>>> while the storage is not getting used to store MTE tags [1].
> >>>>>>>>>>
> >>>>>>>>>> As long as the "ordinary RAM" that maps to a given MTE tag sto=
rage area does
> >>>>>>>>>> not use MTE tagging, we can reuse the MTE tag storage ("almost=
 ordinary RAM,
> >>>>>>>>>> just that it doesn't support MTE itself") for different purpos=
es.
> >>>>>>>>>>
> >>>>>>>>>> We need a guarantee that that memory can be freed up / migrate=
d once the tag
> >>>>>>>>>> storage gets activated.
> >>>>>>>>>
> >>>>>>>>> If I remember correctly, one of the issues with the MTE project=
 that might be
> >>>>>>>>> relevant to GCMA, was that userspace, once it gets a hold of a =
page, it can pin
> >>>>>>>>> it for a very long time without specifying FOLL_LONGTERM.
> >>>>>>>>>
> >>>>>>>>> If I remember things correctly, there were two examples given f=
or this; there
> >>>>>>>>> might be more, or they might have been eliminated since then:
> >>>>>>>>>
> >>>>>>>>> * The page is used as a buffer for accesses to a file opened wi=
th
> >>>>>>>>>      O_DIRECT.
> >>>>>>>>>
> >>>>>>>>> * 'vmsplice() can pin pages forever and doesn't use FOLL_LONGTE=
RM yet' - that's
> >>>>>>>>>      a direct quote from David [1].
> >>>>>>>>>
> >>>>>>>>> Depending on your usecases, failing the allocation might be acc=
eptable, but for
> >>>>>>>>> MTE that wasn't the case.
> >>>>>>>>>
> >>>>>>>>> Hope some of this is useful.
> >>>>>>>>>
> >>>>>>>>> [1] https://lore.kernel.org/linux-arm-kernel/4e7a4054-092c-4e34=
-ae00-0105d7c9343c@redhat.com/
> >>>>>>>>
> >>>>>>>> Thanks for the references! I'll read through these discussions t=
o see
> >>>>>>>> how much useful information for GCMA I can extract.
> >>>>>>>
> >>>>>>> I wanted to get an RFC code ahead of LSF/MM and just finished put=
ting
> >>>>>>> it together. Sorry for the last minute posting. You can find it h=
ere:
> >>>>>>> https://lore.kernel.org/all/20250320173931.1583800-1-surenb@googl=
e.com/
> >>>>>>
> >>>>>> Sorry about the delay. Attached are the slides from my GCMA
> >>>>>> presentation at the conference.
> >>>>>
> >>>>> Hi Folks,
> >>>>
> >>>> Hi,
> >>>>
> >>>>> As I'm getting close to finalizing the GCMA patchset, one question
> >>>>> keeps bugging me. How do we account the memory that is allocated fr=
om
> >>>>> GCMA... In case of CMA allocations, they are backed by the system
> >>>>> memory, so accounting is straightforward, allocations contribute to
> >>>>> RSS, counted towards memcg limits, etc. In case of GCMA, the backin=
g
> >>>>> memory is reserved memory (a carveout) not directly accessible by t=
he
> >>>>> rest of the system and not part of the total_memory. So, if a proce=
ss
> >>>>> allocates a buffer from GCMA, should it be accounted as a normal
> >>>>> allocation from system memory or as something else entirely? Any
> >>>>> thoughts?
> >>>>
> >>>> You mean, an application allocates the memory and maps it into its p=
age
> >>>> tables?
> >>>
> >>> Allocation will happen via cma_alloc() or a similar interface, so
> >>> applications would have to use some driver to allocate from GCMA. Onc=
e
> >>> allocated, an application can map that memory if the driver supports
> >>> mapping.
> >>
> >> Right, and that might happen either through a VM_PFNMAP or !VM_PFNMAP
> >> (ordinarily ref- and currently map-counted).
> >>
> >> In the insert_page() case we do an inc_mm_counter, which increases the=
 RSS.
> >>
> >> That could happen with pages from carevouts (memblock allocations)
> >> already, but we don't run into that in general I assume.
> >>
> >>>
> >>>>
> >>>> Can that memory get reclaimed somehow?
> >>>
> >>> Hmm. I assume that once a driver allocates pages from GCMA it won't
> >>> put them into system-managed LRU or free them into buddy allocator fo=
r
> >>> kernel to use. If it does then at the time of cma_release() it can't
> >>> guarantee there are no more users for such pages.
> >>>
> >>>>
> >>>> How would we be mapping these pages into processes (VM_PFNMAP or
> >>>> "normal" mappings)?
> >>>
> >>> They would be normal mappings as the pages do have `struct page` but =
I
> >>> expect these pages to be managed by the driver that allocated them
> >>> rather than the core kernel itself.
> >>>
> >>> I was trying to design GCMA to be used as close to CMA as possible so
> >>> that we can use the same cma_alloc/cma_release API and reuse CMA's
> >>> page management code but the fact that CMA is backed by the system
> >>> memory and GCMA is backed by a carveout makes it a bit difficult.
> >>
> >> Makes sense. So I assume memcg does not apply here already -- memcg do=
es
> >> not apply on the CMA layer IIRC.
> >>
> >> The RSS is a bit tricky. We would have to modify things like
> >> inc_mm_counter() to special-case on these things.
> >>
> >> But then, smaps output would still count these pages towards the rss/p=
ss
> >> (e.g., mss->resident). So that needs care as well ...
> >
> > In the end I decided to follow CMA as closely as possible, including
> > accounting. GCMA and CMA both use reserved area and the difference is
> > that CMA donates its memory to kernel to use for movable allocations
> > while GCMA donates it to the cleancache. But once that donation is
> > taken back by CMA/GCMA to satisfy cma_alloc() request, the memory
> > usage is pretty much the same and therefore accounting should probably
> > be the same. Anyway, that was the reasoning I eventually arrived at. I
> > posted the GCMA patchset at [1] and included this reasoning in the
> > cover letter. Happy to discuss this further in that patchset.
>
> Right, probably best to keep it simple. Will these GCMA pages be
> accounted towards MemTotal like CMA pages would?

I thought CMA pages are accounted towards CmaTotal and if that's what
you mean then yes, they are added to that metric in the patch [1], see
the change in gcma_register_area(). I'm not adding the GcmaTotal
metric because I think it's simpler to consider GCMA as just a flavor
of CMA, as both are used via the same API (cma_alloc/cma_release) and
serve the same purpose. The GCMA area can be distinguished from the
CMA area using the /sys/kernel/mm/cma/<area>/gcma attribute, but
otherwise, it should appear to users as yet another CMA area. Does
that make sense?

[1] https://lore.kernel.org/all/20251010011951.2136980-9-surenb@google.com/


>
> --
> Cheers
>
> David / dhildenb
>

