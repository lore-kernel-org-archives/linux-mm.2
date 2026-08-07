Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D0CAC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 14:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2046B0092; Fri,  7 Aug 2026 10:14:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352466B0093; Fri,  7 Aug 2026 10:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241356B0095; Fri,  7 Aug 2026 10:14:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EBA846B0092
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:14:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8CCBAA029B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:14:15 +0000 (UTC)
X-FDA: 85074668070.02.F0B5377
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6C087A0006
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:14:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vfmwRR7n;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Gav6SKQL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CEMeKmT0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="L37yUwa/";
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786112053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4ofNE+31BIGjcilMtxKciEXvVlxg/SgK86+li9Dk3w=;
	b=Ut9xYkr8eFUJXvYuwRLMzN63rStT9Bc7YhrTrb7aShwSJLasJP63PdvMijrABMOJ4XC0FY
	rrQahQemf/mPTV9KDqn/OdEFZ5imVgHRZJbNb9h/4wF4ov7v+YdQZGjeus/1WC1nUWMvHx
	VDxSd0/DCYo3dcl6XfPXoTE7WauRLKw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vfmwRR7n;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Gav6SKQL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CEMeKmT0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="L37yUwa/";
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786112053;
	b=FOATqwzC44s1KXqIbFrZa0TE02SdB7lyBXg3avuT4GiZYsa1MkWFPQHJtkgaJSm1ZsID3D
	WEAXR3RDoNhSvklDPukwacsDHx/czY1nQidxDcx+ykJum3CuYQacMGnYAvU79I/6Jmdqxw
	QEISo/Axz6jlGIFjivI0jaDO/r7VDE8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CCED23E16;
	Fri,  7 Aug 2026 14:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786112048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U4ofNE+31BIGjcilMtxKciEXvVlxg/SgK86+li9Dk3w=;
	b=vfmwRR7nzGkRyQDwvo9vi17BiUPwAuX3WykJPpJj25QHlkjai7uP2PdHe12LwjaEdSJ1/7
	oqPIlJep2kwyMzPCVWvVUk0bn/3jzflNrp7p5mwYdz6TauTt2kxQW4U9kY55hug/M5Kg/Y
	5YNBE+Gg42nt1TqyUTxLr+2x3KNrh88=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786112048;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U4ofNE+31BIGjcilMtxKciEXvVlxg/SgK86+li9Dk3w=;
	b=Gav6SKQLcQYWlXGfpToP92xM8rn0anThhC9LWprNkSy+wmNIaAsan0OnOknjELeTT7Phvz
	EGbRyehiwTllHgBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786112043; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U4ofNE+31BIGjcilMtxKciEXvVlxg/SgK86+li9Dk3w=;
	b=CEMeKmT0kSfNgUVWzZRJlK2KYPWxf1nw+casqU4S1R47FxpGgi52XimlTu45Xqzd5I1DD9
	9Kz+WhP4eKbaviDHiMrzPrxXPtIvQa5CT84VOWTUNpFbU8QfkAReLGlhdxnyQwrjErvgeu
	86RqSAohQ1TMStGdyPjNi8qYR1xvExA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786112043;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U4ofNE+31BIGjcilMtxKciEXvVlxg/SgK86+li9Dk3w=;
	b=L37yUwa/8Ad4L2bmKW5TdKHJ5CbKZtDv3dxkzhUAMy9KVIpCqcdj3lUxEnJIY0AljMPk3X
	bds7PewKuAjEg1BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 75729779B6;
	Fri,  7 Aug 2026 14:14:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Xc5qGSvodWrrIQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 07 Aug 2026 14:14:03 +0000
Date: Fri, 7 Aug 2026 15:14:01 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: vova tokarev <vladimirelitokarev@gmail.com>
Cc: akpm@linux-foundation.org, security@kernel.org, linux-mm@kvack.org
Subject: Re: Fwd: BadBunny: UFFDIO_COPY shmem killpriv bypass leading to
 local privilege escalation
Message-ID: <anXnHMInq_JLYbWc@pedro-suse.lan>
References: <CAGBKPgOm8q-8_rwyRPEmSj8JXdh_GaK1Q8vpJ=j-+yA0SgcNQw@mail.gmail.com>
 <CAGBKPgPPALX_5CQJAKUNjwi2fD28pBeS5pRuwQgePU93pOy8EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGBKPgPPALX_5CQJAKUNjwi2fD28pBeS5pRuwQgePU93pOy8EA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6C087A0006
X-Stat-Signature: 88qcwarw7sphzqozjgagmdzdfpcu7bsr
X-HE-Tag: 1786112053-860010
X-HE-Meta: U2FsdGVkX18+cUBuTUoXb/tpsuSqEPqlgm43p/WgIoaLI++dWttqRFHx4Mfauv8qPij8nn2h6fZ5ZN3eoOlno8yCiBCNnsFVoE5hvqBqQhsBejvfuuEZe/9AURyAB+z7Exa/G0x1ghwjsGQ7Uy/9feWq6yLzFhip78yBWom7Fz1TvaHCTOhArAqozvtBtKz+VnuNSNSX7mlFfT2PfiMnSzpELukdWocBzeebL5REniJoEnZzDsRUi5lKib7naExfS6S2fFrZGL3UTgkJkGBYqmQQD1JWoh80GncuAl597obIHd3JB/6GkUWRHwdwXOCoHnis6L1QAbFZ+bUThcf4gO2g68ld6LsR8kDX+koz2ixGvCq5nw+GBMJh4uSViwWUp/zgnFCccaX0emHv84yoW5rdF7ky5or+e17F/3ToiBCFyrcgFIRBNY79YEuw2PjzLSQ56LyYO1MRTAlwZO1TEV56DeMY9QbF62bDuDyOHMdsnd2tfebUsROIbkZ0Xet4rJOu910O4gRPyzY2lgxR6I7Vv2lhM5GqqzRHo3q6SZgJXKOylp3lsDEh4eQ7wsXu+aIjIycrIO2y3qYYkVmLMVm/bSPjCC22Fa7zkZoFghFc49MxS4pE/XFi8H0h2bt2nC2ifgngDaCuhQXKgcFQFCC2GhPu6ZLDeTMUnqmBnmCELXUcESp+y3QYBCGoKQarLcQteYIiaeBO/ErAhxc0UYTzOVPkhVfMcWdrNnU1IVAELxbge4a/0jkvnE+wMWPh/Nzm40BjyZBQp4Rbg+TjJ3MVPN2/7azBN4O2WJB5j6dgJs6xqoEmFIY4Ueom064CzabvhRgrgdAImHI15vc/+QFDQqThFK7bypKlbfIFaNDW+IbAHikm42hYKJ7T7gwUHvcAS6Dobmfr+PoKzxNRsJjzrI9hi9/Pkst551sspyKRn0Ob9DP1sf8SCHllZ8r9c2nTrEVl+rO6ZvUhfFg
 Ft7xVNS1
 kn2+IF1Fuo7YZeh9s9sw3qPeEIBkNYdMHyshTs3X1ekGg3YzsluvYrZu5Q5V+3Xxs6egvDs65KECiqam9Ar3oVHh6khf3Vt8dGabfOmnTcoDTU8Cm+dCOev1dkPgyx1ZDCy++JtrnxI684/zvtwfOi18uDxmoM5LQSC38JMIlFg+Q6bJiFUbmvj6OCOKxJR7N4DB6xUoXMMWApVbMkOnbLtVBeZQm2329SAQ0NNYgDJVymWZ8sLets4G34CFq3VF75dsT/lzXe28jxo9oY8uobP/CwhaqoPtxCaxdp+BGedqJDVt7mEooomRU1b0zQRBnEdDTLcQyswpe3DLLdZ66Y4vjQ2P8oDka7IeOnHeki3V2YDG1zzPaU+QBxsd9GkTwUAUG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 01:40:41PM +0300, vova tokarev wrote:
> Hi,
> 
> It's been almost two months since I sent this report, and I haven't
> heard back. I'd really appreciate any feedback when you get a chance.
> 
> I've rechecked both mainline master and stable 6.12.95 -- the
> vulnerability remains unfixed in both trees:
> 
> 1. mm/shmem.c: shmem_mfill_atomic_pte() (6.12) / shmem_mfill_filemap_add()
>    (7.x) still adds pages to the page cache without calling file_modified()
>    or __remove_privs(). Writing to a SUID binary on tmpfs via UFFDIO_COPY
>    preserves the setuid bit.
> 
> 2. mm/userfaultfd.c: I noticed commit 85668fda932a added retry state
>    tracking on master, but MFILL_RETRY_STATE_VMA_FLAGS still does not
>    include VMA_WRITE_BIT -- the mprotect TOCTOU remains exploitable.
> 
> This is a deterministic local privilege escalation (no race timing
> needed for the killpriv bypass), affects every kernel since 4.11
> (8+ years), and works on any system with userfaultfd + tmpfs (the
> default on virtually all distributions).
> 
> I have a full working PoC that gets uid=0 from uid=1000 reliably.
> Happy to provide any additional information if needed.
> 
> Thanks,
> Vladimir
> 
> 
> ---------- Forwarded message ---------
> From: vova tokarev <vladimirelitokarev@gmail.com>
> Date: Tue, Jun 16, 2026 at 12:37 PM
> Subject: BadBunny: UFFDIO_COPY shmem killpriv bypass leading to local
> privilege escalation
> To: <security@kernel.org>
> 
> 
> Hi,
> 
> I found a local privilege escalation (BadBunny) in the userfaultfd +
> shmem subsystems that affects all Linux kernels from 4.11 to 7.1
> (every major distribution: Ubuntu, Debian, Fedora, RHEL, SUSE, Arch,
> Android, ChromeOS, and any system with CONFIG_USERFAULTFD=y and a
> tmpfs/shmem mount).
> 
> Two bugs are chained:
> 
> 1. TOCTOU in UFFDIO_COPY retry path (mm/userfaultfd.c):
>    mfill_retry_state_changed() does not re-validate VM_WRITE after
>    dropping and re-acquiring the mmap lock in mfill_copy_folio_retry().
>    A concurrent mprotect(PROT_READ) installs a writable PTE into a
>    now-read-only VMA.

This sounds like a bug, but not really exploitable.

> 
> 2. Missing killpriv in shmem UFFDIO_COPY (mm/shmem.c):
>    shmem_mfill_filemap_add() adds pages to the shmem page cache
>    without calling file_modified()/killpriv. This preserves SUID/SGID
>    bits when file content is replaced via UFFDIO_COPY, unlike normal
>    write() which strips them.
> 
> NOTE: The killpriv bypass (Bug 2) does not require
> unprivileged userfaultfd and works even with vm.unprivileged_userfaultfd=0,
> since UFFDIO_COPY on shmem is available to any process that can open
> a tmpfs file O_RDWR and call userfaultfd with UFFD_USER_MODE_ONLY.

Who made the suid file world-writable? Note that this is not a bug, page
fault paths don't clear the suid bit either.

> 
> An unprivileged user can replace the content of a SUID-root binary on
> tmpfs via UFFDIO_COPY while preserving its setuid permission, then
> execute it to obtain root.
> 
> The attack is deterministic (no timing dependency for the killpriv
> bypass), requires no heap spraying, and bypasses all modern kernel
> mitigations (KASLR, SMEP, SMAP, CFI, PAC, heap hardening).
> 
> Affected versions: Linux 4.11+ (since shmem UFFDIO_COPY support,
>     commit 4c27fe4c4c84 "userfaultfd: shmem: add shmem_mcopy_atomic_pte")

This sounds like a bug, but not really exploitable.
> Confirmed on: 7.1.0 (aarch64)
> Affected distros: All major distributions (Ubuntu, Debian, Fedora,
>     RHEL, SUSE, Arch, Android, ChromeOS) that have CONFIG_USERFAULTFD=y
>     and tmpfs mounted (virtually all Linux systems)
> 
> Attached files:
>   - bad_bunny.c                           Full LPE exploit (uid=1000 to
> uid=0) Build: gcc -static -O2 -pthread
>   - suidhelper.c                            Standalone SUID payload binary
> Build: gcc -static -O2
>   - uffdio_copy_lpe_report.md     Detailed writeup with root cause,
> reproduction steps, and suggested fix
>   - badbunny_demo.mp4             PoC demo clip
> 
> The PoC (bad_bunny.c) sets up a SUID target on tmpfs, drops to

Since the exploit isn't public, I assume you set up the tmpfs file as root
and world writable. This is not an LPE.


-- 
Pedro

