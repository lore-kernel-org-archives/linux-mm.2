Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ACFEC5CFC1
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 08:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 675586B035F; Sat, 15 Aug 2026 04:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64CCC6B0361; Sat, 15 Aug 2026 04:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562436B0362; Sat, 15 Aug 2026 04:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30B7C6B035F
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 04:59:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E4D716032B
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 08:59:01 +0000 (UTC)
X-FDA: 85102904082.03.05B8A70
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf09.hostedemail.com (Postfix) with ESMTP id 946BE140008
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 08:58:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786784339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vajMF5qc8VrYH5oIndzXjceiwDO7TMiHevWsujwDkac=;
	b=sCacEGzqfbuy+eYz2DigKIZHYAyIVt/PS9akmaVcFaVThCpazN9pW8DhOu0vC04iWYI+l6
	IADMNrEe5U740BRfiB8hOIwvLzeI/CL6IfT4CNxBhLR+6JoCpDTTWeyZ8iaYxQBYT9PR2/
	hfnKcuRIZDB/RH25sydskEbTEMxbuzs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786784339;
	b=37V3vNkfKezLJcUhG+X8jDh3ndJtWCBsSGGjn8L3p32SW7wUMb907OTrE2+Bl+yGC3kxNM
	UXsvHekyFpJjmMBKV5166eLBp5+irc9Wzg+v3b8q12OOnemeIZVFVDPJk289BCUQWQK2b3
	l0UKneH9PyaFU0rlvOynvyc8/RzzCQ8=
X-UUID: 8757a842988711f19a56ed5b684f684d-20260815
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_MAILER_MTBG
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP
	SRC_LOWREP, DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:81c10f86-3d18-4866-af93-38883b8493ee,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:81c10f86-3d18-4866-af93-38883b8493ee,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:6f1d16ba5c230bba9e9d4b1eaa0da848,BulkI
	D:260812164107VZ003DXX,BulkQuantity:8,SF:17|19|38|64|66|78|80|81|82|83|102
	|127|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil,RT:nil
	,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8757a842988711f19a56ed5b684f684d-20260815
X-User: husong@kylinos.cn
Received: from [192.168.1.116] [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 603180630; Sat, 15 Aug 2026 16:58:48 +0800
Message-ID: <2e5a06b1-1a27-4bfa-8a7b-57121d5f5025@kylinos.cn>
Date: Sat, 15 Aug 2026 16:58:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: husong@kylinos.cn, linux-mm@kvack.org, akpm@linux-foundation.org,
 david@kernel.org, ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Docs/mm: fix THP policy counts in transhuge
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
References: <20260812080313.330413-1-husong@kylinos.cn>
 <20260812080313.330413-3-husong@kylinos.cn> <anw8ASKdPWW9v86d@lucifer>
 <6e4aae7b-2c71-4109-945c-6481efde3636@linux.alibaba.com>
From: Song Hu <husong@kylinos.cn>
In-Reply-To: <6e4aae7b-2c71-4109-945c-6481efde3636@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3ny5qz58q7w4e3o76unic5uu45ioujqe
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 946BE140008
X-HE-Tag: 1786784338-36347
X-HE-Meta: U2FsdGVkX1+N4LW5XJqpjslspcVgzNYmXep93KKMsZVI+h0NKyT5g9FYeDlkfXliIjs0mcFJJG4i7DE6nI5Nu2WY+bWxnrsDfgG6S3+NXzIjlEwNoVouvH8zzKqdZ8tjWypu2ljKAvokVwNSj9dCbz2HYnqT5vSnqCpyVp+ff3wvK+FaOpVhpMTeJUbyPofu6QzNwTNPRpggZNS+8/ZkbwUYd/bLQHPrEr8ZionEtpg2n5Acx+Vs7WQ2uZxuX96XreR5C08PnYgKq4NjpzU9l1tIK7/fsNcBTMQHcqsQ0fF0DhDt4tlDuCZS3egPFClEM+PW3zJbxz2nDFrmNFCcKETWC2If+9Oyv7x3l91MtK64paDMOdjf39lgiVdlGNiAABM9A5lPVFajgSng/rzdAsQM5o0wUu9bmnSzqSfBYfOfJZUSN0gMAWvvKVBmoVPSqI6KLIZ3Km9rylhBReCVxapBPFH+uzleTPVfDQ2/LAtvGcNdnNvkMbJJVrUDM2qbcn57H/ikHg4tO3cw4aa/YlDUMu1mgTN5bGvJ5G9WYVl3p7W+OltsWzp017WFpYy0GLKUMtzT972Na2WqC6p+D11nYXfd9kSM18AZrqKBUxwhUrWx9CPCw4TGp8vf03vBvWm6emmcFHv7ib4lehYygisIU3C7H1nQtj2BHyjGt+baIiLyGbRpfqjYXCmp2yuNy4qg6erJMt2mriWN7ZTH4g7HIwBP9uER6iie6qUuS2UhFteV0FFRcZbXSvDlP2dwTuoAISppDXXAb+MllUbMWvujj2Sq/M6l2GJCp5mrBOp+FjGdHmh9vJelKqZcJ6T7dLW5qGC84NOVAYXdNHrb1fAY4oW7ncka9wkGN439HU9+v7+yssprj2YVLyVKCdVsBu0tbhqYlN2AR/P8cJxw5rD+TLsZOt93J2iFcGUay0+BIjaJTiqAsdVDkxc7k2H08V7F4QCRXs1+yyhdyhj
 SlVQDdiT
 r6HYQ0XnWMKkZT2wx0m3gL32kBsDOCTdVtjym51OZXsLn3j+wRxdRS7Gk8xJ7QVIqgUEu3pcKKdSS2Bc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/12 18:52, Baolin Wang 写道:
> 
> 
> On 8/12/26 5:27 PM, Lorenzo Stoakes (ARM) wrote:
>> On Wed, Aug 12, 2026 at 04:03:13PM +0800, Song Hu wrote:
>>> transhuge.rst claims seven policies for transparent_hugepage_shmem= and
>>> four for transparent_hugepage_tmpfs=.  Both boot parameters are parsed by
>>> shmem_parse_huge(), which accepts six: always, within_size, advise, never,
>>> deny and force.  The "four" applies only to the per-mount huge= option
>>> (shmem_param_enums_huge).  Fix both counts to six.
>>>
>>> Signed-off-by: Song Hu <husong@kylinos.cn>
>>> ---
>>>   Documentation/admin-guide/mm/transhuge.rst | 6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
>>> index b187d618452f..72e944f49da5 100644
>>> --- a/Documentation/admin-guide/mm/transhuge.rst
>>> +++ b/Documentation/admin-guide/mm/transhuge.rst
>>> @@ -389,14 +389,14 @@ is not defined within a valid ``thp_anon``, its policy will default to
>>>   Similarly to ``transparent_hugepage``, you can control the hugepage
>>>   allocation policy for the internal shmem mount by using the kernel parameter
>>>   ``transparent_hugepage_shmem=<policy>``, where ``<policy>`` is one of the
>>> -seven valid policies for shmem (``always``, ``within_size``, ``advise``,
>>> +six valid policies for shmem (``always``, ``within_size``, ``advise``,
>>>   ``never``, ``deny``, and ``force``).
>>
>> I'm not sure we really want to advertise 'special' testing modes like this,
>> sorry. These are not modes anybody should be using in practice especially at
>> kernel boot. We should probably stop people doing that...!
> 
> Yes, 'deny' and 'force' are testing-only configurations and really shouldn't be exposed via the kernel command line. I'll clean them up.
Hi, Baolin, Lorenzo

Thanks for the reviews.

OK, dropping 1/2.

2/2 is wrong too, the tmpfs count was correct as written, and the shmem
part is better sorted out by Baolin's cleanup of the deny/force boot
param exposure.  Withdrawing the whole series.

Thanks,
Song

