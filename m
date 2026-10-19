Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03E89CCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 12:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07BFC6B00DF; Mon, 19 Oct 2026 08:24:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052D46B00E0; Mon, 19 Oct 2026 08:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB466B00E3; Mon, 19 Oct 2026 08:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFF386B00DF
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:24:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D11CC068C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:24:15 +0000 (UTC)
X-FDA: 85339293270.30.8D138C4
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 606274000C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:24:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NgZQ2PlH;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792412653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIl3797HKzBaRekdH/RX1kheOlY2s6cxDUnXXsRaPAI=;
	b=Cy4mTrSc+TmnXUlDqLydlXQbTFyeQs1bCF0hBJMVdw1ml0kbA7dM3VssMrzuuYrO2pwglK
	9pEwK6SwynY19o1n6+sM0rtpvg9injCCLVpgHHXI3SDYcUKMQJFAn3+P95llg1eM5TDkv5
	HGyJzIMrTeYn6mDMM+V5ZCzZQVi0JRw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792412653;
	b=r56HG1MHzPDwbIePOG/ustdwexagGbi3gjRyRJ4k6/MzpsHKBDhs8i5P5zerW8sy578xkX
	RCGkCaxPw7ClVJd03wgOeGP2YnJ0xHzKh63Amgs4M6asPbXm0I6+gn+bMEzmE82zBuwVKI
	G7HVzuQrbdSpxDssUtEbhzqPx+Pu8rk=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NgZQ2PlH;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48b0584ad71so1379774f8f.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:24:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792412652; cv=none;
        d=google.com; s=arc-20260327;
        b=g4vR59RLmBclXkoWbPns+XRnWcAQ55aQYUYG6Xijj1d7umQDVFYV1RX0p3vTZy2+M3
         gOrfpm9fg0C+ZG0IFwOYcM9DAf2jpt2AOCn1CwDIq/sufGepwosV2HCHMEeEalI0VqHE
         XG4zqIN2OJT4/qIRRvLVm587wnx1TAsfPtpLY+IhPXMq5EgCse5zTMEniOq8iyguP0SJ
         Zw1liMErn2BGGB3kpNT9IkJrh09na+MrEDRyFz9H/g73ZvjYHpHwR1+PzayBr27JB0NL
         jqt9yZTDIWAWQsxt3e0HmDDiAgnmO9o1AgS+XyHFf1VH4yq85XG0G8ejMYB8eiel0q7v
         YfrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zIl3797HKzBaRekdH/RX1kheOlY2s6cxDUnXXsRaPAI=;
        fh=SRtOAIZirHA11kOAICuOoa9DYMiEYwu7kPp9jiXYxbg=;
        b=PgWvd2ligK/8Icm+Mlqsw3yvjWSE9XH1dDyPftLgo+cPQMdUT7UwQQaxLvjz6VTISh
         fWSxm2lMn8eUGNEia7XTaJz5kHiINYDqXPZNHk5c7oDelX/Sm5FPR1+ubUrXqIDNIoMN
         DXW3LxSfcbwe+eMUXQujlzBRCsj9OxnCx9HvH0pkpPFUAy9wrLStTNVu/5wcR/RSKXf7
         Ohg/DxlbFIon6KLVnLfan11Ikc5B9CZh1RlK+S2aPEihwYH878UF+79GvvZGd7TUzEYy
         IxeoNVl4l6HC+52SSG39ArCWjgStUB+WBPrCcBSY2rp2EpSxOP2gER8fQxk59LePy74k
         1q2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792412652; x=1793017452; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zIl3797HKzBaRekdH/RX1kheOlY2s6cxDUnXXsRaPAI=;
        b=NgZQ2PlHi8YQxYs4Sba4A5+tJhsODVrmE/WcYTaa0PVxJYVxQLSLhDDrpzYfHm2XNP
         G9hrFlK3f+HALtll7kEGyCZVcjJv7ZUtEoffTiWAFWeAP2fTcCrREynvvPVuiytpXb8p
         zesXgyxAcPbEr9Q0ow7G+aocLD9d/JDtBI2w06/lp+N507IoRMMppDAIGboTLNcQluyB
         v+9L7tzuwT2b5kkqW/Bx2yztb+tOa9y8H5twX6eVNQzki61SlC8AHKWwt6vPRLQsuOxT
         vKAcmZrrTrRP59/5BcJIb8b8k2OuRcGPIug2z4bzVkB77GQsx3GW2i1ObDV22S3Kl0lE
         ycBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792412652; x=1793017452;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zIl3797HKzBaRekdH/RX1kheOlY2s6cxDUnXXsRaPAI=;
        b=pkmu9emNOayAoXOr4lYiQLWVgbjAmF2ZWYDwx1KEEAtRNKmJ1NUuQ2SihFj1CqsDow
         +x/scciPsKQgiZFPT7AyJJkyzn5tPIE0vrF+M8nXkyAeSq0zPKG1yzbtdDzaYaOie6wA
         Y/jiaxDIowZKvZI/V1k79S7u29JyIw9G3FyJPyEI4FhKj+CBecDkdSLREKBgsHrxFDqA
         O040jb9yUpoID+ESkPyZrZw/KNLyxuP0biEHEelbVPLD5e2K1PtjAJdCBoWoPsCSPV0O
         9jAvqHRDHEVbOkpEDNk9S5GDc2B3K/rDnfc0RlUs3evsm04sfnLON/cI4/gndUha41aj
         lb9w==
X-Forwarded-Encrypted: i=1; AKwUvByCGg0V4rPOWGFKa0jlwTrePG0LC4A1JZ7WVdr/O660CL6cI0R7po66+0ePuYvHa+w3n4XxJWHYug==@kvack.org
X-Gm-Message-State: AFq9FYJiftJOrBA4dyDmfzOsX01JdZna183hGWUoqKAvINOJ8h3jZXFu
	XQNuWbvVhCjCy6WlIKSzZjaA8Z8j/daSgW4usd39n3cbpduVZp9aqPhzNEh2ZIMIKMdbOGfmfxa
	ldIaW9rShbPGj/l7AAS9pcGeEmR/2iBw=
X-Gm-Gg: AYBFou0KsCiUYdwwlOcu+ex0CNVKqRsjTXHF8P5YVMHCPr7YhJ2FijFOlomDoIIMTSu
	cNsampbqq/H/vhltLa778SN+qq9LmPbe28HH47jHvHU32qoE7mvHjza1z5dRi4uXEeInZQ3MIHw
	LFUvJdlnK46VWqPf0/4nwM3+/oQMgo33LGU7UbNjmR8/qUKkkEwYz6WpNdx84oU0TuMFxbgiI9a
	3lRCKacv8c4BfMecAWOu8bIT2CWQJCmIYRMuNs5krZxP2Vj/3E7IPRZ/vFK5SSr4QTlQ3+yMFoQ
	EvHnkFMi08Zr9H0DpPAwCu1AUTsOUN9u2yTx7wRoXkvqhqpkUMbnxaOZVp02cEZtDG7Y5UHoBLN
	XmfIKvHrzdfy8M7JuFNtpIqLVvaBqIyEqm2H5B8X3rR5O3gjWbOt2FR3pRccC1qjbHwUSB8M=
X-Received: by 2002:a5d:584b:0:b0:48d:f831:2688 with SMTP id
 ffacd0b85a97d-48e079767e7mr16787506f8f.3.1792412651411; Mon, 19 Oct 2026
 05:24:11 -0700 (PDT)
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
In-Reply-To: <20261014195354.GA371161@cmpxchg.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 19 Oct 2026 05:24:00 -0700
X-Gm-Features: AclHuK9g4IT-C2lPq_2bwXW7AKF8KuPzBZKFA4kZoiUqrTyhjKQMGSX85iLRdLw
Message-ID: <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 606274000C
X-Stat-Signature: 4to655ezyzhowdyiiz8ym7zsq7of3x1j
X-Rspam-User: 
X-HE-Tag: 1792412653-182343
X-HE-Meta: U2FsdGVkX18GLXrWtWw6HJc6ex1jJoIZArdFaomX4Mt9XRcj7GKei/AiXp0JIOFvqzzDXNyvwPOf4XBeCwgDmOyeVpGs9QtzrHmbhKzf8oB9EUWxApFi9wwDgvknbLVNDxYwQZ6/DnLy70xAzAIzH1fyMtIi7QIRG+YTedYd4zRf2OriMsFK6S2+3EFHvGaud3P6LBmT03VpRkHWT5T28SJFA3TJen9g0KNLSMGYjWpumdqA5xSbnZiBKjyNfwNpJ/qcVoQheoItYfM9EEwuaGlVV+xg3gEYTf/uhMMpMPh03N1sK0pQtN2sM3cF+f7UkirGRMYSNpwcmhxDn2iaZGSoePexzOwW01HVSv5LPX16XVJzO8wmWkz454xCEVXHT51/UVbdKfpyihk5mZ1rUbnsG8zWzVqosm09fB870BvCJr7+fPdVjo2dI8Jtm1Kw7hwCivV1RKwraO79D53mX2Oxjh2bdpPHX53NvoPqeAQQTHaJ8U7xHITgR260lIZJgEe7HHn0Ax0Nf64cwXiK/R1KAatTiNNKOl+KQtCGTS2Oqcgtm7IBFvdQa0yxr23BRcA1XrNjYfxS8K8ub/VNAAuD3UUQ7TC/Uk3HpNKdvVEbZpUG3L8QWdMrH0o4fNRt1Xo0oD11u00gqc8En8GSNOxgOw7rU+at7wJqRB8UvmGjb+Z1HWiU1aARBhuUs4PzbmrggpAJwTgfK7ThaeJ6Y6UJQz9Hm15YnBZjIgQDsg8hZr+krFfd0jzniWxnQ7XcCfaD74xI3Q3z7t9KU6r89kxpS/eL7xdDJSFMnLH3XxBIpRdsg9BvaPMnElrVizyS4itJD1U9MD4qqqm26PU9yIvDYZzDA0KXRmS7zNY47cmVsVyItOmf8QBoNZTW7Yaz6smPEsL3/EWxIkE/jnDnzUXhNBh6Tf5VQM7hcj5+iYQH2HNgb3GegTzqcdi6LytNnLA3KPJlJcUXNT6an9x
 ITu5QPm2
 s+0r+IfSKHfagMZnAWrRGt3jAZCTQH1Q/IdjEGmfFurv5AxLQguD4JULdZOkwyWxDYoz57UR3bhQ7RmMJPiiSLn5ouleYNSB0nCU9w4etJkEIFtTplzRX90GMaCq4vUfWLTgQiyBWUAgj1TZdA4KXxwwwfnwS/KHo9a/Uic3wznwr91h5Olg9WURGtsHFRW2mvV99vN+roGvK39xgzAEMySSs1qbevSBWB0bgoeDSa/LQgKFt8Tsb2svPKdZYKmMvt86KGBE/3oaJ+RO3PrVUSh1sv/wQeggjUGcgQVBgBBNsBqV0kjAEbE5AwyX2qNLS3p8FzNoaDepDf8RCxQf9goKl+pfsGZARjxF18YNu/UYDXxc/TjSw+ZUkt+p0RsZ/vqS/L1uEZJV4G0Wm9WY+Ghu4+ojirztEYnJnEVW4wiz52yBmecmdWfwJSRItZcTjqoFlGymuw9IENJ2vJl6Feges8jfEWDz60QR2Ou5jGpzqKQtkpW06W6f7rmzBf6QFgZ25MHLq0JbKMYM1zNtCZSUjUoKiXSbTG+h+duEitOSgeqbbaZ3y2c6CcJvP9oghyZhD6aWV+s3kPUBPALVqKMNFGjcnN2CGPnCUuE9SvXYl2ofLthuVCOvztQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 12:53=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.or=
g> wrote:
>
> On Mon, Oct 05, 2026 at 01:06:28PM +0200, David Hildenbrand (Arm) wrote:
> > On 9/22/26 15:38, Chris Li wrote:
> > > On Mon, Sep 21, 2026 at 8:56=E2=80=AFAM Nhat Pham <nphamcs@gmail.com>=
 wrote:
> > >>
> > >> On Fri, Sep 18, 2026 at 11:50=E2=80=AFPM Chris Li <chrisl@kernel.org=
> wrote:
> > >>> No that time slot is too late for Asia developers. I don't think we
> > >>> should use that time slot for swap alignment.
> > >>>
> > >>> We should find a time slot more friendly to Asia.
> > >>
> > >> Any time slot would have that kind of problem. We're spread out acro=
ss
> > >> the globe.
> > >>
> > >> Let's just use a standardized time slot we have for MM alignment ses=
sions.
> > >
> > > There are more swap maintainers in Asia than in the US + Europe, at
> > > least based on the maintainer file. Please be more inclusive. If the
> > > alignment is done without key stakeholders, it miss the point.
> > >
> > > Sigh, we can't even align on a time slot.
> > >
> > > In that case, let's keep discussing on the mailing list. At least it
> > > is accessible to every one.
> >
> > Looking at the mailing list, that approach doesn't seem to work.
> >
> > Finding a time slot that makes US, Europe and Asia happy is ... tricky.
> >
> > 1 AM is certainly unpleasant.
> >
> > US vs. Asia is also tricky, but doable.
> >
> > China 8AM vs. US West Coast 5PM?
> >
> > China 9AM vs. US West Coast 6PM?
> >
> > (Europe is 2AM vs. 3AM, who besides me from Europe would join?)
>
> Either slot works for me. 8pm/9pm on US Eastern.
>
> Apologize as well for the late response. Travel week followed by
> post-travel sick week...

I hope you're feeling better, Johannes!

Folks, I just realized we never really clarified the exact date, and
since we are in different timezones it can be ambiguous. How about
this:

PDT: Wed Oct 21, 5:00 PM
EDT: Wed Oct 21, 8:00 PM
Europe: Thu Oct 22, 2:00 AM
China: Thu Oct 22, 2:00 AM

Please let me know if folks are busy, sick etc. I'm flexible myself,
unless my flu shot fails me again :)

(Also starting from November, Vancouver, where I live, will have their
own timezone. We'd have to add another row to this).

