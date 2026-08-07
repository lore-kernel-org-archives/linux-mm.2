Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F394C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 06:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F90E6B0088; Fri,  7 Aug 2026 02:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D0A86B008A; Fri,  7 Aug 2026 02:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7326B0092; Fri,  7 Aug 2026 02:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF3756B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 02:53:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57902160337
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:53:25 +0000 (UTC)
X-FDA: 85073557170.24.04DEF1C
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7E51040003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:53:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=lJKjwC9S;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf01.hostedemail.com: domain of sh_def@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=sh_def@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786085603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80UEqxKanTN28pOX1DZ8OIOT9CTXQkPwywSvF0qMB4c=;
	b=BTKaJv3IdSteie1V1To72MBYgxP0prY6hs5T29J56aZ8NWHZOkNj8V1NUjJ8sNJiMuKri0
	Rhg3Ee7zdGHBeEQtHwhuUVcb5Z+MWw7xdaaN4X83j9+kFgoYM+SQC/mfSmDewFmlGWLsIH
	E6Og75VS3IuvEgdtRzq6TutuVbqXWlI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=lJKjwC9S;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf01.hostedemail.com: domain of sh_def@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=sh_def@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786085603;
	b=W/Pn65R8JPc89/DaOYywrdd+KvO1NyrKf79sSKk9SG1+JwXGU3MwdZ51rUVUJ+gIki2TVr
	Wvy3BcpJMfvbb5yOptyIps17iWK+8mSG68jdkdXfg08DTO/zW1YCGjnFGXxESIeDtboeSa
	DbVYZxNEhsRjq5vMegCxioOBC3zDWKY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version:
	Content-Type; bh=80UEqxKanTN28pOX1DZ8OIOT9CTXQkPwywSvF0qMB4c=;
	b=lJKjwC9S7vURAOgHJJETzKt14Z45+4ksU0gkzn7HvpYOyW+1LF/4vv6/i5vJZZ
	uHC5lVJyDc3RHtAceRMPo6vpOX6fH4y3xmS7qo1U2HC4PRCIJdAhZ0vkQ+RG/uCn
	aXe0xjocXn1fsFcKQRZtDXk5nIj3QonWG12idQKtCuINg=
Received: from localhost (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAnWPfBgHVq8tHHKA--.61020S2;
	Fri, 07 Aug 2026 14:52:49 +0800 (CST)
From: Hui Su <sh_def@163.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	qiang1.zhang@intel.com,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] kasan: fix cache shrink race with CPU hotplug
Date: Fri,  7 Aug 2026 14:50:31 +0800
Message-ID: <20260807065038.2600949-1-sh_def@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806135125.a444f867993cb3cd3122551e@linux-foundation.org>
References: <20260806121006.1642946-1-sh_def@163.com> <20260806135125.a444f867993cb3cd3122551e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgAnWPfBgHVq8tHHKA--.61020S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Xw4xJr45tFWDuw4rCr45KFg_yoW7tr4rpF
	ya9a47Cr48Wr18t3ZrA3WkWryrZFZYvF45Jwnagr1FyF4ru3srtry7KryjvFyUW3s5Ja13
	tF4kKasrWFWDAF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUx-BtUUUUU=
X-Originating-IP: [183.192.100.171]
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbCwQJIp2p1gMI5QgAA3K
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7E51040003
X-Stat-Signature: gatpihbe5r4z1ibicf4sqk99cihgpmab
X-Rspam-User: 
X-HE-Tag: 1786085602-539739
X-HE-Meta: U2FsdGVkX19JilQAS/tVEo5lRQKudr4eK4aoktEKCCUwHFlJycR5kIggou2GoseF32TYDCJejgLZZPnRrzlMEhQDAHFFVRPx4J0KitYsxXzYYSOD273QmHGl5eN+7Na0Wosg8ldaJHeaVpkatAV/r2X77S1WQsOXW9dVif7jT+y3lnEPYv9fD1sD501Kj9dC2bAoLJQOuOcz/0FNntAH4Nyyumu4jLwQigYcQHjO6oFnjyikg4gi0Ghb8m9n8CwRJ+3UKkP29IVAweQl3jRPwX+cIBSFJixD8cjYnaEpRoY56OTRrYTcT6xYQ6ajzvf2NMRVdZalYx1AUbxLP4uHCdU4MZ0bvSgOp2qYCVTE2qYTgqr+IDKnyQblK6mk3PKLI92sKLlejE74yfJRPmTW6I31U+m6+0ygV5/Dl2Dnm+75xMHW07nt1RomojgSa6J/BIbmbH0HKiNRUrMNLFi4kqy6mVBYtYue14kQFOdtvOGbzduxaCaRoiYe7b2z68PSVzY5DyPR7d0PnUyNIyNgE5D147nlfRA50LOZGzzT8zYC3i5w90m21ADheXSA7fZ1dmPP7ku48CaGRP6xhpwHFg5mLA0hfSUL1WPSQM8oMCLHbWK8bgSYoE0mtltDJpyBuFXpefGKNVWQuFb8UQsuvR/ztTuPPmIM/Hu27ZBrD5INVe8AwACvB1neOnTsn8lhGIH2yReHkMGIVNsraLWW//urh4hbyLQBiA1Mtrt7F/YWc21EEsnGJl5MsCRSR51UgQzuCkNF9IjCqYUaNlrKipFli8AMthtnaTFHbfiHmB/JngYRDSpuJgYPKif4tDwPv1SLz4mMnlg7lWzek4CfdAXVTYMntirA93gVl/aaENFHKL9A7pQszt1gCLYn/8+ReBIsJFscAFCSY05zilfzM4uDg7md1n4/lj/6lyYXcIJQEankN45InVubu7ws2j1qcRpSwf9HknsqKvIx+EU
 d/ApjA3g
 jYGMVRVQN1QS0DFk+kqKPoHZl7Yqk76czQjY6CcM7pCGMfzrGfI+tiv+uZnRpBycA9TGA0XJjwfevKZAn6U5mVWIN6F9x14gMDoY5ulComQs16ABt05WHW2ZQnnkmDOmMOzJd7/ekyl/6ZWfHG/Ffmo+D/C1h2tawlc2Rm8OrwJ+1jueFRzPeDt7yOmgUvJsoH5HbyP323D53VkQBpCQMra6NQrpxLExzOLuE1x7QVHAod0+vzTdlhds/jLppbe8FxH2NkAX10jiT5SGFZXmKwy6SvvCpqkywbq9dSpAVs//8KNG9fgJjiUjsOS/cP3VjUiD7NQuOfKXQVZPcyFmklzrbQjCDa+5754QayBitDgXJT0jsoIdK99AzOlqgAk2K7K1oOllx85bYGxDtBYw4PPBd3eJ5kTwS0o3an25PUjX7gjVOwd6EWiJ9XHWtkD1qY3RkZ2a4Juxfwo2iIyO5sw3Kj4uSD3JWlDWndNQdHlgcoQ0Zaw1vyLNNounB3DcI1aSz45GATO6osPeQL/VRCCPJYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

> On Thu,  6 Aug 2026 20:10:06 +0800 Hui Su <sh_def@163.com> wrote:
> 
> > kasan_quarantine_remove_cache() first invokes per_cpu_remove_cache() on
> > all online CPUs. Each callback moves objects belonging to the cache from
> > cpu_quarantine to the CPU's shrink_qlist, where they can later be freed
> > from task context.
> > 
> > kmem_cache_destroy() invokes the quarantine removal path while holding
> > cpus_read_lock(), but kmem_cache_shrink() does not. The latter can
> > therefore race with CPU offlining as follows:
> > 
> >   kmem_cache_shrink()             CPU hotplug
> >   -------------------             -----------
> >   on_each_cpu()
> >     CPU1 moves objects to
> >     CPU1's shrink_qlist
> >   on_each_cpu() returns
> >                                   CPU1 goes offline
> >                                   kasan_cpu_offline()
> >                                     drains cpu_quarantine
> >                                     leaves shrink_qlist untouched
> >   for_each_online_cpu()
> >     skips CPU1
> > 
> > The objects left on CPU1's shrink_qlist are not returned to the slab
> > allocator. This may prevent kmem_cache_shrink() from releasing slabs
> > that would otherwise become empty. If CPU1 remains offline, a later
> > kmem_cache_destroy() also skips the list and can report that the cache
> > still contains objects.
> > 
> > Per-CPU shrink_qlist storage exists for every possible CPU, and each
> > list is protected by its own raw spinlock. Iterate over possible CPUs
> > so that a list populated before its CPU went offline is drained as well.
> 
> Thanks.
> 
> Please always describe the userspace-visible runtime effects of a bug
> when proposing a fix.
> 
Thanks.

On my machine, the userspace-visible effect was that unmounting a 9p
filesystem returned successfully, but the kernel reported that the 9p
fcall slab cache still had objects during cache destruction.

The sequence was:
  1. mount a virtio-9p filesystem;
  2. read files from it on CPU1;
  3. write to the 9p fcall slab cache's sysfs shrink file while racing
     with CPU1 offlining;
  4. unmount the filesystem.

The shrink step is what can leave objects on the offline CPU's
shrink_qlist; the later umount exposes the problem through
kmem_cache_destroy().

The mount and umount commands both returned 0. Unmounting the filesystem
then reports this dmesg excerpt:

  [  2994.380134][  T111] BUG 9p-fcall-cache-1 (Tainted: G    B              ): Objects remaining on __kmem_cache_shutdown()
  [  2994.381140][  T111] Object 0xff11000004361118 @offset=4376
  [  2994.381607][  T111] Allocated in p9_fcall_init+0x201/0x400 age=19564 cpu=1 pid=104
  [  2994.382591][  T111]  p9_fcall_init+0x201/0x400
  [  2994.382810][  T111]  p9_tag_alloc+0x12f/0x700
  [  2994.382982][  T111]  p9_client_prepare_req+0x102/0x3e0
  [  2994.383165][  T111]  p9_client_rpc+0x1ab/0xa50
  [  2994.383334][  T111]  p9_client_getattr_dotl+0xb0/0x1a0
  [  2994.383515][  T111]  v9fs_vfs_getattr_dotl+0x115/0x360
  [  2994.383719][  T111]  vfs_getattr_nosec+0x22c/0x3a0
  [  2994.383910][  T111]  vfs_statx+0xd7/0x170
  [  2994.384062][  T111]  vfs_fstatat+0x45/0x80
  [  2994.384215][  T111]  __do_sys_newfstatat+0x84/0xe0
  [  2994.384386][  T111]  do_syscall_64+0x115/0x6a0
  [  2994.384566][  T111]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  [  2994.399720][  T111] WARNING: mm/slub.c:1244 at __kmem_cache_shutdown+0x363/0x500, CPU#0: busybox/111
  [  2994.405655][  T111] Call Trace:
  [  2994.406325][  T111]  kmem_cache_destroy+0x73/0x1b0
  [  2994.406630][  T111]  p9_client_destroy+0x271/0x3c0
  [  2994.407210][  T111]  v9fs_session_close+0x3c/0x260
  [  2994.407409][  T111]  v9fs_kill_super+0x48/0x90
  [  2994.407584][  T111]  deactivate_locked_super+0xa3/0x160
  [  2994.407778][  T111]  cleanup_mnt+0x1dd/0x3e0

So the userspace-visible effect is not that umount fails. It is that a
successful userspace-triggered teardown leaves the 9p fcall slab cache
with objects still present, produces the slab shutdown warning above, and
prevents the cache from being destroyed cleanly.
> > Fixes: 07d067e4f2ce ("kasan: fix sleeping function called from invalid context on RT kernel")
> > Cc: stable@vger.kernel.org
> 
> Especially when proposing a backport.  At present we've provided our
> -stable recipients no reason to accept the patch.
> 
> Documentation/process/stable-kernel-rules.rst says "it must fix a real
> bug that bothers people".
> 

Yes, I agree. I did not include the real bug dmesg in the original
changelog, which made the stable rationale unclear.

The 9p case above shows that this is a real bug: a userspace-triggered
teardown path can leave objects in the 9p fcall cache and report the slab
shutdown warning after umount.
Should I keep Cc: stable in PATCH v2 with this dmesg and
userspace-visible effect added to the changelog?

> 
> > --- a/mm/kasan/quarantine.c
> > +++ b/mm/kasan/quarantine.c
> > @@ -355,7 +355,12 @@ void kasan_quarantine_remove_cache(struct kmem_cache *cache)
> >      */
> >     on_each_cpu(per_cpu_remove_cache, cache, 1);
> >  
> > -   for_each_online_cpu(cpu) {
> > +   /*
> > +    * A CPU can go offline after on_each_cpu() returns, leaving cache
> > +    * objects on that CPU's shrink list. Scan all possible CPUs to
> > +    * drain those lists.
> > +    */
> > +   for_each_possible_cpu(cpu) {
> 
> In some configurations, for_each_possible_cpu() can do a lot more work
> than for_each_online_cpu().  What are the worst-case userspace-visible
> runtime effects of this additional work?

The impact is limited to CONFIG_KASAN_GENERIC kernels. quarantine.o is
built only for CONFIG_KASAN_GENERIC, and the quarantine helpers are
compiled as no-ops otherwise, so non-KASAN kernels and tag-based KASAN
builds are not affected by this change.

For CONFIG_KASAN_GENERIC kernels, the extra cost is paid only when
removing or shrinking a cache, not on the normal allocation/free fast
path. The added work is one raw-spinlock-protected empty-list check per
possible CPU.


