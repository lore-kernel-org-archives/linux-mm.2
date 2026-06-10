Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E85BACD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 09:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1D866B0005; Wed, 10 Jun 2026 05:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF54D6B0088; Wed, 10 Jun 2026 05:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0AFA6B008A; Wed, 10 Jun 2026 05:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FD6E6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 05:54:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 19CCD928EA
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:54:10 +0000 (UTC)
X-FDA: 84863542260.29.34EF0DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 52F6020004
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:54:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Nrslpx/I";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781085248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOOcC8vMo1WFVxSe0Q2hEdY4dvsi3HRkW8edOmhhaUY=;
	b=M4dB7SCQu49BUVnVgrw7PAmkSJIKdfs35/tmlbpK5J2L53Er9touqQyiuT0OuH2bDzYFvu
	O+Lnr0wlldH8blgsfuKtOAhdpqEYXOXLam4ab9/igPdDZiEtIdN2mPjXlSB0T6P7s0aSil
	3CHOnA7Aa7ge+JdDMxtfaeJixwQRy1k=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Nrslpx/I";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781085248;
	b=DRAYQCENOcI4RwHnJpwGRIfFhk3iNiinrbQ+/ZnBhNOaJFM7/VtNNCxcWsSWOhh2YOgqtj
	py3Nrq4rOVPxe2Xb0QOA3r7ezqSH4k6ozSYbDfOXsuzXNPHQUzMohRRP0SUkmvXqwI44cw
	Pw1kdFME4QTzwzThfjMUOPNY/ofYVKQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B6D766001A;
	Wed, 10 Jun 2026 09:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD371F00893;
	Wed, 10 Jun 2026 09:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781085247;
	bh=AOOcC8vMo1WFVxSe0Q2hEdY4dvsi3HRkW8edOmhhaUY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Nrslpx/IDtHzrfEr6PGCpfnTV5w0wOhuIa93SI6qWJhfb0DJjsGLY0GrIJMb38TF9
	 5fdwRdTy9CcTc2RJoQPrvhc+U2n21psKLy0r21v2JMutKIDf9mQxssI5R0lbNCdqkb
	 4igKAcZHoSI65ZP97JwqonD0iAoXumtbwD4ytQaM9yOrjUEAw1ceeXikWE2w/h7qDR
	 C3JLWj0hOnQiju/bIiul8zGY8jTAhkeW+4s8FvCwphsUYNLFRPcDjNwwVUiXPGAiGo
	 0X9vaicMShGUwqSusinGGPfgY3BG+Y9JL21r3yudLPjWD8d7asyTxhOjjG0ELui978
	 7tZJkRRwInc/A==
Message-ID: <f2b5189f-10de-4685-97f3-6ee08d159743@kernel.org>
Date: Wed, 10 Jun 2026 11:54:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1] io_uring/rsrc: add fast path huge page handling in
 buffer registration
To: Christoph Hellwig <hch@infradead.org>
Cc: sw.prabhu6@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, dave@stgolabs.net, dongjoo.seo1@samsung.com,
 Swarna Prabhu <s.prabhu@samsung.com>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, Matthew Wilcox <willy@infradead.org>,
 Zi Yan <ziy@nvidia.com>
References: <20260608062937.804758-1-sw.prabhu6@gmail.com>
 <c924fb59-be47-4fa5-adbf-a50a831ccd7b@kernel.org>
 <aikBIESiJftxBdfL@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aikBIESiJftxBdfL@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: th6woo68h8db1z9arp4cy6hwbwaq5mdy
X-Rspamd-Queue-Id: 52F6020004
X-HE-Tag: 1781085248-278810
X-HE-Meta: U2FsdGVkX19c1zJeN6jwsb43F+/JCh19b2BI8gQSUG67CBddTWyJ4AkfItQt1FlgdqjiikQv7mq7wGjaGkC8X9vNGuFOjYAanp3XrB1Xx+ss2SVnp1FEl1TT2lzKhyakpyXnk7zex8/qkMtIXFy6flKkOpxppG9UlG5Jyw9mFxC16BKFMM9oZTVkfrbkAWDw1xiZg3P5WKEqjjB2U38Tw+abK3AtdjMG3Ix/ua1dqNH21mscTcUTO74oupmCzfE1GoMhgB1KT2ruviRcK6807A9Uh+acug6mWoZImtNnNKBmkDk6AL3ZJVyrQaz2flxADhSnd9B8pE3LnrVWGsCQwdyjOBCxzhK9Sr5DXLKWkvXXMft5psIJs5Tn1SHk8zVV6DGH3c6uKTorN1GhGb33Gbjgn7hm1g5CAfbMNnGTGwZc+nilnfJTqMZFGKM2D28cysMLi5v1gJBIHwssTwRhgqWJHql6jpamuq7EWhLuZh4l+yvU9fD3IOqzSsw94PUE1bHgkM2YCkxHj9xF2OvcrF26egEuLLaaT94hb4LORMA0qibeg8+cnZa1Y/cU0mntmVKIDVrcfCx9fC7pM70/DEZxSoAORlWCgAknkdZBEGuXscr44EwTnT9AbLBpMjYJbBiuNM2rdDT++EP4MPWJOL+XDPozfQYmvgBBrhv7fgq1WC9QXi5yTPZjMs5/y/WGySZMzI/AecfxLhFpF/QiERtOtQSH9koFZGZ/I8v/GpNUHSZmA0axjze8k3Oa4BjvCtuRG4PDiOx4SOmBXxwjBkOTbUV5B0WPRvr7DxuYfvqDaLteHZMI1fTRv8xeACI+Kn0RWLL+lJZZfDDnIrjAVbwWY9554BLRtvlWEExPo3yGfb+LrO04nRpA4GI6BX9vUnHXiqtpDCaMFi7gOJJdTUqdGG+w1G4jpoFVKVVNe4EHRt9rDt7UUa1YS+IMDl0l4bYphHSUOf/BP1XKp+E
 EfTJaqRm
 2ekfcZ24ld/duIBlE+3LgcdnMeYYMEWn0xuCJUPGLb7gSYUqShDxDXmseB9jx8TwM+izilxEM/AahrLAz6YclVfJa1GngrY+amBMbH1GwDQDtaDQihzJC6n7UWgl4qEXmRXUOwHrBRzvHDqzGgPyr1Tk/VkQhcajne/evuG2crdlMrokaeUhR5jk/YdwI/5cgxy8BjQlBhRDqqBD8aOPq7eqz2deKi5VegQmKvZVop2iq3t064rS9nsHnrR5DvGlxzvwqC4mayLyuWOGxuU2Aaa2mb2nY3w2tj+dQ9BMghLutlIc6KujQeJuJo29EWNJoPWc61nqbuWFCe5gxZ9+5UcbyBpaMGn42n2VOFyhJNi/3bXBxt/nFyUU/NwoPWc8UwOfLUW7QGXZ1ZH/y3msXdzT+ocZtkQXSfP9eJeGExMPWuZo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 08:16, Christoph Hellwig wrote:
> On Tue, Jun 09, 2026 at 08:36:43PM +0200, David Hildenbrand (Arm) wrote:
>> I really don't like arbitrary GUP users to starting to special case hugetlb
>> folios, and making assumptions of how other pages they pinned look like (IOW,
>> how the page table mappings actually looked like).
> 
> Me neither, but the current interfaces are kind forcing them :P

Yeah :)

But general rule: if you're outside of MM core and test for hugetlb folios, you
are doing something very wrong.

> 
>>
>> Ideally, we'd have a pin_user_pages_fast() variant that would give you a list of
>> folio ranges instead of individual pages.
> 
> Yes.  iov_iter_extract_bvecs and thus the block direct I/O fast path
> would instantly benefit from that.
The tricky bit for such an interface is that, soon, some pages won't be folios,
but we could still end up with non-folio pages in the address space (e.g.,
vm_insert_page()) and have to pin+return them. So using folios is not future-proof.

There are some long-term plans on providing an interface that would abstract how
you refcount something you GUP'ed. (because, some pages we GUP in the future
might not even have a dedicated refcount, all still fairly unclear). But it's
all not really finalized I think.

For now, we could expose a folio+page/offset+nr_pages interface, where we,
long-term, would not be able to return non-folio pages (e.g., vm_insert_page())
and would instead, in the future, fail the request if we stumble over a
non-folio thing in the page tables. That sounds reasonable for now.

Another solution would be, exposing page-ranges (e.g., page + nr_pages), whereby
we'd say, that all pages in a range belong to the same compound page, and that
we took a single reference for all pages in the range. IOW, page_folio() would
for now be the same for all pages in a range.

As soon as some mapped pages are no longer folios, we'll likely have to modify
plenty of drivers either way, that blindly cast pages to folios ...

So maybe a folio-range based interface is good enough for now.

-- 
Cheers,

David

