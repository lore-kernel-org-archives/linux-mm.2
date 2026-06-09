Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF22ECD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0E26B009D; Tue,  9 Jun 2026 06:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA16D6B00A2; Tue,  9 Jun 2026 06:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D906A6B00A5; Tue,  9 Jun 2026 06:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C692A6B009D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:04:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8682A1404C9
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:04:14 +0000 (UTC)
X-FDA: 84859938828.14.5B0C992
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8BC99140016
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:04:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ienTDyd5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780999452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+MeZs9obcZ3lUPK/UEdDwZZjzRqi4HCT0YL9x/bz95U=;
	b=BvYKYVJ0lUV1EqBBU/vugWjwi1B8pP7lvJsoa9ltSYVVK3jslEy0echR0URjuXtjn6vZs9
	XJOfqWkrveAz61TCQP9TX0VwzPA+bb2I8KILMFpE/68PJZXJQHcxS8Ne2Aqe5mqigw4Y5O
	VEVREhOQfUCKSKYzxXRngGgIHvLl0rk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ienTDyd5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780999452;
	b=8a3i476vSISD6YiSPs1UfthA89tQsb1/6BwzG0l8ikXnuiHialbTfEeOFEmiLdhrK5bpiP
	Mq5OWhr4olFHak6Bi+ds+Iaf0f9Z/T4Gll7kdE/gW1CtQOpoYS5Yb1kkz34ayqTAdLbEse
	G5bqAmOxivZAkjL9S4sTIINu43FXdjM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C388240E29
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92051F008A2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780999451;
	bh=+MeZs9obcZ3lUPK/UEdDwZZjzRqi4HCT0YL9x/bz95U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ienTDyd53bqKYsembdNr0XOcC0E7PSBw4ZeOr0ufuUtJ6x5SM3yWYlkf18QLDt6wt
	 r8NXW6VzCGioL0iwZahAd1m6SJPgs10JHJSujck95cxraC08FZ5n8fWJmk/bpaaYKW
	 Revh5mn4Fv9QzNKX2b8dQm4cwk3IqHa6sMnmxud+4aboz4XG9xFrsI1c4v5lhMBEkP
	 LkMo3ghnTomSzpOR1csFH0tYGqOgLpeFYt1Vz4jswymsA5RqFn3ToxNSddDDlyD4jw
	 9I1l0uizqCVii7tvYVWDRv9tmO0ZtMvi9MJauO0kwCOTzDa4wr8H2nP0eKsAr2oMt9
	 DHXkxlNvZSV3A==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-9157ec935c5so836488185a.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 03:04:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+05xYV3DIzk3L+oecyFlDUwGTjHOg9MUu/9dZOgiXcNKyIBy48KUkev/gj06KcQkc5EdiACBjboA==@kvack.org
X-Gm-Message-State: AOJu0YyeVAFVQzoZAka22j+qAJUdZEiAM/C4A/fDequdG99Bwn6bNdic
	YVxN9v3ix3OHfgQvgILJGBmsvheO+wkCh4FZC7DHvqborvUYtt8aKJAkRp8KwlfWzxx/zc0p+Zt
	Fb0CqjgJIEfzKYtT1NxleOaoOdRmYjHs=
X-Received: by 2002:a05:620a:2681:b0:915:efc6:e918 with SMTP id
 af79cd13be357-915efc73ae5mr810085a.51.1780999450900; Tue, 09 Jun 2026
 03:04:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260608143242.2869392-1-usama.arif@linux.dev>
 <CAGsJ_4xOcTTkpVnno9RgTAkj5-62dLASUa9YnJYSLOEiU1ULww@mail.gmail.com> <50c03b64-1809-4000-88dd-ab147ddc6620@linux.dev>
In-Reply-To: <50c03b64-1809-4000-88dd-ab147ddc6620@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 9 Jun 2026 18:03:58 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zhfTJ-2f=scbYW9peieLpJCgqrOUi9aV+OFqRsM+FKUw@mail.gmail.com>
X-Gm-Features: AVVi8CdM1B4we3xYC38gIoo6NMFRsjfPZfIqdxezrPL8vjEj8UowskPVnaMPaMc
Message-ID: <CAGsJ_4zhfTJ-2f=scbYW9peieLpJCgqrOUi9aV+OFqRsM+FKUw@mail.gmail.com>
Subject: Re: [PATCH] mm/swap_state: remove unnecessary lru_add_drain() from readahead
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, riel@surriel.com, david@kernel.org, 
	baoquan.he@linux.dev, chrisl@kernel.org, kasong@tencent.com, 
	linux-mm@kvack.org, hannes@cmpxchg.org, shakeel.butt@linux.dev, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8BC99140016
X-Stat-Signature: fcwpndqse44jhxg179935pzcbbknzx93
X-HE-Tag: 1780999452-902539
X-HE-Meta: U2FsdGVkX1+FvFvbWlosHGS2cTiKF3kYA7Hz3SRdQuuFfOxj3y04cnZ+2GPVdli00uHnCLAV9qbKnKMWtwD0Lb2rZT8E00qbOg7/xnjbNUuPIO21Rr6UjORB3aWROKgI+bf1u2msK0LkTQWdw5tNphFX4pXYH+//mYcHXUZLuaQxO6mfusDuMzPTDPUQ5zo+f59kLSi+c0ZBMFhRaD7o01syf9kSsxVTGPOGKmDEbc1D4IQZPHihV9jvwg4OQGV0tXqT6OFnyKeUOhNAASnia6i4Lk811b6gAcQ5xxXGESElwgFZBoE0fN6grQzpLYYO/8P0kJQkxHrJK5l6v44zHAbH2DxwmqOofs3DRtpWC0j4dtEJEZgYJISLI5eysXxS83GL7EWQ7KXsRjpYRqJpHCo+XQpFcG7wBrib11QcnIMp/iTV5VXS0ovxufE/KwBUWmI0VHvpAtqGcnd8nYaY4jrghEfUjdXm4al9gBsrDnU/twlSw+wpGH1Z88JhmLNqCRmegdJ896/3gfUfNZxOQYGdiiD3mZZz0PFmGmp55kjUX372keKeW3lGiie5z/7ALpDIAsKSU25ujvS4NfJJqhinCuuap9nmEO9R+okFMfedLihlXxGRF4Jtu22FiuSWu5H77MEpSM/5lU7akvVDzyosEn9ZQIxq0roVCGHg3YnCsq2PzdZQ4icQmX7mAhYs8xUPFFB2NmMhhiHlo5k6IfS/Gl5KpQQB6sKctMcqFAn6XNqA9ESpnCXDWxU4JP2bgIJKaAeoef9oMRqUE5CaMiuiBWwCnuKniQmDzWtkIEQRyrMH+7ZMfPtcCa2/t55z586FuBAiyjxtXrNtr+owmdylMQVB0zWRvJddzac+pBqhkU6q1xia/rDmNsIS6Z300pWtf5+h7XIpZrne1hXfIhJd58SwkY5c6z2s0ZZQhe/mH/YDsJgWKKQx172LfWvU/vRTxGokJU3xqff6dYj
 Wea//EVk
 4aG+AdlJodVRz28fMltcfsc/O+hMnXy+920lNBdV9wjn1ADDfPDgjLrXEWXp1jN7H2efFIVUx9NcbBsiRVSn44z9NJW+udfhIx1NeuFCL6aoRl1Bve9fCHCGUzQoYMPxfCk1S0s7Zx/WuA5nZ3OsJBv/rTDfOyky4i+aLGpQhK+xhu2sdfLr2dZ4NNOO1YtoDLvRRmG5CRGkPihLhHBB+n+Ipw9jeaV8yBAQkj3Oe7nbcZ9uN0qSWUk7EHI3yc5/7abEny4Dw/WfsdkWFIhhxFiYSZyKNsHZQm2ISMS2/XUeGtMBfcR6TKMqwm/omsPV4KkzRzQvPvzWMu7hebjfXPrew5XMvy1XIafCy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 5:30=E2=80=AFPM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
>
>
> On 09/06/2026 09:01, Barry Song wrote:
> > On Mon, Jun 8, 2026 at 10:33=E2=80=AFPM Usama Arif <usama.arif@linux.de=
v> wrote:
> >>
> >> swap_cluster_readahead() and swap_vma_readahead() end the readahead
> >> loop with an explicit lru_add_drain() call. That drain is a leftover
> >> from 2.6.12 era code and serves no functional purpose for the callers:
> >>
> >> - do_swap_page() ignores LRU residency for the readahead folios;
> >>   it only needs the target folio it called swapin_readahead() for,
> >>   and if the write-fault path needs the target folio on the LRU to cou=
nt
> >>   references accurately, it runs its own lru_add_drain() at the
> >>   wp_can_reuse_anon_folio() and do_swap_page() sites.
> >
> > right. as i can see the below in do_swap_page():
> >
> >         /*
> >          * If we want to map a page that's in the swapcache writable, w=
e
> >          * have to detect via the refcount if we're really the exclusiv=
e
> >          * owner. Try removing the extra reference from the local LRU
> >          * caches if required.
> >          */
> >         if ((vmf->flags & FAULT_FLAG_WRITE) &&
> >             !folio_test_ksm(folio) && !folio_test_lru(folio))
> >                 lru_add_drain();
> >
> > and the below in wp_can_reuse_anon_folio():
> >
> >         if (!folio_test_lru(folio))
> >                 /*
> >                  * We cannot easily detect+handle references from
> >                  * remote LRU caches or references to LRU folios.
> >                  */
> >                 lru_add_drain();
> >
> >>
> >> - shmem_swapin_cluster() immediately locks the  returned folio, waits
> >>   for writeback, then operates on it - LRU residency of either the tar=
get
> >>   or the readahead folios is irrelevant.
> >>
> >> - try_to_unuse() likewise locks the folio and calls unuse_pte() withou=
t
> >>   depending on LRU presence.
> >>
> >> Folios newly added to the swap cache by the readahead loop sit in
> >> the per-CPU LRU folio_batch and will be drained naturally as the
> >> batch fills (FOLIO_BATCH_SIZE),by the next reclaim/compaction
> >> lru_add_drain_all() and so on.  The unconditional drain only
> >> synchronously flushes a partial batch and forces contention on
> >> lruvec_lock.
> >>
> >> On a 176-CPU production host running a memory-pressured workload, this
> >> path was observed to call folio_batch_move_lru() from
> >> swap_cluster_readahead() ~28K/min, a very large source of LRU lock
> >> traffic.
> >>
> >
> > Do we see a workload improvement? If yes, can we put the data?
> >
>
> Hello Barry!
>
> So lru lock contention is a source of issue in the meta fleet.
>
> This problem was specifically seen when I ran `perf lock contention -a -b=
`
> in production on a workload that has a really big anon heap and heavy swa=
p
> activity.
>
> When I tried to trace with bpftrace who was the biggest consumer, it was
> readahead.
>
> It is easy to run perf and bpftrace on prod on this specific workload, bu=
t
> more difficult to flash a new kernel and see results. The easiest would b=
e
> when kernel upgrade happens and this patch lands to see the difference an=
d
> I can report back.

Yes, it seems fairly straightforward to reduce LRU lock contention.
From the review, the patch looks good. I=E2=80=99m just not certain whether
we might be missing any corner cases.

I would be happy to see it queued for testing once the mm tree is
ready to accept new patches. Is it too late at the moment?

Feel free to add:

Reviewed-by: Barry Song <baohua@kernel.org>

Thanks,
Barry

