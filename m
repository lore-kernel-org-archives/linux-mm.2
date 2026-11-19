Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D0B9606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 04:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fzsy+AgW
Received: by kanga.kvack.org (Postfix)
	id 83FB46B067B; Wed, 18 Nov 2026 23:32:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F0356B067C; Wed, 18 Nov 2026 23:32:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DEC86B067D; Wed, 18 Nov 2026 23:32:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7906B067B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:32:24 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4BCA120949
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:32:23 +0000 (UTC)
X-FDA: 85450596966.06.579F02B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id E8C7E40004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:32:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fzsy+AgW;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795062742;
	b=HulXPUDJI1Nv9HEqrF6tNV5vFrQTVWbuJyuKSMRG+OUc2UnMbDCHbe6a3/+uQtuGO5Tv1G
	K7P4liEROwvdWMGfHYbY1UaYivMF96keusGVs9Qw/mb6sGgBpM96T/fzYSkFD9qkHO3GZ9
	nM/Ok4GkfTT/0hSXTYrSwP0flnJ6LR8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795062742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=771EE4Y01/Bz+vrcmL8YA+yAmlZjomzAQG5AFXGOp+Q=;
	b=iYqT9BcGVECcPOVetvRkeWT6GgADSxnGrv54PF3MW1YIyoWC74AY6oKuCCfIL0/Jbvo6fx
	YCHE2mj0QyxLELFzfiaGw2Z8MgYaAr9OlSbVzqXvDsID3DI6v0JoBrcGDQGdPxpbizke2c
	dIGKx8Q07Nb5n16Rh3lSe54IMnMDO0Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fzsy+AgW;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E5381477;
	Wed, 18 Nov 2026 20:32:18 -0800 (PST)
Received: from [10.163.128.149] (unknown [10.163.128.149])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AFF553F882;
	Wed, 18 Nov 2026 20:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795062741; bh=pyvnNs/u4c2sdesFangcHufEcUQlfeZ1CpbXhit+XHs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fzsy+AgW3SDfZ0T0gM78vrOJ5nYrWP9ALoqZBJH7YjoQMr68ffveYDzvqH6WTFATW
	 bDvZZx2xiTVm1fM5PvT0skiHbtN6F09EMzldAEV6yvJYxuT+ee+rRh4lnOi9IABqWB
	 zqRT2hnsXawMzwcaiiZhUVin69lHALHSjOfshA7M=
Message-ID: <9a813531-3489-473a-82b3-78cc8babc27d@arm.com>
Date: Thu, 19 Nov 2026 10:02:11 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 2/5] mm/swapops: remove unused
 make_guard_swp_entry()
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
 <20261117-unused-sym-mm-v2-2-2f845e94dd50@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261117-unused-sym-mm-v2-2-2f845e94dd50@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E8C7E40004
X-Rspam-User:
X-Stat-Signature: e3an4p34eckdcfpy6drb7bhsy7jjfqxi
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795062741-296214
X-HE-Meta: U2FsdGVkX18INgtygm0h0M/w7s9Z6hb2+dG2a6p79yn+aZaQvvLSUX82Pij+mBkawRAOKQbaoVYwZ2sW5nIFUFeqAW6BcmbEfcDPhqpi0To0hB187HZssQvk2ZKMQi1qZmEK4jECdcyUABAyeX2OqgfYAt7rArsEdxtv0L+XyTpMHdO+yMSSf9ziN4hPdfJh+d+9ls3W2ejnMBCWzNIr8O16MTA0rV+2L2Nmk0lxiCFZbDoaLqViTTcIyiSyKmOh9tHzXim7vL92LcoQLmMdfniaWdwuCgUEyAZtMXdSplXszFVXwYgAV511F8LtvufD4l24IW72BuqT3w5fLf6iFUsuvw33Wx2WHQLERVFfExO8IR3q/tTvu/Gd8U7Uon+Kog68f5ETbZQKDyCw5S+2nljyTW5TpLiuIEjheYGVYWCIUcbNiwZkHTThYJ2KSVUtSEfoTd4qp/Y9qg07GIpwpEaX8zXIPd3rV/uLMoBg0wMunEZCX7vEvqf8SBYWmnch71aK3WdlkSH6JKcvRdp11aRlCPO0yKWnWuaIaebNyPP35jxlNGdvM0cotQ/sHWDUFcQW/iCF0XjqPoYWxPKHtrZpCGSNhE+S5EuEYwdxLo/9AhZ8i8tLdQYb/H/D45NynBDHMQ2wQv0kMa3OeiYFDl48o0zI2vlQFdhbKGz2S72IDfWbFlBFve7bs5I+8ideGzbeHjK5hIfSQ6A1TOlje6kDqrXIetAXZGJq2xQybkDdDNTKmYtfZpk4F6adX1ksMgRjJIzs1r4uwci8XJDTJnXY6qc0rwBvjX4MJ3vnSzPCMSk7e+UamG2wlkAtfgKZYoBxxHg5CNLfzJpj2h1Vsnc7zBLwEGdaEQ5tye27ZR+03kMqdDRjD/3UCWDN1N2tlETa3LV361a+3+MCC2VsEAfSGj8iAoR+v3SfbMztfViFwp1fbloav4GI7d9Ec0mBVYKWYd+9d1Z4L+CwwHj
 vlOoKfYm
 GZc+f2Kv1iYQmUDnz2gt3GwQZGxqWnFgzYCY4Edu6OZjHktxb0fqGZW4XlKSdTiB7uxP1S96c7+V6XjXDTb7zClH9sH+wEoIqtd06hjz+4bgpiv2q8KYOfbBVy+y7Btw+mJgF6LF660i4tsLjFW7djRWt3qLEMqVhOJw9sMExBMRzDFpHajDB0vtLA2BqapsUu/uSnU8WvYVgqQ4hxgyLD9CRTz7e3c3i8rytak6E8wuWfqrxa8VpRket8ewG8K/VB4N48cistOR7J9MM1+8peOl3TqjVokgvPFKY1kpmdPL1ypxegkhsdMHyRswAuHp09NNYzoYVhiOrdCnH6+iHsPVo1/mH0s52ulMbhyOjVAGzhROymzvCFnT1V+DqmkzleJSOJbBHo7/pOhPG94q/8baXSVY6i83ApBXogI3yAQeUecQtZAuQ+IiAkiEQA5zgu1b2J71Vt42RGwMBHYj128yl4mlYm+KHFch78L26K6PnJ0nZYdUF9kHzTfH1CE4vkpG2cD9rtan5mJY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 17/11/26 12:46 pm, Shivank Garg wrote:
> make_guard_swp_entry() has no callers.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

With the commit message improved:

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  include/linux/swapops.h | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
> index 603f9e3f909c..6f62fc3c8cfa 100644
> --- a/include/linux/swapops.h
> +++ b/include/linux/swapops.h
> @@ -306,11 +306,6 @@ static inline swp_entry_t make_poisoned_swp_entry(void)
>  	return make_pte_marker_entry(PTE_MARKER_POISONED);
>  }
>  
> -static inline swp_entry_t make_guard_swp_entry(void)
> -{
> -	return make_pte_marker_entry(PTE_MARKER_GUARD);
> -}
> -
>  struct page_vma_mapped_walk;
>  
>  #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
> 


