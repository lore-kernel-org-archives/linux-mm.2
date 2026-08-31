Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73107C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BDC76B009B; Mon, 31 Aug 2026 10:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496446B00A2; Mon, 31 Aug 2026 10:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD446B00A3; Mon, 31 Aug 2026 10:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 129E76B009B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:59:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9584C4016B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:59:10 +0000 (UTC)
X-FDA: 85161872460.30.A8E1E1C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 75E7014000C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:59:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kba1Um1I;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6QBCg2q7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Cp7WNb0k;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WVbWiOO7;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788188348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UvT21SLbv8rzIVCfuPJMnTzw0oJMybcWGfiy1xZkB+E=;
	b=YuP1XDgD5bUqfaJks/Qo2t8AJ7iEaNVJg/EriXnuuHZZZimFjpD4qld02hnGDOtbwPzNHR
	bWT9WwueAEjknsmNeB6gzASYTCuaFs8Lz3Ohg9gpPSmYKT65r8f2GEKBK7Ovlfz+vrEnyW
	kE2RsS0O4QV3sM7KKTF2m20rYEQoltc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788188348;
	b=VfCfCTbjSSkBHShMAY7Ybflip0E4Th/tYJhDHIgurMpUctybGWaupZiZ8GosfaHl3z3ql2
	pfUs6QQ/r7nuvqhQBm5SUESikM4jz3vRhL3XfmjdUyaVRY0c65dX3ITgZ0NT+2F2yNfv0f
	gxqxRMkoM1weTdgBisGWib4b8c05xkM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kba1Um1I;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6QBCg2q7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Cp7WNb0k;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WVbWiOO7;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C14351FD91;
	Mon, 31 Aug 2026 14:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788188342; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UvT21SLbv8rzIVCfuPJMnTzw0oJMybcWGfiy1xZkB+E=;
	b=kba1Um1IJqQOmOWWC02FQ7wljvpMVdLO8KeaMH4vf5Cn8EDZP55CGvLwBgMa6St8AbfvWC
	9W14+XoGWltDkZCveefQqbd8mJ/F6Ob+P7Ddl3COw7ZV6o/7djMKtoRY0D/uO6D32vrkC+
	E3wIdI0kyo/wLIudqePMc+YeV1U5XWM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788188342;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UvT21SLbv8rzIVCfuPJMnTzw0oJMybcWGfiy1xZkB+E=;
	b=6QBCg2q7ckf4CU7BXXxPylVr2LQ4f4CB7KMFT9wFe7KDfXmTDVSpRiNb6eCboh21D5QiOP
	lAycuAu3y+JA48Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788188338; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UvT21SLbv8rzIVCfuPJMnTzw0oJMybcWGfiy1xZkB+E=;
	b=Cp7WNb0kLL3rrGZj09jUIdXtLyNI9QB7TeK3l6lNVpsg6Ufa7iIcFcduq3ccurCZPsgoPa
	KtbvdebtIOxh5u+ENZoVUyOqDatZFRxakCEr1i/OjGZHz//M/FvarJrRrWM5CLiJH6d7gA
	/O/ixOt7bWq6fE6mxH4eZrwEmg9Fgz4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788188338;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UvT21SLbv8rzIVCfuPJMnTzw0oJMybcWGfiy1xZkB+E=;
	b=WVbWiOO7rQEg1ngq9yJq0d1joO+t5F6Hv6hy1OIHxdDlaGLaGJkwHQ3NNtZlRKeaXa47VS
	qymBittGYZibkHDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 282B813685;
	Mon, 31 Aug 2026 14:58:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id edFzBrKWlWpdHAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 31 Aug 2026 14:58:58 +0000
Date: Mon, 31 Aug 2026 15:58:56 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Andi Kleen <ak@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	jannh@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RCU safety for vma maple tree walks
Message-ID: <apWUsc-a6k1YkuMv@pedro-suse>
References: <20260831143511.1133029-1-ak@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831143511.1133029-1-ak@kernel.org>
X-Stat-Signature: kyffbwya9jtbbxpq68tfh3ou1kpahm1x
X-Rspamd-Queue-Id: 75E7014000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788188348-127977
X-HE-Meta: U2FsdGVkX18sUBBl871VuSxnABgtJwVoXUiyk557iqcsGHeIP4LyYjdXw/9GxrJDAjTgoJw8/myuj8QPCLbLRNMdx2gH5+hrOIrEn0QaNUNdSJl9yIfkXL1wRjxEyINPUlzZWpPga2CMX7RBye8Z6IbgashYGcMsNxzDCQTBAnEzVR0AQiuvLv8LFutibUCL+4a1LZPVoaaQmNYYzL5dMdqCiysikZKRvi6bfjI5Q2+n/hOH5MJd+2Pz0FIIb7KuVNH1PMOASEOeIlg6ru+CMTDyvSgTtruWL8nZ9uceaDKwyky8swcNTUqQkK3gnl+0LO1NCEpZXU2UYDrT8U7oBux5v1RihWBLjjj9U5wr8lIw3zKClDEZnTpwFLkFTF0wWKvSbijWfwA3IcBTezIqhPoonhDglsUCbHne6E9i3NChPF4nL7ZVZfIaHFmfviM9+MeD0o8ELM8yFCUauoqZFyVXQNNJmR02dInqxzRsRWBOlrATeu/VnE+rpEijutRSJqdO8CkQLn+ogGG4J/JI+OSARF+Zbl+ujRkCSOgXIDovRn3EQcvOj2cxxc1cWutIdGCv96VRtwwOqom1TKnrPdJbQialNRsdZDLM7t26CC3aWJt7B6ctsrlPAXQZUtnfFva6V8fXRK9Jt0qJq+ESfM9yxF+LPPblFMhnmeVbhWrQBIzxSHiaiadPpR4S893K1/n/EO9wqIWNjpAypwPXv1KD0EjylvMIJmXDcN52Reic28wnbo18gbgmQax/pREjuudd6e6kV0tgOUeJ16T5dQXSG+56SxVBtoKZWiNb4/eCRGL2eI8VxIE4efMn9rQpkg7J0FlGtTNSY9VvGnUm8Tpe99PfUxZn36rYzUXG3Rw5Ybmj5V+8qc26l+X6c/9OFIV0/eTn4XxUCiWVfqZYP8iUh67crl+9f4s9sNykPTCfqhUfMaIpx57+Zfdkos2Yqxku1hVYS6QirJ4CXvC
 d3ZJmdD+
 dh8khXV+ObOG5qVeODcxjM0pF7NDdUU7MbSFaXuiaZtghJM0T97uDuxOMTYoaVvQwGVPgBIdfJ0Y/tmdfGaH5b0Egt6hEF7BHWYDvb5sYVqwgxbm8C/C3c+8lcQJYW9MtJ7ttuw95azyYXNUKo+pa/pTq1QNSuhlR9ZfAqmhZfq93Ywj7Jr6tRxLw5hv3VleeHrGF36qc96+liOUAvRDww3UkTvNyXRWvtzMkGRywoq1u9CfeZxTaUWcYkKkNpO6HayCxvEZT7gb+Y0i8qYc+cxnjiUZyoNlm5P3KjNE4b6K+v8TfSG4cEVtWUa4ssk+PZs4q9Qj8+Khm4A1iZpUN+7fwaeOPxqE9eoyRLXANOwSpMCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 07:35:11AM -0700, Andi Kleen wrote:
> I ran into the following scenario in a slightly modified kernel:
> 
>  1. vms_gather_munmap_vmas walks the unmap range and caches a maple node N
>     in the maple iterator.
>  2. It triggers a __split_vma to fix up a range and during that node N
>     is queued for freeing with kfree_rcu
>  3. There is another __split_vma that allocates memory and sleeps due to
>     memory pressure.
>  4. During the sleep the grace period expires and node N gets freed for
>     real.
>  5. The iterator still has node N cached
>  6. When the iteration continues it accesses the freed node and KASAN
>     trips:
> 
> BUG: KASAN: slab-use-after-free in mas_next_slot+0x1e95/0x2860
> Read of size 8 at addr ffff8881160bdc00 by task pool-e/5770
> CPU: 1 UID: 0 PID: 5770 Comm: pool-e Not tainted 7.2.0-rc7-1-debug+ #106
> Allocated by task 5770:
>   mas_alloc_nodes <- mas_preallocate <- __split_vma <- vms_gather_munmap_vmas
>     <- do_vmi_align_munmap <- do_vmi_munmap <- __vm_munmap <- elf_load
>     <- load_elf_binary <- bprm_execve          (pool-e's exec)
> Freed by task 25 (ksoftirqd):
>   __rcu_free_sheaf_prepare <- rcu_free_sheaf_nobarn <- rcu_do_batch <- rcu_core
> The buggy address ... cache maple_node of size 256
> freed 256-byte region [ffff8881160bdc00, ffff8881160bdd00)
> 
> There was also a more complex scenario when the node was immediately
> recycled for the next split VMA insert, modified, but the access by
> the iterator for the previous walk saw corrupted state and triggered
> KASAN too.
> 
> Basically the problem is that any sleeping during VMA walks breaks the
> RCU reader guarantees for the RCU Maple tree iterators. But sleeping
> is unavoidable for various reasons.
> 
> I hit it with a kernel modification that makes this more likely
> (It can do VMA splits on exec mm teardown)
> and also in a very memory constrained environment (4GB guest running a
> stress test), but based on code review I believe it's a generic problem that
> could happen in a unmodified kernel.
> 
> That said I wasn't actually able to trigger it in a unmodified kernel
> so far with stress testing.
> 
> The following old unsolved syzkaller report has a similar signature,
> so maybe it was already seen:
> https://syzkaller.appspot.com/bug?id=4c5268fbb1d6d508a4c34dc425e2693d1ff9911a
> 
> I guess in many cases where it happens for real you don't notice it
> if you don't have KASAN active.
> 
> The patch fixes up all callers to maintain the RCU reader lock
> regions correctly during the VMA walk. If they cannot be maintained the
> iterator is refreshed by a new VMA address lookup in a new region, unless
> it is proven safe not to.
> 

But none of this code uses RCU? I'm confused. The maple tree state should not
be keeping bad state. That is a bug.

All of these functions take the mmap write lock. That should exclude
against other concurrent changes. Using RCU here makes no logical sense.

Does the kernel say anything interesting when CONFIG_DEBUG_VM_MAPLE_TREE=y?
 

-- 
Pedro

