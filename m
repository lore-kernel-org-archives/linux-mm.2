Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D515C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F05716B00C9; Mon, 13 Jul 2026 12:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4496B00CB; Mon, 13 Jul 2026 12:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8FEE6B00C9; Mon, 13 Jul 2026 12:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FF296B00CB
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:20:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C790B1C872E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:01:36 +0000 (UTC)
X-FDA: 84984218592.03.5ECC300
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B30E9180012
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:01:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gGsL6cm0;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783958494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4p/iJEsuqLqZW98fp3Z/JwahVzSBhEWJQYLDi2b1wQ=;
	b=jKiHBrjDY9hmrFsiA3gkIX0lYlU4IIfQ3nRenNIRixjXJ+ARRPpPZYLMS3Vyv2R93GK9Kq
	VhmjReMcnrIZ+QklE9rn94mV9eUyldPWCIC4adj5DsMMWX5Aox838ra00Jfe1X9F5Fesfn
	IIaewaX8iKclDHxfiMFwyg4WdMWLSOg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783958494;
	b=zO3P6kgTGQlYU5AEkOlfEM4vTydjELbPq+NlyxNMx9or/ruv63EeItyOC/Bg90oWu0Psgu
	PXnSizbcCgl2BsBx6QWR9iBVVZPXokyvaYZbtIfe42SpQg7l+TEl2Nksh84pnVFqmkYWyS
	teKwZzZ+T417jL288t0PIBSVor08moQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gGsL6cm0;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 049C7419A6
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC2E1F00AC4
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783958493;
	bh=A4p/iJEsuqLqZW98fp3Z/JwahVzSBhEWJQYLDi2b1wQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gGsL6cm0oLM5uyJRZaD1106UP9rdBNxHJhYQNZjrgQ6XB2pWHuYXctdMjxlM5CRvu
	 gp342h57XlvjDZ6oK+w0AknYaOeGWmzFypilRTF5z3ZnSoE/F5Rrs7PZ17EBeZK8iN
	 iwJ+bCirr2gdw/Edb9/X/c4wKi9GhgqaYLw7m/ofBVvHPa4sXXiu7qhOseBR3V9SQy
	 /TP19s7x0o3mDGmGmNwb1pPz15B7zYYWqQBn2x6Bqb368p8jGp5MDXT4DpshZtFG86
	 o3I0To5oMcQxd+rnCkLkS/ql9KjwpuCT6jOpr9ZOkOMjQMAgCtHgKr/K12LQ4FEf+/
	 bxgE4x9rjaW7A==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c15c42a45adso6365366b.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:01:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rri35KD3XkOFgRiH5QhgeTwki2mGxWHJv+qi9o8yufr2w+KLExcc6j2H5/NWarmSJuX7ZGBzz34Vw==@kvack.org
X-Gm-Message-State: AOJu0YwWGNPilugWCTLq/Aq36QNws8q0Kq/PFd8uvvCqFM4sczEXgvRN
	nQ6Mypb5/iLayNrsbyQGG1E13yvL8PIZu0zhIQs/xmwi8CnCCPrlwNtiFqKDJhBmRU1nu/mNaSs
	wSspSJchLa/UEaooULTIH/WmIgq3/mdc=
X-Received: by 2002:a17:907:d50c:b0:c15:d08a:2cb1 with SMTP id
 a640c23a62f3a-c15fe271f91mr593752966b.0.1783958492729; Mon, 13 Jul 2026
 09:01:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com> <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330>
In-Reply-To: <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 13 Jul 2026 09:01:20 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
X-Gm-Features: AVVi8CemNk_BxeqQs2RK3JG4sK1gdF8qRv2pw_9fmYBGp6XJBiRqkijRIQCRLiw
Message-ID: <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B30E9180012
X-Stat-Signature: skax1nwwysr99d6fnfrdsuet79fga555
X-HE-Tag: 1783958494-132020
X-HE-Meta: U2FsdGVkX1/7j36M7nqnsq8DWpIm/Br7u3RZmvnXRy7o9CddrMna8rrPRPncWuOgPKNtUo4Bg0bckqEaOk2Pjzj+UrdXZqx4v8UljLMsyzYU8MkAmnREOc/NHK7E9K15xnu+hrAj6eIJ3MTsQMi8ACZlPKo8cDpg60Glvby/4qamXbXfpf6DoTnGS1GsUK5VT5ZZ7NzGCvsbnFhnbaiyiatIqf6PQCKKTjZYeke9dBKq+J+cdb7Cr6I4eDhcdhu6AgyrB5LC4j7TdXA/LbX/l7NXIxjD9sLsJglhJO7Z8c8G52vEKNJM6pFis+9XIOAfBdQknHQymEvHKzvOs0D6fIMjGbqmnIHbQuhOU8Q4lor3YlG5jTssYOm/Rld9S9rT2TxcWKST6H5SuoLT+9auAlPEK/sovIesEh7XDUDFoF2/nW2qqrLN7dyRUNLRHBZ6aH5qkWrOjYfP2Jxl6H61Kkyji/ssMUFAbRUIZPLdYp9k0I6et/KRRM7LMV/t1hqjQkMEzMEpFAJ3LLZTYSQx8p708TY9XTsgafbT1f6TzkqvAdLJA1ROdZcKYeZNYKx8FCDjBYyCAXy4XFdIdf2zIQLr+XogxjcOH/QEmjRuzN2jVMsO8D/BMA0JKyUSp0tRDjIG8XVbAYX0RxmWj0VU0H1RKxgV2w0QejIf42Qg4uEE5+1yu5Qa5lSf21f0cR5VT1V2jUj5nbtx9hYgyyumFJfoU4Tm8sNuaLFQXuPzCgoPlOdBa7E7H3tbepqYyAXTewd3uUOXMEXgr9sCJW8HA93YauTKWkv9f0GRli14ZMNnNAodjRC/bhmOH/XVaJ17Q9nzJkOcxmryOXgBrF05i0USUK1VUfS7meA6AAf6CdR+RXO4j6CNTb+gJ3Pop3APOHskUNGwQH5XCPrfMHAhEIta8E/XWFggDyo5hmj/Ubam2MChn2wCxEdH6QCqKq/+jro+uWurgo/te9tRR4s
 z+S/x/jK
 bwk41n46O6E45fIsbodhzI26z1Bx8gKvIBPVCJcOwaKYcJ3t7ZOWpsO756p9zUzm5JJnWoZqHGhththOgzSflz3N3QmsSPNJBJdt+ytLRyQby1p/cFFN/LwMiMT3BOJmP6pU1mMmy0PcXqH8qXAs6Txvz0VMpbhKiemncrDkXpzXqfEYnogn2Bj8y0MlhOWw52ENx0cNvR4kzA/lx9hKQuO7KJ6hCGAogIbcTlNFnQfreqMWW6BsnRRjzwakMNqmNrIzBsQtwkciM1O47rNL61CSWBF2WORfQWVb6SWpY9qeCc+Lzhzn0BKOnLnoaq3hjBnRQy3o66G5NIs2HqLDf2gcmU1R4PWT+amCEdPGrHuy7dgluQaUIHqwFuOSxPWvMWKG5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 8:57=E2=80=AFAM Youngjun Park <youngjun.park@lge.co=
m> wrote:
>
> On Mon, Jul 13, 2026 at 08:50:36AM -0700, Yosry Ahmed wrote:
> > On Sun, Jul 12, 2026 at 7:57=E2=80=AFPM Youngjun Park <youngjun.park@lg=
e.com> wrote:
> > >
> > > This is the v10 series of the swap tier patchset.
> > >
> > > v10 folds in the Sashiko review fixes for the selftests added in v9 a=
nd
> > > rebases onto the current mm-new. There are no functional changes to t=
he
> > > core swap or memcg code since v9; see the changelog for details.
> > >
> > > For context, the bulk of the series is unchanged since v8, with great=
 thanks
> > > to Shakeel Butt and Yosry for the reviews and discussions [1] that sh=
aped it.
> > > The main change in v8 was the interface change to use memory.swap.tie=
rs.max
> > > with '0' (disable) and 'max' (enable) values. This mechanism was sugg=
ested
> > > by Shakeel and Yosry.
> > >
> > > This change allows for future extensions to control swap between tier=
s and
> > > aligns better with existing memcg interfaces. It is confined to patch=
 #3's
> > > user-facing interface; internally, patch #3 still uses the existing m=
ask
> > > processing method, which is implementation-efficient.
> > >
> > > We also discussed tier extensions. Thanks to Yosry, Nhat and Shakeel =
for their
> > > valuable feedback.
> > >
> > > Here is a brief summary of our tentative conclusions. Please correct =
me
> > > if anything is misrepresented (details in references):
> > >
> > > * Zswap tiering [2]:
> > >   Zswap can itself be a tier (typically the fastest one). But, until =
vswap lands,
> > >   zswap cannot be the only allowed tier,
> > >   since it still needs a physical device for allocation;
> > >   that restriction can be lifted once vswap is supported.
> >
> > Does this series support zswap being a tier? I cannot find any mention
> > of zswap in the patches.
>
> Hello Yosry!
>
> This series does not cover zswap as a tier yet.
>
> My plan is to land the swap tier infrastructure together with the
> first use case (cgroup-based swap control) first, and then follow
> up with zswap tier support in a subsequent series, continuing the
> discussions we've had above.
> (I mentioned on cover letter, right above the overview section)
>
> Does that approach sound reasonable to you?

How does swap tiering work with zswap in the current series? I assume
zswap is just enabled for all devices in all tiers? I wonder if
introducing zswap as a tier after the fact changes user-visible
behavior. I guess if zswap will be introduced with a default "max"
value it will more-or-less be the same behavior, but I would check all
user-visible behaviors related to zswap (e.g. interaction with other
zswap interfaces) to make sure nothing breaks or changes in a
meaningful way when zswap is introduced as a tier later.

