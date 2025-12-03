Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08B94D116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 03:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64FEC6B000C; Tue,  2 Dec 2025 22:33:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627576B000D; Tue,  2 Dec 2025 22:33:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5644C6B000E; Tue,  2 Dec 2025 22:33:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 460026B000C
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 22:33:10 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE7CBC02B4
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:33:09 +0000 (UTC)
X-FDA: 84176738898.23.30C90A8
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf02.hostedemail.com (Postfix) with ESMTP id 39B9580005
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:33:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764732787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bkDFb/K5fwMqD4mPLo/QdmxFa9IhBvGjLO5I06Nqpus=;
	b=RRzhfROM9abDxrOyLJSCRuaff2eXDd1VoJJeNPQr8HN7ESXlWP6HMb3g3wn5aGgsDywUzo
	BWyh7vd/9zHOqJGeleh5wNeGA6frLJa/sgSB2h6TsSamOr8yr5SIMO4oV39fp9MJI5vpqK
	QPxOCe8G0FYc6MObxyYCT1vo2xJ6LJY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764732787; a=rsa-sha256;
	cv=none;
	b=jb8S2xqCC8I401o/pmwOq30GfY4d7M+SaCXO682Rqj2AO4ZQeH4JDYpTNRLjV2SlIgNsW7
	1JNMWgtCsNfGuOdfjivpluQgoAW6q5uf18CaR1qOKjGZgnoD7d+6qlqW86eDUhKezJrbxQ
	5zg8EXo2AivfdrNutzyzVsKPXfxhn70=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn;
	dmarc=none
X-UUID: c35bdddecff811f0a38c85956e01ac42-20251203
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:9a00bd03-6b51-4c8e-a6c4-06e0aa533551,IP:10,U
	RL:0,TC:0,Content:2,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:7
X-CID-INFO: VERSION:1.3.6,REQID:9a00bd03-6b51-4c8e-a6c4-06e0aa533551,IP:10,URL
	:0,TC:0,Content:2,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:7
X-CID-META: VersionHash:a9d874c,CLOUDID:29264af93e65bb32178012985f7e831d,BulkI
	D:2512030718596DCL6T2J,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|898,TC:nil,Content:4|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:
	nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0
	,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c35bdddecff811f0a38c85956e01ac42-20251203
X-User: zhangguopeng@kylinos.cn
Received: from [192.168.24.105] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1777734155; Wed, 03 Dec 2025 11:32:58 +0800
Message-ID: <d38858d9-3a40-463b-a38a-acb1cbf6ca3a@kylinos.cn>
Date: Wed, 3 Dec 2025 11:32:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] selftests: cgroup: Replace sleep with
 cg_read_key_long_poll() for waiting on nr_dying_descendants
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: tj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, mkoutny@suse.com, muchun.song@linux.dev,
 lance.yang@linux.dev, shuah@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251124123816.486164-1-zhangguopeng@kylinos.cn>
 <20251124123816.486164-4-zhangguopeng@kylinos.cn>
 <3p7o2cxir6yz4baonmkrzumklg5zx3oddhi7mqlmxu26j7ze33@u2mrvj6pqad4>
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
In-Reply-To: <3p7o2cxir6yz4baonmkrzumklg5zx3oddhi7mqlmxu26j7ze33@u2mrvj6pqad4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 39B9580005
X-Stat-Signature: y8kocftdzj85ty19k8b49u75zthpznrk
X-Rspam-User: 
X-HE-Tag: 1764732786-717095
X-HE-Meta: U2FsdGVkX1/B2eA9VXalpeeBSjFP22GY2sn79Ve7wusROKu4OB4eMW4p92zy2wBC0CiCmDospVogZPx7inSbSRaYkCfLojby2B+zdKoY5wT5wutT1uzfxxOdp4FebOGVCRnxTXnoUIV0LtnlsHpJbWJEoEXOcrvy38WOueLHyi31bOZ7OnD9uQZtxheOekBG+z6Mahd/vDDU3Zv6NrVopIxDr7D8LSMpiYQxlvIGFHFOsOX6DREmMWg/7KuKH/8N9CJovcKQG9CoVCrw9EZmoA7Y35W8K/9+bDJGfRgtFDzUtFHiiUfjZih06Ptb4YkwcfT0neYYHNylpdVVO1l2jM1ZImOfHvj7q59h4Kt7kE79Rhj8ZLDTKLfalY0MMKIxoWBnEufLZQ/4zO8L5xHn7PpwI0uVnO56eYuSCXQybcTF5bDTSDV7b01d0mEoKX6I86aXVd6uOjnPMC6XAJ+qziBYi3YXAigZlS5kwGEHQl6xtFS5oR2ZQgDgDfqHXJq7aMVgyZEYTyVYHUV1KBKOP/XzcP2tAcZ7HwCH63+q+/lpinYDDL5xHTGrhiUFu2K/Esq9X6MOfT4BGInR/0xfYZW/45S8Lvc25bql0/i0DZX0s2a3S1iQ8F5HkFa1rqbUmCG4Ja1pQBmHfnYzQp8cwJOrvBnmU2+DsZ3MpA8jCuZKNX1TQ6ObQC+HXMyR142EajDTYMpOYWtPo46S5tTi+DP/VlN/sKJQdivztP/RtvFzfYTA4UXzXo7VMsUSfLFDK48f5veBsUFG+mUZdmmLModSug+25IgUdAf9YL04bP/qMFH2QrZxsqxTRd3VBVqEqCdjWWAGa4G+FeYDKZEo+Me5Oaa11mOs/E5Yrs+wj8ssGKaREmjwgdLfXm/U1ZOdRJ26shAaWAJhk/7GqSTmQIjIUU+rLrTBfj0t+0iXjO1SHXu94s+HKyZK5la2kBXKo9VUwekKldj7gGs3dDp
 n3EeLCBK
 Xxhxmz6Sc4fqRV63Sk2cG/ZZAUqJsFfZdA0TGkAFKmWaVJPDecWxh+1+2maVwaFKGeCJQLnBnn9ETMbef7/W2JkCQUN2I1BkcQqMNfFdWwl3ED6Yut3OrXJVH6AEWP1OAvb86
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/3/25 07:18, Shakeel Butt wrote:
> On Mon, Nov 24, 2025 at 08:38:16PM +0800, Guopeng Zhang wrote:
>> Replaced the manual sleep and retry logic in test_kmem_dead_cgroups() with the new
>> helper `cg_read_key_long_poll()`.  This change improves the robustness of the test by
>> polling the "nr_dying_descendants" counter in `cgroup.stat` until it reaches 0 or the timeout is exceeded.
>>
>> Additionally, increased the retry timeout to 8 seconds (from 5 seconds) based on testing results:
> 
> Why 8 seconds? What does it depend on? For memcg stats I see the 3
> seconds driven from the 2 sec periodic rstat flush. Mainly how can we
> make this more future proof?
> 
Hi Shakeel,

Thanks a lot for the review and for the guidance.

The 8s timeout was chosen based on stress testing of test_kmem_dead_cgroups()
on my setup: 5s was not always sufficient under load, while 8s consistently
covered the reclaim of dying descendants. It is intended as a generous upper
bound for the asynchronous reclaim and is not tied to any specific kernel
constant. If the reclaim behavior changes significantly in the future, this
timeout can be adjusted along with the test.
>>   - With 5-second timeout: 4/20 runs passed.
>>   - With 8-second timeout: 20/20 runs passed.
>>
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Anyways, just add a sentence in the commit message on the reasoning
> behind 8 seconds and a comment in code as well. With that, you can add:
> 
> Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
I’ll add a short sentence to the commit message and a comment next to
KMEM_DEAD_WAIT_RETRIES explaining this rationale, and will include your:

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

in the next version.

Thanks,
Guopeng


