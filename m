Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B014BC531EB
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 23:24:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75E4C6B0005; Thu, 19 Feb 2026 18:24:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70C2C6B0089; Thu, 19 Feb 2026 18:24:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C3D56B008A; Thu, 19 Feb 2026 18:24:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4556F6B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:24:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA72D5BB1A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:24:52 +0000 (UTC)
X-FDA: 84462788424.20.E1C0384
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id CD92F160002
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:24:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="U/2Jh3yS";
	spf=pass (imf08.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771543490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N81mihdf1oXQ5HgGZbFFRvlKM1gdCdpIV1qQLDbyueM=;
	b=cXoH8qjteeqSba/xcfQBOhlT4V+mrw8bu0x+F+aC6cUJ85K18XAKtAl8VsafRi1Pi6FUGW
	L2AZTEPEb1ZTCZqrDaAhwumO3FfA2whCPGOKhB+TlCfBNX7A36swISAjSZfnT6p737X8jR
	2JBhT9okME5jxfLh887TjAVNmwl0j4Y=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="U/2Jh3yS";
	spf=pass (imf08.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771543490; a=rsa-sha256;
	cv=pass;
	b=KKQjhmpsa5Yxw4JUEnAYLU8lV8uZZUtHcJ1YjqVQv9XbqkM627/2+cpiTW859JJ2eKoK6A
	3d9SMAodhO0IoMEHD18m2M5QsPx40XiCE4IqNaD0FgBlbp3OuPttDiTsTieO60IVihTiDf
	igg2zeMPW7D1EWsP0j4DYYwb6eeHhYY=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2aad8123335so16835ad.1
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:24:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771543489; cv=none;
        d=google.com; s=arc-20240605;
        b=htADL09TmZpf32e4CMTQ2RzyLTa0mIPM81d/TuqYsvS+f4ZrOOjtykq8MGSaU7kc4f
         S7GR6oxJbC/1iJi7jcDhskleJ8iE4Vphy02ndURhzk5lwUcZtLdO2/t09Op9yJufibMl
         f/62Umc0RGB1KjxMydFHEqWxP6RiHrpfURcP2ZE3fB72wZH57TfKk64qqiOPZRImEPt5
         AcINbdPXYnnWZkQhfXGie6mR2huBqSRPw5RQUVAWSUM/89ADwbiZOcu/OOiMyWJgFw3R
         w709Sh0S8SkYUImrXZI/fzkOmGTpLZljXTKEmtRofCafuc6/B/huJjsARLh3glFwJkd8
         SwlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N81mihdf1oXQ5HgGZbFFRvlKM1gdCdpIV1qQLDbyueM=;
        fh=6QfKH9jHeDlYrUdTzPcusnHn9Pu3idbgkTlUTxBHtio=;
        b=XVQ+C6Tv7Uq553DDuv2XrWc8wWwn1dqjJQ6MOAeJHMsTLocTVp00A2PW0Sat2sfPEG
         4eV4//1wGCJWJT01k2VeLHJdubZkBbdM3oJQpya85G/IcvAWVQNK/wQJGERjxWy+DqE5
         C0NDQb0XXNNRHU5WrGQ7FBo5qFyk4a1tLPJmGaOooFQAoFRcBHRBCW3lqpXU01DkjVFb
         I91GcQot9SYuitU43g4ToedLvSkMPKHjxWMYBpdwwypyYwbsYCId1m15uCLzHX6x1+qM
         HWqg2hggQ7KrNq5Wm6I846SYCXCAcssVhU4MqGAGR/NhHDT6pTgB5OlnQUcN+dURaBTG
         Wd6A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771543489; x=1772148289; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N81mihdf1oXQ5HgGZbFFRvlKM1gdCdpIV1qQLDbyueM=;
        b=U/2Jh3ySIV7KAHxYgDfynsz5IRzSnRMY4Aei3Q+/s4K3PSAFZC+wU0j/1i8D4BZK42
         QeIEA5tB1S+g89icx+BUhlNPKrnmQdGbFjXSV1UPjbkJ9C8c2BZA/AaAfd87knkSMJSU
         ePJHeHXWzmBTdfE/s0czHUenzUPky3V7M3njLqBsiPT8M3Q//qrwJXxPLTc+tNYuz4c9
         lCz+kDQhjSTUC6dhtGGgHEIiv3E0SMk2HzglgSGJzW3beBPHIjOEP1/uVomvUbzrgHRo
         AgFHb/BZlGscLbTF57XyQNoSJb2KEpu5nhXbq0AHoMXI7NPFAVXH89pAJNMwhVnFG9V2
         tMsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771543489; x=1772148289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N81mihdf1oXQ5HgGZbFFRvlKM1gdCdpIV1qQLDbyueM=;
        b=p7w5aFGHjrNLxOpeQGWtFSBuj0qAjLNwasU6FyfMzxOyRq5+cOAEZSxaGaphNmN+IO
         7KyBBFLub5a8nQkqUF1wworJoxmK5dpDv3WIRS0XbXgkEt1RxXNumnOi6/2f98achI2J
         3R1oWNZ+FZajutQ2SIdcSsevYrFleBRfwh6APf9WwgAvS78t8WfVwfp2O/o7WKgnxWdq
         kyKBOWSG9qpwRY48PMNDzvkwBxck67tJ+ClhfDHrow3zfoFn6NC86wSYt9fiadArFXLl
         U/Vaxye3oJMYXdNebHw7ETl/TSzaOHokGjyH5i08iLVb4BQtCG4uU2ZV5i43ivp60RVk
         f/lw==
X-Forwarded-Encrypted: i=1; AJvYcCVRF3aQBgSaMzwl5tvze/MTWw0NSwO3Njnfm++XO6vsRMXCLB7TCLxDPTCEUZWnUSasQzIVUdE8tA==@kvack.org
X-Gm-Message-State: AOJu0Ywltiz0XyfkzLLtDDqXtSWcrHjTfgs/Xi2GcJkKAQUiayWm6tP8
	O4qzUhwwcKO3JQJdTJKkDz32zjrVE2DRCemQBHJCLsktY9LUvbq4EZBdiG+veoOOssZH3QWSymB
	fQKkSO68t08iGUl2LGNcYRX95wK/sLMdgAo5Vvnzq
X-Gm-Gg: AZuq6aJGf9WoK5p0RO4FTHlQECTwjVfh94350eMScljBrWkHf0T34nQY2hy69UjTD5a
	DqDeciuMUmcFyymYhzSpzFcKPpoBX0ewkRW+UuaeVdv1cr4jKnhaLaqqhCWxRQK7VmBektp4z1K
	WSDGp/ZiDV21PdKB1YEKeNbYpX8SEhb5aQ1JrhlUvounhhCQNx+wDb/VEzsdJ7fCvRMijPKNX5V
	1z28NJrtfu8HM2IFk3PRJp0urTa7C4SDkX0rO1tKG3z24zHg3Q0b03OfurexvW+Q14GUrn8lNhu
	JCdlM3mDqthqgFOL9L2THLLEiDHQpFQGHvOJWLdFjp3qeLMD
X-Received: by 2002:a17:902:d48b:b0:2a0:89b0:71d6 with SMTP id
 d9443c01a7336-2ad6b0bcda3mr317825ad.17.1771543489146; Thu, 19 Feb 2026
 15:24:49 -0800 (PST)
MIME-Version: 1.0
References: <aZcmlIF4bmG0twkp@thinkstation> <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
In-Reply-To: <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 19 Feb 2026 15:24:37 -0800
X-Gm-Features: AaiRm506iCuwBzt769z6f8HgaTqphlJIMr6ZOf2foqNwbaXvYNvrCMUTeVEWOk0
Message-ID: <CAC_TJvdUoBmZNj68Yghmwhr4W0930s+p7UkAtSj5x5XoGAHhwg@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
	x86@kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>, android-mm <android-mm@google.com>, 
	=?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
	=?UTF-8?Q?Mateusz_Ma=C4=87kowski?= <mmac@google.com>, 
	Steven Moreland <smoreland@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: j8hrrekj6h3eakr9kqct5b5n1wowdwdg
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: CD92F160002
X-HE-Tag: 1771543490-204682
X-HE-Meta: U2FsdGVkX19zrFsL5Rqw+psiE7pKJAFaWlH0KmOU4o87WUNQy3HjvvMOpmDH2/Q23IQhY8QJ8dHqzZbgcMT0CF3Psf2XsJQeVMFRXCZ+agzTRBuMJx5/dcqa9phE9OSe/AjlKtyQZtTCgGKEgJIRrZ9EOoEVG6aNJQj0ZzjYpPbqDULzJpla3YGFwPNb/iqroDHovw1oMSsD9MrE8rsDNd6hrRZxGhVXpudfJWzun/3xlYqOkIym2mCDQsnsylqU4TcKUcO8uVYGnpGT44E+Z1tB3sVsB5YtGBApsYdB1zeoUJ6tUbEBm+rt8glA0avDiAg0Zl/8R0RZrw960JV9C5EuCkPRaRZMpylU6Z/6Zq4O0MtF1msRh69cK4krcWW8GfxjnPmHSTFRhrBjmeURKGonHp3DFX2EooDgOX1YwNG1Tdnpzcs5eXZbcInUfPCm+UUaYhfB96vS/a3+vh6q8waZgK079CpxNqimoGIDi9EKNAjOLHHlsadWCwMBbQmd5kf4tEk3OaPBYpF8JN5Vc5o6/X74n7uTzM2zozgNmJKtC2MlddV/5pxOVJO7idsPeIl2tORaH1n/N29xd09ln5d9427zz6ILttf7CUh3iDDnZ02AZQmD3hsVbwjpJmUVapRvMKgmFQsrFPdFy+xMf4JM3uZg3dAt4mBhkx0dRJ2C4oVcAsJ0nWkSEMiWQWWC5ZgVMwljhMM0YCpwg0eRGWJY+ZKRKE+01ps4cYbv1Z0giOXVGDKZyIquKQxi9vYlcDrkPXwqpW7SWwMch0cpRYLpyvVZLh+CNqV7FiXMdYlj1JXyqj0Q9e6pH2DCRJb3hpYRdVdZhh8CizTL6apQG842lRHmcAocf9EAOE5SpDKDrla/uYVLNEpMUCkrnmm4CitIvvDeAp9CRmuMz54IDbS5OrCsHLu4B8bcVACjs3O/4jY5MKALvoWjpeFAj75TiuAs/Zpx+OPMrJDe2tW
 zlUghZOP
 h4SH+/KC/djGM2YeLEIDWiY6OeTuu2qgdCppbfstUszKht+rEv9IMJTfxK/hd+FatKR86pi0TH6dl+OiK8TArTkuFt0v7Tx1oE1lGFwjK6sYPmzNKKuaKWHTClPCLqQcc5HKKTulfMuY6frC39CV4KW/gM44YNRI41+iIruEaqSB80afG5PBdZdrM2fyJZmJzOZkAZQ+UMi3WWTIHjIhYwBu1X/b9ByPY/ooBOdoWG/Lf/j/nc8h08TJLQLYIwsc+J0iIOkMwhFfLsqwb9tlyNJvbjN5SgH9jyRPP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 7:39=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/19/26 16:08, Kiryl Shutsemau wrote:
> > No, there's no new hardware (that I know of). I want to explore what pa=
ge size
> > means.
> >
> > The kernel uses the same value - PAGE_SIZE - for two things:
> >
> >    - the order-0 buddy allocation size;
> >
> >    - the granularity of virtual address space mapping;
> >
> > I think we can benefit from separating these two meanings and allowing
> > order-0 allocations to be larger than the virtual address space covered=
 by a
> > PTE entry.
> >
> > The main motivation is scalability. Managing memory on multi-terabyte
> > machines in 4k is suboptimal, to say the least.
> >
> > Potential benefits of the approach (assuming 64k pages):
> >
> >    - The order-0 page size cuts struct page overhead by a factor of 16.=
 From
> >      ~1.6% of RAM to ~0.1%;
> >
> >    - TLB wins on machines with TLB coalescing as long as mapping is nat=
urally
> >      aligned;
> >
> >    - Order-5 allocation is 2M, resulting in less pressure on the zone l=
ock;
> >
> >    - 1G pages are within possibility for the buddy allocator - order-14
> >      allocation. It can open the road to 1G THPs.
> >
> >    - As with THP, fewer pages - less pressure on the LRU lock;
> >
> >    - ...
> >
> > The trade-off is memory waste (similar to what we have on architectures=
 with
> > native 64k pages today) and complexity, mostly in the core-MM code.
> >
> > =3D=3D Design considerations =3D=3D
> >
> > I want to split PAGE_SIZE into two distinct values:
> >
> >    - PTE_SIZE defines the virtual address space granularity;
> >
> >    - PG_SIZE defines the size of the order-0 buddy allocation;
> >
> > PAGE_SIZE is only defined if PTE_SIZE =3D=3D PG_SIZE. It will flag whic=
h code
> > requires conversion, and keep existing code working while conversion is=
 in
> > progress.
> >
> > The same split happens for other page-related macros: mask, shift,
> > alignment helpers, etc.
> >
> > PFNs are in PTE_SIZE units.
> >
> > The buddy allocator and page cache (as well as all I/O) operate in PG_S=
IZE
> > units.
> >
> > Userspace mappings are maintained with PTE_SIZE granularity. No ABI cha=
nges
> > for userspace. But we might want to communicate PG_SIZE to userspace to
> > get the optimal results for userspace that cares.
> >
> > PTE_SIZE granularity requires a substantial rework of page fault and VM=
A
> > handling:
> >
> >    - A struct page pointer and pgprot_t are not enough to create a PTE =
entry.
> >      We also need the offset within the page we are creating the PTE fo=
r.
> >
> >    - Since the VMA start can be aligned arbitrarily with respect to the
> >      underlying page, vma->vm_pgoff has to be changed to vma->vm_pteoff=
,
> >      which is in PTE_SIZE units.
> >
> >    - The page fault handler needs to handle PTE_SIZE < PG_SIZE, includi=
ng
> >      misaligned cases;
> >
> > Page faults into file mappings are relatively simple to handle as we
> > always have the page cache to refer to. So you can map only the part of=
 the
> > page that fits in the page table, similarly to fault-around.
> >
> > Anonymous and file-CoW faults should also be simple as long as the VMA =
is
> > aligned to PG_SIZE in both the virtual address space and with respect t=
o
> > vm_pgoff. We might waste some memory on the ends of the VMA, but it is
> > tolerable.
> >
> > Misaligned anonymous and file-CoW faults are a pain. Specifically, mapp=
ing
> > pages across a page table boundary. In the worst case, a page is mapped=
 across
> > a PGD entry boundary and PTEs for the page have to be put in two separa=
te
> > subtrees of page tables.
> >
> > A naive implementation would map different pages on different sides of =
a
> > page table boundary and accept the waste of one page per page table cro=
ssing.
> > The hope is that misaligned mappings are rare, but this is suboptimal.
> >
> > mremap(2) is the ultimate stress test for the design.
> >
> > On x86, page tables are allocated from the buddy allocator and if PG_SI=
ZE
> > is greater than 4 KB, we need a way to pack multiple page tables into a
> > single page. We could use the slab allocator for this, but it would
> > require relocating the page-table metadata out of struct page.
>
> When discussing per-process page sizes with Ryan and Dev, I mentioned
> that having a larger emulated page size could be interesting for other
> architectures as well.
>
> That is, we would emulate a 64K page size on Intel for user space as
> well, but let the OS work with 4K pages.
>
> We'd only allocate+map large folios into user space + pagecache, but
> still allow for page tables etc. to not waste memory.
>
> So "most" of your allocations in the system would actually be at least
> 64k, reducing zone lock contention etc.
>
>
> It doesn't solve all the problems you wanted to tackle on your list
> (e.g., "struct page" overhead, which will be sorted out by memdescs).

Hi Kiryl,

I'd be interested to discuss this at LSFMM.

On Android, we have a separate but related use case: we emulate the
userspace page size on x86, primarily to enable app developers to
conduct compatibility testing of their apps for 16KB Android devices.
[1]

It mainly works by enforcing a larger granularity on the VMAs to
emulate a userspace page size, somewhat similar to what David
mentioned, while the underlying kernel still operates on a 4KB
granularity. [2]

IIUC the current design would not enfore the larger granularity /
alignment for VMAs to avoid breaking ABI. However, I'd be interest to
discuss whether it can be extended to cover this usecase as well.

[1]  https://developer.android.com/guide/practices/page-sizes#16kb-emulator
[2] https://source.android.com/docs/core/architecture/16kb-page-size/gettin=
g-started-cf-x86-64-pgagnostic

Thanks,
Kalesh




>
> --
> Cheers,
>
> David
>

