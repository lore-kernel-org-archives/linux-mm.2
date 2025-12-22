Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EC12E677EA
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 15:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECD536B0005; Mon, 22 Dec 2025 10:34:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7A946B0089; Mon, 22 Dec 2025 10:34:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7CE36B008A; Mon, 22 Dec 2025 10:34:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C38996B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:34:03 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7056988BC5
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:34:03 +0000 (UTC)
X-FDA: 84247502766.14.F4049FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 949881C000A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:34:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BrDj17wm;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766417641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xol217Co56ag81VF5MHRvQYoROn7jopXXGSlBbVTHhQ=;
	b=mNPJgkLwAAFPPB5D0oif1zGm/BXGF3OsHcpY4wzrXu+/3vlIBP+5dqeT/XxtDyoe32ZAxu
	UZsapowrfeFmT0lFLVFCeBjWQyZsmN7KoY8AwvR6FXFrOCe5NoM8DO8nnwMQEIwQ4Ggs09
	p0Rj2eVJRX5y8OXmtEyRHqozfUr/eNw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BrDj17wm;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766417641; a=rsa-sha256;
	cv=none;
	b=333sfnVU0/GFWTwsOWLa+8hGF1HG8z9LTuVBqVP1tftRXtF132BJ2aoyxEfkLZTXM3M/it
	QE6ZusYEo5AY+75iy5tziLRgl0WLk1vJwpZ8KePCzQ0WgWxMzttyBe48k0dPbDRmTkqSMc
	y+o502UD07oPgW1GY+iK2jVpeJSBins=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 679C8419F6;
	Mon, 22 Dec 2025 15:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8DEC4CEF1;
	Mon, 22 Dec 2025 15:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766417640;
	bh=n3hXQxXElFRU5pq8HpCn5TZiWmvSa3ILDsLsLX0GpK8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=BrDj17wm8KyH6Yy5TyHwiSjKNrwVmN6lVXTLojFPl8mt0y88NuDv44OZw5ZAwo1c3
	 iQE5XWXo1hKW3l/sFSCIsth+VT2YIJl+CcYGHDkaloZMci50o06F96mhI52gBxf0DO
	 SRVRu79umAfq+gzZ/dHZkppdaMuZdRQYDFg3Q49jKocFxy1ldBrfQqiB4mZtebRrZI
	 NiZmAZzpKbY/1b1oWMhYUIoWBB7Ox60if77yxHLFyAdo/gHCNjpv+MbpSCkWXTgOvc
	 4tBplfV48Cw63cd6VC3t54yeO3R/ljcWXIo0ILxMahYJbeaiNBSXnztDPmmlEKcbVZ
	 OVfdagKYnJA3w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Evangelos Petrongonas <epetron@amazon.de>,  Alexander Graf
 <graf@amazon.com>,  Andrew Morton <akpm@linux-foundation.org>,  Jason Miu
 <jasonmiu@google.com>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  nh-open-source@amazon.com
Subject: Re: [PATCH] kho: add support for deferred struct page init
In-Reply-To: <CA+CK2bA1kYCf0BwhX3Sg9Ur82nK-7HPzs0sg6xbVWFAJaZLhpw@mail.gmail.com>
	(Pasha Tatashin's message of "Sat, 20 Dec 2025 09:49:44 -0500")
References: <20251216084913.86342-1-epetron@amazon.de>
	<aUFJH9xzJXYOt_X8@kernel.org>
	<CA+CK2bDGvgcGJijAtSSa2k_FWjnZXm2jRiFd6Z9-XjEQ-Y68DQ@mail.gmail.com>
	<aUF4fsWwD9BswkFh@kernel.org>
	<CA+CK2bB2mn5b0N9gs1UavYLUQhbpVvdo702oHZa15E9OaZkKWg@mail.gmail.com>
	<aUUYprAotKYMiEs0@kernel.org>
	<CA+CK2bD101cSC_7+OWkMei2QvUVjSaRLy+LboLe8Sz7KS3by4g@mail.gmail.com>
	<861pkpkffh.fsf@kernel.org>
	<CA+CK2bA1kYCf0BwhX3Sg9Ur82nK-7HPzs0sg6xbVWFAJaZLhpw@mail.gmail.com>
Date: Tue, 23 Dec 2025 00:33:54 +0900
Message-ID: <86jyyecyzh.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 949881C000A
X-Stat-Signature: wqp6uya54tcfz664somdy8wpucm7kp4e
X-HE-Tag: 1766417641-823278
X-HE-Meta: U2FsdGVkX18wyVK8jYiIiR4MWft27W768MfWbBsmzBdv61/Cmr2NI8qVdirTO/j5g0UXKKZXnDvAj3Cqac+8FhVSgDafvA1+UdM5OyeksDTaMw+yssjfJu90cw3bWaVkYdOAzYrxIPit95b6uciDpSMBDWvELB2hAr8HMYNTNtv/HlTi20tWwVljN3vBZEIxlqtOUgGaydGQmObK8Op9p+SAYGgQsCIKd8saYIHhpWq1/uTGZFIgmi7ZI0L0cC0yncDIx5FpDKgoiQN3TJhF4J/fTMDJmhMPuhYe+Wk1p2LfhR4MVrl6W2Pxh5giYGXZORGcjJR+2cRZgMLrv3AxiRlrGTyVSygntSeO8AVpMiL6DZ8RjW2tM/eU7TwEY/I4C+q+WHeO70iLx9CdR2amHxngyMyQFREXpPEA4SVsEoBq799UBdfh0S168zHghbZeORLKMphv08hP96tap2HlYmkbkGdYt0trMxaXtvkCffOmn5rMoM15TXllYARBel4zTRGbu2Ih037cepvh9JgBG+wXtJie9YM9TlAsYJM/fyypDtLw0Se63ISDc5Nc7+mLullBrKOb8jOTFgoGYomXqfiFzAHA3TtMFXLFe5DWKxy27w/X1dHqy1IC5XMM0Jh7KcDcJDTApv+d8BXPfbqINQzeZZ4kxdsLjlji+FZx3P/uzskz+Js+oqIZqBpl+Qzr4KKD73s7J1zdE9VSeT/FAI8VJ3RTobBspF8t+0Mmk+ECURMZuZUK+rLLdwKpC9OzLt2OEYz0vWmXhHZK+UCO5wZKwvjop/MDlamAOcZUXI+TC9t3gUyNkQk4vGEWzN+jN98DkUwJcu19EVQXeMegy03SYXfJU394DzZd3/YH/25tdLYZBtNyu0lgI+9/LxY6NIQGQgt0rjtRaZQa2rm0h5xvfc3J2nj7ATsJ9y9MjUW1rOSrdqk23dRDtMKY+wRrdSLJFPciqq4X5Nh22HP
 ohashQBh
 15kdegZnIcEPq+jTec09JWmnb39QC3Gux7FvSpKhsfPIBLQLzLPXbXTrDq/yIUoqKycIe+E+GV1GbP090DozThV1kG2GcNHMcR7lR2ATG9YF+t5EEWxMU+Vu8L6JPs8ZbhRv2d6FThCz+RzPwgPllH5wdnFGnG4gKA3G3bRsmXmVdWE8nF76BswxADM9XPwiNaZ6HVd/osc/S2xWCI6Ib0iZl3oAfDVB04QkA+pm3HTUdjiR4X80bWMcbaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 20 2025, Pasha Tatashin wrote:

> On Fri, Dec 19, 2025 at 10:20=E2=80=AFPM Pratyush Yadav <pratyush@kernel.=
org> wrote:
>>
>> On Fri, Dec 19 2025, Pasha Tatashin wrote:
[...]
>> > Let's do the lazy tail initialization that I proposed to you in a
>> > chat: we initialize only the head struct page during
>> > deserialize_bitmap(). Since this happens while memblock is still
>> > active, we can safely use early_pfn_to_nid() to set the nid in the
>> > head page's flags, and also preserve order as we do today.
>> >
>> > Then, we can defer the initialization of all tail pages to
>> > kho_restore_folio(). At that stage, we no longer need memblock or
>> > early_pfn_to_nid(); we can simply inherit the nid from the head page
>> > using page_to_nid(head).
>>
>> Does that assumption always hold? Does every contiguous chunk of memory
>> always have to be in the same node? For folios it would hold, but what
>> about kho_preserve_pages()?
>
> NUMA node boundaries are SECTION_SIZE aligned. Since SECTION_SIZE is
> larger than MAX_PAGE_ORDER it is mathematically impossible for a
> single chunk to span multiple nodes.

For folios, yes. The whole folio should only be in a single node. But we
also have kho_preserve_pages() (formerly kho_preserve_phys()) which can
be used to preserve an arbitrary size of memory and _that_ doesn't have
to be in the same section. And if the memory is properly aligned, then
it will end up being just one higher-order preservation in KHO.

>
>> > This approach seems to give us the best of both worlds: It avoids the
>> > memblock dependency during restoration. It keeps the serial work in
>> > deserialize_bitmap() to a minimum (O(1)O(1) per region). It allows the
>> > heavy lifting of tail page initialization to be done later in the boot
>> > process, potentially in parallel, as you suggested.
>>
>> Here's another idea I have been thinking about, but never dug deep
>> enough to figure out if it actually works.
>>
>> __init_page_from_nid() loops through all the zones for the node to find
>> the zone id for the page. We can flip it the other way round and loop
>> through all zones (on all nodes) to find out if the PFN spans that zone.
>> Once we find the zone, we can directly call __init_single_page() on it.
>> If a contiguous chunk of preserved memory lands in one zone, we can
>> batch the init to save some time.
>>
>> Something like the below (completely untested):
>>
>>
>>         static void kho_init_page(struct page *page)
>>         {
>>                 unsigned long pfn =3D page_to_pfn(page);
>>                 struct zone *zone;
>>
>>                 for_each_zone(zone) {
>>                         if (zone_spans_pfn(zone, pfn))
>>                                 break;
>>                 }
>>
>>                 __init_single_page(page, pfn, zone_idx(zone), zone_to_ni=
d(zone));
>>         }
>>
>> It doesn't do the batching I mentioned, but I think it at least gets the
>> point across. And I think even this simple version would be a good first
>> step.
>>
>> This lets us initialize the page from kho_restore_folio() without having
>> to rely of memblock being alive, and saves us from doing work during
>> early boot. We should only have a handful of zones and nodes in
>> practice, so I think it should perform fairly well too.
>>
>> We would of course need to see how it performs in practice. If it works,
>> I think it would be cleaner and simpler than splitting the
>> initialization into two separate parts.
>
> I think your idea is clever and would work. However, consider the
> cache efficiency: in deserialize_bitmap(), we must write to the head
> struct page anyway to preserve the order. Since we are already
> bringing that 64-byte cacheline in and dirtying it, and since memblock
> is available and fast at this stage, it makes sense to fully
> initialize the head page right then.

You will also bring in the cache line and dirty it during
kho_restore_folio() since you need to write the page refcounts. So I
don't think the cache efficiency makes any difference between either
approach.

> If we do that, we get the nid for "free" (cache-wise) and we avoid the
> overhead of iterating zones during the restore phase. We can then
> simply inherit the nid from the head page when initializing the tail
> pages later.

To get the nid, you would need to call early_pfn_to_nid(). This takes a
spinlock and searches through all memblock memory regions. I don't think
it is too expensive, but it isn't free either. And all this would be
done serially. With the zone search, you at least have some room for
concurrency.

I think either approach only makes a difference when we have a large
number of low-order preservations. If we have a handful of high-order
preservations, I suppose the overhead of nid search would be negligible.

Long term, I think we should hook this into page_alloc_init_late() so
that all the KHO pages also get initalized along with all the other
pages. This will result in better integration of KHO with rest of MM
init, and also have more consistent page restore performance.

Jason's radix tree patches will make that a bit easier to do I think.
The zone search will scale better I reckon.

--=20
Regards,
Pratyush Yadav

