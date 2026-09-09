Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD66AC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C07D06B00A4; Wed,  9 Sep 2026 11:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF3D6B00A5; Wed,  9 Sep 2026 11:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF57F6B00A6; Wed,  9 Sep 2026 11:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 804516B00A4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:57:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1546F40268
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:57:26 +0000 (UTC)
X-FDA: 85194678492.23.F586D01
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf03.hostedemail.com (Postfix) with ESMTP id 86BEE2000C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:57:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JaSQu44p;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788969443;
	b=o9ZkFM0VTZd4WIpsVjgUZu/rEaPYDl4L+ywTmBmJ23QzUJDuvhVmB2k/+KcFRNRpTyL93s
	PwAyQhkg9lWF/8t4QQAopDI8I/zuM+9mGXGCr3TJcazV3ajvXtDt8TrFenmDY46YTxDcYg
	IS3t3vH/uKC8T2ydCxPJKrrd0A0pp2Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JaSQu44p;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788969443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4iy8+0hPHH7H0KKiy1Q7l0n/i6naXWb1uop8VCTdEJI=;
	b=OhWjKRMLLfyIra+/udm8CtBIm78/NMTb9BRvv+Dl7OLcoJKT1sg+HSvSHXoG+pDAqrIsOk
	QHbospe3COiU4sSVHxqu5Y3B0+9oowUaNaKpcp1lIuW0pE0UHnuGffA82DzEQQis0TZ4TB
	Dbw0Z1j4iKxbjsavqg+A0c7QGkliko8=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689B1Rtj3817360;
	Wed, 9 Sep 2026 15:57:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=4iy8+0
	hPHH7H0KKiy1Q7l0n/i6naXWb1uop8VCTdEJI=; b=JaSQu44pl+aIEJoiFJDWMG
	HchHUmbXHHotFErjlf8Fe7i8rpP0Ieft5b0BQGRt36/W5daev1jbFrpn6Tiq+M/o
	uZ4cpMUOBZ9OjxNUfkLC1bRV6EO/6ypsipJrzeixBHCfQhLmrPgG6wLBepTfKiZG
	0x0XK2QlvXdeD36NOCD5fG1s1pBI8HsnDnUz9Q++MFQCwibdOrpqABpVkieBZdIm
	1wqyulr0MQdjDo5QgC50gwAGGLC7zlDH27ZDt66gHSi/pI5IUnbQqZ25V8E/CACb
	1ZLoNLkFXpO6Q37XnJGIB2FVEHSAjMfQLSi+2wtyNIkiNeAvjzRWtLCtA/SQfZPA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbf46xjb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 15:57:06 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 689FuGdF014562;
	Wed, 9 Sep 2026 15:57:04 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ggxdk35yd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 15:57:04 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 689Fv2UA48234994
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Sep 2026 15:57:02 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 555E82004D;
	Wed,  9 Sep 2026 15:57:02 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA3AA20040;
	Wed,  9 Sep 2026 15:56:52 +0000 (GMT)
Received: from [9.61.255.18] (unknown [9.61.255.18])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  9 Sep 2026 15:56:52 +0000 (GMT)
Message-ID: <bf38ef7a-b05b-4817-b0fa-9d3fc4db0432@linux.ibm.com>
Date: Wed, 9 Sep 2026 21:26:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/22] coredump: deduplicate the to_skip flush
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
 <20260820-work-coredump-sparse-v2-9-ba32dd718c51@kernel.org>
Content-Language: en-US
From: R Nageswara Sastry <rnsastry@linux.ibm.com>
In-Reply-To: <20260820-work-coredump-sparse-v2-9-ba32dd718c51@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: o_ppSA6HpClRhej38K5mg3ChmUpff7fD
X-Proofpoint-GUID: bPnYIgREOEB5EeDQA6JU4_KoXaV7HYBi
X-Authority-Analysis: v=2.4 cv=DbEnbPtW c=1 sm=1 tr=0 ts=6aa181d2 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=U0HCTcrEiqaaI9b4TmsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE3MyBTYWx0ZWRfX1INXvyjh3PgV
 xQbn2Uih0jsf4f6qVCpUDcjJWOb00k+Ln6MWP1HEhOKbnwX46byyERV24jF3E25LwaMtTwAoZAG
 JlLZGp14DEo26h1b9FeakcBQY4sy0+mZ19NERd76bxzjO6yBGJLgljT6Yt/gYZvrUn0O5JG5PwR
 dTB95L9owQM4u9Y55ThhxTfzzkVEIIYNmVVSdHs68AQc7YygY6nDesC7CjK7Lj5oZmaoHCafPlc
 YzRco/I2Cc13eUypylwhjU/ds+UEADyYW6PRnj5JonLnxV6j16SuM5ekwlPfrHQGPvuDUpoMtrM
 oZ6JMWmlYtbmHsh0EZ1aB0s1/DpXVQ7s2HDMwYZcEOI72U5VsJGy6SgQ19D3uShtLC3PplZYdT7
 BsaR05CMnTEUC+PonGGCwFmWatR530/8w9adsbU8wPtMdP44EHtsZsZOUy64XFoLw7Vl6+y4QNx
 E5iKRzrAgR1p38vAmIQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE3MyBTYWx0ZWRfX5v5JLgxSqhGg
 k6WRTM/rDiDuG3bMIzKiwt4bgN/RJmrPOK/vdSj+EnzdvWNnr1shv0tQh4Rh2GEl06RaHS3lbW2
 9jZZMbTQ05NqRYg50QCFDq0Wjry0tYQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0 spamscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090173
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 86BEE2000C
X-Stat-Signature: 31ig6rgzjnpqsihq5o9nha5bxi4ohorj
X-HE-Tag: 1788969443-413474
X-HE-Meta: U2FsdGVkX1+ZuATaClq+zKA3ZSt0oOOrB5Dz5NUoDHRtERVVzYNw8aGN4tDuutEZJJs7j7JW1XlZ+tSI4Gd5w6PXSTCcEFQRVkrbbBzPrZLGRnFIRAgowX4A9sWEesWk1BMSqRedt/Cyj/vg0RIgNKx/wMRip+EmTAZFD49bk4PsixYNvK8q4ZCH+nB0n5ITUILEjWDnHt+RxOX6yZgBQhsM6CyIocpDfrn0mqMHJqUVDE71C1fia+CT3A6WoIRrWfFIBWs06eJxX5wL0hWAPNbW0VP5YBWKlEsC0j6rVydnvWolfUqmLkVUAC2PcTeMRH1KNVTxhbToblavFQ31E+69TMUO3U0MII1I+GlqQiDXx2UA15heGqDyAK+QfAJIU7eIqI1j7giLAIdoCUa+K0XnXHQ4lH2wU07BkBwAuZgka8bgo3bPrvqGl1G+j3565mCK89+8HtVG9e0a58CjPnXK+7YZDulEbfzwV2SL7Cjoo78RKcYtvoE6ENUw2OA45QpvXoZIWW9SD8dmulT2tlXhhDeWBL8vgTLhnygjaun/nSvPLXZ0mYYz5BERxqCzQUgLryEx/beOZDno4/ur7+ImBaGxtytBqjHY4SA8iwOuyYSkoinKLBq+Q7EMnM0gEhcAlNZgHcGWpJGTN+8DZaa2OoP+EczrSolTruJe2bi5L7fLiXVACEdWRzN5VTQuZW02qijQxmimURalCYZ43dyDuMaJvq+f7Zk64FpY27XIXAaOclku90+4P/zjITEuEWTyxicG029v+ilXUmFOclHrjN0k1OVa6fcAVg7Y+K2GxUIyFxHbfikS5tZp/UeVM20J+1H24DQ0mHEmAMZmEUgmLznKLMV8/NdNHtLqwAprb/cbDu0E/zhPJLK7HRdBTMT0c/k4r3ceVdtwClzhWRMF36+pU83U6OZsTm4P3l20kFn3m82Yj1wgwb+91j8Y7iopUKjHYNjl/brbrKE
 nytidDaH
 TfHnV9OAG095t9rx2Ra/WKNVJvUsC9WLfXK8LZsYbXJnGUXxACts6C0cftJ0g2GOjj7YRiRX2r1kS69Dhh1uAQcqQjbm0Bh/ZuE01Tnk8vTx9hjKYopQA9FZj51HUiTPq9Fi3yMNleD6U/gcKRPE6vcmdGSx1byXsN7aVbKiLl7WRMElwA6DuPKy5X6vQ1j6lXu2cY4xuaQl0FHJcQtvC2s5A++jkyIp1QQzrfPwzyT2ANc59Wn8OwrgD2GoadUnZplXOSzpVqY16ijKISFkTlPPXLw24XessiKSgmsTVDGitNsbJewYZk3Vt0Ivr3wiJpB2X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20.08.2026 4:39 AM, Christian Brauner wrote:
> dump_emit() and dump_emit_page() open-code the same flush of the
> accumulated cprm->to_skip. Move it into a helper.
>
> No functional change.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>

System: ppc64le LPAR (IBM POWER), Linux 7.3-rc2
> ---
>   fs/coredump.c | 17 +++++++++++------
>   1 file changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 156688be3df0..cd36a72be445 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -1256,13 +1256,21 @@ static int __dump_skip(struct coredump_params *cprm, size_t nr)
>   	return __dump_emit(cprm, zeroes, nr);
>   }
>   
> -int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
> +/* Flush the accumulated hole before writing data. */
> +static int dump_flush_skip(struct coredump_params *cprm)
>   {
>   	if (cprm->to_skip) {
>   		if (!__dump_skip(cprm, cprm->to_skip))
>   			return 0;
>   		cprm->to_skip = 0;
>   	}
> +	return 1;
> +}
> +
> +int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
> +{
> +	if (!dump_flush_skip(cprm))
> +		return 0;
>   	return __dump_emit(cprm, addr, nr);
>   }
>   EXPORT_SYMBOL(dump_emit);
> @@ -1293,11 +1301,8 @@ static int dump_emit_page(struct coredump_params *cprm, struct page *page)
>   	if (!page)
>   		return 0;
>   
> -	if (cprm->to_skip) {
> -		if (!__dump_skip(cprm, cprm->to_skip))
> -			return 0;
> -		cprm->to_skip = 0;
> -	}
> +	if (!dump_flush_skip(cprm))
> +		return 0;
>   	if (cprm->written + PAGE_SIZE > cprm->limit)
>   		return 0;
>   	if (dump_interrupted())
>
-- 
Thanks and Regards
R.Nageswara Sastry


