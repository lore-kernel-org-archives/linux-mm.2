Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D6FF428CA
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 19:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F7826B0005; Wed, 15 Apr 2026 15:27:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CF5B6B0089; Wed, 15 Apr 2026 15:27:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4086B008A; Wed, 15 Apr 2026 15:27:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6726B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:27:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1CEF8C21C1
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 19:27:18 +0000 (UTC)
X-FDA: 84661773756.19.36AA402
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id 223D3C000F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 19:27:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PAQYjvJb;
	spf=pass (imf28.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776281236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQ7kho8nNPiCZN6dDdK/LtHsVWQC24olPeq9GPw1YEU=;
	b=U2STWATmuaO63LLelA1b7KfgvvWeNGiIFLGVZbrRgKjNUfzv/9sh9BK4e6buLIgGPA8ugG
	Lwx8gFdYcsUcB+D+FI45ly8AeeFdUp0rOmbFeLOqh7bdbgN4i5aqfLiqF9IfiEyG4vOfl4
	AbCtQBRG5Ydi2rfOYeDqVDH8NAIhjtY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PAQYjvJb;
	spf=pass (imf28.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776281236; a=rsa-sha256;
	cv=pass;
	b=iu0PF/hVfjKZVmWUNBs4vJ9YwYMyrCU6LLtbPULZmKaAoVxFw7TK0r4Odvl6pxnKrOaD48
	V3uxIEf751XDbffGPjBoLZW1gNolJn/rm/RjM9GaTv/ZDe9q5v65S3amgPz6iuot+DYPRd
	D8cmJhk3nzTbs7y6Qud41nUesgQstls=
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7dbe437b072so3911421a34.2
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:27:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776281235; cv=none;
        d=google.com; s=arc-20240605;
        b=QMadJghSWjsrziQIaUtDRw4/1nRuDA5xZ8cuyelJwT619nFMfkwwKcaaHQqM/iSi/S
         NsLnBWfGlo3H1GZFGGu2TmBgt8qm1n6wC1tziDSQg0PIjYnvdxFePxNYl0Nlso9ANleG
         uzlkHq/3nVbcSjG8cO64w9N0UC9jCY6odAqGkj+oUJAjCVV8798//FwH90SOMG+IW1C5
         khiOTOYryfBQuVtHbJ84gnIkf0acQpQ/3JcfNenG+UJhk8J2X7iiKMZR8HGtBWctPrpI
         5d0YD3fXkSGYkGNM3ZOBDbycaN8LSYCgMACg4NJdONxqt0X4/C2CCfbOxL7RmXp5fXSG
         ncAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WQ7kho8nNPiCZN6dDdK/LtHsVWQC24olPeq9GPw1YEU=;
        fh=Y37ZDAVdQcd1Amfz583O5P0Aqi+3MuPglzRMJBOP16k=;
        b=Apw2f4nDv6ZcmtnkCnY1VrEG7MDsS4Qjf4jUgG50YEGwzi+bxJTaYquzi/0QD3phWp
         iCshsDZMNoUVaANr5Tu9mYdmF0Hpoatdv0nmKg7R8W25pgwVrmteBbM5q3H+stHmKTyt
         9bAfm6PU8mEGHHxCTePEIAz6lDXbLhCeVhSrvWraXDdMNZnBs92Cc8q9pHaQ4gJg6HsV
         n4RfSZM5lD0aoXJ5NDLJN735hFU/a5T19JZegyRN38SBOZg3w1phAephXtdVMxZgCcj4
         CPk93nGnoaQw/FzU9Xe5C2IjnmxkhURZPVqeR0p+0T9NTJB5e8jbva6T8HOC+3FUb5Kq
         FMow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776281235; x=1776886035; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WQ7kho8nNPiCZN6dDdK/LtHsVWQC24olPeq9GPw1YEU=;
        b=PAQYjvJbfu8mDPyIW94ekxKxteCQxBFv5g2AXJOesTAaAMsBkA4m7dKH6/rqF87roh
         QlfXAxAIKKI9qdXVLhzXyJV+QswjutV02Pwouz49lLF9XVafuc3q8BmXw4Aynt/NGBJr
         c/4mBmrUs2kMoPeWfCm+8tRR+HUseJcjlAxiUuapIlBr/TpxEIXdhsikaCwopjR9Z86y
         ozA3ZuimLNA/pE1PTtANzSd9AeshRxuxsVog1OG75WhcdofjXRyAaSKlpAk3noUi+KS9
         YptavLev5Re44MyywzyWKjrBtzyFZwwa8aVg4akbphAjYHytVSYJdJiwR554a/S5t1zm
         SXqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776281235; x=1776886035;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WQ7kho8nNPiCZN6dDdK/LtHsVWQC24olPeq9GPw1YEU=;
        b=lto7jzr/53JzkTksYsKsntsBmuUw+DS6xXE+meZ42nfp8RZ9DvuC7LvwT0V7dXRhef
         +fTFw8Gi1sKgygEn3GvBoOb9m3deAyeDiRiDU0y9f/pnzvaG8rL/y8JhhLWd0padmWJr
         9DiFNdvBYXolGR7lcUzi9LHstOrflRUyuo5i3sqIsZ7IeAlX0Tx47mWFrcprqyHSjgn8
         /XWX9F8QqZyPsc94MTg55xnBzIV2HpBYiYSKguXWior+kDR7LO/fNZjlNBEH6pkea6eJ
         ua4zmnT40OpMMhWI0RvdHCQCjBh0AgvkADktTM3gZhfkQ3sFp7kZrlXZMKUFbxCvHzKS
         oC4g==
X-Forwarded-Encrypted: i=1; AFNElJ///wHGq38gX63EvIlc45IC76Hkb26T/ch2GlZ+44I0W6VE3LLNFwf/pDMcD90NAFg+ECdIJ7xq5A==@kvack.org
X-Gm-Message-State: AOJu0Yz2jcxdf2dKOjjkxsWQW5H4xzPra8UErBxQoe+p3VWv/uYo3rI6
	5MfR+PEQBUcjPJBHFgjVb9RZN1hiXc9sYXkBijp57lBFkU57AAaJt5AU0sZ82hv9ho2E3EbBIDP
	laSodpZntpBKGED0/LIQFsxyAihUCR0I=
X-Gm-Gg: AeBDieu4w8HoJg7wSz+RSAaQ80qp/JH+jU2p4P18WtHQErJFxJPHXp5Gze87+GoK9tX
	88tQCnAakHTrYA25kB1VrAp+ngD8g7SvIDA9GSBVK11sd8sQ0x/G+61B+rd9Qpd3PqLXe+g5Lup
	bTqkIc4XaeD+FpBeDGGdh1kzYQcLDYp5V9odEyRK+sq4Nux0B7nuxPfou5N7xOVsTLggBp8hhOJ
	RleVgp7edT/UnSYgF4QPbXBWBiCKe6Qedj7UQXpumoWg69A+kVu690NFa/peiGE87ujZe9HaauK
	h205ZzCq6Bib29wszg==
X-Received: by 2002:a05:6830:25c5:b0:7d9:f50f:968a with SMTP id
 46e09a7af769-7dc27c66377mr13072583a34.5.1776281234901; Wed, 15 Apr 2026
 12:27:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260323175340.3361311-1-avagin@google.com> <20260323175340.3361311-2-avagin@google.com>
 <acGEonF9I6sPA42B@J2N7QTR9R3.cambridge.arm.com> <acJnOB-rlyt-3jU4@willie-the-truck>
 <CAEWA0a7iR8YHooqXJfhersV6YhAXGMZDUhib3QQH5XGn=KNowA@mail.gmail.com>
 <acarA3sGKY4Acozw@J2N7QTR9R3.cambridge.arm.com> <CAEWA0a7AZiuy1F+0LDxtEtJpdu=zA-RKhPb1wcDMpy2tSMFO5g@mail.gmail.com>
 <adUhbk0sKT0ucWhJ@J2N7QTR9R3>
In-Reply-To: <adUhbk0sKT0ucWhJ@J2N7QTR9R3>
From: Andrei Vagin <avagin@gmail.com>
Date: Wed, 15 Apr 2026 12:27:03 -0700
X-Gm-Features: AQROBzBNtO31xd0yW9r81lEqB1GfFyuOQPPb5LE8m1aTt5Q8NnQOvyvucUSdcQk
Message-ID: <CANaxB-xitpwsU9SmQ1D7q0Jn0Ng1b4WYxzAWF3L-pE+EYzbObg@mail.gmail.com>
Subject: Re: [PATCH 1/4] exec: inherit HWCAPs from the parent process
To: Mark Rutland <mark.rutland@arm.com>
Cc: Andrei Vagin <avagin@google.com>, Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>, 
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>, 
	Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: io3p9krpscjs9mfcsynmr4htqb19u4pk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 223D3C000F
X-HE-Tag: 1776281235-180618
X-HE-Meta: U2FsdGVkX1/RCeN3Q4fpfvRGklCXhTWTR/MXdqmN+aDSJpHJMByqFMlI5Wl6VDDU55u6Lm65ph9iKMpL4PetwU4P+yXfsNVVOGCSELey+Ysr1u5s5j12oUBQrg1+Ybxu+NBy7nuncjgw3SjRRccy7nW1r/30wLGe9U0rtb8PSyvOTx37MmU5bPkaU1Tsgn8IKC73vzxyy/ZB/yGj8KjfkDxiYcNrqDNuN+8vbx1sR8e4XzTWts6Ydc6pcRO7zraulgbX5qxqFwDl8lRW1clZKzPunTniRVB7/WDjZKwUCNq+jRM0/u30s6d3NOvUL7IyXH8mUghJAOCP1d28bt6pZbqs2V4rMBW2b+PGs3LKPsAug2wUwt7rIDcvo5awCs+rUX+Otho3boxGV4w75vPDfADMQIf8pyduUvrjFYV4BJX4e6Np3aAj/XmM1Zp2gmsQ3toO/UjY0qbPdUE8VFSVe7TPueF0bCJmRPLPA+Gif0cgUA75UGIyaS+YM/ywrWwp6ZHLlHMFTl5G7/JJJ9w6sSDy3bRvIm7oLxSkJG5LJntY594seRGggWg1Iu69/esG94Gra8pjUN0UBORYPBKABKOyUU6rBF7Wa+HTn3JEMwnXdzUUt59d8kyW/Ck+xKApzva8cG9et1v+ivKcESQZQ/AxjIprjcNX70jTOg/deVN6CjuLETWABQru3Tq1aO+3b6VQN2x89OTDje4TtAgYmerhUe5KUzSLG9e+NnjYhktKVobzgebThZ/MnR61jaAV82rC4csC4F4/SZck3SEflM9wdLxCWNA/6HEHzFFbzmh5XLWd///jBs3cjswTQPc213vkU/THH1R2aFYuypKBW6jYPYKaMlUOYzWl+tjZF5/pULX+fvqwuHYZ6oFMgTAW0st/BETeNRWIYd1hj3A/gA0timI41ibf3Fld2vXqdRzCNSAGZE55yO9Cm3/t0vtk9GDNN5sKfgvC+LUmodW
 3AIWRkXJ
 a9kRT9GQaAlIkHPvuHRK5NF5Y1P+LS6YyKiqg4PYczupWAgXa3hf7ngbKA3GZ5TQSHKJMzhUTfSDt+unxaWM+yx4wnA8xWZqm6dTrfQISTx7NTNKzRKd8i+K4KEgaN1p6NpC0ol/yJslPMzrMzv2Sv8QNLLyYil8nfvqJcAOmWCEgpWBMg7QSoBtIzGQ7I9svGU9KyNRAIQJUr/Wv/sUIO6CejBJGfeEDyQK/uewNb3YzjsMptI2TxJ0x2rRioWUCqXkbp1fWI5uuk+gF3O2WJzTgg0zRIue/ZvNAuZAva9cfVf7nqPiVQ/zjTp98fRjIZ9B1ia7VQVc12s3Gx03dFCtN4BODbSTaGb0we+ZV6S2Pf4N7mzuDbrSDyXsaP34xzC3IKg/1DyYnIlezG8Oo34TOk9PNf0cZz5jDifT0H9bP2MEuwx/5DHSk42O70ZndxTypu4gVWWyaIN0XV9AYNRAmGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mark,

Thanks for the feedback and sorry for the delay, was on vacation.
Please see my comments inline.

On Tue, Apr 7, 2026 at 8:29=E2=80=AFAM Mark Rutland <mark.rutland@arm.com> =
wrote:
>
> On Fri, Mar 27, 2026 at 05:21:26PM -0700, Andrei Vagin wrote:
> > Hi Mark,
> >
> > I understand all these points and they are valid. However, as I
> > mentioned, we are not trying to introduce a mechanism that will strictl=
y
> > enforce feature sets for every container. While we would like to have
> > that functionality, as you and will mentioned, it would require
> > substantially more complexity to address, and maintainers would unlikel=
y
> > to pick up that complexity.
>
> The crux of my complaint here is that unless you do that (to some
> degree), this is not going to work reliably, even with the constraints
> you outline.
>
> Further, I disagree with your proposed solution of pushing more
> constraints onto userspace (to also consider HWCAPs as overriding other
> mechainsms, etc).
>
> I think that as-is, the approach is flawed.

I would really appreciate it if we could move this conversation toward
how we can make it work.

>
> > Even masking ID registers on a per-container basis would introduce
> > extra complexity that could make architecture maintainers unhappy.
> > There were a few attempts to introduce container CPUID masking on
> > x86_64 in the past.
>
> > In CRIU, we are not aiming to handle every possible workload. Our goal
> > is to target workloads where developers are ready to cooperate and
> > willing to make adjustments to be C/R compatible. The goal here is to
> > provide developers with clear instructions on what they can do to ensur=
e
> > their applications are C/R compatible. When I say "workloads", I mean
> > this in a broad sense. A container might pack a set of tools with
> > different runtimes (Go, Java, libc-based). All these runtimes should
> > detect only allowed features.
>
> I do not think that arbitrary applications (and libraries!) should have
> to pick up additional constraints that are unnecessary without CRIU,
> especially where that goes against deliberate design decisions (e.g.
> features in arm64's HINT instruction space, which are designed to be
> usable in fast paths WITHOUT needing explicit checks of things like
> HWCAPs). Note that those typically *do* have kernel controls.
>
> I think there's a much larger problem space than you anticipate, and
> adding an incomplete solution now is just going to introduce a
> maintenance burden.

I am not adding arbitrary constraints for standard non-CRIU use cases.
Previously, I suggested that standard libraries would need to call prctl
to determine if hwcaps should be used for feature detection.  However,
we can avoid this extra syscall by adding the new HWCAP2_CR bit. Then
libraries will simply check this bit in auxv[AT_HWCAP2], meaning the
overhead for "non-criu" cases is just a single bit check.

As for HINT instructions, there are two class of instructions.

The first one doesn't change a process state and they are not required
any special handling in term of checkpoint/restore. If a process is
checkpointed on a newer cpu, and restore it on an older cpu, the older
hardware will simply skip over that instructions.  The architectural
state (registers, memory) should remain consistent.

The second class such as PAC are instructions that actually change a
process state. These instructions require kernel/userspace coordination.
For example, usage of PAC keys can be controlled from userspace via prctl.
I mean when support for new instructions is implemented in the kernel,
we will need to consider that userspace should be able to control them.

>
> > Returning to the subject of this patchset: this series extends the role
> > of hwcaps. With this change, we would establish that hwcaps is the
> > "source of truth" for which features an application can safely use. Any
> > other features available on the current CPU would not be guaranteed to
> > remain available after migration to another machine.
> >
> > After this discussion, I found that the current version missed one majo=
r
> > thing: there should be a signal indicating that hwcaps must be used for
> > feature detection. Since we will need to integrate this interface into
> > libc, Go, and other runtimes, they definitely should not rely just on
> > hwcaps by default, especially in the early stages. This can be solved
> > via the prctl command.  Libraries like libc would call
> > prctl(PR_USER_HWCAP_ENABLED). If this returns true, the runtime knows
> > that only the features explicitly listed in hwcaps should be used.
>
> I do not think we should be pushing that shape of constraint onto
> userspace.

Look at the previous command.

>
> > You are right, the controlled feature set will be limited to features
> > the kernel knows about. And yes, we would need to report CPU features i=
n
> > hwcaps even if the kernel isn't directly involved in handling them.
>
> To be clear, that is not what I am arguing.
>
> As I mentioned before, the way this works on arm64 is that the kernel
> only exposes what it is aware of, even in the ID regs accessible to
> userspace. We usually *can* hide features, and do that for cases of
> mismatched big.LITTLE, virtual machines, etc.

I understand that. My point was that the kernel would need to report
features in hwcaps even if they don't require specific kernel-side
handling.

>
> > Honestly, I am not certain if this is the "right" interface for that,
> > and I would be happy to consider other ideas. I understand that these
> > hwcaps will not work right out of the box, but we need a way to solve
> > this problem. Having a centralized API for CPU/kernel feature detection
> > seems like the right direction.
>
> I think that for better or worse the approach you are tkaing here simply
> does not solve enough of the problem to actually be worthwhile.

This approach mimics solutions that some CRIU users are already
implementing in userspace, but those only work when the user controls/
recompiles all their libraries. I am open to other ideas, but we need a
path forward.

>
> > As for signal frame size and extended states like SVE/SME, we aware
> > about this problem.  However, it is partly mitigated by the fact that i=
f
> > an application does not use some features, those states are not placed
> > in the signal frame.
>
> That is not true. The kernel can and will create signal frames for
> architectural state that a task might never have touched.
>
> Generally arm64 creates signal frames for features when the feature
> *exists*, regardless of whether the task has actively manipulated the
> relevant state. For example, on systems with SVE a trivial SVE signal
> frame gets created even if a task only uses the FPSIMD registers, and on
> systms with SME a TPIDR2 signal frame gets created even if the task has
> never read/written TPIDR2.
>
> When restoring, an unrecognised signal frame is treated as invalid, and
> we can require that certain signal frames are present.

You are right; that was my mistake. My only explanation for why we don't
see this failure often is that C/R is rarely triggered while a process
is actually
inside a signal handler. This is definitely a problem that still needs
to be solved.

>
> > In the future, when we construct/reload a signal frame, we could look
> > at a process feature set for a process and generate a frame according
> > to those features...
>
> When you say 'we' here, are you talking about within the kernel, or
> within the userspace C/R mechanism?

... within the kernel.

Thanks,
Andrei

