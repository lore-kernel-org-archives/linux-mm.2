Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51076CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 11:13:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01B2980138; Tue, 28 Oct 2025 07:13:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35AA80131; Tue, 28 Oct 2025 07:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71E280138; Tue, 28 Oct 2025 07:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4CE080131
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 07:13:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78A23160413
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 11:13:24 +0000 (UTC)
X-FDA: 84047261928.25.A0B27AB
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf14.hostedemail.com (Postfix) with ESMTP id 00B0510000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 11:13:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=HO7joC8n;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761650002; a=rsa-sha256;
	cv=none;
	b=TtiHFHzOj6ZX2vFEfj3Pt7DBtApiSRGtAPCfNVgCyJ0KhUMgEpyQvEGSrZ2VB7LnnS3kWP
	GrRFsvnniAbP8MfziU/Bdk7gJQ9m05+UxyzOO6khOXSyD8u8MZk0nHPOI4IMvOpWFUdMtP
	VPAIezVemGEmKSiw9cf6dUndujrB194=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=HO7joC8n;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761650002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IruZ6tsBVucJWwjqgHjIbPoWLccutkeIxO4pOhVzLak=;
	b=C3OnIqqndVRzG5NMt1+VDsOTuUYFGHCk8qISTxQ+cBGqi1Aod3WhUe/CweW9Gi5k12SnLT
	WKUzlQJu73Lr2tPvfcVu+TJf7kLZHDQWW0Mv9wVTtdqzGPhMu3b/dQY4iT71149WBX4BfX
	V86Hc3ToU1bWJ5Y4oQoATB5eJK+jaw0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IruZ6tsBVucJWwjqgHjIbPoWLccutkeIxO4pOhVzLak=;
	b=HO7joC8nay2zm7gfgvo3nT4alXc9FalA+xPchBjsCjATqUI2d12omH8t3KByJQDv29FvDJP5y
	yZ5JyzoEkqFlkubOk8LCise9PxMgp5XjNoiXmtYnCE33B393RBvGAeZR0noGRtP7YRDl03NXlGz
	YP0JqVX0+6NToW2WH1J8E1c=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4cwnm01D7cz1prLt;
	Tue, 28 Oct 2025 19:12:48 +0800 (CST)
Received: from dggpemf200009.china.huawei.com (unknown [7.185.36.246])
	by mail.maildlp.com (Postfix) with ESMTPS id DDD6A180237;
	Tue, 28 Oct 2025 19:13:16 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (7.185.36.8) by
 dggpemf200009.china.huawei.com (7.185.36.246) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Oct 2025 19:13:16 +0800
Received: from dggpemf500012.china.huawei.com ([7.185.36.8]) by
 dggpemf500012.china.huawei.com ([7.185.36.8]) with mapi id 15.02.1544.011;
 Tue, 28 Oct 2025 19:13:16 +0800
From: zhangqilong <zhangqilong3@huawei.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Wangkefeng (OS Kernel Lab)"
	<wangkefeng.wang@huawei.com>, Sunnanyong <sunnanyong@huawei.com>
Subject: Re: [RFC PATCH 2/3] mm/mincore: Use can_pte_batch_count() in
 mincore_pte_range() for pte batch mincore_pte_range()
Thread-Topic: [RFC PATCH 2/3] mm/mincore: Use can_pte_batch_count() in
 mincore_pte_range() for pte batch mincore_pte_range()
Thread-Index: AdxH+5T+8zk9AGSdQ5COU3ncduDLzg==
Date: Tue, 28 Oct 2025 11:13:16 +0000
Message-ID: <29d2ad2f81b14c8384bd0a7d8d60ef62@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.174.177.115]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: erz5yhjf3zeihrqwbpuzegxddbhq6kuf
X-Rspamd-Queue-Id: 00B0510000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761650000-176039
X-HE-Meta: U2FsdGVkX1/Ns2rgexwGCfANGfTAJNkHGUOZHOYMhHHH8cxkpnAE0rWhJMoXrc53FCeUQ4yqMgqdY792CulnGebPA/iTqHaGilHs48hFWhoqpF4HK3Goe8FZfSqH3J6ev1XeRq6PMSc0l46/jcz0VDun3wnsHpCRQ+/b4339f0OTcTXY1UJSRuNU+I4Pmi5LwetI2oj+d0rps355bexjs1E0vtIOuR7EEYA65wBP8NvERS28boY/HhpLGkHC/eUBECMmaXVkZYJwoiDbYIVL7gNulRcOD5ON7lOqaY21iDD7d2F8z5JSskUSThyUK9QY6mXSGcG2ERl+mxMER2kAlsqlMCK0XocB82T4mR1+UNZ37YYuW6FNV1x4nsgy6dNfdszaBPJE2CCySokKFykE40adcZw7pIAx23qb0cd7mIXFjSxnzvBFbpVSo4QSOuQx9znXboPV19isTNikAvLww2k9s/6Lb/FqSnHWHAocW3Rip7y5PbAkEKAOJaG31u6YtNdiPmDLXCXSeB2tWJcsB1j+UdthLlRQgNmijs0LFyjXAl33FwTStdXKJVRZ1qTNJJm5SECfOd5O5GSK/8SXGnbKfyyoQV08KP2JacUoDQ7gTiRhwNeD5poYGIIfhuZMYF23RW2n65H7fUGaE0pyxQOHLhzhuswuqNmKZq/Z2Uq53hR+9gRRNY6+rAnTQSG77p5OE0NEASyXD/BNzhAO6Qv6QAwKZNXhfNJuOAMAPpBBN/zkHcLu9ieL7Hm7v/xBrWiSydmrYUV+lXRVFmo/tnSpgfWxTkn8sP1jyQ1LV55cpF3a8AsuSR/zJJSahNsZJX7wYUOpDYAkFNjoqK/tCSFDLQ2ltt+OkDVNYLKaBap2w845gh1qUI+Ke01Xi1zvB+bC993YoiCy5R2CVd3QbtlP/lLuPWSBblm71vxF9WujArLGlteFPNJXHWOA5dlcIBZ3zDmYVqaj/16nbEJ
 eWi8UYOU
 GKTIETv8gxRgctqf6BSrGq3UiysvHu7T9aR/ODwqJoH51HlO90g5Ce5GSSnlg2VHfkZrc0QUQ13fmfhjB3KTPeA+ccp2FbfnI1qBXHBveCo1v6iNZPSQu463jYvfQbMCZgJaq+cZMXtI6iLb+c3uKTtE88PQBVQ6udhaweUdEPTSH9u6xMksx8SYLMfow492P5gd8/0seRELn8YTqprEE/DK9miVR1hKsN85q5YHBZTEbysIuRfyAIOciH/CV27EKg6F59O6IjnGObkjET758C9qc8z8UdvrY8BwNTBitV++KzlXpp0WMlQuqm0VeCCsrFqoqo++DVS62M7EC9KCxZ6AZHYtkZVsMJ7EJmrSUsUjRt9PdLDm4WYE4S9NB/q/F2BjUAYvFC86NV6JhPh0Ljh93Uvz8LPR8EQGrGF+ltd8u1B0yQpiyUH+O54T3F1qYdy3CJ74KWvkIkZp2jrZlPlvKrZgEY30QWYmefGrQjleH4VIbEuRnM1oBsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

 On Mon, Oct 27, 2025 at 10:03:14PM +0800, Zhang Qilong wrote:
> > In current mincore_pte_range(), if pte_batch_hint() return one pte,
> > it's not efficient, just call new added can_pte_batch_count().
> >
> > In ARM64 qemu, with 8 CPUs, 32G memory, a simple test demo like:
> > 1. mmap 1G anon memory
> > 2. write 1G data by 4k step
> > 3. mincore the mmaped 1G memory
> > 4. get the time consumed by mincore
> >
> > Tested the following cases:
> >  - 4k, disabled all hugepage setting.
> >  - 64k mTHP, only enable 64k hugepage setting.
> >
> > Before
> >
> > Case status | Consumed time (us)  |
> > ----------------------------------|
> > 4k          | 7356                |
> > 64k mTHP    | 3670                |
> >
> > Pathed:
> >
> > Case status | Consumed time (us)  |
> > ----------------------------------|
> > 4k          | 4419                |
> > 64k mTHP    | 3061                |
> >
> > The result is evident and demonstrate a significant improvement in the
> > pte batch. While verification within a single environment may have
> > inherent randomness. there is a high probability of achieving positive
> > effects.
>=20
> Recent batch PTE series seriously regressed non-arm, so I'm afraid we can=
't
> accept any series that doesn't show statistics for _other platforms_.
>=20
> Please make sure you at least test x86-64.

OK, I will have  a  test on x86-64 as soon and it may yield unexpected resu=
lts.

>=20
> This code is very sensitive and we're not going to accept a patch like th=
is without
> _being sure_ it's ok.

Year, it's a hot path, we should be extremely cautious.

>=20
> >
> > Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> > ---
> >  mm/mincore.c | 10 +++-------
> >  1 file changed, 3 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/mincore.c b/mm/mincore.c index
> > 8ec4719370e1..2cc5d276d1cd 100644
> > --- a/mm/mincore.c
> > +++ b/mm/mincore.c
> > @@ -178,18 +178,14 @@ static int mincore_pte_range(pmd_t *pmd,
> unsigned long addr, unsigned long end,
> >  		/* We need to do cache lookup too for pte markers */
> >  		if (pte_none_mostly(pte))
> >  			__mincore_unmapped_range(addr, addr + PAGE_SIZE,
> >  						 vma, vec);
> >  		else if (pte_present(pte)) {
> > -			unsigned int batch =3D pte_batch_hint(ptep, pte);
> > -
> > -			if (batch > 1) {
> > -				unsigned int max_nr =3D (end - addr) >>
> PAGE_SHIFT;
> > -
> > -				step =3D min_t(unsigned int, batch, max_nr);
> > -			}
> > +			unsigned int max_nr =3D (end - addr) >> PAGE_SHIFT;
> >
> > +			step =3D can_pte_batch_count(vma, ptep, &pte,
> > +						   max_nr, 0);
> >  			for (i =3D 0; i < step; i++)
> >  				vec[i] =3D 1;
> >  		} else { /* pte is a swap entry */
> >  			*vec =3D mincore_swap(pte_to_swp_entry(pte), false);
> >  		}
> > --
> > 2.43.0
> >


