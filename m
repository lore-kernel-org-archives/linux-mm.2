Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C057CD0C852
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 11:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 253796B0005; Tue, 13 Jan 2026 06:11:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235336B0089; Tue, 13 Jan 2026 06:11:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10A226B008A; Tue, 13 Jan 2026 06:11:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F3B016B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:11:13 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A1EECD0A0F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:11:13 +0000 (UTC)
X-FDA: 84326674026.12.0CEAB18
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id A68E72000B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:11:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Jukihy5t;
	spf=pass (imf13.hostedemail.com: domain of smostafa@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768302671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KDqRWolsacePh3UOFidtjakTxzNfCPsnv6damvWujAo=;
	b=GjiEMOowgJzxy8n6B4Auexn21vjUPkylDBowOrkQBU/BQXT+/ZQT1AbXSraXFk/H7kJe8f
	ktP/TpcbjICLV23mYG5myr+MaDFJmxPAlGdBbYINKEHFe0wuLBonBUVLvc12OuSHC+Xqv6
	IcUwjwLERlYS581W/NWBbqrpOnJkcCM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Jukihy5t;
	spf=pass (imf13.hostedemail.com: domain of smostafa@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768302671; a=rsa-sha256;
	cv=pass;
	b=QIaC4oU5P8lSUxhU7kfYDIVKDUBR9ke9W9cst3+ZrmAVv9+ksw0SVBX/Asg+16fDrb/b6e
	WJa3jM/j8s/Se3vN9O7F8An8UjHUc+E4b175qPI66JzoEg6n7IBKYr0Ya+YCeWVqd6sTaL
	QFjQpCl94ss4dN4N8vS8PCfNJbEv8TU=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64baa44df99so8083a12.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:11:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768302670; cv=none;
        d=google.com; s=arc-20240605;
        b=BEJy5LSSXhuKJx520uqN2hFxe3AOukdjpn5h7cGM2bOxSg9xfZoLsyM3hIT4xp8Qqs
         XEEfhxRz5c8nekejjjVuoCFiuhKhltFr/T3vtV0QW915sfx1DfcvKCETyjGsT1BF2MuA
         rIZ7XV6g6h4FABVPoJ2UY4UQJp18rAXiB+m/hWLQle99SsBxoDIF12y7DztkAnOOYvEu
         buj0VCJZ34HxCwm9XViN2k4bma5ifjbvn3oqL/NLSK7rFANkmq3SrbBdC9QsdmpS9mZv
         JdDTLipx828aP4IfflR4rvckl2cembz3QnYReOstPOXKMLcoAa38IhbgC3oH6s4u3/6G
         4kFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KDqRWolsacePh3UOFidtjakTxzNfCPsnv6damvWujAo=;
        fh=kvsWvEa3cRdWT7ZeJAtmxeosrcrlX+BojyDImiQCiTQ=;
        b=arqMM8edwxD9qvviHQ4lLDRs+hb0MFcXraljuVp4B7AOgXRpTiaGVabXTPMLyt+36h
         62OkKe/3Y6g4QFndWz9fDkbn+rXSxEeCq/YznYohRDC98UD6/wqwkYicHesaHH7fu6U/
         +4jpr1f4fCcFxmJIRgndvDzyZBMQ7HA/dUzeKcEPtcdsu1vCo8IjvP+zp7awe3LQUB3k
         Kv75fB+xNo3dn/+RdJ5bbB/yeby70ACW708SR/8mkxUl38xujb2A9i1yrdbDew8YKQvC
         WTQOatZ449C4P1Z4eA9AxaWIdb+ffCEa5FS74xk95FFAy8iGbdwGFWWFgRXL9MVOjJTp
         0Xzg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768302670; x=1768907470; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDqRWolsacePh3UOFidtjakTxzNfCPsnv6damvWujAo=;
        b=Jukihy5tGShDComeC5HBSq4sFYlMU8sONcTBko9rzjKZef/jtCfMN8CYgl25ipwNNc
         AWcij4BtiQPIIpeM3mrM4BMuGTtZMfsIMHvdfSZAJiWmtOCB8HLQupyyRrBFxdURkkpe
         5XlZ+C5l9nufhz7Dj7HngktSl3aD+goauKB+nJwPrr0g2iC+IxzE2DwjFRdm8VI/dX8V
         CejBPOVOXLcvEC5rfSV3Y5SdHoOMJMud1exgg4sAafrWWqV6TnJ8b9wM/M4s0fr9GO6a
         tExo/HbZAxE6loHY+6T52InfJ77bgZ2B5O3PsIdIAM3zQvTOUb0n8SDJuacceXAmAxcm
         Jv7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768302670; x=1768907470;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KDqRWolsacePh3UOFidtjakTxzNfCPsnv6damvWujAo=;
        b=IlzA5Qqs19PfJEGycAjSL0cqPzbhFtADimZ54gW43d5KxxN2CLzp+jo3Ye8svl1ng8
         w+gB5AdHAINipVR4od3mUW3sYklBtttY0yE0UMWqZr4iXefJdoDyO0zamIoRZa9HDVLG
         UvDnR/uTjlbx2XOhTVO5lQLOnIFuwERQrDsBTzql453Bg5lQG1CO4L/JvbmmFUTOiXpi
         lNkOCLq+3JEgtWpWEdK4G06OoJFhm2j2pcQxQIWzYgty4HmybNuP3/UKgU4pzOHJWbWF
         r8sDkcGwjxRRW456KV058Cgq1TjM9RC5Y98bLdVUvDelH13xLMOnUUz48TIiG93bNvFi
         U4lg==
X-Gm-Message-State: AOJu0YxAa9vadsQwNNvynOwE6fXLZ39qBy9qzFm6WzjVKMZQ9CdENxfz
	Yj+/ODVOnwLxUO2p4pZ3QoDk881KLklSwOHlNcpdjFapUgC4GkgZY51tqLKbgOyB7uvy3fvKXR3
	8kfGRMYGPxIJFob4zjwj3zrkiYUd0xLtDOMvQNQUA
X-Gm-Gg: AY/fxX6PKA1/0B+wjTSodJLaFPWi1JITO8x2LwHdC05McbtbFrmncUbYq+uhChEagHM
	oyYVlEistco9f2MEFOA5cL3v4u4mYMY75UeMUjyr0z2ylGzCNQW2mMid/UQOwS5831zeLPGYB3/
	IAzgCHE3vdOA8lirLW4siDCUosH2uZNzTr9DGx4802gC+YFt8FU8ml26U4m6OIWvXL9aHxLNERx
	dYCAcC5LdqCcpSlxeXnTmVoOB12K31J0lYL1Qbl31yE0O4y7VfkHuR2JGqcvJKMqNUyDiTtXGpd
	LTEARKSD4NnnnCL+90mjVZu0ng==
X-Received: by 2002:aa7:cf05:0:b0:64b:53a1:7b09 with SMTP id
 4fb4d7f45d1cf-652f503ee6bmr32524a12.14.1768302669759; Tue, 13 Jan 2026
 03:11:09 -0800 (PST)
MIME-Version: 1.0
References: <20260109171805.901995-1-smostafa@google.com> <hf3gfmaq673tvz6lc7mgip3m4y4o62b3nyqlofas252qr5776y@6oekozsrwea3>
In-Reply-To: <hf3gfmaq673tvz6lc7mgip3m4y4o62b3nyqlofas252qr5776y@6oekozsrwea3>
From: Mostafa Saleh <smostafa@google.com>
Date: Tue, 13 Jan 2026 11:10:56 +0000
X-Gm-Features: AZwV_QgEqIamUf-ZRcxgt46xlqga3cO4Nf6E12yZEj_ySpaNDevCFdZsj-pUJ20
Message-ID: <CAFgf54opD5qveK7njnCgkWeNYWSwiPHTxPBL2ouQYFEAL_kYKQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
To: =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, corbet@lwn.net, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com, 
	baolu.lu@linux.intel.com, rdunlap@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: y8tcjb3xcc3ek5ry4yax61syxekagyca
X-Rspamd-Queue-Id: A68E72000B
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768302671-244723
X-HE-Meta: U2FsdGVkX1/VYgU5opvkDjXtyuu6Lvk8f6DQ1+0Px6GXl3VdqrNrFvMjYfK0rjToYZENOzwxQHcFX5oLL7LrTCr4bjzrddFnXZJ9qTCepDm+rqEChP87H49LwrPIstEatKiGShZn5YJb/yIY2YL7W3iGqR/gRl7LBUD4f1ANncQDjBVrDAO/rPKjR1eUxNer21vJPoaRFqZ1ukIGR2IFRD80cBt4folLp3UIdcCbqJ1euwEOrc4hOZVBFsLzY0BVVZdlyiwFhPF4EDP5W5La5alDY+z1ERdY74IL8HXBpBacqB0olL8fpz29tzgI1Pnf2U5hMYC6vJvxOayVJQRRG1PgrfmoK7zQIaZgRvbOrit2aibn7WWdym3DE/R5Z/iJ2ZrxOtRUHGRlqrhHPe2frfH/Okcy5dR6MhrdNCXK5qPeBlcmYGJBjerWwEKRPOwefg/VfYMLx1iS59FbFNdJljgLabPDXXP/6Q7bOG0ljgBvSmQl27xSHKt4x7cKEdz3PolftSecTUPQ2UtX9A8EiuiOWw7yQMcz+n8Wr2Z6+Ok9YIqgEEmDjP0VO77jz0gad92cTxk5HPq3XpRvQ6obJeoXIvmVa0h4/pu+dZv2hnn1aD8WcjmyTXbje1TY79mgCoQVQKx1fEd4JGnJjf0gKyieYerMavlGs0Oz/x9C1irOT4qqIq5ZKO6MAbFtiFTrMPnO7ybEaLKeaVO0LhaDSfuNYgXL2GyGZW8AqW3oDZsfDpQXYBhO2k6BNRSbmgvq7DYVbQGbR2zegfK7fqAYJ0lusNsP+Nn5aNUxJ+SRZ1mWg86mJv74sqWRr3K0jRU6lfXr0rRo7zHRT2FNlMOkIrHXc5RMGPvCIbxkab2gC7yrZ/RUadEPnIFOrJLr702JqnMW5AYMGXw9TgK177Iay8gu51RVeiY9wVfC1GWnZlfB7GhAEG3Co93F3AJtoY2YTz1K77ZiPX34Xg0JdYW
 pWjqm9f2
 8BqqwgH9o74NP/5PEfHtmbHaU5wa23vQFLFmfB2oflKyO+Rt6wyO+61w43i+12+2LXXNENEB5RNB/PB3Kcc4yRlvimuQiJU7drlOknlftwhHJnE75dr3d0fowY8tf1ix6oGuk6cjYXCO+Z5jfhv9peRiiLDajzgnw3zIHRGd/QQpEfR9NVIsmqUjF8mIwyQWD50eMQkpI2GnDtXwXujZvVxgaPfUXviOS9n2wZc7PHgJ19W2GmwZQSzkvNoLbz314BbYvZBQp4Ht5wxX5Kt1D9SfvhbfX7P+qlu9oRmtIADFpbwSG/PN4/6AqBz8hnADMbyV3+7qOiOmDPtN7uD9nCmESTZIL5uxptsOodSSqmanwtzWtXoW8zVE1c9LkIAJyWa65xP2tRvayOaIGyT3zNv07C4V+bGmBs5aKGGBYOhmrh/nAuKkKAa9iww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 10, 2026 at 9:53=E2=80=AFAM J=C3=B6rg R=C3=B6del <joro@8bytes.o=
rg> wrote:
>
> On Fri, Jan 09, 2026 at 05:18:01PM +0000, Mostafa Saleh wrote:
> > Mostafa Saleh (4):
> >   iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
> >   iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
> >   iommu: debug-pagealloc: Track IOMMU pages
> >   iommu: debug-pagealloc: Check mapped/unmapped kernel memory
> >
> >  .../admin-guide/kernel-parameters.txt         |   9 +
> >  drivers/iommu/Kconfig                         |  19 ++
> >  drivers/iommu/Makefile                        |   1 +
> >  drivers/iommu/iommu-debug-pagealloc.c         | 167 ++++++++++++++++++
> >  drivers/iommu/iommu-priv.h                    |  58 ++++++
> >  drivers/iommu/iommu.c                         |  11 +-
> >  include/linux/iommu-debug-pagealloc.h         |  32 ++++
> >  include/linux/mm.h                            |   5 +
> >  mm/page_ext.c                                 |   4 +
> >  9 files changed, 304 insertions(+), 2 deletions(-)
> >  create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
> >  create mode 100644 include/linux/iommu-debug-pagealloc.h
>
> Applied, thanks.

Thanks a lot! Based on the discussion on patch 3, I might need to
respin a new version.

Thanks,
Mostafa

