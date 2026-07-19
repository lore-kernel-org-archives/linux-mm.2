Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE6FC44512
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 22:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C166B0088; Sun, 19 Jul 2026 18:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4D746B008A; Sun, 19 Jul 2026 18:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C766B008C; Sun, 19 Jul 2026 18:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 934DB6B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:24:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E0237A06AD
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 22:24:25 +0000 (UTC)
X-FDA: 85006956090.22.025D662
Received: from smtp-bc0a.mail.infomaniak.ch (smtp-bc0a.mail.infomaniak.ch [45.157.188.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id 816CB18000A
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 22:24:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ik.me header.s=20200325 header.b=cjUVXAwK;
	dmarc=pass (policy=reject) header.from=ik.me;
	spf=pass (imf06.hostedemail.com: domain of nadia.yvette.chambers@ik.me designates 45.157.188.10 as permitted sender) smtp.mailfrom=nadia.yvette.chambers@ik.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784499864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQB/6+IJqA5duUXmgtGcMMoaGojnmy2eUhB4iYe1QqE=;
	b=RvtALyymX+YzR2jLdT017/JOds5oCyKSE1vcj9r1qsVaBB5CsFMxpdY9ParivbaGCGAFdj
	lROWR20vDXUZp7aTaVuwKQJvPT0QCDNt3xkiz0u7+v2LaJyeV2wtbdHsQkjGZndmea1pQu
	yQSKBaDeUOvMIqji012/bhlfsdmNNTw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ik.me header.s=20200325 header.b=cjUVXAwK;
	dmarc=pass (policy=reject) header.from=ik.me;
	spf=pass (imf06.hostedemail.com: domain of nadia.yvette.chambers@ik.me designates 45.157.188.10 as permitted sender) smtp.mailfrom=nadia.yvette.chambers@ik.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784499864;
	b=2wCBUDyWhGIq774nITZB+wOjQ0azFVb5f9sxr7iQ74zUIr0Z9tsVpOMOAIG4D7m9JGfxls
	5f2YJB2/3fDi3hxMLBcwIhsSE0cAr6fXfvqrGAPG8ONu0wGdN5PZur41w+rKI6zJxp7mDm
	8DuWB13orK7D2wFN6kb4/2V/Zn6VZ3I=
Received: from smtp-4-0001.mail.infomaniak.ch (smtp-4-0001.mail.infomaniak.ch [10.7.10.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4h3J913bYjzQFG;
	Mon, 20 Jul 2026 00:24:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ik.me; s=20200325;
	t=1784499861; bh=PQB/6+IJqA5duUXmgtGcMMoaGojnmy2eUhB4iYe1QqE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cjUVXAwKbm8J5u7giG3EGsVIhfGnZcziJC1kh006pmUFX/mfb+ewKLKxLZfXfSqxN
	 ygbGKaWqLtdk+Kf+GUw0cXZ8wY3N8O4THEjCknx3rJKotwF/5GFDiscItAv1odEWOM
	 lk7WQ20UYKevcDcmYPtGA6/mM2/pssJNFsA7xeyE=
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4h3J8z0g3VzfM6;
	Mon, 20 Jul 2026 00:24:19 +0200 (CEST)
Date: Mon, 20 Jul 2026 00:24:12 +0200
From: Nadia Chambers <nadia.yvette.chambers@ik.me>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, lsf-pc@lists.linux-foundation.org, 
	linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <al0xogLqubAZh6SD@ik.me>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <aZdCl8byz51Q1-v6@thinkstation>
 <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
Feedback-ID: :3e9ae705af0626a:ham:b89b32586f6d122
X-Infomaniak-Routing: alpha
X-Stat-Signature: wbrywnxbntj1p7zfbo1k61ar9gtaubhq
X-Rspamd-Queue-Id: 816CB18000A
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784499863-795380
X-HE-Meta: U2FsdGVkX19xic3EsU1S3PYZJp5fzi3SAtoAZ7Scn9fhu9CbdgyoOH77NJZ47uko4sks9UUkJVbk1xaGWWvBhyfJGXr8NESG/m6duVFdvxsUzFGJZ/N9DtcJmBm7BIoQj0pPE//qdkV4flcsOZ6Q4NgLBb17jNActd/+dzkJ1Gb2d2Mkiy0zycapvLPKAra57p5IsP//kT7UyXgU+ugeXsEmV0KxFLfUH6HwJrcOVBgDq+V3a0qisgJSTbwKSL5DxjQTbxG+n4fw/JBd5Fyiuw8lEXjKMetOfP9b00N0qlQgMRA76cvCQAWyIfeyAjGPrbJKzfja/+cB7om8hapDRsfnlWrrb3z2ViJzWwYvcr7QpGB/nH87VS+Yllk9KNfrArEIg4wFBoLtoc0gaRXb9MnXu2svVt6rYXF+UUdwD7L9f0MDux4vZvw4EAIvm9YOY3WWf+XaKhrsbjmWownVbe0Od3JpK2a1BsWFGt9J06BKIps+/nMUmhua8a7eMDfa7JqhXVv3BJ9UXp/eUSglB65KV0tnTQfH9eiYzwfkH/Ue8wIKDvqxTFX/HCAsxKY3Tvg0r/9EZxMV62p4HGCHkcooEuAVMDEX8CiGqvxfzF8jIq0xeL97nGXg+k8XqDZMDi6JkSu00pWgvEuzIMPWTTxvFh8PVZahr2OBdhj1jXYElygojuxolTUS6wROUhcltBFf8XhPcJrbYG3XcjjdkbYxut1RM5jr1ZnAK5lUn8OA/u3YJ/vhRC7XTI4JKkkwAO/tzzGCjnNkcwyESrTRp2x3TAXetted1PugTmJ0CCzIkuBsdkqAWp5H8v1jGK5LxXhl+BuWCObgsVCudvAcHDtN8at9ldKx1vpiieRU/27K0k7E4Gs0ikk+i/AhJ7MunD97HljgfkAjs4RYEzqnEC+c8S7gnWId55skcPOGMTLJFMyW61v0rGNDcIT8WmZFq4fmLCJ+UVZ6OF+rXLj
 kP1nW5ou
 Z5EcnrPuhw0epNUP0kMd6nPwhN9nz+jK89qu94U9Cd2shAttN1+q0kSynfJl4V1BQapbRL4YOlLvDYLbLN5jFfTgO3kk+O4Y9VBBujl7ew9fYAr0Y4ON6LgRsn+9KUsljH/guPAfjp96/ocjInoqOQTDgEek0JREBUyf84Ld+4Fh9Z+p4rN47bBLjJZ1EhLBKIAMQpnln9MwJbATSR1vQy05zAJGfrrOgsFvgNymhCOAxZvgywjYcH8wwGQkvHYO9NqbTdttG2/oqczc275m1h2nw/BxxJa96fN4QigxaKAmZlK2f0w3dRLZrwTbpx95CsfknWXbEiOdKXhB3SGtn7dolPsC87J917uE9ZG7NwCYjOz/u0KSk1GdoROJoZqUQP+hCD7rqJhdAUD2ak3Ll2gHFfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Am Fr, Feb 20, 2026 um 11:24:37 +0100, David Hildenbrand (Arm) schrieb:
> Right, see the proposal from Dev on the list.
> From user-space POV, the pagesize would be 64K for these emulated processes.
> That is, VMAs must be suitable aligned etc.
> One key thing I think is that you could run such emulated-64k process (that
> actually support it!) with 4k processes on the same machine, like Arm is
> considering.
> You would have no weird "vma crosses base pages" handling, which is just
> rather nasty and makes my head hurt.

While it had to be written, it was a straightforward extension of
converting ->vm_pgoff to being in MMUPAGE_SIZE (Kiryl's PTE_SIZE) units,
recovering offsets into pages usw. Nothing seemed terribly hard to
understand about it. Really, the code as it stands rarely approaches
what it's doing in such a way that it broadly surveys the layout of vmas
and pages and be conscious of whether pages spanned vmas or multiple
vmas were representing maps of of fragments of pages, so I'm not
convinced there's anything particularly unique to be afraid of here.


Am Fr, Feb 20, 2026 um 11:24:37 +0100, David Hildenbrand (Arm) schrieb:
> Well, yes, like Willy says, there are already similar custom solutions for
> s390x and ppc.
> Pasha talked recently about the memory waste of 16k kernel stacks and how we
> would want to reduce that to 4k. In your proposal, it would be 64k, unless
> you somehow manage to allocate multiple kernel stacks from the same 64k
> page. My head hurts thinking about whether that could work, maybe it could
> (no idea about guard pages in there, though).

Never mind wasting memory; just getting it booting in 2003 needed
adjusting things so the THREAD_SIZE stayed constant and there were
things in the core kernel that got a divide by zero or some such when
THREAD_SIZE was too large. The effort for the fix in 2003 was just
getting adequate diagnostics, not the stack allocation code itself.
The mechanically assisted forward port did something that got it booting
that, upon critical examination, I don't like and uses a lot of space.
vmalloc and guard pages don't have anything special about them either,
apart from taking work to implement, which I've done before as part of
what appears to be a now non-extant patch kit, stack_paranoia.


Am Fr, Feb 20, 2026 um 11:24:37 +0100, David Hildenbrand (Arm) schrieb:
> Let's take a look at the history of page size usage on Arm (people can feel
> free to correct me):
> (1) Most distros were using 64k on Arm.
> (2) People realized that 64k was suboptimal many use cases (memory
>     waste for stacks, pagecache, etc) and started to switch to 4k. I
>     remember that mostly HPC-centric users sticked to 64k, but there was
>     also demand from others to be able to stay on 64k.
> (3) Arm improved performance on a 4k kernel by adding cont-pte support,
>     trying to get closer to 64k native performance.
> (4) Achieving 64k native performance is hard, which is why per-process
>     page sizes are being explored to get the best out of both worlds
>     (use 64k page size only where it really matters for performance).

There are ways to deal with internal fragmentation, like tail packing
for the pagecache, switching to slab for a lot of things, potentially
even pagetables, so they don't grow with PAGE_SIZE usw. Stacks might
take more work than the average kernel data structure, but I've
implemented changes to stack allocation before at points when the
vmalloc and size varying usw. usf. stack bits weren't in mainline.
Bitblitting latencies are also issues to try to keep bounded that I've
seen little discussion of here yet.

I suppose the bad news is that I didn't get the chance to actually work
on the internal fragmentation mitigation strategies I wrote out plans
for 23 years ago. They weren't that involved, though.


Am Fr, Feb 20, 2026 um 11:24:37 +0100, David Hildenbrand (Arm) schrieb:
> Arm clearly has the added benefit of actually benefiting from hardware
> support for 64k.
> IIUC, what you are proposing feels a bit like traveling back in time when it
> comes to the memory waste problem that Arm users encountered.
> Where do you see the big difference to 64k on Arm in your proposal? Would
> you currently also be running 64k Arm in production and the memory waste etc
> is acceptable?

My original 2003 intentions for the use of Hugh's ABI compatibility
technique were to make page clustering as a solution for 32-bit large
memory „forward-looking to 64-bit“, where at the time, 64-bit meant
IA64, by using it to provide a guarantee that small superpage
allocations would never fail due to external fragmentation, which design
goal came from above. While some colouring benefits usw. were
anticipated as byproducts, this idea about how to handle small
superpages was the primary way it was conceived of as addressing 64-bit
concerns, perhaps in part by dint of IA64-centrism, or potentially a
kind of inheritance of a requirement for an equivalent of the
very-differently-implemented mechanism for the same from HP-UX. It also
seemed rather safe to set the goal of „raising the floor“ so the very
smallest TLB entries wouldn't proliferate, and the smallest page sizes
consume a lesser fraction of available TLB entries.

Proposals for trying to use the technique as some kind of fully general
method for reaching for 1 GiB if not larger pages seem ill-conceived to
me. Those kinds of issues demand changes akin to transforming the
problem so it's in an entirely lesser complexity class, not adding a
small constant to the methods already in place attempting to deal with
large-scale external fragmentation. I liked Rik's partitioning memory
into arenas of pre-constructed 1 GiB or otherwise very large superpages
as a strategy for that, for instance.

I generally care enough about architectural coverage that my recent
mechanically assisted efforts maintained an 80+ -cell regression testing
matrix of 20+ architectures with PAGE_MMUSHIFT values of 0, 2, 4 and 6.
ARM notably represented an extra architecture variant via LPAE. The arch
code I cry about was not having got the chance to use the recent MIPS
PageGrain extension to provide a 1 KiB MMUPAGE_SIZE and a PAGE_MMUSHIFT
of 8 for demonstration purposes. If I had got that done, I might have
even emailed Babaoğlu, Joy, and possibly even McKusick about it, though
Karels is reputedly the most likely suspect for who outside of Babaoğlu
and Joy might have committed CLSIZE u.a. to 3BSD's VAX VM code in 1979.

I made at least earnest attempts to cover every architecture in the
kernel. There was one I couldn't find a toolchain for that just wired
all of the MMUPAGE macros to be identical to their PAGE analogues and
hoped at least built (arc?), but otherwise, I was trying to cover them
all, even if at the moment only in QEMU. I hope I can put a personal
many-architecture testing lab like I had in the '00s together for
myself again at some point, given the chance, but they'll have to be
small things like for embedded this time with how flats in Berlin are.


-- nyc

