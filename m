Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A98D606A88E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=WQ/tsRED
Received: by kanga.kvack.org (Postfix)
	id C46DA6B05D6; Thu, 12 Nov 2026 07:30:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1EA96B05D7; Thu, 12 Nov 2026 07:30:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34A76B05D8; Thu, 12 Nov 2026 07:30:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91F006B05D6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:30:01 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F558C0582
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:30:00 +0000 (UTC)
X-FDA: 85426398960.11.FAE2F17
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id 48612C0003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:29:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="WQ/tsRED";
	spf=pass (imf22.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794486598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cj3Ij+gD3pAhnaPzvGDvSChqThcBsoLwEviqlfPVQtk=;
	b=v8GbOX6uDq/WlN8M3lVx0f2rBj4yOEiHE1Mco6+OiUP4oIVn7TOVMfsWu4yNUIwTQlFiA/
	DT08z8xzDwuqLDYazUjh17JDm9xx2VlbpF+MGjn5uZDNy+ffH/zRYMyzOfaCOV8c4fyHor
	nb6pxK3wg2prdYz7WUG/Ge1UtpNpjtE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794486598;
	b=Ge//j77PXblA8/lndk4Omy6SZK8mfZkYaU9kMJbdE2YoowAPnvXBuINiVNYFvtWIAKLm79
	gO1avRr4YzE9G7Z9zO92gEgVkdahwgRGJ9lf8fokcl7gfGS6du2JaTJ5VUocmGZ0bT9Jzy
	XSf6Ub/agluKHVq0gqARJqJwVdzTJsc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="WQ/tsRED";
	spf=pass (imf22.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC2igij2858143;
	Thu, 12 Nov 2026 12:29:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Cj3Ij+gD3pAhnaPzvGDvSChqThcBso
	LwEviqlfPVQtk=; b=WQ/tsREDtIPV7Lbql/CUKVbe0H0Wpm21xiFmBEk3xd8YeB
	5QJgQUR1sI2FDzUZQwPi4gaIb2yQqaCPmrnT7n8YjRmiQ/ArV4h9i7227YIebuGi
	+pKgP/ErqGaKG0dbwzqEZXZp3PQ0Y7FO9iJrXZYJVwE6Pt4mLM4+aZFUguZG54y5
	HB8pe5yjUjpTd2EDIMEJjxWbPdrWC25StgpjZ84SOcC3R9SYDbDrONkRqKrMOsHx
	EH2M+xlVT9/wuZ3+gfnwKltoG5nloS7CKbuzyqWIWHsX3VXjE4/h5uwoqdN6HKAw
	T6gW1JLTfZgvOKfQHads3ncoOb4SAobDbww+UJIg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hsumv65sf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 12:29:37 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACCBKwl669861;
	Thu, 12 Nov 2026 12:29:37 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hwd8581d5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 12:29:36 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ACCTXQB13894124
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Nov 2026 12:29:33 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 084932004B;
	Thu, 12 Nov 2026 12:29:33 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF9D520040;
	Thu, 12 Nov 2026 12:29:31 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.69.86])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 12 Nov 2026 12:29:31 +0000 (GMT)
Date: Thu, 12 Nov 2026 13:29:30 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, Alex Shi <alexs@kernel.org>,
        Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Helen Koike <helen.fornazier@gmail.com>,
        Vignesh Raman <vignesh.raman@collabora.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Nhat Pham <nphamcs@gmail.com>
Subject: Re: [PATCH v3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
Message-ID: <d812b71d-b7ec-496f-9404-add2282105a6-agordeev@linux.ibm.com>
References: <20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA0OCBTYWx0ZWRfX61PWThN5bLBB
 QHvsaKAzKaSemekTkz04TfXUL5f11+UWnI8aQzwwM2Nnf8f2b7WkCrqgqP99j3hHQ0OEU+bZSg0
 mPsk/wyxJKoRGOu6mxbHXMCSMDREZh4=
X-Authority-Analysis: v=2.4 cv=GISdgeNK c=1 sm=1 tr=0 ts=6af5b132 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=pGLkceISAAAA:8
 a=itkboQNlIvS3CmqEExoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: MXa2Sk-_6Sw_bmg7o3uoEatjrHj-1pvN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA0OCBTYWx0ZWRfX6vLbARu7BivS
 zj1FORlMjbdRdBzJM9SUIYx06lNa0IOX3yDAVN8Qmu1OkDg7x9LTz4aSot0L08MANolZWays6Br
 KfJax0kAp4eIspAjOU2dHV95hkEP8oUgJf/p3Y/+1H96m0UWu7gHG0igGl50TLiaMF446dFqdHU
 tWer/PU9hA/4xF5IlzjfwQZnADKOIY1MgZYC9MoIq8ZnC1AKpuL89aXrs/xmOPGcFCn4maGw8pF
 59AA0w4KbGhWVDJHkgeCCAuDbqm+IoLUiZGCK8oMWE2rPGwduiiFLfFwDRIMpuwSrpT7hM0eA9x
 rba29btnR6kpUccVJ4iGr3RYCQSdwT6tvRs9BBTgPV4NUZ+suZ6+EhM3RpDmH/jYo9eT6yeEdQi
 17pzmOEjns87LdD3DNKI8MOPulpo/6xzEc9zWbvzUAMnoJ00RwHK/7OkcAgMg501+snBSAlFezd
 PJdds51219o+oqVUmxw==
X-Proofpoint-ORIG-GUID: MqkU3Q4i0ftX4RD9tfhyu81C8hZy5Ha2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 impostorscore=0 clxscore=1011 adultscore=0
 priorityscore=1501 phishscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120048
X-Stat-Signature: ae6zu8c4jzic55actjstwtiphnhxyxtg
X-Rspamd-Queue-Id: 48612C0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794486598-372158
X-HE-Meta: U2FsdGVkX1+7UZWzzTCJxCDeW9XCdKd/+r6rvWJA2MwBKvul1yZ/jpIUpwsWaoQ2h3xK5OM9hVGFY3rJEhQnTpaE5yzUU1TNmrH4yUUssKQZ1C2JIEBrVC419TVc17I2+5eX4nOHNxui4KHH5G69A9EzUtJHZC94B5AGVhoH6Gv9c8zUSMbSUnZFZ7oJIzVO/IQDQFZfzEODJ9tF/6I+LzuunoCfPKoVXyhahxQUfkd/jr2YO5DZnc8t/vHqkUyeRG/oYTBwJatQ1Zug39XT8YRL9e+W5E8aETIGZVDG4/7ZgXgEdOoKnZkNRNwZqgazP2qvKGqAMoDbxF3LkZvK5O0LKoUrVeTxozTpBmRzDJTNOiGtP8LxKQrUBcHGvTa4nm4zeisLF7m5+RB4BE+1IYnqhFN/rvL+pfkmq5MXX4irbMykjTOpp5sMXwyQU/7UMFRy1m4RZo1/FDwl4hfS2xzdusVjLU7QqzO9fBohkeCyviVMGRi63nMwf2GgrmDKy6g4vwoLeABWJM9yZ9IsW/6erYblH4+Gw3zVOOGxNX8jp18UI8bOlcv9X20tIsf9DP3G8xzwU4+B7UycGDoRlXMkn3UE/cezKOwKA+DoGtPSRrt5djJbhCTMLnaqAGqspL6NlI/ti/rhZfHUzrBDw7F8GYHLWi9vvT57V9xt4NuO/PPWOygYpFdfmL8tVF8tixNF5C8IIjKmje078SIvw6WjhdftxRJHo1EStk08rTzW3aYUG2Pf2sSXX2z9yBNISrne2VP4e87oX3skkaBi5j9awsbS9qmUsDWUai2sSI8/eV3J9nAEsmT9em9sJS2KflZGUj1Wft63yAzoc+yS4Zeeen3Ja3XzI2BCNfTFVcpv4lLMDbbH7dklgc1P56lWR66IaHcWPopP1BdAvIwXXGdX0itvBVHIVNqEckkEV1WNJXh2qDh6sVOre8FQzpcV4MAnNMe7TuKE/TQbmxm
 6GLi98u/
 UAfcpwk8ijihUUyQTc9SzwdPTodEg959kRM1fGGLFAeqViVqXp5IF3ygXhtOKdQOQpA/U9+0BJD4kwv86RQV3qdBtQQqO1ygJ3IikkPeimcs3orttdRDg9wMs6YXp1xayZabvkkIoQgNJkj7bAZ8XokGVr+0cMeLD8FOcujWgAMkhzNGatZhydPZNFn/eHkIYMChJYS8X0xphDv8VZKHc0zh1zgRdmqOQYaJbe82XrOANk2hBfgnig1HVuCf0RwxnGUa3ErhlhQ0eD5zafjtCmUoV8Hj3ZfgLV4NS+xKuHCqey8JhdYuUgB+ttdK/E17lHh6pIhjmve08y36bD/Jr6fDknEEyXEINK7YknWxj88R7zKt4lWIRV/nC5VmteebuXxYcbG0CwwPw9gT3gKulNkdQgn6IMpF9DP/tyhCPcByR/ZPRNXof89Q/A865Q8ZEmRJM1nYiQEO87SQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 08:41:26PM +0800, Xueyuan Chen wrote:
> CONFIG_ZSMALLOC_STAT only controls the debugfs interface. The class
> counters are updated regardless of this option.
> 
> Remove the CONFIG_ZSMALLOC_STAT guards and rely on the debugfs API
> stubs when CONFIG_DEBUG_FS=n. Skip statistics setup silently when
> debugfs is unavailable.
> 
> Remove the Kconfig entry and replace the existing CONFIG_ZSMALLOC_STAT
> settings with CONFIG_DEBUG_FS=y. Update the English and Chinese
> documentation to match, and clarify the pool name in the debugfs path.
> 
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
...
>  arch/s390/configs/debug_defconfig                |  2 +-
>  arch/s390/configs/defconfig                      |  2 +-
...
> diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
> index d44674b63715..83193ef8efb9 100644
> --- a/arch/s390/configs/debug_defconfig
> +++ b/arch/s390/configs/debug_defconfig
> @@ -100,7 +100,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
>  CONFIG_IOSCHED_BFQ=y
>  CONFIG_BINFMT_MISC=m
>  CONFIG_ZSWAP=y
> -CONFIG_ZSMALLOC_STAT=y
> +CONFIG_DEBUG_FS=y
>  CONFIG_SLAB_BUCKETS=y
>  CONFIG_SLUB_STATS=y
>  # CONFIG_COMPAT_BRK is not set
> diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
> index e00e252d4694..694a309377d5 100644
> --- a/arch/s390/configs/defconfig
> +++ b/arch/s390/configs/defconfig
> @@ -94,7 +94,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
>  CONFIG_IOSCHED_BFQ=y
>  CONFIG_BINFMT_MISC=m
>  CONFIG_ZSWAP=y
> -CONFIG_ZSMALLOC_STAT=y
> +CONFIG_DEBUG_FS=y
>  CONFIG_SLAB_BUCKETS=y
>  # CONFIG_COMPAT_BRK is not set
>  CONFIG_MEMORY_HOTPLUG=y

So DEBUG_FS is selected unconditionally? Please, drop this for s390.

> --  
> Best regards,
> Xueyuan

Thanks!

