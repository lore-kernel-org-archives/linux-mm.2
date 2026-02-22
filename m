Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE75DC5DF73
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 04:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60A9B6B0088; Sat, 21 Feb 2026 23:10:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B87E6B0089; Sat, 21 Feb 2026 23:10:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C45C6B008A; Sat, 21 Feb 2026 23:10:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36DB66B0088
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 23:10:22 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66BD659BE7
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 04:10:21 +0000 (UTC)
X-FDA: 84470765442.10.8857812
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5A04A80004
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 04:10:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n7McUW9t;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771733419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GaVVUXcjxIxCo1C+WnEbc4wHRZyroHOv+RROfAMIzMU=;
	b=H2wycCagkVAvnvCNSP7WOdQdLwUnUB5RiOtXMRhsFiwT95Hv5GrhdLgnn/6D2eezGEdgWz
	DlB2c0KDtwX6VOptyectcb5EKryBhwfybhgNkdlYYcs4zzVX/b0cBVcxFQG8thm64kpKFe
	sMvIquuEn22/8j5OFkAn33NT+kKyWbI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n7McUW9t;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771733419; a=rsa-sha256;
	cv=none;
	b=rg10q2aSU5e4/NtNepY8IkL//urfGLcoqIACKAHB+oZHTsULcHaWN5D7Pqdgg1Au6Sst5Z
	mIlTQqMrYlazF/75qdQow4Ki8wfIT/E4oOcmM2rWBTIIXnDWC8vWf0K6h/nAtQQRSkqtZE
	rrkOvWvoGEHaTxfT5A4cGf4McIWLCn8=
Message-ID: <448363f3-34d6-4d36-b827-9b81023230ec@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771733414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GaVVUXcjxIxCo1C+WnEbc4wHRZyroHOv+RROfAMIzMU=;
	b=n7McUW9tN38exYfI85ypc+GpKAIdQoL0+UyhfreVAv+vIEZNK+OfcECP8fI9N9FqicCn4x
	o3Qsj7S+EgPhctDFdG6HHGIm1TIr4A9eizfnsy3KuZzN9Xi32TFpBrZRiXGohGNHjyrIif
	35d8g91YmwFh4PJJWSnFZjb2WZk1Ets=
Date: Sun, 22 Feb 2026 12:10:06 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm: thp: deny THP for files on anonymous inodes
Content-Language: en-US
To: Ackerley Tng <ackerleytng@google.com>,
 Deepanshu Kartikey <kartikey406@gmail.com>
Cc: baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 linux-mm@kvack.org, npache@redhat.com, linux-kernel@vger.kernel.org,
 Liam.Howlett@oracle.com,
 syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, ryan.roberts@arm.com,
 stable@vger.kernel.org, ziy@nvidia.com, dev.jain@arm.com, i@maskray.me,
 baohua@kernel.org, shy828301@gmail.com, akpm@linux-foundation.org,
 david@kernel.org
References: <20260214001535.435626-1-kartikey406@gmail.com>
 <b398d163-7b58-402b-a37d-9562d658a62d@linux.dev>
 <CAEvNRgGLAnZkfPZt32-wyCaefu-tvG9WcX3zq1Xe7fsTabZqmA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <CAEvNRgGLAnZkfPZt32-wyCaefu-tvG9WcX3zq1Xe7fsTabZqmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A04A80004
X-Stat-Signature: ajzbxtd6td8hzbdpjp7pe8yz4jfkzpt1
X-HE-Tag: 1771733419-247871
X-HE-Meta: U2FsdGVkX19B9I2rsPbh0hOQtGmfjNMRMcA9MZA0ES0tVN6v0mytJBDTVJZeY7eHS5pHEU8vsdqH9cz2lca6FDnjB/HMkfMn1ACsvjoN+8p2LOM1V+Z3Cn1SRoQWt+IQHXzWGKWxE948MH6lR5NjOM+7PJ1lk675Nj0CJ7dpAcoSKyM95CnlEcuPO0So+L6cYbH1PCDuwadW/VeBCEpVxRMNrlzUBaLhsCFRMbB5eLytsbWIl55c86leqPaNiNwkDsvi7E4EYAi6rGww3eWOTlorPtCxhR5TbDikT4tjt5B93JQDE6Sk2WuPopOJuZoVOrIGL/yxINd2kVHVptbNctS7qS1LP/3sIwAD8cN/d6Tda9JbR8Vq994SVGNAbwpH+pIK/ITE7dduMvGbpFCZAIBQvX3+Pi/n1XZDOlT6bYE6MLcPhjJWG1xrCavqZIXHk66MeTjjQNkkHvNkhbBv8uh8ic47uYYH2egqYcskb9pFlEPjwZXQRVEv9Rn1dt4Vzbw9YnVyP7lJ2q6tjF+AGU6blz/igfuoFri1it8Qk/qmXASDqQh8OJLXljtF3mymf59yxOVAc5beNV8YQAdzd7O9cnsuXGA382BQTPb6r7uaSeZEt8jsvGvUGwMlfAQ88I0PqIJsODWAnQ7KpRAZfenIYG5R18es6PHEXeNifRU6Q0A7o7msgK7mDoy7mGqCKL3bcjZJoOaj2LCmd0I5iomKUlG6K71UEDKSjV/FRxAPcFc9cAptppYNfRlRg71z7Jy6yMFEUZyD288hoqOMKFbRXGwVIyjs/V+zc/jJfmt61w9oedTMyuzm6ym9nmRUKgshj3LFfXJmKn0huI64pOiAF6SkKifYpMcuRiFErrXKKA0z4GiPuEphAJ0rMGLFcCUdbWEe1LIlHnaYK8OR6sHoE1dKG6drlaQv7IVmOWjvCwOmt3KT2QyYsjcxYXm1/vWKU8AQZj23Wswmkfj
 AJ0XQF0s
 krLxtgOdLtgBRQiYXK7okewcJQh496KNdOOEgbmPu2YCCyWOf1Yv7j40sDQVcWwjCNXlJjX/h6YOoJULUkdlyYwg5iI5MNzbo8dACpjkKxsedTKHW/JQPIAUHVLP5u3h4uX0Pe4aB7sTdjUln4ejnVNWIjjFz6HnQPjrzctSQFH47T7kUFcvVRRkWGQXPg6C643djocTkCg+1LMSdNo28NDqQy8J8q/0GpF74nXYrGwMJTR3zrDIJDDGJuBbI0kuNIj0d5z4XS6MY2a+xfE5/e7GKVfCaar8uV+AdzaqJxb8wknh9HRCGoBIGOWL+qj2VdIsfXbdqHWMB4M5Ej6TtABc1W2SGFcxFPZui
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/16 06:48, Ackerley Tng wrote:
> Lance Yang <lance.yang@linux.dev> writes:
> 
>> On 2026/2/14 08:15, Deepanshu Kartikey wrote:
>>> file_thp_enabled() incorrectly allows THP for files on anonymous inodes
>>> (e.g. guest_memfd and secretmem). These files are created via
>>> alloc_file_pseudo(), which does not call get_write_access() and leaves
>>> inode->i_writecount at 0. Combined with S_ISREG(inode->i_mode) being
>>> true, they appear as read-only regular files when
>>> CONFIG_READ_ONLY_THP_FOR_FS is enabled, making them eligible for THP
>>> collapse.
>>>
>>> Anonymous inodes can never pass the inode_is_open_for_write() check
>>> since their i_writecount is never incremented through the normal VFS
>>> open path. The right thing to do is to exclude them from THP eligibility
>>> altogether, since CONFIG_READ_ONLY_THP_FOR_FS was designed for real
>>> filesystem files (e.g. shared libraries), not for pseudo-filesystem
>>> inodes.
>>>
>>> For guest_memfd, this allows khugepaged and MADV_COLLAPSE to create
>>> large folios in the page cache via the collapse path, but the
>>> guest_memfd fault handler does not support large folios. This triggers
>>> WARN_ON_ONCE(folio_test_large(folio)) in kvm_gmem_fault_user_mapping().
>>>
>>> For secretmem, collapse_file() tries to copy page contents through the
>>> direct map, but secretmem pages are removed from the direct map. This
>>> can result in a kernel crash:
>>
>> Good catch, thanks!
>>
>> For secretmem, file_thp_enabled() can incorrectly return true
>> (i_writecount=0, S_ISREG=1), so the mapping becomes eligible for file
>> THP collapse ...
>>
>> However, if any folio is dirty, collapse bails out early with
>> SCAN_PAGE_DIRTY_OR_WRITEBACK, as secretmem doesn't support normal
>> writeback, IIUC.
>>
> 
> Yup! In the reproducers [1] I had to try to avoid setting the dirty flag
> on the pages.
> 
> [1] https://lore.kernel.org/linux-mm/CAEvNRgHegcz3ro35ixkDw39ES8=U6rs6S7iP0gkR9enr7HoGtA@mail.gmail.com
> 
>>>
>>>       BUG: unable to handle page fault for address: ffff88810284d000
>>>       RIP: 0010:memcpy_orig+0x16/0x130
>>>       Call Trace:
>>>        collapse_file
>>>        hpage_collapse_scan_file
>>>        madvise_collapse
>>>
>>> Secretmem is not affected by the crash on upstream as the memory failure
>>> recovery handles the failed copy gracefully, but it still triggers
>>> confusing false memory failure reports:
>>>
>>>       Memory failure: 0x106d96f: recovery action for clean unevictable
>>>       LRU page: Recovered
>>
>> Right. On my setup, that would hit SCAN_COPY_MC in
>> hpage_collapse_scan_file()
>> rather than a hard crash.
>>
> 
> Deepanshu, were you able to trigger a hard crash on some earlier kernel?
> I only saw this false memory failure log.

On a setup where memory failure recovery works, we can trigger a panic by
disabling recovery:

echo 0 > /proc/sys/vm/memory_failure_recovery

Then we would hit the following panic:

[  117.608411] Kernel panic - not syncing: Memory failure on page 1024d6
[  117.609490] CPU: 4 UID: 0 PID: 168 Comm: kworker/4:1 Not tainted 
6.19.0 #83 PREEMPT(full)
[  117.610817] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 0.5.1 01/01/2011
[  117.612121] Workqueue: events memory_failure_work_func
[  117.612978] Call Trace:
[  117.613401]  <TASK>
[  117.613766]  dump_stack_lvl+0x60/0x90
[  117.614382]  dump_stack+0x14/0x1a
[  117.614940]  vpanic+0x1a6/0x470
[  117.615476]  panic+0xc0/0xc0
[  117.615967]  ? __pfx_panic+0x10/0x10
[  117.616571]  ? update_cfs_rq_load_avg+0x5f/0x5a0
[  117.617336]  ? dequeue_entities+0x250/0x1e30
[  117.618043]  memory_failure.cold+0x2d/0x2d
[  117.618725]  ? __pfx_memory_failure+0x10/0x10
[  117.619451]  ? __raw_spin_lock_irqsave+0x8d/0xf0
[  117.620215]  ? __switch_to+0x3e9/0xb60
[  117.620841]  memory_failure_work_func+0x150/0x200
[  117.621621]  process_one_work+0x63d/0xf50
[  117.622292]  worker_thread+0x517/0xd90
[  117.622915]  ? __pfx_worker_thread+0x10/0x10
[  117.623629]  kthread+0x369/0x460
[  117.624169]  ? __pfx_kthread+0x10/0x10
[  117.624796]  ret_from_fork+0x33a/0x660
[  117.625422]  ? __pfx_ret_from_fork+0x10/0x10
[  117.626126]  ? switch_fpu+0x19/0x1f0
[  117.626728]  ? __switch_to+0x3e9/0xb60
[  117.627354]  ? __pfx_kthread+0x10/0x10
[  117.627978]  ret_from_fork_asm+0x1a/0x30
[  117.628633]  </TASK>
[  117.629316] Kernel Offset: disabled
[  117.629902] ---[ end Kernel panic - not syncing: Memory failure on 
page 1024d6 ]---

