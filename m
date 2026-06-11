Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51844CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 18:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C5826B0005; Thu, 11 Jun 2026 14:54:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79CED6B0088; Thu, 11 Jun 2026 14:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DA696B008C; Thu, 11 Jun 2026 14:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5EC656B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:54:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1CA76C280B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:54:38 +0000 (UTC)
X-FDA: 84868533036.02.F72B601
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5693340015
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:54:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NlkBtcSH;
	spf=pass (imf27.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781204076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bTVMqhjCGD00iChQYZ7sxVESMAqPZGe11o/lWoojvhg=;
	b=MKLYGTZfGkluV1u4tw4RCOCqFhhMcclUsLrjePqfTycpBjeAFmGXs9P8AWhyH6N2LThawi
	SzH/0z2QjNtX92RCQEXKPtrpDLEnilumEJ2y/zyFGFMRS5MrmCxlyUQu6xdBwfYYz6Nkkv
	QgF/O8/atk9iKyNm+JDD5SC4vF9edNk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NlkBtcSH;
	spf=pass (imf27.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781204076;
	b=tDfC4pTpYQ6oYBTmYltFJhfYOf/5h+V8SOs1rgBjlX1GAT8YjIcHWQ1j8FqEkQC8EpKvi0
	ZTEhiiOYPiEw4qkJpfYQI67HWKnQdFhel8yqYo/1MqzEZquplzz/mPZU3O+Xe1v/V6hu3w
	HsM1TQOGrOi6Nkla5Lj3ARXYhXvR+5Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781204069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bTVMqhjCGD00iChQYZ7sxVESMAqPZGe11o/lWoojvhg=;
	b=NlkBtcSHZ1zMzDysnEETRQ7OA/pXouAUtcel+hS5pavQcNanoQ6lWlKDq8ZYtl/ZsxkryN
	HfiKWFVGQ9lgMLrTn+J8QnqLfV24vgS+a8pmwIEsYm+cRCYPclj0QwR7O6nss2AdIpwTKr
	qh79uZRZHAAEVcq3X9YmXkuzUiTugLk=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>,  Zenghui Yu <zenghui.yu@linux.dev>,
  linux-mm@kvack.org,  hannes@cmpxchg.org,  yosry@kernel.org,
  chengming.zhou@linux.dev,  qi.zheng@linux.dev
Subject: Re: [zswap?] BUG: sleeping function called from invalid context at
 kernel/cgroup/rstat.c:421
In-Reply-To: <aisAd7IGVtCCEbF4@linux.dev> (Shakeel Butt's message of "Thu, 11
	Jun 2026 11:38:28 -0700")
References: <c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev>
	<CAKEwX=Me_WHU-oVF=rab7-5e=QTaYQJj0adi7xjejm-MyoDxyA@mail.gmail.com>
	<aimbPCBloe0Dqk7t@linux.dev>
	<CAKEwX=PyHr+9wiuohixv4PHEtyvt8uD2j45JGQdN8dzn7UgkXA@mail.gmail.com>
	<ainb3W_-i5ish_K6@linux.dev> <7ia4tsr9lye0.fsf@castle.c.googlers.com>
	<aisAd7IGVtCCEbF4@linux.dev>
Date: Thu, 11 Jun 2026 18:53:59 +0000
Message-ID: <7ia4tsr89ad4.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5693340015
X-Stat-Signature: zg3fedggraaitqg8hmo3rio4hhwxd7sx
X-Rspam-User: 
X-HE-Tag: 1781204073-79575
X-HE-Meta: U2FsdGVkX19IpSDRKfzvvoAhdlCxE5SB3QGSN6tMyRWNolzfF3WuQsPMqolx9HQ4zAsQoOIUE7AgRs+oYqyThXhiJJ/dzkO9VZFdILgWlrIhOGIrVeZFRcjMS/ab2qq9LaA69k5IrRvXKbp7XxQBOjBnulbpv6Up6ZnRbugWRB7iUeDjC5n5tIrzFE3Iop66CAdDMGqle1VtyfXmJXUfdR65sCMVKzBy9V+U456sHVjdo18G5PG8ofkEm6qKGlS0be1n7zUj5l0+hHtn/MoVqCbLMgBwikBrK7IcTvHb/nIskaUiMFVc6mycfqz52vxHdA4z7U9CfEWBZEKr5z/Qw4uRibTIaZmqdCjsOD5uT59ydC06pdSMUXFrIkXK7ha5jAgPMXnKp4KAorWRIhqEloQ2hdpn8W1sMKNJ9t6SoSgJQJEjGjRl4+9zn4EEkTpwDmo+8MguGoMvCQR3fg4ZXfpqfD0hv5dVnVSMud1ZH+cGB2C6YtCL6j4y8ZcBvs0F6v6XKdrexZRY9JAGSTsfjKsRtvmAyXUW5UtL63MvYiXK2tJSzn4BdF4N/KvcjrI2yhf+uTQDi3enCMAn/J9Y4XaY97cEF5ceq2eioYATZI3CrXN5EF90jW1nGzPrrsv9+HOrWURo3xPCe5XgBxQYjX4elzNCMRkJbCeSE2Vsw9MSPCehEEn26/GCjxOSbMughQimxyKCHCV3LNTlowydhJ5VLO2BK2KpZL8XSwU3zXkiKH8/4mJq7uf8nijbyWfy97z1wC7VQtGVGCH/VK5Bx04oxnwscKOguOMtkNAjwrcBi5DDnCIDZEB49zyRfR4VwRUi3LH+eo0q0QVxTUKzwpgmQ5D/0aH01hbf0zA5UN2cFvEOX0h1N89ACsy+o0x9mVNc1MRfVupGm+jzFOkfo1umrks5Ydwz97xvS+fmwHUOf7KLw49phqa9YxnT/XVS3p9OtH0w5R4SrFfX867
 /ngoHqn2
 TlJWCUDGjyUbUeE3w2r7LckXu+vj9+2B/pfKsqkidrrJnJVk6BCroaxinNbz1f6JF/VfR6dn3KGC+c1LmjcO0pPthPOEvLQPeCiwjTCa/vjwVOM9eZkWOs7GZhtA/Ext/p0PwxwmY34JkXTwIe+lSErGaOY5PXcTV/EBEvsI2Fxs41XjNy2vZyL0lknfQ/1cEoAfdM8TbCQL7qvaJBdt2pvE1aDjx9I++BnFClPxDhXsLyuQWVMg3+/FF0h5UdLfWExcXBC7pgmYQIvRBvOH8ZlKHkX8aPRfjo5Uls1QlDas6IAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> On Thu, Jun 11, 2026 at 06:34:15PM +0000, Roman Gushchin wrote:
>> Shakeel Butt <shakeel.butt@linux.dev> writes:
>>=20
>> > On Wed, Jun 10, 2026 at 11:38:29AM -0700, Nhat Pham wrote:
>> >> On Wed, Jun 10, 2026 at 10:31=E2=80=AFAM Shakeel Butt <shakeel.butt@l=
inux.dev> wrote:
>> >> >
>> >> > +Roman, Qi
>> >> >
>> >> > On Wed, Jun 10, 2026 at 09:38:03AM -0700, Nhat Pham wrote:
>> >> > > On Wed, Jun 10, 2026 at 9:05=E2=80=AFAM Zenghui Yu <zenghui.yu@li=
nux.dev> wrote:
>> >> > >
>> >> > > Thanks for reporting, Zenghui.
>> >> > >
>> >> > >
>> >> > > >
>> >> > > > Hi all,
>> >> > > >
>> >> > > > The following splat was triggered on the mainline kernel:
>> >> > > >
>> >> > > >  BUG: sleeping function called from invalid context at kernel/c=
group/rstat.c:421
>> >> > > >  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1126, n=
ame: cat
>> >> > > >  preempt_count: 0, expected: 0
>> >> > > >  RCU nest depth: 1, expected: 0
>> >> > > >  CPU: 7 UID: 0 PID: 1126 Comm: cat Kdump: loaded Not tainted 7.=
1.0-rc7-00056-gacb7500801e9-dirty #304 PREEMPT
>> >> > > >  Hardware name: QEMU QEMU Virtual Machine, BIOS edk2-stable2024=
08-prebuilt.qemu.org 08/13/2024
>> >> > > >  Call trace:
>> >> > > >   show_stack+0x18/0x24 (C)
>> >> > > >   dump_stack_lvl+0x78/0x90
>> >> > > >   dump_stack+0x18/0x24
>> >> > > >   __might_resched+0x114/0x170
>> >> > > >   __might_sleep+0x48/0x98
>> >> > > >   css_rstat_flush+0x54/0x564
>> >> > > >   mem_cgroup_flush_stats+0x9c/0xb0
>> >> > > >   zswap_shrinker_count+0xe4/0x1e4
>> >> > > >   shrinker_debugfs_count_show+0xd8/0x268
>> >> > >
>> >> > > Ah, this seems a bit tricky.
>> >> > >
>> >> > > Seems like shrinker_debugfs_count_show() is invoking
>> >> > > zswap_shrinker_count() in rcu_read_section(). zswap_shrinker_coun=
t()
>> >> > > triggers a stats flushing, which might sleep. Not ideal.
>> >> > >
>> >> > > Is the rcu_read_section() here to protect memcg or shrinker? For
>> >> > > memcg, i dont think it's necessary, no? mem_cgroup_iter() pins the
>> >> > > memcg before returning.
>> >> > >
>> >> > > (memcg maintainers please fact check me).
>> >> >
>> >> > mem_cgroup_iter() handles the lifetime of memcg, so there is no nee=
d for rcu
>> >> > read section for memcg.
>> >> >
>> >> > >
>> >> > > If this is for the shrinker think this needs to follow shrink_sla=
b()'s pattern.:
>> >> > >
>> >> > > rcu_read_lock();
>> >> > > list_for_each_entry_rcu(shrinker, &shrinker_list, list)
>> >> > > {
>> >> > >     if (!shrinker_try_get(shrinker))
>> >> > >         continue;
>> >> > >     rcu_read_unlock();
>> >> > > }
>> >> > >
>> >> > > But OTOH, doesn't seem like rcu_read_section() is what keeping it=
 safe:
>> >> >
>> >> > Shouldn't the caller already holds the reference to the shrinker wh=
ich it is
>> >> > giving to this function? Does debugfs file entry holds a reference =
to the
>> >> > shrinker which it is giving.
>> >> >
>> >> > After looking at shrinker_free(), it has call_rcu(&shrinker->rcu,
>> >> > shrinker_free_rcu_cb), so this rcu read section is against that.
>> >> >
>> >> > I think we can simply use shrinker_try_get() here as Nhat said.
>> >>=20
>> >> Hmm, so is this unsafe even with the current rcu shennanigans? What's
>> >> stopping shrinker to be freed by that callback before we enter
>> >> rcu_read_section()?
>> >>=20
>> >> Seems like this is just implicitly correct - shrinker_debugfs_detach()
>> >> and shrinker_debugfs_remove() happens before call_rcu(&shrinker->rcu,
>> >> shrinker_free_rcu_cb);, so if you're reading this file, then it's
>> >> before shrinker_free_rcu_cb() is even registered?
>> >>=20
>> >> Do we still need rcu or shrinker_try_get() here?
>> >
>> > I think you are right that we don't need rcu or shrinker_try_get() but=
 it is
>> > more about an active debugfs file reader. Suppose we are sleeping with=
in rstat
>> > flush from shrinker_debugfs_count_show() and there is a parallel
>> > shrinker_debugfs_remove() call.
>> >
>> > shrinker_debugfs_remove calls debugfs_remove_recursive and deep in the=
 stack
>> > there is a call wait_for_completion(&fsd->active_users_drained) which =
will wait
>> > for active users, one of which is sleeping within rstat flush.
>> >
>> > So, let's simply remove rcu read here.
>>=20
>> +1 to this. How about this version?
>>=20
>
> Thanks, Andrew already picked up
> https://lore.kernel.org/all/20260610232048.62930-1-shakeel.butt@linux.dev/

Awesome, thanks!

