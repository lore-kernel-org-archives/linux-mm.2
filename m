Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15749CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 18:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 652746B000C; Wed, 27 Aug 2025 14:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629906B0012; Wed, 27 Aug 2025 14:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5401C6B0022; Wed, 27 Aug 2025 14:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 42B2F6B000C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:09:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF2861A07B8
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:09:24 +0000 (UTC)
X-FDA: 83823324648.02.03AE065
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5A31A10000F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:09:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ruGTJgx7;
	spf=pass (imf05.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756318162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Henezf0j+nTZDVoAa0az5i1UqTqYlYmxIli7NXVRxFA=;
	b=KevIUvqCjshNdWABqAdBVFi4csa9BE6+9qfaUb+hHBXPO8L2JeVn3k0Z4khe7gt16Nz9EK
	C3AV2reQp9NbiWbNv0ZlmFlqSKOr4LanOZzWPBVpVeHDzcAZ9IJDhURxoo7DGh3iJ7+kHZ
	8ziMGP5wmsHeMwFt7Alqg9Cx84ndIp4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ruGTJgx7;
	spf=pass (imf05.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756318162; a=rsa-sha256;
	cv=none;
	b=URf8Hs5dkPD8BFYRDo/e5dK89CXj5wJbdI0F+nIAxJ2H1EIFOUp7vMiEoNAXgiRbOeN7Ki
	7ThuyYt/OWhXKZl9bHBp7WyCXy58Xhjon/fDqDfrqvvnfIRavG/E5qr6QLlfOAWcnwATNS
	0N28H+l5Tgflwc6Asw7rkjkk6rtcpRw=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57RBVVGj001647;
	Wed, 27 Aug 2025 18:09:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Henezf
	0j+nTZDVoAa0az5i1UqTqYlYmxIli7NXVRxFA=; b=ruGTJgx7WGavQoeJYMlNor
	XMzhWKSZblz1JTDwZMzRjTwsDT8AobIt38400xI5YMn2eaxjOFhE7Ll/0DTsJl65
	L3o4V0qjvzhdNHDScwz/ZyZMMxUwipV7mm1CN3Ju+fER6qkHtG/eqfccWUh4jQeo
	vxWuVeBBaAd/kLIqeNKZOYu/7xl43Lv4iCYCZzLy0oMmjP95UjMiUXdun+tq7hNs
	gCit0cV+ZCZVDlzWAkK+AljMNZrGnUG3vvwI6k/zb7YcH9ic+RMFpECmxfR7Rqmr
	JxCHyqDlirH19vV6G//9KLKTcEHB37pon9YR6wliIf3kDM5qNo5xdEX0Cx+bv/QQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q5585p0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Aug 2025 18:09:20 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57RHuHtp008453;
	Wed, 27 Aug 2025 18:09:20 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q5585p0g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Aug 2025 18:09:20 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57RGUB41002473;
	Wed, 27 Aug 2025 18:09:19 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 48qt6mh1d6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Aug 2025 18:09:19 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57RI9IEw31130128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 18:09:18 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9277958055;
	Wed, 27 Aug 2025 18:09:18 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49F8758043;
	Wed, 27 Aug 2025 18:09:15 +0000 (GMT)
Received: from [9.124.214.234] (unknown [9.124.214.234])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 27 Aug 2025 18:09:14 +0000 (GMT)
Message-ID: <b451b318-133b-45f6-87b3-3dc3fa1f75a8@linux.ibm.com>
Date: Wed, 27 Aug 2025 23:39:13 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/ksm: Reset KSM counters in mm_struct during fork
To: David Hildenbrand <david@redhat.com>,
        Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Cc: aboorvad@linux.ibm.com, akpm@linux-foundation.org,
        chengming.zhou@linux.dev, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, richard.weiyang@gmail.com, ritesh.list@gmail.com,
        xu.xin16@zte.com.cn
References: <2e662107e01417bf9af23bc7f52863cd538419be.1756211338.git.donettom@linux.ibm.com>
 <512764a4-611c-42d4-8b4a-2aaca4e519a4@gmail.com>
 <53a7bf3d-843d-4e19-b0a3-cc6852fe72c1@redhat.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <53a7bf3d-843d-4e19-b0a3-cc6852fe72c1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mS-jT1OluJPLxq8noMhODUtObNItOHqs
X-Proofpoint-ORIG-GUID: W_QujhfOUYSUVaoozQfOXykh24azsJoS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyMSBTYWx0ZWRfX+NdWAw+hGmuK
 bVsLNdGQeZLHk3q4tmYipIsA/dlu0JGkf7ViJ3+k15NZckt954S2qyhu5FV6DI1hteHgrsUdG73
 BUINunicVcSn0LEKstYS0y8JuDsY+up/ZaxD4jtUVSJQbW6+DhVHvyst+6F1izjdYzs5qk60lpa
 xDlpQ6BZymTbXdJlfzAFDuK/Bb/7Yxpssfb1cG+6KBFh7G8jSVJ+ItrsLT/Q52VXWLyZc/zxkxV
 Eqq++paV8dIaMF/DIQ7f0jdpg+9Ju++YHuX2fHLzNpNX4zwdYISUlsfwAYJFF5iHY4BCEil7M3J
 MyYG7p6LVAWUfo6/Q31YJChJliIfgXamffu058dZVaKCdWs2OwfQAKvzmf5wKoJpaa+1UAaZyrT
 YuIXP/AX
X-Authority-Analysis: v=2.4 cv=A8ZsP7WG c=1 sm=1 tr=0 ts=68af49d1 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=nXaOtthc6F8xOgzlwIkA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_04,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508230021
X-Rspamd-Queue-Id: 5A31A10000F
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: a7cf7jqom8ksn4no583me1knza7sy61f
X-HE-Tag: 1756318162-191521
X-HE-Meta: U2FsdGVkX18CbSMr69PAHsR8bA/lE9jTPnLPyalzhUcci3RVn1Sv6cTUGbBNFZnTmS5/k8jmKv6XvCFy5WAG4AaFDNHV5yN2j3tssNfDa3Mzb0V3pBThUKnemC0Tsy+hJFjPC2TaRWB8D2OkBW260QiNQlyul2Ak+w34d5S+sjIJlUriHRRsMDALEy5Tbmu91Dc0rAE/wJQ2QaiOG0FE6/5aXHokcqBaFjHEVyddhzuyqberMuhDSf+YKPHe7x7Jw0q6zHQ96dGaHLtGxxNEPatdIsceQFnfWVtOQ5CRrl9nANypyWnpc0SlDW7uWf+6GHPYm2mV1LamkzELUu9Jmmeec6IYaDKenuHQ8FHtTdnP4mRINgxCOKWe+wIV63S9pNYcEjYg14iQDJ4SkaeWmKzcoW2UvP+o4OlHZc5BjgN9OkGoQVja2JimP7YT1bC6UdMGgd7bXAQmH3B2179h/oSjuHtC0+/DeQ3GvSEWNRam+Xl4dr7cxwN8iXcp3Y+0/LpqvRNVIsxgiGSUMw58agDTNXHWSPZUNotIXg0M9xSF4Qfu4znuaJ4Qk07t7wm6WHJM/5KWLDSFgMAJ/NwnUI6lSWfe9iTS2I7r8Tj8Bc3zIX/HfIUS+1nGXbv0vgeugU3v0QaGZRmsL558kWMoZnLT6jomarbHqU2JZ5ffMjtRDWJ1UsBWI3sd4iD2x4BHd/KyLxuJvwMD5zpc0mrQQblw/HYnaWX4cPbB3XnYFjV1DAffk0zfhn7dyzFpXcRfxAtSrY1Mvy4zK/GFkkVSxCw+zW3HF/deTTwFPw1yLgCB5LaFOq4zJ9RE0JISWKaZ81nO9Xr8B5sNa5THOleMTu70v4qnp0+3AhBjM+QDSEnVzkLoV4jinaU/AAGrp+/iO7SOP1klLcreZse4k3pKeOmM+IhC61S24izgAm0cjhmRSCLcWrhLA/00wcC1CGeb9vMrsiYSb3iQzgSnwnX
 fBdYgu9W
 q8rqGCAINufYhpJbyhZDdXY14vqqF/1tStpdFx2o+7OyeGbEGzApOiIoPL3VKEG8lSTHyLxYus1BOMGMMNlqIpDo1L3r817u0hj0SNjQb5+2EiujAOSD19rl9yNWIcfPV6lw88Hl/lRMz20fnEfMXNKOZhJBVlCoc0pZn8oUjRJQoxSo3gKHzf2ZO5NfiBz6twzJZqUAu+TGBwxRoJS2pDsCYAisYrRWIVSZ9HjQ0rzdAwMKRifjA3YmT6kTA2fBdu63tOYlEGfRSUs5Cxy7dLJB4FyoHqFJCOeWJXtcuM0cl3wqowCM9KAd/np9lCxwD+ZZ2UOjuRhqkXkXyYdf+02sjl8TQAvx2DNPA2/eDbcxS3mhL5UcZigDP9kzBjkllXiKseh4ld0QZFGglHbcuUgaYcZt25ugXoVewUlPCn6CiyvZx+GORYcIA2RnKCZkJvw4r9EE64BCJLyJqew1Z8Uq3pN5lvCxLU0L/s1wbkOeXXwSyjvwc5rUo2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/26/25 7:39 PM, David Hildenbrand wrote:
> On 26.08.25 15:47, Giorgi Tchankvetadze wrote:
>> What if we only allocate KSM stats when a process actually uses KSM?
>>
>> struct ksm_mm_stats {
>>     atomic_long_t merging_pages;
>>     atomic_long_t rmap_items;
>>     atomic_long_t zero_pages;
>> };
>> struct ksm_mm_stats *mm->ksm_stats; // NULL until first enter
>>
>> static inline struct ksm_mm_stats *mm_get_ksm_stats(struct mm_struct 
>> *mm)
>> {
>>     if (likely(mm->ksm_stats))
>>         return mm->ksm_stats;
>>     return ksm_alloc_stats_if_needed(mm); // Slow path
>> }
>
> The fork'ed child uses KSM. It just doesn't have any stable rmap entries.
>
> We have to copy the zero_pages counter such that 
> ksm_might_unmap_zero_page() will do the right thing.
>
> But you're comment made me realize that there is likely another bug:
>
> When copying zero_pages during fork(), we have to increment 
> &ksm_zero_pages as well. Otherwise we will get an underflow later.


Yes, David, you are right. I added a test to check this scenario, and I 
am seeing ksm_zero_pages go negative.

# cat /sys/kernel/mm/ksm/ksm_zero_pages
-128
#


>
> @Donet, can you look into that as well?


Sure, I will add a fix for this issue in the next version.



