Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6549BCD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1AF56B0088; Thu, 14 May 2026 05:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCB856B008A; Thu, 14 May 2026 05:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93296B008C; Thu, 14 May 2026 05:15:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 957386B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:15:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4457E1601D3
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:15:38 +0000 (UTC)
X-FDA: 84765467556.20.2DDF242
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 55DC940005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:15:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zt+Y5JyG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of muadda@gmail.com designates 209.85.217.41 as permitted sender) smtp.mailfrom=muadda@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778750136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JcQjJmflWJ8pYCEJnWU4oHhrlkdfNRXIu/7tPqXaaGs=;
	b=F+k7er0AbWYhIKDZ9UE+Eoi2mcwHJTocwdClI8n4+2HRhKiC67p55MpZ/Hhm0B/Y+qnIJa
	n07peSUK8WorE51MCEY3f1MFOEJ/vO9dpEUGydNzxr722rkcwzzfrMLkBIKd9hRyuxEyJC
	UCu1JmKZYzek/tQvjEbqCIXJbktyMjc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778750136; a=rsa-sha256;
	cv=pass;
	b=oPzzDyZfSlnXygPBiK/wEboptPhz/TpF+SeqaMC89HEF5qRsOtC5pBjUw+VB8NAT+Ybk5h
	j11WMsOdpo/esOccUPjT293ia0hdZWRvpvhZYo6MX1mAc5tTezRw2+K2VZ3Zuktm6Yv3ou
	qzcBxdFrYWjGzb4cjbJsa1j0tVkAdYk=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zt+Y5JyG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of muadda@gmail.com designates 209.85.217.41 as permitted sender) smtp.mailfrom=muadda@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-6312a0d556cso2937439137.3
        for <linux-mm@kvack.org>; Thu, 14 May 2026 02:15:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778750135; cv=none;
        d=google.com; s=arc-20240605;
        b=IutO9/ONGt5h6HrH+OB6bEOfyS57ASCEPeSrPaOp+GeevgxnnTgpjtHvbt7mRphU14
         Alc42MK3zquUsItrrwCcmCl8oZo8CYfClXu2y9wRocXfr9if6dTtFjoGtCult8fnN6FV
         fQ3h/ZcRRV8wscUVm0rkgeGB+0/PM+691thgR7ZIsEMLGlTWHKth3snCUMAeQl6BKzyp
         jjNdX/VdeaWSg3FoudEFVc7vF/6bZu4h2y3T4emomN1mEouyAslqY+gYOQM64UiiUFSL
         famF/DsBVzeEMV1L5dQNcjtsdJpB9j6WMofSce2xyBbxviGGECm8xT4sp0qTzL38a6nF
         tEVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=JcQjJmflWJ8pYCEJnWU4oHhrlkdfNRXIu/7tPqXaaGs=;
        fh=r6MZJtP+1jNUHdFjAOME1HaSJzYpQetMB0msxv9Z4po=;
        b=G21SBB3EK1cePHoca49wfKh6WUm4FxljDCB9ZhKE8CObMG2lgPOrWhmOL9xJBwGVap
         TUysESxX91UhoQ66DApxoefYQmclZdGkCUSFdzPkLN7tyUtNwY25A7aNS7uHVlceblm9
         pZaOEWpA/zcj1akHVoTfh64wYCw85a7ulzkhtj2NkQO7pp+Kgux3ImMSeTtnm+mOvKOz
         9tnfrSBHEAvKJGpQEuYLLh2jfQPkuSQfvS0PBdw+vEWYF4OJ1jHmB2DSsPCkSkVJBUN8
         Mpo0OE8Aow3Mst01sOE4MMRR/hZl1nNzD72o/LC1OBz0ELxAa9jfwsMYSSuDW3I5qtc0
         4pKQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778750135; x=1779354935; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JcQjJmflWJ8pYCEJnWU4oHhrlkdfNRXIu/7tPqXaaGs=;
        b=Zt+Y5JyGYEXF9tZChqlYJZGveEYxtz6Wuk7g1kz+Qhb/IoQfkCk5LNDNtkadKgN5Ki
         5dMrJFRqOslmN4I09scsjVS55yRECVEZovPXoyTw9DED6SUscLU6J90c9j6HEuuayChE
         l8Pt9Ly7jzr+EaPipKK5CpFxuzrQ7pcAtAOHd7SW0etHyvJMk5M6d7jy9Xj00syXsBeM
         AUWvuwXQzz0M6vEhnHoejPBY40VWWq00WhNQFa8qJfrrBzJ27FVFtFfRAKDSYkY2vslW
         +9DA3ae4cdHjYffXQTNhFw+9os8XsJVn9yVI1jDQCsYSxaZ0MdBEo4Wa74TKSlPC56eK
         gMgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778750135; x=1779354935;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JcQjJmflWJ8pYCEJnWU4oHhrlkdfNRXIu/7tPqXaaGs=;
        b=nZg+Vym0WR/KqiRBeTVqS5H374oHDSuA//IixDMqURJxEdumaBssgzrTjRk5m10Smq
         7bi1xh8CbYn+zbjs9H87QaabCXDVIHLVxO+8Zw3LIKtQDZp5HjH0aFgc4j+0e6l31Lj2
         R/k+KPttBbEZvQWS4V1Icr3n00lDV0mGe4fLnizJ6tWC9yR+SZsGloPkPIb4NIcKyBeh
         LRFxe5DGwTFY/lufJ/GjrvHPL7Tnd76rXN1eOGR+CkZuOrVhjV9V9PAxB1xHKVf9CH2F
         9ZfvKoimLcWjF7TAjEzmChxCYdrbGkf6YVcIFJRWSjLw6aCklDZz3wN0kgvNKKVipHpT
         7Oig==
X-Forwarded-Encrypted: i=1; AFNElJ9JXzW+SZDMJelxSaQLn+tNbbCHQ/tq2mrOhWc3bErq9dBoh0qoveiozclPC1rgxX5NlAqTvYIETA==@kvack.org
X-Gm-Message-State: AOJu0YwnH7RsuekQYZW9iE3ZR1X0rjHe/bhpTVeO0+n4Xk9O9r9g5pz8
	QuOUE6Ssth1LI6Aqis/tXOzwYy0I+Da0TQPbqLtoKSeLbGH6Hw6IPlhItChPqbH4txOUikLg6RC
	bp6D1+UUuT88RJpcdRkM70avEawvdxqo=
X-Gm-Gg: Acq92OGjWPTxRXRhN4yl54ICP8TaHhtJL08XlZ5EBPFaWA9mpu6iilQMBPp1mMGiSzc
	AWCkQeze6zThAdqL+RpGZC1sdl1YV1rQwmM4mGWWqcg/TcHDjzmGbTmNI2UwuFYZeEb9zTs3n3t
	yEklFqTMwBhm1XPfpQ/q50ou5f5w5MuFYMFADuEER6bHnNFX1UyNtlQRFfyTHWAyDIL3iHH0DWM
	Zu7FaPI7ZiO44AHlDRS2zTJz1j2UKmUJKom8LeMwMiTQ0oKHCleIk0wRa2OT5NXQPD07VfO1XXS
	dM2N2rILtwww0zr8CX88vAUt3ZHQkNp2ng==
X-Received: by 2002:a67:e7c9:0:b0:607:97b7:c283 with SMTP id
 ada2fe7eead31-63773706ec5mr3557793137.14.1778750135262; Thu, 14 May 2026
 02:15:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260428122826.339550-1-alban.crequy@gmail.com>
 <20260428122826.339550-2-alban.crequy@gmail.com> <8b29da5b-e260-4b77-a640-8abb447291d1@kernel.org>
In-Reply-To: <8b29da5b-e260-4b77-a640-8abb447291d1@kernel.org>
From: Alban Crequy <alban.crequy@gmail.com>
Date: Thu, 14 May 2026 11:15:23 +0200
X-Gm-Features: AVHnY4JmMvnlNcijFaJzvOY-gQv8qFgBhUDHyIkSORUWp_B9bJm9ixuBJjSyLzs
Message-ID: <CAMXgnP4tmjAXdP+DS_MeCR+eUH9P6GNnfN8Pvw0QsRy4QF=_Rg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm/process_vm_access: pidfd and nowait support for process_vm_readv/writev
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Alban Crequy <albancrequy@microsoft.com>, 
	Peter Xu <peterx@redhat.com>, Willy Tarreau <w@1wt.eu>, linux-kselftest@vger.kernel.org, 
	shuah@kernel.org, Usama Arif <usama.arif@linux.dev>, 
	David Laight <david.laight.linux@gmail.com>
Content-Type: multipart/alternative; boundary="000000000000f4e14a0651c38917"
X-Rspam-User: 
X-Rspamd-Queue-Id: 55DC940005
X-Rspamd-Server: rspam04
X-Stat-Signature: 63mh5pfctyo4qt71bt9ekbbaaymrsci1
X-HE-Tag: 1778750136-529046
X-HE-Meta: U2FsdGVkX1+gxytAWtcG2ZVqVBPdZJedgq7sZejV5kXA2IhG6AYIBgZzkaHKT1PfzJv7HNdh4E/XAHG4WARgYnNrNUofc1hsT9mMlbc4b3rPOWb+Z4iym4MDhvBtwVJv/DDN6tQfa4vBeEP2drqoe3X54b5NWiSpsfvVWHJy47hJClGyK52yr3NR0zc8F9hcAIUGOrJaaCYTf/tb7JMswoiTEtQobbWEobS/IDd5/UKaUWZ+3ZHok8fwvl2O5+GilHuMrK+b9BFKen/o3cwj6eWaNqA+bcDPZoMi66tGr9Pvphgt39Tv+F8eg43qxMY315t3SrC6gRcAR3Jnr0FHC5+zGrWVuzjpNviNaLb7T0ziVnfSA+oj905UYXcrPdQCqyI50hOpB+YviOoSikeSwgY3gZUybnrwc41yOp10ue0ZRMAY4tsBCcsa2r9jYuIX+No4NXyEwgOJSMLyFGYJTCIvxDL5IyF9TeXovhD18rDbaSDGCP7tbJDEIM8UVH8AjtgB7+d4OTS4pYEOJyaxrnzZ1OtBC75XDaHxH/AoPwdZG41ifA+jwi7val5aNOnt0OLsNyrnG8CXxXDAtSjcWARTr8IBrdj9706mP75wCBaA2pzQlPorfmQJZnsNQLsMlZOuNVvJCia4SUk6cx9AsMlfP+QOabv08WxQFQdKQaCqL4HeDYh10Z/Yv8LIPkEt8hqb/ig6r0rMvpErkSp8cNUNkJqMak+r7ylP/ZPR8EnDeE4lD9aW8h77zdxYIVhAvtxDPYmXNMyEx0+rrDT+QK4iHiZCvU1BdvrTq/B0wcfEIZFlz78c/2+Lo+zSWn1p3fl/6I86eqXP5GQqGfRQg6ccYFgV/2jXnf7iOxfgq2xgPURUuLJNBaRv6BmFo3l7wMxNBcP2tPEhaMcd9CsACR3Gj3O/bWDWyIbZdVXwES0Pb+WYn/mHQ8AdZEvb+xtrpcb9KQQiuXqOFTXUh3L
 Knv/kytQ
 soKrE4ZDJRk1vxUBCaJd0L0ACG+EXaHZ2aCHS9RX8fY12JD6leg8KAaIticxiWo7BKRDiefvcivwWNrR0O2df6i6lvRk7OUGYz/lVwVEt7TlJD/nvsm+Gk00PW6BYtxXYX4V/M+9TpobZiMmQ9RXfxgACq2kyoYm8QodMg+gFqjb7a6TInljt8MNmRnorsVDaMA7d8+4+JnpyJeGih4uuU2C8lF12YS6nWULUuvgsgR/VqkRmSdKjNU24oO5M4IwIjm7CWlE20MVDK8npaUYbog4sdpr7Pasa5SP0tAdZYkpQgHlS9crR6rrEBrDU1yb40boH+oRVv5h2xXxaXRYGeUXlX3D1qd0VRrns8G7SieW2IJtZ3KTU9YlnGtkJjtPK0/3G1cxDpYbxBLZZZ1Dj1ofFfxZ+DbFBBxAbq0e+X1e2HIcynITYUNQUKeKpC5Tm2W9v5MDljxLhUAL3Yigcb6/7wDFA3RDT/lh1TJc/sNfFQNfxzyvj16uNO658SOhiWVrHkpTzxCoH9Pb/pDl5DTL+d9+3w7+sJzKczHCrLxjbyxQFkrxt03E37Nqld7+yFKB5pZUQ+dm4vy8I4IhjahL3witdyBVnHZaKIfcm6E4p+1bmTVlAzGJqbKE/TRpYOtE2oLQqs3QhEEMXlbKmr/BLrc9t1rsm1HF+MKvfohtye/LlBGACXV0puZ0BeZDR3FGMIbvLhyVcvnFww5xcgtltEQeCIToYukNHEiuxcbtaIulDll0Lup7x0Tee6h4XitZuldRfJJgnSEHk0y+b6Bc0Z+mYAOzjpbxWQb5YQfqQZsBESRdmKysgrPjH1pUR0X8h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000f4e14a0651c38917
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David,

Thanks for the review. I'm addressing all your comments in v4.

On Tue, 28 Apr 2026 at 22:06, David Hildenbrand (Arm) <david@kernel.org>
wrote:
>
> On 4/28/26 14:28, Alban Crequy wrote:
> > From: Alban Crequy <albancrequy@microsoft.com>
>
> Hi,
>
> some more smaller comments. Overall, LGTM.
>
> >
> > There are two categories of users for process_vm_readv:
> >
> > 1. Debuggers like GDB or strace.
> >
> >    When a debugger attempts to read the target memory and triggers a
> >    page fault, the page fault needs to be resolved so that the debugger
> >    can accurately interpret the memory. A debugger is typically attache=
d
> >    to a single process.
> >
> > 2. Profilers like OpenTelemetry eBPF Profiler.
> >
> >    The profiler uses a perf event to get stack traces from all
> >    processes at 20Hz (20 stack traces to resolve per second). For
> >    interpreted languages (Ruby, Python, etc.), the profiler uses
> >    process_vm_readv to get the correct symbols. In this case,
> >    performance is the most important. It is fine if some stack traces
> >    cannot be resolved as long as it is not statistically significant.
> >
> > The current behaviour of process_vm_readv is to resolve page faults in
> > the target VM. This is as desired for debuggers, but unwelcome for
> > profilers because the page fault resolution could take a lot of time
> > depending on the backing filesystem. Additionally, since profilers
> > monitor all processes, we don't want a slow page fault resolution for
> > one target process slowing down the monitoring for all other target
> > processes.
> >
> > This patch adds the flag PROCESS_VM_NOWAIT, so the caller can choose to
> > not block on IO if the memory access causes a page fault.
>
> What is the expected return value to user space if we run into this case?

If the first page is not resident and PROCESS_VM_NOWAIT is set, it returns
-1
with errno EFAULT.

It can also return a short read, meaning it returns the number of bytes
successfully transferred from pages prior to the fault.

This is the same partial-read behavior as a regular
process_vm_readv when hitting an unmapped page =E2=80=94 NOWAIT just change=
s
when the fault fails (immediately instead of blocking).

I've documented this in the updated commit message in v4 (I will send it
shortly). I also added two selftests that verify partial reads across a
resident and a non-resident page (with both single iovec and two iovecs).

Interestingly, while writing these tests, I found that the current
process_vm_readv(2) man page incorrectly claims that partial transfers
apply at iovec-element granularity. In practice, the kernel returns
partial reads at page granularity within a single remote iovec element.
I've sent a separate fix for that to linux-man@:
https://lore.kernel.org/linux-man/20260514083659.139971-1-alban.crequy@gmai=
l.com/T/#u

> And in the same context: Will you send a man page update? :)

I've included a suggested man page update in the commit message of v4 patch
1/2, ready for the man-pages maintainer to pick up. I'll also send a
separate
patch to linux-man@ once the kernel patches are merged and available in a
new
Linux release.

> > Additionally, this patch adds the flag PROCESS_VM_PIDFD to refer to the
> > remote process via PID file descriptor instead of PID. Such a file
> > descriptor can be obtained with pidfd_open(2). This is useful to avoid
> > the pid number being reused. It is unlikely to happen for debuggers
> > because they can monitor the target process termination in other ways
> > (ptrace), but can be helpful in some profiling scenarios.
> >
> > If a given flag is unsupported, the syscall returns the error EINVAL
> > without checking the buffers. This gives a way to userspace to detect
> > whether the current kernel supports a specific flag:
> >
> >   process_vm_readv(pid, NULL, 1, NULL, 1, PROCESS_VM_PIDFD)
> >   -> EINVAL if the kernel does not support the flag PROCESS_VM_PIDFD
> >      (before this patch)
> >   -> EFAULT if the kernel supports the flag (after this patch)
> >
> > Signed-off-by: Alban Crequy <albancrequy@microsoft.com>
> > ---
> > v3:
> > - Fix ERR_PTR handling for pidfd_get_task(): use IS_ERR()/PTR_ERR()
> >   for the pidfd path, matching process_madvise() (Usama Arif, Sashiko)
> >
> > v2:
> > - Expand commit message with use-case motivation (David Hildenbrand)
> > - Use unsigned long consistently for pvm_flags parameter (David
Hildenbrand)
> > - Add PROCESS_VM_SUPPORTED_FLAGS kernel-internal define (David
Hildenbrand)
> > - Keep (1UL << N) in UAPI header: BIT() is defined in vdso/bits.h
> >   which is not exported to userspace, so UAPI headers using BIT() would
> >   break when included from userspace programs (David Hildenbrand)
> >
> >  MAINTAINERS                     |  1 +
> >  include/uapi/linux/process_vm.h |  9 +++++++++
> >  mm/process_vm_access.c          | 34 ++++++++++++++++++++++++---------
> >  3 files changed, 35 insertions(+), 9 deletions(-)
> >  create mode 100644 include/uapi/linux/process_vm.h
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 2fb1c75afd16..0f6ce21d6235 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16786,6 +16786,7 @@ F:    include/linux/ptdump.h
> >  F:   include/linux/vmpressure.h
> >  F:   include/linux/vmstat.h
> >  F:   fs/proc/meminfo.c
> > +F:   include/uapi/linux/process_vm.h
>
> We try to sort this alphabetically. Sometimes we failed. Likely this
should just
> go to one more line up.

Fixed in v4 =E2=80=94 moved the include/uapi line to the correct position.

> >  F:   kernel/fork.c
> >  F:   mm/Kconfig
> >  F:   mm/debug.c
> > diff --git a/include/uapi/linux/process_vm.h
b/include/uapi/linux/process_vm.h
> > new file mode 100644
> > index 000000000000..4168e09f3f4e
> > --- /dev/null
> > +++ b/include/uapi/linux/process_vm.h
>
> Thinking out loud: the c file is called "process_vm_access.c", should we
name
> the header like that as well?

Good idea =E2=80=94 renamed to include/uapi/linux/process_vm_access.h in v4=
.

> > @@ -0,0 +1,9 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +#ifndef _UAPI_LINUX_PROCESS_VM_H
> > +#define _UAPI_LINUX_PROCESS_VM_H
> > +
> > +/* Flags for process_vm_readv/process_vm_writev */
> > +#define PROCESS_VM_PIDFD        (1UL << 0)
> > +#define PROCESS_VM_NOWAIT       (1UL << 1)
>
> Should we use BIT here? I see some usage in other uapi headers (e.g.,
tcp.h)

As noted in the v2/v3 changelog: BIT() is defined in vdso/bits.h which is
not
exported to userspace. UAPI headers using BIT() (like tcp.h) work in-kernel
but
break for userspace programs that include these headers directly. In
practice,
BIT() in tcp.h is only used by TCP_ACCECN_* flags, so merely including
tcp.h in
userspace programs won't break them unless they use those flags. Those flag=
s
were moved from kernel-only headers to UAPI headers in commit 4fa4ac5e5848
("tcp: accecn: add tcpi_ecn_mode and tcpi_option2 in tcp_info"), which
appeared
in Linux v7.0-rc1 (not yet in a release). So userspace programs don't yet
use
those macros.

So I think (1UL << N) is the correct choice for UAPI.

> > +
> > +#endif /* _UAPI_LINUX_PROCESS_VM_H */
> > diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
> > index 656d3e88755b..dacef50be0be 100644
> > --- a/mm/process_vm_access.c
> > +++ b/mm/process_vm_access.c
> > @@ -14,6 +14,9 @@
> >  #include <linux/ptrace.h>
> >  #include <linux/slab.h>
> >  #include <linux/syscalls.h>
> > +#include <linux/process_vm.h>
> > +
> > +#define PROCESS_VM_SUPPORTED_FLAGS (PROCESS_VM_PIDFD |
PROCESS_VM_NOWAIT)
> >
> >  /**
> >   * process_vm_rw_pages - read/write pages from task specified
> > @@ -68,6 +71,7 @@ static int process_vm_rw_pages(struct page **pages,
> >   * @mm: mm for task
> >   * @task: task to read/write from
> >   * @vm_write: 0 means copy from, 1 means copy to
> > + * @pvm_flags: PROCESS_VM_* flags
> >   * Returns 0 on success or on failure error code
> >   */
> >  static int process_vm_rw_single_vec(unsigned long addr,
> > @@ -76,7 +80,8 @@ static int process_vm_rw_single_vec(unsigned long
addr,
> >                                   struct page **process_pages,
> >                                   struct mm_struct *mm,
> >                                   struct task_struct *task,
> > -                                 int vm_write)
> > +                                 int vm_write,
> > +                                 unsigned long pvm_flags)
> >  {
> >       unsigned long pa =3D addr & PAGE_MASK;
> >       unsigned long start_offset =3D addr - pa;
> > @@ -91,6 +96,8 @@ static int process_vm_rw_single_vec(unsigned long
addr,
> >
> >       if (vm_write)
> >               flags |=3D FOLL_WRITE;
> > +     if (pvm_flags & PROCESS_VM_NOWAIT)
> > +             flags |=3D FOLL_NOWAIT;
> >
> >       while (!rc && nr_pages && iov_iter_count(iter)) {
> >               int pinned_pages =3D min_t(unsigned long, nr_pages,
PVM_MAX_USER_PAGES);
> > @@ -141,7 +148,7 @@ static int process_vm_rw_single_vec(unsigned long
addr,
> >   * @iter: where to copy to/from locally
> >   * @rvec: iovec array specifying where to copy to/from in the other
process
> >   * @riovcnt: size of rvec array
> > - * @flags: currently unused
> > + * @flags: process_vm_readv/writev flags
> >   * @vm_write: 0 if reading from other process, 1 if writing to other
process
> >   *
> >   * Returns the number of bytes read/written or error code. May
> > @@ -163,6 +170,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct
iov_iter *iter,
> >       unsigned long nr_pages_iov;
> >       ssize_t iov_len;
> >       size_t total_len =3D iov_iter_count(iter);
> > +     unsigned int f_flags;
> >
> >       /*
> >        * Work out how many pages of struct pages we're going to need
> > @@ -194,10 +202,18 @@ static ssize_t process_vm_rw_core(pid_t pid,
struct iov_iter *iter,
> >       }
> >
> >       /* Get process information */
> > -     task =3D find_get_task_by_vpid(pid);
> > -     if (!task) {
> > -             rc =3D -ESRCH;
> > -             goto free_proc_pages;
> > +     if (flags & PROCESS_VM_PIDFD) {
> > +             task =3D pidfd_get_task(pid, &f_flags);
> > +             if (IS_ERR(task)) {
> > +                     rc =3D PTR_ERR(task);
>
> This could return -EBADF or -ESRCH. We should document both in the man
page. (or
> decide to always return -ESRCH, dunno)

Agreed with Christian's reply =E2=80=94 keeping the actual errno from
pidfd_get_task() is useful information for userspace. Both EBADF
and ESRCH are documented in the suggested man page update text in v4.

Thanks,
Alban

>
>
>
> --
> Cheers,
>
> David

--000000000000f4e14a0651c38917
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi David,<br><br>Thanks for the review. I&#39;m addressing=
 all your comments in v4.<br><br>On Tue, 28 Apr 2026 at 22:06, David Hilden=
brand (Arm) &lt;<a href=3D"mailto:david@kernel.org">david@kernel.org</a>&gt=
; wrote:<br>&gt;<br>&gt; On 4/28/26 14:28, Alban Crequy wrote:<br>&gt; &gt;=
 From: Alban Crequy &lt;<a href=3D"mailto:albancrequy@microsoft.com">albanc=
requy@microsoft.com</a>&gt;<br>&gt;<br>&gt; Hi,<br>&gt;<br>&gt; some more s=
maller comments. Overall, LGTM.<br>&gt;<br>&gt; &gt;<br>&gt; &gt; There are=
 two categories of users for process_vm_readv:<br>&gt; &gt;<br>&gt; &gt; 1.=
 Debuggers like GDB or strace.<br>&gt; &gt;<br>&gt; &gt; =C2=A0 =C2=A0When =
a debugger attempts to read the target memory and triggers a<br>&gt; &gt; =
=C2=A0 =C2=A0page fault, the page fault needs to be resolved so that the de=
bugger<br>&gt; &gt; =C2=A0 =C2=A0can accurately interpret the memory. A deb=
ugger is typically attached<br>&gt; &gt; =C2=A0 =C2=A0to a single process.<=
br>&gt; &gt;<br>&gt; &gt; 2. Profilers like OpenTelemetry eBPF Profiler.<br=
>&gt; &gt;<br>&gt; &gt; =C2=A0 =C2=A0The profiler uses a perf event to get =
stack traces from all<br>&gt; &gt; =C2=A0 =C2=A0processes at 20Hz (20 stack=
 traces to resolve per second). For<br>&gt; &gt; =C2=A0 =C2=A0interpreted l=
anguages (Ruby, Python, etc.), the profiler uses<br>&gt; &gt; =C2=A0 =C2=A0=
process_vm_readv to get the correct symbols. In this case,<br>&gt; &gt; =C2=
=A0 =C2=A0performance is the most important. It is fine if some stack trace=
s<br>&gt; &gt; =C2=A0 =C2=A0cannot be resolved as long as it is not statist=
ically significant.<br>&gt; &gt;<br>&gt; &gt; The current behaviour of proc=
ess_vm_readv is to resolve page faults in<br>&gt; &gt; the target VM. This =
is as desired for debuggers, but unwelcome for<br>&gt; &gt; profilers becau=
se the page fault resolution could take a lot of time<br>&gt; &gt; dependin=
g on the backing filesystem. Additionally, since profilers<br>&gt; &gt; mon=
itor all processes, we don&#39;t want a slow page fault resolution for<br>&=
gt; &gt; one target process slowing down the monitoring for all other targe=
t<br>&gt; &gt; processes.<br>&gt; &gt;<br>&gt; &gt; This patch adds the fla=
g PROCESS_VM_NOWAIT, so the caller can choose to<br>&gt; &gt; not block on =
IO if the memory access causes a page fault.<br>&gt;<br>&gt; What is the ex=
pected return value to user space if we run into this case?<br><br>If the f=
irst page is not resident and PROCESS_VM_NOWAIT is set, it returns -1<br>wi=
th errno EFAULT.<br><br>It can also return a short read, meaning it returns=
 the number of bytes<br>successfully transferred from pages prior to the fa=
ult.<br><br>This is the same partial-read behavior as a regular<br>process_=
vm_readv when hitting an unmapped page =E2=80=94 NOWAIT just changes<br>whe=
n the fault fails (immediately instead of blocking).<br><br>I&#39;ve docume=
nted this in the updated commit message in v4 (I will send it<br>shortly). =
I also added two selftests that verify partial reads across a<br>resident a=
nd a non-resident page (with both single iovec and two iovecs).<br><br>Inte=
restingly, while writing these tests, I found that the current<br>process_v=
m_readv(2) man page incorrectly claims that partial transfers<br>apply at i=
ovec-element granularity. In practice, the kernel returns<br>partial reads =
at page granularity within a single remote iovec element.<br>I&#39;ve sent =
a separate fix for that to linux-man@:<br><a href=3D"https://lore.kernel.or=
g/linux-man/20260514083659.139971-1-alban.crequy@gmail.com/T/#u">https://lo=
re.kernel.org/linux-man/20260514083659.139971-1-alban.crequy@gmail.com/T/#u=
</a><br><br>&gt; And in the same context: Will you send a man page update? =
:)<br><br>I&#39;ve included a suggested man page update in the commit messa=
ge of v4 patch<br>1/2, ready for the man-pages maintainer to pick up. I&#39=
;ll also send a separate<br>patch to linux-man@ once the kernel patches are=
 merged and available in a new<br>Linux release.<br><br>&gt; &gt; Additiona=
lly, this patch adds the flag PROCESS_VM_PIDFD to refer to the<br>&gt; &gt;=
 remote process via PID file descriptor instead of PID. Such a file<br>&gt;=
 &gt; descriptor can be obtained with pidfd_open(2). This is useful to avoi=
d<br>&gt; &gt; the pid number being reused. It is unlikely to happen for de=
buggers<br>&gt; &gt; because they can monitor the target process terminatio=
n in other ways<br>&gt; &gt; (ptrace), but can be helpful in some profiling=
 scenarios.<br>&gt; &gt;<br>&gt; &gt; If a given flag is unsupported, the s=
yscall returns the error EINVAL<br>&gt; &gt; without checking the buffers. =
This gives a way to userspace to detect<br>&gt; &gt; whether the current ke=
rnel supports a specific flag:<br>&gt; &gt;<br>&gt; &gt; =C2=A0 process_vm_=
readv(pid, NULL, 1, NULL, 1, PROCESS_VM_PIDFD)<br>&gt; &gt; =C2=A0 -&gt; EI=
NVAL if the kernel does not support the flag PROCESS_VM_PIDFD<br>&gt; &gt; =
=C2=A0 =C2=A0 =C2=A0(before this patch)<br>&gt; &gt; =C2=A0 -&gt; EFAULT if=
 the kernel supports the flag (after this patch)<br>&gt; &gt;<br>&gt; &gt; =
Signed-off-by: Alban Crequy &lt;<a href=3D"mailto:albancrequy@microsoft.com=
">albancrequy@microsoft.com</a>&gt;<br>&gt; &gt; ---<br>&gt; &gt; v3:<br>&g=
t; &gt; - Fix ERR_PTR handling for pidfd_get_task(): use IS_ERR()/PTR_ERR()=
<br>&gt; &gt; =C2=A0 for the pidfd path, matching process_madvise() (Usama =
Arif, Sashiko)<br>&gt; &gt;<br>&gt; &gt; v2:<br>&gt; &gt; - Expand commit m=
essage with use-case motivation (David Hildenbrand)<br>&gt; &gt; - Use unsi=
gned long consistently for pvm_flags parameter (David Hildenbrand)<br>&gt; =
&gt; - Add PROCESS_VM_SUPPORTED_FLAGS kernel-internal define (David Hildenb=
rand)<br>&gt; &gt; - Keep (1UL &lt;&lt; N) in UAPI header: BIT() is defined=
 in vdso/bits.h<br>&gt; &gt; =C2=A0 which is not exported to userspace, so =
UAPI headers using BIT() would<br>&gt; &gt; =C2=A0 break when included from=
 userspace programs (David Hildenbrand)<br>&gt; &gt;<br>&gt; &gt; =C2=A0MAI=
NTAINERS =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 | =C2=A01 +<br>&gt; &gt; =C2=A0include/uapi/linux/process_vm.h | =C2=A0=
9 +++++++++<br>&gt; &gt; =C2=A0mm/process_vm_access.c =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0| 34 ++++++++++++++++++++++++---------<br>&gt; &gt; =C2=A03 fi=
les changed, 35 insertions(+), 9 deletions(-)<br>&gt; &gt; =C2=A0create mod=
e 100644 include/uapi/linux/process_vm.h<br>&gt; &gt;<br>&gt; &gt; diff --g=
it a/MAINTAINERS b/MAINTAINERS<br>&gt; &gt; index 2fb1c75afd16..0f6ce21d623=
5 100644<br>&gt; &gt; --- a/MAINTAINERS<br>&gt; &gt; +++ b/MAINTAINERS<br>&=
gt; &gt; @@ -16786,6 +16786,7 @@ F: =C2=A0 =C2=A0include/linux/ptdump.h<br>=
&gt; &gt; =C2=A0F: =C2=A0 include/linux/vmpressure.h<br>&gt; &gt; =C2=A0F: =
=C2=A0 include/linux/vmstat.h<br>&gt; &gt; =C2=A0F: =C2=A0 fs/proc/meminfo.=
c<br>&gt; &gt; +F: =C2=A0 include/uapi/linux/process_vm.h<br>&gt;<br>&gt; W=
e try to sort this alphabetically. Sometimes we failed. Likely this should =
just<br>&gt; go to one more line up.<br><br>Fixed in v4 =E2=80=94 moved the=
 include/uapi line to the correct position.<br><br>&gt; &gt; =C2=A0F: =C2=
=A0 kernel/fork.c<br>&gt; &gt; =C2=A0F: =C2=A0 mm/Kconfig<br>&gt; &gt; =C2=
=A0F: =C2=A0 mm/debug.c<br>&gt; &gt; diff --git a/include/uapi/linux/proces=
s_vm.h b/include/uapi/linux/process_vm.h<br>&gt; &gt; new file mode 100644<=
br>&gt; &gt; index 000000000000..4168e09f3f4e<br>&gt; &gt; --- /dev/null<br=
>&gt; &gt; +++ b/include/uapi/linux/process_vm.h<br>&gt;<br>&gt; Thinking o=
ut loud: the c file is called &quot;process_vm_access.c&quot;, should we na=
me<br>&gt; the header like that as well?<br><br>Good idea =E2=80=94 renamed=
 to include/uapi/linux/process_vm_access.h in v4.<br><br>&gt; &gt; @@ -0,0 =
+1,9 @@<br>&gt; &gt; +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscal=
l-note */<br>&gt; &gt; +#ifndef _UAPI_LINUX_PROCESS_VM_H<br>&gt; &gt; +#def=
ine _UAPI_LINUX_PROCESS_VM_H<br>&gt; &gt; +<br>&gt; &gt; +/* Flags for proc=
ess_vm_readv/process_vm_writev */<br>&gt; &gt; +#define PROCESS_VM_PIDFD =
=C2=A0 =C2=A0 =C2=A0 =C2=A0(1UL &lt;&lt; 0)<br>&gt; &gt; +#define PROCESS_V=
M_NOWAIT =C2=A0 =C2=A0 =C2=A0 (1UL &lt;&lt; 1)<br>&gt;<br>&gt; Should we us=
e BIT here? I see some usage in other uapi headers (e.g., tcp.h)<br><br>As =
noted in the v2/v3 changelog: BIT() is defined in vdso/bits.h which is not<=
br>exported to userspace. UAPI headers using BIT() (like tcp.h) work in-ker=
nel but<br>break for userspace programs that include these headers directly=
. In practice,<br>BIT() in tcp.h is only used by TCP_ACCECN_* flags, so mer=
ely including tcp.h in<br>userspace programs won&#39;t break them unless th=
ey use those flags. Those flags<br>were moved from kernel-only headers to U=
API headers in commit 4fa4ac5e5848<br>(&quot;tcp: accecn: add tcpi_ecn_mode=
 and tcpi_option2 in tcp_info&quot;), which appeared<br>in Linux v7.0-rc1 (=
not yet in a release). So userspace programs don&#39;t yet use<br>those mac=
ros.<br><br>So I think (1UL &lt;&lt; N) is the correct choice for UAPI.<br>=
<br>&gt; &gt; +<br>&gt; &gt; +#endif /* _UAPI_LINUX_PROCESS_VM_H */<br>&gt;=
 &gt; diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c<br>&gt; =
&gt; index 656d3e88755b..dacef50be0be 100644<br>&gt; &gt; --- a/mm/process_=
vm_access.c<br>&gt; &gt; +++ b/mm/process_vm_access.c<br>&gt; &gt; @@ -14,6=
 +14,9 @@<br>&gt; &gt; =C2=A0#include &lt;linux/ptrace.h&gt;<br>&gt; &gt; =
=C2=A0#include &lt;linux/slab.h&gt;<br>&gt; &gt; =C2=A0#include &lt;linux/s=
yscalls.h&gt;<br>&gt; &gt; +#include &lt;linux/process_vm.h&gt;<br>&gt; &gt=
; +<br>&gt; &gt; +#define PROCESS_VM_SUPPORTED_FLAGS (PROCESS_VM_PIDFD | PR=
OCESS_VM_NOWAIT)<br>&gt; &gt;<br>&gt; &gt; =C2=A0/**<br>&gt; &gt; =C2=A0 * =
process_vm_rw_pages - read/write pages from task specified<br>&gt; &gt; @@ =
-68,6 +71,7 @@ static int process_vm_rw_pages(struct page **pages,<br>&gt; =
&gt; =C2=A0 * @mm: mm for task<br>&gt; &gt; =C2=A0 * @task: task to read/wr=
ite from<br>&gt; &gt; =C2=A0 * @vm_write: 0 means copy from, 1 means copy t=
o<br>&gt; &gt; + * @pvm_flags: PROCESS_VM_* flags<br>&gt; &gt; =C2=A0 * Ret=
urns 0 on success or on failure error code<br>&gt; &gt; =C2=A0 */<br>&gt; &=
gt; =C2=A0static int process_vm_rw_single_vec(unsigned long addr,<br>&gt; &=
gt; @@ -76,7 +80,8 @@ static int process_vm_rw_single_vec(unsigned long add=
r,<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct page **p=
rocess_pages,<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stru=
ct mm_struct *mm,<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 struct task_struct *task,<br>&gt; &gt; - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 int vm_write)<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 int vm_write,<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsig=
ned long pvm_flags)<br>&gt; &gt; =C2=A0{<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =
unsigned long pa =3D addr &amp; PAGE_MASK;<br>&gt; &gt; =C2=A0 =C2=A0 =C2=
=A0 unsigned long start_offset =3D addr - pa;<br>&gt; &gt; @@ -91,6 +96,8 @=
@ static int process_vm_rw_single_vec(unsigned long addr,<br>&gt; &gt;<br>&=
gt; &gt; =C2=A0 =C2=A0 =C2=A0 if (vm_write)<br>&gt; &gt; =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 flags |=3D FOLL_WRITE;<br>&gt; &gt; + =C2=
=A0 =C2=A0 if (pvm_flags &amp; PROCESS_VM_NOWAIT)<br>&gt; &gt; + =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 flags |=3D FOLL_NOWAIT;<br>&gt; &gt;<br>&gt=
; &gt; =C2=A0 =C2=A0 =C2=A0 while (!rc &amp;&amp; nr_pages &amp;&amp; iov_i=
ter_count(iter)) {<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 int pinned_pages =3D min_t(unsigned long, nr_pages, PVM_MAX_USER_PAG=
ES);<br>&gt; &gt; @@ -141,7 +148,7 @@ static int process_vm_rw_single_vec(u=
nsigned long addr,<br>&gt; &gt; =C2=A0 * @iter: where to copy to/from local=
ly<br>&gt; &gt; =C2=A0 * @rvec: iovec array specifying where to copy to/fro=
m in the other process<br>&gt; &gt; =C2=A0 * @riovcnt: size of rvec array<b=
r>&gt; &gt; - * @flags: currently unused<br>&gt; &gt; + * @flags: process_v=
m_readv/writev flags<br>&gt; &gt; =C2=A0 * @vm_write: 0 if reading from oth=
er process, 1 if writing to other process<br>&gt; &gt; =C2=A0 *<br>&gt; &gt=
; =C2=A0 * Returns the number of bytes read/written or error code. May<br>&=
gt; &gt; @@ -163,6 +170,7 @@ static ssize_t process_vm_rw_core(pid_t pid, s=
truct iov_iter *iter,<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 unsigned long nr_pa=
ges_iov;<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 ssize_t iov_len;<br>&gt; &gt; =
=C2=A0 =C2=A0 =C2=A0 size_t total_len =3D iov_iter_count(iter);<br>&gt; &gt=
; + =C2=A0 =C2=A0 unsigned int f_flags;<br>&gt; &gt;<br>&gt; &gt; =C2=A0 =
=C2=A0 =C2=A0 /*<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0* Work out how man=
y pages of struct pages we&#39;re going to need<br>&gt; &gt; @@ -194,10 +20=
2,18 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,=
<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 }<br>&gt; &gt;<br>&gt; &gt; =C2=A0 =C2=
=A0 =C2=A0 /* Get process information */<br>&gt; &gt; - =C2=A0 =C2=A0 task =
=3D find_get_task_by_vpid(pid);<br>&gt; &gt; - =C2=A0 =C2=A0 if (!task) {<b=
r>&gt; &gt; - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -ESRCH;<br>&=
gt; &gt; - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto free_proc_pages;<=
br>&gt; &gt; + =C2=A0 =C2=A0 if (flags &amp; PROCESS_VM_PIDFD) {<br>&gt; &g=
t; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 task =3D pidfd_get_task(pid,=
 &amp;f_flags);<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if=
 (IS_ERR(task)) {<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D PTR_ERR(task);<br>&gt;<br>&gt; This coul=
d return -EBADF or -ESRCH. We should document both in the man page. (or<br>=
&gt; decide to always return -ESRCH, dunno)<br><br>Agreed with Christian&#3=
9;s reply =E2=80=94 keeping the actual errno from<br>pidfd_get_task() is us=
eful information for userspace. Both EBADF<br>and ESRCH are documented in t=
he suggested man page update text in v4.<br><br>Thanks,<br>Alban<br><br>&gt=
;<br>&gt;<br>&gt;<br>&gt; --<br>&gt; Cheers,<br>&gt;<br>&gt; David</div>

--000000000000f4e14a0651c38917--

