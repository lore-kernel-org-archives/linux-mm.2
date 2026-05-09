Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66B51CD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 11:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 422136B00EB; Sat,  9 May 2026 07:05:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E8446B013D; Sat,  9 May 2026 07:05:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7D46B00EB; Sat,  9 May 2026 07:05:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 08C3D6B0316
	for <linux-mm@kvack.org>; Sat,  9 May 2026 07:05:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB6ED1C0502
	for <linux-mm@kvack.org>; Sat,  9 May 2026 11:05:00 +0000 (UTC)
X-FDA: 84747599160.13.76E3A8A
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf05.hostedemail.com (Postfix) with ESMTP id A010210000A
	for <linux-mm@kvack.org>; Sat,  9 May 2026 11:04:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="i YHwp/X";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=WWrwA2q5;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778324698; a=rsa-sha256;
	cv=none;
	b=GPHMnGQbfq2apLe1v+oQVFednSJBdn87tbyd2u7ZcJK4RVmOPxM2TqOHiHM9XkxL6PU5qD
	9Td4gAUueFiUABd4xA1rBAb7exr/GB+xNi7NzkokMssP7e1VULQr7VmQSlFpuyfb4a2Axn
	1ilUn/4vbGZbydQszbtrprQ8LaFi0L8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="i YHwp/X";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=WWrwA2q5;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778324698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6oOr15lhB2hYKh+9zKzPi4kv7JyYr4PGQI35DlaGm7s=;
	b=wZz+hXZ31tfw9W10kveqs3nnULsPhBmTYtCAfLC3YDEZIYxE6B7ubHiS28IC6puC1zic4p
	JS2ikYVqPtAA3gG7W8jA4b4RTQ8UAqtnLP4FHU4KfjKXqBWRvBEyYCQUnwjEk4BPy0S1ac
	uB1HRKFlWYs02etNnuFEv0XPEYbpHJU=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id A1D357A00BC;
	Sat,  9 May 2026 07:04:56 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Sat, 09 May 2026 07:04:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1778324696; x=
	1778411096; bh=6oOr15lhB2hYKh+9zKzPi4kv7JyYr4PGQI35DlaGm7s=; b=i
	YHwp/XRv0gFo5lo0yIQ7J3BAhxjKzc3qK9tshRBnSUZQ7Mp9aH96+Wpnu1y3GWU3
	UXBfnZHHE6GUePMKSrbBXQJuHtmVhe/9KdUqGG9+g4zhdo82l7Zcl1wNVDqlWfBm
	0HyAlYwth+3lEoTET+zje/53ySJiy7rVG5PyRC/qflCORE5ANufiF3gyvsqWuejS
	ZVvEM4pS0vD0A/QbxyDRXtHCw20oKudQDFFA2vBKGA/Scp+UFHsrubM4oYb3YfFc
	0c7fd9TxoTejQVLLp8+rWmDTLqsAcWkkeCMi+qXc9w4jFWta2dg1XrRt9DqPoEyz
	mI4Y4mK1w9pcw9kRHdNuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1778324696; x=1778411096; bh=6oOr15lhB2hYKh+9zKzPi4kv7JyYr4PGQI3
	5DlaGm7s=; b=WWrwA2q5wWAbrLhsibxkrHgSeKPAYsHWw5tDREWL+X9KWWCjoOm
	Tj0iUCm3Rmp6aAVYyK0yk+R+NKby83yPn53wIwthTfHnJz78Oa+JTVE6rGNRep91
	2Of0ERtNC5HHgqoOtjNNXOjXKmsdfZCqArYTECWPnOhPpkIjBdwdNRjI3iayuNW0
	Ku4e941xohI8IdchY9oU3+dABYK1gmmjISegRnmXW+cjZopAT5nlGzrBtEgMXa3y
	qCIx5172E05QgX+I87hfNYsFpD260mMQHZrZOJhi9LrA3VMcHTU3EerU5NK3G0iJ
	4UA1Q7m4UdN+qOzIBTgOpGiEV+Tkcj6jVig==
X-ME-Sender: <xms:1xT_acQi0EO7qMXtDm8A4xH3bnC6oCtAL9JeMPzrFxCVmjuR-8BfRA>
    <xme:1xT_aWNmGsd7QfhleS57DWKqiyZWzDjMW8wMj61CqFebOs00fkcCo1J_GMYeQxRep
    mzAKkJ7NWCjvQhaeV2Rr38xPLdnBsTdqskHhcNt4OXctLA0IyfBgD8>
X-ME-Received: <xmr:1xT_aRHVXMYQDA8sKpZv8qc0jHN-p59Ib5Xi6t33yZoI8iHSHcCjEf_3clsKnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduudeftdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepfeetheejudeujeeikeetudelvdevkeefuddtkedvtdehtdetieeu
    ieetjeeugedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeef
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheprghruggsodhgihhtsehgohhoghhlvgdrtghomhdprhgtphht
    thhopehlihhnuhigqdgrrhhmqdhkvghrnhgvlheslhhishhtshdrihhnfhhrrgguvggrug
    drohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgv
    lhdrohhrghdprhgtphhtthhopeifihhllheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eptggrthgrlhhinhdrmhgrrhhinhgrshesrghrmhdrtghomhdprhgtphhtthhopehmrghr
    khdrrhhuthhlrghnugesrghrmhdrtghomhdprhgtphhtthhopegrrhgusgeskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhmrdgtohhm
X-ME-Proxy: <xmx:1xT_aWga9cOpYE_pyhIBjzdsgHr_rfOj1BkR1y3iWOZMCR7O-JxLzQ>
    <xmx:1xT_aVwT2YD9zGiOAPeWGTEZQ_AWNb9NzZ_CYTvN5hhr7Mxo-WSoZQ>
    <xmx:1xT_aSrdIdu-kum0CJwm9VQK2P8SdtM--gColK0Mkz7qx_7Oip9pCw>
    <xmx:1xT_abXbuN040Cx3-DrAvxcS65Gg5Dm0uUpPzmm_pOfKKNSxKF2kYw>
    <xmx:2BT_aavA9QRV2e0u10CUCCw742gCNFuNq8s1eS7dSWg3LPMBFYhS18xw>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 9 May 2026 07:04:54 -0400 (EDT)
Date: Sat, 9 May 2026 12:04:47 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, will@kernel.org, 
	catalin.marinas@arm.com, mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>, 
	Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 02/15] mm: Make empty_zero_page __ro_after_init
Message-ID: <af8UEuy-gfLj6DSV@thinkstation>
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-19-ardb+git@google.com>
 <3d1a6b5c-f3bf-462f-879a-cdb5b60868ac@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d1a6b5c-f3bf-462f-879a-cdb5b60868ac@kernel.org>
X-Stat-Signature: 63jhoxdxyxemyoez3w9yfb6qzbnsx3kp
X-Rspam-User: 
X-Rspamd-Queue-Id: A010210000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1778324698-774682
X-HE-Meta: U2FsdGVkX1+347MSPiTl5gG31evzEobjB50Z5/rdthXi+ErCyLFBC0EtM1dlRaX8d71jitUhL81TQ2zyq/FeZREPg784RHZXZDRlv0H+Yz/VxKBcgF80BSX9FijKz6SdwjHcZoqS+0wDwB6aTSXAqynFmlI4rGL+S7rESiSfaEALsYv5c7aEMLw4C6dK8JEmPMPDILNJA9t90CcFyTlMFkzFefEbp+5iEIcacoxNeu264R1iQp6bsNQ5h3AI5iuoQGFQRadA4uxB0vAZ6Rj/OcMxfq9AjRUSx0f6kKNOhKYyKGD5k8G78kyPJs2aHNAItDpr4F7cwdCzIwMEfJO5e2ZZwWyJYGgDbkUX5GqBWg/AJaVTMw97RLrQJoUUK4zKoGENhesZcQ5S90+nOnvuEpKaZJScuWvGmcD8ReKW+iO64z0paUvMDShcHYQ6QzQZUK2mv1io5VftPU3B/d5Ly2qAIj/H2e7fT09UnryCCTFyoe5/slWG3X4KLu7RTPOCYASS6iZW7W1Lu7g8POYIU06Ox+hw6dmWUYj3gQ2gWBmQ9GK8EXJx221iBMXXPbbEOm5fO3U07ZzXUl/exWn8kkvi1F38Hk7YsODa95uFkwD1Ce6G2H6EB3q20qb/ZxoDiWvj4S9dySGRjPPF0+E8DLjyXBPs8VkgdOV3LWqZ0idBi1HzmuB93JTt37VKwW/lMTgzZSGdxkHaocX0LxoQGgpO9tkvErOlNXWViW7tZr6USxhIEHtf4ShJgT/V1oTaa7XIZKOiVsTlD4AldgiJBDeYptGKS3vYdVyK56elv4VmUT2WAmQ8OXia2hSkW0X+bhJY8G8pAI1HYF4lN14zf8cs+q/3k0dvrLL4q4Oinoy4SyMfffyYWudZ4vAd9PFtNMrhEhHRxFC/toEbdoixdpJfwHE3/M6FPvR8ax1N+Xhv3aEK1HxhdkDSWem1OJnXRsB79mSwf4XizowSsQ1
 YAw0tgyB
 sVG3NE8wbf3iAE+suru2+9mttGt81SfhFxO/PDWmOTXPUBBHAfP3tZA1N53q2Zpkay3jI4/89Qd5x4LOs0IWLMoYt8WKwPB5O6gKm6ouG75w5UKoCHjq9HH79ebEkbMUTkOvFePulNoNaBlRAKcO8cJwu0LY5kbbVAGjVelYMlKFNkuVFSaWVaoMnhLPin/NvFUAND0YtBybVXCzstVU/FdaoxJBiY6IlrhGKWrJeqwNRMrhdJH8g/fqUCDcJl9ekGrcdoukHTOZUM+c2+BvtE76s04dY9MG02zdknfjFe6zb1/PLW0Ar0PLVCViVB64XoPXlKMKFNFwHrckicP2e7m5/AhSF/Fri/hZmMsdFUosIbBU076RF11ZsGKA6qV3/RGZa5h4oY5LOg6N/kSB5tuWNsaomy2b6RDlqV3y//jgIPHZH9DbrntMfOd5QHeKWW9tRI6UFHH7SdM0QqnqkRmRSirgdOx0DKAp1qJRGDpwceJJZtD5NY16hyqSbyaMxXAG6wyUEg2RdqS5WbZ5o2iV+0CN9a3QCVC8zOaBnr4lzPrhoHAvQPWrM6M2TfT7hdjc+ALph79Cd3OZR/2Xf5B6hhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 09:51:09PM +0200, David Hildenbrand (Arm) wrote:
> On 4/27/26 17:34, Ard Biesheuvel wrote:
> > From: Ard Biesheuvel <ardb@kernel.org>
> > 
> > The empty zero page is used to back any kernel or user space mapping
> > that is supposed to remain cleared, and so the page itself is never
> > supposed to be modified.
> > 
> > So make it __ro_after_init rather than __page_aligned_bss: on most
> > architectures, this ensures that both the kernel's mapping of it and any
> > aliases that are accessible via the kernel direct (linear) map are
> > mapped read-only, and cannot be used (inadvertently or maliciously) to
> > corrupt the contents of the zero page.
> > 
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  mm/mm_init.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index f9f8e1af921c..6ca01ed2a5a4 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -57,7 +57,7 @@ unsigned long zero_page_pfn __ro_after_init;
> >  EXPORT_SYMBOL(zero_page_pfn);
> >  
> >  #ifndef __HAVE_COLOR_ZERO_PAGE
> > -uint8_t empty_zero_page[PAGE_SIZE] __page_aligned_bss;
> > +uint8_t empty_zero_page[PAGE_SIZE] __ro_after_init __aligned(PAGE_SIZE);
> >  EXPORT_SYMBOL(empty_zero_page);
> >  
> >  struct page *__zero_page __ro_after_init;
> 
> I am no expert on BSS etc, but from what I understand, we'll still get zeroed
> page-aligned memory. I don't know if there is any other impact on not having it
> in bss.page_aligned. I assume no

IIUC, unlike BSS, it will be part of the kernel image. So kernel image
size will grow by PAGE_SIZE. But compressor will eat it as it is all
zeros, so it should be okay.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

