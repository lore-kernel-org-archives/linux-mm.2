Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADD35CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 04:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F53C280028; Thu, 18 Sep 2025 00:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0088C8E0093; Thu, 18 Sep 2025 00:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E127B280028; Thu, 18 Sep 2025 00:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA3008E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 00:56:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5FB7B5B67F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:56:09 +0000 (UTC)
X-FDA: 83901159258.08.FBA59DC
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id CA3F918000F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:56:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HzqxFbJJ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758171367; a=rsa-sha256;
	cv=none;
	b=NulwBtk3L7DMa0vgY5b00ihzd66Rywm9FJdVjWj/KL/fTfvmH2r+SWY/CMFTqThrO5vSf0
	1zlzvunCtH1AIB6zsI6oQ22At0JQ5dzE8PhHtZaurhu4M+EWM0Tdz32t4kMX0gdruB+GNK
	K7tN5jN8ysXQqBFQ1u0m+heT1ji85eg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HzqxFbJJ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758171367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NotAuUShrSCvXvm4Q5gT+Oz5+LaDyGv2IOTdAjj1U5k=;
	b=ZjEYc34h2Dx4u7VVR/ajsv85yygJJlDaVnQ1DzrO+w9hiJ8Y+iwJAu+XLnDjDs3iZ2NC7S
	oW6+NljqtgJT7yQYjUPBrv0O/jISQKnW1cwWOvdvOPDF0P+bLWvgGSTq+BXaRub+QgT+Kj
	ZGarZNbXb7VhApcrqBYDoQ77GOJpTY4=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HIWI3b027152;
	Thu, 18 Sep 2025 04:50:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NotAuU
	ShrSCvXvm4Q5gT+Oz5+LaDyGv2IOTdAjj1U5k=; b=HzqxFbJJhi3a4bB9d4Tv/A
	UHuVpokOUbsJGvmP1S6linVLxCE/k3Th5TTXlJT1y+pPAutk3FJFp8WAjMSQzbMP
	kfYaMMWD45UI5GzfJlsefrn4xOOlMY70GBvj6FEUBwU5og6lpzOrv7u0YBIpudPU
	ISxJAkL5PTSxGKAEj/KulSlgwlqZC4m/fg2JSO5Q4GigGqwmLiRBIW0mUspqDhnp
	6ZeCl6pwH4qwxHjr/+1+YhLspRRC462bK3QAF5PywDquLOkRIUgRCyJg8rbqyqjA
	r/ke/duC3yZEJr+dUkWmSA6V2b6BDYRloBdA9cDHbCq18bByrU3D+uFpsXKxdGyQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4p816e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 04:50:51 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58I4oouS010353;
	Thu, 18 Sep 2025 04:50:50 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4p816b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 04:50:50 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58I2Vlkr018629;
	Thu, 18 Sep 2025 04:50:49 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 495n5mmq8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 04:50:49 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58I4ondT54264216
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 04:50:49 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 285AA5805A;
	Thu, 18 Sep 2025 04:50:49 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 73B0958056;
	Thu, 18 Sep 2025 04:49:46 +0000 (GMT)
Received: from [9.109.215.183] (unknown [9.109.215.183])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Sep 2025 04:49:43 +0000 (GMT)
Message-ID: <e6f5d1e6-afe5-4225-a672-7523d04c6504@linux.ibm.com>
Date: Thu, 18 Sep 2025 10:19:38 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] drivers/base/node: Handle error properly in
 register_one_node()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <clm@meta.com>, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, Zi Yan <ziy@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        Danilo Krummrich <dakr@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Yury Norov <yury.norov@gmail.com>, Dave Jiang <dave.jiang@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <20250917134604.2149316-1-clm@meta.com>
 <676712d1-7b4f-4614-bd82-5b0c43881865@linux.ibm.com>
 <20250917144844.e8d9b9593aac9f3a4b52a0cb@linux-foundation.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20250917144844.e8d9b9593aac9f3a4b52a0cb@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX9n+UdE8F3voc
 Zb8tlE4PplCfB8r+8NIxpOSKoyGDzgNY5l3sNA7MFra6V7pCaIMB4byySaUp5ftHOvcmXlCD27B
 KXbGFXTnUDkFz5HGfXz6C5LEd5pmVQgubArmmSximt6pZBL7wqv+PcMyBlQ96M/OuENiV1ODBzq
 vWLHNijjFY+SA+A9YcwkibOuIM2DgKAlTtiV0ggmF0DiwKF529bU9jpkxpCEZs/UhZefX7EE3Vf
 LnX5fbAGaAct+XwQw+L/4GZs+LK4sZ4Ddu669qvZdaOR2IapjXmW6Yn6rBpPc0BUedGKj+6uA9M
 OlCGpT2m6yHJzQny3bqansd9ZOcmkHW+9Hmka3jzfupUflO4SdUY3XiJr31vzrtU3ceMtZbUfAD
 z7zhT7+v
X-Proofpoint-ORIG-GUID: lbaNMzgAgeoT0IXfYsWgEKGFdMi2SmhZ
X-Proofpoint-GUID: m6WOCbN5gXP7WPh1-QjaVSYAsLzyPdmd
X-Authority-Analysis: v=2.4 cv=cNzgskeN c=1 sm=1 tr=0 ts=68cb8fab cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=AYsY0RiJbjKyjbCzuxQA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CA3F918000F
X-Stat-Signature: t1hpb6fh7prd4ni3cf5pcwejs8ypmoux
X-Rspam-User: 
X-HE-Tag: 1758171366-418467
X-HE-Meta: U2FsdGVkX18pCQHgURBlRyYERJVlMgZC+j3g98QbahEdotzV1PXJJdaTiaD3ju+lT2ZM0CgsUZWFaPAximyX0XtLFKSkXBMbDKJh/eESpALBFD7oSDr3JiPuufzzse04JG+n2ouuwYDa3ixCEf2tOeuOFTBeXM2rI5Vb7IoAW2dhVeIo/Nk3PTlgKuMEq2f2j2hSkyPvbj+INQCLszGyiv/0h2Hg+SgmO8azGuyV55JYwYRd0wiWv51JP2wPfic19dhiSbF7HAIo3Yu2igEFZQCqq+q3A2DvWT3XuZtrb6/dJQ9e6wTPGQkWnpRiyh3KtwuQu4IJAk+h3TNc9o65RqVaLVVoh6Te8/oWj0h+9JXNLTlFXZ+n6uhG1npw6ukd4Q18Az7Odg7EudbQAbuuwwXh+rHU0kNoP+C9XwUbKWW9gayC8oJCba25wizkAbIAIPBQNloN2KgnQ/yb+IN9Q6Ez6O1U3jZx5ZcbXIfyGUxtL14DFzT6tj0pLCdX/gRgbMYK1dKmXXyxXHv6eQk7+VaM0s8Lqbe90AX/5bQYXzOTJ6iLiRtS9MaC2PGLRndTSuzcUjwBVwFA4t7LC9ShtoAKSalO4CD7eYQMLUpAVdex6nmBajpWOqZ8jyD5TrDauE9KLzW5fcOTdqecACvcibdiVjIs0w+1zC10PigyIMPjj2TjsSS62/rIYldNo2rf82pLImSuIqU69fXEBg5XqNXVBEPHZkIlncaIJgFmCIB6KawqPUFuLuyzBl8ZXXnnh96fVYyT0H4Fviq6tAEmgr/sWZRaOv6hrdBC1GKbp9p4nSEePmWrkEwx6QTVNk7Xs2jufnOtN5BfIbhXEpsgsESg46o+9p53Rnldh2Iy6OM7GnB17DVP40BDdE0F+rI84Rn4NSxgSFxzZSC5Vi2eA0W4H8FC3fQzksS9ClOFqPIRN9WD8BxcDru5uRGg++x24wsZn+QXe7PugFAxqg3
 vkCzq2Dx
 DPLu9Vk+N9BJsxW6av57iiZkeeTh59LMpgvJmFA2RwWoB+wEDXBCjOA0jHN54PHDnQNpePAUkxn7K3tIYTzuqM94nNE0maDIkEi+GqmQMT46k0OgeIIZ5Qa1hdDESoY0fcxo/x79+IMPyHDHaGVJ0OMo/V6plUZhc7HN8ymMUV7D+NvjH1ZBC06t7ZyUPdnEg77x3Ns8JcO/dI+nn8XK/wD7tlVIvhxqMxEomNVn255h9e/nRTTBctDhtx9dBXBodPTDOaZr4agY9kEI5t9gR8clD8cXDsBWtj1knidq5dK2U6p5fUkNU6+h+K9nniJjkrPIbS1+6J2mxxKJnSQAJPnwhOdP8H47KH/k3yQz8eahlqkUplkVcMy7sV5yqHGrGKH5MXrJJ3JVxGIscZuwT02dIfOoczJWHEWqXhXh1kdaP4cajz5p+B5WJyIW5TORXbvDgkMDf1pBV5G1XuGvnHRu1S/QVhzf5xIyPgO6Qkzs9Q2Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/18/25 3:18 AM, Andrew Morton wrote:
> On Wed, 17 Sep 2025 20:25:48 +0530 Donet Tom <donettom@linux.ibm.com> wrote:
>
>>> Can this cause a double-free? Looking at register_node(), when
>>> device_register() fails, it calls put_device(&node->dev). The put_device()
>>> call triggers node_device_release() which does kfree(to_node(dev)), freeing
>>> the entire node structure. So when register_node() returns an error, the
>>> node memory is already freed, but this code calls kfree(node) again on the
>>> same memory.
>>>
>>> The call chain is: register_node()->device_register() fails->
>>> put_device()->node_device_release()->kfree(to_node(dev)).
>>
>> Thank you for pointing this out. I will address it and send a v3.
> This patch is now in mm.git's non-rebasing mm-stable branch, so no
> replacements, please.
>
> A standalone patch with
>
> 	Fixes: 786eb990cfb7 ("drivers/base/node: handle error properly in register_one_node()")
>
> is the way to go.


Sure Andrew .I will send it today.


>
>

