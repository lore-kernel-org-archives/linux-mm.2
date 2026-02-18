Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1687E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 08:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32C9F6B0088; Wed, 18 Feb 2026 03:01:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3011D6B0089; Wed, 18 Feb 2026 03:01:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F9CE6B008A; Wed, 18 Feb 2026 03:01:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D22E6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:01:43 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95F26C0FB4
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:01:42 +0000 (UTC)
X-FDA: 84456833244.03.E12BC36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id C4D9740009
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:01:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Mak/MiUk";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771401700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3ruuMTofIo9i/oK9HcACY4R1qEmnhhazzng5LpDh+Q=;
	b=GpXWNQvNfizba+CDYdSot3/DlQ8UQSSokDc+9olWorKFlgUekcP3B2UmCHS6BSMn9e+PtX
	Bs9xBQGNYwSQ7+dPkhyuQYmSj1ovWVCqp+TxD9ognHaJkyibR1s/mu3jQxfl8UW5tgUCSr
	y1VK1AoHPcwOU4AYXMs+KC0DckQm2fw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Mak/MiUk";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771401700; a=rsa-sha256;
	cv=none;
	b=O5rPxjqcaVBeNJojCNkIgiYahOd/+kRrOVxXgQcpqWElBRRbmnXgbp7LkTliDtM02WBeWI
	FY0RXr6nwTnvA1167wV0xn/CbNUEd9R9WL1Np/4vMZsrECue5NIIQ+ybipo1TIinMgur/f
	uDMNB0QwQPsDNxGGCuC/HYf8DVdYIeQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 193A3600AE;
	Wed, 18 Feb 2026 08:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D7EC19421;
	Wed, 18 Feb 2026 08:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771401699;
	bh=8adjUiJs+jIyBTxznrgbvF6vxedp6JPQT1xLEZRiOgg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Mak/MiUkd+UeBgThN5oJMu2tRhUeTEbSkzhtbgGuJ2abeIXAAhw/WSRG9RVeEr5Jy
	 kectQVA4ZvBcEu5IfC1xcl2LwP70llm2OY6xx5vz6Xh+UlGb2Xnbt1IPCg8wtdV0eI
	 OTXlP7aryLb2yWcL9zFI4WO/BinKkUOtJSWZ/B3OIxZLi1TjEOL1JpMvq6p42u9/EX
	 CwE2XevGvDSUf/bj92fb58e8ppKJuHM2y36R4AVnu97jCsOLCMNT/qtwSAQIRXnJD4
	 /H1DH/dxGW9Xjzc3PYEpnU8f3hbg6XAdMj47rurWmWWOLfcQRax1QJ3RHZVHR5xIuP
	 5piDRYPkhSgIw==
Message-ID: <f791fed9-5d90-4d17-bffd-985dc83ec0cd@kernel.org>
Date: Wed, 18 Feb 2026 09:01:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm/huge_memory: fix move_pages_huge_pmd() for huge
 zero pages
To: Chris Down <chris@chrisdown.name>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <aZU1kTOLcrr-Z371@chrisdown.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZU1kTOLcrr-Z371@chrisdown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C4D9740009
X-Stat-Signature: icr5k97phab6tt7upiobdsacr84usaa9
X-HE-Tag: 1771401700-469899
X-HE-Meta: U2FsdGVkX1+Wbmr7wpmGhTmazLGJ4YQW6+jDkHXGdljGpBRqYiuJRpi06tqezcHbPI6NZ6evfRbkj0MVVuyjIvJrQZactcmFkI4ZmdNTscItY0FWIAz+PFI2lavEoT1gi45JJhl3BLCGNN1oAHSCSYKw5628TCBb2g3KVzBn3QYIv295V/autfbNH9aQUrdPr894KTSqY0idAZcMRJ/qfVt1bnq5jNlf5ZGsND25bllegjq6SBnX7jJC6UfJJii9jvRLIUzjqgsGrX8e5Y4BwaRiHFI47NxMxiHZ59qPkaYkMEfltQ4ZLJNyPjJENfFYPASJ+l9amUjFlNAbruU0GkOFkCBDE3SjG++Th5qE0Mc/xoPW1fbzmbMrp1GTT9QYt6J4tcozO6t7v67/DK0BpJfMwzZkgvG/6ZMmhNNvt/ZZyIdqcS/CrRhnQ9l1d+/TDpje2r9Rje7e0hDKhAn61kd0wJhCqz7gsVjkPPjWJg555WVele4sxlXr18Cs48w+99PFThBfb9xwYwT3hO2AMLFhMaFO54rBAabFkDerKfN1X+IwMn7TnMmodoN8LCo9KJ9lUSz0QkHftoJnQobIUWAYhnIQ/PzLvefb55GJoAbSA89lEuEYtBfF+FkjGQ+M19fRzBSwlzp2lZsYW9J5/ApFO2nK72XsJMLaTyO0sHTa8mfgVZodXq1Ey26GWClm4ZnjzEultdMRKWlQ5ID4CoK9Wu60diLDw/V7anLfIneAroz7wRmmwdbPXhL/DJe7zCRQ3ru227J/SO9fB2smcRT5+U8k7eBrbZBIa+S9Ze44o4aF63G9Xy53gDvi9Cq/Ie2afqgJ5XmDv65CWpRwKH34Jhet3a5lCyAYqMQSHEVuaA7IN4lEMuIoISOp6O9zrz3y8yYXyf1WKKTysGrRt3HJ0khCRw7zF36+kkLHi2AIPSf0LL5NdkYJtwO8lMiJc2toomoa9sk795E522V
 ssXzooUm
 Za6QFY+42+VkgqfJ/mRPsXMGqhvVDpln7UmLPdG68nWI2Atu19Hy9dtOkBNpTDVURgiCbQL4XpF5Ezrw1YlqK7Oqd035ec9id5xFlRCvz2GdzmZTjFdW8SAaxgJrLirUphokLloT710Ss7Hs+8GVz5YXIM8HRxHbL434GLNv/pGMawentLSSFfaUiroEUrlUZJ7uszhHH81jwziNjxTOYIPCnQ1n/3NkcwKTj9Iuix2VCY33HzinGvl+XMFylRwq8YzP9e6hDk+duGyq30FcysqYiZlaaY0yMZylvPXEDfPa5OH1PVZDA2EXxWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/18/26 04:44, Chris Down wrote:
> Two fixes for the huge zero page path in move_pages_huge_pmd()
> (UFFDIO_MOVE).
> 
> Patch 1 fixes a use of NULL folio introduced by the folio_mk_pmd()
> conversion in commit e3981db444a0 ("mm: add folio_mk_pmd()").
> mk_huge_pmd(src_page, ...) with folio_mk_pmd(src_folio, ...) in the huge
> zero page branch where src_folio is explicitly NULL. With
> SPARSEMEM_VMEMMAP this silently produces a PMD with a bogus PFN, on
> other memory models it is a NULL deref.
> 
> Patch 2 adds the missing pmd_mkspecial() call that was omitted when
> commit d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero
> folio special") marked huge zero folio PMD mappings as special. Without
> it, vm_normal_page_pmd() on CONFIG_ARCH_HAS_PTE_SPECIAL architectures
> does not recognise the moved huge zero page as special, incorrectly
> treating it as a normal page and corrupting its refcount.

Thanks for the report and fixes. This sounds like something selftests 
should have detected.

Can we teach  tools/testing/selftests/mm/uffd-unit-tests.c to trigger 
that behavior on the huge zero folio?

We have uffd_move_pmd_test(), but it seems to focus on moving non-zero 
folios I suppose.

-- 
Cheers,

David

