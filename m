Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EFD5CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 03:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8F38E0041; Sun, 16 Nov 2025 22:49:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9590F8E0002; Sun, 16 Nov 2025 22:49:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820E98E0041; Sun, 16 Nov 2025 22:49:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68BBA8E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 22:49:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28CACBD784
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 03:49:57 +0000 (UTC)
X-FDA: 84118720434.14.2470898
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9F10D180004
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 03:49:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XfdfRbK7;
	spf=pass (imf24.hostedemail.com: domain of maddy@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=maddy@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763351394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BzyEFLCvOslnU+HgxrytO8jDUMbNTsFcxxYyVtEM+WQ=;
	b=SMu/fXWDYCznOmW7BZ3ansRkA0X8JopDohEbKI6m5CWZ73wGxijPSPh1RWJVlnbuSCeOnt
	qWGgkyAdoRj+IisSLyZl05EgCeesjbTK4pSiKiqNDpH1KzoDXRCA18VBXUmRenVus1uLco
	BwMDh3SY/a5DGlwLjk0I/jFpYVorEWA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XfdfRbK7;
	spf=pass (imf24.hostedemail.com: domain of maddy@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=maddy@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763351394; a=rsa-sha256;
	cv=none;
	b=xOmaNkXKBO0tdWKsPSkD8fkNQfpyybHCsD76bgyw02s7Y50p7g84xaNjCsFcQB8HiaE+4+
	xh/b/m0DuO7AvHa767tFAQf1NmPrkq1tifhkDa5oJk5GK6MGKWsvm4VNJV8iQzZq36ANTU
	jyPQWOGCMCvGwR0nf+RybU22zdTr4xQ=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AG8DUtw011829;
	Mon, 17 Nov 2025 03:49:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=BzyEFL
	CvOslnU+HgxrytO8jDUMbNTsFcxxYyVtEM+WQ=; b=XfdfRbK7xYDcXCS/eBvekX
	W/lAOp/9U1TYyoIL9xWloZXjDuli6eN63LDblgMi/f2ikz/oDNT1qZSDpf63ij5G
	eu12Br6c+2fClpT6wAKlgw0OW+OJgMOVAWzwz/+RsBEn5XCBOULcgVjNhWKZfiFu
	fBUHbQEOysbKLukF62ZqD4+LTDuGWbqr1IOX5o8rfnXh3w512j4vZsRT7pzEbsOk
	9CsAL8CiZdb7qgSbi5EHGQRISz7XEQQlm49HXUtRT9PhPBhqHfz+o3z3yNUnD7/m
	78sxxb84YkmCF9IbpLEYMDJ0/AsR4imr1A0pK9ArVacEBjqRQBlB2psDzvUcLbKA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejk14c5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Nov 2025 03:49:35 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AH3k4iU012932;
	Mon, 17 Nov 2025 03:49:35 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejk14c5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Nov 2025 03:49:35 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AH2qnQu022354;
	Mon, 17 Nov 2025 03:49:34 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af4umktsf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Nov 2025 03:49:33 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AH3nWW928377704
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 03:49:32 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC88458055;
	Mon, 17 Nov 2025 03:49:32 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1ABA858043;
	Mon, 17 Nov 2025 03:49:26 +0000 (GMT)
Received: from [9.43.73.170] (unknown [9.43.73.170])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Nov 2025 03:49:25 +0000 (GMT)
Message-ID: <8092114e-f6f3-481a-966d-5b8289859a46@linux.ibm.com>
Date: Mon, 17 Nov 2025 09:19:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb
To: Christophe Leroy <christophe.leroy@csgroup.eu>,
        "David Hildenbrand (Red Hat)" <david@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Sourabh Jain <sourabhjain@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Donet Tom <donettom@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Nathan Chancellor <nathan@kernel.org>
References: <20251114214920.2550676-1-david@kernel.org>
 <fb95d369-dda3-47a9-b294-6d5038cee4d4@csgroup.eu>
Content-Language: en-US
From: Madhavan Srinivasan <maddy@linux.ibm.com>
In-Reply-To: <fb95d369-dda3-47a9-b294-6d5038cee4d4@csgroup.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=C/nkCAP+ c=1 sm=1 tr=0 ts=691a9b4f cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1UX6Do5GAAAA:8 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=iox4zFpeAAAA:8
 a=AcnmDf_a5lBLUkyUdPYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=Et2XPkok5AAZYJIKzHr1:22 a=HkZW87K1Qel5hWWM3VKY:22 a=WzC6qhA0u3u7Ye7llzcV:22
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: z5VHJOmMJZ2ZhZaYX3QE0J4csif6_SZW
X-Proofpoint-ORIG-GUID: iZ4VUeTY_jWI2ZMJ4qohkJiYvm7UWP2g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX9ubBWONMolPy
 DOPFovG8IHsjeFQ+Gm/DJmW7rvhqTPCT1A+sSN4U16YKxXu0FXsLMeR3Ent/XqlLZ3q4B6DFcrT
 cOz0Vv2VJoLK0cwVe4fOGIBDnc2DFUhVhuoSABg/6OXdb5ZIMDJ7EXM9Bgdh+92lBHXmNj8Vi+v
 Z/4shOgR/uF7BpY9lla3NT91HARklBHbJTAVKXtgxzAqW8sICx13AkGgaiCaZ0qe0TkT7tq4kTo
 JtEQ8IPWIseCrvYntoK5LbxEM9bNb4C73cIONVuNccxbkT6HBNgpq9b4ejK/jv/mEIcJuvBtUE8
 0aYwa/1bqXkBdwK5rFjIAL4+9dtSHgxIgW0xh4vsSr63Dd2OHP6NtjhQhdaChhtNCZlEd66zx8l
 eIwS7f5UkmxwnlW4E7WczcBuCMCiIg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_02,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 spamscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 clxscore=1011 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9F10D180004
X-Stat-Signature: im4e1g9bs5dutjyqyie9pjp7ai5683wm
X-Rspam-User: 
X-HE-Tag: 1763351394-116495
X-HE-Meta: U2FsdGVkX1/sE436iYLcbbC7/sBAhL8iYGNJFOz8sMcNjBPle7oRvV3a45hh5Sw0h1VX66NHsm69cx9Q45m/kYS63UUqTgCrKbIX7+rNx0Wy5NKpMjN/WF2jwa6LbpU4yNBGLK3crKpShSla/3twxHH8gvFNXOZBosGeeCx7boC5NcqwTF1xvd29ayKBM0ryYqfC7AdBLLTeJiHqArK3b1Lul/1ynPaklTgISAGyP+muv4lRxkab+Zwr737XkeMm8o4+2/hn0rMnduyeB/VFwQajHikcwKF6H1VHet984iKNP/ZGFwYikjjnYDV15sm1Ee9xCJgCsyW/DzMtq8Wox552Vo2NiuOR9Hl/ALeqU+37t+Jyd1j8fHiLiH4h/4HPdGQ/cP5CkTiSjMMKhgrAljMGOb9h6xae+MzkF0SbUu01k3NeMeq+A1DFJ4usyZONzJB0kjkeipS/1n50g9Y87VIXN9gMJcONK3TfVmApPNQj1pgkTspDph7a6kX3LkFqpyiZxbjq0k7m6stFDj6gZxqJyw6zlGHVzP7UJL1CbBtg7gA8LLdyyNTC684nCEyKugNc3O8Woz9ZVpCBOtKWL6gQU7hq2dUROOodJqlk8Kxp9luFkPxskZKTOD3xynBMx3+zKFdM40gUH25uS953yy/2QiygnOCiNTpiMn+5QNkauovTtzNHdlkjv3+OBlAiDik2WbgECp59Bbk475ePouaz6I9ZIFTGfJJQzohC2S0ZU7GgYOOKUciLHW9uk8zGedOCBbi3TVR3oilTnd5xIFHfR0djk7z1C8GH2BiYBPH5PNdeJpkwfQ9vpauVULUcy/qwoaRLDBhurGCrdFAF9xrpn+/Hm7fgjxbcqK+QQ2UkUIYNaReXS1BYf33Lq2WxxAH5lfyxKEDRGpSUSQt0JcUGaFawVkWQFrrKspHegltPgWaz/X/1omzD6HupcJu8NM4+Djq+pQTyHKlcNzH
 KMg+o42q
 ZfcCoJkNufy6P7KIib87lNpqwmLdRLiOH5ZfnAQGxvqOAzEdfWU+Z937EzEnjp0zlu0A+Z5XEEGliOd86i9Q4QgsS0w3xX4iNcVb+J2maF9ktonvuIkluybuwxjaURlmZ3+Y3H1N5HQvNiUGSDtiGBVO1wDtnZP80AJ7PE8DaXQhPn2LBotaZbSNSkz9fERuAlZWDmFr49/Xor2hgw7lidxx1N3svnap3eZZmlgg1wbegFps9wspIBbyvMWiehOwpMQKb55uAiPsUQ6xcBo4D+CqczcwUnN6sQiTfro6fm3JyGtejd1eF2uC4h4iXh8TcJ81OYlHpcDPVuT/a6clEGebH4JsR2D8NajaIrgLjRsqzrOubHzbidytPPWlanTSDy/liTSADxj38QAgQjmJ+oMMR2tr0wtJg/U8RlNHJ2lxoqR2VWEVVm1np+sc5QF3z8uSdEua2MO5gTBfa80tovB12C0F6ZUCwzNW+78LqXCdl9HdjsPV2ST2GBSEAMogaJoDghn0ComIRdPqJIkQTJap/cZCS2oLzTh/lmcOujQ5naadWAxb/IArizNmKQQRJdvoxalXhTLZ+QU7lNTgtUZC+UpcERNzfHpz+3SaTcbjn+pMJZVzL6UFHL+UVZp1B4iOXBEeC+XxQw/YDh0tQp8uVchMnpmRWByRo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/15/25 3:07 PM, Christophe Leroy wrote:
> 
> 
> Le 14/11/2025 à 22:49, David Hildenbrand (Red Hat) a écrit :
>> In the past, CONFIG_ARCH_HAS_GIGANTIC_PAGE indicated that we support
>> runtime allocation of gigantic hugetlb folios. In the meantime it evolved
>> into a generic way for the architecture to state that it supports
>> gigantic hugetlb folios.
>>
>> In commit fae7d834c43c ("mm: add __dump_folio()") we started using
>> CONFIG_ARCH_HAS_GIGANTIC_PAGE to decide MAX_FOLIO_ORDER: whether we could
>> have folios larger than what the buddy can handle. In the context of
>> that commit, we started using MAX_FOLIO_ORDER to detect page corruptions
>> when dumping tail pages of folios. Before that commit, we assumed that
>> we cannot have folios larger than the highest buddy order, which was
>> obviously wrong.
>>
>> In commit 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes
>> when registering hstate"), we used MAX_FOLIO_ORDER to detect
>> inconsistencies, and in fact, we found some now.
>>
>> Powerpc allows for configs that can allocate gigantic folio during boot
>> (not at runtime), that do not set CONFIG_ARCH_HAS_GIGANTIC_PAGE and can
>> exceed PUD_ORDER.
>>
>> To fix it, let's make powerpc select CONFIG_ARCH_HAS_GIGANTIC_PAGE with
>> hugetlb on powerpc, and increase the maximum folio size with hugetlb to 16
>> GiB on 64bit (possible on arm64 and powerpc) and 1 GiB on 32 bit (powerpc).
>> Note that on some powerpc configurations, whether we actually have gigantic
>> pages depends on the setting of CONFIG_ARCH_FORCE_MAX_ORDER, but there is
>> nothing really problematic about setting it unconditionally: we just try to
>> keep the value small so we can better detect problems in __dump_folio()
>> and inconsistencies around the expected largest folio in the system.
>>
>> Ideally, we'd have a better way to obtain the maximum hugetlb folio size
>> and detect ourselves whether we really end up with gigantic folios. Let's
>> defer bigger changes and fix the warnings first.
>>
>> While at it, handle gigantic DAX folios more clearly: DAX can only
>> end up creating gigantic folios with HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD.
>>
>> Add a new Kconfig option HAVE_GIGANTIC_FOLIOS to make both cases
>> clearer. In particular, worry about ARCH_HAS_GIGANTIC_PAGE only with
>> HUGETLB_PAGE.
>>
>> Note: with enabling CONFIG_ARCH_HAS_GIGANTIC_PAGE on powerpc, we will now
>> also allow for runtime allocations of folios in some more powerpc configs.
>> I don't think this is a problem, but if it is we could handle it through
>> __HAVE_ARCH_GIGANTIC_PAGE_RUNTIME_SUPPORTED.
> 
> Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> 
> Tested on powerpc 8xx with CONFIG_ARCH_FORCE_MAX_ORDER=8 instead of 9.
> It is now possible to add hugepages with the following command:
> 
> echo 4 > /sys/kernel/mm/hugepages/hugepages-8192kB/nr_hugepages
> 
> But only if CONFIG_CMA is set.
> 
> Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> 

Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>

Andrew,
can you please take this fix via mm tree

Maddy

>>
>> While __dump_page()/__dump_folio was also problematic (not handling dumping
>> of tail pages of such gigantic folios correctly), it doesn't seem
>> critical enough to mark it as a fix.
>>
>> Fixes: 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes when registering hstate")
>> Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
>> Closes: https://lore.kernel.org/r/3e043453-3f27-48ad-b987-cc39f523060a@csgroup.eu/
>> Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
>> Closes: https://lore.kernel.org/r/94377f5c-d4f0-4c0f-b0f6-5bf1cd7305b1@linux.ibm.com/
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
>> Cc: Donet Tom <donettom@linux.ibm.com>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Nicholas Piggin <npiggin@gmail.com>
>> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: Suren Baghdasaryan <surenb@google.com>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Nathan Chancellor <nathan@kernel.org>
>> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> ---
>>
>> v1 -> v2:
>> * Adjust patch description (typo, 16G vs 1G)
>> * Remove ARCH_HAS_GIGANTIC_PAGE from arch/powerpc/platforms/Kconfig.cputype
>> * Mention CONFIG_HAVE_GIGANTIC_FOLIOS in comment
>> * Use 1 GiB on 32bit to avoid unsigned-long capacity issues
>>
>> I yet have to boot-test this on 32bit powerpc. Something for Monday.
>>
>> ---
>>   arch/powerpc/Kconfig                   |  1 +
>>   arch/powerpc/platforms/Kconfig.cputype |  1 -
>>   include/linux/mm.h                     | 13 ++++++++++---
>>   mm/Kconfig                             |  7 +++++++
>>   4 files changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> index e24f4d88885ae..9537a61ebae02 100644
>> --- a/arch/powerpc/Kconfig
>> +++ b/arch/powerpc/Kconfig
>> @@ -137,6 +137,7 @@ config PPC
>>       select ARCH_HAS_DMA_OPS            if PPC64
>>       select ARCH_HAS_FORTIFY_SOURCE
>>       select ARCH_HAS_GCOV_PROFILE_ALL
>> +    select ARCH_HAS_GIGANTIC_PAGE        if ARCH_SUPPORTS_HUGETLBFS
>>       select ARCH_HAS_KCOV
>>       select ARCH_HAS_KERNEL_FPU_SUPPORT    if PPC64 && PPC_FPU
>>       select ARCH_HAS_MEMBARRIER_CALLBACKS
>> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
>> index 7b527d18aa5ee..4c321a8ea8965 100644
>> --- a/arch/powerpc/platforms/Kconfig.cputype
>> +++ b/arch/powerpc/platforms/Kconfig.cputype
>> @@ -423,7 +423,6 @@ config PPC_64S_HASH_MMU
>>   config PPC_RADIX_MMU
>>       bool "Radix MMU Support"
>>       depends on PPC_BOOK3S_64
>> -    select ARCH_HAS_GIGANTIC_PAGE
>>       default y
>>       help
>>         Enable support for the Power ISA 3.0 Radix style MMU. Currently this
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index d16b33bacc32b..7c79b3369b82c 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -2074,7 +2074,7 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
>>       return folio_large_nr_pages(folio);
>>   }
>>   -#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
>> +#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
>>   /*
>>    * We don't expect any folios that exceed buddy sizes (and consequently
>>    * memory sections).
>> @@ -2087,10 +2087,17 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
>>    * pages are guaranteed to be contiguous.
>>    */
>>   #define MAX_FOLIO_ORDER        PFN_SECTION_SHIFT
>> -#else
>> +#elif defined(CONFIG_HUGETLB_PAGE)
>>   /*
>>    * There is no real limit on the folio size. We limit them to the maximum we
>> - * currently expect (e.g., hugetlb, dax).
>> + * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
>> + * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
>> + */
>> +#define MAX_FOLIO_ORDER        get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
>> +#else
>> +/*
>> + * Without hugetlb, gigantic folios that are bigger than a single PUD are
>> + * currently impossible.
>>    */
>>   #define MAX_FOLIO_ORDER        PUD_ORDER
>>   #endif
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index 0e26f4fc8717b..ca3f146bc7053 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -908,6 +908,13 @@ config PAGE_MAPCOUNT
>>   config PGTABLE_HAS_HUGE_LEAVES
>>       def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
>>   +#
>> +# We can end up creating gigantic folio.
>> +#
>> +config HAVE_GIGANTIC_FOLIOS
>> +    def_bool (HUGETLB_PAGE && ARCH_HAS_GIGANTIC_PAGE) || \
>> +         (ZONE_DEVICE && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
>> +
>>   # TODO: Allow to be enabled without THP
>>   config ARCH_SUPPORTS_HUGE_PFNMAP
>>       def_bool n
>>
>> base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
> 


