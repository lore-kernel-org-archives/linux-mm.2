Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87B4AFD9E39
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 05:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 763506B0005; Fri, 27 Feb 2026 00:11:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739B86B0088; Fri, 27 Feb 2026 00:11:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60E256B0089; Fri, 27 Feb 2026 00:11:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 446A86B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:11:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E24CC1EAB
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 05:11:38 +0000 (UTC)
X-FDA: 84489063876.19.56C4165
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9767340003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 05:11:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IDH1BipB;
	spf=pass (imf04.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772169096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdg4HeYILg9vH96eeWfpQ6Yd+D1ghXXUjeqaDg3EADI=;
	b=1i0WhynUxlBM2bT15l8PyXZC4KjPpwtJxZYstpv8C5duj3XeHgjnOSnLYb3DV5hwHsXJsY
	20/d+s7cWpvl3jJvf8Zghk3Hk+Mm/rFNEM9fmn5Gv3mC4JkqDFxK+7jRrhLMPIKTWvP5uu
	M79iuKOPVPBc33mVQwExWaRhY8QXRnA=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IDH1BipB;
	spf=pass (imf04.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772169096; a=rsa-sha256;
	cv=pass;
	b=W/uA8tUftmz8u9A3ALRVzg31mDWAU62ZCsOx4/w6pxpAcp/gL7HA3j5KD5N6Mv+6UANmIn
	8lf+nE4dmUA1eTVGuQV2UPPhze4Y1lnF10FPEyjgDGq53Z8i0/oLYhh4VsomX91V0wCo1n
	+9M+cbkLcaxyAHHkMl47QfG6DQ6E2IE=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ada9e4ea32so34745ad.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:11:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772169095; cv=none;
        d=google.com; s=arc-20240605;
        b=IZghOno9AmkkU9WAOvkyQmfBPNMeZk36NnbVdIsxyTSiFI7BM6H66+BLp3u0CcqqkG
         Nyp7q0+a7YgIZSDa0g+AAa9X3pAx0kkJah4OeFTvdLZ6afZnkZ3934Fmo6dvFKA4eIDn
         MFfXI7VZdRCemSwm9TKFq48znSlrVG1AMM/k6U2kOxmdIowOj99+IOhDidJqY9ZN5/1d
         9/msf21qjZh6UIioF0+cyvV6I3a4DlvpkWbHhkdJuoFLDN9aCeDBWUW+8a7/zSbzXBv1
         hzYmSr0GfJl+RSliaJ1s0Fxk6iDTlnHc2fW1iRHnyKGUBvdNegjPEKHag75Zl3ZNryUd
         Kavw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kdg4HeYILg9vH96eeWfpQ6Yd+D1ghXXUjeqaDg3EADI=;
        fh=2MQ6A523fME0MLr8fr6q5HB5l7MurwOMOdOtBomrL50=;
        b=ZiHgZdxYN189ZoJTi6EBAZ8ZbIyEtxpPewmP2bPQY+8+DEe0t1mi5jdp9lllr/VZap
         uuCpsLuVJV4oBlABnpUqvJQMaF217Bx+DrL2lT2sOTtHJVbxv9VfQ3md2on3XJ4CVD/y
         JPVoE0tMwcVgAyzbIBB8aPmU44xJ9+WJd2jsSg4G1TQABYgvsykBjCCt5nKG0FMYglrP
         IrIme7O1TDhJDVOdJBS+SZxzIp+BoJ2tJRAJ8ilehJFs74w3ejeeM2rM4YAIYxnyPrCS
         B83vTgW2EQZ5P1cT6N5V3hFljnO7hyoNdyfely55eGN5di5OnYjO5DSQcMrzMshms+LH
         qLdw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772169095; x=1772773895; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kdg4HeYILg9vH96eeWfpQ6Yd+D1ghXXUjeqaDg3EADI=;
        b=IDH1BipBTkBW1jobxah8QHMPiNqgqpFqJDjb4ylKGkQ7KVhBewd5WF8ywKjUIZjurQ
         6KqMQBhiHfgCSUrCm5Rxmyqth+kaZldbNt5gpkyL1co/fXWoU6pipKfsvm+KN7t0PfUi
         NoUAcKBVhN0bskYABmrDK11f2HfEF8sdUbhNfpzIh5WSsk/GeWBkj8dOv8Ze4ct+9Vmu
         8begaJEV+hi4PDS1IHT6AEnJ/XfjhtrX1QF7HXnGuh1Mnslffl8fkddEekVG1CPEWEeJ
         9UYTNfnHecMzfAOvg8gs6jYeyXU31Kv2yrm6lREwKPQg4O7lWTC9y0dZo7/9TKRtVpDH
         VQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772169095; x=1772773895;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kdg4HeYILg9vH96eeWfpQ6Yd+D1ghXXUjeqaDg3EADI=;
        b=wIhlkj03EU01RAANk/T0Xtp1NshDfSQ3JkLxlyyD9dlVPXMDA84ptJH7duvzQehpVq
         FD2e1aaHYmaec3XWBS+m0pqAXbeXyKQ2iCV0IXkwdwXs4ZMGe9NZY+zISx4E7DUhUXvR
         +q4N/3H0fZm6f4pxD7S2D61gOBNJ89XFBz1qbKMrgfwrsBbZ1jqh+0PzjessfCSyMXcX
         MrfAJCe8mFWdez1lw3qTQh9+PX4Zym5nk4J9IktjNcYouFFl5jQ+gp+8PsdR/XAcLMoc
         0D0EWwcDXDuVWJwY6n33yDgAHw3mhnnPAj2LSL1NP1kFU3L+Bk6jXiidlRCkf4inxb3/
         Lybw==
X-Forwarded-Encrypted: i=1; AJvYcCWQDG3nvFEmQZ4fD3tLfW7U9weP2HCEgvvTUxICQvnRMe3hqka3Z/w6YA49Wg8NQPmREH33k/FrXA==@kvack.org
X-Gm-Message-State: AOJu0YxzPGp1HxWr4Oh0AmbJlOJyT8TYNRC1if1h4Nc+4oACa95F/y1b
	SLiUqd/TXnuq/vhInfK3gxGYfSB9h5Lh+3wj3+W2xsGxu8tcecieV5S5QTq6wglxQyhM9WEBg9d
	yUd4yqPWPm3Rv3KtWolvdOEV0uA+JUU+HypCF/b9N
X-Gm-Gg: ATEYQzwIUGtGirOepOYnvAI/2DeVewp95NN64Nw1u8KzyaYztYp0P239bIjYSE2HPdW
	VKHvAJatj7DNWAgZgQehSwrMKE4ssOZLE6zzmyRwwYqtE4sl44doF/N2xyG+MA54KW0uPesd+/h
	nTxC85KvtIm0Bu/N9hrYlUUkU9c1FCeYnvYAGrM7ZkhKGIYQatrGds3vfH8x1gM3OhLUxGP1L83
	EsdfrIGgpt9LVA9ZjZ/9p7c+VFHDrKy4eqjYcq9R7IbTR6F6CGJ4rw6mzp+KS6kzK2/GfBSN8x/
	3sWHh9bu2JqSpEV5/pKhJ+px2fI8S2vZlMjTJEIX
X-Received: by 2002:a17:903:1a4c:b0:2a9:5c9d:d1b with SMTP id
 d9443c01a7336-2adff4fa1f5mr4231785ad.9.1772169094728; Thu, 26 Feb 2026
 21:11:34 -0800 (PST)
MIME-Version: 1.0
References: <20260217145026.3880286-1-dev.jain@arm.com> <CAC_TJvfD19E--wyeVyTmp-LP9ffoLQaUHruZARbdes2EnKgptQ@mail.gmail.com>
 <e1858dc5-6526-4aac-8392-f4f2e19da1bc@arm.com>
In-Reply-To: <e1858dc5-6526-4aac-8392-f4f2e19da1bc@arm.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 26 Feb 2026 21:11:22 -0800
X-Gm-Features: AaiRm50D65ghbF7RzaRcTJH7irRq9mkR44Hj5G0F0y3SYG8dtuk-hDxr7CftTvE
Message-ID: <CAC_TJvcvybHqVAV8nAHEvN-UXUQ5hMjZx+_b2W3MY=xgqR9=6w@mail.gmail.com>
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
X-Stat-Signature: knaxdb4jjf6tx7poyh3q1tbqai916bo1
X-Rspamd-Queue-Id: 9767340003
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772169096-457208
X-HE-Meta: U2FsdGVkX19++gfJCeYw4cjs6Fh5leCWLZTfY31sCoBhZj4cIZOyMf76EMqx1Ha6Jbcy2+QWcmKQ/11WppaqxFZBGW09KWGH0Nb48MWwAq91rIXuIDcvbieLp1sWc2ADuUae6gDkCwUnvg2fOjuixk82tjT7L7zColWMaDU6iNdj1nyFD+dwML4MpVsu/91PHv37h/O08e2rcr65DiryFELkTnWhUYYN30Chnj0ecY5D305cbB7hWM/NCiyvCL9sHtm9m+XsAduLXINrUJN4C1/cKNnF0lnwzLTdcA7eAWaLAExmL+LrlyESKHmEtRrKVnMgDLe6lZcwbbpv5Uz4pvPWnjovfXq/7LpM9ooBMot8jyai+A0TAdfigQgMVm7T6Zpgmc9lCAAFByONcIfdqRvV4Pi6BNKqdf4FGm7kWLIxgITAiLsHKUixfS3dWh5UcwvwiFD3ojWi+2weBb7tFllcpHKt/uqGOdM6ms1D8ITdCVFNSErEqXl8gR6hEfDZcQThcTeh9gpucw/GakfcsLE4Zl+xXcb9iE9dKsvX11Ccu/BwgU7Czwd4Rln0GioLnUdkVX5gViYmPxtqYYvwdlP5VDYQ3VrBgRpeaSuwQ+Uxwp4jwjMjA7v/T/NuDaKAdZXu578u8ZMOa8yq1C1ZUAOyPhxhHiYz1cgcsuwG1KwnVrB8tQZ3teTPpNIKWsym7clYL+7l5keb/bTzZFO7YpoRdEggG94fEbPvG1QNyDcOVdqf087UoN3oduDAwA0e2iOUzQ5Rihsl2Ui2msozaZQ7Qkbq7woiX+fl4J1S+S2zKWioeY/T8KsAsYA0D2HqYY60m92QeGMctZzvYh0x6Ud6wIBbiHOYWMBR/IVNzPNuxUEc7/DIfENZYEjqHUlvyFBf+3II+EwOijKA+eXmk8awHWHy1tyi9x9w9tVT8XRi4cyJOVWZGiwjNDJi0pd9Sj70j8J5Gspywo8UWVb
 zIUfydp2
 Nyq1cusIGe/fvkSwmhblB2zou0f0D9+A2j3Sf+PlDkA4azB+aWIm2Mkp9+OiKRCWJLMPejKK449Lb7cq+AmdW52n+vBqtZZfcWUK/Z4mMPy6VL9quS2nUaTMlctvB33gW+XQtqwJv3JVbKB6IOICJjOKedV7ns5K9E9ae8RBhNBo4tf3yH0awUGgq+n/9PmqOiqIFYgJxrwBVks1p3S9Zrf1dWFUN1i2KGqywhjnjxUMrcSmWDSZ5Yss1W/8yCMEeVbpbq2vashUzbrTg/KdjUkNOnMtsDEQC/qpdHT5960AZ65D5Fib+v67LRJVdMoE9EKoi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 12:45=E2=80=AFAM Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 26/02/26 1:10 pm, Kalesh Singh wrote:
> > On Tue, Feb 17, 2026 at 6:50=E2=80=AFAM Dev Jain <dev.jain@arm.com> wro=
te:
> >>
> >> Hi everyone,
> >>
> >> We propose per-process page size on arm64. Although the proposal is fo=
r
> >> arm64, perhaps the concept can be extended to other arches, thus the
> >> generic topic name.
> >>
> >> -------------
> >> INTRODUCTION
> >> -------------
> >> While mTHP has brought the performance of many workloads running on an=
 arm64 4K
> >> kernel closer to that of the performance on an arm64 64K kernel, a per=
formance
> >> gap still remains. This is attributed to a combination of greater numb=
er of
> >> pgtable levels, less reach within the walk cache and higher data cache=
 footprint
> >> for pgtable memory. At the same time, 64K is not suitable for general
> >> purpose environments due to it's significantly higher memory footprint=
.
> >>
> >> To solve this, we have been experimenting with a concept called "per-p=
rocess
> >> page size". This breaks the historic assumption of a single page size =
for the
> >> entire system: a process will now operate on a page size ABI that is g=
reater
> >> than or equal to the kernel's page size. This is enabled by a key arch=
itectural
> >> feature on Arm: the separation of user and kernel page tables.
> >>
> >> This can also lead to a future of a single kernel image instead of 4K,=
 16K
> >> and 64K images.
> >>
> >> --------------
> >> CURRENT DESIGN
> >> --------------
> >> The design is based on one core idea; most of the kernel continues to =
believe
> >> there is only one page size in use across the whole system. That page =
size is
> >> the size selected at compile-time, as is done today. But every process=
 (more
> >> accurately mm_struct) has a page size ABI which is one of the 3 page s=
izes
> >> (4K, 16K or 64K) as long as that page size is greater than or equal to=
 the
> >> kernel page size (kernel page size is the macro PAGE_SIZE).
> >>
> >> Pagesize selection
> >> ------------------
> >> A process' selected page size ABI comes into force at execve() time an=
d
> >> remains fixed until the process exits or until the next execve(). Any =
forked
> >> processes inherit the page size of their parent.
> >> The personality() mechanism already exists for similar cases, so we pr=
opose
> >> to extend it to enable specifying the required page size.
> >>
> >> There are 3 layers to the design. The first two are not arch-dependent=
,
> >> and makes Linux support a per-process pagesize ABI. The last layer is
> >> arch-specific.
> >>
> >> 1. ABI adapter
> >> --------------
> >> A translation layer is added at the syscall boundary to convert betwee=
n the
> >> process page size and the kernel page size. This effectively means enf=
orcing
> >> alignment requirements for addresses passed to syscalls and ensuring t=
hat
> >> quantities passed as =E2=80=9Cnumber of pages=E2=80=9D are interpreted=
 relative to the process
> >> page size and not the kernel page size. In this way the process has th=
e illusion
> >> that it is working in units of its page size, but the kernel is workin=
g in
> >> units of the kernel page size.
> >>
> >> 2. Generic Linux MM enlightenment
> >> ---------------------------------
> >> We enlighten the Linux MM code to always hand out memory in the granul=
arity
> >> of process pages. Most of this work is greatly simplified because of t=
he
> >> existing mTHP allocation paths, and the ongoing support for large foli=
os
> >> across different areas of the kernel. The process order will be used a=
s the
> >> hard minimum mTHP order to allocate.
> >>
> >> File memory
> >> -----------
> >> For a growing list of compliant file systems, large folios can already=
 be
> >> stored in the page cache. There is even a mechanism, introduced to sup=
port
> >> filesystems with block sizes larger than the system page size, to set =
a
> >> hard-minimum size for folios on a per-address-space basis. This mechan=
ism
> >> will be reused and extended to service the per-process page size requi=
rements.
> >>
> >> One key reason that the 64K kernel currently consumes considerably mor=
e memory
> >> than the 4K kernel is that Linux systems often have lots of small
> >> configuration files which each require a page in the page cache. But t=
hese
> >> small files are (likely) only used by certain processes. So, we prefer=
 to
> >> continue to cache those using a 4K page.
> >> Therefore, if a process with a larger page size maps a file whose page=
cache
> >> contains smaller folios, we drop them and re-read the range with a fol=
io
> >> order at least that of the process order.
> >>
> >> 3. Translation from Linux pagetable to native pagetable
> >> -------------------------------------------------------
> >> Assume the case of a kernel pagesize of 4K and app pagesize of 64K.
> >> Now that enlightenment is done, it is guaranteed that every single map=
ping
> >> in the 4K pagetable (which we call the Linux pagetable) is of granular=
ity
> >> at least 64K. In the arm64 MM code, we maintain a "native" pagetable p=
er
> >> mm_struct, which is based off a 64K geometry. Because of the guarantee
> >> aforementioned, any pagetable operation on the Linux pagetable
> >> (set_ptes, clear_flush_ptes, modify_prot_start_ptes, etc) is going to =
happen
> >> at a granularity of at least 16 PTEs - therefore we can translate this
> >> operation to modify a single PTE entry in the native pagetable.
> >> Given that enlightenment may miss corner cases, we insert a warning in=
 the
> >> architecture code - on being presented with an operation not translata=
ble
> >> into a native operation, we fallback to the Linux pagetable, thus losi=
ng
> >> the benefits borne out of the pagetable geometry but keeping
> >> the emulation intact.
> >>
> >> -----------------------
> >> What we want to discuss
> >> -----------------------
> >>  - Are there other arches which could benefit from this?
> >>  - What level of compatibility we can achieve - is it even possible to
> >>    contain userspace within the emulated ABI?
> >>  - Rough edges of compatibility layer - pfnmaps, ksm, procfs, etc. For
> >>    example, what happens when a 64K process opens a procfs file of
> >>    a 4K process?
> >>  - native pgtable implementation - perhaps inspiration can be taken
> >>    from other arches with an involved pgtable logic (ppc, s390)?
> >>
> >
> > Hi Dev, Ryan,
> >
> > I'd be very interested in joining this discussion at LSF/MM.
>
> Thanks Kalesh for your interest!
>
> >
> > On Android, we have a separate but very related use case: we emulate a
> > larger userspace page size on x86, primarily to allow app developers
> > to test their apps for 16KB compatibility using x86 emulators [1].
> >
> > Similar to your proposed "ABI adapter" layer, our approach works by
> > enforcing a larger 16KB granularity and alignment on the VMAs to
> > emulate the userspace page size, while the underlying kernel still
> > operates on a 4KB granularity [2].
> >
> > In our emulation experience, we've run into a few specific rough edges:
> >
> > 1. mmap and SIGBUS: Enforcing a larger VMA granularity means that
> > mapping files can easily extend the VMA beyond the end of the file's
> > valid offset. When userspace touches this padded area, the 4KB filemap
> > fault cannot resolve to a valid index, resulting in a SIGBUS that
> > applications aren't expecting.
>
> You did mention in the other email the links below, and I went ahead
> to compare :) I was puzzled to see some sort of VMA padding approach
> in your patches. OTOH our approach pads anonymous pages. So for example,
> if a 64K process maps a 12K sized file, we will map 52K/4K =3D 13 anonymo=
us
> pages into the 64K-aligned VMA.
>
> Implementation-wise, we detect such a condition in filemap_fault
> and return VM_FAULT_NEED_ANONPAGE, and redirect that to do_anonymous_page
> to map 4K pages.

Ah, the VMA padding patches you saw are actually for a different feature.

To handle the file mapping overhang, we currently insert a separate
anonymous VMA to cover the remainder of the emulated page range. Tough
I think your approach of returning VM_FAULT_NEED_ANONPAGE to fault
anonymous pages without needing to manage extra VMAs is a much cleaner
design :)

Thanks,
Kalesh

>
> >
> > 2. userfaultfd: This inherently operates at the strict PTE granularity
> > of the underlying kernel (4KB). Hiding this from a userspace that
> > expects a 16KB/64KB fault granularity while the kernel still operates
> > on 4KB granularity is messy ...
>
> Indeed. We will have to fault in 16 4K pages.
>
> >
> > 3. pagemap and PFN interfaces: As you noted with procfs, interfaces
> > that expose or consume PFNs are problematic. Userspace tools reading
> > /proc/pid/pagemap, /proc/kpagecount, /proc/kpageflags,
> > /proc/kpagecgroup, and /sys/kernel/mm/page_idle/bitmap calculate
> > offsets based on the userspace page size ABI, but the kernel returns
> > 4KB PFNs which breaks such users.
> >
> >
> > It would be great to explore if we can align on a unified approach to
> > solve these.
> >
> > [1] https://developer.android.com/guide/practices/page-sizes#16kb-emula=
tor
> > [2] https://source.android.com/docs/core/architecture/16kb-page-size/ge=
tting-started-cf-x86-64-pgagnostic
> >
> > Thanks,
> > Kalesh
> >
> >> -------------
> >> Key Attendees
> >> -------------
> >>  - Ryan Roberts (co-presenter)
> >>  - mm folks (David Hildenbrand, Matthew Wilcox, Liam Howlett, Lorenzo =
Stoakes,
> >>              and many others)
> >>  - arch folks
> >>
>

