Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58041E81BD3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 15:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCC316B0089; Mon,  9 Feb 2026 10:48:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B80016B008A; Mon,  9 Feb 2026 10:48:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6CD6B0093; Mon,  9 Feb 2026 10:48:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1C66B0089
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:48:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28DCE140181
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:48:59 +0000 (UTC)
X-FDA: 84425351598.15.0012B40
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8725218000D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:48:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nmOjylNv;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770652137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4nGYWiGOfNXdVY+uWCPGlOgSj0sGcvKWLRnuu+D02Y=;
	b=P1rZ0WDJK6b0IqaVqNrijlbiQFw2OVHO1a0VSVHTAhZCZLn6xSzoYOdFP4jUVrgaXGca61
	lGXM2Z8DTbmal8bqH3XftH+39Ygsz3dj7FbVHjH+zJOQs6LwNZyN4w0OYQAXcicswJC+GD
	WAlGb81fMa0joVilu5kihQ/hr7f5d4E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nmOjylNv;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770652137; a=rsa-sha256;
	cv=none;
	b=hRqAyaC7XK4mRlqJ8u6k0G7XkRsDYIv7YIxn4Ivmq4VLEAUeKrue85jl3sZVuZtZvybIRq
	4dswBaZZJGXD+9uGKIKwMX6IQ9pOEL90KtbmIAmQVSMDFU6uftZH63n9RmIWNmfWJecYdW
	hNqBPyPqr2XTlE2c0XN4yBjUrhBOapM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=D4nGYWiGOfNXdVY+uWCPGlOgSj0sGcvKWLRnuu+D02Y=; b=nmOjylNvplNe7giU4xqfOfUmJU
	eHbhPCPsVxTvU9KnVqo6OBcmtBhVwhKTegmz1FTX0bzkabYdyeTYS1NF1oFA+ixhLXso+4CSwgm8G
	GpIB8zAK4rgSbf46I/s/9h//HxjyX3oW+H3n/+78v2JrcZqGyle02Xw1CILtpPmZw9ogNAUYlDbys
	l+a8NkdFYBnkcjrKV2s9EatUmDxRICT09+ZXNmTB0pCENAx6vLNMzO31GUqxrFa0EvOI43iF0mQA5
	gxjNtwSKm7kOfAoLmGd1sF4/Xszn7tteYcLH/eFB4h3rBA1SgrljlTzQUvMgRsBKmhEqzEzctpCxB
	z+4+6lRA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vpTVN-00000009iFw-0nJs;
	Mon, 09 Feb 2026 15:48:53 +0000
Date: Mon, 9 Feb 2026 15:48:52 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Min-Hsun Chang <chmh0624@gmail.com>
Cc: corbet@lwn.net, akpm@linux-foundation.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2] Docs/mm: fix typos and grammar in page_tables.rst
Message-ID: <aYoB5JatO60ouaMD@casper.infradead.org>
References: <20260209145603.96664-1-chmh0624@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209145603.96664-1-chmh0624@gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8725218000D
X-Stat-Signature: 3aokrea6c97bgsejrhntctfkwgmc8ckg
X-Rspam-User: 
X-HE-Tag: 1770652136-920524
X-HE-Meta: U2FsdGVkX1+R/j2tMlNNhDCf5ovNj6DOAMTFfgpmwv2Zp8BjuYjzraXqE5+ZZ+gyE6vOjdfc6KQpYNP2F42Y1Prp5O5TiZW5gcqXVpYaMTLh/9EL6ibDAZuHWRdPdx5d0jecF1z1gcmDZxU0oX3a+zSPOwFEe4ScqZi1MYScI4SiUYa2dW64dxkhF3hnaoTcaTLoxwGtQQeaQi+j8E4h7e2VaHkmfcDnP+36ZBOq6hCt7pVdGcJQLMXcLts0NA3lVI6IwgBe+ULUhpHozGA2a+2VkXFmP5Ua5XjitG592d20u3baMZBfjhZwg8TtjrNZe8EjYsn9VRRIbegPP0wK/jcIhNEaopa1eY39uarU++tWXjHhsppUgIRLcMl5iE4yibC5+3ZGPXhkDXTuSo61Rn9rmi7oxE9ZfMQtoftcnuxftyzstT+2ThWkRY+ImNDYnXjVs/4WyhYJCqcbYdpbTcV44x1QaF2bcPYEby3exlWTSAgJ7pX7I/OwdnsBmVfUZzzsH0FIy32bqB9QtE0/eWQhlntE6WahcnGxMSZgBsbRjyQlGkLWxPtTudojW5i3QeLrU6kXxUMYSRnvbZ7ipTgd484lNmLNiFrKjNsu9nQj5sIC1gQ/FfGYcOBuUZ0dJ6tCW4euWu63PrvRP8+F1m7Ssw3h/ZckSkUaDzVr589mHmDH70dZ6Ne8n9IOGHIIWJGeeIz+CUXNfsq2y3PyFKRiZlzQPAoFcTfsNklR6W171Sil3fRwNb2ynDIkodIDtxL1RIzfS9SiLUHCpCwVfQ4Z/HtwkSMhv8CQSZlCyN8EybojPR/zB9UtVjnRLiYJm4aP2X+gCKBy9EhwRm4R9nBOPk9IX+sSBivMZLo2FPUVqIR0iUiJ9MznpTgoO2/e8PiY6xun6LFKLsbWQC8obG1R8UHKHKU4AyEPA26kHpDLrX0A0Q26p75A6soyi3ujyHl8kOPHPTNRbrb5FFp
 LbSXK1fH
 Fvbwpn5QlquzW64fWNBa/UmtEWjDKSKUWAwHlDEMpW3elk/J/7RV9GDKyo0CBjwKh9BEd/No0CMQxwnHof4aieNTXDKqum9/LWAUrFgMIuxWJJJMtK9CdhU7QfE3XuozTVhPd24XoFvkaQ74CoFxDCCjq+A91KEgBDpY315ZyKOcCNfaM28B3Bd1um3a5tq5Z5IIGqYDrz1HqMPX1IKAWHSj9T2NppW7Yb8ndLzldnk3h+RpJlxFpFbPABDScwaqH2w0nvP6ZkB7brmwozwT3tdwgsdSqQgQV7+k2+XcPDDw4lZkWhlMZ78kao6VsKr71OstXputKpBmHdzmyiOikspkdDZwwmLzKAQTCsHv+ORiz10/oSLz0omsQOf4uuQhEL4esl7fLyILIdxirrcQYTL7eLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 10:56:03PM +0800, Min-Hsun Chang wrote:
> Correct several spelling and grammatical errors in the page tables
> documentation. This includes:
> - Fixing "a address" to "an address"
> - Fixing "pfs" to "pfns"
> - Correcting the possessive "Torvald's" to "Torvalds's"
> - Fixing "instruction that want" to "instruction that wants"
> - Fixing "code path" to "code paths"

It'd be polite to cc the original author.  Added.

(also see one question below)

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

> Signed-off-by: Min-Hsun Chang <chmh0624@gmail.com>
> ---
>  Documentation/mm/page_tables.rst | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/mm/page_tables.rst b/Documentation/mm/page_tables.rst
> index e7c69cc32493..126c87628250 100644
> --- a/Documentation/mm/page_tables.rst
> +++ b/Documentation/mm/page_tables.rst
> @@ -26,9 +26,9 @@ Physical memory address 0 will be *pfn 0* and the highest pfn will be
>  the last page of physical memory the external address bus of the CPU can
>  address.
>  
> -With a page granularity of 4KB and a address range of 32 bits, pfn 0 is at
> +With a page granularity of 4KB and an address range of 32 bits, pfn 0 is at
>  address 0x00000000, pfn 1 is at address 0x00001000, pfn 2 is at 0x00002000
> -and so on until we reach pfn 0xfffff at 0xfffff000. With 16KB pages pfs are
> +and so on until we reach pfn 0xfffff at 0xfffff000. With 16KB pages pfns are
>  at 0x00004000, 0x00008000 ... 0xffffc000 and pfn goes from 0 to 0x3ffff.
>  
>  As you can see, with 4KB pages the page base address uses bits 12-31 of the
> @@ -38,8 +38,8 @@ address, and this is why `PAGE_SHIFT` in this case is defined as 12 and
>  Over time a deeper hierarchy has been developed in response to increasing memory
>  sizes. When Linux was created, 4KB pages and a single page table called
>  `swapper_pg_dir` with 1024 entries was used, covering 4MB which coincided with
> -the fact that Torvald's first computer had 4MB of physical memory. Entries in
> -this single table were referred to as *PTE*:s - page table entries.
> +the fact that Torvalds's first computer had 4MB of physical memory. Entries in
> +this single table were referred to as *PTEs* - page table entries.

I'm unsure about this change of "*PTE*:s" to "*PTEs*".  Is that special
rst syntax to keep PTE highlighted without highlighting the 's'?

>  The software page table hierarchy reflects the fact that page table hardware has
>  become hierarchical and that in turn is done to save page table memory and
> @@ -212,7 +212,7 @@ threshold.
>  Additionally, page faults may be also caused by code bugs or by maliciously
>  crafted addresses that the CPU is instructed to access. A thread of a process
>  could use instructions to address (non-shared) memory which does not belong to
> -its own address space, or could try to execute an instruction that want to write
> +its own address space, or could try to execute an instruction that wants to write
>  to a read-only location.
>  
>  If the above-mentioned conditions happen in user-space, the kernel sends a
> @@ -277,5 +277,5 @@ To conclude this high altitude view of how Linux handles page faults, let's
>  add that the page faults handler can be disabled and enabled respectively with
>  `pagefault_disable()` and `pagefault_enable()`.
>  
> -Several code path make use of the latter two functions because they need to
> +Several code paths make use of the latter two functions because they need to
>  disable traps into the page faults handler, mostly to prevent deadlocks.
> -- 
> 2.50.1
> 
> 

