Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5984FC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64B306B0088; Wed, 23 Sep 2026 05:16:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D5296B0093; Wed, 23 Sep 2026 05:16:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F906B0095; Wed, 23 Sep 2026 05:16:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2BD6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:16:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99D6BA67DF
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:16:44 +0000 (UTC)
X-FDA: 85244471928.10.87AB2DB
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf26.hostedemail.com (Postfix) with ESMTP id 42444140002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:16:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sKVNfad8;
	spf=pass (imf26.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790155002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ekAifFySxuN7eTBzJbvVL4QqInmz0syU7wQxG74F/3w=;
	b=5Y/FR4aNUVa1QB2Ts6fYcCLOJYSSgetSz9OqKtsCH55+YhoIsvOZd2DXJMbPs+9wgoBVyx
	SzMl5Ak1YpS5gtRw5Z/Vo68WCk0B4kFZm+0dze1tFbH8223OhxQF2ziRXGLepl4+DleQGl
	ZuilBrTzMFfnEPFzsZYzrlPGaJf9mv4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sKVNfad8;
	spf=pass (imf26.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790155002;
	b=DgBJbQRvBh5OSPv+Tvt2Gr7Jow1TB3TrH5paqcO4OChdbHeFu8lsF+ykgfZD6joQQOL57w
	famsU9UTF83YfZVeSKUj6ZhQrQPicl7zNs5aWt525Zxdur7LUWVUUDBWhAudO2jXrDmdDQ
	BbFTXG5bbuEbzgC6FMlPhF7ezDdP67s=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68N8aB0h2742990;
	Wed, 23 Sep 2026 09:16:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ekAifFySxuN7eTBzJbvVL4QqInmz0s
	yU7wQxG74F/3w=; b=sKVNfad8rEslSZrLrh5R37uv0PuoIHeATBYkluxBok5jZg
	1fqO7f3IHFqBnPBre42UYWa3F23gM3TD0DzBgqPeT2pjTMKUepKaTFHVEPzJxIH3
	dG2Wsu4vHMfKf890kDOZmbX2HjiOQbj9WDL0oHCgKyGOsNH7IpJY/FvR2+0YaLdb
	eR61QbqbEjMfOhEWfadFuUJI69oSBBGjrn4aAKsaL/8k5a+CL0BL3hcBMzuXZZl7
	V/dIhLNZ+Qkof0SL1jX28sr3xWBcLunCvQl7s6D8GuJvOtNc8m20EBs5Pq7MZUvG
	C5IDdvFu5vOr9m9ZIumj1yHayB8q4rjIWxoa+83Q==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske1hvmv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 23 Sep 2026 09:16:35 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68N93E5K007936;
	Wed, 23 Sep 2026 09:16:35 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gvbt2r1mp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Sep 2026 09:16:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68N9GVXC53281066
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Sep 2026 09:16:31 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 363BA2004D;
	Wed, 23 Sep 2026 09:16:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B9A4A20040;
	Wed, 23 Sep 2026 09:16:30 +0000 (GMT)
Received: from osiris (unknown [9.111.16.152])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 23 Sep 2026 09:16:30 +0000 (GMT)
Date: Wed, 23 Sep 2026 11:16:29 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
        Helge Deller <deller@gmx.de>, loongarch@lists.linux.dev,
        linux-s390@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] s390/mm: Drop all pxdp_get()
Message-ID: <20260923091629.9636A36-hca@linux.ibm.com>
References: <20260923043226.331880-1-anshuman.khandual@arm.com>
 <20260923043226.331880-2-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923043226.331880-2-anshuman.khandual@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 7ujkQ9wUog4GYrmFlvdAZP2vQuJfWomt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDAzNSBTYWx0ZWRfX9MP1i2W+uPcB
 o+ivUKSV+Vq2/LqSXcZiildQAzWpo/xH7L8SDuJymcGFUEJURDgBMWcsqvm50UrlEl8aBrzwIZr
 v+tTtEbgZSSwEAqJwZzGLnOHeOP04QSLBGqKJIVDyDQmlkCSN0IjiBEtR3LAgbjwutwnWqM8Sh7
 AVydrT0cgXPCqQaZRJBi3YsmDwCswUDk4yj+hLG9fRqHXKXxpCCdMN06ZlIp643TfmOtztojaRa
 1Hf5rOjSblJLa+Fh5NRBUFqmPA19S6HBm5sbg+aUNyNmynogRPf1qp4h78gwIJkjCDytuNajM0U
 GpGqPLOyRqIJ3IbD4mPyctIy6IH2TsRQhFEWG574sDFVb5BcmmI1izfSEsWXlPBvq7EEkhf0KwJ
 9zCUXKFv5vvus1Z56h9QXh1UKxMpwRPTQ081ST2zZ55oV69MnjrcAPFs2YvINaM5Fi/NwKhgjEl
 fTfEHReniI367SGA0PA==
X-Authority-Analysis: v=2.4 cv=O/KsLx9W c=1 sm=1 tr=0 ts=6ab398f4 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=37rDS-QxAAAA:8 a=7CQSdrXTAAAA:8 a=GzQYO_hYbK6N7GQroPMA:9
 a=CjuIK1q_8ugA:10 a=k1Nq6YrhK2t884LQW06G:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDAzNSBTYWx0ZWRfXyqkcrymsVWtu
 8q6pxW+R1W8Q1UO2CI5cudU/0w2O8S1lkTi3BK5WkiHdPGGqhzrRUsZiDSdtTfFfMrnCIZM3KhI
 QAOCQ9xbS3xW6599hKAqSriprZP5UWk=
X-Proofpoint-GUID: QYGjgB7lKv7pPX4KPcS6XTysovFMVxZD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230035
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 42444140002
X-Stat-Signature: hpsspyfrq6gh4ahqrn1wjwybr5fqyq45
X-HE-Tag: 1790155002-465183
X-HE-Meta: U2FsdGVkX19ydid6v+Q8wIJxq8faDcpvjvw8c1cyrplO7nJ4Xyg9eN21hNK3wmF0cN/quW6xVlBkwH2eTO5nvsrAUWQ1P5sXpIBDY0vqxWACIfPXnYtQLp55BuwdWjr2zbVJIY+XF7RXvM/up73mlek/i1nb4e/Z62R34LUyIuNqGru06J4AIsHUDpInDbwnxk8W2bgcMXQIzk53cONEuc0y4Wff62s/mMbIpq8YR+2LDlr2Vviujs7/iqa3etyU8ft6F0szDt/nBS3uwzyuA9FSMkxYF3QUFJP6TZxR4nAZ7gIfcrVvB+QaigXo0CUkYLLZKLLdj5GxCgEmu3dx6eotZpXUEgPbltib3+AYGz0xAzlVCKvg8/6NFq0UmVknrF93ydQXuje5pHFYgYLR1gFb7OJA/c+6oXfOPrnkPuC65VQpAK8sSJPGiBbOwHTVes0G6fVeVX29Mn0SEcGyJIZ44lCVIcJ7Osk8x8KZ8Og+NmFOvdYbLAioAzmOiaq33UZi0zAteF9Z9yKd8+R1dG8S7TNz/Xyl7ib4fqBi5UcqtOxWk9zlzOQ5Vy4cqE0wS4m31HhpjKZXRLLlx4GRj1VMyXpkONBaXEbP2Su2lqa2gmgrHZkHyAq4TJmpaLABfCLTrL6YjICeqAEdlc2W87+wMIB/G/twyFJx7+AwC3VzJVK+xchO4fsd8jTGtDS2FhyGsnpxmlv7qCZoe1vwGpuw1sRBh57QYRH2gGlCDHxt+/oTpshwRY4iz80Uluw4mmylgFaCf15nFuUiomafl+X9sENQHHktqAGMeJXthUzKgf/d/fKAX9iZmGIUp4UIL5NvFbHLcSmo0RfscAzp8ppe6l92IaDZYbQSD6uPSK6wh+X7sawEf84Dv0+63662D1oJP4VhghwA9yfrA0ce9oWzoZcJYHah9hN/ci4QbGWYvNWGwyt6RO9j0blpSCzw9qsaCotfTR9C/x+L/X/
 th8yMudi
 WtYk/xuApDl8LSUWaNteQ4DY9bFPNipe26o6WJ78tGrC+F+F8Xs6WX15ahQ/zNtcdOKv5SEMPK30gV/0ApKrKd3gl0dCvSzbxFZuUuj6OUUpP0JiVMyvGNQiRg/1FHkcjcFmxHb4lmOoQO/w4Gd2+VeXUzG67gI7O2Hk7hTrhc7aejRZ6aFsBXIpLN/Eh4KPpsg7E1ux6T+K3XWSU4G4GVTE/+VBfIM8ZqWpJDa0Ha/19s84wcfvTo4O9+F1Mqyv+gFMRcNVOIhKMeILiYQVCAdNFM+nri7TN+223xklG2gnne6inIwvmIEj0a9Eu3p9xAhA907FJibeuVyab9U4hWCb5Howa43PDkLP8zhkHJHyBp6+EdzbsvjWvwnfR6F5Xi9Tccz2U7G8/Sp55iRUUClqLM+9oKuhbH4wFLMPER63rYKykF/dWrJlhlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 10:02:20AM +0530, Anshuman Khandual wrote:
> Current platform specific pxdp_get() helpers are exact same as the default
> ones defined in the generic MM header (include/linux/pgtable.h) thus making
> them redundant. Just add required forward declarations.
> 
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Cc: linux-s390@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/s390/include/asm/pgtable.h | 35 +++++----------------------------
>  1 file changed, 5 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index e882663a58e77..0a0b0ec42b624 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -25,6 +25,11 @@
>  #include <asm/page.h>
>  #include <asm/uv.h>
>  
> +static inline pte_t ptep_get(const pte_t *ptep);
> +static inline pud_t pudp_get(const pud_t *pudp);
> +static inline p4d_t p4dp_get(const p4d_t *p4dp);
> +static inline pgd_t pgdp_get(const pgd_t *pgdp);
> +
>  extern pgd_t swapper_pg_dir[];
>  extern pgd_t invalid_pg_dir[];
>  extern void paging_init(void);
> @@ -985,36 +990,6 @@ static inline void set_pte(pte_t *ptep, pte_t pte)
>  	WRITE_ONCE(*ptep, pte);
>  }
>  
> -#define ptep_get ptep_get
> -static inline pte_t ptep_get(pte_t *ptep)
> -{
> -	return READ_ONCE(*ptep);
> -}

As reported by Sashiko, this results in a compile error due to conflicting
types; but I don't see too much value with this patch if a forward declaration
of the common code implementation needs to be added instead. Looks like s390
would be the only architecture which would have that.

Besides that the s390 implementation of ptep_get() will be filled with
more content "soon", when Alexander's lazy mmu work will be merged.

