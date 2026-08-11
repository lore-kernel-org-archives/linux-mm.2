Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25D44C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 04:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBEB16B009D; Tue, 11 Aug 2026 00:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6F586B009E; Tue, 11 Aug 2026 00:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5EC96B00A3; Tue, 11 Aug 2026 00:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91D896B009D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:43:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 119F3140313
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:43:35 +0000 (UTC)
X-FDA: 85087745190.24.D3BB428
Received: from out-178.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	by imf16.hostedemail.com (Postfix) with ESMTP id 14498180008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:43:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c5ql89xR;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786423413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TAa3sw5p0PFvqcG8s8R3U9OywJr1pI3i1+gG5+gOdl4=;
	b=Gr/I4AFF8O+I4WDxd6yyf4sfSC2S3VWE+8YiJc8LGffha0AbK0rIGJV7nj9zU5AtujGiWL
	L0gxmDMJ34c1BhuA2yK8QGrKNy7FcMz5T//tMZTUKTWhXmIbL8cCTNY+XoMbZYvyieQfoj
	oX4m+FtgW5qFJtZNlQtvo1swvGV+Nps=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786423413;
	b=vad/P9/b2Ph0gNDzvKm+gCrEmznZGAoQge+qKjswJQuPp/qonzd11TZhz2XmEpAXnbWS4s
	YxpjgUo4DqRnddDE8ishbZRoFvg0iRrSEHq10omxAT/2k12nLh7/h3Zx8IK42mk14c6aNQ
	vm8KOJAlGAVC4d+TqnGXI8DSouLQruE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c5ql89xR;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 10 Aug 2026 21:43:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786423411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TAa3sw5p0PFvqcG8s8R3U9OywJr1pI3i1+gG5+gOdl4=;
	b=c5ql89xRYRy2pSpxstsC1459EUgtdleOV6rPwoKDYgmirKS5mwSSsBYuB/M1bb+lQJ1EoR
	q645k+I9xrkOD7oY9SrI4VwAZKlFfdH6emocNjLWRViEMUD+fcOLFPSfbmoP6HJHwml4bn
	Or/1SYv+F4PtNfIdH9uYlnHY6XLibXs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	paulmck@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: report RCU-tasks quiescent states in
 shrink_lruvec()
Message-ID: <anqnkZceNHyvbR5S@linux.dev>
References: <20260810-rcu_task_shrink_lruvec-v1-1-4d9f7d5251cb@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810-rcu_task_shrink_lruvec-v1-1-4d9f7d5251cb@debian.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 14498180008
X-Rspam-User: 
X-Stat-Signature: 9nop8oufdg4x7wfscuk81br95hnrm7c5
X-HE-Tag: 1786423412-166492
X-HE-Meta: U2FsdGVkX19yLf5bas/zHv0lqQ16CaLjQfK73y/xn+XPeJH4iE+/VQJb3CaZluT3vhxqiJrv+wOkcMu4Tj+gLKU4S5FAB4/1YMn/euQlKVvLVJF8fiSye8x87brCGwhrYo/Z4gFiMkS3l6gOBjI/9vtHucBDc3BBTecB3WFaZ8lzfOfaqUd7rw+46arPk/4xtEWd3ckMdfiPCB2K7R+tZJKTE1k3MBanBR/2wFUeZltbQ/fEysJAjaDV6A1hxCWxGlhSoqibJj+WofJE79zjHtUM1JZ+cEmUWshTWk9Ud98GJ7614d069DldFO2OEMMiogKMiBAS4vroafBZj/S9fAYMYLi1c7/aQmz9k3XFBZtmeIpFwby3xVvlV9YYigINQApETJs1bJFIg3Gcgz/9ql/8Qs5St5Io76KM0cbtVX0WQ/WdjwyNQacmE5NMLFhESdwLoJU2uuctAeyEoM0jycnxtq8Kvun2+LmD/tJq2FEz3p9K2Hl2XGaocaUje5jmPNyafaFBOlXgq6FPpfG+12YFZbKPfoXdjL12dPVQEDQo3Hzny62oaLMd1sZGyz/IgQ7Tv+E1vHyf+8sc30pOfsH4aAuUffV++djoK2qfrYHuxjTwVTBE/FR9rKxHwmxkvJLVccSoVLbEDq49mHTwECzuoUUplLVJk8XtcMuJXbTkwJRtGxwh4NE5Yte5o0RqvsY6PkkdbB//wYH5qn4jagv+5fpZ4mOJ2T2xlFvsu5NjLzulUTKFZ1N5vrpuQCNqHiY9fu4+BlySntPA9EtYnQRCanL5G+oZRJG8zr19T11x/ctzhnaHa6R8XDrPReTsbEMoBhNKPiAaOhqnpdZBHoHlGDp+CE0fLTISaVhKulQbxbTeEpd9WOTwW7RQgsAsscuvGsiV8QLsfbquZ2WtbEN0YnfVJyWeVzmuC80XPo5xrSbova1ZCn3us23kDPbkk6ToJLB5mEBtk/PeN6M
 DEFvrKSs
 L4rzjski2Fcfn2g/ZYEmLyBMyjQ5gMs5JpqMHfiAfgy4M6532GPrRAuR3eviVgxhIBuBNV8+ELpcRvaYlKsLl07ekZxm1b4evY+w/8OvUtchUz0eRCzIuprrqV4zjadsmM7zP3pLG7Su+3TuEG4hwTZTra5kHdpoOPszy/Q3pRn4vAZ8DYHpDf+YmZYzqUHLMcU6ZwjwfT3v9BqTo4p6gH9UR51tLknsR9eHqzGqdvAgInPOzR8m8JULdY9pl8sDOYhxbvd5/EnKdIm9mkmB2CnrhnRj5EydHDCne
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 02:57:36AM -0700, Breno Leitao wrote:
> I am seeing some rcu_tasks stalls in the Meta fleet during reclaim.
> 
>   INFO: rcu_tasks detected stalls on tasks:
> 	0000000088620d09: .. nvcsw: 6735/6735 holdout: 1 idle_cpu: -1/8
> 	task:GlobalCPUThread state:R  running task  pid:2552016 tgid:2524552
>   Call Trace:
>    shrink_lruvec
>    mem_cgroup_iter
>    shrink_node
>    do_try_to_free_pages
>    try_to_free_pages
>    __alloc_frozen_pages_noprof
>    alloc_pages_noprof
>    pte_alloc_one
>    __pte_alloc
>    handle_mm_fault
> 
> Nothing promises direct reclaim returns in bounded time, and the scan
> loop in shrink_lruvec() only calls cond_resched(), which is a no-op on
> PREEMPTION kernels.  Involuntary preemption is not a Tasks-RCU
> quiescent state, so the reclaiming task never reports one and becomes a
> holdout.

I still don't understand why cond_resched() is being treated as involuntary
preemption but that is orthogonal to this patch.

> 
> Upgrade it to cond_resched_tasks_rcu_qs(), which reports a quiescent
> state even when cond_resched() does nothing.
> 
> PS: This has been discussed in [1]
> 
> Link: https://lore.kernel.org/all/amdWVTs0WKOxguxP@gmail.com/ [1]
> Cc: stable@vger.kernel.org
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


