Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC79CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 05:18:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E07F88E0026; Fri, 17 Oct 2025 01:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8F98E0002; Fri, 17 Oct 2025 01:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C807B8E0026; Fri, 17 Oct 2025 01:18:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2DB78E0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:18:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 432A21602E2
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:18:09 +0000 (UTC)
X-FDA: 84006449898.15.AECCF9C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf03.hostedemail.com (Postfix) with ESMTP id D43D420003
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:18:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PEeymNue;
	spf=pass (imf03.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760678286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yRq4Fjs9RQqmCumBXOIWM/V9Rdd8tRYzHUqt4EgQG1g=;
	b=uz6J6t58hHkn7Io+JLZfTO4SX9vbc2kJRBbX8IvwgDQa1tRhPW0IOMXJ1HEb6S2UqAAjEY
	8I20K+ASJQo2b7fl8Vg9b6nKIXp7JGlQsBIek0UWZOMAOISo5IfKvrUGIUZv6+Db5DJkvU
	Zf/oCnjwFRjf/us/kDKy92Wy5ndmPMg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PEeymNue;
	spf=pass (imf03.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760678287; a=rsa-sha256;
	cv=none;
	b=6PqsfUG8Jqv1BUxkR6FCNNWH/A/t64daPAgAXZMB1xHd7+yIA0ghCIH/1lMVSEj2Y+AHwL
	c4/cLf8V5Rryj2QxtAdl7TjEkNIupMHmjjFrTYGNq5SexgB6Lwunkib3pkV1y4WoCvWNax
	lU5BnCoWP3n/R6pBxwfCF0JpA8pKnCU=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59H3me5T021054;
	Fri, 17 Oct 2025 05:17:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=yRq4Fjs9RQqmCumBXOIWM/V9Rdd8tR
	YzHUqt4EgQG1g=; b=PEeymNueSinjU7DQxwA1rVIebo7bhmjJmy9xinIYgvOK5N
	NwHKuBLojWwD725343ve3TctOfnb57DkzwmoRsQha2erTTiUPeANaqlcanIhILYx
	VAQNb8nEXdYDt+Ez7iJ/D6xLMijWFezv3N4gxc/qRAtmEmK0LjmMVl3t93dv7JGu
	Fk+7Zx90Hakp+y9OQDeN4p5WOhU/3BjOr2v5xBP0wudGob//GGr1NLXu0xaj935V
	2kwMdcQONdC5Btmy7X4jMLeE1QCMFNT92WsZaoGf3fGjrN9QOa9NYfDyuIsbCz8h
	wJVnmfTr2cd2w6Wd8l2Js39HBuEJlMqUmGw3QBKA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qew0dh7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 05:17:53 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59H5ETKP030991;
	Fri, 17 Oct 2025 05:17:53 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qew0dh78-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 05:17:53 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59H1gYRO028047;
	Fri, 17 Oct 2025 05:17:52 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49tdg9gn88-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 05:17:52 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59H5Hpx132571958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 05:17:51 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAAB758054;
	Fri, 17 Oct 2025 05:17:50 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ACBE45805A;
	Fri, 17 Oct 2025 05:17:44 +0000 (GMT)
Received: from [9.124.220.117] (unknown [9.124.220.117])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Oct 2025 05:17:44 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------lEjR0iPOz9KnyL9ZWgMzVvbr"
Message-ID: <cff01514-9074-4c97-bcf1-d4e3594e48b0@linux.ibm.com>
Date: Fri, 17 Oct 2025 10:47:43 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] drivers/base/node: Fold unregister_node() into
 unregister_one_node()
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        Christophe Leroy
 <christophe.leroy@csgroup.eu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, Danilo Krummrich <dakr@kernel.org>,
        Dave Jiang <dave.jiang@intel.com>
References: <20251015172759.69864-1-sj@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20251015172759.69864-1-sj@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xubv_IjbsENKRNmx41Q90HchWwlwgPIN
X-Authority-Analysis: v=2.4 cv=eJkeTXp1 c=1 sm=1 tr=0 ts=68f1d182 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=r77TgQKjGQsHNAKrUKIA:9
 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=4P3WUyT6FmEQvZmdkCYA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=9QPfRxTwsjrChipofWYA:9
 a=1qUZTG5jgF9W_AF5:21 a=_W_S_7VecoQA:10 a=lqcHg5cX4UMA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxNCBTYWx0ZWRfXxS5P6sLnVrC3
 o7MeNSwZX9B5YAtb8LTm1QV4ovlO6cC8EqwNxPt+FYgSs5TPohEMr4E3GKVTqz/x8dZt9SjckeW
 aDS9TfPIpPnlODRhqtiDyAU83W8TtYz61wb4EluTmsaIVbUFYh7PRaqKnRzPPJL2cHVbFNLauYd
 +EMuSLS3z0wJVRhL7M83cglJJsMvvI2tQnUtdIuqBgXVmqyWNyJdbZo8yxXWu5qmuYgrA9i6qaY
 JM3iGxioMr+qzNoFhc7NWhVZdCWuN9NZ/Y4cRtd5xr7gF7ku4zShx2Ub7lOCcMTTj+JjBqeUQJJ
 hjqeMfnVAz3pH9ZAESW9O/sKKc9jRoPOUE3PhGxEz9xLeaF0hKLMIBo1RA0sgA6wQyMTuUyiQyr
 fn5ovtZM3HeHqQN9kDujHTHNLDB+2g==
X-Proofpoint-GUID: hgfPyIsn-v6oRJooxxEavvKmFDBTqY1B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 impostorscore=0
 phishscore=0 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110014
X-Stat-Signature: a5jejefd5ktstxey8o66pnon6fb9z9os
X-Rspamd-Queue-Id: D43D420003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760678286-823369
X-HE-Meta: U2FsdGVkX1+u3ux07LPlnfjV62COFgnhRmxyaGfK/pmA6pEsE9eXJN9HdTErNnsy30J3qnrY7X0g/foVTqrQAZMNlKHojGe0IcOnr6j3mMTwbnnd1Pu8pyaHzIzci8GoKtyARELzRo3I3ig8gO0eA2Q7r+OPcruRYsz01og1SO6D+ey16uMLzKuKKkuaRNOWgvaPxKcqhvLIrtcSINBVH3vSCY3r7Lz3sCOBUIxe/IzItMRXg0hQMRdk7P5sFWJxsnN2nyKTTfX8lHpSZJiyw/LWIYav3XzNNk+4aEvfM8wwjLreaWPxSlD43w7Cuvia5DJzQc6+CnzaNgVS4qLgnO78meDZJTZM7JG/VWzSWKcwG9rzB7IcrOlBQzFpH8ijGlTxFesUrqVjTA4/Ophm/J55QWzRccNLvePwSaI1NR2I8oJlhbSuOP+v68yIp+ahaBeTPy7ljHdPg/cxn3quhh0KuDEYzuemo7luaoNTdNjsfzyMIYAi22pDS64U0TeO50xQuHQ4ApWeAqHR+C1Hmm9uT7K8v97B7/gksRE1Ahyy4X7s183eUcnJTXAIh/xfEh9bn/ELz05C0lbIuSXKROe9rXDZqsz7ZRSFpc3qTyja0wwoiaW7PC68rENRm2M19bZKHiGqERJZtvp4oERcav8vWmU7c0m3yThnVScQIy2J4xg5r4dXDUTNhuPoV34MRK6PGpS/a+aUk0kGHZoxN1v8NnceGrLf0xxTLcTEeKkwxryvokFAWzANu9mhL+mekDrkYmGTGviLjcPKrO6dzKyk3VO+kW19dr/nU0g1FcCRHGZ+1hWdodBmGYRt3HcL1pE7MoXLstYUnjyuomH7grWtH/w8V6eop41JVPp4LYRAfJFdUsJXr2ptMFBKYRkA9F1Hoh5cT/KZNAWzWfy130Dh+8+9LZrOTGvNsMM+4TCncxM/cldwZImpUIMBSIO23CiPnt15OcOerlhKNIh
 6KJQncYI
 zKkK3sux4gVPqbiOhp9NcKJ72FvwCNbJ8GAat2rQTLonLJ2EDzeg7gqSGr/iE+wnRo8iR06xzDz46zbWp7oHr6QssgcvxIUYrOlqCDYyvTCPH1ByYta05az6U5z+EerNhBpWwgrrQnjdXYfrBj3fopdAnFp/5sZPzuUCuAz/Mt5xaS1HrZ/AKW3e24Acbuyvag14IePn6SzD/LIYFQYHIbFx6If8KH4bubd+RaoeJQsiDSZzG633JvYY4W0cwUNnSNMOCE5MEdj42tHXDg1ze+etfvFVV23npYGTtM0IuIfvMQ69h6Rbg+7yomUR00LtdVvAZ/SlO+Vwbvge6kplCytnsTSVfcLUGQZpDBXHTLYXev6iicOz1uV+IiqSWmsDT8uroLDmGvtc1EIzR22+y0llix9wGt6t1oERfiyW5+rdTRkffXum2xSA3BzSz9D3cES7nkRBM5qRlTInm2dL3RwtvoGdc+AAfclU7GdzXFaVyl78cwXHbOrhOjfdSCjTjrKJGpVuJJKVmRn7Cvf3CJJJXeT84WEjwVZPTJ8TYQr1THJfVVgKAJYLCGWppYydGGIlHnQoQWgwh3uMDqRey6LCR9U05JyOStFC3hU3yJd7H0QpdsiRPytkapZNFpKNatsIXANHbLlhdW98eQIqJCWkTaRnW45jOdJD1g3wIKRAme7K48MClFEAKRk0su8oHd3mANZTEBqIrh5TW4zI/oJvJrpI8pw2ylgC/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------lEjR0iPOz9KnyL9ZWgMzVvbr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 10/15/25 10:57 PM, SeongJae Park wrote:
> On Tue, 14 Oct 2025 21:09:17 +0530 Donet Tom<donettom@linux.ibm.com> wrote:
>
>> The function unregister_node() is only called from unregister_one_node().
>> This patch folds unregister_node() into its only caller and renames
>> unregister_one_node() to unregister_node().
>>
>> This reduces unnecessary indirection and simplifies the code structure.
>> No functional changes are introduced.
>>
>> Acked-by: David Hildenbrand<david@redhat.com>
>> Acked-by: Mike Rapoport (Microsoft)<rppt@kernel.org>
>> Signed-off-by: Donet Tom<donettom@linux.ibm.com>
> Acked-by: SeongJae Park<sj@kernel.org>
>
>> ---
>>   drivers/base/node.c  | 38 +++++++++++++++++---------------------
>>   include/linux/node.h |  6 ++----
>>   mm/memory_hotplug.c  |  4 ++--
>>   3 files changed, 21 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/base/node.c b/drivers/base/node.c
>> index 4bcaa8006cd6..758b777dec1f 100644
>> --- a/drivers/base/node.c
>> +++ b/drivers/base/node.c
>> @@ -676,23 +676,6 @@ static void node_device_release(struct device *dev)
>>   	kfree(to_node(dev));
>>   }
>>   
>> -/**
>> - * unregister_node - unregister a node device
>> - * @node: node going away
>> - *
>> - * Unregisters a node device @node.  All the devices on the node must be
>> - * unregistered before calling this function.
>> - */
>> -void unregister_node(struct node *node)
>> -{
>> -	hugetlb_unregister_node(node);
>> -	compaction_unregister_node(node);
>> -	reclaim_unregister_node(node);
>> -	node_remove_accesses(node);
>> -	node_remove_caches(node);
>> -	device_unregister(&node->dev);
>> -}
>> -
>>   struct node *node_devices[MAX_NUMNODES];
>>   
>>   /*
>> @@ -924,13 +907,26 @@ int register_node(int nid)
>>   
>>   	return error;
>>   }
>> -
>> -void unregister_one_node(int nid)
>> +/**
>> + * unregister_node - unregister a node device
>> + * @nid: nid of the node going away
>> + *
>> + * Unregisters the node device at node id  @nid.  All the devices on the
> Nit.  Why two spaces before "@nid"?

Thank you for pointing this out.

Andrew could you please help apply the below fixlet on top of this patch?

 From 0d0345847ad33607c7ebae3798ef37ff16a20fd0 Mon Sep 17 00:00:00 2001
From: Donet Tom<donettom@linux.ibm.com>                                        
Date: Fri, 17 Oct 2025 10:27:54 +0530
Subject: [PATCH] [fixlet] drivers/base/node: Remove extra space in description
                                                                                 
This patch removes an extra space before @nid and "All".
                                                                                 
Signed-off-by: Donet Tom<donettom@linux.ibm.com>                               
---
  drivers/base/node.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)
                                                                                 
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 63b223a3b38e..00cf4532f121 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -911,7 +911,7 @@ int register_node(int nid)
   * unregister_node - unregister a node device
   * @nid: nid of the node going away
   *
- * Unregisters the node device at node id  @nid.  All the devices on the
+ * Unregisters the node device at node id @nid. All the devices on the
   * node must be unregistered before calling this function.
   */
  void unregister_node(int nid)
--
2.51.0


>
> [...]
>
>
> Thanks,
> SJ
--------------lEjR0iPOz9KnyL9ZWgMzVvbr
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
    <div class="moz-cite-prefix">On 10/15/25 10:57 PM, SeongJae Park
      wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20251015172759.69864-1-sj@kernel.org">
      <pre wrap="" class="moz-quote-pre">On Tue, 14 Oct 2025 21:09:17 +0530 Donet Tom <a class="moz-txt-link-rfc2396E" href="mailto:donettom@linux.ibm.com">&lt;donettom@linux.ibm.com&gt;</a> wrote:

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">The function unregister_node() is only called from unregister_one_node().
This patch folds unregister_node() into its only caller and renames
unregister_one_node() to unregister_node().

This reduces unnecessary indirection and simplifies the code structure.
No functional changes are introduced.

Acked-by: David Hildenbrand <a class="moz-txt-link-rfc2396E" href="mailto:david@redhat.com">&lt;david@redhat.com&gt;</a>
Acked-by: Mike Rapoport (Microsoft) <a class="moz-txt-link-rfc2396E" href="mailto:rppt@kernel.org">&lt;rppt@kernel.org&gt;</a>
Signed-off-by: Donet Tom <a class="moz-txt-link-rfc2396E" href="mailto:donettom@linux.ibm.com">&lt;donettom@linux.ibm.com&gt;</a>
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Acked-by: SeongJae Park <a class="moz-txt-link-rfc2396E" href="mailto:sj@kernel.org">&lt;sj@kernel.org&gt;</a>

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">---
 drivers/base/node.c  | 38 +++++++++++++++++---------------------
 include/linux/node.h |  6 ++----
 mm/memory_hotplug.c  |  4 ++--
 3 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 4bcaa8006cd6..758b777dec1f 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -676,23 +676,6 @@ static void node_device_release(struct device *dev)
 	kfree(to_node(dev));
 }
 
-/**
- * unregister_node - unregister a node device
- * @node: node going away
- *
- * Unregisters a node device @node.  All the devices on the node must be
- * unregistered before calling this function.
- */
-void unregister_node(struct node *node)
-{
-	hugetlb_unregister_node(node);
-	compaction_unregister_node(node);
-	reclaim_unregister_node(node);
-	node_remove_accesses(node);
-	node_remove_caches(node);
-	device_unregister(&amp;node-&gt;dev);
-}
-
 struct node *node_devices[MAX_NUMNODES];
 
 /*
@@ -924,13 +907,26 @@ int register_node(int nid)
 
 	return error;
 }
-
-void unregister_one_node(int nid)
+/**
+ * unregister_node - unregister a node device
+ * @nid: nid of the node going away
+ *
+ * Unregisters the node device at node id  @nid.  All the devices on the
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Nit.  Why two spaces before "@nid"?</pre>
    </blockquote>
    <pre>Thank you for pointing this out.

Andrew could you please help apply the below fixlet on top of this patch?</pre>
    <pre>From 0d0345847ad33607c7ebae3798ef37ff16a20fd0 Mon Sep 17 00:00:00 2001          
From: Donet Tom <a class="moz-txt-link-rfc2396E" href="mailto:donettom@linux.ibm.com">&lt;donettom@linux.ibm.com&gt;</a>                                        
Date: Fri, 17 Oct 2025 10:27:54 +0530                                           
Subject: [PATCH] [fixlet] drivers/base/node: Remove extra space in description  
                                                                                
This patch removes an extra space before @nid and "All".                        
                                                                                
Signed-off-by: Donet Tom <a class="moz-txt-link-rfc2396E" href="mailto:donettom@linux.ibm.com">&lt;donettom@linux.ibm.com&gt;</a>                               
---                                                                             
 drivers/base/node.c | 2 +-                                                     
 1 file changed, 1 insertion(+), 1 deletion(-)                                  
                                                                                
diff --git a/drivers/base/node.c b/drivers/base/node.c                          
index 63b223a3b38e..00cf4532f121 100644                                         
--- a/drivers/base/node.c                                                       
+++ b/drivers/base/node.c                                                       
@@ -911,7 +911,7 @@ int register_node(int nid)                                  
  * unregister_node - unregister a node device                                  
  * @nid: nid of the node going away                                            
  *                                                                             
- * Unregisters the node device at node id  @nid.  All the devices on the          
+ * Unregisters the node device at node id @nid. All the devices on the         
  * node must be unregistered before calling this function.                     
  */                                                                            
 void unregister_node(int nid)                                                  
--                                                                              
2.51.0        </pre>
    <p></p>
    <p><br>
    </p>
    <blockquote type="cite"
      cite="mid:20251015172759.69864-1-sj@kernel.org">
      <pre wrap="" class="moz-quote-pre">

[...]


Thanks,
SJ
</pre>
    </blockquote>
  </body>
</html>

--------------lEjR0iPOz9KnyL9ZWgMzVvbr--


