Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42869CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 12:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 907436B0011; Fri, 12 Sep 2025 08:57:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DF0A6B0012; Fri, 12 Sep 2025 08:57:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F4D96B0026; Fri, 12 Sep 2025 08:57:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 719A06B0011
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:57:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D53286FE4
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:57:19 +0000 (UTC)
X-FDA: 83880598998.09.E84DAD8
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf04.hostedemail.com (Postfix) with ESMTP id A43D940006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:57:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PINgmJaT;
	spf=pass (imf04.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757681836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=58XwPAOdgj8C/KnRAhD4XHr5Jy4g4vejUcQ6Kbk//CM=;
	b=BuPDeeY3BaFIapAoTD094jD4QnVMEJ5YqpgBg57300uFoyU229hBFHPteM2O5+Bo7KMSUU
	rjImFgriMq7nZLaKyGWl0VfBeB1Z3EITYSbN8VXLwXz3LeUwxsOJvz0cLmoUOQVXZylK5X
	jDNUfTBPL1wx6BDljYtrcWEG2Zmb3I0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PINgmJaT;
	spf=pass (imf04.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757681836; a=rsa-sha256;
	cv=none;
	b=EfBL3v0s4f/DH6AmOxfYDz4DJNA4KRjGaFATs38/0+lf1wxwZFwzOCm02k4ePXIPx4dB9I
	vGBc6URjyo9zhDJkP/dTmLMdfJVwqm+QbPwoMWS3yOwyLpM52HfbZ9PnlmzQGHJOAeMym/
	XfiY6YhgUQ+qbDHvQ6JC8Y+8K/ggeeI=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58CAlUZY015991;
	Fri, 12 Sep 2025 12:56:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=58XwPAOdgj8C/KnRAhD4XHr5Jy4g4v
	ejUcQ6Kbk//CM=; b=PINgmJaTmGHdAT2AF+hgUasxjL9BP3ekGD0+BKKS7KwoK8
	sGABYUGDODVMXQiHgWK+c+K5Qk7qSwsgdR60qqAZLzYDpggZETp3z0psgslZEABv
	bBcX5ESEIDmK3Ssh4H9tOANdUsDC4ve3Ss2+F7gv0b2x4eL+/WuLL75MKzVSTweJ
	BnHNEduw3NBEZJnatPGxz4bNXovlyj8qkSo5dnKOW7TDpBEP+nN+NRBZl40CS5Tr
	qNJ/GWrhyJzczvz2SBRv1DGgGFj+1abS9It+4g1b4P1w7KVsvZsRQWs+fZ5Ni2Pe
	K7Sikg3vWmUIf/JocL9wcnOqBq8GCKYq4CYPpeqQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cffuknu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 12:56:53 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58CCpNN7003042;
	Fri, 12 Sep 2025 12:56:53 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cffuknk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 12:56:53 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58CALT4M007950;
	Fri, 12 Sep 2025 12:56:51 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49109q31gu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 12:56:51 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58CCunWS30671476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 12:56:49 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EA2220043;
	Fri, 12 Sep 2025 12:56:49 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6AEE20040;
	Fri, 12 Sep 2025 12:56:48 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 12 Sep 2025 12:56:48 +0000 (GMT)
Date: Fri, 12 Sep 2025 14:56:47 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
        Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH v2 2/7] mm: introduce local state for lazy_mmu sections
Message-ID: <248b4623-8755-4323-8a44-be4af30e4856-agordeev@linux.ibm.com>
References: <9de08024-adfc-421b-8799-62653468cf63@arm.com>
 <ef343405-c394-4763-a79f-21381f217b6c@redhat.com>
 <4b4971fd-0445-4d86-8f3a-6ba3d68d15b7@arm.com>
 <4aa28016-5678-4c66-8104-8dcc3fa2f5ce@redhat.com>
 <15d01c8b-5475-442e-9df5-ca37b0d5dc04@arm.com>
 <7953a735-6129-4d22-be65-ce736630d539@redhat.com>
 <781a6450-1c0b-4603-91cf-49f16cd78c28@arm.com>
 <a17ab4e3-627a-4989-a5a5-d430eadabb86@redhat.com>
 <9ed5441f-cc03-472a-adc6-b9d3ad525664-agordeev@linux.ibm.com>
 <74d1f275-23c3-4fd8-b665-503c7fc87df0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74d1f275-23c3-4fd8-b665-503c7fc87df0@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VjJg1bjgqAhkPIFaDf1mLUh7KWJjYCG6
X-Proofpoint-GUID: sT9Q6O7KpHDMezFzmg7Jr_oCplhrH_ZC
X-Authority-Analysis: v=2.4 cv=EYDIQOmC c=1 sm=1 tr=0 ts=68c41895 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=uYqTi1GheQgrfgZHFtwA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyMCBTYWx0ZWRfX5jpC8GUVmzcb
 WNTQnHEt7CYJzjyNcPBhadLwyx9qWJPieT278SgOv0+fgDWmcDKSO9n/bVKVzE2Km2J/kquNqse
 Jo2h4tBAH3Rq2bzLQZKuYkpibwvUYGVvMaMFCBcqCEiBXpyJ/14KPD+uGmPeQ+53nO3UReJyF9T
 vV9SHmTpFlxTvywhGFj1lAohZo5EPieMQrww4F/cF8jq4d9H2qtG/up3a2vR/gmEjopqXn2qMS8
 3cpWLt2lTNHCVrgNs3lbLBPz8/ZfWPrNMNeF/iwV1NkiQwT301stt/rMbx65ewChkpW8jMQrt+D
 mygDppYgjygKsvAP9O23nIW8cFyauWRb1MftHnofDLV/qfCy2wrFGsX2zoH6Hz3rIIVyUeTZ9rw
 xobmB0cV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_04,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060020
X-Stat-Signature: 8341m1aim639fi1impd861bqhphkzfcd
X-Rspam-User: 
X-Rspamd-Queue-Id: A43D940006
X-Rspamd-Server: rspam04
X-HE-Tag: 1757681836-532661
X-HE-Meta: U2FsdGVkX19wElciBPKAVkOt455CPz5lCZ5JTdh7Lix7T78PSZQhYl5iGdUsb5jNhB2PwyJ8aBbQvlntG9Vz9l0QWKm2AqemOvNrUYH0rs5YQlFQ8NR49gMlq45ue14vQmFd1OyX0Vohu95PKG/d6LX3lHRfezl6nK6yhDYPLWPWaLO9udWNvJNH2qNP9iS9fH5+t/9zF6ZI3JrpP+bCZ/7nKT707xS/CsgSMFtdVVyEO5tY3u4DnAyu9wEBYyR2SNRdNUMJNyCl2viEeqqBAGtmMe05LenBXkEIY9gILVrlP5tNVnC3oJ/5DmW+v4xfQJleRpXOB75qJfjJ7lKjBfIC/6LqaQMOun7I8+b3Z8oJz7LK2KxrPxShJ8oZEfXhMRFIJmB4RLN78sTG3B6vO+8WfNQW87YAq3+3sn5SFyfwBs6SowSoVWcMcnVIo87G++zEg++QaTmvebqTmQ0h+eXya84fUv3QspvwViHWm9xdg3ew3gQoRok9R8IdVlf6A907viZguEtLl+yrTGw47IrNOHfA1SEHskAFDn/qCae3Ho3E257TQWQpTqYco7VyMeJPjv84yG0C99nbOOauw6hHnw4dyfhlEoRqzA/VRij/6WI2OTinhqM2jbBjzdtDbqk56FBqqbMGhNzbTPfVoMyeFcEtzZAOxM1YWDCD7IQCZMfn0QBdm+icgfNdZqCxoauXzCHUId9yK3tO1Ji1P0YUJuid8jWQx9qdU/1HVkemWBY9JSRKx616bHZLaZLmPNGdv9XL5kk+4+c+FYY25O6MduPMkliQgtjhM+lhzLQnlVxFsFQcMicpkrGbJDpznNEsO+KisiMfCnU+WPSe45Ckozu4Qf4goxGF6USm42VX+hQBjimv1Dlzj8JP0nZ+L+px+N/Z/KN6ZTgJYk5iARCym4Qgc1qv7RJB+SH0pF/mb3jHiQGjhpdVYqhA5fMLX5xMn6mGem2CVgxn9cp
 C/fp5Amy
 fY2APZ317WsP8cnLDEQgD3UoCCUv8IPepXKnOU9mEZblX4RPUsqNRzIYYHPYUiqjO8UAxWNZ+rDmv1stoPRaeH3pzhvDsAJJJWBr38Safw0lR+SqVi/DnIMwO1V6P7fXp+0LZbYXD0DXDBWVRgK4afqqUymBJtRlcnuVdN3iwOGRGJBdl75+HosiN3ZlgfjQqC9pGxS/XoAWVxwO5SPySs6mfPUSaHb3NAZ6GgqBAprc1FmK1bmDpqB9ELLYz/ZSOq/snzqqsYwE8Nxo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 02:40:55PM +0200, David Hildenbrand wrote:
> It would just be passing more context down to the architecture, right?

Yes. Namely this one would be arch-defined and arch_enter_lazy_mmu_mode()
by default.

static inline void arch_enter_lazy_mmu_mode_pte(struct mm_struct *mm,
						unsigned long addr,
						unsigned long end,
						pte_t *ptep)
{
	...
}

> David / dhildenb

