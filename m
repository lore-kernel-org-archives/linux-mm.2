Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A05A2606A331
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MbYntUSj
Received: by kanga.kvack.org (Postfix)
	id C30D26B00EF; Sat, 21 Nov 2026 21:13:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C096B6B05B0; Sat, 21 Nov 2026 21:13:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1FA76B05B1; Sat, 21 Nov 2026 21:13:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 891136B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:13:28 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C8C5160624
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:13:28 +0000 (UTC)
X-FDA: 85461133296.11.FBC62D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 75F5E40005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:13:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MbYntUSj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795313606;
	b=cDt6znNrMuDw+ji6IGPRf/mMdRen9KEgsAKWXR+b/cZHd1gwasizhbtg5RH1BSfqRlvULF
	K+1vEdFzD6E6xJuCqFpleY4mq3Re5EMIpykbdvy3jg8kya4CyZe5bQd/jUa2GZr0GEBXAt
	jJjuujULlpNvLLRD6i/km3SdUKywPsQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795313606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JjRuBovetgGLfxfZ7NqPAG69TmUpxN1W3znDQ9aIDdg=;
	b=ceqbwN3BYoA6oDY5XEJepSyJ7n68+Qm37+ZJgXjmzh6NufRthAV0lKftyi02fnPZge1N2a
	+IbGOtVWaMgnOPn/pujpm93/s95U0MMeGKn8WOW16+APeH4WINuaPYqTtLUEZUJEn7jf+m
	7QvorbDLT7mlY1/fEi/6UQJpZI4VOVc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MbYntUSj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0BAB60625;
	Sun, 22 Nov 2026 02:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DFF1F000C0;
	Sun, 22 Nov 2026 02:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313605;
	bh=JjRuBovetgGLfxfZ7NqPAG69TmUpxN1W3znDQ9aIDdg=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=MbYntUSj43KK0XEUMVZMfKsY3aiOU7ksnkok0GlzXj9Vtt28SDssP3J5GsRfJHmI1
	 z6L5M088BaqXgPlcib1rK5rvsISYYuNPrudiwOa6+nxGcI0MqHaoD78Vdv7y/asAMw
	 iztA46mkWl8XPSBv8yaWoBl4ctG+ccfTMbwJgNy/FfhthBLLLo+rNDZtLpK12DojGO
	 03f9hyahjSI/9ZhRu0COiJEvVYkoRgaNYZTQ874FPAe0pSig/gs6fogYJ8Rl/zGDwJ
	 74h5NE+BS8i74tataIgBme9IWkSlKlH3GIKcBDHYgzwoULDGV2yA7lpC0YXbA5SNlZ
	 qTGbHxhSroa2A==
Content-Type: multipart/mixed; boundary="===============0061437725914904412=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <1a12b0b293d0622a6a3f897306f3cf2256be88befcfdc0bf272ceeb1de6bcac6@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-16-jarkko@kernel.org>
References: <20261122011809.2667684-16-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 15/26] exit: Support P_USERLAND in waitid()
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:13:22 +0000 (UTC)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 75F5E40005
X-Rspam-User:
X-Stat-Signature: dea4wbfez1msfgsxuf8xusr5ywpkphj5
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795313606-299691
X-HE-Meta: U2FsdGVkX18/85gD04R0fMXUNnqPT7GD2bMr+vhOu2RhCR6MHZ032pJwe63oZ6/zqF9lvTaw3XmQtLtNG3mt56uWiIuaxF9t3MbuZvSTd1g0YprjGdot95wd9c5EdV3xUuxcWYyKwBsyHopZaAappXIfD0ZfhKAFuHMi63fXHYqVe7YJn9kOcG8OLO7VHEs/RBViQUQnIx3gc0aA625xijXqvZ470aEEwq8GWLJjwjEIZVN9RHYtXij9okNZhNEJ7Lhai+GHCYjczcFovSZu8tNIK3UabWE7NkILHKMg6kx8VBS4nKQWIhYKlsyo9aKXmIxkeGB3Oz+9Ctd6eSR34DnqPpWmiFolr3ojGEn2NZNy/E68InX/IY0q+GpbzSIC0I2srmqc/Vj6r+Gq3g/wfQYaKH1kLuY2sN6nIFWtwho0Sd7b5SXbYjN9ZlfQ1H3973LCiQ6m4k48Pl+Sa2G+tUOp7e9ASZngLRXayB9fY6+oiGasNxsDfJZJL77J2BUoA5oMExgcYn3fuY9WgOLwlfDaCgbPUcGUMuf/t0n05k/b+6s1RP00gmRAHWnR6lG7sJlHJ747cbjxGLouw6fRzmlMQ61pcfM0hBL4b7tTUs7yWkFTk/x8fwfax8jn+2gxumzNkuvcQqjvVcY7l3vIpyyaMI6Vv0VsGrgUmGlCHNZ/CLjlipSZ4GKphO5/3dyyED+QCffx2NYixvFOEQBdE9NHf63i3jz2xybTPy1jfD9tUGnAAKUVBevaXQwrt3AWEbJQuLEJrv48I0V6UdVRXTz9tG+ZBjJDkzCsc1SPe/TgbRlhj8U87r/+XOkoTEnxLRdVTeYDWAliXLuZ3j03BVvchFj2BYjLtd55hT40lW7l8uYZHby1ZmrEmfg/FAjLxCGBQX5Iz6LnLLpgAV047CGs1odZXva6pri12M870alMGLhGslGRm73Jglf5/hGuXbx4ea26Vyy11wktB1i
 75zUMDkU
 Z+FtGzmqcIQtZCgC4aCAOznxg6gol5GwQrUuTSEqn2w2uhXoaFA7aggoc3HihhWdcJIpDYtzq3pfTCnku/BsOqm2HH6ZnpxBh0VoKsqCLLpQtkL/HSvOihGOX0+Mis0jI1Gcyc4TZRJEywK/LbK9/ZQpwb5yRN6281rEfE1U7MKNS/lQODuUqpu7r5pMqV8CZKa3NtWQAuf7+GKkKdIX1u5juJMKb6QIaSt07gKx3/pzdB8YGcR8TAa3xCkgkcC/ewD+ru0E2udS3hqRVVyr+jn2YKEA3uBB83vr1hS/Y274winQcfDtZ3P3WZ5tsYNV20t1LZ/+zGsd8fZ5sTTIy0TNM7aE8lsZWGSZMEu4FR2iCIaa01g/y4ZWfdwoMGqqSCRiCe0OPCaq1VLZYMwGdSOZFCVbf8ZZwCKPttHHOnxEItPL4eoeL1xm65Mm7mdheOkmaNLJP/4p8eetQAm6XF+y4bSvAtQi6YBL78bqV8JCFi2t9z00DsJ7Nth584QI/D7TvGL+nv4SYNl/W7V8Ixk2WVjL8RwfZMer4BzTZN5RKD7nyD0Xv3hytsT/HQ57t+CaWSDMX6ic6HAMXCaKv1a1kT2AaWx5XRMBEUeDdfi8U56sfhDObguP6UnnG6r13567v9gdUvvjJHZ0ty+6Q1zTZ6hFSsQEvMB62dYPcDt+d080XXNSiE8NcszMMZrZY7dX2FyMqyDd+Oj2nO0EU55urHo+UUr346wH5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============0061437725914904412==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> exit: Support P_USERLAND in waitid()

TL;DR: A blocking waitid(P_USERLAND) may return an unexpected -EAGAIN if a
failed clone3() bootstrap is retried while it sleeps; it should probably
return -ECHILD or keep waiting.

> diff --git a/kernel/userland.c b/kernel/userland.c
> --- a/kernel/userland.c
> +++ b/kernel/userland.c

[ ... ]

> +/**
> + * DOC: P_USERLAND
> + *
> + * ``waitid(P_USERLAND, userland_fd, &infop, options, NULL)`` waits freezably until
> + * ``userland_fd`` reaches ``USERLAND_DEAD`` (unless ``WNOHANG`` or ``O_NONBLOCK`` is
> + * set) and writes init's exit information into ``infop`` without consuming it.

[ ... ]

> +	if (!nonblock) {
> +		ret = wait_event_freezable(userland->waitq,
> +					   READ_ONCE(userland->state) ==
> +					   USERLAND_DEAD ||
> +					   READ_ONCE(userland->state) ==
> +					   USERLAND_INIT);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	scoped_guard(spinlock, &userland->lock) {
> +		if (userland->state == USERLAND_INIT)
> +			return -ECHILD;
> +		if (userland->state != USERLAND_DEAD)
> +			return (options & WNOHANG) ? 0 : -EAGAIN;

Can a blocking waitid(P_USERLAND) return -EAGAIN here, even though the DOC
comment says it waits until USERLAND_DEAD unless WNOHANG or O_NONBLOCK is
set?

The wait above ends on DEAD or INIT, but userland->lock is only taken after
the wait returns, so the state can change in between.  INIT is not terminal
once 498ccb2ffbc4 ("fork: Support CLONE_INTO_USERLAND in clone3()") is
applied: userland_finish_fork() sets FORKING back to INIT under
userland->lock when copy_process() fails, and then calls
wake_up_all(&userland->waitq).

Sequence:

  Task A: waitid(P_USERLAND, fd, &si, WEXITED, NULL), blocking fd
          passes the early INIT check and sleeps in wait_event_freezable()

  Task B: clone3(CLONE_INTO_USERLAND), state is FORKING
          copy_process() fails (e.g. -EAGAIN from RLIMIT_NPROC)
          userland_finish_fork() sets INIT and wakes A

  Task B or C: retries clone3(CLONE_INTO_USERLAND)
          userland_prepare_fork() sees INIT and sets FORKING again

  Task A: takes userland->lock, state is FORKING or RUNNING,
          neither INIT nor DEAD, WNOHANG is clear, returns -EAGAIN

With neither WNOHANG nor O_NONBLOCK set, waitid() does not return -EAGAIN
for P_PID or P_PIDFD, so a manager doing a blocking wait gets an error it has
no reason to expect, possibly while the new init is running.

In the !nonblock case a non-DEAD state under the lock means a bootstrap
failed, so should this return -ECHILD like the early INIT check, or go back
to waiting?  -EAGAIN and 0 would then only apply to the nonblock case.

userland_waitid() is unchanged through the end of the series, so no later
commit fixes this.  The path is only reachable once 498ccb2ffbc4 adds the
FORKING state; in this commit the state never leaves INIT.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============0061437725914904412==--

