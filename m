Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0DB510FC464
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 01:28:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD3F6B0005; Wed,  8 Apr 2026 21:28:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1877D6B0088; Wed,  8 Apr 2026 21:28:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04EDF6B008A; Wed,  8 Apr 2026 21:28:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0D576B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:28:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6779113A88C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 01:28:56 +0000 (UTC)
X-FDA: 84637283472.11.BB8AE8A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf03.hostedemail.com (Postfix) with ESMTP id D4B8C20008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 01:28:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of liuye@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuye@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775698133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fG3vUXdSmo2WGx3hGWNA7uXxDPaWp8vAqmErULzV7Q0=;
	b=ZOhwJ2Q5u46STC6uiiYbtYCaevLIHy9HoGwHafr7cBHAHpMtni08UOW4Jj2aFQlXrPVXoN
	xeWIHIUJbJyp4DkrUD+ZKNpn2kA96Tvs2nF/JVfO/UUqxUhZno7QjNMKy85Y6P7+w1c8xK
	OjgWxdtSBCXS65zlhUS/DJjECFFu36w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of liuye@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuye@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775698133; a=rsa-sha256;
	cv=none;
	b=CzdOj8vaADZQwwnqarQgdOw1Kz93+To/+iTztpRh54IyfXs+aG88qlZwH7MkjAlB1nC3hf
	Q4v7ety8clvWIb0269mGsCENNGJTPPbopuL8c2U3z9ZbU41DunO/B6G7XsNDD3RdaOjV7z
	9cisiZNz28tPP6b4Ncftponq3NZSwkU=
X-UUID: 70c5364633b311f1aa26b74ffac11d73-20260409
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:0cd0473a-0e18-4636-a6ae-57e12ce8d091,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:0cd0473a-0e18-4636-a6ae-57e12ce8d091,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:3293540a95cda9289efaed8027899327,BulkI
	D:2604081834380YMLFPJK,BulkQuantity:2,Recheck:0,SF:17|19|38|64|66|78|80|81
	|82|83|102|127|841|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil,
	RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DK
	P:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 70c5364633b311f1aa26b74ffac11d73-20260409
X-User: liuye@kylinos.cn
Received: from [192.168.22.151] [(183.242.174.23)] by mailgw.kylinos.cn
	(envelope-from <liuye@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 2109130670; Thu, 09 Apr 2026 09:28:40 +0800
Message-ID: <ba16238e-abb3-4867-b7eb-82271345efe9@kylinos.cn>
Date: Thu, 9 Apr 2026 09:28:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: use round_{up,down}() for PMD alignment in
 madvise_collapse()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Ye Liu <ye.liu@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260408093534.2373007-1-ye.liu@linux.dev>
 <f92c31e8-0a1e-43e5-8d41-18a1b17f4e27@kernel.org>
Content-Language: en-US
From: liuye <liuye@kylinos.cn>
In-Reply-To: <f92c31e8-0a1e-43e5-8d41-18a1b17f4e27@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D4B8C20008
X-Stat-Signature: h6eq5gwkti1oqkgrpy8rmabw6ix368nx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775698131-948554
X-HE-Meta: U2FsdGVkX1+PeFOkdKVLpV0XIDyuFoC16ZsAxV4/MzKBq6QrWsmYNAvPlBOGM+5QonJSP+SVXuuCunQpycp+1yJxtAHK3FQDPCty/hZn/Sqrp4OMNFopBrmoJKG2R9U6DN/YFGHN3Dc4JirzNhMQGNUi7mtdlR2u8r+iD/rT0kc9VannvuBkY8Uv2jCG5s+qAdK2Mbq0bxFKkRriGY+vbCMPAyxqlVDPtFC+DWodnEUju2wWwEqYAQIUAhwKug+6gpw+3BdRm82KPBxJCdT1IgrliZ4BBLAvcnXWEGTy4FUUR3GiZgmUO0wTW08O7Sl1Yny49MWhQz7c9GB3Jp62SAkk0PeOfAERZlEA1Z+mfFJeDsjE4qqSdTXHAimyJ/pR+QR8savURVdP501yETD3XJo/yol+ujr6msMv/xDUTqw/kqxQWtg0Z0N4Xf1bxhkbFKYvJJNu4IoiKHihWggkxszFKP8hAt3d12Ha6kH7j0ShcZ3IruMdlTjUvLVNRcVtZ8Vb2Go7r2KgUq0+RkuBodV3jyrnrfxxj345l2/L/nPpvMcX294K1Am0JkxJFuEjkttU+30QhOOajtt8Qwp8ZBSdX0ruICJ1qAn4TnEaOrUFPgzkIUaI84mqcKTgcICeCgxz1NaG/O1/rt0Kw1K2Xxp4aguY8gcHAUGBZa1D+da0vGHw718pjVGFte2kJnhNWQVPtzHTBB/CytO6ApvIjBozuh+FqwUfSyNi2FMNjMVWTXzFeBecXxAotYSWOo5HKMXd+bRexqLjuAcKBU0tOD1+g776o9ow7DO/RFEbZRrsHF7arfbfc4vfQCG7O+XZ1x/0Vy7es6MvYEBcM206hN2KBuKzOb55ON4dRLamcqfVSZ2+wQkR1Ho0uDVgy7FLG5k/QZ/4lvQwifmdOUIcqmacQYZlNA2I7zh6TrPCgqES5+AamU3mwiVTSyINC3POjZ7AC1+d7sP/jTZR/Ge
 I0QROpml
 AuPWZazTAVDLAWP+Xq+jsN6l+16J6izyqpBqeVTDK+eSw0PidFnDHUvlzyWgZKgnlqLXw7RWyskJKFsG+utS9n0yfuR8Exl7vla3jZm0ywvryNR5TXy7r0G89laxZ0SN6YHdH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/4/8 18:34, David Hildenbrand (Arm) 写道:
> On 4/8/26 11:35, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> The PMD alignment in madvise_collapse() is currently implemented
>> using open-coded bitmask operations:
>>
>>     (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK
>>     end & HPAGE_PMD_MASK
>>
>> Replace them with round_up() and round_down(), which express the
>> same alignment semantics more directly and match other PMD-alignment
>> code paths in khugepaged.
>>
>> No functional change intended.
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
>>  mm/khugepaged.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 1e2bff40d014..80d0b7136b58 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2835,8 +2835,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>  	mmgrab(mm);
>>  	lru_add_drain_all();
>>  
>> -	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
>> -	hend = end & HPAGE_PMD_MASK;
>> +	hstart = round_up(start, HPAGE_PMD_SIZE);
>> +	hend = round_down(end, HPAGE_PMD_SIZE);
>>  
>>  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>>  		enum scan_result result = SCAN_FAIL;
> I tend to prefer ALIGN / ALIGN_DOWN when dealing with sizes + addresses.
>
Thanks, that makes sense.                                          
                                                                   
I'll switch this to ALIGN()/ALIGN_DOWN() in v2 for the address/size
alignment style preference.                                        

-- 
Thanks,
Ye Liu


