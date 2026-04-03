Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 231CAE8538E
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 19:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643306B0005; Fri,  3 Apr 2026 15:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3E36B0088; Fri,  3 Apr 2026 15:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E28F6B008C; Fri,  3 Apr 2026 15:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40E686B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 15:59:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D02E08AF00
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:59:48 +0000 (UTC)
X-FDA: 84618310056.30.63E9EAB
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5E67E1C0007
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:59:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=S5hKRqq5;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775246386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OVNyj2Jj76qFM+tO9FJUNvpvUkWT58xHyWuu5jTOYlw=;
	b=MVH5mWpMobdMzw0VY92or8WcScinaUR8znPWxtT1fhN5JLJF42xZKCEa4KOZcsZoVaTjWK
	pHmmlJuJ77MG7vOJFvUAROuBjnL7ZRdfy8lNg0wlf3599D/K36SYOgmucwUcUV08p7WMbe
	dZSBXqZZE32FqnX1C/MOGmfGTl4qmns=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775246386; a=rsa-sha256;
	cv=none;
	b=kbk3zH0olcvuRMXDcqxf1yOu3tOLc4xSGRpD4y9GwB5mtx8zwCKkVpDwkfIAdu/FCxD9+w
	5+PQ6S0twmW02stR7ML7kiKJygQMEdECziCp2R1ncnq7wEbraCz5vfiKvt+vug9k2rXpcf
	1CfNAPpqfRr2geM7IKxL7KiOaxhZDAo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=S5hKRqq5;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6339lP8L3728728;
	Fri, 3 Apr 2026 19:59:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=OVNyj2
	Jj76qFM+tO9FJUNvpvUkWT58xHyWuu5jTOYlw=; b=S5hKRqq5XMw7x1MN4VawRp
	Z55hyQHiaeEd8V7+mrdovCPVhK9AZLZgR7QxeDWpD0p9NhZ9NtFZVXJwJC1XLn85
	g/1sTH/g4/s17WerFAGL4lMvCu825UEMJWMHv1Irzy5BgzXsODyp3yFtPESlCJwB
	DvV+ceNOPSSUNjm5hciaunOuZTmii3DZHEPf73p/tp0G9QfuPhwOkz88H+RDSePY
	YVjUv54OWF2x2qCzx782dU2WRzUaBsVrk689a5dgQSe0b/YeeVm0lHTtNXfuZwXb
	dEzuVpStxl6qiIgqT2E/weiG8crA+Wa7BE0ttwBLaKkueYfALJHl6Lv7JdbAcROQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d64dh14pj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Apr 2026 19:59:39 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 633F5C2N031552;
	Fri, 3 Apr 2026 19:59:38 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d6uhk75t3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Apr 2026 19:59:38 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 633JxbMV7864898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Apr 2026 19:59:38 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C21FC58061;
	Fri,  3 Apr 2026 19:59:37 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E69795803F;
	Fri,  3 Apr 2026 19:59:32 +0000 (GMT)
Received: from [9.124.211.212] (unknown [9.124.211.212])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Apr 2026 19:59:32 +0000 (GMT)
Message-ID: <e8286f08-abcb-4b77-952d-228ee1dbd705@linux.ibm.com>
Date: Sat, 4 Apr 2026 01:29:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH v3 04/13] selftest/mm: fix cgroup task placement and drop
 memory.current checks in hugetlb_reparenting_test.sh
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <1ac1cac332a692e8d2dd70922bb09c0582340143.1774591179.git.sayalip@linux.ibm.com>
 <7dadb91c-745d-4fde-8a2b-c141b26823a7@kernel.org>
Content-Language: en-IN
In-Reply-To: <7dadb91c-745d-4fde-8a2b-c141b26823a7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDE3NyBTYWx0ZWRfX5MBkzgzA1UV4
 qMVrVKeKymhEVQTmw7N8t1ma4JJlMHknnQcknGuiI8QNTP39xAtr9A0tNvfRo15S5zH7H2stqNy
 r3Dwdf6EQX2DTLHQhu0hTIqKm7pk+AkeSdjJwtv9EepAoU4vtZjlpEvIeD9KHdCnSHOv7ibbdg2
 ZLc2v54DrDuTH2Pe2vc/SBT5B255nBzZiyIQl8iWjCljzRQcDp+/Fy+8iN5vkQeoTXrPut8A/BR
 JoxyaGKtj00jjFdZSxVEewYEl1fKY00vyZ/v8RmpFLlDppopnSt/sefB4vv27F+5fGv5+0+PwiG
 IS/SzkrlkqfuNTgQZ7dE71a/uHUO+DhBBORwmxtD36/6J+IsnaCoNwTjKujO+eQdaAR10VtXE6m
 S3ygT76rodWUjE4aDxJQmCarHPGkZ4LwLrEQzEkWGkYSb284S1oyiWIVXpb7/bm0MBq1Aqu7309
 NIt1GrODPAYIZGzEW3g==
X-Authority-Analysis: v=2.4 cv=QKZlhwLL c=1 sm=1 tr=0 ts=69d01c2c cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=3LRxwzKv8Tv0BEPaKXkA:9
 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: KVFWCwqj010Fi5fKpLtM7gvpgDBcnRQY
X-Proofpoint-ORIG-GUID: BSE_BQcmlXWY7GF8pNScHrx-nM-SzM15
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-03_06,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 spamscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604030177
X-Rspamd-Queue-Id: 5E67E1C0007
X-Stat-Signature: 3dtrg7ju1gxrbr89qciztnts41jrpzzx
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775246385-679419
X-HE-Meta: U2FsdGVkX1/210yeR/Zcd5IiPVOLxVqBDcl70CdfqhC4lnS2ZuuN4d3ox3qaMIZBABorc9554NXBAucag96J/9Utrd0qhCZEnZv/DxyN0r5kwYMHUdih8FhXEaLuxhG3BITgQvyr9G/BHocZt+YHUrdElS4Fp/lhIRu0NWPAYeXlUAyFWhSfR9PtkPtwLuD3ppOjY6ZoInLcitXkU7apUtwhxnEou3FTV4qTJ2Zy0Nh1kxWLsBd8hD190Ei1fGXPaO+5HoWqyqVW7GyFD6NCyktR9nl9pE+l+JWV3RnzkEfVzPMqoaRQLX5XtFt9FRUk5jdE5sn56C2qItjVfJ4+nR7swMl8cVIOEEUYZwD8LS4DoN0rdpR7nULWM9zt4GkW83N+rd5e1E+qI3HKHbrc4ISnSi3hTB6PyLwE/m/bApZ74LKgDC/VrSUrEyT5lYVAXqNThLsRL7iLyzSS3Do017rTkt4blAfahWYbskCf3Fxrr8w00HuiBjxvgApnlFpT4etEwmLKx86BmypWsqPyPl6fnnD8vxz3RMl/rVED1InkzIalDBuq1S1vIflhANWD1GgPvfisy3EK0R3gLLTpbTjbR80qq72GOwtq7DCmTW2R3k/g3/AIp+4QDaeg8JQSDlqko4X8YbjQvPBrNOWq8lG5uxY6J70Im+udFqXFJDbeQ8fLRmXFxmEEe6/gD/GWQLMWQXVQ7aEwyw/qyPOjxbNBNDo8SjZxrVQ5OWmKYjRYtuRWZbJcPE5ptptKaVb4l+S2Yy2D+lNpkdP9HKdGJDvGOyroRK++uOIHq7gs7p3ucn03nwhdzfon4cejYhRD+RMPr73IgLpiO+ZmR+jumryAtNXWnl0jmu2otiUoHLrTkFeAf9CuEjhOihJjEEDT1bQOkEvYVNqCpZoXhe8xnWaVCVt4OFTroQ+TzJMtWxzONNg0NUqcSluT6HAE1UKo8fFClHmAOa3///fyI3B
 JZEJJNnp
 2VjyKTJxMSL5G6zkhVC2DSdITueJXktp3HIVS5D5CVZFmlPZcdXLr2t2joTqEZvSO+n0IvdKxE7kjf/jEoPr7PE3iPdx9XkhSzO4BtsaxmlDfiU7uvAmAG0MDBYkjEDUEyqobEuCZxNJ9YPUE1SV7/2AyptJVjsPv/Ms2o/o9N/QoAhmkAAobX37fYaVNJIe/fAP8vwrNPnkCJngz3tPIxZxyCfZyhffNXSMUf9yB7zQx+vFFgA+6OAllSOiloOstwq7CyCopWSs8nXEmEvLwEubAUNNqfHoGx6ReVXSvdSdIjM4pwyx+fiJ4OcuQolbyxCLg4vkME1VdJwFP8RaGsSQV4upALMRbvqUQGXt+Jn28+3ukIhkSzuHcVuGdRLB9gn57Evf7nKyEKj0+dn3pgYwgctJ4+YZG3407USHNG9OtzEn2maUPBCSQkSOVnZ/dB0aGTYwm9xeQSu4A8evpH3Xsgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/04/26 19:38, David Hildenbrand (Arm) wrote:
> On 3/27/26 08:15, Sayali Patil wrote:
>> Launch write_to_hugetlbfs as a separate process and move only its PID
>> into the target cgroup before waiting for completion. This avoids moving
>> the test shell itself, prevents unintended charging to the shell, and
>> ensures hugetlb and memcg accounting is attributed only to the intended
>> workload.
>>
>> Add a short delay before the hugetlb allocation to avoid a race where
>> memory may be charged before the task migration takes effect, which
>> can lead to incorrect accounting and intermittent test failures.
> 
> Isn't there still a chance for a race, for example, when running in a VM?
> 
Yes, there is still a small race window in the current approach.

I am looking into making this more reliable with a deterministic 
synchronization mechanism to avoid such timing dependencies.

I will send a v4 with this improvement.

Thanks,
Sayali

