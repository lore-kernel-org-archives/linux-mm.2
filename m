Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AF0ACD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 22:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 582326B0005; Wed, 10 Jun 2026 18:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 535AA6B0088; Wed, 10 Jun 2026 18:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449736B008C; Wed, 10 Jun 2026 18:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC936B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:08:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A70BB1646EF
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:08:57 +0000 (UTC)
X-FDA: 84865393914.10.F7B52F4
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf09.hostedemail.com (Postfix) with ESMTP id BC963140005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:08:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zrxb3FL4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781129335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=39aNbmqxEB+y6+1wWTCRLTDBM71LF6M8Aba7hsLG8MY=;
	b=2ELKxXX9lbiCfcFyb3I0vSKve9f4KP0BhwpULJPVKZXOzGF5CUWRLQIAyOI33VtExqaEVJ
	AncWaE+lu4ax8VatbmTDk9AiWnc5eMf56oLjIMmdR8kg/B7B/tz5T0KAQteswKEHDkQwZa
	J6ABZbnX299xe1M02gC0PNHioVRDmz8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zrxb3FL4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781129335;
	b=lMejv9LZGpLHuO7mEYRkr8hwuKm4g/x4IvWiQgorORH+Eqjw4Nf8ks7hiuRGtPsTrMccmu
	xHYNfJ/Xjv63ETbxQD2QI2+gDzO1BvEaIvI2dsuTUOelU8IYWBKIyzfAEzKDw9v2AfHonV
	Q1XhIKibF5AqpJVT5w589q4IGFEpH8o=
Date: Wed, 10 Jun 2026 15:08:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781129332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=39aNbmqxEB+y6+1wWTCRLTDBM71LF6M8Aba7hsLG8MY=;
	b=Zrxb3FL46twEX1WBwuZLWQ779qKrDYvF50ani6DQ3jZEUa98SS7HpjymMNdzrDgJs0vCVv
	sUSKUvySZ9X0TQPgEsKi8YnG3AxD6vM9/mdISGXx46PAa6t7M65d6fWyYNuKNWW8OoSD6I
	+EuusAiK6LesCg9NtECCznFgLn4HYOg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, 
	hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	roman.gushchin@linux.dev, qi.zheng@linux.dev
Subject: Re: [zswap?] BUG: sleeping function called from invalid context at
 kernel/cgroup/rstat.c:421
Message-ID: <ainb3W_-i5ish_K6@linux.dev>
References: <c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev>
 <CAKEwX=Me_WHU-oVF=rab7-5e=QTaYQJj0adi7xjejm-MyoDxyA@mail.gmail.com>
 <aimbPCBloe0Dqk7t@linux.dev>
 <CAKEwX=PyHr+9wiuohixv4PHEtyvt8uD2j45JGQdN8dzn7UgkXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=PyHr+9wiuohixv4PHEtyvt8uD2j45JGQdN8dzn7UgkXA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BC963140005
X-Stat-Signature: t86n486s5duhi1uo61p5sun4u16qwft5
X-Rspam-User: 
X-HE-Tag: 1781129334-603374
X-HE-Meta: U2FsdGVkX19zCl4Qwq2T44WC/TXCCX2mSg8KNXCwGr3AgFKLYpmYn9AuoZoX7eMnFqVQTyTKd6LPa0so38oNdR7Bw+baPWfn08GtN/35KFuieUS5GIzl08K8BUXg3lcyOWzyr/qN5GOl5TGObqv7kLka/F0pyJKpSWOHgvZyvSGOlJqxoCPpDnRicz0K0l6BjuZQx3e1Y47YwfPBw7Jeh6isETJ97wca/RMgr5jggT3KXgYOfrwHsKj1IKCHN9zn0+iGYj7gnMnEySp/aj6l9J3E+sFmcEx8LIOZPV3TplUZGUw6gu87Pgs3r30bdVBBmi5XuNGooV9YFXv/g+atetokGIe+USmTLo/wFWQ7uPK2XjSjZkDNpHtlDH0j+jpEK0xy/0JzmrgDoS9adujFQKaNtx5XAau42rowkXg8uaj5CexQf/ZAslgoHAbIu8/puhDVbTzXmyWQ1ZQoeluXD4xSMb5W2MLuPv7pX94MqPD5ebDHpzmltx5yCN19xspJMlt0UNIsOsLPd3zlu372f6/pf0+orf3asNf/Dse8tmYMIZGogqYL1Pj5uwl/dPYieYwEJScM2kfThcki0G4mcUBBFJ0SU0vxawz7JMhebZ8idTm7A4X0op1Qyy6Orb4HqVntZ8n6MC30CK335WOJhru4YudBAnpo0HZ6pBeV6lc15ZERf/boirAZUa2tMPh08xGs0ByKi7ChvlUEwUsdeqPOQ4SEAP8I2xDZzQx1xEfQ0nelwLOLQ7tpvrWyBw8QcZXiWS9vH+M8GBdVKk2/lqVRCnb1nFXRfbUW/Epr5rh8OtKq2BNElFq6l4VThMD45N5MzeIUC5tyYaKxahSvG3tAraYBpGygFci7RmB1bur2h0U3oJR00lFjM83DmGcsaBSUSgqyANnjhfe1Ayn06JhjiYz50g/56nlCWDfXovWCi7ALL+hj0nphWLpHhjbWWAUeEgm01Vb/aVwV2tt
 CnS0GyoG
 VdCOmrm8ZWnMDzyP8nEL3PVuVbMfi2VJqjnxVfA2Lkoe7hySLO1XhHN0QTQUIAx4upS2aOmYQsCWnTKwW968Z5TPw1iiv1RnG7EFKgw7KjNUKWmJXrA707o0BqAmWDvlDtVYr8ykHMfqlzaZlyz3ZYAdmjfywVYmFskT0NWTpkF4CoTcPUySnYUzHqlMJznqsfUHMfv/POdcCFwlG7a8nMbbxMN0J+CXruGIi1A167FYeS21Mk6Kg8yv9wbmiovX61gx0QJ3DO2zZ+sEFPff4P0N8Rh7HBGlZ8vsybVHCmPUdK+K7BRIkyWDTpZv9JpBRQBJ2J3uIs2WiYvnT/E2f3p6Dfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 11:38:29AM -0700, Nhat Pham wrote:
> On Wed, Jun 10, 2026 at 10:31 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > +Roman, Qi
> >
> > On Wed, Jun 10, 2026 at 09:38:03AM -0700, Nhat Pham wrote:
> > > On Wed, Jun 10, 2026 at 9:05 AM Zenghui Yu <zenghui.yu@linux.dev> wrote:
> > >
> > > Thanks for reporting, Zenghui.
> > >
> > >
> > > >
> > > > Hi all,
> > > >
> > > > The following splat was triggered on the mainline kernel:
> > > >
> > > >  BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
> > > >  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1126, name: cat
> > > >  preempt_count: 0, expected: 0
> > > >  RCU nest depth: 1, expected: 0
> > > >  CPU: 7 UID: 0 PID: 1126 Comm: cat Kdump: loaded Not tainted 7.1.0-rc7-00056-gacb7500801e9-dirty #304 PREEMPT
> > > >  Hardware name: QEMU QEMU Virtual Machine, BIOS edk2-stable202408-prebuilt.qemu.org 08/13/2024
> > > >  Call trace:
> > > >   show_stack+0x18/0x24 (C)
> > > >   dump_stack_lvl+0x78/0x90
> > > >   dump_stack+0x18/0x24
> > > >   __might_resched+0x114/0x170
> > > >   __might_sleep+0x48/0x98
> > > >   css_rstat_flush+0x54/0x564
> > > >   mem_cgroup_flush_stats+0x9c/0xb0
> > > >   zswap_shrinker_count+0xe4/0x1e4
> > > >   shrinker_debugfs_count_show+0xd8/0x268
> > >
> > > Ah, this seems a bit tricky.
> > >
> > > Seems like shrinker_debugfs_count_show() is invoking
> > > zswap_shrinker_count() in rcu_read_section(). zswap_shrinker_count()
> > > triggers a stats flushing, which might sleep. Not ideal.
> > >
> > > Is the rcu_read_section() here to protect memcg or shrinker? For
> > > memcg, i dont think it's necessary, no? mem_cgroup_iter() pins the
> > > memcg before returning.
> > >
> > > (memcg maintainers please fact check me).
> >
> > mem_cgroup_iter() handles the lifetime of memcg, so there is no need for rcu
> > read section for memcg.
> >
> > >
> > > If this is for the shrinker think this needs to follow shrink_slab()'s pattern.:
> > >
> > > rcu_read_lock();
> > > list_for_each_entry_rcu(shrinker, &shrinker_list, list)
> > > {
> > >     if (!shrinker_try_get(shrinker))
> > >         continue;
> > >     rcu_read_unlock();
> > > }
> > >
> > > But OTOH, doesn't seem like rcu_read_section() is what keeping it safe:
> >
> > Shouldn't the caller already holds the reference to the shrinker which it is
> > giving to this function? Does debugfs file entry holds a reference to the
> > shrinker which it is giving.
> >
> > After looking at shrinker_free(), it has call_rcu(&shrinker->rcu,
> > shrinker_free_rcu_cb), so this rcu read section is against that.
> >
> > I think we can simply use shrinker_try_get() here as Nhat said.
> 
> Hmm, so is this unsafe even with the current rcu shennanigans? What's
> stopping shrinker to be freed by that callback before we enter
> rcu_read_section()?
> 
> Seems like this is just implicitly correct - shrinker_debugfs_detach()
> and shrinker_debugfs_remove() happens before call_rcu(&shrinker->rcu,
> shrinker_free_rcu_cb);, so if you're reading this file, then it's
> before shrinker_free_rcu_cb() is even registered?
> 
> Do we still need rcu or shrinker_try_get() here?

I think you are right that we don't need rcu or shrinker_try_get() but it is
more about an active debugfs file reader. Suppose we are sleeping within rstat
flush from shrinker_debugfs_count_show() and there is a parallel
shrinker_debugfs_remove() call.

shrinker_debugfs_remove calls debugfs_remove_recursive and deep in the stack
there is a call wait_for_completion(&fsd->active_users_drained) which will wait
for active users, one of which is sleeping within rstat flush.

So, let's simply remove rcu read here.

> 

