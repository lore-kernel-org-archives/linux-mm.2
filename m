Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33584606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IXzdUAM8
Received: by kanga.kvack.org (Postfix)
	id 973986B05E3; Tue, 10 Nov 2026 07:04:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 923B26B05E4; Tue, 10 Nov 2026 07:04:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EBA76B05E5; Tue, 10 Nov 2026 07:04:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 572786B05E3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:04:40 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA4EEA0344
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:04:39 +0000 (UTC)
X-FDA: 85419077478.25.E380EDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 582522000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:04:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IXzdUAM8;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794312278;
	b=DPlzcCzFcB1VgswfOyCQy0F1ZeOaXtPCydc4LuTUPd2aMN7p5xe4eXbfT+oOi8dzW4GYt+
	4T3La0drXYN+rneUEA66feDrg58wLshxkXzoY2uHIxq9AR6Fl4U91RVqyCHAkcCBdf20WF
	sbxVJc6nsv+cFW5jytx5bIartBNmdkA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IXzdUAM8;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794312278;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0aSoJsBiqEIUd5UKMI0ygCRRPttcqSGpsbYPXvmzyAo=;
	b=TIZ6/U2VpiCSNfnmePDAXPbGy8ZMNt6GaFplxybTsoW62kAIazm36162P8L+9HlnQL/Lzt
	/VFtzD0/8rGsXeQ8a3xab9DDrQnVRvdhWYRChGVrBK5kwq++t5kXXrH9ftMXNOaayENj+v
	PRfK4Wa/zp9zFenaL0qEu6NO84Hb8e8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A4CF142B6B;
	Tue, 10 Nov 2026 12:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09941F0089F;
	Tue, 10 Nov 2026 12:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794312277;
	bh=0aSoJsBiqEIUd5UKMI0ygCRRPttcqSGpsbYPXvmzyAo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IXzdUAM87+XzkIRHiRfpnvI2s+xEs0XGnrwwoMUMnPUBZ8y0t2iWRV2E02ewXhHVA
	 NGTQQWa9XUk+/jgWgg4UYrVMxgZ8twmDATpIgz+WtIg+U1h7AQNywdERSmLtdwu+1p
	 1yJ/Cnggr377uFPGHBsUD8zjEVac0UROMkRTam4odzqIalGQdG1mQOIz2x0Jmt6Wre
	 bQCax5zsRZeqSQ/zocON828Sb0iSGXeoba6O9YjJ4RcTJXeZX0kiYGeqWNnHm032xd
	 BHE14V34Hfg4Q5jswGMHLXEN0FNixHLqCYMQ9LhWCI+ppV7sE74UNHdfgauG7hJlTK
	 mcgceR6ybYdxw==
Message-ID: <sashiko-outbox-206974@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] mm/memory: refuse to map page cache folios that
 are not uptodate
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S2lyeWwgU2h1dHNlbWF1IChNZXRhKQ==?= <kas@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQg?=
 =?utf-8?b?KEFybSk=?= <david@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Hugh
 Dickins" <hughd@google.com>, "Chris Mason" <mason@kernel.org>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261109120403.82361-3-kas@kernel.org>
References: <20261109120403.82361-1-kas@kernel.org>
 <20261109120403.82361-3-kas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 12:04:36 +0000
X-Stat-Signature: t778syq6nps4huq1wgo1otm8777yecag
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 582522000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794312278-503985
X-HE-Meta: U2FsdGVkX19etYZYM728/BjCQW2f5lfb7GAu9TMCdL5ubUk4rK4pvNLkMg/Amy/A9RO+ovKOQJRLoiG2t8+kp4NxpFqE0xcadO4nl+RGncmTvXJgEU/1Z1neF3ioi1n5mZCuF6wFbK+HP+POM75/N0q4TgETiWu9P0pSqH3adBkzG+2RQERb2MU48/kjUzGVcUiy4XJ31tkWB3AqPuK8bxJ+uhYD7tuILay0rsbywGqnHep/EyW/Ruvv5ZWY64g+Y5kasVkCJbc9XGCvyS1HT0VUSyptRR0OnuqtxObZLAo5LirP+7gULAKJUUQILmL72Kgc9C2qxfhun7BeRSRJZVxhKpcWG/cjCSA0LoOIiJ4yeYTArcJqhyqk6bS+0vm7rWLjRp3HQagGGGxSqbMOP/2KOwjHXXzJG7Zc7IV6TOQqV10Ek/RiBx03zkR9xEGdoY6hzeTH5P/ylrxcSlNCeiKVFgcCHhi51hUM8Qf8jdUXnPIhUZsnQjfHATREwzS+zamM9PIaT3T79o5KJtWWK8tMGDdP8+ez/veHwT0CftYeHySyEX42pVJUHyKJv8r4KvPIsrMD1KuBvWwLBCVFqOpcyaMFFLsMboifwNDNZKHjU6nMSHuDhwGBa2eZqIGzGhRFzeCNFBBcMiTrACErPJmpi9u88gwP4xicp0GBRxPCCKYviud/Mxlmt0yjxjPaPu5W4UGHdFnwtL+byFW9Hdq5ny23pTR1nSJaQ7iMAMMkPwKgXqLh8hE2J5PEcpvgkW+IG2JYz/kOOwblM5I+0f+Nx7g8pOtm6zUhIHs/qe8HJLpPMQ0GNUsnOKFpDZYirFk5TMPjOD4Vnj6PZWj0PCl2uEKX48IRJCk0wWX8aJE0++aM8jXgFNkJKMZXE//tfDtlqB366g/x/0pDjeUTdi9DSbYbXfdlQ3baL8mx6BAp07GRMW/tncCcsfWDxPIShXQEdPd/kXMcVNY5PEO
 zpEVllvW
 P+VjHu21BZ6CfRBpawgKxqbPLXQoeMHUVOSs3D3DSeqgaUJ+pHofzcJRginf+Vs+B6V94QwTLiT2bUxDjpwX7l6Un0a2TkBLs236VJmzzCMQOBDEWbSW6dvd3843vinfT8x96P0QEbC3/VPFEarRN8/dnnQT3JkZag/kJNS60OVkNr9Vyax7Rh9NIfGuCbHt0yaIQRIwkL1/pb5W9AjXspbo999bnGOUz+TptjA7T+bADt/8QVdccYdG1CQ1b/i3chrVJzykWxIJmg1jcFMkJ6NK4Mk9n334wVlQY6uhD3/vKV38qs32/4k+fJ6+zgzWWc++fo3J++werokWiVJasdS7lBc6rzFak+omZrM1XzxBex4rObvWFxpBbWBlYYVyXy/+inywBLTjhdz0m/foU4vo6zRtpKAXF5BCz47ypQZH3cG4h+hUZ0b+QS+VOk0QvVg82gbpxtArONFqOO4c6XBDcBr7yRPVTARVHsmWmn7lhY+jHqTmizFPZQfoC45zVHBu2pU9wzjQ7Blce3mpj9bW1l6wANhlPfmgHAXpv16nQ0i0A4naMIc5ldnIFx6CXdE5NG0Y8jP0Tmj1G8f3LKi8Sd3qyro0Sw6uHZoUB454CdUf377feAsJB/YtQHct+mPEs6nMmAGtOH2yOxSHiWfxD8aGW4B/3NAg3Zm26t9ZXAVU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm: reachable WARN_ON_ONCE in do_set_pmd() via MADV_COLLAPSE
--

commit 46c971cfbe24534d9e4da886ac3a3c5691497ddc
Author: Kiryl Shutsemau (Meta) <kas@kernel.org>

mm/memory: refuse to map page cache folios that are not uptodate

This commit adds WARN_ON_ONCE(file_folio_not_uptodate(folio)) checks in
__do_fault() and do_set_pmd() to refuse mapping page cache folios that are
not uptodate and return VM_FAULT_SIGBUS.

> diff --git a/mm/memory.c b/mm/memory.c
> index cc1d0b7d15c75..2324c04d632f5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c

[ ... ]

> @@ -5727,6 +5734,9 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct =
folio *folio, struct page *pa
>  		return ret;
>  	page =3D &folio->page;
> =20
> +	if (WARN_ON_ONCE(file_folio_not_uptodate(folio)))
> +		return VM_FAULT_SIGBUS;

[Severity: Medium]
Can an unprivileged user trigger this WARN_ON_ONCE() via madvise(MADV_COLLA=
PSE)
on a fallocated shmem THP?

shmem_fallocate() inserts PMD-order folios into the page cache with
PG_uptodate clear.  When madvise(MADV_COLLAPSE) runs on that range,
collapse_scan_file() sees a PMD-order folio and returns
SCAN_PTE_MAPPED_HUGEPAGE without checking folio_test_uptodate():

mm/khugepaged.c:collapse_scan_file() {
	...
		if (is_pmd_order(folio_order(folio))) {
			result =3D SCAN_PTE_MAPPED_HUGEPAGE;
			failed_pfn =3D folio_pfn(folio);
			/*
			 * PMD-sized THP implies that we can only try
			 * retracting the PTE table.
			 */
			folio_put(folio);
			break;
		}
	...
}

collapse_pmd() then skips collapse_file() and calls
try_collapse_pte_mapped_thp() -> set_huge_pmd() -> do_set_pmd(), which also
does not check folio_test_uptodate().  This hits the WARN_ON_ONCE() and
makes MADV_COLLAPSE fail with -EINVAL instead of instantiating the
fallocated THP.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109120403.8236=
1-1-kas@kernel.org?part=3D2

