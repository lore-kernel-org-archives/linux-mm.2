Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86C3FC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 09:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BC8D6B007B; Tue, 11 Aug 2026 05:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76CB46B008A; Tue, 11 Aug 2026 05:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65B146B008C; Tue, 11 Aug 2026 05:10:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36B2E6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:10:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE205A1263
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:09:59 +0000 (UTC)
X-FDA: 85088416518.15.89A5656
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1BE1740007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:09:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RLCqqLRw;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786439398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uyzzvzNRD/y1wYaupn9NyKGeEGY5rdCsEO29WGWYMac=;
	b=d7aHEGi7AvdrCsFMBc8A7SV7pakIMvvR3Sv+gdJmeEC6XQvFk1syJlyDJ7JKdbhc73vp5/
	glefx1UyI4iLg4AaD8CZ9S29Z2S8OhP1t0gPejuH5L0qhw0HUYFNUl67u0d6njfXKFrLGG
	9gwV3t1fw+mF8RDONTto9mLmh2CSbjE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RLCqqLRw;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786439398;
	b=4gkA0g5ndHlWrS8LjayQY8bdsQgT3lZ0k313ul2O2cR16FdWPspY51iLib6WC/D0+2swqz
	+DZ+azYMDzXKU9NmmyOmMY+haOw/bVuipuBLQ00WEzWvltV1p5l2cvpxFayUMCkNDPu+B3
	vDhDcg/fFm/c4LSvB9PV+w6dTRCJTVY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 43D4E4058C;
	Tue, 11 Aug 2026 09:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067AC1F000E9;
	Tue, 11 Aug 2026 09:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786439397;
	bh=uyzzvzNRD/y1wYaupn9NyKGeEGY5rdCsEO29WGWYMac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RLCqqLRwnISjALYoK8j7TalrECysnVS5E3CUJZTrDf1nYiwOQjPrfJ/UKit5z/gBX
	 tEVuhT0bpx0aOPU3+0JVhLs0Rm0cVU41KGAPscuK5CADAUcb/gysU1JROECAqjSKtd
	 rQH8WMwogAjlSYTrNE6hwvrKaC0b+O+nb10lbff4JM3qni17XYkLmd+8QYMhQilfBR
	 QZ4pDGz1VSbj6f3TRr/DMVl8ihXdzIXJTgpsx69tWalBJ30f45sy/i2BSv6UFPL7NP
	 EIJmjVutgy8VBjSO/eRwfACVtWRe2aGFInVKnekBt1mLj3QVx/DSfjXL4ZmSB1QgS5
	 LWwDUCdYxAtTw==
Date: Tue, 11 Aug 2026 11:09:47 +0200
From: Christian Brauner <brauner@kernel.org>
To: Xin Zhao <jackzxcui1989@163.com>
Cc: david@kernel.org, ljs@kernel.org, rppt@kernel.org, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, corbet@lwn.net, skhan@linuxfoundation.org, 
	akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, surenb@google.com, 
	mhocko@suse.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, mjguzik@gmail.com, ebiederm@xmission.com, jack@suse.cz, 
	jlayton@kernel.org, chuck.lever@oracle.com, alex.aring@gmail.com, arnd@arndb.de, 
	keescook@chromium.org, mcgrof@kernel.org, j.granados@samsung.com, allen.lkml@gmail.com, 
	rdunlap@infradead.org, kuba@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v8] coredump: Add bit 9 of coredump_filter for pre-exit
 files before dumping
Message-ID: <20260811-zerfallen-boiler-bissfest-cdb998278337@brauner>
References: <20260808052732.2589657-1-jackzxcui1989@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260808052732.2589657-1-jackzxcui1989@163.com>
X-Stat-Signature: kc59n17pptcreywau9xkcgq1tyj3dzay
X-Rspamd-Queue-Id: 1BE1740007
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786439397-511201
X-HE-Meta: U2FsdGVkX1/JZPQAy43vWr3SgLIl/zT+Tzl70s2AA7QHJ8NSnuu7WAn0fZGuBQdplBgZg77G9gNzLNVG5NCAne+zwkDqP4issYzEO0HQrq2RFHKEKAmDyKJBZDAPiylNWcFvpEBwQNxQoAyOylYFRrgTkrcouq1tu0iHIc+XvWh0+PheI1t+1aiuMig/qaPCpHMHqMCVQUB5r+CrrzcBzmBVSNNZUimrTZX/deS2ljN2WH0GLKZvR6k9ZP05657vgq38ooL0pfwbknDOYaBGeMZ1GIiizNh6xpQlFmsKZpLfN5G7uWc5aTowNY+fRaUkdyfg0WoSlJCmxIZa2zfsuqgxYkZhayQ/k5jdaeftqcu7CawLatGHpO63cAcEsxriF9eucHDuakvzYacYoaLODhCHvrm2e6YZtvjjpJ37bMOyKsEa1AOR5vahICDMe8Iv3xTTo1jNshoGZImEtcKt4FuGctbh2AgjMoiFrc6vA6XVhemXW8vyFAT+WfIiU+LZRTaVg1G53m4bk/BZ5iU8WBt1K5MllZ75eydwe7aFVmCBI8Z52TA+oC0oPrN4ElIorgTCd+YRFuFXqw4oilawlIOLxujAxaqFfW6pVv8GXAqJqke8kWysMw5BkBO+8qa1Dg7jK5gdrFn1tqu5N4D+iCCl/zkg3DpwMqxF0xsi0T1AIvKNMaIKftshWMZrQiCXlhM+zetyhtbH/JnR/vPVsLk8XNh7maV5fbbrR2QxpT99bl2eOH0+g0bsud++6cUn41eIers8GNed0qmTft/mCV+QUFFpJX2RTNEarHXb455Oufiksd2D+1yNiI7R0bh/db1pH7bZ1KwtyURASoC2xgWrD+L8qNZ+my4cu7pVICyxMXSEvBuxRTC8p3vkObKKjdVToOrzvLr0Fpym6c2IuB6+k1Kq6Mtzk+Of8ruaigfy45y9kGZh0Agr8DkoxfWLtMQbO3my1gEdMI04e+b
 EF/13AoF
 KUBZmDI8iARj7NdrI9G21lVDtTcxLldQCoUv0lRAebThzx77K5dIN9tcw9+GeEXBXrmBQrEmExPqe7GYSCJH/u0mN6NUbKun3ZsPur5FQc43m9Q8W0Nd1qr0vpL/5pxKxSZUnp+kTjMtLUuhy9Wwv9ecGJEtKtMyG6c/+f0rYNY/MJvqJd1J6nb9SOyD8HyVE0Gsrlgwc6/W1STAZWRQxsOJ1mRCiq9YN/w5dWCB6ZvYhpGJxPwVLjidmgD9qOABUc2uFoFlQ+lJNkCoszsWWbZrjyQJEEKCvDExgxcdoYDPlIs0FFGOR5K57LbTpNyr8nEQvHwDaKRKbcSYytN74QCFbEGDgK8ZIEftotsZvHibcfq2DetLw0oeDwsLKw2T3RRAnhVv71eOEFgXBHdWAQNWkVesQk8V5Ly0M9VDsoMyQFmEJZFJ09nJFbMtferptvs/CCixSvlGI3gppDcqEScFCfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 08, 2026 at 01:27:32PM +0800, Xin Zhao wrote:
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
> Change in v8:
> - Delete the duplicate description of default value of coredump_filter in
>   proc.rst, as suggested by Randy Dunlap.
> 
> Change in v7:
> - Fix description error in proc.rst. Since bit9 has been added, the
>   supported memory types should now be 10,
>   as suggested by David Hildenbrand (Arm).
> - Link to v7: https://lore.kernel.org/all/20260807040124.1706927-1-jackzxcui1989@163.com/
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
>  Documentation/filesystems/proc.rst | 17 ++++++++++++-----
>  fs/coredump.c                      | 21 +++++++++++++++++++++
>  fs/file_table.c                    |  7 ++++++-
>  include/linux/mm_types.h           |  6 ++++--
>  4 files changed, 43 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index db6167bef..aee03858b 100644
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
> @@ -1946,13 +1947,19 @@ The following 9 memory types are supported:
>    Note that bits 0-4 don't affect hugetlb or DAX memory. hugetlb memory is
>    only affected by bit 5-6, and DAX is only affected by bits 7-8.
>  
> -The default value of coredump_filter is 0x33; this means all anonymous memory
> -segments, ELF header pages and hugetlb private memory are dumped.
> +  Note that bit 9 is set by default because tools like systemd-coredump go
> +  through the fds. If you do not set bit 9, files that are not referenced by
> +  any VMA are released before dumping core. Some file release logic, such as
> +  exiting flock or releasing references to shared buffers is executed much
> +  earlier.
> +
> +The default value of coredump_filter is 0x233; this means all anonymous memory
> +segments, ELF header pages, hugetlb private memory and fd list are dumped.
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

Still NAK to this whole appraoch.

