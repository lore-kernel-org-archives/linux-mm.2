Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3132FD3B7DE
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 11:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FFC76B0005; Mon,  8 Dec 2025 06:02:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D87E6B0007; Mon,  8 Dec 2025 06:02:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615066B0008; Mon,  8 Dec 2025 06:02:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 54ABC6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:02:02 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF760600EF
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:02:01 +0000 (UTC)
X-FDA: 84196014042.05.2A673CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2984C14000D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:01:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ghs95GrY;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765191720; a=rsa-sha256;
	cv=none;
	b=WIdZCRJiitRrbzyCe3hGQ0RdoyFb+J0oa0Rbi+kDB3zqGHfQ/1w7VkU6LauY9PdzIDVN7u
	BFscpqIw9chgdOD1zOXiNqBActJQt6EwCGfe88fOAbs7EYTGnBA8D9jmPZHoaj1FnM9sWo
	WUSb8JnvcK1fTRT609hbBDiuG4+hB2c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765191720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pFh8DpXD28yC7tfeBPL98X7h300UEWaFcuCl/N+wtkI=;
	b=rcuv1lgaOJLDFFpRd0qrOb4yJJYDISF/1409fD+YuYjLyU4Gn+Rh+yNZmF8tl1QEh8zwOk
	2W6bvo8tiqgi3QFaviiWVG9SupoB/5rVQYgIrIj1elbyEsLWdkf70XGV0HWIhKH0JRW/qN
	PUWN/uyt777rEYiCIOySaYwRFeQqu+o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ghs95GrY;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1155D40B6E;
	Mon,  8 Dec 2025 11:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327EDC4CEF1;
	Mon,  8 Dec 2025 11:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765191718;
	bh=R/IYT/sJW+5X1kFREBNtpFtBsBV21sa2yHFx+ZlhqgU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ghs95GrY5ScohXYjFvZ3Pct4IVKtbIQFTq16pcDwX0qW1JK1QBau1Eh4h8ro3QLRI
	 Vz6R82+4uv53h+UH3QRrhJB5mpkhVo60A2ypV5I1iR9JCpnv6XrgnmBVoaQtx6t0Ta
	 knH69Qdc29CMD4l9ax37fvZFgvqN/+wT4qDRiFSKNeoPyaem5QpFlDzNboEj81qbmH
	 WsF7g6QNw08rWLujeDvsJVWNi7TpHJIYm+kk55N9KQLCaYuD7mrkg9dZec9HuGXtyh
	 Yt4Hp1p5GtbhjiElQrv/r70VZeUDKIro4myDjeGBfi1ch2sh0BpSY80y8tSes4XpjX
	 ASvRwt7YDTwxA==
Message-ID: <246da543-58a9-4b61-8c88-5ceaca9dc12a@kernel.org>
Date: Mon, 8 Dec 2025 12:01:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] mm/hugetlb: fix hugetlb_pmd_shared()
To: Lance Yang <ioworker0@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 aneesh.kumar@kernel.org, arnd@arndb.de, harry.yoo@oracle.com,
 jannh@google.com, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, liushixin2@huawei.com, loberman@redhat.com,
 lorenzo.stoakes@oracle.com, muchun.song@linux.dev, nadav.amit@gmail.com,
 npiggin@gmail.com, osalvador@suse.de, peterz@infradead.org,
 pfalcato@suse.de, prakash.sangappa@oracle.com, riel@surriel.com,
 stable@vger.kernel.org, vbabka@suse.cz, will@kernel.org,
 Lance Yang <lance.yang@linux.dev>
References: <20251205213558.2980480-2-david@kernel.org>
 <20251208023231.1257-1-ioworker0@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251208023231.1257-1-ioworker0@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2984C14000D
X-Stat-Signature: oi6akp5nnot9y4id8gfrf6hmy77ji63j
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765191719-43325
X-HE-Meta: U2FsdGVkX19crVf3IZ/sJcewRk8BL2DbZ5N3B2V5JjuSzYO1/d/cuJJAAf29g4cR81Dj6faax95CJWlqJJvybgOgWWCLRKm9fv0C+5UWLa5/25stOI1O5SHn1RQ9URvDmzO/QjnwQbvgzKVzjTRC5Ap0/7MrQH8bjAbkzuxooiAqPbPIy/MdosIb5hm3aLkBxOfa+7qTr5dshCC7bZqY0SaT6ThRcO9awdrD3ZUaOP3e+Vn1dM4sy4+suYBewoNjdsCfxTcVMwv29rvR3He3pBIlH+SU4TYoaZu6CARUtMfgV4XatfybdRhNbQUCESssYDDVmjC9m5cBI7X1s/uw7c/0LW17IkFmmpL2RLdSyBS86dfiVO6B+kyhsfGoxl2YPpLKtRsgy5VBHbsIY6u2MjFTFEuU1oswXjgKI/Mdm8UDxI6Uch2guPi80WKidM2sPP2UxaoxQxSGFz51STUrFS3IYm5Ehtu7dhbGOx9py5NiwamY3kIohUosIUma5MdH0YUq1ezLYhj/6kWE8jUj92bOq1hSMGD9Yw6uw/E710lhaz6fqkj1O7xyzm2xpxOaYwJn4Tqzk/bzwhpnbA6CtvgKTYjHIJCa+Se4KxrVHkqTqnPP+V6EMz7cmhURdpW309bgv7/fQfE4ZiDp5kD4ZuT/JiBJomi6CsnDGWtchF9QlGQJxqFb8jtyN4TcdvjYAx8EMV1xNqJCB4uVYOqrp6FnGrzdVW8EF86rHYFBeh87R4ItYqNHFD++qr1cNZAsgkgsWH+bUmCUVOuOYah48owCXOdSfM3jYeM6m1dybR9iLzgadKNHVfFBlDV5lIdjHZ6ikr/TGwyTQbU4G7n2zEGR2sxG/40aVWHVUpLsEjRfpEA2RdDfE2erzHF5mR6dn74Iv3uD4CBDYudb2oI7d1id9pObE2MDdZttsKSAUOAIiD+n/z5kswtJrCXMjrLX2IspSoaHFypbOEBiz85
 V6yO5pKd
 zZr2yC2IPneesqcW2YrdWWhIoL+qDazfEriLBfMtsBR9c5k4SO9pDHXplgdzoMzwfeVFUhlFHLInFmM3mTbhJ3pdSQycl/zxCyRbmQx/NJP5d4HLVflHyaTCCdHBF0ad8p05/E2A15GsPRreT+9ErHuSsLOObBh0EDvliZDTls4cbBj1i+3yXsUPo0OH8MHllNr8G24usm1wB9aJRsdSEkMtKw0aKng9dC8yrc86fMAAT/26gPXKkqyVpAOIT0JNbWrsgwDoEDycWmEnii4cBP92v0qzYBrnrs6bzrx/nXkLVvHAVSbFK3FHc1kOduBxi4aZjr3kxvd1ngTIHksWZCPzBit9tnNVeb9qIPkjPjV2V7JCHp6e8CPxZ3rOJQqFy2hSOnIEcU6DojzXtnKLzufVuyHkDvym39LsvAz1q1gUwmCc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/8/25 03:32, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> 
> On Fri,  5 Dec 2025 22:35:55 +0100, David Hildenbrand (Red Hat) wrote:
>> We switched from (wrongly) using the page count to an independent
>> shared count. Now, shared page tables have a refcount of 1 (excluding
>> speculative references) and instead use ptdesc->pt_share_count to
>> identify sharing.
>>
>> We didn't convert hugetlb_pmd_shared(), so right now, we would never
>> detect a shared PMD table as such, because sharing/unsharing no longer
>> touches the refcount of a PMD table.
>>
>> Page migration, like mbind() or migrate_pages() would allow for migrating
>> folios mapped into such shared PMD tables, even though the folios are
>> not exclusive. In smaps we would account them as "private" although they
>> are "shared", and we would be wrongly setting the PM_MMAP_EXCLUSIVE in the
>> pagemap interface.
>>
>> Fix it by properly using ptdesc_pmd_is_shared() in hugetlb_pmd_shared().
>>
>> Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
>> Cc: <stable@vger.kernel.org>
>> Cc: Liu Shixin <liushixin2@huawei.com>
>> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> ---
> 
> Tested on x86 with two independent processes sharing a 1GiB hugetlbfs file
> (aligned a 1GiB boundary).
> 
> Before the fix, even though PMD sharing worked (pt_share_count=1),
> hugetlb_pmd_shared() returned false because page_count() was still 1,
> causing smaps to report it as "Private" and pagemap to set it
> PM_MMAP_EXCLUSIVE incorrectly :(
> 
> After the fix, hugetlb_pmd_shared() correctly detects the sharing, smaps
> reports it as "Shared", and PM_MMAP_EXCLUSIVE is cleared ;)
> 
> Tested-by: Lance Yang <lance.yang@linux.dev>

Thanks a lot Lance for the testing and thanks to everybody for the review!

-- 
Cheers

David

