Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60C3ECC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 17:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00626B0088; Thu, 15 Oct 2026 13:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1026B008A; Thu, 15 Oct 2026 13:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6D46B008C; Thu, 15 Oct 2026 13:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AAB226B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:49:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AD7D16046E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:48:59 +0000 (UTC)
X-FDA: 85325596398.22.D07DF08
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id 83F0F140007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:48:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j24YHeJ0;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792086537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8gmOZqAjPixYY6Ob7IGv/llQqi0+9XdrKezybj1a6U4=;
	b=QdtSSFukJIy9JMLRPU+GrAJJMTahGpC5ZwrWzU1YaAj/QWQ0bBHPvDqK8vZOJVe1GXfKkk
	Y0tm/ldU/RaT+kCLfcdXJUBoHgcq/5XuOCaDDM6ysrxUGtFHb/x28eXS1e9nB3UoX8SfJ3
	f6pcG2isKxACmVbnh8wyLwmmcBQLw3c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j24YHeJ0;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792086537;
	b=tjzDCZ3/3j35J/UhevqEj7JFzML+D2vRhvjSnwA5syXpIsv2Ka1YaFdTgvywGsnoNaZkcp
	Zjk+fltig8zm0P9WqQk07e8AtnwPBa01ZGLYMcQdy4VVKxZ19mQCENPNwZEAetEJ6v7xlZ
	66smZL2AAuxgLbNJJmir28RPSHGwZeQ=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ac91ac8924so1004039a91.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792086536; x=1792691336; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8gmOZqAjPixYY6Ob7IGv/llQqi0+9XdrKezybj1a6U4=;
        b=j24YHeJ0r5Nztr47FJ9PTEx/FOj2L/hzfclfophEr1jAIHdMlZK0QBy3Maq5ZSSCWs
         ERqyryjRIf4D9UPgSaORkaGhIgQPuMuOx4u2hdMBUBbCbMWH2jZOuDnVOOG87eRiUyXy
         6dlyPcJ68mJrtA+kbGHI8BhOQBvlA6psgNA7F7Hn1oBT5Jey8nRJzWUjYTNTEaQSnEWq
         0CJK+4vZ2qfkrxHLhzhqEw8en5ySE/50diQ8RCAH+dg3BDuNMTcWGGg3Il2oFfokFJX1
         fpxFEiOtAixalv/BW1exnFGDQw98QxH6pLmKoc+CHXrQ+pDtHMv8Ot9/W8JLVozOBLUu
         MBrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792086536; x=1792691336;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8gmOZqAjPixYY6Ob7IGv/llQqi0+9XdrKezybj1a6U4=;
        b=yTQvFuvRaXnFXPLNEcPfuoZyHlrtKBAjEpsoFzLbaLUsvZIGqCtP3mcswd5kANtlYC
         ny6gizUB8iXod/NW5DvAqAfjAZnAYwtYp9iFWcgFhcutefEoJ8VPntlESXAEgFt3vI2B
         uurFf9WRMJXWRG+gOBBqiJCUVhnrI9BGjE6kQ1e8JYShPwoX+L4OkHsm/+41ATqpJlpq
         +vWmYTh3tIyqNfz3tnS/u6iEB+naLcLIRDzU1ugIbYK2K6XfiTdNcM3AeV9BzjPANExM
         JEQC3m5x4Gq5N2AqRW3fBlEDQGF2FEJZRfLlTgM6jrRgaORvUy0K2SKGD1e1M2TsmQvT
         O44g==
X-Forwarded-Encrypted: i=1; AKwUvBx0gPlcODbc9YWdWKizeFV3RYFduhZt/FHjeGqtb33uFcBHc1ed6PCjZY6iatBeDIH3aw93JjqrCQ==@kvack.org
X-Gm-Message-State: AFq9FYJ+oo2VlF1hSV0uwB03Dmi9A+Zw8wlmlbBsDtGKn1Zo0ujpOG7g
	0lgtJ1Z2kIMMEUwEdecM3ckOR9olLPYpiO8so13X2JvMKwHkNPU+/wgc6cCNkhXR8A==
X-Gm-Gg: AYBFou0/yEeJJNSGW35TkQUCNYHHpWAxsa513jCLd0/RNvVBXxb8UBYtg5rm7VMkaKR
	yxA6WOQ8Vp6pKIMcOaFASca1eqxMyh3ybcg3Nx9WLMLzWHfiGNACXec2HhXBU0N/jdoy7BHRYxS
	uutys3ti3FysiMim0IpRwQTgJp3YaX0UK0gO8M8WFqYPlxJtjGsLf3HVp+hKDhzuFzqDmCexaUv
	B8TZGjzp0osTzpr2dMonxaarYeJlPI9At422xEEo2Nni8+lfs29NkatI1qi8GZi1uJ1krr3gTc4
	pMmQmztkiBQDvA6evf4dOqcnh5QyKFJeIDv7eMnSksEDzec4VEK3zQkHEGIQf2rUmbBFmxDB0m4
	SFJSpVUVketc011YrLurraCoytsfkJRq9K3QI2LhwmuijkVVRq7A7aFR9MLPhcIwUp17TvDTP7g
	AxeOnNOX4IDpwOgHFPTuFK1GScl13nn4EdAVPfFRu1jUoCBw/25qWm9I9CckHSPjEIHusMisb0k
	ehMSEfJBHhsl9rgQWJfjVR8iYS+cIuOteL4PhM/DWiBhw==
X-Received: by 2002:a17:90a:bd7:b0:3ab:f38:2b3b with SMTP id 98e67ed59e1d1-3ab9628e531mr9843506a91.21.1792086535442;
        Thu, 15 Oct 2026 10:48:55 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac947928b4sm5041683a91.11.2026.10.15.10.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 10:48:54 -0700 (PDT)
Date: Thu, 15 Oct 2026 17:48:51 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org, vipinsh@google.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	pratyush@kernel.org, graf@amazon.com
Subject: Re: [PATCH v1 0/7] liveupdate: tmpfs preservation and early freeze
Message-ID: <atESAwf17pJ11S9U@google.com>
References: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 83F0F140007
X-Rspam-User: 
X-Stat-Signature: nfougbmw79y31nx5tjf1qukroew9pibn
X-HE-Tag: 1792086537-42558
X-HE-Meta: U2FsdGVkX1/zH49JIZfjnt7xK/XH6bRZWakbkNxXSUgEWjRNpXht0f4STTAoKEAHua9wK4KR2oY7p8xWOjdF5guvDfKD4C3ipSIedDrA5G++z0tH8DLrjWDqEN5uvTO2tZv3UkMXozsDdCgbaPx9b8jWruT1jaxLjxUeoaI/quP7ov297TXu10aeR1nxRq1f7LfNJILMLIiDVSS7IWrNkYjK65ezpuhJAi261hw+3nrFCoQJFFfqxsPKhccoaoJKHc0ZCH6ec1M9pTV1jrJ+wNDzgoq2K09H9vkWRpkGKKMQbY4DHX7ocGUlyTyjTr9CSLIW8B7MruHPdAtWV6261thaBPUKF6KlYO17RRAyJSoElGQoat0wjiKkodLdYpj447FPWoY88JfmEcmGlXCzOWM6jUkNlXrUw0zp9vuHO4f4OziwEgXcFZ3yepaitS9dnAjhd/gH/7/CpgUTWnfeeceIF7leLh71bWPQDJ2rZ/OFJ4FGxJXvyf+wi6fkQKSCeXtk/a7FHesxi19UcDcDgisBmi9vUnF4YF9AJ3BghtP5gQEM0qgrI2h7jwBmayUrCl5LBB7ExFMyMeW9nOIhU/URCqw19zjtSt+Z+OCh5v7V6nETNNvZPrPMd1pBKFwBeB3/S1ruDktu68YYj5o3BwhSCQM+6o0onPqVNVEjSWN/56MaVO6vOplOqtQMdLGwxCk9LndGrcu+n2V90vijCKpI4f/jFag4ehbC10wsRN4lWaVJqRfrqyEifpBkjgr82k7V15tFQf5z2wtZRzhWIBMqy7ATOHiPuPzSG8VASFypSNwl8mwX2Kvjfc+vxzLz6SFkQY+n19C+yQzCr4tW+g7rCjl5iMNDMTV2T4XMvVZKdj7p5p2j3WTCeP9jKdpdwJDzl4Bl3aNmmivwhWBm6VIhiEQ5pEl1XEFnDpu7WeUWBMLiUPE/pFh0YCqA/+BohWMfJSGMBjxOXjWEm8p
 FPfn27Pg
 RNitsQeSZAIeffVmvPpeppdEwFnyDNRnj4tY9QoaBUQ7hkLgy1MztOeC5bJnZy6fXEGR+XLBZm5JfLL9ZrbfxZVTl4ZXqoQo/sP0cFI3ocyGWL9p496hJWBfvkZD04KfJABCmRBI/dYt3v1r4LVHBkYnpvbSQED5Dq7TfWzph+QEfdfFYl24yZ12AK23UWQB19rgk/BkFBp9+M4xPHMfj7TU/t0upRSG+Xt1mWpOIZPNXCJwyztpIqZ0t9ju8bYkLrVYkXWUKuNKIc484gR0lqhFe3RB0nXVy8iJj/LflOhGaiWwAVX4LIVz+pOglsyElRYihiZK1t4jSZWfl2OPQF8pTJ9vbYCpv+LBrKMGypeW+0KE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-10-15 05:38 AM, Pasha Tatashin wrote:
> This series allows preserving files in tmpfs via LUO to survive across a
> live update, and allows userspace to decide when to freeze a session
> instead of delaying until auto-freeze at kexec time. Once userspace is
> done with a session, it can freeze the session immediately (and across
> multiple sessions in parallel), reducing blackout time by not postponing
> this operation to kexec shutdown where all sessions are frozen serially:
> 
> 1. Early session freeze (LIVEUPDATE_SESSION_FREEZE):
>    Currently, LUO sessions are frozen automatically only inside the
>    reboot(LINUX_REBOOT_CMD_KEXEC) path, where luo_session_serialize()
>    iterates through all outgoing sessions under global write locks and
>    freezes them serially during shutdown.
> 
>    Add the LIVEUPDATE_SESSION_FREEZE ioctl on session file descriptors so
>    userspace can freeze a session as soon as it is done with it (and freeze
>    multiple sessions concurrently, since luo_session_freeze() only acquires
>    the per-session mutex). During kexec, already-frozen sessions skip the
>    late auto-freeze step; if an early-frozen session is closed before
>    kexec, its files are rolled back via .unfreeze() before being
>    unpreserved.

Thanks for putting this together. I'm on board with driving
retrieve-into through a per-handler argument instead of a LUO-level
flag. It's what Pratyush suggested on the RFC too (sorry Pratyush, I
never replied to that). I still need to review the actual patch but
I think the idea is fine.

However, nothing ties the arg struct to a handler, it's interpreted by
whichever handler owns the token. At LPC we discussed letting userspace
pick the handler in PRESERVE_FD/RETRIEVE_FD, so that it controls which
one is used when more than one can take a file. If we do that, the
handler name would also be the natural key for which arg struct is
expected.

> 3. Tmpfs file preservation and retrieval:
>    Using the file handler retrieve argument, extend mm/memfd_luo to allow
>    preserving generic shmem-backed tmpfs files (not just unlinked memfd
>    pseudofiles), recording MEMFD_LUO_FLAG_TMPFS in
>    struct memfd_luo_ser.flags so that preserved tmpfs files must be
>    retrieved as tmpfs files and preserved memfd files must be retrieved as
>    memfd files.

I've been working on a v1 of the tmpfs preservation since LPC. v1 fixes
a number of problems in the RFC that I think this series still has
(sorry for the wall of text, it is LLM-generated):

 - Failures that userspace can fix lose the file. The folios are
   restored, charged and added one at a time, so if the target's mount
   is too small (ENOSPC/quota) or the caller hits its memcg limit
   partway through, the target is truncated, the folios are freed, and
   the failure is permanent. Only bad-argument errors are retryable.
   v1 restores all the folios first, charges all the blocks and memcg
   up front, and adds all the folios to the page cache or none of them.
   It keeps the restored folios in private_data between attempts (LUO
   needs to pass private_data to .retrieve() and keep it on failure),
   so the only permanent failure left is losing the KHO state itself.

 - memfd_pin_folios() doesn't require the inode lock, so iommufd can
   pin folios of the target while they're being added or truncated
   away. v1 starts with two patches that make iommufd take the lock
   and make memfd_pin_folios() assert it.

 - The target has to be opened for writing (FMODE_WRITE). Since LUO
   holds a reference to it until finish, that means a restored binary
   can't be executed until the session is finished (-ETXTBSY). v1
   instead requires mnt_want_write_file() and file_permission(MAY_WRITE)
   under the inode lock, like FS_IOC_ENABLE_VERITY. That also rejects
   immutable files, which a fd opened for writing before chattr +i
   doesn't.

 - There's no file_modified() or fsnotify_modify(), so setuid/setgid
   bits aren't cleared and timestamps aren't updated. The normal write
   path does both.

 - f_pos is set through fget() + vfs_setpos() without f_pos_lock, which
   races with read()/lseek() on the same open file. v1 uses
   fdget_pos(). (Sashiko called this an ABBA deadlock. I don't think it
   is one, since vfs_setpos() doesn't take the lock, but the race is
   real.)

 - Early failures leak the preserved folios. The seals/flags check
   frees ser and records a permanent error, so .finish() skips the file
   and the folios are never freed. Sashiko flagged this as well. The
   new MEMFD_LUO_ALL_FLAGS check adds another way to get there. In v1,
   early failures don't consume anything and aren't permanent, so
   .finish() cleans up.

 - If a token was already retrieved, luo_retrieve_file() returns the
   existing file and ignores arg. Userspace that asks to retrieve into
   X gets success and an fd for a different file. I think LUO should
   fail with -EBUSY if an arg is passed for a token that was already
   retrieved.

 - Sashiko's WARN_ON(liveupdate_claim_file()) report on 3/7 is valid:
   xa_insert() can fail with -ENOMEM there, and userspace can trigger
   that.

One place our series are not aligned is MEMFD_LUO_FLAG_TMPFS. My
thinking has been that RETRIEVE_FD should support retrieving into any
shmem file (including linked files, memfds, and O_TMPFILE). It is
userspace's choice at retrieve time. The only thing the kernel enforces
are the fundamental requirements such as exceeding the file's mount's
limit.  When I think about it that way there is nothing special about
retrieving into a memfd and MEMFD_LUO_FLAG_TMPFS is just artificially
limiting how a shmem file can be retrieved. WDYT?

One last thing is my v1 also comes with a dedicated tmpfs selftest with
much broader positive and negative test coverage that I would like to
land (things link O_TMPFILE and read-only targets, executing restored
binaries, exact block accounting with statfs() and st_blocks, including
large folios that extend past EOF, etc.).

Maybe what we can do is keep your 1-5/7 patches and I'll rebase my v1 on
top and send that as a replacement for 6-7/7?

Thanks,
David

