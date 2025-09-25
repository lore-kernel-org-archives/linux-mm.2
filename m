Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7804CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 14:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D2A78E0007; Thu, 25 Sep 2025 10:04:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AA6C8E0006; Thu, 25 Sep 2025 10:04:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02138E0007; Thu, 25 Sep 2025 10:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEC908E0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:04:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93845C02CD
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:04:05 +0000 (UTC)
X-FDA: 83927941650.23.A63551C
Received: from mail-ed1-f68.google.com (mail-ed1-f68.google.com [209.85.208.68])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8124980013
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:04:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RqM3ZUCe;
	spf=pass (imf30.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.208.68 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758809043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OnQGqF3miky45oHSFecUX1+o2qxyKeVjODpGjfHwY6Q=;
	b=Qhet6cxIHV73X5+/LOq0rmgzCImDNV9t2trfVVXnVDLuKLbS+JFcPGxNkQQfPulAt8cY29
	B0orCqMSwkQ4DdjW37zuZYmn8HmyxQ9ybfTRJktZhzqLsiA+zhz6B4S6HiW+MVeNgFm0Gg
	I6B/Uw993IiNL1UQrkvd7jKBIHthPfk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RqM3ZUCe;
	spf=pass (imf30.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.208.68 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758809043; a=rsa-sha256;
	cv=none;
	b=TbkOEavKJmeIBVz+/eWlWhvGO94s4W9cLpGSBSEO8rat/eC5LDtazFfnZaPZfR/WrI4SpS
	Uzgoyp4HTSlqWYRk2hG78RaOkBeZ3HV6cIsOBjtyGQDsGQUTIOwKjj3fRsr6g4AWIDl7Ke
	FPfyzKzIKzD7+FZN8YTMv8o7/AZMLQk=
Received: by mail-ed1-f68.google.com with SMTP id 4fb4d7f45d1cf-62fb48315ddso1827716a12.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758809042; x=1759413842; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OnQGqF3miky45oHSFecUX1+o2qxyKeVjODpGjfHwY6Q=;
        b=RqM3ZUCeJoePdYolCcRlRZdt9oQPdOOPIym5la/oiYFBJHqDANM02kyVByX2JCPsb1
         KkpDXj4Wwu+6URGPJUIrNCmagqBOPkSZXgItLD8lpKMa9vzni8eFV3JlHozv1L6RQ1LO
         T4iDCV49MBTnllwe9l2Zpc0tp7XmXSaJbKhrsLcNToeGYGa1cm7IU2qNrlmya1KfehQ+
         7MVVF7sq/UR1auv+nE0Rbvj5iyujawbkBj3FoDPXzwBIbBFP1Q9OaHO3pi+d8mN6b45a
         AFPdca1QWrMbruD7Hy2GKIwxh7V1wtDNjRrvqV8e5psXyOyAL4J3HcJYddtJ1q/+wMf8
         pCdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758809042; x=1759413842;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OnQGqF3miky45oHSFecUX1+o2qxyKeVjODpGjfHwY6Q=;
        b=b0iKUe05EMyGYqwb1290ID8XfUMR1ONJowa7/J4Yxke7r0P29r6aQ2gYhpai1EgArt
         hjaGEQt9RG4eLzjt/HkqoC0hreADgOkX7VThfliORjhe9DR2pZ5kLUOauiN3B7FAnFFr
         VorfNkQcoG/tCJfYej59A9UFCdgEOtxTjQtHVUbl4M6Tij/drWyWOMm6kNzUqCcPF7wm
         OATTokqUymoEqKhdq2Yk+m1u51OhMUypVLSdh0b3dsLh/VE0GHlO5VzqcLkhRi1jfRK3
         BvJdiLsiwdibR/CIAOf3glFUXw9RKgwgMpTxSDaLvz11bXquZEzyUBeRiIdy1rOZ+JGA
         riVA==
X-Forwarded-Encrypted: i=1; AJvYcCW9rZ3dcDX8Zos1cvl2G9mqA6NHeL/LJ1vfkvgcdYcvI/rPuTJOgegyr43reTllqj3upyicfBvvCw==@kvack.org
X-Gm-Message-State: AOJu0YwQY62KpvOJ7HGxqiZUFGZmnGO6V7HuAnCnPViD27FK9grnKIXq
	1mC481KRt6wZiMaLZBOd/i5WVJtD3Wrg5UywCn5br7xTkNhpf/N6QwNp
X-Gm-Gg: ASbGncvwcDyOGMHeewhGO/AuVlgHaOEizPdHd4+H9RWohbqsZ14okqSAKE7YyaZEBUp
	JK4xYWCM41apsdHBJYwkRYO5ayI5wewaF5DhZPl7Xzm1WD/6Mvo/SzyW+dwutmumzT3+UzRfHwY
	7NLpCsBMItTHdWizYA5mWHFbB/Cq7VMAlltSKiICaUfdyw/t38/D6CWQS13zPWEFRdTGxCJ3uiZ
	EC9MFFc1ggVHBYffGQhhEndaPgqF9OYwiAoEOim385PD2FCshAEs0zR+nzKtZfpPqwDaC61wsXo
	8PU2LMPk1gMU/UtFDy0hwbDMwm1E5Bty4n2D4b1w+OkGsJJZ+nM+aMpPs1/oB6vVlJCjh55t7jw
	FZNaEb7xZdl2j2eZguYoX631Xchy6LECdIYx9Ueuliw3gZ6IV5LmSNhiwmmftyd7unjo=
X-Google-Smtp-Source: AGHT+IHjeCgwZEfqa7Y96eBDiBrld/XfJPAMOxqhP0Mq1Pdz0VZI7xx+XxPK7PDI4V3mCywjFrMjnQ==
X-Received: by 2002:a17:907:9484:b0:b2b:3c31:9529 with SMTP id a640c23a62f3a-b34b8b9372cmr357285366b.15.1758809039838;
        Thu, 25 Sep 2025 07:03:59 -0700 (PDT)
Received: from smtpclient.apple ([194.237.228.134])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3546355d6bsm168614766b.111.2025.09.25.07.03.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Sep 2025 07:03:58 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
From: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
In-Reply-To: <20250917174941.000061d3@huawei.com>
Date: Thu, 25 Sep 2025 16:03:46 +0200
Cc: Wei Xu <weixugc@google.com>,
 David Rientjes <rientjes@google.com>,
 Gregory Price <gourry@gourry.net>,
 Matthew Wilcox <willy@infradead.org>,
 Bharata B Rao <bharata@amd.com>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 dave.hansen@intel.com,
 hannes@cmpxchg.org,
 mgorman@techsingularity.net,
 mingo@redhat.com,
 peterz@infradead.org,
 raghavendra.kt@amd.com,
 riel@surriel.com,
 sj@kernel.org,
 ying.huang@linux.alibaba.com,
 ziy@nvidia.com,
 dave@stgolabs.net,
 nifan.cxl@gmail.com,
 xuezhengchu@huawei.com,
 akpm@linux-foundation.org,
 david@redhat.com,
 byungchul@sk.com,
 kinseyho@google.com,
 joshua.hahnjy@gmail.com,
 yuanchu@google.com,
 balbirs@nvidia.com,
 alok.rathore@samsung.com,
 yiannis@zptcorp.com,
 Adam Manzanares <a.manzanares@samsung.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
References: <20250910144653.212066-1-bharata@amd.com>
 <aMGbpDJhOx7wHqpo@casper.infradead.org>
 <aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F>
 <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
 <CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
 <20250917174941.000061d3@huawei.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
X-Mailer: Apple Mail (2.3818.100.11.1.3)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8124980013
X-Stat-Signature: gu5q3h6khrqog8gnxuayf6sspcarmq8o
X-HE-Tag: 1758809043-348353
X-HE-Meta: U2FsdGVkX1/xDIGW0v7IDcfkWdq9PpPNjQA1u6a8UmxJkqd3vJwbAcgejJgDC1mO1SnxKs8eyjgPvQcYo6pGBjrUI1vqN0HgH6h4xI3v0KIsFa1dYqnud7nGGb9PNalWScKdnENCyCNlcagA7VFf2Rqt6W6PVq3T4/eaumSA6iRJZst6JMLyySc43g8lW+rFnp8xHL1CGXnfEbOSz9+aKQVMoIJJ3zYi6TX/qaefnHHX35grd+MMPWOVc9B3Tn73nrvtC4/J6/rr8SwKxi4HKXpswP0KSo+5y5rsWcCFiv8FnP1CNOi7tVbfms3JN4Ica4MpUnmuNM06MODeEBuV1H+q3B1KhUxrgL4kFQTewL6ZnPTTuYMnYn+CnnwZl4rGoIRxDTp/THzrUCZCIS0rJQzdLLDVkj79IX9wuDBn1qHlHIoC5zWZBgkMyOA/Oqik8puYYxwwWpkIihRr3O/TV9ql809eT70gAKNn01RcbSCRtdWCRn9GeW0+fa1u6E7EE3QlSUOgE4mHbwlWKZHvOAJTMQgNlB09XQiRXjFcfykieq/CqQZOu3L0V6I1w8+Be4fxtXP5gn+wV/2t3YeuKR5waylnzqXe5mLvP6usBpfYnVU9B0GuaTpH5P5bcbdPu561AFcDxrPn5wMxH1ezwkfL3DqU15DRa8w1f+lqNBqKQ3Llk6sxwFfrIaSKVVA3gAV15zBKXW+tXt1iJS0xAN4cvhNgjv4cfa70vub+yp5mjkY/xKx24jJqGNFk+pWsrhJXTaqHaaY8uh1S/9buJg9HEQruKwBh/R7T7iufQmmnonuPv9cS1gKww7LdxYw+uanX3tcjc7k4w6fQgl9HPpIgfTDkaxLYcV8YEBH5AVDjHsmR4lnvnX7EEsSG+AZI3konQHT8IBSnbZiUYvp5oHV7vnqpjCuDZ3BnnR2uuqR7IXbIQEjXgh95PTWX4Gc+WqdZ4rG8JfNRT2L8uK1
 5GsMkL4F
 mL8Pf0Nvou/KDkURlIjWDZ+KRepPhC1R1ogzIjwH+ZYbJsHHrRaybQ7S4oIWx0fu7G8Me3Led4wdWospg3VwS7Q0hXP3CNfe5tAeHN/jbbl1dkG/huxklpuQPUxZbDofO0u7MywfpDNGk60wYNLk/oPHiIbQN9pMiMfzNj0aMziRJ7wA+PgVlenw2MYSQDyeVEIg1V1hFInvUpCO62Ony7ZmC5wxxV6QFYdI2PeHoWtv9viiZ46KEJg7Y/i7sSiyX+C5Zhl7uLghDRcdZYr0sZimZqVOMN2+RiWJCjH5b/b45sKVqbm6zzpQNXjoAU6j8nK4I0cuXDLoNYrxySTa9UU8Hik3emBdcypFUW8vjqIQ94xZEvwWqC/JbPppEAR6d5sGLrdEB6BLgaCcqjTRQqTZghjLKrmW66iMc++j4ZDqoFECKID7UicBn0zYxumi0g4TcLGHEAc4fDNqB8W51sZU9F+5Tld5JRLNlW23p1wnzc+aFSdvvTiCikElQKplfeVIIzpiy+jILhwGvyno6hewiyaKAGNYwH+wMeA8UwIMPK4o6NdZnyFvnwZyYvPsnVi8dYjRT/IYFjZHSmyIR48i1XfU4EHFAIg64a4oHqj09zG1UTB7NXkOYQYz+R4XS1AmER7ZI7GGqQ2o2xUIBEmuJUi9oIr1MhpCjrWdLlO1iPdWCm01RVGFdqAa+lAcuWmhxPnKe1Z8Pzps=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 17 Sep 2025, at 18:49, Jonathan Cameron =
<jonathan.cameron@huawei.com> wrote:
>=20
> On Tue, 16 Sep 2025 17:30:46 -0700
> Wei Xu <weixugc@google.com> wrote:
>=20
>> On Tue, Sep 16, 2025 at 12:45=E2=80=AFPM David Rientjes =
<rientjes@google.com> wrote:
>>>=20
>>> On Wed, 10 Sep 2025, Gregory Price wrote:
>>>=20
>>>> On Wed, Sep 10, 2025 at 04:39:16PM +0100, Matthew Wilcox wrote: =20
>>>>> On Wed, Sep 10, 2025 at 08:16:45PM +0530, Bharata B Rao wrote: =20
>>>>>> This patchset introduces a new subsystem for hot page tracking
>>>>>> and promotion (pghot) that consolidates memory access information
>>>>>> from various sources and enables centralized promotion of hot
>>>>>> pages across memory tiers. =20
>>>>>=20
>>>>> Just to be clear, I continue to believe this is a terrible idea =
and we
>>>>> should not do this.  If systems will be built with CXL (and given =
the
>>>>> horrendous performance, I cannot see why they would be), the =
kernel
>>>>> should not be migrating memory around like this. =20
>>>>=20
>>>> I've been considered this problem from the opposite approach since =
LSFMM.
>>>>=20
>>>> Rather than decide how to move stuff around, what if instead we =
just
>>>> decide not to ever put certain classes of memory on CXL.  Right =
now, so
>>>> long as CXL is in the page allocator, it's the wild west - any page =
can
>>>> end up anywhere.
>>>>=20
>>>> I have enough data now from ZONE_MOVABLE-only CXL deployments on =
real
>>>> workloads to show local CXL expansion is valuable and performant =
enough
>>>> to be worth deploying - but the key piece for me is that =
ZONE_MOVABLE
>>>> disallows GFP_KERNEL.  For example: this keeps SLAB meta-data out =
of
>>>> CXL, but allows any given user-driven page allocation (including =
page
>>>> cache, file, and anon mappings) to land there.
>>>>=20
>>>=20
[snip]
>>> There's also some feature support that is possible with these CXL =
memory
>>> expansion devices that have started to pop up in labs that can also
>>> drastically reduce overall TCO.  Perhaps Wei Xu, cc'd, will be able =
to
>>> chime in as well.
>>>=20
>>> This topic seems due for an alignment session as well, so will look =
to get
>>> that scheduled in the coming weeks if people are up for it. =20
>>=20
>> Our experience is that workloads in hyper-scalar data centers such as
>> Google often have significant cold memory. Offloading this to CXL =
memory
>> devices, backed by cheaper, lower-performance media (e.g. DRAM with
>> hardware compression), can be a practical approach to reduce overall
>> TCO. Page promotion and demotion are then critical for such a tiered
>> memory system.
>=20
> For the hardware compression devices how are you dealing with capacity =
variation
> / overcommit? =20
I understand that this is indeed one of the key questions from the =
upstream
kernel=E2=80=99s perspective.
So, I am jumping in to answer w.r.t. what we do in ZeroPoint; obviously =
I can
not speak of other solutions/deployments. However, our HW interface =
follows=20
existing open specifications from OCP=E2=80=8B [1], so what I am =
describing below is
more widely applicable.

At a very high level, the way our HW works is that the DPA is indeed
overcommitted. Then, there is a control plane over CXL.io (PCIe) which
exposes the real remaining capacity, as well as some configurable
MSI-X interrupts that raise warnings when the capacity crosses over
certain configurable thresholds.

Last year I presented this interface in LSF/MM [2]. Based on the =
feedback I
got there, we have an early prototype that acts as the *last* memory =
tier
before reclaim (kind of "compressed tier in lieu of discard" as was
suggested to me by Dan).

What is different from standard tiering is that the control plane is
checked on demotion to make sure there is still capacity left. If not, =
the
demotion fails. While this seems stable so far, a missing piece is to
ensure that this tier is mainly written by demotions and not arbitrary =
kernel
allocations (at least as a starting point). I want to explore how =
mempolicies
can help there, or something of the sort that Gregory described.

This early prototype still needs quite some work in order to find the =
right
abstractions. Hopefully, I will be able to push an RFC in the near =
future
(a couple of months).

> Whilst there have been some discussions on that but without a
> backing store of flash or similar it seems to be challenging to use
> compressed memory in a tiering system (so as 'normalish' memory) =
unless you
> don't mind occasionally and unexpectedly running out of memory (in =
nasty
> async ways as dirty cache lines get written back).
There =E2=80=8Bare several things that may be done on the device side. =
For now, I
think the kernel should be unaware of these. But with what I described
above, the goal is to have the capacity thresholds configured in a way
that we can absorb the occasional dirty cache lines that are written =
back.
>=20
> Or do you mean zswap type use with a hardware offload of the actual
> compression?
I would categorize this as a completely different discussion (and =
product
line for us).

[1] =
https://www.opencompute.org/documents/hyperscale-tiered-memory-expander-sp=
ecification-for-compute-express-link-cxl-1-pdf
[2] https://www.youtube.com/watch?v=3DtXWEbaJmZ_s

Thanks,
Yiannis

PS: Sending from a personal email address to avoid issues with
confidentiality footers of the corporate domain.=

