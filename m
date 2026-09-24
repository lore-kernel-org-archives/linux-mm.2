Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E0EDC98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 464406B0096; Thu, 24 Sep 2026 04:41:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EE516B0099; Thu, 24 Sep 2026 04:41:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329646B009B; Thu, 24 Sep 2026 04:41:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 10BC66B0096
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:41:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9D185C02B2
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:41:51 +0000 (UTC)
X-FDA: 85248012822.26.25916D5
Received: from mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id AB6BD140006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:41:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r3JdL+JF;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790239309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqC8dD60TdXEG8Xybc2Ogump1u1AvYcFMdC8gPtgS8o=;
	b=3kNidi7HDpApsQPwPYtSoD8IecxFze6OZefuP/Rvw2UXGVLsr1M6gKf9vcWlj/0DR/d7vD
	+p8WsHw87QeWZXs0UWUE0faDAPbKdlfqPL98hd/0KAZbMdTV4x/tOggSlkDhT38Niza/8R
	cd21/QD3xKT+On2nlGPn0GYb8RdY3js=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r3JdL+JF;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790239309;
	b=dDJicVdGf5qDpc9wwNZCSzu2AloqCYI89vKpJ6caUx1JJCL8loSrZP32T1+1HNZE/oALr9
	9swhwHXZWyVj4YhLJjoe0ssTCHO7wBtRCa6w9NoT4+Yo3aUCyYr4UIHTVbF2VQYgezbMwJ
	niQerajH3SgM1irsmiKm2E26XGk13cs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GMW73oM32XjlK00ZreHON07LcCH+HXuZENIE7xmRCOc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790239308; v=1; x=1790844108;
 b=r3JdL+JF0N8GGqeBg1gwCBVoj2h8RnmfVlFITYSGRa49+YDocVU2Xxu7ydAlQWOtoJ3G5a2I
 PnIN5VD5cEyeYRfmqkz0XQ2LxjWpyb+8z2N5SP/YSF3+NTQUqPPJZX9/gucptL7Djv1WJ0Gm491
 HdPHiPZvTlg4Aye0jgoDPcxo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id f39e36a1a49ad3fe;
	Thu, 24 Sep 2026 08:41:48 +0000
X-Mizu-Trace-ID: f39e36a1a49ad3fe
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] ARM: mm: align hugetlb mappings to the huge page size
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260901085740.66283-1-kmehltretter@gmail.com>
Date: Thu, 24 Sep 2026 16:41:30 +0800
Cc: Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5AB6FE85-4CB9-41EF-A700-BC5E071F29F5@linux.dev>
References: <20260901085740.66283-1-kmehltretter@gmail.com>
To: Karl Mehltretter <kmehltretter@gmail.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AB6BD140006
X-Stat-Signature: okrg5g3dpn667koeaja9xhyzjm8nob4f
X-HE-Tag: 1790239309-840309
X-HE-Meta: U2FsdGVkX19/uHvx5EA6g2Igz+lazN6bFvSNiXtzyqzrVrkZd310uAxhyMIzmJANb8V52LvYbVvIXTPCvXcEywx6NWzOOHap77tMlFthv2IBzPF9tLViciuTRlhiPGzwFZthyaSJFgqs5n+wYt2F5pUVEHzCU2BAHcK/k1+8amR7WxseCQGc0IwQLKFkipe9M3HK6gfYR9XfNTwk7WukEli5xnQkDCe4cDNZ1O4yJcDkf55vG3p3JXxAC09OSPryCE/w3Xsw8Fy/haCwbjk5tExqTiGeNGERz27Akqz0gvWEA5deK6rHWs7RPAEbBpZiLoBgnboX1UtFzU4UO76/b7ozqP50R5NkpyVG5wcEsTJqjraIIEzoYzqqsDhbhKzOiVYW03zijBRcahqmnGhPjLB05hEFXpB6mkqBjOzI7n7op8rSXhbdcJBmKfEVyEGmWTyYKQa0twS3p22dAWrloYrroPYZYQkLlJAzoI9slilZW8SR1rG76rGFscMtkb3sqDfYDZfB5zv/sRl/PQSgfDkmYGObvo2ojCa5yQl9FoV+gzj4jhbZ8sOI70OVtLWCUJNwn6I6MxSjLmS/7g5KylXrQhtH3T79Of8w1cSIrfXqb1fmTfWxnvb57e/Fd7y7KoFQXXXDxz95rZ8AM5BXOS5Sixn/wFROM4KQ8ys6p6LdeaFWio+6+J16woL+6b7LpbA77OPk5ekrjoOHQVPmwOwqiJE1Em0hE+CwbkwdFuLN3LzVieOb+MMbv5jDyHbORnWEdIymMGE55UQnm0ZFZ81KN44uaWNEN+YG0vXj7ygpUdijex+FyZreTSyjHaurE8vJU4L8vEO7w/f7X3AapZBFWdmacx5JQLd816hge9uiM76Tvtcfe3hDXlWLWSkMjmit+zOk3RR3iGjD74EIielNXQD5jbmomaBmJR9opkLXRARqa7hia4QJq2ltpzUHjMVlQctyuKOvWArwsfG
 TW+AwYh0
 ovEh21GIkV0AdQ9axueoYqT3cSs5b3zMUST5iE8Z3CjlbJKKNj1j+KIBiiUk/EidzgS4TAut4TUKMSoGZ0SGQItZfCiAxSbuUOdgxm6CVEeQcjSLHeoza1wlqFTVbCxIYDrsEUmbjLMl5mI6WLqcFUrUrLwLtQZEHBcGi3uKnXtltKnrTEEFFlkJDfJURyNwftcECiZOSFroeH+vXC5MXb6T1TuT+InjnNvmtxL3QwYOhKHkUkUuaqnUUKXJrPDC5w4QHxaAvSWAawq9/zlAbHJwXBkJJFs5kxANJafQdg1ISIAJQ1FbcsWYT5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 1, 2026, at 16:57, Karl Mehltretter <kmehltretter@gmail.com> =
wrote:
>=20
> mmap(MAP_HUGETLB) on 32-bit Arm can return an address which is not
> aligned to the huge page size. In a QEMU virt guest, unmapping the VMA
> then hits the alignment check in __unmap_hugepage_range():
>=20
>  kernel BUG at mm/hugetlb.c:5213!
>  Internal error: Oops - BUG: 0 [#1] SMP ARM
>  PC is at __unmap_hugepage_range+0x540/0x584
>  LR is at __zap_vma_range+0x13a0/0x1410
>=20
> Commit 7bd3f1e1a9ae ("mm: make hugetlb mappings go through
> mm_get_unmapped_area_vmflags") made hugetlb mappings use the
> architecture's arch_get_unmapped_area(). The generic implementations
> handle hugetlb alignment, but the Arm implementations only account for
> the optional SHMLBA cache-colouring constraint. A 4 KiB-page kernel =
can
> therefore align the mapping to 4 KiB or 16 KiB instead of the required
> 2 MiB.
>=20
> Set the alignment mask from the file's hstate for hugetlb mappings in
> both Arm implementations. Huge-page alignment also satisfies the
> SHMLBA constraint.
>=20
> Fixes: 7bd3f1e1a9ae ("mm: make hugetlb mappings go through =
mm_get_unmapped_area_vmflags")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Besides 32-bit Arm, the same regression appears to affect MIPS and
SuperH: both support HugeTLB and provide custom =
arch_get_unmapped_area*()
implementations that only enforce cache-colouring alignment, not the
hstate=E2=80=99s huge-page alignment.

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


