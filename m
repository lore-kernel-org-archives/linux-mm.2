Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ACCFCAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 05:03:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5EF88E0006; Thu, 25 Sep 2025 01:03:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3CF78E0001; Thu, 25 Sep 2025 01:03:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925338E0006; Thu, 25 Sep 2025 01:03:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81A798E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:03:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1430258505
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:03:44 +0000 (UTC)
X-FDA: 83926579968.06.89A3057
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id 88974100002
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:03:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oC+v0ig0;
	spf=pass (imf14.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758776621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dsocIPbLYE3LByXqgbRBeV6KVt1ja7Me2A6VAGSZcGM=;
	b=OX6oeX43gMxhDhKZIExmH2W7B/uTFgMjz1O74mKuENZWXfJV4T+uiUBYft0nBr3EI8D0Va
	00uirrF+6EOagrr2OA5nwRh3GSJtchmP9LNXR7rHeO843SfO8Aw7IX4MFSNY9luvsZW0sY
	IL+t50Nt19mpMuVafyz6z0wyRNm/kpA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758776621; a=rsa-sha256;
	cv=none;
	b=lgnibmdAvaNfvPiCQ4IiXaLHpVkwkCuWucOkjLGoAKpbu56S00kzT+7bZRj4+WvYc3FQ97
	iReAe7LbC4/EIretPChXEmS2vemjJ04n3npNvT8F/OZE6CDqryLaSmT5AZda7LyHgY6ljB
	LxqvVn/PI/Q1mefSsXEx/nxUgs4aDqg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oC+v0ig0;
	spf=pass (imf14.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OILbJ9002011;
	Thu, 25 Sep 2025 05:03:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=dsocIP
	bLYE3LByXqgbRBeV6KVt1ja7Me2A6VAGSZcGM=; b=oC+v0ig0UiYj64tH8OaZ2U
	2X9ZkJ/KBNgwQYSlcp9M6uO0cPajTbmDW786+F7Y9uhCcaQms4QJLJi9in0qenUm
	rEPHb7W8iadOF1SipT/Cc0eMSKRLffxB7jKrKFWI0vyVsgeudYCmZePdR7uYu+oc
	fNcZur7gbOfHnCvvy3q7UXCtSBGQ0gcR4xem0rt47QnehDEZ2hJp4nswScuGbwtf
	Sy0T4Ejt7Dm7YKZtOiQdmD4+4uEXlt9O2KLiAUFH2/np+8AvIO2UXQjnAK3c3bZw
	bvG6nIywdWbagaw8bZTXtpnmrdzqdZKn+yZSf1qNtR6XzCsiTUmJmhP2xISgBSKQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499ksc3mff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 05:03:33 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58P4wAI8028338;
	Thu, 25 Sep 2025 05:03:33 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499ksc3mfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 05:03:32 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58P11LqO031109;
	Thu, 25 Sep 2025 05:03:31 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49b9vdd3ua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 05:03:31 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58P53UQA21627608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 05:03:30 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E7055805D;
	Thu, 25 Sep 2025 05:03:30 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7798B5805A;
	Thu, 25 Sep 2025 05:03:24 +0000 (GMT)
Received: from [9.124.219.167] (unknown [9.124.219.167])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 25 Sep 2025 05:03:24 +0000 (GMT)
Message-ID: <ec2a78ce-2f2d-4453-b1dd-8c8ddc0e29d0@linux.ibm.com>
Date: Thu, 25 Sep 2025 10:33:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] drivers/base/node: merge unregister_one_node() and
 unregister_node() to a single function.
To: Christophe Leroy <christophe.leroy@csgroup.eu>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>
Cc: Ritesh Harjani <ritesh.list@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Danilo Krummrich <dakr@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Dave Jiang <dave.jiang@intel.com>
References: <cover.1758736423.git.donettom@linux.ibm.com>
 <c99d97e253378455f1b3b7bec5b0c830d4e73074.1758736423.git.donettom@linux.ibm.com>
 <fa2272b9-13f2-464f-bb95-72fd31f1dcf9@csgroup.eu>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <fa2272b9-13f2-464f-bb95-72fd31f1dcf9@csgroup.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zFQNQipvWXY2e91Gr6_KzHBSU-SaiQL1
X-Proofpoint-GUID: 5JS2pehr0NJlUuVT0owfmnUYDvwklON5
X-Authority-Analysis: v=2.4 cv=SdH3duRu c=1 sm=1 tr=0 ts=68d4cd25 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=u769cWuDflkTXPMc6NMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAyMCBTYWx0ZWRfX3toRuaPFu7uu
 3AdFGEMKOto9+xmvqHc5QukHHmt+qeuRMTCrTELUFHRI4wxcSvLAEcpSjWzJy9752YUiSNjrIyl
 VWggyP17oq0XUZ9RAoPP3zCPpjIaiypP92Fwb7yXFyhfFc7DAaxTB4w+F4WO2bmvN6/64YufxXy
 y7plHlfj83MMH/rBxW69IPH8xdyY1f6KYmKaDsxjE9o7ClMDbIyGFblc+p6s5AlATABSpZqmVSx
 fSorXYlqHseOSt5Jetx1tDEj+chrO8KuySOqCDNNuIqWsD8knvCmTsyLwHAC+6mwMO6vhNQWeW3
 oaUcWA1XpiSMQ8/VsQYehd5vDIkcvmwazSvVFRcWvV9a6Gl97V5H9OUjYE0PA/QMnSvAj0gDio2
 XDNTHDnv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509200020
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 88974100002
X-Stat-Signature: gq1p1u9nhk4gfmx9qpxbw6p8ppxesy9c
X-Rspam-User: 
X-HE-Tag: 1758776621-24753
X-HE-Meta: U2FsdGVkX1/0a4bXJvOaWGJPqSKJeIJ2BoTAZiXNNl+bnG6r3sYU5DW/U4abmew/B6YTnrSllu6CZ+0wV5RT4q5wN+sBqCUmRqA6tZCkFq92OgoaxCLypIha0HoIoR/R2yurGnkVLxFmghQtudn9L83GiTesKMlzWcSMZOmpdeLkceZclfrukWzLhWOGJwNckPFP+xBHNOJL87CXw5ZEzYGH6Qx1q9Xc7QgNDpw5AU1wS2p4+DeUrn4TeBK7rl/CRN34N+9IgyBMPpgE6Iza5zI1omeBIMUwDwxzc0jAMFKwD46vXKifZD0qDVwmNn+OrbHXk7sJ75Zb5MoxWYbCnW27VZj/+5OtBjrcagJ6wmPUcwWzz4KmReHemdFTTpc2mck4VhVxCJegbciWWLa2oYfwncaIxLWZ0V7K8bcf3Yjqyad4NYF/w6RdVpLXDSorZIhZM9NhvnDwoekIDruzikSbKAkxotb/wer0589V09ps3ESl6LjBvLoiTCfE24ms5szxbCL+NpqVIbQa1LPhfSunTd2CzGiGuFD+kF215I7hG5lxkYEHNB7IY4NMqoGdxDd0OggtEhXRoZQnD6ildbkFKOHG5hdJ1liQ355Zwuqo1rpZG0LUvzaEB1a4NNUXSICDBMBP0O2K98NuJSNlY+knFR7g8PonP0OgrXAhHbnKcojmorPvpBwgizTUZE+i2SVoxnRT1+NEGC8al6+NWMx8KYhZNisL4D8LJ6ftVsjRZHZ5h9zaSBgV2VsxSvPdfdcI+nCbkEvKqjljDIeCkQUPwtocP+0BMkiYxH4LuquJ0gwM4TBuPjr0ZPzO5fJBL0ImIByqXau/M5yFVPC0O9tDj+ciKTwWW+1EQlLZFbV6jw6prldF1h2H3i8ojftUDL1gzJUktbqhMIfaNDWkvSmbu3sRTGCUZE4RAEWlCyT5xOyAp48kEz0kKwoaA4zEx09uRiPf1d82czu1aaX
 U+UNr0d2
 FaMmeAhaNMclO2K8tY/hUqLSP6GTlZB+G0u6OdeAA0n4uGbzfO4t3zgAHnoqnf0T+WVVi8FZIb5PiqJ2JKUV80/I49BbmjLAvIfCJgYbtoMq0k7JTHEPEjX/cLWDJwZ255FVly46S95WKL2bc78u+bN8iodsrxwkBj4weCzX3tFUkUwP/2+Qb0C5bZhnWgLYg88iCA7vcJpcRF3qhwV1zf0FGGBX6B+GMEqqZh/sTsPAmO8KHGae8ZHSZtE40c3BkrGgNEz6JFFhQy89l/CvnmwGk/DJNSfD2DeGsgqC9bHOA+B5VfxRSIzbnJOpIrlEzroJCYx4vieWLiZGMPNI6Jt8s+RDJsKjoz2ofL2g3B5wscJiX6dN4yBk/doXEJwPYWM+vH0PpOkGYVAbAaNDNOsmKREpbm4gyQBGEGbOhbBEztDCIb+WMlB7pMpjzHohQkLb6wcO1x+ce0ErRxF2oFY73th8exQz27VflBXtv6GAxM+JoHRTlugLrOv6ZoYKaZ+ZlWwW1RwFWuEY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/25/25 12:49 AM, Christophe Leroy wrote:
>
>
> Le 24/09/2025 à 20:40, Donet Tom a écrit :
>> unregister_one_node() and unregister_node() are small functions.
>> This patch merges them into a single function named unregister_node()
>> to improve code readability.
>
> Same comment than patch 1. It is not only because they are small that 
> you merge them, it is primarily because unregister_node() only has one 
> caller.


Will update it in the next version.


>
>>
>> No functional changes are introduced.
>>
>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>> ---
>>   drivers/base/node.c  | 37 +++++++++++++++++--------------------
>>   include/linux/node.h |  6 ++----
>>   mm/memory_hotplug.c  |  4 ++--
>>   3 files changed, 21 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/base/node.c b/drivers/base/node.c
>> index eab620e29c78..d460c1675c77 100644
>> --- a/drivers/base/node.c
>> +++ b/drivers/base/node.c
>> @@ -638,23 +638,6 @@ static void node_device_release(struct device *dev)
>>       kfree(to_node(dev));
>>   }
>>   -/**
>> - * unregister_node - unregister a node device
>> - * @node: node going away
>> - *
>> - * Unregisters a node device @node.  All the devices on the node 
>> must be
>> - * unregistered before calling this function.
>> - */
>> -void unregister_node(struct node *node)
>> -{
>> -    hugetlb_unregister_node(node);
>> -    compaction_unregister_node(node);
>> -    reclaim_unregister_node(node);
>> -    node_remove_accesses(node);
>> -    node_remove_caches(node);
>> -    device_unregister(&node->dev);
>> -}
>> -
>>   struct node *node_devices[MAX_NUMNODES];
>>     /*
>> @@ -887,12 +870,26 @@ int register_node(int nid)
>>       return error;
>>   }
>>   -void unregister_one_node(int nid)
>> +/**
>> + * unregister_node - unregister a node device
>> + * @nid: nid of the node going away
>> + *
>> + * Unregisters the node device at node id  @nid.  All the devices on 
>> the
>> + * node must be unregistered before calling this function.
>> + */
>> +void unregister_node(int nid)
>>   {
>> -    if (!node_devices[nid])
>> +    struct node *node = node_devices[nid];
>> +
>> +    if (!node)
>>           return;
>>   -    unregister_node(node_devices[nid]);
>> +    hugetlb_unregister_node(node);
>> +    compaction_unregister_node(node);
>> +    reclaim_unregister_node(node);
>> +    node_remove_accesses(node);
>> +    node_remove_caches(node);
>> +    device_unregister(&node->dev);
>>       node_devices[nid] = NULL;
>>   }
>>   diff --git a/include/linux/node.h b/include/linux/node.h
>> index 4dcf876cd0b4..d721127964b3 100644
>> --- a/include/linux/node.h
>> +++ b/include/linux/node.h
>> @@ -124,8 +124,6 @@ static inline void 
>> register_memory_blocks_under_nodes(void)
>>   }
>>   #endif
>>   -extern void unregister_node(struct node *node);
>> -
>>   struct node_notify {
>>       int nid;
>>   };
>> @@ -169,7 +167,7 @@ static inline int 
>> hotplug_node_notifier(notifier_fn_t fn, int pri)
>>   extern void node_dev_init(void);
>>   /* Core of the node registration - only memory hotplug should use 
>> this */
>>   extern int register_node(int nid);
>> -extern void unregister_one_node(int nid);
>> +extern void unregister_node(int nid);
>
> No 'extern' on function prototypes.


Sure.

Thank you very much


>
>>   extern int register_cpu_under_node(unsigned int cpu, unsigned int 
>> nid);
>>   extern int unregister_cpu_under_node(unsigned int cpu, unsigned int 
>> nid);
>>   extern void unregister_memory_block_under_nodes(struct memory_block 
>> *mem_blk);
>> @@ -185,7 +183,7 @@ static inline int register_node(int nid)
>>   {
>>       return 0;
>>   }
>> -static inline int unregister_one_node(int nid)
>> +static inline int unregister_node(int nid)
>>   {
>>       return 0;
>>   }
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 6c050d867031..94a8f6e8811a 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1596,7 +1596,7 @@ int add_memory_resource(int nid, struct 
>> resource *res, mhp_t mhp_flags)
>>   error:
>>       if (new_node) {
>>           node_set_offline(nid);
>> -        unregister_one_node(nid);
>> +        unregister_node(nid);
>>       }
>>   error_memblock_remove:
>>       if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
>> @@ -2201,7 +2201,7 @@ void try_offline_node(int nid)
>>        * node now.
>>        */
>>       node_set_offline(nid);
>> -    unregister_one_node(nid);
>> +    unregister_node(nid);
>>   }
>>   EXPORT_SYMBOL(try_offline_node);
>
>

