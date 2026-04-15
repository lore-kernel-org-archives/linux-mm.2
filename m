Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48C2BF4198C
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 10:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4CCF6B0096; Wed, 15 Apr 2026 06:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFD4D6B0098; Wed, 15 Apr 2026 06:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A133A6B0099; Wed, 15 Apr 2026 06:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 960CC6B0096
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:39:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D0BF1B7B80
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:39:28 +0000 (UTC)
X-FDA: 84660443616.21.286009C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8051F180008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:39:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XVrQ8U1P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776249566; a=rsa-sha256;
	cv=none;
	b=h38Lk11q35t843tRaZnTlOw8qCOsJpOE7zvuTnCWH6WnxfPwvMoH5dCC/uccNoU48G9oX7
	0zEUGlEoKgTM7BytrSQKtvj5UMtMwx6SO6ojzbZWdBU5tDwYMIbW3YrNabZF4jYP8uzId/
	TmEavfaMkb0zQz1EqibHLFjiNC/xOBU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XVrQ8U1P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776249566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKCrW0o6aXpRAmXs22He+QVIMxPsqiY/RjuF4ZJ+/YQ=;
	b=lCsMgjZMnThHNUTYfgSQjbQSruYwqHmGtUOj62Dv3aHgD20h6PCElEtRILoSvFecNDOjZb
	6JO4klH+RT4X+NnDOX3boI0rMh7Djn2TW73uaBTiOgXy9dc+P7lCxiFWc2GMNUSjfmConu
	bzaBSKmFQhmwu+lJC9WCbCSjmuhP3kU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB1FD41796;
	Wed, 15 Apr 2026 10:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E34BC19424;
	Wed, 15 Apr 2026 10:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776249565;
	bh=K7RukhB23YR3WJa/P9JAfup97CfUcFnGwXXICQ2wyfU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XVrQ8U1P2sxf3hOsdPR0lPOuE6D3Nar/YhKPORu24nsR1fezq+vsIUp3pNck2Xzdy
	 GRaD9MkEQHguAvHKHBJjfXZhnTnqBTDC88jRTaxu71EXop5DWraHOIrEgjH703dbL5
	 VmisIyiGLxKYAxewY5WOWyCbNmsZGHyki0s5aZdhdnqsswGLkImoiVaNCjK0SpUzU+
	 XXhrsiGA9TH5mxkSrr75fMytu+O50ZcKARywRPwLaAKhCTwfLQ8OsCAkNothX77YfL
	 gN5rdojqrJSFyK2OgxZ/t6GVfFWSBpndBCJuqMph2Cc/Z3Kf3pQaSKrUWPXMQSyUiI
	 LqjQcc7nMlGBg==
Message-ID: <0499741d-56f0-41c3-9256-0b5f9ccc063b@kernel.org>
Date: Wed, 15 Apr 2026 12:39:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 14/16] arm64/mm: Enable fixmap with 5 level page table
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-15-anshuman.khandual@arm.com>
 <4382c90a-bc92-470e-9aa7-4666753479ca@kernel.org>
 <ac73cc87-8663-4d45-8c0f-4a01ffc0fc29@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ac73cc87-8663-4d45-8c0f-4a01ffc0fc29@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8051F180008
X-Stat-Signature: pwjiemsgzbjjfk9t395honcokx4uxec8
X-HE-Tag: 1776249566-860806
X-HE-Meta: U2FsdGVkX18B3YrtBr25XEyQaPpNbO9B7ZhsItOEBfHQO6NqDHJJ6FueaBpzF37J4qEf4cNSSv72auj74mcpmTplhtmSIqX0hQZF9vNnoa0P/dwM8mPOeoezplXKoheuCbXF1XT0ydl0pP+NVxuDTglNsz1kBsEdUL9aEykwn+nTO2HEV5+5OGlf67NeNcPN/l1iVdo5mLTbIxk3xsD5fcYhKyDeBY1AWhT+4DszBGqSVigaxhMZtQkUE6uQfvf/tBTvZ4CtqQS2EGhZn/+Ww/dePT0qXy9BjEnhBeQpRiZkWXoQa5j1FjbSXg2XpFhGU+Ekfv5A1Ptb8TPgo59+DoJ9DNZUfThpGsR7g3UE1dnvPMbdx6vzlxOE0ISojAAYMsQqEO7bNnW5Vg0eYPOiALy7FppgPG7eDYfF1MhnW1nHQOpqix6nPusRT3Nu1F6g455mh/C89RtCqAEL0amtwDEwbjLnYpq4IwbC1/Iq+JQNnDoBZfO6U3KadGiKTtFJBTl6CxSq6hg+8goMETPXnPaFBMfKbrhNMoLcGfpD3uRgfKNPjcDt3UaMrgzm6opI0ydjDnMNkPvrhtzntd9+gU06DwTyxcrcaY6Bof8BWmq+v9RlHEKPHX+ENvNe5NVTIkzLnErvwlnwWmegMQFwEHTSZ+a76kgzvIIjX5v6p8CSQalOz3vDVKwYRcX+14ovRLiyHaeczm9Dt2MI2gl/1h6DfpqQShZmUM2AVbz314piqVBhhogJuG597vzIeFnLaW8FLuYG9VG0DBpue5+V2RX9qptkv0fM8TVqbA01LNdNNTqb19LJPk8/AEeqYhOR86lRGwWkjXX0NOPLhZqGGLOUUUnHoC/4uWrK8b1x+3dszJs77VhDnbu6UCRP6WYp46jmpnJLnLwwq3JtIEbGl9727Z6978UgOGItAXufXxSBTczouXpJcs5OF+1phYPyEE1coCx9dsxMdp9X8C8
 1e1DV6/9
 L2qssRpXVJ1Q6m5/DB/gp+4dz5D8U1kklKyrxmlmpPnYp2pPtHPb18J8AVKIQOvwsRo7rLqJKH3e3NL6cpGzqoZfgBwL63PHkRHVBTIzFE3ZS9cww6+YHLpOyoWcyBskNxMOMF1IlDul53VRpUt1vb2ZvtO3eJzsRUQkofqu+eSh1wOo4s22pWpkOJ4i5iGWxAXjsCixnkH+GAyJJV2Z4BC0r+aNhyzdDaG8mccnXntxl2WSbUQbMlLBDzdoyS4XT1emJOFcQR5Om8hRuwLlCXyL6yLK6VSdzEG+SzlfHkHNpXB8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/26 05:22, Anshuman Khandual wrote:
> 
> 
> On 08/04/26 5:59 PM, David Hildenbrand (Arm) wrote:
>> On 2/24/26 06:11, Anshuman Khandual wrote:
>>> Enable fixmap with 5 level page table when required. This creates table
>>> entries at the PGD level. Add a fallback stub for pgd_page_paddr() when
>>> (PGTBALE_LEVELS <= 4) which helps in intercepting any unintended usage.
>>
>> Can you add the "why" ?
> 
> Following reworded commit message should work ?
> 
> ------------------------------------------------------------------
> arm64/mm: Enable fixmap with 5 level page table
> 
> FEAT_D128 halves PTRS_PER_PXX thus shrinking the VA range coverage 
> for each page table level. Hence in order to preserve all existing
> VA range configurations, some geometry now need to become 5-level.
> 
> Since fixmap is used to build and manipulate page tables early on
> during boot the mapping must also gain that additional level which
> was not required earlier.
> 
> Enable fixmap with 5 level page table when required. This creates table
> entries at the PGD level. Add a fallback stub for pgd_page_paddr() when
> (PGTBALE_LEVELS <= 4) which helps in intercepting any unintended usage.
> -------------------------------------------------------------------

Perfect, thanks!

-- 
Cheers,

David

