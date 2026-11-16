Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADCCE606A331
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=SAFQEOY9
Received: by kanga.kvack.org (Postfix)
	id D76026B00EF; Mon, 16 Nov 2026 10:26:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4DC36B05B1; Mon, 16 Nov 2026 10:26:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C63966B05B2; Mon, 16 Nov 2026 10:26:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2776B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:26:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3591516014F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:26:41 +0000 (UTC)
X-FDA: 85441359402.22.71EE942
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf29.hostedemail.com (Postfix) with ESMTP id DADB312000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:26:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SAFQEOY9;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf29.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794842799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dwK8TI6qy1OW1ri/FZaygFVxUbF5MpF9Rcdk0ygAxg=;
	b=voaGGS8FvegH423oZA98Z3Mgv84M3sFCwcP0J/AICJQ4TneJQbRS+RzeAcigBaYIk17Lv8
	l9JHfkoFgMMiJVKi5I1UrIdTsIE3fOCaww+s6b0bp2wCm6GI0xNRX/w5R6XZ4WMaoE7ESj
	/hHbLBHXwmMYQ35vTmHUopgbkDzTSSo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SAFQEOY9;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf29.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794842799;
	b=23EdcqAN+PoGtEioIzsXY8MByqDh1YOKCK9uaPMDfJExa9e9lenp+FXoW+1Zqd9Uvm9OUd
	oQ5pfokM2hehigOlp65X+99ho/wLOwJPscT8gM9JltUSYxIGTlJRl/+eEHK57aSY631ERt
	S+Sb2hCT211r6N/G5pgbkRXjz0ixQdI=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGDuOv43631009;
	Mon, 16 Nov 2026 15:26:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=0dwK8TI6qy1OW1ri/FZaygFVxUbF5M
	pF9Rcdk0ygAxg=; b=SAFQEOY9K0TF6/76lgxBx3bHlrTcJ+GsIIM0PkVfkre54L
	WUrNawywEsYtALjdlz7ofXdB9p0Pp3egTKhANOUbktufoRvmRT/MzARpdiSMVZlw
	su0KVzmyx13KSmJLK/PiK3rpnVPhnEsn//9nY0gy36aoLcjLTyjFMQDbAOXVHf8j
	nyNJ/1UQMv6LuzpTiAwhdbz4U+Jd/XdoA+qUAftLY9KteWw/Q5TnnzqUtvCym1ok
	9JQbp2iasqQ/R24Kyd13VMvyjg2OER06mYerSObfIn1wg1XvQEnQj1F2xX+I2NRY
	FMNNBsgYpHZd0WqQvY0BmE/YfaMtr6q2LA0mRymA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hxf566bxy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 15:26:36 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGFGaHc1877646;
	Mon, 16 Nov 2026 15:26:35 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hy46fyvcd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 15:26:35 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AGFQAP552429172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Nov 2026 15:26:10 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 643D920043;
	Mon, 16 Nov 2026 15:26:10 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 06C4C20040;
	Mon, 16 Nov 2026 15:26:10 +0000 (GMT)
Received: from osiris (unknown [9.111.42.169])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 16 Nov 2026 15:26:09 +0000 (GMT)
Date: Mon, 16 Nov 2026 16:26:08 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 12/14] s390/sclp_ftp: Replace get_zeroed_page() with
 kzalloc()
Message-ID: <20261116152608.165348B07-hca@linux.ibm.com>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
 <20261108-s390-sclp-ready-v1-12-3e7c90eb6676@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261108-s390-sclp-ready-v1-12-3e7c90eb6676@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA2MSBTYWx0ZWRfX28vpUqlOw2r1
 RkcZ7aGlRqN8/B2JmCvFltseg1TH2tw3HR7sWeoijQCc+GAC1EH075/kKK/AZCrVTwprGD1F9PM
 tgpccJdR/tIoS3K8ae2yMI76NUfS1a4=
X-Proofpoint-GUID: BLvltcQCLTMTj6A-iBioRX8bDKVj9MqI
X-Authority-Analysis: v=2.4 cv=ROImjIi+ c=1 sm=1 tr=0 ts=6afb20ac cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=cbU3o08U4KG32iXkhCkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: BLvltcQCLTMTj6A-iBioRX8bDKVj9MqI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA2MSBTYWx0ZWRfX9sgdr1ebrgLe
 Ln76Ip40/j/6weeD6F/mfUlMpvPsE2RYi5YfpZy9gnRqQ0VFKd+HW2KAnF52RPLdkXa5qFnEKBn
 JhSiNotNAqHadAroyAGROu3gbFRVml+ffds4biAjAC2jBMGjLBRhAOeBHL0lyhnp884756IDaQC
 dUdjWb5SDOR7sjcSq6cE06ntJC2spQbZhSPY2uC2H4P7md+85wPr8NcnjkGffWYzqn09pm2LwnK
 w9zAo/+HdZ2HRZdi5y0T7RFnEqOB3ZaNbNN8oqnG3tE7NZyF2Enf8I9IPYlA4/hnPNnbXN/m42V
 pNzl88LPOd2ewtLsSIJyPhw5cYy1TUcz4wT23b3tUm0CVl34xJhhxFDVQTwWxdktM5Ac/AkYTdi
 9el8mwNmj1s/KZoWPfREvYnDmUEMQy9DF7y8tACCk5ZTWbkkTiE3pFHySe0pjffAbo/MYpsUKS8
 QjCeTO7vq4r4INxG/Mw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_04,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160061
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DADB312000B
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 11nnmhsgiaummkc8n6a3te5zbopkytyq
X-Rspam-User: 
X-HE-Tag: 1794842798-457416
X-HE-Meta: U2FsdGVkX19j+gSClQS1nd/PH5sLW6w3qojKu0gKwYTUu8Cm42Q8wgPxIjJ7UW11hHxg8gw4z4cPjZ9YAy0yurfNU8Q6hvroq5SoCYmg3bXmP8luDnrUZqvlAGRk9bnJIwbT8NL+eSzSv3fiKr+kYV8Nv3GAXICnZbl5NWHJji7QX797PhOAb6uHrMhwL2ABRu6UM3BC216j6oPtxWU4qn3Bhg+5u7RIHqKdxyZSRcpo4O+fmTITeOQumt4oa0JAecIb8AojW4eh7nW2z7+FHxBlzuudILFVx+4Iz8LAUD5O8udypRd3wXs6ffTcXdA/JuZDNNhQSOR3o54Bd0o7/g7BERerQrmO5zUu1rEQpl2u98RUzp2JnLmgMwn62MmvzCR7+aTUSwN7toAsLFCNvaxDqprIFLwIlwoUVJBYaMBcfEsKAr+5RLcecS240NV1Q2B0rK9ELhF7J+ykzrrctZg3Wgk4UgD19NfcJlNMJOnRLRZHSH6oTa4Uv9u35BRCzQeD4WsACcB39jouuroyCGFFGmha5OLuC7KvHzQgWZ3HMYYWUiMIi6bxqCzl1tyy3SGJt9eC+BpbqkEdsvve2hIKYJ7qCZiZ0Y7Ll1GEx5puH61UZQFQa3gNWn9wNZTEDS+03IQA80mUuNy4qljuMhYi17Sl502jxUxxaMa4NvvBkEN8wuWWhzmdE4jPDTnDQjLuIdw6MK7BMaZgLi/n8GGBrFsKSP+R19a7tkj9Sk+mucinzczpzZxDxOEcxBbljB12N7nGsAhmkeOu8lYc/zmC66zR5yThfHyXUzxcF7XkEOmRDupDpUGofyBUJFNDfTGANkLdc1f+iTAiRq4jAoyihT6LUYbyREqxqEDFFygBO4BcNKLEoRYSaP57jNRtID540KBvW3KFuGqls4EFEqom0++3gc4AQ3jT5nrXbrFlBUYyaAoIsg7i+9EwZjgNdmlXYqqo+Cm3xKeJ5Vj
 IttVJcFX
 ZyhGdjM5us1y0sJuSOitFVh8XwaAT2TQGc2nWy+1f3exeX3CQIHRrnT060i9fNe1kRZSe+dMCeBnZNLSI7+Y3SK9WSlWsoBSVTmZpAsCxOukRDvFsm5ftnenp40HS/UTplbpLDOZTYSOzBzQEbNWcmCtohf/z+FrghmvdRFSxZ/FkN4bdTqHliyeGAVHamZ6dQDaNd+6IWyqd7u8NxreIvUkPx1I0xIWIavck3v0n2HFyO2Qa+RveSzLz0hjaQ/mFykjyI6RI26BwsJF/u6w461todirlOxAp2/q1abnGP8MhhkQcg65wwDnXl6TB7hdL8wgyuC73k8kCFKO8lsz0ti34nhxhereJMcRJQFKbmVEHQ5k2AH6N7kOZOO2lDWQT124RP3xCm0UPqSdAjNM3IfCBhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 10:58:43AM +0200, Mike Rapoport (Microsoft) wrote:
> sclp_ftp_et7() allocates the SCCB used for an HMC file transfer request
> and sclp_ftp_startup() allocates the SCCB used to read the SCLP info in
> the debug code.
> 
> These buffers can be allocated with kmalloc() as there's nothing special
> about them to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Performance difference between kmalloc() and __get_free_pages() is not
> measurable as both allocators take an object/page from a per-CPU list for
> fast path allocations.
> 
> For the slow path the performance is anyway determined by the amount of
> reclaim involved rather than by what allocator is used.
> 
> Replace use of get_zeroed_page() with kzalloc() and free_page() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  drivers/s390/char/sclp_ftp.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

...

> @@ -250,7 +250,7 @@ int sclp_ftp_startup(void)
>  		return rc;
>  
>  #ifdef DEBUG
> -	info = get_zeroed_page(GFP_KERNEL);
> +	info = (unsigned long)kzalloc(PAGE_SIZE, GFP_KERNEL);
>  
>  	if (info != 0) {
>  		struct sysinfo_2_2_2 *info222 = (struct sysinfo_2_2_2 *)info;
> @@ -262,7 +262,7 @@ int sclp_ftp_startup(void)
>  				 info222->lpar_number, info222->name);
>  		}
>  
> -		free_page(info);
> +		kfree((void *)info);

Sashiko is right here, the ugly cast can go away with a trivial code change.

