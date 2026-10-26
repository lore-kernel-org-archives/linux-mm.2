Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B71D60A2631
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 22:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WFbyZTea
Received: by kanga.kvack.org (Postfix)
	id 91EC66B05B1; Mon, 26 Oct 2026 18:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8827F6B05B2; Mon, 26 Oct 2026 18:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637B96B05B3; Mon, 26 Oct 2026 18:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2AB826B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:30:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 919851206EA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:30:48 +0000 (UTC)
X-FDA: 85366223376.23.1F59A36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E3A8C1A0008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:30:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=WFbyZTea;
	spf=pass (imf19.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793053847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hDtNVLezgn7PdnL8lxuAMKA3HktkOtqQ7BOccgZ24og=;
	b=2hc+bXl1rIfWqH0Oj23o4Aa4LTPszXI6jOnv6s+9CUvUipbA8VuyqvhpkibEcibv5STGCW
	rBZQJif0XuCFeoFkuqA9A5EWBp1EeyEY/LKB+cnkW5oqGq1kHodqNI0o42ecfkw/8qXGd3
	Di8nm3GF33ZZ10Ihp30ZbUtAHaetRrQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793053847;
	b=Z5qENJWbAQ3Vx5xTiNQgEC9LSaMwWYS9sIk3yHuzI9K1tu2mVotOX/Lkv8BEWu5lHENT8U
	Y/kYsmgy9RyUqVZzoO9e6j6/oiHamgEChZxCpHPz9TseTr8hlpeUxam9WOwyp9JcM4TJpx
	eVfnBP4Le04W3WpUpaZH75+FlrmsF6A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=WFbyZTea;
	spf=pass (imf19.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FD7C43BC1;
	Mon, 26 Oct 2026 22:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2237D1F01829;
	Mon, 26 Oct 2026 22:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793053845;
	bh=hDtNVLezgn7PdnL8lxuAMKA3HktkOtqQ7BOccgZ24og=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=WFbyZTeaLbCY7ikuEs02jXbJsHCKJuFY/nfKSONWHoJU/2S/39wsTuAQ8g+/Md79e
	 DB4TvvDXjasmcGt144E8xgtFsxUljyQhx2sGVcmNSUlwQK8UT6v1M2yr3CugiNXCkX
	 m6MweNqwjERuBLkScl1t31HP2jc07sHYYSpdSJ68gbrdL/+ctrs3iVv9aC7CSLkAjN
	 6sfOzrtVhHenVSn7PIuB9pFdtoetDWKLPpn/MlWVg4bOXaxKC0xsmnyNj/ErH2Bc6b
	 sj8C/3hyI7le0llJhynkd5e0XA9841gGOYgDuz95tXwTXvafMEg0Jn8hmj5vP/quKy
	 U4OyEGKm4+pCg==
Content-Type: multipart/mixed; boundary="===============9203731180031934646=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <10ab2f3b005f0df2c0a88e93e6917826d928bb1f82c6a645f942c099e48f8b6e@mail.kernel.org>
In-Reply-To: <20261026215226.3713941-4-jthoughton@google.com>
References: <20261026215226.3713941-4-jthoughton@google.com>
Subject: Re: [RFC PATCH 03/10] bpf: Fail sleepable user copy helpers when current->mm is NULL
From: bot+bpf-ci@kernel.org
To: jthoughton@google.com,akpm@linux-foundation.org,viro@zeniv.linux.org.uk
Cc: tglx@kernel.org,peterz@infradead.org,kees@kernel.org,arnd@arndb.de,david@kernel.org,ljs@kernel.org,liam@infradead.org,vbabka@kernel.org,rppt@kernel.org,surenb@google.com,mhocko@suse.com,seanjc@google.com,pbonzini@redhat.com,jmattson@google.com,axboe@kernel.dk,asml.silence@gmail.com,James.Bottomley@HansenPartnership.com,mkp@kernel.org,dsterba@suse.com,mason@kernel.org,ast@kernel.org,daniel@iogearbox.net,john.fastabend@gmail.com,jpoimboe@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,mingo@redhat.com,acme@kernel.org,namhyung@kernel.org,linux-mm@kvack.org,linux-fsdevel@vger.kernel.org,kvm@vger.kernel.org,io-uring@vger.kernel.org,linux-scsi@vger.kernel.org,linux-btrfs@vger.kernel.org,bpf@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-perf-users@vger.kernel.org,linux-kernel@vger.kernel.org,jthoughton@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason
 @kernel.
 org,ihor.solodrai@linux.dev
Date: Mon, 26 Oct 2026 22:30:45 +0000 (UTC)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E3A8C1A0008
X-Stat-Signature: f5fhmwt415q1cwcaa1817qkc9b39ahpz
X-Rspam-User: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793053846-992346
X-HE-Meta: U2FsdGVkX18inCX2xoz2eVljpVHHRbg7wf0iZr8IkX07TV/ar+kcBUfhcNr90HDds5HW+gTAgV7eaeI98ogk5y0qdMAXbgLlcKv09wXVz2kfbqK8P4iaYhZVdYVBNwRkaR5aeSyLUnyXrMr+GYXGVr6A8MyO6TVYsG5bXWWW7Rn4oJO+E3FvJj24qztEa04/rLkcUdnnHW6J0Cso7cSN3HHPOkLt13edgFv+PtaF9O6KrM6EDDtnd52SS/P0mCAdqg4l6r0VokavoaeqhADWw8tlfbvt2LtxJaYmYEVpz/m/rYJfhjvMlSvOPjLoTkFvCjcN3I2mvQ1G8qfsFjdFjCEaJRVj11Ke5ZEvofdBINprOL2u6FKYpEG21TPL/CFeHGRXVZLWOVZlHBT+pPdCtj3eo78iQ66JQRQJX9hh7PBTDe97bmaIYggr2p/JVKyZjirDt80nN0f1IAVUW460gkVnJsiZbAoBXaz2AuAz5JztNCkvU3OyD+qBVAZ+9A6ylImRtnC5vk1TAKtYoAol3A235NgukNvnJmxMQXN+mKRm8vgSun6YPL76SssJNkYYtEJ02zkZXYML8+e+7df2O3CGcWJhUqBWdSiqBmus9CB8KK1Hj2Fz6CAB70trJqSqlt3PxwRqISSZ9l5XURQld2c3bG1vJ4gpfmRQXpWMU6H6Ig+HZc9kCwzIH3rt7cS2pC9JIIHyn8c9lfGrcnorLWVU7knX3QKXI/SCylafcOg3AmTkxd/NHWHccW28OgpyTFHMSr/x3Wf+BgfXZ5Q9FMN7K8J5VDlSknUOotrMRweBhRcsXq8OZR/WdBBTtmY7S5U3ZebLEkBa3hxmJRRXMT0QpR7xCzgNDjgcb49JQxeMpwno3kfiWM07qRJxVFvKaIgk3JkDnSFjCwEtKSqqT0K4SjTgG75CluWWDcB7EX8j8xQXynf1vSykPtqkbTe+uJlEtvLKRVpJZ6JaCF+
 rQn0c5Bm
 2TK7eZH3fbNzCMfQUmF1rilPiKSiRuDFVZspHpPnyiFse9sy3gyirUk/7dP3TAXFuO1QD8gAAe3IlC1HgO+H+keK52mp+92WEqC6EtBdPqAPb1s02aY45Nl5me70j1A3yCJ57eOMPlJwpZB/ZuF8yLpSHMJdW2gpa2JC1UdiwcagVPnAvQYSlC9n0Wb+8rhCCJXv0l9NSd13tDnxC7ruxJ12BLcw+e0sDgzHBqwz5+ydYYiNCgLdARfURrC1P5PAlJRPC5JQoLdnrvnfL8peauT5Gd9TAZ88ZKWgsr9imyDv6hCaZOJmwaPqfNkOKBGLjnapFgrXRbdVRpZbRAd/Qj3i5knGgWpUg6PNyetaFfRx+wCH4PPo0MgsBAN+8lfnC8RGZTfFjndbB0s7UFUkpqD5K4FyftUUp7o7IkofvARJ2AtE7XkF/FpguD8ENrrLHZy7qfrLCXTpZmy3ylnH23SS1sbw/2JAvKZ8cVTh2cZJf4in4XzOny19FKZDyRuASyO4UTg5LkNG/iNRpwSnuZ8cThCxPZ3rfy0hYL60v96v233Gy5Ev6EbDEKrtcY96nV0wsJ5VDxSX34mU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============9203731180031934646==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> bpf: Fail sleepable user copy helpers when current->mm is NULL

TL;DR: Commit message only: the security_file_release() example of a sleepable
program running from a kworker looks inaccurate, since such a program appears
not to be attachable there. The fix itself looks justified.

> bpf: Fail sleepable user copy helpers when current->mm is NULL
>
> Sleepable BPF programs can run on behalf of a kernel thread, or of a
> task that has already gone through exit_mm(). For example, bpf_wq
> callbacks always run from a kworker, bpf_task_work callbacks queued
> late enough run from exit_task_work(), and lsm.s or fentry.s programs
> may be attached to functions called during exit_files(),
> exit_task_work() or from kernel threads (e.g. security_file_release()
> from a kworker running delayed_fput()).
> In such contexts, bpf_copy_from_user(), bpf_copy_from_user_str() and
> bpf_copy_from_user{,_str}_dynptr() (when reading from the current task)
> call copy_from_user() or strncpy_from_user() without an mm. That access
> does not reliably fail: the user half of the address space belongs to
> whatever mm happens to be lazily loaded, if any, so the program may read
> another task's memory.
> As there is no user memory to read from in this case, fail with -EFAULT
> without attempting the access.
> Fixes: 07be4c4a3e7a ("bpf: Add bpf_copy_from_user() helper.")
> Fixes: 65ab5ac4df01 ("bpf: Add bpf_copy_from_user_str kfunc")
> Fixes: a498ee7576de ("bpf: Implement dynptr copy kfuncs")
> Signed-off-by: James Houghton <jthoughton@google.com>

The commit message gives security_file_release() as an example of a place
where an lsm.s or fentry.s program can run from a kworker:

> (e.g. security_file_release() from a kworker running delayed_fput())

Is this example accurate for the tree being patched?

bpf_lsm_file_release is not in the sleepable_lsm_hooks set in
kernel/bpf/bpf_lsm.c, so btf_id_allow_sleepable() rejects a sleepable
BPF_PROG_TYPE_LSM program there.  bpf_lsm_file_free_security, the other hook
reached from __fput() through file_free(), is in untrusted_lsm_hooks rather
than the sleepable set.

For a BPF_PROG_TYPE_TRACING program, check_attach_sleepable() requires
within_error_injection_list(addr) (or a syscall prefix when
CONFIG_FUNCTION_ERROR_INJECTION is off), or an fmodret set with
KF_SLEEPABLE.  Neither security_file_release() nor bpf_lsm_file_release()
has ALLOW_ERROR_INJECTION, and the only fmodret sets are in
net/bpf/test_run.c, net/mptcp/bpf.c and bpf_testmod.

That suggests a program attached to security_file_release() is never
sleepable and cannot call bpf_copy_from_user() or the KF_SLEEPABLE copy
kfuncs.

The fix itself still looks justified, since bpf_wq callbacks run from a
kworker and is_async_cb_sleepable() is true for them.  Only the example
appears to be off.

Would an example that is actually reachable keep the changelog accurate?
For instance, bpf_lsm_task_alloc() when kthreadd forks a kernel thread
(current is kthreadd), or bpf_lsm_kernel_read_file() and bpf_lsm_file_open()
when a kworker loads firmware with kernel_read_file().  All three hooks are
in sleepable_lsm_hooks.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/40410166379
--===============9203731180031934646==--

