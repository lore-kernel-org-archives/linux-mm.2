Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CACFC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 06:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C0566B00AA; Tue,  1 Sep 2026 02:22:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8713E6B00AB; Tue,  1 Sep 2026 02:22:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7604F6B00AC; Tue,  1 Sep 2026 02:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD886B00AA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:22:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CFE6CA023D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:22:18 +0000 (UTC)
X-FDA: 85164198756.07.5CE4864
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 35EE41C0005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:22:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tRJQnl6J;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788243736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVEo3DRGGCSdCvn8moEHUtteQuA8cdjiwaf12LKHABY=;
	b=XzvEu7VNRADXvmrWjE4nEuo0pDPhgl964SXuHKILwr+GozScH/Y1dAu6b/Z+WmfDnvlzo8
	/PtwXx8LcBGfdIUApiTdjsbrowxBoYJrL//GPVJ0JW2gQQnW7co/xp/2TyIaMhTrD7o4SN
	Gvi8OkknF7xV9sqpd1oyradZHb205UI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788243736;
	b=JwmvniEhcsyXNpEdInUw3ZMwLPeZE5ICvt7pEfD/SVZGaYu76zpQDr5hxV6eW5U1oAt4lp
	0p1npQxG+Ejhubayk+OPUsuo2dydCaRwPRlJbXbgiuhzdXTYD/MRPLHpwvEHJS9yBLUwdt
	/ETHuorPzw9pnuNi+fdtnj0zazRehFY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tRJQnl6J;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D0151756;
	Mon, 31 Aug 2026 23:22:11 -0700 (PDT)
Received: from [10.164.19.53] (unknown [10.164.19.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B0E1D3F85F;
	Mon, 31 Aug 2026 23:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788243735; bh=bRwEjPB8J1SjKC3oPG9e9HzL/U1SyH/SEHquXWa+ZBo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tRJQnl6JSh2o7IqeJ2FWMR9/vm89y7lkqOowGY30fN7wWGWyNd7EbfWGSKAMI21XF
	 eaXX+Y50GLxB3qa7dL66KFS6W2PlaH7q0E6sHhNpPR8RIJwisDDptjJb4XyVudCQHk
	 +JZRRhN+w34Ljsi5l6j5jjepxFiuEqtZq5EYtHGQ=
Message-ID: <54bd749f-04f5-4665-bd5f-d485e7197132@arm.com>
Date: Tue, 1 Sep 2026 11:52:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: vmalloc: fix vmap_purge_lock livelock under memory
 pressure
To: Uladzislau Rezki <urezki@gmail.com>, Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260828091753.299295-1-ye.liu@linux.dev>
 <20260828110503.e1eff32a9b7df9a8b2ddd4d6@linux-foundation.org>
 <bec5eaef-d084-467f-9bfd-43f7dedc1aa7@arm.com> <apVPTt9Xw8kSgmTU@milan>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <apVPTt9Xw8kSgmTU@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 35EE41C0005
X-Stat-Signature: 1ieimb9xhcqqstwtjugcde6ishy98wgi
X-HE-Tag: 1788243736-722593
X-HE-Meta: U2FsdGVkX191AG0m5168mf6PO4Ct8qX+JndTYMenetZ4+T4UMC7qIVLKzX/xSCMw9w0EAJx1vypvPEIN2uckxiXFXUskqL/SFHab1ub7ygxw9xq/PxVgQUsDmWJnodCZQwQurfjqL6rP4Xaeyl1B0sin5AWPAhhRCpdXXLIIvFcqiwT8ktJc2kVvn9V69giU2J8Ac2o/yPK5wosFedd/TTFXxanV1bVMY9Ucc1yR4aHkPZeh0blBfbnyjzY5SUwh3jdkB7C+qC2OpCxy00s67yDhtybv/NIGAL7PjPaltNnyGAQ9CyQmF1hcFJEsUs55ErROsjtnyHfl/wXImXZnNZgtm64CbnRQMdGstzif4O9jjn6HizH0jHRlH19HSiocgEGrwdinMhvpdhp57pMbPR9tP48+Lk7Xdb42s7rajuSYKWhBNlohbs0CCIWxGnH+ovl7EysZyla8BlED9hDwhqkHXmKkdboWpBUJD++ax8B/rmZI5Jkio4eJm4TR1wizSsTRBRYeVCw/SD/Aw3k69jfXlloPefREl/Wi3/YYPQY9/xTvzTyPoZOPUIC6Ri5T+qYsc9oivFbORc8KL+b8HL5YrdfoRWF0Kzj0phMirP1AjIKUU6xXx2opnI+op5y4b+aCkhPTkqVWiSI42VHXJ0c0Eq3dcwD4dEo4c71F4Z7Wx3ooBNQI92eHdOOClwL9X6jjYA4kI8m2JCx5VMoYe/+JvvU3xtHSBoJ4TnnbJMd5th1L7F0YvDzpH1EqgofZqw/CCJ4kmWUqAyhFHKlwxJfjTycLGjmq3JjlWJKJduY0rcjYjo4CmbNe+P/nBbZbVc6rQ0ogfz5cWlKtYlXgL+gRmiv+iSydZP0Y6jpnyOpfgFtc+fQcvczZjjsa6cNYi5MRiquFBz6kN9D1dtVWl+0REpd0s/eJSQRQigTVL61CRvcrTiiR9joaQ4pCdpDC29QDH9X/a07wHZvzCrO
 Z2ePsfFD
 W1MLM9relsDk9z4MUqn5hRGojZ+ohsInpRz/yEEPz0RyZle4NVTj/VCFiGucBr72l0+h3Dt6z+b5MAIZFVnCDMBzui/ZuXvtYSLlSLsxvGinecTXqBEJWrci2eU0+K5PzqLRPWLW0zG+7TT8lCw4+6601q7lHEB58IYpbV0nSYkbLHMdZly/5i0lJZKkXrSGeM0Ny3ohd1I8GXeAKh7doBhQhr/GS/0HVpHDKzxTsrr5tryCuhOzDuXkAyKy2va5pcasAlRVvfXqzG1VjO9Ej5DY64OP0UwevbCTmDMihID3IhmzFFYuSJn2RkbUaKanBCUGvcuykX+scnGqLwSJVIxMcDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 31/08/26 3:24 pm, Uladzislau Rezki wrote:
> On Mon, Aug 31, 2026 at 11:39:14AM +0530, Dev Jain wrote:
>>
>>
>> On 28/08/26 11:35 pm, Andrew Morton wrote:
>>> On Fri, 28 Aug 2026 17:17:53 +0800 Ye Liu <ye.liu@linux.dev> wrote:
>>>
>>>> From: Ye Liu <liuye@kylinos.cn>
>>>>
>>>> The vmap_purge_lock mutex can be held for an extended period by
>>>> __purge_vmap_area_lazy() which calls flush_work() to wait for
>>>> purge_vmap_node workers while holding the lock.  Under memory
>>>> pressure, those workers may themselves be blocked in direct
>>>> reclaim trying to acquire the same lock via the
>>>> vmap_node_shrink_scan() shrinker callback, creating a circular
>>>> dependency that deadlocks the entire system.
>>>>
>>>> Two places acquire vmap_purge_lock from paths that can be reached
>>>> during direct reclaim:
>>>>
>>>> 1. vmap_node_shrink_scan(): replace blocking guard(mutex) with
>>>>    mutex_trylock().  This is a shrinker that only decays the vmap
>>>>    pool and returns SHRINK_STOP without freeing memory; skipping a
>>>>    decay cycle when the lock is contended is harmless and prevents
>>>>    tasks from piling up on the mutex in the direct reclaim path.
>>>>
>>>> 2. reclaim_and_purge_vmap_areas(): replace mutex_lock() with
>>>>    mutex_trylock().  This is called from the vmalloc allocation
>>>>    overflow path; if trylock fails, another thread is already
>>>>    purging and the allocator's retry will find freed space.  The
>>>>    notifier chain provides a fallback if the retry still fails.
>>>>
>>>> Both trylock failures break the circular dependency: the lock
>>>> holder's flush_work() can complete because workers are no longer
>>>> blocked on vmap_purge_lock in the direct reclaim path.
>>>
>>> Thanks.  AI review expressed a couple of concerns:
>>> 	https://sashiko.dev/#/patchset/20260828091753.299295-1-ye.liu@linux.dev
>>
>>
>> Sounds legit to me. Now there is no guarantee of purge being successful, and we
>> can get a spurious failure.
>>
>> How about using a WQ_RECLAIM workqueue:
>>
>> vmap_purge_wq = alloc_workqueue("vmap_purge",
>> 				WQ_MEM_RECLAIM | WQ_PERCPU, 0);
>>
>> I see the same pattern in __lru_add_drain_all() and kmem_cache_init_late().
>>
> WQ_MEM_RECLAIM makes sense but this is another patch.
> 
> I copied here AI comment:
>>
>> Does replacing this blocking lock with a trylock break synchronization for
>> the callers?
>>
> No it does not. If someone is doing reclaim we do not wait and do not try
> to do it again thus fail allocation.
> 
>> When vmalloc space is exhausted, alloc_vmap_area() calls
>> reclaim_and_purge_vmap_areas() and relies on its blocking behavior to ensure
>> that free space has actually been reclaimed before looping back to retry:
>> mm/vmalloc.c:alloc_vmap_area() {
>>    ...
>> overflow:
>> 	if (!purged) {
>> 		reclaim_and_purge_vmap_areas();
>> 		purged = 1;
>> 		goto retry;
>> 	}
>>    ...
>> }
>> With this patch, if another thread holds vmap_purge_lock, mutex_trylock()
>> fails and the function returns immediately.
>>
> If reclaim is in progress and trylock fails a caller repeats only one
> time to retry an allocation. There is no any infinite loop.
> 
>>
>> The allocator then retries
>> instantly without waiting for the concurrent purge to complete.
>> Because the retry fails and purged is already 1, could this cause the
>> allocation to abort and return a spurious vmalloc allocation failure
>> (-EBUSY or -ENOMEM)?
>>
> vmap space can be fragmented and not avail for 32-bit systems. For
> 64-bit system it is likely impossible.
> 
> But, i think we can overt mutex_lock() into mutex_trylock() just only
> in the:
> 
> static unsigned long
> vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> {
> 	struct vmap_node *vn;
> 
> 	guard(mutex)(&vmap_purge_lock);
> 	for_each_vmap_node(vn)
> 		decay_va_pool_node(vn, true);
> 
> 	return SHRINK_STOP;
> }
> 
> so the reclaim path is not blocked. It should also address an issue
> reported by the Ye Liu <ye.liu@linux.dev>.

IIUC you are suggesting mutex_trylock() only in the shrinker path. But
then, the following is possible no: take purge lock, try to get a
worker thread, worker thread is stuck in vmalloc -> alloc_vmap_area
-> reclaim_and_purge_vmap_areas -> take purge lock?


> 
> --
> Uladzislau Rezki


