Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 525E6CC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7811E6B009D; Thu,  2 Apr 2026 02:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7588D6B009E; Thu,  2 Apr 2026 02:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66DE76B009F; Thu,  2 Apr 2026 02:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 546BA6B009D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:42:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF4F7160490
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:42:58 +0000 (UTC)
X-FDA: 84612673236.21.AD20699
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7820EC0009
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:42:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iA5w9u2C;
	spf=pass (imf22.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775112176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RPTO0DYaY/d8+WLZ/HWMNI0pPLF5PSarA4pYkxdO8nU=;
	b=dNPjMss6ais1WUX9X9HgqDLiC8+MnHF4ZMTrLG8c3+6qVldyDlHUxVZftezhu+XbzmP8t/
	Idg0Ee2gGWd+xx/UPRymHZcRs0WHpvQWK76mAb2NVVXguGiXPRPqiNMfwmLsRfmVRNCUJ6
	BJ9pDIW3QOD+C7ifDKUhnEBnD++/MGg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iA5w9u2C;
	spf=pass (imf22.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775112176; a=rsa-sha256;
	cv=none;
	b=M/zhq6eThOCItPQt4Ewdm9YJ4S5fdDbIoqs5wFHW2ndrBwblMKwBEC5upN4+v+11gDw8aL
	ywQ+Gea+cwbgLpWcdjjBQ9lEHKuYnSCUEV2kQkrQkgxTVibzIx/WoDv4coMqXj0f/yzQxf
	tEEjRgOOOMmxW73PBZHLF+4tvzL4Bjs=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6322dTke236239;
	Thu, 2 Apr 2026 06:42:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=RPTO0DYaY/d8+WLZ/HWMNI0pPLF5PS
	arA4pYkxdO8nU=; b=iA5w9u2CZZuqEdwgPuTLDVdva1NhNNCNLkXcqrZeTENTZr
	OfpHMTcGe7g/AuI5cZnAVJaO1BDOhA6QtBA/Qx7yWq3BoT1fb96REbO8wyH7B6AG
	DKlA5q3AxbOdW3KTKCLl1mFctCV/a6Xa5vfayUDG/7dzDiFzrLM4iuzPTySFRnBW
	qbxu9PN49j+oXpGr4BrjostoF2A2EqjTfTrlLe7mEcUZ9QILaPPDh+tJ69p/om00
	PjTRyAxjRgjN6n/dg/XjzSgS1uHvDhvAwGXMXZUQHA+YA9U6uWeRo/ZXzCTt+Rz/
	dbaZ8RYr5CDlZq4MfQuRl6wH4Dy147+3+CnDflXg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d66q3bk48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Apr 2026 06:42:42 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63225kVw008685;
	Thu, 2 Apr 2026 06:42:42 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d6v11rrem-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Apr 2026 06:42:41 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6326geAr22872706
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Apr 2026 06:42:41 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D86ED58051;
	Thu,  2 Apr 2026 06:42:40 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E58F5805C;
	Thu,  2 Apr 2026 06:42:36 +0000 (GMT)
Received: from [9.39.16.6] (unknown [9.39.16.6])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  2 Apr 2026 06:42:35 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------LspP04RDqWezW5Pn7kgxlFRK"
Message-ID: <6e58d73a-fd21-4e6f-b1c5-37dda7e006a1@linux.ibm.com>
Date: Thu, 2 Apr 2026 12:12:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: fix preinited section_mem_map clobbering on
 failure path
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Frank van der Linden <fvdl@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20260331113724.2080833-1-songmuchun@bytedance.com>
 <81857888-b6aa-4f04-bfd7-e9365d62669d@linux.ibm.com>
 <1ACF04AC-CC9B-4B29-8E3F-6609B5C1B09E@linux.dev>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <1ACF04AC-CC9B-4B29-8E3F-6609B5C1B09E@linux.dev>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: GdFtizFs75ZFdD075faTNMxTinhIm0gu
X-Authority-Analysis: v=2.4 cv=frzRpV4f c=1 sm=1 tr=0 ts=69ce0fe3 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=r77TgQKjGQsHNAKrUKIA:9 a=VnNF1IyMAAAA:8
 a=968KyxNXAAAA:8 a=NZoFHl13bqaJ-IwmEIUA:9 a=QEXdDO2ut3YA:10
 a=ZRGaOfixQ7KW42RQcCAA:9 a=WTK3bPQC7c9GO7MO:21 a=_W_S_7VecoQA:10
 a=lqcHg5cX4UMA:10
X-Proofpoint-ORIG-GUID: ghaV165Dd5E7jhx6j-um4nuUH6KENxmh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDA1NCBTYWx0ZWRfX0miuM9m/DlUo
 cjDhPq1TRyCLXKK/1Hf0lfGiu2It5SeRKk0DfgjQPjdNWAoXxnn+okxS3CCP5bIg/jDT+vcxaNG
 ejvIETdkWXDRYd1Mij0HTadUPx/XJ2eKwie/mwxgLEBRHM/AC54SKvFiwCR2z7Dhm2HVpZsz5eM
 L1b1nEOuERKcY8J12C4pM4qf8Calcx5944G3ZfHkYIXLhBn09cpc3YpYuKco1gFqjIWfik/k8K5
 Zpts0k5b8B28lEuUaqvne2zAdlEFnQmgLCnwkart2UBDD5rhTZn6BUYh3i6VbIOTMc6nQ+Friqy
 wF+DoHAetw7FJ87KBFHmhWbG+xitTdNqjhnPpn4M5gmT1FUih38LzolTonb3wkByZr97uphBIAF
 qpvod6+iAgwK8UP3oXpC+8ZYs2448qMOSPq257gMTfL9j8lfJMqGf0r8ixqVeZJEa82swQjesFW
 khu5e02lVUdEaLzTCPQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_01,2026-04-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604020054
X-Rspam-User: 
X-Stat-Signature: 4jrfy1zf6zpneohxaupfusjbyef7d4wh
X-Rspamd-Queue-Id: 7820EC0009
X-Rspamd-Server: rspam09
X-HE-Tag: 1775112176-391758
X-HE-Meta: U2FsdGVkX18P0OhvgTfm9uh8rUv5P4o4j0WC5X7kR3VEKEhLzieFNvskjXD42Sjq0aWL+KXQsrC4X5JhqUjXqS/11M4YvRxVubvW6vs37FSi3Kx3//2KDsfP0l6Q2jDxY+DuJk3LP91wOjF7JEivyA3qp0f3z9nHCYz8/zTz6zZEJ5lDqcXmRfMyYf21P3RQqaxI3bXXKSIN2oZ2ZeuAVOrBQj4fpyW9cpNCbhEQ8UoWYzfmLEDymPzXWUWhJk9mM/3Ds1QFxSNgtwMe6gVF0DEW0wTPi+mpN/DUxcVdg55zhalQw06hpWE5LUUuPOp/p8WuWqmiIGf0MDwb6bz0gXr2cPmwAJIVaQ4jGNs6YFM2XQjZh6/Uo99i+WOHPeGNu5KEXXTJLgLdCZm+yiQb1tK46BApgIB1GaNPUleNc5F34mJzWep73xAF0q0XLxdqnx6f3+tyDrqR0B4YyKsycZhznSpG+HxYSCdtNIi/P2tMJpvn/EXvWEoFlfflEBLqBdpzbB9xsZrqVbI96DnTf5vKU1N85nQpqlM+xcc4HU7yFJmHnIR12COxY9d2yaRrcZTNQAZ9LTp3USBc5acQYx68C1beEB0gnhxtlYdBTWGi5lRO+WdLk41Rp1lyZxzBBJeGIOjq37Zet1VhR4vRmrU/qK5yhX0R/QtUT3aiVfsjGVUUJ8pvkn3slsAmFBv72bXoOgd6nQGy4m6uRyXq3Py7tLFmt7wWP+MBzJa4lVc+t2Vz5qr5xm6AXo+XH3Kd31j0t1KDscxRzt99+Q5QDLHYQro1meirRpaPTJaGTjb5EmdlYD0TTo8IoaA/Dark6Xt4QrGHsedltvO2Uxn6qXHMBKy/r6Om8vn3sKik2O1TPVSaQA3YnuqpB/hBeJtSGFG9LwyYhngCZ1/j5d4KUH9wb9kERDMngNHhGrdHe5rMxbneDDehouXdT2vgyfBQdxjfDKBK2b1MahBi4sm
 X7Rv7X+V
 FKDSfRvsl/Z6vSjGbPfKsqHiPAmD6iZYSPTmT7c5zRorevk/bwwSgzYx5RFPQam0PKMsI+RNo9xlqA7B710025m49mzv00f/o2tl82SNOyMGgzqLyys9WErnhLVuno0wAnHOzieYui72u0x5UOldGB/WP1O3cvLbB3bhPzXlhycONh8rMZK6cievGVO56l5/c8EqfbNSSKEPhfnylalSX5M2ZN23E2VX4JzWTp5Z2OCSbUpng03zz3mkt77LclfAxwTMZS0i/V4V2s+p4pCK772huiBYlEaTBedJA2yWZoZM34Kw+E9fc6HIxvoblTj8GGr8EaIL7Qzw7j2RfEAMXXjmEh+rb58lWDTcmnTREjSqjMRAVcjYDGyg+6DQq4q/RGsITxt+zaoJ+UENc92jmWLMNpqsXpDFl0ghOjW9rPZKQAY5eVmbLnp9deVOxKCDCHey3258J+sBgMnz8os1vDo5CXwHvXmHTk5sSHvt8kgU6Wyd1Sn1UoLvls1WOtqcZGvbWF7UcGYL8Vthmbs5R+q+CjeXBvd/tSW7v04nLjR0eKJEBDIVqBBJAaRk7J4OVtI6F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------LspP04RDqWezW5Pn7kgxlFRK
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/1/26 7:58 AM, Muchun Song wrote:
>
>> On Apr 1, 2026, at 02:34, Donet Tom<donettom@linux.ibm.com> wrote:
>>
>> Hi Muchun
> Hi,
>
>> On 3/31/26 5:07 PM, Muchun Song wrote:
>>> sparse_init_nid() is careful to leave alone every section whose vmemmap
>>> has already been set up by sparse_vmemmap_init_nid_early(); it only
>>> clears section_mem_map for the rest:
>>>
>>>          if (!preinited_vmemmap_section(ms))
>>>                  ms->section_mem_map = 0;
>>>
>>> A leftover line after that conditional block
>>>
>>>          ms->section_mem_map = 0;
>>>
>>> was supposed to be deleted but was missed in the failure path, causing the
>>> field to be overwritten for all sections when memory allocation fails,
>>> effectively destroying the pre-initialization check.
>>>
>>> Drop the stray assignment so that preinited sections retain their
>>> already valid state.
>>>
>>> Fixes: d65917c42373 ("mm/sparse: allow for alternate vmemmap section init at boot")
>>> Signed-off-by: Muchun Song<songmuchun@bytedance.com>
>>> ---
>>>   mm/sparse.c | 1 -
>>>   1 file changed, 1 deletion(-)
>>>
>>> diff --git a/mm/sparse.c b/mm/sparse.c
>>> index c2eb36bfb86d..3a14b733bf71 100644
>>> --- a/mm/sparse.c
>>> +++ b/mm/sparse.c
>>> @@ -584,7 +584,6 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
>>>    ms = __nr_to_section(pnum);
>>>    if (!preinited_vmemmap_section(ms))
>>>    ms->section_mem_map = 0;
>>> - ms->section_mem_map = 0;
>>
>> This looks correct to me.
>>
>> I have a couple of questions:
>>
>> 1. As I understand, section_mem_map initially stores the nid
>>     during early boot, and later it stores a pointer to an
>>     array of struct page. In sparse_init_nid(), the struct page
>>     array is stored in section_mem_map via
>>     sparse_init_early_section(). If
>>     __populate_section_memmap() fails, we are  clearing the nid
>>     stored in section_mem_map right?
> Right.
>
>> 2. Another question: if sparse_init_nid() fails for some
>>     sections, there is no retry mechanism to add them again,
>>     correct?
> Right.
>
>> 3. when ms->section_mem_map is set to 0
>>     for a pre-initialized section, does it only affect the
>>     pre-initialization check, or could it lead to other issues?
>>
> Only affect pre-initialization. No other issues.


Thanks for the clarification.

This looks good to me.

Reviewed by: Donet Tom <donettom@linux.ibm.com>



>
> Thanks.
>
>> - Donet
>>
>>>    }
>>>   }
>
--------------LspP04RDqWezW5Pn7kgxlFRK
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 4/1/26 7:58 AM, Muchun Song wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:1ACF04AC-CC9B-4B29-8E3F-6609B5C1B09E@linux.dev">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">On Apr 1, 2026, at 02:34, Donet Tom <a class="moz-txt-link-rfc2396E" href="mailto:donettom@linux.ibm.com">&lt;donettom@linux.ibm.com&gt;</a> wrote:

Hi Muchun
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Hi,

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
On 3/31/26 5:07 PM, Muchun Song wrote:
</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">sparse_init_nid() is careful to leave alone every section whose vmemmap
has already been set up by sparse_vmemmap_init_nid_early(); it only
clears section_mem_map for the rest:

        if (!preinited_vmemmap_section(ms))
                ms-&gt;section_mem_map = 0;

A leftover line after that conditional block

        ms-&gt;section_mem_map = 0;

was supposed to be deleted but was missed in the failure path, causing the
field to be overwritten for all sections when memory allocation fails,
effectively destroying the pre-initialization check.

Drop the stray assignment so that preinited sections retain their
already valid state.

Fixes: d65917c42373 ("mm/sparse: allow for alternate vmemmap section init at boot")
Signed-off-by: Muchun Song <a class="moz-txt-link-rfc2396E" href="mailto:songmuchun@bytedance.com">&lt;songmuchun@bytedance.com&gt;</a>
---
 mm/sparse.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index c2eb36bfb86d..3a14b733bf71 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -584,7 +584,6 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
  ms = __nr_to_section(pnum);
  if (!preinited_vmemmap_section(ms))
  ms-&gt;section_mem_map = 0;
- ms-&gt;section_mem_map = 0;
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">

This looks correct to me.

I have a couple of questions:

1. As I understand, section_mem_map initially stores the nid
   during early boot, and later it stores a pointer to an
   array of struct page. In sparse_init_nid(), the struct page
   array is stored in section_mem_map via
   sparse_init_early_section(). If
   __populate_section_memmap() fails, we are  clearing the nid
   stored in section_mem_map right?
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Right.

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
2. Another question: if sparse_init_nid() fails for some
   sections, there is no retry mechanism to add them again,
   correct?
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Right.

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
3. when ms-&gt;section_mem_map is set to 0
   for a pre-initialized section, does it only affect the
   pre-initialization check, or could it lead to other issues?

</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Only affect pre-initialization. No other issues.</pre>
    </blockquote>
    <p><font face="monospace"><br>
        Thanks for the clarification.<br>
        <br>
        This looks good to me.<br>
        <br>
      </font></p>
    <p id="b"
style="overflow-wrap: anywhere; font-size: 13px; font-family: monospace; background: rgb(255, 255, 255); color: rgb(0, 0, 51); white-space: pre-wrap; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">Reviewed by: Donet Tom <a class="moz-txt-link-rfc2396E" href="mailto:donettom@linux.ibm.com">&lt;donettom@linux.ibm.com&gt;</a></p>
    <p><br>
    </p>
    <p><br>
    </p>
    <blockquote type="cite"
      cite="mid:1ACF04AC-CC9B-4B29-8E3F-6609B5C1B09E@linux.dev">
      <pre wrap="" class="moz-quote-pre">

Thanks.

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
- Donet

</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">  }
 }
</pre>
        </blockquote>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">

</pre>
    </blockquote>
  </body>
</html>

--------------LspP04RDqWezW5Pn7kgxlFRK--


