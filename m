Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE20EEDF038
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 05:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C52F6B0005; Thu, 12 Feb 2026 00:07:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573086B0089; Thu, 12 Feb 2026 00:07:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474C86B008A; Thu, 12 Feb 2026 00:07:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 345B76B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:07:36 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C59951605CD
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 05:07:35 +0000 (UTC)
X-FDA: 84434621670.18.F6FBC74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id F101A140003
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 05:07:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VThiPv5S;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770872854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8Boom/y1csbLaEyLNSP9DqTYkdyPshuMWp/CxlEwfw=;
	b=5X2RSl0gX4tG29e7MsVufTNNnEM7EgPQe6GvAnZ8gRWJydsTmd9JYWYBjCteVJngvkSE/j
	8llEP+IqCwAWvErfgSOIMz8pbYfpuzVOLUYQ9+NIfDo1UHIRsEzdLGCD7U22aoP30MsExm
	3BaOUwAF/xMKM1iIn7lFnUkGm9VjTgQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770872854; a=rsa-sha256;
	cv=none;
	b=4l+heoml3OnTdkwnAJyg3SQVDWg1gb5VSKRV0L4zTkNwXfF5Heww6bIFlhnJv4DQ0lUJ4F
	tEIvo+4g/XcsVCcdjBmH9fUKIkasrg2r7bLfNH3GK35IStQIdnlJCsRZd3ZGtwgxk3hIFq
	bclQuQw2LTnzXt2+xUN3i3L33Oopw98=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VThiPv5S;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C62C60010
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 05:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A20C4CEF7
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 05:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770872853;
	bh=EosASMTX2s9CcIWPWVdD9Epc98EOoJxCZ11MXv+yVnM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VThiPv5SMbZEL/DadPMgq+mMtrYpHmln/TSs8AhEw97M7Faeeuws9vFsH/bCmqQpu
	 33dlouVWkrWPCw1pE80IHQqSFazOJOEkWlHdV/UHniqoY/VJFSL4g6I0b2QF62SFjn
	 JphkosFI2fy9ggHqegdKfnsPbznEG7wdwxQwqeECOpU3r7Kl8FMDuqBIEBDBuoAA5g
	 BmhZF9+nJ/SxHVLT/fKJu1TJnGVT8I8kHATrFpK74MvOrTccFT6DqBAkxGiOvT7NHQ
	 EyH11HrBCNf+QHgfdcYfHSP2AnBin6I02bH3NyfJgOrOk+tAGLHCfD/oR1EwtD0rdS
	 5d/P67ie+zDRw==
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7966d821baaso13991277b3.3
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:07:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWpByQHZ+Gt3m8PZUpXTZ7bN4LtHv2w2KoyV51Vfhdue3BGO2T67TwJNXsmU5LD+9NHFj9RaSbgjA==@kvack.org
X-Gm-Message-State: AOJu0Yzm0+qOLQmGDwQHIirbLmVb0ZAQ3sDclfD9YJGNPOzUIXA9bxsz
	qZk8z3tTlcw6Ltl0UV7DiZcYFILnroFPUIJCtEY+cdmAT2G6sX1w8jijG39qMO0Ynrqhe7t6zyb
	OykkDiNuKipe4BQnagwhbk+NX6hj1yQvSvt9BuEEHHQ==
X-Received: by 2002:a05:690c:fc8:b0:794:dac2:89de with SMTP id
 00721157ae682-7972f113502mr19419047b3.17.1770872852305; Wed, 11 Feb 2026
 21:07:32 -0800 (PST)
MIME-Version: 1.0
References: <20260208215839.87595-2-nphamcs@gmail.com> <20260208222652.328284-1-nphamcs@gmail.com>
 <CAMgjq7AQNGK-a=AOgvn4-V+zGO21QMbMTVbrYSW_R2oDSLoC+A@mail.gmail.com> <CAKEwX=OUni7PuUqGQUhbMDtErurFN_i=1RgzyQsNXy4LABhXoA@mail.gmail.com>
In-Reply-To: <CAKEwX=OUni7PuUqGQUhbMDtErurFN_i=1RgzyQsNXy4LABhXoA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 11 Feb 2026 21:07:20 -0800
X-Gmail-Original-Message-ID: <CACePvbWCZhdF6vyP6BEhyCGXurST7EewNk=HGcE_qVGAwJpFPg@mail.gmail.com>
X-Gm-Features: AZwV_Qi4jBzTgP6vyYE2l1ny_j4kHipqIQCjBTH1peMA4w-c1bJcYp0Pl-VIEPg
Message-ID: <CACePvbWCZhdF6vyP6BEhyCGXurST7EewNk=HGcE_qVGAwJpFPg@mail.gmail.com>
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, hughd@google.com, yosry.ahmed@linux.dev, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, len.brown@intel.com, chengming.zhou@linux.dev, 
	huang.ying.caritas@gmail.com, ryan.roberts@arm.com, shikemeng@huaweicloud.com, 
	viro@zeniv.linux.org.uk, baohua@kernel.org, bhe@redhat.com, osalvador@suse.de, 
	christophe.leroy@csgroup.eu, pavel@kernel.org, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com, 
	joshua.hahnjy@gmail.com, npache@redhat.com, gourry@gourry.net, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	rafael@kernel.org, jannh@google.com, pfalcato@suse.de, 
	zhengqi.arch@bytedance.com, minchan@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: F101A140003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: yucw18e9kfj8yp9nugcs41734w6u7ax4
X-HE-Tag: 1770872853-283937
X-HE-Meta: U2FsdGVkX1+8ugFX7C6vMeuDWMy72WbtFf2eaa1AfZ+oCdPjdrTv7txoN4DDzLPlaoiC1eSuY06KIdJC/VPqhRnbFEp0KovbfrVypZWRtfC4S0xj+DFg+IIvyldy5s0GXfpCscjEfPJqQocpkwFfXrBa/YC01FAwIvRt44jVaFERU+CnGRRibQP0YnJmCIkrWDcGX8+jxgU8Oo4oPacWSSXm4NwG4bzEa6J0NuNAKofQWbzk77oDJhP0PViQBKinGCLdQRm84y3AAU4IqlhnneDvJUJpctZkUaU9X26e84UuEE/UkLRIoAQXWv0TF/CXZahEzU+vO7yo9wR8uUf7nf3zL1xreI/quVDBuhGrfv8CdxbOpFJAiXtxK+HwbNq0sW1yY+VvD/x4FZuazOdgBQLWivR9KKvTTvRBiLwX6eqXbZu0DLtl5zcmwu7lKl1OXdinqI0/1zyddSZHhGGifS5GIDxi2XQFiZu21ATnHwbYm6FtQuet3xDnHVA315Ddk+OcWkVQyba9BdY3sNQ5yb+o6VfoRZcKfR40Stv4pd7mxZz2B8fKgjvktehvLhzr/Qro5b+BNpZP5C4GeaUk4EvTypNRtG3dbVGn7ndMXHV0p636v8SFJADUeU8li3Mf04TpmHi2iuiP/OS7u5qWiyqwkmI/6IAe7taNNuss4NpyP8UAl+dSVMStngpBOge6C9TDHDsJcWa3Ua1DcYTq4OOTQBS0RcfmRJffdXH94cxUFRraOOGIKZwP/kag8q1HO2X+xtSbUdRR8rgrKZE5fXXrqjsWWAXuWdOZKkkJ5DiD12wrIDUbtBRoFazoYBqqX0gmk9JR1vdlIKOzkaoIWVRWytE/Anf7PCB+2wlOE2FnD798qwMUVJR/bwd39DG2B1+TRplltx1cYD6KCsY/GZtNL620qej7q/i5zIEuHKkyFvuSNl8xoVRqRXTmJ0PLXDSVthxk94fGWuyojWu
 qz1qWxpE
 CDlLIZdLYy+m/QF6gcrBFyNSsPvQ+tqxzmrweN8nbMYz6RqRxqfEntuIZ9qt7H+JlNz9SqwRXLA6OzPPmYIIJGk7okBCppZowOhMwgTa65mLRcYMPPbQu4vzL2iWbmSRpwKf+9I5YRFTxiBJNI7WMffhryvSlef+Z4Ed6c26xM392Yem2ZZHsGGRXlwHQhosGEJaf83+tba00TcmPXTJ+5pi8AFMUcihXWby1iw8ZL/OzlI2qwk73AZ3+428k4HWKIUrughHx9VWWxnxlqvma29PxVJaf59DlSz/UZqS8Etcl4kBuuuLlmPK0fy+gBPOBSJNaxDReCqq5ESczbqvY0zm/BEkLfY2mNWY9QVXTLYASb2V1lUoseoQ7Ew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 11:11=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Tue, Feb 10, 2026 at 10:00=E2=80=AFAM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > On Mon, Feb 9, 2026 at 7:57=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wr=
ote:
> > >
> > > Anyway, resending this (in-reply-to patch 1 of the series):
> >
> > Hi Nhat,
> >
> > > Changelog:
> > > * RFC v2 -> v3:
> > >     * Implement a cluster-based allocation algorithm for virtual swap
> > >       slots, inspired by Kairui Song and Chris Li's implementation, a=
s
> > >       well as Johannes Weiner's suggestions. This eliminates the lock
> > >           contention issues on the virtual swap layer.
> > >     * Re-use swap table for the reverse mapping.
> > >     * Remove CONFIG_VIRTUAL_SWAP.
> >
> > I really do think we better make this optional, not a replacement or
> > mandatory. There are many hard to evaluate effects as this
> > fundamentally changes the swap workflow with a lot of behavior changes
> > at once. e.g. it seems the folio will be reactivated instead of
> > splitted if the physical swap device is fragmented; slot is allocated
> > at IO and not at unmap, and maybe many others. Just like zswap is
> > optional. Some common workloads would see an obvious performance or
> > memory usage regression following this design, see below.
>
> Ideally, if we can close the performance gap and have only one
> version, then that would be the best :)
>
> Problem with making it optional, or maintaining effectively two swap
> implementations, is that it will make the patch series unreadable and
> unreviewable, and the code base unmaintanable :) You'll have x2 the
> amount of code to reason about and test, much more merge conflicts at
> rebase and cherry-pick time. And any improvement to one version takes
> extra work to graft onto the other version.

I second that this should be run time optional for other types of
swap. It should not be mandatory for other swap that does not benefit
from it. e.g. zram.

Chris

