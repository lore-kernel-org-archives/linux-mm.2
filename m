Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ED42FED3D9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365F66B0005; Fri, 24 Apr 2026 10:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33CF56B008C; Fri, 24 Apr 2026 10:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27A146B0092; Fri, 24 Apr 2026 10:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15E986B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:49:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B28F0120199
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:49:17 +0000 (UTC)
X-FDA: 84693732354.22.1A3DC0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id EB4AD2000A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:49:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qzc4YfJ9;
	spf=pass (imf13.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777042156; a=rsa-sha256;
	cv=none;
	b=kfRTrTFsdenl7OKh7pFCqP9Wiy9yjtZTYvNS/bGunJD3czTk+070y9E54H9cFzQtHw8d5n
	BL/XNlwgRO9JhgGoNWsKUcLz5wliJcqatXBtgkbYKd1JX5vFojBXwW4kpPdE+Lcpwgo+Xu
	cwx0IkATZcXZBQ/d9zNPLe0sO/Lx610=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qzc4YfJ9;
	spf=pass (imf13.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777042156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rpKdzbmDT+OX09upoMMUPlLuHHtsWIlW7/dl2Ms2+K8=;
	b=q4AfX0DKiSFpcSdK+zbZzhIswAmDuvSb65E7mHD0aqX1tNsXzbfgrPC4aRjhMAxSAMaaD/
	vwiV9B5ofPO6CTCJQqqQYjyxjrKlgYnUytF+4W0hD9555r7KPOgEzDZBtHRZQU8JQFeBfI
	cyEZRymHHWb+9S570ciAccu4MPCXV98=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C666A436EE;
	Fri, 24 Apr 2026 14:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E77C2BCB2;
	Fri, 24 Apr 2026 14:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777042154;
	bh=N3KRDFRWCC7Nko2EDRm46i09HlpWUKUQ8/WalpyXK0c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qzc4YfJ9NTx+KD7S0Xp53xzlAPbzzkgMXPKPiC8gXSIon4KBsyhscCVPWLqAvZvwh
	 zTaZ7QYY4far8/rL5R8wnT/eUkudetpRKmWvl64J/Mb/vmCieSBVQj5zpc2Q/BTj29
	 invfCMEjPF+8KvwrlPO2Q8iG2mlyyt1ASk9cs8vPNJ8E+O2Gu+WpUSe145g6HNNMc3
	 DTJ6HJ1eaFo4Dt3wo70jjdLm28YLbU11QaljXqYQaBIYnW/m/WX/yKsYFG6ucxOSi5
	 ImV2VxvRIsMV+kbu/KzNKo/hN22ocHGj5tVABPsOGZzh45U9d6VAttOe0/RCgTw9pM
	 tRubiRxjLFWPg==
Date: Fri, 24 Apr 2026 10:49:13 -0400
From: Sasha Levin <sashal@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, corbet@lwn.net, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, skhan@linuxfoundation.org,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Sasha Levin <sashal@nvidia.com>,
	Sanif Veeras <sveeras@nvidia.com>,
	"Claude:claude-opus-4-7" <noreply@anthropic.com>
Subject: Re: [RFC 4/7] mm: add page consistency checker implementation
Message-ID: <aeuC6TJ4XowazVZj@laps>
References: <20260424140056.2094777-1-sashal@kernel.org>
 <20260424140056.2094777-5-sashal@kernel.org>
 <4b961a07-b72d-4c8a-ab49-23f61ed12b53@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4b961a07-b72d-4c8a-ab49-23f61ed12b53@kernel.org>
X-Rspamd-Queue-Id: EB4AD2000A
X-Stat-Signature: 3xggpjfwes67ojij93cszq53r3mmh5z4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1777042155-98958
X-HE-Meta: U2FsdGVkX19ul1DXWepeojvB4btxGls5RYYOfGsyr/NFMPPmEi2yoToNPrCqd3Vs66zRy+BLwwX6q+1cI1MExMJqRJSzllqqy9tf34vJCcdnzQnkfdZdmRAJ5Z0XwRa7qlKmHlLxwndT9c0yZeHPiYnrNdgAKpST71UnyoJnrBgzOzLC23zeC1szneQQexlCRYoZoJBKX/5BN80VawY0V77Hmedy2WjtwYeArTeIHqbRPbsTJIGHpzoUGUB0qEi9xf9C1U59voF11u8tqM3x5wvlBWtqTE8mpvWcX0o4ZomYZlntEz1eMixovo0Zw+up3o5Ye73ADk161wOd4iBz64302BYYRFRrWgcgFjeYo0c6XEkyRAgZwjfBV2H6XJaF2GKJXH1gWZMh2RDn8hMR/c/Tc7Im/JAkwnoF9NHgIXY+OnjPyEZa9cA/AuMFEyIjNTFEIb3npzpHqTdCWH9OQR2CddNWLns4TyiyFv9rECyovCXQsmITcPACuSXIxoL7Y4//Uv3zuPcuyTdJqWCMhUBS79i5mJqkWf46sUUjAwkqzrk9QZ0uNkgX/jl5tfY2Tc3rhyJJUCo4JPyuIWbm1L8WNgxfnOpIqMlr+zhi2LhCrsGeVMcSN3jHfiu0W19Zk+r4Q1NmraLRlyQQmQiZGG9GV4/dSPwOvFiJDL4dWNyoBKidfiaCmWhyd6AbG/WXMx4O1zlbT8roSD7A/8JzoLKQcEDqC0DaBkJLGdGMqEJ6bA+2F40sNEWoonZeqxked1vSGQ02ZWH11fc01ENeF3pDSWGl/eIxxOa1BINsmW2rlMUSe4GupCFPAqOdhSZsrs8bMCvCRvTr1tJgMx9Wf54MsCJsMVFhaWTVb3qPVI97N3mfm1iO6278DEb4najHh6twiGfJwXwVj2ttDPgCNvum2Z/416xrpJQe2XDYd/KXzirIlnENYIdKtH6NGkjtnoi6v3JvUf4KaXrm4jP
 P5+MK249
 rBWtrS2otulvf+4lsDjV3VaAO/cOZSIBgiouW0G4iIbQS1bPk8ym7BkK6snZ5VTl+CTLhTqOWJ7dHzfT62OTMAgBrxwxwjtDP35NPXOOcDN6IwbfnEnr+Dg6pO03jUOthMMCIr5m5fX7Ik5wLfCFDcdgaHBA7DxsAdKbdVwTETT6JWaMtqk1jKZLJdoPhbr7zaTCJmPSg/cdRgqAeLVEK5ftSCRztyMiJATQw5uQU+DXFEjCFFOKOQyM11FDWfgk0U9w2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 04:25:41PM +0200, David Hildenbrand (Arm) wrote:
>> +	/*
>> +	 * Size bitmaps to cover the full PFN range including any holes.
>> +	 * Holes waste a few bits but a flat bitmap keeps the indexing
>> +	 * trivial (pfn - min_pfn) and avoids additional data structures
>> +	 * that would themselves be subject to corruption.  This matches
>> +	 * the approach used by pageblock_flags.
>> +	 */
>> +	pc_state.min_pfn = PHYS_PFN(memblock_start_of_DRAM());
>> +	pc_state.max_pfn = PHYS_PFN(memblock_end_of_DRAM());
>> +	spanned_pfns = pc_state.max_pfn - pc_state.min_pfn;
>> +	if (!spanned_pfns || spanned_pfns > UINT_MAX) {
>> +		pr_err("PFN span %lu cannot be represented by bitmap APIs, feature disabled\n",
>> +		       spanned_pfns);
>> +		return;
>> +	}
>> +
>> +	pc_state.db.nbits = spanned_pfns;
>> +
>> +	bitmap_bytes = BITS_TO_LONGS(pc_state.db.nbits) * sizeof(unsigned long);
>> +
>> +	pr_info("Initializing: PFN range [%lu-%lu), %u bits (%zu KB per bitmap)\n",
>> +		pc_state.min_pfn, pc_state.max_pfn, pc_state.db.nbits,
>> +		bitmap_bytes / 1024);
>> +
>> +	/* Allocate primary bitmap (zeroed by memblock_alloc) */
>> +	pc_state.db.bitmap[DUAL_BITMAP_PRIMARY] =
>> +		memblock_alloc(bitmap_bytes, SMP_CACHE_BYTES);
>> +	if (!pc_state.db.bitmap[DUAL_BITMAP_PRIMARY]) {
>> +		pr_err("Failed to allocate primary bitmap, feature disabled\n");
>> +		return;
>> +	}
>>
>
>One bitmap that covers all sparse memory available at boot.
>
>Conclusion: Just horrible.

Depends on who's looking at the code :)

I picked it for auditability: covering the whole range with two
memblock_alloc'd arrays means the only thing on the lookup path is the bitmap
words themselves, which is what the dual-bitmap invariant already checks.

We could go with per-section bitmaps which will fix the waste but pull
mem_section[] into the trust boundary, so we'd have to start validating it too.

-- 
Thanks,
Sasha

