Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1867BCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 12:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4775C6B0005; Thu,  4 Jun 2026 08:59:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44F546B0088; Thu,  4 Jun 2026 08:59:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38BF56B008A; Thu,  4 Jun 2026 08:59:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2721A6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:59:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C276D1C14D9
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:59:50 +0000 (UTC)
X-FDA: 84842237340.09.E028A66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D30F9C0002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:59:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n9WYg3ti;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780577988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vAkbvi1aE+QuBjLTRFf9k039ZmQ4xmk/MiltR3U18QQ=;
	b=FWY52fv5EATmPA2c10+A3D0puFHmIrSQfpv2s3pwNQu/A6J3AVHZkZKnhg/vBAmu3/+m2j
	4vvBOUZ5FK4oFBYQoZmjj0Gs9K8LZyGyHgNRVRUK0HSDgqB3s9HWev1CJ3AhjEjDZccv3e
	BIh2pC0r+Uz00ZLHCAaTKIleK1LB+Co=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n9WYg3ti;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780577989;
	b=H6a5Nbz5UnuKb6AgDHu21/+ua8Q45BJ/PFOpfrAbc5quhq19QEhTQ7Mz4A1kjzmqxTc4JJ
	6IZSVSXj9Hrb2BC6GSA6PqgSYOQvwnduOlPHuP6A9qvspLjIITlMI/QMzntL83hPL+2EVf
	JDE7Yh6bTr8cFroC4WBv4pNG/ZXeJqI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0241841B23;
	Thu,  4 Jun 2026 12:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105D51F00893;
	Thu,  4 Jun 2026 12:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780577987;
	bh=vAkbvi1aE+QuBjLTRFf9k039ZmQ4xmk/MiltR3U18QQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=n9WYg3ti2USEyvDmhdD8MJKM6GOI1SjZ+1dpo1Z+JuyBOyKrTwIWuElHBh5bhwPd7
	 6lqoZh0U5ojY/idqOffI/bT+pTa1VQgUzyP/FUgwKqdZy57DGZ7er9XRLSk1WLUtst
	 wcYOSyFvrQwQZLLWVk4cWIMd1muMKvsuqWJVY1RDnFMh+GqKjp15cYdC+Kx2Wegu51
	 V5EeuCp8iigg6dT7v06oOPI5hh/JbogFmfVHzT3Hs/+XZxqAOIJNBD15X5wsMZUkbx
	 3+LjykpYLqCCyuZH4SJ9jzEhM51VsZLOslEXL9Yz0S5W5HjmKNNV3nCb2WORqROSWr
	 Ig3M3ip9bUBzA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 1/2] mm/process_vm_access: pidfd and nowait support
 for process_vm_readv/writev
From: Christian Brauner <brauner@kernel.org>
To: Alban Crequy <alban.crequy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Alban Crequy <albancrequy@microsoft.com>, Peter Xu <peterx@redhat.com>, 
 Willy Tarreau <w@1wt.eu>, linux-kselftest@vger.kernel.org, shuah@kernel.org, 
 Usama Arif <usama.arif@linux.dev>, 
 David Laight <david.laight.linux@gmail.com>
In-Reply-To: <20260603082707.3831525-1-alban.crequy@gmail.com>
References: <20260602100917.3641359-1-alban.crequy@gmail.com>
 <20260602100917.3641359-2-alban.crequy@gmail.com>
 <20260603082707.3831525-1-alban.crequy@gmail.com>
Date: Thu, 04 Jun 2026 14:59:41 +0200
Message-Id: <20260604-pudding-postieren-situation-f52745691fdb@brauner>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=3173; i=brauner@kernel.org;
 h=from:subject:message-id; bh=cdG9DKfiE9TSscxA54BmqzLb+7QHcmi8WUqp8p4DBuw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQplu1P9087ESYhcOLby0pPm+77Z5x/5bwRuD119zGzh
 WZBX3fu6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIQQZGhotXfj6RrOz9evip
 wwTvOfsuF7j5rglxPLcnv/WNrrLO5C+MDJvmPdu1Zv6UE5Nmbbz+7aX9rzW+yYpSpeKRX5X/rT4
 0r4cLAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D30F9C0002
X-Stat-Signature: tfge9jh4mpkzjxjj3ow6ek6mqeyfj3fd
X-Rspam-User: 
X-HE-Tag: 1780577988-496549
X-HE-Meta: U2FsdGVkX1/82FZCHMeq7VQ8WDlySEfSZoNkd7U/swAeR0J6FDPDDfoKcv/5KF2MxdJVcWMz7YzRAoO0rpo9BgqWnCGTUbkQbPiVg2mBW24lN6pGmIXJ19jmN2EnRUA9iXd0dK1+SXeQBjCppP5SvXiojf6hgQN8BmpVocOLY73brIx45MuMHYBwItLvknL14GK2gI39vesUM3tRFSde9mR7GSJOPskUsN2eQy0D3XACVXqy6IT45CracpHMO3aylxkcHXk4/rsD/9eCQ90v+zyfpkio6lBMor0cKWERTswzXQWRKtbq8IX/3iGeFVFA4ScmvyvavumFKor8/8uWW4VxvgvARastwhT8pZM2qwPiVNBIdH4dyNSYPTchtZVmjxOLpSFhAV7ilj/pLln7dW6jiXtIOxsESiZxNYfUOMui7fL7roDu7eonLyha8M86/CTvVdsyfR/LyxLOk60U29o2oDKFCa3AMuCUaSC4IW9c0r9UZ4aBGvKuuWHmgsmXRcTfHEKbyjtP/iGj3qA5wtMkdPCsDABvXjiAfqBm9Juz9OC4WJifjjYoDBCFyhiM+nca8BKe8c8WG1QOZBFE0uyy2Iit+AW1xLGA1D67UHs5jfBenP25o/hl7cCXhgACcsOQ9i/29hfG63D34RlxebMNEbT5dJrnebXOxxS2uknrFsL17+SUfnojHLI/wBBZ0zaNuproGF/rygaQocDbQr+Pm/LmT0aVpode4pAFDSDiBgIyqGYfUNPdGXv9NrPDLubveDahuSo1HYbXEj8UHFRBWsCkHQhkh9+/tGcA4euvZCZNeLScfmfPUumRyx8j1QoDu4+pw9Lhi/HdUX9V6c2RJBeEzCNrnV9LxV0Oku+yBUmon09uju0ZJ6ru1YasNMjK0DHhMOFMO4t0SAMySzPjz8f9Dp9r4KBDDQqeJY2JXUgGwsBRVgD/5Bs91uVzVFy7jef7vhf1mbkxTk+
 gAOpk1iU
 98xteMDkoKKFhC2LmCYSfLMxEBBrmqQofVP09ScV8wu0WXh77Vx9wXFcPFmiJ/pDxRyJrBy1HtFGdgogJuhbumDYISxNTvSUUTZgpld0QX05DF0H82dWkrQJYoTwfGP8izmdw7QKtHHe6cSm/9N5hp9dtmSf+3DH5IYjcfAr8cRy/5rTqJa/Ske7yOgc0CBna2rxvsVD56Uw2O1xPoDkCEb5gsrNVul1h3MC4AU5GAkhaLrzrooGPluhSJokBOmISo1fpfRKvTPrFye5zUQk1NabSy+2TZGZNML3D/2b9rjCzTQ5K7AFpKC5PRk99QF6a5YHR6UN5mFmbZldOdKIR+oanJGuOgDJguDLUNTJpSY1poqJ/2l0JHyfHZHmDDCfWA6fyt038hCxG4NeSVLpDnQBJQgGxzngtxoaB31/xhRRSmriBqiNhUlfKMhAmMZF7ymgSv+6lo9Do4ZH44trXJd0Nsx3tXUAMbzxp3F2yJj3Ley3AkhhNd5fo+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-03 10:27 +0200, Alban Crequy wrote:
> Sashiko raised a question about pidfd_get_task() and PIDFD_THREAD [1],
> so I ran some tests to understand the behavior.
> [1] https://sashiko.dev/#/patchset/20260602100917.3641359-1-alban.crequy@gmail.com
> 
> pidfd_get_task() always resolves pidfds using PIDTYPE_TGID (kernel/pid.c
> line 640), regardless of whether the pidfd was created with PIDFD_THREAD.
> This means:
> 
>  - A PIDFD_THREAD pidfd for a non-leader thread fails with ESRCH.
>  - A regular pidfd for a process whose leader has exited (pthread_exit
>    in main, secondary thread still alive) also fails with ESRCH.
> 
> This is not specific to my patch: process_madvise() uses pidfd_get_task()
> in the same way and has the same behavior. I wrote a test program
> confirming this:
> 
>   https://github.com/alban/tests/tree/alban_pvm_flags/pvm_flags/pidfd_thread_test
> 
> Results summary:
> 
>   All threads alive:
>     pidfd_open(pid, 0)              + process_vm_readv: OK
>     pidfd_open(tid, PIDFD_THREAD)   + process_vm_readv: OK (leader tid)
>     pidfd_open(tid, PIDFD_THREAD)   + process_vm_readv: ESRCH (non-leader)
> 
>   Leader thread exited (secondary still alive):
>     pidfd_open(pid, 0)              + process_vm_readv: ESRCH
>     pidfd_open(pid, PIDFD_THREAD)   + process_vm_readv: ESRCH
>     pidfd_open(tid, PIDFD_THREAD)   + process_vm_readv: ESRCH (non-leader)
>     process_vm_readv(tid, flags=0)                    : OK (plain TID path)
> 
>   process_madvise() behaves identically in all cases above.
> 
> For the non-leader thread case when all threads are alive, this is fine in
> practice: all threads share the same mm_struct, so profilers just use a regular
> pidfd for the thread-group leader.

This was an intentional limitation back then because pidfds only came in
thread-group flavor. I only added subthread pidfds much later.
pidfd_get_task() should drop the flags argument btw. I think that's
unused.

> However, the exited-leader case is a real limitation for profilers.
> OpenTelemetry eBPF Profiler wants to profile a process where the main thread
> has exited but secondary threads are still running [2].
> [2] https://github.com/open-telemetry/opentelemetry-ebpf-profiler/pull/376

If the thread-group leader exists before all of it's subthreads exit
then this is a broken program - even if it is a legal state. The
thread-group leader cannot be reaped while there are live subthreads and
it also means that any subthread exec "resurrects" the thread-group
leader struct pid. So that's going to make for fun profiling...

> Using plain TIDs (flags=0) would work, but it means users cannot use
> PROCESS_VM_PIDFD in this scenario.
> 
> What do you think this patch should do? I see two options:
>  - Address this limitation in a separate future patch that fixes
>    pidfd_get_task() to use PIDTYPE_PID when PIDFD_THREAD is detected in
>    f_flags, benefiting all callers (process_vm_readv, process_madvise,
>    and any future users).

As long as all users of the interface are fine with operating on
subthreads this should be perfectly fine.


