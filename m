Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9D57CD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 10:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63CBB6B0092; Sat, 23 May 2026 06:03:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6146D6B0095; Sat, 23 May 2026 06:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 550EF6B0096; Sat, 23 May 2026 06:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 417276B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 06:03:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1AD2F1A0B12
	for <linux-mm@kvack.org>; Sat, 23 May 2026 10:03:47 +0000 (UTC)
X-FDA: 84798248094.04.78AA7A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 77EA7C000E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 10:03:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b2v/Ws4X";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779530625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tHmN2BHFAqmkx4+yIKAwc/rhqe6iOFn48NmkgaH2AR4=;
	b=BeF2zlp6gippa6Fa0V2fgqa+WgkqoI/eS1GiN0Ch0GC/Sq84xv5JTSLWkVLEGIA+zsYIYM
	ggCPNefNmSE8dlv1v0tg7++I4bKr4WL1iHi795aHqlSki+sKbQL0vzOlzcxixmevldkCYB
	MYlHKkwP/Mi+l7ns7EOmVVVv+O4f1Uk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b2v/Ws4X";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779530625; a=rsa-sha256;
	cv=none;
	b=fuulTCt4Q/4DlQUZNqO9AnqU2JakDF36fOFgLhZDnwhiNUNWGSwBBTBa5+k3z+Zt49irxb
	PH4S96L6HFg+9cy6dxa9Y1ipBT11gLmqqymlWQ7jWpmCDHNYyPDgWe6i2krimE4nN4lyNQ
	iu9IlXs3ajTS07lDkhERDSJgl0D0lwc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5234C409FC;
	Sat, 23 May 2026 10:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA061F000E9;
	Sat, 23 May 2026 10:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779530624;
	bh=tHmN2BHFAqmkx4+yIKAwc/rhqe6iOFn48NmkgaH2AR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b2v/Ws4X/OrJeoVd2MADb1/OzwlF6mfWpHskl0n53AtfrSWsGgexN3Yaa2xwr+Tgb
	 NxYvlMdRrDNzJNcemlWPWIZafZlAJ+IbO2Ay2XBX5cKlRzDab8WGSMMtKIdylDbLPH
	 joRzNAZdmyWyHGAzrW5zkWygvSxFheziGrqE4vs0cldK2Jz7LgE7peYrq7dPzjGpsZ
	 MdFNSGR6VDJSvQ1tnOQNvcAgH6LWWf8fCUvCYtWzKfh4MpqTCf0r8FubYVyZWrcYUk
	 Yk+89/7C5VZvHVkv453mbcpMostz4UddeknfAJnvcP/RyMnEpCuP9//GXhJ8CnT7Na
	 eLq5UlIcIHnug==
Date: Sat, 23 May 2026 13:03:32 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com, linux-man@vger.kernel.org, alx@kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH v3 05/16] mm: add MM_CP_UFFD_RWP change_protection() flag
Message-ID: <ahF7dNveFezH5bEy@kernel.org>
References: <20260522133857.552279-1-kirill@shutemov.name>
 <20260522133857.552279-6-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522133857.552279-6-kirill@shutemov.name>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 77EA7C000E
X-Stat-Signature: hnkfuokei1hfeg8bs7qesgu1ms4gnxxg
X-Rspam-User: 
X-HE-Tag: 1779530625-590630
X-HE-Meta: U2FsdGVkX1+BI/tuHXRsf5gk7aUT9iLj8UEzKlU4skfPHE8SDdDaRQZUEPfYDgrXEXIayrA9iw0wiwRNdkZ1/kqOUh0WU+grB0Eqo5gtOuiwWSEsLQ2H+qkggdtnYwAVyvsWlQTfHbUC3qixAH/5O5OWS1yl8iMZGbcU62Q/2SydgkByOS/6ULrmR13sJyC8LC94ga3OU4jX2Fe9uEz3Enk3aC/lN4c1a9L2QaBW/4fumUQtMFCPu2EctDcOmnUUILKktzVB39G519BiXceBd21EER/9nfrkb3Yg5sd4y79okAa1mHXSlTOp8L6jgNyERYi2uALbtzrpONJbzpF73oYvIRFMn2zaowH+7XFn1AZYZlGrpr2AUBVJSBC7LTeQMSaVPJLjZz/tQQUywd144r+Ax0lGAXrQHGgLt5Qr0bnfRW/DxjsTTZgxEPujf+Gyfin1/6n0u5Mf3klvxwDtsFnOsb71n2gF25O+wNWcc9hNuA30eOMG/fvKgfcWeve76GYH/mqBzBSFlgiSk8kU0j9isvrkebTjjnFqzCdII1Dg0Dw0fWFsZHicvy7aQ9JAtHr42GkUXUa/4y6+exq+vSZlpM2e6C3bzQMWHRm4MR2J/lZXAirPyoXWjResmCQXS8QA/WoolmuU0i7AJ+wiFtxhcyqFLwbkpBKJWZrcf3xrjCRf80K/PPp6bhpJ3zPC9V3afDSmq3yBleMVNOxi7ACtithQY1WR8PbBMf8bA0NhpGtaXR+CYVkU3ptvNK+hJToGJ9GpXYGadNslGMTL17o7sU7Tp4/OrhrcTz1fjoinz9tDrwdB4bDjOo2Gq9VIzmmJ0qB944la/UA4jMslQE5FlovWc6w36YTqiMfn/iS1V4tMPGW4r8msWoMuD5HJ00xOHQr88dTgE1BgSxXra7IFYWsF60SSJfi3nELqXPwoTVg56DH0TRMoGlqkmVSsHzVpm/7pGe4DdcN13yS
 ENN8PzMb
 XYeVOMSxfG83AqsHWM5LLb8cn/YHaHGlZQ5WQXTFjjIu3gimaFJ9qH4nlPVU1paOOtWpRG6A9wO6DOqNuXc7seGdxSQV7l/Mhrreoyi15YJeotN3hze/Uts+iawCAS/lhTS2xaxVoW4hOd+lfFV5aHrYJMkxYazPUhneq/z6X7VVjOB9ZYcYLn3i86IJ9hKOjwZpqLkc4C4f1U7s0MLH7MbvO2C1rspAkTAXxfFcneENvJVzzoYIvseiPnF0KuNu+FFOoHjXbb9mI+eaa05GsX//WOOxv0iLHGnxB+0diljkHmevCiz6fd2evEd7XqPx9KxBR3hbkrdsOh+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 02:38:46PM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Preparatory patch. Add the change_protection() primitive that
> userfaultfd RWP will use.
> 
> An RWP-protected PTE is PAGE_NONE with the uffd PTE bit set. The
> PROT_NONE half makes the CPU fault on any access; the uffd bit
> distinguishes an RWP fault from a plain mprotect(PROT_NONE) or NUMA
> hinting fault. MM_CP_UFFD_WP and MM_CP_UFFD_RWP share the same PTE
> bit, so the two cannot be used together on the same range.
> 
> Two new change_protection() flags:
> 
>   MM_CP_UFFD_RWP            install PAGE_NONE and set the uffd bit
>   MM_CP_UFFD_RWP_RESOLVE    restore vma->vm_page_prot, clear the uffd bit
> 
> Both are wired through change_pte_range(), change_huge_pmd(), and
> hugetlb_change_protection() so anon, shmem, THP, and hugetlb all
> share the same semantics.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mm.h            |  5 ++++
>  include/linux/userfaultfd_k.h |  1 -
>  mm/huge_memory.c              | 30 +++++++++++++----------
>  mm/hugetlb.c                  | 25 ++++++++++++++-----
>  mm/mprotect.c                 | 46 +++++++++++++++++++++++++++--------
>  5 files changed, 77 insertions(+), 30 deletions(-)

-- 
Sincerely yours,
Mike.

