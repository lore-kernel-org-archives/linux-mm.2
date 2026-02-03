Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8662FE7FDCF
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 19:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E6736B0005; Tue,  3 Feb 2026 14:48:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 994616B0088; Tue,  3 Feb 2026 14:48:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868A66B0089; Tue,  3 Feb 2026 14:48:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F1976B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:48:21 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E719013B248
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:48:20 +0000 (UTC)
X-FDA: 84404181960.19.0923237
Received: from mail-dl1-f65.google.com (mail-dl1-f65.google.com [74.125.82.65])
	by imf15.hostedemail.com (Postfix) with ESMTP id E8870A0002
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:48:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BrOxLuVg;
	spf=pass (imf15.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770148099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljYXjREKDmOu7d2s7Y3SwTV+aN53dscZlpBmijYsyBA=;
	b=mS6U3zAf+6fLhsJgcdd0jPMpo5rW0+IYmhDVv4cqaX2r9ET0ywFENGcfvsZz2Fe2O2d8/6
	903TGQl5gpYpVK4v9qvirsZ+7bky26X5b8mbAfPSiy+s5LTU2405lZm3dY3KX8IIM4QKPf
	VkzMrIWO7W1D7SeYSGNdp0I2AqAao7o=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BrOxLuVg;
	spf=pass (imf15.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770148099; a=rsa-sha256;
	cv=pass;
	b=5k/ux15jEZ9lfX/MKLeXI50bLVIm1tnUNnwMGZ8LbBcLpnoYBTVmeH8k6YtYNIvh8RNoYF
	6aavad32QFULS502zTUmf4FKTdpuC7jyBF4/xqPGzGoIK68xfP1xolNB7YmdA6VyQg+Waw
	5oRCqpF4u+x5S2REV/vG6S0tQgdCmUI=
Received: by mail-dl1-f65.google.com with SMTP id a92af1059eb24-11f36012fb2so7070049c88.1
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 11:48:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770148098; cv=none;
        d=google.com; s=arc-20240605;
        b=gbh+avSXztNi6f/3EHTAOYer9Ge4M5lc3arRaUyTiaFimIrqxVXIecJO6uuCBX0dlF
         oa1YTgFD/fMb3w1z9P51EUNfZJ/X/UAVrJT+JEnSXgaTIJCdXK8lEa/LrUhY/KvhtfSk
         f5n1bmXF0EVHB9QU+E+qGfACXOLIPoFeDCrygEwFgYmPiv6V+TT82TsuZgPZNGjKUYWu
         1AKgAOVofGsi31KwPhBrxCzmEcf1Ni6UryFxCpbLwr9V2KoSzlUCptuWbWzcU7cNP2C/
         6NW1byc1pPo8DtqyZcfX+mPW0B1syFu/jjnzfIMFaE/WlSyiIMebAa/TN8BLWEbte/4i
         fN6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ljYXjREKDmOu7d2s7Y3SwTV+aN53dscZlpBmijYsyBA=;
        fh=s5DMigsTsJxSSuGshljZq3lELQhuMeM7av2xNByGFRk=;
        b=SZDWT5n5KUmYXZA3bCVCH52addxy9icltIQ7jZ6iyPZ9dpeIYQVd/sZzFrBmbSz1I3
         gKXIGVit7nq2Gq9yymQN0TUHbg4SuVyy3KvZ7IQk/np3A273/bphKuJn3qi2nNyYlZFj
         TcIaNhHqx116nH2HqsbSIyQIf/+DlGEuIXn4VFR42/hAk6gMrPpvYdUeDJnpa4WR38l2
         wEhQDp7p8SoLybJqX/8LlmMSLQ8H7IvdyHvQPs7f2MdL+sLVsrGI1ptxaqKarbldaDfC
         7SZ3TV3m9tp04pY5KyTI1PW2gx9OnuWwhBtW/YG9Gsggb9msE/zubRYQmpEHAzCi7Y5M
         1DNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770148098; x=1770752898; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ljYXjREKDmOu7d2s7Y3SwTV+aN53dscZlpBmijYsyBA=;
        b=BrOxLuVgRPoecuTYydkfyC7k5nON1HQQCJK8Gw54LSqxQ8Cl6LDPCBLd7mSyN/uBUD
         a2sKgt/aHmhjfMvVRwNBAwcsrnGALgg4RODGE/n0PakXGqeCUiQnbFr1VVNyubh727mr
         byHXTLsPsN5i06G1MGvFk6kpEGqVKaJItdQ78qz5zrvpZLCezWPRxzhb8uDUYeEvR8Xz
         Ue4V0RKAF1PoAUMH+JHVEgrwOBHK2b7JNz/WCOwfcKPq0r1B1aJ05So0rD0TdGc2TpPS
         T9WFb/lDO3n5BhJem1ektPo+XXxp9TIxZlABl/bnywhUxnleOjHxU1nPrt0eCLv1rCuQ
         x98Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770148098; x=1770752898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ljYXjREKDmOu7d2s7Y3SwTV+aN53dscZlpBmijYsyBA=;
        b=W+Rkgm+ULUyDabBhS5qKZffPtBkLVcaVVxsvG3aXk79WPnfwUXu5ruuSzIc/MgRYkU
         ykOXSecS6eYVlqln7++4bFUbyFMEel3je9iZX1nL6FmXAXHNwBaIzAEpKKejk7CBVF45
         3ybOjwGtjulPmpj5DHKmUSMO9y/rjgpiB5zJl1KdHL8T7vOKfi53+wRLiJYGn5AfDvr7
         mrArTbpYdpChj0WB9Mlvb503xF1ExeWx0SGFGl87DEv/wlTPZumVu3iMXqY0EYFGkY20
         TTc1IvUAZJaJ4t0v8tpW0iEOYcYq4ZEmZ18CnT9/1l344lOhovgCz77Ye+VxzoGk3ahg
         fazA==
X-Forwarded-Encrypted: i=1; AJvYcCUNbuS9aoa7zwJf9h98vvm/WV2wH+74+RIsKCciE8Ag9fUt2igYw2KVqBcQ91DVE1gJJjao8jFI/g==@kvack.org
X-Gm-Message-State: AOJu0YyToGQ8wBFU7D8gOZKNCr9U00cHp6ttMeQ38DeDm3oMbuk7XacQ
	1WXJLya2rSjxCv3cHZ2vjvue0zrnLBdlPDgbga9kY653myjVnwuCILGRmOAJc+/fC1ZdpzAGy/J
	2U+I1c6KTXje8W4YY3WmfgEGswKvEzQ==
X-Gm-Gg: AZuq6aLKVihYpKUeAs4xBE16iGkChUMEeMKVk6vIh+Trr80l13hycKxdrwdLTHevkY6
	UyjDwmR2uHycDLKNhY3R2iZTdFt2UAkgm/Sm23No3++QJdKPYV7VdHQef908Mis1N4bRskYvPD6
	X1nWaZ9vxw3kf/7fvzIBaj3tnqsdzEFhaKM8oCfShvF1TNxRo8qWbsZ9dVjbq//91T9kdtHyFFO
	YGm/pFC8xh0Hrxq7nu21H/euKQpc+hpIJvzeBkWL6Nt2RQf3tLRG0du586al86AFXhtcJ4=
X-Received: by 2002:a05:7022:6ba2:b0:11b:923d:773f with SMTP id
 a92af1059eb24-126f4781428mr242143c88.5.1770148097517; Tue, 03 Feb 2026
 11:48:17 -0800 (PST)
MIME-Version: 1.0
References: <20260130014807.51302-1-sj@kernel.org> <20260131195408.66514-1-sj@kernel.org>
In-Reply-To: <20260131195408.66514-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Tue, 3 Feb 2026 11:48:06 -0800
X-Gm-Features: AZwV_QhQ9CdPx0t0XZJXip2Lmrp6vOfL-d4v8wYJQjypSaPQbLX41bGGmoxym7c
Message-ID: <CALa+Y1475VSnrNTn-AQtTTnye+sdAGu9sVO0YMEtLidNW53_=A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/3] mm/damon: Introduce node_target_mem_bp Quota
 Goal Metric
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E8870A0002
X-Stat-Signature: sybasicwjgqasesjg8sdcztbccrcrset
X-Rspam-User: 
X-HE-Tag: 1770148098-348605
X-HE-Meta: U2FsdGVkX1/UjcBJ2nYdP/uSY7iqGeEJCDEUY2fDDV9opEdsp3v+rL3/XtBnBPgNyNMX8Bt24fBeEnw++EeONfpVZZppL7K8sPWOdTSJZ2Ff5eYm4EYDoDtd//oXxLGlwi62IDbuQWFX9+rjlE4tYSUdCMzMIdV+aWEraghdgZXqYK9WHdUaNY7ccjcThR/EFstAF5Yb1oTB8GUR/YY9r231rZdpstg1r0stqbZsC8oQmB2ZZ4p7g0M17ODx59KBmcbllQH6O6msJe4T6J0l4THd0qmJxMNwCkce2JXszLEDWGvOD4A5Q3ZvwHX1SgVa2MYYGKD0gulCd4dl+/zCQGtO3QyraKayKj4Ulq0msvOJEYSFXpHRDMpmovd3M+oGwS3nf6z6S7ENMcNCOw9ddjLGR6/lrcmzpL7GqjpQ13kMncFRn2mFWz+tFCgPEGmKsJAia8GUbGxBKK+AT7rDqrfd7cj0PFZ5Tf3GTehV9I3yrWHSRUBakYOxtPxDbR20ZBXp97sPQP8Hbac5Fh8vYwc4HQDj35BWXMjZpzQoElgOvyTDW4fKOpnKRzE6d2+Sics6PbD4iNeTt0H8fhEBzmQo0jAsFGLs9b3DP1MPb1J9RjpATgImDx/NtLljNzqLtFVKJhe2BTCTc5egVpMjV6Qu9+9UQG5N2lL/+6xwjDKpzFG+BQzwQ3Gjm4MLhLz6hxRcTLxZwtmUzd5m+3AJ/+Nqff78mnmQ0cG3zwc340pKTUlasHcHSkk4lTEc0kC07/JckUOWK3qxtSCnV3Gfe5y8bhcT4tFB4LD5KgARMlkEDFeFgdbk2pLgJdh6N5+gvloUMfWEgBgzsYw7Dn/9iQO7N4hGI1wZhf9evxO2JmUAl8XzKwuRC/BGv9kjxVSLkqsYfLsCG7WVPCOU//eVF8pr9RIlxKT9uZQ/gjBfR8Vz6UIkIgpYV/lCq+p+095RHnLAVztOnhWJvQpgbp0
 21Q2oG4i
 Ag9+EmdcGZjUFUorwRtIgmSX264jTlOP9AueTFw2UcaJ8BoR4y5DVs8WGhFqHZzK8l9Y/J3NIWYcnqG49pd4+wcNdZACeJIZrmkR/zdQRL2I4Y94M36Mn8pKx+I5vNUPM3DPE1HkqJPgbhp7oqUGej6Or61/12V3Lwll3i+RNZ3kw763aYCNF6tPdVCCNK6iQXPAZ1/aB3CkJCwgtKzH4Jm4UgC8nl7ntvovWD2f7d5A08Zt4TkMcopHHa754EBbM7TTgLdzy8wrrWztKXRsV9Zia9Pd3j5FkTi70Qa+w3Bg4P7JGT5d5tG94mr5GpAUUFTqMydNA/iRQdmSIxPi5Eue9+WCbcNvZ2YvcXFPqZjTYYrXyUADwwR184D9l5/yOVpCsoWfd9B2s0QfbNQ8akg7fjP0oO4SHh1mBU5+l1BvK21YefqlVLDmubvrcrmpKhJI/0NDRkHIdDLku/7e3EDk/KCWgRtol1GdsigXDQbTHuc92EMKJveDmlCPn8qcm+Es7ZoI2Ys0Nhp7Jt0eGE7uNPEOGyn6tUvkWcpUcAYL2+b6FLTV261/bUcCGZux98ZKc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000021, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 31, 2026 at 11:54=E2=80=AFAM SeongJae Park <sj@kernel.org> wrot=
e:
>
> On Thu, 29 Jan 2026 17:48:06 -0800 SeongJae Park <sj@kernel.org> wrote:
>
> > On Thu, 29 Jan 2026 13:58:11 -0800 Ravi Jonnalagadda <ravis.opensrc@gma=
il.com> wrote:
> >
> > > This series introduces a new DAMON quota goal metric, `node_target_me=
m_bp`,
> > > designed for controlling memory migration in heterogeneous memory sys=
tems
> > > (e.g., DRAM and CXL memory tiering).
> > >
> > > v1: https://lore.kernel.org/linux-mm/20260123045733.6954-1-ravis.open=
src@gmail.com/T/#u
> [...]
> >     Context 0: monitors node 0, migrate_hot -> node 1
> >       goal: node_ineligible_mem_bp, nid=3D0, target=3D4000
> >
> >     Context 1: monitors node 1, migrate_hot -> node 0
> >       goal: node_target_mem_bp, nid=3D0, target=3D6000
>
> In offline, Ravi enlightened me that using a single context with two sche=
mes
> instead of the above two contexts setup can be more efficienct and useful=
.  I
> agree that.  It will be able to only single kdamond, and there could be m=
ore
> flexible use cases that can use the whole-memory access pattern.
>
> That is, we can use single context with the two schemes, but adding a cor=
e
> layer DAMOS filters for applying the schemes to only memory of node 0 and=
 node
> 1, respectively.  Similar for memory tiering use cases.
>
> But I was recommending the multi contexts approach to people because the
> current implementation of DAMOS is not efficient when both quota and core=
 layer
> filters are used.  I was actually working on making it improved, and just
> posted an RFC patch series [1].  After the patches are merged, hopefully =
the
> single context approach will be useful and effcient enough for varying us=
e
> cases including the memory tiering.
>
> [1] https://lore.kernel.org/20260131194145.66286-1-sj@kernel.org
>
Thanks for providing the DAMOS_FILTER patch update SJ.

For v3, I plan to introduce two complementary metrics:
DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP
and DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP.

This will support the following approaches for hot memory migration:
1. Single context with two schemes using both metrics.
(along with DAMOS_FILTER_TYPE_ADDR)
2. Two DAMON contexts each using
DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP.

Will provide more details on the implementation and usage in the v3 series.

Thanks,
Ravi.
>
> Thanks,
> SJ
>
> [...]

