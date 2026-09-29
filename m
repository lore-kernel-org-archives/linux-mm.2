Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55A21CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 11:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E645F6B0088; Tue, 29 Sep 2026 07:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13326B008A; Tue, 29 Sep 2026 07:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDB766B008C; Tue, 29 Sep 2026 07:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A03006B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:54:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 134CBA040A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:54:59 +0000 (UTC)
X-FDA: 85266643518.30.4A73712
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 279D9180003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:54:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M10x7lp6;
	spf=pass (imf16.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790682897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S0aLT5GhtdTKzc7SEqO4ZKrTggwJ/hbn3y4IvvHxkXI=;
	b=Trg8es1ql/g1nknT3k9R1SKPfw3mfJP2kPoMnTfm077aUyx0VwEqTJFpH+kFWvb9BDYTbq
	PYp8NW7jJL3sAsnPpr5w87T+BKHpTYnq/UzNMiciOiWoZhjFYIfF0F0YkwKtafq4fw6T97
	Lut/fH+XQpOiJFImCg/NKjSSVpmHHHs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790682897;
	b=nirJB4DLyzCt0TJWb2FiiSb7MtZpuplQgcda2PNZfVuWSq67cNy8vYs2zRA8jlyC/2va7/
	ga1s6PKlYUauaao7ZMhaAMEpg/sF5feWWCoYbob4pgl9pvTFLi/L5Jh1K+JdmU+op/BTJ2
	c4l5OIpozpms0jzu7Lr+KJq60pCqvOo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M10x7lp6;
	spf=pass (imf16.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BC3344780
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DED1F0089E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790682896;
	bh=S0aLT5GhtdTKzc7SEqO4ZKrTggwJ/hbn3y4IvvHxkXI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=M10x7lp6AAYxWfozwpiVSaz6eD3KM81OR+04WgSLlTBECqAaypzptuVVr8yosWEDS
	 ysNwVNr7mvaJ4uRDRfYhP2nJpm+FR8kRBGI5aNKmMyixKmNf2Zx6v2ubfui7W5ggQT
	 0W/7fSnHaTOMKR4aeJOXCuPLtP8nes9Hd+/+OK2D/PVMnaBRjwNVio8/L7h2yt659S
	 +i3oBvdUaAHrRJd6mWR4UNMJj6lqokowPKaOdpfN3C68PiDXt096AudJXDMbogb/Fj
	 IJ0A2+h6fAtUeFHSPCehtQOykZQeTdD+mnX5gGStYdT0X1efVJV7D5iHkn0ONeOKpt
	 CBPnhLvi3Jubg==
Received: by mail-lr2-f34.google.com with SMTP id 38308e7fff4ca-3a6502af787so30203691fa.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:54:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy1pVXqbAHZ2t01ra/GgxpvtvBbrkuQGnpDl1g3Sp+nSWB4Yfz1y3Wx0FQNnFvxD1Sni2d4+lpP4w==@kvack.org
X-Gm-Message-State: AFq9FYJWNYhx8BEhPAFO5QYZalpsvCJsAh6z1Vwradmv38SkzDwRIMQO
	NUoKZh/edmXHiy8nNRyiqcDIRZKkN8uTB3K8OhsbyFlgjuGsBvlSHR6DcnTJkeeIskICh4kSYr6
	eLuebr39sSp3nnDPOL3Yq8id8SvnTJm4=
X-Received: by 2002:a05:6512:3401:b0:5b6:184c:7d99 with SMTP id
 2adb3069b0e04-5b8df093114mr5498654e87.34.1790682894230; Tue, 29 Sep 2026
 04:54:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260926-hibernation-v2-0-235f69f3ab2a@kernel.org> <20260927150257.c9558f807114f2ce9c6675e0@linux-foundation.org>
In-Reply-To: <20260927150257.c9558f807114f2ce9c6675e0@linux-foundation.org>
From: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Date: Tue, 29 Sep 2026 13:53:10 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0jZnGzUOf6xsu-J-4cFOeY8yaLivNNUoBCnR4VJQisqHg@mail.gmail.com>
X-Gm-Features: AclHuK8pzzjTvTId2wLoBf-9vLWfrBr9lHS8pLDp-rGJYqJfLaSLwRr15r-Wayo
Message-ID: <CAJZ5v0jZnGzUOf6xsu-J-4cFOeY8yaLivNNUoBCnR4VJQisqHg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] hibernation: make safe_copy_page more robust and
 remove debug_pagealloc support
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Alexander Potapenko <glider@google.com>, 
	David Hildenbrand <david@kernel.org>, Marco Elver <elver@google.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>, 
	Pavel Machek <pavel@kernel.org>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 279D9180003
X-Stat-Signature: 3gtm6ztkyqh589mwk8uch8j6k4gppy51
X-Rspam-User: 
X-HE-Tag: 1790682897-250747
X-HE-Meta: U2FsdGVkX19Pfkjyn5Yb2tVQumYyPxLj1VWJHf9iN968BUp0E4UmUcaPUogB/ODySkSSPUbEs6KyigW92N3XsGVKVgXAvAbBBdPvM1IyUwOnbL0Hho6nthx5xGOo0SXRnzpfGfv4IiFqib63jL01M/tEf2XgvsX9o6uJ8qyUytwEl7UdZ8tyBf7QT1vqaZsHFT1y06tuGC5UbBQ65N1ldzrqOkk8rlFSloAhmjCavvemaLX44LBmFLA/aJReiT9TJUd5elvPow+z9juOU8gv1/SytaGj3H6EvRW8IYcOl9kVqY7Nbq9NPJsfoQ80fKUJqLBfxigUl2wfcVCpvcjT4ikjr2J8K8yjN8S4ealGgNYU1qeTxCfdmsc5OrV4MyPE6OSG8Rd8AB+95Y+kJc5Hdri3g8fDTNZwBQM0pTCDMZJfFgkaWTsNY2Pt6hprcNXHmwA9AjIgzm30fk3CNxhfCJQKo33nSmkeWB6iOeL0cxttBxn3JPMdtS9m2vCL9AAz28EHpJERfFPmyYV4kb7xb5kBNjRVSMt+Fy/UM1ZxCTvO7I+MyN+pP8RvJPF01TOVGUkuRbvUJQG2pDOpPYssEREZyXR6V5ZhbXll5WkmkBY9ZJz53PH9j2P6c1CsbCbYzY8TN1l9VhznEN9lG6WHEUd3mFwftLIaR7V6Er+UCDAeoYlzVCUsPDxm36OjnjLx6FZsyxqoLHsxo6/mmBiXj8OlvnqDfsjFjdZ2UBZBFDAhRIgppiGAl1LlluzrYW3zgWRPoYtwfsHz6tX1G+l4AtJ8X8myTb7EEz4apEzkw1LqsQXYqCT5uB/Yenor8ae3o0UZxlo3yJM/fBYXCIcnTaGYA9Y8h/Uo9MubKv5W27ShLYjMMstpo0p5GZRFH7o8fL5J5/KHTvVtPrikEnY1/FNZMq7zPEP4bJ2Z303x478d72HCvDtKsfUOPCb9L4ngUeNRPRpdvNBfVF7b/wo
 032yq4ab
 /6lTaWtFdliCsa1Lc3B9H/BP990cNKOhjEQLH6o82PpiUE/07v2253BRgrxZk0SfRWX862snmDc+BQonQw7goQE7vEYYmHuX4GUo/trBRUOrz3sWPj/vCyK1vABkfKfryWHKsUKLyC86ZMYisxyPTdTScPQWMhqvkWjOyFsPz97rKIp7BrHFpXDuf9/mKHvMjYsUvdIFursb+dsypxbODKYyrk1Of2WEBLVcsoVI6X3GOsUv1cCBXWv8Wz1ckm/Skc/dBcmXOu6g3IzxamErT1fqhAdNyJuPV97v6VdLtnRjH/b/whOe2W5Mc1BMcsjIdFRB7Q7GhyFLm4GXvOAkB+sgDJrP/9Ie2HUrNOz7DNe8cgSsVxcSi0TDIc4OVa2xZiJyoi1O8CFOKeC4R+eDHccAb3LQ7qYzqGKvi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 12:02=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Sat, 26 Sep 2026 12:26:29 +0300 "Mike Rapoport (Microsoft)" <rppt@kern=
el.org> wrote:
>
> > When hibernation creates a memory image, it uses set_direct_map() APIs =
to
> > temporarily map pages that are marked as not present in the kernel page
> > tables.
> >
> > Initially, this was intended to support debug_pagealloc along with
> > hibernation on x86.
> >
> > With the increasing desire to use set_direct_map APIs for hardening
> > features and with their inconsistent implementations across architectur=
es,
> > using kernel_page_present() + set_direct_map_valid_noflush() to save
> > non-present pages in the hibernation image is not very safe, to say the
> > least.
> >
> > Worse, some combinations of debug features, such as debug_pagealloc and
> > PAGE_POISON cause a crash during restore.
> >
> > Keeping debug_pagealloc compatible with hibernation requires a complex
> > infrastructure for tracking free unmapped pages with a page flag/page t=
ype,
> > verifying that it is actually a free page that hibernate_map_page() tri=
es
> > to remap and making sure there are no stale or failed page table update=
s.
> > With init_on_{alloc,free} and/or PAGE_POISON on top, this also requires=
 the
> > ability to map and initialize these free pages on restore.
> >
> > This complexity does not seem justified for a somewhat niche debugging
> > scenario.
> >
> > Instead of a complex fix to support hibernation with debug_pagealloc, m=
ake
> > sure that copy_data_pages() and its helpers properly handle errors that=
 may
> > happen during page table updates, explicitly enable saving of KFENCE pa=
ges
> > and disallow hibernation when debug_pagealloc is enabled.
>
> Thanks.
>
> > Mike Rapoport (Microsoft) (5):
> >       hibernation: make swsusp_page helpers static
> >       hibernation: ensure secretmem pages don't reach a snapshot
> >       hibernate: handle potential errors in hibernate_{map,unmap}_page(=
)
> >       hibernation, KFENCE: explicitly map/unmap KFENCE pages
> >       hibernation: make hibernation unavailable when debug_pagealloc is=
 on
> >
> >  include/linux/kfence.h   |  29 ++++++++++
> >  include/linux/suspend.h  |   6 ---
> >  kernel/power/hibernate.c |   6 +++
> >  kernel/power/snapshot.c  | 137 +++++++++++++++++++++++++--------------=
--------
> >  mm/kfence/core.c         |  52 +++++++++++++++++-
> >  5 files changed, 159 insertions(+), 71 deletions(-)
>
> I'm not sure how to route this.  Rafael, wdyt?

I don't have a strong preference.

If you decide to pick it up, please feel free to add my ACK to the
patches.  Or if you prefer it to be picked up by me, please let me
know.

Thanks!

