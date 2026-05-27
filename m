Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CF7BCD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 15:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DDAF6B00AF; Wed, 27 May 2026 11:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9675E6B00B0; Wed, 27 May 2026 11:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82ED46B00B2; Wed, 27 May 2026 11:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD306B00AF
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:53:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F2D6590D51
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:53:20 +0000 (UTC)
X-FDA: 84813644202.29.E9F37F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3FF0480014
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:53:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G9HbQqFk;
	spf=pass (imf02.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779897199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=acBXCFXCO0QcppYUjrSg5CthjV5fygRW8wTTyAY/7iE=;
	b=x3NeonFE287aisbdNMMYFoWaN798KAlc7tzJmwz1Zpu0+nmwbPSbGspkKPqg55jzZr2iVH
	XbEob17v1aJpbMl8PuS39tUlKddOIDiGK9XRNJygNClQpmptUyg5/dxmcphBoLRvZjGpn1
	3CZzY05AxZ9/oPRc4DjnN9hTT6LDGD0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G9HbQqFk;
	spf=pass (imf02.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779897199; a=rsa-sha256;
	cv=none;
	b=eMvTpJumwU8gv/OJB5WJxXOrd300D98dLXNVWpqxsA457/atgkEFFyid0+FVtKE7Vf1oKL
	lFujRqROOXJoYD8F0uf8dxq9glJZFzS9QyRmIyzstgP898Qi6+1pKQxc2bgMboc/Mo+LAv
	2ZoSuVKvXQJNIEjEUKdxjgAKhzyuC5A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 526F140256;
	Wed, 27 May 2026 15:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3177A1F00A3D;
	Wed, 27 May 2026 15:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779897198;
	bh=acBXCFXCO0QcppYUjrSg5CthjV5fygRW8wTTyAY/7iE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G9HbQqFkbMDy9esmTnzQen+IsqE10YcPwdZPM/k37brj//37kMvDUcdqRZTWu09P7
	 TIm58yvF+BGnMQpev7utwqm+4WZJS8z5UyNuAfohtlCMymAYbWBkDS8zXsfonsqbGO
	 GHMhKtARZqlxTW5H3ArMeE/DtSaoJPyBuJKa6+F+0E/0V58wvPfo8IUYhDhJua3PxP
	 O4FPqMmFoB604MOOeKmAb6kVXrUvQJceozY56kggYmtOMZ74I3lAhK3L3UMLpGZnuJ
	 d4DZzF8Dc8SRubj3ckrsnTecUNoPaQKki7NT7aRTFCYSnPSpP6lDK1J3sSe5OxRSkc
	 Fnkca5bZ3feMA==
Date: Wed, 27 May 2026 17:53:06 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Karsten Desler <kdesler@soohrt.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [REGRESSION] x86/hugetlb: AMD F15h VA alignment offset breaks
 MAP_HUGETLB alignment
Message-ID: <ahcTYufV7P5Cmotq@localhost.localdomain>
References: <20260527143643.GO31091@soohrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527143643.GO31091@soohrt.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: cwibap5f773qgf5fcjpkdpgxb1rtcqqw
X-Rspam-User: 
X-Rspamd-Queue-Id: 3FF0480014
X-HE-Tag: 1779897199-119836
X-HE-Meta: U2FsdGVkX1/ciENuvzEEzdgj/l276SBqots6G/TxTst8L7WfjIU/mDmOwgML+DcscMjw7D2dPrPPhs0WHclhPgkMUWXIfb9jjqedxDDrou7Vn8YzQ+Ogy56x4Fiq+XI33PKURP8/M4Zcz8EXwKB4pkq0C+R4ZyGqcqoIe0AkRqOI1KDDagjbRlJWSn06+q+S8dIIqoyqs+WFqj7WQoLmERLAHEY6h/WZPvyE8Je5IKdNS/9mHfpbfVeLjr+1XKOeeb5/llJn4qV99dtxBGTarBxpAN6Z6PRrp28bZs9vxZwKwQpNHM189GWqW+KwGU07Y8c1iwZJ1d1tWU0Fse9waqrCuZ+dx0e8ZVp9ZyJUMAj3ABjfPETyYybzKO5CKMjX+C3zMMKXTNWbQSVc/xMTijxvqxTXEzK/ST1OkeMPQkA4xq4Asiw2lf31SBESoOrZXWGpf05KHP4GPYoCoJI/fbaSwNvJcaxXcFaZXefotAyNBMJfWUgTuKXRZfGmzKMoVtnxRLxMgOBEJMs85pVsvNwZAC+ik+Ab/U0ZDKp8RwLpfzYjM+Jyt9h2e/0kNIqZEIxYp1Rz2eoyXODTEKs9VDW6ewDHSd7pnwnGblTFJKehgrhLAvybbXH/gtCyfgZM5n/OKD6JZMuxFzJn4GnKmruWKmJ1lYyJ2p7UISm3d9ZO6Aga2dg+94mAACSBPQ2zoKwE3fmZ+vQay/H/0E5QhvbnE4A+iECQZJKIztWmabcQqvv1FBpYUQR7yoiaOsrTMej1DBNk+lQOYQfKpiJYt8WdJMmCHDDbLQIzisLydzmkOv8o1bzZauBl/3kufaftVAMzNfge8KV3nXOYpTo7oOeeWOOLHl2VlRTC+BztQkxv1SwK3P9s+meAFW+HueUdlZd0aHGkcQFfWsau1gRZBI2D5MOZbrrBKA2a0li1fRIHYa8YP2Xaqev++/njqAEoqqVodmt5ezGbYIeuj8J
 NMhzp6Hk
 wvLU1S23vV0liAy31rLh4A7UABNH6Ask/lwz+IY1FlQRcByno6i/+Nnm1Zy3w4ZJ2qTa8joRGpfecw4M5ysFbMVkJcN+m/SIE1ds3Fu8JSfsxsnzPUe83ILysAYMgT7oGcHEQl7sqGgcW+yaeo/oZKmcj7QtVNUN0gyApGJlygBwan69IO81Wz8vlyU9da+v2HGgLOebvEeg4bbMp1Wu+D7ZLBxlF5efcjo9Ifqkw49vFm9L76GoyAxRLQ7yMsndp58l1+qSpr/YnooqyrpeTYH7iIeQuHVP8vNzgZDEtknqMVRU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 04:36:43PM +0200, Karsten Desler wrote:
> Hi,
> 
> I found a reproducible hugetlb regression on an AMD Family 15h system.
> 
> On some boots, mmap(MAP_HUGETLB) returns a virtual address that is not aligned
> to the hugepage size. The mapping is nevertheless installed as a hugetlb VMA.
> When the process exits, the kernel later BUGs in __unmap_hugepage_range().
> 
> 6.18.33 x86_64, AMD opteron 6238, 2M hugepages

Thanks Kartsten for reporting this.

Ooops, that would be me.

> Example bad mapping captured from /proc/$pid/maps:
> 
>   7fc67f604000-7fc67f804000 rw-p 00000000 00:0f 12340 /anon_hugepage (deleted)
> 
> The address has offset 0x4000 within a 2 MiB hugepage.
> 
> smaps confirms it is really hugetlb:
> 
>   KernelPageSize:     2048 kB
>   MMUPageSize:        2048 kB
>   Private_Hugetlb:    2048 kB
>   VmFlags: rd wr mr mw me de ht
> 
> Minimal reproducer:
> 
>   echo 1000 > /proc/sys/vm/nr_hugepages
> 
>   mmap(NULL, 1229824, PROT_READ|PROT_WRITE,
>        MAP_PRIVATE|MAP_ANONYMOUS|MAP_POPULATE|MAP_HUGETLB, -1, 0)
> 
> On bad boots this returns e.g.:
> 
>   mmap returned 0x7fc67f604000 aligned=no offset=16384
> 
> and exiting the process triggers:
> 
>   Kernel BUG at __unmap_hugepage_range+0x5ef/0x640
>   RIP: __unmap_hugepage_range+0x5ef/0x640
>   Fixing recursive fault but reboot is needed!
> 
> The following is AI work, sorry if that's total BS but at the very least,
> I can reproduce the kernelBUG and booting with
>   align_va_addr=off
> works around the issue.
> 
> This is boot-dependent. Some boots work, some fail. The reason appears
> to be the per-boot AMD F15h VA alignment offset.

I have to confess that I completely overlooked that scenario, so let me
apologyze.

> The old x86 hugetlb path in arch/x86/mm/hugetlbpage.c only set:
> 
>   info.align_mask = PAGE_MASK & ~huge_page_mask(h);
> 
> It did not add the AMD F15h align offset.
> 
> After the v6.13-rc1 hugetlb mmap rework, hugetlb mappings go through
> arch_get_unmapped_area*(), and x86 currently does:
> 
>   if (filp) {
>           info.align_mask = get_align_mask(filp);
>           info.align_offset += get_align_bits();
>   }

Ok, I see.

> 
> For hugetlb, get_align_mask(filp) correctly returns the hugepage alignment
> mask, but get_align_bits() can still return the AMD F15h per-boot offset,
> e.g. 0x4000. That produces a non-hugepage-aligned hugetlb VMA.
> 
> Likely introduced by the v6.13-rc1 series:
> 
>   1317a5e7f7b1 arch/x86: teach arch_get_unmapped_area_vmflags to handle hugetlb mappings
>   7bd3f1e1a9ae mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags
>   cc92882ee218 mm: drop hugetlb_get_unmapped_area{_*} functions

Yes, that was part of a refactoring I did some time ago.

I will fix it up later today/early tomorrow.

Would you be available for a quick test once I have the patch?

 

-- 
Oscar Salvador
SUSE Labs

