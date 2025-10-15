Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE9CCCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 09:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7DC8E0017; Wed, 15 Oct 2025 05:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79FBA8E0002; Wed, 15 Oct 2025 05:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DCC08E0017; Wed, 15 Oct 2025 05:37:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B00C8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:37:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02B3A13C1EE
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:37:37 +0000 (UTC)
X-FDA: 83999846196.10.0BA5416
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 10F9A40008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:37:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iCFsb2rz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760521056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pn+PfUTaOErMrK4kmS5h/pJ01lIUFvcqGW1ChJWqgVQ=;
	b=kMhyBvqVopM/GwTFULA+RxEevoT5dCllMvhhTSsa+cTU1Z6SQhSXucOrIxCyrpLU2jmAgP
	1Jk8DSaixCPw9MK4qcnQyZKv87VArXuVkpv1wRBveAGGwmi2SOC4SwABTud9G9ebaLPRQY
	8Fea/9NGuiddEVcYVuPf/LKOTpwYk4A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760521056; a=rsa-sha256;
	cv=none;
	b=PPkA3pDuINCDI34betIbglbsrDfiPRADuH/0cMcqQi0BhRvLMlfPFinBi4N1yIXlgZcKey
	x3NKXNTmtekGDDf2Rmz8/Fs1aii+khjf+SQgf5Ez43qYtOPcuoYon9Q4UvRDLma3/0VdGv
	2P2GT5mG5aaxd9s0uhxxhEkNV0IJC5w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iCFsb2rz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
Message-ID: <8ccabf86-c194-48c1-9fa3-c7515742d63c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760521054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pn+PfUTaOErMrK4kmS5h/pJ01lIUFvcqGW1ChJWqgVQ=;
	b=iCFsb2rzBiWmerRPA6GOPsTAqKJCocKV2LmT4gTxHosP8QEbp3U9BE/jto+j0O9UfVinQP
	7qCesKpiU1DD/Pj6VOu9tmup59QIMtDzO3nSateHX9A9VJdu8h/aiMV3iQBvt1lpqOHeYj
	rC7+m0PonyxdJtGj04Jqvv9xzTEa1Cs=
Date: Wed, 15 Oct 2025 17:37:22 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] tools/mm: use <stdbool.h> in page_owner_sort.c
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251015085843.104443-1-ye.liu@linux.dev>
 <cdd96bd2-f759-4637-b61e-c77fcd9a24c5@arm.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <cdd96bd2-f759-4637-b61e-c77fcd9a24c5@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 10F9A40008
X-Rspamd-Server: rspam02
X-Stat-Signature: try793o1qy9gm3x7ciby5o4ogyfyyu75
X-HE-Tag: 1760521055-176405
X-HE-Meta: U2FsdGVkX19qnhS3w/5E8UPtzvrQE9aB5hXifBgKf3gDaaWq3VF2SLlaC34tkcKu3DVQgRtPu0d/KYRmb3tg3vn3qw6FRt1N01DNANzhxWevXH5VUKFyhgQ56Z6IhPi84299Ac2CIFK3L7YlySP5XcMH2Zlv9UKOwDhTGnlGN5nyAqOvRZdBcCBcqkTC8mOoGfwLfL5qrhrd6AZPQkXHxx8uUc70Cr3QHZBOLVEzADiLEQhHmm5wpoRjBlhcEsvVAPxbSMsycMuVduhsybcBL3Uv9d4LZ2m3lDboBmnuj7IvMIqgNyY/w/1fheRzdreumjNR6PWiwQcJzCJODh9fYMIzVf15NXz2KTaUFK4QZafk3KlI9cGq5sxhPsWjrG4aZThswylMoBCYQXUrIhla2XZKzTObw6iWs0uoPz2lyp9aU/p1c1pLlNLe4ej8HPaGH36RRCwF8ceHzunJuiTDKIDsT/dKh9/Sou0C7s7sR4wstR2K7kWSwJiOe4isvGWsX/IvofCH5lJB9lfIoefHGO2ZB0Da7DEtz3PhWtV4tePRNgcqFpDI0oxpHC1bVqRiB5lXzwvyPJdS+aaQz/wadMsxZTwFp8BGic0YFHozcXgzNUv+C7ikrOQZZWuYBDvXOknNhYBSUQ+sLRms6reSsMAJPuIIpWmmLo/VQlehfhKPN5vx/eeMGcQu8k1gB5sDLrhu6EGADV5+Y9NRy1w2h2C5Hm9qR4OPobaQuQr0c0aNysbD8Ioul1quVFE/TbmNj+kn8liK7jSzMG9Nr3noOWhd8KSIeuiWDoSigMIUhqyF4g0j2u4bmsFU3yGBbHJDy+QSymcBPMhqjDdMIolQ2h+QKbwD+rMH4oaE/sXeiOuDgkg/BRiaTfreQje5Dm1f3LGrJUlAehZa/iDXX86t8kh6cFJkag/8Oq9U+GStGdEZhw3ulPoKq3CvHnc3BVZFJCwEkIfRErZe9TrO7LS
 +QeMDk1X
 aMtFudt0/Jsxn9i4jWb9oQIwSoXK/oXtlUpb/z8glJvQT6tgAcxRXgKTmWHLieFnqeAvJRqyEySYjj2uBoPMoXuVsSbQslN6ZNTiKUqYLFerNsL/njtTrET5NfmDIFaBzP4YhvPVYbEfCU74UOMdAonjjY5mvhqgQE1BEdcxklX1fks0c+IFEbYxLyCXBMCEarQ7mtHEto4DuchT/JXFpSgK1cmjdj0RzPNmtEtl7atXMsg3cyR1xFkO1yNmLhGlF+HjbLpmIjhTg+VXDxytSZ4+ICQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/10/15 17:08, Dev Jain 写道:
> 
> On 15/10/25 2:28 pm, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> Use standard <stdbool.h> instead of manually defining bool, true and false.
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
>>   tools/mm/page_owner_sort.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
>> index 880e36df0c11..cbd195d7b5da 100644
>> --- a/tools/mm/page_owner_sort.c
>> +++ b/tools/mm/page_owner_sort.c
>> @@ -13,6 +13,7 @@
>>     #include <stdio.h>
>>   #include <stdlib.h>
>> +#include <stdbool.h>
>>   #include <sys/types.h>
>>   #include <sys/stat.h>
>>   #include <fcntl.h>
>> @@ -23,9 +24,9 @@
>>   #include <linux/types.h>
>>   #include <getopt.h>
>>   -#define bool int
>> -#define true 1
>> -#define false 0
>> +//#define bool int
>> +//#define true 1
>> +//#define false 0
>>   #define TASK_COMM_LEN 16
> 
> You forgot to remove these :)
Oops, you're right — I’ll drop those lines and send a v2.  :)
Thanks!> 
>>     struct block_list {

-- 
Thanks,
Ye Liu


