Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E808CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 23:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA8CF6B0011; Fri, 12 Sep 2025 19:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E808F8E0001; Fri, 12 Sep 2025 19:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9B7E6B0011; Fri, 12 Sep 2025 19:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7E3F6B0011
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 19:32:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D8E111B092
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 23:32:22 +0000 (UTC)
X-FDA: 83882199324.07.B7249EC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id E313F4000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 23:32:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UAvHGdvz;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757719940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qeJiLUczh+jDUEzC4NUWxpIlCOTOGxO/IeLpeysMhqw=;
	b=UmuHWjIsqGYUDNOMLTQzobw77kpu6tYQiHB2CZyqr4UKmk+twpNOvqscIf++OQoCNvs3Aj
	HJMJ0Z4p+p0N4okgwV4BxCdpx0RjE2F27LU63NR9gKWDkFntaUc2cPAsJZmPrRBJSddghJ
	OEwh1Bla3kjNtpGB50oty3pLuU3k3v4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757719940; a=rsa-sha256;
	cv=none;
	b=70RPYVWA4IrUnUW9AymyYID9kQUXcV1xxOUOXN5VY41HICHESiZROXl/DoEHyyvokAftlT
	wP+XZhTwMIRGS/CQfEC9cAbUnRK3iMe25pdU5gvv7cTbGGiZebS50NM9B3Sy0nO0o3j2JP
	9FaNfDFnSAD6SgjCqpBDVl2hvahBaqw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UAvHGdvz;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757719939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qeJiLUczh+jDUEzC4NUWxpIlCOTOGxO/IeLpeysMhqw=;
	b=UAvHGdvzGEY1ZxZitzkMoIwwFXg8Ix1vIBNRuNAe2HJ6/ahZLE9EiqM6aOzdXm00yDcYgs
	mPzN4A/y/Y1GyhVuPoJW25YOxd4mmVdhTRMNrehWcxAREAf2sn0LLeUNJwXb57AyXWFe4h
	97MeXKPAfykbdafbMIhKGAW/EpQUjq0=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-EhNyUmA0OGCKSzViLqsyBg-1; Fri, 12 Sep 2025 19:32:18 -0400
X-MC-Unique: EhNyUmA0OGCKSzViLqsyBg-1
X-Mimecast-MFC-AGG-ID: EhNyUmA0OGCKSzViLqsyBg_1757719937
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-71d603c7e05so32606487b3.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:32:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719937; x=1758324737;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qeJiLUczh+jDUEzC4NUWxpIlCOTOGxO/IeLpeysMhqw=;
        b=BbyhAI0I2ODfGDQwc3f75rorAbne27wniVPySDQMPylZlEb66kGlUsyIwhf//bMTcB
         GviBCY70sCryK9Y0rySZ73Q2SMmX5cHNO5et/pYebWPew4bLxRuFMcbSXKUPBjE3Aea6
         48hjrjn3dvmHQT4vWylFUo3dwYr8yEh8zDGXfPtq2AQu6mxDRXze/PBgx9kdUt3y2a0B
         Iw2pMpwKncvA68Es53MKDTxbrgaRcm+S4RC8WiMA4Gx2cqYwXGnq1/Qof64cyVfLDbTy
         EteLZrkwdA0iq+a4zU152DTdfjo1SSe5wkRZSAf9/nb916CzQWKHe/jaIUhwDO4N65uP
         b7+g==
X-Forwarded-Encrypted: i=1; AJvYcCVHcOK3uVRkWdB987ucHJ+T1YvUufy5saFC5tFwA7BX03dSSTZJ3b1IXMKTuQ7ZOiNDyWiG4Rry1w==@kvack.org
X-Gm-Message-State: AOJu0Yxnzw1Iiv10jHCPcXxgUvKDuLH0abGA91lAvZ/fGTxlr11W8DOg
	rDRPxmMm+JOmxjlEdax9M+pru6w5uOO1N7v3ngHePq/x9bZBQajWRF6l8NDYrD3TawOYp4ib5zD
	gFlxaB+dIUSbu0LkK0uAdbOcmC8h4a1Y5k9qLOOeu+AJGehADWZIil49vfpUZf54wR2ZMCHaqVx
	RMCG69/teBLuLJsquLS32QOFF7qEA=
X-Gm-Gg: ASbGncvF4YKCxMKhVFAkBz7zZEijsbgR8u1Gc538zfoSDAHKJIYDHxwVcDZ6iSNCNWp
	lH5gjwhZlH2B4jM8Eh5NeDV6NJjSywvBih8YZij3pUqov53j0hbrgwASI7hDRuTnwFb/ZJa63Gz
	CetRohIPrgKOPwST4e9YQyBZMDdarLs/xW5ik=
X-Received: by 2002:a05:690c:6d01:b0:71f:b624:323a with SMTP id 00721157ae682-730631915bcmr48747557b3.22.1757719937520;
        Fri, 12 Sep 2025 16:32:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEK1z++fo1VlAXjdvZLZjfG0xFXeJ93pQE2PD3RXY0X2Ke9QcK3xuGmHvpnFUlHapj1cPtD8bnkIBPCoxV0I88=
X-Received: by 2002:a05:690c:6d01:b0:71f:b624:323a with SMTP id
 00721157ae682-730631915bcmr48747047b3.22.1757719937032; Fri, 12 Sep 2025
 16:32:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250912032810.197475-1-npache@redhat.com> <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
In-Reply-To: <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
From: Nico Pache <npache@redhat.com>
Date: Fri, 12 Sep 2025 17:31:51 -0600
X-Gm-Features: Ac12FXw_TS5TScQ8j1sWTJVRrVUFEA5RkwbW-1v00F8cU_6m8fECtZnnxeVB4sc
Message-ID: <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: towCs95wPhpAT1k5tK6MG08t0i2KIiT1HS48EJL4BB8_1757719937
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E313F4000A
X-Stat-Signature: iue44mimubbfdwyhnukoha34i6ixu4tr
X-Rspam-User: 
X-HE-Tag: 1757719939-216221
X-HE-Meta: U2FsdGVkX18nuRQKM5vmf4FhOs3EcJdawQ2OsKCuHZ9Deadqe7TmALyNyUabEc1ZRCUi/1i9ufeRvvF6kHSKcbzEXxnVsORrj9e5ZJibalbjQ4MmxUbHRxhdeUAqEqypSgLvV+cZ4ww4kZnstfu3J56jqaWYvS+uUEfo38jsFgmAASTQaYr8+Ws6TQntKSaVByKRTWGK7UiZF6A14mICdCuSZJJf4iGJOUjWMybUiB1VwH9VR6PaFzNajAU9r4Amsh/U0wY4E5UJMgj7E1wXxNQ6d0p53gCzdG2ZN6P+qCe7q/iEGw+ivAAHArLG3JhKQKEkAHjTNO2oSq+mdHfM9VmoR8/n+aK0w5+4GbmYXxzGHbw2GCrDDA2nPiIy0FKhbVst0KSzLhbwNmH+F4zmz7dCR2RmACJTUYrhrSKI68GRachKIJFWE2VnPz7Ws7Ve9SE1R5QOsm+eqWEiFvHbasF6v0wajVDyv943dXCS4DLspObvWQ8jV3EG2yzdPRQTWZLpUX/kwfh00HvOazYapWK62o3F8hSQrNkxySPiH72iIWqChU63YRzX6q0VX4eN4+ympXtvD5DRAyQIedImsgP33JgLTRwRXcEMvqyGo5d12xc1rpi1Xu4Tm1A9BtUZSJdD5DyhZ6DnfrpfgBJPoq4q1425iHJR/FUv8Pg5+65escmem/d2388dz0z+pMC3KbAXh6eZ5jiPhdujw6o3Fc+I/JwgFCzPKkMBATATX0QLbOHCPPnBYaGly1mIvyRJxaygb3U5trUuLGEs6vtwdE6wZPt9r2KgB7PO9SLYIEFjlR6s1rcmAZCTdOwl8qv602o3TdlpSAbZvcOAkcaXk+JgDmw82/GxRqPVOqgVPKFwQ3BX8xDEwuMCwwziQkPYHHOIqJZaagbsjZRM6z69wieEFo59gsYmyY3v0JYjcM9WshBswVAWbdsD6EuC5SJyoo94stJyXO6/C2YZIFQ
 lSKSQHdL
 gnH2ogZ1SHURQvcJuFDFKkt4ZkbX6pM7d/qnQAeJnDfEdrwtsH8Wisl8IZ3E25MNZ6wxuFH9m6gtOVxkPTZaauqo1QmH5iK3rl1Pyf5G3xU0xBkMLOWfVbNgGfp/ltJIMPDQiFV0Tqo/Fmyv9l8VrRL3x7r/NOkC1zYdZ91aHW5A6OmIUIZktynwlwerhMUgzooVKCc5ImqxkY8cdhOuvdke11cTUF9Zp+MF4E2+fyE+bZ/tmdE4qDy3tonNZneZe6rkfV3dv2diYPfzN5zmrYnv6F/7lniQNrZa76ZrybXkxu3onODLhIML0Wsopwn09V0yHusGj6H7HhHJC2JPE8JTiLa/BbFfQYAAb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 6:25=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 12.09.25 14:19, Kiryl Shutsemau wrote:
> > On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
> >> The following series provides khugepaged with the capability to collap=
se
> >> anonymous memory regions to mTHPs.
> >>
> >> To achieve this we generalize the khugepaged functions to no longer de=
pend
> >> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track indiv=
idual
> >> pages that are occupied (!none/zero). After the PMD scan is done, we d=
o
> >> binary recursion on the bitmap to find the optimal mTHP sizes for the =
PMD
> >> range. The restriction on max_ptes_none is removed during the scan, to=
 make
> >> sure we account for the whole PMD range. When no mTHP size is enabled,=
 the
> >> legacy behavior of khugepaged is maintained. max_ptes_none will be sca=
led
> >> by the attempted collapse order to determine how full a mTHP must be t=
o be
> >> eligible for the collapse to occur. If a mTHP collapse is attempted, b=
ut
> >> contains swapped out, or shared pages, we don't perform the collapse. =
It is
> >> now also possible to collapse to mTHPs without requiring the PMD THP s=
ize
> >> to be enabled.
> >>
> >> When enabling (m)THP sizes, if max_ptes_none >=3D HPAGE_PMD_NR/2 (255 =
on
> >> 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 f=
or
> >> mTHP collapses to prevent collapse "creep" behavior. This prevents
> >> constantly promoting mTHPs to the next available size, which would occ=
ur
> >> because a collapse introduces more non-zero pages that would satisfy t=
he
> >> promotion condition on subsequent scans.
> >
> > Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
> > all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.
> >
>
> I am all for not adding any more ugliness on top of all the ugliness we
> added in the past.
>
> I will soon propose deprecating that parameter in favor of something
> that makes a bit more sense.
>
> In essence, we'll likely have an "eagerness" parameter that ranges from
> 0 to 10. 10 is essentially "always collapse" and 0 "never collapse if
> not all is populated".
Hi David,

Do you have any reason for 0-10, I'm guessing these will map to
different max_ptes_none values.
I suggest 0-5, mapping to 0,32,64,128,255,511

You can take my collapse_max_ptes_none() function in this series and
rework it for the larger sysctl work you are doing.

Cheers,
-- Nico
>
> In between we will have more flexibility on how to set these values.
>
> Likely 9 will be around 50% to not even motivate the user to set
> something that does not make sense (creep).
>
> Of course, the old parameter will have to stick around in compat mode.
>
> --
> Cheers
>
> David / dhildenb
>


