Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6A94606A323
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 13:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=oIrIDIY+
Received: by kanga.kvack.org (Postfix)
	id E52F96B05B1; Fri, 27 Nov 2026 08:15:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDD696B05B3; Fri, 27 Nov 2026 08:15:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA52D6B05B4; Fri, 27 Nov 2026 08:15:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 969B16B05B1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:15:01 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFAA98035A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:15:00 +0000 (UTC)
X-FDA: 85480944360.16.052C0C0
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4E8E3180003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:14:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oIrIDIY+;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of gerald.schaefer@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=gerald.schaefer@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795785298;
	b=uOIVz8x5D4hmG8Rg7sbNRnzKyd0smwNG0TCh4B/qV+HFEY9c7YUbe98cMNFZ1QOY4LRJMr
	paFhgLAsWruxC0j1ybEHU5e7BfF4/rAm/PxOVjTtWAH8E+gWFal4oAhIsaSGeU9zQJIZ3H
	toMvBMwj6ezVj/Q8DjUbC7gguAChf4c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795785298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g9Ph1lEpYYg+Jn1hnAK3NFg3pmxAgdYKSsFE1n9J8BI=;
	b=qN1xiQl6/xKUJ/mOUeTwTlhRtTeaeJY7EulEzI0G8cVAk5aJzEATONx1PqisqRQVS+/ciO
	lwZgcBCIqha1NQqEhChDGdidUCdVuNA6ikItQDUepnRA2skBeQ4FJ9Y6O2yRjg7NFfXNKC
	5zt+MbH8bNCn2P6b+MxYtkwZan3Lass=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oIrIDIY+;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of gerald.schaefer@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=gerald.schaefer@linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARD54K13148909;
	Fri, 27 Nov 2026 13:14:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=g9Ph1l
	EpYYg+Jn1hnAK3NFg3pmxAgdYKSsFE1n9J8BI=; b=oIrIDIY+xLHHlcm1zb69fv
	GMNWR7eBTAkNWPKYQKDsLDzgEhaP8so7NShzKMhCBrmlqzxv843BWjGiM4oql7d9
	xVAWm4K/zc5slnQTEeaY3sstLQMf+w1DPccfeyD+NZ9F0qT0r/Aq7eZvVwBQq9iR
	tUvH5Dl/e01EVGw1lQiaNOi+nFwaT4W357ico7tZmpVLZqpv+ikgFFIsyuUEJ4lv
	E+f+D+KoxmOPZ0eKLiRXJaDAG2PeyoicwbdTsRY9040adK0jXIkYfM57Kl4U12j7
	HfG5Xu0+kU2GsMsVxd8d9N2OOsJlaaKaI7Uq7hJaIgDqJDGC4UNYwdwm2wc41CQQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g1n5ts-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 13:14:39 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARCnDol1100426;
	Fri, 27 Nov 2026 13:14:39 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j6rhckb0a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 13:14:39 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARDEZ1a30278294
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 13:14:35 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 219DA2004D;
	Fri, 27 Nov 2026 13:14:35 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8DFB92004E;
	Fri, 27 Nov 2026 13:14:33 +0000 (GMT)
Received: from thinkpad-T15 (unknown [9.111.82.22])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 27 Nov 2026 13:14:33 +0000 (GMT)
Date: Fri, 27 Nov 2026 14:14:31 +0100
From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
        Baolin Wang
 <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev
 Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang
 <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau
 <kas@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        Rik van Riel
 <riel@surriel.com>, Vlastimil Babka <vbabka@kernel.org>,
        Harry Yoo
 <harry@kernel.org>, Jann Horn <jannh@google.com>,
        Kyle Zeng
 <kylebot@openai.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
        linux-s390@vger.kernel.org, Jason Gunthorpe
 <jgg@ziepe.ca>
Subject: Re: [PATCH for 7.4-rc2+ 4/7] s390/mm: always clear
 _SEGMENT_ENTRY_READ in pmdp_invalidate()
Message-ID: <20261127141431.4c3c2b2b@thinkpad-T15>
In-Reply-To: <20261015-anon_vma_uaf_fix-v1-4-7b977303b42b@nvidia.com>
References: <20261015-anon_vma_uaf_fix-v1-0-7b977303b42b@nvidia.com>
	<20261015-anon_vma_uaf_fix-v1-4-7b977303b42b@nvidia.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: FeLowTyogOlHUnJfBR_xou9lqiAF_CMx
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA1MiBTYWx0ZWRfX4M209SkPbL/+
 k08Lj+ZiToxKEUtkfQyo5s/KDbFjbNj1bTKYgyAbu+miQQlryq5UfjuQvbq11JyfaWzhyzgUhq8
 H9c1T0ulS11ryjHb1Kybw3/eQh8f8qQ=
X-Proofpoint-GUID: vhiax2KLb9rM44fc03ndO3pMxE3yegDi
X-Authority-Analysis: v=2.4 cv=c8M+0h9l c=1 sm=1 tr=0 ts=6b098240 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=Ikd4Dj_1AAAA:8
 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=jawjUyVw3NHo_kiyCjgA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA1MiBTYWx0ZWRfX3t/itx/F+v7t
 h/ee1jM5erlFfsjIU6YSrmIguY6Ayym1x1uIVW2Y8711jl72iFE/5ayGtoMq5hd2nBrjV0idY3s
 0JsLLeCeQW6STOu760KEXuf49Vp3nnM1kelrDvCncmdnZ2pjIvXmjENMA4kPH36xyV43purtLzg
 dGKcR4W3Eq0l2MUxLwnReQuxI+3ecMPPGc90hpPo+xL9hnDdu7Vn4WYvlhhup+5eUHhOfzr5oO+
 LykciOx9XF+CHLLWWJLbJDGTLUk9q4T9os2GCrIaYgIXfACd4CrzYto5bs+4aQP6u5czPhjv0I/
 zw1Iefdi1sMKavdPAEWIv0W3cJdXoVY78eu/y4o6KMp9LOiTYCVdjJYFwfk2PxOvku7nZsFS+Ah
 qZUNU6pronN79Bu0g1JNdQ+whX+H84qd13cjuqz87nrtwjmAChgZBgw4DWh5tW0LUUGpLWrmXfc
 fMzM6pIqloGyImQDDsQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270052
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4E8E3180003
X-Rspam-User:
X-Stat-Signature: xqoaw1a5kdkkd15m1b54og15kzurhe93
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795785298-843124
X-HE-Meta: U2FsdGVkX1/ZUXW53wyF0IZhFqgm7VAEueoK8x7uYNWXO2OcnNRiCjuDwfiGDyaoWOxKCh/GaezEB3meLnGuKP3l8fkX31mRrOxESjawNi7K6+vP4yuR10mgf6WAFx03fDcD8nQDrhiJVcsfT7YHaX4XcSuDJOJbrFfF+dbfO9rmeBNh6uDld8y7kUY54fXv7TJ7M1Tke70fySW99Zkj499h1AyNIKklJYZfnr47aBf8NJPkoSC5AXKqRQ2wARsnoAreQsPXrStl+05yF/3tmZ/W++LGHNC9Zxp8K6xk28lHqgXDT9uSLAKeEnCnghuoUEbfY00Pr+HVqBPwPdunRWG1C6pJi90ZfvVWRzkbJsFz3QhUJ8ntFamojy3iWIgVauMQNn6DIlSi1PbJxdbN/N29o5OZUaFKbW1hzbTMShUTCm6dc0W56Qxz+rKRqbHbjyeyq2UlXJeetVBMYnzcFC3Pzuj8Bwju3+5IjSCVOoDGUBbUpuOUts7lO0wGwB3FFLoDDcLFu9/MrXUvNajdrh4gTsDH3vTIjRMylgdCaOmt65TYqXVcbrMkOJk+lz1CynbwuPGUQeq00LGWFLmn/oSMFhGa9bG+ISIwMiGhmFPRWD48etQWIE5Z9FkQn8BEDg79bHW/2q3Y9qbsDzjgs6vFeQSixE0mZBYLq+cZskpK6AWg2KySNTKh5bvmXSl/EegXxfADUIHcPvrggCiY6LsN0mO2Y4zhqhDOzT81ddohszUZVFxl9VrgePlXPGzDUSRucZbX366/xGh7lkk+IwbJw4vWksE+9ipGfmLMFkTQGXyd2SoDKXCU/Q0JFJQ4dMLL+6wIh3xhPquIz/MSjRATNIfr10gwsifU5I+3zpZyt+D+aiJitiCU47SotJgNpsv3lzK/zs+FBceB6DHqbQwSsvZc3hiKlnZ9YnqinNp80eLi7HvU/zYMqjhs/ne5U1NB3+mlcPq4G20YHRz
 ND3/0ETU
 GQ71dEFPJUw6YF7me6cHvKQ+jh/lVxMTn99hiTTV6C9eRfPouAz6EL/C1H0TGqwg4Yh/OcozSHJdoM4JwW0g6N2Y7zv8DuJaX5HMsEW9euDwTjNHxdK7NJabtuo+/7xhyM5OBsyxmNhegiQK1v6zwfssJua9EVsEi9qzJBy2Et15o3YzMDPERzywlPH+JI7DSJf/ApTt4BHM1xArKmyQcbEorjKWw4DsAJKqbq9I1FJc6XfyyTgRNaZi2DKmrFTd2WBKe4QFz53s34t2LOOXff4KordAfok/0c9KjFVWOkjcoEzFLwbA92XJuZqphkks7BEucj1r9ws7a/Z/gsCXkjzMw3YgUsnZbiHU4ww/H/5lPMfuHaPo3r03uDd1zI8D3QEuNqsy3aR4i8G7diSMf3/Fb4023EnReM0AZsc0f24NX86Y+cKbxvFCUbkaWeMwu4AdCJCJZK+QMeOgWfBM+9ddoBhkb9OhAdmxoZBjmsv/AdsFL4+cmoBMQHeI/jTTno6FKG+WRqEXTPHHXnYGkEtSJp1rpG7ERp0t8rJso8V8F5nUOVyg61n1RNq697Bl/GX3EOBDmndi9Om4Fli9xvRWNXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 15 Oct 2026 14:13:04 -0400
Zi Yan <ziy@nvidia.com> wrote:

> pmdp_invalidate() sets _SEGMENT_ENTRY_INVALID, but on s390 that bit
> alone also marks an old (not young) PMD, which is still a valid mapping
> that GUP-fast follows. Without CONFIG_PAGE_TABLE_CHECK, an invalidated
> PMD is therefore not pmd_protnone(), so GUP-fast can grab a reference on
> the folio and, as the PMD value doesn't change until the caller
> finishes, the recheck after taking the reference passes too.
> 
> Code that invalidates a PMD and then decides, from the folio refcount,
> whether it may drop the mapping relies on GUP-fast backing off from an
> invalidated PMD, like it does from a cleared one. x86, arm64 and powerpc
> already make GUP-fast reject invalidated PMDs.
> 
> With CONFIG_PAGE_TABLE_CHECK, pmdp_invalidate() already clears
> _SEGMENT_ENTRY_READ, which makes the entry pmd_protnone(), so GUP-fast
> does not follow it. Do that unconditionally. As noted in commit
> 7b4dde5e40ad6 ("s390/pgtable: Add s390 support for page table check"),
> an invalidated PMD that is pmd_protnone() is fine for the remaining
> pmd_protnone() users, which run under the page table lock or are
> lockless walkers that should not follow it anyway.
> 
> Assisted-by: LLM
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Alexander Gordeev <agordeev@linux.ibm.com>
> To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> To: Heiko Carstens <hca@linux.ibm.com>
> To: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: linux-s390@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/s390/include/asm/pgtable.h | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index 2d5c2ab06de98..fe1ba746203ab 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -1781,10 +1781,14 @@ static inline pmd_t pmdp_invalidate(struct vm_area_struct *vma,
>  	pmd_t pmd = *pmdp;
>  
>  	VM_WARN_ON_ONCE(!pmd_present(pmd));
> +	/*
> +	 * _SEGMENT_ENTRY_INVALID alone also marks an old (not young) entry,
> +	 * which lockless walkers like GUP-fast may follow. Clear
> +	 * _SEGMENT_ENTRY_READ too, so the invalidated entry is pmd_protnone()
> +	 * and is not followed, and page table check does not count it.
> +	 */
>  	pmd = set_pmd_bit(pmd, __pgprot(_SEGMENT_ENTRY_INVALID));
> -#ifdef CONFIG_PAGE_TABLE_CHECK
>  	pmd = clear_pmd_bit(pmd, __pgprot(_SEGMENT_ENTRY_READ));
> -#endif
>  	page_table_check_pmd_set(vma->vm_mm, addr, pmdp, pmd);
>  	pmd = pmdp_xchg_direct(vma->vm_mm, addr, pmdp, pmd);
>  	return pmd;

Thanks, looks good to me, and I especially like the comment. As David said,
pmdp_invalidate() does not have reasonable semantics, and I think this makes
it a bit more clear, at least for s390.

Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

