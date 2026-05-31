Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7119CD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 07:19:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3BD46B010B; Sun, 31 May 2026 03:19:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6046B010C; Sun, 31 May 2026 03:19:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8DB66B010D; Sun, 31 May 2026 03:19:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C20D76B010B
	for <linux-mm@kvack.org>; Sun, 31 May 2026 03:19:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5655A1C06D9
	for <linux-mm@kvack.org>; Sun, 31 May 2026 07:19:24 +0000 (UTC)
X-FDA: 84826864248.28.DF4722F
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8B2D1140006
	for <linux-mm@kvack.org>; Sun, 31 May 2026 07:19:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="OKYxp2/e";
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780211962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UgyOMSo1NQT9NR/s9Gmh5C++kaNJthsUpAzUGUjKh8k=;
	b=1YrOKIhGkQalA86E0jo9RrgzQekMU2rOtdraWYERGT/pTRsX24OUDqyi6Gp5iciPVRHWf1
	WGoIdCsHakn8Zv424dqBzlt4X3VhG2/+3gzm9keIbRbbG5nkU3ILJwjoQDu+s02A5PwHFX
	ES/YThyy4Lv3qIe0J/2C+0T4/OWmwn0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="OKYxp2/e";
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780211962; a=rsa-sha256;
	cv=none;
	b=yO3bYkN0/0/vFXWUSVJ6SJSS4AHB4J1Zi250MIYUDXStoKfUpx8IM3A2PtUuKFt8yVy3wi
	OKj+9Rawv5SVdEGTDTCoDEOAuPS65EaS6eYno/Jmgp6YXhvRNY8ICN+ZlN/W1kURxjIabL
	Fxt8uYia4zFa9QAxB+XG7mTBGVcRbcs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780211958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UgyOMSo1NQT9NR/s9Gmh5C++kaNJthsUpAzUGUjKh8k=;
	b=OKYxp2/euq94yW/BPlLJPwdiYfRQcuT145cwocxP1tMXDQnxVH8DFOnodfv1FPZXMlXLCc
	kRTYcgDt2gUggNPJiWjwTB5Smh2j0coJATntxq/OKgA9TmbAefd+z7fbWApU/qd8xKAYxI
	SMqIEnb+vlsE2yUpzPce/xXrgmk12Tc=
From: Lance Yang <lance.yang@linux.dev>
To: npache@redhat.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP collapse support
Date: Sun, 31 May 2026 15:18:45 +0800
Message-Id: <20260531071845.10875-1-lance.yang@linux.dev>
In-Reply-To: <20260522150009.121603-12-npache@redhat.com>
References: <20260522150009.121603-12-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 68bds6qyi1mxxx8n3hqt41s9k4tht1qb
X-Rspamd-Queue-Id: 8B2D1140006
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780211962-612759
X-HE-Meta: U2FsdGVkX19jMiJfXLiNL0AeC7jm5XE7Hx1gIAusv/U2dbQsoP9y8U1JzaJkz3g/IbI6Pm8F2j9XhIzbZnkIi4GAeUpEg0YyzsBF2VUB+DidGprBlUlEXqvGKcvwm1vO3FNwhL+8X4gKIQ2BMnRRfU8BLnivuF6SJHcp7hKJUNvBiRcndzEpM5Am47VQS91RjDPHPXlmaTGv3OUUyg8FdoSDvr8ImzGUTViJ5O2gwxdDZC5u7Tub3DFPO4T78egq3OjGdcjjJOgQvlB/NuSVn5ZjoEF8VmHQkoDufJd6vYvin+zwmoVYLny8yqxNnZ7B8235cXslJ+dMHMBdkTrPFVzDru2PWn5czoobxDEuVT+cTzarU4kerrybFjO/3l3DXAulnM7P/9kEpBcyBdcUw51uYHbX5flkNLm5StyMvjBN/JAugq07jKxFjeJpeAMQlIaHAIptWKRxqQjFC3HBP/bMLJCUr4+hYyOlFSaPZgrqBwRJdm7Msj/J3P909Lm0/EbYux3YC6heiirguj8uQGFgADB5OHCIo8417JVoMKJGSZ6pIRSf91v7u5NYsXI1y1dxSmcfRpje5uX4KoWurBDZ7R5ro6whLZOsrojTKm64BDF5NDTQ0ZD78p5wU3mpu2njOcdPJHm1A7NGk++jDAo0P6jC0f+zTqXkpLpFIDLUDp3td5Fe8urf0Y5nCha0ibRmJPfie2kliYrkaojBxi9cgVmhMZFOMpIAbX3q7K7lqEiFJpzy/G/h1/jHJAmRTfAASdQkTqMK2zBgTPg2p1agajgZU6Y2AAc5NMK70i1ox479nlWGRb2R1tQ1clTv1pdSGqvb28kGbg6KLWc12+RMLNq+Z35AbzoeGPXM92RZdD2+/YTQynv5kMyD1wjpivIWVowLieCUHK8CisaXElPadd2z/eHlveD3m6EGmJYLrw4whSYH/jgLEX/CCvtJIgHxWYpjveoyW9SiYV7
 /aQyXpZu
 oeufZr+4zYxoTgeyzU6P2wBsGDnVF2bF/ckzgOiCrtMyJVkQmlqYK5A6nGw+X05qe5NAjHSXAe88LgxMstQQTyYlVW8UXDf7e4m0oKj6B8t7+9FYlaV9erwU8V+v/WPjdSdH55RqWs7Pq7j5nuNalY0KJb2K4YoHckVFF3ZutQCTPFOEKnCz2YCfrRC3+FXWRlvwYEKcCA3nq552V0vG1Co15Z7uBmKt5nzLV4O174JE5NVeRRzBdvs8ZuxxqOcXCgOeXzX9TAQyGyQsMWzO5/VLNNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, May 22, 2026 at 09:00:06AM -0600, Nico Pache wrote:
[...]
>@@ -1587,10 +1749,11 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> 	if (result == SCAN_SUCCEED) {
> 		/* collapse_huge_page expects the lock to be dropped before calling */
> 		mmap_read_unlock(mm);
>-		result = collapse_huge_page(mm, start_addr, referenced,
>-					    unmapped, cc, HPAGE_PMD_ORDER);
>-		/* collapse_huge_page will return with the mmap_lock released */
>+		nr_collapsed = mthp_collapse(mm, vma, start_addr, referenced,
>+					     unmapped, cc, enabled_orders);
>+		/* mmap_lock was released above, set lock_dropped */
> 		*lock_dropped = true;
>+		result = nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;

Hmm ... don't we lose the allocation-failure result here?

Previously collapse_scan_pmd() propagated SCAN_ALLOC_HUGE_PAGE_FAIL from
collapse_huge_page(), so khugepaged would call khugepaged_alloc_sleep()
in khugepaged_do_scan().

Now if allocation fails and nr_collapsed stays 0, we just return
SCAN_FAIL. So we won't back off via khugepaged_alloc_sleep() anymore?

Cheers, Lance

