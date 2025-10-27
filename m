Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2065ECCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 16:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D4F80075; Mon, 27 Oct 2025 12:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5378000A; Mon, 27 Oct 2025 12:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70A1680075; Mon, 27 Oct 2025 12:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5ED148000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:47:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11C73C017F
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:47:43 +0000 (UTC)
X-FDA: 84044475606.05.22F744D
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf13.hostedemail.com (Postfix) with ESMTP id 931932000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:47:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=j+S6nQ74;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf13.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761583660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Z/0C64ctaozs3ABvQcRCVXmOnEYI0cdXgxwFEI+wK8=;
	b=mS4+W6E7JiMlFEelZe4hlUyyX+2I+p63H4JT7d3J8pcnDN2COwpYFyZC3DV5CCRWZjydj2
	uSLfjQb/36iH9D7xASIbTPkhfFO8BquJQpMl0SSEDQn1CMA2qDqyZTbTzjOUxYXh523OUB
	rKEO9R/HaaSwIoIo7UBRktrykMIN7Fs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761583660; a=rsa-sha256;
	cv=none;
	b=DHM0Js7kt8aFnU6mIiy8jCG2COIQ1frbZn3DKbQQdEhEpXxoYl/jyEvV5MYVvXIXtQsixZ
	Tj05sdWtGgwb18vx+q19PsjAwI9BIVByu5T0N48hYYC3vhRqdbQgoqgmXW5LjVLDd42SXM
	2i9mdLv/Q9UeUosy08UatqEhn+9uCuA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=j+S6nQ74;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf13.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RD8UQE032633;
	Mon, 27 Oct 2025 16:47:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=1Z/0C6
	4ctaozs3ABvQcRCVXmOnEYI0cdXgxwFEI+wK8=; b=j+S6nQ74Se7giUxmRQfDzo
	0fHXyJt9Lgj5bSsrWtdQlcW/roLoLbYuUk7XXfEPscwj+Ier7Gw3pZ+MtYB/mbQh
	5zuyM1wmgFz0nm0QmuLMGxmbGA85R4Tt+f5obJoHkNaLwRs5NFy8TjQaad1XrZ2Y
	pruWJ55VfwMm53S9DVHJ23TIZQT+mc13OXbtSZp8JfZ1hffB5RORFuoZter1Tjlp
	g2/0uRFYQ9bxCPjJzqJFMfzzfBgLx6CiG6fubEPSlZTUrxQkxf13JSI77IP7lV8Z
	rh8/aGe2OWouWG0n9O9OJPJ8CbbcTRDk5beLBOGyNeXhvDtFrcw9MQJ/UH8stllw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0kyt7yx5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Oct 2025 16:47:33 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59RGjbRp004340;
	Mon, 27 Oct 2025 16:47:32 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0kyt7yx0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Oct 2025 16:47:32 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59RFIZ0s030114;
	Mon, 27 Oct 2025 16:47:31 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a19vmekkw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Oct 2025 16:47:31 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59RGlT109896284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 16:47:29 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 87CB220043;
	Mon, 27 Oct 2025 16:47:29 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C59A320040;
	Mon, 27 Oct 2025 16:47:28 +0000 (GMT)
Received: from p-imbrenda (unknown [9.155.209.42])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Oct 2025 16:47:28 +0000 (GMT)
Date: Mon, 27 Oct 2025 17:47:26 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Balbir Singh
 <balbirs@nvidia.com>, Liam.Howlett@oracle.com,
        airlied@gmail.com, akpm@linux-foundation.org, apopple@nvidia.com,
        baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
        dakr@kernel.org, dev.jain@arm.com, dri-devel@lists.freedesktop.org,
        francois.dugast@intel.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, lyude@redhat.com, matthew.brost@intel.com,
        mpenttil@redhat.com, npache@redhat.com, osalvador@suse.de,
        rakie.kim@sk.com, rcampbell@nvidia.com, ryan.roberts@arm.com,
        simona@ffwll.ch, ying.huang@linux.alibaba.com, ziy@nvidia.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: linux-next: KVM/s390x regression
Message-ID: <20251027174726.5d8fcce7@p-imbrenda>
In-Reply-To: <748cdc18-e32d-41bd-90d1-a102b1c51e06@redhat.com>
References: <20251001065707.920170-4-balbirs@nvidia.com>
	<20251017144924.10034-1-borntraeger@linux.ibm.com>
	<9beff9d6-47c7-4a65-b320-43efd1e12687@redhat.com>
	<c67386be-5278-411d-97e7-43fc34bf7c98@linux.ibm.com>
	<8c778cd0-5608-4852-9840-4d98828d7b33@redhat.com>
	<74272098-cfb7-424b-a55e-55e94f04524e@linux.ibm.com>
	<84349344-b127-41f6-99f1-10f907c2bd07@redhat.com>
	<c9f28d0c-6b06-47a2-884d-7533f7b49c45@nvidia.com>
	<f5debf87-0477-4d6a-8280-0cd95cd09412@linux.ibm.com>
	<748cdc18-e32d-41bd-90d1-a102b1c51e06@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ubob-5LekCHHco6DkR2SSF7gBcYPozRH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAwMSBTYWx0ZWRfX76PA6OE8xQR1
 w6FqXRJhMr8hQX2vlEjfyQrEeLlINNckKrCpHqV9x3C8T+/0MOhO77PRRlZuHvtxhrvJ14q4LDO
 gy6rQVqHOBPRsjm8rzQ8UM+K3vmNugEiNmmNaWYNYuyqgAXHCYVezSpfCtook6eZfohpVsMTAMS
 5pCfRkzynTMtXsJm4Shk77fu6hXApSLdiPXkdeRzPU6K1xQ04NwgFg0yewqrHjtiOSFUCftOrCi
 omXYZd64bQs5akgGifdp5LPzr8OIZUb23x6uhz2nt728Y1Oj8Cm8sHG2RjBZ5hjnfHNj9VV9gYq
 BwYfWdkAHiGeFDchPidmxmgC7VQQkseyNKh6QrnlvNqYyhG7dK2opBh9/BoJMwi2G/meyseDjdq
 GWSKir29IsZ3GOZL1FJz7G8+NgayeA==
X-Proofpoint-GUID: 6rmIiatZmSL_xPvg8AlM1iNfS4Hou4ZO
X-Authority-Analysis: v=2.4 cv=FaE6BZ+6 c=1 sm=1 tr=0 ts=68ffa225 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=ph-KnSEqExXM2Mgme_gA:9 a=CjuIK1q_8ugA:10
 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_06,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510250001
X-Rspam-User: 
X-Rspamd-Queue-Id: 931932000A
X-Rspamd-Server: rspam02
X-Stat-Signature: xxargka6h9hbeubca9mo31wfrsshbfh5
X-HE-Tag: 1761583660-111165
X-HE-Meta: U2FsdGVkX1+UL6PSG4nVVjLcqHqI6X/L6ZNowpdf6m7Cm5DEt8Y4slp79Q6mOvD0rwOfiNgbGSm/HtpJIme8OZMMEuTrLvNx8bza2wvvOh7lK4fQHW2b1rTbgDAIixIJAeoCIV0aD5XzdaWjudygHgK1uzUY14z/fjM64b7mBzuVeM/R1Cg8LQi0vRhceATZyRYJq0UVGXCwUVyuwe1Xo4E7PCkNPgUxGCOEeMRloaaY630hMy6hGZO74eTiUdP4RPtJNSuuaDwrih5v/eJOIPIOrpp5Luv10ul4xwyN/v+GitVBgJ5DDHtnVHVp3rsLUh0c3ybDceivVH1kvT/YL1cNI3PQLU/+/ukDlnfL7qiwFVUj26R27zsHekzoSsR6BRO9KEGxB2E68LuA5JlaMfbqcyFHhtE/dxM4SfCB5XwoilqOGUTc8NBKYcGaF22iN0bpd214/KTjrWIkjUwtCEY+1D/9QX3/3cZWOovg2BqbB5au2wo+YwyZEYU6LwVrThDxh1dmKe2Cax5qOz32MJGLlDmJ6fsGMmCzIQhp4jVPQRhHtreCsDTzhq1RJG5VTehnD59GG7Pwk7VZ95JafWCH9I92PMZGyh8fowHO/U3IrKQKenq/wNtUcsh0c5JFtqXlg2Vs8BGvwpZk8CdnZWV6PgfH5jPkbdRfOG3yYsCFAez+CLz3kYWbD6dHFE5LgZmgEUS2f/3IwxB6fCg1ElOzX7gyJHOzFkWcQlwdkw29rskZmhrtQILy/kSPeklWj50MvMk33bFxL+8TRkQnoQRQA4o04fc0EgfdL0APbmncxKRhBhdevMCD2cMMy11A0GcJa4Vkyi82wxqPUhmwt/a7gH+FB/GRKbNpO1Wx3CjjmEpoBCxbaZ7Pxk8HqW2RWdG1oUj2FUYikE8YGyUludWsjSq84kiS8l6rB2SfX1/SzmA3MjwL07H56uKMAGT4M/kB3nVQWMUVSbFrfkC
 5mWmzLfb
 22+Mb5wdAyPnktwXO/PV28xoiKHeY/aZN13ecR+AOpBjAFRpblT4xIcnyyxItrIDebGrTVUQNXGJQILSosUcuhE5WxZRDX7zxnAgEZgetbYZrE2zYl77Y1ihhFB6wpZwJec3IyqtfunncjeMN5z+slvpEVTdeGepvl1At81teyOK/joK6MKpJE5IPIq1qKcPJhUUg1eoWKHOt3a3wqzE0sPswa3835XaNgOAxLsmDW+4+fluhgdRutHPrxf/GZq30JCofD6qpqkTaUr6+rSpXsIOj8J4bl7MKp5f2oYJSyLJUsmpB7Wof1G1+Qjntwm1WcTKKOZ89MQms+YrCfhwFOdl5SQ9VfJ0r0DHM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Oct 2025 10:41:28 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 20.10.25 09:00, Christian Borntraeger wrote:
> > Am 17.10.25 um 23:56 schrieb Balbir Singh:
> >   
> >> In the meanwhile, does this fix/workaround work?
> >>
> >> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> >> index 0c847cdf4fd3..31c1754d5bd4 100644
> >> --- a/mm/pgtable-generic.c
> >> +++ b/mm/pgtable-generic.c
> >> @@ -290,7 +290,7 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
> >>    
> >>    	if (pmdvalp)
> >>    		*pmdvalp = pmdval;
> >> -	if (unlikely(pmd_none(pmdval) || !pmd_present(pmdval)))
> >> +	if (unlikely(pmd_none(pmdval) || is_pmd_non_present_folio_entry(pmdval)))
> >>    		goto nomap;
> >>    	if (unlikely(pmd_trans_huge(pmdval)))
> >>    		goto nomap;
> >>  
> > 
> > Yes, this seems to work.  
> 
> Right, but that's not what we will want here. We'll have to adjust s390x 
> gmap code (which is getting redesigned either way) to only take the page 
> lock.
> 
> In the end, we'll want here later a single
> 
> if (!pmd_present(pmdval))
> 	goto nomap;
> 

this seems to do the trick:

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 8ff6bba107e8..22c448b32340 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -599,8 +599,9 @@ int __gmap_link(struct gmap *gmap, unsigned long
gaddr, unsigned long vmaddr) | _SEGMENT_ENTRY_GMAP_UC
                                        | _SEGMENT_ENTRY;
                        } else
-                               *table = pmd_val(*pmd) &
-                                       _SEGMENT_ENTRY_HARDWARE_BITS;
+                               *table = (pmd_val(*pmd) &
+                                       _SEGMENT_ENTRY_HARDWARE_BITS)
+                                       | _SEGMENT_ENTRY;
                }
        } else if (*table & _SEGMENT_ENTRY_PROTECT &&
                   !(pmd_val(*pmd) & _SEGMENT_ENTRY_PROTECT)) {



it marks non-leaf gmap segment (pmd) entries as present, just as normal
pmds would be.

I think it's a good enough fix for now, pending the rewrite, which I
hope to get in the next merge window


