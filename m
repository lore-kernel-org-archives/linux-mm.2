Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03079606A33B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 04:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TQUol2j4
Received: by kanga.kvack.org (Postfix)
	id 0AAA16B05B5; Sun, 15 Nov 2026 23:20:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082EF6B05B6; Sun, 15 Nov 2026 23:20:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F04A06B05B7; Sun, 15 Nov 2026 23:20:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC41D6B05B5
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:20:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C0DCA863E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:20:58 +0000 (UTC)
X-FDA: 85439681796.28.C05AFBC
Received: from mta1.migadu.com (out-149.mta1.migadu.com [95.215.58.149])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5BE3F180007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:20:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TQUol2j4;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.149 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794802856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hwx3UqmvUcD/HyRqK0DpAUkWsr95XozabXUp3cBOCMk=;
	b=NzAy6JhlsycSbfBiAMm+oUWbDWEGUlnw8GhY4IYoh9QW7UEqCbfpOjNnmjsEXDJZYTJL3y
	fH9/IOPmfnI0HDsTQDlIrQswD5FyISWSyXrKkNVvCXUMH4ZHJRD29nvaSRFduPt01s/6ta
	Ii/cfP0c6q6XlUOremPO0tHCAsxx5dA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794802856;
	b=QFEwtuPOkt6gRl3AOFbiSaXo/XAfuP/zPpsBhOkwZIOp7AVXTvIIWIk+/NrZZvpWG77dKE
	2mQJ8V5DBlNlFZIrTFcXjMKAbgoZVQKeZGwnvUVVB8ItV+10MLOxZl8Fn3JpF/0yfIan+N
	DInyP/CQdABUMMQ2c0TvKuFhEdwH8jA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TQUol2j4;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.149 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7pW8AZ8R/uTepnlgwO1WpGRt3bCUzg1YhLz1Re5mJrg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794802854; v=1; x=1795407654;
 b=TQUol2j4Aagt78om7KOFmEdN1Ij6QCkrL8ywx9HPQx+fSwH5132izO9ORmIpD6VPL5LdSrFo
 Y6l5ayhTHz6gNcR7ruhQ4oiCztTGwZknXVRkSoAizIzsMjBU8u0UahPGGNqGG769FAZMtAsPWv7
 jGDqm0FH3EW8dcnDGmYQ1pLg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ad4f7a5ec1aa5aec;
	Mon, 16 Nov 2026 04:20:54 +0000
X-Mizu-Trace-ID: ad4f7a5ec1aa5aec
X-Migadu-Flow: FLOW_OUT
Message-ID: <080c7d55-f140-4265-a30e-e5d568f3b954@linux.dev>
Date: Mon, 16 Nov 2026 12:20:40 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/14] mm: Unify memmap initialization for compound
 pages
To: Muchun Song <songmuchun@bytedance.com>
Cc: Li Zhe <lizhe.67@bytedance.com>, Andrew Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, James Houghton <jthoughton@google.com>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261113033442.62970-1-songmuchun@bytedance.com>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20261113033442.62970-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 3q7by6bhcz988jp5u7pe3e1xk46t878e
X-Rspamd-Queue-Id: 5BE3F180007
X-Rspam-User: 
X-HE-Tag: 1794802856-432588
X-HE-Meta: U2FsdGVkX19ilLr79utXONHHxbn1YZUfJpHXxSlNyzlj1aRQ3HkEd45zmu9sJrJBNR4rGahkZbWeNkKo8hpXTOO8oIzNCIPcxHMx07JWCCs+Ri4Bb4EvM5xyGMaItPaOaEMKOCUdWYI6i1CQvBEFavRLL2unWscQgDO+AQpwBA3UP2nWDDtP+YKVfROLoXvNQMch/5yUMwu2C6soSuSLA0bn4KevZm+J/22d36cRfFaM5qbG5vANeHP3PHYUioBahNSgmrLEmJJp38jNzynqcxGsSejaeB3/7THAd1ok44mqKdZXxHoP2McQLSXD52Ggj7z38nHi53ae6DYkPWz5b+Tu43a2WB3i28niHy83Nj3FyOVw+t4R7pac+AS6lp4O0E3MapvtSwe2OOqeVOnqLtXO/hI5CNFcM56SiLh8mixLKVGGyvawNd9XZLYAJwyVwVLmIX9pkR3G+0JOXzC5eSJfTyGSgBQ4xcawLsanDC9bzt+bB86Z5fegd2MvSoWkp+hRUy2LxvlZ4alVHeTGSk0jkFIjqHwh1/IhzUA9ZVQlhyqbMHKfX+03XyfngSGODQXA5N/2YhB/BTsCyhoKeu/SnH3SIED4pwlIImA35cmlwIxt0f7XDdozeHUCFSHksyZUndIrwKtmN+N/svjPN6OQvvKQwfcffefBT+NR1gzj9iKNB7b2+CpKUkLg0b2opbRg2bo3jfrfJK4Qd55IOUE0JKG0nUuDxbkwkKElUvyOVo6OY6mxLADjiVMeI39h+wKdhYaIR+2EvgGCUOIJuaIA/UbaL9PUcDANZtjmBK/5IvvDFRptp17e47xw7cCYOYGHNXxz34e90HvwrZ3YdQpqj7aJbsJoI9nNoGrIb4jMp3h/OCUVZqq8a2YnHqJ9fySFOYu85vXc1KzLM9Qnirlmm4X+kBdhbTc473S+xWSPZVY30/AbTpltHsPAleggJ2oSIZ+TwcmKUw7LmqA
 3VXBRevj
 qLquEZTMb8nUxouYuPTVaA0VeCEzQAdmNgADKuow9KP4mRAs5nb05SmATa0et8Qw5FjJpFNXi/klPQaN+iytnTPIRU6gDApwMl/6s9LzvQWyPUhdeW+WNO0cNFCRDqF4xwEGWntygVm9VL2HnyLu23jOFPWhiBGIV0iW9gEb6nIIDXSZ0GyGE2lO8dVg/2ObnkHAW4P3cRompwVXxfXHoXoDpL8EG3PBbLSV/G44nWDktLXw76g2yrLJXp7u1xTQ/5dTCs1bPaGhfaSvAZM2cA86Gm7bSAFDXer4of9sa2s1KXRFs499ZFZIEMDme0BqBkx5r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/13 11:34, Muchun Song wrote:
> Hi,
> 
> This v2 is based on the mm-new branch at commit daed51c91051.
> 
> This series is split out from the earlier, larger series
> "mm: Generalize HVO for HugeTLB and device DAX" [1]. That series
> generalized vmemmap optimization across HugeTLB and device DAX. One
> remaining piece is the separate compound struct page initialization used
> by boot-time gigantic HugeTLB pages and compound ZONE_DEVICE ranges.
> 
> This v2 also folds in Li Zhe's two-patch series, using that series' v2
> as the integration point [2]. Those patches add
> memmap_init_page_from_template() and use it to reduce bootmem HugeTLB
> tail struct page initialization overhead. The surrounding patches in
> this queue are adjusted to build on that helper directly, so the merged
> series keeps one template-copy helper and then shares frozen compound
> page initialization between ZONE_DEVICE and HugeTLB.
> 
> The first two patches are the merged prerequisite series. The next four
> patches make the generic memmap initialization code suitable for
> sharing. They add zone-consistency verification to template copies,
> factor the PFN-independent page state, simplify the ZONE_DEVICE template
> setup, and introduce a helper for initializing frozen compound pages.
> 
> The HugeTLB patches then make boot-time gigantic HugeTLB initialization
> rely on the common frozen compound-page helper. The following small
> cleanups make now-local helpers static. The final three patches move
> early-reserved CMA pageblock setup into cma_activate_area() and then move
> MIGRATE_MOVABLE pageblock initialization into the shared memmap helpers.
> 
> After this series, boot-time HugeTLB and compound ZONE_DEVICE ranges,
> including device DAX, use the same helpers for frozen compound-page and
> pageblock initialization.
> 
> [1] https://lore.kernel.org/20260513130542.35604-1-songmuchun@bytedance.com/
> [2] https://lore.kernel.org/20261112112816.55095-1-lizhe.67@bytedance.com/
> 
> v2:
> - Fold in Li Zhe's memmap template helper series, based on its v2 [2].

Nit: actually, the link [2] points to Li Zhe's v3, while this says v2 :)

