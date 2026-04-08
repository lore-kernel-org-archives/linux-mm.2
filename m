Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 038B21073CA6
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 12:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FAD46B008C; Wed,  8 Apr 2026 08:29:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AB576B0092; Wed,  8 Apr 2026 08:29:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1ED6B0093; Wed,  8 Apr 2026 08:29:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CD746B008C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:29:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C64D213BF87
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:29:50 +0000 (UTC)
X-FDA: 84635320140.26.D9C1DAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E74724000A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:29:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bbzqqgYD;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775651389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8y5Ycg7R99Pg70uvWWdHQ93znkZ8DwM6ExjSWIGpvq0=;
	b=CYPpvPKqGJodjutWgQwowc0aYlgrS4QtiFZxNnA9YSN/cJxfpm/ZPygwAhXNGt69Gg/aEV
	E2paWDuzpsmxMKPi41dVraSN1902hQi/dEHy8M/jAxj03s48LeC4gm79ETB0dT6tQeWtba
	nxoq7ciYv64Z/uoRkqGALtNjpfPhJMU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bbzqqgYD;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775651389; a=rsa-sha256;
	cv=none;
	b=hLd8bqLD6TsSTx6FlD2mSM/kHSJV5TCc/YHwb889284drNDY+lqptb+RgePWXzaJktd/mR
	Kvsnyn3Q1E+VwqEpFaJr0nQIUcJDw6DhaeiZglelq6dAQ17opbtRitlWMMLsRcKsx2LqUQ
	GllPIB4BqUGaCLcxBjM6diP/2PZNO+s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD2B243E3A;
	Wed,  8 Apr 2026 12:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFA7C2BCB0;
	Wed,  8 Apr 2026 12:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775651387;
	bh=YoeeG6VmG9FMt4vLqUZu66gSA7KOlJhiS55juM69ZcM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bbzqqgYDJaQzrCs8odQyzCSqhRwcmyL1ScaEN1/EvV8yt15TkSLXSG06xagX7ROA9
	 S5GrDl+xfuQYxN8nXIEWX90ehEFAm/sxQ0UbtYVqsAIKRLpi7KFD83TjjgaAEgL+Ih
	 orRIFhBmHouoMfpe41uiaXXuBlM5McRT8VZkv0q3WDt7YHq/WGOQlnyztXBKtavsYA
	 e1uFC5yRv1oxG5qxnhsTlNU19ROFHvtR2S0t+cHwsPe3IRGjYNLoFDwpFBZOZR0jJO
	 gT/W+2kyHJrimY22ExgTLGQNtw0vs9XJsIpC81enpf4ZgdsclBKJnrxwUcnr/l2TL1
	 ZJEd/fFXzRP8Q==
Message-ID: <4382c90a-bc92-470e-9aa7-4666753479ca@kernel.org>
Date: Wed, 8 Apr 2026 14:29:44 +0200
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260224051153.3150613-15-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 56oqn3pscazfphmhzi717jsmfeq3zugc
X-Rspamd-Queue-Id: E74724000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1775651388-586043
X-HE-Meta: U2FsdGVkX18PH7wOXwC52IFFgvRPK7WJ8okmo09WZwAX3+gddx+ELjjd684zY2TYSYSlvvV8f83Qiuwb7riJ8BsgHvtLojFMKA6ChrR3mY6/npRcl7nJqcEejj/wdz4DcBWQfD9VV97RW1VdO8JbuSF0OTQtOb+A0J22qfOTXVYgad3e/DNww/lWJeAZlAG2phO1Ldi/T8NXsqoycbovX3SNLbRmJciP2moSXRwX+dT3sn3/xW0yiCNtEj5PsikOkht98Ve2hkG1lJZkP1cIWZObSY1vRhhZT5UZT45Yhfiy2DTx11ns0+2udPV0k/rpOMsK2Tu4Uc5bhDCg4BWi0S4vC4hjnaxh7eFJ79jkv+pU/q1mfO4hsW+hYQnxzdubLZ01yQHFnHT/9BLO1AShAZS7DgIWX47Y+okvsKH4KZPJp7hQ8tdu0gh6XZ2iISH+ylEPx0lHvuL3R1UVNONHm72OqYrLcUZai0Rp6o+wZ2oYAvOYrVAmAS45Xb5L1tcN0uPpwmkYQ32IW8b4OlWEKCTRQmaalFXi1X6SQfcPtdpETOglN9UB6PdxN8pOuSbFvSM2dzDv5WjIYZwmvO1R4qume4AGmtK+t7Gfoiump1PjzqxxCGgydrSU1yrj/fItkdBdVv5Icat2SeebiY1Qp1WxgKU5BPoPOVeeSFNTEuDYTYN/PHgCIs/HzE+QRMWSk4i15OLc3SnYbMgq3HZN8RSGFlzmdyy86uH23ia63/w44H3i9mAQzUypksqyRvv1CX0OqnvPQ/yGztIqyumViuqxNAevLP+sNzCprgvqX6HLXIumdTjVETJK87i2FzTwD2WcUBVMU0YBEnZHW4NOAIB4q0ye4mLfH7NvCSiKEMAacfVxPcHJkdf4XqfHiS6f+XpxmQyV42USKaiURqoRZ39dSJg+lobv63e3MiitzZrBcfyDiOloYy3+wyKi2zjetmOyDugouwqivNNAWdA
 2WefULL1
 u06/so5upYasLnx4y6WgMEDJS61xBB2JkHEdMqR9KeYZ+7dZkIbZMGi5b4WDeHyizMdsKqkos4Pe0ZLmTXI3JozH1+hfzY6OlTPnD8sq6DAm+U8510tlgyOS7Qv+T3pW5oe2ZxBZAy6mx3338nXpJNHfptVz/4GvRRyVHn5vbxWFHLxQZpVsiX3ChvSWSM2Bs7VMlhzHDbNuzBCQfaCoQTgU5b+9C6vw8JcBV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 06:11, Anshuman Khandual wrote:
> Enable fixmap with 5 level page table when required. This creates table
> entries at the PGD level. Add a fallback stub for pgd_page_paddr() when
> (PGTBALE_LEVELS <= 4) which helps in intercepting any unintended usage.

Can you add the "why" ?


-- 
Cheers,

David

