Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E047CF8FA8F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 15:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B69376B0005; Tue, 21 Apr 2026 11:01:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF9B96B0088; Tue, 21 Apr 2026 11:01:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A091A6B0089; Tue, 21 Apr 2026 11:01:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8CAC86B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:01:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E759161068
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:01:44 +0000 (UTC)
X-FDA: 84682877328.08.228E3FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DEAF740022
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:01:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fNBlNenF;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776783700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C8UZd1Ny/Y/4JsrtwE7PU7LuBkTETBvUkjflb369Faw=;
	b=N1Ai7k5MSmXU6JY+vo5IUAZajU9di1GzAMupzCbjblHGoRktdTgHUwXD7blpCZc4aFSjCz
	i4QDejoTlQvEiPhvvZo3i1ouklf1uoGgIVryVcADY8qWIO+qKRc1IcxbE13ToHz9DPto4b
	JharQc7Too1VopU6pVSE4htJmXGv8YE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776783700; a=rsa-sha256;
	cv=none;
	b=v5CefNjtaE8V9teaiV44N/sxKiWoR+HHM6CRMjG9vu5232B7svIrOs0PHvZHkQJlHfwkoA
	ndgHw2VlhZya8UIOP1pqnlIy8OirhKAVnQLTAgy0v/K6hBPsBiYFij5Ig6xusPkG1lnYdn
	PJvEFoxVuiWRFBwZFFBk2EcqSoB2AZk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fNBlNenF;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D10B444DD;
	Tue, 21 Apr 2026 15:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262ADC2BCB0;
	Tue, 21 Apr 2026 15:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776783698;
	bh=WA+5WAYPDlZ3kBXu4XrXR71aWl9R8b7xN5r2CQXf+94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNBlNenF1TYZY8vMfGKJGkMeog5vpWTZS8sEJLqoBhGkYM69LvmncrbTczIjczyb+
	 64XSSX8dLqD6X/XSxkgZK03oKO3vf6FjCeHUZcGzxC9DypmeOdYR16z00E7ongptAx
	 AM17fRqCSKFdJ+g+qL0L2+fRjoxNuu81DWEAxa1eT3NZdAP9FOJwY9ALXHqBRX5zLs
	 diCrIKL7kqqaJlhbPdyd0YdJHdGOIZUoiySrwbjD0FbtgWnVHJUhA3NigURVYbtI9M
	 PDRJukFtZ3bL4c4hDIMOzDBt216RF4/ZUO9yTVH0TZkaE2YZoPDxM3/aiAwyXt8qSE
	 DrznSyXPUDg/A==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Junxi Qian <qjx1298677004@gmail.com>,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/sysfs-schemes: fix use-after-free on memcg_path and goal path
Date: Tue, 21 Apr 2026 08:01:34 -0700
Message-ID: <20260421150135.3097-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260421012028.67143-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ujekwngxgf1a7kiqfb7s7j9cahqa6fab
X-Rspam-User: 
X-Rspamd-Queue-Id: DEAF740022
X-Rspamd-Server: rspam05
X-HE-Tag: 1776783699-383865
X-HE-Meta: U2FsdGVkX19a5Zq7D9v8ch37gCOy3Ul6v9J6fc2XwO99XvtK2DDAEDdBqeJY2ekRLyg5Imce8PRukJbwXD+6XWoEcjZiAGN1o8te90xflbAtlm7b7PaVbn+FIOPHEgYFQwztU/XnEikQq4NfVLwd6aA9nSUYV8eBAuaVaXoL8wPPi+k7c1TTyqHc2WlJwf+0v1nDKnAWvr6pUB9LHMJWeFmM0GPlIQcDawyEwhn9wePmEEc5kvqnBhNv05IiPzpOg5CvPoN/Vr0YVZ0sbPHSq7J+wDHv0Ps3VWyvQCI0epE7cafdQdnxQvkZglCRSQGIkbyAxijYISCY1usna8hoFg3G47VjHw8XcLKHK4qPgvwkj1FcMMCgOh320R1vI+UNxV5aLNasAszoijZrlIEd1bwY2ml3K/oF5qCDZ/UgAETu+XtrXmhlfU6nq9lOebdmX5vARKgCUPnz0wn217FpuGi3OqQyKvLBh1RoLepgvp5JJzBHHVYgo5embi6Q2etCrh8J/HEzneo84Ite8+7cBT4sGghNyHOu4E2UZ/Bc80Bjj7M9N/WrtaKi1x0GjFQ/odov72Uyt0zerrsi0eQ7l0pusnoSeuvoAiLWZfB5v0/hJ+upkKhW/JkuHC48N719qq7wA2JDIM0wJ5P5F2iMUbOpSo05JxGEo7HMOF29y+89sodHJS2KygRbeQpce7yEXmvJUrXxQcaDx+EtQ9kravVOv4YD8w65iAx2DQbVZ6P73pbhC+pNFRQTYsnpv39q9rO42eHuRKQJJkd2EOsF768+Zqp2y2dOfdEVdrFRj5FJeYFusmNy8stHWw35HGooS0IU9m7zn8ALEFLbU7VHEK7v5jotMFmr6glDqDfI3UwOaJG835r7zzm7TBTUQjznWVAeF+qMjQMA50mTxcxsE0z8cyXoAXoa51pwXoO5Dx9zfkWXeXRQEVnLrWNbzCLXEvl6QLajtFQTtCff6wn
 PuQsf2h5
 Vpr2/l2AKSV9Fk9wqQ9DrJg6AuIuBAnN+1cDmX8BZRxFxbXN7Im5sf7TpFA71lsfVWWtXGGhPCxeXLkkym0DKaA/KeGU4LdxSJSroE3QBglWQ7sU/4maoARX7h5QKKkLNrGZFJobLdhsokq+7k+hRA3Wsnn775h8o+MH+5FPnZR5nYNZKsrp81PKPwn3hoAljTaFHIPnL6uvtNgg93XL6qUF8h/+JYuBoJ4RmsUgQPWBi0z0FOyMksKPmjMl2JdFxKKozjcfFhyzVcIsjIK2FukHWMn1vbWiNmvnErIoPJcOPII5SUN/PWhZBNaVXOHUvmnRR83Qz6ChFn/AyRYahHEd6LWrYlqVaPQEM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Apr 2026 18:20:27 -0700 SeongJae Park <sj@kernel.org> wrote:

> Hello Junxi,
> 
> 
> When you send a new version of a patch, please send it as a new mail with
> changes log [1], rather than as a reply to the old version.
> 
> On Mon, 20 Apr 2026 20:54:05 +0800 Junxi Qian <qjx1298677004@gmail.com> wrote:
> 
> > memcg_path_store() and path_store() free and replace their respective
> > string pointers without holding damon_sysfs_lock. This creates a race
> > with the kdamond thread, which reads these pointers in
> > damon_sysfs_add_scheme_filters() and damos_sysfs_add_quota_score()
> > via damon_call() during a "commit" operation.
> > 
> > The race window is as follows:
> >   Thread A (commit):  holds damon_sysfs_lock, triggers damon_call()
> >   kdamond thread:     reads sysfs_filter->memcg_path in
> >                       damon_sysfs_memcg_path_to_id()
> >   Thread B (sysfs):   calls memcg_path_store() WITHOUT lock,
> >                       kfree(filter->memcg_path), replaces pointer
> > 
> > Since Thread B does not hold damon_sysfs_lock, the kdamond thread can
> > observe a freed pointer, resulting in a use-after-free when
> > damon_sysfs_memcg_path_eq() dereferences it for string comparison.
> 
> Thank you for finding and sharing this bug!
> > 
> > Similarly, memcg_path_show() and path_show() read the string pointers
> > without holding the lock, so a concurrent store can free the string
> > just before sysfs_emit() dereferences it, causing a use-after-free.
> 
> Is this correct?  Isn't sysfs prohibiting such concurrent read/write using
> kernfs_open_file->mutex?  Were you able to trigger this?

This is corrct if the two threads are not sharing same open file.  E.g., they
openend the file with their own open() call.

Sorry if I confused you.


Thanks,
SJ

> 
> > 
> > KASAN reports the following on v7.0.0-rc5 with CONFIG_KASAN=y:
> > 
> >   ==================================================================
> >   BUG: KASAN: double-free in memcg_path_store+0x6e/0xc0
> > 
> >   Free of addr ffff888100a086c0 by task exp/149
> > 
> >   CPU: 1 UID: 0 PID: 149 Comm: exp Not tainted 7.0.0-rc5-gd38efd7c139a #18 PREEMPT(lazy)
> >   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> >   Call Trace:
> >    <TASK>
> >    dump_stack_lvl+0x55/0x70
> >    print_report+0xcb/0x5d0
> >    kasan_report_invalid_free+0x94/0xc0
> >    check_slab_allocation+0xde/0x110
> >    kfree+0x114/0x3b0
> >    memcg_path_store+0x6e/0xc0
> >    kernfs_fop_write_iter+0x2fc/0x490
> >    vfs_write+0x8e1/0xcc0
> >    ksys_write+0xee/0x1c0
> >    do_syscall_64+0xfc/0x580
> >    entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >    </TASK>
> > 
> >   Allocated by task 147 on cpu 0 at 12.364295s:
> >    kasan_save_stack+0x24/0x50
> >    kasan_save_track+0x17/0x60
> >    __kasan_kmalloc+0x7f/0x90
> >    __kmalloc_noprof+0x191/0x490
> >    memcg_path_store+0x32/0xc0
> >    kernfs_fop_write_iter+0x2fc/0x490
> >    vfs_write+0x8e1/0xcc0
> >    ksys_write+0xee/0x1c0
> > 
> >   Freed by task 150 on cpu 0 at 13.373810s:
> >    kasan_save_stack+0x24/0x50
> >    kasan_save_track+0x17/0x60
> >    kasan_save_free_info+0x3b/0x60
> >    __kasan_slab_free+0x43/0x70
> >    kfree+0x137/0x3b0
> >    memcg_path_store+0x6e/0xc0
> >    kernfs_fop_write_iter+0x2fc/0x490
> >    vfs_write+0x8e1/0xcc0
> >    ksys_write+0xee/0x1c0
> > 
> >   The buggy address belongs to the object at ffff888100a086c0
> >    which belongs to the cache kmalloc-8 of size 8
> >   ==================================================================
> > 
> > Fix this by holding damon_sysfs_lock while swapping the path pointer
> > in both memcg_path_store() and path_store(),
> 
> I'd like to avoid use of the lock in long term.  But this sounds good and
> simple for hotfixes.
> 
> > and while reading the
> > path pointer in memcg_path_show() and path_show().
> 
> As I commented above, I'm not sure if this is really needed.
> 
> > The actual kfree()
> > is moved outside the lock since the old pointer is no longer reachable
> > once replaced.
> > 
> > Fixes: 490a43d07f16 ("mm/damon/sysfs-schemes: free old damon_sysfs_scheme_filter->memcg_path on write")
> 
> I think this deserves Cc-ing stable@.
> 
> Also, this patch is fixing two bugs.  For making backport of the fixes easy,
> could we split this patch into two patches, one for memcg_path_{show,store}(),
> and the other one for path_{show,store}()?
> 
> > Signed-off-by: Junxi Qian <qjx1298677004@gmail.com>
> > 
> > ---
> > Changes in v2:
> > - Also protect memcg_path_show() and path_show() with damon_sysfs_lock,
> >   since sysfs show and store callbacks can run concurrently and a
> >   lockless read in show can race with the kfree in store. (Sashiko AI)
> 
> As I abovely commented, I'm not sure that Sashiko comment is correct.
> 
> > 
> >  mm/damon/sysfs-schemes.c | 36 ++++++++++++++++++++++++++++--------
> >  1 file changed, 28 insertions(+), 8 deletions(-)
> > 
> > diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> > index 5186966da..1a890e2a4 100644
> > --- a/mm/damon/sysfs-schemes.c
> > +++ b/mm/damon/sysfs-schemes.c
> > @@ -533,9 +533,14 @@ static ssize_t memcg_path_show(struct kobject *kobj,
> >  {
> >  	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
> >  			struct damon_sysfs_scheme_filter, kobj);
> > +	ssize_t len;
> >  
> > -	return sysfs_emit(buf, "%s\n",
> > +	mutex_lock(&damon_sysfs_lock);
> 
> I read Sashiko is commenting [2] about possible ABBA deadlock, and suggesting
> mutex_trylock().  I think that makes sense.  damon_sysfs_lock is always only
> mutex_trylock()-ed for the reason.
> 
> > +	len = sysfs_emit(buf, "%s\n",
> >  			filter->memcg_path ? filter->memcg_path : "");
> > +	mutex_unlock(&damon_sysfs_lock);
> > +
> > +	return len;
> >  }
> 
> And I'm unsure if this change for memcg_path_show() is really needed.
> 
> >  
> >  static ssize_t memcg_path_store(struct kobject *kobj,
> > @@ -543,15 +548,20 @@ static ssize_t memcg_path_store(struct kobject *kobj,
> >  {
> >  	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
> >  			struct damon_sysfs_scheme_filter, kobj);
> > -	char *path = kmalloc_array(size_add(count, 1), sizeof(*path),
> > -				   GFP_KERNEL);
> > +	char *path, *old;
> >  
> > +	path = kmalloc_array(size_add(count, 1), sizeof(*path), GFP_KERNEL);
> >  	if (!path)
> >  		return -ENOMEM;
> >  
> >  	strscpy(path, buf, count + 1);
> > -	kfree(filter->memcg_path);
> > +
> > +	mutex_lock(&damon_sysfs_lock);
> 
> Let's use mutex_trylock().
> 
> > +	old = filter->memcg_path;
> >  	filter->memcg_path = path;
> > +	mutex_unlock(&damon_sysfs_lock);
> > +
> > +	kfree(old);
> >  	return count;
> >  }
> 
> Same comments for path_show() and path_store() changes.
> 
> [1] https://docs.kernel.org/process/submitting-patches.html#commentary
> [2] https://lore.kernel.org/20260420183146.0DA7AC2BCB0@smtp.kernel.org
> 
> 
> Thanks,
> SJ
> 
> [...]

Sent using hkml (https://github.com/sjp38/hackermail)

