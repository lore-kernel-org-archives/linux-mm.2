Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5529C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4F56B00AE; Wed,  9 Sep 2026 12:06:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8C676B00AF; Wed,  9 Sep 2026 12:06:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4626B00B0; Wed,  9 Sep 2026 12:06:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96D066B00AE
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:06:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3510AA430D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:06:35 +0000 (UTC)
X-FDA: 85194701550.21.EE1FD65
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf18.hostedemail.com (Postfix) with ESMTP id A31ED1C0009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:06:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GATc8n39;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf18.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GATc8n39;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf18.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788969992;
	b=dvhAg6nKU3kctMhv+Li5fH3j2H3Zabdg7qWSYS2GfmcwfXltWUdJAuWjEXl4vykhkqyomO
	Rr3XCfRJLmRqx44UGYAcUdeb2zohMe2Zn6zUDTkkALTc9KtUJZxNN5gOUr3dJdnvjiitvp
	h9/WTgLPJC2/RwieIhkbiENlx4/8n38=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788969992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RWjlI4MbqEsZqtycIqtATsbjlYjEDTmZpbeEKOTud1s=;
	b=yVJHGkAxvZGxFIODYmk89GCtPJeA5G61vIK8NGpWxXS1vRCI7O2q25f+/1FpLSSo++66Z9
	d00I2tnoBPqxy8tpWI46decmzmVkGvFCF29Og0qS7Q2bGnh0Z2vx/RprZA2I6b7dut0El4
	NNIGmzGZw6Jmsc9E6bbKD43rQ4x03lA=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689B22Lf2666620;
	Wed, 9 Sep 2026 16:06:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=RWjlI4
	MbqEsZqtycIqtATsbjlYjEDTmZpbeEKOTud1s=; b=GATc8n39raqlzovpzocBJQ
	Qq/Zebd1E3g6mr0A6PZoBUVwGU1ckOw9ocDq7s47zosAcmDQQjUwGaBQe93DceFr
	SBI26gWxDRTHXZkCfWkS8QjNqyIIq5eeGzAa78VWtndciymtqziBwdSXv+VNpQ/s
	mPVuWj8esHtAQ5Lp9ZyHuchZGXDO+NWvZFWYG6BlCxUKWhsq9Ef9mbcjF1IfNwUq
	T4MrIgRUFR0gvKKUQ99mzszOmR+Cbj4koHMQHt8+M85QIarGhq53LD1SmlOOtsdj
	28LrODlEYGuEtIpX9+XqJCswR3dYvtbXfuoybqfc1LkcufFqIk32bUhqJmvjTNQg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbjrxkqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:06:26 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 689FuEUP001920;
	Wed, 9 Sep 2026 16:06:25 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ggwswba5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:06:25 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 689G6MRq30933304
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Sep 2026 16:06:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D8702004F;
	Wed,  9 Sep 2026 16:06:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 21AA72004B;
	Wed,  9 Sep 2026 16:06:13 +0000 (GMT)
Received: from [9.61.255.18] (unknown [9.61.255.18])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  9 Sep 2026 16:06:12 +0000 (GMT)
Message-ID: <fbe69571-3750-46b2-9db8-eb7b2e287ca8@linux.ibm.com>
Date: Wed, 9 Sep 2026 21:36:09 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/22] selftests/coredump: put a hole in the middle of
 a sparse mapping
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>,
        Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Omar Sandoval <osandov@osandov.com>, Jacob Lalonde <jalalonde@fb.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
 <20260820-work-coredump-sparse-v2-20-ba32dd718c51@kernel.org>
Content-Language: en-US
From: R Nageswara Sastry <rnsastry@linux.ibm.com>
In-Reply-To: <20260820-work-coredump-sparse-v2-20-ba32dd718c51@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=E7T9Y6dl c=1 sm=1 tr=0 ts=6aa18402 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=yvCvHZBkMPEFi-hM:21 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=4b849oTNI3KMiQfRc2UA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfXwMOKEAOnufqd
 SGF+DFNNDavrSKHi0O55IeVnCJpxKsk8JMbNAF5YjDffOGYM/iiFNdwXrgZVLI0UDW6amkSRT5j
 c9kaVzcekM8HfLv/ujde5QoSFy27w1A=
X-Proofpoint-ORIG-GUID: uESFL6ZdpJh2pism_iCO0yEFf0a3Syt_
X-Proofpoint-GUID: __IvkGFV-gsBehoP4a6j6PMjApE_YReo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfX/iNiFzIMlsZz
 vhZswCktN33AMgFoktb9LL5NRjECPckotB7sYlKRHixcGDrGmwbwJRTNqzWXvCfuKKH/1Vg2QCQ
 8hQD/dbozyCxmL0Q3700Jkgjt6UKvN+RR1lv+CUymuOSjwlQdJCfOnWoUrHZ2mqPaCGB8ZT5P79
 w4Q4xbl5UZ7AOJ0ymI476D+Z2RWtcMKXyg+whwzAt9CP8wkvgK0nZvLV6p6knx1+dOznQPOrA2x
 y2lcagUJTdgEg6BJV/rcanXJ8zdZzWKyovhqmlXjqR/783N9/sIQiUKd6DCYcdn3O3+86whqkAG
 mNsxGHAUxqiOVRREXXESX3xNuwV0LbP3emO3JHxwjAPr5Wcn3U9L8E/apkJTpPcy5jtMutmT9Jn
 7z6XzIc52t8Six/81f6YKFmgnsv//JznOwzvNaAZzb4IGU/TCtDVl/xJ1SElyzqYimrd63JB+vy
 T1Ol686LKB8o4lg23IA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090178
X-Rspam-User: 
X-Rspamd-Queue-Id: A31ED1C0009
X-Stat-Signature: zhtum167xe8twx5y8uqbxztr3y765ew1
X-Rspamd-Server: rspam01
X-HE-Tag: 1788969992-245967
X-HE-Meta: U2FsdGVkX1+J4bxxxm8+Kj6dy3vnF7PSPYK5Dnn4naEKgTgxx8sBeR+B67Vrf2pdoKkr7lkxRf1QCRdNQuMWqSk9NTiY1Y+vlNgYH1gLayaW88pBCbcoEtFQ3dr+AfO+pdjjAbSS3+LYvdMwf5C2xVUoQmKayMjqT0drfug2rO9IQn303C4MdTv5o3V3GOfOKqY0tobigRiuKq4F3jIU7zxMdHYDKFqDwj1JcL80V5A04lZXNtXXG6/euL+rQgabcZCQx6vVS7Tanbv/xYgsug7AGYxtDtL3kOo2qggaZw9YuUqs1PHxWv1MX4BtTePOxmXrmPRxN4jOU/sZgzFudRcYo6v1pxf/WZAmh359UDvwKcc/gAExkDjpfx5PY3p5P9/lU2osDPa20nQSjjAJTTwYqyceu3ynufcLs6u7N9uJcI/eCpKW9a45KKbDWi5kg7AmhLEzuRnJ0Eq4g4MA98EmX/8u0NyyDBPdGos0bwbZRhmM0N+9/D8m1Vlir7Ow/eUfIycSZPzT+qJLKTiaH3yLLVRGIlBWn22Z53qS9J26wdns6MR9W5X3s59FZGqa821cPqxpt2Xbtp6GBZycoMaFEeW+LwaChxGZ3bVUrxgb9AEMmZg/U7qI+zpltALe0jmpFs0gb7efpRuXKV5H3dzrFDLttkf0Q/kaBDuWwGbD1npKZn/Mi4fMZcYxjlI6yIGjFZjEokI55Q6MwmdezqbzpGqHNBfWi6Mtg9GPX+WvOAKv/OJn+Cb3lvZV01185ExVC2d33m5vCdmfl4dcbws7lZWDI9GkNhATFQTMgFdluBHof11nx9x5C+8SF+HZ7S0jxiifJMpabyZPjLT+LihU0Huks4I5fa+aDUMaejL4DVzPyh4tyI8Gfbc1LM1KQSQMleVeYcRzbUeV+PsgCzbTJVHvuL/w1kojDhEtL346N6YfEmUsjk3OS99EcoGSWXkkQUZT7hwKxtGS7na
 OmhbdYZh
 kHo1VekY4kbE3O+bKqtrAebF4fEi39dA0QMD3AavwGjznlUA4A3AKCZn+2XFEjQpfgXHEBEEuKY7ENulba+MGRpfICtfzqLJwtWqiQjsNDQEsjzbHsTwvpba2jwNVgjgBoLKtqBGwnb3GqoVEU0vrAs5PzqTBOW2mgjzlbwB+LYTSlfGxAsUJ5ucFonORvWYSfK21l6vcugMH2iO8uz5icoFYsgpneff3X/KlOQPgg8iJhUAxbs0Xd5K9iNMsrka6wFNclbRv9qOW1Q9lBZjNUgI6FwrW/URBvzHGOxy+5RfMWogkR5tO7bwqww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20.08.2026 4:39 AM, Christian Brauner wrote:
> The crashing_child_sparse() helper touches the first page of the
> mapping. That forces everything behind it to be a trailing hole. This is
> easy to handle. Make the test more difficult meaningful by also touchin
> the last page. This causes the hole to sit between two populated pages.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>

System: ppc64le LPAR (IBM POWER), Linux 7.3-rc2
> ---
>   tools/testing/selftests/coredump/coredump_test_helpers.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
> index 45d76fa0f469..89f3954c5607 100644
> --- a/tools/testing/selftests/coredump/coredump_test_helpers.c
> +++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
> @@ -58,14 +58,16 @@ void crashing_child_sparse(size_t size)
>   	char *p;
>   
>   	/*
> -	 * Touch the first page only. The whole mapping is dumped because
> -	 * it has been written to, but all of it save that one page is a
> -	 * hole.
> +	 * Touch the first and the last page. This will cause the whole mapping
> +	 * to be dumped because it has been written to. Everything between
> +	 * those two pages is a hole though.
>   	 */
>   	p = mmap(NULL, size, PROT_READ | PROT_WRITE,
>   		 MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
> -	if (p != MAP_FAILED)
> +	if (p != MAP_FAILED) {
>   		p[0] = 'x';
> +		p[size - 1] = 'x';
> +	}
>   
>   	/* crash on purpose */
>   	*(volatile int *)NULL = 0;
>
-- 
Thanks and Regards
R.Nageswara Sastry


