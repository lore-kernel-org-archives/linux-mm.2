Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51F9FCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 20:36:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 205906B0088; Fri, 19 Jun 2026 16:36:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 192116B008A; Fri, 19 Jun 2026 16:36:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 009986B008C; Fri, 19 Jun 2026 16:36:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF9926B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:36:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C9D6C23F8
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:36:12 +0000 (UTC)
X-FDA: 84897819384.12.ABA063A
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8E8098000A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:36:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=mnmKjTkP;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=XX9lk+W1;
	spf=pass (imf30.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781901369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9GLtWWqWktjBsO6zUS9H3pH7linCcBMrn4b8Id1EqCo=;
	b=WBARfTFzfyExh26DTL+34M9FYcjEgHdWEygdOv3CFpM+Nq3kHRQ2S8qlQqFY0UarEwRGgA
	NZ+8CRwUyJwwrnopTZ55rpX/tLNykcCR1W9A1uhm0sQrof4s63JXIwnSjT7fD+Z2+G8veG
	NaqNSh2OYBc3QYyhJxdrSLNBZxOdKnM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=mnmKjTkP;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=XX9lk+W1;
	spf=pass (imf30.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781901369;
	b=SiEKGo+F5I0V7LhDGNdr8FeEqYpQlsehS91PROi1uHfTJKL+kyZGjhXxyMolhcECbk+gTT
	ePBb680Q/yZFdNozNpca9kUvl7IbQp5NoRdti+nVSiB5tmw1iXglI4ra7aWO+7kMoG3gBK
	LBlS1dG/vc9tBtfM0iHsZcXWiCSBPqI=
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65JKCslv1740493
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:36:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9GLtWWqWktjBsO6zUS9H3pH7linCcBMrn4b8Id1EqCo=; b=mnmKjTkPWPoCwaUT
	LxhBBEEXXGk9WNnyhFzSBuWEYy2N11iQv6BeZEOCkGH45d8lr1wZ+7sSfCeyO/WX
	Pc1vaYX2Ntup12I3MOYsjS14ZjYJ1DYsdGz4u3zTdtZKmqAAiO5FcS+KBt5r35kK
	Aep2JMrSNp6p5llkGS295Y1rRwRvS5OeK1RR8IiTg4E9CPUgOnNL2XNusZWIoXah
	rjr7qgop7fWR6nxsV6hxzEVkqTTmd69C+eSiOOvSr7iBs1BtIy5+VJZuURhONN8p
	g0c7sMQXdyxGAkY9zRLBV4MWOmGfTNQzvhz0WOT9uXBJZPjYXLmu4uRNuKP7vi4y
	4IQKUg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4evm22dmpe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:36:08 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-37d125687b6so1663299a91.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781901368; x=1782506168; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9GLtWWqWktjBsO6zUS9H3pH7linCcBMrn4b8Id1EqCo=;
        b=XX9lk+W1n04pRfdDntmo7zoxmwQSOjCs1KqmLLtkcFNjybk0hcwAKn39rWFZ8MIft3
         LR/SF5Pwxr/eT8SZDsAoAOTx7IbvqUNhQkwOOVaicp5o1xmfT17CuF9qQ2bmiio4b8Vi
         F6G1VhV2gFQzJz+2nZsaV6GtJJNZru/p+XbqtAmEIG4a0sriXQiIlMHjlZH1FY9rtk8c
         Vz6Xgp/wMeVCARtMOJ5RH2qfyF2K5I3Ysqh5Sg0y0zv/Etr2ZcSUzCFWWGpDh1vcjaQ+
         LVPdJJFwhBAJ76+gm5Wi5jsbpeT26VnL9zfw7qtPSJjiFvu097v0dsf72Gc/Rz84FFW4
         uAbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781901368; x=1782506168;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9GLtWWqWktjBsO6zUS9H3pH7linCcBMrn4b8Id1EqCo=;
        b=n04zsN5qf42N0mDYOa56R4bFcr5phJ0CK8lCfFs0hhA0HGkmnr5hUI4fypIKBoEpC1
         IMMY/DsCRpS03kEIRPx2ctb8kso8eJGSZxh3PNZxb/xLY34+BmDmmCnhZgaxF49gJ3dR
         6NBi5J78UJcHadYnbf8RVemhAAZR4yTnbWIJBb02mIatIQ/+FOzAKGACVFR8d/bDA95Y
         VyTqZj1snD1HlhsU0PvuXbVlU6ojOmzFTNU4hTcdFX4R8iziLuvewIYUEugeT+XKeUnS
         8y3RMiQi/3fBVMF/O9UG4rwf00FURyUeOpyoSEyR+7lR3bhCn2MctuR6AMmU9Ae92aRy
         oKZg==
X-Forwarded-Encrypted: i=1; AFNElJ+WBYk7xnWKgjtftkvLl2BJoghtBGkK4odlwYfLNgzcSbrU3Q2jqlTVRyg+gfjVVtPjIFAOLkzPOQ==@kvack.org
X-Gm-Message-State: AOJu0Yy7AWL7hGgHv83DBuQA8d1eiFzQBK9ymTrhVRBqjxL5Li9kbWGh
	C9SkFd1mLuSR0eTl0gN7nH6fVfa+f84sPHhXYYAp3A3197EU/C3Wh7cVxtqNOe3uedXCudRAlK4
	aVztKMxUOt290hn9VbRSOseVbV5SzCApaTbPOLMAxeyOTVZzfRHNz4g==
X-Gm-Gg: AfdE7cka9ZTu2EtX+xsLOZoA/BmGI9KV4cK/sg7HzvMUvpNX3Xx4G+70rrsK2QJ4JIP
	niKP4l7wmsopSwNk1LEE17dlfxWx8cDyYUKcG3fQ6G7B28LBvl3P2glEL8X3/x02sk9R0UfmbYK
	Rl+7gLmp2Z1IAaHvg9ekGdlD/qQ/obw6Zb/5TfwclBPXVxhbS0q1eaLhHF4keD4/Md1uO32LSMz
	JJQ1xpsTHaL5vMZXHYrNaSaFIW8d0zVPnJn8bwpuwNRpaghKTPG0slpRLEBVajD+szqwe6S5ZPU
	fTifupYhD6mFJsbQc3bOaMfcbyA7hOjhew4kCXri+BJpLMsUiePskSplVO+x+GrUcRss14z+qwf
	vYRWA6R+efhffwKONW2fCR4/tDW7eZZIpfVOS0UOPsA==
X-Received: by 2002:a17:902:f70c:b0:2c0:d91d:c3e8 with SMTP id d9443c01a7336-2c725ba5b74mr43431285ad.4.1781901367617;
        Fri, 19 Jun 2026 13:36:07 -0700 (PDT)
X-Received: by 2002:a17:902:f70c:b0:2c0:d91d:c3e8 with SMTP id d9443c01a7336-2c725ba5b74mr43431085ad.4.1781901367119;
        Fri, 19 Jun 2026 13:36:07 -0700 (PDT)
Received: from [192.168.0.8] ([49.205.250.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c743bfd9ddsm2903105ad.55.2026.06.19.13.36.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2026 13:36:06 -0700 (PDT)
Message-ID: <38a6af85-7691-446d-ac7f-5430347030da@oss.qualcomm.com>
Date: Sat, 20 Jun 2026 02:06:01 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: page_ext: validate section in for_each_page_ext
 iterator
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Luiz Capitulino <luizcap@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: kernel@oss.qualcomm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260617-page_ext-v1-1-37ad802b1a38@oss.qualcomm.com>
 <1dbebf73-6c46-44e1-ac6a-f5ffa9849b37@kernel.org>
 <698e5cdc-8f1d-4984-bb54-a4b7979b4dc8@redhat.com>
 <3149fcee-eded-49b0-baf4-ab69c27ff063@kernel.org>
Content-Language: en-US
From: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
In-Reply-To: <3149fcee-eded-49b0-baf4-ab69c27ff063@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=YN+vDxGx c=1 sm=1 tr=0 ts=6a35a838 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=BL6/p84Y3ifFzq3ZkNxHwA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=3o2e-M2zIh-Jw1OuFa8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: Zo5pBQ0YisQdTWI0LLPLR0yaL4kbw0cM
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE5MDE5NyBTYWx0ZWRfX9FKzfNsRATH4
 +UnjCjmvG/bGz6rVkU+WmALi4sZtyTQ6SOGJVtfXL4c+RA9hm/82CRhMges9jet2kXfxN+7ujPQ
 B62cClEwFxl82w3p+KqXWH0tWnq77SY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE5MDE5NyBTYWx0ZWRfX4/ZhtdFOsJ53
 dxtWX8aeIHIb0x4Etx7Bg0Gh3ty+4fH0NaMebAXhATWbN0dNkeDVfH4Sr0QcaP8q6+yfYUnbDwE
 US6hh/exlkKQ0iWQmmXoojkrrX6a5BXRStXlP5WUFlp8Wv7EawC+CN4SF0VUBqUxXQtCXU7w7Ks
 07kV2GddOvCd1bu9h5CYyQkZo+50sLujMDMDVWa74X4JahgLuJV13wx4/piE7aLrH/AKIkl6myx
 zhbW7yf3uKbundCY0A70ajCZF1o0jVMTFAcsLuuC4ZAuan9Rk44v/S/cBi1dFqm1eQ+qunB/muX
 FKVJiMkE9I1yzRX0QCIfWiwl1uIY+05398we33BrjZji06ZiOqN0p5xas2C6XVMIkNBQEGriDWC
 KZ8A4oXkM+fdqk/BwFwmg2gmj0NMqLNxpTrqudoUqwYRPfQ3LpJWNoMXrN+wgV+xIL6ppnUHMbq
 S+ypQ7A5by4M7Hj54/A==
X-Proofpoint-ORIG-GUID: Zo5pBQ0YisQdTWI0LLPLR0yaL4kbw0cM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_04,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1015 impostorscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606190197
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8E8098000A
X-Stat-Signature: jicczdrqsd4ugdkmouyrw9cj4jy84uab
X-Rspam-User: 
X-HE-Tag: 1781901369-214907
X-HE-Meta: U2FsdGVkX1/ZIRkwZFVklWXHOqN9EbEx2yqVuoS/A0jGpAhX4GI4CZulymv7ahk2vgHzUJE7enfWknTjDURTWNnfcnju9EGmvLak9FsIXsTCJaQH+GP51IL+tlmKP77wOolUK4myoPm59O2UYHohNjtQoRcOtTgEqilIUTc2h7pd+HW//mEsaXtXpqAQGfmc6y7yyZpiNdM7ZnBwR90LLCnpA3ivh1mCRBYdYgAbrFXaC+e0J1ryqavO4PQEaAX1yuF5Er63pKpfYvy/06WZakGmedVy6cFAVF5bX+fmuwwU6ttzr4dGCk+m+aaK0zWpWUoE47TGJkEwftvEfGkxW0VPv9UlB/DmMGqVKJ7bP0KdxROnRbaTr6pQwjcFreHhyBIYzpLnx0eHNPJMaSz8uzOBXsk80BNNknfV78ZFJtYFrqOprWB8SEcKCRXB5GVJ154DIAkuWqGUQxteZc08/1v0KuoEoB1S+2udOyCpXi9P12doIYygM9QSWsfTDRW8DyEydZpgDloLZ0DZgQupL6agIlRy6K94y2rsZYfzZoMFkg5kenfNxEAEML6Am0DBLtM0YldYahgMN4Q36BkQeToKJIjTNiOLL9Lk4pGA961gkntecZmGLxeGvYH/EKacEAGR5mcrEodmmp7wqYc7Di+x1UDfOjWB4mCyh3EkRhfmuV8gU3H/YS1Cnj69YFVgDKZgcG8azZYiG6IXYcFq/nR+xWVOZ8BW56jLfNonTxCtmdHvpzQ/Qgz5kpOz9CSqj8HRM6mDnCRd1bhv/9zHrEuS/P7+rR+JYvbDWy0W7E+jkvzawgagPuN5KkyuU+TYNwnoIU+r5TifIno9G9Pd9tmi+3uXrBNtydBhbd5+ZcN1a39Z+KElMfXAhSssRru6bqSF2NMvanHPePEnlCe21m2+S6r2HFRGvtuiWpq/FHRWfX0GnP34isNxmz0px1Fdcnf39Vx0rCwvxOWz5fW
 okpmEEXQ
 W5kmUI+j0E1RA73DUm5Dll1GTl+tsl+WJGN3ybdcGEfVVm92jPrgowU3kWOkzPJiKJYKG5beHjmAQ/tuWMXDARkT+Z9hKm27/cF40gyugSkm+/T/t6g75j0NcRY8ZyG4Dy4uLg+MiTVxFmjweur73lnD9USlWsEncjEG+aZFqvUldydawaJfgD04rTqkcgQwkyEP5mG0opEBvb9WPyrnYHyNL3CUY02w4r7Lnj771bvlx42LI0SmMGl9mchfU4MQp2wYy0YqDKLBrz9h7QmpJj2jBOsHlkDUFOEnrbpVtat9eWdMvljnoQPy2Ovlaf7O55qr2SIyYiPzymmL6avQb+oIScDq80FHPSm8PXybpb/5f2BRwyVRid4nmMlKcLQFWMO0Btv19QRnOI5zbVjjC7MPmTWZraVEzEZ+5DbFtGqvYQYAUAbNN50QHaujMNFlqEXeyb0Fm0x95Vuo9MyGpk/2FBF3i3TPKlicd2AoaM7KaGZ7DsRgZk+/TXinG64KK4aac29J+c+6Lkw/3a7k6420DHOlTLWevlnp9QSu3GvlNANA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/19/2026 1:30 PM, David Hildenbrand (Arm) wrote:
> On 6/19/26 04:38, Luiz Capitulino wrote:
>> On 2026-06-18 05:04, David Hildenbrand (Arm) wrote:
>>> On 6/17/26 17:09, Ketan wrote:
>>>> The page_ext iteration API do not validate if the PFN still
>>>> belongs to a valid section while advancing the iterator.
>>>>
>>>> When dynamically adding memory in hotplug path, it can lead
>>>> to a NULL pointer dereference during page_ext_lookup at the
>>>> boundary of the last valid section.
>>>>
>>>> [   14.555124][  T846] Call trace:
>>>> [   14.555125][  T846]  lookup_page_ext+0x6c/0x108 (P)
>>>> [   14.555127][  T846]  page_ext_lookup+0x30/0x3c
>>>> [   14.555129][  T846]   +0x11c/0x260
>>>> [   14.571201][  T846]  __free_pages_ok+0x5e8/0x8e0
>>>> [   14.571204][  T846]  __free_pages_core+0x78/0xf0
>>>> [   14.571206][  T846]  generic_online_page+0x14/0x24
>>>> [   14.597782][  T846]  online_pages+0x178/0x30c
>>>> [   14.597784][  T846]  memory_block_change_state+0x284/0x32c
>>>> [   14.597787][  T846]  memory_subsys_online+0x4c/0x64
>>>> [   14.597789][  T846]  device_online+0x88/0xb0
>>>> [   14.597791][  T846]  online_memory_block+0x30/0x40
>>>> [   14.597793][  T846]  walk_memory_blocks+0xac/0xe8
>>>> [   14.597794][  T846]  add_memory_resource+0x280/0x298
>>>> [   14.656161][  T846]  add_memory+0x60/0x98
>>>
>>> So, we do allocate the page_ext in memory_notify(MEM_GOING_ONLINE) -> ...
>>> page_ext_callback() -> online_page_ext().
>>>
>>> Which makes sure that all page_ext is actually allocated (for the full section).
>>>
>>> So when we later end up in generic_online_page(), the page_ext should be there
>>> and the memory section should be valid.
>>>
>>>
>>> How can online_pages(), which onlines memory part of present memory sections,
>>> online (free) memory that suddenly does not belong to a present memory section?
>>>
>>> Something doesn't make sense here.
>>
>> Ketan, would you please share the full OOPs message and maybe tell us
>> how you reproduce this issue?
> 
> Ah, I think I figured it out.
> 
> for_each_page_ext() does a "__page_ext = page_ext_iter_next(&__iter)" and the end.
> 
> That is the real problem and should be spelled out in the patch description.
> 
> Likely we should just handle that in the iterator, looking up page-ext for something
> that doesn't exist is weird.
> 
> 
>  From ce41607a4e4c1d872b6d3050da2e24d41a30d822 Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Fri, 19 Jun 2026 09:58:46 +0200
> Subject: [PATCH] tmp
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>   include/linux/page_ext.h | 16 +++++++++++-----
>   1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
> index 61e876e255e8..468c074582e1 100644
> --- a/include/linux/page_ext.h
> +++ b/include/linux/page_ext.h
> @@ -112,6 +112,7 @@ static inline struct page_ext *page_ext_next(struct page_ext *curr)
>   
>   struct page_ext_iter {
>   	unsigned long index;
> +	unsigned long pgcount;
>   	unsigned long start_pfn;
>   	struct page_ext *page_ext;
>   };
> @@ -120,15 +121,19 @@ struct page_ext_iter {
>    * page_ext_iter_begin() - Prepare for iterating through page extensions.
>    * @iter: page extension iterator.
>    * @pfn: PFN of the page we're interested in.
> + * @pgcount: number of page_ext entries to iterate
>    *
>    * Must be called with RCU read lock taken.
>    *
>    * Return: NULL if no page_ext exists for this page.
>    */
>   static inline struct page_ext *page_ext_iter_begin(struct page_ext_iter *iter,
> -						unsigned long pfn)
> +		unsigned long pfn, unsigned long pgcount)
>   {
> +	VM_WARN_ON_ONCE(!pgcount);
> +
>   	iter->index = 0;
> +	iter->pgcount = pgcount;
>   	iter->start_pfn = pfn;
>   	iter->page_ext = page_ext_lookup(pfn);
>   
> @@ -149,8 +154,9 @@ static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter)
>   
>   	if (WARN_ON_ONCE(!iter->page_ext))
>   		return NULL;
> +	if (++iter->index >= iter->pgcount)
> +		return NULL;
>   
> -	iter->index++;
>   	pfn = iter->start_pfn + iter->index;
>   
>   	if (page_ext_iter_next_fast_possible(pfn))
> @@ -183,9 +189,9 @@ static inline struct page_ext *page_ext_iter_get(const struct page_ext_iter *ite
>    * IMPORTANT: must be called with RCU read lock taken.
>    */
>   #define for_each_page_ext(__page, __pgcount, __page_ext, __iter) \
> -	for (__page_ext = page_ext_iter_begin(&__iter, page_to_pfn(__page));\
> -		__page_ext && __iter.index < __pgcount;          \
> -		__page_ext = page_ext_iter_next(&__iter))
> +	for (__page_ext = page_ext_iter_begin(&__iter, page_to_pfn(__page), __pgcount);\
> +	     __page_ext; \
> +	     __page_ext = page_ext_iter_next(&__iter))
>   
>   #else /* !CONFIG_PAGE_EXTENSION */
>   struct page_ext;

Sure David, your above understanding is correct.
Thankyou for the suggested alternative fix, fixing the iterator itself 
seems to be a better approach than having the section check in 
lookup_page_ext.

Thanks & Regards,
Ketan



