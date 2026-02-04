Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B1DBE8B385
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 00:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541606B0005; Tue,  3 Feb 2026 19:08:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519386B0088; Tue,  3 Feb 2026 19:08:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EDBB6B0089; Tue,  3 Feb 2026 19:08:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 251E46B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:08:58 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3744140611
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:08:57 +0000 (UTC)
X-FDA: 84404838714.23.52256BC
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id D44011C0007
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:08:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BQ7YXjas;
	spf=pass (imf21.hostedemail.com: domain of fvdl@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770163735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6uel3NpK6iI8vR6uEGTqIKNBHcIHI6ugXqm6OzGBCug=;
	b=bOasJ52HykkaW6ZdDzJtnnIAOn4OvLphSYGlFa2x1HOGJDvrlL6R5DhdBpm2G5VvDboSPa
	BsKCMwTJeNdVUnI49eXhdkG5xxv+4tAMRps8djs+sk5gmEQFOEVvStJzAt+UDy6snk+qbe
	+wJDsjmzhoVH36entAkBdfbmmu7OXKM=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BQ7YXjas;
	spf=pass (imf21.hostedemail.com: domain of fvdl@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770163735; a=rsa-sha256;
	cv=pass;
	b=VCkn2I5eAEImXDQjK5cyPmg+Yqs5T1ctZIU/WrioW0akUeRpBhqx/x2OBDne/UIxa/Nmkm
	zYQZMPdVtaONwyeVs2nHmAbsUaJWmSrUTzFkcLV6A90Bxj+FUCfeQZWMw7oPvc+cfBYx73
	W4sBW2ZDR0RiZpZiX2pEcG8MNwjQAM4=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5033b64256dso83741cf.0
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 16:08:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770163735; cv=none;
        d=google.com; s=arc-20240605;
        b=cmvXlDdoTK8uQuSHWzodzZ7/VKwnYJirFTd7bYdskjTTanGMi6ypYtHIi9uouxyAv2
         Qn7xlHO1mNHB59JQspQ6S+kl+GD52UxGJsDK/KFnDClluk/X60g3w7JyNILD5AyPtm+N
         RkXTEmO3NXSeijjvrJGcfngV4ECVHIyz2fMZ+GdeRnvuZB/S4G5XZL8I4PXP9+Z+wjnW
         GBB95To8WMg3TH1WxPd518P4T3YEFZmlKrtZ5cI+UuNSXVcefwEHn4NY3t+yMFkuEVPn
         Btoo/Svd/rpZTrpJlDbLOP5PLLPUdkLCAnH5IBIWhIUIRZa3RZfjk4dtPJSDtz49WRCs
         AiMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6uel3NpK6iI8vR6uEGTqIKNBHcIHI6ugXqm6OzGBCug=;
        fh=e3oUrVtMqkBpOH7EMO86/NzjmfU/Tcons5TjyPXBkbM=;
        b=SC5GEt9aMf52M25frUKk2BBt7EmM7Fjq0lLmZXlcaEHYu08DErpbHesX3tnU9uD02f
         uQEBOi+7T+vjbB0QcDy9tCIDhG9bdjCd4Qf1uQ2MowVeT/LZftXgwgAcLXyVDkWruYAC
         uldtNxcq9SNb0or4xXm/xlw7dpWx2dr2OgIVpr9bcG9Yf50o1nKNWVIq8WEyaewGHMJr
         gP1xbHrzCJijbUIFQ1h/ULKoIVJ2ekmbCOX+TJiUaPtxyEYa2PVTTNJ+MvA7aMbliq0k
         wlTTuGnV+48qNxG7FinEj6d+1wpSBEV8REsVK0mFMBIzPtBxf0z1IghebpwI3UFe7xUw
         0gtg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770163735; x=1770768535; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6uel3NpK6iI8vR6uEGTqIKNBHcIHI6ugXqm6OzGBCug=;
        b=BQ7YXjashp0tSnOHhoeIvPVkbxQmGin800L+Xyp2brun/ANLUs2KH7W9HxPbCA7cto
         YTZVwzCpX1HnjIhWwN/Wl/AX7EaoL0XJGKIusQnPQ+x/WCBdPM1O+GzCTMWB96z+C8zK
         9VvLe09rg4tHYQX2sPJSAX54WIdwgWltpDvm+Zchn1luwqqk9zYkN6v6O0nLaep+mNhd
         UHu3Fh8nNsdhC9SFtQrhwDuO2kc/QBswUFeZ374f4SmkKlcoPfN+KohPphzeLyLSXtuV
         ZAdTkmYhEHtpP2WNo7v2iZ8a+Ia5+chPsswGp9pF/MbZg6vuQ5s3YOtaAH0QPjaKBTju
         2h1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770163735; x=1770768535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6uel3NpK6iI8vR6uEGTqIKNBHcIHI6ugXqm6OzGBCug=;
        b=BL18681vVdwy5vUhB41QDtEqzsRFJPqZamf4a6MhnYLFuZksmQuoA2SDOb0cnA953M
         gnp1Vy4dbudQEIqlU/4umPtsCoE65r3N2Y+kylz1HM+V+lu/5moobO1ZQk9Hk4zJWISF
         1quammJhRfE4CT2MVEwzD3pwtUBfwgPkAnxyKMXPKEm1ssFy3l9JXUPpyu0Rmdgzr2tP
         rc/zEXjK/7/pnb95kFpE0OhP0KVAQfhwlbkp2TGkMUES4XYzEyIfKyy5sBj0VfoMOrol
         T3fiwwDFgQzZfIWQYO5/2jZi9kyQIjkZBCdF27PNVeGHw0woPP3U9lzmH8LiM87SwSV5
         bYRw==
X-Forwarded-Encrypted: i=1; AJvYcCVJ1aPZoiWt8aYJaRizcGRg4KelTjGa7U9yBjR/sLJfD8e7PwicvCsjpX7MJjSzQ7hei4wZeEf0jg==@kvack.org
X-Gm-Message-State: AOJu0YxM2QrLahzAD5agoVl67pFYB91wPhAIB0dkdhly91LyPmIYKYTC
	p19fQ9qDXKmrU9XeFtnKSHie46YIYCtBir0sax4j/muEroPNpXj+V/vs94nuVDzwNkYWxJC8Fse
	JKEiZv6rwoY4I3V4qG0kWOuX6/uXqFtFh2o07TxuV
X-Gm-Gg: AZuq6aJk498YS5Vca8p996O/cdP3Wna5mqVQdwCFy7SV+qhsADVy/4xi6hxvalB14C5
	HPLmxDOWeT86Ft/bWD3ZQYfmOcTBN2VBVDsYDRiSdEopR7MKansheDTj9BFQ2j3bWdrEv+az0CO
	rtiVPxT8UL0THTFfMdY68o97/UKAGViggax/iDk3eZDuKIb+3Egsd+sRA8SnL9Rvq1rv0FP7RUM
	DW4y6kXHaV4KqebH3p+Eujw5eJDXN2OpVeZeADaYtf1l5LgApAfQp5yj8M43N1Pf43QMxg=
X-Received: by 2002:a05:622a:ca:b0:4ed:ff79:e679 with SMTP id
 d75a77b69052e-5061d7c1423mr2318661cf.19.1770163734442; Tue, 03 Feb 2026
 16:08:54 -0800 (PST)
MIME-Version: 1.0
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <3561FD10-664D-42AA-8351-DE7D8D49D42E@nvidia.com> <20f92576-e932-435f-bb7b-de49eb84b012@gmail.com>
In-Reply-To: <20f92576-e932-435f-bb7b-de49eb84b012@gmail.com>
From: Frank van der Linden <fvdl@google.com>
Date: Tue, 3 Feb 2026 16:08:41 -0800
X-Gm-Features: AZwV_QioWK44SReIQj0qONbnl1TvrOX3rgEQcTXIFUqF4yALGxraNcehCyHlxuQ
Message-ID: <CAPTztWacSRGa36qv7jmGL9bL600t8K8x+31tbPEsvfY=qrnsNw@mail.gmail.com>
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
To: Usama Arif <usamaarif642@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, lorenzo.stoakes@oracle.com, linux-mm@kvack.org, 
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org, 
	baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, 
	vbabka@suse.cz, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D44011C0007
X-Stat-Signature: hg3bxbxmnda7iea38n45qwoj7mskzxbm
X-Rspam-User: 
X-HE-Tag: 1770163735-185366
X-HE-Meta: U2FsdGVkX18YKzsyjBdX3aYnWDY0apaoYxxapX2MMv8P7xdmDiWGwspByJLDkAUPktR/Vm1SVFK04XJa0KhM2WSz+dE6PQftWViY8WeT4E8PLVzkZ131FsFgiSVRxFKHtk+Jx2LvPxmCXHvO16/tcW1PNw/jzZMlHt9DxIy9ptPAqGDlTZVapLsneurrDkALIur+xuG7NaGCkMstD4wQHRwcoN25Mh/TiCOa5cAPdfvSz3dGUXuOFbJ3RSQ3d+6abxBK4bmWowZw1R8Bb9hifWvn4+aww8jBwhsHIdvqeRsv4f87pN5vvNamZrzzB69poPakMyWw4KQgkExrQqIPimYzED6umTHOeBDrT1og3r6WkfieAUmlUFlp7PPOmzROa5q36MX2pOUsVkpZZ6lk/obRluL7IAdrWjSx0cIDygY71NHv5F76wztLvSCGdbYZpB3ztfwDyTCRwBslrp7+ckKUFMrncEFZ+A7KRKz5NfT1XrWB8uJQDvFbJW/MOxvLYPmTQZgrAbNDLLL7e1l8YLI+YvczSve1BJYRoW7aDYphUG8ypAuRHJj+oIlL1/XK6ua6OTFL89oZ8FLPAQDwyDh0c2rC7AT2VHaiUJVbMpsFJEIOp3G0PtajdlZrk3ARb83xAOuHk3JdwciMoRTAuOtgPWEjIoHa/gagydMJcwIY8b6d9uCppQD9oGfw7kXNzsrXKg292hxhAMCQx7oHu24PKYCAuab6kia2XTA18ReoG++OG3lFIFM1ycUD7iJbcSsSeQ/EdIQ2A1B6ZL/Dvb2bMRFPsD+TEcs46jwzz7OhhqL/FimMn9T6ZYfUXL9oAdT4H5BeccZsE61lCML1i6y++Hd7/ygNSau+mTS17X3tpaKWd2q08Q+nC16wGy+yfuCMS/ekwu+JltGjkZMi+h8UVNzYPtyh+HONLFqcxgTSknfSVc6ueLsTTrPVZuMIRR5Lr4V9/7bnuV1vBu1
 hSvNqu+d
 880KPohlpSQZGyvt7+lCSsH7WAwTcfnnCVIz7zqt/Z2GwPK75I6gG4ECWPmqPBiIaDP3M6eNn8H5SsmfYlXD9uA82HLaOtqAiE1NO0S3iQ2BO5/6HIB/sXmAWz31Tktqdwq81B0EHMyvGcSAPBrl6H2PHWxmmmV0RSbzJ5NWKAns8nvJbFAhM0syoxWN3tLMj7Q+ghHFAWycsELmYDxP/oaYutiMsy7y7BmXsDxVATL+yNU3gVrsuHmY9uYlsjdqKOVHcwSfUwXk97x0RMOD59Dt1rfOW1XO+Y1V8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 3, 2026 at 3:29=E2=80=AFPM Usama Arif <usamaarif642@gmail.com> =
wrote:
>
>
>
> On 02/02/2026 08:24, Zi Yan wrote:
> > On 1 Feb 2026, at 19:50, Usama Arif wrote:
> >
> >> This is an RFC series to implement 1GB PUD-level THPs, allowing
> >> applications to benefit from reduced TLB pressure without requiring
> >> hugetlbfs. The patches are based on top of
> >> f9b74c13b773b7c7e4920d7bc214ea3d5f37b422 from mm-stable (6.19-rc6).
> >
> > It is nice to see you are working on 1GB THP.
> >
> >>
> >> Motivation: Why 1GB THP over hugetlbfs?
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> While hugetlbfs provides 1GB huge pages today, it has significant limi=
tations
> >> that make it unsuitable for many workloads:
> >>
> >> 1. Static Reservation: hugetlbfs requires pre-allocating huge pages at=
 boot
> >>    or runtime, taking memory away. This requires capacity planning,
> >>    administrative overhead, and makes workload orchastration much much=
 more
> >>    complex, especially colocating with workloads that don't use hugetl=
bfs.
> >
> > But you are using CMA, the same allocation mechanism as hugetlb_cma. Wh=
at
> > is the difference?
> >
>
> So we dont really need to use CMA. CMA can help a lot ofcourse, but we do=
nt *need* it.
> For e.g. I can run the very simple case [1] of trying to get 1G pages in =
the upstream
> kernel without CMA on my server and it works. The server has been up for =
more than a week
> (so pretty fragmented), is running a bunch of stuff in the background, us=
es 0 CMA memory,
> and I tried to get 20x1G pages on it and it worked.
> It uses folio_alloc_gigantic, which is exactly what this series uses:
>
> $ uptime -p
> up 1 week, 3 days, 5 hours, 7 minutes
> $ cat /proc/meminfo | grep -i cma
> CmaTotal:              0 kB
> CmaFree:               0 kB
> $ echo 20 | sudo tee /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_huge=
pages
> 20
> $ cat /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
> 20
> $ free -h
>                total        used        free      shared  buff/cache   av=
ailable
> Mem:           1.0Ti       142Gi       292Gi       143Mi       583Gi     =
  868Gi
> Swap:          129Gi       3.5Gi       126Gi
> $ ./map_1g_hugepages
> Mapping 20 x 1GB huge pages (20 GB total)
> Mapped at 0x7f43c0000000
> Touched page 0 at 0x7f43c0000000
> Touched page 1 at 0x7f4400000000
> Touched page 2 at 0x7f4440000000
> Touched page 3 at 0x7f4480000000
> Touched page 4 at 0x7f44c0000000
> Touched page 5 at 0x7f4500000000
> Touched page 6 at 0x7f4540000000
> Touched page 7 at 0x7f4580000000
> Touched page 8 at 0x7f45c0000000
> Touched page 9 at 0x7f4600000000
> Touched page 10 at 0x7f4640000000
> Touched page 11 at 0x7f4680000000
> Touched page 12 at 0x7f46c0000000
> Touched page 13 at 0x7f4700000000
> Touched page 14 at 0x7f4740000000
> Touched page 15 at 0x7f4780000000
> Touched page 16 at 0x7f47c0000000
> Touched page 17 at 0x7f4800000000
> Touched page 18 at 0x7f4840000000
> Touched page 19 at 0x7f4880000000
> Unmapped successfully
>
>
>
>
> >>
> >> 4. No Fallback: If a 1GB huge page cannot be allocated, hugetlbfs fail=
s
> >>    rather than falling back to smaller pages. This makes it fragile un=
der
> >>    memory pressure.
> >
> > True.
> >
> >>
> >> 4. No Splitting: hugetlbfs pages cannot be split when only partial acc=
ess
> >>    is needed, leading to memory waste and preventing partial reclaim.
> >
> > Since you have PUD THP implementation, have you run any workload on it?
> > How often you see a PUD THP split?
> >
>
> Ah so running non upstream kernels in production is a bit more difficult
> (and also risky). I was trying to use the 512M experiment on arm as a com=
parison,
> although I know its not the same thing with PAGE_SIZE and pageblock order=
.
>
> I can try some other upstream benchmarks if it helps? Although will need =
to find
> ones that create VMA > 1G.
>
> > Oh, you actually ran 512MB THP on ARM64 (I saw it below), do you have
> > any split stats to show the necessity of THP split?
> >
> >>
> >> 5. Memory Accounting: hugetlbfs memory is accounted separately and can=
not
> >>    be easily shared with regular memory pools.
> >
> > True.
> >
> >>
> >> PUD THP solves these limitations by integrating 1GB pages into the exi=
sting
> >> THP infrastructure.
> >
> > The main advantage of PUD THP over hugetlb is that it can be split and =
mapped
> > at sub-folio level. Do you have any data to support the necessity of th=
em?
> > I wonder if it would be easier to just support 1GB folio in core-mm fir=
st
> > and we can add 1GB THP split and sub-folio mapping later. With that, we
> > can move hugetlb users to 1GB folio.
> >
>
> I would say its not the main advantage? But its definitely one of them.
> The 2 main areas where split would be helpful is munmap partial
> range and reclaim (MADV_PAGEOUT). For e.g. jemalloc/tcmalloc can now star=
t
> taking advantge of 1G pages. My knowledge is not that great when it comes
> to memory allocators, but I believe they track for how long certain areas
> have been cold and can trigger reclaim as an example. Then split will be =
useful.
> Having memory allocators use hugetlb is probably going to be a no?
>
>
> > BTW, without split support, you can apply HVO to 1GB folio to save memo=
ry.
> > That is a disadvantage of PUD THP. Have you taken that into considerati=
on?
> > Basically, switching from hugetlb to PUD THP, you will lose memory due
> > to vmemmap usage.
> >
>
> Yeah so HVO saves 16M per 1G, and the page depost mechanism adds ~2M as p=
er 1G.
> We have HVO enabled in the meta fleet. I think we should not only think o=
f PUD THP
> as a replacement for hugetlb, but to also enable further usescases where =
hugetlb
> would not be feasible.
>
> Ater the basic infrastructure for 1G is there, we can work on optimizing,=
 I think
> there would be a a lot of interesting work we can do. HVO for 1G THP woul=
d be one
> of them?
>
> >>
> >> Performance Results
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> Benchmark results of these patches on Intel Xeon Platinum 8321HC:
> >>
> >> Test: True Random Memory Access [1] test of 4GB memory region with poi=
nter
> >> chasing workload (4M random pointer dereferences through memory):
> >>
> >> | Metric            | PUD THP (1GB) | PMD THP (2MB) | Change       |
> >> |-------------------|---------------|---------------|--------------|
> >> | Memory access     | 88 ms         | 134 ms        | 34% faster   |
> >> | Page fault time   | 898 ms        | 331 ms        | 2.7x slower  |
> >>
> >> Page faulting 1G pages is 2.7x slower (Allocating 1G pages is hard :))=
.
> >> For long-running workloads this will be a one-off cost, and the 34%
> >> improvement in access latency provides significant benefit.
> >>
> >> ARM with 64K PAGE_SZIE supports 512M PMD THPs. In meta, we have a CPU
> >> bound workload running on a large number of ARM servers (256G). I enab=
led
> >> the 512M THP settings to always for a 100 servers in production (didn'=
t
> >> really have high expectations :)). The average memory used for the wor=
kload
> >> increased from 217G to 233G. The amount of memory backed by 512M pages=
 was
> >> 68G! The dTLB misses went down by 26% and the PID multiplier increased=
 input
> >> by 5.9% (This is a very significant improvment in workload performance=
).
> >> A significant number of these THPs were faulted in at application star=
t when
> >> were present across different VMAs. Ofcourse getting these 512M pages =
is
> >> easier on ARM due to bigger PAGE_SIZE and pageblock order.
> >>
> >> I am hoping that these patches for 1G THP can be used to provide simil=
ar
> >> benefits for x86. I expect workloads to fault them in at start time wh=
en there
> >> is plenty of free memory available.
> >>
> >>
> >> Previous attempt by Zi Yan
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> >>
> >> Zi Yan attempted 1G THPs [2] in kernel version 5.11. There have been
> >> significant changes in kernel since then, including folio conversion, =
mTHP
> >> framework, ptdesc, rmap changes, etc. I found it easier to use the cur=
rent PMD
> >> code as reference for making 1G PUD THP work. I am hoping Zi can provi=
de
> >> guidance on these patches!
> >
> > I am more than happy to help you. :)
> >
>
> Thanks!!!
>
> >>
> >> Major Design Decisions
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> 1. No shared 1G zero page: The memory cost would be quite significant!
> >>
> >> 2. Page Table Pre-deposit Strategy
> >>    PMD THP deposits a single PTE page table. PUD THP deposits 512 PTE
> >>    page tables (one for each potential PMD entry after split).
> >>    We allocate a PMD page table and use its pmd_huge_pte list to store
> >>    the deposited PTE tables. This ensures split operations don't fail =
due
> >>    to page table allocation failures (at the cost of 2M per PUD THP)
> >>
> >> 3. Split to Base Pages
> >>    When a PUD THP must be split (COW, partial unmap, mprotect), we spl=
it
> >>    directly to base pages (262,144 PTEs). The ideal thing would be to =
split
> >>    to 2M pages and then to 4K pages if needed. However, this would req=
uire
> >>    significant rmap and mapcount tracking changes.
> >>
> >> 4. COW and fork handling via split
> >>    Copy-on-write and fork for PUD THP triggers a split to base pages, =
then
> >>    uses existing PTE-level COW infrastructure. Getting another 1G regi=
on is
> >>    hard and could fail. If only a 4K is written, copying 1G is a waste=
.
> >>    Probably this should only be done on CoW and not fork?
> >>
> >> 5. Migration via split
> >>    Split PUD to PTEs and migrate individual pages. It is going to be d=
ifficult
> >>    to find a 1G continguous memory to migrate to. Maybe its better to =
not
> >>    allow migration of PUDs at all? I am more tempted to not allow migr=
ation,
> >>    but have kept splitting in this RFC.
> >
> > Without migration, PUD THP loses its flexibility and transparency. But =
with
> > its 1GB size, I also wonder what the purpose of PUD THP migration can b=
e.
> > It does not create memory fragmentation, since it is the largest folio =
size
> > we have and contiguous. NUMA balancing 1GB THP seems too much work.
>
> Yeah this is exactly what I was thinking as well. It is going to be expen=
sive
> and difficult to migrate 1G pages, and I am not sure if what we get out o=
f it
> is worth it? I kept the splitting code in this RFC as I wanted to show th=
at
> its possible to split and migrate and the rejecting migration code is a l=
ot easier.
>
> >
> > BTW, I posted many questions, but that does not mean I object the patch=
set.
> > I just want to understand your use case better, reduce unnecessary
> > code changes, and hopefully get it upstreamed this time. :)
> >
> > Thank you for the work.
> >
>
> Ah no this is awesome! Thanks for the questions! Its basically the discus=
sion I
> wanted to start with the RFC.
>
>
> [1] https://gist.github.com/uarif1/35dcd63f9d76048b07eb5c16ace85991
>
>

It looks like the scenario you're going for is an application that
allocates a sizeable chunk of memory upfront, and would like it to be
1G pages as much as possible, right?

You can do that with 1G THPs, the advantage being that any failures to
get 1G pages are not explicit, so you're not left with having to grow
the number of hugetlb pages yourself, and see how many you can use.

1G THPs seem useful for that. I don't recall all of the discussion
here, but I assume that hooking 1G THP support in to khugepaged is
quite something else - the potential churn to get an 1G page could
well cause more system interference than you'd like.

The CMA scenario Rik was talking about is similar: you set
hugetlb_cma=3DNG, and then, when you need 1G pages, you grow the hugetlb
pool and use them. Disadvantage: you have to do it explicitly.

However, hugetlb_cma does give you a much larger chance of getting
those 1G pages. The example you give, 20 1G pages on a 1T system where
there is 292G free, isn't much of a problem in my experience. You
should have no problem getting that amount of 1G pages. Things get
more difficult when most of your memory is taken - hugetlb_cma really
helps there. E.g. we have systems that have 90% hugetlb_cma, and there
is a pretty good success rate converting back and forth between
hugetlb and normal page allocator pages with hugetlb_cma, while
operating close to that 90% hugetlb coverage. Without CMA, the success
rate drops quite a bit at that level.

CMA balancing is a related issue, for hugetlb. It fixes a problem that
has been known for years: the more memory you set aside for movable
only allocations (e.g. hugetlb_cma), the less breathing room you have
for unmovable allocations. So you risk the 'false OOM' scenario, where
the kernel can't make an unmovable allocation, even though there is
enough memory available, even outside of CMA. It's just that those
MOVABLE pageblocks were used for movable allocations. So ideally, you
would migrate those movable allocations to CMA under those
circumstances. Which is what CMA balancing does. It's worked out very
well for us in the scenario I list above (most memory being
hugetlb_cma).

Anyway, I'm rambling on a bit. Let's see if I got this right:

1G THP
  - advantages: transparent interface
  - disadvantage: no HVO, lower success rate under higher memory
pressure than hugetlb_cma

hugetlb_cma
   - disadvantage: explicit interface, for higher values needs 'false
OOM' avoidance
   - advange: better success rate under pressure.

I think 1G THPs are a good solution for "nice to have" scenarios, but
there will still be use cases where a higher success rate is preferred
and HugeTLB is preferred.

Lastly, there's also the ZONE_MOVABLE story. I think 1G THPs and
ZONE_MOVABLE could work well together, improving the success rate. But
then the issue of pinning raise its head again, and whether that
should be allowed or configurable per zone..

- Frank

