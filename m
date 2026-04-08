Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC9C1073C9E
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 12:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96E936B008A; Wed,  8 Apr 2026 08:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8D96B008C; Wed,  8 Apr 2026 08:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E88A6B0093; Wed,  8 Apr 2026 08:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 694346B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:19:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B5851A0AFC
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:19:35 +0000 (UTC)
X-FDA: 84635294310.12.7274072
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 38C4F80004
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:19:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="T/m0vfx4";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775650773; a=rsa-sha256;
	cv=none;
	b=N426vTl/Mto12rPtFjkoIoicWlUtG8ke2hAcnPFVYGUN+il8iClfmPj0aiDgxePGsMlJqh
	PkU2RQRXpDWRlnObUI1uV6P9E7x+0PMZoHGKIMuvZXO+UzThd7U6G2cUT6A/eHXBtosQPd
	9p9/SxJrdnS7GOIGFG6cx1goJNlGmPU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775650773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EyEQQNPw5KopS1pke3ugKyefjmvWpVuZWomSyGxbnAE=;
	b=H4e6hNZXtEUzQuCttUmsWZIjoD+cagCaMJvECitgjHuULgx9AbEq+s7W/cQ+FeWthkJ3qx
	WqKgu0hYe/7jr+3BtS5F/0EOmTuO9I3nErEPPHsvi+V9agpIQM9Bf5JdN9x5bZVJgrZ95h
	POh9ZpPDzxGMMr171IBbH5WiVnFUEaw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="T/m0vfx4";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D11D40A6D;
	Wed,  8 Apr 2026 12:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14B9C19421;
	Wed,  8 Apr 2026 12:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775650772;
	bh=9E8xnEI0gSHBrirZhRjM/X0Iif7I5GIwKL1ibI0pHto=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T/m0vfx4j03cEdRgSiCPTCXACm9in5tB/LrYLOeu46YRTtExnZKzu9pmanF0eojcS
	 E8Bqe3zDxmL6qJarrLRsGEinRpcRvx03oQRxfTdyVX529jOZpjJLFMiAyvHNzvV2ff
	 /Ox3N3uZM7Tt2POIk9xCSOqj9FKDTJooaBAOQhBi9nG+8gPE31eauX+wYc1sWXS2d9
	 FjjGqOl0C77qWokoLdTkpzpphe8kOIb667oaL5pqM1dTjualr2mRuDnx3VOtkkyKn7
	 74shInP9QjFeS/zZy3KUK37rSLril15ORHMMCzXv/0IMZK4dxEm6+2PPELHNBX5Bnm
	 bZyYci9CNfQ8A==
Message-ID: <e294a87b-392b-4b12-bd12-70c66c793fcd@kernel.org>
Date: Wed, 8 Apr 2026 14:19:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 08/16] arm64/mm: Convert READ_ONCE() as pgdp_get() while
 accessing PGD
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-9-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260224051153.3150613-9-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 38C4F80004
X-Stat-Signature: atwffidyiqrbhouxicfyy35gojqw3aaz
X-HE-Tag: 1775650773-522516
X-HE-Meta: U2FsdGVkX19ZQc+qeZKJnYocJEJW3pru+i6hlKjwDnnXwgOzYp8oJuSsfotIuhohOeYaouULMeosJQtq72H3rfDRTeonMtDsliiZD1kPHUPO8Qs0r50QFQDvx4PGFXjtwVfEKUp3CKqjonmYz6KEzi1SCVDjzh83hRpHWjWiy288FnsV2HDcPTSYvtfdiZD12EqFAnNwnP0V9Bv7Uv2saOZ5Y32Xtq1AccJfr7VGJmxAoCnjZqTKLP5D0hokhmky5N+ay+9Uncd16BeGZOpK0/3yAVSwSEUiLmy6j/V6ug5X+Dk/qNy1yVw/xJ8AbWJz97s740ggU3J3C0ki8xQmJj8SOUkEZqkbnjwVbhQe6BwAdnjSxb7S+THPZSR7edDXxOHBTRrgUGnD67Fp1YuTeVZBRjQJRCnrCmjUCzmwqcdA4pkwOEiCAB2oinnArm487JfkThFDveS2Lde/XyF4OHn8WbjUrCB0tWOGR0n7OvvTAdWta8QJP2/z/uFFQflDbhJFwumuLfjfc8GyyByNbOrF0GAr8z+PbVN/+0kX5KxUjbYsxk6iB69646PpZr43xfdH21wpesIvtFTLoWxm9XU0HET4Mv3AzsaGYnFnDf2zQBGpe9GEUE/Lupz7FB6t8HUzG1IgI9EIM9UWuwlPQOPmiwGsQaNg8XJLVtPQSD8DdJ3LeJ95TN+Qg3+kLGZ1wkOF/vdJHhpxNwW0e5QS2NjIYh38nkCyb2zQ2oCZCY9auYgFNZVxmHMfPemMF7YkOHxC6IlFtABgEJZI1rS/J6ODY7lBzK3CHmme5y9nFdzqIMasYtqk+ZzP+q8apvN8R/vllakRGhiSQAde8Wh0YRsYm/7LNyHvvdnfHH4tgO4prRvsCnU9VQqLrDJVIhK35PpXBHnwjjCkRKAm/0o17KwD4S2K0oAD0kwTzOgluUCy5tAL4ZhA3zkKTU1sWJR1CpzPFXLT1wrPANz3djd
 Sa1gBS27
 UMT5pxTPMiQ5zA9ixzTZzNxov6zqcTtbCcLO3iOBK2M9gtONRX7VkEp5S+E3W8xnypLLrzLYuDYK+UNMFPRdn6GA9dwXBxb5IB6iPLlZEzbZMh5m000dz9GBY0CdifSaAcQKSYQ6Avub/PJA0FvmBwrGtkXt9KNzJOrRzRm4W2j0lxueKhD+hTvTHOIQCdehRi7u50egUmaEiaEn8wAo9DV5pG+e+IVSZORlBiXXux7THaeeJzKcSPP6o3eGMs6YuSGtkuoMMfMmTe7qOjvFlQThWk/Ew9FKlN4W0Q3oDHYyXOGsApHjdGTH4Kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 06:11, Anshuman Khandual wrote:
> Convert all READ_ONCE() based PGD accesses as pgdp_get() instead which will
> support both D64 and D128 translation regime going forward.

Please mention here why you move p4d_offset_phys/p4d_offset. (same
applies to other patches)

Do we get additional function calls that might degrade some page table
walkers?

Same comment regarding BUG_ON.

-- 
Cheers,

David

