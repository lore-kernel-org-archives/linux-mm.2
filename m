Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE5FCCCF9E9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 01:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B716B8000E; Sun, 26 Oct 2025 21:09:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22D28000A; Sun, 26 Oct 2025 21:09:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E99D8000E; Sun, 26 Oct 2025 21:09:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 888818000A
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 21:09:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3EF7E1A047D
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 01:09:01 +0000 (UTC)
X-FDA: 84042110082.15.3197B19
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7D811180012
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 01:08:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=AdACAeN3;
	spf=pass (imf24.hostedemail.com: domain of kassey.li@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=kassey.li@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761527338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R5rflRvNSTNwiTDiRnQz4O15hv87Vo+TvuJsUzZcrRw=;
	b=esRoZSzMzmDujXbphIhHQDlAMoz40WlIodjmvFJhKU86ALND3PTlCBlEKAawrg4rPONQGz
	ZDQeQtpoj9ZTm48ZnB5q+09jz95oe+9uEyOYEKu9n7JfGn9QxYD5nJvc0JNt7psZf4Rq0+
	9YSDkfsnuPo81368VzUhXqcq3ncPmYU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=AdACAeN3;
	spf=pass (imf24.hostedemail.com: domain of kassey.li@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=kassey.li@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761527338; a=rsa-sha256;
	cv=none;
	b=atzeqLQqfWQ6vKx+DJYQpDo3fmBjwmE4ph+rhpEMzmShg9Cui8/jRoEFC6RNBCBbr+aLhq
	twuEeSMMSPNhNSbkDGXz2/uC81l14TmrdKPi1tqgyH2V2Q45cziAI9XxBHyTaCqzh6rqXc
	9JvIp9qnmBC0UWDX/iqfDsdD1AkYwSE=
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59QJTnYH588480
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 01:08:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=R5rflRvNSTNwiTDiRnQz4O15
	hv87Vo+TvuJsUzZcrRw=; b=AdACAeN3naoZ/G+Ocg/CbOYJCb6Um0SvBoWedHTD
	PazvjczvibqPM2CLxNf5UGbo83p9MCgtpZh37W5liKa/5qO12HrOgCtV4iUnwtmG
	JemWb+gMl1y1zGoeQ04GEVBKXSi4qWMVgQRPrTIAE65ZAFXfNH5MI0ubjK048oVq
	5FvZtYvIafqTbYeA81bkmVvFaJVFKx6R8PDFDWgU6kyk28NGjmyQLjt67PcxxVe5
	hyoXFk/G5B7Pr5B/12fuNf6JVqF1xOGjKACvokgUuq9JY2WJQZ942wFFo5VGgJBv
	HqZ42dPxpNnXrxSbm9oIarcu+yYW9y2lkWVH1AqN9A/Q5Q==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4a0ps12rpk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 01:08:56 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2930e6e2c03so41838575ad.3
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:08:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761527336; x=1762132136;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R5rflRvNSTNwiTDiRnQz4O15hv87Vo+TvuJsUzZcrRw=;
        b=oxsXaa2/MR9OnTgXiPigbPjb5uYCrF3kzDdKpwGw5hZzeGxK2Rwfry4rpLckcHlU/U
         c6rx4uNxKf64wghaO8ZHITBkJc8c+yU8zQZLMp3w20kgyEVCTHYOhdr0QxVelaG8WMcg
         XRxgSgIbhJLiCKROGtGsQZbdL/QOFMq/QYP5Od8jb+lxEvZ/B41FZtfc0afo8WqwE8cx
         fTtMwKXqibEAc8SD8emr93wk+78c3hyQxlgvVr8dMiMl/BUbv/v1hos6krl8CmBb0F7x
         nJq65Wl0CvMq4CT/7cjLb/7TMYxorNOqI5VVDCp5ibQ5HtZxROi7g28kWZybxKWA4K0W
         Wl9g==
X-Forwarded-Encrypted: i=1; AJvYcCUwHRGWZQWspW3F5UayXDVXlT/1a1j9KYWBJULP6jdgRw7BP+kqnDZHaOs5Okivn/be8yKXcocMQg==@kvack.org
X-Gm-Message-State: AOJu0YwynK2thj6EkyiSYq1R4QQ2FTpkz1B5ZDpLXUo57JZT02mTEgej
	fK5jAoAEJIqIZM5stBuAhpP11DDwgrMZcR7z1YgOG2ym3Eewm+PkTbh19Wl5JFMuTxSuhj5HqRg
	piooGaNk95QRdnaKV7bqrwCtxRvaLBWO/1KqlWSJCZGbRPeXzMSPstw==
X-Gm-Gg: ASbGncuhP7CBaidfyzfHywsgoCftx7iDslU8qRPD04PwW3aSkNR7hsI0nYFzmfdZLGS
	Xx6kVMaOqXZGI5yysVteZSkHFgoPb262FbllZI6xKfMZjwtwulFD0gMs5QyyFciqpS/Vl3ZZPBb
	avOGpxmbsFOeLZZDq9ZyOPwgtpK9Y0UagyDdOFbLmtnnkr0Vzq0KsfPkL1QQQiHpF9s8W7uOCzI
	SKwa5H7dKJ17EN3Uy/H84bld1MYu5tYMkyObUhphVvBbRQSylbZeenzag6L72ua1JJAumhDvUMR
	QusjEYRFiYVvuMmUVwJC4G/RQipXrIZiCEvHKwmapahG2FaH2dv2n57+BtuiBZEP0Tkv/Kat1Dn
	OSdahXktH4dWStVPyssv1gTZXgMZJ9kgvsV9kjm1zZRTi
X-Received: by 2002:a17:902:c942:b0:290:c5c8:9419 with SMTP id d9443c01a7336-290cb65b8e4mr459547315ad.48.1761527336124;
        Sun, 26 Oct 2025 18:08:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmaUSlndRgk4wRM1ZLY+xzoIB3GpdFwqZFoBB6jNy91QeUgZr8ADRAgWlskuMmHjRhXcXc4Q==
X-Received: by 2002:a17:902:c942:b0:290:c5c8:9419 with SMTP id d9443c01a7336-290cb65b8e4mr459546985ad.48.1761527335569;
        Sun, 26 Oct 2025 18:08:55 -0700 (PDT)
Received: from [10.81.60.1] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498cf352esm61087855ad.17.2025.10.26.18.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Oct 2025 18:08:55 -0700 (PDT)
Content-Type: multipart/alternative;
 boundary="------------6HJm9sW00g98swvwMMwZchq1"
Message-ID: <3a555a1f-873a-44c7-b7e7-ea83dd591b66@oss.qualcomm.com>
Date: Mon, 27 Oct 2025 09:08:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: add flags in cache_show
To: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com,
        linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
References: <20251017064839.585204-1-kassey.li@oss.qualcomm.com>
 <910a1d39-ca72-4e79-9f6d-66415794d9a9@suse.cz>
 <b7f44bb8-b12e-43e7-b870-f6499ae13e58@oss.qualcomm.com>
 <d1d729d1-2330-4710-801f-f007979abbcd@suse.cz>
From: Kassey Li <kassey.li@oss.qualcomm.com>
In-Reply-To: <d1d729d1-2330-4710-801f-f007979abbcd@suse.cz>
X-Authority-Analysis: v=2.4 cv=Ju78bc4C c=1 sm=1 tr=0 ts=68fec628 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=r77TgQKjGQsHNAKrUKIA:9
 a=EUspDBNiAAAA:8 a=u7tejvtZdTxe3_zVxq4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=04tRj30XZ7tI6QFgPwYA:9 a=ZCoGfTM_d3Y957dP:21 a=_W_S_7VecoQA:10
 a=lqcHg5cX4UMA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: AICJXoAXtStNFoIMmxieHVkFJdJQiGuD
X-Proofpoint-GUID: AICJXoAXtStNFoIMmxieHVkFJdJQiGuD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDAwOCBTYWx0ZWRfX0jiJ0BtyHXwA
 aryi5Xz5CcYI42pvIP2YOMrlwj6x4Sf8jSojEBz71D1myWg/24MXgO7DQrz6j5vh0jsJzlJzFUY
 pKA6oBKg5hdq12RY/Md3vZNFm4s1Mo7hlzvO89AleL50NZKwrWrGA32ltw2N7oJz6IqfNxo9i9K
 Kc06S8GQPFPb/2HY/8eiaikbKZ50nA1j3FhNKR39jUqxsEsTiZRV90TTT+lH+hiMky9TGHt8uXi
 3+21SCWSrsVKw6YQf8eZDs2yt3+Rs9GZO6awLc3in4I9SmR0P193Zrn7UL1TOCHn/Qc8gYnaVlk
 7NqZIOVOhHu5u5kPYsclSJAMFyHQYTQLMGez7QHF7Kg12OSa3cN01B91S4Q15T3bJpLKpoIqFMe
 iPuOTzarkdMjq3XRfLNzTdfXivl+cA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_01,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 adultscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510020000 definitions=main-2510270008
X-Rspamd-Queue-Id: 7D811180012
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1dmddg8rjxpwi3xem7yos18oehj8geg3
X-HE-Tag: 1761527338-607177
X-HE-Meta: U2FsdGVkX1/zz0Aw7XdrfSOb6G9GqpLvqM7m65J/4Eebu01asZAFSRV5yt+PYNmCE91mq+kkSC7dqErYIntE3UGXmu3ovL3ExZhFMYzCgPTleJpJvj19gaHHOAthuTc92w+vR4hkjNmEVxEuxjFiz2UQUorsujC6P9VOMGT8AmIxfhXIcA4g4kAq/sxJ/yoPAU4ZmMJQTUwRTOW2KsEJ4pl6D+7AwGPTl17oK48yjsVXr6TdO5H+rFokqfUlD2pM7fFPpmmkcmewSvuZRiyJ6wULL1RSBRd7JVlzHdQXC+fAwQlaJKYlPfqtOk1yWKr/imcdM3MryG2Lpx27skHPus9RdH4sgXfxBR2188Po9e4pvKob9lVv6wsAwyZ3V0ESpNk0g5lZBa/O0tAkLi0QWFgzTCiIf8xySqzZzbt7rVH4Z0CVMRN+7lY8tDTg56qYuIb+BM6/+Dv5irMAjM/7Kc5eB84/xDQA7VTNv3UwhT+QwiuMN4aK+wOV81ghd6NRqGTnxzOC0naciaahJ0Dbul6PybR+JOeF/Aukv50/3NlQQp6njSNzprmlvCBeB1Z7k5YJSyb3sfEZcks9hsKZ4ZZfHXioycsBqORfDi8GG6IQCv6itdj2fXU+F18XXiDsbUxQngkvRkKo7+Ab5GA42XLsL1hwqoGRP9+ksGK+k00m3IFMLdLVp2d5C8lrcF7GjyKjXq7CncZHy8oCwdyBz6w1GJdQy/hSP9FKqhbFsNqh0BI8pV/VSDp83iCK7EYapKRayE7yuFR8CjJifqKfqSxHANUZ2wm4Q+w/cN4XIm5658YVZDBLqLzct+uGJg5E5s+4KdVC+z80vvRGJQeNyISa07n2UZIX6b6DxRrZ7VmFwpf/C284Nldw9f/NwQPZ1m9PsHXtIPxFYdZBbTQCJTWPtdoqkAqS61fSCuxkz2PmicWAE3EjwxpSlvxo2UO7q3QZJfqf4UBWD2vf5tX
 NiOze/2y
 kEcL3PiwalvHZthqvjRxRfuNRUHELNs75cPikDSngvq9qWv5Ogjt5AfoEJOswtdCiR2uy56MRfVKgYYf9H8LucCW1m53Br4ccmSB94ikI/eCTG3gAk3dx62Y7Q8KqBrLhbn9rLK3z5aTk1bfZCtWdReiknPq0ySCE+6oi0aRPQXf2GPB4uaw6pXp1hbzFEu4sI4shn1VUSiACkA+8ioWiiPFOYdM36BM6GGq9MMf+Bh6pk2whWXqxHCT77aS4GSXKfBQyWneQNN1DDc0m31ZAPgXOnOtyTA2CatKwSvArDQSPloEuOftUhwDVtW1J0EqmQPviqIIh/6XtdwDZoErNcBdLiL1fw9bpUIbQSO+IN/KgBoVQTrZBbJO68tEfbP6LGCjVnlprdDI4UTl09WciBdh7IzyA7cua3/HEVRWEng5fWHjKdav9PIxLJJrcCvrPrc9GZYz8LpWhalDj1fGFNGsk6LrMghuDOAfhq+EBJhIg+WA/ZAeH2IiyDBTWVFxdhWx708zsf/aP3buO+AuiOtN/jx37YVT0UF6gKcaU4XX3rYhREbp9D36t6sZBNQAHylCfvYkr4LHMMawpA7qMNr81Z9wZrqgtP+sGKMgmkyEbMY9vQGUXDYZV6tZ+RDQOn33qooNMKBpjPAOMlaD4e7N6dg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------6HJm9sW00g98swvwMMwZchq1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 10/24/2025 4:22 PM, Vlastimil Babka 写道:
> On 10/24/25 05:06, Kassey Li wrote:
>> 在 10/17/2025 6:50 PM, Vlastimil Babka 写道:
>>> On 10/17/25 08:48, Kassey Li wrote:
>>>> Flags info is useful to check the slab type.
>>>>
>>>> for example, _SLAB_RECLAIM_ACCOUNT:
>>>>
>>>>       0x50100 _SLAB_PANIC _SLAB_RECLAIM_ACCOUNT _SLAB_CMPXCHG_DOUBLE
>>>>
>>>> Signed-off-by: Kassey Li<kassey.li@oss.qualcomm.com>
>>> Many of the flags are represented by files in /sys/kernel/slab/<cache>/
>>> If you miss some, we could add it there. Changing slabinfo output could
>>> break some users and the raw hex value is not a stable representation of the
>>> flags anyway.
>> may you review this draft change according your suggest  ? if ok, i will
>> share v2 change.
> What I meant is that that are files for some specific flags, e.g. the
> SLAB_RECLAIM_ACCOUNT you mentioned has a file "reclaim_account".
> Other files could be added for other flags when it's useful. Printing a raw
> number dumping the implementation details isn't great.


Thanks for the suggests, this is clear for me.  I will try the 
"reclaim_account" to match my usage firstly.

>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index b1f15598fbfd..619f446d2251 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -9033,6 +9033,12 @@ static ssize_t slab_size_show(struct kmem_cache
>> *s, char *buf)
>>    }
>>    SLAB_ATTR_RO(slab_size);
>>
>> +static ssize_t slab_flags_show(struct kmem_cache *s, char *buf)
>> +{
>> +       return sysfs_emit(buf, "%u\n", s->flags);
>> +}
>> +SLAB_ATTR_RO(slab_flags);
>> +
>>    static ssize_t align_show(struct kmem_cache *s, char *buf)
>>    {
>>           return sysfs_emit(buf, "%u\n", s->align);
>> @@ -9480,6 +9486,7 @@ SLAB_ATTR(skip_kfence);
>>
>>    static struct attribute *slab_attrs[] = {
>>           &slab_size_attr.attr,
>> +       &slab_flags_attr.attr,
>>           &object_size_attr.attr,
>>           &objs_per_slab_attr.attr,
>>           &order_attr.attr,
>>
>>>> ---
>>>>    mm/slab_common.c | 6 +++---
>>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>>>> index 932d13ada36c..f43239211e69 100644
>>>> --- a/mm/slab_common.c
>>>> +++ b/mm/slab_common.c
>>>> @@ -1083,7 +1083,7 @@ static void print_slabinfo_header(struct seq_file *m)
>>>>    	 * without _too_ many complaints.
>>>>    	 */
>>>>    	seq_puts(m, "slabinfo - version: 2.1\n");
>>>> -	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab>");
>>>> +	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> <flags>");
>>>>    	seq_puts(m, " : tunables <limit> <batchcount> <sharedfactor>");
>>>>    	seq_puts(m, " : slabdata <active_slabs> <num_slabs> <sharedavail>");
>>>>    	seq_putc(m, '\n');
>>>> @@ -1112,9 +1112,9 @@ static void cache_show(struct kmem_cache *s, struct seq_file *m)
>>>>    	memset(&sinfo, 0, sizeof(sinfo));
>>>>    	get_slabinfo(s, &sinfo);
>>>>    
>>>> -	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d",
>>>> +	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d 0x%-8x",
>>>>    		   s->name, sinfo.active_objs, sinfo.num_objs, s->size,
>>>> -		   sinfo.objects_per_slab, (1 << sinfo.cache_order));
>>>> +		   sinfo.objects_per_slab, (1 << sinfo.cache_order), s->flags);
>>>>    
>>>>    	seq_printf(m, " : tunables %4u %4u %4u",
>>>>    		   sinfo.limit, sinfo.batchcount, sinfo.shared);
--------------6HJm9sW00g98swvwMMwZchq1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 10/24/2025 4:22 PM, Vlastimil Babka
      写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:d1d729d1-2330-4710-801f-f007979abbcd@suse.cz">
      <pre wrap="" class="moz-quote-pre">On 10/24/25 05:06, Kassey Li wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
在 10/17/2025 6:50 PM, Vlastimil Babka 写道:
</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">On 10/17/25 08:48, Kassey Li wrote:
</pre>
          <blockquote type="cite">
            <pre wrap="" class="moz-quote-pre">Flags info is useful to check the slab type.

for example, _SLAB_RECLAIM_ACCOUNT:

     0x50100 _SLAB_PANIC _SLAB_RECLAIM_ACCOUNT _SLAB_CMPXCHG_DOUBLE

Signed-off-by: Kassey Li <a class="moz-txt-link-rfc2396E" href="mailto:kassey.li@oss.qualcomm.com">&lt;kassey.li@oss.qualcomm.com&gt;</a>
</pre>
          </blockquote>
          <pre wrap="" class="moz-quote-pre">Many of the flags are represented by files in /sys/kernel/slab/&lt;cache&gt;/
If you miss some, we could add it there. Changing slabinfo output could
break some users and the raw hex value is not a stable representation of the
flags anyway.
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">
may you review this draft change according your suggest  ? if ok, i will 
share v2 change.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
What I meant is that that are files for some specific flags, e.g. the
SLAB_RECLAIM_ACCOUNT you mentioned has a file "reclaim_account".
Other files could be added for other flags when it's useful. Printing a raw
number dumping the implementation details isn't great.</pre>
    </blockquote>
    <p><br>
    </p>
    <p>Thanks for the suggests, this is clear for me.  I will try the "<span
      style="white-space: pre-wrap">reclaim_account</span>" to match my
      usage firstly. </p>
    <blockquote type="cite"
      cite="mid:d1d729d1-2330-4710-801f-f007979abbcd@suse.cz">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">diff --git a/mm/slub.c b/mm/slub.c
index b1f15598fbfd..619f446d2251 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -9033,6 +9033,12 @@ static ssize_t slab_size_show(struct kmem_cache 
*s, char *buf)
  }
  SLAB_ATTR_RO(slab_size);

+static ssize_t slab_flags_show(struct kmem_cache *s, char *buf)
+{
+       return sysfs_emit(buf, "%u\n", s-&gt;flags);
+}
+SLAB_ATTR_RO(slab_flags);
+
  static ssize_t align_show(struct kmem_cache *s, char *buf)
  {
         return sysfs_emit(buf, "%u\n", s-&gt;align);
@@ -9480,6 +9486,7 @@ SLAB_ATTR(skip_kfence);

  static struct attribute *slab_attrs[] = {
         &amp;slab_size_attr.attr,
+       &amp;slab_flags_attr.attr,
         &amp;object_size_attr.attr,
         &amp;objs_per_slab_attr.attr,
         &amp;order_attr.attr,

</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">
</pre>
          <blockquote type="cite">
            <pre wrap="" class="moz-quote-pre">---
  mm/slab_common.c | 6 +++---
  1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 932d13ada36c..f43239211e69 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1083,7 +1083,7 @@ static void print_slabinfo_header(struct seq_file *m)
  	 * without _too_ many complaints.
  	 */
  	seq_puts(m, "slabinfo - version: 2.1\n");
-	seq_puts(m, "# name            &lt;active_objs&gt; &lt;num_objs&gt; &lt;objsize&gt; &lt;objperslab&gt; &lt;pagesperslab&gt;");
+	seq_puts(m, "# name            &lt;active_objs&gt; &lt;num_objs&gt; &lt;objsize&gt; &lt;objperslab&gt; &lt;pagesperslab&gt; &lt;flags&gt;");
  	seq_puts(m, " : tunables &lt;limit&gt; &lt;batchcount&gt; &lt;sharedfactor&gt;");
  	seq_puts(m, " : slabdata &lt;active_slabs&gt; &lt;num_slabs&gt; &lt;sharedavail&gt;");
  	seq_putc(m, '\n');
@@ -1112,9 +1112,9 @@ static void cache_show(struct kmem_cache *s, struct seq_file *m)
  	memset(&amp;sinfo, 0, sizeof(sinfo));
  	get_slabinfo(s, &amp;sinfo);
  
-	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d",
+	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d 0x%-8x",
  		   s-&gt;name, sinfo.active_objs, sinfo.num_objs, s-&gt;size,
-		   sinfo.objects_per_slab, (1 &lt;&lt; sinfo.cache_order));
+		   sinfo.objects_per_slab, (1 &lt;&lt; sinfo.cache_order), s-&gt;flags);
  
  	seq_printf(m, " : tunables %4u %4u %4u",
  		   sinfo.limit, sinfo.batchcount, sinfo.shared);
</pre>
          </blockquote>
        </blockquote>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
</pre>
    </blockquote>
  </body>
</html>

--------------6HJm9sW00g98swvwMMwZchq1--

