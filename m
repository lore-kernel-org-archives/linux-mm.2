Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8814CF31B7
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 12:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122FF6B00AA; Wed, 19 Nov 2025 07:17:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FB3B6B00AB; Wed, 19 Nov 2025 07:17:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0377E6B00AE; Wed, 19 Nov 2025 07:17:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7AD36B00AA
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:17:48 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20A87C02CD
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:17:46 +0000 (UTC)
X-FDA: 84127257732.22.B3132FA
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf06.hostedemail.com (Postfix) with ESMTP id 483F518000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:17:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zqy5lX1a;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763554664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9eiK6+KP3sQeus9efFgfEbOH2adoGq+RjOojwb3xNjU=;
	b=fSWL003nGNq73O0si9S4N+MTeCHOTw7WPdSz5qCOdujgeHyJvGWkm6ZNFtp80TurwjmDTP
	FWEbwdN9OVg5baOcvNrrQTdbC9WayTZnFuEXAeJMc4CQzL+Uh7CjJfaYGK46pgn3L2SJd6
	O39WVIEJGikS9+q6Hxhnd3rxqdSpl9g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zqy5lX1a;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763554664; a=rsa-sha256;
	cv=none;
	b=QVppmVGoWZzFJKo72LohfD71x7OYbbQ5rZXQLz6viQ6fOJPSV3idzbuVg/1nslWsLIb8Bc
	llVz7lfeMfazV0p0ZfV3nrLn7WK3nvICHD2QJgRpte+D/2E8aZ/Vj21+JjGr1hLXb6A7P7
	NOenNYoBveDzgvmMCSa/V8cPeMTq8gg=
Message-ID: <939e3496-5012-4e7d-8a33-e9de4354d4fd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763554662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9eiK6+KP3sQeus9efFgfEbOH2adoGq+RjOojwb3xNjU=;
	b=Zqy5lX1a8NH32Urc6QLDGvEAqomF2lRwsHiYL0l9i1s/rF3dYjFpcG8gjDNr8eJS2XwRye
	ZVGhpKOTCj8lKt/dfRzfgKw3J1mAcg3B69SNBb0spvOTCzuF7kU0BWqQyFrC8oudnT+l5K
	mEXeAABjnQT0helIioSYA0k5eRwmsng=
Date: Wed, 19 Nov 2025 20:17:31 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/7] mm: change mm/pt_reclaim.c to use asm/tlb.h
 instead of asm-generic/tlb.h
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
 dev.jain@arm.com, akpm@linux-foundation.org, ioworker0@gmail.com,
 linmag7@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1763537007.git.zhengqi.arch@bytedance.com>
 <e9d510106b5bf72a9b577b8c5ad161fd3c29c2b6.1763537007.git.zhengqi.arch@bytedance.com>
 <e539179f-668e-452d-a08e-6143392dae6a@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <e539179f-668e-452d-a08e-6143392dae6a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 483F518000B
X-Stat-Signature: 3t6o684qnmx5yaz19tqyrtgsmn9moxfb
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763554664-609450
X-HE-Meta: U2FsdGVkX1/uatZokfDdUnJnsvLWhA3xCWn7khAyQIgxwhTrg1uYx/8VIGXH1i49IT3yrgttx2q7gCbBirP60TnOg1yFksE1KGcSAXuzEETimiw0nM2HMa2m4Tyq7ULqRuEjXwgKJstj+J0pOXltRtZr+RGp3Mowq/LtQJYTgfN9deD2MzOGQkPzKHET+rV1h4w1L0iHw4bcPy7542D7VePT/NURhpHh+hxoCEXc+Cb1sQDdJVeYfvLcPZ5VLfUAHbcYPZvZRgnsH0r8a5nqfHQwVeuEkiWZPIhzYgsu7Md6LtTQY1wzIslwD+0mkPjmx0d7rz2gvsufkcG9XhQBM5vIPtMJJi1to0bLBbyfsAfumqz77xbKCr1Q11GdnBt71M0gwKbx4zgv4eNrBLrnL+P/j/t1Y1RSFeZoAiNoYO1zmbol77LCXqisZfOIDnm3N8QzudGUrfaQYh2hQJUwT1H0899rXeINyqG6sjC7A9XqAyDYPjMuUQpAs0vvdoU7Evj8usCbXUWCuqJTAXwME8FK+RxbCyA7wGBuQD0FQrMVN4Mnt/bC6Xs+38TpBbg8F4wOqEib9PcJImZIhbcpXpKWCGheG+eD+/C0UY8DsBIMBMaukCWpywaNwhJfFeBrk/zDXrA9jqjTcdfKoFbobiyWN8TwTHUFU9wzDRLKV5Sb+YahfLmkrBIQ8fBoJ57vAKcC4BEhtdHrUeOjTi7IQancEhUytnyZ7F172xI6NtmTgNjfHcWgwcpOhu37fsIrUFaH+mHhJ1f80LPCGLDuYLo2bp+Q2HwQFK7D0z2NttrAF9bMQtO8T8HOIIVX+BJzdaZ/oU4kuYvMA7Z6bP3hPY28Ypy0vqQQXqU/almLHdMHxpX2pzhUkJ/DzmMDroA+dNOrQ+MXHfX0a7T5hwayeXD23YJZ/MXIoHSez0dyo+68Uurk/R2M75hW5pXIJ0zhW7a4U2nM8rsqtGL0AF9
 iP8W5603
 PLkRiS+hO8yK0D9TkMQq3kwkiVIWFO+Y4CXMjmdDeuDkwHfttlp3NA7x2cHEItLBAFIa+Unr9ZJ4OqJii3DWuTc2fjIjgmG1qrb5AA6El6lP94P8DQi6parTbQC+f4a8Pb4fF9OCOHNAsAWrhMk9/2rEQEFRAUXidtMVD6tpVfmABIHyg49zQHnL36E1Ftm4jkmDjMr969rxzkuBfeTyjEH+yXtezw1MYkFF5nqJqu6P0VeGe7cdqUaETd9ih6dBOGNZSxVPpVED/NTLYt7wqhU/mJnb2oUdp81AzsHx9BmKF5iroiw3TyDTjX2kAfTV5Hi5tFRUaLNXXlcl8zmLQMR56WlCunnplkOsjBgCYTJext2o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/19/25 7:41 PM, David Hildenbrand (Red Hat) wrote:
> On 19.11.25 08:31, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Generally, the asm/tlb.h will include asm-generic/tlb.h, so change
>> mm/pt_reclaim.c to use asm/tlb.h instead of asm-generic/tlb.h. This can
>> also fix compilation errors on some architecture when CONFIG_PT_RECLAIM
>> is enabled (such as alpha).
> 
> "This is a preparation for enabling CONFIG_PT_RECLAIM on other 
> architectures, such as alpha."

OK, will modify it in the next version.

> 
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   mm/pt_reclaim.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
>> index 0d9cfbf4fe5d8..46771cfff8239 100644
>> --- a/mm/pt_reclaim.c
>> +++ b/mm/pt_reclaim.c
>> @@ -2,7 +2,7 @@
>>   #include <linux/hugetlb.h>
>>   #include <linux/pgalloc.h>
>> -#include <asm-generic/tlb.h>
>> +#include <asm/tlb.h>
>>   #include "internal.h"
> 
> Right, we're using pte_free_tlb(), and the default lives in include/asm- 
> generic/tlb.h.
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Thanks!

> 


