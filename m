Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE53BF30283
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 20:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD2F6B00A1; Sun, 15 Mar 2026 16:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B47A6B00C6; Sun, 15 Mar 2026 16:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DDD26B00C7; Sun, 15 Mar 2026 16:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B82A6B00A1
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:48:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3870140813
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:48:28 +0000 (UTC)
X-FDA: 84549485496.27.B4B90E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1D4BC160008
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:48:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lHIdGpox;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773607707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYuLf+FLkpXqdsfg76tP4KMTyb7rRxrYHTc/u6iorn0=;
	b=7wuFScoHlbc6XynLnqrqKQWKowNPe5UPGdcr/Pd6UdukOvr5eK3FJcQLiV0IDqcYJ8NVzW
	HDz6XWMN27dezgwfrMdBwzZSa7mpD9V7GyCCAuA6qEE32F6hqZd5kUERLaWFGBlDdkhXdY
	z7g3FnEW73dLW10nXG4m0TWWMXVFhkQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773607707; a=rsa-sha256;
	cv=none;
	b=kNUcHsHdobLaK8G9B8acT/N2knIrBtUtQ7OXcUTeblj9Mf6gbmLIxci2jiiHQIirrnmKTR
	hAVZrolc9ZjfPOUejMiBimLOv9RgPmJFt/pT9ljFiOkdwACDPnGa4ox2i0M0ZdqlKWLaHE
	SEqoH99OroaverxIjENfxsI/AF7/l7M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lHIdGpox;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 741046183C;
	Sun, 15 Mar 2026 20:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93439C4CEF7;
	Sun, 15 Mar 2026 20:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773607706;
	bh=AKmldbxaY791aD9Xfil/Ru0vWSAymPxRXmxXjFu7b4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lHIdGpox9WtCzyIYJU69aXY52aRr6S/+Jtpm4Uj3GMYvPIe/DbAbkhO2KTdk9isdk
	 AKigtKpt+XI0v1CkX1wEF1tZQ4VMhtnuZYM4O1DtCogSwx5ndxAQ/h+ZjeStqx7CyA
	 g+SYgZFMm79yVu4f0CKWufIdrZrSeIRqAM8r0st4Bt8SH2Xtym/Ta2V0Ap0RWM3mtc
	 qM/lUbt+vKwjfC0MPnzrCVBDSnQ4VjG1omxkeSBWD3bJQ2CW9svPUNXKjddNRwGS5r
	 M9kFLqt2NSyezpiP9CVe+UnnktWuJML5TAQysTAeIAZPyygY13u1jXZ8KgLqKIgV8I
	 5jH+57S6cRiSg==
Date: Sun, 15 Mar 2026 20:48:22 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kit Dallege <xaum.io@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, corbet@lwn.net, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH] Docs/mm: document the OOM killer
Message-ID: <fbee0ca1-4de6-4182-865b-a33d9ed32ee4@lucifer.local>
References: <20260314152518.100194-1-xaum.io@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260314152518.100194-1-xaum.io@gmail.com>
X-Stat-Signature: hg5cbp4udzt3ybmm6pswcm7s9mc6dx5c
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D4BC160008
X-Rspamd-Server: rspam12
X-HE-Tag: 1773607706-135399
X-HE-Meta: U2FsdGVkX18opZlW8YIClvzoqny1KTJkCg9Y/FzbKtOOKfvJounQP5muTA6FBGpuPwTIOFIx4B+QzJB+8eA4L3Hv6cGwbInrMEwi3U//daXqSDhTZu7+RyFaGxUvXnRExlpAwk4HPaiyYi1ndntr4NaVXn6cLxLftFSOPDZYjx8YrjoLKDG505yL3Tqf/V+oLrqxa7/oVn6CGKA9JpaEaXcX+4JE/iEf6wJm3CPYfegh3N+MoMhB5iqx9aB+ELCUtjG7MADQ8jyn2cAZtyqWIGFB5DJRe2Qc0APZtw3oGK1nr7Qzzycv0jgv8gl4lVXRID1HMg4V8O2dy6qnBz9EukHFU1kS/1ClB8JoXPLhn4snRqXq8GgsQNtj21BditeD0RPq5N9sZd7WwQHPMfxx8tR41LITqlkfOEW1N1CkUqXZgnZVOGuarhNiO5R+TUXHTEyUBzI6D5dvSyFJ1aZb1gH+gRionbvKs+pINwH6whyftPVix045Hn6oQHXfJWMG77PKkDZWU6THV91/R/3cR1JV0EFxPP/6wn0WOVvOX82VzyIDhs6EDzgT7cGAhd5vBfD2cJ2XBtKTGdlroFXmX0utr4V+rMbkH/N8VAFmeMffk3SHxZ1pQTErZx2WdRnsrPvFDBUtxUwUBVJgSpbLObitv36UNqeuBhO5/mWHq6LunficukTEQCJfP+ozrD5071y9RnRXSThJXxyuv2PJWZI9btAAv0dZFPVS4xVZg0tblyPEf7hEIX1vvHB8uzl4tMVSarSvOxhbVwEDbiDbyJ/JSYmFs9wByaSp25HQ+LN197aHCKDfBisi1JEhSFBIz/UQ7KuBftWz9aAet4/Ptv4+5ez4zQ6IW08KNq11QogroyWsse30QRrVja8YxfbaXli7+Xf2Q7dm8tm2+6LJcpJ4dsfv/7TewTrpKoUQwKNpggfAsJCI5VWGyuF1ANPnXG/ugy/Rgy0mAVl5Jvf
 ct2Bq4Qu
 YzE2ENViTb6ZXDILm2L1slzXXTMfxh08zTWEqY6e7TnnElH7KEq0S/agnaMhDoAcvQh3kXkm7bqbaJGgSvmS9XibUIgFDGqA2r5ofNwp5EVLm1D9HoLQH2UM+8E0VeskAw4kfYS3XbGyccOuNLGba7rKhfsY/fXDxRGWS4guQj2+Lret3/RwIe3OmwqPxJt8yseC7jkR7ZXCFLBvhqQbgJFGcLVgHJyJ28DwJttLlgTacANlQHdmxaNGjlaPaHLLqmoI0kS+Eu+TwTmQi9+ihL7kAuMjTGMpFUTf5INyaJ3LmHitt76QelvViNV0mD7CdSlGSkqszqJYGW7c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK for being AI slop again, obviously.

Again, +cc the OOM maintainer you failed to bother to look up.

Reasons, as the rest:
- Worthless documentation
- Everything about patch screams 'zero effort, Claude did it all'
- Bad etiquette

As with all the rest it'd need to be totally rewritten and it's not worth the
maintainer time.

On Sat, Mar 14, 2026 at 04:25:18PM +0100, Kit Dallege wrote:
> Fill in the oom.rst stub that was created in commit 481cc97349d6
> ("mm,doc: Add new documentation structure") as part of the structured
> memory management documentation following Mel Gorman's book outline.

I mean the more I see it the more annoying it is.

>
> Cover the scoring heuristic, allocation constraints, OOM reaper,
> process_mrelease syscall, and sysctl knobs.

This sentence contains almost as much content as the patch.

>
> Signed-off-by: Kit Dallege <xaum.io@gmail.com>
> ---
>  Documentation/mm/oom.rst | 67 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 67 insertions(+)
>
> diff --git a/Documentation/mm/oom.rst b/Documentation/mm/oom.rst
> index 18e9e40c1ec1..2259f871a4a7 100644
> --- a/Documentation/mm/oom.rst
> +++ b/Documentation/mm/oom.rst
> @@ -3,3 +3,70 @@
>  ======================
>  Out Of Memory Handling
>  ======================
> +
> +When the kernel cannot satisfy a memory allocation after exhausting reclaim,
> +compaction, and memory reserves, it invokes the OOM killer to terminate a

I mean this is just actively wrong to start with.

> +process and free memory.  The implementation is in ``mm/oom_kill.c``.

Terminate a 'process', even what that is tricky in kernel vs userland...

> +
> +Victim Selection
> +================
> +
> +The OOM killer scores every eligible process and kills the one with the
> +highest score.  The score is the sum of the process's resident pages, swap
> +entries, and page table pages.  This sum is then adjusted by the per-process
> +``oom_score_adj`` tunable (range -1000 to 1000, default 0), which biases
> +the score by ``oom_score_adj * totalpages / 1000``.  Setting
> +``oom_score_adj`` to -1000 disables OOM killing for that process entirely.
> +
> +The ``totalpages`` baseline depends on the allocation constraint:
> +
> +- **Unconstrained**: all RAM plus swap.
> +- **Cpuset**: memory on nodes in the current cpuset.
> +- **Memory policy**: memory on nodes in the current mempolicy.
> +- **Memory cgroup**: the cgroup's memory limit.
> +
> +Only processes that can use memory within the constraint are considered.
> +Kernel threads and init are never eligible.
> +
> +OOM Reaper
> +==========
> +
> +Sending SIGKILL does not immediately free memory — the victim must be
> +scheduled, unwind its stack, and tear down its address space.  To speed
> +this up, the OOM reaper kernel thread (available on MMU systems) proactively
> +unmaps the victim's anonymous and private pages without waiting for the

Anonymous AND private eh?

> +victim to exit.

Actually there IS some waiting for a specific futex case :)) though maybe
removed now.

> +
> +The reaper gives the victim a short window to exit naturally before
> +intervening.  It walks the victim's VMAs in reverse and calls

Why in reverse? Moon walk?

I mean etc. etc. this is really not helpful.

> +``unmap_page_range()`` to release physical pages.  Once reaping completes
> +(or is no longer possible), the mm is marked ``MMF_OOM_SKIP`` so the OOM
> +killer skips it in future invocations.
> +
> +Before reaping, the mm is marked ``MMF_UNSTABLE`` to signal page fault
> +handlers that private mappings may have been zeroed and are no longer
> +reliable.
> +
> +process_mrelease
> +================
> +
> +The ``process_mrelease(pidfd, flags)`` system call lets userspace OOM
> +managers (such as systemd-oomd or Android's lmkd) trigger the same reaping
> +mechanism on a dying process without waiting for the kernel OOM killer.
> +It operates on a process that is already exiting and performs the same
> +address space teardown that the OOM reaper would.
> +
> +Sysctl Knobs
> +============
> +
> +``vm.panic_on_oom``
> +  0 (default): kill a process.  1: panic on unconstrained OOM only.
> +  2: always panic.
> +
> +``vm.oom_kill_allocating_task``
> +  When non-zero, kill the task that triggered the OOM rather than scanning
> +  for the largest process.
> +
> +``vm.oom_dump_tasks``
> +  When non-zero (default), dump a table of all eligible tasks and their
> +  memory usage to the kernel log before killing.
> --
> 2.53.0
>
>
>

