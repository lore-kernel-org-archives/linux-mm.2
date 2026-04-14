Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14E5FF531ED
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 11:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF556B008A; Tue, 14 Apr 2026 07:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6986B0092; Tue, 14 Apr 2026 07:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EC2D6B0093; Tue, 14 Apr 2026 07:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00D5E6B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:13:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8BE0258FF8
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:13:43 +0000 (UTC)
X-FDA: 84656901126.06.9CA16E7
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf08.hostedemail.com (Postfix) with ESMTP id 05434160008
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:13:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Lnpz/coF";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776165221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=18wnu0j6nOlBo7L66MN9NA7h7B+h1kmUSFuqSPpe4YY=;
	b=0hP3qfAqzYVH+Rok5xGzrmPw9cJ8CaISW3vIQyU9yIsrBoXleya/Z+tYFdkYN3n12DjasA
	DofFrNCbM8o0l0NjVa4ePEh4CjiPY4Y82eyvoiE5izNJ0A7yPmJxYBPekV4cD9kBhWZ/8g
	pvZNI/6YYsjzthUX84y3FtnBXCK5oZY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776165221; a=rsa-sha256;
	cv=none;
	b=fwj4uclPDLH7ka2jBUrRHdbml6q2zKReOcDvC0FIUgH5GnMVZUgTlOOIq/MGM5QEWf3ZGF
	MJ5VCYzWsCfLzJY9mEwZOTr8vtY3vj/KygK5cMi3EN5RWwRD+BvYBmJ2FAdcJ4aIGDH8sL
	e7ZegG9DmdZzRMhM3Aq6K/np8mApZNI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Lnpz/coF";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLIq1G1860578;
	Tue, 14 Apr 2026 11:13:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=18wnu0
	j6nOlBo7L66MN9NA7h7B+h1kmUSFuqSPpe4YY=; b=Lnpz/coFjQnxQwuMCjNkhE
	98/FSVSTpLcwDZddkGiEgUhB3W+zOk8IVKR8nCRjk4nz7QbtzVuWKAchobLrilWV
	Wgt2t3iYQnTSl5lTlA5o12jAWMqXkLDxu7q6dCACf+394cVUKM1zbWXZ5OJOAv3A
	PLmGyR1r/mFyTYboAhiRmFyRpxmlbuqx6cj5oD7Ge5zYVljngCt3KDDSsLpiuMwn
	xBoQOFuJH+TC9cBCKBk2Qx2q5fMO0X82cZj1kvPRrk1trkrvheBmBcwVPD0/NtpJ
	pdg7ln6kjI2IlNI/EzZmbpPqmd5eNsJ7e/mxzm6Zr/nLA0+Px+Zyjt8kE1iCx2BQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89pa8uj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 11:13:27 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63EALejN004188;
	Tue, 14 Apr 2026 11:13:27 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dg24k92vt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 11:13:27 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63EBDQ8F22676018
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 11:13:26 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D1BDB58053;
	Tue, 14 Apr 2026 11:13:26 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D6C9758043;
	Tue, 14 Apr 2026 11:13:23 +0000 (GMT)
Received: from [9.39.26.89] (unknown [9.39.26.89])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 11:13:23 +0000 (GMT)
Message-ID: <b1a5b96a-a525-4566-876d-5286c1367d7a@linux.ibm.com>
Date: Tue, 14 Apr 2026 16:43:21 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memblock: fix off-by-one page leak in
 reserve_mem_release_by_name()
To: DaeMyung Kang <charsyam@gmail.com>, Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260414094439.982853-1-charsyam@gmail.com>
 <20260414104353.989063-1-charsyam@gmail.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260414104353.989063-1-charsyam@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: wkLhB1sG-uScmjyYMpuqjEOmKu6tMIPb
X-Proofpoint-ORIG-GUID: 7JcEVzdBO7YccUBjh6yMYYB6HFHeu3pv
X-Authority-Analysis: v=2.4 cv=WbE8rUhX c=1 sm=1 tr=0 ts=69de2158 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=A9Q-lSG_ta5snbpTm5QA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDEwMSBTYWx0ZWRfX3M/DsbIwZE4i
 QAWM4kkD8F/DarLEXqCHMCquT2f/UVJ7m+ub+kBtazP1cOwUOIJTAsIOXzjPzwrWJr+wlFgqaK5
 zprW8W8enLD+5lQUXdOgnxxwrnDzcrpLK16CaqzBVOKAOVYqRrZrMyQTFDMk1L/arC82TyUhlXu
 OpSY9WCcLjihggUiuQYfjXo/QEZ2nQV84Nbyzzrhttlwn/FVi24h4giwqqGePAys21GhXCPyhaP
 JDDrUo5U7YWwTOKV/sDidYh6vmiIm6n1uwemOKXMa/sGn1zpsw6FqAx9lPfUO3Hvjra+YAD8f+B
 LlJHkNE/ZsvpFkdoL0tc2xgumxR0tZa0xnD0R2KeJVnMhUSca+as1Ycd1Bq63ECeR4iDwB2PlpR
 GHZ5H927brRWyFnpnqbgR0DBGr6XLzRkjksaj82OWTKKy+Twy/nVpQXELBM/OH9PVVFBpZgpwEh
 g3JrLg7FykuytS6jdAQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 priorityscore=1501 spamscore=0 clxscore=1011
 phishscore=0 impostorscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140101
X-Rspamd-Queue-Id: 05434160008
X-Stat-Signature: m3qr7dh59yqj8eyyw3u8rcq5jnbfctyz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776165220-405101
X-HE-Meta: U2FsdGVkX1/94tRzSzOfMNdxJyPRJzpwU0ycO/ah+WdbN6CIDgKv5q4e6nzHbYqz55Cby9hBXKWRpwngiv50SHrnsBFfpLvfzwi6ioKz8CRSkdLI1VHwA9AJM6ruqHly4/iJ1O5hSRsQRH0p/Np83DXw8THuv4Qsdy34V3VOEcgxzsxRQZQwRunaYGzMFG64GHRWAQbgrC/3ocPa2/n4OUXFj9fflyIGd6GLL3FkfVMNwGA9f7AxstOSinYtfCOJqXkGVw7DtoggEfm8DAzQ6uDflmCcC26rV4l2wod1PuhXVKZe2884/URqsT+mjWXt2G+8HmmQ71H9bNR48brM64CrD2aYsZrjqnLIAMlUse1hFRW3CIqqgGmZOU1IvTU8SrhnlB8nbDCqQxePe3/qO4Z7akVQfrxpia7Y5QRTWF2jD1dJ0HXvruihRt4X2lwlV42fTwVOHTOVUFwlM/PSAU/RBmq0hVZ+JqqB0inPZYFXbBpTDQXkAfy7XAB/k0dMaBR088048ZtKMr6ADcYODJDZu7osoXiWdiWGuR2KCb8abvKFkF9QYtD3Kg72gkqtMqzm4SdS9jypllyfQjj6M68ZBj4UXOVsddod+6r1IB0t2G8QczHMFaRbtrRi1LCAgfEx+xsks6bZA/skDwtihnb0TVuTKqa4kq+igpePv/VutEOOPjxQYYGEtrKXa8I+RaW6fLPu+lC+lrP5cyEpon24E17QQwGi+Vdkujss6UgZS9VrooEy9/Ggcoq7bMBjjnsQqTSkbjfNxm2iRnCWUhFcf2oRLYpU0Db//0ODOYy5iSR/HZqVA1UsjI3lIqbhBmlcN8F4EPNrKlHrvDRwXQWivLFmCC+OVsU9nSHTuggPLt9AbftxvXWwBiSOyEwvqVwulH26XN1f4hwlZMFYoRo/ag0alUo24YsAaxuokREe46FAh/Hs+KOa3sea1U8teYK1ht6dLvanMmU/Rs8
 jYIHJU1V
 9YFwZ+5rIPUYMDAWy5HWAIv4L2iobE4JIpfhj7Mos5dZtO5AnJ1FHlFdn8G89W8ZOygAgGfiSvpmrBoM4C9eMj4smH/NxkC88hqSWByAkQeHbbP+JHtMrI6VlLFql554dmiemXkzK4b3Jz2Ji/yuGKf7BWR+Vrth8MGOY7RfuFyziW4lED4CnGptoGcm45CcN85+1Hb/5iiAd0s+WlbywMXx+MhcA8NUlCS7vYU5V268W4aqVSsOaAmzruw8OmiNoRJGmXVIfJ4bb53X1192eMSOWtCiZNZPrExVMMhO42kq5DxkHK9Kot1GMxo5+XTEZQ4zQLif4rBwrI6MW6aor1PXhSCfzGyPpptp577FOs/OSOvQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

On 4/14/26 4:13 PM, DaeMyung Kang wrote:
> free_reserved_area() treats its 'end' argument as exclusive: it aligns
> end down via 'end & PAGE_MASK' and iterates with 'pos < end'.
>
> reserve_mem_release_by_name() instead passes 'start + map->size - 1',
> which causes the last page of a page-aligned reservation to never be
> freed. For a reservation spanning N pages, only N - 1 pages are
> released back to the allocator.
>
> Fix it by passing the exclusive end address, 'start + map->size'.
>
> Fixes: 74e2498ccf7b ("mm/memblock: Add reserved memory release function")
> Cc: stable@vger.kernel.org
> Signed-off-by: DaeMyung Kang <charsyam@gmail.com>


I think it might be better to send v2 as a separate patch  rather than 
as a reply to the previous version.

This patch looks good to me.

Reviewed-by: Donet Tom donettom@linux.ibm.com

-Donet


> ---
> Changes in v2:
>   - Add Fixes: tag and Cc: stable (per Donet Tom's review).
>   - v1: https://lore.kernel.org/lkml/
>
>   mm/memblock.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/memblock.c b/mm/memblock.c
> index b3ddfdec7a80..d4a02f1750e9 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -2434,7 +2434,7 @@ int reserve_mem_release_by_name(const char *name)
>   		return 0;
>   
>   	start = phys_to_virt(map->start);
> -	end = start + map->size - 1;
> +	end = start + map->size;
>   	snprintf(buf, sizeof(buf), "reserve_mem:%s", name);
>   	free_reserved_area(start, end, 0, buf);
>   	map->size = 0;

