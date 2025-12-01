Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 352B6D116F5
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 16:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814896B0012; Mon,  1 Dec 2025 11:23:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC3F6B0027; Mon,  1 Dec 2025 11:23:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7294A6B002A; Mon,  1 Dec 2025 11:23:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62D046B0012
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 11:23:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1BA4AC027D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:23:23 +0000 (UTC)
X-FDA: 84171422286.14.22557FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6A603A001D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:23:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="G/UhbdjW";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764606201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5FsYgFk9Of/KaHaE3G7n35bOsZK1dunOkMncY90kpyw=;
	b=lGBuTvd5k9IEZEwlulOpruV0s1q9e8H4+GVTNC4i3MfliRe36eJUy+ry6xubhMRWMiHL+a
	vCNZjwktFAMV/AhdJjK9Lz7d3oIOr+qEVcuuYoUNSmGEJxKoO3+CP0UKMk0SU9uJ9VqnLq
	3pYI9rMe/VZY0z3Xt4qaGq8UKn8CEk4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="G/UhbdjW";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764606201; a=rsa-sha256;
	cv=none;
	b=FP4y27Tf9ryD4X2n6snNDiw7Ql57MHxsaAjlDc561J+qjkbwcOg3UVwYUUjSKT/mGyRolw
	CqmBRi77oEtbG37u94Q5gPKH+uNOY9FAK6diMrhtnP/UhowYEkzoJu9CnZzEa0lZXahv1p
	9K0K2gwnE9iXV0Q/yDzzvKwrHnk/voE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D7B8D60147;
	Mon,  1 Dec 2025 16:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA41C116C6;
	Mon,  1 Dec 2025 16:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764606200;
	bh=jI2Xz4swv6NzW7KPu/IKp1XhNPCIaDL+QjuUHyw6uMU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=G/UhbdjW1d6DsPOsCmlw/Bj6lJAQvrgkme7H+SyraTkDoDtpuBjPOsXxArXqlssHg
	 0v2N6siQfR2ubsRPSVCPKwAo7iW0u8+OdDzyuKvy1gHZOi5jtOE4GlV5ivPNGcuCkl
	 EQDv9/ZLuxLihV+nFOgNdccm9PFjsmgbMV7QZ8TqfnA08c+fu36yE0lyfNZXMMFnHJ
	 BkQZJR+2JUkl/r9a7VhDDrtf5uNmCZwkoZkFYPpMWRozZ1h4JBD9BPE4KlBo7vWRXa
	 4l19T5HvXfe/uwJlvzonEI8gj85nfj/ZZ+YxIPMRxLcy4ui/Sv73sTE6Qncbu15OlU
	 haES3TV6LehVg==
Message-ID: <341d1aed-13ad-41ee-ad30-487c5baec399@kernel.org>
Date: Mon, 1 Dec 2025 17:23:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] support batched checks of the references for large
 folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1763976541.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <cover.1763976541.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6A603A001D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5xogn3eur9rwmh6o8pchxuzn1gn55mjb
X-HE-Tag: 1764606201-994864
X-HE-Meta: U2FsdGVkX1/MNU3t/RvK7777EPhnDTD6m0UtbUDs6jUZYmZa3QP11C1sZ7hJo6ZbMurBYNpsrMkSuTYGqLgO0BUfBHBSADsR8z3Ef/4GROr6G38RPTUDw9cELSa1Ym/RSMo+tKwTRu/4WODMkD+bf+0nJHQXx8UUBYUj0OZDJ0GYYhyFVi5LE369b2Yo+0YSOp22zuEA5TiRs3VszAr1TkMX8MLN8vGMcWeEkwTp3wFTJMHT/PtaFwEJRy3Hih/i2AGITGU3/LxlfWITiEgzaLChODbqM0LqXxmojbvaY4QuoA47o6yAcmldaCZvm2KECQW2JC85fG9CZMSX0kMveTnVJHDeHblqEwvU+5lfCJLk2vw1Tq5lxO8PRSM5hDKnT7Jw6VxmkMXWtzs5Uwa52fMXQBwL7O3ffUrNpx9OZncpXxiOT6LQqo7zgsxzQiK2zZFaoBnXWN82BdOyu8FGkz8AUSqHw0u+uaH9K3OT75gFDHTqI0+DVc+uLVh85hwjaOVGUVXXbfxv8+sLWebW0b8wMNFyifzlyZ6GpI3/1QeyX8CGeYcOBVuoSQhNPtorkzlyWHJtvc1nKMphtKa1AngrjtS0Esnxa97niLXNBKXuJ4YcqOryCv0vGjzQ2ftuZX8Dz/D1UQSzFRB3qJLMTlYixePfcqYI3pzcsJsnMMeRLC3l2i7gV8vQm2kJIC8KPxa5K7KLC6R99SDV1z/PA1iUKqeKtr4rb4UMCgAFXF/hMlavB0chAsLD21HBJG7RtqYeOAfPAYicVUfi684r6+nOlXZ9sFiumqFvjP64R6hEmOKws2Qh9YIH4nPXHnUUnRIRpFKSwOvzIt45G0x+Q/ZKn41pKeqAk7ZsKAwQcNB8hpOBDATaJ4JbZJR04mNWyKiijput8IdmY87h6yBbBrIm9sG86L5/vnNtnPHf4cz+xrrzPrJTVsC05r/vWxtoTMGrA8Qig2BezL+5dC9
 Y7Ot/UHi
 M4xY2SPeapnHvhe+2JJER0PXq6Fn77zrDQ4DYr7PhzPtjUPCQ3Bjq/F4jX+hBXboGSHnwh7MKHSF2gO7GyRbIBqEqI99oGe3vOmbz3uMdpS04Hfw1CUdEEciZ9c/nbr1QKZP4PiiGVPVemLUt4Q1wprWIaWHobV82RINLWaGF8EVdNarxJGP0zaH7EmW4zMktrQCNQlvm3uVd3RypRw7W7Qv8DieB6PFrlabDT2j5sFm1lL56K8TVvSfewF2PrYnSNVcDH3OFn8HZMabdnRXrhxwtegSheDS4nIDO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/25/25 01:56, Baolin Wang wrote:
> Currently, folio_referenced_one() always checks the young flag for each PTE
> sequentially, which is inefficient for large folios. This inefficiency is
> especially noticeable when reclaiming clean file-backed large folios, where
> folio_referenced() is observed as a significant performance hotspot.
> 
> Moreover, on Arm architecture, which supports contiguous PTEs, there is already
> an optimization to clear the young flags for PTEs within a contiguous range.
> However, this is not sufficient. We can extend this to perform batched operations
> for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).
> 
> By supporting batched checking of the young flags and flushing TLB entries,
> I observed a 33% performance improvement in my file-backed folios reclaim tests.

Can you point at the benchmark or briefly explain what it does? What 
exactly are we measuring that improves by 33%?

-- 
Cheers

David

