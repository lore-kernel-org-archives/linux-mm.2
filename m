Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90BB4606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 22:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J3ReQyyP
Received: by kanga.kvack.org (Postfix)
	id AFB076B05B5; Tue, 17 Nov 2026 17:22:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAB1A6B05B9; Tue, 17 Nov 2026 17:22:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DE76B05BA; Tue, 17 Nov 2026 17:22:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68E1E6B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:22:20 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EBC63C05C2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:22:19 +0000 (UTC)
X-FDA: 85446035598.28.1E6F488
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1E84FA0003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:22:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J3ReQyyP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794954138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8SI6dF9aj8I6Xyc7aHfvZCamGlGBl6LeyZ0P5TJyoUY=;
	b=qd62IUWFVjyALNBh5zVsT4VC25E4laEAYVBG6LevLQYT188/0gEmr7oHsIGm3pwW79bpXQ
	yucvhJfZK9f+ciXki+7jnZCNGnZ1AxSm088b764WSpMV+ij70+b2Vtrq8cZlhIts8ICZeH
	m7gxHHcI6av6U/0zJSy2hlDqDFyJbwA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794954138;
	b=PYfPgEJY7LfC7jTjSCtjwvk02NnyeAWitzq/3h6YNOlY6LxaLiR72rUndhMMxsyx2HGpUa
	5e5irkN6ZLSJUXeTWd6o2B8epuN8KnkTY2ywswyMABDhUGYeJujMOQzPf8lHqR6DJKqu/y
	FQ5kWXq2hG0Oghf02ZXqn2+8Ap7Uzgs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J3ReQyyP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 442BD40983;
	Tue, 17 Nov 2026 22:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE191F000C4;
	Tue, 17 Nov 2026 22:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794954137;
	bh=8SI6dF9aj8I6Xyc7aHfvZCamGlGBl6LeyZ0P5TJyoUY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=J3ReQyyPp7G9Cs9e9cfYHA0dJGPwnvzW0W8cbokRo1dkQHaIGqu5lK7RaC0UbzEW4
	 AQhOENqON8AlS1271xUYilhf9CAt/UlTTBWZ/tTX3uiMY+E8tEbJ1ZSNm7UUzMIckb
	 qiVv/1jYcxtnG/mKbfP4dCM6weW9nmnY/rfLF08L3GmJt84ELc7dP/j/y0U7jiHDLO
	 3RO1P7DbpScYxyx/C127WT+zPfynXy0zwdYnWiKeeVWC+WgjK4mHzL8+qPbKRWCIEi
	 6REH30LRULbcXyY4JS5YGD3W08KShZTWgUmx79M152EzSDW9WNb7ApreQir3fQArk6
	 B1CwBKLe3oshA==
Message-ID: <e2831d86-2fda-44ca-8ee3-b3b29877f78c@kernel.org>
Date: Tue, 17 Nov 2026 23:22:08 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] mm/huge_memory: add a per-order counter for
 underused splits
To: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: baohua@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org,
 kas@kernel.org, alex@ghiti.fr, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 willy@infradead.org, linux-mm@kvack.org
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-4-joannelkoong@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261103212004.1356327-4-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1E84FA0003
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: uq74md7xp1c3ybgn578wsg6yyumcaa1t
X-Rspam-User: 
X-HE-Tag: 1794954137-127860
X-HE-Meta: U2FsdGVkX1+7WEiduSYXoZRhTl6OYizGja31aaTkSolWCV/dXvRjsvKwMsERgOVUioYEe2xYIbKTC0rnMXdfbia4QD2cw9eT9B9Tf+rQc0Fbngyj6eBK6UZ25eoZRVqA2nbHE+tK7BK4yvcrPeMn/5z/LlxyAMW3Rd0lh7DPT9TFC0cPX+RtsFf5Ud6IYxOpm7k5WcXQGiRbMEfb/sBcRVfGMno15QFsKRDbk3qDDz9HfH1LvIzLVHM68vJZUNgrWVHEPq5/cejvq6S4wFLc30UTfEmA3OYtD5RzcaAIrYSs71Adwg8vWWkT53WnHffzXDwYoGmUk5QcXIgvZZSo6Lk9HFGA/jSraXnAQ2cHvNoiuDeZB89gQeGAgObf6sSEQNwV0dRN4C+OVwhOHZusRUCXFlYiUzr2HEdlQ2KDNZWtQLn/eOq6wUQszenuinf2m2Y4MPluc4XixOFTzCdHLPOGtuqtR66APsGFNqB9QwB6nxh3XuLS9FDETHp7l/h25etCjdvxCWLFLFOTVMf6+vwWbhnqD7aXIZhj7/885bfWDBOQlfWIA/ykl1Fu959AJXRrX6JBGZMdBhanCf8DR9H2DyoCzWJDd/TmNJ44CZNmcwJcXwOWZH6FJc99MmQT4h67PVcCd4Xs0lb9z7q3VoDFdKUl8LT3lzlYt78KSuDeQH8Jf3EC71bpndyRHWwYGGk9SeIUaPXZpeQ2pLNfN39l/kSDJG4n+Lr6/OOeOr2jcynM9cJoZ8Sv3dz5XDzaGF29BF2exkSz3OmKKLM+aJDBmcoa/VsJFSFhjkdLrIO4o1l1C9nMgx9TGzkbpAHNivEBRaTw47tNlnK5VPT4RCRuQcY+Wo6sZJGstG97pLQ8rpewSmSvO+LtoONFSWIKmPF2aqjvq7jnOtydFj0DTGPRXJAQ+VTB/Dxwvc9CCOYTnvoP0ArSmb2LPGHi6IR3n2zMZ4OiuqtDHD+Ifpe
 CMWvWMNG
 QPoSxkRvCLdczvg08LOmHPLk9LvGQwPhxM1Vi+PV4cIhGY01YUXwrTuPS60gnemdYbpSwktcjzNfVpe4vQ1TTf7Soiod2A/CGzeGAoeojxVw06bTrkVbySMP9HuOPMj/DoPw17gr7TjReP/0IErmNEdVRAIIFCnc/uqSLCc3UyA6ucGuSdpiMmmjcBHkqjqMoPMR00+W1aPIgAdITNtAd8G4o5qhs+pnvoMFHDnVuihi5ieJMiurkFovDDG5Wz6NxS3O+MK/jwlDUz3IOG6AdX8K/Wn3qWUo4ev1C8rtFYRwX94OMFRwdk4wB7XWgkenRn7COL5xW5ZzWHU4xzDGi+HWxSvaZrohqr17d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 22:20, Joanne Koong wrote:
> thp_underused_split_page counts every folio that the deferred split
> shrinker splits for being underused. Today that is only ever a
> PMD-sized folio, but a later patch queues anonymous mTHP folios for
> underused splitting too, at which point this counter would start
> counting mTHP splits as well.
> 
> thp_underused_split_page could then end up larger than thp_split_page,
> and there would be no per-order count of underused splits. That doesn't
> match how the other THP split stats work. In /proc/vmstat,
> thp_split_page and thp_deferred_split_page only count PMD-sized folios.
> Splits of every size, PMD included, are counted per order in the split
> and split_deferred stats under hugepages-<size>/stats/.
> 
> Do the same for underused splits. Only count PMD-sized folios in
> thp_underused_split_page, and add a per-order split_underused stat that
> counts underused splits of every size. The folio's order has to be read
> before splitting it, since the folio is no longer large once the split
> succeeds.
> 
> There is no functional change to thp_underused_split_page yet, as only
> PMD-sized folios are split for being underused today.
> 
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

