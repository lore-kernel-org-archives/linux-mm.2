Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A564BC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A04336B0096; Wed,  9 Sep 2026 11:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DBFD6B0098; Wed,  9 Sep 2026 11:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2906B0099; Wed,  9 Sep 2026 11:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 665A66B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:53:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A56AC0236
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:53:34 +0000 (UTC)
X-FDA: 85194668748.16.E108D18
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf09.hostedemail.com (Postfix) with ESMTP id 829FC140008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:53:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FkZShthZ;
	spf=pass (imf09.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788969211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9fEv8CVQ+LcrjyrEyKWNY8tE1ZC5nOC4fuPxuTwwtWQ=;
	b=u/n3z9ywLpx5koq0+a0ieMxXWTI3CtG4rY5itcvb84SaCIC3yPUIgQKeV/ZJYHL9/KGsLo
	o8vJGKXfKzD7qYpAkVERV+bFskW/bR/teUMpU0Ae0b5hCeM/7GozpzbViWL5iLPX+vkuIp
	X1hCdcWZw8bssSygC0zlO2/UoovrmqE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788969211;
	b=7cEZbiquGxMFCfXnibv2y0Y+5dm8P184EBbjZol4JOy4m2bMVX6n5ZlSxwOifASV2WKk4W
	yWYUdzu9FHA+Gk4oE9GcJTVJYJizFvH9eTcJLlk88rc1mE6AOXwqX0tXEcvubxPXXK5fbU
	Co5MvNzK4972y84tKWOoLvdb+vwNN8g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FkZShthZ;
	spf=pass (imf09.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689B1hXA1930950;
	Wed, 9 Sep 2026 15:53:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=9fEv8C
	VQ+LcrjyrEyKWNY8tE1ZC5nOC4fuPxuTwwtWQ=; b=FkZShthZPf6z6Inxuhf+uF
	iNXUzguRjPZq6PaXhqShCZ3McDp20T3UU5KU3cjMrWdZqtNCUuSuqfdkm8GvIvLF
	dd72+XGKDtIjz69shK+IZlKQChWqyKHmF6exXT0UkgZBSqDxfU9Ur7ERBXMUX80P
	s0bhDfhWZtFY8AxXcf0pCGiGI5KikMBri/OGHlqKcjofQOFEa0vOHAVhylAiOQpt
	uCOLt6833VHDacYxqLq1mLTEtUp5aex8n856rgslbajZo+ccvWXcR2TgU4TdVmIw
	4EHKN7jBzQE3ENXFaCKAqQK2azDDhu9EJCVqra+ip00luEloiWqmnR79lR7H0gcw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbqk6vp0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 15:53:23 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 689FfE6N015367;
	Wed, 9 Sep 2026 15:53:22 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ggwswb807-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 15:53:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 689FrJXq50987368
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Sep 2026 15:53:20 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9F5A2004B;
	Wed,  9 Sep 2026 15:53:19 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4CF0E20043;
	Wed,  9 Sep 2026 15:53:10 +0000 (GMT)
Received: from [9.61.255.18] (unknown [9.61.255.18])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  9 Sep 2026 15:53:09 +0000 (GMT)
Message-ID: <30360c50-0238-40e8-b598-bdfda1141cc8@linux.ibm.com>
Date: Wed, 9 Sep 2026 21:23:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/22] coredump: refuse negative skips
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
 <20260820-work-coredump-sparse-v2-2-ba32dd718c51@kernel.org>
Content-Language: en-US
From: R Nageswara Sastry <rnsastry@linux.ibm.com>
In-Reply-To: <20260820-work-coredump-sparse-v2-2-ba32dd718c51@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: pYL1X5j4L64D3lhY8GC7_PxezJajFPeA
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE3MyBTYWx0ZWRfXyZQ2yeCYTZ8Y
 0zY5ztZt9jhIlCwPuIHMWYJZeFMN1RfSvZmQxlYKHYhZCliMI/1/l/3Wg0EpWXDDd6lWozX46Rp
 BOsUhsvxP3K7Gf6k9YxbUWZBPcLY48o=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE3MyBTYWx0ZWRfX5MyolTbYyMTx
 81rdDfK4pUyI4nx4v6Y9Tq/r/gVfH0lueULm43ZNa2On7UJUzNwVwdVblnzuc6TdwypX9OVkabd
 mY7Y+a3Um2ewoWxHnuzkeZMU9B9ZEx8zXreAkdyeB0s9N4qbY4sE3Mi+N9nw47/d2BRpkyMNGvD
 3NamjGc8COyszi5eNpC2WHmCm6ZnIaCNR9nVGU8PKzrDMBSZz7UZmsQZ2GC97VMvBlLdIC1rSRX
 cnRoYJFT+Rf7HW7PJ/28KPLDCHwRT7HIo66pa7r9Oacak+UAvogwSvhdsx8cRtWmtDzjGv5q3Tx
 MRgAeULZKoh4YyzTCo7msiB5MQSn0j7ly8YqteQYeKytKoC6USiarP/25m9uwlz0MZyki4TDtFE
 9HQGoeP/j1znxi3DPlsn/xA5Dz4ToJDJEyWtDxCPse+ktxUKAo6Dlm+UeqHdrTyl+tA5+qewgyB
 79OOPB5Pjo8vswDjYfA==
X-Authority-Analysis: v=2.4 cv=JaKMa0KV c=1 sm=1 tr=0 ts=6aa180f3 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=0fa85O3lyfMzuANSHggA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: x7FvKhawyt97Kk1EQB6_XHSAe9xWv9Jr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090173
X-Stat-Signature: m1jaqz8rff1z57qpuur3uehxmu4b1d49
X-Rspam-User: 
X-Rspamd-Queue-Id: 829FC140008
X-Rspamd-Server: rspam03
X-HE-Tag: 1788969211-685862
X-HE-Meta: U2FsdGVkX1+zoDMwwyzLbDumUIFZgCBJ6U8kVCJ74eF5sXEUpJO8wSDoNk6rL7du2ZPp3uGVCoy/Cb9XB4Gi8qEdyBrDDxGkLspnFxD5K5hIkYx3Fwa20PufI4Bf3DOlejuRp9yghfZlNSjv+USWJJn4Pe0zySaegtD4MV6hQNW8OTgJ+fiTziiko/fvsTJ1DXOK89ZPj93srzETNfiNqu1AGKMTDhWQ/iKykn3PltxkaaTK8EmHnLM533HZRKez09ny3jD/xYU6wYTitDF14Dx0f/zvUlvNvV49aXmUX7CGUsa6oW9z2tvghv1IjKQSgLxEo1rYnKdXIeMAkZgu8zcFlv5d4rNExPg2da4lyuOwoUtocExrg12HZTA2+tr9NGbhiETY+4b/xWvO0jt/s1tRTrYTL5/7G3El4zaQNgHD4ZJU8bwJIDb2akQ1+zQRUKDt6lWf3i8BJuZpkaz62Lcylg9+AINYWsH6E35RHUWsb99s3yxv9+zb/ohkBRpsDcBDHBJqkkj8jV95vuUpaevx/tl+4SutQS26NhXFkPMUOk9LHuFWBCZN3nE58eKUV2MZwZF7J35/67b1qh6k+XmITlLcUpq+HDH10FlCo+XFu0pPSEaZjpZDiKDl3fP1yR3xBYoYp21KB5kVqi+aqcL7qOlnlAAB1pSGils/+dajjqw7o7sdYJEU7eyF67Ehyg72tVE5X5UFQbfG6EhfRNPab0qoTA5ADhkj+OJjfrgRHlFFqzsgRYsuU+DMN330qzUORXjloemOnAWR8iQDiRQT79DoHazMRsAnbXuRM6l5m3iGfo0W6NGeFXLwlASe/wz9Fbgde1Do/N2I/J1+3rvQY6iYgEW/ukLToWI/3nVg598uAN8kAxEFyI2rpRo62SanVSILCOzSpR3Rx1Cy9y05a5MqXFLgdLNTkacbnLW+4j8I+ONKYDWtpewUJGsGocBtfo9oFPAkRj+GW3A
 2UtmROG4
 MO1vn4ej4MWhigd3VRe9ziQ9q2LFJGfbWJsBtcU2aAh4TRkXqDVwjE3VcGv8m3KqoEI3GGGwb4x6CuaV74/RDjKRbuEC3p4F1v8iwNUQl7F5uS000j1ANBuGjh4bLlxv+GpxQh8zMWwlQO1Q9EGuvO1tBSKA/9acEGvMiRBG7pplVtoWIAxnLidM1+7ZHgoA2tygElbai1KCv2PjNLezykjIezJzdAXevo/aPOAm865U5KJpM5B/PEk3pNNMHD3EOacXeyWiw9bB5DK/qWEEf2X3F0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20.08.2026 4:39 AM, Christian Brauner wrote:
> The dump_skip_to() helper calculates a relative skip based on the
> absolute positon of the coredump:
>
> 	cprm->to_skip = pos - cprm->pos;
>
> That's easy to mess up for callers and one already did. This risk
> endless zero PAGE_SIZE loops or overwriting already written coredump
> data thereby corrupting the dump.
>
> I don't think skipping backwards has any meaning. So warn and refuse.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>

System: ppc64le LPAR (IBM POWER), Linux 7.3-rc2
> ---
>   fs/coredump.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/fs/coredump.c b/fs/coredump.c
> index e68a76ff92a3..ac4e922c9cb9 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -1261,6 +1261,8 @@ EXPORT_SYMBOL(dump_emit);
>   
>   void dump_skip_to(struct coredump_params *cprm, unsigned long pos)
>   {
> +	if (WARN_ON_ONCE(pos < cprm->pos))
> +		return;
>   	cprm->to_skip = pos - cprm->pos;
>   }
>   EXPORT_SYMBOL(dump_skip_to);
>
-- 
Thanks and Regards
R.Nageswara Sastry


