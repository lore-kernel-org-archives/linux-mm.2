Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D299ACAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 12:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207AA6B0022; Thu, 11 Sep 2025 08:07:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DF546B0023; Thu, 11 Sep 2025 08:07:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE906B0024; Thu, 11 Sep 2025 08:07:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E9B416B0022
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:07:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63CF9140208
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:07:27 +0000 (UTC)
X-FDA: 83876844534.22.8395883
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf23.hostedemail.com (Postfix) with ESMTP id CDAD4140012
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:07:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=k8qq71z0;
	spf=pass (imf23.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757592445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c30ZQnsvAEyuVkRVamQoGQaRen0nYIRa+BA7jFqu78U=;
	b=jOmlWoefXsfb/xZbsOYpPt1vcWAFOVnbNlH4Gwia2U0nrRWCdXgfzoByaFdsPKEkWY5ZJv
	o9Y5IsrY5/PSynJM5QC6N1G5EQTdLjLn9lRVP183b1MiBg/2/HVt+G6O8HnFf2O5eWW8UC
	vPS95tcS8blDiugw6abd5vgdDo9i10Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=k8qq71z0;
	spf=pass (imf23.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757592445; a=rsa-sha256;
	cv=none;
	b=TmiGygds2CERMfjHAN/BN6nAsp9GfiFFFI9s1OWqy2a9UCjMdL0Dk3GSkXXmc3uJCVA5da
	ZHDW+VVHy3niQAryasL+VNWM3eQq7rsn9lxSsO4/1Ab5TMYehgZvXWjDkNuYW7A+E3B4Uj
	J5RjT/NrwT8d0QmZovNAdGQWd2tA1nQ=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B84fHU032047;
	Thu, 11 Sep 2025 12:06:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=c30ZQnsvAEyuVkRVamQoGQaRen0nYI
	Ra+BA7jFqu78U=; b=k8qq71z07GrReGd9S9mOiL2kfz2BW5pit9iGHWyQ501+3o
	18SrSVgXyKIh3fgbTocFTOqLMtqSFK4cxX7BIxE3tS22XZO0MuuzR1offUBCNMnq
	oKDIaYOBM6OqV/8/2nb5TYMMtbfty7TIxuJR1UwI7ijudG7hBz2n8mEO1/1JtIWQ
	dCG50x7Is5mNMQX/2OgEzJRaOS4B3WAK5BbVoavZQgJ0vMUStU+M4xrwJU761IBV
	72RsuHX8BmU9AXx/ZC8PQ4TAp5bfKtZi3PWfc0gEnh3wsk+FWngrjfyj6wXqFlUw
	ta9dp/wt1kSFBm9tnzdcdwRJffzZgn8TZgXdZhNg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cffmge8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 12:06:56 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58BButst022969;
	Thu, 11 Sep 2025 12:06:55 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cffmge1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 12:06:55 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58B99ZNi011435;
	Thu, 11 Sep 2025 12:06:54 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 490y9unx8m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 12:06:54 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58BC6qp621103260
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 12:06:52 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 592C42004B;
	Thu, 11 Sep 2025 12:06:52 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 95E1D20040;
	Thu, 11 Sep 2025 12:06:51 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 11 Sep 2025 12:06:51 +0000 (GMT)
Date: Thu, 11 Sep 2025 14:06:50 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
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
Message-ID: <80be36e5-d6e1-4b37-a1ca-47e92ac21b02-agordeev@linux.ibm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-3-kevin.brodsky@arm.com>
 <d23ea683-cca4-4973-88b1-4f6fd9b22314@redhat.com>
 <ca2054ad-b163-4e61-8ec4-6f2e36461628-agordeev@linux.ibm.com>
 <e7acb889-1fe9-4db3-acf4-39f4960e8ccd@redhat.com>
 <2fecfae7-1140-4a23-a352-9fd339fcbae5-agordeev@linux.ibm.com>
 <e521b1f4-3f2b-48cd-9568-b9a4cf4c4830@redhat.com>
 <47ee1df7-1602-4200-af94-475f84ca8d80@arm.com>
 <b2e52967-7ca1-411e-9c66-8d3483624ca7-agordeev@linux.ibm.com>
 <250835cd-f07a-4b8a-bc01-ace24b407efc@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <250835cd-f07a-4b8a-bc01-ace24b407efc@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EOlye06iv3wrpFZ8EV5hsz2FcaKHpkNR
X-Proofpoint-GUID: 51K6fRL5QpJCzFIQhT_Qazz7bChQjXpl
X-Authority-Analysis: v=2.4 cv=EYDIQOmC c=1 sm=1 tr=0 ts=68c2bb60 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8
 a=jRhVRVM2bwpbWWX_RR8A:9 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyMCBTYWx0ZWRfX8pGJfFgtntNW
 /kOIUEwDJMICGimD1/ufjSKSVIfmo3TNK7+Fxsinl9Egq+oGXoolAwIU93iuesvkQ3s13VVlzhh
 JIgGdj6U9PokjpkHg4ykDpABkraxfLb3HERwg3941FM1HXB2esU2ebixaknpbywBxWh5hGHimsp
 ci9R67AshxoJpy340lLj5ssEfi6eKhyjCh5p8fZq/k83GFNAv5ZYjhl/Hqc7I+sNgjVlWR40LHM
 kZLurS1M60tPSFVJMaBaPvAXWRbQAESVilgI8Vf2JWna8t2s571X/x3Ahb2bFBInNwL1PkLtgz0
 aizOmw9YsKcqSGhvZ6E05+Xu1Xlt46nNfGetQx37HOL9xVINKsAa7u5yRb/jAsXOIQWyZmkfM1v
 9y5BFajA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060020
X-Stat-Signature: pas4z3wdjnx8quyty95k3xjgyi98wrr8
X-Rspam-User: 
X-Rspamd-Queue-Id: CDAD4140012
X-Rspamd-Server: rspam04
X-HE-Tag: 1757592444-197632
X-HE-Meta: U2FsdGVkX18z+i4Hv9ntFweNpYQyBBjX0If0hwReNLLbzSY3QYDyT7KxGmDCxyJb6XXy7XgC5rBPAfm47VGkuflR78k0zZYuQXx00Zeec5nTHweUO4HNdqQraM/9myzb2m8vKxaQtcYC3OuuoYftZZHDJXHRRJ5fkADBYFmY/T63/3FTJKYyTMC10DsNzRZDTD4z4u6J+1RxgIQFu1OAg2vHf0SNb+qWLXSDfY2wH2dN55iYZOMsvHfsbOuIVDFrh6BLzOOtgrDGMLIsAnY3WYoU31fj2NfkK9ogMfMO5U9EYNN3VImpzkekoXad9siGaibiPQ6hKtUTXJetNFQAlw7MhTgGD8AYA+ZsxmQGgYPffwIJrWjLBka6+brSR4EtO32q3x9lLOO0oHsOF+zEIaYySVrEEj25BoKxgOzbkKiUnbCryD8SLEfbFEX/Nll3KmhhjWW3NobBx/+2/6JQdYgXWotSavzx32cylv3qPYNl+BRm0x/0fYcYJHOokU3zaInoNedLG0iWpHeLGkDxLy9KqEcTimWZz8scJTpOjSJcR5bEg3EnJ9RsStd7Tv1MtZmwqqPWc7dxa+nnN9XYnusF5Xcov1e1k6XOvufq++hfFcGXQO1DM/qUjdl3OOMwhIcqY+kwSiBiANrUBKB+BCL1MHH9kz6FHksvYde2hAoRcIaBDO7FsY7quQgYX/QSnG9X99rqmiarGvlPh370ez59ofeo2ew8Ifi25GgEw56wVSBVgYMYrUmJYXYo3lOcp3x+Oq3IxsOQ216a9V1BUrBG/2Hr7z+C9zvwGQlgBrGYazmp20qb5jsQXzhYbSdHj4oglQ5UwBBhl7xmj+hoYSnvh+yqSOkuWlt940KZwOkpL9k3gP1Tz4GRovmwcEnQEmy13oSIF3pltY9o56yy+83auB2tK/6xdUMewM0Ssg71eLUV/VtAFeGNTbBIxGKaIc4hwJIpKV4c96kp9jr
 n+7u2CAd
 CVNXxWLRhCqS39Epi1vlaJylaFgEh6IsR1VKiV2y3WJLSlKgFE0l+gjLmdivFZse2hxGLKqI3oV34WdsQhskwVnQEKcD5t5im81TFUgKDTwNhQPnrVAzpFH9gNFEqU8G1p+XyfImCMfcHEqeGwQGCMyShMp3leWxysvwn5eFVT9u2iOxndYv4F9Jr0Dety+0BhsYx0bCKjXteZkQmM+A8SjyOkwYaJKcaT9zcL4aq0GcFy/Hrtn4CUIxoOlBa7UKClhLpyhTxW/+mrsUH1M9B3E7dzYMXAdpZZy3wT+MaVUQFrJteZykQ7GIflAHeB6meksC16YHEKV9W+N4nzP7/7Nq9EkpKFcg0GwIfptmUh9KOhMTKQhK3xzRWWxmj2YrchbfkLR1TTy399QbvzGOSX7Rz3pGInVPAWmJXJ8ivWCL2eN4kldHMKKYVbLZDYPch+mEs8itAC+sE7cWaG0UiWF6Hp7LwCbZ8sfkH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 06:11:54PM +0200, Kevin Brodsky wrote:

Hi Kevin,

> On 09/09/2025 16:38, Alexander Gordeev wrote:
> >>>>> Would that integrate well with LAZY_MMU_DEFAULT etc?
> >>>> Hmm... I though the idea is to use LAZY_MMU_* by architectures that
> >>>> want to use it - at least that is how I read the description above.
> >>>>
> >>>> It is only kasan_populate|depopulate_vmalloc_pte() in generic code
> >>>> that do not follow this pattern, and it looks as a problem to me.
> >> This discussion also made me realise that this is problematic, as the
> >> LAZY_MMU_{DEFAULT,NESTED} macros were meant only for architectures'
> >> convenience, not for generic code (where lazy_mmu_state_t should ideally
> >> be an opaque type as mentioned above). It almost feels like the kasan
> >> case deserves a different API, because this is not how enter() and
> >> leave() are meant to be used. This would mean quite a bit of churn
> >> though, so maybe just introduce another arch-defined value to pass to
> >> leave() for such a situation - for instance,
> >> arch_leave_lazy_mmu_mode(LAZY_MMU_FLUSH)?
> > What about to adjust the semantics of apply_to_page_range() instead?
> >
> > It currently assumes any caller is fine with apply_to_pte_range() to
> > enter the lazy mode. By contrast, kasan_(de)populate_vmalloc_pte() are
> > not fine at all and must leave the lazy mode. That literally suggests
> > the original assumption is incorrect.
> >
> > We could change int apply_to_pte_range(..., bool create, ...) to e.g.
> > apply_to_pte_range(..., unsigned int flags, ...) and introduce a flag
> > that simply skips entering the lazy mmu mode.
> 
> This is pretty much what Ryan proposed [1r] some time ago, although for
> a different purpose (avoiding nesting). There wasn't much appetite for
> it then, but I agree that this would be a more logical way to go about it.
> 
> - Kevin
> 
> [1r]
> https://lore.kernel.org/all/20250530140446.2387131-4-ryan.roberts@arm.com/

May be I missing the point, but I read it as an opposition to the whole
series in general and to the way apply_to_pte_range() would be altered
in particular:

 static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 				     unsigned long addr, unsigned long end,
 				     pte_fn_t fn, void *data, bool create,
-				     pgtbl_mod_mask *mask)
+				     pgtbl_mod_mask *mask, bool lazy_mmu)

The idea of instructing apply_to_page_range() to skip the lazy mmu mode
was not countered. Quite opposite, Liam suggested exactly the same:

<quote>
Could we do something like the pgtbl_mod_mask or zap_details and pass
through a struct or one unsigned int for create and lazy_mmu?

These wrappers are terrible for readability and annoying for argument
lists too.

Could we do something like the pgtbl_mod_mask or zap_details and pass
through a struct or one unsigned int for create and lazy_mmu?

At least we'd have better self-documenting code in the wrappers.. and if
we ever need a third boolean, we could avoid multiplying the wrappers
again.
<quote>

Thanks!

