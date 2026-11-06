Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0354606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 11:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Pu/0y5rW
Received: by kanga.kvack.org (Postfix)
	id C20426B05B0; Fri,  6 Nov 2026 06:21:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA9C56B05B1; Fri,  6 Nov 2026 06:21:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A49EF6B05B2; Fri,  6 Nov 2026 06:21:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FA876B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:21:31 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F11BDA0D2E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:21:30 +0000 (UTC)
X-FDA: 85404453540.01.16A80A0
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf27.hostedemail.com (Postfix) with ESMTP id AACB740006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:21:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Pu/0y5rW";
	spf=pass (imf27.hostedemail.com: domain of zaslonko@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=zaslonko@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793964088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XSkCRP/iCAmBq/Ps3sn+ycEaOS8RbaoK3GlU0yrOuoo=;
	b=ZrQavGLGm13Am4w/57ABdS+oaqFwZBCR8BgcHWoHqKRefMz/Hn1Um1dp2HMyLbWnZ08WJ6
	w6wiUj76rSsTxEjEhCziMwglGbOSSMGsgsFDfSaRHisXyT0o/dHXye/l2cKDOZiesEq4c3
	ixgddYTUWH4i7Voe60IrmpsVgzL+RIA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793964088;
	b=SbFqtGcou7ELGuTRHHUdaT6lpMEbgz5Y8FVD7n4T8kZeejtI4eZwjBd3BzwICHfTQOEzj0
	MpA6XqoglcFW9uwEeosEsgyLaH7xwcCf1joGY9wkLgNgRoUQ1wa+b8jfFTFzvvEXSk/CQi
	2yixzrhkBgC2b6HONjwYI97jCtuofoE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Pu/0y5rW";
	spf=pass (imf27.hostedemail.com: domain of zaslonko@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=zaslonko@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6AjbgX980374;
	Fri, 6 Nov 2026 11:21:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=XSkCRP
	/iCAmBq/Ps3sn+ycEaOS8RbaoK3GlU0yrOuoo=; b=Pu/0y5rWc2ZrdPZqiI2pP/
	Te1Gta1kngdRT+2amzGzZ3MydLtq4CkBKZ3uTRCtTMnXvT6bfDYrxyaANsvsyh/R
	33MRcI1343pdxyf0lDnJTeppbWzknzuWe6v+lZE85A8jlrqurH0KuEH0AzoqF4Kz
	O3bTMiT3XWDVeKsIjcefVIoUGfSMcyODzR86L8Eh0ByIm4KME+zQuOUwkBu0ViRV
	u9n6gZZVa+vhgJ6V8lIqJYVOcAQiM2XE//xsnf5N684CZqNamr6X8XLVKLo9+dbe
	t+GxoilQWHzPfmqJDHAHFO04CE9iRQkfkQbp29ay4xXoMwquAyO65vzF9cUiCnGQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hs3rbuufn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 06 Nov 2026 11:21:20 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6Ao7943260750;
	Fri, 6 Nov 2026 11:21:19 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hqv1v6tfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Nov 2026 11:21:19 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A6BLIss4981286
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Nov 2026 11:21:18 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EA5F5805D;
	Fri,  6 Nov 2026 11:21:18 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CA0D58058;
	Fri,  6 Nov 2026 11:21:14 +0000 (GMT)
Received: from [9.111.151.197] (unknown [9.111.151.197])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  6 Nov 2026 11:21:14 +0000 (GMT)
Message-ID: <0a3c64d1-2b8f-4e0b-87ca-5397d1aaa3ee@linux.ibm.com>
Date: Fri, 6 Nov 2026 12:21:12 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crash: keep crashkernel CMA pages reserved if activation
 fails
To: Usama Arif <usama.arif@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, baoquan.he@linux.dev,
        rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org,
        ruirui.yang@linux.dev, jbohac@suse.cz, david@kernel.org,
        hbathini@linux.ibm.com, leitao@debian.org, kexec@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, kas@kernel.org,
        hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
        kernel-team@meta.com
References: <20261104145600.3708886-1-usama.arif@linux.dev>
Content-Language: en-US
From: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org,
        Bradley Morgan <brads@mainlining.org>
In-Reply-To: <20261104145600.3708886-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zxaghCs0BOzGJLIG7jFmKscVIT5NRM5b
X-Proofpoint-GUID: zxaghCs0BOzGJLIG7jFmKscVIT5NRM5b
X-Authority-Analysis: v=2.4 cv=MqLHeGae c=1 sm=1 tr=0 ts=6aedb830 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=v7f7EczwOuDDiPIii9gA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDA0NCBTYWx0ZWRfX7zq9oNWaXh0U
 FC1wxkRX4UHerDFfCDSe/7AR824SCkh7FVX0m2cCeucIHT4Qq+DAREGwDLQSjfLCCK+nKG0/Z1I
 k4IO/PNS/iN+mDiWAQFfOU4tOWY5As4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDA0NCBTYWx0ZWRfX3tB4QAo85Yle
 twUqL/+8aN7LMEcEsB0CAs9RLVC9vrrZteEwPlo0j3uRnR1W7YoMALXTqFVp8Q8esXu727tdaNN
 DzdYK3osL5l2FKNQAldUR0T/tbOAmH1Ye7UE3wTJuE0EOaRNi70qgaUXGol9TOXkv2GzsZtVF8Y
 HzOla4OtHShSHyenU7fM371K9csCj8c/HHABc9VweEns5PXP7bX7EL4kWFCss4zMnR2/zKaKLCe
 teVC0uDbMbjV2EJNV5CkaHjB/+l0F1RJo7ul4xS36lSlXia5Ma/cCGqXFB6bNEwM41dH2yFJZgu
 CztOkLSkX+4K90IxdqV2zMzKwQLt6WM6P78Rn3Nh7gGTu/4e1UxH+zNtWduHbZJbrf1VG2i/nBd
 tbST2q9naYNAlGRwdh3794QaOWbdN9MwRT+TrDPbHB+1Y0HEQNOYk3xyea7O1qObAt4ldoqYP+b
 IYwsVB69XIeNuxIWUOw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_03,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 priorityscore=1501 adultscore=0 clxscore=1011
 malwarescore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060044
X-Rspamd-Server: rspam06
X-Stat-Signature: 9ib7axrykjhyzu7boeqkngme7xpu9mc9
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AACB740006
X-Rspam-User: 
X-HE-Tag: 1793964088-517228
X-HE-Meta: U2FsdGVkX185PYjnB+hVb+9WORTvYcB9iAcL5+hLvTfXupPO92nPbKVvBw2rxX1yHBRBqp9J2MzbbaROhQcY7mWCgY2wlYwOcgte9pU6cIrGsdGW57DFkuwA/OG2nHKOhuAbcKYb2VGTZX4ya+/hIrFZEbqzj13iVwzAwM9hqB64kKtbx4TQNy+Gj0an3EYvlzRY3YVYx8wYMN6Sony65lWAxCktuRq3znYFoY9YRBVe8W7vBu3MY89d73IFTrM4wUXVBo0jD+lAvaNRUcszfG9i/9nU85TOmgXmsVz4ximMl9JUr1C0CYq8cDusu6tKRQQH93gkT8kyVME6A++d8jj+bue/W9cSAKhkOwp7psqngKqSaP64Vh4HdOwPZQt0qr/E2zsUtlaznYevxO7UZ9UyRl86kM26vfGpnm/OJsv+WGiP/XdjtquTLJh4mK8Dh/xu+5kWBYgKJVxO8z/CtFOiqOHHdhGsUsMTNiQ66302fa64KukGtg0ejm1zH4yTkvVCqXcVdLJvRO918sghp3fWqHvIfZMloAQZTBy2ilSzmJzUF/L5LCZ51z1Zkl+OJDSmXDG/dlirPdbMD+Lu1bsNZQy2zZDYP6fPDozk58DM6q8O4++HtEXkuWVx4X4/SdzqKVbJ3//az5lsvYmzBC3mvS36YOq24lFow9sHzdGh4yVQfHJFfTvxuiwFUpZoyHkOBzXy4Z9s1y7W+F1Kbci873PAM6J2026A+VC1oVVg0VFAvqhvRp59hjlk6/CTZcnPe+uwJhNhbHJ64qE7EynMJ7wDrkeD6xdBO7QGZxIlT0d4FgH1Hi/PTz6jC5W1Av75Vwdvq01D5tv7hlJb11s5WWrRYBPtrkODq4jMkvlmTk0sdFyQUPAOvMhMP7a5Coak2ispW1FPpGmgX6aS2QZlN+i0/l0ilA+bK9RwH2XnZP9Xp1bo/cUcjHVr9xTcWDRvQzNmIU0X9FIJl5F
 uw5hVHuh
 ReqnApg7ZPryZDxaxFxvGxklcTVqrDH5GOl/rcBlFYga6JOptREtRYpDP4nHgFMuiQWb262BC10ktKwhscuChMgMu7zwZFbN3V1SnV8WYwsrCFiLc6df+BKcE53r4OcBucxU+6rYAzYCJE7s24NHF7CC6jvU7xcoqiEQnctpczJ377Z9fg7xBRdTZ72iDfjV9KLpMEwE6kChAV+Z4rBmmZp6hFFa6Ainj1KElJPoLM+BigQ4kkhSq1SY39GrZC57X3Kq3TOYrZq6zHCtmRADEUcHYBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 04-Nov-26 15:56, Usama Arif wrote:
> reserve_crashkernel_cma() adds each crashkernel CMA area to
> crashk_cma_ranges[] as soon as it is declared. If the area later fails
> activation, e.g. because movablecore= put the ZONE_MOVABLE boundary
> inside it, cma_activate_area() releases the pages to the buddy allocator
> as ordinary memory. The range is still handed to the crash kernel and
> excluded from the vmcore, so kernel data that lands there is overwritten
> by the crash kernel and missing from the dump.
> 
> Mark the areas with cma_reserve_pages_on_error(), so that a failed
> activation leaves the pages reserved: lost to the first kernel, but safe
> for the crash kernel to use.
> 
> Fixes: ab475510e042 ("kdump: implement reserve_crashkernel_cma")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
s390 hits this without movablecore= (adding the s390 maintainers and
linux-s390) since ZONE_DMA ends at 2G here.
CMA tries to reserve areas above 4G first, but falls back to lower
memory when it doesn't fit, so a cma area can end up across the 2G boundary.
I ran into this while adding crashkernel=,cma support for s390, which I
will post soon, and came up with the same fix.

About dropping the range instead, as you offered for v2: I'd keep this
version. With the range dropped, the kdump kernel gets less memory than
configured, and that only shows at crash time. With this patch, the
the first kernel 'loses' the memory as with a regular crashkernel= reservation
of the same size.

There is a second problem in the same loop: all areas are named
"crashkernel", which breaks the CMA sysfs and debugfs entries when
there are several. I've sent a separate fix for that:

https://lore.kernel.org/r/20261106104309.3669583-1-zaslonko@linux.ibm.com

Reviewed-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Tested-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>

