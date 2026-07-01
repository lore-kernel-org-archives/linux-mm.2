Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA46CC43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:02:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99E5D6B00A5; Wed,  1 Jul 2026 10:02:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94FAC6B00BE; Wed,  1 Jul 2026 10:02:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 893D96B00BF; Wed,  1 Jul 2026 10:02:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66E8B6B00A5
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:02:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB871C1E43
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:02:19 +0000 (UTC)
X-FDA: 84940372398.16.F549B73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 418AB80008
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:02:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nA9q2MeL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782914538;
	b=JNe8bAi8mbohtuSR6qPix+oVLTljOzEVcSJN/kuZstItjRL5Pic6+TKnxon7SJMclK7TiF
	Jn0yoO5PXoL3klM4NB2U4pbIUUlo/xtPxiGTcdwY/PHVWvrz6s7Nv6EFIegDKFkgLR588Y
	CDPYvQIG+4Ixy9mTeHG1JrUK5muzZ+8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782914538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vw8z2xa2mqlN/ZTtjrIIu9+BWOTzccAJAjLflenxRAU=;
	b=NtifgYpLcMwqJg3OeWlw13a2/otzf1FYxYldqSTttfX/BwBrA9eZnvtJqQlzX8PGBlL95A
	Qx3W6d8G+B25znifimybJk0lrobHiELOXptUQ8XwXmvPxcEj+oh+mUHq6/4pHu1Cy9dLhO
	H5XJFabYXbsInAk1AOodUJmm5Zy30ME=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nA9q2MeL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A57E6001D;
	Wed,  1 Jul 2026 14:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6501F000E9;
	Wed,  1 Jul 2026 14:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782914537;
	bh=Vw8z2xa2mqlN/ZTtjrIIu9+BWOTzccAJAjLflenxRAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nA9q2MeL81TpY1Do1QuHzuT24eLoF/C9BZJX7H9oKfTCGIib2/EvSpqgfozqGo2rs
	 twteLmAueEnOz/AMWSiUKUGT+sm07AbmEqtxnVXv0TURtdMILOsKh9PZeo6amDoptZ
	 QMZicEqi/bi9I0JWPqGrMVAMvAuXHubvIlSt0HSd5tRLfCACpolJuNHCJgkv/QaALa
	 SLd53Egpz5oUivT0/Z8ZD36zPbMv/wbN12rVUx26r+AIgbcRQ++QpedYDNfeFnb4QK
	 Yaa15oKL2OlkOnibPKLgikr3AZaj4JUi9ELNReTAN0spczf0xN3QLf+jqjCsnbFgkc
	 0l4GL87h8zfkw==
Date: Wed, 1 Jul 2026 17:02:11 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 1/2] usb: host: ohci-dbg: use kmalloc() for print
 buffer
Message-ID: <akUd4xYXowxLEd5s@kernel.org>
References: <20260701-b4-usb-v2-0-272807df4b64@kernel.org>
 <20260701-b4-usb-v2-1-272807df4b64@kernel.org>
 <4aa114fd-ec0e-4e7c-ab9c-6e9a327b3cfa@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4aa114fd-ec0e-4e7c-ab9c-6e9a327b3cfa@rowland.harvard.edu>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 418AB80008
X-Stat-Signature: cse3sdzabrcqq8r8u1ahutbbwtsyd9rx
X-HE-Tag: 1782914537-458529
X-HE-Meta: U2FsdGVkX18VZ6Fmcv94dWPRbLvVvuloWSPzhx3XuH0AiTTK/K3odQwzV7xSzIoSJsxyBjQ0YwtukRv4o3gCeerAmyK8UD5l56smmQYSOrNnyXIDE/7pLraZehL1V14NetNjCY6pvwnDj9XwXTo5LgG6k9zFNf1PpMemtMn5pT5hE5IsxhHFMWY0EEv8OWvqGjGFNtd4GydHbEBr8behuSefBa92yZADCA0oGy9DB5kD/etAsHVCaLnrcRCLJ3GcUPhHPK81/ccWW7qqZv7gl/edjPFuSDnm6M6HKyzCHRRceXBAH/8fE+f6AyVsN5XlsaMb8lTplAgpFhtv8m6GE3ZWcSTmodRusLkyvlltgGJkqNVI2w3l9dOGArwsZJL43uxcrUdhnMloNA9XVA+YAge7zhOeOI/CDA+Dd+GLX5UWOrazRaqU7YJj64q+liI78+OtAqrH6fWQIfpf63MWCcD5Zm9olXhIrD5uUKBsLwDkIx2htZJ0XbVCteF4OosijRlIEjTgNKxF50PJR5by7NuZja8t8yGzUCez2tTXhJzNGWmJyg4sG/7p/e944nleohG+CeNq/EWODKNpBnSeqXm3ZB52MhJtFHccIsgC0HhbSui5MoCKokEMzGzzGOneJ31FtWJixph7hByCHTJVOQ3wT5qKychOOJqX/Dv6MiEJV4SHOIrXK0mqZHu8kGdAJgpw3M7D3MK+rsswlNoA8tEMWG/lKfoGw2hgCoh/XYJ0WR3kdWMgAwc6psi+kc1qljCJZT3MBRTLYcFQKFxo29eifShaqGckOZZ6M6nTFwAcuUYqwO/uPZbcubEUfuYHMDqAuTO/9U4Hjv+AwQwqmnpLi6zilPLKfE4rt3aZUHAMY4qP1LxITD/GG7LsjmG2jlXyjFb96ygWoA2zKdpnOnNRZE8JBUfwXT3b5CUIZxeDM2nJT3m7K8lFd3z2xoBR0Wq3iLNxUyGWwcpdx9k
 sQah4Umy
 JcdAkxl804WpU9gKfG9sFWIPE2E3/jPLE9Kju8iGSGwE44HuD+8M1ZXD1C1YAUF07lYm+lcMk4X/48zL9OZ3W0lj1Kj5V561PkF2xzhYC78tMDkEGLdKyWxL+0EHl6JDU8+g7AgUjvRnWfmW5cxlk/yF7WXKFtQu3jZANTBY4DqgMG8fkBDF9NWuIsgw81+OUt2UdqiQ+yhJtIm7FeSKV3aso77X22i7Xlc/dZ7PMg/kZRdTCDyZz4BEvBSsssAWz86mSnjPR5Pvkr9qBIJRQvlB/Y0fbk3JZZcw0J9ikURhdtl4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 09:52:42AM -0400, Alan Stern wrote:
> On Wed, Jul 01, 2026 at 12:41:50PM +0300, Mike Rapoport (Microsoft) wrote:
> > ochi-dbg allocates buffers for formatting of various dump outputs.
> > 
> > These buffers can be allocated with kmalloc() as there's nothing special
> > about them to go directly to the page allocator.
> > 
> > kmalloc() provides a better API that does not require ugly casts and
> > kfree() does not need to know the size of the freed object.
> > 
> > Performance difference between kmalloc() and __get_free_pages() is not
> > measurable as both allocators take an object/page from a per-CPU list for
> > fast path allocations.
> > 
> > For the slow path the performance is anyway determined by the amount of
> > reclaim involved rather than by what allocator is used.
> > 
> > Replace use of get_zeroed_page() with kzalloc() and free_page() with
> > kfree().
> > 
> > While on it, drop the NULL checks in debug_close(). buf is never NULL
> > here because all the open handlers return -ENOMEM when alloc_buffer()
> > fails, and kfree() can handle a NULL buf->page.
> > 
> > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> 
> Reviewed-by: Alan Stern <stern@rowland.harvard.edu>

Thanks!
 
> Incidentally, I filtered it out of my reply this time, but on this and 
> previous submissions you have a CC: entry that says <rpppt@kernel.org>, 
> which is an invalid address (three 'p's instead of two).  Is there a 
> typo in one of your scripts or settings?  It's a little surprising that 
> you aren't constantly getting email error messages every time you send 
> something out.

I'm gradually switching to b4 send and this looks like off-by-one in my
manual editing of the addresses.
 
> Alan Stern

-- 
Sincerely yours,
Mike.

