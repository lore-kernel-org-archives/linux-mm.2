Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA9EEC624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 17:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECADF6B008C; Tue,  1 Sep 2026 13:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2416B0092; Tue,  1 Sep 2026 13:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBB0D6B0095; Tue,  1 Sep 2026 13:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B1EFC6B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:46:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C8EB404ED
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:46:55 +0000 (UTC)
X-FDA: 85165923990.14.6D31BC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 815DD100006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:46:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MM8rdnOG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788284813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Di7QTynNdwrefgWArR8x/gWtyxCUPTHCJ3Ml9Ox/wmg=;
	b=lZaDzrsAhlaffrXneRcxEunJxsCxtDEIcyNaCB/vUnlpPnjCbWj6vEH+KikloCRQn38oqE
	pMoJkZaSucpfnO7DVdNzlVYRDBo3ModAN+yZzR/8G/0+0cuLOJ1H28JS2in5zuCCmDbodw
	1YMaJw9N0Ea+ZQHOTq9U37TmRIp9ipo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788284813;
	b=vJ6bGNkF8VtetYxt8UoCB4ia/jahpk5zlZtFtR4jdGip3btygBUzpH3OAX7a98agjtb7qE
	pB/1DBTNT4NfBVNwSbnr/tNa0XVpyEp/tqjNe+hGFNWuHdwDks5/JkfIMh66XMkEInkmhQ
	0CB4DeA2frSuLeI7pLPoXGgaUIlZ9BQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MM8rdnOG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F7E940A39;
	Tue,  1 Sep 2026 17:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3001F00A3A;
	Tue,  1 Sep 2026 17:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788284812;
	bh=Di7QTynNdwrefgWArR8x/gWtyxCUPTHCJ3Ml9Ox/wmg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MM8rdnOGJ8NlTTKLBF+ZWl4lOqzsu33URdTXUoJAJpM+r3LMdEnN32gB8oaIOp83P
	 z7fAnqDfQSf6tUhZgpY4nWuMOnOy7OfNzElYFAYlsMu2dcBVtpp2mqJUbXPsNkvPxV
	 11dRQjJ7g1neo95rCP6rPnh8KcRaPxitPJjADq9dyLpOgxG24g/VuDYURyR5Pqy8Eh
	 COgDziYII4r37BFKQYvTyK1UzqfV5hd2eo61ezLxLtw6eNo/8Hp7OJIVWxoGYK7+t9
	 7rtvqZ/IE+uWuuJPihziw49O8FbDUnDc5Ycrl6Ydu8kO3O5Kd29Z2yQnBOLRiTMiRZ
	 Mv+NLrts5eGrg==
Date: Tue, 1 Sep 2026 20:46:43 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: David Laight <david.laight.linux@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michal Simek <michal.simek@amd.com>,
	Ritu Agarwal <rituagar@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
Message-ID: <apcPg_y-HsMki7we@kernel.org>
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
 <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
 <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
 <20260831123937.32255a49@pumpkin>
 <apaF1HUtJnstuUN4@kernel.org>
 <1729fb06-6beb-f8ef-3e71-47fc3f00345d@outbound.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1729fb06-6beb-f8ef-3e71-47fc3f00345d@outbound.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 815DD100006
X-Stat-Signature: 68dsrr388ai56dmy5suah7e3xcamoxyi
X-Rspam-User: 
X-HE-Tag: 1788284813-824252
X-HE-Meta: U2FsdGVkX1+euS6IuovpGXRcrBBc8anY1aNCGsSJRNuydLk1HY663kouo5EsbcOVM7vjhg5cAMldSxHzcE2qCv1RVCiF+F9BEfr1mLGg9wd8iOzG+D1Ih6+iNdaPAQTScKtpZ2DAjTQcB9sKVfxmueS1D310AKEfWE7e6YElTGo4RjDtBexAMw5m/p6ewJYYJwJT8Q8A3oPLWSLC8ARckp2bX66QnIdGqpolu7ojT58AySaNbrjisbKJRoVXq7s028nHiRWDKQJZk635SZ4uMEybnoIDFpYVEc1wDHr8iYhsurL+xlCMcPtTSK9U5xDBXz0AnxqAk7tNcYVB5Yo/l614CpIZU3qeq4R8fJjlM8ZyCT9tz0XRyIbtq8o23ZUJu9A5KxB+Xa8RCqRNfYCxRjtdJZAJBSjk8C618v8ZXlJ/LxI6iLYtoAWSbYayaBVIGSRnK8w0Xf2SGygV37/l7Q3F8Y1ne6vbbxIeLP+09DauVwskAoWTi+3GwzfvHeobpIs9OMF4/jY7KEoFYF1D7Eqg46nbCZCf7D0jjaeCAR/4NXwpr/hshXOlRLzVRAPTL3KuqovDA1daqf/ZdKTS+owPusbBAoqUIBzjYDSy9n/7Srg/Glvk618/VaHHbheeZvdSiDHlqUSi6hZCXTBMxbEyz03hXg1PeCqnfnQ6JxY2kRV0izFepVRuWxWc8Ykh3sTuy26B22nkzOxeVe/pj4HwGw+eerl6n1mYE3vHlT4ovLW/UenjVy/ojbArFRHISaUE8MkJSCHjfRsckr12U69gRKNzB2Thy5cHcG8Qp9kp7uGn/F/7/DNClbpT9gKnGV5w842LMwaiBUumAh1j6uQnc1YDCWK9TjnTIJSE+AdPMV94IZQDSvy+lZE5tpsNaEXkujI7fLwlqP0M+MA0S6TLenm+1PJts7BvdBDEhMMSUBRpEHIIazP8K7gV1vIIgFeZDBVSqZl7xxXzZ1J
 Fl8EOAOw
 UaQkvHvaRHs8J+QHmu64Z1U2CHnOiEhosbELNDBteVk+OyeuOhU/RBG22hDszdhzCrRPCgZZLeisH+scOzjG9RTua9uv5JjgktDKrleRvnvPVJFuXRRVO0bdSRrQZpnScYEl1M7P1mHjId1wzQ8Zv/TrHGKYVHYqjxvICAl4jxqfraHK4l6Ac9nRyMeU6CQnbsX7tSeD7kSMWyWbSz/01Vm43ACUf2SgpD1kglphh8rWX9lV5skgXizYJtqdEk5b8CpaOPsuosa2dsd1BLki+mSurOjyOjCRKChAwiW+V41tA+xpRT6bWDIqWx2AJ5yUpNycWIcrwVrk3zgOrA7DGT6DBQsC4KaT/gwBhG+J0WU7kKvB0h19zkh5uDwsMf6UsUp6UGWSMImuXsWMhAvb9fIKtBCh3C5LLZJGSyHSMKfV1FwwrXw5jqeBOtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Eli,

Thanks for the detailed explanation!

On Tue, Sep 01, 2026 at 10:44:20AM +0200, Eli Billauer wrote:
> On 01/09/2026 9:59, Mike Rapoport wrote:
> > > Would it really make sense to allocate the four buffers separately?
> > > And/or use vmalloc().
> > My understanding is that the buffers don't need to be physically
> > contiguous and vmalloc()ing the entire fifo->mem in one go should work.
> 
> vmalloc() is an interesting point.
> 
> fifo_init(), fifo_write(), fifo_read() and fifo_mem_release() implement a
> FIFO in software that the XillyUSB driver uses internally.
> 
> The memory for this FIFO is allocated in fifo_init() by calling
> __get_free_pages() with requests for up to 64 kiB. With the maximal total
> buffer size of 256 MiB, we have a possibility of 4096 allocations into an
> array of buffers. And if __get_free_pages() fails, the size of each buffer
> is halved in the following attempt, which tries to allocate 8192 buffers,
> each 32 kiB, in this example. And so on.

With vmalloc() you'd get all 256 MiB in one go if there are indeed free 
256 MiB in the system. Unlike get_free_pages()/kmalloc(), vmalloc() does
not try to allocate physically contiguous chunks and it's not affected by
fragmentation.
 
> This mechanism with an array of buffers complicates the implementation of
> the other functions as well.
> 
> So why not replace this with a single call to vmalloc(), possibly asking for
> 256 MiB in one call? That would mean simplifying all four functions.
> 
> When I wrote this driver back in 2020, I avoided vmalloc() because Linus
> wrote "vmalloc() is NOT SOMETHING YOU SHOULD EVER USE!". (See [1]). He also
> noted that vmalloc() is a restricted resource. But that's from 2003, so
> maybe things have changed since?

I believe so, we have kvmalloc() that falls back from kmalloc() to
vmalloc() for larger allocations and we do have about 1k callers of
vmalloc() family.

In 2003 the majority of machines that ran Linux were 32 bit and those had
limited virtual address space. And yes, vmalloc() is slower than kmalloc()
or get_free_pages().
 
> Questions that arise in this context:
> 
> * Does vmalloc() guarantee that non-pageable physical RAM is allocated when
> it returns?

It's not pageable in the sense of demand paging. Some architectures lazily
synchronize vmalloc page tables and this can cause page faults that will
take care of the page table synchronization.

> * Can copy_to/from_user() be used with memory allocated with vmalloc().

Yes.

> * Is vmalloc() guaranteed to successfully allocate memory in the same
> situation that __get_free_pages() could have been used to obtain the same
> amount of memory (in smaller chunks, as with fifo_init() )? Maybe they
> allocate memory from separate memory pools?

The pools are the same in the end, vmalloc() allocates memory using page
allocator, just like __get_free_pages(). The difference is that vmalloc()
does not try to allocate physically contiguous chunks, but rather a
collection of assorted order-0 pages.

This is actually more likely to succeed than multiple large order
allocations.
 
> And most important: In what way, if at all, is memory obtained with
> vmalloc() practically different from memory allocated by __get_free_pages(),
> if it's never used for DMA?

The memory is not physically contiguous and cannot be used for DMA.
Some accesses may generate a fault to synchronize the kernel page tables.
The memory is there, but some processes may have not-yet-synced page
tables.
The allocation itself does more work and it is slower.
 
> Does the API offer clear answers to these questions?
 
Thanks for the detailed explanation

> Thanks in advance,
>    Eli
> 
> [1] https://lwn.net/Articles/57804/

-- 
Sincerely yours,
Mike.

