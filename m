Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D829C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CFF56B0095; Tue,  8 Sep 2026 03:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A75D6B0096; Tue,  8 Sep 2026 03:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BDCC6B0098; Tue,  8 Sep 2026 03:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5B36B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:55:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 013DD403CD
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:55:46 +0000 (UTC)
X-FDA: 85189835934.16.443598C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4728CC0004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:55:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Aibw55aV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788854145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+z/W0SyogxAbXELZ8t1ZssTfimRFsPFk5JDyvb71aNQ=;
	b=toSD1cvdzncil2tsLGYq9vrGKoxFUj1BZ+iGP7XPyP9E+YZwL/HU4onrCC3XnnkRejD7KG
	NY3VzzDm5jXWyB1Ny+mVbSPN+IjHseVyP7SP26/VomNfo8pmlXJ8iejlo/mUwBY0kLu9dQ
	BBcSZByGSTCYEODHiiRh4yRD3rt3+GA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Aibw55aV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788854145;
	b=LblFQkCloDPkL7ScHDZLEaKcTnTEpAyyQeg0Aa2elqAmBRnrcKaYPu4U6rZQbIDcuznTIt
	WIACtuK/V1JClGyxprvs0VU/ujKdImgOteNR0NyGzG+LsBrHnG2XOLBZJwhSSc/xEoPrYf
	OjBdehDM3era6zW7qj46ewBnpSp3cus=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3ED043BBF;
	Tue,  8 Sep 2026 07:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F3C1F00A3A;
	Tue,  8 Sep 2026 07:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788854143;
	bh=+z/W0SyogxAbXELZ8t1ZssTfimRFsPFk5JDyvb71aNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Aibw55aVzuncFoqY/O0hYQQB0/O43/vaI9PhWMKkcNFwVlbWbhT6CGhChSUX7M9+N
	 dpiaYMM1PpymYnfVaGijOm/xiD4Ab7ceySQHOJCbWM7mfEXrr8GgYgxgGEiSLcvfpe
	 o7rkqmRz/aOWv6WO8J83j1YL3nGsFtQApzatCAk1iYSCUyg/Nr7zH7zYYUNLWyNbL0
	 xSAeu+j1qWcgsrT0R3bze1sfwMWvj+VqbwFLKY64oOhZP2eyap/4GAkrrsxswA0eC2
	 meloyVlB+pXTSVTv3BP4DvmEA82i2lAXaxabPLGB83Tm8g4C2Em6npv2XvPfpkBmVE
	 ZWnKnp+JxdEWg==
Date: Tue, 8 Sep 2026 10:55:36 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 1/4] KVM: s390: Replace get_zeroed_page() with
 kzalloc() for the STHYI buffer
Message-ID: <ap-_eN-RcdeNg6SW@kernel.org>
References: <20260906-s390-kvm-v2-0-2cf6434e6646@kernel.org>
 <20260906-s390-kvm-v2-1-2cf6434e6646@kernel.org>
 <dcb5547b-a04b-4991-a581-e3784ccfe303@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcb5547b-a04b-4991-a581-e3784ccfe303@linux.ibm.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: pxtyjej7dju6tiysethergfrhnhdedm8
X-Rspamd-Queue-Id: 4728CC0004
X-HE-Tag: 1788854145-330800
X-HE-Meta: U2FsdGVkX18dRv6jN+nmLjng1ZbQ/3Aw+M9rxeIf65ZTsUdriFH2UxmfLPlQbKHe2HpNwAeL3SAXFba6nllcxQze9sGzhWguEBfowsKCbkxr3TZtmCFSdXA7ILGfjpPh0AsZE8S26k/Hh0GcqJb6GYaYbzTxt52yXAFLMmTd0mydmyFQM+RT5+/uElXDtFpYZ82Tz1TmVkXcP40Menw4DApCnuHeUU9kw13C4gO3GEaM+Gh8ySB3ClJkK1hEW0aG7vk9eNLuMB9tVJ6jeEeavzg62oxk2oTB0bJ8Qa2bXwjcG++3Q/A0lZ9st4hY/7pPEXshPX0BJCzXZT0bio5TXidv/5+7SFUVcysosGGdsQCMZvnYo9A3fGXwJbalTA/0zuM6Qy3sGmi8a6LiRxZhg2UtJRGlFb0EhYyr5jhmjTrJroQHPiih1Ppr6U6G+FWmv/NmE2OO6ASTwa/ViyT5nTCoPkB2YZu+i6O/2EGbHB4h9z+fTdVUXXZLVF9EfaREY8i3bpjfeGBtdZuTENJRvIWxEmmk5yetNO19K7Csv0kbkqsopN7427mqePfMUQ4zAH9R5WmtN3z3Q5X+UUu8fV/RqXW47xOH0DHTTVAEM1YJcTnuLmzeJ9di55JclChrjy4k1Or49lKQT9Zzupxuau/Ru1wfIgOTl1oYAXn585AuB2lvyG42xgaD2ASJ9sSaSESft4m1kXEC5ibzvM8yzUHyycUhp/GhxUwTTGkD0/EveosKutwaqF0Nf0GEuEWqGrq2YAnLgrgIXFwjuT8QyuudDfX6m3fNX8en5Mq3OIzSv8xTGMJux+9+XJolN6TQzOh1qF9N+O5MI1036Bo5T/3EpQ7kD61/gLwbF0SWMukMdI3hfGpJ4sQ8fEl1gefb1eCDxV/98zRjcfDtDVo/Y/kUAnLoyCM+5e1NezM/umbzoTX2UMVDaeh1QdqQgL2Cm8Qb+kDpKYGq8bhHAc3
 t9p+SGzi
 rL8cbXvi0KOpwPUuELw3VyVkvri0AultpFWyYxcUZVK+iewCyyQZ/v8k/OIt+HgVgGCfp9KTYEn7PC6Fn68Is6sXi/6mx2MmExbI7NuXcECpn9jufjjflmqBqwJh0/UH6tdFoLLfDS2a93VX85/dKrxaOgoEkxZrPRiNQ1x4kfSEmOWbHcbvyWbJbup8xdYvy5AJMvZq6EJ+97CG9q8ST7lugT1CJu24NPG2McVmyizqJ9zUsA0brzjqPhBuK9hYDxtgncy1DHohA+NmwDL5Z56xFFJM1x+YvZ5Lwn3EsFtkaBOOjh9jmck14hQNHfVYxufO/HpR5uuGoi4M7VI2pd20GJ0NGmtLQYjyo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 02:23:02PM +0200, Janosch Frank wrote:
> On 9/6/26 10:27 AM, Mike Rapoport (Microsoft) wrote:
> > handle_sthyi() allocates the buffer that receives the STHYI response
> > block before it is copied to the guest.
> > 
> > This buffer can be allocated with kmalloc() as there's nothing special
> > about it to go directly to the page allocator.
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
> > The only goto in that function does not unwind anything, it merely skips
> > to the exit when the function code is invalid. Turn it into an early
> > return so that the buffer can be freed with __free(kfree).
> > 
> > Replace use of get_zeroed_page() with kzalloc() and free_page() with
> > kfree().
> > 
> > Assisted-by: copilot:claude-opus
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Yup, there's no alignment requirement anyway.
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 
> 
> 
> Looking at the kernel's sthyi.c there are a couple more locations we could
> change:
> 
> I don't see a need for the syscall to allocate a page and the cache doesn't
> need page allocation either. We should even be able to have them byte

That's planned :)
I'm splitting this project into small chunks to ease both my review of what
LLM did and to avoid patch bombs that are hard to review for everyone.

> aligned since they are never the destination for one of the diagnose
> instructions, a kvzalloc should be fine if I didn't miss something...

For PAGE_SIZE allocations kvzalloc() will kzalloc() anyway, so I'd rather
use the latter explicitly. 
 
> Diag224 needs a 4k aligned 31-bit physical address for some reason so that
> needs GFP_DMA. diag204 is vmallocing anyway since subcode 7 uses logical
> addresses.

Actually __vmalloc_node() seems a bit odd there :)
Plain vmalloc() would do the same.

-- 
Sincerely yours,
Mike.

