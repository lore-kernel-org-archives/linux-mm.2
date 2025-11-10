Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DACE1CCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 08:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01FB38E0006; Mon, 10 Nov 2025 03:12:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F396F8E0002; Mon, 10 Nov 2025 03:12:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E278B8E0006; Mon, 10 Nov 2025 03:12:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD5918E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 03:12:40 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 698EDC0CBA
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:12:40 +0000 (UTC)
X-FDA: 84093980880.02.1E959BA
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id E28D040006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:12:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Yv6+1trT;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762762358; a=rsa-sha256;
	cv=none;
	b=pd4GysoaizzDIpWU7MYvjCm8O4K5qhI8ofnghKfs4mB1Mk9+5BQ3S1X7YCcBTcIQIfCakM
	Fd3CZpGKFvUJNWFlo4djcUfxiZ1PM0wl0WaMXoYZyhzvdRkOlLDh6FJgHhCuu19f7Qh7Uz
	SXOTgzkX/FCm/ABGjGkdORCrE4CftCE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Yv6+1trT;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762762358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WrPV25ztsYqDlknSOqBjqi2t4Xb9rXv0xi6T3uNdmFI=;
	b=j8RIq/IDv25fQD6zCD+L6ggfDvT94HU6YWlUn6SpUISO6mPIrcEj4ogVCJ4W6o912q+xoO
	nnAJeOr7nb31jYprWvUp3O6GmB2qS18521tXU4BRKWref1feiP+yPMVQjh83UezZESxIf2
	Cco+bTeUR5lzKkYT9DIwQKsx8Q84DQ0=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A9Mrb3H023648;
	Mon, 10 Nov 2025 08:11:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WrPV25
	ztsYqDlknSOqBjqi2t4Xb9rXv0xi6T3uNdmFI=; b=Yv6+1trT97d7+DoSIjC5W6
	OLc4ylQKCKMAex0x0xYUBtCqgGuOUmceIjAitPSSQP4ha308n1vNjyCUQ6cvZ2r4
	ei0eh+6E9Z0WEUSMVNe1jsCNm1I0JTMS3qMI8JK4k2CVJe8jcjFAe6GAYoZoYIPF
	f2cH/cIWwfriYd6HDlkD0TTd91dXSMehLyFJYeYA+XopFefAuy+V38DHQN1UNf/W
	3T+xvOmCCkXhX+7+7DFZbaLjxNtRDGKQpKgGoSwe7T8r3LPSCJLEPD7oCZTkMUFj
	LW2FbGx5/pNgTdyi+piCoZDGmqPtaOa5o+7Wu4AdD2ze9GkYr3qc6pGcoRQ53Zvg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wc6y6xk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 08:11:58 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AA86mfJ029272;
	Mon, 10 Nov 2025 08:11:58 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wc6y6xf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 08:11:58 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA51uvx014762;
	Mon, 10 Nov 2025 08:11:56 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aahpjvgyb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 08:11:56 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AA8BsbP47645168
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 08:11:54 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 951A120043;
	Mon, 10 Nov 2025 08:11:54 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7574A20040;
	Mon, 10 Nov 2025 08:11:52 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.87.129.150])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 10 Nov 2025 08:11:52 +0000 (GMT)
Date: Mon, 10 Nov 2025 09:11:50 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Woodhouse <dwmw2@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
        Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org
Subject: Re: [PATCH v4 06/12] mm: introduce generic lazy_mmu helpers
Message-ID: <413b2c49-f124-4cda-8fea-a6cc165f6326-agordeev@linux.ibm.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-7-kevin.brodsky@arm.com>
 <71418b31-aedb-4600-9558-842515dd6c44@arm.com>
 <c764489e-0626-4a50-87b5-39e15d9db733@gmail.com>
 <645178fd-df4e-42fe-b55e-97d9506499be@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <645178fd-df4e-42fe-b55e-97d9506499be@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAxOCBTYWx0ZWRfX0qxBt6PLz+e1
 5ZkKhsJ1OtkLmCa4F9dckZhmGNoe5OQimO5vrOJyhCGGn+Oo9dBlfBgtY6sJsMOGytiqooOVqqZ
 5VlqH6qDTNOxg7GqSCIIkxN9587HG/yU0g8PN3RC/Kn+8SDIn+tbvRphHit2rtoXvmhJTS9c/na
 zuc/vHReC35SkVZuc771TOtpWXwRcO+j9mxabq08ugqh/MQzZP8E1qqkKzT/vrw3I0gce+auuVH
 8WG34NSJDjSCXhv0z/g1L2qiclooBzH5Y6sWhPQC3GQgXW7SVzsG1L6s2HqrTxBfWDx3OGWlJ4d
 4V2wmLiIQn3wqkNWKtMaFFAnqiHVcDdPhaMGEjvefyMBpcxvcGE7lueGMCRslhcd2O9xOyzBoik
 qwn8HhTZbHMdNrVo7h0rei5NGYuy+g==
X-Authority-Analysis: v=2.4 cv=GcEaXAXL c=1 sm=1 tr=0 ts=69119e4e cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=8nJEP1OIZ-IA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=7CQSdrXTAAAA:8 a=AOQWXcEz_zGDWlu_gTMA:9
 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-GUID: fP4xPRY0VPWa2LszakKlWyXVqqNy18Qg
X-Proofpoint-ORIG-GUID: hjtY_m4sJxhd70lXi6KoIa-Y8h7Rk4-J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080018
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E28D040006
X-Stat-Signature: zg9ky6ohbynouge3qin67hrpu5tcgjgp
X-Rspam-User: 
X-HE-Tag: 1762762357-988781
X-HE-Meta: U2FsdGVkX18mQ95gGY6SFAcF/wNoz3O3dX+o88/KxQE1XwP2IxFf9kHOtkNEUih1Z80sW2ebVet5z1sHLoBl3vONiDRzAIewB8MTPWg7gsA8ldyvdtmxCAi5dn1kAn2bV/F6aXGjmpQe+pHajd9PdrPhFbhUjye7z0RVLnXACVkXbUksrLhbuwoHciOtUUdqVwALsCXcC2nIVS/vSGt86N0kjeD6kcG9nyv0ZxrJ//UfV4CKUrGB22JHjFG8riu9M7QTrF3OzTYc3S904wcqhEBmcnwa9UJDoJtBYZKWbpYlD2HMIVUsUQIvYdisPmIneSspk1HrEAd8LKXWi3ycgIpWVPEeYDi04MegAK182cnOkzs76GRgSWh22qxFRadll26nr0CDMigJgFf9f1CAYtt5emI5OvaU8kHtcm6T2q9MXZ0UM5/p8ntQcPsBWiDVdKGScqt0oQU3xzVIjE/7yf9P0v5H1Gw/tGj0zfoMUAWz1AaGEAS+wJZnwa/17EXTR2O5CF4ra6sruFaS/+rBEkJfsiXpT/WYMMHf72yP5oQ77Z6VVqA4wQ0esEDb2K8XSTS9oFjtc+Jg5ZhqrEQI7d57q4aO1886cBYfKvxBy0I+50+vDRYQPUg57qzIVEv0etbmfzbGxR9rZIkx7nnEXTVLZKVfAy81QyhPNFnaAxxVlTAmbRY2XbUnIZfukaeRneTBRhPaUrWjtVG5AdmjJ8ngq4eUFkplsCMWVSKzb+IW8DGR0fPZmLHtdp9lRPHRYFjFwlmcICoQUf96Nbnq8YIynE0U1eIwAGAEqffc7F3O2YlMwViaxLHNu4bK7rZXlSqYnXsglqPfX1gVLcVKHK+l5RYftYc+N2Dic8rOLPru1+PmJbZvBuUKUMlZdITVJ4/KiAyyXGhNssGowUmhNywk1N54OsRBc7naivynfnp8MrF4NmnfSAgfG08WRI37sQYEdGPfGcTofBE85hC
 FB+O+uzH
 h9403xJygS6SUy1Pp/8fQCp8ldPlegN4ouqUaJETHinZXyt//at7D88LH/rLXSAu6witu6tRPv031E1fBDsE1jB/l5NIf0u5G3RxmxZcwd3w1W1DTB+FX2Mjlva2VTSsReG1fNxHQJ1CxKbLq4soJ1O8/oo49a5nbbyWB6yH3p/A+NhxqStWW1IuDC7iUS99RbJckX91HOrHeQgsQotFTA1/DFqGpZNHfBr8rNrytxWm2w8RXaI5niYXleiaDgZ2gfz96rjC2h4Q1u9QIvpq0Yc3HYyMIwKDfMEAxAbT1c3dG4RwMGLUZRIBW3WkLRJCWTfY7Ibg60peA9auh8hianCAH0fkn1JNPN66BVh0BSLwkZDvg+oQabozHnvkik+Cf3qN4KqOu4amUEg7DuYTrO3MU3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 03:22:54PM +0000, Ryan Roberts wrote:

Hi Ryan,

> On 07/11/2025 14:34, David Hildenbrand (Red Hat) wrote:
> >>>   #ifndef pte_batch_hint
> >>> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> >>> index 5d2a876035d6..c49b029d3593 100644
> >>> --- a/mm/kasan/shadow.c
> >>> +++ b/mm/kasan/shadow.c
> >>> @@ -305,7 +305,7 @@ static int kasan_populate_vmalloc_pte(pte_t *ptep,
> >>> unsigned long addr,
> >>>       pte_t pte;
> >>>       int index;
> >>>   -    arch_leave_lazy_mmu_mode();
> >>> +    lazy_mmu_mode_pause();
> >>
> >> I wonder if there really are use cases that *require* pause/resume? I think
> >> these kasan cases could be correctly implemented using a new nest level instead?
> >> Are there cases where the effects really need to be immediate or do the effects
> >> just need to be visible when you get to where the resume is?
> >>
> >> If the latter, that could just be turned into a nested disable (e.g. a flush).
> >> In this case, there is only 1 PTE write so no benefit, but I wonder if other
> >> cases may have more PTE writes that could then still be batched. It would be
> >> nice to simplify the API by removing pause/resume if we can?
> > 
> > It has clear semantics, clearer than some nest-disable IMHO.
> > 
> > Maybe you can elaborate how you would change ("simplify") the API in that
> > regard? What would the API look like?
> 
> By simplify, I just meant can we remove lazy_mmu_mode_pause() and
> lazy_mmu_mode_resume() ?
> 
> 
> We currently have:
> 
> apply_to_page_range
>   lazy_mmu_mode_enable()
>     kasan_populate_vmalloc_pte()
>       lazy_mmu_mode_pause()
>       <code>
>       lazy_mmu_mode_resume()
>   lazy_mmu_mode_disable()
> 
> Where <code> is setting ptes. But if <code> doesn't need the effects to be
> visible until lazy_mmu_mode_resume(), then you could replace the block with:
> 
> apply_to_page_range
>   lazy_mmu_mode_enable()
>     kasan_populate_vmalloc_pte()
>       lazy_mmu_mode_enable()
>       <code>
>       lazy_mmu_mode_disable()
>   lazy_mmu_mode_disable()
> 
> However, looking at this more closely, I'm not really clear on why we need *any*
> special attention to lazy mmu inside of kasan_populate_vmalloc_pte() and
> kasan_depopulate_vmalloc_pte().
> 
> I *think* that the original concern was that we were doing ptep_get(ptep) inside
> of a lazy_mmu block? So we need to flush so that the getter returns the most
> recent value? But given we have never written to that particular ptep while in
> the lazy mmu block, there is surely no hazard in the first place?

There is, please see:
https://lore.kernel.org/linux-mm/cover.1755528662.git.agordeev@linux.ibm.com/

> apply_to_existing_page_range() will only call kasan_depopulate_vmalloc_pte()
> once per pte, right? So given we read the ptep before writing it, there should
> be no hazard? If so we can remove pause/resume.

Unfortunately, we rather not, please see:
https://lore.kernel.org/linux-mm/d407a381-099b-4ec6-a20e-aeff4f3d750f@arm.com/

The problem is kasan code invokes apply_to_page_range(), which enters lazy_mmu
mode unconditionally. I would claim that is rather an obstacle for the kasan
code, not a benefit. But it needs to be tackled.

Should apply_to_page_range() had an option not to enter the lazy_mmu mode
(e.g. an extra "bool skip_lazy" parameter) - the pause/resume could have
been avoided.

> Thanks,
> Ryan

Thanks!

