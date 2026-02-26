Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B919EFC5903
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA4EE6B0088; Thu, 26 Feb 2026 02:40:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5BAE6B0089; Thu, 26 Feb 2026 02:40:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88506B008A; Thu, 26 Feb 2026 02:40:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91DEF6B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:40:52 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2DD235BF2B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:40:52 +0000 (UTC)
X-FDA: 84485811144.12.CABCDFD
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id 29A6B40010
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:40:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=u3f52SWm;
	spf=pass (imf27.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772091650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2GU5SM6jqGe2gfNc3W7uqQvvp0coVugTWgrE3eLCzdQ=;
	b=yoYCmmh3vDd3KSak0FhYEW1v15kT362rvL/2+Vf739wXzsIFBsh+MtiPLXL6bXK0V5oQrS
	A6oaf7dfAaETFsHpOcsQxsqKLwsVCpNRSa7Cyf4Fa6UkqZftxcfPL4BrD8jF3z+rwBKZBk
	i+9s54wABM37Ue/oqP7pjPZ5L6WOuLw=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=u3f52SWm;
	spf=pass (imf27.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772091650; a=rsa-sha256;
	cv=pass;
	b=aZ/c7xri+2trPcLU+zBVERcnyn9IJooVrOI/EOhwqztJ5KCqkWjLPjKzTn7Lzx5V99h54l
	kliJ1/SYDIBJy8LCuxk3znicsHhnr05YBx/ramyFiyyHoKPKGuSQrMTL/PquyPSq7Qe5OY
	fl+dv5hI2Ff8EB26japqeQkxmKZXAiQ=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ada9e4ea32so52895ad.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:40:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772091649; cv=none;
        d=google.com; s=arc-20240605;
        b=Ih4WWVUwlMvoCkIoipbImi+NUQCZQkJAT3gHq43ct0WTQl/rBHCCBZqzOjSvj4p5S/
         xNqK1XEZCsASz6rB+1sxFzokj17wD+Clr64r6hFSD3HBzZ3uF7S2VBASHySWAe+iU6oQ
         jqCR3shh572EKoeU0Qvnv3+ecbdbaQEKLgr6/DpTKeZc8rRAMDk3J02uEYxrXzpW9FxR
         BltTev9s0pVT/UqIcFb4Lja6VVOuT92URj/J8DpjkvSZxdOmzmUXUS5XSRaLiG/aLh1p
         WScpgC1QRVuF2imtYGVs34AZuCJqC6O9PwZDyBDFLLVbhM/t8gEqY6ariKekyDhuDtYF
         q1Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2GU5SM6jqGe2gfNc3W7uqQvvp0coVugTWgrE3eLCzdQ=;
        fh=QLxJeTTVMFrQFy4+qnaHrIWuGhVo6d5yPE9BV5o8dLU=;
        b=SO5vlFMBmPbVwKS/Oy2giPGwpBNTkpUxkjyyQe+K0aHKh47loFeXzNxZzoHxXgRvAc
         E0YboUj0FOwp2LuQfGX4h1d3bJtLocP0Y/2SoXHNXOI82O6l188bB18CgTeX/tgeT41f
         cyEogPDnzzuCdb+iHrjoNetooE+C4k1kBs7iip+oyV7GVpoGqvFYAx77bOoXrIjMjm8n
         QqD3okEvskPAbvls5ZxGVhu1Vi1Mvq6t0Mn+xO6AE8NckklVUYlIgVbsURPDX6sszz5/
         LEb72hHT/WAIQMijnkXSKAuKImHHzFCEjmhnMVzRL6S6qb1bkvFAkmG/nbw7Uqtfu3sb
         hrIg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772091649; x=1772696449; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2GU5SM6jqGe2gfNc3W7uqQvvp0coVugTWgrE3eLCzdQ=;
        b=u3f52SWmy4TdvZy/HNpon3R7C6KZMTQsBdE3D44MDg33UkRYRTgm9/gs+PBveyq+Gt
         THVsD5DtZ3nOZBY5g/ZYw0iE1fjLsDwHLkWZpJCp+kWZ9tnqFKsKE/J+6o7z3v3LAsAk
         /edg6mkBXcTCsq/PcGSNeb5jMKrOQRu9MMyQx8M5eHy8N7BuM1XrU1pf6AQY3nN+2SVe
         CCx65ZrXCyUXf1xkRyULqjFae7iH4uNsYV+m7s+UEfg6oh7Ht7bPgAL6clgjEfk8Mq36
         5xiBPalE4UBHWL0ck/IW2+L9A6tZiYwPQWoWwZO+mad5uw0dis7WwAzv4zWulv3rRyNd
         ktzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772091649; x=1772696449;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2GU5SM6jqGe2gfNc3W7uqQvvp0coVugTWgrE3eLCzdQ=;
        b=B/aH6yU2lHQZS1MZybZcmLOTX1+kjRnQGFVmWSaKmS8Kp1m2w1AcsG3foW1JXOExSV
         oB4DrvjPvWaXzuK53M4CwYR7+u7Xpc+HnaS7RBhy2pXt9d+0NUucP/Pp8E7l0kBekCAI
         EU0GoX3/5+ZotbYWUUynemH6BWu1pPP8+QLM78IJtKCgtKQofWLLC2fJa1DnSs/OURGG
         qT27qPM86VTpjt13D8pnh1j8GnOpN3cH2XWjEvfQgtZB+lfPmgoJ/vAz7umPfPSedmZp
         1RZGHj/Npfx6X+Bv8CyttPp+WAWEIcRPLvoVuu4/rCAXxAFOTYJASlNMVbetY+mnFVqO
         Jylg==
X-Forwarded-Encrypted: i=1; AJvYcCUGhQQaKzBZzW//70IkTfJjkgpvkHuT3g18ujXG427HdEZWGNeh3gRvYN74wrCjDDhJ/XaF69oSqw==@kvack.org
X-Gm-Message-State: AOJu0YwSa1AiPndjA57doD4lwCFSOxtBCSW7zb2NWEFpuqJnbEDlwcVo
	XZLjqfPEEYo5N4OVPymGZAZluwAqm9HAxysK1NMyVGudK6I2fNHb4w8UtJ5VROqcziIXl5JsE6f
	pJMyITHaIlHMVgX4sBi9BSYcdQLI+VCzNEVSX3dnu
X-Gm-Gg: ATEYQzzG+WR+NcBkh1azey69TjV0+hVjOhZl2YzOX/EoFtcis3eeUEBpOJdufj9ak/9
	9GnwdLVHNbwhurBivuKT1M7WoJ06tUO6lX84nASyc8z6AqLgz0SS8HZbDp/Ky8camoXdIv2LfYx
	rTou5H/jAVZ0gaJay8RZed6J6qRS4gi8EHqQlA0Feg6OA0HzAAfMOJf+ZWvVuFo9Hn7o/67quew
	YSNpD/5XAHrmwRhdJ1MdGGQxNG2bWnyGQ2Pvg2JNjGWOmG8jfjDxxJHJ3s9yYx/3XPt2yn0kA8W
	T9b5mlr73Nzks2vdY/NFW5ER7b84jYtWlHuumd+MrtgOCGS51w==
X-Received: by 2002:a17:903:1ad0:b0:2a7:6c4e:5914 with SMTP id
 d9443c01a7336-2adf7721839mr1456305ad.6.1772091648235; Wed, 25 Feb 2026
 23:40:48 -0800 (PST)
MIME-Version: 1.0
References: <20260217145026.3880286-1-dev.jain@arm.com>
In-Reply-To: <20260217145026.3880286-1-dev.jain@arm.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 25 Feb 2026 23:40:35 -0800
X-Gm-Features: AaiRm53qWWo5MB4ueH2PCIe5gx6Mwj_ETLVvRNUsIKl5chlpjmW_kvj6j6uOl6s
Message-ID: <CAC_TJvfD19E--wyeVyTmp-LP9ffoLQaUHruZARbdes2EnKgptQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
To: Dev Jain <dev.jain@arm.com>
Cc: lsf-pc@lists.linux-foundation.org, ryan.roberts@arm.com, 
	catalin.marinas@arm.com, will@kernel.org, ardb@kernel.org, 
	willy@infradead.org, hughd@google.com, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, =?UTF-8?Q?Mateusz_Ma=C4=87kowski?= <mmac@google.com>, 
	=?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
	Marcin Szymczyk <marcinszymczyk@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 29A6B40010
X-Stat-Signature: epr1xciwgdpnteygkxjuyrjk4dq95nsy
X-Rspam-User: 
X-HE-Tag: 1772091649-692597
X-HE-Meta: U2FsdGVkX19M1pbiCN7wDhPR7dWvDuiI47kY9KpyBTy+YUp5w9URoVZBJXPPzQhIBCaDKPnhBKzj62ecUzQHeY/ENhJCQGXCznVb/lGxGXyYMMszUIRZahOaXyVkksw38DeXDk3eLrCguH62MNX8lAGXbvSsPwXeR8u86HH6BDJcB8lcoF9bwXb/7gS2idNIuh7m2J5A9QorOKtjCkeS/wbxnPRWzFYYCsAAOSdq7OqHVZKj32yNbP0meZIxp7L3Y7dqmzbAVQf4JfRDI7SCtTbu6CrAaa675x+dBTirr8HTYup3BRPmUa2dEn+DpBBFKvsrfkRU1aYp1Mp2hz+YQHo2Ui0SIsu5XkqGQzyKExbeuk2nPPZe4qdJo9CbZ7rvSJAsFyHy2jYcdS7/lInYbnEFf9WI5l4SFtaGsp9xfDSuxjnZlv9BlV6lLKr1hNo0cHhRM5i6MnKFwdDHEiraNGVmHEK9950qoG6A18QwC4rSMC2tKGLhaTw9LhIiWctk6A6ZAmkw5pKwvxqcuiVO8oiFYj8Eqvgzej14sQ4BYxjXNI9p+/JLanz4V1tctgDiwnGhZQqIQsIx6+hhrUv8w8ElwkwETrW8usByH3YOxZtSYph1xMQ9NwS2492J+26aGzEA+amF8qw6BV6fOcFUOO/gSalmPHQlU9vOnlm2SkKthaNVDeyYvLdMTrWAJYBSo14algmd0JdBswIj35j9lAYh1Wk06PbUphRUMZwK80c4dkIAoGSjoy5jPaGomJutejVG/cRJyEthfJ21FcSYvhn57PoeDs/04HlUcpwbxRnTrwvo4V7IKXbGV0rQNcMndENV5EorFtiPTBYbVROBj1LOvYz8sFRdSlhej8cn7kbNJyMerc+aQipuTGE/ZgBa2x8ZdbLCH9zdeGZzIitNdWg7qhYEfSHQF3/szSWzWl4pQzFQCqMq/8hKcoUL/BklXMYs6XbNcpFYOQOKAf1
 scp4UdND
 XXBJEmnLCcrpOGpC7Z0ZVJIsL4+EZsPHIq4rTIhTai1u7ps/wAKcqSKKwHDR2EEA+0dvGPgvthZH7HhWZ8sXfAJQyoLS+7S5jVV1YGpbft3WIIkg8+VZUNoaiylq5Vvhp/vNhSjJ9cmIz/93b804vjoH/mPEBillWljaTyAHloZrHvcmdmMcJjtQPumDloWxSFnau6EDtNDG49+gI/g6RAsZrByVX2vI5EqpWGcZjeWgIXhE4lXiZrLjgD+n/dgKkmOsi2wvE1+YIypo2OoiGCNxrmElv4uc6O0NfzP4MuW1QTcYjpaBbL8n7gDZygPbotL6g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 6:50=E2=80=AFAM Dev Jain <dev.jain@arm.com> wrote:
>
> Hi everyone,
>
> We propose per-process page size on arm64. Although the proposal is for
> arm64, perhaps the concept can be extended to other arches, thus the
> generic topic name.
>
> -------------
> INTRODUCTION
> -------------
> While mTHP has brought the performance of many workloads running on an ar=
m64 4K
> kernel closer to that of the performance on an arm64 64K kernel, a perfor=
mance
> gap still remains. This is attributed to a combination of greater number =
of
> pgtable levels, less reach within the walk cache and higher data cache fo=
otprint
> for pgtable memory. At the same time, 64K is not suitable for general
> purpose environments due to it's significantly higher memory footprint.
>
> To solve this, we have been experimenting with a concept called "per-proc=
ess
> page size". This breaks the historic assumption of a single page size for=
 the
> entire system: a process will now operate on a page size ABI that is grea=
ter
> than or equal to the kernel's page size. This is enabled by a key archite=
ctural
> feature on Arm: the separation of user and kernel page tables.
>
> This can also lead to a future of a single kernel image instead of 4K, 16=
K
> and 64K images.
>
> --------------
> CURRENT DESIGN
> --------------
> The design is based on one core idea; most of the kernel continues to bel=
ieve
> there is only one page size in use across the whole system. That page siz=
e is
> the size selected at compile-time, as is done today. But every process (m=
ore
> accurately mm_struct) has a page size ABI which is one of the 3 page size=
s
> (4K, 16K or 64K) as long as that page size is greater than or equal to th=
e
> kernel page size (kernel page size is the macro PAGE_SIZE).
>
> Pagesize selection
> ------------------
> A process' selected page size ABI comes into force at execve() time and
> remains fixed until the process exits or until the next execve(). Any for=
ked
> processes inherit the page size of their parent.
> The personality() mechanism already exists for similar cases, so we propo=
se
> to extend it to enable specifying the required page size.
>
> There are 3 layers to the design. The first two are not arch-dependent,
> and makes Linux support a per-process pagesize ABI. The last layer is
> arch-specific.
>
> 1. ABI adapter
> --------------
> A translation layer is added at the syscall boundary to convert between t=
he
> process page size and the kernel page size. This effectively means enforc=
ing
> alignment requirements for addresses passed to syscalls and ensuring that
> quantities passed as =E2=80=9Cnumber of pages=E2=80=9D are interpreted re=
lative to the process
> page size and not the kernel page size. In this way the process has the i=
llusion
> that it is working in units of its page size, but the kernel is working i=
n
> units of the kernel page size.
>
> 2. Generic Linux MM enlightenment
> ---------------------------------
> We enlighten the Linux MM code to always hand out memory in the granulari=
ty
> of process pages. Most of this work is greatly simplified because of the
> existing mTHP allocation paths, and the ongoing support for large folios
> across different areas of the kernel. The process order will be used as t=
he
> hard minimum mTHP order to allocate.
>
> File memory
> -----------
> For a growing list of compliant file systems, large folios can already be
> stored in the page cache. There is even a mechanism, introduced to suppor=
t
> filesystems with block sizes larger than the system page size, to set a
> hard-minimum size for folios on a per-address-space basis. This mechanism
> will be reused and extended to service the per-process page size requirem=
ents.
>
> One key reason that the 64K kernel currently consumes considerably more m=
emory
> than the 4K kernel is that Linux systems often have lots of small
> configuration files which each require a page in the page cache. But thes=
e
> small files are (likely) only used by certain processes. So, we prefer to
> continue to cache those using a 4K page.
> Therefore, if a process with a larger page size maps a file whose pagecac=
he
> contains smaller folios, we drop them and re-read the range with a folio
> order at least that of the process order.
>
> 3. Translation from Linux pagetable to native pagetable
> -------------------------------------------------------
> Assume the case of a kernel pagesize of 4K and app pagesize of 64K.
> Now that enlightenment is done, it is guaranteed that every single mappin=
g
> in the 4K pagetable (which we call the Linux pagetable) is of granularity
> at least 64K. In the arm64 MM code, we maintain a "native" pagetable per
> mm_struct, which is based off a 64K geometry. Because of the guarantee
> aforementioned, any pagetable operation on the Linux pagetable
> (set_ptes, clear_flush_ptes, modify_prot_start_ptes, etc) is going to hap=
pen
> at a granularity of at least 16 PTEs - therefore we can translate this
> operation to modify a single PTE entry in the native pagetable.
> Given that enlightenment may miss corner cases, we insert a warning in th=
e
> architecture code - on being presented with an operation not translatable
> into a native operation, we fallback to the Linux pagetable, thus losing
> the benefits borne out of the pagetable geometry but keeping
> the emulation intact.
>
> -----------------------
> What we want to discuss
> -----------------------
>  - Are there other arches which could benefit from this?
>  - What level of compatibility we can achieve - is it even possible to
>    contain userspace within the emulated ABI?
>  - Rough edges of compatibility layer - pfnmaps, ksm, procfs, etc. For
>    example, what happens when a 64K process opens a procfs file of
>    a 4K process?
>  - native pgtable implementation - perhaps inspiration can be taken
>    from other arches with an involved pgtable logic (ppc, s390)?
>

Hi Dev, Ryan,

I'd be very interested in joining this discussion at LSF/MM.

On Android, we have a separate but very related use case: we emulate a
larger userspace page size on x86, primarily to allow app developers
to test their apps for 16KB compatibility using x86 emulators [1].

Similar to your proposed "ABI adapter" layer, our approach works by
enforcing a larger 16KB granularity and alignment on the VMAs to
emulate the userspace page size, while the underlying kernel still
operates on a 4KB granularity [2].

In our emulation experience, we've run into a few specific rough edges:

1. mmap and SIGBUS: Enforcing a larger VMA granularity means that
mapping files can easily extend the VMA beyond the end of the file's
valid offset. When userspace touches this padded area, the 4KB filemap
fault cannot resolve to a valid index, resulting in a SIGBUS that
applications aren't expecting.

2. userfaultfd: This inherently operates at the strict PTE granularity
of the underlying kernel (4KB). Hiding this from a userspace that
expects a 16KB/64KB fault granularity while the kernel still operates
on 4KB granularity is messy ...

3. pagemap and PFN interfaces: As you noted with procfs, interfaces
that expose or consume PFNs are problematic. Userspace tools reading
/proc/pid/pagemap, /proc/kpagecount, /proc/kpageflags,
/proc/kpagecgroup, and /sys/kernel/mm/page_idle/bitmap calculate
offsets based on the userspace page size ABI, but the kernel returns
4KB PFNs which breaks such users.


It would be great to explore if we can align on a unified approach to
solve these.

[1] https://developer.android.com/guide/practices/page-sizes#16kb-emulator
[2] https://source.android.com/docs/core/architecture/16kb-page-size/gettin=
g-started-cf-x86-64-pgagnostic

Thanks,
Kalesh

> -------------
> Key Attendees
> -------------
>  - Ryan Roberts (co-presenter)
>  - mm folks (David Hildenbrand, Matthew Wilcox, Liam Howlett, Lorenzo Sto=
akes,
>              and many others)
>  - arch folks
>

