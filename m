Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B681CFA478
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 07:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 961D96B002D; Fri, 21 Nov 2025 02:47:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939316B0062; Fri, 21 Nov 2025 02:47:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F946B0096; Fri, 21 Nov 2025 02:47:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 72B736B002D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:47:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4757D4EC4F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:47:57 +0000 (UTC)
X-FDA: 84133835394.22.82449C5
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id F354040004
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:47:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763711275; a=rsa-sha256;
	cv=none;
	b=g1sHOSnt7JWi2hBDvzdFujVz2JtcpMZcAeGMfQ+fRoFANPlZiPP9DJQY5/4sD/UFziKJ6U
	BAFkFq/yYwN9AYGIDEbsGkLz5HOjuRHMbYHWFx4bXaI+1PokE4Nsf9XJjOdAoSED5qyvUy
	p9O6a/PZd0vT/4c/pHfhY2JCE4UFaJw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763711275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NZDm+dCfaG07HrzrKQn9D0fRIneme15KZ0ld+lJlWaU=;
	b=Ob7GAqqYOm4VTpBbUkuWjoeU9RZaC5u61/cw+7WChhs6wERksGQhS+bZxqZzdSg86hY19P
	5ut1m9CJqTgWK6svKwDOoqw1IXFvp5r/4wGUJ0tEkSR0+OVBZXEaVdUcSLe0BcYBq7OeHZ
	FfE2nZr0EDkdcfouqY0XfePRWSK/1lw=
X-UUID: 5c6868fcc6ae11f0a38c85956e01ac42-20251121
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:c47afd99-8d09-4ddf-aff3-c959e8862316,IP:20,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-INFO: VERSION:1.3.6,REQID:c47afd99-8d09-4ddf-aff3-c959e8862316,IP:20,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:15
X-CID-META: VersionHash:a9d874c,CLOUDID:ed791c21fc197a444815489b1aed3c13,BulkI
	D:251120233527X6NZUQMX,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:
	nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0
	,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5c6868fcc6ae11f0a38c85956e01ac42-20251121
X-User: zhangguopeng@kylinos.cn
Received: from [192.168.24.105] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1849455201; Fri, 21 Nov 2025 15:47:42 +0800
Message-ID: <f7553219-e19d-4172-90da-a2077cb574cc@kylinos.cn>
Date: Fri, 21 Nov 2025 15:47:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] selftests: cgroup: make test_memcg_sock robust against
 delayed sock stats
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: tj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 lance.yang@linux.dev, shuah@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251120060406.2846257-1-zhangguopeng@kylinos.cn>
 <p655qedqjaakrnqpytc6dltejfluxo6jrffcltfz2ivonmk6lb@bxf5xlgo4iw2>
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
In-Reply-To: <p655qedqjaakrnqpytc6dltejfluxo6jrffcltfz2ivonmk6lb@bxf5xlgo4iw2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F354040004
X-Stat-Signature: 93a5bqqprbaw6nsibu9791npeepit7b3
X-Rspam-User: 
X-HE-Tag: 1763711273-572473
X-HE-Meta: U2FsdGVkX1+UQZ4iaql9/XtMDz33M7So19XRPijOPHNkU4Ff2S2OE/mBLMsspCaL10UNm0WKtL65FKUQsdG5YbmNAAYNdDsQ2NoEnz/YNbUcbOiQSw0hMnqfohthSugI/5DBt6gp4s99zlDL6clJaneKu/AfTN3hvmmzmiEFx/5xsn/HheCjimwZznseXNlG/DApx8RzwIfujGzE7WNVocoF/bMz6Jt5RIwrJcJgC7u66pHAAQsGHLWKGo1SwOkxuJQBBOMSpj9VlRrUIcS7gijHIMiHEZNOrTiWbeQi4kzdF5xXlhcNO4n7q0vEGGn3NyIxuwZsKa/qMKvXXqlE29AAOKQKr+4JKuuIXrgjtQIIsoaz2Qb1cyUFf5pUMDq3OtpHwFzp2m5zryzY7dT8lLYEWEthRnPWWp9+ehgOMOyrl0BrlDe/Iaaj46PVxX5VBgsvbW0+zkkE/yQzs9rKQP5guAPVURUpjrtyn8CpvW8qc3uxX0BtlHgnxLxe5jkluQWHhXijKlj4mMGAQp1S92s7WjD8kee8dQfcT5/X8NBiVKAZ27PN3ON3++8/HdhVjGe75lCWGRy0R50MwTIsV8OXmO1t64eE79COLmvHBaHDfvm7+wM028bkDtjHx53ywi+P7DlegSWo+FRWk4CpT0cJF49+qYLCNri5vG6FeZITJAFhMbZYKeXHaLw2HmbUzuf+x81jjHGvMOc32wgv8vKjda9LMIXDB42mAoZlbWS//o7AQzl2SqWWeqoC4ObKiINIvthvfd1PVWgU2ExrIp1p2f2REJDWWTX9HsNQIt0oahVdUu6f0JqYI+Qpv1MrvpGbR/2BYyWuVT3OlGF1nvEePEzyLjJzvmJrPAdtrzzkIHjOUWae58lhJTEFRzPLAv7yDW2IQ+KcR9W89GLAEP51bgQuPNyPozgOMdKwMV+L/lgIJ2cvsyf16D/a4DHlFMCVLfV4flYBKxpIe7m
 17B+lG88
 gSbI9aIGFwl6HdHqDJrfgbqPf4TaCQUPMi8x7or11IXFnQN5JU/6mcjmYkPNg32TSPtjnXtC4xYaRkukt7FyTkVIkoRJ7xR7i5A0uckqxgi7V6ir2s054rx9t81trw1dx1Ho7ac43FzI/WyFXae80jl8LN5RjxyOl1DeCiCgkkMLnarysj99x2ToS0nU6uC2GS9+vF+JMp2YDRSwuddejAwa5LS+BGpmbUHyE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/20/25 23:35, Michal Koutný wrote:
> Hello Guopeng.
> 
> +Cc Leon Huang Fu <leon.huangfu@shopee.com>   
> 
> On Thu, Nov 20, 2025 at 02:04:06PM +0800, Guopeng Zhang <zhangguopeng@kylinos.cn> wrote:
>> test_memcg_sock() currently requires that memory.stat's "sock " counter
>> is exactly zero immediately after the TCP server exits. On a busy system
>> this assumption is too strict:
>>
>>   - Socket memory may be freed with a small delay (e.g. RCU callbacks).
> 
> (FTR, I remember there is `echo 1 > /sys/module/rcutree/parameters/do_rcu_barrier`,
> however, I'm not sure it works always as expected (a reader may actually
> wait for multi-stage RCU pipeline), so plain timeout is more reliable.)
> 
Hi Michal,

Thank you for the suggestion.

I tested using `echo 1 > /sys/module/rcutree/parameters/do_rcu_barrier`, but
unfortunately the effect was not very good on my setup. As you mentioned, a
reader may actually wait for the multi-stage RCU pipeline, so a plain timeout
seems more reliable here.
>>   - memcg statistics are updated asynchronously via the rstat flushing
>>     worker, so the "sock " value in memory.stat can stay non-zero for a
>>     short period of time even after all socket memory has been uncharged.
>>
>> As a result, test_memcg_sock() can intermittently fail even though socket
>> memory accounting is working correctly.
>>
>> Make the test more robust by polling memory.stat for the "sock "
>> counter and allowing it some time to drop to zero instead of checking
>> it only once.
> 
> I like the approach of adaptive waiting to settle in such tests.
> 
>> The timeout is set to 3 seconds to cover the periodic rstat flush
>> interval (FLUSH_TIME = 2*HZ by default) plus some scheduling slack. If
>> the counter does not become zero within the timeout, the test still
>> fails as before.
>>
>> On my test system, running test_memcontrol 50 times produced:
>>
>>   - Before this patch:  6/50 runs passed.
>>   - After this patch:  50/50 runs passed.
> 
> BTW Have you looked into the number of retries until success?
> Was it in accordance with the flushing interval?
> 
Yes. From my observations, it usually succeeds after about 10–15 retries on
average (roughly 1–1.5 seconds), and occasionally it takes more than 20 retries
(>2 seconds). This looks broadly in line with the periodic rstat flushing
interval (~2 seconds) plus some scheduling slack.
>>
>> Suggested-by: Lance Yang <lance.yang@linux.dev>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>> v3:
>>  - Move MEMCG_SOCKSTAT_WAIT_* defines after the #include block as
>>    suggested.
>> v2:
>>  - Mention the periodic rstat flush interval (FLUSH_TIME = 2*HZ) in
>>    the comment and clarify the rationale for the 3s timeout.
>>  - Replace the hard-coded retry count and wait interval with macros
>>    to avoid magic numbers and make the 3s timeout calculation explicit.
>> ---
>>  .../selftests/cgroup/test_memcontrol.c        | 30 ++++++++++++++++++-
>>  1 file changed, 29 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
>> index 4e1647568c5b..8ff7286fc80b 100644
>> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
>> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
>> @@ -21,6 +21,9 @@
>>  #include "kselftest.h"
>>  #include "cgroup_util.h"
>>  
>> +#define MEMCG_SOCKSTAT_WAIT_RETRIES        30              /* 3s total */
>> +#define MEMCG_SOCKSTAT_WAIT_INTERVAL_US    (100 * 1000)    /* 100 ms */
>> +
>>  static bool has_localevents;
>>  static bool has_recursiveprot;
>>  
>> @@ -1384,6 +1387,8 @@ static int test_memcg_sock(const char *root)
>>  	int bind_retries = 5, ret = KSFT_FAIL, pid, err;
>>  	unsigned short port;
>>  	char *memcg;
>> +	long sock_post = -1;
>> +	int i;
>>  
>>  	memcg = cg_name(root, "memcg_test");
>>  	if (!memcg)
>> @@ -1432,7 +1437,30 @@ static int test_memcg_sock(const char *root)
>>  	if (cg_read_long(memcg, "memory.current") < 0)
>>  		goto cleanup;
>>  
>> -	if (cg_read_key_long(memcg, "memory.stat", "sock "))
>> +	/*
>> +	 * memory.stat is updated asynchronously via the memcg rstat
>> +	 * flushing worker, which runs periodically (every 2 seconds,
>> +	 * see FLUSH_TIME). On a busy system, the "sock " counter may
>> +	 * stay non-zero for a short period of time after the TCP
>> +	 * connection is closed and all socket memory has been
>> +	 * uncharged.
>> +	 *
>> +	 * Poll memory.stat for up to 3 seconds (~FLUSH_TIME plus some
>> +	 * scheduling slack) and require that the "sock " counter
>> +	 * eventually drops to zero.
>> +	 */
>> +	for (i = 0; i < MEMCG_SOCKSTAT_WAIT_RETRIES; i++) {
>> +		sock_post = cg_read_key_long(memcg, "memory.stat", "sock ");
>> +		if (sock_post < 0)
>> +			goto cleanup;
>> +
>> +		if (!sock_post)
>> +			break;
>> +
>> +		usleep(MEMCG_SOCKSTAT_WAIT_INTERVAL_US);
>> +	}
> 
> I think this may be useful also for othe tests (at least other
> memory.stat checks), so some encapsulated implementation like a macro
> with parameters
> 	cg_read_assert_gt_with_retries(cg, file, field, exp, timeout, retries)
> WDYT?
> 
> Michal

That’s a great idea. I agree this pattern could be useful for other
`memory.stat` checks as well, and I will implement an encapsulated helper/macro
along those lines as per your suggestion.

Thanks,
Guopeng


