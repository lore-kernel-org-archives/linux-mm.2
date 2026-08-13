Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35B32C5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 144B66B020E; Thu, 13 Aug 2026 04:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F51E6B020F; Thu, 13 Aug 2026 04:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29536B0213; Thu, 13 Aug 2026 04:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D07C16B020E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:51:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34B4CA0573
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:51:17 +0000 (UTC)
X-FDA: 85095626994.04.C64C2DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8801C120007
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:51:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nWPYIb/p";
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786611075;
	b=AGobDWw6jeP2AVOPWnXauDMI4gjQDWe32mN+f9iOhwdl2B4llS5BNYEX2NN5U1H9Nr1H5A
	PtwtYLVMS+ni/8OyI7Q14/KJtfCjGBNxgKaJokSXTXEHz2UHXAbPZzKhO/jCgUFX1N3z6w
	xX0nAd9OI/CAPv6mCygNN62BJObpDXU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nWPYIb/p";
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786611075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s15YMfOwxWEvAnRRd4hU5g+v53XbUCKXoccrAXlR3Xc=;
	b=OYwJU98Bo+DCSYmpsrSR95hCdQf1NHIHiOAriuZenYc/KmoeFRkzn61wlGx7xfjzcTtp7M
	jk1afJm7pDNE4y96Os+ZSGNhzaU+1rbz07ogoaUmrnB6NPkEhAbfdwZNNsiudXpSBDv6Th
	lU0OqKdRfmoOalzEXUwFOFnTKCAK528=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA23E43B65;
	Thu, 13 Aug 2026 08:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6A31F000E9;
	Thu, 13 Aug 2026 08:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786611074;
	bh=s15YMfOwxWEvAnRRd4hU5g+v53XbUCKXoccrAXlR3Xc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nWPYIb/pH6H6oqPWsIPtUjNPbp07s6id5XEc1hMPQDMdeKAuZOc9j8PNXJxfz33n6
	 G5IxTmlmRhScRf8Rtc8d+7pqOLpyuMN6lUMOhfbf5lTZefaXpD7B6E3/5v9m1xTNDp
	 m+i2jwmBGB+jr7V/SNZYlKjYsTuYkARctVNycKJoDlAUIXVy5KJ41TZo8kC+RuWTco
	 vSV1Z6V0YTo37RIgaBT+JA47S9pvA5P8NoFDBjXkG5xW+1Ddj3Teg0/cbcV7yJ5tKj
	 LOuXPzmtuHuqAqKA4GyOzCA7qcxeXCTdSVdbHMX+vPJboJijElcEOPP7vokRjodtrn
	 NPX5Z2P3YnCig==
Date: Thu, 13 Aug 2026 11:51:00 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: ljs@kernel.org, akpm@linux-foundation.org, baolu.lu@linux.intel.com,
	bp@alien8.de, dave.hansen@linux.intel.com, david@kernel.org,
	den@openvz.org, devnexen@gmail.com, hpa@zytor.com,
	iommu@lists.linux.dev, jgg@ziepe.ca, jgross@suse.com,
	jirislaby@kernel.org, kas@kernel.org, kevin.tian@intel.com,
	liam@infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lists@steffen.cc, luto@kernel.org,
	mingo@redhat.com, peterz@infradead.org, pfalcato@suse.de,
	shakeel.butt@linux.dev, stable@vger.kernel.org, surenb@google.com,
	syzbot@syzkaller.appspotmail.com, tglx@kernel.org,
	toshi.kani@hpe.com, vbabka@kernel.org, vishal.moola@gmail.com,
	will@kernel.org, x86@kernel.org, bharata@amd.com,
	Ananth.Narayan@amd.com
Subject: Re: [PATCH 0/5] x86/mm/pat: CPA fixes
Message-ID: <an2FdPPOWT50lLD4@kernel.org>
References: <anXvODEvV4f_Taj7@lucifer>
 <20260813055544.25567-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813055544.25567-1-nikunj@amd.com>
X-Rspamd-Queue-Id: 8801C120007
X-Rspam-User: 
X-Stat-Signature: iuqsdfhpyf9i5cugxai3iumfn6b7u916
X-Rspamd-Server: rspam06
X-HE-Tag: 1786611075-247358
X-HE-Meta: U2FsdGVkX1+Lv2mvkQqcWqGIRAd0hDl6hZYE4Z4c37vHbdRU7UWwoxxcCqcBASzOlafDxDbQu9zQiZAx8P32os6Pqj6TbN1Z5HENgY/Gm2OOcYjn8QeKcySdEpnHw9B4+zGddXF0BbRXUozXWUSGaTGynVfv3Eo1eeNSmdHsPZ+SrvEJbmH1lCUiHhDGPg5juPAcj4AUJsnJjINQ7ckqj3BpmkdMcgpbxnpWo/BOOYxonj6YbRPGwPta31HfXy8zVwODg6IhS4vk5UyZTu/0BV9sIa5RgWMiSnbkSk1jA3BfLHWhMp+UiXk+kOj2AaM/LmPuk1k8nDa1K8XbVjkbKrzZte301FHlEh7oD/RhvPebwy5kWhhYirBZNBo6T25ZBq+NT4fJaT9NgMVZDMGjRdgmI3gjetxe2G8aK2QnjzNwS9TK2PRZmxuTSeUx3HX4vHKw+8BDfh3ozaobtwcdC5tfivFxcWX6+GberIsVIv0uBRj9xd+RXJhB3CwA9+dku12PYUycA16c/Az9NT9dplyX/38DxnHV1Q6cqTYbhZDx8UEmgRdc4tWIWntDK311DTc0WxHD7/wW9Ks+mi/uZuzB1JVteOfFNr9hzgXIzTySZO+dF4twCEYcGYD8KTbjC46uhXZurQaex0AVCY7Y+8iu7/pMxuDAAnY1cU5MfWGU9ylBiCiin2r4YGTyjhZUMldIfLuxO5y0gsoDsEXG8TlZPdb5lDcCXWF1zFRGV1WMnxbyl1YH3CsneLkZ+ES1KEqpHOJIHi1+FJnUcvNdwsdENbTnu8l21kc2HXqlXfstKUPl/Sd9CkSaQJBmke8wtL9p8q7HAN25Y4aRViHgG/2fREY6oimYXJxjCzN00QrOMx8cyJyo67dLtDA2cJ5K8A9RjLca1hPilUBDeE0JvC6A7KKPG10TmHbEW/kAcKKCPGEhMYCX1DA/cKdzo8Dqleqekz0d9LqWFxDd9FC
 QhA9Snc6
 4CZ3MjZCedWJ9h+eNJALhv1BFVZ2R7c7uv7qdaE9mWM9cyA8HZiZrBWcmKQZgahBQVeNsoPZSsuLLghC8VUIHLiDkODVGePifVoFofWMj4uxcqCTUfACh/YjAcJCO1cVUFcXxWmS9cw0HKABoDyejNRReCxfgazc2Gain6P3/wqFqivZqIgjtbRLw28w4jJascDhXroIhbSxbdRFRb1fge0zA64Pz15nNiddM/dKIVtHqxkCqw58rlB7CsidvBFndXDFFST+o3+3sFgYdPGU+CJv1T0iu9eQylAcDdphbKMVIn2mWb6B0QCtZ+fFrQUXcXrFuuKyswj905WqNxwnx2yf+0yEmuAHjm5CiSRvBpR7CL5bcI1U6WKDEfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 05:55:44AM +0000, Nikunj A Dadhania wrote:
> On Fri, Aug 07, 2026 at 04:36:08PM +0100, Lorenzo Stoakes (ARM) wrote:
> > +static void poke_vmalloc_pages_safe(struct page **pages, void *addr,
> > +				    bool cross_page_boundary)
> > +{
> > +	guard(mmap_read_lock)(&init_mm);
> > +	poke_vmalloc_pages(pages, addr, cross_page_boundary);
> > +}
> 
> Tested just the proposed patch from this email (without the rest of the
> CPA fixes series) on the 512-guest concurrent boot harness (details in

For this fix to actually fix anything, the patches that add locking of
mmap_lock to CPA are needed still.

> [1]) and still see the memcmp BUG, I havent hit the first BUG though:
> 
>   kernel BUG at arch/x86/kernel/alternative.c:2727!
>   Oops: invalid opcode: 0000 [#1] SMP NOPTI
>   CPU: 1 UID: 0 PID: 485 Comm: (udev-worker) Not tainted 7.2.0-rc5-pokesafe+ #42 PREEMPT(full)
>   RIP: 0010:__text_poke.cold+0xdb/0x2af
> 
> The instrumentation captured the following before the memcmp BUG:
> 
>   SMP alternatives: __text_poke: memcmp failed at addr=ffffffffc06ce1bb len=4
>   SMP alternatives: __text_poke: expected (src): 2e 2e 31 c0
>   SMP alternatives: __text_poke: found    (dst): f9 b8 9b d3
>   SMP alternatives: __text_poke: pfn at poke time (vmalloc_to_page): 8ece
>   SMP alternatives: __text_poke: pfn at readback time (vmalloc_to_page): c6ce
>   SMP alternatives: __text_poke: page table dump for addr:
>     PGD 2f042067  P4D 2f043067  PUD 2f045067  PMD c6001a1
> 
> pfn acquired at the start of __text_poke() (0x8ece) differs from pfn
> at readback time (0xc6ce) in the instrumentaion.
> 
> [1] https://lore.kernel.org/all/20260812063316.21371-1-nikunj@amd.com/
> 
> Regards,
> Nikunj

-- 
Sincerely yours,
Mike.

