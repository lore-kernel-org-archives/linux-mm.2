Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA5A6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 17:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAC5A6B00AF; Wed,  1 Jul 2026 13:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5CD76B00B0; Wed,  1 Jul 2026 13:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 924366B00B1; Wed,  1 Jul 2026 13:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6965B6B00AF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:26:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C08D7120457
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:26:12 +0000 (UTC)
X-FDA: 84940886184.14.3D60BD1
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id BFE0F100002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:26:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bPRjtl3p;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782926770;
	b=EZM1NuVWoM8gRU8xElQOMwXApD7Q6dAYBCKdeRGlXTlmsF8Ae7y6d92p9NxBdy2mcsH8xe
	HPcT8CNO8ORCBHF9ZvJnstUiV/wpVd/w0gJ1Q7RKX3IUZztSxtaZS0bwu3JJ2/PlLVlImy
	XJ0ci/vLMge2wxsQ0C9UyOBu7jW09Zo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782926770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GBB5HZ6zDCVz0SCESSEY3U9B2MI62tJWE3p2W/LN8NQ=;
	b=JF1MOAFeMgIr6C71rtFwcOUPxPXYPY0olNIbMCng46tANpgFRFMRXuQX/slne3vFGbjbyR
	SDHJHbnHw3WKteMRH6ebr/50lwFTnPBiN7Y6qVeUzept7xobcskcw9/j59cPh+hU33bV1h
	Ea7CvXIO8JJbaqufYydrM9l/WZqMEqg=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bPRjtl3p;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c12788a75abso187176266b.2
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 10:26:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782926769; cv=none;
        d=google.com; s=arc-20260327;
        b=PPSyY188/s9LvmZqV1zbpL6VKbDHpGTp1fSMQnvP0FTmA0wrxasglLrDY7s5F5rUA2
         hkw13+V54pyf4qYLayDw5LzFyN9VFjmceBRH07roUCFPk5g2DYcPmIJmwfkTf3Nt5LzX
         fFRJ2C5ZtS1dIieowGC1HfKSKaG7zTpd4BaQakob2/CsrLox8+yrqQj8peTTsPKdKczE
         ZvXGcdRGhKLLnK1FcK0gXqZvWdlUw1nMF2O45R8iIyYE1ZILdYncptMqgjxqwkQehMe8
         Ca/KUkKrHdbpjwyY1bAcTz+gjNiTnjsE1EbKEAztPCj+lJEtHlBy2jpuZLAoL1yLQSJF
         UoQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GBB5HZ6zDCVz0SCESSEY3U9B2MI62tJWE3p2W/LN8NQ=;
        fh=+fVSvtS7obMfEoEGsavUXPg28Wocs4ZWSUiuubH4IPQ=;
        b=YS6x+pwvA0LuUENVQ2+HnJ074AJBxv4THDHkv+0Q2Xsys1kT+RDZnHwU5/f+GAfU/n
         unJjan0kC1r8tXP2xo5jvUCn19gzW5ktFu/Aslsqmt5pu2dSVCqsv93pix0SIhaNFQpi
         vQeBPIlaHqghMTf1lczeUfF0hC7LxsixoKME2aO9dkyAk9DR3kNwqMH5LRoL1/0QWl92
         LjUW9GE/7ei3VIkUcr3LoGxGldsiW5co8+JJgV7KhLS57TI9clxfasm5jKCvh/mJxn+d
         T4pRsFuWPHKM7TFxnhScyXsd8+71ZuSkl4OE5wfPcdcCqQgnAudYzORivxQD2pQwZriV
         0ubw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782926769; x=1783531569; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GBB5HZ6zDCVz0SCESSEY3U9B2MI62tJWE3p2W/LN8NQ=;
        b=bPRjtl3pNJ7VTpYxLeiRxrYOu2DxcFFGorhAzV1S9MWJrI7RCtLMVY03vxdian+HIb
         6EeB2nb5R/1stj4izXVlWCJMS+fVBfhcsxXCCmkgf39SIRnsHcRR/i022kEWaVpt+3ff
         t8TkV62AZTGkiI2J0jKCpKD3+G21P1p9BbUFAUtgWdxf6UWpeV4CRJ/uPzr2o80WbOJR
         6GgxOL5NcOR4pOXYxEkP/mlvgLQWwswP4RAkN4HvO8b0KDS+WQhGOYmldB5a/ZTBLOGr
         j037B0vOMjwAUvQcjtmGruIZzmvjqlQ+AFzU/f+KTbBGl9AcqR2pxWP14lFYEJRVVGOS
         5KSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782926769; x=1783531569;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GBB5HZ6zDCVz0SCESSEY3U9B2MI62tJWE3p2W/LN8NQ=;
        b=NXce5zG4Hz++KAM76Di1etR3hbFNhVsIt2FIEh2dBMQ5j97OUPEsX7mjIs5MPlMI6H
         Alz/si+tLDwpKhZLr37pouasaLN8LIX4NvZSI7JvUV6J5ViR7LpmCdyHpkmyAGeT+641
         MvyqVWp5rl2GCVfY67uvgnQYQ3wnC7EnLrdOZ+YaYRa8pUf4LOEzdSAwgFoJP5ncNn9r
         rKzSvFu8WcphTn/hy7ZL3u7zHgCTPYu/sLOvCQiAsHWvyWRqDTwob7m2PEUsyJjPmiPe
         XLut12dNe4HjiBeJJpbZqsSDMm8NBB64xmbcR3j2h/cDAHnCW2d2kKUuB0cfuatKwju4
         IVtg==
X-Forwarded-Encrypted: i=1; AHgh+RolrtDAPz5Bgave1IJJ7V7NCGc+bjcKX2o/CAbbex5ru1M1nbTK8eJ0ZkZ0Q23Hbt0mrsmOBoJIwg==@kvack.org
X-Gm-Message-State: AOJu0YxD0F+ZZdjNiFdy+wOJ0VJ+12rdQuL/Z9e8dXCyOVXZRdaB+x+G
	RbRox+TsAgnLAR9Hs9V0K4VuAoBUu9vNuz9LvtsiOCJ1B7BP3ERsjpXWBlljttXoFkjTyi7uzfx
	V0EHMmU6fmNNqIsf7kD33+yNVOnaPGGg=
X-Gm-Gg: AfdE7cmwbnkNr3Lk9Qd7J2cAzFayjq+6mnFOAZEEI4Tv8jh/7Hvutc+8rb+XdTY3cR1
	gPAhIGD82HLT/lou7TXnoEMe3PlhHlhCUpJC6VsVwQbvSdFzATy9ZSMWAEp5wQvo3P5zqDdCbRw
	vePLgnN6DF5+PqTzEWsD7HZ0d7kyaziNYGXYyjEL9lavRz2bJdj9c11UA5Db3iVkNhHMFFN5zpe
	QUufF+u5bldWpyKTtwHSqjTidC0CXvBflNwqHJXy7pRMFJHSbIDTtX/sFwPtw3ELG6YLCcN2NJp
	s07MxjFjnJCZHnw5KNqGANfKdlKvpw==
X-Received: by 2002:a17:907:e102:b0:bee:ac9b:9abc with SMTP id
 a640c23a62f3a-c12ae4095f7mr66116266b.22.1782926768722; Wed, 01 Jul 2026
 10:26:08 -0700 (PDT)
MIME-Version: 1.0
References: <e1c290782eeb419e8c3e18ac6b1f49eb@xiaomi.com> <126cb4ced14f4a3fa40c3189bf8a5920@xiaomi.com>
 <49858bc642844e3bbf6449c0f241af04@xiaomi.com> <700a2cbf90a2484f979aac858f08f5d4@xiaomi.com>
 <623db71c-daab-451c-909f-a8efa56b998b@linux.alibaba.com>
In-Reply-To: <623db71c-daab-451c-909f-a8efa56b998b@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 2 Jul 2026 01:25:31 +0800
X-Gm-Features: AVVi8CctcQDElI9zL7pd34LeyQdKnKpM1fDGsN08-NT-WlwHLsQHKfiPOh_GADc
Message-ID: <CAMgjq7AcD4Mg5byJr-niZVp_Y=_ZVeCp42xakGCa=mw4zXkJhg@mail.gmail.com>
Subject: Re: [BUG] shmem: shmem_get_folio_gfp livelock
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: =?UTF-8?B?6ams6LaF?= <machao26@xiaomi.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, =?UTF-8?B?55Sw5a2d5paM?= <tianxiaobin@xiaomi.com>, 
	=?UTF-8?B?5L+e5Lic5paM?= <yudongbin@xiaomi.com>, 
	=?UTF-8?B?5p2O6bmP56iL?= <xiaoyaoli@xiaomi.com>, 
	"hughd@google.com" <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BFE0F100002
X-Rspam-User: 
X-Stat-Signature: 5jmdkr9r7fo3m6c8jiqibi7esznygrhm
X-HE-Tag: 1782926770-81226
X-HE-Meta: U2FsdGVkX18YBJGEnRSSR/3AomdDltYsVn/q3tVbs/yLYqXEHhWLZFb+qtYIHpo5gLG+wktspI29/yCO5o2hty149ss1cKuMiay8DPbIHIu1vj80cTvRGrE4pLUJ0FBGI+4vJvg4ocI/EoAOrH/5/3z15gBno6dge6Z1NUP9ovK1NZazrcOwPORJ/06PV85ux4xHIWFnIS4ltqWuVyk3to1Le+jNScyzalv3pto0XkbNxSMBwSgAOrhj4n/yxcxQ0ES2VD1WdLkWT/L4y3RSxWo4C0k1jKEK/9ekpdhvMjAyM8VhoR5ZTN54INh6PQVhCqnPgRRmeahHgDOtyrFy3lBAAh81JRQzbes40snIybN784PqkxNUo9F5v9159kmSd0uslCLW2CAprP4WCz/SM/aZqKgZ8nB+I65IN5+zOrERrcAFFwfKIvdBkDy3C4IBzsXWO56r4S67AeKDzPOzywQPLUeILtakIkditxl/BNKNI9CCJCXW2X8iYAXTkd0EbtbTaFdNLVMjAFNwOROd/6MbcaJmrvZeeWY8hGdQI2nLbnqBEkg74k5YWqc/bP3WH5KdAQYAs1cOFHIpgCr/GkIaXn3SXuQOdda+fnKXhEOChOn2cj6Z6CNXn23GvKHLTIITL2atuPY6MUKk2UhdEkLXRFWixiCPIaL9NpYxlTrFLzGxqPweQUW1U7pWGCQriiDVGG3noGslFI8wG5g+KExh4n80yy2vgeWPhrxjuxjpFcPGjPlcN9XjK1MZjQqs3XvaYU0oouKjWwKuP4jzE4xFFzGjhBokm7lDNq/Vu+rom1iArBd/bBgI5nXtkpopQzMuReH1AXmiRduBhpJfmJ+JEcxGmyceX80qSkrvKeQUFm9RjMWbj0oo4B6nuUJAe5Kv1sEx0WqY0AsEHSvHI9ZMQXbKC6etRw6guKZXAJ6zqSEEZAoYPUbW1qC8oS9tTWSljltX49HWbSmSXW0
 ay5xX2g4
 Nr2fpqkTYsyv/hnqaPfc010OMzYA5dETf0zCYGnC5jbOCkrwl+oRUPZ+ag1YRxiGeDbmvEymm3HHndRDZw2DTH3fsqlPSnEtH4SYnWXffn+2H7Stlgi5hkvwo6MB0rgqFTVRig51WkdvqhSN3n8coUYO5AD106NRaNHs6BfacIIYGoS1JT5/onG0GJseNaDBqS/czn2Xdh8dt/1fbAP3wcf6wRsomxm6Zs1OWWh1lztgfd2N+YtJC5oEnY5lwL3w9hWmwWPBGLyG2fNKjTinfRNeIblv0BmmAeENon7lcgnhPSllc1aCeMIYsC+Aca/yfr2sKf0u52tYsPngX6Zyf9kZADymKMzbtkc3hjWamwgONO6gN4+dqJ9j5uZS5409mqxvgMRTY2uN4iQKb2rUYXdJp0DaFY58qHo5WKHGRQBIq6Y2b9/pmbpBEgiMJKiVJEqx5P7I2A6b30HhSrZtKj2RH0gTrM8Bcw3tBx+5hhxn4uwjFRm1XN//lI9M7f+eib2HT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 1, 2026 at 6:09=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> CC Hugh and Kairui.

Hello!

>
> On 6/30/26 9:15 PM, =E9=A9=AC=E8=B6=85 wrote:
> > Hello,
> > I encountered a bug in the shmem subsystem. Details below.
> >
> > [Summary]
> > shmem_get_folio_gfp() can livelock when multiple threads fault on the
> > same shmem page concurrently. The -EEXIST retry loop (goto repeat) has
> > no cond_resched(), causing busy-looping threads to starve the thread
> > that holds the swapcache slot, resulting in an indefinite RCU stall and
> > system hang.
> > [Environment]
> > 1.Kernel: 6.18.21 (ARM64, PREEMPT, CONFIG_LRU_GEN=3Dy)
> > 2.Triggered by: multi-threaded app with threads constrained to 2 CPUs
> > via cpuset
> > [Root Cause]
> > When multiple threads in the same process fault on the same shmem
> > swap entry:
> > 1.Thread A enters shmem_swap_alloc_folio(), succeeds at
> > swapcache_prepare() (sets SWAP_HAS_CACHE), then enters
> > workingset_refault() =E2=86=92 lru_gen_refault() =E2=86=92 rcu_read_loc=
k().
> > While inside the RCU read-side critical section, it is
> > preempted via preempt_schedule_irq (IRQ exit path detects
> > TIF_NEED_RESCHED).
> > 2.Threads B & C enter shmem_swap_alloc_folio(), fail at
> > swapcache_prepare() (slot already taken by A), return -EEXIST.
> > 3.In shmem_get_folio_gfp():
> >      error =3D shmem_swapin_folio(...);
> >      if (error =3D=3D -EEXIST)
> >          goto repeat;// no cond_resched(), tight loop
> > 4.Threads B & C spin at 100% CPU on the retry loop. All three
> > threads share the same cpuset (CPU0-1,cpus_allowed=3D0x3).Thread A
> > is perpetually preempted and starved =E2=80=94 it cannot complete the
> > few instructions needed to call rcu_read_unlock().
> > 5.The held RCU read lock blocks the grace period indefinitely,
> > causing all synchronize_rcu() callers (cgroup operations,
> > fd allocation, etc.) to hang, eventually blocking init.
> > [Scheduling Details]
> > Key observations:
> > 1.Thread A was RCU-boosted to prio 98 but accumulated only
> > 99ms of execution over the entire stall period (~1200s).
> > It was effectively starved despite the priority boost.
> > 2.Threads B & C have vruntime=3D0 and prio 91, indicating
> > they run in an RT-equivalent scheduling class (SCHED_FIFO/RT
> > policy). Each accumulated ~1134 seconds of execution with
> > only ~1600 context switches, meaning they ran uninterrupted
> > for ~700ms per scheduling quantum on average.
> > 3.Thread A cannot preempt Threads B & C: Although RCU boost
> > raised Thread A to prio 98, Threads B & C at prio 91 (lower
> > numeric value =3D higher priority in RT class) have equal or
> > higher effective priority. The busy-looping threads never
> > voluntarily yield (no cond_resched(), no blocking calls in
> > the loop), so Thread A never gets scheduled.
> > 4.CPU contention: CPU0 had nr_running=3D28 and CPU1 had
> > nr_running=3D24, with 3-4 RT tasks per CPU. Thread A competed
> > with Thread B on CPU0 but could not win scheduling.
> > [Observed Impact]
> > 1.RCU stall lasting 910+ seconds (19 consecutive stall
> > warnings, grace period g=3D4398761 never advanced)
> > 2.synchronize_rcu_expedited() callers blocked 742+ seconds
> > 3.init process hung > 720 seconds =E2=86=92 system unresponsive
> > [Call Traces]
> > Thread A (RCU stall source, sampled 19 times identically):
> > __switch_to+0x1a4/0x360 (T)
> > __schedule+0x96c/0xf3c
> > preempt_schedule_irq+0xec/0x198
> > raw_irqentry_exit_cond_resched+0x2c/0x44
> > irqentry_exit+0x38/0x64
> > exit_to_kernel_mode+0x28/0x38
> > el1_interrupt+0x5c/0xa8
> > el1h_64_irq_handler+0x18/0x24
> > el1h_64_irq+0x84/0x88
> > workingset_refault+0x16c/0x79c (P)
> >    shmem_swapin_folio+0x8e4/0xd44
> >      shmem_get_folio_gfp+0xb8/0x710
> >        shmem_fault+0xa0/0x174
> >          __do_fault
> > do_pte_missing
> > handle_mm_fault
> > do_page_fault
> > el0_ia
> >
> > Thread B (busy-loop on CPU0, sum_exec_runtime=3D1134s):
> > xas_load+0x78/0xe4 (P)
> >    shmem_swapin_folio+0x950/0xd44
> >      shmem_get_folio_gfp+0xb8/0x710
> >        shmem_fault =E2=86=92 ... =E2=86=92 el0_ia
> >
> > Thread C (busy-loop on CPU1, sum_exec_runtime=3D1134s):
> > xas_load+0x50/0xe4 (P)
> >    shmem_swapin_folio+0xd8/0xd44
> >      shmem_get_folio_gfp+0xb8/0x710
> >        shmem_fault =E2=86=92 ... =E2=86=92 el0_ia
> > [Question]
> > What is the recommended approach to fix this livelock?
> > We are considering adding a cond_resched() before the
> > goto repeat in shmem_get_folio_gfp() to break the tight
> > loop and allow the swapcache-holding thread to make
> > progress. Would this be an acceptable fix, or is there
> > a better strategy (e.g., bounded retry with fallback,
> > or yielding to the specific waiter)?

So this is a 6.18 issue, the SWAP_HAS_CACHE design was a long time
issue and we had a workaround for anon in commit 13ddaf26be32, the
`schedule_timeout_uninterruptible(1)`. That's fine as a workaroud and
we remove the workaround with proper redesign later in commit
f1879e8a0c60. Shmem never used a workaround like
schedule_timeout_uninterruptible and we jump to the right design
directly.

For 6.18 LTS, do we need a fix though? I think we can have a similar
timeout for shmem as well, just do a
schedule_timeout_uninterruptible(1), yes it's really ugly, and we have
another long time workaround like that in mm/swap_state.c as well in
6.18. Without the later proper redesign there seems no better way.
Barry provided an extra improvement on top of that workaround in
commit 01626a182302, maybe can also be carried into shmem. So maybe
having both for shmem is a good choice for a 6.18 fix.

>
> IIRC, the scheduler maintainers are not a fan of continuing to sprinkle
> random cond_resched() calls throughout the kernel. The scheduling
> decisions should be left to the scheduler itself.
>
> Regarding your issue, could you try the latest kernel? IIUC, this
> problem has already been fixed there (likely from Kairui's swap
> refactoring work [1]).

Yes, exactly, the recent swap rework removed the root SWAP_HAS_CACHE
problem, so we should no longer see any similiar problems like this in
mainline.

