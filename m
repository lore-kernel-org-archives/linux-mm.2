Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39A26C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24DBE6B0095; Mon,  3 Aug 2026 09:07:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D77B6B0099; Mon,  3 Aug 2026 09:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CDD76B00A4; Mon,  3 Aug 2026 09:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE84E6B0095
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:07:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E8E012064D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:32:34 +0000 (UTC)
X-FDA: 85059443028.21.1DC2460
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id CA74C4000B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:32:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BcKJhhXR;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785749552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tV++lx5wKqCLqTJkSKjN0rIr4B0HTe85fHGLY9zxVMQ=;
	b=0nor4WZn4F6j8Zbi1xY0ZcoSgtTtvps82Oi1CI0Et5YuxMxcBPVIpefYX3F3UoFetbLZ37
	UGOzES7uD01S3fawI/512/K7rW8+8D3cQntXRmJHelSJ3vtk5Cl1CJEN/vppxy93NTlhCI
	1ecacTTAylS/SjNhQwwmcaKZkN594D8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785749552;
	b=LC721aL5BhAZ7TQXlFVLgDNhTSuGeDoQi7hnHb0DEYvEsckuCRVwgJJEWea5x/1hSe4eHK
	ki77scKQkPfsTGtjAmYHG4KlYkD6GcMFDO7pgamspT78SPKCiGuI6AASK6eW/HunYgHIOf
	KTCmI+rnnboryeBKkPJ56s7Opk/6WZs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BcKJhhXR;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 99FB24389B;
	Mon,  3 Aug 2026 09:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834281F000E9;
	Mon,  3 Aug 2026 09:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785749551;
	bh=tV++lx5wKqCLqTJkSKjN0rIr4B0HTe85fHGLY9zxVMQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BcKJhhXRkiRbXC2AN5t9Z7i08hpKfJ5oidgPQpSKJtvyeNJ72f8EcgJaFO1j8zNwX
	 Txx0uWuhckidz+69oyvI+5Q4gIn0MUcuD25eCNFxJhTsPySR5o9z85BubiJujY3Bbp
	 MSHK8dvgri/+2FCewZK56HAI4qA5VW8EwByNSIid/uLwC6EbWRrtygckVww8FGyD0d
	 0cuKb4B68lXnGkLMledMj0J3Zd3IlFsBHjueGWxjg4iUH0um8JYjRyEAaHpGxlF0pS
	 MlABDvPHsMP00IH4vr2PojwL3Y14mA+tM9F4NQQjb0hun6IRsY9hkNnuY8VP+Gzvnr
	 aeKgffwvHzjgA==
Message-ID: <9a820779-606b-4a67-affc-5fdb85a00289@kernel.org>
Date: Mon, 3 Aug 2026 11:32:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 23/26] mm: Split out NR_FREE_PAGES_BLOCKS_[UN]MAPPED
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
 Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>,
 Sean Christopherson <seanjc@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-23-6f5729aa9832@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260726-page_alloc-unmapped-v3-23-6f5729aa9832@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b8y8qqj9y7x1od5uc1c3pokorzafpiyy
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CA74C4000B
X-HE-Tag: 1785749552-157762
X-HE-Meta: U2FsdGVkX18NYOjVP6GMgh8tG9BL7KwELZAMqmR+hmRJpS1rv8X028vapG+hm4LHpha4fUTn8/HDFXPu0aPvVxc+vcOV2gzvkCaLxmFk5dQ5PZug3OaGt4i1ben+AWstU2SLhaQMcrSz3FLOPJFC/Igjy5fMbBJ7YnkDRyJWNBCafdWHjML8TitR2uw3K8EK0I9JHiRZa2fltudxOMBfVYlgm2lxXQHC6hzFX7uW2Z3nUQuwHYeHibBR857dLWLxehdy/bDls+Os/BqO5mc26JGAgO/z+4BiL6QlQf7FfaoCKXRbAu/U5MiUq1HftFWHayMJtEq4RbKJySgzDuJVgTEwJ1aWFHvan/eCj88+JNO1pZ/uyF+KKo+Z0xHColpcfr1LWpPuGxhgsm5RMqVO2Usi3IRyztxt3PHscveIUVj6Q243FkXb5pbEJcZ2eSCJ5KsDiLYn8G4kl+m2YVtySTpuyqdwC33CJfBKaNPjBVNmvxC4ljfQIWASGfivMi6wzxhsLUhFMBjwCv/HwtxC6edME/TFoIMY6Nia6Y4cd2gZ8cKCF5J6QAMCnxoh3CfOhSX2ONafVqp0d9zQDg3fEPgJa0yFjf3cAq4w1RiD8h7ifF0XAslUQAiFCAXHvz0KDhyUHJabRwbqyysxsLZ2IUwKlrXA5Pm64nGPB8FmQLQomMjzrT5PVKgaD4lJLJAXfyYJTWc89htkygHRScYoXphSmTeIQKIA+eDG2rEqP3LkJoqfWbmmgv2uIfKLtyCqFwCKoI90jHVWeYM/F+ay3G9HwQmk7BmCUqwAglMdZ5Fqnod/DVirDE7y6wpg0N7ZQ2pXaUi/N62OvQdnkaA4D/EmX6WaUv4BYh7jPEYthgT0mecWfR6ydtR2vpyVUl7MZt7/x+wAM5ryvZ/fN4AUUOPNRRcOWberwjyFjwwE2I5JHpBolGvo4nHJxVgPsrRJaGDc9v9laL5gEVbFXci
 jnHwu9L6
 uEAZfHXLGBe+JKfs5nY8rbwefAQ/bNaT/e4LJzFQeeRZOKPFTk8tdTZ/Vz1aANQAGUxL5Fcrk3/hN+5rAsFWsD7x0VcKMKUnyBsGDuGhbVxtGPg4Nm6X7wWxFoO6hjxJxd1DWwodz1ASXAUn3ZotDFsOJ6AGbTnTOuNTJhRyDzfIx9KOHWfhoAs7qrUhHCHLn46sttGJl6iCvqU5ifYjFrHDW02gYj4wuFEvTDKilsqQYSHj+FpLi21kaYzYGlHXGqC6skTLaLnQxphZCKhJuvwsyt/blQG/y9vEGHmYw7jSkdYZb7XnPCulR9+E3e277QOwDdBmwnrYfpnEdfUF0SNg6ikcbN8s6OOrQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 00:22, Brendan Jackman wrote:
> In order to infer whether compaction is likely to enable an allocation
> that maps/unmaps a pageblock, we need to know how many fully-free
> pageblocks of each type there are.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


