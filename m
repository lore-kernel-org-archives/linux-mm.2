Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 277E1FF886C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 22:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 756316B00A7; Tue, 28 Apr 2026 18:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7079D6B00AB; Tue, 28 Apr 2026 18:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644CA6B00AD; Tue, 28 Apr 2026 18:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 587B06B00A7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 18:55:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B46DF1B92DC
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:55:29 +0000 (UTC)
X-FDA: 84709472778.27.984F184
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C78F3120005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:55:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oGyQdGW/";
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777416927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FL9CyL3QjQtOHkuNAxAJkT6kV2Q9aHFOerE0NNcBA+k=;
	b=ljIEdU5USxgvxKDpaQzxsJqegWDoBqITKzXx4l7S0IvX+BbIK1FD4319PNo+kDaD0isSzH
	rGOU2tRy9A0/U14nQip2VvZ0OnAT+gYtvyfpmYGBJWoJcy9lvBR2zn0NEaV5C/OmJMPQCw
	oEabjABs2s6wPz8pJq455t6FmQ6e01U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777416927; a=rsa-sha256;
	cv=none;
	b=Arzx6n7jEVpGGYhOArkViaVsjS+hLu2Sz5FvgMZXmw2ApFVfrpO+CwCMDGJwoftFRdLSLP
	NVIBC9BE8YU8u083vMXx9xjVbSBeH1J/iXYsdvlE5b61qu6ka+samrHVXMxgc4eFcPJdiv
	PJiGM38jfj8Pd6mpP0W1rZ7SYOxb33s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oGyQdGW/";
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A27D60581
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CA0C2BCC4
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777416926;
	bh=wy1UnNGI+1k/69Uo4WOgM4+nyZqotk4fk7KmlJZLe30=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oGyQdGW/2LCUXkkKYWmmOsvSsssZkI4W8XTnChiqnwm9MzEtgbs4gg9av/Dznzn1K
	 KdgM87VRsYU2B9v94xbut6j2mPRdxFoqaJ7k2IsqzwvvZejRN/lzVmD7wEu12NHMuP
	 nnubk0mwUQTu39BMqfvA5enbfdlViSoOLci3Q83fzzOqR7jftpZXpDCE0rBnmo70ld
	 FW7q8uwne3RNYLFsfrFfaMGCsT3OJHCp1Oaxo+rwcCstfrJrdRWwOnOw5JWLK7AvzT
	 U/q/27XKhNKGLK5gP6/QPb58TQ+HwEPrfBWyWVkqLG/VNe6kdNho0jPd2Eekgrk/HM
	 DT79EdA8yFpuA==
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-89fc4147f2eso132718736d6.3
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:55:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8NmHOQHXEQG1GijHa0pj4Gdxy0IuCn2exunUv8+3c96nz4DyCdcGXrNbvquz8B1QQKzPx22ibuCg==@kvack.org
X-Gm-Message-State: AOJu0YyHFuc66gPujbJe2Sks1JK8VyPVVTYiwnSNiM10j9xaEvfN4owo
	oBOotnDXJCD81qsav44tZMjqgwcd3EgDPK12HxnQmRC2l1Ma2SU+8Kitev4Rd1wS8LfyVh+xVSg
	GaCRNQSr5/2mABH4vSZZGV9tGMSh2Ar0=
X-Received: by 2002:ad4:5c49:0:b0:8ac:aaac:4034 with SMTP id
 6a1803df08f44-8b3e31a2a64mr85074126d6.29.1777416925996; Tue, 28 Apr 2026
 15:55:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260423034917.8234-1-baohua@kernel.org> <ec08f25f-1049-4fbd-8a87-0df135a867be@kernel.org>
 <CAGsJ_4wn=o5ZCNPGguCCk=19iYZr1V9Jup0NdRUKXySsKfD_4g@mail.gmail.com>
 <17a3bc38-0d97-4316-b2fb-02a91202c504@kernel.org> <CAGsJ_4y6_G5BPZKs3Mg3s2ygxGh1o22GX_3wEsM5hs7WX_cOhQ@mail.gmail.com>
 <efcdb62c-54e9-4806-87a2-5729e3c1506d@kernel.org> <CAGsJ_4xvXZVRO0-mXAWM7mH9pVH+DAYggDBG1+2x5iQ9mfDDDA@mail.gmail.com>
 <20260428060115.84c55bcf72315c01b86e0c90@linux-foundation.org>
In-Reply-To: <20260428060115.84c55bcf72315c01b86e0c90@linux-foundation.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 29 Apr 2026 06:55:13 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wTNZPHfCkm4oV4Doi29TUoJ+Ar3fg0cXRWuQ+FMa4UaA@mail.gmail.com>
X-Gm-Features: AVHnY4KNVM7WmRs1foPXC0kSIHfC6Aaq8gSJ8r4N1_wavwvRC5sZMOFJg4p4DQM
Message-ID: <CAGsJ_4wTNZPHfCkm4oV4Doi29TUoJ+Ar3fg0cXRWuQ+FMa4UaA@mail.gmail.com>
Subject: Re: [PATCH] mm/huge_memory: Fix outdated comment about freeing
 subpages in __folio_split
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C78F3120005
X-Stat-Signature: bexredby1a8pykn1nmzjw96daipsypy6
X-Rspam-User: 
X-HE-Tag: 1777416927-724673
X-HE-Meta: U2FsdGVkX19fMTy+tpalYgBZKik5eazkCYcZfI7J813RHqc8fpib+FmQLSReI/Q9BXa5+tjTt8t4jnwtf7cgdZjnEj+uQGdJq/T6egzgVpnzziZQpAi7TvVngd6eSqmgWUfAz30JDATpVZb/oiHvJAFc+8UrmQY8L521qBpdLY2ZRR31fZmqfhccM9tZU1Xd3SuJk4VcHE5Ib8Fg7HplRK3Hx8NegJqmnGb9AdrA8iX0hg+M5a5qNk5MUwTbHSxx1loux+YtWbP79N6XGXHBMoHYKbBolaLYILEanxbF7CQc+zxqb6m/yKEptzSGxdGT9+cC7YWlhV9KQA56LnkGAtvBK8h+7WCAEvM3kW/gl5M9+Ig6suFzk61JJZeRKj17HSz8P65Zkeymv1FeEOpROIO6saXIOY8fKeZq2/I4e1rccmqC2+LqYnd83D10ROGndyVrOvZ744QNiLN6mJFFGUrEzxU7+dO3EDtXTfFUk9s3jqqRk5J9yB+k2ghFhDil9Iu1G9q4RGJC0iNWRmIIeInilNhQLGFoTvaTs0viBM7FBzzxNM7wiR1aqYCBTuUsSMpSK+ntCkOenZAJCyvJpW28IMwnWZft9p2wdi20uwHb2wyz920Ois3lgtJgR2NIQTbi8cv1tWGfD/sikzJnHoco03Ji7lcGblFJCWmlwT3iBslKKJIVubTuDyFDokqf44HxEyTRylW4Ml5azcZtwqiCX4KAyvQhT3vNrSX4Jv2lp9J+fNVh2UEXnhVLZGv0of1jFwYZEnD/t+hfccxjmvQPx7uj9tcqMU79SD9Fk9KupbtEaBXC/d7j+YzkSoBWELkCVNTOl/S7agSVrslUn6lgbQ8i6lA5/Q/j2r58JhdNn1t1dH2D7gvaefQ6B07zB5ZHYNbQdb8cGEIYqkBk4BbHqpIFBLCXHfb4rw71UzJn6BUBbTYY58bOCIvicHMRYgUZBR8+VofI0iIr8ul
 Q/sWRtR2
 lMY2BPL8ypsgPlC+yZj+d8ErxOiXHkDtIRP5hO8Pgw0ry8n0fe7MGhjwDDB103/g+wc4uJsiwer9+e+uYFLjCmVLyXobzpZ0UdADBZ+Bn3t+NNqB8qG6rhQYFALEnpQ/RKzAPF0F9Vr2HoQpNuwiWbaabcesSIbBlQylORMDdeAQs6m7yI3RDroODJz8fhySshwRf7mO+F9aQPnjtiEzRLIrqL6mi+6oHmVZztBOHMMeafwJfEkE5wccmOuTGdVraw9InTJhwH893d0PDW3RRY+fo8flXvGrYeyDk6jposiikoa+mYblkS7V1uXeHnJ6+wGZc/mTYuqcXXPcX9NhFeFXjjZPITdsKZDaczSZhWiYbAl3+fxpOrjDa8FaiIjPqnhD7NGdHkr8QHL5XWxh+jBbHas5z5Ycqo+z/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 9:01=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 28 Apr 2026 18:32:40 +0800 Barry Song <baohua@kernel.org> wrote:
>
> > On Tue, Apr 28, 2026 at 6:08=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 4/28/26 12:05, Barry Song wrote:
> > > > On Mon, Apr 27, 2026 at 3:42=E2=80=AFPM David Hildenbrand (Arm)
> > > > <david@kernel.org> wrote:
> > > >>
> > > >> On 4/26/26 22:42, Barry Song wrote:
> > > >>> On Thu, Apr 23, 2026 at 8:36=E2=80=AFPM David Hildenbrand (Arm)
> > > >>> <david@kernel.org> wrote:
> > > >>>
> > > >>> Thanks, david! would it make more sense to add =E2=80=9Cwhen
> > > >>> CONFIG_PAGE_MAPCOUNT is enabled=E2=80=9D at the end of the
> > > >>> sentence?
> > > >>
> > > >> Better to phrase it in a way that doesn't even require these detai=
ls :)
> > > >>
> > > >> Do we even need this detail in the patch description?
> > > >
> > > > What about:
> > > >
> > > > The comment appears to be outdated. add_to_swap() no longer exists,
> > > > and the explanation of why we need to call put_page() after
> > > > splitting could be made more general.
> > >
> > > Jup :)
> >
> > Thanks!
> > Hi Andrew, would you like to make the change in the
> > changelog, or would you prefer that I send a new version?
>
> This?

Yes, exactly.

Thanks very much!

>
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> Subject: mm/huge_memory: fix outdated comment about freeing subpages in _=
_folio_split
> Date: Thu, 23 Apr 2026 11:49:17 +0800
>
> The comment appears to be outdated.  add_to_swap() no longer exists,
> and the explanation of why we need to call put_page() after splitting
> could be made more general.

