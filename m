Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC29AE63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4855A6B008A; Sun, 15 Feb 2026 23:54:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4569D6B009B; Sun, 15 Feb 2026 23:54:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362516B009D; Sun, 15 Feb 2026 23:54:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0009E6B008A
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:54:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06E76160C1D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 04:53:57 +0000 (UTC)
X-FDA: 84449102514.24.D7504CB
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf19.hostedemail.com (Postfix) with ESMTP id BEC391A000A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 04:53:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771217635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6o5UUGwK2OKC457CdaKvANzctWkSRZeblVw/7g0cHj4=;
	b=DzE2ucBSsNPYeugbrU14icqUl/C8oxrjpUWszvAVQGpJFBgFuyRIH46fekUygXNMyCs2Tr
	v7HrJ5hjqOXM9noNBahbUg/rqRz0u9AIYuyr8Mc/5Trod8mHeTSNAw1uOwF6UoYKuCuxLq
	w9swmj45NLsGpos6IieOb5Xc5cmM2Jg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771217635; a=rsa-sha256;
	cv=none;
	b=Ma7Qlqc2TqZB/rCKWO8/VanmG9jqcxQo8SovxEv2YRfdRjHwPEKsTPa8kznNMomnjWxW/2
	uoXJLXMv4vUUS3rdOjPFxB9rjk8dyuG5k2QUWmpMsZqA01K9qJ52OMTW6Ya5idLTNE0Kzl
	UlABwQSlGaxUyZmXpwIiUQHR/Yfg4EI=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61G4rXnK336450;
	Sun, 15 Feb 2026 22:53:38 -0600
Message-ID: <1e83d9c3cf11ba825237dbc7d6a70ba47ab328cc.camel@kernel.crashing.org>
Subject: Re: [PATCH] mm: Fix memblock_free_late() when using deferred struct
 page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Alexander Potapenko <glider@google.com>,
        Marco Elver
	 <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 16 Feb 2026 15:53:33 +1100
In-Reply-To: <aYtBctm4TlHGnzXV@kernel.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <aYJBBs17B-SQXFqq@kernel.org>
	 <279931074239b7f3812c4cb3969f887303c8cc26.camel@kernel.crashing.org>
	 <aYL3zxuTLT8N7C8-@kernel.org>
	 <c3769af482913dd7ee9d5302c8afa990255691a5.camel@kernel.crashing.org>
	 <aYXDeN0WGQG8-cxe@kernel.org>
	 <bf0231accb89709968efb4d8e1be9970aeb716f8.camel@kernel.crashing.org>
	 <e5d5a1105d90ee1e7fe7eafaed2ed03bbad0c46b.camel@kernel.crashing.org>
	 <5a44609fe992624573a3ca0a293888bd623e2a06.camel@kernel.crashing.org>
	 <0344bfbeb017cafc0f7bd4433eeacd9bc802d9c9.camel@kernel.crashing.org>
	 <aYtBctm4TlHGnzXV@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BEC391A000A
X-Stat-Signature: d3bx8y9dhn5kkr9fjz5aapjfttnnsqfx
X-Rspam-User: 
X-HE-Tag: 1771217633-386167
X-HE-Meta: U2FsdGVkX1+KO1B2cjIDCkqYx+fBlcbKwbh3iBTvdhajJYjDBjUqcvPP366wr6U2sRgCo5KFRMO3HZZ5But/ssxJ+uXlxxuwxalI48k1LlUeOFQGgCOO4ABJn8NwcOsFlBOEZrnoztGtGK5WTAK/frlf/z1QgtSOLOoMJ8/C8QkVMYrjxwU4YeBLPq9rGtNAeImFFsi11umGNP1OnmSYsCggQKNb42MpJtzxc0zA49hhXHG1ZP2zS3roK2kbIOHq1crlsaOXJxkMaqFGNMH/5LDNvqeS2reHaY8bGHxQRsgoHf6L2CWNzWJs8OQag4Nj3eaE1vGv/XQsqfQ7cY5TPmdjfSFj1sxDS3gzxYc/O6+cgGyae4AR7kDsJGZ9ylsENtCgMRjNgZlyeNAzoiFrJFF3KB/ztDjqFery+au4PCIHB5PubJuqU8fXwbEX7XrMsoqJDHyByDhNnXWuVJzXP6LoBg0eRkX9XCBjwRD9F3XT7v1hC6ynoMo5/O6l+PyJbw7NnmM/yqPrmFsOIMGmuRTjA+L8cM0we16ivm8K7SmmutiilKuqGM6JXdNG6qjnpIG5lYTYH2ECSy62U1CkzJd/wZExW65kCNzUD6JBH+XKu/t74I0JXiRhON6OLWhQhdT+W7hEctqgBd7F9t/9bnCSoX17wwfYrlXlFOgiZBXcYrDHcygmwYvvvOW9kwZmnHR9VTZHnJ1DeLQCvUPu8evqgUMQv5o8Zwf4bg3gY6g6MejmFeowa+EUdBN6eGfAKyOiZOZHqyA2Rwuc0MO6aFJysR5Q1M1DK8sv1OiBLzZmsCN5K1nSz77Jgz1wBCI6QHXSPwNqCHPwsjHoGg2Q7zCAQtVMTzkWH+LJ17BA4wLDJJG3HzEekCbQtC+KYnTI68xTtQ46nlg2/hiVCAx3rkwt8mOb1DBaHIWIvoB04X4Q2f4nSbejvtA9UQJCY14HWSaqDqpC04D2gK1xWMe
 PJ1VmDpf
 REU4rp40zjJVL1Z5jmtilsqsINS3WqSS0Bgva/Y8h5UjSUN7ptYw1j5dA0yjdcdPVhXBLhCiB+x6J5YWH/XpNFBAmcwbuRmyGNJUaMxvn1BNRKWTvmVQ3wHZCGJp5c6W64GWbKVbTYoO8cfgeRHm5b+/KV+uhIW35t2tPwk99T8Zh/SRyKBGgH97lqufSQHS82uT/Pl0NtyM55IimKmPm6pjUYnQ/G6Aw/BeE1/j9jXCf9vs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(stripping history)

So I went into a big refresher (or learning exercise since there's
quite a bit here that I never really looked at before either).

So here is a break down, in chronological order, of the setup and
initialization of the memory map, and how the reserve business
interacts with it as I understand it from reading the code.

Please correct me if I missed or misunderstood something :-) Also maybe
this is worth turning into a piece of doc ?

Then some conclusions (I think I know why the patches crashed).

1) Setting up the memblock maps
-------------------------------

This is the first thing that happens, usually deep in arch code (though
DT based archs use common code for it).

 * memblock.memory is initialized (from e820 in our case). In the e820
case, we only populate what is explicitely marked as usable. So we have
a pile of holes in there, especially around low memory where ACPI
sticks a bunch of things.

So for example, this snippet:

[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000007fffff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x0000000000800000-0x0000000000807fff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x0000000000808000-0x000000000080afff] usabl=
e

Will result in a 'hole' from 0x0000000000800000 to 0x0000000000807fff.

 * This is also where we collect the EFI boot services memory map and
plonk
it in memblock.reserved on x86 via efi_reserve_boot_services().
This will be useful later.

From this point, memblock is the memory allocator.

2) Allocation of memory backing for struct pages (memmap).
----------------------------------------------------------

Before we poke at struct pages, they need to exist.

On sparsemem systems, this happens at
setup_arch() -> ... -> paging_init() (in arch code)
which calls sparse_init() to do the job.

From my understanding they memmap is effectively created (though not
initialized) in sections by memblocks_present() in sparse.c which
iterates
the memblock.memory list (coming from e820 above) and calls
memblock_present() for each usable chunk.

On sparsemem, the section_mem_map in the memory sections is set to
track
which sections have mapped backing pages, for use later by pfn_valid()

Note that hole we had in my example is too small to result in a missing
sparsemem allocation, but any big enough hole (as big as a section)
could result in struct page(s) not existing at all.

For non-sparsemem systems, the mem_map allocation happens a little bit
later, in
paging_init() -> zone_sizes_init() -> free_area_init() ->
free_area_init_node(), but for all intent and purpose, it is the same
time.

3) Early initialization of struct pages
---------------------------------------

Once allocated, struct pages need to be initialized. We have a multi-
stage process due to the option of deferring that initialization to a
multithreaded process.

The first stage of initialization of struct pages happens in
paging_init() -> free_area_init(). So *right after* the allocation
mentioned above.

It sets up the zones and a bunch of other things (including
free_area_init_node() mentioned above), and eventually calls
memmap_init() which is the interesting bit here.

Ignoring the ZONE_DEVICE case for now, memmap_init() will iterate the
memblock.memory ranges (so the same ranges for which we ensured we have
allocated the corresponding sections of mem_map earlier) and the zones,
calling memmap_init_zone_range() for each combination:
=20
First memmap_init_zone_range() will for each valid intersection of
memory range and zone, initialize struct pages until defer_init() says
no more (ie, deferring by setting pgdat->first_deferred_pfn to
something that isn't ULONG_MAX).

We start with only one section. This is where the "deferral point" is
established. (There is a mechanism to "grow" that early initialization
on demand if early allocs need it but I'll ignore that for now as
well).

It also tracks the holes between the regions and calls
init_unavailable_range() for those (additionally memmap_init() calls
init_unavailable_range() one last time for any hole after the last
region).

Note that init_unavailable_range() is thus called for *every* hole
between the memory regions, regardless of whether we have deferred
something or not and regardless of whether we have allocated sections
of memory map or not at this point. The pfn_valid() test inside
init_unavailable_range() will take care of skipping the unallocated
sections of memory map. So far so good...

So at this point, we have:

 - mem_map allocated
 - "usable" memory ranges has struct pages initialized up to the
"deferral" point for not-already-reserved regions. (additionally marked
reserved already for ZONE_DEVICE, otherwise not).
 - holes between memory ranges have struct page initialized and
reserved provided they have corresponding backing struct pages
allocated (present sections).
 - What is uninitialized at this point are any struct pages above the
deferral point. Anything else is initialized. Not all reservations are
represented yet

IE. The memmap has backing memory, initialized for all holes and up to
the deferral point for the rest. Only reserved for holes (and
ZONE_DEVICE). We still have work to do :-)

Now, we go back from setup_arch() to the main boot process, memblock is
still "live" and our primary memory allocator.

4) Transition to the page allocator
-----------------------------------

A bit later, still fairly early during boot, it's time to enable the
page allocator and slab. It all starts with mm_core_init() ->
mem_init() in arch code.

Now mem_init() has been abused over time to do more than just this, but
the meat here is that it eventually calls memblock_free_all(). This is
when we start actually "freeing" pages and reserving memblock.reserved
pages.

 * First we calls free_unused_memmap(). So from what I can tell, this
frees bits of the mem_map that aren't covered in memblock.memory. Now
I'm not too sure what the purpose of this is at this point, as we
already only allocated the mem_map for what's in memblock.memory early
on. Could this be that we have code path that take out sections of
memblock.memory between then and now that I missed ?

 * Then the meat of the matter: free_low_memory_core_early() which does
the interesting stuff, notably memmap_init_reserved_pages() and
__free_memory_core(). The former reserves the stuff that should be
reserved, the latter sends non-deferred and non-reserved pages to buddy
for use. Let's focus on the former:

 * memmap_init_reserved_pages() is doing mostly two passes, one looks
for memblock.memory regions marked nomap, and reserves them, which I'll
ignore. The second pass use the for_each_reserved_mem_region() iterator
to mark memblock.reserved regions reserved using
reserve_bootmem_region().

This will just walk memblock.reserved blindly, doesn't specifically
limits itself to things covered by memblock.memory (ie e820). The
saving grace here is that it checks for pfn_valid(), and so will avoid
holes in the mem_map.

There is no other check, so if a page happens to be marked as reserved
by the BIOS and also part of a "hole", the struct page will be
initialized twice.

In both cases we land in init_reserved_page() followed by
__SetPageReserved(). In both case pfn_valid() should save the day if
the corresponding section of mem_map hasn't been allocated (which could
happen since we ignore memblock.memory).

Let's have a closer look. init_reserved_page() is called for every
reserved page in memblock.reserved() for which a backing struct page
exists basically. However the first thing it does is:

	if (early_page_initialised(pfn, nid))
                return;

That means that anything below the deferral point is skipped. Fair
enough, it has already been initialized as we established earlier
(note: the marking of PG_reserved happens in the caller, so it happens
regardless of that test, as expected).

That does mean that there is a small window here for double-
initialization: reserved areas covering memory holes above the deferral
point will be initialized twice, once earlier as all holes are, and
once here. I don't think that's an issue however, is it ?

At this point, we thus have initialized and marked all
memblock.reserved pages properly (as long as they don't land in a
hole), whether they sit below or above the deferral point.

Next we actually free some memory into the page allocator with:

        for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE, &start, &en=
d,
                                NULL)
                count +=3D __free_memory_core(start, end);

Nothing much to add here, it skips reserved regions and "frees" the
remaining pages in the usable mem ranges.

One little nit: This iterates everything. The decision to skip pages
below the deferral point (since they struct page isn't initialized)
comes from the test early_page_initialised() inside
memblock_free_pages().

At this point, the page allocator is "live" and memblock is "dead"
(though the memblock data structures are still around, it is just not
supposed to be updated anymore).

5) Late freeing of memblock memory (EFI Boot Services and others)
-----------------------------------------------------------------

This is the result of something calling memblock_free_late() after the
above point.

Now, for the sake of this conversation, I assume this happens *before*
the deferred pages init. There could be cases where it happens after, I
haven't audited all callers of memblock_free_late(), I'm mostly
interested in what happens in efi_free_boot_services() and that happens
before.

We also assume we cannot trust the EFI memory map to contains only
things referencing usable memory. So we get called with stuff that may
or may not be backed by a struct page, and if it does, the struct page
may or may not be initialized.

I think we can assume that:

 * If pfn_valid() the struct page exists, otherwise it doesn't.

 * If it exists, then the struct page was initialized if (and only if)
it was marked reserved earlier. It doesn't matter if it sits in a hole
anymore at this point. If it was not marked reserved, the struct page
has also not been initialized if above the deferral point. We assume
that all those pages HAVE been marked reserved by
efi_reserve_boot_services() earlier, meaning they *are* initialized as
long as pfn_valid() is happy.

 * One thing I have NOT yet figured out ... do we have a problem if the
page is in a hole that lands outside of a zone boundary ? I haven't
really got my head deep down into the details of zone initializations
(especially as we adjust the boundaries here or there), so this could
be a problem.


99) Conclusion :-)
------------------

Nothing firm yet here but a few hints at what could possibly go wrong
and one obvious issue with the previous patch(es).

First the obvious ... the proposed patch that just makes
memblock_free_late() call free_reserved_page() is missing a call to
pfn_valid(). Without this, it can (and will) hit holes in the mem_map,
and that's probably one of the crashes I reported.

Now, it would be nice to then go allocate those missing bits of
mem_map, because I really don't want to give up on that memory. Small
instances are a thing and with the current price of DRAM, a fairly
relevant one :-) But I'll look at that later.

My original patch had the exact same issue btw.

The other potential issue, for which I welcome your input as I'm
running short on time for the day is ... the impact to zones. I see a
possibility for those pages to be outside of any zone's
zone_start_pfn/spanned_pages range ... or not ? As I said, I didn't get
my head yet around the zones init and spanning adjustments that
happens, so I don't know if we really have potentially "holes" here or
not.

This leads to the question... could we work around a lot of those
issues easily by making the early efi_reserve_boot_services() *also*
add the regions to memblock.memory in addition to memblock.reserve ?
ie, those regions are marked as boot services code/data, so they must
be memory to begin with, and that's all early enough that we can do it.

We should still add the missing pfn_valid() of course, if anything for
the sake of any other caller of memblock_free_late() ... or we could
change memblock_free_late() to only consider ranges that are both
reserved *and* in memblock.memory. You mentioned that might be slow
though.

Opinions ?

Cheers,
Ben.


On Tue, 2026-02-10 at 16:32 +0200, Mike Rapoport wrote:
> Hi Ben,
>=20
> On Tue, Feb 10, 2026 at 07:34:15PM +1100, Benjamin Herrenschmidt
> wrote:
> > On Tue, 2026-02-10 at 17:17 +1100, Benjamin Herrenschmidt wrote:
> > >=20
> > > So ... that was a backport to 6.12.68 and my original patch is
> > > crashing
> > > the same way ! (it was working last week interestingly enough,
> > > something else got backported that gets in the way maybe ?).
> > >=20
> > > I'm going to have to go back to digging :-(
> > >=20
> > > I suspect the pages aren't reserved. I swear this was working :-)
> >=20
> > So I rebuilt with a bit of extra debug prints, CONFIG_DEBUG_VM on,
> > and
> > memblock=3Ddebug ... it's not hitting the reserved check, but it's
> > also
> > not crashing the same way (still 6.12, I'll play with upstream
> > again
> > later):
> >=20
> > =C2=A0.../...
>=20
> Do you mind sending the entire log?
> =C2=A0
> >=20
> > [=C2=A0=C2=A0=C2=A0 0.045633] Freeing SMP alternatives memory: 36K
> > [=C2=A0=C2=A0=C2=A0 0.045633] pid_max: default: 32768 minimum: 301
> > [=C2=A0=C2=A0=C2=A0 0.045633] memblock_free_late: [0x000000003d36b000-
> > 0x000000003d37bfff] efi_free_boot_services+0x11f/0x2e0
> > [=C2=A0=C2=A0=C2=A0 0.045633] memblock_free_late: [0x000000003b336000-
> > 0x000000003d36afff] efi_free_boot_services+0x11f/0x2e0
> > [=C2=A0=C2=A0=C2=A0 0.045633] memblock_free_late: [0x000000003b317000-
> > 0x000000003b335fff] efi_free_boot_services+0x11f/0x2e0
> > [=C2=A0=C2=A0=C2=A0 0.045633] memblock_free_late: [0x000000003b2f7000-
> > 0x000000003b316fff] efi_free_boot_services+0x11f/0x2e0
> > [=C2=A0=C2=A0=C2=A0 0.045633] memblock_free_late: [0x000000003b000000-
> > 0x000000003b1fffff] efi_free_boot_services+0x11f/0x2e0
> > [=C2=A0=C2=A0=C2=A0 0.045633] memblock_free_late: [0x00000000393de000-
> > 0x00000000393defff] efi_free_boot_services+0x11f/0x2e0
> > [=C2=A0=C2=A0=C2=A0 0.045633] memblock_free_late: [0x0000000038e73000-
> > 0x00000000390cdfff] efi_free_boot_services+0x11f/0x2e0
> > [=C2=A0=C2=A0=C2=A0 0.045633] LSM: initializing
> > lsm=3Dlockdown,capability,landlock,yama,safesetid,selinux,bpf,ima
> > [=C2=A0=C2=A0=C2=A0 0.045633] landlock: Up and running.
> > [=C2=A0=C2=A0=C2=A0 0.045633] Yama: becoming mindful.
> > [=C2=A0=C2=A0=C2=A0 0.045633] SELinux:=C2=A0 Initializing.
> > [=C2=A0=C2=A0=C2=A0 0.045633] LSM support for eBPF active
> > [=C2=A0=C2=A0=C2=A0 0.045633] Mount-cache hash table entries: 2048 (ord=
er: 2,
> > 16384 bytes, linear)
> > [=C2=A0=C2=A0=C2=A0 0.045633] Mountpoint-cache hash table entries: 2048=
 (order: 2,
> > 16384 bytes, linear)
> > [=C2=A0=C2=A0=C2=A0 0.045633] smpboot: CPU0: Intel(R) Xeon(R) Platinum =
8259CL CPU
> > @ 2.50GHz (family: 0x6, model: 0x55, stepping: 0x7)
> > [=C2=A0=C2=A0=C2=A0 0.045633] Performance Events: unsupported p6 CPU mo=
del 85 no
> > PMU driver, software events only.
> > [=C2=A0=C2=A0=C2=A0 0.045633] signal: max sigframe size: 3632
> > [=C2=A0=C2=A0=C2=A0 0.045633] rcu: Hierarchical SRCU implementation.
> > [=C2=A0=C2=A0=C2=A0 0.045633] rcu:=C2=A0	Max phase no-delay instances i=
s 1000.
> > [=C2=A0=C2=A0=C2=A0 0.045633] Timer migration: 1 hierarchy levels; 8 ch=
ildren per
> > group; 1 crossnode level
> > [=C2=A0=C2=A0=C2=A0 0.045633] smp: Bringing up secondary CPUs ...
> > [=C2=A0=C2=A0=C2=A0 0.045633] smpboot: x86: Booting SMP configuration:
> > [=C2=A0=C2=A0=C2=A0 0.045633] .... node=C2=A0 #0, CPUs:=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 #1
> > [=C2=A0=C2=A0=C2=A0 0.045633] MDS CPU bug present and SMT on, data leak=
 possible.
> > See
> > https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html
> > =C2=A0for more details.
> > [=C2=A0=C2=A0=C2=A0 0.045633] MMIO Stale Data CPU bug present and SMT o=
n, data
> > leak possible. See
> > https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/processor_mm=
io_stale_data.html
> > =C2=A0for more details.
> > [=C2=A0=C2=A0=C2=A0 0.045633] smp: Brought up 1 node, 2 CPUs
> > [=C2=A0=C2=A0=C2=A0 0.045633] smpboot: Total of 2 processors activated =
(9999.97
> > BogoMIPS)
> > [=C2=A0=C2=A0=C2=A0 0.045633] node 0 deferred pages initialised in 0ms
> > [=C2=A0=C2=A0=C2=A0 0.045633] Memory: 900460K/999468K available (16384K=
 kernel
> > code, 9440K rwdata, 11364K rodata, 3740K init, 6440K bss, 94600K
> > reserved, 0K cma-reserved)
> > [=C2=A0=C2=A0=C2=A0 0.045633] devtmpfs: initialized
> > [=C2=A0=C2=A0=C2=A0 0.045633] x86/mm: Memory block size: 128MB
> > [=C2=A0=C2=A0=C2=A0 0.045633] ------------[ cut here ]------------
> > [=C2=A0=C2=A0=C2=A0 0.045633] page type is 1, passed migratetype is 0 (=
nr=3D16)
> > [=C2=A0=C2=A0=C2=A0 0.045633] WARNING: CPU: 1 PID: 2 at mm/page_alloc.c=
:721
> > rmqueue_bulk+0x82e/0x880
> > [=C2=A0=C2=A0=C2=A0 0.045633] Modules linked in:
> > [=C2=A0=C2=A0=C2=A0 0.045633] CPU: 1 UID: 0 PID: 2 Comm: kthreadd Not t=
ainted
> > 6.12.68-93.123.amzn2023.x86_64 #1
> > [=C2=A0=C2=A0=C2=A0 0.045633] Hardware name: Amazon EC2 t3.micro/, BIOS=
 1.0
> > 10/16/2017
> > [=C2=A0=C2=A0=C2=A0 0.045633] RIP: 0010:rmqueue_bulk+0x82e/0x880
> > [=C2=A0=C2=A0=C2=A0 0.045633] Code: c6 05 be be 13 02 01 e8 b0 b5 ff ff=
 44 89 e9
> > 8b 14 24 48 c7 c7 a8 6d 51 8e 48 89 c6 b8 01 00 00 00 d3 e0 89 c1
> > e8 32 4f d2 ff <0f> 0b 4c 8b 44 24 48 e9 79 fc ff ff 48 c7 c6 e0 77
> > 51 8e 4c 89 e7
> > [=C2=A0=C2=A0=C2=A0 0.045633] RSP: 0000:ffffd592c002f898 EFLAGS: 000100=
86
> > [=C2=A0=C2=A0=C2=A0 0.045633] RAX: 0000000000000000 RBX: ffff8e363b2cbc=
80 RCX:
> > ffffffff8f1f0c68
> > [=C2=A0=C2=A0=C2=A0 0.045633] RDX: 0000000000000000 RSI: 00000000fffeff=
ff RDI:
> > 0000000000000001
> > [=C2=A0=C2=A0=C2=A0 0.045633] RBP: fffffb9c40e3a408 R08: 00000000000000=
00 R09:
> > ffffd592c002f740
> > [=C2=A0=C2=A0=C2=A0 0.045633] R10: ffffd592c002f738 R11: ffffffff8f370c=
a8 R12:
> > fffffb9c40e3a400
> > [=C2=A0=C2=A0=C2=A0 0.045633] R13: 0000000000000004 R14: 00000000000000=
03 R15:
> > 0000000000038e90
> > [=C2=A0=C2=A0=C2=A0 0.045633] FS:=C2=A0 0000000000000000(0000)
> > GS:ffff8e3639f00000(0000) knlGS:0000000000000000
> > [=C2=A0=C2=A0=C2=A0 0.045633] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 000=
0000080050033
> > [=C2=A0=C2=A0=C2=A0 0.045633] CR2: 0000000000000000 CR3: 000000001bc340=
01 CR4:
> > 00000000007706f0
> > [=C2=A0=C2=A0=C2=A0 0.045633] PKRU: 55555554
> > [=C2=A0=C2=A0=C2=A0 0.045633] Call Trace:
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 <TASK>
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 __rmqueue_pcplist+0x233/0x2c0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 rmqueue.constprop.0+0x4b6/0xe80
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? _raw_spin_unlock+0xa/0x30
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? rmqueue.constprop.0+0x557/0xe80
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? _raw_spin_unlock_irqrestore+0xa/0=
x30
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 get_page_from_freelist+0x16e/0x5f0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 __alloc_pages_noprof+0x18a/0x350
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 alloc_pages_mpol_noprof+0xf2/0x1e0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? shuffle_freelist+0x126/0x1b0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 allocate_slab+0x2b3/0x410
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ___slab_alloc+0x396/0x830
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? switch_hrtimer_base+0x8e/0x190
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? timerqueue_add+0x9b/0xc0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? dup_task_struct+0x2d/0x1b0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? _raw_spin_unlock_irqrestore+0xa/0=
x30
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? start_dl_timer+0xb0/0x140
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 kmem_cache_alloc_node_noprof+0x271/=
0x2e0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? dup_task_struct+0x2d/0x1b0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 dup_task_struct+0x2d/0x1b0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 copy_process+0x195/0x17e0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 kernel_clone+0x9a/0x3b0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? psi_task_switch+0x105/0x290
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 kernel_thread+0x6b/0x90
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? __pfx_kthread+0x10/0x10
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 kthreadd+0x276/0x2d0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? __pfx_kthreadd+0x10/0x10
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ret_from_fork+0x30/0x50
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? __pfx_kthreadd+0x10/0x10
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ret_from_fork_asm+0x1a/0x30
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 </TASK>
> > [=C2=A0=C2=A0=C2=A0 0.045633] ---[ end trace 0000000000000000 ]---
> > [=C2=A0=C2=A0=C2=A0 0.045633] ------------[ cut here ]------------
> > [=C2=A0=C2=A0=C2=A0 0.045633] page type is 1, passed migratetype is 0 (=
nr=3D8)
> > [=C2=A0=C2=A0=C2=A0 0.045633] WARNING: CPU: 1 PID: 2 at mm/page_alloc.c=
:686
> > expand+0x1af/0x1e0
> > [=C2=A0=C2=A0=C2=A0 0.045633] Modules linked in:
> > [=C2=A0=C2=A0=C2=A0 0.045633] CPU: 1 UID: 0 PID: 2 Comm: kthreadd Taint=
ed:
> > G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.12.68-93.123.amzn2023.x86_64 #1
> > [=C2=A0=C2=A0=C2=A0 0.045633] Tainted: [W]=3DWARN
> > [=C2=A0=C2=A0=C2=A0 0.045633] Hardware name: Amazon EC2 t3.micro/, BIOS=
 1.0
> > 10/16/2017
> > [=C2=A0=C2=A0=C2=A0 0.045633] RIP: 0010:expand+0x1af/0x1e0
> > [=C2=A0=C2=A0=C2=A0 0.045633] Code: c6 05 af 06 14 02 01 e8 9f fd ff ff=
 89 e9 8b
> > 54 24 34 48 c7 c7 a8 6d 51 8e 48 89 c6 b8 01 00 00 00 d3 e0 89 c1
> > e8 21 97 d2 ff <0f> 0b e9 e5 fe ff ff 48 c7 c6 e0 6d 51 8e 4c 89 ff
> > e8 eb 23 fc ff
> > [=C2=A0=C2=A0=C2=A0 0.045633] RSP: 0000:ffffd592c002f828 EFLAGS: 000100=
82
> > [=C2=A0=C2=A0=C2=A0 0.045633] RAX: 0000000000000000 RBX: ffff8e363b2cbc=
80 RCX:
> > ffffffff8f1f0c68
> > [=C2=A0=C2=A0=C2=A0 0.045633] RDX: 0000000000000000 RSI: 00000000fffeff=
ff RDI:
> > 0000000000000001
> > [=C2=A0=C2=A0=C2=A0 0.045633] RBP: 0000000000000003 R08: 00000000000000=
00 R09:
> > ffffd592c002f6d0
> > [=C2=A0=C2=A0=C2=A0 0.045633] R10: ffffd592c002f6c8 R11: ffffffff8f370c=
a8 R12:
> > 0000000000000008
> > [=C2=A0=C2=A0=C2=A0 0.045633] R13: 0000000000038e98 R14: 00000000000000=
03 R15:
> > fffffb9c40e3a600
> > [=C2=A0=C2=A0=C2=A0 0.045633] FS:=C2=A0 0000000000000000(0000)
> > GS:ffff8e3639f00000(0000) knlGS:0000000000000000
> > [=C2=A0=C2=A0=C2=A0 0.045633] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 000=
0000080050033
> > [=C2=A0=C2=A0=C2=A0 0.045633] CR2: 0000000000000000 CR3: 000000001bc340=
01 CR4:
> > 00000000007706f0
> > [=C2=A0=C2=A0=C2=A0 0.045633] PKRU: 55555554
> > [=C2=A0=C2=A0=C2=A0 0.045633] Call Trace:
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 <TASK>
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 rmqueue_bulk+0x541/0x880
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 __rmqueue_pcplist+0x233/0x2c0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 rmqueue.constprop.0+0x4b6/0xe80
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? _raw_spin_unlock+0xa/0x30
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? rmqueue.constprop.0+0x557/0xe80
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? _raw_spin_unlock_irqrestore+0xa/0=
x30
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 get_page_from_freelist+0x16e/0x5f0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 __alloc_pages_noprof+0x18a/0x350
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 alloc_pages_mpol_noprof+0xf2/0x1e0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? shuffle_freelist+0x126/0x1b0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 allocate_slab+0x2b3/0x410
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ___slab_alloc+0x396/0x830
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? switch_hrtimer_base+0x8e/0x190
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? timerqueue_add+0x9b/0xc0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? dup_task_struct+0x2d/0x1b0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? _raw_spin_unlock_irqrestore+0xa/0=
x30
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? start_dl_timer+0xb0/0x140
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 kmem_cache_alloc_node_noprof+0x271/=
0x2e0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? dup_task_struct+0x2d/0x1b0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 dup_task_struct+0x2d/0x1b0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 copy_process+0x195/0x17e0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 kernel_clone+0x9a/0x3b0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? psi_task_switch+0x105/0x290
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 kernel_thread+0x6b/0x90
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? __pfx_kthread+0x10/0x10
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 kthreadd+0x276/0x2d0
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? __pfx_kthreadd+0x10/0x10
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ret_from_fork+0x30/0x50
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ? __pfx_kthreadd+0x10/0x10
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 ret_from_fork_asm+0x1a/0x30
> > [=C2=A0=C2=A0=C2=A0 0.045633]=C2=A0 </TASK>
> > [=C2=A0=C2=A0=C2=A0 0.045633] ---[ end trace 0000000000000000 ]---
> >=20
> > > >=20
> > >=20
> >=20
>=20

