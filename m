Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49682CF64A4
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 02:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A23CF6B0010; Wed, 19 Nov 2025 21:12:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AE306B0028; Wed, 19 Nov 2025 21:12:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C276B0089; Wed, 19 Nov 2025 21:12:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75D466B0010
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:12:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E987E88F86
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:12:10 +0000 (UTC)
X-FDA: 84129360420.19.B25FAE8
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf22.hostedemail.com (Postfix) with ESMTP id A31AEC000D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:12:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763604728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SiJBnBlYbLuEwVyizDE1m+A2D3SEDAgNbHhgqT4/Mec=;
	b=Ti6SC1kW2S5gxFnU5VVnHj82hglmZfaN06DEgYe/AnvRxlCC0AUTnxB5sJjIgokFU9FdA2
	PTQMiVUeqaeeBd+TS4mWJ4er46Sy1yOWBOKKItF8ltYG0oyjsVtF28PlKgGZSJhuQ3UG/h
	l0u+Rf8wlKJIyLAv4wiKZKOYnTQtgNg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763604728; a=rsa-sha256;
	cv=none;
	b=gcMDmpOMdmrz4V9MTj2tpgiuA24A+jlPvSuLWxU/pGuPzYWOsEuZt74lSvRmXa3o+YWwL1
	7PIo/TDZzafjivIBBVgFa84jujd0Jz+0i6Oks2qU1HKN8MjXT+3iHN1Bfx4nRJOd0Ktyjr
	HhOFqJDT8YBs1/ts1t/fReoMOwXkQ2A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn;
	dmarc=none
X-UUID: 4d46b0d4c5b611f0a38c85956e01ac42-20251120
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:ef79d8a0-0334-43ca-b31d-7b08ab0dca32,IP:20,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-INFO: VERSION:1.3.6,REQID:ef79d8a0-0334-43ca-b31d-7b08ab0dca32,IP:20,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:15
X-CID-META: VersionHash:a9d874c,CLOUDID:5e05ec9e36a263da29547234aa54b56b,BulkI
	D:251119202822NBVZVXBR,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|841,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk
	:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4d46b0d4c5b611f0a38c85956e01ac42-20251120
X-User: zhangguopeng@kylinos.cn
Received: from [192.168.24.105] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1050465187; Thu, 20 Nov 2025 10:12:01 +0800
Message-ID: <2c276ed9-626f-4bae-9d42-727dd176ec74@kylinos.cn>
Date: Thu, 20 Nov 2025 10:11:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: cgroup: make test_memcg_sock robust against
 delayed sock stats
To: Lance Yang <ioworker0@gmail.com>
Cc: hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org,
 mkoutny@suse.com, muchun.song@linux.dev, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, shuah@kernel.org, tj@kernel.org,
 leon.huangfu@shopee.com, Lance Yang <lance.yang@linux.dev>
References: <20251119105216.1675608-1-zhangguopeng@kylinos.cn>
 <20251119122758.85610-1-ioworker0@gmail.com>
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
In-Reply-To: <20251119122758.85610-1-ioworker0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A31AEC000D
X-Stat-Signature: fd7wmhu8n4w3586gqz7tz3z7ca5fyjs3
X-Rspam-User: 
X-HE-Tag: 1763604727-812572
X-HE-Meta: U2FsdGVkX18uTvTMLSzsGv1RCPt9cApwDhIaMwBCDuhTnypby6LJD0Dx8E+p0a4MXRRkvBr1O92BMxNIwof6UFk0/fDtND+84bJVLbqkpzw37OPDDAwnWwlPVuzJ1eCeasZa6rL3HrI0tYSs/rgKx0o9P6dh1YUlVOfVHTaIlaAnm4zU1RyFa2yDaULx3qlUENvEJYWJr8V1Xq93Vu6AMmZyPrzfFcHteb+4EQDBSBKhjTSxaPeoX4vFv1v7/J+vj1iOqAADypC+7D8z2VuQfhaiaI9daVUam6YOt9N1ZzFZxskKhxuLcqpmei4F/2SWfI0s/3KvWgjgLEKFUqhoIbNbu3rwYEc+R42zU8OIBcNHv71SaFSSH9k01BbxtR5xSamEwSUKLOzBrto4wJzHqqsTMSDdpeE2XDUqnXcQvADYnlAKwaGpil2k902FGhvky27g5Dp6v85LUJWo9E4mL3d732AdoCzPXnBbrqw/ZvpKEFftWtImvRvDKqEy/9oVblGjXNyoC6/viILiLjaHReb7fHxJGNA07qm7tLw2QDncwttsu6j6htoFxTSX6RZqiuIliEAxyyTURQU9hAj5MtUEJ2J21WdlsNuikJggazehbBszoI5XwjjYKCE/meql2sUm3B4n0Z4hmvdNkAhzNxGoQ9ShSJWpTxsUor/jYh8WBo/39X30TBnj4itdSvslTTSd0rW4WJmgB6QRH2GyH0ZcdzXXIpvfPgp5O7d6lGwIBFj0h26/5ZGZVUu5aFmchUgM7Zxb5wd7xIHqEB8H1Wef3jHTUWJPZGvdtJPfWk/ydM50To0Kg/xYUa+STEvnj2KtS8r7BDWvKotI+B6sBnjP3eZJXvNlo1RVCYliRm1+1Mn3eiO4JTvp3pEzsDpl6bxz0FPscMs2To57cHZ8FkXNvBPflEFHE6LvkzvjedOmHMwwd5JPITNmFCVxThZ0ymGvFz2oTcmCEVKEkMP
 2mIwty1A
 R1e7tfNxr4itH6JtiRp2K6wBFYEQCmYRm2nlb7yYVOr6QXNx1B2S+tKlOlJ2ozdE2niKuq2jro2RBqRS2+WqB6hhY8V4dB5En7QcSUIklp7vrBnDm+XUfhK7+3/3mjWyFZvgL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/19/25 20:27, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> 
> On Wed, 19 Nov 2025 18:52:16 +0800, Guopeng Zhang wrote:
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
>> Make the test more robust by polling memory.stat for the "sock " counter
>> and allowing it some time to drop to zero instead of checking it only
>> once. If the counter does not become zero within the timeout, the test
>> still fails as before.
>>
>> On my test system, running test_memcontrol 50 times produced:
>>
>>   - Before this patch:  6/50 runs passed.
>>   - After this patch:  50/50 runs passed.
Hi Lance,

Thanks a lot for your review and helpful comments!
> 
> Good catch! Thanks!
> 
> With more CPU cores, updates may be distributed across cores, making it
> slower to reach the per-CPU flush threshold, IIUC :)
> 
Yes, that matches what I’ve seen as well — on larger systems it indeed
takes longer for the stats to converge due to per-CPU distribution and
the flush threshold.
>>
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>  .../selftests/cgroup/test_memcontrol.c        | 24 ++++++++++++++++++-
>>  1 file changed, 23 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
>> index 4e1647568c5b..86d9981cddd8 100644
>> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
>> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
>> @@ -1384,6 +1384,8 @@ static int test_memcg_sock(const char *root)
>>  	int bind_retries = 5, ret = KSFT_FAIL, pid, err;
>>  	unsigned short port;
>>  	char *memcg;
>> +	long sock_post = -1;
>> +	int i, retries = 30;
>>  
>>  	memcg = cg_name(root, "memcg_test");
>>  	if (!memcg)
>> @@ -1432,7 +1434,27 @@ static int test_memcg_sock(const char *root)
>>  	if (cg_read_long(memcg, "memory.current") < 0)
>>  		goto cleanup;
>>  
>> -	if (cg_read_key_long(memcg, "memory.stat", "sock "))
>> +	/*
>> +	 * memory.stat is updated asynchronously via the memcg rstat
>> +	 * flushing worker, so the "sock " counter may stay non-zero
>> +	 * for a short period of time after the TCP connection is
>> +	 * closed and all socket memory has been uncharged.
>> +	 *
>> +	 * Poll memory.stat for up to 3 seconds and require that the
>> +	 * "sock " counter eventually drops to zero.
> 
> It might be worth mentioning that the current periodic rstat flush happens
> every 2 seconds (#define FLUSH_TIME (2UL*HZ)). Adding this context to the
> comment would explain why the 3-second timeout was chosen ;)
> 
Good idea,I actually started with a 2-second timeout to match the rstat flush
interval (FLUSH_TIME = 2*HZ), and that already reduced the flakiness
compared to the original code. However, on my test system there were
still a few intermittent failures over multiple runs. Bumping the
timeout to 3 seconds made the test stable (50/50 runs passed), so I
went with a slightly larger value to cover the periodic flush plus
scheduling noise on busy machines. I’ll update the comment in v2 to
spell out this rationale.
>> +	 */
>> +	for (i = 0; i < retries; i++) {
>> +		sock_post = cg_read_key_long(memcg, "memory.stat", "sock ");
>> +		if (sock_post < 0)
>> +			goto cleanup;
>> +
>> +		if (!sock_post)
>> +			break;
>> +
>> +		usleep(100 * 1000); /* 100ms */
> 
> Nit: It would be better to define the retry count and interval as macros
> (e.g., MAX_RETRIES, WAIT_INTERVAL) to avoid magic numbers and make the 3s
> timeout calculation explicit.
> 
Makes sense. I’ll introduce macros for the retry count and the wait
interval in v2 so that the 3s timeout is explicit and we don’t rely on
magic numbers.

I’ll send a v2 shortly.

Best regards,
Guopeng
>> +	}
>> +
>> +	if (sock_post)
>>  		goto cleanup;
>>  
>>  	ret = KSFT_PASS;
> 
> Thanks,
> Lance


