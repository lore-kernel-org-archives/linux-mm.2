Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED008C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 09:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E34216B0443; Mon, 17 Aug 2026 05:41:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0B916B05D7; Mon, 17 Aug 2026 05:41:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D49866B05F5; Mon, 17 Aug 2026 05:41:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B42476B0443
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:41:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 267EA806BF
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:41:15 +0000 (UTC)
X-FDA: 85110268110.02.E6B5088
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 34A1C180007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:41:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QSRNwRZr;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786959673;
	b=5kMAyQB8rFUXvVWVMMTsk0vqtwemr38Atu+jABzpzd5Ci2/5ZgkDB+bxZrnVMr5M36Mtb+
	Iyl4+nyJ3ElOUZ1TBrA3iZnPdIKaC0HWApzyqIgl2dj09h2EYj1GuCAqnAKTxD+Mag/L2C
	h5TKfOYMLaod/BeGAXUf/WkRCxOfgmE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QSRNwRZr;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786959673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xM0Jv1MN8RK5yk+ejT9VDlQVaj3QwZ/bKuG2ZVbh3Rg=;
	b=KuY0EI8WvNqNlIOktbOgI0s6p8M9h/ek3anb5lnAHSGeQCWJNE3G0hoN0UC9I3CmENWlaT
	cXxJjegs9zQj68W7Dz185aAA7dVfJuW0LVDe76rd5u4ISRkoC5tewvC8vuNM96O+jaZIDc
	JatJJYCuCRHMEu7gYDzXtMV2Tm8PIGs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 638374326F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4847B1F00A3D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786959672;
	bh=xM0Jv1MN8RK5yk+ejT9VDlQVaj3QwZ/bKuG2ZVbh3Rg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QSRNwRZr/t9440iqEXzv9BbfjwoHTADp+8ohb7Cm4MlxyFfu72iQQ9dd4cUdlFs6y
	 0FlOZdg4Bq8RJ0vEuAHrcjabLPZJ99ACyf6LWDCO8H9/ATQNtCEf+6YBWJvMRh+Qfw
	 1SuubMT/vA9yZqMRHtHXDee8M6ttWcP8ATUQLZCu3zI7jhlrKxQc0VXLoNTgoFZ/D8
	 1zmtveSxJZIynmLBYlB2zNZBsMqpVMcrrALGhbfUMT/1WvyMKRCL2lWafgEyJF7GeR
	 /AVE/R2oIVXL2f5Z2uqoqlObIMlS7WAFE6yNvtzAq/pTgV2yQXwIyw0UNFbeX3B3+q
	 oAaVT//LNVAdA==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e7c6ec9dbso142107085a.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:41:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Roj04yD6efSuO8TV2jdul1JCpaoxUHLUFi0YFXMgqDKO2i9RRL2C7rN4kDG9sCAeEZE51opcbfafg==@kvack.org
X-Gm-Message-State: AOJu0YzuGoaLBnHURy0h6hsIPgQuEPkku2agX0QUYbj+3nAYiykUdZcb
	6A3ONdtRwRXMGwO8Y3TV7sapuWsW51o5JzkYx5vLXuO8p+0B24ZyTmQ9dxANtjcmM9PCY3JRX7F
	lWzmFCXURzlDpUGfPIvOuDZDiJ8/5vrE=
X-Received: by 2002:a05:620a:c97:b0:92e:52df:3523 with SMTP id
 af79cd13be357-936d224b35cmr1701887885a.8.1786959671652; Mon, 17 Aug 2026
 02:41:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260813-swap-v2-0-4a625ccabdae@debian.org> <20260813-swap-v2-3-4a625ccabdae@debian.org>
 <CAGsJ_4y7kQmZpfPQo8n5wRD2syHRj21XPvi6+OjVm_cXbfDLQQ@mail.gmail.com> <aoLTWeyz_GldJwe4@gmail.com>
In-Reply-To: <aoLTWeyz_GldJwe4@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 17 Aug 2026 17:40:59 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y77jHiYNawJcKTS+HWL2_Fck2rDFN+AWV+8bHx42qdWA@mail.gmail.com>
X-Gm-Features: AcwNN1VR9MqfIW2H4r7W2viBMeaTqtLPETE8RgmkqldpJdjUYh9_gY6raUygSqs
Message-ID: <CAGsJ_4y77jHiYNawJcKTS+HWL2_Fck2rDFN+AWV+8bHx42qdWA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: fail the fault on a malformed swap entry
 instead of retrying it
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 34A1C180007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: opwxdrdzeu9jr8uro68ifwzgmnf55biw
X-HE-Tag: 1786959673-112414
X-HE-Meta: U2FsdGVkX1/04swJbXgaQzcL4M3M+WWeXao1u7eqZdW8w74EuY3eDVVh4kpk52PUI5bysXk3yoTgwdA3xcEGZce9K7vPbdjSud0WEW/BvKOz72LZbhRThZqueH9UHMGW7hJ72kufMRec/3QI/GiGOnOjZOWD/yJvXu0tY/33GLBFd9IW8KeD9tRE3UIFQ+cMg7hsgBHuFZcVEytpGwwnT74nXxKKSEowuRk1RTnwmjvZ/hLXMFVylRnTa4M/g2mxHGkgFeV8rC4cHQ6zEEnw+IjLM28Dk7I2Q550cyPkPTPnAMkqndvOvd3csDboy16bVXsUcNSFI4V66oYSJ7DagsQwyt3QdTve+jmM7gOpr8brVrZEpPPSedzGANY20NLSOC5QB0o6/Z+DUwZfnNDjwBqB8fD1wxCudagHv3JqeJs+wYih9j9RXA8H9hx/uB+WaAwuIbbDh7pP7xbyfesVsFrK5H2LzOH62Vai6CHHg8190nfK8uAkFbk+EXjHDxbi+2VgVUAgrEPqzSO2s/fGejlhNVGKe3AnefKCEtNiuL0bGO1TY6xJU5JQC1Y4iyZgvajAAnJwfBbQvED7iBrC2O4934w2K6Mx8AbAzf0bv6T7yuRIYN1GQejl/LTXBsu4yjyHBV7k5uiWfB0YBYQrtw/65oGD6Z7tjAWZ8zCnd/wd1TmN1s9/Aya+p+p5pRtERS9YzfgBH02nqZK3sRymNS/Zh8jSdw603rbqcolRyHdZ2xOD7niFFgv5MwL56CT7TxwFBsrMpsgoUU08hMS9ZLBbfmte4W5M06U4VbO7/1kbx4rAT9iYr+3/BveZI5zBH5kahuYW0ubWjQ4Owy7tUaDX647XXSQ4lWhuLgIOHOiVsdviEpWsbrDPpsvQj/wQwms2rxPx7I3OoHGUqbh/aRx6seHlCBIwxCQvpPseMhV4PDZnxupad/BSU2Skx3M5zPdGeL/zDOn/qN+U8hM
 9WBCiYUs
 duE+qdi65+EtTSaSCiyZxH8Yb6/MkMq5cWg+bnz3W4Lk0qIrRzbJc8HrDek1O28wj9mIOZjrryXq2Bvu8FECjEtkU1JUB4uaakVHfl9dj1defEiYJteXDXP/AW16Eh4gEJ1g3V+sJ3VWW5les/aQR5nXkMpxAepz17H/4ZNKWN1agYBB0u/awnldd2HOo6Y1fyxf9pYqtPvLWyfbbCXQOVmetqSZ5NFmHgRXccmWtNJKvBPiMsHqaxdRzVtp88reqMoA6Hcj2Jca/DSQUHnlBr2/gCMs7gUcJrfW2+YeBZ+UP48p0cH+e/3+Oyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 5:30=E2=80=AFPM Breno Leitao <leitao@debian.org> wr=
ote:
>
> On Mon, Aug 17, 2026 at 06:22:41AM +0800, Barry Song wrote:
> > On Thu, Aug 13, 2026 at 6:02=E2=80=AFPM Breno Leitao <leitao@debian.org=
> wrote:
> > >
> > > do_swap_page() returns 0 when get_swap_device() fails, which the faul=
t
> > > handler reads as "handled". For an entry that can never become valid
> > > the retry takes the same fault again, so the thread spins forever,
> > > retrying on the same fault.
> > >
> > > Return VM_FAULT_SIGBUS (Bad access) for a malformed entry (pr_err() w=
as
> > > called at get_swap_device()).
> > >
> > > Signed-off-by: Breno Leitao <leitao@debian.org>
> > > ---
> > >  mm/memory.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 7201e848129a7..fa2b3d2ad3202 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -4957,6 +4957,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> > >         /* Prevent swapoff from happening to us, and reject a bad ent=
ry. */
> > >         si =3D get_swap_device(entry);
> > >         if (IS_ERR_OR_NULL(si)) {
> > > +               /* A malformed entry never becomes valid, so don't re=
try it. */
> > > +               if (IS_ERR(si))
> > > +                       ret =3D VM_FAULT_SIGBUS;
> >
> >
> > Hi Breno,
> >
> > Since you now return VM_FAULT_SIGBUS, the page fault should no
> > longer retry repeatedly. Do we still need patch 1/3, which adds the
> > rate-limited printk?
>
> Yes, I still think we need it, for a few reasons:
>
> 1) A different bug could just as easily trigger the same message
>    flood again.
> 2) I don't see a case where flooding the log with this message
>    would help. If it keeps firing, something else is already
>    broken, and the repeated message itself adds nothing useful.
> 3) From a monitoring perspective, I'd guess 95% of our log
>    messages should be rate limited anyway, and this one would fall into
>    this category.
>
> You think this one shouldn't be ratelimited?

I=E2=80=99m fine with rate limiting. I=E2=80=99m just curious: now that you=
 return
`SIGBUS`, the PF won=E2=80=99t retry, so you shouldn=E2=80=99t get flooded =
with
printk messages, right?
Or are there still cases where returning SIGBUS won=E2=80=99t prevent the
printk flooding?

Best Regards
Barry

