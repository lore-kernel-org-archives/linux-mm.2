Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B033C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460726B0096; Fri, 18 Sep 2026 08:05:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410BF6B0098; Fri, 18 Sep 2026 08:05:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326AD6B0099; Fri, 18 Sep 2026 08:05:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E05F6B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:05:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 987EB40693
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:05:19 +0000 (UTC)
X-FDA: 85226752758.17.44FC468
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C87AE14000F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:05:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=feuOnPyn;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789733117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSiQ3QMreWpLjgxso1PqR96WBdVagKdVsODyghsTQXE=;
	b=46U1W56b1Zurhr2upk9iWXAeRdKvxrMs9iROCYd+LPE7PtTIrk8IY+FbuaDMb+Vik3V9cv
	SyE5yeYuko2RYBk+cTpackzFPtdEkWjIUv04IspEfmIRjw0tXidB0s04hyBKDVjf13Rcqp
	Li0CrRr/wR4wl6BAUbpXrxgcBPycPeY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=feuOnPyn;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789733117;
	b=CcfFrI3yD8Avbb0iEq8VhH39Ar6HJa+d2FWmO405IAilJxBgUHpcMLG5EAUcEHrEih4m0y
	P5cLKgGYQacojjzO8crXf7ELGYXWAx2Yr2DCqKBrXahxk2qmmK2E8UPtm3CAtbSS7LLYeq
	qExhfvlFQpfWvDEzUjyvmzr857D+hwg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2736740A07;
	Fri, 18 Sep 2026 12:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092AD1F000FF;
	Fri, 18 Sep 2026 12:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789733117;
	bh=cSiQ3QMreWpLjgxso1PqR96WBdVagKdVsODyghsTQXE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=feuOnPynGATQzBm+y5Y0N8iVZf3OcStsF8Lj1jKsGJsLKUfiFJa6BoCVk/JaYVQyk
	 OxfyjPWu+TfwGnIs4ArII6v83x/jIgYGSa9659+haoeGP6g1uDAwjoIG055ijR47jv
	 AxEik0AMjOpisiDDEZf3jK9UlykYZnSbRqhqvS6UIob1bQ/BnBH56dNFsNYvM9v5Qz
	 u85GnqQwFf7PetGzpkpWyy6BMKwFisHo9GUzMbxkcjxPfdyGWktdFd0L1zTJI9c20n
	 20knn2MbkptmWjYIVD1/fUc0fgmoKzUkxyS6xrsWAYpUPJ2psc6ULCUqpGyj0sVi3g
	 BCRycWP02kM5g==
Message-ID: <9d3355f2-2d3d-4767-9972-ea57ac50ff79@kernel.org>
Date: Fri, 18 Sep 2026 14:05:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm/vma: const-ify vma_assert_stabilised() and
 associated functions
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260917-vma-is-faulted-v3-0-5c22314a72e7@kernel.org>
 <20260917-vma-is-faulted-v3-1-5c22314a72e7@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-vma-is-faulted-v3-1-5c22314a72e7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: smakh9rzr7orwf7gigr9onm811g9cbuo
X-Rspamd-Queue-Id: C87AE14000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1789733117-377830
X-HE-Meta: U2FsdGVkX1/Rhqk+H74dbvtFOIWb24hioqQIZl/DMxjdO2mCdmCsxnMWyTWH7O/i3CWSXy+qFsX4yRoE/O93xjCdAHFxWvxGXreRIVP0yZWbQSo/MgkPtaDiCSj2TSrro48zcLRmwPpB0KCtn0sJ2uMRNSUkI4p8n2pTDuHWT+B8jBxV3wgK7on6fB9Mz7n5c+I8f1Y1MK+ga6x1DIeZSeAm1kw6ys/xbTYUKhNawf1J+CVLb+ppMaZRAYHW1bAY1sBao1brQm5UqDQ6qnQyc6ZhifBEabDLNWgkA/0IPMFEqic68cmZ+KM87g3VhZ0rnTebLFm6590HGq23GK+uzpwSnEPGs5F1UTkzmqD51Yx+iRGcvprfmEv2iFjHf+I5bwue2gi/UBWYqQpYqaKo+abifRZab7kzsyPYRzoc9wHVG0aoLftIFK4V4NIH1foswPKwiZC4dRJftqNU4OhUMI0eOrH/69Fk7AW3rR0gDh2dBqaKc4P5PrEFxEqD3ZQTCsUt6fLc7Y7zp5qXNw1iCSfkHNVefLvpwZVXBF7jZO7BoUtoeorZR2d+NluyboTQppNcSrD5dfMVwiiPShZkKKBqgTVkqjGv9Hdz+pLQFf2f+GNxB+VWLyJGVSxcUpEerw85YhpU2k2qJI4OWNAWk4/rEAIAPx/0X6aQWANjmvhDfKbFb3Z/Ik4PADeEGFlMA8jTEhwrKgSu9Zq604uWDjjhD7k324JsTx/WXzgZTg0yyV3q13kRa1G+GOEueceNOa7FP+PUNCtSSGU7Xl4l3HwRGdbu35liAsz6555CtzHUCYvUcprkcV0A9iqIwImLmjyGhH4YbemGHuQra0Ox8qOGNfkeG8aFPZBu+249NVn/HdveZ+H4EG0tf15xAcSZm0IA71HISJdaOkyIzr0LXdLuXIkQSMoYnvmauQP/2Z4Z8Fn2T2p9HS1EyuZ417Pqz5BKPnJKNxY8BFf0UJZ
 RENNfS4b
 SXnj8rySWPcRqDeqFUNdwTApNQm0Gwt01o5D7MuWpV4hN0Cfxx/Z0zoxEA2X6wg3j7TJLbvpcgw+LA2b9MmLwzuYYz6fjnzgZdCQtehdMWLj25K613Ic0O4Wef5wuBbquiFbcPdDLrcgdEzFvC+MCBzD6dSFuK3IjxLbMiH8p9Zqg2uroiiQ4OpHRVuoR2nYXK95HTkYY0R9ThrPKtOVUxjCmihnTnO4DIKSic2K/z60WrrlQEdnU0vmpPuRhsgMphnTko5HlWDpA5uHjbbeeCLtKCJYAKc7me0ZDWvMaWlQGm+Xz7lEBvVU91LzSC0frsBi35kFCsIXPhu5O+UI1UtTd8uD9hs/w3w5XK3WgGVZ088Mu15FK+BFmTtFlcVmQ8w0cmsc6WskKi1YHbHm93qkW0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 21:47, Lorenzo Stoakes (ARM) wrote:
> The vma pointers are not modified in any of these functions so make it
> official by const-ify them.
> 
> Propagate this throughout the call stack.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

