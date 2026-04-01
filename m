Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B965610FCAC0
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 18:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AEB26B0005; Wed,  1 Apr 2026 14:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25EFD6B0088; Wed,  1 Apr 2026 14:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19CF16B0089; Wed,  1 Apr 2026 14:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 09AFC6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:44:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A6058E027B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:44:29 +0000 (UTC)
X-FDA: 84610862658.04.0E90C90
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id EEE594000D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:44:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VD5vpqkI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775069068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RVyY1l68dr/eCM6hPf9WHkEHkljnRQfRcRQGPTmv6G8=;
	b=4fnC+Hj1+CvvGS7QKkK7i9gqwzp9bK2frwGu/nD45WR3YA0FYRczVP5udTYSZHdSael3TX
	Qj8QtocyBNt4Z/xwb5qVaXgfLRCVXoHSPUoC/Nl/DIH88LY1663UB3llLd0FPQBfBTG9cu
	L6ZATafepQykuoqapTauo1+p8+SFhcc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775069068; a=rsa-sha256;
	cv=none;
	b=b5RUSAhGdDkEaEW1AZ7wTBFNSeoX2npREQNrX1vXFfcNZ/Vai5ebUIFOR51N2ZUi6SpK8S
	4DQyX5jzAgr+v2QpNi24T8J7beXA/2uUKqGw7Uo6hbCVaD/vNPAxo3LoorUUms5RhwowSp
	5IYEgW2RFBSRbifxtJTPgA/N5c4JGHE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VD5vpqkI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CBC06013A;
	Wed,  1 Apr 2026 18:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6889FC4CEF7;
	Wed,  1 Apr 2026 18:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775069067;
	bh=7xzStj3k1oXqrTXPBH4aWe0qsaL6BGdKjHlWyPnNBpM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VD5vpqkI6cuuDjGekS+PkL53/yMBQy0wk1mggFjtVnAxP2ACyj0GXCnydwAoS/Mt6
	 q1RGGKqSqNqDH01sZd651krrjf+Wv2RZYj1OjKNew/N/TQPGGttZD8g7uCyjlqPtQp
	 trut2dUioke2w2pAwUsn2f1ycchEM3qwbr5M0VGsjhT3GM9H8SNamG0kYrrjPW4qEs
	 fmYCthWdPr/k/yENJZ+zs6tExyzi6ZprP6+EW8TWRcF3pxxMqy+nHxeWby1oyxVAGa
	 vcn4I4kbrtIaF30/U0TlFfU4RJweIDG+GWpiqeXBxuBiueeJkcz+td3Cc9lpPaaIqG
	 xrqiYXqOnaXQQ==
Message-ID: <61ef9256-01ea-49a4-9824-be1c3c1fcba5@kernel.org>
Date: Wed, 1 Apr 2026 20:44:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/vma: fix memory leak in __mmap_region()
Content-Language: en-US
To: Sechang Lim <rhkrqnwk98@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260331180811.1333348-1-rhkrqnwk98@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260331180811.1333348-1-rhkrqnwk98@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EEE594000D
X-Stat-Signature: pseypq899kd46pus8q3sdqedtk8uz5yj
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775069067-6224
X-HE-Meta: U2FsdGVkX1/M6AJdarbhpEVqKmADwTg4Rg7yaZVlzleVOyrJCRizUhIQX+5wF8T7oKCGyBCptFqJe/U0K0cBTNGL615Jgmjhx6VUZRpbzyxJURv8F2Ag2ZGLHr5EfKh3PPcJvBgg0/ekkgab8Oqn5H81DK0XsSPKrz4eR3PSB2ex1YEefJPfO3fQ6LPMT4V7b7GpahFFQsJFfzyt2pe2MuqWgZG9dhmc16zQtC0x1aSJ5r+Zos0wUXhwes4s0Q3d34waeJQnHuWb2ewMykmbHTCbbv7AcPft6JJyPOHix1zQjkH+tiiPzo5jsiulWxfzSeAkQ2wutx21mLzRKDPQI1w2cZMS3+em6KyZFzQRE5P6mwhVyCYRb8jX+43148veu8+QzbKMbFL9s2jYmQqq82KEF2Pl4iE2hlRvacCoPbwvQvvXjUD/4GFZS3tJcsBC+l1iDPp4oekNp7Rm5cfcyw1N9rCwnOFhVw2roKNhgQ3xLYjX2jlDRXGuW7wQ5Vd1qh5b3kxeltWa6rV7flyKhkpXN+OgWIU57Wq+XSCsEIfINBMZBO7kLbPQZs+wHDStc68MC5+jclzCx4Vx0Axy7iQW7SR0J6UJnSk2wTGFV6YzZmx5NuoOuCgIXNMG8WKnx9l5XfVenS24S/NCVK2jNhFT4XDPzeIVQK5lZG1BjsxjdPqnLE+FIk0gu5cmIGgqXDrwtZwPjkvYxeBqhOkJccDPdsIDB+Wlhzn908MygrP6IAh8pRiesQicsxGbQcfqZlAIIqY4+JZanfMoYK/O1BzhilWC9mEMwA7ThJhi0wezfH+Uqp4btZAGgelG9ao9mylDgX/QJHhjoKvfZx70MtfsaLuA32hBQgJrMt0J2ZHhSTFo54dSW1k87vui5Sw+EnQMYeu3fu25KbgCX+5lc9gUk05XaBZgDiaCq3gSPKjS0KHTildCPYvNxgqam1DjfwcLmC/qgY7VV4EM73R
 FRa4IXLY
 +hD95KFgN6b5Ebpr8PrizYF1GgWytQpU7poWlyZmh2DvTc/nTcHA+9pwnB+M3aYg+Dx6qhWm9tkkHHO0w1LPJwLc8xUOljbVPDntpTx71Nrj6t51m3OtzGNyekhL7ZYaJndOv7q8sphWIC4OWlxe2l6u1DhpDgDwfaOJp3DBSSUVn9REsQYyrGv5m1ygHZXEH0sJwkN12l03KyZdXw4b3b5peRf5COLFQg2csdKyyd1qz9Q6TaO4e0k43ZQQIniK2HdGyqPp1m0UFGSqOWgHdDhTWKqQtj86iS+Nm+dQABxt8QS/0r+dAh1db946O3Oz5ZIv0RKDQ0lhgoDSNmUtt/5Z7EhiDVEXuu6Oq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 20:08, Sechang Lim wrote:
> commit 605f6586ecf7 ("mm/vma: do not leak memory when .mmap_prepare
> swaps the file") handled the success path by skipping get_file() via
> file_doesnt_need_get, but missed the error path.
> 
> When /dev/zero is mmap'd with MAP_SHARED, mmap_zero_prepare() calls
> shmem_zero_setup_desc() which allocates a new shmem file to back the
> mapping. If __mmap_new_vma() subsequently fails, this replacement
> file is never fput()'d - the original is released by
> ksys_mmap_pgoff(), but nobody releases the new one.
> 
> Add fput() for the swapped file in the error path.
> 
> Reproducible with fault injection.
> 
> FAULT_INJECTION: forcing a failure.
> name failslab, interval 1, probability 0, space 0, times 1
> CPU: 2 UID: 0 PID: 366 Comm: syz.7.14 Not tainted 7.0.0-rc6 #2 PREEMPT(full)
> Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x164/0x1f0
>  should_fail_ex+0x525/0x650
>  should_failslab+0xdf/0x140
>  kmem_cache_alloc_noprof+0x78/0x630
>  vm_area_alloc+0x24/0x160
>  __mmap_region+0xf6b/0x2660
>  mmap_region+0x2eb/0x3a0
>  do_mmap+0xc79/0x1240
>  vm_mmap_pgoff+0x252/0x4c0
>  ksys_mmap_pgoff+0xf8/0x120
>  __x64_sys_mmap+0x12a/0x190
>  do_syscall_64+0xa9/0x580
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>  </TASK>
> 
> kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> BUG: memory leak
> unreferenced object 0xffff8881118aca80 (size 360):
>   comm "syz.7.14", pid 366, jiffies 4294913255
>   hex dump (first 32 bytes):
>     00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
>     ff ff ff ff ff ff ff ff c0 28 4d ae ff ff ff ff  .........(M.....
>   backtrace (crc db0f53bc):
>     kmem_cache_alloc_noprof+0x3ab/0x630
>     alloc_empty_file+0x5a/0x1e0
>     alloc_file_pseudo+0x135/0x220
>     __shmem_file_setup+0x274/0x420
>     shmem_zero_setup_desc+0x9c/0x170
>     mmap_zero_prepare+0x123/0x140
>     __mmap_region+0xdda/0x2660
>     mmap_region+0x2eb/0x3a0
>     do_mmap+0xc79/0x1240
>     vm_mmap_pgoff+0x252/0x4c0
>     ksys_mmap_pgoff+0xf8/0x120
>     __x64_sys_mmap+0x12a/0x190
>     do_syscall_64+0xa9/0x580
>     entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> Found by syzkaller.
> 
> Fixes: 605f6586ecf7 ("mm/vma: do not leak memory when .mmap_prepare swaps the file")
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!


