Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF02CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 17:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EF9E6B0005; Wed, 10 Jun 2026 13:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0EB6B0088; Wed, 10 Jun 2026 13:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6666B008C; Wed, 10 Jun 2026 13:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3606B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:31:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE67F163E73
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 17:31:36 +0000 (UTC)
X-FDA: 84864694992.08.4CC9ADD
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf02.hostedemail.com (Postfix) with ESMTP id 000688001B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 17:31:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jikk91+B;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781112695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5f3Z+IGGTCqjDtkePqAPZxEHUMLLCQIFZBtebBF2GeM=;
	b=TM/QBHcsNAeCZkXsvy6T5DvJNU9a45lGl94mAuTwsYjddRkdCyP7vKOWlPoaPzlDAHlWt6
	DsUAIfHp0ZkeagOGFX0eGrC3ZQrIVl9WjfrbRrQFNuq/5+0X+0sQX5r0oOfJaEFL6876xJ
	DW65JObydx9VFmRuBuCTEPGcMJ4drlc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jikk91+B;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781112695;
	b=Vx6Jb3ul/AtQBqmxpbiec9nh4syY01Hrn6Tn8xr/4PowO9ad2+51ZScW0WYJ5aAQMfeYHn
	yUbnOFCFEap7AsdH+t/BQomS7d9Bki0ILDKo5+w/9Q4JCOF284V57RYpK+GXZlthCucrAm
	XcqWkL3271uoFxVNplceLZxl1qFN14s=
Date: Wed, 10 Jun 2026 10:31:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781112689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5f3Z+IGGTCqjDtkePqAPZxEHUMLLCQIFZBtebBF2GeM=;
	b=jikk91+BRMbtGjMsItO2oRN42Dz7Jv/0OoG4ZEwtG9E9sJjvl8kgwv/ZFCKuUSwYl9dsVz
	wa3fSexRskmV2IHHLr4DPiJWXNrXDyMi8E1KmeAUS80key7M2ylU2VjkFh9pWPf2Lwi3/a
	3DjO0S4aMlprIEY3sGzK4T9cNEDKazY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, 
	hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	roman.gushchin@linux.dev, qi.zheng@linux.dev
Subject: Re: [zswap?] BUG: sleeping function called from invalid context at
 kernel/cgroup/rstat.c:421
Message-ID: <aimbPCBloe0Dqk7t@linux.dev>
References: <c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev>
 <CAKEwX=Me_WHU-oVF=rab7-5e=QTaYQJj0adi7xjejm-MyoDxyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=Me_WHU-oVF=rab7-5e=QTaYQJj0adi7xjejm-MyoDxyA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 000688001B
X-Stat-Signature: fc5scd587k33ep6g5y5ugswa1dx9d6we
X-HE-Tag: 1781112692-347985
X-HE-Meta: U2FsdGVkX1/BrjRtly1ZHNQ76VH8z53n6i9jb0XxZeQpP+is6GHxKQE5RF5oYDy6IopIqgOdDMV5XqMTC0lRFrsNd+L+35qdFFZTrqnMLEN0eEGGE7wlzUZZVK/9X5Qk1VWu3+QANNpzGwyhQDSmg/jM8+e6vPuFTqxgERpOlLlTSe4I4uNxT8TXzoawx3zQu7Dpa1VWkQ/WJuOJTJ5fAx5ZEGfR5cYHMBYOQFD/chW+LNdTHk6ngNA4qFScMD7Tm4IHO0oRxQIRSM7le6pXdd8F0aFF9SsDu1B84MnVj51rvtOmNzRziV03+ec7xZTIjZBn4ujyXcILSUl/NfYI5uma/WtoddYOynp6kBwaCfz49/UV9ZoFfeHgM3FQfCDSL4SSIigZljBp1s84iaJhSsh8tB9SAQmyw/4HjAyMkWrOMe8RCTLqWqRTYL5SGW9FbS9GBpoxWr9s/8PHePSF/7TOktyJQVRkAZ+p0s1l1paEv3vuRs4TRsOQGN4RHT3XVFFTPGnKjZXaojBwnmW2YbZ+5ZFcdF3NqCpwgLsaG5evSKsJyzuNK4VNVB9hLKsQ/MbNtgUVPzQF/7bPkgIXHgWG+uBPlMln7mrj6nsu5PneAfZNfy9QpSDhOpU+F3VHqpjXTiBq1yGlt28uNfaECclNVGsB/t2bozTmEyt+sDlPafUe5APrCK4QUJLoZrs8YuZW/R9sQQ9nAgz34k8ySH72A7wBAj7C1acE6zREYr0UlfRCHLuT3M5MRfXA/MeRyYeT4FUmHSHl4E0cuWp9EgIDZVRB+EoEKKUKwsGc9pW+UPvJVgFnhUkoeo9iuJ1ploVxe45xndiFdQrlXHGrLsIoj5p61gPLObynLzDCPJXrv3F6HnxMAcc+BbXktRJ/ZYgMcXXSiI6no2Qg/IGhu+oz8Ad74Ob1kWcq8Trrim87QB61Ht+N7zCzASO3AYGOuau6vY+VLEf169J6yKZ
 M85IqAy5
 bBBiSrFYdM/bWdvcMCNSdnoTP+f7oBV0f2tsLpibH0Q1MH8nv505sF4Ttf719/R3aArGdKkYsroYOnFebTz8gxlGQySXAETOdQAF0lurLeMBaHTIm2pUJf3fu28j5/uVQ7sLky9EKLwlyWiiRiUiTWkJX/oA3O+C/sck1X9J7v6S9F+plR+EUaLgDCFTNXN/frPxEKhwPpD8EOgTov1up6o0oiBFl7ypImp+FpaSwU3E+TX1AW7mQbUXXf7rOXbCJoDe0Conn3FQgayR/jIi0OL5pEyzX7bc0+b90mxwdlrQALL5TMk5Nq4SyMgQNnG1m9Sxd8R2xkFpWv4UPOOiMNt+I6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Roman, Qi

On Wed, Jun 10, 2026 at 09:38:03AM -0700, Nhat Pham wrote:
> On Wed, Jun 10, 2026 at 9:05 AM Zenghui Yu <zenghui.yu@linux.dev> wrote:
> 
> Thanks for reporting, Zenghui.
> 
> 
> >
> > Hi all,
> >
> > The following splat was triggered on the mainline kernel:
> >
> >  BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
> >  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1126, name: cat
> >  preempt_count: 0, expected: 0
> >  RCU nest depth: 1, expected: 0
> >  CPU: 7 UID: 0 PID: 1126 Comm: cat Kdump: loaded Not tainted 7.1.0-rc7-00056-gacb7500801e9-dirty #304 PREEMPT
> >  Hardware name: QEMU QEMU Virtual Machine, BIOS edk2-stable202408-prebuilt.qemu.org 08/13/2024
> >  Call trace:
> >   show_stack+0x18/0x24 (C)
> >   dump_stack_lvl+0x78/0x90
> >   dump_stack+0x18/0x24
> >   __might_resched+0x114/0x170
> >   __might_sleep+0x48/0x98
> >   css_rstat_flush+0x54/0x564
> >   mem_cgroup_flush_stats+0x9c/0xb0
> >   zswap_shrinker_count+0xe4/0x1e4
> >   shrinker_debugfs_count_show+0xd8/0x268
> 
> Ah, this seems a bit tricky.
> 
> Seems like shrinker_debugfs_count_show() is invoking
> zswap_shrinker_count() in rcu_read_section(). zswap_shrinker_count()
> triggers a stats flushing, which might sleep. Not ideal.
> 
> Is the rcu_read_section() here to protect memcg or shrinker? For
> memcg, i dont think it's necessary, no? mem_cgroup_iter() pins the
> memcg before returning.
> 
> (memcg maintainers please fact check me).

mem_cgroup_iter() handles the lifetime of memcg, so there is no need for rcu
read section for memcg.

> 
> If this is for the shrinker think this needs to follow shrink_slab()'s pattern.:
> 
> rcu_read_lock();
> list_for_each_entry_rcu(shrinker, &shrinker_list, list)
> {
>     if (!shrinker_try_get(shrinker))
>         continue;
>     rcu_read_unlock();
> }
> 
> But OTOH, doesn't seem like rcu_read_section() is what keeping it safe:

Shouldn't the caller already holds the reference to the shrinker which it is
giving to this function? Does debugfs file entry holds a reference to the
shrinker which it is giving.

After looking at shrinker_free(), it has call_rcu(&shrinker->rcu,
shrinker_free_rcu_cb), so this rcu read section is against that.

I think we can simply use shrinker_try_get() here as Nhat said.

> 
> rcu_read_lock();
> memcg_aware = shrinker->flags & SHRINKER_MEMCG_AWARE;
> 
> We get the shrinker reference outside of the rcu_read_section(), and
> just dereference it without any checking inside of the section.
> 
> I think we can just remove the rcu_read_(un)lock() here?
> 
> Long term, I still think we'd be better off getting rid of this stats
> flushing. Seems expensive either way.
> 

