Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 661F7C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:28:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CC596B0095; Thu,  3 Sep 2026 10:28:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D106B0096; Thu,  3 Sep 2026 10:28:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56DBC6B0098; Thu,  3 Sep 2026 10:28:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 230FA6B0095
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:28:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B50E5A4715
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:28:55 +0000 (UTC)
X-FDA: 85172682630.30.C34E3B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D04CC18000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:28:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OE5hfAL3;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788445734;
	b=pdbfdEjWvVWZ/9yZUdci+9gL3aYEMCr6lpWn4+ucBipGQsrA8V/VKcwPEx7FrTlHRl5CDi
	NVtHm7hId0a1GDDNqgtE4Mat/PKXGgdldiptFtFlwC7tTKFo4pBCIW2BNqXDB0wfUCtcCl
	jFSH652rZv427oQOZLZ1C+4SgS+BNiI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OE5hfAL3;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788445734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TE2Me2Qaapw28vfR1oCk/7uMMKpbgxiAwR/j5we1CsM=;
	b=Gcb76A+RFD/2WzsLCzq+0r9+dMv1ISPNZ++239QVTrymGry9CAZhC5LMHsNKGU2jMRZbL9
	2PpBpePHypfJR/6YrHdJfR2p2pBazBWkmM3vsshS2N9qQWGENH10D8tEse4lRqaxGT5jBe
	RRUmuyNLbxFyEt53gBOSPh4WuTccwd0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F219F4026E;
	Thu,  3 Sep 2026 14:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C921F00ACA;
	Thu,  3 Sep 2026 14:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788445732;
	bh=TE2Me2Qaapw28vfR1oCk/7uMMKpbgxiAwR/j5we1CsM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OE5hfAL3bZQXVLclfyoI0zNWbNdoHhR0Y9tgkTkLT4dgLH1aK20LS1exAyJ7QW8TX
	 zBYnmWVvbiVhEqGa+2UFTGrp+zYQ6x6WXAKG+heYjTEmhaywSP+24/clriu4Vg0lWB
	 loFTOURzIqqlCw4bdaKpTPRA9eMqFBX9uLomnhQtGsVZFde9XO15oo49ZveZ6PiQwf
	 qws563/lr7XaqPc++y9Qrg12M2EhRE/9E2U/EpiErsgFI1i+x03OucFkoU+cmoO2On
	 1EG5AGpXI0EMAh+RIKyLEW2ZBvVJ8LzcN0d9zvL6uIEm/3/YRvEU0soOPJN76a3PnT
	 flM3BixQBpQrA==
Message-ID: <3c19c24f-5036-4bbe-b3af-e5eae102f34a@kernel.org>
Date: Thu, 3 Sep 2026 16:28:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
Content-Language: en-US
To: Eli Billauer <eli.billauer@gmail.com>, Mike Rapoport <rppt@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>, Arnd Bergmann
 <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Michal Simek <michal.simek@amd.com>, Ritu Agarwal <rituagar@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
 <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
 <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
 <20260831123937.32255a49@pumpkin> <apaF1HUtJnstuUN4@kernel.org>
 <1729fb06-6beb-f8ef-3e71-47fc3f00345d@outbound.gmail.com>
 <apcPg_y-HsMki7we@kernel.org>
 <9a3d6a08-339c-3315-cc81-46907d0836ad@outbound.gmail.com>
 <apgSCyj-h2xVc2ss@kernel.org>
 <1d7f8806-f4a0-fda0-a361-a011460ef308@outbound.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <1d7f8806-f4a0-fda0-a361-a011460ef308@outbound.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: xudehu4hi96hgtko6dks7q5wusrjc87p
X-Rspamd-Queue-Id: D04CC18000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1788445733-913910
X-HE-Meta: U2FsdGVkX1/bcq+6kjcbXve+RXAzW6MBCoFiW6ozOv4HrD8KELXr9OEeOF/6MLrdT1ykjiwxI5eEQQYA3BbLW1R0TqSQwMvvoBd7nqauzid98A8ACoGVhBxdP++IEfd72m1qcYT5z6X+CylG0s+yww/c+1Gh9976goHZv098H+P7WyA/Nzu0T/33hVo6ErTqUIaVm01tDD7sw6pt64A6j2RRM5GbwQttgsB+CClE8g4oj7STFacgHsIMTnyyabH3jqmk0qzRgy8aXfR8I17D31mbPNcLjddTX0C9H6BKYXMm4fsd0XpAR23mLJ19qGEmKTs1z0kdnw+Rd65eZJSH+7TVikyFyuh/lf86FcOqsb4Jo8e+xtm3Bjo/Fj6qxLuA8rnZjTWVP9DLmnXtLXEp0pyE4Jkee/5cV8Po0FzQHYo5I4X2NZUtoQzlSit2g+N6FGtfcIIXZnP1FyaU9Kotb0JnBaGJCwZgPavPM6ybqW3KrtibqwZ7tgGno8keqPtVkaX98xyPuGV1sjCKT1rRTlqQdG6OPOnQXCxVms4evhS1eG8YtASWQt0cU6z4mb/SWoFeJOpOrvyYS+o5C8zlov8jOrpZWe4ZFRPcGHEOO89oT2GwH3nj+uTJKPGbMeSvzIk9IO+qbgUk09GEp4qohCyg2Nd4MqjreXD6d+OFEZ8s6XPa2EZ4Tq8cQMMV4Vn91X+LE+QP2C48Nn5bLffCRxCy5TiKAZu4A7C/Nj3umv7j76SiUcL/QPm827A4AGyBtMf+I977zVd+lIT1uQ4JwmKZKzMa+a320mLx+S5C9nJY/AmP/F0xBStZJpRw2JZOP6ujgCmJYwdxMtThkfPXoiKHvGJDbqV23EojzCqO0dUuLe42D3TwFopvYhLE+s2DDO89pdonZg6ECYi0PYI61OMhRUWl00Ni2+YJMbc+lpNMiM6ahDOhTR9EpY4e2U+qyVLhIWE5cDBgY6Yrzd2
 Cun84FaA
 0JRx4QhuXqS11mcAm+hrQUoqy4zURloStZQkZtHQ4/t/QssK9ZG+gHQRU6kNlTttVeRd5bJDWTXSYNzumYTyLdQTYNHsm7BUfB4b92uGWHFXqI2wkW6KmUy9YP0Lic77Kb06zo/T/lTzuWHMP0d7wzW6v9y00D3OOpvUXsxqlx7cCNLSlGCuSjKdibGkVRywZVVrk3h36i57Vf3590AWDEnF8ZLpe8cG+bCSJMJhZ8AHPT+ro0xAhkKO0r6U3mUN3HjFN0ZiKx6P7zDNdFRSOj1UIGGpItaDPf4f5lxSpBYGXaaZhXZ0oms2MYYkcoZefErNTOI9C+Cbz/TNJ6Ihm1dtTHUWD39Sj67ryBax5rjewXtRfWiEcIR8dkVQ7roZPPAcV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 14:30, Eli Billauer wrote:
> On 02/09/2026 14:09, Mike Rapoport wrote:
>>> So using vmalloc() may result in a malfunction in the data transport where
>>> the __get_free_pages() would have been successful. This outweighs the
>>> benefit of a somewhat higher probability of success in allocating very large
>>> buffers, and surely the improved aesthetics of the kernel code.
>> kmalloc() still works, just like __get_free_pages()
>>   
> 
> After these few days of discussion, this is what I make of this topic.
> 
> The memory allocation in fifo_init() is somewhat ugly, but this driver 
> has been out there for five years, and no complaints from users.
> 
> The vmalloc() option may be successful sometimes where the current 
> allocation will not. On the other hand, there is a possibility that it 
> will cause real trouble with page faults. Plus, a large allocation with 
> vmalloc() may be a weak spot on a platform to which the kernel is 
> partially or poorly ported.

vmalloc() has its limitations, yes...

> With __get_free_pages(), there is no doubt that usable memory is 
> allocated right away, and that it will work that way on every single 
> esoteric platform. vmalloc() leaves us with "we're pretty sure there is 
> probably no problem".
> 
> So I vote against vmalloc().
> 
> As for replacing __get_free_pages() with kmalloc(), it's a matter of 
> taste. I think that if you're after a buffer that has a power-of-two 
> number of pages, __get_free_pages() is the natural choice, and using it 
> makes it easier for the reader to understand what you're doing. 

If you are only after a buffer (that's physically contiguous and aligned)
and don't need the struct page itself, then kmalloc() is the natural choice.
This is where we are heading with the upcoming memdesc conversions etc.

> Replacing it with a kmalloc() is confusing in my opinion, and requires 
> that the reader is aware that kmalloc() falls back to __get_free_pages() 

Why? The reader has only to know that kmalloc() will provide such a buffer
(up to sizes that the page allocator would) and whether it falls back to the
page allocator or not is an implementation detail.
BTW, it's only at >2*PAGE_SIZE where it falls back. Which could change at
any point and nobody should care.

> in this case. So we actually want __get_free_pages(), but call kmalloc() 
> instead and let it fall back to __get_free_pages() so we don't have a 
> cast and don't need to save the order, and assume that everyone knows 
> that this is equivalent.

Oh right with __get_free_pages() you need to pass the order for freeing.
That's a real practical argument for kmalloc(). So I don't see why you'd
hold it against kmalloc().

> So I vote against the kmalloc() thing as well.
> 
> If this patch is part of a larger kernel cleanup, I suppose my votes 
> don't count for much. But for the record, this is my opinion.
> 
> Thanks and regards,
>     Eli


