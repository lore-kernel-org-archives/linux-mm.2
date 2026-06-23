Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3091CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:02:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA66E6B0088; Tue, 23 Jun 2026 05:02:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B56FA6B0095; Tue, 23 Jun 2026 05:02:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45D76B0096; Tue, 23 Jun 2026 05:02:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2B06B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:02:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03AF0C1E3E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:02:19 +0000 (UTC)
X-FDA: 84910586040.30.803BBB8
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf03.hostedemail.com (Postfix) with ESMTP id B76B320007
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:02:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782205337;
	b=CgFOfQoV7WR17DvVNTIGTwqJvCJtD9qEqSaBPiWnny5JWVm1QmRcuGxqzkgFUwyKNQ4Gzl
	0UFhs+cV2d+sZvJ8Ujhoa5sEkJETLtz7eEWDndYUmUxZ7PqAR2bMPzqZtiAG1iEGSEReFe
	pDsxtBozn3Hy5CZz/gIbIm8exDSQ4rY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782205337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LZ+TZqiuf5HF4ha+0i5puj/5GTQOohP4gsjbpzoMquo=;
	b=OzHWc03iMbpNeilsTqXG1hi25WGFP2938IukpWDBjT8D/Py50qGcy65tPbyVk6g+6GLHDJ
	Gi7s+FD4nDFrfOiAaNSh8nLlkc6uPLq8JuQdFVUuPxt3xAYbRtugH/0dbQ8vf87g9589hk
	H6DuSULAHMKK/I9X/fGpcTJ7KglGdQQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn;
	dmarc=none
X-UUID: 3740d6f46ee211f1aa26b74ffac11d73-20260623
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:ac3a88ad-107b-4d39-a542-fe20c4c244f5,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:ac3a88ad-107b-4d39-a542-fe20c4c244f5,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:96aa78bb5b78416de3ee6f8223da1cd9,BulkI
	D:260623164252SOOOWG2W,BulkQuantity:1,Recheck:0,SF:17|19|38|64|66|78|80|81
	|82|83|102|127|136|841|865|898|1209,TC:nil,Content:0|15|52,EDM:-3,IP:-2,UR
	L:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SP
	R:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3740d6f46ee211f1aa26b74ffac11d73-20260623
X-User: zhangguopeng@kylinos.cn
Received: from [192.168.109.140] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1118971230; Tue, 23 Jun 2026 17:02:09 +0800
Message-ID: <5be54565-00be-4c05-91ca-0825fa925167@kylinos.cn>
Date: Tue, 23 Jun 2026 17:02:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memcg: remove stray text from obj_stock_pcp comment
To: Harry Yoo <harry@kernel.org>, Guopeng Zhang <guopeng.zhang@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260623082614.81621-1-guopeng.zhang@linux.dev>
 <82703e62-4061-4241-b12b-c46b927cc67d@kernel.org>
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
In-Reply-To: <82703e62-4061-4241-b12b-c46b927cc67d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4j6y16cwg1r58g3qehmmqe1qtpi84cay
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B76B320007
X-HE-Tag: 1782205336-475077
X-HE-Meta: U2FsdGVkX19hgCRP08OSNtVLshGLNFGzfenHxNiaCdrZAj8r+eTp2vSGpd8piCD2rJ/1UpCurLf47RnHJZpc/zecnDJki/5zZwyjzqpjgb4rMotWWbF6LEm0I467226HKtJSZJ/p/eZBmhzgscxPX66NglZsgqPF//PL40+WUfKo4ahBSS3FtgbMK+KeKbjxISsk9bWepQHMtpdipgleITaB4sYuUCusFvfKNYFZqETsLcXBmCf6R4ix0KIvL6PGJ17Vd/CJycodz8in9MlAr1raX7mRFrSuRtUzm7S9kLUowyucaxiNVTs7mQ9HL3fthwN/BqSICa6j6oKJtZStkDYZbrMI8IeeZtI7gBQUECeCC1hEJq9j2DKZEv22To1rDfYcu06q5B2ersfQwBcNQX+q8F+ARiqxCS+OkpcI8okpwU+KyHFhX8XaP5knegitJiiwHCA+CEgSuiLbp3S/GrLkGB1M+xEudz1y7HSnnMmFLPY8XYyivwhGW4ts4kjOD1AkDKcwqgFm0MON2TTl8ZOsykBYezFwLJYPnHW6SS0gFppHGUNuoVRR2wj5dVBh3qzpMzXhQ3212qm0OhlY6KVSh7G6j8XqBQMGk42fff76Zkw5WCeWvQCIFXK7j9N5XmX99IhLPd7DnfPULcwQWZiJok3b7T7WmrQmWK65F596XmnPjZVm7UwDUORs0pkGkLiolLCANnkyI6KIn/IZ+75GMjNkmjxvuN9kWgYf/Nf8qy8DA7VJwrM+tSw89hixX8Ht1qrVWlKmXyNVEFObo0Rj12oYyq8aHPieZnIZartbyCLg+Cpejp4FK6dKSUhxuVoVEtDR6RuTHGWaQIqtDxHYqRTA/qG5akwfpy6+hiLfY7xMs3WxXcmlygNjjA+SpcsWBlOFKZAnVaANh77ZXk9NacMdCf9enqP1UrJB8kRBZMJiEjPRxG4mD3N3PJfZTgPUhTbaqs9+ADxJXo7
 d3HDpjF6
 JrOMO4YrPs36pF44RdmnjFxKxf7h1QS3YOxMzspiRJ4qyzMDfsZOR7nFkQ41MfePAkuahAWsQaWaDh9/4fwo92OHs9a45eIJXtVF4l7rtN7Igsv52qTjVwMHHqvq3TAPD03TaX6IuVi29TDXagyZTWbdqGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/6/23 16:42, Harry Yoo 写道:
>
> On 6/23/26 5:26 PM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> A patch filename was accidentally inserted into the comment describing
>> the nr_bytes field of struct obj_stock_pcp. Remove it.
> nit: perhaps add something like
> "Fix a typo in the comment (target -> targets)"?
Hi Harry,

Thanks for the review and the Ack.

Yes, I also fixed the "target -> targets" typo, but missed mentioning it
in the commit message. I'll be more careful about describing all changes
clearly next time. If a respin is needed, I'll add it to the commit
message and carry your Acked-by.

Thanks,
Guopeng

>> No functional change.
>>
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
> FWIW,
> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
>
> Thanks!
>
>>  mm/memcontrol.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 6dc4888a90f3..3eedfc4e84a0 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2039,7 +2039,7 @@ struct obj_stock_pcp {
>>  	/*
>>  	 * On rare archs with 256KiB base page size (hexagon and powerpc 44x)
>>  	 * keep nr_bytes to unsigned int as uint16_t cannot represent the full
>> -e patches/memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch	 * sub-page remainder. Such archs are not cacheline optimization target.
>> +	 * sub-page remainder. Such archs are not cacheline optimization targets.
>>  	 */
>>  	unsigned int nr_bytes[NR_OBJ_STOCK];
>>  #else

