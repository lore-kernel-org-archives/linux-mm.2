Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE4D104BEC7
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22D7B6B0005; Wed, 11 Mar 2026 06:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6826B0089; Wed, 11 Mar 2026 06:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E6246B008A; Wed, 11 Mar 2026 06:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D97526B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:11:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F95F1A070F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:11:26 +0000 (UTC)
X-FDA: 84533364972.18.E5877CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id CBD9D180010
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:11:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vORWu92q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773223884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hdOJL1yYTnsO411MaFPrt8EI5lpClWJ2queE70PRRaQ=;
	b=DYaHr5L1u3dDr9ugHgQOdKk6GxzN5qCXcYD5AnuiJrssfYK/r/BamV0zA+xlaafddtWwSg
	E/VqDQ3TdpLZvfhT10q3V9t9Wqhs0edC7uBCqusLGizr53cg7KlqkAjvJ14DOXIOV7OtgE
	t2MmU3obkZ7l/0c4iGlQoS+Rd+ts3vI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773223884; a=rsa-sha256;
	cv=none;
	b=X/ceCo/5U1iaAxS9fSiS4X784DxEy0FaKNCoXvFElby0fsvcEAcgfP9F7cPlyyAz4Mz6ri
	u7Dxg1hwFNcRT4JzMi3LlypmWq1IU+kzil3e8rAkoM9vZa7VVLiYr+md695F7t8bQikyd2
	lJAWlXkNfUOaRhnmNrVCmtAD/qbDouo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vORWu92q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E1E46600B0;
	Wed, 11 Mar 2026 10:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B9AC4CEF7;
	Wed, 11 Mar 2026 10:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773223883;
	bh=LCBZgY/aamBuvWc1+VzQD3H9HM4ufxSjmpZJ92W5bvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vORWu92q6D3w4sohkY61ALK9H2VgoICnSF9jtg/EfSS9Xf7VFwnDduwbWLSiY2pJt
	 q9TAuqhB7by8fgQZ+LFuJ3uOG0cVE3feGj9rw/tA5G8kW8exk6yQixWp+n4CPlcWFw
	 28LxQHJeeocPn7q3xXmo3PFWAqbxlJy6Y9wpR4NuSXrR5Fe9pb4E/wv4s6S3S8QQmy
	 IZBbN7eZ57qrwzO+1ojlTLvHQ8QC11l/wQKTD6+eBsntkOVIe6ahTc3LS5rK9f8j4P
	 WrItiND+pdNKTdyq4+J20jN5FjpDN7BZ/Wg7QMDOSD+D7gaq9nRTnCNjmPqdRq/vNF
	 YOdjn5m7Ky75w==
Date: Wed, 11 Mar 2026 10:11:20 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Jianzhou Zhao <luckd0g@163.com>
Cc: pfalcato@suse.de, akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: BUG: KCSAN: data-race in do_mremap / vma_complete
Message-ID: <abaad620-bc19-4a3b-9bef-6a1ad4335ce3@lucifer.local>
References: <1a7d4c26.6b46.19cdbe7eaf0.Coremail.luckd0g@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a7d4c26.6b46.19cdbe7eaf0.Coremail.luckd0g@163.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CBD9D180010
X-Stat-Signature: yrxzbrjwtxuz9dn3sdrqy633yud6byu5
X-Rspam-User: 
X-HE-Tag: 1773223884-651850
X-HE-Meta: U2FsdGVkX1/cpG2KeUAMfWvnhxtz02x6lIkj8RZFh0OON/T+CqgncroGf2pBPqXg/SMTP5G6lEeuYlkKb5G00atsCZYMtKU0Jg/XfEgGmjoqpf8FkumTa3CQPYIMD0TE/fVrLwsfvoGSXy6+TODcgjE7pWttBEdxvZabT8cSvgpEenfCkUgRALDZUPZ2BgNPqLa+mvfWT3MeER6S3nSyEHl1TpWUrnqv5VjQOrh9/g+nHxOw074wviWJhS/jiU+4pyNC71yvoA+4HR/aBGwEZ2Rzdkgt/hf+2fQ/bUXEijrYHgZE7m7C0js1s+D8OJV4nKNzb2E8HXNmxrldZGzIHrCX1PjiUqW/rmR6Npt0TJESKrnX9U0aDlhEw9F6cA5u9NR2sllwS6vBN5R1pvDTQDW5MJ7ruKMQ2JNzzNP8tRJ32FvhbFA7kLkcif8ylqkE5eGRz8RIU73jX7/YnAu1V+gvFmFKtGPJwzPA92EjYWFxQkBBhj8eotdAzMhjwKaNW3YUteCwzlKmsbMkLtKPQMf8oxJsDLY0XbZZtaoMs7y11cTUyVHSBofjzgEkjcjMwcL8k607TJDuP9564IaXCwVMs2UbJdaQNhzw8E365WGgTdk7gAq/qgExgnb4NhJKXGuufOpJnBx9mj09HcGA8NCSJP2zDOHhNvA4UT0MHliYPWm1dn9T8qjle2MGIwfs3Y6YtsL/6ZHV6xe9FEg1A8FpQbbyRKKyfFSlV5kZAbeukKiaIorg7/IJr2KaweWvzUKbeW2w/TWZ2LehdopGaqjmtKcXxqDtUJ/OsCVznebwt/KUpDzBYiVUnyAPk6CJaNCnngf58hKJmUWA6ZARGr0xjC49Lh4k6ILgxDKawJ/CUgRWDm9x6vSLew8prBnWVjvDnmfRkf4hkoTfwgdlmbpTQNF4UXeL82/HQxtYdogtAJhxz7gyCCY0kcZ9j6YrEHgIFfWXVDzRyuPREnK
 MaDpssqV
 PEcuOThsRysqgJVECeHF1kYgUVZ91kpnSfSSvCo3BNr9hRKbhG3rNbtPVYgZ0lrsS/Dd+Y7Dn1ohxMb43snA1rZg4G0aO6fAKEifqw8B3eWRfIetL5Vd1rF2xFd8bFwNyckt1UuRgLdNQYipubf1P/SWanV6CheDloRe2gVb/Yw8UKZnPZTCudc2RvCpqFg3qD3HlNEj5/g4S+RDdjarCjXkJqV8qWgslWh/AJo0NN2p1jkag6UuQiizZ+j7vDXkf/hlwd79/M9nrWY1eQFJVE6fOEacum5gxEpACFslPduBVxyGfKi0AVmOHDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Removing incorrect mail, I know it'll take a while to propagate the mail
change :)

On Wed, Mar 11, 2026 at 03:58:55PM +0800, Jianzhou Zhao wrote:
>
> Subject: [BUG] mm/mremap: KCSAN: data-race in do_mremap / vma_complete
> Dear Maintainers,
> We are writing to report a KCSAN-detected data race vulnerability within the memory management subsystem, specifically involving `vma_complete` and `check_mremap_params`. This bug was found by our custom fuzzing tool, RacePilot. The race occurs when `vma_complete` increments the `mm->map_count` concurrently while `check_mremap_params` evaluates the same `current->mm->map_count` without holding the appropriate `mmap_lock` or using atomic snapshot primitives (`READ_ONCE`). We observed this bug on the Linux kernel version 6.18.0-08691-g2061f18ad76e-dirty.
> Call Trace & Context
> ==================================================================
> BUG: KCSAN: data-race in do_mremap / vma_complete
> write to 0xffff88800c232348 of 4 bytes by task 27920 on cpu 1:
>  vma_complete+0x6d2/0x8a0 home/kfuzz/linux/mm/vma.c:354
>  __split_vma+0x5fb/0x6f0 home/kfuzz/linux/mm/vma.c:567
>  vms_gather_munmap_vmas+0xe5/0x6a0 home/kfuzz/linux/mm/vma.c:1369
>  do_vmi_align_munmap+0x2a3/0x450 home/kfuzz/linux/mm/vma.c:1538
>  do_vmi_munmap+0x19c/0x2e0 home/kfuzz/linux/mm/vma.c:1596
>  do_munmap+0x97/0xc0 home/kfuzz/linux/mm/mmap.c:1068
>  mremap_to+0x179/0x240 home/kfuzz/linux/mm/mremap.c:1374
>  ...
>  __x64_sys_mremap+0x66/0x80 home/kfuzz/linux/mm/mremap.c:1961
> read to 0xffff88800c232348 of 4 bytes by task 27919 on cpu 0:
>  check_mremap_params home/kfuzz/linux/mm/mremap.c:1816 [inline]
>  do_mremap+0x352/0x1090 home/kfuzz/linux/mm/mremap.c:1920
>  __do_sys_mremap+0x129/0x160 home/kfuzz/linux/mm/mremap.c:1993
>  __se_sys_mremap home/kfuzz/linux/mm/mremap.c:1961 [inline]
>  __x64_sys_mremap+0x66/0x80 home/kfuzz/linux/mm/mremap.c:1961
>  ...
> value changed: 0x0000001f -> 0x00000020
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 0 UID: 0 PID: 27919 Comm: syz.7.1375 Not tainted 6.18.0-08691-g2061f18ad76e-dirty #42 PREEMPT(voluntary)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> ==================================================================
> Execution Flow & Code Context
> In `mm/vma.c`, the `vma_complete()` function finalizes VMA alterations such as insertions. When a new VMA is successfully attached (e.g., during splitting), the function increments the process's `map_count` while holding the necessary `mmap_lock` in write mode from the calling context:
> ```c
> // mm/vma.c
> static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
>     struct mm_struct *mm)
> {
>  ...
>  } else if (vp->insert) {
>   /* ... split ... */
>   vma_iter_store_new(vmi, vp->insert);
>   mm->map_count++; // <-- Plain concurrent write
>  }
>  ...
> }
> ```
> Conversely, the `mremap` syscall validation sequence preemptively evaluates `check_mremap_params()` *before* acquiring the `mmap_lock`. This allows dropping malformed syscalls fast but leaves the map quota check unsynchronized:
> ```c
> // mm/mremap.c
> static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
> {
>  ...
>  /* Worst-scenario case ... */
>  if ((current->mm->map_count + 2) >= sysctl_max_map_count - 3) // <-- Plain concurrent read
>   return -ENOMEM;
>  return 0;
> }
> ```
> At `mm/mremap.c:1924`, the `mmap_write_lock_killable(mm)` is only acquired *after* `check_mremap_params()` successfully returns.
> Root Cause Analysis
> A KCSAN data race arises because the `mremap` parameters validator attempts to enact an early heuristic rejection based on the current threshold of `mm->map_count`. However, this evaluation executes entirely without locks (`mmap_lock` is taken subsequently in `do_mremap`). This establishes a plain, lockless read racing against concurrent threads legitimately mutating `mm->map_count` (such as `vma_complete` splitting areas and incrementing the count under the protection of `mmap_lock`). The lack of `READ_ONCE()` combined with a mutating operation provokes the KCSAN alarm and potentially permits compiler load shearing.
> Unfortunately, we were unable to generate a reproducer for this bug.
> Potential Impact
> This data race technically threatens the deterministic outcome of the `mremap` heuristic limit guard. Because `map_count` spans 4 bytes, severe compiler load tearing across cache lines theoretically could trick `check_mremap_params` into accepting or rejecting expansions erratically. Functionally, as a heuristic pre-check, it is virtually benign since a stricter bounded evaluation takes place later under safety locks, but fixing it stops sanitizing infrastructure exhaustion and formalizes the lockless memory access.
> Proposed Fix
> To inform the compiler and memory models that the read access of `map_count` inside `check_mremap_params` deliberately operates locklessly, we should wrap the evaluation using the `data_race()` macro to suppress KCSAN warnings effectively while conveying intent.
> ```diff
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1813,7 +1813,7 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
>    * Check whether current map count plus 2 still leads us to 4 maps below
>    * the threshold, otherwise return -ENOMEM here to be more safe.
>    */
> -	if ((current->mm->map_count + 2) >= sysctl_max_map_count - 3)
> +	if ((data_race(current->mm->map_count) + 2) >= sysctl_max_map_count - 3)
>    return -ENOMEM;

Ack, this used to be checked under the mmap write lock.

I'll send a patch that factors out these kinds of checks + potentially does a
speculative check ahead of time and then re-checks once lock established.

With a:

Suggested-by: Jianzhou Zhao <luckd0g@163.com>

>   return 0;
> ```
> We would be highly honored if this could be of any help.

Thanks, much appreciated :)

> Best regards,
> RacePilot Team

Cheers, Lorenzo

