Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A4D60A2604
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 04:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ISnp1hYQ
Received: by kanga.kvack.org (Postfix)
	id D55F96B05B5; Wed, 18 Nov 2026 23:38:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2E906B066F; Wed, 18 Nov 2026 23:38:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C431F6B05C4; Wed, 18 Nov 2026 23:38:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A15606B0680
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:38:53 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 340281C4134
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:38:53 +0000 (UTC)
X-FDA: 85450613346.13.A737A00
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5ECD51A0003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:38:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ISnp1hYQ;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795063131;
	b=cdY42AoKHfmCghdV+EDDO+s5jrgedzdwVmKs2G9OG8GRMX99eg9V19OnszIgBZRaojYLQ7
	hu5OVRBMNp9zmu4+LC9sO6iGqJcndG+vRw+fHbnWQ6wuf7+9Oe0EdDsQasbcSUBstyou2Y
	1apaJekdKMZOpmIgQIGz5jSG/U59b/8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ISnp1hYQ;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795063131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=boV9j9CJiFSO2Y60FsNmlMGCziCduZoOfN17A//Gn10=;
	b=LjzSdDuh/BbkeMH/PNR9cLli/RK52EvjWeCuuJ+R7GCkWxRN9r/1mu/29t+v3OZSR92OWT
	m3xJXMOTJq8C60QxWmDwih59waw+1eLeA9rzk7/PnJqI4Gw3HhNjXtEzEPI9axtHMHWzvl
	SUP3PDX/a9m3H9nJYN0beQfHjVbkFkk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 757EA152B;
	Wed, 18 Nov 2026 20:38:47 -0800 (PST)
Received: from [10.163.128.149] (unknown [10.163.128.149])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD11B3F882;
	Wed, 18 Nov 2026 20:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795063130; bh=EcZiEGeiH3FHAMhxWmsIUo56I3szGrADgPmAMfAcAeM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ISnp1hYQlv1T88o3LSEUjbvpB2fm0RfDcV/gWnHvHLw1Mnw4y+ybPLlqFExeLkarC
	 3r2QYiOR/UBto46mbJFkxBKnE1UzeDMJUTXsgSNB363MOyxftBrBVY/7nslJZbaU7c
	 kbwLjFFbKDVESDn/OfvyHqui9dgqEtdx/E6rzLNQ=
Message-ID: <ac1d1bfd-5305-4292-8905-edd14ad028fa@arm.com>
Date: Thu, 19 Nov 2026 10:08:40 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 5/5] mm: nommu: remove unused heap_stack_gap
To: Shivank Garg <shivankg@amd.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
 <20261117-unused-sym-mm-v2-5-2f845e94dd50@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261117-unused-sym-mm-v2-5-2f845e94dd50@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5ECD51A0003
X-Stat-Signature: gnuheqfs5dhg8ijdwgh3qrf1koygbe1i
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795063131-147190
X-HE-Meta: U2FsdGVkX19JzuL6M59nSB02g4kZdkjmMveN6+CR0qjplyMBkZqAJdOFPWv0yzGu4VMdEEuaidUqXoqYNXo+p3ZC1KRB6mBoav/4LVB7VWZd5uInE6+Oi7rmRnOj8qoXNHkS+JKh44hTvOJ6GCD4jEWBlrnbsTAa2nqiRXmr8TBtWbsS7s3KoehkxTl/YEhH0kEKwUNlkU7wzucbB1Qair1RUd6r7p1pJVStvtgZv0+N6ppp+WD2BWVORnMY/+XzA/E6CSgZ3tkfpMYowmoKUQNjdZe55LW2Glr4Q/HcdiMWXz2af90mUa4Rhe76exN/lES0euMiRAwdbXY0Qsj5sV0hdawPWxu6yLCEqd51C1Ou5DFX6MI2uUe1xBmGSrm5YEwipcVEyMBiFAjjEySDzJ2V/1FUVSa6mKw3WpmmfI9X/QkJfv7g595Qj/2qPJlFCpn6DIE3zvs7AZWQj6/F3hna3b9dT0vCiTCzi0E2gm/l8s7IxliHwAgHiDKwVc2HioGfjzo+T1WcM9uoNWaW6Ss6fc9NqIVae+s8qtd89d8xCHM+xKzF1WT5F+Cvt4dHeRybfYh2TA0G4AuI/lHbf9kNuLc+R4Ryq+fRMUS2Og/9SxsFBMgPHKF+LGixn95q0VSdTTVVwjWciDhQrZEJCNFWwYz41OohVcNGtsOAQTVaGNjIj3ioMXZuHQQDa+paoZR50dDrsuLb8XCTuTzdFq8GU/OyqGNqCb/uUTXQA7KRq2rIKjkQW+RuMybETWgsm2QwMfCJbs1ZJ1HpsNUeOq7zLjv6DbeAUC1ofMCWnizmO3bGZ1nnKAcoDQhHbZVcBFJaJK18RQ9un69XCl0SXPdFh7mQUd+HsxbbyeoHE3Qa9EAQNYbcwMu6xo1rp2zOZ97u0nk1Ia0+y6U+KzOuy+fd5l1cNZMPZWhtyqjBkwR0ZfJtuMqUfwxqp7y97dTxIlQ5uUtBcewq/p7Q7TF
 1vRDSpVE
 WP4HQL2ugYWaLrhqJexSMazOK+9X8HjHbj1l/sor6TEX8sawDsuhRBPyOy6ZvHydW3IpPWqhUcEyWaywdTCsQreStTeB8hvYvpbs1B7CNLu33gFX9CaQQD9l6u/Qobpi0u7jXz5pqZm012zk2d6MyqRqcdeVsXe62FJ4OnXq5znVNtjYc0Zt67bNVfmTCwTbIqSkS7MgFFa8gYJ73kC3PLJoQztBpK6oBnNkaaLZMuQOU6PfQIZwzGnaj/vSz/mLqFOKvwoFsq20BvtjiWUNLWjqugqipeJLi+b48AQSqALA36j5L0eH7ntZL9PxG0AL7B2AeWvPH11qSvAJL0ZrlgqYcFpLvBOPsrwmcCWLTdHwqPrgfjoJwNi6l4vuMJCTyPnLchM6OCrFHL5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 17/11/26 12:46 pm, Shivank Garg wrote:
> heap_stack_gap has been unused since at least the start of git history,
> commit 1da177e4c3f4 ("Linux-2.6.12-rc2").
> 
> Link: https://lore.kernel.org/linux-mm/20140430083620.GA4711@dhcp22.suse.cz/
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/nommu.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/nommu.c b/mm/nommu.c
> index df99495c8902..a971c12f2732 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -43,7 +43,6 @@
>  #include "internal.h"
>  
>  unsigned long highest_memmap_pfn;
> -int heap_stack_gap = 0;
>  
>  atomic_long_t mmap_pages_allocated;
>  
> 


