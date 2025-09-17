Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19DA8CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 22:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D0178E0086; Wed, 17 Sep 2025 18:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5811F8E006B; Wed, 17 Sep 2025 18:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470238E0086; Wed, 17 Sep 2025 18:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2EE5A8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:15:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 879C513B707
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:15:56 +0000 (UTC)
X-FDA: 83900150712.21.070AB83
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8FFBB1A000D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:15:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FpscpWBV;
	spf=pass (imf19.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758147354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1p4ncEV/0Oe5T32Jx5hlprtEOLrd/1ewkvxiGL3vw0c=;
	b=pfxtzhAAi59Um/o+m/L2kMs8TLjR3IwRyi/pHJodhNPLIUDX5hPnYfTJHjfCR0LXIkBJOS
	NwruKIfpubGp3wMuihq4ZFRQifteuTWXGYnnqvclNz820ex722FO2lDIHE+vb3COjFznfg
	jxPUgTDfU+ikYwy+I6tHJWhtZobBtKU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758147354; a=rsa-sha256;
	cv=none;
	b=SgIVSYoBsnLt+diIAHoKZdnFOvviOo8JDMZnx37nw6Ij+A+/Jx2H0Ca4eKayOepso37wy4
	m5QuIhXK7ZkriSXdu0wmiQTQ8wSaHt725DylVNKLm8YJtr6c5SOBu/S8AWeRmpmKaqUNI+
	Y2E8DKkDxHLcDmsoqT2CrC62EugiZaM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FpscpWBV;
	spf=pass (imf19.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45f2f894632so28005e9.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758147353; x=1758752153; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1p4ncEV/0Oe5T32Jx5hlprtEOLrd/1ewkvxiGL3vw0c=;
        b=FpscpWBVG5FXrvEsNXr34D2vjUQ0bLam5fQTlEFUOVr4285KPSe5RuRyYB1GviTknv
         jfKNzMGeErkh9AlkHfnNau0TvjTo1QZGxpyok42UwbjFl/IT/gD89NLG4HNGMwb0XYtG
         f3SwYYYtsrcK96r/0csY/QL+29uCXsz/4W2bXvwKFnDgdXB3rsVla3NmlDk2utSmbvWC
         4nB2dlynX/Bn/VwjCpG92hZV6h9rNzbvR+kOG7MMfFLU/xDq6AQK2vBxnaOUMR1d+uAt
         IcEAZnpSriYC6/uAkjAcJhlX4AJiQ+60XX6XfdjN3eXGuxegaTWd/OwVWDEECsNLtAO5
         xfiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758147353; x=1758752153;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1p4ncEV/0Oe5T32Jx5hlprtEOLrd/1ewkvxiGL3vw0c=;
        b=s699UzBVIvzAKtgFhYgIk1U9Pi8/r6Gqr5/ZH4CK+oX1/+8l/S/mnONK4eJUM3QXFU
         ip+iYUpqTznqbWsImCV5+ItuAGIHaVXtr10HqR4Br4k6E/RAw4jclFkyTEjpNVN/aZDV
         vMPXvII4VQt/FQuwAT+Zh8MXmujKekjotOVAy8uNyirtIZXgZfvcqAztrdSZh6RkfFcX
         lYR9kD/lA8kdyCuUKntYl/Qq2wFlmj7ADARpNCYme4o2gb7xFEuF7dl/3RP6LBsatfif
         C242CWwjCn1VVtyjSOyOM3Wu8XNa4FoTo61NemHDE80hyryBl1+3McxL74xXvgnoeXt+
         hslA==
X-Forwarded-Encrypted: i=1; AJvYcCVBmfxbJPznD2qiDsFTo6KL134Mu6onAa647/sOXcDltu86etft/GUP/GhGcwLarj6Gbx/AtfJkDQ==@kvack.org
X-Gm-Message-State: AOJu0Ywk0mUahsMr8Sf2pgEnx7nXgU558UK5R2fKaSwKOUsaJK/lrYXV
	g6bLSaVknn0Pz3GKWFiDwoFdJlOA7uv9lLiMlxuTHN+jGaC9+SFO4L2VB6SqsP60NPpn+h6XU+b
	So0AnEa4WV0Lv61sZsqCa+Vup5m//8wky1Ehkq4nb
X-Gm-Gg: ASbGncttVUrd07+E/hGqQXt0AEPiIrh3k9hrOIC4O04evWUYcWl5aLg9tiTBtPhw9dJ
	41xU/AlEfy2ANSYE0Y5c2u3/ym/Dz7mx58slXCgGMJx9R+VtqtRq2DkrlIlcBDM8QbjLgTLL2o1
	WBB79RQ5QmxR65u4wrhz8Tdhim6862oCRbLhjLlaIcgYneT3+pIlCz3b1vfKbiOxNZI+kwghWQ4
	5FDiuMPr8ojsQI/lGPS24hD0p8km6cABvU60aHyoo4eRsAOPbdj+7YqyDhHM7Y=
X-Google-Smtp-Source: AGHT+IETa168RMgXYCyuMbREDGOaHVmJadjLDpn2kmhrTSuNtoIw5sYpaUJCBGdkIQavpq6g1JLeI6FZ1TdA3bdskYU=
X-Received: by 2002:a05:600c:3f0e:b0:45f:2e6d:c9ee with SMTP id
 5b1f17b1804b1-4615364d0efmr2582795e9.6.1758147352822; Wed, 17 Sep 2025
 15:15:52 -0700 (PDT)
MIME-Version: 1.0
References: <aMiu_Uku6Y5ZbuhM@hpe.com> <a99eb11f-a7ac-48a3-a671-c5f0f6b5b491@arm.com>
 <8c3188da-7078-4099-973a-1d0d74db2720@redhat.com> <aMsDJ3EU1zVJ00cX@hpe.com>
 <cd71fac2-bb9d-4e84-a074-2b695654e655@redhat.com> <CACw3F52p45t3iSZPjx_Lq9kBn1ZGTDZsxk+iQ-xFA1zdvdqqrw@mail.gmail.com>
 <aMsR4Tr9ov1pfucC@agluck-desk3> <aMsqdesM1ImJp1yt@hpe.com>
In-Reply-To: <aMsqdesM1ImJp1yt@hpe.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 17 Sep 2025 15:15:41 -0700
X-Gm-Features: AS18NWB0Be2bZgwB40bum70rJy1DrSew59KlnBWueOxwtEk5FxFH7XCa5Jb7Kdo
Message-ID: <CACw3F51w=HfA1no7BqpaKX4ta+O6KAwp8NnRMdePc7wFW1yQmA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
To: Kyle Meyer <kyle.meyer@hpe.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, David Hildenbrand <david@redhat.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, akpm@linux-foundation.org, corbet@lwn.net, 
	linmiaohe@huawei.com, shuah@kernel.org, jane.chu@oracle.com, 
	Liam.Howlett@oracle.com, bp@alien8.de, hannes@cmpxchg.org, jack@suse.cz, 
	joel.granados@kernel.org, laoar.shao@gmail.com, lorenzo.stoakes@oracle.com, 
	mclapinski@google.com, mhocko@suse.com, nao.horiguchi@gmail.com, 
	osalvador@suse.de, rafael.j.wysocki@intel.com, rppt@kernel.org, 
	russ.anderson@hpe.com, shawn.fan@intel.com, surenb@google.com, vbabka@suse.cz, 
	linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8FFBB1A000D
X-Stat-Signature: rqxyobmjcefrstpooiqj1ajexj6p3qxg
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758147354-958818
X-HE-Meta: U2FsdGVkX18RWQ0i1m7rb6RPzKiKq6NvwqmtHx+9zGT5TrahhW/NMCAEdSTUwZF2KHjYYzWNx3B4cIw8k9V2qLGH+293kKP3f7K6ZFILUGdU+M+lT3i86ReCGDH6c7/9c7jVZ/Gw6vjkCyrIYqe/2k77Nt5J3XeuxiHKEhzupzUISQLwvkgpW5dl4dIQGf2V7+Zx1zlvHFuK5BEvEqwYBdswKvlW2toOgr0lSiAhuyytXanfeMfFgJJ8ychiWyV9CVG/JZDbcCOhikfvJGkL4zsRETY3Z3DNHR/G7urCbtG2+1CCC4vDWA2upv1ulKPzkidQfG+xkEmZYHLaPWzjA8v/FieVgNQq53hW0Xt1C+lFHgjzc5Tc3PKpf40n7JD6QPCqbC1Nyp5KUIbUP2SBTNpAqX/WANb76U84fOL0AYxmlWZZCWXb200utGoTk94lzznACl2SZmTpJFO1O8pIU5mESgOXlueYD4pMZRna3m6Lb4olBR0cq6VpgiTHT1xZsGrbx+i5ZXqp/EgvVlGGXKyvjZBvASMWsVPHrfbLwR4YPNqZnlbD/gbLa03rxfEAC6WbDYZa4KGxFNZ/1NGdNgzTSjbqS98o3xSC7mlESc93otrd3kLMU0soWQ1eiSCbh4oyMA5pf8C9eig3ooAP7HwvnC59JG7nFuTNZF6Xx5y3XtxMNWG/GkMZqfttHpNwTEiCSL+qcyddCggUAGZBMNpu/ZqN5Psl2syAw8zpZdT1WkAnTMfOmoSZX9jBlHs3/vEuqoiwU4jwzrr0ww8o6lR11LDdMuFb5GDizubk4RXupK3BZ1/RIl+IoEsVqfOB/q6aOxE0k+A6WGrAD7IFO0KTusBFTENb1C5ok/8LHPi+RH8ai/3IQTv/Pvkz+499LtwE2lRq9diDW7ojJiiWBf9HbhPRch+WcE8DgleW5L7IvvrpQe88xFwVFuFljmrV2G+DUdl2bPPylpgD3fj
 KMNU8K1B
 u+RcBl2nI9CKDi9R8HTvyC+w3dEocCVAdffqPAUqFUC1fcFJGdgPBzUigKFcJ1lY6SSAIDNk4K2UsJgadmEMKaHz5tbRk37+w/HLYagfi/rDUjpKqlvhHqGC4JvBEe/z1CufQSZdaeGnLTkY+CZ23a5XrUlT4+FuSRoMYsiZsr/FzgmeS0XsianMVp0eeXwMb9ztzuQWaj3aR7/cdzTfo2IXk/VX+vBLi2Oub6CgFzAvHx3KjOJ7SnH0/50xFxtOqj/afKDlkIgJgvAHq7qFGG4/Hlf9eFLFsSRQO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 2:39=E2=80=AFPM Kyle Meyer <kyle.meyer@hpe.com> wro=
te:
>
> On Wed, Sep 17, 2025 at 12:54:09PM -0700, Luck, Tony wrote:
> > On Wed, Sep 17, 2025 at 12:32:47PM -0700, Jiaqi Yan wrote:
> > > +1. Given /proc/sys/vm/enable_soft_offline is extensible, I would
> > > prefer a compact userspace API.
> > >
> > > > would create a new file, and the file has weird semantics such that=
 it
> > > > has no meaning when enable_soft_offline=3D0.
> >
> > So the expand the bitmask idea from earlier in this thread?
> >
> > Bit0  0 =3D soft offline disabled. 1 =3D Enabled (but see other bits)
> > Bit1  0 =3D allow offline of 4K pages, 1 =3D suppress 4K offline
> > Bit2  0 =3D allow offline of hugetlb, 1 =3D suppress hugetlb offline
> > Bit3  0 =3D allow breakup of transparent huge pages to just offline 4K,=
 1 =3D suppress transparent breakup
> > Bit4+ Reserved for suppressing other page types we invent in the future
> >
> > Values 0 and 1 keep their original meaning.
> >
> > Value 5 means: offline 4K, keep hugetlb, breakup transparent huge pages=
.
>
> Do you happen to have any use cases or reasoning for why someone might wa=
nt
> to disable soft offline for 4K pages or transparent huge pages? I'd like =
to
> understand the motivation for adding the extra bits.

Not sure if making sense, but something I can think of are: one may
really not want performance impact as THP will be split, THP and 4K
pages will be migrated, and even wildly willing to defragment with 4K
pages with corrected errors?

>
> Thanks,
> Kyle Meyer

