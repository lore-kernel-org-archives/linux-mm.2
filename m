Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FB66C4451B
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 17:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5DD56B0088; Sun, 19 Jul 2026 13:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0E7F6B008A; Sun, 19 Jul 2026 13:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24C76B008C; Sun, 19 Jul 2026 13:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C02B6B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 13:30:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04D4180675
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 17:30:47 +0000 (UTC)
X-FDA: 85006216176.20.751F7FC
Received: from smtp-bc0c.mail.infomaniak.ch (smtp-bc0c.mail.infomaniak.ch [45.157.188.12])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9A8F1120008
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 17:30:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ik.me header.s=20200325 header.b=d94GS9Wq;
	dmarc=pass (policy=reject) header.from=ik.me;
	spf=pass (imf29.hostedemail.com: domain of nadia.yvette.chambers@ik.me designates 45.157.188.12 as permitted sender) smtp.mailfrom=nadia.yvette.chambers@ik.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784482246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CgK7IvRxf3QPyJpb9n07JBZlc4fYKX+6CAGrsFf+HRs=;
	b=cJOTsl5V0Y/a2P39AUOwsaThH8La3lPD4L6VknzHR5w4xIuOZW2gKcQZzncmOPJtac8j6i
	BkV2nr1DA1XnY3ZkB1x/FZLvK5HRvx6Vz5IVulhhXUi+BO9sPcYmRgHjZmeimxp58NQUsn
	p67J2RbHuvyPYi9i3ci9WND1SLf/RfM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ik.me header.s=20200325 header.b=d94GS9Wq;
	dmarc=pass (policy=reject) header.from=ik.me;
	spf=pass (imf29.hostedemail.com: domain of nadia.yvette.chambers@ik.me designates 45.157.188.12 as permitted sender) smtp.mailfrom=nadia.yvette.chambers@ik.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784482246;
	b=Bb3KOZnKdN3QlBqMZ7WsSJHHOWQ/rVudB1NT27URXZLGHVYej8bLWejkapRAUAJWFSFXXI
	br6QhQfZg8FhohjirVLMImqRKB6LghU28zPWVOjPdw0cSkRrssQrl6RScv6k98iIEQF3Zq
	bvA7mMRXCVEYo9BduWfve7sBwBUtJ2c=
Received: from smtp-4-0001.mail.infomaniak.ch (unknown [IPv6:2001:1600:7:10::a6c])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4h39fC4vl2z9Pg;
	Sun, 19 Jul 2026 19:30:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ik.me; s=20200325;
	t=1784482243; bh=CgK7IvRxf3QPyJpb9n07JBZlc4fYKX+6CAGrsFf+HRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d94GS9WqCgEI36kwNvebR1DJQ296v1q57+j5IRMA8rsvjsh6+X8GHtI6OVRLX+8+h
	 uHpr5z9GiOjEjF6vBtOEdTChSYJaBxAhVPhfzrQbsTUmQ9DiZv+Yo7TGdJHTlxZKPM
	 LpqlJvE6J6jpggNkiFAToB7BvWl1ieqbpXp5dh3s=
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4h39f903D7z7NC;
	Sun, 19 Jul 2026 19:30:40 +0200 (CEST)
Date: Sun, 19 Jul 2026 19:30:39 +0200
From: Nadia Chambers <nadia.yvette.chambers@ik.me>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <alzp5lvQho0nAoSS@ik.me>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <aZcxWsWO7AxQW6JC@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZcxWsWO7AxQW6JC@thinkstation>
Feedback-ID: :e0199cdf3b76464:ham:b89b32586f6d122
X-Infomaniak-Routing: alpha
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9A8F1120008
X-Stat-Signature: bikqkccujqpk3zcrmezg1k39kfkq5mn8
X-HE-Tag: 1784482245-519374
X-HE-Meta: U2FsdGVkX19WshkqqqKHx78NI4FF8xBgR08p3MykiI6fyvRIU2jDZ/Qztgyo1Z0Dg3AygbMzaBSBk3+NFNCwCeRIp0t/cSqxYSH8MqCUkFJpzHOppehTQlfEVFpvkivd+c3S+72XsDnhhdv+/pHRXbdUPSKpsMlvobC8W0gxyGhXHIntR3CLz8i1y0KMWVB0N8A46d2AzA7ZtMzq0MWa5l/wVnrivMN++EYqtbNg1/wMen+oaHRFc7Bmusbil8KpKx4SbKk40v4eAIbmxOtWJLIyFzAYu4/9WwF0wuUkQu7DJP27xnQDnX3n0s+N80jlLx+QaaAI5fFn9DVj4NaFR8HVtYvaRCNrDzMG9qKNZp4HQL4fLeu+wBtxq8JS20hjVgKDtw19Io6AN1sn1j5AboD80UoUhVUtZ58BjSYpqKLStJV+2V632Oty9DYYmbJmg9SmYecoQ6AN1e6AzdFNL8hvKxxfrS0oDkyAhUsZ25ASbKYj0aM20wi3Dv1CI/qT+c8yhQe9sAbkqb7mjOGqjN5kvUl0PEANf5jTiKKeMBVQKGJA/AzY8EZHXwVGoR7q8r9iA9eC50R9dNqFTAnJTnzy6Ry/UPPt3O0QT0nhFnRn7lxrDvybcAT2aCqN/9xT2oLMy8uJr/F8wC4+6Jf4Teir9kbLCe9OWqHtv80JbiDdjbt3MXHeUHbI4MZu6HAKc+Itl9C+4XjM+iB+5kULIKz3wvkrnxT3uooCQCtYD4SKEw6zSkIbG0KC8a/wJhQPLDFcNnqQtMYxAYnKWbslo88qtbZfgIx/njaxEQwMLuVYYOWZB9l3nX62ZGmUm4Y/ZCb0Gb3hdMjLLFLH2KxPWXWRCW6rHF1b1CT3n+xPz8KsRtjDmMz1LF1VcjwnTKUXUavBqqkqG1H7n6QPEHPHx7hlgoq5TsbS+O4I59Cxo5r0GQUTLSvPnAI4M6B6JpRz0Gw8AxFxzFL1Y0qUQ5T
 8PNww/WV
 SxPDycResZWxitN/62obl9qQeZZEaARNyqEYn4gRBUteG1aIG3vcTWGhyW9j7Pl9Y1Vy9ePcn5dmzKrdsc1B0BQe1OO7tPY/4j7AbTWu7ZSIu4SR/m/drdvStWu+aPhOdgQK8noKeNVLyjwBcADwlpeTGDXVIPD30yZKglEbnN6aGHX0/vUNaISwjLbei6+PdeHMAN3PwfL7VhgWgKpuZjEVIS6mQiXHu5whww5IVH7Jzv5b9IWyOaan9Ipn5opPM4v7jXyr6kLdE7xGQmvcVDlWdMOBD14Kc+swVn7s3odKVbOaG6s31P3uUhzqQmXoiduJz9IpC4VNoPRue206kwglnWIbaNqauvLTJ+Kg1u9hGCwJ/qykqBRTKPyVGLbPeJAQgM/vUPrtHZxwpL6ukte0E3q4ZR2tDfFxtRBTltMxE3Rg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 04:39:34PM +0100, David Hildenbrand (Arm) wrote:
>> When discussing per-process page sizes with Ryan and Dev, I mentioned that
>> having a larger emulated page size could be interesting for other
>> architectures as well.
>> That is, we would emulate a 64K page size on Intel for user space as well,
>> but let the OS work with 4K pages.
>> We'd only allocate+map large folios into user space + pagecache, but still
>> allow for page tables etc. to not waste memory.
>> So "most" of your allocations in the system would actually be at least 64k,
>> reducing zone lock contention etc.

Am Do, Feb 19, 2026 um 15:54:56 +0000, Kiryl Shutsemau schrieb:
> I am not convinced emulation would help zone lock contention. I expect
> contention to be higher if page allocator would see a mix of 4k and 64k
> requests. It sounds like constant split/merge under the lock.

Presumably because the higher-order allocations would lack the per-CPU
special-case handling for order 0? IIRC LLFree is lock-free at all
allocation orders, which would likely help the zone lock specifically.
I suppose there's a sense I'm hoping my memory isn't out-of-date, but I
would still be glad to see the improvement. Extending per-CPU freelists
to small nonzero orders z.B. 4 might also help zone locks to allocate
64 KiB case likely around as much as using PAGE_MMUSHIFT == 4.


On Thu, Feb 19, 2026 at 04:39:34PM +0100, David Hildenbrand (Arm) wrote:
>> It doesn't solve all the problems you wanted to tackle on your list (e.g.,
>> "struct page" overhead, which will be sorted out by memdescs).

Am Do, Feb 19, 2026 um 15:54:56 +0000, Kiryl Shutsemau schrieb:
> I don't think we can serve 1G pages out of buddy allocator with 4k
> order-0. And without it, I don't see how to get to a viable 1G THPs.

memdescs are too recent for me to know about, but there is a comment to
make about 1 GiB superpages: doubly exponential decays in availability
are going to overwhelm the effects of any reasonable valud of
PAGE_MMUSHIFT (your ilog(PG_SIZE/PTE_SIZE) which has no macro for it)
long before 1 GiB. Bumping a small constant off the grand total of
allocation orders isn't going to be an adequate strategy. ISTR Rik van
Riel had code going round to partition RAM into something akin to
pre-formed large z.B. 1 GiB superpages that's a far more meaningful
approach to 1 GiB superpages than reducing the allocation order for
1 GiB from 18 to 14 or 12. The double exponential makes orders above
maybe 2 or 3 require migration or compaction and there's a cut-off above
which you're going to need to be either be fresh off a virgin boot or to
do something slow bordering on swsusp-style mass eviction.

If memdescs, presumably from „memory descriptors“, are something like
memory extents, I wholeheartedly endorse moves to more extent-based or
extent-like memory management and can quibble about the details later.

You can make an argument that scaling may need to take special steps to
reduce the TLB entries for the smallest page sizes so they don't
outcompete the real datasets when they proliferate. But buddy allocating
(LLFree should be used instead) isn't going to be appreciably any better
at orders 14 (PAGE_MMUSHIFT == 4) or 12 (PAGE_MMUSHIFT == 6) than 18, as
with double exponential decays, it dropped to effectively zero onf.
vmtl. 5 or 6, and values of PAGE_SIZE much larger than 64-256 KiB would
likely require far more extensive efforts to address regressions driven
by bitblitting latency and internal fragmentation than simple things like
tail packing the page cache. If you're starting from an
MMUPAGE_SIZE/PTE_SIZE of 64 KiB z.B. ppc64, it only really changes the
story to cutting 14 to 10 or 8, but the net result of that with
PAGE_MMUSHIFT == 4 is a PAGE_SIZE of 1 MiB and for PAGE_MMUSHIFT == 6 of
4 MiB, which are clearly beyond the pale of what'll be tolerable for
insb. network latencies for high-performance scenarios.

There is a case where those handfuls of buddy bitmap orders makes a
difference: if you're trying to split the difference between z.B. the
MMUPAGE_SHIFT/ilog2(PTE_SIZE) and PMD_SHIFT. That's not reaching 1 GiB,
though. That's the only real benefit possible to offer in the trivial
case of the sparse page size spectrum. Dense page size spectra like
MIPS, LoongArch, RISC-V Svnapot, and Fujitsu M12 SPARC (I presume IA64
has sadly been completely discontinued at this point) are more of where
the benefits an argument can be made for are concentrated. In the
desperation of the sparse page size spectrum case z.B. x86 page size
growth increment / Sprungweite of 9 or some Apple M5 ARM systems' 11,
trimming orders off of it might be worth it even after something in the
vein of Rik's large superpage / „huge page“ -sized arenas, but with some
devoted to the first superpage size as that's too many orders off from
MMUPAGE_SIZE for naïve handling to work well.

To be clear, I am in favour of page clustering as per your pte_size,
Andrea's hard-page-size, my pgcl (not genuinely distinct from Hugh's
except via my being a far lesser coder than he), and Hugh's larpage.
My objection is that the rationale you've given isn't sustainable.


-- nyc

