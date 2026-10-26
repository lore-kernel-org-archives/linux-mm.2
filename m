Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9084D606A33B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 22:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dr+bFo+7
Received: by kanga.kvack.org (Postfix)
	id 8D1A46B05B0; Mon, 26 Oct 2026 18:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B746B05B1; Mon, 26 Oct 2026 18:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749A16B05B2; Mon, 26 Oct 2026 18:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 461926B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:30:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8AE48C0880
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:30:46 +0000 (UTC)
X-FDA: 85366223292.23.6007328
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0ECCA10000C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:30:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=dr+bFo+7;
	spf=pass (imf05.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793053845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dmscNNXpR9Tlb5LZlm76LmXvzMKP1GvB98Aa5akaxVg=;
	b=x0HxWOyrNCHjcuacrN3t1hgYwojSSrEU0y/IkRV2IUOArdX4JpLJDblEQvdAy2UVBwCN7m
	Vw9gVj5vboiZfnzPcW6w0jaoRQbToMPSjnB/mrlCiBaJFHDuOQgHF5IgLu5gkmK8sDWx5D
	hwln/D/RI9qQhVhohYG3mOyyaOLz+Ck=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=dr+bFo+7;
	spf=pass (imf05.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793053845;
	b=oJW0ub4UP4sy77IA8A712p3sNK7Gcm6MZJdiIpYAplPhu5OzY9Nh0LszpZ2OLJc5amXaNb
	Ber+WrEP3hMlpiKA7R3oQhbphr1GSX8N9M/aXq7anwC9BVw9SMvrcVEXgP1xqnudoKlKYo
	Hc7zCEp86i3pooPlZESYn5bJq1pU/0w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 12517600CB;
	Mon, 26 Oct 2026 22:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46EC1F01825;
	Mon, 26 Oct 2026 22:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793053843;
	bh=dmscNNXpR9Tlb5LZlm76LmXvzMKP1GvB98Aa5akaxVg=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=dr+bFo+7z5+CTwiGHeYIy9H24IjvPgf4TRxSimSjSs3n/yAhL9aRSZINo/x5mroHe
	 IomSvINKTXigvFZ4T2r4pQS6DcTQna3EE9nzEaCD82hejA4AZ3C7UlSxPbJbhFSHxy
	 Di/MXuc0u3/DB8dqNapb7z2siMBwUqQB6nYCMuq4/0PMPiMdvRGNrUrJkXSpvs0w3z
	 2AT3Q8x/a6nwJyggelSWmXb4qTG5Z6QAbLhvcEzt6dxwgv3iYRFYhWUqc9QXSKF1rA
	 6AS+VQieQSX/Ma92ZXhyBaeeXWlR1S0w7QnMoMkQeDXfNXkfAbaABsGjNgcpENxttB
	 vTydLvfW/5xGw==
Content-Type: multipart/mixed; boundary="===============5289104665204023220=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <bce97570ea9665a2f83216d4dfd7ab7ce17d54aa777f761c3d12db430ba21bb9@mail.kernel.org>
In-Reply-To: <20261026215226.3713941-5-jthoughton@google.com>
References: <20261026215226.3713941-5-jthoughton@google.com>
Subject: Re: [RFC PATCH 04/10] stacktrace: Don't unwind the user stack without an mm
From: bot+bpf-ci@kernel.org
To: jthoughton@google.com,akpm@linux-foundation.org,viro@zeniv.linux.org.uk
Cc: tglx@kernel.org,peterz@infradead.org,kees@kernel.org,arnd@arndb.de,david@kernel.org,ljs@kernel.org,liam@infradead.org,vbabka@kernel.org,rppt@kernel.org,surenb@google.com,mhocko@suse.com,seanjc@google.com,pbonzini@redhat.com,jmattson@google.com,axboe@kernel.dk,asml.silence@gmail.com,James.Bottomley@HansenPartnership.com,mkp@kernel.org,dsterba@suse.com,mason@kernel.org,ast@kernel.org,daniel@iogearbox.net,john.fastabend@gmail.com,jpoimboe@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,mingo@redhat.com,acme@kernel.org,namhyung@kernel.org,linux-mm@kvack.org,linux-fsdevel@vger.kernel.org,kvm@vger.kernel.org,io-uring@vger.kernel.org,linux-scsi@vger.kernel.org,linux-btrfs@vger.kernel.org,bpf@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-perf-users@vger.kernel.org,linux-kernel@vger.kernel.org,jthoughton@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason
 @kernel.
 org,ihor.solodrai@linux.dev
Date: Mon, 26 Oct 2026 22:30:42 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0ECCA10000C
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mjmb9x81pkwmt8cgsdt761p9hemgxrrd
X-HE-Tag: 1793053844-901402
X-HE-Meta: U2FsdGVkX18UGrewWMEfO4MnIJXT/jkS3J11Xsu2JaMV7L9DiDCxL5sUc+5ZZoUoQG5krTC59ScKUAidvaR511Qgh40KlLIlbrB846Hi/j2fH393rMh2KdP9EFghCximfOtLNfjKJkl01mNyUrmMmADtDPDzOhsnjGxE/gUp75AvtVs7ROKkKU6iYijfOcD3XZs0QcQWtdpV4HRF1jpOYDYH5WoW3rGCu556NLysjdIPf/ij04qq3XoBwLjMrJhhwvqGYCo6O5lt/MrVUDBYqvjCT2kbCGfpnesf77i9TLJhgiCJqFDbgodDZ50/jm2Ly0plLSyieCkj3+AJZNMHqs27GwIu7XlRqdzBSZzhCeZeWNrebS6lsEaAf9VpDj0fx5MJJEGwmMLx8gxRAVcWPo7jJ1tV42scPNVq00aU5WmFzGlLxeHPlQVu8r19Eeksr3xq1pejB3YS/sUQdt2MeQ+gcAj7R/weeTA5RM2qBaazudJuES4CsA5tWRRJIa0WspDyjg1LtJfQ5xb+N2cNJ8Q6ApOpIFJz1OzLzuyntiit6DMoJcX0qPW8PKvUfbCDh5wMmbpNSnk2g+UMVJmFOO4FKIYs4bz2fwz7NFsntatF7ZZPo5TtHwCIVJg9Dvd6OTo7JOXeYlBPMiCMUw3Cy9kirhZyOCnU1GRRbQyu/40+x4HzlWNjW1kvyGYSmd9uZVVDg+1LAuW87w/ETH9iN/LCEfEUHaIBBPYVzS205HGGLIYT1MYkvmJWARG8F/NVDw51f3y1jao3PAGx80ljgKdf4/iJjKSiZPDU3ZrL+TxQUZ+oTWItx/f2VG+lO3r6FuE6AHQHAGlSBK81UIU9vLlouaMrVMyueecWnXKsznfHJDKCRc4GoVZlmGqBEHtDM5c336v5jBoFA21CH+a4DUIl+qRYiU+hOq9o56W3fu8spHfgDT6PdeQcghmcedhgVa8yLImYDZTqCUvnP9s
 PSveh9jp
 vHoufhwNbf1bH9dGmH5N+GxzROXQu7IMJX8Wl/IPvBNWC8grmLDe4Z1Zif2/AdCv+NstNj/hdQguqidMhwHkZZs2/OHWD9RfOv0DHR/Juq/OFwIwmq/oRnysUOYg+S3luUBlIO8aiTq3MSGJjJiSav7RXS0qHgH56pWhSxDmhGvJUkLShp93hFvZ2WkeQ3qNfHr0o/AhaI0y3UJEN7sWHnlg1fQf788z8vUvA0opYS6w4vWZKK2xi2apeqEJ5MIHrwDkp7mO7jO0Ojh2GHdOI34GXrBnnGaMWa2lnMszzCRINHfc1RCugfr7wVWFkpPZUmevVspPR2J+b83mOEjJ10eZmpFrabZLYAgGUUPwBb5F6Ows+1bezmlRAroUImBjD6/UHRT3sdSzxuwSvtIq+zennVFzImnI1FuYZpHiDOI8777t+ph1rMRkVPVKxSawOllgXjJl8k6xFUckWc3PCITlm/KWbRubaTxMte4J/DcKaNWcJlaxeTDKdEgIugdhY7ayrxn/di129P9BFcxgBGLGhWUQTonus2eF8PVqyDpg1M/uwPNmtXCNcEvh4Om7goDzWiRdqXGAVi+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============5289104665204023220==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> stacktrace: Don't unwind the user stack without an mm

TL;DR: Commit message only: the Fixes: tag may point at the wrong commit;
7e8e6816c649, which dropped the !current->mm check, looks like the real
culprit rather than 214d8ca6ee85.

> stacktrace: Don't unwind the user stack without an mm
>
> stack_trace_save_user() only refuses to unwind the user stack of tasks
> with PF_KTHREAD set. That doesn't cover all tasks without an mm:
>  - A user task that has already gone through exit_mm(), e.g. when an
>    event fires from exit_files(), exit_task_work() or the final context
>    switch in do_exit().
>  - PID 1 before it execs init, and usermode helper children before they
>    exec, which are created with user_mode_thread() and don't have
>    PF_KTHREAD set. E.g. booting with trace_options=userstacktrace and
>    an event enabled with trace_event= unwinds PID 1's "user stack"
>    during initcalls.
> With the ftrace userstacktrace option enabled, the architecture
> unwinders then read the user stack without an mm. That access does not
> reliably fail: the user half of the address space belongs to whatever
> mm happens to be lazily loaded, if any, so the unwinder may read
> another task's memory.
> Use is_user_task() instead, which also checks current->mm, as perf
> already does for the same reason since commit 76ed27608f7d ("perf:
> sched: Fix perf crash with new is_user_task() helper"). This also stops
> unwinding the user stack of PF_USER_WORKER threads, which never run in
> user space, matching perf.
> Fixes: 214d8ca6ee85 ("stacktrace: Provide common infrastructure")
> Signed-off-by: James Houghton <jthoughton@google.com>

Is the Fixes: tag pointing at the right commit?

When 214d8ca6ee85 added the ARCH_STACKWALK version of
stack_trace_save_user(), it guarded the unwind with:

	/* Trace user stack if not a kernel thread */
	if (!current->mm)
		return 0;

That check already covers both cases described above (a task past exit_mm(),
and PID 1 or usermode helpers before exec, which have mm == NULL).

The check was replaced by commit 7e8e6816c649 ("stacktrace: Use PF_KTHREAD to
check for kernel threads"), which switched it to:

	if (current->flags & PF_KTHREAD)
		return 0;

That dropped the no-mm protection, which looks like what this patch restores
via is_user_task().

Should this be:

  Fixes: 7e8e6816c649 ("stacktrace: Use PF_KTHREAD to check for kernel threads")


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/40410166379
--===============5289104665204023220==--

