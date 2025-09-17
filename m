Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B95ACAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 14:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0C2D8E0030; Wed, 17 Sep 2025 10:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBE8C8E0003; Wed, 17 Sep 2025 10:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD2538E0030; Wed, 17 Sep 2025 10:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9BBA8E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:56:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5EB741605BD
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:56:16 +0000 (UTC)
X-FDA: 83899042752.15.30FB72C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id DDA53100011
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:56:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Rct3IbzP;
	spf=pass (imf14.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758120974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rR06gtPnF/0lad3TuycRjJDpgyMkkm7KtU3RqeljMR0=;
	b=1lEuAPPac6W+rJ7iiZ3ugJKhBtj3qXNbCNpifHGe+mfq2BA03xNZ8TGE2ZnixC5hlbD1Hy
	fMSbw5iNoHFH+AUYnN8slfsPxt7nrRsZ7euCO7Ghpx317y3J1+iPJ/FMfWIxR/wnS+31Fk
	ttU7tS88BtxX/ccI12P88yQwqxB1HzE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758120974; a=rsa-sha256;
	cv=none;
	b=MQ/ORHfdHcmDqWggm18VF9tQb7aRts2ptUzJTdZFia6J9LsurG9ARDGcmCaXI/M+kDs8Nz
	2TxbJMKG3RpZ9/zhspYjr73dD5YHFTil2G7c+Jx7nPl1OhAq/IKc96TajOM8kZaQxQBRPb
	RRgBAt5tF8CaSLN5aJ5dZ80H9HB6Pb4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Rct3IbzP;
	spf=pass (imf14.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58H8dCHK023732;
	Wed, 17 Sep 2025 14:55:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=rR06gt
	PnF/0lad3TuycRjJDpgyMkkm7KtU3RqeljMR0=; b=Rct3IbzPzfNYhATirBqtua
	GackugCR9dsjDApxHI3cuKoVcov9cnf2ISm8WTYWPvxjit0XSYolr5KjuuW5AFap
	J2coxAFv9XNDUEuUTM3tIWOQwTQowVu4eSNX2t9329ayZqY3ApejWhfzmAm1SgsP
	NzWNk31ZR6KsX0e4tIEpgs0n8gg/lLVeaGo9B7GMU4Rk1vNP36qCcwjFwWFAjl0v
	jKxepwgTOiBCRJB1nrcghzvBGuDNDoezYtKxKXeBs+ZSDYVZV2r0kUxxOUOdysPQ
	H1RSyzfNr1Tl0FOnJyNmpt68FU3hQ2pJSu6E9wjEA0Fq6V8K7jqxcN0c8KMPLmvw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4qm6d9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:55:57 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58HEpFib002366;
	Wed, 17 Sep 2025 14:55:57 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4qm6d7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:55:57 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HDqLTt029514;
	Wed, 17 Sep 2025 14:55:56 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kb11yqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:55:56 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HEttdA27853372
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 14:55:55 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 88E2F5803F;
	Wed, 17 Sep 2025 14:55:55 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 52B5B58054;
	Wed, 17 Sep 2025 14:55:50 +0000 (GMT)
Received: from [9.109.215.183] (unknown [9.109.215.183])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 14:55:49 +0000 (GMT)
Message-ID: <676712d1-7b4f-4614-bd82-5b0c43881865@linux.ibm.com>
Date: Wed, 17 Sep 2025 20:25:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] drivers/base/node: Handle error properly in
 register_one_node()
To: Chris Mason <clm@meta.com>
Cc: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador
 <osalvador@suse.de>, Zi Yan <ziy@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        Danilo Krummrich <dakr@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Yury Norov <yury.norov@gmail.com>, Dave Jiang <dave.jiang@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <20250917134604.2149316-1-clm@meta.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20250917134604.2149316-1-clm@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wA33Ic2Fwwy0CtaNYj3S3UXMkwZMpURl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX8X65/ufRsGVo
 bDCC1dccNXM0EWET9nYDeBvXFOX+osCHHAFBagTCHm/nXv88A/WHoQGYfDDSJPHh6iUGiqByniK
 +Ps8jp+GPtn3Xlu318ZUmH9rZiXD6BRqERZDWz/JLpdHd4oxCxqN6zGWmPxnlWYEbbq03gw6lTS
 +FDJXupWDT/2BakFtzHXEVPFMuqWOTiXsaLJ6o5Ai2iZpP8aHeSnktedd2SEN2rqVw7q1Su/dup
 wn7Y0HRnt0UD9vX8e7XWpmFQ407ic2GoO0Clnmjh1KK9aG3/kNQAr1J99sh5R2qTiVbMM57JiGx
 fE9xNOS5gUBJfpnUNGkBw1+NN8uOO+GnKiFitv97Z4pDWeX92o9YnbAHCPAYf0O2njuJC1FKeX4
 1sBNEDUh
X-Authority-Analysis: v=2.4 cv=R8oDGcRX c=1 sm=1 tr=0 ts=68cacbfd cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=rKeXGq08CVa402lCTmoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: EX0LyWaAr9H_o1C6qQrgirVdE316IUWH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DDA53100011
X-Stat-Signature: pbj1fyi98jjj8i1jpgo8oc4gbokdfmre
X-Rspam-User: 
X-HE-Tag: 1758120973-342078
X-HE-Meta: U2FsdGVkX1+JCinMjYjcOxV9TtcKWE11X+rCQc+AJDa6D/+Xu4GLE3MvZtO2jN2XzGmFIqAuwcOCiNO1C61QBKJQodW3V2Z7e1EEMEKJyVHsdJvOMwBBnODML0LxsddFJ5JVo0Bhinz+mfq3ttnjSCG7lVXIARB+Quw9AHBGi+5NFZGLBrZMth16gJmDRZUkwYxFGZgXHcOEq7olKSlC3sOXEZae3JWkLAOGUkLAQNUQ7l+gPd1bYOdhiUKFNT5bdzJdeZG9hk3jLFZcfQWPAfoNWGMhkueN0UTwezQeebQ79JApsweyS3QaZMo1FlMKdC9cer3wSfWDMIHTpeLXs54OClJjw6dFHgytSW8T/a4o3KlThe6c+jFes00mXnoHanX3rXg5tZCw4iUoP7d6DLaUs22FjWYoc3qDv+nE8jKjVoYa58q3UUmXP0Tzb81gwbCDeEpuHfTUcsdoTJ+qDDQ24fnXce9T+vZHAnqNtD1sbC0V9e5ZNPDS2nZSO8R0q2YdPy3EqvgeskQpxcuSkGxifQCz4Bz2SOPuioVzf4Oxg8imeEd4fv6eQVhZu+1PmpBCYfB36PnSpuIoU+Zw3snSXU6Jj3Eq0ml+oebTVPkzbtiWEvCDFqVnpcxUUy4Eb2EVbXnkFuO/xO6HuegswJdfpUQRRTklqCrsAyT5QKsWLlCrrQpwRWG4qYkW2JYm/1sqo1PoWmzeTrVQFT39SGF5uRp8QJLyiFFnsZ8OKiDnk/C3BC4shMEKxrlUIDG8oB5g51NYV+en/B9p1IT+fsghojmEpbH2MUsDCdec8KKiwc7qYMf79wyu0rwuX0ueVo/DKLlpVT5WgLlsVc1/OCkaCnzVVAQeG3Eza4TR0IC6r/559iuWQee6Ux5LDnU7fgq7NxXB2J294RePtf+zfAnHFos7zkhLX7+kEOnAWeSY/2fVvHWtzyomn1Y4khz47acFqM3XGEM3/KCKvzn
 SQbS8HBt
 Qa4VFQsAgVAYbrPCgBjwB6kPLE6lAmHoYqVqwDBApkOSWGotjf5maK0iLJrJuMZpQDmmpM+tqSOfa0iY9z7lTDh+ybgm/U4Y9ZYyuDay64G9RqPjfkqRBU2xlsqxi48/fhbfGMhtcBRTyEeqVO+jKMHWHVOfFYUpi++n5k65D88WqawrrbR2dAfddHTdNGYnk54yePEujNni9T8nHb8Exe7MuAVp/5MU10rvVFtiEqcg1E6hRPKoZbLonkVNFcR/spSnaaHplXaa8t6bo+R4u2iJqpFJmLtqHj2IznDKspClwkTmujYRd6mmKZ/zTz0pb86ZwKXD8d/PXRYlqmrHih+xBoXLJMQaa3jxNCF+Flv1tVs/lpLiXr9jFmI+bLyeBXnxlHNtGRO00KB/IJEFn+wvcKEYeGBzfdQ6N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/17/25 7:15 PM, Chris Mason wrote:
> On Fri, 22 Aug 2025 14:18:45 +0530 Donet Tom <donettom@linux.ibm.com> wrote:
>
>> If register_node() returns an error, it is not handled correctly.
>> The function will proceed further and try to register CPUs under the
>> node, which is not correct.
>>
>> So, in this patch, if register_node() returns an error, we return
>> immediately from the function.
>>
>> Fixes: 76b67ed9dce6 ("[PATCH] node hotplug: register cpu: remove node struct")
>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>> ---
>> v1 -> v2
>> Made the changes based on Oscar’s review comments.
>>
>> v1 - https://lore.kernel.org/all/20250702112856.295176-1-donettom@linux.ibm.com/
>> ---
>>   drivers/base/node.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/base/node.c b/drivers/base/node.c
>> index c65b4917794e..1608816de67f 100644
>> --- a/drivers/base/node.c
>> +++ b/drivers/base/node.c
>> @@ -883,6 +883,11 @@ int register_one_node(int nid)
>>   	node_devices[nid] = node;
>>   
>>   	error = register_node(node_devices[nid], nid);
>> +	if (error) {
>> +		node_devices[nid] = NULL;
>> +		kfree(node);
>> +		return error;
>> +	}
> Can this cause a double-free? Looking at register_node(), when
> device_register() fails, it calls put_device(&node->dev). The put_device()
> call triggers node_device_release() which does kfree(to_node(dev)), freeing
> the entire node structure. So when register_node() returns an error, the
> node memory is already freed, but this code calls kfree(node) again on the
> same memory.
>
> The call chain is: register_node()->device_register() fails->
> put_device()->node_device_release()->kfree(to_node(dev)).


Thank you for pointing this out. I will address it and send a v3.


>
> [ This came from automated patch review, but it looks real to me ]
>
> -chris
>

