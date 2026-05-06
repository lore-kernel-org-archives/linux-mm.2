Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB3EDCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 12:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5C96B0005; Wed,  6 May 2026 08:10:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D867D6B0088; Wed,  6 May 2026 08:10:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9BF26B008A; Wed,  6 May 2026 08:10:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B82916B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:10:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7986D1401CD
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:10:17 +0000 (UTC)
X-FDA: 84736877274.18.AAC2FB8
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id D468910000D
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:10:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kgiI15yA;
	spf=pass (imf05.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778069415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZtwzGj/Cax+3P4OOw+bfUOBHyFVXjSFJ4a1rGiao3GA=;
	b=1EaSq4x/luQBcVUlO+jKZz+jwzrTJ6CMLbq/nHE9n+UlkvSH7q1mtjXQoDAfiepFHKqS4F
	LE+uSBiBC7V1kg57nYrGjyFkOvdYEMvBiD2Ekqb6tVwaAo8e7zCvxKqnBECib1KuFK+AbE
	vztv3WABtCs1mRAM/XG9W8ZlG6bIxlY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kgiI15yA;
	spf=pass (imf05.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778069415; a=rsa-sha256;
	cv=none;
	b=S/U1wNKICHSLqKEiK+tJ0S7c8Tb3mvs+6CjPCnpstUn3Trs+Bdf8hOINoK+BGj19KGk11/
	PXR0AW0DEGOOQIiHwfRkFI/d7PCPaRFWEB/TW/8+XUVK0yy5SKvV3/nrvplLio8pmK6QaD
	mPhl+qbsjDBk3MbKA2WQWg58cIBxzuM=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 645K6q8H2808530;
	Wed, 6 May 2026 12:10:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ZtwzGj
	/Cax+3P4OOw+bfUOBHyFVXjSFJ4a1rGiao3GA=; b=kgiI15yA44suZPvLptSlax
	kSGnWLjQcWrmE1mE0wp6Wh+xcTHItOj2CJM094z4sx1rrAdtuap/2D3jP61eDexE
	twQ/4OzS0eQFDc3a5rQC+6nZjYzaDj8zESMM0uJ1Dw+DoMlQPYx4kNlgpIvgih9P
	p4vs15lTPbnHbt9AHg4IuYUOWSGL2nl/JBJ5nmmPorGO68+9EOAcrlxha4Jv7CQx
	k1bwIw/ie1sEdTqyEGOqiUkIHCwdZgAyZ21Z1aeIIgYPQpuByviwqLeLskyfjMHW
	r1pBhEEgfEV+sPvATwNxdPuV0KZScgxDi/RB6W6vxoYGhe2hxGhlHTX8iQsYYMXQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y1ggw8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 May 2026 12:10:10 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 646C5QqM032540;
	Wed, 6 May 2026 12:10:09 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwvkjx3eb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 May 2026 12:10:09 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 646CA92B34144898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 6 May 2026 12:10:09 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0489C58055;
	Wed,  6 May 2026 12:10:09 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 208C65804B;
	Wed,  6 May 2026 12:10:03 +0000 (GMT)
Received: from [9.123.3.209] (unknown [9.123.3.209])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  6 May 2026 12:10:02 +0000 (GMT)
Message-ID: <5308bbfc-286b-45a9-b527-c282ce95a028@linux.ibm.com>
Date: Wed, 6 May 2026 17:40:01 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] selftests/cgroup: Fix hardcoded page size in
 test_percpu_basic
To: Li Wang <li.wang@linux.dev>, akpm@linux-foundation.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
        muchun.song@linux.dev, tj@kernel.org, mkoutny@suse.com,
        shuah@kernel.org
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Waiman Long <longman@redhat.com>, Christoph Lameter <cl@linux.com>,
        Shakeel Butt <shakeelb@google.com>, Vlastimil Babka <vbabka@suse.cz>
References: <20260501022058.18024-1-li.wang@linux.dev>
 <20260501022058.18024-2-li.wang@linux.dev>
Content-Language: en-IN
From: Sayali Patil <sayalip@linux.ibm.com>
In-Reply-To: <20260501022058.18024-2-li.wang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: JJimJ3U9Ee2f75fvJNMoQyEthf9nE0cr
X-Proofpoint-GUID: JpMACp870QKhw6LAYNdgB11JVvGe__yj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA2MDExOSBTYWx0ZWRfX+7mLPDG8OGPN
 pcmFBnQ03nwA0nYPv4Y505miok8pUv0+rKoRywZfZlh378cPqj/GlnvirMpBMOcopToCFZqAG7H
 5RsFbgG/AiFGejzMzhpNF1svhVvCRHIt0SVYuIGb2aHGMCGyaZIXt27TttnrbQD7ZG+1g90RpPm
 iRqK7HP8lTsn/Z4W+dpwTN1cBgDmPcpwYu9w919k98QWSDFrJicZHyVnAn/huEZ4S+GubK8cVjm
 HP8TK0yi8EdMXQ2HF3TP6XxjfZpEyD9YSOqMz5JkS57lPp9aS3OSM88cIKimAiZt2GV0qsflPqu
 dNoqJp/hcU0luEE6yKOy2aCB1hN08rrmdbwPatuVH9s4Z21tnYbwuCPmmhSvMwzJfsYxElcAue3
 14ynO/pJhWrzmuqv6b9cL8Wc1yvh42CodcuORry8BGMG5PzyDCxPW8NN015So9h4FfEikwIXXXM
 Zdxqvk6AIb2sPTcDCPw==
X-Authority-Analysis: v=2.4 cv=UbFhjqSN c=1 sm=1 tr=0 ts=69fb2fa3 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=20KFwNOVAAAA:8
 a=NufY4J3AAAAA:8 a=ufHFDILaAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=VnNF1IyMAAAA:8 a=3SF8d-dLAay7TFkNkXcA:9 a=QEXdDO2ut3YA:10
 a=TPcZfFuj8SYsoCJAFAiX:22 a=ZmIg1sZ3JBWsdXgziEIF:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_03,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605060119
X-Stat-Signature: gxoh3djqgy1emk5i74nj8mwsbrk5s6jy
X-Rspamd-Queue-Id: D468910000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778069414-538451
X-HE-Meta: U2FsdGVkX1/HTEai6LaDfV90eChvV7RyH+RmJA92haWWJg8ZHh9sYKV6HZU0tLwf4aVwbt8VVDhZz2YAUc8NoPvWd5S5IgyQzlUOgM5mvqRQgt5mJ64JIUnmMPh9iUIeqQ1aFCewPz2i+HbebhyWxZPLA+dnKPNBXpWM1F55NnVVRHpFcWCOHTsaDHRKF3KCvew9wae6tmG/yjQHuAtCwl/GcrNkbEUyjL0IAEp7Vy+LdyU9NOcPbHyFfAeR+whelPwKdYjNKNknA4OuW1adg44rHFoVQn5TBRyJU34ORrr0UMBb1KTslJoDsf7IB5nvj9g+JPqKsCRtjep2HMgkyd27JOv+xL22xgEoB4s6FJYjcORu23Xk5bY0Att3LHAPwei9O9IQWOarHBg8qXiKeN0McPQ7EdVi8zKQphvJ5dOY5Ky79HjQRrchVmEEJw0la9iUmi4wYvCNMn6fg5UPy5XEo+2jFmtZMldTtZr/BIJpWUUW4WX9k0qMEUVSzDwPfKa7nK0iVdSFQy94c9R+o/c2Uk+izICcRBZjAcnPxQ/oc1RXlZzZc4RnLpHp2zAc6VL8XelHKRHxHt0VbAPRqZ/OyfkpSlDW1RM8xHhI3AtiWj9u/ob9gXsfSImtiMCC/t+cCo4tCKWrd7n8B63C7WbpUP6JOo5yhJ7RAqmj0Hr0Pn3x9ePSb4de1QlqmRZwfW4IdFW3eOEajjn1NQ43gS3gIcdgaYNgPYERqA3eBP5tfTrRLROCQy9pn0Es0YtOfW2e7iCVNIXgQZbkqpS28JNJK77sosO1kAlTxX6TvEGQZNTL0IjMCdTaQHV8bEmzr9hprIgotV24fRDiBWEFKS2Rsnl1TxHChz6WjJQZ3YU/JmPtoNXyRVQY0WjQnKVPcMXRKF19X10OY+u/KaoMZzKsyhk2FV+Trnp9rxUbQBSKm2RCkfpeiOKToWjh8xI+CCqj+jUVxsMYmDYghEm
 vrvRnLBv
 T/4ZU0BM7+SHRlc9YXoD3vBEpbx70+0/HxiPdX6SeQBdAneeoVqRTqmBnPAZyv8zl97TwYsBgN4lpSC8driVyNUbu9cjsXHIrWLiVEED4fx14kZjTMCskUAtK8mQCAD5EUGoQs6nCOt+D3PdJgXdzklxEL+U+v5EGaMRDY22v3Xk3IDQggJkG+qvRJdGGrL4tK6fTxT7UUD76oHYBD7OR+Gqdq4UG1iaeRfl9iErgee+t9YCxDCqe1RDfunbcVBQg04LlKWxDy65ZxZG0F+8CW8cgB5YMeGAG7Xj2lKenpIayjiSlLf3E5l2e5f3KvqwSudg8rLcd6VR3y9AmIADGLP3s+9dmoqA3bha9p/CCPXzF6OYZYbaH5wdc0vMfm2KsRLW1ftXmmSXsJRb5Pf71T88uSAhAxSMyQpNPSvdIsHWJXQ+ykEHB06sAJUT7oh3UwUytE4xGRzxnr/Go719DJAX78N0HUJdz65RUG94E5NprnEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/05/26 07:50, Li Wang wrote:
> MAX_VMSTAT_ERROR uses a hardcoded page size of 4096, which assumes
> 4K pages. This causes test_percpu_basic to fail on systems where
> the kernel is configured with a larger page size, such as aarch64
> systems using 16K or 64K pages, where the maximum permissible
> discrepancy between memory.current and percpu charges is
> proportionally larger.
> 
> Replace the hardcoded 4096 with sysconf(_SC_PAGESIZE) to correctly
> derive the page size at runtime regardless of the underlying
> architecture or kernel configuration.
> 
> Signed-off-by: Li Wang <li.wang@linux.dev>
> Cc: Waiman Long <longman@redhat.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: Waiman Long <longman@redhat.com>
> ---
>   tools/testing/selftests/cgroup/test_kmem.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
> index eeabd34bf08..249d7911306 100644
> --- a/tools/testing/selftests/cgroup/test_kmem.c
> +++ b/tools/testing/selftests/cgroup/test_kmem.c
> @@ -24,7 +24,7 @@
>    * the maximum discrepancy between charge and vmstat entries is number
>    * of cpus multiplied by 64 pages.
>    */
> -#define MAX_VMSTAT_ERROR (4096 * 64 * get_nprocs())
> +#define MAX_VMSTAT_ERROR (sysconf(_SC_PAGESIZE) * 64 * get_nprocs())
>   
>   #define KMEM_DEAD_WAIT_RETRIES        80
>   

Reviewed-by: Sayali Patil <sayalip@linux.ibm.com>

Thanks,
Sayali

