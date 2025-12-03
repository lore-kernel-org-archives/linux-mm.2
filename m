Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87D52D116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 03:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A132E6B000C; Tue,  2 Dec 2025 22:27:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EB586B000D; Tue,  2 Dec 2025 22:27:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9286F6B000E; Tue,  2 Dec 2025 22:27:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 826A66B000C
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 22:27:59 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 389BF13A0E6
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:27:59 +0000 (UTC)
X-FDA: 84176725878.10.009A4CA
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf21.hostedemail.com (Postfix) with ESMTP id 179F61C0007
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:27:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764732477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9okrp6nztgcSSAqFXtQAgVG3oJiJAV1qdYte3A5qtfQ=;
	b=gvTqZJJ7C2O9g0Vdv2RLEhvI9Zn3NtwaXmyge+D63pyyL4cau1kqVv/FwSjrCfrGSEnY9q
	Zqxx0PFbi1XUUsxBGMZ3QvO6DEQVC46ZCujk30WOVYM0ra0SdxXWvRaBQBumn8fP1sgi02
	P1TSFSELAaonsUODUPe8/A9NGsBXFfw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764732477; a=rsa-sha256;
	cv=none;
	b=dJ/pOAu2Y4Sknp2UhHeG9czyMRBsP11p7GpcP20MSY6xvb848cpoD8dQ9/GgfEvH1CGwnZ
	xtFPhloubAiVtJa8M22D7TjCm18DnMTkYUq9qLKl8ghp1JqNAFmIqlcaSelQ0mhDSYSSLo
	4gTyIWS98uj9FqI0L8N8sbZtC7QEG3A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn;
	dmarc=none
X-UUID: 0bef3c36cff811f0a38c85956e01ac42-20251203
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:ad37dd2f-44d2-4f3c-991a-89a4075088f5,IP:10,U
	RL:0,TC:0,Content:2,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:7
X-CID-INFO: VERSION:1.3.6,REQID:ad37dd2f-44d2-4f3c-991a-89a4075088f5,IP:10,URL
	:0,TC:0,Content:2,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:7
X-CID-META: VersionHash:a9d874c,CLOUDID:a4568913cfbad42cd49316be8af8bbac,BulkI
	D:251127185555KE68HCIH,BulkQuantity:4,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|898,TC:nil,Content:4|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:
	nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0
	,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0bef3c36cff811f0a38c85956e01ac42-20251203
X-User: zhangguopeng@kylinos.cn
Received: from [192.168.24.105] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 718298084; Wed, 03 Dec 2025 11:27:50 +0800
Message-ID: <240ebe22-6e1c-4481-8a5e-b929bbfad178@kylinos.cn>
Date: Wed, 3 Dec 2025 11:27:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] selftests: cgroup: make test_memcg_sock robust
 against delayed sock stats
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: tj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, mkoutny@suse.com, muchun.song@linux.dev,
 lance.yang@linux.dev, shuah@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251124123816.486164-1-zhangguopeng@kylinos.cn>
 <20251124123816.486164-3-zhangguopeng@kylinos.cn>
 <me7djjzkgufieiyvrsbezi4i4t6v5zsbonirjlacce6hgilb2c@sxnifdeh2gnv>
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
In-Reply-To: <me7djjzkgufieiyvrsbezi4i4t6v5zsbonirjlacce6hgilb2c@sxnifdeh2gnv>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 179F61C0007
X-Stat-Signature: 7c1cinpzzsy6rwsho44mzmk64j7stwub
X-HE-Tag: 1764732475-642445
X-HE-Meta: U2FsdGVkX19iW+Okn3Tvk1b/QuMT7X/vjdX6ra4jrXWnchyEWb2ibND969f8Bcqr8QBUwZKE9zAXqTE9ObpcBMALjx2l6Lm6C1VZ4YJxU8dg2HDU/0kkwm3HZQW7s122g7a+sTsx6vBf4Bmp6Na3pliaPrYXREoC+9FgTx/RIAJT9dhNLXwv/y6+nInTRWkAHUkzeJ00hbwRF4wZYq4mUkdseOUTljB1dBKPIZjrsPVYySiE0nXRjbP1/16+nn4hZhXS7MiFjHxFTOzVLAykjROXecX977xQ72XVCIYydHZT1KTcIOehkEfhkkSHRWRieHgFlVIRoHQvu8mHDUE/T7eMRfgs8DGJMExr/paNZwjGtzIz8M/V6wiKd/Caa7BRipnZ0iOrc2ZH4aj46vCIB/BPtwQNneTvP2/QaufMXW5A4TEL8K0oyZ0JP095I/ZNZKO8uycyW1yAlHfDZn4dF7goPXTskeXCBoKA3y+xHng+kkcc/oaW/abSUBHaqf2qMFENb4HuMfEW7SX+16xF5aLdPaD4EjYcmhx805KCvwDBWUbgjARPckwb4ZjflKOt7qXMB78CLvQ1osmMlh7r1RpumKQPW0240wo1ZkPupP9dN6lnmU7TGKLLQ+ioyWk0CRbYHpao8Pfo4ILcG3B75IQhyKyu/Cxw/zXtetQf9jBGfRILDkpsKTB/HXljkE1IXNgi0jnmO1juVOF7ygK/9zdMFInAmaSnXruBmgHT/2f3n9mVu0y8ZsIMjHIchV1FlvPInTKSIfbE7KyP8nu7zu+o8bbATPFV7oaZOYM8hAALmKy7yLo+OusWLPB7uySQfTyeDbxtnQizbpqk6NwgyNggcaex6OSQOWFUNTpuCnfEZqG+xmZmmzcRZ5DtAYH/2vd2+tUJj3zTg6MIwnJqYXTpMWtHJdBUglqbgM6qIZOZwJlW720Q8mSEqdVbkwKJIRcJUyUE2aSlUWmVWWh
 9auTfvIV
 rBTEMASdmgMpukzL/Sd07NfI8CrAlclBLIyK5X6OxDYjFtGHlX+aNOS0+ZnZH3g+AcQHEi7kIkSFMh/DoiuNuhXApfSeM6Etr1tP/xbMkbIAXJaH7go2VSvzSBsZNyA+WwaOU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/3/25 07:12, Shakeel Butt wrote:
> On Mon, Nov 24, 2025 at 08:38:15PM +0800, Guopeng Zhang wrote:
>> test_memcg_sock() currently requires that memory.stat's "sock " counter
>> is exactly zero immediately after the TCP server exits. On a busy system
>> this assumption is too strict:
>>
>>   - Socket memory may be freed with a small delay (e.g. RCU callbacks).
>>   - memcg statistics are updated asynchronously via the rstat flushing
>>     worker, so the "sock " value in memory.stat can stay non-zero for a
>>     short period of time even after all socket memory has been uncharged.
>>
>> As a result, test_memcg_sock() can intermittently fail even though socket
>> memory accounting is working correctly.
>>
>> Make the test more robust by polling memory.stat for the "sock "
>> counter and allowing it some time to drop to zero instead of checking
>> it only once. The timeout is set to 3 seconds to cover the periodic
>> rstat flush interval (FLUSH_TIME = 2*HZ by default) plus some
>> scheduling slack. If the counter does not become zero within the
>> timeout, the test still fails as before.
>>
>> On my test system, running test_memcontrol 50 times produced:
>>
>>   - Before this patch:  6/50 runs passed.
>>   - After this patch:  50/50 runs passed.
>>
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> Suggested-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>  .../selftests/cgroup/test_memcontrol.c        | 20 ++++++++++++++++++-
>>  1 file changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
>> index 4e1647568c5b..dda12e5c6457 100644
>> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
>> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
>> @@ -21,6 +21,8 @@
>>  #include "kselftest.h"
>>  #include "cgroup_util.h"
>>  
>> +#define MEMCG_SOCKSTAT_WAIT_RETRIES        30              /* 3s total */
> 
> No need for the comment at the end as it will be stale when someone
> change DEFAULT_WAIT_INTERVAL_US in future.
> 
> Anyways it's a nit.
> 
> Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Hi Shakeel,

Thanks for the review and for the Reviewed-by.

Good point about the comment. I’ll drop the "/* 3s total */" part in the next version so it does not become stale if DEFAULT_WAIT_INTERVAL_US changes.

Thanks,
Guopeng


