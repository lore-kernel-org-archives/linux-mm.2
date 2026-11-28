Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5642606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 02:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=SfKvHHDA
Received: by kanga.kvack.org (Postfix)
	id 97DD76B05B0; Fri, 27 Nov 2026 21:58:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D9B6B05B1; Fri, 27 Nov 2026 21:58:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 843BD6B05B2; Fri, 27 Nov 2026 21:58:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58C3E6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 21:58:41 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D3C1805C2
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 02:58:39 +0000 (UTC)
X-FDA: 85483019958.18.19EBC12
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf03.hostedemail.com (Postfix) with ESMTP id 71C3A20004
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 02:58:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SfKvHHDA;
	spf=pass (imf03.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795834717;
	b=AEgwN71kU6GiEZSnfS7boVcRi5B03r21pJBG+lwHvLXOIXNjGsgbiQ+jY6CQSHg0t9KNwR
	5ZAGKHtoraXdluk76l+6NZI35TtPptyYF2qtYph0B3tBRBqWxYBkG4RCfvWaK3PsxTT+2F
	yJbsnA3OQ2mGpWbE+FIQ935SMVob4NE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795834717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXm9bjNklHkCJkXC6cXS/6l9msjPSXzfutfiuU6LTJE=;
	b=d7vDLNQ5LHZ4ehvEqG7Gk+CDi2klv+FoCkKe4dbs0jYBI1JUULXB2tkUZRZ4BAl+1fZGm+
	awRRCttNhGXixkK+mpAFaqaaCOhJnxrqCcB2v9BliKT5A0+CkSmiZN8VgaWSKEQk3Yz5or
	JbWkeKdog3gzbmBvtufm5fkL8XFgn/g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SfKvHHDA;
	spf=pass (imf03.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=iXm9bjNklHkCJkXC6cXS/6l9msjPSXzfutfiuU6LTJE=;
	b=SfKvHHDA5DZy5PHVuUfUp7ZJIYPFO/O1wYHgqxN6U4/eJpLR+3Ela1UpPw9XS8p/TtJJrEZrr
	gDPn1UZB2A8lTM0A3I9jkCqzQxTZVWI0Nmo8f3SKrZ6KPSFo+ihxjnn+PVobzzgk/65BELmIsiR
	LEeIYm+6onwT1S/RxJyVyGY=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jbw1Y64lPzpStH;
	Sat, 28 Nov 2026 10:57:21 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 102B5202E6;
	Sat, 28 Nov 2026 10:58:29 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 28 Nov
 2026 10:58:28 +0800
Message-ID: <ad0126a1-0d5d-47eb-87fd-1df6ccfece02@huawei.com>
Date: Sat, 28 Nov 2026 10:58:27 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 4/8] crash_core: replace for_each_mem_range() with
 for_each_mem_region()
To: Wandun Chen <chenwandun1@gmail.com>, <pjw@kernel.org>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
	<robh@kernel.org>, <baoquan.he@linux.dev>, <rppt@kernel.org>,
	<m.szyprowski@samsung.com>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <saravanak@kernel.org>,
	<akpm@linux-foundation.org>, <pasha.tatashin@soleen.com>,
	<pratyush@kernel.org>, <ruirui.yang@linux.dev>, <robin.murphy@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linux-riscv@lists.infradead.org>,
	<devicetree@vger.kernel.org>, <kexec@lists.infradead.org>,
	<linux-mm@kvack.org>, <iommu@lists.linux.dev>
References: <20261127090723.741253-1-chenwandun1@gmail.com>
 <20261127090723.741253-5-chenwandun1@gmail.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20261127090723.741253-5-chenwandun1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 71C3A20004
X-Rspam-User:
X-Stat-Signature: 7rupb4d3gtzdub1p4ffkh5g37qurugyc
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795834715-986841
X-HE-Meta: U2FsdGVkX185hol/XpRN8/ToRIT2GhHpeARY6tG3XC/NYNxN5TT5RECH4zM9cYhkfuTcsAy8ubISlOpaHbzATeCYpntsGBOiv3FKCQTDpe0fc05zXF2sW/BVWywyLFLIgOhLR43WaNQ4AcDW17IbqL4EIJedeNBSbwM/3XhC4uljV62eA2J+hnSWYqDm8f//WZDVBt0bX2ivdU5AHu8pxXquVhezMzDXXxLFbQ3f9/0TXEylhu7PjuWEYFSrlzWTiNzbCA9i8iMvHYb5Xfq5mocLKBHGLKez+9Q7RCod3RUxMil/m81d4iGqU2+bBjdPN4nBSjNSg5NXVBTl0/5LAmp0oKu+9JBnbo1XMcI/DYmnq4h+8t6Suu6fayizdQNDZdJd8aaJol7VWpRhDCNoihc9gjPKB5fouPZ9zzs7tBayEKdHT/yYdH92YTzC1zJ/qFnETAjqDV1QvpM93iRY9JyHPV/0yxkR7v/qJDXFS+ukWwZtER6/l+SBHdHcvd+doGunlXuzxAfFInIqhMaeVpriN8PgPXhNzyg8NzgAkCr+1lZdrrYKruypXCCwBNtsfSds6HGq7Bc4oBcej3Gn0K2FQ6ywamh32gyECdU1E0rLVsqkzHntE62C+Rq2XLBt/3X4i8jM+/ls2k5xPf94vGo2brwGAlEf/ebPyaR0OBDYYHvV0XE/t4Yx5WzUaYI7XPGWBrDbKo4xc7M4rXO3+tMlLPQ0cprz5UPERQoBs6bBxxFBElv5xe8fs10uED1G52HBlZPvytozXR5J4pR7aSEGLuNp58kbcmo2mNe51OsAeZ02BLzJwJLh8+KPrhzaP+KZcnNg712yYNh0EDdx0US/FqCEZhALmkd/iyxA6r13yygFkctnk/xdAekCYEue/Z1OaMppQ5KUJKes/OlXqK4URQhbEEsV5g8uTpqsrsNhQZ37sLJxIdz0MGFxatiI4ob3eRuD6SJGr13D+pE
 yrH22Zuw
 gJ2U3dJNtSq2GhgY8Onc2aDlKvoZuWaNYMmdnus/yqAv36VVIo0SpC0k921ZQQo0a09KVGTyBrGaBRfIWOCcGllhafMT5/oJXHXc35woGpoc5EpaQJnJRcEahdvqbkaeYEosFAgOSU7GGIGfCSmsAd5m/nR/nU5hTF3TSjfShXitqAddOA+LoAWduZBqhoAGfA2bZk3Lmrhjf7wQhIbpHSUYzcLzeP1CwckIsT0gpRX7B1YoL3LhAHm6FFCg0iIkD3ypUrVlVhrWho0LTpaNQfTNBUhOE3D5qoKnL7Mdd1CgEKqWzCoK/Jgs6DyIdIJlfPBsUEHy3MEQ4eTUP1+SAH3oWeZcODlIIeqlqNdngaE6hi7XQ2IIuYbKwTJyKB6oIIrycIIzFVmEshQUOPDkEn2CvAj+vJqHmwPr/PKTy198QiUF9de5IMNa1vVJRJX9HBFFnYGS8LCtPyrYAbTqxcKtg9pFU2gdzTlbiTGZPYaBcdFBOiyU5hLp9du5jHYouIuDb6bqX0ENyJ3ZZ2AC27MiJqJgUDx8SX6/Y9ZCoKVhMiIwpu1KJy2VuxqaQiOW68hCSAnzpmEchEkKOmQxA/MyuqmDyJK+jRjUbQ7ikFJ1RUIZRrefDq3Z1gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/11/27 17:07, Wandun Chen 写道:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> for_each_mem_range() skips MEMBLOCK_NOMAP regions implicitly. Switch the
> weak defaults to for_each_mem_region(), which exposes struct
> memblock_region and per-region flags, and filter NOMAP regions explicitly
> via the new crash_should_skip_region() helper. This prepares for a
> subsequent patch to extend the skip filter.
> 
> No functional change.
> 
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
> Acked-by: Baoquan He <baoquan.he@linux.dev>
> ---
>  kernel/crash_core.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> index 8a861a946e26..e161c8b65e00 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
> @@ -283,25 +283,34 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
>  }
>  
>  #ifdef CONFIG_ARCH_KEEP_MEMBLOCK
> +/* Exclude NOMAP regions from the vmcore. */
> +static bool crash_should_skip_region(struct memblock_region *reg)
> +{
> +	return memblock_is_nomap(reg);


LGTM
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>

> +}
> +
>  unsigned int __weak arch_get_system_nr_ranges(void)
>  {
>  	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* crashk_res + crashk_low_res, +CMA splits */
> -	phys_addr_t start, end;
> -	u64 i;
> +	struct memblock_region *reg;
>  
> -	for_each_mem_range(i, &start, &end)
> +	for_each_mem_region(reg) {
> +		if (crash_should_skip_region(reg))
> +			continue;
>  		nr_ranges++;
> +	}
>  	return nr_ranges;
>  }
>  
>  int __weak arch_crash_populate_cmem(struct crash_mem *cmem)
>  {
> -	phys_addr_t start, end;
> -	u64 i;
> +	struct memblock_region *reg;
>  
> -	for_each_mem_range(i, &start, &end) {
> -		cmem->ranges[cmem->nr_ranges].start = start;
> -		cmem->ranges[cmem->nr_ranges].end = end - 1;
> +	for_each_mem_region(reg) {
> +		if (crash_should_skip_region(reg))
> +			continue;
> +		cmem->ranges[cmem->nr_ranges].start = reg->base;
> +		cmem->ranges[cmem->nr_ranges].end = reg->base + reg->size - 1;
>  		cmem->nr_ranges++;
>  	}
>  	return 0;


