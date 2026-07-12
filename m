Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A6CAC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 05:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF2956B0088; Sun, 12 Jul 2026 01:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA33E6B008A; Sun, 12 Jul 2026 01:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6B2A6B008C; Sun, 12 Jul 2026 01:38:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7E9C6B0088
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 01:38:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FE621C4131
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 05:38:13 +0000 (UTC)
X-FDA: 84979018866.20.8E02423
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id D7D73100002
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 05:38:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=tpJ8bAHU;
	spf=pass (imf14.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783834690;
	b=CgY4LISRH6oib8CpKz/fHNh08WubE88HH8ZVt2ZJEwm57OLS8ibL0iXfnXYcAbMsP5qpIe
	xvA++qvsWO21WxKI3uvcvMfEIx/8Lti+YOTIGhsxdbYgxdlNHSOT5QwgP1FSdPqmwHGPQW
	R+YqZx8wk3nHlhvg4grmJwMvTGhQLfs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=tpJ8bAHU;
	spf=pass (imf14.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783834690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FmrEDx8QxMchU1PCvAPUFKd41C7Mk0v0R+yTy+YcmbM=;
	b=h9dbQrWF805wb1OVdiLvLWLb03VZRm2HMiy4UB2c+6PKQMFA/V9Fbw/Vpxtaw3n0Yx7zaD
	xGw0/hKRI1/tmosfZhPaKfwzj7Jh5XG5M4pu/sD4fVuNJLTx7nuZQheqX2i7YFL0eljBIX
	NXAdiQX0TH7eW5mrxmW37+HQZRquD9s=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66C4CC5S2755698;
	Sun, 12 Jul 2026 05:37:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=FmrEDx
	8QxMchU1PCvAPUFKd41C7Mk0v0R+yTy+YcmbM=; b=tpJ8bAHUG8kPxxb5vGDVIq
	6O5OoxQhtwfjsmnXCd2wPVjFCG8s7O6+4vwqq0p+koTTBEr0W06YF+vTNvvcrgXQ
	uErDvCo4TgxBLBY4BNfMvygotU2aenEgChUqDSCtS1AIxsgnfMmTjyYaMOqBrr2j
	BZcZME5i+Vgj8lA4KwhMnkGwpmP0SNh6nhgY/R3raZm3LHZPBkLP/KKDrMs1aIAI
	kKF97QDynKp8g1JKLN2VAPdx2QVslr5MAscOeusdaXc7AHYn76vqHtE0nVSemyZL
	rLnia2Mx9psjE0pWsyaM7iFbR6U+ukROXTXqHUHANvnP1WhB25kF7Di04iIhH58A
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fbf29uagk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 12 Jul 2026 05:37:48 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66C5YbmF028137;
	Sun, 12 Jul 2026 05:37:47 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fc0hvrr7k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 12 Jul 2026 05:37:47 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66C5bkdm31261284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 05:37:46 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B34F58045;
	Sun, 12 Jul 2026 05:37:46 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8FC2E58050;
	Sun, 12 Jul 2026 05:37:40 +0000 (GMT)
Received: from [9.39.28.183] (unknown [9.39.28.183])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Sun, 12 Jul 2026 05:37:40 +0000 (GMT)
Message-ID: <ded27d4f-3e66-4cd7-9757-a2e52770c3c4@linux.ibm.com>
Date: Sun, 12 Jul 2026 11:07:38 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH v3 0/3] selftests/mm: avoid false failures in hugetlb and
 KSM tests
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>,
        David Hildenbrand
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko
 <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Miaohe Lin <linmiaohe@huawei.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1783446924.git.sayalip@linux.ibm.com>
 <20260709185319.cbf0c39dd47ee3853d212b7b@linux-foundation.org>
Content-Language: en-IN
In-Reply-To: <20260709185319.cbf0c39dd47ee3853d212b7b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDA1MCBTYWx0ZWRfX09MeEcG0vjIt
 7v6YhGGQP//AxKeZoVB57S/v5Phrt2sipl8TptJHgH9R3xgwWMmFzFq68NoEhGw4BHn3N6vcK2I
 uepkizLnWsilGBPM/QUSaAZ6f9RUClY=
X-Proofpoint-GUID: f_xJzRtk3x_iNQf7hVMdY4rgOoSj3IPX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDA1MCBTYWx0ZWRfX5DgCAFtuws9Z
 DIi8QDJ3z9AJL0DbldWqZCL3vjjogx8PrLV8bysPv7AuZB72j8iIUuizKjW9EhXXTvLRI2Cm8ZI
 OpNtmucVuHtbBpvvaNRNMxiP6Zk0rZN6qzZZeIQaOwkV4FLFNqHLs8jjQ4IJAbhEZvhcLSR/4wN
 TR4lK8q1CgVZUKo6+hitjdN9koo89CnlqF3saGiGmDIwktXIi0FBYAXrJyZSbRXKd7AyeGTxPy3
 63rRzBtxfyj83tWZeuEyVe5DmyCHo1Vw8kMZ9kQuoGv/uq3grwcV7zAm6oVxi/dN8hLspgmrJtS
 B4VrGo3w5JJLIXKarQRbyKEuHsPyZHG1gvaQe9lMBwkQRqVlXJ9rLwyavr6Dt/m8PhiP2gK7J/K
 /ZU9IhPpc8cBrFxZjWxn0WADd9mPQQ13vW3gYKOYGxQ8dHkWvQvxvS8dpy2IBPi5ELFVks8PkT2
 fOJ5YdFensaM4cgXIfQ==
X-Proofpoint-ORIG-GUID: roN63tJwwzI1npq61pQNk0ybmXMzHcGC
X-Authority-Analysis: v=2.4 cv=PvajqQM3 c=1 sm=1 tr=0 ts=6a53282c cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=c92rfblmAAAA:8
 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=YLSOTn8K_J3FlFHuE84A:9 a=QEXdDO2ut3YA:10
 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_02,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 spamscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607120050
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D7D73100002
X-Stat-Signature: 4jtwuocdpua5o9ujs8y5grtetmg3zt9h
X-HE-Tag: 1783834690-370407
X-HE-Meta: U2FsdGVkX18++S1mC8BAwN4nIZBi2BJjNVNIxoIVzHEWrmorzTqxvEj4EB6Z525dLD2KR3PZQOYiH9dEbH5rrLtore65YNBCKHU+43osnkNCSol0khzBVmRw72v3vJ5kTFbjgWso9suD6AxQcZ49vuupgI67S/+0R9AdmiZz/bvcougiTG1Y/Da5q/YlHwL8X2KVWWXCtf/tg/2tNDeiZUxTASpTjCRCWJ6fw52F9+jWhBDfQNNjvkAnN1AmVNmxeRozq83WR+4F91eJQ4Seb1n8ng/cELFSxEX41PrdudkjWdv3N15lhQNsrHuZcAzHAmwWdH5jBDzN5q62R9sUgcUIIihXqJrYtzknIb9BJASUFmiZB+3J62oKfu0xm+p1dN5Fd/WzGfrN+BLdi8b6Qr0Kz1tWQ/qR6ybK2laTb31WmNS2ptDKuTlhHqe0r1HQWPgvV57u7YAZ6vFuN47/y2GJmH77EPvjZv7wStKlONkruWRCX0yTZDkQCR7zL/6eBqvUn7p12esC2xFEs2C8D8vxrYnASgv5ebJshBfXREIA+C66NHuzbfr5wEZHxF2CJHyXTQsVyDNTOeMCY7hWAzB28LDrv6tQafibx3W1u4mHRSpVNFK4LsuYoHXoKbF3cBofW9TpV4ae6rDLKafbNP5Mwm3Q/4Z5Wlpw6T+7Xp4z0PIianPTqiIi22Pfd4D5zdWWD/CkB0hYuH3IHJ2KfPa3VFgDvW6JVjBhExlIgGiLR2Kv2jClQ6iDzF2+XCXcAozdv9foxJ5NXZFjk5aoWQ2ybrHOCexRbT98O66i7Hpyr8bAkikjfUrgCsj4LmTNCoKM91cG7sSMkffJ9mczMOVw1gUTWrQbaU/hHhst2KDJ1cHq40BxX7PhDHkGR9Nn5Z9Fv4NKDQ6QT/iK7Yavm6ieqyAl3N47N0R7BDbHXzakMYyj/NYeMq8L6yrIO90FDMN71XoGub/bGMNPOXw
 pceIEvZE
 UjTrv223pNUBk7jpBBz0fwwmvdsEMHJoKTpAI2Mg8Xe1OdB+Aim6TvOqIoPbJwhgSjTV0qq4Nek+N6p+WwOAzPv+TITKDHVs/oFjLNdJvDAHMO8S367G8RUDtdm2I3ynSeTEqsqyyo6dmuCOEavrCGABNijzanZh9ORY73gnJ2uHwqX/FWgC5SANLobZKUQPryBMPaD+UeE8ZOsWarxgXn9iug+14SzOOvMaNKHoudu6xjiaIr9rbkzbzMTUMcR5OLChLX66Y3a+IDaMRZxzmAui4d4T02LsTQosbsWMYL/J1QvctnAoH8x3Idux9bB68W8G0XWAIgRVAqY41uJFqJtosIL/4YnnEQyQucYSiy70MqUXAziCd7/MxlBBs7uUy1LyH3i8T/IJfnzKpeBstYad+tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/07/26 07:23, Andrew Morton wrote:
> On Wed,  8 Jul 2026 12:29:04 +0530 Sayali Patil <sayalip@linux.ibm.com> wrote:
> 
>> This series fixes issues in the hugetlb and KSM MM selftest categories
>> that can report failures when the prerequisites for the tests are not
>> satisfied.
> 
> Thanks.  AI review asked one question:
> 	https://sashiko.dev/#/patchset/cover.1783446924.git.sayalip@linux.ibm.com

Hi Andrew,
I answered this in v2, as the same question was raised by Sashiko:
https://lore.kernel.org/all/d73ef56f-077e-4995-993b-56b2c58b6b65@linux.ibm.com/


Thanks,
Sayali

