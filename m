Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81D17FC590F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 09:08:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9C786B0088; Thu, 26 Feb 2026 04:08:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A205D6B0089; Thu, 26 Feb 2026 04:08:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 901FE6B008A; Thu, 26 Feb 2026 04:08:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 781B56B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 04:08:18 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2FBCD1B762C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:08:18 +0000 (UTC)
X-FDA: 84486031476.04.7C39237
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4C9EE4000D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:08:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fz2NDguc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772096896; a=rsa-sha256;
	cv=none;
	b=FQxeEyz25laFxXnvQVDANvXhQT46k0xrD8xGXINjYWyGDRcNCFa2lof+cdx4KI1LyQImRI
	SEAIfnxo4fVoXt94BZjRBZtTdqsl8pKUrDrR1tkeaIyRHEHdta4YQKHEoGrZygtcF+cl9P
	MNW/gOiCFrv1shFPGbH7MJxJWrZQQQY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fz2NDguc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772096896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9GxSMZHScUxIn+8E4CzIuG4hlJVrAkuR5XrUsdWo5VE=;
	b=KO6dTCzJedWJ03I2A8fhfZXV8HXwio2xPYAaZUnfPYdjVRTvwbtj13AY0NiBPjHJq3AX/v
	XuE1zHiMWG0ZcK7kFt8LlRwE7XkHcs+FjY9TONFBMdA1FvxuSMSqMG/qgPVpC/mftHHOvs
	E8DpzDUHNLMhzf8tywDSMT+gUn+kY/8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 606AB43E7B;
	Thu, 26 Feb 2026 09:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10C7C19423;
	Thu, 26 Feb 2026 09:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772096895;
	bh=y11g85XCUlJsP2pyz2TMzKQd4wTjpzRaV9t1RrP34Is=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fz2NDguc1AOocd74h8/J/h7ht36vcblPdeyl1ZjskZ7ogkSk1JEeX1JSL2GS/wXMD
	 6/3VKmcLGkdTHvpkKnUlhY73qSQgkI5UMSA6TGcPqpCL0tKrQUGPgodhruXcwy/clE
	 93idkfQEhc3SibeIbHqrEUcxXp8pfLXx8QYAq78BeGCktAGudCKsWyRE4AiL0GO8ev
	 cLqSWYlL/AjfUAzOViDYpfJSWLs1xCAE9r6rP5XeufpTYz0/WRlB8AbtvUE/7v4qDC
	 Uu0PjfRGzRPH0v0yfeKQrnUKcz22mqwEiAXAqSAiwctDwofLuelBp+jKmeKvkL1aID
	 OV9ExLj0EQ3kA==
Message-ID: <2599bc1e-1f8e-46bc-afea-4cb8f657545b@kernel.org>
Date: Thu, 26 Feb 2026 10:08:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] mm: support batched checking of the young flag for
 MGLRU
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
 <84d2426c63c1eafeaa0cfbad7c5cc11e9c11b980.1771897150.git.baolin.wang@linux.alibaba.com>
 <2e7a1e24-3616-4b79-b943-b5f7efde2d31@kernel.org>
 <0871edb9-08a2-46a0-ade6-af842a12e0d3@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0871edb9-08a2-46a0-ade6-af842a12e0d3@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aa37xj5bukqkcgrujrcmjhcm17p6jfpg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4C9EE4000D
X-HE-Tag: 1772096896-600181
X-HE-Meta: U2FsdGVkX18bq2QNB3+2valEeVh6/if9oUvwgfNmUDLF716pV0yvq54TUNwE/Z0EHocK7ioZC8KhmS4W6xfnrgZjBhr/OzdkmMZoHANxvp0jAn4jeEOewcS1/crxy5D1E9SY3TzzuH8cqXfLg8rskXQu+DEgbEaF3cGU0Ia2u3Z294ES2AEo2CaddPx4pjH1pDfnihQYv/tp9zxtQ0z2oK5emHRbE+oOaaxPiGXbo83pd14nCtHnpWQZGNiqCRBG/73eHq7E/us0Xim6Zl8j+kuN9jYVfEHzcU5z4NrQLok21sEZC404/Qee1v823kJuWy8u7cZlElKESIgtrKsZ3QFoyBSzrI0oD/swmXz1tr9lX628XoJtCA35DLJyNAIAcWCVufUWprtvuHH1UJyUW6IGbx39GkuArXNo07vCse0dtSxdu5vE68s8xZ/APIN3VB3RqbnUwN/IAZi0hXBQAnm3Q362a1smxXzsy4Z8LRv5Wu2MeX9/ql8m9kHRlQ7arq1LOfRQVFK7BZ1ASOSVUZP8CRZ953q/pUM25HejjNGN/lBHhMXTLhGrkHtLeWrvISG9DV79HLdEr77FK9CIM82P/1p7FyxQNsVjkpAjL57RY20YjvD9TH3ZzDSAcVpbdbCy2C8Ku3PEu92OpRRaq9AL53G1YNPP7GtFpHE5IrrulL2WzSMPZgvrolv4rZWBM48k1K4DcyrM0bjPldrd2kx642mhJmHLjrlSRFiA0MySPg0bXvsBgtXU8f3w0n4Y1licdqbsUCJdG+UHiu8NUCavcimC7pjfUmIZZhCWFsbADTBqRgdyR0Mwt5yuFNf56MgyZ1IMNaYapjJ6aN0nM8bc+SjKt8M0O69+YUHDjynOEggJG6UpdOL34ACUj7yKwyKYeLEBSeQptPhEkA//SEgHVGgLi7SFDm/fZhSPsBHTgwjYzdPMFa9d+8/cywBaB5qeOSCTHG7+ElQriSH
 cIeeDres
 44rgtgggHPGv0bcZE8JnJYQcasRmO3VOBF3m3iXmSOGKDoQFrlvUz/Dph0x+fsif7y/Ai4QzIt9+zuqst8AS/bu56OMUCfw2YpnfntgOhILAS+K1VCrSFOJJKDf/PliX41ChX78L2/ImI/4YTilgN/nPp61W/AUNxMnJ02b8YholKxAULsmJJVe3xp4ZBm78r+c1WU0H+frltFrHMNWV/8lHP8ASZBoV/4ooUnH6cs77oaVi87T740pYStgGXF9yFdWjYPt6kqqiKM3fqh7pMC+zWl+EcnZS6oz28
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>>> +            pte_t pteval = ptep_get(pvmw.pte);
>>
>> I wonder if there could be a way to avoid this ptep_get() by letting
>> page_vma_mapped_walk() just provide the last value it used (in
>> check_pte() I guess). Something for another patch.
> 
> Well, we’d need to add a new field to ‘struct page_vma_mapped_walk’ to
> store the last value (e.g., pvmw.pteval),

Yes.

> but this makes me wonder if it
> is worth adding a new field just to avoid a lightweight read (which
> should have no obvious performance impact).

You recall that ptep_get() on arm64 is not that lightweight due to
con-pte? :)

But yeah, something for another day.

[...]

>>
>> What is "batched"? Did you mean "nr_ptes" ? Or just the initial value
>> for "nr" ?
> 
> There is already an 'nr' variable in this function. "nr_ptes" sounds
> good to me, and will use it.

You can just use "nr" here and reuse it for the existing variable?

Both have the same semantics (nr of ptes / pages), so having a single
value might cause less confusion.

-- 
Cheers,

David

