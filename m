Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4270DCD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 18:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6546B0005; Thu, 11 Jun 2026 14:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 757876B0088; Thu, 11 Jun 2026 14:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66D306B008C; Thu, 11 Jun 2026 14:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 548096B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:34:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E239F1C38D9
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:34:36 +0000 (UTC)
X-FDA: 84868482552.09.BAB4C06
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2562CC0003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:34:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oaEuxGMQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781202875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zR8MQSre2CLLZAd+twHHefU9+W/4bKjSzNIzMHlz7HU=;
	b=mcbgqFN2bpve072xg+3NpOnPqt2SsTSNP4UyYUXjyXkL7i+uf5VuNZwRxGCRfzyHRkW/IW
	TR3LG2zAL0HmyPnrdom0dlK3d7mKyow84LwD8Ex7UmxjJC3lRxTkZ5Iz5xNiniUaT1BJ+x
	YlGhcL5sIGqCTEiQk1xQ54Rt3jlId2M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oaEuxGMQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781202875;
	b=G4aJBbpkvNd2gI02H40kjx7bIxfPLEeK1ka0A7H2zzn6E7v+3LHssjYCF/zTJEfAWOl0P6
	8PjuBdhl+BgXlL0uvWgd+xqAZfUNAqzLOfvvrC4bXu7pq1GAgTez4VGpiBz+RaXnAZ7LXe
	GVtOk8eF8moiPME1RjMVI8P8ASNPecw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781202869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zR8MQSre2CLLZAd+twHHefU9+W/4bKjSzNIzMHlz7HU=;
	b=oaEuxGMQmeP3ubbs7QW/tmE+RMQ58veYE+Q1dlIg6jqFBwn9fQO/fJfSwB3Y0+iGSunpvk
	mvlrtmNlnX1YImA/xHPTX/n5a1iH3k7MT1wvMYZJtop8bJ+GcI/Q3Ccrr6fSLl3NCJw+wj
	oY8rQjUB+tgObORLpgXZyqrRVM1BjFk=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>,  Zenghui Yu <zenghui.yu@linux.dev>,
  linux-mm@kvack.org,  hannes@cmpxchg.org,  yosry@kernel.org,
  chengming.zhou@linux.dev,  qi.zheng@linux.dev
Subject: Re: [zswap?] BUG: sleeping function called from invalid context at
 kernel/cgroup/rstat.c:421
In-Reply-To: <ainb3W_-i5ish_K6@linux.dev> (Shakeel Butt's message of "Wed, 10
	Jun 2026 15:08:48 -0700")
References: <c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev>
	<CAKEwX=Me_WHU-oVF=rab7-5e=QTaYQJj0adi7xjejm-MyoDxyA@mail.gmail.com>
	<aimbPCBloe0Dqk7t@linux.dev>
	<CAKEwX=PyHr+9wiuohixv4PHEtyvt8uD2j45JGQdN8dzn7UgkXA@mail.gmail.com>
	<ainb3W_-i5ish_K6@linux.dev>
Date: Thu, 11 Jun 2026 18:34:15 +0000
Message-ID: <7ia4tsr9lye0.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2562CC0003
X-Stat-Signature: 4igpm7tcxkwxypkdhmp5ddee76q7t4db
X-Rspam-User: 
X-HE-Tag: 1781202873-990824
X-HE-Meta: U2FsdGVkX18FiTH0R1ho1/Xb38VqfxYv0N7JjeKZUEPtnPfo0PePYGHCJUhlTphpUzRYVzQOnSDy5hptMlVZlgkGgYxpMnLpbMml3mOG/rh9pDz9HHR2FgtRxCdsXlGWKwKPE+QV0ef0xOaUuulqnpC1eegav2TmxStblC6a5NTM5nZtNjvI1xgs2xh936FziXpY4+HNH4B5QRJBJggIKIGl27IHWp1HCdKDUHU02difkTgEV6yD9cRVjzeFEwUoQAHZJn63FwxAUKTrlSB0gaxRugiveqMT+SwfXztY+7GZGu78yu7DVusonG0FZLYB+JwW6bUaZ/i5F/rrWQR94qzPAASgaRxFS3KLbZGc15b3y/1SGm2wGXeTC44jFCczxq3g49FqsxwOKhjXsZKXQoyV2dwnL3wvHWM+srsCmplWJm11LPbgtWi9B1Pt+qn/ZmhG9flWpJTRvA6p+B8tn4GItsQgqZgduUeeIzllMRNLXn6Fia0el6jhZmBWhum/rMX6YEWZMS+IzM34jT7axRCXa1TgP34ny9wHNWdj3UAjhCOYYR6x22Ca5ZbqNe/2/bcD/wcAClmlUufkFRu4yU0prDiPOL45Le/YSoXvmgAmoaqSKghwTMRXNqr/N9ITt+RqjiboY+BZ8zeU+Yfp1+dA7LdbWkHdkMU1tkk3Jx5Jgs68FocY1aE78UEnuAgtYXR++7cGlBcpx+95xnMRLZ4r6KWHblIo0xkgAWxss0icMcev4fZ59zT7c7EY5TnCuSrG61AGrg7K26EJqowDOJ4h3WaKwSAOghyoFfRWuUPsVX5+DTW0HLZ4Hdr01EjS3qJX3lWWou8yIkg9dpwgBL6w8qe3VzwiJSHjRzeWDWJtlTXkwG8jIfr+2tOxVeH5ezaH564sdkDQrNAKqCoYUApBGMChJ2gmGwzR6q3jdtUw7+tVxSjnW15p55L7KpvwASXTm2eY1wXE5qJg/G1
 eIw84rl8
 aIedcl4RUkEO3M3OrZLLNzAELMXVFeTXTIL0F7OtASyoK3xkiKg2RqU9YkVpt1fTEgOUlomxtzHhqlFOYe6Ti81NqE+eYKoDiyJjvLyeWIP3QmDCeKBold2QIjnrYzDkoY02+Upb62eesM8eJsl3jFYHpwFflnEOwDWnlHWKJQLlIiemLesVHf/ZCZpdtqtgTrXqo3yWXgLCmOxxZ45afavZqUtVbfqNylM6kuapUoL+yK9kPYnCScgWwSJTytdCTPJjcYC7QlLkDwYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> On Wed, Jun 10, 2026 at 11:38:29AM -0700, Nhat Pham wrote:
>> On Wed, Jun 10, 2026 at 10:31=E2=80=AFAM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
>> >
>> > +Roman, Qi
>> >
>> > On Wed, Jun 10, 2026 at 09:38:03AM -0700, Nhat Pham wrote:
>> > > On Wed, Jun 10, 2026 at 9:05=E2=80=AFAM Zenghui Yu <zenghui.yu@linux=
.dev> wrote:
>> > >
>> > > Thanks for reporting, Zenghui.
>> > >
>> > >
>> > > >
>> > > > Hi all,
>> > > >
>> > > > The following splat was triggered on the mainline kernel:
>> > > >
>> > > >  BUG: sleeping function called from invalid context at kernel/cgro=
up/rstat.c:421
>> > > >  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1126, name=
: cat
>> > > >  preempt_count: 0, expected: 0
>> > > >  RCU nest depth: 1, expected: 0
>> > > >  CPU: 7 UID: 0 PID: 1126 Comm: cat Kdump: loaded Not tainted 7.1.0=
-rc7-00056-gacb7500801e9-dirty #304 PREEMPT
>> > > >  Hardware name: QEMU QEMU Virtual Machine, BIOS edk2-stable202408-=
prebuilt.qemu.org 08/13/2024
>> > > >  Call trace:
>> > > >   show_stack+0x18/0x24 (C)
>> > > >   dump_stack_lvl+0x78/0x90
>> > > >   dump_stack+0x18/0x24
>> > > >   __might_resched+0x114/0x170
>> > > >   __might_sleep+0x48/0x98
>> > > >   css_rstat_flush+0x54/0x564
>> > > >   mem_cgroup_flush_stats+0x9c/0xb0
>> > > >   zswap_shrinker_count+0xe4/0x1e4
>> > > >   shrinker_debugfs_count_show+0xd8/0x268
>> > >
>> > > Ah, this seems a bit tricky.
>> > >
>> > > Seems like shrinker_debugfs_count_show() is invoking
>> > > zswap_shrinker_count() in rcu_read_section(). zswap_shrinker_count()
>> > > triggers a stats flushing, which might sleep. Not ideal.
>> > >
>> > > Is the rcu_read_section() here to protect memcg or shrinker? For
>> > > memcg, i dont think it's necessary, no? mem_cgroup_iter() pins the
>> > > memcg before returning.
>> > >
>> > > (memcg maintainers please fact check me).
>> >
>> > mem_cgroup_iter() handles the lifetime of memcg, so there is no need f=
or rcu
>> > read section for memcg.
>> >
>> > >
>> > > If this is for the shrinker think this needs to follow shrink_slab()=
's pattern.:
>> > >
>> > > rcu_read_lock();
>> > > list_for_each_entry_rcu(shrinker, &shrinker_list, list)
>> > > {
>> > >     if (!shrinker_try_get(shrinker))
>> > >         continue;
>> > >     rcu_read_unlock();
>> > > }
>> > >
>> > > But OTOH, doesn't seem like rcu_read_section() is what keeping it sa=
fe:
>> >
>> > Shouldn't the caller already holds the reference to the shrinker which=
 it is
>> > giving to this function? Does debugfs file entry holds a reference to =
the
>> > shrinker which it is giving.
>> >
>> > After looking at shrinker_free(), it has call_rcu(&shrinker->rcu,
>> > shrinker_free_rcu_cb), so this rcu read section is against that.
>> >
>> > I think we can simply use shrinker_try_get() here as Nhat said.
>>=20
>> Hmm, so is this unsafe even with the current rcu shennanigans? What's
>> stopping shrinker to be freed by that callback before we enter
>> rcu_read_section()?
>>=20
>> Seems like this is just implicitly correct - shrinker_debugfs_detach()
>> and shrinker_debugfs_remove() happens before call_rcu(&shrinker->rcu,
>> shrinker_free_rcu_cb);, so if you're reading this file, then it's
>> before shrinker_free_rcu_cb() is even registered?
>>=20
>> Do we still need rcu or shrinker_try_get() here?
>
> I think you are right that we don't need rcu or shrinker_try_get() but it=
 is
> more about an active debugfs file reader. Suppose we are sleeping within =
rstat
> flush from shrinker_debugfs_count_show() and there is a parallel
> shrinker_debugfs_remove() call.
>
> shrinker_debugfs_remove calls debugfs_remove_recursive and deep in the st=
ack
> there is a call wait_for_completion(&fsd->active_users_drained) which wil=
l wait
> for active users, one of which is sleeping within rstat flush.
>
> So, let's simply remove rcu read here.

+1 to this. How about this version?

--

From a4a018d026c9a39ec15a5b30014e81ce2381e281 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <roman.gushchin@linux.dev>
Date: Thu, 11 Jun 2026 17:40:21 +0000
Subject: [PATCH] mm: shrinkers: remove unnecessary rcu_read_lock()

Zenghui Yu reported a lockdep splat caused by sleeping within a
rcu_read_lock section in shrinker_debugfs_count_show():

 BUG: sleeping function called from invalid context at kernel/cgroup/rstat.=
c:421
 in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1126, name: cat
 preempt_count: 0, expected: 0
 RCU nest depth: 1, expected: 0
 CPU: 7 UID: 0 PID: 1126 Comm: cat Kdump: loaded Not tainted 7.1.0-rc7-0005=
6-gacb7500801e9-dirty #304 PREEMPT
 Hardware name: QEMU QEMU Virtual Machine, BIOS edk2-stable202408-prebuilt.=
qemu.org 08/13/2024
 Call trace:
  show_stack+0x18/0x24 (C)
  dump_stack_lvl+0x78/0x90
  dump_stack+0x18/0x24
  __might_resched+0x114/0x170
  __might_sleep+0x48/0x98
  css_rstat_flush+0x54/0x564
  mem_cgroup_flush_stats+0x9c/0xb0
  zswap_shrinker_count+0xe4/0x1e4
  shrinker_debugfs_count_show+0xd8/0x268
  seq_read_iter+0x1b8/0x4ac
  seq_read+0xe0/0x11c
  full_proxy_read+0x6c/0xa8
  vfs_read+0xc0/0x2fc
  ksys_read+0x68/0xfc
  __arm64_sys_read+0x1c/0x28
  invoke_syscall+0x54/0x110
  el0_svc_common.constprop.0+0x40/0xe0
  do_el0_svc+0x1c/0x28
  el0_svc+0x38/0x128
  el0t_64_sync_handler+0xa0/0xe4
  el0t_64_sync+0x198/0x19c

Fix it by removing the rcu_read_lock()/unlock() entirely.
Indeed: it's not needed here: memcg's are protected by
mem_cgroup_iter() and shrinker by being attached to the debugfs file.

Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Change-Id: Ifa381f7983491cde61354af9b1cb14ca373c1f75
---
 mm/shrinker_debug.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
index affa64437302..cda4e86428c8 100644
--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
@@ -57,8 +57,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m=
, void *v)
 	if (!count_per_node)
 		return -ENOMEM;
=20
-	rcu_read_lock();
-
 	memcg_aware =3D shrinker->flags & SHRINKER_MEMCG_AWARE;
=20
 	memcg =3D mem_cgroup_iter(NULL, NULL, NULL);
@@ -88,8 +86,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m=
, void *v)
 		}
 	} while ((memcg =3D mem_cgroup_iter(NULL, memcg, NULL)) !=3D NULL);
=20
-	rcu_read_unlock();
-
 	kfree(count_per_node);
 	return ret;
 }
--=20
2.54.0.1136.gdb2ca164c4-goog


