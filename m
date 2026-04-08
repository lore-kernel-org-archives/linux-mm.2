Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E35C105D997
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 02:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580BB6B0088; Tue,  7 Apr 2026 22:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558146B0089; Tue,  7 Apr 2026 22:27:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4951D6B008A; Tue,  7 Apr 2026 22:27:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 389CB6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:27:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF297140983
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:27:45 +0000 (UTC)
X-FDA: 84633802890.21.AF9752F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id E1ACD40002
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:27:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IOy7CudM;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775615264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZs04kdhuJIPtSRk7Lom9Ogrm63p9jgWswEzqMw9Shc=;
	b=LXO24SvF5BhFTVLb3lUBjYvjfAu081sZCpw6VnsVTzniFo2tzMGId3zZGuwQyoJhQg4Rud
	nEyjdpCfTqQnUoxU2TtYbNCiJ0MW7TZn6lm8iBtXIlhd0EBTZLWBWC/qyUs2xvi9mZl/LK
	ArAIb7Qri5LSE+cHfn0EtcZfd0oCKCQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775615264; a=rsa-sha256;
	cv=none;
	b=omkknfCZBIag/zx6YOg6u94Arko4mdLJBou7Bmfc0HwnC+fD6F1t3WXakilMfMV8nJuP2u
	8P2ZwRbBSjVdLMsQmNPP7Nxpr8DEQU4ZfogYVvWVfrzdyt+mHkPfKHUjOhhCXgmnNPyszn
	Wm+12w8b3Y1uIIG/mb9VOCHSge9V4rc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IOy7CudM;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D8D12444BD
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A4EC2BCC6
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775615262;
	bh=KZs04kdhuJIPtSRk7Lom9Ogrm63p9jgWswEzqMw9Shc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IOy7CudMUCHr+fyuW44rnIM6ovqv+dEzIlcDdG3DahLGmGYiKmimaz1egOhRHsgcs
	 i1sATkS7Xq52T0wNHmHrcjTDvokPgSHcAPWvpWnbCyV6hkl6fVebITqh9F2Nq/7dWf
	 EUoEo4qtrelecBbhtiTsh8TdZnpKPYsfaDGhzmFFAs3cpMH6rwJfjlzbVrORnSwPDW
	 3oMOl+HQ1m/FY8mAr6XXcPQllkPxUmo6F2GpWG5i0C8ILaLts1Mb0+R+2omKdYScF8
	 ADdHsmZeGEeMC4QwsTATM3H1LiDZBoXTcFR5hsvbwfybKC2VGXStZjQ2IG5/nv1+WP
	 pCyC+uWeGmbFw==
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50babbce85fso71782481cf.2
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 19:27:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCULQDWf04YfsLEOHVl6kv5PkVphFjY6e/0s8HpEHslzWuTIlh79jm60S8lJK/pKnQVazl5URIw3Yw==@kvack.org
X-Gm-Message-State: AOJu0YzH/yrHT0jZ5/5lLt/5YKhrf+q6i5na0NW9XPtvK8rlGPkn+rdT
	FynDuhQet4LrvmEjdluPbua19V9ix7C4z4enaxygiPNNmrc6xNoFFDx7wwNGK3DQaDneGgcCacl
	sUtUIyD3G50jeQJCOhmKdbgN6lW/luUw=
X-Received: by 2002:ac8:7fc5:0:b0:50d:7f81:55ff with SMTP id
 d75a77b69052e-50d7f81587emr218992701cf.32.1775615262018; Tue, 07 Apr 2026
 19:27:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260407110002.204755-1-wujianyue000@gmail.com>
 <adUTC-7iyOAUlhR7@cmpxchg.org> <CAJxJ_jjJtpJJrSA39E1La7qcBE1QMx_Eb1FNwEgy7u0=M6X0-w@mail.gmail.com>
In-Reply-To: <CAJxJ_jjJtpJJrSA39E1La7qcBE1QMx_Eb1FNwEgy7u0=M6X0-w@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 8 Apr 2026 10:27:30 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xV+=esx4+LDV6tBtyoWaTaJjC3iv0UsEnVD-m_tCN9Tw@mail.gmail.com>
X-Gm-Features: AQROBzCbqrIW5mvreMqgnsbPi5CxC-ACFX__ASzA2sn7vfqvMSNIXK_0uhjYHpM
Message-ID: <CAGsJ_4xV+=esx4+LDV6tBtyoWaTaJjC3iv0UsEnVD-m_tCN9Tw@mail.gmail.com>
Subject: Re: [PATCH] mm: move folio LRU helpers out of swap
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	david@kernel.org, mhocko@suse.com, zhengqi.arch@bytedance.com, 
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E1ACD40002
X-Stat-Signature: 6fzqeoy4kur1ps9aowac3yse4rbpk6na
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775615263-948150
X-HE-Meta: U2FsdGVkX1/0Nvi4QQloD3sLLMZaM4XCTQWr2Yg2MMPYoNsOZMU7qWNUeoiYlUDCgPJ1RcrmNnQOJ5bPpXb8UVhvtULpc4wd0Xjt/RXitjTsfuWpr/g4IpkCXFYP2Gw2HfQoo++zJL0JJSt+g56H+344k43nbe3pe7+tnyu7ZXy1XhVfchPWKwT0TjkCk16T71W6ixCDsRj5/ALvMDiflJJPTXe+JZpG3vGAKX5H+vR5NVKUISqlwAWvrEyhOQgo+c/t0sly7OpgNvwlgHWq1jCgMFTIq1oi21sTvmZFynX/6S2i80BpV2elivnHWeTVyIA1ehLnJ2KlmUjAMHy5IDch0jsaKGVYjThljrWwislnjqR/dAx+0/oh/+KmN+A8CDc7CRDvVJCWtYZf0Z+TO4iKn6VVfb7sUQRHyp1/BzeLnN16hW9n5z1QHWAbfTIDl9kMwHl8euKTDPVZVYuss0ZL71CWCFjgiJ2adp2IZPRtf0POF9nQgg1H62b7/VBbIOlBbzGruMEFKwJpRXMbzEndbBYxEVQ8eoKYzrZHYieWiSbYu3DDO6SIwRRWfvG44wQ8U2nBURllArZ6VpJKS8Pqz/ndGewLT4cK+4PVoEKXf3RNz8Eay4KRHb1SCELu1SPCiSD9Inybp1G0gcZNcqp6zjcsk2cKFrOUuDg8RpCwM6WHnT4dPPmH3XElfkRdQShdnKDK1m3Zz/4+IJAS4Fbh3AmTsFXAcF99GBuwSO1PJqIc3F5/Lv64kCAbilc7hjz8ltz2SkWZBGIIOvLjUdlJONc85CgD2CX6SEz1r1PF0wpLb20nyd9H68M7b7R0A1wIaeXcrNRfAej4QCI1oBF61WMQYRIhJ+NvWmZbr8ZuN9IcbICiAlbD/4IE37TOBb1F61+QWCqmHLJhijpURqKV4DXfD7OjheC6YmP89OK/xpYVM6e9xTEbO2jTj5SDR3726RViO1KpKWujRAC
 HXqoMI7t
 3M6G12fD7KZLDSBUH94cDml/CrWXX2vEPTVuaN5+oZFU7dezo5mSAB0jcKVu/jT0ya6MZLsY9T8JQq/DcsZuEbw2Z1svuRvVaWB9TtqtAGJCEItk7Drx748fE/8Zfuz3y9fb47DwMX9px6kJEtQI5n+2zSHiDvsazFST2Hg15WlXMx9EJL10Q/J5n/SHHZzM2W/mmv8AbMI57Cf7e+8HqXExVC/ObNnjyi0MUPH/SuQEV3NGMDM+7pOLmxI0pAzMgE87JL380i04sNugNONBKKxdyCVfh3yOnUx5L2HGJ2ljZJ2YRT8mKeaRLzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 8, 2026 at 8:41=E2=80=AFAM Jianyue Wu <wujianyue000@gmail.com> =
wrote:
>
> On 4/7/2026 10:22 PM, Johannes Weiner wrote:
> > Ironically, the only thing that doesn't fit in this file is the swap
> > stuff. The page_cluster & sysctl should be static in swap_state.c.
> >
> > The rest seems thematically relatively clean - infrastructure for
> > managing folio lifetime. swap.c is not the best name for it, but short
> > of finding a very clear improvement I'd just leave it alone.
>
> Thanks everyone for the reviews and the clear feedback.
>
> I=E2=80=99m withdrawing this patch. I understand the concerns about the
> relative include path, the limited benefit versus churn/conflicts.
> I learned a lot from the discussion, many details in mm parts.

Please don=E2=80=99t abandon this direction =E2=80=94 it just needs a bette=
r
approach. While this patch isn=E2=80=99t perfect, cleaning up
include/linux/swap.h and mm/swap.c seems like a worthwhile
path. include/linux/swap.h is basically a tangled mess.

Thanks
Barry

