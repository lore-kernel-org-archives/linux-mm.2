Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0397CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 08:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9216C6B009B; Thu, 15 Oct 2026 04:33:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D0CA6B009D; Thu, 15 Oct 2026 04:33:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80EFA6B009E; Thu, 15 Oct 2026 04:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 614296B009B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:33:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CCE4FA86D7
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:33:38 +0000 (UTC)
X-FDA: 85324196916.03.83D4DD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 47E6C40007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:33:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UtjExpLX;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792053217;
	b=pEwpKSE9F/qB+p64SubYVFOlQd41+Gnrvk1IYNmMWfdXfm48Y5lpfvA5zTD+7Dj9f1rhvB
	nr/1Px10fZmwUfdljgnczydlRfKQG5zeG0XAggDlb/aetbwrTRiGYjQUtsfbOlNYKf/s30
	TkbcqhlZ3QwhLWqU4TqhZiImo9NHVqs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UtjExpLX;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792053217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOZJvgkf51bXSMCUGPR93r0N2Iu+EN4HtBMStIPgKjU=;
	b=zRB9eaE1I5ZTrK1zqra1x/tWojC+Q1SMQ/h8im8SDTNDEnSbnS4APdu6xTpglc8nPP9OyD
	Vr4TH7Uc3N5FrkuEQg9WQJ/jiOegb1n+C+bMFvfOxfM0j6X7Aw45lrotSSfj8L95uSGGQ9
	JTe9i3jAIRUxFp22glJmgzK/Oc71Ta8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 032B96020C;
	Thu, 15 Oct 2026 08:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31CA1F000C5;
	Thu, 15 Oct 2026 08:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792053215;
	bh=AOZJvgkf51bXSMCUGPR93r0N2Iu+EN4HtBMStIPgKjU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UtjExpLX+a8cuwlOqRz7cmtKMwlhGF6EnvQaF0p0x4Idxm7ijZzJ4N4aHzgnTwlwz
	 R8l5QkDwcjiwdCBHnSSRjTENCW08WR3l+IPSoc8tl1wAz2YK6UMjqe+xrJrJTVMzqJ
	 MF7tyXtn/OSw2I7X24p6aWSO9Oj/85pkVXRZJqnSDeQXfOMbOnbLe0GUhAOGM2sD2X
	 HekeupaPpNdH7XpRSKNDfJ7waPaTVh+8cokwHTARhRjZNQUO+kbrqC0b10qK3i0PHH
	 L89uERs+2aOpCbcvSSbRB28Xz57aSinboHKLUsW89VCRBBgh6LJp0SsTjzcNZ77czB
	 aZ5VuixK0k5AQ==
Date: Thu, 15 Oct 2026 11:33:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, Arnd Bergmann <arnd@arndb.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] mm: Generalize page table allocation helpers
Message-ID: <atCP1YszjrtrB30U@kernel.org>
References: <20261014035910.687847-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014035910.687847-1-songmuchun@bytedance.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 47E6C40007
X-Rspam-User: 
X-Stat-Signature: ysm96z4x3za34ndaoarwmszn6wh41kmf
X-HE-Tag: 1792053217-23663
X-HE-Meta: U2FsdGVkX18zyOIt9WmweeC9YwI5tSDUR+gOrLpM9P+QZJM86DB1sWCG6MjhDCbQso5ne5A0pfhZcSfrutGU0yi6t2xNkLrp3MVXx+WgtkOwNL00uWhzSUjYRuvKkpjTDQr7LZOOqL2CvlziX/y7cH6t1FFnZAnAzdh8h0Tbdr7/kJrD2Jab0A3h2v9kh0Tp+sLIEtdIY9FbRSt25z0STNzO0bKS9ZTziQXro3PXfkWZ7mSwpqpId4EbLYvSX+sjTOHM+5zwhMp8cUQZ56b5RxAKxppvqWxJxr63IkFCpdOIvISG4xUw/aPHXBbQuDQlfGZO4/mEVgke35b42RwF+HLHElgVfmxPMTLng9g61vfKKjE9psdMvF8PXLajO1qJbjTKlztNebxCwgT/EUUpa9hdJUJe4y7acImynOYIAErR0h3qAHNDPIPVK5Ey6xYaKq21odA4NnZfa8AIoyN3CIC+elud1572ZdxgiqhsJKV2DV9kxcMAYf0/SEZ/oSaeNmrTM2vIW2huPpC+aSsLt6e+42LcwXDgY8GMApkn7A1SKRpNYJJi7yv7MmdlzlsMqzgTzce8rWaWmuJjCtZ4s2FSQEz0YfONM4EJN2HmB5jHct7Srlb9n9cy7ddARmchjM7f3rDrXXamur5a6o8vNecMenyBh8kY/wJXIksUrGWSvD9T5GalNX/wf10J0GkotYv2bWx3DpGZ+Mh0v3YLGP2WR7bqJTZkAv/8d5cCEF9BxzKLD2L1NLEriEB3dcsuSIHUbmlJ/N7hvDmHstwOWhlYFk6xJnqJJh8+Ao28MuJzPYYDZdIooffh5LNBoJdXz+/RnkUG2gq5xUkY69fAO5DFJJRp2SlxGVq1pepDaH8QISzN/ChtFhGlZ4w/L54r/8Ae4M/RtvduZVv+5KoYv6O+Jm/xjJCDn0tq3b2YWH+x8XIJ1txOeIVDmQEmXmBP1kJYje7D/tIhlzOOTFD
 Hu+UIQCX
 hjNbdqBgB3NxM/PmZyZVkF+tTkOC1j9hoCriToB0OBIGeGkvZwIjHZmWFD1zfrBVv5mMayb4VnINJPwazz4qE04Vy2cUAH1ejTCSzXXRoaUidIXGieqclUeek8z640bBgX+n7Y3PEXj8if5CG608EjokPiN4rowW8+t3ozII8cM5pWDDwWGcbd7NXqUYw/irFGjudF6Em3E8DBR3++w0EtCuzQW2zsl5BYngp8hGzO9CREPsOHLoprxCNhWLbb2/XUaMmqB1QvWIld5+JjG4YgBS9YGc9tSPKgpqEz6zeWAMwq7P1+sxA36NAPvizEni53pneB4Ng2NTHDAfe3VG1Zk3slyy2uoKWhhAa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 11:59:07AM +0800, Muchun Song wrote:
> A subsequent series will switch runtime vmemmap population to the
> generic page-table allocators. Since vmemmap tables belong to init_mm,
> the allocators must select GFP_PGTABLE_KERNEL and mark the ptdesc as a
> kernel page table.
> 
> Some architecture-specific allocators do not preserve both semantics.
> LoongArch and MIPS choose PMD/PUD GFP flags without checking the mm,
> which can charge kernel PMD tables to a memcg and leave user PUD tables
> unaccounted. The private PMD/PUD allocators also omit kernel ptdesc
> marking.
> 
> Rather than duplicate this handling in each architecture, extend the
> generic PTE, PMD and PUD allocators to support architecture
> initialization hooks and non-zero table orders. LoongArch, MIPS and
> parisc can then drop their private allocators and inherit the generic
> GFP selection and ptdesc handling.
> 
> This series only prepares the allocation interfaces; the runtime
> vmemmap conversion will be submitted separately.
> 
> Muchun Song (3):
>   mm: generalize kernel PTE table allocation
>   mm: generalize PMD page table allocation
>   mm: generalize PUD page table allocation

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

>  arch/loongarch/include/asm/pgalloc.h | 48 ----------------------------
>  arch/mips/include/asm/pgalloc.h      | 40 -----------------------
>  arch/parisc/include/asm/pgalloc.h    | 17 ----------
>  include/asm-generic/pgalloc.h        | 29 ++++++++++++++---
>  4 files changed, 24 insertions(+), 110 deletions(-)
> 
> 
> base-commit: ad9f2d463666c64e94b04be5263c9bf8f9f96fb7
> -- 
> 2.54.0
> 

-- 
Sincerely yours,
Mike.

