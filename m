Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 459BEC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 05:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39236B0092; Fri, 28 Aug 2026 01:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2A16B0096; Fri, 28 Aug 2026 01:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8A246B00A2; Fri, 28 Aug 2026 01:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF0386B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:39:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2108BA3C5E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:39:52 +0000 (UTC)
X-FDA: 85149576624.30.10BD67C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 65822180004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:39:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="OUe/I4kK";
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787895590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=saCp1ODXEDwi38FA7nL50yvKTMsyJL4w4PBPDdxbPpY=;
	b=rk7L42/MaIYQRqDRa2DqtidxeqBjvQxOeENCSJAWCKRvQfeYe9cVaVuvmDDrVKnsw3DM38
	5LA5RPGwsYU+lH74jgycRKZHQWg73yWLHueVGCmtR+2dch/7VPsi4+KV4IA8H7VgU+rAre
	NzaMhhbE1EqYCZouVfm0v6TqfXElfhs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="OUe/I4kK";
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787895590;
	b=xRl7hs/TDwYRlZh/JbhQSkWlAVZWQwLx6AbqshKDpydgpvonWS/caJET5wGGQszxBnNI7p
	jlCZosgl+hmkQiZE5TqSXAJqtbA5zqUd38wzm5w13QenVUjabPybITU/DlFQFje7mujz3P
	1pa1SLhKaoD394RlXBnEXIJOLCx219s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C7BDA602CE;
	Fri, 28 Aug 2026 05:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F2A1F000E9;
	Fri, 28 Aug 2026 05:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787895589;
	bh=saCp1ODXEDwi38FA7nL50yvKTMsyJL4w4PBPDdxbPpY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OUe/I4kKl1IqBcGIkGjmGrfcJVc9TLT2CvvQlffxqcLuYDyJcEvYYDfW1rZZPMhiH
	 lYW/VNcrDLI36iGraqidaScttACFiGrJ1k7I/GKZaA2Ey07eH3kpV2Es2yikDQJn6I
	 XvfKFsQX7UaaX+ke7/7cKng5/7pFHOWAuZm5Ev8I=
Date: Thu, 27 Aug 2026 22:39:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Adrian =?UTF-8?Q?Barna=C5=9B?= <abarnas@google.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Alexandre Ghiti <alex@ghiti.fr>, Andy Lutomirski <luto@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Brendan Jackman
 <brendan.jackman@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, David Hildenbrand <david@kernel.org>, Gerald
 Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Len Brown <lenb@kernel.org>, Palmer Dabbelt
 <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Pavel Machek
 <pavel@kernel.org>, Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin"
 <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>, Ryan Roberts
 <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>, Thomas
 Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, Vasily
 Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>, Will Deacon
 <will@kernel.org>, x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 loongarch@lists.linux.dev
Subject: Re: [PATCH v2 0/6] arch, mm/execmem: resolve confusion about
 set_direct_map_valid_noflush()
Message-Id: <20260827223947.c773e6a7324eaf3fe0d8362f@linux-foundation.org>
In-Reply-To: <20260823-execmem-set-vm-perms-v0-2-v2-0-b013a37d84b3@kernel.org>
References: <20260823-execmem-set-vm-perms-v0-2-v2-0-b013a37d84b3@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o1z854x3fncmntpkt14etjt4bb4hh9hp
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 65822180004
X-Rspam-User: 
X-HE-Tag: 1787895590-381888
X-HE-Meta: U2FsdGVkX1+trZHgmF3lUdFLVWpjGqpmygsi8FZKzbN5dRnESrG2eo8kqT82IyFCaOfdMNBSpLReg8OnapRI7njBMw5hqDo3tdim5PIX/k0Rh8XfyDS/DXgM8ZAu7O6N7qRh6piqsDgUWwbRfGSbLevbxPiCcvnMKTF2rGD6a9sVfxeo85IY7h6qoxbj0RrdN23vewE5rhZwys6LYBhCvf2pdkvMgWsa9+VvS8IqbQObuA7YpY5tKCNoMOKrTCeku4fdW/USAw7no7vxt5u1barU4ol+0luCUwD1aVUa+djHK2pSGRUPchERd6N9xJSDPpVCPDp6Q2c2tN2CJu3Ei/vXPHUoats+pz6yndb0gmfEXinR1qWVQxedDDgcbq0VMEZMoKizwgalUjuP0O4tRKeK20XOIs4Q5FHGgW40yn0q47SHAmZQXj2PkfiZGUwXw7qa8hRn8KAjuMRyz5d/0+KxUjx1yzCmb4smgz2pWuBFXzHEWjC3xgd930iX4N5iu8v/cWEVdzrslI+Sk5KMSzCCgXdmjZToOfqSFTzyaB4HdlprvIF0pu3HgTJQ5xwJS2SOiDGkGWLIxOV1IdO1yIsLZhjQNq6a76bxfMwFvENHtoxqYh8IjlLgaHIoGFkhYyLwHLCLo2xIlBHJhkW/syMKZUE66rFxfObkzxWV4IUnuKmCebjywVn4IDx1Da+nGHhhOyRihKdZQHrdF5UW6zzcQwO2o16MI+GDHbPy1X/M2+9OW0J2SefC3U+zYUM6QMLf3YhxzVCWKBi1RADMSrIOq4rBVlDYwKG+lMj/fsZ4ywYYqy44yguNhnckuO41n+D3KilyLtih4xrwBOx3mBtASYgCQGRZ7gK0XGiTRiwmJ4UYqjNi/bjHgDTPFgCCtqNVRJBuxFR59sP0PsGCIScCj7QRpERvGu9XCBo5yqXG5M239bxuWpSknbZMMuB972iQeUc5GqOyzI+CWe7
 IEDanicM
 67tfegFPZkisCZqOkG5EFBTN61oIeDHkMh6mgsYcQw17U3GVrSl/rdRKWc5iP0HbX0TD1q5PlV9kH+ukyX1/zAk3CijLlVnY23g5VOp74zgSUrB0QXAfcUQ7iDIGsgHSbhgoU/O12Te6Y59Cl+iO52MCk9B40Igplz9Qw+4XWQl9EuNzDBU/kF/NnwPSr4FUO4gwAQs/Dotya6wWszxZw0tsuNkMSdXE7jbBu9aQT6lXmcIHC4qXp2aUou2gaVaoDxYsAXyHbOni5gV3UwNLleS8JHkwc2GMyDIUw/fV/RS1Vk6lQL1asVqieF4ALykY7eJF16lpDEqy7p2d7+4naPITYxmzg2rbeIjOefv+BNQkf1XTDoz55pMYtn58Q0DiefG7M5tEAPuZ+VyPajyIN6sW8IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 23 Aug 2026 14:46:11 +0300 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> Recent discussion about implementation of execmem's ROX caches on arm64

I'm assuming a "[1]" reference was intended here.

> revealed a confusion about how set_direct_map_valid_noflush()
> implemented on different architectures.
> 
> On arm64 it sets or clears the PTE_VALID bit marking a PTE as present or
> not present.
> 
> On other architectures it's a range version of
> set_direct_map_invalid_noflush() and set_direct_map_default_noflush()
> 
> Unlike arm64::set_direct_map_valid_noflush(),
> set_direct_map_default_noflush() not only marks PTE as present, but also
> sets its default protection mode.
> 
> Other than that, initial design of execmem ROX caches didn't rely on
> restoration of large mappings that's now available on x86, but
> completely removed the memory allocated for the ROX cache from the
> direct map to ensure that large mappings are not split. This precluded
> usage of VM_FLUSH_RESET_PERMS for the ROX cache allocations and required
> execmem to implement manipulation of the direct map alias.
> 
> Current implementation of ROX caches does not remove the direct map
> alias but simply calls set_memory_rox() that updates the permissions in
> both vmalloc address space and the direct map and relies on
> collapse_large_pages() in x86 CPA to keep large mappings.
> 
> This allow using VM_FLUSH_RESET_PERMS for execmem ROX cache allocations
> with small adjustments to set_direct_map APIs and vmalloc::reset_perms()
> behaviour: adding number of pages parameter to set_direct_map APIs and
> making resetting of the direct map permissions in vmalloc VMAP_HUGE
> friendly.
> 
> Implement these adjustments, make execmem always use
> VM_FLUSH_RESET_PERMS and revert set_direct_map_valid_noflush() changes.
> 
> [1] https://lore.kernel.org/all/20260611130144.1385343-4-abarnas@google.com

The patchset is perhaps a little green but I tossed it in there, thanks.

I hit a few rejects in arch/x86/mm/pat/set_memory.c, but minor stuff.

I trust you've seen Sashiko's incidental oh-btw comments.

	https://sashiko.dev/#/patchset/20260823-execmem-set-vm-perms-v0-2-v2-0-b013a37d84b3@kernel.org


