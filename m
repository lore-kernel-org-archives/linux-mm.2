Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B407FF886F
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 02:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6543A6B0088; Thu, 30 Apr 2026 22:43:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DE496B008A; Thu, 30 Apr 2026 22:43:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5DB6B008C; Thu, 30 Apr 2026 22:43:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33D6D6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 22:43:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0929C1F61
	for <linux-mm@kvack.org>; Fri,  1 May 2026 02:43:55 +0000 (UTC)
X-FDA: 84717306030.16.E616841
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9C81540006
	for <linux-mm@kvack.org>; Fri,  1 May 2026 02:43:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VL4OkY1b;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777603434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJy1h7yV9AtdKyhdw89DZ/RBhLX6KgnZgEhjyuieIHA=;
	b=qkfPbagYAAu2v+lqMX8ccoj3ODRqzaIaPmGMipnwGbE8rBqkS7q6d6PYWR1dKsJMXzzb9c
	BFaq2ZzSeh28LOLTNEs8eMPm/jjPeGI5qlXs498hCDsumhSDxn+Gs+Cn4ThawrqC9gkuKD
	H8YwHyDUuumIKdOWkl6cIXWyK1ke9Bs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VL4OkY1b;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777603434; a=rsa-sha256;
	cv=none;
	b=pExUqSwVkwNZrgNuFjFVCO2xqDAT5RNcUaW7hHp+0vvKB3DkuZwL1Xuy+bGh6/cJyKd2VS
	a4C5TH8ZA/mwK7zi8MHdsICFUtAh5fkk/w6aCP2q847SoC2cbRk0lrUaGFaOJi9uMabK2U
	HWGmF9lnWuUmij2S26kaHdFwkGC6lZw=
Date: Fri, 1 May 2026 10:43:40 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777603431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XJy1h7yV9AtdKyhdw89DZ/RBhLX6KgnZgEhjyuieIHA=;
	b=VL4OkY1bPG9rf4PHswU1JPzV0TlhVdk7xr0NCUKMZZifRa+6HiE7ZxIjZ7YPrjUXm0wI3T
	VZS9PcFz40eKE+lYOXg3n4h40HB0Y+hiKIwZR2va9m/XQK2YWyerc8WmFjMHRAW6kFRHdC
	UQi8B46IbspHdDZryGEiEWuBDpm9q5M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: kerayhuang <huangzjsmile@gmail.com>
Cc: bhe@redhat.com, flyingpeng@tencent.com, kasong@tencent.com,
	kerayhuang@tencent.com, albinwyang@tencent.com, linux-mm@kvack.org
Subject: Re: [PATCH] mm/swap: Add cond_resched() in
 swap_reclaim_full_clusters to prevent softlockup
Message-ID: <afQTXPLbNrB3NOqe@MiWiFi-R3L-srv>
References: <aeuOuj5rHa6hgLga@MiWiFi-R3L-srv>
 <20260429124931.452003-1-kerayhuang@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429124931.452003-1-kerayhuang@tencent.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: swfkk6q9s58k8nb4bc1mjgczpuft8gre
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9C81540006
X-Rspam-User: 
X-HE-Tag: 1777603433-271910
X-HE-Meta: U2FsdGVkX1+YptlNPyuAk9oLwmo0yk7No9DYk/jpvrxzofCag0JcLwg6GhdY3XCDYDLciBe1MGYnxEyUtLEMxPIs7xhaIuAtRDOuSx4cGvZRV6FEyUS6q8I6A6mXYt88r4quzaicCAQLbM7AxWWooFvDzWuxBu6cHl4EKTMpxKStzoeqfdak8ulRyPRjXkebk0WqfHRIeP+zSEKaEBU8J/uiQ37FbbW9JJp2wYdpNQkpiOzkL13GLC5a8EqD/gTh5sSUQ+p4Tmd9MHX9FY/aLZd+Yns3p2MrMtQ0MmbFTbBTKfXm13EceBVWqCRJGYoQ9Ex+l8VR1ySmhxvK0F04QVF4E/MsZiVQpHWFIg8w7KODGWgu4n/bamJsX9B6hx3biM+Zb6kSZ6ZZrqiqrZbTQKcnjroEZ8wI3ijnxgr5V+b7vB8ACBX034V0DD24FUQJNMdbYLu6eMXWiPNPVpYlwkvJ2y1kFKoicgNy2O6uGhaUjlJWbgJ9VHidoxjKgbU1SVF4hSzoTQVbptLr5hR9Md2EJ49dIgjness7mnTXH75QV476lGm+PdCiix4PWQhFTT7z5pN5nK7n9YRZ8JAcuzUDwjTF1kHacslEjVJmE6FcUVM7caw7GqXOTQ2DCkSAnuzPrAtTzfVw2CEnwWLwu0S5RHlUvviaBk8JGSKWVtZa3Ie3xudFHptvdcWxZdqpJFF12BxSAZnl0PXHg75TC/dAeHJ91n/EsPTddusbNXbzdtdTdDaXKwxi97Jg0f+zKNtEtlFpRXscIK+wD6QL/HL3+Edh1PJO93bvSLEeqojEpOQ8S8ha6QSk4WnCvkMzSrUSCTKoZf2N+agx8qeg4g8UZrrOoHcPIhvHbjhRALZYkfM/QxnimfZluqm6qOjXZtYB+9kxy1DvRHsX/5HNu1B07U8tX4E966JIRRdnUwElXneD5BL8QZ30EuxgWIRG9uuFcAOHIpUUZ4rYYyF
 r6B5P2Wk
 mtac7KTZFOwQWuUOUYAljCxnZPOyzzDmGOHFrRBs3uw54Vx2FGxYY/sDkeQGUPJXpTCf8KY8py9K3F9CwTaP43uU1WCZ8RV8ObWvMOz1W/yvTRbCFWINhzzZKH2FPwOCpc0SRx30MIqnm9zGBOIuizXIqlHSeqA14IOsYjzVXuVQhrVF272o2jTxmyTXJpct4FTtPQL/sCt61ssH6jAPCTnEl2Ti5jYJFodoheKM52KBj49yaE8vMinVgJ1ZVJPj5XgAbnyLq9Bxqa11WOnbimmVaVfGHqr1G+c3Q0e/vc5RBrAVQwhxTIe3X/e3mtc8aPrML
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/29/26 at 08:49pm, kerayhuang wrote:
> Hi Baoquan,
> Thanks for the review!
> > Hi Keray,
> > 
> > On 04/24/26 at 08:37pm, kerayhuang wrote:
> > > Add periodic cond_resched() calls during large full_clusters
> > > reclaim operations to prevent softlockup issues.
> > > 
> > > Signed-off-by: kerayhuang <kerayhuang@tencent.com>
> > > Reviewed-by: Kairui Song <kasong@tencent.com>
> > > Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> > > ---
> > >  mm/swapfile.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > 
> > Thanks for the patch. The change looks good to me, however there are
> > still small concerns.
> > 
> > For patch log, it might be better to provide more details, e.g did you
> > observe this issue in a product environment, or just a code exploring?
> > If observed in a product environment, what does the backtrace look like 
> > when softlockup happened?
> 
> We hit a real softlockup in an internal stress test environment. 
> The workload was LTP memory/swap stress on a large arm64 machine, 
> with 320 CPUs, about 1TB memory and an 8.6GB swap device. 
> The system was under heavy load and the swap device had a large 
> number of full clusters. The softlockup was triggered during 
> a stress test after about 3 days.
> 
> The backtrace looks like:
> 
>   PID: 3817773  TASK: ffff0883bb28b780  CPU: 48   COMMAND: "kworker/48:7"
>    #0 [ffff800080183d10] __crash_kexec at ffffa4c1361e5de4
>    #1 [ffff800080183d90] panic at ffffa4c1360d5e9c
>    #2 [ffff800080183e20] watchdog_timer_fn at ffffa4c136231fa8
>    ...
>   #16 [ffff8000c4ad3cb0] swap_cache_del_folio at ffffa4c1363e1614
>   #17 [ffff8000c4ad3ce0] __try_to_reclaim_swap at ffffa4c1363e4bfc
>   #18 [ffff8000c4ad3d40] swap_reclaim_full_clusters at ffffa4c1363e5474
>   #19 [ffff8000c4ad3da0] swap_reclaim_work at ffffa4c1363e550c
>   #20 [ffff8000c4ad3dc0] process_one_work at ffffa4c136102edc
>   #21 [ffff8000c4ad3e10] worker_thread at ffffa4c136103398
>   #22 [ffff8000c4ad3e70] kthread at ffffa4c13610d95c
> 
> From the vmcore analysis, swap_reclaim_work() called
> swap_reclaim_full_clusters() with force=true, which sets to_scan to 1551 clusters.
> At the time of the softlockup, there were still 1427 full clusters remaining in the
> full_clusters list.
> 
> I will add these details to the commit log in v2.

Sounds like a very great root cause digging. Adding these into patch log
will be very helpful.

By the way, is it worth a Fixes tag?

> 
> > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > index 9174f1eeffb0..74a1e324449d 100644
> > > --- a/mm/swapfile.c
> > > +++ b/mm/swapfile.c
> > > @@ -1054,6 +1054,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
> > >  		swap_cluster_unlock(ci);
> > >  		if (to_scan <= 0)
> > >  			break;
> > > +		cond_resched();
> > 
> > Besides, is it a little bit too aggressive to call cond_resched() for
> > each cluster reclaiming compared with the old code? Do you consider to
> > make it gentle, e.g calling cond_resched() every several clusters, 8, 16
> > or other number decided based on your testing performance statistics.
> 
> I think calling cond_resched() per cluster is reasonable
> here because:
> 
> 1) Each cluster iteration already involves scanning up to 512 slots,
>    and each slot reclaim may call __try_to_reclaim_swap() which does
>    non-trivial work (lock/unlock, folio lookup, swap cache deletion,
>    and potentially slab freeing). So the work per cluster is already
>    substantial.
> 
> 2) cond_resched() is a lightweight check - it only actually reschedules 
>    when need_resched() is set, so in the common case it's just a flag
>    check with negligible overhead. Therefore calling it once per cluster
>    gives a bounded latency without forcing an actual context switch every 
>    time. If we call it only every 8 or 16 clusters, the worst-case 
>    non-preemptible window can still become quite large on machines with 
>    many full clusters.
> 
> 2) This is a workqueue context (swap_reclaim_work), not a hot fast
>    path, so the slight overhead is acceptable.

OK, that sounds good. Just when system is under heavy stress, it could
yield after each cluster reclaiming. Imagine a system with a bigger swap
disk, it will alwasy need to check if swap is 50% full and if it's in
workqueue. Anyway, maybe I am overthinking. The overrall looks very
great to me, good catch, good root cause digging and good fix. Let's see
if other people have any concern.

Thanks
Baoquan

