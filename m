Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6693CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 13:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 293E38E0013; Thu, 25 Sep 2025 09:21:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243EC8E0001; Thu, 25 Sep 2025 09:21:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10C778E0013; Thu, 25 Sep 2025 09:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F26E48E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:21:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B79F1601D0
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:21:12 +0000 (UTC)
X-FDA: 83927833584.18.BDBC2D4
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id ACCD31A000E
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:21:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RvCZUGSH;
	spf=pass (imf19.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758806469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=izGvxpR8RQZ9UpXF9e+lyp0j6l+qKVnb1xtnr65Pjm4=;
	b=rWZkZOYd2GhX0l8bPk0PaTw98EEl0cBN4YcOLFuSEab1+VEVTTtUPJySgdeTceAnfKRsgZ
	6ZljuGFdZOGrGe1HCHMIakX3x+JaqMf+tP5VW3Of4fM52SHtX9UCdkQl0LHZwsmiS4SpGZ
	KWKnRxFe+9U0RBvlHLLmiGwq7v1e70M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758806469; a=rsa-sha256;
	cv=none;
	b=i3CFU1ROiiWOzZMtuOnfmT93UIirQ5O7m+ZGYOnheqj61bBZsZmQSqaDPx1YKkUn4a/U/f
	YmzSh5XHjmARcEjOQPrXowmYhD2oEsiE1e86sp+wdq6UxaEVq6xFaXhgwt0nk2cWnPBJR8
	MuclngDJE/adHqlh0t88vY5zxWTOcmQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RvCZUGSH;
	spf=pass (imf19.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58PDExM2005703;
	Thu, 25 Sep 2025 13:20:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=izGvxp
	R8RQZ9UpXF9e+lyp0j6l+qKVnb1xtnr65Pjm4=; b=RvCZUGSHSijPR3Rl6QKtJo
	Y4c2jWVDdC07PZOkjbCMFbNW/7I32sapNM+wvF6CN1UfwzE+HCajs/AQQQPGg0ew
	b+GUDup5GVZAzoDODHp31sDqNuNdRXNK5U0s8oqSOEzah9Y0yTC4v7V3dGT1ICN1
	Q+giwkCYFtY5u/KL41nMuioTNEy0MYMV1B0KNmetDXQjZTY+uCyIppNdr6sFY3nv
	WrAumX6TFKpNBpH+Af/3yiTexayGyVEHDIL+8hCRt6Zp0uQMAIKScYTowPL2UiIq
	kWKYpP/XqEo2lUYRABJX39lhPmJcU50jM6kvfmYtmce/e7PtyT0lhPB6Aeh6L1/Q
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499kwyw0uv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 13:20:57 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58PD4HVp004982;
	Thu, 25 Sep 2025 13:20:56 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499kwyw0uk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 13:20:56 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58PA862L019671;
	Thu, 25 Sep 2025 13:20:56 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49a83kdyds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 13:20:56 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58PDKseh27722280
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 13:20:55 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A57C758061;
	Thu, 25 Sep 2025 13:20:54 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E2AA58057;
	Thu, 25 Sep 2025 13:20:49 +0000 (GMT)
Received: from [9.39.30.226] (unknown [9.39.30.226])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 25 Sep 2025 13:20:49 +0000 (GMT)
Message-ID: <3ad7a1b6-eaba-4e1e-aa27-b6c9260ddc68@linux.ibm.com>
Date: Thu, 25 Sep 2025 18:50:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] drivers/base/node: merge register_one_node() and
 register_node() to a single function.
To: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>
Cc: Ritesh Harjani <ritesh.list@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        Christophe Leroy
 <christophe.leroy@csgroup.eu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Danilo Krummrich <dakr@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Dave Jiang <dave.jiang@intel.com>
References: <cover.1758736423.git.donettom@linux.ibm.com>
 <40257b5228dec05e5b252f02438608eb8d681a2d.1758736423.git.donettom@linux.ibm.com>
 <0de65980-4333-434a-ae7d-2b7be46c2cca@redhat.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <0de65980-4333-434a-ae7d-2b7be46c2cca@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=J5Cq7BnS c=1 sm=1 tr=0 ts=68d541b9 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=VYFwuNkCapB6VMV0qykA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: eMJ9kfsTgBHfUA6tVjsPD_AWFt_ZESvP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxNSBTYWx0ZWRfX+DZTcBF17QFy
 MJGsSw1/Ma0YcTsS42Ta3NR9/1joRq7IOGTZXo+cwc7aZJbzUJaXRGPwCwXFwuM+5/jWjBD3dGt
 Tk3EDAfcN5i38vmODxWFcPGltZX9kTTCvdfCWV5Z2NlFgWxLa3oNm8+pcfJStpZdKE4Gwq4VzTW
 sJkAMrOXpfc63gthcVes50j/iqweKkELJ+x7YU7uusmeyGQQM4aLq2c9fE6Q/+dJnIN9dW6NSqH
 AuG+1nW9L2yAudJXxgTbhdYL5s28+10xdlW+KchgLU06UsGP3EjqQ3uF17XkO5GnpYdm+UdF2lJ
 oJQnlNNoBPLQbNRziKFEx7Bv4ftMtntnWH6VzCAs+NzzZ999TiM1Wk2/8vuMLaY4Zv54febI3Ms
 KxIRK8rA
X-Proofpoint-ORIG-GUID: Dk6YoM9jUnqj7o99btFxGm_iPC6WbMWr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-25_01,2025-09-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 clxscore=1015 adultscore=0 suspectscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509200015
X-Rspamd-Queue-Id: ACCD31A000E
X-Stat-Signature: aptudfok5kt5qn9ob59go8i9s7z4d17t
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758806469-327459
X-HE-Meta: U2FsdGVkX19/b9koXIz7kB/cysHR9C1YRfRcOJEb2c/L4NW06P6EvB7rfprQ/iDt2je/YItMJoFcLqW9mrDv8sXgtLGk8h7YplMq6RqcsqA4JVg2+Ig16slHGK4/xlDjiGXFUxWa5TcAkiV3YmnWuKFFbwJwuXa6WckOsqV0tADrP7KDqDm/zreZ8Dh1V+XUGwKjcK+0dIu1eZCmxG+YrEcFoVLZ1b6vDYrims3YMnR3vngnDe0ejlM2Y8elrL0f1Pfl3SBTDdl/4xmo9bgyC0QWRs1iBS4vP1DM6UT5tspM/HKdjtIFg43SpO9VSaFvibVej5wKNIcr7GZe6whQTRum/6rGpRimfABBMgnGCIvIOYNU87/zEKMJmxfjVoqjNyU9Tb1jWe5wWxpLif/1q+D5cWJsGoqiU9tAHCrzMHtGFqUlBWqiWHRsiQikjadcQhO7vpQnIqrMnWqO2CtdCPlsULML/iSMZOwzaed/oqL8Om/q+S9MAi8F7ocTmFRdcrstafWg+LT7mkQ55cbpiz7iaz1iXzVSB0lkDe1RQe+Rb52TUOFqCgAEmTjNTmiGq//DT38y6wHuqwLn+RpYMSoYflm9H6J345iTbk/YeBoFqNpR45kJg6KhSqARzyF6GSeH5I4BONrxtFkYZTQv2dIt1sVwaYPol9w65otg9hU56FolJn4ur2fynFsS9spJD/MtIM4rikNeZSFOCFOAWJqcC0TXHMNv9Tu5srI8FoE3/7lXnN3vWuby6ei0EZFevnD1POoMqmg3ISnVU7BEs8I1nRqD4gs3Xbz/5N4RAKL7EdnvWG+eVA2/RJJNxmT+iklqWDkmwTd74XM44AzN2nceCMmi6Ce/4RKTlpckGzvhDYfN6nbFVG2CJuQyPDmiCfge/lQ94qTPe89i1e8UNDwwNEhDNtR2CRTKLrxeIZFR2H9oU7rl1JHzIu2Ld2WZ5Q+K8TmuvVLuZDaTlu6
 lsZZjvsK
 tE8E1EfWrME/ikcM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/25/25 2:24 PM, David Hildenbrand wrote:
> On 24.09.25 20:40, Donet Tom wrote:
>> register_one_node() and register_node() are small functions.
>> This patch merges them into a single function named register_node()
>> to improve code readability.
>>
>> No functional changes are introduced.
>>
>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>> ---
>
> [...]
>
>>   /**
>>    * unregister_node - unregister a node device
>>    * @node: node going away
>> @@ -869,7 +842,13 @@ void 
>> register_memory_blocks_under_node_hotplug(int nid, unsigned long 
>> start_pfn,
>>   }
>>   #endif /* CONFIG_MEMORY_HOTPLUG */
>>   -int register_one_node(int nid)
>> +/*
>
> We can directly convert this to proper kernel doc by using /**
>
Sure I will add it.


>
>> + * register_node - Setup a sysfs device for a node.
>> + * @nid - Node number to use when creating the device.
>> + *
>> + * Initialize and register the node device.
>
> and briefly describing what the return value means
>
> "Returns 0 on success, ..."
>
Sure

>> + */
>> +int register_node(int nid)
>>   {
>>       int error;
>>       int cpu;
>> @@ -880,14 +859,23 @@ int register_one_node(int nid)
>>           return -ENOMEM;
>>         INIT_LIST_HEAD(&node->access_list);
>> -    node_devices[nid] = node;
>>   -    error = register_node(node_devices[nid], nid);
>> +    node->dev.id = nid;
>> +    node->dev.bus = &node_subsys;
>> +    node->dev.release = node_device_release;
>> +    node->dev.groups = node_dev_groups;
>> +
>> +    error = device_register(&node->dev);
>>       if (error) {
>> -        node_devices[nid] = NULL;
>
> Wondering why we did have this temporary setting of the node_devices[] 
> in there. But I cannot immediately spot why it was required.


node_devices[] is used in many places to access node data.

In the previous code, immediately after allocating the node

structure, it was stored in node_devices[]. On error paths, we

were clearing the node structure entry from node_devices[].


With the new code, the node structure is now stored in node_devices[]

only after the device has been registered, and just before calling

register_cpu_under_node(), since node_devices[] is accessed inside

that function.


It is also used outside of node.c, in hugetlb_register_all_nodes() .

Do you think we could use a different mechanism instead of this?


