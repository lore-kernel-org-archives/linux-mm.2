Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95883CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 05:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4BF68E00AF; Thu, 18 Sep 2025 01:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E23CC8E0093; Thu, 18 Sep 2025 01:03:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39498E00AF; Thu, 18 Sep 2025 01:03:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C20438E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:03:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6EDE21A07B5
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:03:29 +0000 (UTC)
X-FDA: 83901177738.09.61295CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E567018000E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:03:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tde8YXB9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758171806; a=rsa-sha256;
	cv=none;
	b=rqqlTUvcBgsxRddXXaOCHl2rsiTgqFvQ07t5KA1AZoBmfdY+0aL0FYqR4KOZ+1mMnRfAhF
	kP0LmyMIRJsad1ncuoWG36GIcyp+NG6F12I8S9koGTGgo/iRHrjsiyxnSy3Rn3F9T53lAJ
	X+2QcIoBWQOOyT9SjHPXWTN62rJuSVk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tde8YXB9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758171806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7W2lyROUGHdP3dsbt+IeiIDj0Na9XdzQYQpgVUVsyN0=;
	b=GimSIBVxmuVa3jVor1olEPS0HhGBQwmiSYzEKxcxmoBCOZR6CyM9Qr0SK1YUJoAp/uuJY2
	I4igf3VCicDrAR5J3L+gPMnvWBZ+n2ffiFPx3REjkztCraVtPni7ESIPlqYEx25ubvgeA0
	4yaWSadk/urmforkArx1SfJ7ORbQ0DU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 471B6601F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA224C4CEFD
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758171805;
	bh=7W2lyROUGHdP3dsbt+IeiIDj0Na9XdzQYQpgVUVsyN0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tde8YXB9L6jmb7tyDtcA6w3F8fMoLR290MYJs+BkIvqPVACcv1LBpVWWLc7HxV/o4
	 uPiEazH/KjNcToWBwOwQWCtETOFcc7K3fxI7Cs57EX4neeYE9ZzS4KAllYSaLTor5s
	 QjNSCe+jidwnLUee+pIa7MZHwRTT90cuoK12cRKsfkBbKhTia+txRRc8C+e3HzA1Bo
	 Evt0LQN8dtAwBNLDr1zkLcKeMLhpmopVFqsRfCYts0A+J4ZY8nMuMhy3UL5VPpnGMT
	 9ElkD1DekbbS827JZiwofkLNr9rJWySK87ZDE95o2FFa2TB0fjjrxjThYlEl/uvdgS
	 qMPsbLZnaL5yg==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-55f720ffe34so601116e87.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:03:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUm97kNH6tIyIY5oEt/ATMmLYsJKkGJqfGZSIYO6VEny4VC/y6yNp8fdFNTem7y1O1qYx7YKLhLzw==@kvack.org
X-Gm-Message-State: AOJu0Yzx5rnXYiLoioRgUHtv3S6sHINLBPGbrBu+JXiV7mfZIL5JBZnr
	KHmW2z+i8jPMtMEztYpOHVgDkOLnCm8Idw+dDieviY7UluxPHDnvPMe4Ixi1opW1suCtr8ofdCX
	bjIyXAGq9WAg2YVqVqQymGDmzwQLsaw==
X-Google-Smtp-Source: AGHT+IGD1CQLqGySmhrkzQzsiSL90znsRrvPLPTc7vfVtF4Ow+HKYTydxL79tCPmKxbplpuM3Gthu0dxw6cuB/nL9SI=
X-Received: by 2002:a05:6512:ea1:b0:576:59cd:ffb1 with SMTP id
 2adb3069b0e04-57894ebf20cmr648428e87.22.1758171804455; Wed, 17 Sep 2025
 22:03:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-2-ryncsn@gmail.com>
 <CAGsJ_4w2GqGj8HZMfwndsWu7qkORqsnaw9WwhmQS=pW4gR7nEA@mail.gmail.com>
 <CAF8kJuNbUyDWcJ13ZLi-xsiYcbY30w7=cFs7wdxszkc7TC4K2Q@mail.gmail.com>
 <CAGsJ_4wKWem-STYAnh_0EgSFKzzs1M1c7wz6K82wLt6T6JEw9A@mail.gmail.com>
 <CACePvbU8cUs-wwPsXkZ24EWga5bXxxUGSCT18rKAWFYn5w9rpw@mail.gmail.com>
 <CAGsJ_4yhDU_WVfEybDhGE-WF5+w-fak1-F8jqbAQ-Qw1+qWkaw@mail.gmail.com>
 <CACePvbUabb+L6Z9Nb-41fLR-FMhj--cDWSbnXtCj3rpqXModiQ@mail.gmail.com> <CAGsJ_4y8yTX48ESHKgLNCvM1M1_gY9uGnD4qiz8n+gD47Zd1Hg@mail.gmail.com>
In-Reply-To: <CAGsJ_4y8yTX48ESHKgLNCvM1M1_gY9uGnD4qiz8n+gD47Zd1Hg@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 17 Sep 2025 22:03:12 -0700
X-Gmail-Original-Message-ID: <CANeU7QkZBWFO6SeVHtmm73oLu7r0zavePQEYmQfH8opKPH1QWw@mail.gmail.com>
X-Gm-Features: AS18NWB6V52_xqiX64XXMAqy3-yf52xEFlsm6O0XCWcfwFVru9CDfSCEY0zMNRc
Message-ID: <CANeU7QkZBWFO6SeVHtmm73oLu7r0zavePQEYmQfH8opKPH1QWw@mail.gmail.com>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E567018000E
X-Stat-Signature: j54ahkqkao5qfzmfmz56c9e16fn63nce
X-Rspam-User: 
X-HE-Tag: 1758171806-838173
X-HE-Meta: U2FsdGVkX19+O2KF24NPRMe/7Ip2s8C4ZLqTwCxLUqcJZD9j2rkp9U5RS6nCkQmHy9GUZxFrprHvRp7BZuIpp6My7G+Bdbmmml7/4hFXjbIQbdWZX9/6dgAmya7lgY4HnMgRABOG1y87kHFFaN2QfU+n03tFALOhYb4r6tM6dUzq+cPEOef+oDmDxnWIzu2BEO3SH8rFkHR8aMChekegGumMCqMzfAf+0EldsZ9REkfYVidGRIpZtAVpT5vTqBbMSd0za0vY8sQgy03Fxm0dnR6PC0PxpQbE6AM2zSKvhtHlN8f0OuVkqHvbXL9bEk2F5xIW55TuN12cdP/R64TO1nrbLe4RLpYWJU7rdjApdPwbqOGlgL8cr32grfWslZjta+7gt1nNVDoVOeYjgpToBfTtfWHKP6Pp5dob6Y7m6izg7DGo4X4kuM0LSZ86LscVvFT6xag7BNQmBlP8pOPXoKjtOTSGVPRyV/VDFGQTRRTWGpMAIVzqPTOCmgDxI4ivbjNjOOiJsBiRAmxgdUEVjTRPx4sR2CTiNLroobbfb4D+hZJPkZBs6XvvaReltOzOdIhfyUyGt0YjdWNSn4vu1aD5qM7xbEtGOxZVjspEVbuXJCPBXPIBuuy4OMnHwn5dhJUUZ9gRBwWkkT2fBeo92/sUO6ixNnATVqLjw0paUYBbHHtwIvG9FXoDi4aKmtyc69LZDR4Si4sSckHXjduXGVuM05ZGcIoi7zW6kifrRUjMn6vn3Mx4pVNjRgHaKVZ1DI8Bc4zL5GXSI85i0GzyAoQW3xHCxaYxiMGgXVVqUDwAAijBlOrPEVqSBXnwk9Mu3z7AjOomcqPtC8aSQpKvsta8YOMTuzTuIpIa/i3Fq14d/dfYfPcfVo8FWvCV8oJZxSZW8O5z4m64lBP2e2kWN6DjwWxYiP7h4XbPt4VvaBi3eUxk49SFN5CRzLiwQCh+eUn2sS63QmCCWwzVMJA
 kV3fbNA0
 y4gieVZaIYRsO6R35k5gp0NMDSX1yojblRXqjDKolF+BXo86cxem8+R1zBEyRI4F3A1JcNMlxDSIiTPMnxhD5oBxklq5Nx/R5K1cRTTvlkpLyQ9wS3gUbz5CM1gLl2kJSVMMsyBpxVa3dG+I2+8OSAtoEdZo0iUQ40GhYuhjw4V25kBMXYbNG+pL0RywrDYjFl+e3QxSU1RJOE0yf5jUK/lLUh2qFdavYXzgC0S/Y/zL/vbube/QXhiScgi9OYt8fAJpaJe3o0R0QYINUfpsI4SxDs+Borx71DIuaGL34byVABXYHAHN9sIvztg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 4:38=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> > > This approach still seems to work, so the 32-bit system appears to be
> > > the only exception. However, I=E2=80=99m not entirely sure that your =
description
> > > of =E2=80=9Cthe second last level=E2=80=9D is correct. I believe it r=
efers to the PTE,
> > > which corresponds to the last level, not the second-to-last.
> > > In other words, how do you define the second-to-last level page table=
?
> >
> > The second-to-last level page table page holds the PMD. The last level
> > page table holds PTE.
> > Cluster size is HPAGE_PMD_NR =3D 1<<HPAGE_PMD_ORDER
> > I was thinking of a PMD entry but the actual page table page it points
> > to is the last level.
> > That is a good catch. Let me see how to fix it.
> >
> > What I am trying to say is that, swap table size should match to the
> > PTE page table page size which determines the cluster size. An
> > alternative to understanding the swap table is that swap table is a
> > shadow PTE page table containing the shadow PTE matching to the page
> > that gets swapped out to the swapfile. It is arranged in the swapfile
> > swap offset order. The intuition is simple once you find the right
> > angle to view it. However it might be a mouthful to explain.
> >
> > I am fine with removing it, on the other hand it removes the only bit
> > of secret sauce which I try to give the reader a glimpse of my
> > intuition of the swap table.
>
> Perhaps you could describe the swap table as similar to a PTE page table
> representing the swap cache mapping.

Hard to qualify what is "similar", in what way it is similar.
Different readers will have different interpretations of what similar
means to them.

> That is correct for most 32-bit and 64-bit systems,
> but not for every machine.

I think I will leave it as for most 64 bit systems, the swap table
size is exactly one page table page size and that is not coincidental.

> The only exception is a 32-bit system with a 64-bit physical address
> (Large Physical Address Extension, LPAE), which uses a 4 KB PTE table
> but a 2 KB swap table because the pointer is 32 bit while each page
> table entry is 64 bit.

I feel that is a very corner case. I will leave it out of the
document. I want to present a simplified abstracted view. There is
always more detail to distract the simple abstracted view. That is why
we have physics.

> Maybe we can simply say that the number of entries in the swap table
> is the same as in a PTE page table?

Yes, that is what I want to say, for most modern 64 bit systems.

Chris

