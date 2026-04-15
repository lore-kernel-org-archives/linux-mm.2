Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6266FFA0C2C
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 05:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73AE86B0092; Wed, 15 Apr 2026 01:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7128A6B0093; Wed, 15 Apr 2026 01:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62DA86B0095; Wed, 15 Apr 2026 01:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 516B16B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:34:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2C8D13A934
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:34:54 +0000 (UTC)
X-FDA: 84659676108.07.2D1BDFA
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5EC5616000C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:34:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VniIU8wA;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776231292; a=rsa-sha256;
	cv=none;
	b=uEAPvYczhNP9wDh0z8PLpRHG9rW+0/tKRv+wob2yT0FqFt1t4gVwJ6xugJ9a1ilpDJ/8GE
	5zEIugX6tS7A0mqYqRXO1OTLfhkwpOI+sGXHJy/WojeKxgol+8dTiRmULNSIfiV/mXlkui
	xkpGJuYpRh6WBZDcpHmURqV+32nNB6Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VniIU8wA;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776231292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Jn/bYnePmmBijhebJjawFdR7dw/NO7bhdl8r0/lNyQ=;
	b=7LgbpxB9b2vNUl2Fsk1s7H93oP5B89VKf5sjNtHTnrIgdCSkdiaGlCVJlFVdiAb/lWIssX
	z+866YOs9H9F4oaVzNvDFvX12z8YvjwtlPZjt2rw15rAYXr15xmJR4oVJAITJzBF62I0UR
	+l/Cw8bi9uheqcyaiQjHjW/wp5cRhGY=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63F5NYYt1835027;
	Wed, 15 Apr 2026 05:34:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5Jn/bY
	nePmmBijhebJjawFdR7dw/NO7bhdl8r0/lNyQ=; b=VniIU8wAQgXc4YVPyxfsw3
	YGAWphVS0Mkbp4ye2+wKggHLXrPlVixfv5iMMmzICjvfVp6M52DryayZeZxp/Llk
	u54G8Gc8pFMYsGJX6XQ51XEXtJLs8XWA4VR+INtemhMNFr9dv3VAknH4MRtcMl3T
	YBbpmY/PefAdqWG1piBw9d3YbmI9zYjnvbuU/9DMGbSMZct+tLhYou6MVk/1xLAR
	8btrV5cJTCwybgOzdsHAHG0BxzdEE95JUTr9jsaBf+lA+5QTCYx5XGFreCEfPG5n
	5itvyosHAprbk/sI8BrxpZt6AIMP83d1WzwvgaXse4vH2t8gYIuNaB0qrJYKpcSg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89reg0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 05:34:46 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63F2je6L031099;
	Wed, 15 Apr 2026 05:34:44 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dg10ycy88-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 05:34:44 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63F5YiTh62062968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 05:34:44 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C9E858065;
	Wed, 15 Apr 2026 05:34:44 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B2BD58055;
	Wed, 15 Apr 2026 05:34:36 +0000 (GMT)
Received: from [9.124.217.38] (unknown [9.124.217.38])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Apr 2026 05:34:35 +0000 (GMT)
Message-ID: <42a006b1-2b51-46ae-a5ed-829f3947fb20@linux.ibm.com>
Date: Wed, 15 Apr 2026 11:04:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/53] selftests/mm: hugetlb_madv_vs_map: use kselftest
 framework
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        "Liam R. Howlett"
 <Liam.Howlett@oracle.com>,
        Lance Yang <lance.yang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Mark Brown <broonie@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-mm@kvack.org
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-11-rppt@kernel.org>
 <c1ff61ca-89a2-4d13-b376-03cbe7719366@linux.ibm.com>
 <adzEg1JM-OO0yzqd@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <adzEg1JM-OO0yzqd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDA0NyBTYWx0ZWRfX5jAnyqzoweR2
 CGXDG7GeOEyhlibk9pkaSRTU6V3VMMhek8jQA9GtnZNk8w3PwE97lw91KTPXfaTYSDCv0mDI9Rs
 zD9/jpQDArrR7maoxfc4iCcQoH8iYTYPaUBlUq2HRy+lfRGOD/QVKpOTGJlsIKqTh6k65H23KxW
 TKYPVFVtmNuyaSWWWPL/DVgB0dOggfaRyLxfw5h2YyrpKw6Dd/ukjz6QVuS97aEv7AxBnlYdV8U
 sGP3lFXRVO6sGg3SClJPhr6ea+oo15amzqQmOt1K04ACZZeUnYoFskw/zxA7qBPGYISthpv39Ji
 rz4DJquojsevsvbGgBBrWEQIre8en6U71j1Kmasaqc8BoGv4aGoOZytkGOsEIHEUdEtihDlkxnb
 1V3kg/QbO6qmSafdOMinntMfZcOnP6l/4vU2G7C633MbGR6HvbvJLL0xKOl4hVi4sl2DAGebPYT
 VIVTPYzhMkAiGk2JMdw==
X-Proofpoint-ORIG-GUID: msp-FA4ZJIjvPQaSQBaqiFu-rrAPM7RF
X-Proofpoint-GUID: 4h4UzFtMaRJRpHNfGTmCSqmleT-WqJv1
X-Authority-Analysis: v=2.4 cv=fYidDUQF c=1 sm=1 tr=0 ts=69df2376 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=rQ_swS4sU4-nGWuC61sA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_04,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 phishscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604150047
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5EC5616000C
X-Stat-Signature: 7smc3wbisqqjqcryb85jzbth9dd9qk7z
X-Rspam-User: 
X-HE-Tag: 1776231292-932133
X-HE-Meta: U2FsdGVkX1+Tbl3v6j2YngB2gefn9XLpj2Mm95ocSCaLm1/tRtDpQI8PbzORJhFNz2MEr9V2sDoWAjYgVzYk6kerZT8L87dVTmkKrF+SAen40zjgo3uEp94j/dovTtpMEy1gHTIBBz4kOebdmVb3iWGrHJ9rvJl9ehaj22rZOVQnefe6Y4NTHtr7xEkjYE/YnX4rI1kos98unBStZUKQSZFPwb8hQC1bdgsWBVtGko5k38hjBoqKuPEwbxPLfwK6z19V6s6PW9c05b1bj1h3O2a/QNhG3S0t7tljwx47kUydKGuQnh3aHQFN7J7vYB1v8td797DuZ03G+aagMCardd62fafryUfNBw7JdD88Lb5AqQG9fy62iYB8LJuuuw1FB4CVW6mbMi7az0EGPbgrTUlVuGYV0B2/ArnPqPPCFJFhwbE00ULH4JnodNeinvst7HvyyGbkzMm5zLKp7qhqCUkbW6pZXohNwtWPzYuxc5YIPcTfy48R9vThNkW2CvM+5/fxnpfL9+c3oiuG8ISk1y+rAHkO1wwOrknlnphctc61zAT39uQwvwr0fwshsTXi4jdDK2bBAZSgsl90SRr17AnwEmCUOwLaEl36VY+mNFawL30iO+VFOR24FMbISlh7xGOqEB66VYbqqRoLdsKj5nOZfLZrbW6rHqzCZj08FYy5Mqn4tKXzYN84o2VWsvG0gctCDRLXoqMXfyopPFLq2asaue0xKWZ+3R0cW48il6mOcBnBNQA8AvV7u9HaxuD/y8AinIJX4zD8eUii4hoWBjk3mHZDu72G0Nfh0HpCo7Hq42/eYVkdYKtPXXzhQCPk3nf50mGWhjXV0U2SgIZH8KdSazoCkQbcLtOIUOpEFcgyNvTMkghfjDsUX3pSpJtvdkz+YmZ8VPdPQQyAsu3G7xDw6CQXmAjbfsncRi4fmASEhJetmzqEqtScfIy5dGR/FLj61ZE1gVP4EfuEqVn
 S08gAx4s
 I3wydbRjUrJ0GanRx5XAtQDJsLQ6zM8ukr6t/L/bfws358hAR8tKLKpMK7pRIaVbk40WRKyeySguxBTw53WTZ3ij0+0E3x36hzYXVcRUz0j/xaiP3TUTcwlt67IV4TyT4Yt2jtoqG7tjBAxfj+r/aO0HIhS0eGGuinoZ8r7Qe7OegxE2S/ibxqIml0utoM9ow1Qn/2ubUjJmc5BTOrMnVXxs1nw7+DuVg/EVW24VDgYXeJLO0FZmJ8MFQwDXSOaxvxYde6Igil4EtzMsj1dtQyByXHAuEYTJFXFHCzs5E+jg7pgBWOfVbniApqiXQz+XHtLTM+a6ym9FBapM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/13/26 3:55 PM, Mike Rapoport wrote:
> Hi,
>
> On Thu, Apr 09, 2026 at 10:44:28PM +0530, Donet Tom wrote:
>> Hi Mike
>>
>> On 4/6/26 7:46 PM, Mike Rapoport wrote:
>>
>>      From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>>
>>      Convert hugetlb_madv_vs_map test to use kselftest framework for
>>      reporting and tracking successful and failing runs.
>>
>>      Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>      ---
>>       .../testing/selftests/mm/hugetlb_madv_vs_map.c | 18 +++++++++---------
>>       1 file changed, 9 insertions(+), 9 deletions(-)
>>
>>      @@ -115,12 +114,13 @@ int main(void)
>>
>>                      if (ret) {
>>                              ksft_test_result_fail("Unexpected huge page allocation\n");
>>      -                       return KSFT_FAIL;
>>      +                       ksft_finished();
>>
>>
>> Should we call munmap() before exiting?
>   
> We could, not that it really matters.


Thank you for the clarification—it makes sense.

>   
>>                      }
>>
>>                      /* Unmap and restart */
>>                      munmap(huge_ptr, mmap_size);
>>              }
>>
>>      -       return KSFT_PASS;
>>      +       ksft_test_result_pass("No unexpected huge page allocations\n");
>>      +       ksft_finished();
>>       }
>>

