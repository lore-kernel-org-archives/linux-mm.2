Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20629CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256616B00B6; Mon, 11 May 2026 10:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2069A6B00CF; Mon, 11 May 2026 10:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11CFD6B00DA; Mon, 11 May 2026 10:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 000BB6B00B6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:22:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5A6D1C0051
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:22:31 +0000 (UTC)
X-FDA: 84755354502.28.0E16816
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf10.hostedemail.com (Postfix) with ESMTP id C595CC0004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:22:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PZ7AFLYQ;
	spf=pass (imf10.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778509349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EBr6Fvx4EhFl+fiKVDbOrGkrFPYrVTn8Rw8J0IyiXD4=;
	b=1ctXXvKVCQfh1X4UK2OOzuTwBB/57kzVrcrd2Y61Oo8Q446zdVhZ9ZxTH7gN2BgiVqD/h4
	auBRzhPoKsmgLpr6LcD9I7/hAQSP00Dqd3zCglXuraRTl4rL5C0Fha7xuy/7V5hFOIBWXZ
	1V2+fp2A16YsamBLOT8U0TbcD2WUdvs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PZ7AFLYQ;
	spf=pass (imf10.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778509349; a=rsa-sha256;
	cv=none;
	b=FdSg2wl8E1UvkxKCRtVAecDNt937BEEPe3P97CjUpmcE7FOE7MV3vFkOKzzY9DSbWEJ/8p
	gRWqvIEv54KVqx8GDmxOg2KuDEbbOOhmV7z/nic+NsVby9rmla1I1i21VzSwE5rF4Vcqzk
	mMrxgd+N0Clr7fwkVsX5oJ11/4jPn+s=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64BA7tVh2635669;
	Mon, 11 May 2026 14:22:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=EBr6Fvx4EhFl+fiKVDbOrGkrFPYrVT
	n8Rw8J0IyiXD4=; b=PZ7AFLYQWQh0DARv50iTmhHp5zS/Ejizy+ypwzeFIZouS+
	B35jEKPkz+I44ugqqDSrk8uynJ7EHmDfCwwk1qyUL168wMn90+7Jy5+au6gRMXUO
	sohcL6fxqf+EZVCwwBOvb+sWp7MXoR+Tmhu6yI7HRbKbUXd0OiJl+h6cVw0fcv5g
	kwq9vh8vJEUQE30DRbwn4toirDsVN+vRKyC0JGmbMgcWv6pJuPYzeNVul71s8p3I
	LVZxytsy51FnmX0GF48ZqK1TplFzATu/pDeLDl+oy4MskbU6Ndernf421G9yVjeO
	GEqUMuWEB/2Cg9oKDU0VrIyx80tksyXLv8iyOVhQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e1vn4rnt1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 May 2026 14:22:04 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64BE9MBW024960;
	Mon, 11 May 2026 14:22:03 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e2f8q5rb5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 May 2026 14:22:03 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64BEM0RU56885546
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 May 2026 14:22:00 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 21C8320043;
	Mon, 11 May 2026 14:22:00 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CDF7420040;
	Mon, 11 May 2026 14:21:58 +0000 (GMT)
Received: from osiris (unknown [9.111.59.149])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 11 May 2026 14:21:58 +0000 (GMT)
Date: Mon, 11 May 2026 16:21:57 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Andreas Larsson <andreas@gaisler.com>, Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-s390@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 7/8] s390/mm: use free_reserved_page() in
 vmem_free_pages()
Message-ID: <20260511142157.9589E90-hca@linux.ibm.com>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-7-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-7-3fb0be6fc688@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=BM+DalQG c=1 sm=1 tr=0 ts=6a01e60d cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=boL7ADR7qhV1eUdEaRQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTExMDE1NiBTYWx0ZWRfX9eMnKqaesw6+
 dWs2XKM2Coq1K2t6vtXUjCW/Ls+NZ6Ocg3gIMXDYbWqvM6Y0/kNGHNfKyKSDy/e3V4I52+nyQQi
 T3hsKpBs0j02l46KbBJkcPht0W/0kHwHvm4nqdzNNiCiM5wHjaB84yj9A2qQZyKXC2oxOvSlswb
 wSoxhLpnddu+8ySgcU2uuvafRjZowWq84v9GgZQdQ0Es9DC4wReHZ/1ONwt0vlnq3MHc1YWEKrm
 5ao/IHMrjvsa9qqgcduF5p7V0yZqz3m6sLsOm4Avt688GEJB+mepfPl6WURzMeIkxi0WMs+IRa+
 PoqPydwHWthihJUCXymL3VfYwixUhRzXJrrFraRWYVTmgFokNaqu3am6bSfwEB/qC3GP/Jjdnz7
 JPN7qTOE+na8g2XkmlyZr6FYNBN9/lA3gSZ/YrLsrDG2hmEeOI0xukvAfJ+SlzbPzcNbqa0PIua
 kpfzIVDuYDfFYEnQKVA==
X-Proofpoint-GUID: yUQzDOeY4Z3eWv4ViXPYc2-41M_eHNnR
X-Proofpoint-ORIG-GUID: HMCowyjGDOqPNKrRS-Lt9uxif4ohm-SX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_04,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 suspectscore=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605110156
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C595CC0004
X-Rspam-User: 
X-Stat-Signature: za5k8yxizacdza5my4p9etwtjyg4k31h
X-HE-Tag: 1778509348-145355
X-HE-Meta: U2FsdGVkX1+RwBduEHHuLnyZOCF2eY2UqG90GhI37YJ7HlW/fk3j/OoGIoKjtAOGOzW0n96Wt345yfJoWJ94DV/tLDcUIKa+tQJsJPBl2Pu8DCUmA9gxEcsY27igEBmhOV6LB7bH2XjY3VSOCjHnK/DWdoQjKcLz37wQ7zrQZWflUBawu4ok+/Xl+Sx3SRh9SKnuHnpLSfj5JGZZXcfdVJ29vD3j2c4ZkxFDglEDUsirAWUVBa51fUUb3neLSo+uxZbvDw2Nj8irf8Z6jem6TbqhIng01Et1lUpp1bY7HG314ENLgfno/Ae2ffKCjNMFXf3tyj3PD64f9ygHgwEqXHNSgUenGXol0lWBrSO1WtaaIIQxusHOgSMku9Jlxu8N3yRvGkt3nyQXlcQSJRvrfVV4dX8cVZy/opJuEIy3nJS47HKLIR0LiDikyJcaAIYVsO/a8wn6hpk/+IuYz+aVs/PMXoXKzJUNNuEDSHJO1bOFz1PWhejSV+W2OxauZmHDO2iAk/A/DQQJOq16B3v0BeRn7bRQbDQsqec/52J3hujpqTJkJVraAT3VlMzS6vwf4/pYjOUhOIeJOLOJ6vn2JznzbzqJn4IuHro+SRsDZABwA4exsH4M8SgYqwHEGP9kks4DBt5IMMpWSbuZPWB/ceQO39/6OiHBt7AwoHMWl7+uKWM9R92SihqZMn8ynD/ZHpVyYLF7ztZ+X+8j8x6IV1jD82jDjTOHLzX2gw5Hk/N4Q+1H+cCSMSdWaxbRB6sXA1zjOg88RMHtSPZjfe//jGk/VrsHAzVWXhgTDSv5jG1SmycEjTmT0FOQ0Du4RNE1KlOMtEx5cY4hl6NQAZJM7mcfbLE6U+hN1mokH/Gq9arD3+kQLM3qUuZAjS3Qu6E6Li1TA7aJwtk3o/Ea5ayuqKH8I6fha5l4auJ9IAy8mBF5unXgMfY+yb4hE5QJJtqfuEx9nXsu5ftwcx2QjWv
 rjDHljLQ
 2pXF2KuNQu4v1QgEZua2T4I84XU9sGzCQJXWx2YPoIJcRktGowBOJ7Z2x4DObVqn+FEJ/wxci5sBTtz7lzCS0c+W1UNXFn7VUVQ36cnG6M4mDRxe/rgIWyufEm+gKKo6c3ZVWfVmQVkhQSC/u0qQAZDSNbR8cx9hTLukZ+PSOEpSKc+cdHKMTrjag/ecb1O25gzdysu9gRLidRKMZgtPXaSwKm1mlPBXnLs0Fg8b8Jv8T6b8vN1Htk1LXhFT90H8fvO7Nm+NBTOSqlZpPziUInUaglpQjflxU/L5Cv0V9RA37zEukiytsgewDGhBmkRW1QiSVwzaRq7LTmLsXNdWzHatSmCMC/UKYFqrbai1X1z9raCFikIL5bBh1PA44VsLH6gSaHgzmwcC/LunAtVkHj71uQQtsmJENYLBRUCdSZjutYqY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:05:35PM +0200, David Hildenbrand (Arm) wrote:
> We never select CONFIG_HAVE_BOOTMEM_INFO_NODE on s390. Therefore,
> free_bootmem_page() nowadays always translates to free_reserved_page().
> 
> Let's use free_reserved_page() to replace the free_bootmem_page() loop.
> We can stop including bootmem_info.h.
> 
> Likely, vmemmap freeing code could be factored out into the core in the
> future.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  arch/s390/mm/vmem.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
> index eeadff45e0e1..d8b2a60e0c33 100644
> --- a/arch/s390/mm/vmem.c
> +++ b/arch/s390/mm/vmem.c
> @@ -4,7 +4,6 @@
>   */
>  
>  #include <linux/memory_hotplug.h>
> -#include <linux/bootmem_info.h>
>  #include <linux/cpufeature.h>
>  #include <linux/memblock.h>
>  #include <linux/pfn.h>
> @@ -51,7 +50,7 @@ static void vmem_free_pages(unsigned long addr, int order, struct vmem_altmap *a
>  	if (PageReserved(page)) {
>  		/* allocated from memblock */
>  		while (nr_pages--)
> -			free_bootmem_page(page++);
> +			free_reserved_page(page++);

What about the implicit call of kmemleak_free_part_phys() which gets
removed with this?

