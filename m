Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0225BD12D4B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 12:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5952E6B0012; Wed,  3 Dec 2025 07:00:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5499D6B002C; Wed,  3 Dec 2025 07:00:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45BB66B0032; Wed,  3 Dec 2025 07:00:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 353916B0012
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 07:00:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF97213AF39
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 12:00:02 +0000 (UTC)
X-FDA: 84178016244.11.992AFB9
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf30.hostedemail.com (Postfix) with ESMTP id C5F2D80002
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:59:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764763200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cfR1op6I2ilEgsRWTWe25yHuD9w2fpD5VolsHrq/pDw=;
	b=H5NC1pS2RI2vtQWMP9RfGon7YbyGWDS+8saDnzKxl/TswopU9EG2H0SGuCTY/UOHGU7SUb
	022RI03K3NjonpNJ7B/iCoqX9S95TYDT8YPUPvN8N415cAY9nQtT+rC2EDsqaq0ttq9uYT
	g2+bAOdB/kTsDBDojYlwKloBYeafMYI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764763200; a=rsa-sha256;
	cv=none;
	b=Sdnh6+FWAtaKWhx4Bo47PCP1ULSRHwVnsYieVF3Ditk71n+Fp0ePUoBsIkwbcj6c2fRSuv
	3miMoWhRcKulKBAA72FW5e/DCJCC+56WEmT/eQGdhszk384UsaDtDaPsnvsanEuis62ESG
	etucHNsKo3MO564B/Ve3C49I46C0qGE=
X-UUID: 9425e766d03f11f0a38c85956e01ac42-20251203
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:5b83410b-1a13-40e2-9e25-4f438dd71b9a,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:5b83410b-1a13-40e2-9e25-4f438dd71b9a,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:161b65e2e8a1b24f3f8f0378b4a6013a,BulkI
	D:251120233527X6NZUQMX,BulkQuantity:2,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:
	nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0
	,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9425e766d03f11f0a38c85956e01ac42-20251203
X-User: zhangguopeng@kylinos.cn
Received: from [192.168.24.105] [(223.70.160.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1309268471; Wed, 03 Dec 2025 19:59:53 +0800
Message-ID: <440f6a44-5d1a-44d6-b776-ec58e6c79f37@kylinos.cn>
Date: Wed, 3 Dec 2025 19:59:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] selftests: cgroup: make test_memcg_sock robust against
 delayed sock stats
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: tj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 lance.yang@linux.dev, shuah@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251120060406.2846257-1-zhangguopeng@kylinos.cn>
 <p655qedqjaakrnqpytc6dltejfluxo6jrffcltfz2ivonmk6lb@bxf5xlgo4iw2>
 <f7553219-e19d-4172-90da-a2077cb574cc@kylinos.cn>
In-Reply-To: <f7553219-e19d-4172-90da-a2077cb574cc@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C5F2D80002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: h4yfegir8zf9k1npb5766czxqc9shnp6
X-HE-Tag: 1764763199-361834
X-HE-Meta: U2FsdGVkX18tMVSUlL/5G6Sj58pb2lopAZUJuDlFlqsyQnDLHEnekUHSPO89XGa07UKXl9sFOotJnF+Ew15WbIgYwRdLHkFcck/XJEd9W5c7qLMqPyxqL0Lv/QKgixAoRFGIy6mXfuEviGIFzcHnQiLqDiDj7dRzjgAuo/zpdpKGu0PMJt6hfvIkKJqQ3weqVnJKpfVXDlOoMB783V5ppQiT1+Nwba04sskye1SI+36RyMc4BUzA1yPxSyHANWSCV+M9L5QpTucxaO720zhwmfshdmdeH2k+eEOx5bRjsmmxnHgnhq1xKDwsmvZps8bx61XB9fpv1XXAewUbRDQiWDP35/R0cD391E3rWDdVVh1CbjETSVvAAzGpw343WCiU2oGjnj8Q1ufY6wu6OLT94i1lIXmqpAkztKUq7nKukMrsh4lZbwhrRCSYf5TJ3MgNLDMEnziHc6l+MGmuxvu31/s4hU7YtuHSd5AanJ2MXefihr6vAG8nJHi6YDlYPZmJv84hgpP+VPpdH8nrM8/IkhnO5liM0062X2VOFNWrN3RTW4FSuPfm/86UyKSYp/OuISjLGArFiisu181iurS8/9Uo/qWbQtE5OAhxN2X6G52e2etVU5gSpXeisrBbURPPozEMHxn2Mp7efJPMod4Ba9yZTZB/nsJFXzqkjA52WvTwJPSxLMTWs5W4AiG1lit76kxhSY0mo7Z0KP3+0fgPnFVMkuOQTeC5Eq3g8o14is7+ORTvwG2uwCxuBE8gBweVaBZRyfx95cji6hnPrCAQeOG36veMJj8rUCTmc51yaPCZ+K9vQgLm/Euyeenei8C/8RaAxA2jZ6u8j6DWfwWJCpe7LUor5G59WIfx3mskCpyuOFLEpLM1Wh72LMnr0E6cdWeehCr+gOuZJ/zTcJrvbBpxYUqCq8nhZ89VDGS4YSxEiAjjCivbZKqiayhgAwfWEt6plHkvL/SGi4fxMUv
 qQ5ZwzD8
 S9IKFxgYQC9s0wTV5lWTvsdTvxFmz1my4uL5xMsTvRIxymCLOuHFrB3XEC/sxdUierhaKLMEvaWcXgLdjvTzSeWpvnoEr/Jjqic3jRu/sDHiS5iqW7bHvR2tfvrUde8Flsrty6DOzEt8rAoaXAygPNDoTCKFcJe/ogX0wADPxu3aNA11vZlTSJWY1HKFpdDt8D2mTQuHE976nn1efD77EyIOJpJOmsQso2QDM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/21/25 15:47, Guopeng Zhang wrote:
> 
> 
> On 11/20/25 23:35, Michal Koutný wrote:
>> Hello Guopeng.
>>
>> +Cc Leon Huang Fu <leon.huangfu@shopee.com>   
>>
>> On Thu, Nov 20, 2025 at 02:04:06PM +0800, Guopeng Zhang <zhangguopeng@kylinos.cn> wrote:
>>> test_memcg_sock() currently requires that memory.stat's "sock " counter
>>> is exactly zero immediately after the TCP server exits. On a busy system
>>> this assumption is too strict:
>>>
>>>   - Socket memory may be freed with a small delay (e.g. RCU callbacks).
>>
>> (FTR, I remember there is `echo 1 > /sys/module/rcutree/parameters/do_rcu_barrier`,
>> however, I'm not sure it works always as expected (a reader may actually
>> wait for multi-stage RCU pipeline), so plain timeout is more reliable.)
>>
> Hi Michal,
> 
> Thank you for the suggestion.
> 
> I tested using `echo 1 > /sys/module/rcutree/parameters/do_rcu_barrier`, but
> unfortunately the effect was not very good on my setup. As you mentioned, a
> reader may actually wait for the multi-stage RCU pipeline, so a plain timeout
> seems more reliable here.
>>>   - memcg statistics are updated asynchronously via the rstat flushing
>>>     worker, so the "sock " value in memory.stat can stay non-zero for a
>>>     short period of time even after all socket memory has been uncharged.
>>>
>>> As a result, test_memcg_sock() can intermittently fail even though socket
>>> memory accounting is working correctly.
>>>
>>> Make the test more robust by polling memory.stat for the "sock "
>>> counter and allowing it some time to drop to zero instead of checking
>>> it only once.
>>
>> I like the approach of adaptive waiting to settle in such tests.
>>
>>> The timeout is set to 3 seconds to cover the periodic rstat flush
>>> interval (FLUSH_TIME = 2*HZ by default) plus some scheduling slack. If
>>> the counter does not become zero within the timeout, the test still
>>> fails as before.
>>>
>>> On my test system, running test_memcontrol 50 times produced:
>>>
>>>   - Before this patch:  6/50 runs passed.
>>>   - After this patch:  50/50 runs passed.
>>
>> BTW Have you looked into the number of retries until success?
>> Was it in accordance with the flushing interval?
>>
> Yes. From my observations, it usually succeeds after about 10–15 retries on
> average (roughly 1–1.5 seconds), and occasionally it takes more than 20 retries
> (>2 seconds). This looks broadly in line with the periodic rstat flushing
> interval (~2 seconds) plus some scheduling slack.
>>>
>>> Suggested-by: Lance Yang <lance.yang@linux.dev>
>>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>> ---
>>> v3:
>>>  - Move MEMCG_SOCKSTAT_WAIT_* defines after the #include block as
>>>    suggested.
>>> v2:
>>>  - Mention the periodic rstat flush interval (FLUSH_TIME = 2*HZ) in
>>>    the comment and clarify the rationale for the 3s timeout.
>>>  - Replace the hard-coded retry count and wait interval with macros
>>>    to avoid magic numbers and make the 3s timeout calculation explicit.
>>> ---
>>>  .../selftests/cgroup/test_memcontrol.c        | 30 ++++++++++++++++++-
>>>  1 file changed, 29 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
>>> index 4e1647568c5b..8ff7286fc80b 100644
>>> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
>>> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
>>> @@ -21,6 +21,9 @@
>>>  #include "kselftest.h"
>>>  #include "cgroup_util.h"
>>>  
>>> +#define MEMCG_SOCKSTAT_WAIT_RETRIES        30              /* 3s total */
>>> +#define MEMCG_SOCKSTAT_WAIT_INTERVAL_US    (100 * 1000)    /* 100 ms */
>>> +
>>>  static bool has_localevents;
>>>  static bool has_recursiveprot;
>>>  
>>> @@ -1384,6 +1387,8 @@ static int test_memcg_sock(const char *root)
>>>  	int bind_retries = 5, ret = KSFT_FAIL, pid, err;
>>>  	unsigned short port;
>>>  	char *memcg;
>>> +	long sock_post = -1;
>>> +	int i;
>>>  
>>>  	memcg = cg_name(root, "memcg_test");
>>>  	if (!memcg)
>>> @@ -1432,7 +1437,30 @@ static int test_memcg_sock(const char *root)
>>>  	if (cg_read_long(memcg, "memory.current") < 0)
>>>  		goto cleanup;
>>>  
>>> -	if (cg_read_key_long(memcg, "memory.stat", "sock "))
>>> +	/*
>>> +	 * memory.stat is updated asynchronously via the memcg rstat
>>> +	 * flushing worker, which runs periodically (every 2 seconds,
>>> +	 * see FLUSH_TIME). On a busy system, the "sock " counter may
>>> +	 * stay non-zero for a short period of time after the TCP
>>> +	 * connection is closed and all socket memory has been
>>> +	 * uncharged.
>>> +	 *
>>> +	 * Poll memory.stat for up to 3 seconds (~FLUSH_TIME plus some
>>> +	 * scheduling slack) and require that the "sock " counter
>>> +	 * eventually drops to zero.
>>> +	 */
>>> +	for (i = 0; i < MEMCG_SOCKSTAT_WAIT_RETRIES; i++) {
>>> +		sock_post = cg_read_key_long(memcg, "memory.stat", "sock ");
>>> +		if (sock_post < 0)
>>> +			goto cleanup;
>>> +
>>> +		if (!sock_post)
>>> +			break;
>>> +
>>> +		usleep(MEMCG_SOCKSTAT_WAIT_INTERVAL_US);
>>> +	}
>>
>> I think this may be useful also for othe tests (at least other
>> memory.stat checks), so some encapsulated implementation like a macro
>> with parameters
>> 	cg_read_assert_gt_with_retries(cg, file, field, exp, timeout, retries)
>> WDYT?
>>
>> Michal
> 
> That’s a great idea. I agree this pattern could be useful for other
> `memory.stat` checks as well, and I will implement an encapsulated helper/macro
> along those lines as per your suggestion.
> 
> Thanks,
> Guopeng
> 
Hi Michal,

Thanks again for your earlier suggestion about encapsulating this pattern
into a helper/macro like:

    cg_read_assert_gt_with_retries(cg, file, field, exp, timeout, retries)

In v5 I tried to follow that direction by introducing a generic helper
function:

    cg_read_key_long_poll()

in cgroup_util.[ch]. This helper encapsulates the "poll with retries"
logic and returns the final value, while leaving the actual assertion
to the callers. Tests like test_memcg_sock() and test_kmem_dead_cgroups()
then decide what condition they want to check (e.g. == 0, > 0, etc.),
which seemed a bit more flexible and reusable for other cgroup stats.

Please let me know if you think this direction makes sense or if you have
any further suggestions.

Thanks again for the suggestion and for your feedback.

Best regards,
Guopeng

