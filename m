Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAED1CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 20:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 139256B000E; Tue,  2 Sep 2025 16:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C2CA6B0010; Tue,  2 Sep 2025 16:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF3146B0011; Tue,  2 Sep 2025 16:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D73356B000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:13:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9FD48C01B9
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:13:13 +0000 (UTC)
X-FDA: 83845409466.05.8F0F910
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0A7F680002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:13:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756843991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pA100de6+EGGSebqr7S3ta17DmY+lz+0j4dxdX6ghr8=;
	b=fP7ELSOvXNxkD+ZktgKT4gqYskmIF/xZn39zuRf+MBLUiRrOzIJNK3TzXpu4FI+vy7iK/3
	A1C7JbEJciW/Q5RKUoXhnWQyHLHyQECA6rJkXb2Xn9sK70AMkm7YAU4F5dCxAAqOKeICWC
	Z9Evrl3v/68YHuoZVy6n2iM3yZJurjg=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756843991; a=rsa-sha256;
	cv=pass;
	b=YirC4X9F7qd/WM/j2/7NHWccgprTJFwJwzSGS+32sgqzVjNVWHQbLpiMpYnmwZLAbwml3B
	jK9Tc1hT5/3ouqGo1cpJHB16OIpSUHbpGTobJNf8doJesXcEcur7WSL1y06CAXWUmhYTpu
	QTJHyz92Juwa/47Rh3pxVL30gC0R/6M=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E24B1A0382
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:13:10 +0000 (UTC)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F1A9C0203
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:13:10 +0000 (UTC)
X-FDA: 83845409340.04.9E20EAE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id C5A6F140014
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:13:07 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756843987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pA100de6+EGGSebqr7S3ta17DmY+lz+0j4dxdX6ghr8=;
	b=gxAx91QxTA5ajULHva5VYaluhC/ym7pwS8kBSfzidoXS7+uQKkrS1MJQM8TCxtoFVDVxR1
	fwgMFhqIAf78TZ3lFYxDFnPfG0iNQklawXDF3kKxDzLnxu9elkPDxcNtTCngjv/MkfBZFA
	61DFJlY8aBhv5QqC/r3C5Voju1SNTjo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eMVoy9pp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756843987; a=rsa-sha256;
	cv=none;
	b=RZ9AYL9mKDOMK0XsyBFQbCHiUILy3jic4u7Yh051F+nMWzKewp42yfImMHFf3oo5foT5+O
	9e396Mrq002Hh23BaddRpB5oCmPVfRJNqSOrGNyZcMacx+DQkgPbuzTezdzHN4T9/angiu
	nBy2ztTRwN0bYZB0CcJtrVKCHGcp5O8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756843987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pA100de6+EGGSebqr7S3ta17DmY+lz+0j4dxdX6ghr8=;
	b=eMVoy9pp6C9xj3/MXQCpRGaA/ego7jZ1wRsE1rSXE73GVcSp5Uwv91RD+COm+XmTeM4ssV
	PBc8J02ayvg1iOm9MwSt11oiXJ/TmgI3tzZ51H1JVcJDQXmo0BWRxmfjqbqctxaYJwbr1v
	17STqK1t3EWdqIpl5HBMgmDisEnE6ws=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-E52YUqBfMsqqoe8TJ_cpeA-1; Tue, 02 Sep 2025 16:13:06 -0400
X-MC-Unique: E52YUqBfMsqqoe8TJ_cpeA-1
X-Mimecast-MFC-AGG-ID: E52YUqBfMsqqoe8TJ_cpeA_1756843985
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-72166cf69bcso5255697b3.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 13:13:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756843985; x=1757448785;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pA100de6+EGGSebqr7S3ta17DmY+lz+0j4dxdX6ghr8=;
        b=GiqLye6D38I6P+F7l8kboleDLKQyZF+qsmqDqNKMqcSGVAfHg9wsXct0Tv7fBuM4HS
         pMEIPyMnHN8bgOSFeRd1Xy9RerCbDievbVE3PsRy4h234zYzelw4Kgr5yXoRf9xDurgX
         6Prwca9LjuXLcT4ZU4f/hLa6Ua5BsnVfS251IWi/d0NROs5BKUw2vfnoWO3Cp4BlykPM
         tS6qXRkvjYuFnPmpKXeZ+NkPqBCAE3e8xvwhf5jNcQeQ5g6e42lq5NU8I0OsGU0hoL0B
         VHR18s+dUWWB1Lbty2nmCtWyrsPuH6/RXK13gpG6iFtfFIN7GNwv+1DByMV7B4QnkmtT
         YmzQ==
X-Gm-Message-State: AOJu0YyC41NCS708o4i+dY9iYKxG2MhKVxOcWUM4Q8oJW4Rlp2nYAjvU
	F30W1VJcedFOBW+fPaqlGfMEvnnTc/cMvC8yad7TLgTT51TRr8OaU9vAHjrU1UDqE/0hHApcRNA
	5DEfRIhLLO4x4ZvELbxdgIQCxGL5TZ5KFEJzi02kF+sfGseSolGEW30UrUlOa/RIGK3dG1ZnadE
	GRPpKWuMiHpAmNhnUztMHvuPO0TqE=
X-Gm-Gg: ASbGncsUw/m/rAkVVus92MFhXWDN+7pimZM3iHMD8Td3DnlFd+4O6qsX2HDXDJlIQSc
	E/1SN2Acbd+MxQVfb8QZ7mMvTmQx6IGQuIYO7Bey4QWslS3NT9JB+20DmQPVV5Jw/jpOSC25X8l
	haEWTiJHY4Khx8bgCMJyio/liGMPWv4K6tGg==
X-Received: by 2002:a05:690c:a0a5:10b0:723:b168:91de with SMTP id 00721157ae682-723b168a355mr27781517b3.3.1756843984876;
        Tue, 02 Sep 2025 13:13:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzBmWDDzOhOINPHDFz8+ZgPvTqimLcoX7LqCzGqCPfHQoShbajHcwhsB8xTxFyNXAROK2tA8Izhee9OTeUJtc=
X-Received: by 2002:a05:690c:a0a5:10b0:723:b168:91de with SMTP id
 00721157ae682-723b168a355mr27780857b3.3.1756843984110; Tue, 02 Sep 2025
 13:13:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250819134205.622806-1-npache@redhat.com> <20250819134205.622806-7-npache@redhat.com>
 <06d1b76f-039c-4d6f-a03d-9253b14b5e8f@lucifer.local>
In-Reply-To: <06d1b76f-039c-4d6f-a03d-9253b14b5e8f@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Tue, 2 Sep 2025 14:12:38 -0600
X-Gm-Features: Ac12FXxK7KWA4bV49Z6cNvEqyoDfKFUqtaPtY1Vos0WSrdcr3Ojwl1O61q8PZeo
Message-ID: <CAA1CXcDPF5cHF8HEtc28AToyHpDeGLjgYD17X42U3ksiNAFvSQ@mail.gmail.com>
Subject: Re: [PATCH v10 06/13] khugepaged: add mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com, 
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de, 
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, 
	jglisse@google.com, surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: N0Jsyeqk6NvspzFhPfDy3xwtZU82sDQw7twtolVje6c_1756843985
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-HE-Meta: U2FsdGVkX1+Kr8KO7n1S78uPpozoisX5YycoRGD8/YCPdHsNCf47MuNwfcL1fXE+qjRoFpShu8ZIqUBobBIwU1V6PNIv8a30GwHAi8kF13xSUhcLYMyicmhM/HcmijSWVI1fVGKTFncqm3EauQN/MkdO1GYVRzgKYVEl/bYGi75OiHRunR4JfnC3MhjhK21uL0B/PQV/JLwaPFsX6nKsUFVErV4As1F4gAtsLSa5bZnZXFPo3hT/ozxgA4uc8YO8T10a2lCpuZhIpwWs8Bdcl1bcYpZHQEp8PnU78jp5kd1ffoYIMcqdsiuHixAfSdIs9NofMLHf19P0N0Q5ec6XeRHYLNkADAsLvMLd1bO8FtaBFqxtJd2bGtZf+mOYXPindCiOXbqX+DNp5pDJ5S6n+mKU8pIMv3MQr50FzJCxl6cXnt6w3uYaGwYBXwF+QFfqDkIFwjYAe1zUL3IgTo+cSdNmhbF7iVdGSTv5Rs9nKrivT4/rUOFO5c6uXJsq0dyyYs/cIYcFBvQfgm8ZGmpVefoKxLK8mBtEJX/9SL+b4HR0DqMgr0C9mEoIB+p6Q/4RoEJmyrKX6ZrzzTwuA6I6n7Y01JDk696Xd9qYX1u8bAVebtP1EqhMAAepC50LJORQZKmvS8eE/x/R+dj+nUis6bo543OP8orJgzxZr8I5mvwzoDDJW2w9l75atYd4grYmdzdYPVJmWv1w0Nsxz6FcJLrwEgAb7iDDaUvcpbk4c+JS6mOgpGOpZqSwCC4TwYEP419q1J2ISIwghWNk3bijcrlcwkv4Imw1epWyt3q1NSKD31Cr5BjGO2ymybNZ8G35Pybg/kJ3zNh80MGyUvrdx7L559bZBemKkeyQ+7UrtsYBDDpfELJf5pQv0li8YN1qTB4eQFxpd8v8XLspmlIVt1GM5KHB89DfmPrR+gulTm/RidNVgb+o+AcBKmTXpE9vlGqsCYGeDhVxnAvjqdv
 gBYh/q7h
 L6M2LqVR9xA63IWFty5sqdM2G67I0qq9S4kSm5QIrrNNwA0zry0lfB6jNwsbqzbo3wp/FaKVjXppuTc32ERbKjFv/rHRQCE6qDoqAiAOT6asbKSqlmOAcH9oAFT6gReA9K8z2yIh1AqMBouOFOD2+7d8yVDJWv5qgWsRWbGsek6JPHNW9i1rKATop4tfP8K+XpToiPw5XWqspNsYsIoAxDcLk6wAEm8uzNfUqFZpj5CuIv64XpJR8L5KGdyDOSfFLitSsyCD41c/izqQv6nzzakCckO3SgGCsHpsUSIojrbIBCgWvMewBZIfPlAHo4F5iDZ+V58yiEeaPlLwGMqgrz9GtKTJdcr6r/BGnsJ1FvMuWe0tNuATDn8b8Qg==
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0A7F680002
X-Stat-Signature: pqy85x4c1s6uomtixm87k4bunp4e79id
X-Rspam-User: 
X-HE-Tag-Orig: 1756843987-594686
X-HE-Tag: 1756843990-980202
X-HE-Meta: U2FsdGVkX18z5T9bQo5gEnEwgoDQBWeuqfuxr/9Ng/SYZNGMLPwn8ilGrS63JG9kNG9D0MHVmO+q9DrFWsq2Lxu/VzpMV9U8hfEqKHYItgNr/O5jmQ68qRm1MlPmr9SYzc6DVmlyvUmVfr0hhRHey2MRA+IFYZ9cOulYqmF8dKufWtgfLVbhMZaa2Y9ZcmxIux0ypdblX3ZGC4BmDnKklRAVVMJoJ68FddzFw54choozrZ6wWKGxYyXvPFRDNq3BsJ7FYxKv3DgNcrJzwQ4QDHu4OPZ/R54a5mKjmD/wren7GVHSMpuCyg1Qyp8xLI6HTd9hX8/gZWLMzTruDL748A06KhezPZfAX8sgTO6DUdb1j1TsqLJ9c0gpRPU09m6djJEyMdUyqIxWtIpZGX54953L91zIg2PEn+K3IfJPQw62ZkmpBMW9qdqTcXGXH3/spKtt/v+H/PzkTNlsLYxo3AgAMdV9O/tuhfH3YUWnqoPYB0RWg6lNcfJZKYeVJoO+yHgwGQKSCvlxY+IxCsaPpSE4iCEJhxrA7WQcffF56VJoBbq9Uh4wrx2067Aq37XwTPt6H6dsEgl1aM0gWqTRqoe2OmWdtXpoPbXicBRgpDT1KNqjFBlvN9iVPwMZDTmbZFTpePHiT272keI+yetd5MJKxplOMmTUXcW5Ka3DTfv2Lh0k3u9516WlPb7m4wR9aBEZRU5pNgY8BA5pAHKELYBGydc6fm0ZXTa0uUGDr+PjOGs6iRW5BByGYYfZR2qvudMtmzWket9l9j5nGEPdf3Ok79cDRSrKmUHBBN4xdBvx+lJ/c96L8SrkKNLMi1k6fpzCBp4S9YFUtCr+WNn24QKtD9p0wSD/b5y5ihw6bOXbXe87i+UXNZWM7MxRdWCsG9UWnMtYihOfqdthM09Q6qA3dFI+hpBAauXQ7HzqK2NlP0BCjL++C+pd9xfRU84V/MyaUTy0Junr1i+7HwK
 DRVExmkk
 hCf5AsZ0Pne2dCUM3Vpi2iGUPJajKGh+VejMsCdJXJ6WIZs2sEraiwKnvVeSdufdEO4CcTfSyyTMIP9oDPLCXFESejzKYsoH921caFDKcSI0Zrmt4ryDmlvZWBZ6UHFw6Y/D2w5NKXzKnEUj/ki3hHheBiDGyK36+4fjRo7zLstgvFjW32b3gAxzRLDMkDgpa5HCJP1ufgOaHpIqOUG02PvLg6S5hICAv3oI8+ozCvtoXYi8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 12:30=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Aug 19, 2025 at 07:41:58AM -0600, Nico Pache wrote:
> > Introduce the ability for khugepaged to collapse to different mTHP size=
s.
> > While scanning PMD ranges for potential collapse candidates, keep track
> > of pages in KHUGEPAGED_MIN_MTHP_ORDER chunks via a bitmap. Each bit
> > represents a utilized region of order KHUGEPAGED_MIN_MTHP_ORDER ptes. I=
f
> > mTHPs are enabled we remove the restriction of max_ptes_none during the
> > scan phase so we don't bailout early and miss potential mTHP candidates=
.
> >
> > A new function collapse_scan_bitmap is used to perform binary recursion=
 on
> > the bitmap and determine the best eligible order for the collapse.
> > A stack struct is used instead of traditional recursion. max_ptes_none
> > will be scaled by the attempted collapse order to determine how "full" =
an
> > order must be before being considered for collapse.
> >
> > Once we determine what mTHP sizes fits best in that PMD range a collaps=
e
> > is attempted. A minimum collapse order of 2 is used as this is the lowe=
st
> > order supported by anon memory.
> >
> > For orders configured with "always", we perform greedy collapsing
> > to that order without considering bit density.
> >
> > If a mTHP collapse is attempted, but contains swapped out, or shared
> > pages, we don't perform the collapse. This is because adding new entrie=
s
> > can lead to new none pages, and these may lead to constant promotion in=
to
> > a higher order (m)THP. A similar issue can occur with "max_ptes_none >
> > HPAGE_PMD_NR/2" due to the fact that a collapse will introduce at least=
 2x
> > the number of pages, and on a future scan will satisfy the promotion
> > condition once again.
> >
> > For non-PMD collapse we must leave the anon VMA write locked until afte=
r
> > we collapse the mTHP-- in the PMD case all the pages are isolated, but =
in
> > the non-PMD case this is not true, and we must keep the lock to prevent
> > changes to the VMA from occurring.
> >
> > Currently madv_collapse is not supported and will only attempt PMD
> > collapse.
>
> Yes I think this has to remain the case unfortunately as we override
> sysfs-specified orders for MADV_COLLAPSE and there's no sensible way to
> determine what order we ought to be using.
>
> >
> > Signed-off-by: Nico Pache <npache@redhat.com>
>
> You've gone from small incremental changes to a huge one here... for the
> sake of reviewer sanity at least, any chance of breaking this up?
I had this as two patches (one for the bitmap and one for implementing
it), but I was asked to squash them :/
>
> > ---
> >  include/linux/khugepaged.h |   4 +
> >  mm/khugepaged.c            | 236 +++++++++++++++++++++++++++++--------
> >  2 files changed, 188 insertions(+), 52 deletions(-)
> >
> > diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> > index eb1946a70cff..d12cdb9ef3ba 100644
> > --- a/include/linux/khugepaged.h
> > +++ b/include/linux/khugepaged.h
> > @@ -1,6 +1,10 @@
> >  /* SPDX-License-Identifier: GPL-2.0 */
> >  #ifndef _LINUX_KHUGEPAGED_H
> >  #define _LINUX_KHUGEPAGED_H
> > +#define KHUGEPAGED_MIN_MTHP_ORDER    2
>
> I guess this makes sense as by definition 2 pages is least it could
> possibly be.
Order, so 4 pages, 16kB mTHP
>
> > +#define KHUGEPAGED_MIN_MTHP_NR       (1 << KHUGEPAGED_MIN_MTHP_ORDER)
>
> Surely KHUGEPAGED_MIN_NR_MTHP_PTES would be more meaningful?
Sure!
>
> > +#define MAX_MTHP_BITMAP_SIZE  (1 << (ilog2(MAX_PTRS_PER_PTE) - KHUGEPA=
GED_MIN_MTHP_ORDER))
>
> This is confusing - size of what?
We need it like this due to ppc64 (and maybe others?), it used to be
based on PMD_ORDER, but some arches fail to compile due to the PMD
size only being known at boot time.

This compiles to 9 on arches that have 512 ptes.
so 1 << (9 - 2) =3D=3D 128
>
> If it's number of bits surely this should be ilog2(MAX_PTRS_PER_PTE) -
> KHUGEPAGED_MIN_MTHP_ORDER?
This would only be 7? We need a 128 bit bitmap
>
> This seems to be more so 'the maximum value that could contain the bits r=
ight?
>
> I think this is just wrong though, see below at DECLARE_BITMAP() stuff.
>
> > +#define MTHP_BITMAP_SIZE  (1 << (HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP=
_ORDER))
>
> Hard to know how this relates to MAX_MTHP_BITMAP_SIZE?
>
> I guess this is the current bitmap size indicating all that is possible,
> but if these are all #define's what is this accomplishing?
One for compile time one for runtime. Kind of annoying but it was the
easiest solution given the architecture limitations.
>
> For all - please do not do (1 << xxx)! This can lead to sign-extension bu=
gs at least
> in theory, use _BITUL(...), it's neater too.
ack, thanks!
>
> NIT but the whitespace is all screwed up here.
>
> KHUGEPAGED_MIN_MTHP_ORDER and KHUGEPAGED_MIN_MTHP_NR
>
> >
> >  #include <linux/mm.h>
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 074101d03c9d..1ad7e00d3fd6 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -94,6 +94,11 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, M=
M_SLOTS_HASH_BITS);
> >
> >  static struct kmem_cache *mm_slot_cache __ro_after_init;
> >
> > +struct scan_bit_state {
> > +     u8 order;
> > +     u16 offset;
> > +};
> > +
> >  struct collapse_control {
> >       bool is_khugepaged;
> >
> > @@ -102,6 +107,18 @@ struct collapse_control {
> >
> >       /* nodemask for allocation fallback */
> >       nodemask_t alloc_nmask;
> > +
> > +     /*
> > +      * bitmap used to collapse mTHP sizes.
> > +      * 1bit =3D order KHUGEPAGED_MIN_MTHP_ORDER mTHP
>
> I'm not sure what this '1bit =3D xxx' comment means?
A single bit represents 1 << MIN_MTHP_ORDER (4) pages. Ill express that bet=
ter
>
> > +      */
> > +     DECLARE_BITMAP(mthp_bitmap, MAX_MTHP_BITMAP_SIZE);
>
> Hmm this seems wrong.
Should be a bitmap with 128 bits (for 4k page size). Not sure what's wrong =
here.
>
> DECLARE_BITMAP(..., val) is expessed as:
>
> #define DECLARE_BITMAP(name,bits) \
>         unsigned long name[BITS_TO_LONGS(bits)]
>
> So the 2nd param should be number of bits.
>
> But MAX_MTHP_BITMAP_SIZE is:
>
> (1 << (ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER))
>
> So typically:
>
> (1 << (9 - 2)) =3D 128
>
> And BITS_TO_LONGS is defined as:
>
> __KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(long))
>
> So essentially this will be 128 / 8 on a 64-bit system so 16 bytes to
> store... 7 bits?
I think you mean 64. 8 would be BYTES_PER_TYPE
>
> Unless I'm missing something here?
Hmm, unless the DECLARE_BITMAP is being used incorrectly in multiple
places, DECLARE_BITMAP(..., # of bits) is how this is intended to be
used.

I think it's an array of unsigned longs, so each part of the name[] is
already 64 bits. hence the divide.
>
> > +     DECLARE_BITMAP(mthp_bitmap_temp, MAX_MTHP_BITMAP_SIZE);
>
> Same comment as above obviously. But also this is kind of horrible, why a=
re
> we putting a copy of this entire bitmap on the stack every time we declar=
e
> a cc?
The temp one is used as a scratch pad, Baolin also finds this useful
in his file mTHP collapse useful for another use as well.

In general khugepaged always uses the same CC, so it doesn't not
having to constantly allocate this.
>
> > +     struct scan_bit_state mthp_bitmap_stack[MAX_MTHP_BITMAP_SIZE];
> > +};
> > +
> > +struct collapse_control khugepaged_collapse_control =3D {
> > +     .is_khugepaged =3D true,
> >  };
>
> Why are we moving this here?
Because if not it doesn't compile.
>
> >
> >  /**
> > @@ -854,10 +871,6 @@ static void khugepaged_alloc_sleep(void)
> >       remove_wait_queue(&khugepaged_wait, &wait);
> >  }
> >
> > -struct collapse_control khugepaged_collapse_control =3D {
> > -     .is_khugepaged =3D true,
> > -};
> > -
> >  static bool collapse_scan_abort(int nid, struct collapse_control *cc)
> >  {
> >       int i;
> > @@ -1136,17 +1149,19 @@ static int alloc_charge_folio(struct folio **fo=
liop, struct mm_struct *mm,
> >
> >  static int collapse_huge_page(struct mm_struct *mm, unsigned long addr=
ess,
> >                             int referenced, int unmapped,
> > -                           struct collapse_control *cc)
> > +                           struct collapse_control *cc, bool *mmap_loc=
ked,
> > +                           unsigned int order, unsigned long offset)
> >  {
> >       LIST_HEAD(compound_pagelist);
> >       pmd_t *pmd, _pmd;
> > -     pte_t *pte;
> > +     pte_t *pte =3D NULL, mthp_pte;
> >       pgtable_t pgtable;
> >       struct folio *folio;
> >       spinlock_t *pmd_ptl, *pte_ptl;
> >       int result =3D SCAN_FAIL;
> >       struct vm_area_struct *vma;
> >       struct mmu_notifier_range range;
> > +     unsigned long _address =3D address + offset * PAGE_SIZE;
>
> This name is really horrible. please name it sensibly.
>
> It feels like address ought to be consistently the base of the THP or mTH=
P
> we wish to collapse, and if we need something PMD aligned for some reason
> we should rename _that_ to e.g. pmd_address.
>
> Orrr it could be mthp_address...
>
> Perhaps we could just figure that out here and pass only the
> address... aligning to PMD boundary shouldn't be hard/costly.
>
> But it may indicate we need further refactorisation so we don't need to
> paper over cracks + pass around a PMD address to do things when that may
> not be where the (m)THP range begins.
Ok i'll rename them, but we still need to know the PMD address as we
rely on it for a few key operations.
Can we leave _address and rename address to pmd_address?
>
> >
> >       VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> >
> > @@ -1155,16 +1170,20 @@ static int collapse_huge_page(struct mm_struct =
*mm, unsigned long address,
> >        * The allocation can take potentially a long time if it involves
> >        * sync compaction, and we do not need to hold the mmap_lock duri=
ng
> >        * that. We will recheck the vma after taking it again in write m=
ode.
> > +      * If collapsing mTHPs we may have already released the read_lock=
.
> >        */
> > -     mmap_read_unlock(mm);
> > +     if (*mmap_locked) {
> > +             mmap_read_unlock(mm);
> > +             *mmap_locked =3D false;
> > +     }
> >
> > -     result =3D alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
> > +     result =3D alloc_charge_folio(&folio, mm, cc, order);
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out_nolock;
> >
> >       mmap_read_lock(mm);
> > -     result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc,
> > -                                      BIT(HPAGE_PMD_ORDER));
> > +     *mmap_locked =3D true;
> > +     result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc, B=
IT(order));
>
> I mean this is kind of going back to previous commits, but it's really ug=
ly
> to pass a BIT(xxx) here, is that really necessary? Can't we just pass in
> the order?
Yes and no... currently we only ever pass the bit of the current order
so we could get away with it, but to generalize it we want the ability
to pass a bitmap of the available orders. Like in the case of future
madvise_collapse support, we would need to pass a bitmap of possible
orders.
>
> It's also inconsistent with other calls like
> e.g. __collapse_huge_page_swapin() below which passes the order.
>
> Same goes obv. for all such invocations.
>
> >       if (result !=3D SCAN_SUCCEED) {
> >               mmap_read_unlock(mm);
> >               goto out_nolock;
> > @@ -1182,13 +1201,14 @@ static int collapse_huge_page(struct mm_struct =
*mm, unsigned long address,
> >                * released when it fails. So we jump out_nolock directly=
 in
> >                * that case.  Continuing to collapse causes inconsistenc=
y.
> >                */
> > -             result =3D __collapse_huge_page_swapin(mm, vma, address, =
pmd,
> > -                                                  referenced, HPAGE_PM=
D_ORDER);
> > +             result =3D __collapse_huge_page_swapin(mm, vma, _address,=
 pmd,
> > +                                                  referenced, order);
> >               if (result !=3D SCAN_SUCCEED)
> >                       goto out_nolock;
> >       }
> >
> >       mmap_read_unlock(mm);
> > +     *mmap_locked =3D false;
> >       /*
> >        * Prevent all access to pagetables with the exception of
> >        * gup_fast later handled by the ptep_clear_flush and the VM
> > @@ -1198,8 +1218,7 @@ static int collapse_huge_page(struct mm_struct *m=
m, unsigned long address,
> >        * mmap_lock.
> >        */
> >       mmap_write_lock(mm);
> > -     result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc,
> > -                                      BIT(HPAGE_PMD_ORDER));
> > +     result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc, B=
IT(order));
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out_up_write;
> >       /* check if the pmd is still valid */
> > @@ -1210,11 +1229,12 @@ static int collapse_huge_page(struct mm_struct =
*mm, unsigned long address,
> >
> >       anon_vma_lock_write(vma->anon_vma);
> >
> > -     mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
> > -                             address + HPAGE_PMD_SIZE);
> > +     mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, _address=
,
> > +                             _address + (PAGE_SIZE << order));
>
> This _address is horrible. That really does have to change.
>
> >       mmu_notifier_invalidate_range_start(&range);
> >
> >       pmd_ptl =3D pmd_lock(mm, pmd); /* probably unnecessary */
> > +
>
> Odd whitespace...
>
> >       /*
> >        * This removes any huge TLB entry from the CPU so we won't allow
> >        * huge and small TLB entries for the same virtual address to
> > @@ -1228,19 +1248,16 @@ static int collapse_huge_page(struct mm_struct =
*mm, unsigned long address,
> >       mmu_notifier_invalidate_range_end(&range);
> >       tlb_remove_table_sync_one();
> >
> > -     pte =3D pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
> > +     pte =3D pte_offset_map_lock(mm, &_pmd, _address, &pte_ptl);
>
> I see we already have a 'convention' of _ prefix on the pmd param, but tw=
o
> wrongs don't make a right...
>
> >       if (pte) {
> > -             result =3D __collapse_huge_page_isolate(vma, address, pte=
, cc,
> > -                                                   &compound_pagelist,
> > -                                                   HPAGE_PMD_ORDER);
> > +             result =3D __collapse_huge_page_isolate(vma, _address, pt=
e, cc,
> > +                                                   &compound_pagelist,=
 order);
> >               spin_unlock(pte_ptl);
> >       } else {
> >               result =3D SCAN_PMD_NULL;
> >       }
> >
> >       if (unlikely(result !=3D SCAN_SUCCEED)) {
> > -             if (pte)
> > -                     pte_unmap(pte);
>
> Why are we removing this?
>
> >               spin_lock(pmd_ptl);
> >               BUG_ON(!pmd_none(*pmd));
> >               /*
> > @@ -1255,17 +1272,17 @@ static int collapse_huge_page(struct mm_struct =
*mm, unsigned long address,
> >       }
> >
> >       /*
> > -      * All pages are isolated and locked so anon_vma rmap
> > -      * can't run anymore.
> > +      * For PMD collapse all pages are isolated and locked so anon_vma
> > +      * rmap can't run anymore
> >        */
> > -     anon_vma_unlock_write(vma->anon_vma);
> > +     if (order =3D=3D HPAGE_PMD_ORDER)
> > +             anon_vma_unlock_write(vma->anon_vma);
>
> Hmm this is introducing a horrible new way for things to go wrong. And
> there's now a whole host of terrible error paths that can go wrong very
> easily around rmap locks and yeah, no way we cannot do it this way.
>
> rmap locks are VERY sensitive and the ordering of the locking matters a
> great deal (see top of mm/rmap.c). So we have to be SO careful here.
>
> I suggest you simply have a boolean 'anon_vma_locked' or something like
> this, and get rid of these horrible additional code paths and the second
> order =3D=3D HPAGE_PMD_ORDER check.
>
> We'll track whether or not the lock is held and thereby needs releasing
> that way instead.
>
> Also, and very importantly - are you 100% sure you can't possibly have a
> deadlock or issue beyond this point if you don't release the rmap lock?
I double checked, this was added as a fix to an issue Hugh reported.
The gap between these callers is rather small, and I see no way that
it could skip the lock/unlock cycle.
>
> This is veeeery important, as there can be implicit assumptions around
> whether or not one can acquire these locks and you basically have to audi=
t
> ALL code over which this lock is held.
>
> I'm speaking from hard experience here having bumped into this in various
> attempts at work relating to this stuff...
>
> >
> >       result =3D __collapse_huge_page_copy(pte, folio, pmd, _pmd,
> > -                                        vma, address, pte_ptl,
> > -                                        &compound_pagelist, HPAGE_PMD_=
ORDER);
> > -     pte_unmap(pte);
> > +                                        vma, _address, pte_ptl,
> > +                                        &compound_pagelist, order);
> >       if (unlikely(result !=3D SCAN_SUCCEED))
> > -             goto out_up_write;
> > +             goto out_unlock_anon_vma;
>
> See above...
>
> >
> >       /*
> >        * The smp_wmb() inside __folio_mark_uptodate() ensures the
> > @@ -1273,33 +1290,115 @@ static int collapse_huge_page(struct mm_struct=
 *mm, unsigned long address,
> >        * write.
> >        */
> >       __folio_mark_uptodate(folio);
> > -     pgtable =3D pmd_pgtable(_pmd);
> > -
> > -     _pmd =3D folio_mk_pmd(folio, vma->vm_page_prot);
> > -     _pmd =3D maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
> > -
> > -     spin_lock(pmd_ptl);
> > -     BUG_ON(!pmd_none(*pmd));
> > -     folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
> > -     folio_add_lru_vma(folio, vma);
> > -     pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > -     set_pmd_at(mm, address, pmd, _pmd);
> > -     update_mmu_cache_pmd(vma, address, pmd);
> > -     deferred_split_folio(folio, false);
> > -     spin_unlock(pmd_ptl);
> > +     if (order =3D=3D HPAGE_PMD_ORDER) {
> > +             pgtable =3D pmd_pgtable(_pmd);
> > +             _pmd =3D folio_mk_pmd(folio, vma->vm_page_prot);
> > +             _pmd =3D maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
> > +
> > +             spin_lock(pmd_ptl);
> > +             BUG_ON(!pmd_none(*pmd));
>
> I know you're refactoring this, but be good to change this to a
> WARN_ON_ONCE(), BUG_ON() is verboten unless it's absolutely definitely
> going to be a kernel nuclear event, so worth changing things up as we go.
Yeah i keep seeing those warning in checkpatch, so Ill go ahead and edit it=
.
>
> > +             folio_add_new_anon_rmap(folio, vma, _address, RMAP_EXCLUS=
IVE);
> > +             folio_add_lru_vma(folio, vma);
> > +             pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > +             set_pmd_at(mm, address, pmd, _pmd);
> > +             update_mmu_cache_pmd(vma, address, pmd);
> > +             deferred_split_folio(folio, false);
> > +             spin_unlock(pmd_ptl);
> > +     } else { /* mTHP collapse */
> > +             mthp_pte =3D mk_pte(&folio->page, vma->vm_page_prot);
>
> I guess it's a rule that each THP or mTHP range spanned must span one and
> only one folio.
>
> Not sure &folio->page has a future though.
>
> Maybe better to use folio_page(folio, 0)?
Ok sounds good I'll use that.
>
> > +             mthp_pte =3D maybe_mkwrite(pte_mkdirty(mthp_pte), vma);
> > +
> > +             spin_lock(pmd_ptl);
> > +             BUG_ON(!pmd_none(*pmd));
>
> having said the above, this is trictly introducing a new BUG_ON() which i=
s
> a no-no, please make it a WARN_ON_ONCE().
>
> > +             folio_ref_add(folio, (1 << order) - 1);
>
> Again no 1 << x please.
>
> Do we do something similar somewhere else for mthp ref counting? Can we
> share code somehow?
Yeah but IIRC its only like 2 or 3 places that do something like
this... most callers to folio_add_* do things in slightly different
manners. Maybe something to look into for the future, but I think it
will be difficult to generalize it.
>
> > +             folio_add_new_anon_rmap(folio, vma, _address, RMAP_EXCLUS=
IVE);
> > +             folio_add_lru_vma(folio, vma);
> > +             set_ptes(vma->vm_mm, _address, pte, mthp_pte, (1 << order=
));
>
> Please avoid 1 << order, and I think at this point since you reference it=
 a
> bunch of times, just store a local var like nr_pages or sth?
yeah not a bad idea!
>
> > +             update_mmu_cache_range(NULL, vma, _address, pte, (1 << or=
der));
> > +
> > +             smp_wmb(); /* make pte visible before pmd */
>
> Can you give some detail as to why this will work here and why it is
> necessary?
Other parts of the kernel do it when setting ptes before updating the
PMD. I'm not sure if it's necessary, but better safe than sorry.
>
> > +             pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>
> If we're updating PTE entriess why do we need to assign the PMD entry?
We removed the PMD entry for GUP_fast reasons, then we reinstall the
PMD entry after the mTHP is in place. Same as for PMD collapse.
>
> > +             spin_unlock(pmd_ptl);
> > +     }
>
> This deeply, badly needs to be refactored into something that both shares
> code and separates out these two operations.
>
> This function is disgustingly long as it is, and that's not your fault, b=
ut
> let's try to make things better as we go.
>
> >
> >       folio =3D NULL;
> >
> >       result =3D SCAN_SUCCEED;
> > +out_unlock_anon_vma:
> > +     if (order !=3D HPAGE_PMD_ORDER)
> > +             anon_vma_unlock_write(vma->anon_vma);
>
> Obviously again as above, we need to simplify this and get rid of this
> whole bit.
>
> >  out_up_write:
> > +     if (pte)
> > +             pte_unmap(pte);
>
> OK I guess you moved this from above down here? Is this a valid place to =
do this?
Yes if not we were potentially unmapping a pte early.
>
> >       mmap_write_unlock(mm);
> >  out_nolock:
> > +     *mmap_locked =3D false;
>
> This is kind of horrible, we now have pretty mad logic around who sets
> mmap_locked and where.
>
> Can we just do this at the call sites so we avoid that?
>
> I mean anything we do with this is hideous, but that'd be less confusing =
It
> hink.
>
> >       if (folio)
> >               folio_put(folio);
> >       trace_mm_collapse_huge_page(mm, result =3D=3D SCAN_SUCCEED, resul=
t);
> >       return result;
> >  }
> >
> > +/* Recursive function to consume the bitmap */
>
> Err... please don't? Kernel stack is a seriously finite resource, we do n=
ot
> want recursion at all.
>
> But I'm not actually seeing any recursion here? Am I missing something?
>
> > +static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long ad=
dress,
> > +                     int referenced, int unmapped, struct collapse_con=
trol *cc,
> > +                     bool *mmap_locked, unsigned long enabled_orders)
>
> This is a complicated and confusing function, it requires a comment
> describing how it works.
Ok will do!
>
> > +{
> > +     u8 order, next_order;
> > +     u16 offset, mid_offset;
> > +     int num_chunks;
> > +     int bits_set, threshold_bits;
> > +     int top =3D -1;
>
> Err why do we start at -1 then immediately increment it?
You are correct, it was probably a leftover bit from my development
phase. Seems I can just set it to 0 to begin with.
>
> > +     int collapsed =3D 0;
> > +     int ret;
> > +     struct scan_bit_state state;
> > +     bool is_pmd_only =3D (enabled_orders =3D=3D (1 << HPAGE_PMD_ORDER=
));
>
> Extraneous outer parens.
ack
>
> > +
> > +     cc->mthp_bitmap_stack[++top] =3D (struct scan_bit_state)
> > +             { HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER, 0 };
>
> This is the same as
>
>         cc->mthp_bitmap_stack[0] =3D ...;
>         top =3D 1;
>
> No?
no it would be bitmap_stack[0] =3D ...
then top goes to -1 (at state =3D... ), and if we add more items
(next_order) to the stack it would go top =3D 1 (adds one for each half
of the split)
>
>
> This is really horrible. Can we just have a helper function for this
> please?
Seems kinda excessive for 4 lines and one caller.
>
> Like:
>
>         static int mthp_push_stack(struct collapse_control *cc,
>                 int index, u8 order, u16 offset)
>         {
>                 struct scan_bit_state *state =3D &cc->mthp_bitmap_stack[i=
ndex];
>
>                 VM_WARN_ON(index >=3D MAX_MTHP_BITMAP_SIZE);
>
>                 state->order =3D order;
>                 state->offset =3D offset;
>
>                 return index + 1;
>         }

This would not work in its current state because its ++index in the
current implementation. I would need to refactor, but the general idea
still stands
>
> And can invoke via:
>
>         top =3D mthp_push_stack(cc, top, order, offset);
>
> Or pass index as a pointer possibly also.
>
> > +
> > +     while (top >=3D 0) {
> > +             state =3D cc->mthp_bitmap_stack[top--];
>
> OK so this is the recursive bit...
>
> Oh man this function so needs a comment describing what it does, seriousl=
y.
>
> I think honestly for sake of my own sanity I'm going to hold off reviewin=
g
> the rest of this until there's something describing the algorithm, in
> detail here, above the function.
It's basically binary recursion with a stack structure, that checks
regions of the bitmap in descending order (ie order 9, order 8, ...)
if we go to the next order we add two items to the stack (left and
right half). I will add a comment describing it at the top of the
function.
>
> > +             order =3D state.order + KHUGEPAGED_MIN_MTHP_ORDER;
> > +             offset =3D state.offset;
> > +             num_chunks =3D 1 << (state.order);
> > +             /* Skip mTHP orders that are not enabled */
> > +             if (!test_bit(order, &enabled_orders))
> > +                     goto next_order;
> > +
> > +             /* copy the relavant section to a new bitmap */
> > +             bitmap_shift_right(cc->mthp_bitmap_temp, cc->mthp_bitmap,=
 offset,
> > +                               MTHP_BITMAP_SIZE);
> > +
> > +             bits_set =3D bitmap_weight(cc->mthp_bitmap_temp, num_chun=
ks);
> > +             threshold_bits =3D (HPAGE_PMD_NR - khugepaged_max_ptes_no=
ne - 1)
> > +                             >> (HPAGE_PMD_ORDER - state.order);
> > +
> > +             /* Check if the region is "almost full" based on the thre=
shold */
> > +             if (bits_set > threshold_bits || is_pmd_only
> > +                     || test_bit(order, &huge_anon_orders_always)) {
> > +                     ret =3D collapse_huge_page(mm, address, reference=
d, unmapped,
> > +                                              cc, mmap_locked, order,
> > +                                              offset * KHUGEPAGED_MIN_=
MTHP_NR);
> > +                     if (ret =3D=3D SCAN_SUCCEED) {
> > +                             collapsed +=3D (1 << order);
> > +                             continue;
> > +                     }
> > +             }
> > +
> > +next_order:
> > +             if (state.order > 0) {
> > +                     next_order =3D state.order - 1;
> > +                     mid_offset =3D offset + (num_chunks / 2);
> > +                     cc->mthp_bitmap_stack[++top] =3D (struct scan_bit=
_state)
> > +                             { next_order, mid_offset };
> > +                     cc->mthp_bitmap_stack[++top] =3D (struct scan_bit=
_state)
> > +                             { next_order, offset };
> > +             }
> > +     }
> > +     return collapsed;
> > +}
> > +
> >  static int collapse_scan_pmd(struct mm_struct *mm,
> >                            struct vm_area_struct *vma,
> >                            unsigned long address, bool *mmap_locked,
> > @@ -1307,31 +1406,60 @@ static int collapse_scan_pmd(struct mm_struct *=
mm,
> >  {
> >       pmd_t *pmd;
> >       pte_t *pte, *_pte;
> > +     int i;
> >       int result =3D SCAN_FAIL, referenced =3D 0;
> >       int none_or_zero =3D 0, shared =3D 0;
> >       struct page *page =3D NULL;
> >       struct folio *folio =3D NULL;
> >       unsigned long _address;
> > +     unsigned long enabled_orders;
> >       spinlock_t *ptl;
> >       int node =3D NUMA_NO_NODE, unmapped =3D 0;
> > +     bool is_pmd_only;
> >       bool writable =3D false;
> > -
> > +     int chunk_none_count =3D 0;
> > +     int scaled_none =3D khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER =
- KHUGEPAGED_MIN_MTHP_ORDER);
> > +     unsigned long tva_flags =3D cc->is_khugepaged ? TVA_KHUGEPAGED : =
TVA_FORCED_COLLAPSE;
> >       VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> >
> >       result =3D find_pmd_or_thp_or_none(mm, address, &pmd);
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out;
> >
> > +     bitmap_zero(cc->mthp_bitmap, MAX_MTHP_BITMAP_SIZE);
> > +     bitmap_zero(cc->mthp_bitmap_temp, MAX_MTHP_BITMAP_SIZE);
>
> Having this 'temp' thing on the stack for everyone is just horrid.
As I mention above this serves a very good purpose, and is also
expanded in another series by Baolin to serve another similar purpose
too.
>
> >       memset(cc->node_load, 0, sizeof(cc->node_load));
> >       nodes_clear(cc->alloc_nmask);
> > +
> > +     if (cc->is_khugepaged)
> > +             enabled_orders =3D thp_vma_allowable_orders(vma, vma->vm_=
flags,
> > +                     tva_flags, THP_ORDERS_ALL_ANON);
> > +     else
> > +             enabled_orders =3D BIT(HPAGE_PMD_ORDER);
> > +
> > +     is_pmd_only =3D (enabled_orders =3D=3D (1 << HPAGE_PMD_ORDER));
>
> This is horrid, can we have a function broken out to do this please?
>
> In general if you keep open coding stuff, just write a static function fo=
r
> it, the compiler is smart enough to inline.
ok, we do this is a few places so perhaps its the best approach.
>
> > +
> >       pte =3D pte_offset_map_lock(mm, pmd, address, &ptl);
> >       if (!pte) {
> >               result =3D SCAN_PMD_NULL;
> >               goto out;
> >       }
> >
> > -     for (_address =3D address, _pte =3D pte; _pte < pte + HPAGE_PMD_N=
R;
> > -          _pte++, _address +=3D PAGE_SIZE) {
> > +     for (i =3D 0; i < HPAGE_PMD_NR; i++) {
> > +             /*
> > +              * we are reading in KHUGEPAGED_MIN_MTHP_NR page chunks. =
if
> > +              * there are pages in this chunk keep track of it in the =
bitmap
> > +              * for mTHP collapsing.
> > +              */
> > +             if (i % KHUGEPAGED_MIN_MTHP_NR =3D=3D 0) {
> > +                     if (i > 0 && chunk_none_count <=3D scaled_none)
> > +                             bitmap_set(cc->mthp_bitmap,
> > +                                        (i - 1) / KHUGEPAGED_MIN_MTHP_=
NR, 1);
> > +                     chunk_none_count =3D 0;
> > +             }
>
> This whole thing is really confusing and you are not explaining the
> algoritm here at all.
>
> This requires a comment, and really this bit should be separated out plea=
se.
This used to be its own commit, but multiple people wanted it
squashed... ugh. Which should we go with?
>
> > +
> > +             _pte =3D pte + i;
> > +             _address =3D address + i * PAGE_SIZE;
> >               pte_t pteval =3D ptep_get(_pte);
> >               if (is_swap_pte(pteval)) {
> >                       ++unmapped;
> > @@ -1354,10 +1482,11 @@ static int collapse_scan_pmd(struct mm_struct *=
mm,
> >                       }
> >               }
> >               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> > +                     ++chunk_none_count;
> >                       ++none_or_zero;
> >                       if (!userfaultfd_armed(vma) &&
> > -                         (!cc->is_khugepaged ||
> > -                          none_or_zero <=3D khugepaged_max_ptes_none))=
 {
> > +                         (!cc->is_khugepaged || !is_pmd_only ||
> > +                             none_or_zero <=3D khugepaged_max_ptes_non=
e)) {
> >                               continue;
> >                       } else {
> >                               result =3D SCAN_EXCEED_NONE_PTE;
> > @@ -1453,6 +1582,7 @@ static int collapse_scan_pmd(struct mm_struct *mm=
,
> >                                                                    addr=
ess)))
> >                       referenced++;
> >       }
> > +
> >       if (!writable) {
> >               result =3D SCAN_PAGE_RO;
> >       } else if (cc->is_khugepaged &&
> > @@ -1465,10 +1595,12 @@ static int collapse_scan_pmd(struct mm_struct *=
mm,
> >  out_unmap:
> >       pte_unmap_unlock(pte, ptl);
> >       if (result =3D=3D SCAN_SUCCEED) {
> > -             result =3D collapse_huge_page(mm, address, referenced,
> > -                                         unmapped, cc);
> > -             /* collapse_huge_page will return with the mmap_lock rele=
ased */
> > -             *mmap_locked =3D false;
> > +             result =3D collapse_scan_bitmap(mm, address, referenced, =
unmapped, cc,
> > +                                           mmap_locked, enabled_orders=
);
> > +             if (result > 0)
> > +                     result =3D SCAN_SUCCEED;
> > +             else
> > +                     result =3D SCAN_FAIL;
>
> We're reusing result as both an enum value and as a storage for unmber
> colapsed PTE entries?
>
> Can we just use a new local variable? Thanks
>
> >       }
> >  out:
> >       trace_mm_khugepaged_scan_pmd(mm, folio, writable, referenced,
> > --
> > 2.50.1
> >
>
> I will review the bitmap/chunk stuff in more detail once the algorithm is
> commented.
ok thanks for the review.
>
> Cheers, Lorenzo
>



