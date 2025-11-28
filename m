Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6579D116F1
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 13:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5BD6B0026; Fri, 28 Nov 2025 08:51:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8D366B002E; Fri, 28 Nov 2025 08:51:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA3056B0031; Fri, 28 Nov 2025 08:51:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C87296B0026
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:51:43 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FB9713B0F4
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:51:43 +0000 (UTC)
X-FDA: 84160153686.12.EAEAC01
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf17.hostedemail.com (Postfix) with ESMTP id D48A84000B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:51:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=K2Z8tqMv;
	spf=pass (imf17.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764337901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r/OOpcVTp61iopdoqOEy4BlI0dubVkeEnLCmlQuTfcE=;
	b=k6+1DrKcC2n1rghjmRItTyiUJ6iQT9+S6Qnv+LFwb8MxA6Tehi/r4QcBNUohrPHuP3N+Pp
	Gj6RVArMgnj8oKFcWPfobrE54Vs4Im/aC/wzQf9ChZLY3Bm19c/C5TXhIxllaGSC1MK5HW
	wa76NB4+rBJBsioG1QNOD2lj5C7izyY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764337901; a=rsa-sha256;
	cv=none;
	b=ZP6W1g/lm6Q/s5slFxP3dKbOzdWJxF8c1A0CQJaP+I81oTzRggBfh2jiJqFhtWveYOjR/d
	H4KGILW+Bqq3lNsBUProPxb9SdaGmIhmRFeH4JJcbVGFWPzq4rUNZ8NPWc1Wg5YOWof7Za
	pZJ0yvX7MyHF8Km5Pfvz4k/+nC11NPk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=K2Z8tqMv;
	spf=pass (imf17.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AS7BFTe019581;
	Fri, 28 Nov 2025 13:50:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=r/OOpcVTp61iopdoqOEy4BlI0dubVk
	eEnLCmlQuTfcE=; b=K2Z8tqMvKnbK3NPoVnvwS9bUNU+eHd2oMYLOcbbh8yfK0y
	7w+kywfkKjNbOtVYyLHncZfrLhsUFlMKc8mckWWFo/7yDF7q2EC3680JCjr0BDdu
	8hdzQIFNvTY74oSwkge1FPDmDtQuS3N4eKeep50nCH91r64Ni41OGcShCtvxag/d
	oQJuOfiI8kQiaTqyu86HXCvB1Ut662QlIMQYNdLjG9yHF3w4NFq53bu3DX5W0wUK
	KJtTHVgf+JS2KOO3k4hBKyku54ovMUn0BQWEN4c+awe+REbEmOxOF0bVDID0fYMS
	c9lxbFvTLYJpmhyU8CyCMh3b6QO1RShuMgREVYig==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4uvpnby-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Nov 2025 13:50:52 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5ASDop3o022924;
	Fri, 28 Nov 2025 13:50:51 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4uvpnbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Nov 2025 13:50:51 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5ASBYANQ027466;
	Fri, 28 Nov 2025 13:50:50 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4anq4he397-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Nov 2025 13:50:50 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ASDokoI38601150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Nov 2025 13:50:46 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 99BE320043;
	Fri, 28 Nov 2025 13:50:46 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6BFF20040;
	Fri, 28 Nov 2025 13:50:45 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 28 Nov 2025 13:50:45 +0000 (GMT)
Date: Fri, 28 Nov 2025 14:50:44 +0100
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
        David Woodhouse <dwmw2@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
        Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org
Subject: Re: [PATCH v5 06/12] mm: introduce generic lazy_mmu helpers
Message-ID: <07ffb66d-1e74-4634-bccb-75575b3862af-agordeev@linux.ibm.com>
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <20251124132228.622678-7-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124132228.622678-7-kevin.brodsky@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfX2ersG0vbStz0
 FLn4GUMOcSxnVbRNPX+VoL6pG7B6q9UsQ2OZG5zNPsZ5dk6+yNddVfyFO4U0uqrKeTdCEHcr2b5
 l15HvPDcY0Lc38rVTn2il/GNHJ96Q2/VeOAUyp2DHD09YEDF7m+IZDZ8XPJoTE+UPvafWv7l/y8
 1iSrwrbuSmWXb5LS0zGud5cDdbkRbuFZ18eO9q7EkgPbpUJ9usgLbYsqxLyzPAxNnG34ofEs4sE
 ksZQxJ67fToJqX3beRWd6D9kF6kg/SXsAPhgRoMeI7l1sNXEZ6vrAx+o44xH+gY8A5Z2yuzyB8b
 roVSjE+o2OX6QR76JlqKTFjCl+HbnJOryGRQxe1hT3H5YzWY9YCpvkpeU7+0rpiOAm4Gk+k6POO
 kmT2iY3iue+TABUU+o6PMhW9NmP0hA==
X-Authority-Analysis: v=2.4 cv=PLoCOPqC c=1 sm=1 tr=0 ts=6929a8bc cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8 a=20KFwNOVAAAA:8 a=gOb4qOPT8CXnsm_EvbgA:9
 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-ORIG-GUID: QQCPW5TC082nb_eAVjuWkyWCtrkGV2VS
X-Proofpoint-GUID: qGdYAHc_0Xw3xrcj-QOfvU9MLghUc-FQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_03,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220021
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D48A84000B
X-Stat-Signature: zg3dx3du549aze5ay66guafimao9r99e
X-Rspam-User: 
X-HE-Tag: 1764337900-49853
X-HE-Meta: U2FsdGVkX1+rR4P2rK+77yPy8QuiIs4KhdX5/AjvDCspUO2GGbLTZwP7KZ1qNCn6wuz2usfALK0m8jmK4MzrHpKnxGdOqt+3vBMpCZQZU5cd/HWe7IyszW1IPj2xtf3tOIlkKA9VQZihpwL3iw8HA3BsQoSnoKnfp2hiOBkvzQGmffFjQB7W+HNFkSJsE+UNfzmRDkXnZTHA6eJQgeS9fOLkl4sjdh9qgNbGFPlE1H4ee+RI9sf5XuNH6phHNiRI+DZwKG57r71fTXT9YOPs+JGfQMTwOzhZbvJuwMZUpvmtNzhI7gYVhvA8rWvEUFyBSbfW71/Bdy140kAIxkNaTsQY5BRJKbiUTImOCCpm0wXCkIJZc4FKvuO5teyDiEgGt51lKQLsrfqCRKyQG5hUz0PemyyiKAR8z2LcTBge9IHuYpyMAove7/+mO8VDOSsyzi3PSrZw3BWvBKZs5/nzmGhcOnmAXOC4Llm3IC/GbTABWGaYz393ztsa1hgcBIpHFQOswH1deocs1fOTHOHg+zJHbSlJUWFRF0BecdcwgBWItPj5Kayub54I0LC2NArPM2LyvbqX/SzHF8gFU43vxWMzTJP54X3VbI0pc7mmz4PZRsoVgWLnU0/OSQKNEnVXMCeh5Q6i2q0wKMsMCXrs9QWp+cq6gC0uJPlItJIJmbUY/PJ72W7ewMnq9xvjTfmf1hpeQY927C1lgoHQ7aIh5G5ikDkDykTXyDOuYmwIIB28x6IVmk/9DiXyleabsUz/RwIxAQiG1ZSR6RE474cAtsKyw3Fq2Bx6yVe9+ajVC2O68gtHKi7afs1xq2x3ALt9L3a7dA1DTIQ6WqcndXoZrqhKmJCTRDdzY/O3INJWaAECShPNV2w547IGDmFasJvBXjrAADN6Ck8pVx4yWdXfPOvY2qW4zTnFMYL4Brys4r7J6MAT7dJ+blcuWN8v04zayKDv0NvEbrnW2i1arnG
 kHMx1pTs
 If9Rga/qf4RLc0m5m4ZUfYUzN88HWOK5hyW1510/fnga87Fg0pA3Qxbp2T1Ruo0Zh2Jjd/Wv+9pI/jSBWovVm6QMy1hpPVjKRHHBNrHW42gzc7VXE4MvmsofqQ5TbQWEkhCiZC0aXsFCW6oRvAazgnPwuptUnuZMkidLM2c//xElKBcmJwuMnw9/hGljvf7EfQZehu+LVzNEK3F4AvVaTTQx2/qGZuCfaevx2wv+ZaDC/e/Ud+1S76P6D599P+s4eC5V3eePRqzLGMi/uTMD0uAM3AfjtZRxLLClffN5JzT9uWcFwLT0lXWP6lJ9Q+mZWgFiFtj/WpqryjZnSA4KWFNMcC6rmQSVTpHDzdo0heakdypn2cjkTXLSFJJRFo4elS0QSkaeRsHzjJCfsHwSr3grL8B547Kl5VHinXe42C7XvacAxB8XgyKhef3YOrpgrjYzA3Hf38PcosF4qaL+K8yc0t1cBnvDH4WTTmvXB5ksBIC94nf5E3kB9X3w4JGZnj8qnBC7z1xlPSowif0keCmngJpXoqTuTi/N9KqTrXRLCdBVmTkeF+IaV0ih9Qiff5ztO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 01:22:22PM +0000, Kevin Brodsky wrote:
> The implementation of the lazy MMU mode is currently entirely
> arch-specific; core code directly calls arch helpers:
> arch_{enter,leave}_lazy_mmu_mode().
> 
> We are about to introduce support for nested lazy MMU sections.
> As things stand we'd have to duplicate that logic in every arch
> implementing lazy_mmu - adding to a fair amount of logic
> already duplicated across lazy_mmu implementations.
> 
> This patch therefore introduces a new generic layer that calls the
> existing arch_* helpers. Two pair of calls are introduced:
> 
> * lazy_mmu_mode_enable() ... lazy_mmu_mode_disable()
>     This is the standard case where the mode is enabled for a given
>     block of code by surrounding it with enable() and disable()
>     calls.
> 
> * lazy_mmu_mode_pause() ... lazy_mmu_mode_resume()
>     This is for situations where the mode is temporarily disabled
>     by first calling pause() and then resume() (e.g. to prevent any
>     batching from occurring in a critical section).
> 
> The documentation in <linux/pgtable.h> will be updated in a
> subsequent patch.
> 
> No functional change should be introduced at this stage.
> The implementation of enable()/resume() and disable()/pause() is
> currently identical, but nesting support will change that.
> 
> Most of the call sites have been updated using the following
> Coccinelle script:
> 
> @@
> @@
> {
> ...
> - arch_enter_lazy_mmu_mode();
> + lazy_mmu_mode_enable();
> ...
> - arch_leave_lazy_mmu_mode();
> + lazy_mmu_mode_disable();
> ...
> }
> 
> @@
> @@
> {
> ...
> - arch_leave_lazy_mmu_mode();
> + lazy_mmu_mode_pause();
> ...
> - arch_enter_lazy_mmu_mode();
> + lazy_mmu_mode_resume();
> ...
> }
> 
> A couple of notes regarding x86:
> 
> * Xen is currently the only case where explicit handling is required
>   for lazy MMU when context-switching. This is purely an
>   implementation detail and using the generic lazy_mmu_mode_*
>   functions would cause trouble when nesting support is introduced,
>   because the generic functions must be called from the current task.
>   For that reason we still use arch_leave() and arch_enter() there.
> 
> * x86 calls arch_flush_lazy_mmu_mode() unconditionally in a few
>   places, but only defines it if PARAVIRT_XXL is selected, and we
>   are removing the fallback in <linux/pgtable.h>. Add a new fallback
>   definition to <asm/pgtable.h> to keep things building.

Would it make sense to explicitly describe the policy wrt sleeping while
in lazy MMU mode? If I understand the conclusion of conversation right:

* An arch implementation may disable preemption, but then it is arch
  responsibility not to call any arch-specific code that might sleep;
* As result, while in lazy MMU mode the generic code should never
  call a code that might sleep;

1. https://lore.kernel.org/linux-mm/b52726c7-ea9c-4743-a68d-3eafce4e5c61@arm.com/

> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
...

