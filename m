Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FFA5C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31E086B00DD; Wed, 12 Aug 2026 05:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F4F16B00DE; Wed, 12 Aug 2026 05:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2332B6B00DF; Wed, 12 Aug 2026 05:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F39EC6B00DD
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:19:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88B72C016A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:19:30 +0000 (UTC)
X-FDA: 85092069300.18.A71FD2E
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf24.hostedemail.com (Postfix) with ESMTP id 203CF18000D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:19:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ez5poWQF;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786526368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CaCusDgVv2l8Ud0TpqaYcXSMcsXjIAmjWTTMpzz/8oc=;
	b=wISMhYB9gOhYFXq5nmInT+Aip3aSm8AgdndRBs15BleOXBWpdVcUKHhuDH8eJ8S1ItuyJZ
	LlEoHjMUzBcM54QnN80u55BZE6ZuNdowvEBENFWnjryjVezC6ti8TpRYi009/9Fb1ywhLW
	KvYYYah03n0aN5viZubVMbwYWotmSf0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ez5poWQF;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786526368;
	b=H8/qb4iOWLHyx37aZl/YqdefyDo6LFdJEdg1EL9IuPkVZSJtkzG2En+svKvfuxTPQaM/WY
	3DkwGhZ/Ot4NHh74nTGLTRbdKItcAYKesCl1z5XE3baRP1qLaErIuS2ze+wOlPFgCnYbIA
	QNdvQRCtryxmjgyzZKDGePpxVMK/5Eo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786526362; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=CaCusDgVv2l8Ud0TpqaYcXSMcsXjIAmjWTTMpzz/8oc=;
	b=Ez5poWQFsiVlIWZNRch50Y9b1MjNjI1z/xJiAj1tFHwbC9bY1M0C6gUGItC3Q28DFXXNbZ1MWWEKJKGM4Nb3wx8Iw3vWDBmQ/qVkcIL3WooRtx9p6h1fagRwd+YvDH7oVm8cOqBHno15ss0GYdTJ4sRiK4/EmH9oNYrZRzgkB7c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X8rG8n8_1786526359;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8rG8n8_1786526359 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 12 Aug 2026 17:19:20 +0800
Message-ID: <f78bdc98-545f-46a7-9c99-a62807bbd2ac@linux.alibaba.com>
Date: Wed, 12 Aug 2026 17:19:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] mm/khugepaged: extract reference check into
 folio_pte_referenced() helper
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jn6653q8aiit7et8hco7mcaimnucmmti
X-Rspamd-Queue-Id: 203CF18000D
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786526366-916727
X-HE-Meta: U2FsdGVkX1/NSqS9buAJW4FxZzDDRQ/wIFMg4RlaTOCGGVlO6xtUJJ9Z5eWj19+FrjfHiJs42vpAYV2DYFlCfAQTtKJgD7be0ot5UKTXUpVbYbTgmwxUCMXDelur6MBHRX9+75z/rhiQkSPsoECztDTjfZDEV6Wwiv8YlZgWo+1k391mHte1Hj5/m5rg5/V0y9wPbT4CZK897IX4g3tbwR+RCZCIec0RVmaHomN5d1iHHSH6zN4Qsn6QFn8Rc7riRGPu/SYNIsIyHmRJsCmfTJKmHA64j7U9PZjTp/jXXqAti9HGOSFHU0+0eFHpveP+HVhAivus/oubtlsEy/b+jFd+ISjSXkhmE8WHm0l2HmC0ArKCvc+B/YZSQpdujggiV+r4AetfSoIOyysg/RT7ZWvihsi2dMDYGwrEX4MGHzU9LfKYzrawA/KwRVBBAcBV8ez6ocjtcoKvq490SX4/IBPGvwajmcscWiGlonRUUb1UN1usbVWInVeWtBKBzlEv9/Vov+W18FvFC11y1q9CapnZ9EajYFDoALihbuMIVnLhpJaWUTFGwoG7h2vpKky01lQt/+gQYVgukvWKC8iBp321O1uJ0rXrMotjnGT9IUQAI+0umimvCNnQRGVhCafPummm6Z87+A1ZEihkdUwW8g6D6iICdu8gBPxZlPhng71XEQ1gezvlaAL2mPlnCD0UyTjXl7QOhXCisAUlTgj3uD8ny5+ineDy/VxJM+1JRDTiu1LsMdzRFZnN7++YHXN0sjFgQQAnXv0BpRkZh8vkq5Et+pGU3DJvg3HmnyVjeLzF68lclhFXQu4ye5jIK82i7es2/aGXifszuTU5VSIK73GV9NlxWQGVqMjeQdxtWFC9ZDSxEP0E7yf1JO2y2R0NJ+Xo0TLcDCYyw3dy3raD1z9sH1y7xK4npLlydcf6gm2y3F9E4xFHGXehUIi12dDNjt3IKHXhSCPR/ljJazO
 I8+ke/IC
 tiOYkJLQ16gH9Ygx1qxh/pwB34/oI5fsUgWjaaUQgw4Wto5UbzqhS9woxOg4Bufh3noCuSTuNrW4xAqZUoCwEwUvFrwM+OoJ13/PZDrxTDdFQn2e5mzmbitO3pEklOFXHB9tdSlWoWSfld/5IarJrxEwOn+9AkA8tqqxNNH6T5UTn6/f6qxDlBZPaDbO1r/s//FVAuLhirD2ep4GcdKl365H2kaMW8iKvLcSKcA6mR6UGKoMMX3xDBbWdHR3DJzntRxRLRgzKYJ5zkuYVvue6+rmVGgWFJBCcVuf9wt2EQAO+k21jikStaibgyZ8c8zPj1JiidqgBnFH7Z13I/nqZh/vpg+9Lc5yPDvmJErl9DnNbzRbag5sCg44DCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/11/26 8:48 PM, Nico Pache (Red Hat) wrote:
> This change deduplicates the "is this PTE/folio referenced enough to be
> considered for a collapse" condition that was repeated in both
> __collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
> a single inline helper function.
> 
> Also move the comment and use it as the function header. While we are at
> it, updated the comment to clarify that a young pte is a recently accessed
> one.
> 
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---
>   mm/khugepaged.c | 32 ++++++++++++++++++--------------
>   1 file changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1e26ea97381a..8babd4c97db6 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -672,6 +672,22 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>   	}
>   }
>   
> +/*
> + * folio_pte_referenced() - Check if a folio or its PTE mapping was recently used
> + *
> + * Return: true if recent access was observed through either the folio state
> + * or the current PTE mapping.
> + */
> +static inline bool folio_pte_referenced(struct folio *folio,
> +		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
> +{
> +	/* The folio was referenced previously ... */
> +	if (folio_test_young(folio) || folio_test_referenced(folio))
> +		return true;
> +	/* ... or the PTE mapping was recently used */
> +	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);
> +}

Thanks David for asking again to move the 'cc->is_khugepaged' out of 
this helper. I also suggested this before[1]. So

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

[1] 
https://lore.kernel.org/all/62b2bd29-28d2-4440-a970-526dd5d5bbe0@linux.alibaba.com/

