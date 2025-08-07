Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86FB5CA0EC4
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 09:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E3BC8E0005; Thu,  7 Aug 2025 05:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06B898E0002; Thu,  7 Aug 2025 05:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E76368E0005; Thu,  7 Aug 2025 05:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D38008E0002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:34:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C5F7C06B6
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 09:34:14 +0000 (UTC)
X-FDA: 83749450428.27.35477C2
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf20.hostedemail.com (Postfix) with ESMTP id C9D331C000C
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 09:34:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NtebDZpF;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf20.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754559252; a=rsa-sha256;
	cv=none;
	b=667mkw9aVZu/wlRBQSizVcF58+nXUGyzdL0vvzFuPgTni5Qp8FbSGzO7JsZ9F/dBpHJgC5
	EzYfH5iShgNNDaywUKU79qv7W3irsplMFWFRRS5A7qaDoaiz9beI9/3LJJwm/75dr6yKoB
	Vz8SupKR1DsM9Q+7abjj0UuF3Y4ZsyI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NtebDZpF;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf20.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754559252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z4OY3uF0CmeXCfiwg6IqQhPAwqZoeH/gzHHFxL3Xd9w=;
	b=ZLfKCVm6eevuIdAWHAAes+a5X3bvBZY1ZAEri7s+U7tuRWtMKFH+3ej2tRglK2YMh1DxgZ
	91nsivbilAY59PNdgfyLZBykTnniTtAqFBlBVsFgV5FWgJKMd3QaPIDuB6pvpM0EtO1Gpp
	gP1l75e/mdjhqaqxPd8kjGiXPW/rNX8=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5775SDi0028233;
	Thu, 7 Aug 2025 09:34:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=z4OY3u
	F0CmeXCfiwg6IqQhPAwqZoeH/gzHHFxL3Xd9w=; b=NtebDZpF2huz2ugNXXfiQP
	LibQKzHcHX5PHFeRk4/E0f9o8PhOqwHDlJU8sfzz2JW99rK28oOjrbyiIlnWR1K4
	sbWf9I1NgQRDB/4jXZpldfu8zJX6IXGfXYiThQz4I0tz0elEjDfeyPvJAZ/+hIOu
	O6y1rCvIEQZaKjJCApA3YWVWiq4ZAxMeTBhNn6DAO/ahJhK87b+N0wJR7RxWT0qd
	FbCrS2gWPB+aMbDd6KVjuuiTYU+mxUE3d8tU5Dr5zAL12GU3X2hsbEdRns7kJewl
	qhJBxA1UsajxbfCcLrR1IrnHYxBFXxSd3Z27zyqUWzem4WUHms/0mn8NqfqAT7nQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bq611djn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Aug 2025 09:34:07 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5779Va7T001623;
	Thu, 7 Aug 2025 09:34:07 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bq611djg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Aug 2025 09:34:07 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5775Ke0m022668;
	Thu, 7 Aug 2025 09:34:05 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48bpwqfxrb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Aug 2025 09:34:05 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5779Y5fS13632106
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Aug 2025 09:34:05 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3FBE25805D;
	Thu,  7 Aug 2025 09:34:05 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9025A58059;
	Thu,  7 Aug 2025 09:34:02 +0000 (GMT)
Received: from [9.109.245.113] (unknown [9.109.245.113])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 Aug 2025 09:34:02 +0000 (GMT)
Message-ID: <b9e29604-b771-4e57-a3d7-430572e552b1@linux.ibm.com>
Date: Thu, 7 Aug 2025 15:04:01 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: do check_huge_anon() with a number been
 passed in
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
        david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
        dev.jain@arm.com
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250807082707.30647-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20250807082707.30647-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: B2c0FcYKeIJpxkcIUxM95fKBIW4F85jc
X-Proofpoint-ORIG-GUID: WtxzAoCGKw2AFPD8a987RjY2VIgfC_m5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDA3MyBTYWx0ZWRfX0z8csTYVfm2K
 N61ZrTZGvOzJqDjkxHWpy8YMgj9hoRCnd37gXvCe8YyqbmK4tG5MQzUKWH06iVamYuSmozFUVvp
 Fc15gAAB68LlBZCE66yR9P1zZ2eaJGlSDfb3MUin3wb9UhL0eO8YfhZ7Wua3KnkhH1EbuJVTJZM
 zsGBemvTlgEdiC+7fo8AvQ6+kfypVheWLY5lExLjQCF9wZdqRz5zHe2ZSUVHoG8JfgytsmTZXfK
 B1kXde7CdFcegMts0wCUrb4IvVB1g2xWUMK1VcBaHS7OiFGToGTz+/UptYT51N/SrgFycBYb3lO
 opXNAdVXTTRFm+bIPY1i2wxqmn+ZbOydZoo1tJEsALP1KlnXA+HEuBIV39KPxiwugRMLyBXj0nf
 p7Xm3CZs0KeNB+SG97soEyt7bPGoeFgGBy5BwfjKZN/A+JJMFAgnFP1puW0xdI/DgpC6H6U0
X-Authority-Analysis: v=2.4 cv=TayWtQQh c=1 sm=1 tr=0 ts=6894730f cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=eg5YlAqusF3bNEAdQk0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_01,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 mlxlogscore=970 bulkscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2507300000
 definitions=main-2508070073
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C9D331C000C
X-Stat-Signature: 8toopnuj3a74ocrh7k3syg4zkf5giwps
X-HE-Tag: 1754559251-708221
X-HE-Meta: U2FsdGVkX1/Fc9X5QCbLfXepLyoUEqgSw+pcR9aPED/Ix7fg8hCppmyfLKltRE40bASKw5wjmadPDWcglUd/iE8ap3XkmcFKQx5BS1DFTklTTHFSj4+pWpoDSVuWBiAYGlLaT34caEi5l0ZuO3GS+VTL3frEkYV6zkgcI9Fi1hW2d1Ob+EaRsBDZVOhfL26Tqqxcfl+D2olyxYTWUMKGJ57j3teXNmJbyawy+0q+RSAqiYHVIfxlW0T/CkFg5QexApagbygGEy5KD0cjr3X+tCUX212FNEBc30QLr5/TLFMFZGAJBwHI2evuJbqj4PY1S7J86iUdRCS0Azfcw/BZNUS61cnfxnfPEbmZ4eGX3FS74l5fvB6m5WafvGrQ2bOa2b29KfDkkfmQy39EhXsQPq+M8/xUfIiq3lg3y5C+LmJZjVpPPHU0N0TsQNx4AehIU9eUNvRhXLUCJUT3f4qBQXzgVufYoEHXThYJ5C/mhPc1l6nucSQOTJiUjTimhDuXRJFA6CfyI1t1797QPSoh9D+iqV+UgrX/cOjDB6BUJfrts1h6Vr6d9ooYWeAW4uH+qqQJQ32dRw9QZSwA7Fk7CeYswoNg5wpPIxV4RYPO9/oivXJNdAqqA62YtwqL6N3ZJ5l1pX1d1sDL9UzxgZcyQm67xNaHCQT1jQcnmNSZQpzwrmBx5QpMJjnhfH2aMq3/DMIBfuyn2w0/31X6GLRQG2WYFe4JSCqHTm1a52jd9INeXNad6Ms5GmWl5cObEWFezR6O3a526l0C6aKZpgfknDUtS+gFapOm1KG+oLxAELMKmRBvyC81Y9RSHoFc+xkL5XGjdFNdAjPKANbSMAe38DrDCJz9gjrz96pp15flQ4xS4Iy/9VZYHxkkEifjPj3q7U31DZOAj/yp5jlARkgM5eYUCvBG6X/vozJQ2M3L2JUiVbyN+zbkuGDA7hbfDeBQoaQ6tWhtq3cvWHXADCY
 U2l0T5bY
 aTjEHGp41eL1R7l/2GptfynJloPPsMFU7pZV+kfnNsoRYIuviiO5c7LHW8oTQ796AVkze9UKdenorTIa24hXSmQN30h3B7cyyQ2zE3pavN8jo70xbAyAidCP373LKvXNgDcSRWvG/YjJOiIAuKBVbsU2U6c7eINkpTEQlmY+S0fhM0T4N6Ejlq9bjBKly57DxkUqB0UyncEINRsX1VEE4UEpm3ZU6Uf74xVUS2GtyirxmpqnO+aGh8W1svfwGjyoyuCvw7bb9qkzfHsgD7WKB08BZxQq4KbCtlGSQnY/re8qYsQ1YJVxPPxpHm9Bj0NpDDdJSnF0kW9fZ8NBVOhZQ6W4vPaN0w7SHIIULXFHZpP/IuP+J4IM47MkhPxrxPUjzkeUZf2mcd48KEng=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/7/25 1:57 PM, Wei Yang wrote:
> Currently it hard coded the number of hugepage to check for
> check_huge_anon(), but we already have the number passed in.
>
> Do the check based on the number of hugepage passed in is more
> reasonable.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>   tools/testing/selftests/mm/split_huge_page_test.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 44a3f8a58806..bf40e6b121ab 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -111,7 +111,7 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
>   	unsigned long rss_anon_before, rss_anon_after;
>   	size_t i;
>   
> -	if (!check_huge_anon(one_page, 4, pmd_pagesize))
> +	if (!check_huge_anon(one_page, nr_hpages, pmd_pagesize))
>   		ksft_exit_fail_msg("No THP is allocated\n");
>   
>   	rss_anon_before = rss_anon();

LGTM

reviewed-by: Donet Tom <donettom@linux.ibm.com>



