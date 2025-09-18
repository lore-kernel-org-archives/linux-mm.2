Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50801CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 06:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A716F8E00BF; Thu, 18 Sep 2025 02:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A485B8E0093; Thu, 18 Sep 2025 02:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95DDE8E00BF; Thu, 18 Sep 2025 02:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81FBC8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:46:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3BA9F1A0779
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:46:17 +0000 (UTC)
X-FDA: 83901436794.01.8F9FEC1
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id D6AF840009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:46:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Sf5cA2Tq;
	spf=pass (imf07.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758177975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmyeBES4QYQMD3WHm2ocxnsfboYzNZugX1gq0nt42Ro=;
	b=Y+Hb3dM3BImgFkb2wIxZEbBfQUBpRnvBCGUfu8vgp5W2PF64r+FkWubi8kgvgCPI0c9Udq
	OJWKvUKc5A4Pa4ItEv3AFEPnPXW6ml4XxFXlTaWqwXLQHiWu7AsshAzUFm1ZakaQ5lX5wz
	q7Zr1+vpr9CNDtpNg5Cas7gaVlDaBKU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Sf5cA2Tq;
	spf=pass (imf07.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758177975; a=rsa-sha256;
	cv=none;
	b=uqLB9kjI40j351UV19BCyRlbh7FVG8ZU/CEZ781iciL1RY1tzi0MojP1HH9ITBCaF8i1aq
	QHeqyWjia6v1/bq+mQIfWVpWOW5fgsIoKefEb0+seCpA43Vpsp1KQWnkSJha5Nz9qDp5rp
	iPV15OO5CSftaE0UYsSI5C9c/A6mRZo=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HIalYU011054;
	Thu, 18 Sep 2025 06:46:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=UmyeBE
	S4QYQMD3WHm2ocxnsfboYzNZugX1gq0nt42Ro=; b=Sf5cA2Tqtu3t2jFLNJPZDy
	qJTWKGOrMZ4SwISlXZWsMV0cdnk0nWB8srPg5nEvbXKlhNdhRsm8PrTyYRbx4sC+
	H3xAU400yeF0BR6VPftq9gHLIR9rfjDogTc4yO5FyiNkJuKLWLj+38bjcVIde+Tg
	UqK6fH0yL4x2KFybDy4agH+imLY9bGdQ2gqpt4vUiSF0uJVNMpJGWHRonpMFZKbu
	QxwdOMI1stIu0N7InaU9mL1XK5UGtCS1XL0lRzun6LmYqSjq39eXMuawxJ5u8b3G
	YkB//BXA2DJ/iRhOyfH+ON3ddtZm/2FKgeB11EwVVRrrZq4w0UBCkY4YdVoYTfCA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4ng2u6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 06:46:02 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58I6W6il029922;
	Thu, 18 Sep 2025 06:46:01 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4ng2tv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 06:46:01 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58I3FUH1009486;
	Thu, 18 Sep 2025 06:46:00 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 495nn3n0au-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 06:46:00 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58I6k0VV33686028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 06:46:00 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1CCA158064;
	Thu, 18 Sep 2025 06:46:00 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA79E5805F;
	Thu, 18 Sep 2025 06:45:54 +0000 (GMT)
Received: from [9.109.215.183] (unknown [9.109.215.183])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Sep 2025 06:45:54 +0000 (GMT)
Message-ID: <196c1592-3383-409a-8b4e-38ef1c215528@linux.ibm.com>
Date: Thu, 18 Sep 2025 12:15:52 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/base/node: Fix double free in register_one_node()
To: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
        clm@meta.com
Cc: Jonathan.Cameron@huawei.com, alison.schofield@intel.com, dakr@kernel.org,
        dave.jiang@intel.com, gregkh@linuxfoundation.org,
        kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, osalvador@suse.de, rafael@kernel.org,
        ritesh.list@gmail.com, yury.norov@gmail.com, ziy@nvidia.com
References: <20250918054144.58980-1-donettom@linux.ibm.com>
 <5512b1b6-31f8-4322-8a5f-add8d1e9b22f@redhat.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <5512b1b6-31f8-4322-8a5f-add8d1e9b22f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=MN5gmNZl c=1 sm=1 tr=0 ts=68cbaaaa cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=imvTE1wgVU1FVdfX0jYA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: l04Thvrv5UYZLP7kR0BDhfQtkmNnzQK5
X-Proofpoint-ORIG-GUID: n0PqdEgIoQTB6dCL5DnTqMuUmzVh3SsI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX7XZVJ46u9mjV
 gtRw2U+xyN1qGj+1eBEz3J/cMjWfJ8BdWa5fAD2JloyEl6Id4q7F2XrH6juJhIpxXlzmTrsd/xY
 53ktt5M+9vjxOo8Fd/qdmu9+f2w948B1+VJ8UTgO74jA9U4Eykbv1DcEFgXYkeyaSpuvMnQib4n
 EKndKxGxR7g2sQc4phhLaNtxUa+G/qrddKkt5/eNr4s1fgpCLQkBdnQoTGRqZz6QPmf1gqdpu+/
 qoS93FEgGpyFg13oVagzYzgSdwiSnJzXTmEmUQ4YlY961toMET9+1+GEl0d+qHcYXPghWzW2aqF
 ABNw03BvPCwUcER54uXvFKnkAxJ/DaHy1/fW0oiBLe4udlNWmrcMiQqFY9dNPIbNoqA5SuFq61B
 0BKIGG/K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-18_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204
X-Rspamd-Queue-Id: D6AF840009
X-Stat-Signature: tahequaj5y7eqswnow4fb7gk8xwjnt9n
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758177974-722403
X-HE-Meta: U2FsdGVkX1+y5gR6198jM3yTNMQ+nunWk3FjWghPFt8rU7qTuTPk5sCgCRsFKDucDW4E6MkRRBWtSiGiu1VrNcifNbMOrTeM6i70hdWj4b+B3yEFqm9Xyz5Rx+O2/LDfvQm+076k8cgJSsSuBKCen3PLWEBxHv7TTbyOsWyZsHNnLF1oyYRfgrG/Ur/ILkW0ugTHRZLAoGL3mwI6PhGv97fpvgYeCzqo5MtGppfifM8gvriG/4pd50Z1A9fnkwGS3toP0V8ax0TsW9+o/8m/d4P/VpolGjosuzcl7e6slOD65Mhvmn1VDA8mO1Tm1WBBm6sN93HSdroyXv8OyZVhn0k7OZLNAPmxR6XaatXwxISnYom4v5CENOMA0L1Bb13e6ZhJFUmCyHOYd3w0qQ0DUCeKV4mGlAkfPrDlyFpky0eVRw61aOLEIgtdgJLRWE7xYgQxtOr3L6/7LcBydky4qzMgCI23OvT8M1uCDP0rKavu11TIUDCMfrokvJWG4TfH+trO0R1TKRgXr+yREon3xh6uA+YXnGz7wykqEP6ES76Wmr3gJzdCuoZ/0sKtjaeHO/spgBuAbtWU8uC4x7i29SYf7v7U4cavHGIBZ3nLoAfvYTmflyw8Y0i0uQvvyQEedZYdF4kF2am+IsG8Mas7fg+0Zu01E8oImaTzwDBEHhGn15+V979VpVJPXNfj/c5eE1O41vUJNXWAl6UMGAJkkGUbzD0gSSWxxGsqRugqUYM9aJFOOUY/UsyvjFwBGesfbC5Jdu42YnOqtkUgDFWY0vQZJYwCCuW4cc06W20ZU4Vvc00ugz4BiYcM0ARjpI6sNWIA7ZlwmJyF1jW1vZDBXcBg5A0nvMj7anwdluYqkydU4mFijOWfVzVQlwsjBiDhF0i1rshZnBCi3G4Oe0hss9AAJGzJtZtyXW48TQtj09QTtStVIp9xAFj8Im/ju5e4NagHRQXT6E94ii2RL6q
 iwAovr4t
 zAJWkdzIpx8XABtZ1TXkqGVhUUEyy6GmJ1/xLAdBybzEEqjQWLBdsHXXOiujMXruIhQUnStIYtqeQDXd2vL1/GqW3elOqsA5YscPesHMfw06sJ/k1Fz5HEJhnrq13DpbE4vgj34LmWrACzFGWliqzvYXRXKutf2oOig72OK9IQ2Fv8eWDkqxpES+coGIujRE8r0zycwxL0uKofEEqXD0/Z/ZOZtZLBOnhURvfCCIeypAJ15JxsblYcRn9irVHyvp7jBprpQOlq5utZUZz1r1envAqNsKwgn6uLsl1a/2D8sauiVz3FxkZ5G0ZVsVTt+/sOz3/ra9aI+RdIwdBtY8zBfCVRBzh8cQVt5/qpQn3xm8sKLnEOjX+vMAsYKNbinStyzH1avYvi7gZGOv8E++CEcGittiAgyxlNuhse8SpeWv7NV77alaAm5QSiQicHxyc+WAbzUdv9VGCbUAEtIf5q8icAuPu+bRNZBYWkhDAmCiN5uzgvyLXVC5fq35WriYNEgxVSXmMkWZh59c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/18/25 11:25 AM, David Hildenbrand wrote:
> On 18.09.25 07:41, Donet Tom wrote:
>> When device_register() fails in register_node(), it calls
>> put_device(&node->dev). This triggers node_device_release(),
>> which calls kfree(to_node(dev)), thereby freeing the entire
>> node structure.
>>
>> As a result, when register_node() returns an error, the node
>> memory has already been freed. Calling kfree(node) again in
>> register_one_node() leads to a double free.
>>
>> This patch removes the redundant kfree(node) from
>> register_one_node() to prevent the double free.
>>
>> Fixes: 786eb990cfb7 ("drivers/base/node: handle error properly in 
>> register_one_node()")
>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>> ---
>>   drivers/base/node.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/base/node.c b/drivers/base/node.c
>> index 1608816de67f..6b6e55a98b79 100644
>> --- a/drivers/base/node.c
>> +++ b/drivers/base/node.c
>> @@ -885,7 +885,6 @@ int register_one_node(int nid)
>>       error = register_node(node_devices[nid], nid);
>>       if (error) {
>>           node_devices[nid] = NULL;
>> -        kfree(node);
>>           return error;
>>       }
>
> Yes, that matches what other users (staring at mm/memory-tiers.c) do.
>
> I wonder if we should just inline register_node() into 
> register_one_node().
>
> Then it's clearer that we perform a put_device() already in there.
>
> On top of that, we could then just s/register_one_node/register_node/
>
> And then we could do a similar cleanup for unregister_one_node / 
> unregister_node where I don't consider the split function really 
> valuable.


Sure David, I will work on it and send it as a separate patch.



