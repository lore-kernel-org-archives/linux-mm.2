Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09F56C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 07:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCB8B6B0005; Sat, 11 Jul 2026 03:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2DE6B0088; Sat, 11 Jul 2026 03:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE08C6B008A; Sat, 11 Jul 2026 03:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 960B36B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 03:27:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21F2CA0679
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 07:27:39 +0000 (UTC)
X-FDA: 84975665838.24.8046F91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 92D86A0004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 07:27:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iZM9j+K2;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783754857;
	b=b3I2ZigZ++0BCMMpxbptixSxN4dyWU9Nh1Kc4fOIAEY8lBEaFnMg6ngb2nOF8AlxlZ5zZT
	61EuhqYbwabq5t800vLKyDSxffUnOX3AomSIUxBK//XCgpyzdlq1lwE5vmZe77g1MKKPd1
	jvjX7g/32eqeXBJ1b+KN/vkkL5VBaZM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iZM9j+K2;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783754857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C+6p82jb2/aEkt1ZTkLsvP1xOUzDqGuBhaufElbiyiI=;
	b=b63fL9gkVfiddMln1fa1R8Vg6HK7fKdQZrlg5TxePpqZ73xQDWMt+NDLSCtF1PlTBVFrDh
	wyG8CEqkFIJ6mKkxxYL7cU42B9LWeMUjVdrcPuK2nBcSrEpPFVaqp4wRjDuceLXAn33xC2
	1udZPFPmJkqThF9p5TP+fjJtG1WtLss=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EEE29600C3;
	Sat, 11 Jul 2026 07:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F931F000E9;
	Sat, 11 Jul 2026 07:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783754856;
	bh=C+6p82jb2/aEkt1ZTkLsvP1xOUzDqGuBhaufElbiyiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iZM9j+K29RqsZs/pgnjVGv1y/g1WDedJzleE5hWTeFT1NHl/YR8r7Q5VoRC5PP/rG
	 UMcyaaIxn0XOwNyxb49orLZnE6JHuDqKU7zXvxMYZTASOuFy3Rl0KF8G/aG1fQ2yFN
	 NeEX2HmUW3yKRYYI2UfxY5yVZZIkwR66AzlyTlAmS+wXGo2P7gDhmlUV7+BliJLjMq
	 swhey2eI29p+gioLYySaxV69zUnEQuZ1T4P0nDgROA2wq59QWV1QAZClGZrNYeluqm
	 lohPBUPZyrwZx4ZBOCQPV3u/E3qyqm+H7Ivc7V4QITxG6YwHXBTs6H2Vpa4dBWSf5s
	 uKpFuFsV+Xr3A==
Date: Sat, 11 Jul 2026 08:27:23 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Qi Xi <xiqi2@huawei.com>
Cc: Russell King <linux@armlinux.org.uk>, 
	Xie Yuanbin <xieyuanbin1@huawei.com>, akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	liaohua4@huawei.com, lilinjie8@huawei.com, linusw@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@suse.com, rppt@kernel.org, sunnanyong@huawei.com, surenb@google.com, 
	vbabka@kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH v3 1/2] ARM: mm: fix use-after-free in __do_user_fault()
 under CONFIG_DEBUG_USER
Message-ID: <alHnqsIdcMghnUER@lucifer>
References: <akzpuerKqOY7qfFi@shell.armlinux.org.uk>
 <20260707131409.79043-1-xieyuanbin1@huawei.com>
 <akz8aZUW23rpyrLO@lucifer>
 <ak0cfZPZIWz4v95K@shell.armlinux.org.uk>
 <3fb3b11d-515b-400d-b1d2-5623dacb92cb@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fb3b11d-515b-400d-b1d2-5623dacb92cb@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 92D86A0004
X-Stat-Signature: egsy3heax8mzg3efkyjciagq6mfzsoij
X-HE-Tag: 1783754857-719521
X-HE-Meta: U2FsdGVkX18Zoare2Q7+w5AmZFPL8vIRfS95C45y/Gi8ws5ZJnFyL9My9WDOxEVUhrtvh9W3x/gFT2j9QD0nPH3ukzLf1O6ZYv4jPh3Wyup2ijUUOWjkUG7rauh3KdiTku3eft65/06udmqm9XzqCscTF2gVeo4L9/3QR7BidsTZzkAzhezvVtmEg9uX6391dhRAtn+nFkLHDTMTGZ8qql1Kv4XRDWaX9IkuPNItfWK3olVenQ1h17K8wW1+hJjUgGGwZJv0Rb+qvBr7SC2e/aF36ZtKNMXjvpkpEBwESX0L0ls4xjLm6FoniO6ZzKhP1zME7yrkcpmrwj2gEHx419OVcVvwXbiOppqu8xOOjSZv6QKRyMAZ99quJF05F6jDEELsF+5PeaWf3VYTFAAt6EMsbKFWnoXuKQ2zgoqNXPhYetWznTbMylOiYEqtaLWUgo4s9QGA7an58HL77KndNpCtOJWB3vdq30MDb1bYjg2sHk7SGlPeRjShrwt/z31WcCDDOG4PuVwMMHxsAPWGHFMWr3DXpiG8hHtuoqFrDfEflVKVGxljQ2Y/ToYUXoFkVSNB0L0z8pY23OhkmnRjf6avCAWpu4aTAC/PAAmOWj8L2sbpN4cc8p9Tidwno5vpXs+SE3F7aH+KHPhXiCUwJGJcYOSvyQ9tAsFgZq3MbaqRqG+UpKcibvOTQC7JEiLssM7Rj7NHxwO7R6nUnllIPzpuiPXveUgjeTxcmUuZ4XxoddQCrQIPz2nRMJH3HLcJhbZzOPjCeXVZGhcpUGXKsVC98DErwBEB30W35M4qfHLN8Cwt3hDM7oBct92dqNL7q72Y1wQSoJelQ3Sj1NyFIwvvWQo0QEDi/2ar/hm0pc9NBVMlf1XxQ8y7A5vvrPlsQox5ZG3PppF+cofGlDkKr1pcNZVcukZSKIO6I8uvUHONrh8oWTmTmzCqLwj+9PcNedzP9TpW6JMvWKhRr2/
 uE64bTyH
 TlKTrvy9otH/zRhXdpqOTmODB7kjGToC84atz2QYRep+RsWRg/rmrD5pO2McM8yDU3GQSGtS2g6OpuBLo13esbuq5kWSbAU+D4XoTgNAul3XxwVMH1Qmx0zPWwxLXumQlqK2fTOMjLHCEKaUum87ugwV5xMdT+oXjii6i4IgwwkjHh888TWEY9OxVY1x0Vj5QF38fsdtlGqCj1YMLiuh+eRxHGh10wKwh734bWJwBBH6m9mMyjZlyVTX6reNZ+UjnfsGv1GxlcqdyujfFu+JVmI6wlj+LyIJ9LK5A3FyLnKxouDH2JGlH4EEb6A18+V7Dje8t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 10:32:29AM +0800, Qi Xi wrote:
>
> On 07/07/2026 23:34, Russell King wrote:
> > On Tue, Jul 07, 2026 at 02:20:19PM +0100, Lorenzo Stoakes wrote:
> > > On Tue, Jul 07, 2026 at 09:14:09PM +0800, Xie Yuanbin wrote:
> > > > On Tue, 7 Jul 2026 12:57:45 +0100, Russell King wrote:
> > > > > No. This information is useful debug for kernel oops.
> > > > For kernel oops, I think it should be `!user_mode(regs)`, Qi Xi's reply:
> > > >
> > > > On Tue, 7 Jul 2026 19:48:12 +0800, Qi Xi wrote:
> > > > > For do_DataAbort() fallback:
> > > > >
> > > > > 	if (user_mode(regs)) {
> > > > > 		if (addr < TASK_SIZE) {
> > > > > 			mmap_read_lock(current->mm);
> > > > > 			show_pte(KERN_ALERT, current->mm, addr);
> > > > > 			mmap_read_unlock(current->mm);
> > > > > 		}
> > > > > 	} else {
> > > > > 		show_pte(KERN_ALERT, current->mm, addr);
> > > > > 	}
> > > > changes nothing to kernel oops. It only skip show_pte() for user-mode
> > > > faults, and the fault addr is a kernel address, which means a user
> > > > program is trying to access a kernel address.
> > > > I think it is reasonable to skip show_pte() in this case?
> > > Well the whole reason you're faulting here might be because a userland process
> > > did that right? The page tables should tell you (presumably on ARM32 :)
> > >
> > > And I hate to repeat myself, maybe you didn't read the whole thread but... just
> > > use mmap_write_lock(), this isn't necessary?
> > >
> > > What is this trying to achieve?
> > >
> > > You're not in a hotpath, why are you bothering to conditionally take/not take
> > > the lock?
> > Unconditionally taking the lock could lead to a deadlock. Consider
> > the case where the mmap lock is held, and we get an unrecognised
> > abort from the kernel.
> >
> > If we try to take the mmap lock again, we'll deadlock, which will
> > result in very little debug information being output - and the
> > system locks up. The only thing that would save such a case would
> > be if the user had decided to use a hardware watchdog, or is
> > physically present to press the reset button.

Yeah right, ugh.

We don't currently have an mmap_write_trylock(), that was removed in commit
cf95e337cb63 ("mm: delete mmap_write_trylock() and vma_try_start_write()")
but I think it's legit to bring _only_ the mmap_write_trylock() back (not
vma_try_start_write()), AND updated to account for how VMA locking works
currently (we have to update a seqcount on mmap write lock acquisition).

To make life easy - I've attached a patch that you can add as part of a
series (please keep attribution etc. to me so I can be blamed/villified if
this is insane :)

That way we avoid the deadlock and also avoid concurrent downgraded
munmap() oopsing in show_pte().

>
> We are preparing a v4 and would like to confirm the approach for
> the do_DataAbort() fallback path (__do_user_fault() is similar).
>
> As Lorenzo noted, an mmap write lock is required here because
> munmap() downgrades the write lock to a read lock before tearing
> down page tables.
>
> -	show_pte(KERN_ALERT, current->mm, addr);
> +	if (user_mode(regs)) {
> +		if (addr < TASK_SIZE) {
> +			mmap_write_lock(current->mm);
> +			show_pte(KERN_ALERT, current->mm, addr);
> +			mmap_write_unlock(current->mm);
> +		}
> +	} else {
> +		show_pte(KERN_ALERT, current->mm, addr);
> +	}
>
> The lock is taken only for user_mode(regs) + addr < TASK_SIZE, so
> kernel aborts that may already hold the mmap lock are left unchanged.
> For user-mode faults on kernel addresses (addr >= TASK_SIZE), as
> Yuanbin noted, it is reasonable to skip show_pte().
>
> Please let us know if you see any issues with this approach, or if you
> would suggest a different way to handle it.
>

In general yeah but with mmap_write_trylock() after you add the attached
patch to a series (making sure to cc- the right people etc.)... but also,
wouldn't you just generally want this in show_pte()?

Seems to me best way is to put the existing show_pte() into a __show_pte()
and then do show_pte() like (untested top of my head thing):

void show_pte(const char *lvl, struct mm_struct *mm, unsigned long addr,
	      bool is_user)
{
	/* Write lock needed to account for concurrent downgraded munmap(). */
	if (is_user && !mmap_write_trylock(mm)) {
		printk("%s[%08lx] unable to acquire lock for PTE output\n",
			lvl, addr);
		return;
	}
	__show_pte(lvl, mm, addr);
	if (is_user)
		mmap_write_unlock(mm);
}

Cheers, Lorenzo

----8<----
From 2d0906c9ca962361fcdf2a033deb2a37252c486a Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Sat, 11 Jul 2026 08:07:27 +0100
Subject: [PATCH] mm: add mmap_write_trylock()

Commit cf95e337cb63 ("mm: delete mmap_write_trylock() and
vma_try_start_write()") removed mmap_write_trylock() as there were no
users.

Re-add this helper and update to have it update the mm's write lock
sequence count number as per the current VMA lock implementation.

The use cases for this function are very narrow - in the vast majority of
cases an inability to acquire the write lock is terminal so you want either
an unconditional or killable variant of the mmap write lock.

However this is being added so a subsequent patch can safely dump PTE
information when an unhandled fault arises in arm32.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mmap_lock.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 04b8f61ece5d..fe14d4babae9 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -546,6 +546,18 @@ static inline void mmap_write_lock_nested(struct mm_struct *mm, int subclass)
 	__mmap_lock_trace_acquire_returned(mm, true, true);
 }

+static inline bool __must_check mmap_write_trylock(struct mm_struct *mm)
+{
+	bool ret;
+
+	__mmap_lock_trace_start_locking(mm, true);
+	ret = down_write_trylock(&mm->mmap_lock) != 0;
+	if (ret)
+		mm_lock_seqcount_begin(mm);
+	__mmap_lock_trace_acquire_returned(mm, true, ret);
+	return ret;
+}
+
 static inline int __must_check mmap_write_lock_killable(struct mm_struct *mm)
 {
 	int ret;
--
2.55.0

