Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 175CAC531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 17:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCD136B007B; Fri, 24 Jul 2026 13:57:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E666B0088; Fri, 24 Jul 2026 13:57:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A948D6B008A; Fri, 24 Jul 2026 13:57:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2776B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:57:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2353BA001B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 17:57:13 +0000 (UTC)
X-FDA: 85024426746.15.3B14439
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 281E318000E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 17:57:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wjha943R;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784915831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4oS0neAM9sBbbD29XIiKBoe/E74msHV+fLImGO41pk=;
	b=xQnTg46q1AH6YIPhN431ScxFAnfhV50anNFH0SE+XASBZ3O1rhinL/A4jJGysD3IbhU5Rf
	YKJza2IhI5ZlfE+f8v4hsaueh7lhm0XFdRX7RCBeRLme1DZ1K3yJCpr+LoDW8eRiawGYpv
	D3ffzIgYsNiRjIUKek4GYb3uV4WZpTk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784915831;
	b=JucKxD03Xhh1XVUkUei8oxnTBU8IX/CeQiGpvJ+sk8OypeUzr9NeQWCTYNGCUvZAqlSCH/
	8I9nk+DGSwyuKDlQ4vaXKdt3yQxozKWHHgYm1Cf6GNt/+kYUgmPSLI/5BKLg1wIZETHb8T
	TD8Xy+V2WYDqZ9DgRYAYImmP0F0cUcM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wjha943R;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EA0845036
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 17:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA13B1F00ADE
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 17:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784915830;
	bh=v4oS0neAM9sBbbD29XIiKBoe/E74msHV+fLImGO41pk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Wjha943RAT77bV7zMChLZ4uYCR7BKfUkVEyZSmO7ylDcqEqa+vAwLEv5rQHgiBW38
	 pblIGXM9Ljn0Cm3dOrxwm0gvplVVuFvrFi49TXyJ9QoUH+6k/rl1iq0aWISpm7hnhq
	 Umi18EM26JzU/5wdOo2EcYVLVm00bCs8Tf5UXwyvsxYhchEBUwSHqRlkozsNLeTlrv
	 tGQbyziMhF7QMD5ezCpHePhSn3xtHMts0Ad1mXuO+c1W1PThAhQOoXG56R9rtVFwqD
	 eU2tMYokfp/FyxyFYY3wjk7S9BiK4kPflUK25csuThTBEG1VAxhue951p4CnzELQrh
	 qssqhF2jaI+hw==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c15f47e6297so77612566b.0
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:57:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpHXtasySk3dJcYnFbONQAV1sc2SS2TZm+1wVC2v/Obnk2v26xPbH40AqC/ByZH9vzq0LgMITlzyQ==@kvack.org
X-Gm-Message-State: AOJu0YzT+Xn1mwcSjzKyQVu9Qc7lKh7kc16o/I4R/7NXzV3EGvEzTn//
	m2SGbM2HZQWlXTF/xV7UgtmFDaVCAbi44nwU9MQUBwFLp0fBRz8AHnPaV+ieRdGhycoN6/qNTy8
	gVe5RSDNuHkpb24y0/NwnBptFlPefvzA=
X-Received: by 2002:a17:907:98d:b0:c1c:72b:e65a with SMTP id
 a640c23a62f3a-c1c507d0862mr350331266b.26.1784915828673; Fri, 24 Jul 2026
 10:57:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-3-jiahao.kernel@gmail.com> <amF7_GB5Rl6OJmt4@cmpxchg.org>
 <CAO9r8zPaUPddYoLz8o+g+xkb-zdkfyB+LqaDOrkzqFSePEV-xA@mail.gmail.com>
 <amIdU1lFxqxTI3Gc@cmpxchg.org> <CAO9r8zPepaekOgaDaVBWyB_F05Ezvz+AJZ8M5+NGQ4BmiJNBkQ@mail.gmail.com>
 <d8de419d-0077-c47c-a5f1-37c229a853ed@gmail.com>
In-Reply-To: <d8de419d-0077-c47c-a5f1-37c229a853ed@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 24 Jul 2026 10:56:57 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNq3bRN+mumA5tcdizStpgoqTc++FYuGjvL8spbv4Q8YQ@mail.gmail.com>
X-Gm-Features: AUfX_mzrT9xKIy9LdfhWAr5n_0886vraGnegZQOHjwrM4nt45OfxgRt4tKiwdpw
Message-ID: <CAO9r8zNq3bRN+mumA5tcdizStpgoqTc++FYuGjvL8spbv4Q8YQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org, tj@kernel.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 281E318000E
X-Stat-Signature: p8kxha4hzizi7ensw9m6gjc7g947bnuq
X-Rspam-User: 
X-HE-Tag: 1784915831-65519
X-HE-Meta: U2FsdGVkX1/aOOiI6+N6HvGUXGTeX2mC+oYyGIL/I1W7/h8ekbU3HqqPnDQceL7Q2U4PBgThqJDfHAuzhCIfFbZz/dpinCys1W4GWMqlnL+h1e8NBPnCoZlg3ZEqRPM0WGy1urA+AHI0hcozKLfHSCS8wb+l4jnJC16X9cFYjCDF22nYWEQ40ibQBQpEIUs2fO3xwIQ107MF9wO4IL8LzXyMQYgYCklQ4QwuoPTp6Nfp8k0bbFUeCtlXP3T3gBSSxtMccaDf/nzI5vyb2wnOpnYRnDgfMqNcBqcYGdYI39N6zSA2EaAlTRc4qrU2r05RhjHW3nC7jFwdlzLPnPkfhSc+b/oKl7WdJJ0gjD+gFQBLfbo1XkIHPpLJBo2WmExhdC+87AED3y3FUEo/C4SA7sSAP1G9+WrVGSITP6RmNZ9PLwh014PIfdS6Ku+9BWPLMQZ0NbwQqrrOWzV3QSBfC0/4LMOfzDwyRsIqjS4fI66Yj/NpZuCPsGCoijjao0LlMROuyQv1ji9bXQ6HoZ+hD48Y4EOGSz76uVTbt7dB53sy3YyiodqDMZAY5Su+1lk+r95Z8QRgZscG0lYH5onRPttajR92NtT+bLupSuvj1/NCvLUyLJBo2wSZGmILaK/PCa+SSHrCKLyXjeDG+jEF8P3oxZ+/+MLNbBrh7FV5fuEdhfquMlq56srK9NsX9Hw20lZPGpLRfrr0o9QRZR7U4vNy1WPx6u8GfO573EcDFFGDfYAIYcI9Gf4CLoxCKU7u6cWEnGNAT+x/Yg7aUwCvPA0KlYlNlEzi1VsIERcDWi9/hQvvp2UlyhmK+kieuNwtyAKEM1yMYln/0SmIlrlaHf2DCoELEzS8rE4Zk/Q/cWrZCr1pNyVw5jhHVrZAjAEcWruQqtT2mcIEc11IGXQaAOTi2f9YD8lJQcuEteJTDClcORuFYKSDeZZ/p89xabKYUWEYlNaTRBQci43EW57
 p4NRDZNE
 uf3edTqwQ5m5IjTmkFnlDBHsDbKas4+DlF80iWQOmc6nGfFDYtrA7AiIEGGIq7BSXn80gUOXeHu4F7xTO5xD8BfRYshqjwQPmzM7MtCiDrQSNwm1Kvemx5jPWocWzPgia6MeurghgHN9aTNuI4z9LheBuLlA/mk+QC01PdzConiHwodHtwUsHp3d7UT9GruEiBPpTo/JAm7TgrQxDc3Ix1nr4AD/7lC4/DDUwZSrC2FW+Ux4VvdpJecddhjO9ZXu6wNzKTLLeriZ9HyEuT4cL2bp/iDz1UEFsGr2FlKecW92ca7E6jPKmRImqje4AP2UklEWV3rxM67w+L4fjhrenhVEb2KSOHHxRVwsDbcPhVFYO/Jv567wGK0gfO+RgbmhMLrAnngmdCdm68rzRQWJ69Kg7ZPS2A6EACq2XfzW24yGa81MAFUUDznvarbfSI61+0G1CczlDcQLXG3HMB4D2iM1XGgVQ55+Fa18SqFAo5RMq/1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 3:21=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
>
>
> On 2026/7/24 00:39, Yosry Ahmed wrote:
> > On Thu, Jul 23, 2026 at 6:55=E2=80=AFAM Johannes Weiner <hannes@cmpxchg=
.org> wrote:
> >>
> >> On Wed, Jul 22, 2026 at 09:52:18PM -0700, Yosry Ahmed wrote:
> >>> On Wed, Jul 22, 2026 at 7:27=E2=80=AFPM Johannes Weiner <hannes@cmpxc=
hg.org> wrote:
> >>>>
> >>>> On Fri, Jul 17, 2026 at 04:51:51PM +0800, Hao Jia wrote:
> >>>>> @@ -1369,7 +1402,7 @@ static void shrink_worker(struct work_struct =
*w)
> >>>>>                        goto resched;
> >>>>>                }
> >>>>>
> >>>>> -             ret =3D shrink_memcg(memcg);
> >>>>> +             ret =3D shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
> >>>>>                /* drop the extra reference */
> >>>>>                mem_cgroup_put(memcg);
> >>>>>
> >>>>> @@ -1493,7 +1526,7 @@ bool zswap_store(struct folio *folio)
> >>>>>        objcg =3D get_obj_cgroup_from_folio(folio);
> >>>>>        if (objcg && !obj_cgroup_may_zswap(objcg)) {
> >>>>>                memcg =3D get_mem_cgroup_from_objcg(objcg);
> >>>>> -             if (shrink_memcg(memcg)) {
> >>>>> +             if (shrink_memcg(memcg, 1)) {
> >>>>
> >>>> Why 64 for the global limit but only 1 for the cgroup limit? That
> >>>> seems arbitrary in multiple ways.
> >>>
> >>> I suggested that we keep the writeback here without batching and do
> >>> that change separately, mainly out of abundance of caution as
> >>> writeback is done synchronously here so the extra latency could be
> >>> problematic. I think we probably want to measure the performance
> >>> impact of that separately.
> >>>
> >>> That being said, this path is potentially too expensive anyway due to
> >>> the flush, but I would rather we do some basic measurements before
> >>> batching here.
> >>>
> >>> What do you think?
> >>
> >> It's not an unknown, right? We know this works for direct reclaimers,
> >> cgroup limit reclaim e.g., and what the latency implications are.
> >>
> >> Because of how reclaim works, we also know it'll call zswap_store() in
> >> batches of SWAP_CLUSTER_MAX. If we don't batch here, they're likely to
> >> each call shrink_memcg() once we're at the limit - while still risking
> >> rejections due to compressibility differences.
> >>
> >> My worry is that if we start with an inconsistency, we'll be stuck
> >> with it for a long time.
> >>
> >> I'd rather start with the clean, consistent version. Dial it back only
> >> if we have data to justfiy the complication that we can put into a
> >> comment and the changelog that outlines why exactly it's different.
> >
> > I am fine with doing that and basically always using NR_ZSWAP_WB_BATCH
> > as the batch size in shrink_memcg(), but I would be more comfortable
> > if we did some sanity testing.
> >
> > Hao, would you be able to do some smoke testing with NR_ZSWAP_WB_BATCH
> > used for all paths, and memory.zswap.max set in a way that induces
> > writeback? You can probably set memory.zswap.max to 1% of total memory
> > instead of the global pool limit and rerun the same test.
>
> Building on Test Case 2, I set zswap.max=3D320M (~1% of total system
> memory) and updated both invocation paths of shrink_memcg() to process
> batches of 32 or 64. The resulting benchmark data is shown below.
> (Note: Test Case 2 also sets max_pool_percent=3D1.)
>
>                        baseline-cgroup   batch-all-32-cgroup
> batch-all-64-cgroup
> shrink_worker wakeups        7,238             766               367
> shrink_memcg calls      12,059,142       1,961,194           983,878
> written_back                28,277         301,157           327,997
> zswap_store calls         1,349,572       1,168,190         1,114,549
>    store succeeded            492,861         521,315           459,246
>    store rejected             856,712         646,875           655,303
>    store reject rate            ~63%           ~55%              ~58%
> pool_limit_hit              510,130          50,096            57,715
> pswpout                     884,989         948,032           983,300
> pswpin                    1,251,268       1,638,668         1,878,453

The numbers generally look good, the store rejection rate is
decreasing and we are naturally doing more writeback which makes
sense. The store rejection rate actually increases when the batch size
increases to 64, maybe aggressive writeback is more likely to fail and
cause a store rejection, so that also makes sense.

The only part I can't immediately reason about is pswpin. How are we
reading from physical swap more than we ever wrote to it?

Also why does it significantly increase with batching? I would hope
that it actually decreases (like the commit message), because colder
pages end up on disk. But even if we eventually swapin everything on
disk, I would only expect a slight increase to match the slight
increase in pswpout.

