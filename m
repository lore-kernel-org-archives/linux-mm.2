Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 176AEF5A8D1
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 01:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31B136B0088; Mon, 20 Apr 2026 21:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CC3B6B0089; Mon, 20 Apr 2026 21:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2396B008A; Mon, 20 Apr 2026 21:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B66B6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 21:20:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 99A775C2F1
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 01:20:40 +0000 (UTC)
X-FDA: 84680808240.09.644E281
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D5E394000A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 01:20:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r0NYO6Qg;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776734439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q6z8F6iHQcK8WfzMTDdzVV1JwoDk8sTGNPxzTmzDGKg=;
	b=zX6xW2YhG2U6WtMZ1NIG0eLhioNVuxBZB3JesIixTJURQ3PmCz//qUvQndn/x9atai++PN
	7H8iZJ7tW+QPxJEw5eY6RoyvI9aM/QyO4LCb81GGljJ8wT1gGgsJ6GN64rv2DDkSG1j9GB
	sJCMrIFtKjQ5VMN4oV2uT98zwvtuPMs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776734439; a=rsa-sha256;
	cv=none;
	b=5RHwBz3AnX1Kwb8SP8UwLkNVMJDc17knDIo8MCiwSHo74ar1G9UjEbDHNbSSBxzPRE1wsn
	MtI2BopCwjxGWQiJt+mGVzKWVHKxomJPjwUJ4KKyg6+6n3itZ/ctzAECocUERE75Zd/+LM
	w/h/YU4gLg16BR9bK7yQqsZmTpdE9Oc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r0NYO6Qg;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A4DD64048F;
	Tue, 21 Apr 2026 01:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F46EC2BCB3;
	Tue, 21 Apr 2026 01:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776734437;
	bh=kFjPHjdqXPh1vzTeTNAYLlOo6NQK1J4F1ZAd2Ygq2Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0NYO6QgOQnz7w0hGW6fe+snBccFuqDWJoNXEh5XR3kO9qkpDi240W2SQeqIiWg7n
	 VxSvuCD3UHDRTxvB9HlEISY1HtCjI8EKNHdWnN4nhBGWax3+i7Oh2fpFLAoFxL1I/F
	 WFzcldkI++wq3fxJp0UXiujq1YwUhbt7YTAa7bpKr6JUfNncHcwKv/R/iHsroFU0Rp
	 on1bUR8C9SU6AfcPxOOCt5eTaQT1zaioluBPSDg+iWQVAahgq+Vnw+TeJISnj0zmAp
	 L1mE3xskQMApGmmc/1iFqbGOh5s3YqHnPBw5LJzmeTvutQtvch5ASKwEp3N3dFq2KS
	 dG9qLfd0NQeXA==
From: SeongJae Park <sj@kernel.org>
To: Junxi Qian <qjx1298677004@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/sysfs-schemes: fix use-after-free on memcg_path and goal path
Date: Mon, 20 Apr 2026 18:20:27 -0700
Message-ID: <20260421012028.67143-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260420125405.362137-1-qjx1298677004@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xjq88cu4d8xohe9wa38jee75kewmsxis
X-Rspam-User: 
X-Rspamd-Queue-Id: D5E394000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1776734438-886710
X-HE-Meta: U2FsdGVkX1/PHz3DplWJXqvxoNATnGMpI9BFZdX/98KnmOOtX1Bx2T1pVMUQRp2m32Z+uV5k8rLcM1Hl6ukOIWPpMvUsNVh1iQ6irbgbB3dYGr3flmpd7YLZ/RAx9B76MV8cewHQsjTejzU7/mQ5emh5mYvIgpJpBuw5wodlzk+Vp+WRlDJtS9BZaVxjFx//QYQ1bzQ5KilX41xY/k0wW7FB4czyGUwcytTax07ugZxdKvY9fBA3f/ET5FtDz87rRY86lVeYDZ8yHrMM9TpzMxDz01MrOaboAEow6Yxx0iB+/jhEKya1CwnsBwQCjqu22WUKvClPtdIxkIca/WdOMvpsZIUjiqMSnBk5/sZFoYRm5OQ0R9R8CFR0jnzUEw+mQYEXvyE1yy6TwR0MeQpvLP9YpM9mbEW8PWELm6DOM80TIZXgbNQ3N0r3am7K3vuFn+mWoQv6b4L0QR54t9rgVpXtxT5qm4lupwG3CzkMYVBqhYeDPUHDl+DRSpU++o4R6LOG07kLehFg2to597P91Rn/YRVENoHWCmBzRgsuPUF15IYis8kitNeTdBJTdeYsVeHAXbNDxysH+9fa1vYYj0t9wp7LVYCDOp2cPina9QoqaS8U0OwNvXMQ1z+d2ngzmgNCx9n64Qb+whn9RWtABe4qEfxMa6QxIsFZg/kscPqg4fFFgveEo6beMRlOF6TXbah9sdJCvjak/QTCRBgLIt6ee/cVO0eVw1NBgx/OMXPxK4BcLyouAU6Lh6KWRpOUciNkRQYmjAkaoYyXEDFr/RTr5KT6EQjYGNV3kw1Esmg4E5SKBjJTPa+o72Y/16kFJnHB+6YDjTnm7D9ftGSeqYIm1MdJ9ByxkB/zWGqSpswNiSvmrE5fVe7e18gxDXkxzAAGTKb+xiqHdv49sFnKPTNLdZBado/aEliaDJcoFmz5B0gvRt83psS8wm7q2t02FevCsd+ZhNzkOzO1PNP
 uK9lYlIq
 9V90qgREcgpKJnpCjgOU0d0XrN28otMibGY/iEyAS2vitVVwYx0MAOcP0J8UZ3WweJrBelbqVjFyKKr4nXnZYm5BbRuelDz21FH7hkd336NcIvYj3wkgmiFIE0hK7BkwZ3bfVyekoKUwQrdmZiVLsvK6Hf4cSdCsRiUFzGggVeGrOTlNbsguEXf9z9D42dcH5Q/crBHPgJSNMMCXW2VqsHKJtMv26ouA0u+xU7WGxiBogwilArbUEZZatZhpPOQzjMpyS3LpzHRqWKaxadvOSQhKF8XlcsEjm8L8ujNB4p0fcLw5VxW+FdudLRm3NdbopwXDq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Junxi,


When you send a new version of a patch, please send it as a new mail with
changes log [1], rather than as a reply to the old version.

On Mon, 20 Apr 2026 20:54:05 +0800 Junxi Qian <qjx1298677004@gmail.com> wrote:

> memcg_path_store() and path_store() free and replace their respective
> string pointers without holding damon_sysfs_lock. This creates a race
> with the kdamond thread, which reads these pointers in
> damon_sysfs_add_scheme_filters() and damos_sysfs_add_quota_score()
> via damon_call() during a "commit" operation.
> 
> The race window is as follows:
>   Thread A (commit):  holds damon_sysfs_lock, triggers damon_call()
>   kdamond thread:     reads sysfs_filter->memcg_path in
>                       damon_sysfs_memcg_path_to_id()
>   Thread B (sysfs):   calls memcg_path_store() WITHOUT lock,
>                       kfree(filter->memcg_path), replaces pointer
> 
> Since Thread B does not hold damon_sysfs_lock, the kdamond thread can
> observe a freed pointer, resulting in a use-after-free when
> damon_sysfs_memcg_path_eq() dereferences it for string comparison.

Thank you for finding and sharing this bug!
> 
> Similarly, memcg_path_show() and path_show() read the string pointers
> without holding the lock, so a concurrent store can free the string
> just before sysfs_emit() dereferences it, causing a use-after-free.

Is this correct?  Isn't sysfs prohibiting such concurrent read/write using
kernfs_open_file->mutex?  Were you able to trigger this?

> 
> KASAN reports the following on v7.0.0-rc5 with CONFIG_KASAN=y:
> 
>   ==================================================================
>   BUG: KASAN: double-free in memcg_path_store+0x6e/0xc0
> 
>   Free of addr ffff888100a086c0 by task exp/149
> 
>   CPU: 1 UID: 0 PID: 149 Comm: exp Not tainted 7.0.0-rc5-gd38efd7c139a #18 PREEMPT(lazy)
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x55/0x70
>    print_report+0xcb/0x5d0
>    kasan_report_invalid_free+0x94/0xc0
>    check_slab_allocation+0xde/0x110
>    kfree+0x114/0x3b0
>    memcg_path_store+0x6e/0xc0
>    kernfs_fop_write_iter+0x2fc/0x490
>    vfs_write+0x8e1/0xcc0
>    ksys_write+0xee/0x1c0
>    do_syscall_64+0xfc/0x580
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>    </TASK>
> 
>   Allocated by task 147 on cpu 0 at 12.364295s:
>    kasan_save_stack+0x24/0x50
>    kasan_save_track+0x17/0x60
>    __kasan_kmalloc+0x7f/0x90
>    __kmalloc_noprof+0x191/0x490
>    memcg_path_store+0x32/0xc0
>    kernfs_fop_write_iter+0x2fc/0x490
>    vfs_write+0x8e1/0xcc0
>    ksys_write+0xee/0x1c0
> 
>   Freed by task 150 on cpu 0 at 13.373810s:
>    kasan_save_stack+0x24/0x50
>    kasan_save_track+0x17/0x60
>    kasan_save_free_info+0x3b/0x60
>    __kasan_slab_free+0x43/0x70
>    kfree+0x137/0x3b0
>    memcg_path_store+0x6e/0xc0
>    kernfs_fop_write_iter+0x2fc/0x490
>    vfs_write+0x8e1/0xcc0
>    ksys_write+0xee/0x1c0
> 
>   The buggy address belongs to the object at ffff888100a086c0
>    which belongs to the cache kmalloc-8 of size 8
>   ==================================================================
> 
> Fix this by holding damon_sysfs_lock while swapping the path pointer
> in both memcg_path_store() and path_store(),

I'd like to avoid use of the lock in long term.  But this sounds good and
simple for hotfixes.

> and while reading the
> path pointer in memcg_path_show() and path_show().

As I commented above, I'm not sure if this is really needed.

> The actual kfree()
> is moved outside the lock since the old pointer is no longer reachable
> once replaced.
> 
> Fixes: 490a43d07f16 ("mm/damon/sysfs-schemes: free old damon_sysfs_scheme_filter->memcg_path on write")

I think this deserves Cc-ing stable@.

Also, this patch is fixing two bugs.  For making backport of the fixes easy,
could we split this patch into two patches, one for memcg_path_{show,store}(),
and the other one for path_{show,store}()?

> Signed-off-by: Junxi Qian <qjx1298677004@gmail.com>
> 
> ---
> Changes in v2:
> - Also protect memcg_path_show() and path_show() with damon_sysfs_lock,
>   since sysfs show and store callbacks can run concurrently and a
>   lockless read in show can race with the kfree in store. (Sashiko AI)

As I abovely commented, I'm not sure that Sashiko comment is correct.

> 
>  mm/damon/sysfs-schemes.c | 36 ++++++++++++++++++++++++++++--------
>  1 file changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> index 5186966da..1a890e2a4 100644
> --- a/mm/damon/sysfs-schemes.c
> +++ b/mm/damon/sysfs-schemes.c
> @@ -533,9 +533,14 @@ static ssize_t memcg_path_show(struct kobject *kobj,
>  {
>  	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
>  			struct damon_sysfs_scheme_filter, kobj);
> +	ssize_t len;
>  
> -	return sysfs_emit(buf, "%s\n",
> +	mutex_lock(&damon_sysfs_lock);

I read Sashiko is commenting [2] about possible ABBA deadlock, and suggesting
mutex_trylock().  I think that makes sense.  damon_sysfs_lock is always only
mutex_trylock()-ed for the reason.

> +	len = sysfs_emit(buf, "%s\n",
>  			filter->memcg_path ? filter->memcg_path : "");
> +	mutex_unlock(&damon_sysfs_lock);
> +
> +	return len;
>  }

And I'm unsure if this change for memcg_path_show() is really needed.

>  
>  static ssize_t memcg_path_store(struct kobject *kobj,
> @@ -543,15 +548,20 @@ static ssize_t memcg_path_store(struct kobject *kobj,
>  {
>  	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
>  			struct damon_sysfs_scheme_filter, kobj);
> -	char *path = kmalloc_array(size_add(count, 1), sizeof(*path),
> -				   GFP_KERNEL);
> +	char *path, *old;
>  
> +	path = kmalloc_array(size_add(count, 1), sizeof(*path), GFP_KERNEL);
>  	if (!path)
>  		return -ENOMEM;
>  
>  	strscpy(path, buf, count + 1);
> -	kfree(filter->memcg_path);
> +
> +	mutex_lock(&damon_sysfs_lock);

Let's use mutex_trylock().

> +	old = filter->memcg_path;
>  	filter->memcg_path = path;
> +	mutex_unlock(&damon_sysfs_lock);
> +
> +	kfree(old);
>  	return count;
>  }

Same comments for path_show() and path_store() changes.

[1] https://docs.kernel.org/process/submitting-patches.html#commentary
[2] https://lore.kernel.org/20260420183146.0DA7AC2BCB0@smtp.kernel.org


Thanks,
SJ

[...]

