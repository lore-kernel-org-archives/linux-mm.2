Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8429C5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 13:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C83186B008A; Mon, 10 Aug 2026 09:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33C46B0092; Mon, 10 Aug 2026 09:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B219A6B0093; Mon, 10 Aug 2026 09:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8631A6B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:14:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 21B2E1A0178
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:14:55 +0000 (UTC)
X-FDA: 85085404950.28.1F04052
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id 624FA14000A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:14:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=DLE+tXq5;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf26.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786367692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ew4qmYHZIycQ1b32QhL8Lfq6hZJ47KLiqRijOxOPC0M=;
	b=7l9vC2uj4Y8wiTp9RtslnefJLgONzquwqM8SOQpn+kvC6Jv76Xm4P+UQDI3PrHYctH9QOh
	C559Hi1IluaMDS5ROqrSZzVGBsomfFUSyav7BDdXXK/iqSU3Dy8qncu5+9TuiToQ989IxB
	7s0qhKvt172jviLr0zb7PMMWJhp6vC0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=DLE+tXq5;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf26.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786367692;
	b=15lCk3g4fWvoSg9Ivn7RIviW7bC5xzI5NOce8m79mQhyM0+zBPHlJ6SwWsZHhi5JWer64/
	jkW2ktctpPMGkUO7B0o6Q7tL7zP9w7KWHnR7q0aUauZImW96w35ldH4F96V//TphWAqV/O
	DyIidY9NI6tL16VKmHuoAk3AXEqesCI=
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACbMgg3845080
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:14:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=ew4q
	mYHZIycQ1b32QhL8Lfq6hZJ47KLiqRijOxOPC0M=; b=DLE+tXq5s3oT8uze4iVZ
	LP7RJiSjXhEbg+EzPEFzbdzGldoC9Ja805fXHrpIJl/rpIR67b+XBHG0vXd0nDA1
	VHziaesYA9cz/yhb/sMAFHb9nDX/jH6+GNu5JnrotUyJz6g+Y8WGxEldaDGjJxzV
	HpEovKuWB/Zy2bxhtOMfH4LypWjXWrKSKf4YqjFJUhGdtprUAk5LdqsAwvHszgio
	sEnpAe4/sdiRetg/F8Pw54HU8XPZqVhDi6Na2yZCuIUfB2cbGzr7pyj80dWzQ3Sk
	nIfrJP+mBUASt6ogWoC/3UzhN2sd7gl5T7ZnD4SfWGFO0RluC7U5VK7j9Q8oDoYX
	aw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fxyb9b22x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:14:50 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92efd2ca21aso325135685a.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:14:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786367689; x=1786972489;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ew4qmYHZIycQ1b32QhL8Lfq6hZJ47KLiqRijOxOPC0M=;
        b=AMR1UKgHaZqvWk97yMmdYiiuD3i+28zJ2muDf4xVLuD8+sJ9wXiohNSZhRWgBtKjrf
         DaT8Ko3/JG3WD0HKJJ1RZ+aYwWPS/oOvjXJOPYDgJOJQGUM3iAqn83T68+ShFQUMkQvM
         hxbtBuuLjRE9K8ApyTbRCKuNodA86leZMIX6omx8KLSuTZFap8YsYbBX+Wg5klI2qlTk
         LNAZn+WYcoq2U1uHql1cHrKbGPfFN6uXOZPhD+HVjyGKaSPLakqQOuDMv47l1bSVyMPB
         7Y9jX6FiXxoFf68HN7keL4FEB6RKXUpWaaeqdq4f3uqMxYTFycI88YLFuD81lCvMb931
         65qg==
X-Forwarded-Encrypted: i=1; AHgh+RpDC6+5yu5GFzDFiY1U0ewDSob78pmU7yysGuzqFCumvUj1oiIVr3g3pwHHzDlSQJ0i+7V8+C7T7Q==@kvack.org
X-Gm-Message-State: AOJu0Yxz4yr2adaVdzTPGUzY07y3LunTmVqGWDuSQQMfsckFNX6EwRoA
	cwRb9+Est1d00mxAVRZluUj0c+syopZDIwH2cpOa+jcfi245TC5/8cKG9TD1QzxG2D6HQWSDXuj
	87DAPe3WCgsdS9kFc02jEgwN9jvL0vyRcsxHyKbEFWo29tpzB
X-Gm-Gg: AR+sD11lJU9jFODQ4/FPGwqTOcpQ0HrEvMd6MmwHA2ztlzUD00ZIUZDyfmVIb6Y800Q
	dYaXEvhlGou3iEIqbdtgQSWoCWF4jifBKicwfxuGlka6+4ij0Htb9hgrjkoT+yf5h3Cg+3UJK8Y
	V4yBjAkC/9Kc1DMYqahJ6geAAxGOdjOMJbK5Wr+mJgS8qphb47JR6rW0U2bKKjS0Z262UcKcdZn
	79mn7SyN+cqFB8pibVZlXYZuYPagd83+4ZeMob/CXgt7vvoqzFxfRbhqadonjb4vAurAXoVY3Aa
	QSoxMaaaLwZ1gdxRcrY/q/vS4sRFuqn00cCSOlAVlOe6rxVTBHUfG7PgBANnkhyNEfD1jnHOBth
	TEul25lP3HeikR0Ucbsq7Cd8U4eSVqU+9in9JrMJnqqUnxDy/r1lR0o6/lYHpyInl
X-Received: by 2002:ac8:6f08:0:b0:52b:4f1a:5fde with SMTP id d75a77b69052e-52d4bbae79bmr19560521cf.19.1786367689394;
        Mon, 10 Aug 2026 06:14:49 -0700 (PDT)
X-Received: by 2002:ac8:6f08:0:b0:52b:4f1a:5fde with SMTP id d75a77b69052e-52d4bbae79bmr19559721cf.19.1786367688959;
        Mon, 10 Aug 2026 06:14:48 -0700 (PDT)
Received: from ?IPV6:2a00:a040:199:782e:7d00:b463:d29c:a508? ([2a00:a040:199:782e:7d00:b463:d29c:a508])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995ea27ec7sm309907065e9.10.2026.08.10.06.14.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 06:14:47 -0700 (PDT)
Message-ID: <bc25141c-753a-4280-83fd-a7e2e2a2db6d@columbia.edu>
Date: Mon, 10 Aug 2026 16:14:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] mm/page_io: use swap entries directly in zeromap
 helpers
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett"
 <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-3-0899bac3b826@columbia.edu>
 <annJiayAzNA7kA6O@lucifer>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <annJiayAzNA7kA6O@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=QKxYgALL c=1 sm=1 tr=0 ts=6a79ceca cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22 a=VwQbUJbxAAAA:8
 a=VjhqdUCHYpRGtv9QOVwA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: BhM-ruSILZHNI_5ddCqv7RD7hj_1muQU
X-Proofpoint-ORIG-GUID: BhM-ruSILZHNI_5ddCqv7RD7hj_1muQU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDExMyBTYWx0ZWRfX6W6s15hn+j20
 2Gr8WIVWncGtaibdvCaRz2a/EQDjieEIHLa1WYW+hi1tFJGIMzDz+5Snr/AFWjSWK1AK2nXyYyg
 YSDWC7ksfw9sPYEQ9TSDyGUxTPs2BF3unVqcTW4B8Wvn+Wn56Q0+3lNo4y4z4XPdkBlyHkSCh9T
 bsjDcl/DktUZ9o0ngudoogxVn5FZWbNbIKZBAgEnGtmAQkQJGgJ+0NDg2z1kLuR/f7ZHhc3T8A0
 bI59/vvypR989lQ4TPwFq9y58i740peUTy9blmNdLeJywRoo9v1dcDfaABij8uDdcqf4HzXn7pI
 fH9gMTt+VbxTRB4iUtCa1Tay/A8zRnU84T/cpr4Runj4JruOy8Dc0Nygk/Ebg7gExf948xdP+bW
 kDImY2lfyEDMLBmUp85US4/PbaYKH2uLIQVW3OtW2Koxnna4SsbG1ihYnMLsqpT0oAvJ+6YdpqW
 62VzaAKsX+eYBcZ8uSw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDExMyBTYWx0ZWRfX38YQ1Wl5xjpl
 zgvGxvEhgvX82eQkcYtgCQMCJuxO+EQTnr8V0tDZsqAy9t8yAg8aujmJPJow/KaOJc0OBX1GCxk
 rmodQXePU1Vdjc/rebS048cLR/vfYEUYioFcIM6YfX3796oTPARC
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11870
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=10
 clxscore=1015 impostorscore=10 adultscore=0 suspectscore=0 phishscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100113
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 624FA14000A
X-Stat-Signature: 49tgcq3n55fjt4x466fkgxitbgpeoo9f
X-Rspam-User: 
X-HE-Tag: 1786367692-222150
X-HE-Meta: U2FsdGVkX1+ttv+1PDCN8rPSkkAM4Gbio5nlfmjfJj9eMYPDOEJbWfHeeah5fggiQYdBtaHqRAkvi/aLPQ+SBccX9oFQHbFKX1SwenhxKnTn5imPoAhKjVjI8/xBk7rwh7w60J9FtyPUav1gJMWS2iLoEUXAFpLJhJNTZQI9uzywWLibw/ALt0JSiWIYL+5qXIp/2q+3xpdoMxPfmvg3u4ib+QwEwe6CCyss6UNNPVqrlj9dN+tRkrU2tUoxMTKuz8cnqHx+cis09NEG1GN2OE2/98G9zLghShoa4BY3F6v9auhXZwsjmJiRTRcgn5xfLnecfXZxnu11oxN5u6PP1nQnx3mz9cl1OhVLUEh8ygAKCs1qANlQIPzIAakoIiDC6s+JPyoCfX6w5B1q803Y8tZJH0Z1otBwVzf3PQnAfGnc6/bHyfpLB7t2dFXsHehqeuwoMKyE4KPSqH+AIdFjattU43aUGdNmS7EOBKsy946guDW5jdgzd//F210sBYJsl9fM3GUyVOhLloA/0WrLKm9yaCYNIZcLwYU8f1HxU/iydEf6+qagQ82gmyHC2JdKGv8/xPteVQEslGccPxJlgsw93HEBUrPlcjOvv7YFFoEX6D34kV+cl5wlOJUZtXFgjgPaCNxRm7q9mhQB+5qa0YPAYqtSnfg6toSgEgFNyiS2Qg4uB/3Yb53GDb49fqLf8Zf3rOO9YRJWc0wOnJBPr4uWqepnZB5Nce8OMmoZYLtXPoGuS9ftfg6sv7+pGVHxIgKWZYkJJPe2EjhZvRgAF3jz3GStFsTauBBLpsDdVgOwdk8cTc4AMIXA+0cF7LHgxM7Qp8OXt/AqgL6VALC40IEdS1aF7Xu2IjLfDjqRhxePID5d9Q/UB5kavlUEZQ1ZG7Dla2+5YiRsrbNmirwHisP0uDt6S/ibsBav098ULrAo6slaK2ZT1C6TYgdxthx7v/hVhbQQdqhsy3zkDI+
 k/NyINa/
 z1HVh7tz9aQrEF1HPr+H7mfWz7lGGEK/MqKJ6baEw5pbyj+OADjER7Aeq8XK8zIjfzBcSE7so/8o24KsMWkvsWRHP7UDOcf1WESfaCbDJUrZ56VrE3qLKBnHqYGzuUIfgPoUTa0y3RWAesvqb6w/VywiAm+BZW3d686ndUmC+bqqs6LzVhuAkfkxhUNwrRDrGqb2zCkzfhG9La8i0to5o3VZ25Wst70iW9HdqePWwIfM5CV2vntIay7nuWjnvBR+L0F09i4xHi6V0pn4A3sb5s4bz2r/Vnfw0uQpjoajE479+U3nHau7U480+fcJgDfNd2tIlk5FoNnW1jRL5+Qc1h4o+WAZP+W3HKdxKMevjupFWp3pwcfolYRlemPtB/ATL9e631oJv5J19Wz8+/X0zI5T5Hghx2/zhPsa0dT6uQtLsD5uv5w5v3I0g1y9v1vSMDl84qRylZXO4peRDy3n+rT+r6sme7T9/lUAdE2H3XGhaquv+HDAw1SkhET68EMD/akifviNJ58RTkEgXZbdIznb62LR/N7GfZf06CGDu6FrBkosamvNIpGdt91Ju8z9yJIAc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/10/26 8:55 AM, Lorenzo Stoakes (ARM) wrote:
> On Thu, Aug 06, 2026 at 06:55:35PM -0400, Tal Zussman wrote:
>> Increment swp_entry_t::val directly instead of recomputing each entry
>> with page_swap_entry(). This removes the last struct page usage in
>> page_io.c and saves one call to compound_head() per page.
>>
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> 
> Lord I just looked at page_swap_entry() and... yeah. This is an improvement
> thanks :)
> 
> I haven't looked at the rest of the series so maybe you already did it but I
> wonder if we could remove it altogether?
> 

Indeed we can - I have ~7 more patches which do exactly that, but they're more
wide-ranging (rmap, zswap, huge_memory, swapfile, arm64 MTE), so I kept them
separate from this.

I believe Andrew is planning to pick this up post-rc1, so I'll probably send
them out then since they rely on some of these changes.

> Should we rename page_io.c to folio_io.c now? :P
> 
> Anyway LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 

Thanks!

>> ---
>>  mm/page_io.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/page_io.c b/mm/page_io.c
>> index 43b4383a4729..c6d0949b3f1e 100644
>> --- a/mm/page_io.c
>> +++ b/mm/page_io.c
>> @@ -159,7 +159,7 @@ static void swap_zeromap_folio_set(struct folio *folio)
>>  	struct obj_cgroup *objcg = get_obj_cgroup_from_folio(folio);
>>  	int nr_pages = folio_nr_pages(folio);
>>  	struct swap_cluster_info *ci;
>> -	swp_entry_t entry;
>> +	swp_entry_t entry = folio->swap;
>>  	unsigned int i;
>>
>>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
>> @@ -167,8 +167,8 @@ static void swap_zeromap_folio_set(struct folio *folio)
>>
>>  	ci = swap_cluster_get_and_lock(folio);
>>  	for (i = 0; i < folio_nr_pages(folio); i++) {
>> -		entry = page_swap_entry(folio_page(folio, i));
>>  		__swap_table_set_zero(ci, swp_cluster_offset(entry));
>> +		entry.val++;
>>  	}
>>  	swap_cluster_unlock(ci);
>>
>> @@ -182,7 +182,7 @@ static void swap_zeromap_folio_set(struct folio *folio)
>>  static void swap_zeromap_folio_clear(struct folio *folio)
>>  {
>>  	struct swap_cluster_info *ci;
>> -	swp_entry_t entry;
>> +	swp_entry_t entry = folio->swap;
>>  	unsigned int i;
>>
>>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
>> @@ -190,8 +190,8 @@ static void swap_zeromap_folio_clear(struct folio *folio)
>>
>>  	ci = swap_cluster_get_and_lock(folio);
>>  	for (i = 0; i < folio_nr_pages(folio); i++) {
>> -		entry = page_swap_entry(folio_page(folio, i));
>>  		__swap_table_clear_zero(ci, swp_cluster_offset(entry));
>> +		entry.val++;
>>  	}
>>  	swap_cluster_unlock(ci);
>>  }
>>
>> --
>> 2.39.5
>>
> 
> --
> Cheers, Lorenzo
> 


