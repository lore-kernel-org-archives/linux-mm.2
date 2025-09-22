Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E17DCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 23:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 262908E000B; Mon, 22 Sep 2025 19:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213608E0001; Mon, 22 Sep 2025 19:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14FD48E000B; Mon, 22 Sep 2025 19:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 04FF88E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 19:03:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9A91A85958
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:03:12 +0000 (UTC)
X-FDA: 83918413824.20.81C311F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E7BE11C0014
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:03:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pTMVo+nj;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758582191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VPhxa5fthXREUZ9Vd9xxu+8yvzM/ynvX6sKUWU7rs9g=;
	b=HVKDVVuqy2DEYLqvJoRYZX7Z5IO7ARe6JHshToJcAC7wHqhmFHqasdaBhTVoQdb8C2EVSQ
	CAVfo4US/mnXTsm7fLnGsMYIEJ2uaWDi49kO6q3gu6+xFKlYaSNSYzz32T2cCJ0v1Ckrh8
	vNRrG4mhDYPVr67WEbOArZGJAJUsWDM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758582191; a=rsa-sha256;
	cv=none;
	b=Tg/maCZ4FqCbUZP1AGzsV73i0kP2WzOIuIVVFsV65T1/ff4pMDGLTBd0iDkOw/J83X9E1d
	40PaJ5YNRVRrkLaLXtM/wdX+NVMgizAiXwyLttHaEuG+ggpnYgSuojMhtwLpAbWw2djyhg
	2wIVoyg0FFqonYdkAQCDw9ZDz6MWog8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pTMVo+nj;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D65D46025C;
	Mon, 22 Sep 2025 23:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63BFC4CEF0;
	Mon, 22 Sep 2025 23:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758582189;
	bh=Ga3iCtdjN8K221Qg5mW5H1wWCF8VcrbTHNLCYL827Tg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pTMVo+nj7csww0q3/7UDygDGBnLo3Te9cgJKYwUtiPgeHpi4Cwdke/MPEfT9PnXLX
	 DXeGEdvIfwsnOf+3RoWJNjmYPfdUYmGAVQd6LMP8N0/qkM1IOGHaiWl/Sl0aHaTn82
	 E4k7BPsCffyuL2niZV8EMfcE27uUOPkaH9zmFSAw=
Date: Mon, 22 Sep 2025 16:03:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal
 Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
 Peilin Ye <yepeilin@google.com>, Kumar Kartikeya Dwivedi
 <memxor@gmail.com>, bpf@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Meta kernel team
 <kernel-team@meta.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] memcg: skip cgroup_file_notify if spinning is not
 allowed
Message-Id: <20250922160308.524be6ba4d418886095ab223@linux-foundation.org>
In-Reply-To: <20250922220203.261714-1-shakeel.butt@linux.dev>
References: <20250922220203.261714-1-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E7BE11C0014
X-Stat-Signature: ydnpf36xizxze91iwkoicjxdct64j8hg
X-Rspam-User: 
X-HE-Tag: 1758582190-575248
X-HE-Meta: U2FsdGVkX182ojiOYK7/roQp3QnPan7scTJ8ibPo57ry0sPNYtq5kSqZyHWN7oDlNQaBLJErgqoN+xyNqup2MYtKB4HIVPoHtvZKRyYAE9h/ijO/B7xrx78Yoiu7YGyE193dctvK583oCfGPdxUmM17K0GOv2Du8b/JiVQuRuRyllsDbrhwT8+P9mUSZaJ8IC+TvGeP71T5zFFbsctrdzgkFl+nUIUoM93GJWcFcd5B05AyZafONBL5TuSQeb227NDmkpeXW/Rg20Y72oAGuIS9RHW47DCDp8qOYytkeggPH01QKJW1Ttb1LlLw/PihsMRZHIEvPiDr8FeDf78yX6FM2mIk8zIIYUUm+euJWqf6tRKcV5+zgPbbttFIJgJdI5PtSg1DY5hw7hsxHTyq0bzxCRamA7SCAIinHAGFVU6Uq0gXXOp4wO+Xqq7rfjci/6tL5dSHdbpi7Gw8aYbZeMgWw5NffO63FbIWmLZHyNleu/wR4cH0Z2gdUKhIR45vHfV8bMc2JpLZ8c8dzGgDwwmIXS8h/k93EXi0CJrtF8LyHuy7qAk7jmYVcMZQ4x+VNG2DqDYwtFAP54Z2VFIUxEPGsZFW8i7ACvoYcwqEkMGAWXxeZ/4/Ds9IEen9teecdF26A4c8qYvIV13GmZEBPf/v4ngeJgQ2GQ+iBo6IIc1McOl9Djh/FRfB2tvzzLVUGRM4KplflWnyItPSQh0mfq+lQl/FkYCmZy22YNgbqqmakjMPMRMaef8V/yI/eLX2EaaDP4oKvgnemkl2zElLbQkYV0+d1ZyjxFti0Pxq3dcszF+lR4LO5wHclG51Q+1SgqUltyyDEmlZrXzxASg0bLcjzeqtwZgXlF56TttEQZEi8Vjfqq3HJbv7lfd02MnlYJLLGnC4gdhI63uGcg/HNjpjBEVLib6npBR/j/B2/SGMtxrpsCFFmjIfYgkjYm33/XREpsyFfDlF9VP8ntyC
 YbxgoYn3
 l8zUX15lTr33RcImQXXYCbot0df12wP+uY3iQZ/qIoHLc7Lehq/XhtjePhHQ9DAGSJyUP0R9VQwsSREpLWtZr2rJ2eVlF0ufSt8xGEmKPGEusHG4RuglygIruPWaK+Jo2g1q/yyHMsO33I6tKXaSzShMDzMycWyd1OVRb9GIlfjPBSWorgRWrcDfnqn+DVFrILVBApnb3jEIdHjss/7eyoSGwQ9INfDFTLbBqQFoc8Z++rOb/IwbBSRyOqZiwgk8DBbq2KYrPDI2QA5hnp8+hv6WSz2m2j1UTf6btj8BbXPtZZJc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Sep 2025 15:02:03 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> Generally memcg charging is allowed from all the contexts including NMI
> where even spinning on spinlock can cause locking issues. However one
> call chain was missed during the addition of memcg charging from any
> context support. That is try_charge_memcg() -> memcg_memory_event() ->
> cgroup_file_notify().
> 
> The possible function call tree under cgroup_file_notify() can acquire
> many different spin locks in spinning mode. Some of them are
> cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
> just skip cgroup_file_notify() from memcg charging if the context does
> not allow spinning.
> 
> Alternative approach was also explored where instead of skipping
> cgroup_file_notify(), we defer the memcg event processing to irq_work
> [1]. However it adds complexity and it was decided to keep things simple
> until we need more memcg events with !allow_spinning requirement.

What are the downsides here?  Inaccurate charging obviously, but how
might this affect users?

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2307,12 +2307,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	bool drained = false;
>  	bool raised_max_event = false;
>  	unsigned long pflags;
> +	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
>  

Does this affect only the problematic call chain which you have
identified, or might other callers be undesirably affected?

