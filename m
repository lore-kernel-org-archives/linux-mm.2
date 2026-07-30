Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08622C55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2106B0093; Thu, 30 Jul 2026 07:29:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89FC6B0095; Thu, 30 Jul 2026 07:29:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7AE26B0096; Thu, 30 Jul 2026 07:29:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CEF46B0093
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:29:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 29B361C12C6
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:29:56 +0000 (UTC)
X-FDA: 85045223592.19.CB2B3EB
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf11.hostedemail.com (Postfix) with ESMTP id B333040004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:29:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LOlhvmIF;
	spf=pass (imf11.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785410993;
	b=bAOZmPcr0KAvaf8J31t2rEoDc0TaX1xR/GJnE28z2fdB+xqhbZWM9Kgmbyb4sbRxHCEYL/
	MktBYUUehx8OXYtbXsJN37/NGR++fmaGIqNp8vHLCK1WgnAUPQ1b2Gm+HaLRAiMHo8OTi3
	u9VXM+coUUQx65e+/zogI3JGSffhlbo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LOlhvmIF;
	spf=pass (imf11.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785410993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iqt2s1hq4p/5rHwvwtT1k5VmvNMosICBR3I5pd05C5g=;
	b=SqIMqT9nThFqO05zDMCgTv0KMunbOPEoQmYAycQI9hwqnMwauDz0oG9MbNVitxaOtnZOhH
	ni6pN6rJ9pUz2ilua47T+whALaqHp1sjwXgG2qFJnZVHDFTgTXZaMNTo2pXpMtrmOpCpNE
	oCqpO6DvRPqWkugiJjagZDjNuTbZYPg=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UAHuns2709587;
	Thu, 30 Jul 2026 11:29:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=iqt2s1hq4p/5rHwvwtT1k5VmvNMosI
	CBR3I5pd05C5g=; b=LOlhvmIFhW/EngAbWhcK7RbynBbOcMLn8k9M44UoY1doH4
	CQvK5x3I2gQ+I/eDxx00AjEnGtglp7EP68wc5irkslKwFXFeJyl0JpnizTObLrfc
	wnyqyVaeaaICVHqF2o3nzEsKAdgN/Yna9ginLJBQYB1NQh6VV3ax2kGWMpJVTv1w
	Whce7mFVUCRYyM740D1Il6BuX9SbUGAUDXA28opS6pOfQXzqxqb5sws7Ac3yDMnD
	KtYJdCmUTspQr6cTO/OMjZNmWB4NVe1S/2N8p4JSmv7CA0Tz7QReSsr7LIs1FL0h
	Sa1KUyP3rTtmf7GCyJSTJvX4W0zsccVa7vEHk3Xw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuw7qdv8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 11:29:29 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66UBQg3P005008;
	Thu, 30 Jul 2026 11:29:28 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5yat6k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 11:29:28 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66UBTQAJ43581894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 11:29:26 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2BC1C20043;
	Thu, 30 Jul 2026 11:29:26 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 39C4320040;
	Thu, 30 Jul 2026 11:29:25 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.224.92.206])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 30 Jul 2026 11:29:25 +0000 (GMT)
Date: Thu, 30 Jul 2026 13:29:24 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tursulin@ursulin.net>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Will Deacon <will@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
        Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        David Hildenbrand <david@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eduard Zingerman <eddyz87@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@gentwo.org>, Mike Rapoport <rppt@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, ziy@nvidia.com, pfalcato@suse.de,
        ryan.roberts@arm.com, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-parisc@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-arch@vger.kernel.org, kasan-dev@googlegroups.com,
        linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH RFC 07/11] mm/mremap: use ptep_get() for the destination
 PTE
Message-ID: <50dd77c0-b6cc-43e2-abd5-6d44a29b5597-agordeev@linux.ibm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <20260727164715.2866609-8-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727164715.2866609-8-usama.anjum@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: V4x9pQxNwD7ZNr5cxCV2-nvUuRwrRIk1
X-Proofpoint-ORIG-GUID: V4x9pQxNwD7ZNr5cxCV2-nvUuRwrRIk1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA4NCBTYWx0ZWRfX0CQsHlonvlnH
 AF8GXubMVqrPdR5q2n+7Pi5IhSvnRClhhnIlGsM45pj9nS5tbh9v0OQ7ZDryymjJZRFKeKVHtnB
 2WWJA774SAFONtJMa1V+ZFbhY/GluaeNfrJWfajh0aeP9y3KCj2N7q61IT/ZcqjPD8Ux1nEITrp
 lqWGD3CVkHnuWYvD92qt1C/5PMxyLshMO14JBLRDs++WhJByj0BHkXcsWNivsbVrtdJT6sVZwbe
 dzeDGI8gWjRNMh7nT2wbxj0bb+I7NqjrGKSVMqorBDA3g5atHjQfxeyyy1zH1imIK+WiEUWLOj2
 QQUIajHJgwMTOVFObZZxwcDbjinR/ict/W/9rkboCapJlq+7peril/x1TLLHoImfIa1fT9/ascw
 AjAYP3c7Nyd6rCK2zbdbMkwiwAS4FHnHFqkFfsWMAkhtZLdazd3x2FNYbpmW9FLWL90LlaufF1X
 g6HAqpq5Re1qYW6+N8A==
X-Authority-Analysis: v=2.4 cv=SKFykuvH c=1 sm=1 tr=0 ts=6a6b3599 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=7CQSdrXTAAAA:8 a=nEq6qJbkOf9lyMFAmGoA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA4NCBTYWx0ZWRfX+toP0yvqLwe3
 5MpM2JLPKFYcitSFhNnjhmLQzv/6TWy3jhaIxgQDqHwpJrQHSWwSOVkfjDxzt8TAMHiE7g64vAw
 8VzOqfzQntIJPAir8I8JMkTRPXuGciY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_03,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300084
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B333040004
X-Stat-Signature: b3der41qz3bxz1ukmuhdxk1kf9uhqfwo
X-Rspam-User: 
X-HE-Tag: 1785410993-319980
X-HE-Meta: U2FsdGVkX1/aj5ahdZS8bBnFG6SoE9rfHjaboDWToBa8ykzzCC3JA4vKJVkVDP9H+DsVxhCAa0BV7OBLri+zFnVzwsyvQC76mTBdwrYbnfWm/sNUhvdNzmLBYqlZx8go9rdykDRIv32sji1QJ9S8I4vb7xyBkQN8bJ1+Exn4Q20af7Hd9oqkRAwcZlZypktvfqSYYHIRt2XLKAdADKfgbLoMpvKW00cevCxvjqbE48P/9sfsUC4ifxdYL03ly7MYpLPg2sbd99qnxJ9KC4B7Wuo+XlvofBkZf8IXAKbC6WMmjr8o3eflSFtjkTqvuFG/ehpO0BRlAeiZkTCIk599eYJO81tQfVHa8rg0Lv1k0rBbOMaNMIDNhSTMSRSVTsMoWhXBzTJD8nPa1/XxX+NERmiqNZjH6Rz5i1u0Q5uAuwBESFiCYh06GWkGzYSMHCY1dHe3pRazZv9JIa+iNH0U9Fiz6m0oCvEZ7r/9A9qDcZFpNTFRqlIUiwVHJJSpMvaff3s54CMuwSOA+eAwHaKnNtUpt3vYFhP43RTeyd3MsR5MNN/mJ/IEZezixaTekW5NeDiV6H9iDNbjTDwHBJXesp0pB3nijPGKL9yIXHYgcKbBAh168qW9FlDPhUjD1+q7keeRyQM2MJfhXG/XOHw62j8PdQuEf8f5SwI44eoEpb3t/ZHWBtf2Z9w4ipGvRsC+nxiNB+tNs4zpL7doopnlwg1KegWX4fAFWrFu0KRh1+ifzfhOgu5S0+6xLUvl+n5EBeTiTOSopM+6qGU7BPf4ZzJDS+BREKLHEA2QpmVB0gdXFqzxWSuaZNEwZEwCUQGq9bHGReWuPq3Wjs1qTI6m6lHEUXWcLPmw7RNExXk3x6qicBZuRCjOldDFkh0hJ/Vc1WtISmpyTGTcA9gnJcAu+U5T3iCNCLq6+WGiRDRmvDeB2//JQiCHjTQjiCwJrAvQuQ3QgtycyC/ddeaG63r
 JKW7sW+l
 e2LOr3zHqA19a09lN9BdViIlnqLkju6Eiqk7i1/AXZTraqnAy6wSNdAfVbarFWNeB0U4J4E61gGdLPGfABB3aGvmOQQiO1sibK7tya7NEla+/WYRO+rHR0ogrWVlJ8rGbTX/7tLeGIHRI/JuZ0bpfnOKqxRmYZc5ko7vwjaR+v2JwcusTUkLgKV3xTSsDeZkB0KLWyvgyUdfyTZDW0ixTtOxxi5rcwm9jqKLd473UbZ7RX6veCaFa75xQaZUuz3KL0VK2jmmfgNdWMHTey2rixzL3+C8lMIRwBwV5o03ypQe2rXPs5JY8hkwCA0pFx8qlRh7PFAEM1GFA8IcasmrggvaJqnXTgg+GRSLvn1/oZqyTr8iro22u6fMHwG23AG86NVDSPhhqMFl16pNqfyg6fYYoEF0hlHc7Q4HsCmVrNRT6Ua9jT/IkxpvhXS7uddhSosDRqzYCARRSPyXOs13/kSNc+SERnpsq2WJD3K4n+wVBQDNsR3CTNFhKtQcsbqQGLGfwUoTPtLnpr+TAYpk0miQjwwroRx/9INen
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 05:46:58PM +0100, Muhammad Usama Anjum wrote:
> move_ptes() directly dereferences new_ptep when checking that the
> destination slot is empty. new_ptep now points to hw_pte_t table storage,
> while pte_none() consumes a logical pte_t value.
> 
> Read the destination entry through the standard ptep_get() accessor before
> passing the logical value to pte_none().
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  mm/mremap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index d966ee8248b6b..ecb90ccee6fdd 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -264,7 +264,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
>  
>  	for (; old_addr < old_end; old_ptep += nr_ptes, old_addr += nr_ptes * PAGE_SIZE,
>  		new_ptep += nr_ptes, new_addr += nr_ptes * PAGE_SIZE) {
> -		VM_WARN_ON_ONCE(!pte_none(*new_ptep));
> +		VM_WARN_ON_ONCE(!pte_none(ptep_get(new_ptep)));

Same as the previous patch, except that I did it already:
https://lore.kernel.org/linux-mm/20260720141633.501799-1-agordeev@linux.ibm.com/

>  
>  		nr_ptes = 1;
>  		max_nr_ptes = (old_end - old_addr) >> PAGE_SHIFT;
> -- 
> 2.47.3
> 

