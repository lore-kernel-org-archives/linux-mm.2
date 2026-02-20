Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81BE6C561E6
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 19:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870C66B0088; Fri, 20 Feb 2026 14:22:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4C16B0089; Fri, 20 Feb 2026 14:22:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D71E6B008A; Fri, 20 Feb 2026 14:22:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 46F0E6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 14:22:08 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B3D2E1B5142
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:22:07 +0000 (UTC)
X-FDA: 84465805494.14.2A8E76D
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id A9D8C180014
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:22:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1qvngr7m;
	spf=pass (imf24.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771615325; a=rsa-sha256;
	cv=pass;
	b=njjuinUskHdyB+7NSqPseQLSnnhn0N38yXbsqELYC+yxck5K9sd+Hz4xtM8uWlMMKaqyuq
	x92n+CBa7c+1eQESjKM38E5dj3lwZncknjpY0ydv89Pj+ouZyrNDirNnNNd/84rchz36zt
	Ah28RBpwtrIWvJutbyknoKU/5tElvkE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1qvngr7m;
	spf=pass (imf24.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771615325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sHqh7tr0ekv0Y3NGHjbawmsrB+Z/ZMWh4LwTW562Zfs=;
	b=T0raH7E/u8rDgtAuW9y9L1K+qkhboZpTjkxnpuIdzXxCCeCjIlZqyXThsC0NasbMrbT5qy
	GIwC3HseL+ZwKob6vf/mdZ373Ietq5VL94TNBb7AjRBycx/KX5srLkBV+y+A6eE6uuWEnx
	UbH2dnI2jxZ9/BTILqaVuSMN/C5zCTM=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a964077671so10095ad.0
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:22:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771615324; cv=none;
        d=google.com; s=arc-20240605;
        b=XFXCtgPd5lgkGU+DnpgR8FsSW+4zNHz0M0McVu4dGBjLFP54lT/CHjnR/zAaDDhUV/
         0r1o2+MZXZtde6F+NQwgDBKicBiAvm/e/iKoPARiyGOCsuqPpOUxmueNdSzgbBm6KQvX
         2PxQezO3ygSh+OxrOVHAtgeb7es/Ks/gdrJgs2YSsPRSONR2QYSMr3fJ8X1rpbxQ99VY
         vpYso0pdbqBV5T9Luc5G2LQ0Zbt8O8hBO3m7QAM1qCeXZWeOhA1qtCWzW/ip4DL9Sy5N
         Mp1y3kBxAXCEj6aypQrudQdHH/jOyPdQsq9cXJkLzQyuUCb10g9/JPdxH0yK+PeuGL4O
         vbDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sHqh7tr0ekv0Y3NGHjbawmsrB+Z/ZMWh4LwTW562Zfs=;
        fh=6qb8s4UWkTLxhJNqLmSHHdP93wkW3T1cgKEgRnYoSJo=;
        b=WMNFovo/UpTBNgr+WKgZwIK9ka+dRG9XEzpc0/fWxKmghdycoZcZnUmx7Cn5p5wpKS
         X+fwKKSHuUNzQzDkLBUQNCKU0SH2jgpLdifNUg9o53/T6Ns3zbNUwYdZm1MbS/xK3Ppa
         eq6pbT7JYAYQcQpQlWPujQQHTBjSNCUtO/Rs2KiqOvYpTu132ZdaOl5M0c5HuvpoNP5V
         grxu6tZqpyVMIJ3U3Ug/jBnPRC6D04cAHA4niv2MgEnc3Lz7y2P0eUM8ULL9B8RgfO/1
         WmNh2sjB90uqYXQJIC3bOcUKi2xXTf+nxf2AN6b1nFvdfvlKlbjI0nX7FoHjd99ifu3I
         DGJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771615324; x=1772220124; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sHqh7tr0ekv0Y3NGHjbawmsrB+Z/ZMWh4LwTW562Zfs=;
        b=1qvngr7m29LPozUTzyCAatS0da1KX32jCL9V3WljmaQuCaLM5XUD4hKfWCZ5URYcxI
         VPocxuActNfdL8j2Ul5r3aTnqx7LsOLCm7/pNPiCseJAVWDZUTbr9vhiGwUJYHLt+6od
         NFFtE7wHTOCWgO5zDKIWPREpPygfWquQHADNccMWF4RdZmonffjzFiypFC58FrmSD2Tz
         p2x/mLgBU2ozN8++lQzaOyyq7r3abTNUVETe3WyK7U5/+2TU8ukjo7IRph+vtU7y8k+f
         2YeUvc9ulOMcj+7Z2pguQtqtgmGESMV7m7hsg7fFGjzitYEdm8rFY5+9+8br62SJRciE
         Fwuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771615324; x=1772220124;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sHqh7tr0ekv0Y3NGHjbawmsrB+Z/ZMWh4LwTW562Zfs=;
        b=lyHP6C/f0cQweuy3vaALcA3AIzkiWyi6qCIb0vWP6ceAxDaQaiEumoEcx+0BqUF38W
         NeOufywT7fY4PcHOzzbVKhDVcPUr8njQmJn/Ys1oyqPBypWSyWHNkwEP4potzehAGnz8
         Diy97W2X0Un5QKjGBORyjowl75S3hl+vzLdBaaqpC0kefTf8TM/A8HtR9eptz1aY9S4w
         RfNKJVH1aAPq9ISnIVakYPJY7YjwDLNTdozy9NAZZs/ajryy0pK7QJ85Kl2eRyLDM68f
         9Xhj4NNTi225z5cqlTqIgLOi5gyzsUDaeHhTWfdEtFOgJINmXAFTrzus5ys7b3Ya8b3P
         QlNg==
X-Forwarded-Encrypted: i=1; AJvYcCUzUX7zej6sz2a7t6mSUj3mLnyifSwv9tBxjoep3DzalTxkvMTtpq/FK2n5xHedoYVuu50GE3s00A==@kvack.org
X-Gm-Message-State: AOJu0Yycwe1SmnBrj4UOUe6M6q5xe8Jpyt/sPuHibZtkiUec2YIJvmpN
	0/KXYsoOOF1tEjCEPTCrJQalile7L4wWYByIzOgcTDwBoSbuBrF/LybHKz8L5Met1YERpHFdNNu
	KFd3qqvq2KwIskUpOfB5t1knzHWL2GI0Nm7CPOmEP
X-Gm-Gg: AZuq6aJ1pV0pqB2oGE0cpQlYTcnxG0xfvk4VcTVcCSS5f4sGywxwFYeOHqv6G1gvBR7
	5qm6p+kw9tUomwQl9SJd8L9c3ZxDK4Owp0tRR0HIJ2K4SOeTQs7BdzlvcLjE5LTgWsXpJLIIAcd
	STvfUARTI8wmCLg9qr2Aij2TuoL5UBJrkHER3URIzJ33dDROCIXqHm+JpE3rKjI5u85rQgQQgDw
	3m49uTYXGJMQ5ZOHVZUvvHGzmVLb/xApJg1h5MXApkyYwXspiwqMU1yLqjWNv4OjOlgJ80VTTHZ
	WBrTtVaFXJwjeZGxVLSoLaMb3ufy7tch/O4Nhn1a
X-Received: by 2002:a17:903:368f:b0:29f:f71:a3b9 with SMTP id
 d9443c01a7336-2ad7520311amr77535ad.5.1771615323968; Fri, 20 Feb 2026 11:22:03
 -0800 (PST)
MIME-Version: 1.0
References: <aZcmlIF4bmG0twkp@thinkstation> <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <CAC_TJvdUoBmZNj68Yghmwhr4W0930s+p7UkAtSj5x5XoGAHhwg@mail.gmail.com> <aZhOnSVao9yFJML7@thinkstation>
In-Reply-To: <aZhOnSVao9yFJML7@thinkstation>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Fri, 20 Feb 2026 11:21:51 -0800
X-Gm-Features: AaiRm50UBLIkUkxehA2a6J1AoKV6rrE9W8YZ2wl9Fg_ge1pZG8FwqF-kLFv2ux0
Message-ID: <CAC_TJvddLYEApVbS3ZxHtP12hF1wymDbsBjEtV+J1qodmCPGRQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
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
X-Rspamd-Queue-Id: A9D8C180014
X-Stat-Signature: i3b3eco3rrc5bdxgreei5xcmib9jim4g
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771615325-43739
X-HE-Meta: U2FsdGVkX1+WTYqYOaXSpRlCVEDAuNTbgCfT/mgbPx1c5UlvagFDjojrrmuHl+Q9nJfZOXAFmSz8Wt9+/w9c+MMxGridujNeF94UKeveLlcNbi5FGMicf6S0cGArQQ2oeJddVgBIU4X0VQGT7AfvJAPcwVLHfbM9nB0hhxCuhiXHO1gCJFe35ToGQp6pqKNh0XE4JAE2k5CKrGWu16Bk3561lFi22UoVk5hlrLrOHAiKAemt7tXVYyUSjlugob3A0Cmu8y30pXjXuooukS94EVOprAMJ0Lbc4NGVO/8Bp3ZlQfDchuVRLe6CXlgC53vSSS3KaswPrh0a5ESiwbCeSs1hG8EkLKQdUlNDxuq/C/yqfhkCTj98kgbOElQwE64PsshlI0L5gK7uRVFqUOfhtSAvMz4OLTh7/cotQa+e7Dhwv+5RnxPYj5hd8RgUF4pMf99XywiJ1ILCmPGdNlar5l6j5RWuksexQ1IdTATbOb2Ybd6xgiSThddNJEhFkPTmS7SkcfTfQYZdLeX06GAi2J47dr0gDbFli91rWdES5h0OK2k2t+T3s6bbBbCYl+PB/2w/WjHnBQX/VSWESbeTpU+tUglxIMuROAFL3T37eb0iLmfPhedVjjEYHXDqhYAm5SobwQJ18GtViz0HwlvxXHcx3ggaJvmfxsC/AHvmDdGZmrfSnH0hhAapFfEMQj66hNg0sHPHQo32bbj4YhPKcyecS86+fYYEMmsRJ7AZVev1Twl4+WdPsgJ22wFAuSDk4KDq/EWowPk6FI8VTutDd1pcUtMzPjbIARlD6E/GofWifvAFle00gzK+ZgUNBA9k1UzOQE+MOKDtSSd5STyhvHiwK3aYvTtf5TvBindcrEks0KffrRfMR/5kXwc4zEAK7g9ZvH516bDNEMhAPoXXv41kOuAnMeuASZQZMN+JRgiuX3gcrP+NLbGgF033Bez+VC3CZkPZYT+OuSJkP/0
 saUtLZqn
 5t5QZe60UUGjmRDzVP+HK38d59V9rDVy73W5KRTod//KPjm3d/DJClrwqj/5LnfFrdusGUDg7lfleWW9XS8jBHJa+POM13/tkf9wyYg0JjUQj2jGTh+SdYqlr1qBlkAdN0Nd9jz5qVi2SZhKc58GPm09k8NkvewamVv6M5byYNVRRFNWHzsE7OuzoGWKuVxfBEChnvqQW5JKi5gNG7zKCe/6VlghnFi4DYpO3XJmCu5AHfoK7lfxlABW1yshKbOfrjirgTWQs20ZuHHjdqgwI9BXA7vmpIUi9NKS5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 4:10=E2=80=AFAM Kiryl Shutsemau <kas@kernel.org> wr=
ote:
>
> On Thu, Feb 19, 2026 at 03:24:37PM -0800, Kalesh Singh wrote:
> > On Thu, Feb 19, 2026 at 7:39=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 2/19/26 16:08, Kiryl Shutsemau wrote:
> > > > No, there's no new hardware (that I know of). I want to explore wha=
t page size
> > > > means.
> > > >
> > > > The kernel uses the same value - PAGE_SIZE - for two things:
> > > >
> > > >    - the order-0 buddy allocation size;
> > > >
> > > >    - the granularity of virtual address space mapping;
> > > >
> > > > I think we can benefit from separating these two meanings and allow=
ing
> > > > order-0 allocations to be larger than the virtual address space cov=
ered by a
> > > > PTE entry.
> > > >
> > > > The main motivation is scalability. Managing memory on multi-teraby=
te
> > > > machines in 4k is suboptimal, to say the least.
> > > >
> > > > Potential benefits of the approach (assuming 64k pages):
> > > >
> > > >    - The order-0 page size cuts struct page overhead by a factor of=
 16. From
> > > >      ~1.6% of RAM to ~0.1%;
> > > >
> > > >    - TLB wins on machines with TLB coalescing as long as mapping is=
 naturally
> > > >      aligned;
> > > >
> > > >    - Order-5 allocation is 2M, resulting in less pressure on the zo=
ne lock;
> > > >
> > > >    - 1G pages are within possibility for the buddy allocator - orde=
r-14
> > > >      allocation. It can open the road to 1G THPs.
> > > >
> > > >    - As with THP, fewer pages - less pressure on the LRU lock;
> > > >
> > > >    - ...
> > > >
> > > > The trade-off is memory waste (similar to what we have on architect=
ures with
> > > > native 64k pages today) and complexity, mostly in the core-MM code.
> > > >
> > > > =3D=3D Design considerations =3D=3D
> > > >
> > > > I want to split PAGE_SIZE into two distinct values:
> > > >
> > > >    - PTE_SIZE defines the virtual address space granularity;
> > > >
> > > >    - PG_SIZE defines the size of the order-0 buddy allocation;
> > > >
> > > > PAGE_SIZE is only defined if PTE_SIZE =3D=3D PG_SIZE. It will flag =
which code
> > > > requires conversion, and keep existing code working while conversio=
n is in
> > > > progress.
> > > >
> > > > The same split happens for other page-related macros: mask, shift,
> > > > alignment helpers, etc.
> > > >
> > > > PFNs are in PTE_SIZE units.
> > > >
> > > > The buddy allocator and page cache (as well as all I/O) operate in =
PG_SIZE
> > > > units.
> > > >
> > > > Userspace mappings are maintained with PTE_SIZE granularity. No ABI=
 changes
> > > > for userspace. But we might want to communicate PG_SIZE to userspac=
e to
> > > > get the optimal results for userspace that cares.
> > > >
> > > > PTE_SIZE granularity requires a substantial rework of page fault an=
d VMA
> > > > handling:
> > > >
> > > >    - A struct page pointer and pgprot_t are not enough to create a =
PTE entry.
> > > >      We also need the offset within the page we are creating the PT=
E for.
> > > >
> > > >    - Since the VMA start can be aligned arbitrarily with respect to=
 the
> > > >      underlying page, vma->vm_pgoff has to be changed to vma->vm_pt=
eoff,
> > > >      which is in PTE_SIZE units.
> > > >
> > > >    - The page fault handler needs to handle PTE_SIZE < PG_SIZE, inc=
luding
> > > >      misaligned cases;
> > > >
> > > > Page faults into file mappings are relatively simple to handle as w=
e
> > > > always have the page cache to refer to. So you can map only the par=
t of the
> > > > page that fits in the page table, similarly to fault-around.
> > > >
> > > > Anonymous and file-CoW faults should also be simple as long as the =
VMA is
> > > > aligned to PG_SIZE in both the virtual address space and with respe=
ct to
> > > > vm_pgoff. We might waste some memory on the ends of the VMA, but it=
 is
> > > > tolerable.
> > > >
> > > > Misaligned anonymous and file-CoW faults are a pain. Specifically, =
mapping
> > > > pages across a page table boundary. In the worst case, a page is ma=
pped across
> > > > a PGD entry boundary and PTEs for the page have to be put in two se=
parate
> > > > subtrees of page tables.
> > > >
> > > > A naive implementation would map different pages on different sides=
 of a
> > > > page table boundary and accept the waste of one page per page table=
 crossing.
> > > > The hope is that misaligned mappings are rare, but this is suboptim=
al.
> > > >
> > > > mremap(2) is the ultimate stress test for the design.
> > > >
> > > > On x86, page tables are allocated from the buddy allocator and if P=
G_SIZE
> > > > is greater than 4 KB, we need a way to pack multiple page tables in=
to a
> > > > single page. We could use the slab allocator for this, but it would
> > > > require relocating the page-table metadata out of struct page.
> > >
> > > When discussing per-process page sizes with Ryan and Dev, I mentioned
> > > that having a larger emulated page size could be interesting for othe=
r
> > > architectures as well.
> > >
> > > That is, we would emulate a 64K page size on Intel for user space as
> > > well, but let the OS work with 4K pages.
> > >
> > > We'd only allocate+map large folios into user space + pagecache, but
> > > still allow for page tables etc. to not waste memory.
> > >
> > > So "most" of your allocations in the system would actually be at leas=
t
> > > 64k, reducing zone lock contention etc.
> > >
> > >
> > > It doesn't solve all the problems you wanted to tackle on your list
> > > (e.g., "struct page" overhead, which will be sorted out by memdescs).
> >
> > Hi Kiryl,
> >
> > I'd be interested to discuss this at LSFMM.
> >
> > On Android, we have a separate but related use case: we emulate the
> > userspace page size on x86, primarily to enable app developers to
> > conduct compatibility testing of their apps for 16KB Android devices.
> > [1]
> >
> > It mainly works by enforcing a larger granularity on the VMAs to
> > emulate a userspace page size, somewhat similar to what David
> > mentioned, while the underlying kernel still operates on a 4KB
> > granularity. [2]
> >
> > IIUC the current design would not enfore the larger granularity /
> > alignment for VMAs to avoid breaking ABI. However, I'd be interest to
> > discuss whether it can be extended to cover this usecase as well.
>
> I don't want to break ABI, but might add a knob (maybe personality(2) ?)
> for enforcement to see what breaks.

I think personality(2) may be too late? By the time a process invokes
it, the initial userspace mappings (executable, linker for init, etc)
are already established with the default granularity.

To handle this, I've been using an early_param to enforce the larger
VMA alignment system-wide right from boot.

Perhaps, something for global enforcement (Kconfig/early param) and a
prctl/personality flag for per-process opt in?

>
> In general, I would prefer to advertise a new value to userspace that
> would mean preferred virtual address space granularity.

This makes sense for maintaining ABI compatibility. Userspace
allocators might want to optimize their layouts to match PG_SIZE while
still being able to operate at PTE_SIZE when needed.

-- Kalesh

>
> >
> > [1]  https://developer.android.com/guide/practices/page-sizes#16kb-emul=
ator
> > [2] https://source.android.com/docs/core/architecture/16kb-page-size/ge=
tting-started-cf-x86-64-pgagnostic
> >
> > Thanks,
> > Kalesh
> >
> >
> >
> >
> > >
> > > --
> > > Cheers,
> > >
> > > David
> > >
>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

