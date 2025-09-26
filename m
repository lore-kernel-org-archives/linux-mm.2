Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14752CAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 13:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C9798E0008; Fri, 26 Sep 2025 09:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1C58E0001; Fri, 26 Sep 2025 09:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B77B8E0008; Fri, 26 Sep 2025 09:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 07ED58E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:48:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA5401A06AD
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:48:31 +0000 (UTC)
X-FDA: 83931531222.22.02DF61F
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5BD7614000B
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:48:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758894509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nHAzyB1ExayqfB1KvLcMUJ+iJCBNjh2z3jpPxeZ8LlU=;
	b=THeccEtqsPJZmucc0jQMMbz/huwDpSch/bMA8GuliAk3vV/z3aHAC1wK28Hvn6T9AStZ7j
	FkyVRQ4EFOmdO4WcsPiqxKCZmXiKZ4EJze4DGzsEQ29Rtm5ZxkLitwLSexzXhq4vlIUiJN
	3dXsFAyt0mxGuVkhn5eq4Lt6UF3b+V4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758894509; a=rsa-sha256;
	cv=none;
	b=av1xSENp4kjN2AkWMOvvPXwMJB6oR6Xzrs2TDb1iV4Gyyu43CgobAX+uxLgDqt1bMOy5FE
	F952AVUS/J1JN/Fa/Qfe+6NnvjbF/RHaOvBaqqrxoS/07E/svsVlNT/pgI/GfZ8agJXBLp
	OtSG9PXEeR1Ca2KeXY5PLRD1TLf/2sM=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4cYBkM2mswz9sTk;
	Fri, 26 Sep 2025 15:48:27 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5Q3lMEydGwPm; Fri, 26 Sep 2025 15:48:27 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4cYBkM1Y8Xz9sTh;
	Fri, 26 Sep 2025 15:48:27 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 2435C8B77A;
	Fri, 26 Sep 2025 15:48:27 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id iuKruXyQLJPN; Fri, 26 Sep 2025 15:48:27 +0200 (CEST)
Received: from [192.168.202.221] (unknown [192.168.202.221])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id CF6348B779;
	Fri, 26 Sep 2025 15:48:25 +0200 (CEST)
Message-ID: <3a1e75dd-6b39-4506-b4d7-806915d2a6fa@csgroup.eu>
Date: Fri, 26 Sep 2025 15:48:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/numa_emulation: Move the size calculation in
 split_nodes_interleave() to a separate function
To: pratyush.brahma@oss.qualcomm.com,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250926-numa-emu-v1-0-714f2691bf8b@oss.qualcomm.com>
 <20250926-numa-emu-v1-2-714f2691bf8b@oss.qualcomm.com>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <20250926-numa-emu-v1-2-714f2691bf8b@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5BD7614000B
X-Stat-Signature: 7ke6bnc1npyj1igm33nbtp75jjkyr4e5
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758894509-516683
X-HE-Meta: U2FsdGVkX1/nfUyMtRASu06puyEG7p9VDV6LdIxgDtC8AFtrW0k6C6O+nIR/cDWN7hJoNI3tIV3TfIUUy2OUSpDai2iRkpmv9qhWOgw9Xg4otrcqEefYX789VKKYltwHJ2GOAEm093myUijgllpwr4XwlEFxOX2Qeww2upZDZZ0up4ocsMvlr3xXraVRfFvPJ7ZFZMQf9jBQLSQcC7WkEnVKoJ9JdllEP9+OthGesLm8ofZXHnCFMk6kPdX2aoL9ngAijk18TL19Mof5yC7s5rAnLtvIo9jtiO+6IVLWqZDkGppZd48iqE+cGeHtesPLITBVUyqYksKLoiSWWcOed0M8G7l9qKiQ406MaeesJKk6e+C4KYspYrVQlqqnzLDZjMKN+IGf4ysWGB2YTTno7ar4igc6sJFGso816sroyo+cBy+nfK7sR8KIs9DDhyVo8gIlACZE3c/Zxtgmc4vHC3vj6CCQdugmv+ycWfkFPMCaloFck8aAihuEdjOwAkbAB7euPlg3CsIQbvpFMjPcwbdP/b25FTh34A6hjzENNC3ey9t0PgTFIkCwurB+e86jL69em6+U0zkFAtRqf+ijMp3hsh8NsX01KI5zVt/A5X7ytWn0hMYGjD2mrnE+z3uYb5qx9zwx8P2nR+I6LUOPvHlgT9MRcvVhktP+1rvgD6Je9rdT22fB39PaxS3JnWaD/eDA/yMt/uNruioUlJqqUFg16pAMpqnQKwMoTbTnHLb2mQb3K4zQf3fG9OJf7Lk2kJcXNBAK5RwXvss7q2cRUP1tl4SjcXfJlpwBTm78TihYiSXW9oS6lIdLvB/NJe9W62RVcjsGHsPlCBDt0bbBXgcGSeGugQvowVTZZfOHyieaRG/jNrS/f1KZGJPh4KhTNx4JNZ7qRcNaNa5vvF2iM1E+nX1AaMOTkPIcer2MjYBEmp5aZRigTv43JX7HplyvjEDiByWkVe8C5QDFgIs
 5cI/fCiC
 ccTsNnawJwXJ+u2NuOXEIITvlyW9ghccvBlh41ndKJ9gXcGuiJExsHja2EDOaI+KiPDRAU5KINcT0SjtbsDVEYxeHHJeN/qCpooKCpPb7YUNnqOrD7/SmRA9m1n85NoOpzsaNiQVsGjnI86grUoV3vdrS8a4FqsIH9lxbfS6Q/8NvIKAnaixjO/8w63UaMiMJTgf7TMn5quKRv7SvBNLRwNY4Re2c2foak1nOcmgynbq+7vYkl1XGsf54SnjgeralIZN5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 26/09/2025 à 12:34, pratyush.brahma@oss.qualcomm.com a écrit :
> From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> 
> The size calculation in split_nodes_interleave() has several nuances.
> Move it to a separate function to improve code modularity and
> simplify the readability of split_nodes_interleave().
> 
> Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> ---
>   mm/numa_emulation.c | 44 +++++++++++++++++++++++++++++---------------
>   1 file changed, 29 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> index 2a335b3dd46a..882c349c2a0f 100644
> --- a/mm/numa_emulation.c
> +++ b/mm/numa_emulation.c
> @@ -76,6 +76,34 @@ static int __init emu_setup_memblk(struct numa_meminfo *ei,
>   	return 0;
>   }
>   
> +static void __init __calc_split_params(u64 addr, u64 max_addr,
> +		int nr_nodes, u64 *psize, int *pbig)
> +{
> +	u64 size, usable_size;
> +	int big;
> +
> +	/* total usable memory (skip holes) */
> +	usable_size  = max_addr - addr - mem_hole_size(addr, max_addr);
> +
> +	/*
> +	 * Calculate target node size.  x86_32 freaks on __udivdi3() so do
> +	 * the division in ulong number of pages and convert back.
> +	 */
> +	size = PFN_PHYS((unsigned long)(usable_size >> PAGE_SHIFT) / nr_nodes);
> +
> +	/*
> +	 * Calculate the number of big nodes that can be allocated as a result
> +	 * of consolidating the remainder.
> +	 */
> +	big = ((size & (FAKE_NODE_MIN_SIZE - 1UL)) * nr_nodes) / FAKE_NODE_MIN_SIZE;
> +
> +	/* Align the base size down to the minimum granularity */
> +	size = ALIGN_DOWN(size, FAKE_NODE_MIN_SIZE);
> +
> +	*psize = size;
> +	*pbig  = big;

Having to return simple type values through pointers is usually the 
start of proplems.Whenever possible you shouldn't returning simple types 
via pointers.

Your function is void, it could return size instead.

And big seems independant, could be returned by another function.

> +}
> +
>   /*
>    * Sets up nr_nodes fake nodes interleaved over physical nodes ranging from addr
>    * to max_addr.
> @@ -100,21 +128,7 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
>   		nr_nodes = MAX_NUMNODES;
>   	}
>   
> -	/*
> -	 * Calculate target node size.  x86_32 freaks on __udivdi3() so do
> -	 * the division in ulong number of pages and convert back.
> -	 */
> -	size = max_addr - addr - mem_hole_size(addr, max_addr);
> -	size = PFN_PHYS((unsigned long)(size >> PAGE_SHIFT) / nr_nodes);
> -
> -	/*
> -	 * Calculate the number of big nodes that can be allocated as a result
> -	 * of consolidating the remainder.
> -	 */
> -	big = ((size & (FAKE_NODE_MIN_SIZE - 1UL)) * nr_nodes) /
> -		FAKE_NODE_MIN_SIZE;
> -
> -	size = ALIGN_DOWN(size, FAKE_NODE_MIN_SIZE);
> +	__calc_split_params(addr, max_addr, nr_nodes, &size, &big);
>   	if (!size) {
>   		pr_err("Not enough memory for each node.  "
>   			"NUMA emulation disabled.\n");
> 


