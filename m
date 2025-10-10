Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABD25CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F33DC8E003E; Fri, 10 Oct 2025 11:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0BBC8E002C; Fri, 10 Oct 2025 11:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E217D8E003E; Fri, 10 Oct 2025 11:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEE448E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:47:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3304B8B3E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:47:37 +0000 (UTC)
X-FDA: 83982634554.06.2EC1D0A
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id C086DC0006
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:47:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WLGKSLkI;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.166.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nn21ru+6IYq3SaeNjiz8pwX5xTmh6Plv4aw/vIBloTA=;
	b=bsd6rqtZXN7zQ4IHIbvlEvPW8tpGPbrkyWGEWWDITPCN4e5rmqSnH+aPacLfGhdGRLaKjy
	hB02E+4+MfJV+b5jGj3Dn7rRICGzlCmTOoYlznMcNyPj1NHQymfNZoMhhTeWePHbmsLPbA
	2zbZfRvrOWw9GvjBt7rXylAh1LGq6D0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WLGKSLkI;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.166.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111255; a=rsa-sha256;
	cv=none;
	b=372bbRypuvDW13JKLF1yyqCF4Ptzcax2irQXuqqi+HR6TKuO+H/T/ZncjQcjGuQPKX0KVr
	75UmcwhRxWP8Y+rxpl4LZjYaMBrwRMNOh7D1gCYNVJ8DhZMkaQOvS+FmXA0BS4yT9Zg/AS
	1+nWJvJeczVF08Fc0Eab7HSVOXlhjkA=
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-42d7d0c58f9so161185ab.1
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760111255; x=1760716055; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nn21ru+6IYq3SaeNjiz8pwX5xTmh6Plv4aw/vIBloTA=;
        b=WLGKSLkIefJAsV3lSTyYjZvU0NBFszUAcAQxGaR4aFLSeQH47UklCFxCGFFDhIOQqS
         YM7EswCqBKgSeZPa/fqNkhrsGfP1CfU+tUgtJ/Xal0BcNYrfc5meu4o4VbQLul2eClyP
         UYDtWiKSRAnk13TNCQUd0gz9olsliZD+UYmrF2yrHZzBEp82VR7vW/CTUybx5odDBTfT
         XDZJFP3bcFsOkQ1ytmbj0QXho7D22ySwUkcT8rKmLVrfySyWlX2Ma0cJhNSwOgAyFYJe
         7bH1ait26BfDYK1IHmPpqpM5N94k+vLkzgKSvQzfj29or9x6wiej6yH553RPcMqumffA
         87Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760111255; x=1760716055;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nn21ru+6IYq3SaeNjiz8pwX5xTmh6Plv4aw/vIBloTA=;
        b=ijrBSJS7t0TCqRw6pNLiyOvtJLjJx6u0jKcQmay4WdWTmAiF2eaqlmCeyApz+2+WLa
         0004WSDIlsfXfgoSXTieJLKyxrqCV5xOn4Czz3uDjhSwMU+LqjU2qXicxmk1QycFEno6
         +/4DRVy9w1bUHQBlueiwWw4iZ4Ly+Q3vEgzmoEQYAIQGdlRPDkUpzHYOLidRoF+tTjs6
         I9LBITOHaGmI9VaMBADruceEvwn2LH8zNiKH1j5Bx1yMJGh9uXURn+uQMXLWiXn4//7t
         6p4erGbzoi8leLi5cJYIxtsmrXrySitaLvyX+uvv8kKE96aIwhmbty0gefbdyU3/h3Km
         nydw==
X-Forwarded-Encrypted: i=1; AJvYcCX+DPp3inZ59Qfm7l4BIAYeemwkBL4wU0t29RuWyeCKQO0wu14aMvW5dgA4xxGGeS23bPOK1jcq+Q==@kvack.org
X-Gm-Message-State: AOJu0YxGRr+un8E1H5amsDGQOFvXVMNDr7RUQ2CQdi6F+w09nH6GQGzO
	c578TJ8rtitx5GfqM/LlTtz6aRv2ZSBFA1tYnY3A4gAUvLW3i2Sx6y2tr2HCtrVphilpr11NGDW
	ExB6IQFVU9zcM7ejmsFayaVRaxTDDQCmqwsrnyw6S
X-Gm-Gg: ASbGncvvU34LjKuyPk9nJD0O2NRl7/TS7yHVqVzPwKjhW1cCyLFMcIfIdejVLDMtZKi
	xpD7F4Tf1LtXoU54HKg/5lW2T4iX/QxJbUW6fEFI1YXUdB3KAvWw/zJ9YA/jBGX4pJ9mHKqrX42
	LxKCk1V/Psy+D4OJH/7QkxFhiDbufk5KZxf9+/hafLT34Ol6cCeAbEpKh0L3co3ww0kBEsPaC0r
	Q1uMmLNBcVlSd0GOoR+PlcbvxaXXao=
X-Google-Smtp-Source: AGHT+IFhNvdXLUfN8AwQth4W32cKw2Fo5qWzAO7pSq4jYjYRTt95cZW3Ga7cw49IWvnxZ6mp6u76mcRdcsC0AlxmAwI=
X-Received: by 2002:ac8:5f13:0:b0:4e4:d480:ef3a with SMTP id
 d75a77b69052e-4e6eabefc7bmr22994041cf.13.1760111254053; Fri, 10 Oct 2025
 08:47:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAJuCfpEWVEqsivd7oTvp4foEho_HaD1XNP8KTeKWzG_X2skfGQ@mail.gmail.com>
 <7944006e-8209-4074-85da-14f5545cd8b6@redhat.com> <Z6H4qCZDthSpI3nN@raptor>
 <CAJuCfpHZFAH4YvzekBgL2Np9UE95tw6ueevxapFzLXpf8UeoqA@mail.gmail.com>
 <CAJuCfpFyJBf1PX_d6NKDVSgg3EhXcbebVCYjMMpti6d5VnAJwg@mail.gmail.com>
 <CAJuCfpGghAELOpAxcUrAsGt86th-faAdOebw0SfYesS0+2cGmg@mail.gmail.com>
 <CAJuCfpEXBMBTPB6j3OS9uaKT_NbyqivnpA35hRYRiPikgyO6AQ@mail.gmail.com>
 <d3177175-86d6-437b-8084-9d3521161146@redhat.com> <CAJuCfpFBgYrOsAD5JbuBOMUVJo7H5e_qDxjxPsqHH1SSQum9Xg@mail.gmail.com>
 <ef8b8fe0-be77-429c-a474-be7b7f8be587@redhat.com> <CAJuCfpG+bXMDzfDRAZwhTX2CNu+yA12PVVV6sWcbWvJAsKvUww@mail.gmail.com>
 <ddde064a-3297-4da1-bd2f-b3fbc2384e1f@redhat.com> <CAJuCfpGHZFmSV9ZDXc_CxxACzq-TjVudnCT3thn_Ok6S4nm3eQ@mail.gmail.com>
 <5c3fc24c-dfbf-4d59-bda0-8726d2eaa78a@redhat.com>
In-Reply-To: <5c3fc24c-dfbf-4d59-bda0-8726d2eaa78a@redhat.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 10 Oct 2025 08:47:22 -0700
X-Gm-Features: AS18NWDso4Sq1vuiMj1fngD3BtbeVxkDxq_7HZihr-hQ1MkXkPjbj8exZFRdfkg
Message-ID: <CAJuCfpGLsN32Tq6BBzgbxBSBu7Ogxy5d+3-TE4+jCKgGfaHLvA@mail.gmail.com>
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
X-Stat-Signature: ymuh8qizn7w8tz5bgqguymr5d3f5r3fo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C086DC0006
X-HE-Tag: 1760111255-908903
X-HE-Meta: U2FsdGVkX1/0v2ciBCVTMx6tn6q4fo31yWCTdX8hk7XhJTqnZHTm7ppPXgHuyr5IWGXh9CCQRguRmV7WsT0ycrGX97kYw1vqPvr4LaXK8kOnhrtTSUNtTmmNl626vrJ6lHi7sTcCffsMh2vATKS1Xe8j2+e9I2woC+mwUe1JJ7l6tpNWY3wI7W9rxDkhV/OhlkJPEFXF0iBhwTpdclFs0E3tce9zCQgkJKQFWOhrvMswJGFXghmRD4mh7h+6uLDSiid7+LY+OAg7Qq65ZrYEcsa/m1fn/VMG5j//rkMFxq5p02vpE5eGs+CjGGsIom7XyVQ2e5PXss8p0TgwsDgZ9otacl7bZ8tyMOELWtJFq0YeN3EXvYdEF87WziZ8c0pPIq9TSWq4+2FmVMnHVLPR1SurCpk07f8z/S+EFAw828E/9ht+MHOgcmCQr6oo9+OOJwn+zIdVdswZVF/s1ZLX8fKOLbvE//v9NT6xGIjxKUn7L0PhDoDaWT2dtUlfruO9FKuYSfS3vZuOidSxX09AyIBHJPHlNuqhts0Tv/pUDveUcEtmER5hn5+sZAhGLQuCW3FqjE3wQQOU4G9oMhpLRCFzBrlwLvn3nLl/OdhrHCQxAlaLkI7snHmhEeFFv+0noPbHaaDdMbSY/K6ywcqzXlbQIs+LySvO1AlN/ZbwMGAHH9m8yAgk4PmjMBfvj+6cCYSA5MbwqB7wZhU21cgfpXR+28I90u1RQJRxp9oh3zSRGJsbUr5tSm3qu5RrZlGnwQ2znQe6ow4fHs4sohwigJgN256WuMiHbJH4yMktu8sUopPNWXowCki0o51+SdcHkhn8cYIl6dEsK6tazHoCM5UiL4/xfdw3Jw3jgm7toRHUnp+/ZUqWMW0fXk6QuOh0Uu+CLnMtZxcL3VShuAwt5OeNwFSkanh3ZfYNkG8d+vv7o2EXypXGyhC+wmK/P79piEhQF3K9si8SHWIhM95
 ywRSLNnt
 sHBmTUQxNphbewNbypu37tniOeVrwCJleEjRfuaj2+O++7xWFjC/WWng17MeQzRdwzGW3Cx8FLLVyq9/c5n2xgUw6D3x2k1jbY813KEfI/y/3TkgfwxwNxSm98uWL9ZrySea1Br987pxKU5wci421IEz4upfCnwPQk0DLIx7oH8Bu3hJeUeTJ6ACI8sBTm3wUlge+l5HyziwciBEKQwqAAwKA1jvSBnngLjROoBB0925WKKtJtXUkdN1akpiSqB/r9ijqKGXIpdr4Wm3Eu57F5H8KMmJtd4wfgAVZ93XDz6UAT0+XrpYBjltpIvoeC4Rc1anBcuP1ObiJz4w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 8:37=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 10.10.25 17:07, Suren Baghdasaryan wrote:
> > On Fri, Oct 10, 2025 at 6:58=E2=80=AFAM David Hildenbrand <david@redhat=
.com> wrote:
> >>
> >> On 10.10.25 03:30, Suren Baghdasaryan wrote:
> >>> On Mon, Sep 1, 2025 at 9:01=E2=80=AFAM David Hildenbrand <david@redha=
t.com> wrote:
> >>>>
> >>>> On 27.08.25 02:17, Suren Baghdasaryan wrote:
> >>>>> On Tue, Aug 26, 2025 at 1:58=E2=80=AFAM David Hildenbrand <david@re=
dhat.com> wrote:
> >>>>>>
> >>>>>> On 23.08.25 00:14, Suren Baghdasaryan wrote:
> >>>>>>> On Wed, Apr 2, 2025 at 9:35=E2=80=AFAM Suren Baghdasaryan <surenb=
@google.com> wrote:
> >>>>>>>>
> >>>>>>>> On Thu, Mar 20, 2025 at 11:06=E2=80=AFAM Suren Baghdasaryan <sur=
enb@google.com> wrote:
> >>>>>>>>>
> >>>>>>>>> On Tue, Feb 4, 2025 at 8:33=E2=80=AFAM Suren Baghdasaryan <sure=
nb@google.com> wrote:
> >>>>>>>>>>
> >>>>>>>>>> On Tue, Feb 4, 2025 at 3:23=E2=80=AFAM Alexandru Elisei
> >>>>>>>>>> <alexandru.elisei@arm.com> wrote:
> >>>>>>>>>>>
> >>>>>>>>>>> Hi,
> >>>>>>>>>>>
> >>>>>>>>>>> On Tue, Feb 04, 2025 at 09:18:20AM +0100, David Hildenbrand w=
rote:
> >>>>>>>>>>>> On 02.02.25 01:19, Suren Baghdasaryan wrote:
> >>>>>>>>>>>>> Hi,
> >>>>>>>>>>>>
> >>>>>>>>>>>> Hi,
> >>>>>>>>>>>>
> >>>>>>>>>>>>> I would like to discuss the Guaranteed Contiguous Memory Al=
locator
> >>>>>>>>>>>>> (GCMA) mechanism that is being used by many Android vendors=
 as an
> >>>>>>>>>>>>> out-of-tree feature, collect input on its possible usefulne=
ss for
> >>>>>>>>>>>>> others, feasibility to upstream and suggestions for possibl=
e better
> >>>>>>>>>>>>> alternatives.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> Problem statement: Some workloads/hardware require physical=
ly
> >>>>>>>>>>>>> contiguous memory and carving out reserved memory areas for=
 such
> >>>>>>>>>>>>> allocations often lead to inefficient usage of those carveo=
uts. CMA
> >>>>>>>>>>>>> was designed to solve this inefficiency by allowing movable=
 memory
> >>>>>>>>>>>>> allocations to use this reserved memory when it=E2=80=99s o=
therwise unused.
> >>>>>>>>>>>>> When a contiguous memory allocation is requested, CMA finds=
 the
> >>>>>>>>>>>>> requested contiguous area, possibly migrating some of the m=
ovable
> >>>>>>>>>>>>> pages out of that area.
> >>>>>>>>>>>>> In latency-sensitive use cases, like face unlock on phones,=
 we need to
> >>>>>>>>>>>>> allocate contiguous memory quickly and page migration in CM=
A takes
> >>>>>>>>>>>>> enough time to cause user-perceptible lag. Such allocations=
 can also
> >>>>>>>>>>>>> fail if page migration is not possible.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> GCMA (Guaranteed CMA) is a mechanism previously proposed in=
 [1] which
> >>>>>>>>>>>>> was not upstreamed but got adopted later by many Android ve=
ndors as an
> >>>>>>>>>>>>> out-of-tree feature. It is similar to CMA but backing memor=
y is
> >>>>>>>>>>>>> cleancache backend, containing only clean file-backed pages=
. Most
> >>>>>>>>>>>>> importantly, the kernel can=E2=80=99t take a reference to p=
ages from the
> >>>>>>>>>>>>> cleancache, therefore can=E2=80=99t prevent GCMA from quick=
ly dropping them
> >>>>>>>>>>>>> when required. This guarantees GCMA low allocation latency =
and
> >>>>>>>>>>>>> improves allocation success rate.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> We would like to standardize GCMA implementation and upstre=
am it since
> >>>>>>>>>>>>> many Android vendors are asking to include it as a generic =
feature.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> Note: removal of cleancache in 5.17 kernel due to no users =
(sorry, we
> >>>>>>>>>>>>> didn=E2=80=99t know at the time about this use case) might =
complicate
> >>>>>>>>>>>>> upstreaming.
> >>>>>>>>>>>>
> >>>>>>>>>>>> we discussed another possible user last year: using MTE tag =
storage memory
> >>>>>>>>>>>> while the storage is not getting used to store MTE tags [1].
> >>>>>>>>>>>>
> >>>>>>>>>>>> As long as the "ordinary RAM" that maps to a given MTE tag s=
torage area does
> >>>>>>>>>>>> not use MTE tagging, we can reuse the MTE tag storage ("almo=
st ordinary RAM,
> >>>>>>>>>>>> just that it doesn't support MTE itself") for different purp=
oses.
> >>>>>>>>>>>>
> >>>>>>>>>>>> We need a guarantee that that memory can be freed up / migra=
ted once the tag
> >>>>>>>>>>>> storage gets activated.
> >>>>>>>>>>>
> >>>>>>>>>>> If I remember correctly, one of the issues with the MTE proje=
ct that might be
> >>>>>>>>>>> relevant to GCMA, was that userspace, once it gets a hold of =
a page, it can pin
> >>>>>>>>>>> it for a very long time without specifying FOLL_LONGTERM.
> >>>>>>>>>>>
> >>>>>>>>>>> If I remember things correctly, there were two examples given=
 for this; there
> >>>>>>>>>>> might be more, or they might have been eliminated since then:
> >>>>>>>>>>>
> >>>>>>>>>>> * The page is used as a buffer for accesses to a file opened =
with
> >>>>>>>>>>>       O_DIRECT.
> >>>>>>>>>>>
> >>>>>>>>>>> * 'vmsplice() can pin pages forever and doesn't use FOLL_LONG=
TERM yet' - that's
> >>>>>>>>>>>       a direct quote from David [1].
> >>>>>>>>>>>
> >>>>>>>>>>> Depending on your usecases, failing the allocation might be a=
cceptable, but for
> >>>>>>>>>>> MTE that wasn't the case.
> >>>>>>>>>>>
> >>>>>>>>>>> Hope some of this is useful.
> >>>>>>>>>>>
> >>>>>>>>>>> [1] https://lore.kernel.org/linux-arm-kernel/4e7a4054-092c-4e=
34-ae00-0105d7c9343c@redhat.com/
> >>>>>>>>>>
> >>>>>>>>>> Thanks for the references! I'll read through these discussions=
 to see
> >>>>>>>>>> how much useful information for GCMA I can extract.
> >>>>>>>>>
> >>>>>>>>> I wanted to get an RFC code ahead of LSF/MM and just finished p=
utting
> >>>>>>>>> it together. Sorry for the last minute posting. You can find it=
 here:
> >>>>>>>>> https://lore.kernel.org/all/20250320173931.1583800-1-surenb@goo=
gle.com/
> >>>>>>>>
> >>>>>>>> Sorry about the delay. Attached are the slides from my GCMA
> >>>>>>>> presentation at the conference.
> >>>>>>>
> >>>>>>> Hi Folks,
> >>>>>>
> >>>>>> Hi,
> >>>>>>
> >>>>>>> As I'm getting close to finalizing the GCMA patchset, one questio=
n
> >>>>>>> keeps bugging me. How do we account the memory that is allocated =
from
> >>>>>>> GCMA... In case of CMA allocations, they are backed by the system
> >>>>>>> memory, so accounting is straightforward, allocations contribute =
to
> >>>>>>> RSS, counted towards memcg limits, etc. In case of GCMA, the back=
ing
> >>>>>>> memory is reserved memory (a carveout) not directly accessible by=
 the
> >>>>>>> rest of the system and not part of the total_memory. So, if a pro=
cess
> >>>>>>> allocates a buffer from GCMA, should it be accounted as a normal
> >>>>>>> allocation from system memory or as something else entirely? Any
> >>>>>>> thoughts?
> >>>>>>
> >>>>>> You mean, an application allocates the memory and maps it into its=
 page
> >>>>>> tables?
> >>>>>
> >>>>> Allocation will happen via cma_alloc() or a similar interface, so
> >>>>> applications would have to use some driver to allocate from GCMA. O=
nce
> >>>>> allocated, an application can map that memory if the driver support=
s
> >>>>> mapping.
> >>>>
> >>>> Right, and that might happen either through a VM_PFNMAP or !VM_PFNMA=
P
> >>>> (ordinarily ref- and currently map-counted).
> >>>>
> >>>> In the insert_page() case we do an inc_mm_counter, which increases t=
he RSS.
> >>>>
> >>>> That could happen with pages from carevouts (memblock allocations)
> >>>> already, but we don't run into that in general I assume.
> >>>>
> >>>>>
> >>>>>>
> >>>>>> Can that memory get reclaimed somehow?
> >>>>>
> >>>>> Hmm. I assume that once a driver allocates pages from GCMA it won't
> >>>>> put them into system-managed LRU or free them into buddy allocator =
for
> >>>>> kernel to use. If it does then at the time of cma_release() it can'=
t
> >>>>> guarantee there are no more users for such pages.
> >>>>>
> >>>>>>
> >>>>>> How would we be mapping these pages into processes (VM_PFNMAP or
> >>>>>> "normal" mappings)?
> >>>>>
> >>>>> They would be normal mappings as the pages do have `struct page` bu=
t I
> >>>>> expect these pages to be managed by the driver that allocated them
> >>>>> rather than the core kernel itself.
> >>>>>
> >>>>> I was trying to design GCMA to be used as close to CMA as possible =
so
> >>>>> that we can use the same cma_alloc/cma_release API and reuse CMA's
> >>>>> page management code but the fact that CMA is backed by the system
> >>>>> memory and GCMA is backed by a carveout makes it a bit difficult.
> >>>>
> >>>> Makes sense. So I assume memcg does not apply here already -- memcg =
does
> >>>> not apply on the CMA layer IIRC.
> >>>>
> >>>> The RSS is a bit tricky. We would have to modify things like
> >>>> inc_mm_counter() to special-case on these things.
> >>>>
> >>>> But then, smaps output would still count these pages towards the rss=
/pss
> >>>> (e.g., mss->resident). So that needs care as well ...
> >>>
> >>> In the end I decided to follow CMA as closely as possible, including
> >>> accounting. GCMA and CMA both use reserved area and the difference is
> >>> that CMA donates its memory to kernel to use for movable allocations
> >>> while GCMA donates it to the cleancache. But once that donation is
> >>> taken back by CMA/GCMA to satisfy cma_alloc() request, the memory
> >>> usage is pretty much the same and therefore accounting should probabl=
y
> >>> be the same. Anyway, that was the reasoning I eventually arrived at. =
I
> >>> posted the GCMA patchset at [1] and included this reasoning in the
> >>> cover letter. Happy to discuss this further in that patchset.
> >>
> >> Right, probably best to keep it simple. Will these GCMA pages be
> >> accounted towards MemTotal like CMA pages would?
> >
> > I thought CMA pages are accounted towards CmaTotal and if that's what
> > you mean then yes, they are added to that metric in the patch [1], see
> > the change in gcma_register_area(). I'm not adding the GcmaTotal
> > metric because I think it's simpler to consider GCMA as just a flavor
> > of CMA, as both are used via the same API (cma_alloc/cma_release) and
> > serve the same purpose. The GCMA area can be distinguished from the
> > CMA area using the /sys/kernel/mm/cma/<area>/gcma attribute, but
> > otherwise, it should appear to users as yet another CMA area. Does
> > that make sense?
>
> I was rather wondering whether these pages will be part of /proc/meminfo
> MemTotal: so that totalram_pages_add() is called for them.
>
> For ordinary CMA that happens in cma_activate_area() ->
> init_cma_reserved_pageblock() through adjust_managed_page_count(), where
> we also have the __free_pages() call.

Ah, ok I see what you mean. IIUC this combination of __free_pages() +
adjust_managed_page_count() means the pages from the CMA area are
donated to the system, and therefore the MemTotal is increased. Since
GCMA does not donate its memory to the system (it donates to the
cleancache instead), we do not increase MemTotal.

>
> If nothing changed on that front, then yes, it would behave just like
> ordinary CMA.
>
> I should probably take a look at your v1, unfortunately that might have
> to wait for next week as I'm out of review capacity for today I'm afraid.

No worries, I appreciate your input whenever it arrives.
Thanks!

>
> --
> Cheers
>
> David / dhildenb
>

