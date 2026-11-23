Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BAAB606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cBsGZTjI
Received: by kanga.kvack.org (Postfix)
	id 6FB3B6B05B0; Mon, 23 Nov 2026 04:49:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AB396B05B3; Mon, 23 Nov 2026 04:49:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5735E6B05B9; Mon, 23 Nov 2026 04:49:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1340E6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:49:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 727E51C4227
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:49:51 +0000 (UTC)
X-FDA: 85465912182.23.D256DFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B8A5A80007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:49:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cBsGZTjI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795427389;
	b=DO2x4tdWm1K/+7+bBL5YuBQcpcuFC16/dtJt5KZ/JMbsUHwYplRvPRIh5ulA3HzG5oGb8k
	+kh/n5Kftsgfyy6LN4uWl0w/xx9bJtOYaNncVlOU0NALh7RBth1hCCjryR6b9HSG1bfnUZ
	o+XSPLS86U62od3EOq7fU2tyWK0v1Wc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795427389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ef54Pql+YoPfTG1BLTpFwT/5ZO7fM9qVVWeboMwz5EM=;
	b=Ceeq2zUmU8dyKHn3PwNQHdBRGT3EUaR2xGoQJmKST1fbWmzZZPde6xqO/Wbj4BZds35yk0
	9cVxlHT27+LmQd/g7M4bwPTmS53npqSoqueArzOj33M5jhej9v2EyBIhFhwMH1GlsFhTCN
	m3XgYowSOLL+K4+NtQWUm86ltjwkJNw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cBsGZTjI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 559D66021E;
	Mon, 23 Nov 2026 09:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D5A1F000C0;
	Mon, 23 Nov 2026 09:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795427389;
	bh=Ef54Pql+YoPfTG1BLTpFwT/5ZO7fM9qVVWeboMwz5EM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cBsGZTjIXO2UkHKZiW3Bxi0OW5d3U0M9bsOJbVpk/F/k3SbYin0kA4TQbz4+Zn6s3
	 oXBMXy5Jp4qbOQpRxhjqBr0ZI+1VFahJrBA6rVlFTTMdcdriW6yZD89gxRNT3PKowJ
	 kOm1uqWK+K7AH8gWvxINpZPgGc4z1zunfVwz8A2DdQM4zEKYMvrRCg6g2gVPf/2U3y
	 Yrw1fAUv90GI6Tn/E6O6nEv42lCLbu1cBcVHDprigbfIpIu+ycdAPUvz5kDrO5ORAS
	 VcN2HSMDv/UBDNWiEhXlYIgExf3BgvCVtVPbag8LTK3AmRmgFrAyTw9O12W/5kzBM4
	 uZy/0XLWw0x1A==
Message-ID: <16e6001e-4e3a-4aac-8be4-05e754248f02@kernel.org>
Date: Mon, 23 Nov 2026 10:49:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: page_alloc: make the high-order watermark
 check honour ALLOC_NOFRAGMENT
Content-Language: en-US
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261116125103.2894162-1-kas@kernel.org>
 <20261116125103.2894162-3-kas@kernel.org>
 <a066d403-1608-4c0b-b06b-0b786e71b12d@arm.com>
 <av7_n5llADUbJI-r@shutemov.name>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <av7_n5llADUbJI-r@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ae9s6be988yzawdfdp7ztwcqh513uu5z
X-Rspamd-Queue-Id: B8A5A80007
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795427389-698747
X-HE-Meta: U2FsdGVkX19hC8aSJFmZlu23koo9/bLP4IZQQdT1AxOy5/CKl/vHfknqid1Z7ti5Mp45mUVgit8LJMN1rswga7Tu2yvoFnfxSAZf4QzOMWH2FNBprxLnL8qQ2h/BA2c1DuMn3WULLIGKURCnL6GLt0PXpAUP774f+WdryjSgANQoiJle2cwBX/eaTOlLMiIh5b1Dfvk+ZEGmvfZk4C/nHMWebgstbyCNNhNT1DsCjtiDeL+3mPHa45a9VswNL3zhA4iPwj2CK1NfvfHvXfc2nk1hV1EtyiVMa8ehdASXJb1zFTzI+TWuJ7nZoEVWhWK4AIQm/B8Fm8xUIr5apenghSJboLEE3S5bp8bIZLLo19DYCSgK4hz5IPj3mpxfw63kC3J1lgDLJsNStG+shbxmJVOqrLzW8R3lR/PL7/zgpPLGNhlTRbzDWbqC4z+y+nQoeGbza62q1xFWLKfTnq5rWjb9qPD69/Ni6a1w2X/MOlL4wCRfCeyqb33LnHm0cJemTrr3mEzzWJ4v9KTfnMFvleNEPIvuirIP29jfzhQ5VgwUbz85VPimVDLja2kad2v/8JppsB7DtvUIIKPu5BumMCwagHN1PUtty4Q4Lz4inwIErTl4TuASEnAYJ+hR/btcVfOu2Ga37bxS9hvzg7y1T1k3Hxs1cYXyGRIX9UgXQdIQ4FyTAfrtH9+L12nQyfhPx5HG+aZygtPCwODMbyh6IP3BQ+7KEvrtqgDPerujqHTjhYuZEZtMxbZ7WVz6mDtlxlMjvR6X1sAtQ+qja9N9HzCG6NChJDpNsOyoXviooYpN35qGznv5mjNCh7DFAwv0Hj1Hphy5XLYodBq2jZqv7jbQGLKx/BRoBMm1zWyQSYTmdw+s8dFicoENgJ9RkxXJ7kXJaa8YN2rJntJSy+mfX8Dhsz0QRZCuX3Y3kJGfqD6urz9nGV+HlE3gGmJEU12KqJE86rpBaDJftYw/8Hg
 +xUNOFF1
 9BTTjVyYkxxjHr+gWApulwCdOQ7bp35Q9sar1fQwmIiHa9DzNq6fuviLV25R4VnBaMaVrv9LCihlR6lYtByF04R00fFh13od+tQ/VIC2eQdM5Z+3N+QiK1fGLz1P2fsdQc3/jy0cvkRmEaBa4E9ft2X6/c0vwrV8phjGM9UkU0gGzstpfktPVMOfCD7gjTeZbjeNE3HF8hCA7laUasMB8bBmVby3M03OQu14rb0gyEOxfVdr92pSWtN+GxYR0sjXNR9uV/bgYway1LLcgE7+eWCGO28zsAwUkZH7bTRK3zVaK+K6t8f7A88ay0Vcun6ZFVCbUzn68QKg1rPN6IMBGXI0j++yJ1VYVqISZ0OjPwhZDg3ECK7FBqpClTrRZGuoxRoffiHUg/WnGfOohz91O36gch6rvgg7fD/C+2LT7SQMmBIIlpgEBfehyky4LjUDvfhNzwJd8znjSvGSaBgGrFRHNKTo4aOkzKd7yYuHCJUJlESdbkgvU9TfncE9VR/0A4DXjK3tjGRhGKzD4HnMAV4445A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 15:02, Kiryl Shutsemau (Meta) wrote:
> On Wed, Nov 18, 2026 at 01:40:17PM +0530, Dev Jain wrote:
>> So let us do something like: we have zone_watermark_ok_for_alloc. It will call
>> zone_watermark_ok, which will only handle the watermark computation (so this is a
>> refactor for the code ending at if (!order) line in current zone_watermark_ok).
>> Then it will also scan the freelists for the correct order, correct migratetype etc.
> 
> A count-only zone_watermark_ok() does not work for three callers that
> pass a high order: kswapd's pgdat_balanced(), kcompactd's
> __compact_finished() under defrag_mode, and should_reclaim_retry(). They
> ask whether the zone has a free page of that order regardless of
> migratetype. They need the free list scan without the migratetype
> filter, so neither of your two helpers fits them.
> 
> So the split is not count vs scan. It is the zone as a whole vs one
> request, as the comment above __zone_watermark_ok() says. The _mt variant
> is the one that takes the request's migratetype. Callers that only want
> the count already pass order 0.
> 
> I am not particularly tied to the _mt() name, but _for_alloc() is a
> mouthful.

Agreed. I've left it as is, we can cleanup later.


