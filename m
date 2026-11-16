Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EB40606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 13:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=CyqEYnvE
Received: by kanga.kvack.org (Postfix)
	id 923F26B05B5; Mon, 16 Nov 2026 08:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D4E26B05B6; Mon, 16 Nov 2026 08:16:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C3C26B05B7; Mon, 16 Nov 2026 08:16:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 545766B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:16:20 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5F4DC08DD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:16:19 +0000 (UTC)
X-FDA: 85441030878.20.482DD1D
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id 30AD440009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:16:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CyqEYnvE;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf17.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794834976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irSzvd6rW8sUPYLpW1c1dglGknltWR9sWTeBGdFo7Zs=;
	b=r5jC9JdvfJ56++kbAYgTkYfO9c3NPu0WxPG82X6VBZMAZns3WTzl0r4Xh7OeT/ZwwNRi7l
	8Z+3Wi7Ome4dnxIcfsNEeXjjivqOqKGRopqFZLuRo3mOvLBW046ZdYcH7mqeqQ9o3xCkJY
	/73TvziLU5YRU/zeemMf1c0bSo+aVbc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794834976;
	b=TsthCIfKjNUh4o3+5Osm8Djg9GhYwnn0J1p5Rkqq8DGwq9nSCkTDqpLtXSS3tzJrmcNAwV
	3Si8PeO6lUx+CFQu2llIP73sU7uAaPEZFDFhAZcieYn16y/cdcVVZXBIAaV3yDq6u3GfML
	2mDkyu/nxNkrmRvagau0uJQiluyPLdw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CyqEYnvE;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf17.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGCQobW3269834;
	Mon, 16 Nov 2026 13:16:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=irSzvd6rW8sUPYLpW1c1dglGknltWR
	9sWTeBGdFo7Zs=; b=CyqEYnvEB12TBPq/yTRg+bKU5jNT0TfbnSC7aDHu010ShV
	wisMMh5CaheyS5e6R51Isv16+BOWKykY3tpjyYFZtar0NbACWxYtFYa8co6lj4Eg
	+sAEiaPphJCBY/OGllcb3lQ9ySmAn2lJfGWupM2TbRTM7Rw0Y3FyU7Hb2UO34DfR
	YUMr+7aAAg/w3gxLdFIv+ksqjbvVYYzZYUqx+VZ8QlpG6XRFPi45QygifBfk53/7
	8duwEcdPxUSGcdR5svEcuzOEdwNu0gh2yBL5YNVNTol0dDtWip4LR7uzYYXbb6+k
	juF0Mcoe4vwaE5s8dSEHXHpuzgCBworkqxlPPbLw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hxf9vdaty-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 13:16:06 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGC4s8K2972461;
	Mon, 16 Nov 2026 13:16:05 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j00ns8nen-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 13:16:05 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AGDFV1645678852
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Nov 2026 13:15:32 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD9952004D;
	Mon, 16 Nov 2026 13:15:31 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6AB5D20040;
	Mon, 16 Nov 2026 13:15:31 +0000 (GMT)
Received: from osiris (unknown [9.111.42.169])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 16 Nov 2026 13:15:31 +0000 (GMT)
Date: Mon, 16 Nov 2026 14:15:30 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/5] s390/uvdevice: Replace get_zeroed_page() with
 kzalloc()
Message-ID: <20261116131530.125125E49-hca@linux.ibm.com>
References: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
 <20261108-s390-char-ready-v1-4-3db507722530@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261108-s390-char-ready-v1-4-3db507722530@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i2D_tlpxr72T_N2LxoY17nVBjcw2IKaF
X-Authority-Analysis: v=2.4 cv=dtxOmFg4 c=1 sm=1 tr=0 ts=6afb0216 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=kt7I_EveaTZZBW9BUTwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA1MSBTYWx0ZWRfX3O4PszTN79kD
 V0RMgSAt7OwvlsmoopAqtG6ODelN84sy/1sjneuQ/8EwrwqaxEZe6PAPYAyyLE49CNx4XLJcIYr
 goehKRvFg65rQ3WNlGd6hBmhuTRT84gNgkXFqgjdMqF/E2gHZkpr7K6XHJuKZXzb6d/+YHBU6Lu
 EyveSUg4mQy35BQqJdEz1fWmpw/+aL9iw/bVcu0QSXbfgT+7uzq7RhWHZP7t+a/JFDrutFOs9aG
 Stvd+9yamdskQjl614XMcN98BOwrUrqqL6ZOmBpCTfWLlhlPBahu39sy6LyV3b0t8VlJQG91nbs
 2dQkoBpWK1CzSH4cTTKDAqbEmandMNirqqqzJ5qb2qq+J9pT/FQwCP8yoQyH5H0svvLYsBeGnZO
 gbLapLF5nwkPlATl021ol+eXZButHXopy78RFHWChM9uz+ydtCbDyDMZOo0ursduQhnGyYlu7gj
 RksWth9Xhpn+UcRp0KA==
X-Proofpoint-ORIG-GUID: i2D_tlpxr72T_N2LxoY17nVBjcw2IKaF
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA1MSBTYWx0ZWRfX+XgafhIJRVE+
 2QE73nd9PQoM3KUWBx/2ilhF4/JLt3Icgq2JPrwC9SfT/zz/lMJMOrUBL9S5zjY92K3M8QqICm2
 WHAQGA16oHKLrSDtPVbdnp4UYvzLS8I=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_04,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 spamscore=0 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611160051
X-Stat-Signature: wemuc6nu5jxxuqngenfn1hsnfbiig486
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 30AD440009
X-HE-Tag: 1794834976-946347
X-HE-Meta: U2FsdGVkX18YpGJCGEOd6jBXhbfRhL2JVQD2N3u6f4GxsYKQqEQOaHzJ1npLS0PuljaDDeDdI0/D5TCnvEGVQpPJUYD1yb21RErU9W1G6/9qvU2f1JrvRlhCR10pK/GE4WOM3JrRc2VMOe0zKZJ3zBMN4s9hnHvBa64omyhFw3+ZZmO/x0jcPm5qsr72gcospDgIgtVruJQWUfIA6/AULqYnlgZS9/xE5x7iQSDY/hQtjlNeVerLW8SVeVP05lZTi5IPpL/mxOzANzRBQvj5gexKpgEnw8F3BF72vLubblsjleEIlmIE56SG4NFqqyHndwJATyPBdci24QOyYrFAsz+9sxeynxSqL6Y+seBYWmTabxXCQ89tRaRo/vQHd9HuFiz21I5U7/lLitul+ZoIPNIHXdbQ/pRX23HbpT2QKUcTKEQHPvpxMTqQrbBH/B/vWvO4k1q59jlfjlil6+m3MtM0c+KmK7J1rThKP9kBYV6H1jvGxR914L6PsY0CClFAn8R7vUhqzMsNplasp+hagN0BdP00uERgL1CCUA5IXVx9gJBXNHjsCWWtWFbkNw8vSECbDrwP7+KxZ1f/NAGz716bn97HWoVw5QC4A2SUmfuDrUF03qRrwapyWWnqOvTnnZLgRUlO4sZ48ulhDCOBkWUhblEWEs66v5ZOkYE1gY3x8Ym0OfL38MUsGeAR4Lpaanqeiu3aSIl3eTu4ZVuMG8wgSvSF1eeGrt6DH84fj+sbQQ0VmZwZp6uCbjG3TDDOVEP6gTfRXJ1GgjVoG+H96scduSfXxXqpwriopvlKN2cHWtptsNrIKDUDxGUUvI2HCjJvRFUQ43RlSR91Wvffe7cdwMa4UuBfnKwbmovmU4YC13GwUYrkRViuFjjSGfybMRnd9PKjc6p+GxaSlISywytzh+tYJwTnkG3oQ06RIFEvRZx9eEzbPF0nzV3VDRGIuNj94OSyoTmGJSC8EED
 YDvs64L0
 5jwDqma3gzc9clwY7RsVvPv29MLB8xp1Ympkc3XYm4kESB74C9f/5ZoUYhZs0hbZMhFGzHA0TcSDMcNILRWaHtVEoBmIjnwjx0viPVDekIZsK8rV7s1thU7t3+Jp/R4j9fu4BBzLWfDsvWeV/a583MZy4vA3EpvfPcmik51836oH+FoWOP0kWniFnRu9TVK8wBKOfnsUdAGosfW3gRFqo+KILv3IsPE4keWsxI2wAyT/aVsI77ja03n2TbGUV+mD35+QNEzDSOQjuc+hK7JjuijxJeBQAy+pCZdoBpUkRFLRRiRkIOYjYixdNK9D4WlkWz5JUferHyG7tFJwhkRI/LjY7VvVa1JU8Z1mink286HF6Qqk5u1lHSXMvAJoTJp28V2MveyDlcCSHHzA0Mw2RhNDD1bDcjVxlbJ2BydHwb0KIuMvnqQnGvlLxsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 10:49:01AM +0200, Mike Rapoport (Microsoft) wrote:
> uvio_list_secrets() allocates the buffer that receives the list of
> secrets returned by the Ultravisor.
> 
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
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
>  drivers/s390/char/uvdevice.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>

