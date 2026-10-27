Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454AD606A327
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=hMCWU+rW
Received: by kanga.kvack.org (Postfix)
	id 4E5266B07FD; Tue, 27 Oct 2026 11:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BDB36B07FF; Tue, 27 Oct 2026 11:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2EB6B0800; Tue, 27 Oct 2026 11:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 113796B07FD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:49:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 988DE1A0A26
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:49:38 +0000 (UTC)
X-FDA: 85368841236.24.2008B08
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id AD4EC40008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:49:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hMCWU+rW;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1KBHB8+qa4NlnLyGzz+b6HJfV/xmDramajBB5F7wR4s=;
	b=5dHUJPAEyPsFl5hs8LGi/JwaxI+XchaB1RvflYbEHnMSeVeyPX349xyiwdynlGo/T0ROAY
	7X2pC4YVIx+yeFsKVjQiwG1drXqTX+RLlujiytPgHewHgRQNWjP3Hf9pRXNHCNErnJvfFV
	lD/inLxFR1aKMvjQ92tvr5kIjy1xyV0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hMCWU+rW;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116176;
	b=PDUm0wBMBx0yI6zlIDuf8gN03caCFS4sLkko9p2VRuTZsE1fezpD1bS7t76yEgSpfq70Ns
	bvx2xkeg8tB5Z2Ro/9HRhMu1C+4ZCazQjdvX5TJEoH6QaLtBsB7WskSfrPFUiLy6e/ZWl6
	xv+pa8HNEF1wpc/RjuB6wzVbUKki+H0=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-53665358476so816691cf.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793116176; x=1793720976; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1KBHB8+qa4NlnLyGzz+b6HJfV/xmDramajBB5F7wR4s=;
        b=hMCWU+rW1HCppOMQY9+XD3lkczQC5TBcl7b7zLKbvWDdCRnhqGRxWoOOa9DqST+EH2
         3cOeQDwjNHtLud4cxdnI58x0u9R6U3ij4XTH5CJ60H1+mOrRN6j74RT6R1h9Uxz0elS5
         beiawBLi/dT4CmrQ2BYvWEEYZDwOO08A5rEK66QwB7l/rPF2GsG8AoVIQyVS+WBM6IQN
         CvXGDgXqjY8bxdOX27rA5S7Rk+aGtG6HVS6rasBBkkWur0/L+XrkmJyQ42SdMtP6fOyz
         hu/+kFnyI2LG4zjjwh9RyyR4G8q3SJWPyp0f+Ux0cLH6ZKT+IWt5qyV3Vqb/lpwCOMFC
         u7Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793116176; x=1793720976;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1KBHB8+qa4NlnLyGzz+b6HJfV/xmDramajBB5F7wR4s=;
        b=wGktOGuv4b9fXquGS6q0mrMSOH3zRl3ye2N7A9BuzlLVD0DEAMvAGXailH1gkwU+W+
         z/zXrPb0hXUO9g1VyhH5gxKufRkD7VqR49KggC7M9pALGo7SjbrzfCtqYr6X89BnBVV7
         UQ6hPkHhD7oCnXKImTJ+Smi/FXs9OHjXw/pzry9GoVvqIIKh/Ppp4OnA0He8YQw7QjqI
         fnB8C4wcicAAjymaA2QMuxgAX0XeWykqZfOYJckYCfgZisW5piuCepQ610Vu/tMQ50mC
         d0uP2NDT+ipjE0sbxWO+5wy9YsPhg9Jm2UB58wVaCpgFCrbJRsAhShMG2fFnqXsL/Iio
         hPQg==
X-Forwarded-Encrypted: i=1; AKwUvBw1DOt/n+Xgrl+cDQJH3/K7ODY3ppwA4G0qiG+1G+O/p+/HVG2j/j9bQayuixzXYZ4D3lxRf848qw==@kvack.org
X-Gm-Message-State: AFq9FYKhqd73l+iuZjYYKz5oz0WaQ9C2/QOmqcgnU4JyVj0g6wIdiyMc
	fuzLuAabVQLosG/4+vsNEng4BkD29Ka56yx9Pha6ygTdBOhiqORig+7EEXSd+jXNvcW1DDIyQ+g
	1caFV45I=
X-Gm-Gg: AYBFou1GcyabLP7ThXSYfxS7IruNfoKKzbL6D9ojgkx+xjDkb3IIIYvRtLWeYGVO2I3
	Nh2egGdbbL7nWUEC+LMNNNDX7cmfrLVrovGGlYaKrgRivpaUvC48jSa4lXdqWgPOfMHy1o1TnJF
	sRzwh2ZsTd5OdlFO6pJtg9FeEGHyM99vOv5x858yVuBCWqrrWemDvjRv6HCJSGGWpOqxkMoI+xt
	YLo6doqTmDDpN2BWa5/6hwvW8kTaxArAItYVwjqQdxAxyqxAtLcljcn/RufJYk2kliJluKKhX81
	XEdHLpf09MaBBbBqyfO7NrTxTdr7E3EDGEIitbi1/jU/ZM5sC/jSH3urik+7/jzcMVSIJo174wr
	URBBdyP1VEo+djbfu73c/g1LV9jlu2T1PmankqNuTW2tmqkbW8TVUyQHCQvSe1xZsXywJA5bzzT
	rYlfXIKXCmVc7+BnDuc0bDw9B94SqHfPM5u4hO7/98SCGO9c9CsZC2AdpTrUGejLuEYBvHGm6Z6
	6wzUCUk8uFMHG+Dn0AVG7XRA2w1eRGDCO3mtojBtZX7joV0GmuNyqTLWR0LDezR478R5ZaTgHLB
	gvTmY/pUiK3v2oW66TY9Sx7oV0c=
X-Received: by 2002:ac8:5709:0:b0:535:1368:4582 with SMTP id d75a77b69052e-5383b572fa6mr173122891cf.46.1793116175615;
        Tue, 27 Oct 2026 08:49:35 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47ce49d9sm106169096d6.45.2026.10.27.08.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 08:49:34 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 0/6] mm: fix pfn walker races with memory offline
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, 
 kernel-team@meta.com, akpm@linux-foundation.org, vbabka@kernel.org, 
 surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, 
 hannes@cmpxchg.org, ziy@nvidia.com, linmiaohe@huawei.com, 
 nao.horiguchi@gmail.com, ljs@kernel.org, liam@infradead.org, 
 rppt@kernel.org, osalvador@suse.de, muchun.song@linux.dev, 
 iamjoonsoo.kim@lge.com, anshuman.khandual@arm.com
In-Reply-To: <1c61eeb7-5fad-46e5-9643-e99050b9042d@kernel.org>
References: <20261027042204.3741307-1-gourry@gourry.net>
 <01d7d54d-0047-4eb6-a1d2-5b3f113f26cf@kernel.org>
 <179310071902.664110.12994053710961856591.b4-reply@b4>
 <9051ac3d-60b9-4ed2-b781-b7191898bc83@kernel.org>
 <179310895201.1491991.14362391061932133491.b4-reply@b4>
 <1c61eeb7-5fad-46e5-9643-e99050b9042d@kernel.org>
Date: Tue, 27 Oct 2026 11:49:33 -0400
Message-Id: <179311617372.2530325.90240880272181996.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AD4EC40008
X-Stat-Signature: euy931zdtq3ig5nniaio87y9s8b5bhhy
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793116176-26737
X-HE-Meta: U2FsdGVkX19tRgJpKoNIimmnQ9ksfmikTnqruhqK1xlNxBiGggXrKPdi92OslYlG37m56yFRsPjVNIBrkRpYA2Phx9KHdPeAq03VHBpNy3BBOuCKhSlNgKF8Lg6Bu1SVO5cZRU4BpdUsO1arnRQL0tx02RlzhCQUtSYwJaHwYa5hJ9YFoJpVs66tU2m19pYjc477EI2bMxh1yUL6Whe1zii1iZL62kzRtbgz/k21LQpG8DTa0oBRivLjUyHobIFj43SSq7P9sxrlwtyeNVhEsVnZbFkgrigP6aCPQHn5VvCgcY1kJS9ADWA7L2tPSi9WXldR3dqq80zpYTtJlx4TYR0wgqAu6Susfe3qWZf6PeS+6YGaTZDn4G4xjQRcQ71fkiHtw0gNTIMTo6WUKgHTnNGKz1oaZlM4dyJgaH7UwIJJNoUQTpgXWHO/iOZKjeCaJT3qUabbySgtc9ZS3rpCW8YPzG+IYvUM0AyhdKIdmrhMCvqR9Iv8+pihSIMqXCh9dAv+2EYZqU+u4cgJ1LeK3WjcsfAbnejOsqJLs1jDxdKZSoNOx5hNuY6sBSVbLv84s2Dh9x+if9saUvib4pOJrb43T2WJq4YB/l0kY/oNamRfavD11ibaRhUQ/G+A8OKI80RfeYFERYuY7mfWqNQ3AZg2YFApREApzfYlzRN87gcIO89naCkpoy3Dro2xCNZH/Fk1W7j1ozq+MOsN78z1ghGEg3Rcx4rl+Z89oI2xfEORdWty2XVl6Dl5K++x6b01J4Mo1DvWPNwc/63woXTFDvnZJo2T+j+Zwm+F5HtzyvmsnsP35qtZ+WdAx+ltxV1NNA2jDIEV2tmeINga6VimSoRiOfz0pwwrAHpxes0GnM1vHLP6ZxrQ48vOLiw4AdLYHI5a0gP9Z6VKsZUOwzMDLtpx8PoWr0kwUy1/m02VmDxSxfbZQEOylzpasje/6ziCiDsD+0GhLvNL4Ui8Bb+
 K1efoWrP
 b1m5+v2IG2tZ4MjKlVAB6VQ9ip5BZ/IoFyq0xxsfOSGBJdiTsIZwVl6WQl6wU1iDfflTT/UbMHMJ+nEsTZZXjx3nAYzrt9euYbUkLDMAgWbHO3/BU7gUWfxb7qFH+n2WxspvMgcUHSiO0x4Bayio5iiYuHQF0LmvHIehrCsYKE9DhrqJcAp8IjakQ1r9bSalLnDKH0GPllFWNd2B1cL0XbQb3pqxCAUG71/p27JC8GCFTyTWKT7BTH135XCkJI8PHPb55Hm3SrMjQ4CRdwSY6P9OVkajkyZMH+47JGq8MLQYRO+JPwn9Iy/gXrI89mDKcgeGvgmP5V3V4K+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 15:25 +0100, David Hildenbrand (Arm) wrote:
> On 10/27/26 14:49, Gregory Price (Meta) wrote:
> > 
> > while these are ai-generated, I'm not posting untested, unreviewed
> > schlopp for the sake of getting patches upstream.
> 
> Appreciated.
> 
> For this long-standing considered low-priority thing in particular it is
> reasonable to go back in time, see how often it was raised (quite often by me)
> and how often it was actually reported (I found one case).
> 
> Then discuss the high level design in more than a single sentence :)
> 
> Discuss why we are not using it for other pfn_to_online_page() users, how it
> interacts with zone->contig etc etc.
> 
> There really isn't a lot on the design in the cover letter.
>

Fair, there's a mix of design vs firefighting tension going on here.

I'm trying to get out ahead of a rapidly evolving scaling issue before
it becomes big.  But I will admit it's sometimes hard to even figure
out what questions to ask without posting the wrong patches first.

(Cunningham's law :P)

> > Some of these don't show up as crashes but instead as hung offline
> > attempts (GFP_KERNEL landing on movable).  That shows up as our
> > hypervisor just failing to overcommit / guests hanging.
> > 
> > The compaction/alloc_contig bug is one I've seen in production.
> 
> Right, but I suspect that's "[PATCH 4/6] mm/page_alloc: don't undo another
> isolation in alloc_contig_range" which is *not at all* related to "mm: fix pfn
> walker races with memory offline".
>

Ehhh... i'd argue it's the same shape.  But i'll concede some of these
could be pulled out ahead as you've said elsewhere.

> > skippable side note on virtio-balloon/mem:
> > 
> > I have some improvements to virtio-balloon and virtio-mem that allow for
> > handoff from balloon directly to mem for hot-unplug without having to
> > drop the balloon, but I haven't posted those (and we don't run those in
> > production, so this is not the nexus of crashes).
> 
> Do you mean free-page reporting or actual balloon inflation/deflation paired
> with virtio-mem. I hope not the latter, because that is just disgusting.
> 

Actual balloon inflation/deflation.  It is disgusting, but it's
effective.  Right now we use hotplug at boot to minimize the size of
cold machines to avoid thundering herd issues, and then add it when
they actually get allocated for work.

At runtime we use ballooning to reduce a VM to its actual RSS based
on PSI feedback (see: that virtio stats extension i sent you some while
ago), but would like to use hotplug to give the host a defense against
a storm of deflate_on_oom scenarios across a large number of guests.

Basically using PSI stats we can make guests do somewhat aggressive
proactive reclaim on without having to build any new tooling, and
while being able to back-off aggressively.

Free-page reporting is also on by default, but this only helps you if
your guests are being extra nice about things.

(spoiler: they're not! they're greedly little imps! :D)

My experiments made balloon prefer to try to reclaim movable regions
in contiguous blocks, and then just hand that contiguous block off to
virtio-mem for offline without having to drop the balloon.

tl;dr: This seems effective and works quite well.

I've become a little confused as to why virtio balloon and mem are
separate entities when they could work together this way.

Haven't had the time to read up on the development history.

> > 
> > Agreed.  Although I fear the structural fix for this will have uglier
> > performance issue than we think.  Then again, maybe it doesn't matter
> > (if you're doing a PFN walk, then you're likely already doing something
> > stupidly expensive).
> 
> Which areas are you mostly concerned about and from which piece do you expect
> the overhead?
> 

largely the zonelist iteration - which looking back through history 
has already been "optimized" multiple times, only for those things
to introduce more bugs :\.

The zonelist races seem more ammenable to RCU solutions than the pfn
walks.  I'm not sure how to safely quiesce every possible PFN walker
without atomics in their fast path.

> For "broader" things that are not just a simple pfn_to_online_page() user, we
> could also have memory online/offline sync in more efficient ways using the
> memory notifier.
> 
> It's also tricky, but maybe for zone->contig + compaction the better solution?
> 

This seems reasonable, I was trying not to schlopp you with a half-baked
architectural fix and instead use the available tools.

But maybe we should chat (after the window).

I'll try to be on IRC more often.

> > On performance:
> > 
> > I've been hammering this with will-it-scale and a bunch of workload
> > tests on a variety of hosts and have not seen any obvious regressions
> > outside of powerpc (which i can't test directly, but SRCU-fast requires
> > atomics for powerpc from what i can tell - so it will eat overhead
> > without a fallback... if there is actually any hotplug ppc hardware out
> > there to care about?)
> 
> So the big problem is the overhead on the read side for srcu?
>

Yes - but specifically this affects PowerPC because it:
 - has NMI
 - does NOT have NMI-safe per-CPU operations
 - supports memory hotplug
 - uses atomics for SRCU-fast

So using SRCU fast in these contexts is not cheap.

For what I could measure in QEMU, the atomics on PPC seem like they
could be significant (15-20% overhead) in microbenchmarks.

Hard to say what that turns into on real hardware.

I implemented a fallback solution for those architectures to just not
free the zonelists in this case.  They have to iterate the dead zones,
but it's a much less overhead comparatively (<1%, but measurable).

For everyone else SRCU-fast is imperceptible overhead.

> If we can find something else to suspend compaction, we could maybe switch to
> rcu for the remaining cases.
> 

Is long-term compaction suspension even safe? I had to make COMPACTION a
requirement for N_MEMORY_USER_NUMA in order to not generate spurious
failures due to fragmentation.

~Gregory

-- 
~Gregory


