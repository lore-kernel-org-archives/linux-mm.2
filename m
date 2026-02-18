Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A01C9E9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 07:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 086EF6B0089; Wed, 18 Feb 2026 02:52:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034026B008A; Wed, 18 Feb 2026 02:52:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82F76B008C; Wed, 18 Feb 2026 02:52:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7B076B0089
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 02:52:40 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92D77C0833
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:52:40 +0000 (UTC)
X-FDA: 84456810480.06.6B31650
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id E0A2BC0002
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:52:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XBFwv/J0";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771401158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bh8mNK6cWdRHE9lltvHCp/Tk3qXoITR4obKRh/opo/Y=;
	b=P/EmvlhmyKj0nydQ2x+ovPA3fJfXfGcq+mFQnYyc9qxFHAhVWoOKeisguQ1Ae3WGRZey5v
	LZPHGh/w67SLjf8bo/n5qWwgudLzpq9c1ZJiJ4/YYbcG3DF8rQ8vUSQZaAD5ECgWpfNWbt
	4fauDtVTb9lCXIjwwKrLZPKhKorcr98=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XBFwv/J0";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771401158; a=rsa-sha256;
	cv=none;
	b=ldKr0J4AzqDVBjjLXT0htdkCeRvm9dEdt/JpAoWS84IFxW2TI0GHFE5ZZjJAD/866hbpBK
	bsdb5YHwZEBa3677PwS1Sdtm9DtuEzLWrupaOKxpL1sjXCLCpdsnNjw53qvBr6T88ZyHBt
	yTActf3F0SVH4bmqTS41YemAuCgGaoI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3047B600AE;
	Wed, 18 Feb 2026 07:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BC7C19421;
	Wed, 18 Feb 2026 07:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771401157;
	bh=xHxjG4bDz4pgMox2OsAsfkgSSmmHF2eogXtvvKL0pkM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XBFwv/J0DHxfil/5yD6SPFQuYpECUHR5ZkFwRRYUuYJigiix4wzFkNC0ctIpYoBzr
	 +B033FA2rkhfJBYWqPcqOcPyi+uvOk3iTMIFgQwOScyB/0CPD3YFTxLJRUCUQ2fwiF
	 lx1Z61wkbIIabzOlIbr6+HAJ3RdLhPJuOLL+Lzb7hxNEusLBuOETkfMOZgrRp8akR/
	 iiOUz7ij/AH7Lu4BDp0/PXkbshEP+BDDL0M+SFKHh+4BxJq9glypyjclCQasxxJDAk
	 nW6P7XLVtdmDlnomvjPB9+HnqAAPIGYomS1z5G9i8fux+VWWPhtrgYO+ocIaj6qL/4
	 4F3uFGDQRXr8w==
Message-ID: <0b653dcd-842b-4360-bc1c-8fe779efbc23@kernel.org>
Date: Wed, 18 Feb 2026 08:52:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/huge_memory: Fix use of NULL folio in
 move_pages_huge_pmd()
To: Chris Down <chris@chrisdown.name>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <aZU1vSmn5aF8xvJj@chrisdown.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZU1vSmn5aF8xvJj@chrisdown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3bcextcdyb1hkhxmi8cphest14j5x7xt
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: E0A2BC0002
X-HE-Tag: 1771401158-709805
X-HE-Meta: U2FsdGVkX1+lrkA7hQDzdBHMIKfr9vfFjimx+rEAFgbX7Vcz2pq99g6sXYP56CNKj4HPVlSNKWHCoVD1KDxF4JooHSzBUHcNQiOvLznGsrNAiyBQk/1tatbTw6wyhRJONyLmfpoJq8yoNKXUdk57z3T0MILimRrdt86nV7Ke8rhcjwdIU3j6GJawkKM1tTGW5dH8kAYsd90SKHyS38iMdNdCNmgLCYrtzDPWI4nrcx5o8BTIayZoETAYdrbpOYbtRH9ouV+AGF9UaflP7g5b17Pc08znfM4LDfmvradsjUFbS3VJw6GGCXWy34LRAaGIegd40esbFvFkCcjGScLqs0B9JAmapNcNVApdRvdidGwlssd3kNWySoaG2101tdGU8K/nrSFnAVAGl9co9OpQs0p3/CBnqGnfrZvn19QuFDURjJ0isjod0KvZfi1dhLW6BMUuDWKJsRTDoDgMRNVROZzdy6aADg9WWvYzUoWow5DA9aWFAvwY3cKD0wAp0nfm/p0Pcqvo0tWToB0vCRKQ/2JogmesskALAX0A9kn9tTjrFHq+L2YGST1iq5G75jzolUYMasA3+2YND48MMSC1y3SoXBpyf2b7vhYIuu/wxlmT1RbAPEcmgdjNif0IjYrngC2P9jWIFQ7ZIxchCpsEU7/3WGLibQRk2B0HVYU6qalVgNQsDuCr7kJOd56cAGkMEHJ//kBWnvjYqPRBpx7124NsATQYvkbUM5VbjVGoHq91/j+E25owVmCU2qAsso24voVpNoGk9vz3kAsScVDgnYSFIr4kUnQvasjKjiuikUMchr/oGbaTKpQ7zXoQBOAF8YMxoAl5BPSg8hiFt2lwReMXkBPTMUE2r1a2ds6YjmyPbTVpJ8Tw+a9F/W4PbPGROdWfC+xXAuIrTq/REbiFR46GPsqKwqjiAasBLuQ5Ju+VvX0nKxAgfGgT041hgY25+qv9BeE+9WNoDhJPaL0
 CvUBIGa1
 xH8teBSXa2tME1hyaT8usj1mgpZUJBPBPq8Me3EZGJPBIVwyG3eesoAc1F8FMkfF0S5PdIXt1waUbd0wMCQ1lR6dZ9TkS3dQPCgLOuIPL6hUtO13tw0JzyvBqDohaeacOYQXL93yxTJgyr4tgkI0ZaCSwqBDqeytItcOnzN8sz91bwr1mVYyVi6IVxVII8H9f3o76vSgcldAUPhYMOzu4yZFAY64CjHjMKcvSqmFdWVCl3NQN0KoT4wQld11DQjoSKteBZgptMAH/iBzWfzjmdeg9hZJK/TvIkSydbYpFNuS4F/zNS1ybjBICzA8YRNyWhWJqCg8QAouSJWw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/18/26 04:45, Chris Down wrote:
> move_pages_huge_pmd() handles UFFDIO_MOVE for both normal THPs and huge
> zero pages. For the huge zero page path, src_folio is explicitly set to
> NULL (used as a sentinel to skip folio operations like lock and rmap).
> 
> In the huge zero page branch, src_folio is NULL, so folio_mk_pmd(NULL,
> pgprot) passes NULL through folio_pfn() and page_to_pfn(). With
> SPARSEMEM_VMEMMAP this silently produces a bogus PFN, installing a PMD
> pointing to non-existent physical memory. On other memory models it
> is a NULL dereference.
> 
> Use page_folio(src_page) to obtain the valid huge zero folio from the
> page, which was obtained from pmd_page() and remains valid throughout.
> 
> Fixes: e3981db444a0 ("mm: add folio_mk_pmd()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>   mm/huge_memory.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 44ff8a648afd..fed57951a7cd 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2794,7 +2794,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>   		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
>   	} else {
>   		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
> -		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
> +		_dst_pmd = folio_mk_pmd(page_folio(src_page), dst_vma->vm_page_prot);
>   	}
>   	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
>   

God this code is horrible.

Why can't we simply move the PMD like move_huge_pmd() would do and make 
this code less error prone?

	_dst_pmd = src_pmdval;

According to validate_move_areas(), the permissions of both VMAs are equal.


We might have to handle it just like move_huge_pmd():

	_dst_pmd = move_soft_dirty_pmd(src_pmdval);

To also set the softdirty bit.

Then, we would want to just clear uffd.

	_dst_pmd = move_soft_dirty_pmd(src_pmdval);
	_dst_pmd = clear_uffd_wp_pmd(_dst_pmd);

-- 
Cheers,

David

