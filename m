Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9025E606A339
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 19:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BlcS5iMC
Received: by kanga.kvack.org (Postfix)
	id A8CE56B0AAD; Wed, 25 Nov 2026 14:35:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3D666B0AAF; Wed, 25 Nov 2026 14:35:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9526D6B0AB0; Wed, 25 Nov 2026 14:35:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 714316B0AAD
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:35:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC7C8A8C24
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:35:41 +0000 (UTC)
X-FDA: 85474646082.25.A4DB248
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 20B811A0008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:35:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BlcS5iMC;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795635340;
	b=6ZW5YSa5bXubPW8wao3xHILDlGgJiRPB/O3pT1z2RKSQCO/2G6M1HI/uHy3kVwyM865A4K
	GjRLaKUebaGtlFliifBgNexIl3xC/KBxqAA9oAQq58QVg91MAsbza32Ij45jWHd/XA4Urz
	28GW+XefcFs/lPvKeDzdKGag3RWaDVs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795635340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J16zb1Ctmxjj4viGGPpXWizsVsOTqEcxg8H1/pGkPyA=;
	b=Hg6to8rwMah3PjS74TkbDPqukwKeDHmiYL3k3vrGWQGn7X2topsFWrBuTwRlnkMbLwmtqp
	teDrdnMiSr7kH7caeQDrB7OLIh9IQVsAlQiubLPF70ubsPw2vL1QyW0b8hui+rw8QeB2vm
	tEHMFHGxwIWA2UVSr+d2HoCNWsiRRVg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BlcS5iMC;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A82162173;
	Wed, 25 Nov 2026 19:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EF31F000C6;
	Wed, 25 Nov 2026 19:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795635338;
	bh=J16zb1Ctmxjj4viGGPpXWizsVsOTqEcxg8H1/pGkPyA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BlcS5iMCT7yAwq7lIHqSzzXNh1Mxt2Je8g0hVSPb3wBTiacydjRxAP7iaWWnqIuBO
	 er7Zs8hkKDu7ZFNAGXsQ5Qo1VGv0f4eHqaZKrvQPxzNXbnCcOZe5+rduaAYA1L0y8R
	 JSaKGixXq/zwswHUrguiZGgS/nwsOroDUPhEcu0k=
Date: Wed, 25 Nov 2026 11:35:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Egor Shalashnov <shalasheg@gmail.com>
Cc: linux-mm@kvack.org, dennis@kernel.org, tj@kernel.org, cl@gentwo.org,
 zhengqi.arch@bytedance.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu_ref: make percpu_ref_switch_lock per percpu_ref
Message-Id: <20261125113537.bdb168bfe8962ef1aefc097b@linux-foundation.org>
In-Reply-To: <6c943754-05b5-4017-9145-0d145766909a@gmail.com>
References: <01612865-faa0-4fe5-8184-a177f104843f@gmail.com>
	<6c943754-05b5-4017-9145-0d145766909a@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 20B811A0008
X-Stat-Signature: j69jmi3oibaw7t7bd5e7s4zapu4udef8
X-Rspam-User:
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795635339-926083
X-HE-Meta: U2FsdGVkX18rflpzpiGtjex5tQ80uESU7+/h4sQX4/ehTgOyQrRYBvrFfebrZjl/wBzfeA20bjEap7A4SFvoS0wjILCVBk1K+kJAMx5E49NgG0y/p8lO/43teEfboXcEhXXzcARU8g4AL4hP05ZNCOfSMGXxqIYIxvtuM4sJyNA+V1+ZoaMESn2XHwyuLueBJBA5djRb4CP0vGAlZiOnGHRyEWCkUe2J22duAOkSOTl6HcvnAeCbByo05GYms4QaMaZnlFGvxv58wcdRITf+alJLhEOqVZMR3S6jLwRdG8DsgCpG1U0LOLbnWKgh90SIeKs/Hvr3COZlXyqaztcj0vovL1S+3SUGnSon1OvS9Aw3HCyl7x+fBbX4x3zUq0b25kpsJYBHPdnJ+Yu1x7f/SwbMCc8nBzfOYEeZX0idWq+8QxNwIYy/PfUWbe9wctGaUrTApTOBnPy79oUfb4jKDECsqIdzJK+9p2x//omVmo11cKWAUv09JNjjyAfMsOyCwCTo6z9XEKAChYB/0EeaUW0MRHY3VLP09wyAz3HSJuhmP6SzOZHa7w9hQ1b8axqYl+Oexr8jGzEXbw8bnD3PRqFPG9WILiaAaeMDVy7YHeQ+Fj6QdrWkH2pcFL4NhQxyg8JvmeHPF9DPfIp2MeLG6XCEXqab38yl8uNT93C+VFWAgU1iDVvZ+FzOGYrY3V9zPzRIZsMmLsF6iCAiZsZMvTgpHlAyWmQ2YyYilFipm17uv2HNEiMBy5XqcT1kRWBnmFLW1XGweYCqYqInu6mvEAVT2wlS4Lev5RnWlFp8dVFGWn5YqFMkvum98feyM31vddpd68TSdWZ+U8f3AtfKQGXeD0HWl35Q/eNtmOcQ0WIlqHgKDlj6ERxPyeM0DT3LzrZnk/Y32xgWKHbe76lkprm923dY+/eF0NOqNemElO7R58DjSx9eGqfYHyfnv+o0Y1+3F29nc115Ac445wC
 N1RipUZ5
 HygJz7nRSUVv4dyCNofycMa0Ev+y23MIQI61lAqgq60d88j90cN3QHblyusxA4qkcAJ19w5o7C49pf7bANVsu1qvxpF4yrMFd1vtqeYUKraaElnuqUP1e4uuHw3gVwUdj4OaYZCvmoE9zvNc9fAkk4w4TeRozpQMMmWR5Yjmb7sEt7F1sR3cBHvMYBbfY/pnSt6hn4ejC1+W8quq12TnViWs434w3Ui+1JISeXefouBLu3MXUqj4YdjiPPQKPstwM3PtPldwxbAJa4KR8Pi9kNK1WltwI4WqoCXzKZd83N6YfwzEToB0UK3c1Uwp/OVwSL3LsC9AQluYI9DX9ci1b1jmMwwGkreG+to91UOVzXH/Sj1ogLoVCh61ZqzmaIzoIAb6bXCMMZw5ePYXEbiGPf6BA6bLy2m/NzEsnm6A5EpMJbGSqCHlVHL8s95sNBnGWO6WVYwA5gD1BCkwzVNYQgTVjEQ4zOQlgFdZH9IhxWTJ6304VnjOxIdL73/xyK80IV5QHDiBq7Rbc4gY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 25 Nov 2026 18:55:55 +0300 Egor Shalashnov <shalasheg@gmail.com> wrote:

> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Currently, percpu_ref uses the global percpu_ref_switch_lock to
> protect the mode switching operation. When multiple percpu_ref
> perform mode switching at the same time, the lock may become a
> performance bottleneck.
> 
> This patch introduces per percpu_ref percpu_ref_switch_lock to
> fixes this situation.
> 
> ...
>
> I would like to revive Qi Zheng's per-reference switch lock patch
> from 2022 as a standalone change.

This is a nice little change - it's a shame it was buried inside in a
larger patchset back in 2022.

> Our workload maintains many independent percpu_ref instances and
> repeatedly performs kill, waits for references to drain, and reinitializes
> them. Multiple CPUs execute these cycles concurrently on different
> instances.
> 
> All these transitions compete for the same global switch lock.
> Reinitialization also clears the per-CPU counters while holding it.
> As the number of concurrent transitions grows, this shared lock
> becomes a significant bottleneck.
> 
> With a module-local adaptation of Qi's per-reference locking change,
> we observed approximately 2.8x to 6.5x lower operation completion times
> in the measured workload. This motivates using a lock per instance
> so that independent transitions can proceed concurrently.

Well, an unpublished module isn't very useful for us.

And an intense microbenchmark isn't as interesting as a real-world
workload.  So can you please provide more details about what "our
workload" is doing and some measurements on how much this patch
improves that workload?

> @@ -109,6 +110,8 @@ struct percpu_ref {
>  	 */
>  	unsigned long		percpu_count_ptr;
>  
> +	spinlock_t percpu_ref_switch_lock;
> +
>  	/*
>  	 * 'percpu_ref' is often embedded into user structure, and only
>  	 * 'percpu_count_ptr' is required in fast path, move other fields
> diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
> index f8d9068..5d46602 100644
> --- a/lib/percpu-refcount.c
> +++ b/lib/percpu-refcount.c
> @@ -36,7 +36,6 @@
>  
>  #define PERCPU_COUNT_BIAS	(1LU << (BITS_PER_LONG - 1))
>  
> -static DEFINE_SPINLOCK(percpu_ref_switch_lock);

lol, yeah, that'll do it!

It does grow percpu_ref by 4 bytes, but LLM estimates that a busy
machine will have 10k-100k of these floating around so not to bad.

And I'm told that this will cause io_ring_ctx's hot fields to spill
into a second cacheline, but that can be fixed up by reordering
io_ring_ctx fields.

Alternatively, this looks like somewhere where a hashed spinlock will
work well.  A static array of 32(?) cacheline_aligned spinlocks, hash
the percpu_ref* onto one of those.  That'll get 90% of the benefit
without growing percpu_ref.


