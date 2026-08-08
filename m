Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 583F9C55174
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 09:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 099C16B00A5; Sat,  8 Aug 2026 05:02:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04A976B00A6; Sat,  8 Aug 2026 05:02:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3556B00A7; Sat,  8 Aug 2026 05:02:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C9CDC6B00A5
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 05:02:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5EC6BA01B5
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 09:02:07 +0000 (UTC)
X-FDA: 85077510294.09.9212EC2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id E56EA1C0008
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 09:02:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=W7lzaSx5;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786179725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enYcDXlR0yhFbDH+2aaIlGrTlCM5GxSFhS1h+rPoprw=;
	b=iIR0At/cQWYS3TLhG7DgT/dUV/Z7QIfVg9Px7YjKFBBHz7fSYh1UEMcuSRit1JXK+we9yT
	Hr8JUV9d0HK1quFmG394I8k6SguQ6pg9ogfx2cTsdb7wJO2yrt1juQ5DJJkLI6BXHooJqU
	dem3sjlMiX1STxFFwgAvY/Wf14AH3N8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786179725;
	b=z4//1ImeVdHSzwRI3bTGMSOHltZuLPOgVe1oF3UUGWiRNBarlQz897L2wZVwgCzfZ1Pb8V
	0Kh8WwO9IUFN+C3lrxtz7nY9bsW3FRqxW5Pe2VOAFfI3ifB/EmjmlIBbymE7KfEolQAgfr
	Saqdx++719qQ3uwMbsT2hmPvQ5awEYs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=W7lzaSx5;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=enYcDXlR0yhFbDH+2aaIlGrTlCM5GxSFhS1h+rPoprw=; b=W7lzaSx5ETUEASip6Ojo9Ht0Dc
	mxlUcZ4DHwrIX3MCzn3+YVbUZYq94+ldl6ZmNuS44kPKc4YkZTPbevAWLnj/C6yT4/eu6F1Yupv8S
	ESKVykga7hYQkc9PvY/+DXMsMW2GNEnZWSe9K3tnGLzgrf2Uq55fqVdGaG3b8APwudxYr/WbwLKDT
	P2bz7OZ6e9Vfc+dS+UGkby30gs8f7RjRPSJqMqpkvky+2gcsLi+Q7MZyJywsYhVgYskgqwekfjriQ
	CXWbYHe3uBXl5MQS51Be2b6KQ6E/uHaKkowZW1cQHZQaureEifZLGeKkvw8dKiW7qysZEQxqUQFxU
	kVpRPlHQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wsbcQ-00000004vh6-15Hy;
	Sat, 08 Aug 2026 07:37:22 +0000
Date: Sat, 8 Aug 2026 08:37:22 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com,
	Liam.Howlett@oracle.com, ljs@kernel.org, david@kernel.org,
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com,
	aliceryhl@google.com, arve@android.com, cmllamas@google.com,
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org,
	davem@davemloft.net, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v4 3/5] mm: Add RCU-based VMA lookup helper that waits
 for writers
Message-ID: <anbcsiwuxE-8Edgc@casper.infradead.org>
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-4-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806200548.3124802-4-surenb@google.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 856zb1od6ufi5ykhb1efj59kr4fnrhd5
X-Rspamd-Queue-Id: E56EA1C0008
X-HE-Tag: 1786179724-631682
X-HE-Meta: U2FsdGVkX19JvEap5JzmKyNJ0hr1oDQxPjGYaOQxCb30U7wXKHIfhhHGOJYnKDsiydpOZKerU6K3m0nJLAjuOBq/tz88X7L04OUFchpjtXy48l0RjRru8jMp4/nN01ffyxWVcDvQe0ZkMHwDASmejMuNwE30nGhEkhxbs5JioCj/Bp6c/puSqJbgDfplGo7/SimN1BJJMsjyBIRk1mQFAvDut67p7mxHUKOtGHWqJNK1n6rrMic84y+6V+uJF/Lfmz8HESgkUIpI0lnYi1g7sjsdGEvUbC8wnF1bNttnAdjFrzX6SHGBEjp49f7+dC9RQQ4FF1FNAZWsd+dut1efZe1jI5REP+tde5wTV40QdPKzM9MdGvD1m/HCkYh5SJU1NhmXLifKMpqCAqyQIxCcLyBqmZObXDeWG82Ho8hbtZBLL9x6E/8ZDVcfPpfmgGX7lcTyatDa0+LId2Ifgi9h1W6kS92RT06SWtO0zVyzboJUrYEKT7yb0QT8R+cGv8BmXNAwWcrSe/TuBepwUkXV153sbKSKVH0zRUnvUIw3+axLM0I1NdF8y7O4tnRW0atol5clCD1CvDq1GEc/2WqeYIXrPn4Q8M8ow602LzRHXbOL2BFdlF4Go42Mynmsw0p+XLq+3JDSXRNMB+kGy9zOinwS0WlE05b2rfyTS6JTC4V/CKhgqqGThOe9u5V+4aPo6K6Gt33fTDCGb1LDLcXHsgI8HIb85pqbkudo7hQaoGBDk9WVyFh7fcs5nWLbIpn/00BnsnkIRDn6/2VSLamlkOYdzLweZ6peMgrdytGIstDxOJ7uAfhqDouLdhvQT+GIG3XGfblFZFrHwXLHmhinlYFId5E+hwsST9ftvq9xiPYdnrNcHYxGf6PkH/kfw7VKAFBLcmB7KSIY/AodqN3acd9Rb9RrwvHXO8mdYRfquCAGvl3d60JeL+oOugPa1bOB4L7+myObNUNzVlCSQb6
 Jkk659c2
 ElY3OJdDfOzAcztmURRedcXbNxLY6Izp48SabsBZHMaKKuWzqcKfo7CCWyh5uqzTvgV4iZ+DQg97DNlJd97woMyNWSKBdMN5N/j52Belb1f+6ddFnAXnSvPArhcEOtElKGigTuGtTRucXCoZ378NsUPGh76G8kif85VnmJSC/GG2KkT48JvFFTYPV8fDfjVIwcwSOiHGdIBZexrnx+BeBgkgjcOAPETfizZwp7PwvF5wkSfkCRixCB03LT451vZyolywlcvYnFBfzqQGfz10rIGyxebMvqnMGaFTA5ERwpVX7CDIlcKGNJWkvnqkYfXuZRjL2it2hCGPIsVky/0H7kYVLow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 01:05:46PM -0700, Suren Baghdasaryan wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> == Background ==
> 
> There are basically two parallel ways to look up a VMA: the
> traditional way, which is protected by mmap_read_lock, and the RCU-based
> per-VMA lock way which is based on RCU and refcounts.
> 
> == Problem ==
> 
> The mmap_lock one is more straightforward to use but it has a big
> disadvantage in that it can not be mixed with page faults since those
> can take mmap_lock for read, which can deadlock when mixed with nested
> page faults and parallel writers.
> For example:
> 
> 	mmap_read_lock(mm);
> 	// Another thread does mmap_write_lock().
> 	// New mmap_lock readers are blocked.
> 	vma = vma_lookup(mm, address);
> 	// This deadlocks on mmap_read_lock() if it faults:
> 	copy_from_user(address);
> 	mmap_read_unlock(mm);
> 
> The per-VMA lock can be mixed with faults, but they can fail and need to
> be able to fall back to the traditional way.
> 
> == Solution ==
> 
> Add vma_start_read_unlocked() - a variant of the RCU-based lookup that
> waits for writers. This is basically the same as the existing RCU-based
> lookup, but on a failure to lock it temporarily takes mmap_lock for read
> and waits for writers to finish before locking the VMA, dropping the
> mmap_lock and returning the locked VMA. This has some advantages:
> 
>  1. Callers do not need to have a fallback path for when they
>     collide with writers.
>  2. It can be used in contexts where page faults can happen because
>     it can take the mmap_lock for read but never *holds* it.
>  3. Its fast path does not require taking mmap_lock for read.
> 
> Basically, when applied correctly, this approach results in faster
> *and* simpler code.

Maybe just write a new commit message, because while this is a useful
primitive to have, (as evidenced by patch 5) it doesn't do what this
commit message claims.

