Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39517C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19E436B0115; Mon, 29 Jun 2026 11:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14E706B011A; Mon, 29 Jun 2026 11:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 067006B011C; Mon, 29 Jun 2026 11:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D49BA6B0115
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:57:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A47BC075D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:57:39 +0000 (UTC)
X-FDA: 84933405438.11.39AF65C
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf01.hostedemail.com (Postfix) with ESMTP id 873AC40004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:57:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lpag+Snz;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782748657;
	b=MTVLk6PGDcm8F3UYl0eyksBI6+LyyAUax8Rw2Oppt9EhhFfEi4HDgrxd+sj27P4NNpjJGe
	DR730NBpMIXxmZvsJ44cDfdxRBop8HW8sZDISKFka5Zen0SJcDtFfz4gfghNfBozDL08TD
	H0UwgnGNUyGEie6xQP/utGPNtmLw8Pw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782748657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6iVA2zRP3Q6Mev0wUJ3/G5DB+CMqN0zyU8Yc5QNh77w=;
	b=0G3PnBQNM8CghJCgE20NFdlA19vxT7rztcr8GDW6Uwnuu+AQicBvXz7NJUFW5zPWhDi+ev
	JgXMjdnjvMmAa1lZBdzrI5prr3w4qufJMUbLZ5PvwLQ85TLEnerCfenDSDobTbfT3sq5Ex
	U6E4EYi9MSQ3fgKff+sAIQZJ+Kt30uA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lpag+Snz;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 29 Jun 2026 08:57:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782748655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6iVA2zRP3Q6Mev0wUJ3/G5DB+CMqN0zyU8Yc5QNh77w=;
	b=Lpag+Snzofwc6iR4Pe79wtgkKtmI3CamHNCFKedLBoxwi9QClFx0Tn0R97WOCXV0detlj2
	gKR7xAFBnXqUhdwX7uYjOs/EO0ZOPf+V/Oz/F0aAYV89hE/QV2e09r0MYo7ho0OAZu1m/N
	iAOyzMNoWwKytHpGqVhNc5mwX2LjRGQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	linux-mm@kvack.org, hannes@cmpxchg.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/vmpressure: split v1 userspace eventfd code
 into vmpressure-v1.c
Message-ID: <akKVyumaSGpysPUR@linux.dev>
References: <20260629130042.2649505-1-usama.arif@linux.dev>
 <20260629130042.2649505-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629130042.2649505-3-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 873AC40004
X-Stat-Signature: z7wnq335wrxoxjmuuj1tut1hkk4jnt4g
X-HE-Tag: 1782748657-608177
X-HE-Meta: U2FsdGVkX1/OLTRnWRnOOdVxcFoqjCAJZa9LCWZw0hGhRr9B/xEyG7W8HaVl9SjJCUIYPQKE3ql8Ams/Ac3iuWM+oHGlYyhMOY+11025lTfa9odtn8lvqe/RpMlcGvRpbfl3QJP1ilTdLe6pVV2TkX9cHv/e6LuVQruxDeSkKoNqrEZfjgyNy3nQo+WGBOK55yV0/jQ+C1mh+NhRKsjwpWexWMKHr7ptuUEPlVw1sA88C9HSw7IEpzGjlM4fOf+HarsFiaNraN8kIgdEF+gKRuurMN3iQbdYCk9YTG5GQR11oLt6y/eiJclXcz3FhEx1ZH2t95d7Ax4rzJCFTNbw2F9GVc3mZG0n28uNLGMM5b5UpB+T7EpUMSHiABf5hyWNhwsdGltMH1Xgq9SPwqniOa4x6eI4bMBPaAZxNup6uVUDOKJi+yHo+0FhVZ7vDA9HzjupZqWzqTCJpa64ZatdfZTW5WPtU4G8mzYz0/kfJxBy7+2ud1bRGtBkH/mLFEP0ESGu8NFugNjGBL5F4wWvzx9Z4/ehjYoiOV76QA0oFIcpG/UdMggN4WXt61sFWBUFgsN75tJgePX4yMlMLXBBO2TP2rdQ6jyx9ElWEuLktMOlg/gDUsIS2fTJK/LwVhHjVTS324XbAeMHk8Le041FLcON6Ro+byJ1+QLIfU03h8r+4xqEPRYSCaTAQH5HpJ8bv12dQ5MEj5xjfahHaOscFJrU+7gOJBUDRupL+4eM3pH9t5fsr5FiWlIPyg/y9m3bVjuZUoqaqJtyvBEBeuxZp6ThJAFWiTi1lmQbP+IjnDNv3wookaXnQHah3xkCxm0DRfG3FPkj0dIQ6CaXx+bmRIuBh1ECzrV+gkjHrTnsnsamcXzA4jyRiyA0/MTMqXujJNBsDCekkNk7g47ITiMJ3kzVrsuDUCamDEcf/y9mE9UImxnhfP8p58mC2EaqzkwzB9v6lQzG3Va1YpNBGrs
 kTIksom/
 9wA0jCvBBgkY+sqG16V2u5/vXQcFVS81LWvNVOGGxQjUl4O5BPfnfDGrPEqRNaeUlzj/ktEal1i52AFdeeGVo6nLmVx+bMahia/MPfTvdpEAVdMijelswo4jXedwHK8HqZ1P26Fo3ECKBPW4EaOPTmTJKB9ubMTKu3ZNRO4+8H443QSPGF6OUba09Li09CLRIlKlD6hQkgLFP6xkPksVQy5phUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 05:59:37AM -0700, Usama Arif wrote:
> Clean up mm/vmpressure.c by separating the cgroup v1 userspace eventfd
> interface from the shared and v2 in-kernel code.
> 
> Currently, almost half of mm/vmpressure.c exists to serve tree=true:
> struct vmpressure_event, the events list and its mutex, the work_struct
> and vmpressure_work_fn that drains tree_scanned/tree_reclaimed, the
> parent walk, vmpressure_event(), vmpressure_register_event(),
> vmpressure_unregister_event(), and vmpressure_prio() (which always
> calls vmpressure() with tree=true).
> 
> Move it all into a new mm/vmpressure-v1.c built only when
> CONFIG_MEMCG_V1=y (following the existing memcontrol-v1.o pattern).
> 
> vmpressure.c keeps the shared bits (constants, vmpressure_calc_level,
> the runtime hierarchy check, the tree=false body, init/cleanup
> plumbing) and calls into three small v1 hooks for the tree=true
> accumulator and the v1 portions of init/cleanup. The hooks have
> static-inline no-op stubs in include/linux/vmpressure.h for the
> !MEMCG_V1 case, so callers don't need ifdefs. vmpressure_prio() gets
> the same treatment, which means vmscan.c's call site disappears at
> compile time on v2-only kernels.
> 
> The only #ifdef CONFIG_MEMCG_V1 in source remains around the v1-only
> fields inside struct vmpressure itself.
> 
> Memory savings on CONFIG_MEMCG_V1=n (measured with pahole):
> 
>   struct vmpressure :  112B ->   24B
>   struct mem_cgroup : 1664B -> 1536B
> 
> This split is the first step toward eventually making vmpressure
> CONFIG_MEMCG_V1 only. The v2 in-kernel socket pressure path
> (tree=false) cannot be removed today immediately: PSI is not an
> exact replacement for vmpressure, and switching networking socket-buffer
> back-off to PSI may regress networking performance or increase memory
> pressure in workloads that today rely on vmpressure's hysteresis. The
> medium-term plan is to introduce a PSI-based socket-pressure path, keep
> vmpressure available for v2 behind a defconfig as an opt-out for several
> releases, and only then drop the tree=false path entirely, at which point
> everything that remains in mm/vmpressure-v1.c is the whole subsystem.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

