Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1FF8CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0830C8E000F; Tue,  9 Sep 2025 10:39:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05ACD8E0003; Tue,  9 Sep 2025 10:39:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8BC98E000F; Tue,  9 Sep 2025 10:39:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3FE98E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:39:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 91D6D1A058B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:39:22 +0000 (UTC)
X-FDA: 83869969764.12.3E92386
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf29.hostedemail.com (Postfix) with ESMTP id 058DA12000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:39:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eAw85XMT;
	spf=pass (imf29.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757428760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZxnElgXfWNXHVRkPVUlwCfE0YEzKBATAK/iNRyCHno=;
	b=vBrhFvyHpABHrRIFLSGF/C0jplypAJFr7eeGbz4V+bqjTr7VHXMkzMFDJpHTacfG2F3FpY
	t7crUj6b4RTYoQdZbqjGb5/3ntGYuhzFJ3stBSAyZKJHYRX33uCy+O7pbhOnBrLrqIpwx5
	AojaRxJj8l2TSAvDZ4f/uvUNo+EUOCE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757428760; a=rsa-sha256;
	cv=none;
	b=GQhHk2rYgnmhgBGluQmXJVfBakh7A/WGAJIfpEvK/kdNXISNIZnG/OY6dQuFcJNe4/tFDR
	Rex8JyaXQE906TKkGsCw66t6nDQCt19szCXKS99S2Bps0dQFYkBuGDD6k75rdNRz6OO2Ii
	tOBoWdOYWmEaGHRGRnE48TzUp+Ho7n8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eAw85XMT;
	spf=pass (imf29.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589BBEbn028671;
	Tue, 9 Sep 2025 14:38:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=PZxnEl
	gXfWNXHVRkPVUlwCfE0YEzKBATAK/iNRyCHno=; b=eAw85XMTzWR9vGa1/hE9vj
	mydHz5ZGmT77GHt0U64/1YAtQ+lSFTmIp9CIEXj9AqCB1xpfIW94Ks0mq2SdgDpJ
	0FPArRwybEixPfZaOslsDAe44oIe3Tm1gRsGZY/RLa+8mT3lM30D87vp64U0OPcE
	AyEhpKjxohjXf8zMTSl45uNLe+xdcC+WMRvNiK8F4OVX4+mUboi1o5W9xWOJyuG4
	YBGbdgCpU8wPxsq98ebD9TZKO89s1xp8D5BcFUSvtxMjUPUOH9oIgZBJ+OTTT7hW
	3ZKsxlOOkqxL4/35WGGIhaGdo6h3UOz5oPnEPsFraOl5KI9HlFyrZTNClQjrf38A
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490xycw9r8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 14:38:52 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 589EUjFv007959;
	Tue, 9 Sep 2025 14:38:52 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490xycw9r3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 14:38:51 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 589AvumM017218;
	Tue, 9 Sep 2025 14:38:50 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gmbdxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 14:38:50 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 589EcnS049545616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 14:38:49 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0279320043;
	Tue,  9 Sep 2025 14:38:49 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2791F2004B;
	Tue,  9 Sep 2025 14:38:48 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  9 Sep 2025 14:38:48 +0000 (GMT)
Date: Tue, 9 Sep 2025 16:38:46 +0200
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
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2 2/7] mm: introduce local state for lazy_mmu sections
Message-ID: <b2e52967-7ca1-411e-9c66-8d3483624ca7-agordeev@linux.ibm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-3-kevin.brodsky@arm.com>
 <d23ea683-cca4-4973-88b1-4f6fd9b22314@redhat.com>
 <ca2054ad-b163-4e61-8ec4-6f2e36461628-agordeev@linux.ibm.com>
 <e7acb889-1fe9-4db3-acf4-39f4960e8ccd@redhat.com>
 <2fecfae7-1140-4a23-a352-9fd339fcbae5-agordeev@linux.ibm.com>
 <e521b1f4-3f2b-48cd-9568-b9a4cf4c4830@redhat.com>
 <47ee1df7-1602-4200-af94-475f84ca8d80@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47ee1df7-1602-4200-af94-475f84ca8d80@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: w3un9YJFAnj-nx4lP2drAL9l1yJOP1En
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDIzNSBTYWx0ZWRfX5AD3L9SkswSm
 yrVgoGtIISKP604rm8z2wlBI+9ePIXNFYQAYLSzjXIjHlXrJz/N5CyEoKiLBFH0S6cAaacNg8MI
 /uqSqt+AyIfCoA2W1PycTsyoA9dnPphhk2M6Dy7RNUKN5o43iFF9IXyIGVBQKdc5LYc5Tqn/OPM
 HPGZJ2R+BrI/nWN/OrWkeMYz3esjc3UK9kdBknkAwa1vw44DfXe2kcF7OMH8RK37Zmyzfk8ftAT
 Mah9tj2mXv8ZZFGcLXNuNYIctcCpzvNgMf9Y+RDBJM2AEQkCBcXflTuYScwL6Aa0Fdpz3OLg/9L
 oof/OuMSKGRkSalY70FlPW8UQK4wZ6ys9K9DbelwH72mhkNMfgbwQ1G8LikJGVg3ZsfCHBBKKvz
 o+6LVfHA
X-Proofpoint-GUID: kEu557zaNP3aZma9JIWXWvvSIckTRd-u
X-Authority-Analysis: v=2.4 cv=F59XdrhN c=1 sm=1 tr=0 ts=68c03bfc cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=8nJEP1OIZ-IA:10 a=yJojWOMRYYMA:10 a=0nQrape7h3WL6H1kZSkA:9
 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_02,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1015
 impostorscore=0 bulkscore=0 adultscore=0 spamscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509060235
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 058DA12000E
X-Stat-Signature: 58t7a8cu1hcszibr4mk3b1scdw9wztg9
X-Rspam-User: 
X-HE-Tag: 1757428759-845385
X-HE-Meta: U2FsdGVkX18W3GMNV3PxoQFU2ally9YutFL8rOgOzQkJbwph92dG5iui3wHbVdU4wyKH+eb9FVjmfXbZYLkHm2Ndt6tcrPjwz6IY73jKtlqrh4r4O9oqSPBkTbt6PrpqOxfyoyadG5N1Qv7DrRuMSs5PWSrkLDFTJDQgw2F2Gj+VhplyYhhn7Xaiaz+rR/+OEsP23g/FsrrccZkBdqFBQGFEk27oNDf5lGTQ5wZJ5fJR40o6fZV6D7uzr5IMube+5Dj++vgNMMxZLEzXQAaqHyrxYgA5WPCw1KPJX2kqCvbwzqzbJEqfsG9FniZXKrTRds6dYLV+tMCDoPUAIxZeSY2y1SgjsxKk1jyJml5b5VpOUaAZeVXgMn0MmfGPFG1T3VvtKwzrpzq1EWdAkDQA+338tmOJy+QelFBt0jnImkUBgxwUZj7dcSom6hVGEstp9zaV34oVFcw5U5NT7JJN+nNKcw39/UCfjfJcVuCdR/gVVK+DhKsBG7pAdQE6HadIGEgwOsjoDuUhpGkbPNZjfLP6FhsWDdrUpr99WK2jbFrkNZRXLhgz42eYr6i5HykBlw+1r1+ya9n/JZoJGgnlDgZ06hvNVn6aFinm6sOv03ekaDaVBDIOrMbTNf1Ymw2D7TrP0Jz5h6kKVDb/orXmeszhMPZIXjXDYfvtzaEhEHXoVp/lxOaiHdwcyp5G7hhYG0A3WVn0SkBwfGJ4gi+O/ZNYJcu+LWRyxIpYv+4iqBMu4gPvh+Nar8dLZfsxbMyqf2KznoHE+GZWCjn+A9o7jo6PEZnXKJ4oIcqcJSr00RKUZtqpZ12+vvnOPHmycVFhqGXWjF/ioiAJei/y/9gzCvDCLlK5ouDn2uNfT3xM/nWs75hqb3iks+jEmnomsyZaHhQ5DGge0ZYhbFrgmXzl9x4S9gzWi8oayoo1Z7sxPGuidTHrDwtl6KRFPJ+uM7ixLIqb43iGbFwcky1F2Ov
 hThlRxgR
 cUbg29b1p1Uoe0j99+IsU2MUwzqGdg0NuJhTeVScfHiftyX1VfNEKyrnGsC3ExBMleT4vPUPQW1zvchvvo4qAe1LxH9hrjkvxm7HXTx9W94YvttRvC9B3Xkao7OTFnG+CFoAcv8HYjwL9829mQiq3xKjuVIrqIdg0McAhPDtW9oha8XCIC9mLzTEXS2mUi9eoe5IrSJXSLYQnhDnH5nHGlY2Q5Wy6cOuBbjL1vb4wiPRjnKo8vK1iybVNYnHRwBi7f70mzYR3HjemGn7E9QDZOpPL+K6ypR3Gka32vsjG1eBYRbihCqJTTFNX91yGr+kOmW6tj3qwVkj6YOZ7jrwbxmYra9KE1dL6bS0+DIGX4K5WxcdQV4hlxRoOznCggMyTmMbxmDFE77cWxhkYSkW0w7z/yL09gSzk9Gepjm/HFQPXmJo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 03:49:46PM +0200, Kevin Brodsky wrote:
> On 09/09/2025 13:54, David Hildenbrand wrote:
> > On 09.09.25 13:45, Alexander Gordeev wrote:
> >> On Tue, Sep 09, 2025 at 12:09:48PM +0200, David Hildenbrand wrote:
> >>> On 09.09.25 11:40, Alexander Gordeev wrote:
> >>>> On Tue, Sep 09, 2025 at 11:07:36AM +0200, David Hildenbrand wrote:
> >>>>> On 08.09.25 09:39, Kevin Brodsky wrote:
> >>>>>> arch_{enter,leave}_lazy_mmu_mode() currently have a stateless API
> >>>>>> (taking and returning no value). This is proving problematic in
> >>>>>> situations where leave() needs to restore some context back to its
> >>>>>> original state (before enter() was called). In particular, this
> >>>>>> makes it difficult to support the nesting of lazy_mmu sections -
> >>>>>> leave() does not know whether the matching enter() call occurred
> >>>>>> while lazy_mmu was already enabled, and whether to disable it or
> >>>>>> not.
> >>>>>>
> >>>>>> This patch gives all architectures the chance to store local state
> >>>>>> while inside a lazy_mmu section by making enter() return some value,
> >>>>>> storing it in a local variable, and having leave() take that value.
> >>>>>> That value is typed lazy_mmu_state_t - each architecture defining
> >>>>>> __HAVE_ARCH_ENTER_LAZY_MMU_MODE is free to define it as it sees fit.
> >>>>>> For now we define it as int everywhere, which is sufficient to
> >>>>>> support nesting.
> >>>> ...
> >>>>>> {
> >>>>>> + lazy_mmu_state_t lazy_mmu_state;
> >>>>>> ...
> >>>>>> - arch_enter_lazy_mmu_mode();
> >>>>>> + lazy_mmu_state = arch_enter_lazy_mmu_mode();
> >>>>>> ...
> >>>>>> - arch_leave_lazy_mmu_mode();
> >>>>>> + arch_leave_lazy_mmu_mode(lazy_mmu_state);
> >>>>>> ...
> >>>>>> }
> >>>>>>
> >>>>>> * In a few cases (e.g. xen_flush_lazy_mmu()), a function knows that
> >>>>>>      lazy_mmu is already enabled, and it temporarily disables it by
> >>>>>>      calling leave() and then enter() again. Here we want to ensure
> >>>>>>      that any operation between the leave() and enter() calls is
> >>>>>>      completed immediately; for that reason we pass
> >>>>>> LAZY_MMU_DEFAULT to
> >>>>>>      leave() to fully disable lazy_mmu. enter() will then
> >>>>>> re-enable it
> >>>>>>      - this achieves the expected behaviour, whether nesting
> >>>>>> occurred
> >>>>>>      before that function was called or not.
> >>>>>>
> >>>>>> Note: it is difficult to provide a default definition of
> >>>>>> lazy_mmu_state_t for architectures implementing lazy_mmu, because
> >>>>>> that definition would need to be available in
> >>>>>> arch/x86/include/asm/paravirt_types.h and adding a new generic
> >>>>>>     #include there is very tricky due to the existing header soup.
> >>>>>
> >>>>> Yeah, I was wondering about exactly that.
> >>>>>
> >>>>> In particular because LAZY_MMU_DEFAULT etc resides somewehere
> >>>>> compeltely
> >>>>> different.
> >>>>>
> >>>>> Which raises the question: is using a new type really of any
> >>>>> benefit here?
> >>>>>
> >>>>> Can't we just use an "enum lazy_mmu_state" and call it a day?
> >>>>
> >>>> I could envision something completely different for this type on s390,
> >>>> e.g. a pointer to a per-cpu structure. So I would really ask to stick
> >>>> with the current approach.
> 
> This is indeed the motivation - let every arch do whatever it sees fit.
> lazy_mmu_state_t is basically an opaque type as far as generic code is
> concerned, which also means that this API change is the first and last
> one we need (famous last words, I know). 
> 
> I mentioned in the cover letter that the pkeys-based page table
> protection series [1] would have an immediate use for lazy_mmu_state_t.
> In that proposal, any helper writing to pgtables needs to modify the
> pkey register and then restore it. To reduce the overhead, lazy_mmu is
> used to set the pkey register only once in enter(), and then restore it
> in leave() [2]. This currently relies on storing the original pkey
> register value in thread_struct, which is suboptimal and most
> importantly doesn't work if lazy_mmu sections nest. With this series, we
> could instead store the pkey register value in lazy_mmu_state_t
> (enlarging it to 64 bits or more).
> 
> I also considered going further and making lazy_mmu_state_t a pointer as
> Alexander suggested - more complex to manage, but also a lot more flexible.
> 
> >>> Would that integrate well with LAZY_MMU_DEFAULT etc?
> >>
> >> Hmm... I though the idea is to use LAZY_MMU_* by architectures that
> >> want to use it - at least that is how I read the description above.
> >>
> >> It is only kasan_populate|depopulate_vmalloc_pte() in generic code
> >> that do not follow this pattern, and it looks as a problem to me.
> 
> This discussion also made me realise that this is problematic, as the
> LAZY_MMU_{DEFAULT,NESTED} macros were meant only for architectures'
> convenience, not for generic code (where lazy_mmu_state_t should ideally
> be an opaque type as mentioned above). It almost feels like the kasan
> case deserves a different API, because this is not how enter() and
> leave() are meant to be used. This would mean quite a bit of churn
> though, so maybe just introduce another arch-defined value to pass to
> leave() for such a situation - for instance,
> arch_leave_lazy_mmu_mode(LAZY_MMU_FLUSH)?

What about to adjust the semantics of apply_to_page_range() instead?

It currently assumes any caller is fine with apply_to_pte_range() to
enter the lazy mode. By contrast, kasan_(de)populate_vmalloc_pte() are
not fine at all and must leave the lazy mode. That literally suggests
the original assumption is incorrect.

We could change int apply_to_pte_range(..., bool create, ...) to e.g.
apply_to_pte_range(..., unsigned int flags, ...) and introduce a flag
that simply skips entering the lazy mmu mode.

Thanks!

