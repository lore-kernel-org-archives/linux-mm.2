Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FA1DC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 11:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D11EF6B00EE; Tue, 30 Jun 2026 07:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3006B00EF; Tue, 30 Jun 2026 07:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB1446B00F1; Tue, 30 Jun 2026 07:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89F786B00EE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:50:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 027E540167
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:50:28 +0000 (UTC)
X-FDA: 84936411378.21.0CDF389
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 213E4140012
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:50:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qn/MLd0I";
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782820227;
	b=FV18lHIfpeqRFfUtHYy3qHA9U8TlMWHgDZCFOhBjHgHlwQQlNCxm+Ba0/3q3gcxcyHuc2D
	KMCYFan7bgDn3sjRi725IHdv/UfnHEjc++0d56/nkOawfKyVVDgmfqTaVDDPH4/+7z+GWp
	HoKGK/UiDQoc6JpS6AYa8enSDXnWL4U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782820227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3hvYV5F0HW0mYVPFBJ5mN9I6k/uFTqbAUDyOTxMxApM=;
	b=rOVZp0SM2PevHwknA5OtAEklSPxjXOtzMd0TDuj7rsljQrOE6h/y4WALDLMJKUr27VMVK1
	oDhvVxIj7k24TnCIDXlUywk4k78niuiK/vSYh2CXSHknUxpIXzuXL+ukXtX7wQCyoNRXBH
	kxwMY+XGyG6OqisVy8nhuNrDeBvx7ao=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qn/MLd0I";
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3227B40392;
	Tue, 30 Jun 2026 11:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE0E1F000E9;
	Tue, 30 Jun 2026 11:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782820226;
	bh=3hvYV5F0HW0mYVPFBJ5mN9I6k/uFTqbAUDyOTxMxApM=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Qn/MLd0IR9HhW5yyfEPkQdczgybpj6ZHAL5gWPmsj+kj4IeZeVRWZtSpyu+1A2FdM
	 2ZyMMciF3ki5YHFMc8oc4j80ho6bITrjzD4UVfRqR/OPYTN45K9zEAc/flFdFbyk2R
	 z2EYNIIe6T5B0Sq/czI8I4URtdh8zrHP/d3fUXvsKBOQPhrD95yEpJA95OGtMdkelW
	 wiPCKMJ4khAT1bT/Zd/tAfNfK7m1Hkr2ollgHMDgfs0cNkD0JZPtX8bhIA64uaHQlc
	 K/jUCgrGi2gBNZQsGt/3SSPL6TJLSM5KS+aoZoC8mFHlXgBDXj81P6b3LyXyyeMx5Y
	 v04guXcnlpoAQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5] coredump: Add bit 9 of coredump_filter for pre-exit
 files before dumping
From: Christian Brauner <brauner@kernel.org>
To: Xin Zhao <jackzxcui1989@163.com>
Cc: brauner@kernel.org, ljs@kernel.org, rppt@kernel.org, pfalcato@suse.de, 
 viro@zeniv.linux.org.uk, corbet@lwn.net, skhan@linuxfoundation.org, 
 akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, 
 vbabka@kernel.org, surenb@google.com, mhocko@suse.com, mingo@redhat.com, 
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
 mjguzik@gmail.com, ebiederm@xmission.com, jack@suse.cz, jlayton@kernel.org, 
 chuck.lever@oracle.com, alex.aring@gmail.com, arnd@arndb.de, 
 keescook@chromium.org, mcgrof@kernel.org, j.granados@samsung.com, 
 allen.lkml@gmail.com, kuba@kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-mm@kvack.org, linux-doc@vger.kernel.org
In-Reply-To: <20260630075604.52533-1-jackzxcui1989@163.com>
References: <20260630075604.52533-1-jackzxcui1989@163.com>
Date: Tue, 30 Jun 2026 13:50:15 +0200
Message-Id: <20260630-alzheimer-mahlzeit-mutlos-4641a5947a04@brauner>
X-Mailer: b4 0.16-dev-96101
X-Developer-Signature: v=1; a=openpgp-sha256; l=11283; i=brauner@kernel.org;
 h=from:subject:message-id; bh=tzPpk1pFeWsU9LkYgsibQI8shjhjR4OoibGXFRUEm4Y=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ5r60863RqWXlA83r9b0emcORnKa08ddLzFqfK0br13
 69mcWtnd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzEcBfDP6vvBs0qbBsaracU
 x3rcjpv1XHlGOdNT5caKXPME5VuPJBkZfhVn5K/bdnLDicYVa57kJdrJzj6o61B9aW+AZnOp+8s
 wdgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 213E4140012
X-Rspam-User: 
X-Stat-Signature: 6saunxht88kkz8i74so6hopp68gi7boi
X-HE-Tag: 1782820226-872258
X-HE-Meta: U2FsdGVkX1+ewlIlUDweLDqceTvIl7hAZJ49TLrZXQp6bJpPyHfQttQXXBiFUPXI9Rv84WASiGoO4yVwQsBH0CdsbkbU8BBoM7XIynQL+wvn9ISwak3+VErN7sQTXiDPw3PAbF+FlME7H/68HYmid6TLAqPNpirza0QI+7Du5kjqeHHW9AG6dilIKEkeFIK2UPGYv+CPcB3RWzZyK0y5StTUnvLl5qPxOuvS73PNKF7dtDn220HkoU+gqM4WJiFO53TpSl/KXtIXRH6B4j0vDS/gAH8QL1IAeU26YMkLDeAeoV8wMzD/zSnvViOV/H5VAxVPOwuxKOEKGTX+xp9cFLgYhDzF5SWAkfuQmaDLQz2OIUzO489fe0SkjdT6DJOjRj63FkFJXZx3EH0zCumTJOEUAtl0PHzh3N60BvJDBV/T7kYdUA90ucyF+JksqBQDntYUzMp2tIWrWx/OS8OB1QKuCpTvJmZAxGUq6IPiPgw7FNcuvYWLWJ2Ufp3l80FG/zT46gviaLJ+K6y05CyG/4/Nmgsj80cruWtjD2GxJhZ4cOCINiINN9BTsGHVewYu4P+25+U/epLoQdopcSXQnRRu3AjtspYznSBa788AKiEltZCVaI5FIY6+CMBeTvfIeWdO0nWIxdi1InX5XDNaTFT7lXUrjmes8xTObk910Iz+Jb1d0MacD+eDAyFUfWngnf7LAaGhwHD8Y/7mzGkglT/WztEnS4tuKRS7mSxWFdf+WhseBHxpuX2B5669RB66EAwIFEYoeF22PNvo2pwwO4hRpGwlIvFpVLUQywrLuDwKGQBm0BWyRp+UMfzde+IXutUXq2h2HGeIIj+5+7eqwRybKEow6vBDPK9sqv0F4S2gQWB3xhz6b3X8Ek/a7YZUs9vXYXSIi5w9TqWMCHVx7pHysbUMaN9Bxx345owOW5DkxZfpsfKZz7E93TS9j0ZYaqyB8ITOQSo/2Qp3pPO
 DjzxaK+t
 t43RAxFJVPfHOAtx36r/VYxEwHAcemJ5r0nZsEaurbfvmQHQlLE998GgPMoZ+tR2qPIIH1ZKKBWiTbM7gfdOIZ0TVxBV6/Q1IpxcFFFgeHkcFQO3F5xNrdYmAvjTMHtb7FCpE6mQVzsJXi4eHKO8jQTJrXDQN1dl+QzSYVc/+TwHYFcrJnC9ZTn7PIkG/fhG7mMiiVvYisUjC2FbrURQW9MdH6ulileUGYPz0JqIwAJ0608CTE6cbwIfsUJrrNTyiW5KOFKOzX9ZOnl7uIj/S4FtLiPDYnYx5/VtdgN9Ix43WyCcFweNHYiIQIcDk/tR7QhBnFg63xVqnAUVlnP76vkulwsPQkRmhmnsmSZjegttfC9EoI9WMDtG7TGhgDaS3E4ih9VsY7gD3gP2jOZrTy3RqwSlZpgXEknOxrlpgz24rDKau0nRqX0QQpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-30 15:56 +0800, Xin Zhao wrote:
> A coredump typically takes seconds or even longer to complete. If we
> happen to hold a write lock with flock just before triggering the
> coredump, that write lock will not be released during the entire coredump
> process. As a result, other processes attempting to acquire the same write
> lock may experience significant delays. Another typical scenario is that
> some custom management modules for shared memory also need to release the
> reference counts of the related buffers as soon as possible, rather than
> waiting until the coredump is complete.
> 
> Add a new bit(9) of coredump_filter to tag whether need to dump fd list.
> We set it by default because tools like systemd-coredump go through the
> fds. Some other coredump pipe programs like minicoredump do not use fds by
> default. If you are sure that your coredump backend does not use the fds,
> you can clear bit 9, which will allow some file resources without VMA
> references to be released earlier.
> 
> In fput(), check FP_DUMPCORE task flags to NOT release file by task work,
> otherwise file put operation will NOT execute util coredump finish.
> 
> Test Case One - flock
> Test program send signal SIGABRT to the program which owns the flock,
> output the wait time(unit ms) to successfully attach the flock.
> Test program malloc 500MB heap and memset it.
> If NOT set bit9 of coredump_filter, waitms is 11280.
> If set bit9 of coredump_filter, waitms is 0.
> 
> Test Case Two - ion buffer
> Test programs include ion buffer publisher and ion buffer subscriber.
> Ion buffer publisher output the ion buffer hold_time if the subscriber
> NOT send ack to publisher and NOT release it. The subscriber will trig
> coredump by itself in some time.
> If NOT set bit9 of subscriber coredump_filter, max hold_time is 19591ms.
> If set bit9 of subscriber coredump_filter, max hold_time is 320ms.
> 
> Signed-off-by: Xin Zhao <jackzxcui1989@163.com>
> ---
> 
> Change in v5:
> - Not add another bootargs for the feature,
>   as suggested by Christian Brauner and Lorenzo Stoakes.
>   Add bit9 of coredump_filter to tag whether need to dump fd list.
>   Set bit9 to 1 as default.
> - Al Viro, Christian Brauner and Lorenzo Stoakes point out so many
>   problems of the code related to umap that was added in v4, delete all of
>   it which is unnecessary. The management of reference counting for shared
>   memory generally does not need to be released through the release
>   operation of files that have VMA references. Traversing all the threads
>   within the process and executing exit_files() is sufficient.
> - Fulfill comments and commit log,
>   as suggested by Pedro Falcato and Lorenzo Stoakes.
> 
> Change in v4:
> - Christian pointed out that the coredump process will traverse file
>   descriptors (fd), so certain fds should not be closed by default.
>   Rework the whole feature, add /proc/<pid>/coredump_pre_exit for user
>   pre-exit resources selection, default is NOT pre-exit anything.
> - Mateusz suggested that walking the fd table and release the file-lock is
>   reasonable. No longer release all the fd(s). Based on user config, only
>   the flock fd(s) and the fd(s) correspondent to file-backed shared memory
>   will be released at most.
> - Link to v4: https://lore.kernel.org/all/20260624145552.70143-1-jackzxcui1989@163.com/
> 
> Change in v3:
> - Add comment and commit-log to explain why do the MMF_DUMP_MAPPED_SHARED
>   mm_flags_test() check, note that memory mapped files keep their own
>   separate references to the files. The case to work around is that early
>   unlocking a flock on a file allows other processes to lock and modify
>   the mapped data protected by the flock,
>   as suggested by Pedro Falcato.
> - Link to v3: https://lore.kernel.org/all/20260619122419.3954581-1-jackzxcui1989@163.com/
> 
> Change in v2:
> - Get rid of the implement of adding new fcntl API, the issue does not
>   worth inflicting the cost on everyone,
>   as suggested by Al Viro.
> - Call exit_files() in coredump_wait(),
>   as suggested by Eric W. Biederman.
>   Add MMF_DUMP_MAPPED_SHARED mm_flags_test() check to filter cases that
>   need to dump file-backed shared memory.
> - Link to v2: https://lore.kernel.org/lkml/20260618150301.3226517-1-jackzxcui1989@163.com/
> 
> v1:
> - Link to v1: https://lore.kernel.org/all/20260618030700.2511668-1-jackzxcui1989@163.com/
> ---
>  Documentation/filesystems/proc.rst | 14 ++++++++++++--
>  fs/coredump.c                      | 21 +++++++++++++++++++++
>  fs/file_table.c                    |  7 ++++++-
>  include/linux/mm_types.h           |  6 ++++--
>  4 files changed, 43 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index db6167bef..d590a1dda 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -1939,6 +1939,7 @@ The following 9 memory types are supported:
>    - (bit 6) hugetlb shared memory
>    - (bit 7) DAX private memory
>    - (bit 8) DAX shared memory
> +  - (bit 9) fd list
>  
>    Note that MMIO pages such as frame buffer are never dumped and vDSO pages
>    are always dumped regardless of the bitmask status.
> @@ -1946,13 +1947,22 @@ The following 9 memory types are supported:
>    Note that bits 0-4 don't affect hugetlb or DAX memory. hugetlb memory is
>    only affected by bit 5-6, and DAX is only affected by bits 7-8.
>  
> +  Note that bit 9 is set by default because tools like systemd-coredump go
> +  through the fds. If you do not set bit 9, files that are not referenced by
> +  any VMA are released before dumping core. Some file release logic, such as
> +  exiting flock or releasing references to shared buffers is executed much
> +  earlier.
> +
> +The default value of coredump_filter is 0x233; this means all anonymous memory
> +segments, ELF header pages, hugetlb private memory and fd list are dumped.
> +
>  The default value of coredump_filter is 0x33; this means all anonymous memory
>  segments, ELF header pages and hugetlb private memory are dumped.
>  
>  If you don't want to dump all shared memory segments attached to pid 1234,
> -write 0x31 to the process's proc file::
> +write 0x231 to the process's proc file::
>  
> -  $ echo 0x31 > /proc/1234/coredump_filter
> +  $ echo 0x231 > /proc/1234/coredump_filter
>  
>  When a new process is created, the process inherits the bitmask status from its
>  parent. It is useful to set up coredump_filter before the program runs.
> diff --git a/fs/coredump.c b/fs/coredump.c
> index bb6fdb1f4..ed4d30916 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -521,6 +521,25 @@ static int zap_threads(struct task_struct *tsk,
>  	return nr;
>  }
>  
> +/*
> + * If do not dump fd list, files that are not referenced by any VMA
> + * can be released before dumping core. Therefore, some file release
> + * logic, such as exiting flock or releasing references to shared
> + * buffers is executed much earlier. Note that do_coredump() often
> + * takes several seconds or even longer to execute.
> + */
> +static void coredump_pre_exit(void)
> +{
> +	struct task_struct *tsk = current, *t;
> +
> +	if (mm_flags_test(MMF_DUMP_FD_LIST, tsk->mm))
> +		return;

Why does this hanging off of mm?

> +
> +	for_each_thread(tsk, t) {
> +		exit_files(t);
> +	}

Even if we wanted to do this it is fundamentally the wrong primitive for
this. I would envision that anything that wanted to "zap" file
descriptors synchronously would either have to do it synchronously or
offload it to a delayed coredump list and wait for it to have drained.

I dislike both options... Without thorough anaylsis I'm not even sure if
taking out files out of order with other exit-related cleanup will not
end up causing fun bugs. Meaning:

[...]
exit_sem(tsk);
exit_shm(tsk);
exit_files(tsk);

anything before that might implicitly relying on files struct being
sane or some other subtle interactions. My appetite to dig into this
just to make this questionable patch mergeable isn't very high...

So I would expect anything that is serious about this would have to
communicate back to the other tasks in coredump_wait() that they're
supposed to shed their descriptor state early. I wouldn't know whether
that can be done safely without actual surgery.

Also, as was pointed out in other parts of the thread: files are shared
_across_ thread-groups not just within thread-groups. Anything that does
SCM_RIGHTS or has done some pidfd_getfd() dance - however unlikely -
might still hold that file alive and you have zero chances of getting it
out of its hands.

If this is so critical, just skip the coredump via COREDUMP_REJECT or
similar means.

> +}
> +
>  static int coredump_wait(int exit_code, struct core_state *core_state)
>  {
>  	struct task_struct *tsk = current;
> @@ -1124,6 +1143,8 @@ static void do_coredump(struct core_name *cn, struct coredump_params *cprm,
>  	if (cn->mask & COREDUMP_REJECT)
>  		return;
>  
> +	coredump_pre_exit();
> +
>  	/* get us an unshared descriptor table; almost always a no-op */
>  	/* The cell spufs coredump code reads the file descriptor tables */
>  	if (unshare_files())
> diff --git a/fs/file_table.c b/fs/file_table.c
> index 16e52e7fc..399db62f6 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -566,7 +566,12 @@ static void __fput_deferred(struct file *file)
>  		return;
>  	}
>  
> -	if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
> +	/*
> +	 * coredump_pre_exit() may release files before dumping core.
> +	 * Cannot use task_work in the case, needs to release files
> +	 * earlier."

And it does that by offloading the closing of files to a kthread that
runs asynchronously?

> +	 */
> +	if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD | PF_DUMPCORE))) {

This:

(task->flags & PF_KTHREAD | PF_DUMPCORE)

will have interesting side-effects for everyone else...

>  		init_task_work(&file->f_task_work, ____fput);
>  		if (!task_work_add(task, &file->f_task_work, TWA_RESUME))
>  			return;
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index c7db35be6..e865edb04 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1954,14 +1954,16 @@ enum {
>  #define MMF_DUMP_HUGETLB_SHARED  8
>  #define MMF_DUMP_DAX_PRIVATE	9
>  #define MMF_DUMP_DAX_SHARED	10
> +#define MMF_DUMP_FD_LIST	11
>  
>  #define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
> -#define MMF_DUMP_FILTER_BITS	9
> +#define MMF_DUMP_FILTER_BITS	10
>  #define MMF_DUMP_FILTER_MASK \
>  	((BIT(MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
>  #define MMF_DUMP_FILTER_DEFAULT \
>  	(BIT(MMF_DUMP_ANON_PRIVATE) | BIT(MMF_DUMP_ANON_SHARED) | \
> -	 BIT(MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF)
> +	 (1 << MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF |\
> +	 (1 << MMF_DUMP_FD_LIST))
>  
>  #ifdef CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
>  # define MMF_DUMP_MASK_DEFAULT_ELF	BIT(MMF_DUMP_ELF_HEADERS)
> -- 
> 2.34.1
> 
> 
> 



