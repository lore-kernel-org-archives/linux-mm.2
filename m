Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 553F6C5AD2C
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 09:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48AF06B00AC; Sat,  8 Aug 2026 05:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4347B6B00AD; Sat,  8 Aug 2026 05:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322CF6B00AE; Sat,  8 Aug 2026 05:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 04E0E6B00AC
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 05:13:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 640B91202FE
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 09:13:20 +0000 (UTC)
X-FDA: 85077538560.26.D247701
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6917A180008
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 09:13:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TKF1Xr2p;
	spf=pass (imf24.hostedemail.com: domain of vladimirelitokarev@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=vladimirelitokarev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786180398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6a2Bj+iNH0MJrSrJE5IKJbLQ9q7oIFksXepV/tXP/SA=;
	b=csMRZx+2zb6Dk2xvaFUfnwCqrkP1yKuoLZr78dJq/39GwDQUZ/NPY2vV1xbSVHvU2uucxE
	CYRtaOilATtaDhZa+bpChl+lhNnYRszqvVBsAJeI/MvfusoZech1ENfdvA5Pj1quxoUjEZ
	LNuM12xNdPG+6ngkKul0mBNImP764pA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786180398;
	b=MPjqa7xWUcxcZ13Oz9UJ+C1gVffRuD2xMbcY6oPL05rP83t5zBcUyhRXuT0shBb9bCosgA
	M7azIwjrGD6Dc+Gmd7kBtIQtwx4ImAD3NkzRZBlA4utP22z8iGMKvEIHDbTyii3gjKBxB2
	bLCqPS8NCnp4Altt4vp5jLOv+lAODwU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TKF1Xr2p;
	spf=pass (imf24.hostedemail.com: domain of vladimirelitokarev@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=vladimirelitokarev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-667923d86a7so571425d50.0
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 02:13:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786180397; cv=none;
        d=google.com; s=arc-20260327;
        b=R7+aAduIa74Oh2Mrp0z3ZK7Tw2xqsvleVWr29NyvGHKYAXnSwwytZqZBbUIL4kA6un
         dKVgXQPdCs5keaJ5smw+lZQsgVAHcc2SAGXVfk41XHBCcSfwtWZJt/sJ3KAlEkl/kDNj
         dczCKgJL36zoQ7a3CZGqfb8Mwn79WfTBiHoDGO1FK3gHf8MaBYcus5vmn3LMMCDuyy3N
         xUbcmPBbOghQcCUorMqbw3k/Bt4rQhC1BB4YwMxnAVRhtKhKJQZclx1TRSx+lfDF4Aic
         xNRyg70kafYNuQ8uS1jmd7umpei8HOqtEpaJUCnMDKKbQKT2TaDkcYA58L+83fbVN7FE
         339Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6a2Bj+iNH0MJrSrJE5IKJbLQ9q7oIFksXepV/tXP/SA=;
        fh=Q2Nqn+ZkdHNYsWlmOmivSLE7Luy3pgYjyQnUqdDmvyU=;
        b=g0kXetPTirKs4h/bg5Wc0tBCty+py+gmGe6Wj9N1EHvwHhZzdTxUIQ9HjqLgoePgJn
         0BA2qPaulqeoN31ISpQmX725Fo1IxD2rDQ/Zpcc8+4z3Ke3bypMuiGnXjhYP4A88GmNy
         AvoLTo4DMRlB5g9mAcbp1w6/RWUnvTbzKEZHIwjT5qQsJebxlNIVWXuBm7aXGb5iiwMX
         dP3DvxT2pztx0q8p/staQn7dQoZfVH/1LEh1ZYJr8Zm17RCVceBKskRuoq7xWjlCnXq7
         fX806K5FUq8ku8nPGaizz7sQon+BfgFGOlk7f/N63Su+t7yJUxKoJIDap9EQuY6U9Ht3
         Jawg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786180397; x=1786785197; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6a2Bj+iNH0MJrSrJE5IKJbLQ9q7oIFksXepV/tXP/SA=;
        b=TKF1Xr2pyS9R9yRo+u30NDGOYwCbhDvsYiVZ4tmGNEhTG9ChpOr1oTT29n51oL7dtn
         izz+TiAwJQM2l6/mtcFa01yu0BXFHfZQ/iNgrpFfW5eIoKbsue3tTb93gK7tfUnMy6Nr
         2pDk7rsQFbp3MNHBZkPKktNXkcgRqoeDyiKwyzd8JDJG/AvJt6tToKyVS7S2lrguoirU
         08uMX4MiMNe9AFik3gjLFKcH/i5qsdH9/k1UMBLKFNVMb86+O9pEzaWXDcXXvQyXMCvJ
         eYxCwKr9mj89d9g/rSHzz/ufY0Ma1ced/8RXkhd9pFtYwHZlms/N/0IcWYwqWN0wF4Mq
         417w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786180397; x=1786785197;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6a2Bj+iNH0MJrSrJE5IKJbLQ9q7oIFksXepV/tXP/SA=;
        b=WLBIOLKD6dJ8ysrDBpLJNa1t7vafPqZdKxddIh3GFDmbC3s5QgZUdgPESOqd0/dKHh
         tesej208+Cd6Y/wHB+5hOY5DU3iaI8KgE0KAlGQO9eFSqhkwHXR57wgYeG/CsIXZLAC7
         0EJjy2tnunBVxp5AlUjQhPqFgBWGC8F9GmSZCzfc2mdVk5YInuclChwdTjzRskKbY6F+
         cHm21f0TbyE98LjKPY3xc76UIh9JM0RXPBqxPUvUaGbl6UFtS2zH1wtoT1wHojkYV60I
         TtdL+eM+UWVEtAQ6Y+DsYIYKp/ZJGqejGyWXLDYeZdAOypNtSUi2n21hNNvT65UqN+zb
         XuAA==
X-Forwarded-Encrypted: i=1; AHgh+RrBTsSfDttFcWZvP2xuxMS5MgzvPdU3OcaXV0H/GQ9zND7BHDpebaEnyrcohhh9vOOhIyf2KJfSvw==@kvack.org
X-Gm-Message-State: AOJu0Yx0UbQIsVUTqj6+UXG1+PzuhBEMsmiO1IsWY5XD5OISAkUoJvOH
	RU7xJMqez6xLofUlCAEa1Ev16SIm0jIMxSxtOncTLp93ub51qXDGqCJteYFGxktCqKjYXwwc9E5
	KqE2NnvHULzw2PgLZKHieQGNKrTr1afKUPOf8Ozc=
X-Gm-Gg: AR+sD11GTuzvzX+mzFgCA9BxCe+ZYBAwM0Plq5ouNNodc+95sEjvQ8fRyC8djwdb1VT
	Jvs1pIrE3xrTzl1M0xay3fQ/w2LnPWKTvIGhxDRz0NcJdU1fdqAIYwwqitOe//ywKftazCBq8zE
	yZqMCZlIb4wN96yQssQX6RDf7QOCgE9n1RICm24p0+DYI6NCS0z25+2ToU815QFvj49RyqChfHU
	uG35cGj+P2HqIHCaWFacnJIkV6reXcRcDPSMCiynSxINba49yp3vENWbM3BtmsUsRm3nR/LI8oX
	MUETE+wZoA5Leq2Dg6so865ZfZ8vy0byz/gkre7Y0beq7cPaIBBte1N8uUa2YZtk4/2aLeYmASx
	jaceCvDez2Y6xzxH6E9U=
X-Received: by 2002:a53:9004:0:b0:668:9a36:b229 with SMTP id
 956f58d0204a3-66ada9092b6mr1944828d50.21.1786180397440; Sat, 08 Aug 2026
 02:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAGBKPgOm8q-8_rwyRPEmSj8JXdh_GaK1Q8vpJ=j-+yA0SgcNQw@mail.gmail.com>
 <CAGBKPgPPALX_5CQJAKUNjwi2fD28pBeS5pRuwQgePU93pOy8EA@mail.gmail.com> <anXnHMInq_JLYbWc@pedro-suse.lan>
In-Reply-To: <anXnHMInq_JLYbWc@pedro-suse.lan>
From: vova tokarev <vladimirelitokarev@gmail.com>
Date: Sat, 8 Aug 2026 12:13:06 +0300
X-Gm-Features: AUfX_mwIrsuqXHXsbuNzkMJ8D27kVHssZA7LC66ntX4GTsvHIXm9umLh_d7inL8
Message-ID: <CAGBKPgOfbMJruqcegJca6BBpEtpd91s5ASF_VU+gucWsjwp8WA@mail.gmail.com>
Subject: Re: Fwd: BadBunny: UFFDIO_COPY shmem killpriv bypass leading to local
 privilege escalation
To: Pedro Falcato <pfalcato@suse.de>
Cc: akpm@linux-foundation.org, security@kernel.org, linux-mm@kvack.org
Content-Type: multipart/alternative; boundary="00000000000018225606588588eb"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6917A180008
X-Stat-Signature: 9ieyxeqyjcbcjuzw94c618cmnkzreiiu
X-HE-Tag: 1786180398-750958
X-HE-Meta: U2FsdGVkX1/zdOyBYDLpBquCDZql7vlvIakOGzbOgsrd35D7AwoS1kagd/6ENABz3/qCJteuvOAN7bU0Us4k2y308cKIycGQ4k6djCM6qijSkDtzbDI1pYkmwxoH8LYHfCv9lBI4L+A08j1QEjYDhbCMaA/pvr0j8MY721UgjRl8oSMqaiNfGhKb4p4MzK4oAzCzLvh3DhBQ+D3VpuN2eWZXyUzLrKR8j4ABa/EXM14ED7DpzPpYWz4fjh6qiSuGSvQwSI+jA0/o638wMpBUbuYHs8Dy1Ywv24rvmiF682DbwwOoUajFoZr98WLLICYwrsxZBljvPcg4TK4K7u2tHWlJ6TJcDOahx8rVArK5+vhZaPP4YJQlPf9F2W1LqbRHYzT+0gmRbk7qQnE1lj8oH6frCjGzoGWE/ztZXzwB4VcwsVUfSYHlU5HWtVv39huEIncuP4u7D1TUsoM3JXaovN8ibJvjxnx9T0gLgRlbLGeG1PGzrKH8qAlmvXTZdXj8obcA13WmHnni2jeXLTf1bzsHgR4Gu/waLJVcYD0Thk0h3rGybOV9CtSpbSimMUiYsdthRGuV6pAs343M8QaJIxqNFR3eNexTSqUhlk2EMS5p8SWbgYdk1THbb0HmrbMHmMQp9zV97yPAJ3xiqs5MojnNmsbl4/5jqyHyPdl15OOOYjZj6PZriM+/1G2uI6/FUGWIsDq1ZJ2uQJGIwDaMzIVyg3vzHaSc/jVNy4TsIKiXa7ftJnWCEYuCvZVg/3u2hFdtUyfHLElfu0T45Ac6T4r0QL5hargzTbgbGnnSlDB+7XFyxnUCelDVnrZhl+2L9UghiOhugmWZogslTpWlDgGvK3kZAB0fG0mxFHcATERvePQZW7AaVCMJhuU9COeHpiawjdlOXFezkJv6sdcBlIzWhIWm6CVyE3v/sWfq6YOpVU/QuXgmNFrULJDsTh7UCl4l9hACX6QzoZYyGTP
 N8NOs3+Z
 PtyICMXNKQXD91RCM16SyB3v7TnhPK+nOCDjv0qMVm2nL1QCMK3dejlzGECBkt+uwlS7IkSLohxuARqzFWQCxLZ9hNQIJfz+5fY1DVxtxBcDlrVpLh4+45VIClNctVh2Bdvg731vlCzRTFlxA9MfKN9i/z0I3wz5y0O5V7Alco8P99YFZ3fWHKGsUjzskXkO+FJ7+U0r4v5AHQAcoC3QyV20iO9l7BruAbghm3oZuAf/TRZeQ5yrrIdOf8kd1Eal7blRWhKWv4j2MB1OQzPWWQ+xEBEAKxv501UbbIVFzJ5Ci9/r8TAcfqDHbo1q84WZa0zs66tBlqBqc3cpZobd3Y2MHtOuA57kI8SuGvP8lpHMVv4R9j+4j4v4ppfDf8WYBOU6gJ2BlSX0iqbJJiU1MLafbnF7Ejk75xhLCBJ9KpsTaj1FsiS7+tyH3GTr0h0rmeMINBm0iM+SfynTYExbZ5sf3HqQmeGsbV6NX89Ayv9GBLm14ALz9jl0aZse1y6DbBK4zST2/Bv/RC1HwAFINnl+peIuSCiVLeXlJCqCOxnWsdvDsH3pKPJJ8YNTc0MOtEiqGDIO7Rnj7m+AeJxHadv1xFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000018225606588588eb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Pedro,

Thanks for the review. Let me address both points.

On the page fault comparison:

UFFDIO_COPY is not comparable to a page fault. Page faults serve
existing page cache content (read-like). UFFDIO_COPY adds new,

user-controlled content to the shmem page cache (write-like).

The correct comparison is to write(), which calls file_modified()

-> __remove_privs() to strip SUID/SGID.


This is exactly the reasoning used when fallocate() was fixed

across XFS (commit fbe7e5200365), ext4, and f2fs to call

file_modified(). The XFS commit message says:

"as various fallocate modes can change the file contents [...]

we should drop file privileges like suid just like we do for a

regular write()"

UFFDIO_COPY on shmem changes file contents.

It should drop file privileges like suid, just like write().


On the PoC setup and exploitability:

The PoC uses mode 04777 for simplicity of demonstration,

but the underlying bug is a killpriv invariant violation:

every VFS write path calls file_modified() to strip SUID on

content modification, but shmem_mfill_filemap_add() does not.

The killpriv mechanism is defense-in-depth - if file permissions

alone were sufficient to protect SUID, the kernel wouldn't bother

stripping SUID on write(). But it does, because writable SUID files

 do occur in practice (group-writable SUID binaries, POSIX ACLs,

 container shared mounts, chained with a separate write-access bug).


For precedent: CVE-2023-0386 (overlayfs copy-up preserving SUID

 across namespaces) is the same class of bug - a kernel code path

 that modifies or copies file content without stripping SUID -

and was scored CVSS 7.8 and added to CISA's KEV catalog.

The fallocate killpriv fixes were backported to all stable trees.


Additionally, this path is available even with

vm.unprivileged_userfaultfd=3D0, since UFFD_USER_MODE_ONLY

bypasses the privilege check (userfaultfd_syscall_allowed()

returns true unconditionally for USER_MODE_ONLY).

The kernel considers this path safe for unprivileged use,

yet it skips killpriv.


*On the fix:*

Regardless of how we classify severity, the fix is trivial and makes

UFFDIO_COPY consistent with every other write path -

add file_modified() to shmem_mfill_filemap_add().

I'm happy to submit a patch if you'd like.


Best regards,

Vladimir

On Fri, Aug 7, 2026 at 5:14=E2=80=AFPM Pedro Falcato <pfalcato@suse.de> wro=
te:

> On Fri, Aug 07, 2026 at 01:40:41PM +0300, vova tokarev wrote:
> > Hi,
> >
> > It's been almost two months since I sent this report, and I haven't
> > heard back. I'd really appreciate any feedback when you get a chance.
> >
> > I've rechecked both mainline master and stable 6.12.95 -- the
> > vulnerability remains unfixed in both trees:
> >
> > 1. mm/shmem.c: shmem_mfill_atomic_pte() (6.12) /
> shmem_mfill_filemap_add()
> >    (7.x) still adds pages to the page cache without calling
> file_modified()
> >    or __remove_privs(). Writing to a SUID binary on tmpfs via UFFDIO_CO=
PY
> >    preserves the setuid bit.
> >
> > 2. mm/userfaultfd.c: I noticed commit 85668fda932a added retry state
> >    tracking on master, but MFILL_RETRY_STATE_VMA_FLAGS still does not
> >    include VMA_WRITE_BIT -- the mprotect TOCTOU remains exploitable.
> >
> > This is a deterministic local privilege escalation (no race timing
> > needed for the killpriv bypass), affects every kernel since 4.11
> > (8+ years), and works on any system with userfaultfd + tmpfs (the
> > default on virtually all distributions).
> >
> > I have a full working PoC that gets uid=3D0 from uid=3D1000 reliably.
> > Happy to provide any additional information if needed.
> >
> > Thanks,
> > Vladimir
> >
> >
> > ---------- Forwarded message ---------
> > From: vova tokarev <vladimirelitokarev@gmail.com>
> > Date: Tue, Jun 16, 2026 at 12:37=E2=80=AFPM
> > Subject: BadBunny: UFFDIO_COPY shmem killpriv bypass leading to local
> > privilege escalation
> > To: <security@kernel.org>
> >
> >
> > Hi,
> >
> > I found a local privilege escalation (BadBunny) in the userfaultfd +
> > shmem subsystems that affects all Linux kernels from 4.11 to 7.1
> > (every major distribution: Ubuntu, Debian, Fedora, RHEL, SUSE, Arch,
> > Android, ChromeOS, and any system with CONFIG_USERFAULTFD=3Dy and a
> > tmpfs/shmem mount).
> >
> > Two bugs are chained:
> >
> > 1. TOCTOU in UFFDIO_COPY retry path (mm/userfaultfd.c):
> >    mfill_retry_state_changed() does not re-validate VM_WRITE after
> >    dropping and re-acquiring the mmap lock in mfill_copy_folio_retry().
> >    A concurrent mprotect(PROT_READ) installs a writable PTE into a
> >    now-read-only VMA.
>
> This sounds like a bug, but not really exploitable.
>
> >
> > 2. Missing killpriv in shmem UFFDIO_COPY (mm/shmem.c):
> >    shmem_mfill_filemap_add() adds pages to the shmem page cache
> >    without calling file_modified()/killpriv. This preserves SUID/SGID
> >    bits when file content is replaced via UFFDIO_COPY, unlike normal
> >    write() which strips them.
> >
> > NOTE: The killpriv bypass (Bug 2) does not require
> > unprivileged userfaultfd and works even with
> vm.unprivileged_userfaultfd=3D0,
> > since UFFDIO_COPY on shmem is available to any process that can open
> > a tmpfs file O_RDWR and call userfaultfd with UFFD_USER_MODE_ONLY.
>
> Who made the suid file world-writable? Note that this is not a bug, page
> fault paths don't clear the suid bit either.
>
> >
> > An unprivileged user can replace the content of a SUID-root binary on
> > tmpfs via UFFDIO_COPY while preserving its setuid permission, then
> > execute it to obtain root.
> >
> > The attack is deterministic (no timing dependency for the killpriv
> > bypass), requires no heap spraying, and bypasses all modern kernel
> > mitigations (KASLR, SMEP, SMAP, CFI, PAC, heap hardening).
> >
> > Affected versions: Linux 4.11+ (since shmem UFFDIO_COPY support,
> >     commit 4c27fe4c4c84 "userfaultfd: shmem: add shmem_mcopy_atomic_pte=
")
>
> This sounds like a bug, but not really exploitable.
> > Confirmed on: 7.1.0 (aarch64)
> > Affected distros: All major distributions (Ubuntu, Debian, Fedora,
> >     RHEL, SUSE, Arch, Android, ChromeOS) that have CONFIG_USERFAULTFD=
=3Dy
> >     and tmpfs mounted (virtually all Linux systems)
> >
> > Attached files:
> >   - bad_bunny.c                           Full LPE exploit (uid=3D1000 =
to
> > uid=3D0) Build: gcc -static -O2 -pthread
> >   - suidhelper.c                            Standalone SUID payload
> binary
> > Build: gcc -static -O2
> >   - uffdio_copy_lpe_report.md     Detailed writeup with root cause,
> > reproduction steps, and suggested fix
> >   - badbunny_demo.mp4             PoC demo clip
> >
> > The PoC (bad_bunny.c) sets up a SUID target on tmpfs, drops to
>
> Since the exploit isn't public, I assume you set up the tmpfs file as roo=
t
> and world writable. This is not an LPE.
>
>
> --
> Pedro
>

--00000000000018225606588588eb
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">





<p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;">Pedro,</p>
<p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;">Thanks for the review. Let me address both points.<br><br=
>
</p>
<p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;">On the page fault comparison:<b></b></p>
<p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;">UFFDIO_COPY is not comparable to a page fault. Page fault=
s serve<br>existing page cache content (read-like). UFFDIO_COPY adds new,=
=C2=A0</p><p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-=
variant:normal;font-size-adjust:none;font-kerning:auto;font-feature-setting=
s:normal;font-stretch:normal;font-size:13px;line-height:normal;font-family:=
&quot;Helvetica Neue&quot;">user-controlled content to the shmem page cache=
 (write-like).=C2=A0</p><p class=3D"gmail-p1" style=3D"margin:0px;font-styl=
e:normal;font-variant:normal;font-size-adjust:none;font-kerning:auto;font-f=
eature-settings:normal;font-stretch:normal;font-size:13px;line-height:norma=
l;font-family:&quot;Helvetica Neue&quot;">The correct comparison is to writ=
e(), which calls file_modified()=C2=A0</p><p class=3D"gmail-p1" style=3D"ma=
rgin:0px;font-style:normal;font-variant:normal;font-size-adjust:none;font-k=
erning:auto;font-feature-settings:normal;font-stretch:normal;font-size:13px=
;line-height:normal;font-family:&quot;Helvetica Neue&quot;">-&gt; __remove_=
privs() to strip SUID/SGID.</p>
<p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;"><br>
This is exactly the reasoning used when fallocate() was fixed=C2=A0</p><p c=
lass=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:normal=
;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;font-=
stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helvetic=
a Neue&quot;">across XFS (commit fbe7e5200365), ext4, and f2fs to call</p><=
p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:nor=
mal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;fo=
nt-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helve=
tica Neue&quot;">file_modified(). The XFS commit message says:</p>
<p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;">&quot;as various fallocate modes can change the file cont=
ents [...]=C2=A0</p><p class=3D"gmail-p1" style=3D"margin:0px;font-style:no=
rmal;font-variant:normal;font-size-adjust:none;font-kerning:auto;font-featu=
re-settings:normal;font-stretch:normal;font-size:13px;line-height:normal;fo=
nt-family:&quot;Helvetica Neue&quot;">we should drop file privileges like s=
uid just like we do for a=C2=A0</p><p class=3D"gmail-p1" style=3D"margin:0p=
x;font-style:normal;font-variant:normal;font-size-adjust:none;font-kerning:=
auto;font-feature-settings:normal;font-stretch:normal;font-size:13px;line-h=
eight:normal;font-family:&quot;Helvetica Neue&quot;">regular write()&quot;<=
/p>
<p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;">UFFDIO_COPY on shmem changes file contents.=C2=A0</p><p c=
lass=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:normal=
;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;font-=
stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helvetic=
a Neue&quot;">It should drop file privileges like suid, just like write().<=
/p>
<p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;"><br>
On the PoC setup and exploitability:<b></b></p>
<p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;">The PoC uses mode 04777 for simplicity of demonstration,=
=C2=A0</p><p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-=
variant:normal;font-size-adjust:none;font-kerning:auto;font-feature-setting=
s:normal;font-stretch:normal;font-size:13px;line-height:normal;font-family:=
&quot;Helvetica Neue&quot;">but the underlying bug is a killpriv invariant =
violation:=C2=A0</p><p class=3D"gmail-p1" style=3D"margin:0px;font-style:no=
rmal;font-variant:normal;font-size-adjust:none;font-kerning:auto;font-featu=
re-settings:normal;font-stretch:normal;font-size:13px;line-height:normal;fo=
nt-family:&quot;Helvetica Neue&quot;">every VFS write path calls file_modif=
ied() to strip SUID on</p><p class=3D"gmail-p1" style=3D"margin:0px;font-st=
yle:normal;font-variant:normal;font-size-adjust:none;font-kerning:auto;font=
-feature-settings:normal;font-stretch:normal;font-size:13px;line-height:nor=
mal;font-family:&quot;Helvetica Neue&quot;">content modification, but shmem=
_mfill_filemap_add() does not.=C2=A0</p><p class=3D"gmail-p1" style=3D"marg=
in:0px;font-style:normal;font-variant:normal;font-size-adjust:none;font-ker=
ning:auto;font-feature-settings:normal;font-stretch:normal;font-size:13px;l=
ine-height:normal;font-family:&quot;Helvetica Neue&quot;">The killpriv mech=
anism is defense-in-depth - if file permissions=C2=A0</p><p class=3D"gmail-=
p1" style=3D"margin:0px;font-style:normal;font-variant:normal;font-size-adj=
ust:none;font-kerning:auto;font-feature-settings:normal;font-stretch:normal=
;font-size:13px;line-height:normal;font-family:&quot;Helvetica Neue&quot;">=
alone were sufficient to protect SUID, the kernel wouldn&#39;t bother</p><p=
 class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:norm=
al;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;fon=
t-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helvet=
ica Neue&quot;">stripping SUID on write(). But it does, because writable SU=
ID files</p><p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;fon=
t-variant:normal;font-size-adjust:none;font-kerning:auto;font-feature-setti=
ngs:normal;font-stretch:normal;font-size:13px;line-height:normal;font-famil=
y:&quot;Helvetica Neue&quot;">=C2=A0do occur in practice (group-writable SU=
ID binaries, POSIX ACLs,</p><p class=3D"gmail-p1" style=3D"margin:0px;font-=
style:normal;font-variant:normal;font-size-adjust:none;font-kerning:auto;fo=
nt-feature-settings:normal;font-stretch:normal;font-size:13px;line-height:n=
ormal;font-family:&quot;Helvetica Neue&quot;">=C2=A0container shared mounts=
, chained with a separate write-access bug).</p>
<p class=3D"gmail-p2" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;;min-height:15px"><br></p>
<p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;">For precedent: CVE-2023-0386 (overlayfs copy-up preservin=
g SUID</p><p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-=
variant:normal;font-size-adjust:none;font-kerning:auto;font-feature-setting=
s:normal;font-stretch:normal;font-size:13px;line-height:normal;font-family:=
&quot;Helvetica Neue&quot;">=C2=A0across namespaces) is the same class of b=
ug - a kernel code path</p><p class=3D"gmail-p1" style=3D"margin:0px;font-s=
tyle:normal;font-variant:normal;font-size-adjust:none;font-kerning:auto;fon=
t-feature-settings:normal;font-stretch:normal;font-size:13px;line-height:no=
rmal;font-family:&quot;Helvetica Neue&quot;">=C2=A0that modifies or copies =
file content without stripping SUID -=C2=A0</p><p class=3D"gmail-p1" style=
=3D"margin:0px;font-style:normal;font-variant:normal;font-size-adjust:none;=
font-kerning:auto;font-feature-settings:normal;font-stretch:normal;font-siz=
e:13px;line-height:normal;font-family:&quot;Helvetica Neue&quot;">and was s=
cored CVSS 7.8 and added to CISA&#39;s KEV catalog.=C2=A0</p><p class=3D"gm=
ail-p1" style=3D"margin:0px;font-style:normal;font-variant:normal;font-size=
-adjust:none;font-kerning:auto;font-feature-settings:normal;font-stretch:no=
rmal;font-size:13px;line-height:normal;font-family:&quot;Helvetica Neue&quo=
t;">The fallocate killpriv fixes were backported to all stable trees.</p>
<p class=3D"gmail-p2" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;;min-height:15px"><br></p>
<p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;">Additionally, this path is available even with=C2=A0</p><=
p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:nor=
mal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;fo=
nt-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helve=
tica Neue&quot;">vm.unprivileged_userfaultfd=3D0, since UFFD_USER_MODE_ONLY=
=C2=A0</p><p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-=
variant:normal;font-size-adjust:none;font-kerning:auto;font-feature-setting=
s:normal;font-stretch:normal;font-size:13px;line-height:normal;font-family:=
&quot;Helvetica Neue&quot;">bypasses the privilege check (userfaultfd_sysca=
ll_allowed()=C2=A0</p><p class=3D"gmail-p1" style=3D"margin:0px;font-style:=
normal;font-variant:normal;font-size-adjust:none;font-kerning:auto;font-fea=
ture-settings:normal;font-stretch:normal;font-size:13px;line-height:normal;=
font-family:&quot;Helvetica Neue&quot;">returns true unconditionally for US=
ER_MODE_ONLY).=C2=A0</p><p class=3D"gmail-p1" style=3D"margin:0px;font-styl=
e:normal;font-variant:normal;font-size-adjust:none;font-kerning:auto;font-f=
eature-settings:normal;font-stretch:normal;font-size:13px;line-height:norma=
l;font-family:&quot;Helvetica Neue&quot;">The kernel considers this path sa=
fe for unprivileged use,=C2=A0</p><p class=3D"gmail-p1" style=3D"margin:0px=
;font-style:normal;font-variant:normal;font-size-adjust:none;font-kerning:a=
uto;font-feature-settings:normal;font-stretch:normal;font-size:13px;line-he=
ight:normal;font-family:&quot;Helvetica Neue&quot;">yet it skips killpriv.<=
/p>
<p class=3D"gmail-p3" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;;min-height:16px"><b></b><br></p>
<p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;"><b>On the fix:</b><b></b></p>
<p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;">Regardless of how we classify severity, the fix is trivia=
l and makes=C2=A0</p><p class=3D"gmail-p1" style=3D"margin:0px;font-style:n=
ormal;font-variant:normal;font-size-adjust:none;font-kerning:auto;font-feat=
ure-settings:normal;font-stretch:normal;font-size:13px;line-height:normal;f=
ont-family:&quot;Helvetica Neue&quot;">UFFDIO_COPY consistent with every ot=
her write path -=C2=A0</p><p class=3D"gmail-p1" style=3D"margin:0px;font-st=
yle:normal;font-variant:normal;font-size-adjust:none;font-kerning:auto;font=
-feature-settings:normal;font-stretch:normal;font-size:13px;line-height:nor=
mal;font-family:&quot;Helvetica Neue&quot;">add file_modified() to shmem_mf=
ill_filemap_add().=C2=A0</p><p class=3D"gmail-p1" style=3D"margin:0px;font-=
style:normal;font-variant:normal;font-size-adjust:none;font-kerning:auto;fo=
nt-feature-settings:normal;font-stretch:normal;font-size:13px;line-height:n=
ormal;font-family:&quot;Helvetica Neue&quot;">I&#39;m happy to submit a pat=
ch if you&#39;d like.</p>
<p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;"><br>
Best regards,</p>
<p class=3D"gmail-p1" style=3D"margin:0px;font-style:normal;font-variant:no=
rmal;font-size-adjust:none;font-kerning:auto;font-feature-settings:normal;f=
ont-stretch:normal;font-size:13px;line-height:normal;font-family:&quot;Helv=
etica Neue&quot;">Vladimir</p></div><br><div class=3D"gmail_quote gmail_quo=
te_container"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, Aug 7, 2026 at =
5:14=E2=80=AFPM Pedro Falcato &lt;<a href=3D"mailto:pfalcato@suse.de">pfalc=
ato@suse.de</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">On Fri, Aug 07, 2026 at 01:40:41PM +0300, vova tokarev wrote:<br=
>
&gt; Hi,<br>
&gt; <br>
&gt; It&#39;s been almost two months since I sent this report, and I haven&=
#39;t<br>
&gt; heard back. I&#39;d really appreciate any feedback when you get a chan=
ce.<br>
&gt; <br>
&gt; I&#39;ve rechecked both mainline master and stable 6.12.95 -- the<br>
&gt; vulnerability remains unfixed in both trees:<br>
&gt; <br>
&gt; 1. mm/shmem.c: shmem_mfill_atomic_pte() (6.12) / shmem_mfill_filemap_a=
dd()<br>
&gt;=C2=A0 =C2=A0 (7.x) still adds pages to the page cache without calling =
file_modified()<br>
&gt;=C2=A0 =C2=A0 or __remove_privs(). Writing to a SUID binary on tmpfs vi=
a UFFDIO_COPY<br>
&gt;=C2=A0 =C2=A0 preserves the setuid bit.<br>
&gt; <br>
&gt; 2. mm/userfaultfd.c: I noticed commit 85668fda932a added retry state<b=
r>
&gt;=C2=A0 =C2=A0 tracking on master, but MFILL_RETRY_STATE_VMA_FLAGS still=
 does not<br>
&gt;=C2=A0 =C2=A0 include VMA_WRITE_BIT -- the mprotect TOCTOU remains expl=
oitable.<br>
&gt; <br>
&gt; This is a deterministic local privilege escalation (no race timing<br>
&gt; needed for the killpriv bypass), affects every kernel since 4.11<br>
&gt; (8+ years), and works on any system with userfaultfd + tmpfs (the<br>
&gt; default on virtually all distributions).<br>
&gt; <br>
&gt; I have a full working PoC that gets uid=3D0 from uid=3D1000 reliably.<=
br>
&gt; Happy to provide any additional information if needed.<br>
&gt; <br>
&gt; Thanks,<br>
&gt; Vladimir<br>
&gt; <br>
&gt; <br>
&gt; ---------- Forwarded message ---------<br>
&gt; From: vova tokarev &lt;<a href=3D"mailto:vladimirelitokarev@gmail.com"=
 target=3D"_blank">vladimirelitokarev@gmail.com</a>&gt;<br>
&gt; Date: Tue, Jun 16, 2026 at 12:37=E2=80=AFPM<br>
&gt; Subject: BadBunny: UFFDIO_COPY shmem killpriv bypass leading to local<=
br>
&gt; privilege escalation<br>
&gt; To: &lt;<a href=3D"mailto:security@kernel.org" target=3D"_blank">secur=
ity@kernel.org</a>&gt;<br>
&gt; <br>
&gt; <br>
&gt; Hi,<br>
&gt; <br>
&gt; I found a local privilege escalation (BadBunny) in the userfaultfd +<b=
r>
&gt; shmem subsystems that affects all Linux kernels from 4.11 to 7.1<br>
&gt; (every major distribution: Ubuntu, Debian, Fedora, RHEL, SUSE, Arch,<b=
r>
&gt; Android, ChromeOS, and any system with CONFIG_USERFAULTFD=3Dy and a<br=
>
&gt; tmpfs/shmem mount).<br>
&gt; <br>
&gt; Two bugs are chained:<br>
&gt; <br>
&gt; 1. TOCTOU in UFFDIO_COPY retry path (mm/userfaultfd.c):<br>
&gt;=C2=A0 =C2=A0 mfill_retry_state_changed() does not re-validate VM_WRITE=
 after<br>
&gt;=C2=A0 =C2=A0 dropping and re-acquiring the mmap lock in mfill_copy_fol=
io_retry().<br>
&gt;=C2=A0 =C2=A0 A concurrent mprotect(PROT_READ) installs a writable PTE =
into a<br>
&gt;=C2=A0 =C2=A0 now-read-only VMA.<br>
<br>
This sounds like a bug, but not really exploitable.<br>
<br>
&gt; <br>
&gt; 2. Missing killpriv in shmem UFFDIO_COPY (mm/shmem.c):<br>
&gt;=C2=A0 =C2=A0 shmem_mfill_filemap_add() adds pages to the shmem page ca=
che<br>
&gt;=C2=A0 =C2=A0 without calling file_modified()/killpriv. This preserves =
SUID/SGID<br>
&gt;=C2=A0 =C2=A0 bits when file content is replaced via UFFDIO_COPY, unlik=
e normal<br>
&gt;=C2=A0 =C2=A0 write() which strips them.<br>
&gt; <br>
&gt; NOTE: The killpriv bypass (Bug 2) does not require<br>
&gt; unprivileged userfaultfd and works even with vm.unprivileged_userfault=
fd=3D0,<br>
&gt; since UFFDIO_COPY on shmem is available to any process that can open<b=
r>
&gt; a tmpfs file O_RDWR and call userfaultfd with UFFD_USER_MODE_ONLY.<br>
<br>
Who made the suid file world-writable? Note that this is not a bug, page<br=
>
fault paths don&#39;t clear the suid bit either.<br>
<br>
&gt; <br>
&gt; An unprivileged user can replace the content of a SUID-root binary on<=
br>
&gt; tmpfs via UFFDIO_COPY while preserving its setuid permission, then<br>
&gt; execute it to obtain root.<br>
&gt; <br>
&gt; The attack is deterministic (no timing dependency for the killpriv<br>
&gt; bypass), requires no heap spraying, and bypasses all modern kernel<br>
&gt; mitigations (KASLR, SMEP, SMAP, CFI, PAC, heap hardening).<br>
&gt; <br>
&gt; Affected versions: Linux 4.11+ (since shmem UFFDIO_COPY support,<br>
&gt;=C2=A0 =C2=A0 =C2=A0commit 4c27fe4c4c84 &quot;userfaultfd: shmem: add s=
hmem_mcopy_atomic_pte&quot;)<br>
<br>
This sounds like a bug, but not really exploitable.<br>
&gt; Confirmed on: 7.1.0 (aarch64)<br>
&gt; Affected distros: All major distributions (Ubuntu, Debian, Fedora,<br>
&gt;=C2=A0 =C2=A0 =C2=A0RHEL, SUSE, Arch, Android, ChromeOS) that have CONF=
IG_USERFAULTFD=3Dy<br>
&gt;=C2=A0 =C2=A0 =C2=A0and tmpfs mounted (virtually all Linux systems)<br>
&gt; <br>
&gt; Attached files:<br>
&gt;=C2=A0 =C2=A0- bad_bunny.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Full LPE exploit (uid=
=3D1000 to<br>
&gt; uid=3D0) Build: gcc -static -O2 -pthread<br>
&gt;=C2=A0 =C2=A0- suidhelper.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Standalone SUID pay=
load binary<br>
&gt; Build: gcc -static -O2<br>
&gt;=C2=A0 =C2=A0- uffdio_copy_lpe_report.md=C2=A0 =C2=A0 =C2=A0Detailed wr=
iteup with root cause,<br>
&gt; reproduction steps, and suggested fix<br>
&gt;=C2=A0 =C2=A0- badbunny_demo.mp4=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0PoC demo clip<br>
&gt; <br>
&gt; The PoC (bad_bunny.c) sets up a SUID target on tmpfs, drops to<br>
<br>
Since the exploit isn&#39;t public, I assume you set up the tmpfs file as r=
oot<br>
and world writable. This is not an LPE.<br>
<br>
<br>
-- <br>
Pedro<br>
</blockquote></div>

--00000000000018225606588588eb--

