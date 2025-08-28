Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B6FFCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 06:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839228E000B; Thu, 28 Aug 2025 02:12:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9A58E0001; Thu, 28 Aug 2025 02:12:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D8378E000B; Thu, 28 Aug 2025 02:12:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 583368E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:12:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E21FD1A09B0
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:12:51 +0000 (UTC)
X-FDA: 83825147742.13.D3AF7F6
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id 386B5140003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:12:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JgX0VfDF;
	spf=pass (imf23.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756361570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cnbLMdPiCwmvYLji+zAdnqkI0zKaKd1dlWQ6sfyOcHc=;
	b=fY9rnA6DfIxwxUUp9hm0NvJtJ00dOZTROGkS7r1F/5arYd7oH8G4Tn3yMq/ovo8Naqiplq
	JK9vDyHbFldMrCt2IaUEF/A2hE2m8A1hJrls3PdTe/6z4Tq9naQC2t8ASGbqEmReeH5izX
	eWSz2PK+J6fuW2g/h4SSrPYbj3i14FI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JgX0VfDF;
	spf=pass (imf23.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756361570; a=rsa-sha256;
	cv=none;
	b=EL7z2r3KiOMaMqMPo6FDXLTOCd/kZ+cYTQUvridzhmt6O5Jz4UAUVzHOoRnc+XwyES5hwy
	XuC2FoC8kuMzTBTsBw3Rw6pbx+qGZjCrItQezjTef2UA/Jp4L66kSGDWn2Su05tNh9zfsQ
	uI15PVgFKnr+Bt3lG9Z155maQthcSmQ=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-70ddd2e61d9so7606536d6.1
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756361569; x=1756966369; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cnbLMdPiCwmvYLji+zAdnqkI0zKaKd1dlWQ6sfyOcHc=;
        b=JgX0VfDF4Po+ZP+zL7QxPEigpxgiqg5RoUnF9ymv+BkByALUCuUv+lCA/aoVCdjd4s
         zbDLcLSNJRg1x3HH1fidcR8ITT97YEWLDG1LO0/KyX5Fa/leMaZTnu5SM47wCU+3kZ4v
         d6qxh9gti3Xvp1dkqhDTE4MKLDu9yBLKmuMoWgiaEtXHv0Q9DipSiAPngkxVsDw1Prll
         MVgIicocGerjsAPNDHAsv3t8THkpLcv4We7K3Ihjrlc4ercF7KsCP8xIaXym94OlVxH5
         45Y3E46xpk4tlnZ+CCDNLWs6Rv6XPVliyemQNFaYDApk4oOmXlDeF9Kg+MuJWw2Q+wlL
         cRag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756361569; x=1756966369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cnbLMdPiCwmvYLji+zAdnqkI0zKaKd1dlWQ6sfyOcHc=;
        b=aba9Wuszxu55vYxEEgY0+8nMclZe+kWC0wdJzVCBTjmRK3neBF3g+s7pUzp53b2dum
         J4GwtF1cfc0aTmaj0e/SYJ26ZOrs4ocmYJ3V2bthQtcw2qSrHRKZHYX/3qXqCe6jFV6N
         qGjF1ghYh3WOWgqsVCOQbT4LfFuxHvjIz1GugUtOT5GZN2VBjGCAh7LLY+qgUSB+YBCO
         B3LCcT6CTQTspYIpKedx/VxLc5zsNtbRpqDS/a5hnpt6NUzVUpxORV0TPqcdOLGusnXI
         tXjClaldCv3woG8USodAX2vtSTzR0HKhTlx45eyBMiVE87Kq2PzTPW9NK6h/m8377e8M
         64kQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+bfLz6aAk3tFNeR2o6EOmLG1KxXL9FIMMjvbmRlcBxdXhvrGmZ4bktlV9nTOo6V2NJmpmHEyTDw==@kvack.org
X-Gm-Message-State: AOJu0YwY33+Dh4Uv+KQC912+LGDqBGNDP8KV2x4tbVybi1qvlYfb5Q2N
	ynYKZSeqM58AfMPfEDYUoCZ6CCj90fBOVSbhI9efCsmeANliKny/l7bHYUuOYRamda04Lb8FWlX
	KSbukGgPQ545FN4eh5yEr3Mk1LKBp6mI=
X-Gm-Gg: ASbGncsgihPZ0OHZWNeHllC3ystCaJCgsKWvDA/AC1Hn2K4w9hWK/uofgvDJvoGE8H9
	fZI9sz1GabalPb1+zto3xzIdlW4vCpfuBIAPTVVtUO8ixc+YIGLmLp3h6GKn2Q1+Ng/AmkUHr1c
	EhWx67Om40BNvonjaLd/wsLEpfUinOO6xB/H5vrp31RgdZPetQDKr/CnaenoOyRelgftABJJMMo
	fjEFRxFBuD1mUZ6HJODdAeUlDWIhWlFU+xIjQ4=
X-Google-Smtp-Source: AGHT+IHWEqZvffeKo8kRXTyycXIE2aUiikzOvRaEpoYzy2gliBcy83nY3larYygf49dGuEclkaz2O/Wg5aGu2qNho5M=
X-Received: by 2002:a05:6214:3293:b0:70d:9f91:642a with SMTP id
 6a1803df08f44-70d9f916d1bmr193078726d6.56.1756361569344; Wed, 27 Aug 2025
 23:12:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <20250826071948.2618-5-laoar.shao@gmail.com>
 <bca7698c-7617-4584-afaa-4c3d2c971a79@lucifer.local>
In-Reply-To: <bca7698c-7617-4584-afaa-4c3d2c971a79@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 28 Aug 2025 14:12:12 +0800
X-Gm-Features: Ac12FXwA8AE2T9DT0lZOOileufyZaAaDfXMTycJckIK5rbkI3PvbmFzzlT8sNXM
Message-ID: <CALOAHbDxxN8CsGwAWQU4XRkG8NvU-chbiDv=oKW0mADSf1vaiQ@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 04/10] bpf: mark vma->vm_mm as trusted
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 386B5140003
X-Stat-Signature: b334swhz8jijptfbama1zzjkdedaukyi
X-Rspam-User: 
X-HE-Tag: 1756361570-119024
X-HE-Meta: U2FsdGVkX1+vdHoX66lgYBVDbi4KeCSUTF9ofTWSIS2lZsX/U/zxaDK1F/uTo212pdOj1wvq7SI3mftknae+/3nM3RH4zvxgREkHNxA2r4QcqeG4d9GoC8ONA3kbLFW3i/e/XhFiQiymgUxJww/5VAuO839WPFCZEF/yCoo72W+4r3FP89x8BxaNTlDFB/qGeCXr6LmADfERCMS4ETidxgOnDoJU5dm3VRrEooB27z4iDt708Oc5R8gJtUmVnci8qF4AFTpWoAqbYI1mU2YzFS+pDrDqPEWNn30/q1h2XG3NMsR5AKYV8DkLjqB9uQP1U52x9UIfpq5RcgX1KjFEVg3MWWjiBHVmXtRDdoO7Wj4dvc0BH7xXIQugrZKsqZOAYa3b/UuFsGomzFxdxOQpmaWNOObhqBScotvY9Bg9QGZgKvKK0r31A55C+so1Ua03bvD/cRUnKIQB2yHDSTCtskpsAjgevg2YRJiPMasogjzJ00gPk1pypXiaAJ16/p33w2mf/3HZG/fN5gF/MgmaR7u6TrqgODS1O+BbyFuMFBkkGyI0HVKFJO2ajdXDWF2w0WBAIprFrgX38zriGVvZqkb4eF0WKWv9njWLZQgA19e3O5aEKNtVhrX9IzVFmL+ASg9LbTMpMyeZhUn6VWRGEYEL8sDKWe4Yy9SzPh7eVLDHD4rBN2CCWX/auCulB9LSEpkwEIuJMPR25ORIYTWXxMJgwgEiFvdtfOWfZUCUm0DSiu1w3+5j9TjfsDnKPefB5kZNd2smkHDb/9SASGWsDjPhGtlSXwgMGcjJjByirrcvzvbE+4YG90+ctrbO+hjoBk2OlZA1EdMbsCC5ifA6Jm2KW3rFApRY/BLNFm5ldzQmNA7uwBeztccUGGBGHIcJh+mJfQNvwCFNLK7laSK4XzGb836h1OTNEmFbbb4DtJft5frznekUULB/brKlaiefTXX7pP529he5DbsDeZ9
 AhJmoY6I
 lHM8JAF0yC4+BCFywlhX8fTR137bwdrYvf7vZbaz2YgCkgems8lKQDS+PuVbU54wywV62Tvn+oYlMiFll79gccxfvSN6IfUoV1bla
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 11:46=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Aug 26, 2025 at 03:19:42PM +0800, Yafang Shao wrote:
> > Every VMA must have an associated mm_struct, and it is safe to access
>
> Err this isn't true? Pretty sure special VMAs don't have that set.

I=E2=80=99m not aware of any VMA that doesn=E2=80=99t belong to an mm_struc=
t. If there
is such a case, it would be helpful if you could point it out. In any
case, I=E2=80=99ll remove the VMA-related code in the next version since it=
=E2=80=99s
unnecessary.

>
> > outside of RCU. Thus, we can mark it as trusted. With this change, BPF
> > helpers can safely access vma->vm_mm to retrieve the associated task
> > from the VMA.
>
> On the basis of above don't think this is valid.
>

--=20
Regards
Yafang

