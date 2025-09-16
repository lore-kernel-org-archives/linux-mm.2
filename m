Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 194F4CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 23:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E4D48E000E; Tue, 16 Sep 2025 19:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BBE48E0001; Tue, 16 Sep 2025 19:29:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F94C8E000E; Tue, 16 Sep 2025 19:29:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F01858E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:29:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A8DF140323
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:29:04 +0000 (UTC)
X-FDA: 83896706208.02.937AD3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7B20820005
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:29:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YSH/P5vr";
	spf=pass (imf13.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758065342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LGvykd1nT8oriIHpNmzR+OSQDJaKsFdiiA4ZAshy8xM=;
	b=6X+pgVWJFNzqzFoYYIO9ruOg2ZEvGuraj4JGSc+7/spt/TElDnrykVIOJxw6maCZKuQ8dM
	cxjJv9r0xFPjKFz3vn4l+AjLJ3nGGRWFko+nl/GM/2fqbhil/zxOm4/2pkWwM/4CGXrX3S
	TdC1iKz3M2vJyHThAJY/cPjAUg0SvJs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YSH/P5vr";
	spf=pass (imf13.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758065342; a=rsa-sha256;
	cv=none;
	b=CzO+zwLYiQus6LG7PdGiRg1vmiv3gv2AuT9/Lqus8vYAarLvxZJCqLnUVurN+0yWqU5xHP
	F0m1xA7KgBsxfCAoufJV66ShJ+FfdKvER5EbrVv3aRCZ3AdIO1wAAXjLIjn4Uh8mchQ00Y
	rb2i0SCWitfx2LuI46tKkUPyBqUMpXA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E05B44B84
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10095C4CEFD
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758065341;
	bh=LGvykd1nT8oriIHpNmzR+OSQDJaKsFdiiA4ZAshy8xM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YSH/P5vrx8CKIXAvy/xTBRiRAVNmMdR+OCHwSGi4G0vl/AI7y9/IRaKALqjvLlEMC
	 djUAnQxCg09Xq3C9p+iZ23fXMiuQqEe48LjSeoBgN3ku6HojFPrV3LLsyjFp6W5OmA
	 XS/dYglm4VWX1vmHYiuO1EX0U+FJk10RdGJiEo9AZLLt+smfKCQrx91jrDY7SgL3Ib
	 uMngR1E9dF933xwHG2I0PymwolYgm0MHGa9njkjvrC83+031Al2Loi319WVNNslji3
	 J9uaZKM5j/rBKpUslLu3NjKt+GbOVpY7FpDDN3r+/tXIx4301fKPHOBnTDNdlqWJqN
	 CujrOZbTRqOBA==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-71d603b674aso41736277b3.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:29:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXeod5wIUJJ3eyqw9AGPTX1qysohvgRgr9NAOSQQXCeMUApJKTFyi4v4akDsbXfBppIlU75JUHz1A==@kvack.org
X-Gm-Message-State: AOJu0Yy5MdqQ1b2fDkkgS4BD3YJYlIsxYnVpuwPSiN9kA1paNYqbuVcT
	VnNV2U5bgACvEx7bXIkSFXEmv0SXDWDEzvMz1eOi2wmgOoP7oQfJs+JH4dIpZKvYZ6mv+VKBigL
	HSTiko3sXOM78yxBHyqI05RPs+XAfSV13gosLJi/ikQ==
X-Google-Smtp-Source: AGHT+IGij916d5sP85+tuss02Upn/245YaMM5bz3jwhN4dO54AsUWUls4eLhNMOciKeNZilYYN0w64QPz6dGBbFqQpU=
X-Received: by 2002:a05:690c:600e:b0:723:92c4:beeb with SMTP id
 00721157ae682-73892a629e7mr597217b3.40.1758065340338; Tue, 16 Sep 2025
 16:29:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-2-ryncsn@gmail.com>
 <CAGsJ_4w2GqGj8HZMfwndsWu7qkORqsnaw9WwhmQS=pW4gR7nEA@mail.gmail.com>
 <CAF8kJuNbUyDWcJ13ZLi-xsiYcbY30w7=cFs7wdxszkc7TC4K2Q@mail.gmail.com> <CAGsJ_4wKWem-STYAnh_0EgSFKzzs1M1c7wz6K82wLt6T6JEw9A@mail.gmail.com>
In-Reply-To: <CAGsJ_4wKWem-STYAnh_0EgSFKzzs1M1c7wz6K82wLt6T6JEw9A@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 16 Sep 2025 16:28:49 -0700
X-Gmail-Original-Message-ID: <CACePvbU8cUs-wwPsXkZ24EWga5bXxxUGSCT18rKAWFYn5w9rpw@mail.gmail.com>
X-Gm-Features: AS18NWDaf018NL2Ds7liDcEY9OWYh3Bgw6P4zsvyeNjVw4_3JGi9egdPzhgDInI
Message-ID: <CACePvbU8cUs-wwPsXkZ24EWga5bXxxUGSCT18rKAWFYn5w9rpw@mail.gmail.com>
Subject: Re: [PATCH v4 01/15] docs/mm: add document for swap table
To: Barry Song <21cnbao@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7B20820005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 9dpiddfpokiinxi6k4tbozq4fz7m8sc7
X-HE-Tag: 1758065342-234100
X-HE-Meta: U2FsdGVkX195lUelJWa+JHV11iXl4RAAoJaPbOVmyKcy9KU8dHdm3+UYNVadJDaB39YtscRWLuwW+D0bWXSr/9IpluyzjG9cGiYxEqLncAMNkrMsuKSZTMcwEpW25K/85aUDsDxwVIX54w8aqA3Iwmjm06ULAqCuTxEkKgT1ojGTSj72ihPwQBn3o5B3kNt9159WLJNWEI9vYnpbFawsB5izmrsRf8mT1zKUp48v5b9HwptJk87zzXKazcRW2CJwSxPZqSUTRcRHN7zdFBYVGrXTCKC0bMa1FsrkYMBmOcbWgMKciKl9GWtDAQovstzAZzRBjG5TgUW8OlJ5CRbC0capbcdAYC910u00VpiLcjkaAK4Ulny662QxoDkcllxmz6UMcrycmyg4rpYzlReyH8snRgmKwiH1pCGrx+PXsIE/NdTvtdQa7OYNBmmGc6VdfnbaXfLOu0It9Ux60fbugcM2z8NL0BmEvkR2L0AAMcwUyNYKwruwikCf5iRtQkaCbUzMUInv8mveBrTinlHlSrVRPGM8s5NrJW9RwZA0/aooq1LZs2KL9EmAsqV9qSEaJLiKCmNgAc/g4JvdmroJGqgnUZYUtGpJCkInbhCO2rPfYbCJuRZv17WMMFMm8Jjwum1nHQwdA2Z8k0M0/inMgHaS+OGgNAWT4NtC2Dy3PmESzT+4KowQzMiI9zmqztBuAd1xStbnX982hIXzPZtauubTqxYQ+9rW+GoolKw58ehQph71zxFMyEbtXuPuv7KHZqk1Stl44MYuV+nNxahQn/Rv/jIAN3Fe0gkTCiY7mFeWnK0FM9+c5vGnt4BaIvjH8T30QxHnuLgLqybncGVuNBFefGnQoCfmYlqpAYCTuuSw2gcY/JUKu7VGQkNSNtXCnludYCp2/3mOYv1mJX0+FF0QT+mbVzxaVwalbCO4/AJ2fxHeiFxM549wE1P7GmoPVnHnZVt6Zhi4qwTp3Tb
 cZUqx/vL
 ReegLgLYahwVXqStL/LRb5dUifY9NH/JHEVKXr2MPx0IAsSgRWvKkZblkrGeQn4YoZVOxkR5rhacel0cfAckjHexYcKT/VAfRxkgHPW2+LcZPIJmwC5hwlL/fzOD1mIIxMhju3wZDOra1z11b3tR1G61fg90GMHyQuxHia4KL/BBwPhQ/SLS4ZmHZwjcJHCKpjTm+yvEQq+CoZjP8ZxGILBG+ZFKBWDSG7XN49VPKozqCIT5rAZYPwjPvlXJbd8eJBIzZd3nWfvSbdLA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 4:09=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
> > I think my previous statement still stands correct considering both
> > swap out and swap in. Of course there is always room for improvement
> > to make it more clear. But folio always has the data is not true for
> > swap in. If you have other ways to improve it, please feel free to
> > suggest.
>
> I assume you=E2=80=99re referring to the swapin case where a folio has be=
en
> allocated and added to the swap cache, but it=E2=80=99s still being read =
and
> hasn=E2=80=99t been updated yet?

Right. That is the case swapfile has the data and folio does not.

>
> I assume it could be something like:
> The data may be in the folio or will be placed there later. It could
This is for swap in only, does not describe the swap out case.

> also reside in the swap file.

Right and it did not have the same coverage about data that can be
both in the folio and swapfile. Sorry about the pedantic. If we want
to improve it, we might want to cover the same level of detail.

> Alternatively, leave it unchanged.
I think considering the swap out and swap in case, the original is
fine. The reader will need to make some effort to map to what it does
in the code, at least the description is correct.

>
> >
> >
> > > On a 32-bit system, I=E2=80=99m guessing the swap table is 2 KB, whic=
h is about
> > > half of a page?
> >
> > Yes, true. I consider that but decide to leave it out of the document.
> > There are a lot of other implementation details the document does not
> > cover, not just this aspect. This document provides a simple
> > abstracted view (might not cover all the detail cases). One way to
> > address that is add a qualification "on a 64 bit system". What do you
> > say? I don't want to talk about the 32 bit system having half of a
> > page in this document, I consider that too much detail. The 32 bit
> > system is pretty rare nowadays.
>
> I=E2=80=99d prefer that we remove all descriptions about matching PAGE_SI=
ZE,

I am fine with that as well.

> since we would need to double-check every case, like 16 KB or 64 KB pages=
.

The cluster size is determined by the last to second level page table
page size. I fail to see why 16KB matters here for the cluster. Are
you saying in the 16KB page size case, the custer size is 512/4 =3D 128
swap entry per cluster?

> For ARM64 with a 16 KB page size, the last-level index uses 24:14.
> For ARM64 with a 64 KB page size, it uses 28:16[1]. For them, 512 entries
> are not one PAGE.

Now you got me curioused.

In your above two examples, what is the respected swap cluster swap entry s=
ize?
In other words, how much entry does one swap cluster hold?

Sorry I am not very familiar with the ARM page tables.

Chris

