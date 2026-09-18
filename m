Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC237C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 19:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99E106B0088; Fri, 18 Sep 2026 15:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94F0C6B008A; Fri, 18 Sep 2026 15:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8662F6B008C; Fri, 18 Sep 2026 15:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66EB56B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:32:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D0FB140742
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 19:32:42 +0000 (UTC)
X-FDA: 85227880164.21.926C1BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D5648120004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 19:32:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kr5npqUT;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789759961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VABaJiNkB+07BojV48SKGNtgg2IwaRyrt+EONkqTGrg=;
	b=i4vpc4Rx0skXny8kzjECuhCE8/r8Mf2c6B4jJtAyc0q0ju1XmUfLujGXT2cwQM+puTD79L
	p7apr9Btp+s77QzDSf9JRRKJWpw1Go3fTntu+rYu1CELLOKa4pv2hX+W97gdKyjl3Etmm9
	mjTOox+Qs3wh8hfUmyd91LB202mPrnI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789759961;
	b=yrbcWpQ8QJKf9v72lDnxtYkN9c6E1lv07afcpYkdBBa0fSTC7JIBz2wYYu9Zxt0JhSojAX
	WafesJXfdi97tNQ20IMXAKncHOvD1EZd1exSUypCQQF6+YmNoDtUPKBBHParMIXcVulu3B
	6smhiUkufCX9TKwIe9ISkcsMi9RG6EM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kr5npqUT;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E663602CC;
	Fri, 18 Sep 2026 19:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8391F000FF;
	Fri, 18 Sep 2026 19:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789759959;
	bh=VABaJiNkB+07BojV48SKGNtgg2IwaRyrt+EONkqTGrg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kr5npqUTuUYIza0EGwv8Pg0oNpVs/9IBZjeSpnYCPu6IPmMsPIRAUgoG3t7c4L2kz
	 LVnje1t/pJHBSKi241YC/xgs60r2ae+81Xt09eCek58jEYUAcGTfyqSoN/L/TtYEUX
	 HrejmoiEpUBqYcpsbCg8muFi3WxyiezK9mUxrI1w=
Date: Fri, 18 Sep 2026 12:32:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/shmem: report RCU-tasks quiescent states while
 undoing a range
Message-Id: <20260918123239.8f25b984ca280fcc11ef6e6a@linux-foundation.org>
In-Reply-To: <20260918-shmem-tasks-rcu-v1-1-79acf91a2569@debian.org>
References: <20260918-shmem-tasks-rcu-v1-1-79acf91a2569@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D5648120004
X-Stat-Signature: f5oqpg856jbtafkjw77sxznkrkjd9a4e
X-HE-Tag: 1789759960-526032
X-HE-Meta: U2FsdGVkX19t0loMt+Hs/tDX6OnikvC/q9KXMU4t27htQCXR1hDyCHqO/gNb3DsQmPaVs7oIWT0DD1uXcuHWfOR4kS39eEIVtSoiTFBGc8mr7OUX8vXUHyy7unwUmQogq3A8v81aCbunEcFQn6Ol/ZGchwIy4ykOhmji1BBd5hys/iqcfDMvdGV03osff7jjcG8JxLknOcOTvAUbLAvR9Aau7v0Bxh0XnTwvmmQ+st5XfnETDMdTy9hkq5bFaiBjepKZ9vs+/Rda3tOn0daB2yBDqt+vscqtBHxsn4uonAomIEYDmq1nM/4FO9H61vSktfBQP7s6rVooRYyeVxPvsReE8+qFnbsGyxSp5cmMHjeOs4MjmjLxobpkj3YbgtBPITG2cZBGT8ZHic6j6zdBOm56SC6wBrZxfM7JWfjE1iBOQx3GoW+yN85alhZTzp7FP7SO3fVq7PbuylczoF9E0KyG0leoMNDWtCQHPh53EtcJm7KIgl2fJAKPhJBC8ogZyB7mA7v9tLKfx57yzHsX5RUnUIhp6cIaFZ5VFUpWO1ndP0qMXbiX+0AJYGfbqcByG6Nt/nh31ppqrULO2MPy27e1REg+lX+uII3l9yjBhDea+ka29nS7CqMLQvSuuuiWhwkFGZhdVZSpJ/l8sPb+Woo+Ma+x0nBblhAU5vbtHu+jVFfkmAv9SCWqtr3EWtvZACS6EcbF6WIUM8qMYg5AOS5IpbdYZk8ZXC57Kkz96e/0SbQ2Zc1j0taWQ66OU2pvoFnIcN54fnStXhlFI7vx0bPBb0dmI6/NamSJBF2AQY0geRx/IcdFqNFAJGMkGBl/KJs9KlNiBZiZaA6hPn5AQPpgpH+FWl1SkJqEp+nrN5hVn1P/3E4n+sd5gwbCAbHuCoaCApDr3jXFU5nnkXBcYfXMeMH0dSD8dhgWJuzs0mNuJK7bSdNNi2UfAzv7Np7B4RmniOD1SpT0jLEGPcn
 F9O9bmQx
 9bzJBibMQnnYf25HOFhh96u/zR92zosYUEGWneZpDnISIN9k6DqhcAyYTg++uTbO9f+tJli+BUln4eSmAJc0/91J0ZWHHD9OesEYXSHnD9sYtMFjb+l7qEgF9P75XrFiBFhN66nHrWdUQ3tJAvG09shQhlJb0ghGFrDL9oHHwG/gDcIVcapoMBDrMyEhaH5LYMlNiEylITSC911a37vEWnm18DaI+lVJVlaAY1vCuuhHuPKLI/lSU+Gpyd2ghD/L0j25KJ0UUAoHv8pCXq4VWJlhQAiTCPMVKGUO8kVUw3qvqy/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 04:24:37 -0700 Breno Leitao <leitao@debian.org> wrote:

> This shows up in the Meta fleet on ftruncate() of large tmpfs files:
> 
>   INFO: rcu_tasks detected stalls on tasks:
>   00000000752fd185: .. nvcsw: 59455/59455 holdout: 1 idle_cpu: -1/0
>   task:rocksdb:bottom  state:R  running task
>     __folio_split
>     find_get_entry
>     find_get_entries
>     truncate_inode_partial_folio
>     shmem_undo_range
>     shmem_setattr
>     notify_change
>     do_ftruncate
>     __x64_sys_ftruncate
>     do_syscall_64
> 
> shmem_undo_range() walks the whole of the requested range in folio_batch
> sized steps, twice, and its two cond_resched() calls are the only
> reschedule points in that walk.
> 
> cond_resched() is not an RCU-tasks quiescent state.  Use
> cond_resched_tasks_rcu_qs() at both points so the walk reports an
> RCU-tasks quiescent state as it proceeds.

We keep hitting this.  Whyohwhy doesn't cond_resched() imply
cond_resched_tasks_rcu_qs().

> Fixes: 8315f42295d2 ("rcu: Add call_rcu_tasks()")
> Cc: stable@vger.kernel.org

That's 2014.

> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1367,7 +1367,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  		}
>  		folio_batch_remove_exceptionals(&fbatch);
>  		folio_batch_release(&fbatch);
> -		cond_resched();
> +		cond_resched_tasks_rcu_qs();

Won't this change remove the cond_resched() function from old kernels
which really want it?


