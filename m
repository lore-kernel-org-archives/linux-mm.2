Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 046E1CF64BB
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 06:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33E0C6B0026; Thu, 20 Nov 2025 01:09:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6F36B0027; Thu, 20 Nov 2025 01:09:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6816B002D; Thu, 20 Nov 2025 01:09:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0689E6B0026
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:09:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8B1B1A078F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:09:29 +0000 (UTC)
X-FDA: 84129958458.08.B761554
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf28.hostedemail.com (Postfix) with ESMTP id 013FDC000C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:09:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763618967; a=rsa-sha256;
	cv=none;
	b=Y4kP7nphj/yIwEN9ofXT9WURlz6+CgALJgjRE44xDzPyG+J0uFAPtvdN3kQpX1hMZW1H+Z
	WEV5sNh7Ac7gS1Y8vgizzv262fZ37BkSFVutsyBQT++Kr+APwPLhN/zJPZCn43eKS2d7uf
	BhCpntVw7M71ku+Yo6HcapuYIU3obUo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763618967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TqkoLjzuhr3Oq6LFprFUE3ghV/i4KqtFt/Es3a5aGIg=;
	b=Skmy7SN5CFy3vGpKNSa1S87ZoeJswYR4HXFZc/R83s4WcuXdGPXYh1T6O5lRpSnW0Y9USP
	m6OIvZsBpTMrtj8He3uLOC5L2X3kZBuiIVcQ7duF1cqJtavSe8uGUp7TBrhTMpYdqSZqn8
	4ltUxJcIHkbUTKeE9X0q6DGuksfDgOc=
X-UUID: 72d87d48c5d711f0a38c85956e01ac42-20251120
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:35555e7c-4513-473d-942b-10595bd58636,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:35555e7c-4513-473d-942b-10595bd58636,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:a52600f6b0d97fa4666b3ab345936255,BulkI
	D:251120134057RJ6KFBKQ,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|841,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk
	:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 72d87d48c5d711f0a38c85956e01ac42-20251120
X-User: zhangguopeng@kylinos.cn
Received: from [192.168.24.105] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 913754144; Thu, 20 Nov 2025 14:09:18 +0800
Message-ID: <2fda06e4-19ac-497d-8f42-73972bdd761e@kylinos.cn>
Date: Thu, 20 Nov 2025 14:09:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests: cgroup: make test_memcg_sock robust against
 delayed sock stats
To: Lance Yang <lance.yang@linux.dev>
Cc: shuah@kernel.org, mkoutny@suse.com, linux-mm@kvack.org,
 muchun.song@linux.dev, linux-kselftest@vger.kernel.org,
 shakeel.butt@linux.dev, linux-kernel@vger.kernel.org, tj@kernel.org,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev
References: <20251120031619.1828911-1-zhangguopeng@kylinos.cn>
 <5ad2b75f-748a-4e93-8d11-63295bda0cbf@linux.dev>
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
In-Reply-To: <5ad2b75f-748a-4e93-8d11-63295bda0cbf@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 013FDC000C
X-Stat-Signature: 47apcrbq8989phkbudby6m4crba7767j
X-HE-Tag: 1763618966-76832
X-HE-Meta: U2FsdGVkX19U+D82NuZeJtOwaVzXOFMJTfPUISSn6fPVNZHWTcZZa0rA39eDjUK2Ql51BW5bBt/Jnfl1rSuSQYeXL8SAPytkqSDQ1Kbz37rpUhiX8t9uqZOUUDdgEflLfdoYfmbtuX94LyvdfZvC+oMdZp+bjIgvcJFzdEniQ1vl6oV7s3Axc3Qr/Pzj2wVjmtbjyXbX3Dw/BG8Tt1+4APVhkPR9iGGXy65yjQVPj896MqHsPw7mRiuV5QDB0DL54UHOtuCtQ1Ag68jpz/JMv3DdknHn0ipg/7aScOSUtiert0q04GJ4GhqKbJ9xPaOFh7+N5NHYMuvZjohrVhhPmJy0QJBH6SdXxCZxPD6LHxZ33Ro8ipzfqiY+lr9/2Zp83wa442x9QlG8Kxl8sayLg9UoW3fsWB+qFvFqnguFdwO551Vqbl6wHcftwKEaIKRv0qL0Ctr+Nxg3D+5KBGKAFvSFwY5oNj45daL0hH3VHL5d06NJL8Tfhh8gNt8l8psOTNSEZUKaNnChfsH0tGSUkN8QUBinVVRV7NtTTodmosAFcsPom0jxbkQsH3446c1Atoq9NiHTSfDpMkoCtx6JBrKTG4P2iC4ry4rjHuCHKwROn5PbP7d7+EnrvNXrU1OqKY+X16udGwtBDXP+VbAt99yLwkknydU10LgwgdIEwhTDaQABSPUSDo+i25AqxWSHCXqb2+iW6n9qbF+YNpFyDP80cNOypRwJ1M9yZkcowh+W63GtLtBVn2IUKvekRZlqVyYFZdRx2+8YZqWyFPhT0ngKsSBVcaKxUGwykgNXwB+HPdKNVgvmtUa+NEqdr5HKr8zTFWdyWLEGQw+CixjM6hujmj/GpwKOzd7kkTvw9S4b/cLjYXeP+nUw6gIvB+rviWiPv4i6Ak3iDZ7LcHe6oWtz++c7+lxHQRMEiKp1evMufjHfkOa2OKsok8zlPd+SG520jAlICQzdw1lO0n0
 MxNhOu2G
 IgenSdeYpMzBhOyXUUXlzp/uFKlZg0mgbJIaDpepkUYFGQkgUsADP3dpvGgyeVKsQRK86gHNWDgHO4MLyb/b00Hdt5CwjmLHHpJL2Ekbvjtb6iOyxo92enSGTrGVKekW44gpZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/20/25 13:40, Lance Yang wrote:
> 
> 
> On 2025/11/20 11:16, Guopeng Zhang wrote:
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
>> Suggested-by: Lance Yang <lance.yang@linux.dev>
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>> v2:
>>   - Mention the periodic rstat flush interval (FLUSH_TIME = 2*HZ) in
>>     the comment and clarify the rationale for the 3s timeout.
>>   - Replace the hard-coded retry count and wait interval with macros
>>     to avoid magic numbers and make the 3s timeout calculation explicit.
>> ---
>>   .../selftests/cgroup/test_memcontrol.c        | 30 ++++++++++++++++++-
>>   1 file changed, 29 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
>> index 4e1647568c5b..7bea656658a2 100644
>> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
>> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
>> @@ -24,6 +24,9 @@
>>   static bool has_localevents;
>>   static bool has_recursiveprot;
>>   +#define MEMCG_SOCKSTAT_WAIT_RETRIES        30              /* 3s total */
>> +#define MEMCG_SOCKSTAT_WAIT_INTERVAL_US    (100 * 1000)    /* 100 ms */
> 
> Nit: Defines are usually placed at the top of the file (e.g., after the
> #include block). Placing them between global variables and functions
> looks a bit out of place, IMHO ...
> Otherwise, feel free to add:
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> [...]
> 
> Cheers,
> Lance
Thanks for the review and the suggestion!

Good point about the placement of the defines — I’ll move
MEMCG_SOCKSTAT_WAIT_* after the #include block in v3 as you suggested,
and I’ll add your:

    Reviewed-by: Lance Yang <lance.yang@linux.dev>

as well.

Thanks again!

Best regards,
Guopeng


