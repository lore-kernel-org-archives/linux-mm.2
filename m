Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8370CCD193
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 03:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B72D8E0034; Thu, 23 Oct 2025 23:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8674E8E0002; Thu, 23 Oct 2025 23:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72F9F8E0034; Thu, 23 Oct 2025 23:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5F4C38E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 23:07:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3616D1299EE
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 03:07:30 +0000 (UTC)
X-FDA: 84031522260.18.DEC3462
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id ADBED2000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 03:07:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="HvzaN1/E";
	spf=pass (imf13.hostedemail.com: domain of kassey.li@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=kassey.li@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761275248; a=rsa-sha256;
	cv=none;
	b=Oo0Cng5Utaq2I3tPcaP23/cu0ZV4xJh+uBbKiHxD0qS/XmKwh6IZdOwJmaFqARa5nMdacv
	wlb2mM48yoW5H29JiXzwo2J0WDb/U1mGuyjj1+Xn/HwxDM+BD7KOSgqTV4UVkC+SIotK6c
	H68uBA/52y1IpQGXJ8c4blsOwAjciF8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="HvzaN1/E";
	spf=pass (imf13.hostedemail.com: domain of kassey.li@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=kassey.li@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761275248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P5am9cIwdsyXY0VIFsQ7HOlbX35yaubT05poJPGxdS8=;
	b=5rx7lChiyU0C+G49Hz1RQz/QLZYXMn0wGXUffyiFaQAnU+qrJvVng4lK66dbAI/TxzVrkr
	EYSjkVLwPMqjOjqX49IGpXv4Et2T3mBn1nc31h/maqmCfAxLbyX2T7NTau3mAeaotdi5tQ
	MAGs5HGoOVkEyz7OcVqElIxU2GhYeTE=
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59NEm2J4010377
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 03:07:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	P5am9cIwdsyXY0VIFsQ7HOlbX35yaubT05poJPGxdS8=; b=HvzaN1/EfOEjR2LI
	AdQ7hAWcvYxxkJhuP1u/S8kRTBcl5NYkrz2UTPpJVLDxIEklY12lRbhBQkvJnv0Q
	6zcm0C89uCRyGzfy8j2jzk7JA5qTmzcuN5snTy+rNR+aUwiMMrSN1+B9jKzDJhDz
	bPCGjx9LQdJA+U9U+fnKRd9e+Zlb5dzgBQeRDWQWtV1vg7NbnrQNNgVd7Kzahx3i
	nhppfkE82nXRUcmsN8oeSWhMYHwZ3EPf21xnVWkBRTUwgh26PiQg8/Eyv1uZrQ55
	6E5rn9bHOzxHI3wc3L97wF1zhE5VktGzeXMlhp85qjrN1jC7mLwZ6K2vJHVsOMf3
	AJNYrw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49v344an8h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 03:07:26 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2924b3b9d47so14656305ad.0
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:07:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761275245; x=1761880045;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=P5am9cIwdsyXY0VIFsQ7HOlbX35yaubT05poJPGxdS8=;
        b=YooOdS7iK+X3oIgF/mxndRQcAStNEzT/vWDbdWpeFFlvAtvflMN2GiGcn7pKsQZOkp
         lPvV6GxrYthE9xAaw+7p2bQsRta9aH+panCEK5qeNmGYmNOjEMTxvwX8tgrHAqWMJirc
         jjeqYZbAaZknwO+TsRTSUO4A1UB1IrtfzD4Op7hkVIz/QCsk2Kx3ngEV41HuwSOWEZ3q
         Nu/0bxQPNb3HOs5lWuduuFqhnvqIlSINvElbX4hmkr4bILUugqpPQYHZjZontYjspTgg
         mpX0R1I57DFH+Eb5b1ptf/aQ0/CjJllUi6tjumCXijS5WD3WRPU5SBAngo8mnxfYvz9/
         pCvQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1weV4AdJpIg0iZEyjfccgNOda4fmx8bxyiamI0UaEBlbogkb7Vgd8ZR43Rr3Tra+Gy4I4BRSMcw==@kvack.org
X-Gm-Message-State: AOJu0YxUHBvOXHLs60oz1jA5/p8KUzNHm6zBOHRCTr8qt2wD/mviuKmi
	knsIXrvkCu9ePlamqM0H1Rl+8jR02pQraWQtwonUhkp116G3P5b92TcyXRbbdwobJSOX14dbciI
	qQF7qiboBd8X+NWs9f5/ocgSlze5JHxlYIQRszdggGgBciPL9xaOlJg==
X-Gm-Gg: ASbGnct/lMxTppQ4Yw7sIpj8epHzIgCH0yv5i/NioyJzhl5K9wm+LEkwNUuAXkCgqw6
	/gjSIcn+cYTfVFb6/yfgMzfGH4XMxnkvCIkIIK4oHyYA4dxKMg/1+KqouvuN8PFZN0vNlR1NW1M
	xlENX9lwNo2NMV2HeWXowsXs4lxY2Bs3gs//a2iFsrd/DyKB0BihnIbP3MWTnpdBT0OkmwlmwnL
	AXhDo4f5Wgcfwqn6Ys37X+zyKpuJoAKvvWJNaCF6JW6x47X+r0W6fllmzKNnEOqjQ/R4cF0C98T
	AJQPDkGx6L8P92UEwFF4kXQdG2vM4oE5ukVCLR1Xx+XxdW6TY2IMOEnrcEIhLI5Y7ndcsnt5dI+
	uTN0GeDK2SFQ5Q7w5NqXSVbO7R+Wwxd38kl10hqC4S/nS
X-Received: by 2002:a17:903:46d0:b0:267:9931:dbfb with SMTP id d9443c01a7336-290cb65c642mr331251395ad.54.1761275245121;
        Thu, 23 Oct 2025 20:07:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3hT/5IHicpEX0vzAdNXzjs8PnqWwhcmBGRNi1I4wu55KZqXrQ97k30+PpTa8qlbH5TEhPnw==
X-Received: by 2002:a17:903:46d0:b0:267:9931:dbfb with SMTP id d9443c01a7336-290cb65c642mr331250825ad.54.1761275244535;
        Thu, 23 Oct 2025 20:07:24 -0700 (PDT)
Received: from [10.81.60.1] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946ded7c8bsm38971875ad.22.2025.10.23.20.07.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 20:07:23 -0700 (PDT)
Message-ID: <b7f44bb8-b12e-43e7-b870-f6499ae13e58@oss.qualcomm.com>
Date: Fri, 24 Oct 2025 11:06:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: add flags in cache_show
To: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com,
        linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
References: <20251017064839.585204-1-kassey.li@oss.qualcomm.com>
 <910a1d39-ca72-4e79-9f6d-66415794d9a9@suse.cz>
From: Kassey Li <kassey.li@oss.qualcomm.com>
In-Reply-To: <910a1d39-ca72-4e79-9f6d-66415794d9a9@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: hUeduWO-Qw6gt_B_L3lK6ajTnStPr4aO
X-Proofpoint-ORIG-GUID: hUeduWO-Qw6gt_B_L3lK6ajTnStPr4aO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX00izGaQqrW1C
 J1tHnfr1Ed2iyBieA0l859s8N2snIvFJyCqzEhi9laqUaTssPhBTN8FCB+v6mkYFyiTT41unudx
 T/3RNoqox+0n9hqKpM+rQJFnItcyDMKgEP2sYixnKxcBQeowM5fgMpUSh5leAKp/5nkiwNCNuX/
 UccTsRORPURqgVSQ5jmfZP9bdLC8uDfmQjL1II/sbCfcxKhcsiLYbwDaJNqcXKbRRQXpqJjFwZ7
 33tR06s7Be6+ooCUh+o5G2tUkCPBmxqOZvA0NRzYVeXVKs8HU/bzpoUVG6h7TbNK9DTli3Mu8mY
 MngOocRpksLAgoadRzLutg9aVNzUHIUYe/grSAFRnBPv3W/LtS1TFEKVWVS0YLt/Ku3bdeOVwE4
 nqo9eacoxPcqsC2yFXvyIEFuyLNzHw==
X-Authority-Analysis: v=2.4 cv=E/vAZKdl c=1 sm=1 tr=0 ts=68faed6e cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=cU5A3ohShU3V7SrR5iAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180023
X-Rspam-User: 
X-Stat-Signature: h86biqjek6a3sjy38kuhawaf8p734p74
X-Rspamd-Queue-Id: ADBED2000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1761275247-926931
X-HE-Meta: U2FsdGVkX1+JirkMwCmfntwN5GjzfKUbDedBWsi8XDH7KxlWR4oDnuQsvNqfJ1VqtNKOPY3giGrbgVW6hhGW6RZ0v3UmFOZK2TUxwsczCoqGKuiv5rCC7VRwHd2bUmFt0Z4E/wWUTmogWp5MQeiKwfOrILz9KnIgtur12sVCwouTkDp4bR35YgPJTZRZWJqVunochEo4WJMWFMkSE5rrD5rkc9IrQR4xrGaMSEcpPj5B4QulkGab/CxU3dxXM7xP1v8X2ySZDKC1+a9m72sS7V2y+SlX555YGjcqBaVom+9d8rDyWiOzwIiJWq1GkVT1XqTl13ZnUS++Q9ack2mQBKiHyZoNQAPEm4+1yAUqLbjxamagbYwmN4mwDJ3e6NZIQbcPbap0iCLfHDphYbLrVXLzvNuXNlRXaDlqY1RZGN+0+/h8l5XimYm0gFyoqwN83t1/m6kLjABFBmVGQoF6Cg2uNxCPvLI2oSpDI0FadMdgOC8cfLf4io5GRqzV+Vbf1/cIMkfkAULlbXFNAYJ2jxtiLCdkWbKssJuZx/TOj82FA2+hXgnylmsqoCT7sfWH07ulFFmCcqgHDgJe9+X1aI42ZQbSa0k0CZEcBXhiwpNY4c4V04MwTcCLE9PwHVy5GljuOzL9puC9gh5eWXwWwsUMeQL7GnRv/Wo4hmcI8QxBQ6tUjMj7sM5XXtikoEbeoKiPlGwROxHCbQxXW3CVSgO3eqi4w9Q3RUyzZlPfZIJhiFwb0z5b9LH9BkbJ4RCwq2GZpbG0r+c5BOsEPa4/VT82qSQxWlHcqffeDgjpCA5hrIWwe69l4OamKx1huVWx4UXrC2yyMOgqwAL4d1IFWJOJOvtIcI1AJyCOuWGFv43ijpGgVYK2CbzZe8Jx9VOOZGEMxwpl55NdZhsmzPyJeOlGuum87/lK5PJhTkZlbvxhwjAvnCTQnzdf91mmnz3qRdiPF3KzTswr5fGmT0h
 GgitBOF6
 W7bz0/IBVyPvsIncXGq8Kv3zNLTAJ3uHZJXWwysu7FOOfNfJnv6ReTPLXos/K0tFTOZUZNJ6WLJuGezWSip+Xq/bsn/JdilQ+gEkcUJ07Awwb2LbjXZxmtPDtZWGC+CyopLvJmcts0Iq2VuOfrxjJaynS4tYv7c7956TCZF+tOdReiEVTXl0dZ9xqXX9hSisA+6vyGRUQ3yz8UqDmSAkxCE7wanB7tIMFxvKKZeiSiLRu84ScaTOeBfox2OVtrxx2kken1+OIlRDaFKGPHqSxbYW5KsaEyheV9VVH1dPDIvYN+8pJbKi7J7bQ2FSSfgpC+13XXAn9SS6f1jQBFiOBDh5wXzZ4X455HlACeizQTkXi1bRr4JoDb1kIr7kB/bKsZyXZvdBSJ96inYGkPOepU8idYIIag91pR9ZAMhDXONyASEO5jeOr4eAGPOVyaUxH7pt4jM1ySy0prOm+KOFinAovjXOer4LPtrHK+6vVydPLTmmgnV1bbD0T0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 10/17/2025 6:50 PM, Vlastimil Babka 写道:
> On 10/17/25 08:48, Kassey Li wrote:
>> Flags info is useful to check the slab type.
>>
>> for example, _SLAB_RECLAIM_ACCOUNT:
>>
>>      0x50100 _SLAB_PANIC _SLAB_RECLAIM_ACCOUNT _SLAB_CMPXCHG_DOUBLE
>>
>> Signed-off-by: Kassey Li <kassey.li@oss.qualcomm.com>
> Many of the flags are represented by files in /sys/kernel/slab/<cache>/
> If you miss some, we could add it there. Changing slabinfo output could
> break some users and the raw hex value is not a stable representation of the
> flags anyway.

may you review this draft change according your suggest  ? if ok, i will 
share v2 change.

diff --git a/mm/slub.c b/mm/slub.c
index b1f15598fbfd..619f446d2251 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -9033,6 +9033,12 @@ static ssize_t slab_size_show(struct kmem_cache 
*s, char *buf)
  }
  SLAB_ATTR_RO(slab_size);

+static ssize_t slab_flags_show(struct kmem_cache *s, char *buf)
+{
+       return sysfs_emit(buf, "%u\n", s->flags);
+}
+SLAB_ATTR_RO(slab_flags);
+
  static ssize_t align_show(struct kmem_cache *s, char *buf)
  {
         return sysfs_emit(buf, "%u\n", s->align);
@@ -9480,6 +9486,7 @@ SLAB_ATTR(skip_kfence);

  static struct attribute *slab_attrs[] = {
         &slab_size_attr.attr,
+       &slab_flags_attr.attr,
         &object_size_attr.attr,
         &objs_per_slab_attr.attr,
         &order_attr.attr,

>
>> ---
>>   mm/slab_common.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index 932d13ada36c..f43239211e69 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -1083,7 +1083,7 @@ static void print_slabinfo_header(struct seq_file *m)
>>   	 * without _too_ many complaints.
>>   	 */
>>   	seq_puts(m, "slabinfo - version: 2.1\n");
>> -	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab>");
>> +	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> <flags>");
>>   	seq_puts(m, " : tunables <limit> <batchcount> <sharedfactor>");
>>   	seq_puts(m, " : slabdata <active_slabs> <num_slabs> <sharedavail>");
>>   	seq_putc(m, '\n');
>> @@ -1112,9 +1112,9 @@ static void cache_show(struct kmem_cache *s, struct seq_file *m)
>>   	memset(&sinfo, 0, sizeof(sinfo));
>>   	get_slabinfo(s, &sinfo);
>>   
>> -	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d",
>> +	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d 0x%-8x",
>>   		   s->name, sinfo.active_objs, sinfo.num_objs, s->size,
>> -		   sinfo.objects_per_slab, (1 << sinfo.cache_order));
>> +		   sinfo.objects_per_slab, (1 << sinfo.cache_order), s->flags);
>>   
>>   	seq_printf(m, " : tunables %4u %4u %4u",
>>   		   sinfo.limit, sinfo.batchcount, sinfo.shared);

