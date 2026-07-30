Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DF98C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 10:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E1DA6B0088; Thu, 30 Jul 2026 06:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 693256B008A; Thu, 30 Jul 2026 06:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B2D6B0092; Thu, 30 Jul 2026 06:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BBFE6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:24:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BBB221C12C1
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:24:54 +0000 (UTC)
X-FDA: 85045059708.14.7FD73F0
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id 81EEB180005
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:24:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cbuZuTGv;
	spf=pass (imf06.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785407092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xw9bl0UjL8IGxj4aZhOi4y5k8I/VjGwH4N8Nftf3ETs=;
	b=FoAvEdojrZWPa0Dx2kUv22AHLgTxv/97SW0p/kpHgUm8o6KYZi/ceFq/Lp2fl/DfzF/XzW
	hJxPiSiwQPidtbBlhMKlVlyUPHaKXmHTx4eGLlRADBUY+o6PqvqieI12PlHKbk1HBmmNM3
	hUsJKOtV0Mrx7m8yGIq3jF9YGeEKfV0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cbuZuTGv;
	spf=pass (imf06.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785407092;
	b=Hlq/0gZWbmB7kfSPb43Y8DQr7nwGin7KxsOyAgoGu/jeDV+tTxdlLlZVJoDk4LfMNx34du
	049w6/7enKCpywH5beSOekfkvGHul9dGmPmc4WIHwljfedCTu57036f0eCbkBloY5IzWiK
	KTvtjMk4ofB+ipAHVzxLZQDVdXI0Esk=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UAHfTr2636729;
	Thu, 30 Jul 2026 10:24:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=xw9bl0UjL8IGxj4aZhOi4y5k8I/VjG
	wH4N8Nftf3ETs=; b=cbuZuTGvqINoexIK4WJN7w/SOfmPaw53VjLgWWtS0g1TV6
	AApSlNPtfukyEGV6EI1+baii13lUpd2RVrnTO88JAS1uB01nwD67S3BhwpoT2ftm
	pF1aM1FG6wpbsP/2T2h/31TWb6MAMdVqk0Y0U7xObox64yGys3hlQjDIfr8/OyTT
	ZLk2ISyswnawz/KZ/3QxEn7Cz3+cgM9B0jXe3LlYa7dkclFQ8s+v8pXMLDuK64eU
	xSEo265wzDTK23P4NZS7d3IgP6C+Az950pfBRGVg8zEGHpSLAluj7s56G0jmRmD0
	INGHxNZjyqwgHLW/B1Qyfn+8b6UhtSsWVxw1bs8A==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuyjeb2g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 10:24:22 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66UACIwl016888;
	Thu, 30 Jul 2026 10:24:21 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8yhjrst-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 10:24:21 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66UAOJda30736806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 10:24:19 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4770120040;
	Thu, 30 Jul 2026 10:24:19 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 832C320043;
	Thu, 30 Jul 2026 10:24:18 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.224.92.206])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 30 Jul 2026 10:24:18 +0000 (GMT)
Date: Thu, 30 Jul 2026 12:24:17 +0200
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
Subject: Re: [PATCH RFC 05/11] mm: convert PTE table entries in ptep_get()
Message-ID: <9ac3f058-2a22-4801-8633-65635053c8ea-agordeev@linux.ibm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <20260727164715.2866609-6-usama.anjum@arm.com>
 <34eed5fd-c569-49d8-bc4d-a3d4b1207fbd-agordeev@linux.ibm.com>
 <fec9e0c7-07c3-442c-819b-f9f5316cb6a2@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fec9e0c7-07c3-442c-819b-f9f5316cb6a2@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA3NyBTYWx0ZWRfX4Ckb6VFvsR9K
 iulXf5F6J1kbO3S70H2cESI4ld0w043xIGqpEZSAio/jR2ldVb59L2x/b1Cpx4Kz3J+55BAkaM9
 AupsGP2HnWvt72AfxwuZCRHnnZzHlFA=
X-Proofpoint-GUID: lqUngdZpiUvWS2H94qSv0rrypUIzUueB
X-Proofpoint-ORIG-GUID: lqUngdZpiUvWS2H94qSv0rrypUIzUueB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA3NyBTYWx0ZWRfX06YvqUElSumU
 CX2i3BnWz3n82hQOJuDP+Eanqg4avWjidLhYvcVNnamNO07ZloFlgeCgnjzpU+K/axVetiCls6t
 fKTSRdUkAcS0rVX5DnmB5M3W+uSpPU1IR/K4E27Sif4nh0pOXRleMzORssdR6V6MA7b5OjvGCGl
 tmvL0lRGkg/9y7/aNGQHm7zP9EpllmztMk0bjuCc6uOo5iaioj63uiUyglAwfqaYT/no/5x3iQn
 vH4Y1m9mc+79iOqDEv4VRNaHyLb/P8hiMxjG+nu/SRMxZsyV5wIoBoehG5Qe599Oqn8bsFRSCM3
 nyuj5Wj5auh3/+ccZhKHFFSfFIyH9mArzZF7DQ5gDzyTNL3gEudzEqBeGvpOI/h3/KDV8L04T7O
 OCFoQvBOxFLH/rPHH9zdO6BPTMqXuYhm4NtAFZGuJ1Oen3ihETQeEK2CjltziDECdSbdSoTjDB5
 7szof3AH3iJlA7l4pXg==
X-Authority-Analysis: v=2.4 cv=X5Vi7mTe c=1 sm=1 tr=0 ts=6a6b2656 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=7CQSdrXTAAAA:8
 a=7fzHlb7OYtr7bZKlnRAA:9 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_03,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300077
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 81EEB180005
X-Stat-Signature: n7nhocb3qabnuf63pxh38crrt8z1t5rd
X-HE-Tag: 1785407092-906618
X-HE-Meta: U2FsdGVkX1/XIhjxUNC7fw3429RPxBxEiOaJgScG+X+Hmi1Odv+1TNrRhZ0Lam2rRCkkdJ81YFnzckYJd+xuK1nfoJNtrbmueHxOAP6hyYiHFbFq0rRn9i/QoROVuB2Nlwf4qQJteCMU45+xkemxYAKCcHLXOlh7D5k9xzeYicOiccDcJWQcxJFd6+wDp7tbf7MRgjR+/DmgMXyGzxt8sORBlKB1OugczN4AeTFn2OpXGu4r8A3RHqv8hEMag39nnV2GocoF5+eJJ425NKW5tT4KBYsgZtgb+8rJJmaJVy3R9Do65I0rU5AuvquOcXxIAqqgV3Gq4hs5dlvAl4X2P+n/YouT0MVbdI57fKYMjdm5BSeOIAcQSmylyZoFi/XdziJCBvcYpUFEMMcgtdwSGZeMTRd+ay9TsZEW0tdbkAiYmGvmRmEu+jvGYmTGY6GDN1q/Js04/R37h+2sfN9z9xo0RpCUqd1JKS7DC5EZSzB0fxfsTaYiF2YR/CCtoQv3q60AdD1gQUY+TxtIuAllce7l2byW415C3cXC4plOySN1ZAS/wm6OBkjBdc32awBaqhlvTdbbHT1Qi4Y37MYGfkpKpwFJ06tW6GEt9MeJLQAjYpgw3BXhejDERhYT9lBbH50SMnM9wavWFNNIeq0cqXsQYGpOGxNghRUUOZt65ET01f1oV/66bLtn4HinuAD787lfPIcdeViwUa+KUOCConk1hvzSSmcF2udF0qptWobEPg29Zo05euR2h9LohtEjxwX5SLnkdZhrIiwz6RAjZIzUHHDpM+0SeoM+qjrH48HpvLKDL4whSYTKq74ZuauwNejtl4/lJZpT3HZ7EpI2KeGogz9Y2ktPYk6otykkwPTuvj6boyjNXlF4Nb/3elXxtB1qN0JWMaD1q8ltGe7q9bTzQ956PUFEDAtaId1Y6o8XvEo1OLIKnlR+FErHzGuFZnZaYa4ukwRg6Z4U/28
 SbXgE7qc
 u23r3P/BaR90N+kEvbku7tquehHcn691ZwGvLeA4CnkddX6tK/8fBIGnQ8nuRk+b5oh/rPYFnWm87RkOQkypAKALUn9cc0C7ferNsTqslwUV12UDAhzWgYrimwh8GcS3EbEL14boQ11Rwjg5BW7amny6HVHD7yQlsRs8A9bm1ICXB5PrcEWgArzDeaMsLaMuAYBCWu7BhPCizUQE8AjHb+yH4CbXE7ui1USXIWTeekQ7OqbXRpGwz78xGislERPhz6VS9r2IX/4kPzC7rMAyDsH8RGhjEW7gqlGfdKPOtCYL1LR/1xRG0Zo0eCwUk2JRmxgqWIspK2qtk3r6nIaQH7jBbTk0OiyahumHXyATYyI+cfPc51ypFvRJkiZUw+iOtyNGQe4Wq2bVyn3R4ZPyWvvOlNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 11:11:35AM +0100, Muhammad Usama Anjum wrote:
> On 30/07/2026 11:08 am, Alexander Gordeev wrote:
> > On Mon, Jul 27, 2026 at 05:46:56PM +0100, Muhammad Usama Anjum wrote:
> >> ptep_get() now accepts a pointer to hw_pte_t storage but must continue to
> >> return a logical pte_t value. Add __pte_from_hw() as the conversion hook
> >> and apply it in the generic ptep_get() implementation.
> >>
> >> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> >> ---
> >>  include/linux/pgtable.h       | 2 +-
> >>  include/linux/pgtable_types.h | 1 +
> >>  2 files changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> >> index dad80d264aac2..3003ac9cd81fe 100644
> >> --- a/include/linux/pgtable.h
> >> +++ b/include/linux/pgtable.h
> >> @@ -493,7 +493,7 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
> >>  #ifndef ptep_get
> >>  static inline pte_t ptep_get(hw_pte_t *ptep)
> >>  {
> >> -	return READ_ONCE(*ptep);
> >> +	return READ_ONCE(__pte_from_hw(*ptep));
> > 
> > Should it be something like?
> > 
> > 	return __pte_from_hw(READ_ONCE(*ptep));
> I'd thought about it. My thinking is that we should get the pte_t first before
> before calling READ_ONCE(). Please correct me what makes more sense?

I have a problem with "get the pte_t first" part ;) I think what we want
is atomically read the hw_pte_t from the HW table and then convert the
result to pte_t.

> > 
> >>  }
> >>  #endif
> >>  
> >> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
> >> index ed5dba42a4f8c..61afe27307ec2 100644
> >> --- a/include/linux/pgtable_types.h
> >> +++ b/include/linux/pgtable_types.h
> >> @@ -6,6 +6,7 @@
> >>  
> >>  #ifndef __HAVE_ARCH_HW_PTE_T
> >>  #define hw_pte_t pte_t
> >> +#define __pte_from_hw(pte)	(pte)
> >>  #endif
> >>  
> >>  #endif /* _LINUX_PGTABLE_TYPES_H */
> >> -- 
> >> 2.47.3
> >>
> 
> -- 
> Thanks,
> Usama
> 

