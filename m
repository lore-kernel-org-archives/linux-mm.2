Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CBFFC9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 01:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C79D6B0088; Sun, 27 Sep 2026 21:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 250436B008A; Sun, 27 Sep 2026 21:50:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119386B008C; Sun, 27 Sep 2026 21:50:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D47816B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 21:50:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E30880ABC
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:50:09 +0000 (UTC)
X-FDA: 85261490538.13.9CEAACF
Received: from mta0.migadu.com (out-35.mta0.migadu.com [91.218.175.35])
	by imf08.hostedemail.com (Postfix) with ESMTP id 17F5B160007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:50:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i642vPZ6;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.35 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790560207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h3nRgSDQzHRceNINJ0CmgoIAJgoR/3hhS49F+G/qdCE=;
	b=bEFqQeJ2LtSXjTtcM4XM1/ieM6faVXXTfFXNdofuKYNCLIOFzNVfUuZ4AdcGBGXlQC+cVA
	/wcWCl4Hl6WH1vPPuJlUyjh37KQtUcynPeoKxKJgWRrPPoF4bYyMXB+Vx/ElZU9GN3PhiI
	xnoBGwx3Y+nMhpptyuERtxxBHRxat04=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i642vPZ6;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.35 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790560207;
	b=afPza7ufN+NypwOJRckL98qxHlsE8mFJ+NdoxU6cFmfIzt2T7iGukcIOABOilBWbvHUIpi
	32gOsz4pFF/Vu5ONbL/sAPjAHqlna7ILmHSinWYyaERZLdqao6D+M3VkGBt47r6pdp6Evo
	v1h1I3UfKbhVk/P2XYEY6AUJfNkJ3HQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RAi6LaQaIERnguNa75CIILKwcfJnHB40JrzKtoc+ARQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790560205; v=1; x=1791165005;
 b=i642vPZ6AAFEMsfq6Yf1PfwOeeahFco14EV8Avqv9HTqhooaA2j0gfOA2QJG2ehTPfshwSez
 DxNTAJZgTXcZiON6+hVgi9VPWLxcNsjHcCenEcJaFQSe9zmWQ2PzWXhqP/mTJqyDyTfZJmFWO7b
 /zI8ptKsDVXsSm7as7JtU6EA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b6a582d4e49657da;
	Mon, 28 Sep 2026 01:50:02 +0000
X-Mizu-Trace-ID: b6a582d4e49657da
X-Migadu-Flow: FLOW_OUT
Message-ID: <99cdc0cd-3af1-4d61-af28-47fad8657c62@linux.dev>
Date: Mon, 28 Sep 2026 09:49:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] mm/sparse-vmemmap: support device DAX in common
 vmemmap path
To: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin
 <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev
References: <20260924075259.2013039-1-songmuchun@bytedance.com>
 <20260924075259.2013039-3-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260924075259.2013039-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 17F5B160007
X-Stat-Signature: zcyjoitdpn9w6ipk6xxs7y8cruyxduk9
X-Rspam-User: 
X-HE-Tag: 1790560206-180111
X-HE-Meta: U2FsdGVkX18rXr1q+vBHizNgPhYKJA0V82ryqiKoX6xwYMzo/7/lkdXkLaD3/grQDKf7inc1cHbEJrhMpSKuuivgiX2ReqdkOqsWlxnJUoUVJH6HLNweg/yFQmpFksLPh3srnPwzH7XBWIHNy/lVJuwPCgOoKmpUaEHnynCNGTLTi2lkuh8qyIw1CoNgO7zoXmSRpeTMyTN7lwnW9I9EvtzEqicg635RuiL8km7vwE8PAXHJ11rG64JZ4VDZfMYH6CI3AjoJFyW+JlxG5rfQOlcEkKOoIlQZw1xiGqAsTKwCXoe5E9d37fD14mDFkrgmalcsm4QiKr0S9NbGoicvbgg9HrIbMi3TTNH6rSeYB4dNkn7/QhZxu3eLs2XTO8A5J1w9xoOCCYA1er8meKdJiIuEGCEJeiFyBrBs2DtuKiJ1hFnZF/y7XSoFATPSCDWnQK1DNFIx61cUMwbwO14BMxD7X5vc5TA8VZGk8brTpE78wXQUZa8uxaw7AUASvNuwyk4/7rtkCsK/ti8HKyduHmXKbgdMWKbMHhoHg6m5sPRTVnbcTkHxtNbcKjCiNe/++bO3t+quilaaw4HXzVNo+QNExEGevxDgJSvi4VKknrkoMWrysiIvvJxckzEh9EoaEOPsKz1KaeELo9eC0/LtQ/mCpRLPz/tA/rHFcBFUMuCcy3uSo0k+8btumdn9WV9hRXAfswAHXfC+ZUz55M7CGMerUdLD7Pno/gu4cDe/Px7+HBFGCmctCD34WLpHJRD0jH+eLIXOU8/mHY426xpykhVXVUm8jzYJ0to7ugd4my5co98EveI+zO1j76ZkyVnogVe32gP4jRtOREaqH7v31FCp3sRacBaHNvvdjhiIpzyIoyihRtduPP9LJB63/EfJCfWfUMCzihcdG0uPAyT7Uo+USAiz1A9xiJhhg0/XE9cBOfWnUXvMzC/kycnb5V1L1uEbBvJQqIOrmQYyFa/
 FjU/pUdz
 Ux7+l23bb/ZHCvkJbKfp1BDSwHLa3iHC/vIWJu2IPbnGuxYhXxRarT4n7ObmKHZJZXdwuwbWVMPAyQI1VGakUSvENOeepEHNSPkOB57k41V77APSb7oheKkmP6IBGYWBggaXt+0nAefLagt1L33CzP/I/HdmKMVqOfSQfdfPbO/XWos/WPwNuxbdury9hRyqGKulq/7eN+UZ7jdNPFvXURwIMNKFpnL4EVeDHwc4qZg8oOe6RzGqXjq3WeysNwYe564n/uWSWRH6q3BgSI9jhY639/9obJKFWc805tUvZIJUwZlg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/24/26 3:52 PM, Muchun Song wrote:
> The common vmemmap population path cannot yet handle optimized Device DAX
> mappings on its own. It uses pfn_to_zone() to find the shared tail page,
> but Device DAX populates its vmemmap at runtime before the ZONE_DEVICE span
> is initialized.
> 
> Teach the common path to use device_zone() for runtime optimized vmemmap
> population while retaining pfn_to_zone() for early boot. This allows the
> same path to support both early boot mappings and Device DAX.
> 
> The backing PFN supplied by the Device DAX-specific population path is no
> longer used, allowing the redundant lookup and population code to be
> removed later.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v2:
> - Expand comments around slab initialization to explain zone lookup and
>    page refcounting (suggested by Qi Zheng)
> ---
>   mm/sparse-vmemmap.c | 56 +++++++++++++++++++++++++--------------------
>   1 file changed, 31 insertions(+), 25 deletions(-)

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi




