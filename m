Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ADF9D1489D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 04:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7FA96B0005; Wed,  7 Jan 2026 23:19:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B55E36B0088; Wed,  7 Jan 2026 23:19:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63176B0092; Wed,  7 Jan 2026 23:19:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90B5B6B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 23:19:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 275C216048A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 04:19:14 +0000 (UTC)
X-FDA: 84307491828.02.EDB4285
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id AC36D4000B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 04:19:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Ox49Xy1a;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=jKl71zQW;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf17.hostedemail.com: domain of dmitry.baryshkov@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=dmitry.baryshkov@oss.qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767845951; a=rsa-sha256;
	cv=none;
	b=IszyXkmEOYfhrJRd2HNVtH87KpVZ7o7+aSRVmh/sHupehbBZD//bpS0dyZkU3F9jdyuR1l
	wzjqq4fV4tl/q9pIzb94mcjOs/LiKZMXBhg+liX0uQ8G1B6nNJJ1uvQEwuiPVVuz6+b+XL
	CFODCX7CgdWnbBXfSKmUnGIbAn9XZr8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Ox49Xy1a;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=jKl71zQW;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf17.hostedemail.com: domain of dmitry.baryshkov@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=dmitry.baryshkov@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767845951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6n6eGO/pCuVe8oMXSNSp7uXmN/PfzMKXjCd5ZAvWwhk=;
	b=nooPlmklASHGCAOiBQzQDhvaOyToCkuu7Us+O46Ra6TkZqZpJuWkNMcNAR8qPRrgSvf5SY
	hhlOxDGMAB2kjWNJaFTz105exkMhFlvsmKPymdzrKhp+VwhiJ7FbC8olOpzc01bW3ggc6I
	fttNYmxNUAjMGIw3ZgtXRkyR/FLLHyg=
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 607HVK4V3890457
	for <linux-mm@kvack.org>; Thu, 8 Jan 2026 04:19:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=6n6eGO/pCuVe8oMXSNSp7uXm
	N/PfzMKXjCd5ZAvWwhk=; b=Ox49Xy1aKllJcA13izEnh8wm3FKR/VoFZL6dzt7+
	wXVtmtJs38hRBb2koqv9cuDltsXF8adOvil0h8GFXMIyPcwCxZ/gHLcE5q6gDVXH
	vKDNoEV2mMP0aZRAbDZCQgahQYa/mZtESrYseEQ33+ZgdWu3gV8F86R6bwGacOZH
	xYJEMKQ0MERorQXryUU2+vnBX0PjcRjKyNyVagT2FxBUWWciKAfgtmS+jYj2Z8WI
	IVyyEK50ReTw31Ogl0+LTXVRdCt0EvvtTOPMcCBEMDfVIv8ZdprG4mgxPcpTC3hB
	qisOt9nxPCYdI32IcwSLY5Gh5v42Ao3MLb+cB8NNeaiEiQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bhuy71nkj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 08 Jan 2026 04:19:10 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8bb3388703dso1056019885a.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 20:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767845950; x=1768450750; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6n6eGO/pCuVe8oMXSNSp7uXmN/PfzMKXjCd5ZAvWwhk=;
        b=jKl71zQWZHTEubDNgffqpUs4DluG8n4J3EqtVrhIXyCsFJf9DSiyBQtJlD04l+btAV
         oRAHTlnkpQB7TOTN4QC+aHCmFJLg8xr4m1WXPCROQQnRt6CscuheSBNxZ3UlkvuqOXCr
         OY0oGq3D/3ZAoloACiafRiJwmy3tnL50H6AMu+YurQtrIjN17jr5U8EU6usIfX6n3RKt
         doXLQFtu70RNdsAmdO3G79ihudprHNOUfRxvNQv7qppfyHQK9LKJXFmC88Ve3lqOVr2W
         6RFMWOb/X+MQThRlKFP+5JlIemgexCqTLnnN3lmmErlJghJQs+lKsm1VYW4qT9+Lqa5p
         gMqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767845950; x=1768450750;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6n6eGO/pCuVe8oMXSNSp7uXmN/PfzMKXjCd5ZAvWwhk=;
        b=gkTzXf83nC8+gULM4EbYj9/+jszY7RJTxgu8NXRBBO7pItAlvOmlM8Dx7dc5UrPbQH
         bGXHjkYgJLWKTMzB9K75pD7/73MC7swweNUC0kZ63ZdJU+E1/pS+UOU+djo9hyDr+PDR
         w7JTH5ZKbI+lPIMn3Kv7rR5F69GVLxsWEGhRj8ILzsOrv+N2yhxO5x+IxPd3c5gTYt4y
         vTaQ66EMPSvdPpXy/7BxjT+86HFPNzm31Ue30s0j31N/ku++bfh7HqmRn4e+d31HEWLv
         6vVdlVEr2B8vs6Ijz3HT486WnCFwe0RL4YlbgnkaZVNrP99gMZPaitLE4kVw0T7gb7f2
         4Dnw==
X-Forwarded-Encrypted: i=1; AJvYcCUeUambavFh4f2NglvrHCxrbc8qPkvyUq7g/Q9ccytg+5WdHmveO5uS0zeyNgNE7QlaflEiFliukw==@kvack.org
X-Gm-Message-State: AOJu0YwGZeJtBvEXkIpBPUl/LVqQI2e2OKaMfHR/ZjD07HbKnEvsQe4p
	cJSdyjmWcea1Stbq8IAE+7wy9C5YWVs0r3JO5ug/9FKJHo5Icsc/CIyiR3lRRVgX4mHvjirXhgS
	I4FZlSzUA8ZzLi1hJ8bjo1oWMzWGP9i8E2Y2GSRGEpvb7JpG/4Zdtjg==
X-Gm-Gg: AY/fxX5IqiFVof6Cpkx2eqb4E1c+R9lKURX7FcpJnQoFss7tIGg3ez1KML/WcrD5Mpb
	L/237hj69Up46H6cexUvHT3yTTOn6T7Zf2iT60pSSLigyShym++MZJzRUDEXUFXc2WpLlNMpvqJ
	CzyBdpyyA3sJ0jgnkY+QbFnd7Q2M1DXube8Rhidu7Xz99iQILefxZsJibfblKKdcCUf0ZRi5COE
	F1SF5HVs7ZjzO4wVC7yQsWt5XocHOPj+XD6oBKlNA/IRTC5FIzqBrE3GrWNjPW7LMgpEvXzKmCj
	qiENOjD/UBRYpahRk62K7u5lORMTXH4Sz2Lk0yWcxVA4pogugxuxbqojZCMM2mwXSGNsIP0uvoC
	wvCG3YF15Mi7K2xOflIeKHAsv8RK3QQ5vYjdPIYp2maUxGIX2WcLLU1lhl38o2Sc8B2mLbVPq2w
	6tJusxRAOl1V3ZzpPI7hRETL8=
X-Received: by 2002:a05:620a:192a:b0:8b2:a049:4ac4 with SMTP id af79cd13be357-8c3893954camr655324685a.27.1767845949868;
        Wed, 07 Jan 2026 20:19:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGrjpQVGWdWnQFS7NWmu8BLh7IymgpE9bLHvysOl1J+xcsuKnw66JiyKWG4oIyo4FhBezbbng==
X-Received: by 2002:a05:620a:192a:b0:8b2:a049:4ac4 with SMTP id af79cd13be357-8c3893954camr655321785a.27.1767845949437;
        Wed, 07 Jan 2026 20:19:09 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b6cf54bdfsm1197240e87.52.2026.01.07.20.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 20:19:08 -0800 (PST)
Date: Thu, 8 Jan 2026 06:19:07 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
        sidhartha.kumar@oracle.com, jane.chu@oracle.com,
        Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 5/6] mm: cma: add cma_alloc_frozen{_compound}()
Message-ID: <aV8wOx_O5Esy5fni@umbar.lan>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
 <20251230072422.265265-6-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230072422.265265-6-wangkefeng.wang@huawei.com>
X-Proofpoint-ORIG-GUID: 0y9wWEPg45Cvlhxndy3_sQwBs1qlVPF4
X-Proofpoint-GUID: 0y9wWEPg45Cvlhxndy3_sQwBs1qlVPF4
X-Authority-Analysis: v=2.4 cv=DZEaa/tW c=1 sm=1 tr=0 ts=695f303e cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=i0EeH86SAAAA:8 a=Ej1_6GTrvnUClRgrvkQA:9 a=CjuIK1q_8ugA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDAyNiBTYWx0ZWRfX5+HOVKd1DSen
 7630Mm2/mN6n1hbpAK0yM68q/ULYZD+/8P0EdkEvynB8JxBa438UyRks2l/XTYd0YIjYMj6tMWL
 VmUXnIkJg7RRH5aVO2nXzWQOtpFLGAK2NaGY2rZbG5w1KW61DiQ6l61aOrZDy6xV76/9sXwwt4e
 taOS4eaVf3cdO8NJk2l5ltDk96VFCoVndadstOCzvRJcYLJ+RQ1F+gYQ7QB2B4wQW8aRFvqjuLQ
 w8+JS5DwjfQlz0+Pn17DiTFbpbYFpvOMaKvFr6GDM0X3HGf/BSAGy05QZA8bgLjN+/15CsLwjP9
 C0thhnihUfO4wOLDEyZW3fWqF9L+zQInpWb6/g0VnLN9XVX1mv5UZTe7odo1wAehHovl6s6riTw
 inbPsooeNHBHo5EEW2nqGjsmKtmbES6oGDRiJiWDTdkkKQleY6Sg4PgS7b0gezz9x3eFfcOQCF9
 Qu87rKKzlJFgGS9bIbA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_05,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0
 spamscore=0 clxscore=1011 suspectscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601080026
X-Rspamd-Queue-Id: AC36D4000B
X-Rspamd-Server: rspam03
X-Stat-Signature: i3pkhqtccr1u99ykq3s5jqb5xj9477t4
X-Rspam-User: 
X-HE-Tag: 1767845951-706786
X-HE-Meta: U2FsdGVkX1/n12mXRRKsBgTIfd+koQL2Hko3Hco6is0XpbKjuOSkuFbyRE4G6TOE7PDzyXYl8qVxUL2F4S/U7y8EvOLFn8A0aK/LkOA8cmBHsAUwGRWRySLJ9j1xd26PY4SHlKnAiztMBqgEO5bKSaDmPtyVWI41qi28xSs9gUyUEMPAZYWP31DucJTTKkGPl/m2CCrnIWmGTiZCPIHWKwzLgyGQUcIsu4RHS8up5+GiF9nQr21hefj5ez8ZCBozDcl8ie3A+QZ8q6siik2/GohznFaqr/DTqQHYuJY24RDmwaZfi1Ka44RdDhvEe2ZXiYz+OWVDOVVaA/XBkoy70sHiiFodCLNRieH2ZO2YEEksieT3GdQONSEpmxclFJolTwicKeCBq90XA2OQLwXQOm8oFFgY+5pzoV4mIZYBhB7CX6YNfOnQzPyVrWetrmvXIMb3U/gUTqzu7WZL9m/1ZKsMg1rebGpvgUCmK7J9YdK6NmXCF54oFC2kVNhWABnVHrE9clGoGXJH2NiVULc3WCO8jzq0fFLwN01qWNUG3/c8tmt6Pm8A4WCpwijjtL270gnJ28q8T4dhdDXt2h+S0vw6emlpK7EYXeINOjVRncxSYikTdDEZ1Omn3AkY7KLdrs6iRR5jEdqbTQidDR/QkJHcknXjXHLX26owr51GfaPD5Lb3kijf0OcE9KA7SiKSRCzFhEHjo9ZfqKvDCRCSIhe9yMX7HS2TTPYA/syeLa/csAHyqz4q38SIW5ljfD80GK9qFtbchXd5ECuVjMXTnwr+F/B2TyZz9SADBCAnY/kJXQ60HViHkaczxQy32u3KfY3i6KtSGIt9R/lxk6PbMzG1jbqkregfJhYsP+Sh3DDJonPrDGk+DjJ27cMg0hcTceYGNwsqHz4Qx3wEqg3qe1KSgs13pIoK8GwJhtjIPn9VJM5elxDv99ry/CujCIc90M90NLI43T6w6ymI/Nf
 RI9J9OwW
 zfyCRxMIW6xxBUxoIvPjuFaOKvxC63PYwHLRNnnjwSgA0vhHWvPMUTAdUOF20G7Zb6TbMFQhDW3zQwcx3tSeGj5PYKKDVsHZBVUgQZc/vRGbfkCWqbQLtMNG2Q9WO7f/Pm/1v7OvBcAn7aCImov+tbK7a0x/aVGaC9aKDGxfTrgeQYGEx2PaNUTbH69FD3pBxElI3K8VMpsX6xQBmVkib0HvSyFpWNiQ9eZRNOz/8IiMrPIxQ81EFVVlBnFCVDqZN3L/1Le5Xu/FmmQTtxRYHJ/7+bCdqAn7vbE1GHCIyFjg9tVICryC4uwTpY6KXwYGSZoLcYot+Wp0q6y+hlzq1BOr5StsY3+jqiCaX8DDEXc/B4vFb1FD+AIUke7Fe9boCZ6GvM5MJG7DuK7LYNlmDQ8vFnJHeiBNb6smN9koZ0VmkdX5h/eaJfgDe82JiIQoU76lvqRfLpQxkanL2k2hWOBqOqDx1j9wLFqatBVoKNfnMn2XUSRwkt03WfD5mizM7nc5NYFJH6KumDnuSkukr90SdXGVyzWl4wT8JSMBsaglBeHU+fFSWxCAbvO5qvQdL8zbx9Ne045P2Z+zAy/m5kSDNhQtRcv2bEU/wVpV/xgranPeFSns5o7CeeK+KfxF9HTSYUkduNtTquLWkhcMOWTCI+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 03:24:21PM +0800, Kefeng Wang wrote:
> Introduce cma_alloc_frozen{_compound}() helper to alloc pages without
> incrementing their refcount, then convert hugetlb cma to use the
> cma_alloc_frozen_compound() and cma_release_frozen() and remove the
> unused cma_{alloc,free}_folio(), also move the cma_validate_zones()
> into mm/internal.h since no outside user.
> 
> The set_pages_refcounted() is only called to set non-compound pages
> after above changes, so remove the processing about PageHead.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  include/linux/cma.h |  26 +++--------
>  mm/cma.c            | 107 +++++++++++++++++++++++++++++---------------
>  mm/hugetlb_cma.c    |  24 +++++-----
>  mm/internal.h       |  10 ++---
>  4 files changed, 97 insertions(+), 70 deletions(-)
> 

This breaks booting of Qualcomm RB3 Gen2:

[    9.500774] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
[    9.509862] Mem abort info:
[    9.512745]   ESR = 0x0000000096000004
[    9.516597]   EC = 0x25: DABT (current EL), IL = 32 bits
[    9.522050]   SET = 0, FnV = 0
[    9.525194]   EA = 0, S1PTW = 0
[    9.528429]   FSC = 0x04: level 0 translation fault
[    9.533440] Data abort info:
[    9.536400]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[    9.542030]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[    9.547224]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[    9.552684] [0000000000000008] user address but active_mm is swapper
[    9.559237] Internal error: Oops: 0000000096000004 [#1]  SMP
[    9.565054] Modules linked in:
[    9.568202] CPU: 7 UID: 0 PID: 59 Comm: kworker/u32:1 Not tainted 6.19.0-rc3-00212-gfb9a328d3040 #4016 PREEMPT
[    9.578552] Hardware name: Qualcomm Technologies, Inc. Robotics RB3gen2 (DT)
[    9.585792] Workqueue: events_unbound deferred_probe_work_func
[    9.591791] pstate: 204000c5 (nzCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    9.598941] pc : __get_pfnblock_flags_mask.isra.0+0x30/0x60
[    9.604669] lr : free_pcppages_bulk+0x120/0x274
[    9.609327] sp : ffff8000808ab610
[    9.612741] x29: ffff8000808ab610 x28: 0000000000000001 x27: ffff0001797fa380
[    9.620071] x26: ffffa5ded75b3800 x25: 0000000000000004 x24: ffff0001797fa390
[    9.627399] x23: ffffa5ded7850ea0 x22: 0000000000000001 x21: 000000000000003a
[    9.634728] x20: ffff00017f41b020 x19: ffff0001797fa3f0 x18: ffff000080a2a9e8
[    9.642057] x17: ffff000080a2a9e8 x16: ffff0000803c1b50 x15: 0000000000000003
[    9.649385] x14: 0000000000000028 x13: 0000000000006aa1 x12: 0000000000000000
[    9.656707] x11: 0000000000000001 x10: 0000000000000000 x9 : fffffdffc1f8c000
[    9.664037] x8 : ffff00017f41b028 x7 : ffff00017f41ae00 x6 : fffffdffc1f8c008
[    9.671364] x5 : fffffc08070506c0 x4 : 000001fffff8100e x3 : 0001fffff8100e0a
[    9.678693] x2 : 0000000000000000 x1 : 0000000000000017 x0 : fffffc08070506c0
[    9.686021] Call trace:
[    9.688537]  __get_pfnblock_flags_mask.isra.0+0x30/0x60 (P)
[    9.694257]  free_frozen_page_commit.isra.0+0x1a8/0x478
[    9.699628]  __free_frozen_pages+0x240/0x5c0
[    9.704013]  free_contig_frozen_range+0xc8/0x110
[    9.708764]  __cma_release_frozen+0x54/0x188
[    9.713159]  cma_release+0x4c/0x78
[    9.716661]  dma_free_contiguous+0x2c/0x74
[    9.720870]  dma_direct_free+0xf4/0x188
[    9.724814]  dma_free_attrs+0xa8/0x1d8
[    9.728666]  qcom_scm_pas_init_image+0x178/0x18c
[    9.733414]  qcom_mdt_pas_init+0x130/0x23c
[    9.737623]  qcom_mdt_load+0x44/0xa0
[    9.741299]  venus_boot+0x14c/0x2e8
[    9.744891]  venus_probe+0x32c/0x5d8
[    9.748567]  platform_probe+0x5c/0xa4
[    9.752332]  really_probe+0xbc/0x2c0
[    9.756009]  __driver_probe_device+0x78/0x120
[    9.760483]  driver_probe_device+0x3c/0x160
[    9.764779]  __device_attach_driver+0xb8/0x140
[    9.769347]  bus_for_each_drv+0x88/0xe8
[    9.773290]  __device_attach+0xa0/0x198
[    9.777232]  device_initial_probe+0x50/0x54
[    9.781527]  bus_probe_device+0x38/0xac
[    9.785468]  deferred_probe_work_func+0x90/0xcc
[    9.790130]  process_one_work+0x214/0x64c
[    9.794251]  worker_thread+0x1bc/0x360
[    9.798103]  kthread+0x14c/0x220
[    9.801424]  ret_from_fork+0x10/0x20
[    9.805103] Code: f8647842 f100005f 8b231043 9a821062 (f9400442)
[    9.811358] ---[ end trace 0000000000000000 ]---

-- 
With best wishes
Dmitry

