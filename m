Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCD49606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 15:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=We4ZcvPf
Received: by kanga.kvack.org (Postfix)
	id F20456B0A4F; Wed, 25 Nov 2026 10:33:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7376B0A51; Wed, 25 Nov 2026 10:33:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0AA26B0A52; Wed, 25 Nov 2026 10:33:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2FB66B0A4F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:33:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43F83140F23
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:33:38 +0000 (UTC)
X-FDA: 85474036116.20.80E0A8F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9262FC000D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:33:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=We4ZcvPf;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795620816;
	b=PYhakianKstTHu3bfJIydP6O3f2TKoDtjvlNS5RtOeNjIDH1ADJrTV6qFlFZF4Yq7a6b2h
	690T+/JxRIbVy7ckGCYn6ITZPDsI7C0eLwNnDCVC/TWsSwdBP9ORW5PdaYtsN1A9nEjJra
	axiVeVzaDXJdxjGLfOSuWhybkjldrLI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795620816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+vF0i9sfZKUXmupXO2GXat8RGnc/R+fwUIydX1npxU=;
	b=xngKtDx1q45CVz+I6q4oq1Noo0Gb1T1SiwrkorT+PXNtB+u3EP9gHbID7kwxA8hRXTSdPs
	rOnrK0bdh93YYE/oBs0ZFBd0o7vzjQ+xEqJMe2CYPCd2iQ4He9Qwjx1iGyVuWpUIOrhN+u
	Jx9BFVExVQ4bcTMQ7kTRGY+lUviRVms=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=We4ZcvPf;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D87FF438BC;
	Wed, 25 Nov 2026 15:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5CA1F000F2;
	Wed, 25 Nov 2026 15:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795620815;
	bh=4+vF0i9sfZKUXmupXO2GXat8RGnc/R+fwUIydX1npxU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=We4ZcvPfvGACiTc0GdegtIgoPDkj5NaWQ/nMSlh2b5Cjv8l99WoEfwMmGVL+VhapP
	 +9qmZU9xhNSlWCTWXEPXhw1TIRLYR4PXqODqf9+8oCR4TFftuu2bxdhMHb1ZJgyu87
	 /G0cSUvEEyMb+FN7FpThCnn2aFHueEmF1nj0LeUyoNF971x9+EJRpB3vIWvb8xbckm
	 /K0QP6jFu9d6KpPngQbMS/1i1hsWwhuZ8tf5OmQLzaXUrVyvj+RdF6zD9OoeY3ZR9U
	 yXbF93c4RA673PR0G6R1nkft8ISvvfAp/lkvqL1TB/kAJKv059Bb2OZlf+4aHH0QXo
	 Jkgihn6t/1uHg==
Date: Wed, 25 Nov 2026 15:33:28 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: david@kernel.org, corbet@lwn.net, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	rientjes@google.com, shakeel.butt@linux.dev, sean@ashe.io, neelx@suse.com, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH] mm/oom_kill: optionally log victim command-line
 arguments on OOM kill
Message-ID: <awb6I0qAySbhBIsW@gremlin>
References: <20261124205043.1010247-1-atomlin@atomlin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124205043.1010247-1-atomlin@atomlin.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9262FC000D
X-Rspam-User:
X-Stat-Signature: r1g6rex9sawb34z4amhwur1syypu8ncj
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795620816-561107
X-HE-Meta: U2FsdGVkX1/mk/P8Icr+CWq2/NFiGwcZfSKK0SFW1wqTcQi6QrtX15kek1qlwkOZj+9PEwwFLzREXLDw+bYqTOB0YF69q6j9sfYhjdPFTAIKZPZGR1eEao1vtrwsQczrN6lTmqnmPDqVCsT20f8A9dbut3w67xr3KXa7pel0Uo+LJsuBr7hHP9S4C/wx1qjxMTAyK/3wxDnaBx6T2y8f+OLeHNnqJHmEv6HhuqrhBVh1/oagIFryt74xfM23KMvbE6rqvqZsmIPqLbqUyiCC6q2ftTL6J8ei1xu5P7lThSk76qctDaM39rIjpFd0I8KngPkpJGfHNMFNTkJtpqF3RNAi5R8Vn+wA/beR1AWkWLHqUQGoqwOsz6g/S3nrikYsNqRsvktSGSr6KD9pcubBZPI1+YLY/xN+aNkXXljxfnIisReaogs8AiaBRGD1DPuN9GBC+Sk6bPfBQIMo6xzm/YsCf2DagKLhzkMktNEn1ehSMI8DS/dUl9PNfGNfrh3VMuhZOojsyk4uJ2+u5/t+LUuTktvQ4oCxzZhhn+vcr7QxQB3vAPvxKbQTsqMEPdP8PFai3GIOx8GVaApymKX1QbG1QfnSSf1eL1LxKAOZkSy1MamhvZ5F/HrP3Mdi1SN83DPFIVsi3vZ4u2Liqf5rkfHyaCoeSscl1c6e1LbK1Bt9L4OM/+b/lYY0DimCMjXfzpPtD80ty+pP8awl0g70ZL6/lWSkrICJJfUcCZNLDg8a6d3+tNN/kaFOtlLtzXX788g4XXaHtEQQHjoGlLCEC8iE+cdghA/dteeAJTpslalnIwqzh9oMQrc4dPpODS/KrcKJpjmxvVbpX/l3BeCd1bg/lcQs+wG+EHj994JFMwC7FBnMPWLm1FCKmwdjlfTt9XtxuIgOlKV96EixZ9SprZ5aDA+htJTtjP6xe63C0s6UhgKRRbEh2wYgBw413VsiAD/W67qFbHQjDtjZh7+
 CJf3bv3i
 tEK73C7PE9l3/m4OEzgIDubpBdXeKOo3wiUkl5VJ3NPetRQ94FjrnjfIxuKdJV7K1V5xkdd+5el7OXwE/jqfii4jMbDxnnU4nMCo3e9Dn9O/DAijWb+RDNDjS8P5+OfRKu7qKLxyQjPW8xm7TJeZxHy/RN7o0I3mRxjnplMHcdOvfn43HoNYusuvFvUhC6Ezc3ba+mzbO6jma8trvAHNuj1CtzI7dvPuHq+8jj/680ita/6jTneNU24yn6UrFvKU4svCiXhwsW/KlTo287ePyTxppbHkLTzZzRNkOddUNsPd7ChOW9VNwaRbF2u1oCu/IPHBH7xz3bFAzHDpmoooNX5abMp39NZWhtZ1PofQ2lKwUFph9sofqPYSPt+C5iqKJebEb+g3k6f5SS57bQr570IY7Kkh0+fX/jju/+WSUu1o1+dvxX2ZZL9p7sNELGrrDXEGzM/bUs2b7UAjrRRlnyrq+txfvzuGk1wLO5pWtcXJWbRnEQBO4Xc7O2MYGxQD6OhFtV3OjsslCVyn7IGkhUbe4L1GvGMV9Bj4NTuMtitWLmAdwMQzTPCsqhxBv0eSDqePrAzLy3Po4Tgw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nackity nackity NACK NACK NACK!

This is terribly, horribly broken both in concept and implementation.

On Tue, Nov 24, 2026 at 03:50:43PM -0500, Aaron Tomlin wrote:
> When the OOM killer terminates a task in __oom_kill_process(), the
> kernel log records only victim->comm alongside its PID and memory
> counters. Because comm[] is truncated to TASK_COMM_LEN and typically
> reflects the interpreter binary rather than the executed programme or
> script (e.g. "python3" instead of /usr/bin/python3 -sP
> /usr/bin/firewalld --nofork --nopid), identifying which service or
> worker instance was killed during post-mortem analysis is often
> difficult once the process has exited and /proc/[pid]/cmdline is gone.
>
> The standard get_cmdline() helper cannot be called from
> __oom_kill_process(). OOM kill paths run whilst holding oom_lock, so
> blocking on mmap_read_lock_killable() risks deadlocking against a
> thread holding mmap_write_lock() whilst waiting for memory allocation
> on oom_lock. Furthermore, get_cmdline() walks user pages via
> access_process_vm(), which triggers page faults, memory allocations,
> and swap-in I/O during an active OOM condition, and drops an mm_users
> reference via mmput() that could run synchronous exit_mmap() teardown
> under oom_lock.

Also, fiddling with the memory of a soon-to-die process under extreme
memory pressure is insane, additionally _holding that lock_ under memory
pressure is insane.

>
> Introduce an opt-in vm.oom_dump_cmdline sysctl (documented in
> Documentation/admin-guide/sysctl/vm.rst), disabled by default to

'Have mm people support my code literally forever'... and make it an ABI
requirement too!

> preserve existing behaviour and avoid exposing potentially sensitive
> command-line arguments unless explicitly requested by the
> administrator. When enabled on CONFIG_MMU builds, __oom_kill_process()
> attempts a best-effort, non-blocking read of the victim's resident
> argument vector (including setproctitle(3) updates inspected via
> arg_end - 1) after releasing task_lock(victim). It snapshots the
> argument and environment bounds under mm->arg_lock, acquires mmap_lock
> via mmap_read_trylock(), bails out if MMF_OOM_SKIP or MMF_UNSTABLE is
> set, and walks only present, non-PageHWPoison() anonymous page table
> entries via folio_walk_start() without faulting or allocating memory.
> After dropping the page table lock, each pinned subpage is flushed via
> flush_anon_page() and copied across kmap_local_page() and
> copy_from_user_page(), and mmap_lock is released prior to calling
> printk.

Ah the giant slabs of impenetrable text that reviewers are supposed to read in
detail now... LLMs really have a lot to answer for.

You (or far more likely your LLM) is just describing the (horribly broken)
code in English here.

I hate how often I have to read this stuff...

>
> To preserve backwards compatibility with monitoring tools that parse
> the existing "Killed process %d (%s) ..." message, leave that line
> untouched and emit a separate rate-limited companion line sanitised
> with %*pE when resident argument bytes are recovered. For example:
>
>     [  124.819203] Out of memory: Killed process 1482 (python3) total-vm:184320kB, anon-rss:42100kB, ...
>     [  124.819215] Out of memory: Process 1482 (python3) cmdline: /usr/bin/python3 -sP /usr/bin/firewalld --nofork --nopid
>

Doubling the output in a way that is super confusing, great! :)

> Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>

This patch is broken in a million different ways.

The process gets sent SIGKILL and _then_ you race it to take the mmap read
lock, which prevents the reaper from running?

You do a lock inversion between oom_lock and the mmap_lock, and hope it'll
be OK?

You take a heavy rwsem lock while the system is under extreme memory
pressure? Which, again, prevents the reaper getting to it?

You do heavy operations during one of the most sensitive, dangerous times
for a kernel for a nice-to-have annotation?

And dump_oom_victim() already outputs memcg information, which systemd
uses, your example mentions firewalld so likely that'd _already_ give you
the kind of information you are interested in (except for mutliple
workers).

You're adding a ton of totally broken complexity then, insanely, making it
a global sysctl flag that we have to support forever as an ABI too.

You intentionally abuse folio_walk_start() to do _what its kdoc tells you
not to_:

 * This function must *not* be used as a naive replacement for
 * get_user_pages() / pin_user_pages(), especially not to perform DMA or
 * to carelessly modify page content. This function may *only* be used to grab
 * short-term folio references, never to grab long-term folio references.

You're (or more likely your LLM) is literally copy/pasting code from
__access_remote_vm() combined with this mad abuse of folio_walk_*() as a
proto-GUP to... get more info about a killed process.

You also copy/pasted wrong so this is even more subtly broken.

You are also potentially exposing sensitive information. Your ratelimiting
is broken.

Oh and of course, you add 256 bytes to the VERY limited kernel stack at the
point of an OOMK.

I mean I could go on. Even the concept here is fundamentally broken, so
please don't waste our time with respins.

Thanks.

> ---
>  Documentation/admin-guide/sysctl/vm.rst |  30 ++++
>  mm/oom_kill.c                           | 206 ++++++++++++++++++++++++
>  2 files changed, 236 insertions(+)

Of course it's also a massive patch...

--
Cheers, Lorenzo

