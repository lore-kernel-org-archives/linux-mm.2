Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CA66FED3E6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015B86B0005; Fri, 24 Apr 2026 14:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08C16B008A; Fri, 24 Apr 2026 14:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7A86B008C; Fri, 24 Apr 2026 14:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB27E6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:27:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78EB6160280
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:27:00 +0000 (UTC)
X-FDA: 84694281000.16.37DADE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9DB891C0013
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:26:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u+/3vppJ";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777055218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+jS3NSZ/pWuHI9hX1IWYMyRsaWF/3cxfOua17HST4o=;
	b=WrZQvVhAF4tyW/QaZn9EZdNKZRADfrUJfxHAnGcviexdx+MKjmOc5hhIFjZ3Dk4OjYI6gg
	cdIR1Pm3qFCRmKpxXB4jci3b1dpMWhojNBEzUEJKNeJKKTof7lTHlO1HB8QNQYEVwiFiIJ
	zNuxRmUQaRMBTzzNI+CYNQ6kOsJ2BMI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u+/3vppJ";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777055218; a=rsa-sha256;
	cv=none;
	b=nA155Z4FqBVdUJ/TgcFg4sEM3lwCSB2RkmQvDcL3Ke+Jxx/N7blVfnCwqXYRqEtw0xbiba
	IYaB/rnl/7Wt5UXaitIlniQw+06C8LLt9UrE9FNhmAbr878c3/ZW4BQSdk4XQuEdekZcBd
	UpCSR+LuseX0gGNceKsohf4swObEpe4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ACD18438AD;
	Fri, 24 Apr 2026 18:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE05C19425;
	Fri, 24 Apr 2026 18:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777055217;
	bh=jE+zr5OC/t8vyDfTHUxqFb6gZ02duNQ6SztJCyxGuqE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=u+/3vppJBKOOpM3X1nw7OU1ci2VL3WwTteFLA23ZxyYPekT8sRH+NkSv9MryHCfw4
	 ByyOzoUTfzuyMEq/N4IgIhqN4WwV1+MnscD2fDaeHpW4WJ0ogBhoE1jWFzymx3Puf4
	 1rYxvxeXeOquKGwELqQ7LltCH/S5/mb5bogRPhMUmN96sLIjY7OgKyhUK/2zKbdJwB
	 7k5V7SoTeMWJpZTuTKG7gXD9PiZnMH7VOi2O4Cwbc8TdX+SnK+7XsIFe1yE9W9O8M+
	 JhrG9BNe+RbqZQeYPpuGmN5a9kscoHzq/1/9EA062MO0XLZDAiWAJcsgmVHQGIjBUw
	 XW7ksSG+PnkYQ==
Message-ID: <1dea839c-8a26-4fb4-b432-a866e31572ba@kernel.org>
Date: Fri, 24 Apr 2026 20:26:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 4/7] mm: add page consistency checker implementation
To: Sasha Levin <sashal@kernel.org>
Cc: akpm@linux-foundation.org, corbet@lwn.net, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, skhan@linuxfoundation.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sasha Levin <sashal@nvidia.com>, Sanif Veeras <sveeras@nvidia.com>,
 "Claude:claude-opus-4-7" <noreply@anthropic.com>
References: <20260424140056.2094777-1-sashal@kernel.org>
 <20260424140056.2094777-5-sashal@kernel.org>
 <4b961a07-b72d-4c8a-ab49-23f61ed12b53@kernel.org> <aeuC6TJ4XowazVZj@laps>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aeuC6TJ4XowazVZj@laps>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9DB891C0013
X-Stat-Signature: mzn7ob3j87dkus7tksgese1jxx1tjdk1
X-HE-Tag: 1777055218-250068
X-HE-Meta: U2FsdGVkX1/rlrLFXmuF8op49H2Dcs+MCs3ul9tydNCwEOp/wNCVuIK6uqPm3IUCcQ9X78VjkEKGI52HA9pnUDGQq+iZumzfblRA8U+8vbP6MkxQ6+S4SWGc3bMWSPqpca4Vw2yoV9vSor2Pmug2e0ch+KxB9KFqLsbrqDPxbqdcD1xe6SJhlDj7zkER5uv9xBbErgVy3tQpDVKa2LBsrbJijlILTGjSv/GJAv+D/+Cmregf8fkBD8Ftk6P9Hw3/Tb8f6YiHD1hAAfJaefpnNtAgcUBfGMR84/qurqr73PTPgOIwQ2Rv3WFdJV5n9eA59PJbs0rY0YYY49MXYjNt8oQm+iwZP2r9O+cF6lf9bSjrau0BuALhmTsJvcalLfHlFUdaOVvJEndfNgfZ4HE+7V7N6vM7YxofSNObD080KIQLfSRt8mvQpH65onXW48fEPoUMlLIhd5iL+2MWM7fYGNr7vQahYxFb4IAbJZt5UqastM5jxQC//OG46nvfZR+3m4VHKOyThLGIXf18U9NcQ0tJ8hwXnGxwAFdBzwJN95ATJSos/hhgogHFNhJZnVUoPOTC6/rHwfSXtIdx7aRJWd0vHdEKThL2A8YsAfE7Lr4gwqBe+6XOeaxOpH5Qf9sIeu1/bY9WiyITAPyL2zawqJgIajB9b+L8PgiSolu/ieVNXcaTpU0uC1YcQdlrl/ZoxzEqJ5l+U3/zhR+80SFziPPoQoqN4np3s8rpbi03solUHRLpwMBVY/8zW1xlEqNOqoJuPvJeytHSKBJmo/TmvgyF2ZQC/SxAKWUMgtmS4s/KZlIdpnQATmIqaa4tJk9/1HANMVg6eDVPcfbqlmpNjsF5qTBeMXos5j/6glbekBSS1f74puAGnMQkk95Cn8H5NL0cak2tBB/gJI47DzGDjCQN3FF1OgN7yv38xCwtSNo41C6LnAcUimVMPCZG9BpGsiBrsglWqfT+6JA/crV
 zQsweGGJ
 6kEMaZVowPqkCLLnIGC7b1kgUUgvwTLbvl58hIl+Ntse7q8iR2tE0cvxllTArY8k+GZ5X3BUxLpcW1Be1aApFNZpWpP4yK/HSfl1mBgijVzCbzig8MMrW8oUyNk+5XtxceQipR+Cqgx8jKVYsnBMsE/KsXiqnW5HWyUG66UawTvblnEiX3GMxVMU3WDuXa4GJ8y6u1SUqRL9tm0akah1yBsJBwiacwYrhJVs9Y8heMppobMKSyxUoRssBpz56qvir7v2Q3uDi9E85MwHrzRYmmYtbeuGUt+9RjuVm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 16:49, Sasha Levin wrote:
> On Fri, Apr 24, 2026 at 04:25:41PM +0200, David Hildenbrand (Arm) wrote:
>>> +    /*
>>> +     * Size bitmaps to cover the full PFN range including any holes.
>>> +     * Holes waste a few bits but a flat bitmap keeps the indexing
>>> +     * trivial (pfn - min_pfn) and avoids additional data structures
>>> +     * that would themselves be subject to corruption.  This matches
>>> +     * the approach used by pageblock_flags.
>>> +     */
>>> +    pc_state.min_pfn = PHYS_PFN(memblock_start_of_DRAM());
>>> +    pc_state.max_pfn = PHYS_PFN(memblock_end_of_DRAM());
>>> +    spanned_pfns = pc_state.max_pfn - pc_state.min_pfn;
>>> +    if (!spanned_pfns || spanned_pfns > UINT_MAX) {
>>> +        pr_err("PFN span %lu cannot be represented by bitmap APIs, feature
>>> disabled\n",
>>> +               spanned_pfns);
>>> +        return;
>>> +    }
>>> +
>>> +    pc_state.db.nbits = spanned_pfns;
>>> +
>>> +    bitmap_bytes = BITS_TO_LONGS(pc_state.db.nbits) * sizeof(unsigned long);
>>> +
>>> +    pr_info("Initializing: PFN range [%lu-%lu), %u bits (%zu KB per bitmap)\n",
>>> +        pc_state.min_pfn, pc_state.max_pfn, pc_state.db.nbits,
>>> +        bitmap_bytes / 1024);
>>> +
>>> +    /* Allocate primary bitmap (zeroed by memblock_alloc) */
>>> +    pc_state.db.bitmap[DUAL_BITMAP_PRIMARY] =
>>> +        memblock_alloc(bitmap_bytes, SMP_CACHE_BYTES);
>>> +    if (!pc_state.db.bitmap[DUAL_BITMAP_PRIMARY]) {
>>> +        pr_err("Failed to allocate primary bitmap, feature disabled\n");
>>> +        return;
>>> +    }
>>>
>>
>> One bitmap that covers all sparse memory available at boot.
>>
>> Conclusion: Just horrible.
> 
> Depends on who's looking at the code :)

Or who generated that code ;)

-- 
Cheers,

David

