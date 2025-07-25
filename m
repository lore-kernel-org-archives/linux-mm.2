Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04DA7C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 23:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C44F6B008A; Fri, 25 Jul 2025 19:25:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88CF36B008C; Fri, 25 Jul 2025 19:25:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78B006B0092; Fri, 25 Jul 2025 19:25:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC2B6B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:25:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D9A271A056A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 23:25:58 +0000 (UTC)
X-FDA: 83704371996.17.AC5922B
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf21.hostedemail.com (Postfix) with ESMTP id EB3DC1C0007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 23:25:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Fw/uCp44";
	spf=pass (imf21.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753485957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aaydfYuqVafMA2JLko3KZS5h6j/lPMMeqjP2Raw9h1E=;
	b=IZaURxZt/HwPpkJWC/je9UMyPa9dEB/ig/gvASUJU/0FzOMbcWgFPUWLhdyLay1H56l2nc
	GxZmnL6RXrEKa30OdDnSK014/sI6xQfkfazCRxZkSBY11DyWD7fC+zBgMeJaFvmTQsR+jH
	uf0tDHwg3trz4cD8K4jv7LuNebHpfQ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753485957; a=rsa-sha256;
	cv=none;
	b=fxgSF2lU61XyYV0JVUkLxS66TcN45uJMn1iReoUSI7q9DuUBSJDWNCqCnyeGw4qmNiW4Yr
	pOhjyYcR08FhZEBK1eS2ILRCiYnBj0znESQx+d1oBg7H/ONuyhNq+pdQpaO96OIEyBiEdE
	CfKp7nbL89NGIz1T4L2akjks1spg7sc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Fw/uCp44";
	spf=pass (imf21.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753485954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aaydfYuqVafMA2JLko3KZS5h6j/lPMMeqjP2Raw9h1E=;
	b=Fw/uCp44j50elRecwJYSlIwHTVK4my4ZXuqt1jXAPGzfYKW68TOQLEWcy0aYrAYuOUS2tp
	5weDJPJQbYnUTtSguNmZ4Q2Fu3dMoSEHhjiXvQJeCIzfWSQfoDu/L3p10rq1rkRSyGO9YO
	qQ0u6ug7uwAzA06C4Eu0TAeQqCl8Hu4=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Matthew Wilcox
 <willy@infradead.org>,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  Liu Shixin <liushixin2@huawei.com>
Subject: Re: [PATCH] mm: consider disabling readahead if there are signs of
 thrashing
In-Reply-To: <875xffsxj4.fsf@linux.dev> (Roman Gushchin's message of "Fri, 25
	Jul 2025 15:42:07 -0700")
References: <20250710195232.124790-1-roman.gushchin@linux.dev>
	<at4ojyziprhhktjgtfmuyzrqwfmomnly6fubkvmbtxkdnx6hpb@5nldc3vipwny>
	<875xffsxj4.fsf@linux.dev>
Date: Fri, 25 Jul 2025 16:25:49 -0700
Message-ID: <87jz3vdf9e.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EB3DC1C0007
X-Stat-Signature: 3eqnceacj3zqc6798y14zbfxuagnmrbd
X-Rspam-User: 
X-HE-Tag: 1753485956-700436
X-HE-Meta: U2FsdGVkX1+D83fjSotNt4+NuFuzqmuQmLuP0H2xvFkFro4xH2oUSLDalxNrTT1S8teym8Dz5cmw20EzkMubBWaMrtE+0pm4ULp7LAY67Sr4jK+tL6kO8D3mcdvmpjHisPdXA6QRKYmAZ+kFgzfDgcyhj5423C2n8668TGrung/9Gslh8b2v83JxnE5vC1dQK2DdzFlOcQxAtvhT71UVSN5lhQrMBgBR6RrZZhM+0Li65OfM3cK1HOSmTu5QH+rmSOA76emBRaArXGmHYWMQYk/L+qGRqJl5eKVEfdudmnQzTnyG2+jOer2BjLmdm8BVObvQ+UYueUj2tPpB8KPHqBseyybmcIRzIhpAMQjrhMcHyaVcVKFzsXzIIemZeb1s9/nmV720+5eJ3rv5agF8GpWDICqKszqpDvTIvCAPDhag7ekRlTaYDC5Y29qw3pk2Rt2aouhxZ5SaRbOOIrcMlARQY3dCLxoYnqg0ylCG+Tnf69mTFzM3KHwyHKdDqT2zGBiL/oUmZZui9GKUVCpg6wHa8KvjF4LvXW85rDvz93N3uMK1MB+sbIaOTMypZYe+GvTzxbYIPc0x00DgZMqzMlVsYV26K1Ny+/askSZALOz6t3S0GHFTepwbNOiHRolwOJ4qcJSKcuOAaGbcRfKi6JA6k/i2FEkcu3IbxgBtBRWpNM9G28qInND/jjWgBAO9z0YDBRC3rBpBW0CubcvTTscAnTgeczls0yfStiwhqoMBxHJIG7K73rO4kE4DOEe51ssKA7SPFfqs4dXioMlB4uoKCOOu+6WroiRwy70ETQnJ8jaq+q2T9JrIaxoCq156rtRExj3oW2Y7nKUCe/v3ilUvU85TjNzCuQonDbQ/NVpuEWATi5zxRQs0EWuBb15hNTobjL6t1G0m7WwYrwNLZt8Hd7iTkfDD0Ga0X5FWIrCcEp1YFuuEPBzRaif0o5b5cNv5Th0zZ/6SiJJhi7Y
 VrG9qJ3/
 paSWO9LCbb3EnK2m92jhaH2kGhL6zcRRbx8X0Uud1tPdk/MSOYJYHTPDUIYtWSwlEx/km+JLZG//Fn6b62nM6SRYjcMfDZxg1qSBea4B1c5d0aO3jCia3vNjREitosjPM3AovnDahd0+4SIDU06yaRwvG5GalRRoGbzFGB5e5SgM0s6UBVYdESg8gUMYAkbhUfrgbawLTzJwai0RVmOgAvS5Jdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Roman Gushchin <roman.gushchin@linux.dev> writes:

> Jan Kara <jack@suse.cz> writes:
>
>> On Thu 10-07-25 12:52:32, Roman Gushchin wrote:
>>> We've noticed in production that under a very heavy memory pressure
>>> the readahead behavior becomes unstable causing spikes in memory
>>> pressure and CPU contention on zone locks.
>>> 
>>> The current mmap_miss heuristics considers minor pagefaults as a
>>> good reason to decrease mmap_miss and conditionally start async
>>> readahead. This creates a vicious cycle: asynchronous readahead
>>> loads more pages, which in turn causes more minor pagefaults.
>>> This problem is especially pronounced when multiple threads of
>>> an application fault on consecutive pages of an evicted executable,
>>> aggressively lowering the mmap_miss counter and preventing readahead
>>> from being disabled.
>>
>> I think you're talking about filemap_map_pages() logic of handling
>> mmap_miss. It would be nice to mention it in the changelog. There's one
>> thing that doesn't quite make sense to me: When there's memory pressure,
>> I'd expect the pages to be reclaimed from memory and not just unmapped. 
>> Also given your solution uses !uptodate folios suggests the pages were
>> actually fully reclaimed and the problem really is that filemap_map_pages()
>> treats as minor page fault (i.e., cache hit) what is in fact a major page
>> fault (i.e., cache miss)?
>>
>> Actually, now that I digged deeper I've remembered that based on Liu
>> Shixin's report
>> (https://lore.kernel.org/all/20240201100835.1626685-1-liushixin2@huawei.com/)
>> which sounds a lot like what you're reporting, we have eventually merged his
>> fixes (ended up as commits 0fd44ab213bc ("mm/readahead: break read-ahead
>> loop if filemap_add_folio return -ENOMEM"), 5c46d5319bde ("mm/filemap:
>> don't decrease mmap_miss when folio has workingset flag")). Did you test a
>> kernel with these fixes (6.10 or later)? In particular after these fixes
>> the !folio_test_workingset() check in filemap_map_folio_range() and
>> filemap_map_order0_folio() should make sure we don't decrease mmap_miss
>> when faulting fresh pages. Or was in your case page evicted so long ago
>> that workingset bit is already clear?
>>
>> Once we better understand the situation, let me also mention that I have
>> two patches which I originally proposed to fix Liu's problems. They didn't
>> quite fix them so his patches got merged in the end but the problems
>> described there are still somewhat valid:
>
> Ok, I got a better understanding of the situation now. Basically we have
> a multi-threaded application which is under very heavy memory pressure.
> I multiple threads are faulting simultaneously into the same page,
> do_sync_mmap_readahead() can be called multiple times for the same page.
> This creates a negative pressure on the mmap_miss counter, which can't be
> matched by do_sync_mmap_readahead(), which is be called only once
> for every page. This basically keeps the readahead on, despite the heavy
> memory pressure.
>
> The following patch solves the problem, at least in my test scenario.
> Wdyt?

Actually, a better version is below. We don't have to avoid the actual
readahead, just not decrease mmap_miss if the page is locked.

--

diff --git a/mm/filemap.c b/mm/filemap.c
index 0d0369fb5fa1..1756690dd275 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3323,9 +3323,15 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
        if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
                return fpin;
 
-       mmap_miss = READ_ONCE(ra->mmap_miss);
-       if (mmap_miss)
-               WRITE_ONCE(ra->mmap_miss, --mmap_miss);
+       /* If folio is locked, we're likely racing against another fault,
+        * don't decrease the mmap_miss counter to avoid decreasing it
+        * multiple times for the same page and break the balance.
+        */
+       if (likely(!folio_test_locked(folio))) {
+               mmap_miss = READ_ONCE(ra->mmap_miss);
+               if (mmap_miss)
+                       WRITE_ONCE(ra->mmap_miss, --mmap_miss);
+       }
 
        if (folio_test_readahead(folio)) {
                fpin = maybe_unlock_mmap_for_io(vmf, fpin);

