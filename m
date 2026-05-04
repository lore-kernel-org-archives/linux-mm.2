Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C9B3CD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 18:41:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F261B6B0088; Mon,  4 May 2026 14:41:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED5FC6B008A; Mon,  4 May 2026 14:41:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC45D6B008C; Mon,  4 May 2026 14:41:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CD5F26B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 14:41:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75E3A12026E
	for <linux-mm@kvack.org>; Mon,  4 May 2026 18:41:56 +0000 (UTC)
X-FDA: 84730606632.19.DDF760A
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf13.hostedemail.com (Postfix) with ESMTP id 007802000F
	for <linux-mm@kvack.org>; Mon,  4 May 2026 18:41:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Isi/X9Dm";
	spf=pass (imf13.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777920114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yvHcsNFjpKdX5ErIocbgAVaHl/9juTjsjhDQtOgugvw=;
	b=caQI8WoWaLJtwJgAcTJYBMBeP+tlr5uqenlx3RZhXytWE3xOPcZwZ6KnnYVhoP6Mrnl6sS
	Ff036Ie4g/H7UL1RpK0KIHx0RX+Vk9Xdm086geofSkQm+w50cGIgFIXCTERq/zVyUvLT6E
	dAn3pPOi6OOZjfOyTBAnlAAYKgL6Gek=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777920114; a=rsa-sha256;
	cv=none;
	b=1dfmzxQrwZO/NwhpD2H6A+azYbC/oYtO27b4VWQomqDKBBj08RW15JUhBiIDO9abDgRMvP
	N1tAMGBpjbbyZTFVmSh/UeqmjJ5qeI6rlvnvhP4mWuAyAVddQFaTIi/AvG/CLF5KZ1gpAC
	Ik7y7+Ody43RS2roGLsuOyv14RfLbtU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Isi/X9Dm";
	spf=pass (imf13.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 644Ee7K53279333;
	Mon, 4 May 2026 18:41:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=yvHcsN
	FjpKdX5ErIocbgAVaHl/9juTjsjhDQtOgugvw=; b=Isi/X9DmTiz++beZ2hHnz0
	lnO7FKsu3Q3rdfK+tbMMMBKCWqzQL+RwsLDBek71bzhUiNku1uQkwEosES1aJ7OO
	VcNDGIjP/DT+fHX/WbbgHTk30PkSxkttmSXPHI5Qvproqy/eLoqfHswSIlVsCn9t
	NxSBuoyMqqCDIYoKDaaVPk4f8iwD5ERXbuyZ+TbwLE1lVr6yDec/b8FeSQxWW+P/
	7M6N6TBOSLmchINLDM7BTALXSkhPKQTRNL8LDiarkapodkv7Gk/QjvZGrGQxCZIt
	F6xY+OJ+aQk5aVhaSn9ZUEN5pSv2YoEmabDmAvBWf3FMtZsaL+pPv+huaATaYP8w
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9xxg6an-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 18:41:32 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 644IdYZq029391;
	Mon, 4 May 2026 18:41:31 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwukq6hvj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 18:41:31 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 644IfUxu31523576
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 18:41:30 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 653DD58052;
	Mon,  4 May 2026 18:41:30 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 421F858045;
	Mon,  4 May 2026 18:41:11 +0000 (GMT)
Received: from [9.124.220.160] (unknown [9.124.220.160])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 18:41:10 +0000 (GMT)
Message-ID: <5a01bf62-772c-461d-a7ae-ce4758a3fc5b@linux.ibm.com>
Date: Tue, 5 May 2026 00:11:09 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/7] mm: pghot: Precision mode for pghot
To: Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net,
        mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
        raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
        sj@kernel.org, weixugc@google.com, willy@infradead.org,
        ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
        nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
        akpm@linux-foundation.org, david@kernel.org, byungchul@sk.com,
        kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
        balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com
References: <20260504060924.344313-1-bharata@amd.com>
 <20260504060924.344313-5-bharata@amd.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260504060924.344313-5-bharata@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDE3MCBTYWx0ZWRfX3eQGrXRcx67y
 Q+qDSY+an09rUR5bUgGyBsHUpGRRy9Ty3c4Fuekq4vlPqG9Jg3/rliCNYyDdjG276jSRSucXTR1
 lorAJy5aD1ychZhtQ/0TwzCQl8d5bizJ6zmGL+3buTi+iFF3bU8RWokeJJ+reSdx1bdpS8K/KNT
 VD8vP6cXKcfsacizEWnbBAgpLBRRwDng6VMleHIYlHj7f4iSHaFK3KrdQ8hK/aBQgIW+V57g5zt
 sKZOMwfVQ1bC8tpFdysMc+Zag1qwzwGKERa2JJORKUQTxtOH/1yJxHvHLyWq/oA/+8ZrzTbGFTi
 fnO6qW5fS3AnBl13+ZuFSatcNnwvk/wNuR6DSvoyIMmUOL26DHOfafAlqfYRD4d0nbz3xLwJuw7
 tS57rPouG27WFmBHX9NcbFwxtkd8aQe+ZW2g2DGoMHb9AKzTNpr2MRiO40sCsyrQ0IeHg4Ed46U
 akp2RreXGpZbNrlLeVg==
X-Proofpoint-ORIG-GUID: tnQ7oG-l8PShrukvXVgQiQl63R7FB0zx
X-Proofpoint-GUID: -h9KWz6Den0bubtBzScitqzim355Tuff
X-Authority-Analysis: v=2.4 cv=ctWrVV4i c=1 sm=1 tr=0 ts=69f8e85c cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=7u06FiZDblvXUniig18A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_05,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015
 suspectscore=0 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605040170
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 007802000F
X-Stat-Signature: nggsy764a3fqjx861ocaksbssmoe6no8
X-Rspam-User: 
X-HE-Tag: 1777920113-632907
X-HE-Meta: U2FsdGVkX1+xAs6YLnXdTumVp7WGevSsZqPq5uBii6dQBG793q6bjN8ichLZus/E7vuIOa+21BJYFLNaWp+no/iEk/AoeJI3siGdSgyvC1K0lhaVC+cf1LLazg95fmoi1P2irFBByoQ6UdeHAzra0+xKc/JladeNHtKJL25ilykkTRZAh1oSfDQV6moptZqhPvd+1oetpfoDhCrfcoMGSnVZtLY/d6yBvqGWXSM9RrqmEySrJMh5HiSXcQynNo4op9cDiiR2kPd+Ks9/IfQaHZbeFqcJJqW3kFj4HMX5JcG1l6ngleBHHR/gS3R+RmpTNuimiBSqBEHy1DxUKASYUCDJ7aV++K9xqOHx/6PUkQwxT/FzJTF5XaAlK4XRjnu7RT3LT6UzAl8Z97HOpnPk+8WYqwUtxlkM1jHGfVLmiHeAZKrPg0RHKIFhVxxNd01sGSAEgfOWTL0ml6zPXmwLe3jePsOFWU2Acjxz6f05RaQ6n2xrGivztRf/T8vU3am/BATFmr/vsjwZL1do0hNXbr/6WaY0aYehVqPvgjZMcpdNB5AW2xe1Tzc0V+oNZynnSFWWxCCLI3NzgS5WAMm84FZRAz1Sx6Ak8gFL9Ut3i0h1EMaRDk+Ado/bxuJhtniJmyv0BzDjPyeQy9xGyr/DLsMJYgKNjQB5qqm4ZhBhLCap/nQH5b6jfXyW6i3n7+0vpg1Z0WeOFzKDNEl69Gb0Wku3cyh7V6TiQ4wTKAsPFzbj9SlEuToIN+k3raQBqH4ouuATnPfm0fOss6WBQ/CE/H3I9pVoD24016+DWNJV2ATpMQgdGJBVlj5zSZ0iw7H1e9XgNBTyU1iYYl/swL9KVg1rj3uQDcSKEiq1nwnRlPS13xK7fVit4zkst7RKGjnAt8UXfMlpqqZdYvQHDLKkzQEk5dKzXsmMe6WOH+6XvFf7uScY8dDeWaXTdpQljOkMyFfnut6ZakExQAlx/9E
 r7gO7gJw
 sMdC0+6ZYkJcw40dPYK5Gm02fHQYLLHRB9pL1Qm6IRWn1VKWGU0Ux338n8Cz0nihaVE4D9POcZ6I1N55S7F+LYHVJyGpaoLjDsTpARmDrEP+6V7czsfjNgSUQT8LGkEaUl9L/gGqcNxKYJgZU1xcx2VNvjuaucTp6H0M5TEM4KWeBv3K8WgMdnnCaTtkLjJ1PyrgZoR2kN9ckWLcJPAtnn+BOkli+2Eg2nFTuZj0AzEugItUn5+5V5YvfeSQuO9rx13kDOh1gHwAEK+Mo9sgra2zoUTRkY9ipcyrrgCeXB/U8RMsnuUTqoaI+hCzBQ+kh4OXZ9v+E5HloCh6BHLeXhE7DsWYE6WH42ipb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bharata

On 5/4/26 11:39 AM, Bharata B Rao wrote:
> +#include <linux/pghot.h>
> +#include <linux/jiffies.h>
> +#include <linux/memory-tiers.h>
> +
> +bool pghot_nid_valid(int nid)

I might be missing something, but since pghot_nid_valid() exists in both 
pghot-default.c and pghot-precise.c, would it make sense to move it to a 
header file as a static inline function?

-Donet


> +{
> +	if (nid != NUMA_NO_NODE &&
> +	    (!numa_valid_node(nid) || nid > PGHOT_NID_MAX ||
> +	     !node_online(nid) || !node_is_toptier(nid)))
> +		return false;
> +
> +	return true;
> +}
> +
> +unsigned long pghot_access_latency(unsigned long old_time, unsigned long time)
> +{
> +	return jiffies_to_msecs((time - old_time) & PGHOT_TIME_MASK);
> +}
> +
> +bool pghot_update_record(phi_t *phi, int nid, unsigned long now)
> +{

