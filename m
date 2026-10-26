Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7CB3606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ka/7Sxsk
Received: by kanga.kvack.org (Postfix)
	id DC73E6B05B0; Mon, 26 Oct 2026 10:37:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D781A6B05B1; Mon, 26 Oct 2026 10:37:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E5E6B05B3; Mon, 26 Oct 2026 10:37:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A94E86B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:37:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3AFF2C0771
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:37:13 +0000 (UTC)
X-FDA: 85365029946.30.1553D5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A7EE580005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:37:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ka/7Sxsk";
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793025431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sl9wycySHELWIYxBYAxwb0s27UAcNsM0vqaNzM0OM3o=;
	b=kE+LW8lGjzU5EceCnTbwrErbNDYjD8hz+fqwc0eA2B2W7qf1abcqjjjNZp6zQZtEJ3xcQF
	b1CzsSTKH4gNhpKQVYW8sgjNrKBfSHyzbKix2SuiUhqGmX4aQWroKmS44+rHRg/Wo7Yf0L
	aEVFexmi2F13/tJFxYY1TkTMUACftWY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ka/7Sxsk";
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793025431;
	b=S/sG3xwTCXPDK/3Ct9MxxV9g8MAI4+LgTDJuj0ewESZNINdY6i61MR9pH4ZVPvSs9a4gbF
	9/0ree7YToSMhGbx0oIygd270YeGeamSE+IxDBofRM75oE8dcMfLM9RuMXcSCQMBh4UcjP
	rem83kNqz8kWWygXLvgQXp5ej5CzGQU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DDE7F601FB;
	Mon, 26 Oct 2026 14:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA76F1F01825;
	Mon, 26 Oct 2026 14:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793025430;
	bh=sl9wycySHELWIYxBYAxwb0s27UAcNsM0vqaNzM0OM3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ka/7SxskYU2X8HL9aFrMsSmohChlAIIZ8CqxW5S8KxSfV/fmq5SxQPV1sJOqYwepk
	 61cs3TwGMcQOa7Ma1/IW9h7U5F67h9S4kMsQaaTaYkPDuvYpWyrnCbZaByHyM4gN9G
	 LFr9UBBC1GKpUxScLdzwZ1kqVkzNcseCy6PRhYemqbFTymHwK8dItOaB19+4lUisDU
	 1UkWga42Y1EU9ifGgERxGI3o5x+QT9zmNpRgYN40KcKFvD9v6NkDftUdA2Yoh2t1Wf
	 GJkmfyxuLbdXZRMtWVwp7vueyBAUxQBl35c7aVJE1qyA8/xKa3U5BMpLqJuMY7WFAJ
	 EL+YIbmiq6Mtg==
Date: Mon, 26 Oct 2026 14:37:05 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ngoc Quy <ngocquy0700@gmail.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: pin mm_users in do_pagemap_scan()
Message-ID: <at9jXXDoMLi3X2EF@gremlin>
References: <20261014095540.3261469-1-ngocquy0700@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014095540.3261469-1-ngocquy0700@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A7EE580005
X-Stat-Signature: n45f8akym68jdunrpaos9cbs3tgzauak
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793025431-785582
X-HE-Meta: U2FsdGVkX19MGD6qM9zkEAl17dKxPp+NZzr19ZaP8dn26IFXhBSZZQtH948gLtrmQdifOWtiakBDoMDE4bQGz8deC1jbAJDiM4jl7C7uJZ1rN2O0g1o9XFuzVUk3a3REb6gIsD1XibOACQoG0tkV2T6QwF+aFl9Bd2w9kS89ZAjZR5ppNxez/8sUsPLOeDORu2+nKjDksJ7jMYx7vBDNsyVZ2NmmASFEbv810QNKvS4WpioVTCNzVSp6vrMxmwd4T9+WbkwsfHWRXJ9yfHlwaFg4agzJafg8J7egsJdEeN0tRmqt7EWyMvaElHEV6muFLAxBBLeTqCEgY07uMrw4On1+lo2zD5N6IRb469xrYQQgfuJazUlNJRN+PBgjr8CryB6/qj57wisCV17Ax72CxUuSrPHYQGznFlMctGJI0sXP5agIhfOwbQU5W5ofzvLViAe1xq8VD/jEbU6cZ9nZQEGjk9Xi9RUiTuafzhYfdWqhDJa8V9TQ6acKoCXLroFvQKH9PcnGh5ksVG2/qJzVl2fnB/GfpfgGpcpzLAGnrdlnDlIWNbh5wBLE7Py/85wHmauESCo+uUziW2rd2ahytHte02zUCXvn1Y/WOLFuU4r747zuMrA1Jz5dHrLjjHITGB+BJjBdhHtqGrmT/VkPb2i1dwuGnWwhDW81O8ayWl+UsMlaFIgRVtADbMBR25LyJB2oYbFYMg2pDjXiYjxJ7ezGoy3X+XhGc1Ix16ctrQvMJgHQ8OLOkmJLqFe3TeteiE8MHKZqVupzn2/DSELHNgIPCg9ah07J2LERqZw0Dd4Z3ayse39pNJE9eVE+O+3STp/G3Qedvsc//quoQ/LL+dIyJvATB3rMWJLwkYlDfofE4NOdWfsQeIWYbBHrv7kkLYc1KxJA85/kI2GcyKaYLk83PiB4pLjmv9mXrYHi2nakaud87bI2TVASPjUAonMgTIOSit6Hwyka0OcSsV3
 Q83WYkbs
 j/9lN7mFxDh4IkVOeuvuN8kOA6WK1eSHMJEn0n3P2na2twFaV+R3zRkLHWPJ50TWeK8zjq534Lb4uQ/MKo93gPl+A9/AR9cPQBqliaORLaEwxzYV12JwGjDb/G87zHj1wB+LmBywUJ2bb2Llgyu4c2KQqfspx24oXX7MCzQwk8xDHZRIAusr/Usv4AVbEXlfZfkDlvsN8Q/+OnRVRbNw4Bi3H6WAmhDOnogcv5wjoPdeAKIaRumZyUyYnOKx72VwKKhx3DSM9zE3Hh2/YkgMqscvoU2paGgZY2h98uCKx/xAnbzD9n6qpxusP/dNS7w9KYUjzNR3EHtydJlJXy23+O/zBTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 14, 2026 at 04:55:40PM +0700, Ngoc Quy wrote:
> The PAGEMAP_SCAN ioctl takes mmap_read_lock() on an mm obtained from
> /proc/<pid>/pagemap without holding a reference to mm_users.
>
> proc_mem_open() deliberately grabs only mm_count, so a consumer that

NIT: just say mmgrab() here. Its comment already explains the
mmget_not_zero() semantics.

> touches the address space has to call mmget_not_zero() first. Every
> other consumer in this file does -- m_start(), do_procmap_query(),
> show_smaps_rollup() and pagemap_read() -- but do_pagemap_scan() does
> not.
>
> Without that reference the target can reach exit_mmap() concurrently,
> and exit_mmap() calls unmap_vmas() while holding mmap_lock only for
> reading, which does not exclude the scanner. For ordinary VMAs this is
> harmless, as free_pgtables() and remove_vma() run afterwards under
> mmap_write_lock. A shared hugetlb VMA is different: __hugetlb_zap_end()
> frees the VMA's hugetlb_vma_lock inside the read-locked phase.
>
> walk_hugetlb_range() can therefore load vma->vm_private_data, have the
> lock freed underneath it, and then down_read() a freed rw_semaphore.
> The load happens before the freeing side clears the pointer, so this is
> a use-after-free and not a NULL dereference. Any unprivileged user can
> reach it with no huge pages configured, as hugetlb_reserve_pages()
> allocates the lock before the VM_NORESERVE early return.
>
> Pin mm_users across the scan, the way the other consumers do. mmput()
> from the exiting task can then no longer reach exit_mmap() while a walk
> is in progress.
>
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-5

This is the old-format tag, but the tag is no longer required, so let's
just drop it.

Instead, write something under the --- about AI usage.

> Signed-off-by: Ngoc Quy <ngocquy0700@gmail.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  fs/proc/task_mmu.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 5c54aebe2118..8825b01f5e38 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -3231,15 +3231,18 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
>  	size_t n_ranges_out = 0;
>  	int ret;
>
> +	if (!mm || !mmget_not_zero(mm))
> +		return -ESRCH;
> +
>  	ret = pagemap_scan_get_args(&p.arg, uarg);
>  	if (ret)
> -		return ret;
> +		goto out_mmput;
>
>  	p.masks_of_interest = p.arg.category_mask | p.arg.category_anyof_mask |
>  			      p.arg.return_mask;
>  	ret = pagemap_scan_init_bounce_buffer(&p);
>  	if (ret)
> -		return ret;
> +		goto out_mmput;
>
>  	for (walk_start = p.arg.start; walk_start < p.arg.end;
>  			walk_start = p.arg.walk_end) {
> @@ -3294,6 +3297,8 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
>  		ret = -EFAULT;
>
>  	kfree(p.vec_buf);
> +out_mmput:
> +	mmput(mm);
>  	return ret;
>  }
>
>
> base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
> --
> 2.53.0
>

--
Cheers, Lorenzo

