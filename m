Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB09BCD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 23:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4F666B0005; Thu,  4 Jun 2026 19:52:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D00296B0088; Thu,  4 Jun 2026 19:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEEF86B008A; Thu,  4 Jun 2026 19:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACF4C6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:52:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E85F1203BB
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:52:48 +0000 (UTC)
X-FDA: 84843882816.05.72C0A80
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2E29EA0011
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:52:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h751sbA8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780617166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9qJVUjgRvfBeIKnlJo5ncmrdnqgqaZI84EFOu3Ayy7g=;
	b=t9ALRE89vCKxXFyT+15cZd/SkmhQJCvtZ2e3qc9puVgMxtQwcnZMu7YpEVy+UI6UzB67y1
	Ttmw6fqKupgNvOGXUnuhfbueEk6lmCMmGnILP0bpklG3ahQCFE9o1MXqEGkRNliFiPkArU
	fVBQuoOoyTAQZD6esH1ekZgWqY7fKMg=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h751sbA8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780617166;
	b=C6SBghee+lvFeik5N3gPSBor0Yxcb/2LmN66cDTav8ShYRjphjy7mb3O0CXO8hJTV8MXQ6
	LcTkSDrzC5v7sihhvZX7ka90DrlKWFZh559Cpvmk0f0/nFj+q3Gv7tjuFkR/Px+bJufQql
	XZIqzToLQG7HRozhHvAd8R+4UK01KFk=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5177d1ff061so128181cf.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 16:52:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780617165; cv=none;
        d=google.com; s=arc-20240605;
        b=Y7TWA/ulZQ0d0092odTXrBIpByLWMz5SphCOTIvNcD6VhJhpy6CAhxOXAtJFCeGySg
         RvDDnErJnmVPGEpyjB0w6JyTEsb/f4oZM1oHEPYK64WPZPkhBnFtpGMZ7jOUO08vC0mm
         d7D2MPmJwYodhD6NkzFeoTRfNB+XElb9wEN3+R6XTR310L+/naGayoRE72qnqtXIbl9h
         D+paUC+b0KvTldE5nIqIJn3vep7XPMSjG8fkI0xCK6ebOTYJGwIp5DLfkKiFisL6zI+m
         Ra6+od2xNavgUgVJ2umra4+tivyUIbdD7ZzUNPXNSVIuMdOx3iQ0mAvVO4n2vNHfHGst
         rtQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9qJVUjgRvfBeIKnlJo5ncmrdnqgqaZI84EFOu3Ayy7g=;
        fh=jjBLgXU1rkOQkjF8HqlimySj0H280s+QOJbDCfXjBIQ=;
        b=gGiGjBNv3kXjMgOV8vpFXGwEQRmzlST8s8dckcLlTzV/w6MQ3wwAoTAuVQYJTVum6r
         xYc2h03DcpESeGSxc6tHlKcEUYIgERIl9txA33U/hByRilfSsKbnuYW5L7gZh4OhP1TN
         bH+5aRKkmN8s4XJRwrl7MfR0TMszQwJr7dyDBKuaEi6nXjr4+/2dyMoZqv3PhETmdi6C
         PeTh9FYEoQ8meIKVGsCnYngw81VHnTfkODhqipKhmMJuSymjZvfFyX2vYUgt3avbhmDs
         9Wcbq8QxjPOnQ+DqVdV2Rr68+J67pPBz11q/tuZ90q/9KlpU7QeuyBTU1jay/DSt1whB
         UJeQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780617165; x=1781221965; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9qJVUjgRvfBeIKnlJo5ncmrdnqgqaZI84EFOu3Ayy7g=;
        b=h751sbA8x5G/Hp+eu7/HM5+KPfXHrTnszi+fantSIQw0zOfotOTTt03T/vd0JX+Cg5
         M4/H3gZRV6mRi5YfqsbFHbZFgdvO9ojIBbeIsP11VPQA3ppw2rkbk3wAmdu9+t2p1Tqm
         o7IA/UMOA9gQX/BiTciYmUS0p+I1PoEckf16DbEXn3jC9wyOdDsjqHDpD8b7XMptqC3E
         OFNzCHs2b2hTX34V12TBKCLpjAhLEu9ZVhiPIMg4RJgVN6ucYbhQAHxmzF9QqV8jMALq
         +qzXpeClLYkqzofC0SRJOKRvJPk99wALedcgwX7MpK5Udx37Y+TOt/cEDWFJ3JZh7eSN
         +dlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780617165; x=1781221965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9qJVUjgRvfBeIKnlJo5ncmrdnqgqaZI84EFOu3Ayy7g=;
        b=cxhK7o/Ptgi1H7Twcd0X7yIkpzzXvPXll3FM//YnQqunIomfY+l6Ju6FUo/w+NpjeS
         MZdcec0uGXLg1xfdQfpvky59//tFQvF55qQTfjtBl4vVUyDOVA3Of2jS/niREm1mJjcd
         LQXcIQK4nqfbUaLP7EitIr0/ZCRGSDxJ53ei7fE/bGcNPvN5oz/LrZCWhTaprSC5hhNk
         7J5Gyt9WsLuhDAMR4Rlc7a6u4AAWE1+Nwyl3dYaHvAipgAvaSodf6reDeHF+RWrhVyz/
         maT6MQnwPvc9JkX/jKR9oZJFImRDMG9TAtbnZDqz3i4vInCzgB7zp/ajzjyAzE6bDI5K
         qwEg==
X-Forwarded-Encrypted: i=1; AFNElJ/U8PSHlu+Lh9LMMFQqx3mlWdAn1rrvis7aKxzRyNA1OQreDBHWc0lj3lbQsbORs5okEvhxCRvgCg==@kvack.org
X-Gm-Message-State: AOJu0YzCeGSs13y4aXt/cw62n0+s2zb0P+vdlYIJlZYwVdlwpEo2qLlL
	+i2+tnBdys90AAgebqtxh6LZjva+o+tEgob+bXea4xAe6hz5O8NplvnhnTtzJPJSGpSfNfY2WSk
	bNUbeWnC/p+aL4raESChWEuNnISZWzY9epCYcpy1n
X-Gm-Gg: Acq92OFFl6XOzkqVML+8/td7eaEMMwxfpA/VqqAALvy3YU5KvGPQWvCSbMJ6hlgSwTD
	C3NePK9T8ZSD13EWYojUJ1aAJm2f0lBtIwXhE3EQOhSk/suspYAYiC1jUxytlrolE1rh2FisKTx
	74dEr37y8bRlEIUIJkNlEuCVzV7Uuy6F2oTRKz3GEW+csacnKI56iE1U6o4MwzcKYPSg5VYQ56J
	lTo0+qMIGCuDFWlrIJ0lJcqqi4NInPYtPW80Ys13t7HuSZ0UypeE2nD8/B3sbEcq+w9Q1s/w+tC
	JYYcGfNjvoXpW09V
X-Received: by 2002:a05:622a:900a:b0:516:4f62:85ea with SMTP id
 d75a77b69052e-517984d8be7mr897491cf.21.1780617164336; Thu, 04 Jun 2026
 16:52:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260506022256.32664-1-hao.ge@linux.dev> <20260508171251.9bfb5e833859090d4480e222@linux-foundation.org>
 <20260526190015.d4edd406962fcc3a1ee4cb53@linux-foundation.org>
 <0e835109-9068-464f-88e2-c1847cd34c71@linux.dev> <CAJuCfpGjPFbd+Fw52_cz-HSQZndUDDiGTXH38y8U-6sZF4=YwA@mail.gmail.com>
 <edb60c5c-5d94-4d85-860e-8c0d4537fcb3@linux.dev>
In-Reply-To: <edb60c5c-5d94-4d85-860e-8c0d4537fcb3@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 4 Jun 2026 16:52:32 -0700
X-Gm-Features: AVVi8CfiDxsr9NDLNh0OqCMX2AsKHAD1fybPu2nOdA9CvIkGyhMZuKmWDIrdpdY
Message-ID: <CAJuCfpGaeDbFohH263Lmcd471h145C8PttfaGCC1BkRo3Ja28Q@mail.gmail.com>
Subject: Re: [PATCH v5] mm/alloc_tag: replace fixed-size early PFN array with
 dynamic linked list
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kent Overstreet <kent.overstreet@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2E29EA0011
X-Stat-Signature: jbkkb67k4rfdyc1n85guuxwxy1rr4a5o
X-Rspam-User: 
X-HE-Tag: 1780617166-981955
X-HE-Meta: U2FsdGVkX1+o3zW8M8U1MrTnsHMtWxag1twjOovlDJmQW56rrXKBU2VzsJsiEwGYNaTgjvEctb32uxTMiMJFXuS/zmb9ibmziQGW86yv2oRZ4Mbi0ZN9pDza/saMVFW4n8NC8Utw25SnZLf9c+OIscYf9XP9VXBqUY/K71uGuAxvP/QoH8uYUp/h4Ce5rdLMe+lTI1U+0qXEr8j/ru3t0bJJdeifb4839olw438Zf/T3ZGCGx7SWYnwDVNnLdV77yPjHRnDuqdG0FKdgHxkEdifyAeG3DflF9Afy519uZ7QjJoAyREcfQfkddZAW5SnEvPglBtnEE5jebx3iIY+e81DGnIPXoWIakBMXOR86Vqr1EsuBVs1mSC2j9AL1SRnrNNE5v8fCF60eOVxd8lnApBV3H8mmJD7vxLRD4zh/VNt/2+GejmPhh0LoX9NERDbj6imySmBNW6lqSqHffNAngSBZtHFZqz2ExgK2MJbS2xHSVHUkxtMZHcJj+aj/EbivfLX+NMU17T7WJK93F7wcpePo+10SO5DmVkYS6+C4AUqoaLDdiRJlSCeuHyzPSlrl7f/y0/R/A5fEyFHHO0+v1+aC90I9rw2+BCiIC5eaDkRweIbYIjssgyyfJhe3niMDl+Iggv59nJYsYBjCM2J9EIULgDCakjSQSqQKPyWx6ef+OiKRs4ORDpr1A45yIktOcjC7znrLjz09ZdxLwvmyI1WCTyyjGpZ4EwH/kK71Zt3uVeIr3pyC7bgVs9tqo092wppmKOiTU6ms+fpi3JEdwiQSXtTMAAfspSHustOsGqtXbOMoxY+j0WHtos9y5gz1vFBkapTw5XiexXZUyGV9OUTzPb7EO5o7Z9yRFrbuJHD6TfOAZSOu8W6owMu47bKWIOeLi9/QLS+zRM/UI+ykfDusDqCL5E9tWpjUqLw7iR1iMOJ3BcYp+J+bY4rX5BC9HSKkOfFi0ctJP2CeR4K
 +SgrGNmy
 HT00vHV8x4aggu3625Qao2CJ1astxskybXTvpgFHOrUmsZhu50fpr5Ix4sJJ2h57YeDNikLb6SUkFY0K4mzc9Xh26jxqGag1W1bpKZTml19lSL32EBvfLCqw65duKTcP9y65DC95uwt+rjwiDqsq2Ke+diDkGhOyBitPf/pbGlGyX9jnl8zvsXz9xBLPPbIzCqJP6BIcJiWEuBGsIhvW/23SLZCdNFDitE9TT8OWLrR3RVGiqX0f88nAtqzYxrMVeAwHNSj42cv3R4obyGb2MW12nuvAB3CSPcV0/gq+UdaK0EHdkzYB5RJYC9ZtxLAoq6MBiR7wIRvdBo5gmajHoLAkShwmGUa+mDAIzdRRa8bHkZKkABegRj3rdZp2bJSe9c+A41nzTboUU65xbVg90Y7vfh/og8O7BiBWJQYEoxp7EKS0H7njQvX49OQzZnsgahVI32UKLtNt3gxcAldpGRJ6zsJjlkdsr76F4dMKCnecWk8hrF16S8lysOrOOqNOskecvLy+dPN4LiGsZPHulH7uuZS/YDAh8WOoxlITrtsCbsKY3Gw784CLWWtTpGW0crmX4ohZBHk6sQO5Rq9K3ssURNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 7:47=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
>
> On 2026/6/4 00:54, Suren Baghdasaryan wrote:
> > On Tue, May 26, 2026 at 10:22=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrot=
e:
> >>
> >> On 2026/5/27 10:00, Andrew Morton wrote:
> >>> On Fri, 8 May 2026 17:12:51 -0700 Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
> >>>
> >>>> On Wed,  6 May 2026 10:22:56 +0800 Hao Ge <hao.ge@linux.dev> wrote:
> >>>>
> >>>>> Pages allocated before page_ext is available have their codetag lef=
t
> >>>>> uninitialized. Track these early PFNs and clear their codetag in
> >>>>> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
> >>>>> warnings when they are freed later.
> >>>>>
> >>>>> Currently a fixed-size array of 8192 entries is used, with a warnin=
g if
> >>>>> the limit is exceeded. However, the number of early allocations dep=
ends
> >>>>> on the number of CPUs and can be larger than 8192.
> >>>>>
> >>>>> Replace the fixed-size array with a dynamically allocated linked li=
st
> >>>>> of pfn_pool structs. Each node is allocated via alloc_page() and ma=
pped
> >>>>> to a pfn_pool containing a next pointer, an atomic slot counter, an=
d a
> >>>>> PFN array that fills the remainder of the page.
> >>>>>
> >>>>> The tracking pages themselves are allocated via alloc_page(), which
> >>>>> would trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and
> >>>>> recurse indefinitely. Introduce __GFP_NO_CODETAG (reuses the
> >>>>> %__GFP_NO_OBJ_EXT bit) and pass gfp_flags through pgalloc_tag_add()
> >>>>> so that the early path can skip recording allocations that carry th=
is
> >>>>> flag.
> >>>> AI review asked a couple of things.  I have a feeling we saw at leas=
t
> >>>> one of these, so probably already dealt with.
> >>>>       https://sashiko.dev/#/patchset/20260506022256.32664-1-hao.ge@l=
inux.dev
> >> Hi Andrew
> >>
> >> My apologies. I'm also waiting for Suren's review. He may have been ti=
ed
> >> up lately
> >>
> >> and might not have time to get to this.
> >>
> >>
> >> Sashiko raised two issues this time. I've already responded to the fir=
st
> >> one.
> >>
> >> See the link below:
> >>
> >> https://lore.kernel.org/all/0b9969e2-b208-46c2-a9a5-bf620239275a@linux=
.dev/
> >>
> >> If I haven't missed any details, it should be a false positive.
> > That seems to be the case. I wonder why Sashiko did not consider
> > that... CC'ing Roman to see if Sashiko can be improved (unless we both
> > are missing something).
> >
> >>
> >> As for the second point, let me address it.
> >>
> >> The early PFN tracking window is entirely within mm_core_init(),
> >>
> >> which is called from start_kernel():
> >>
> >> start_kernel()
> >>
> >>       mm_core_init()
> >>
> >>           memblock_free_all();
> >>
> >>           mem_init() //start early PFN tracking
> >>
> >>           kmem_cache_init()                           // SLUB bootstra=
p +
> >> kmalloc caches
> >> ...
> >>           page_ext_init()                                   // clears
> >> alloc_tag_add_early_pfn_ptr
> >>
> >>       ...
> >>
> >>       rest_init() //spawns kernel_init thread
> >>
> >>
> >> kernel_init() =E2=86=92 kernel_init_freeable()            // separate =
thread, later
> >>
> >>       smp_init()                                    // secondary CPUs
> >> come online here
> >>
> >> Within the early PFN window (mem_init() to page_ext_init()):
> >>
> >>    1. We are still in start_kernel(), single CPU. The buddy allocator
> >>
> >> was just initialized from memblock and should have plenty of free
> >>
> >> pages, so alloc_page() would likely be satisfied from the fast
> >>
> >> path. If so, the __GFP_NOFAIL without __GFP_DIRECT_RECLAIM
> >>
> >> check in the slowpath would not be reached.
> >>
> >> 2. Since only the boot CPU is running, alloc_page() targets the
> >>
> >> boot node, which has memory. So even if __GFP_THISNODE were
> >>
> >> inherited, it would not fail on the boot node during this window.
> >>
> >>
> >> So Sashiko's analysis applies to the general case, and indeed the issu=
es
> >>
> >> he raised could occur there.
> >>
> >> However, in the early boot scenario, I believe the current patch is sa=
fe,
> >>
> >> even though it is not fully generic (after all, no one can predict
> >> future use cases).
> >>
> >> Therefore, I agree with his suggestion that using a clean mask like
> >> GFP_NOWAIT | __GFP_NOWARN.
>
> Hi Suren
>
> I've been thinking about the GFP flags issue for the past few days.
> There are actually a couple of issues
>
> with the suggestion of using GFP_NOWAIT | __GFP_NOWARN.
>
> First, GFP_NOWAIT already includes __GFP_NOWARN, so it's redundant.
>
> Second, GFP_NOWAIT also includes __GFP_KSWAPD_RECLAIM, which is exactly
> the same issue he flagged
>
> previously with GFP_ATOMIC =E2=80=94 it can still trigger wakeup_kswapd()=
 and
> acquire scheduler locks, leading to
>
> potential deadlock in the same scenario he described.
>
> So I think __GFP_HIGH | __GFP_NO_CODETAG is the right choice.

Make sense. TBH if we are failing to allocate a 0-order page during
the early init stage then something is seriously wrong with the
system.

>
> Since this runs under rcu_read_lock(), we can't have __GFP_DIRECT_RECLAIM=
.
>
> And since Sashiko pointed out the scheduler lock concern with
> __GFP_KSWAPD_RECLAIM,
>
> we can't have that either.
>
> I have posted the v6 revision, would you please kindly review it at your
> convenience?
>
> https://lore.kernel.org/all/20260604024008.46592-1-hao.ge@linux.dev/
>
> Thanks
>
> Best Regards
>
> Hao
>
> > This sounds good to me. With that change feel free to add:
> >
> > Acked-by: Suren Baghdasaryan <surenb@google.com>
> >
> >>
> >> In any case, I will wait for your and Suren's feedback. You may have
> >> different opinions on this matter.
> >>
> >>
> >> Thanks
> >>
> >> Best Regards
> >>
> >> Hao
> >>
> >>
> >>> Please?
> >>>
> >>> Also, this patch has no evidence of human review.
> >>>
> >>>
> >>> From: Hao Ge <hao.ge@linux.dev>
> >>> Subject: mm/alloc_tag: replace fixed-size early PFN array with dynami=
c linked list
> >>> Date: Wed, 6 May 2026 10:22:56 +0800
> >>>
> >>> Pages allocated before page_ext is available have their codetag left
> >>> uninitialized.  Track these early PFNs and clear their codetag in
> >>> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set" war=
nings
> >>> when they are freed later.
> >>>
> >>> Currently a fixed-size array of 8192 entries is used, with a warning =
if
> >>> the limit is exceeded.  However, the number of early allocations depe=
nds
> >>> on the number of CPUs and can be larger than 8192.
> >>>
> >>> Replace the fixed-size array with a dynamically allocated linked list=
 of
> >>> pfn_pool structs.  Each node is allocated via alloc_page() and mapped=
 to a
> >>> pfn_pool containing a next pointer, an atomic slot counter, and a PFN
> >>> array that fills the remainder of the page.
> >>>
> >>> The tracking pages themselves are allocated via alloc_page(), which w=
ould
> >>> trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and recurse
> >>> indefinitely.  Introduce __GFP_NO_CODETAG (reuses the %__GFP_NO_OBJ_E=
XT
> >>> bit) and pass gfp_flags through pgalloc_tag_add() so that the early p=
ath
> >>> can skip recording allocations that carry this flag.
> >>>
> >>> Link: https://lore.kernel.org/20260506022256.32664-1-hao.ge@linux.dev
> >>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> >>> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> >>> Cc: Brendan Jackman <jackmanb@google.com>
> >>> Cc: Johannes Weiner <hannes@cmpxchg.org>
> >>> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> >>> Cc: Michal Hocko <mhocko@suse.com>
> >>> Cc: Vlastimil Babka <vbabka@kernel.org>
> >>> Cc: Zi Yan <ziy@nvidia.com>
> >>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >>> ---
> >>>
> >>>    include/linux/alloc_tag.h |    4
> >>>    lib/alloc_tag.c           |  145 +++++++++++++++++++++++----------=
---
> >>>    mm/page_alloc.c           |   12 +-
> >>>    3 files changed, 102 insertions(+), 59 deletions(-)
> >>>
> >>> --- a/include/linux/alloc_tag.h~mm-alloc_tag-replace-fixed-size-early=
-pfn-array-with-dynamic-linked-list
> >>> +++ a/include/linux/alloc_tag.h
> >>> @@ -163,11 +163,11 @@ static inline void alloc_tag_sub_check(u
> >>>    {
> >>>        WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
> >>>    }
> >>> -void alloc_tag_add_early_pfn(unsigned long pfn);
> >>> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags);
> >>>    #else
> >>>    static inline void alloc_tag_add_check(union codetag_ref *ref, str=
uct alloc_tag *tag) {}
> >>>    static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
> >>> -static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
> >>> +static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t =
gfp_flags) {}
> >>>    #endif
> >>>
> >>>    /* Caller should verify both ref and tag to be valid */
> >>> --- a/lib/alloc_tag.c~mm-alloc_tag-replace-fixed-size-early-pfn-array=
-with-dynamic-linked-list
> >>> +++ a/lib/alloc_tag.c
> >>> @@ -767,60 +767,95 @@ static __init bool need_page_alloc_taggi
> >>>     * their codetag uninitialized. Track these early PFNs so we can c=
lear
> >>>     * their codetag refs later to avoid warnings when they are freed.
> >>>     *
> >>> - * Early allocations include:
> >>> - *   - Base allocations independent of CPU count
> >>> - *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_i=
nit,
> >>> - *     such as trace ring buffers, scheduler per-cpu data)
> >>> - *
> >>> - * For simplicity, we fix the size to 8192.
> >>> - * If insufficient, a warning will be triggered to alert the user.
> >>> + * Each page is cast to a pfn_pool: the first few bytes hold metadat=
a
> >>> + * (next pointer and slot count), the remainder stores PFNs.
> >>> + */
> >>> +struct pfn_pool {
> >>> +     struct pfn_pool *next;
> >>> +     atomic_t count;
> >>> +     unsigned long pfns[];
> >>> +};
> >>> +
> >>> +#define PFN_POOL_SIZE                        ((PAGE_SIZE - offsetof(=
struct pfn_pool, pfns)) / \
> >>> +                                      sizeof(unsigned long))
> >>> +
> >>> +/*
> >>> + * Skip early PFN recording for a page allocation.  Reuses the
> >>> + * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to av=
oid
> >>> + * recursion when allocating pages for the early PFN tracking list
> >>> + * itself.
> >>>     *
> >>> - * TODO: Replace fixed-size array with dynamic allocation using
> >>> - * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
> >>> + * Codetags of the pages allocated with __GFP_NO_CODETAG should be
> >>> + * cleared (via clear_page_tag_ref()) before freeing the pages to pr=
event
> >>> + * alloc_tag_sub_check() from triggering a warning.
> >>>     */
> >>> -#define EARLY_ALLOC_PFN_MAX          8192
> >>> +#define __GFP_NO_CODETAG             __GFP_NO_OBJ_EXT
> >>>
> >>> -static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
> >>> -static atomic_t early_pfn_count __initdata =3D ATOMIC_INIT(0);
> >>> +static struct pfn_pool *current_pfn_pool __initdata;
> >>>
> >>> -static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
> >>> +static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_=
t gfp_flags)
> >>>    {
> >>> -     int old_idx, new_idx;
> >>> +     struct pfn_pool *pool;
> >>> +     int idx;
> >>>
> >>>        do {
> >>> -             old_idx =3D atomic_read(&early_pfn_count);
> >>> -             if (old_idx >=3D EARLY_ALLOC_PFN_MAX) {
> >>> -                     pr_warn_once("Early page allocations before pag=
e_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
> >>> -                                   EARLY_ALLOC_PFN_MAX);
> >>> -                     return;
> >>> +             pool =3D READ_ONCE(current_pfn_pool);
> >>> +             if (!pool || atomic_read(&pool->count) >=3D PFN_POOL_SI=
ZE) {
> >>> +                     gfp_t gfp =3D gfp_flags & ~(__GFP_DIRECT_RECLAI=
M | GFP_ZONEMASK);
> >>> +                     struct page *new_page =3D alloc_page(gfp | __GF=
P_NO_CODETAG);
> >>> +                     struct pfn_pool *new;
> >>> +
> >>> +                     if (!new_page) {
> >>> +                             pr_warn_once("early PFN tracking page a=
llocation failed\n");
> >>> +                             return;
> >>> +                     }
> >>> +                     new =3D page_address(new_page);
> >>> +                     new->next =3D pool;
> >>> +                     atomic_set(&new->count, 0);
> >>> +                     if (cmpxchg(&current_pfn_pool, pool, new) !=3D =
pool) {
> >>> +                             clear_page_tag_ref(new_page);
> >>> +                             __free_page(new_page);
> >>> +                             continue;
> >>> +                     }
> >>> +                     pool =3D new;
> >>>                }
> >>> -             new_idx =3D old_idx + 1;
> >>> -     } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_id=
x));
> >>> +             idx =3D atomic_read(&pool->count);
> >>> +             if (idx >=3D PFN_POOL_SIZE)
> >>> +                     continue;
> >>> +             if (atomic_cmpxchg(&pool->count, idx, idx + 1) =3D=3D i=
dx)
> >>> +                     break;
> >>> +     } while (1);
> >>>
> >>> -     early_pfns[old_idx] =3D pfn;
> >>> +     pool->pfns[idx] =3D pfn;
> >>>    }
> >>>
> >>> -typedef void alloc_tag_add_func(unsigned long pfn);
> >>> +typedef void alloc_tag_add_func(unsigned long pfn, gfp_t gfp_flags);
> >>>    static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __ref=
data =3D
> >>>        RCU_INITIALIZER(__alloc_tag_add_early_pfn);
> >>>
> >>> -void alloc_tag_add_early_pfn(unsigned long pfn)
> >>> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
> >>>    {
> >>>        alloc_tag_add_func *alloc_tag_add;
> >>>
> >>>        if (static_key_enabled(&mem_profiling_compressed))
> >>>                return;
> >>>
> >>> +     /* Skip allocations for the tracking list itself to avoid recur=
sion. */
> >>> +     if (gfp_flags & __GFP_NO_CODETAG)
> >>> +             return;
> >>> +
> >>>        rcu_read_lock();
> >>>        alloc_tag_add =3D rcu_dereference(alloc_tag_add_early_pfn_ptr)=
;
> >>>        if (alloc_tag_add)
> >>> -             alloc_tag_add(pfn);
> >>> +             alloc_tag_add(pfn, gfp_flags);
> >>>        rcu_read_unlock();
> >>>    }
> >>>
> >>>    static void __init clear_early_alloc_pfn_tag_refs(void)
> >>>    {
> >>> -     unsigned int i;
> >>> +     struct pfn_pool *pool, *next;
> >>> +     struct page *page;
> >>> +     int i;
> >>>
> >>>        if (static_key_enabled(&mem_profiling_compressed))
> >>>                return;
> >>> @@ -829,37 +864,45 @@ static void __init clear_early_alloc_pfn
> >>>        /* Make sure we are not racing with __alloc_tag_add_early_pfn(=
) */
> >>>        synchronize_rcu();
> >>>
> >>> -     for (i =3D 0; i < atomic_read(&early_pfn_count); i++) {
> >>> -             unsigned long pfn =3D early_pfns[i];
> >>> +     for (pool =3D current_pfn_pool; pool; pool =3D next) {
> >>> +             int nr_pfns =3D atomic_read(&pool->count);
> >>> +
> >>> +             for (i =3D 0; i < nr_pfns; i++) {
> >>> +                     unsigned long pfn =3D pool->pfns[i];
> >>>
> >>> -             if (pfn_valid(pfn)) {
> >>> -                     struct page *page =3D pfn_to_page(pfn);
> >>> -                     union pgtag_ref_handle handle;
> >>> -                     union codetag_ref ref;
> >>> -
> >>> -                     if (get_page_tag_ref(page, &ref, &handle)) {
> >>> -                             /*
> >>> -                              * An early-allocated page could be fre=
ed and reallocated
> >>> -                              * after its page_ext is initialized bu=
t before we clear it.
> >>> -                              * In that case, it already has a valid=
 tag set.
> >>> -                              * We should not overwrite that valid t=
ag with CODETAG_EMPTY.
> >>> -                              *
> >>> -                              * Note: there is still a small race wi=
ndow between checking
> >>> -                              * ref.ct and calling set_codetag_empty=
(). We accept this
> >>> -                              * race as it's unlikely and the extra =
complexity of atomic
> >>> -                              * cmpxchg is not worth it for this deb=
ug-only code path.
> >>> -                              */
> >>> -                             if (ref.ct) {
> >>> +                     if (pfn_valid(pfn)) {
> >>> +                             union pgtag_ref_handle handle;
> >>> +                             union codetag_ref ref;
> >>> +
> >>> +                             if (get_page_tag_ref(pfn_to_page(pfn), =
&ref, &handle)) {
> >>> +                                     /*
> >>> +                                      * An early-allocated page coul=
d be freed and reallocated
> >>> +                                      * after its page_ext is initia=
lized but before we clear it.
> >>> +                                      * In that case, it already has=
 a valid tag set.
> >>> +                                      * We should not overwrite that=
 valid tag
> >>> +                                      * with CODETAG_EMPTY.
> >>> +                                      *
> >>> +                                      * Note: there is still a small=
 race window between checking
> >>> +                                      * ref.ct and calling set_codet=
ag_empty(). We accept this
> >>> +                                      * race as it's unlikely and th=
e extra complexity of atomic
> >>> +                                      * cmpxchg is not worth it for =
this debug-only code path.
> >>> +                                      */
> >>> +                                     if (ref.ct) {
> >>> +                                             put_page_tag_ref(handle=
);
> >>> +                                             continue;
> >>> +                                     }
> >>> +
> >>> +                                     set_codetag_empty(&ref);
> >>> +                                     update_page_tag_ref(handle, &re=
f);
> >>>                                        put_page_tag_ref(handle);
> >>> -                                     continue;
> >>>                                }
> >>> -
> >>> -                             set_codetag_empty(&ref);
> >>> -                             update_page_tag_ref(handle, &ref);
> >>> -                             put_page_tag_ref(handle);
> >>>                        }
> >>>                }
> >>>
> >>> +             next =3D pool->next;
> >>> +             page =3D virt_to_page(pool);
> >>> +             clear_page_tag_ref(page);
> >>> +             __free_page(page);
> >>>        }
> >>>    }
> >>>    #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
> >>> --- a/mm/page_alloc.c~mm-alloc_tag-replace-fixed-size-early-pfn-array=
-with-dynamic-linked-list
> >>> +++ a/mm/page_alloc.c
> >>> @@ -1255,7 +1255,7 @@ void __clear_page_tag_ref(struct page *p
> >>>    /* Should be called only if mem_alloc_profiling_enabled() */
> >>>    static noinline
> >>>    void __pgalloc_tag_add(struct page *page, struct task_struct *task=
,
> >>> -                    unsigned int nr)
> >>> +                    unsigned int nr, gfp_t gfp_flags)
> >>>    {
> >>>        union pgtag_ref_handle handle;
> >>>        union codetag_ref ref;
> >>> @@ -1269,17 +1269,17 @@ void __pgalloc_tag_add(struct page *page
> >>>                 * page_ext is not available yet, record the pfn so we=
 can
> >>>                 * clear the tag ref later when page_ext is initialize=
d.
> >>>                 */
> >>> -             alloc_tag_add_early_pfn(page_to_pfn(page));
> >>> +             alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);
> >>>                if (task->alloc_tag)
> >>>                        alloc_tag_set_inaccurate(task->alloc_tag);
> >>>        }
> >>>    }
> >>>
> >>>    static inline void pgalloc_tag_add(struct page *page, struct task_=
struct *task,
> >>> -                                unsigned int nr)
> >>> +                                unsigned int nr, gfp_t gfp_flags)
> >>>    {
> >>>        if (mem_alloc_profiling_enabled())
> >>> -             __pgalloc_tag_add(page, task, nr);
> >>> +             __pgalloc_tag_add(page, task, nr, gfp_flags);
> >>>    }
> >>>
> >>>    /* Should be called only if mem_alloc_profiling_enabled() */
> >>> @@ -1312,7 +1312,7 @@ static inline void pgalloc_tag_sub_pages
> >>>    #else /* CONFIG_MEM_ALLOC_PROFILING */
> >>>
> >>>    static inline void pgalloc_tag_add(struct page *page, struct task_=
struct *task,
> >>> -                                unsigned int nr) {}
> >>> +                                unsigned int nr, gfp_t gfp_flags) {}
> >>>    static inline void pgalloc_tag_sub(struct page *page, unsigned int=
 nr) {}
> >>>    static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, un=
signed int nr) {}
> >>>
> >>> @@ -1867,7 +1867,7 @@ inline void post_alloc_hook(struct page
> >>>
> >>>        set_page_owner(page, order, gfp_flags);
> >>>        page_table_check_alloc(page, order);
> >>> -     pgalloc_tag_add(page, current, 1 << order);
> >>> +     pgalloc_tag_add(page, current, 1 << order, gfp_flags);
> >>>    }
> >>>
> >>>    static void prep_new_page(struct page *page, unsigned int order, g=
fp_t gfp_flags,
> >>> _
> >>>

