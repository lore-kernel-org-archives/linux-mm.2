Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFF28CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 11:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A58C6B000E; Thu, 27 Nov 2025 06:18:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22EF66B002A; Thu, 27 Nov 2025 06:18:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16C216B002C; Thu, 27 Nov 2025 06:18:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0669E6B000E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:18:37 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9391BC092F
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:18:36 +0000 (UTC)
X-FDA: 84156139032.27.92F9404
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5563A1C000A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:18:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764242314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b64UkLlz6h3kb9bFVCc7wRdC3QGWwdO6JaI1se4sKnc=;
	b=4H+m6O8QmRq7b/GhWUQfjafITDactD1HPmlhNXpuZQMOy/NTVuEY7Qd6//3dMdtSFHhTjh
	quFpIGJWWevHJsFFM+WucwFiB2sxRrb2Evd3ID5+KkYnwQC16p2C9B+65TKxdcRyp9rbDt
	oObX8UVnS8nY8dhPFoMc9Pe6uhS3bbQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764242314; a=rsa-sha256;
	cv=none;
	b=vPO3x25+p39iXHsX1oGf+HUNbcDjTepOtvidLo5fUPpMe+XjSWvFoyJUgaNufjbkb5njT+
	4OxONw937yol7QsbnmNhaKXwQf8q0thErH1JwDCW5fuRA+ePGcxWbvej0dgX9obZhTL9Ra
	VyMtdSm/KeDxKZ1wkAESyIGNObCzrKo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn;
	dmarc=none
X-UUID: c7fe0a6ccb8211f0a38c85956e01ac42-20251127
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:ad6b010e-7e9c-454f-8d10-440a32aef2ad,IP:20,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-INFO: VERSION:1.3.6,REQID:ad6b010e-7e9c-454f-8d10-440a32aef2ad,IP:20,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:15
X-CID-META: VersionHash:a9d874c,CLOUDID:ac23435250749fcb68881771cadf2b61,BulkI
	D:251127185555KE68HCIH,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:1,File:nil,RT:
	nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0
	,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c7fe0a6ccb8211f0a38c85956e01ac42-20251127
X-User: zhangguopeng@kylinos.cn
Received: from [192.168.24.105] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1804284380; Thu, 27 Nov 2025 19:18:20 +0800
Message-ID: <07b9bdd1-3499-41a7-bef2-9428935fd3f1@kylinos.cn>
Date: Thu, 27 Nov 2025 19:18:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] selftests: cgroup: make test_memcg_sock robust
 against delayed sock stats
To: Lance Yang <lance.yang@linux.dev>
Cc: shuah@kernel.org, muchun.song@linux.dev, mkoutny@suse.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, shakeel.butt@linux.dev,
 linux-kernel@vger.kernel.org, tj@kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev,
 Andrew Morton <akpm@linux-foundation.org>
References: <20251124123816.486164-1-zhangguopeng@kylinos.cn>
 <20251124123816.486164-3-zhangguopeng@kylinos.cn>
 <8ce13061-b4a7-4474-9e57-bab9b1a62b63@linux.dev>
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
In-Reply-To: <8ce13061-b4a7-4474-9e57-bab9b1a62b63@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5563A1C000A
X-Stat-Signature: ct9rnmr7gooofx6fp4hekg81mgxgqxsc
X-Rspam-User: 
X-HE-Tag: 1764242312-818427
X-HE-Meta: U2FsdGVkX19OLQBeVZMyGgF6uiN0Ct1T5IYCpAMJe3eZBRlNSviRYz4BE4OaOmc0SAFSZ86N8r76clL3/X6AVtPz7qelCIU0GoeJHKlFa3b2I+aqY90Be9Yc1i4icXv16ofQpI1TDE0uF2z6Tl6TEdypbm56yjEgWGTb07vZUt5uOl+sFFE9waDD29Gih11OeQmrhhDf0gfAgcE/h16iRyy0AR1zfQVSCn/pzCxROMlTJ0q6REUZaIVPzgccWtSvoOE4GCEvF+GUzE2jfS2KBJAuH8HgI+d2YbNbFfFxy/9c+jlnDg6aOZ+ITQIY/FPXvN/eb3l5wqZjNRwk9kLobLN/gkcggMKcqL3Bu0TWsKzLVisFtV+YaDtL/Ju5ibiKFo/elgFIuwzataoj++x3TXdLPJ7/Rbfhh2KdgxE9nqpUJd7bLEpyFvjGSAopdHiXb6CLs4/TqAnXdBDOkans/8suWbYgedlJcrsS+19qXC8HDYZDexmStekMJlDX2q6bhmIKburlxph72R21ZbfNQ4W0JxPIz/L2rM6P8lPObE/20DaGP/3TvQW8c/2u5MqJldkvFDfU5uwlZQwVzOB7hyEjZgKOn2e9KnZ3TXAXY9V2ofl/yTT9BDgNiIFMRCS1OmEZx3bfLDosBGHU4WO2OLt59hB77LPh9tsHQOeKhOeQ5Vu0Z77+aBH8WF+Uka5gU2NqLuZZPTTuq3JpI5zyJdFs8uWf9BBPvYjPO/MPPc5E3hUtzCPBIXFK+Pm08AIRLI0YqJK6YxijNC9BwKMDv0YAWw1YPi58EgYAvnTbRMH0N+EwWnw8BIkPtedctktOMkYgP9BM4qDOROacg8RZMDr9u96nDiokPCpEOuTnG6BboKPIbKVPqJhBEiAvO3fNoxbxG3+/znTTY0nlLU4Ao87YmrN9HE3MeDNabZTDx7YPYDP9oZO7haGtZZhHkQegclfHciMfd0qhXpkGmR3
 GZ16Yzqe
 8nMo47jUBmd/eTDDV11BXWfyXTgNRlczLPrxOL7UhpnQx3sNotoJdPfRkhGboa7cTvxYQ9CJi/HDwjV1/UxLsg8dMROdxyivGOMMrUWUaldr4iW2K6XqAWmRMfepEUx1TphCHBToHInDiLT1DhkXPN5oNeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/27/25 18:55, Lance Yang wrote:
> 
> 
> On 2025/11/24 20:38, Guopeng Zhang wrote:
>> test_memcg_sock() currently requires that memory.stat's "sock " counter
>> is exactly zero immediately after the TCP server exits. On a busy system
>> this assumption is too strict:
>>
>>    - Socket memory may be freed with a small delay (e.g. RCU callbacks).
>>    - memcg statistics are updated asynchronously via the rstat flushing
>>      worker, so the "sock " value in memory.stat can stay non-zero for a
>>      short period of time even after all socket memory has been uncharged.
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
>>    - Before this patch:  6/50 runs passed.
>>    - After this patch:  50/50 runs passed.
>>
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> Suggested-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   .../selftests/cgroup/test_memcontrol.c        | 20 ++++++++++++++++++-
>>   1 file changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
>> index 4e1647568c5b..dda12e5c6457 100644
>> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
>> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
>> @@ -21,6 +21,8 @@
>>   #include "kselftest.h"
> 
> This patch fails to apply to mm-new ...
> 
> Hmm, it expects #include "kselftest.h" here, but the tree uses
> #include "../kselftest.h".
> 
> Which is odd, as that line hasn't been touched in years ...
Hi,lance

Thanks for your review.

When I prepared this patch I was working on linux-next, where
tools/testing/selftests/cgroup/test_memcontrol.c already uses:

    #include "kselftest.h"

I just checked, and this change comes from the following commit:

    1aaedc385b9b278dcf91f4e9d0c3e1a078804ff1
    https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20251127&id=1aaedc385b9b278dcf91f4e9d0c3e1a078804ff1

So the patch applies cleanly on top of the latest linux-next, but not on
mm-new which still has `#include "../kselftest.h"`.

Thanks,
Guopeng



