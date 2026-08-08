Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55492C55174
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 12:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 459756B00B7; Sat,  8 Aug 2026 08:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40A5B6B00B9; Sat,  8 Aug 2026 08:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8F66B00BA; Sat,  8 Aug 2026 08:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB12F6B00B7
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 08:17:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8109C0371
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 12:17:24 +0000 (UTC)
X-FDA: 85078002408.16.DF0E541
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5206420003
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 12:17:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=njcPzkbS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fLyELjvD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=szDHY6tG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2pLjEvFU;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786191442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qehbiy1CA3dVi+qrouYSN8RlLNI21IoWPgUv6jKFe1I=;
	b=amIFd1mDlrvYx0zml+W87WDp3kQHajt9SYttEgk4ZJD9ifAsSL+5c+yVpX1Z6waoUHlFlA
	Rxm34NDw81a/+0Jimz3OvMoLfZqN9fQUAgEb6tn7hnKT53DWJxgnsXvFhzYFjce+npNuQt
	TZgpH7yhiobZIQgjwMpcr5bdvC4eBcU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786191442;
	b=rs2fuQiM3Vvdnzui13hm/9+ol7/ekVW0fLxjgfpG6+v4UexdvUa0NfpAd1SukyHykj71PI
	93em8KuyJA2yGpsnZFTYs30iLcma4emZ82NWKvOi6XVnDu+/tStn4FYsr+peAYZ6ZNwLmg
	7eXiYdiK8KspBKyvlHMiluh8NX4SKdc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=njcPzkbS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fLyELjvD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=szDHY6tG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2pLjEvFU;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3D21780C9F;
	Sat,  8 Aug 2026 12:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786191436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qehbiy1CA3dVi+qrouYSN8RlLNI21IoWPgUv6jKFe1I=;
	b=njcPzkbS0nKgRDOBCsdQIenwyxVtbRlSK9B5DVZYgJWkzImM7S1LllkbDYM6gbbcKIdqgL
	Ehs3mfw+EOFTMqatGyTwpQqOrk+7qq5rRoIoFZ5AvjR/cYru0qaJ8NXCR4Fq1nmJJoqcqv
	4DNtOEOuNYfJn1muVxdYiktHr4jJRkQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786191436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qehbiy1CA3dVi+qrouYSN8RlLNI21IoWPgUv6jKFe1I=;
	b=fLyELjvD93ELzIVUiQ8WkqFGzUn+2y/TzzCYR1Bzr21ktKzXAnWJo05gyh/94PHWOegqyl
	gI1U5S8u+LffBMDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786191432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qehbiy1CA3dVi+qrouYSN8RlLNI21IoWPgUv6jKFe1I=;
	b=szDHY6tGcKNdlx+XCa3JpjfYzpM8qXs5G3UIEjU1r3D5XDWDftLOO10ZPw5aJ44Mbzpctu
	Gv6AXnvX8HLukjxneIRmwxAAs2R3rATCO2JFM7P52cuGwLoaHJaknh7OAOoizveW0IjMak
	XyzncoIYxVq9hdyJdiq0slSWfQizBY0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786191432;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qehbiy1CA3dVi+qrouYSN8RlLNI21IoWPgUv6jKFe1I=;
	b=2pLjEvFUvZWrNHgNf0whLMKpoP5aV2f5ClQ/BhXmRfnniLBG/nWHVH+CJswb1J1/I1hgex
	eek3pPHSvuGrxvDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 82BE7779B2;
	Sat,  8 Aug 2026 12:17:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id k29KHEced2rBTAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Sat, 08 Aug 2026 12:17:11 +0000
Date: Sat, 8 Aug 2026 13:17:09 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: vova tokarev <vladimirelitokarev@gmail.com>
Cc: akpm@linux-foundation.org, security@kernel.org, linux-mm@kvack.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org
Subject: Re: Fwd: BadBunny: UFFDIO_COPY shmem killpriv bypass leading to
 local privilege escalation
Message-ID: <ancYCBUT8aB0qHwz@pedro-suse.lan>
References: <CAGBKPgOm8q-8_rwyRPEmSj8JXdh_GaK1Q8vpJ=j-+yA0SgcNQw@mail.gmail.com>
 <CAGBKPgPPALX_5CQJAKUNjwi2fD28pBeS5pRuwQgePU93pOy8EA@mail.gmail.com>
 <anXnHMInq_JLYbWc@pedro-suse.lan>
 <CAGBKPgOfbMJruqcegJca6BBpEtpd91s5ASF_VU+gucWsjwp8WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGBKPgOfbMJruqcegJca6BBpEtpd91s5ASF_VU+gucWsjwp8WA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5206420003
X-Stat-Signature: 6gft5sm94rb1hw3aza3c3uesgd6rdhnk
X-HE-Tag: 1786191442-174573
X-HE-Meta: U2FsdGVkX1+kD4FKnj5zLm7lmmYiJK2bNWB8BHbWOUZH0OeZXrGBOquKDYjCYxQZ5RE/dP5fDbYanlvWbWEqCpZ9DZwM3e9tcw586PN60kSRja5aC/NE8vqMp9IrOPOpDcPL6/QtlPmBxds7RBTz1yAkoKBSkq01Uu5O2vUgHQrKWNUkI7NIHNJzQedaQPdIDSHams9zRRqaGJT0ERnH+k3DJwjrc2b/hshkdQxM37Nuzja8u8cgOdGIZAlgd1qP7SxnYvgANu1rNm/htaNDYdADeaD8w5vfqSQtqcaUqia+9v7jB3EOEEEwS7PzEvKK34RtePZ0zVKUEL8Ky1O61AGjyeQ3W1BSwKWlg9kbjwewI3X4h1OoE7bXKb/caftju2JY7bun2LRoejV2x2t/VBcWLdwvYLmbRtUKw4YkSA5dgablWKexmLcG1aEg1Y6bFfoqc0oJcsSVFkA9vUcJtMI6LISqcdeh7SttzMKm1kskXup9fODLIqqs+48UtUd/H10nl/CJE0bgantrWUMVt7WeQuFjfiLqcrmTkzPfNR/sBhEcY1MIu8PTmbqyTwlZfRl5sy2Lx3VerX/xSgEwTEANicDsFMPN+7IRyHIbyUG3nIkuQDVoEVVNvHTOinaePXlovYVrIevCFcx054OubVhONJYpp6L3VxoNAJJLDBeAirKcGioBoqQrxZt1K+QhlZqjpHsTD4cZe1270xpwi8HW1efN3L2jEG1H6LK/7NMd6QldUHnN6eobTMoeXXnAuTViEGhGTxGtPCsxTJ09MdsvdxXbYg43jPGzQx3dpNJqP+1woe+i+Fqz6sQcrXs6Ld7otkccaWyQeUlm01IsEQ04XIyEZfMfBCZrPIHqCnjqgWjGgXE99hQcGvfr6YHb0e9/DpsnwDao1dq3B0FJhUnQUOpJ/zMqhGWZtWdH4L1BFIV/ceQhHD3m5fhZCE77+wNgLzZlUoi1Sl4u0fK
 pr6qY4hB
 dg+8Fk5ewFOUSvxqzG6xrJNnfoZhmnx3GsXTJk8yYdCOfsblU698V5aKQzd1X7y5WPke0eErC3ZcDiXxQnOvWeqpixwkZHqkmbzHeCumFGj7IU5dmJoPOXhT24LEyCQUbnLz4jSydnyZbnmGBP21ItdmckO83fv7zwj1BrNDH5Nb4NzkroEIboBbDyJZvLBzRUtOb/XrnbzVbH6qYBGMCH3ewBo+DTNQjgJSDK04iDEYw8MgjfiK1qHlSGgJyEfXlcLgLQrMWNFC995NGzvlgXmZxXVBh9OLqY68hHqski3feZ+uSFGjN4EoFSq3jxdaOqcBLusWeHDsrhM60ztwE6YSvwPypCd9gzfs5Eg65o3vVVX+dDPIydDmLeGOOBECt7+Aj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I'm adding a bunch of fs people that might have opinions about this. Please
see the rest of the thread below.

On Sat, Aug 08, 2026 at 12:13:06PM +0300, vova tokarev wrote:
> Pedro,
> 
> Thanks for the review. Let me address both points.
> 
> On the page fault comparison:
> 
> UFFDIO_COPY is not comparable to a page fault. Page faults serve
> existing page cache content (read-like). UFFDIO_COPY adds new,

A page fault can also write to the page cache. On MAP_SHARED mappings.

> 
> user-controlled content to the shmem page cache (write-like).
> 
> The correct comparison is to write(), which calls file_modified()
> 
> -> __remove_privs() to strip SUID/SGID.
> 
> 
> This is exactly the reasoning used when fallocate() was fixed
> 
> across XFS (commit fbe7e5200365), ext4, and f2fs to call
> 
> file_modified(). The XFS commit message says:
> 
> "as various fallocate modes can change the file contents [...]
> 
> we should drop file privileges like suid just like we do for a
> 
> regular write()"

I can't speak for fallocate, or other system calls. As far as I'm aware,
this is a best-effort kind of thing. As I said, writing to a MAP_SHARED
mapping does not clear the setuid bit. It's a super trivial thing to do,
too. But it's not a problem because setuid executables are not world-writable.

I simply don't think this can feasibly be a security boundary, considering
how much it has been historically screwed up, and how the second-most basic
way to write to a file Just Bypasses It. I also don't know a single setuid
program that's packaged as 04777. Do you?

> 
> UFFDIO_COPY on shmem changes file contents.
> 
> It should drop file privileges like suid, just like write().
> 
> 
> On the PoC setup and exploitability:
> 
> The PoC uses mode 04777 for simplicity of demonstration,
> 
> but the underlying bug is a killpriv invariant violation:
> 
> every VFS write path calls file_modified() to strip SUID on
> 
> content modification, but shmem_mfill_filemap_add() does not.
> 
> The killpriv mechanism is defense-in-depth - if file permissions
> 
> alone were sufficient to protect SUID, the kernel wouldn't bother
> 
> stripping SUID on write(). But it does, because writable SUID files
> 
>  do occur in practice (group-writable SUID binaries, POSIX ACLs,
> 
>  container shared mounts, chained with a separate write-access bug).
> 
> 
> For precedent: CVE-2023-0386 (overlayfs copy-up preserving SUID
> 
>  across namespaces) is the same class of bug - a kernel code path
> 
>  that modifies or copies file content without stripping SUID -
> 
> and was scored CVSS 7.8 and added to CISA's KEV catalog.
> 
> The fallocate killpriv fixes were backported to all stable trees.
> 
> 
> Additionally, this path is available even with
> 
> vm.unprivileged_userfaultfd=0, since UFFD_USER_MODE_ONLY
> 
> bypasses the privilege check (userfaultfd_syscall_allowed()
> 
> returns true unconditionally for USER_MODE_ONLY).
> 
> The kernel considers this path safe for unprivileged use,
> 
> yet it skips killpriv.
> 
> 
> *On the fix:*
> 
> Regardless of how we classify severity, the fix is trivial and makes
> 
> UFFDIO_COPY consistent with every other write path -
> 
> add file_modified() to shmem_mfill_filemap_add().
> 
> I'm happy to submit a patch if you'd like.
> 
> 
> Best regards,
> 
> Vladimir
> 
> On Fri, Aug 7, 2026 at 5:14 PM Pedro Falcato <pfalcato@suse.de> wrote:
> 
> > On Fri, Aug 07, 2026 at 01:40:41PM +0300, vova tokarev wrote:
> > > Hi,
> > >
> > > It's been almost two months since I sent this report, and I haven't
> > > heard back. I'd really appreciate any feedback when you get a chance.
> > >
> > > I've rechecked both mainline master and stable 6.12.95 -- the
> > > vulnerability remains unfixed in both trees:
> > >
> > > 1. mm/shmem.c: shmem_mfill_atomic_pte() (6.12) /
> > shmem_mfill_filemap_add()
> > >    (7.x) still adds pages to the page cache without calling
> > file_modified()
> > >    or __remove_privs(). Writing to a SUID binary on tmpfs via UFFDIO_COPY
> > >    preserves the setuid bit.
> > >
> > > 2. mm/userfaultfd.c: I noticed commit 85668fda932a added retry state
> > >    tracking on master, but MFILL_RETRY_STATE_VMA_FLAGS still does not
> > >    include VMA_WRITE_BIT -- the mprotect TOCTOU remains exploitable.
> > >
> > > This is a deterministic local privilege escalation (no race timing
> > > needed for the killpriv bypass), affects every kernel since 4.11
> > > (8+ years), and works on any system with userfaultfd + tmpfs (the
> > > default on virtually all distributions).
> > >
> > > I have a full working PoC that gets uid=0 from uid=1000 reliably.
> > > Happy to provide any additional information if needed.
> > >
> > > Thanks,
> > > Vladimir
> > >
> > >
> > > ---------- Forwarded message ---------
> > > From: vova tokarev <vladimirelitokarev@gmail.com>
> > > Date: Tue, Jun 16, 2026 at 12:37 PM
> > > Subject: BadBunny: UFFDIO_COPY shmem killpriv bypass leading to local
> > > privilege escalation
> > > To: <security@kernel.org>
> > >
> > >
> > > Hi,
> > >
> > > I found a local privilege escalation (BadBunny) in the userfaultfd +
> > > shmem subsystems that affects all Linux kernels from 4.11 to 7.1
> > > (every major distribution: Ubuntu, Debian, Fedora, RHEL, SUSE, Arch,
> > > Android, ChromeOS, and any system with CONFIG_USERFAULTFD=y and a
> > > tmpfs/shmem mount).
> > >
> > > Two bugs are chained:
> > >
> > > 1. TOCTOU in UFFDIO_COPY retry path (mm/userfaultfd.c):
> > >    mfill_retry_state_changed() does not re-validate VM_WRITE after
> > >    dropping and re-acquiring the mmap lock in mfill_copy_folio_retry().
> > >    A concurrent mprotect(PROT_READ) installs a writable PTE into a
> > >    now-read-only VMA.
> >
> > This sounds like a bug, but not really exploitable.
> >
> > >
> > > 2. Missing killpriv in shmem UFFDIO_COPY (mm/shmem.c):
> > >    shmem_mfill_filemap_add() adds pages to the shmem page cache
> > >    without calling file_modified()/killpriv. This preserves SUID/SGID
> > >    bits when file content is replaced via UFFDIO_COPY, unlike normal
> > >    write() which strips them.
> > >
> > > NOTE: The killpriv bypass (Bug 2) does not require
> > > unprivileged userfaultfd and works even with
> > vm.unprivileged_userfaultfd=0,
> > > since UFFDIO_COPY on shmem is available to any process that can open
> > > a tmpfs file O_RDWR and call userfaultfd with UFFD_USER_MODE_ONLY.
> >
> > Who made the suid file world-writable? Note that this is not a bug, page
> > fault paths don't clear the suid bit either.
> >
> > >
> > > An unprivileged user can replace the content of a SUID-root binary on
> > > tmpfs via UFFDIO_COPY while preserving its setuid permission, then
> > > execute it to obtain root.
> > >
> > > The attack is deterministic (no timing dependency for the killpriv
> > > bypass), requires no heap spraying, and bypasses all modern kernel
> > > mitigations (KASLR, SMEP, SMAP, CFI, PAC, heap hardening).
> > >
> > > Affected versions: Linux 4.11+ (since shmem UFFDIO_COPY support,
> > >     commit 4c27fe4c4c84 "userfaultfd: shmem: add shmem_mcopy_atomic_pte")
> >
> > This sounds like a bug, but not really exploitable.
> > > Confirmed on: 7.1.0 (aarch64)
> > > Affected distros: All major distributions (Ubuntu, Debian, Fedora,
> > >     RHEL, SUSE, Arch, Android, ChromeOS) that have CONFIG_USERFAULTFD=y
> > >     and tmpfs mounted (virtually all Linux systems)
> > >
> > > Attached files:
> > >   - bad_bunny.c                           Full LPE exploit (uid=1000 to
> > > uid=0) Build: gcc -static -O2 -pthread
> > >   - suidhelper.c                            Standalone SUID payload
> > binary
> > > Build: gcc -static -O2
> > >   - uffdio_copy_lpe_report.md     Detailed writeup with root cause,
> > > reproduction steps, and suggested fix
> > >   - badbunny_demo.mp4             PoC demo clip
> > >
> > > The PoC (bad_bunny.c) sets up a SUID target on tmpfs, drops to
> >
> > Since the exploit isn't public, I assume you set up the tmpfs file as root
> > and world writable. This is not an LPE.
> >
> >
> > --
> > Pedro
> >

-- 
Pedro

