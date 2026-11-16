Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B131606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 17:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=A5Vlrj26
Received: by kanga.kvack.org (Postfix)
	id 9DEDC6B05B3; Mon, 16 Nov 2026 12:41:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5E96B05B4; Mon, 16 Nov 2026 12:41:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A4FB6B05B5; Mon, 16 Nov 2026 12:41:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 566966B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:41:19 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE2CDC0213
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:41:18 +0000 (UTC)
X-FDA: 85441698636.24.C2A8093
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf03.hostedemail.com (Postfix) with ESMTP id 48DF520004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:41:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=A5Vlrj26;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794850876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t8fFzc+67KQpZN7Xb9dT4z/F5KJZqrvBQ4Haj4SJy6M=;
	b=5srU8kty47f4hy5hDnXhRlXJBe7MoPntcwO8aR5jDgsTsfQ6DDF4lOUOYQJw4oeKkgWelF
	2f97mkuW4vHjPCTftE8iKxkCndKrr8zLwN6hk258UP709q0pWUz/MfdQ4M2/2k31/QMct4
	yN52VOhQq3eDR6u/f8remp05EcVb5lE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=A5Vlrj26;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794850876;
	b=FDfFpLj7gkAHOv+IYHrPL5Sn+zUt501AMfIwRUK8KzTwXXCbLrpHqe0jyXWJ14OKiqkc1r
	Mo63LfZuH5e74e+AMwAmdYG+glyDNSo8cmDuNqoESTdvrJe/EWKZtVlOXpuli5Qcth2BKp
	kP/sv2y7GTSj9+yZQKgPaIbxP03ISzY=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGGPw0t3951380;
	Mon, 16 Nov 2026 17:34:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=t8fFzc+67KQpZN7Xb9dT4z/F5KJZqr
	vBQ4Haj4SJy6M=; b=A5Vlrj26ejSk+eQpnWAn86Ta+qsTVbm6qUumrzWGQZ6HS7
	WiG9MqcgDAwX0gz4c7HdLG2lHn5KOXkELB/yPhl3V6w/foYwduqckKLk9vn2KMHo
	+LZXtMjaMzmHqQMZFEoUmBtCuZ5HT7W5+9PC8LllBSCHunmYyPfen27xurL9QxnR
	SJ85RYwbfJSWhLFL3CESdwv8LCkSPitn5RYBvHqjZk81qQmoIhMv5xI3raM3bpQd
	yradEj+VCo6NuiLBf8qlD3nXfCtI+EYZQtnJZdBqneoqKUssYIxQBvzNtW7uxXqP
	Vua6xfor/40DhWhbAZX6WMRJLO/n6bkppssOwL1g==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hxf566s7k-443
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 17:34:00 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AG7nxxK2129088;
	Mon, 16 Nov 2026 08:06:29 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hy3fghgx8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 08:06:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AG86OCd32571772
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Nov 2026 08:06:24 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 407802004E;
	Mon, 16 Nov 2026 08:06:24 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B26B20040;
	Mon, 16 Nov 2026 08:06:23 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.34.1])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 16 Nov 2026 08:06:23 +0000 (GMT)
Date: Mon, 16 Nov 2026 09:06:21 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@kernel.org>,
        Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
        Kyle Zeng <kylebot@openai.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
        linux-s390@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH for 7.4-rc2+ 4/7] s390/mm: always clear
 _SEGMENT_ENTRY_READ in pmdp_invalidate()
Message-ID: <0dcaca2f-7669-4b20-9204-68ed13d77ffb-agordeev@linux.ibm.com>
References: <20261015-anon_vma_uaf_fix-v1-0-7b977303b42b@nvidia.com>
 <20261015-anon_vma_uaf_fix-v1-4-7b977303b42b@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-anon_vma_uaf_fix-v1-4-7b977303b42b@nvidia.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA2OSBTYWx0ZWRfX+1WCvfZo2A3r
 X9oHPlX7sjjz/znAFRDAQ6eOQ/Nl1RAb/A68sKsw3Ra/CMnZs24cDvNILCogjdChwM2uV6mWwx0
 iFI1dz9Q7swY9p+C2cfOngpjDOLUxQk=
X-Proofpoint-GUID: tqjVguXDKydwkTCpxf9Ih4XMa-8ERHOm
X-Authority-Analysis: v=2.4 cv=ROImjIi+ c=1 sm=1 tr=0 ts=6afb3e89 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=Ikd4Dj_1AAAA:8
 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=jawjUyVw3NHo_kiyCjgA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: RlKNbNXmJi-0aDghPxxu7N3gnH-oC2kk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA2OSBTYWx0ZWRfX952MX5YQ7qBz
 YkJZ5k+bKAalVpinT4yTjQaZoEVwToYnhZS9xVj7AU0ML+kHVOlPghWMWYkQm0bjbRa3SPuvuNx
 uK2NWUhCP2ObGGBrJBvT0d65RMPLSaCX6rk3NcwbhSFnig+XA76oBQ6xgJxndSM1NdwkoIV4w+R
 RGddGHx7+F2QVMBcPEsWB9Vkik5TH2jjYXLYVL466IZhAIxFOmyDE6yNH5D+ABQChfML/tdXLG1
 Q6498yG0qniB9+BQD5hTu6QhDJTWvRmvSLuvxABlEubVvfRnxnUNvr59GCAVjnKUwj+Je1o/Qwc
 VI0w54BxfbhigH1I4dawMZIYb8tTpvXuTkFMOpBrD46sCF4sLH2MY/Awle2nd5jC0+pcw45ddFZ
 Zpc97ifK2dlDKy7QBO8vghKgwV/y628NvQWnoORtnjwexAXLFHHJnhjGvAASBCZNnlOxKBw6P8B
 uBGj2c3od2C7Xtzqjkw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_05,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 priorityscore=1501 bulkscore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160069
X-Rspamd-Queue-Id: 48DF520004
X-Rspam-User: 
X-Stat-Signature: e7uga5mjhttmbqasewae3gyekbrbsnrh
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794850876-870374
X-HE-Meta: U2FsdGVkX1/6QlwAuF8qbhSWFz8DGrOrgwcH275nCrntyFndOegC7y4pAuiWzyZ2AJeFm4Apguk+/jSvvn481QbsIQmpR/gEA+Ap4LhypSVRZgDT5AgwO2c87SDQe8qEAh7RqjmhuctIsn4A6KyFu9g5zJuMibdvHtoxyuZndPadfLo3cRWFOU7M9Qnqw6VBLUE2dfVWpKji0F7k4z1XK2dzbDQdpbO4L97ATnmyC8l6VzyGuxVJ+l5YT4ORSeuiS2W7gZBdJIMp6zrYNMGOV802PJFmtD2P+9o/MNKfG8nT22/Y/CgdbnIpNI8IGe/A7Y5yw0Dy1cixsrvLcTYL9CpuKXPw7S0ubaw9+9zFDtgktCclscpVrZss8wVRZAhM2kOx0jaEL7jmm8ggj1AfLZGq/W+S/mVFu03FRGnvujqWte5y97uAksa1nauqdZPZLqLPwSqyjh1yc9NDF3BSMaF0PstSdlK8s6mrD/Y28l8WdToHbGtXu7YbPZDBdPklCaliSvsKxg1WWAGRTH0367wpAsThTapcOp1YHPZtnCvjhZ6Ux4MM9JSIldaeuPzUgoNqhSMnm62vBx1YkjW1PXkrsMITyNcV7MPTrECHdr0mnvqhVk9QUacSenm5JvRw4ljGlXqvSo+oPTGPbhka1vThzirH4yhMlrOQuPqAr563cpC9Li6TNJvwpIbCF6DS08K/Asum/5Z6kdqunTN9dcQ9lgzhJhsjMR3NyGP02+GuyKvrlmW3aHIFG+fY5sYRznjgpCHJvfwunKKz+HWKSNW8uBgTanx2+aDBDAMCgQq2BBly+1PNAkd31huebhkjLdPjfgZz5+VXxYS8PYn7E/obQGWl7ERxYxrnKItZAKNZy9V/PpwLHCTnSMYN5k+kQxO2Ix/k1K9r/ZkNfFrQbpERVfFyHfcdTPRbiumRNejH4APf0LT0KJCaz9kbFxombbWEH0DQXsAFRzHqAiG
 Eb1/QKn3
 YGS/cn67ZTiHRhIWqn1NyZdkXK/3QUg4/RgF2Po89EHPYdpoeeqZZZBGKsdHIjUDU9mhEEUAKUhcycZAmVSh91/SbAtzLgnJvHVZfaO6nAMH/4M/GNqiTrPav8yDN81FDDv0MTWJ14tTp0tUEDgK4cmFxf9I3UM7DSyJZLTgT9I6bhpsW2HpF0DbBZuFPMMMk9dExDXeRATIvmSyjZqRQYbqM3t/K2TRgDeteAaveZsJjDOBvfUsVhsGSyFA2EyWL3GvmRyynImU+LyQG8UySW6AtlqoJdSzbBPFT9SPdvSpXZAq6nLgZZXNhIhf0eLLGSKqnTPlLqgmMoG6X8D4vlTrEx754dFogVv1wZ1KbvVydSNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 15, 2026 at 02:13:04PM -0400, Zi Yan wrote:
> pmdp_invalidate() sets _SEGMENT_ENTRY_INVALID, but on s390 that bit
> alone also marks an old (not young) PMD, which is still a valid mapping
> that GUP-fast follows. Without CONFIG_PAGE_TABLE_CHECK, an invalidated
> PMD is therefore not pmd_protnone(), so GUP-fast can grab a reference on
> the folio and, as the PMD value doesn't change until the caller
> finishes, the recheck after taking the reference passes too.

I do not quite get how where pmd_young() (or whatever) participates in
the scenarios you described. If you meant something else, then the
wording is rather confusing.

In my reading it is the notion of pmd_protnone() decisive for GUP, not
old/young.

> Code that invalidates a PMD and then decides, from the folio refcount,
> whether it may drop the mapping relies on GUP-fast backing off from an
> invalidated PMD, like it does from a cleared one. x86, arm64 and powerpc
> already make GUP-fast reject invalidated PMDs.

Why the code change itself looks fine, I would love the commit message
to provide bit more details.

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

Could you please remove this comment in favour of more descriptive
commit message?

>  	pmd = set_pmd_bit(pmd, __pgprot(_SEGMENT_ENTRY_INVALID));
> -#ifdef CONFIG_PAGE_TABLE_CHECK
>  	pmd = clear_pmd_bit(pmd, __pgprot(_SEGMENT_ENTRY_READ));
> -#endif
>  	page_table_check_pmd_set(vma->vm_mm, addr, pmdp, pmd);
>  	pmd = pmdp_xchg_direct(vma->vm_mm, addr, pmdp, pmd);
>  	return pmd;

Thanks!

