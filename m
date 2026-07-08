Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E90C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1958E6B00A1; Wed,  8 Jul 2026 03:56:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11F486B00A5; Wed,  8 Jul 2026 03:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00DCF6B00A6; Wed,  8 Jul 2026 03:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C256E6B00A1
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:56:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 412821206F5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:56:38 +0000 (UTC)
X-FDA: 84964852476.01.9767C82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 74FCFC0007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:56:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XhZ5wam4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783497396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iF0WU+Dby9RJdsVxJ9dmUlAKDBzHHa10m32nvy0nqXU=;
	b=jhBURDry2jrAi0NXE34QDAbRr7cZOfQpGEoy0zE8NKtO2BeiRfGxSdJh+TVC3B2U0CGLeB
	JhJyzol1UBbq3Fq0xMwyt66To9mP2UwBWLIWxf+JZuhwYwESuECajXylhRvjn9fVpMpE4k
	RdDrS+gpRAYyziG1frRJio58wkWF7XM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XhZ5wam4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783497396;
	b=oTq/JWBiKhMhyL4hE2eFonJUAw3olUZFpI/akX4iAQOsJkiFqryA9eMN6Gut1BRd17N9lf
	9Frk8hQRHpyos4cfteiL1FECzu3MzSTukCKxdzXlxG2yG/mqkAaaQjATFQi857HSLEluFT
	njCFRFNWAiiebp6Lk9QK4KdLk/l1m5M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AAEB240478;
	Wed,  8 Jul 2026 07:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36B11F000E9;
	Wed,  8 Jul 2026 07:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783497395;
	bh=iF0WU+Dby9RJdsVxJ9dmUlAKDBzHHa10m32nvy0nqXU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XhZ5wam45rznxZvw7gY0USWzU5QfUteHzSBCzZuoFfeYk9fbKGpP9JXYTo98LVWam
	 MrTz64bB56Ez7PKLsdETUlpWEgebzZSfIqBuaPZOfOhLZUfNm0GTJIAN45voZE/EYO
	 qeZ8OGp6AoTHEXKtruHinJg/0mqNn3ZzoVMFtZlR4eHbJtqGH5G6f6wHvAK0gzKN5m
	 9pPQfk69bty/aN0rZLbkTU8alwYp0cZ7i4K1zB7UhIrdU8XFKpXyRsjm3mbPhk21/x
	 mOr2sQMdPWtu81RTdp57gduttlFviMNglvv1a7X7/8kc2L9pn3jXv61OcSOLwy6MVL
	 u1GJv1xza3SFw==
Message-ID: <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
Date: Wed, 8 Jul 2026 09:56:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
To: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: usama.arif@linux.dev, alex@ghiti.fr, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <20260707201735.4113107-3-joannelkoong@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707201735.4113107-3-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 74FCFC0007
X-Stat-Signature: hjzfemtyh6hk4n6m5jdxwbh8uham3wow
X-Rspam-User: 
X-HE-Tag: 1783497396-411329
X-HE-Meta: U2FsdGVkX19MopJeCPCw0noQYGh6w2pkP8/Tbxwcuws7vgn6mJct38KcPEgQ3zOdPeN65ZD3vZrmOAYfDb3p7SR3v6fJuArQ5+8GQirciwSSYGaeZ3e62PDx2Uk735iB3ipfevkyG5eZj2PWxFO502VamUFdCjud9+jPLKjZRwIeRlgh1oHXvqfH57VrnsjYOjICVBUnDUxvesu0hoB1tbQC3hVVrdqSNWa7xPf6d+WYiD2qCUnzQTvRb7qtqtBjQZAPrh/in3IbyTqrlxI2f+SAXa69Xg429AL956IcbL3ZOYcuZKh9L23P4ODlpY1Vz16CY6qIcpwHi1PQ7gQ8ZQq/48LsR8jkJWl+GqHoPLaLdHRlAWzi73Q85AFhp4n7N4/unlLf84q9Ai51qSc9yWjDQy4MphwzisOFxGpQmrWxKq1fnlx7I7Af5S5IJqQj8Mxm2RTu8dpjgtS5RIB9mRhThmZoj7wtM+wVPpqJlYnruGUrL7SFDeu5RdJZXzgT+/hFSBDCv1wq5m3Cx3tACKSRHcC7IadCY1IP9GF2R3R0AOb/h8bhS63RXkglErPOwLF+S+2qoN/JQ50lzSvql+qQcl/o1mCQ2oOiWZY2kB4LQ2uRzJ2sitG0RIWdLlUgoCltkQ+yZw6iJdzFFuurlmmugHD73CJt4CAcI7yzGfazkY3HqDa84Kojk613Pi6Gngko8I/vkgm5PrTFnK31IToxr+RB8JFPU4XBzYarkyW6vGyh8MxLwVtJhwrHitWiH34c/ArJmX8/dYVaGRhrUIMxjbfQJL226rjyESFEtp/xFy09OEyNeKxiue+4+FOW2E6pr3W2jDg/0ua9SiUVGnBwJP5KW3VexKk/h4xJ2mHu4c5KuB7B/cZREsSvoq92oUdK+6Sbfz8COELI/p1s9pqZjUuqTTD5Gr2+11+P25qHXy7JHFFBtRa60a8vfeKrKAVwQcZq1PlqpwoyagB
 qu+bAwmL
 Oj4FET2f/mHI7vRZrZJk+1PI408LnU1uSOrsxp1bhq85mGvNQLfQwPz/RjEqHgBL4aqFqEWdw32L5lsaOdbzogU/cR+wJ4HzXOiasfrlB27aXBjSbZ8dJyAL8fCaFVDQZPqj5pFHmWVx7PmY8cpSy3+RQ064IJxrEBe7zP6SvK+vXiC6ekbfKc7C3SdxrYsk7pfXDYPMOJuDw55VGo+0lmd7N/gijN5We0CNIFLTeOAOaBK7NHGTaaa55HtqNlzt1rA2l18XKPa10ch2zroHF+1mYBJZLMDU2Qs/fWk9uowBD5x9ddQaHJwUd9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 22:17, Joanne Koong wrote:
> Unlike for PMD-sized folios, an anonymous mTHP folio doesn't get added
> to the deferred split list at fault or collapse time. As a result, a
> fully mapped mTHP folio that is mostly zero-filled doesn't get split by
> the deferred split shrinker when the system is under memory pressure.
> 
> Add anonymous mTHP folios to the deferred split list so that if there's
> memory pressure, a zero-filled mTHP can be split with its zero pages
> remapped to the shared zero page and then reclaimed.
> 
> To minimize overhead on the common order-0 fault path, the
> deferred_split_folio() call is guarded by an inline folio_test_large()
> check.
> 
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  mm/memory.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 6637c5b13c9b..441d918e3dc0 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5259,6 +5259,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
>  	folio_add_lru_vma(folio, vma);
>  	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
>  	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
> +	if (folio_test_large(folio))
> +		deferred_split_folio(folio, false);
>  }
>  
>  static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,

I had a session [1] at LSF/MM about having essentially all large anon folios
part of the the deferred split queue.

(1) I don't think this scales.

(2) I suspect the shrinker should make smarter decisions of what to scan/reclaim
first.

I think this needs more proper thought.

[1]
https://docs.google.com/presentation/d/1RfKWCY1AMVns-WLn-QdAWbI2a-rA7fbFyh7XD1Wn5BY/edit?usp=sharing

-- 
Cheers,

David

