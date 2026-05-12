Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5AFECD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 12:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D1F86B0095; Tue, 12 May 2026 08:58:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9776B0096; Tue, 12 May 2026 08:58:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BFAD6B0098; Tue, 12 May 2026 08:58:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D2BF6B0095
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:58:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B9C3B1A0326
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:58:10 +0000 (UTC)
X-FDA: 84758770740.13.919C0AB
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf13.hostedemail.com (Postfix) with ESMTP id 437962000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:58:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cTo2iYEW;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf13.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778590688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BplvGcE2Ie+j0x10pLdH80hGB87ll31uVVquVDCkdiM=;
	b=x7KdJephtC7bC/ZimGMrWBq7hL9/c2xyB3VWxehBEXPOMaoc0eya50F3gRJ0Kbz0XXNgpQ
	Qg1l3WMczWdNwXiAJb+GFuhHa3hmWzLozDGsJbGWQCE9OsGkEwit/T6iup297xfqvInmic
	FlD5K8DrasaJ83TJ4c6+YAzCxyvlhfk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778590688; a=rsa-sha256;
	cv=none;
	b=vRCTF9EjIU7CnNnXEWNazVfM1ev0LXBI2FHXpRM4jWPmM0/RjAoj9N6iekCzCpbxqa4ADc
	SIQaWPd4VelQDwQNPacm9INzbM5uQ1IKm+xUUWGDGYQFXpQXvQy+Wuwa2bIm2C9vcILZ7f
	BFtABYuJZRIgB1Puqq+Q1OtTcTb1SAc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cTo2iYEW;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf13.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64CC32Zg3185478;
	Tue, 12 May 2026 12:58:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=BplvGc
	E2Ie+j0x10pLdH80hGB87ll31uVVquVDCkdiM=; b=cTo2iYEW+xIzdfhk4Kuaqu
	izH25bpOWlM2wUNN/9BUtgIeYlKOb9HwN0J5X84NEKA0qIs14TEtEkjEua4ZfgVD
	EcHedAPYNLSwsNlgsh/5BVR8WPucVdCzchtsRJqqawV8lbLEfVdHWCrsnjt3yrNA
	vnZvwd5I+ywVqcT/nm4fRV0iI0X6K8EXBqZw0KbPDUikHU9VeEOP9AcLXZ53Wn5v
	9RqI8Bl+AEReOPvsU9jWtTi7icvAO+jlOV2kZZ5ihY3lxdKwUCc7F6M++d7/fchR
	R/6r2eD0EkU9IJ7xXfjFH0tBmxpqn+cqaui6RJ4GWrhb5LGiEtwpJo02JKpV0tdA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e3nv5b3t5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 12:58:04 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64CCsSdl022020;
	Tue, 12 May 2026 12:58:03 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e3nfgk5xc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 12:58:03 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64CCw2AE32506604
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 May 2026 12:58:02 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 699075804E;
	Tue, 12 May 2026 12:58:02 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 31E2358054;
	Tue, 12 May 2026 12:57:56 +0000 (GMT)
Received: from [9.124.208.247] (unknown [9.124.208.247])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 May 2026 12:57:55 +0000 (GMT)
Message-ID: <6963c69e-5bb3-4ac5-96e4-38bc6085d29e@linux.ibm.com>
Date: Tue, 12 May 2026 18:27:53 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Fix mmap() return value check in
 run_migration_benchmark
To: Hongfu Li <lihongfu@kylinos.cn>, jgg@ziepe.ca, leon@kernel.org,
        akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260512101305.139509-1-lihongfu@kylinos.cn>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260512101305.139509-1-lihongfu@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=cPHQdFeN c=1 sm=1 tr=0 ts=6a0323dc cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=q24qZgjzlUWr7uAMhH4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: rfgdGQ-P0cHhwFn5wwG0kSyXfuOZkn6c
X-Proofpoint-GUID: R0fw4q6z-3yitglsWsHUATA4qaUmv1RN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEyMDEzMSBTYWx0ZWRfXwfPzxp/bd2qE
 ix8KD9eAZ2g8OcQeyfjXWv8RJM1qOdb9/XR72HnCFdI94PHNJEAnY9oTCu+Cd+6M8q5lQR53oUz
 kTmYouLSdkkFmYexb3uKGcXB03K8LfkMFmcUX10D3hI83e771Men201+Z46LJd8+tJBWqyeVeQm
 unDlnYrI776v3oeAfV0vxTW22ZrsntleSepc8i9amhYI24I9r5OjTXqy7d6po9RFb9oNQQ7Smus
 BSOJsFoPi/wA73+TX5jcvRRMYBhb+TpXFnQaW68Bw/MQcyxYg8o6omLhL+l1cDwVLEpEf54LcqG
 PeAeHxq/h+GaHCmFfOgSiIbxvlhkgPzO2pC8lTe6WLyn6VIGYzKiZ8w52s5KFwA6wIVZM3sIm1O
 0DGnXEq1UNkMXeW5Kw9I1/1QMAVmMTYYJLoJqqvVp8qyjItSCiB2lnxzJQkLCSRt0kV8PrUcGdo
 k5d/MqWkw1FE8oSOYIQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1011 spamscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605120131
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 437962000E
X-Stat-Signature: sfqh1dkcwts5yigdj85777pd7u9rjn7k
X-Rspam-User: 
X-HE-Tag: 1778590688-634844
X-HE-Meta: U2FsdGVkX19EoOLcKw3oNuXSUc+t7gnbbz7Ac8xxfB8UZQbi6LrNeb2qOIOaaJ+gX5of15VlHty7m2OGszTK2H/dVBFZ4t9yuPsanEq7o75EmNhuS6hSx90UVExsdXId2RPY0j2SbN4skW9uKvFpsth/7b4Zd5SOBHMcR0KlrXiLSnti86A0Ype7B81ZNm7B6UB4pi9iH582Qwmjf10Iw5XD4rxkuHxYi0+YK0xJCK/vADu1WA3REKEhlQZKRjdUZDw/G5Y+gYr91PB6tOkC6kHdgzWFaUFu+1R2KeZZHi49b+bsfXP7aUIJj5uVBWNQnB08HvXY9w0qkGv6+5LYl0E7Jr7aPhT5SLXviXqqc2hN6H3P99Yw3FNSj56Ba3ygARqy+beeRetWtNMuoVv7nLRpYvRhsrJPKlXHwvZc0CTMfoTPxZZoXQaSgGqjzN43IGMKcvIkZj/PYFvoIdzePgS+RJaSo4Bnxz5CCi1sSPotUj/1DBaYhwThr5PhmnAciH5ZG0bXuEp4VoNzuVJ+VV3QEFo/iuWR2vSuVgLdAUz4wzQLNhAGb3gNk9SB5QxCFVBjTLRoeLSF+o2rXXTkdA6MtGvK92xXwMyMW7eZdjO58t3jLOSrxkSA2n1YOFsFa5ReNshu1CRGAKpnzr5LfsrzgJd95eLvqBNVwFm1/pK2y3Oi2neaw7TE5b1oVYP0v3TlVYoWiKUwKxLy2CJ/o7fDFJaG/8/cXiyHfZYpXOUllDJolgxw0qkaFrxRbfkJJgEuafq0vgE6rxj1f1XpSdXmEpyXx9kiT/omzrGqT8iFdvkrYb9iv4CryHX4pxLJFft0xTDJ2T+zYLmw32N5GRkCQk4HNHzC0uyH9M6/BRidxWuXGPkJH0nHQ79qd5g2x8PBkjR0+4ay2Qq7gsIYTB2j5+TwnND4KPlo5Jep0G8tJmdtGx+mKragyAL65yR3i32SqMVFJwD9AAWyJkW
 4gptrLY3
 woEefyFY9DGCt3UMsItQKIBxkICf8e7ssoW0/Gt1oNjAbnkveP5+sNjGiffncXEjaf9tDWWZli1FESbQONI0AQh9AHP5NeQU7x4ohkCeJzfTtU8VRMEPhUYPKH271EbEaITux9mvrR/Y8ZCaPls42/CdSxAUOj8GManZrxZ6lgvCxTwV1biGJVfSlA7ntM4w8/jlbR75zpJZqXmmVNAQqeKgcZCSDK6myoJDddnN9uT012102FVdw18kairuSE0M4rlYGlIAe1dBKO65tT6Ql5Amv+C7+NQathW+L3qopUJXVhyz97tUuVh/TVm7G0/SW2NmP7csiOGwyKIFQHRjIFVq8lIr888dSeYnXU4M3TQW0KCQITeESup5qHlir2bzl3p4NoyyZ9KqE+0k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 5/12/26 3:43 PM, Hongfu Li wrote:
> mmap() returns MAP_FAILED on error, not NULL.  The current check uses
> !buffer->ptr, which evaluates to false when mmap() fails (since
> MAP_FAILED is (void *)-1, not 0), so the error path is never taken.
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>


LGTM

Reviewed-by: Donet Tom <donettom@linux.ibm.com>

> ---
>   tools/testing/selftests/mm/hmm-tests.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index 788689497e92..d72adba5c74e 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -2688,7 +2688,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
>   	buffer->ptr = mmap(NULL, buffer_size, PROT_READ | PROT_WRITE,
>   			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>   
> -	if (!buffer->ptr)
> +	if (buffer->ptr == MAP_FAILED)
>   		return -1;
>   
>   	/* Apply THP hint if requested */

