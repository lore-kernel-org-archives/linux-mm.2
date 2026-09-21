Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7295C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 17:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CB1F6B00BF; Mon, 21 Sep 2026 13:54:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854A66B00C1; Mon, 21 Sep 2026 13:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743BB6B00C2; Mon, 21 Sep 2026 13:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46D4D6B00BF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:54:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D518FA4168
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:54:37 +0000 (UTC)
X-FDA: 85238519394.26.FF1F1AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 37DAC4000A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:54:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j0lA4uFj;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790013276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZauDV3vJKUROsmCoqVdGrpQ07LaYoylUMtCQPyYKr3g=;
	b=dVnmGu3ms0EVCe7cm3jfLP1dRgMV65knWfNOSlcWSzlBsLwJcm+y9dxlRYJ4hdgQo5xndm
	g4Oj4M2Ntfu1kI4tFyYsGG68KrEtAanKdNLAK/KSpwkII39lLgPLDRRhKHTA7wiaqi9FvB
	j+sBuuAQvtX0G6VX92jnyJ8Iz0A58DE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790013276;
	b=YqDIQro4iLSEAboJJtD0J1jD/AYnRwZM8WAhAylpVXxI3a3BclIeSajfPeJkgIPllcB1fP
	oyTngvqHfFJ94r1gsVcYs0br/8vdzfCg2wUWmM/9odlx17ZD7L4Mx1a1eDQD8DK0/oYsrl
	Ubr/szMsAJhcNCcy+374VjXSKNn6EmQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j0lA4uFj;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 77BD4417F7;
	Mon, 21 Sep 2026 17:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975B31F000FF;
	Mon, 21 Sep 2026 17:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790013275;
	bh=ZauDV3vJKUROsmCoqVdGrpQ07LaYoylUMtCQPyYKr3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j0lA4uFjJBcRY6wWftw6EMIqyMIJ3+NR7zrSfOF1Z9f/TpSIZ9Gh4y4jjvxmRONiM
	 ObFuyLQ3ujm1yOOBV9KrS8elLJVfpjsktABH0b/F1q1DonDxSlGIPFvplEykYNyWru
	 TlrUJIAlHIsRcMxf5Hseb1ckLHW5wBXYIPyvOsX2gRpDZsTqCte91cFQpVs3/uhjQy
	 /uSJ4AgrDQbnh845s783rZmk0fA2Mnl9gEqoW27HOmlO9rUd44HaqIaFmOIhFLKK2U
	 BjNB7hlhY1CcorgDW7hwVfGqMdkjLPpMfT+I78qw5XqoHtqO09h+yru8tFtvcXd+2y
	 9NHxKZRfAtd9Q==
Date: Mon, 21 Sep 2026 18:54:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hongru Zhang <zhanghongru06@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, baohua@kernel.org, surenb@google.com, david@kernel.org, 
	liam@infradead.org, mhocko@suse.com, rppt@kernel.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, willy@infradead.org, zhaonanzhe@xiaomi.com, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	linux-arm-kernel@lists.infradead.org, chenhuacai@kernel.org, kernel@xen0n.name, 
	loongarch@lists.linux.dev, maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, linuxppc-dev@lists.ozlabs.org, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	linux-riscv@lists.infradead.org, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com, 
	svens@linux.ibm.com, linux-s390@vger.kernel.org, dave.hansen@linux.intel.com, 
	luto@kernel.org, peterz@infradead.org, tglx@kernel.org, mingo@redhat.com, 
	bp@alien8.de, x86@kernel.org, hpa@zytor.com, 
	Hongru Zhang <zhanghongru@xiaomi.com>
Subject: Re: [PATCH v6] mm: retry page faults once under the per-VMA lock
Message-ID: <arFYRAa-i7CIwmHL@gremlin>
References: <20260911025613.1220845-1-zhanghongru@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911025613.1220845-1-zhanghongru@xiaomi.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 37DAC4000A
X-Stat-Signature: sifujfkfgy67t6tiionpb6ekoe6qhp9h
X-Rspam-User: 
X-HE-Tag: 1790013276-858165
X-HE-Meta: U2FsdGVkX1+O7oPgbrglgjnUp2IJ5eWKJXGJPmH3pOmeepgOiD0zgc+kyK9OZwpoUNKd1DEd8W/FuwEY6uzzweqmZrAI4kBOsoqAIrahLGwwi38ujRvbjhBYGPU3ABNyPfMJY3v/sxmqVlOhSdCtwcuV46ovQxsAqTsTxopPFpN3EYfrQ7AqhWI28eo+TAlvvPY8EdiVmZH/Qs0Bb1dEN9YtnUjgRW4m7S7G68ovHvO7nuH2Pf3iqt677hxz4JC8FR4PSg77XgSIZypIBtc6OCDGsOAQiPyySciySi6DgG+f0LmLoEpaPseMQV/rs4v3zPHiys9XgRV7joQWZYgCjerv45qwtWemZA7p1Eh/r5iT7Sa5Yxf+KFmC8S061zn9rAqZA6+n2VBbpB5JijfqlzwQENyMFX3L+0nKzy8W5lEiqsTkptXSsLzLmaC6b5S3q0+4frmCYlgJOjMjcJrHtPikuCFyUR7NM1aI3RQVg/E40zUakB/C5s7kdzs4mWKTHa9olPYF/1ajhsDB4837RIiILGTSBOUFQUXRfi0v0qEBcuz0yKcq6DTnu7sAeWlu8OCLzQK1SeYY51+eapfhX4Zl/a5j782JU1bQxsXH0PG6QaU1AD0q4fapfSGDFe7PYkAWHHc4zDQw3b9ls+nAVnHWpIf0eNpepCYNOg6UgKH71OUFIRnaU7MsKdcfnF0uFtpx1RwgTO1r4F4OB9qJAvMfzc3crhITJ3tI2M45NCuyLQps6zHJvv8NScYZM1UyWHocq1uamM7Ww/LsZVH6g3gavEkrzx0PMD0nhSRR5slb6IZwZdpiWoQA/Vmd9bqA8M65UiaECVRrntrmDQ4yQ0uYSrzqOCi0JpihGHaldTootLVUQ1RT+OqcgnOPDENjl0nWzyY0jqpwKLAY5laS/aZUT+cjdhps15adDWbiWhVaFLz7SKmQhfLrjNEVjc/vJAndM07HT7Yj04/FGwd
 hFJptD6r
 JXcA3xj0cII9doepZFRp62D+SYphRgUC3dsYqivuKz2f9HtkGdyn+ZsmmRRtDov8KE+lGheSfiQn4vrtnVdn7p9yHpo45qbLa95C7VtaF+Ccq781ZQfys3r+LmzEwZfoSGhue6/hrfnGQh3sqUcpxFt5+uJ1ivfEFXWiRmtABO4x7+SEFX7blVu3mH1jLi4zbt0k0hrITEFbe3b6Esn+cBR4TQd6GL0qx+LVtVwuPHw1xF1t08qgwnlqPYXSVGMw9vR6ubZZ0NmfKuQ/nl+te6K6sdfbdm1rZN2AaQDXrQ6V9w5s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OK I finally got to this...

I fear we're going to go round in circles on this/have endless revisions of
the same thing.

So 2 things the patch needs to answer, more or less right away:

1. What are you actually optimising for?

2. Where does the hurt happen?

Your patch does neither, then goes on to arm wave away all the complexity
and presents a 'simple' solution that I feel brushes a lot under the rug.

Answer to 1 is 'cold app startup time for a specific set of apps'
2 is filemap_fault() AFAICT.

You should definitely be stating this upfront.

And I also seem to remember that zygote + multi-threaded apps = fork
blocking is part of the problem here, which is why there was push-back on
just holding the VMA lock over I/O.

Looking through filemap_fault() makes me want to cry and looking through
the other retry logic in the fault code makes me want to live on an island
with parakeets and coconuts forgetting any of this even exists...

The retry logic is fu.. err.. ndamentally a total mess.

Part of the problem is that each time this patch is respinned we lose
context on what is a complicated istuation.

VM_FAULT_RETRY can mean a million different things:

1. I dropped the lock and waited for the folio to be unlocked.

do_swap_page(), remove_device_exclusive_entry() -> folio_lock_or_retry()

2. I dropped the lock to start I/O it may or may not be ready when you come
   back.

filemap_fault() after do_sync_mmap_readahead() or page not uptodate
synchronous read with lock dropped <- what you are optimising for, or
shmem_falloc_wait() waiting for a hole punch.

The maybe_unlock_mmap_for_io() stuff.

3. I dropped the lock and nothing was waited for, OOM me on retry!

filemap_fault() allocation failure, gotta retry because we dropped the
lock!

4. I can't do this under the VMA lock, use an mmap lock

vmf_can_call_fault(), any vm_ops without ->map_pages, __vmf_anon_prepare()
when mmap_read_trylock() lost, also hugetlb_fault() horror shows.

Also device-private swap entries.

5. Userfaultfd! Because of course!

Userspace has to do something.

handle_userfault() after sleeping for uffd handler, retry should succeed.

ctx->released -> yield to releasing thread.

6. Fatal signal

Arch handlers rely on this, so retry also means 'check signals'. Fun.

7. Some driver insanity

It means all things to all people. Used for waiting on stuff like

LLM says:

- TTM at drivers/gpu/drm/ttm/ttm_bo_vm.c:62 and 144, dma_resv contention
  and GPU idle wait. Consumers in amdgpu, i915, nouveau, radeon and vmwgfx
  re-derive "was the reservation unlocked" from ret == VM_FAULT_RETRY &&
  !NOWAIT.

- xe_bo_cpu_fault_fastpath() at drivers/gpu/drm/xe/xe_bo.c:2021, where
  RETRY is the default return value, including for "runtime PM not active".

- panthor at drivers/gpu/drm/panthor/panthor_gem.c:831 onwards, where
  dma_resv_trylock() failure is RETRY and the same error is NOPAGE, SIGBUS
  or RETRY depending on mmap_lock_held.

- sgx_vepc_fault() at arch/x86/kernel/cpu/sgx/virt.c:91, EBUSY from
  __sgx_vepc_fault().  All of these call mmap_read_unlock() directly rather
  than release_fault_lock(). They are only safe because none has
  ->map_pages, so vmf_can_call_fault() bounces them before ->fault
  runs. The VMA-lock design rests on that proxy.

So yeah. All that. Wow.

8. Nothing!

LLM says:

  - page_mkwrite() returns in fs/exfat/file.c:951 (inode_trylock lost),
    fs/nfs/file.c:699, fs/netfs/buffered_write.c:576 and
    fs/orangefs/inode.c:635 onwards, including the combination
    VM_FAULT_LOCKED | VM_FAULT_RETRY. do_page_mkwrite() at mm/memory.c only
    passes through ERROR and NOPAGE, and do_shared_fault() and
    wp_page_shared() then ignore the returned value entirely. The write
    fault completes as if page_mkwrite had succeeded.

And maybe I'm missing some stuff too.

there's also places where retries are done which don't even involve
VM_FAULT_RETRY like migration_entry_wait() and pte_same() mismatches and
do_page_mkwrite() on truncation and some other places.

I think any patch maybe doesn't have to have a massive essay but it DOES
need to ack that three are a LOT of meanings and it's a TOTAL DISASTER.

Your perf numbers look very artificial - you create situations where you
KNOW from the code you'll get mmap lock contention, then have a lot of
threads contend and gosh darn it, well the contention is really high! :)

I mean - I feel like most of your perf numbers amount to 'contend locks
gets us lock contention' - and are thus useless really?

I think the bit that _matters_ is what you're actually after which is stuff
like:

> Tencent Video cold app launch time
>
> +-----------+----------+----------+--------+
> | Statistic |  Vanilla |  Patched | Change |
> +-----------+----------+----------+--------+
> |    Mean   | 1,907 ms | 1,840 ms |  -3.5% |
> +-----------+----------+----------+--------+
> |  Maximum  | 3,023 ms | 2,851 ms |  -5.7% |
> +-----------+----------+----------+--------+

Which is not earth-shattering to me.

Now, while the patch is _small_ it takes all of the above, all of the
complexity, all of the bigger questions about how to solve this and
compresses it down into 'just retry the VMA lock'.

(I note that you change the tried logic subtly too which is another thing
but never mind that).

I worry that we're not doing the REAL work here and this is just shoving
stuff under the rug for what look to be mediocre performance improvements
in a very specific workload and costing a bunch of paths (albeit not common
ones) pointless VMA lock retries.

And I worry that maybe that actually _adds_ complexity by the back door a
bit.

But I worry a LOT more that it's just a HACK (and I know Barry was nice
about the idea and I appreciate it but I have to be honest).

Instead of dealing with any of the above, we just leave the mess in place +
just retry the operation under VMA because we happen to know, for this ONE
workload, it works out better.

And PROBABLY it doesn't add too much overhead to anything else.

SO.

I've written too much again, let's sum it up.

1. WE HAVE TO DECIDE whether we want to accept the hack because it
   helps in a known case and probably doesn't harm any other cases.

2. WE HAVE TO FIX THIS DAMN MESS. Even if we take something like this WE
   HAVE TO FIX IT.

I'm inclined to rip out the whole retry thing altogether one way or another
but I leave that to Matthew to figure out :)


If we decide we DO want the hack, then DEAR LORD can we not have this
horrible duplication across arches? I seem to remember you agreed to take
that out ([0]), and maybe it's pending what Matthew wants to do, but is
there not a way to avoid that?

ALSO. It seem we are subtly changing how the tried flag stuff works and
that really needs to be considered carefully.

And FINALLY if we DO do that, the patch message MUST be honest about the
goals MUST state EXACTLY what it's trying to optimise, it MUST clearly
state that in a comment or whatever where the code is.

It must NOT wave its arms and pretend that it's some general solution for
fault retries the way it does now. It feels like it's hiding what it's
really intended for at that just adds yet more confusion to this mess.

I REALLY want to hear from Matthew on all this, I don't think we can move
ahead without his clear feedback.

--
Cheers, Lorenzo

[0]:https://lore.kernel.org/linux-mm/20260709084752.147379-1-zhanghongru@xiaomi.com/

