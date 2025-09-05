Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1156CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 15:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F155F8E000C; Fri,  5 Sep 2025 11:53:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6188E0001; Fri,  5 Sep 2025 11:53:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E0A8E000C; Fri,  5 Sep 2025 11:53:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C4C088E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:53:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8CA4EB68D5
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:53:15 +0000 (UTC)
X-FDA: 83855640750.29.437A49E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf16.hostedemail.com (Postfix) with ESMTP id 36F5C180008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:53:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qnifUl96;
	spf=pass (imf16.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757087593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrKzRKvPlqc1QwFwyTNKlG24n0S3B0erGWAU2bVkVqg=;
	b=U9S4rmZLELR4aGzlt4iC+tS6iBW3Hr2B0uMwp9PoWCeltYXM4GPvcUq+FChHOJEpYJU2xH
	xiSfuYEvZ8S6cM+fSGJpZK6RQ+CgqkP6/BXzjTb3L+qhs3PRAmIMKbwOKGSaf196+ClIYD
	oaNhUzrs5RKWr6vtMF/vKkNeK220TOw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qnifUl96;
	spf=pass (imf16.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757087593; a=rsa-sha256;
	cv=none;
	b=BHnR6049gBCwWZH4nK4piq0gEjagoCqHZV5bGZ4KzcEkK/jvrUSyzDDpzcBUPjTgkGHDdx
	LlINzzBpXK0XWbY6HBRScJ/Su+XurgluGulna5hacs1EvNc0T706TN7sMakTJbj1WLPQuV
	owtTTJqcaQ9yhsS1itUYsX1JKCZnZBk=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5858qiX8001199;
	Fri, 5 Sep 2025 15:52:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=yrKzRKvPlqc1QwFwyTNKlG24n0S3B0
	erGWAU2bVkVqg=; b=qnifUl96cq8S6mdWIUWZY6BIWU8yF2upNweBx/YvMVrUqk
	RurxzzOfjdHTO1vZruHBUGw3vkJ3WeEmWzLy0ib2dt0fUdi9302JluZSn5voqpb9
	tt+K2LZopne4AXw3OGAsBjWP8De3MBm1hwH4/INAMOLsTRAjDmX8jUJ/gKxB4XAc
	KrIlZNUzwzjCaqkU+ZOpln4XrPIJTWESS5y/saIRobaltfDoOVm72NdzSHeS2nKf
	hGMYLo6HZzSBX5xdzjXsfqIsGIlRMWccKTKAhN9S2rP+bQ/qPKUMPRNpVA8A/v6E
	L8fXKTqpSJEYDa6i80pdzLQ72TamFaiRukB8PM0g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48wshfcpx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Sep 2025 15:52:50 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 585Fmcsp012235;
	Fri, 5 Sep 2025 15:52:49 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48wshfcpwy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Sep 2025 15:52:49 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 585FmxfV019937;
	Fri, 5 Sep 2025 15:52:48 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 48vbmujcy7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Sep 2025 15:52:48 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 585Fqke750659768
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 5 Sep 2025 15:52:46 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C56520043;
	Fri,  5 Sep 2025 15:52:46 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1DCE620040;
	Fri,  5 Sep 2025 15:52:45 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.48.240])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  5 Sep 2025 15:52:45 +0000 (GMT)
Date: Fri, 5 Sep 2025 17:52:43 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andreas Larsson <andreas@gaisler.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
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
        Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH 5/7] powerpc/mm: support nested lazy_mmu sections
Message-ID: <074ff6ab-5868-4fde-b5bb-9e17632ad817-agordeev@linux.ibm.com>
References: <20250904125736.3918646-1-kevin.brodsky@arm.com>
 <20250904125736.3918646-6-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904125736.3918646-6-kevin.brodsky@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lCd6YOMsS3DuDBadSx3AqoWK9sgWIwBw
X-Authority-Analysis: v=2.4 cv=do3bC0g4 c=1 sm=1 tr=0 ts=68bb0752 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=j0AthGTrb4EvYsEn83oA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: f87PfJay9odLOn37oqVwjr2CAlcWWHn1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTAyMDA0MCBTYWx0ZWRfX6sVQx3QDeZVb
 n0/AHQXDAd1IPDvrbQDAZqWNvYoji1vUEPP9JAjcx2sdZwqxFNT8P6jKDiqCdhkxMnGuyNq6xN0
 S8g8X6OMzE3gSb6sI+vSPcwT7zIQgnHlzsA9jiitgokDLD2w11I2lobQd0RzFFdQVPBFq7gLH2W
 w3OGrenK+wBn0voMSBbmNjp1Fjlqy/CSo5Vh9PvP5VNsOgQXuA9fqz0KJ8mfFGOfUfce75STf2p
 eu65lI0DTVxqmjYKeyaFdLRjc3SxwtmZeh1Pe6KdSGdqawAHM6zOfs0r4Yils+ob60NU/kRnAup
 7+9DLLEmBuvBzuYqwqF9czbkIes2bGJOe8p5YqMQ0X/8i+oJ9lIUH4tj2BythK5q2hT0kmdi9nq
 KtlUPSlt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_05,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509020040
X-Stat-Signature: a58frtc1u73tcgfhwiucjm3ozntf6p9z
X-Rspam-User: 
X-Rspamd-Queue-Id: 36F5C180008
X-Rspamd-Server: rspam05
X-HE-Tag: 1757087593-709665
X-HE-Meta: U2FsdGVkX1+/cN/k0V4LkWuA1BmfdRjagqF9iyyKM+9SKF4o8Z3lWbft2Yhgo7f1bW1mu9oNGa/zFzpkwyu2jTuWUFZo4LyyATuJ5njbzI1ujLiNAw/1vH2syQ3IrmsbvyQt1b1/rYS4sIocaFZB64VtHd9GQX/YRJBYVJDXxQyvoQj7UjxnoaFBHmcNMT21gmjxblu6hQMMvNhPSFAqCnR+BNNybzLLZQVA0Zex8r9goZeF56lb9mXLproFTEAsNjyMUuIHGeTk0azLEFUJdCk4Wey8m0MUsNKzSUrCJfwhiLkUICTFxviXmrWLWhpJiKYENOTcmFbAW4fpzwUz/p9z34J28/bPBlK/TEwWjIrPeERP5mGvR0qpQs2kSxC4ySFCBuLK4Jemu8x9bXpZsuvG7AuTgBFVS7sMEtn4VOhq8t06v2csy5gfNgWol94pzC8iIjKT5YLByLJwtJnIQZhi+eURrms3I9Ah8E4JU0Jw9ID9/Io8kQankaNYok9EZ/ldyG0zUAnjh7OD4Zo9wEPq8CWrIdwCaTLWP9GFKU0GkNJ1ny44SDbEZq39iyiLipEn23qPyZ87pNKL+fSEUfbXWh/ud8QDq8UoYUZFJ+Vj7udAY1Q2jjNW0kBQR91SwdTaTki1kvsbz85Zh916TkV0qrnateOFaGvomUtou8DfemyA0HOt9hk1I+bYm6O7QHb9aiO79syCq7WG9tVKxIoxI1UxufNc8yPkw7n2FSW7h3oqZuy9ajr2tmMGyEzREMgX2fHLdxVa72DAqxoJA4t+QE6BBBUW0NQH6QNJv4x4A2zA8AgHyvUStGBJyuaACHAoM4czGuSTEHlqdXQSwQLE0mFsBuVY4iJFdJ4S902I0dgqBjHDV5eGgpOXvlygI14H6K8nZfvNfMroeel2Bajyv4wnGi7KKhVVPaQTfVWpCuprdQAT3ewwe2rzlxNluGSMLiVoil6Mxtoz70i
 exgEY7hP
 g3TJIHWFZ2RVN1oXJtq3ZHt9dzdAgybtgSvOveC32nwyctJcZdrCeK0cfL1EYZofECTk4h7AKOEx7aZP3ErEPtjfb0TZzcbIaxwI2cjEVgIDHeByMUV3JwLG+Jo8kpaKPDCR7f2boER+vcmMtzmDmDeOZXCcL6zKCQMSOyebtS3fI9lKGyJ7WWw/sZtJ08lovMIprZZhnaozKodWV1MLBZHzw4KsROpQ+CELljXKgPr6zsKDf/E1jk1s4qtA1W1oJ23+8nMLcDUAWdgu/pvPk9jr8JXLxtxLOHilA50s7jOn7qqz+a0BNfAvas7sXcHjnEEeiI0LBL0dgYXnAKHrJMfPAblgr5aVyacaH5Nb5GNtxFC5890RaSskdwt1d2Ed92D1ob2pJZ6gUNXk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 01:57:34PM +0100, Kevin Brodsky wrote:
...
>  static inline lazy_mmu_state_t arch_enter_lazy_mmu_mode(void)
>  {
>  	struct ppc64_tlb_batch *batch;
> +	int lazy_mmu_nested;
>  
>  	if (radix_enabled())
>  		return LAZY_MMU_DEFAULT;
> @@ -39,9 +40,14 @@ static inline lazy_mmu_state_t arch_enter_lazy_mmu_mode(void)
>  	 */
>  	preempt_disable();
>  	batch = this_cpu_ptr(&ppc64_tlb_batch);
> -	batch->active = 1;
> +	lazy_mmu_nested = batch->active;
>  
> -	return LAZY_MMU_DEFAULT;
> +	if (!lazy_mmu_nested) {

Why not just?

	if (!batch->active) {

> +		batch->active = 1;
> +		return LAZY_MMU_DEFAULT;
> +	} else {
> +		return LAZY_MMU_NESTED;
> +	}
>  }
>  
>  static inline void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
> @@ -54,7 +60,10 @@ static inline void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
>  
>  	if (batch->index)
>  		__flush_tlb_pending(batch);
> -	batch->active = 0;
> +
> +	if (state != LAZY_MMU_NESTED)
> +		batch->active = 0;
> +
>  	preempt_enable();
>  }

Thanks!

