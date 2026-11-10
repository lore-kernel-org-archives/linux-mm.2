Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F331E606B584
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oae+OodQ
Received: by kanga.kvack.org (Postfix)
	id 208D36B05B0; Tue, 10 Nov 2026 06:51:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0A96B05B5; Tue, 10 Nov 2026 06:51:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6566B05DB; Tue, 10 Nov 2026 06:51:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E01BA6B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:51:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F32B3120516
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:51:48 +0000 (UTC)
X-FDA: 85419045096.15.18758D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3F68340008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:51:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oae+OodQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794311507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O6X3Z9fBtxilcMGd2LjGjP2OdK0/6YVs2YfALZnX1Y4=;
	b=UiGPN1wIuZ2q9qM95FErs7TMQLJGif7v0IDpniBRVwaHeS0UvAD9MSkIRD6Xc6vHdTszsw
	O90zsYJl95/7oA/3nsc1gT2aEkvxlolWFbnQSmNwbxJfqN8WGZcCv4OTmznRzWcc/2vWnG
	z6yahu0UQ119fpnp6WLfSN9NrDNywN0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oae+OodQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794311507;
	b=5fDX/d4MKqnd0utvomZZ8dqsOHERD8jauLTvcNQg/Fv7Kk+F2E69jfJcOT7+YYUTSs0iO7
	i71h3Ld9jBct1wXyg17cnnr29rt+dpk8PhuJHUeNxAFI6rn1OkgXudlR0ni68coFuMJBPJ
	/nURN3EpiMMO+CkvnEwx2FHq+j6a4pw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AD5941490;
	Tue, 10 Nov 2026 11:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF371F0089F;
	Tue, 10 Nov 2026 11:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794311506;
	bh=O6X3Z9fBtxilcMGd2LjGjP2OdK0/6YVs2YfALZnX1Y4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oae+OodQ78mRo/uzxIlp3uK3oFdwp52ecWXJSOmm/c62ef4MUimKFBNXtSOohv7gJ
	 7cQBQu13y+Ijgpl4UpJX4dZYBQA3QxmmEUygGTvVzHunGnk4oEjGV0w8OJa9EskmKe
	 6UIWD73lnNe9RAsFl9T3k+3G0Ieajp+GtzFfa/4f6ljg9oJxqcArHpC9rDL3qnvhtm
	 6TC0eVHmZ/HvD/5ruz0+S01wKOwrpb9McGIUsVjVTkus4D4oPprh0Mc1nuri07smtB
	 2kOQULzo4VTmgO1t4AHUN6ryMYO41DUj6dqEprjJ/Fkor+qX6s9Dk5jxC5Hexp7enl
	 SEK+cjTRPm2nQ==
Message-ID: <895188b0-b79b-49c0-aba8-c04cb3292e10@kernel.org>
Date: Tue, 10 Nov 2026 12:51:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [SECURITY] mm: split file arm of unmap_folio() drops RWP PTE
 state
To: n3rd <18670333770@163.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "ziy@nvidia.com" <ziy@nvidia.com>, "ljs@kernel.org" <ljs@kernel.org>,
 "kas@kernel.org" <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 "peterx@redhat.com" <peterx@redhat.com>,
 "security@kernel.org" <security@kernel.org>
References: <3f250fc2.bbe22.1a1c5441381.Coremail.18670333770@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3f250fc2.bbe22.1a1c5441381.Coremail.18670333770@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3F68340008
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: qqnb6pb1tb6i1tghmudxy35xwxxg49e9
X-HE-Tag: 1794311507-953944
X-HE-Meta: U2FsdGVkX19P4AGq/4jUHMKP26M2rZyKXGvbqxcyxSHjf9Nge3IHVr9Kfk8WluYapnbtBPLOL1F9C2q5uROsvsF5UqzVowf8PATaJ1sfu5y7FcaZV/0x9iBG+Q9+bfzfl7GckFJcFEVkz54bFXpIlv2fNM9NOdOqOFYtTVZr/juj4os9dO6u1ifI8ZVF7GFBbZ2R7cNyktWZCCeyn4ECrU3H164sjgtfiioZ8y2Lua+wCKft2yjOVSW9eyaMuAHhurqzEVPIUbu5+vY1UGxJ641cJiqDiu2mAnpW2MGusnMtJEPc2AiEsUAuS7yj+hZislAoKPLsvS+xRkMInd1MCGzWB48GBnEjaUYI9dUu/SDBtS1L2koZ7/yngKwXW9/B8qbfwI8GI4MYSOLLhQFdtxm4+yFBP7aadEzeoovjdnK/N62V/lSh/64qPGD+sA/9TIBtRyGj4p/esVy1f8fqZOtP1goaFYFhRfOkDb8flokilLYATjZrvDf8PeVGIOwK+qm0toWrRolP5omL4hWWLHjPBKqm6eMj8MH+7w41quFeSvDi2uHeE5lPc5//YZXTTUSlUA33rhdksAvwwgntm1aVHVJG4gWC2ZijEDq5mpRHoSAz6E4x2GOPv85hO7LJBlKq9LL3RAmEOE8U9wA72eL+4HWZpJvMr8jMQsKabgFmFcW4Fc0OagJ6S5Yi1wJ6HvPTd2rg9MOLBhsjX+Zt9N9gy6PPnnxsGXmCTL0KjPw9Rxbw8tQqwMqdIoUDE+bgEUvN/H5o98WFhX1+t8Zafn6A5WZfLm6/ntefXdKe5FRM6JPVcXzc+Czgb5LTF304B3WrrRBTIytTLegYfZxTVX1tt+JbpgKC+YsTQ4z9SYxyjnGvP/9FCnUA0vF+9sC98v1s61PkuCj/4H+RlmcbFCaEPZvPH/SmspuaokD75Rl0hlr39RO/jSa+V1mh+CFtZcVtHi5hYY448+gnsgk
 dO1uB79i
 SjgZ2sS7a8z7kMtG4iOxni7C/oDSYa5rTmW/tat2HrlehX9z/JGn5bFlRLkkx2k8gxzGN0w+3hl0pShEHwm0wlkZ1BgKJazLrsE2Dj516/r/BIsX3xmDV7HhHi39yaYiJkdUtUa9/WCLBQIA5MRtnQXGfsxPq/aVRNMDGyAXXu1dmL3kFDCbZlRKZMqsYDeKVZ94c6ETFIKiSesXCxCShakalaEARprcKHvArR/OdASdWenz4z3Wi6SwI1v2cpGZZvMZpuk8jwE+wsVPuyyxTyguotXG9OnbrqEfFDQkR8VZaqu6C8/Ns5DTi82UHxdBQeYfXln4//h/w/h6PvkvcDcvOf3o573eqWpjCJsIAA7aDNgAxEh87Y1RQfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 12:42, n3rd wrote:
> 
> Hello,
> 
> I am reporting a security bug in the Linux kernel.
> 
> 1. Affected kernel versions
> Linux v7.3-rc7 (mainline, built and tested as 7.3.0-rc7) is affected and was
> reproduced on two fresh boots. v7.3-rc6 carries the same code and is affected as
> well. v7.2.9 does not have the RWP feature at all, because UFFDIO_RWPROTECT,
> UFFD_FEATURE_RWP and VM_UFFD_RWP were added in v7.3, so it is not affected.
> Triggering additionally requires CONFIG_TRANSPARENT_HUGEPAGE for the PTE mapped
> shmem big folio and CONFIG_USERFAULTFD_RWP. There is no upstream fix as of v7.3-
> rc7 and no CVE has been assigned.

Please don't indicate uffd problems where we lose a pte bit as a security
problem. It's not.

-- 
Cheers,

David

