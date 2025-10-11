Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 370D8CCD187
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 02:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290C88E0014; Fri, 10 Oct 2025 22:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268858E0011; Fri, 10 Oct 2025 22:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17E498E0014; Fri, 10 Oct 2025 22:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06CEB8E0011
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 22:14:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E1861DE9DF
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 02:14:27 +0000 (UTC)
X-FDA: 83984214174.10.CC12C06
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id ADD192000C
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 02:14:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ct+2C7JC;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760148865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjM7Uo7QXRSYcqIINz76pFr6NJAIPUeKl8+ji06M7jI=;
	b=nvbJJdfsQgDF8/OwdjPEe5tGSg/E7c/MpdsmV7VSxPP/Yj2oP5VU9IJ/I7SYxTAaWTQM8G
	ZDlbS/GNExAqtPXOA1TXQhXuplZVHvcoQJsUaR3h1W/EL+udlpDHau6PbbcgCIkY148DEf
	gENEzKTtLZmAepKEz92ocQigHD2VSmI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ct+2C7JC;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760148865; a=rsa-sha256;
	cv=none;
	b=HmtY/QN2cnZLQwmD1DDnNPsnaW8sV3t37hbCQ5Iug9VqNRUXvoTP90qDEBvKdm0Mt8pngW
	W9WS+a5Ia8sFyYe5uRa9pv0ER0AKxEX1FzR/Q1YFoCNm4mJ0bXcYIdYqRxBRZeZdP905xu
	dBqbgMuT0dslhPZwsXgZTuQJwC1bMGA=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-78e4056623fso29164186d6.2
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 19:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760148865; x=1760753665; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OjM7Uo7QXRSYcqIINz76pFr6NJAIPUeKl8+ji06M7jI=;
        b=Ct+2C7JCSgKaqZ/OXKbh+BdqQJNT4gEQnvr306hXvTGdbAhdZvWsPwSWwIuvA/hFHY
         W1sythTdAVEz4a+8MWHDiiEtmlOknfhQj7SSS3rr/ZkW3+fgWC3AbPKuZGwoy+g41ECg
         q9ENSy/u0abubZOieDfuSI+F5o8ZzHyW6Yjog1x4ekBXFzAm62fLsO/bLAqX7d7pPR5X
         bkjX8ykGdGWyi1KOv3YBEEH9Va7qxqTVT9kI3g4ZUGfJXrTiWPal6fWSlHfxKt/Fm8W5
         a1nYe1/hDzdG3JwqO4XcrWAkd3LwIUDKH2wt+o2vOGf4A/Abo7Dk+d7cEHs8ZnmdOGtU
         3sxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760148865; x=1760753665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OjM7Uo7QXRSYcqIINz76pFr6NJAIPUeKl8+ji06M7jI=;
        b=oez6LOseP+ywKqsvr3rmfYNmig56Ge3N/D10mxsnaPwFXHxBPIpj6VWNWv/3bKCh1h
         gR/54S6PeEW5cIJcUZnzaSGPfxhx051mT63MfN5OpwULhiS9U4PMrPwR/NJuaVvhsmDg
         1KsSfoxH660p8Brx3pP+f0Sce29/STJiD2roMpcSTZMhByc/WrvBoIVf+hgArgTOBDKC
         r1frWwkHqBGxuGsCvU16+LtCUbRPXGZsc3Ke/hcdWSlOHkHaemmkTsDvG+pwNuclckZE
         n6D+OvAHI2X+z/BA6qYGCN4CIiOeo5SZyrlG0mjIJuuuD/tbxZXB6X2H3+JH0iYL72TK
         dtLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWW7g67ewXFYaziYHfHXsw5bulGPpm8aGxLVuacEcgRAyu9dwcEQz+2NrRyUyQLM+MgA0818NVF/A==@kvack.org
X-Gm-Message-State: AOJu0YzstrmxySsDb4aYykPPTEFWvO8z9i1UB6xjVgPW6xxK+kqlfcut
	dI8DLjSfm0zP+xCfhCiXuMpd81l1chRthmP4cSeTEv11aIQHzAkqyj6kDGiYPPwpZY+iwPr98Hn
	+Blr7vNocNVqsH3GsnknXaWjLYNCqvCk=
X-Gm-Gg: ASbGnctODmjGXjo7xVulmJxN2FBEpTpPaGNkR4kOPfmrn/MgKvkZ5hiRUEMeC96ZVdR
	kYd+K2u7VbrwtxLtZ+f8/YymsIv4zc3CFUtEPyIXvc3ryxgogAmAIX+95QVzxexfEUTtKysMd7k
	VEKThVKpR4GBH5nWCoVbLceEXVyElMtdFW7nKrOzMypJl/buiNSQaEAX7qVhEXitP8f/HlkVvsS
	7bz8vasu14NP3+aXSFxm+CMDSXVdilKP/06cTf/znSqK4aT3Z01rK7yoXQ=
X-Google-Smtp-Source: AGHT+IGaeWexa9bzckVo2Zuz8KIURfJ9ec0dzy2/uD8zB9hlaiwuFTNQBQBPWfvTfKv9XXFEhBIN1ZQ9u4RYMWr8GwE=
X-Received: by 2002:a05:6214:250d:b0:72a:ba05:7759 with SMTP id
 6a1803df08f44-87b2105abd3mr248316426d6.28.1760148864567; Fri, 10 Oct 2025
 19:14:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250930055826.9810-1-laoar.shao@gmail.com> <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
 <27e002e3-b39f-40f9-b095-52da0fbd0fc7@redhat.com> <CALOAHbBFNNXHdzp1zNuD530r9ZjpQF__wGWyAdR7oDLvemYSMw@mail.gmail.com>
 <7723a2c7-3750-44f7-9eb5-4ef64b64fbb8@redhat.com> <CALOAHbD_tRSyx1LXKfFrUriH6BcRS6Hw9N1=KddCJpgXH8vZug@mail.gmail.com>
 <96AE1C18-3833-4EB8-9145-202517331DF5@nvidia.com> <f743cfcd-2467-42c5-9a3c-3dceb6ff7aa8@redhat.com>
 <CALOAHbAY9sjG-M=nwWRdbp3_m2cx_YJCb7DToaXn-kHNV+A5Zg@mail.gmail.com>
 <129379f6-18c7-4d10-8241-8c6c5596d6d5@redhat.com> <CALOAHbD8ko104PEFHPYjvnhKL50XTtpbHL_ehTLCCwSX0HG3-A@mail.gmail.com>
 <3577f7fd-429a-49c5-973b-38174a67be15@redhat.com>
In-Reply-To: <3577f7fd-429a-49c5-973b-38174a67be15@redhat.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sat, 11 Oct 2025 10:13:48 +0800
X-Gm-Features: AS18NWCAaE3m0s9H3fRQL4N3FgUc6r2BHuW_Zdib2ILLDEDUTnQn0cQOhl7yXZI
Message-ID: <CALOAHbAeS2HzQN96UZNOCuME098=GvXBUh1P4UwUJr0U-bB5EQ@mail.gmail.com>
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: David Hildenbrand <david@redhat.com>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	baolin.wang@linux.alibaba.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	Matthew Wilcox <willy@infradead.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, 21cnbao@gmail.com, Shakeel Butt <shakeel.butt@linux.dev>, 
	lance.yang@linux.dev, Randy Dunlap <rdunlap@infradead.org>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: ADD192000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: m76o9jbf6qhnhi9ckpk7w9txk89w19sm
X-HE-Tag: 1760148865-600136
X-HE-Meta: U2FsdGVkX1+P7NRHe7+xpVmwlDVymAT+mWdCKEsIDM7i1/DX3rA0cknVXZIxVpD9h4aQvXJSdyB092/FyheDo6xjFjkPKwhTeij9a1ptTakypPM1oWEfQ9W0QRs60gI7uDoiZJ+857ncs4CGSBIaRDdAhAt8kpDr+exYT5Am0DUkFQGdqzS2gbtZXIYaGAA0aK9Zwz4LQCSVpAz+7TdaKe7mYxJygekS9sbVzyB1ouib3cr172pgIKNEKEKFySwjzc+B08ofrClrVbX7N07LutYeU0tiaafFQwhp5xYswFTVr7COo7ygJtsyKVjrw4S+qZdO1Oy+FD4cn/5PnTTgHnz4JQbqFxrI4f0DNoBd/UrYB6QygQn9BYVYYY6OZgEJAGa6q7noxPJeV2KrR+qehg9oTiY/3OQs4UNaAmDYCKU3EswzCf34wpUBO28RpSmzJBtQNlafMdvmyGIGUVGwS5SJkhCTTEB/FdvvimBowXzosCdtS53JAXj5JuHyWhRkFNwdvvHpkB2U8yLplxfqf4z7/8FOQNrCzylxJeRVysWqELFVJ3D+OeFd/hIWaaR75CRcqhiNd6DtrFd6YXjRj9ZZsHyCuxhaTVUPAkreWmhij9JB71CFyS50gOzDuDn+EVXDXcUWHdzPUb0/qtJK90GwFPGvQ0lT0XKJ8qgmWnbTABKLchXmsk3ebLRjXI2J8TzG8lLazmsJFzsnyhNU5FIR/L7IJvLSGJ08PGBVXjH4KjfOv7pqgRgdD69CplludgFywrbk4at8su6Lr+Zqjv//O0wxyVyy3Q//JLKhmvPcElEuRhQgrHiiQjpz7ZdhoQ7MuDr0IgvtMflznOVR/nidP6+edMZFBYiF8muk7RtrNafJe6JtOBD+Qg7JJ7C4TqCZs+M5ehu1OZbNUhODUBrwlVPQqPiumbzkqvppI84qbPEgLcBLYXEi3XoeQvPgHqpn6//I9ypsjmZlLeO
 8S9fh2EP
 w8rwId5+cvcWCGHMhEc7GFGfxUu/Ton+R4BkpagRRur9ziByoYmYH2KV6mzS3t5EgmHDyFbMehmK+DUmmSrCSBCj+VHkCqH3reriAYYmvEDEiGOEeARMKjQ1+BeXjJRZXEK1Ntd2Dh5uP/HH4DY7DgAWuKiDOx1EmLA9eZfsswCbr8U+bMZsa9tB3CtqQSDxmzxo65TGeM/Fj1G1QRn1Pe4unLO3r6rWu0a8SB1o63goe9KaRBDnlO/zDzTNbvMuKZdBfPF4I/eaA7p9pdVwVvwlPC+cDeEXHQ8RfkwWUw9g+A4fhcJvvkNgwWDC8KvO/8p/fzu6KMYkfOulYtGipaqj3WRQPMRarftOKrKbjMre6loIBeIPa5VZOXOu6T+wRJrUyU1I2cbEo/a4+ftsOaumC4u2RGN+CBuLSjgUOXVtiIV2YSFnIjtTPjdiF8FUSHwH7qXeDwvqwLD0F0nPoMAskucBh3sw2oaVw/yRlDs4FNSE3BpC+EZi76N//p+rzWL7NEMYZ33+AX2u9J/f/JpqacfDoweIN+vTyN2vZ8mlKHjYYej+yO1zV8Ze6Kxiq/sEDtNH9qLLczJ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 3:54=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 09.10.25 11:59, Yafang Shao wrote:
> > On Thu, Oct 9, 2025 at 5:19=E2=80=AFPM David Hildenbrand <david@redhat.=
com> wrote:
> >>
> >> On 08.10.25 15:11, Yafang Shao wrote:
> >>> On Wed, Oct 8, 2025 at 8:07=E2=80=AFPM David Hildenbrand <david@redha=
t.com> wrote:
> >>>>
> >>>> On 08.10.25 13:27, Zi Yan wrote:
> >>>>> On 8 Oct 2025, at 5:04, Yafang Shao wrote:
> >>>>>
> >>>>>> On Wed, Oct 8, 2025 at 4:28=E2=80=AFPM David Hildenbrand <david@re=
dhat.com> wrote:
> >>>>>>>
> >>>>>>> On 08.10.25 10:18, Yafang Shao wrote:
> >>>>>>>> On Wed, Oct 8, 2025 at 4:08=E2=80=AFPM David Hildenbrand <david@=
redhat.com> wrote:
> >>>>>>>>>
> >>>>>>>>> On 03.10.25 04:18, Alexei Starovoitov wrote:
> >>>>>>>>>> On Mon, Sep 29, 2025 at 10:59=E2=80=AFPM Yafang Shao <laoar.sh=
ao@gmail.com> wrote:
> >>>>>>>>>>>
> >>>>>>>>>>> +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct =
*vma,
> >>>>>>>>>>> +                                     enum tva_type type,
> >>>>>>>>>>> +                                     unsigned long orders)
> >>>>>>>>>>> +{
> >>>>>>>>>>> +       thp_order_fn_t *bpf_hook_thp_get_order;
> >>>>>>>>>>> +       int bpf_order;
> >>>>>>>>>>> +
> >>>>>>>>>>> +       /* No BPF program is attached */
> >>>>>>>>>>> +       if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> >>>>>>>>>>> +                     &transparent_hugepage_flags))
> >>>>>>>>>>> +               return orders;
> >>>>>>>>>>> +
> >>>>>>>>>>> +       rcu_read_lock();
> >>>>>>>>>>> +       bpf_hook_thp_get_order =3D rcu_dereference(bpf_thp.th=
p_get_order);
> >>>>>>>>>>> +       if (WARN_ON_ONCE(!bpf_hook_thp_get_order))
> >>>>>>>>>>> +               goto out;
> >>>>>>>>>>> +
> >>>>>>>>>>> +       bpf_order =3D bpf_hook_thp_get_order(vma, type, order=
s);
> >>>>>>>>>>> +       orders &=3D BIT(bpf_order);
> >>>>>>>>>>> +
> >>>>>>>>>>> +out:
> >>>>>>>>>>> +       rcu_read_unlock();
> >>>>>>>>>>> +       return orders;
> >>>>>>>>>>> +}
> >>>>>>>>>>
> >>>>>>>>>> I thought I explained it earlier.
> >>>>>>>>>> Nack to a single global prog approach.
> >>>>>>>>>
> >>>>>>>>> I agree. We should have the option to either specify a policy g=
lobally,
> >>>>>>>>> or more refined for cgroups/processes.
> >>>>>>>>>
> >>>>>>>>> It's an interesting question if a program would ever want to sh=
ip its
> >>>>>>>>> own policy: I can see use cases for that.
> >>>>>>>>>
> >>>>>>>>> So I agree that we should make it more flexible right from the =
start.
> >>>>>>>>
> >>>>>>>> To achieve per-process granularity, the struct-ops must be embed=
ded
> >>>>>>>> within the mm_struct as follows:
> >>>>>>>>
> >>>>>>>> +#ifdef CONFIG_BPF_MM
> >>>>>>>> +struct bpf_mm_ops {
> >>>>>>>> +#ifdef CONFIG_BPF_THP
> >>>>>>>> +       struct bpf_thp_ops bpf_thp;
> >>>>>>>> +#endif
> >>>>>>>> +};
> >>>>>>>> +#endif
> >>>>>>>> +
> >>>>>>>>      /*
> >>>>>>>>       * Opaque type representing current mm_struct flag state. M=
ust be accessed via
> >>>>>>>>       * mm_flags_xxx() helper functions.
> >>>>>>>> @@ -1268,6 +1281,10 @@ struct mm_struct {
> >>>>>>>>      #ifdef CONFIG_MM_ID
> >>>>>>>>                     mm_id_t mm_id;
> >>>>>>>>      #endif /* CONFIG_MM_ID */
> >>>>>>>> +
> >>>>>>>> +#ifdef CONFIG_BPF_MM
> >>>>>>>> +               struct bpf_mm_ops bpf_mm;
> >>>>>>>> +#endif
> >>>>>>>>             } __randomize_layout;
> >>>>>>>>
> >>>>>>>> We should be aware that this will involve extensive changes in m=
m/.
> >>>>>>>
> >>>>>>> That's what we do on linux-mm :)
> >>>>>>>
> >>>>>>> It would be great to use Alexei's feedback/experience to come up =
with
> >>>>>>> something that is flexible for various use cases.
> >>>>>>
> >>>>>> I'm still not entirely convinced that allowing individual processe=
s or
> >>>>>> cgroups to run independent progs is a valid use case. However, sin=
ce
> >>>>>> we have a consensus that this is the right direction, I will proce=
ed
> >>>>>> with this approach.
> >>>>>>
> >>>>>>>
> >>>>>>> So I think this is likely the right direction.
> >>>>>>>
> >>>>>>> It would be great to evaluate which scenarios we could unlock wit=
h this
> >>>>>>> (global vs. per-process vs. per-cgroup) approach, and how
> >>>>>>> extensive/involved the changes will be.
> >>>>>>
> >>>>>> 1. Global Approach
> >>>>>>       - Pros:
> >>>>>>         Simple;
> >>>>>>         Can manage different THP policies for different cgroups or=
 processes.
> >>>>>>      - Cons:
> >>>>>>         Does not allow individual processes to run their own BPF p=
rograms.
> >>>>>>
> >>>>>> 2. Per-Process Approach
> >>>>>>        - Pros:
> >>>>>>          Enables each process to run its own BPF program.
> >>>>>>        - Cons:
> >>>>>>          Introduces significant complexity, as it requires handlin=
g the
> >>>>>> BPF program's lifecycle (creation, destruction, inheritance) withi=
n
> >>>>>> every mm_struct.
> >>>>>>
> >>>>>> 3. Per-Cgroup Approach
> >>>>>>        - Pros:
> >>>>>>           Allows individual cgroups to run their own BPF programs.
> >>>>>>           Less complex than the per-process model, as it can lever=
age the
> >>>>>> existing cgroup operations structure.
> >>>>>>        - Cons:
> >>>>>>           Creates a dependency on the cgroup subsystem.
> >>>>>>           might not be easy to control at the per-process level.
> >>>>>
> >>>>> Another issue is that how and who to deal with hierarchical cgroup,=
 where one
> >>>>> cgroup is a parent of another. Should bpf program to do that or mm =
code
> >>>>> to do that? I remember hierarchical cgroup is the main reason THP c=
ontrol
> >>>>> at cgroup level is rejected. If we do per-cgroup bpf control, would=
n't we
> >>>>> get the same rejection from cgroup folks?
> >>>>
> >>>> Valid point.
> >>>>
> >>>> I do wonder if that problem was already encountered elsewhere with b=
pf
> >>>> and if there is already a solution.
> >>>
> >>> Our standard is to run only one instance of a BPF program type
> >>> system-wide to avoid conflicts. For example, we can't have both
> >>> systemd and a container runtime running bpf-thp simultaneously.
> >>
> >> Right, it's a good question how to combine policies, or "who wins".
> >
> >  From my perspective, the ideal approach is to have one BPF-THP
> > instance per mm_struct. This allows for separate managers in different
> > domains, such as systemd managing BPF-THP for system processes and
> > containerd for container processes, while ensuring that any single
> > process is managed by only one BPF-THP.
>
> I came to the same conclusion. At least it's a valid start.
>
> Maybe we would later want a global fallback BPF-THP prog if none was
> enabled for a specific MM.

good idea. We can fallback to the global model when attaching pid 1.

>
> But I would expect to start with a per MM way of doing it, it gives you
> way more flexibility in the long run.

THP, such as shmem and file-backed THP, are shareable across multiple
processes and cgroups. If we allow different BPF-THP policies to be
applied to these shared resources, it could lead to policy
inconsistencies. This would ultimately recreate a long-standing issue
in memcg, which still lacks a robust solution for this problem [0].

This suggests that applying SCOPED policies to SHAREABLE memory may be
fundamentally flawed ;-)

[0]. https://lore.kernel.org/linux-mm/YwNold0GMOappUxc@slm.duckdns.org/

(Added the maintainers from the old discussion to this thread.)

--=20
Regards
Yafang

