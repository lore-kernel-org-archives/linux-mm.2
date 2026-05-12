Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59511CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 15:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B460C6B00A6; Tue, 12 May 2026 11:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1DAB6B00AC; Tue, 12 May 2026 11:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33F36B00AD; Tue, 12 May 2026 11:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 915706B00A6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:48:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 560674052A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:48:03 +0000 (UTC)
X-FDA: 84759198846.05.CFD8E6F
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4572C100002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:48:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SBd2o1qX;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778600881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HvUvOiFnKHM0REYpmaWk5d+F2+5GIifwAyYSC+4XUic=;
	b=o72herNrZ5OGAuk36zt3nQOuD5V/pkD2OVrQOqt6Tad1m0GiR4sbGRoA70TPPg1T1hpCKr
	F/5YYiLbzZbLlwVfmsczkvmyvGoTuTYVFmegeQS1BY1Ob8mtvtDInQcCkvmebHhr++4ipB
	ZJZUfHpJoLH09LHFNADLzEgFwbPKQO4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SBd2o1qX;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778600881; a=rsa-sha256;
	cv=pass;
	b=XLE3XtD4xvG8c3rfHCMY9UyFdAD5kFiD2M7wAktDs9MVHxaj2KGxlW6p5QIi/HOPTJ+JbG
	MVEH3+X13EUrhXrGVS17gKKtGVt3lARy8EuFe8s68H9vYLXdU/DlCcZS/I8UU4PpzFOOAJ
	Vsc248qAA1CzJyPyxex0jmVREMtTGX0=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso53142115e9.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 08:48:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778600880; cv=none;
        d=google.com; s=arc-20240605;
        b=ICsrzoQ0kjOfpDmDk4eUQq01ESnbbLqQuv78z22QhvYPX40ROSCBYMSPMiWjuseUVc
         l59PhyA2HjKLZFqoGnmdr/T1aGlTXs7cnE4AryahRkvOzo2+OINZ8ymQ6CLM82a8Y4iy
         7TRP6Vd/P4XjfuDmT5+Z6CJFEfdW/+6zz0CIjDp0qzX3ala2D7wQGEQd+Z1v0a3wtjHc
         z7fsqFZrjbw4+PM/xOx1zKgJ7UqWcE+fF42NtYuUe61cU0Vz4i5WKHR8AlXmeMunnOZE
         7m0RktfJSLdEP3yaKvSjXvZ+Ar/3ePDUBRPv5wzsb4uwnSsdLoGRAShzzhYwQJIrCbkf
         XmFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HvUvOiFnKHM0REYpmaWk5d+F2+5GIifwAyYSC+4XUic=;
        fh=f0LSKwbfJyE+xTcfgLSsKksRdr/kveHj3Oz0YtWhIdQ=;
        b=adozB/Sy+PDnV9SH8+B0t54PrI7VGIOKM3kALzNpawDuI+27ZFp4bgDlVkABreQG32
         us2H/GIA3gwNyuSrVY1uwFti9eM9yQZfXxSXrTZOGJC2bFw+k5mtev1wpdSiZKOv2jh1
         4zKv5YrJaSsEiAx8pkDKsGOU3gN+z+RAGNVNjpQ3cDU0Fz+jGoBE1sRzkruqU2R9Y04T
         PMEs5y0l0lJTbE50eG+4irQ9qsmpD6RyB54C2xXPj+e64JVxWqPtTXHXYjslppyTARaV
         Oiw/JBf+W7vZibxhTvt5pB1BId8zRHd3uXfDN0DsAP0AxL/VfHvfVUetHix1zypS+/TF
         Sdyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778600880; x=1779205680; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HvUvOiFnKHM0REYpmaWk5d+F2+5GIifwAyYSC+4XUic=;
        b=SBd2o1qXAT2aRar3V260lFaxCE2yWsYYpNHBiKIigZdd6qjlZgeVgGGdc9WVjIkx09
         8NlK1Bih2uuWTVWNP4yO5T69N/TqvOFHTBfFMESEV35pzIJEQZI/jADI+X28JDyoeY8w
         +zhT+ZU13XBDg0fQFQsrMx8cMl+at2nZ172amtV1xXsA7AZuIPZNN1syuW5UVuzRWow6
         rg1Ha3CnemZUMN0vuyw7zVLtSc8SdVD+a/aXJ3q3gmsOHM5KNLsX5ZDHaeRTmHBupQV3
         SwkL7Ow6VEW6sfMcR5tdXVoVKiZi0SFdIJAmqoPCbmWKrWEXwtczxh/eREzCYQIKwl2/
         4/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778600880; x=1779205680;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HvUvOiFnKHM0REYpmaWk5d+F2+5GIifwAyYSC+4XUic=;
        b=sUPAtt9KlXrKbd8vQufr9Pdb8Cnvo5MxWIlP4bAkUVM/+HnZmFK9EMfWVvRXmllF8X
         mfU/cQ96LB4rSvjdnyU623PoCHNnFXYc39TktHzj/EEWKyd90MIvO/4iBF1d28cfqefm
         vWIc9CjQ5jIvuaReSF7+b2uqG7fRx0LSgLUxW2J2bV6H8rhcm2nNdylfeo4jPiWecmyJ
         DqIFRhd3gMZGsX1brv1d09+ohmz2Kl9Os5h6YI1VkdKxZhQpv8cKR8kzWnCzyU6RDHQJ
         Jzki0qcMO2gG2efIFDEtFwkus43MRSJkXiTA+D8HL97HM8YYXxZa8krKXnPnPxIUbqXV
         QxQw==
X-Forwarded-Encrypted: i=1; AFNElJ+U9gWszbR3+bSjc2xJ93hy407K2eoySuPWF2PvH+7mDTPPzesC8HmCg/WOEu4vmYA6jCUpgj8WUg==@kvack.org
X-Gm-Message-State: AOJu0YyZ+bCqkmDa7UDMiBZ41i+8qZbeqyz65SxhLy6FCHXhUE9nMZD3
	tlrpYyLbaTSTbo3J43wWGlQttI4JOuRC4Xysy5uyU1FNJHszmz41nt1ainoHbMlw2IrQmfn/FYR
	aHLyMSLNYXnGrr1pQ0YNRTLnKqthsKLE=
X-Gm-Gg: Acq92OFtsl03OAzNm7bAOghvZFRUP7W2PX8ilUYxn4abT1/Pn+jo6JfyIsF8a4UOAVC
	+F4yrXYuQ6+TwmqGPB0V/7VotJEVcYKXopN5+oJZ79Sqcgdv5mJBSRRziJbjFuE/lOq8743nQor
	kas9uZEy/E+RpGnqknvUIk0pE8TGuWR2zI1sgsLRFCgvPfmk/f7UlP1bVg0fgHqpcWpqq5fUDrC
	YRpn34xFc/D0aSHLZMFShwRsRVO7hF8DPJK0M61fqZJMHwEg5d86pezjgXkGkXit4LDjEyGaNUu
	Qn7Oh8v6QHJSrPHmCAa/DtACApjN/c8ml5PdzOw=
X-Received: by 2002:a05:600c:3e19:b0:48a:5546:61a1 with SMTP id
 5b1f17b1804b1-48e8fe721afmr50364255e9.15.1778600879485; Tue, 12 May 2026
 08:47:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260511105149.75584-1-jiahao.kernel@gmail.com>
 <20260511105149.75584-3-jiahao.kernel@gmail.com> <CAKEwX=PLFRkfUvZyaYfwBv0QJ-8KAktvZvGA02Hod04H-RsS-Q@mail.gmail.com>
 <CAO9r8zNOPdpJuTmccvQ6ZAVS+tXxp-_ofA765DbnfaUZOPPO-g@mail.gmail.com> <12e4784e-2add-d849-7e54-bde8abfa6e78@gmail.com>
In-Reply-To: <12e4784e-2add-d849-7e54-bde8abfa6e78@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 12 May 2026 08:47:47 -0700
X-Gm-Features: AVHnY4JskTf23tSbnnLn2V95OlEo1bjSAHzhtTqVEIKfyAdTp_H0_7MV48nFSA8
Message-ID: <CAKEwX=MOixJAUGiwUcMQa0Stvg-mR-MvpDRD8WA4YMtRvnUYTg@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/zswap: Implement proactive writeback
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, Alexandre Ghiti <alex@ghiti.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: t9sdzykfpt4a6w9m3f7sqipe3ahm9gaj
X-Rspamd-Queue-Id: 4572C100002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778600881-969172
X-HE-Meta: U2FsdGVkX189umdGQOM8sTjIx9m8pnrNAgGDPyJLlFTVsGRIxknm2ocZg6HMVqSLYMqDM5bqOn0m0EJ+syhZD/YLxRRZ3cTVRb8NgUJ/zUBqIJZuX3UsNZhOMpuWE4J1kavp+mUUIFlwgobJNsgnQJfKJ29qJOpbstyBlaJpZvR/1nLVb15yoOQX9FK2w8lpIdQX3RrdlXNEfCFdpZRd1KlL6+dG2KF9W8PaDU8ybLm2XOEfh/kjVasjrALKrfV0RNkJ+B/WUz8ZXzgpzuLOvndnafuCw4kDQI6wjZ8Fg3KzOF1lIzwFAB1hN4hnOgeHBSBDHedZPKDVyT+YHdvBZqR60Oc9KzLcpq6a+oZlq2zkCvWQKMBDbM6OXNjItppnVOWI2v7WJzUAGTCSJMIA4zwIhCJOoGTorYBI4935zyrJ/ehpX6GHmqzkQCM1x5IJ873atJq5B7TiVu3acdfuNfBZpNkmmZqKCO9NfV9x1wzACew4GAssSY/srytSkI67IFffAWNwRlrIcXUAQFQqlwSk6mJLvBWtD9JEJa3n+rl7k60wRB6XgPxC0Isfa6StF9bpnckhQhLw1AEXoXnWjLJ52O+suX9GvCd+JK3XsgptkO7YT00Y7ZxY/WV9Lu1IFnRxvM2X0XMkJFJfqMRcnlnndlJDYKX8XmLX8IAtMbamRBheE7hFy32Dpoio47jE6P7ldw9RyOlryEkyziin2e4yxVZk3/5zwVJ4vgHghcvdPUxNfoy+BVU7CZC8eucANrC/2jMzEdqvJcT2f2k/BR82uTyuaM6V6gGgsLLfMF/pB1LiN2Ol7WptvxqZrJx9aHVgd3q4DAFmG1qa40oDoqRBzlVemWDoczTtw9l2SR9SFkKiIFO7EG5W0axtU049w+nNh/ffPOA+xp8va1vKY5GFbxo48ilzuQyKWfBsm+zMoG6TtjgCf3CicAtPHLUsLz3TxDv6dqr52K4BILD
 CZbrK0vR
 g0ESQjgE3Yq4i77qtjaEHz3D4RRoWMFWnrg/L8E+T4om3RH/uYpbVyUJ95gB7DGmQLtrLZ/Ta4vQeUglnSVjH13D+2YYb4qZZOLm+Br4Q6UmfIZs1UiFgXpCR0rUBnv1ch+UCFg1hNhoyPgu4m3So30TGmYpKLIswrR1oOOw/7oDfUVhkl1b5mKf75UwHl2QPw4hGq3J5ZCnk5uZj3ufi8ILcc2bSP13UOzOWuMLl2oKwWZ2EkwXGz2sQ3cHFabk8d56zIrSAnnU+NNNC+tPJJm2aFfiscLlTPIkT3pdN2Xr78cSS754DXJ/z5JL8DcQXM2msFxZN3Kwc/IFPVEXeh7GiaN+SW/Ye3FKwOTqN12wU029Pb5Ux3yLEUo8y56sPhD0nFeesxXEj+ecS/cnLvy6L+tDFrmglWRlc9HR2ELU2JkuJ2ncw1s4b/XJZvS62azVamDLwnzmXJb42Wt7h725eSjlu8CVKgLZ7TfBqrNu7KVx1LGA1jmVwhuXERFxCN70hK8YPi2bmDBF/ByltKNL+0rmQNjD7Q9HLQaXreaPeENOsonwSA48/qdyKP2mgTNdlfD2DJ4/9sFOJdjQ7WizOAAFhy/7txt09kIt6fq8rgsKvNPIIsh1ZVg0iyZmtx+5ckH/iPosrnSx8FZLRbarglZOxVE7swzEM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 2:32=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
>
>
> On 2026/5/12 03:57, Yosry Ahmed wrote:
> > On Mon, May 11, 2026 at 12:49=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> =
wrote:
> >>
> >> On Mon, May 11, 2026 at 3:52=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.c=
om> wrote:
> >>>
> >>> From: Hao Jia <jiahao1@lixiang.com>
> >>>
> >>> Zswap currently writes back pages to backing swap devices reactively,
> >>> triggered either by memory pressure via the shrinker or by the pool
> >>> reaching its size limit. This reactive approach offers no precise
> >>> control over when writeback happens, which can disturb latency-sensit=
ive
> >>> workloads, and it cannot direct writeback at a specific memory cgroup=
.
> >>> However, there are scenarios where users might want to proactively
> >>> write back cold pages from zswap to the backing swap device, for
> >>> example, to free up memory for other applications or to prepare for
> >>> upcoming memory-intensive workloads.
> >>>
> >>> Therefore, implement a proactive writeback mechanism for zswap by
> >>> adding a new cgroup interface file memory.zswap.proactive_writeback
> >>> within the memory controller.
> >>
>
> Thanks Nhat, Yosry =E2=80=94 let me address both comments together.
>
> >>
> >> We already have memory.reclaim, no? Would that not work to create
> >> headroom generally for your use case? Is there a reason why we are
> >> treating zswap memory as special here?
> >
>
> Apologies for the lack of detailed explanation in the patch description,
> which led to the confusion.
>
> While we are already utilizing memory.reclaim, it does not fully address
> our requirements.
>
> Our deployment runs a userspace proactive reclaimer that drives
> memory.reclaim based on the system's runtime state (memory/CPU/IO
> pressure, refault rate, ...) and workload-specific
> policy. That first stage compresses cold anon pages into zswap. Entries
> that then remain in zswap past a policy-defined age threshold are
> considered "twice cold", and the reclaimer wants
> to write them back to the backing swap device at a moment of its own
> choosing, to further reclaim the DRAM still held by the compressed data.
>
> This is the "second-level offloading" pattern described in Meta's TMO
> paper [1]. zswap proactive writeback is what this series introduces to
> address that second-level offloading stage.
>
> [1] https://www.pdl.cmu.edu/ftp/NVM/tmo_asplos22.pdf

Yeah that's what we've been trying to work on as well :) We are
working on a couple of improvements to the mechanism side of this path
(cc Alex) - hopefully it will help your use case too!

Anyway, back to my original inquiry: I understand your use case. It's
pretty similar to our goal. What I'm not getting is why is
memory.reclaim (which you already use) not sufficient for zswap ->
disk swap offloading too?

Zswap objects are organized into LRU and exposed to the shrinker
interface. Echo-ing to memory.reclaim should also offload some zswap
entries, correct? Are there still cold zswap entries that escape this,
somehow?

Furthermore, we already have a way to detect the "twice cold" entries
you mentioned: the referenced bit. This is analogous to the way we
treat uncompressed pages.

>
>
> > +1, why do we need to specifically proactively reclaim the compressed m=
emory?
> >
> > Also, if we do need to minimize the compressed memory and force higher
> > writeback rates, we can do so with memory.zswap.max, right?
>
> Here are a few reasons why memory.zswap.max is not enough:
>
> 1. Writing memory.zswap.max itself does not trigger any writeback
> immediately. For a memcg that has reached steady state (on which the
> userspace reclaimer is no longer invoking
> memory.reclaim), after enough time has passed, the reclaimer has no good
> way to trigger proactive writeback for second-level offloading by
> lowering memory.zswap.max, because in steady
> state nothing drives the zswap_store() -> shrink_memcg() path. The
> userspace reclaimer still has no control over when proactive writeback
> happens.
>
> 2. memory.zswap.max currently triggers zswap writeback via zswap_store()
> -> shrink_memcg(), and each over-limit event can write back at most
> NR_NODES entries. If zswap residency is far
> above memory.zswap.max, converging to the target size requires at least
> O(over-limit pages / NR_NODES) zswap_store() events, with no batching =E2=
=80=94
> proactive writeback therefore has
> significant latency.
>
> 3. memory.zswap.max is a stateful interface. If the userspace reclaimer
> crashes for any reason mid-operation, it may leave memory.zswap.max at
> some set value, putting the application in a
>   persistently throttled bad state.
>
> 4. Once the userspace reclaimer has lowered memory.zswap.max, if the
> workload is rapidly expanding and triggers memory reclaim via
> memory.high / kswapd / etc., the actual amount written
> back can exceed what was intended.

One more reason: IIRC, when you set memory.zswap.max to a value other
than 0 max, every zswap store incurs a pretty expensive check
(obj_cgroup_may_zswap), which does a force flush
(__mem_cgroup_flush_stats). That was pretty expensive last time some
of our internal services played with it. So yeah, it's not ideal...

(if you're using this, might wanna profile this as well).

>
> Thanks,
> Hao

