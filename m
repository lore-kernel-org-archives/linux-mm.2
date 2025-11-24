Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B798FCFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 13:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DF876B0022; Mon, 24 Nov 2025 08:26:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B8626B002C; Mon, 24 Nov 2025 08:26:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F376F6B009E; Mon, 24 Nov 2025 08:26:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCF426B0022
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:26:01 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADD30B8DA1
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:26:01 +0000 (UTC)
X-FDA: 84145573722.17.87DE884
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id E6ED718000C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:25:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CYTjpF4I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763990760; a=rsa-sha256;
	cv=none;
	b=U4YZhFaNCO1z8e7cSVbGXOBgwdB2yOJxhdEZNF5G8lzSVKIOxeNNd9arFToQOQiqutWqWH
	4YZb3lgUlCBxPyuhiC8gDkMwgIKI4ouEq3gwA+5BE7wVUSNjZDbfhNSv1PCDJgMG3P5cH8
	rRcQMwRDKp7a0ZQzcmLedcjB6roCbQU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CYTjpF4I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763990760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VnvBX/XZZCUCV5Tjc3nbVAUiO6caprpKW+yLpMrITTs=;
	b=LTYP38prgsSfvjnARoRZjxj5yT+vIMMEra1biHa9UOcQPTJow+tmJgC4wKH8oGB78kdP5S
	lFk9RqdEDyZY94VysaB45psoj97r3YqhSNnVh/rSe61fFj93g8iCLX4wB/nI5tmM8OUOEL
	h/PXo5TbJS3HkrnIf3jOL98T2rMLtXU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A6D31429DA;
	Mon, 24 Nov 2025 13:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5B3C4CEF1;
	Mon, 24 Nov 2025 13:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763990758;
	bh=V3pNaPV0kKnax3zGGnv1AnsUhY0LbnCFMQ5OaJ21pJ0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=CYTjpF4IqP6zSOrYyA371vjXfNJC7bd00OTA1CE5rpfF6muw17PEE2UxeKCi15eLq
	 PQxSKfXFIgFWxfzPAYgfMtTjyX5g80i197Ya+zrjB7Sw9Cyy+NCIkFgg7jfzi5qcNW
	 b41ni0lnkTl61chQhTW85fIs872WP5c4GTYZzcUuPdAI1GDVpCZrY9uEhS+l5nDImj
	 l0XWnjCK579Po2HYhTBgnPZthYY/E19895OxnfPmAoIi8XVq96ZrczHVKeplcZsaDA
	 USypK0KqHUs4xEfdivciT9uT3FLODj0pbwolLV7dU9zvVaL6JKk6X10jIl6OpLZxVN
	 I1Nmy/oMt9gXA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: ranxiaokai627@163.com,  rppt@kernel.org,  akpm@linux-foundation.org,
  catalin.marinas@arm.com,  changyuanl@google.com,  graf@amazon.com,
  pasha.tatashin@soleen.com,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v3] KHO: Fix boot failure due to kmemleak access to
 non-PRESENT pages
In-Reply-To: <mafs0see3zkug.fsf@kernel.org> (Pratyush Yadav's message of "Mon,
	24 Nov 2025 13:16:55 +0100")
References: <20251124025943.94469-1-ranxiaokai627@163.com>
	<mafs0see3zkug.fsf@kernel.org>
Date: Mon, 24 Nov 2025 14:25:55 +0100
Message-ID: <mafs0ms4bzhng.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E6ED718000C
X-Stat-Signature: ptn57od9dtjo68huokeqf1qmg9w81rrt
X-Rspam-User: 
X-HE-Tag: 1763990759-701509
X-HE-Meta: U2FsdGVkX186+460vjHiOmSLiM0FvSe6FQPxUGmO1JnnPawERPWwLuPyuCD8/1G6v/n5K/5wPJ4F9mfDeueN87qE9ti/ofD4J4HjBal/qtCPtuxgEikkAgM2Y1B/9quJPvJz8z4X8CEesIxdqXH++BLFQsvbHRCx4ITlv/Nf7HBOC/TCcsZyQwL2WVYpWaAdQOvQvDc7/PPLWBFVbnXorVw8TeVEKaztywYeWH6nOYXteuPZz9Ivttlpb3weLC3C1JFJhuOSTmhlPHNqdk1wGVXRjpb5BsEsk7Cx801svZP4BolHaTYOShMQj6AFzaNig0UY8Xq5GmQyonL+pDtdoUOIP6cgTPpWOFBYoHow6R965VZzLl9RVnu4LIStn13L8XISvu4By9RV+kc4Z3K176w3EL8otq27Z36UzbgcRAyFUdvCEAHovRhz/kZfsz/MLwJNPRi7sUb4kv0cBOrVF4iWAQx7WtUhhyfngRG58l31RdxeSJl5aaks2Ml2RrEs0qim3fPWUswXiByc5rIeNmFrk5stjZuWk/v0Yt2KRtMg60rPhrF80/4MPTYoiViOMcbQuE897/pbpYxAT2jT/rxtZ2KCrZPN2kgEK4qPnJkbDJMPM8PehIx0+232uVaL1KjrD1pnSofNFBnnRnUTt2omF9HWDzhRRhJ5P/JzuhhfYQ6MY6MwpAD5IOmp1UDk1MBGkuAcI7BhBDDSaZjh6jEoGu38snN/DrfNvS+O3RtnszdVsgANWKILtJ9QZVzcGWTYsu5dm10tn1B0RdP9654rCf33t0SqZkIjhyfobd8RNz3M2M5J1sQ8djLGqktiOLNx/mWkiWw07fcUj+rNrvSEFhQVBUUY2AvVunzM45Ansg7qNP8uNA9bXhkjaN1QXzGW45yg8jURx0e8/hAFHFevalAvtHj8tZwaSzscavSaGlgQJnJ/bqhmc23UFUuuKO0Zf1hF41t/pZiPnD7
 RjbKtPYL
 FaF3hGU1c//lzyiBdJ3S7EUdXFaA4MWR4POXlF3W2X0c5DDosdXC3X/2z/pfDzxBfqixIBx2HIed//aO5wtFXhWm6oaxhU3dd/mkxa5/YCIG65BYZVf+vmbzBgp29wjgcMxWGgHpwuTfMyqrDOxanR93qFbgGhyi8yCMfINEXqcN+HzqgJ3clOWgVesQhzSeb504FhDeXmebHh0K521Jy0fIJ80G2gj6MXu0loQ1Fy8BC4eCpmAqINJovo+IXd4PQBFWoLAtZgcYrwma5AG0YidlHsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24 2025, Pratyush Yadav wrote:

> On Mon, Nov 24 2025, ranxiaokai627@163.com wrote:
>
>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>>
>> When booting with debug_pagealloc=on while having:
>> CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
>> CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=n
>> the system fails to boot due to page faults during kmemleak scanning.
>>
>> This occurs because:
>> With debug_pagealloc is enabled, __free_pages() invokes
>> debug_pagealloc_unmap_pages(), clearing the _PAGE_PRESENT bit for
>> freed pages in the kernel page table.
>> KHO scratch areas are allocated from memblock and noted by kmemleak. But
>> these areas don't remain reserved but released later to the page allocator
>> using init_cma_reserved_pageblock(). This causes subsequent kmemleak scans
>> access non-PRESENT pages, leading to fatal page faults.
>>
>> Mark scratch areas with kmemleak_ignore_phys() after they are allocated
>> from memblock to exclude them from kmemleak scanning before they are
>> released to buddy allocator to fix this.
>>
>> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
>> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> ---
>>  kernel/liveupdate/kexec_handover.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>> index 224bdf5becb6..c729d455ee7b 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -11,6 +11,7 @@
>>  
>>  #include <linux/cleanup.h>
>>  #include <linux/cma.h>
>> +#include <linux/kmemleak.h>
>>  #include <linux/count_zeros.h>
>>  #include <linux/kexec.h>
>>  #include <linux/kexec_handover.h>
>> @@ -1369,6 +1370,7 @@ static __init int kho_init(void)
>>  		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
>>  		unsigned long pfn;
>>  
>> +		kmemleak_ignore_phys(kho_scratch[i].addr);
>
> Can you please put the explanation you gave in [0] for why this is not
> necessary in KHO boot as a comment here?

And also an explanation of why this is necessary in the first place. You
do explain that in the commit message, but a shorter version as a
comment will make this a lot easier to understand instead of having to
dig through git history.

[...]

-- 
Regards,
Pratyush Yadav

