Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82E81C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 04:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601BD6B0088; Fri,  7 Aug 2026 00:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1646B008A; Fri,  7 Aug 2026 00:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3376B0096; Fri,  7 Aug 2026 00:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 148B36B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:09:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7DFB1C0305
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 04:09:20 +0000 (UTC)
X-FDA: 85073143680.22.467FF55
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id CC6EA40003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 04:09:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=zKVIlxYG;
	spf=pass (imf07.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786075758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oF4tDkaGlAAglccIfmxxSdWjYIRv+c24sdYcGVwXKQY=;
	b=MOLFjE4zSBASNRbnTP+MiuMFD2wzIJUB9OFgmLWq7LuGOgJ6LpA6YK28G6Zby5IN1GWQC+
	cEtp4GKKJ3x/Xr9sALJI6nkGNlFxy0c7eUeghLh8BjiNXMErxm7nIbQN4xxYOcWwEgODBT
	thv+wpAPZ9J9sF2x8VAPt+tZdp4mR0g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786075758;
	b=8R48rFLLBrjN3Tl4fNCqXw3X1ciND/Bqof2hrP6NRJ3TFnn8Ns8BSGRH96mHjw2W4RUsQI
	+ObKSlOuW6DoYqb5iPY7dXkS6DPIPJeI4gWe65/C4NsncOZiWhKE6Q1g8cBIzno9nDHdR/
	Yb2usYTdRDnwI1v84m6fWel0xEiW9Es=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=zKVIlxYG;
	spf=pass (imf07.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=oF4tDkaGlAAglccIfmxxSdWjYIRv+c24sdYcGVwXKQY=; b=zKVIlxYGlntYCCXy0VfJNUdVxV
	3mefvEiHMJPQH04LrcYgeWaBcT9aYSqffplXGYVggTTBDMADVbab08J16tXxMqyzBuP+mN85+iFbm
	QBdUWcT0UgVYmhavqRJjAtnbt8nuR3DOrn3jECj9L05KqlrE0VhU76pcohA0AcLE+sJeZzglfmHBw
	onV+2cw+gZKfk1O1Wuv9+wQvvdcyPSnixq1etbOdTXs+eY2cpKyVTJI+uFE6cOLlPOsfw+o4K2Kb0
	p65Ov8u67qxUvJ8C9/5XUUuO34MeYuMhukvdMpmdNO0769hgWtuvpFeNHpGYyTbcLwum0cCtnXchr
	JyMvxkHg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wsBt1-000000074Fp-1HEX;
	Fri, 07 Aug 2026 04:08:47 +0000
Message-ID: <a2293778-bce7-4f88-a049-6370707694ef@infradead.org>
Date: Thu, 6 Aug 2026 21:08:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] coredump: Add bit 9 of coredump_filter for pre-exit
 files before dumping
To: Xin Zhao <jackzxcui1989@163.com>, david@kernel.org, brauner@kernel.org,
 ljs@kernel.org, rppt@kernel.org, pfalcato@suse.de, viro@zeniv.linux.org.uk,
 corbet@lwn.net, skhan@linuxfoundation.org, akpm@linux-foundation.org,
 liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, mjguzik@gmail.com, ebiederm@xmission.com,
 jack@suse.cz, jlayton@kernel.org, chuck.lever@oracle.com,
 alex.aring@gmail.com, arnd@arndb.de, keescook@chromium.org,
 mcgrof@kernel.org, j.granados@samsung.com, allen.lkml@gmail.com
Cc: kuba@kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org
References: <20260807040124.1706927-1-jackzxcui1989@163.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260807040124.1706927-1-jackzxcui1989@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CC6EA40003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ztbrb8pq385m4pu9idawngc8ewazgwba
X-HE-Tag: 1786075755-897997
X-HE-Meta: U2FsdGVkX1/bpMzq0HU056OqItM2UOc+Da9zeRI0BWGEh2UxaaOBAbuAT7Qs21sgkqCO6aV6Zh27ksi9N6Ayg880KGte8ErdkUjVPP4kACIZPHuP6pX603yn0x62jEpZIcHoFDLDuk8KxbzOdw+Gavn1Fh+2V5Ar6A1By2wRUR7i2s4O4bMo/coAyqzgEeeCtaGZP2gLXKlNYLc6Iv883+6BdFdkJxrLCYo0PCWD/oE7fI70l3+Dcf9D/KxEFo186q0+xb7JbjLJTbfjxeYqgq53dcpbG209Q7nacZnfWe3oBYK7tsGcWm/ucEk3BOqkIpNgiwKEhXkSx3WkAXD6rPZuGqOu5Olxf7vHIoyunr0wUoIbdFfMEyTMYWLrvthi1eevitvwQQq5FygSZQEkUbfNUYohRGX5nblstebRHyDF5o3xI2O0J4FEfL88q8xQjJia7DR6mw1Gv1jfYm9vPzzaKvog3b0Y7Tjym5KIaoDmpxkHevQYq0UCBgy20wM+L/sZ2oxxGzEObkdn5VroVqW5/OXDbvTJHIMiCbOwmkzwJPrDUTPIe+p5C0HYyc6bmJtnP4roM/GL/UEc0w+/MP91qHwFjvsMSctVN1Im1BGek/22vvK/qD0wLnyWvCcorVHlWYhSkKQESFdYMnz59F0W7jlLiNIMLf50gQaZ4amFhTeWyDHEtynSs31iuUvi6GdXSYfXU3rVSytPdopeR2jI3ZoSavFGjCwqDqC8Y3qMYdKBUqi0Q3Hjo6wubn2oHCTncR57Ivm7lShs1bdJimPOGMYzoefHYDy1OcE26Nvan4PM0Z6izMI9EZITM6tFSmGS3CcS66e0u5VlZwyFBE/xMqLoRhBd8v/nMu/rdz9SWvdee7siMKm1qd9/8f1rGO6PjpKPBraAHVSIeMsHXTGjbjdra63LwC/kNIO+0jvjEh/QwyYIQZLea8ZNWmd7NXXyAXoQpVT1IrJptIH
 8Ogmr5bP
 wgX3TsgI7RUeNfGRzs2t6wdA1IJeiZOeikTUDbfmkMyIesilhguHYscuEQXz/R8r66Tt8bqvA7J99jXHRFYJtjYfh0ULHI5EqfC8rVSJbUi9Isfa0lSuZlpEedvSe8hIdMRAiDXajsgk2kege6asUfnRN2FDp5CPJCP7b1oE0nUCGpg1fuIUwCD7h4TnXhJTJzLmekgGGh+j+OKsQbnV0r0lD6bEKW+p5V8NLXj7X/SMOMi7k0hAxm+QKBPUUx8sh7RdjiLl8Dj3b4/rRiWKpF2Y2X8dhqJ1iKK2T38bmVjYqV/SS5+4a5kf9BtVZpmNCEw+gDIXAQ1JOvY/OODRzUpbXsHvkoho4m8N0ipYcT4hZbK6LJyMBTLMkFUfAJYvktDDROlwClOHxdPuR/NTgultxRimptt+ANKJUEBtaEeWcXRpHDBXQuDzeSvcxNiAYHERmAjpfVaABj3M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi--

On 8/6/26 9:01 PM, Xin Zhao wrote:
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
> Change in v7:
> - Fix description error in proc.rst. Since bit9 has been added, the
>   supported memory types should now be 10,
>   as suggested by David Hildenbrand (Arm).
> 
> Change in v6:
> - Fix operator precedence in PF_KTHREAD/PF_DUMPCORE check.
> - Link to v6: https://lore.kernel.org/all/20260804001703.1340667-1-jackzxcui1989@163.com/
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
> - Link to v5: https://lore.kernel.org/all/20260630075604.52533-1-jackzxcui1989@163.com/
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
>  Documentation/filesystems/proc.rst | 16 +++++++++++++---
>  fs/coredump.c                      | 21 +++++++++++++++++++++
>  fs/file_table.c                    |  7 ++++++-
>  include/linux/mm_types.h           |  6 ++++--
>  4 files changed, 44 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index db6167bef..0728ebd73 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -1927,7 +1927,7 @@ will be dumped when the <pid> process is dumped. coredump_filter is a bitmask
>  of memory types. If a bit of the bitmask is set, memory segments of the
>  corresponding memory type are dumped, otherwise they are not dumped.
>  
> -The following 9 memory types are supported:
> +The following 10 memory types are supported:
>  
>    - (bit 0) anonymous private memory
>    - (bit 1) anonymous shared memory
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

I could easily be missing something here, but to me it appears that the
paragraph immediately above here should have been deleted (i.e., replaced
by the one above it).
Can you explain, please?

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
> +
> +	for_each_thread(tsk, t) {
> +		exit_files(t);
> +	}
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
> index 16e52e7fc..6ed8ace8c 100644
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
> +	 * earlier.
> +	 */
> +	if (likely(!in_interrupt() && !(task->flags & (PF_KTHREAD | PF_DUMPCORE)))) {
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

-- 
~Randy


