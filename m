Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAD58E9A02C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 02:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1C96B0089; Wed, 18 Feb 2026 21:11:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D45596B0093; Wed, 18 Feb 2026 21:11:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26B06B0098; Wed, 18 Feb 2026 21:11:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AE7046B0089
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:11:21 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5DD091B4F25
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:11:21 +0000 (UTC)
X-FDA: 84459579162.30.F5EB0E8
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 69C3E40006
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:11:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E+cntsYM;
	spf=pass (imf11.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771467079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B8r7Xu03hD1NsQgpLSgThmDByITnvPYiHoa09ETtWrs=;
	b=ynx8K7Rnmm9KtFJXVZVi06089EVvkDXlf3MsAanmCOgygPgA+HdSjCoXzvo1vVlJy/BM9u
	gAMmUu3D31/EB++hw1cm28UO9Z+h1BHcKxg3IHh5nKOc46yKAxzJvPZV59R8p9DlkyPiEI
	cOSYzAbX++0Go/tlLq27BcrlI8CgbOc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E+cntsYM;
	spf=pass (imf11.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771467079; a=rsa-sha256;
	cv=pass;
	b=T2lR/r5eL1/I7tX+c420vlETWgAPQy3GqBen6bWeAqY9GZErDBilTmsIZb5JNbgkd/j7Do
	wD0528wF8Bg1AFjBG1lEHVykU+3V2Nirl3zsIgzKN9leWvIdUC3UjKazfSIlGvZZc68mU/
	Sqv8inKY3DeYNb+pAHamNEENQtK9s+k=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-649d4c77a32so365675d50.2
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 18:11:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771467078; cv=none;
        d=google.com; s=arc-20240605;
        b=MZgNQ8erV8OGXMRYbC+WBOGEpDzRDy+Rw+eSSu5+lwO0Ycg9lq7vPDQnZKonwmiU5k
         AjLWBK1JyBTjw8MvGXAU9dzna0epE9Dp8QDmycYcrbepQuzTNFcujUz9NzI3V8iYtwdh
         mqZRUJ+ulUt4urslbX2fV2vdkenHH39NvuCGQF+1FPSvpIz7O0nB4tfroiFM7vw2LDSA
         4kquiNY4JpMTkrsLxeE+p3YuhIliL+LLIuRJNZHObUZfhYMUbiAPrsdLCkaxUA2OzqR3
         /WD/Gchsy4hQfZFoZpXDAbBQyZCs7+LyMqPC5/nYVoMFsNXfS0S1xaeZ3iC9CLIcRCxC
         Ho+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B8r7Xu03hD1NsQgpLSgThmDByITnvPYiHoa09ETtWrs=;
        fh=UT2gvVetxrw0jdboKiSzQzKmF9sYLZozBL8ffkRLhJM=;
        b=kIhtb0lTR+lHrxxJ7n+gmDjr4j46HOB8BbXTXVGtHYCBIaAP7kl8qnAWvkY1LnT3iw
         aiCtWxtY3+IyZk5ZNVhNJxMC0KJ31f7+WQR3S/W6YAIRZ26zn06cSE0AGpm1uD34gsdc
         Z8ACPvbMc4Vqr88BrArc8ZR9re/MBjA9EByJWrR+M7j6Nenk9vcncBidQyiucRXZXa8d
         Nwb5M/lACuK9yNC5hvw7kpxhqfHa7OLnT+5w3NBB7DJs+lvYmSAIwGgAolRqykAXLTyR
         uLmwMbCf7O+rn6WtQ6qS13UF6eIBVepalu6wEifZQGfLKvWpWd/Bk1HhVEWUXNWV+6TQ
         UsyQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771467078; x=1772071878; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B8r7Xu03hD1NsQgpLSgThmDByITnvPYiHoa09ETtWrs=;
        b=E+cntsYMBppv3Kkq1Uf4Ryo5w+YZSnd1ZQ0pMFG5pAa57uf7VjuZqF+IwORMO8Enfc
         JZY9o9QMaiXni5IA6GqL0anHYUaojV1vQQ39FxxOQwMf03jDjCHApx9yikmBuO3OiPzv
         58rJ5i8TxbjcRqGN3KTxd0fFUu1ukObeva9MalmO8U/WmGiow8hQdptPAGBSw8fEk3ds
         94xyDq1R6dK70k/eXxgbf8N3BQ2zS9gpcSPcekuTgtrZYgp1YNVOpHr9+cLOWZ2tTZSR
         WHTsVx3sk3OYy8JT+ovEbZlDeXrZFnP4VPLcThGwg15ducRN5xMGNtGLKla2r9HLD/97
         K53w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771467078; x=1772071878;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B8r7Xu03hD1NsQgpLSgThmDByITnvPYiHoa09ETtWrs=;
        b=rmd0juImlSibbt6OnH59g2pF97sgWmZdcTyx6hBBJJT+UsEMPcI/P2UCAuZrgxs2Ip
         jJiXOfEH4S4FVrCxo3leKyvHoBeqgqasT9lu83hyo0gyUkdi73ZWd9rsmnouGGmeLF3S
         7Lkt47KTKkex4l4DMXotu/rndDmmUCzKvQiWmaJF7oYnsWvVNv2z5F27+fo5Unqn+Md1
         uXb5FE0r87H3c8cn01bmSPDwXcy2oMtq+FCvC4oj1PZ1o+a8nuKpLIQNLiV3eIUfk4W/
         IQeLSxPQS4eCFwMdkU00RM60QKRlZ3z4NoGhkElLhx7KH7LP8lsbUFNpay9imeP2TuZo
         ePfg==
X-Forwarded-Encrypted: i=1; AJvYcCUJrTwXYXaOoE7clsBrJrL5EQvIHeniRyXgkX3dhsRlcTDVhf+vYvvyiN0zwzjTLDmoeBXrcLJDJA==@kvack.org
X-Gm-Message-State: AOJu0Yz4iJMTbauEIAyYbJgwInhvs/o4WTqYX1Iv27Btp2Uxn9+kQWU8
	FMe7APCVXnf9ko9x6hLHxVwZA4y814M4dIu/kwdXpsvHqGmIKZgr7zPr9Y3UpjZtOdscp0ft6JL
	dl5iYqJlJcmW2bEUpySq6+NuXUz1Fmuc=
X-Gm-Gg: AZuq6aJ0WeorlzWkf/KAU6bQJA29JBsI5CMm3xBvS1WY8WGMg0ypwOpII7EIxYrdH4X
	lASedz5j1v+RvPsDSpZQnDtxwqsdgA26sMLRxIWKOgW5ymU9y0pEIvj+1lM78S6xVejPXcqbdfL
	akIcqokX2A7RmRhWKJ/93d8zxKGy62OoeK+LjwLRNpZM7woE3nhwPIL0Fsnti6uWrvgVb0Mi9TN
	my+ivI9GhQR3AKPMc/WAsjFEH/Le+Dj4nFIw8uTDcMnTltvxDYlLQCy7TbuTuiVBL1nPuUAvOu1
	mhdtgJO1
X-Received: by 2002:a05:690e:134a:b0:649:b4cd:b539 with SMTP id
 956f58d0204a3-64c198c9bc3mr15236808d50.35.1771467078197; Wed, 18 Feb 2026
 18:11:18 -0800 (PST)
MIME-Version: 1.0
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
 <CAOptpSP1zx1akeGkZEuPBx1Fk8uz8rs4_m5c55GwPUROmCGxKg@mail.gmail.com>
 <419053a2-9784-4051-b73e-5871d3c32be9@kernel.org> <aZTgnAkXecRPUGxs@thinkstation>
In-Reply-To: <aZTgnAkXecRPUGxs@thinkstation>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Thu, 19 Feb 2026 10:11:07 +0800
X-Gm-Features: AaiRm52qIpRcacCTSfAPR_s5-blPIeEG_FW8lpccSWLKjsU94iBmWgO4MtLy71I
Message-ID: <CAOptpSNhZTVS4b=xK39QocT8-4Uyj=P6xfkq=Pt0HTbZ0vaKnw@mail.gmail.com>
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous pages
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ta8ccou666ibnfgjpn57581qygabcsx7
X-Rspam-User: 
X-Rspamd-Queue-Id: 69C3E40006
X-Rspamd-Server: rspam01
X-HE-Tag: 1771467079-146004
X-HE-Meta: U2FsdGVkX188FvUH2V/wBeASfbFLxZdehCOBolPNNcYX5vCgoB1G8EI5v2Ulqe1Gcg2oBfnIsPStfe0RI3RoIxdG/Xw/oytw4IUZKDpC9dYMT8lX7lK4l5P6oPYV3CKb5W/Det8KLJiKDCfmUUz1tUu+vhHeCtdk+0bKLZLHwK7XeioHSRvMKcZCcnpHLbJHbXvITLvR+wj7dlchpt0Uxz92A8H8DCjHrZib2MZ1sReryT5trnIx4ewhv+w9ONsfa08J+I9O7gAUx6Or4fDNJ3azAhJZpgUbx2eYzFfIyQUhBK7dNKggHI62aazJ4jP/LN6oFsIW3aq0fF83OFz+iBjdKMGjKeHGP0sIu2fDBvuny/GH7rIsIAhzDCRxJ+XBG/98byC9idNR/NgskgI40JYHxXIRSMbxdxVnj+hbNJzXWXu+UVAdZeaQ1HRGa1/C0ROp0HCL68cym9lyEim3ifLm+VSjzrNEmImeivRmYqqjvQVlYAnN9GcgMRnsP/SVG+2lVc8Li7ZURxPqV5yBzs9FQhZfKvpRFDrhSbch+FVKYODvZx7ZHfs1p0HE+IehEYPxCeKoBLn2MFwxDHL3XiW8iYaEkATsWHMnPKSb+uFDB0fIu9CycLqjCyvXTm4pq4AbrCohC1nuZ+HTHlSu8+YOt79YUff4yuTospgXTpevwybtIAGKTXScV/fl+qjbO0vCK/70hLKx8d2BVqLFS343cuzcsq8PllgzQFJti3a3u557Tj/jqsfHprJemhuB9bwlkjk91xPigqFcy5yvyjhCFHGSdGny62+jLyX0wgLqjq+O0OStgibHfOAMxNZysCKTHopcIpKvMQ7IOHLTZWvFJmb8jHT5K7r5mMVif7yUrFhtn9b5VYO7wHmT4aYHVie/HbGRkcFJJg0KH0pDHv0qKO+GizpQuBnbqYvZZFyp/hkj1lXcqM+2QsjBMoaWVjRfBY6vAJh4Ym1QZs9
 XHbv1beR
 7RT470Me2iDEIaZK2eJo1QNj23rq94UmUUw055oqhlggRkcsVPyNS67rhNLqwM3UoE0oBLdVlaIxU396TJI9jiEXZENKLUDtw5LWDNHRFR01ijEFvCVMaKTfBWD/HiteTbCOGC7ZU7rpo6TBNMZrlOB3jLh5AGP3C3sJDPfpoaDstvyJtgfAVVkS3/tSodnZcU3UoPKII+9I5O2pGTLLVGmG388AU/RLP9ivc+HzfM9IP0hmcMra71IP7VFzzt8JtwHdr1cvlw2u7Mnoi9aFQoj+KMDAMC/mIwgt9pe5G9pA6iFUqYGTQdCCmIlZD/Eux6J+tYnwULNoEG0E4wLBCsWRpNWVihWbsJCHjrSRt1lIkoj5ZNFVja37WYffslCA5dLeZoDB6gxiomEPHd770oPkSNLooKLsQmpnd2Z4Qqv5BlquldhS1mlHwCtBGlzZQ8+kk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 5:53=E2=80=AFAM Kiryl Shutsemau <kas@kernel.org> wr=
ote:
>
> On Tue, Feb 17, 2026 at 09:29:02PM +0100, David Hildenbrand (Arm) wrote:
> > On 2/17/26 16:22, Wenchao Hao wrote:
> > > On Sat, Feb 14, 2026 at 4:45=E2=80=AFPM Wenchao Hao <haowenchao22@gma=
il.com> wrote:
> > > >
> > > > Add kernel command line option "count_zero_page" to track anonymous=
 pages
> > > > have been allocated and mapped to userspace but zero-filled.
> > > >
> > > > This feature is mainly used to debug large folio mechanism, which
> > > > pre-allocates and map more pages than actually needed, leading to m=
emory
> > > > waste from unaccessed pages.
> > > >
> > > > Export the result in /proc/pid/smaps as "AnonZero" field.
> > > >
> > > > Link: https://lore.kernel.org/linux-mm/20260210043456.2137482-1-hao=
wenchao22@gmail.com/
> > >
> > > Sorry for the late reply. We are now on Chinese New Year holiday, so.=
..
> > >
> > > The original goal of this patch is to measure memory waste from anony=
mous
> > > THPs - pages pre-allocated on fault but never accessed.
> > >
> > > On memory-sensitive devices like mobile phones, this helps us make be=
tter
> > > decisions about when and how to enable THP. I think this is useful fo=
r
> > > guiding THP policies, even as a debugging feature.
> > >
> > > Let me summarize the discussion so far:
> > > - Matthew Wilcox questioned the value and raised concerns fork but ha=
ven't
> > >    exec path
> > > - Michal Hocko criticized the inefficiency of scanning zero-filled pa=
ges.
> > > - Kiryl Shutsemau prefers a system-call-based interface.
> > > - David Hildenbrand acknowledged the value and suggested implementati=
on
> > >    improvements.
> > > Please correct me if I missed or misrepresented anything.
> > >
> > > I suggest we first agree whether this functionality is useful for ups=
tream,
> > > before discussing implementation details.
> > >
> > > Reasons why this should go upstream from me:
> > >
> > > - Anonymous THP can introduce real memory waste, but we currently hav=
e no
> > >    good way to measure it.
> > > - With accurate metrics, we can make better THP policy: disable for
> > >    low-utilization cases, or early-unmap to relieve memory pressure a=
nd so
> > >    on. This is especially valuable for mobile/embedded devices.
> > >
> > > Possible implementations:
> > >
> > > 1. A new smaps counter (default-off) to count zero-filled pages.
> > > 2. A new madvise command like MADV_GET_ZEROPAGE
> > > 3. A dedicated system call
> >
> > I understand Kiyls point about smaps providing too much information use=
rs
> > might not be interested in already. So sorting that out might provide a=
 real
> > benefit to other users that are only interested in specific stats (e.g.=
,
> > Rss).
>
> You can also limit the range of virtual address space you want to look
> at.
>
> > Providing a system call where one can specify/filter in theory sounds l=
ike a
> > good idea. A syscall implies that one has to write a tool to obtain the=
se
> > metrics.
> >
> > The nice thing about smaps/smaps_rollup is that it can be easily consum=
ed on
> > any system while debugging.
> >
> > I wonder if there could be a way to achieve something similar with a fi=
le.
> > Likely not, but maybe someone reading along can surprise me :)
>
> I guess you can open a file write to it what you want to get and then
> read. It is awkward from shell to keep file descriptor around, but doable=
.
>

That approach doesn=E2=80=99t seem very elegant and could be rather complex=
.
In practice, we might need to analyze multiple processes simultaneously,
which would be quite difficult to implement.

> > Otherwise we'd have to go with a tool.
>
> A tool might be more ergonomic.
>
> To minimize friction, it would be nice to put the tool into util-linux
> (or whatever trendy Rust-rewrite called), so it would find its way to
> every machine. Eventually.
>

At the moment, we have two possible implementation approaches:

One is to extend smaps, with a dynamic toggle to count zero=E2=80=91filled =
pages
only when explicitly enabled, so we avoid introducing unnecessary overhead
by default.
A potential downside of smaps is its relatively low information density, as
it may include data users are not interested in.
While in my view, the rich information from smaps is still very helpful for
memory analysis. For example, when a process shows large memory
fluctuations under certain scenarios, smaps snapshots can help us
investigate the root cause.

The other approach is to introduce a new system call, which could then be
packaged into a standard tool. This would allow higher information density
and filter out redundant data compared to smaps.

But so far we have been focusing on implementation details. I believe the
higher priority question is whether upstream actually needs this kind of
functionality.

I don=E2=80=99t want to waste community time and resources discussing somet=
hing
the mainline does not consider valuable. I=E2=80=99d appreciate hearing eve=
ryone=E2=80=99s
thoughts on this.

Thanks.

> --
>   Kiryl Shutsemau / Kirill A. Shutemov

