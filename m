Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 844E1CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 21:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98E38E0007; Fri, 12 Sep 2025 17:32:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D48098E0002; Fri, 12 Sep 2025 17:32:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0FB98E0007; Fri, 12 Sep 2025 17:32:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB0BD8E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:32:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A3171A09C9
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:32:02 +0000 (UTC)
X-FDA: 83881896084.30.441470D
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7284DC000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:32:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kHoWlP7u;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757712720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nB05rLXKMtPtZrh57BZDQzQHznNp2IGoQ+Wq3Ewi4RQ=;
	b=pMIMWrnunMvtkv4+3I7QkksVBwQX/KReyyn/QWPlYAWFHJIqboaQaKUR4ecKtf0e4CA54b
	CyF+iS3iQL23kLlVlz2fjbOKX9Ub5FmTnCXQl0ybXe98dH1y4FENWnGEYrui4bxVoPCrlG
	fDOP6595Da78eDykqC1+hwgnEUF875k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kHoWlP7u;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757712720; a=rsa-sha256;
	cv=none;
	b=QCnn09R64pWQe+fR3x1mGR2zu6WdQDJRy8GiZccbepnbSU/vjOxeLoromreXKiGeGJNS50
	ajGRHxh8s5yGRoL2SYWP/PS24P1yiN5fVLB5jZXGuv2ymEMZBqIL1W6AHg+m0xvXa7HwTO
	tBw2oVoL5OSkzbGO1esbq4as641g8Ek=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3e2055ce973so1347317f8f.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757712719; x=1758317519; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nB05rLXKMtPtZrh57BZDQzQHznNp2IGoQ+Wq3Ewi4RQ=;
        b=kHoWlP7uDbQ9+UpUAeYz9l3SKtT8tS1VIh2hxecfdnu1w/eP4v2LP3tiE4yK9DuWuT
         sQB5tkPkdi7MP4Yjq5o/XdptDg1qeEMtazxeg+tZnrnBo60nCGvMYiqXOcXc3MrPpvyq
         X0oYjSdYqLoRk7niNktw9qvv6TgsGJk+cyYVTF265J1CHQB+P7cr3SVaHGQ4SiGeiWLj
         E4QdH6gJYAmg5n/0c8AtTtdSnMXtf+odEXYF5/X2gL2hIWOqW3GqVjGDAWl9jcJHUxff
         g8k4NTAC13/eMa3yOLX4BJmjiJaRm2lFSyiynzpl43T9E5T4UNAoP09relXoBmsuUsX4
         23MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757712719; x=1758317519;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nB05rLXKMtPtZrh57BZDQzQHznNp2IGoQ+Wq3Ewi4RQ=;
        b=qSkMPeSIOQIJ84L+ZIvO/AaCNlfNk0GfXaCetATjoIsmsIfjufhzNut/E4fXbgk6Sm
         fZlDr+lCQYd0zukrfNig6qQvonDNNCoRsh/CskqykdaqwyHksnKEMoTe1IYum8qJPVR0
         Gac1qAilv2WLSuFLWxR3pc0WCW3FeNYEiAGw1cU1uLoBqLXz/l+OcevPWe1APCyYvk1a
         KWssA1wors7kCN48riwstOkurE9f3q/84arh7bwFScXYU1kzgmnasSFGJ9nt+SUMRm4b
         KqSYiifEEd9NLkddxGc+yBrIyuKbr3RJT5AfSImJUuF/TyGaqk4ZIkNqL+hIa0/1YYhU
         G1Rg==
X-Forwarded-Encrypted: i=1; AJvYcCWyfpb6CaJICJSIwXxLFIm9DJqWClwUsP4N8yG/PcrdwupUuRRN/uwQHufcEKd9dbr1iLjoB6aDOA==@kvack.org
X-Gm-Message-State: AOJu0YwQMn2XcJYePJ3m97vQauuH8SNumv4fW/S6q6ohesoDl1PDyOqt
	ZpKZCYmV6A2N6+azic4HK7oFy9ImNm/z0u5cb6sN0J3G96EOuIXXjMt965KPAN5cHmucMINsXPb
	SNnJrotmG1jIwJ6MfFEfRH1mbbOa5CiE=
X-Gm-Gg: ASbGncuHw893m6nPjpjKTr7+cg/1lC1wfCWzuEsJVNE5wEopSngLBuxP9LtPTNuYv3D
	ZKLRM36wgMOguSXNsvHKNlTlPTo34tpZ/yCh1/tdSLTRj/Yrddc4xf0kxw4NZyxYo3XIW9IvdK0
	2KgrgTyJ9+9WZ8bpNhjy52JSd5VOyEtjx4XfCQbIdGaI/3AcqCuUWmtMwIupeLbajV+Y2VbC+QS
	nmJyYSldW8cV+IPgjYx9bNEag6vVkbc8T+3vFbVNd8kPDs=
X-Google-Smtp-Source: AGHT+IFUeMgQlf6fs6AORCntODMfu50pN2Us9+9v0ugPeBxALcefvSOo8Yzbnfmg1F1+efgTkLrMfu+7draX1MoM4pE=
X-Received: by 2002:a05:6000:250f:b0:3da:936b:95cf with SMTP id
 ffacd0b85a97d-3e7657a93b4mr4693306f8f.28.1757712718670; Fri, 12 Sep 2025
 14:31:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-6-alexei.starovoitov@gmail.com> <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
 <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
 <CAADnVQJu-mU-Px0FvHqZdTTP+x8ROTXaqHKSXdeS7Gc4LV9zsQ@mail.gmail.com> <shfysi62hb5g7lo44mw4htwxdsdljcp3usu2wvsjpd2a57vvid@tuhj63dixxpn>
In-Reply-To: <shfysi62hb5g7lo44mw4htwxdsdljcp3usu2wvsjpd2a57vvid@tuhj63dixxpn>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 12 Sep 2025 14:31:47 -0700
X-Gm-Features: AS18NWBW02h4cDWcOcjmf4PsYlNoMq0It-ylsFAZRRDqbaTi-aURNC-GRbMFqCw
Message-ID: <CAADnVQ+eD7p4i0B9Q2T-OS_n=AqcrrvYZGY57QOOqKEof6SkDQ@mail.gmail.com>
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Michal Hocko <mhocko@suse.com>, Sebastian Sewior <bigeasy@linutronix.de>, 
	Andrii Nakryiko <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7284DC000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: i8d9hwwa8rfif3kroyfnyksdatibuu6n
X-HE-Tag: 1757712720-424072
X-HE-Meta: U2FsdGVkX1+mxZVukocgNEYEu4N9Ve4euroDtwf1hZhx3+CkbCaOlSLmH0RCv4RyDOxnpXkXBA23ufPcubcFIo6fOArwCjZWYB0o/AYTdW2vOR7kzXPGBxnt73uw6jncEclyzSxb5xz1lWRwNAUkmnuHpgCuNbhwGydtjI6wwSbpKhMbiM6vcWmjUeToG5TUJJHutNzaHTRYI86YFiNGvmwut1bkNJoeH5oSSRF2heEHp6Xos6tu1zGaj0rjA78v2AnTVPbEmfBb0K5kg9fqRpzOZulpm2s4+uOywcrV1DQZ1Bw/ubKuOr9ej3ZdtCDOkOfgtkL47Uuukpq6loPBO31eV+LEqITcT59O55xU0l5dzWlQ2Ty5agOk63uKYEC4bQ0xQeoYHRsts4TiGrZ0cxb3LdRaN+XuJdq2xFeZc2w8EKy/qPg6lpEO7fjGSUjylNOIi1Fynf/rrcErwVnJgZNTGdPPEcLZUQ9ZjLt0lB0EviO6C1aWE9LDCZwtpM3QooDymL81j0hnMPLmm2/O2GKLboRICCUX508/veI+PeO5MXiX/2HEmvBpg6rEaQPW4Guanu3Sp8emwLAdF7ccHtEDbzdHdLC2+vJQaOfr2L6lODEcHepc7j8vKkiRh8Nr38J741QZwSHr6CWMSgdIWHXIVZGNQi6W2fPvh9ikjhzEtxfMPYsmYEeXnx2wE7MKsbuin3Jc2WwDihMGDjdpVDJO+6M+VbCj52+v/FvXZ1xn3FhXkWAz8eaZVdeBTcIFQQ+N5wa6BVfF4kybHN+prh16ugNqQTc5xBrHw44Y9AOziek83tE4fj38sbXmhoWnnjXEIQs7XYDqfeV+2lqa0cdCVe1B7q9CJvZ0+uifxhyI0Zp/HS3CY/ZhoOmt3QsHUBw9HloUWUE0m+1wRMeNBWRGIzuxjSn7QMd7rfHS1aXMM5GizUd6ngaH/vIYQzSVAuO3nPjg5f0SXM6Thsc
 4Pd1eOJI
 iRnnZqVCFxHBkx6envmp50j/dT1IFLgW6h3EZq4yHgX1En6vbNyRYQB4K5wgz04bkD4z4Mo8/6Y2gpRfTHvZI0N2zu6wywsFoMIlqkg0q20WB/YuRL0NkUnA6nJlV4IQBQ85c7cxRyWg/8iy8GZ6SQBIC/e0lyzVN/VKN1Rt+mXbwqoDNIos9FbU6qIRpoycvb/+ChyZ3HBPEufjjlmGPWx/fvXizu03yo7ASLiLXe4+vSJiccI2SQmXBZYx05J6n74peKXGYLsfYYwV2DcJztVwH5MqPuM8yvP4U8op55qp2CXsTiVZqc2aufmFPEEHvCocYdbR/VvRRpgDWRZ0PdA/hBBm6ipXL+4wp8qYNV/dPfQDKzJe+NjOYszTt2ljgDriB0JvqRj3prP6uoCMtVbQF7sxjL0nvhWjW+o1dR1jmaeKNsn/3ekLeMuQE7FlPKsMTOLVCJXOxugrfQFrfPOq3EmyRpv3sYR3cVI6j3O8OU9k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 2:29=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Fri, Sep 12, 2025 at 02:24:26PM -0700, Alexei Starovoitov wrote:
> > On Fri, Sep 12, 2025 at 2:03=E2=80=AFPM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> > >
> > > On Fri, Sep 12, 2025 at 12:27=E2=80=AFPM Shakeel Butt <shakeel.butt@l=
inux.dev> wrote:
> > > >
> > > > +Suren, Roman
> > > >
> > > > On Mon, Sep 08, 2025 at 06:00:06PM -0700, Alexei Starovoitov wrote:
> > > > > From: Alexei Starovoitov <ast@kernel.org>
> > > > >
> > > > > Since the combination of valid upper bits in slab->obj_exts with
> > > > > OBJEXTS_ALLOC_FAIL bit can never happen,
> > > > > use OBJEXTS_ALLOC_FAIL =3D=3D (1ull << 0) as a magic sentinel
> > > > > instead of (1ull << 2) to free up bit 2.
> > > > >
> > > > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > >
> > > > Are we low on bits that we need to do this or is this good to have
> > > > optimization but not required?
> > >
> > > That's a good question. After this change MEMCG_DATA_OBJEXTS and
> > > OBJEXTS_ALLOC_FAIL will have the same value and they are used with th=
e
> > > same field (page->memcg_data and slab->obj_exts are aliases). Even if
> > > page_memcg_data_flags can never be used for slab pages I think
> > > overlapping these bits is not a good idea and creates additional
> > > risks. Unless there is a good reason to do this I would advise agains=
t
> > > it.
> >
> > Completely disagree. You both missed the long discussion
> > during v4. The other alternative was to increase alignment
> > and waste memory. Saving the bit is obviously cleaner.
> > The next patch is using the saved bit.
>
> I will check out that discussion and it would be good to summarize that
> in the commit message.

Disgaree. It's not a job of a small commit to summarize all options
that were discussed on the list. That's what the cover letter is for
and there there are links to all previous threads.

